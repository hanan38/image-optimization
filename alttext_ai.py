#!/usr/bin/env python3
"""
AltText.ai API Integration Module

This module provides functions to generate alt text for images using the AltText.ai API.
Supports both synchronous and asynchronous processing with webhook callbacks.

Requirements:
    - AltText.ai API key (set in environment variable ALTTEXT_AI_API_KEY)
    - requests library
    - python-dotenv (for environment variable loading)

Usage:
    from alttext_ai import generate_alt_text
    
    alt_text = generate_alt_text("https://example.com/image.jpg")
    print(alt_text)
"""

import os
import time
import json
import requests
from typing import Optional, Dict, Any
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

class AltTextAI:
    """AltText.ai API client"""
    
    def __init__(self, api_key: Optional[str] = None):
        """
        Initialize AltText.ai client
        
        Args:
            api_key: AltText.ai API key. If not provided, will use ALTTEXT_AI_API_KEY env var
        """
        self.api_key = api_key or os.getenv('ALTTEXT_AI_API_KEY')
        if not self.api_key:
            raise ValueError("AltText.ai API key is required. Set ALTTEXT_AI_API_KEY environment variable.")
        
        self.base_url = "https://alttext.ai/api/v1"
        self.headers = {
            "X-API-Key": self.api_key,
            "Content-Type": "application/json"
        }
        
        # Optional settings from environment
        self.default_keywords = os.getenv('ALTTEXT_AI_KEYWORDS', '')
        self.webhook_url = os.getenv('ALTTEXT_AI_WEBHOOK_URL', '')
    
    def generate_alt_text(self, image_url: str, keywords: Optional[str] = None, 
                         use_webhook: bool = False, timeout: int = 30) -> Optional[str]:
        """
        Generate alt text for an image URL
        
        Args:
            image_url: URL of the image to process
            keywords: Optional keywords for SEO optimization
            use_webhook: Whether to use asynchronous webhook processing
            timeout: Request timeout in seconds
            
        Returns:
            Generated alt text string, or None if failed
        """
        try:
            # Prepare payload
            payload = {
                "image": {
                    "url": image_url
                }
            }
            
            # Add keywords if provided
            keywords_to_use = keywords or self.default_keywords
            if keywords_to_use:
                payload["keywords"] = keywords_to_use
            
            # Add webhook if specified
            if use_webhook and self.webhook_url:
                payload["webhook_url"] = self.webhook_url
            
            print(f"🔍 Generating alt text for: {image_url}")
            
            # Make API request
            response = requests.post(
                f"{self.base_url}/images",
                headers=self.headers,
                json=payload,
                timeout=timeout
            )
            
            # Handle response
            if response.status_code == 200:
                result = response.json()
                alt_text = result.get('alt_text', '')
                print(f"✅ Generated alt text: {alt_text}")
                return alt_text
            
            elif response.status_code == 202:
                # Asynchronous processing started
                result = response.json()
                job_id = result.get('job_id', '')
                print(f"🔄 Asynchronous processing started. Job ID: {job_id}")
                
                if not use_webhook:
                    # Poll for result
                    return self._poll_for_result(job_id, timeout)
                else:
                    print("📞 Webhook will be called when processing is complete")
                    return f"ASYNC_JOB:{job_id}"
            
            else:
                print(f"❌ API request failed with status {response.status_code}: {response.text}")
                return None
                
        except requests.exceptions.Timeout:
            print(f"⏰ Request timed out after {timeout} seconds")
            return None
        except requests.exceptions.RequestException as e:
            print(f"❌ Request failed: {e}")
            return None
        except Exception as e:
            print(f"❌ Unexpected error: {e}")
            return None
    
    def _poll_for_result(self, job_id: str, timeout: int = 30) -> Optional[str]:
        """
        Poll for asynchronous job result
        
        Args:
            job_id: Job ID returned from async request
            timeout: Maximum time to wait for completion
            
        Returns:
            Generated alt text or None if failed/timeout
        """
        start_time = time.time()
        poll_interval = 2  # Poll every 2 seconds
        
        print(f"⏳ Polling for job {job_id} completion...")
        
        while time.time() - start_time < timeout:
            try:
                response = requests.get(
                    f"{self.base_url}/jobs/{job_id}",
                    headers=self.headers,
                    timeout=10
                )
                
                if response.status_code == 200:
                    result = response.json()
                    status = result.get('status', '')
                    
                    if status == 'completed':
                        alt_text = result.get('alt_text', '')
                        print(f"✅ Job completed. Alt text: {alt_text}")
                        return alt_text
                    elif status == 'failed':
                        error = result.get('error', 'Unknown error')
                        print(f"❌ Job failed: {error}")
                        return None
                    else:
                        print(f"⏳ Job status: {status}")
                
                time.sleep(poll_interval)
                
            except Exception as e:
                print(f"❌ Error polling job status: {e}")
                break
        
        print(f"⏰ Job polling timed out after {timeout} seconds")
        return None
    
    def get_job_status(self, job_id: str) -> Optional[Dict[str, Any]]:
        """
        Get status of an asynchronous job
        
        Args:
            job_id: Job ID to check
            
        Returns:
            Job status dictionary or None if failed
        """
        try:
            response = requests.get(
                f"{self.base_url}/jobs/{job_id}",
                headers=self.headers,
                timeout=10
            )
            
            if response.status_code == 200:
                return response.json()
            else:
                print(f"❌ Failed to get job status: {response.status_code}")
                return None
                
        except Exception as e:
            print(f"❌ Error getting job status: {e}")
            return None
    
    def test_connection(self) -> bool:
        """
        Test if the API key is valid and the service is accessible
        
        Returns:
            True if connection is successful, False otherwise
        """
        try:
            # Instead of using a test image, just check if we can make a basic API call
            # by trying to get job status for a non-existent job (which should return 404 but proves API is accessible)
            response = requests.get(
                f"{self.base_url}/jobs/test-connection-check",
                headers=self.headers,
                timeout=10
            )
            
            # Any response (even 404) means the API is accessible and our key is valid
            # Invalid API keys would return 401/403
            if response.status_code in [200, 202, 404]:
                print("✅ AltText.ai API connection successful")
                return True
            elif response.status_code in [401, 403]:
                print(f"❌ API authentication failed with status {response.status_code}")
                return False
            else:
                print(f"❌ API test failed with status {response.status_code}")
                return False
                
        except Exception as e:
            print(f"❌ API connection test failed: {e}")
            return False


# Convenience functions for backward compatibility
def generate_alt_text(image_url: str, keywords: Optional[str] = None, 
                     api_key: Optional[str] = None) -> Optional[str]:
    """
    Generate alt text for an image URL (convenience function)
    
    Args:
        image_url: URL of the image to process
        keywords: Optional keywords for SEO optimization
        api_key: Optional API key (uses env var if not provided)
        
    Returns:
        Generated alt text string, or None if failed
    """
    try:
        client = AltTextAI(api_key)
        return client.generate_alt_text(image_url, keywords)
    except Exception as e:
        print(f"❌ Failed to generate alt text: {e}")
        return None


def test_alttext_ai_connection(api_key: Optional[str] = None) -> bool:
    """
    Test AltText.ai API connection (convenience function)
    
    Args:
        api_key: Optional API key (uses env var if not provided)
        
    Returns:
        True if connection is successful, False otherwise
    """
    try:
        client = AltTextAI(api_key)
        return client.test_connection()
    except Exception as e:
        print(f"❌ Connection test failed: {e}")
        return False


if __name__ == "__main__":
    # Simple CLI test
    import sys
    
    if len(sys.argv) > 1:
        image_url = sys.argv[1]
        keywords = sys.argv[2] if len(sys.argv) > 2 else None
        
        print(f"Testing AltText.ai with image: {image_url}")
        alt_text = generate_alt_text(image_url, keywords)
        
        if alt_text:
            print(f"Result: {alt_text}")
        else:
            print("Failed to generate alt text")
    else:
        print("Usage: python alttext_ai.py <image_url> [keywords]")
        
        # Test connection
        if test_alttext_ai_connection():
            print("API connection is working!")
        else:
            print("API connection failed. Check your API key.") 
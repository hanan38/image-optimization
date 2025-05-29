#!/usr/bin/env python3
"""
S3 Bucket Analysis Tool

This utility helps debug S3 bucket configuration and object access issues.
It provides insights into bucket policies, public access settings, and object permissions.

Usage:
    python check_s3_objects.py

Features:
    - Check bucket policy and public access block settings
    - List recent objects in the bucket
    - Test object existence and accessibility
    - Analyze object ACL permissions
"""

import json
import os

import boto3
from botocore.exceptions import ClientError
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configuration
AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_KEY")
S3_BUCKET = os.getenv("S3_BUCKET")

# Initialize S3 client
s3_client = boto3.client(
    "s3", aws_access_key_id=AWS_ACCESS_KEY, aws_secret_access_key=AWS_SECRET_KEY
)


def check_bucket_policy():
    """Check the bucket policy"""
    try:
        response = s3_client.get_bucket_policy(Bucket=S3_BUCKET)
        policy = json.loads(response["Policy"])
        print("Bucket Policy:")
        print(json.dumps(policy, indent=2))
        return policy
    except ClientError as e:
        if e.response["Error"]["Code"] == "NoSuchBucketPolicy":
            print("No bucket policy found")
            return None
        else:
            print(f"Error getting bucket policy: {e}")
            return None


def check_bucket_public_access_block():
    """Check the bucket's public access block settings"""
    try:
        response = s3_client.get_public_access_block(Bucket=S3_BUCKET)
        pab = response["PublicAccessBlockConfiguration"]
        print("Public Access Block Configuration:")
        print(f"  BlockPublicAcls: {pab.get('BlockPublicAcls', 'Not set')}")
        print(f"  IgnorePublicAcls: {pab.get('IgnorePublicAcls', 'Not set')}")
        print(f"  BlockPublicPolicy: {pab.get('BlockPublicPolicy', 'Not set')}")
        print(f"  RestrictPublicBuckets: {pab.get('RestrictPublicBuckets', 'Not set')}")
        return pab
    except ClientError as e:
        print(f"Error getting public access block: {e}")
        return None


def list_recent_objects():
    """List recent objects in the bucket"""
    try:
        response = s3_client.list_objects_v2(Bucket=S3_BUCKET, MaxKeys=10)

        if "Contents" in response:
            print("\nRecent objects in bucket:")
            for obj in response["Contents"][:10]:
                print(
                    f"  {obj['Key']} (Size: {obj['Size']} bytes, Modified: {obj['LastModified']})"
                )
        else:
            print("No objects found in bucket")

    except ClientError as e:
        print(f"Error listing objects: {e}")


def check_object_acl(object_key):
    """Check ACL for a specific object"""
    try:
        response = s3_client.get_object_acl(Bucket=S3_BUCKET, Key=object_key)
        print(f"\nACL for {object_key}:")
        for grant in response["Grants"]:
            grantee = grant["Grantee"]
            permission = grant["Permission"]

            if grantee["Type"] == "Group":
                print(f"  {grantee['URI']}: {permission}")
            elif grantee["Type"] == "CanonicalUser":
                print(f"  User {grantee.get('DisplayName', 'Unknown')}: {permission}")

    except ClientError as e:
        print(f"Error getting object ACL for {object_key}: {e}")


def test_object_exists(object_key):
    """Test if an object exists and is accessible"""
    try:
        response = s3_client.head_object(Bucket=S3_BUCKET, Key=object_key)
        print(f"\nObject {object_key} exists:")
        print(f"  Size: {response['ContentLength']} bytes")
        print(f"  Content-Type: {response['ContentType']}")
        print(f"  Last Modified: {response['LastModified']}")
        return True
    except ClientError as e:
        if e.response["Error"]["Code"] == "404":
            print(f"\nObject {object_key} does not exist")
        else:
            print(f"Error accessing object {object_key}: {e}")
        return False


if __name__ == "__main__":
    print("S3 Bucket Analysis")
    print("=" * 50)

    # Check bucket policy
    check_bucket_policy()
    print()

    # Check public access block
    check_bucket_public_access_block()
    print()

    # List recent objects
    list_recent_objects()

    # Test specific objects from our mapping
    test_objects = [
        "Car_shipping_from_Brandon_Florida_to_anywhere_in_the_US.webp",
        "farmers-dog-970x550.webp",  # This one was working
    ]

    for obj_key in test_objects:
        if test_object_exists(obj_key):
            check_object_acl(obj_key)

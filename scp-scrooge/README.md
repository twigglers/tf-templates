# Reducing Policy Characters in SCP

## Summary
The following example demonstrates how to reduce bytes in an SCP when using the aws_iam_policy_document data source. This is particular useful if policies are violating the maximum policy size (5,120 bytes) - POLICY_CONTENT_LIMIT_EXCEEDED.

## Details
As the AWS Organizations API for [CreatePolicy](https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreatePolicy.html) and [UpdatePolicy](https://docs.aws.amazon.com/organizations/latest/APIReference/API_UpdatePolicy.html) accept a string for the policy content, additional white spaces introduced by the aws_iam_policy_document data source can be removed with a simple replace(). References:


From Cloudtrail:
1. Without the replace function to remove whitespaces:

    ```
    content = data.aws_iam_policy_document.whitelisting_services.json
    ```

    CloudTrail shows:
    ```
    {
        ...
        "eventSource": "organizations.amazonaws.com",
        "eventName": "CreatePolicy",
        "awsRegion": "us-east-1",
        "requestParameters": {
            "tags": [],
            "name": "example",
            "description": "",
            "type": "SERVICE_CONTROL_POLICY",
            "content": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"AllowedServices\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"s3:*\",\n        \"iam:*\",\n        \"ec2:*\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}"
        },
        "responseElements": {
            "policy": {
                "policySummary": { ... },
                "content": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"AllowedServices\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"s3:*\",\n        \"iam:*\",\n        \"ec2:*\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}"
            }
        },
        ...
    }
    ```

2. With the replace function to remove whitespaces i.e.

    ```
    content = replace(data.aws_iam_policy_document.whitelisting_services.json, " ", "")
    ```

    CloudTrail shows:
    ```
    {
        ...
        "eventSource": "organizations.amazonaws.com",
        "eventName": "CreatePolicy",
        "awsRegion": "us-east-1",
        "requestParameters": {
            "tags": [],
            "name": "example",
            "description": "",
            "type": "SERVICE_CONTROL_POLICY",
            "content": "{\n\"Version\":\"2012-10-17\",\n\"Statement\":[\n{\n\"Sid\":\"AllowedServices\",\n\"Effect\":\"Allow\",\n\"Action\":[\n\"s3:*\",\n\"iam:*\",\n\"ec2:*\"\n],\n\"Resource\":\"*\"\n}\n]\n}",
        },
        "responseElements": {
            "policy": {
                "policySummary": { ... },
                "content": "{\n\"Version\":\"2012-10-17\",\n\"Statement\":[\n{\n\"Sid\":\"AllowedServices\",\n\"Effect\":\"Allow\",\n\"Action\":[\n\"s3:*\",\n\"iam:*\",\n\"ec2:*\"\n],\n\"Resource\":\"*\"\n}\n]\n}",
            }
        },
        ...
    }
    ```
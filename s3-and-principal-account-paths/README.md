# Granting access to a centralised bucket to organisational paths

## Summary
The following example demonstrates to leverage the context key aws:PrincipalAccount in a bucket policy to lockdown paths in the bucket that member accounts in an AWS Organization can access. This is help for providing files out member accounts that are unique and contextual such as metadata (generated centrally) that should be consumed only by that account.

## Details
In the example, the following are two member accounts of the AWS Organization with ID "o-yyyyyyyyyy":
* 123456789012
* 210987654321

By using the context key aws:PrincipalAccount:
* only IAM principals within account 123456789012 can access 123456789012/test.txt
* only IAM principals within account 210987654321 can access 210987654321/test.txt

Note: the IAM principals (users or roles) must have corresponding permissions to access the cross-account bucket.
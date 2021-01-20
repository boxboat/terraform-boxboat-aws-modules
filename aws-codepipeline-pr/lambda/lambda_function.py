import datetime
import re
import boto3
codebuild_client = boto3.client('codebuild')

def lambda_handler(event, context):

  if event['detail']['referenceType'] in ['branch'] and re.match("feature\/|bug\/", event['detail']['referenceName']):
    branch_refs = event['detail']['referenceFullName']

    codebuild_client.start_build(projectName='${build_name}', sourceVersion=branch_refs)
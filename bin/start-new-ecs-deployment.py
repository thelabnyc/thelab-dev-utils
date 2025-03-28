#!/usr/bin/env python3
"""
This script requires that the Gitlab CI user has the following AWS IAM
permissions (for the relevant resources):

- ecs:UpdateService (for the service specific by the `service_name` arg)

"""

import boto3
import argparse

parser = argparse.ArgumentParser(description="Start a new deployment of an ECS service")
parser.add_argument("region", help="AWS region name")
parser.add_argument("cluster_name", help="ECS cluster name")
parser.add_argument("service_name", help="ECS service name")

args = parser.parse_args()

ecs_client = boto3.client("ecs", region_name=args.region)
response = ecs_client.update_service(
    cluster=args.cluster_name,
    service=args.service_name,
    forceNewDeployment=True,
)

print(response)

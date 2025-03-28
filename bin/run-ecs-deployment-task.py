#!/usr/bin/env python3
"""
This script requires that the Gitlab CI user has the following AWS IAM
permissions (for the relevant resources):

- ecs:DescribeServices (for the service specific by the `service_name` arg)
- ecs:RunTask
- iam:PassRole (for the task's configured IAM execution role)
"""

import boto3
import argparse
import json

parser = argparse.ArgumentParser(description="Start a new deployment of an ECS service")
parser.add_argument("region", help="AWS region name")
parser.add_argument("cluster_name", help="ECS cluster name")
parser.add_argument("service_name", help="ECS service name")
parser.add_argument("container_name", help="Container name within ECS task")
parser.add_argument("command", help="Container command to run encoded as a JSON array")
parser.add_argument("--cpu", type=int, help="CPU allocation override")
parser.add_argument("--memory", type=int, help="Memory allocation override")

args = parser.parse_args()

ecs_client = boto3.client("ecs", region_name=args.region)

# Describe the service to get the metadata we need to start a new task
services_resp = ecs_client.describe_services(
    cluster=args.cluster_name,
    services=[args.service_name],
)
service = services_resp["services"][0]

# Build task kwargs
overrides = {}
if args.cpu:
    overrides["cpu"] = str(args.cpu)
if args.memory:
    overrides["memory"] = str(args.memory)

# Start the deployment task
runtask_resp = ecs_client.run_task(
    cluster=args.cluster_name,
    taskDefinition=service["taskDefinition"],
    networkConfiguration=service["networkConfiguration"],
    overrides=dict(
        containerOverrides=[
            {
                "name": args.container_name,
                "command": json.loads(args.command),
            }
        ],
        **overrides,
    ),
    startedBy="gitlab-ci-ops-utils",
)
print("Full run_task response (for debugging):")
print(runtask_resp)
print("\n")

task = runtask_resp["tasks"][0]
task_arn = task["taskArn"]
task_id = task_arn.split("/")[-1]

print(f"Started task: {task_arn}")
print("To view logs for this task, use the command below:")
print("")
print(f"ecs-cli configure --region {args.region} --cluster {args.cluster_name}")
print(f"ecs-cli logs --task-id {task_id} --follow")
print("")
print("Or you can view the task via the AWS Console:")
print("")
print(
    f"https://{args.region}.console.aws.amazon.com/ecs/home?region={args.region}#/clusters/{args.cluster_name}/tasks/{task_id}/details"
)

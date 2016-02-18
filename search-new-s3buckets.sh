#!/bin/bash

# list all existing S3 buckets sorted from older to newer

aws s3 ls |sort

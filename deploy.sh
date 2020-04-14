#! /usr/bin/env bash
export AWS_PROFILE=$1
terraform init
terraform apply -auto-approve -var fp_context=$1 -var domain=$2
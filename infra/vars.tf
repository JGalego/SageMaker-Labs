// vars.tf

# For more information, please visit:
# https://docs.aws.amazon.com/sagemaker/latest/dg/regions-quotas.html
# https://aws.amazon.com/about-aws/global-infrastructure/regions_az/
variable "region" {
  type        = string
  description = "The [AWS Region](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/) that will host the labs"
  default     = "us-east-1"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name."
  }

  validation {
    condition     = var.region != "ap-northeast-3"
    error_message = <<EOM
As of November 2022, the following SageMaker features aren't available in the Asia Pacific (Osaka) Region:

    Amazon SageMaker Autopilot
    Clarify
    SageMaker Edge Manager
    Ground Truth
    Amazon SageMaker Inference Recommender
    Amazon SageMaker Model Monitor
    Reinforcement learning
    RStudio on Amazon SageMaker

For more information, please visit:
https://docs.aws.amazon.com/sagemaker/latest/dg/regions-quotas.html
EOM
  }

  validation {
    condition     = !startswith(var.region, "us-gov-")
    error_message = "Amazon SageMaker Pipelines is available in all the AWS Regions supported by AWS except the AWS GovCloud (US) Regions."
  }
}

variable "project" {
  type        = string
  description = "The name of the project"
  default     = "smlabs"

  validation {
    condition     = can(regex("([0-9A-Za-z])", var.project))
    error_message = "For the project name, only a-z, A-Z and 0-9 are allowed."
  }

  validation {
    condition     = length(var.project) >= 3
    error_message = "Project name should be at least 3 characters long."
  }
}

variable "owner" {
  type        = string
  description = "The owner of the project"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
  default     = "dev"
  validation {
    condition = contains([
      "dev",
      "test",
      "stage",
      "prod"
    ], var.environment)
    error_message = "Invalid environment name - Expected: [dev, test, stage, prod]."
  }
}

# For more information, see
# https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-images.html
# https://docs.aws.amazon.com/sagemaker/latest/dg/studio-jl.html
variable "sm_app_image_name" {
  type        = string
  description = "ARN of the Amazon SageMaker image that will be used"
  default     = "datascience-1.0"
}

# For more information, see
# https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
variable "sm_app_instance_type" {
  type        = string
  description = "The instance type that the image runs on"
  default     = "ml.t3.medium"

  validation {
    condition     = startswith(var.sm_app_instance_type, "ml.")
    error_message = "SageMaker Studio Instance Types must start with \"ml.\"."
  }
}

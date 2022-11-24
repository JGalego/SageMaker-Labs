/*
* # Amazon SageMaker Labs 🧠 (Infrastructure)
* 
* ## Overview
* 
* [Terraform](https://www.terraform.io/) configuration for managing the required infrastructure for the labs.
* 
* ## Setup
*
* 0. Add an [S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) configuration file (`config.s3.tfbackend`) if one is not provided.
*
* > **Note:** The backend configuration **must** include values for `region`, `bucket` and `key`
*
* 1. Initialize working directory
* 
* 	```bash
* 	cd infra
* 	terraform init -upgrade -backend-config="config.s3.tfbackend"
* 	```
* 
* 2. Create execution plan
* 
* 	```bash
* 	terraform plan
* 	```
* 
* 3. Provision infrastructure
* 
* 	```bash
* 	terraform apply
* 	```
*/

terraform {
  # Specifies which versions of Terraform can be used w/ this configuration
  required_version = ">= 1.3.5"

  required_providers {
    # Terraform provider for AWS
    # https://github.com/hashicorp/terraform-provider-aws
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.40.0"
    }

    # Use this provider to run commands locally and store the results
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.3"
    }

    # Use this provider to generate random IDs and avoid naming collision
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }

  backend "s3" {
    # Uses a partial configuration
    # https://www.terraform.io/language/settings/backends/configuration#partial-configuration
    # to define an S3 backend w/ state locking and consistency checking via DynamoDB
    # https://www.terraform.io/language/settings/backends/s3
  }
}

provider "aws" {
  region = var.region

  # These tags will be inherited by all resources that support tags
  # https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider
  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      Owner       = var.owner
    }
  }
}

/* Generic */

// Get user and account information
data "aws_caller_identity" "current" {}

// Just a random number that'll be used to avoid naming collisions
resource "random_id" "smlabs" {
  byte_length = 8
}

/* SageMaker Studio Domain */

// For demo purposes *only*, we'll be using the default VPC and its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.default.id
    ]
  }
}

// These AWS managed policies add permissions to use built-in Amazon SageMaker project templates and JumpStart solutions
// See https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam-awsmanpol-sc.html
data "aws_iam_roles" "sagemaker_service_catalog" {
  name_regex = ".*AmazonSageMakerServiceCatalog.*"
}

// Let's create a dedicated execution role for SageMaker users
resource "aws_iam_role" "sagemaker_execution" {
  name = "${var.project}-${random_id.smlabs.dec}-sagemaker-execution-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "sagemaker.amazonaws.com"
          ]
        }
      },
    ]
  })
}

// Grants *administrative* permissions that allow a principal full access to all Amazon SageMaker resources and operations
// See https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam-awsmanpol.html
data "aws_iam_policy" "sagemaker_full_access" {
  name = "AmazonSageMakerFullAccess"
}

// Gives user permissions to perform time series forecasting
// See https://docs.aws.amazon.com/sagemaker/latest/dg/canvas-set-up-forecast.html
data "aws_iam_policy" "sagemaker_canvas_forecast_access" {
  name = "AmazonSageMakerCanvasForecastAccess"
}

// Attach policies to the execution role
resource "aws_iam_role_policy_attachment" "sagemaker_full_access_attach" {
  role       = aws_iam_role.sagemaker_execution.name
  policy_arn = data.aws_iam_policy.sagemaker_full_access.arn
}

resource "aws_iam_role_policy_attachment" "sagemaker_canvas_forecast_access" {
  role       = aws_iam_role.sagemaker_execution.name
  policy_arn = data.aws_iam_policy.sagemaker_full_access.arn
}

// Finally, we can create the domain
// See https://docs.aws.amazon.com/sagemaker/latest/dg/studio-entity-status.html
resource "aws_sagemaker_domain" "smlabs" {
  // What we'll call the domain
  domain_name = "${var.project}-${random_id.smlabs.dec}-domain"

  // The mode of authentication that members will use to access the domain (either IAM or SSO)
  auth_mode = "IAM"

  // The VPC and subnets that Studio will use for communication
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_execution.arn

    canvas_app_settings {
      time_series_forecasting_settings {
        status = "ENABLED"

        // By default, Canvas uses the execution role specified in the UserProfile that launches the Canvas app. 
        // If an execution role is not specified in the UserProfile, Canvas uses the execution role specified in the Domain that owns the UserProfile.
      }
    }

    // We'll leave everything else as default
  }
}

// Add a user to our domain

resource "aws_sagemaker_user_profile" "owner" {
  domain_id         = aws_sagemaker_domain.smlabs.id
  user_profile_name = var.owner
  user_settings {
    execution_role = aws_iam_role.sagemaker_execution.arn
  }
}

// Enable access to SageMaker Projects and JumpStart
// See https://aws.amazon.com/blogs/machine-learning/enable-amazon-sagemaker-jumpstart-for-custom-iam-execution-roles/

resource "aws_sagemaker_servicecatalog_portfolio_status" "smlabs" {
  status = "Enabled"
}

data "external" "service_catalog_portfolio_info" {
  program = [
    "sh", "-c", "./get_portfolio_id.sh"
  ]

  depends_on = [
    aws_sagemaker_servicecatalog_portfolio_status.smlabs
  ]
}

resource "aws_servicecatalog_principal_portfolio_association" "owner" {
  portfolio_id  = data.external.service_catalog_portfolio_info.result["Id"]
  principal_arn = aws_iam_role.sagemaker_execution.arn
}

// Let's add some SageMaker apps...

// The Amazon SageMaker Studio interface (based on JupyterLab)
resource "aws_sagemaker_app" "jupyter_server" {
  domain_id         = aws_sagemaker_domain.smlabs.id
  user_profile_name = aws_sagemaker_user_profile.owner.user_profile_name
  app_name          = "default"
  app_type          = "JupyterServer"
}

// The KernelGateway app corresponds to a running SageMaker image container.
// Each user can have multiple KernelGateway apps running at a time in a single Studio domain.
resource "aws_sagemaker_app" "kernel_gateway" {
  domain_id         = aws_sagemaker_domain.smlabs.id
  user_profile_name = aws_sagemaker_user_profile.owner.user_profile_name
  app_name          = "${replace(var.sm_app_image_name, ".", "-")}-${replace(var.sm_app_instance_type, ".", "-")}-${random_id.smlabs.dec}"
  app_type          = "KernelGateway"

  resource_spec {
    instance_type       = var.sm_app_instance_type
    sagemaker_image_arn = "arn:aws:sagemaker:${var.region}:${local.sagemaker_account_ids[var.region]}:image/${var.sm_app_image_name}"
  }
}

// Development Note: When facing persistent state errors like
// https://github.com/hashicorp/terraform-provider-aws/issues/27265
// just remove the app resource from the Terraform state by running
// terraform state rm aws_sagemaker_app.<APP_NAME>

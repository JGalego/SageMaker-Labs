// output.tf

output "sm_domain_url" {
  description = "The SageMaker domain URL"
  value       = aws_sagemaker_domain.smlabs.url
}
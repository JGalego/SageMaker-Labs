#!/bin/bash

# Get accepteed portfolio shares belonging to Amazon SageMaker
aws servicecatalog list-accepted-portfolio-shares | jq -r " .PortfolioDetails[] | select(.ProviderName == \"Amazon SageMaker\")"
# Amazon SageMaker Labs 🧠

## Overview

> 🚧 **Caution:** this project is under construction!

An (open) set of curated labs that demonstrate **every** nook and cranny ⚙️ of [Amazon SageMaker](https://aws.amazon.com/sagemaker/):

* How it supports **all** stages of the ML pipeline - from data collection and labeling to model deployment... and back ♾️
* How it automates the entire workflow - welllll, almost... 👀 looking at you [Amazon Augmented AI](https://aws.amazon.com/augmented-ai/) - and last but *certainly* not least
* How to optimize everything for cost 💰

Ready to master the mystic art of moving ML-powered apps to production? 🧙

<img src="https://media.tenor.com/jNGGYr4g4xAAAAAM/benedict-cumberbatch-dr-strange.gif"/>

## Getting Started

0. [Provision infrastructure](infra/README.md) (*optional*)
1. Open [SageMaker Studio](https://docs.aws.amazon.com/sagemaker/latest/dg/studio.html)
2. Clone this repository
3. Open [A Tour of SageMaker](sagemaker_tour.ipynb)
4. Enjoy! 😉

## FAQ

> **Which one is better - SageMaker Studio or Notebook Instances?**

In general, SageMaker Studio is a better option.

Starting a Studio Notebook is faster (5-10x) than launching an instance-based notebook.

Furthermore, Notebook sharing is much easier within SageMaker Studio. 

One caveat though is that Studio Notebooks don't support [`local` mode](https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines-local-mode.html).

For a deeper dive into the differences between these two options, check out [Machine Learning Environments > SageMaker Studio > Use Studio Notebooks > How Are Amazon SageMaker Studio Notebooks Different from Notebook Instances?](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-comparison.html).

## References

### Tutorials

* [Build, Train, and Deploy a Machine Learning Model with Amazon SageMaker](https://aws.amazon.com/getting-started/hands-on/build-train-deploy-machine-learning-model-sagemaker/)
* [Train and tune a deep learning model at scale](https://aws.amazon.com/getting-started/hands-on/train-tune-deep-learning-model-amazon-sagemaker/)

### Learning

* [Amazon SageMaker Technical Deep Dive Series](https://www.youtube.com/playlist?list=PLhr1KZpdzukcOr_6j_zmSrvYnLUtgqsZz)
* [Dive into Deep Learning](https://www.d2l.ai/) – an interactive, notebook-shaped DL book

### Guides

* [Deploy a Model in Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/how-it-works-deployment.html)
* [Use Amazon SageMaker Built-in Algorithms or Pre-trained Models](https://docs.aws.amazon.com/sagemaker/latest/dg/algos.html)
* [Buy and Sell Amazon SageMaker Algorithms and Models in AWS Marketplace](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-marketplace.html)
* [Using SageMaker JumpStart Models](https://docs.aws.amazon.com/sagemaker/latest/dg/jumpstart-models.html)
* [Using Your Own Algorithm or Model](https://docs.aws.amazon.com/sagemaker/latest/dg/docker-containers-notebooks.html)
* [Using Amazon Augmented AI for Human Review](https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-use-augmented-ai-a2i-human-review-loops.html)

### Code

* [AWSome SageMaker](https://github.com/aws-samples/awesome-sagemaker) – a curated list of references for Amazon SageMaker
* [Amazon SageMaker Examples](https://github.com/aws/amazon-sagemaker-examples) – these are automatically available when using SageMaker Notebook Instances
* [Hugging Face Notebooks > SageMaker](https://github.com/huggingface/notebooks/tree/main/sagemaker) – sample notebooks that demonstrate how to build, train and deploy [🤗 Transformers](https://github.com/huggingface/transformers) with Amazon SageMaker
* [Amazon Augmented AI Sample Notebooks](https://github.com/aws-samples/amazon-a2i-sample-jupyter-notebooks)
* [Optimizing NLP models with Amazon EC2 `Inf1` instances in Amazon SageMaker](https://github.com/aws-samples/aws-inferentia-huggingface-workshop)

### Infrastructure

* [AWS ML Infrastructure](https://aws.amazon.com/machine-learning/infrastructure/) – an overview of the different services that support ML-specific workloads
* [How to choose the right GPU for DL](https://towardsdatascience.com/choosing-the-right-gpu-for-deep-learning-on-aws-d69c157d8c86) – a must read
* HW accelerators - [AWS Trainium / `Trn1` Instances](https://aws.amazon.com/machine-learning/trainium/) and [Habana Gaudi / `DL1` Instances](https://aws.amazon.com/ec2/instance-types/dl1/) for training, [AWS Inferentia / `Inf1` Instances](https://aws.amazon.com/machine-learning/inferentia/) for inference, and even [FPGAs / `F1` Instances](https://aws.amazon.com/ec2/instance-types/f1/)

### Blogs

* [Deploying ML models using SageMaker Serverless Inference (Preview)](https://aws.amazon.com/blogs/machine-learning/deploying-ml-models-using-sagemaker-serverless-inference-preview/)
* [Host Hugging Face transformer models using Amazon SageMaker Serverless Inference](https://aws.amazon.com/blogs/machine-learning/host-hugging-face-transformer-models-using-amazon-sagemaker-serverless-inference/)
* [Introducing the Amazon SageMaker Serverless Inference Benchmarking Toolkit](https://aws.amazon.com/blogs/machine-learning/introducing-the-amazon-sagemaker-serverless-inference-benchmarking-toolkit/)
* [Bring your own model with Amazon SageMaker script mode](https://aws.amazon.com/blogs/machine-learning/bring-your-own-model-with-amazon-sagemaker-script-mode/)
* [Speed up YOLOv4 inference to twice as fast on Amazon SageMaker](https://aws.amazon.com/blogs/machine-learning/speed-up-yolov4-inference-to-twice-as-fast-on-amazon-sagemaker/)
* [Accelerate BERT inference with Hugging Face Transformers and AWS Inferentia](https://huggingface.co/blog/bert-inferentia-sagemaker)
* [Build custom Amazon SageMaker PyTorch models for real-time handwriting text recognition](https://aws.amazon.com/blogs/machine-learning/build-custom-amazon-sagemaker-pytorch-models-for-real-time-handwriting-text-recognition/)
* [Julien Simon’s substack](https://substack.com/profile/100614256-julien-simon) – Chief Evangelist @ 🤗, former Global Technical Evangelist (AI/ML) @ AWS

### Frameworks

* [TensorFlow on AWS](https://aws.amazon.com/tensorflow/)
* [PyTorch on AWS](https://aws.amazon.com/pytorch/)
* [Hugging Face on Amazon SageMaker](https://aws.amazon.com/machine-learning/hugging-face/) (and [Amazon SageMaker on Hugging Face](https://huggingface.co/docs/sagemaker/index))
* … and [many more](https://docs.aws.amazon.com/sagemaker/latest/dg/frameworks.html)

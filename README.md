Terraform Hands-on Workshop
===========================

> full-day training to learn Terraform on AWS, and through GitHub Actions


Question this training will answer
----------------------------------

- What is Terraform?
- How do I use it?
- How is it better / different than similar tools?
- How do I use Terraform modules?
- How do I run Terraform in a DevOps pipeline?
- Where can I go for help?


Curriculum
----------

The workshop is broken into 7 chapters:

0. Machine Setup:  Get everything installed and ready before you arrive.

1. Introduction to Infrastructure as Code and Terraform:  This is an instructor-led section where we assume no prior Terraform knowledge.

2. Apps:  Build the apps we'll deploy into AWS.

3. Click-Ops:  Build some cloud resources by clicking through the AWS website.

4. Terraform with AWS:  Build the same cloud resources using AWS Terraform modules.

5. Terraform Modules:  Swap some Terraform resources with modules and compare & contrast their usefulness.

6. DevOps Pipeline:  Run the app build steps and the Terraform commands in GitHub Actions.

7. Discussion:  What surprised you?  Where can you go from here?  Here's some best practices and resources.


Prerequisites
-------------

- This course assumes no prior knowledge of terraform, or infrastructure-as-code.

- We assume you have a basic understanding of `VS Code`, `Terminal/Bash` and `Cloud Infrastructure`.

- You need to install some software.  Head to [Machine Setup Instructions](/00-Machine-Setup/README.md) to get everything in place.


Architecture Diagram
--------------------

In this class we'll build the following application:

![Workshop Architecture](./architecture.svg)

This sample includes:

- A DynamoDB data store
- A Lambda that reads the data
- An API Gateway in front of the Lambda
- A Fargate / Elastic Container Service (ECS) setup to run containers
- An ALB (Application Load Balancer) in front of the containers

**Our Goal:** is to automate this through Configuration-as-Code using Terraform and a DevOps pipeline in Azure DevOps.


License
-------

MIT, Copyright Richardson & Sons, LLC

Acronyms and Definitions
=========================

- **Repo**: (Short for Repository)  GitHub Repository containing application source code, DevOps pipelines, and other resources

- **Artifact**: Build output saved as results of a build.  These can include built application assets, Docker containers, Terraform output json, and other resources.

- **Artifactory**: [JFrog Artifactory](https://jfrog.com/artifactory/) is a cloud-hosted place to store build artifacts such as NuGet packages, NPM modules, and Docker images.

- **DevOps**: A methodology of combining Developer and Operations personnel to ease communication between teams.

- **DevSecOps**: A methodology of including InfoSec skills and teams into the DevOps process.

- **Pipeline** or **DevOps Pipeline** or **CI/CD**: A DevOps build that does various build and deploy steps to automate software validation.  Typically this includes steps defined in a YAML file committed into the repository.

- **CI**: The Continuous Integration step in a DevOps pipeline.  This builds and tests the latest version of the code.

- **CD**: The Continuous Deployment step in a DevOps pipeline.  This deploys the latest version of the software to production or non-production servers and/or cloud infrastructure.

- **Service Connection**: In the DevOps pipeline, define a secure connection to another resource such as a cloud repository or deployment environment.  The Service Connection removes the need to store credentials in the build pipeline.


AWS
---

- **ECR**: Amazon [Elastic Container Registry](https://aws.amazon.com/ecr/) is an AWS-hosted private Docker container registry.  Best practice is to deploy an ECR together with Fargate to run your Docker containers.

- **ECS**: Amazon [Elastic Container Service](https://aws.amazon.com/ecs/) is an AWS-hosted private service for running Docker containers.  You can deploy ECS or EKS in Fargate ("serverless") mode to ease management of these resources.

- **ALB**: [Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/application-load-balancer/) is a cloud service that can validate authorization and direct to various cloud resources.  In this workshop we put an ALB in front of Fargate / ECS.

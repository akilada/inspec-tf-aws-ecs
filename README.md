# Inspec Profile for AWS ECS

[![InSpec](https://img.shields.io/badge/inspec-v4.16-brightgreen)](http://terraform.io)

Inspec from for terraform-aws-ecs environment.  

Blog URL - 

Prerequisites 
---

* Inspec Docker Image - https://github.com/akilada/inspec-docker.git
* Terraform Repo URL - https://github.com/akilada/terraform-aws-ecs.git

Execute
---
```
inspec check profiles/DemoECS
inspec exec profiles/DemoECS -t aws://ap-southeast-2 --input-file profiles/DemoECS/attributes.yml
```


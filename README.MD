# Aquaman
Aquaman is a utility container which was designed to be a great way to interact with any number of external services from your favorite CI/CD pipeline jobs. It serves as a great jumping off point for things like gitlab-runner and jenkins as you can pass standard bash commands for your favorite automation tools directly to Aquaman. It was built on top of alpine with the following baked in:
- bash
- git
- ssh-client
- wget
- curl
- ansible
- ansible-vault
- python3
- aws-cli
- kubectl
- rancher-cli
- azure-cli
- gcp-cli (google cloud sdk)
- terraform
- pulumi

  You should not include/store any secrets or passwords within this container, instead they should be passed to the container as environment variables at runtime.


![Aquaman](https://i.imgur.com/ajjUiVr.png)
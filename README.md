# kube-template

How to spin-up a platform with a git push!

```diff
# clusters/kube-do-sample.yaml
+ status: UP
- status: DOWN
```

## Setup

Supported cloud providers
* [DigitalOcean](https://www.digitalocean.com)

1. Create a new repository from this [template](https://github.com/hckops/kube-template/generate)
    - it works both with Public and Private repositories
    - naming convention: `kube-???` or `???-k8s`
2. Replace `repoURL`
    ```bash
    OLD_REPOSITORY=git@github.com:hckops/kube-template.git
    NEW_REPOSITORY=<HTTPS_OR_SSH_GIT_URL>

    grep -Rl --exclude=*.md --exclude-dir=.git ${OLD_REPOSITORY} . | xargs \
      sed -i "s|${OLD_REPOSITORY}|${NEW_REPOSITORY}|g"
    ```
3. Create action secrets, open `https://github.com/OWNER/REPOSITORY/settings/secrets/actions`
    - `DIGITALOCEAN_ACCESS_TOKEN` See [kube-do-action](https://github.com/hckops/actions#kube-do-action)
    - `GITOPS_SSH_KEY` and `ARGOCD_ADMIN_PASSWORD` See [bootstrap-action](https://github.com/hckops/actions#bootstrap-action)
    - `DISCORD_WEBHOOK_URL` See [discord-action](https://github.com/hckops/actions#discord-action) (optional)

TODO  `argocd.configs.credentialTemplates.ssh-creds.sshPrivateKey` in `argocd-config/values-bootstrap.yaml`

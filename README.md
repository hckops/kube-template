# kube-template

[![kube-do](https://github.com/hckops/kube-template/actions/workflows/kube-do.yml/badge.svg)](https://github.com/hckops/kube-template/actions/workflows/kube-do.yml)

> *Spin-up a platform with a git push!*

Setup
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
3. Add the following action secrets
    * `DIGITALOCEAN_ACCESS_TOKEN` required for cluster provisioning with [DigitalOcean](https://cloud.digitalocean.com)
    - `GITOPS_SSH_KEY` and `ARGOCD_ADMIN_PASSWORD` required to bootstrap this sample platform
    - `DISCORD_WEBHOOK_URL` optional, to notify the status in a Discord channel
    - for more info see [kube-do](.github/workflows/kube-do.yml) and [hckops/actions](https://github.com/hckops/actions)
4. Override the credential template with the right owner
    ```diff
    # argocd-config/values-bootstrap.yaml
    + argocd.configs.credentialTemplates.ssh-creds.url: <OWNER_OR_REPOSITORY>
    - argocd.configs.credentialTemplates.ssh-creds.url: git@github.com:hckops
    ```
4. Update the cluster definition and push all the changes
    ```diff
    # clusters/kube-do-sample.yaml
    + status: UP
    - status: DOWN
    ```
5. Wait... :rocket:
6. Connect to ArgoCD
    ```bash
    DIGITALOCEAN_ACCESS_TOKEN=<MY_ACCESS_TOKEN>
    # [admin|argocd] https://localhost:8080
    make forward-argocd name=do-sample token=${DIGITALOCEAN_ACCESS_TOKEN}
    ```

TODO
* kube forward doesn't work in docker
* notify in discord action builds

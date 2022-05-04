# kube-template

Spin-up a platform with a git push!

Supported cloud providers
* [DigitalOcean](https://cloud.digitalocean.com)

Setup steps
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
3. Add these action secrets, for more info see [hckops/actions](https://github.com/hckops/actions)
    - `DIGITALOCEAN_ACCESS_TOKEN`
    - `GITOPS_SSH_KEY` and `ARGOCD_ADMIN_PASSWORD`
    - `DISCORD_WEBHOOK_URL` (optional)
4. Provision a DigitalOcean cluster and bootstrap the sample platform by committing and pushing these changes
    ```diff
    # clusters/kube-do-sample.yaml
    + status: UP
    - status: DOWN
    ```
5. TODO kube-forward + url

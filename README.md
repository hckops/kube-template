# kube-template

[![kube-do](https://github.com/hckops/kube-template/actions/workflows/kube-do.yml/badge.svg)](https://github.com/hckops/kube-template/actions/workflows/kube-do.yml)

> *Spin-up a platform with a git push!*

Setup
1. Create a new repository from this [template](https://github.com/hckops/kube-template/generate)
    - it works both with Public and Private repositories
    - naming convention: `kube-<CLUSTER_NAME>` or `<CLUSTER_NAME>-k8s`
2. Replace repository URL
    ```bash
    OLD_REPOSITORY=git@github.com:hckops/kube-template.git
    NEW_REPOSITORY=<HTTPS_OR_SSH_GIT_URL>

    grep -Rl --exclude=*.md --exclude-dir=.git ${OLD_REPOSITORY} . | xargs \
      sed -i "s|${OLD_REPOSITORY}|${NEW_REPOSITORY}|g"
    ```
3. Rename cluster name and definition `clusters/kube-do-<CLUSTER_NAME>.yaml`
    ```bash
    grep -Rl --exclude-dir=.git "do-sample" . | xargs \
      sed -i "s|sample|<CLUSTER_NAME>|g"
    ```
4. Override the credential template with the right owner
    ```diff
    # argocd-config/values-bootstrap.yaml
    + argocd.configs.credentialTemplates.ssh-creds.url: git@github.com:<OWNER_OR_REPOSITORY>
    - argocd.configs.credentialTemplates.ssh-creds.url: git@github.com:hckops
    ```
5. Add the following action secrets
    * `DIGITALOCEAN_ACCESS_TOKEN` required to privision a cluster with [DigitalOcean](https://cloud.digitalocean.com)
    - `GITOPS_SSH_KEY` and `ARGOCD_ADMIN_PASSWORD` required to bootstrap this platform with [ArgoCD](https://argo-cd.readthedocs.io/en/stable)
    - `DISCORD_WEBHOOK_URL` optional, to notify the status in a Discord channel
    - for more info see [kube-do](.github/workflows/kube-do.yml) and [hckops/actions](https://github.com/hckops/actions)
6. Update the cluster definition and push all the changes
    ```diff
    # clusters/kube-do-<CLUSTER_NAME>.yaml
    + status: UP
    - status: DOWN
    ```
7. Wait... :rocket:
8. Connect to ArgoCD
    ```bash
    DIGITALOCEAN_ACCESS_TOKEN=<MY_ACCESS_TOKEN>

    # https://localhost:8080
    # [admin|<ARGOCD_ADMIN_PASSWORD>]
    make forward-argocd name=do-sample token=${DIGITALOCEAN_ACCESS_TOKEN}
    ```
9. Sample apps
    ```bash
    # https://localhost:8090
    kubectl --kubeconfig do-sample-kubeconfig.yaml -n examples \
      port-forward svc/guestbook-ui 8090:80
    # https://localhost:8091
    kubectl --kubeconfig do-sample-kubeconfig.yaml -n examples \
      port-forward svc/hello-kubernetes-gitops 8091:80
    ```

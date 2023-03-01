# kube-template

[![kube-do](https://github.com/hckops/kube-template/actions/workflows/kube-do.yml/badge.svg)](https://github.com/hckops/kube-template/actions/workflows/kube-do.yml)
[![helm-dependencies](https://github.com/hckops/kube-template/actions/workflows/helm-dependencies.yml/badge.svg)](https://github.com/hckops/kube-template/actions/workflows/helm-dependencies.yml)

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
3. Rename cluster name and definition `clusters/kube-<CLUSTER_NAME>.yaml`
    ```bash
    grep -Rl --exclude-dir=.git "do-template" . | xargs \
      sed -i "s|do-template|<CLUSTER_NAME>|g"
    ```
4. Override the credential template with the right owner
    ```diff
    # argocd-config/values-bootstrap.yaml
    + argocd.configs.credentialTemplates.ssh-creds.url: git@github.com:<OWNER_OR_REPOSITORY>
    - argocd.configs.credentialTemplates.ssh-creds.url: git@github.com:hckops
    ```
5. Add the following action secrets
    * `DIGITALOCEAN_ACCESS_TOKEN` required to privision a cluster with [DigitalOcean](https://cloud.digitalocean.com)
    - `ARGOCD_ADMIN_PASSWORD` and `ARGOCD_GIT_SSH_KEY` required to bootstrap this platform with [ArgoCD](https://argo-cd.readthedocs.io/en/stable)
    - `DISCORD_WEBHOOK_URL` optional, to notify the status in a Discord channel
    - for more info see [workflow](.github/workflows/kube-do.yml) and [hckops/actions](https://github.com/hckops/actions)
6. Update the cluster definition and push all the changes
    ```diff
    # clusters/kube-<CLUSTER_NAME>.yaml
    + status: UP
    - status: DOWN
    ```
    or simply create the cluster by running
    ```bash
    make cluster-up
    ```
7. Wait... :rocket:

<p align="center">
  <img src="docs/discord-message.png" alt="discord-message" width="500">
</p>

8. Connect to ArgoCD
    ```bash
    # download kubeconfig
    make kube-config

    # https://localhost:8080
    # [admin|<ARGOCD_ADMIN_PASSWORD>]
    make forward-argocd
    ```

![argocd-ui](docs/argocd-ui.png)

9. Sample apps
    ```bash
    # http://localhost:8090
    kubectl --kubeconfig clusters/do-template-kubeconfig.yaml -n examples \
      port-forward svc/guestbook-ui 8090:80

    # http://localhost:8091
    kubectl --kubeconfig clusters/do-template-kubeconfig.yaml -n examples \
      port-forward svc/hello-kubernetes-gitops 8091:80
    ```
10. Alternatively, access the cluster from a container
    ```bash
    # use "--network host" to solve dns issues locally or edit "/etc/docker/daemon.json"
    docker run --rm --name hck-tmp -it \
      -e KUBECONFIG=/root/.kube/config \
      -v ${PWD}/clusters/do-template-kubeconfig.yaml:/root/.kube/config \
      hckops/kube-argo
    
    # with docker-compose
    docker-compose up -d
    docker exec -it local-hck-template bash
    docker-compose down -v
    
    # login with kubeconfig
    argocd login --core

    # list apps
    kubens argocd
    kubectl get applications
    argocd app list
    ```
11. Destroy the cluster
    ```bash
    make cluster-down
    ```

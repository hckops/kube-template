# kube-template

How to spin-up a platform with a git push!

```diff
# clusters/kube-do-sample.yaml
version: 1
name: do-sample
provider: digitalocean
+ status: UP
- status: DOWN

config:
  region: lon1
  size: s-1vcpu-2gb
  count: 1
```

## TODO

Actions secrets
* `DIGITALOCEAN_ACCESS_TOKEN`
* `DISCORD_WEBHOOK_URL`

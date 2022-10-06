require-%:
	@ if [ "$(shell command -v ${*} 2> /dev/null)" = "" ]; then \
		echo "[$*] not found"; \
		exit 1; \
	fi

check-param-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Missing parameter: [$*]"; \
		exit 1; \
	fi

##############################

CLUSTER_NAME := test-do-lon1

.PHONY: cluster-workflow
cluster-workflow: check-param-from check-param-to check-param-status
	sed -i 's/status: ${from}/status: ${to}/g' "clusters/kube-$(CLUSTER_NAME).yaml"
	git --no-pager diff
	git commit -am "${status} cluster"
	git push origin main

.PHONY: cluster-up
cluster-up:
	@make cluster-workflow name=$(CLUSTER_NAME) from=DOWN to=UP status=START

.PHONY: cluster-down
cluster-down:
	@make cluster-workflow name=$(CLUSTER_NAME) from=UP to=DOWN status=STOP

.PHONY: kube-config
kube-config: require-doctl check-param-token
	@doctl kubernetes cluster kubeconfig show $(CLUSTER_NAME) --access-token ${token} > "$(CLUSTER_NAME)-kubeconfig.yaml"

.PHONY: forward-argocd
forward-argocd: require-kubectl kube-config
	kubectl --kubeconfig "$(CLUSTER_NAME)-kubeconfig.yaml" port-forward svc/argocd-server -n argocd 8080:443

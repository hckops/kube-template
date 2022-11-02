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

CLUSTER_NAME := do-template
CLUSTER_CONFIG := clusters/kube-$(CLUSTER_NAME).yaml
KUBECONFIG_NAME := clusters/$(CLUSTER_NAME)-kubeconfig.yaml

##############################

.PHONY: cluster-status
cluster-status: check-param-from check-param-to check-param-status
	sed -i 's/status: ${from}/status: ${to}/g' $(CLUSTER_CONFIG)
	git --no-pager diff
	git commit $(CLUSTER_CONFIG) -m "${status} cluster"
	git push origin main

.PHONY: cluster-up
cluster-up:
	@make cluster-status name=$(CLUSTER_NAME) from=DOWN to=UP status=START

.PHONY: cluster-down
cluster-down:
	@make cluster-status name=$(CLUSTER_NAME) from=UP to=DOWN status=STOP
	@rm -fv $(KUBECONFIG_NAME)

##############################

.PHONY: kube-config
kube-config: require-doctl
	@doctl auth init
	@doctl kubernetes cluster kubeconfig show $(CLUSTER_NAME) > $(KUBECONFIG_NAME)

.PHONY: forward-argocd
forward-argocd: require-kubectl kube-config
	kubectl --kubeconfig $(KUBECONFIG_NAME) port-forward svc/argocd-server -n argocd 8080:443

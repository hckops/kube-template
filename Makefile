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

.PHONY: cluster-up
cluster-up: check-param-name
	sed -i 's/status: DOWN/status: UP/g' "clusters/kube-${name}.yaml"
	git --no-pager diff
	git commit -am "START cluster"
	git push origin main

.PHONY: kube-config
kube-config: require-doctl check-param-name check-param-token
	@doctl kubernetes cluster kubeconfig show ${name} --access-token ${token} > "${name}-kubeconfig.yaml"

.PHONY: forward-argocd
forward-argocd: require-kubectl kube-config
	kubectl --kubeconfig "${name}-kubeconfig.yaml" port-forward svc/argocd-server -n argocd 8080:443

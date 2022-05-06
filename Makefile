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

.PHONY: forward-argocd
forward-argocd: require-doctl require-kubectl check-param-name check-param-token
	@doctl kubernetes cluster kubeconfig show ${name} --access-token ${token} > "${name}-kubeconfig.yaml"
	kubectl --kubeconfig "${name}-kubeconfig.yaml" port-forward svc/argocd-server -n argocd 8080:443

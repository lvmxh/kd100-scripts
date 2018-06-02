kubectl apply -f kube-dashboard.yaml

# POD=$(kubectl get po -n kube-system -l k8s-app=kubernetes-dashboard -o jsonpath={..metadata.name})
# kubectl exec -n kube-system $POD -- /dashboard --help

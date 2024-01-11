# Push commands in the background, when the script exits, the commands will exit too
kubectl port-forward svc/vespa-cfg 19071:19071 & \
kubectl port-forward svc/vespa-cfg 19050:19050 & \
kubectl port-forward svc/vespa-cfg 8080:8080 

echo "Press CTRL-C to stop port forwarding and exit the script"
wait

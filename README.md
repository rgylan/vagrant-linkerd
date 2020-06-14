1.  Make C:\Users\romel\.docker
2.  Copy {ca, cert, key}.pem from C:\sandbox\vagrant-centos\tls to #1
3.  On your terminal do:
  set DOCKER_TLS_VERIFY=1
  set DOCKER_HOST=tcp://<remote-docker-host>:2376

4.  If docker is masked
  systemctl unmask docker.service
  systemctl unmask docker.socket
  systemctl start docker.service

5.  On Clear Linux
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.2.15:6443 --token zplbfp.f7kn0rrr4u9695o9 \
    --discovery-token-ca-cert-hash sha256:762618552e745c2111eaf25f663974a185033db80ec2433b71e92f5d2b207d75

Linkerd
1.  Creating DNS via Host File in Windows c:\Windows\System32\Drivers\etc\hosts <your-domain your-ip>
2.  Sample ingress below to use with Linkerd Dashboard ex http://dashboard.example.com:31574/
[vagrant@kmaster vagrant]$ kubectl -n ingress-nginx get svc
NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.106.157.154   <none>        80:31574/TCP,443:30123/TCP   19m
ingress-nginx-controller-admission   ClusterIP   10.106.169.250   <none>        443/TCP                      19m

https://kubernetes.github.io/ingress-nginx/deploy/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/baremetal/deploy.yaml
https://linkerd.io/2/tasks/exposing-dashboard/  
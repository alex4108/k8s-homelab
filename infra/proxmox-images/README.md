# This needs to run on an Ubuntu system!

Prereqs:
    * Ubuntu 
    * Root access via SSH key to a proxmox host
    

`make image`
I'm not sure if this step can be containerized...

Makes an Ubuntu 20 vm with latest kubelet, kubeadm, kubectl, and containerd.

You can deploy this as a worker or master!

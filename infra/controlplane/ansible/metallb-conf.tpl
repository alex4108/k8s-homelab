apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  namespace: metallb-system
spec:
  addresses:
  - {{ ip_range }}
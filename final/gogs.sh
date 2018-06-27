oc new-app wkulhanek/gogs:11.34 -lapp=gogs
oc scale dc/gogs --replicas=0
oc rollout pause dc/gogs
oc set volume dc/gogs --add --overwrite --name=gogs-volume-1 --mount-path=/data/ --type persistentVolumeClaim --claim-name=gogs-data --claim-size=4Gi  
oc create configmap gogs --from-file=$HOME/app.ini
oc set volume dc/gogs --add --overwrite --name=config-volume -m /opt/gogs/custom/conf/ -t configmap --configmap-name=gogs


oc expose svc gogs
oc scale dc/gogs --replicas=1
oc rollout resume dc/gogs

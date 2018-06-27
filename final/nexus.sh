oc new-app sonatype/nexus3:latest
oc rollout pause dc/nexus3
oc scale dc/nexus3 --replicas=0

oc volume dc/nexus3 --add --name=nexus3-volume-1 --overwrite --claim-size=2Gi
oc set resources dc nexus3 --limits=memory=2Gi --requests=memory=1Gi

oc patch dc/nexus3 --patch '{"spec":{"strategy":{"type":"Recreate"}}}'


oc set probe dc/nexus3 --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
oc set probe dc/nexus3 --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://:8081/repository/maven-public/

oc expose svc nexus3

oc scale dc/nexus3 --replicas=1
oc rollout resume dc/nexus3
oc expose dc nexus3 --port=5000 --name=nexus-registry
oc create route edge nexus-registry --service=nexus-registry --port=5000

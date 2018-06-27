cat <<ENDL
#Run these commands on the pod
createuser gogs
createdb gogs
psql -c "alter user gogs with encrypted password 'gogs';"
psql -c "grant all privileges on database gogs to gogs;"
exit
ENDL

oc rsh $(oc get pods -l deploymentconfig=postgresql --template '{{ range .items }}{{ .metadata.name }}{{ end }}')

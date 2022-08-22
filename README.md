### Tekton Pipeline for deploy WebSphere Liberty Apps ###
---

Updated: 17/08/2022 - Support for Gradle.  Please note that the archive needs to be placed in `../../../source/target` for it to work.

--- 

This is a sample pipeline that can be used for deploying an application to a WebSphere Liberty container and deploying it to OCP.  The pipeline will do the following:

1. Update the name of the project to lowercase and remove spaces.
2. Download code from a [Git](https://github.com) repository
3. Compile the code using [Maven](https://maven.apache.org)
4. Use the [Dockerfile](https://docs.docker.com/engine/reference/builder/) to build a new tWAS image and store it in the OCP [ImageStreams](https://docs.openshift.com/container-platform/4.10/openshift_images/image-streams-manage.html) repository
5. Create a WebSphere Liberty Instance based and have it running.

The first 3 items are done with Tasks from the [Tekton Hub](https://hub.tekton.dev).

The [OpenShift](https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/) and [Tekton](https://github.com/tektoncd/cli/releases) CLIs are needed to run commands and setup the pipeline.

1. Login to your OCP cluster
2. Create a project (namespace) for the pipelines, if necessary
```
oc new-project <project> (was-liberty)
```
3. Install the WebSphere Liberty Operator
```
oc apply -f tekton/was-liberty-install.yaml -n <project>
```
4. Install the Tekton Pipeline.   
```
oc apply -f tekton/tekton-pipelines-install.yaml
```
5. Install the necessary Tekton Tasks from the Tekton Hub
```
tkn hub install task git-clone -n <project>
tkn hub install task maven -n <project>
tkn hub install task kaniko -n <project>
```
needed for gradle:
```
tkn hub install task gradle -n <project>
```
6. Add task to format the app name (make lowercase, remove spaces)
```
oc apply -f tekton/was-pipeline-task-appname.yaml -n <project>
```
7. Add the custom Task for Deployment
```
oc apply -f tekton/was-pipeline-task-deploy.yaml -n <project>
```
8. Add the PersistentVolumeClaim used to share between tasks.
```
oc apply -f tekton/was-pipeline-pvc.yaml -n <project>
```
9. Install the Pipeline
```
oc apply -f tekton/was-pipeline.yaml -n <project>
```
needed when using gradle:
```
oc apply -f tekton/was-pipeline-gradle.yaml -n <project>
```

To run the pipeline, a sample Pipeline Run is included
```
oc create -f tekton/was-pipeline-run.yaml -n <project>
```
---
#### Setting up a trigger ####

In a true CI/CD pipeline developers would not be submitting a Pipeline Run with the necessary data to kick off a pipeline, they would use an EventListener that would take some inputs and start the Pipeline Run.  

1. Setup the necessary ServiceAccount and cluster secuity to receive events and act upon them.  The file must be updated with the namespace used for the Pipeline for the security.  Update `CHANGE_ME` with the appropriate namespace.
```
oc apply -f was-triggers-security.yaml -n <project>
```
2. Add the Trigger Template, which is an outline of how to handle the Trigger and what to run, which is similar to the Pipeline Run
```
oc apply -f was-triggers-template.yaml -n <project>
```
3. Add the necessary bindings for this specific application.  This contains information to be passed to the Trigger Template
```
oc apply -f was-triggers-bindings.yaml -n <project>
```
4. Add the EventListener, which will startup a Pod and service to listen to Events for the trigger.  The Pod name will be prefixed with an `el` with the name of the EventListen.  In this sample it is called `el-was-triggers-eventlistener`.  The Service is given the same name as the Pod.
```
oc apply -f was-triggers-eventlistener.yaml -n <project>
```
5. Create a Route so that the Trigger can be called from outside the cluster.
```
oc apply -f was-triggers-route.yaml -n <project>
```
To test the Trigger, the Route endpoint can be called with the necessary JSON parameters. 
```
ROUTE_HOST=$(oc get route el-was-triggers-listener -n <project> --template='http://{{.spec.host}}')
URL=https://github.com/bpaskin/WASLiberty-Tekton.git
curl -v -H 'X-GitHub-Event: pull_request' -H 'Content-Type: application/json' -d '{ "repository": {"clone_url": "'"${URL}"'"}, "pull_request": {"head": {"sha": "master1", "repo": {"name":"WASLiberty-TekTon"}}} }' ${ROUTE_HOST}
```
If the request is accepted successfully the HTTP response should be either a `201 Created` or `202 Accepted`. 

#### Using a Webhook to trigger a build ####

The Pipeline can be started when a GitHub Pull is done.  This will send a message to the Event Listener endpoint with some data.  The repository name, SHA of the pull request and URL of the repository will be used in the pipeline.

1. Go to the GitHub repository page in the web browser.
2. Click the Settings tab.
3. In the navigation pane, click Hooks.
4. Click Add Webhook.
5. In the Payload URL field, paste the webhook URL (output from the `oc get route el-was-triggers-listener -n <project> --template='http://{{.spec.host}}'` command
6. In the Content type field, select JSON.
7. Leave the Secret field empty
8. In the options displayed, ensure that the Pull event is selected only.
9. Ensure that the Active check box is selected. This option keeps the webhook enabled and sends notifications whenever an event is triggered.
10. Click Add webhook to complete the configuration of the webhook in GitHub Enterprise.

Helpful while testing `Tasks`: `tkn task start was-deploy-app --showlog`

---

When using Git with a userid/token or with SSL Key, then a new `Secret` needs to be added, the `Pipeline` needs a new workspace and the `Pipeline-Run` needs to reference the workspace and the `Secret`.  Have a [look](https://artifacthub.io/packages/tekton-task/tekton-catalog-tasks/git-clone) at the Git Clone task.  

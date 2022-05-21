FROM arvindsundaram/vc_norbis

COPY projects /projects

COPY vc_workflow.sh .

ENTRYPOINT [ "bash" , "vc_workflow.sh" ]

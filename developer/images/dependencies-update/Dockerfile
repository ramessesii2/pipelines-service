#@FROM registry.access.redhat.com/ubi9/ubi-minimal
FROM registry.access.redhat.com/ubi9/ubi-minimal@sha256:61925d31338b7b41bfd5b6b8cf45eaf80753d415b0269fc03613c5c5049b879e
LABEL build-date= \
    com.redhat.build-host= \
    description="This image provides the scripts to update the repository dependencies." \
    distribution-scope="public" \
    io.k8s.description="This image provides the scripts to update the repository dependencies." \
    io.k8s.display-name="dependencies-update" \
    maintainer="Pipeline Service" \
    name="dependencies-update" \
    release="0.1" \
    summary="Provides the scripts to update the repository dependencies" \
    url="https://github.com/openshift-pipelines/pipeline-service/tree/main/developer/images/dependencies-update" \
    vcs-ref= \
    vcs-type="git" \
    vendor="Pipeline Service" \
    version="0.1"
WORKDIR /
RUN mkdir /workspace && chmod 777 /workspace && chown 65532:65532 /workspace
ENV HOME /tmp/home
RUN mkdir $HOME && chmod 777 $HOME && chown 65532:65532 $HOME
RUN microdnf install -y \
      findutils-4.8.0 \
      git-2.31.1 \
      skopeo-1.9.4 \
    && microdnf clean all

COPY shared /tmp/image-build/shared
RUN /tmp/image-build/shared/hack/install.sh --debug --bin jq \
    && rm -rf /tmp/image-build

COPY developer/images/dependencies-update/hack /opt/dependencies-update
RUN chmod 755 /opt/dependencies-update/bin/*.sh
USER 65532:65532
ENV WORK_DIR /workspace
VOLUME /workspace
WORKDIR /workspace

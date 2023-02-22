# Changes to this file are not auto-propagated to the downstream build automation. We need to make the changes manually in the midstream repo located here:
# https://gitlab.cee.redhat.com/cpaas-midstream/telco-5g-ran/bare-metal-event-relay/-/blob/rhaos-4.13-rhel-8/distgit/containers/bare-metal-event-relay/Dockerfile.in
# Build the manager binary
FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.12 AS builder
WORKDIR /go/src/github.com/redhat-cne/hw-event-proxy-operator
COPY . .
ENV GO111MODULE=off
RUN make
# Build

FROM registry.ci.openshift.org/ocp/4.12:base
WORKDIR /
COPY --from=builder /go/src/github.com/redhat-cne/hw-event-proxy-operator/build/_output/bin/hw-event-proxy-operator /
COPY --from=builder /go/src/github.com/redhat-cne/hw-event-proxy-operator/bindata /bindata
USER 65532:65532

ENTRYPOINT ["/hw-event-proxy-operator"]

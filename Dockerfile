# Dockerfile for Fluentd with pre-installed plugins
# Base image: Fluentd v1.17 on Debian
FROM fluent/fluentd:v1.17-debian-1

# Switch to root to install dependencies and plugins
USER root

# Install build dependencies required for plugin compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Fluentd plugins
# These are the same plugins that were previously installed at runtime
RUN gem install fluent-plugin-kubernetes_metadata_filter -v 3.4.0 --no-document \
    && gem install fluent-plugin-grafana-loki -v 1.2.20 --no-document \
    && gem install fluent-plugin-systemd -v 1.1.0 --no-document \
    && gem install fluent-plugin-concat -v 2.5.0 --no-document \
    && gem install fluent-plugin-prometheus -v 2.1.0 --no-document

# List installed plugins for verification
RUN fluent-gem list | grep fluent-plugin

# Switch back to fluent user for security
USER fluent

# Default command - will be overridden by Kubernetes
CMD ["fluentd", "-c", "/fluentd/etc/fluent.conf"]

# Security Policy

## Supported versions

Only the latest release on `main` receives security fixes.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public issues.**

Use GitHub's private vulnerability reporting: go to the **Security** tab of the repository and click **Report a vulnerability**.

Please include:

- a description of the issue and its impact
- steps to reproduce, or a proof of concept
- affected files, endpoints, or versions

You can expect an acknowledgment within 7 days. Once the issue is confirmed, a fix will be prepared and released, and you will be credited in the changelog unless you prefer otherwise.

## Scope

In scope: the API (`api/`), the Docker image, Kubernetes manifests, CI/CD workflows, and dependency vulnerabilities.
Out of scope: the public demo's availability (it runs on a single VM with no SLA).

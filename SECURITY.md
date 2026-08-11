# Security Policy

## Supported versions

Security fixes are applied to the latest released version of Deep Widget.

| Version | Supported |
| --- | --- |
| 1.0.x | Yes |
| Earlier versions | No |

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability.

Use the repository's **Security > Advisories > New draft security advisory**
page and include:

- the affected version;
- steps to reproduce the issue;
- the expected and actual behavior;
- the security or privacy impact;
- a minimal proof of concept when safe to share.

Remove personal photos, access tokens, signing keys, passwords, device serial
numbers and local filesystem paths before attaching logs or screenshots.

Maintainers will acknowledge a valid private report when they are available,
investigate it, and coordinate disclosure after a fix is ready. Please do not
publish the details before that coordination is complete.

## Release signing

The official Deep Widget signing key is never stored in this repository.
Contributors can run debug builds without it. Fork maintainers must create and
protect their own release key and should use a different Android application ID.

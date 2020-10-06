# Mail

If you use another mail server you can specify it in docker-compose.yml file via RelayHost.

```yaml
environment:
  - POSTFIX_RELAYHOST=[global-mail]:1025
```

# Vulnerabilities

Investigate vulnerabilities.

```bash
# Run audit in docker container
~/audit.sh

# Run audit in project folder
docker-compose exec -u application web bash -c "~/audit.sh"

# Search for Yarn and execute audit
find . -maxdepth 2 -iname yarn.lock -exec sh -c '(cd $(dirname {}) && docker-compose up -d && docker-compose exec -u application web bash -c "~/audit.sh" && cd -)' \;
```

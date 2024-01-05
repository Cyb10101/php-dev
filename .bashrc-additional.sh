source ~/.shell-methods.sh
sshAgentRestart
sshAgentAddKey 7d ~/.ssh/id_rsa
bashCompletion
addAlias
addDockerVariables
stylePS1 "${DOCKER_COMPOSE_PROJECT}"

addPythonVenvToPath
export PATH=${PATH}:~/.composer/vendor/bin:./bin:./vendor/bin:./node_modules/.bin

USAGE
-----

`
git submodule add https://github.com/worstinme/docker-workspace.git _docker
mkdir _docker_local
cp _docker/example.docker-compose.yml docker-compose.yml
cp _docker/.env.example .env
`

Start with editing created docker-compose.yml for your project
Store custom configruation files,  Dockerfiles, volumes etc. in _docker_local directory


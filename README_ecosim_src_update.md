# EcoSIM source code update:

1. Go to the forked [EcoSIM](https://github.com/leizhang-geo/EcoSIM.git) GitHub website (on my github page), click "Sync fork" for branch 'main' and 'dev-leizhang'.

2. Go to [ecosim_docker](https://github.com/leizhang-geo/ecosim_docker.git) GitHub repository (on local machine), sync fork of EcoSIM source code (submodule).
- `cd ./EcoSIM`
- `git pull origin dev-leizhang`
- `cd ..`
- `git add -A; git commit; git push origin`

3. If there is a conflict and sync EcoSIM src cannot be performed (i.e., if above step 2 does not work), we can totally remove folder 'EcoSIM'. We may need to completely remove submodule info by following steps:
- `git submodule deinit -f -- ./EcoSIM`
- `git rm -f ./EcoSIM`
- `rm -rf .git/modules/EcoSIM`
- `git submodule add --force -b dev-leizhang git@github.com:leizhang-geo/EcoSIM.git EcoSIM`
- `git add -A; git commit; git push origin`

4. Update the code files in folder `src_update`:

- In build_EcoSIM.sh (location: before the code of `print_help()`):
```bash
### LZ code edit START ###
systype="Linux"
precision="double"
shared=1
### LZ code edit END   ###
```

- In CMakeLists.txt (location: before the code of `if (ATS_ECOSIM)`):
```bash
### LZ code edit START ###
set(ATS_ECOSIM TRUE)
set(TPL_INSTALL_PREFIX $ENV{NETCDF_DIR})
### LZ code edit END   ###
```

6. Push all to GitHub repo: `git add -A; git commit; git push origin`.

7. Start building EcoSIM in Docker.


# Github co-develop（fork -> dev -> pull request）

1. Fork the original repo to your GitHub account.

2. Clone your own fork to your machine.

3. Add the original repo as upstream: `git remote add upstream git@github.com:leizhang-geo/<repo_name>.git`

4. Create your branch for develop, make your changes, test, and commit

5. When you are done, push to your own fork (not to the original repo): `git push origin <dev branch name>`

6. Go to your fork on GitHub, and GitHub will show a button like: "Compare & pull request". Click it and submit your pull request to the original repo.

7. After PR approved, sync with upstream:
- `git checkout <branch_name>`
- `git pull upstream <branch_name>`
- `git push origin <branch_name>`


# Docker useage

- Recursively clone a repo: git clone --recursive git@github.com:leizhang-geo/ecosim_docker.git

- Rename an image: `docker tag [image_name_old]:[tag_old] [image_name_new]:[tag_new]` -> `docker rmi [image_name_old]:[tag_old]`

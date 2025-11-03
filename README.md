<div align="center">
<a href="https://git.mrrp.es/GamePlayer-8/realmprobe"><h1>RealmProbe</h1></a>
</div>
<div align="center">
Test CI/CD capabilities to define it's ready state in production builds.
</div>
<div align="center">

[![TransRights]][transrights_url]
[![Enbyware]][enbyware_url]
[![License]][license_url]

</div>
<div align="center">

[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://github.com/prettier/prettier)
[![commit style: husky](https://img.shields.io/badge/commit_style-husky-FEC56D.svg)](https://github.com/typicode/husky)

</div>

# Description

RealmProbe was meant to check if CI/CD provides minimal as well as maximum set of capabilities, allowing rapid builds.
<br/>
Is only for testing if CI/CD can be anyhow usable and at what level.
<br/>
Contains as well:

- Code coverage
- System toolkits

# Builds

Lurk for the latest "Green tick" next to repo commits, would point the status of probe.

> [!IMPORTANT]
> In the `.provisioning` directory there are Woodpecker CI/CD configuration files for building OCI images, both being shipped on local git instance and Docker Hub.
> What's being executed on probed instances is in `.woodpecker`,`.forgejo/workflows`,`.gitea/workflows`,`.github/workflows`,`.gitlab-ci.yml`.

# Development

> [!WARNING]
> Please read the [Code of Conduct](CODE_OF_CONDUCT.md) and [Apache 2.0 License](LICENSE.txt) before contributing.

Make sure to run `source source.sh` and use vscode / any IDE which supports Prettier & Husky for git integrity.
This repository can utilize Git LFS for handling binary files.

[xaviama_url]: https://ci.chimmie.k.vu/repos/25
[codeberg_url]: https://ci.codeberg.org/repos/15215
[transrights_url]: https://en.wikipedia.org/wiki/Transgender_rights_movement
[enbyware_url]: https://en.wikipedia.org/wiki/Non-binary
[license_url]: LICENSE.txt
[liberapay_url]: https://liberapay.com/chimmie
[XaviaMa]: https://ci.chimmie.k.vu/api/badges/25/status.svg
[Codeberg]: https://ci.codeberg.org/api/badges/15215/status.svg
[TransRights]: https://pride-badges.pony.workers.dev/static/v1?label=trans%20rights&stripeWidth=6&stripeColors=5BCEFA,F5A9B8,FFFFFF,F5A9B8,5BCEFA
[Enbyware]: https://pride-badges.pony.workers.dev/static/v1?label=enbyware&labelColor=%23555&stripeWidth=8&stripeColors=FCF434%2CFFFFFF%2C9C59D1%2C2C2C2C
[License]: https://img.shields.io/badge/License-Apache_2.0-green
[LiberaPay]: https://img.shields.io/liberapay/receives/chimmie

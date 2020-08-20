# Harmony ansible deployment

Copy `hosts-example` to `credentials/hosts` and configure the remote hosts

Install BLS key(s) to `credentials/<hostname>/bls/<pubkey>.key`

Multiple BLS keys are supported.

*Note that changing `num_bls` is not enough, you have to add/remove the
appropriate BLS keys on chain using `hmy staking edit-validator` with
`--remove-bls-key` and `--add-bls-key` to match what is on the node.*

BLS passphrases are not supported by this role at the moment.

Secure credentials

```bash
chmod og-rx -R credentials
```

## Update binaries from upstream, push to hosts

Note that this downloads binaries to your local machine, and the role installs
those binaries.

```bash
./update.sh
ansible-playbook main.yml
```

`./update.sh` downloads binaries native to where it is run, and on MacOS this
means it downloads binaries that cannot be deployed to our nodes.

**NOTE: If `BN_MA` changes in `node.sh`, update `files/sbin/harmonyd`**

All other changes in `node.sh` (e.g. arguments etc) need to be updated in files/sbin/harmonyd

On a new install this will NOT automatically start harmony! To do that:

## Start/restart Harmony

```bash
ansible-playbook restart.yml
```

## Stop/clean/start Harmony (like ./node.sh -c)

```bash
ansible-playbook clean.yml
```

## Stop Harmony

```bash
ansible-playbook stop.yml
```

## Stop Harmony, clean, start harmony

```bash
./update.sh
ansible-playbook stop.yml clean.yml main.yml start.yml
```

## Nuke Harmony database and user

```bash
ansible-playbook nuke.yml
```

## Fetch remote wallet in to local `credentials/`

Edit `hosts` and adjust the `wallet_home` fact to taste.

```bash
ansible-playbook fetch.yml
```

## To check balances on the node

```bash
./hmy.sh balances <public_address>
```

# Building Harmony

## Checkout upstream

```bash
mkdir harmony-one
cd harmony-one
git clone git@github.com:harmony-one/bls
git clone git@github.com:harmony-one/mcl
```

## Check out our fork and upstream u3

```bash
git clone git@github.com:Blockdaemon/harmony.git
cd harmony
git remote add upstream git@github.com:harmony-one/harmony
git fetch --all
git checkout -b u3 upstream/u3
```

## Build

```bash
make
```

## To deploy binary built in `src/harmony-one/harmony`

```bash
ansible-playbook main.yml --tags dev
```

## Update our fork from upstream

``` bash
git -C ../bls pull
git -C ../mcl pull
git fetch --all
git remote prune upstream
git remote prune origin
git checkout go.mod
git checkout master && git rebase upstream/master
git checkout u3 && git rebase upstream/u3
```

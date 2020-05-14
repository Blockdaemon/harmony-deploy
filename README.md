# Harmony ansible deployment

Copy `hosts-example` to `hosts` and configure the remote hosts

Install bls key to `credentials/<hostname>/bls`

Copy bls passphrase into `credentials/<hostname>/bls/passphrase`

Secure credentials

```bash
chmod og-rx -R credentials
ansible-playbook main.yml
```

## Update binaries from upstream, push to hosts

```bash
./update.sh
ansible-playbook main.yml
```

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

## Check out our fork of t3

```bash
git clone git@github.com:Blockdaemon/harmony.git
cd harmony
git remote add upstream git@github.com:harmony-one/harmony
git fetch --all
git checkout -b t3 upstream/t3
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
git checkout t3 && git rebase upstream/t3
```

## Push result to our fork

```bash
git push origin t3
git push origin master
```

# Harmony scripts

Copy `hosts-example` to `hosts` and configure the remote hosts

Copy passphrase into `credentials/<hostname>/passphrase`

Install wallet and bls keys to `credentials/<hostname>/` into `keystore/` and `bls/` respectively

Secure secrets and wallets, run playbook:

```
chmod og-rx -R credentials
ansible-playbook harmony.yml
```

## Update binaries from upstream, push to hosts

```
./update.sh
ansible-playbook harmony.yml
```

**NOTE: If `BN_MA` changes in `node.sh`, update tasks/wrapper.yml**

All other changes in `node.sh` (e.g. arguments etc) need to be updated in files/sbin/harmonyd

On a new install this will NOT automatically start harmony! To do that:

## Start/restart Harmony

```
ansible-playbook restart.yml
```

## Stop/clean/start Harmony (like ./node.sh -c)

```
ansible-playbook clean.yml
```

## Stop Harmony

```
ansible-playbook stop.yml
```

## Stop Harmony, clean, start harmony

```
./update.sh
ansible-playbook stop.yml clean.yml harmony.yml start.yml
```

## Nuke Harmony database and user

```
ansible-playbook nuke.yml
```

## Fetch remote wallet in to local `credentials/`

Edit `hosts` and adjust the `wallet_home` fact to taste.

```
ansible-playbook fetch.yml
```

## To check balances on the node

```
./wallet.sh balances --address <public_address>
```

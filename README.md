# Harmony scripts

Copy `hosts-example` to `hosts` and configure the remote hosts

Copy passphrase into `credentials/<hostname>/passphrase`

Install wallet and bls keys to `credentials/<hostname>/` into `keystore/` and `bls/` respectively

Secure secrets and wallets, run playbook:

```
chmod og-rx -R credentials
ansible-playbook harmony.yml
```

## Update binaries

```
./update.sh
```

## Start/restart Harmony

```
ansible-playbook restart.yml
```

## Restart Harmony after cleaning db (like ./node.sh -c)

```
ansible-playbook clean.yml
```

## Stop Harmony

```
ansible-playbook stop.yml
```

## Fetch remote wallet in to local `credentials/`

Edit fetch.yml and adjust the `wallet_user` fact to taste.

**Note that the RESULTS ARE GLOBALLY READABLE FILES. Do not omit the `chmod` command below!!**

```
ansible-playbook fetch.yml
chmod og-rx -R credentials
```

## To check balances on the node

```
./wallet.sh balances --address <public_address>
```

# Harmony scripts

Copy `hosts-example` to `hosts` and configure the remote hosts

Copy `secrets-example.json` to `secrets.json` and add public addresses and wallet passphrases

Install wallet and bls keys to `credentials/<hostname>/` into `keystore/` and `bls/` respectively

Secure secrets and wallets, run playbook:

```
chmod og-r secrets.json credentials/*/keystore/*
ansible-playbook harmony.yml
```

## Update binaries

```
./update.sh
```

## Restart Harmony

```
ansible-playbook restart.yml
```

## Restart Harmony after cleaning db (like ./node.sh -c)

```
ansible-playbook clean.yml
```

## To check balances on the node

```
./wallet.sh balances --address <public_address>
```

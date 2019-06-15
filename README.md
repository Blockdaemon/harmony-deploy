# Harmony scripts

Copy `addresses-example.json` to `addresses.json` and add public addresses
Copy wallet keys to to `keystore/<hostname>/`

Run playbook:

```
ansible-playbook harmony.yml
```

To update:

```
cd files/bin
. update
fakeroot node.sh asdf
```

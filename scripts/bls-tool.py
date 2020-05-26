#!/usr/bin/env python3

import os, sys
import json, requests
import yaml

def print_err(*args):
    print(*args, file=sys.stderr, flush=True)

## JSON-RPC
def json_rpc(url, method, params=[]):
    if url == None:
        url = os.getenv("HMY_URL", "https://api.s0.t.hmny.io/")

    headers = {'Content-Type':'application/json'}
    req = {"jsonrpc":"2.0","method":method,"params":params,"id":1337}
    resp = requests.post(url, data=json.dumps(req), headers=headers)
    if resp.status_code != 200 or len(resp.content) == 0:
        print_err(f"{method} failed: {resp.status_code}: {resp.content.decode()}")
        return []
    return resp.json()

def get_hmy_median_raw_stake_snapshot(url=None):
    resp = json_rpc(url, "hmyv2_getMedianRawStakeSnapshot")
    if not 'result' in resp:
        print_err("getMedianRawStakeSnapshot", resp)
        return
    return resp['result']

def get_hmy_validator_information(addr, url=None):
    resp = json_rpc(url, "hmyv2_getValidatorInformation", params=[addr])
    if not 'result' in resp:
        print_err("getValidatorInformation", resp)
        return
    return resp['result']

def main():
    with open("bls-tool.yaml") as file:
        addrs = yaml.load(file, Loader=yaml.FullLoader)
        #print(json.dumps(addrs))
    snapshot = get_hmy_median_raw_stake_snapshot()
    candidates = snapshot['epos-slot-candidates']
    for i,c in enumerate(candidates):
        v = c['validator']
        #candidates[i]['name'] = v
        old_len = len(c['keys-at-auction'])
        candidates[i]['len'] = old_len
        if v in addrs:
            info = get_hmy_validator_information(v)
            name = info['validator']['name']
            candidates[i]['name'] = name
            if addrs[v]:
                new_len = addrs[v]['try_bls']
                if old_len != new_len:
                    old_stake = candidates[i]['stake-per-key']
                    new_stake = c['stake']/new_len
                    print_err(f"{name}: {old_stake/1E18} x{old_len} -> {new_stake/1E18} x{new_len}")
                    candidates[i]['len'] = new_len
                    candidates[i]['stake-per-key'] = new_stake
    candidates = sorted(candidates, key = lambda i: i['stake-per-key'],reverse=True)
    i = 1
    for c in candidates:
        l = c['len']
        if 'name' in c:
            if l>1:
                print(f"{i}-{i+l-1}: {c['name']} x{l}")
            else:
                print(f"  {i}: {c['name']}")
        i += l

if __name__ == "__main__":
    main()

# vim: sw=4:expandtab

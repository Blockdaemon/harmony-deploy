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

def get_eff_stake(info):
    ret = 0
    if info['metrics'] and 'by-bls-key' in info['metrics']:
        for m in info['metrics']['by-bls-key']:
            if 'key' in m and 'effective-stake' in m['key']:
                eff = float(m['key']['effective-stake'])
                if eff > ret:
                    ret = eff
    return ret

def main():
    with open("bls-tool.yaml") as file:
        addrs = yaml.load(file, Loader=yaml.FullLoader)
        #print(json.dumps(addrs))
    snapshot = get_hmy_median_raw_stake_snapshot()
    median = float(snapshot['epos-median-stake'])
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
            candidates[i]['eff'] = get_eff_stake(info)
            if addrs[v]:
                new_len = addrs[v]['try_bls']
                if old_len != new_len:
                    old_stake = candidates[i]['stake-per-key']
                    new_stake = c['stake']/new_len
                    print_err(f"{name}: {round(old_stake/1E24,2)}M x{old_len} -> {round(new_stake/1E24,2)}M x{new_len}")
                    candidates[i]['len'] = new_len
                    candidates[i]['stake-per-key'] = new_stake
    candidates = sorted(candidates, key = lambda i: i['stake-per-key'],reverse=True)
    max_eff = get_eff_stake(get_hmy_validator_information(candidates[0]['validator']))
    print(f"med/max: {round(median/1E24,2)}M/{round(max_eff/1E24,2)}M ({round(max_eff*100.0/median)}%)")
    i = 1
    for c in candidates:
        l = c['len']
        if 'name' in c:
            pct_of_median = round(c['stake-per-key']*100.0/median)
            s = f"{c['name']} {round(c['stake-per-key']/1E24,2)}M ({pct_of_median}%), {round(c['eff']/1E24,2)}M"
            if l>1:
                p = f"{i}-{i+l-1}".rjust(7)
                print(f"{p}: {s}x{l}")
            else:
                p = f"{i}".rjust(7)
                print(f"{p}: {s}")
        i += l

if __name__ == "__main__":
    main()

# vim: sw=4:expandtab

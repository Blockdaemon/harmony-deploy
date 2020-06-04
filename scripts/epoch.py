#!/usr/bin/env python3

import os, sys
import time
import json, requests

seconds_per_block = 8.5
block_sample_gap = 1000

def print_err(*args):
    print(*args, file=sys.stderr, flush=True)

def timer(elapsed):
    (days, rem) = divmod(elapsed, 24*60*60)
    (hours, rem) = divmod(rem, 60*60)
    (minutes, seconds) = divmod(rem, 60)
    return "{}d {:0>2}h {:0>2}m {:0>2}s".format(int(days),int(hours),int(minutes),round(seconds))

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

def get_hmy_block_number(url=None):
    resp = json_rpc(url, "hmyv2_blockNumber")
    if not 'result' in resp:
        print_err("blockNumber", resp)
        return
    return resp['result']

def get_hmy_block(num, url=None):
    resp = json_rpc(url, "hmyv2_getBlockByNumber", params=[num,{}])
    if not 'result' in resp:
        print_err("getBlockByNumber", resp)
        return
    return resp['result']

def get_hmy_get_staking_network_info(url=None):
    resp = json_rpc(url, "hmyv2_getStakingNetworkInfo", params=[-1])
    if not 'result' in resp:
        print_err("getStakingNetworkInfo", resp)
        return
    return resp['result']

block = get_hmy_block_number()
#print(block)

now = get_hmy_block(block)
then = get_hmy_block(block-block_sample_gap)
if 'timestamp' in now and 'timestamp' in then:
    #print(now['timestamp'])
    #print(then['timestamp'])
    elapsed = now['timestamp']-then['timestamp']
    seconds_per_block = float(elapsed)/block_sample_gap

info = get_hmy_get_staking_network_info()
#print(json.dumps(info))
blocks_left = info['epoch-last-block'] - block
secs = blocks_left*seconds_per_block
print(f"{blocks_left} blocks to go, {timer(secs)} (@{seconds_per_block}/sec)")
when = time.time() + secs
print(time.ctime(when))

# vim: sw=4:expandtab

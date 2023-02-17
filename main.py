import time
import argparse
from datetime import timedelta

from prefect import flow, task

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument(
    '-input', 
    metavar='i',
    type=int, 
    nargs='+',
    help='List of integers to be passed to prefect',
)

def cache_key_from_sum(context, parameters):
    print(parameters)
    return sum(parameters["nums"])

@task(cache_key_fn=cache_key_from_sum, cache_expiration=timedelta(days=7))
def cached_task(nums):
    print('running an expensive operation')
    time.sleep(10)
    return sum(nums)

@flow
def test_caching(nums):
    cached_task(nums)

if __name__ == "__main__":
    args = parser.parse_args()
    print(f"Using prefect inputs: {args.input}")
    test_caching(args.input)


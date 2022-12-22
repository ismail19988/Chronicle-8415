import requests
import sys
import json


PROXY_PUBLIC_IP = ''


def send_request(route, body):
    return requests.post(route, json=body)


def direct_hit(query):
    ans = send_request(route=PROXY_PUBLIC_IP + "/direct_hit", body={'query': query})
    return ans.status_code, ans.text


def random_hit(query):
    ans = send_request(route=PROXY_PUBLIC_IP + "/random_hit", body={'query': query})
    return ans.status_code, ans.text


def custom_hit(query):
    ans = send_request(route=PROXY_PUBLIC_IP + "/custom", body={'query': query})
    return ans.status_code, ans.text


if __name__ == "__main__":

    query_entry = ""
    hit_entry = ""

    try:
        query_entry = sys.argv[1]
    except IndexError as e:
        print("No query or strategy provided")
        exit(0)

    try:
        hit_entry = sys.argv[2]
    except IndexError as e:
        print("No query or strategy provided")
        exit(0)

    status, answer = "", ""
    if hit_entry == "direct":
        status, answer = direct_hit(query_entry)
    elif hit_entry == "random":
        status, answer = random_hit(query_entry)
    elif hit_entry == "custom":
        status, answer = custom_hit(query_entry)
    else:
        print("The strategy provided is not supported.")

    if status == 200:
        print('the query has succeeded!')
        print('answer:')
        print(answer)

    exit(0)

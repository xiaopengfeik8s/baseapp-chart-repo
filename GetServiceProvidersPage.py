#!/usr/bin/python3

from flask import Flask, request, abort, Response, jsonify as flask_jsonify, make_response
import argparse 
import sys, os, getopt, socket, json, time
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest
from aliyunsdkcore.auth.credentials import AccessKeyCredential

app = Flask(__name__)

@app.route('/')
def index():
    return ('iKubernetes demoapp v1.0 !! ClientIP: {}, ServerName: {}, '
            'ServerIP: {}!\n'.format(request.remote_addr, socket.gethostname(),
                                     socket.gethostbyname(socket.gethostname())))

@app.route('/<namespace>/<serviceName>/<ip_address>')
def check_ip_in_response(namespace, serviceName, ip_address):
    credentials = AccessKeyCredential(os.environ['ALIBABA_CLOUD_ACCESS_KEY_ID'], os.environ['ALIBABA_CLOUD_ACCESS_KEY_SECRET'])

    client = AcsClient(region_id='cn-shanghai', credential=credentials)

    request = CommonRequest()
    request.set_accept_format('json')
    request.set_method('POST')
    request.set_protocol_type('https')  # https | http
    request.set_domain('edas.cn-shanghai.aliyuncs.com')
    request.set_version('2017-08-01')

    request.add_query_param('namespace', namespace)
    request.add_query_param('region', "cn-shanghai")
    request.add_query_param('serviceType', "springCloud")
    request.add_query_param('page', "0")
    request.add_query_param('size', "100")
    request.add_query_param('serviceName', serviceName)
    request.add_header('Content-Type', 'application/json')
    request.set_uri_pattern('/pop/sp/api/mseForOam/getServiceProvidersPage')

    try:
        response = client.do_action_with_exception(request)
        response_data = json.loads(response.decode('utf-8'))
        ips_in_content = [provider['Ip'] for provider in response_data['Data']['Content']]
        result = ip_address in ips_in_content
        return flask_jsonify(result=result)
    except Exception as e:
        return str(e), 500


def main(argv):
    port = 8888
    host = '0.0.0.0'
    debug = False

    if os.environ.get('PORT') is not None:
        port = os.environ.get('PORT')

    if os.environ.get('HOST') is not None:
        host = os.environ.get('HOST')

    try:
        opts, args = getopt.getopt(argv, "vh:p:", ["verbose", "host=", "port="])
    except getopt.GetoptError:
        print('server.py -p <portnumber>')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-p", "--port"):
            port = arg
        elif opt in ("-h", "--host"):
            host = arg
        elif opt in ("-v", "--verbose"):
            debug = True

    app.run(host=str(host), port=int(port), debug=bool(debug))


if __name__ == "__main__":
    main(sys.argv[1:])

########################################################################################################################
#!!
#! @description: This flow makes a POST call to Qualys API: /api/2.0/fo/asset/host/vm/detection/?action=list
#!               Returns an XML output
#!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#! @input truncation_limit: (Optional) Maximum number of host records processed per request.
#! @input show_qds: (Optional) Show the QDS value for each detection record.
#! @input show_results: (Optional) Controls the inclusion of results in the output.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ''
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input keystore: Optional - The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Default value: ''
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: Optional - The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input execution_timeout: Optional - Time in seconds to wait for the operation to finish executing.
#!                           Default: '0' (infinite timeout)
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established.
#!                         Default: '0' (infinite)
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.vm
flow:
  name: get_host_detection_list
  inputs:
    - qualys_base_url: "${get_sp('io.cloudslang.qualys.base_url')}"
    - qualys_username: "${get_sp('io.cloudslang.qualys.username')}"
    - qualys_password: "${get_sp('io.cloudslang.qualys.password')}"
    - ids:
        required: false
    - status:
        required: false
    - id_min:
        required: false
    - detection_updated_since:
        required: false
    - truncation_limit:
        required: false
    - show_qds:
        default: '1'
        required: false
    - show_qds_factors:
        default: '1'
        required: false
    - show_results:
        default: '0'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
    - keystore:
        default: "${get_sp('io.cloudslang.base.http.keystore')}"
        required: false
    - keystore_password:
        default: "${get_sp('io.cloudslang.base.http.keystore_password')}"
        required: false
        sensitive: true
    - execution_timeout:
        required: false
    - connect_timeout:
        default: '0'
        required: false
  workflow:
    - qualys_host_detection_query_params:
        do:
          io.cloudslang.qualys.utils.qualys_host_detection_query_params:
            - detection_updated_since: '${detection_updated_since}'
            - status: '${status}'
            - truncation_limit: '${truncation_limit}'
            - show_results: '${show_results}'
            - show_qds: '${show_qds}'
            - show_qds_factors: '${show_qds_factors}'
            - ids: '${ids}'
            - id_min: '${id_min}'
        publish:
          - query_params
        navigate:
          - SUCCESS: http_client_post
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://' + qualys_base_url + '/api/2.0/fo/asset/host/vm/detection/'}"
            - auth_type: Basic
            - username: '${qualys_username}'
            - password:
                value: '${qualys_password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - execution_timeout: '${execution_timeout}'
            - connect_timeout: '${connect_timeout}'
            - headers: 'X-Requested-With: ACE'
            - query_params: '${query_params}'
        publish:
          - return_result
          - status_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      qualys_host_detection_query_params:
        x: 40
        'y': 120
      http_client_post:
        x: 280
        'y': 120
        navigate:
          be9d1d5b-6a65-8c5b-0012-71b34e947739:
            targetId: e475f956-01e7-ac78-dbcc-b915390e6467
            port: SUCCESS
    results:
      SUCCESS:
        e475f956-01e7-ac78-dbcc-b915390e6467:
          x: 520
          'y': 120

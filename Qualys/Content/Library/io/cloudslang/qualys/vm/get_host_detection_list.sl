########################################################################################################################
#!!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input show_results: (Optional) Controls the inclusion of results in the output.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.vm
flow:
  name: get_host_detection_list
  inputs:
    - qualys_base_url: "${get_sp('base_url')}"
    - qualys_username: "${get_sp('username')}"
    - qualys_password: "${get_sp('password')}"
    - ids:
        required: false
    - show_results:
        default: '0'
        required: false
    - status:
        required: false
    - id_min:
        required: false
    - detection_updated_since:
        required: false
  workflow:
    - qualys_host_detection_query_params:
        do:
          io.cloudslang.qualys.utils.qualys_host_detection_query_params:
            - include_vuln_type: '${include_vuln_type}'
            - detection_updated_since: '${detection_updated_since}'
            - status: '${status}'
            - show_results: '${show_results}'
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
            - headers: 'X-Requested-With: ACE'
            - query_params: '${query_params}'
        publish:
          - return_result
          - status_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
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
        x: 240
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

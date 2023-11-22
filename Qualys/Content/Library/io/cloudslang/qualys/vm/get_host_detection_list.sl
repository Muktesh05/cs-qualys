########################################################################################################################
#!!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#! @input truncation_limit: (Optional) Maximum number of host records processed per request.
#! @input show_qds: (Optional) Show the QDS value for each detection record.
#! @input show_results: (Optional) Controls the inclusion of results in the output.
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
    - show_qds: '1'
    - show_qds_factors: '1'
    - show_results:
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

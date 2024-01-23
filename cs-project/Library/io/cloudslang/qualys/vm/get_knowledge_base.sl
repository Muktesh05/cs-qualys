########################################################################################################################
#!!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.vm
flow:
  name: get_knowledge_base
  inputs:
    - qualys_base_url: "${get_sp('io.cloudslang.qualys.base_url')}"
    - qualys_username: "${get_sp('io.cloudslang.qualys.username')}"
    - qualys_password:
        default: "${get_sp('io.cloudslang.qualys.password')}"
        sensitive: true
    - ids:
        required: false
    - id_min:
        required: false
    - details:
        required: false
    - id_max:
        required: false
  workflow:
    - qualys_knowledge_base_query_params:
        do:
          io.cloudslang.qualys.utils.qualys_knowledge_base_query_params:
            - details: '${details}'
            - ids: '${ids}'
            - id_min: '${id_min}'
            - id_max: '${id_max}'
        publish:
          - query_params
        navigate:
          - SUCCESS: http_client_post
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://' + qualys_base_url + '/api/2.0/fo/knowledge_base/vuln/'}"
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
  outputs:
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      qualys_knowledge_base_query_params:
        x: 40
        'y': 80
      http_client_post:
        x: 280
        'y': 80
        navigate:
          be9d1d5b-6a65-8c5b-0012-71b34e947739:
            targetId: e475f956-01e7-ac78-dbcc-b915390e6467
            port: SUCCESS
    results:
      SUCCESS:
        e475f956-01e7-ac78-dbcc-b915390e6467:
          x: 520
          'y': 80

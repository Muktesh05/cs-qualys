namespace: io.cloudslang.qualys.vm
flow:
  name: get_host_list
  inputs:
    - qualys_base_url: "${get_sp('base_url')}"
    - qualys_username: "${get_sp('username')}"
    - qualys_password:
        default: "${get_sp('password')}"
        sensitive: true
  workflow:
    - host_list_inputs_to_json:
        do:
          io.cloudslang.qualys.utils.host_list_inputs_to_json:
            - details: Basic
            - truncation_limit: '10'
            - vm_scan_date_after: '2019-08-08'
            - show_tags: '0'
        publish:
          - inputs_json
        navigate:
          - SUCCESS: http_client_post
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://' + qualys_base_url + '/api/2.0/fo/asset/host/'}"
            - auth_type: Basic
            - username: '${qualys_username}'
            - password:
                value: '${qualys_password}'
                sensitive: true
            - headers: 'X-Requested-With: ACE'
            - body: '${inputs_json}'
            - content_type: application/json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 400
        'y': 120
        navigate:
          8a18973a-81ef-dc36-de96-50b14b13b766:
            targetId: f2d30c69-0ab2-2aaa-84cf-d3eeec43b6ad
            port: SUCCESS
      host_list_inputs_to_json:
        x: 80
        'y': 120
    results:
      SUCCESS:
        f2d30c69-0ab2-2aaa-84cf-d3eeec43b6ad:
          x: 640
          'y': 120

########################################################################################################################
#!!
#! @input action: (Required)
#! @input details: (Optional) Show the requested amount of host information for each host. Valid values are Basic, Basic/AGs, All, All/AGs, or None.
#! @input truncation_limit: (Optional) Specify the maximum number of host records processed per request. Default is 1000, can be adjusted to a lower or higher value.
#! @input vm_scan_date_after: (Optional) Show hosts with a vulnerability scan end date after a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input show_tags: (Optional) Specify 1 to display asset tags associated with each host in output.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.vm
flow:
  name: get_host_list
  inputs:
    - qualys_base_url: "${get_sp('io.cloudslang.qualys.base_url')}"
    - qualys_username: "${get_sp('io.cloudslang.qualys.username')}"
    - qualys_password:
        default: "${get_sp('io.cloudslang.qualys.password')}"
        sensitive: true
    - action: list
    - details: Basic
    - truncation_limit: '10'
    - vm_scan_date_after: '2019-08-08'
    - show_tags: '0'
  workflow:
    - host_list_inputs_to_json:
        do:
          io.cloudslang.qualys.utils.host_list_inputs_to_json:
            - action: '${action}'
            - details: '${details}'
            - truncation_limit: '${truncation_limit}'
            - vm_scan_date_after: '${vm_scan_date_after}'
            - show_tags: '${show_tags}'
        publish:
          - query_params
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
            - query_params: '${query_params}'
        publish:
          - return_result
          - status_code
          - error_message
        navigate:
          - SUCCESS: check_status
          - FAILURE: on_failure
    - check_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '200'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      host_list_inputs_to_json:
        x: 80
        'y': 120
      http_client_post:
        x: 320
        'y': 120
      check_status:
        x: 600
        'y': 120
        navigate:
          629fbd1c-8571-a4d6-614f-7971a43482c5:
            targetId: f2d30c69-0ab2-2aaa-84cf-d3eeec43b6ad
            port: SUCCESS
    results:
      SUCCESS:
        f2d30c69-0ab2-2aaa-84cf-d3eeec43b6ad:
          x: 840
          'y': 120

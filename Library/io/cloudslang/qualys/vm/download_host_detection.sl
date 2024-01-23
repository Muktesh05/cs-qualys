########################################################################################################################
#!!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input truncation_limit: (Optional) Maximum number of host records processed per request.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#! @input show_qds: (Optional) Show the QDS value for each detection record.
#! @input output_file: Path to the file to save the response.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.vm
flow:
  name: download_host_detection
  inputs:
    - base_url: "${get_sp('io.cloudslang.qualys.base_url')}"
    - username: "${get_sp('io.cloudslang.qualys.username')}"
    - password:
        default: "${get_sp('io.cloudslang.qualys.password')}"
        sensitive: true
    - ids:
        required: false
    - truncation_limit:
        required: false
    - id_min:
        required: false
    - show_qds:
        default: '1'
        required: false
    - show_qds_factors:
        default: '1'
        required: false
    - output_file:
        default: "C:\\response.xml"
        required: false
  workflow:
    - qualys_host_detection_query_params:
        do:
          io.cloudslang.qualys.utils.qualys_host_detection_query_params:
            - ids: '${ids}'
            - truncation_limit: '${truncation_limit}'
            - id_min: '${id_min}'
            - show_qds: '${show_qds}'
            - show_qds_factors: '${show_qds_factors}'
            - show_results: '0'
            - output_format: XML
        publish:
          - query_params
        navigate:
          - SUCCESS: download_host_detection_stream
    - download_host_detection_stream:
        do:
          io.cloudslang.qualys.vm.download_host_detection_stream:
            - url: "${'https://' + base_url + '/api/2.0/fo/asset/host/vm/detection/'}"
            - query_params: '${query_params}'
            - headers: 'X-Requested-With: ACE'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - output_file: '${output_file.strip()}'
        publish:
          - response_code
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
        x: 80
        'y': 160
      download_host_detection_stream:
        x: 360
        'y': 160
        navigate:
          971a9556-15c7-dac9-4be2-05d9e34b32ca:
            targetId: 42756394-f5ac-725a-ca01-358946076632
            port: SUCCESS
    results:
      SUCCESS:
        42756394-f5ac-725a-ca01-358946076632:
          x: 600
          'y': 160

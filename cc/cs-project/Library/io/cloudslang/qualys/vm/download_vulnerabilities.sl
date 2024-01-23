########################################################################################################################
#!!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input output_file: Path to the file to save the response.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.vm
flow:
  name: download_vulnerabilities
  inputs:
    - base_url: "${get_sp('io.cloudslang.qualys.base_url')}"
    - username:
        default: "${get_sp('io.cloudslang.qualys.username')}"
        required: true
    - password:
        default: "${get_sp('io.cloudslang.qualys.password')}"
        sensitive: true
    - ids:
        required: false
    - details:
        required: false
    - output_file
    - id_min:
        required: false
    - id_max:
        required: false
  workflow:
    - qualys_knowledge_base_query_params:
        do:
          io.cloudslang.qualys.utils.qualys_knowledge_base_query_params:
            - details: '${details}'
            - ids: '${ids.strip()}'
            - id_min: '${id_min}'
            - id_max: '${id_max}'
        publish:
          - query_params
        navigate:
          - SUCCESS: download_vulnerabilities_stream
    - download_vulnerabilities_stream:
        do:
          io.cloudslang.qualys.vm.download_host_detection_stream:
            - url: "${'https://' + base_url + '/api/2.0/fo/knowledge_base/vuln/'}"
            - query_params: '${query_params}'
            - headers: 'X-Requested-With: ACE'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - output_file: '${output_file.replace(" ","")}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      qualys_knowledge_base_query_params:
        x: 80
        'y': 160
      download_vulnerabilities_stream:
        x: 360
        'y': 160
        navigate:
          210a2031-499a-aac0-a05d-8f1d3f4ed1cf:
            targetId: 8c146a1b-afad-54c2-aeed-e4728d9e81ac
            port: SUCCESS
    results:
      SUCCESS:
        8c146a1b-afad-54c2-aeed-e4728d9e81ac:
          x: 640
          'y': 160

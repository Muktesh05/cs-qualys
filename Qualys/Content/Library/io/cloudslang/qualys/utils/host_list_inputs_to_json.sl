namespace: io.cloudslang.qualys.utils
operation:
  name: host_list_inputs_to_json
  inputs:
    - action
    - echo_request:
        required: false
    - show_asset_id:
        required: false
    - details:
        required: false
    - os_pattern:
        required: false
    - truncation_limit:
        required: false
    - ips:
        required: false
    - ipv6:
        required: false
    - ag_ids:
        required: false
    - ids:
        required: false
    - id_min:
        required: false
    - id_max:
        required: false
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute():
          # code goes here
      # you can add additional helper methods below.
  results:
    - SUCCESS

namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_host_detection_query_params
  inputs:
    - action
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(action):
          parameters = []
          if action: parameters.append("action=" + str(action))
          parameter_string = '&'.join(parameters)

          return {"query_params": parameter_string}
      # you can add additional helper methods below.
  outputs:
    - query_params
  results:
    - SUCCESS


########################################################################################################################
#!!
#! @input action: (Required) The action to perform, typically 'list'.
#! @input echo_request: (Optional) Specify 1 to view input parameters in the XML output.
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#!!#
########################################################################################################################

namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_knowledge_base_query_params
  inputs:
    - action: list
    - echo_request:
        required: false
    - details:
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
      def execute(action, echo_request, details, ids, id_min, id_max):
          params = {key: value for key, value in locals().items() if value}
          query_string = '&'.join(f"{key}={value}" for key, value in params.items())
          return {"query_params": query_string}
  outputs:
    - query_params
  results:
    - SUCCESS

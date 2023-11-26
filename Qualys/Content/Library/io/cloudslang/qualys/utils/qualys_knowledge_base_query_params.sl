
########################################################################################################################
#!!
#! @input action: (Required) The action to perform, typically 'list'.
#! @input echo_request: (Optional) Specify 1 to view input parameters in the XML output.
#! @input details: (Optional) Show the requested amount of information for each vulnerability in the XML output. A valid value is: Basic (default), All, or None. Basic includes basic elements plus CVSS Base and Temporal scores. All includes all vulnerability details, including the Basic details.
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#! @input id_max: (Optional) Used to filter the XML output to show only vulnerabilities that have a QID number less than or equal to a QID number you specify.
#! @input last_modified_after: (Optional) Used to filter the XML output to show only vulnerabilities last modified after a certain date and time. When specified vulnerabilities last modified by a user or by the service will be shown. The date/time is specified in YYYY-MM-DD[THH:MM:SSZ] format (UTC/GMT).
#! @input published_after: (Optional) Used to filter the XML output to show only vulnerabilities published after a certain date and time. The date/time is specified in YYYY-MM-DD[THH:MM:SSZ] format (UTC/GMT).
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
    - last_modified_after:
        required: false
    - published_after:
        required: false
  python_action:
    use_jython: false
    script: |-
      def execute(action, echo_request, details, ids, id_min, id_max, last_modified_after, published_after):
          params = {key: value for key, value in locals().items() if value}
          query_string = '&'.join(f"{key}={value}" for key, value in params.items())
          return {"query_params": query_string}
  outputs:
    - query_params
  results:
    - SUCCESS

########################################################################################################################
#!!
#! @input action: (Required)
#! @input echo_request: (Optional) Specify 1 to view input parameters in the XML output. When unspecified, parameters are not included in the XML output.
#!!#
########################################################################################################################
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
    - ag_titles:
        required: false
    - ids:
        required: false
    - id_min:
        required: false
    - id_max:
        required: false
    - network_ids:
        required: false
    - compliance_enabled:
        required: false
    - no_vm_scan_since:
        required: false
    - no_compliance_scan_since:
        required: false
    - vm_scan_since:
        required: false
    - compliance_scan_since:
        required: false
    - vm_processed_before:
        required: false
    - vm_processed_after:
        required: false
    - vm_scan_date_before:
        required: false
    - vm_scan_date_after:
        required: false
    - vm_auth_scan_date_before:
        required: false
    - vm_auth_scan_date_after:
        required: false
    - scap_scan_since:
        required: false
    - no_scap_scan_since:
        required: false
    - use_tags:
        required: false
    - tag_set_by:
        required: false
    - tag_include_selector:
        required: false
    - tag_exclude_selector:
        required: false
    - tag_set_include:
        required: false
    - tag_set_exclude:
        required: false
    - show_tags:
        required: false
    - show_ars:
        required: false
    - ars_min:
        required: false
    - ars_max:
        required: false
    - show_ars_factors:
        required: false
    - show_trurisk:
        required: false
    - trurisk_min:
        required: false
    - trurisk_max:
        required: false
    - show_trurisk_factors:
        required: false
    - host_metadata:
        required: false
    - host_metadata_fields:
        required: false
    - show_cloud_tags:
        required: false
    - cloud_tag_fields:
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

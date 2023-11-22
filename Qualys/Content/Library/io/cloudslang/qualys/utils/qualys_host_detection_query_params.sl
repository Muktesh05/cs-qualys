
########################################################################################################################
#!!
#! @input action: (Required) The action to perform, typically 'list'.
#! @input echo_request: (Optional) Specify 1 to view input parameters in the XML output.
#! @input show_asset_id: (Optional) Shows the asset ID of the scanned hosts in the output.
#! @input include_vuln_type: (Optional) Download vulnerability information based on their type.
#! @input show_results: (Optional) Controls the inclusion of results in the output.
#! @input show_reopened_info: (Optional) Includes reopened info for reopened vulnerabilities.
#! @input arf_kernel_filter: (Optional) Identify vulnerabilities on Linux kernels.
#! @input arf_service_filter: (Optional) Identify vulnerabilities on ports/services.
#! @input arf_config_filter: (Optional) Identify vulnerabilities based on host configuration.
#! @input output_format: (Optional) Specifies the format of the output.
#! @input truncation_limit: (Optional) Maximum number of host records processed per request.
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#! @input ips: (Optional) Show only certain IP addresses/ranges.
#! @input ag_ids: (Optional) Show only hosts belonging to specified asset groups.
#! @input network_ids: (Optional) Restrict request to certain custom network IDs.
#! @input vm_scan_since: (Optional) Show hosts scanned since a specific date and time.
#! @input no_vm_scan_since: (Optional) Show hosts not scanned since a specific date and time.
#! @input vm_scan: (Optional) Show hosts scanned within a specified number of days.
#! @input before: (Optional) Show hosts with vulnerability scan results processed before a specific date and time.
#! @input compliance_enabled: (Optional) Valid only when the policy compliance module is enabled.
#! @input os_pattern: (Optional) Show hosts with operating systems matching a regex pattern.
#! @input qids: (Optional) Show detection records with certain QIDs.
#! @input severities: (Optional) Show detection records with certain severities.
#! @input show_igs: (Optional) Specify 1 to show information gathered along with vulnerabilities.
#! @input titles: (Optional) Show detection records based on search list titles.
#! @input filter_superseded_qids: (Optional) Filter out QIDs that have been superseded.
#! @input use_tags: (Optional) Select hosts based on asset tags.
#! @input tag_set_by: (Optional) Select a tag set by providing tag IDs or names.
#! @input tag_include_selector: (Optional) Include hosts that match selected tags.
#! @input tag_exclude_selector: (Optional) Exclude hosts that match selected tags.
#! @input tag_set_include: (Optional) Specify a tag set to include hosts.
#! @input tag_set_exclude: (Optional) Specify a tag set to exclude hosts.
#! @input show_tags: (Optional) Display asset tags associated with each host.
#! @input show_qds: (Optional) Show the QDS value for each detection record.
#!!#
########################################################################################################################

namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_host_detection_query_params
  inputs:
    - action
    - echo_request:
        required: false
    - show_asset_id:
        required: false
    - include_vuln_type:
        required: false
    - show_results:
        required: false
    - show_reopened_info:
        required: false
    - arf_kernel_filter:
        required: false
    - arf_service_filter:
        required: false
    - arf_config_filter:
        required: false
    - output_format:
        required: false
    - truncation_limit:
        required: false
    - ids:
        required: false
    - id_min:
        required: false
    - ips:
        required: false
    - ag_ids:
        required: false
    - network_ids:
        required: false
    - vm_scan_since:
        required: false
    - no_vm_scan_since:
        required: false
    - vm_scan:
        required: false
    - before:
        required: false
    - compliance_enabled:
        required: false
    - os_pattern:
        required: false
    - qids:
        required: false
    - severities:
        required: false
    - show_igs:
        required: false
    - titles:
        required: false
    - filter_superseded_qids:
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
    - show_qds:
        required: false
  python_action:
    use_jython: false
    script: |-
      def execute(action, echo_request, show_asset_id, include_vuln_type, show_results, show_reopened_info, arf_kernel_filter, arf_service_filter, arf_config_filter, output_format, truncation_limit, ids, id_min, ips, ag_ids, network_ids, vm_scan_since, no_vm_scan_since, vm_scan, before, compliance_enabled, os_pattern, qids, severities, show_igs, titles, filter_superseded_qids, use_tags, tag_set_by, tag_include_selector, tag_exclude_selector, tag_set_include, tag_set_exclude, show_tags, show_qds):
          params = {key: value for key, value in locals().items() if value}
          query_string = '&'.join(f"{key}={value}" for key, value in params.items())
          return {"query_params": query_string}
  outputs:
    - query_params
  results:
    - SUCCESS

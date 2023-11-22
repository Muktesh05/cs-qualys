
########################################################################################################################
# Qualys Host Detection API CloudSlang Operation
# This operation constructs a query for the Qualys Host Detection API based on provided input parameters.
#
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
########################################################################################################################

namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_host_detection_query_params
  inputs:
    - action: list
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
    script: |-
      # do not remove the execute function
      def execute(action, echo_request, show_asset_id, include_vuln_type, show_results, show_reopened_info, arf_kernel_filter, arf_service_filter, arf_config_filter, output_format, truncation_limit, ids, id_min, ips, ag_ids, network_ids, vm_scan_since, no_vm_scan_since, vm_scan, before, compliance_enabled, os_pattern, qids, severities, show_igs, titles, filter_superseded_qids, use_tags, tag_set_by, tag_include_selector, tag_exclude_selector, tag_set_include, tag_set_exclude, show_tags, show_qds):
          parameters = []
          if action: parameters.append("action=" + str(action))
          if echo_request: parameters.append("echo_request=" + str(echo_request))
          if show_asset_id: parameters.append("show_asset_id=" + str(show_asset_id))
          if include_vuln_type: parameters.append("include_vuln_type=" + str(include_vuln_type))
          if show_results: parameters.append("show_results=" + str(show_results))
          if show_reopened_info: parameters.append("show_reopened_info=" + str(show_reopened_info))
          if arf_kernel_filter: parameters.append("arf_kernel_filter=" + str(arf_kernel_filter))
          if arf_service_filter: parameters.append("arf_service_filter=" + str(arf_service_filter))
          if arf_config_filter: parameters.append("arf_config_filter=" + str(arf_config_filter))
          if output_format: parameters.append("output_format=" + str(output_format))
          if truncation_limit: parameters.append("truncation_limit=" + str(truncation_limit))
          if ids: parameters.append("ids=" + str(ids))
          if id_min: parameters.append("id_min=" + str(id_min))
          if ips: parameters.append("ips=" + str(ips))
          if ag_ids: parameters.append("ag_ids=" + str(ag_ids))
          if network_ids: parameters.append("network_ids=" + str(network_ids))
          if vm_scan_since: parameters.append("vm_scan_since=" + str(vm_scan_since))
          if no_vm_scan_since: parameters.append("no_vm_scan_since=" + str(no_vm_scan_since))
          if vm_scan: parameters.append("vm_scan=" + str(vm_scan))
          if before: parameters.append("before=" + str(before))
          if compliance_enabled: parameters.append("compliance_enabled=" + str(compliance_enabled))
          if os_pattern: parameters.append("os_pattern=" + str(os_pattern))
          if qids: parameters.append("qids=" + str(qids))
          if severities: parameters.append("severities=" + str(severities))
          if show_igs: parameters.append("show_igs=" + str(show_igs))
          if titles: parameters.append("titles=" + str(titles))
          if filter_superseded_qids: parameters.append("filter_superseded_qids=" + str(filter_superseded_qids))
          if use_tags: parameters.append("use_tags=" + str(use_tags))
          if tag_set_by: parameters.append("tag_set_by=" + str(tag_set_by))
          if tag_include_selector: parameters.append("tag_include_selector=" + str(tag_include_selector))
          if tag_exclude_selector: parameters.append("tag_exclude_selector=" + str(tag_exclude_selector))
          if tag_set_include: parameters.append("tag_set_include=" + str(tag_set_include))
          if tag_set_exclude: parameters.append("tag_set_exclude=" + str(tag_set_exclude))
          if show_tags: parameters.append("show_tags=" + str(show_tags))
          if show_qds: parameters.append("show_qds=" + str(show_qds))
          print query_string
          query_string = '&'.join(parameters)
          return {"query_params": query_string}
  outputs:
    - query_params
  results:
    - SUCCESS

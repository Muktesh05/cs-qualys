########################################################################################################################
#!!
#! @input action: (Required)
#! @input echo_request: (Optional) Specify 1 to view input parameters in the XML output. When unspecified, parameters are not included in the XML output.
#! @input show_asset_id: (Optional) When specified, shows the asset ID of the scanned hosts in the output. 
#! @input details: (Optional) Show the requested amount of host information for each host. Valid values are Basic, Basic/AGs, All, All/AGs, or None.
#! @input os_pattern: (Optional) Show only hosts which have an operating system matching a certain regular expression. Must be URL encoded.
#! @input truncation_limit: (Optional) Specify the maximum number of host records processed per request. Default is 1000, can be adjusted to a lower or higher value.
#! @input ips: (Optional) Show only certain IP addresses/ranges. One or more IPs/ranges may be specified, comma separated.
#! @input ipv6: (Optional) A valid IPv6 address. Multiple entries are comma separated. Note: Other filter parameters are not accepted when using this filter.
#! @input ag_ids: (Optional) Show only hosts belonging to asset groups with certain IDs. Multiple entries are comma separated.
#! @input ag_titles: (Optional) Show only hosts belonging to asset groups with certain titles. Multiple entries are comma separated.
#! @input ids: (Optional) Show only certain host IDs/ranges. Multiple entries are comma separated.
#! @input id_min: (Optional) Show only hosts which have a minimum host ID value.
#! @input id_max: (Optional) Show only hosts which have a maximum host ID value.
#! @input network_ids: (Optional, valid when Network Support enabled) Restrict request to certain custom network IDs.
#! @input compliance_enabled: (Optional, valid when policy compliance module enabled) Filter scanned hosts list for compliance or vulnerability management hosts.
#! @input no_vm_scan_since: (Optional) Show hosts not scanned for vulnerabilities since a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input no_compliance_scan_since: (Optional) Show compliance hosts not scanned since a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input vm_scan_since: (Optional) Show hosts last scanned for vulnerabilities since a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input compliance_scan_since: (Optional) Show hosts last scanned for compliance since a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input vm_processed_before: (Optional) Show hosts with vulnerability scan results processed before a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input vm_processed_after: (Optional) Show hosts with vulnerability scan results processed after a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input vm_scan_date_before: (Optional) Show hosts with a vulnerability scan end date before a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input vm_scan_date_after: (Optional) Show hosts with a vulnerability scan end date after a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input vm_auth_scan_date_before: (Optional) Show hosts with a successful authenticated vulnerability scan end date before a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input vm_auth_scan_date_after: (Optional) Show hosts with a successful authenticated vulnerability scan end date after a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input scap_scan_since: (Optional) Show hosts last scanned for SCAP since a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input no_scap_scan_since: (Optional) Show hosts not scanned for SCAP since a specified date (YYYY-MM-DD[THH:MM:SSZ] format).
#! @input use_tags: (Optional) Specify 0 to select hosts based on IPs/ranges and asset groups, or 1 for asset tags.
#! @input tag_set_by: (Optional, when use_tags=1) Specify “id” to select a tag set by IDs or “name” for tag names.
#! @input tag_include_selector: (Optional, when use_tags=1) Select “any” to include hosts matching any tags, or “all” for all tags.
#! @input tag_exclude_selector: (Optional, when use_tags=1) Select “any” to exclude hosts matching any tags, or “all” for all tags.
#! @input tag_set_include: (Optional, when use_tags=1) Specify tag set to include, identifying by tag names or IDs.
#! @input tag_set_exclude: (Optional, when use_tags=1) Specify tag set to exclude, identifying by tag names or IDs.
#! @input show_tags: (Optional) Specify 1 to display asset tags associated with each host in output.
#! @input show_ars: (Optional) Specify 1 to show the Asset Risk Score (ARS) in output.
#! @input ars_min: (Optional, when show_ars=1) Show only assets with an ARS value greater than or equal to specified minimum.
#! @input ars_max: (Optional, when show_ars=1) Show only assets with an ARS value less than or equal to specified maximum.
#! @input show_ars_factors: (Optional) Specify 1 to show ARS contributing factors associated with each asset.
#! @input show_trurisk: (Optional) Specify 1 to show the TruRisk value in output.
#! @input trurisk_min: (Optional, when show_trurisk=1) Show only assets with a TruRisk value greater than or equal to specified minimum.
#! @input trurisk_max: (Optional, when show_trurisk=1) Show only assets with a TruRisk value less than or equal to specified maximum.
#! @input show_trurisk_factors: (Optional) Specify 1 to show TruRisk contributing factors associated with each asset.
#! @input host_metadata: (Optional) Specify "all" to list all cloud assets with their metadata or a cloud provider's name for specific assets.
#! @input host_metadata_fields: (Optional, when host_metadata is specified) Specify metadata fields to return data for certain attributes.
#! @input show_cloud_tags: (Optional) Specify 1 to display cloud provider tags for each scanned host asset in the output.
#! @input cloud_tag_fields: (Optional, when show_cloud_tags is specified) Specify cloud tags or combinations to return information for specified tags.
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

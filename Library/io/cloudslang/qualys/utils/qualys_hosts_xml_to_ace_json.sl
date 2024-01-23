namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_hosts_xml_to_ace_json
  inputs:
    - xml_input
    - base_url
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(input_string, elements):
          import re
          import os
          import xml.sax
          from xml.sax import SAXException
          import uuid
          import json

          class QualysHostListHandler(xml.sax.ContentHandler):
              INT_TAGS = {"ID", "ASSET_ID", "UNIQUE_VULN_ID", "QID",
                          "SEVERITY", "TIMES_FOUND", "IS_IGNORED",
                          "IS_DISABLED", "SSL", "CODE"}
              STRING_TAGS = {"DATETIME", "IP", "TRACKING_METHOD", "DNS",
                             "OS", "HOSTNAME", "DOMAIN", "FQDN", "LAST_SCAN_DATETIME",
                             "LAST_VM_SCANNED_DATE", "LAST_VM_SCANNED_DURATION",
                             "LAST_VM_AUTH_SCANNED_DATE", "LAST_VM_AUTH_SCANNED_DURATION",
                             "TYPE", "STATUS", "RESULTS", "FIRST_FOUND_DATETIME",
                             "LAST_FOUND_DATETIME", "LAST_TEST_DATETIME",
                             "LAST_UPDATE_DATETIME", "LAST_PROCESSED_DATETIME",
                             "TEXT", "URL", "SERIAL_NUMBER",
                             "HARDWARE_UUID", "FIRST_FOUND_DATE",
                             "FIST_FOUND_DATE",  # TODO remove
                             "LAST_BOOT"}
              DICT_TAGS = {"HOST_LIST_OUTPUT", "HOST_LIST_VM_DETECTION_OUTPUT",
                           "RESPONSE", "DNS_DATA", "WARNING"}
              LIST_TAGS = {"HOST_LIST", "DETECTION_LIST"}
              LIST_ITEM_TAGS = {"HOST", "DETECTION"}

              skip_comma = True
              last_tag_type = ""

              def __init__(self, root_tag, skip_tags, file_id, max_size):
                  super().__init__()
                  self.root_tag = root_tag
                  self.fileCount = 0
                  self.skip_tags = skip_tags
                  self.max_size = max_size
                  self.fileId = file_id
                  self.fileName = "ace-"+self.fileId+"-"+str(self.fileCount)+".json"
                  self.file = open(self.fileName, "wt")
                  # self.file.write('{"%s":{' % self.root_tag)
                  self.file.write('{')
                  # xml.sax sometimes splits a CDATA section in multiple strings
                  # so, we store the value here and write it before the end tag
                  self.current_value = ""
                  # additional results
                  self.id_min = ""
                  self.warning_code = ""
                  self.warning_url = ""

              def startElement(self, q_name, attributes):
                  if q_name in self.skip_tags:
                      return
                  self.last_tag_type = ""
                  if q_name in self.INT_TAGS:
                      self.last_tag_type = "INT"
                  if not self.skip_comma:
                      self.file.write(',')
                  q_name_lower = q_name.lower()
                  # O(n) operation in lists and tuples, but an O(1) operation in sets and dicts
                  if q_name in self.STRING_TAGS or q_name in self.INT_TAGS:
                      value = '"%s":' % q_name_lower
                      self.skip_comma = False
                  elif q_name in self.DICT_TAGS:
                      value = '"%s":{' % q_name_lower
                      self.skip_comma = True
                  elif q_name in self.LIST_TAGS:
                      value = '"%s":[' % q_name_lower
                      self.skip_comma = True
                  elif q_name in self.LIST_ITEM_TAGS:
                      value = '{'
                      self.skip_comma = True
                  else:
                      raise SAXException("Unknown tag " + q_name)
                  self.file.write(value)
                  self.current_value = ''

              def endElement(self, q_name):
                  if q_name in self.skip_tags:
                      return
                  if q_name in self.INT_TAGS or q_name in self.STRING_TAGS:
                      value = self.current_value
                  elif q_name in self.DICT_TAGS or q_name in self.LIST_ITEM_TAGS:
                      value = '}'
                      if(q_name == "HOST"):
                          self.file.seek(0, os.SEEK_END)
                          if(self.file.tell() >= self.max_size):
                              value = ''
                              self.skip_comma = True
                              self.file.write("}]}")
                              self.file.close()
                              self.fileCount += 1
                              self.fileName = "ace-"+self.fileId+"-"+str(self.fileCount)+".json"
                              self.file = open(self.fileName, "wt")
                              # self.file.write('{"%s":{"%s": [' % (self.root_tag, "host_list"))
                              self.file.write('{"%s": [' % ("host_list"))
                  elif q_name in self.LIST_TAGS:
                      value = ']'
                  else:
                      raise SAXException("Unknown tag " + q_name)
                  self.file.write(value)

                  # we assume that the output is sorted by IDs
                  if q_name == "ID" and self.id_min == -1:
                      self.id_min = self.current_value

                  if q_name == "CODE":
                      self.warning_code = self.current_value

                  if q_name == "URL":
                      self.warning_url = self.current_value
                      self.id_min = get_id_min_from_warning_url(self.warning_url)

                  self.current_value = ''

              def characters(self, content):
                  value = content.strip()
                  if not value:
                      return
                  if not self.last_tag_type == "INT":
                      if self.current_value:
                          # removing the last quote and concatenating
                          self.current_value = self.current_value[:-1] + '%s"' % value
                      else:
                          self.current_value = '"%s"' % value
                  else:
                     self.current_value = value

              def end(self):
                  self.file.write("}")


          def get_id_min_from_warning_url(warning_url):
              if warning_url is not None:
                  match = re.search(r'id_min=(\d+)', warning_url)
                  # Extract and return the value if found
                  if match:
                      return match.group(1)

          # ========================================================= #
          # TO DO                                                     #
          # Define an execute method here to use it as an operation   #
          # ========================================================= #

          def main():
              with open("response3.xml", "rb") as input_file:
                  max_size = 1024 * 1024 * 0.8
                  file_id = uuid.uuid4().hex[:6]
                  handler = QualysHostListHandler("ace_json",
                                                  ["HOST_LIST_OUTPUT", "RESPONSE", "WARNING", "CODE", "TEXT", "URL"],
                                                  file_id, max_size)
                  xml.sax.parse(input_file, handler=handler)
                  handler.end()
                  print(max_size)
                  file_list = []
                  for i in range(handler.fileCount + 1):
                      file_list.append("ace-%s-%s.json" % (file_id, i))
              return {
                  "acx_json_chunks": file_list
              }

          if __name__ == "__main__":
              print(main())

    outputs:
      - acx_json_chunks
  results:
    - SUCCESS

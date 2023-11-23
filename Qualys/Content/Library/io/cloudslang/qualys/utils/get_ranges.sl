namespace: io.cloudslang.qualys.utils
operation:
  name: get_ranges
  inputs:
    - input_string
    - elements
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(input_string, elements):
           # Convert the string to a list of integers
          numbers = list(map(int, input_string.split(',')))

          # Sort the list
          numbers.sort()
          elements_int = int(elements)

          # Create ranges of up to 500 elements
          range_list = []
          for i in range(0, len(numbers), elements_int):
              # Determine the end of the current range
              range_end = min(i + elements_int, len(numbers))

              # Format the range as a string: "first_element - last_element"
              range_str = f"{numbers[i]}-{numbers[range_end - 1]}"
              range_list.append(range_str)

          return {"range_list":str(range_list)[1:-1].replace("'","")}
      # you can add additional helper methods below.
  outputs:
    - range_list
  results:
    - SUCCESS

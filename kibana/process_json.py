import json
import os

def read_json_file(input_file):
    with open(input_file, 'r') as f:
        return json.load(f)

def write_json_files(records, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for record in records:
        filename = f"{record['time'].replace(':', '-').replace('.', '-')}.json"
        filepath = os.path.join(output_dir, filename)
        with open(filepath, 'w') as f:
            json.dump(record, f, indent=2)
            f.write('\n')

def process_json_file(input_file, output_dir):
    data = read_json_file(input_file)
    write_json_files(data['records'], output_dir)

input_file = 'input.json'
output_dir = 'output_files'

process_json_file(input_file, output_dir)

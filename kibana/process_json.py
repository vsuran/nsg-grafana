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

def process_all_json_files(logs_dir, output_dir):
    for file_name in os.listdir(logs_dir):
        if file_name.endswith('.json'):
            input_file = os.path.join(logs_dir, file_name)
            process_json_file(input_file, output_dir)

logs_dir = 'logs'
output_dir = 'output_files'

process_all_json_files(logs_dir, output_dir)

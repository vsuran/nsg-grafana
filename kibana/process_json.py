import json
import os
import glob

def read_json_file(input_file):
    try:
        with open(input_file, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: The file {input_file} does not exist.")
        return None
    except json.JSONDecodeError:
        print(f"Error: The file {input_file} is not a valid JSON.")
        return None

def write_json_files(records, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for record in records:
        filename = f"{record['time'].replace(':', '-').replace('.', '-')}.json"
        filepath = os.path.join(output_dir, filename)
        try:
            with open(filepath, 'w') as f:
                json.dump(record, f, indent=2)
                f.write('\n')
        except IOError as e:
            print(f"Error writing to file {filepath}: {e}")

def clear_output_dir(output_dir):
    files = glob.glob(os.path.join(output_dir, '*.json'))
    for f in files:
        try:
            os.remove(f)
        except OSError as e:
            print(f"Error deleting file {f}: {e}")

def process_json_file(input_file, output_dir):
    clear_output_dir(output_dir)
    data = read_json_file(input_file)
    if data:
        write_json_files(data['records'], output_dir)

input_file = 'input.json'
output_dir = 'output_files'

process_json_file(input_file, output_dir)

import os
import sys
import json

tmp_dir_path = sys.argv[1]
with open(os.path.join(tmp_dir_path, 'answer'), 'r') as f_in:
	user_info = json.load(f_in)

proj_name = '{}_osnachos_code'.format(user_info['group_name'])
os.chdir(os.path.join('/home/ubuntu/grader_service/', 'osnachos'))
if not os.isdir(proj_name):
	os.system('git clone http://root:passw0rd@10.2.1.88/{} {}_osnachos_code'.format(user_info['git_location'], user_info['group_name']))
else:
	os.chdir(proj_name)
	os.system('git pull')

os.chdir(tmp_dir_path)
with open('response', 'w') as f_out:
	f_out.write('10\n')
	f_out.write('10\n')
	f_out.write('Good job!\n')

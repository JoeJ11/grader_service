#!/usr/bin/python
# -*- coding: ASCII -*-

import os
import sys
import json
import subprocess
import time
import shutil

import process

RAILS_ROOT = '/home/ubuntu/grader_service/'
if len(sys.argv) > 2:
	RAILS_ROOT = sys.argv[2]
GRADER_ROOT = os.path.join(RAILS_ROOT, 'nachos')

tmp_dir_path = sys.argv[1]

with open(os.path.join(tmp_dir_path, 'answer'), 'r') as f_in:
	user_info = json.load(f_in)

proj_name = '{}_osnachos_code'.format(user_info['group_name'])
os.chdir(os.path.join(RAILS_ROOT, 'osnachos'))
if not os.path.isdir(proj_name):
	os.system('git clone http://root:passw0rd@10.2.1.88/{} {}'.format(user_info['git_location'], proj_name))
	os.chdir(proj_name)
else:
	shutil.rmtree(os.path.join(RAILS_ROOT, 'osnachos', proj_name))
	os.system('git clone http://root:passw0rd@10.2.1.88/{} {}'.format(user_info['git_location'], proj_name))
	os.chdir(proj_name)
# os.system('rm -r {}/nachos/threads'.format(GRADER_ROOT))
# os.system('cp -r threads/ {}/nachos/threads/'.format(GRADER_ROOT))
# dir_util.copy_tree('threads', '{}/nachos/threads/'.format(GRADER_ROOT))
shutil.rmtree(os.path.join(RAILS_ROOT, 'nachos', 'threads'))
shutil.rmtree(os.path.join(RAILS_ROOT, 'nachos', 'userprog'))
shutil.copytree(os.path.join(RAILS_ROOT, 'osnachos', proj_name, 'threads'), os.path.join(RAILS_ROOT, 'nachos', 'threads'))
shutil.copytree(os.path.join(RAILS_ROOT, 'osnachos', proj_name, 'userprog'), os.path.join(RAILS_ROOT, 'nachos', 'userprog'))
os.chdir(os.path.join(GRADER_ROOT, 'proj2'))

os.system('make clean')
os.system('make')
os.system('make ag')

score = 0
comment = ''
tasks = {
	1:'../bin/nachos -x grade-file.coff -- nachos.ag.UserGrader1 -# \'testID=%d\'',
	2:'../bin/nachos -x grade-exec.coff -- nachos.ag.UserGrader2 -# \'testID=%d\'',
	3:'../bin/nachos -- nachos.ag.ThreadGrader6a -# lottery=true,depth=5,fanout=3,maxLocks=2,pJoin=50,release=5',
}

def grade(task, task_name):
	p = process.Command(task)
	p.start()
	while not p.stop:
		time.sleep(1)
	print 'Task {}'.format(task_name)
	if 'success' in p.out.split('\n'):
		return True, '<p>Test Case {}: Success!</p>\n'.format(task_name)
	elif p.terminate:
		return False, '<p>Test Case {} Error Message:</p>\n{}'.format(task_name, p.err.replace('\n', '<br/>\n'))
	else:
		return False, '<p>Test Case {} Timeout</p>\n'.format(task_name)

os.system('rm nachos.conf')
os.system('cp nachos.conf1 nachos.conf')

for d in range(12):
	correct, msg = grade(tasks[1].format(d), 'Task 1-{}'.format(d))
	if correct: 
		score += 1
	comment += msg

for d in range(15):
	correct, msg = grade(tasks[2].format(d, 'Task 2-{}'.format(d)))
	if correct:
		socre += 1
	comment += msg

os.system('rm nachos.conf')
os.system('cp nachos.conf2 nachos.conf')

correct, msg = grade(tasks[3], 'Task 3')
if correct:
	score += 1
comment += msg

# process.exec_command('cp nachos.conf1 nachos.conf')
# terminate, ext_code, out, err = process.exec_command(tasks[8])
# if terminate:
# 	score += 1
# 	comment += 'Test Case 8: Success!\n'
# else:
# 	comment += 'Test Case 8: Timeout\n'

os.chdir(tmp_dir_path)
print 'Grade {}/{}'.format(score, len(tasks))
print 'Comment:\n{}'.format(comment)
with open('response', 'w') as f_out:
	f_out.write('{}\n'.format(score))
	f_out.write('{}\n'.format(12+15+1)
	f_out.write('<div>'+comment+'</div>')


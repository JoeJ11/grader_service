#!/usr/bin/python
# -*- coding: ASCII -*-

import os
import sys
import json
import subprocess
import time

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
	os.chdir(proj_name)
	os.system('git pull')
os.system('rm -r {}/nachos/threads'.format(GRADER_ROOT))
os.system('cp -r threads/ {}/nachos/'.format(GRADER_ROOT))
os.chdir(os.path.join(GRADER_ROOT, 'proj1'))

os.system('make clean')
os.system('make')
os.system('make ag')

score = 0
comment = ''
tasks = {
	1:'../bin/nachos -- nachos.ag.ThreadGrader3 -# joinAfterFinish=True',
	2:'../bin/nachos -- nachos.ag.ThreadGrader1 -# level=20',
	3:'../bin/nachos -- nachos.ag.ThreadGrader4 -# numThreads=3,requireImmediate=false',
	4:'../bin/nachos -- nachos.ag.ThreadGrader2 -# goal=10,numThreads=10',
	5:'../bin/nachos -- nachos.ag.ThreadGrader5 -# checkPriority=true,checkFifo=true,alterPriority=true',
	6:'../bin/nachos -- nachos.ag.ThreadGrader6a -# lottery=false,depth=5,fanout=3,maxLocks=2,pJoin=50,release=5',
	7:'../bin/nachos -- nachos.ag.ThreadGrader6b -# depth=10,pJoin=50',
}

def grade(task):
	p = process.Command(tasks[task])
	p.start()
	while not p.stop:
		time.sleep(1)
	print 'Task {}'.format(task)
	if 'success' in p.out.split('\n'):
		return True, 'Test Case {}: Success!\n'.format(task)
	elif p.terminate:
		return False, 'Test Case {} Error Message:\n{}'.format(task, p.err)
	else:
		return False, 'Test Case {} Timeout\n'.format(task)

os.system('rm nachos.conf')
os.system('cp nachos.conf1 nachos.conf')
correct, msg = grade(1)
if correct:
	score += 1
comment += msg
correct, msg = grade(2)
if correct:
	score += 1
comment += msg
correct, msg = grade(3)
if correct:
	score += 1
comment += msg
correct, msg = grade(4)
if correct:
	score += 1
comment += msg

os.system('rm nachos.conf')
os.system('cp nachos.conf2 nachos.conf')
correct, msg = grade(5)
if correct:
	score += 1
comment += msg
correct, msg = grade(6)
if correct:
	score += 1
comment += msg
correct, msg = grade(7)
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
	f_out.write('{}\n'.format(len(tasks)))
	f_out.write(comment)

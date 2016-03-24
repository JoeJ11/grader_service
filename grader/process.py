import subprocess
import time

def exec_command(command):
	proc = subprocess.Popen(command, stderr=subprocess.PIPE, stdout=subprocess.PIPE, shell=True)
	counter = 0
	while proc.poll()==None and counter < 30:
		counter += 1
		time.sleep(1)
	if proc.poll()==None:
		proc.kill()
		return (False, proc.poll(), '', '')
	else:
		(out, err) = proc.communicate()
		return (True, proc.poll(), out, err)
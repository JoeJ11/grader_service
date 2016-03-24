import subprocess
import time
import os
import signal
import threading

class Command(threading.Thread):
	def __init__(self, command):
		threading.Thread.__init__(self);
		self.command = command
		self.stop = False

		self.terminate = False
		self.ext_code = -1
		self.out = ''
		self.err = ''

	def run(self):
		proc = subprocess.Popen(self.command, stderr=subprocess.PIPE, stdout=subprocess.PIPE, shell=True, preexec_fn=os.setsid)
		counter = 0
		while proc.poll()==None and counter < 30:
			counter += 1
			time.sleep(1)
		if proc.poll()==None:
			self.terminate = False
			self.stop = True
			os.killpg(os.getpgid(proc.pid), signal.SIGTERM)
		else:
			(out, err) = proc.communicate()
			self.terminate = True
			self.out = out
			self.err = err
			self.stop = True
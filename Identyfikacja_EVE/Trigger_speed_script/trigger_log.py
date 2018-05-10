#! /usr/bin/python
#########################################
#   File name: trigger_log.py
#   Author: Bartłomiej Styczeń
#   Date created: 4/15/2018
#   Last date modified: 5/10/2018
#   Python Version: 2.7
#
# 	It is recommended to refer to README file in the same directory as this script.
#########################################
import serial
import time
import os
import csv

class TriggerLog():
	'''Class to send ROS commands (steering wheel, velocity) for triggering '''
	def __init__(self):
		self.uart = serial.Serial(
			port = 'COM13',
			baudrate = 2000000,
			bytesize = serial.EIGHTBITS,
			parity = serial.PARITY_NONE,
			stopbits = serial.STOPBITS_ONE   
		)
		self.throttle_neutral = 0
		self.steering_wheel_neutral_high = (1023 >> 8)
		self.steering_wheel_neutral_low = (1023 & 0xff)
		self.ros_cmd = {'manual':	0, 
						'automatic':1, 
						'stop':		2, 
						'pad':		3, 
						'null':		4} 
		self.eve_ctrl_reg = 0b00000010
		self.throttle_inputs = []
		self.steering_wheel_inputs = []
		self.brake_inputs = []
		self.read_commands()
		self.prompt()

	def prompt(self):
		'''Prompt user to choose type of experiment'''
		os.system('cls')
		print("-----Choose your activity-----")
		print("1 - Throttle")
		print("\n2 - Multiple throttle")
		print("\n3 - Steering wheel")
		print("\n4 - Multiple steering wheel")
		print("\n5 - Brake (not included in ROS CMD)")
		print("\n6 - Multiple brake (not included in ROS CMD)")
		print("\n0 - Stop")
		activity = input("\nActivity: ")
		if activity == 1:
			self.throttle_type('single')
		elif activity == 2:
			self.throttle_type('multiple')			
		elif activity == 3:
			self.steering_wheel_type('single')
		elif activity == 4:
			self.steering_wheel_type('multiple')
		elif activity == 5:
			self.brake_type('single')
		elif activity == 6:
			self.brake_type('multiple')
		elif activity == 0:
			self.stop()
		else:
			self.stop()

	# Throttle methods
	def throttle_type(self, flag):
		'''Check type of throttle experiment (single, multiple) and run methods accordingly'''
		os.system('cls')
		if flag == 'single':
			throttle_percentage = int(input("Throttle percentage (0 - 100): "))
			print("Throttle value: " + str(throttle_percentage)+'%')
			print("Press Ctrl + C to stop triggering and go to menu")
			self.throttle(throttle_percentage, 'single')
		elif flag == 'multiple':
			self.multiple_throttle()

	def throttle(self, throttle_percentage, flag):
		'''Trigger single throttle command until CTRL + C is pressed, value have to be 0 - 100'''
		try:
			throttle_high_byte = int((throttle_percentage >> 8) & 0xff)
			throttle_low_byte = int(throttle_percentage & 0xff)
			while True:
				self.uart.write('2' + chr(self.steering_wheel_neutral_high) + chr(self.steering_wheel_neutral_low) 
								+ chr(throttle_high_byte) + chr(throttle_low_byte) + chr(self.ros_cmd['automatic']) + chr(self.eve_ctrl_reg))
				time.sleep(0.1)
		except KeyboardInterrupt:
			if flag == 'single':
				self.prompt()
			elif flag == 'multiple':
				return

	def multiple_throttle(self):
		'''Runs multiple throttle commands read from list'''
		input_number = 0
		print("------Multiple throttle------")
		while input_number < len(self.throttle_inputs):
			print("Input "+str(input_number+1)+" / "+str(len(self.throttle_inputs))+"; value: "+str(self.throttle_inputs[input_number])+'%')
			self.throttle(self.throttle_inputs[input_number], 'multiple')
			input_number = input_number + 1
		self.prompt()

	# Steering wheels methods
	def steering_wheel_type(self, flag):
		'''Check type of steering wheel experiment (single, multiple) and run methods accordingly'''
		os.system('cls')
		if flag == 'single':
			steering_wheel = int(input("Steering wheel (0 - 2046): "))
			print("Steering wheel value: " + str(steering_wheel))
			print("Press Ctrl + C to stop triggering and go to menu")
			self.steering_wheel(steering_wheel, 'single')
		elif flag == 'multiple':
			self.multiple_steering_wheel()

	def steering_wheel(self, steering_wheel, flag):
		'''Trigger single steering wheel command until CTRL + C is pressed, value have to be 0 - 2046'''
		try:
			steering_wheel_high_byte = int((steering_wheel >> 8) & 0xff)
			steering_wheel_low_byte = int(steering_wheel & 0xff)
			while True:
				self.uart.write('2' + chr(steering_wheel_high_byte) + chr(steering_wheel_low_byte) 
								+ chr(self.throttle_neutral) + chr(self.throttle_neutral) + chr(self.ros_cmd['automatic']) + chr(self.eve_ctrl_reg))
				time.sleep(0.1)	
		except KeyboardInterrupt:
			if flag == 'single':
				self.prompt()
			elif flag == 'multiple':
				return

	def multiple_steering_wheel(self):
		'''Runs multiple steering wheel commands read from list'''
		input_number = 0
		print("------Multiple steering wheel------")
		while input_number < len(self.steering_wheel_inputs):
			print("Input "+str(input_number+1)+" / "+str(len(self.steering_wheel_inputs))+"; value: "+str(self.steering_wheel_inputs[input_number]))
			self.steering_wheel(self.steering_wheel_inputs[input_number], 'multiple')
			input_number = input_number + 1
		self.prompt()

	# Braking methods
	def brake_type(self, flag):
		'''Check type of braking experiment (single, multiple) and run methods accordingly'''
		os.system('cls')
		if flag == 'single':
			brake = int(input("Brake value: "))
			print("Brake value: " + str(throttle_percentage)+'%')
			print("Press Ctrl + C to stop triggering and go to menu")
			self.brake(brake, 'single')
		elif flag == 'multiple':
			self.multiple_brake()

	def brake(self, brake, flag):
		'''Trigger single brake command until CTRL + C is pressed, value have to be 0 - 100'''
		try:
			brake_high_byte = int((brake >> 8) & 0xff)
			brake_low_byte = int(brake & 0xff)
			while True:
				# here should be UART write command
				time.sleep(0.1)
		except KeyboardInterrupt:
			if flag == 'single':
				self.prompt()
			elif flag == 'multiple':
				return

	def multiple_brake(self):
		'''Runs multiple brake commands read from list'''
		input_number = 0
		while input_number < len(self.throttle_inputs):
			print("Input "+str(input_number+1)+" / "+str(len(self.brake_inputs))+"; value: "+str(self.brake_inputs[input_number]))
			self.brake(self.brake_inputs[input_number], 'multiple')
			input_number = input_number + 1
		self.prompt()

	def read_commands(self):
		'''Read command from csv file and write them to command lists'''
		with open('input.csv', 'rb') as f:
			reader = csv.reader(f)
			command_list = list(reader)[0]
			steering_wheel_index_start = command_list.index('s1')
			steering_wheel_index_end = command_list.index('s2')

			throttle_index_start = command_list.index('t1')
			throttle_index_end = command_list.index('t2')

			brake_index_start = command_list.index('b1')
			brake_index_end = command_list.index('b2')
			
			self.throttle_inputs = map(int, command_list[throttle_index_start + 1:throttle_index_end])
			self.steering_wheel_inputs = map(int, command_list[steering_wheel_index_start + 1:steering_wheel_index_end])
			self.brake_inputs = map(int, command_list[brake_index_start + 1:brake_index_end])
			
	def stop(self):
		'''Close connection and exit'''
		self.uart.close()
		print("Press ENTER to finish...")
		raw_input()
		os.system('cls')

		
if __name__ == "__main__":
	trigger = TriggerLog()

	
	

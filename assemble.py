import shlex, sys

labels = {}
globals = {}
fixups = []
code = []

lexer = shlex.shlex(sys.stdin)
lexer.commenters = '#'
lexer.wordchars += '_:-'

while True:
	token = lexer.get_token()
	if token == '':
		break
		
	if token[-1] == ':':
		# define label
		token = token[:-1]
		if token in labels:
			raise Exception(str(lexer.lineno) + ': redefined label ' + token)
		else:
			labels[token] = len(code)
	elif token == 'res':	# reserve data
		globals[lexer.get_token()] = len(globals)
	elif token == 'ldi':
		# Load immediate
		value = int(lexer.get_token())
		if value > 127 or value < -128:
			raise Exception(str(lexer.lineno) + ': value out of range')
		elif value < 0:
			value = (0xff ^ (-value)) + 1	# Convert to twos complement

		code += [ value & 0xff ]
	elif token == 'bl':
		target = lexer.get_token()
		if target in labels:
			code += [ 0x300 | labels[target] ]
		else:
			fixups = [ (len(code), target) ]
			code += [ 0x300 ]
	elif token == 'st':
		code += [ 0x200 | globals[lexer.get_token()] ]
	elif token == 'sub':
		code += [ 0x100 | globals[lexer.get_token()] ]
	else:
		raise Exception(str(lexer.lineno) + ': bad instruction' + token)

for addr, label in fixups:
	code[addr] = (code[addr] & 0x300) | (labels[label] & 0xff)

for x in code:
	print '%03x' % x
	
import shlex
import sys

labels = {}
globals = {}
next_global = 0
fixups = []
code = []
memory_ops = {'add': 0, 'sub': 0x100, 'st': 0x300, 'and': 0x600}

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
    elif token == 'res':
        # reserve data
        globals[lexer.get_token()] = next_global
        lookahead = lexer.get_token()
        if lookahead == ',':
            next_global += int(lexer.get_token())
        else:
            lexer.push_token(lookahead)
            next_global += 1
    elif token == 'ldi':
        # Load immediate
        operand = lexer.get_token()
        if operand.isdigit() or operand[0] == '-':
            value = int(operand)
            if value > 127 or value < -128:
                raise Exception(str(lexer.lineno) + ': value out of range')
            elif value < 0:
                value = (0xff ^ (-value)) + 1  # Convert to twos complement
        else:
            # Assume this is loading a data pointer
            value = globals[operand]

        code += [0x200 | (value & 0xff)]
    elif token == 'bl':
        # Branch if accumulator less than zero
        target = lexer.get_token()
        if target in labels:
            code += [0x400 | labels[target]]
        else:
            fixups = [(len(code), target)]
            code += [0x400]
    elif token in memory_ops:
        operand = lexer.get_token()
        if operand.isdigit():
            opval = int(operand)
        else:
            opval = globals[operand]

        code += [memory_ops[token] | opval]
    elif token == 'index':
        code += [0x500 | globals[lexer.get_token()]]
    else:
        raise Exception(str(lexer.lineno) + ': bad instruction' + token)

for addr, label in fixups:
    code[addr] = (code[addr] & 0x700) | (labels[label] & 0xff)

for x in code:
    print '%03x' % x

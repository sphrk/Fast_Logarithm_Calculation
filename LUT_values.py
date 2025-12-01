import numpy as np

N_BIT = 16
N_BIT_FRAC = 6
SCALE = 2 ** N_BIT_FRAC

E = np.arange(-N_BIT_FRAC, N_BIT - N_BIT_FRAC, dtype=float)
print('Exponents:\n', E)

EXPONENT_TABLE = (E) * np.log(2)
EXPONENT_TABLE = np.round(EXPONENT_TABLE * SCALE).astype(int)
print("\nExponent Table Values:")
print(*EXPONENT_TABLE, sep=', ')


# ### Priority Encoder Code Generator ####
# for i in range(N_BIT-1, 0-1, -1):
#     enc_out = bin(i)[2:].zfill((int(np.log2(N_BIT))))
#     if i != 0:
#         print(f'"{enc_out}" when x({i}) = \'1\' else')
#     else:
#         print(f'"{enc_out}";')


#### multiplexer code Generator ####
# value_name = 'x'
# print("with <sel_signal> select")
# print("<output_signal> <= ")
# for i in range(N_BIT-1, 0, -1):
#     sel = bin(i)[2:].zfill((int(np.log2(N_BIT))))

#     hi = i-1
#     if i >= N_BIT_MANTISA:
#         li = i - N_BIT_MANTISA
#         CONCAT_ZERO = ''
#     else:
#         li = 0
#         CONCAT_ZERO = f'& "{"0" * (N_BIT_MANTISA-hi-1)}"'
#     # print(hi, li)

#     if i == 1:
#         print(f'{value_name}(0) {CONCAT_ZERO} when others;')
#     else:
#         print(f'{value_name}({hi} downto {li}) {CONCAT_ZERO} when "{sel}",')


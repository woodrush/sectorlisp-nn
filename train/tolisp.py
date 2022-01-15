import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np
import struct

from model import model

def binary(num):
    return "".join(f"{c:0>8b}" for c in struct.pack('!f', num))

def floatbin(num):
    binstring = binary(num)
    return binstring[0], binstring[1:9], binstring[9:21], binstring[21:]

def tofixedfloat(x):
    N_total_bits = 18
    N_integer_bits = 5
    sign, expbin, f1, f2 = floatbin(x)
    frac = f1 + f2
    expdec = int(expbin, base=2) - 127
    fracdec = "1"+frac
    ret = "0"*(N_integer_bits - 1 - expdec) + fracdec
    ret = ret[:N_total_bits]
    if sign == "1":
        ret = "".join([("1" if c == "0" else "0") for c in ret])
        negativeret = int(ret, base=2) + 1
        ret = f"{negativeret:b}"
        ret = ret[-N_total_bits:]
    return ret

def tolistexpr(x):
    s = tofixedfloat(x)
    s = "".join(reversed(s))
    ret = "(" + " ".join(s) + ")"
    return ret

def writemat(A, filename):    
    with open(filename, "wt") as f:
        f.write("")
    with open(filename, "at") as f:
        f.write("(\n")
        for i in range(A.shape[0]):
            f.write("(")
            for j in range(A.shape[1]):
                f.write(tolistexpr(A[i,j]))
            f.write(")\n")
        f.write(")")

if __name__ == "__main__":
    model.load_weights("./params.h5")

    A_1, B_1 = [x.numpy() for x in model.layers[1].weights]
    A_2, B_2 = [x.numpy() for x in model.layers[3].weights]

    print(np.max(A_1), np.min(A_1),
          np.max(A_2), np.min(A_2),
          np.max(B_1), np.min(B_1),
          np.max(B_2), np.min(B_2))

    x = np.array(
        [
        [0,1,1],
        [0,0,1],
        [0,0,1],
        [0,1,0],
        [1,0,0]
        ], dtype=np.float64)
    x = x.reshape(-1)
    x

    def matpredict(x):
        return np.clip(x @ A_1 + B_1, 0, None) @ A_2 + B_2
    
    print(matpredict(x))

    print(np.min(x @ A_1), np.max(x @ A_1))
    print(np.min(x @ A_1 + B_1), np.max(x @ A_1 + B_1))
    print(np.min(np.clip(x @ A_1 + B_1, 0, None) @ A_2), np.max(np.clip(x @ A_1 + B_1, 0, None) @ A_2))

    writemat(A_1.transpose(), "A_1_T.lisp")
    writemat(B_1.reshape((1,-1)), "B_1.lisp")
    writemat(A_2.transpose(), "A_2_T.lisp")
    writemat(B_2.reshape((1,-1)), "B_2.lisp")

# This file is part of QuTiP: Quantum Toolbox in Python.
#
#    Copyright (c) 2011 and later, Paul D. Nation and Robert J. Johansson.
#    All rights reserved.
#
#    Redistribution and use in source and binary forms, with or without 
#    modification, are permitted provided that the following conditions are 
#    met:
#
#    1. Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#
#    2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#    3. Neither the name of the QuTiP: Quantum Toolbox in Python nor the names
#       of its contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
#    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
#    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
#    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
#    HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
#    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
#    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
#    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
#    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
#    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
#    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################
import numpy as np
cimport numpy as np
cimport cython
cimport libc.math

DTYPE = np.float64
ctypedef np.float64_t DTYPE_t

ITYPE = np.int32
ctypedef np.int32_t ITYPE_t

CTYPE = np.complex128
ctypedef np.complex128_t CTYPE_t

CTYPE = np.int64
ctypedef np.int64_t LTYPE_t

@cython.boundscheck(False)
@cython.wraparound(False)
cpdef cy_overlap(object op1, object op2):
    
    cdef Py_ssize_t row
    cdef CTYPE_t tr = 0.0
	
    op1 = op1.T.tocsr()
	
    cdef int col1, row1_idx_start, row1_idx_end
    cdef np.ndarray[CTYPE_t, ndim=1, mode="c"] data1 = op1.data.conj()
    cdef np.ndarray[ITYPE_t, ndim=1, mode="c"] idx1 = op1.indices
    cdef np.ndarray[ITYPE_t, ndim=1, mode="c"] ptr1 = op1.indptr

    cdef int col2, row2_idx_start, row2_idx_end
    cdef np.ndarray[CTYPE_t, ndim=1, mode="c"] data2 = op2.data
    cdef np.ndarray[ITYPE_t, ndim=1, mode="c"] idx2 = op2.indices
    cdef np.ndarray[ITYPE_t, ndim=1, mode="c"] ptr2 = op2.indptr

    cdef int num_rows = ptr1.shape[0]-1

    for row in range(num_rows):

        row1_idx_start = ptr1[row]
        row1_idx_end = ptr1[row + 1]
        for row1_idx from row1_idx_start <= row1_idx < row1_idx_end:
            col1 = idx1[row1_idx]

            row2_idx_start = ptr2[col1]
            row2_idx_end = ptr2[col1 + 1]
            for row2_idx from row2_idx_start <= row2_idx < row2_idx_end:
                col2 = idx2[row2_idx]

                if col2 == row:
                    tr += data1[row1_idx] * data2[row2_idx]
 
    return tr / op1.shape[0]

@cython.boundscheck(False)
@cython.wraparound(False)
cpdef np.ndarray[int, ndim=1, mode="c"] cy_grape_inner(
        np.ndarray[int, ndim=1, mode="c"] vec):
    """
	test
    """
    return 0
	


#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

#include "tikzDevice.h"


static const R_CMethodDef CEntries[] = {
    {"TikZ_Annotate", (DL_FUNC) &TikZ_Annotate, 3},
    {NULL, NULL, 0}
};

static const R_CallMethodDef CallEntries[] = {
    {"TikZ_DeviceInfo",            (DL_FUNC) &TikZ_DeviceInfo,            1},
    {"TikZ_EvalWithoutInterrupts", (DL_FUNC) &TikZ_EvalWithoutInterrupts, 2},
    {NULL, NULL, 0}
};

static const R_ExternalMethodDef ExternalEntries[] = {
    {"TikZ_StartDevice", (DL_FUNC) &TikZ_StartDevice, -1},
    {NULL, NULL, 0}
};

void R_init_tikzDevice(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, CallEntries, NULL, ExternalEntries);
    R_useDynamicSymbols(dll, FALSE);
}

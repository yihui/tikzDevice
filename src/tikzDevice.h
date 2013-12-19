/*
 * There probably won't be more than one C source file using
 * this header, but it's still a good idea to make sure the
 * compiler will only include it once. Errors could result
 * otherwise.
*/

#ifndef HAVE_TIKZDEV_H // Begin once-only header
#define HAVE_TIKZDEV_H

#ifndef DEBUG
#define DEBUG FALSE
#endif

/* Use default graphics engine function declarations. */
#define R_USE_PROTOTYPES 1

/* Declarations for functions provided by the R language */
#include <R.h>
#include <Rinternals.h>
#include <R_ext/GraphicsEngine.h>

/* Check R Graphics Engine for minimum supported version */
#if R_GE_version < 8
#error "This version of the tikzDevice must be compiled against R 2.12.0 or newer!"
#endif

/* Macro definitions */
#define TIKZ_NAMESPACE R_FindNamespace(mkString("tikzDevice"))


/*
 * tikz_engine can take on possible values from a list of all the TeX engines
 * we support.
 */
typedef enum {
  pdftex = 1,
  xetex = 2,
  luatex = 3
} tikz_engine;

typedef enum {
  TIKZ_START_PAGE = 1,
  TIKZ_NO_PAGE = 0,
  TIKZ_FINISH_PAGE = -1
} TikZ_PageState;

typedef enum {
  TIKZ_START_CLIP = 1,
  TIKZ_NO_CLIP = 0,
  TIKZ_FINISH_CLIP = -1
} TikZ_ClipState;


/*
 * tikzDevDesc is a structure that is used to hold information
 * that is unique to the implementation of the TikZ Device. A
 * new component may be created for any information that it is
 * deemed desirable to have available during execution of TikZ
 * Device routines.
*/
typedef struct {
	FILE *outputFile;
  char *outFileName;
  char *originalFileName;
  tikz_engine engine;
  int rasterFileCount;
  int pageNum;
	Rboolean debug;
	Rboolean standAlone;
	Rboolean bareBones;
  Rboolean onefile;
	int oldFillColor;
	int oldDrawColor;
	int stringWidthCalls;
	const char *documentDeclaration;
	const char *packages;
	const char *footer;
	Rboolean console;
	Rboolean sanitize;
  TikZ_ClipState clipState;
  TikZ_PageState pageState;
} tikzDevDesc;


/* Function Prototypes */

/* Public Functions */
SEXP TikZ_StartDevice(SEXP args);
void TikZ_Annotate(const char **annotation, int *size);
SEXP TikZ_DeviceInfo(SEXP device_num);


static Rboolean TikZ_Setup(
		pDevDesc deviceInfo,
		const char *fileName,
		double width, double height, Rboolean onefile,
		const char *bg, const char *fg, double baseSize,
		Rboolean standAlone, Rboolean bareBones,
		const char *documentDeclaration,
		const char *packages, const char *footer,
		Rboolean console, Rboolean sanitize, int engine );


/* Graphics Engine function hooks. Defined in GraphicsDevice.h . */

/* Device State */
static Rboolean TikZ_Open( pDevDesc deviceInfo );
static void TikZ_Close( pDevDesc deviceInfo );
static void TikZ_NewPage( const pGEcontext plotParams, pDevDesc deviceInfo );
static void TikZ_Clip( double x0, double x1,
		double y0, double y1, pDevDesc deviceInfo );
static void TikZ_Size( double *left, double *right,
		double *bottom, double *top, pDevDesc deviceInfo);

/* Font Metrics*/
static void TikZ_MetricInfo( int c, const pGEcontext plotParams,
		double *ascent, double *descent, double *width, pDevDesc deviceInfo );
static double TikZ_StrWidth( const char *str,
		const pGEcontext plotParams, pDevDesc deviceInfo );

/* Drawing routines. */
static void TikZ_Text( double x, double y, const char *str,
		double rot, double hadj, const pGEcontext plotParams, pDevDesc deviceInfo);
static void TikZ_Circle( double x, double y, double r,
		const pGEcontext plotParams, pDevDesc deviceInfo );
static void TikZ_Rectangle( double x0, double y0, 
		double x1, double y1, const pGEcontext plotParams, pDevDesc deviceInfo );
static void TikZ_Line( double x1, double y1,
		double x2, double y2, const pGEcontext plotParams, pDevDesc deviceInfo );
static void TikZ_Polyline( int n, double *x, double *y,
		pGEcontext plotParams, pDevDesc deviceInfo );
static void TikZ_Polygon( int n, double *x, double *y,
		pGEcontext plotParams, pDevDesc deviceInfo );
static void
TikZ_Path( double *x, double *y,
  int npoly, int *nper,
  Rboolean winding,
  const pGEcontext plotParams, pDevDesc deviceInfo );

static void TikZ_Raster(
  unsigned int *raster,
  int w, int h,
  double x, double y,
  double width, double height,
  double rot,
  Rboolean interpolate,
  const pGEcontext plotParams, pDevDesc deviceInfo
);

/* Dummy/Unimplemented routines. */
static SEXP TikZ_Cap( pDevDesc deviceInfo );
static void TikZ_Activate( pDevDesc deviceInfo );
static void TikZ_Deactivate( pDevDesc deviceInfo );
static Rboolean TikZ_Locator( double *x, double *y, pDevDesc deviceInfo );
static void TikZ_Mode( int mode, pDevDesc deviceInfo );

/* End R Graphics engine function hooks. */



/*Internal style definition routines*/

/*
 * This enumeration specifies the kinds of drawing operations that need to be
 * performed, such as filling or drawing a path.
 *
 * When adding new members, use the next power of 2 as so that the presence or
 * absance of an operation can be determined using bitwise operators.
 */
typedef enum {
  DRAWOP_NOOP = 0,
  DRAWOP_DRAW = 1,
  DRAWOP_FILL = 2
} TikZ_DrawOps;
static TikZ_DrawOps TikZ_GetDrawOps(pGEcontext plotParams);

static void TikZ_DefineColors(const pGEcontext plotParams, pDevDesc deviceInfo, TikZ_DrawOps ops);
static void TikZ_WriteDrawOptions(const pGEcontext plotParams, pDevDesc deviceInfo, TikZ_DrawOps ops);
static void TikZ_WriteLineStyle(pGEcontext plotParams, tikzDevDesc *tikzInfo);

static double ScaleFont( const pGEcontext plotParams, pDevDesc deviceInfo );

/* Utility Routines*/
static void printOutput(tikzDevDesc *tikzInfo, const char *format, ...);
static void Print_TikZ_Header( tikzDevDesc *tikzInfo );
static char *Sanitize(const char *str);
#if 0
static Rboolean contains_multibyte_chars(const char *str);
#endif
static double dim2dev( double length );
static void TikZ_CheckState(pDevDesc deviceInfo);
static char *calloc_strcpy(const char *str);
static char *calloc_x_strcpy(const char *str, size_t extra);
static char *calloc_x_strlen(const char *str, size_t extra);
static void const_free(const void *ptr);

#endif // End of Once Only header

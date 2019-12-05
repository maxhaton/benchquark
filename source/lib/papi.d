/* Converted to D from papi.h by htod */

module lib.papi;

extern(C):
@nogc:




//#include <sys/types.h>
import core.sys.posix.sys.types;
//#include <limits.h>
import core.stdc.limits;
//C     #include "papiStdEventDefs.h"
import lib.papiStdEventDefs;

/* Converted to D from papi.h by htod */

/****************************/
/* THIS IS OPEN SOURCE CODE */
/****************************/

/** 
* @file    papi.h
*
* @author  Philip Mucci
*          mucci@cs.utk.edu
* @author  dan terpstra
*          terpstra@cs.utk.edu
* @author  Haihang You
*	       you@cs.utk.edu
* @author  Kevin London
*	       london@cs.utk.edu
* @author  Maynard Johnson
*          maynardj@us.ibm.com
*
* @brief Return codes and api definitions.
*/



/**
 * @mainpage PAPI
 *  
 * @section papi_intro Introduction
 * The PAPI Performance Application Programming Interface provides machine and 
 * operating system independent access to hardware performance counters found 
 * on most modern processors. 
 * Any of over 100 preset events can be counted through either a simple high 
 * level programming interface or a more complete low level interface from 
 * either C or Fortran. 
 * A list of the function calls in these interfaces is given below, 
 * with references to other pages for more complete details. 
 *
 * @section papi_high_api High Level Functions
 * A simple interface for instrumenting end-user applications. 
 * Fully supported on both C and Fortran. 
 * See individual functions for details on usage.
 * 
 *	@ref high_api
 * 
 * Note that the high-level interface is self-initializing. 
 * You can mix high and low level calls, but you @b must call either 
 * @ref PAPI_library_init() or a high level routine before calling a low level routine.
 *
 * @section papi_low_api Low Level Functions
 * Advanced interface for all applications and performance tools.
 * Some functions may be implemented only for C or Fortran.
 * See individual functions for details on usage and support.
 * 
 * @ref low_api
 *
 * @section papi_Fortran Fortran API
 * The Fortran interface has some unique features and entry points.
 * See individual functions for details.
 * 
 * @ref PAPIF
 *
 * @section Components 
 *
 *	Components provide access to hardware information on specific subsystems.
 *
 *	Components can be found under the conponents directory or @ref papi_components "here". 
 *	and included in a build as an argument to configure, 
 *	'--with-components=< comma_seperated_list_of_components_to_build >'
 * 
 * @section papi_util PAPI Utility Commands
 * <ul> 
 *		<li> @ref papi_avail - provides availability and detail information for PAPI preset events
 *		<li> @ref papi_clockres - provides availability and detail information for PAPI preset events
 *		<li> @ref papi_cost - provides availability and detail information for PAPI preset events
 *		<li> @ref papi_command_line - executes PAPI preset or native events from the command line
 *		<li> @ref papi_decode -	decodes PAPI preset events into a csv format suitable for 
 *							PAPI_encode_events
 *		<li> @ref papi_event_chooser -	given a list of named events, lists other events 
 *										that can be counted with them
 *		<li> @ref papi_mem_info -	provides information on the memory architecture 
									of the current processor
 *		<li> @ref papi_native_avail - provides detailed information for PAPI native events 
 * </ul>
 * @see The PAPI Website http://icl.cs.utk.edu/papi
 */

/** \htmlonly
  * @page CDI PAPI Component Development Interface
  * @par \em Introduction
  *		PAPI-C consists of a Framework and between 1 and 16 Components. 
  *		The Framework is platform independent and exposes the PAPI API to end users. 
  *		The Components provide access to hardware information on specific subsystems. 
  *		By convention, Component 0 is always a CPU Component. 
  *		This allows default behavior for legacy code, and provides a universal 
  *		place to define system-wide operations and parameters, 
  *		like clock rates and interrupt structures. 
  *		Currently only a single CPU Component can exist at a time. 
  *
  * @par No CPU
  *		In certain cases it can be desirable to use a generic CPU component for 
  *		testing instrumentation or for operation on systems that don't provide 
  *		the proper patches for accessing cpu counters. 
  *		For such a case, the configure option: 
  *	@code
  *		configure --with-no-cpu-counters = yes
  *	@endcode 
  *	is provided to build PAPI with an "empty" cpu component.
  *
  *	@par Exposed Interface
  *		A Component for PAPI-C typically consists of a single header file and a 
  *		single (or small number of) source file(s). 
  *		All of the information for a Component needed by PAPI-C is exposed through 
  *		a single data structure that is declared and initialized at the bottom 
  *		of the main source file. 
  *		This structure, @ref papi_vector_t , is defined in @ref papi_vector.h .
  *	
  *	@par Compiling With an Existing Component 
  *		Components provided with the PAPI source distribution all appear in the 
  *		src/components directory. 
  *		Each component exists in its own directory, named the same as the component itself. 
  *		To include a component in a PAPI build, use the configure command line as shown:
  *	
  *	@code
  *		configure --with-components="component list"
  *	@endcode
  *	
  * Replace the "component list" argument with either the name of a specific 
  *	component directory or multiple component names separated by spaces and 
  *	enclosed in quotes as shown below:
  *
  *	\c configure --with-components="acpi lustre infiniband"
  *
  *	In some cases components themselves require additional configuration. 
  *	In these cases an error message will be produced when you run @code make @endcode . 
  *	To fix this, run the configure script found in the component directory.
  * 
  *	@par Adding a New Component 
  *	The mechanics of adding a new component to the PAPI 4.1 build are relatively straight-forward.
  *	Add a directory to the papi/src/components directory that is named with 
  *	the base name of the component. 
  *	This directory will contain the source files and build files for the new component. 
  *	If configuration of the component is necessary, 
  *	additional configure and make files will be needed. 
  *	The /example directory can be cloned and renamed as a starting point. 
  *	Other components can be used as examples. 
  *	This is described in more detail in /components/README.
  *
  *	@par Developing a New Component 
  *		A PAPI-C component generally consists of a header file and one or a 
  *		small number of source files. 
  *		The source file must contain a @ref papi_vector_t structure that 
  *		exposes the internal data and entry points of the component to the PAPI-C Framework. 
  *		This structure must have a unique name that is exposed externally and 
  *		contains the name of the directory containing the component source code.
  *
  *	Three types of information are exposed in the @ref papi_vector_t structure:
  *		Configuration parameters are contained in the @ref PAPI_component_info_t structure;
  *		Sizes of opaque data structures necessary for memory management are in the @ref cmp_struct_sizes_t structure;
  *		An array of function entry points which, if implemented, provide access to the functionality of the component.
  *
  *	If a function is not implemented in a given component its value in the structure can be left unset. 
  *	In this case it will be initialized to NULL, and result (generally) in benign, although unproductive, behavior.
  *
  *	During the development of a component, functions can be implemented and tested in blocks. 
  *	Further information about an appropriate order for developing these functions 
  *	can be found in the Component Development Cookbook .
  *
  * @par PAPI-C Open Research Issues:
  *	<ul>
  *	<li> Support for non-standard data types: 
  *		Currently PAPI supports returned data values expressed as unsigned 64-bit integers. 
  *		This is appropriate for counting events, but may not be as appropriate 
  *		for expressing other values. 
  *		Examples of some other possible data types are shown below. 
  *		Data type might be expressed as a flag in the event definition.
  *	<li> Signed Integer
  *		<ul>
  *		<li>Float: 64-bit IEEE double precision
  *		<li>Fixed Point: 32-bit integer and 32-bit fraction
  *		<li>Ratios: 32 bit numerator and 32 bit denominator
  *		</ul>
  *	<li> Synchronization:
  *		Components might report values with widely different time scales and 
  *		remote measurements may be significantly skewed in time from local measurements. 
  *		It would be desirable to have a mechanism to synchronize these values in time.
  *	<li> Dynamic Component Discovery:
  *		Components currently must be included statically in the PAPI library build. 
  *		This minimizes startup disruption and time lag, particularly for large parallel systems. 
  *		In some instances it would also be desirable to support a run-time 
  *		discovery process for components, possibly by searching a specific 
  *		location for dynamic libraries.
  *	<li> Component Repository:
  *		A small collection of components are currently maintained and 
  *		supported inside the PAPI source distribution. 
  *		It would be desirable to create a public component repository where 3rd 
  *		parties could submit components for the use and benefit of the larger community.
  *	<li> Multiple CPU Components:
  *		With the rise in popularity of heterogeneous computing systems, it may 
  *		become desirable to have more than one CPU component. 
  *		Issues must then be resolved relating to which cpu time-base is used, 
  *		how are interrupts handled, etc. 
  *	</ul>
  * \endhtmlonly
  */

/* Definition of PAPI_VERSION format.  Note that each of the four 
 * components _must_ be less than 256.  Also, the PAPI_VER_CURRENT
 * masks out the revision and increment.  Any revision change is supposed 
 * to be binary compatible between the user application code and the 
 * run-time library. Any modification that breaks this compatibility 
 * _should_ modify the minor version number as to force user applications 
 * to re-compile.
 */
//C     #define PAPI_VERSION_NUMBER(maj,min,rev,inc) (((maj)<<24) | ((min)<<16) | ((rev)<<8) | (inc))
//C     #define PAPI_VERSION_MAJOR(x)   	(((x)>>24)    & 0xff)
//C     #define PAPI_VERSION_MINOR(x)		(((x)>>16)    & 0xff)
//C     #define PAPI_VERSION_REVISION(x)	(((x)>>8)     & 0xff)
//C     #define PAPI_VERSION_INCREMENT(x)((x)          & 0xff)

/* This is the official PAPI version */
/* The final digit represents the patch count */
//C     #define PAPI_VERSION  			PAPI_VERSION_NUMBER(5,6,0,0)
//C     #define PAPI_VER_CURRENT 		(PAPI_VERSION & 0xffff0000)

  /* Tests for checking event code type */
//C     #define IS_NATIVE( EventCode ) ( ( EventCode & PAPI_NATIVE_MASK ) && !(EventCode & PAPI_PRESET_MASK) )
//C     #define IS_PRESET( EventCode ) ( ( EventCode & PAPI_PRESET_MASK ) && !(EventCode & PAPI_NATIVE_MASK) )
//C     #define IS_USER_DEFINED( EventCode ) ( ( EventCode & PAPI_PRESET_MASK ) && (EventCode & PAPI_NATIVE_MASK) )

//C     #ifdef __cplusplus
//C     extern "C"
//C     {
//C     #endif

/* Include files */


//C     #include "papiStdEventDefs.h"


/** \internal 
@defgroup ret_codes Return Codes
Return Codes
All of the functions contained in the PerfAPI return standardized error codes.
Values greater than or equal to zero indicate success, less than zero indicates
failure. 
@{
*/

//C     #define PAPI_OK          0     /**< No error */
//C     #define PAPI_EINVAL     -1     /**< Invalid argument */
const PAPI_OK = 0;
//C     #define PAPI_ENOMEM     -2     /**< Insufficient memory */
const PAPI_EINVAL = -1;
//C     #define PAPI_ESYS       -3     /**< A System/C library call failed */
const PAPI_ENOMEM = -2;
//C     #define PAPI_ECMP       -4     /**< Not supported by component */
const PAPI_ESYS = -3;
//C     #define PAPI_ESBSTR     -4     /**< Backwards compatibility */
const PAPI_ECMP = -4;
//C     #define PAPI_ECLOST     -5     /**< Access to the counters was lost or interrupted */
const PAPI_ESBSTR = -4;
//C     #define PAPI_EBUG       -6     /**< Internal error, please send mail to the developers */
const PAPI_ECLOST = -5;
//C     #define PAPI_ENOEVNT    -7     /**< Event does not exist */
const PAPI_EBUG = -6;
//C     #define PAPI_ECNFLCT    -8     /**< Event exists, but cannot be counted due to counter resource limitations */
const PAPI_ENOEVNT = -7;
//C     #define PAPI_ENOTRUN    -9     /**< EventSet is currently not running */
const PAPI_ECNFLCT = -8;
//C     #define PAPI_EISRUN     -10    /**< EventSet is currently counting */
const PAPI_ENOTRUN = -9;
//C     #define PAPI_ENOEVST    -11    /**< No such EventSet Available */
const PAPI_EISRUN = -10;
//C     #define PAPI_ENOTPRESET -12    /**< Event in argument is not a valid preset */
const PAPI_ENOEVST = -11;
//C     #define PAPI_ENOCNTR    -13    /**< Hardware does not support performance counters */
const PAPI_ENOTPRESET = -12;
//C     #define PAPI_EMISC      -14    /**< Unknown error code */
const PAPI_ENOCNTR = -13;
//C     #define PAPI_EPERM      -15    /**< Permission level does not permit operation */
const PAPI_EMISC = -14;
//C     #define PAPI_ENOINIT    -16    /**< PAPI hasn't been initialized yet */
const PAPI_EPERM = -15;
//C     #define PAPI_ENOCMP     -17    /**< Component Index isn't set */
const PAPI_ENOINIT = -16;
//C     #define PAPI_ENOSUPP    -18    /**< Not supported */
const PAPI_ENOCMP = -17;
//C     #define PAPI_ENOIMPL    -19    /**< Not implemented */
const PAPI_ENOSUPP = -18;
//C     #define PAPI_EBUF       -20    /**< Buffer size exceeded */
const PAPI_ENOIMPL = -19;
//C     #define PAPI_EINVAL_DOM -21    /**< EventSet domain is not supported for the operation */
const PAPI_EBUF = -20;
//C     #define PAPI_EATTR		-22    /**< Invalid or missing event attributes */
const PAPI_EINVAL_DOM = -21;
//C     #define PAPI_ECOUNT		-23    /**< Too many events or attributes */
const PAPI_EATTR = -22;
//C     #define PAPI_ECOMBO		-24    /**< Bad combination of features */
const PAPI_ECOUNT = -23;
//C     #define PAPI_NUM_ERRORS	 25    /**< Number of error messages specified in this API */
const PAPI_ECOMBO = -24;

const PAPI_NUM_ERRORS = 25;
//C     #define PAPI_NOT_INITED		0
//C     #define PAPI_LOW_LEVEL_INITED 	1       /* Low level has called library init */
const PAPI_NOT_INITED = 0;
//C     #define PAPI_HIGH_LEVEL_INITED 	2       /* High level has called library init */
const PAPI_LOW_LEVEL_INITED = 1;
//C     #define PAPI_THREAD_LEVEL_INITED 4      /* Threads have been inited */
const PAPI_HIGH_LEVEL_INITED = 2;
/** @} */
const PAPI_THREAD_LEVEL_INITED = 4;

/** @internal 
@defgroup consts Constants
All of the functions in the PerfAPI should use the following set of constants.
@{
*/

//C     #define PAPI_NULL       -1      /**<A nonexistent hardware event used as a placeholder */

const PAPI_NULL = -1;
/** @internal  
	@defgroup domain_defns Domain definitions 
 	@{ */

//C     #define PAPI_DOM_USER    0x1    /**< User context counted */
//C     #define PAPI_DOM_MIN     PAPI_DOM_USER
const PAPI_DOM_USER = 0x1;
//C     #define PAPI_DOM_KERNEL	 0x2    /**< Kernel/OS context counted */
alias PAPI_DOM_USER PAPI_DOM_MIN;
//C     #define PAPI_DOM_OTHER	 0x4    /**< Exception/transient mode (like user TLB misses ) */
const PAPI_DOM_KERNEL = 0x2;
//C     #define PAPI_DOM_SUPERVISOR 0x8 /**< Supervisor/hypervisor context counted */
const PAPI_DOM_OTHER = 0x4;
//C     #define PAPI_DOM_ALL	 (PAPI_DOM_USER|PAPI_DOM_KERNEL|PAPI_DOM_OTHER|PAPI_DOM_SUPERVISOR) /**< All contexts counted */
const PAPI_DOM_SUPERVISOR = 0x8;
/* #define PAPI_DOM_DEFAULT PAPI_DOM_USER NOW DEFINED BY COMPONENT */
//C     #define PAPI_DOM_MAX     PAPI_DOM_ALL
//C     #define PAPI_DOM_HWSPEC  0x80000000     
/**< Flag that indicates we are not reading CPU like stuff.
alias PAPI_DOM_ALL PAPI_DOM_MAX;
                                           The lower 31 bits can be decoded by the component into something
                                           meaningful. i.e. SGI HUB counters */
/** @} */
const PAPI_DOM_HWSPEC = 0x80000000;

/** @internal 
 *	@defgroup thread_defns Thread Definitions 
 *		We define other levels in papi_internal.h
 *		for internal PAPI use, so if you change anything
 *		make sure to look at both places -KSL
 *	@{ */
//C     #define PAPI_USR1_TLS		0x0
//C     #define PAPI_USR2_TLS		0x1
const PAPI_USR1_TLS = 0x0;
//C     #define PAPI_HIGH_LEVEL_TLS     0x2
const PAPI_USR2_TLS = 0x1;
//C     #define PAPI_NUM_TLS		0x3
const PAPI_HIGH_LEVEL_TLS = 0x2;
//C     #define PAPI_TLS_USR1		PAPI_USR1_TLS
const PAPI_NUM_TLS = 0x3;
//C     #define PAPI_TLS_USR2		PAPI_USR2_TLS
alias PAPI_USR1_TLS PAPI_TLS_USR1;
//C     #define PAPI_TLS_HIGH_LEVEL     PAPI_HIGH_LEVEL_TLS
alias PAPI_USR2_TLS PAPI_TLS_USR2;
//C     #define PAPI_TLS_NUM		PAPI_NUM_TLS
alias PAPI_HIGH_LEVEL_TLS PAPI_TLS_HIGH_LEVEL;
//C     #define PAPI_TLS_ALL_THREADS	0x10
alias PAPI_NUM_TLS PAPI_TLS_NUM;
/** @} */
const PAPI_TLS_ALL_THREADS = 0x10;

/** @internal 
 *	@defgroup locking_defns Locking Mechanisms defines 
 *	@{ */
//C     #define PAPI_USR1_LOCK          	0x0    /**< User controlled locks */
//C     #define PAPI_USR2_LOCK          	0x1    /**< User controlled locks */
const PAPI_USR1_LOCK = 0x0;
//C     #define PAPI_NUM_LOCK           	0x2    /**< Used with setting up array */
const PAPI_USR2_LOCK = 0x1;
//C     #define PAPI_LOCK_USR1          	PAPI_USR1_LOCK
const PAPI_NUM_LOCK = 0x2;
//C     #define PAPI_LOCK_USR2          	PAPI_USR2_LOCK
alias PAPI_USR1_LOCK PAPI_LOCK_USR1;
//C     #define PAPI_LOCK_NUM			PAPI_NUM_LOCK
alias PAPI_USR2_LOCK PAPI_LOCK_USR2;
/** @} */
alias PAPI_NUM_LOCK PAPI_LOCK_NUM;

/* Remove this!  If it breaks userspace we might have to add it back :( */
/* #define PAPI_MPX_DEF_DEG 32			                        */

/**	@internal 
	@defgroup papi_vendors  Vendor definitions 
	@{ */
//C     #define PAPI_VENDOR_UNKNOWN 0
//C     #define PAPI_VENDOR_INTEL   1
const PAPI_VENDOR_UNKNOWN = 0;
//C     #define PAPI_VENDOR_AMD     2
const PAPI_VENDOR_INTEL = 1;
//C     #define PAPI_VENDOR_IBM     3
const PAPI_VENDOR_AMD = 2;
//C     #define PAPI_VENDOR_CRAY    4
const PAPI_VENDOR_IBM = 3;
//C     #define PAPI_VENDOR_SUN     5
const PAPI_VENDOR_CRAY = 4;
//C     #define PAPI_VENDOR_FREESCALE 6
const PAPI_VENDOR_SUN = 5;
//C     #define PAPI_VENDOR_ARM     7
const PAPI_VENDOR_FREESCALE = 6;
//C     #define PAPI_VENDOR_MIPS    8
const PAPI_VENDOR_ARM = 7;
/** @} */
const PAPI_VENDOR_MIPS = 8;

/** @internal 
 *	@defgroup granularity_defns Granularity definitions 
 *	@{ */

//C     #define PAPI_GRN_THR     0x1    /**< PAPI counters for each individual thread */
//C     #define PAPI_GRN_MIN     PAPI_GRN_THR
const PAPI_GRN_THR = 0x1;
//C     #define PAPI_GRN_PROC    0x2    /**< PAPI counters for each individual process */
alias PAPI_GRN_THR PAPI_GRN_MIN;
//C     #define PAPI_GRN_PROCG   0x4    /**< PAPI counters for each individual process group */
const PAPI_GRN_PROC = 0x2;
//C     #define PAPI_GRN_SYS     0x8    /**< PAPI counters for the current CPU, are you bound? */
const PAPI_GRN_PROCG = 0x4;
//C     #define PAPI_GRN_SYS_CPU 0x10   /**< PAPI counters for all CPUs individually */
const PAPI_GRN_SYS = 0x8;
//C     #define PAPI_GRN_MAX     PAPI_GRN_SYS_CPU
const PAPI_GRN_SYS_CPU = 0x10;
/** @} */
alias PAPI_GRN_SYS_CPU PAPI_GRN_MAX;

/** @internal 
	@defgroup evt_states States of an EventSet 
	@{ */
//C     #define PAPI_STOPPED      0x01  /**< EventSet stopped */
//C     #define PAPI_RUNNING      0x02  /**< EventSet running */
const PAPI_STOPPED = 0x01;
//C     #define PAPI_PAUSED       0x04  /**< EventSet temp. disabled by the library */
const PAPI_RUNNING = 0x02;
//C     #define PAPI_NOT_INIT     0x08  /**< EventSet defined, but not initialized */
const PAPI_PAUSED = 0x04;
//C     #define PAPI_OVERFLOWING  0x10  /**< EventSet has overflowing enabled */
const PAPI_NOT_INIT = 0x08;
//C     #define PAPI_PROFILING    0x20  /**< EventSet has profiling enabled */
const PAPI_OVERFLOWING = 0x10;
//C     #define PAPI_MULTIPLEXING 0x40  /**< EventSet has multiplexing enabled */
const PAPI_PROFILING = 0x20;
//C     #define PAPI_ATTACHED	  0x80  /**< EventSet is attached to another thread/process */
const PAPI_MULTIPLEXING = 0x40;
//C     #define PAPI_CPU_ATTACHED 0x100 /**< EventSet is attached to a specific cpu (not counting thread of execution) */
const PAPI_ATTACHED = 0x80;
/** @} */
const PAPI_CPU_ATTACHED = 0x100;

/** @internal 
	@defgroup error_predef Error predefines 
	@{ */
//C     #define PAPI_QUIET       0      /**< Option to turn off automatic reporting of return codes < 0 to stderr. */
//C     #define PAPI_VERB_ECONT  1      /**< Option to automatically report any return codes < 0 to stderr and continue. */
const PAPI_QUIET = 0;
//C     #define PAPI_VERB_ESTOP  2      /**< Option to automatically report any return codes < 0 to stderr and exit. */
const PAPI_VERB_ECONT = 1;
/** @} */
const PAPI_VERB_ESTOP = 2;

/** @internal 
	@defgroup profile_defns Profile definitions 
	@{ */
//C     #define PAPI_PROFIL_POSIX     0x0        /**< Default type of profiling, similar to 'man profil'. */
//C     #define PAPI_PROFIL_RANDOM    0x1        /**< Drop a random 25% of the samples. */
const PAPI_PROFIL_POSIX = 0x0;
//C     #define PAPI_PROFIL_WEIGHTED  0x2        /**< Weight the samples by their value. */
const PAPI_PROFIL_RANDOM = 0x1;
//C     #define PAPI_PROFIL_COMPRESS  0x4        /**< Ignore samples if hash buckets get big. */
const PAPI_PROFIL_WEIGHTED = 0x2;
//C     #define PAPI_PROFIL_BUCKET_16 0x8        /**< Use 16 bit buckets to accumulate profile info (default) */
const PAPI_PROFIL_COMPRESS = 0x4;
//C     #define PAPI_PROFIL_BUCKET_32 0x10       /**< Use 32 bit buckets to accumulate profile info */
const PAPI_PROFIL_BUCKET_16 = 0x8;
//C     #define PAPI_PROFIL_BUCKET_64 0x20       /**< Use 64 bit buckets to accumulate profile info */
const PAPI_PROFIL_BUCKET_32 = 0x10;
//C     #define PAPI_PROFIL_FORCE_SW  0x40       /**< Force Software overflow in profiling */
const PAPI_PROFIL_BUCKET_64 = 0x20;
//C     #define PAPI_PROFIL_DATA_EAR  0x80       /**< Use data address register profiling */
const PAPI_PROFIL_FORCE_SW = 0x40;
//C     #define PAPI_PROFIL_INST_EAR  0x100      /**< Use instruction address register profiling */
const PAPI_PROFIL_DATA_EAR = 0x80;
//C     #define PAPI_PROFIL_BUCKETS   (PAPI_PROFIL_BUCKET_16 | PAPI_PROFIL_BUCKET_32 | PAPI_PROFIL_BUCKET_64)
const PAPI_PROFIL_INST_EAR = 0x100;
/** @} */

/* @defgroup overflow_defns Overflow definitions 
   @{ */
//C     #define PAPI_OVERFLOW_FORCE_SW 0x40	/**< Force using Software */
//C     #define PAPI_OVERFLOW_HARDWARE 0x80	/**< Using Hardware */
const PAPI_OVERFLOW_FORCE_SW = 0x40;
/** @} */
const PAPI_OVERFLOW_HARDWARE = 0x80;

/** @internal 
  *	@defgroup mpx_defns Multiplex flags definitions 
  * @{ */
//C     #define PAPI_MULTIPLEX_DEFAULT	0x0	/**< Use whatever method is available, prefer kernel of course. */
//C     #define PAPI_MULTIPLEX_FORCE_SW 0x1	/**< Force PAPI multiplexing instead of kernel */
const PAPI_MULTIPLEX_DEFAULT = 0x0;
/** @} */
const PAPI_MULTIPLEX_FORCE_SW = 0x1;

/** @internal 
	@defgroup option_defns Option definitions 
	@{ */
//C     #define PAPI_INHERIT_ALL  1     /**< The flag to this to inherit all children's counters */
//C     #define PAPI_INHERIT_NONE 0     /**< The flag to this to inherit none of the children's counters */
const PAPI_INHERIT_ALL = 1;

const PAPI_INHERIT_NONE = 0;

//C     #define PAPI_DETACH			1		/**< Detach */
//C     #define PAPI_DEBUG          2       /**< Option to turn on  debugging features of the PAPI library */
const PAPI_DETACH = 1;
//C     #define PAPI_MULTIPLEX 		3       /**< Turn on/off or multiplexing for an eventset */
const PAPI_DEBUG = 2;
//C     #define PAPI_DEFDOM  		4       /**< Domain for all new eventsets. Takes non-NULL option pointer. */
const PAPI_MULTIPLEX = 3;
//C     #define PAPI_DOMAIN  		5       /**< Domain for an eventset */
const PAPI_DEFDOM = 4;
//C     #define PAPI_DEFGRN  		6       /**< Granularity for all new eventsets */
const PAPI_DOMAIN = 5;
//C     #define PAPI_GRANUL  		7       /**< Granularity for an eventset */
const PAPI_DEFGRN = 6;
//C     #define PAPI_DEF_MPX_NS     8       /**< Multiplexing/overflowing interval in ns, same as PAPI_DEF_ITIMER_NS */
const PAPI_GRANUL = 7;
  //#define PAPI_EDGE_DETECT    9       /**< Count cycles of events if supported [not implemented] */
const PAPI_DEF_MPX_NS = 8;
  //#define PAPI_INVERT         10		/**< Invert count detect if supported [not implemented] */
//C     #define PAPI_MAX_MPX_CTRS	11      /**< Maximum number of counters we can multiplex */
//C     #define PAPI_PROFIL  		12      /**< Option to turn on the overflow/profil reporting software [not implemented] */
const PAPI_MAX_MPX_CTRS = 11;
//C     #define PAPI_PRELOAD 		13      /**< Option to find out the environment variable that can preload libraries */
const PAPI_PROFIL = 12;
//C     #define PAPI_CLOCKRATE  	14      /**< Clock rate in MHz */
const PAPI_PRELOAD = 13;
//C     #define PAPI_MAX_HWCTRS 	15      /**< Number of physical hardware counters */
const PAPI_CLOCKRATE = 14;
//C     #define PAPI_HWINFO  		16      /**< Hardware information */
const PAPI_MAX_HWCTRS = 15;
//C     #define PAPI_EXEINFO  		17      /**< Executable information */
const PAPI_HWINFO = 16;
//C     #define PAPI_MAX_CPUS 		18      /**< Number of ncpus we can talk to from here */
const PAPI_EXEINFO = 17;
//C     #define PAPI_ATTACH			19      /**< Attach to a another tid/pid instead of ourself */
const PAPI_MAX_CPUS = 18;
//C     #define PAPI_SHLIBINFO      20      /**< Shared Library information */
const PAPI_ATTACH = 19;
//C     #define PAPI_LIB_VERSION    21      /**< Option to find out the complete version number of the PAPI library */
const PAPI_SHLIBINFO = 20;
//C     #define PAPI_COMPONENTINFO  22      /**< Find out what the component supports */
const PAPI_LIB_VERSION = 21;
/* Currently the following options are only available on Itanium; they may be supported elsewhere in the future */
const PAPI_COMPONENTINFO = 22;
//C     #define PAPI_DATA_ADDRESS   23      /**< Option to set data address range restriction */
//C     #define PAPI_INSTR_ADDRESS  24      /**< Option to set instruction address range restriction */
const PAPI_DATA_ADDRESS = 23;
//C     #define PAPI_DEF_ITIMER		25		/**< Option to set the type of itimer used in both software multiplexing, overflowing and profiling */
const PAPI_INSTR_ADDRESS = 24;
//C     #define PAPI_DEF_ITIMER_NS	26		/**< Multiplexing/overflowing interval in ns, same as PAPI_DEF_MPX_NS */
const PAPI_DEF_ITIMER = 25;
/* Currently the following options are only available on systems using the perf_events component within papi */
const PAPI_DEF_ITIMER_NS = 26;
//C     #define PAPI_CPU_ATTACH		27      /**< Specify a cpu number the event set should be tied to */
//C     #define PAPI_INHERIT		28      /**< Option to set counter inheritance flag */
const PAPI_CPU_ATTACH = 27;
//C     #define PAPI_USER_EVENTS_FILE 29	/**< Option to set file from where to parse user defined events */
const PAPI_INHERIT = 28;

const PAPI_USER_EVENTS_FILE = 29;
//C     #define PAPI_INIT_SLOTS    64     
/*Number of initialized slots in
                                   DynamicArray of EventSets */

const PAPI_INIT_SLOTS = 64;
//C     #define PAPI_MIN_STR_LEN        64      /* For small strings, like names & stuff */
//C     #define PAPI_MAX_STR_LEN       128      /* For average run-of-the-mill strings */
const PAPI_MIN_STR_LEN = 64;
//C     #define PAPI_2MAX_STR_LEN      256      /* For somewhat longer run-of-the-mill strings */
const PAPI_MAX_STR_LEN = 128;
//C     #define PAPI_HUGE_STR_LEN     1024      /* This should be defined in terms of a system parameter */
const PAPI_2MAX_STR_LEN = 256;

const PAPI_HUGE_STR_LEN = 1024;
//C     #define PAPI_PMU_MAX           40      /* maximum number of pmu's supported by one component */
//C     #define PAPI_DERIVED           0x1      /* Flag to indicate that the event is derived */
const PAPI_PMU_MAX = 40;
/** @} */
const PAPI_DERIVED = 0x1;

/** Possible values for the 'modifier' parameter of the PAPI_enum_event call.
   A value of 0 (PAPI_ENUM_EVENTS) is always assumed to enumerate ALL 
   events on every platform.
   PAPI PRESET events are broken into related event categories.
   Each supported component can have optional values to determine how 
   native events on that component are enumerated.
*/
//C     enum {
//C        PAPI_ENUM_EVENTS = 0,		/**< Always enumerate all events */
//C        PAPI_ENUM_FIRST,				/**< Enumerate first event (preset or native) */
//C        PAPI_PRESET_ENUM_AVAIL, 		/**< Enumerate events that exist here */

   /* PAPI PRESET section */
//C        PAPI_PRESET_ENUM_MSC,		/**< Miscellaneous preset events */
//C        PAPI_PRESET_ENUM_INS,		/**< Instruction related preset events */
//C        PAPI_PRESET_ENUM_IDL,		/**< Stalled or Idle preset events */
//C        PAPI_PRESET_ENUM_BR,			/**< Branch related preset events */
//C        PAPI_PRESET_ENUM_CND,		/**< Conditional preset events */
//C        PAPI_PRESET_ENUM_MEM,		/**< Memory related preset events */
//C        PAPI_PRESET_ENUM_CACH,		/**< Cache related preset events */
//C        PAPI_PRESET_ENUM_L1,			/**< L1 cache related preset events */
//C        PAPI_PRESET_ENUM_L2,			/**< L2 cache related preset events */
//C        PAPI_PRESET_ENUM_L3,			/**< L3 cache related preset events */
//C        PAPI_PRESET_ENUM_TLB,		/**< Translation Lookaside Buffer events */
//C        PAPI_PRESET_ENUM_FP,			/**< Floating Point related preset events */

   /* PAPI native event related section */
//C        PAPI_NTV_ENUM_UMASKS,		/**< all individual bits for given group */
//C        PAPI_NTV_ENUM_UMASK_COMBOS,	/**< all combinations of mask bits for given group */
//C        PAPI_NTV_ENUM_IARR,			/**< Enumerate events that support IAR (instruction address ranging) */
//C        PAPI_NTV_ENUM_DARR,			/**< Enumerate events that support DAR (data address ranging) */
//C        PAPI_NTV_ENUM_OPCM,			/**< Enumerate events that support OPC (opcode matching) */
//C        PAPI_NTV_ENUM_IEAR,			/**< Enumerate IEAR (instruction event address register) events */
//C        PAPI_NTV_ENUM_DEAR,			/**< Enumerate DEAR (data event address register) events */
//C        PAPI_NTV_ENUM_GROUPS			/**< Enumerate groups an event belongs to (e.g. POWER5) */
//C     };
enum
{
    PAPI_ENUM_EVENTS,
    PAPI_ENUM_FIRST,
    PAPI_PRESET_ENUM_AVAIL,
    PAPI_PRESET_ENUM_MSC,
    PAPI_PRESET_ENUM_INS,
    PAPI_PRESET_ENUM_IDL,
    PAPI_PRESET_ENUM_BR,
    PAPI_PRESET_ENUM_CND,
    PAPI_PRESET_ENUM_MEM,
    PAPI_PRESET_ENUM_CACH,
    PAPI_PRESET_ENUM_L1,
    PAPI_PRESET_ENUM_L2,
    PAPI_PRESET_ENUM_L3,
    PAPI_PRESET_ENUM_TLB,
    PAPI_PRESET_ENUM_FP,
    PAPI_NTV_ENUM_UMASKS,
    PAPI_NTV_ENUM_UMASK_COMBOS,
    PAPI_NTV_ENUM_IARR,
    PAPI_NTV_ENUM_DARR,
    PAPI_NTV_ENUM_OPCM,
    PAPI_NTV_ENUM_IEAR,
    PAPI_NTV_ENUM_DEAR,
    PAPI_NTV_ENUM_GROUPS,
}

//C     #define PAPI_ENUM_ALL PAPI_ENUM_EVENTS

alias PAPI_ENUM_EVENTS PAPI_ENUM_ALL;
//C     #define PAPI_PRESET_BIT_MSC		(1 << PAPI_PRESET_ENUM_MSC)	/* Miscellaneous preset event bit */
//C     #define PAPI_PRESET_BIT_INS		(1 << PAPI_PRESET_ENUM_INS)	/* Instruction related preset event bit */
//C     #define PAPI_PRESET_BIT_IDL		(1 << PAPI_PRESET_ENUM_IDL)	/* Stalled or Idle preset event bit */
//C     #define PAPI_PRESET_BIT_BR		(1 << PAPI_PRESET_ENUM_BR)	/* branch related preset events */
//C     #define PAPI_PRESET_BIT_CND		(1 << PAPI_PRESET_ENUM_CND)	/* conditional preset events */
//C     #define PAPI_PRESET_BIT_MEM		(1 << PAPI_PRESET_ENUM_MEM)	/* memory related preset events */
//C     #define PAPI_PRESET_BIT_CACH	(1 << PAPI_PRESET_ENUM_CACH)	/* cache related preset events */
//C     #define PAPI_PRESET_BIT_L1		(1 << PAPI_PRESET_ENUM_L1)	/* L1 cache related preset events */
//C     #define PAPI_PRESET_BIT_L2		(1 << PAPI_PRESET_ENUM_L2)	/* L2 cache related preset events */
//C     #define PAPI_PRESET_BIT_L3		(1 << PAPI_PRESET_ENUM_L3)	/* L3 cache related preset events */
//C     #define PAPI_PRESET_BIT_TLB		(1 << PAPI_PRESET_ENUM_TLB)	/* Translation Lookaside Buffer events */
//C     #define PAPI_PRESET_BIT_FP		(1 << PAPI_PRESET_ENUM_FP)	/* Floating Point related preset events */

//C     #define PAPI_NTV_GROUP_AND_MASK		0x00FF0000	/* bits occupied by group number */
//C     #define PAPI_NTV_GROUP_SHIFT		16			/* bit shift to encode group number */
const PAPI_NTV_GROUP_AND_MASK = 0x00FF0000;
/** @} */
const PAPI_NTV_GROUP_SHIFT = 16;

/* 
The Low Level API

The following functions represent the low level portion of the
PerfAPI. These functions provide greatly increased efficiency and
functionality over the high level API presented in the next
section. All of the following functions are callable from both C and
Fortran except where noted. As mentioned in the introduction, the low
level API is only as powerful as the component upon which it is
built. Thus some features may not be available on every platform. The
converse may also be true, that more advanced features may be
available and defined in the header file.  The user is encouraged to
read the documentation carefully.  */


//#include <signal.h>

/*  Earlier versions of PAPI define a special long_long type to mask
	an incompatibility between the Windows compiler and gcc-style compilers.
	That problem no longer exists, so long_long has been purged from the source.
	The defines below preserve backward compatibility. Their use is deprecated,
	but will continue to be supported in the near term.
*/
//C     #define long_long long long
//C     #define u_long_long unsigned long long

/** @defgroup papi_data_structures PAPI Data Structures */

//C     	typedef unsigned long PAPI_thread_id_t;
extern (C):
alias uint PAPI_thread_id_t;

	/** @ingroup papi_data_structures */
//C     	typedef struct _papi_all_thr_spec {
//C          int num;
//C          PAPI_thread_id_t *id;
//C          void **data;
//C        } PAPI_all_thr_spec_t;
struct _papi_all_thr_spec
{
    int num;
    PAPI_thread_id_t *id;
    void **data;
}
alias _papi_all_thr_spec PAPI_all_thr_spec_t;

//C       typedef void (*PAPI_overflow_handler_t) (int EventSet, void *address,
//C                                     long long overflow_vector, void *context);
alias void  function(int EventSet, void *address, long overflow_vector, void *context)PAPI_overflow_handler_t;

        /* Handle C99 and more recent compilation */
	/* caddr_t was never approved by POSIX and is obsolete */
	/* We should probably switch all caddr_t to void * or long */
//C     #ifdef __STDC_VERSION__
//C       #if (__STDC_VERSION__ >= 199901L)
//C     	typedef char *caddr_t;
alias char *caddr_t;
//C       #else

//C       #endif
//C     #endif

	/** @ingroup papi_data_structures */
//C        typedef struct _papi_sprofil {
//C           void *pr_base;          /**< buffer base */
//C           unsigned pr_size;       /**< buffer size */
//C           caddr_t pr_off;         /**< pc start address (offset) */
//C           unsigned pr_scale;      
/**< pc scaling factor: 
                                 fixed point fraction
                                 0xffff ~= 1, 0x8000 == .5, 0x4000 == .25, etc.
                                 also, two extensions 0x1000 == 1, 0x2000 == 2 */
//C        } PAPI_sprofil_t;
struct _papi_sprofil
{
    void *pr_base;
    uint pr_size;
    caddr_t pr_off;
    uint pr_scale;
}
alias _papi_sprofil PAPI_sprofil_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_itimer_option {
//C          int itimer_num;
//C          int itimer_sig;
//C          int ns;
//C          int flags;
//C        } PAPI_itimer_option_t;
struct _papi_itimer_option
{
    int itimer_num;
    int itimer_sig;
    int ns;
    int flags;
}
alias _papi_itimer_option PAPI_itimer_option_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_inherit_option {
//C           int eventset;
//C           int inherit;
//C        } PAPI_inherit_option_t;
struct _papi_inherit_option
{
    int eventset;
    int inherit;
}
alias _papi_inherit_option PAPI_inherit_option_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_domain_option {
//C           int def_cidx; /**< this structure requires a component index to set default domains */
//C           int eventset;
//C           int domain;
//C        } PAPI_domain_option_t;
struct _papi_domain_option
{
    int def_cidx;
    int eventset;
    int domain;
}
alias _papi_domain_option PAPI_domain_option_t;

/**  @ingroup papi_data_structures*/
//C        typedef struct _papi_granularity_option {
//C           int def_cidx; /**< this structure requires a component index to set default granularity */
//C           int eventset;
//C           int granularity;
//C        } PAPI_granularity_option_t;
struct _papi_granularity_option
{
    int def_cidx;
    int eventset;
    int granularity;
}
alias _papi_granularity_option PAPI_granularity_option_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_preload_option {
//C           char lib_preload_env[PAPI_MAX_STR_LEN];   
//C           char lib_preload_sep;
//C           char lib_dir_env[PAPI_MAX_STR_LEN];
//C           char lib_dir_sep;
//C        } PAPI_preload_info_t;
struct _papi_preload_option
{
    char [128]lib_preload_env;
    char lib_preload_sep;
    char [128]lib_dir_env;
    char lib_dir_sep;
}
alias _papi_preload_option PAPI_preload_info_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_component_option {
//C          char name[PAPI_MAX_STR_LEN];            /**< Name of the component we're using */
//C          char short_name[PAPI_MIN_STR_LEN];      
/**< Short name of component,
						to be prepended to event names */
//C          char description[PAPI_MAX_STR_LEN];     /**< Description of the component */
//C          char version[PAPI_MIN_STR_LEN];         /**< Version of this component */
//C          char support_version[PAPI_MIN_STR_LEN]; /**< Version of the support library */
//C          char kernel_version[PAPI_MIN_STR_LEN];  /**< Version of the kernel PMC support driver */
//C          char disabled_reason[PAPI_MAX_STR_LEN]; /**< Reason for failure of initialization */
//C          int disabled;   /**< 0 if enabled, otherwise error code from initialization */
//C          int CmpIdx;				/**< Index into the vector array for this component; set at init time */
//C          int num_cntrs;               /**< Number of hardware counters the component supports */
//C          int num_mpx_cntrs;           /**< Number of hardware counters the component or PAPI can multiplex supports */
//C          int num_preset_events;       /**< Number of preset events the component supports */
//C          int num_native_events;       /**< Number of native events the component supports */
//C          int default_domain;          /**< The default domain when this component is used */
//C          int available_domains;       /**< Available domains */ 
//C          int default_granularity;     /**< The default granularity when this component is used */
//C          int available_granularities; /**< Available granularities */
//C          int hardware_intr_sig;       /**< Signal used by hardware to deliver PMC events */
//   int opcode_match_width;      /**< Width of opcode matcher if exists, 0 if not */
//C          int component_type;          /**< Type of component */
//C          char *pmu_names[PAPI_PMU_MAX];         /**< list of pmu names supported by this component */
//C          int reserved[8];             /* */
//C          unsigned int hardware_intr:1;         /**< hw overflow intr, does not need to be emulated in software*/
//C          unsigned int precise_intr:1;          /**< Performance interrupts happen precisely */
//C          unsigned int posix1b_timers:1;        /**< Using POSIX 1b interval timers (timer_create) instead of setitimer */
//C          unsigned int kernel_profile:1;        /**< Has kernel profiling support (buffered interrupts or sprofil-like) */
//C          unsigned int kernel_multiplex:1;      /**< In kernel multiplexing */
//   unsigned int data_address_range:1;    /**< Supports data address range limiting */
//   unsigned int instr_address_range:1;   /**< Supports instruction address range limiting */
//C          unsigned int fast_counter_read:1;     /**< Supports a user level PMC read instruction */
//C          unsigned int fast_real_timer:1;       /**< Supports a fast real timer */
//C          unsigned int fast_virtual_timer:1;    /**< Supports a fast virtual timer */
//C          unsigned int attach:1;                /**< Supports attach */
//C          unsigned int attach_must_ptrace:1;	   /**< Attach must first ptrace and stop the thread/process*/
//   unsigned int edge_detect:1;           /**< Supports edge detection on events */
//   unsigned int invert:1;                /**< Supports invert detection on events */
//   unsigned int profile_ear:1;      	   /**< Supports data/instr/tlb miss address sampling */
//     unsigned int cntr_groups:1;           /**< Underlying hardware uses counter groups (e.g. POWER5)*/
//C          unsigned int cntr_umasks:1;           /**< counters have unit masks */
//   unsigned int cntr_IEAR_events:1;      /**< counters support instr event addr register */
//   unsigned int cntr_DEAR_events:1;      /**< counters support data event addr register */
//   unsigned int cntr_OPCM_events:1;      /**< counter events support opcode matching */
     /* This should be a granularity option */
//C          unsigned int cpu:1;                   /**< Supports specifying cpu number to use with event set */
//C          unsigned int inherit:1;               /**< Supports child processes inheriting parents counters */
//C          unsigned int reserved_bits:12;
//C        } PAPI_component_info_t;
struct _papi_component_option
{
    char [128] name;
    char [64] short_name;
    char [128] description;
    char [64] version_;
    char [64] support_version;
    char [64] kernel_version;
    char [128] disabled_reason;
    int disabled;
    int CmpIdx;
    int num_cntrs;
    int num_mpx_cntrs;
    int num_preset_events;
    int num_native_events;
    int default_domain;
    int available_domains;
    int default_granularity;
    int available_granularities;
    int hardware_intr_sig;
    int component_type;
    char *[40] pmu_names;
    int [8] reserved;
    uint __bitfield1;
    uint hardware_intr() { return (__bitfield1 >> 0) & 0x1; }
    uint hardware_intr(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffffffe) | (value << 0); return value; }
    uint precise_intr() { return (__bitfield1 >> 1) & 0x1; }
    uint precise_intr(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffffffd) | (value << 1); return value; }
    uint posix1b_timers() { return (__bitfield1 >> 2) & 0x1; }
    uint posix1b_timers(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffffffb) | (value << 2); return value; }
    uint kernel_profile() { return (__bitfield1 >> 3) & 0x1; }
    uint kernel_profile(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffffff7) | (value << 3); return value; }
    uint kernel_multiplex() { return (__bitfield1 >> 4) & 0x1; }
    uint kernel_multiplex(uint value) { __bitfield1 = (__bitfield1 & 0xffffffffffffffef) | (value << 4); return value; }
    uint fast_counter_read() { return (__bitfield1 >> 5) & 0x1; }
    uint fast_counter_read(uint value) { __bitfield1 = (__bitfield1 & 0xffffffffffffffdf) | (value << 5); return value; }
    uint fast_real_timer() { return (__bitfield1 >> 6) & 0x1; }
    uint fast_real_timer(uint value) { __bitfield1 = (__bitfield1 & 0xffffffffffffffbf) | (value << 6); return value; }
    uint fast_virtual_timer() { return (__bitfield1 >> 7) & 0x1; }
    uint fast_virtual_timer(uint value) { __bitfield1 = (__bitfield1 & 0xffffffffffffff7f) | (value << 7); return value; }
    uint attach() { return (__bitfield1 >> 8) & 0x1; }
    uint attach(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffffeff) | (value << 8); return value; }
    uint attach_must_ptrace() { return (__bitfield1 >> 9) & 0x1; }
    uint attach_must_ptrace(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffffdff) | (value << 9); return value; }
    uint cntr_umasks() { return (__bitfield1 >> 10) & 0x1; }
    uint cntr_umasks(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffffbff) | (value << 10); return value; }
    uint cpu() { return (__bitfield1 >> 11) & 0x1; }
    uint cpu(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffffff7ff) | (value << 11); return value; }
    uint inherit() { return (__bitfield1 >> 12) & 0x1; }
    uint inherit(uint value) { __bitfield1 = (__bitfield1 & 0xffffffffffffefff) | (value << 12); return value; }
    uint reserved_bits() { return (__bitfield1 >> 13) & 0xfff; }
    uint reserved_bits(uint value) { __bitfield1 = (__bitfield1 & 0xfffffffffe001fff) | (value << 13); return value; }
}
alias _papi_component_option PAPI_component_info_t;

/**  @ingroup papi_data_structures*/
//C        typedef struct _papi_mpx_info {
//C          int timer_sig;				/**< Signal number used by the multiplex timer, 0 if not: PAPI_SIGNAL */
//C          int timer_num;				/**< Number of the itimer or POSIX 1 timer used by the multiplex timer: PAPI_ITIMER */
//C          int timer_us;				/**< uS between switching of sets: PAPI_MPX_DEF_US */
//C        } PAPI_mpx_info_t;
struct _papi_mpx_info
{
    int timer_sig;
    int timer_num;
    int timer_us;
}
alias _papi_mpx_info PAPI_mpx_info_t;

//C        typedef int (*PAPI_debug_handler_t) (int code);
alias int  function(int code)PAPI_debug_handler_t;

   /** @ingroup papi_data_structures */
//C        typedef struct _papi_debug_option {
//C           int level;
//C           PAPI_debug_handler_t handler;
//C        } PAPI_debug_option_t;
struct _papi_debug_option
{
    int level;
    PAPI_debug_handler_t handler;
}
alias _papi_debug_option PAPI_debug_option_t;

/** @ingroup papi_data_structures
	@brief get the executable's address space info */
//C        typedef struct _papi_address_map {
//C           char name[PAPI_HUGE_STR_LEN];
//C           caddr_t text_start;       /**< Start address of program text segment */
//C           caddr_t text_end;         /**< End address of program text segment */
//C           caddr_t data_start;       /**< Start address of program data segment */
//C           caddr_t data_end;         /**< End address of program data segment */
//C           caddr_t bss_start;        /**< Start address of program bss segment */
//C           caddr_t bss_end;          /**< End address of program bss segment */
//C        } PAPI_address_map_t;
struct _papi_address_map
{
    char [1024]name;
    caddr_t text_start;
    caddr_t text_end;
    caddr_t data_start;
    caddr_t data_end;
    caddr_t bss_start;
    caddr_t bss_end;
}
alias _papi_address_map PAPI_address_map_t;

/** @ingroup papi_data_structures
	@brief get the executable's info */
//C        typedef struct _papi_program_info {
//C           char fullname[PAPI_HUGE_STR_LEN];  /**< path + name */
//C           PAPI_address_map_t address_info;	 /**< executable's address space info */
//C        } PAPI_exe_info_t;
struct _papi_program_info
{
    char [1024]fullname;
    PAPI_address_map_t address_info;
}
alias _papi_program_info PAPI_exe_info_t;

   /** @ingroup papi_data_structures */
//C        typedef struct _papi_shared_lib_info {
//C           PAPI_address_map_t *map;
//C           int count;
//C        } PAPI_shlib_info_t;
struct _papi_shared_lib_info
{
    PAPI_address_map_t *map;
    int count;
}
alias _papi_shared_lib_info PAPI_shlib_info_t;

/** Specify the file containing user defined events. */
//C     typedef char* PAPI_user_defined_events_file_t;
alias char *PAPI_user_defined_events_file_t;

   /* The following defines and next for structures define the memory hierarchy */
   /* All sizes are in BYTES */
   /* Associativity:
		0: Undefined;
		1: Direct Mapped
		SHRT_MAX: Full
		Other values == associativity
   */
//C     #define PAPI_MH_TYPE_EMPTY    0x0
//C     #define PAPI_MH_TYPE_INST     0x1
const PAPI_MH_TYPE_EMPTY = 0x0;
//C     #define PAPI_MH_TYPE_DATA     0x2
const PAPI_MH_TYPE_INST = 0x1;
//C     #define PAPI_MH_TYPE_VECTOR   0x4
const PAPI_MH_TYPE_DATA = 0x2;
//C     #define PAPI_MH_TYPE_TRACE    0x8
const PAPI_MH_TYPE_VECTOR = 0x4;
//C     #define PAPI_MH_TYPE_UNIFIED  (PAPI_MH_TYPE_INST|PAPI_MH_TYPE_DATA)
const PAPI_MH_TYPE_TRACE = 0x8;
//C     #define PAPI_MH_CACHE_TYPE(a) (a & 0xf)
//C     #define PAPI_MH_TYPE_WT       0x00	   /* write-through cache */
//C     #define PAPI_MH_TYPE_WB       0x10	   /* write-back cache */
const PAPI_MH_TYPE_WT = 0x00;
//C     #define PAPI_MH_CACHE_WRITE_POLICY(a) (a & 0xf0)
const PAPI_MH_TYPE_WB = 0x10;
//C     #define PAPI_MH_TYPE_UNKNOWN  0x000
//C     #define PAPI_MH_TYPE_LRU      0x100
const PAPI_MH_TYPE_UNKNOWN = 0x000;
//C     #define PAPI_MH_TYPE_PSEUDO_LRU 0x200
const PAPI_MH_TYPE_LRU = 0x100;
//C     #define PAPI_MH_CACHE_REPLACEMENT_POLICY(a) (a & 0xf00)
const PAPI_MH_TYPE_PSEUDO_LRU = 0x200;
//C     #define PAPI_MH_TYPE_TLB       0x1000  /* tlb, not memory cache */
//C     #define PAPI_MH_TYPE_PREF      0x2000  /* prefetch buffer */
const PAPI_MH_TYPE_TLB = 0x1000;
//C     #define PAPI_MH_MAX_LEVELS    6		   /* # descriptors for each TLB or cache level */
const PAPI_MH_TYPE_PREF = 0x2000;
//C     #define PAPI_MAX_MEM_HIERARCHY_LEVELS 	  4
const PAPI_MH_MAX_LEVELS = 6;

const PAPI_MAX_MEM_HIERARCHY_LEVELS = 4;
/** @ingroup papi_data_structures */
//C        typedef struct _papi_mh_tlb_info {
//C           int type; /**< Empty, instr, data, vector, unified */
//C           int num_entries;
//C           int page_size;
//C           int associativity;
//C        } PAPI_mh_tlb_info_t;
struct _papi_mh_tlb_info
{
    int type;
    int num_entries;
    int page_size;
    int associativity;
}
alias _papi_mh_tlb_info PAPI_mh_tlb_info_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_mh_cache_info {
//C           int type; /**< Empty, instr, data, vector, trace, unified */
//C           int size;
//C           int line_size;
//C           int num_lines;
//C           int associativity;
//C        } PAPI_mh_cache_info_t;
struct _papi_mh_cache_info
{
    int type;
    int size;
    int line_size;
    int num_lines;
    int associativity;
}
alias _papi_mh_cache_info PAPI_mh_cache_info_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_mh_level_info {
//C           PAPI_mh_tlb_info_t   tlb[PAPI_MH_MAX_LEVELS];
//C           PAPI_mh_cache_info_t cache[PAPI_MH_MAX_LEVELS];
//C        } PAPI_mh_level_t;
struct _papi_mh_level_info
{
    PAPI_mh_tlb_info_t [6]tlb;
    PAPI_mh_cache_info_t [6]cache;
}
alias _papi_mh_level_info PAPI_mh_level_t;

/**  @ingroup papi_data_structures
  *	 @brief mh for mem hierarchy maybe? */
//C        typedef struct _papi_mh_info { 
//C           int levels;
//C           PAPI_mh_level_t level[PAPI_MAX_MEM_HIERARCHY_LEVELS];
//C        } PAPI_mh_info_t;
struct _papi_mh_info
{
    int levels;
    PAPI_mh_level_t [4]level;
}
alias _papi_mh_info PAPI_mh_info_t;

/**  @ingroup papi_data_structures
  *  @brief Hardware info structure */
//C        typedef struct _papi_hw_info {
//C           int ncpu;                     /**< Number of CPUs per NUMA Node */
//C           int threads;                  /**< Number of hdw threads per core */
//C           int cores;                    /**< Number of cores per socket */
//C           int sockets;                  /**< Number of sockets */
//C           int nnodes;                   /**< Total Number of NUMA Nodes */
//C           int totalcpus;                /**< Total number of CPUs in the entire system */
//C           int vendor;                   /**< Vendor number of CPU */
//C           char vendor_string[PAPI_MAX_STR_LEN];     /**< Vendor string of CPU */
//C           int model;                    /**< Model number of CPU */
//C           char model_string[PAPI_MAX_STR_LEN];      /**< Model string of CPU */
//C           float revision;               /**< Revision of CPU */
//C           int cpuid_family;             /**< cpuid family */
//C           int cpuid_model;              /**< cpuid model */
//C           int cpuid_stepping;           /**< cpuid stepping */

//C           int cpu_max_mhz;              /**< Maximum supported CPU speed */
//C           int cpu_min_mhz;              /**< Minimum supported CPU speed */

//C           PAPI_mh_info_t mem_hierarchy; /**< PAPI memory hierarchy description */
//C           int virtualized;              /**< Running in virtual machine */
//C           char virtual_vendor_string[PAPI_MAX_STR_LEN]; 
                                    /**< Vendor for virtual machine */
//C           char virtual_vendor_version[PAPI_MAX_STR_LEN];
                                    /**< Version of virtual machine */

      /* Legacy Values, do not use */
//C           float mhz;                    /**< Deprecated */
//C           int clock_mhz;                /**< Deprecated */

      /* For future expansion */
//C           int reserved[8];

//C        } PAPI_hw_info_t;
struct _papi_hw_info
{
    int ncpu;
    int threads;
    int cores;
    int sockets;
    int nnodes;
    int totalcpus;
    int vendor;
    char [128]vendor_string;
    int model;
    char [128]model_string;
    float revision;
    int cpuid_family;
    int cpuid_model;
    int cpuid_stepping;
    int cpu_max_mhz;
    int cpu_min_mhz;
    PAPI_mh_info_t mem_hierarchy;
    int virtualized;
    char [128]virtual_vendor_string;
    char [128]virtual_vendor_version;
    float mhz;
    int clock_mhz;
    int [8]reserved;
}
alias _papi_hw_info PAPI_hw_info_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_attach_option {
//C           int eventset;
//C           unsigned long tid;
//C        } PAPI_attach_option_t;
struct _papi_attach_option
{
    int eventset;
    uint tid;
}
alias _papi_attach_option PAPI_attach_option_t;

/**  @ingroup papi_data_structures*/
//C           typedef struct _papi_cpu_option {
//C              int eventset;
//C              unsigned int cpu_num;
//C           } PAPI_cpu_option_t;
struct _papi_cpu_option
{
    int eventset;
    uint cpu_num;
}
alias _papi_cpu_option PAPI_cpu_option_t;

/** @ingroup papi_data_structures */
//C        typedef struct _papi_multiplex_option {
//C           int eventset;
//C           int ns;
//C           int flags;
//C        } PAPI_multiplex_option_t;
struct _papi_multiplex_option
{
    int eventset;
    int ns;
    int flags;
}
alias _papi_multiplex_option PAPI_multiplex_option_t;

   /** @ingroup papi_data_structures 
	 *  @brief address range specification for range restricted counting if both are zero, range is disabled  */
//C        typedef struct _papi_addr_range_option { 
//C           int eventset;           /**< eventset to restrict */
//C           caddr_t start;          /**< user requested start address of an address range */
//C           caddr_t end;            /**< user requested end address of an address range */
//C           int start_off;          /**< hardware specified offset from start address */
//C           int end_off;            /**< hardware specified offset from end address */
//C        } PAPI_addr_range_option_t;
struct _papi_addr_range_option
{
    int eventset;
    caddr_t start;
    caddr_t end;
    int start_off;
    int end_off;
}
alias _papi_addr_range_option PAPI_addr_range_option_t;

/** @ingroup papi_data_structures 
  *	@union PAPI_option_t
  *	@brief A pointer to the following is passed to PAPI_set/get_opt() */

//C     	typedef union
//C     	{
//C     		PAPI_preload_info_t preload;
//C     		PAPI_debug_option_t debug;
//C     		PAPI_inherit_option_t inherit;
//C     		PAPI_granularity_option_t granularity;
//C     		PAPI_granularity_option_t defgranularity;
//C     		PAPI_domain_option_t domain;
//C     		PAPI_domain_option_t defdomain;
//C     		PAPI_attach_option_t attach;
//C     		PAPI_cpu_option_t cpu;
//C     		PAPI_multiplex_option_t multiplex;
//C     		PAPI_itimer_option_t itimer;
//C     		PAPI_hw_info_t *hw_info;
//C     		PAPI_shlib_info_t *shlib_info;
//C     		PAPI_exe_info_t *exe_info;
//C     		PAPI_component_info_t *cmp_info;
//C     		PAPI_addr_range_option_t addr;
//C     		PAPI_user_defined_events_file_t events_file;
//C     	} PAPI_option_t;
union _N3
{
    PAPI_preload_info_t preload;
    PAPI_debug_option_t debug_;
    PAPI_inherit_option_t inherit;
    PAPI_granularity_option_t granularity;
    PAPI_granularity_option_t defgranularity;
    PAPI_domain_option_t domain;
    PAPI_domain_option_t defdomain;
    PAPI_attach_option_t attach;
    PAPI_cpu_option_t cpu;
    PAPI_multiplex_option_t multiplex;
    PAPI_itimer_option_t itimer;
    PAPI_hw_info_t *hw_info;
    PAPI_shlib_info_t *shlib_info;
    PAPI_exe_info_t *exe_info;
    PAPI_component_info_t *cmp_info;
    PAPI_addr_range_option_t addr;
    PAPI_user_defined_events_file_t events_file;
}
alias _N3 PAPI_option_t;

/** @ingroup papi_data_structures
  *	@brief A pointer to the following is passed to PAPI_get_dmem_info() */
//C     	typedef struct _dmem_t {
//C     	  long long peak;
//C     	  long long size;
//C     	  long long resident;
//C     	  long long high_water_mark;
//C     	  long long shared;
//C     	  long long text;
//C     	  long long library;
//C     	  long long heap;
//C     	  long long locked;
//C     	  long long stack;
//C     	  long long pagesize;
//C     	  long long pte;
//C     	} PAPI_dmem_info_t;
struct _dmem_t
{
    long peak;
    long size;
    long resident;
    long high_water_mark;
    long shared_;
    long text;
    long library;
    long heap;
    long locked;
    long stack;
    long pagesize;
    long pte;
}
alias _dmem_t PAPI_dmem_info_t;

/* Fortran offsets into PAPI_dmem_info_t structure. */

//C     #define PAPIF_DMEM_VMPEAK     1
//C     #define PAPIF_DMEM_VMSIZE     2
const PAPIF_DMEM_VMPEAK = 1;
//C     #define PAPIF_DMEM_RESIDENT   3
const PAPIF_DMEM_VMSIZE = 2;
//C     #define PAPIF_DMEM_HIGH_WATER 4
const PAPIF_DMEM_RESIDENT = 3;
//C     #define PAPIF_DMEM_SHARED     5
const PAPIF_DMEM_HIGH_WATER = 4;
//C     #define PAPIF_DMEM_TEXT       6
const PAPIF_DMEM_SHARED = 5;
//C     #define PAPIF_DMEM_LIBRARY    7
const PAPIF_DMEM_TEXT = 6;
//C     #define PAPIF_DMEM_HEAP       8
const PAPIF_DMEM_LIBRARY = 7;
//C     #define PAPIF_DMEM_LOCKED     9
const PAPIF_DMEM_HEAP = 8;
//C     #define PAPIF_DMEM_STACK      10
const PAPIF_DMEM_LOCKED = 9;
//C     #define PAPIF_DMEM_PAGESIZE   11
const PAPIF_DMEM_STACK = 10;
//C     #define PAPIF_DMEM_PTE        12
const PAPIF_DMEM_PAGESIZE = 11;
//C     #define PAPIF_DMEM_MAXVAL     12
const PAPIF_DMEM_PTE = 12;

const PAPIF_DMEM_MAXVAL = 12;
//C     #define PAPI_MAX_INFO_TERMS  12		   /* should match PAPI_EVENTS_IN_DERIVED_EVENT defined in papi_internal.h */

const PAPI_MAX_INFO_TERMS = 12;

/** @ingroup papi_data_structures 
  *	@brief This structure is the event information that is exposed to the user through the API.

   The same structure is used to describe both preset and native events.
   WARNING: This structure is very large. With current definitions, it is about 2660 bytes.
   Unlike previous versions of PAPI, which allocated an array of these structures within
   the library, this structure is carved from user space. It does not exist inside the library,
   and only one copy need ever exist.
   The basic philosophy is this:
   - each preset consists of a code, some descriptors, and an array of native events;
   - each native event consists of a code, and an array of register values;
   - fields are shared between preset and native events, and unused where not applicable;
   - To completely describe a preset event, the code must present all available
      information for that preset, and then walk the list of native events, retrieving
      and presenting information for each native event in turn.
   The various fields and their usage is discussed below.
*/


/** Enum values for event_info location field */
//C     enum {
//C        PAPI_LOCATION_CORE = 0,			/**< Measures local to core      */
//C        PAPI_LOCATION_CPU,				/**< Measures local to CPU (HT?) */
//C        PAPI_LOCATION_PACKAGE,			/**< Measures local to package   */
//C        PAPI_LOCATION_UNCORE,			/**< Measures uncore             */
//C     };
enum
{
    PAPI_LOCATION_CORE,
    PAPI_LOCATION_CPU,
    PAPI_LOCATION_PACKAGE,
    PAPI_LOCATION_UNCORE,
}

/** Enum values for event_info data_type field */
//C     enum {
//C        PAPI_DATATYPE_INT64 = 0,			/**< Default: Data is a signed 64-bit int   */
//C        PAPI_DATATYPE_UINT64,			/**< Data is a unsigned 64-bit int */
//C        PAPI_DATATYPE_FP64,				/**< Data is 64-bit floating point */
//C        PAPI_DATATYPE_BIT64,				/**< Data is 64-bit binary */
//C     };
enum
{
    PAPI_DATATYPE_INT64,
    PAPI_DATATYPE_UINT64,
    PAPI_DATATYPE_FP64,
    PAPI_DATATYPE_BIT64,
}

/** Enum values for event_info value_type field */
//C     enum {
//C        PAPI_VALUETYPE_RUNNING_SUM = 0,	/**< Data is running sum from start */
//C        PAPI_VALUETYPE_ABSOLUTE,	        /**< Data is from last read */
//C     };
enum
{
    PAPI_VALUETYPE_RUNNING_SUM,
    PAPI_VALUETYPE_ABSOLUTE,
}

/** Enum values for event_info timescope field */
//C     enum {
//C        PAPI_TIMESCOPE_SINCE_START = 0,	/**< Data is cumulative from start */
//C        PAPI_TIMESCOPE_SINCE_LAST,		/**< Data is from last read */
//C        PAPI_TIMESCOPE_UNTIL_NEXT,		/**< Data is until next read */
//C        PAPI_TIMESCOPE_POINT,			/**< Data is an instantaneous value */
//C     };
enum
{
    PAPI_TIMESCOPE_SINCE_START,
    PAPI_TIMESCOPE_SINCE_LAST,
    PAPI_TIMESCOPE_UNTIL_NEXT,
    PAPI_TIMESCOPE_POINT,
}

/** Enum values for event_info update_type field */
//C     enum {
//C        PAPI_UPDATETYPE_ARBITRARY = 0,	/**< Data is cumulative from start */
//C        PAPI_UPDATETYPE_PUSH,	        /**< Data is pushed */
//C        PAPI_UPDATETYPE_PULL,	        /**< Data is pulled */
//C        PAPI_UPDATETYPE_FIXEDFREQ,	    /**< Data is read periodically */
//C     };
enum
{
    PAPI_UPDATETYPE_ARBITRARY,
    PAPI_UPDATETYPE_PUSH,
    PAPI_UPDATETYPE_PULL,
    PAPI_UPDATETYPE_FIXEDFREQ,
}


//C        typedef struct event_info {
//C           unsigned int event_code;             
/**< preset (0x8xxxxxxx) or 
                                                native (0x4xxxxxxx) event code */
//C           char symbol[PAPI_HUGE_STR_LEN];      /**< name of the event */
//C           char short_descr[PAPI_MIN_STR_LEN];  
/**< a short description suitable for 
                                                use as a label */
//C           char long_descr[PAPI_HUGE_STR_LEN];  
/**< a longer description:
                                                typically a sentence for presets,
                                                possibly a paragraph from vendor
                                                docs for native events */

//C           int component_index;           /**< component this event belongs to */
//C           char units[PAPI_MIN_STR_LEN];  /**< units event is measured in */
//C           int location;                  /**< location event applies to */
//C           int data_type;                 /**< data type returned by PAPI */
//C           int value_type;                /**< sum or absolute */
//C           int timescope;                 /**< from start, etc. */
//C           int update_type;               /**< how event is updated */
//C           int update_freq;               /**< how frequently event is updated */

     /* PRESET SPECIFIC FIELDS FOLLOW */



//C           unsigned int count;                
/**< number of terms (usually 1) 
                                              in the code and name fields 
                                              - presets: these are native events
                                              - native: these are unused */

//C           unsigned int event_type;           
/**< event type or category 
                                              for preset events only */

//C           char derived[PAPI_MIN_STR_LEN];    
/**< name of the derived type
                                              - presets: usually NOT_DERIVED
                                              - native: empty string */
//C           char postfix[PAPI_2MAX_STR_LEN];   
/**< string containing postfix 
                                              operations; only defined for 
                                              preset events of derived type 
                                              DERIVED_POSTFIX */

//C           unsigned int code[PAPI_MAX_INFO_TERMS]; 
/**< array of values that further 
                                              describe the event:
                                              - presets: native event_code values
                                              - native:, register values(?) */

//C           char name[PAPI_MAX_INFO_TERMS]         /**< names of code terms: */
//C                    [PAPI_2MAX_STR_LEN];          
/**< - presets: native event names,
                                                  - native: descriptive strings 
						  for each register value(?) */

//C          char note[PAPI_HUGE_STR_LEN];          
/**< an optional developer note 
                                                supplied with a preset event
                                                to delineate platform specific 
						anomalies or restrictions */

//C        } PAPI_event_info_t;
struct event_info
{
    uint event_code;
    char [1024]symbol;
    char [64]short_descr;
    char [1024]long_descr;
    int component_index;
    char [64]units;
    int location;
    int data_type;
    int value_type;
    int timescope;
    int update_type;
    int update_freq;
    uint count;
    uint event_type;
    char [64]derived;
    char [256]postfix;
    uint [12]code;
    char [256][12]name;
    char [1024]note;
}
alias event_info PAPI_event_info_t;




/** \internal
  * @defgroup low_api The Low Level API 
  @{ */
//C        int   PAPI_accum(int EventSet, long long * values); /**< accumulate and reset hardware events from an event set */
int  PAPI_accum(int EventSet, long *values);
//C        int   PAPI_add_event(int EventSet, int Event); /**< add single PAPI preset or native hardware event to an event set */
int  PAPI_add_event(int EventSet, int Event);
//C        int   PAPI_add_named_event(int EventSet, const char *EventName); /**< add an event by name to a PAPI event set */
int  PAPI_add_named_event(int EventSet, char *EventName);
//C        int   PAPI_add_events(int EventSet, int *Events, int number); /**< add array of PAPI preset or native hardware events to an event set */
int  PAPI_add_events(int EventSet, int *Events, int number);
//C        int   PAPI_assign_eventset_component(int EventSet, int cidx); /**< assign a component index to an existing but empty eventset */
int  PAPI_assign_eventset_component(int EventSet, int cidx);
//C        int   PAPI_attach(int EventSet, unsigned long tid); /**< attach specified event set to a specific process or thread id */
int  PAPI_attach(int EventSet, uint tid);
//C        int   PAPI_cleanup_eventset(int EventSet); /**< remove all PAPI events from an event set */
int  PAPI_cleanup_eventset(int EventSet);
//C        int   PAPI_create_eventset(int *EventSet); /**< create a new empty PAPI event set */
int  PAPI_create_eventset(int *EventSet);
//C        int   PAPI_detach(int EventSet); /**< detach specified event set from a previously specified process or thread id */
int  PAPI_detach(int EventSet);
//C        int   PAPI_destroy_eventset(int *EventSet); /**< deallocates memory associated with an empty PAPI event set */
int  PAPI_destroy_eventset(int *EventSet);
//C        int   PAPI_enum_event(int *EventCode, int modifier); /**< return the event code for the next available preset or natvie event */
int  PAPI_enum_event(int *EventCode, int modifier);
//C        int   PAPI_enum_cmp_event(int *EventCode, int modifier, int cidx); /**< return the event code for the next available component event */
int  PAPI_enum_cmp_event(int *EventCode, int modifier, int cidx);
//C        int   PAPI_event_code_to_name(int EventCode, char *out); /**< translate an integer PAPI event code into an ASCII PAPI preset or native name */
int  PAPI_event_code_to_name(int EventCode, char * out_);
//C        int   PAPI_event_name_to_code(const char *in, int *out); /**< translate an ASCII PAPI preset or native name into an integer PAPI event code */
int  PAPI_event_name_to_code(char * in_, int *out_);
//C        int  PAPI_get_dmem_info(PAPI_dmem_info_t *dest); /**< get dynamic memory usage information */
int  PAPI_get_dmem_info(PAPI_dmem_info_t *dest);
//C        int   PAPI_get_event_info(int EventCode, PAPI_event_info_t * info); /**< get the name and descriptions for a given preset or native event code */
int  PAPI_get_event_info(int EventCode, PAPI_event_info_t *info);
//C        const PAPI_exe_info_t *PAPI_get_executable_info(void); /**< get the executable's address space information */
PAPI_exe_info_t * PAPI_get_executable_info();
//C        const PAPI_hw_info_t *PAPI_get_hardware_info(void); /**< get information about the system hardware */
PAPI_hw_info_t * PAPI_get_hardware_info();
//C        const PAPI_component_info_t *PAPI_get_component_info(int cidx); /**< get information about the component features */
PAPI_component_info_t * PAPI_get_component_info(int cidx);
//C        int   PAPI_get_multiplex(int EventSet); /**< get the multiplexing status of specified event set */
int  PAPI_get_multiplex(int EventSet);
//C        int   PAPI_get_opt(int option, PAPI_option_t * ptr); /**< query the option settings of the PAPI library or a specific event set */
int  PAPI_get_opt(int option, PAPI_option_t *ptr);
//C        int   PAPI_get_cmp_opt(int option, PAPI_option_t * ptr,int cidx); /**< query the component specific option settings of a specific event set */
int  PAPI_get_cmp_opt(int option, PAPI_option_t *ptr, int cidx);
//C        long long PAPI_get_real_cyc(void); /**< return the total number of cycles since some arbitrary starting point */
long  PAPI_get_real_cyc();
//C        long long PAPI_get_real_nsec(void); /**< return the total number of nanoseconds since some arbitrary starting point */
long  PAPI_get_real_nsec();
//C        long long PAPI_get_real_usec(void); /**< return the total number of microseconds since some arbitrary starting point */
long  PAPI_get_real_usec();
//C        const PAPI_shlib_info_t *PAPI_get_shared_lib_info(void); /**< get information about the shared libraries used by the process */
PAPI_shlib_info_t * PAPI_get_shared_lib_info();
//C        int   PAPI_get_thr_specific(int tag, void **ptr); /**< return a pointer to a thread specific stored data structure */
int  PAPI_get_thr_specific(int tag, void **ptr);
//C        int   PAPI_get_overflow_event_index(int Eventset, long long overflow_vector, int *array, int *number); /**< # decomposes an overflow_vector into an event index array */
int  PAPI_get_overflow_event_index(int Eventset, long overflow_vector, int *array, int *number);
//C        long long PAPI_get_virt_cyc(void); /**< return the process cycles since some arbitrary starting point */
long  PAPI_get_virt_cyc();
//C        long long PAPI_get_virt_nsec(void); /**< return the process nanoseconds since some arbitrary starting point */
long  PAPI_get_virt_nsec();
//C        long long PAPI_get_virt_usec(void); /**< return the process microseconds since some arbitrary starting point */
long  PAPI_get_virt_usec();
//C        int   PAPI_is_initialized(void); /**< return the initialized state of the PAPI library */
int  PAPI_is_initialized();
//C        int   PAPI_library_init(int version); /**< initialize the PAPI library */
int  PAPI_library_init(int version_);
//C        int   PAPI_list_events(int EventSet, int *Events, int *number); /**< list the events that are members of an event set */
int  PAPI_list_events(int EventSet, int *Events, int *number);
//C        int   PAPI_list_threads(unsigned long *tids, int *number); /**< list the thread ids currently known to PAPI */
int  PAPI_list_threads(uint *tids, int *number);
//C        int   PAPI_lock(int); /**< lock one of two PAPI internal user mutex variables */
int  PAPI_lock(int );
//C        int   PAPI_multiplex_init(void); /**< initialize multiplex support in the PAPI library */
int  PAPI_multiplex_init();
//C        int   PAPI_num_cmp_hwctrs(int cidx); /**< return the number of hardware counters for a specified component */
int  PAPI_num_cmp_hwctrs(int cidx);
//C        int   PAPI_num_events(int EventSet); /**< return the number of events in an event set */
int  PAPI_num_events(int EventSet);
//C        int   PAPI_overflow(int EventSet, int EventCode, int threshold,
//C                          int flags, PAPI_overflow_handler_t handler); /**< set up an event set to begin registering overflows */
int  PAPI_overflow(int EventSet, int EventCode, int threshold, int flags, PAPI_overflow_handler_t handler);
//C        void  PAPI_perror(const char *msg ); /**< Print a PAPI error message */
void  PAPI_perror(char *msg);
//C        int   PAPI_profil(void *buf, unsigned bufsiz, caddr_t offset, 
//C     					 unsigned scale, int EventSet, int EventCode, 
//C     					 int threshold, int flags); /**< generate PC histogram data where hardware counter overflow occurs */
int  PAPI_profil(void *buf, uint bufsiz, caddr_t offset, uint scale, int EventSet, int EventCode, int threshold, int flags);
//C        int   PAPI_query_event(int EventCode); /**< query if a PAPI event exists */
int  PAPI_query_event(int EventCode);
//C        int   PAPI_query_named_event(const char *EventName); /**< query if a named PAPI event exists */
int  PAPI_query_named_event(char *EventName);
//C        int   PAPI_read(int EventSet, long long * values); /**< read hardware events from an event set with no reset */
int  PAPI_read(int EventSet, long *values);
//C        int   PAPI_read_ts(int EventSet, long long * values, long long *cyc); /**< read from an eventset with a real-time cycle timestamp */
int  PAPI_read_ts(int EventSet, long *values, long *cyc);
//C        int   PAPI_register_thread(void); /**< inform PAPI of the existence of a new thread */
int  PAPI_register_thread();
//C        int   PAPI_remove_event(int EventSet, int EventCode); /**< remove a hardware event from a PAPI event set */
int  PAPI_remove_event(int EventSet, int EventCode);
//C        int   PAPI_remove_named_event(int EventSet, const char *EventName); /**< remove a named event from a PAPI event set */
int  PAPI_remove_named_event(int EventSet, char *EventName);
//C        int   PAPI_remove_events(int EventSet, int *Events, int number); /**< remove an array of hardware events from a PAPI event set */
int  PAPI_remove_events(int EventSet, int *Events, int number);
//C        int   PAPI_reset(int EventSet); /**< reset the hardware event counts in an event set */
int  PAPI_reset(int EventSet);
//C        int   PAPI_set_debug(int level); /**< set the current debug level for PAPI */
int  PAPI_set_debug(int level);
//C        int   PAPI_set_cmp_domain(int domain, int cidx); /**< set the component specific default execution domain for new event sets */
int  PAPI_set_cmp_domain(int domain, int cidx);
//C        int   PAPI_set_domain(int domain); /**< set the default execution domain for new event sets  */
int  PAPI_set_domain(int domain);
//C        int   PAPI_set_cmp_granularity(int granularity, int cidx); /**< set the component specific default granularity for new event sets */
int  PAPI_set_cmp_granularity(int granularity, int cidx);
//C        int   PAPI_set_granularity(int granularity); /**<set the default granularity for new event sets */
int  PAPI_set_granularity(int granularity);
//C        int   PAPI_set_multiplex(int EventSet); /**< convert a standard event set to a multiplexed event set */
int  PAPI_set_multiplex(int EventSet);
//C        int   PAPI_set_opt(int option, PAPI_option_t * ptr); /**< change the option settings of the PAPI library or a specific event set */
int  PAPI_set_opt(int option, PAPI_option_t *ptr);
//C        int   PAPI_set_thr_specific(int tag, void *ptr); /**< save a pointer as a thread specific stored data structure */
int  PAPI_set_thr_specific(int tag, void *ptr);
//C        void  PAPI_shutdown(void); /**< finish using PAPI and free all related resources */
void  PAPI_shutdown();
//C        int   PAPI_sprofil(PAPI_sprofil_t * prof, int profcnt, int EventSet, int EventCode, int threshold, int flags); /**< generate hardware counter profiles from multiple code regions */
int  PAPI_sprofil(PAPI_sprofil_t *prof, int profcnt, int EventSet, int EventCode, int threshold, int flags);
//C        int   PAPI_start(int EventSet); /**< start counting hardware events in an event set */
int  PAPI_start(int EventSet);
//C        int   PAPI_state(int EventSet, int *status); /**< return the counting state of an event set */
int  PAPI_state(int EventSet, int *status);
//C        int   PAPI_stop(int EventSet, long long * values); /**< stop counting hardware events in an event set and return current events */
int  PAPI_stop(int EventSet, long *values);
//C        char *PAPI_strerror(int); /**< return a pointer to the error name corresponding to a specified error code */
char * PAPI_strerror(int );
//C        unsigned long PAPI_thread_id(void); /**< get the thread identifier of the current thread */
uint  PAPI_thread_id();
//C        int   PAPI_thread_init(unsigned long (*id_fn) (void)); /**< initialize thread support in the PAPI library */
int  PAPI_thread_init(uint  function()id_fn);
//C        int   PAPI_unlock(int); /**< unlock one of two PAPI internal user mutex variables */
int  PAPI_unlock(int );
//C        int   PAPI_unregister_thread(void); /**< inform PAPI that a previously registered thread is disappearing */
int  PAPI_unregister_thread();
//C        int   PAPI_write(int EventSet, long long * values); /**< write counter values into counters */
int  PAPI_write(int EventSet, long *values);
//C        int   PAPI_get_event_component(int EventCode);  /**< return which component an EventCode belongs to */
int  PAPI_get_event_component(int EventCode);
//C        int   PAPI_get_eventset_component(int EventSet);  /**< return which component an EventSet is assigned to */
int  PAPI_get_eventset_component(int EventSet);
//C        int   PAPI_get_component_index(const char *name); /**< Return component index for component with matching name */
int  PAPI_get_component_index(char *name);
//C        int   PAPI_disable_component(int cidx); /**< Disables a component before init */
int  PAPI_disable_component(int cidx);
//C        int	 PAPI_disable_component_by_name(const char *name ); /**< Disable, before library init, a component by name. */
int  PAPI_disable_component_by_name(char *name);


   /** @} */

/** \internal
  @defgroup high_api  The High Level API 

   The simple interface implemented by the following eight routines
   allows the user to access and count specific hardware events from
   both C and Fortran. It should be noted that this API can be used in
   conjunction with the low level API. 
	@{ */

//C        int PAPI_accum_counters(long long * values, int array_len); /**< add current counts to array and reset counters */
int  PAPI_accum_counters(long *values, int array_len);
//C        int PAPI_num_counters(void); /**< get the number of hardware counters available on the system */
int  PAPI_num_counters();
//C        int PAPI_num_components(void); /**< get the number of components available on the system */
int  PAPI_num_components();
//C        int PAPI_read_counters(long long * values, int array_len); /**< copy current counts to array and reset counters */
int  PAPI_read_counters(long *values, int array_len);
//C        int PAPI_start_counters(int *events, int array_len); /**< start counting hardware events */
int  PAPI_start_counters(int *events, int array_len);
//C        int PAPI_stop_counters(long long * values, int array_len); /**< stop counters and return current counts */
int  PAPI_stop_counters(long *values, int array_len);
//C        int PAPI_flips(float *rtime, float *ptime, long long * flpins, float *mflips); /**< simplified call to get Mflips/s (floating point instruction rate), real and processor time */
int  PAPI_flips(float *rtime, float *ptime, long *flpins, float *mflips);
//C        int PAPI_flops(float *rtime, float *ptime, long long * flpops, float *mflops); /**< simplified call to get Mflops/s (floating point operation rate), real and processor time */
int  PAPI_flops(float *rtime, float *ptime, long *flpops, float *mflops);
//C        int PAPI_ipc(float *rtime, float *ptime, long long * ins, float *ipc); /**< gets instructions per cycle, real and processor time */
int  PAPI_ipc(float *rtime, float *ptime, long *ins, float *ipc);
//C        int PAPI_epc(int event, float *rtime, float *ptime, long long *ref, long long *core, long long *evt, float *epc); /**< gets (named) events per cycle, real and processor time, reference and core cycles */
int  PAPI_epc(int event, float *rtime, float *ptime, long * ref_, long *core, long *evt, float *epc);
/** @} */



/* Backwards compatibility hacks.  Remove eventually? */
//C     int   PAPI_num_hwctrs(void); /**< return the number of hardware counters for the cpu. for backward compatibility. Don't use! */
int  PAPI_num_hwctrs();
//C     #define PAPI_COMPONENT_INDEX(a) PAPI_get_event_component(a)
//C     #define PAPI_descr_error(a) PAPI_strerror(a)

//C     #ifdef __cplusplus
//C     }
//C     #endif







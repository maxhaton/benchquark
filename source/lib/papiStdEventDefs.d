/* Converted to D from papiStdEventDefs.h by htod */
module lib.papiStdEventDefs;
extern(C):
@nogc:
/* Converted to D from papiStdEventDefs.h by htod */


/* file: papiStdEventDefs.h

The following is a list of hardware events deemed relevant and useful
in tuning application performance. These events have identical
assignments in the header files on different platforms however they
may differ in their actual semantics. In addition, all of these events
are not guaranteed to be present on all platforms.  Please check your
platform's documentation carefully.

*/
//C     #ifndef _PAPISTDEVENTDEFS
//C     #define _PAPISTDEVENTDEFS

/*
   Masks to indicate the event is a preset- the presets will have 
   the high bit set to one, as the vendors probably won't use the 
   higher numbers for the native events 
   This causes a problem for signed ints on 64 bit systems, since the
   'high bit' is no longer the high bit. An alternative is to AND
   with PAPI_PRESET_AND_MASK) instead of XOR with PAPI_PRESET_MASK to isolate
   the event bits.
   Native events for a specific platform can be defined by setting
   the next-highest bit. This gives PAPI a standardized way of 
   differentiating native events from preset events for query
   functions, etc.
*/

const int PAPI_PRESET_MASK    = 0x80000000;
const int  PAPI_NATIVE_MASK   =  (0x40000000);
const int PAPI_UE_MASK		= (0xC0000000);


const PAPI_PRESET_AND_MASK = 0x7FFFFFFF;
//C     #define PAPI_UE_AND_MASK     0x3FFFFFFF
const PAPI_NATIVE_AND_MASK = 0xBFFFFFFF;

const PAPI_UE_AND_MASK = 0x3FFFFFFF;
//C     #define PAPI_MAX_PRESET_EVENTS 128		/*The maxmimum number of preset events */
//C     #define PAPI_MAX_USER_EVENTS 50			/*The maxmimum number of user defined events */
const PAPI_MAX_PRESET_EVENTS = 128;
//C     #define USER_EVENT_OPERATION_LEN 512	/*The maximum length of the operation string for user defined events */
const PAPI_MAX_USER_EVENTS = 50;

const USER_EVENT_OPERATION_LEN = 512;
/*
   NOTE: The table below defines each entry in terms of a mask and an integer.
   The integers MUST be in consecutive order with no gaps.
   If an event is removed or added, all following events MUST be renumbered.
   One way to fix this would be to recast each #define in terms of the preceeding
   one instead of an absolute number. e.g.:
     #define PAPI_L1_ICM  (PAPI_L1_DCM + 1)
   That way inserting or deleting events would only affect the definition of one
   other event.
*/

//C     enum
//C     {
//C     	PAPI_L1_DCM_idx = 0,			   /*Level 1 data cache misses */
//C     	PAPI_L1_ICM_idx,		 /*Level 1 instruction cache misses */
//C     	PAPI_L2_DCM_idx,		 /*Level 2 data cache misses */
//C     	PAPI_L2_ICM_idx,		 /*Level 2 instruction cache misses */
//C     	PAPI_L3_DCM_idx,		 /*Level 3 data cache misses */
//C     	PAPI_L3_ICM_idx,		 /*Level 3 instruction cache misses */
//C     	PAPI_L1_TCM_idx,		 /*Level 1 total cache misses */
//C     	PAPI_L2_TCM_idx,		 /*Level 2 total cache misses */
//C     	PAPI_L3_TCM_idx,		 /*Level 3 total cache misses */
//C     	PAPI_CA_SNP_idx,		 /*Snoops */
//C     	PAPI_CA_SHR_idx,		 /*Request for shared cache line (SMP) */
//C     	PAPI_CA_CLN_idx,		 /*Request for clean cache line (SMP) */
//C     	PAPI_CA_INV_idx,		 /*Request for cache line Invalidation (SMP) */
//C     	PAPI_CA_ITV_idx,		 /*Request for cache line Intervention (SMP) */
//C     	PAPI_L3_LDM_idx,		 /*Level 3 load misses */
//C     	PAPI_L3_STM_idx,		 /*Level 3 store misses */
/* 0x10 */
//C     	PAPI_BRU_IDL_idx,		 /*Cycles branch units are idle */
//C     	PAPI_FXU_IDL_idx,		 /*Cycles integer units are idle */
//C     	PAPI_FPU_IDL_idx,		 /*Cycles floating point units are idle */
//C     	PAPI_LSU_IDL_idx,		 /*Cycles load/store units are idle */
//C     	PAPI_TLB_DM_idx,		 /*Data translation lookaside buffer misses */
//C     	PAPI_TLB_IM_idx,		 /*Instr translation lookaside buffer misses */
//C     	PAPI_TLB_TL_idx,		 /*Total translation lookaside buffer misses */
//C     	PAPI_L1_LDM_idx,		 /*Level 1 load misses */
//C     	PAPI_L1_STM_idx,		 /*Level 1 store misses */
//C     	PAPI_L2_LDM_idx,		 /*Level 2 load misses */
//C     	PAPI_L2_STM_idx,		 /*Level 2 store misses */
//C     	PAPI_BTAC_M_idx,		 /*BTAC miss */
//C     	PAPI_PRF_DM_idx,		 /*Prefetch data instruction caused a miss */
//C     	PAPI_L3_DCH_idx,		 /*Level 3 Data Cache Hit */
//C     	PAPI_TLB_SD_idx,		 /*Xlation lookaside buffer shootdowns (SMP) */
//C     	PAPI_CSR_FAL_idx,		 /*Failed store conditional instructions */
/* 0x20 */
//C     	PAPI_CSR_SUC_idx,		 /*Successful store conditional instructions */
//C     	PAPI_CSR_TOT_idx,		 /*Total store conditional instructions */
//C     	PAPI_MEM_SCY_idx,		 /*Cycles Stalled Waiting for Memory Access */
//C     	PAPI_MEM_RCY_idx,		 /*Cycles Stalled Waiting for Memory Read */
//C     	PAPI_MEM_WCY_idx,		 /*Cycles Stalled Waiting for Memory Write */
//C     	PAPI_STL_ICY_idx,		 /*Cycles with No Instruction Issue */
//C     	PAPI_FUL_ICY_idx,		 /*Cycles with Maximum Instruction Issue */
//C     	PAPI_STL_CCY_idx,		 /*Cycles with No Instruction Completion */
//C     	PAPI_FUL_CCY_idx,		 /*Cycles with Maximum Instruction Completion */
//C     	PAPI_HW_INT_idx,		 /*Hardware interrupts */
//C     	PAPI_BR_UCN_idx,		 /*Unconditional branch instructions executed */
//C     	PAPI_BR_CN_idx,			 /*Conditional branch instructions executed */
//C     	PAPI_BR_TKN_idx,		 /*Conditional branch instructions taken */
//C     	PAPI_BR_NTK_idx,		 /*Conditional branch instructions not taken */
//C     	PAPI_BR_MSP_idx,		 /*Conditional branch instructions mispred */
//C     	PAPI_BR_PRC_idx,		 /*Conditional branch instructions corr. pred */
/* 0x30 */
//C     	PAPI_FMA_INS_idx,		 /*FMA instructions completed */
//C     	PAPI_TOT_IIS_idx,		 /*Total instructions issued */
//C     	PAPI_TOT_INS_idx,		 /*Total instructions executed */
//C     	PAPI_INT_INS_idx,		 /*Integer instructions executed */
//C     	PAPI_FP_INS_idx,		 /*Floating point instructions executed */
//C     	PAPI_LD_INS_idx,		 /*Load instructions executed */
//C     	PAPI_SR_INS_idx,		 /*Store instructions executed */
//C     	PAPI_BR_INS_idx,		 /*Total branch instructions executed */
//C     	PAPI_VEC_INS_idx,		 /*Vector/SIMD instructions executed (could include integer) */
//C     	PAPI_RES_STL_idx,		 /*Cycles processor is stalled on resource */
//C     	PAPI_FP_STAL_idx,		 /*Cycles any FP units are stalled */
//C     	PAPI_TOT_CYC_idx,		 /*Total cycles executed */
//C     	PAPI_LST_INS_idx,		 /*Total load/store inst. executed */
//C     	PAPI_SYC_INS_idx,		 /*Sync. inst. executed */
//C     	PAPI_L1_DCH_idx,		 /*L1 D Cache Hit */
//C     	PAPI_L2_DCH_idx,		 /*L2 D Cache Hit */
	/* 0x40 */
//C     	PAPI_L1_DCA_idx,		 /*L1 D Cache Access */
//C     	PAPI_L2_DCA_idx,		 /*L2 D Cache Access */
//C     	PAPI_L3_DCA_idx,		 /*L3 D Cache Access */
//C     	PAPI_L1_DCR_idx,		 /*L1 D Cache Read */
//C     	PAPI_L2_DCR_idx,		 /*L2 D Cache Read */
//C     	PAPI_L3_DCR_idx,		 /*L3 D Cache Read */
//C     	PAPI_L1_DCW_idx,		 /*L1 D Cache Write */
//C     	PAPI_L2_DCW_idx,		 /*L2 D Cache Write */
//C     	PAPI_L3_DCW_idx,		 /*L3 D Cache Write */
//C     	PAPI_L1_ICH_idx,		 /*L1 instruction cache hits */
//C     	PAPI_L2_ICH_idx,		 /*L2 instruction cache hits */
//C     	PAPI_L3_ICH_idx,		 /*L3 instruction cache hits */
//C     	PAPI_L1_ICA_idx,		 /*L1 instruction cache accesses */
//C     	PAPI_L2_ICA_idx,		 /*L2 instruction cache accesses */
//C     	PAPI_L3_ICA_idx,		 /*L3 instruction cache accesses */
//C     	PAPI_L1_ICR_idx,		 /*L1 instruction cache reads */
	/* 0x50 */
//C     	PAPI_L2_ICR_idx,		 /*L2 instruction cache reads */
//C     	PAPI_L3_ICR_idx,		 /*L3 instruction cache reads */
//C     	PAPI_L1_ICW_idx,		 /*L1 instruction cache writes */
//C     	PAPI_L2_ICW_idx,		 /*L2 instruction cache writes */
//C     	PAPI_L3_ICW_idx,		 /*L3 instruction cache writes */
//C     	PAPI_L1_TCH_idx,		 /*L1 total cache hits */
//C     	PAPI_L2_TCH_idx,		 /*L2 total cache hits */
//C     	PAPI_L3_TCH_idx,		 /*L3 total cache hits */
//C     	PAPI_L1_TCA_idx,		 /*L1 total cache accesses */
//C     	PAPI_L2_TCA_idx,		 /*L2 total cache accesses */
//C     	PAPI_L3_TCA_idx,		 /*L3 total cache accesses */
//C     	PAPI_L1_TCR_idx,		 /*L1 total cache reads */
//C     	PAPI_L2_TCR_idx,		 /*L2 total cache reads */
//C     	PAPI_L3_TCR_idx,		 /*L3 total cache reads */
//C     	PAPI_L1_TCW_idx,		 /*L1 total cache writes */
//C     	PAPI_L2_TCW_idx,		 /*L2 total cache writes */
	/* 0x60 */
//C     	PAPI_L3_TCW_idx,		 /*L3 total cache writes */
//C     	PAPI_FML_INS_idx,		 /*FM ins */
//C     	PAPI_FAD_INS_idx,		 /*FA ins */
//C     	PAPI_FDV_INS_idx,		 /*FD ins */
//C     	PAPI_FSQ_INS_idx,		 /*FSq ins */
//C     	PAPI_FNV_INS_idx,		 /*Finv ins */
//C     	PAPI_FP_OPS_idx,		 /*Floating point operations executed */
//C     	PAPI_SP_OPS_idx,		 /* Floating point operations executed; optimized to count scaled single precision vector operations */
//C     	PAPI_DP_OPS_idx,		 /* Floating point operations executed; optimized to count scaled double precision vector operations */
//C     	PAPI_VEC_SP_idx,		 /* Single precision vector/SIMD instructions */
//C     	PAPI_VEC_DP_idx,		 /* Double precision vector/SIMD instructions */
//C     	PAPI_REF_CYC_idx,		 /* Reference clock cycles */
//C     	PAPI_END_idx			 /*This should always be last! */
//C     };
enum
{
    PAPI_L1_DCM_idx,
    PAPI_L1_ICM_idx,
    PAPI_L2_DCM_idx,
    PAPI_L2_ICM_idx,
    PAPI_L3_DCM_idx,
    PAPI_L3_ICM_idx,
    PAPI_L1_TCM_idx,
    PAPI_L2_TCM_idx,
    PAPI_L3_TCM_idx,
    PAPI_CA_SNP_idx,
    PAPI_CA_SHR_idx,
    PAPI_CA_CLN_idx,
    PAPI_CA_INV_idx,
    PAPI_CA_ITV_idx,
    PAPI_L3_LDM_idx,
    PAPI_L3_STM_idx,
    PAPI_BRU_IDL_idx,
    PAPI_FXU_IDL_idx,
    PAPI_FPU_IDL_idx,
    PAPI_LSU_IDL_idx,
    PAPI_TLB_DM_idx,
    PAPI_TLB_IM_idx,
    PAPI_TLB_TL_idx,
    PAPI_L1_LDM_idx,
    PAPI_L1_STM_idx,
    PAPI_L2_LDM_idx,
    PAPI_L2_STM_idx,
    PAPI_BTAC_M_idx,
    PAPI_PRF_DM_idx,
    PAPI_L3_DCH_idx,
    PAPI_TLB_SD_idx,
    PAPI_CSR_FAL_idx,
    PAPI_CSR_SUC_idx,
    PAPI_CSR_TOT_idx,
    PAPI_MEM_SCY_idx,
    PAPI_MEM_RCY_idx,
    PAPI_MEM_WCY_idx,
    PAPI_STL_ICY_idx,
    PAPI_FUL_ICY_idx,
    PAPI_STL_CCY_idx,
    PAPI_FUL_CCY_idx,
    PAPI_HW_INT_idx,
    PAPI_BR_UCN_idx,
    PAPI_BR_CN_idx,
    PAPI_BR_TKN_idx,
    PAPI_BR_NTK_idx,
    PAPI_BR_MSP_idx,
    PAPI_BR_PRC_idx,
    PAPI_FMA_INS_idx,
    PAPI_TOT_IIS_idx,
    PAPI_TOT_INS_idx,
    PAPI_INT_INS_idx,
    PAPI_FP_INS_idx,
    PAPI_LD_INS_idx,
    PAPI_SR_INS_idx,
    PAPI_BR_INS_idx,
    PAPI_VEC_INS_idx,
    PAPI_RES_STL_idx,
    PAPI_FP_STAL_idx,
    PAPI_TOT_CYC_idx,
    PAPI_LST_INS_idx,
    PAPI_SYC_INS_idx,
    PAPI_L1_DCH_idx,
    PAPI_L2_DCH_idx,
    PAPI_L1_DCA_idx,
    PAPI_L2_DCA_idx,
    PAPI_L3_DCA_idx,
    PAPI_L1_DCR_idx,
    PAPI_L2_DCR_idx,
    PAPI_L3_DCR_idx,
    PAPI_L1_DCW_idx,
    PAPI_L2_DCW_idx,
    PAPI_L3_DCW_idx,
    PAPI_L1_ICH_idx,
    PAPI_L2_ICH_idx,
    PAPI_L3_ICH_idx,
    PAPI_L1_ICA_idx,
    PAPI_L2_ICA_idx,
    PAPI_L3_ICA_idx,
    PAPI_L1_ICR_idx,
    PAPI_L2_ICR_idx,
    PAPI_L3_ICR_idx,
    PAPI_L1_ICW_idx,
    PAPI_L2_ICW_idx,
    PAPI_L3_ICW_idx,
    PAPI_L1_TCH_idx,
    PAPI_L2_TCH_idx,
    PAPI_L3_TCH_idx,
    PAPI_L1_TCA_idx,
    PAPI_L2_TCA_idx,
    PAPI_L3_TCA_idx,
    PAPI_L1_TCR_idx,
    PAPI_L2_TCR_idx,
    PAPI_L3_TCR_idx,
    PAPI_L1_TCW_idx,
    PAPI_L2_TCW_idx,
    PAPI_L3_TCW_idx,
    PAPI_FML_INS_idx,
    PAPI_FAD_INS_idx,
    PAPI_FDV_INS_idx,
    PAPI_FSQ_INS_idx,
    PAPI_FNV_INS_idx,
    PAPI_FP_OPS_idx,
    PAPI_SP_OPS_idx,
    PAPI_DP_OPS_idx,
    PAPI_VEC_SP_idx,
    PAPI_VEC_DP_idx,
    PAPI_REF_CYC_idx,
    PAPI_END_idx,
}

const  PAPI_L1_DCM = (PAPI_L1_DCM_idx  | PAPI_PRESET_MASK)	/*Level 1 data cache misses */
const  PAPI_L1_ICM = (PAPI_L1_ICM_idx  | PAPI_PRESET_MASK)	;/*Level 1 instruction cache misses */
const  PAPI_L2_DCM = (PAPI_L2_DCM_idx  | PAPI_PRESET_MASK)	;/*Level 2 data cache misses */
const  PAPI_L2_ICM = (PAPI_L2_ICM_idx  | PAPI_PRESET_MASK)	;/*Level 2 instruction cache misses */
const  PAPI_L3_DCM = (PAPI_L3_DCM_idx  | PAPI_PRESET_MASK)	;/*Level 3 data cache misses */
const  PAPI_L3_ICM = (PAPI_L3_ICM_idx  | PAPI_PRESET_MASK)	;/*Level 3 instruction cache misses */
const  PAPI_L1_TCM = (PAPI_L1_TCM_idx  | PAPI_PRESET_MASK)	;/*Level 1 total cache misses */
const  PAPI_L2_TCM = (PAPI_L2_TCM_idx  | PAPI_PRESET_MASK)	;/*Level 2 total cache misses */
const  PAPI_L3_TCM = (PAPI_L3_TCM_idx  | PAPI_PRESET_MASK)	;/*Level 3 total cache misses */
const  PAPI_CA_SNP = (PAPI_CA_SNP_idx  | PAPI_PRESET_MASK)	;/*Snoops */
const  PAPI_CA_SHR = (PAPI_CA_SHR_idx  | PAPI_PRESET_MASK)	;/*Request for shared cache line (SMP) */
const  PAPI_CA_CLN = (PAPI_CA_CLN_idx  | PAPI_PRESET_MASK)	;/*Request for clean cache line (SMP) */
const  PAPI_CA_INV = (PAPI_CA_INV_idx  | PAPI_PRESET_MASK)	;/*Request for cache line Invalidation (SMP) */
const  PAPI_CA_ITV = (PAPI_CA_ITV_idx  | PAPI_PRESET_MASK)	;/*Request for cache line Intervention (SMP) */
const  PAPI_L3_LDM = (PAPI_L3_LDM_idx  | PAPI_PRESET_MASK)	;/*Level 3 load misses */
const  PAPI_L3_STM = (PAPI_L3_STM_idx  | PAPI_PRESET_MASK)	;/*Level 3 store misses */
const  PAPI_BRU_IDL= (PAPI_BRU_IDL_idx | PAPI_PRESET_MASK)	;/*Cycles branch units are idle */
const  PAPI_FXU_IDL= (PAPI_FXU_IDL_idx | PAPI_PRESET_MASK)	;/*Cycles integer units are idle */
const  PAPI_FPU_IDL= (PAPI_FPU_IDL_idx | PAPI_PRESET_MASK)	;/*Cycles floating point units are idle */
const  PAPI_LSU_IDL= (PAPI_LSU_IDL_idx | PAPI_PRESET_MASK)	;/*Cycles load/store units are idle */
const  PAPI_TLB_DM = (PAPI_TLB_DM_idx  | PAPI_PRESET_MASK)	;/*Data translation lookaside buffer misses */
const  PAPI_TLB_IM = (PAPI_TLB_IM_idx  | PAPI_PRESET_MASK)	;/*Instr translation lookaside buffer misses */
const  PAPI_TLB_TL = (PAPI_TLB_TL_idx  | PAPI_PRESET_MASK)	;/*Total translation lookaside buffer misses */
const  PAPI_L1_LDM = (PAPI_L1_LDM_idx  | PAPI_PRESET_MASK)	;/*Level 1 load misses */
const  PAPI_L1_STM = (PAPI_L1_STM_idx  | PAPI_PRESET_MASK)	;/*Level 1 store misses */
const  PAPI_L2_LDM = (PAPI_L2_LDM_idx  | PAPI_PRESET_MASK)	;/*Level 2 load misses */
const  PAPI_L2_STM = (PAPI_L2_STM_idx  | PAPI_PRESET_MASK)	;/*Level 2 store misses */
const  PAPI_BTAC_M = (PAPI_BTAC_M_idx  | PAPI_PRESET_MASK)	;/*BTAC miss */
const  PAPI_PRF_DM = (PAPI_PRF_DM_idx  | PAPI_PRESET_MASK)	;/*Prefetch data instruction caused a miss */
const  PAPI_L3_DCH = (PAPI_L3_DCH_idx  | PAPI_PRESET_MASK)	;/*Level 3 Data Cache Hit */
const  PAPI_TLB_SD = (PAPI_TLB_SD_idx  | PAPI_PRESET_MASK)	;/*Xlation lookaside buffer shootdowns (SMP) */
const  PAPI_CSR_FAL= (PAPI_CSR_FAL_idx | PAPI_PRESET_MASK)	;/*Failed store conditional instructions */
const  PAPI_CSR_SUC= (PAPI_CSR_SUC_idx | PAPI_PRESET_MASK)	;/*Successful store conditional instructions */
const  PAPI_CSR_TOT= (PAPI_CSR_TOT_idx | PAPI_PRESET_MASK)	;/*Total store conditional instructions */
const  PAPI_MEM_SCY= (PAPI_MEM_SCY_idx | PAPI_PRESET_MASK)	;/*Cycles Stalled Waiting for Memory Access */
const  PAPI_MEM_RCY= (PAPI_MEM_RCY_idx | PAPI_PRESET_MASK)	;/*Cycles Stalled Waiting for Memory Read */
const  PAPI_MEM_WCY= (PAPI_MEM_WCY_idx | PAPI_PRESET_MASK)	;/*Cycles Stalled Waiting for Memory Write */
const  PAPI_STL_ICY= (PAPI_STL_ICY_idx | PAPI_PRESET_MASK)	;/*Cycles with No Instruction Issue */
const  PAPI_FUL_ICY= (PAPI_FUL_ICY_idx | PAPI_PRESET_MASK)	;/*Cycles with Maximum Instruction Issue */
const  PAPI_STL_CCY= (PAPI_STL_CCY_idx | PAPI_PRESET_MASK)	;/*Cycles with No Instruction Completion */
const  PAPI_FUL_CCY= (PAPI_FUL_CCY_idx | PAPI_PRESET_MASK)	;/*Cycles with Maximum Instruction Completion */
const  PAPI_HW_INT = (PAPI_HW_INT_idx  | PAPI_PRESET_MASK)	;/*Hardware interrupts */
const  PAPI_BR_UCN = (PAPI_BR_UCN_idx  | PAPI_PRESET_MASK)	;/*Unconditional branch instructions executed */
const  PAPI_BR_CN  = (PAPI_BR_CN_idx   | PAPI_PRESET_MASK)	;/*Conditional branch instructions executed */
const  PAPI_BR_TKN = (PAPI_BR_TKN_idx  | PAPI_PRESET_MASK)	;/*Conditional branch instructions taken */
const  PAPI_BR_NTK = (PAPI_BR_NTK_idx  | PAPI_PRESET_MASK)	;/*Conditional branch instructions not taken */
const  PAPI_BR_MSP = (PAPI_BR_MSP_idx  | PAPI_PRESET_MASK)	;/*Conditional branch instructions mispred */
const  PAPI_BR_PRC = (PAPI_BR_PRC_idx  | PAPI_PRESET_MASK)	;/*Conditional branch instructions corr. pred */
const  PAPI_FMA_INS= (PAPI_FMA_INS_idx | PAPI_PRESET_MASK)	;/*FMA instructions completed */
const  PAPI_TOT_IIS= (PAPI_TOT_IIS_idx | PAPI_PRESET_MASK)	;/*Total instructions issued */
const  PAPI_TOT_INS= (PAPI_TOT_INS_idx | PAPI_PRESET_MASK)	;/*Total instructions executed */
const  PAPI_INT_INS= (PAPI_INT_INS_idx | PAPI_PRESET_MASK)	;/*Integer instructions executed */
const  PAPI_FP_INS = (PAPI_FP_INS_idx  | PAPI_PRESET_MASK)	;/*Floating point instructions executed */
const  PAPI_LD_INS = (PAPI_LD_INS_idx  | PAPI_PRESET_MASK)	;/*Load instructions executed */
const  PAPI_SR_INS = (PAPI_SR_INS_idx  | PAPI_PRESET_MASK)	;/*Store instructions executed */
const  PAPI_BR_INS = (PAPI_BR_INS_idx  | PAPI_PRESET_MASK)	;/*Total branch instructions executed */
const  PAPI_VEC_INS= (PAPI_VEC_INS_idx | PAPI_PRESET_MASK)	;/*Vector/SIMD instructions executed (could include integer) */
const  PAPI_RES_STL= (PAPI_RES_STL_idx | PAPI_PRESET_MASK)	;/*Cycles processor is stalled on resource */
const  PAPI_FP_STAL= (PAPI_FP_STAL_idx | PAPI_PRESET_MASK)	;/*Cycles any FP units are stalled */
const  PAPI_TOT_CYC= (PAPI_TOT_CYC_idx | PAPI_PRESET_MASK)	;/*Total cycles executed */
const  PAPI_LST_INS= (PAPI_LST_INS_idx | PAPI_PRESET_MASK)	;/*Total load/store inst. executed */
const  PAPI_SYC_INS= (PAPI_SYC_INS_idx | PAPI_PRESET_MASK)	;/*Sync. inst. executed */
const  PAPI_L1_DCH = (PAPI_L1_DCH_idx  | PAPI_PRESET_MASK)	;/*L1 D Cache Hit */
const  PAPI_L2_DCH = (PAPI_L2_DCH_idx  | PAPI_PRESET_MASK)	;/*L2 D Cache Hit */
const  PAPI_L1_DCA = (PAPI_L1_DCA_idx  | PAPI_PRESET_MASK)	;/*L1 D Cache Access */
const  PAPI_L2_DCA = (PAPI_L2_DCA_idx  | PAPI_PRESET_MASK)	;/*L2 D Cache Access */
const  PAPI_L3_DCA = (PAPI_L3_DCA_idx  | PAPI_PRESET_MASK)	;/*L3 D Cache Access */
const  PAPI_L1_DCR = (PAPI_L1_DCR_idx  | PAPI_PRESET_MASK)	;/*L1 D Cache Read */
const  PAPI_L2_DCR = (PAPI_L2_DCR_idx  | PAPI_PRESET_MASK)	;/*L2 D Cache Read */
const  PAPI_L3_DCR = (PAPI_L3_DCR_idx  | PAPI_PRESET_MASK)	;/*L3 D Cache Read */
const  PAPI_L1_DCW = (PAPI_L1_DCW_idx  | PAPI_PRESET_MASK)	;/*L1 D Cache Write */
const  PAPI_L2_DCW = (PAPI_L2_DCW_idx  | PAPI_PRESET_MASK)	;/*L2 D Cache Write */
const  PAPI_L3_DCW = (PAPI_L3_DCW_idx  | PAPI_PRESET_MASK)	;/*L3 D Cache Write */
const  PAPI_L1_ICH = (PAPI_L1_ICH_idx  | PAPI_PRESET_MASK)	;/*L1 instruction cache hits */
const  PAPI_L2_ICH = (PAPI_L2_ICH_idx  | PAPI_PRESET_MASK)	;/*L2 instruction cache hits */
const  PAPI_L3_ICH = (PAPI_L3_ICH_idx  | PAPI_PRESET_MASK)	;/*L3 instruction cache hits */
const  PAPI_L1_ICA = (PAPI_L1_ICA_idx  | PAPI_PRESET_MASK)	;/*L1 instruction cache accesses */
const  PAPI_L2_ICA = (PAPI_L2_ICA_idx  | PAPI_PRESET_MASK)	;/*L2 instruction cache accesses */
const  PAPI_L3_ICA = (PAPI_L3_ICA_idx  | PAPI_PRESET_MASK)	;/*L3 instruction cache accesses */
const  PAPI_L1_ICR = (PAPI_L1_ICR_idx  | PAPI_PRESET_MASK)	;/*L1 instruction cache reads */
const  PAPI_L2_ICR = (PAPI_L2_ICR_idx  | PAPI_PRESET_MASK)	;/*L2 instruction cache reads */
const  PAPI_L3_ICR = (PAPI_L3_ICR_idx  | PAPI_PRESET_MASK)	;/*L3 instruction cache reads */
const  PAPI_L1_ICW = (PAPI_L1_ICW_idx  | PAPI_PRESET_MASK)	;/*L1 instruction cache writes */
const  PAPI_L2_ICW = (PAPI_L2_ICW_idx  | PAPI_PRESET_MASK)	;/*L2 instruction cache writes */
const  PAPI_L3_ICW = (PAPI_L3_ICW_idx  | PAPI_PRESET_MASK)	;/*L3 instruction cache writes */
const  PAPI_L1_TCH = (PAPI_L1_TCH_idx  | PAPI_PRESET_MASK)	;/*L1 total cache hits */
const  PAPI_L2_TCH = (PAPI_L2_TCH_idx  | PAPI_PRESET_MASK)	;/*L2 total cache hits */
const  PAPI_L3_TCH = (PAPI_L3_TCH_idx  | PAPI_PRESET_MASK)	;/*L3 total cache hits */
const  PAPI_L1_TCA = (PAPI_L1_TCA_idx  | PAPI_PRESET_MASK)	;/*L1 total cache accesses */
const  PAPI_L2_TCA = (PAPI_L2_TCA_idx  | PAPI_PRESET_MASK)	;/*L2 total cache accesses */
const  PAPI_L3_TCA = (PAPI_L3_TCA_idx  | PAPI_PRESET_MASK)	;/*L3 total cache accesses */
const  PAPI_L1_TCR = (PAPI_L1_TCR_idx  | PAPI_PRESET_MASK)	;/*L1 total cache reads */
const  PAPI_L2_TCR = (PAPI_L2_TCR_idx  | PAPI_PRESET_MASK)	;/*L2 total cache reads */
const  PAPI_L3_TCR = (PAPI_L3_TCR_idx  | PAPI_PRESET_MASK)	;/*L3 total cache reads */
const  PAPI_L1_TCW = (PAPI_L1_TCW_idx  | PAPI_PRESET_MASK)	;/*L1 total cache writes */
const  PAPI_L2_TCW = (PAPI_L2_TCW_idx  | PAPI_PRESET_MASK)	;/*L2 total cache writes */
const  PAPI_L3_TCW = (PAPI_L3_TCW_idx  | PAPI_PRESET_MASK)	;/*L3 total cache writes */
const  PAPI_FML_INS= (PAPI_FML_INS_idx | PAPI_PRESET_MASK)	;/*FM ins */
const  PAPI_FAD_INS= (PAPI_FAD_INS_idx | PAPI_PRESET_MASK)	;/*FA ins */
const  PAPI_FDV_INS= (PAPI_FDV_INS_idx | PAPI_PRESET_MASK)	;/*FD ins */
const  PAPI_FSQ_INS= (PAPI_FSQ_INS_idx | PAPI_PRESET_MASK)	;/*FSq ins */
const  PAPI_FNV_INS= (PAPI_FNV_INS_idx | PAPI_PRESET_MASK)	;/*Finv ins */
const  PAPI_FP_OPS = (PAPI_FP_OPS_idx  | PAPI_PRESET_MASK)	;/*Floating point operations executed */
const  PAPI_SP_OPS = (PAPI_SP_OPS_idx  | PAPI_PRESET_MASK)	;/* Floating point operations executed; optimized to count scaled single precision vector operations */
const  PAPI_DP_OPS = (PAPI_DP_OPS_idx  | PAPI_PRESET_MASK)	;/* Floating point operations executed; optimized to count scaled double precision vector operations */
const  PAPI_VEC_SP = (PAPI_VEC_SP_idx  | PAPI_PRESET_MASK)	;/* Single precision vector/SIMD instructions */
const  PAPI_VEC_DP = (PAPI_VEC_DP_idx  | PAPI_PRESET_MASK)	;/* Double precision vector/SIMD instructions */
const  PAPI_REF_CYC= (PAPI_REF_CYC_idx  | PAPI_PRESET_MASK);	/* Reference cconst */
const  PAPI_END    = (PAPI_END_idx  | PAPI_PRESET_MASK);	/*T;his should always be last! */

//C     #endif


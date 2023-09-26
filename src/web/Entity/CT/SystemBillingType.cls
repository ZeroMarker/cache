/// 名称:系统计费类型
/// 编写者:基础平台组-陈莹
Class web.Entity.CT.SystemBillingType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SystemBillingType";

Property SMCFErrorFileCounter As %String;

/// Length of ADJ No
Property INCCNADJLength As %Float;

/// ADJ Counter
Property INCCNADJNo As %Float;

/// ADJ Prefix
Property INCCNADJPrefix As %String;

/// ADJ Suffix
Property INCCNADJSuffix As %String;

/// Length of CONS No
Property INCCNCONSLength As %Float;

/// CONS Counter
Property INCCNCONSNo As %Float;

/// CONS Prefix
Property INCCNCONSPrefix As %String;

/// CONS Suffix
Property INCCNCONSSuffix As %String;

/// Length of CSR No
Property INCCNCSRLength As %Float;

/// CSR Counter
Property INCCNCSRNo As %Float;

/// CSR Prefix
Property INCCNCSRPrefix As %String;

/// CSR Suffix
Property INCCNCSRSuffix As %String;

/// Length of DISP No
Property INCCNDISPLength As %Float;

/// DISP Counter
Property INCCNDISPNo As %Float;

/// DISP Prefix
Property INCCNDISPPrefix As %String;

/// DISP Suffix
Property INCCNDISPSuffix As %String;

/// Length of GRN No
Property INCCNGRNLength As %Float;

/// GRN Counter
Property INCCNGRNNo As %Float;

/// GRN Prefix
Property INCCNGRNPrefix As %String;

/// GRN Suffix
Property INCCNGRNSuffix As %String;

/// IsRet Length
Property INCCNIsRetLength As %Float;

/// IsRet_No
Property INCCNIsRetNo As %Float;

/// IsRetPrefix
Property INCCNIsRetPrefix As %String;

/// IsRetSuffix
Property INCCNIsRetSuffix As %String;

/// Length of MO
Property INCCNMOLength As %Float;

/// MO Counter
Property INCCNMONo As %Float;

/// MO Prefix
Property INCCNMOPrefix As %String;

/// MO Suffix
Property INCCNMOSuffix As %String;

/// Length of MRQ
Property INCCNMRQLength As %Float;

/// MRQ Counter
Property INCCNMRQNo As %Float;

/// MRQ Prefix
Property INCCNMRQPrefix As %String;

/// MRQ Suffix
Property INCCNMRQSuffix As %String;

/// Length of PO
Property INCCNPOLength As %Float;

/// PO Counter
Property INCCNPONo As %Float;

/// PO Prefix
Property INCCNPOPrefix As %String;

/// PO Suffix
Property INCCNPOSuffix As %String;

/// Length of REQ No
Property INCCNREQLength As %Float;

/// REQ Counter
Property INCCNREQNo As %Float;

/// REQ Prefix
Property INCCNREQPrefix As %String;

/// REQ Suffix
Property INCCNREQSuffix As %String;

/// Length of RR No
Property INCCNRRLength As %Float;

/// Receive/Return Counter
Property INCCNRRNo As %Float;

/// Receive/Return Prefix
Property INCCNRRPrefix As %String;

/// Receive/Return Suffix
Property INCCNRRSuffix As %String;

/// Length of ST No
Property INCCNSTLength As %Float;

/// Stock Take Counter
Property INCCNSTNo As %Float;

/// Stock Take Prefix
Property INCCNSTPrefix As %String;

/// Stock Take Suffix
Property INCCNSTSuffix As %String;

/// Length of TRF No
Property INCCNTRFLength As %Float;

/// Issue/Transfer Counter
Property INCCNTRFNo As %Float;

/// Issue/Transfer Prefix
Property INCCNTRFPrefix As %String;

/// Issue/Transfer Suffix
Property INCCNTRFSuffix As %String;

/// /////
Property PATCFIPNoLength As %Float;

Property PATCFIPNoValue As %Float;

Property PATCFIPNoPrefix As %String;

Property PATCFIPNoSuffix As %String;

/// /////
Property PATCFOPAdmNoLength As %Float;

Property PATCFOPAdmNoValue As %Float;

Property PATCFOPAdmNoPrefix As %String;

Property PATCFOPAdmNoSuffix As %String;

/// /////
Property PATCFIPAdmNoLength As %Float;

Property PATCFIPAdmNoValue As %Float;

Property PATCFIPAdmNoPrefix As %String;

Property PATCFIPAdmNoSuffix As %String;

/// /////
Property PATCFEMAdmNoLength As %Float;

Property PATCFEMAdmNoValue As %Float;

Property PATCFEMAdmNoPrefix As %String;

Property PATCFEMAdmNoSuffix As %String;

/// /////
Property PATCFProcessLength As %Float;

Property PATCFProcessValue As %Float;

Property PATCFProcessPrefix As %String;

Property PATCFProcessSuffix As %String;

/// /////
Property PATCFHPLength As %Float;

Property PATCFHPValue As %Float;

Property PATCFHPPrefix As %String;

Property PATCFHPSuffix As %String;

/// /////
Property PATCFAnaestLength As %Float;

Property PATCFAnaestValue As %Float;

Property PATCFAnaestPrefix As %String;

Property PATCFAnaestSuffix As %String;

/// /////
Property PATCFOperLength As %Float;

Property PATCFOperValue As %Float;

Property PATCFOperPrefix As %String;

Property PATCFOperSuffix As %String;

}

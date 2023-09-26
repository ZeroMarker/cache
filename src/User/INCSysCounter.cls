/// Inventory System Counter(INCCN,583)
Class User.INCSysCounter Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_SysCounter, StorageStrategy = SQLStorage ]
{

/// Length of ADJ No
Property INCCNADJLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 33, SqlFieldName = INCCN_ADJ_Length ];

/// ADJ Counter
Property INCCNADJNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 17, SqlFieldName = INCCN_ADJ_No ];

/// ADJ Prefix
Property INCCNADJPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = INCCN_ADJ_Prefix ];

/// ADJ Suffix
Property INCCNADJSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = INCCN_ADJ_Suffix ];

/// Length of CONS No
Property INCCNCONSLength As %Float [ InitialExpression = 8, SqlColumnNumber = 58, SqlFieldName = INCCN_CONS_Length ];

/// CONS Counter
Property INCCNCONSNo As %Float [ InitialExpression = 1, SqlColumnNumber = 59, SqlFieldName = INCCN_CONS_No ];

/// CONS Prefix
Property INCCNCONSPrefix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 60, SqlFieldName = INCCN_CONS_Prefix ];

/// CONS Suffix
Property INCCNCONSSuffix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 61, SqlFieldName = INCCN_CONS_Suffix ];

/// Length of CSR No
Property INCCNCSRLength As %Float [ InitialExpression = 8, SqlColumnNumber = 54, SqlFieldName = INCCN_CSR_Length ];

/// CSR Counter
Property INCCNCSRNo As %Float [ InitialExpression = 1, SqlColumnNumber = 55, SqlFieldName = INCCN_CSR_No ];

/// CSR Prefix
Property INCCNCSRPrefix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = INCCN_CSR_Prefix ];

/// CSR Suffix
Property INCCNCSRSuffix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 57, SqlFieldName = INCCN_CSR_Suffix ];

/// Length of DISP No
Property INCCNDISPLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 34, SqlFieldName = INCCN_DISP_Length ];

/// DISP Counter
Property INCCNDISPNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 14, SqlFieldName = INCCN_DISP_No ];

/// DISP Prefix
Property INCCNDISPPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = INCCN_DISP_Prefix ];

/// DISP Suffix
Property INCCNDISPSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = INCCN_DISP_Suffix ];

/// Length of GRN No
Property INCCNGRNLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 32, SqlFieldName = INCCN_GRN_Length ];

/// GRN Counter
Property INCCNGRNNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 3, SqlFieldName = INCCN_GRN_No ];

/// GRN Prefix
Property INCCNGRNPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INCCN_GRN_Prefix ];

/// GRN Suffix
Property INCCNGRNSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = INCCN_GRN_Suffix ];

/// IsRet Length
Property INCCNIsRetLength As %Float [ SqlColumnNumber = 62, SqlFieldName = INCCN_IsRet_Length ];

/// IsRet_No
Property INCCNIsRetNo As %Float [ SqlColumnNumber = 63, SqlFieldName = INCCN_IsRet_No ];

/// IsRetPrefix
Property INCCNIsRetPrefix As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 64, SqlFieldName = INCCN_IsRet_Prefix ];

/// IsRetSuffix
Property INCCNIsRetSuffix As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 65, SqlFieldName = INCCN_IsRet_Suffix ];

/// Length of LnIn No
Property INCCNLnInLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 35, SqlFieldName = INCCN_LnIn_Length ];

/// Loan In Counter
Property INCCNLnInNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 26, SqlFieldName = INCCN_LnIn_No ];

/// Loan In Prefix
Property INCCNLnInPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = INCCN_LnIn_Prefix ];

/// Loan In Suffix
Property INCCNLnInSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = INCCN_LnIn_Suffix ];

/// Length of LnOut No
Property INCCNLnOutLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 36, SqlFieldName = INCCN_LnOut_Length ];

/// Loan Out Counter
Property INCCNLnOutNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 29, SqlFieldName = INCCN_LnOut_No ];

/// Loan Out Prefix
Property INCCNLnOutPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = INCCN_LnOut_Prefix ];

/// Loan Out Suffix
Property INCCNLnOutSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = INCCN_LnOut_Suffix ];

/// Length of MO
Property INCCNMOLength As %Float [ InitialExpression = 8, SqlColumnNumber = 42, SqlFieldName = INCCN_MO_Length ];

/// MO Counter
Property INCCNMONo As %Float [ InitialExpression = 1, SqlColumnNumber = 45, SqlFieldName = INCCN_MO_No ];

/// MO Prefix
Property INCCNMOPrefix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = INCCN_MO_Prefix ];

/// MO Suffix
Property INCCNMOSuffix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = INCCN_MO_Suffix ];

/// Length of MRQ
Property INCCNMRQLength As %Float [ InitialExpression = 8, SqlColumnNumber = 44, SqlFieldName = INCCN_MRQ_Length ];

/// MRQ Counter
Property INCCNMRQNo As %Float [ InitialExpression = 1, SqlColumnNumber = 47, SqlFieldName = INCCN_MRQ_No ];

/// MRQ Prefix
Property INCCNMRQPrefix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = INCCN_MRQ_Prefix ];

/// MRQ Suffix
Property INCCNMRQSuffix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = INCCN_MRQ_Suffix ];

/// Length of PO
Property INCCNPOLength As %Float [ InitialExpression = 8, SqlColumnNumber = 43, SqlFieldName = INCCN_PO_Length ];

/// PO Counter
Property INCCNPONo As %Float [ InitialExpression = 1, SqlColumnNumber = 46, SqlFieldName = INCCN_PO_No ];

/// PO Prefix
Property INCCNPOPrefix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = INCCN_PO_Prefix ];

/// PO Suffix
Property INCCNPOSuffix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = INCCN_PO_Suffix ];

/// Length of REQ No
Property INCCNREQLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 37, SqlFieldName = INCCN_REQ_Length ];

/// REQ Counter
Property INCCNREQNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 11, SqlFieldName = INCCN_REQ_No ];

/// REQ Prefix
Property INCCNREQPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = INCCN_REQ_Prefix ];

/// REQ Suffix
Property INCCNREQSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = INCCN_REQ_Suffix ];

/// Length of RR No
Property INCCNRRLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 38, SqlFieldName = INCCN_RR_Length ];

/// Receive/Return Counter
Property INCCNRRNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 23, SqlFieldName = INCCN_RR_No ];

/// Receive/Return Prefix
Property INCCNRRPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = INCCN_RR_Prefix ];

/// Receive/Return Suffix
Property INCCNRRSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = INCCN_RR_Suffix ];

/// INCCN Row ID
Property INCCNRowId As %Float [ InitialExpression = 1, Required, SqlFieldName = INCCN_RowId ];

/// Length of ST No
Property INCCNSTLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 39, SqlFieldName = INCCN_ST_Length ];

/// Stock Take Counter
Property INCCNSTNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 20, SqlFieldName = INCCN_ST_No ];

/// Stock Take Prefix
Property INCCNSTPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = INCCN_ST_Prefix ];

/// Stock Take Suffix
Property INCCNSTSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = INCCN_ST_Suffix ];

/// Length of TRF No
Property INCCNTRFLength As %Float(MAXVAL = 12, MINVAL = 1) [ InitialExpression = 8, SqlColumnNumber = 40, SqlFieldName = INCCN_TRF_Length ];

/// Issue/Transfer Counter
Property INCCNTRFNo As %Float(MINVAL = 0) [ InitialExpression = 1, SqlColumnNumber = 5, SqlFieldName = INCCN_TRF_No ];

/// Issue/Transfer Prefix
Property INCCNTRFPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INCCN_TRF_Prefix ];

/// Issue/Transfer Suffix
Property INCCNTRFSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = INCCN_TRF_Suffix ];

Index RowIDBasedIDKeyIndex On INCCNRowId [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCSysCounter).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCSysCounter","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCSysCounter).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCSysCounter","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCSysCounter).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCSysCounter","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCSysCounter).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCSysCounter","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCSysCounter).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCSysCounter","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="INCCNADJLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNADJNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNADJPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNADJSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCONSLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCONSNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCONSPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCONSSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCSRLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCSRNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCSRPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNCSRSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNDISPLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNDISPNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNDISPPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNDISPSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNGRNLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNGRNNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNGRNPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNGRNSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNIsRetLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNIsRetNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNIsRetPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNIsRetSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnInLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnInNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnInPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnInSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnOutLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnOutNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnOutPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNLnOutSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMOLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMONo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMOPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMOSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMRQLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMRQNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMRQPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNMRQSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNPOLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNPONo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNPOPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNPOSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNREQLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNREQNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNREQPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNREQSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNRRLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNRRNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNRRPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNRRSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNRowId">
<Selectivity>1</Selectivity>
</Property>
<Property name="INCCNSTLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNSTNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNSTPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNSTSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNTRFLength">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNTRFNo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNTRFPrefix">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCCNTRFSuffix">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>1</SqlIdExpression>
<SQLMap name="DataMasterINCCN">
<Data name="INCCN_ADJ_Length">
<Node>"ADJ_Len"</Node>
</Data>
<Data name="INCCN_ADJ_No">
<Node>"ADJ_No"</Node>
</Data>
<Data name="INCCN_ADJ_Prefix">
<Node>"ADJ_Pre"</Node>
</Data>
<Data name="INCCN_ADJ_Suffix">
<Node>"ADJ_Suf"</Node>
</Data>
<Data name="INCCN_CONS_Length">
<Node>"CONS_Len"</Node>
</Data>
<Data name="INCCN_CONS_No">
<Node>"CONS_No"</Node>
</Data>
<Data name="INCCN_CONS_Prefix">
<Node>"CONS_Pre"</Node>
</Data>
<Data name="INCCN_CONS_Suffix">
<Node>"CONS_Suf"</Node>
</Data>
<Data name="INCCN_CSR_Length">
<Node>"CSR_Len"</Node>
</Data>
<Data name="INCCN_CSR_No">
<Node>"CSR_No"</Node>
</Data>
<Data name="INCCN_CSR_Prefix">
<Node>"CSR_Pre"</Node>
</Data>
<Data name="INCCN_CSR_Suffix">
<Node>"CSR_Suf"</Node>
</Data>
<Data name="INCCN_DISP_Length">
<Node>"DISP_Len"</Node>
</Data>
<Data name="INCCN_DISP_No">
<Node>"DISP_No"</Node>
</Data>
<Data name="INCCN_DISP_Prefix">
<Node>"DISP_Pre"</Node>
</Data>
<Data name="INCCN_DISP_Suffix">
<Node>"DISP_Suf"</Node>
</Data>
<Data name="INCCN_GRN_Length">
<Node>"GRN_Len"</Node>
</Data>
<Data name="INCCN_GRN_No">
<Node>"GRN_No"</Node>
</Data>
<Data name="INCCN_GRN_Prefix">
<Node>"GRN_Pre"</Node>
</Data>
<Data name="INCCN_GRN_Suffix">
<Node>"GRN_Suf"</Node>
</Data>
<Data name="INCCN_IsRet_Length">
<Node>"ISR_Len"</Node>
</Data>
<Data name="INCCN_IsRet_No">
<Node>"ISR_No"</Node>
</Data>
<Data name="INCCN_IsRet_Prefix">
<Node>"ISR_Pre"</Node>
</Data>
<Data name="INCCN_IsRet_Suffix">
<Node>"ISR_Suf"</Node>
</Data>
<Data name="INCCN_LnIn_Length">
<Node>"LnIn_Len"</Node>
</Data>
<Data name="INCCN_LnIn_No">
<Node>"LnIn_No"</Node>
</Data>
<Data name="INCCN_LnIn_Prefix">
<Node>"LnIn_Pre"</Node>
</Data>
<Data name="INCCN_LnIn_Suffix">
<Node>"LnIn_Suf"</Node>
</Data>
<Data name="INCCN_LnOut_Length">
<Node>"LnOut_Len"</Node>
</Data>
<Data name="INCCN_LnOut_No">
<Node>"LnOut_No"</Node>
</Data>
<Data name="INCCN_LnOut_Prefix">
<Node>"LnOut_Pre"</Node>
</Data>
<Data name="INCCN_LnOut_Suffix">
<Node>"LnOut_Suf"</Node>
</Data>
<Data name="INCCN_MO_Length">
<Node>"MO_Len"</Node>
</Data>
<Data name="INCCN_MO_No">
<Node>"MO_No"</Node>
</Data>
<Data name="INCCN_MO_Prefix">
<Node>"MO_Pre"</Node>
</Data>
<Data name="INCCN_MO_Suffix">
<Node>"MO_Suf"</Node>
</Data>
<Data name="INCCN_MRQ_Length">
<Node>"MRQ_Len"</Node>
</Data>
<Data name="INCCN_MRQ_No">
<Node>"MRQ_No"</Node>
</Data>
<Data name="INCCN_MRQ_Prefix">
<Node>"MRQ_Pre"</Node>
</Data>
<Data name="INCCN_MRQ_Suffix">
<Node>"MRQ_Suf"</Node>
</Data>
<Data name="INCCN_PO_Length">
<Node>"PO_Len"</Node>
</Data>
<Data name="INCCN_PO_No">
<Node>"PO_No"</Node>
</Data>
<Data name="INCCN_PO_Prefix">
<Node>"PO_Pre"</Node>
</Data>
<Data name="INCCN_PO_Suffix">
<Node>"PO_Suf"</Node>
</Data>
<Data name="INCCN_REQ_Length">
<Node>"REQ_Len"</Node>
</Data>
<Data name="INCCN_REQ_No">
<Node>"REQ_No"</Node>
</Data>
<Data name="INCCN_REQ_Prefix">
<Node>"REQ_Pre"</Node>
</Data>
<Data name="INCCN_REQ_Suffix">
<Node>"REQ_Suf"</Node>
</Data>
<Data name="INCCN_RR_Length">
<Node>"RR_Len"</Node>
</Data>
<Data name="INCCN_RR_No">
<Node>"RR_No"</Node>
</Data>
<Data name="INCCN_RR_Prefix">
<Node>"RR_Pre"</Node>
</Data>
<Data name="INCCN_RR_Suffix">
<Node>"RR_Suf"</Node>
</Data>
<Data name="INCCN_ST_Length">
<Node>"ST_Len"</Node>
</Data>
<Data name="INCCN_ST_No">
<Node>"ST_No"</Node>
</Data>
<Data name="INCCN_ST_Prefix">
<Node>"ST_Pre"</Node>
</Data>
<Data name="INCCN_ST_Suffix">
<Node>"ST_Suf"</Node>
</Data>
<Data name="INCCN_TRF_Length">
<Node>"TRF_Len"</Node>
</Data>
<Data name="INCCN_TRF_No">
<Node>"TRF_No"</Node>
</Data>
<Data name="INCCN_TRF_Prefix">
<Node>"TRF_Pre"</Node>
</Data>
<Data name="INCCN_TRF_Suffix">
<Node>"TRF_Suf"</Node>
</Data>
<Global>^COUNT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INCCN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"STOCK"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INCCN_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INCCN_RowId</SqlRowIdName>
<StreamLocation>^User.INCSysCounterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

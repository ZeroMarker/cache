/// Old Table - To be Deleted
Class User.ARCDebtor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_Debtor, StorageStrategy = SQLStorage ]
{

/// Addressee
Property ARCDRAddressee As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = ARCDR_Addressee ];

/// Total Receipts Per Batch (For Credit Card Co)
Property ARCDRBatchTotal As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 47, SqlFieldName = ARCDR_BatchTotal ];

/// Bill Format
Property ARCDRBillFmt As %String(DISPLAYLIST = ",Summarized,Itemized", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",S,I") [ SqlColumnNumber = 20, SqlFieldName = ARCDR_BillFmt ];

/// BlackList Flag
Property ARCDRBlackLstFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 40, SqlFieldName = ARCDR_BlackLstFlag ];

/// Credit Available 
Property ARCDRCRAvail As %Float [ SqlColumnNumber = 24, SqlFieldName = ARCDR_CRAvail ];

/// Credit Limit
Property ARCDRCRLimit As %Float [ SqlColumnNumber = 23, SqlFieldName = ARCDR_CRLimit ];

/// Credit Term
Property ARCDRCRTerm As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 22, SqlFieldName = ARCDR_CRTerm ];

/// not in use
Property ARCDRCatDR As ARCDebCat [ SqlColumnNumber = 44, SqlFieldName = ARCDR_Cat_DR ];

/// Charge Exclusion Flag
Property ARCDRChrgExclFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlComputeCode = { s {ARCDR_ChrgExclFlag}=$$CO38^at181({ARCDR_RowId})
}, SqlComputed, SqlFieldName = ARCDR_ChrgExclFlag, Transient ];

/// Debtor Code
Property ARCDRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ARCDR_Code ];

/// Commission Imposed By Hospital To Patient
Property ARCDRCommCharge As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 55, SqlFieldName = ARCDR_CommCharge ];

/// Commission Imposed by Card Co. To Hospital
Property ARCDRCommPercent As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 45, SqlFieldName = ARCDR_CommPercent ];

/// Commission Percent Calculation Type
Property ARCDRCommType As %String(DISPLAYLIST = ",1 Receipt Per Batch,Many Receipts Per Batch", MAXLEN = 23, TRUNCATE = 1, VALUELIST = ",S,B") [ SqlColumnNumber = 46, SqlFieldName = ARCDR_CommType ];

/// not in use
Property ARCDRCrRateDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = ARCDR_CrRate_DR ];

/// Not Used Des Ref to ARCDA
Property ARCDRCtrlAcctDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = ARCDR_CtrlAcct_DR ];

/// Debtor Origin Info
Property ARCDRDebtorOriginInfo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 61, SqlComputeCode = { s {ARCDR_Debtor_Origin_Info}=$$CO61^at181({ARCDR_RowId})
}, SqlComputed, SqlFieldName = ARCDR_Debtor_Origin_Info, Transient ];

/// Designation
Property ARCDRDesignation As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ARCDR_Designation ];

/// End Date
Property ARCDREndDate As %Date [ SqlColumnNumber = 19, SqlFieldName = ARCDR_EndDate ];

/// Debtor created outside registration
Property ARCDRIndepFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = ARCDR_IndepFlag ];

/// Not Used Des Ref to CTIND
Property ARCDRIndustryDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = ARCDR_Industry_DR ];

/// Des Ref to ARCCT(not in use)
Property ARCDRIpChgTypeDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ARCDR_IpChgType_DR ];

/// Days or Amt for Inpatient Limit Setup
Property ARCDRLimitIP As %String(DISPLAYLIST = ",Days,Amount", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,A") [ SqlColumnNumber = 63, SqlFieldName = ARCDR_LimitIP ];

/// Check Limit Start Date
Property ARCDRLimitSDate As %Date [ SqlColumnNumber = 64, SqlFieldName = ARCDR_LimitSDate ];

/// Type of Limit Setup
Property ARCDRLimitType As %String(DISPLAYLIST = ",Visit-Service Category,Visit-Patient,Year-Service Category,Year-Patient", MAXLEN = 22, TRUNCATE = 1, VALUELIST = ",VS,VP,YS,YP") [ InitialExpression = "N", SqlColumnNumber = 58, SqlFieldName = ARCDR_LimitType ];

/// Debtor Name
Property ARCDRName As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlComputeCode = { s {ARCDR_Name}=$p({ARCDR_Debtor_Origin_Info},"^",6)
}, SqlComputed, SqlFieldName = ARCDR_Name, Transient ];

/// No Of Staff
Property ARCDRNoOfStaff As %Float(MAXVAL = 9999, MINVAL = 0) [ SqlColumnNumber = 52, SqlFieldName = ARCDR_NoOfStaff ];

/// OutPatient Billing Policy
Property ARCDROpBillPolicy As %String(DISPLAYLIST = ",By Visit,Consolidated", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",O,M") [ InitialExpression = "By Visit", SqlColumnNumber = 59, SqlFieldName = ARCDR_OpBillPolicy ];

/// Des Ref to ARCCT
Property ARCDROpChgTypeDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ARCDR_OpChgType_DR ];

/// Origin ID
Property ARCDROriginID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 62, SqlComputeCode = { s {ARCDR_Origin_ID}=$p({ARCDR_Debtor_Origin_Info},"^",62)
}, SqlComputed, SqlFieldName = ARCDR_Origin_ID, Transient ];

/// Des Ref to CTRG
Property ARCDRRegionDR As CTRegion [ SqlColumnNumber = 54, SqlFieldName = ARCDR_Region_DR ];

/// Service Exclusion Flag
Property ARCDRServExcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlComputeCode = { s {ARCDR_ServExcFlag}=$$CO37^at181({ARCDR_RowId})
}, SqlComputed, SqlFieldName = ARCDR_ServExcFlag, Transient ];

/// Debtor Short Name
Property ARCDRShName As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 57, SqlComputeCode = { s {ARCDR_ShName}=$e({ARCDR_Name},1,20)
}, SqlComputed, SqlFieldName = ARCDR_ShName, Transient ];

/// Start Date
Property ARCDRStartDate As %Date [ SqlColumnNumber = 18, SqlFieldName = ARCDR_StartDate ];

/// Statement Type
Property ARCDRStatementType As %String(DISPLAYLIST = ",Open Balance,Forward Balance", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",O,B") [ SqlColumnNumber = 21, SqlFieldName = ARCDR_StatementType ];

Index ARCDRCodeUnqIdx1 On ARCDRCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCDebtor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDebtor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCDebtor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDebtor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCDebtor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDebtor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCDebtor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDebtor","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCDebtor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDebtor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARCDR(0))</SqlIdExpression>
<SQLMap name="DataMasterARCDR">
<Data name="ARCDR_Addressee">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="ARCDR_BatchTotal">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCDR_BillFmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCDR_BlackLstFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCDR_CRAvail">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARCDR_CRLimit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARCDR_CRTerm">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARCDR_Cat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCDR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCDR_CommCharge">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCDR_CommPercent">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCDR_CommType">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCDR_CrRate_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARCDR_CtrlAcct_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARCDR_Designation">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCDR_EndDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCDR_IndepFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="ARCDR_Industry_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="ARCDR_IpChgType_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARCDR_LimitIP">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="ARCDR_LimitSDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="ARCDR_LimitType">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="ARCDR_NoOfStaff">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="ARCDR_OpBillPolicy">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="ARCDR_OpChgType_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARCDR_Region_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="ARCDR_StartDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCDR_StatementType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARCDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARCDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARCDR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCDRCode">
<Global>^ARCDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCDR_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCDR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCDebtorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

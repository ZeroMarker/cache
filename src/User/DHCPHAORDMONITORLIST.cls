Class User.DHCPHAORDMONITORLIST Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCTL_ROWID, SqlTableName = DHC_PHAORDMONITORLIST, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PCTLChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAORDMONITOR Parent Reference
Relationship PCTLPHAOMParRef As User.DHCPHAORDMONITOR [ Cardinality = parent, Inverse = ChildDHCPHAORDMONITORLIST, Required, SqlFieldName = PCTL_PHAOM_ParRef ];

/// PCTL_ChildSub
Property PCTLChildSub As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PCTL_ChildSub ];

Property PCTLOrdItemDr As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = PCTL_OrdItem_Dr ];

Property PCTLGrpNo As %String [ SqlColumnNumber = 3, SqlFieldName = PCTL_GrpNo ];

Property PCTLAuditReasonDr As User.DHCPHCNTSREASON [ SqlColumnNumber = 4, SqlFieldName = PCTL_AuditReason_Dr ];

/// PCTL_PrescNo
Property PCTLPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PCTL_PrescNo ];

/// PCTL_Adm_Dr
Property PCTLAdmDr As User.PAAdm [ SqlColumnNumber = 7, SqlFieldName = PCTL_Adm_Dr ];

/// 用药日期
Property PCTLDoseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PCTL_DoseDate ];

/// 拒绝原因
Property PCTLAuditReasonDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PCTL_AuditReasonDesc ];

/// PCTLAutoAuditLevel
Property PCTLAutoAuditLevel As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PCTL_AutoAuditLevel ];

/// PCTL_MandAuditFlag
Property PCTLMandAuditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PCTL_MandAuditFlag ];

/// PCTL_AutoAuditMsg
Property PCTLAutoAuditMsg As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PCTL_AutoAuditMsg ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexAdm">
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHAORDMONITOR.PHAOM_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PCTL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTL_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHAORDMONITOR.PHAOM_ROWID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCTL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateOrdItem">
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PHAORDMONITOR.PHAOM_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PCTL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateOrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTL_OrdItem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCTL_DoseDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PHAORDMONITOR.PHAOM_ROWID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PCTL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHAORDMONITOR.PHAOM_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PCTL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTL_OrdItem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHAORDMONITOR.PHAOM_ROWID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCTL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHAORDMONITOR.PHAOM_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PCTL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTL_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHAORDMONITOR.PHAOM_ROWID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCTL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PCTL_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCTL_AuditReasonDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCTL_AuditReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCTL_AutoAuditLevel">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCTL_AutoAuditMsg">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCTL_DoseDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCTL_GrpNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCTL_MandAuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCTL_OrdItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCTL_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAORDMONITOR.PHAOM_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PCTL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAORDMONITOR.PHAOM_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAORDMONITORLIST</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

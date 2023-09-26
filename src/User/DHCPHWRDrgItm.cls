Class User.DHCPHWRDrgItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDI_RowID, SqlTableName = DHC_PHWRDrgItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHDIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHDI_PHWR_Parref
Relationship PHDIPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRDRGITM, Required, SqlFieldName = PHDI_PHWR_Parref ];

/// PHDI_ChildSub
Property PHDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHDI_ChildSub ];

/// PHDI_OEORI_DR  医嘱ID
Property PHDIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PHDI_OEORI_DR ];

/// PHDI_INCI_Dr  药品
Property PHDIINCIDr As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = PHDI_INCI_Dr ];

/// PHDI_Dosage  剂量
Property PHDIDosage As %Library.Numeric [ SqlColumnNumber = 5, SqlFieldName = PHDI_Dosage ];

/// PHDI_PHCIN_Dr  用法
Property PHDIPHCINDr As User.PHCInstruc [ SqlColumnNumber = 6, SqlFieldName = PHDI_PHCIN_Dr ];

/// PHDI_PHCFR_Dr  频次
Property PHDIPHCFRDr As User.PHCFreq [ SqlColumnNumber = 7, SqlFieldName = PHDI_PHCFR_Dr ];

/// PHDI_PHCDU_Dr  疗程
Property PHDIPHCDUDr As User.PHCDuration [ SqlColumnNumber = 8, SqlFieldName = PHDI_PHCDU_Dr ];

/// PHDI_NeedUseFlag  需要使用标志 患者入院时是否需要使用本药品治疗?	港大 权力	2022-04-21
Property PHDINeedUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PHDI_NeedUseFlag ];

/// PHDI_SelfProvidFlag  自备药标志	服用药物是否为患者自备药?	港大 权力	2022-04-21
Property PHDISelfProvidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PHDI_SelfProvidFlag ];

/// PHDI_IntegFlag  整合标志	是否已完成药物整合?	港大 权力	2022-04-21
Property PHDIIntegFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PHDI_IntegFlag ];

/// PHDI_ComplianceFlag  依从性标志	服用药物依从性	港大 权力	2022-04-21
Property PHDIComplianceFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PHDI_ComplianceFlag ];

/// PHDI_ChangeDesc  更改说明	现患者医嘱用药是否跟入院前用药方案不同？例如更改剂量等	港大 权力	2022-04-21
Property PHDIChangeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHDI_ChangeDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^mdata("DHCPHWRDRGITM"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHDI_ChangeDesc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHDI_ComplianceFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHDI_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDI_INCI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDI_IntegFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHDI_NeedUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDI_PHCDU_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDI_PHCFR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDI_PHCIN_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDI_SelfProvidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHWardRound.PHWR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRDrgItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

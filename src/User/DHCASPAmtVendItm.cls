/// IN Issue/Transfer Item(DHCINIT,373)
Class User.DHCASPAmtVendItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASPAVI_RowId, SqlTableName = DHC_ASPAmtVendItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Index RowIDBasedIDKeyIndex On ASPAVIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_InIsTrf Parent Reference
Relationship ASPAVIASPAVParRef As User.DHCASPAmtVend [ Cardinality = parent, Inverse = ChildDHCASPAmtVendItm, Required, SqlFieldName = ASPAVI_ASPAV_ParRef ];

Relationship ChildDHCASPAVILoc As User.DHCASPAmtVendItmLoc [ Cardinality = children, Inverse = ASPAVILOCPARREF ];

/// ASPAVI_ChildSub
Property ASPAVIChildSub As %Library.Float [ InitialExpression = {$i(^DHCASPAV($p(%d(0),$c(1),1),"ASI",0))}, SqlColumnNumber = 2, SqlFieldName = ASPAVI_ChildSub ];

/// 库存项
Property ASPAVIINCIDR As User.INCItm [ Required, SqlColumnNumber = 3, SqlFieldName = ASPAVI_INCI_DR ];

/// ASPAVI_Qty
Property ASPAVIQty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ Required, SqlColumnNumber = 4, SqlFieldName = ASPAVI_Qty ];

/// 单位 ASPAVI_CTUOM_DR : User.CTUOM
Property ASPAVICTUOMDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = ASPAVI_CTUOM_DR ];

/// 差价金额ASPAVI_DifAmt
Property ASPAVIDifAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ASPAVI_DifAmt ];

/// 正票发票号 ASPAVI_PoInvNo
Property ASPAVIPoInvNo As %Library.String [ SqlColumnNumber = 7, SqlFieldName = ASPAVI_PoInvNo ];

/// 负票发票号 ASPAVI_NeInvNo
Property ASPAVINeInvNo As %Library.String [ SqlColumnNumber = 8, SqlFieldName = ASPAVI_NeInvNo ];

/// 备注 ASPAVI_Remark
Property ASPAVIRemark As %Library.String [ SqlColumnNumber = 9, SqlFieldName = ASPAVI_Remark ];

/// 正票金额ASPAVI_PoAmt
Property ASPAVIPoAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ASPAVI_PoAmt ];

/// 负票金额ASPAVI_NeAmt
Property ASPAVINeAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ASPAVI_NeAmt ];

/// 审核日期
Property ASPAVIAuditDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 12, SqlFieldName = ASPAVI_AuditDate ];

/// 审核时间
Property ASPAVIAuditTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = ASPAVI_AuditTime ];

/// 审核人 SSUSR :User.SSUser
Property ASPAVIAuditUsrDR As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = ASPAVI_AuditUsr_DR ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ASPAVI_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ASPAVI_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ASPAVI_AuditUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ASPAVI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASPAVI_DifAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASPAVI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASPAVI_NeAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASPAVI_NeInvNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASPAVI_PoAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ASPAVI_PoInvNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASPAVI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASPAVI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCASPAV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ASPAmtVend.ASPAV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ASPAVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ASPAmtVend.ASPAV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ASI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ASPAVI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INCIndex">
<Global>^DHCASPAV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ASPAmtVend.ASPAV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ASPAVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPAVI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_ASPAmtVend.ASPAV_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASPAVI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ItmAuditIndex">
<Global>^DHCASPAV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ASPAmtVend.ASPAV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ASPAVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmAuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPAVI_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASPAVI_ASPAV_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASPAVI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCASPAmtVendItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

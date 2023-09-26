Class User.DHCASPAmtVendItmLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASPAVIL_RowId, SqlTableName = DHC_ASPAmtVendItmLoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ASPAVILCHILDSUB [ IdKey, PrimaryKey, Unique ];

/// DHC_ASPAmtVendItm Parent Reference
Relationship ASPAVILOCPARREF As User.DHCASPAmtVendItm [ Cardinality = parent, Inverse = ChildDHCASPAVILoc, Required, SqlFieldName = ASPAVIL_ASPAVI_ParRef ];

/// ASPAVIL_CHILDSUB
Property ASPAVILCHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ASPAVIL_CHILDSUB ];

/// ASPAVIL_LocDr 
Property ASPAVILLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = ASPAVIL_LocDr ];

/// ASPAVIL_Qty
Property ASPAVILQty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = ASPAVIL_Qty ];

/// 单位 ASPAVIL_CTUOM_DR : User.CTUOM
Property ASPAVILCTUOMDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = ASPAVIL_CTUOM_DR ];

/// 差价金额ASPAVIL_DifAmt
Property ASPAVILDifAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ASPAVIL_DifAmt ];

/// 备注 ASPAVIL_Remark
Property ASPAVILRemark As %Library.String [ SqlColumnNumber = 7, SqlFieldName = ASPAVIL_Remark ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="LocIndex">
<Global>^DHCASPAV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ASPAmtVend.ASPAV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_ASPAmtVendItm.ASPAVI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ASPAVIL_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPAVIL_LocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_ASPAmtVend.ASPAV_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_ASPAmtVendItm.ASPAVI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ASPAVIL_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ASPAVIL_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASPAVIL_DifAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASPAVIL_LocDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASPAVIL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASPAVIL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCASPAV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ASPAmtVend.ASPAV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_ASPAmtVendItm.ASPAVI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ASPAVIL_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ASPAmtVend.ASPAV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ASI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_ASPAmtVendItm.ASPAVI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"IL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASPAVIL_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ASPAVIL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCASPAmtVendItmLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

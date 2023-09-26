Class User.DHCInDispRetItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = DSRI_RowId, SqlTableName = DHC_InDispRetItm, StorageStrategy = sqlstorage ]
{

Index RowIDBasedIDKeyIndex On DSRIChildSub [ IdKey, PrimaryKey, Unique ];

/// DSRI_DSR_ParRef
Relationship DSRIDSRParRef As User.DHCInDispRet [ Cardinality = parent, Inverse = ChildDHCInDispRetItm, Required, SqlFieldName = DSRI_DSR_ParRef ];

/// DSRI_ChildSub
Property DSRIChildSub As %Numeric [ InitialExpression = {$i(^DHCINDSR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = DSRI_ChildSub ];

/// DSRI_INCLB_DR
Property DSRIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = DSRI_INCLB_DR ];

/// DSRI_Qty
Property DSRIQty As %Float [ SqlColumnNumber = 4, SqlFieldName = DSRI_Qty ];

/// DSRI_CTUOM_DR
Property DSRICTUOMDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = DSRI_CTUOM_DR ];

/// DSRI_DSI_DR
Property DSRIDSIDR As User.DHCInDispItm [ SqlColumnNumber = 6, SqlFieldName = DSRI_DSI_DR ];

/// DSRI_Rp
Property DSRIRp As %Float [ SqlColumnNumber = 7, SqlFieldName = DSRI_Rp ];

/// DSRI_RpAmt
Property DSRIRpAmt As %Float [ SqlColumnNumber = 8, SqlFieldName = DSRI_RpAmt ];

/// DSRI_Sp
Property DSRISp As %Float [ SqlColumnNumber = 9, SqlFieldName = DSRI_Sp ];

/// DSRI_SpAmt
Property DSRISpAmt As %Float [ SqlColumnNumber = 10, SqlFieldName = DSRI_SpAmt ];

/// DSRI_Remark
Property DSRIRemark As %String [ SqlColumnNumber = 11, SqlFieldName = DSRI_Remark ];

Storage sqlstorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DSRI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSRI_DSI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSRI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSRI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSRI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSRI_Rp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSRI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSRI_Sp">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSRI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCINDSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InDispRet.DSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DSRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_InDispRet.DSR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSRI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIndsi">
<Global>^DHCINDSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InDispRet.DSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DSRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Indsi"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSRI_DSI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSRI_DSR_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInDispRetItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

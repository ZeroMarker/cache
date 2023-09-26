Class User.DHCMatDispItmInclb Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSLB_RowId, SqlTableName = DHC_MatDispItmInclb, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On DSLBChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DSLBParRef As User.DHCMatDispItm [ Cardinality = parent, Inverse = ChildDHCMatDispItmInclb, Required, SqlFieldName = DSLB_ParRef ];

Property DSLBChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DSLB_ChildSub ];

Property DSLBINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = DSLB_INCLB_DR ];

Property DSLBQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DSLB_Qty ];

Property DSLBSp As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DSLB_Sp ];

Property DSLBSpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DSLB_SpAmt ];

Property DSLBRetQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DSLB_RetQty ];

Storage SqlStorage
{
<SQLMap name="Datamaster">
<Data name="DSLB_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSLB_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSLB_RetQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSLB_Sp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSLB_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMATDISP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MatDisp.DISP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_MatDispItm.DSI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_MatDispItmInclb.DSLB_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_MatDisp.DISP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_MatDispItm.DSI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"B"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DSLB_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DSLB_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatDispItmInclbS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

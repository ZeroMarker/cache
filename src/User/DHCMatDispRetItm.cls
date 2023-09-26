Class User.DHCMatDispRetItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = RETI_RowId, SqlTableName = DHC_MatDispRetItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RETIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship RETIParRef As User.DHCMatDispRet [ Cardinality = parent, Inverse = ChildDHCMatDispRetItm, Required, SqlFieldName = RETI_ParRef ];

Property RETIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = RETI_ChildSub ];

Property RETIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = RETI_OEORI_DR ];

Property RETIDSIDR As User.DHCMatDispItm [ SqlColumnNumber = 4, SqlFieldName = RETI_DSI_DR ];

Property RETIINCIDR As User.INCItm [ SqlColumnNumber = 5, SqlFieldName = RETI_INCI_DR ];

Property RETIQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RETI_Qty ];

Property RETISp As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RETI_Sp ];

Property RETISpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = RETI_SpAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RETI_DSI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RETI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RETI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RETI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RETI_Sp">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RETI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCMATDISRET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MatDispRet.Ret_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RETI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MatDispRet.Ret_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RETI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RETI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatDispRetItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

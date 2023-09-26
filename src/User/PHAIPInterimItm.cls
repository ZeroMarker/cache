Class User.PHAIPInterimItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIII_RowID, SqlTableName = PHAIP_InterimItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PIIIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PIIIPIIParRef As User.PHAIPInterim [ Cardinality = parent, Inverse = ChildPHAIPInterimItm, Required, SqlFieldName = PIII_PII_ParRef ];

Property PIIIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PIII_ChildSub ];

Property PIIIInciDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = PIII_Inci_DR ];

Property PIIIQty As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = PIII_Qty ];

Property PIIIDspDR As User.DHCOEDispensing [ SqlColumnNumber = 5, SqlFieldName = PIII_Dsp_DR ];

Property PIIIPYFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PIII_PYFlag ];

Property PIIIPhaiDR As User.DHCPHACollectItm [ SqlColumnNumber = 7, SqlFieldName = PIII_Phai_DR ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PIII_Dsp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIII_Inci_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIII_PYFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIII_Phai_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIII_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BS.PHA.IP.Interim</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIP_Interim.PII_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIII_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIP_Interim.PII_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIII_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHAIPInterimItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

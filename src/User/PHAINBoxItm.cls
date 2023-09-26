Class User.PHAINBoxItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIBI_RowID, SqlTableName = PHAIN_BoxItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PIBIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PIBIPHBParRef As User.DHCPHBox [ Cardinality = parent, Inverse = ChildPHAINBoxItm, Required, SqlFieldName = PIBI_PHB_ParRef ];

Property PIBIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PIBI_ChildSub ];

Property PIBIPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PIBI_PrescNo ];

Property PIBIPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = PIBI_Pointer ];

Property PIBIType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = PIBI_Type ];

Property PIBIReceiveCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PIBI_Receive_Check ];

Property PIBIWardDisp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = PIBI_Ward_Disp ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PIBI_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIBI_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIBI_Receive_Check">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIBI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIBI_Ward_Disp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BS.PHA.IN.Box</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHBox.PHB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHBox.PHB_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIBI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPointer">
<Global>^BS.PHA.IN.Box</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHBox.PHB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIBI_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIBI_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHBox.PHB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^BS.PHA.IN.Box</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHBox.PHB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIBI_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHBox.PHB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAINBoxItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

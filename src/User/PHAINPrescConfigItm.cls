Class User.PHAINPrescConfigItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIPCI_RowID, SqlTableName = PHAIN_PrescConfigItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PIPCIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PIPCIPIPCParRef As User.PHAINPrescConfig [ Cardinality = parent, Inverse = ChildPHAINPrescConfigItm, Required, SqlFieldName = PIPCI_PIPC_ParRef ];

Property PIPCIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PIPCI_ChildSub ];

Property PIPCIPresTypeDR As User.PHAINPrescType [ SqlColumnNumber = 3, SqlFieldName = PIPCI_PresType_DR ];

Property PIPCISort As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = PIPCI_Sort ];

Property PIPCIType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = PIPCI_Type ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PIPCI_PresType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIPCI_Sort">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIPCI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CD.PHA.IN.PrescConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_PrescConfig.PIPC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIPCI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_PrescConfig.PIPC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIPCI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHAINPrescConfigItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

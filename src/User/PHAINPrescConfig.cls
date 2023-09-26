Class User.PHAINPrescConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIPC_RowID, SqlTableName = PHAIN_PrescConfig, StorageStrategy = SQLStorage ]
{

Relationship ChildPHAINPrescConfigItm As User.PHAINPrescConfigItm [ Cardinality = children, Inverse = PIPCIPIPCParRef ];

Property PIPCType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PIPC_Type ];

Property PIPCPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PIPC_Pointer ];

Property PIPCHerbPresTypeDR As User.PHAHERBPresType [ SqlColumnNumber = 4, SqlFieldName = PIPC_HerbPresType_DR ];

Property PIPCOPFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = PIPC_OPFlag ];

Property PIPCIPFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PIPC_IPFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CD.PHA.IN.PrescConfig(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PIPC_HerbPresType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIPC_IPFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIPC_OPFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIPC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIPC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CD.PHA.IN.PrescConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIPC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^CD.PHA.IN.PrescConfig</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PIPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIPC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIPC_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PIPC_RowID</SqlRowIdName>
<StreamLocation>^User.PHAINPrescConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

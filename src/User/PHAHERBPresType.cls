Class User.PHAHERBPresType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPT_RowID, SqlTableName = PHAHERB_PresType, StorageStrategy = sqlStorage ]
{

Relationship ChildPHAHERBPresTypeItm As User.PHAHERBPresTypeItm [ Cardinality = children, Inverse = PHPTIParref ];

Property PHPTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PHPT_Code ];

Property PHPTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PHPT_Desc ];

Property PHPTDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = PHPT_Default ];

Storage sqlStorage
{
<SqlIdExpression>$i(^CD.PHA.HERB.PresType(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHPT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPT_Default">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHPT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CD.PHA.HERB.PresType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHPT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHPT_RowID</SqlRowIdName>
<StreamLocation>^User.PHAHERBPresTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

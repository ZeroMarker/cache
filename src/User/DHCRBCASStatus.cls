Class User.DHCRBCASStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASS_Rowid, SqlTableName = DHC_RBCASStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ASS_Code
Property ASSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ASS_Code ];

/// ASS_Desc
Property ASSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ASS_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCASStatus)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ASS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCASStatus</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ASS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCASStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

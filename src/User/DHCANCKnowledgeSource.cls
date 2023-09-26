/// DHC_ANC_KnowledgeSource
Class User.DHCANCKnowledgeSource Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCKS_RowId, SqlTableName = DHC_ANC_KnowledgeSource, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCKS_Code
Property ANCKSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCKS_Code ];

/// ANCKS_Desc
Property ANCKSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCKS_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("KSrc",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCKS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCKS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCKS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KSrc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCKS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANCKS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KSrc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCKS_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANCKS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCKnowledgeSourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

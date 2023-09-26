/// DHC_ANC_KnowledgeCat
Class User.DHCANCKnowledgeCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCKC_RowId, SqlTableName = DHC_ANC_KnowledgeCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCKC_Code
Property ANCKCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCKC_Code ];

/// ANCKC_Desc
Property ANCKCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCKC_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("KCat",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCKC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCKC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCKC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCKC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANCKC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCKC_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANCKC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCKnowledgeCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

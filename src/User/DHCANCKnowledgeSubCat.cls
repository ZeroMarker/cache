/// DHC_ANC_KnowledgeSubCat
Class User.DHCANCKnowledgeSubCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCKSC_RowId, SqlTableName = DHC_ANC_KnowledgeSubCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCKSC_Code
Property ANCKSCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCKSC_Code ];

/// ANCKSC_Desc
Property ANCKSCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCKSC_Desc ];

/// ANCKSC_ANCKC_Dr
Property ANCKSCANCKCDr As User.DHCANCKnowledgeCat [ SqlColumnNumber = 4, SqlFieldName = ANCKSC_ANCKC_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("KSCat",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCKSC_ANCKC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCKSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCKSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCKSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KSCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCKSC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANCKSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KSCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCKSC_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANCKSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCKnowledgeSubCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

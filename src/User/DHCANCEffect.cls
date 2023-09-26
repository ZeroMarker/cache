/// DHC_ANC_Effect
Class User.DHCANCEffect Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCEF_RowId, SqlTableName = DHC_ANC_Effect, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCEF_Code
Property ANCEFCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCEF_Code ];

/// ANCEF_Desc
Property ANCEFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCEF_Desc ];

Index ANCEFCodeUnqIdx1 On ANCEFCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("ANEffect",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCEF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCEF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCEF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANEffect"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCEF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANCEF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANEffect"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCEF_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANCEF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCEffectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

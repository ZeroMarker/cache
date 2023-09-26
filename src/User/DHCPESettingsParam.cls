/// 体检配置-参数
Class User.DHCPESettingsParam Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SP_RowId, SqlTableName = DHC_PE_SettingsParam, StorageStrategy = SQLStorage ]
{

// Index SPCodeUnique On SPCode [ Unique ];

/// 应用程序DR
Property SPSADR As User.DHCPESettingsApp [ SqlColumnNumber = 2, SqlFieldName = SP_SA_DR ];

/// 参数Code
Property SPCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = SP_Code ];

/// 参数描述
Property SPDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = SP_Desc ];

/// 参数默认值
Property SPDefault As %Library.String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SP_Default ];

/// 参数备注
Property SPNote As %Library.String(MAXLEN = 100000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SP_Note ];

Storage SQLStorage
{
<SqlIdExpression>$i(^mdata("DHCPESettingsParam"))</SqlIdExpression>
<SQLMap name="AppDRIndex">
<Global>^DHCPESettingsParam</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SP_SA_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPESettingsParam</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SP_SA_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SP_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ParamCodeIndex">
<Global>^DHCPESettingsParam</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SP_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ParamDataMast">
<Data name="SP_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SP_Default">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SP_Note">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SP_SA_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPESettingsParam</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PramAPPCode">
<Global>^DHCPESettingsParam</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APPCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SP_SA_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SP_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPESettingsParamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

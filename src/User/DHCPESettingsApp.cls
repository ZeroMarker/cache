/// 体检配置-应用程序
Class User.DHCPESettingsApp Extends (%Persistent, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SA_RowId, SqlTableName = DHC_PE_SettingsApp, StorageStrategy = SQLStorage ]
{

Index SACodeUnique On SACode [ Unique ];

/// 应用程序Code
Property SACode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = SA_Code ];

/// 应用程序描述
Property SADesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = SA_Desc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^mdata("DHCPESettingsApp"))</SqlIdExpression>
<SQLMap name="APPMastData">
<Data name="SA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPESettingsApp</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="AppCodeIndex">
<Global>^DHCPESettingsApp</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPESettingsAPPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

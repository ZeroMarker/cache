Class User.DHCDocCTModule Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHCDoc_CT_Module, StorageStrategy = SQLStorage ]
{

//Property DHCDocCTModuleCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DHCDoc_CT_Module_Code ];

/// Charge Code
/// Description
Property DHCDocCTModuleDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DHCDoc_CT_Module_Desc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocCT("Module",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCDoc_CT_Module_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDocCT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Module"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocCT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ModuleDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCDoc_CT_Module_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCTModuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

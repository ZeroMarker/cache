Class User.DHCAdvFormField Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AF_RowID, SqlTableName = DHC_AdvFormField, StorageStrategy = SQLStorage ]
{

/// 字段代码  AF_FieldCode
Property AFFieldCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = AF_FieldCode ];

/// 字段描述  AF_FieldDesc
Property AFFieldDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = AF_FieldDesc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVFF)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AF_FieldCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AF_FieldDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVFF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCADVFF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AF_FieldCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCADVFF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AF_FieldDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvFormFieldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

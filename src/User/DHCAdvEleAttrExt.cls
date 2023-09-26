Class User.DHCAdvEleAttrExt Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = EAE_RowID, SqlTableName = DHC_AdvEleAttrExt, StorageStrategy = SQLStorage ]
{

/// 属性代码 EAE_AttrCode	 
Property EAEAttrCode As %String [ SqlColumnNumber = 2, SqlFieldName = EAE_AttrCode ];

/// 元素Dr EAE_DicCode
Property EAEDicCode As %String [ SqlColumnNumber = 3, SqlFieldName = EAE_DicCode ];

/// 属性值 EAE_AttrValue
Property EAEAttrValue As %String [ SqlColumnNumber = 4, SqlFieldName = EAE_AttrValue ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVEAE)</SqlIdExpression>
<SQLMap name="IndexAttrCode">
<Global>^DHCADVEAE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EAE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EAE_AttrCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDicCode">
<Global>^DHCADVEAE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EAE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EAE_DicCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="EAE_AttrCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EAE_AttrValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EAE_DicCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVEAE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EAE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EAE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvEleAttrExtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

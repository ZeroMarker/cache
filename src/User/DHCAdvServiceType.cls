Class User.DHCAdvServiceType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SERTYPE_RowID, SqlTableName = DHC_AdvServiceType, StorageStrategy = SQLStorage ]
{

// SERTYPE_Code	状态代码

Property SERTYPECode As %String [ SqlColumnNumber = 2, SqlFieldName = SERTYPE_Code ];

// SERTYPE_Desc	状态描述

Property SERTYPEDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SERTYPE_Desc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVSERTYPE)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVSERTYPE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SERTYPE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SERTYPE_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SERTYPE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="SERTYPE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SERTYPE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVSERTYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SERTYPE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SERTYPE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvServiceTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCAdvMedUseLink Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MUL_RowID, SqlTableName = DHC_AdvMedUseLink, StorageStrategy = NewStorage1 ]
{

Property MULCode As %String [ SqlColumnNumber = 2, SqlFieldName = MUL_Code ];

Property MULDesc As %String [ SqlColumnNumber = 3, SqlFieldName = MUL_Desc ];

Relationship ChildDHCAdvMedUseLinkItm As User.DHCAdvMedUseLinkItm [ Cardinality = children, Inverse = MULIMULParref ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVMUSELK)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVMUSELK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MUL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MUL_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MUL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MUL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MUL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVMUSELK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MUL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MUL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvMedUseLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

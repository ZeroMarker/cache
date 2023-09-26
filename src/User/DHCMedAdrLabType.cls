Class User.DHCMedAdrLabType Extends %Persistent [ Owner = {_PUBLIC}, SqlRowIdName = MADRLT_RowID, SqlTableName = DHC_MedAdrLabType, StorageStrategy = NewStorage1 ]
{

Property MADRLTCode As %String [ SqlColumnNumber = 2, SqlFieldName = MADRLT_Code ];

Property MADRLTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = MADRLT_Desc ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMEDADRLTP)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCMEDADRLTP</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MADRLT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MADRLT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MADRLT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMEDADRLTP</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MADRLT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MADRLT_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MADRLT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MADRLT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MADRLT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMEDADRLTP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MADRLT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MADRLT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrLabTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

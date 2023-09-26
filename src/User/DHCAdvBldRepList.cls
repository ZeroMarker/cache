Class User.DHCAdvBldRepList Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BLD_RowID, SqlTableName = DHC_AdvBldRepList, StorageStrategy = NewStorage1 ]
{

Property BLDRepDr As %String [ SqlColumnNumber = 2, SqlFieldName = BLD_Rep_Dr ];

Property BLDBldType As %String [ SqlColumnNumber = 3, SqlFieldName = BLD_BldType ];

Relationship ChildDHCAdvBldRepListNo As User.DHCAdvBldRepListNo [ Cardinality = children, Inverse = BLDRepListParRef ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVBLDRLI)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="BLD_BldType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLD_Rep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVBLDRLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="RepDrIndex">
<Global>^DHCADVBLDRLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLD_Rep_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldRepListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

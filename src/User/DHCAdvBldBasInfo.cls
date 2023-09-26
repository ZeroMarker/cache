Class User.DHCAdvBldBasInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BCI_RowID, SqlTableName = DHC_AdvBldBasInfo, StorageStrategy = NewStorage1 ]
{

Property BCIBRepDr As User.DHCAdvBloodReport [ SqlColumnNumber = 2, SqlFieldName = BCI_BRep_Dr ];

Property BCIBasDr As User.DHCAdvBldBasic [ SqlColumnNumber = 3, SqlFieldName = BCI_Bas_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVBLDBACI)</SqlIdExpression>
<SQLMap name="IndexBRepDr">
<Global>^DHCADVBLDBACI</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BCI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BRepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BCI_BRep_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBasDr">
<Global>^DHCADVBLDBACI</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BasDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BCI_Bas_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BCI_BRep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BCI_Bas_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVBLDBACI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BCI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BCI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldBasInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

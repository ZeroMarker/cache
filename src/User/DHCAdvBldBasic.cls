Class User.DHCAdvBldBasic Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDB_RowID, SqlTableName = DHC_AdvBldBasic, StorageStrategy = NewStorage1 ]
{

Property BLDBCode As %String [ SqlColumnNumber = 2, SqlFieldName = BLDB_Code ];

Property BLDBDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BLDB_Desc ];

Property BLDBType As %String [ SqlColumnNumber = 4, SqlFieldName = BLDB_Type ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVBLDBASIC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVBLDBASIC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BLDB_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BLDB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLDB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLDB_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVBLDBASIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldBasicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

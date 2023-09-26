Class User.DHCAdvBldType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDT_RowID, SqlTableName = DHC_AdvBldType, StorageStrategy = NewStorage1 ]
{

Property BLDTCode As %String [ SqlColumnNumber = 2, SqlFieldName = BLDT_Code ];

Property BLDTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BLDT_Desc ];

Property BLDTActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BLDT_Active ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCADVBLDTYPE)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVBLDTYPE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BLDT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BLDT_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLDT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLDT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVBLDTYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

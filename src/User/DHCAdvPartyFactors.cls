Class User.DHCAdvPartyFactors Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PARFAC_RowID, SqlTableName = DHC_AdvPartyFactors, StorageStrategy = NewStorage1 ]
{

Property PARFACCode As %String [ SqlColumnNumber = 2, SqlFieldName = PARFAC_Code ];

Property PARFACDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PARFAC_Desc ];

Property PARFACLevel As %String [ SqlColumnNumber = 4, SqlFieldName = PARFAC_Level ];

Property PARFACLevelRowID As %String [ SqlColumnNumber = 5, SqlFieldName = PARFAC_LevelRowID ];

Property PARFACActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PARFAC_ActiveFlag ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCADVPARFAC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVPARFAC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PARFAC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PARFAC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PARFAC_LevelRowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PARFAC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLeveldr">
<Global>^DHCADVPARFAC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PARFAC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LevelRowID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PARFAC_LevelRowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PARFAC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PARFAC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PARFAC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PARFAC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PARFAC_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PARFAC_LevelRowID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVPARFAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PARFAC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PARFAC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvPartyFactorsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

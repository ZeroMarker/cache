Class User.DHCAdvMedRepCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MRC_RowID, SqlTableName = DHC_AdvMedRepCat, StorageStrategy = NewStorage1 ]
{

Property MRCCode As %String [ SqlColumnNumber = 2, SqlFieldName = MRC_Code ];

Property MRCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = MRC_Desc ];

Property MRCLevel As %String [ SqlColumnNumber = 4, SqlFieldName = MRC_Level ];

Property MRCLevelRowID As %String [ SqlColumnNumber = 5, SqlFieldName = MRC_LevelRowID ];

Property MRCActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = MRC_ActiveFlag ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVMEDRCA)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVMEDRCA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MRC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLeveldr">
<Global>^DHCADVMEDRCA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LevelRowID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRC_LevelRowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MRC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRC_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRC_LevelRowID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVMEDRCA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MRC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvMedRepCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

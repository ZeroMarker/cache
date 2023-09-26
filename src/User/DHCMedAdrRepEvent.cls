Class User.DHCMedAdrRepEvent Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MADREV_RowID, SqlTableName = DHC_MedAdrRepEvent, StorageStrategy = NewStorage1 ]
{

Relationship ChildDHCMedAdrRepEventItm As User.DHCMedAdrRepEventItm [ Cardinality = children, Inverse = MADREVIParref ];

Property MADREVCode As %String [ SqlColumnNumber = 2, SqlFieldName = MADREV_Code ];

Property MADREVDesc As %String [ SqlColumnNumber = 3, SqlFieldName = MADREV_Desc ];

Property MADREVActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MADREV_ActiveFlag ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMEDADREVT)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="MADREV_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MADREV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MADREV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMEDADREVT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MADREV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MADREV_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCMEDADREVT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MADREV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MADREV_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MADREV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDesc">
<Global>^DHCMEDADREVT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MADREV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MADREV_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MADREV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrRepEventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

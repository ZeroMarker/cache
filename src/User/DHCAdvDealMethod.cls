Class User.DHCAdvDealMethod Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ADME_RowID, SqlTableName = DHC_AdvDealMethod, StorageStrategy = NewStorage1 ]
{

Property ADMECode As %String [ SqlColumnNumber = 2, SqlFieldName = ADME_Code ];

Property ADMEDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ADME_Desc ];

Property ADMEActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ADME_ActiveFlag ];

/// 集团化医院  AIME_Hosp_Dr
Property ADMEHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = ADME_Hosp_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVDEMED)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVDEMED</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ADME_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADME_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADME_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADME_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADME_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADME_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVDEMED</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADME_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvDealMethodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

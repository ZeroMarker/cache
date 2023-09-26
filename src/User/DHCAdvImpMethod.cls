Class User.DHCAdvImpMethod Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AIME_RowID, SqlTableName = DHC_AdvImpMethod, StorageStrategy = NewStorage1 ]
{

Property AIMECode As %String [ SqlColumnNumber = 2, SqlFieldName = AIME_Code ];

Property AIMEDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AIME_Desc ];

Property AIMEActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AIME_ActiveFlag ];

/// 集团化医院  AIME_Hosp_Dr
Property AIMEHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AIME_Hosp_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVIMPMED)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVIMPMED</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AIME_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIME_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="AIME_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AIME_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AIME_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AIME_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVIMPMED</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AIME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AIME_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvImpMethodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

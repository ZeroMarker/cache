Class User.DHCMedAdrLabItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MADRLI_RowID, SqlTableName = DHC_MedAdrLabItem, StorageStrategy = NewStorage1 ]
{

Property MADRLIItemCode As %String [ SqlColumnNumber = 2, SqlFieldName = MADRLI_ItemCode ];

Property MADRLIItemDesc As %String [ SqlColumnNumber = 3, SqlFieldName = MADRLI_ItemDesc ];

Property MADRLIItemVal As %String [ SqlColumnNumber = 4, SqlFieldName = MADRLI_ItemVal ];

Property MADRLIItemUom As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = MADRLI_ItemUom ];

Property MADRLIItemActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = MADRLI_ItemActiveFlag ];

Property MADRLIType As DHCMedAdrLabType [ SqlColumnNumber = 7, SqlFieldName = MADRLI_Type ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMEDADRLI)</SqlIdExpression>
<SQLMap name="IndexType">
<Global>^DHCMEDADRLI</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MADRLI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MADRLI_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MADRLI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MADRLI_ItemActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MADRLI_ItemCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MADRLI_ItemDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MADRLI_ItemUom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MADRLI_ItemVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MADRLI_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMEDADRLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MADRLI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MADRLI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrLabItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

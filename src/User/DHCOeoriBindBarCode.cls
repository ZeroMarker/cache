/// 医嘱绑定高值条码
Class User.DHCOeoriBindBarCode Extends (%Persistent, User.Abstract) [ SqlRowIdName = DHCOBB_RowId, SqlTableName = DHC_OeoriBindBarCode, StorageStrategy = SQLStorage ]
{

Property DHCOBBOEORIDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DHCOBB_OEORI_DR ];

Property DHCOBBItmTrackDR As User.DHCItmTrack [ SqlColumnNumber = 3, SqlFieldName = DHCOBB_ItmTrack_DR ];

Property DHCOBBAckFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DHCOBB_AckFlag ];

Property DHCOBBDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DHCOBB_Date ];

Property DHCOBBTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DHCOBB_Time ];

Property DHCOBBSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DHCOBB_SSUSR_DR ];

Property DHCOBBAckDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = DHCOBB_AckDate ];

Property DHCOBBAckTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DHCOBB_AckTime ];

Property DHCOBBAckSSUSRDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = DHCOBB_AckSSUSR_DR ];

Property DHCOBBCancelDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = DHCOBB_CancelDate ];

Property DHCOBBCancelTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DHCOBB_CancelTime ];

Property DHCOBBCancelSSUSRDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = DHCOBB_CancelSSUSR_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOBB)</SqlIdExpression>
<SQLMap name="IndexOeori">
<Global>^DHCOBB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCOBB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCOBB_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCOBB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCOBB_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCOBB_AckFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCOBB_AckSSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCOBB_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCOBB_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCOBB_CancelSSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCOBB_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCOBB_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCOBB_ItmTrack_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCOBB_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCOBB_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCOBB_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCOBB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCOBB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCOBB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCOBB_RowId</SqlRowIdName>
<StreamLocation>^User.DHCOeoriBindBarCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCOBB)
	s oldI = +$g(^mdata("DHCOBB"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCOBB = maxI
	s ^mdata("DHCOBB") = maxI
}

Parameter EXTENTSIZE = 250;

}

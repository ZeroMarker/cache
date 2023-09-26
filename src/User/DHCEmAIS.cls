Class User.DHCEmAIS Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = AIS_RowId, SqlTableName = DHC_EmAIS, StorageStrategy = NewStorage1 ]
{

/// 项目描述 AIS_ItmDesc
Property AISItmDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = AIS_ItmDesc ];

/// 项目代码 AIS_ItmCode
Property AISItmCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = AIS_ItmCode ];

/// 是否可用 AIS_ActiveFlag
Property AISActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AIS_ActiveFlag ];

/// 集团化医院 AIS_Hosp_Dr
Property AISHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AIS_Hosp_Dr ];

Relationship ChildDHCEMAISITEM As User.DHCEmAISItem [ Cardinality = children, Inverse = AISParRefDr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMAIS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AIS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AIS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AIS_ItmCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AIS_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMAIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AIS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AIS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMAIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AIS_ItmCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCodeHos">
<Global>^DHCEMAIS</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CodeHos"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AIS_ItmCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIS_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AIS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmAISS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

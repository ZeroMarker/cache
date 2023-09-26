Class User.DHCAppTesDiag Extends %Persistent [ SqlRowIdName = AT_RowID, SqlTableName = DHC_AppTesDiag, StorageStrategy = SQLStorage ]
{

/// 代码 AT_Code
Property ATCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = AT_Code ];

/// 描述 AT_Desc
Property ATDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = AT_Desc ];

/// 医院标识 AT_Hosp_Dr
Property ATHospDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = AT_Hosp_Dr ];

/// 是否可用 AT_ActiveFlag
Property ATActiveFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AT_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPTD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPPTD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPTD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AT_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTesDiagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

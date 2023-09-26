Class User.DHCAppPosition Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPosition, StorageStrategy = SQLStorage ]
{

/// 代码
Property APCode As %String [ SqlColumnNumber = 2, SqlFieldName = AP_Code ];

/// 描述
Property APDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AP_Desc ];

/// 是否可用
Property APActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AP_ActiveFlag ];

/// 上一级的rowid
Property APHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AP_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPPOS)</SqlIdExpression>
<SQLMap name="IndexDesc">
<Global>^DHCAPPOS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="AP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCAPPOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexapcode">
<Global>^DHCAPPOS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPositionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

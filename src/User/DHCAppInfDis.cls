Class User.DHCAppInfDis Extends %Persistent [ SqlRowIdName = AP_RowID, SqlTableName = DHC_AppInfDis, StorageStrategy = SQLStorage ]
{

/// 代码 AP_Code
Property APCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = AP_Code ];

/// 描述 AP_Desc
Property APDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = AP_Desc ];

/// 医院标识 AP_Hosp_Dr
Property APHospDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = AP_Hosp_Dr ];

/// 是否可用 AP_ActiveFlag
Property APActiveFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AP_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPID)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
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
<Piece>3</Piece>
</Data>
<Global>^DHCAPPID</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCAPPID</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
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
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCAPPID</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
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
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppInfDisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

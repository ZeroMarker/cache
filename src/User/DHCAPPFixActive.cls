Class User.DHCAPPFixActive Extends %Persistent [ Not ProcedureBlock, SqlRowIdName = AP_FixRowId, SqlTableName = DHC_AppFixActive, StorageStrategy = SQLStorage ]
{

/// 描述 AP_FixCode
Property APFixCode As %String [ SqlColumnNumber = 2, SqlFieldName = AP_FixCode ];

/// 代码 AP_FixDesc
Property APFixDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AP_FixDesc ];

/// 医院 AP_Hosp_Dr
Property APHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = AP_Hosp_Dr ];

/// 可用标志 AP_ActiveFlag
Property APActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AP_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPFIXACTIVE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_FixCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_FixDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPFIX</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_FixRowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_FixRowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPPFIX</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_FixRowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_FixCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_FixRowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPFIX</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_FixRowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_FixDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_FixRowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AP_FixRowId</SqlRowIdName>
<StreamLocation>^User.DHCAPPFixActiveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

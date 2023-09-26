Class User.DHCAppPisTesItm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisTesItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 病理申请主表  AP_PisMas_Dr
Property APPisMasDr As User.DHCAppPisMaster [ SqlColumnNumber = 2, SqlFieldName = AP_PisMas_Dr ];

/// 检测方法   AP_TesItm_Dr
Property APTesItmDr As %Library.String [ SqlColumnNumber = 3, SqlFieldName = AP_TesItm_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCAPPPTI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_PisMas_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_TesItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPPTI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPisMas">
<Global>^DHCAPPPTI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PisMas"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_PisMas_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisTesItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

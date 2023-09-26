Class User.DHCAppPisInfDis Extends %Persistent [ SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisInfDis, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 病理申请主表  AP_PisMas_Dr
Property APPisMasDr As User.DHCAppPisMaster [ SqlColumnNumber = 2, SqlFieldName = AP_PisMas_Dr ];

/// 传染病史   AP_InfDis_Dr User.DHCAppInfDis 2019-11-22由原先传染病史维护页面迁移到病理基础字典维护
Property APInfDisDr As User.DHCAppPisDicItem [ SqlColumnNumber = 3, SqlFieldName = AP_InfDis_Dr ];

/// 传染病史   AP_InfDisDesc
Property APInfDisDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AP_InfDisDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCAPPPID)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_InfDisDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_InfDis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_PisMas_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPPPID</Global>
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
<Global>^DHCAPPPID</Global>
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
<StreamLocation>^User.DHCAppPisInfDisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

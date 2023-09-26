Class User.DHCAppPatSigns Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APS_RowID, SqlTableName = DHC_AppPatSigns, StorageStrategy = SQLStorage ]
{

/// 就诊ID  APS_Adm_Dr
Property APSAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = APS_Adm_Dr ];

/// 体征内容  APS_Signs
Property APSSigns As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = APS_Signs ];

/// 检查申请表ID DHC_AppReport  APS_Req_Dr
Property APSReqDr As User.DHCAppReport [ SqlColumnNumber = 4, SqlFieldName = APS_Req_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPPATSI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APS_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APS_Req_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APS_Signs">
<Node>"Sings"</Node>
</Data>
<Global>^DHCAPPATSI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCAPPATSI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APS_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReq">
<Global>^DHCAPPATSI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APS_Req_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPatSignsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

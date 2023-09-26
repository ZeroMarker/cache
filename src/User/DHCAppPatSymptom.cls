Class User.DHCAppPatSymptom Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APS_RowID, SqlTableName = DHC_AppPatSymptom, StorageStrategy = SQLStorage ]
{

/// 就诊ID  APS_Adm_Dr
Property APSAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = APS_Adm_Dr ];

/// 主诉  APS_Symptom
Property APSSymptom As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = APS_Symptom ];

/// 检查申请表ID DHC_AppReport  APS_Req_Dr
Property APSReqDr As User.DHCAppReport [ SqlColumnNumber = 4, SqlFieldName = APS_Req_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPATSY)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APS_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APS_Req_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APS_Symptom">
<Node>"Symptom"</Node>
</Data>
<Global>^DHCAPPATSY</Global>
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
<Global>^DHCAPPATSY</Global>
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
<Global>^DHCAPPATSY</Global>
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
<StreamLocation>^User.DHCAppPatSymptomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

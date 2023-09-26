Class User.DHCAppPreHis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APH_RowID, SqlTableName = DHC_AppPreHis, StorageStrategy = SQLStorage ]
{

/// 就诊ID  APH_Adm_Dr
Property APHAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = APH_Adm_Dr ];

/// 现病史内容  APH_History
Property APHHistory As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = APH_History ];

/// 检查申请表ID DHC_AppReport  APH_Req_Dr
Property APHReqDr As User.DHCAppReport [ SqlColumnNumber = 4, SqlFieldName = APH_Req_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPPREH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APH_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APH_History">
<Node>"History"</Node>
</Data>
<Data name="APH_Req_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPREH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APH_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCAPPREH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APH_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReq">
<Global>^DHCAPPREH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APH_Req_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPreHisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

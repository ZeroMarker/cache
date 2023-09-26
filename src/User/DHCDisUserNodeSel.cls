Class User.DHCDisUserNodeSel Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = UNS_RowID, SqlTableName = DHC_DisUserNodeSel, StorageStrategy = SQLStorage ]
{

/// 岗位ID  UNS_Node_Dr
Property UNSNodeDr As User.DHCDisWorkNode [ SqlColumnNumber = 2, SqlFieldName = UNS_Node_Dr ];

/// 用户ID  UNS_User_Dr
Property UNSUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = UNS_User_Dr ];

/// 班次ID  UNS_Sche_Dr
Property UNSScheDr As User.DHCDisSchedule [ SqlColumnNumber = 4, SqlFieldName = UNS_Sche_Dr ];

/// 开始日期  UNS_CreateDate	
Property UNSCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = UNS_CreateDate ];

/// 开始时间  UNS_CreateTime	
Property UNSCreateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = UNS_CreateTime ];

/// 截止日期  UNS_UpdDate	
Property UNSUpdDate As %Date [ SqlColumnNumber = 7, SqlFieldName = UNS_UpdDate ];

/// 截止时间  UNS_UpdTime	
Property UNSUpdTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = UNS_UpdTime ];

/// 状态  UNS_Status
Property UNSStatus As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = UNS_Status ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISUNS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UNS_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UNS_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UNS_Node_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UNS_Sche_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UNS_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UNS_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UNS_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UNS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISUNS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UNS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UNS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateUser">
<Global>^DHCDISUNS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UNS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UNS_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UNS_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UNS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNode">
<Global>^DHCDISUNS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UNS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchDateStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UNS_Node_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UNS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchDateStatus">
<Global>^DHCDISUNS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UNS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UNS_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UNS_Sche_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UNS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisUserNodeSelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

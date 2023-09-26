Class User.DHCInPhReq Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHR_RowID, SqlTableName = DHC_InPhReq, StorageStrategy = SQLStorage ]
{

/// d ##Class(User.DHCInPhReq).%BuildIndices()
Parameter EXTENTSIZE = 250;

Relationship ChildDHCInPhReqItm As User.DHCInPhReqItm [ Cardinality = children, Inverse = PHRIPHRParref ];

/// 请领单号
Property PHRNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHR_No ];

/// 病区指向的科室ID
Property PHRWardLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHR_WardLoc_Dr ];

/// 发药科室ID
Property PHRDispLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHR_DispLoc_Dr ];

/// 请领人id
Property PHRReqUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PHR_ReqUser_Dr ];

/// 请领日期
Property PHRReqDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PHR_ReqDate ];

/// 请领时间
Property PHRReqTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PHR_ReqTime ];

/// 请领单类型
Property PHRReqType As User.PHAIPReqType [ SqlColumnNumber = 8, SqlFieldName = PHR_ReqType ];

/// 请领单状态
Property PHRStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHR_Status ];

/// 备药主表
Property PHRDrawDr As User.DHCPHDraw [ SqlColumnNumber = 10, SqlFieldName = PHR_Draw_Dr ];

/// 撤销人
Property PHRCancelUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PHR_CancelUser_Dr ];

/// 撤销日期
Property PHRCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PHR_CancelDate ];

/// 撤销时间
Property PHRCancelTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PHR_CancelTime ];

/// 关联单号
Property PHRConnectNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHR_ConnectNo ];

/// 病区专业组
Property PHRWardGroupDR As User.DHCWardProGroup [ SqlColumnNumber = 15, SqlFieldName = PHR_WardGroup_DR ];

/// 提示药房开始备药日期
Property PHRStartDateDrug As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = PHR_StartDateDrug ];

/// 提示药房开始备药时间
Property PHRStartTimeDrug As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = PHR_StartTimeDrug ];

/// 提示药房开始备药人
Property PHRReadyDrugUser As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = PHR_ReadyDrugUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINPHREQ)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHR_CancelUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHR_ConnectNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHR_DispLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHR_Draw_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHR_ReadyDrugUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHR_ReqDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHR_ReqTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHR_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHR_ReqUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHR_StartDateDrug">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHR_StartTimeDrug">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHR_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHR_WardGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHR_WardLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINPHREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConnectNo">
<Global>^DHCINPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DispLocConnectNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHR_DispLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHR_ConnectNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDispLocDate">
<Global>^DHCINPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DispLocDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHR_DispLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHR_ReqDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHR_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHR_WardLoc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDrawId">
<Global>^DHCINPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DispLocDrawId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHR_DispLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHR_Draw_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeWardDate">
<Global>^DHCINPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TypeWardDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHR_WardLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHR_ReqType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHR_ReqDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardDate">
<Global>^DHCINPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WardDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHR_WardLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHR_ReqDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInPhReqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINPHREQ)
	s oldI = +$g(^mdata("DHCINPHREQ"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINPHREQ = maxI
	s ^mdata("DHCINPHREQ") = maxI
}

}

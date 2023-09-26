Class User.DHCINPO Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PO_RowId, SqlTableName = DHC_INPO, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PO_INPO_DR
Property POINPODR As User.INPO [ SqlColumnNumber = 2, SqlFieldName = PO_INPO_DR ];

/// PO_CTLOC_DR
Property POCTLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PO_CTLOC_DR ];

/// PO_SCG_DR
Property POSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 4, SqlFieldName = PO_SCG_DR ];

/// PO_StkType
Property POStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 5, SqlFieldName = PO_StkType ];

/// 请领科室
Property POReqLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PO_ReqLoc_DR ];

/// PO_ApprovedUser
Property POApprovedUser As SSUser [ SqlColumnNumber = 7, SqlFieldName = PO_ApprovedUser_DR ];

/// PO_ApprovedDate
Property POApprovedDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PO_ApprovedDate ];

/// PO_ApprovedTime
Property POApprovedTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PO_ApprovedTime ];

/// PO_SendStat
Property POSendStat As %String(DISPLAYLIST = ",Part,Finish", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",P,F") [ SqlColumnNumber = 10, SqlFieldName = PO_SendStat ];

/// PO_Carrier_DR
Property POCarrierDR As User.DHCCarrier [ SqlColumnNumber = 11, SqlFieldName = PO_Carrier_DR ];

/// PO_AuditUser_DR
Property POAuditUser As SSUser [ SqlColumnNumber = 12, SqlFieldName = PO_AuditUser_DR ];

/// PO_AuditDate
Property POAuditDate As %Date [ SqlColumnNumber = 13, SqlFieldName = PO_AuditDate ];

/// PO_AuditTime
Property POAuditTime As %Time [ SqlColumnNumber = 14, SqlFieldName = PO_AuditTime ];

/// 第三方采购平台订单ID
Property POPurPlanCodeId As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PO_PurPlanCodeId ];

/// 配送点
Property POPurDistriDR As User.PHAINPurDistribution [ SqlColumnNumber = 16, SqlFieldName = PO_PurDistri_DR ];

/// PO_SendUser_Dr 发送订单人员
Property POSendUserDr As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = PO_SendUser_Dr ];

/// PO_SendDate  发送订单日期
Property POSendDate As %Date [ SqlColumnNumber = 18, SqlFieldName = PO_SendDate ];

/// PO_SendTime 发送订单时间
Property POSendTime As %Time [ SqlColumnNumber = 19, SqlFieldName = PO_SendTime ];

/// PO_PlatStat 平台订单状态（1, 待配送,11, 配货中,12, 配送中,2, 已入库,3, 已完成,4, 已关闭）
Property POPlatStat As %String [ SqlColumnNumber = 20, SqlFieldName = PO_PlatStat ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINPO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PO_ApprovedDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PO_ApprovedTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PO_ApprovedUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PO_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PO_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PO_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PO_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PO_Carrier_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PO_INPO_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PO_PlatStat">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PO_PurDistri_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PO_PurPlanCodeId">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PO_ReqLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PO_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PO_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PO_SendStat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PO_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PO_SendUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PO_StkType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINPO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINPO">
<Global>^DHCINPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INPO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PO_INPO_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINPOS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINPO)
	s oldI = +$g(^mdata("DHCINPO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINPO = maxI
	s ^mdata("DHCINPO") = maxI
}

}

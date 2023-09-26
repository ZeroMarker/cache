Class User.DHCMedAdrRepAudit Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDADR_RowID, SqlTableName = DHC_MedAdrRepAudit, StorageStrategy = NewStorage1 ]
{

Relationship ChildDHCMedAdrRepAuditItm As User.DHCMedAdrRepAuditItm [ Cardinality = children, Inverse = MEDADRIAdtParRef ];

/// MEDADR_Pointer	报告
Property MEDADRPointer As %String [ SqlColumnNumber = 2, SqlFieldName = MEDADR_Pointer ];

/// MEDADR_Type	报告类别
Property MEDADRType As %String [ SqlColumnNumber = 3, SqlFieldName = MEDADR_Type ];

/// MEDADR_Status_DR	审核状态
Property MEDADRStatusDR As %String [ SqlColumnNumber = 4, SqlFieldName = MEDADR_Status_DR ];

/// MEDADR_AuditUser_DR	审核人
Property MEDADRAuditUserDR As %String [ SqlColumnNumber = 5, SqlFieldName = MEDADR_AuditUser_DR ];

/// MEDADR_AuditDate	审核日期
Property MEDADRAuditDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MEDADR_AuditDate ];

/// MEDADR_AuditTime	审核时间
Property MEDADRAuditTime As %Time [ SqlColumnNumber = 7, SqlFieldName = MEDADR_AuditTime ];

/// MEDADR_NextLoc_DR	指向处理部门
Property MEDADRNextLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = MEDADR_NextLoc_DR ];

/// MEDADR_LocAdvice	科室意见
Property MEDADRLocAdvice As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MEDADR_LocAdvice ];

/// MEDADR_Receive	接收状态
Property MEDADRReceive As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MEDADR_Receive ];

/// MEDADR_RetReason	驳回原因
Property MEDADRRetReason As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MEDADR_RetReason ];

/// MEDADR_Invaild	作废
Property MEDADRInvaild As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MEDADR_Invaild ];

/// MEDADR_AuditLoc_DR	审核部门
Property MEDADRAuditLocDR As User.CTLoc [ SqlColumnNumber = 13, SqlFieldName = MEDADR_AuditLoc_DR ];

/// MEDADR_RecProgress	进展情况说明 调查核实
Property MEDADRRecProgress As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MEDADR_RecProgress ];

/// MEDADR_RetStatus	驳回指向 指向状态
Property MEDADRRetStatus As %String [ SqlColumnNumber = 15, SqlFieldName = MEDADR_RetStatus ];

/// MEDADR_TimeOutFlag	护士长审核超时
Property MEDADRTimeOutFlag As %String [ SqlColumnNumber = 16, SqlFieldName = MEDADR_TimeOutFlag ];

/// 审批完成标志、最后一个状态
Property MEDADROverFlag As %String [ SqlColumnNumber = 17, SqlFieldName = MEDADR_OverFlag ];

/// 状态
Property MEDADRStatus As %String [ SqlColumnNumber = 18, SqlFieldName = MEDADR_Status ];

/// MEDADR_TransUser_Dr	转办处理人
Property MEDADRTransUserDr As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = MEDADR_TransUser_Dr ];

/// MEDADR_ReqUser_Dr	请示处理人
Property MEDADRReqUserDr As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = MEDADR_ReqUser_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMEDREPADT)</SqlIdExpression>
<SQLMap name="IndexPointerNext">
<Global>^DHCMEDREPADT</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MEDADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PointerNext"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDADR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDADR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEDADR_NextLoc_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MEDADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPoitner">
<Global>^DHCMEDREPADT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEDADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDADR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDADR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEDADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeSta">
<Global>^DHCMEDREPADT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEDADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeSta"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDADR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDADR_Status_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEDADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MEDADR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEDADR_AuditLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEDADR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEDADR_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEDADR_Invaild">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEDADR_LocAdvice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEDADR_NextLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEDADR_OverFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MEDADR_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDADR_RecProgress">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MEDADR_Receive">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEDADR_ReqUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MEDADR_RetReason">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEDADR_RetStatus">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MEDADR_Status">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MEDADR_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDADR_TimeOutFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MEDADR_TransUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MEDADR_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMEDREPADT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MEDADR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrRepAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

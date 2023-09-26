/// PanicReportTrans
Class User.DHCAntCVReportTrans Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPRT_RowID, SqlTableName = DHC_AntCVReportTrans, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DPRTOrder [ IdKey, PrimaryKey, Unique ];

/// DHC_AntCVReport Parent Reference
Relationship DPRTParRef As User.DHCAntCVReport [ Cardinality = parent, Inverse = ChildDHCAntCVReportTrans, Required, SqlFieldName = DPRT_ParRef ];

/// DPRT_Order
Property DPRTOrder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DPRT_Order ];

/// DPRT_Date
Property DPRTDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 3, SqlFieldName = DPRT_Date ];

/// DPRT_Time
Property DPRTTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DPRT_Time ];

/// DPRT_UserID
Property DPRTUserID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DPRT_UserID ];

/// DPRT_TimeOfNotice
Property DPRTTimeOfNotice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DPRT_TimeOfNotice ];

/// DPRT_NameOfNotice
Property DPRTNameOfNotice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DPRT_NameOfNotice ];

/// DPRT_LinkPhoneNo
Property DPRTLinkPhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DPRT_LinkPhoneNo ];

/// DPRT_Comment
Property DPRTComment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DPRT_Comment ];

/// DPRT_SendStatus
Property DPRTSendStatus As %Library.String(DISPLAYLIST = ",Created,Finish", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",C,F") [ SqlColumnNumber = 10, SqlFieldName = DPRT_SendStatus ];

/// DPRT_Advice 处理意见
Property DPRTAdvice As %String(MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DPRT_Advice ];

/// DPRT_ExecResult 处理结果字典代码 个别其它项目使用
Property DPRTExecResult As %String [ SqlColumnNumber = 12, SqlFieldName = DPRT_ExecResult ];

/// DPRT_SessLoc 操作时科室
Property DPRTSessLoc As %Integer [ SqlColumnNumber = 13, SqlFieldName = DPRT_SessLoc ];

/// 医生工号
Property DPRTDocCode As %String [ SqlColumnNumber = 14, SqlFieldName = DPRT_DocCode ];

/// 医生电话
Property DPRTDocTel As %String [ SqlColumnNumber = 15, SqlFieldName = DPRT_DocTel ];

/// 联系人与患者关系
Property DPRTPatRelation As User.CTRelation [ SqlColumnNumber = 16, SqlFieldName = DPRT_PatRelation ];

/// DPRT_OpUserCode 操作人工号
Property DPRTOpUserCode As %String [ SqlColumnNumber = 17, SqlFieldName = DPRT_OpUserCode ];

/// DPRT_OpType 操作 Receive接收 Exec处理 Delete删除 ForwardDoc转发医生
Property DPRTOpType As %String(DISPLAYLIST = ",Receive,Exec,Delete,ForwardDoc", VALUELIST = ",Rec,E,D,FwD") [ SqlColumnNumber = 18, SqlFieldName = DPRT_OpType ];

/// DPRT_FwToLocDr 转发时选择的科室ID
Property DPRTFwToLocDr As User.CTLoc [ SqlColumnNumber = 19, SqlFieldName = DPRT_FwToLocDr ];

/// DPRT_FwToUserDr 转发时选择的用户ID
Property DPRTFwToUserDr As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = DPRT_FwToUserDr ];

/// DPRT_FwToUserDr 转发时选择的用户ID2
Property DPRTFwToUserDr2 As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = DPRT_FwToUserDr2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DPRT_Advice">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DPRT_Comment">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DPRT_Date">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPRT_DocCode">
<Delimiter>"\"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DPRT_DocTel">
<Delimiter>"\"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DPRT_ExecResult">
<Delimiter>"\"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DPRT_FwToLocDr">
<Delimiter>"\"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DPRT_FwToUserDr">
<Delimiter>"\"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DPRT_FwToUserDr2">
<Delimiter>"\"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DPRT_LinkPhoneNo">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPRT_NameOfNotice">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DPRT_OpType">
<Delimiter>"\"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DPRT_OpUserCode">
<Delimiter>"\"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DPRT_PatRelation">
<Delimiter>"\"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DPRT_SendStatus">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DPRT_SessLoc">
<Delimiter>"\"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DPRT_Time">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DPRT_TimeOfNotice">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPRT_UserID">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAntCVReport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AntCVReport.DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_AntCVReport.DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>DHC_AntCVReport.DPRP_Order</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L5}</Expression>
<Field>DPRT_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AntCVReport.DPRP_Type}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_AntCVReport.DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AntCVReport.DPRP_Order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TR"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRT_Order}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCAntCVReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AntCVReport.DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_AntCVReport.DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DHC_AntCVReport.DPRP_Order</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>DPRT_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AntCVReport.DPRP_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AntCVReport.DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_AntCVReport.DPRP_Order}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DPRT_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendStatus">
<Global>^DHCAntCVReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AntCVReport.DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_AntCVReport.DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DHC_AntCVReport.DPRP_Order</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>DPRT_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEND"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRT_SendStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AntCVReport.DPRP_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AntCVReport.DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_AntCVReport.DPRP_Order}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DPRT_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAntCVReportTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

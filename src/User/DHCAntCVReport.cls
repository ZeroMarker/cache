/// Panic Report
Class User.DHCAntCVReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPRP_RowID, SqlTableName = DHC_AntCVReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (DPRPType, DPRPLabNo, DPRPOrder) [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCAntCVReportItems As User.DHCAntCVReportItems [ Cardinality = children, Inverse = DPRIParRef ];

Relationship ChildDHCAntCVReportTrans As User.DHCAntCVReportTrans [ Cardinality = children, Inverse = DPRTParRef ];

Relationship ChildDHCAntCVReportLink As User.DHCAntCVReportLink [ Cardinality = children, Inverse = DPRLParRef ];

Relationship ChildDHCAntCVReportAdmLog As User.DHCAntCVReportAdmLog [ Cardinality = children, Inverse = DPRALParRef ];

/// Labno
Property DPRPLabNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DPRP_LabNo ];

/// Order
Property DPRPOrder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DPRP_Order ];

/// Date 记录日期
Property DPRPDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = DPRP_Date ];

/// Time 记录时间
Property DPRPTime As %Time [ SqlColumnNumber = 5, SqlFieldName = DPRP_Time ];

/// UserDR
Property DPRPUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DPRP_UserDR ];

/// EntryDate
Property DPRPEntryDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = DPRP_EntryDate ];

/// EntryTime
Property DPRPEntryTime As %Time [ SqlColumnNumber = 8, SqlFieldName = DPRP_EntryTime ];

/// EntryUserDR
Property DPRPEntryUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = DPRP_EntryUserDR ];

/// Adm
Property DPRPAdm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DPRP_Adm ];

/// Comment
Property DPRPComment As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DPRP_Comment ];

/// Status  add Delete
Property DPRPStatus As %Library.String(DISPLAYLIST = ",Created,Finish,Delete,Receive", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",C,F,D,Rec") [ SqlColumnNumber = 12, SqlFieldName = DPRP_Status ];

/// Labortory
Property DPRPLabortory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DPRP_Labortory ];

/// LabPhone
Property DPRPLabPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DPRP_LabPhone ];

/// ReceiveDT
Property DPRPReciveDT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DPRP_ReciveDT ];

Property DPRPTestSetDR As %Library.String [ SqlColumnNumber = 16, SqlFieldName = DPRP_TestSetDR ];

/// Type
Property DPRPType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DPRP_Type ];

/// Result
Property DPRPResult As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DPRP_Result ];

/// DPRP_OEOrdItemID
Property DPRPOEOrdItemID As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DPRP_OEOrdItemID ];

/// DPRP_UserName
Property DPRPUserName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DPRP_UserName ];

/// DPRP_LisExamRowid  检验传过来的id
Property DPRPLisExamRowid As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DPRP_LisExamRowid ];

/// DPRP_OtherInfo
Property DPRPOtherInfo As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DPRP_OtherInfo ];

/// DPRP_AlredySendTimes 已发送消息次数
Property DPRPAlredySendTimes As %Integer [ InitialExpression = 0, SqlColumnNumber = 23, SqlFieldName = DPRP_AlredySendTimes ];

/// ReportDate 接口参数传的报告日期
Property DPRPReportDate As %Date [ SqlColumnNumber = 24, SqlFieldName = DPRP_ReportDate ];

/// ReportTime 接口参数传的报告时间
Property DPRPReportTime As %Time [ SqlColumnNumber = 25, SqlFieldName = DPRP_ReportTime ];

/// ReportLoc 报告科室 科室ID^科室描述
Property DPRPReportLoc As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = DPRP_ReportLoc ];

/// ReportTel 报告科室电话
Property DPRPReportTel As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = DPRP_ReportTel ];

Property DPRPIsEnd As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DPRP_IsEnd ];

Property DPRPCurrProcess As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DPRP_CurrProcess ];

Property DPRPPatientID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DPRP_PatientID ];

/// 原始就诊科室
Property DPRPOriginalLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DPRP_OriginalLoc ];

/// 原始就诊科室
Property DPRPOriginalWard As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DPRP_OriginalWard ];

/// 患者在危机值未闭环 换到新的就诊记录 如急诊 住院等
Property DPRPFinalAdm As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DPRP_FinalAdm ];

/// 患者在危机值未闭环 换到转科 或者换到新的就诊
Property DPRPFinalLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DPRP_FinalLoc ];

/// 患者在危机值未闭环 换到转科 或者换到新的就诊
Property DPRPFinalWard As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DPRP_FinalWard ];

/// 患者危急值产生时 主管医生 人员
Property DPRPOriginalDoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DPRP_OriginalDoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DPRP_Adm">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DPRP_AlredySendTimes">
<Delimiter>"\"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DPRP_Comment">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DPRP_CurrProcess">
<Delimiter>"\"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DPRP_Date">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPRP_EntryDate">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPRP_EntryTime">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DPRP_EntryUserDR">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPRP_FinalAdm">
<Delimiter>"\"</Delimiter>
<Node>"EXTD"</Node>
<Piece>4</Piece>
</Data>
<Data name="DPRP_FinalLoc">
<Delimiter>"\"</Delimiter>
<Node>"EXTD"</Node>
<Piece>5</Piece>
</Data>
<Data name="DPRP_FinalWard">
<Delimiter>"\"</Delimiter>
<Node>"EXTD"</Node>
<Piece>6</Piece>
</Data>
<Data name="DPRP_IsEnd">
<Delimiter>"\"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DPRP_LabPhone">
<Delimiter>"\"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DPRP_Labortory">
<Delimiter>"\"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DPRP_LisExamRowid">
<Delimiter>"\"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DPRP_OEOrdItemID">
<Delimiter>"\"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DPRP_OriginalDoc">
<Delimiter>"\"</Delimiter>
<Node>"EXTD"</Node>
<Piece>7</Piece>
</Data>
<Data name="DPRP_OriginalLoc">
<Delimiter>"\"</Delimiter>
<Node>"EXTD"</Node>
<Piece>2</Piece>
</Data>
<Data name="DPRP_OriginalWard">
<Delimiter>"\"</Delimiter>
<Node>"EXTD"</Node>
<Piece>3</Piece>
</Data>
<Data name="DPRP_OtherInfo">
<Delimiter>"\"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DPRP_PatientID">
<Delimiter>"\"</Delimiter>
<Node>"EXTD"</Node>
<Piece>1</Piece>
</Data>
<Data name="DPRP_ReciveDT">
<Delimiter>"\"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DPRP_ReportDate">
<Delimiter>"\"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DPRP_ReportLoc">
<Delimiter>"\"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DPRP_ReportTel">
<Delimiter>"\"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DPRP_ReportTime">
<Delimiter>"\"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DPRP_Result">
<Node>"Result"</Node>
</Data>
<Data name="DPRP_Status">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DPRP_TestSetDR">
<Delimiter>"\"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DPRP_Time">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DPRP_UserDR">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DPRP_UserName">
<Delimiter>"\"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCAntCVReport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>DPRP_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DPRP_Type}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>{DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRP_Order}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCAntCVReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DPRP_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRP_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPRP_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DPRP_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCAntCVReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DPRP_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPRP_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DPRP_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFinalAdm">
<Global>^DHCAntCVReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DPRP_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FNLADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRP_FinalAdm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPRP_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DPRP_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatEnd">
<Condition>{DPRP_IsEnd}="0"</Condition>
<ConditionFields>DPRP_PatientID,DPRP_IsEnd</ConditionFields>
<Global>^DHCAntCVReport</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DPRP_Order</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatEnd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRP_PatientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPRP_IsEnd}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRP_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DPRP_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAntCVReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

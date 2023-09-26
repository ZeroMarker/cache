/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗日期信息
Class User.ChemoPlanDate Extends (%Persistent, User.Abstract) [ SqlTableName = Chemo_PlanDate, StorageStrategy = SQLStorage ]
{

Relationship ChildStatus As User.ChemoPlanDateStatus [ Cardinality = children, Inverse = PDSParRef ];

Relationship ChildApply As User.ChemoPlanDateApply [ Cardinality = children, Inverse = PDAParRef ];

Index RowIDBasedIDKeyIndex On PDID [ IdKey, PrimaryKey, Unique ];

/// PD_ID
Property PDID As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.PlanDate(0))}, Required, SqlFieldName = PD_ID ];

/// 化疗方案ID
Property PDPLID As User.ChemoPlan [ SqlColumnNumber = 2, SqlFieldName = PD_PLID ];

/// 化疗周期ID
Property PDPSID As User.ChemoPlanStage [ SqlColumnNumber = 3, SqlFieldName = PD_PSID ];

/// 病人
Property PDPatientDR As User.PAPatMas [ SqlColumnNumber = 4, SqlFieldName = PD_PatientDR ];

/// 就诊
Property PDAdmDR As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = PD_AdmDR ];

/// 化疗日期
Property PDDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PD_Date ];

/// 是否按时（1按时,2推迟）
Property PDOnTime As %String [ SqlColumnNumber = 7, SqlFieldName = PD_OnTime ];

/// 推迟原因
Property PDDelayReason As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PD_DelayReason ];

/// 推迟到哪天
Property PDToDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PD_ToDate ];

/// 身高
Property PDHeight As %String [ SqlColumnNumber = 10, SqlFieldName = PD_Height ];

/// 体重
Property PDWeight As %String [ SqlColumnNumber = 11, SqlFieldName = PD_Weight ];

/// 体温
Property PDTemperature As %String [ SqlColumnNumber = 12, SqlFieldName = PD_Temperature ];

/// 血压
Property PDBlood As %String [ SqlColumnNumber = 13, SqlFieldName = PD_Blood ];

/// 脉搏
Property PDPulse As %String [ SqlColumnNumber = 14, SqlFieldName = PD_Pulse ];

/// 血氧
Property PDOxygen As %String [ SqlColumnNumber = 15, SqlFieldName = PD_Oxygen ];

/// ECOG得分
Property PDECOG As %String [ SqlColumnNumber = 16, SqlFieldName = PD_ECOG ];

/// 口腔粘膜炎评分
Property PDKQScore As %String [ SqlColumnNumber = 17, SqlFieldName = PD_KQScore ];

/// 数据来源
Property PDDataSR As %String [ SqlColumnNumber = 18, SqlFieldName = PD_DataSR ];

/// BSA
Property PDBSA As %String [ SqlColumnNumber = 19, SqlFieldName = PD_BSA ];

/// GFR
Property PDGFR As %String [ SqlColumnNumber = 20, SqlFieldName = PD_GFR ];

/// 血清肌酸酐
Property PDSC As %String [ SqlColumnNumber = 21, SqlFieldName = PD_SC ];

/// 过敏史记录
Property PDGMiSFill As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PD_GMiSFill ];

/// 检验检查备注
Property PDExamNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PD_ExamNote ];

/// 状态(N,A,Y,S,C,U,R：初始,未完成,已审核,中止,作废,完成,拒绝)
Property PDStatus As %String [ SqlColumnNumber = 24, SqlFieldName = PD_Status ];

/// 最后更新日期
Property PDUpdateDate As %Date [ SqlColumnNumber = 25, SqlFieldName = PD_UpdateDate ];

/// 最后更新时间
Property PDUpdateTime As %Time [ SqlColumnNumber = 26, SqlFieldName = PD_UpdateTime ];

/// 最后更新人
Property PDUpdateUser As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = PD_UpdateUser ];

/// 最后更新科室
Property PDUpdateLoc As User.CTLoc [ SqlColumnNumber = 28, SqlFieldName = PD_UpdateLoc ];

/// 预估时长
Property PDPlanTime As %String [ SqlColumnNumber = 29, SqlFieldName = PD_PlanTime ];

/// 要求审核医生
Property PDNeedUser As User.SSUser [ SqlColumnNumber = 30, SqlFieldName = PD_NeedUser ];

/// 要求审核科室
Property PDNeedLoc As User.CTLoc [ SqlColumnNumber = 31, SqlFieldName = PD_NeedLoc ];

/// 备注
Property PDNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = PD_Note ];

/// 关联日期(无用)
Property PDLinkDate As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = PD_LinkDate ];

/// 有无过敏史(1/0)
Property PDHasGMis As %String [ SqlColumnNumber = 34, SqlFieldName = PD_HasGMis ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##class(DHCDoc.Chemo.BS.DateStatus).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(DHCDoc.Chemo.BS.DateStatus).OnTrigger($g(%d(1)),"TAfterUpd")
}

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PD_AdmDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PD_BSA">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PD_Blood">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PD_DataSR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PD_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PD_DelayReason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PD_ECOG">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PD_ExamNote">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PD_GFR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PD_GMiSFill">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PD_HasGMis">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PD_Height">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PD_KQScore">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PD_LinkDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PD_NeedLoc">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PD_NeedUser">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PD_Note">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PD_OnTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PD_Oxygen">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PD_PLID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PD_PSID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PD_PatientDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PD_PlanTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PD_Pulse">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PD_SC">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PD_Status">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PD_Temperature">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PD_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PD_UpdateLoc">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PD_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PD_Weight">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanDateD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PD_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAadmDate">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AadmDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PD_AdmDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxAdm">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PD_AdmDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxDate">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PD_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPSID">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PSID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PD_PSID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPatient">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Patient"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PD_PatientDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PD_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanDateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

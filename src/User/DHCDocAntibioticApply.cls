/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 抗菌药物申请记录表
/// NOTE: 启用新的基础数据配置表 DHCAnt_Base.PurposeDataConfig
/// 			AAUseReasonDR：User.DHCCTAntUseReason 改成：%Library.String类型
/// 	  	AAApplyStatus:去掉了其限制条件 (DISPLAYLIST = ",Apply,Audit,Suspend,Refuse,Emergency,Other", MAXLEN = 7, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",A,U,S,R,E,O")
Class User.DHCDocAntibioticApply Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AA_Rowid, SqlTableName = DHC_Doc_AntibioticApply, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PA_Adm
Property AAAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = AA_Adm_DR ];

/// ARC_ItmMast
Property AAArcimDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = AA_Arcim_DR ];

/// OEC_Priority
Property AAPriorDR As User.OECPriority [ SqlColumnNumber = 4, SqlFieldName = AA_Prior_DR ];

/// AA_DoseQty
Property AADoseQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = AA_DoseQty ];

/// CT_Uom
Property AADoseUomDR As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = AA_DoseUom_DR ];

/// PHC_Freq
Property AAFreqDR As User.PHCFreq [ SqlColumnNumber = 7, SqlFieldName = AA_Freq_DR ];

/// PHC_Duration
Property AADurDR As User.PHCDuration [ SqlColumnNumber = 8, SqlFieldName = AA_Dur_DR ];

/// PHC_Instruc
Property AAInstrDR As User.PHCInstruc [ SqlColumnNumber = 9, SqlFieldName = AA_Instr_DR ];

/// SS_User
Property AAApplyUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = AA_ApplyUser_DR ];

/// AA_ApplyDate
Property AAApplyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = AA_ApplyDate ];

/// AA_ApplyTime
Property AAApplyTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = AA_ApplyTime ];

/// AA_ApplyStatus
Property AAApplyStatus As %Library.String [ SqlColumnNumber = 13, SqlFieldName = AA_ApplyStatus ];

/// AA_ApplyRemark
Property AAApplyRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AA_ApplyRemark ];

/// AA_EndDate
Property AAEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = AA_EndDate ];

/// AA_EndTime
Property AAEndTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = AA_EndTime ];

/// AA_UseReason_DR
Property AAUseReasonDR As %Library.String [ SqlColumnNumber = 17, SqlFieldName = AA_UseReason_DR ];

/// AA_MicrobeSpecFlag
Property AAMicrobeSpecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = AA_MicrobeSpecFlag ];

/// AA_DrugTestFlag
Property AADrugTestFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = AA_DrugTestFlag ];

/// AA_ConsultationDep_DR
Property AAConsultationDepDR As User.CTLoc [ SqlColumnNumber = 20, SqlFieldName = AA_ConsultationDep_DR ];

/// AA_ConsultationDoc_DR 医护人员表ID
Property AAConsultationDocDR As User.CTCareProv [ SqlColumnNumber = 21, SqlFieldName = AA_ConsultationDoc_DR ];

/// AA_OEORI_DR
Property AAOEORIDR As User.OEOrdItem [ SqlColumnNumber = 22, SqlFieldName = AA_OEORI_DR ];

/// AA_UserAdd_DR
Property AAUserAddDR As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = AA_UserAdd_DR ];

/// AA_DateAdd
Property AADateAdd As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = AA_DateAdd ];

/// AA_TimeAdd
Property AATimeAdd As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = AA_TimeAdd ];

/// AA_AuditUser_DR
Property AAAuditUserDR As User.SSUser [ SqlColumnNumber = 26, SqlFieldName = AA_AuditUser_DR ];

/// AA_AuditDate
Property AAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = AA_AuditDate ];

/// AA_AuditTime
Property AAAuditTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = AA_AuditTime ];

/// AA_AuditRemark
Property AAAuditRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AA_AuditRemark ];

/// AA_LastUpdateUser
Property AALastUpdateUser As User.SSUser [ SqlColumnNumber = 30, SqlFieldName = AA_LastUpdateUser ];

/// AA_LastUpdateDate
Property AALastUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = AA_LastUpdateDate ];

/// AA_LastUpdateTime
Property AALastUpdateTime As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = AA_LastUpdateTime ];

/// AA_Note
Property AAApplyTypeControl As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = AA_ApplyTypeControl ];

/// AA_Note1
Property AANote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = AA_Note1 ];

/// AA_Suscept_DR 药敏结果
Property AASusceptDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = AA_Suscept_DR ];

/// AA_Purpose_DR 使用目的ID
Property AAPurposeDR As User.DHCAntUsePurpose [ SqlColumnNumber = 36, SqlFieldName = AA_Purpose_DR ];

/// AA_OrderDays  预计疗程天数
Property AAOrderDays As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = AA_OrderDays ];

/// AA_DHCConsult_DR  指向会诊表User.DHCConsultation 
Property AADHCConsultDR As User.DHCConsultation [ SqlColumnNumber = 38, SqlFieldName = AA_DHCConsult_DR ];

/// AA_isEmergency 临时医嘱是否紧急使用
Property AAisEmergency As %Library.Boolean [ SqlColumnNumber = 39, SqlFieldName = AA_isEmergency ];

/// AA_StDate   申请开始日期
Property AAStDate As %Library.Date [ SqlColumnNumber = 40, SqlFieldName = AA_StDate ];

/// AA_Loc_DR  申请科室
Property AALocDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = AA_Loc_DR ];

/// AA_DHCConsultTwo_DR  第二个会诊表id
Property AADHCConsultTwoDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = AA_DHCConsultTwo_DR ];

/// AA_ConsultationDepTwo  第二个会诊科室
Property AAConsultationDepTwo As %String(TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = AA_ConsultationDepTwo ];

/// AA_ConsultationDocTwo  第二个会诊医生
Property AAConsultationDocTwo As %String(TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = AA_ConsultationDocTwo ];

/// AA_DHCConsultThree_DR  第三个会诊表id
Property AADHCConsultThreeDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = AA_DHCConsultThree_DR ];

/// AA_ConsultationDepThree  第三个会诊科室
Property AAConsultationDepThree As %String(TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = AA_ConsultationDepThree ];

/// AA_ConsultationDocThree  第三个会诊医生
Property AAConsultationDocThree As %String(TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = AA_ConsultationDocThree ];

/// AA_EmergecyReason  越级原因
Property AAEmergecyReason As %String(MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = AA_EmergecyReason ];

/// AA_ProcessType  流程类型
Property AAProcessType As %String(TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = AA_ProcessType ];

/// AA_DefaultDepFlag  默认会诊科室标志
Property AADefaultDepFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = AA_DefaultDepFlag ];

/// AA_ConsultationDepNums  会诊科室个数
Property AAConsultationDepNums As %String(TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = AA_ConsultationDepNums ];

/// AA_Process  当前流程
Property AAProcess As %String(TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = AA_Process ];

/// AA_LastAuditUser  最终审核科室
Property AALastAuditUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = AA_LastAuditUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDAA("ANT"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AA_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AA_ApplyDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AA_ApplyRemark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AA_ApplyStatus">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AA_ApplyTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AA_ApplyTypeControl">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="AA_ApplyUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AA_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AA_AuditDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="AA_AuditRemark">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="AA_AuditTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="AA_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="AA_ConsultationDepNums">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>35</Piece>
</Data>
<Data name="AA_ConsultationDepThree">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>30</Piece>
</Data>
<Data name="AA_ConsultationDepTwo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>27</Piece>
</Data>
<Data name="AA_ConsultationDep_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="AA_ConsultationDocThree">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>31</Piece>
</Data>
<Data name="AA_ConsultationDocTwo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>28</Piece>
</Data>
<Data name="AA_ConsultationDoc_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="AA_DHCConsultThree_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>29</Piece>
</Data>
<Data name="AA_DHCConsultTwo_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>26</Piece>
</Data>
<Data name="AA_DHCConsult_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="AA_DateAdd">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="AA_DefaultDepFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>34</Piece>
</Data>
<Data name="AA_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AA_DoseUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AA_DrugTestFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="AA_Dur_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AA_EmergecyReason">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>32</Piece>
</Data>
<Data name="AA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AA_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AA_Instr_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AA_LastAuditUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>37</Piece>
</Data>
<Data name="AA_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="AA_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="AA_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="AA_Loc_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>25</Piece>
</Data>
<Data name="AA_MicrobeSpecFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="AA_Note1">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="AA_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="AA_OrderDays">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="AA_Prior_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AA_Process">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>36</Piece>
</Data>
<Data name="AA_ProcessType">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>33</Piece>
</Data>
<Data name="AA_Purpose_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="AA_StDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="AA_Suscept_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="AA_TimeAdd">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="AA_UseReason_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="AA_UserAdd_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="AA_isEmergency">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Global>^DHCDAA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ANT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDR">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AA_Adm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApplyDate">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ApplyDate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_ApplyDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApplyUser">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ApplyUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AA_ApplyUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_AuditDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsDepDoc">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ConsDepDoc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_ConsultationDep_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AA_ConsultationDoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsult">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Consult"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AA_DHCConsult_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsultThree">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Consult"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AA_DHCConsultThree_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsultTwo">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Consult"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AA_DHCConsultTwo_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsultation">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Cons"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_ConsultationDep_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEndDate">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_EndDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCDAAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_OEORI_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocAntibioticApplyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

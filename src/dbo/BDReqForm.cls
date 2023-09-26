/// BDReqForm
Class dbo.BDReqForm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqForm, StorageStrategy = Default ]
{

Index IndexEpisodeNo On (WorkGroupDR, ReceiveDate, EpisodeNo) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexAgreeFormNo On AgreeFormNo [ SqlName = Index_AgreeFormNo, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexMedicalRecordNo On MedicalRecordNo [ SqlName = Index_MedicalRecordNo, Type = index ];

Index IndexOpsCode On OpsCode [ SqlName = Index_OpsCode, Type = index ];

Index IndexReceiveDate On ReceiveDate [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexReceiveUserDR On (ReceiveUserDR, ReceiveDate) [ SqlName = Index_ReceiveUserDR, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexReqFormNo On ReqFormNo [ SqlName = Index_ReqFormNo, Type = index, Unique ];

Index IndexReqType On (ReqTypeDR, CheckDate) [ SqlName = Index_ReqType, Type = index ];

Index IndexSampleNo On SampleNo [ SqlName = Index_SampleNo, Type = index ];

Index IndexUseSampleNo On UseSampleNo [ SqlName = Index_UseSampleNo, Type = index ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexWorkGroupDR On (WorkGroupDR, ReceiveDate) [ SqlName = Index_WorkGroupDR, Type = index ];

Index IndexBookCollDate On BookCollDate [ SqlName = Index_BookCollDate, Type = index ];

Index IndexCarryDate On CarryDate [ SqlName = Index_CarryDate, Type = index ];

Index IndexBookDate On BookDate [ SqlName = Index_BookDate, Type = index ];

Index IndexReqAssessNo On ReqAssessNo [ SqlName = Index_ReqAssessNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDREQFORM On RowID [ PrimaryKey, SqlName = PK_BD_REQFORM, Type = index, Unique ];

/// Foreign Key FKBDReqABO created via DDL
ForeignKey FKBDReqABO(ABODR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_BD_Req_ABO ];

/// Foreign Key FKBDReqAddUser created via DDL
ForeignKey FKBDReqAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_AddUser ];

/// Foreign Key FKBDReqAgeUnit created via DDL
ForeignKey FKBDReqAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_BD_Req_AgeUnit ];

/// Foreign Key FKBDReqCertType created via DDL
ForeignKey FKBDReqCertType(CertTypeDR) References dbo.BTCertType(PKBTCERTTYPE) [ SqlName = FK_BD_Req_CertType ];

/// Foreign Key FKBDReqCheckUser created via DDL
ForeignKey FKBDReqCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_CheckUser ];

/// Foreign Key FKBDReqCheckUser created via DDL
ForeignKey FKBDAutologousAss(AutologousAssDR) References dbo.BDAutologousAss(PKBDAutologousAss) [ SqlName = FK_BD_AutologousAss ];

// ForeignKey FKBDReqEthnicity(EthnicityDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_BD_Req_Ethnicity ];

/// Foreign Key FKBDReqEthnicity created via DDL
/// Foreign Key FKBDReqKeestBloodGroup created via DDL
ForeignKey FKBDReqKeestBloodGroup(KeestBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_Req_KeestBloodGroup ];

/// Foreign Key FKBDReqLocation created via DDL
ForeignKey FKBDReqLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_Req_Location ];

/// Foreign Key FKBDReqOrganBloodGroup created via DDL
ForeignKey FKBDReqOrganBloodGroup(OrganBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_Req_OrganBloodGroup ];

/// Foreign Key FKBDReqRH created via DDL
ForeignKey FKBDReqRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_BD_Req_RH ];

/// Foreign Key FKBDReqReceiveUser created via DDL
ForeignKey FKBDReqReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_ReceiveUser ];

/// Foreign Key FKBDReqReqType created via DDL
ForeignKey FKBDReqReqType(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BD_Req_ReqType ];

/// Foreign Key FKBDReqSendUser created via DDL
ForeignKey FKBDReqSendUser(SendUserDR) References dbo.BTDoctor(PKBTDOCTOR) [ SqlName = FK_BD_Req_SendUser ];

/// Foreign Key FKBDReqSignUser created via DDL
ForeignKey FKBDReqSignUser(SignUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_SignUser ];

/// Foreign Key FKBDReqSpecies created via DDL
ForeignKey FKBDReqSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_BD_Req_Species ];

/// Foreign Key FKBDReqWard created via DDL
ForeignKey FKBDReqWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_Req_Ward ];

/// Foreign Key FKBDReqWorkGroup created via DDL
ForeignKey FKBDReqWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_Req_WorkGroup ];

/// Foreign Key FKBDReqSignUser created via DDL
ForeignKey FKBDReqCarryUser(CarryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_CarryUser ];

ForeignKey FKBDReqCollUser(BookCollUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_CollUser ];

ForeignKey FKBDReqDeptCheckUser(DeptCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_DeptCheckUser ];

ForeignKey FKBDReqHeadCheckUser(HeadCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_HeadCheckUser ];

/// dbo.BBDefectType 
ForeignKey FKBDReqBBDefectType(DefectTypeDR) References dbo.BBDefectType(PKBBDEFECTTYPE) [ SqlName = FK_BD_Req_BBDefectType ];

ForeignKey FKBDApprovalList(ApprovalListDR) References dbo.BDApprovalList(PKBDAPPROVALLIST) [ SqlName = FK_BD_Req_ApprovalList ];

ForeignKey FKPaymentType(PaymentTypeDR) References dbo.BTPaymentType(PKBTPAYMENTTYPE) [ SqlName = FK_Payment_Type ];

ForeignKey FKBDReqUrgency(UrgencyDR) References dbo.BBUrgency(PKBBURGENCY) [ SqlName = FK_BD_Req_Urgency ];

ForeignKey FKBDReqSuperiorUser(SuperiorUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Req_SuperiorUser ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单号  
Property ReqFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 申请单类型  
Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 创建人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 病案号  
Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 姓名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 年龄(无单位)  
Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 年龄单位  
Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 证件类型  
Property CertTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 证件号  
Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 身份证号  
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 18) [ SqlColumnNumber = 18 ];

/// ABO血型  
Property ABODR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// RH血型  
Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 稀有血型  
Property RareBloodGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

/// 民族  
Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 22 ];

/// 归属地  
Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 病区  
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 床号  
Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

/// 诊断  
Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 27 ];

/// 是否有输血史  {1:true,0:false}
Property IsTransHistory As %Library.Boolean [ SqlColumnNumber = 28 ];

/// 最近输血日期  
Property LastTransDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 是否有不良反应  {1:true,0:false}
Property IsUntowardEffect As %Library.Boolean [ SqlColumnNumber = 30 ];

/// 不良反应说明  
Property UntowardEffectNote As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 31 ];

/// 是否有器官移植  {1:true,0:false}
Property IsOrganExplant As %Library.Boolean [ SqlColumnNumber = 32 ];

/// 器官供者血型  
Property OrganBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 是否骨髓移植  {1:true,0:false}
Property IsKeestExplant As %Library.Boolean [ SqlColumnNumber = 34 ];

/// 骨髓供者血型  
Property KeestBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 是否使用特殊药物  {1:true,0:false}
Property IsDrugHistory As %Library.Boolean [ SqlColumnNumber = 36 ];

/// 特殊药物  
Property DrugList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 37 ];

/// 是否有孕产史  
Property IsPregHistory As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 38 ];

/// 孕次  
Property Pregnancies As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 39 ];

/// 产次  
Property ChildBirths As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

/// 预计输血日期  
Property BookDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

/// 心功能评估  
Property AssHeart As %Library.SmallInt [ SqlColumnNumber = 42 ];

/// 肝功能评估  
Property AssLiver As %Library.SmallInt [ SqlColumnNumber = 43 ];

/// 肾功能评估  
Property AssKidney As %Library.SmallInt [ SqlColumnNumber = 44 ];

/// 肺功能评估  
Property AssLung As %Library.SmallInt [ SqlColumnNumber = 45 ];

/// 高血压评估  
Property AssHypertensive As %Library.SmallInt [ SqlColumnNumber = 46 ];

/// 标本号  
Property SampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 47 ];

/// 使用标本号  
Property UseSampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 48 ];

/// 知情同意单号  
Property AgreeFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 49 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 50 ];

/// 是否超量  
Property IsExcess As %Library.SmallInt [ SqlColumnNumber = 51 ];

/// 状态  
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 52 ];

/// 就诊类型  
Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 53 ];

/// 手术名称  
Property OpsName As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 54 ];

/// 手术代码  
Property OpsCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 55 ];

/// 是否同行  {1:true,0:false}
Property IsSame As %Library.Boolean [ SqlColumnNumber = 56 ];

/// 申请单送达日期  
Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 57 ];

/// 申请单送达时间  
Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 58 ];

/// 申请单送达人  
Property SendUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 59 ];

/// SignDate  
Property SignDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 60 ];

/// SignTime  
Property SignTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 61 ];

/// SignUserDR  
Property SignUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 62 ];

/// 审核说明  
Property CheckCause As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 63 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 64 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 65 ];

/// 审核人  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 66 ];

/// 是否打印  {1:true,0:false}
Property IsPrinted As %Library.Boolean [ SqlColumnNumber = 67 ];

/// 是否成功发送  {1:true,0:false}
Property IsSended As %Library.Boolean [ SqlColumnNumber = 68 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

/// 接收时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 70 ];

/// 接收人  
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 71 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 72 ];

/// 是否合格  {1:true,0:false}
Property IsQualified As %Library.Boolean [ SqlColumnNumber = 73 ];

/// 评估内容  
Property EvaluateText As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 74 ];

/// 体重  
Property Weight As %Library.Float [ SqlColumnNumber = 75 ];

/// 身高  
Property Height As %Library.Float [ SqlColumnNumber = 76 ];

/// 血压  
Property BldPressure As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 77 ];

/// 脉搏(次/分钟)  
Property Pulse As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 78 ];

/// 体温(℃)  
Property BodyTemp As %Library.Float [ SqlColumnNumber = 79 ];

/// 手术日期  
Property OpsDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 80 ];

/// 预定采血日期  
Property BookCollDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 81 ];

/// 用血时间  
Property BookTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 82 ];

/// 手术时间  
Property OpsTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 83 ];

/// 预定采血时间  
Property BookCollTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 84 ];

/// 预定采血量  
Property BookCollVolume As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 85 ];

/// 年龄(有单位)  
Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 86 ];

/// 一定用  {1:true,0:false}
Property IsDefinitelyUse As %Library.Boolean [ SqlColumnNumber = 87 ];

/// 医保类型  
Property MedicalInsuranceType As %Library.SmallInt [ SqlColumnNumber = 88 ];

/// 医保类型  
Property TISMedicalInsuranceType As %Library.SmallInt [ SqlColumnNumber = 89 ];

/// 运送日期  
Property CarryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 90 ];

/// 运送时间  
Property CarryTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 91 ];

/// 运送人  
Property CarryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 92 ];

/// IsIntraoperative  
Property IsIntraoperative As %Library.SmallInt [ SqlColumnNumber = 93 ];

/// 预定采集类型  
Property BookColectType As %Library.SmallInt [ SqlColumnNumber = 94 ];

///       
Property IsBldTransTaboo As %Library.Boolean [ SqlColumnNumber = 95 ];

///       
Property AutologousAssDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 96 ];

/// 身体状态  
Property BodyStatus As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 97 ];

/// 预计失血量  
Property EstimatedBldLoss As %Library.Float [ SqlColumnNumber = 98 ];

/// 输血科评估  
Property TisAssessment As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 99 ];

/// 输血科意见  
Property TisOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 3000) [ SqlColumnNumber = 100 ];

/// 预定采集者  
Property BookCollUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 101 ];

/// 预定采集地点  
Property BookCollectPlace As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 102 ];

/// ReqAdmNo  
Property ReqAdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 103 ];

/// 科室电话  
Property LocationTel As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 104 ];

/// 输血科审核日期  
Property DeptCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 105 ];

/// 输血科审核时间  
Property DeptCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 106 ];

/// 输血科审核人  
Property DeptCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 107 ];

/// 输血科审核说明  
Property DeptCheckRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 108 ];

/// 科主任审核日期  
Property HeadCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 109 ];

/// 科主任审核时间  
Property HeadCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 110 ];

/// 科主任审核用户  
Property HeadCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 111 ];

/// 科主任审核说明  
Property HeadCheckRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 112 ];

/// 流水号  
Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 113 ];

/// OpaId  
Property OpaId As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 114 ];

/// IsNormalECG  {1:true,0:false}
Property IsNormalECG As %Library.Boolean [ SqlColumnNumber = 115 ];

/// SubjectRuleDesc  
Property SubjectRuleDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 116 ];

/// 出生日期  
Property BirthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 117 ];

/// 出生时间  
Property BirthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 118 ];

/// 拒收类型  
Property DefectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 119 ];

/// 评估单号  
Property ReqAssessNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 120 ];

/// 审批单  
Property ApprovalListDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 121 ];

/// 支付类型  
Property PaymentTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 122 ];

/// 锁定  {1:true,0:false}
Property IsLocked As %Library.Boolean [ SqlColumnNumber = 123 ];

Property IsDrugAllergy As %Library.Boolean [ SqlColumnNumber = 124 ];

Property AllergDrug As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 125 ];

/// 用血概率
Property PredictUse As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 126 ];

/// 估计出血量
Property PredictOut As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 127 ];

/// 是否需要单独采集标本 0手工指定 1自动获取
Property NewSample As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 128 ];

/// 血型结果来源 0手工登记 1 自动获取
Property BGSource As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 129 ];

/// 输血紧急程度
Property UrgencyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 130 ];

/// 上级医师审核日期
Property SuperiorDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 131 ];

/// 上级医师审核时间
Property SuperiorTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 132 ];

/// 上级医师
Property SuperiorUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 133 ];

Storage Default
{
<Data name="BDReqFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormNo</Value>
</Value>
<Value name="3">
<Value>ReqTypeDR</Value>
</Value>
<Value name="4">
<Value>AdmNo</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>RegNo</Value>
</Value>
<Value name="9">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="10">
<Value>SurName</Value>
</Value>
<Value name="11">
<Value>GivenName</Value>
</Value>
<Value name="12">
<Value>SpeciesDR</Value>
</Value>
<Value name="13">
<Value>Age</Value>
</Value>
<Value name="14">
<Value>AgeUnitDR</Value>
</Value>
<Value name="15">
<Value>CertTypeDR</Value>
</Value>
<Value name="16">
<Value>CertNo</Value>
</Value>
<Value name="17">
<Value>IDNumber</Value>
</Value>
<Value name="18">
<Value>ABODR</Value>
</Value>
<Value name="19">
<Value>RHDR</Value>
</Value>
<Value name="20">
<Value>RareBloodGroup</Value>
</Value>
<Value name="21">
<Value>Ethnicity</Value>
</Value>
<Value name="22">
<Value>NativePlace</Value>
</Value>
<Value name="23">
<Value>LocationDR</Value>
</Value>
<Value name="24">
<Value>WardDR</Value>
</Value>
<Value name="25">
<Value>BedNo</Value>
</Value>
<Value name="26">
<Value>Diagnosis</Value>
</Value>
<Value name="27">
<Value>IsTransHistory</Value>
</Value>
<Value name="28">
<Value>LastTransDate</Value>
</Value>
<Value name="29">
<Value>IsUntowardEffect</Value>
</Value>
<Value name="30">
<Value>UntowardEffectNote</Value>
</Value>
<Value name="31">
<Value>IsOrganExplant</Value>
</Value>
<Value name="32">
<Value>OrganBloodGroupDR</Value>
</Value>
<Value name="33">
<Value>IsKeestExplant</Value>
</Value>
<Value name="34">
<Value>KeestBloodGroupDR</Value>
</Value>
<Value name="35">
<Value>IsDrugHistory</Value>
</Value>
<Value name="36">
<Value>DrugList</Value>
</Value>
<Value name="37">
<Value>IsPregHistory</Value>
</Value>
<Value name="38">
<Value>Pregnancies</Value>
</Value>
<Value name="39">
<Value>ChildBirths</Value>
</Value>
<Value name="40">
<Value>BookDate</Value>
</Value>
<Value name="41">
<Value>AssHeart</Value>
</Value>
<Value name="42">
<Value>AssLiver</Value>
</Value>
<Value name="43">
<Value>AssKidney</Value>
</Value>
<Value name="44">
<Value>AssLung</Value>
</Value>
<Value name="45">
<Value>AssHypertensive</Value>
</Value>
<Value name="46">
<Value>SampleNo</Value>
</Value>
<Value name="47">
<Value>UseSampleNo</Value>
</Value>
<Value name="48">
<Value>AgreeFormNo</Value>
</Value>
<Value name="49">
<Value>Remark</Value>
</Value>
<Value name="50">
<Value>IsExcess</Value>
</Value>
<Value name="51">
<Value>Status</Value>
</Value>
<Value name="52">
<Value>AdmType</Value>
</Value>
<Value name="53">
<Value>OpsName</Value>
</Value>
<Value name="54">
<Value>OpsCode</Value>
</Value>
<Value name="55">
<Value>IsSame</Value>
</Value>
<Value name="56">
<Value>SendDate</Value>
</Value>
<Value name="57">
<Value>SendTime</Value>
</Value>
<Value name="58">
<Value>SendUserDR</Value>
</Value>
<Value name="59">
<Value>SignDate</Value>
</Value>
<Value name="60">
<Value>SignTime</Value>
</Value>
<Value name="61">
<Value>SignUserDR</Value>
</Value>
<Value name="62">
<Value>CheckCause</Value>
</Value>
<Value name="63">
<Value>CheckDate</Value>
</Value>
<Value name="64">
<Value>CheckTime</Value>
</Value>
<Value name="65">
<Value>CheckUserDR</Value>
</Value>
<Value name="66">
<Value>IsPrinted</Value>
</Value>
<Value name="67">
<Value>IsSended</Value>
</Value>
<Value name="68">
<Value>ReceiveDate</Value>
</Value>
<Value name="69">
<Value>ReceiveTime</Value>
</Value>
<Value name="70">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="71">
<Value>WorkGroupDR</Value>
</Value>
<Value name="72">
<Value>IsQualified</Value>
</Value>
<Value name="73">
<Value>EvaluateText</Value>
</Value>
<Value name="74">
<Value>Weight</Value>
</Value>
<Value name="75">
<Value>Height</Value>
</Value>
<Value name="76">
<Value>BldPressure</Value>
</Value>
<Value name="77">
<Value>Pulse</Value>
</Value>
<Value name="78">
<Value>BodyTemp</Value>
</Value>
<Value name="79">
<Value>OpsDate</Value>
</Value>
<Value name="80">
<Value>BookCollDate</Value>
</Value>
<Value name="81">
<Value>BookTime</Value>
</Value>
<Value name="82">
<Value>OpsTime</Value>
</Value>
<Value name="83">
<Value>BookCollTime</Value>
</Value>
<Value name="84">
<Value>BookCollVolume</Value>
</Value>
<Value name="85">
<Value>AgeDesc</Value>
</Value>
<Value name="86">
<Value>IsDefinitelyUse</Value>
</Value>
<Value name="87">
<Value>MedicalInsuranceType</Value>
</Value>
<Value name="88">
<Value>TISMedicalInsuranceType</Value>
</Value>
<Value name="89">
<Value>CarryDate</Value>
</Value>
<Value name="90">
<Value>CarryTime</Value>
</Value>
<Value name="91">
<Value>CarryUserDR</Value>
</Value>
<Value name="92">
<Value>IsIntraoperative</Value>
</Value>
<Value name="93">
<Value>BookColectType</Value>
</Value>
<Value name="94">
<Value>IsBldTransTaboo</Value>
</Value>
<Value name="95">
<Value>AutologousAssDR</Value>
</Value>
<Value name="96">
<Value>BodyStatus</Value>
</Value>
<Value name="97">
<Value>EstimatedBldLoss</Value>
</Value>
<Value name="98">
<Value>TisAssessment</Value>
</Value>
<Value name="99">
<Value>TisOpinion</Value>
</Value>
<Value name="100">
<Value>BookCollUserDR</Value>
</Value>
<Value name="101">
<Value>BookCollectPlace</Value>
</Value>
<Value name="102">
<Value>ReqAdmNo</Value>
</Value>
<Value name="103">
<Value>LocationTel</Value>
</Value>
<Value name="104">
<Value>DeptCheckDate</Value>
</Value>
<Value name="105">
<Value>DeptCheckTime</Value>
</Value>
<Value name="106">
<Value>DeptCheckUserDR</Value>
</Value>
<Value name="107">
<Value>DeptCheckRemark</Value>
</Value>
<Value name="108">
<Value>HeadCheckDate</Value>
</Value>
<Value name="109">
<Value>HeadCheckTime</Value>
</Value>
<Value name="110">
<Value>HeadCheckUserDR</Value>
</Value>
<Value name="111">
<Value>HeadCheckRemark</Value>
</Value>
<Value name="112">
<Value>EpisodeNo</Value>
</Value>
<Value name="113">
<Value>OpaId</Value>
</Value>
<Value name="114">
<Value>IsNormalECG</Value>
</Value>
<Value name="115">
<Value>SubjectRuleDesc</Value>
</Value>
<Value name="116">
<Value>BirthDate</Value>
</Value>
<Value name="117">
<Value>BirthTime</Value>
</Value>
<Value name="118">
<Value>DefectTypeDR</Value>
</Value>
<Value name="119">
<Value>ReqAssessNo</Value>
</Value>
<Value name="120">
<Value>ApprovalListDR</Value>
</Value>
<Value name="121">
<Value>PaymentTypeDR</Value>
</Value>
<Value name="122">
<Value>IsLocked</Value>
</Value>
<Value name="123">
<Value>IsDrugAllergy</Value>
</Value>
<Value name="124">
<Value>AllergDrug</Value>
</Value>
<Value name="125">
<Value>PredictUse</Value>
</Value>
<Value name="126">
<Value>PredictOut</Value>
</Value>
<Value name="127">
<Value>NewSample</Value>
</Value>
<Value name="128">
<Value>BGSource</Value>
</Value>
<Value name="129">
<Value>UrgencyDR</Value>
</Value>
<Value name="130">
<Value>SuperiorDate</Value>
</Value>
<Value name="131">
<Value>SuperiorTime</Value>
</Value>
<Value name="132">
<Value>SuperiorUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormD</DataLocation>
<DefaultData>BDReqFormDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormD</IdLocation>
<IndexLocation>^dbo.BDReqFormI</IndexLocation>
<StreamLocation>^dbo.BDReqFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

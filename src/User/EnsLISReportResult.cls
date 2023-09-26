/// 检验报告结果表
Class User.EnsLISReportResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = Ens_LISReportResult ]
{

/// DDL Primary Key Specification
Index LISREPORTRESULTPKey On LISRRReportID [ PrimaryKey, Type = index, Unique ];

Index LISRRPatientIDIndex On (LISRRPatientID, LISRRCheckDate, LISRRCheckTime) [ Type = index ];

Index LISRRUpdateTimeIndex On (LISRRUpdateDate, LISRRUpdateTime);

Index LISRRCheckDateTimeIndex On (LISRRHosCode, LISRRCheckDate, LISRRCheckTime);

Index LISRRVisitNumberIndex On LISRRVisitNumber [ Type = index ];

/// 报告ID
Property LISRRReportID As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ InitialExpression = {$I(^Busi.ENS.EnsLISReportResultC)}, Required, SqlColumnNumber = 2, SqlFieldName = LISRR_ReportID ];

/// 患者ID
Property LISRRPatientID As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = LISRR_PatientID ];

/// 就诊类型
Property LISRREncounterTypeCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 4, SqlFieldName = LISRR_EncounterTypeCode ];

/// 就诊号码
Property LISRRVisitNumber As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = LISRR_VisitNumber ];

/// 就诊病案号
Property LISRRDocumentNO As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 6, SqlFieldName = LISRR_DocumentNO ];

/// 就诊日期
Property LISRRAdmDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = LISRR_AdmDate ];

/// 就诊时间
Property LISRRAdmTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = LISRR_AdmTime ];

/// 证件类型(名称)
Property LISRRCertType As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 9, SqlFieldName = LISRR_CertType ];

/// 证件号
Property LISRRCertNo As %Library.String(COLLATION = "EXACT", MAXLEN = 18) [ SqlColumnNumber = 10, SqlFieldName = LISRR_CertNo ];

/// 身份证号
Property LISRRIDNumber As %Library.String(COLLATION = "EXACT", MAXLEN = 18) [ SqlColumnNumber = 11, SqlFieldName = LISRR_IDNumber ];

/// 支付类型(名称)
Property LISRRPaymentType As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 12, SqlFieldName = LISRR_PaymentType ];

/// 姓名
Property LISRRPatientName As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 13, SqlFieldName = LISRR_PatientName ];

/// 性别(男、女、未知性别、未说明性别)
Property LISRRSex As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 14, SqlFieldName = LISRR_Sex ];

/// 出生日期
Property LISRRDOB As %Library.Date [ SqlColumnNumber = 15, SqlFieldName = LISRR_DOB ];

/// 年龄
Property LISRRAge As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ SqlColumnNumber = 16, SqlFieldName = LISRR_Age ];

/// 年龄单位
Property LISRRAgeUnit As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 17, SqlFieldName = LISRR_AgeUnit ];

/// 民族
Property LISRRNation As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 18, SqlFieldName = LISRR_Nation ];

/// 申请医院
Property LISRRHospital As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = LISRR_Hospital ];

/// 申请科室代码
Property LISRRDeptCode As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ SqlColumnNumber = 20, SqlFieldName = LISRR_DeptCode ];

/// 申请科室名称
Property LISRRDeptName As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 21, SqlFieldName = LISRR_DeptName ];

/// 申请日期
Property LISRRRequestDate As %Library.Date [ SqlColumnNumber = 22, SqlFieldName = LISRR_RequestDate ];

/// 申请时间
Property LISRRRequestTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = LISRR_RequestTime ];

/// 病区代码
Property LISRRWardCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 24, SqlFieldName = LISRR_WardCode ];

/// 病区名称
Property LISRRWardName As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 25, SqlFieldName = LISRR_WardName ];

/// 床号
Property LISRRBedNo As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 26, SqlFieldName = LISRR_BedNo ];

/// 临床症状
Property LISRRSymptom As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 27, SqlFieldName = LISRR_Symptom ];

/// 手机号
Property LISRRMobileNo As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ SqlColumnNumber = 28, SqlFieldName = LISRR_MobileNo ];

/// 座机号
Property LISRRPhoneNo As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ SqlColumnNumber = 29, SqlFieldName = LISRR_PhoneNo ];

/// 邮箱
Property LISRREmail As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ SqlColumnNumber = 30, SqlFieldName = LISRR_Email ];

/// 身高
Property LISRRHeight As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 31, SqlFieldName = LISRR_Height ];

/// 体重
Property LISRRWeight As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 32, SqlFieldName = LISRR_Weight ];

/// 血压
Property LISRRBloodPressure As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 33, SqlFieldName = LISRR_BloodPressure ];

/// 生理条件
Property LISRRClinicalConditions As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 34, SqlFieldName = LISRR_ClinicalConditions ];

/// 是否怀孕
Property LISRRPregnant As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 35, SqlFieldName = LISRR_Pregnant ];

/// 怀孕周数
Property LISRRPregnantWeeks As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 36, SqlFieldName = LISRR_PregnantWeeks ];

/// ABO血型(A、B、O、AB)
Property LISRRABO As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 37, SqlFieldName = LISRR_ABO ];

/// RH血型(阴性、阳性)
Property LISRRRH As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 38, SqlFieldName = LISRR_RH ];

/// 地址
Property LISRRAddress As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 39, SqlFieldName = LISRR_Address ];

/// 传染标志
Property LISRRInfectFlag As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 40, SqlFieldName = LISRR_InfectFlag ];

/// 院感标志
Property LISRRInfectAlert As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 41, SqlFieldName = LISRR_InfectAlert ];

/// 特殊标本标志
Property LISRRSpecialFlag As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 42, SqlFieldName = LISRR_SpecialFlag ];

/// 孕次
Property LISRRPregnantNum As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 43, SqlFieldName = LISRR_PregnantNum ];

/// 产次
Property LISRRChildbirthNum As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 44, SqlFieldName = LISRR_ChildbirthNum ];

/// 申请备注
Property LISRRReqNotes As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 45, SqlFieldName = LISRR_ReqNotes ];

/// 申请单号
Property LISRRRequestNo As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 46, SqlFieldName = LISRR_RequestNo ];

/// 是否加急
Property LISRRUrgent As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 47, SqlFieldName = LISRR_Urgent ];

/// 采集日期
Property LISRRCollectDate As %Library.Date [ SqlColumnNumber = 48, SqlFieldName = LISRR_CollectDate ];

/// 采集时间
Property LISRRCollectTime As %Library.Time [ SqlColumnNumber = 49, SqlFieldName = LISRR_CollectTime ];

/// 采集者代码
Property LISRRCollectUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 50, SqlFieldName = LISRR_CollectUserCode ];

/// 采集者描述
Property LISRRCollectUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 51, SqlFieldName = LISRR_CollectUserDesc ];

/// 采集部位代码
Property LISRRCollectPositionCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 52, SqlFieldName = LISRR_CollectPositionCode ];

/// 采集部位名称
Property LISRRCollectPosition As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 53, SqlFieldName = LISRR_CollectPosition ];

/// 采集容器代码
Property LISRRContainerCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 54, SqlFieldName = LISRR_ContainerCode ];

/// 采集容器名称
Property LISRRContainer As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 55, SqlFieldName = LISRR_Container ];

/// 采集说明
Property LISRRCollectNotes As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 56, SqlFieldName = LISRR_CollectNotes ];

/// 24小时尿量
Property LISRRH24Volume As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 57, SqlFieldName = LISRR_H24Volume ];

/// 24小时尿量时间段
Property LISRRH24UTimePeriod As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 58, SqlFieldName = LISRR_H24UTimePeriod ];

/// 采集时体温
Property LISRRBodyTemp As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 59, SqlFieldName = LISRR_BodyTemp ];

/// 是否保密
Property LISRRConfidential As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 60, SqlFieldName = LISRR_Confidential ];

/// 运送日期
Property LISRRCarryDate As %Library.Date [ SqlColumnNumber = 61, SqlFieldName = LISRR_CarryDate ];

/// 运送时间
Property LISRRCarryTime As %Library.Time [ SqlColumnNumber = 62, SqlFieldName = LISRR_CarryTime ];

/// 运送者代码
Property LISRRCarryUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 63, SqlFieldName = LISRR_CarryUserCode ];

/// 运送者描述
Property LISRRCarryUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 64, SqlFieldName = LISRR_CarryUserDesc ];

/// 接收日期
Property LISRRReceiveDate As %Library.Date [ SqlColumnNumber = 65, SqlFieldName = LISRR_ReceiveDate ];

/// 接收时间
Property LISRRReceiveTime As %Library.Time [ SqlColumnNumber = 66, SqlFieldName = LISRR_ReceiveTime ];

/// 接收者代码
Property LISRRReceiveUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 67, SqlFieldName = LISRR_ReceiveUserCode ];

/// 接收者描述
Property LISRRReceiveUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 68, SqlFieldName = LISRR_ReceiveUserDesc ];

/// 接收时标本质量
Property LISRRSpecimenQuality As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 69, SqlFieldName = LISRR_SpecimenQuality ];

/// 接收说明
Property LISRRReceiveNotes As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 70, SqlFieldName = LISRR_ReceiveNotes ];

/// 入库日期
Property LISRRInStorageDate As %Library.Date [ SqlColumnNumber = 71, SqlFieldName = LISRR_InStorageDate ];

/// 入库时间
Property LISRRInStorageTime As %Library.Time [ SqlColumnNumber = 72, SqlFieldName = LISRR_InStorageTime ];

/// 入库者代码
Property LISRRInStorageUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 73, SqlFieldName = LISRR_InStorageUserCode ];

/// 入库者描述
Property LISRRInStorageUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 74, SqlFieldName = LISRR_InStorageUserDesc ];

/// 出库日期
Property LISRROutStorageDate As %Library.Date [ SqlColumnNumber = 75, SqlFieldName = LISRR_OutStorageDate ];

/// 出库时间
Property LISRROutStorageTime As %Library.Time [ SqlColumnNumber = 76, SqlFieldName = LISRR_OutStorageTime ];

/// 出库者代码
Property LISRROutStorageUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 77, SqlFieldName = LISRR_OutStorageUserCode ];

/// 出库者描述
Property LISRROutStorageUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 78, SqlFieldName = LISRR_OutStorageUserDesc ];

/// 出库类型
Property LISRROutStorageType As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 79, SqlFieldName = LISRR_OutStorageType ];

/// 创建日期
Property LISRRAddDate As %Library.Date [ SqlColumnNumber = 80, SqlFieldName = LISRR_AddDate ];

/// 创建时间
Property LISRRAddTime As %Library.Time [ SqlColumnNumber = 81, SqlFieldName = LISRR_AddTime ];

/// 创建者代码
Property LISRRAddUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 82, SqlFieldName = LISRR_AddUserCode ];

/// 创建者描述
Property LISRRAddUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 83, SqlFieldName = LISRR_AddUserDesc ];

/// 创建类型
Property LISRRAddType As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 84, SqlFieldName = LISRR_AddType ];

/// 送达日期
Property LISRRArriveDate As %Library.Date [ SqlColumnNumber = 85, SqlFieldName = LISRR_ArriveDate ];

/// 送达时间
Property LISRRArriveTime As %Library.Time [ SqlColumnNumber = 86, SqlFieldName = LISRR_ArriveTime ];

/// 送达者代码
Property LISRRArriveUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 87, SqlFieldName = LISRR_ArriveUserCode ];

/// 送达者描述
Property LISRRArriveUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 88, SqlFieldName = LISRR_ArriveUserDesc ];

/// 送达位置
Property LISRRArriveWorkGroup As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 89, SqlFieldName = LISRR_ArriveWorkGroup ];

/// 上机日期
Property LISRRMachineDate As %Library.Date [ SqlColumnNumber = 90, SqlFieldName = LISRR_MachineDate ];

/// 上机时间
Property LISRRMachineTime As %Library.Time [ SqlColumnNumber = 91, SqlFieldName = LISRR_MachineTime ];

/// 检测日期
Property LISRRTestDate As %Library.Date [ SqlColumnNumber = 92, SqlFieldName = LISRR_TestDate ];

/// 检测时间
Property LISRRTestTime As %Library.Time [ SqlColumnNumber = 93, SqlFieldName = LISRR_TestTime ];

/// 作废日期
Property LISRRCancelDate As %Library.Date [ SqlColumnNumber = 94, SqlFieldName = LISRR_CancelDate ];

/// 作废时间
Property LISRRCancelTime As %Library.Time [ SqlColumnNumber = 95, SqlFieldName = LISRR_CancelTime ];

/// 作废者代码
Property LISRRCancelUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 96, SqlFieldName = LISRR_CancelUserCode ];

/// 作废者描述
Property LISRRCancelUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 97, SqlFieldName = LISRR_CancelUserDesc ];

/// 作废原因
Property LISRRCancelReason As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 98, SqlFieldName = LISRR_CancelReason ];

/// 报告内容Xml
Property LISRRReprotXml As %Library.GlobalCharacterStream [ SqlColumnNumber = 99, SqlFieldName = LISRR_ReprotXml ];

/// 报告内容Pdf
Property LISRRReprotPdf As %Library.GlobalCharacterStream [ SqlColumnNumber = 100, SqlFieldName = LISRR_ReprotPdf ];

/// 报告类型（1普通，2危急，0其他）
Property LISRRReprotType As %Library.String(COLLATION = "EXACT", MAXLEN = 4) [ SqlColumnNumber = 101, SqlFieldName = LISRR_ReprotType ];

/// 备注
Property LISRRRemarks As %Library.String(COLLATION = "EXACT", MAXLEN = 512) [ SqlColumnNumber = 102, SqlFieldName = LISRR_Remarks ];

/// 是否微生物报告 1:微生物报告; 2:普通报告
Property LISRRISMcroorganism As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 103, SqlFieldName = LISRR_ISMcroorganism ];

/// 时间戳日期
Property LISRRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 104, SqlFieldName = LISRR_UpdateDate ];

/// 时间戳时间
Property LISRRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 105, SqlFieldName = LISRR_UpdateTime ];

/// 鉴定结果
Property LISRRIdentifition As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 106, SqlFieldName = LISRR_Identifition ];

/// 审核日期
Property LISRRCheckDate As %Library.Date [ Required, SqlColumnNumber = 107, SqlFieldName = LISRR_CheckDate ];

/// 审核时间
Property LISRRCheckTime As %Library.Time [ Required, SqlColumnNumber = 108, SqlFieldName = LISRR_CheckTime ];

/// 审核医生代码
Property LISRRCheckUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 109, SqlFieldName = LISRR_CheckUserCode ];

/// 审核医生描述
Property LISRRCheckUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 110, SqlFieldName = LISRR_CheckUserDesc ];

/// 初审日期
Property LISRRFirstCheckDate As %Library.Date [ SqlColumnNumber = 111, SqlFieldName = LISRR_FirstCheckDate ];

/// 初审时间
Property LISRRFirstCheckTime As %Library.Time [ SqlColumnNumber = 112, SqlFieldName = LISRR_FirstCheckTime ];

/// 初审医生代码
Property LISRRFirstCheckUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 113, SqlFieldName = LISRR_FirstCheckUserCode ];

/// 初审医生描述
Property LISRRFirstCheckUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 114, SqlFieldName = LISRR_FirstCheckUserDesc ];

/// 医嘱描述(针对于没有项目代码，只有项目名称的情况)
Property LISRROrderItemDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 115, SqlFieldName = LISRR_OrderItemDesc ];

/// 异常标识代码
Property LISRRWarnCode As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 116, SqlFieldName = LISRR_WarnCode ];

/// 报告状态（1审核，2取消审核，3作废）
Property LISRRStatus As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 117, SqlFieldName = LISRR_Status ];

/// 审核方式（1手工，2自动）
Property LISRRAuthType As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 118, SqlFieldName = LISRR_AuthType ];

/// 传输日期
Property LISRRTransmitDate As %Library.Date [ SqlColumnNumber = 119, SqlFieldName = LISRR_TransmitDate ];

/// 工作小组代码
Property LISRRWorkGroupCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 120, SqlFieldName = LISRR_WorkGroupCode ];

/// 工作小组名称
Property LISRRWorkGroupDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 121, SqlFieldName = LISRR_WorkGroupDesc ];

/// 标本报告序号
Property LISRROrder As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 122, SqlFieldName = LISRR_Order ];

/// 标本代码
Property LISRRSpecimenID As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 123, SqlFieldName = LISRR_SpecimenID ];

/// 细菌鉴定号
Property LISRRAccessionNo As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 124, SqlFieldName = LISRR_AccessionNo ];

/// 核收日期
Property LISRRAcceptDate As %Library.Date [ SqlColumnNumber = 125, SqlFieldName = LISRR_AcceptDate ];

/// 核收时间
Property LISRRAcceptTime As %Library.Time [ SqlColumnNumber = 126, SqlFieldName = LISRR_AcceptTime ];

/// 核收者代码
Property LISRRAcceptUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 127, SqlFieldName = LISRR_AcceptUserCode ];

/// 核收者姓名
Property LISRRAcceptUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 128, SqlFieldName = LISRR_AcceptUserDesc ];

/// 重审日期
Property LISRRReCheckDate As %Library.Date [ SqlColumnNumber = 129, SqlFieldName = LISRR_ReCheckDate ];

/// 重审时间
Property LISRRReCheckTime As %Library.Time [ SqlColumnNumber = 130, SqlFieldName = LISRR_ReCheckTime ];

/// 重审者代码
Property LISRRReCheckUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 131, SqlFieldName = LISRR_ReCheckUserCode ];

/// 重审者姓名
Property LISRRReCheckUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 132, SqlFieldName = LISRR_ReCheckUserDesc ];

/// 是否自动审核（1:是；2：否）
Property LISRRAutoCheck As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 133, SqlFieldName = LISRR_AutoCheck ];

/// 是否数字签名
Property LISRRDigitSign As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 134, SqlFieldName = LISRR_DigitSign ];

/// 签名字符串
Property LISRRDigitSignString As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 135, SqlFieldName = LISRR_DigitSignString ];

/// 签名时间戳
Property LISRRDigitSignTime As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 136, SqlFieldName = LISRR_DigitSignTime ];

/// 是否打印（1:是；2：否）
Property LISRRPrinted As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 137, SqlFieldName = LISRR_Printed ];

/// 是否阅读
Property LISRRReaded As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 138, SqlFieldName = LISRR_Readed ];

/// 首次阅读日期
Property LISRRFirstReadDate As %Library.Date [ SqlColumnNumber = 139, SqlFieldName = LISRR_FirstReadDate ];

/// 首次阅读时间
Property LISRRFirstReadTime As %Library.Time [ SqlColumnNumber = 140, SqlFieldName = LISRR_FirstReadTime ];

/// 首次阅读医生代码
Property LISRRFirstReadUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 141, SqlFieldName = LISRR_FirstReadUserCode ];

/// 首次阅读医生姓名
Property LISRRFirstReadUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 142, SqlFieldName = LISRR_FirstReadUserDesc ];

/// 报告主评价
Property LISRRMainConclusion As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 143, SqlFieldName = LISRR_MainConclusion ];

/// 报告次评价
Property LISRRMinorConclusion As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 144, SqlFieldName = LISRR_MinorConclusion ];

/// 复查号
Property LISRRReAssayNumber As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 145, SqlFieldName = LISRR_ReAssayNumber ];

/// 院区代码
Property LISRRHosCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 146, SqlFieldName = LISRR_HosCode ];

/// 标本名称
Property LISRRSpecimenDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 147, SqlFieldName = LISRR_SpecimenDesc ];

/// 院区名称
Property LISRRHosName As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 148, SqlFieldName = LISRR_HosName ];

/// 手工计费的医嘱rowid串
Property LISRRManualOrdItemList As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 149, SqlFieldName = LISRR_ManualOrdItemList ];

/// 标本评价
Property LISRRSpecConc As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 150, SqlFieldName = LISRR_SpecConc ];

Storage Default
{
<Data name="EnsLISReportResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LISRRReportID</Value>
</Value>
<Value name="3">
<Value>LISRRPatientID</Value>
</Value>
<Value name="4">
<Value>LISRREncounterTypeCode</Value>
</Value>
<Value name="5">
<Value>LISRRVisitNumber</Value>
</Value>
<Value name="6">
<Value>LISRRDocumentNO</Value>
</Value>
<Value name="7">
<Value>LISRRAdmDate</Value>
</Value>
<Value name="8">
<Value>LISRRAdmTime</Value>
</Value>
<Value name="9">
<Value>LISRRCertType</Value>
</Value>
<Value name="10">
<Value>LISRRCertNo</Value>
</Value>
<Value name="11">
<Value>LISRRIDNumber</Value>
</Value>
<Value name="12">
<Value>LISRRPaymentType</Value>
</Value>
<Value name="13">
<Value>LISRRPatientName</Value>
</Value>
<Value name="14">
<Value>LISRRSex</Value>
</Value>
<Value name="15">
<Value>LISRRDOB</Value>
</Value>
<Value name="16">
<Value>LISRRAge</Value>
</Value>
<Value name="17">
<Value>LISRRAgeUnit</Value>
</Value>
<Value name="18">
<Value>LISRRNation</Value>
</Value>
<Value name="19">
<Value>LISRRHospital</Value>
</Value>
<Value name="20">
<Value>LISRRDeptCode</Value>
</Value>
<Value name="21">
<Value>LISRRDeptName</Value>
</Value>
<Value name="22">
<Value>LISRRRequestDate</Value>
</Value>
<Value name="23">
<Value>LISRRRequestTime</Value>
</Value>
<Value name="24">
<Value>LISRRWardCode</Value>
</Value>
<Value name="25">
<Value>LISRRWardName</Value>
</Value>
<Value name="26">
<Value>LISRRBedNo</Value>
</Value>
<Value name="27">
<Value>LISRRSymptom</Value>
</Value>
<Value name="28">
<Value>LISRRMobileNo</Value>
</Value>
<Value name="29">
<Value>LISRRPhoneNo</Value>
</Value>
<Value name="30">
<Value>LISRREmail</Value>
</Value>
<Value name="31">
<Value>LISRRHeight</Value>
</Value>
<Value name="32">
<Value>LISRRWeight</Value>
</Value>
<Value name="33">
<Value>LISRRBloodPressure</Value>
</Value>
<Value name="34">
<Value>LISRRClinicalConditions</Value>
</Value>
<Value name="35">
<Value>LISRRPregnant</Value>
</Value>
<Value name="36">
<Value>LISRRPregnantWeeks</Value>
</Value>
<Value name="37">
<Value>LISRRABO</Value>
</Value>
<Value name="38">
<Value>LISRRRH</Value>
</Value>
<Value name="39">
<Value>LISRRAddress</Value>
</Value>
<Value name="40">
<Value>LISRRInfectFlag</Value>
</Value>
<Value name="41">
<Value>LISRRInfectAlert</Value>
</Value>
<Value name="42">
<Value>LISRRSpecialFlag</Value>
</Value>
<Value name="43">
<Value>LISRRPregnantNum</Value>
</Value>
<Value name="44">
<Value>LISRRChildbirthNum</Value>
</Value>
<Value name="45">
<Value>LISRRReqNotes</Value>
</Value>
<Value name="46">
<Value>LISRRRequestNo</Value>
</Value>
<Value name="47">
<Value>LISRRUrgent</Value>
</Value>
<Value name="48">
<Value>LISRRCollectDate</Value>
</Value>
<Value name="49">
<Value>LISRRCollectTime</Value>
</Value>
<Value name="50">
<Value>LISRRCollectUserCode</Value>
</Value>
<Value name="51">
<Value>LISRRCollectUserDesc</Value>
</Value>
<Value name="52">
<Value>LISRRCollectPositionCode</Value>
</Value>
<Value name="53">
<Value>LISRRCollectPosition</Value>
</Value>
<Value name="54">
<Value>LISRRContainerCode</Value>
</Value>
<Value name="55">
<Value>LISRRContainer</Value>
</Value>
<Value name="56">
<Value>LISRRCollectNotes</Value>
</Value>
<Value name="57">
<Value>LISRRH24Volume</Value>
</Value>
<Value name="58">
<Value>LISRRH24UTimePeriod</Value>
</Value>
<Value name="59">
<Value>LISRRBodyTemp</Value>
</Value>
<Value name="60">
<Value>LISRRConfidential</Value>
</Value>
<Value name="61">
<Value>LISRRCarryDate</Value>
</Value>
<Value name="62">
<Value>LISRRCarryTime</Value>
</Value>
<Value name="63">
<Value>LISRRCarryUserCode</Value>
</Value>
<Value name="64">
<Value>LISRRCarryUserDesc</Value>
</Value>
<Value name="65">
<Value>LISRRReceiveDate</Value>
</Value>
<Value name="66">
<Value>LISRRReceiveTime</Value>
</Value>
<Value name="67">
<Value>LISRRReceiveUserCode</Value>
</Value>
<Value name="68">
<Value>LISRRReceiveUserDesc</Value>
</Value>
<Value name="69">
<Value>LISRRSpecimenQuality</Value>
</Value>
<Value name="70">
<Value>LISRRReceiveNotes</Value>
</Value>
<Value name="71">
<Value>LISRRInStorageDate</Value>
</Value>
<Value name="72">
<Value>LISRRInStorageTime</Value>
</Value>
<Value name="73">
<Value>LISRRInStorageUserCode</Value>
</Value>
<Value name="74">
<Value>LISRRInStorageUserDesc</Value>
</Value>
<Value name="75">
<Value>LISRROutStorageDate</Value>
</Value>
<Value name="76">
<Value>LISRROutStorageTime</Value>
</Value>
<Value name="77">
<Value>LISRROutStorageUserCode</Value>
</Value>
<Value name="78">
<Value>LISRROutStorageUserDesc</Value>
</Value>
<Value name="79">
<Value>LISRROutStorageType</Value>
</Value>
<Value name="80">
<Value>LISRRAddDate</Value>
</Value>
<Value name="81">
<Value>LISRRAddTime</Value>
</Value>
<Value name="82">
<Value>LISRRAddUserCode</Value>
</Value>
<Value name="83">
<Value>LISRRAddUserDesc</Value>
</Value>
<Value name="84">
<Value>LISRRAddType</Value>
</Value>
<Value name="85">
<Value>LISRRArriveDate</Value>
</Value>
<Value name="86">
<Value>LISRRArriveTime</Value>
</Value>
<Value name="87">
<Value>LISRRArriveUserCode</Value>
</Value>
<Value name="88">
<Value>LISRRArriveUserDesc</Value>
</Value>
<Value name="89">
<Value>LISRRArriveWorkGroup</Value>
</Value>
<Value name="90">
<Value>LISRRMachineDate</Value>
</Value>
<Value name="91">
<Value>LISRRMachineTime</Value>
</Value>
<Value name="92">
<Value>LISRRTestDate</Value>
</Value>
<Value name="93">
<Value>LISRRTestTime</Value>
</Value>
<Value name="94">
<Value>LISRRCancelDate</Value>
</Value>
<Value name="95">
<Value>LISRRCancelTime</Value>
</Value>
<Value name="96">
<Value>LISRRCancelUserCode</Value>
</Value>
<Value name="97">
<Value>LISRRCancelUserDesc</Value>
</Value>
<Value name="98">
<Value>LISRRCancelReason</Value>
</Value>
<Value name="99">
<Value>LISRRReprotXml</Value>
</Value>
<Value name="100">
<Value>LISRRReprotPdf</Value>
</Value>
<Value name="101">
<Value>LISRRReprotType</Value>
</Value>
<Value name="102">
<Value>LISRRRemarks</Value>
</Value>
<Value name="103">
<Value>LISRRISMcroorganism</Value>
</Value>
<Value name="104">
<Value>LISRRUpdateDate</Value>
</Value>
<Value name="105">
<Value>LISRRUpdateTime</Value>
</Value>
<Value name="106">
<Value>LISRRIdentifition</Value>
</Value>
<Value name="107">
<Value>LISRRCheckDate</Value>
</Value>
<Value name="108">
<Value>LISRRCheckTime</Value>
</Value>
<Value name="109">
<Value>LISRRCheckUserCode</Value>
</Value>
<Value name="110">
<Value>LISRRCheckUserDesc</Value>
</Value>
<Value name="111">
<Value>LISRRFirstCheckDate</Value>
</Value>
<Value name="112">
<Value>LISRRFirstCheckTime</Value>
</Value>
<Value name="113">
<Value>LISRRFirstCheckUserCode</Value>
</Value>
<Value name="114">
<Value>LISRRFirstCheckUserDesc</Value>
</Value>
<Value name="115">
<Value>LISRROrderItemDesc</Value>
</Value>
<Value name="116">
<Value>LISRRWarnCode</Value>
</Value>
<Value name="117">
<Value>LISRRStatus</Value>
</Value>
<Value name="118">
<Value>LISRRAuthType</Value>
</Value>
<Value name="119">
<Value>LISRRTransmitDate</Value>
</Value>
<Value name="120">
<Value>LISRRWorkGroupCode</Value>
</Value>
<Value name="121">
<Value>LISRRWorkGroupDesc</Value>
</Value>
<Value name="122">
<Value>LISRROrder</Value>
</Value>
<Value name="123">
<Value>LISRRSpecimenID</Value>
</Value>
<Value name="124">
<Value>LISRRAccessionNo</Value>
</Value>
<Value name="125">
<Value>LISRRAcceptDate</Value>
</Value>
<Value name="126">
<Value>LISRRAcceptTime</Value>
</Value>
<Value name="127">
<Value>LISRRAcceptUserCode</Value>
</Value>
<Value name="128">
<Value>LISRRAcceptUserDesc</Value>
</Value>
<Value name="129">
<Value>LISRRReCheckDate</Value>
</Value>
<Value name="130">
<Value>LISRRReCheckTime</Value>
</Value>
<Value name="131">
<Value>LISRRReCheckUserCode</Value>
</Value>
<Value name="132">
<Value>LISRRReCheckUserDesc</Value>
</Value>
<Value name="133">
<Value>LISRRAutoCheck</Value>
</Value>
<Value name="134">
<Value>LISRRDigitSign</Value>
</Value>
<Value name="135">
<Value>LISRRDigitSignString</Value>
</Value>
<Value name="136">
<Value>LISRRDigitSignTime</Value>
</Value>
<Value name="137">
<Value>LISRRPrinted</Value>
</Value>
<Value name="138">
<Value>LISRRReaded</Value>
</Value>
<Value name="139">
<Value>LISRRFirstReadDate</Value>
</Value>
<Value name="140">
<Value>LISRRFirstReadTime</Value>
</Value>
<Value name="141">
<Value>LISRRFirstReadUserCode</Value>
</Value>
<Value name="142">
<Value>LISRRFirstReadUserDesc</Value>
</Value>
<Value name="143">
<Value>LISRRMainConclusion</Value>
</Value>
<Value name="144">
<Value>LISRRMinorConclusion</Value>
</Value>
<Value name="145">
<Value>LISRRReAssayNumber</Value>
</Value>
<Value name="146">
<Value>LISRRHosCode</Value>
</Value>
<Value name="147">
<Value>LISRRSpecimenDesc</Value>
</Value>
<Value name="148">
<Value>LISRRHosName</Value>
</Value>
<Value name="149">
<Value>LISRRManualOrdItemList</Value>
</Value>
<Value name="150">
<Value>LISRRSpecConc</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsLISReportResultD</DataLocation>
<DefaultData>EnsLISReportResultDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsLISReportResultD</IdLocation>
<IndexLocation>^Busi.ENS.EnsLISReportResultI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsLISReportResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

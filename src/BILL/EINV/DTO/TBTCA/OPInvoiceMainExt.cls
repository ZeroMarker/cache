Class BILL.EINV.DTO.TBTCA.OPInvoiceMainExt Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 医疗类别
Property MedicalType As %String(XMLPROJECTION = "ELEMENT");

/// 门诊号???
Property PatientNumber As %String(XMLPROJECTION = "ELEMENT");

/// 医疗机构类型
Property OrgType As %String(XMLPROJECTION = "ELEMENT");

/// 医保类型
Property MedicalInsuranceType As %String(XMLPROJECTION = "ELEMENT");

/// 医保编号
Property MedicalInsuranceID As %String(XMLPROJECTION = "ELEMENT");

/// 医保统筹基金支付
Property FundPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// 其他支付
Property OtherPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// 个人账户支付
Property AccountPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// 个人现金支付
Property OwnPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// 个人自付
Property SelfpaymentAmount As %String(XMLPROJECTION = "ELEMENT");

/// 病历号
Property CaseNumber As %String(XMLPROJECTION = "ELEMENT");

/// 预交金额
Property PrepaidAmount As %String(XMLPROJECTION = "ELEMENT");

/// 补缴金额
Property RechargeAmount As %String(XMLPROJECTION = "ELEMENT");

/// 退费金额
Property RefundAmount As %String(XMLPROJECTION = "ELEMENT");

/// 性别
Property Gender As %String(XMLPROJECTION = "ELEMENT");

/// 年龄
Property Age As %String(XMLPROJECTION = "ELEMENT");

/// 缴款码
Property PayCode As %String(XMLPROJECTION = "ELEMENT");

/// 医保结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

/// 就诊科室???
Property VisitDeptName As %String(XMLPROJECTION = "ELEMENT");

/// 就诊科室编码
Property VisitDeptCode As %String(XMLPROJECTION = "ELEMENT");

/// 医保待遇状态
Property InsuranceStatus As %String(XMLPROJECTION = "ELEMENT");

/// 医疗账户支付
Property MedicalAccountPayment As %String(XMLPROJECTION = "ELEMENT");

/// 健康账户支付
Property HealthAccountPay As %String(XMLPROJECTION = "ELEMENT");

/// 共济账户支付
Property MasonicAccountPay As %String(XMLPROJECTION = "ELEMENT");

/// 医疗账户余额
Property MedicalAccountBalance As %String(XMLPROJECTION = "ELEMENT");

/// 健康账户余额
Property HealthAccountBalance As %String(XMLPROJECTION = "ELEMENT");

/// 门诊慢( 特 殊 )病种名称	???
Property SpecialDiseasesName As %String(XMLPROJECTION = "ELEMENT");

/// 医疗救助
Property MedicalAssistance As %String(XMLPROJECTION = "ELEMENT");

/// 大病保险
Property IllnessInsure As %String(XMLPROJECTION = "ELEMENT");

/// 保健基金
Property HealthCareFund As %String(XMLPROJECTION = "ELEMENT");

/// 公务员补助
Property CivilServantSubsidy As %String(XMLPROJECTION = "ELEMENT");

/// 减：医院减免
Property HospitalRelief As %String(XMLPROJECTION = "ELEMENT");

/// 应退款???
Property RefundableAmount As %String(XMLPROJECTION = "ELEMENT");

/// 超封顶线费用
Property OverCapPay As %String(XMLPROJECTION = "ELEMENT");

/// 预交金余额???
Property PrepaidBalance As %String(XMLPROJECTION = "ELEMENT");

/// 本月就诊次数???
Property TimesOfMonth As %String(XMLPROJECTION = "ELEMENT");

/// 就诊日期???
Property MedicalDate As %String(XMLPROJECTION = "ELEMENT");

/// 家庭共济账户余额
Property FamilyMasonicAccountBalance As %String(XMLPROJECTION = "ELEMENT");

/// 先行自付
Property PreSelfPay As %String(XMLPROJECTION = "ELEMENT");

/// 个人自费
Property SelfpaymentCost As %String(XMLPROJECTION = "ELEMENT");

/// 数据来源
Property UploadSource As %String(XMLPROJECTION = "ELEMENT");

/// 交款人手机号
Property PayerPhoneNo As %String(XMLPROJECTION = "ELEMENT");

/// 就诊类型
Property VisitType As %String(XMLPROJECTION = "ELEMENT");

/// 结算号
Property SettlementNo As %String(XMLPROJECTION = "ELEMENT");

/// 医疗机构编码（社会信用代码）
Property SocialCreditCode As %String(XMLPROJECTION = "ELEMENT");

/// 病人身份证号码
Property IDCardNo As %String(XMLPROJECTION = "ELEMENT");

/// 病人姓名
Property SickName As %String(XMLPROJECTION = "ELEMENT");

/// 社会保障号码
Property SocialSecurityNumber As %String(XMLPROJECTION = "ELEMENT");

/// 开票点编码
Property PlaceCode As %String(XMLPROJECTION = "ELEMENT");

/// 社保卡号
Property SocialSecurityCardNo As %String(XMLPROJECTION = "ELEMENT");

/// 工伤支付
Property WorkInjuredPay As %String(XMLPROJECTION = "ELEMENT");

/// 起付标准
Property SPStand As %String(XMLPROJECTION = "ELEMENT");

/// 乙类首自付
Property BSelfpayment As %String(XMLPROJECTION = "ELEMENT");

/// 按比例自付
Property PTNSelfpayment As %String(XMLPROJECTION = "ELEMENT");

/// 师职补助
Property TeacherSubsidy As %String(XMLPROJECTION = "ELEMENT");

/// 产前检查费
Property AntenatalClinic As %String(XMLPROJECTION = "ELEMENT");

/// 大病补充报销
Property LSubsidiaryInsuranceReimbursement As %String(XMLPROJECTION = "ELEMENT");

Property DiseaseDetails As BILL.EINV.DTO.TBTCA.DiseaseDetails(XMLPROJECTION = "ELEMENT");

Property TreatmentDevice As BILL.EINV.DTO.TBTCA.TreatmentDevice(XMLPROJECTION = "ELEMENT");

/// 就诊病情
/// 大型医疗甲乙类设备使用情况
/// 交款人扩展信息
Property PayerPartyExt As BILL.EINV.DTO.TBTCA.PayerPartyExt;

}

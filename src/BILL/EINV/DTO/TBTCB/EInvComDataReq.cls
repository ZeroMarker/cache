/// 杭州未来科技电子发票开票接口参数
Class BILL.EINV.DTO.TBTCB.EInvComDataReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

/// Zid	自增id 号	Number	16	是
Property Zid As %String(XMLPROJECTION = "ELEMENT");

/// Organ	机构代码	Varchar	4	是
Property Organ As %String(XMLPROJECTION = "ELEMENT");

/// SettlementNo	结算号	Varchar	32	是
Property SettlementNo As %String(XMLPROJECTION = "ELEMENT");

/// SettlementTime	结算时间	Varchar	14	是
Property SettlementTime As %String(XMLPROJECTION = "ELEMENT");

/// Sjlx	票据类型	Varchar	2	是
Property Sjlx As %String(XMLPROJECTION = "ELEMENT");

/// UploadSource	上传来源	Varchar	2	是
Property UploadSource As %String(XMLPROJECTION = "ELEMENT");

/// RandomNumber	校验码	Varchar	6	是
Property RandomNumber As %String(XMLPROJECTION = "ELEMENT");

/// VisitType	就诊类型	Varchar	2	是
Property VisitType As %String(XMLPROJECTION = "ELEMENT");

/// Sickid	病人信息ID	Varchar	32	是
Property Sickid As %String(XMLPROJECTION = "ELEMENT");

/// Sfz	身份证号	Varchar	18	
Property Sfz As %String(XMLPROJECTION = "ELEMENT");

/// Ybk	医保卡号	Varchar	50	能 同
Property Ybk As %String(XMLPROJECTION = "ELEMENT");

/// Jkk	健康卡号	Varchar	50	
Property Jkk As %String(XMLPROJECTION = "ELEMENT");

/// Jzk	就诊卡号	Varchar	50
Property Jzk As %String(XMLPROJECTION = "ELEMENT");

/// Hzh	护照号	varchar	50	
Property Hzh As %String(XMLPROJECTION = "ELEMENT");

/// Txz	港澳通行证	varchar	50	
Property Txz As %String(XMLPROJECTION = "ELEMENT");

/// ZdyCardNo1	自定义卡号 1	Varchar	50	
Property ZdyCardNo1 As %String(XMLPROJECTION = "ELEMENT");

/// ZdyCardNo2	自定义卡号 2	Varchar	50
Property ZdyCardNo2 As %String(XMLPROJECTION = "ELEMENT");

/// CardRemark	卡信息备注	Varchar	100	
Property CardRemark As %String(XMLPROJECTION = "ELEMENT");

/// MedicalInstitutionCode	社会信用代码	Varchar	20	
Property MedicalInstitutionCode As %String(XMLPROJECTION = "ELEMENT");

/// yljgbm	医疗机构编码	Varchar	30	是	
Property yljgbm As %String(XMLPROJECTION = "ELEMENT");

/// MedicalInstitutionType	医疗机构类型	Varchar	20	是	
Property MedicalInstitutionType As %String(XMLPROJECTION = "ELEMENT");

/// SiteName	站点名称	Varchar	100		
Property SiteName As %String(XMLPROJECTION = "ELEMENT");

/// VisitingDepartment	就诊科室	Varchar	20
Property VisitingDepartment As %String(XMLPROJECTION = "ELEMENT");

/// CaseNumber	病历号	Varchar	20	是	
Property CaseNumber As %String(XMLPROJECTION = "ELEMENT");

/// HospitalizationNo	住院号,门诊号	Varchar	20	是	
Property HospitalizationNo As %String(XMLPROJECTION = "ELEMENT");

/// SickName	就诊人姓名	Varchar	200	是	
Property SickName As %String(XMLPROJECTION = "ELEMENT");

/// Gender	性别	Varchar	10	是
Property Gender As %String(XMLPROJECTION = "ELEMENT");

/// MedicalInsuranceType	医保类型	Varchar	30	是	
Property MedicalInsuranceType As %String(XMLPROJECTION = "ELEMENT");

/// SocialSecurityNumber	社会保障号码	Varchar	50	是	
Property SocialSecurityNumber As %String(XMLPROJECTION = "ELEMENT");

/// Headcust	头部自定义域	Varchar	100	
Property Headcust As %String(XMLPROJECTION = "ELEMENT");

/// Bodycust	主体自定义域	Varchar	100	
Property Bodycust As %String(XMLPROJECTION = "ELEMENT");

/// CollectionUnit	收款单位	Varchar	100	是
Property CollectionUnit As %String(XMLPROJECTION = "ELEMENT");

/// RecName	收款人	Varchar	50	是
Property RecName As %String(XMLPROJECTION = "ELEMENT");

/// Pblx	票版类型	varchar	1	是
Property Pblx As %String(XMLPROJECTION = "ELEMENT");

/// SYBXR1	本次赔付金额	Number	16,2
Property SYBXR1 As %String(XMLPROJECTION = "ELEMENT");

/// SYBXN1	起付标准累计额	Number	16,2
Property SYBXN1 As %String(XMLPROJECTION = "ELEMENT");

/// SYBXN2					累计金额	Number	16,2
Property SYBXN2 As %String(XMLPROJECTION = "ELEMENT");

/// SYBXR2	本次赔付金额	Number	16,2
Property SYBXR2 As %String(XMLPROJECTION = "ELEMENT");

/// SYBXN3				起付标准累计额	Number	16,2
Property SYBXN3 As %String(XMLPROJECTION = "ELEMENT");

/// SYBXN4	累计金额	Number	16,2
Property SYBXN4 As %String(XMLPROJECTION = "ELEMENT");

/// PayerPartyType	交款人类型	Varchar	1	是
Property PayerPartyType As %String(XMLPROJECTION = "ELEMENT");

/// PayerPartyCode	交款人代码	Varchar	30	是
Property PayerPartyCode As %String(XMLPROJECTION = "ELEMENT");

/// Age	年龄	Number	3		门 诊
Property Age As %String(XMLPROJECTION = "ELEMENT");

/// MedicalDate	就诊日期	Varchar	20	必须
Property MedicalDate As %String(XMLPROJECTION = "ELEMENT");

/// MedicalInsuranceID	医保编号	Varchar	30	是	
Property MedicalInsuranceID As %String(XMLPROJECTION = "ELEMENT");

/// FundPayAmount	医保统筹基	Number	16,2
Property FundPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// FundDJJZAmount	道交救助基金垫付	Number	16,2		
Property FundDJJZAmount As %String(XMLPROJECTION = "ELEMENT");

/// FundDJJZDept	道交救助基金垫付机构	Varchar	200		
Property FundDJJZDept As %String(XMLPROJECTION = "ELEMENT");

/// FundDJJZDate	道交救助基金垫付日期	Varchar	20		
Property FundDJJZDate As %String(XMLPROJECTION = "ELEMENT");

/// OtherPayAmount	其他支付	Number	16,2		
Property OtherPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// AccountPayAmount	个人账户支付	Number	16,2		
Property AccountPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// OwnPayAmount	个人现金支付	Number	16,2
Property OwnPayAmount As %String(XMLPROJECTION = "ELEMENT");

/// SelfpaymentAmount	个人自负	Number	16,2
Property SelfpaymentAmount As %String(XMLPROJECTION = "ELEMENT");

/// SelfpaymentCost	个人自费	number	16,2
Property SelfpaymentCost As %String(XMLPROJECTION = "ELEMENT");

/// PhoneNumber	手机号	Varchar	20	
Property PhoneNumber As %String(XMLPROJECTION = "ELEMENT");

/// FundPayAmountInfo	医保统筹基金支付说明	Varchar	500	
Property FundPayAmountInfo As %String(XMLPROJECTION = "ELEMENT");

/// FundDJJZAmountInfo	道交救助基金垫付说明	Varchar	500	
Property FundDJJZAmountInfo As %String(XMLPROJECTION = "ELEMENT");

/// OtherPayAmountInfo	其他支付说明	Varchar	500	
Property OtherPayAmountInfo As %String(XMLPROJECTION = "ELEMENT");

/// OwnPayAmountInfo	个人现金支付说明	Varchar	500	
Property OwnPayAmountInfo As %String(XMLPROJECTION = "ELEMENT");

/// SelfpaymentCare	个人自理	Number		16,2
Property SelfpaymentCare As %String(XMLPROJECTION = "ELEMENT");

/// PayMode	交款方式	Varchar	30	
Property PayMode As %String(XMLPROJECTION = "ELEMENT");

/// BizCode	业务流水号	Varchar	32	是
Property BizCode As %String(XMLPROJECTION = "ELEMENT");

/// CurrencyType	货币种类	Varchar	30	
Property CurrencyType As %String(XMLPROJECTION = "ELEMENT");

/// ExchangeRate	汇率	Number
Property ExchangeRate As %String(XMLPROJECTION = "ELEMENT");

/// Checker	复核人	Varchar	20	是	
Property Checker As %String(XMLPROJECTION = "ELEMENT");

/// SupervisorRemark	财政部门备注	Varchar	500	
Property SupervisorRemark As %String(XMLPROJECTION = "ELEMENT");

/// MedicalType	医疗类别	Varchar	30	是	
Property MedicalType As %String(XMLPROJECTION = "ELEMENT");

/// SocialSecurityCardNo	社保卡号	Varchar	50
Property SocialSecurityCardNo As %String(XMLPROJECTION = "ELEMENT");

/// Remark	备注	Varchar	500		记录写库当前服
Property Remark As %String(XMLPROJECTION = "ELEMENT");

/// Rksj	务器时间	Varchar	17	是	
Property Rksj As %String(XMLPROJECTION = "ELEMENT");

/// Total	合计	Number	16,2	是
Property Total As %String(XMLPROJECTION = "ELEMENT");

/// CashPayment	现金支付	Varchar	500	
Property CashPayment As %String(XMLPROJECTION = "ELEMENT");

/// PaymentThisYear	本年支付	Number	16,2
Property PaymentThisYear As %String(XMLPROJECTION = "ELEMENT");

/// BalanceThisYear	本年余额	Number	16,2
Property BalanceThisYear As %String(XMLPROJECTION = "ELEMENT");

/// PaymentLastYear	历年支付	Number	16,2
Property PaymentLastYear As %String(XMLPROJECTION = "ELEMENT");

/// BalanceLastYear	历年余额	Number	16,2
Property BalanceLastYear As %String(XMLPROJECTION = "ELEMENT");

/// MedicalInsuranceAccount	医保账户	Varchar	500	
Property MedicalInsuranceAccount As %String(XMLPROJECTION = "ELEMENT");

/// Workplace	工作单位	Varchar	100		
Property Workplace As %String(XMLPROJECTION = "ELEMENT");

/// BedNumber	床位号	Varchar	20
Property BedNumber As %String(XMLPROJECTION = "ELEMENT");

/// HospitalizationDate	住院日期	Varchar	50	是
Property HospitalizationDate As %String(XMLPROJECTION = "ELEMENT");

/// WesternMedicineFee	西药费	Number	16,2		西药费(其中自
Property WesternMedicineFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayWesternMedicineFee	理自费)	Number	16,2
Property SelfPayWesternMedicineFee As %String(XMLPROJECTION = "ELEMENT");

/// ChinesePatentMedicine	中成药	Number	16,2
Property ChinesePatentMedicine As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayChinesePatentMedici	中成药(其中自ne	理自费)	Number	16,2
Property SelfPayChinesePatentMedici As %String(XMLPROJECTION = "ELEMENT");

/// ChineseHerbalMedicine	中草药	Number	16,2
Property ChineseHerbalMedicine As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayChineseHerbalMedici	中草药(其中自ne	理自费)	Number	16,2
Property SelfPayChineseHerbalMedici As %String(XMLPROJECTION = "ELEMENT");

/// BedFee	床位费	Number	16,2		床位费(其中自	
Property BedFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayBedFee	理自费)	Number	16,2
Property SelfPayBedFee As %String(XMLPROJECTION = "ELEMENT");

/// DiagnosisFee	诊查费	Number	16,2		诊查费(其中自
Property DiagnosisFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayDiagnosisFee	理自费)	Number	16,2
Property SelfPayDiagnosisFee As %String(XMLPROJECTION = "ELEMENT");

/// InspectionFee	检查费	Number	16,2		检查费(其中自	
Property InspectionFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayInspectionFee	理自费)	Number	16,2	
Property SelfPayInspectionFee As %String(XMLPROJECTION = "ELEMENT");

/// ExamineFee	检验费	Number	16,2		检验费(其中自
Property ExamineFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfExamineFee	理自费)	Number	16,2
Property SelfExamineFee As %String(XMLPROJECTION = "ELEMENT");

/// TreatmentFee	治疗费	Number
Property TreatmentFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayTreatmentFee	治疗费(其中自	Number
Property SelfPayTreatmentFee As %String(XMLPROJECTION = "ELEMENT");

/// OperationFee	手术费	Number	16,2		手术费(其中自
Property OperationFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayOperationFee	理自费)	Number	16,2
Property SelfPayOperationFee As %String(XMLPROJECTION = "ELEMENT");

/// BloodTransfusionFee	输血费	Number	16,2		输血费(其中自
Property BloodTransfusionFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayBloodTransfusionFee	理自费)	Number	16,2
Property SelfPayBloodTransfusionFee As %String(XMLPROJECTION = "ELEMENT");

/// NursingFee	护理费	Number	16,2		护理费(其中自
Property NursingFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayNursingFee	理自费)	Number	16,2	
Property SelfPayNursingFee As %String(XMLPROJECTION = "ELEMENT");

/// MaterialFee	材料费	Number	16,2		材料费(其中自
Property MaterialFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayMaterialFee	理自费)	Number	16,2
Property SelfPayMaterialFee As %String(XMLPROJECTION = "ELEMENT");

/// OtherFee	其它	Number	16,2		其它(其中自理
Property OtherFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayOtherFee	自费)	Number	16,2		合计(其中自理
Property SelfPayOtherFee As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayTotal	自费)	Number	16,2
Property SelfPayTotal As %String(XMLPROJECTION = "ELEMENT");

/// Cash	现金(支票)	Number	16,2
Property Cash As %String(XMLPROJECTION = "ELEMENT");

/// ThisYearAccount	本年账户	Number	16,2
Property ThisYearAccount As %String(XMLPROJECTION = "ELEMENT");

/// LastYearAccount	历年账户	Number	16,2
Property LastYearAccount As %String(XMLPROJECTION = "ELEMENT");

/// InsuranceAccount	医保账户	Number	16,2
Property InsuranceAccount As %String(XMLPROJECTION = "ELEMENT");

/// SettlementTotal	(结算信息)合计	Number	16,2
Property SettlementTotal As %String(XMLPROJECTION = "ELEMENT");

/// AdvancepPayment	预缴款	Number	16,2
Property AdvancepPayment As %String(XMLPROJECTION = "ELEMENT");

/// PayBack	补缴	Number	16,2		( 缴款) 其中: 现
Property PayBack As %String(XMLPROJECTION = "ELEMENT");

/// PayBackCash	金	Number	16,2		( 缴款) 其中: 支
Property PayBackCash As %String(XMLPROJECTION = "ELEMENT");

/// PayBackCheck	票	Number	16,2		
Property PayBackCheck As %String(XMLPROJECTION = "ELEMENT");

/// Refund	退款	Number	16,2		( 退款) 其中: 现
Property Refund As %String(XMLPROJECTION = "ELEMENT");

/// RefundCash	金	Number	16,2	
Property RefundCash As %String(XMLPROJECTION = "ELEMENT");

/// Payee	领款人	Varchar	50		收费项目名称自	
Property Payee As %String(XMLPROJECTION = "ELEMENT");

/// ItemNameCust1	定义 1	Varchar	50		收费项目金额自	
Property ItemNameCust1 As %String(XMLPROJECTION = "ELEMENT");

/// ItemMoneyCust1	定义 1	Number	16,2		收费项目自理自
Property ItemMoneyCust1 As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayItemMoneyCust1	费自定义 1	Number	16,2		收费项目名称自	
Property SelfPayItemMoneyCust1 As %String(XMLPROJECTION = "ELEMENT");

/// ItemNameCust2	定义 2	Varchar	50		
Property ItemNameCust2 As %String(XMLPROJECTION = "ELEMENT");

/// ItemMoneyCust2	收费项目金额自定义 2	Number	16,2
Property ItemMoneyCust2 As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayItemMoneyCust2	收费项目自理自费自定义 2	Number	16,2		
Property SelfPayItemMoneyCust2 As %String(XMLPROJECTION = "ELEMENT");

/// ItemNameCust3	收费项目名称自定义 3	Varchar	50		
Property ItemNameCust3 As %String(XMLPROJECTION = "ELEMENT");

/// ItemMoneyCust3	收费项目金额自定义 3	Number	16,2		
Property ItemMoneyCust3 As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayItemMoneyCust3	收费项目自理自费自定义 3	Number	16,2		
Property SelfPayItemMoneyCust3 As %String(XMLPROJECTION = "ELEMENT");

/// ItemNameCust4	收费项目名称自定义 4	Varchar	50		
Property ItemNameCust4 As %String(XMLPROJECTION = "ELEMENT");

/// ItemMoneyCust4	收费项目金额自定义 4	Number	16,2		
Property ItemMoneyCust4 As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayItemMoneyCust4	收费项目自理自自定义 4	Number	16,2		
Property SelfPayItemMoneyCust4 As %String(XMLPROJECTION = "ELEMENT");

/// ItemNameCust5	收费项目名称自定义 5	Varchar	50		
Property ItemNameCust5 As %String(XMLPROJECTION = "ELEMENT");

/// ItemMoneyCust5	收费项目金额自定义 5	Number	16,2		
Property ItemMoneyCust5 As %String(XMLPROJECTION = "ELEMENT");

/// SelfPayItemMoneyCust5	收费项目自理自费自定义 5	Number	16,2		
Property SelfPayItemMoneyCust5 As %String(XMLPROJECTION = "ELEMENT");

/// SettleItemNameCust1	结算项目名称自定义 1	Varchar	50		
Property SettleItemNameCust1 As %String(XMLPROJECTION = "ELEMENT");

/// SettleItemMoneyCust1	结算项目金额自定义 1	Number	16,2		
Property SettleItemMoneyCust1 As %String(XMLPROJECTION = "ELEMENT");

/// SettleItemNameCust2	 结算项目名称自定义 2	Varchar	50		
Property SettleItemNameCust2 As %String(XMLPROJECTION = "ELEMENT");

/// SettleItemMoneyCust2	结算项目金额自定义 2	Number	16,2		
Property SettleItemMoneyCust2 As %String(XMLPROJECTION = "ELEMENT");

/// SettleItemNameCust3	 结算项目名称自定义 3	Varchar	50		
Property SettleItemNameCust3 As %String(XMLPROJECTION = "ELEMENT");

/// SettleItemMoneyCust3	结算项目金额自定义 3	Number	16,2		
Property SettleItemMoneyCust3 As %String(XMLPROJECTION = "ELEMENT");

/// PayBackCust	补缴自定义：银行卡	Number	16,2		
Property PayBackCust As %String(XMLPROJECTION = "ELEMENT");

/// PayBackMoneyCust		补缴金额自定退款自定义：银义：银行卡	Number	16,2		
Property PayBackMoneyCust As %String(XMLPROJECTION = "ELEMENT");

/// RefundCust	行卡	Number	16,2		
Property RefundCust As %String(XMLPROJECTION = "ELEMENT");

/// RefundMoneyCust	退款金额自定义：银行卡	Number	16,2
Property RefundMoneyCust As %String(XMLPROJECTION = "ELEMENT");

/// PayeeCust	领款人处自定义;支票	Number	16,2
Property PayeeCust As %String(XMLPROJECTION = "ELEMENT");

/// PayeeMoneyCust	领款人处金额自	Number	16,2
Property PayeeMoneyCust As %String(XMLPROJECTION = "ELEMENT");

/// PayBackAlipay	补缴支付宝 补缴智慧医疗账		Number	16,2		
Property PayBackAlipay As %String(XMLPROJECTION = "ELEMENT");

/// PayBackSmartMedical	户	Number	16,2		
Property PayBackSmartMedical As %String(XMLPROJECTION = "ELEMENT");

/// RefundAlipay	退款支付宝 退款智慧医疗账	Number	16,2		
Property RefundAlipay As %String(XMLPROJECTION = "ELEMENT");

/// RefundSmartMedical	户	Number	16,2		
Property RefundSmartMedical As %String(XMLPROJECTION = "ELEMENT");

/// HospitalTemplate	医院自定义模板	Varchar	2		
Property HospitalTemplate As %String(XMLPROJECTION = "ELEMENT");

/// Scjg	上传结果	Varchar	2		
/// Property Scjg As %String(XMLPROJECTION = "ELEMENT");
/// Zwcwxx	中文错误信息	Varchar	200		
/// Property Zwcwxx As %String(XMLPROJECTION = "ELEMENT");
/// Sccs	上传次数	Number	2	是	
/// Property Sccs As %String(XMLPROJECTION = "ELEMENT");
/// Dzjg	订正结果默认数据库服务	Varchar	2		
Property Dzjg As %String(XMLPROJECTION = "ELEMENT");

/// Autotime	器时间	date			
Property Autotime As %String(XMLPROJECTION = "ELEMENT");

/// Entercode	执收单位编码	Varchar	20	是	
Property Entercode As %String(XMLPROJECTION = "ELEMENT");

}

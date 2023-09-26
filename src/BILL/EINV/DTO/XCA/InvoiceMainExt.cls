Class BILL.EINV.DTO.XCA.InvoiceMainExt Extends %RegisteredObject
{

Property BusinessDate As %String(CAPTION = "业务日期");

Property Gender As %String(CAPTION = "性别");

Property Age As %String(CAPTION = "年龄");

Property MedicalType As %String(CAPTION = "医疗类别");

Property MedicalInsuranceType As %String(CAPTION = "医保类型");

Property MedicalInsuranceNumber As %String(CAPTION = "社会保障卡号");

Property CaseNumber As %String(CAPTION = "病例号");

Property HospitalizationNumber As %String(CAPTION = "住院号");

Property DepartmentName As %String(CAPTION = "科别");

Property InHospitalDate As %String(CAPTION = "住院日期");

Property OutHospitalDate As %String(CAPTION = "出院日期");

Property PatientNumber As %String(CAPTION = "门诊号");

Property MedicalDate As %String(CAPTION = "就诊日期");

Property PrepayAmount As %String(CAPTION = "预缴金额");

Property RechargeAmount As %String(CAPTION = "补缴金额");

Property RefundAmount As %String(CAPTION = "退费金额");

Property SelfPaymentCost As %String(CAPTION = "个人自费");

Property BSelfpayment As %String(CAPTION = "乙类首自付");

Property PTNSelfpayment As %String(CAPTION = "按比例自付");

Property OwnPayAmount As %String(CAPTION = "个人现金支付");

Property AccountPayAmount As %String(CAPTION = "个人账户支付");

Property FundPayAmount As %String(CAPTION = "医保统筹基金支付");

Property CivilSubsidy As %String(CAPTION = "公务员补助");

Property TeacherSubsidy As %String(CAPTION = "师职补助");

Property LInsuranceReimburse As %String(CAPTION = "大额（病）保险报销");

Property LSuppleInsuranceReimburse As %String(CAPTION = "大病补充保险报销");

Property MedicalHelp As %String(CAPTION = "医疗救助");

Property AntenatalClinic As %String(CAPTION = "产前检查费");

Property OtherPayAmount As %String(CAPTION = "其他支付");

Property SelfMainExt As %String(CAPTION = "个性化其他项目信息");

}

/// 基本信息扩展
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainExt Extends (%RegisteredObject, %XML.Adaptor)
{

Property BusinessNumber As %String(CAPTION = "业务单号", XMLPROJECTION = "ELEMENT");

Property BusinessDate As %String(CAPTION = "业务日期", XMLPROJECTION = "ELEMENT");

Property Gender As %String(CAPTION = "性别", XMLPROJECTION = "ELEMENT");

Property MedicalType As %String(CAPTION = "医疗类别", XMLPROJECTION = "ELEMENT");

Property OrgType As %String(CAPTION = "医疗机构类型", XMLPROJECTION = "ELEMENT");

Property MedicalInsuranceType As %String(CAPTION = "医保类型", XMLPROJECTION = "ELEMENT");

Property InsuranceID As %String(CAPTION = "医保编号", XMLPROJECTION = "ELEMENT");

Property FundPayAmount As %String(CAPTION = "医保统筹基金支付", XMLPROJECTION = "ELEMENT");

Property OtherPayAmount As %String(CAPTION = "其他支付", XMLPROJECTION = "ELEMENT");

Property AccountPayAmount As %String(CAPTION = "个人账户支付", XMLPROJECTION = "ELEMENT");

Property OwnPayAmount As %String(CAPTION = "个人现金支付", XMLPROJECTION = "ELEMENT");

Property SelfpaymentAmount As %String(CAPTION = "个人自付", XMLPROJECTION = "ELEMENT");

Property SelfpaymentCost As %String(CAPTION = "个人自费", XMLPROJECTION = "ELEMENT");

Property PatientNumber As %String(CAPTION = "门诊号", XMLPROJECTION = "ELEMENT");

Property MedicalDate As %String(CAPTION = "就诊日期", XMLPROJECTION = "ELEMENT");

Property CaseNumber As %String(CAPTION = "病例号", XMLPROJECTION = "ELEMENT");

Property HospitalizationNumber As %String(CAPTION = "住院号", XMLPROJECTION = "ELEMENT");

Property DepartmentName As %String(CAPTION = "科别", XMLPROJECTION = "ELEMENT");

Property InHospitalDate As %String(CAPTION = "住院日期", XMLPROJECTION = "ELEMENT");

Property OutHospitalDate As %String(CAPTION = "出院日期", XMLPROJECTION = "ELEMENT");

Property PrepayAmount As %String(CAPTION = "预缴金额", XMLPROJECTION = "ELEMENT");

Property RefundAmount As %String(CAPTION = "住院退款", XMLPROJECTION = "ELEMENT");

Property RechargeAmount As %String(CAPTION = "补缴金额", XMLPROJECTION = "ELEMENT");

Property PrepaidAmount As %String(CAPTION = "退费金额", XMLPROJECTION = "ELEMENT");

Property RelatedInvoiceCode As %String(CAPTION = "相关票据代码", XMLPROJECTION = "ELEMENT");

Property RelatedInvoiceNumber As %String(CAPTION = "相关票据号码", XMLPROJECTION = "ELEMENT");

Property PayCode As %String(CAPTION = "缴款码", XMLPROJECTION = "ELEMENT");

}

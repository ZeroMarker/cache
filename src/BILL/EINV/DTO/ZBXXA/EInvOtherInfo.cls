/// 票面其他信息
Class BILL.EINV.DTO.ZBXXA.EInvOtherInfo Extends %RegisteredObject
{

Property OutpatientCode As %String(CAPTION = "门诊号");

Property VisitingTime As %String(CAPTION = "就诊日期");

Property MedInstitutionType As %String(CAPTION = "医疗机构类型");

Property MedInsuranceType As %String(CAPTION = "医保类别");

Property MedInsuranceCode As %String(CAPTION = "医保编号");

Property Sex As %String(CAPTION = "性别");

Property MedInsurancePay As %String(CAPTION = "医保统筹基金支 ");

Property OtherPay As %String(CAPTION = "其他支付");

Property PersonalAccountPay As %String(CAPTION = "个人账户支 ");

Property PersonalCashPay As %String(CAPTION = "个人现金支付");

Property PersonalPay As %String(CAPTION = "个人自付");

Property PersonalExpense As %String(CAPTION = "个人自费");

Property MedRecordNO As %String(CAPTION = "病历号");

Property HosptztNumber As %String(CAPTION = "住院号");

Property HosptztDepartment As %String(CAPTION = "住院科 ");

Property HosptztDate As %String(CAPTION = "住院时间");

Property PrepaidAmount As %String(CAPTION = "预缴金额");

Property SupplementAmount As %String(CAPTION = "补缴金额");

Property RefundAmount As %String(CAPTION = "退费金额");

}

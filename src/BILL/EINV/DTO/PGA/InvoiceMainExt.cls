Class BILL.EINV.DTO.PGA.InvoiceMainExt Extends %RegisteredObject
{

Property businessNumber As %String(CAPTION = "业务流水号");

Property businessDate As %String(CAPTION = "业务日期");

Property gender As %String(CAPTION = "性别");

Property age As %String(CAPTION = "年龄");

Property medicalType As %String(CAPTION = "医疗类别");

Property patientNumber As %String(CAPTION = "门诊号");

Property medicalDate As %String(CAPTION = "就诊日期");

Property orgType As %String(CAPTION = "医疗机构类型");

Property medicalInsuranceType As %String(CAPTION = "医保类型");

Property medicalInsuranceId As %String(CAPTION = "社会保障卡号");

Property fundPayAmount As %String(CAPTION = "医保统筹基金支付");

Property otherPayAmount As %String(CAPTION = "其他支付");

Property accountPayAmount As %String(CAPTION = "个人账户支付");

Property ownPayAmount As %String(CAPTION = "个人现金支付");

Property selfPaymentAmount As %String(CAPTION = "个人自付");

Property selfPaymentCost As %String(CAPTION = "个人自费");

Property caseNumber As %String(CAPTION = "病例号");

Property hospitalizationNumber As %String(CAPTION = "住院号");

Property departmentName As %String(CAPTION = "科别");

Property inHospitalDate As %String(CAPTION = "住院日期");

Property outHospitalDate As %String(CAPTION = "出院日期");

Property prePayAmount As %String(CAPTION = "预缴金额");

Property rechargeAmount As %String(CAPTION = "补缴金额");

Property refundAmount As %String(CAPTION = "退费金额");

Property selfMainExt As %String(CAPTION = "个性化其他项目信息");

}

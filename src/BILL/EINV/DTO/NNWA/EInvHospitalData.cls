/// 住院信息
Class BILL.EINV.DTO.NNWA.EInvHospitalData Extends %RegisteredObject
{

Property orgType As %String(CAPTION = " 医疗机构类型");

Property medicalInsuranceType As %String(CAPTION = "医保类型");

Property medicalInsuranceID As %String(CAPTION = "医保编号");

Property fundPayAmount As %String(CAPTION = "医保统筹基金支付");

Property otherPayAmount As %String(CAPTION = "其他支付");

Property accountPayAmount As %String(CAPTION = "个人账户支付");

Property ownPayAmount As %String(CAPTION = "个人现金支付");

Property selfpaymentAmount As %String(CAPTION = "个人自付");

Property selfpaymentCost As %String(CAPTION = "个人自费");

Property caseNumber As %String(CAPTION = "病例号");

Property hospitalizationNumber As %String(CAPTION = "住院号");

Property departmentName As %String(CAPTION = "科室名称");

Property departmentCode As %String(CAPTION = "科室编号");

Property inHospitalDate As %String(CAPTION = "住院日期");

Property outHospitalDate As %String(CAPTION = "出院日期");

Property prepayAmount As %String(CAPTION = "预缴金额");

Property rechargeAmount As %String(CAPTION = "补缴金额");

Property refundAmount As %String(CAPTION = "退费金额");

Property prepayItem As list Of BILL.EINV.DTO.NNWA.EInvPrepayItemData(CAPTION = "预缴金票据");

}

/// ///对象功能说明：预交金开票入参组织对象
Class BILL.EINV.DTO.BSA.PreDepositInvoiceReq Extends %RegisteredObject
{

Property busType As %String(CAPTION = "业务标识");

/// 缴款人类型：1 个人 2 单位
Property payerType As %String(CAPTION = "缴款人类型");

Property placeCode As %String(CAPTION = "开票点编码");

Property isTurnDeposit As %String(CAPTION = "是否为转存");

Property busNo As %String(CAPTION = "预交金业务流水号");

Property payer As %String(CAPTION = "患者姓名");

Property busDateTime As %String(CAPTION = "业务发生时间");

Property payee As %String(CAPTION = "收费员");

Property drawee As %String(CAPTION = "缴款人");

Property author As %String(CAPTION = "编制人");

Property hospitalNo As %String(CAPTION = "患者住院号");

Property visitNo As %String(CAPTION = "住院就诊编号");

Property caseNumber As %String(CAPTION = "病历号");

Property patientId As %String(CAPTION = "患者唯一ID");

Property patientNo As %String(CAPTION = "患者就诊编号");

Property inHospitaDate As %String(CAPTION = "入院日期");

Property hospitalArea As %String(CAPTION = "病区");

Property remark As %String(CAPTION = "备注");

Property bedNo As %String(CAPTION = "床号");

Property category As %String(CAPTION = "科别");

Property categoryCode As %String(CAPTION = "科室编码");

Property faber As %String(CAPTION = "费别");

Property tel As %String(CAPTION = "患者手机号码");

Property email As %String(CAPTION = "患者邮箱地址");

Property idCardNo As %String(CAPTION = "患者身份证号码");

Property cardType As %String(CAPTION = "卡类型");

Property cardNo As %String(CAPTION = "卡号");

Property accountName As %String(CAPTION = "账户名称");

Property accountNo As %String(CAPTION = "账户号码");

Property accountBank As %String(CAPTION = "账户开户行");

Property accountUnit As %String(CAPTION = "转账单位");

Property medicalCareType As %String(CAPTION = "医保类型名称");

Property billNumber As %String(CAPTION = "单据号");

Property amt As %String(CAPTION = "预缴金金额");

Property ownAcBalance As %String(CAPTION = "预缴金账户余额");

Property payChannelCode As %String(CAPTION = "交费渠道编码");

Property sourceHospitalNo As %String(CAPTION = "原住院号");

// Property payChannelDetail As list Of BILL.EINV.DTO.BSA.IPPayChannelDetail(CAPTION = "交费渠道列表");

Property sourceVisitNo As %String(CAPTION = "原就诊号");

/*
Property busType As %String(CAPTION = "业务标识");

Property busNo As %String(CAPTION = "预交金业务流水号");

Property payer As %String(CAPTION = "患者姓名");

Property busDateTime As %String(CAPTION = "业务发生时间");

Property placeCode As %String(CAPTION = "开票点编码");

Property payee As %String(CAPTION = "收费员");

Property drawee As %String(CAPTION = "缴款人");

Property author As %String(CAPTION = "编制人");

Property tel As %String(CAPTION = "患者手机号码");

Property email As %String(CAPTION = "患者邮箱地址");

Property idCardNo As %String(CAPTION = "患者身份证号码");

Property cardType As %String(CAPTION = "卡类型");

Property cardNo As %String(CAPTION = "卡号");

Property amt As %String(CAPTION = "预缴金金额");

Property ownAcBalance As %String(CAPTION = "预缴金账户余额");

Property category As %String(CAPTION = "入院科室名称");

Property categoryCode As %String(CAPTION = "入院科室编码");

Property inHospitalDate As %String(CAPTION = "入院日期");

Property hospitalNo As %String(CAPTION = "患者住院号");

Property visitNo As %String(CAPTION = "住院就诊编号");

Property patientId As %String(CAPTION = "患者唯一ID");

Property patientNo As %String(CAPTION = "患者就诊编号");

Property caseNumber As %String(CAPTION = "病历号");

Property payChannelDetail As list Of BILL.EINV.DTO.BSA.IPPayChannelDetail(CAPTION = "交费渠道列表");

Property accountName As %String(CAPTION = "账户名称");

Property accountNo As %String(CAPTION = "账户号码");

Property accountBank As %String(CAPTION = "账户开户行");

Property remark As %String(CAPTION = "备注");

Property workUnit As %String(CAPTION = "工作单位或地址");
*/
}

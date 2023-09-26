/// 7.2.2 开电子票据请求对象
Class BILL.EINV.DTO.XAA.InvoiceReq Extends %RegisteredObject
{

Property serialNumber As %String(CAPTION = "业务流水号");

/// 1:门诊票
/// 2:住院票
/// 3:政府非税收入
/// 4:社会团体会费
/// 5:公益事业捐赠
/// 6:资金往来结算
/// 7:其他票据
Property theType As %String(CAPTION = "票据类型");

Property totalAmount As %String(CAPTION = "总金额");

Property recName As %String(CAPTION = "收款人全称");

Property recAcct As %String(CAPTION = "收款人账号");

Property recOpBk As %String(CAPTION = "收款人开户行");

/// 1:个人;2:单位
Property payerPartyType As %String(CAPTION = "交款人类型");

Property payerPartyCode As %String(CAPTION = "交款人代码");

Property payerPartyName As %String(CAPTION = "交款人名称");

/// 男/女
Property gender As %String(CAPTION = "性别");

Property payerAcct As %String(CAPTION = "交款人账号");

Property payerOpBk As %String(CAPTION = "交款人开户行");

/// 缴费方式:1-现金、2-POS 刷卡3-批量代扣 4-终端支付
Property payMode As %String(CAPTION = "交款方式");

Property businessNumber As %String(CAPTION = "业务单号");

Property handlingPerson As %String(CAPTION = "开票人");

Property checker As %String(CAPTION = "复核人");

Property patientNumber As %String(CAPTION = "门诊号");

Property medicalDate As %String(CAPTION = "就诊日期");

Property orgType As %String(CAPTION = "医疗机构类型");

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

Property departmentName As %String(CAPTION = "科别");

Property inHospitalDate As %String(CAPTION = "住院日期");

Property outHospitalDate As %String(CAPTION = "出院日期");

Property prepayAmount As %String(CAPTION = "预缴金额");

Property rechargeAmount As %String(CAPTION = "补缴金额");

Property refundAmount As %String(CAPTION = "退费金额");

Property remark As %String(CAPTION = "备注");

Property spstand As %String(CAPTION = "起付标准");

Property bselfpayment As %String(CAPTION = "乙类首自付");

Property ptnselfpayment As %String(CAPTION = "按比例自付");

Property civilSubsidy As %String(CAPTION = "公务员补助");

Property teacherSubsidy As %String(CAPTION = "师职补助");

Property linsuranceReimbursement As %String(CAPTION = "大额保险报销");

Property lsubsidiaryInsuranceReimbursement As %String(CAPTION = "大病补充保险报销");

Property medicalHelp As %String(CAPTION = "医疗救助");

Property antenatalClinic As %String(CAPTION = "产前检查费");

Property medicalInsuranceNumber As %String(CAPTION = "社会保障卡号");

Property items As list Of BILL.EINV.DTO.XAA.Invoiceitems(CAPTION = "收费项目");

Property auxItems As list Of BILL.EINV.DTO.XAA.InvoiceauxItems(CAPTION = "收费项目明细");

}

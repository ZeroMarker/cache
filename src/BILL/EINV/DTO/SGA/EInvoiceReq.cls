/// 税歌电子发票开具参数组织对象
Class BILL.EINV.DTO.SGA.EInvoiceReq Extends %RegisteredObject
{

/// 票据流水号（his发票号)
Property einvoiceNo As %String(CAPTION = "业务流水号");

Property einvoiceCode As %String(CAPTION = "票据代码");

/// 票据代码 330601+年后两位：门诊收费 ；330602+年后两位：住院收费；330603+年后两位：诊查费收费
/// 接口文档不清楚先改成List ，最后找开发商确认
Property einvoiceNumber As %String(CAPTION = "票据号码");

Property einvoiceType As %String(CAPTION = "票据代码类型");

Property opeType As %String(CAPTION = "处理类型");

/// 330601：门诊收费;330602：住院收费;330603：诊查费收费
/// (处理类型 1默认:正常)
Property totalAmount As %String(CAPTION = "开票总金额");

Property institutionCode As %String(CAPTION = "单位代码");

Property recName As %String(CAPTION = "收款人全称");

Property recAcct As %String(CAPTION = "收款人账号");

/// 交款人类型（固定1）
Property payerPartyType As %String(CAPTION = "交款人类型");

Property payerPartyCode As %String(CAPTION = "交款人代码");

Property payerPartyName As %String(CAPTION = "交款人全称");

Property payerPartyAcct As %String(CAPTION = "交款人账号(手机号)");

Property payerPartyOpBank As %String(CAPTION = "交款人开户行");

/// 开票人（默认是系统）(可以和recName一致)
Property handlingPerson As %String(CAPTION = "开票人");

Property checker As %String(CAPTION = "复核人");

Property medicalNo As %String(CAPTION = "病例号");

Property medicalCardNo As %String(CAPTION = "就诊卡号");

/// 开票日期(yyyy-MM-dd)
Property issueDate As %String(CAPTION = "开票日期");

/// 开票时间（例：13:20:46）
Property issueTimeStr As %String(CAPTION = "开票时间");

Property totalAmountSelf As %String(CAPTION = "自费总金额");

Property medicalType As %String(CAPTION = "医疗机构类型");

Property idCardNo As %String(CAPTION = "身份证");

Property patientName As %String(CAPTION = "病人名称");

Property patientGender As %String(CAPTION = "病人性别");

Property patientMedicalInsuranceType As %String(CAPTION = "病人医保类型");

Property patientSsn As %String(CAPTION = "病人社会保障号码");

/// 病人社会保障号码(区别于ssnNo，patientSsn打印于票上，可以做隐蔽处理)
Property ssnNo As %String(CAPTION = "病人社会保障号码");

Property patientCompany As %String(CAPTION = "病人工作单位");

/// 费用信息
Property section As %String(CAPTION = "科别");

/// 病人治疗开始日期(yyyy-MM-dd)
Property patientTreatmentStartDate As %String(CAPTION = "病人治疗起始日期");

/// 病人治疗结束日期(yyyy-MM-dd)
Property patientTreatmentEndDate As %String(CAPTION = "病人治疗结束日期");

Property admissionNumber As %String(CAPTION = "病人住院号");

/// 预交款（浙江省医疗住院收费票据）
Property prepaidFunds As %String(CAPTION = "预交款");

Property additionalPayment As %String(CAPTION = "补缴");

/// 补缴现金（浙江省医疗住院收费票据）
Property additionalCashPayment As %String(CAPTION = "补缴现金");

/// 补缴支票（浙江省医疗住院收费票据）
Property additionalCheckPayment As %String(CAPTION = "补缴支票");

/// 退款（浙江省医疗住院收费票据）
Property refunds As %String(CAPTION = "退款");

/// 退款现金（浙江省医疗住院收费票据）
Property refundsCash As %String(CAPTION = "退款现金");

/// 领款人（浙江省医疗住院收费票据）
Property payee As %String(CAPTION = "领款人");

/// 现金(支票)（浙江省医疗住院收费票据）
Property cashOrCheck As %String(CAPTION = "现金(支票)");

Property allAmountCn As %String(CAPTION = "合计金额（大写）");

Property allAmount As %String(CAPTION = "合计金额");

Property invoicingPartyName As %String(CAPTION = "开票方单位名称");

/// 医保支付
Property healthCareAccountPayment As %String(CAPTION = "医保账户支付");

Property individualAccountCurrPayment As %String(CAPTION = "个人账户_本年支付");

Property individualAccountCurrBalance As %String(CAPTION = "个人账户_本年余额");

Property individualAccountPrevPayment As %String(CAPTION = "个人账户_历年支付");

Property individualAccountPrevBalance As %String(CAPTION = "个人账户_历年余额");

Property cashPayment As %String(CAPTION = "现金支付信息");

/// 现金支付结算明细 ；存在现金支付信息时在此节点下按明细添加
Property cashPayDetails As list Of BILL.EINV.DTO.SGA.CashPayList(CAPTION = "现金支付");

Property healthCareAccount As %String(CAPTION = "医保账户");

/// 院区编码（需要医院预先在院区页面自行增加）
Property affiliatedAreaCode As %String(CAPTION = "院区编码");

Property visitNo As %String(CAPTION = "就诊号");

Property visitDeptName As %String(CAPTION = "就诊科室");

Property accountPayDetail As list Of BILL.EINV.DTO.SGA.INSUPayList(CAPTION = "医保账户结算明细");

Property totalBalance As %String(CAPTION = "结算合计");

Property remark As %String(CAPTION = "备注");

Property remarkName1 As %String(CAPTION = "备注名1");

Property remarkContent1 As %String(CAPTION = "备注内容1");

Property remarkName2 As %String(CAPTION = "备注名2");

Property remarkContent2 As %String(CAPTION = "备注内容2");

Property remarkName3 As %String(CAPTION = "备注名3");

Property remarkContent3 As %String(CAPTION = "备注内容3");

Property remarkName4 As %String(CAPTION = "备注名4");

Property remarkContent4 As %String(CAPTION = "备注内容4");

Property remarkName5 As %String(CAPTION = "备注名5");

Property remarkContent5 As %String(CAPTION = "备注内容5");

/// 明细
Property items As list Of BILL.EINV.DTO.SGA.EInvDetailList(CAPTION = "清单项目明细");

}

Class BILL.EINV.DTO.HNA.InvoiceMainExt Extends %RegisteredObject
{

Property businessNumber As %String(CAPTION = "业务单号");

Property businessDate As %String(CAPTION = "业务日期");

Property gender As %String(CAPTION = "性别");

Property age As %String(CAPTION = "年龄");

Property address As %String(CAPTION = "地址");

Property medicalType As %String(CAPTION = "医疗类别");

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

Property relatedInvoiceCode As %String(CAPTION = "相关票据代码");

Property relatedInvoiceNumber As %String(CAPTION = "相关票据号码");

Property payCode As %String(CAPTION = "缴款码");

Property selfmainext As %String(CAPTION = "个性化其他项目信息");

Property patientNo As %String(CAPTION = "患者登记号");

Property cardNo As %String(CAPTION = "卡号");

/// 起付标准
Property spStand As %String(CAPTION = "起付标准");

/// 乙类首自付
Property bSelfpayment As %String(CAPTION = "乙类首自付");

/// 按比例自付
Property ptnSelfpayment As %String(CAPTION = "按比例自付");

/// 师职补助
Property teacherSubsidy As %String(CAPTION = "师职补助");

/// 大病补充保险报销
Property lSuppleInsuranceReimburse As %String(CAPTION = "大病补充保险报销");

/// 产前检查费
Property antenatalClinic As %String(CAPTION = "产前检查费");

/// 医疗救助
Property civilSubsidy As %String(CAPTION = "医疗救助");

/// 医疗救助
Property lInsuranceReimburse As %String(CAPTION = "医疗救助");

/// 医疗救助
Property medicalInsuranceNumber As %String(CAPTION = "医疗救助");

/// 医疗救助
Property medicalHelp As %String(CAPTION = "医疗救助");

}

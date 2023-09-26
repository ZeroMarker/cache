/// 富深电子票据红冲的入参对象
Class BILL.EINV.DTO.FSA.EInvalidReq Extends %RegisteredObject
{

Property einvoicespecimen As %String(CAPTION = "电子票据模板 1:门诊2:住院");

Property issuedate As %String(CAPTION = "开票日期");

Property issuetime As %String(CAPTION = "开票时间");

Property payerpartytype As %String(CAPTION = "交款人类型");

Property payerpartycode As %String(CAPTION = "交款人代码");

Property payerpartyname As %String(CAPTION = "交款人名称");

Property payeracct As %String(CAPTION = "交款人账号");

Property payeropbk As %String(CAPTION = "交款人开户行");

Property payerphonenumber As %String(CAPTION = "交款人手机号");

Property recname As %String(CAPTION = "收款人");

Property recacct As %String(CAPTION = "收款人账号");

Property recopbk As %String(CAPTION = "收款人开户行");

Property totalamount As %String(CAPTION = "总金额");

Property bizcode As %String(CAPTION = "业务流水号");

Property handlingperson As %String(CAPTION = "开票人（收款人）");

Property checker As %String(CAPTION = "复核人");

Property remark As %String(CAPTION = "其他信息");

Property relatedinvoicecode As %String(CAPTION = "相关票据代码");

Property relatedinvoicenumber As %String(CAPTION = "相关票据号码");

Property businessnumber As %String(CAPTION = "业务单号");

Property businessdate As %String(CAPTION = "业务日期");

Property gender As %String(CAPTION = "性别");

Property medicaltype As %String(CAPTION = "医疗类别");

Property patientnumber As %String(CAPTION = "门诊号");

Property medicaldate As %String(CAPTION = "就诊日期");

Property orgtype As %String(CAPTION = "医疗机构类型");

Property medicalinsurancetype As %String(CAPTION = "医保类型");

Property medicalinsuranceid As %String(CAPTION = "医保编号");

Property fundpayamount As %String(CAPTION = "医保统筹基金支付");

Property otherpayamount As %String(CAPTION = "其他支付");

Property accountpayamount As %String(CAPTION = "个人账户支付");

Property ownpayamount As %String(CAPTION = "个人现金支付");

Property selfpaymentamount As %String(CAPTION = "个人自付");

Property selfpaymentcost As %String(CAPTION = "个人自费");

Property casenumber As %String(CAPTION = "病例号");

Property hospitalizationnumber As %String(CAPTION = "住院号");

Property departmentname As %String(CAPTION = "科别");

Property inhospitaldate As %String(CAPTION = "住院日期");

Property outhospitaldate As %String(CAPTION = "出院日期");

Property prepayamount As %String(CAPTION = "预缴金额");

Property rechargeamount As %String(CAPTION = "补缴金额");

Property refundamount As %String(CAPTION = "退费金额");

/// 1：直接返回data，需等待2：无data，后续发主动获取接口查询（空值，默认为2）建议使用方式2
Property state As %String(CAPTION = "获取返回参数方式");

/// details项目信息（List）门诊大类 住院大类
Property details As list Of BILL.EINV.DTO.FSA.detailslist(CAPTION = "项目信息");

/// auxdetails项目清单（List） 住院也需要传明细
Property auxdetails As list Of BILL.EINV.DTO.FSA.auxdetailslist(CAPTION = "项目清单");

}

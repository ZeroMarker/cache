Class BILL.EINV.DTO.XYHA.OPInvoiceMain Extends %RegisteredObject
{

Property OrgID As %String(CAPTION = "机构编号");

Property EINVOICENAME As %String(CAPTION = "电子票据名称");

Property INVOICENO As %String(CAPTION = "医院票据号");

Property PATIENTNUMBER As %String(CAPTION = "门诊号");

Property EINVOICECODE As %String(CAPTION = "电子票据代码（来源财政）");

Property EINVOICENUMBER As %String(CAPTION = "电子票据号码（来源财政）");

Property INVOICETYPE As %String(CAPTION = "开票类型");

Property VISITDATE As %String(CAPTION = "就诊时间");

Property OfficeCode As %String(CAPTION = "就诊科室代码");

Property OfficeName As %String(CAPTION = "就诊科室名称");

Property fdrcode As %String(CAPTION = "就诊医师代码");

Property fdr As %String(CAPTION = "就诊医师姓名");

Property TOTALAMOUNT As %String(CAPTION = "总金额");

Property ISSUETIME As %String(CAPTION = "开票时间");

Property INVOICINGCLERK As %String(CAPTION = "开票员代码");

Property HANDLINGPERSON As %String(CAPTION = "开票人");

Property CHECKER As %String(CAPTION = "复核人");

Property CARDTYPE As %String(CAPTION = "卡类型");

Property CARDNO As %String(CAPTION = "卡号");

Property PAYERPARTYTYPE As %String(CAPTION = "交款人类型");

Property PAYERPARTYCODE As %String(CAPTION = "交款人代码");

Property PAYERPARTYNAME As %String(CAPTION = " 患者名称 ");

Property GENDER As %String(CAPTION = "性别");

Property AGE As %String(CAPTION = "年龄");

Property ADDRESS As %String(CAPTION = "地址");

Property Tel As %String(CAPTION = "联系电话");

Property PAYERACCT As %String(CAPTION = "患者账号");

Property PAYEROPBK As %String(CAPTION = "患者开户行");

Property PAYMODE As %String(CAPTION = "交款方式");

Property CURRENCYTYPE As %String(CAPTION = "货币种类");

Property EXCHANGERATE As %String(CAPTION = "汇率");

Property SUPERVISORREMARK As %String(CAPTION = "备注");

Property PatientType As %String(CAPTION = "病人类型");

Property MEDICALINSURANCETYPE As %String(CAPTION = "医保类型");

Property MEDICALINSURANCEID As %String(CAPTION = "医保编号");

Property CBDQ As %String(CAPTION = "参保地区");

Property PREPAYAMOUNT As %String(CAPTION = "预缴金额");

Property RECHARGEAMOUNT As %String(CAPTION = "补缴金额");

Property REFUNDAMOUNT As %String(CAPTION = "退费金额");

Property Deductible As %String(CAPTION = "起付线");

Property SELFPAYMENTCOST As %String(CAPTION = "个人自费");

Property YLSZF As %String(CAPTION = "乙类首自付");

Property ABLZF As %String(CAPTION = "按比例自付");

Property OWNPAYAMOUNT As %String(CAPTION = "个人现金支付");

Property ACCOUNTPAYAMOUNT As %String(CAPTION = "个人账户支付");

Property FUNDPAYAMOUNT As %String(CAPTION = "医保统筹基金支付");

Property GWYBZ As %String(CAPTION = "公务员补助");

Property SZBZ As %String(CAPTION = "师职补助");

Property DEBXBX As %String(CAPTION = "大额保险报销");

Property CDEBX As %String(CAPTION = "超大额报销");

Property DBBXBX As %String(CAPTION = "大病保险报销");

Property DBBCBXBX As %String(CAPTION = "大病补充保险报销");

Property YLJZ As %String(CAPTION = "医疗救助");

Property YYCDFY As %String(CAPTION = "医院承担费用");

Property CQJCF As %String(CAPTION = "产前检查费");

Property OTHERPAYAMOUNT As %String(CAPTION = "其他支付");

Property SELFPAYMENTAMOUNT As %String(CAPTION = "个人自付");

Property SELFMAINEXT As %String(CAPTION = "个性化其他项目信息");

Property TIME As %String(CAPTION = "时间戳");

}

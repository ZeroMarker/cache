Class BILL.EINV.DTO.XYHA.IPInvoiceMain Extends %RegisteredObject
{

Property ORGID As %String(CAPTION = " 机构编号 ");

Property EINVOICENAME As %String(CAPTION = " 电子票据名称 ");

Property EINVOICECODE As %String(CAPTION = " 电子票据代码 ");

Property EINVOICENUMBER As %String(CAPTION = " 电子票据号码 ");

Property INVOICETYPE As %String(CAPTION = " 开票类型 ");

Property VISITDATE As %String(CAPTION = " 入院时间 ");

Property PATIENTNUMBER As %String(CAPTION = " 住院号 ");

Property INVOICENO As %String(CAPTION = " 住院结算单据号 ");

Property FINHOSPDEPT As %String(CAPTION = " 入院科室代码 ");

Property FINHOSPDEPTNAME As %String(CAPTION = " 入院科室名称 ");

Property FINHOSPSTATUS As %String(CAPTION = " 入院状态 ");

Property FINHOSPDIA As %String(CAPTION = " 入院诊断代码 ");

Property FINHOSPDIANAME As %String(CAPTION = " 入院诊断名称 ");

Property FOUTHOSPDATE As %String(CAPTION = " 出院时间 ");

Property FOUTHOSPDEPT As %String(CAPTION = " 出院科室代码 ");

Property FOUTHOSPDEPTNAME As %String(CAPTION = " 出院科室名称 ");

Property FOUTHOSPSTATE As %String(CAPTION = " 出院状态 ");

Property FOUTHOSPDIA As %String(CAPTION = " 出院诊断代码 ");

Property FOUTHOSPDIANAME As %String(CAPTION = " 出院诊断名称 ");

Property FFACTINHOSPDAYS As %String(CAPTION = " 实际住院天数 ");

Property FDRCODE As %String(CAPTION = " 主治医师代码 ");

Property FDR As %String(CAPTION = " 主治医师 ");

Property FOPECODE As %String(CAPTION = " 手术代码 ");

Property FOPENAME As %String(CAPTION = " 手术名称 ");

Property TOTALAMOUNT As %String(CAPTION = " 总金额 ");

Property ISSUETIME As %String(CAPTION = " 开票时间 ");

Property INVOICINGCLERK As %String(CAPTION = " 开票员代码 ");

Property HANDLINGPERSON As %String(CAPTION = " 开票人 ");

Property CHECKER As %String(CAPTION = " 复核人 ");

Property CARDTYPE As %String(CAPTION = " 卡类型 ");

Property CARDNO As %String(CAPTION = " 卡号 ");

Property PAYERPARTYTYPE As %String(CAPTION = " 交款人类型 ");

Property PAYERPARTYCODE As %String(CAPTION = " 交款人代码 ");

Property PAYERPARTYNAME As %String(CAPTION = " 患者名称 ");

Property GENDER As %String(CAPTION = " 性别 ");

Property AGE As %String(CAPTION = " 年龄 ");

Property ADDRESS As %String(CAPTION = " 地址 ");

Property TEL As %String(CAPTION = " 联系电话 ");

Property PAYERACCT As %String(CAPTION = " 患者账号 ");

Property PAYEROPBK As %String(CAPTION = " 患者开户行 ");

Property PAYMODE As %String(CAPTION = " 交款方式(字典) ");

Property CURRENCYTYPE As %String(CAPTION = " 货币种类(字典) ");

Property EXCHANGERATE As %String(CAPTION = " 汇率    ");

Property SUPERVISORREMARK As %String(CAPTION = " 备注 ");

Property PATIENTTYPE As %String(CAPTION = " 病人类型 ");

Property MEDICALINSURANCETYPE As %String(CAPTION = " 医保类型");

Property MEDICALINSURANCEID As %String(CAPTION = " 医保编号 ");

Property CBDQ As %String(CAPTION = " 参保地区");

Property CASENUMBER As %String(CAPTION = " 病例号 ");

Property PREPAYAMOUNT As %String(CAPTION = " 预缴金额 ");

Property RECHARGEAMOUNT As %String(CAPTION = " 补缴金额 ");

Property REFUNDAMOUNT As %String(CAPTION = " 退费金额 ");

Property DEDUCTIBLE As %String(CAPTION = " 起付线　");

Property SELFPAYMENTCOST As %String(CAPTION = " 个人自费 ");

Property YLSZF As %String(CAPTION = " 乙类首自付　");

Property ABLZF As %String(CAPTION = " 按比例自付　");

Property OWNPAYAMOUNT As %String(CAPTION = " 个人现金支付 ");

Property ACCOUNTPAYAMOUNT As %String(CAPTION = " 个人账户支付 ");

Property FUNDPAYAMOUNT As %String(CAPTION = " 医保统筹基金支付 ");

Property GWYBZ As %String(CAPTION = " 公务员补助　");

Property SZBZ As %String(CAPTION = " 师职补助　");

Property DEBXBX As %String(CAPTION = " 大额保险报销　");

Property CDEBX As %String(CAPTION = " 超大额报销　");

Property DBBXBX As %String(CAPTION = " 大病保险报销　");

Property DBBCBXBX As %String(CAPTION = " 大病补充保险报销　");

Property YLJZ As %String(CAPTION = " 医疗救助　");

Property YYCDFY As %String(CAPTION = " 医院承担费用　");

Property CQJCF As %String(CAPTION = " 产前检查费　");

Property SELFMAINEXT As %String(CAPTION = " 个性化其他项目信息 ");

Property TIME As %String(CAPTION = " 时间戳 ");

}

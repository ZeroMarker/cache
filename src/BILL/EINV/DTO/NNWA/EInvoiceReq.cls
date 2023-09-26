/// 开票请求参数对象（安一附院高新分院(诺诺网)）
Class BILL.EINV.DTO.NNWA.EInvoiceReq Extends %RegisteredObject
{

/// 唯一业务流水号，用于标识不同的票据
Property bizCode As %String(CAPTION = "业务流水号");

/// 门诊：0601,住院：0602,预缴金：0609
Property classCode As %String(CAPTION = "票据种类代码");

Property relatedType As %String(CAPTION = "票据类型");

Property invoicingPartyCode As %String(CAPTION = "开票单位代码");

Property invoicingPartyName As %String(CAPTION = "开票单位名称");

/// 如果是多院区，此处为院区编号，如果冲红，此项可为空
Property placeCode As %String(CAPTION = "开票点编号");

Property recName As %String(CAPTION = "收款人名称");

Property handlingPerson As %String(CAPTION = "开票人名称");

Property checker As %String(CAPTION = "复核人名称");

Property payerPartyType As %String(CAPTION = "交款人类型");

/// 单位为社会信用代个人一般为身份证号
Property payerPartyCode As %String(CAPTION = "交款人代码");

Property payerPartyName As %String(CAPTION = "交款人名称");

Property gender As %String(CAPTION = "性别");

Property payerTel As %String(CAPTION = "交款人手机号");

Property payerEmail As %String(CAPTION = "交款人邮箱");

/// 缴费时使用的卡类型01：就诊卡 02：社保卡 03：户口簿 99：其他
Property cardType As %String(CAPTION = "卡类型");

Property cardNo As %String(CAPTION = "卡号");

Property address As %String(CAPTION = "地址");

Property totalAmount As %String(CAPTION = "总金额");

/// 1：现金；2：银行卡；3：支付宝；4：微信；9：其他
Property payMode As %String(CAPTION = "交款方式");

Property payerAcct As %String(CAPTION = "交款人账");

Property payerOpbk As %String(CAPTION = "交款人开户行");

Property businessNumber As %String(CAPTION = "业务单号");

Property businessDate As %String(CAPTION = "业务日期");

/// 门诊票补充此节点信息格式详见：Patient数据
Property patient As BILL.EINV.DTO.NNWA.EInvPatientData(CAPTION = "门诊票据");

/// 住院票补充此节点信息格式详见：Hospitalization数据
Property hospitalization As BILL.EINV.DTO.NNWA.EInvHospitalData(CAPTION = "住院票据");

/// 预缴金补充此节点信息格式详见：Prepay数据
Property prepay As BILL.EINV.DTO.NNWA.EInvPrepayData(CAPTION = "预缴金票据");

Property relatedBizCode As %String(CAPTION = "相关业务流水号");

Property relatedInvoiceCode As %String(CAPTION = "相关票据代码");

Property relatedInvoiceNumber As %String(CAPTION = "相关票据号码");

/// 1：退费 2：错开 3：换开纸质票 4：其他
Property relatedCancelType As %String(CAPTION = "冲红类型");

Property printEinvoiceCode As %String(CAPTION = "换开纸质票票据代码");

Property printEinvoiceNumber As %String(CAPTION = "换开纸质票票据号码");

Property cancelRemark As %String(CAPTION = "冲红备注");

/// 开票明细项目，详见Item数据，预缴金票据可为空
Property item As list Of BILL.EINV.DTO.NNWA.EInvItemData(CAPTION = "项目");

/// 医疗收费明细项目在此节点下添加，详见AuxItem，预缴金可为空
Property auxItem As list Of BILL.EINV.DTO.NNWA.EInvAuxItemData(CAPTION = "收费明细项目");

Property remark As %String(CAPTION = "备注");

}

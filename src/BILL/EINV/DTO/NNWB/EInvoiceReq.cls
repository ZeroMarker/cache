/// 诺诺网开票请求参数组织对象
Class BILL.EINV.DTO.NNWB.EInvoiceReq Extends %RegisteredObject
{

/// buyerName	String	Y	企业名称/个人	100	购方名称
Property buyerName As %String(CAPTION = " 购方名称");

/// buyerTaxNum	String	N		20	购方税号（企业要填，个人可为空）
Property buyerTaxNum As %String(CAPTION = " 购方税号");

/// buyerTel	String	N	0571-88888888	20	购方电话
Property buyerTel As %String(CAPTION = " 购方电话");

/// buyerAddress	String	N	杭州市	80	购方地址
Property buyerAddress As %String(CAPTION = " 购方地址");

/// buyerAccount	String	中国工商银行 111111N	100	购方银行账号及开户行地址
Property buyerAccount As %String(CAPTION = " 购方银行账号及开户行地址");

/// salerTaxNum	String	Y	20	销方税号（使用沙箱环境请求时消息体参数salerTaxNum和消息头参数userTax			9		填写🡪🡪9901999999142）
Property salerTaxNum As %String(CAPTION = " 销方税号");

/// salerTel	String	Y	0571-77777777	20	销方电话
Property salerTel As %String(CAPTION = " 销方电话");

/// salerAddress	String	Y		80	销方地址
Property salerAddress As %String(CAPTION = " 销方地址");

/// salerAccount	String	N		100	销方银行账号和开户行地址			201701051202079		
Property salerAccount As %String(CAPTION = " 销方银行账号和开户行地址");

/// orderNo	String	Y	20	订单号（每个企业唯一）
Property orderNo As %String(CAPTION = " 订单号");

/// invoiceDate	String	Y2016-01-1🡪 12:🡪0:0020	订单时间
Property invoiceDate As %String(CAPTION = " 订单时间");

/// invoiceCode	String	N	1259999156🡪0	12冲红时填写的对应蓝票发票代码（红票必填，不满12位请左补0）
Property invoiceCode As %String(CAPTION = " 冲红时填写的对应蓝票发票代码");

/// invoiceNum	String	N	001🡪0865	8冲红时填写的对应蓝票发票号码（红票必填，不满8位请左补0）
Property invoiceNum As %String(CAPTION = " 对应蓝票发票号码");

/// billInfoNo	String	N	16	发票信息表编号ZZZZZZZZZZZZZZZ72Z”字样，其  中“Z”为开具红字增值税专用发票所需要的长度为16位信息表编号。
Property billInfoNo As %String(CAPTION = " 发票信息表编号");

/// departmentId	String	N	9F7E94🡪9CA8B4 C60A2FFF🡪EA🡪2	部门门店id（诺诺系统中的id）90B088
Property departmentId As %String(CAPTION = " 部门门店id");

/// clerkId	String	N		🡪2	开票员id（诺诺系统中的id）
Property clerkId As %String(CAPTION = " 开票员id");

/// remark	String	N	
/// 备注信息	冲红时，在备注中注明“对应正数发票代码:XXXXXXXXX号码:YYYYYYYY”
/// 2🡪0	文案，其中“X”为发票代码，“Y”为发票号码，可以不填，接口会自动添加该文案；机动车发票蓝票时备注只能为空
Property remark As %String(CAPTION = " 备注信息");

/// checker	String	N	王五	20	复核人
Property checker As %String(CAPTION = " 复核人");

/// payee	String	N	李四	20	收款人
Property payee As %String(CAPTION = " 收款人");

/// clerk	String	Y	张三	20	开票员
Property clerk As %String(CAPTION = " 开票员");

/// listFlag	String	N	0	1	清单标志：非清单:0；清单:1，默认:0
Property listFlag As %String(CAPTION = " 清单标志");

/// listName	String	N	详见销货清单	清单项目名称：对应发票票面项目名称（li92	stFlag为1时，必填，默认为“详见销货清单”）
Property listName As %String(CAPTION = " 清单项目名称");

/// pushMode	String	N	1	推送方式：-1,不推送;0,邮箱;1,手机（默认2）;2,邮箱、手机
Property pushMode As %String(CAPTION = " 推送方式");

/// buyerPhone	String	Y	15858585858	购方手机（pushMode为1或2时，此项为20必填）
Property buyerPhone As %String(CAPTION = " 购方手机");

/// email	String	Y	test@xx.com推送邮箱（pushMode为0或2时，此项为50必填）
Property email As %String(CAPTION = " 推送邮箱");

/// invoiceType	String	Y	1	1	开票类型：1:蓝票;2:红票
Property invoiceType As %String(CAPTION = " 开票类型");

/// invoiceLine	String	N	p	1	发票种类：p,普通发票(电票)(默认);c,普通
Property invoiceLine As %String(CAPTION = " 发票种类");

/// productOilFlag	String	N	0	1	成品油标志：非成品油(默认):0;成品油:1代开标志：0非代开;1代开。代开蓝票时备注要求填写文案：代开企业税号:***,代开企
Property productOilFlag As %String(CAPTION = " 发票种类");

/// proxyInvoiceFlag	String	N	0	1	业名称:***；代开红票时备注要求填写文案：对应正数发票代码:***号码:***代开企业税号:***代开企业名称:***
Property proxyInvoiceFlag As %String(CAPTION = " 发票种类");

/// http:127.0.0.1/invoicallBackUrl	String	N	开票完成 传发票信息地址ce/callback/	
Property callBackUrl As %String(CAPTION = " 回调地址");

/// extensionNumber	String	N		5	分机号（只能为空或者数字）
Property extensionNumber As %String(CAPTION = " 分机号");

/// terminalNumber	String	N		4	终端号（开票终端号，只能 为空或数字）
Property terminalNumber As %String(CAPTION = " 终端号");

/// 发票明细，支持填写商品明细最大2000行invoiceDetail	Array	Y	100（包含折扣行、被折扣行）
Property invoiceDetail As list Of BILL.EINV.DTO.NNWB.EInvoiceDetails(CAPTION = " 发票明细");

/// 机动车销售发票明细
Property vehicleInfo As BILL.EINV.DTO.NNWB.EInvoicevehicleInfo(CAPTION = " 机动车销售发票");

}

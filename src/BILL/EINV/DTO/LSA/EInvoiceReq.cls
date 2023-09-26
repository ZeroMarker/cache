/// 广州乐税信息科技有限公司(乐税)--直连开票入参对象
Class BILL.EINV.DTO.LSA.EInvoiceReq Extends %RegisteredObject
{

/// 系统标识，由乐税提供
Property appID As %String(CAPTION = "系统标识");

/// 以秒为单位的当前时间--示例：1545043005
Property time As %String(CAPTION = "当前时间");

/// appid+appkey+time组成字符串，在用MD5加密出32位长度的字符串，字符串为小写
/// 示例：e2c2d9a797df245d54f668f9deefd7b7
Property token As %String(CAPTION = "加密字符串");

/// 单据流水号（唯一）
Property billGuid As %String(CAPTION = "单据流水号");

Property billNo As %String(CAPTION = "单据编号");

/// 跟医院沟通每个操作员的税盘分机号为固定值
Property sellMachineNo As %String(CAPTION = "税盘分机号");

/// 0：增值税专用发票（当发票类型为0时，不允许开具零税率发票） 2：增值税普通发票 51：增值税电子普通票
Property invType As %String(CAPTION = "票据类型");

/// 单据类型（乐税可根据单据类型定义备注，对接时再约定值）
Property billType As %String(CAPTION = "单据类型");

/// 单据来源（固定值，业务系统名称，传入NC）
Property billSource As %String(CAPTION = "单据来源");

/// 业务日期（单据生成日期）	N
Property bizDate As %String(CAPTION = "业务日期");

/// Y（跟buyTaxNo可二选一）
Property buyName As %String(CAPTION = "购方名称");

Property buyTaxNo As %String(CAPTION = "购方纳税人识别号");

/// O(可选参数)
Property buyBankAccount As %String(CAPTION = "购方开户账号");

Property buyAddrTel As %String(CAPTION = "购方地址电话");

/// N
Property note As %String(CAPTION = "备注");

Property sellName As %String(CAPTION = "销方名称");

Property sellTaxNo As %String(CAPTION = "销方税号");

/// O(可选参数)
Property sellAddrTel As %String(CAPTION = "销方地址及电话");

Property sellBankAccount As %String(CAPTION = "销方银行及账号");

/// 税收分类编码版本号（传默认值：33.0） N
Property goodsVersion As %String(CAPTION = "税收分类编码版本号");

/// O(可选参数)
Property cashier As %String(CAPTION = "收款人");

Property checker As %String(CAPTION = "复核人");

Property invoicer As %String(CAPTION = "开票人");

/// 合计税额（不传时，按明细税额累加） N
Property totalTaxAmount As %String(CAPTION = "合计税额");

/// 价税合计（不传时，按明细价税累加） N
Property totalAmount As %String(CAPTION = "价税合计");

/// 不含税总额（不传时，按明细不含税金额累加） N
Property totalAmountWithoutTax As %String(CAPTION = "不含税总额");

/// (红冲票时必传)  N
Property sourceinvCode As %String(CAPTION = "源正数发票代码");

Property sourceinvNo As %String(CAPTION = "源正数发票号码");

/// 值须为数值0（非红冲）或1（红冲），默认0  N
Property negativeFlag As %String(CAPTION = "红冲标识");

/// 专用发票且是负数票时需要输入（需在开票软件中申请红字发票信息表，税局审核通过后可以获取到） N
Property negNativeNo As %String;

Property details As list Of BILL.EINV.DTO.LSA.EInvoiceDetails(CAPTION = "单据明细");

}

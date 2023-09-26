/// 开票返回值处理对象
Class BILL.EINV.DTO.YDA.EInvoiceRes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "RetData";

/// 	 	返回状态  	<!-- 返回成功状态：4011，其他失败-->
Property RetCode As %String(TRUNCATE = 1);

/// 	 	相关提示	<!-- 4011-开票成功[0000,] -->
Property RetMsg As %String(TRUNCATE = 1);

/// 	 	发票代码
Property InfoTypeCode As %String(TRUNCATE = 1);

/// 	 	发票号码
Property InfoNumber As %String(TRUNCATE = 1);

/// 	 	合计不含税金额
Property InfoAmount As %String(TRUNCATE = 1);

/// 	 	合计税额
Property InfoTaxAmount As %String(TRUNCATE = 1);

/// 	 	开票日期
Property InfoInvDate As %String(TRUNCATE = 1);

/// 	 	所属月份
Property InfoMonth As %String(TRUNCATE = 1);

/// 	 	销货清单标志0无销货清单，1有销货清单
Property GoodsListFlag As %String(TRUNCATE = 1);

/// 	 	发票剩余份数
Property InvStock As %String(TRUNCATE = 1);

/// 	 	有票标志，0 为金税卡中无可开发票，1 为有票
Property IsInvEmpty As %String(TRUNCATE = 1);

}

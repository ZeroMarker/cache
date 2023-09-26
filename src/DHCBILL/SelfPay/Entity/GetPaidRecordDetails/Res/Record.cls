Class DHCBILL.SelfPay.Entity.GetPaidRecordDetails.Res.Record Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// OrderNo	缴费订单号
Property OrderNo As %String(TRUNCATE = 1);

/// InvoiceNo	票据流水号
Property InvoiceNo As %String(TRUNCATE = 1);

/// InvDate	消费日期
Property InvDate As %String(TRUNCATE = 1);

/// InvTime	消费时间
Property InvTime As %String(TRUNCATE = 1);

/// DurgWin 发药窗口
Property DurgWin As %String(TRUNCATE = 1);

/// TotalAmt	票据总金额
Property TotalAmt As %String(TRUNCATE = 1);

/// InsuShareAmt	医保垫付金额
Property InsuShareAmt As %String(TRUNCATE = 1);

/// PatShareAmt 患者自付金额	
Property PatShareAmt As %String(TRUNCATE = 1);

/// PayModeInfo 支付方式信息
Property PayModeInfo As %String(TRUNCATE = 1);

/// PrintFlag	发票打印标志
Property PrintFlag As %String(TRUNCATE = 1);

/// PrtInvNo	打印发票号
Property PrtInvNo As %String(TRUNCATE = 1);

/// AdmDate 就诊日期	
Property AdmDate As %String(TRUNCATE = 1);

/// AdmTime 就诊时间	
Property AdmTime As %String(TRUNCATE = 1);

/// AdmDept	就诊科室
Property AdmDept As %String(TRUNCATE = 1);

/// AdmDoctor	就诊医生
Property AdmDoctor As %String(TRUNCATE = 1);

/// ItemList	项目信息列表
Property ItemList As list Of DHCBILL.SelfPay.Entity.GetPaidRecordDetails.Res.Item(XMLITEMNAME = "Item", XMLPROJECTION = "COLLECTION");

}

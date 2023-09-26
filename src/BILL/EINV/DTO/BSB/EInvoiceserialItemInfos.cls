Class BILL.EINV.DTO.BSB.EInvoiceserialItemInfos Extends %RegisteredObject
{

/// itemCode	项目编码	String	20	否	
Property itemCode As %String(TRUNCATE = 1, XMLNAME = "itemCode");

/// itemName	项目名称	String	100	是	
Property itemName As %String(TRUNCATE = 1, XMLNAME = "itemName");

/// specification	规格型号	String	40	否
Property specification As %String(TRUNCATE = 1, XMLNAME = "specification");

/// units	单位	String	20	否	
Property units As %String(TRUNCATE = 1, XMLNAME = "units");

/// count	数量	Number	18	否	默认为  1
Property count As %String(TRUNCATE = 1, XMLNAME = "count");

/// unitPrice	单价	Number	18,6	否	
Property unitPrice As %String(TRUNCATE = 1, XMLNAME = "unitPrice");

/// amount	金额	Number	18,2	是	价税合计额
Property amount As %String(TRUNCATE = 1, XMLNAME = "amount");

/// itemExtendInfo	扩展信息	JSON	不限	否
Property itemExtendInfo As %String(TRUNCATE = 1, XMLNAME = "itemExtendInfo");

}

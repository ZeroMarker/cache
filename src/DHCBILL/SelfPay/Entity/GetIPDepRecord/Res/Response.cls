Class DHCBILL.SelfPay.Entity.GetIPDepRecord.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// RecordCount 记录数
Property RecordCount As %String(TRUNCATE = 1);

/// RecordList
Property RecordList As list Of DHCBILL.SelfPay.Entity.GetIPDepRecord.Res.Record(XMLITEMNAME = "Record", XMLPROJECTION = "COLLECTION");

}

Class DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1, XMLITEMNAME = "Result_Code");

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1, XMLITEMNAME = "Error_Msg");

/// ResultMsg 结果描述
Property ResultData As DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.ResultData(XMLITEMNAME = "Result_Data");

}

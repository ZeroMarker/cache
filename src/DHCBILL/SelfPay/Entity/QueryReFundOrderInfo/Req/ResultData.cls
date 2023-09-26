Class DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.ResultData Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

/// 列表
Property RecordList As list Of DHCBILL.SelfPay.Entity.GetBillDetails.Res.RecordList(XMLITEMNAME = "Record_List", XMLPROJECTION = "COLLECTION");

}

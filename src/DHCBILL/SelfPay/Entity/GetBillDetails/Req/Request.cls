Class DHCBILL.SelfPay.Entity.GetBillDetails.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// AdmID	就诊ID
Property AdmID As %String(TRUNCATE = 1);

/// StartDate 开始日期(OutFlag=0时有效)
Property StartDate As %String(TRUNCATE = 1);

/// EndDate 结束日期(OutFlag=0时有效)
Property EndDate As %String(TRUNCATE = 1);

/// OutFlag 输出类型(1显示医嘱明细,0显示收费明细)
Property OutFlag As %String(TRUNCATE = 1);

/// ExpStr	扩展串
Property ExpStr As %String(TRUNCATE = 1);

}

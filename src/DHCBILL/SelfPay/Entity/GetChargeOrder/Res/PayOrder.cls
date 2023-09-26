Class DHCBILL.SelfPay.Entity.GetChargeOrder.Res.PayOrder Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// OrderNo 结算单号
Property OrderNo As %String(TRUNCATE = 1);

/// OrderSum 结算单总额
Property OrderSum As %String(TRUNCATE = 1);

/// OrderInsuFlag 结算单号
Property OrderInsuFlag As %String(TRUNCATE = 1);

/// OrdInsuData 医保分解信息
Property OrdInsuData As %GlobalCharacterStream;

/// OrderInsType 费别描述
Property OrderInsType As %String(TRUNCATE = 1);

/// ItemList	就诊信息列表
Property ItemList As list Of DHCBILL.SelfPay.Entity.GetChargeOrder.Res.Item(XMLITEMNAME = "Item", XMLPROJECTION = "COLLECTION");

}

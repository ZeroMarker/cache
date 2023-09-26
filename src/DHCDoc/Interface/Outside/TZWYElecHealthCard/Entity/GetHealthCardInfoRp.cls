Class DHCDoc.Interface.Outside.TZWYElecHealthCard.Entity.GetHealthCardInfoRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property data As DHCDoc.Interface.Outside.TZWYElecHealthCard.Entity.List.GetHealthCardInfoListRp;

/// 交易结果：0：成功 非0：错误
Property success As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property errCode As %String(TRUNCATE = 1);

Property errMsg As %String(TRUNCATE = 1);

}

Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.SignRq Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 基础标签
Property base As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Base(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// 医生工号
Property docid As %String(TRUNCATE = 1, XMLNAME = "doc_id");

/// 医生姓名
Property docname As %String(TRUNCATE = 1, XMLNAME = "doc_name");

/// 医生反馈信息
Property feedback As DHCDoc.Interface.Outside.HLYYHZYY.Entity.FeedBack(XMLNAME = "feed_back", XMLPROJECTION = "ELEMENT");

}

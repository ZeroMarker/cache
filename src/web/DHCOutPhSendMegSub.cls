Class web.DHCOutPhSendMegSub Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLNAME = "SubPha";

//PhCode 药品代码

Property PhCode As %String(TRUNCATE = 1);

//基本单位数量

Property PhQty As %String(TRUNCATE = 1);

//单价

Property PhPrice As %String(TRUNCATE = 1);

//自付比例

Property SelfPayScale As %String(TRUNCATE = 1);

//公费标记

Property Bursary As %String(TRUNCATE = 1);

}

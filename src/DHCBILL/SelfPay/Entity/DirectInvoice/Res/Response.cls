/// / Creator:TianZJ
/// / CreatDate:2022-04-14
/// / Description:获取导诊单打印数据出参类
Class DHCBILL.SelfPay.Entity.DirectInvoice.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// PatNo 登记号
Property PatNo As %String(TRUNCATE = 1);

/// PatName 姓名
Property PatName As %String(TRUNCATE = 1);

/// Age 年龄
Property Age As %String(TRUNCATE = 1);

/// UserCode 收费员
Property UserCode As %String(TRUNCATE = 1);

/// PrtDate 收费日期
Property PrtDate As %String(TRUNCATE = 1);

/// AdmReason 费别
Property AdmReason As %String(TRUNCATE = 1);

/// Amount 金额
Property Amount As %String(TRUNCATE = 1);

/// ArcType 项目分类
Property ArcType As %String(TRUNCATE = 1);

/// RegLoc 接收科室
Property RegLoc As %String(TRUNCATE = 1);

/// LocAdress 科室地址
Property LocAdress As %String(TRUNCATE = 1);

/// InvocieURL 电子发票地址
Property InvocieURL As %String(TRUNCATE = 1);

/// ItemList	项目列表列表
Property ItemLists As list Of DHCBILL.SelfPay.Entity.DirectInvoice.Res.ItemList(XMLITEMNAME = "ItemList", XMLPROJECTION = "COLLECTION");

}

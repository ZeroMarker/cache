Class DHCBILL.SelfPay.Entity.GetPaidRecordDetails.Res.Item Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ItemCode 项目代码
Property ItemCode As %String(TRUNCATE = 1);

/// ItemName 项目名称
Property ItemName As %String(TRUNCATE = 1);

/// ItemCategory 项目分类
Property ItemCategory As %String(TRUNCATE = 1);

/// ItemRecDept 接收科室
Property ItemRecDept As %String(TRUNCATE = 1);

/// ItemPrice 项目单价
Property ItemPrice As %String(TRUNCATE = 1);

/// ItemQty 项目数量
Property ItemQty As %String(TRUNCATE = 1);

/// ItemSum 项目金额
Property ItemSum As %String(TRUNCATE = 1);

/// ItemUom 项目单位
Property ItemUom As %String(TRUNCATE = 1);

/// ItemSpecs 项目规格
Property ItemSpecs As %String(TRUNCATE = 1);

}

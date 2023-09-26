Class DHCBILL.ScanPay.Entity.HSYT.ScanRefOutput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Property 第三方属性名  XMLNAME  His端名称 
Parameter XMLSEQUENCE = 0;

// =0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

Property Header As DHCBILL.ScanPay.Entity.HSYT.ScanHead(XMLNAME = "Head", XMLPROJECTION = "ELEMENT");

Property Body As DHCBILL.ScanPay.Entity.HSYT.ScanRefundOut(XMLNAME = "Body", XMLPROJECTION = "ELEMENT");

}

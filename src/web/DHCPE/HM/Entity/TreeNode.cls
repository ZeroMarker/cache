Class web.DHCPE.HM.Entity.TreeNode Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

// 输出空值元素

Parameter XMLIGNORENULL = 1;

// 忽略意外元素

Parameter XMLIGNOREINVALIDTAG = 0;

// 忽略意外属性

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Property id As %String;

Property text As %String;

Property iconCls As %String;

Property children As list Of web.DHCPE.HM.Entity.TreeNode;

}

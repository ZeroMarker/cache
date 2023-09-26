Class web.DHCPE.ArcimManager.Entity.TreeNode Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

// 输出空值元素

Parameter XMLIGNORENULL = 1;

// 忽略意外元素

Parameter XMLIGNOREINVALIDTAG = 0;

// 忽略意外属性

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Property parentId As %String;

Property id As %String;

Property text As %String;

Property desc As %String;

Property iconCls As %String;

Property code As %String;

Property type As %String;

Property sourceId As %String;

Property condition As web.DHCPE.ArcimManager.Entity.NodeCondition;

Property children As list Of web.DHCPE.ArcimManager.Entity.TreeNode;

Property week0 As %String;

Property week1 As %String;

Property week2 As %String;

Property week3 As %String;

Property week4 As %String;

Property week5 As %String;

Property week6 As %String;

}

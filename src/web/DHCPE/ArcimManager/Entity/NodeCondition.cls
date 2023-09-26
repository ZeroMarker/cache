Class web.DHCPE.ArcimManager.Entity.NodeCondition Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

// 输出空值元素

Parameter XMLIGNORENULL = 1;

// 忽略意外元素

Parameter XMLIGNOREINVALIDTAG = 0;

// 忽略意外属性

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Property sexId As %String;

Property vipLevel As %String;

Property minAge As %String;

Property maxAge As %String;

}

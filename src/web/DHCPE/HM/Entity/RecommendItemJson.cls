Class web.DHCPE.HM.Entity.RecommendItemJson Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

// 输出空值元素

Parameter XMLIGNORENULL = 1;

// 忽略意外元素

Parameter XMLIGNOREINVALIDTAG = 0;

// 忽略意外属性

Parameter XMLIGNOREINVALIDATTRIBUTE = 0;

Property total As %Integer;

Property rows As list Of web.DHCPE.HM.Entity.RecommendItem;

}

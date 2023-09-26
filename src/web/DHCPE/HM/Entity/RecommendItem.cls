Class web.DHCPE.HM.Entity.RecommendItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

// 输出空值元素

Parameter XMLIGNORENULL = 1;

// 忽略意外元素

Parameter XMLIGNOREINVALIDTAG = 0;

// 忽略意外属性

Parameter XMLIGNOREINVALIDATTRIBUTE = 0;

Property Seq As %Integer;

Property OrdSetsDR As %Integer;

Property OrdSetsDesc As %String;

Property Relevance As %Float;

Property Note As %String;

Property DetailIds As %String;

Property OrdSetsType As %String;

Property OrdSetsPrice As %String;

}

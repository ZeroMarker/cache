Class web.DHCENS.STBLL.LIS.MODEL.PatLisOrdListInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PatLisOrdListInfo";

Property OrderList As list Of web.DHCENS.STBLL.LIS.MODEL.PatLisOrdInfo(XMLNAME = "OrderList");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 10, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 10, XMLNAME = "UpdateTime");

}

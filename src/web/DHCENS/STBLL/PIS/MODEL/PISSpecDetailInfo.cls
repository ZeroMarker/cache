Class web.DHCENS.STBLL.PIS.MODEL.PISSpecDetailInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "SpecInfo";

/// 标本序号
Property SpecNO As %String(MAXLEN = "");

/// 标本名称
Property SpecName As %String(MAXLEN = "");

/// 标本部位
Property SpecPosition As %String(MAXLEN = "");

/// 标本数量
Property SpecQty As %String(MAXLEN = "");

/// 原病理号
Property OriginalNO As %String(MAXLEN = "");

/// 标本离体时间
Property SepDate As %String(MAXLEN = "");

/// 标本固定时间
Property FixDate As %String(MAXLEN = "");

}

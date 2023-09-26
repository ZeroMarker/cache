Class web.DHCENS.STBLL.BOOKREG.MODEL.BookRegService Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "BookRegRt";

/// 交易代码
Property TradeCode As %Library.String;

/// 预约机构
Property ExtOrgCode As %Library.String;

/// 客户端类型
Property ClientType As %Library.String;

/// 医院唯一编号
Property HospitalId As %Library.String;

/// 操作员代码
Property ExtUserID As %Library.String;

/// 交易流水号
Property TransactionId As %Library.String;

/// 预约单号
Property OrderCode As %Library.String;

}

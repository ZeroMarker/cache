Class web.DHCENS.STBLL.DICT.MODEL.CTOperation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_Operation";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 批准标志
Property ApprovedIndicator As %Library.String(MAXLEN = 5, XMLNAME = "ApprovedIndicator");

/// 有效开始日期
Property CTOPStartDate As %Library.Date(XMLNAME = "CTOP_StartDate");

/// 状态
Property CTOPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOP_Status");

/// 最后更新日期
Property CTOPUpdateDate As %Library.Date(XMLNAME = "CTOP_UpdateDate");

/// 最后更新时间
Property CTOPUpdateTime As %Library.Time(XMLNAME = "CTOP_UpdateTime");

/// 最后更新人编码
Property CTOPUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTOP_UpdateUserCode");

/// 手术代码
Property OperationCode As %Library.String(MAXLEN = 20, XMLNAME = "OperationCode");

/// 手术名称
Property OperationName As %Library.String(MAXLEN = 100, XMLNAME = "OperationName");

/// 手术等级
Property OperationScale As %Library.String(MAXLEN = 10, XMLNAME = "OperationScale");

/// 操作类型
Property OperationType As %Library.String(MAXLEN = 10, XMLNAME = "OperationType");

/// 正名标志
Property StdIndicator As %Library.String(MAXLEN = 5, XMLNAME = "StdIndicator");

}

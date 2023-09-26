Class web.DHCENS.STBLL.BOOKREG.MODEL.RepBookService Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "RepBookService";

// Property TradeResultCode As %Library.String;

// Property TradeResultContent As %Library.String;

/// 交易结果：0：成功 非0：错误
/// 对错误/异常的详细描述信息
/// 挂号序号
Property SeqCode As %Library.String;

/// 预约单号
Property OrderCode As %Library.String;

/// 就诊时间段
Property AdmitRange As %Library.String;

/// 挂号费
Property RegFee As %Library.String;

/// 就诊地点
Property AdmitAddress As %Library.String;

/// 预约单内容
Property OrderContent As %Library.String;

/// 交易流水号
Property TransactionId As %Library.String;

}

Class web.DHCEkg.SystemStatus.Dict.QueryResponse Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Response";

/// 医嘱号,必填
Property OEOrdItemID As %String;

/// 检查部位
Property Position As %String;

/// 检查号,必填
Property ExamID As %String;

/// 状态
Property Status As %String;

/// 操作人工号
Property UserID As %String;

/// 操作人姓名
Property UserName As %String;

/// 操作时间日期
Property UpDateTime As %String;

/// 来源系统
Property SourceSystem As %String;

/// 正逆流程标识
Property ProcessFlag As %String;

}

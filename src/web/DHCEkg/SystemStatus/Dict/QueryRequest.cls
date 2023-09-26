Class web.DHCEkg.SystemStatus.Dict.QueryRequest Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

/// 医嘱号,必填
Property OEOrdItemID As %String;

/// 检查号,必填
Property ExamID As %String;

}

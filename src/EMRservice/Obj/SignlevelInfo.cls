Class EMRservice.Obj.SignlevelInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "SignlevelInfo";

Parameter XMLTYPE = "SignlevelInfo";

Parameter XMLIGNORENULL = 1;

/// 模板签名级别Code
/// 
Property LevelCode As %String;

/// 模板签名级别描述
Property LevelDesc As %String;

/// 模板/模板标题 信息
Property SignTemp As EMRservice.Obj.SignTempInfo;

}

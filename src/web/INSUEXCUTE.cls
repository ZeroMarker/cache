Class web.INSUEXCUTE Extends %RegisteredObject [ LegacyInstanceContext, ProcedureBlock ]
{

/// ZhanMingchao 20150320
/// 执行任意类方法或query
/// 封装base64加密，支持中? 
/// 请不要改动此? 
Parameter Split As %String = "$@";

/// 执行类方法或Query，入参个数不限制，返回数据长度不限制  
/// 	入参:ClassName:类名，methodName：函数名,inArgs:可变参数个数取决于被调用的函? 
/// 	入参的个数不固定，返回数据长度不限制  
/// 	调用示例:
/// 	w ##class(web.INSUEXCUTE).Excute("Testweb","test","1")
/// 	w ##class(web.INSUEXCUTE).Excute("web.INSUTest","Testweb2","1","5Lit5Y2O5Lq65rCR")
ClassMethod Excute(ClassName As %String = "", methodName As %String = "", inArgs...) As %GlobalCharacterStream
{
}

/// 执行类方法或Query，入参个数不限制，返回数据长度不限制  
/// 	inArgs:入参?$@"分隔  
/// inArgs arg1$@arg2$@arg3$@………?
/// 	w ##class(web.INSUEXCUTE).ExcuteLong("web.INSUTest","Testweb2","1$@2")
ClassMethod ExcuteLong(ClassName As %String = "", methodName As %String = "", inArgs As %String) As %GlobalCharacterStream
{
}

/// 执行类方法或Query，入参个数不限制，返回数据长度不限制,兼容老版? 
/// 	入参:p1~p16  
/// 	入参的个数不大于16个，返回数据长度不限? 
/// 	调用示例:  
/// 	w ##class(web.INSUEXCUTE).Excute("Testweb","test","1")
/// 	w ##class(web.INSUEXCUTE).Excute("web.INSUTest","Testweb2","1","5Lit5Y2O5Lq65rCR")
ClassMethod ExcuteOld(ClassName As %String = "", methodName As %String = "", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %GlobalCharacterStream
{
}

/// 修改base64加密，使支持中文  
ClassMethod base64Encode(inVal) As %GlobalCharacterStream
{
}

/// 修改base64解密，使支持中文  
ClassMethod base64Decode(inVal) As %GlobalCharacterStream
{
}

ClassMethod base64DecodeStr(inVal) As %String
{
}

}

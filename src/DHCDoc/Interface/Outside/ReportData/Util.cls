/// creator：郭荣勇
/// date：2019-04-10
/// desc：接口数据获取工具类
Class DHCDoc.Interface.Outside.ReportData.Util Extends %RegisteredObject
{

/// @param : %String jsonstr  指向字段传入Id就成 	{ID:2,PAADMPAPMIDR:1,...}
/// @param : %String className
/// 把jsonstr转成className类的对象
ClassMethod ObjectFromJSON(jsonstr As %String, className As %String) As %ObjectHandle
{
	Q ##class(ext.util.JsonObject).FromJSON(jsonstr).Bean(className)
}

/// @date   2017-07-28
/// @param: Object  pObject  要转换成JSON流的对象
/// @param: %GlobalCharacterStream  pStream	JSON流
/// @param: %String  pClass 不传入默认为$classname(Obj)
/// @param: ext.util.JsonObject jsonObject 确定Obj转成什么样的Json
/// 对象转JSON流
/// Other:存在的问题，如果json传超长，可能会报“字符串超长”的错误
ClassMethod ObjectToJSONStream(pObject As %RegisteredObject, ByRef pStream, pClass As %String = "", jsonObject As ext.util.JsonObject = "") As %Status
{
	Q ##class(ext.util.JsonObject).ObjectToJSONStream(.pObject,.pStream,pClass,.jsonObject)
}

/// @author Lid
/// @date   2017-07-28
/// @param: Object  pStream  要转换成对象的json数据流
/// @param: %RegisteredObject pObject 要转换的对象
/// @param: %String  pClass	要转换的对象的类名，不传入默认为$classname(pObject)
/// JSON流转为对象
ClassMethod JSONStreamToObject(pStream, Output pObject As %RegisteredObject, pClass As %String = "") As %Status
{
	Q ##class(ext.util.JsonObject).JSONStreamToObject(pStream,.pObject,pClass)
}

}

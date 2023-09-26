/// Creator: Huxiaotian 2018-12-03
/// Description: 该类用于封装对象,对象的属性可以根据需要扩展
/// Others: 
/// 	(1)转JSON前用于存放对象结构的数据(键值对), {key:val, key:val, key:val}
/// 	(2)本类主要提供的方法:
/// 	obj.Set(key, val)
/// 	obj.Get(key)
/// 	obj.ToJSON()
/// 	obj.WriteJSON()
/// 	obj.FromJSON()
Class web.DHCST.Object Extends %RegisteredObject
{

Property %data As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Method %DispatchGetProperty(pProperty As %String)
{
	Quit $G(..%data(pProperty))
}

Method %DispatchSetProperty(pProperty As %String, pValue As %String)
{
	If ('$D(..%data(pProperty)) || (..%data(pProperty)'=pValue)) {
		Set ..%data(pProperty) = pValue
	}
}

/// 2019-05-06 -- new add Hxt
Method Get(pProperty As %String)
{
	Quit $G(..%data(pProperty))
}

Method Set(pProperty As %String, pValue As %String)
{
	If ('$D(..%data(pProperty)) || (..%data(pProperty)'=pValue)) {
		Set ..%data(pProperty) = pValue
	}
	Quit $this
}

Method %Clear()
{
	Kill ..%data
}

/// =======================以下为转JSON的核心方法=======================
/// Creator: Huxiaotian 2018-12-03
/// Desc: 数组转成JSON字符串
/// Output: {key:val, key:[], key:{}}
Method ToJSON()
{
	Quit ##class(web.DHCST.JSONUtils).ObjToJSON($this)
}

/// Creator: Huxiaotian 2018-12-03
/// Desc: 数组Write为JSON
/// Output: {key:val, key:[], key:{}}
Method WriteJSON()
{
	Do ##class(web.DHCST.JSONUtils).ObjWriteAsJSON($this)
}

/// Creator: Huxiaotian 2019-10-22
/// Desc: 把json字符串转成对象,方便取值
/// Output: 由web.DHCST.Array和web.DHCST.Object嵌套组成的对象
/// w ##class(web.DHCST.Object).FromJSON()
ClassMethod FromJSON(jsonStr) As web.DHCST.Object
{
	Quit ##class(web.DHCST.JSONUtils).%New().FromJSON(jsonStr)
}

}

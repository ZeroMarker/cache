/// Creator: Huxiaotian 2018-12-03
/// Description: 该类用于封装对象,对象的属性可以根据需要扩展
/// Others: 
/// 	(1)转JSON前用于存放对象结构的数据(键值对), {key:val, key:val, key:val}
/// 	(2)本类主要提供的方法:
/// 	s obj = ##class(web.DHCPE.Utils.Object).%New()
/// 	obj.Set(key, val) 	// s obj.key = val
/// 	obj.Get(key) 		// s val = obj.key
/// 	obj.Next(.key, .val)
/// 	obj.Remove(key)
/// 	obj.Size()
/// 	obj.Clear()
/// 	obj.ToJSON()
/// 	obj.WriteJSON()
/// 	obj.FromJSON()
Class web.DHCPE.Utils.Object Extends %RegisteredObject
{

Property %data As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %len As %Integer [ InitialExpression = 0 ];

Property %nIdx As %Integer [ InitialExpression = 0 ];

Method %DispatchGetProperty(pProperty As %String)
{
	q $g(..%data(pProperty))
}

Method %DispatchSetProperty(pProperty As %String, pValue As %String)
{
	if ('$d(..%data(pProperty)) || (..%data(pProperty)'=pValue)) {
		s ..%data(pProperty) = pValue
		s ..%len = ..%len + 1
	}
}

/// 2019-05-06 -- new add Hxt
Method Get(pProperty As %String)
{
	q $g(..%data(pProperty))
}

Method Set(pProperty As %String, pValue As %String)
{
	if ('$d(..%data(pProperty)) || (..%data(pProperty)'=pValue)) {
		s ..%data(pProperty) = pValue
		s ..%len = ..%len + 1
	}
	q $this
}

/// 2020-03-18 -- new add Hxt
Method Next(ByRef pProperty = "", ByRef pValue = "")
{
	s ..%nIdx = $o(..%data(pProperty))
	q:..%nIdx="" 0
	s pProperty = ..%nIdx
	s pValue = $g(..%data(pProperty))
	q 1
}

Method Remove(pProperty)
{
	q:pProperty="" 0
	q:'$d(..%data(pProperty)) 1
	k ..%data(pProperty)
	s ..%len = ..%len - 1
	q 1
}

Method Size()
{
	q +(..%len)
}

Method Clear()
{
	k ..%data
	s ..%len = 0
	q 1
}

/// =======================以下为转JSON的核心方法=======================
/// Creator: Huxiaotian 2018-12-03
/// Desc: 数组转成JSON字符串
/// Output: {key:val, key:[], key:{}}
Method ToJSON()
{
	Quit ##class(web.DHCPE.Utils.JSONUtils).ObjToJSON($this)
}

/// =======================以下为转JSON的核心方法=======================
/// Creator: Huxiaotian 2018-12-03
/// Desc: 数组转成JSON字符串
/// Output: {key:val, key:[], key:{}}
Method ToJSONStream(Stream)
{
	Quit ##class(web.DHCPE.Utils.JSONUtils).ObjToJSON($this,"",.Stream)
}

/// Creator: Huxiaotian 2018-12-03
/// Desc: 数组Write为JSON
/// Output: {key:val, key:[], key:{}}
Method WriteJSON()
{
	Do ##class(web.DHCPE.Utils.JSONUtils).ObjWriteAsJSON($this)
	Quit ""
}

/// Creator: Huxiaotian 2019-10-22
/// Desc: 把json字符串转成对象,方便取值
/// Output: 由web.DHCST.Array和web.DHCPE.Utils.Object嵌套组成的对象
/// w ##class(web.DHCPE.Utils.Object).FromJSON()
ClassMethod FromJSON(jsonStr) As web.DHCPE.Utils.Object
{
	Quit ##class(web.DHCPE.Utils.JSONUtils).%New().FromJSON(jsonStr)
}

}

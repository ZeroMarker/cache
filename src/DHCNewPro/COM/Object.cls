/// Creator: qunianpeng <引用> Huxiaotian 2018-12-03
/// Description: 该类用于封装对象,对象的属性可以根据需要扩展
/// Others: 
/// 	(1)转JSON前用于存放对象结构的数据(键值对), {key:val, key:val, key:val}
/// 	(2)本类主要提供的方法:
/// 	s obj = ##class(DHCNewPro.COM.Object).%New()
/// 	obj.Set(key, val) 	// s obj.key = val
/// 	obj.Get(key) 		// s val = obj.key
/// 	obj.Next(.key, .val)
/// 	obj.Remove(key)
/// 	obj.Size()
/// 	obj.Clear()
/// 	obj.ToJSON()
/// 	obj.WriteJSON()
/// 	obj.FromJSON()
Class DHCNewPro.COM.Object Extends %RegisteredObject
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
/// Creator: 2018-12-03
/// Desc: 数组转成JSON字符串
/// Output: {key:val, key:[], key:{}}
Method ToJSON()
{
	Quit ##class(DHCNewPro.COM.JSONUtils).ObjToJSON($this)
}

/// Creator: 2018-12-03
/// Desc: 数组Write为JSON
/// Output: {key:val, key:[], key:{}}
Method WriteJSON()
{
	Do ##class(DHCNewPro.COM.JSONUtils).ObjWriteAsJSON($this)
	Quit ""
}

/// Creator: 2019-10-22
/// Desc: 把json字符串转成对象,方便取值
/// Output: 由web.DHCST.Array和PHA.COM.Object嵌套组成的对象
/// w ##class(DHCNewPro.COM.Object).FromJSON()
ClassMethod FromJSON(jsonStr) As DHCNewPro.COM.Object
{
	Quit ##class(DHCNewPro.COM.JSONUtils).%New().FromJSON(jsonStr)
}

}

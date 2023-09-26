/// Creator: qunianpeng <引用> Huxiaotian 2018-12-03
/// Description: 
/// Others: 
/// 	(1)转JSON前用于存放数组结构的数据, [val, val, val]
/// 	(2)本类主要提供的方法:
/// 	s arr = ##class(DHCNewPro.COM.Array).%New()
/// 	arr.Insert(element)
/// 	arr.Push(element)
/// 	arr.Pop()
/// 	arr.Remove(index)
/// 	arr.Get(index)
/// 	arr.Set(index,element)
/// 	arr.Size()
/// 	arr.Next()
/// 	arr.Clear()
/// 	arr.ToJSON()
/// 	arr.WriteJSON()
/// 	arr.FromSON(jsonStr)
Class DHCNewPro.COM.Array Extends %RegisteredObject
{

Property %arr As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

Property %len As %Integer [ InitialExpression = 0 ];

Property %pIdx As %Integer [ InitialExpression = 0 ];

Property %nIdx As %Integer [ InitialExpression = 0 ];

/// Creator: Huxiaotian 2019-10-13
/// Desc: 元素操作方法
Method Insert(element)
{
	s ..%arr(..%len) = element
	s ..%len = ..%len + 1
	q 1
}

Method Push(element)
{
	s ..%arr(..%len) = element
	s ..%len = ..%len + 1
	q 1
}

Method Pop()
{
	s ..%pIdx = $o(..%arr(""),-1)
	s v = ..%arr(..%pIdx)
	k ..%arr(..%pIdx)
	s ..%len = ..%len - 1
	q v
}

Method Remove(index)
{
	q:index="" 0
	q:'$d(..%arr(index)) 1
	k ..%arr(index)
	s ..%len = ..%len - 1
	q 1
}

Method Set(index, element)
{
	q:index="" 0
	i '$d(..%arr(index)) s ..%len = ..%len + 1
	s ..%arr(index) = element
	q 1
}

Method Get(index)
{
	q:index="" ""
	q $g(..%arr(index))
}

Method Size()
{
	q +(..%len)
}

Method Next(ByRef k = "", ByRef v = "")
{
	s ..%nIdx = $o(..%arr(k))
	q:..%nIdx="" 0
	s k = ..%nIdx
	s v = $g(..%arr(k))
	q 1
}

Method Clear()
{
	k ..%arr
	s ..%len = 0
	s ..%pIdx = 0
	s ..%nIdx = 0
	q 1
}

/// =======================以下为转JSON的核心方法=======================
/// Creator: 2018-12-03
/// Desc: 数组转成JSON字符串
/// Output: [val,[],{key:val,key:val}]
Method ToJSON()
{
	Quit ##class(DHCNewPro.COM.JSONUtils).ObjToJSON($this)
}

/// Creator: 2018-12-03
/// Desc: 数组Write为JSON
/// Output: [val,[],{key:val,key:val}]
Method WriteJSON()
{
	Do ##class(DHCNewPro.COM.JSONUtils).ObjWriteAsJSON($this)
	Quit ""
}

/// Creator: Huxiaotian 2019-10-22
/// Desc: 把json字符串转成对象,方便取值
/// Output: 由PHA.COM.Array和web.DHCST.Object嵌套组成的对象
/// w ##class(DHCNewPro.COM.Array).FromJSON()
ClassMethod FromJSON(jsonStr) As DHCNewPro.COM.Array
{
	Quit ##class(DHCNewPro.COM.JSONUtils).%New().FromJSON(jsonStr)
}

}

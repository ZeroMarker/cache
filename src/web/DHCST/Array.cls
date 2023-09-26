/// Creator: Huxiaotian 2018-12-03
/// Description: 该类继承自%ListOfDataTypes,可以使用%ListOfDataTypes的所有方法
/// Others: 
/// 	(1)转JSON前用于存放数组结构的数据, [val, val, val]
/// 	(2)本类主要提供的方法:
/// 	arr.Push(element) / arr.Insert(element)
/// 	arr.Get(index)
/// 	arr.ToJSON()
/// 	arr.WriteJSON()
/// 	arr.FromSON(jsonStr)
Class web.DHCST.Array Extends (%RegisteredObject, %ListOfDataTypes)
{

/// Creator: Huxiaotian 2019-10-13
/// Desc: 元素操作方法
Method Push(element)
{
	d $this.Insert(element)
}

Method Get(index)
{
	q $this.GetAt(index)
}

/// =======================以下为转JSON的核心方法=======================
/// Creator: Huxiaotian 2018-12-03
/// Desc: 数组转成JSON字符串
/// Output: [val,[],{key:val,key:val}]
Method ToJSON()
{
	Quit ##class(web.DHCST.JSONUtils).ObjToJSON($this)
}

/// Creator: Huxiaotian 2018-12-03
/// Desc: 数组Write为JSON
/// Output: [val,[],{key:val,key:val}]
Method WriteJSON()
{
	Do ##class(web.DHCST.JSONUtils).ObjWriteAsJSON($this)
}

/// Creator: Huxiaotian 2019-10-22
/// Desc: 把json字符串转成对象,方便取值
/// Output: 由web.DHCST.Array和web.DHCST.Object嵌套组成的对象
/// w ##class(web.DHCST.Array).FromJSON()
ClassMethod FromJSON(jsonStr) As web.DHCST.Array
{
	Quit ##class(web.DHCST.JSONUtils).%New().FromJSON(jsonStr)
}

}

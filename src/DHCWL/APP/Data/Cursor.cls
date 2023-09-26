Class DHCWL.APP.Data.Cursor Extends %RegisteredObject
{

/// <method>MoveToFirst</mothod>直接将游标移动到数据集的开始位置。该方法会返回游标位置的对象引用。<br>
Method MoveToFirst() As Cursor
{
}

/// <method>MoveToLast</mothod>直接将游标移动到数据集的最后位置。该方法会返回游标位置的对象引用。<br>
Method MoveToLast() As Cursor
{
}

/// <method>MoveToLast</mothod>该方法的作用时将游标移动到指定的index位置处，并返回该位置的游标，若位置index非法就返回空。<br>
/// <var>index</var>数据集位置index
Method MoveTo(index) As Cursor
{
}

/// <method>Next</mothod>迭代到下一个游标位置。该方法会返回游标位置的对象引用。<br>
Method Next() As Cursor
{
}

/// <method>Next</mothod>迭代到上一个游标位置。该方法会返回游标位置的对象引用。<br>
Method Previous() As Cursor
{
}

/// <method>Get</mothod>该方法的作用是得到该游标位置给定property属性的属性值。若属性表示的是一个复合属性则返回Cursor引用，然后可以根据该引用进一步访问属性值。<br>
/// <var>propertyName</var>参为属性名字propertyName，若访问该属性下的复合属性的属性值则用paraProName.childProName的形式，用英文点号分割。
Method Get(propertyName As %String, index = "")
{
}

/// <method>GetArraySize</mothod>该方法的作用是若给定propertyName属性是一个数组则返回该数组的大小<br>
/// <var>propertyName</var>参为属性名字propertyName
Method GetArraySize(propertyName As %String) As %Integer
{
}

/*
/// <method>Set</mothod>该方法的作用是设置该游标位置给定property属性的属性值。若属性表示的是一个复合属性则返回Cursor引用，然后可以根据该引用进一步访问属性值。<br>
/// <var>property</var>参为属性名字property，若访问该属性下的复合属性的属性值则用paraProName.childProName的形式，用英文点号分割。<br>
/// <var>value</var>要设置的属性值value
Method Set(property, value) As %Status
{
}
*/
/// <method>IsFirst</method>判定当前游标是否已经在开始数据集的位置。<br>
Method IsFirst() As %Boolean
{
}

/// <method>IsFirst</method>判定当前游标是否已经在最后一个数据集的位置。<br>
Method IsLast() As %Boolean
{
}

/// <method>SetScope</method>设定游标可以游动的数据集范围
/// <var>from</var>开始位置；<var>end</var>结束位置
Method SetScope(from = 1, end = 0)
{
}

/// <method>GetScopeFrom</method>获取数据区间的开始区间位置
Method GetScopeFrom() As %String
{
}

/// <method>GetScopeTo</method>获取数据区间的结束区间位置
Method GetScopeTo() As %String
{
}

/// <method>ValidateDomain</method>检查该游标当前所在的索引位置是否是合法的。
Method ValidateDomain(index = "", from = "", end = "") As %Boolean
{
}

/// <method>GetMeta</method>获取该数据集下的定义信息，返回Meta对象的定义
/// 
Method GetMeta() As Meta
{
}

/// <method>GetPivot</method>获取当前游标的位置表示
/// 
Method GetPivot() As %String
{
}

/// <method>GetPivot</method>获取给定开始位置和结束位置区间内的数据行数
/// 
Method GetScopeCount(strt = "", end = "") As %Integer
{
}

}

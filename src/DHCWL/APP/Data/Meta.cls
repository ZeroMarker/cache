/// 类 <class>DHCWL.APP.Data.Meta</class>定义了一个对象结果的抽象。<br>
/// 一个对象结构包括多个属性，每个属性包括：名字，类型，别名，是否可显示等等
Class DHCWL.APP.Data.Meta Extends %Library.RegisteredObject [ Abstract ]
{

/// 获取该结构体定义的属性个数，其个数是直接属性的个数，即如果某个属性是复合属性，只计一处理
/// 
Method GetPropertyCount() As %Integer
{
}

/// <method>GetPropertyName</mothod>用来获取指定位置列的属性名字<br>
/// <var>index</var>表示属性定义的位置。
Method GetPropertyName(index As %Integer) As %String
{
}

/// <method>GetPropertyAliasName</mothod>用来获取指定位置列的属性别名<br>
/// <var>propertyName</var>表示属性名字。
Method GetAliasName(propertyName As %String) As %String
{
}

/// <method>GetPropertyAliasName</mothod>用来获取指定属性名字的属性别名<br>
/// <var>propertyName</var>表示属性名字。
Method GetPropertyType(propertyName As %String) As %String
{
}

/// <method>GetPropertyIndex</mothod>用来获取指定属性名字在定义中所在的位置<br>
/// <var>propertyName</var>表示属性名字。
Method GetPropertyIndex(propertyName As %String) As %Integer
{
}

/// <method>GetProperty</mothod>用来获取指定属性名字的Meta定义<br>
/// <var>propertyName</var>表示属性名字。
Method GetProperty(propertyName As %String) As Meta
{
}

/// <method>CanShow</method>。判定该属性是否可显示。对不可显示属性在Reader中就不需要返回该属性的值。<br>
/// <var>propertyName</var>表示属性名字。
Method CanShow(propertyName As %String) As %Boolean
{
}

/// <method>AvailableShow</method>设置该属性为可显示属性。
/// <var>propertyName</var>表示属性名字。
Method AvailableShow(propertyName As %String)
{
}

/// <method>AvailableShow</method>设置该属性为可显示属性。
/// <var>propertyName</var>表示属性名字。
Method DisavailableShow(propertyName As %String)
{
}

/// <method>CopyInstance</method>拷贝该Meta对象的一个副本
Method CopyInstance() As Meta
{
}

/// <method>GetParentMeta</method>返回该属性所在的Meta定义
Method GetParentMeta() As Meta
{
}

/// <method>GetClassName</method>返回当前Meta定义代表的类型名
Method GetClassName(propertyName As %String = "") As %String
{
}

/// <method>GetFullAccessLable</method>得到访问当当前属性的前缀的全访问符
Method GetFullAccessLable() As %String
{
}

/// <method>IsArray</method>判定属性propertyName是否为数组类型
/// <var>propertyName</var>属性的名字
Method IsArray(propertyName) As %Boolean
{
}

/// <method>ToDefineString</method>返回Meta对象的字符串定义
Method ToDefineString() As %String
{
}

/// <method>SetId</method>设置ID字段
Method SetId(propertyList...) As %Status
{
}

/// <method>GetId</method>取得ID字段
Method GetId() As %Status
{
}

}

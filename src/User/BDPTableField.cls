/// Function: 基础数据表结构登记子表 -字段维护
/// Creator: 陈莹
/// CreateDate:2014-6-22
Class User.BDPTableField Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_TableField ]
{

Relationship ParRef As User.BDPTableList [ Cardinality = parent, Inverse = ChildField ];

/// 表字段名称
Property FieldName As %String(MAXLEN = "") [ Required ];

/// 字段中文描述
Property FieldDesc As %String(MAXLEN = "") [ Required ];

/// 表结构中定义的字段指向表的代码 只有DR类型的使用
Property FieldTabCode As %String(MAXLEN = "");

/// 字段类型
Property FieldType As %String(MAXLEN = "");

/// 是否可翻译
Property FieldTranslation As %String(MAXLEN = "");

Index NameIndex On (FieldName, ParRef) [ Unique ];

Storage Default
{
<Data name="BDPTableFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FieldDesc</Value>
</Value>
<Value name="3">
<Value>FieldName</Value>
</Value>
<Value name="4">
<Value>FieldTabCode</Value>
</Value>
<Value name="5">
<Value>FieldType</Value>
</Value>
<Value name="6">
<Value>FieldTranslation</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildField")</DataLocation>
<DefaultData>BDPTableFieldDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPTableListC("ChildField")</IdLocation>
<IndexLocation>^User.BDPTableFieldI</IndexLocation>
<StreamLocation>^User.BDPTableFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

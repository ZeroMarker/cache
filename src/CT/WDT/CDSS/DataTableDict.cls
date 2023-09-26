/// Creator:丁亚男
/// CreatDate:2020-04-24
/// Description：数据库表字典表
/// Table：CT.WDT.CDSS.DataTableDict
Class CT.WDT.CDSS.DataTableDict Extends (%Persistent, User.Abstract)
{

/// 表空间名
Property TableSpaceName As %String [ Required ];

/// 数据表顺序号
Property TableNum As %Integer [ Required ];

/// 数据表名称
Property TableName As %String [ Required ];

/// 数据表字段顺序号
Property TableFieldNum As %Integer [ Required ];

/// 数据表字段数据描述
Property TableFieldName As %String [ Required ];

/// 数据表字段数据类型
Property TableFieldClass As %String;

/// 数据表字段长度
Property TableFieldLength As %String;

/// 数据表字段主键标记（0是，1否）
Property TableFieldKeyFlag As %Integer;

/// 数据表字段外键
Property TableFieldFkey As %String;

/// 数据表字段默认值
Property TableFieldDefaults As %String;

/// 数据表字段描述
Property TableFieldDesc As %String(MAXLEN = "");

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 患者模型数据类型
Property PMDataType As %String;

Index FieldNameIndex On (TableFieldName As Exact, TableName As Exact);

Index TableNameIndex On (TableName As Exact, TableFieldName As Exact);

Index TableNameFiledIndex On (TableName As Exact, TableFieldDesc As Exact);

Storage Default
{
<Data name="DataTableDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableSpaceName</Value>
</Value>
<Value name="3">
<Value>TableNum</Value>
</Value>
<Value name="4">
<Value>TableName</Value>
</Value>
<Value name="5">
<Value>TableFieldNum</Value>
</Value>
<Value name="6">
<Value>TableFieldName</Value>
</Value>
<Value name="7">
<Value>TableFieldClass</Value>
</Value>
<Value name="8">
<Value>TableFieldLength</Value>
</Value>
<Value name="9">
<Value>TableFieldKeyFlag</Value>
</Value>
<Value name="10">
<Value>TableFieldFkey</Value>
</Value>
<Value name="11">
<Value>TableFieldDefaults</Value>
</Value>
<Value name="12">
<Value>TableFieldDesc</Value>
</Value>
<Value name="13">
<Value>Remarks</Value>
</Value>
<Value name="14">
<Value>PMDataType</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DataTableDictD</DataLocation>
<DefaultData>DataTableDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DataTableDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DataTableDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DataTableDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

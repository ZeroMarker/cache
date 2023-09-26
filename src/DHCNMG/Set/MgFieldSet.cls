/// Creator:
/// Descriptions:列表字段配置
/// Date:2017-10-30
/// 
Class DHCNMG.Set.MgFieldSet Extends %Persistent
{

/// 表ID
Property FieldTable As %String [ SqlColumnNumber = 2, SqlFieldName = Field_Table ];

/// 字段描述
Property FieldDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Field_Desc ];

/// 字段代码
Property FieldCode As %String [ SqlColumnNumber = 4, SqlFieldName = Field_Code ];

/// 序号
Property FieldSort As %Integer [ SqlColumnNumber = 5, SqlFieldName = Field_Sort ];

/// 是否显示
Property FieldDisplay As %String [ SqlColumnNumber = 6, SqlFieldName = Field_Display ];

/// 是否锁定
Property FieldLock As %String [ SqlColumnNumber = 7, SqlFieldName = Field_Lock ];

/// 表头表尾锁定 【0：表头 1：表尾】
Property FieldLockPos As %String [ SqlColumnNumber = 8, SqlFieldName = Field_LockPos ];

/// 宽度
Property FieldWidth As %Integer [ SqlColumnNumber = 9, SqlFieldName = Field_Width ];

Property FieldType As %String [ SqlColumnNumber = 10, SqlFieldName = Field_Type ];

Index field On (FieldTable, FieldCode);

Index sort On (FieldTable, FieldSort);

Storage Default
{
<Data name="MgFieldSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FieldTable</Value>
</Value>
<Value name="3">
<Value>FieldDesc</Value>
</Value>
<Value name="4">
<Value>FieldCode</Value>
</Value>
<Value name="5">
<Value>FieldSort</Value>
</Value>
<Value name="6">
<Value>FieldLock</Value>
</Value>
<Value name="7">
<Value>FieldLockPos</Value>
</Value>
<Value name="8">
<Value>FieldDisplay</Value>
</Value>
<Value name="9">
<Value>FieldWidth</Value>
</Value>
<Value name="10">
<Value>FieldType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgFieldSetD</DataLocation>
<DefaultData>MgFieldSetDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgFieldSetD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgFieldSetI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgFieldSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

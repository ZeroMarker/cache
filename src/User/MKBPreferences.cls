/// 基础数据平台-谢海睿
/// 医生站知识库授权数据表
/// 2019-10-12
Class User.MKBPreferences Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_Preferences ]
{

// 授权类别$d(^User.MKBDoctorI("TypeIndex",1))

Property ObjectType As %String [ Required, SqlColumnNumber = 2, SqlFieldName = ObjectType ];

// 授权名称

Property ObjectReference As %String [ Required, SqlColumnNumber = 3, SqlFieldName = ObjectReference ];

// 授权类型

Property ValueType As %String [ Required, SqlColumnNumber = 4, SqlFieldName = ValueType ];

// 是否开立诊断标识（Y/N）

Property MKBValue As %String [ Required, SqlColumnNumber = 5, SqlFieldName = MKBValue ];

Index SearchIndex On (ObjectType, ObjectReference, ValueType) [ Unique ];

Storage Default
{
<Data name="MKBPreferencesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ObjectType</Value>
</Value>
<Value name="3">
<Value>ObjectReference</Value>
</Value>
<Value name="4">
<Value>ValueType</Value>
</Value>
<Value name="5">
<Value>MKBValue</Value>
</Value>
</Data>
<DataLocation>^User.MKBPreferencesD</DataLocation>
<DefaultData>MKBPreferencesDefaultData</DefaultData>
<IdLocation>^User.MKBPreferencesD</IdLocation>
<IndexLocation>^User.MKBPreferencesI</IndexLocation>
<StreamLocation>^User.MKBPreferencesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class CHSS.ServiceProviderInfo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = InfoRowId, SqlTableName = ServiceProviderInfo ]
{

Property 机构代码 As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = 机构代码 ];

Property 机构名称 As %String(MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = 机构名称 ];

Property 医生姓名 As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = 医生姓名 ];

Property 医生类别 As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = 医生类别 ];

Property 医生年龄 As %Numeric [ SqlColumnNumber = 6, SqlFieldName = 医生年龄 ];

Property 医生职称 As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = 医生职称 ];

Property 医生职务 As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = 医生职务 ];

Property 医生性别 As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = 医生性别 ];

Storage Default
{
<Data name="ServiceProviderInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>医生姓名</Value>
</Value>
<Value name="3">
<Value>机构代码</Value>
</Value>
<Value name="4">
<Value>机构名称</Value>
</Value>
<Value name="5">
<Value>医生年龄</Value>
</Value>
<Value name="6">
<Value>医生性别</Value>
</Value>
<Value name="7">
<Value>医生类别</Value>
</Value>
<Value name="8">
<Value>医生职务</Value>
</Value>
<Value name="9">
<Value>医生职称</Value>
</Value>
</Data>
<DataLocation>^CHSS.ServiceProviderInfoD</DataLocation>
<DefaultData>ServiceProviderInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.ServiceProviderInfoD</IdLocation>
<IndexLocation>^CHSS.ServiceProviderInfoI</IndexLocation>
<StreamLocation>^CHSS.ServiceProviderInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class User.DHCDocCureConfigPara Extends %Persistent [ SqlTableName = DHC_DocCure_ConfigPara ]
{

Parameter EXTENTSIZE = 250;

/// CP_Code 代码
Property CPCode As %String [ SqlColumnNumber = 2, SqlFieldName = CP_Code ];

/// CP_Desc 描述
Property CPDesc As %String(MAXLEN = 9999) [ SqlColumnNumber = 3, SqlFieldName = CP_Desc ];

/// CP_Value 数值
Property CPValue As %String(MAXLEN = 9999) [ SqlColumnNumber = 4, SqlFieldName = CP_Value ];

/// CP_Note 备注
Property CPNote As %String(MAXLEN = 9999) [ SqlColumnNumber = 5, SqlFieldName = CP_Note ];

/// CP_Active 是否激活
Property CPActive As %String [ SqlColumnNumber = 6, SqlFieldName = CP_Active ];

/// CP_HospID 院区
Property CPHospID As CTHospital [ SqlColumnNumber = 7, SqlFieldName = CP_HospID ];

Index CPCodeIndex On CPCode;

Storage Default
{
<Data name="DHCDocCureConfigParaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPCode</Value>
</Value>
<Value name="3">
<Value>CPDesc</Value>
</Value>
<Value name="4">
<Value>CPValue</Value>
</Value>
<Value name="5">
<Value>CPNote</Value>
</Value>
<Value name="6">
<Value>CPActive</Value>
</Value>
<Value name="7">
<Value>CPHospID</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureConfigParaD</DataLocation>
<DefaultData>DHCDocCureConfigParaDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCDocCureConfigParaD</IdLocation>
<IndexLocation>^User.DHCDocCureConfigParaI</IndexLocation>
<StreamLocation>^User.DHCDocCureConfigParaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

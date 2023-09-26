/// creator:dhh
/// createdate:20200521
/// description:PAD版本
Class DHCINM.Set.MgVersion Extends %Persistent
{

/// AppId
Property AppId As %String [ SqlColumnNumber = 2, SqlFieldName = App_Id ];

/// Version
Property AppVersion As %String [ SqlColumnNumber = 3, SqlFieldName = App_Version ];

/// title
Property AppTitle As %String [ SqlColumnNumber = 4, SqlFieldName = App_Title ];

/// note
Property AppNote As %String [ SqlColumnNumber = 5, SqlFieldName = App_Note ];

/// url
Property AppUrl As %String(MAXLEN = 2000) [ SqlColumnNumber = 6, SqlFieldName = App_Url ];

Storage Default
{
<Data name="MgVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppId</Value>
</Value>
<Value name="3">
<Value>AppVersion</Value>
</Value>
<Value name="4">
<Value>AppTitle</Value>
</Value>
<Value name="5">
<Value>AppNote</Value>
</Value>
<Value name="6">
<Value>AppUrl</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Set.MgVersionD</DataLocation>
<DefaultData>MgVersionDefaultData</DefaultData>
<IdLocation>^DHCINM.Set.MgVersionD</IdLocation>
<IndexLocation>^DHCINM.Set.MgVersionI</IndexLocation>
<StreamLocation>^DHCINM.Set.MgVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

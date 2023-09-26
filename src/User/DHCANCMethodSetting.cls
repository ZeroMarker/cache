Class User.DHCANCMethodSetting Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANMS_RowId, SqlTableName = DHC_ANC_MethodSetting, StorageStrategy = CacheStorage ]
{

/// ANMS_ANMethod_Dr
Property ANMSANMethodDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANMS_ANMethod_Dr ];

/// ANMS_Ctloc_Dr
Property ANMSCtlocDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANMS_Ctloc_Dr ];

/// ANMS_OrderList
Property ANMSOrderList As %String [ SqlColumnNumber = 4, SqlFieldName = ANMS_OrderList ];

/// ANMS_Code
Property ANMSCode As %String [ SqlColumnNumber = 5, SqlFieldName = ANMS_Code ];

/// ANMS_Desc
Property ANMSDesc As %String [ SqlColumnNumber = 6, SqlFieldName = ANMS_Desc ];

/// ANMS_Option
Property ANMSOption As %String [ SqlColumnNumber = 7, SqlFieldName = ANMS_Option ];

/// ANMS_Note
Property ANMSNote As %String [ SqlColumnNumber = 8, SqlFieldName = ANMS_Note ];

Index ANMethod On ANMSANMethodDr As Exact;

Storage CacheStorage
{
<Data name="DHCANCMethodSettingClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCMethodSettingDefaultData">
<Value name="1">
<Value>ANMSANMethodDr</Value>
</Value>
<Value name="2">
<Value>ANMSCtlocDr</Value>
</Value>
<Value name="3">
<Value>ANMSOrderList</Value>
</Value>
<Value name="4">
<Value>ANMSCode</Value>
</Value>
<Value name="5">
<Value>ANMSDesc</Value>
</Value>
<Value name="6">
<Value>ANMSOption</Value>
</Value>
<Value name="7">
<Value>ANMSNote</Value>
</Value>
</Data>
<DataLocation>^DHCANC("ANMethod")</DataLocation>
<DefaultData>DHCANCMethodSettingDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("ANMethod")</IdLocation>
<IndexLocation>^DHCANC("ANMethod",0)</IndexLocation>
<StreamLocation>^User.DHCANCMethodSettingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

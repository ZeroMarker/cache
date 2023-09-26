Class CT.AN.OperRiskControl Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperRiskControl ]
{

Property Operation As %String [ SqlColumnNumber = 2 ];

Property Code As %String [ Required, SqlColumnNumber = 3 ];

Property Description As %String [ Required, SqlColumnNumber = 4 ];

Property Emergency As %String(DISPLAYLIST = ",是,否", VALUELIST = ",on,off") [ SqlColumnNumber = 5 ];

Property LocalAnesthesia As %String(DISPLAYLIST = ",是,否", VALUELIST = ",on,off") [ SqlColumnNumber = 6 ];

Property SecondCategory As %String(DISPLAYLIST = ",是,否", VALUELIST = ",on,off") [ SqlColumnNumber = 7 ];

Property ControlType As %String(DISPLAYLIST = ",无,提示,禁止", VALUELIST = ",NONE,MSG,FORBID") [ SqlColumnNumber = 8 ];

Property ItemType As %String(DISPLAYLIST = ",检验,检查,病理,病历,手麻", VALUELIST = ",LIS,PACS,PIS,EMR,AN") [ SqlColumnNumber = 9 ];

Property TriggerTiming As CT.AN.DataModule [ SqlColumnNumber = 10 ];

Property DataAttribution As CF.AN.DataAttribution [ SqlColumnNumber = 11 ];

Property OperCategoryControl As %String [ SqlColumnNumber = 12 ];

Index IOperation On Operation;

Index ICode On Code [ Unique ];

Index ITriggerTiming On TriggerTiming;

Storage Default
{
<Data name="OperRiskControlDefaultData">
<Value name="1">
<Value>Operation</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Emergency</Value>
</Value>
<Value name="5">
<Value>LocalAnesthesia</Value>
</Value>
<Value name="6">
<Value>SecondCategory</Value>
</Value>
<Value name="7">
<Value>ControlType</Value>
</Value>
<Value name="8">
<Value>ItemType</Value>
</Value>
<Value name="9">
<Value>TriggerTiming</Value>
</Value>
<Value name="10">
<Value>DataAttribution</Value>
</Value>
<Value name="11">
<Value>OperCategoryControl</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperRiskControlD</DataLocation>
<DefaultData>OperRiskControlDefaultData</DefaultData>
<IdLocation>^CT.AN.OperRiskControlD</IdLocation>
<IndexLocation>^CT.AN.OperRiskControlI</IndexLocation>
<StreamLocation>^CT.AN.OperRiskControlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

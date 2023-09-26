Class web.DHCST.SoapModel.AdrRepModifyModel Extends %Persistent
{

Parameter XMLNAME = "Modify";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property iFlowFlag As %String(TRUNCATE = 1);

Property isOver As %String(TRUNCATE = 1);

Property iWorkFlowTemplID As %String(TRUNCATE = 1);

Property sCurrentActivityId As %String(TRUNCATE = 1);

Property sInitiatorId As %String(TRUNCATE = 1);

Property sEntityId As %String(TRUNCATE = 1);

Property sAuditId As %String(TRUNCATE = 1);

Property sOABusinessId As %String(TRUNCATE = 1);

Property sThirdBusinessId As %String(TRUNCATE = 1);

Property sOperationTime As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AdrRepModifyModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>iFlowFlag</Value>
</Value>
<Value name="3">
<Value>isOver</Value>
</Value>
<Value name="4">
<Value>iWorkFlowTemplID</Value>
</Value>
<Value name="5">
<Value>sCurrentActivityId</Value>
</Value>
<Value name="6">
<Value>sInitiatorId</Value>
</Value>
<Value name="7">
<Value>sEntityId</Value>
</Value>
<Value name="8">
<Value>sAuditId</Value>
</Value>
<Value name="9">
<Value>sOABusinessId</Value>
</Value>
<Value name="10">
<Value>sThirdBusinessId</Value>
</Value>
<Value name="11">
<Value>sOperationTime</Value>
</Value>
</Data>
<DataLocation>^web.DHCST693C.AdrRepModifB670D</DataLocation>
<DefaultData>AdrRepModifyModelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCST693C.AdrRepModifB670D</IdLocation>
<IndexLocation>^web.DHCST693C.AdrRepModifB670I</IndexLocation>
<StreamLocation>^web.DHCST693C.AdrRepModifB670S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

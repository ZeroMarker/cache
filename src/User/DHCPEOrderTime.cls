Class User.DHCPEOrderTime Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_OrderTime ]
{

Parameter ClassName = "User.DHCPEOrderTime";

Property OTArcimDR As %String [ SqlFieldName = OT_Arcim_DR ];

Property OTRooMDR As %String [ SqlFieldName = OT_RooM_DR ];

Property OTUserDR As %String [ SqlFieldName = OT_User_DR ];

Property OTMinute As %String [ SqlFieldName = OT_Minute ];

Index RoomUserOrder On (OTRooMDR, OTUserDR, OTArcimDR) [ Data = OTMinute ];

Storage Default
{
<Data name="DHCPEOrderTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTArcimDR</Value>
</Value>
<Value name="3">
<Value>OTMinute</Value>
</Value>
<Value name="4">
<Value>OTRooMDR</Value>
</Value>
<Value name="5">
<Value>OTUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEOrderTimeD</DataLocation>
<DefaultData>DHCPEOrderTimeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEOrderTimeD</IdLocation>
<IndexLocation>^User.DHCPEOrderTimeI</IndexLocation>
<StreamLocation>^User.DHCPEOrderTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

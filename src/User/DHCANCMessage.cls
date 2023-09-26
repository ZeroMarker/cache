Class User.DHCANCMessage Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANMSG_RowId, SqlTableName = DHC_ANC_Message, StorageStrategy = CacheStorage ]
{

Property ANMSGCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANMSG_Code ];

Property ANMSGDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANMSG_Desc ];

Property ANMSGReceiveCtloc As %String [ SqlColumnNumber = 4, SqlFieldName = ANMSG_ReceiveCtloc ];

Property ANMSGReceiveGroup As %String [ SqlColumnNumber = 5, SqlFieldName = ANMSG_ReceiveGroup ];

Property ANMSGReceiveUser As %String [ SqlColumnNumber = 6, SqlFieldName = ANMSG_ReceiveUser ];

Property ANMSGMaxinum As %String [ SqlColumnNumber = 7, SqlFieldName = ANMSG_Maxinum ];

Property ANMSGIfUse As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.30000%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ANMSG_If_Use ];

Index Code On ANMSGCode As Exact;

Property ANMSGReceiveType As %String(DISPLAYLIST = ",Ctloc,Group,User", SELECTIVITY = "25.00000%", VALUELIST = ",C,G,U") [ SqlColumnNumber = 9, SqlFieldName = ANMSG_ReceiveType ];

Storage CacheStorage
{
<Data name="DHCANCMessageClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCMessageDefaultData">
<Value name="1">
<Value>ANMSGCode</Value>
</Value>
<Value name="2">
<Value>ANMSGDesc</Value>
</Value>
<Value name="3">
<Value>ANMSGReceiveGroup</Value>
</Value>
<Value name="4">
<Value>ANMSGReceiveCtloc</Value>
</Value>
<Value name="5">
<Value>ANMSGReceiveUser</Value>
</Value>
<Value name="6">
<Value>ANMSGMaxinum</Value>
</Value>
<Value name="7">
<Value>ANMSGIfUse</Value>
</Value>
<Value name="8">
<Value>ANMSGReceiveType</Value>
</Value>
</Data>
<DataLocation>^DHCANC("Message")</DataLocation>
<DefaultData>DHCANCMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("Message")</IdLocation>
<IndexLocation>^DHCANC("Message",0)</IndexLocation>
<StreamLocation>^User.DHCANCMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

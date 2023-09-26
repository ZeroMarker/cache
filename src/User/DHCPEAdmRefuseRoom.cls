Class User.DHCPEAdmRefuseRoom Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_AdmRefuseRoom ]
{

Parameter ClassName = "User.DHCPEAdmRefuseRoom";

Property ARRPAADMDR As User.PAAdm [ Required, SqlFieldName = ARR_PAADM_DR ];

Property ARRRoomDR As User.DHCPERoom [ Required, SqlFieldName = ARR_Room_DR ];

Property ARRRefuseUserDR As User.SSUser [ Required, SqlFieldName = ARR_RefuseUser_DR ];

Property ARRRefuseDate As %Date [ Required, SqlFieldName = ARR_RefuseDate ];

Property ARRRefuseTime As %Time [ SqlFieldName = ARR_RefuseTime ];

Property ARRResumeUserDR As User.SSUser [ SqlFieldName = ARR_ResumeUser_DR ];

Property ARRResumeDate As %Date [ SqlFieldName = ARR_ResumeDate ];

Property ARRResumeTime As %Time [ SqlFieldName = ARR_ResumeTime ];

//RF:谢绝  RS:启用

Property ARRStatus As %String [ SqlFieldName = ARR_Status ];

Index RefuseDateStatus On (ARRRefuseDate, ARRStatus As AlphaUp, ARRRoomDR);

Index PAADMStatus On (ARRPAADMDR, ARRStatus As AlphaUp, ARRRoomDR);

Storage Default
{
<Data name="DHCPEAdmRefuseRoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARRPAADMDR</Value>
</Value>
<Value name="3">
<Value>ARRRoomDR</Value>
</Value>
<Value name="4">
<Value>ARRRefuseUserDR</Value>
</Value>
<Value name="5">
<Value>ARRRefuseDate</Value>
</Value>
<Value name="6">
<Value>ARRRefuseTime</Value>
</Value>
<Value name="7">
<Value>ARRResumeUserDR</Value>
</Value>
<Value name="8">
<Value>ARRResumeDate</Value>
</Value>
<Value name="9">
<Value>ARRResumeTime</Value>
</Value>
<Value name="10">
<Value>ARRStatus</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEAdmRefuseRoomD</DataLocation>
<DefaultData>DHCPEAdmRefuseRoomDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEAdmRefuseRoomD</IdLocation>
<IndexLocation>^User.DHCPEAdmRefuseRoomI</IndexLocation>
<StreamLocation>^User.DHCPEAdmRefuseRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

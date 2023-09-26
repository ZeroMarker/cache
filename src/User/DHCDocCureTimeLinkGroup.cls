Class User.DHCDocCureTimeLinkGroup Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = DHC_DocCureTimeLinkGroup ]
{

/// DDCTS_Code
Property DDCTLGTimePeriodDr As User.DHCDocCureRBCTimePeriodSet [ SqlColumnNumber = 2, SqlFieldName = DDCTLG_TimePeriod_Dr ];

/// DDCTS_Desc
Property DDCTLGServiceGroupDr As User.DHCDocCureRBCServiceGroupSet [ SqlColumnNumber = 3, SqlFieldName = DDCTLG_ServiceGroup_Dr ];

/// DDCIS_Hospital_DR  院区
Property DDCTLGHospitalDR As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = DDCTLG_Hospital_DR ];

Index TLGTimePeriodIndex On DDCTLGTimePeriodDr;

Index TLGServiceGroupIndex On DDCTLGServiceGroupDr;

Index TLGTPandSGIndex On (DDCTLGTimePeriodDr, DDCTLGServiceGroupDr);

Index TLGSGandTPIndex On (DDCTLGServiceGroupDr, DDCTLGTimePeriodDr);

Storage Default
{
<Data name="DHCDocCureTimeLinkGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DDCTLGTimePeriodDr</Value>
</Value>
<Value name="3">
<Value>DDCTLGServiceGroupDr</Value>
</Value>
<Value name="4">
<Value>DDCTLGHospitalDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureTimeLinkGroupD</DataLocation>
<DefaultData>DHCDocCureTimeLinkGroupDefaultData</DefaultData>
<IdLocation>^User.DHCDocCureTimeLinkGroupD</IdLocation>
<IndexLocation>^User.DHCDocCureTimeLinkGroupI</IndexLocation>
<StreamLocation>^User.DHCDocCureTimeLinkGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

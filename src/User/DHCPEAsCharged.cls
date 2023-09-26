Class User.DHCPEAsCharged Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_AsCharged ]
{

Parameter ClassName = "User.DHCPEAsCharged";

Property ACAuditDR As User.DHCPEPreAudit [ SqlFieldName = AC_Audit_DR ];

Property ACUser As %String [ SqlFieldName = AC_User ];

Property ACDate As %Date [ SqlFieldName = AC_Date ];

Property ACTime As %Time [ SqlFieldName = AC_Time ];

Property ACType As %String [ SqlFieldName = AC_Type ];

Property ACRemark As %String [ SqlFieldName = AC_Remark ];

Index ACIndex On ACAuditDR As AlphaUp;

Index ACDateIndex On ACDate As AlphaUp;

Index UserDateIndex On (ACUser, ACDate As AlphaUp);

Storage Default
{
<Data name="DHCPEAsChargedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ACAuditDR</Value>
</Value>
<Value name="3">
<Value>ACUser</Value>
</Value>
<Value name="4">
<Value>ACDate</Value>
</Value>
<Value name="5">
<Value>ACTime</Value>
</Value>
<Value name="6">
<Value>ACType</Value>
</Value>
<Value name="7">
<Value>ACRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEAsChargedD</DataLocation>
<DefaultData>DHCPEAsChargedDefaultData</DefaultData>
<IdLocation>^User.DHCPEAsChargedD</IdLocation>
<IndexLocation>^User.DHCPEAsChargedI</IndexLocation>
<StreamLocation>^User.DHCPEAsChargedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

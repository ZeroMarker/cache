/// 材料是否送总检的记录
Class User.DHCPESendAudit Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_SendAudit ]
{

Parameter ClassName = "User.DHCPESendAudit";

Property SAPAAdmDR As PAAdm [ Required, SqlFieldName = SA_PAAdm_DR ];

Property SASendUserDR As SSUser [ Required, SqlFieldName = SA_SendUser_DR ];

Property SASendDate As %Library.Date [ Required, SqlFieldName = SA_SendDate ];

Property SASendTime As %Library.Time [ Required, SqlFieldName = SA_SendTime ];

Index AdmIndex On SAPAAdmDR;

Index SendDateIndex On SASendDate;

Storage Default
{
<Data name="DHCPESendAuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SAPAAdmDR</Value>
</Value>
<Value name="3">
<Value>SASendUserDR</Value>
</Value>
<Value name="4">
<Value>SASendDate</Value>
</Value>
<Value name="5">
<Value>SASendTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPESendAuditD</DataLocation>
<DefaultData>DHCPESendAuditDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPESendAuditD</IdLocation>
<IndexLocation>^User.DHCPESendAuditI</IndexLocation>
<StreamLocation>^User.DHCPESendAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

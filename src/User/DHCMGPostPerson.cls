Class User.DHCMGPostPerson Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_Post_Person ]
{

Property PostNurPersonDR As %String(TRUNCATE = 1) [ SqlFieldName = PostNur_Person_DR ];

Property PostNurPostDR As %String(TRUNCATE = 1) [ SqlFieldName = PostNur_Post_DR ];

Storage Default
{
<Data name="DHCMGPostPersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostNurPersonDR</Value>
</Value>
<Value name="3">
<Value>PostNurPostDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPostPersonD</DataLocation>
<DefaultData>DHCMGPostPersonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPostPersonD</IdLocation>
<IndexLocation>^User.DHCMGPostPersonI</IndexLocation>
<StreamLocation>^User.DHCMGPostPersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

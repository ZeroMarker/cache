Class User.DHCPEHighRiskDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_HighRiskDetail ]
{

Parameter ClassName = "User.DHCPEHighRiskDetail";

Relationship parentRisk As User.DHCPEHighRiskResult [ Cardinality = parent, Inverse = childDetail ];

Property HRDResultDR As DHCPEResult [ SqlFieldName = HRD_ResultDR ];

Index ResultDRIndex On HRDResultDR;

Storage Default
{
<Data name="DHCPEHighRiskDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HRDResultDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("childDetail")</DataLocation>
<DefaultData>DHCPEHighRiskDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEHighRiskResultC("childDetail")</IdLocation>
<IndexLocation>^User.DHCPEHighRiskDetailI</IndexLocation>
<StreamLocation>^User.DHCPEHighRiskDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class User.DHCCITypeDefineOrderRule Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_CITypeDefineOrderRule ]
{

Property TORActiveFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlFieldName = TOR_ActiveFlag ];

Relationship TORCTDParRef As User.DHCCITypeDefine [ Cardinality = parent, Inverse = OrdRule ];

Property TORCTHospitalDR As CTHospital [ SqlFieldName = TOR_CTHospital_DR ];

Property TORDateFrom As %Date [ Required, SqlFieldName = TOR_DateFrom ];

Property TORDateTo As %Date [ SqlFieldName = TOR_DateTo ];

Property TORRecLocDR As CTLoc [ Required, SqlFieldName = TOR_RecLoc_DR ];

Property TORTimeFrom As %Time [ SqlFieldName = TOR_TimeFrom ];

Property TORTimeTo As %Time [ SqlFieldName = TOR_TimeTo ];

Storage Default
{
<Data name="DHCCITypeDefineOrderRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TORRecLocDR</Value>
</Value>
<Value name="3">
<Value>TORActiveFlag</Value>
</Value>
<Value name="4">
<Value>TORDateFrom</Value>
</Value>
<Value name="5">
<Value>TORCTHospitalDR</Value>
</Value>
<Value name="6">
<Value>TORDateTo</Value>
</Value>
<Value name="7">
<Value>TORTimeFrom</Value>
</Value>
<Value name="8">
<Value>TORTimeTo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OrdRule")</DataLocation>
<DefaultData>DHCCITypeDefineOrderRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCITypeDefineC("OrdRule")</IdLocation>
<IndexLocation>^User.DHCCITypeDefineOrderRuleI</IndexLocation>
<StreamLocation>^User.DHCCITypeDefineOrderRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

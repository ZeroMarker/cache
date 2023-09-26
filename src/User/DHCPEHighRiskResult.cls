Class User.DHCPEHighRiskResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_HighRiskResult ]
{

Parameter ClassName = "User.DHCPEHighRiskResult";

Relationship childDetail As User.DHCPEHighRiskDetail [ Cardinality = children, Inverse = parentRisk ];

Property HRRPAAdm As PAAdm [ Required, SqlFieldName = HRR_PAAdm ];

Property HRROEOrdItemDR As User.OEOrdItem [ SqlFieldName = HRR_OEOrdItemDR ];

Property HRREDDetail As %Stream.GlobalCharacter [ SqlFieldName = HRR_EDDEtail ];

Property HRRActive As %String [ SqlFieldName = HRR_Active ];

Property HRRUserDR As SSUser [ SqlFieldName = HRR_UserDR ];

Property HRRDate As %Library.Date [ SqlFieldName = HRR_Date ];

Property HRRTime As %Library.Time [ SqlFieldName = HRR_Time ];

// 是否需随访

Property HRRCRMFlag As %String [ SqlFieldName = HRR_CRMFlag ];

Index DateIndex On (HRRDate, HRRTime);

Index PAAdmIndex On HRRPAAdm;

Storage Default
{
<Data name="DHCPEHighRiskResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HRRPAAdm</Value>
</Value>
<Value name="3">
<Value>HRROEOrdItemDR</Value>
</Value>
<Value name="4">
<Value>HRREDDetail</Value>
</Value>
<Value name="5">
<Value>HRRActive</Value>
</Value>
<Value name="6">
<Value>HRRUserDR</Value>
</Value>
<Value name="7">
<Value>HRRDate</Value>
</Value>
<Value name="8">
<Value>HRRTime</Value>
</Value>
<Value name="9">
<Value>HRRCRMFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEHighRiskResultD</DataLocation>
<DefaultData>DHCPEHighRiskResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEHighRiskResultD</IdLocation>
<IndexLocation>^User.DHCPEHighRiskResultI</IndexLocation>
<StreamLocation>^User.DHCPEHighRiskResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

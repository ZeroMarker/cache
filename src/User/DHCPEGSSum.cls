Class User.DHCPEGSSum Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_GSSum ]
{

Parameter ClassName = "User.DHCPEGSSum";

Property GSSDetail As %Stream.GlobalCharacter [ SqlFieldName = GSS_Detail ];

Property GSSYGDetail As %Stream.GlobalCharacter [ SqlFieldName = GSS_YGDetail ];

Property GSSParref As User.DHCPEGeneralSummarize [ SqlFieldName = GSS_Parref ];

Index IndexParref On GSSParref;

Storage Default
{
<Data name="DHCPEGSSumDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GSSDetail</Value>
</Value>
<Value name="3">
<Value>GSSParref</Value>
</Value>
<Value name="4">
<Value>GSSYGDetail</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGSSumD</DataLocation>
<DefaultData>DHCPEGSSumDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEGSSumD</IdLocation>
<IndexLocation>^User.DHCPEGSSumI</IndexLocation>
<StreamLocation>^User.DHCPEGSSumS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 10、医学判别标准表DHC_HM_CMedicalStandards
Class User.DHCHMCMedicalStandards Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CMedicalStandards ]
{

Parameter ClassName = "User.DHCHMCMedicalStandards";

/// 2	MS_Code	代码
Property MSCode As %String;

/// 3	MS_Desc	描述	
Property MSDesc As %String;

/// 11	MS_NatureValue	是否正常值					Y正常值
Property MSNatureValue As %String;

/// 12	MS_Active	激活	Y/N	
Property MSActive As %String;

/// 13	MS_Remark	备注	Text	200		
Property MSRemark As %String(MAXLEN = 200);

Index MSCodeIndex On MSCode [ Unique ];

Index MSDescIndex On MSDesc;

Storage Default
{
<Data name="DHCHMCMedicalStandardsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSActive</Value>
</Value>
<Value name="3">
<Value>MSCode</Value>
</Value>
<Value name="4">
<Value>MSDesc</Value>
</Value>
<Value name="5">
<Value>MSNatureValue</Value>
</Value>
<Value name="6">
<Value>MSRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCMedicalStandardsD</DataLocation>
<DefaultData>DHCHMCMedicalStandardsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCMedicalStandardsD</IdLocation>
<IndexLocation>^User.DHCHMCMedicalStandardsI</IndexLocation>
<StreamLocation>^User.DHCHMCMedicalStandardsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

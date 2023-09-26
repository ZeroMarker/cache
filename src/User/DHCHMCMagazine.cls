/// 11、健康杂志表DHC_HM_CMagazine
Class User.DHCHMCMagazine Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CMagazine ]
{

Parameter ClassName = "User.DHCHMCMagazine";

/// 	M_Code	编码			NOTNULL	
Property MCode As %String [ Required ];

Index MCodeIndex On MCode;

/// 4	M_Desc	杂志名称	Text	30	NOT NULL	
Property MDesc As %String(MAXLEN = 30) [ Required ];

Index MDescIndex On MDesc;

/// 9	M_Periodical	期别	Text	10	
Property MPeriodical As %String(MAXLEN = 10);

Index MPeriodicalIndex On MPeriodical;

/// 13	M_Active	激活	Y/N		
Property MActive As %String;

/// 7	M_Link	杂志链接	Text	50	
Property MLink As %String;

/// 8	M_Summary	杂志简介	Text	200
Property MSummary As %String(MAXLEN = 200);

/// 12	HMMZ_Remark	备注	Text	200	
Property MRemark As %String(MAXLEN = 200);

/// 12	MPublishDate	出版日期	
Property MPublishDate As %Date;

Storage Default
{
<Data name="DHCHMCMagazineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HMMZRemark</Value>
</Value>
<Value name="3">
<Value>MActive</Value>
</Value>
<Value name="4">
<Value>MCode</Value>
</Value>
<Value name="5">
<Value>MDesc</Value>
</Value>
<Value name="6">
<Value>MLink</Value>
</Value>
<Value name="7">
<Value>MPeriodical</Value>
</Value>
<Value name="8">
<Value>MSummary</Value>
</Value>
<Value name="9">
<Value>MRemark</Value>
</Value>
<Value name="10">
<Value>MPublishDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCMagazineD</DataLocation>
<DefaultData>DHCHMCMagazineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCMagazineD</IdLocation>
<IndexLocation>^User.DHCHMCMagazineI</IndexLocation>
<StreamLocation>^User.DHCHMCMagazineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

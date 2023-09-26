/// Desc:		图库
/// Creator:	yejian
/// CreateDate:	2012-09-16
Class EMRmeta.ImageLib Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCategoryID On CategoryID;

Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property CategoryID As %Integer;

Property Sequence As %Integer;

Storage Default
{
<Data name="ImageLibDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>CategoryID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ImageLibD</DataLocation>
<DefaultData>ImageLibDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.ImageLibD</IdLocation>
<IndexLocation>^DHCEMRM.ImageLibI</IndexLocation>
<StreamLocation>^DHCEMRM.ImageLibS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

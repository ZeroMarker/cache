/// Desc:文本知识关联科室
/// Creator:Candy
/// CreateDate:2018-3-2
Class EMRmeta.TextKBLoc Extends (%Persistent, %XML.Adaptor)
{

Index IdxCategoryLocID On (CategoryID, LocID) [ Unique ];

Property CategoryID As %Integer;

Property LocID As %Integer;

Storage Default
{
<Data name="TextKBLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>LocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TextKBLocD</DataLocation>
<DefaultData>TextKBLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TextKBLocD</IdLocation>
<IndexLocation>^DHCEMRM.TextKBLocI</IndexLocation>
<StreamLocation>^DHCEMRM.TextKBLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

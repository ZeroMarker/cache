/// d ##class(DHCWL.BaseDataQuery.RItemFm).%BuildIndices()
Class DHCWL.BaseDataQuery.RItemFm Extends %Persistent
{

Property ItemDr As RptItem;

Property Format As %String(COLLATION = "EXACT");

Index ItemDr On (ItemDr, Format);

ClassMethod GetFormatByItemID(itemID As %String) As %String
{
	s format=""
	if $d(^DHCWL.BaseDataQuery.RItemFmI("ItemDr",itemID)) {
		s format=$o(^DHCWL.BaseDataQuery.RItemFmI("ItemDr",itemID,format))
	}
	q format
}

Storage Default
{
<Data name="RItemFmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemDr</Value>
</Value>
<Value name="3">
<Value>Format</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.RItemFmD</DataLocation>
<DefaultData>RItemFmDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.RItemFmD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.RItemFmI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.RItemFmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

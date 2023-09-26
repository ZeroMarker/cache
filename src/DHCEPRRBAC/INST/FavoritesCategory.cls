Class DHCEPRRBAC.INST.FavoritesCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property UserID As %String(TRUNCATE = 1);

Property CategoryDesc As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Index IdxUserID On (UserID, CreateDate, CreateTime);

Storage Default
{
<Data name="FavoritesCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>CategoryDesc</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.FavorCatD</DataLocation>
<DefaultData>FavoritesCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.FavorCatD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.FavorCatI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.FavorCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

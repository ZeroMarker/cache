Class DHCEPRSearch.INST.FavoritesCategory Extends %Persistent
{

Property UserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property CategoryDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property CreateDate As %Date [ SqlColumnNumber = 4 ];

Property CreateTime As %Time [ SqlColumnNumber = 5 ];

Index IdxUserID On UserID;

Index IdxCreateDateTime On (CreateDate, CreateTime);

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
<DataLocation>^DHCEPRSearch.INST.FavCateD</DataLocation>
<DefaultData>FavoritesCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.INST.FavCateD</IdLocation>
<IndexLocation>^DHCEPRSearch.INST.FavCateI</IndexLocation>
<StreamLocation>^DHCEPRSearch.INST.FavCateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

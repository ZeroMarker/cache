Class DHCEPRSearch.INST.Favorites Extends %Persistent
{

Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property MRVerItemID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property UserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property CategoryID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property DocName As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property Tags As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Property Notes As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Property AddDate As %Date [ SqlColumnNumber = 9 ];

Property AddTime As %Time [ SqlColumnNumber = 10 ];

Index IdxMREpisodeID On MREpisodeID;

Index IdxMRVerItemID On MRVerItemID;

Index IdxUserID On UserID;

Index IdxUserIDAndMRVerItemID On (UserID, MRVerItemID);

Index IdxAddDateTime On (AddDate, AddTime);

Storage Default
{
<Data name="FavoritesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>MRVerItemID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>CategoryID</Value>
</Value>
<Value name="6">
<Value>DocName</Value>
</Value>
<Value name="7">
<Value>Tags</Value>
</Value>
<Value name="8">
<Value>Notes</Value>
</Value>
<Value name="9">
<Value>AddDate</Value>
</Value>
<Value name="10">
<Value>AddTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.INST.FavoritesD</DataLocation>
<DefaultData>FavoritesDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.INST.FavoritesD</IdLocation>
<IndexLocation>^DHCEPRSearch.INST.FavoritesI</IndexLocation>
<StreamLocation>^DHCEPRSearch.INST.FavoritesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

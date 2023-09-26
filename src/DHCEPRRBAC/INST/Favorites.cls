Class DHCEPRRBAC.INST.Favorites Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EpisodeID As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property CategoryID As %String(TRUNCATE = 1);

Property Tags As %String(TRUNCATE = 1);

Property Notes As %String(TRUNCATE = 1);

Property AddDate As %Date;

Property AddTime As %Time;

Index IdxEpisodeID On (UserID, EpisodeID);

Index IdxExist On (CategoryID, EpisodeID);

Index IdxCategoryID On CategoryID;

Index IdxUserID On (UserID, CategoryID, AddDate, AddTime);

Storage Default
{
<Data name="FavoritesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CategoryID</Value>
</Value>
<Value name="5">
<Value>Tags</Value>
</Value>
<Value name="6">
<Value>Notes</Value>
</Value>
<Value name="7">
<Value>AddDate</Value>
</Value>
<Value name="8">
<Value>AddTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.FavorD</DataLocation>
<DefaultData>FavoritesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.FavorD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.FavorI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.FavorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

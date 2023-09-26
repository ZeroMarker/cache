Class CT.CKB.PDSS.TinySave Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = Tiny_RowID, SqlTableName = DHC_CKBTinySave, StorageStrategy = CacheStorage ]
{

Property TinyText As %Library.Text(MAXLEN = 50000) [ SqlColumnNumber = 2, SqlFieldName = Tiny_Text ];

Property ParrefID As %String [ SqlColumnNumber = 3, SqlFieldName = Parref_ID ];

Storage CacheStorage
{
<Data name="TinySaveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TinyText</Value>
</Value>
<Value name="3">
<Value>ParrefID</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.TinySaveD</DataLocation>
<DefaultData>TinySaveDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.TinySaveD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.TinySaveI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.TinySaveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index Parref On ParrefID;

}

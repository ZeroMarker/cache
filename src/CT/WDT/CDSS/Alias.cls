/// Creator:谷雪萍
/// CreatDate:2021-11-03
/// Description：CDSS-别名通用名
/// Table：CT.WDT.CDSS.Alias
Class CT.WDT.CDSS.Alias Extends (%Persistent, User.Abstract)
{

/// 表名
Property TableName As %String(MAXLEN = "") [ Required ];

/// 别名
Property DataAlias As %String(MAXLEN = "") [ Required ];

/// 对应表rowid
Property DataReference As %String(MAXLEN = "") [ Required ];

Index AliasIndex On (TableName As Exact, DataAlias As Exact, DataReference As Exact);

Index DataRefIndex On (TableName As Exact, DataReference As Exact);

/// 新加索引 别名忽略大小写进行识别 2022-11-10 GXP
Index UPAliasIndex On (TableName As Exact, DataAlias, DataReference As Exact);

/// 用于字典别名校验 2023-03-10 ZWW
Index TableAliasIndex On (TableName As Exact, DataAlias As Exact);

Storage Default
{
<Data name="AliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>DataAlias</Value>
</Value>
<Value name="4">
<Value>DataReference</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AliasD</DataLocation>
<DefaultData>AliasDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AliasD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AliasI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 文献搜索日志表
Class User.MKBDocGridShow Extends (%Persistent, User.Abstract)
{

/// 用户名
Property MKBDGUser As %String(MAXLEN = "");

/// 操作类型（查询/预览/下载）
Property MKBDGOptType As %String(MAXLEN = "");

/// 操作内容（查询条件/文献名）
Property MKBDGContent As %String(MAXLEN = "");

/// 操作时间
Property MKBDGDate As %Date;

Storage Default
{
<Data name="MKBDocGridShowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBDGUser</Value>
</Value>
<Value name="3">
<Value>MKBDGOptType</Value>
</Value>
<Value name="4">
<Value>MKBDGContent</Value>
</Value>
<Value name="5">
<Value>MKBDGDate</Value>
</Value>
</Data>
<DataLocation>^User.MKBDocGridShowD</DataLocation>
<DefaultData>MKBDocGridShowDefaultData</DefaultData>
<IdLocation>^User.MKBDocGridShowD</IdLocation>
<IndexLocation>^User.MKBDocGridShowI</IndexLocation>
<StreamLocation>^User.MKBDocGridShowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

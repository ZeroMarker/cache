Class EMRmeta.CollectTemplate Extends %Persistent
{

Index IdxUserNodeID On (userID, nodeID);

// 医生ID：

Property userID As %String(TRUNCATE = 1);

// 模板唯一标识

Property nodeID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CollectTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>userID</Value>
</Value>
<Value name="3">
<Value>nodeID</Value>
</Value>
</Data>
<DataLocation>^EMRmeta.CollectTemplateD</DataLocation>
<DefaultData>CollectTemplateDefaultData</DefaultData>
<IdLocation>^EMRmeta.CollectTemplateD</IdLocation>
<IndexLocation>^EMRmeta.CollectTemplateI</IndexLocation>
<StreamLocation>^EMRmeta.CollectTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 保存那些病例需要使用手写签名功能，ID来自病例展现结构
Class EPRmeta.HandWrittenPrtID Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PrtID As %String(TRUNCATE = 1);

Index Idx On PrtID;

Storage Default
{
<Data name="HandWrittenPrtIDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrtID</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.HandWrittenPrtIDD</DataLocation>
<DefaultData>HandWrittenPrtIDDefaultData</DefaultData>
<IdLocation>^DHCEPRM.HandWrittenPrtIDD</IdLocation>
<IndexLocation>^DHCEPRM.HandWrittenPrtIDI</IndexLocation>
<StreamLocation>^DHCEPRM.HandWrittenPrtIDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

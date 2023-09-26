/// 名称:	EMR.DB.SynDataConfig
/// 描述:	存储不需要显示的同步数据
/// 编写者：yejian
/// 编写日期: 2022-6-14
/// 产品组：电子病历产品组
Class EMR.DB1.SynDataConfig Extends %Persistent
{

Index IdxDocumentID On DocumentID;

Index IdxIDCode On (DocumentID, Code);

/// 病历DocumentID
Property DocumentID As %String;

/// Code
Property Code As %String(MAXLEN = 100);

Storage Default
{
<Data name="SynDataConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentID</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.SynDataConfigD</DataLocation>
<DefaultData>SynDataConfigDefaultData</DefaultData>
<IdLocation>^EMR.DB1.SynDataConfigD</IdLocation>
<IndexLocation>^EMR.DB1.SynDataConfigI</IndexLocation>
<StreamLocation>^EMR.DB1.SynDataConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

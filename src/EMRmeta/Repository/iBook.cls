/// 名称:EMRmeta.Repository.iBook
/// 描述:联机文献主表
/// 编写者：guozongtao
/// 编写日期: 2014-8-19
Class EMRmeta.Repository.iBook Extends %Persistent
{

Index IdxCategoryID On CategoryID;

Index IdxAuthor On Author;

/// 隶属联机文献目录
Property CategoryID As %String;

/// 文档类型（PDF/EMR）
Property DocumentType As %String;

/// 联机文献名称	
Property Name As %String;

/// 联机文献作者
Property Author As %String;

/// 联机文献摘要
Property Summary As %String;

/// 联机文献数据流	
Property Document As %GlobalBinaryStream(LOCATION = "^DHCEMRR.iBookS");

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

Storage Default
{
<Data name="iBookDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>DocumentType</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Author</Value>
</Value>
<Value name="6">
<Value>Summary</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>Document</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.iBookD</DataLocation>
<DefaultData>iBookDefaultData</DefaultData>
<IdLocation>^DHCEMRM.iBookD</IdLocation>
<IndexLocation>^DHCEMRM.iBookI</IndexLocation>
<StreamLocation>^DHCEMRM.iBookS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

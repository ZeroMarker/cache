/// Desc:		图库图片
/// Creator:	Candyxu
/// CreateDate:	2017-07-13
Class EMRmeta.Image.Item Extends (%Persistent, User.Abstract, %XML.Adaptor)
{

Index IdxCategoryID On CategoryID;

/// 编码
Property Code As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 目录ID
Property CategoryID As %String;

/// 图片类型
Property ImageType As %String(MAXLEN = 20, TRUNCATE = 1);

/// 图片数据
Property ImageData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.Image.ItemS");

/// 发布状态(0:未发布;1:已发布)
Property IsPublish As %Integer;

/// 顺序
Property Sequence As %Integer;

Index IdxCategoryIDIsPublishSequence On (CategoryID, IsPublish, Sequence);

Storage Default
{
<Data name="ItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>CategoryID</Value>
</Value>
<Value name="5">
<Value>ImageType</Value>
</Value>
<Value name="6">
<Value>ImageData</Value>
</Value>
<Value name="7">
<Value>IsPublish</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Image.ItemD</DataLocation>
<DefaultData>ItemDefaultData</DefaultData>
<IdLocation>^DHCEMRM.Image.ItemD</IdLocation>
<IndexLocation>^DHCEMRM.Image.ItemI</IndexLocation>
<StreamLocation>^DHCEMRM.Image.ItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

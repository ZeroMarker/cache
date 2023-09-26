/// Desc:		单个图片，相当于KBNode
/// Creator:	Kumon Xie
/// CreateDate:	2011-09-11
Class EPRmeta.ImageItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxImageLibID On ImageLibID;

Index IdxImageTreeID On ImageTreeID;

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 图库ID
Property ImageLibID As %Integer;

/// 项目RowID
Property ImageTreeID As %Integer;

/// 原始图片数据
Property ImageData As %GlobalBinaryStream(LOCATION = "^DHCEPRM.ImageItemS");

/// 带热区图片数据
Property HotSpotData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.ImageItemS");

/// 图示数据
Property IconData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.ImageItemS");

/// 图片状态(0:无图片;1:原始;2:裁剪;3:热区;)
Property Status As %Integer;

/// 发布状态(0:未发布;1:已发布)
Property IsPublish As %Integer;

Storage Default
{
<Data name="ImageItemDefaultData">
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
<Value>ImageLibID</Value>
</Value>
<Value name="5">
<Value>ImageTreeID</Value>
</Value>
<Value name="6">
<Value>ImageData</Value>
</Value>
<Value name="7">
<Value>HotSpotData</Value>
</Value>
<Value name="8">
<Value>IconData</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>IsPublish</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.ImageItemD</DataLocation>
<DefaultData>ImageItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.ImageItemD</IdLocation>
<IndexLocation>^DHCEPRM.ImageItemI</IndexLocation>
<StreamLocation>^DHCEPRM.ImageItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Desc: 归档病历项目
Class DHCEPRFS.META.MRItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 归档病历项目名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历项目编码
Property Code As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

/// 归档病历项目描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 归档病历子类ID
Property MRSubCategoryID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 归档病历项目类型(可以与集中打印类型一致)
Property Type As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 6 ];

/// 归档病历项目类型参数配置(比如电子病历的打印模板ID,参数格式可以自定义)
Property TypeParams As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 7 ];

/// 归档病历项目来源
Property Source As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 9 ];

/// 附属项目 （0表示此项目附加到其他项目上生成，生成时跳过此项目，大于0的数字串表示附加在此项目上的其他项目ID，在生成时合并一起生成）
Property Attachment As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 附属项目类型(1表示附属项目追加在前, 2表示附属项目追加在后)
Property AttachType As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 是否还有子项目标志(1表示有子项目，其他表示无子项目)
Property SubFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 扫描的标题文字，当OCR时发现匹配此文字则自动分类
Property OCRArrangeTitle As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 媒体类型，为空表示PDF文档，OTHER表示不分类，MP3，MP4等
Property MediaType As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 项目生产的纸质类型，目前支持b5和a4
Property PaperSize As %String(TRUNCATE = 1) [ SqlColumnNumber = 15 ];

Index IdxMain On Code [ Unique ];

Index IdxType On (Type, TypeParams) [ Unique ];

Index IdxAttachment On Attachment;

Index IdxMRSubCategoryID On MRSubCategoryID;

Index IdxSequence On (MRSubCategoryID, Sequence);

Storage Default
{
<Data name="MRItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>MRSubCategoryID</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>TypeParams</Value>
</Value>
<Value name="8">
<Value>Source</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Attachment</Value>
</Value>
<Value name="11">
<Value>AttachType</Value>
</Value>
<Value name="12">
<Value>SubFlag</Value>
</Value>
<Value name="13">
<Value>OCRArrangeTitle</Value>
</Value>
<Value name="14">
<Value>MediaType</Value>
</Value>
<Value name="15">
<Value>PaperSize</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRItemD</DataLocation>
<DefaultData>MRItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRItemD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

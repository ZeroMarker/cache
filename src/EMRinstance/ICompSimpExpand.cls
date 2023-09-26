/// 名称:EMRinstance.ICompSimpExpand
/// 描述:实例数据-知识库嵌套时简单单元打散表的关联表
/// 编写者：niucaicai
/// 编写日期: 2018-08-07
Class EMRinstance.ICompSimpExpand Extends %Persistent
{

Index IdxForUpdate On (InstanceDataID, SectionCode, SourceCompositeCode, SourceSimpleItemCode);

Index IdxForGetSection On (InstanceDataID, SourceCompositeCode, SourceSimpleItemCode, SectionCode);

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, SourceCompositeCode, SourceSimpleItemCode, InstanceDataID);

Index IdxForKBNode On (EpisodeID, TemplateID, KBNodeID, SectionCode, SourceCompositeCode, SourceSimpleItemCode, InstanceDataID);

Index IdxICompositeSimpleID On ICompositeSimpleID [ Unique ];

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// docID
Property ChartItemID As %String(TRUNCATE = 1);

/// 实例ID
Property InstanceDataID As %String(TRUNCATE = 1);

/// 简单元素打散表rowID
Property ICompositeSimpleID As %String(TRUNCATE = 1);

/// 知识库ID
Property KBNodeID As %String(TRUNCATE = 1);

/// 章节编码
Property SectionCode As %String(TRUNCATE = 1);

/// 简单元素原始编码
Property SourceCompositeCode As %String(TRUNCATE = 1);

/// 知识库原始编码
Property SourceSimpleItemCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ICompSimpExpandDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>TemplateID</Value>
</Value>
<Value name="4">
<Value>ChartItemID</Value>
</Value>
<Value name="5">
<Value>InstanceDataID</Value>
</Value>
<Value name="6">
<Value>ICompositeSimpleID</Value>
</Value>
<Value name="7">
<Value>SourceCode</Value>
</Value>
<Value name="8">
<Value>KBNodeID</Value>
</Value>
<Value name="9">
<Value>SectionCode</Value>
</Value>
<Value name="10">
<Value>CompositeCode</Value>
</Value>
<Value name="11">
<Value>SimpleItemCode</Value>
</Value>
<Value name="12">
<Value>SourceCompositeCode</Value>
</Value>
<Value name="13">
<Value>SourceSimpleItemCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ICompSimpExpandD</DataLocation>
<DefaultData>ICompSimpExpandDefaultData</DefaultData>
<IdLocation>^DHCEMRI.ICompSimpExpandD</IdLocation>
<IndexLocation>^DHCEMRI.ICompSimpExpandI</IndexLocation>
<StreamLocation>^DHCEMRI.ICompSimpExpandS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

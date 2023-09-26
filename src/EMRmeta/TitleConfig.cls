Class EMRmeta.TitleConfig Extends (%Persistent, %XML.Adaptor)
{

/// 类型为DOCID的parentId
Property CategoryID As %String(TRUNCATE = 1);

/// 字典代码
Property TitleCode As %String(TRUNCATE = 1);

/// 是否另立单页
Property PageBreak As %String(TRUNCATE = 1);

/// 是否另页书写
Property PageNextBreak As %String(TRUNCATE = 1);

/// 标题顺序
Property Sequence As %Integer;

/// 是否默认加载知识库 True为默认加载，False为默认不加载
Property AutoLoad As %String;

/// 分组ID
Property GroupID As %String;

/// 关联模板ID
Property TemplateID As %String;

/// 是否唯一创建 False为重复创建，true唯一创建
Property UniqueCreate As %String;

/// False选择加载，true为默认加载
Property DefaultLoad As %String;

Relationship ColumnConfig As EMRmeta.TitleColConfig [ Cardinality = children, Inverse = TitleConfig ];

Index IdxCategorySequence On (CategoryID, Sequence);

Index IdxTitleCode On TitleCode;

Index IdxCategoryTitleCodeTemplate On (CategoryID, TitleCode, TemplateID);

Index IdxTitleCodeUniqueCreate On (TitleCode, UniqueCreate);

Index IdxCategoryDefaultLoadSequence On (CategoryID, DefaultLoad, Sequence);

Index IdxCategoryTitleCode On (CategoryID, TitleCode);

Storage Default
{
<Data name="TitleConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>TitleCode</Value>
</Value>
<Value name="4">
<Value>PageBreak</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>AutoLoad</Value>
</Value>
<Value name="7">
<Value>GroupID</Value>
</Value>
<Value name="8">
<Value>TemplateID</Value>
</Value>
<Value name="9">
<Value>UniqueCreate</Value>
</Value>
<Value name="10">
<Value>DefaultLoad</Value>
</Value>
<Value name="11">
<Value>PageNextBreak</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TitleConfigD</DataLocation>
<DefaultData>TitleConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TitleConfigD</IdLocation>
<IndexLocation>^DHCEMRM.TitleConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.TitleConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 名称:		CT.EMR.DOC.TemElementTypes
/// 描述:		文档结构元素类型
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class CT.EMR.DOC.TemElementTypes Extends %Persistent
{

Index IdxCode On Code;

Index IdxTypeCode On (Type, Code);

/// 元素分类(seciton/composite/simple/medformula)
Property Type As %String(TRUNCATE = 1);

/// 编码(seciton:Section，composite:MIConcept,simple:MIString/MINumber/MIDateTime/MIList/MIRadioGroup/MICheckbox,medformula:IMacroDesc/IMacroSample)
Property Code As %String(TRUNCATE = 1);

/// 名称章节，复合元素，(字符型元素/数值型元素/日期型元素/列表型元素/单选型元素/多选型元素)，医学公式（月经生育史/月经生育史子元素)
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="TemElementTypesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.TemElementTypesD</DataLocation>
<DefaultData>TemElementTypesDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.TemElementTypesD</IdLocation>
<IndexLocation>^CT.EMR.DOC.TemElementTypesI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.TemElementTypesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

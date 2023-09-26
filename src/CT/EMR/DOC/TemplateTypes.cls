/// 名称:	CT.EMR.DOC.TemplateTypes
/// 描述:	通用文档管理模块 文档类型
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-06
/// 产品组：电子病历产品组
Class CT.EMR.DOC.TemplateTypes Extends %Persistent
{

Index IdxCode On Code;

// Property Product As CT.EMR.DOC.Products;

/// 项目标识
/// 编码(DOC/GRID/FREEFORM)
Property Code As %String(TRUNCATE = 1);

/// 名称(文档/表单/自由表单(发布不用控制术语关联))
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="TemplateTypesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Product</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.TemplateTypesD</DataLocation>
<DefaultData>TemplateTypesDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.TemplateTypesD</IdLocation>
<IndexLocation>^CT.EMR.DOC.TemplateTypesI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.TemplateTypesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

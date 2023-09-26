/// 名称:		CT.EMR.DOC.DicFunctionTypes
/// 描述:		通用文档管理-功能字典类型表
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class CT.EMR.DOC.DictFunctionTypes Extends %Persistent
{

Index IdxCode On Code;

// 项目标识

// Property Product As CT.EMR.DOC.Products;

/// 编码(funcGroup/funcItem/funcMenuNode/funcMenu/funcMenuSub/funcBtn )
Property Code As %String(TRUNCATE = 1);

/// 名称(功能分组/功能项/右键菜单节点/右键菜单/右键子菜单/功能按钮)
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DictFunctionTypesDefaultData">
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
<DataLocation>^CT.EMR.DOC.DictFunctionTypesD</DataLocation>
<DefaultData>DictFunctionTypesDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.DictFunctionTypesD</IdLocation>
<IndexLocation>^CT.EMR.DOC.DictFunctionTypesI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.DictFunctionTypesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

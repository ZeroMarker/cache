/// 名称:	CT.EMR.DOC.DictFunction
/// 描述:	通用文档管理模块 Document(Doc) 角色权限管理-功能字典表
/// 编写者：yejian
/// 编写日期: 2020-11-9
Class CT.EMR.DOC.DictFunction Extends %Persistent
{

Index IdxCode On FuncCode;

Index IdxParentCode On ParentCode;

Index IdxPCCode On (ParentCode, FuncCode);

Index IdxRowId On (ParentID, Sequence);

// 项目标识

// Property Product As CT.EMR.DOC.Products;

/// 功能编码
Property FuncCode As %String(TRUNCATE = 1);

/// 功能名称
Property FuncName As %String(TRUNCATE = 1);

/// 功能描述
Property FuncDesc As %String(TRUNCATE = 1);

/// 功能url
Property FuncUrl As %String(TRUNCATE = 1);

/// 类型 funcCategory/funcItem/funcMenuNode/funcMenu/funcMenuSub/funcBtn 
Property Type As CT.EMR.DOC.DictFunctionTypes;

/// 顺序
Property Sequence As %Integer;

/// 父节点
Property ParentID As %Integer;

/// 父节点编码
Property ParentCode As %String(TRUNCATE = 1);

/// 权限标识
Property Perms As %String(TRUNCATE = 1);

/// 菜单图标
Property Icon As %String(TRUNCATE = 1);

/// 路由地址
Property Path As %String(TRUNCATE = 1);

/// 组件路径
Property Component As %String(TRUNCATE = 1);

/// 菜单类型（M目录，C菜单，F按钮）
Property MenuType As %String(TRUNCATE = 1);

/// 菜单状态（0显示，1隐藏）
Property Visible As %String(TRUNCATE = 1);

/// 更新时间
Property UpdateTime As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DictFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FuncCode</Value>
</Value>
<Value name="3">
<Value>FuncName</Value>
</Value>
<Value name="4">
<Value>FuncDesc</Value>
</Value>
<Value name="5">
<Value>FuncUrl</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>ParentID</Value>
</Value>
<Value name="9">
<Value>ParentCode</Value>
</Value>
<Value name="10">
<Value>Perms</Value>
</Value>
<Value name="11">
<Value>Icon</Value>
</Value>
<Value name="12">
<Value>Path</Value>
</Value>
<Value name="13">
<Value>Component</Value>
</Value>
<Value name="14">
<Value>MenuType</Value>
</Value>
<Value name="15">
<Value>Visible</Value>
</Value>
<Value name="16">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.DictFunctionD</DataLocation>
<DefaultData>DictFunctionDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.DictFunctionD</IdLocation>
<IndexLocation>^CT.EMR.DOC.DictFunctionI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.DictFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

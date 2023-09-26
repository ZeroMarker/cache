/// 名称:	CT.MA.QC.QualityDictFunction
/// 描述:	病历质控维护程序——角色权限管理-功能字典表
/// 编写者：hky
/// 编写日期: 2021-07-14
Class CT.MA.QC.QualityDictFuntion Extends %Persistent
{

Index IdxFuncCode On FuncCode [ Unique ];

Index IdxParentID On ParentID;

/// 功能编码
Property FuncCode As %String(TRUNCATE = 1);

/// 功能名称
Property FuncName As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

/// 父节点
Property ParentID As %Integer;

Storage Default
{
<Data name="QualityDictFuntionDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityDictFuntionD</DataLocation>
<DefaultData>QualityDictFuntionDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityDictFuntionD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityDictFuntionI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityDictFuntionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 基础数据关联表 
Class CT.BSP.MSG.BaseDataLink Extends %Persistent
{

/// 关联类型
Property LinkKey As %String(COLLATION = "Exact") [ Required ];

/// 源数据类型
Property SrcRefType As %String(COLLATION = "Exact") [ Required ];

/// 源数据ID
Property SrcRefObjId As %String(COLLATION = "Exact") [ Required ];

/// 关联数据类型
Property LinkRefType As %String(COLLATION = "Exact") [ Required ];

/// 关联数据ID
Property LinkRefObjId As %String(COLLATION = "Exact") [ Required ];

Index SRCDATA On (LinkKey, SrcRefType, SrcRefObjId);

Storage Default
{
<Data name="BaseDataLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LinkKey</Value>
</Value>
<Value name="3">
<Value>SrcRefType</Value>
</Value>
<Value name="4">
<Value>SrcRefObjId</Value>
</Value>
<Value name="5">
<Value>LinkRefType</Value>
</Value>
<Value name="6">
<Value>LinkRefObjId</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.MSG.BaseDataLinkD</DataLocation>
<DefaultData>BaseDataLinkDefaultData</DefaultData>
<IdLocation>^CT.BSP.MSG.BaseDataLinkD</IdLocation>
<IndexLocation>^CT.BSP.MSG.BaseDataLinkI</IndexLocation>
<StreamLocation>^CT.BSP.MSG.BaseDataLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

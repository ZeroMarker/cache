/// Desc: 自定义字典
/// Creator:Candy
/// 
Class DHCEPRFS.META.CustomDic Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 字典代码列
Property CtmDictCode As %String(TRUNCATE = 1);

/// 字典描述列
Property CtmDictDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 字典别名列
Property CtmDictAlias As %String(TRUNCATE = 1);

/// 字典类型
Property CtmDictType As %String(TRUNCATE = 1);

/// 是否有效
Property CtmIsActive As %String(TRUNCATE = 1);

/// 顺序
Property CtmIndex As %String(TRUNCATE = 1);

Index IdxCtmDictType On CtmDictType;

Index IdxTypeIndex On (CtmDictType, CtmIndex);

Index IdxTypeCode On (CtmDictType, CtmDictCode);

Storage Default
{
<Data name="CustomDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtmDictAlias</Value>
</Value>
<Value name="3">
<Value>CtmDictCode</Value>
</Value>
<Value name="4">
<Value>CtmDictDesc</Value>
</Value>
<Value name="5">
<Value>CtmDictType</Value>
</Value>
<Value name="6">
<Value>CtmIndex</Value>
</Value>
<Value name="7">
<Value>CtmIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CustomDicD</DataLocation>
<DefaultData>CustomDicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.CustomDicD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CustomDicI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CustomDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

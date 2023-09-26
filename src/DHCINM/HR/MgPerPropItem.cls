/// 护理档案属性变更记录
/// Creator     ChenPeng
/// CreateDate  2023-02-11
Class DHCINM.HR.MgPerPropItem Extends (%Persistent, %Populate)
{

/// 护士档案操作记录
Relationship PerOperate As DHCINM.HR.MgPerOperate [ Cardinality = parent, Inverse = PerPropItem ];

/// 属性名
Property Prop As %String [ SqlColumnNumber = 2, SqlFieldName = Per_PropName ];

/// 属性类型
Property Type As %String [ SqlColumnNumber = 3, SqlFieldName = Per_PropType ];

/// 修改后的值
Property NewVal As %String [ SqlColumnNumber = 4, SqlFieldName = Per_PropNewVal ];

/// 修改前的值
Property OldVal As %String [ SqlColumnNumber = 5, SqlFieldName = Per_PropOldVal ];

/// Relationship PerOperate As DHCINM.HR.MgPerOperate [ Cardinality = parent, Inverse = PerPropItem ];
Storage Default
{
<Data name="PerPropItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Prop</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>NewVal</Value>
</Value>
<Value name="5">
<Value>OldVal</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgPerPropItemD</DataLocation>
<DefaultData>MgPerPropItemDefaultData</DefaultData>
<Description>
<![CDATA[Relationship PerOperate As DHCINM.HR.MgPerOperate [ Cardinality = parent, Inverse = PerPropItem ];]]></Description>
<IdLocation>^DHCINM.HR.MgPerPropItemD</IdLocation>
<IndexLocation>^DHCINM.HR.MgPerPropItemI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgPerPropItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

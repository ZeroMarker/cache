/// 名称:     护理病历病人列表查询条件子表
/// 描述:     用于组合查询病人列表数据
/// 编写者：  yaojining
/// 编写日期: 2022.11.10
/// 产品组：  护理
Class CT.NUR.EMR.PatFilterItem Extends (%Persistent, User.Abstract) [ SqlTableName = PatFilterItem ]
{

Relationship FIPFParRef As CT.NUR.EMR.PatFilter [ Cardinality = parent, Inverse = PFFIChildSub, Required, SqlFieldName = FI_PF_ParRef ];

/// 描述
Property FIDesc As %String [ SqlColumnNumber = 2, SqlFieldName = FI_Desc ];

/// 描述
Property FICode As %String [ SqlColumnNumber = 3, SqlFieldName = FI_Code ];

/// 图标
Property FIIcon As %String [ SqlColumnNumber = 4, SqlFieldName = FI_Icon ];

/// 状态
Property FIStatusDR As CT.NUR.EMR.StatusDict [ SqlColumnNumber = 5, SqlFieldName = FI_Status_DR ];

Storage Default
{
<Data name="PatFilterItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FIDesc</Value>
</Value>
<Value name="3">
<Value>FICode</Value>
</Value>
<Value name="4">
<Value>FIIcon</Value>
</Value>
<Value name="5">
<Value>FIStatusDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PFFIChildSub")</DataLocation>
<DefaultData>PatFilterItemDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.PatFilterC("PFFIChildSub")</IdLocation>
<IndexLocation>^CT.NUR.EMR.PatFilterItemI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.PatFilterItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

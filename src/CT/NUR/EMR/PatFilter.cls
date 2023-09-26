/// 名称:     护理病历病人列表查询条件父表
/// 描述:     用于组合查询病人列表数据
/// 编写者：  yaojining
/// 编写日期: 2022.11.10
/// 产品组：  护理
Class CT.NUR.EMR.PatFilter Extends (%Persistent, User.Abstract) [ SqlTableName = PatFilter ]
{

Relationship PFFIChildSub As CT.NUR.EMR.PatFilterItem [ Cardinality = children, Inverse = FIPFParRef ];

/// 描述
Property PFDesc As %String [ SqlColumnNumber = 2, SqlFieldName = PF_Desc ];

/// 代码
Property PFCode As %String [ SqlColumnNumber = 3, SqlFieldName = PF_Code ];

/// 图标
Property PFIcon As %String [ SqlColumnNumber = 4, SqlFieldName = PF_Icon ];

/// 状态
Property PFStatusDR As CT.NUR.EMR.StatusDict [ SqlColumnNumber = 5, SqlFieldName = PF_Status_DR ];

Storage Default
{
<Data name="PatFilterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PFDesc</Value>
</Value>
<Value name="3">
<Value>PFCode</Value>
</Value>
<Value name="4">
<Value>PFIcon</Value>
</Value>
<Value name="5">
<Value>PFStatusDR</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.PatFilterD</DataLocation>
<DefaultData>PatFilterDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.PatFilterD</IdLocation>
<IndexLocation>^CT.NUR.EMR.PatFilterI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.PatFilterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 名称:     护理病历科室类型、在院类型字典表
/// 描述:     用于护理病历科室类型、在院类型字典对照
/// 编写者：  yaojining
/// 编写日期: 2022.09.27
/// 产品组：  护理
Class CT.NUR.EMR.VisitDict Extends (%Persistent, User.Abstract) [ SqlTableName = VisitDict ]
{

/// 代码
Property VDCode As %String [ SqlColumnNumber = 2, SqlFieldName = VD_Code ];

/// 描述
Property VDDesc As %String [ SqlColumnNumber = 3, SqlFieldName = VD_Desc ];

/// 更新人
Property VDUpdateUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = VD_UpdateUser_DR ];

/// 更新日期
Property VDUpdateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 5, SqlFieldName = VD_UpdateDate ];

/// 更新时间
Property VDUpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 6, SqlFieldName = VD_UpdateTime ];

Index Code On VDCode;

Storage Default
{
<Data name="VisitDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VDCode</Value>
</Value>
<Value name="3">
<Value>VDDesc</Value>
</Value>
<Value name="4">
<Value>VDUpdateUserDR</Value>
</Value>
<Value name="5">
<Value>VDUpdateDate</Value>
</Value>
<Value name="6">
<Value>VDUpdateTime</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.VisitDictD</DataLocation>
<DefaultData>VisitDictDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.VisitDictD</IdLocation>
<IndexLocation>^CT.NUR.EMR.VisitDictI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.VisitDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

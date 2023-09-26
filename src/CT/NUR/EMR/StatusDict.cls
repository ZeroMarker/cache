/// 名称:     护理病历状态字典表
/// 描述:     用于护理病历状态字典对照
/// 编写者：  yaojining
/// 编写日期: 2022.09.27
/// 产品组：  护理
Class CT.NUR.EMR.StatusDict Extends (%Persistent, User.Abstract) [ SqlTableName = StatusDict ]
{

/// 代码
Property SDCode As %String [ SqlColumnNumber = 2, SqlFieldName = SD_Code ];

/// 描述
Property SDDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SD_Desc ];

/// 更新人
Property SDUpdateUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = SD_UpdateUser_DR ];

/// 更新日期
Property SDUpdateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 5, SqlFieldName = SD_UpdateDate ];

/// 更新时间
Property SDUpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 6, SqlFieldName = SD_UpdateTime ];

Index Code On SDCode;

Storage Default
{
<Data name="StatusDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDCode</Value>
</Value>
<Value name="3">
<Value>SDDesc</Value>
</Value>
<Value name="4">
<Value>SDUpdateUserDR</Value>
</Value>
<Value name="5">
<Value>SDUpdateDate</Value>
</Value>
<Value name="6">
<Value>SDUpdateTime</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.StatusDictD</DataLocation>
<DefaultData>StatusDictDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.StatusDictD</IdLocation>
<IndexLocation>^CT.NUR.EMR.StatusDictI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.StatusDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Creator:      yaojining
/// CreatDate:    2022.09.27
/// Description:  护理病历功能开关配置项目表（新）
Class CT.NUR.EMR.SettingsItem Extends (%Persistent, User.Abstract) [ SqlTableName = SettingsItem ]
{

/// 键
Property SIKey As %String [ SqlColumnNumber = 2, SqlFieldName = SI_Key ];

/// 默认数据类型
Property SIDefType As %String [ SqlColumnNumber = 3, SqlFieldName = SI_DefType ];

/// 默认值
Property SIDefValue As %String [ SqlColumnNumber = 4, SqlFieldName = SI_DefValue ];

/// 描述
Property SIDesc As %String [ SqlColumnNumber = 5, SqlFieldName = SI_Desc ];

/// 页面类别
Property SIPageCode As %String [ SqlColumnNumber = 6, SqlFieldName = SI_PageCode ];

/// 状态
Property SIStatusDR As CT.NUR.EMR.StatusDict [ SqlColumnNumber = 7, SqlFieldName = SI_Status_DR ];

/// 备注
Property SIRemark As %String(MAXLEN = 5000) [ SqlColumnNumber = 8, SqlFieldName = SI_Remark ];

/// 可见性
Property SIVisibleDR As CT.NUR.EMR.StatusDict [ SqlColumnNumber = 9, SqlFieldName = SI_Visible_DR ];

Index Key On SIKey;

Index TypeKey On (SIDefType, SIKey);

Index CodeKey On (SIPageCode, SIKey);

Storage Default
{
<Data name="SettingsItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SIKey</Value>
</Value>
<Value name="3">
<Value>SIDefType</Value>
</Value>
<Value name="4">
<Value>SIDefValue</Value>
</Value>
<Value name="5">
<Value>SIDesc</Value>
</Value>
<Value name="6">
<Value>SIPageCode</Value>
</Value>
<Value name="7">
<Value>SIStatusDR</Value>
</Value>
<Value name="8">
<Value>SIRemark</Value>
</Value>
<Value name="9">
<Value>SIVisibleDR</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.SettingsItemD</DataLocation>
<DefaultData>SettingsItemDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.SettingsItemD</IdLocation>
<IndexLocation>^CT.NUR.EMR.SettingsItemI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.SettingsItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Creator:guozj
/// Descriptions:护理信息（护士层级）
/// Date:2017-08-30
/// 
Class DHCNMG.HR.MgLevel Extends %Persistent
{

/// 人员档案id
Property LevelPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Level_PerDR ];

/// 护士层级
Property NurLevel As %String [ SqlColumnNumber = 3, SqlFieldName = Nur_Level ];

/// 晋升日期
Property LevelDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Level_Date ];

/// 备注
Property LevelRemark As %String(MAXLEN = 2000) [ SqlColumnNumber = 5, SqlFieldName = Level_Remark ];

/// 状态【A：已审核 N：未提交 Y:提交】
Property LevelStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Level_Status ];

/// 层级系数
Property LevelFactor As %String [ SqlColumnNumber = 7, SqlFieldName = Level_Factor ];

Index ssid On LevelPerDR;

Index date On (LevelDate, LevelPerDR);

Index perDate On (LevelPerDR, LevelDate);

Storage Default
{
<Data name="MgLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LevelPerDR</Value>
</Value>
<Value name="3">
<Value>NurLevel</Value>
</Value>
<Value name="4">
<Value>LevelDate</Value>
</Value>
<Value name="5">
<Value>LevelRemark</Value>
</Value>
<Value name="6">
<Value>LevelStatus</Value>
</Value>
<Value name="7">
<Value>LevelFactor</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgLevelD</DataLocation>
<DefaultData>MgLevelDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgLevelD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgLevelI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

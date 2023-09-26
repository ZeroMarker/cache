/// 
/// 
/// 科研基金
Class DHCNMG.HR.MgResearch Extends %Persistent
{

/// 人员档案id
Property ReseaPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Resea_PerDR ];

/// 科研名称
Property ReseaTitle As %String [ SqlColumnNumber = 3, SqlFieldName = Resea_Title ];

/// 科研级别
Property ReseaLevel As %String [ SqlColumnNumber = 4, SqlFieldName = Resea_Level ];

/// 立项日期(年)
Property ReseaDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Resea_Date ];

/// 经费
Property ReseaFee As %String [ SqlColumnNumber = 6, SqlFieldName = Resea_Fee ];

/// 排位
Property ReseaRank As %String [ SqlColumnNumber = 7, SqlFieldName = Resea_Rank ];

/// 状态
Property ReseaStatus As %String [ SqlColumnNumber = 8, SqlFieldName = Resea_Status ];

Property ReseaUser As %String [ SqlColumnNumber = 9, SqlFieldName = Resea_User ];

Index ssid On ReseaPerDR;

Index date On (ReseaDate, ReseaPerDR);

Storage Default
{
<Data name="MgResearchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResPerDR</Value>
</Value>
<Value name="3">
<Value>ReseaPerDR</Value>
</Value>
<Value name="4">
<Value>ReseaTitle</Value>
</Value>
<Value name="5">
<Value>ReseaLevel</Value>
</Value>
<Value name="6">
<Value>ReseaDate</Value>
</Value>
<Value name="7">
<Value>ReseaFee</Value>
</Value>
<Value name="8">
<Value>ReseaRank</Value>
</Value>
<Value name="9">
<Value>ReseaStatus</Value>
</Value>
<Value name="10">
<Value>ReseaUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgResearchD</DataLocation>
<DefaultData>MgResearchDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgResearchD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgResearchI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgResearchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

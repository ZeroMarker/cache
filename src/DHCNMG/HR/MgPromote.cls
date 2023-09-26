/// 
/// 
/// 适宜推广技术
Class DHCNMG.HR.MgPromote Extends %Persistent
{

/// 人员档案id
Property PromotePerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Promote_PerDR ];

/// 项目名称
Property PromoteTitle As %String [ SqlColumnNumber = 3, SqlFieldName = Promote_Title ];

/// 年度（开始）（年）
Property PromoteStYear As %Date [ SqlColumnNumber = 4, SqlFieldName = Promote_StYear ];

/// 年度（截止）（年）
Property PromoteEndYear As %Date [ SqlColumnNumber = 5, SqlFieldName = Promote_EndYear ];

/// 培训班次数
Property PromoteNum As %String [ SqlColumnNumber = 6, SqlFieldName = Promote_Num ];

/// 受训人数
Property PromoteNurse As %String [ SqlColumnNumber = 7, SqlFieldName = Promote_Nurse ];

/// 状态
Property PromoteStatus As %String [ SqlColumnNumber = 8, SqlFieldName = Promote_Status ];

Property PromoteUser As %String [ SqlColumnNumber = 9, SqlFieldName = Promote_User ];

Index ssid On PromotePerDR;

Storage Default
{
<Data name="MgPromoteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PromotePerDR</Value>
</Value>
<Value name="3">
<Value>PromoteTitle</Value>
</Value>
<Value name="4">
<Value>PromoteStYear</Value>
</Value>
<Value name="5">
<Value>PromoteEndYear</Value>
</Value>
<Value name="6">
<Value>PromoteNum</Value>
</Value>
<Value name="7">
<Value>PromoteNurse</Value>
</Value>
<Value name="8">
<Value>PromoteStatus</Value>
</Value>
<Value name="9">
<Value>PromoteUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgPromoteD</DataLocation>
<DefaultData>MgPromoteDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgPromoteD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgPromoteI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgPromoteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

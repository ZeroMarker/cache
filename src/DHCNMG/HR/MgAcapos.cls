/// 
/// 
/// 学术任职
Class DHCNMG.HR.MgAcapos Extends %Persistent
{

/// 人员档案id
Property AcaposPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Acapos_PerDR ];

/// 任职单位
Property AcaposUnit As %String [ SqlColumnNumber = 3, SqlFieldName = Acapos_Unit ];

/// 开始日期
Property AcaposStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Acapos_StDate ];

/// 结束日期
Property AcaposEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Acapos_EndDate ];

/// 职务
Property AcaposPost As %String [ SqlColumnNumber = 6, SqlFieldName = Acapos_Post ];

/// 状态
Property AcaposStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Acapos_Status ];

Property AcaposUser As %String [ SqlColumnNumber = 8, SqlFieldName = Acapos_User ];

Index ssid On AcaposPerDR;

Storage Default
{
<Data name="MgAcaposDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcaposPerDR</Value>
</Value>
<Value name="3">
<Value>AcaposUnit</Value>
</Value>
<Value name="4">
<Value>AcaposStDate</Value>
</Value>
<Value name="5">
<Value>AcaposEndDate</Value>
</Value>
<Value name="6">
<Value>AcaposPost</Value>
</Value>
<Value name="7">
<Value>AcaposStatus</Value>
</Value>
<Value name="8">
<Value>AcaposUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgAcaposD</DataLocation>
<DefaultData>MgAcaposDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgAcaposD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgAcaposI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgAcaposS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

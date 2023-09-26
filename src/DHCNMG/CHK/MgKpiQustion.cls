Class DHCNMG.CHK.MgKpiQustion Extends %Persistent
{

/// KpiItemSub ID
Property QuesKpiItemSubDR As DHCNMG.DB.MgKpiItemSub [ Required, SqlColumnNumber = 2, SqlFieldName = Ques_KpiItemSubDR ];

/// KpiGroup ID
Property QuesKpiGroupDR As DHCNMG.DB.MgKpiGroup [ Required, SqlColumnNumber = 3, SqlFieldName = Ques_KpiGroupDR ];

/// Ward ID
Property QuesWardDR As DHCNMG.DB.MgWard [ Required, SqlColumnNumber = 4, SqlFieldName = Ques_WardDR ];

/// 得分
Property QuesScore As %String [ Required, SqlColumnNumber = 5, SqlFieldName = Ques_Score ];

/// KpiCheck ID
Property QuesKpiCheckDR As DHCNMG.CHK.MgKpiCheck [ Required, SqlColumnNumber = 6, SqlFieldName = Ques_KpiCheckDR ];

Index KpiItemSubTimesIndex On (QuesKpiItemSubDR, QuesWardDR);

Index WardTimesIndex On (QuesWardDR, QuesKpiItemSubDR);

Storage Default
{
<Data name="MgKpiQustionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesKpiItemSubDR</Value>
</Value>
<Value name="3">
<Value>QuesKpiGroupDR</Value>
</Value>
<Value name="4">
<Value>QuesWardDR</Value>
</Value>
<Value name="5">
<Value>QuesScore</Value>
</Value>
<Value name="6">
<Value>QuesCheckDR</Value>
</Value>
<Value name="7">
<Value>QuesKpiCheckDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgKpiQustionD</DataLocation>
<DefaultData>MgKpiQustionDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgKpiQustionD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgKpiQustionI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgKpiQustionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

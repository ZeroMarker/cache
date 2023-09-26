/// Descriptions:微信端满意度
/// Date:2018-04-19
/// Creator:gzj
Class DHCNMG.Work.MgNurSatisfy Extends %Persistent
{

/// 年月
Property WorkMonth As %Integer [ SqlColumnNumber = 2, SqlFieldName = Work_Month ];

/// 患者就诊号
Property WorkAdm As %String [ SqlColumnNumber = 3, SqlFieldName = Work_Adm ];

/// 护士人员表ID
Property WorkNurse As %String [ SqlColumnNumber = 4, SqlFieldName = Work_Nurse ];

/// 满意度 【满意：1  不满意：0】
Property WorkSatify As %String [ SqlColumnNumber = 5, SqlFieldName = Work_Satify ];

Index Date On (WorkAdm, WorkMonth, WorkNurse);

Storage Default
{
<Data name="MgNurSatisfyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkMonth</Value>
</Value>
<Value name="3">
<Value>WorkAdm</Value>
</Value>
<Value name="4">
<Value>WorkNurse</Value>
</Value>
<Value name="5">
<Value>WorkSatify</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgNurSatisfyD</DataLocation>
<DefaultData>MgNurSatisfyDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgNurSatisfyD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurSatisfyI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurSatisfyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

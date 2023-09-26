/// creator:lulin
/// createdate:2018-04-10
/// description:历史护患比
Class DHCNMG.Sens.MgNurPR Extends %Persistent
{

/// 病区
Property NurPRWard As DHCNMG.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = NurPR_Ward ];

/// 日期
Property NurPRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = NurPR_Date ];

/// 白班护士总数
Property NurPRNurNum As %String [ SqlColumnNumber = 4, SqlFieldName = NurPR_NurNum ];

/// 白班患者总数
Property NurPRPatNum As %String [ SqlColumnNumber = 5, SqlFieldName = NurPR_PatNum ];

/// 白班护患比
Property NurPRNurPR As %String [ SqlColumnNumber = 6, SqlFieldName = NurPR_NurPR ];

/// 夜班护士总数
Property NurPRNurNumN As %String [ SqlColumnNumber = 7, SqlFieldName = NurPR_NurNumN ];

/// 夜班患者总数
Property NurPRPatNumN As %String [ SqlColumnNumber = 8, SqlFieldName = NurPR_PatNumN ];

/// 夜班护患比
Property NurPRNurPRN As %String [ SqlColumnNumber = 9, SqlFieldName = NurPR_NurPRN ];

Index ward On NurPRWard;

Index dateward On (NurPRDate, NurPRWard);

Storage Default
{
<Data name="MgNurPRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurPRWard</Value>
</Value>
<Value name="3">
<Value>NurPRDate</Value>
</Value>
<Value name="4">
<Value>NurPRNurNum</Value>
</Value>
<Value name="5">
<Value>NurPRPatNum</Value>
</Value>
<Value name="6">
<Value>NurPRNurPR</Value>
</Value>
<Value name="7">
<Value>NurPRNurNumN</Value>
</Value>
<Value name="8">
<Value>NurPRPatNumN</Value>
</Value>
<Value name="9">
<Value>NurPRNurPRN</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Sens.MgNurPRD</DataLocation>
<DefaultData>MgNurPRDefaultData</DefaultData>
<IdLocation>^DHCNMG.Sens.MgNurPRD</IdLocation>
<IndexLocation>^DHCNMG.Sens.MgNurPRI</IndexLocation>
<StreamLocation>^DHCNMG.Sens.MgNurPRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

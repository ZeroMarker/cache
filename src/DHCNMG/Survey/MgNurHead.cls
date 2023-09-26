/// Creator: guozj
/// Createdate: 2018-01-23
/// Description：病区护士长【南方医院版】
Class DHCNMG.Survey.MgNurHead Extends %Persistent
{

/// 姓名
Property NurHeadName As %String [ SqlColumnNumber = 2, SqlFieldName = NurHead_Name ];

/// 工号
Property NurHeadNo As %String [ SqlColumnNumber = 3, SqlFieldName = NurHead_No ];

/// HIS工号
Property NurHeadHISNo As %String [ SqlColumnNumber = 4, SqlFieldName = NurHead_HISNo ];

/// 所辖病区
Property NurHeadWard As %String [ SqlColumnNumber = 5, SqlFieldName = NurHead_Ward ];

/// 类型
Property NurHeadType As %String [ SqlColumnNumber = 6, SqlFieldName = NurHead_Type ];

Index HeadNo On NurHeadNo;

Index HISNO On NurHeadHISNo;

Storage Default
{
<Data name="MgNurHeadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurHeadName</Value>
</Value>
<Value name="3">
<Value>NurHeadNo</Value>
</Value>
<Value name="4">
<Value>NurHeadHISNo</Value>
</Value>
<Value name="5">
<Value>NurHeadWard</Value>
</Value>
<Value name="6">
<Value>NurHeadType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Survey.MgNurHeadD</DataLocation>
<DefaultData>MgNurHeadDefaultData</DefaultData>
<IdLocation>^DHCNMG.Survey.MgNurHeadD</IdLocation>
<IndexLocation>^DHCNMG.Survey.MgNurHeadI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.MgNurHeadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class DHCINM.HR.MgPartTimeRow Extends %Persistent
{

/// 兼职科室表
Property WardDr As %String [ SqlColumnNumber = 2, SqlFieldName = PTRow_Ward ];

/// 兼职岗位表
Property PostDr As %String [ SqlColumnNumber = 3, SqlFieldName = PTRow_PostDr ];

/// 周一日期
Property MonDay As %Date [ SqlColumnNumber = 4, SqlFieldName = PTRow_Date ];

/// 备注
Property Remark As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = PTRow_Remark ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 6, SqlFieldName = PTRow_Creator ];

Index remark On (WardDr, PostDr, MonDay, Remark);

Storage Default
{
<Data name="MgPartTimeRowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDr</Value>
</Value>
<Value name="3">
<Value>PostDr</Value>
</Value>
<Value name="4">
<Value>MonDay</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgPartTimeRowD</DataLocation>
<DefaultData>MgPartTimeRowDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgPartTimeRowD</IdLocation>
<IndexLocation>^DHCINM.HR.MgPartTimeRowI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgPartTimeRowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

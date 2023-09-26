/// creator: zhangjz
/// Description：工作量月报
/// Date:2018-08-20
Class DHCNMG.Work.MgNurWorkRp Extends %Persistent
{

Property WorkTitle As %String(TRUNCATE = 1);

/// 开始日期
Property WorkStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = Work_StDate ];

/// Work_EndDate	结束日期
Property WorkEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = Work_EndDate ];

/// Work_CreateUser	创建人
Property WorkCreateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Work_CreateUser ];

/// Work_CreateDate	创建日期
Property WorkCreateDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 6, SqlFieldName = Work_CreateDate ];

/// Work_CreatTime	创建时间
Property WorkCreatTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = Work_CreatTime ];

Property WorkMem As %String(TRUNCATE = 1);

/// 月
Property WorkRpMon As %String(TRUNCATE = 1);

Index CDate On WorkCreateDate;

Index StDate On WorkStDate;

Storage Default
{
<Data name="MgNurWorkRpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkTitle</Value>
</Value>
<Value name="3">
<Value>WorkStDate</Value>
</Value>
<Value name="4">
<Value>WorkEndDate</Value>
</Value>
<Value name="5">
<Value>WorkCreateUser</Value>
</Value>
<Value name="6">
<Value>WorkCreateDate</Value>
</Value>
<Value name="7">
<Value>WorkCreatTime</Value>
</Value>
<Value name="8">
<Value>WorkMem</Value>
</Value>
<Value name="9">
<Value>WorkRpMon</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgNurWorkRpD</DataLocation>
<DefaultData>MgNurWorkRpDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgNurWorkRpD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurWorkRpI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurWorkRpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// creator: zhangjz
/// Description：工作量月报明细表
/// Date:2018-08-20
Class DHCNMG.Work.MgNurWardMonRp Extends %Persistent
{

Relationship ChildRpSub As DHCNMG.Work.MgNurWardMonSubPer [ Cardinality = children, Inverse = WorkRpParef ];

Relationship ChildRpWard As DHCNMG.Work.MgNurWardMonSub [ Cardinality = children, Inverse = WardParref ];

/// Work_Dep_Dr 病区
Property WorkDepDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Work_Dep_Dr ];

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

Property WorkRp As DHCNMG.Work.MgNurWorkRp;

Index Dep On WorkDepDr;

Index StDate On WorkStDate;

Index WorkRp On WorkRp;

Storage Default
{
<Data name="MgNurWardMonRpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkDepDr</Value>
</Value>
<Value name="3">
<Value>WorkTitle</Value>
</Value>
<Value name="4">
<Value>WorkStDate</Value>
</Value>
<Value name="5">
<Value>WorkEndDate</Value>
</Value>
<Value name="6">
<Value>WorkCreateUser</Value>
</Value>
<Value name="7">
<Value>WorkCreateDate</Value>
</Value>
<Value name="8">
<Value>WorkCreatTime</Value>
</Value>
<Value name="9">
<Value>WorkMem</Value>
</Value>
<Value name="10">
<Value>WorkRp</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgNurWardMonRpD</DataLocation>
<DefaultData>MgNurWardMonRpDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgNurWardMonRpD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurWardMonRpI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurWardMonRpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

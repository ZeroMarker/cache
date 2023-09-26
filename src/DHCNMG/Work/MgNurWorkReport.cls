/// creator: zhangjz
/// Description：工作量日报表
/// Date:2018-08-10
Class DHCNMG.Work.MgNurWorkReport Extends %Persistent
{

Relationship ChildSub As DHCNMG.Work.MgNurWorkRpSub [ Cardinality = children, Inverse = WorkRpParef ];

Relationship ChildWard As DHCNMG.Work.MgNurWorkRpWard [ Cardinality = children, Inverse = WardParref ];

/// Work_Dep_Dr Ward病区ID
Property WorkDepDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Work_Dep_Dr ];

/// Work_StDate 开始日期
Property WorkStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = Work_StDate ];

/// Work_EndDate 截止日期
Property WorkEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = Work_EndDate ];

/// Work_CreateUser 创建者
Property WorkCreateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Work_CreateUser ];

/// Work_CreateDate 创建日期
Property WorkCreateDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 6, SqlFieldName = Work_CreateDate ];

/// Work_CreatTime 创建时间
Property WorkCreatTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = Work_CreatTime ];

/// Work_mem
Property Workmem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Work_mem ];

Property WorkRp As DHCNMG.Work.MgNurWorkRp [ SqlColumnNumber = 9, SqlFieldName = WorkRp ];

Index Dep On WorkDepDr;

Index StDate On WorkStDate;

Index WorkRp On WorkRp;

Storage Default
{
<Data name="MgNurWorkReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkDepDr</Value>
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
<Value>Workmem</Value>
</Value>
<Value name="9">
<Value>WorkRp</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgNurWorkReportD</DataLocation>
<DefaultData>MgNurWorkReportDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgNurWorkReportD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurWorkReportI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurWorkReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

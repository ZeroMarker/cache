/// Creator: 王赢赢
/// CreatDate: 2010-4-31
/// Description: 寻找上期去年同期
Class dhc.ca.cache.report.comm.MonthFind Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2010-4-31
/// Description: 
/// Table：
/// Input:type:sq(上期),qt(去年同期),
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.comm.MonthFind).findMonth(1,"sq")
ClassMethod findMonth(monthDr, type) As %String
{
 n (monthDr,type)
 s tmpTypeDr=""
 i type="sq" d
 .s tmpTypeDr=$o(^DHCCAACCPERIOD(0,"Name","上期",tmpTypeDr))
 e  i type="qt" d
 .s tmpTypeDr=$o(^DHCCAACCPERIOD(0,"Name","去年同期",tmpTypeDr))
 q:tmpTypeDr="" -1
 
 s tmpMonSubDr=""
 s tmpMonSubDr=$o(^DHCCAACCOUNTMONTHS(0,"Period",monthDr,tmpTypeDr,tmpMonSubDr))
 q:tmpMonSubDr="" -1
 
 s tmpMonDr=$p(^DHCCAACCOUNTMONTHS(monthDr,"Periods",tmpMonSubDr),"^",2)
 q tmpMonDr
}

Storage Default
{
<Data name="MonthFindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.MonthFindD</DataLocation>
<DefaultData>MonthFindDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.MonthFindD</IdLocation>
<IndexLocation>^dhc.ca.c.MonthFindI</IndexLocation>
<StreamLocation>^dhc.ca.c.MonthFindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

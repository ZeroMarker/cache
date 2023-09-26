Class dhc.ca.cache.report.Balanceofpayments Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Projection blanceofpayments As %Projection.Java(ROOTDIR = "E:\eclipseWorkSpace1\dhccashreport\src");

//金额

Property money As %Float;

//金额类别

Property type As %String(TRUNCATE = 1);

//项目类别

Property itemType As %String(TRUNCATE = 1);

//科室类别

Property deptType As %String(TRUNCATE = 1);

//项目

Property itemName As %String(TRUNCATE = 1);

//科室

Property deptName As %String(TRUNCATE = 1);

//月份名称

Property monthName As %String(TRUNCATE = 1);

//月份

Property month As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BalanceofpaymentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>cost</Value>
</Value>
<Value name="3">
<Value>income</Value>
</Value>
<Value name="4">
<Value>itemAll</Value>
</Value>
<Value name="5">
<Value>itemName</Value>
</Value>
<Value name="6">
<Value>deptName</Value>
</Value>
<Value name="7">
<Value>deptType</Value>
</Value>
<Value name="8">
<Value>itemType</Value>
</Value>
<Value name="9">
<Value>dept</Value>
</Value>
<Value name="10">
<Value>item</Value>
</Value>
<Value name="11">
<Value>money</Value>
</Value>
<Value name="12">
<Value>type</Value>
</Value>
<Value name="13">
<Value>month</Value>
</Value>
<Value name="14">
<Value>monthName</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.BalanceofpaymentsD</DataLocation>
<DefaultData>BalanceofpaymentsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.BalanceofpaymentsD</IdLocation>
<IndexLocation>^dhc.ca.c.BalanceofpaymentsI</IndexLocation>
<StreamLocation>^dhc.ca.c.BalanceofpaymentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// creator: zhangjz
/// Description：工作量日报明细
/// Date:2018-08-10
Class DHCNMG.Work.MgNurWorkRpSub Extends %Persistent
{

Relationship WorkRpParef As DHCNMG.Work.MgNurWorkReport [ Cardinality = parent, Inverse = ChildSub ];

Property WorkRpSubItmDR As DHCNMG.DB.MgNurWorkLoadItm [ SqlColumnNumber = 3, SqlFieldName = WorkRpSub_Itm_DR ];

/// Work_Num  数量
Property WorkRpSubNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WorkRpSub_Num ];

/// Work_Count  分值
Property WorkRpSubCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WorkRpSub_Count ];

/// WorkRpSub_ExNur_Dr	执行人--DHCNMG.HR.MgPersons ID
Property WorkRpSubExNurDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = WorkRpSub_ExNur_Dr ];

Storage Default
{
<Data name="MgNurWorkRpSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkRpSubItmDR</Value>
</Value>
<Value name="3">
<Value>WorkRpSubNum</Value>
</Value>
<Value name="4">
<Value>WorkRpSubCount</Value>
</Value>
<Value name="5">
<Value>WorkRpSubExNurDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>MgNurWorkRpSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurWorkRpSubI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurWorkRpSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

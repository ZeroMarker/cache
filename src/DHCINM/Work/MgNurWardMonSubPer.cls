/// creator: 
/// Description：月报分数明细表
/// Date:
Class DHCINM.Work.MgNurWardMonSubPer Extends %Persistent
{

Relationship WorkRpParef As DHCINM.Work.MgNurWardMonRp [ Cardinality = parent, Inverse = ChildRpSub, Required ];

Property WorkRpSubItmDR As CF.DHCINM.DB.WorkLoadItm [ SqlColumnNumber = 3, SqlFieldName = WorkRpSub_Itm_DR ];

/// Work_Num	数量
Property WorkRpSubNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WorkRpSub_Num ];

/// Work_Count	分数
Property WorkRpSubCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WorkRpSub_Count ];

/// WorkRpSub_ExNur_Dr	执行人
Property WorkRpSubExNurDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = WorkRpSub_ExNur_Dr ];

Storage Default
{
<Data name="MgNurWardMonSubPerDefaultData">
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
<DataLocation>{%%PARENT}("ChildRpSub")</DataLocation>
<DefaultData>MgNurWardMonSubPerDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildRpSub")</IdLocation>
<IndexLocation>^DHCINM.Work.MgNurWardMo5AAFI</IndexLocation>
<StreamLocation>^DHCINM.Work.MgNurWardMo5AAFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// creator: 
/// Description：工作量病区日数据项目数量及分数
/// Date:
Class DHCINM.Work.MgNurWorkRpWard Extends %Persistent
{

Relationship WardParref As DHCINM.Work.MgNurWorkReport [ Cardinality = parent, Inverse = ChildWard, Required ];

Relationship ChildItmData As DHCINM.Work.MgNurWorkRpSubItmData [ Cardinality = children, Inverse = WorkRpWardParref ];

/// Ward_WorkItm
Property WardWorkItm As CF.DHCINM.DB.WorkLoadItm [ SqlColumnNumber = 2, SqlFieldName = Ward_WorkItm ];

/// Ward_WorkNum	数量
Property WardWorkNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Ward_WorkNum ];

// [ InitialExpression = {$i(^DHCINM.WorkWorkRP($p(%d(0),$c(1),1),"ward",0))}, Required, SqlColumnNumber = 4 ];

/// ChildSub
/// ward_Count	分值
Property WardWorkCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Ward_WorkCount ];

Storage Default
{
<Data name="MgNurWorkRpWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardWorkItm</Value>
</Value>
<Value name="3">
<Value>WardWorkNum</Value>
</Value>
<Value name="4">
<Value>WardWorkCount</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildWard")</DataLocation>
<DefaultData>MgNurWorkRpWardDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildWard")</IdLocation>
<IndexLocation>^DHCINM.Work.MgNurWorkRpWardI</IndexLocation>
<StreamLocation>^DHCINM.Work.MgNurWorkRpWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

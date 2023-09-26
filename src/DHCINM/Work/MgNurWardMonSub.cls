/// creator: 
/// Description：月报项目分数和执行护士明细
/// Date:
Class DHCINM.Work.MgNurWardMonSub Extends %Persistent
{

Relationship WardParref As DHCINM.Work.MgNurWardMonRp [ Cardinality = parent, Inverse = ChildRpWard, Required ];

Relationship ChildItmData As DHCINM.Work.MgNurWardMonSubItm [ Cardinality = children, Inverse = WorkRpWardParref ];

/// Ward_WorkItm
Property WardWorkItm As CF.DHCINM.DB.WorkLoadItm [ SqlColumnNumber = 2, SqlFieldName = Ward_WorkItm ];

/// Ward_WorkNum	数量
Property WardWorkNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Ward_WorkNum ];

// [ InitialExpression = {$i(^DHCINM.WorkWorkRP($p(%d(0),$c(1),1),"ward",0))}, Required, SqlColumnNumber = 4 ];

/// ChildSub
/// ward_Count	分数
Property WardWorkCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Ward_WorkCount ];

Storage Default
{
<Data name="MgNurWardMonSubDefaultData">
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
<DataLocation>{%%PARENT}("ChildRpWard")</DataLocation>
<DefaultData>MgNurWardMonSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildRpWard")</IdLocation>
<IndexLocation>^DHCINM.Work.MgNurWardMonSubI</IndexLocation>
<StreamLocation>^DHCINM.Work.MgNurWardMonSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

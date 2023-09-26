/// 护理计划数据子表
Class User.DHCNurPlanRecCompleteSub Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = RCS_RowId, SqlTableName = DHC_NurPlan_RecCompleteSub ]
{

Relationship RCSParRef As User.DHCNurPlanRecParent [ Cardinality = parent, Inverse = ChildRecCompleteSub, SqlFieldName = RCS_ParRef ];

Property RCSItemCompleteID As %String [ SqlColumnNumber = 2, SqlFieldName = RCS_ItemCompleteID ];

Property RCSCompleteFactor As %String [ SqlColumnNumber = 3, SqlFieldName = RCS_CompleteFactor ];

Property RCSOrder As %String [ SqlColumnNumber = 4, SqlFieldName = RCS_Order ];

Property RCSEmrCode As %String [ SqlColumnNumber = 5, SqlFieldName = RCS_EmrCode ];

Property RCSElementCode As %String [ SqlColumnNumber = 6, SqlFieldName = RCS_ElementCode ];

Property RCSFreq As %String [ SqlColumnNumber = 7, SqlFieldName = RCS_Freq ];

Property RCSDescription As %String [ SqlColumnNumber = 8, SqlFieldName = RCS_Description ];

Property RCSStatus As %String [ SqlColumnNumber = 9, SqlFieldName = RCS_Status ];

Property RCSUpdateUser As %String [ SqlColumnNumber = 10, SqlFieldName = RCS_UpdateUser ];

Property RCSUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = RCS_UpdateDate ];

Property RCSUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = RCS_UpdateTime ];

Index ItemComplete On RCSItemCompleteID;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RCSUpdateUser</Value>
</Value>
<Value name="3">
<Value>RCSUpdateDate</Value>
</Value>
<Value name="4">
<Value>RCSUpdateTime</Value>
</Value>
<Value name="5">
<Value>RCSCompleteFactor</Value>
</Value>
<Value name="6">
<Value>RCSOrder</Value>
</Value>
<Value name="7">
<Value>RCSEmrCode</Value>
</Value>
<Value name="8">
<Value>RCSElementCode</Value>
</Value>
<Value name="9">
<Value>RCSFreq</Value>
</Value>
<Value name="10">
<Value>RCSDescription</Value>
</Value>
<Value name="11">
<Value>RCSStatus</Value>
</Value>
<Value name="12">
<Value>RCSItemCompleteID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RecComplete")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RecComplete")</IdLocation>
<IndexLocation>^DHCNurPlani("RecComplete",0)</IndexLocation>
<SqlChildSub>RCS_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCNurPlanRecCompleteSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 护理计划数据子表
Class User.DHCNurPlanRecTriggerSub Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = RTS_RowId, SqlTableName = DHC_NurPlan_RecTriggerSub ]
{

Relationship RTSParRef As User.DHCNurPlanRecParent [ Cardinality = parent, Inverse = ChildRecTriggerSub, SqlFieldName = RTS_ParRef ];

Property RTSItemTriggerID As %String [ SqlColumnNumber = 2, SqlFieldName = RTS_ItemTriggerID ];

Property RTSTriggerFactor As %String [ SqlColumnNumber = 3, SqlFieldName = RTS_TriggerFactor ];

Property RTSOrder As %String [ SqlColumnNumber = 4, SqlFieldName = RTS_Order ];

Property RTSEvent As %String [ SqlColumnNumber = 5, SqlFieldName = RTS_Event ];

Property RTSDiag As %String [ SqlColumnNumber = 6, SqlFieldName = RTS_Diag ];

Property RTSEmrCode As %String [ SqlColumnNumber = 7, SqlFieldName = RTS_EmrCode ];

Property RTSElementCode As %String [ SqlColumnNumber = 8, SqlFieldName = RTS_ElementCode ];

Property RTSDescription As %String [ SqlColumnNumber = 9, SqlFieldName = RTS_Description ];

Property RTSFreq As %String [ SqlColumnNumber = 10, SqlFieldName = RTS_Freq ];

Property RTSStatus As %String [ SqlColumnNumber = 11, SqlFieldName = RTS_Status ];

Property RTSUpdateUser As %String [ SqlColumnNumber = 12, SqlFieldName = RTS_UpdateUser ];

Property RTSUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = RTS_UpdateDate ];

Property RTSUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = RTS_UpdateTime ];

Index ItemTrigger On RTSItemTriggerID;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RTSUpdateUser</Value>
</Value>
<Value name="3">
<Value>RTSUpdateDate</Value>
</Value>
<Value name="4">
<Value>RTSUpdateTime</Value>
</Value>
<Value name="5">
<Value>RTSTriggerFactor</Value>
</Value>
<Value name="6">
<Value>RTSOrder</Value>
</Value>
<Value name="7">
<Value>RTSEvent</Value>
</Value>
<Value name="8">
<Value>RTSDiag</Value>
</Value>
<Value name="9">
<Value>RTSEmrCode</Value>
</Value>
<Value name="10">
<Value>RTSElementCode</Value>
</Value>
<Value name="11">
<Value>RTSFreq</Value>
</Value>
<Value name="12">
<Value>RTSDescription</Value>
</Value>
<Value name="13">
<Value>RTSItemTriggerID</Value>
</Value>
<Value name="14">
<Value>RTSStatus</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RecTrigger")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RecTrigger")</IdLocation>
<IndexLocation>^DHCNurPlani("RecTrigger",0)</IndexLocation>
<SqlChildSub>RTS_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCNurPlanRecTriggerSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

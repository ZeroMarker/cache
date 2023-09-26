Class CKB.PDSS.RuleLog Extends %Persistent [ SqlRowIdName = RL_RowId, SqlTableName = RuleLog ]
{

/// d ##class(CKB.PDSS.RuleLog).%BuildIndices()
/// 规则组号
Property RLRule As CT.CKB.PDSS.Rule [ SqlColumnNumber = 2, SqlFieldName = RL_Rule ];

/// 操作人
Property RLUser As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = RL_User ];

/// 操作日期
Property RLDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = RL_Date ];

/// 操作时间
Property RLTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 5, SqlFieldName = RL_Time ];

/// 操作类型
/// 新增(Add) /  修改(Edit)  / 发布(Release) / 取消发布(CancelRelease)  / 删除 (Remove)
Property RLType As %String [ SqlColumnNumber = 6, SqlFieldName = RL_Type ];

/// 名称
Property RLName As %String [ SqlColumnNumber = 7, SqlFieldName = RL_Name ];

/// 备注
Property RLRemark As %String [ SqlColumnNumber = 8, SqlFieldName = RL_Remark ];

/// LastLog
Property RLLastLog As %String [ SqlColumnNumber = 9, SqlFieldName = RL_LastLog ];

/// RL_Hospital 医院描述	2020/3/30 
Property RLHospital As %String [ SqlColumnNumber = 10, SqlFieldName = RL_Hospital ];

Index Date On RLDate As Exact;

Index Rule On RLRule As Exact;

Storage Default
{
<Data name="RuleLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RLRule</Value>
</Value>
<Value name="3">
<Value>RLUser</Value>
</Value>
<Value name="4">
<Value>RLDate</Value>
</Value>
<Value name="5">
<Value>RLTime</Value>
</Value>
<Value name="6">
<Value>RLType</Value>
</Value>
<Value name="7">
<Value>RLName</Value>
</Value>
<Value name="8">
<Value>RLRemark</Value>
</Value>
<Value name="9">
<Value>RLLastLog</Value>
</Value>
<Value name="10">
<Value>RLHospital</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.RuleLogD</DataLocation>
<DefaultData>RuleLogDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.RuleLogD</IdLocation>
<IndexLocation>^CKB.PDSS.RuleLogI</IndexLocation>
<StreamLocation>^CKB.PDSS.RuleLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

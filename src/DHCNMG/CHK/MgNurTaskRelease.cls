/// 
Class DHCNMG.CHK.MgNurTaskRelease Extends %Persistent
{

/// 质控类型
Property TaskType As %String [ SqlColumnNumber = 2, SqlFieldName = Task_Type ];

/// 开始日期
Property TaskStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Task_StDate ];

/// 截止日期
Property TaskEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Task_EndDate ];

/// 检查人员
Property TaskChecker As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Task_Checker ];

/// 检查病区
Property TaskWards As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Task_Wards ];

/// 检查项目
Property TaskQuals As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Task_Quals ];

/// 创建人
Property TaskCreator As %String [ SqlColumnNumber = 8, SqlFieldName = Task_Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, SqlColumnNumber = 9, SqlFieldName = Create_Date ];

/// 状态
Property Status As %String [ SqlColumnNumber = 10, SqlFieldName = Status ];

/// 检查组
Property TaskCheckGroup As %String [ SqlColumnNumber = 11, SqlFieldName = Task_CheckGroup ];

/// 检查层级
Property QualLevel As %String [ SqlColumnNumber = 12, SqlFieldName = Qual_Level ];

Index type On (Status, TaskType, TaskStDate);

Storage Default
{
<Data name="MgNurTaskReleaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskType</Value>
</Value>
<Value name="3">
<Value>TaskStDate</Value>
</Value>
<Value name="4">
<Value>TaskEndDate</Value>
</Value>
<Value name="5">
<Value>TaskChecker</Value>
</Value>
<Value name="6">
<Value>TaskWards</Value>
</Value>
<Value name="7">
<Value>TaskQuals</Value>
</Value>
<Value name="8">
<Value>TaskCreator</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>TaskCheckGroup</Value>
</Value>
<Value name="12">
<Value>QualLevel</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurTaskReleaseD</DataLocation>
<DefaultData>MgNurTaskReleaseDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurTaskReleaseD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurTaskReleaseI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurTaskReleaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

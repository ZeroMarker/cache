/// Creator:guozj
/// Descriptions:护士长夜查房检查明细
/// Date:2018-05-14
/// 
Class DHCNMG.CHK.MgNurNightCheckSub Extends %Persistent
{

Relationship Parref As DHCNMG.CHK.MgNurNightCheck [ Cardinality = parent, Inverse = ChildSub ];

/// 明细描述
Property TaskItems As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Task_Items ];

/// 对应的质控项目ID
Property TaskQual As %String [ SqlColumnNumber = 3, SqlFieldName = Task_Qual ];

/// 父节点ID 1
Property TaskPar As %String [ SqlColumnNumber = 4, SqlFieldName = Task_Par ];

/// 检查结果
Property TaskResult As %String [ SqlColumnNumber = 5, SqlFieldName = Task_Result ];

/// 检查任务记录ID【无用】
Property TaskRecID As %String [ SqlColumnNumber = 6, SqlFieldName = Task_RecID ];

/// 备注
Property TaskRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = Task_Remark ];

/// 原分值
Property TaskValue As %String [ SqlColumnNumber = 8, SqlFieldName = Task_Value ];

/// 合并数量
Property TaskRowSpan As %String [ SqlColumnNumber = 9, SqlFieldName = Task_RowSpan ];

/// 排序
Property TaskSort As %String [ SqlColumnNumber = 10, SqlFieldName = Task_Sort ];

Index Rec On TaskRecID;

Index par On TaskPar;

Index qualId On TaskQual;

Index Sort On (Parref, TaskSort);

Index qual On (Parref, TaskQual);

Storage Default
{
<Data name="MgNurNightCheckSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskItems</Value>
</Value>
<Value name="3">
<Value>TaskQual</Value>
</Value>
<Value name="4">
<Value>TaskPar</Value>
</Value>
<Value name="5">
<Value>TaskResult</Value>
</Value>
<Value name="6">
<Value>TaskRecID</Value>
</Value>
<Value name="7">
<Value>TaskRemark</Value>
</Value>
<Value name="8">
<Value>TaskValue</Value>
</Value>
<Value name="9">
<Value>TaskRowSpan</Value>
</Value>
<Value name="10">
<Value>TaskSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurNightCheckSubD</DataLocation>
<DefaultData>MgNurNightCheckSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Parref")</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurNightCheckSubI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurNightCheckSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class DHCINM.Intern.MgInternAdjust Extends %Persistent
{

/// 批次名称
Property AdjustDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Adjust_Desc ];

/// 转正进科日期
Property PerDepDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Adjust_DepDate ];

/// 状态 N :保存 Y：提交
Property AdjustStatus As %String [ SqlColumnNumber = 4, SqlFieldName = Adjust_Status ];

/// 创建人
Property AdjustCrtUser As %String [ SqlColumnNumber = 5, SqlFieldName = Adjust_CrtUser ];

/// 创建日期
Property AdjustCrtDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Adjust_CrtDate ];

/// 批次实习生
Property AdjustIntern As %String [ SqlColumnNumber = 7, SqlFieldName = Adjust_Intern ];

/// 开始日期
Property AdjustStDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Adjust_StDate ];

/// 结束日期
Property AdjustEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Adjust_EndDate ];

/// 延长天数
Property Days As %String [ SqlColumnNumber = 10, SqlFieldName = Adjust_Days ];

/// 说明
Property Remark As %String [ SqlColumnNumber = 11, SqlFieldName = Adjust_Remark ];

/// 类型
Property AdjustType As %String [ SqlColumnNumber = 12, SqlFieldName = Adjust_Type ];

/// 支援病区
Property AdjustWard As %String [ SqlColumnNumber = 13, SqlFieldName = Adjust_Ward ];

/// 转正科室
Property AdjustDep As %String [ SqlColumnNumber = 14, SqlFieldName = Adjust_Dep ];

/// 聘任职称
Property AdjustHireDuty As %String [ SqlColumnNumber = 15, SqlFieldName = Adjust_HireDuty ];

/// 聘任开始日期
Property AdjustHireStDate As %Date [ SqlColumnNumber = 16, SqlFieldName = Adjust_HireStDate ];

/// 离职日期
Property AdjustResignDate As %Date [ SqlColumnNumber = 17, SqlFieldName = Adjust_ResignDate ];

Index member On AdjustIntern;

Index ward On AdjustWard;

Storage Default
{
<Data name="MgInternAdjustDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdjustDesc</Value>
</Value>
<Value name="3">
<Value>PerDepDate</Value>
</Value>
<Value name="4">
<Value>AdjustStatus</Value>
</Value>
<Value name="5">
<Value>AdjustCrtUser</Value>
</Value>
<Value name="6">
<Value>AdjustCrtDate</Value>
</Value>
<Value name="7">
<Value>AdjustIntern</Value>
</Value>
<Value name="8">
<Value>AdjustStDate</Value>
</Value>
<Value name="9">
<Value>AdjustEndDate</Value>
</Value>
<Value name="10">
<Value>Days</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>AdjustType</Value>
</Value>
<Value name="13">
<Value>AdjustWard</Value>
</Value>
<Value name="14">
<Value>AdjustDep</Value>
</Value>
<Value name="15">
<Value>AdjustHireDuty</Value>
</Value>
<Value name="16">
<Value>AdjustHireStDate</Value>
</Value>
<Value name="17">
<Value>AdjustResignDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgInternAdjustD</DataLocation>
<DefaultData>MgInternAdjustDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgInternAdjustD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgInternAdjustI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgInternAdjustS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

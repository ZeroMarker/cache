/// Creator:wangcc
/// Descriptions:兼职岗位
/// Date:
Class DHCINM.HR.MgPartTimePost Extends %Persistent
{

Relationship Parref As DHCINM.HR.MgPartTimeLoc [ Cardinality = parent, Inverse = ChildSub ];

/// 岗位代码
Property PostCode As %String [ SqlColumnNumber = 2, SqlFieldName = PT_PostCode ];

/// 岗位描述
Property PostDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PT_PostDesc ];

/// 薪金（元/人/h）
Property Salary As %String [ SqlColumnNumber = 4, SqlFieldName = PT_Salary ];

/// 总薪金（元）
Property MaxSalary As %String [ SqlColumnNumber = 5, SqlFieldName = PT_MaxSalary ];

/// 人数
Property PersonCount As %String [ SqlColumnNumber = 6, SqlFieldName = PT_PersonCount ];

/// 开始时间
Property StTime As %String [ SqlColumnNumber = 7, SqlFieldName = PT_StTime ];

/// 结束时间
Property EndTime As %String [ SqlColumnNumber = 8, SqlFieldName = PT_EndTime ];

/// 启用日期
Property StartDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PT_StartDate ];

/// 停用日期
Property StopDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PT_StopDate ];

/// 周期
Property Cycle As %String [ SqlColumnNumber = 11, SqlFieldName = PT_Cycle ];

/// 备注
Property Remark As %String(MAXLEN = 10000) [ SqlColumnNumber = 12, SqlFieldName = PT_Remark ];

/// 创建者
Property Creator As %String [ SqlColumnNumber = 13, SqlFieldName = PT_Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 14, SqlFieldName = PT_CreateDate ];

Index Code On PostCode;

Storage Default
{
<Data name="MgPartTimePostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostCode</Value>
</Value>
<Value name="3">
<Value>PostDesc</Value>
</Value>
<Value name="4">
<Value>Salary</Value>
</Value>
<Value name="5">
<Value>MaxSalary</Value>
</Value>
<Value name="6">
<Value>PersonCount</Value>
</Value>
<Value name="7">
<Value>StTime</Value>
</Value>
<Value name="8">
<Value>EndTime</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>StopDate</Value>
</Value>
<Value name="11">
<Value>Cycle</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>Creator</Value>
</Value>
<Value name="14">
<Value>CreateDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgPartTimePostD</DataLocation>
<DefaultData>MgPartTimePostDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.HR.MgPartTimePostI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgPartTimePostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

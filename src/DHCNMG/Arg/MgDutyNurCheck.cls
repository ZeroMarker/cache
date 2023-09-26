Class DHCNMG.Arg.MgDutyNurCheck Extends %Persistent
{

Relationship ChildSub As DHCNMG.Arg.MgDNCheckSub [ Cardinality = children, Inverse = Parref ];

/// 查房开始日期
Property CheckStDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Check_StDate ];

/// 查房开始时间
Property CheckStTime As %Time [ SqlColumnNumber = 3, SqlFieldName = Check_StTime ];

/// 查房结束日期
Property CheckEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Check_EndDate ];

/// 查房结束时间
Property CheckEndTime As %Time [ SqlColumnNumber = 5, SqlFieldName = Check_EndTime ];

/// 检查楼层
Property CheckFloor As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Check_Floor ];

/// 检查病区
Property CheckWard As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Check_Ward ];

/// 检查内容
Property CheckContent As list Of %String [ SqlColumnNumber = 8, SqlFieldName = Check_Content ];

/// 好的方面
Property CheckGoodAspect As %String(MAXLEN = 100000) [ SqlColumnNumber = 9, SqlFieldName = Check_GoodAspect ];

/// 存在的问题
Property CheckProblem As %String(MAXLEN = 100000) [ SqlColumnNumber = 10, SqlFieldName = Check_Problem ];

/// 查房人
Property CheckUser As list Of %String [ SqlColumnNumber = 11, SqlFieldName = Check_User ];

/// 状态
Property CheckStatus As %String [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = Check_Status ];

/// 状态操作者
Property StatusUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 13, SqlFieldName = Status_User ];

/// 状态改变说明
Property StatusRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Status_Remark ];

/// 创建者
Property CheckCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 15, SqlFieldName = Check_CrtUser ];

/// 创建日期
Property CheckCrtDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 16, SqlFieldName = Check_CrtDate ];

/// 创建时间
Property CheckCrtTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 17, SqlFieldName = CheckCrtTime ];

/// 病危人数
Property CheckAtDeathNum As %String [ SqlColumnNumber = 18, SqlFieldName = Check_AtDeathNum ];

/// 病重人数
Property CheckSeriousNum As %String [ SqlColumnNumber = 19, SqlFieldName = Check_SeriousNum ];

Index Date On CheckStDate;

Storage Default
{
<Data name="MgDutyNurCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckStDate</Value>
</Value>
<Value name="3">
<Value>CheckStTime</Value>
</Value>
<Value name="4">
<Value>CheckEndDate</Value>
</Value>
<Value name="5">
<Value>CheckEndTime</Value>
</Value>
<Value name="6">
<Value>CheckFloor</Value>
</Value>
<Value name="7">
<Value>CheckWard</Value>
</Value>
<Value name="8">
<Value>CheckContent</Value>
</Value>
<Value name="9">
<Value>CheckGoodAspect</Value>
</Value>
<Value name="10">
<Value>CheckProblem</Value>
</Value>
<Value name="11">
<Value>CheckUser</Value>
</Value>
<Value name="12">
<Value>CheckStatus</Value>
</Value>
<Value name="13">
<Value>StatusUser</Value>
</Value>
<Value name="14">
<Value>StatusRemark</Value>
</Value>
<Value name="15">
<Value>CheckCrtUser</Value>
</Value>
<Value name="16">
<Value>CheckCrtDate</Value>
</Value>
<Value name="17">
<Value>CheckCrtTime</Value>
</Value>
<Value name="18">
<Value>CheckAtDeathNum</Value>
</Value>
<Value name="19">
<Value>CheckSeriousNum</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgDutyNurCheckD</DataLocation>
<DefaultData>MgDutyNurCheckDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgDutyNurCheckD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgDutyNurCheckI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgDutyNurCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

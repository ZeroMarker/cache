/// creator: xbl
/// createDate: 2018-01-12
/// description: 护士长夜查房
Class DHCNMG.Arg.MgNurHeadCheck Extends %Persistent
{

Relationship ChildSub As DHCNMG.Arg.MgNHCheckSub [ Cardinality = children, Inverse = Parref ];

Relationship ChildRVSub As DHCNMG.Arg.MgNHTrackReviewSub [ Cardinality = children, Inverse = Parref ];

/// 查房日期
Property CheckDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Check_Date ];

/// 查房开始时间
Property CheckStTime As %Time [ SqlColumnNumber = 3, SqlFieldName = Check_StTime ];

/// 查房结束时间
Property CheckEndTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Check_EndTime ];

/// 检查楼层
Property CheckFloor As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Check_Floor ];

/// 检查病区
Property CheckWard As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Check_Ward ];

/// 记录病区
Property CheckRecWardNum As %Integer [ SqlColumnNumber = 7, SqlFieldName = Check_RecWardNum ];

/// 检查内容
Property CheckContent As list Of %String [ SqlColumnNumber = 8, SqlFieldName = Check_Content ];

/// 好的方面
Property CheckGoodAspect As %String(MAXLEN = 100000) [ SqlColumnNumber = 9, SqlFieldName = Check_GoodAspect ];

/// 存在的问题
Property CheckProblem As %String(MAXLEN = 100000) [ SqlColumnNumber = 10, SqlFieldName = Check_Problem ];

/// 建议及意见
Property CheckSuggest As %String(MAXLEN = 10000) [ SqlColumnNumber = 11, SqlFieldName = Check_Suggest ];

/// 查房人
Property CheckUser As list Of %String [ SqlColumnNumber = 12, SqlFieldName = Check_User ];

/// 状态
Property CheckStatus As %String [ InitialExpression = "N", SqlColumnNumber = 13, SqlFieldName = Check_Status ];

/// 状态操作者
Property StatusUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 14, SqlFieldName = Status_User ];

/// 状态改变说明
Property StatusRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = Status_Remark ];

/// 创建者
Property CheckCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 16, SqlFieldName = Check_CrtUser ];

/// 创建日期
Property CheckCrtDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 17, SqlFieldName = Check_CrtDate ];

/// 创建时间
Property CheckCrtTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 18, SqlFieldName = Check_CrtTime ];

/// 复查建议及意见
Property CheckRVSuggest As %String(MAXLEN = 10000) [ SqlColumnNumber = 19, SqlFieldName = Check_RVSuggest ];

/// 复查者
Property CheckRVCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 20, SqlFieldName = Check_RVCrtUser ];

/// 复查日期
Property CheckRVCrtDate As %Date [ SqlColumnNumber = 21, SqlFieldName = Check_RVCrtDate ];

/// 复查时间
Property CheckRVCrtTime As %Time [ SqlColumnNumber = 22, SqlFieldName = Check_RVCrtTime ];

Index Date On CheckDate;

Storage Default
{
<Data name="MgNurHeadCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckDate</Value>
</Value>
<Value name="3">
<Value>CheckStTime</Value>
</Value>
<Value name="4">
<Value>CheckEndTime</Value>
</Value>
<Value name="5">
<Value>CheckFloor</Value>
</Value>
<Value name="6">
<Value>CheckWard</Value>
</Value>
<Value name="7">
<Value>CheckResWardNum</Value>
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
<Value>CheckSuggest</Value>
</Value>
<Value name="12">
<Value>CheckUser</Value>
</Value>
<Value name="13">
<Value>CheckStatus</Value>
</Value>
<Value name="14">
<Value>StatusUser</Value>
</Value>
<Value name="15">
<Value>StatusRemark</Value>
</Value>
<Value name="16">
<Value>CheckCrtUser</Value>
</Value>
<Value name="17">
<Value>CheckCrtDate</Value>
</Value>
<Value name="18">
<Value>CheckCrtTime</Value>
</Value>
<Value name="19">
<Value>CheckRecWardNum</Value>
</Value>
<Value name="20">
<Value>CheckWardNum</Value>
</Value>
<Value name="21">
<Value>CheckRVSuggest</Value>
</Value>
<Value name="22">
<Value>CheckRVCrtUser</Value>
</Value>
<Value name="23">
<Value>CheckRVCrtDate</Value>
</Value>
<Value name="24">
<Value>CheckRVCrtTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNurHeadCheckD</DataLocation>
<DefaultData>MgNurHeadCheckDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgNurHeadCheckD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNurHeadCheckI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNurHeadCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

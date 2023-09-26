/// creator: LCY
/// createdate: 20190826
/// description: 护士长手册/科室护理工作年终总结
Class DHCNMG.Handbook.MgHNHWorkSum Extends %Persistent
{

/// 工作总结制定人
Property HNHSumDesDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = HNH_SumDes_DR ];

/// 工作总结制定病区
Property HNHSumWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = HNH_SumWard_DR ];

/// 工作总结主题
Property HNHSumTitle As %String(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = HNH_SumTitle ];

/// 工作总结
Property HNHWorkSum As %String(MAXLEN = 2000) [ SqlColumnNumber = 5, SqlFieldName = HNH_WorkSum ];

/// 工作总结创建日期
Property HNHCreDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = HNH_CreDate ];

/// 工作总结创建时间
Property HNHCreTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = HNH_CreTime ];

///  状态(未提交N，提交Y，审核S，驳回B)
Property HNHSumStatus As %String [ SqlColumnNumber = 8, SqlFieldName = HNH_SumStatus ];

/// 工作总结提交日期
Property HNHSubDate As %Date [ SqlColumnNumber = 9, SqlFieldName = HNH_SubDate ];

/// 工作总结提交时间
Property HNHSubTime As %Time [ SqlColumnNumber = 10, SqlFieldName = HNH_SubTime ];

/// 审核人员
Property HNHRevDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 11, SqlFieldName = HNH_Rev_DR ];

/// 审核通过意见
Property HNHRevIdea As %String [ SqlColumnNumber = 12, SqlFieldName = HNH_Rev_Idea ];

/// 驳回操作人员
Property HNHOperDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 13, SqlFieldName = HNH_Oper_DR ];

/// 审核通过日期
Property HNHRevDate As %Date [ SqlColumnNumber = 14, SqlFieldName = HNH_RevDate ];

/// 审核通过时间
Property HNHRevTime As %Time [ SqlColumnNumber = 15, SqlFieldName = HNH_RevTime ];

/// 驳回原因
Property HNHRejation As %String(MAXLEN = 100) [ SqlColumnNumber = 16, SqlFieldName = HNH_Rejation ];

/// 驳回日期
Property HNHRejDate As %Date [ SqlColumnNumber = 17, SqlFieldName = HNH_RejDate ];

/// 驳回时间
Property HNHRejTime As %Time [ SqlColumnNumber = 18, SqlFieldName = HNH_RejTime ];

Index SumDes On HNHSumDesDR;

Index SumWard On HNHSumWardDR;

Index SumTitle On HNHSumTitle;

Index SumDate On HNHCreDate;

Storage Default
{
<Data name="MgHNHWorkSumDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HNHSumDesDR</Value>
</Value>
<Value name="3">
<Value>HNHSumWardDR</Value>
</Value>
<Value name="4">
<Value>HNHSumTitle</Value>
</Value>
<Value name="5">
<Value>HNHWorkSum</Value>
</Value>
<Value name="6">
<Value>HNHCreDate</Value>
</Value>
<Value name="7">
<Value>HNHCreTime</Value>
</Value>
<Value name="8">
<Value>HNHSumStatus</Value>
</Value>
<Value name="9">
<Value>HNHSubDate</Value>
</Value>
<Value name="10">
<Value>HNHSubTime</Value>
</Value>
<Value name="11">
<Value>HNHRevDR</Value>
</Value>
<Value name="12">
<Value>HNHRevIdea</Value>
</Value>
<Value name="13">
<Value>HNHOperDR</Value>
</Value>
<Value name="14">
<Value>HNHRevDate</Value>
</Value>
<Value name="15">
<Value>HNHRevTime</Value>
</Value>
<Value name="16">
<Value>HNHRejation</Value>
</Value>
<Value name="17">
<Value>HNHRejDate</Value>
</Value>
<Value name="18">
<Value>HNHRejTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.MgHNHWorkSumD</DataLocation>
<DefaultData>MgHNHWorkSumDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.MgHNHWorkSumD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.MgHNHWorkSumI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.MgHNHWorkSumS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

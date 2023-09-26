/// 护士长手册/备忘录
Class DHCNMG.Handbook.MgHNHMemo Extends %Persistent
{

/// 备忘录记录人
Property HNHMemoDesDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = HNH_MemoDes_DR ];

/// 备忘录记录病区
Property HNHMemoWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = HNH_MemoWard_DR ];

/// 备忘录主题
Property HNHMemoTitle As %String(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = HNH_MemoTitle ];

/// 备忘录内容
Property HNHMemo As %String(MAXLEN = 2000) [ SqlColumnNumber = 5, SqlFieldName = HNH_Memo ];

/// 工作总结创建日期
Property HNHCreDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = HNH_CreDate ];

/// 备忘录记录时间
Property HNHCreTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = HNH_CreTime ];

///  状态(未提交N，提交Y，审核S，驳回B)
Property HNHMemoStatus As %String [ SqlColumnNumber = 8, SqlFieldName = HNH_MemoStatus ];

/// 备忘录提交日期
Property HNHSubDate As %Date [ SqlColumnNumber = 9, SqlFieldName = HNH_SubDate ];

/// 备忘录提交时间
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

Index MemoDes On HNHMemoDesDR;

Index MemoWard On HNHMemoWardDR;

Index MemoTitle On HNHMemoTitle;

Index MemoDate On HNHCreDate;

Storage Default
{
<Data name="MgHNHMemoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HNHMemoDesDR</Value>
</Value>
<Value name="3">
<Value>HNHMemoWardDR</Value>
</Value>
<Value name="4">
<Value>HNHMemoTitle</Value>
</Value>
<Value name="5">
<Value>HNHMemo</Value>
</Value>
<Value name="6">
<Value>HNHCreDate</Value>
</Value>
<Value name="7">
<Value>HNHCreTime</Value>
</Value>
<Value name="8">
<Value>HNHMemoStatus</Value>
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
<DataLocation>^DHCNMG.Handbook.MgHNHMemoD</DataLocation>
<DefaultData>MgHNHMemoDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.MgHNHMemoD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.MgHNHMemoI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.MgHNHMemoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Creator:guozj
/// Descriptions:转科申请
/// Date:2017-08-26
/// 
Class DHCNMG.HR.MgTransApp Extends %Persistent
{

/// 申请号
Property TransAppNo As %String [ SqlColumnNumber = 2, SqlFieldName = Trans_AppNo ];

/// 转出病区
Property TransOutDep As %String [ SqlColumnNumber = 3, SqlFieldName = Trans_OutDep ];

/// 转入病区
Property TransInDep As %String [ SqlColumnNumber = 4, SqlFieldName = Trans_InDep ];

/// 申请人数
Property TransCount As %Integer [ SqlColumnNumber = 5, SqlFieldName = Trans_Count ];

/// 转科人 病区id+护士id
Property TransNurse As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Trans_Nurse ];

/// 状态【N:未提交 Y: 已提交  A：审核 B：驳回】
Property TransStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Trans_Status ];

/// 转科日期
Property TransDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Trans_Date ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Create_Date ];

/// 申请人
Property CreateUser As %String [ SqlColumnNumber = 10, SqlFieldName = Create_User ];

/// 申请说明
Property TransReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Trans_Reason ];

/// 审核人
Property TransChecker As %String [ SqlColumnNumber = 12, SqlFieldName = Trans_Checker ];

/// 驳回原因
Property TransOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Trans_Opinion ];

/// 转科类型
Property TransType As %String [ SqlColumnNumber = 14, SqlFieldName = Trans_Type ];

/// 结束日期
Property TransEndDate As %Date [ SqlColumnNumber = 15, SqlFieldName = Trans_EndDate ];

/// 【L：长期调科 T：临时调科（用人申请）】
Property TranSpecy As %String [ SqlColumnNumber = 16, SqlFieldName = Tran_Specy ];

/// 撤销人
Property CancelUser As %String [ SqlColumnNumber = 17, SqlFieldName = Cancel_User ];

/// 撤销日期
Property CancelDate As %Date [ SqlColumnNumber = 18, SqlFieldName = Cancel_Date ];

/// 审核意见
Property TransRadio As %String [ SqlColumnNumber = 19, SqlFieldName = Trans_Radio ];

Index appno On TransAppNo;

Index date On (TranSpecy, TransEndDate);

// Index outdep On (TranSpecy, TransOutDep);

Storage Default
{
<Data name="MgTransAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransAppNo</Value>
</Value>
<Value name="3">
<Value>TransOutDep</Value>
</Value>
<Value name="4">
<Value>TransCount</Value>
</Value>
<Value name="5">
<Value>TransName</Value>
</Value>
<Value name="6">
<Value>TransStatus</Value>
</Value>
<Value name="7">
<Value>TransDate</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateUser</Value>
</Value>
<Value name="10">
<Value>TransChecker</Value>
</Value>
<Value name="11">
<Value>TransReason</Value>
</Value>
<Value name="12">
<Value>TransOpinion</Value>
</Value>
<Value name="13">
<Value>TransInDep</Value>
</Value>
<Value name="14">
<Value>TransNurse</Value>
</Value>
<Value name="15">
<Value>TransType</Value>
</Value>
<Value name="16">
<Value>TransEndDate</Value>
</Value>
<Value name="17">
<Value>TranSpecy</Value>
</Value>
<Value name="18">
<Value>CancelUser</Value>
</Value>
<Value name="19">
<Value>CancelDate</Value>
</Value>
<Value name="20">
<Value>TransRadio</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgTransAppD</DataLocation>
<DefaultData>MgTransAppDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgTransAppD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgTransAppI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgTransAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

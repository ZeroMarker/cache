/// 病区持续改进
Class DHCNMG.CHK.MgWardImprove Extends %Persistent [ SqlTableName = MgWardImprove ]
{

/// 病区ID（DHCNMG.DB.MgWard表ID）
Property ProbWardDr As DHCNMG.DB.MgWard [ SqlFieldName = Prob_WardDr ];

/// 问题类型
Property ProbType As %String [ SqlFieldName = Prob_Type ];

/// 问题描述
Property ProbDesc As %String [ SqlFieldName = Prob_Desc ];

/// 责任科室ID(DHCNMG.DB.MgWardLoc)
Property ProbWardLocDr As DHCNMG.DB.MgWardLoc [ SqlFieldName = Prob_WardLocDr ];

/// 发现科室ID(DHCNMG.DB.MgWardLoc)
Property ProbFindWardLocDr As DHCNMG.DB.MgWardLoc [ SqlFieldName = Prob_FindWardLocDr ];

/// 发现病区ID(DHCNMG.DB.MgWard)
Property ProbFindWardDr As DHCNMG.DB.MgWard [ SqlFieldName = Prob_FindWardDr ];

/// 责任人
Property ProbDutyPerson As DHCNMG.HR.MgPersons [ SqlFieldName = Prob_DutyPerson ];

/// 发现人
Property ProbFindPerson As %String [ SqlFieldName = Prob_FindPerson ];

/// 创建日期
Property ProbDate As %Date [ SqlFieldName = Prob_Date ];

/// 提交日期
Property ProbSubmitDate As %Date [ SqlFieldName = Prob_SubmitDate ];

/// 审核日期
Property ProbCheckDate As %Date [ SqlFieldName = Prob_CheckDate ];

/// 状态
Property ProbStatus As %String [ SqlFieldName = Prob_Status ];

/// 问题原因
Property ProbReason As %String [ SqlFieldName = Prob_Reason ];

/// 是否重点关注
Property ProbWatch As %String [ SqlFieldName = Prob_Watch ];

Storage Default
{
<Data name="MgWardImproveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProbWardDr</Value>
</Value>
<Value name="3">
<Value>ProbType</Value>
</Value>
<Value name="4">
<Value>ProbDesc</Value>
</Value>
<Value name="5">
<Value>ProbWardLocDr</Value>
</Value>
<Value name="6">
<Value>ProbDutyPerson</Value>
</Value>
<Value name="7">
<Value>ProbFindPerson</Value>
</Value>
<Value name="8">
<Value>ProbDate</Value>
</Value>
<Value name="9">
<Value>ProbSubmitDate</Value>
</Value>
<Value name="10">
<Value>ProbCheckDate</Value>
</Value>
<Value name="11">
<Value>ProbStatus</Value>
</Value>
<Value name="12">
<Value>ProbReason</Value>
</Value>
<Value name="13">
<Value>ProbBhReason</Value>
</Value>
<Value name="14">
<Value>ProbCheckResult</Value>
</Value>
<Value name="15">
<Value>ProbWatch</Value>
</Value>
<Value name="16">
<Value>ProbFindWardLocDr</Value>
</Value>
<Value name="17">
<Value>ProbFindWardDr</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgWardImproveD</DataLocation>
<DefaultData>MgWardImproveDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgWardImproveD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgWardImproveI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgWardImproveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

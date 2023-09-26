/// Creater:wangpf
/// Descriptions:质控问题反馈汇总
/// Date:2020-06-19
Class DHCINM.CHK.MgCheckQues Extends %Persistent
{

/// 检查任务
Property QuesTask As DHCINM.CHK.MgQualCheckTask [ SqlColumnNumber = 2, SqlFieldName = Ques_Task ];

/// 质控类型
Property QuesType As CT.DHCINM.Set.MgSysParamSub [ SqlColumnNumber = 3, SqlFieldName = Ques_Type ];

/// 检查项目
Property QuesQual As CT.DHCINM.DB.MgQualItem [ SqlColumnNumber = 4, SqlFieldName = Ques_Qual ];

/// 检查病区
Property QuesWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = Ques_Ward ];

/// 检查结果
Property QuesResult As DHCINM.CHK.MgCheckResult [ SqlColumnNumber = 6, SqlFieldName = Ques_Result ];

/// 检查日期(问题发生日期)
Property QuesDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Ques_Date ];

/// 问题描述
Property QuesDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Ques_Desc ];

/// 条目标准
Property QuesStandard As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Ques_Standard ];

/// 相关护士
Property QuesRelatedPer As list Of %String [ SqlColumnNumber = 10, SqlFieldName = Ques_RelatedPer ];

/// 检查级别 H:护理部,L:大科,W:病区
Property QuesLevel As %String [ SqlColumnNumber = 11, SqlFieldName = Ques_Level ];

/// 状态 N:待处理S:已处理,A:已解决,Q:问题上诉,B:驳回,I:忽略
Property QuesStatus As %String [ SqlColumnNumber = 12, SqlFieldName = Ques_Status ];

/// 备注
Property QuesRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Ques_Remark ];

/// 处理人
Property QuesProcessPer As %String [ SqlColumnNumber = 14, SqlFieldName = Ques_ProcessPer ];

/// 处理日期
Property QuesProcessDate As %Date [ SqlColumnNumber = 15, SqlFieldName = Ques_ProcessDate ];

/// 原因分析
Property QuesAnalyze As %String(MAXLEN = 1000) [ SqlColumnNumber = 16, SqlFieldName = Ques_Analyze ];

/// 护理人员原因
Property QuesNurRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 17, SqlFieldName = Ques_NurRea ];

/// 病人情况原因
Property QuesPatRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 18, SqlFieldName = Ques_PatRea ];

/// 设备原因
Property QuesDeviceRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 19, SqlFieldName = Ques_DeviceRea ];

/// 工作环境原因
Property QuesWorkRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 20, SqlFieldName = Ques_WorkRea ];

/// 物品原因
Property QuesGoodsRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 21, SqlFieldName = Ques_GoodsRea ];

/// 其他原因
Property QuesOtherRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 22, SqlFieldName = Ques_OtherRea ];

/// 整改措施
Property QuesStep As %String(MAXLEN = 1000) [ SqlColumnNumber = 23, SqlFieldName = Ques_Step ];

/// 预期目标
Property QuesGoal As %String(MAXLEN = 1000) [ SqlColumnNumber = 24, SqlFieldName = Ques_Goal ];

/// 护理部意见(效果评价)
Property QuesHLBView As %String(MAXLEN = 1000) [ SqlColumnNumber = 25, SqlFieldName = Ques_HLBView ];

/// 护理部处理人
Property QuesHLBPer As %String [ SqlColumnNumber = 26, SqlFieldName = Ques_HLBPer ];

/// 护理部处理日期
Property QuesHLBDate As %Date [ SqlColumnNumber = 27, SqlFieldName = Ques_HLBDate ];

Index Result On QuesResult;

Storage Default
{
<Data name="MgCheckQuesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesTask</Value>
</Value>
<Value name="3">
<Value>QuesType</Value>
</Value>
<Value name="4">
<Value>QuesQual</Value>
</Value>
<Value name="5">
<Value>QuesWard</Value>
</Value>
<Value name="6">
<Value>QuesResult</Value>
</Value>
<Value name="7">
<Value>QuesDate</Value>
</Value>
<Value name="8">
<Value>QuesDesc</Value>
</Value>
<Value name="9">
<Value>QuesStandard</Value>
</Value>
<Value name="10">
<Value>QuesRelatedPer</Value>
</Value>
<Value name="11">
<Value>QuesLevel</Value>
</Value>
<Value name="12">
<Value>QuesStatus</Value>
</Value>
<Value name="13">
<Value>QuesRemark</Value>
</Value>
<Value name="14">
<Value>QuesProcessPer</Value>
</Value>
<Value name="15">
<Value>QuesProcessDate</Value>
</Value>
<Value name="16">
<Value>QuesAnalyze</Value>
</Value>
<Value name="17">
<Value>QuesNurRea</Value>
</Value>
<Value name="18">
<Value>QuesPatRea</Value>
</Value>
<Value name="19">
<Value>QuesDeviceRea</Value>
</Value>
<Value name="20">
<Value>QuesWorkRea</Value>
</Value>
<Value name="21">
<Value>QuesGoodsRea</Value>
</Value>
<Value name="22">
<Value>QuesOtherRea</Value>
</Value>
<Value name="23">
<Value>QuesStep</Value>
</Value>
<Value name="24">
<Value>QuesGoal</Value>
</Value>
<Value name="25">
<Value>QuesHLBView</Value>
</Value>
<Value name="26">
<Value>QuesHLBPer</Value>
</Value>
<Value name="27">
<Value>QuesHLBDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgCheckQuesD</DataLocation>
<DefaultData>MgCheckQuesDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgCheckQuesD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgCheckQuesI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgCheckQuesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Creater:lulin
/// Descriptions:质控问题反馈汇总子表
/// Date:2018-06-12
Class DHCNMG.CHK.MgCheckQuesSub Extends %Persistent
{

Relationship Parref As DHCNMG.CHK.MgCheckQues [ Cardinality = parent, Inverse = ChildSub ];

/// 原因分析
Property QuesSubRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = QuesSub_Rea ];

/// 护理人员原因
Property QuesSubNurRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = QuesSub_NurRea ];

/// 病人情况原因
Property QuesSubPatRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = QuesSub_PatRea ];

/// 设备原因
Property QuesSubDeviceRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = QuesSub_DeviceRea ];

/// 工作环境原因
Property QuesSubWorkRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = QuesSub_WorkRea ];

/// 物品原因
Property QuesSubGoodsRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = QuesSub_GoodsRea ];

/// 整改措施
Property QuesSubSteps As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = QuesSub_Steps ];

/// 预期目标
Property QuesSubGoal As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = QuesSub_Goal ];

/// 效果评价
Property QuesSubAssess As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = QuesSub_Assess ];

/// 护理部意见
Property QuesSubView As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = QuesSub_View ];

/// 处理人
Property QuesSubHander As %String [ SqlColumnNumber = 12, SqlFieldName = QuesSub_Hander ];

/// 处理时间日期
Property QuesSubHandDate As %Date [ SqlColumnNumber = 13, SqlFieldName = QuesSub_HandDate ];

/// 护理部审核人
Property QuesSubAuditor As %String [ SqlColumnNumber = 14, SqlFieldName = QuesSub_Auditor ];

/// 病区审核日期
Property QuesSubAudDate As %Date [ SqlColumnNumber = 15, SqlFieldName = QuesSub_AudDate ];

/// 状态 N:待处理S:已处理,A:已解决,Q:问题上诉,B:驳回,I:忽略
Property QuesStatus As %String [ SqlColumnNumber = 16, SqlFieldName = Ques_Status ];

Storage Default
{
<Data name="MgCheckQuesSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesSubRea</Value>
</Value>
<Value name="3">
<Value>QuesSubNurRea</Value>
</Value>
<Value name="4">
<Value>QuesSubPatRea</Value>
</Value>
<Value name="5">
<Value>QuesSubDeviceRea</Value>
</Value>
<Value name="6">
<Value>QuesSubWorkRea</Value>
</Value>
<Value name="7">
<Value>QuesSubGoodsRea</Value>
</Value>
<Value name="8">
<Value>QuesSubSteps</Value>
</Value>
<Value name="9">
<Value>QuesSubGoal</Value>
</Value>
<Value name="10">
<Value>QuesSubAssess</Value>
</Value>
<Value name="11">
<Value>QuesSubView</Value>
</Value>
<Value name="12">
<Value>QuesSubHander</Value>
</Value>
<Value name="13">
<Value>QuesSubHandDate</Value>
</Value>
<Value name="14">
<Value>QuesSubAuditor</Value>
</Value>
<Value name="15">
<Value>QuesSubAudDate</Value>
</Value>
<Value name="16">
<Value>QuesStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgCheckQuesSubD</DataLocation>
<DefaultData>MgCheckQuesSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgCheckQuesSubI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgCheckQuesSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

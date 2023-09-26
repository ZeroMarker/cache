/// Creater:lulin
/// Descriptions:质控问题反馈汇总主表
/// Date:2018-06-12
Class DHCNMG.CHK.MgCheckQues Extends %Persistent
{

Relationship ChildSub As DHCNMG.CHK.MgCheckQuesSub [ Cardinality = children, Inverse = Parref ];

/// 检查项目id
Property QuesCheckDR As %String [ SqlColumnNumber = 2, SqlFieldName = Ques_CheckDR ];

/// 问题描述：检查条目
Property QuesDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Ques_Desc ];

/// 条目标准：检查标准
Property QuesStand As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = Ques_Stand ];

/// 护士签名
Property QuesMember As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Ques_Member ];

/// 检查级别 H:护理部,L:大科,W:病区
Property QuesLevel As %String [ SqlColumnNumber = 6, SqlFieldName = Ques_Level ];

/// 病区
Property QuesWard As DHCNMG.DB.MgWard [ SqlColumnNumber = 7, SqlFieldName = Ques_Ward ];

/// 问题来源,质控类型
Property QuesSource As %String [ SqlColumnNumber = 8, SqlFieldName = Ques_Source ];

/// 状态 N:待处理S:已处理,A:已解决,Q:问题上诉,B:驳回,I:忽略
Property QuesStatus As %String [ SqlColumnNumber = 9, SqlFieldName = Ques_Status ];

/// 备注
Property QuesRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Ques_Remark ];

/// 检查人
Property QuesUser As %String [ SqlColumnNumber = 11, SqlFieldName = Ques_User ];

/// 检查日期
Property QuesCheckDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Ques_CheckDate ];

/// 检查类型 Q:质控检查 N：夜查房
Property QuesCheckType As %String [ SqlColumnNumber = 13, SqlFieldName = Ques_CheckType ];

Index Check On (QuesCheckType, QuesCheckDR);

Index Source On (QuesSource, QuesCheckDR);

Storage Default
{
<Data name="MgCheckQuesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesCheckDR</Value>
</Value>
<Value name="3">
<Value>QuesDesc</Value>
</Value>
<Value name="4">
<Value>QuesStand</Value>
</Value>
<Value name="5">
<Value>QuesMember</Value>
</Value>
<Value name="6">
<Value>QuesLevel</Value>
</Value>
<Value name="7">
<Value>QuesWard</Value>
</Value>
<Value name="8">
<Value>QuesSource</Value>
</Value>
<Value name="9">
<Value>QuesStatus</Value>
</Value>
<Value name="10">
<Value>QuesRemark</Value>
</Value>
<Value name="11">
<Value>QuesUser</Value>
</Value>
<Value name="12">
<Value>QuesCheckDate</Value>
</Value>
<Value name="13">
<Value>QuesCheckType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgCheckQuesD</DataLocation>
<DefaultData>MgCheckQuesDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgCheckQuesD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgCheckQuesI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgCheckQuesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

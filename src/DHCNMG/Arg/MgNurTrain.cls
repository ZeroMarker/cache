/// creator: xbl
/// createdate: 20180108
/// description: 开展新业务新技术
Class DHCNMG.Arg.MgNurTrain Extends %Persistent
{

Relationship ChildSub As DHCNMG.Arg.MgNurTrainSub [ Cardinality = children, Inverse = Parref ];

/// 类型 "N":"开展新技术新业务","B":"业务学习","C":"夜查房培训","T":"教学培训
Property TrainType As %String [ SqlColumnNumber = 2, SqlFieldName = Train_Type ];

/// 病区
Property TrainWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Train_WardDR ];

/// 培训人 DHCNMG.HR.MgPersons
Property TrainTeacher As %String [ SqlColumnNumber = 4, SqlFieldName = Train_Teacher ];

/// 培训主题
Property TrainTitle As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Train_Title ];

/// 培训日期
Property TrainDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Train_Date ];

/// 培训内容
Property TrainContent As %Text(MAXLEN = 100000) [ SqlColumnNumber = 7, SqlFieldName = Train_Content ];

/// 状态
Property TrainStatus As %String [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = Train_Status ];

/// 提交日期
Property TrainSubmitDate As %String [ SqlColumnNumber = 9, SqlFieldName = Train_SubmitDate ];

/// 提交时间
Property TrainSubmitTime As %String [ SqlColumnNumber = 10, SqlFieldName = Train_SubmitTime ];

/// 创建者
Property TrainCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 11, SqlFieldName = Train_CrtUser ];

/// 创建日期
Property TrainCrtDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = Train_CrtDate ];

/// 创建时间
Property TrainCrtTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 13, SqlFieldName = Train_CrtTime ];

/// 科外培训人病区
Property TrainTeaWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 14, SqlFieldName = Train_TeaWardDR ];

/// 培训人类型【1、科外。2、院外。其他：本科】
Property TrainTeaType As %String [ SqlColumnNumber = 15, SqlFieldName = Train_TeaType ];

/// 外院培训人单位
Property TrainTeaWork As %String [ SqlColumnNumber = 16, SqlFieldName = Train_TeaWork ];

/// 外院培训人姓名
Property TrainTeaName As %String [ SqlColumnNumber = 17, SqlFieldName = Train_TeaName ];

/// 外院培训人职称
Property TrainTeaDuty As %String [ SqlColumnNumber = 18, SqlFieldName = Train_TeaDuty ];

/// 附件 (,)逗号间隔
Property TrainRefer As %String(MAXLEN = 100000) [ SqlColumnNumber = 19, SqlFieldName = Train_Refer ];

Index TypeWard On (TrainType, TrainWardDR);

Index TypeDate On (TrainType, TrainDate);

Index TypeTeaType On (TrainType, TrainTeaType);

Storage Default
{
<Data name="MgNurTrainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrainCode</Value>
</Value>
<Value name="3">
<Value>TrainWardDR</Value>
</Value>
<Value name="4">
<Value>TrainTeacher</Value>
</Value>
<Value name="5">
<Value>TrainTitle</Value>
</Value>
<Value name="6">
<Value>TrainDate</Value>
</Value>
<Value name="7">
<Value>TrainContent</Value>
</Value>
<Value name="8">
<Value>TrainStatus</Value>
</Value>
<Value name="9">
<Value>TrainCrtUser</Value>
</Value>
<Value name="10">
<Value>TrainCrtDate</Value>
</Value>
<Value name="11">
<Value>TrainCrtTime</Value>
</Value>
<Value name="12">
<Value>TrainSubmitDate</Value>
</Value>
<Value name="13">
<Value>TrainSubmitTime</Value>
</Value>
<Value name="14">
<Value>TrainType</Value>
</Value>
<Value name="15">
<Value>TrainTeaWardDR</Value>
</Value>
<Value name="16">
<Value>TrainTeaType</Value>
</Value>
<Value name="17">
<Value>TrainTeaWork</Value>
</Value>
<Value name="18">
<Value>TrainTeaName</Value>
</Value>
<Value name="19">
<Value>TrainTeaDuty</Value>
</Value>
<Value name="20">
<Value>TrainRefer</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNurTrainD</DataLocation>
<DefaultData>MgNurTrainDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgNurTrainD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNurTrainI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNurTrainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

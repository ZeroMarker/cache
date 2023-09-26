Class DHCINM.HR.MgOutTrain Extends %Persistent
{

/// 护士ID
Property NurseID As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Nurse_ID ];

/// 所在病区
Property TrainDep As %String [ SqlColumnNumber = 3, SqlFieldName = Train_Dep ];

/// 开始日期
Property TrainStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Train_StDate ];

/// 结束日期
Property TrainEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Train_EndDate ];

/// 进修专科  
Property TrainSubject As %String [ SqlColumnNumber = 6, SqlFieldName = Train_Subject ];

/// 进修医院
Property TrainHospital As %String [ SqlColumnNumber = 7, SqlFieldName = Train_Hospital ];

/// 进修科室
Property TrainLoc As %String [ SqlColumnNumber = 8, SqlFieldName = Train_Loc ];

/// 进修计划
Property TrainTarget As %String(MAXLEN = 5000) [ SqlColumnNumber = 9, SqlFieldName = Train_Target ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = Create_Date ];

/// 职称
Property TrainHireDuty As %String [ SqlColumnNumber = 11, SqlFieldName = Train_HireDuty ];

/// 职务
Property TrainPostDuty As %String [ SqlColumnNumber = 12, SqlFieldName = Train_PostDuty ];

/// 学历
Property TrainAcade As %String [ SqlColumnNumber = 13, SqlFieldName = Train_Acade ];

/// 年份
Property TrainYear As %String [ SqlColumnNumber = 14, SqlFieldName = Train_Year ];

Index Date On (TrainYear, TrainDep, NurseID);

Index Per On NurseID;

Storage Default
{
<Data name="MgOutTrainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurseID</Value>
</Value>
<Value name="3">
<Value>TrainDep</Value>
</Value>
<Value name="4">
<Value>TrainStDate</Value>
</Value>
<Value name="5">
<Value>TrainEndDate</Value>
</Value>
<Value name="6">
<Value>TrainSubject</Value>
</Value>
<Value name="7">
<Value>TrainHospital</Value>
</Value>
<Value name="8">
<Value>TrainLoc</Value>
</Value>
<Value name="9">
<Value>TrainTarget</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>TrainHireDuty</Value>
</Value>
<Value name="12">
<Value>TrainPostDuty</Value>
</Value>
<Value name="13">
<Value>TrainAcade</Value>
</Value>
<Value name="14">
<Value>TrainYear</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgOutTrainD</DataLocation>
<DefaultData>MgOutTrainDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgOutTrainD</IdLocation>
<IndexLocation>^DHCINM.HR.MgOutTrainI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgOutTrainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

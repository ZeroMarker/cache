/// Creator:gzj
/// Description:外派进修人员
/// 
Class DHCNMG.HR.MgNurTraining Extends %Persistent
{

Relationship ChildSub As DHCNMG.HR.MgNurTrainingSub [ Cardinality = children, Inverse = Parref ];

/// 护士ID
Property NurseID As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Nurse_ID ];

/// 年份
Property TrainYear As %Integer [ SqlColumnNumber = 3, SqlFieldName = Train_Year ];

/// 毕业院校
Property TrainSchool As %String [ SqlColumnNumber = 4, SqlFieldName = Train_School ];

/// 学历
Property TrainAcade As %String [ SqlColumnNumber = 5, SqlFieldName = Train_Acade ];

/// 所在病区
Property TrainDep As %String [ SqlColumnNumber = 6, SqlFieldName = Train_Dep ];

/// 开始日期
Property TrainStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Train_StDate ];

/// 结束日期
Property TrainEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Train_EndDate ];

/// 进修专科  
Property TrainSubject As %String [ SqlColumnNumber = 9, SqlFieldName = Train_Subject ];

/// 进修医院
Property TrainHospital As %String [ SqlColumnNumber = 10, SqlFieldName = Train_Hospital ];

/// 进修科室
Property TrainLoc As %String [ SqlColumnNumber = 11, SqlFieldName = Train_Loc ];

/// 进修目标及工作设想
Property TrainTarget As %String(MAXLEN = 5000) [ SqlColumnNumber = 12, SqlFieldName = Train_Target ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = Create_Date ];

/// 创建人
Property CreateUser As %String [ SqlColumnNumber = 14, SqlFieldName = Create_User ];

/// 专科护士
Property TrainSpecial As %String [ SqlColumnNumber = 15, SqlFieldName = Train_Special ];

/// 学位
Property TrainDegree As %String [ SqlColumnNumber = 16, SqlFieldName = Train_Degree ];

/// 职称
Property TrainHireDuty As %String [ SqlColumnNumber = 17, SqlFieldName = Train_HireDuty ];

/// 职务
Property TrainPostDuty As %String [ SqlColumnNumber = 18, SqlFieldName = Train_PostDuty ];

Index Date On (TrainYear, TrainDep, NurseID);

Storage Default
{
<Data name="MgNurTrainingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurseID</Value>
</Value>
<Value name="3">
<Value>TrainYear</Value>
</Value>
<Value name="4">
<Value>TrainSchool</Value>
</Value>
<Value name="5">
<Value>TrainAcade</Value>
</Value>
<Value name="6">
<Value>TrainDep</Value>
</Value>
<Value name="7">
<Value>TrainStDate</Value>
</Value>
<Value name="8">
<Value>TrainEndDate</Value>
</Value>
<Value name="9">
<Value>TrainSubject</Value>
</Value>
<Value name="10">
<Value>TrainHospital</Value>
</Value>
<Value name="11">
<Value>TrainLoc</Value>
</Value>
<Value name="12">
<Value>TrainTarget</Value>
</Value>
<Value name="13">
<Value>CreateDate</Value>
</Value>
<Value name="14">
<Value>CreateUser</Value>
</Value>
<Value name="15">
<Value>TrainSpecial</Value>
</Value>
<Value name="16">
<Value>TrainDegree</Value>
</Value>
<Value name="17">
<Value>TrainHireDuty</Value>
</Value>
<Value name="18">
<Value>TrainPostDuty</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurTrainingD</DataLocation>
<DefaultData>MgNurTrainingDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgNurTrainingD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurTrainingI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurTrainingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

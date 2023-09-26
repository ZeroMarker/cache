/// 医嘱完成时间
Class dbo.BTTATFinishTime Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATFinishTime, StorageStrategy = Default ]
{

Index IndexMaster On (TestSetDR, HospitalDR, AdmissionTypeDR, ReportTimeType, OrderNo) [ SqlName = Index_Master, Type = index ];

Index IndexTestSet On (TestSetDR, AdmissionTypeDR, WorkGroupMachineDR) [ SqlName = Index_TestSet, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTATFINISHTIME On RowID [ PrimaryKey, SqlName = PK_BT_TATFINISHTIME, Type = index, Unique ];

/// Foreign Key FKTATFinishSettingHospital created via DDL
ForeignKey FKTATFinishSettingHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TATFinishSettingHospital ];

/// Foreign Key FKTATFinishTimeTestSet created via DDL
ForeignKey FKTATFinishTimeTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TATFinishTimeTestSet ];

/// Foreign Key FKTATFinishTimeWGMachine created via DDL
ForeignKey FKTATFinishTimeWGMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_TATFinishTimeWGMachine ];

/// Foreign Key FKVisitNumberAdmType created via DDL
ForeignKey FKTATFinishTimeAdmType(AdmissionTypeDR) References dbo.BTAdmissionType(PKBTADMISSIONTYPE) [ SqlName = FK_TATFinishTimeAdmType ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱代码  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 就诊类型  
Property AdmissionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 间隔类型  
Property ReportTimeType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 完成时间  
Property FinishTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

///       
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

///       
Property AcceptTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

///       
Property ReportTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

///       
Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

///       
Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTTATFinishTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>AdmissionTypeDR</Value>
</Value>
<Value name="5">
<Value>ReportTimeType</Value>
</Value>
<Value name="6">
<Value>OrderNo</Value>
</Value>
<Value name="7">
<Value>FinishTime</Value>
</Value>
<Value name="8">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="9">
<Value>ReceiveTime</Value>
</Value>
<Value name="10">
<Value>AcceptTime</Value>
</Value>
<Value name="11">
<Value>ReportTime</Value>
</Value>
<Value name="12">
<Value>StartTime</Value>
</Value>
<Value name="13">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATFinishTimeD</DataLocation>
<DefaultData>BTTATFinishTimeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTATFinishTimeD</IdLocation>
<IndexLocation>^dbo.BTTATFinishTimeI</IndexLocation>
<StreamLocation>^dbo.BTTATFinishTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

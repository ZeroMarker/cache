Class dbo.CFBTTestSetTAT Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CFBT_TestSetTAT, StorageStrategy = Default ]
{

Index IndexMaster On (TestSetDR, HospitalDR, AdmTypeID, TimeType) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAdmType On (TestSetDR, AdmTypeID, TimeType) [ SqlName = Index_AdmType, Type = index ];

Index IndexTimeType On (TestSetDR, TimeType, AdmTypeID) [ SqlName = Index_TimeType, Type = index ];

/// DDL Primary Key Specification
Index PKCFBTTESTSETTAT On RowID [ PrimaryKey, SqlName = PK_CFBT_TESTSETTAT, Type = index, Unique ];

/// Foreign Key FKTATFinishSettingHospital created via DDL
ForeignKey FKTestSetTATHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TestSetTATHospital ];

/// Foreign Key FKTATFinishTimeTestSet created via DDL
ForeignKey FKTestSetTATTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetTATTestSet ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱 
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 就诊类型 0代表所有，非0为BT_AdmissionType表RowID 
Property AdmTypeID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 时间类型 {1采集-接收,2接收-核收,3接收-审核}枚举
Property TimeType As %Library.TinyInt [ Required, SqlColumnNumber = 6 ];

/// 时间  
Property TimeValue As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 单位 {M分钟,H：小时,D：天}枚举  
Property TimeUnit As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="CFBTTestSetTATDefaultData">
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
<Value>AdmTypeID</Value>
</Value>
<Value name="5">
<Value>TimeType</Value>
</Value>
<Value name="6">
<Value>TimeValue</Value>
</Value>
<Value name="7">
<Value>TimeUnit</Value>
</Value>
</Data>
<DataLocation>^dbo.CFBTTestSetTATD</DataLocation>
<DefaultData>CFBTTestSetTATDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.CFBTTestSetTATD</IdLocation>
<IndexLocation>^dbo.CFBTTestSetTATI</IndexLocation>
<StreamLocation>^dbo.CFBTTestSetTATS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

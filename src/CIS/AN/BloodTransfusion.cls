/// 输血申请记录
Class CIS.AN.BloodTransfusion Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BloodTransfusion ]
{

/// 手术
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// ABO血型
Property ABO As %String [ SqlColumnNumber = 3 ];

/// RH血型
Property RH As %String [ SqlColumnNumber = 4 ];

/// 输血史
Property TransHistory As %String [ SqlColumnNumber = 5 ];

/// 临床诊断
Property Diagnosis As %String [ SqlColumnNumber = 6 ];

/// 输血目的
Property Purpose As %String [ SqlColumnNumber = 7 ];

/// 预计输血日期
Property PlanTransDT As %TimeStamp [ SqlColumnNumber = 8 ];

/// 输血性质
Property Nature As %String [ SqlColumnNumber = 9 ];

/// HGB
Property HGB As %String [ SqlColumnNumber = 10 ];

/// HCT
Property HCT As %String [ SqlColumnNumber = 11 ];

/// PLT
Property PLT As %String [ SqlColumnNumber = 12 ];

/// ALT
Property ALT As %String [ SqlColumnNumber = 13 ];

/// HBsAg
Property HBsAg As %String [ SqlColumnNumber = 14 ];

/// HBsAb
Property HBsAb As %String [ SqlColumnNumber = 15 ];

/// HBeAg
Property HBeAg As %String [ SqlColumnNumber = 16 ];

/// HBeAb
Property HBeAb As %String [ SqlColumnNumber = 17 ];

/// HCVAb
Property HCVAb As %String [ SqlColumnNumber = 18 ];

/// HIVAb
Property HIVAb As %String [ SqlColumnNumber = 19 ];

/// 梅毒
Property Syphilis As %String [ SqlColumnNumber = 20 ];

/// 申请医师
Property AppDoctor As %String [ SqlColumnNumber = 21 ];

/// 上级医师
Property SuperiorDoctor As %String [ SqlColumnNumber = 22 ];

/// 科主任
Property HeadOfDept As %String [ SqlColumnNumber = 23 ];

/// 医务科签字人员
Property MedicalAdmin As %String [ SqlColumnNumber = 24 ];

/// 输血科签字人员
Property TransProv As %String [ SqlColumnNumber = 25 ];

/// 标本采集人员
Property SpecimenCollector As %String [ SqlColumnNumber = 26 ];

/// 血袋编码
Property BarCode As %String [ SqlColumnNumber = 27 ];

/// 输血申请ID
Property ExternalID As %String [ SqlColumnNumber = 28 ];

/// 输血申请条码号
Property AppBarCode As %String [ SqlColumnNumber = 29 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 外部系统ID索引
Index IExt On ExternalID;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="BloodTransfusionDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>ABO</Value>
</Value>
<Value name="3">
<Value>RH</Value>
</Value>
<Value name="4">
<Value>TransHistory</Value>
</Value>
<Value name="5">
<Value>Diagnosis</Value>
</Value>
<Value name="6">
<Value>Purpose</Value>
</Value>
<Value name="7">
<Value>PlanTransDT</Value>
</Value>
<Value name="8">
<Value>Nature</Value>
</Value>
<Value name="9">
<Value>HGB</Value>
</Value>
<Value name="10">
<Value>HCT</Value>
</Value>
<Value name="11">
<Value>PLT</Value>
</Value>
<Value name="12">
<Value>ALT</Value>
</Value>
<Value name="13">
<Value>HBsAg</Value>
</Value>
<Value name="14">
<Value>HBsAb</Value>
</Value>
<Value name="15">
<Value>HBeAg</Value>
</Value>
<Value name="16">
<Value>HBeAb</Value>
</Value>
<Value name="17">
<Value>HCVAb</Value>
</Value>
<Value name="18">
<Value>HIVAb</Value>
</Value>
<Value name="19">
<Value>Syphilis</Value>
</Value>
<Value name="20">
<Value>AppDoctor</Value>
</Value>
<Value name="21">
<Value>SuperiorDoctor</Value>
</Value>
<Value name="22">
<Value>HeadOfDept</Value>
</Value>
<Value name="23">
<Value>MedicalAdmin</Value>
</Value>
<Value name="24">
<Value>TransProv</Value>
</Value>
<Value name="25">
<Value>SpecimenCollector</Value>
</Value>
<Value name="26">
<Value>BarCode</Value>
</Value>
<Value name="27">
<Value>ExternalID</Value>
</Value>
<Value name="28">
<Value>AppBarCode</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.BloodTransfusionD</DataLocation>
<DefaultData>BloodTransfusionDefaultData</DefaultData>
<IdLocation>^CIS.AN.BloodTransfusionD</IdLocation>
<IndexLocation>^CIS.AN.BloodTransfusionI</IndexLocation>
<StreamLocation>^CIS.AN.BloodTransfusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class DHCMed.NINF.Srv.InfStatBaseInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID
Property Paadm As %String(TRUNCATE = 1);

/// 出院日期
Property DischDate As %Date;

/// 出院科室
Property DischLoc As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmDate As %Date;

/// 就诊科室
Property AdmLoc As %String(TRUNCATE = 1);

/// 院感次数
Property ReportTimes As %String(TRUNCATE = 1);

/// 手术相关感染次数
Property OperRelaInfTimes As %String(TRUNCATE = 1);

/// 手术部位感染次数
Property OperPosiInfTimes As %String(TRUNCATE = 1);

/// 是否新生儿
Property IsNewBorn As %String(DISPLAYLIST = ",YES,NO", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 是否手术肺部感染
Property OperBellInfTimes As %String(TRUNCATE = 1);

/// 择期手术感染次数
Property SeleOperInfTimes As %String(TRUNCATE = 1);

/// 择期手术肺部感染次数
Property SeleOperBellInfTimes As %String(TRUNCATE = 1);

/// 择期手术次数
Property SeleOperTimes As %String(TRUNCATE = 1);

/// 急诊手术次数
Property EmerOperTimes As %String(TRUNCATE = 1);

/// 手术次数
Property OperTimes As %String(TRUNCATE = 1);

/// 0级手术感染次数
Property Rank0OperInfTimes As %String(TRUNCATE = 1);

/// 0级手术次数
Property Rank0OperTimes As %String(TRUNCATE = 1);

/// 1级手术感染次数
Property Rank1OperInfTimes As %String(TRUNCATE = 1);

/// 1级手术次数
Property Rank1OperTimes As %String(TRUNCATE = 1);

/// 2级手术感染次数
Property Rank2OperInfTimes As %String(TRUNCATE = 1);

/// 2级手术次数
Property Rank2OperTimes As %String(TRUNCATE = 1);

/// 3级手术感染次数
Property Rank3OperInfTimes As %String(TRUNCATE = 1);

/// 3级手术次数
Property Rank3OperTimes As %String(TRUNCATE = 1);

/// 中心静脉相关血源性感染次数
Property VenousBloodInfTimes As %String(TRUNCATE = 1);

/// 中心静脉置管使用日数
Property VenousBloodDays As %String(TRUNCATE = 1);

/// 呼吸机相关肺部感染次数
Property RespPlumInfTimes As %String(TRUNCATE = 1);

/// 呼吸机使用日数
Property RespPlumDays As %String(TRUNCATE = 1);

/// 留置导尿管相关泌尿道感染次数
Property CathUrinaryTractInfTimes As %String(TRUNCATE = 1);

/// 留置导尿管病人日数
Property CathOfDays As %String(TRUNCATE = 1);

/// 与血液透析相关血液感染次数
Property BloodInfTimes As %String(TRUNCATE = 1);

/// 同期进行血液透析次数
Property HemodialysisTimes As %String(TRUNCATE = 1);

Index IndexOfPaadm On Paadm;

Index IndexOfDischDate On DischDate;

//Relationship ChildOfOper As DHCMed.NINF.Srv.InfStatOperInfo [ Cardinality = children, Inverse = ParOfBaseInfo ];

//Relationship ChildOfICU As DHCMed.NINF.Srv.InfStatICUInfo [ Cardinality = children, Inverse = ParOfBaseInfo ];

Storage Default
{
<Data name="InfStatBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Paadm</Value>
</Value>
<Value name="3">
<Value>DischDate</Value>
</Value>
<Value name="4">
<Value>DischLoc</Value>
</Value>
<Value name="5">
<Value>AdmDate</Value>
</Value>
<Value name="6">
<Value>AdmLoc</Value>
</Value>
<Value name="7">
<Value>ReportTimes</Value>
</Value>
<Value name="8">
<Value>OperRelaInfTimes</Value>
</Value>
<Value name="9">
<Value>OperPosiInfTimes</Value>
</Value>
<Value name="10">
<Value>IsNewBorn</Value>
</Value>
<Value name="11">
<Value>OperBellInfTimes</Value>
</Value>
<Value name="12">
<Value>SeleOperInfTimes</Value>
</Value>
<Value name="13">
<Value>SeleOperBellInfTimes</Value>
</Value>
<Value name="14">
<Value>SeleOperTimes</Value>
</Value>
<Value name="15">
<Value>EmerOperTimes</Value>
</Value>
<Value name="16">
<Value>OperTimes</Value>
</Value>
<Value name="17">
<Value>Rank0OperInfTimes</Value>
</Value>
<Value name="18">
<Value>Rank0OperTimes</Value>
</Value>
<Value name="19">
<Value>Rank1OperInfTimes</Value>
</Value>
<Value name="20">
<Value>Rank1OperTimes</Value>
</Value>
<Value name="21">
<Value>Rank2OperInfTimes</Value>
</Value>
<Value name="22">
<Value>Rank2OperTimes</Value>
</Value>
<Value name="23">
<Value>Rank3OperInfTimes</Value>
</Value>
<Value name="24">
<Value>Rank3OperTimes</Value>
</Value>
<Value name="25">
<Value>VenousBloodInfTimes</Value>
</Value>
<Value name="26">
<Value>VenousBloodDays</Value>
</Value>
<Value name="27">
<Value>RespPlumInfTimes</Value>
</Value>
<Value name="28">
<Value>RespPlumDays</Value>
</Value>
<Value name="29">
<Value>CathUrinaryTractInfTimes</Value>
</Value>
<Value name="30">
<Value>CathOfDays</Value>
</Value>
<Value name="31">
<Value>BloodInfTimes</Value>
</Value>
<Value name="32">
<Value>HemodialysisTimes</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Srv.InfStatBaseD</DataLocation>
<DefaultData>InfStatBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Srv.InfStatBaseD</IdLocation>
<IndexLocation>^DHCMed.NINF.Srv.InfStatBaseI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Srv.InfStatBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

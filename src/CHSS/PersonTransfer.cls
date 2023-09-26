Class CHSS.PersonTransfer Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = TransferRowId, SqlTableName = PersonTransfer ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 转诊状态(审核)
/// Property TransferStatusDR As CHSS.DictTransferStatus;   //2010-07-03
Property TransferStatusDR As %String(DISPLAYLIST = ",1,2,3", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",1,2,3");

/// 转诊类别
/// Property TransferTypeDR As CHSS.DictTransferType;   //2010-07-03
Property TransferTypeDR As %String(DISPLAYLIST = ",1,2,3", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",1,2,3");

/// 转诊单位
Property SendUnit As %String(MAXLEN = 60, TRUNCATE = 1);

/// 姓名
Property PatientName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 性别
Property SexDR As User.CTSex;

/// 出生日期
Property Birth As %Date;

/// 病历号
Property CaseBookNumber As %String(MAXLEN = 20, TRUNCATE = 1);

/// 联系电话
Property TelNumber As %String(MAXLEN = 50, TRUNCATE = 1);

/// 家庭住址
Property HomePlace As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊科室
Property SendDepartment As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊科室主任
Property SendLeader As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊医师
Property SendDoctor As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊时间
Property SendDate As %Date;

/// 转诊医师联系电话
Property SendDoctNumber As %String(MAXLEN = 50, TRUNCATE = 1);

/// 接诊单位
Property AcceptUnit As %String(MAXLEN = 50, TRUNCATE = 1);

/// 接诊科室
Property AcceptDepartment As %String(MAXLEN = 50, TRUNCATE = 1);

/// 接诊科室主任
Property AcceptLeader As %String(MAXLEN = 50, TRUNCATE = 1);

/// 接诊医师
Property AcceptDoctor As %String(MAXLEN = 50, TRUNCATE = 1);

/// 接诊开始时间
Property StartAcceptDate As %Date;

/// 接诊结束时间
Property EndAcceptDate As %Date;

/// 接诊医师联系电话
Property AcceptDoctNumber As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊联系电话(白天1)
Property AcceptNumberDay1 As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊联系电话(白天2)
Property AcceptNumberDay2 As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊联系电话(晚上)
Property AcceptNumberNight As %String(MAXLEN = 50, TRUNCATE = 1);

/// 审核人
Property AuditMan As %String(MAXLEN = 50, TRUNCATE = 1);

/// 审核时间
Property AuditDate As %Date;

/// 主诉
Property ChiefComplaint As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现病史
Property DoctorSay As %String(MAXLEN = 100, TRUNCATE = 1);

/// 既往病史
Property DiseaseHistory As %String(MAXLEN = 100, TRUNCATE = 1);

/// 个人史
Property PersonHistory As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史
Property FamilyHistory As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗意见
Property Suggestion As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断
Property DiagnoseResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转诊原因
Property TransferReason As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转诊目的
Property TransferTarget As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病情摘要
Property CaseAbstract As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转诊注意事项
Property Attentions As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转诊单位编码
Property SendUnitCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 接诊单位编码
Property AcceptUnitCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 作废标志
Property bDeleteFlag As %String(MAXLEN = 5, TRUNCATE = 1);

/// 原转诊记录
Property OldRecordRowId As %Integer;

/// 费别
Property FeeTypeDR As CHSS.DictMedicalInsuranceType;

/// 转回日期
Property BackDate As %Date;

/// 病情转归
Property BackCaseInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转诊实体类型(2010.07.04)
Property InstanceType As %String(DISPLAYLIST = ",checkup,Transfer", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",1,2");

/// 转诊目标类型(2010.07.04)
Property TargetsType As %String(DISPLAYLIST = ",OutPatient,InPatient", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",OP,IP");

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PersonTransferDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcceptDepartment</Value>
</Value>
<Value name="3">
<Value>AcceptDoctNumber</Value>
</Value>
<Value name="4">
<Value>AcceptDoctor</Value>
</Value>
<Value name="5">
<Value>AcceptLeader</Value>
</Value>
<Value name="6">
<Value>AcceptNumberDay1</Value>
</Value>
<Value name="7">
<Value>AcceptNumberDay2</Value>
</Value>
<Value name="8">
<Value>AcceptNumberNight</Value>
</Value>
<Value name="9">
<Value>AcceptUnit</Value>
</Value>
<Value name="10">
<Value>AcceptUnitCode</Value>
</Value>
<Value name="11">
<Value>Attentions</Value>
</Value>
<Value name="12">
<Value>AuditDate</Value>
</Value>
<Value name="13">
<Value>AuditMan</Value>
</Value>
<Value name="14">
<Value>Birth</Value>
</Value>
<Value name="15">
<Value>CaseAbstract</Value>
</Value>
<Value name="16">
<Value>CaseBookNumber</Value>
</Value>
<Value name="17">
<Value>ChiefComplaint</Value>
</Value>
<Value name="18">
<Value>DiagnoseResult</Value>
</Value>
<Value name="19">
<Value>DiseaseHistory</Value>
</Value>
<Value name="20">
<Value>DoctorSay</Value>
</Value>
<Value name="21">
<Value>EndAcceptDate</Value>
</Value>
<Value name="22">
<Value>FamilyHistory</Value>
</Value>
<Value name="23">
<Value>HomePlace</Value>
</Value>
<Value name="24">
<Value>OldRecordRowId</Value>
</Value>
<Value name="25">
<Value>PatientName</Value>
</Value>
<Value name="26">
<Value>PersonHistory</Value>
</Value>
<Value name="27">
<Value>PersonRowId</Value>
</Value>
<Value name="28">
<Value>Remark</Value>
</Value>
<Value name="29">
<Value>SendDate</Value>
</Value>
<Value name="30">
<Value>SendDepartment</Value>
</Value>
<Value name="31">
<Value>SendDoctNumber</Value>
</Value>
<Value name="32">
<Value>SendDoctor</Value>
</Value>
<Value name="33">
<Value>SendLeader</Value>
</Value>
<Value name="34">
<Value>SendUnit</Value>
</Value>
<Value name="35">
<Value>SendUnitCode</Value>
</Value>
<Value name="36">
<Value>SexDR</Value>
</Value>
<Value name="37">
<Value>StartAcceptDate</Value>
</Value>
<Value name="38">
<Value>Suggestion</Value>
</Value>
<Value name="39">
<Value>TelNumber</Value>
</Value>
<Value name="40">
<Value>TransferReason</Value>
</Value>
<Value name="41">
<Value>TransferStatusDR</Value>
</Value>
<Value name="42">
<Value>TransferTarget</Value>
</Value>
<Value name="43">
<Value>TransferTypeDR</Value>
</Value>
<Value name="44">
<Value>bDeleteFlag</Value>
</Value>
<Value name="45">
<Value>BackCaseInfo</Value>
</Value>
<Value name="46">
<Value>BackDate</Value>
</Value>
<Value name="47">
<Value>FeeTypeDR</Value>
</Value>
<Value name="48">
<Value>InstanceType</Value>
</Value>
<Value name="49">
<Value>TargetsType</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonTransferD</DataLocation>
<DefaultData>PersonTransferDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonTransferD</IdLocation>
<IndexLocation>^CHSS.PersonTransferI</IndexLocation>
<StreamLocation>^CHSS.PersonTransferS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

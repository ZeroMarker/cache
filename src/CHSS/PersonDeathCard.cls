Class CHSS.PersonDeathCard Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = CardRowId, SqlTableName = PersonDeathCard ]
{

/// 个人档案主键
Property PersonRowId As %String(MAXLEN = 30, TRUNCATE = 1);

/// 报告单位编码
Property CommunityCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 报告单位名称
Property CommunityName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 卡片编号
Property CardCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 性别编码
Property Sex As User.CTSex;

/// 若为女性，属于哪种情况
/// Property  WomenType	BIGINT;	
/// 身份证号
Property ID As %String(MAXLEN = 18, TRUNCATE = 1);

/// 出生日期
Property Birthday As %Date(FORMAT = 1);

/// 民族
Property Nation As User.CTNation;

/// 婚姻状况
Property Marriage As User.CTMarital;

/// 主要职业及工种
Property WorkType As User.CTOccupation;

/// 文化程度
Property DeuLevel As User.CTEducation;

/// 详细现住地址
Property Addr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住地址名称
Property AddrName As %String(MAXLEN = 40, TRUNCATE = 1);

/// 现住地址类型
Property PlaceType As CHSS.DictAreaType;

/// 户籍地址
Property RegisterAddr As %String(MAXLEN = 50, TRUNCATE = 1);

/// 户籍地址编码
Property RegisterAddrCode As %String(MAXLEN = 10, TRUNCATE = 1);

/// 户籍地址名称
Property RegisterAddrName As %String(MAXLEN = 40, TRUNCATE = 1);

/// 户籍类型
Property AreaType As CHSS.DictAreaType;

/// 死者生前工作单位
Property WorkPlace As %String(MAXLEN = 40, TRUNCATE = 1);

/// 死亡日期
Property DeadDate As %Date(FORMAT = 1);

/// 死亡地点
Property DeadZone As CHSS.DictDeathPlace;

/// 死亡地点编码
Property DeadZoneCode As %String(MAXLEN = 20, TRUNCATE = 1);

/// 死者家属姓名
Property FolkName As %String(MAXLEN = 20, TRUNCATE = 1);

/// 家属联系电话
Property FolkTel As %String(MAXLEN = 15, TRUNCATE = 1);

/// 家属联系地址
Property FolkAddr As %String(MAXLEN = 40, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (a)
Property ACause As %String(MAXLEN = 100, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (a)ICD编码
Property AICD10 As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (a) 发病至死亡时间间隔数
Property AScopeTime As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (a) 发病至死亡时间间隔单位
Property AScopeTimeUnit As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (b)
Property BCause As %String(MAXLEN = 100, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (b)ICD编码
Property BICD10 As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (b) 发病至死亡时间间隔数
Property BScopeTime As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (b) 发病至死亡时间间隔单位
Property BScopeTimeUnit As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (c)
Property CCause As %String(MAXLEN = 100, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (c)ICD编码
Property CICD10 As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (c) 发病至死亡时间间隔数
Property CScopeTime As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (c) 发病至死亡时间间隔单位
Property CScopeTimeUnit As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (d)
Property DCause As %String(MAXLEN = 100, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (d)ICD编码
Property DICD10 As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (d) 发病至死亡时间间隔数
Property DScopeTime As %String(MAXLEN = 10, TRUNCATE = 1);

/// 直接导致死亡的疾病或情况 (d) 发病至死亡时间间隔单位
Property DScopeTimeUnit As %String(MAXLEN = 10, TRUNCATE = 1);

/// 其它疾病诊断
Property OtherCause As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其它疾病诊断ICD
Property OtherICD10 As %String(MAXLEN = 10, TRUNCATE = 1);

/// 根本死因原因
Property BaseCause As %String(MAXLEN = 100, TRUNCATE = 1);

/// 根本死亡原因ICD10编码
Property BSICD10 As %String(MAXLEN = 10, TRUNCATE = 1);

/// 最高诊断单位
Property DorgLevel As %String(MAXLEN = 20, TRUNCATE = 1);

/// 最高诊断依据
Property DiagnoseBy As CHSS.DiagnosisWitness;

/// 住院号
Property HospitalNo As %String(MAXLEN = 30, TRUNCATE = 1);

/// 填卡医生
Property Doctor As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医生填卡日期
Property FillDate As %Date(FORMAT = 1);

/// 备注
Property Note As %String(MAXLEN = 40, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId;

Index DeadDateIndex On DeadDate;

Storage Default
{
<Data name="PersonDeathCardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ACause</Value>
</Value>
<Value name="3">
<Value>AICD10</Value>
</Value>
<Value name="4">
<Value>AScopeTime</Value>
</Value>
<Value name="5">
<Value>AScopeTimeUnit</Value>
</Value>
<Value name="6">
<Value>Addr</Value>
</Value>
<Value name="7">
<Value>AddrName</Value>
</Value>
<Value name="8">
<Value>AreaType</Value>
</Value>
<Value name="9">
<Value>BCause</Value>
</Value>
<Value name="10">
<Value>BICD10</Value>
</Value>
<Value name="11">
<Value>BSICD10</Value>
</Value>
<Value name="12">
<Value>BScopeTime</Value>
</Value>
<Value name="13">
<Value>BScopeTimeUnit</Value>
</Value>
<Value name="14">
<Value>BaseCause</Value>
</Value>
<Value name="15">
<Value>Birthday</Value>
</Value>
<Value name="16">
<Value>CCause</Value>
</Value>
<Value name="17">
<Value>CICD10</Value>
</Value>
<Value name="18">
<Value>CScopeTime</Value>
</Value>
<Value name="19">
<Value>CScopeTimeUnit</Value>
</Value>
<Value name="20">
<Value>CardCode</Value>
</Value>
<Value name="21">
<Value>CommunityCode</Value>
</Value>
<Value name="22">
<Value>CommunityName</Value>
</Value>
<Value name="23">
<Value>DCause</Value>
</Value>
<Value name="24">
<Value>DICD10</Value>
</Value>
<Value name="25">
<Value>DScopeTime</Value>
</Value>
<Value name="26">
<Value>DScopeTimeUnit</Value>
</Value>
<Value name="27">
<Value>DeadDate</Value>
</Value>
<Value name="28">
<Value>DeadZone</Value>
</Value>
<Value name="29">
<Value>DeadZoneCode</Value>
</Value>
<Value name="30">
<Value>DeuLevel</Value>
</Value>
<Value name="31">
<Value>DiagnoseBy</Value>
</Value>
<Value name="32">
<Value>Doctor</Value>
</Value>
<Value name="33">
<Value>DorgLevel</Value>
</Value>
<Value name="34">
<Value>FillDate</Value>
</Value>
<Value name="35">
<Value>FolkAddr</Value>
</Value>
<Value name="36">
<Value>FolkName</Value>
</Value>
<Value name="37">
<Value>FolkTel</Value>
</Value>
<Value name="38">
<Value>HospitalNo</Value>
</Value>
<Value name="39">
<Value>ID</Value>
</Value>
<Value name="40">
<Value>Marriage</Value>
</Value>
<Value name="41">
<Value>Nation</Value>
</Value>
<Value name="42">
<Value>Note</Value>
</Value>
<Value name="43">
<Value>OtherCause</Value>
</Value>
<Value name="44">
<Value>OtherICD10</Value>
</Value>
<Value name="45">
<Value>PatientName</Value>
</Value>
<Value name="46">
<Value>PersonRowId</Value>
</Value>
<Value name="47">
<Value>PlaceType</Value>
</Value>
<Value name="48">
<Value>RegisterAddr</Value>
</Value>
<Value name="49">
<Value>RegisterAddrCode</Value>
</Value>
<Value name="50">
<Value>RegisterAddrName</Value>
</Value>
<Value name="51">
<Value>Sex</Value>
</Value>
<Value name="52">
<Value>WorkPlace</Value>
</Value>
<Value name="53">
<Value>WorkType</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonDeathCardD</DataLocation>
<DefaultData>PersonDeathCardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonDeathCardD</IdLocation>
<IndexLocation>^CHSS.PersonDeathCardI</IndexLocation>
<StreamLocation>^CHSS.PersonDeathCardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

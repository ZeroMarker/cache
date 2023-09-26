Class CHSSWeb.HISInterface.PersonInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonRowId As %Integer;

Property PersonCode As %String(TRUNCATE = 1);

Property PersonName As %String(TRUNCATE = 1);

Property SexName As %String(TRUNCATE = 1);

Property Birth As %Date;

Property FamilyAddress As %String(TRUNCATE = 1);

/// 拼音码
Property SpellCode As %String(TRUNCATE = 1);

/// 信息卡号
Property CardNumber As %String(TRUNCATE = 1);

/// 身份证号
Property IDCard As %String(TRUNCATE = 1);

/// 建档日期
Property DateRegister As %Date;

/// 录入日期
Property DateInput As %Date;

/// 籍贯
Property BirthPlace;

/// 参加工作时间
Property DateOfWork;

/// 工作单位
Property WorkPlace;

/// 退休时间
Property DateOFRetire As %Date;

/// 独生子女标志
Property IsSingleChild As %Integer;

/// 死亡标识
Property IsDead As %String(TRUNCATE = 1);

/// 死亡时间
Property DateOfDead As %Date;

/// 信息来源
Property InformationSource As %String(TRUNCATE = 1);

/// 机构编码
Property CommunityCode As %String(TRUNCATE = 1);

/// 联系人
Property LinkManName As %String(TRUNCATE = 1);

/// 联系人电话
Property LinkManPhone As %String(TRUNCATE = 1);

/// 与户主关系
Property RelationHourseHoldDRName As %String(TRUNCATE = 1);

/// 责任医生
Property DoctorRegister As %String(TRUNCATE = 1);

/// 责任护士
Property NurseRegister As %String(TRUNCATE = 1);

/// 国籍
Property NationalityDRName As %String(TRUNCATE = 1);

/// 户口类别
Property HouseHoldTypeDRName As %String(TRUNCATE = 1);

/// 户籍类别（居住状况）
Property DocimialTypeDRName As %String(TRUNCATE = 1);

/// 医疗费用类别
Property MedicalInsuranceTypeDRName As %String(TRUNCATE = 1);

/// 定点医疗单位
Property PointHospitalRowIdDRName As %String(TRUNCATE = 1);

/// 所属居委会
Property CommitteeDRName As %String(TRUNCATE = 1);

/// 所属派出所
Property PoliceRowIdDRName As %String(TRUNCATE = 1);

/// 所属街道
Property StreetRowIdDRName As %String(TRUNCATE = 1);

/// 民族
Property NationDRName As %String(TRUNCATE = 1);

/// 血型
Property BloodTypeDRName As %String(TRUNCATE = 1);

/// 婚姻状况
Property MarriageDRName As %String(TRUNCATE = 1);

/// 文化程度
Property EducationDRName As %String(TRUNCATE = 1);

/// 职业
Property ProfessionDRName As %String(TRUNCATE = 1);

/// 证件类别
Property IDCardTypeDRName As %String(TRUNCATE = 1);

/// 证件生效日期
Property DateOfIDStart As %Date;

/// 证件失效日期
Property DateOfIDEnd As %Date;

/// 提供证件的机构名称
Property IDCardProvider As %String(TRUNCATE = 1);

/// 医疗保险号
Property MedicalInsuranceID As %String(TRUNCATE = 1);

/// 医院就诊号
Property HosDiagnoseId As %String(TRUNCATE = 1);

/// 地址类别
Property AddressTypeDRName As %String(TRUNCATE = 1);

/// 地址
Property Address As %String(TRUNCATE = 1);

/// EMAIL
Property PersonEmail As %String(TRUNCATE = 1);

/// add by wangbo 20100422
/// 过敏物质
Property Allergen As %String(TRUNCATE = 1);

/// 暴露史
Property ExposureHis As %String(TRUNCATE = 1);

/// 疾病史
Property DiseaseHis As %String(TRUNCATE = 1);

/// 手术46
Property OPSHis As %String(TRUNCATE = 1);

/// 外伤48
Property TraumaHis As %String(TRUNCATE = 1);

/// 输血50
Property TransfusionHis As %String(TRUNCATE = 1);

/// 家族史52
Property FamilyHis As %String(TRUNCATE = 1);

/// 遗传病史
Property GeneticDiseaseHis As %String(TRUNCATE = 1);

/// 有无残疾
Property Deformity As %String(TRUNCATE = 1);

/// 残疾证号
Property DeformityCard As %String(TRUNCATE = 1);

/// 建档机构
Property CommunityName As %String(TRUNCATE = 1);

/// 操作人员
Property OperatorInputName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PersonInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Birth</Value>
</Value>
<Value name="3">
<Value>FamilyAddress</Value>
</Value>
<Value name="4">
<Value>LinkManPhone</Value>
</Value>
<Value name="5">
<Value>PersonCode</Value>
</Value>
<Value name="6">
<Value>PersonName</Value>
</Value>
<Value name="7">
<Value>PersonRowId</Value>
</Value>
<Value name="8">
<Value>RelationHourseHoldName</Value>
</Value>
<Value name="9">
<Value>SexName</Value>
</Value>
<Value name="10">
<Value>Address</Value>
</Value>
<Value name="11">
<Value>AddressTypeDRName</Value>
</Value>
<Value name="12">
<Value>BirthPlace</Value>
</Value>
<Value name="13">
<Value>BloodTypeDRName</Value>
</Value>
<Value name="14">
<Value>CardNumber</Value>
</Value>
<Value name="15">
<Value>CommitteeDRName</Value>
</Value>
<Value name="16">
<Value>CommunityCode</Value>
</Value>
<Value name="17">
<Value>DateInput</Value>
</Value>
<Value name="18">
<Value>DateOFRetire</Value>
</Value>
<Value name="19">
<Value>DateOfDead</Value>
</Value>
<Value name="20">
<Value>DateOfIDEnd</Value>
</Value>
<Value name="21">
<Value>DateOfIDStart</Value>
</Value>
<Value name="22">
<Value>DateOfWork</Value>
</Value>
<Value name="23">
<Value>DateRegister</Value>
</Value>
<Value name="24">
<Value>DocimialTypeDRName</Value>
</Value>
<Value name="25">
<Value>DoctorRegister</Value>
</Value>
<Value name="26">
<Value>EducationDRName</Value>
</Value>
<Value name="27">
<Value>HosDiagnoseId</Value>
</Value>
<Value name="28">
<Value>HouseHoldTypeDRName</Value>
</Value>
<Value name="29">
<Value>IDCard</Value>
</Value>
<Value name="30">
<Value>IDCardProvider</Value>
</Value>
<Value name="31">
<Value>IDCardTypeDRName</Value>
</Value>
<Value name="32">
<Value>InformationSource</Value>
</Value>
<Value name="33">
<Value>IsDead</Value>
</Value>
<Value name="34">
<Value>IsSingleChild</Value>
</Value>
<Value name="35">
<Value>MarriageDRName</Value>
</Value>
<Value name="36">
<Value>MedicalInsuranceID</Value>
</Value>
<Value name="37">
<Value>MedicalInsuranceTypeDRName</Value>
</Value>
<Value name="38">
<Value>NationDRName</Value>
</Value>
<Value name="39">
<Value>NationalityDRName</Value>
</Value>
<Value name="40">
<Value>NurseRegister</Value>
</Value>
<Value name="41">
<Value>PersonEmail</Value>
</Value>
<Value name="42">
<Value>PointHospitalRowIdDRName</Value>
</Value>
<Value name="43">
<Value>PoliceRowIdDRName</Value>
</Value>
<Value name="44">
<Value>ProfessionDRName</Value>
</Value>
<Value name="45">
<Value>RelationHourseHoldDRName</Value>
</Value>
<Value name="46">
<Value>SpellCode</Value>
</Value>
<Value name="47">
<Value>StreetRowIdDRName</Value>
</Value>
<Value name="48">
<Value>WorkPlace</Value>
</Value>
<Value name="49">
<Value>LinkMan</Value>
</Value>
<Value name="50">
<Value>LinkManName</Value>
</Value>
<Value name="51">
<Value>Allergen</Value>
</Value>
<Value name="52">
<Value>CommunityName</Value>
</Value>
<Value name="53">
<Value>Deformity</Value>
</Value>
<Value name="54">
<Value>DeformityCard</Value>
</Value>
<Value name="55">
<Value>DiseaseHis</Value>
</Value>
<Value name="56">
<Value>ExposureHis</Value>
</Value>
<Value name="57">
<Value>FamilyHis</Value>
</Value>
<Value name="58">
<Value>OPSHis</Value>
</Value>
<Value name="59">
<Value>TransfusionHis</Value>
</Value>
<Value name="60">
<Value>TraumaHis</Value>
</Value>
<Value name="61">
<Value>GeneticDiseaseHis</Value>
</Value>
<Value name="62">
<Value>OperatorInputName</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HISInter6F2.PersonInfoD</DataLocation>
<DefaultData>PersonInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HISInter6F2.PersonInfoD</IdLocation>
<IndexLocation>^CHSSWeb.HISInter6F2.PersonInfoI</IndexLocation>
<StreamLocation>^CHSSWeb.HISInter6F2.PersonInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

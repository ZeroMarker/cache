Class CHSS.PersonHealthRecordMain Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PersonRowId, SqlTableName = PersonHealthRecordMain ]
{

/// Projection PersonProjection As %Projection.Java;
Relationship ChildPersonLongTermProblem As PersonLongTermProblem [ Cardinality = children, Inverse = PersonRowIdParref ];

/// 个人编码
Property PersonCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PersonCode ];

/// 姓名
Property PersonName As %String(MAXLEN = 60, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PersonName ];

/// 拼音码
Property SpellCode As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SpellCode ];

/// 信息卡号
Property CardNumber As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CardNumber ];

/// 身份证号
Property IDCard As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = IDCard ];

/// 建档日期
Property DateRegister As %Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DateRegister ];

/// 录入日期
Property DateInput As %Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DateInput ];

/// 出生日期
Property Birth As %Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = Birth ];

/// 籍贯
Property BirthPlace As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = BirthPlace ];

/// 参加工作时间
Property DateOfWork As %Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DateOfWork ];

/// 工作单位
Property WorkPlace As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = WorkPlace ];

/// 退休时间
Property DateOFRetire As %Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DateOFRetire ];

/// 特殊群体类别
Property SpecialPopType As %Integer [ SqlColumnNumber = 14, SqlFieldName = SpecialPopType ];

/// 独生子女标志
Property IsSingleChild As %Integer [ SqlColumnNumber = 15, SqlFieldName = IsSingleChild ];

/// 活产胎次
Property BirthParity As %Integer [ SqlColumnNumber = 16, SqlFieldName = BirthParity ];

/// 诊疗号
Property DiagnoseId As %Integer [ SqlColumnNumber = 17, SqlFieldName = DiagnoseId ];

/// 其他档案标识符
Property OtherRecordId As %Integer [ SqlColumnNumber = 18, SqlFieldName = OtherRecordId ];

/// 死亡标识
Property IsDead As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = IsDead ];

/// 死亡时间
Property DateOfDead As %Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DateOfDead ];

/// 信息来源
Property InformationSource As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = InformationSource ];

/// 机构编码
Property CommunityCode As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = CommunityCode ];

/// 联系人姓名
Property LinkManName As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = LinkManName ];

/// 联系人电话
Property LinkManPhone As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = LinkManPhone ];

/// 残疾证号
Property DeformityCode As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = DeformityCode ];

/// 与户主关系
Property RelationHourseHoldDR As CHSS.DictKin [ SqlColumnNumber = 26, SqlFieldName = RelationHourseHoldDR ];

/// 责任医生
Property DoctorRegister As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = DoctorRegister ];

/// 责任护士
Property NurseRegister As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = NurseRegister ];

/// 建档人员
Property OperatorInput As User.SSUser [ SqlColumnNumber = 29, SqlFieldName = OperatorInput ];

/// 国籍
Property NationalityDR As User.CTCountry [ SqlColumnNumber = 30, SqlFieldName = NationalityDR ];

/// 家庭档案主键
Property FamilyRowId As CHSS.FamilyHealthRecord [ SqlColumnNumber = 31, SqlFieldName = FamilyRowId ];

/// 户口类别
Property HouseHoldTypeDR As CHSS.DictHouseHoldType [ SqlColumnNumber = 32, SqlFieldName = HouseHoldTypeDR ];

/// 户籍类别（居住状况）
Property DocimialTypeDR As CHSS.DictDocimialType [ SqlColumnNumber = 33, SqlFieldName = DocimialTypeDR ];

/// 医疗费用类别
Property MedicalInsuranceTypeDR As CHSS.DictMedicalInsuranceType [ SqlColumnNumber = 34, SqlFieldName = MedicalInsuranceTypeDR ];

/// 定点医疗单位
Property PointHospitalRowIdDR As CHSS.DictPointHospital [ SqlColumnNumber = 35, SqlFieldName = PointHospitalRowIdDR ];

/// 所属居委会
Property CommitteeDR As CHSS.DictCommittee [ SqlColumnNumber = 36, SqlFieldName = CommitteeDR ];

/// 所属派出所
Property PoliceRowIdDR As CHSS.DictPolice [ SqlColumnNumber = 37, SqlFieldName = PoliceRowIdDR ];

/// 所属街道
Property StreetRowIdDR As CHSS.DictStreet [ SqlColumnNumber = 38, SqlFieldName = StreetRowIdDR ];

/// 是否有残疾人证
Property HaveDeformityCertificate As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = HaveDeformityCertificate ];

/// 残疾类别
Property DeformityType As CHSS.DictDeformityType [ SqlColumnNumber = 40, SqlFieldName = DeformityType ];

/// 更新人员
Property StaffOfUpdate As User.SSUser [ SqlColumnNumber = 41, SqlFieldName = StaffOfUpdate ];

/// 更新日期
Property DateOfUpdate As %Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = DateOfUpdate ];

/// 档案状态
Property PersonStatus As CHSS.DictArchivesStatus [ SqlColumnNumber = 43, SqlFieldName = PersonStatus ];

/// 照片
Property Photo As %Integer [ SqlColumnNumber = 44, SqlFieldName = Photo ];

/// 性别
Property SexDR As User.CTSex [ SqlColumnNumber = 45, SqlFieldName = SexDR ];

/// 民族
Property NationDR As User.CTNation [ SqlColumnNumber = 46, SqlFieldName = NationDR ];

/// 血型
Property BloodTypeDR As User.PACBloodType [ SqlColumnNumber = 47, SqlFieldName = BloodTypeDR ];

/// 婚姻状况
Property MarriageDR As User.CTMarital [ SqlColumnNumber = 48, SqlFieldName = MarriageDR ];

/// 文化程度
Property EducationDR As User.CTEducation [ SqlColumnNumber = 49, SqlFieldName = EducationDR ];

/// 职业
Property ProfessionDR As User.CTOccupation [ SqlColumnNumber = 50, SqlFieldName = ProfessionDR ];

/// 证件类别
Property IDCardTypeDR As User.PACCardType [ SqlColumnNumber = 51, SqlFieldName = IDCardTypeDR ];

/// 证件生效日期
Property DateOfIDStart As %Date(FORMAT = 1) [ SqlColumnNumber = 52, SqlFieldName = DateOfIDStart ];

/// 证件失效日期
Property DateOfIDEnd As %Date(FORMAT = 1) [ SqlColumnNumber = 53, SqlFieldName = DateOfIDEnd ];

/// 提供证件的机构名称
Property IDCardProvider As %String(MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = IDCardProvider ];

/// 医疗保险号
Property MedicalInsuranceID As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = MedicalInsuranceID ];

/// 医院就诊号
Property HosDiagnoseId As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = HosDiagnoseId ];

/// 地址类别
Property AddressTypeDR As CHSS.DictAddressType;

/// 地址
Property Address As %String(MAXLEN = 100, TRUNCATE = 1);

/// EMAIL
Property PersonEmail As %String(MAXLEN = 60, TRUNCATE = 1);

/// 档案建立类别
Property RegisterType As %Integer;

Index PersonNameIndex On (CommunityCode, PersonName);

Index PersonCodeIndex On PersonCode [ Unique ];

Index IDCardIndex On IDCard [ Unique ];

Index CommunityCodeIndex On CommunityCode;

Index FamilyRowIdIndex On (CommunityCode, FamilyRowId);

Index DateRegisterIndex On (CommunityCode, DateRegister);

Index RelationHourseHoldDRIndex On (CommunityCode, FamilyRowId, RelationHourseHoldDR);

Index CardNumberIndex On CardNumber [ Unique ];

/// add by wangbo 2010-06-12
Index SexDRIndex On SexDR;

Index PersonStatusIndex On PersonStatus;

Index PersonStatusSexDRIndex On (PersonStatus, SexDR);

Index CommCodeStatusSexDRIndex On (CommunityCode, PersonStatus, SexDR);

Index CommCodeStatusNameIndex On (CommunityCode, PersonStatus, PersonName);

//插入之后 往ReportCommunityFPCount 里插入数据

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
    Set PersonRowId = {PersonRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateOfRegister = {DateRegister}  
    d ##class(CHSSWeb.ReportOfTrigger).RecordInsert("PersonHealthRecordMain",PersonRowId,CommunityCode,DateOfRegister)
	Set PersonStatus={PersonStatus}
    d ##class(CHSSWeb.CommStaTriggerService).PersonDeathRecordInsert(PersonRowId,CommunityCode,PersonStatus)
}

//修改之前 往ReportCommunityFPCount 里更新数据

Trigger BeforeUpdate [ Event = UPDATE ]
{
  
    Set PersonRowId = {PersonRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateOfRegister = {DateRegister} 
    d ##class(CHSSWeb.ReportOfTrigger).RecordUpdate("PersonHealthRecordMain",PersonRowId,CommunityCode,DateOfRegister)
	Set PersonStatus={PersonStatus}
    d ##class(CHSSWeb.CommStaTriggerService).PersonDeathRecordUpdate(PersonRowId,CommunityCode,PersonStatus)
}

//删除之前 ReportCommunityFPCount 里删除数据

Trigger BeforeDelete [ Event = DELETE ]
{
  
    Set PersonRowId = {PersonRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateOfRegister = {DateRegister} 
    d ##class(CHSSWeb.ReportOfTrigger).RecordDelete("PersonHealthRecordMain",PersonRowId,CommunityCode,DateOfRegister)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert'=1 d
    .Set PersonRowId = %this.%Id()  
    .Set CommunityCode = %this.CommunityCode
    .Set DateOfRegister = %this.DateRegister
    .d ##class(CHSSWeb.ReportOfTrigger).RecordUpdate("PersonHealthRecordMain",PersonRowId,CommunityCode,DateOfRegister)
	.Set PersonStatus= %this.PersonStatus
    d ##class(CHSSWeb.CommStaTriggerService).PersonDeathRecordUpdate(PersonRowId,CommunityCode,PersonStatus)
	Quit $$$OK
Error
 	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert=1 d 
	.Set PersonRowId = %this.%Id()   
    .Set CommunityCode = %this.CommunityCode
    .Set DateOfRegister = %this.DateRegister
    .d ##class(CHSSWeb.ReportOfTrigger).RecordInsert("PersonHealthRecordMain",PersonRowId,CommunityCode,DateOfRegister)
	.Set PersonStatus= %this.PersonStatus
    d ##class(CHSSWeb.CommStaTriggerService).PersonDeathRecordInsert(PersonRowId,CommunityCode,PersonStatus)
	Quit $$$OK
Error
 	Quit $$$OK
}

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status
{
	S $zt="Error"
 
	S tmpFamily= ##class(CHSS.PersonHealthRecordMain).%Open(oid) 
	Set PersonRowId = tmpFamily.%Id()  
    Set CommunityCode = tmpFamily.CommunityCode  
    Set DateOfRegister = tmpFamily.DateRegister 
    d ##class(CHSSWeb.ReportOfTrigger).RecordDelete("PersonHealthRecordMain",PersonRowId,CommunityCode,DateOfRegister)

	Quit $$$OK
Error
 	;Quit $$$OK
}

Storage Default
{
<Data name="PersonHealthRecordMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonCode</Value>
</Value>
<Value name="3">
<Value>PersonName</Value>
</Value>
<Value name="4">
<Value>SpellCode</Value>
</Value>
<Value name="5">
<Value>CardNumber</Value>
</Value>
<Value name="6">
<Value>DateRegister</Value>
</Value>
<Value name="7">
<Value>IDCard</Value>
</Value>
<Value name="8">
<Value>Birth</Value>
</Value>
<Value name="9">
<Value>DateInput</Value>
</Value>
<Value name="10">
<Value>BirthPlace</Value>
</Value>
<Value name="11">
<Value>BirthParity</Value>
</Value>
<Value name="12">
<Value>DateOFRetire</Value>
</Value>
<Value name="13">
<Value>DateOfDead</Value>
</Value>
<Value name="14">
<Value>DateOfWork</Value>
</Value>
<Value name="15">
<Value>DiagnoseId</Value>
</Value>
<Value name="16">
<Value>InformationSource</Value>
</Value>
<Value name="17">
<Value>IsDead</Value>
</Value>
<Value name="18">
<Value>IsSingleChild</Value>
</Value>
<Value name="19">
<Value>OtherRecordId</Value>
</Value>
<Value name="20">
<Value>SpecialPopType</Value>
</Value>
<Value name="21">
<Value>WorkPlace</Value>
</Value>
<Value name="22">
<Value>CommunityCode</Value>
</Value>
<Value name="23">
<Value>DeformityCode</Value>
</Value>
<Value name="24">
<Value>LinkManName</Value>
</Value>
<Value name="25">
<Value>LinkManPhone</Value>
</Value>
<Value name="26">
<Value>RelationHourseHoldDR</Value>
</Value>
<Value name="27">
<Value>DoctorRegister</Value>
</Value>
<Value name="28">
<Value>NurseRegister</Value>
</Value>
<Value name="29">
<Value>OperatorInput</Value>
</Value>
<Value name="30">
<Value>DocimialTypeDR</Value>
</Value>
<Value name="31">
<Value>HouseHoldTypeDR</Value>
</Value>
<Value name="32">
<Value>CommitteeDR</Value>
</Value>
<Value name="33">
<Value>PointHospitalRowIdDR</Value>
</Value>
<Value name="34">
<Value>PoliceRowIdDR</Value>
</Value>
<Value name="35">
<Value>StreetRowIdDR</Value>
</Value>
<Value name="36">
<Value>HaveDeformityCertificate</Value>
</Value>
<Value name="37">
<Value>DeformityType</Value>
</Value>
<Value name="38">
<Value>PersonStatus</Value>
</Value>
<Value name="39">
<Value>StaffOfUpdate</Value>
</Value>
<Value name="40">
<Value>DateOfUpdate</Value>
</Value>
<Value name="41">
<Value>NewProperty1</Value>
</Value>
<Value name="42">
<Value>Photo</Value>
</Value>
<Value name="43">
<Value>NationalityDR</Value>
</Value>
<Value name="44">
<Value>SexDR</Value>
</Value>
<Value name="45">
<Value>NationDR</Value>
</Value>
<Value name="46">
<Value>BloodTypeDR</Value>
</Value>
<Value name="47">
<Value>EducationDR</Value>
</Value>
<Value name="48">
<Value>MarriageDR</Value>
</Value>
<Value name="49">
<Value>ProfessionDR</Value>
</Value>
<Value name="50">
<Value>MedicalInsuranceTypeDR</Value>
</Value>
<Value name="51">
<Value>FamilyRowId</Value>
</Value>
<Value name="52">
<Value>DateOfIDEnd</Value>
</Value>
<Value name="53">
<Value>DateOfIDStart</Value>
</Value>
<Value name="54">
<Value>IDCardProvider</Value>
</Value>
<Value name="55">
<Value>IDCardTypeDR</Value>
</Value>
<Value name="56">
<Value>MedicalInsuranceID</Value>
</Value>
<Value name="57">
<Value>HosDiagnoseId</Value>
</Value>
<Value name="58">
<Value>Address</Value>
</Value>
<Value name="59">
<Value>AddressTypeDR</Value>
</Value>
<Value name="60">
<Value>Email</Value>
</Value>
<Value name="61">
<Value>PersonEmail</Value>
</Value>
<Value name="62">
<Value>RegisterType</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHealthRecordMainD</DataLocation>
<DefaultData>PersonHealthRecordMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHealthRecordMainD</IdLocation>
<IndexLocation>^CHSS.PersonHealthRecordMainI</IndexLocation>
<StreamLocation>^CHSS.PersonHealthRecordMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 
/// 
/// Descriptions:保存人员数据全集
Class DHCNMG.HR.MgPersonData Extends %Persistent [ Owner = {dhpm1} ]
{

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Create_Date ];

/// 姓名
Property PerName As %String [ SqlColumnNumber = 3, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %String [ SqlColumnNumber = 4, SqlFieldName = Per_ID ];

/// 编号（实习生编号）
Property PerNo As %String [ SqlColumnNumber = 5, SqlFieldName = Per_No ];

/// ssuserid
Property PerUserDR As %String [ SqlColumnNumber = 6, SqlFieldName = Per_UserDR ];

/// 出生日期
Property PerBirthday As %Date [ SqlColumnNumber = 7, SqlFieldName = Per_Birthday ];

/// 身份证号码
Property PerCardId As %String [ SqlColumnNumber = 8, SqlFieldName = Per_CardId ];

/// 医护类型(医生(D)、护士(N))
Property PerCareType As %String [ SqlColumnNumber = 9, SqlFieldName = Per_CareType ];

/// 性别
Property PerSexDR As %String [ SqlColumnNumber = 10, SqlFieldName = Per_SexDR ];

/// 当前病区
Property PerDepDR As %String [ SqlColumnNumber = 11, SqlFieldName = Per_DepDR ];

/// 进入病区日期
Property PerDepDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Per_DepDate ];

/// 来院日期
Property PerComeDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Per_ComeDate ];

/// 护士年届
Property PerYear As %String [ SqlColumnNumber = 14, SqlFieldName = Per_Year ];

/// 参加工作日期
Property PerWorkDate As %Date [ SqlColumnNumber = 15, SqlFieldName = Per_WorkDate ];

/// 注册证书号
Property PerRegNo As %String [ SqlColumnNumber = 16, SqlFieldName = Per_RegNo ];

/// 婚姻
Property PerMarriage As %String [ SqlColumnNumber = 17, SqlFieldName = Per_Marriage ];

/// 籍贯
Property PerNativePlace As %String [ SqlColumnNumber = 18, SqlFieldName = Per_NativePlace ];

/// 职工性质
Property PerSource As %String [ SqlColumnNumber = 19, SqlFieldName = Per_Source ];

/// 现住址
Property PerAddress As %String [ SqlColumnNumber = 20, SqlFieldName = Per_Address ];

/// 政治面貌
Property PerPolitical As %String [ SqlColumnNumber = 21, SqlFieldName = Per_Political ];

/// 民族
Property PerNation As %String [ SqlColumnNumber = 22, SqlFieldName = Per_Nation ];

/// 上衣号
Property PerClothesNo As %String [ SqlColumnNumber = 23, SqlFieldName = Per_ClothesNo ];

/// 裤号
Property PerTrouserNo As %String [ SqlColumnNumber = 24, SqlFieldName = Per_TrouserNo ];

/// 鞋号
Property PerShoesNo As %String [ SqlColumnNumber = 25, SqlFieldName = Per_ShoesNo ];

/// 人员类型（正式（N）、进修（S）、实习（P）、护理员（W） 管理员（M））
Property PerTypeDR As %String [ SqlColumnNumber = 26, SqlFieldName = Per_TypeDR ];

/// 是否轮转护士
Property PerTransFlag As %String [ SqlColumnNumber = 27, SqlFieldName = Per_TransFlag ];

/// 工作科室
Property PerWordType As %String [ SqlColumnNumber = 28, SqlFieldName = Per_WordType ];

/// 护士种类
Property PerNurType As %String [ SqlColumnNumber = 29, SqlFieldName = Per_NurType ];

/// 家庭联系人
Property PerContact As %String [ SqlColumnNumber = 30, SqlFieldName = Per_Contact ];

/// 联系方式（手机号）
Property PerPhone As %String [ SqlColumnNumber = 31, SqlFieldName = Per_Phone ];

/// 身高
Property PerHeight As %String [ SqlColumnNumber = 32, SqlFieldName = Per_Height ];

/// 扩展字段{日期}
Property PerRetireDate As %Date [ SqlColumnNumber = 33, SqlFieldName = Per_RetireDate ];

/// 扩展字段{日期}
Property PerResignDate As %Date [ SqlColumnNumber = 34, SqlFieldName = Per_ResignDate ];

/// 照片
Property PerPic As %String [ SqlColumnNumber = 35, SqlFieldName = Per_Pic ];

/// 审核状态（Y、N）
Property PerAuditFlag As %String [ SqlColumnNumber = 36, SqlFieldName = Per_AuditFlag ];

/// 审核人
Property PerAuditor As %String [ SqlColumnNumber = 37, SqlFieldName = Per_Auditor ];

/// 审核日期
Property PerAuditDate As %Date [ SqlColumnNumber = 38, SqlFieldName = Per_AuditDate ];

/// 添加人
Property RecUser As %String [ SqlColumnNumber = 39, SqlFieldName = Rec_User ];

/// 更新日期
Property RecDate As %Date [ SqlColumnNumber = 40, SqlFieldName = Rec_Date ];

/// 更新时间
Property RecTime As %Time [ SqlColumnNumber = 41, SqlFieldName = Rec_Time ];

/// 院内短号
Property PerHosShortNo As %String [ SqlColumnNumber = 42, SqlFieldName = Per_HosShortNo ];

/// 在院状态 在职 离职 退休
Property PerStatus As %String [ SqlColumnNumber = 43, SqlFieldName = Per_Status ];

/// 状态日期 
Property PerStateDate As %Date [ SqlColumnNumber = 44, SqlFieldName = PerStateDate ];

/// 状态原因
Property PerStatuReason As %String(MAXLEN = 2000) [ SqlColumnNumber = 45, SqlFieldName = Per_StatuReason ];

/// 提干日期
Property PerCadreDate As %Date [ SqlColumnNumber = 46, SqlFieldName = Per_CadreDate ];

/// 党团日期
Property PerPolitDate As %Date [ SqlColumnNumber = 47, SqlFieldName = Per_PolitDate ];

/// 家庭地址
Property PerHomeAddress As %String [ SqlColumnNumber = 48, SqlFieldName = Per_HomeAddress ];

/// 户口所在地
Property PerHouseAddress As %String [ SqlColumnNumber = 49, SqlFieldName = Per_HouseAddress ];

/// 科室
Property PerLocDR As %String [ SqlColumnNumber = 50, SqlFieldName = Per_LocDR ];

/// 用户密码
Property PerPassword As %String [ SqlColumnNumber = 51, SqlFieldName = Per_Password ];

/// HIS工号
Property HISNO As %String [ SqlColumnNumber = 52, SqlFieldName = HIS_NO ];

/// 导入日期
Property ImportDate As %Date [ SqlColumnNumber = 53, SqlFieldName = Import_Date ];

/// 导入人
Property ImportUser As %String [ SqlColumnNumber = 54, SqlFieldName = Import_User ];

/// 岗位名称
Property PostTitle As %String [ SqlColumnNumber = 55, SqlFieldName = Post_Title ];

/// 纳编日期
Property PrepareDate As %Date [ SqlColumnNumber = 56, SqlFieldName = Prepare_Date ];

/// 试工
Property PerTrialWork As %String [ SqlColumnNumber = 57, SqlFieldName = Per_TrialWork ];

/// 试工期至
Property PerTrialDate As %Date [ SqlColumnNumber = 58, SqlFieldName = Per_TrialDate ];

/// 试工合格
Property PerTrialQual As %String [ SqlColumnNumber = 59, SqlFieldName = Per_TrialQual ];

/// 应退休日期
Property PerLRetireDate As %Date [ SqlColumnNumber = 60, SqlFieldName = Per_LRetireDate ];

/// 英语级别
Property PerForeignLevel As %String [ SqlColumnNumber = 61, SqlFieldName = Per_ForeignLevel ];

/// 有无特长
Property PerIsEspecially As %String [ SqlColumnNumber = 62, SqlFieldName = Per_IsEspecially ];

/// 特长
Property PerEspecially As %String [ SqlColumnNumber = 63, SqlFieldName = Per_Especially ];

/// 执业证书注册日期
Property PerRegRegiDate As %Date [ SqlColumnNumber = 64, SqlFieldName = Per_RegRegiDate ];

/// 执业证书有效期
Property PerRegValidDate As %Date [ SqlColumnNumber = 65, SqlFieldName = Per_RegValidDate ];

/// 护士分级
Property PerNurseLevel As %String [ SqlColumnNumber = 66, SqlFieldName = Per_NurseLevel ];

/// 是否专科护士
Property PerIsSpeciNurse As %String [ SqlColumnNumber = 67, SqlFieldName = Per_IsSpeciNurse ];

/// 专科护士
Property PerSpeciNurse As list Of %String [ SqlColumnNumber = 68, SqlFieldName = Per_SpeciNurse ];

/// 取得专科日期
Property PerSeciNurseDate As %Date [ SqlColumnNumber = 69, SqlFieldName = Per_SeciNurseDate ];

/// 有无执业证书
Property PerIsRegiste As %String [ SqlColumnNumber = 70, SqlFieldName = Per_IsRegiste ];

/// 资格证书
Property PerQualCerifite As %String [ SqlColumnNumber = 71, SqlFieldName = Per_QualCerifite ];

/// 最初学历
Property PerInitialAcade As %String [ SqlColumnNumber = 72, SqlFieldName = Per_InitialAcade ];

/// 最初学历毕业院校
Property PerInitialSchool As %String [ SqlColumnNumber = 73, SqlFieldName = Per_InitialSchool ];

/// 当前学历
Property PerCurrentAcade As %String [ SqlColumnNumber = 74, SqlFieldName = Per_CurrentAcade ];

/// 当前学历毕业院校
Property PerCurrentSchool As %String [ SqlColumnNumber = 75, SqlFieldName = Per_CurrentSchool ];

/// 社会兼职
Property PerSocietyPart As %String [ SqlColumnNumber = 76, SqlFieldName = Per_SocietyPart ];

/// 人员聘用
Property PerNurseHire As %String [ SqlColumnNumber = 77, SqlFieldName = Per_NurseHire ];

/// 在护理岗
Property PerInNursePost As %String [ SqlColumnNumber = 78, SqlFieldName = Per_InNursePost ];

/// 岗位名称
Property PerPostName As %String [ SqlColumnNumber = 79, SqlFieldName = Per_PostName ];

/// 归属部门
Property PerAttriDepart As %String [ SqlColumnNumber = 80, SqlFieldName = Per_AttriDepart ];

/// 应往届【实习生的应往届】
Property PerCategroy As %String [ SqlColumnNumber = 81, SqlFieldName = Per_Categroy ];

/// 审核意见
Property AuditReason As %String [ SqlColumnNumber = 82, SqlFieldName = Audit_Reason ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 83, SqlFieldName = Audit_Time ];

/// 学历
Property PerAcademic As %String [ SqlColumnNumber = 84, SqlFieldName = Per_Academic ];

/// 学位
Property PerDegree As %String [ SqlColumnNumber = 85, SqlFieldName = Per_Degree ];

/// 职称
Property PerHireDuty As %String [ SqlColumnNumber = 86, SqlFieldName = Per_HireDuty ];

/// 层级
Property PerLevel As %String [ SqlColumnNumber = 87, SqlFieldName = Per_Level ];

/// 职务
Property PerPostDuty As %String [ SqlColumnNumber = 88, SqlFieldName = Per_PostDuty ];

Property PerRowID As DHCNMG.HR.MgPersons [ SqlColumnNumber = 89, SqlFieldName = Per_RowID ];

Index date On (CreateDate, PerRowID);

Storage Default
{
<Data name="MgPersonDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>PerName</Value>
</Value>
<Value name="4">
<Value>PerID</Value>
</Value>
<Value name="5">
<Value>PerNo</Value>
</Value>
<Value name="6">
<Value>PerUserDR</Value>
</Value>
<Value name="7">
<Value>PerBirthday</Value>
</Value>
<Value name="8">
<Value>PerCardId</Value>
</Value>
<Value name="9">
<Value>PerCareType</Value>
</Value>
<Value name="10">
<Value>PerSexDR</Value>
</Value>
<Value name="11">
<Value>PerDepDR</Value>
</Value>
<Value name="12">
<Value>PerDepDate</Value>
</Value>
<Value name="13">
<Value>PerComeDate</Value>
</Value>
<Value name="14">
<Value>PerYear</Value>
</Value>
<Value name="15">
<Value>PerWorkDate</Value>
</Value>
<Value name="16">
<Value>PerRegNo</Value>
</Value>
<Value name="17">
<Value>PerMarriage</Value>
</Value>
<Value name="18">
<Value>PerNativePlace</Value>
</Value>
<Value name="19">
<Value>PerSource</Value>
</Value>
<Value name="20">
<Value>PerAddress</Value>
</Value>
<Value name="21">
<Value>PerPolitical</Value>
</Value>
<Value name="22">
<Value>PerNation</Value>
</Value>
<Value name="23">
<Value>PerClothesNo</Value>
</Value>
<Value name="24">
<Value>PerTrouserNo</Value>
</Value>
<Value name="25">
<Value>PerShoesNo</Value>
</Value>
<Value name="26">
<Value>PerTypeDR</Value>
</Value>
<Value name="27">
<Value>PerTransFlag</Value>
</Value>
<Value name="28">
<Value>PerWordType</Value>
</Value>
<Value name="29">
<Value>PerNurType</Value>
</Value>
<Value name="30">
<Value>PerContact</Value>
</Value>
<Value name="31">
<Value>PerPhone</Value>
</Value>
<Value name="32">
<Value>PerHeight</Value>
</Value>
<Value name="33">
<Value>PerRetireDate</Value>
</Value>
<Value name="34">
<Value>PerResignDate</Value>
</Value>
<Value name="35">
<Value>PerPic</Value>
</Value>
<Value name="36">
<Value>PerAuditFlag</Value>
</Value>
<Value name="37">
<Value>PerAuditor</Value>
</Value>
<Value name="38">
<Value>PerAuditDate</Value>
</Value>
<Value name="39">
<Value>RecUser</Value>
</Value>
<Value name="40">
<Value>RecDate</Value>
</Value>
<Value name="41">
<Value>RecTime</Value>
</Value>
<Value name="42">
<Value>PerHosShortNo</Value>
</Value>
<Value name="43">
<Value>PerStatus</Value>
</Value>
<Value name="44">
<Value>PerStateDate</Value>
</Value>
<Value name="45">
<Value>PerStatuReason</Value>
</Value>
<Value name="46">
<Value>PerCadreDate</Value>
</Value>
<Value name="47">
<Value>PerPolitDate</Value>
</Value>
<Value name="48">
<Value>PerHomeAddress</Value>
</Value>
<Value name="49">
<Value>PerHouseAddress</Value>
</Value>
<Value name="50">
<Value>PerLocDR</Value>
</Value>
<Value name="51">
<Value>PerPassword</Value>
</Value>
<Value name="52">
<Value>HISNO</Value>
</Value>
<Value name="53">
<Value>ImportDate</Value>
</Value>
<Value name="54">
<Value>ImportUser</Value>
</Value>
<Value name="55">
<Value>PostTitle</Value>
</Value>
<Value name="56">
<Value>PrepareDate</Value>
</Value>
<Value name="57">
<Value>PerTrialWork</Value>
</Value>
<Value name="58">
<Value>PerTrialDate</Value>
</Value>
<Value name="59">
<Value>PerTrialQual</Value>
</Value>
<Value name="60">
<Value>PerLRetireDate</Value>
</Value>
<Value name="61">
<Value>PerForeignLevel</Value>
</Value>
<Value name="62">
<Value>PerIsEspecially</Value>
</Value>
<Value name="63">
<Value>PerEspecially</Value>
</Value>
<Value name="64">
<Value>PerRegRegiDate</Value>
</Value>
<Value name="65">
<Value>PerRegValidDate</Value>
</Value>
<Value name="66">
<Value>PerNurseLevel</Value>
</Value>
<Value name="67">
<Value>PerIsSpeciNurse</Value>
</Value>
<Value name="68">
<Value>PerSpeciNurse</Value>
</Value>
<Value name="69">
<Value>PerSeciNurseDate</Value>
</Value>
<Value name="70">
<Value>PerIsRegiste</Value>
</Value>
<Value name="71">
<Value>PerQualCerifite</Value>
</Value>
<Value name="72">
<Value>PerInitialAcade</Value>
</Value>
<Value name="73">
<Value>PerInitialSchool</Value>
</Value>
<Value name="74">
<Value>PerCurrentAcade</Value>
</Value>
<Value name="75">
<Value>PerCurrentSchool</Value>
</Value>
<Value name="76">
<Value>PerSocietyPart</Value>
</Value>
<Value name="77">
<Value>PerNurseHire</Value>
</Value>
<Value name="78">
<Value>PerInNursePost</Value>
</Value>
<Value name="79">
<Value>PerPostName</Value>
</Value>
<Value name="80">
<Value>PerAttriDepart</Value>
</Value>
<Value name="81">
<Value>PerCategroy</Value>
</Value>
<Value name="82">
<Value>AuditReason</Value>
</Value>
<Value name="83">
<Value>AuditTime</Value>
</Value>
<Value name="84">
<Value>PerEducate</Value>
</Value>
<Value name="85">
<Value>PerAcademic</Value>
</Value>
<Value name="86">
<Value>PerDegree</Value>
</Value>
<Value name="87">
<Value>PerHireDuty</Value>
</Value>
<Value name="88">
<Value>PerLevel</Value>
</Value>
<Value name="89">
<Value>PerPostDuty</Value>
</Value>
<Value name="90">
<Value>PerRowID</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgPersonDataD</DataLocation>
<DefaultData>MgPersonDataDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgPersonDataD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgPersonDataI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgPersonDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

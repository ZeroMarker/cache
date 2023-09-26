/// Creator:
/// Descriptions:护士专业档案
/// Date:
/// 
Class DHCNMG.HR.MgPersons Extends %Persistent
{

/// 姓名
Property PerName As %String [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %String [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 编号（实习生编号、进修生编号）
Property PerNo As %String [ SqlColumnNumber = 4, SqlFieldName = Per_No ];

/// ssuserid
Property PerUserDR As %String [ SqlColumnNumber = 5, SqlFieldName = Per_UserDR ];

/// 出生日期
Property PerBirthday As %Date [ SqlColumnNumber = 6, SqlFieldName = Per_Birthday ];

/// 身份证号码
Property PerCardId As %String [ SqlColumnNumber = 7, SqlFieldName = Per_CardId ];

/// 医护类型(医生(D)、护士(N))
Property PerCareType As %String [ SqlColumnNumber = 8, SqlFieldName = Per_CareType ];

/// 性别
Property PerSexDR As %String [ SqlColumnNumber = 9, SqlFieldName = Per_SexDR ];

/// 当前病区
Property PerDepDR As %String [ SqlColumnNumber = 10, SqlFieldName = Per_DepDR ];

/// 进入病区日期
Property PerDepDate As %Date [ SqlColumnNumber = 11, SqlFieldName = Per_DepDate ];

/// 来院日期
Property PerComeDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Per_ComeDate ];

/// 护士年届
Property PerYear As %String [ SqlColumnNumber = 13, SqlFieldName = Per_Year ];

/// 参加工作日期
Property PerWorkDate As %Date [ SqlColumnNumber = 14, SqlFieldName = Per_WorkDate ];

/// 执业证书
Property PerRegNo As %String [ SqlColumnNumber = 15, SqlFieldName = Per_RegNo ];

/// 婚姻
Property PerMarriage As %String [ SqlColumnNumber = 16, SqlFieldName = Per_Marriage ];

/// 籍贯
Property PerNativePlace As %String [ SqlColumnNumber = 17, SqlFieldName = Per_NativePlace ];

/// 职工性质(受聘形式)
Property PerSource As %String [ SqlColumnNumber = 18, SqlFieldName = Per_Source ];

/// 现住址
Property PerAddress As %String [ SqlColumnNumber = 19, SqlFieldName = Per_Address ];

/// 政治面貌
Property PerPolitical As %String [ SqlColumnNumber = 20, SqlFieldName = Per_Political ];

/// 民族
Property PerNation As %String [ SqlColumnNumber = 21, SqlFieldName = Per_Nation ];

/// 上衣号
Property PerClothesNo As %String [ SqlColumnNumber = 22, SqlFieldName = Per_ClothesNo ];

/// 裤号
Property PerTrouserNo As %String [ SqlColumnNumber = 23, SqlFieldName = Per_TrouserNo ];

/// 鞋号
Property PerShoesNo As %String [ SqlColumnNumber = 24, SqlFieldName = Per_ShoesNo ];

/// 人员类型（正式（N）、进修（S）、实习（P）、护理员（W） 管理员（M） 工人（G）） 助理护士（A） 护理学员（T）
Property PerTypeDR As %String [ SqlColumnNumber = 25, SqlFieldName = Per_TypeDR ];

/// 是否轮转护士
Property PerTransFlag As %String [ SqlColumnNumber = 26, SqlFieldName = Per_TransFlag ];

/// 工作科室
Property PerWordType As %String [ SqlColumnNumber = 27, SqlFieldName = Per_WordType ];

/// 护士种类
Property PerNurType As %String [ SqlColumnNumber = 28, SqlFieldName = Per_NurType ];

/// 家庭联系人
Property PerContact As %String [ SqlColumnNumber = 29, SqlFieldName = Per_Contact ];

/// 联系方式（手机号）
Property PerPhone As %String [ SqlColumnNumber = 30, SqlFieldName = Per_Phone ];

/// 身高
Property PerHeight As %String [ SqlColumnNumber = 31, SqlFieldName = Per_Height ];

/// 扩展字段{日期}
Property PerRetireDate As %Date [ SqlColumnNumber = 32, SqlFieldName = Per_RetireDate ];

/// 扩展字段{日期}
Property PerResignDate As %Date [ SqlColumnNumber = 33, SqlFieldName = Per_ResignDate ];

/// 照片
Property PerPic As %String [ SqlColumnNumber = 34, SqlFieldName = Per_Pic ];

/// 审核状态（Y、N）
Property PerAuditFlag As %String [ SqlColumnNumber = 35, SqlFieldName = Per_AuditFlag ];

/// 审核人
Property PerAuditor As %String [ SqlColumnNumber = 36, SqlFieldName = Per_Auditor ];

/// 审核日期
Property PerAuditDate As %Date [ SqlColumnNumber = 37, SqlFieldName = Per_AuditDate ];

/// 添加人
Property RecUser As %String [ SqlColumnNumber = 38, SqlFieldName = Rec_User ];

/// 更新日期
Property RecDate As %Date [ SqlColumnNumber = 39, SqlFieldName = Rec_Date ];

/// 更新时间
Property RecTime As %Time [ SqlColumnNumber = 40, SqlFieldName = Rec_Time ];

/// 院内短号
Property PerHosShortNo As %String [ SqlColumnNumber = 41, SqlFieldName = Per_HosShortNo ];

/// 在院状态 在职 离职 退休
Property PerStatus As %String [ SqlColumnNumber = 42, SqlFieldName = Per_Status ];

/// 状态日期 
Property PerStateDate As %Date [ SqlColumnNumber = 43, SqlFieldName = PerStateDate ];

/// 状态原因
Property PerStatuReason As %String(MAXLEN = 2000) [ SqlColumnNumber = 44, SqlFieldName = Per_StatuReason ];

/// 提干日期
Property PerCadreDate As %Date [ SqlColumnNumber = 45, SqlFieldName = Per_CadreDate ];

/// 聘任职称
/// Property PerHireDuty As %String [ SqlColumnNumber = 46, SqlFieldName = Per_HireDuty ];
/// 聘任职称日期
/// Property PerHireDutyDate As %Date [ SqlColumnNumber = 47, SqlFieldName = Per_HireDutyDate ];
/// 职务
/// Property PerPostDuty As %String [ SqlColumnNumber = 48, SqlFieldName = Per_PostDuty ];
/// 职务日期
/// Property PerPostDutyDate As %Date [ SqlColumnNumber = 49, SqlFieldName = Per_PostDutyDate ];
/// 党团日期
Property PerPolitDate As %Date [ SqlColumnNumber = 50, SqlFieldName = Per_PolitDate ];

/// 家庭地址
Property PerHomeAddress As %String [ SqlColumnNumber = 51, SqlFieldName = Per_HomeAddress ];

/// 户口所在地
Property PerHouseAddress As %String [ SqlColumnNumber = 52, SqlFieldName = Per_HouseAddress ];

/// 科室
Property PerLocDR As %String [ SqlColumnNumber = 53, SqlFieldName = Per_LocDR ];

/// 用户密码
Property PerPassword As %String [ SqlColumnNumber = 54, SqlFieldName = Per_Password ];

/// HIS工号
Property HISNO As %String [ SqlColumnNumber = 55, SqlFieldName = HIS_NO ];

/// 导入日期
Property ImportDate As %Date [ SqlColumnNumber = 56, SqlFieldName = Import_Date ];

/// 导入人
Property ImportUser As %String [ SqlColumnNumber = 57, SqlFieldName = Import_User ];

/// 岗位名称
Property PostTitle As %String [ SqlColumnNumber = 58, SqlFieldName = Post_Title ];

/// 纳编日期
Property PrepareDate As %Date [ SqlColumnNumber = 59, SqlFieldName = Prepare_Date ];

/// 试工
Property PerTrialWork As %String [ SqlColumnNumber = 60, SqlFieldName = Per_TrialWork ];

/// 试工期至
Property PerTrialDate As %Date [ SqlColumnNumber = 61, SqlFieldName = Per_TrialDate ];

/// 试工合格
Property PerTrialQual As %String [ SqlColumnNumber = 62, SqlFieldName = Per_TrialQual ];

/// 应退休日期
Property PerLRetireDate As %Date [ SqlColumnNumber = 63, SqlFieldName = Per_LRetireDate ];

/// 英语级别
Property PerForeignLevel As %String [ SqlColumnNumber = 64, SqlFieldName = Per_ForeignLevel ];

/// 有无特长
Property PerIsEspecially As %String [ SqlColumnNumber = 65, SqlFieldName = Per_IsEspecially ];

/// 特长
Property PerEspecially As %String [ SqlColumnNumber = 66, SqlFieldName = Per_Especially ];

/// 执业证书注册日期
Property PerRegRegiDate As %Date [ SqlColumnNumber = 67, SqlFieldName = Per_RegRegiDate ];

/// 执业证书有效期
Property PerRegValidDate As %Date [ SqlColumnNumber = 68, SqlFieldName = Per_RegValidDate ];

/// 护士分级
Property PerNurseLevel As %String [ SqlColumnNumber = 69, SqlFieldName = Per_NurseLevel ];

/// 是否专科护士
Property PerIsSpeciNurse As %String [ SqlColumnNumber = 70, SqlFieldName = Per_IsSpeciNurse ];

/// 专科护士
Property PerSpeciNurse As list Of %String [ SqlColumnNumber = 71, SqlFieldName = Per_SpeciNurse ];

/// 取得专科日期
Property PerSeciNurseDate As %Date [ SqlColumnNumber = 72, SqlFieldName = Per_SeciNurseDate ];

/// 有无执业证书
Property PerIsRegiste As %String [ SqlColumnNumber = 73, SqlFieldName = Per_IsRegiste ];

/// 资格证书
Property PerQualCerifite As %String [ SqlColumnNumber = 74, SqlFieldName = Per_QualCerifite ];

/// 最初学历
Property PerInitialAcade As %String [ SqlColumnNumber = 75, SqlFieldName = Per_InitialAcade ];

/// 最初学历毕业院校
Property PerInitialSchool As %String [ SqlColumnNumber = 76, SqlFieldName = Per_InitialSchool ];

/// 当前学历
Property PerCurrentAcade As %String [ SqlColumnNumber = 77, SqlFieldName = Per_CurrentAcade ];

/// 当前学历毕业院校
Property PerCurrentSchool As %String [ SqlColumnNumber = 78, SqlFieldName = Per_CurrentSchool ];

/// 社会兼职
Property PerSocietyPart As %String(MAXLEN = 1000) [ SqlColumnNumber = 79, SqlFieldName = Per_SocietyPart ];

/// 人员聘用
Property PerNurseHire As %String [ SqlColumnNumber = 80, SqlFieldName = Per_NurseHire ];

/// 在护理岗
Property PerInNursePost As %String [ SqlColumnNumber = 81, SqlFieldName = Per_InNursePost ];

/// 岗位名称
Property PerPostName As %String [ SqlColumnNumber = 82, SqlFieldName = Per_PostName ];

/// 归属部门
Property PerAttriDepart As %String [ SqlColumnNumber = 83, SqlFieldName = Per_AttriDepart ];

/// 离职方式
Property PerLeaveMode As %String [ SqlColumnNumber = 84, SqlFieldName = Per_LeaveMode ];

/// 离职原因
Property PerLeaveReason As %String [ SqlColumnNumber = 85, SqlFieldName = Per_LeaveReason ];

/// 离职日期
Property PerLeaveDate As %String [ SqlColumnNumber = 86, SqlFieldName = Per_LeaveDate ];

/// 应往届【实习生的应往届】
Property PerCategroy As %String [ SqlColumnNumber = 87, SqlFieldName = Per_Categroy ];

/// 审核意见
Property AuditReason As %String [ SqlColumnNumber = 88, SqlFieldName = Audit_Reason ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 89, SqlFieldName = Audit_Time ];

/// 实习生院校
Property PerInternSchool As %String [ SqlColumnNumber = 90, SqlFieldName = Per_InternSchool ];

/// 体重
Property PerWeight As %String [ SqlColumnNumber = 91, SqlFieldName = Per_Weight ];

/// 特长
Property PerHobby As %String(MAXLEN = 1000) [ SqlColumnNumber = 92, SqlFieldName = Per_Hobby ];

/// 实习生类别
Property PerType As %String [ SqlColumnNumber = 93, SqlFieldName = Per_Type ];

/// 外派人员进修标识【Y:外派进修】
Property PerTrainFlag As %String [ SqlColumnNumber = 94, SqlFieldName = Per_TrainFlag ];

/// 原工作单位[进修生]
Property PerUnit As %String [ SqlColumnNumber = 95, SqlFieldName = Per_Unit ];

/// 来院进修生职称
Property PerHireJob As %String [ SqlColumnNumber = 96, SqlFieldName = Per_HireJob ];

/// 来院进修开始日期
Property PerTrainStDate As %Date [ SqlColumnNumber = 97, SqlFieldName = Per_TrainStDate ];

/// 来院进修结束日期
Property PerTrainEndDate As %Date [ SqlColumnNumber = 98, SqlFieldName = Per_TrainEndDate ];

/// 来院进修费用
Property PerTrainFee As %String [ SqlColumnNumber = 99, SqlFieldName = Per_TrainFee ];

/// 备注
Property PerRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 100, SqlFieldName = Per_Remark ];

/// 岗位竞聘
Property PerPostCompete As %String [ SqlColumnNumber = 101, SqlFieldName = Per_PostCompete ];

/// 家庭联系人电话
Property PerContactPhone As %String [ SqlColumnNumber = 102, SqlFieldName = Per_ContactPhone ];

/// 实习生转正日期【转成助护 】
Property PerInternDate As %Date [ SqlColumnNumber = 103, SqlFieldName = Per_InternDate ];

/// 学员 转成助护的日期
Property PerStuToAss As %Date [ SqlColumnNumber = 104, SqlFieldName = Per_StuToAss ];

/// 学员转成护士的日期
Property PerStuToNurse As %Date [ SqlColumnNumber = 105, SqlFieldName = Per_StuToNurse ];

/// 助护转成护士的日期
Property PerAssToNurse As %Date [ SqlColumnNumber = 106, SqlFieldName = Per_AssToNurse ];

/// 助护转 学员 日期
Property PerAssToStu As %Date [ SqlColumnNumber = 107, SqlFieldName = Per_AssToStu ];

/// 实习生转学员
Property PerInternToStu As %Date [ SqlColumnNumber = 108, SqlFieldName = Per_InternToStu ];

/// 实际职称
Property PerSJHireDuty As %String [ SqlColumnNumber = 109, SqlFieldName = Per_SJHireDuty ];

/// 实际职称取得日期
Property PerSJHireDutyDate As %Date [ SqlColumnNumber = 110, SqlFieldName = Per_SJHireDutyDate ];

Index PerID On PerID;

Index DepID On PerDepDR;

Index type On PerTypeDR;

Index card On PerCardId;

Index hisno On HISNO;

Index Info On (PerTypeDR, PerNo);

Index PerNo On PerNo;

Storage Default
{
<Data name="MgPersonsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerName</Value>
</Value>
<Value name="3">
<Value>PerID</Value>
</Value>
<Value name="4">
<Value>PerNo</Value>
</Value>
<Value name="5">
<Value>PerUserDR</Value>
</Value>
<Value name="6">
<Value>PerBirthday</Value>
</Value>
<Value name="7">
<Value>PerCardId</Value>
</Value>
<Value name="8">
<Value>PerCareType</Value>
</Value>
<Value name="9">
<Value>PerSexDR</Value>
</Value>
<Value name="10">
<Value>PerDepDR</Value>
</Value>
<Value name="11">
<Value>PerDepDate</Value>
</Value>
<Value name="12">
<Value>PerComeDate</Value>
</Value>
<Value name="13">
<Value>PerYear</Value>
</Value>
<Value name="14">
<Value>PerWorkDate</Value>
</Value>
<Value name="15">
<Value>PerRegNo</Value>
</Value>
<Value name="16">
<Value>PerMarriage</Value>
</Value>
<Value name="17">
<Value>PerNativePlace</Value>
</Value>
<Value name="18">
<Value>PerSource</Value>
</Value>
<Value name="19">
<Value>PerAddress</Value>
</Value>
<Value name="20">
<Value>PerPolitical</Value>
</Value>
<Value name="21">
<Value>PerNation</Value>
</Value>
<Value name="22">
<Value>PerClothesNo</Value>
</Value>
<Value name="23">
<Value>PerTrouserNo</Value>
</Value>
<Value name="24">
<Value>PerShoesNo</Value>
</Value>
<Value name="25">
<Value>PerTypeDR</Value>
</Value>
<Value name="26">
<Value>PerTransFlag</Value>
</Value>
<Value name="27">
<Value>PerWordType</Value>
</Value>
<Value name="28">
<Value>PerNurType</Value>
</Value>
<Value name="29">
<Value>PerContact</Value>
</Value>
<Value name="30">
<Value>PerPhone</Value>
</Value>
<Value name="31">
<Value>PerRetireDate</Value>
</Value>
<Value name="32">
<Value>PerResignDate</Value>
</Value>
<Value name="33">
<Value>PerAuditFlag</Value>
</Value>
<Value name="34">
<Value>PerAuditor</Value>
</Value>
<Value name="35">
<Value>PerAuditDate</Value>
</Value>
<Value name="36">
<Value>PerPic</Value>
</Value>
<Value name="37">
<Value>RecUser</Value>
</Value>
<Value name="38">
<Value>RecDate</Value>
</Value>
<Value name="39">
<Value>RecTime</Value>
</Value>
<Value name="40">
<Value>PerHeight</Value>
</Value>
<Value name="41">
<Value>PerArchive</Value>
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
<Value>PerHireDuty</Value>
</Value>
<Value name="48">
<Value>PerPostDuty</Value>
</Value>
<Value name="49">
<Value>PerPolitDate</Value>
</Value>
<Value name="50">
<Value>PerHomeAddress</Value>
</Value>
<Value name="51">
<Value>PerHouseAddress</Value>
</Value>
<Value name="52">
<Value>PerLocDR</Value>
</Value>
<Value name="53">
<Value>PerHireDutyDate</Value>
</Value>
<Value name="54">
<Value>PerPostDutyDate</Value>
</Value>
<Value name="55">
<Value>PerPassword</Value>
</Value>
<Value name="56">
<Value>HISNO</Value>
</Value>
<Value name="57">
<Value>ImportDate</Value>
</Value>
<Value name="58">
<Value>ImportUser</Value>
</Value>
<Value name="59">
<Value>PostTitle</Value>
</Value>
<Value name="60">
<Value>PrepareDate</Value>
</Value>
<Value name="61">
<Value>PerCareDate</Value>
</Value>
<Value name="62">
<Value>PerTrialWork</Value>
</Value>
<Value name="63">
<Value>PerTrialDate</Value>
</Value>
<Value name="64">
<Value>PerTrialQual</Value>
</Value>
<Value name="65">
<Value>PerLRetireDate</Value>
</Value>
<Value name="66">
<Value>PerForeignLeve</Value>
</Value>
<Value name="67">
<Value>PerIsEspecially</Value>
</Value>
<Value name="68">
<Value>PerForeignLevel</Value>
</Value>
<Value name="69">
<Value>PerEspecially</Value>
</Value>
<Value name="70">
<Value>PerRegRegiDate</Value>
</Value>
<Value name="71">
<Value>PerRegValidDate</Value>
</Value>
<Value name="72">
<Value>PerNurseLevel</Value>
</Value>
<Value name="73">
<Value>PerIsSpeciNurse</Value>
</Value>
<Value name="74">
<Value>PerSepeciNurse</Value>
</Value>
<Value name="75">
<Value>PerSpeciNurse</Value>
</Value>
<Value name="76">
<Value>PerSeciNurseDate</Value>
</Value>
<Value name="77">
<Value>PerIsRegiste</Value>
</Value>
<Value name="78">
<Value>PerQualCerifite</Value>
</Value>
<Value name="79">
<Value>PerInitialAcade</Value>
</Value>
<Value name="80">
<Value>PerInitialSchool</Value>
</Value>
<Value name="81">
<Value>PerCurrentAcade</Value>
</Value>
<Value name="82">
<Value>PerCurrentSchool</Value>
</Value>
<Value name="83">
<Value>PerSocietyPart</Value>
</Value>
<Value name="84">
<Value>PerNurseHire</Value>
</Value>
<Value name="85">
<Value>PerInNursePost</Value>
</Value>
<Value name="86">
<Value>PerPostName</Value>
</Value>
<Value name="87">
<Value>PerAttriDepart</Value>
</Value>
<Value name="88">
<Value>PerLeaveMode</Value>
</Value>
<Value name="89">
<Value>PerLeaveReason</Value>
</Value>
<Value name="90">
<Value>PerLeaveDate</Value>
</Value>
<Value name="91">
<Value>PerCategroy</Value>
</Value>
<Value name="92">
<Value>AuditReason</Value>
</Value>
<Value name="93">
<Value>AuditTime</Value>
</Value>
<Value name="94">
<Value>PerInternSchool</Value>
</Value>
<Value name="95">
<Value>PerInternAcade</Value>
</Value>
<Value name="96">
<Value>PerInternProf</Value>
</Value>
<Value name="97">
<Value>PerWeight</Value>
</Value>
<Value name="98">
<Value>PerHobby</Value>
</Value>
<Value name="99">
<Value>PerInternType</Value>
</Value>
<Value name="100">
<Value>PerType</Value>
</Value>
<Value name="101">
<Value>PerTrainFlag</Value>
</Value>
<Value name="102">
<Value>PerUnit</Value>
</Value>
<Value name="103">
<Value>PerHireJob</Value>
</Value>
<Value name="104">
<Value>PerTrainStDate</Value>
</Value>
<Value name="105">
<Value>PerTrainEndDate</Value>
</Value>
<Value name="106">
<Value>PerTrainFee</Value>
</Value>
<Value name="107">
<Value>PerTrainLoc</Value>
</Value>
<Value name="108">
<Value>PerRemark</Value>
</Value>
<Value name="109">
<Value>PerPostCompete</Value>
</Value>
<Value name="110">
<Value>PerContactPhone</Value>
</Value>
<Value name="111">
<Value>PerInternDate</Value>
</Value>
<Value name="112">
<Value>PerStuToAss</Value>
</Value>
<Value name="113">
<Value>PerStuToNurse</Value>
</Value>
<Value name="114">
<Value>PerAssToNurse</Value>
</Value>
<Value name="115">
<Value>PerAssToStu</Value>
</Value>
<Value name="116">
<Value>PerInternToStu</Value>
</Value>
<Value name="117">
<Value>PerSJHireDuty</Value>
</Value>
<Value name="118">
<Value>PerSJHireDutyDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgPersonsD</DataLocation>
<DefaultData>MgPersonsDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgPersonsD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgPersonsI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgPersonsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

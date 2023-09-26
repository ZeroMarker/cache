/// 手术申请
Class CIS.AN.OperSchedule Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperSchedule ]
{

/// 就诊ID
Property EpisodeID As %String [ SqlColumnNumber = 2 ];

/// 第三方系统手术ID
Property ExternalID As %String [ SqlColumnNumber = 3 ];

/// 手术申请科室ID
Property AppDeptID As %String [ SqlColumnNumber = 4 ];

/// 手术室ID(指定手术在哪个手术室完成)
Property OperDeptID As %String [ SqlColumnNumber = 5 ];

/// 手术执行科室ID(指定手术由哪个科室完成)
Property OperExecDeptID As %String [ SqlColumnNumber = 6 ];

/// 手术申请时，病人所在的科室ID
Property PatDeptID As %String [ SqlColumnNumber = 7 ];

/// 手术申请时，病人所在的病区ID
Property PatWardID As %String [ SqlColumnNumber = 8 ];

/// 手术申请时，病人所在的床位
Property PatBedID As %String [ SqlColumnNumber = 9 ];

/// 手术状态
Property Status As CT.AN.OperStatus [ SqlColumnNumber = 10 ];

/// 术前诊断
Property PrevDiagnosis As %String(MAXLEN = 500) [ SqlColumnNumber = 11 ];

/// 拟施麻醉ID
Property PrevAnaMethod As %String [ SqlColumnNumber = 12 ];

/// 申请日期
Property AppDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13 ];

/// 申请时间
Property AppTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14 ];

/// 手术日期
Property OperDate As %Date [ SqlColumnNumber = 15 ];

/// 手术开始时间
Property OperTime As %Time [ SqlColumnNumber = 16 ];

/// 手术申请用户ID
Property AppUserID As %String [ SqlColumnNumber = 17 ];

/// 手术申请医护人员ID
Property AppCareProvID As %String [ SqlColumnNumber = 18 ];

/// 手术类型(急诊或择期)
Property SourceType As %String(DISPLAYLIST = ",择期,急诊,日间", MAXLEN = 4, VALUELIST = ",B,E,D") [ SqlColumnNumber = 19 ];

/// 是否麻醉
Property Anaesthesia As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 20 ];

/// 是否重返手术(非计划二次手术)
Property ReentryOperation As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 21 ];

/// 是否隔离手术
Property IsoOperation As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 22 ];

/// 是否体外循环
Property ECC As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 23 ];

/// 是否自体血回输
Property TransAutoblood As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 24 ];

/// 是否备血
Property PrepareBlood As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 25 ];

/// 血型
Property BloodType As %String(DISPLAYLIST = ",未知,A型,B型,O型,AB型,已查未归", VALUELIST = ",N,A,B,O,AB,UR") [ SqlColumnNumber = 26 ];

/// RH血型
Property RHBloodType As %String(DISPLAYLIST = ",未知,阴性,阳性,已查未归", VALUELIST = ",N,-,+,UR") [ SqlColumnNumber = 27 ];

/// HbsAg
Property HbsAg As %String(DISPLAYLIST = ",未知,阴性,阳性,已查未归", VALUELIST = ",N,-,+,UR") [ SqlColumnNumber = 28 ];

/// HcvAb
Property HcvAb As %String(DISPLAYLIST = ",未知,阴性,阳性,已查未归", VALUELIST = ",N,-,+,UR") [ SqlColumnNumber = 29 ];

/// HivAb
Property HivAb As %String(DISPLAYLIST = ",未知,阴性,阳性,已查未归", VALUELIST = ",N,-,+,UR") [ SqlColumnNumber = 30 ];

/// 梅毒
Property Syphilis As %String(DISPLAYLIST = ",未知,阴性,阳性,已查未归", VALUELIST = ",N,-,+,UR") [ SqlColumnNumber = 31 ];

/// 手术要求
Property OperRequirement As %String(MAXLEN = 200) [ SqlColumnNumber = 32 ];

/// 检验信息
Property LabTest As %String(MAXLEN = 200) [ SqlColumnNumber = 33 ];

/// 病人姓名
Property PatName As %String [ SqlColumnNumber = 34 ];

/// 病人性别
Property PatGender As %String [ SqlColumnNumber = 35 ];

/// 病人出生日期
Property PatDOB As %Date [ SqlColumnNumber = 36 ];

/// 病人体重
Property PatWeight As %String [ SqlColumnNumber = 37 ];

/// 病人身高
Property PatHeight As %String [ SqlColumnNumber = 38 ];

/// 手术用时
Property OperDuration As %Float [ SqlColumnNumber = 39 ];

/// 手术物品
Property SurgicalMaterials As %String(MAXLEN = 200) [ SqlColumnNumber = 40 ];

/// 特殊情况
Property SpecialConditions As %String(MAXLEN = 200) [ SqlColumnNumber = 41 ];

/// 计划台次
Property PlanSeq As %Integer [ SqlColumnNumber = 42 ];

/// 手术申请医嘱ID
Property AppOrderItem As %String [ SqlColumnNumber = 43 ];

/// 外部系统麻醉ID
Property ExtAnaestID As %String [ SqlColumnNumber = 44 ];

/// 手术体位
Property OperPosition As %String [ SqlColumnNumber = 45 ];

/// 专家手术标志
Property ExpertFlag As %String [ SqlColumnNumber = 46 ];

/// 原来的手术申请
Property OriginalSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 47 ];

/// 手术台次类型
Property SeqType As %String(DISPLAYLIST = ",正常台,接台", VALUELIST = ",N,C") [ SqlColumnNumber = 48 ];

/// 高值耗材
Property HighConsume As %String(MAXLEN = 500) [ SqlColumnNumber = 49 ];

/// 是否使用抗生素
Property Antibiosis As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 50 ];

/// 感染手术
Property InfectionOper As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 51 ];

/// 是否微创手术
Property MIS As %String [ SqlColumnNumber = 52 ];

/// 手术部位
Property BodySite As %String [ SqlColumnNumber = 53 ];

/// 实习进修人员
Property SurIntership As %String [ SqlColumnNumber = 54 ];

/// 手术参观人员
Property SurVisitors As %String [ SqlColumnNumber = 55 ];

/// 手术间
Property OperRoom As CF.AN.Location [ SqlColumnNumber = 56 ];

/// 手术台次
Property OperSeq As %String [ SqlColumnNumber = 57 ];

/// 器械护士
Property ScrubNurse As %String [ SqlColumnNumber = 58 ];

/// 巡回护士
Property CircualNurse As %String [ SqlColumnNumber = 59 ];

/// 患者登记号
Property RegNo As %String [ SqlColumnNumber = 60 ];

/// 患者住院号
Property MedicareNo As %String [ SqlColumnNumber = 61 ];

/// 日间手术标志
Property DaySurgery As %String(DISPLAYLIST = ",是,否", MAXLEN = 4, VALUELIST = ",Y,N") [ SqlColumnNumber = 62 ];

/// 撤回标志
Property RevokeFlag As %String(DISPLAYLIST = ",是,否", MAXLEN = 4, VALUELIST = ",Y,N") [ SqlColumnNumber = 63 ];

/// 术后诊断
Property PostDiagnosis As %String(MAXLEN = 200) [ SqlColumnNumber = 64 ];

/// 切口类型
Property BladeType As %String [ SqlColumnNumber = 65 ];

/// 麻醉科室
Property AnaDept As %String [ SqlColumnNumber = 66 ];

/// 患者身份证号
Property CardID As %String [ SqlColumnNumber = 67 ];

/// 费别
Property AdmReason As %String [ SqlColumnNumber = 68 ];

/// 就诊日期
Property AdmDate As %Date [ SqlColumnNumber = 69 ];

/// 正在安排的手术间
Property ArrOperRoom As CF.AN.Location [ SqlColumnNumber = 70 ];

/// 正在安排的台次
Property ArrOperSeq As %String [ SqlColumnNumber = 71 ];

/// 正在安排的器械护士
Property ArrScrubNurse As %String [ SqlColumnNumber = 72 ];

/// 正在安排的巡回护士
Property ArrCircualNurse As %String [ SqlColumnNumber = 73 ];

/// 多重耐药菌
Property MDROS As %String [ SqlColumnNumber = 74 ];

/// 手术就诊类型
Property OPAdmType As %String(DISPLAYLIST = ",门诊手术,住院手术,科内手术", VALUELIST = ",OOP,IOP,DOP") [ SqlColumnNumber = 75 ];

/// 患者来院时间
Property ComeHosTime As %Time [ SqlColumnNumber = 76 ];

/// 患者联系号码
Property PatPhoneNumber As %String [ SqlColumnNumber = 77 ];

/// 患者须知
Property PatNeedNotice As %String(MAXLEN = 500) [ SqlColumnNumber = 78 ];

/// 恢复床
Property PACUBed As CF.AN.Location [ SqlColumnNumber = 79 ];

/// 手术费用审核标志
Property OPFeeFlag As %String(DISPLAYLIST = ",已审核,待审核", VALUELIST = ",Y,N") [ SqlColumnNumber = 80 ];

/// 麻醉费用审核标志
Property ANFeeFlag As %String(DISPLAYLIST = ",已审核,待审核", VALUELIST = ",Y,N") [ SqlColumnNumber = 81 ];

/// PACU出室Steward评分
Property PACUOutSteward As %String [ SqlColumnNumber = 82 ];

/// 医疗组长
Property TeamLeader As %String [ SqlColumnNumber = 83 ];

/// 手术室实习进修人员
Property OperStaff As %String [ SqlColumnNumber = 84 ];

/// 申请类型
Property AppType As %String(DISPLAYLIST = ",手术申请,麻醉申请,科内手术", VALUELIST = ",OP,AN,DOP") [ SqlColumnNumber = 85 ];

/// 申请医生联系电话
Property AppDocPhoneNo As %String [ SqlColumnNumber = 86 ];

/// 药物过敏
Property DrugAllergy As %String(DISPLAYLIST = ",无,有", VALUELIST = ",N,Y") [ SqlColumnNumber = 87 ];

/// 药物过敏说明
Property DrugAllergyNote As %String(MAXLEN = 500) [ SqlColumnNumber = 88 ];

/// 正在安排的手术开始时间
Property ArrOperTime As %String [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 89 ];

/// 手术取消原因
Property CancelReason As %String(MAXLEN = 500) [ SqlColumnNumber = 90 ];

/// 手术取消操作人
Property CancelUser As %String [ SqlColumnNumber = 91 ];

/// 手术取消操作时间
Property CancelTime As %TimeStamp [ SqlColumnNumber = 92 ];

/// 排班通知单打印标志(深圳南山)
Property ArrPrintFlag As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 93 ];

/// 器械助手
Property ScrubAssistant As %String [ SqlColumnNumber = 94 ];

/// 巡回助手
Property CircualAssistant As %String [ SqlColumnNumber = 95 ];

/// 术后登记医生
Property DocRegisterUser As %String [ SqlColumnNumber = 96 ];

/// 术后登记日期
Property DocRegisterDate As %Date [ SqlColumnNumber = 97 ];

/// 术后登记时间
Property DocRegisterTime As %Time [ SqlColumnNumber = 98 ];

/// 手术时段(上午、下午，门诊手术用)
Property OperPeriod As %String [ SqlColumnNumber = 99 ];

/// 末次月经
Property PatLMP As %String [ SqlColumnNumber = 100 ];

/// 非计划二次手术(南山医院质控使用)
Property UnPlanSecOper As %String [ SqlColumnNumber = 101 ];

/// 手术包
Property SurgicalKit As %String [ SqlColumnNumber = 102 ];

/// 外院专家职业资格证编码
Property SELicenseCode As %String [ SqlColumnNumber = 103 ];

/// 日间手术备注
Property DaySurgeryNote As %String(MAXLEN = 200) [ SqlColumnNumber = 104 ];

/// 机器人
Property Robot As %String [ SqlColumnNumber = 105 ];

/// 导航
Property Navigation As %String [ SqlColumnNumber = 106 ];

/// 是否补充器械
Property AddInstruments As %String [ SqlColumnNumber = 107 ];

/// 委托人姓名
Property AgentName As %String [ SqlColumnNumber = 108 ];

/// 委托人手机号
Property AgentMobNo As %String [ SqlColumnNumber = 109 ];

/// 主刀手机号
Property SurgeonMobNo As %String [ SqlColumnNumber = 110 ];

/// 助手手机号
Property AssitMobNo As %String [ SqlColumnNumber = 111 ];

/// 保留标本
Property KeepSpecimen As %String [ SqlColumnNumber = 112 ];

/// 新型冠状病毒肺炎核酸检测
Property COVIDNATest As %String [ SqlColumnNumber = 113 ];

/// 手术规模
Property OperScope As %String(DISPLAYLIST = ",大,中,小,特", VALUELIST = ",L,M,S,E") [ SqlColumnNumber = 114 ];

/// 科室计划台次,积水潭用:A1创6-第一条-第1台
Property LocPlanSeqNo As %String [ SqlColumnNumber = 115 ];

/// 统计分类(四川成都新都中医)
Property StatCategory As %String [ SqlColumnNumber = 116 ];

/// 总台次(四川成都新都中医)
Property StatSeq As %String [ SqlColumnNumber = 117 ];

/// 部位深浅(自贡三院)
Property SiteDepth As %String [ SqlColumnNumber = 118 ];

/// 腔镜手术(自贡三院)
Property Endoscopy As %String [ SqlColumnNumber = 119 ];

/// 计划生育手术
Property FamilyPlanning As %String [ SqlColumnNumber = 120 ];

/// 是否冰冻
Property Profrozen As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 121 ];

/// 是否使用C型臂
Property MechanicalArm As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 122 ];

/// 首台延缓原因：积水潭用
Property FirstDelayReason As %String [ SqlColumnNumber = 123 ];

Property FirstDelayReasonNote As %String [ SqlColumnNumber = 124 ];

/// 北大医院用，三日内胸部CT
Property ThreeDayChestCT As %String [ SqlColumnNumber = 125 ];

/// 感染性疾病隔离措施(港大医院)
Property InfectionIsolation As %String [ SqlColumnNumber = 126 ];

/// 多重耐药菌隔离措施(港大医院)
Property MRDOSIsolation As %String [ SqlColumnNumber = 127 ];

/// 技师
Property Technician As %String [ SqlColumnNumber = 128 ];

/// 辅助人员
Property Paramedics As %String(MAXLEN = 200) [ SqlColumnNumber = 129 ];

/// 预计手术日期
Property EstimatedOperDate As %Date [ SqlColumnNumber = 130 ];

/// 预计手术时间
Property EstimatedOperTime As %Time [ SqlColumnNumber = 131 ];

/// 日间退出原因
Property DaySurgeryCancelReason As %String [ SqlColumnNumber = 132 ];

/// 日间退出原因备注
Property DaySurgeryCancelNote As %String [ SqlColumnNumber = 133 ];

/// 北京妇产接生人员
Property Midwife As %String [ SqlColumnNumber = 134 ];

/// 胸水
Property Hydrothorax As %String [ SqlColumnNumber = 135 ];

/// 手术体位备注
Property OperPosNote As %String(MAXLEN = 200) [ SqlColumnNumber = 136 ];

/// 院区ID
Property HospitalId As %String [ SqlColumnNumber = 137 ];

/// 术后入ICU
Property PostoperativeToICU As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 138 ];

/// 按就诊ID索引
Index Adm On EpisodeID;

/// 按申请日期索引
Index AppDate On AppDate;

/// 按手术日期索引
Index OPDate On OperDate;

/// 按申请科室和手术日期索引
Index AppDeptDate On (AppDeptID, OperDate);

/// 按手术室和手术日期索引
Index OperDeptDate On (OperDeptID, OperDate);

/// 外部系统ID索引
Index Ext On ExternalID;

/// 外部系统麻醉ID索引
Index ExtAna On ExtAnaestID;

/// 原手术申请索引
Index Original On OriginalSchedule;

/// 登记号索引
Index IRegNo On RegNo;

/// 住院号索引
Index IMedicareNo On MedicareNo;

/// 日间手术索引
Index IDaySurgery On DaySurgery;

/// 医嘱ID索引
Index IOrderItem On AppOrderItem;

/// 手术就诊类型索引
Index IOPAdmType On OPAdmType;

/// 申请类型索引
Index IAppType On AppType;

/// 日间索引
Index DateDaySurgery On (OperDate As Exact, DaySurgery As Exact);

Trigger AfterInsert [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
    set id = {RowId}
    do ..OnUpdate(id)
}

Trigger AfterUpdate [ Event = UPDATE, Foreach = row/object, Time = AFTER ]
{
    set id = {RowId}
    do ..OnUpdate(id)
}

Trigger AfterDelete [ Event = DELETE, Foreach = row/object, Time = AFTER ]
{
    set id = {RowId}
    do ..OnDelete(id)
}

ClassMethod OnDelete(id)
{
	do ..OnUpdate(id)
}

ClassMethod OnUpdate(id)
{
	try
    {
    	set ^DHCANOPTriggerCache("OperSchedule",id)=$ZTIMESTAMP
    }
    catch(sc)
    {
	    set ^DHCANOPOperListCacheError("OperSchedule",+$h,$p($h,",",2))=sc.Name_"@"_sc.Code_"@"_sc.Location_"@"_sc.Data
    }
}

Storage Default
{
<Data name="OperScheduleDefaultData">
<Value name="1">
<Value>EpisodeID</Value>
</Value>
<Value name="2">
<Value>ExternalID</Value>
</Value>
<Value name="3">
<Value>AppDeptID</Value>
</Value>
<Value name="4">
<Value>OperDeptID</Value>
</Value>
<Value name="5">
<Value>OperExecDeptID</Value>
</Value>
<Value name="6">
<Value>PatDeptID</Value>
</Value>
<Value name="7">
<Value>PatWardID</Value>
</Value>
<Value name="8">
<Value>PatBedID</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>PrevDiagnosis</Value>
</Value>
<Value name="11">
<Value>PrevAnaMethod</Value>
</Value>
<Value name="12">
<Value>AppDate</Value>
</Value>
<Value name="13">
<Value>AppTime</Value>
</Value>
<Value name="14">
<Value>OperDate</Value>
</Value>
<Value name="15">
<Value>OperTime</Value>
</Value>
<Value name="16">
<Value>AppUserID</Value>
</Value>
<Value name="17">
<Value>AppCareProvID</Value>
</Value>
<Value name="18">
<Value>SourceType</Value>
</Value>
<Value name="19">
<Value>Anaesthesia</Value>
</Value>
<Value name="20">
<Value>ReentryOperation</Value>
</Value>
<Value name="21">
<Value>IsoOperation</Value>
</Value>
<Value name="22">
<Value>ECC</Value>
</Value>
<Value name="23">
<Value>TransAutoblood</Value>
</Value>
<Value name="24">
<Value>PrepareBlood</Value>
</Value>
<Value name="25">
<Value>BloodType</Value>
</Value>
<Value name="26">
<Value>RHBloodType</Value>
</Value>
<Value name="27">
<Value>HbsAg</Value>
</Value>
<Value name="28">
<Value>HcvAb</Value>
</Value>
<Value name="29">
<Value>HivAb</Value>
</Value>
<Value name="30">
<Value>Syphilis</Value>
</Value>
<Value name="31">
<Value>OperRequirement</Value>
</Value>
<Value name="32">
<Value>LabTest</Value>
</Value>
<Value name="33">
<Value>PatName</Value>
</Value>
<Value name="34">
<Value>PatGender</Value>
</Value>
<Value name="35">
<Value>PatDOB</Value>
</Value>
<Value name="36">
<Value>PatWeight</Value>
</Value>
<Value name="37">
<Value>PatHeight</Value>
</Value>
<Value name="38">
<Value>OperDuration</Value>
</Value>
<Value name="39">
<Value>SurgicalMaterials</Value>
</Value>
<Value name="40">
<Value>SpecialConditions</Value>
</Value>
<Value name="41">
<Value>PlanSeq</Value>
</Value>
<Value name="42">
<Value>AppOrderItem</Value>
</Value>
<Value name="43">
<Value>ExtAnaestID</Value>
</Value>
<Value name="44">
<Value>OperPosition</Value>
</Value>
<Value name="45">
<Value>ExpertFlag</Value>
</Value>
<Value name="46">
<Value>OriginalSchedule</Value>
</Value>
<Value name="47">
<Value>SeqType</Value>
</Value>
<Value name="48">
<Value>HighConsume</Value>
</Value>
<Value name="49">
<Value>Antibiosis</Value>
</Value>
<Value name="50">
<Value>InfectionOper</Value>
</Value>
<Value name="51">
<Value>MIS</Value>
</Value>
<Value name="52">
<Value>BodySite</Value>
</Value>
<Value name="53">
<Value>SurIntership</Value>
</Value>
<Value name="54">
<Value>SurVisitors</Value>
</Value>
<Value name="55">
<Value>OperRoom</Value>
</Value>
<Value name="56">
<Value>OperSeq</Value>
</Value>
<Value name="57">
<Value>ScrubNurse</Value>
</Value>
<Value name="58">
<Value>CircualNurse</Value>
</Value>
<Value name="59">
<Value>RegNo</Value>
</Value>
<Value name="60">
<Value>MedicareNo</Value>
</Value>
<Value name="61">
<Value>DaySurgery</Value>
</Value>
<Value name="62">
<Value>RevokeFlag</Value>
</Value>
<Value name="63">
<Value>PostDiagnosis</Value>
</Value>
<Value name="64">
<Value>BladeType</Value>
</Value>
<Value name="65">
<Value>AnaDept</Value>
</Value>
<Value name="66">
<Value>CardID</Value>
</Value>
<Value name="67">
<Value>AdmReason</Value>
</Value>
<Value name="68">
<Value>AdmDate</Value>
</Value>
<Value name="69">
<Value>ArrOperRoom</Value>
</Value>
<Value name="70">
<Value>ArrOperSeq</Value>
</Value>
<Value name="71">
<Value>ArrScrubNurse</Value>
</Value>
<Value name="72">
<Value>ArrCircualNurse</Value>
</Value>
<Value name="73">
<Value>MDROS</Value>
</Value>
<Value name="74">
<Value>OPAdmType</Value>
</Value>
<Value name="75">
<Value>ComeHosTime</Value>
</Value>
<Value name="76">
<Value>PatPhoneNumber</Value>
</Value>
<Value name="77">
<Value>PatNeedNotice</Value>
</Value>
<Value name="78">
<Value>PACUBed</Value>
</Value>
<Value name="79">
<Value>OPFeeFlag</Value>
</Value>
<Value name="80">
<Value>ANFeeFlag</Value>
</Value>
<Value name="81">
<Value>PACUOutSteward</Value>
</Value>
<Value name="82">
<Value>TeamLeader</Value>
</Value>
<Value name="83">
<Value>OperStaff</Value>
</Value>
<Value name="84">
<Value>AppType</Value>
</Value>
<Value name="85">
<Value>AppDocPhoneNo</Value>
</Value>
<Value name="86">
<Value>DrugAllergy</Value>
</Value>
<Value name="87">
<Value>DrugAllergyNote</Value>
</Value>
<Value name="88">
<Value>ArrOperTime</Value>
</Value>
<Value name="89">
<Value>CancelReason</Value>
</Value>
<Value name="90">
<Value>CancelUser</Value>
</Value>
<Value name="91">
<Value>CancelTime</Value>
</Value>
<Value name="92">
<Value>ArrPrintFlag</Value>
</Value>
<Value name="93">
<Value>ScrubAssistant</Value>
</Value>
<Value name="94">
<Value>CircualAssistant</Value>
</Value>
<Value name="95">
<Value>DocRegisterUser</Value>
</Value>
<Value name="96">
<Value>DocRegisterDate</Value>
</Value>
<Value name="97">
<Value>DocRegisterTime</Value>
</Value>
<Value name="98">
<Value>OperPeriod</Value>
</Value>
<Value name="99">
<Value>PatLMP</Value>
</Value>
<Value name="100">
<Value>UnPlanSecOper</Value>
</Value>
<Value name="101">
<Value>SurgicalKit</Value>
</Value>
<Value name="102">
<Value>SELicenseCode</Value>
</Value>
<Value name="103">
<Value>DaySurgeryNote</Value>
</Value>
<Value name="104">
<Value>Robot</Value>
</Value>
<Value name="105">
<Value>Navigation</Value>
</Value>
<Value name="106">
<Value>AddInstruments</Value>
</Value>
<Value name="107">
<Value>AgentName</Value>
</Value>
<Value name="108">
<Value>AgentMobNo</Value>
</Value>
<Value name="109">
<Value>SurgeonMobNo</Value>
</Value>
<Value name="110">
<Value>AssitMobNo</Value>
</Value>
<Value name="111">
<Value>KeepSpecimen</Value>
</Value>
<Value name="112">
<Value>COVIDNATest</Value>
</Value>
<Value name="113">
<Value>OperScope</Value>
</Value>
<Value name="114">
<Value>LocPlanSeqNo</Value>
</Value>
<Value name="115">
<Value>StatCategory</Value>
</Value>
<Value name="116">
<Value>StatSeq</Value>
</Value>
<Value name="117">
<Value>SiteDepth</Value>
</Value>
<Value name="118">
<Value>Endoscopy</Value>
</Value>
<Value name="119">
<Value>FamilyPlanning</Value>
</Value>
<Value name="120">
<Value>Profrozen</Value>
</Value>
<Value name="121">
<Value>MechanicalArm</Value>
</Value>
<Value name="122">
<Value>FirstDelayReason</Value>
</Value>
<Value name="123">
<Value>FirstDelayReasonNote</Value>
</Value>
<Value name="124">
<Value>ThreeDayChestCT</Value>
</Value>
<Value name="125">
<Value>InfectionIsolation</Value>
</Value>
<Value name="126">
<Value>MRDOSIsolation</Value>
</Value>
<Value name="127">
<Value>Technician</Value>
</Value>
<Value name="128">
<Value>Paramedics</Value>
</Value>
<Value name="129">
<Value>EstimatedOperDate</Value>
</Value>
<Value name="130">
<Value>EstimatedOperTime</Value>
</Value>
<Value name="131">
<Value>DaySurgeryCancelReason</Value>
</Value>
<Value name="132">
<Value>DaySurgeryCancelNote</Value>
</Value>
<Value name="133">
<Value>Midwife</Value>
</Value>
<Value name="134">
<Value>Hydrothorax</Value>
</Value>
<Value name="135">
<Value>OperPosNote</Value>
</Value>
<Value name="136">
<Value>HospitalId</Value>
</Value>
<Value name="137">
<Value>PostoperativeToICU</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperScheduleD</DataLocation>
<DefaultData>OperScheduleDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperScheduleD</IdLocation>
<IndexLocation>^CIS.AN.OperScheduleI</IndexLocation>
<StreamLocation>^CIS.AN.OperScheduleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

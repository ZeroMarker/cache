/// 手术申请计划表
Class CIS.AN.OperCatalogue Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperCatalogue ]
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

/// 病人所在科室ID
Property PatDeptID As %String [ SqlColumnNumber = 7 ];

/// 病人所在病区ID
Property PatWardID As %String [ SqlColumnNumber = 8 ];

/// 病人所在床位ID
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

/// 多重耐药菌
Property MDROS As %String [ SqlColumnNumber = 32 ];

/// 麻醉科室ID
Property AnaDeptID As %String [ SqlColumnNumber = 33 ];

/// 手术要求
Property OperRequirement As %String(MAXLEN = 200) [ SqlColumnNumber = 34 ];

/// 检验信息
Property LabTest As %String(MAXLEN = 200) [ SqlColumnNumber = 35 ];

/// 手术用时
Property OperDuration As %Float [ SqlColumnNumber = 36 ];

/// 手术物品
Property SurgicalMaterials As %String(MAXLEN = 200) [ SqlColumnNumber = 37 ];

/// 特殊情况
Property SpecialConditions As %String(MAXLEN = 200) [ SqlColumnNumber = 38 ];

/// 高值耗材
Property HighConsume As %String(MAXLEN = 500) [ SqlColumnNumber = 39 ];

/// 是否使用抗生素
Property Antibiosis As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 40 ];

/// 感染手术
Property InfectionOper As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 41 ];

/// 是否微创手术
Property MIS As %String [ SqlColumnNumber = 42 ];

/// 手术申请医嘱ID
Property AppOrderItem As %String [ SqlColumnNumber = 43 ];

/// 外部系统麻醉ID
Property ExtAnaestID As %String [ SqlColumnNumber = 44 ];

/// 手术体位
Property OperPosition As %String [ SqlColumnNumber = 45 ];

/// 手术部位
Property BodySite As %String [ SqlColumnNumber = 46 ];

/// 手术切口
Property BladeType As %String [ SqlColumnNumber = 47 ];

/// 手术台次类型
Property SeqType As %String(DISPLAYLIST = ",正常台,接台", VALUELIST = ",N,C") [ SqlColumnNumber = 48 ];

/// 正在安排的手术间
Property ArrOperRoom As CF.AN.Location [ SqlColumnNumber = 49 ];

/// 正在安排的台次
Property ArrOperSeq As %String [ SqlColumnNumber = 50 ];

/// 正在安排的器械护士
Property ArrScrubNurse As %String [ SqlColumnNumber = 51 ];

/// 正在安排的巡回护士
Property ArrCircualNurse As %String [ SqlColumnNumber = 52 ];

/// 手术间
Property OperRoom As CF.AN.Location [ SqlColumnNumber = 53 ];

/// 手术台次
Property OperSeq As %String [ SqlColumnNumber = 54 ];

/// 器械护士
Property ScrubNurse As %String [ SqlColumnNumber = 55 ];

/// 巡回护士
Property CircualNurse As %String [ SqlColumnNumber = 56 ];

/// 日间手术标志
Property DaySurgery As %String(DISPLAYLIST = ",是,否", MAXLEN = 4, VALUELIST = ",Y,N") [ SqlColumnNumber = 57 ];

/// 患者姓名
Property PatName As %String [ SqlColumnNumber = 58 ];

/// 患者登记号
Property RegNo As %String [ SqlColumnNumber = 59 ];

/// 患者住院号
Property MedicareNo As %String [ SqlColumnNumber = 60 ];

/// 患者身份证号
Property CardID As %String [ SqlColumnNumber = 61 ];

/// 患者性别
Property PatGender As %String [ SqlColumnNumber = 62 ];

/// 患者出生日期
Property PatDOB As %Date [ SqlColumnNumber = 63 ];

/// 患者体重
Property PatWeight As %String [ SqlColumnNumber = 64 ];

/// 患者身高
Property PatHeight As %String [ SqlColumnNumber = 65 ];

/// 实习进修人员
Property SurIntership As %String [ SqlColumnNumber = 66 ];

/// 手术参观人员
Property SurVisitors As %String [ SqlColumnNumber = 67 ];

/// 撤回标志
Property RevokeFlag As %String(DISPLAYLIST = ",是,否", MAXLEN = 4, VALUELIST = ",Y,N") [ SqlColumnNumber = 68 ];

/// 术后诊断
Property PostDiagnosis As %String(MAXLEN = 200) [ SqlColumnNumber = 69 ];

/// 费别
Property AdmReason As %String [ SqlColumnNumber = 70 ];

/// 就诊日期
Property AdmDate As %Date [ SqlColumnNumber = 71 ];

/// 手术就诊类型
Property OPAdmType As %String(DISPLAYLIST = ",门诊手术,住院手术,科内手术", VALUELIST = ",OOP,IOP,DOP") [ SqlColumnNumber = 72 ];

/// 恢复床
Property PACUBed As CF.AN.Location [ SqlColumnNumber = 73 ];

/// 手术费用审核标志
Property OPFeeFlag As %String(DISPLAYLIST = ",已审核,待审核", VALUELIST = ",Y,N") [ SqlColumnNumber = 74 ];

/// 麻醉费用审核标志
Property ANFeeFlag As %String(DISPLAYLIST = ",已审核,待审核", VALUELIST = ",Y,N") [ SqlColumnNumber = 75 ];

/// PACU出室Steward评分
Property PACUOutSteward As %String [ SqlColumnNumber = 76 ];

/// 申请类型
Property AppType As %String(DISPLAYLIST = ",手术申请,麻醉申请,科内手术", VALUELIST = ",OP,AN,DOP") [ SqlColumnNumber = 77 ];

/// 药物过敏
Property DrugAllergy As %String(DISPLAYLIST = ",无,有", VALUELIST = ",N,Y") [ SqlColumnNumber = 78 ];

/// 药物过敏说明
Property DrugAllergyNote As %String(MAXLEN = 500) [ SqlColumnNumber = 79 ];

/// 手术取消原因
Property CancelReason As %String(MAXLEN = 500) [ SqlColumnNumber = 80 ];

/// 手术取消操作人
Property CancelUser As %String [ SqlColumnNumber = 81 ];

/// 手术取消操作时间
Property CancelTime As %TimeStamp [ SqlColumnNumber = 82 ];

/// 器械助手
Property ScrubAssistant As %String [ SqlColumnNumber = 83 ];

/// 巡回助手
Property CircualAssistant As %String [ SqlColumnNumber = 84 ];

/// 术后登记医生
Property DocRegisterUser As %String [ SqlColumnNumber = 85 ];

/// 术后登记日期
Property DocRegisterDate As %Date [ SqlColumnNumber = 86 ];

/// 术后登记时间
Property DocRegisterTime As %Time [ SqlColumnNumber = 87 ];

/// 日间手术备注
Property DaySurgeryNote As %String(MAXLEN = 200) [ SqlColumnNumber = 88 ];

/// 是否补充器械
Property AddInstruments As %String [ SqlColumnNumber = 89 ];

/// 保留标本
Property KeepSpecimen As %String [ SqlColumnNumber = 90 ];

/// 新型冠状病毒肺炎核酸检测
Property COVIDNATest As %String [ SqlColumnNumber = 91 ];

/// 是否冰冻
Property Profrozen As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 92 ];

/// 技师
Property Technician As %String [ SqlColumnNumber = 93 ];

/// 日间退出原因
Property DaySurgeryCancelReason As %String [ SqlColumnNumber = 94 ];

/// 日间退出原因备注
Property DaySurgeryCancelNote As %String [ SqlColumnNumber = 95 ];

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

Storage Default
{
<Data name="OperCatalogueDefaultData">
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
<Value>MDROS</Value>
</Value>
<Value name="32">
<Value>AnaDeptID</Value>
</Value>
<Value name="33">
<Value>OperRequirement</Value>
</Value>
<Value name="34">
<Value>LabTest</Value>
</Value>
<Value name="35">
<Value>OperDuration</Value>
</Value>
<Value name="36">
<Value>SurgicalMaterials</Value>
</Value>
<Value name="37">
<Value>SpecialConditions</Value>
</Value>
<Value name="38">
<Value>HighConsume</Value>
</Value>
<Value name="39">
<Value>Antibiosis</Value>
</Value>
<Value name="40">
<Value>InfectionOper</Value>
</Value>
<Value name="41">
<Value>MIS</Value>
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
<Value>BodySite</Value>
</Value>
<Value name="46">
<Value>BladeType</Value>
</Value>
<Value name="47">
<Value>SeqType</Value>
</Value>
<Value name="48">
<Value>ArrOperRoom</Value>
</Value>
<Value name="49">
<Value>ArrOperSeq</Value>
</Value>
<Value name="50">
<Value>ArrScrubNurse</Value>
</Value>
<Value name="51">
<Value>ArrCircualNurse</Value>
</Value>
<Value name="52">
<Value>OperRoom</Value>
</Value>
<Value name="53">
<Value>OperSeq</Value>
</Value>
<Value name="54">
<Value>ScrubNurse</Value>
</Value>
<Value name="55">
<Value>CircualNurse</Value>
</Value>
<Value name="56">
<Value>DaySurgery</Value>
</Value>
<Value name="57">
<Value>PatName</Value>
</Value>
<Value name="58">
<Value>RegNo</Value>
</Value>
<Value name="59">
<Value>MedicareNo</Value>
</Value>
<Value name="60">
<Value>CardID</Value>
</Value>
<Value name="61">
<Value>PatGender</Value>
</Value>
<Value name="62">
<Value>PatDOB</Value>
</Value>
<Value name="63">
<Value>PatWeight</Value>
</Value>
<Value name="64">
<Value>PatHeight</Value>
</Value>
<Value name="65">
<Value>SurIntership</Value>
</Value>
<Value name="66">
<Value>SurVisitors</Value>
</Value>
<Value name="67">
<Value>RevokeFlag</Value>
</Value>
<Value name="68">
<Value>PostDiagnosis</Value>
</Value>
<Value name="69">
<Value>AdmReason</Value>
</Value>
<Value name="70">
<Value>AdmDate</Value>
</Value>
<Value name="71">
<Value>OPAdmType</Value>
</Value>
<Value name="72">
<Value>PACUBed</Value>
</Value>
<Value name="73">
<Value>OPFeeFlag</Value>
</Value>
<Value name="74">
<Value>ANFeeFlag</Value>
</Value>
<Value name="75">
<Value>PACUOutSteward</Value>
</Value>
<Value name="76">
<Value>AppType</Value>
</Value>
<Value name="77">
<Value>DrugAllergy</Value>
</Value>
<Value name="78">
<Value>DrugAllergyNote</Value>
</Value>
<Value name="79">
<Value>CancelReason</Value>
</Value>
<Value name="80">
<Value>CancelUser</Value>
</Value>
<Value name="81">
<Value>CancelTime</Value>
</Value>
<Value name="82">
<Value>ScrubAssistant</Value>
</Value>
<Value name="83">
<Value>CircualAssistant</Value>
</Value>
<Value name="84">
<Value>DocRegisterUser</Value>
</Value>
<Value name="85">
<Value>DocRegisterDate</Value>
</Value>
<Value name="86">
<Value>DocRegisterTime</Value>
</Value>
<Value name="87">
<Value>DaySurgeryNote</Value>
</Value>
<Value name="88">
<Value>AddInstruments</Value>
</Value>
<Value name="89">
<Value>KeepSpecimen</Value>
</Value>
<Value name="90">
<Value>COVIDNATest</Value>
</Value>
<Value name="91">
<Value>Profrozen</Value>
</Value>
<Value name="92">
<Value>Technician</Value>
</Value>
<Value name="93">
<Value>DaySurgeryCancelReason</Value>
</Value>
<Value name="94">
<Value>DaySurgeryCancelNote</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperCatalogueD</DataLocation>
<DefaultData>OperCatalogueDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperCatalogueD</IdLocation>
<IndexLocation>^CIS.AN.OperCatalogueI</IndexLocation>
<StreamLocation>^CIS.AN.OperCatalogueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

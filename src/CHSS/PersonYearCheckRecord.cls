Class CHSS.PersonYearCheckRecord Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = YearCheckRowId, SqlTableName = PersonYearCheckRecord ]
{

Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ Required ];

/// 随访日期
Property DateCheck As %Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DateCheck ];

/// 随访地点
Property CheckAdd As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CheckAdd ];

/// 随访医生
Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CheckDoctor ];

/// 症状
Property Symptom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体温
Property Temperature As %Float [ SqlColumnNumber = 5, SqlFieldName = Temperature ];

/// 脉搏
Property Pulse As %Integer [ SqlColumnNumber = 6, SqlFieldName = Pulse ];

/// 收缩压
Property nHighPressure As %Integer [ SqlColumnNumber = 7, SqlFieldName = nHighPressure ];

/// 舒张压
Property nLowPressure As %Integer [ SqlColumnNumber = 8, SqlFieldName = nLowPressure ];

/// 体重
Property Weight As %Float [ SqlColumnNumber = 9, SqlFieldName = Weight ];

/// 身高
Property Height As %Float [ SqlColumnNumber = 10, SqlFieldName = Height ];

/// BMI(自动计算)
Property BMI As %Float [ SqlColumnNumber = 11, SqlFieldName = BMI ];

/// 臀围
Property Saddle As %Float;

/// 腰围
Property Waist As %Float;

/// 呼吸频率
Property Breath As %Integer;

/// 齿列类表
Property Dentition As CHSS.DictDentition;

/// 咽部检查结果
Property PharyngealCheck As CHSS.DictPharyngeal [ SqlColumnNumber = 71, SqlFieldName = PharyngealCheck ];

/// 腰围/臀围
Property WaistlineStern As %Float [ SqlColumnNumber = 12, SqlFieldName = WaistlineStern ];

/// 老年人认知功能
Property OlderCongnize As CHSS.DictCognitiveAbility [ SqlColumnNumber = 13, SqlFieldName = OlderCongnize ];

/// 认知分数
Property OlderCongnizeScore As %String(MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = OlderCongnizeScore ];

/// 老年人情感状态
Property OlderSensibility As CHSS.DictAffectiveState [ SqlColumnNumber = 15, SqlFieldName = OlderSensibility ];

/// 情感状态分数
Property OlderSensibilityScore As %String(MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OlderSensibilityScore ];

/// 生活质量
Property LiveQuality As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = LiveQuality ];

/// 左眼视力
Property LeftEyesight As %Float [ SqlColumnNumber = 18, SqlFieldName = LeftEyesight ];

/// 右眼视力
Property RightEyesight As %Float [ SqlColumnNumber = 19, SqlFieldName = RightEyesight ];

/// 纠正左眼视力  
Property LeftCorrectEyesight As %Float [ SqlColumnNumber = 20, SqlFieldName = LeftCorrectEyesight ];

/// 纠正右眼视力
Property RightCorrectEyesight As %Float [ SqlColumnNumber = 21, SqlFieldName = RightCorrectEyesight ];

/// 听力
Property Hearing As CHSS.DictHearing [ SqlColumnNumber = 22, SqlFieldName = Hearing ];

/// 运动功能
Property Movement As CHSS.DictMotorFunction [ SqlColumnNumber = 23, SqlFieldName = Movement ];

/// 皮肤
Property Skin As CHSS.DictSkin [ SqlColumnNumber = 24, SqlFieldName = Skin ];

/// 淋巴结
Property Scrofula As CHSS.DictLymphNodes;

/// 淋巴结其他
Property ScrofulaOther As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = ScrofulaOther ];

/// 桶状胸
Property bBarrelChest As CHSS.DictBarrelChest [ SqlColumnNumber = 26, SqlFieldName = bBarrelChest ];

/// 呼吸音
Property BreathSounds As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = BreathSounds ];

/// 呼吸音异常
Property BreathSoundsInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = BreathSoundsInfo ];

/// 啰音
Property Rale As CHSS.DictRale [ SqlColumnNumber = 29, SqlFieldName = Rale ];

/// 啰音异常
Property RaleInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = RaleInfo ];

/// 心率
Property HeartRate As %Numeric [ SqlColumnNumber = 31, SqlFieldName = HeartRate ];

/// 心律
Property CardiacRhythm As CHSS.DictCardiacRhythm [ SqlColumnNumber = 32, SqlFieldName = CardiacRhythm ];

/// 杂音
Property Souffle As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = Souffle ];

/// 杂音异常  
Property SouffleInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = SouffleInfo ];

/// 压痛
Property Tenderness As %String(TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = Tenderness ];

/// 压痛情况
Property TendernessInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = TendernessInfo ];

/// 包块
Property EnclosedMass As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = EnclosedMass ];

/// 包块情况
Property EnclosedMassInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = EnclosedMassInfo ];

/// 肝大
Property Hepatauxe As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = Hepatauxe ];

/// 肝大情况
Property HepatauxeInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = HepatauxeInfo ];

/// 脾大
Property Splenomegaly As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = Splenomegaly ];

/// 脾大情况
Property SplenomegalyInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = SplenomegalyInfo ];

/// 移动性浊音
Property ShiftingDullness As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = ShiftingDullness ];

/// 移动性浊音情况
Property ShiftingDullnessInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = ShiftingDullnessInfo ];

/// 下肢水肿
Property EdemaOfLimbs As CHSS.DictLowerExtremityEdema [ SqlColumnNumber = 45, SqlFieldName = EdemaOfLimbs ];

/// 肛门
Property Anus As CHSS.DictAnus [ SqlColumnNumber = 46, SqlFieldName = Anus ];

/// 肛门其他
Property AnusOther As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = AnusOther ];

/// 前列腺
Property Prostate As CHSS.DictProstate [ SqlColumnNumber = 48, SqlFieldName = Prostate ];

/// 前列腺情况
Property ProstateInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = ProstateInfo ];

/// 下次预约日期
Property BookingDate As %Date(FORMAT = 1) [ SqlColumnNumber = 50, SqlFieldName = BookingDate ];

/// 是否下次预约 
Property bBooking As %SmallInt [ SqlColumnNumber = 51, SqlFieldName = bBooking ];

/// 空腹血糖
Property BloodSurgeLimosis As %Integer [ SqlColumnNumber = 52, SqlFieldName = BloodSurgeLimosis ];

/// 总胆固醇
Property Cholesterin As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = Cholesterin ];

/// 心里调整
Property MentalityAdjust As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = MentalityAdjust ];

/// 此次随访结果
Property CheckResult As %SmallInt [ SqlColumnNumber = 55, SqlFieldName = CheckResult ];

/// 处理
Property Deal As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = Deal ];

/// 其他
Property Other As %String(MAXLEN = 100, TRUNCATE = 1);

//Property StaffInput As User.SSUser [ SqlColumnNumber = 57, SqlFieldName = StaffInput ];

/// 妇科检查--add by hwb
/// 乳腺
Property Galactophore As %String(MAXLEN = 100, TRUNCATE = 1);

/// 外阴
Property VaginaInflammation As CHSS.DictWomenCheck [ SqlColumnNumber = 59, SqlFieldName = VaginaInflammation ];

/// 外阴异常情况
Property VaginaInflammationDes As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 60, SqlFieldName = VaginaInflammationDes ];

/// 宫颈
Property Cervicitis As CHSS.DictWomenCheck [ SqlColumnNumber = 61, SqlFieldName = Cervicitis ];

/// 宫颈异常情况
Property CervicitisDes As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 62, SqlFieldName = CervicitisDes ];

/// 阴道
Property DoubleWombs As CHSS.DictWomenCheck [ SqlColumnNumber = 63, SqlFieldName = DoubleWombs ];

/// 阴道异常情况
Property DoubleWombsDes As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 64, SqlFieldName = DoubleWombsDes ];

/// 宫体
Property UterineFibroids As CHSS.DictWomenCheck [ SqlColumnNumber = 65, SqlFieldName = UterineFibroids ];

/// 宫体异常情况
Property UterineFibroidsDes As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 66, SqlFieldName = UterineFibroidsDes ];

/// 附件
Property AccessaryTumour As CHSS.DictWomenCheck [ SqlColumnNumber = 67, SqlFieldName = AccessaryTumour ];

/// 附件异常情况
Property AccessaryTumourDes As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 68, SqlFieldName = AccessaryTumourDes ];

/// 新增口唇，巩膜
/// 口唇
Property OralLips As CHSS.DictOralLips [ SqlColumnNumber = 69, SqlFieldName = OralLips ];

/// 巩膜
Property Sclera As CHSS.DictSclera [ SqlColumnNumber = 70, SqlFieldName = Sclera ];

/// 录入人员
Index PersonRowIdParrefIndex On PersonRowIdParref;

/// 是否打印
Property IsPrint As %String(MAXLEN = 30, TRUNCATE = 1);

/// 疾病史
Property DiseaseHistory As %String(MAXLEN = 50, TRUNCATE = 1);

/// 其他疾病史
Property DiseaseHistoryOther As %String(MAXLEN = 100, TRUNCATE = 1);

/// 流行病学资料
Property EpidemiologyData As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术
Property Operation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 近1年外出史
Property LatestYearOut As CHSS.DictHaveOrNo;

/// 外出地点
Property LatestYearOutPlace As %String(MAXLEN = 100, TRUNCATE = 1);

/// 滞留时间约?日
Property ResortDays As %String(MAXLEN = 100, TRUNCATE = 1);

/// 持续时间     
Property Feverhours As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发热原因 
Property FeverReason As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否收集生物标本收集
Property BiologyExemplar As CHSS.DictYesOrNo;

/// 收集标准
Property CollectStandard As CHSS.DictCollectStandard;

/// 血浆
Property PlasmaExemplar As CHSS.DictYesOrNo;

/// DNA
Property DNAExemplar As CHSS.DictYesOrNo;

/// 检查医院
Property CheckHospital As %String(MAXLEN = 100, TRUNCATE = 1);

/// 录入日期
Property FillDate As %Date;

/// 录入日期
Property FillTime As %Time;

/// 调查员
Property Doctor1 As %String(MAXLEN = 60, TRUNCATE = 1);

/// 复核员
Property Doctor2 As %String(MAXLEN = 60, TRUNCATE = 1);

/// 检查医师	
Property Doctor3 As %String(MAXLEN = 60, TRUNCATE = 1);

/// 检查医师
Property Doctor4 As %String(MAXLEN = 60, TRUNCATE = 1);

/// 检查医师
Property Doctor5 As %String(MAXLEN = 60, TRUNCATE = 1);

/// 复核人员
Property Doctor6 As %String(MAXLEN = 60, TRUNCATE = 1);

/// 录入机构
Property CommunityCode As %String(MAXLEN = 60, TRUNCATE = 1);

/// 标记是否为系统插入的空记录   NULL 为系统插入的 空记录
Property Mark As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlFieldName = Mark ];

/// 标记是否是Excel导入
Property Excel As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlFieldName = Excel ];

Index PersonRowIdkIndex On PersonRowIdParref;

Index PersonRowIdFillDateIndex On FillDate;

Index PersonRowIdMarkIndex On (PersonRowIdParref, Mark);

Index PersonRowIdDateCheckIndex On (PersonRowIdParref, DateCheck);

Index CommunityCodeDateCheckIndex On (CommunityCode, DateCheck);

//插入之后 往ReportCommunityPYCCount 里插入数据

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
    Set YearCheckRowId = {YearCheckRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateCheck = {DateCheck}  
    Set FillDate = {FillDate}   
    Set Mark = {Mark}
    i Mark="NOTNULL" d
    .d ##class(CHSSWeb.ReportOfTrigger).PYCInsert(YearCheckRowId,CommunityCode,DateCheck,FillDate)
    q
}

//修改之前 往ReportCommunityPYCCount 里更新数据

Trigger BeforeUpdate [ Event = UPDATE ]
{
    Set YearCheckRowId = {YearCheckRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateCheck = {DateCheck}  
    Set FillDate = {FillDate}  
     Set Mark = {Mark}
    i Mark="NOTNULL" d
    .d ##class(CHSSWeb.ReportOfTrigger).PYCUpdate(YearCheckRowId,CommunityCode,DateCheck,FillDate)
  q
}

//删除之前 往ReportCommunityPYCCount 里删除数据

Trigger BeforeDelete [ Event = DELETE ]
{
  
    Set YearCheckRowId = {YearCheckRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateCheck = {DateCheck}  
    Set FillDate = {FillDate}  
     Set Mark = {Mark}
    i Mark="NOTNULL" d
    .d ##class(CHSSWeb.ReportOfTrigger).PYCDelete(YearCheckRowId,CommunityCode,DateCheck,FillDate)
    q
}

Method %OnBeforeSave(insert As %Boolean) As %Status
{
	s $zt="Error"
 
	i insert'=1 d
    .Set YearCheckRowId = %this.%Id()  
    .Set CommunityCode = %this.CommunityCode
    .Set DateCheck = %this.DateCheck
    .Set FillDate = %this.FillDate
    .Set Mark = %this.Mark
    .i Mark="NOTNULL" d
    ..d ##class(CHSSWeb.ReportOfTrigger).PYCUpdate(YearCheckRowId,CommunityCode,DateCheck,FillDate)
   	Quit $$$OK
Error
	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error" 
	i insert=1 d 
	.Set YearCheckRowId = %this.%Id()   
    .Set CommunityCode = %this.CommunityCode
    .Set DateCheck = %this.DateCheck
    .Set FillDate = %this.FillDate
    .Set Mark = %this.Mark
    .i Mark="NOTNULL" d
    ..d ##class(CHSSWeb.ReportOfTrigger).PYCInsert(YearCheckRowId,CommunityCode,DateCheck,FillDate)
	Quit $$$OK
Error
 	Quit $$$OK
}

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status
{
	S $zt="Error"
 
	S tmpPYC= ##class(CHSS.FamilyHealthRecord).%Open(oid) 
	Set YearCheckRowId = tmpPYC.%Id()  
    Set CommunityCode = %this.CommunityCode
    Set DateCheck = %this.DateCheck
    Set FillDate = %this.FillDate  
    Set Mark = %this.Mark
    i Mark="NOTNULL"  d
    .d ##class(CHSSWeb.ReportOfTrigger).PYCDelete(YearCheckRowId,CommunityCode,DateCheck,FillDate)
	Quit $$$OK
Error
 	Quit $$$OK
}

Storage Default
{
<Data name="PersonYearCheckRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Anus</Value>
</Value>
<Value name="3">
<Value>AnusOther</Value>
</Value>
<Value name="4">
<Value>BMI</Value>
</Value>
<Value name="5">
<Value>BloodSurgeLimosis</Value>
</Value>
<Value name="6">
<Value>BookingDate</Value>
</Value>
<Value name="7">
<Value>Breath</Value>
</Value>
<Value name="8">
<Value>BreathSounds</Value>
</Value>
<Value name="9">
<Value>BreathSoundsInfo</Value>
</Value>
<Value name="10">
<Value>CardiacRhythm</Value>
</Value>
<Value name="11">
<Value>CheckAdd</Value>
</Value>
<Value name="12">
<Value>CheckDoctor</Value>
</Value>
<Value name="13">
<Value>CheckResult</Value>
</Value>
<Value name="14">
<Value>Cholesterin</Value>
</Value>
<Value name="15">
<Value>DateCheck</Value>
</Value>
<Value name="16">
<Value>Deal</Value>
</Value>
<Value name="17">
<Value>Dentition</Value>
</Value>
<Value name="18">
<Value>EdemaOfLimbs</Value>
</Value>
<Value name="19">
<Value>EnclosedMass</Value>
</Value>
<Value name="20">
<Value>EnclosedMassInfo</Value>
</Value>
<Value name="21">
<Value>Hearing</Value>
</Value>
<Value name="22">
<Value>HeartRate</Value>
</Value>
<Value name="23">
<Value>Height</Value>
</Value>
<Value name="24">
<Value>Hepatauxe</Value>
</Value>
<Value name="25">
<Value>HepatauxeInfo</Value>
</Value>
<Value name="26">
<Value>LeftCorrectEyesight</Value>
</Value>
<Value name="27">
<Value>LeftEyesight</Value>
</Value>
<Value name="28">
<Value>LiveQuality</Value>
</Value>
<Value name="29">
<Value>MentalityAdjust</Value>
</Value>
<Value name="30">
<Value>Movement</Value>
</Value>
<Value name="31">
<Value>OlderCongnize</Value>
</Value>
<Value name="32">
<Value>OlderCongnizeScore</Value>
</Value>
<Value name="33">
<Value>OlderSensibility</Value>
</Value>
<Value name="34">
<Value>OlderSensibilityScore</Value>
</Value>
<Value name="35">
<Value>Other</Value>
</Value>
<Value name="36">
<Value>PharyngealCheck</Value>
</Value>
<Value name="37">
<Value>Prostate</Value>
</Value>
<Value name="38">
<Value>ProstateInfo</Value>
</Value>
<Value name="39">
<Value>Pulse</Value>
</Value>
<Value name="40">
<Value>Rale</Value>
</Value>
<Value name="41">
<Value>RaleInfo</Value>
</Value>
<Value name="42">
<Value>RightCorrectEyesight</Value>
</Value>
<Value name="43">
<Value>RightEyesight</Value>
</Value>
<Value name="44">
<Value>Saddle</Value>
</Value>
<Value name="45">
<Value>Scrofula</Value>
</Value>
<Value name="46">
<Value>ScrofulaOther</Value>
</Value>
<Value name="47">
<Value>ShiftingDullness</Value>
</Value>
<Value name="48">
<Value>ShiftingDullnessInfo</Value>
</Value>
<Value name="49">
<Value>Skin</Value>
</Value>
<Value name="50">
<Value>Souffle</Value>
</Value>
<Value name="51">
<Value>SouffleInfo</Value>
</Value>
<Value name="52">
<Value>Splenomegaly</Value>
</Value>
<Value name="53">
<Value>SplenomegalyInfo</Value>
</Value>
<Value name="54">
<Value>StaffInput</Value>
</Value>
<Value name="55">
<Value>Temperature</Value>
</Value>
<Value name="56">
<Value>Tenderness</Value>
</Value>
<Value name="57">
<Value>TendernessInfo</Value>
</Value>
<Value name="58">
<Value>Waist</Value>
</Value>
<Value name="59">
<Value>WaistlineStern</Value>
</Value>
<Value name="60">
<Value>Weight</Value>
</Value>
<Value name="61">
<Value>bBarrelChest</Value>
</Value>
<Value name="62">
<Value>bBooking</Value>
</Value>
<Value name="63">
<Value>nHighPressure</Value>
</Value>
<Value name="64">
<Value>nLowPressure</Value>
</Value>
<Value name="65">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="66">
<Value>Symptom</Value>
</Value>
<Value name="67">
<Value>IsPrint</Value>
</Value>
<Value name="68">
<Value>DiseaseHistory</Value>
</Value>
<Value name="69">
<Value>EpidemiologyData</Value>
</Value>
<Value name="70">
<Value>LatestYearOut</Value>
</Value>
<Value name="71">
<Value>Operation</Value>
</Value>
<Value name="72">
<Value>HowDays</Value>
</Value>
<Value name="73">
<Value>LatestYearOutPlace</Value>
</Value>
<Value name="74">
<Value>FeverReason</Value>
</Value>
<Value name="75">
<Value>Feverhours</Value>
</Value>
<Value name="76">
<Value>ResortDays</Value>
</Value>
<Value name="77">
<Value>BiologyExemplar</Value>
</Value>
<Value name="78">
<Value>CollectStandard</Value>
</Value>
<Value name="79">
<Value>DNAExemplar</Value>
</Value>
<Value name="80">
<Value>PlasmaExemplar</Value>
</Value>
<Value name="81">
<Value>CheckHospital</Value>
</Value>
<Value name="82">
<Value>Mark</Value>
</Value>
<Value name="83">
<Value>FillDate</Value>
</Value>
<Value name="84">
<Value>FillTime</Value>
</Value>
<Value name="85">
<Value>DiseaseHistoryOther</Value>
</Value>
<Value name="86">
<Value>Doctor1</Value>
</Value>
<Value name="87">
<Value>Doctor2</Value>
</Value>
<Value name="88">
<Value>Doctor3</Value>
</Value>
<Value name="89">
<Value>Doctor4</Value>
</Value>
<Value name="90">
<Value>Doctor5</Value>
</Value>
<Value name="91">
<Value>Doctor6</Value>
</Value>
<Value name="92">
<Value>CommunityCode</Value>
</Value>
<Value name="93">
<Value>Excel</Value>
</Value>
<Value name="94">
<Value>Galactophore</Value>
</Value>
<Value name="95">
<Value>VaginaInflammation</Value>
</Value>
<Value name="96">
<Value>AccessaryTumour</Value>
</Value>
<Value name="97">
<Value>AccessaryTumourDes</Value>
</Value>
<Value name="98">
<Value>Cervicitis</Value>
</Value>
<Value name="99">
<Value>CervicitisDes</Value>
</Value>
<Value name="100">
<Value>DoubleWombs</Value>
</Value>
<Value name="101">
<Value>DoubleWombsDes</Value>
</Value>
<Value name="102">
<Value>UterineFibroids</Value>
</Value>
<Value name="103">
<Value>UterineFibroidsDes</Value>
</Value>
<Value name="104">
<Value>VaginaInflammationDes</Value>
</Value>
<Value name="105">
<Value>OralLips</Value>
</Value>
<Value name="106">
<Value>Sclera</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonYearCheckRecordD</DataLocation>
<DefaultData>PersonYearCheckRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonYearCheckRecordD</IdLocation>
<IndexLocation>^CHSS.PersonYearCheckRecordI</IndexLocation>
<StreamLocation>^CHSS.PersonYearCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 新型冠状病毒感染的肺炎病例个案调查表 (第三版)
Class DHCMed.EPD.NCPInvestigation Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildSample As DHCMed.EPD.NCPSample [ Cardinality = children, Inverse = Parref ];

/// 问卷编号
Property InvCardNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊号
Property InvEpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 基本信息
Property InvPatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告状态
Property InvStatusDr As DHCMed.SS.Dictionary;

/// 身份证号
Property InvIdentity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 传染病
Property InvReportDr As DHCMed.EPD.Epidemic;

/// 症状和体征
Property InvSymPtomDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最高温度
Property InvTemperature As %Float;

/// 症状和体征其他
Property InvSymPtomExt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有无并发症
Property InvIsComplication As %Boolean;

/// 并发症
Property InvComplication As %String(MAXLEN = 100, TRUNCATE = 1);

/// 并发症其他
Property InvComplicationExt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血常规检查是否检测
Property InvIsBloodTest As %Boolean;

/// 血常规检测时间
Property InvBloodTestDate As %Date;

/// WBC（白细胞数）
Property InvWBC As %Float;

/// L（淋巴细胞数）
Property InvLymphocyte As %Float;

/// L（淋巴细胞百分比） 
Property InvLymphocytePer As %Float;

/// N（中性粒细胞百分比） 
Property InvNePer As %Float;

/// 胸部Ｘ线检测是否有肺炎影像学特征：□未检测 □无 □有
Property InvChestXrayDr As DHCMed.SS.Dictionary;

/// 胸部Ｘ线检测时间
Property InvChestXrayDate As %Date;

/// 胸部CT检测是否有肺炎影像学特征：□未检测 □无 □有
Property InvChestCTDr As DHCMed.SS.Dictionary;

/// 胸部CT线检测时间
Property InvChestctDate As %Date;

/// 发病后是否就诊
Property InvIsMedical As %Boolean;

/// 发病后首次就诊日期
Property InvFirstAdmDate As %Date;

/// 就诊医院名称
Property InvAdmHospital As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否隔离：□否 □是
Property InvIsIsolated As %Boolean;

/// 隔离开始日期
Property InvIsolatedDate As %Date;

/// 是否住院
Property InvIsInHosp As %Boolean;

/// 入院日期
Property InvInHospDate As %Date;

/// 是否收住ICU治疗：□否 □是
Property InvIsInICU As %Boolean;

/// 入住ICU 日期
Property InvInICUDate As %Date;

/// 患者是否是以下特定职业人群: □医务人员 □医院其他工作人员 □病原微生物检测人员 □野生动物接触相关人员 □家禽、家畜养殖人员 □其他
Property InvOccupationDr As DHCMed.SS.Dictionary;

Property InvOccupationExt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 患者是否孕妇
Property InvIsGravida As %Boolean;

/// 既往病史（可多选）：□无 □高血压 □糖尿病 □心脑血管疾病□肺部疾病（如哮喘、肺心病 、肺纤维化、矽肺等）□慢性肾病 □慢性肝病□免疫缺陷类疾病 □其他
Property InvPreAnamnesisDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他既往病史
Property InvPreAnamnesisExt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发病或检测阳性前 14 天内是否有武汉或其他有本地病例持续传播地区的旅行史或居住史：□旅行史 □居住史 □否
Property InvTravelLiveDr As DHCMed.SS.Dictionary;

/// 发病或检测阳性前 14 天内是否接触过有武汉或其他有本地病例持续传播地区有发热或有呼吸道症状的人：□是 □否
Property InvIsContactFever As %Boolean;

/// 发病或检测阳性前 14 天内是否接触过有武汉或其他有本地病例持续传播地区旅行史或居住史的人：□是 □否
Property InvIsContactTrave As %Boolean;

/// 发病或检测阳性前 14 天内是否有确诊病例、轻症病例或无症状感染者的接触史：□是 □否
Property InvIsContactDiag As %Boolean;

/// 发病或检测阳性前 14 天内患者同一家庭、工作单位、托幼机构或学校等集体单位是否有聚集性发病？□是 □否 □不清楚
Property InvGatherDr As DHCMed.SS.Dictionary;

/// 发病或检测阳性前 14 天内是否有医疗机构就诊史：□否 □是
Property InvIsTreatment As %Boolean;

/// 居住地点(村庄/居民楼)周围是否有农贸市场：□是，距离您家大约 米 □否 □不清楚
Property InvMarketDr As DHCMed.SS.Dictionary;

/// 距离农贸市场大约 米
Property InvDistance As %String(MAXLEN = 100, TRUNCATE = 1);

/// 否去过农贸市场：□是 □否 □ 不清楚
Property InvIsMarketDr As DHCMed.SS.Dictionary;

/// 若去过，病例是农贸市场的： □市场从业人员 □供货／进货商 □消费者□其他（含送饭、找人、途经等）
Property InvMarketType As DHCMed.SS.Dictionary;

/// 调查单位
Property InvReportCompany As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告科室 指向CT_Loc
Property InvReportLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 调查人 指向SS_User
Property InvReportUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 调查日期
Property InvReportDate As %Date;

/// 调查时间
Property InvReportTime As %Time;

/// 审核人 指向SS_User
Property InvCheckUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 审核日期
Property InvCheckDate As %Date;

/// 审核时间
Property InvCheckTime As %Time;

/// 以就诊号为索引
Index IndexEpisodeID On InvEpisodeID;

/// 以基本信息为索引
Index IndexPatientID On InvPatientID;

/// 以填写日期为索引
Index IndexReportDate On (InvReportDate, InvReportTime);

/// 以审核日期为索引
Index IndexCheckDate On (InvCheckDate, InvCheckTime);

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description:  根据ID取个案调查表
/// Table：       DHCMed.EPD.NCPInvestigation
/// Input：       aId : DHCMed.EPD.NCPInvestigation.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.NCPInvestigation).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.NCPInvestigation
{
	New (aId)
	Quit:'##class(DHCMed.EPD.NCPInvestigation).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.NCPInvestigation).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description:  更新个案调查表
/// Table：       DHCMed.EPD.NCPInvestigation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.NCPInvestigation).Update("^^67^61^2777^121212199005113422^46^3627,3634,3635^^^0^3649,3653^^0^^^^^^3660^^3660^^1^2020-02-01^234^0^^1^2020-02-13^1^2020-02-14^3664^^1^3670,3674^^3681^0^1^0^3685^1^3686^^3685^^22^95^10209^2020-02-15^^^^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID                = $p(aInputStr,aSeparete,1)
	Set CardNo            = $p(aInputStr,aSeparete,2)
	Set EpisodeID         = $p(aInputStr,aSeparete,3)
	Set PatientID         = $p(aInputStr,aSeparete,4)
	Set StatusDr          = $p(aInputStr,aSeparete,5)
	Set Identity          = $p(aInputStr,aSeparete,6)
	Set ReportDr          = $p(aInputStr,aSeparete,7)
	Set SymPtomDr         = $p(aInputStr,aSeparete,8)
	Set Temperature       = $p(aInputStr,aSeparete,9)
	Set SymPtomExt        = $p(aInputStr,aSeparete,10)
	Set IsComplication    = $p(aInputStr,aSeparete,11)
	Set ComplicationDr    = $p(aInputStr,aSeparete,12)
	Set ComplicationExt   = $p(aInputStr,aSeparete,13)
	Set IsBloodTest       = $p(aInputStr,aSeparete,14)
	Set BloodTestDate     = $p(aInputStr,aSeparete,15)
	Set WBC               = $p(aInputStr,aSeparete,16)
	Set Lymphocyte        = $p(aInputStr,aSeparete,17)
	Set LymphocytePer     = $p(aInputStr,aSeparete,18)
	Set NePer             = $p(aInputStr,aSeparete,19)
	Set ChestXrayDr       = $p(aInputStr,aSeparete,20)
	Set ChestXrayDate     = $p(aInputStr,aSeparete,21)
	Set ChestCTDr         = $p(aInputStr,aSeparete,22)
	Set ChestctDate       = $p(aInputStr,aSeparete,23)
	Set IsMedical         = $p(aInputStr,aSeparete,24)
	Set FirstAdmDate      = $p(aInputStr,aSeparete,25)
	Set AdmHospital       = $p(aInputStr,aSeparete,26)
	Set IsIsolated        = $p(aInputStr,aSeparete,27)
	Set IsolatedDate      = $p(aInputStr,aSeparete,28)
	Set IsInHosp          = $p(aInputStr,aSeparete,29)
	Set InHospDate        = $p(aInputStr,aSeparete,30)
	Set IsInICU           = $p(aInputStr,aSeparete,31)
	Set InICUDate         = $p(aInputStr,aSeparete,32)
	Set OccupationDr      = $p(aInputStr,aSeparete,33)
	Set OccupationExt     = $p(aInputStr,aSeparete,34)
	Set IsGravida         = $p(aInputStr,aSeparete,35)
	Set PreAnamnesisDr    = $p(aInputStr,aSeparete,36)
	Set PreAnamnesisExt   = $p(aInputStr,aSeparete,37)
	Set TravelLiveDr      = $p(aInputStr,aSeparete,38)
	Set IsContactFever    = $p(aInputStr,aSeparete,39)
	Set IsContactTrave    = $p(aInputStr,aSeparete,40)
	Set IsContactDiag     = $p(aInputStr,aSeparete,41)
	Set GatherDr          = $p(aInputStr,aSeparete,42)
	Set IsTreatment       = $p(aInputStr,aSeparete,43)
	Set MarketDr          = $p(aInputStr,aSeparete,44)
	Set Distance          = $p(aInputStr,aSeparete,45)
	Set IsMarketDr        = $p(aInputStr,aSeparete,46)
	Set MarketType        = $p(aInputStr,aSeparete,47)
	Set RepCompany        = $p(aInputStr,aSeparete,48)
	Set ReportLoc         = $p(aInputStr,aSeparete,49)
	Set ReportUser        = $p(aInputStr,aSeparete,50)
	Set ReportDate        = $p(aInputStr,aSeparete,51)
	Set ReportTime        = $p(aInputStr,aSeparete,52)
	Set CheckUser         = $p(aInputStr,aSeparete,53)
	Set CheckDate         = $p(aInputStr,aSeparete,54)
	Set CheckTime         = $p(aInputStr,aSeparete,55)
	Quit:(ReportDr="")||(StatusDr="")||(EpisodeID="") return
	
	If CardNo="" {
		Set CardNo=..GetNewCardNo()
	}
	
	Set objReport=##class(DHCMed.EPD.Epidemic).GetObjById(ReportDr)
	Quit:'$IsObject(objReport) return
	
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusDr)
	Quit:'$IsObject(objStatus) return
	Set objChestXray=##class(DHCMed.SS.Dictionary).GetObjById(ChestXrayDr)
	Quit:'$IsObject(objChestXray) return
	Set objChestCT=##class(DHCMed.SS.Dictionary).GetObjById(ChestCTDr)
	Quit:'$IsObject(objChestCT) return
	Set objOccupation=##class(DHCMed.SS.Dictionary).GetObjById(OccupationDr)
	Quit:'$IsObject(objOccupation) return

	Set objTravelLive=##class(DHCMed.SS.Dictionary).GetObjById(TravelLiveDr)
	Quit:'$IsObject(objTravelLive) return
	Set objGather=##class(DHCMed.SS.Dictionary).GetObjById(GatherDr)
	Quit:'$IsObject(objGather) return
	Set objMarket=##class(DHCMed.SS.Dictionary).GetObjById(MarketDr)
	Quit:'$IsObject(objMarket) return
	Set objIsMarket=##class(DHCMed.SS.Dictionary).GetObjById(IsMarketDr)
	Quit:'$IsObject(objIsMarket) return
	Set objType=##class(DHCMed.SS.Dictionary).GetObjById(MarketType)

	Set:BloodTestDate'="" BloodTestDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(BloodTestDate)
	Set:ChestXrayDate'="" ChestXrayDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ChestXrayDate)
	Set:ChestctDate'="" ChestctDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ChestctDate)
	Set:FirstAdmDate'="" FirstAdmDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(FirstAdmDate)
	Set:IsolatedDate'="" IsolatedDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(IsolatedDate)
	Set:InHospDate'="" InHospDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(InHospDate)
	Set:InICUDate'="" InICUDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(InICUDate)	

	Set:ReportDate'="" ReportDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ReportDate)
	Set:ReportDate="" ReportDate=+$h
	Set:ReportTime[":" ReportTime=$zth(ReportTime,1)
	Set:ReportTime="" ReportTime=$p($h,",",2)
	
	Set:CheckDate'="" CheckDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
	Set:CheckTime[":" CheckTime=$zth(CheckTime,1)

	If ID="" {
		Set obj=##class(DHCMed.EPD.NCPInvestigation).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.NCPInvestigation).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.InvCardNo         = CardNo
	Set obj.InvEpisodeID      = EpisodeID
	Set obj.InvPatientID      = PatientID
	Set obj.InvStatusDr       = objStatus
	Set obj.InvIdentity       = Identity
	Set obj.InvReportDr       = objReport
	Set obj.InvSymPtomDr      = SymPtomDr
	Set obj.InvTemperature    = Temperature
	Set obj.InvSymPtomExt     = SymPtomExt
	Set obj.InvIsComplication = IsComplication
	Set obj.InvComplication   = ComplicationDr
	Set obj.InvComplicationExt= ComplicationExt
	Set obj.InvIsBloodTest    = IsBloodTest
	Set obj.InvBloodTestDate  = BloodTestDate
	Set obj.InvWBC            = WBC
	Set obj.InvLymphocyte     = Lymphocyte
	Set obj.InvLymphocytePer  = LymphocytePer
	Set obj.InvNePer          = NePer
	Set obj.InvChestXrayDr    = objChestXray
	Set obj.InvChestXrayDate  = ChestXrayDate
	Set obj.InvChestCTDr      = objChestCT
	Set obj.InvChestctDate    = ChestctDate
	Set obj.InvIsMedical      = IsMedical
	Set obj.InvFirstAdmDate   = FirstAdmDate
	Set obj.InvAdmHospital    = AdmHospital
	Set obj.InvIsIsolated     = IsIsolated
	Set obj.InvIsolatedDate   = IsolatedDate
	Set obj.InvIsInHosp       = IsInHosp
	Set obj.InvInHospDate     = InHospDate
	Set obj.InvIsInICU        = IsInICU
	Set obj.InvInICUDate      = InICUDate
	Set obj.InvOccupationDr   = objOccupation
	Set obj.InvOccupationExt  = OccupationExt
	Set obj.InvIsGravida      = IsGravida
	Set obj.InvPreAnamnesisDr = PreAnamnesisDr
	Set obj.InvPreAnamnesisExt= PreAnamnesisExt
	Set obj.InvTravelLiveDr   = objTravelLive
	Set obj.InvIsContactFever = IsContactFever
	Set obj.InvIsContactTrave = IsContactTrave
	Set obj.InvIsContactDiag  = IsContactDiag
	Set obj.InvGatherDr       = objGather
	Set obj.InvIsTreatment    = IsTreatment
	Set obj.InvMarketDr       = objMarket
	Set obj.InvDistance       = Distance
	Set obj.InvIsMarketDr     = objIsMarket
	Set obj.InvMarketType     = objType
	Set obj.InvReportCompany  = RepCompany
	Set obj.InvReportLoc      = ReportLoc	
	Set obj.InvReportUser     = ReportDate
	Set obj.InvReportDate     = ReportDate
	Set obj.InvReportTime     = ReportTime
	Set obj.InvCheckUser      = CheckUser
	Set obj.InvCheckDate      = CheckDate
	Set obj.InvCheckTime      = CheckTime 
    b ;3
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description : 获取新的卡片编号
/// Output      : 新的卡片编号
/// w ##class(DHCMed.EPD.NCPInvestigation).GetNewCardNo()
ClassMethod GetNewCardNo() As %String
{
	Set xCurrDate=""
	Set CurrDate=$zd(+$h,3)
	Set CurrDate=$tr(CurrDate,"-","")
	Set CurrDate=$e(CurrDate,3,$l(CurrDate))
	Set num=$i(^DHCMed.EPD.NCPCardNoC(CurrDate))
	If $l(num)<5 {
		Set $p(xCurrDate,"0",5-$l(num))=num
	} Else {
		Set xCurrDate=num
	}
	
	Set xCurrDate=CurrDate_xCurrDate  //年月日（150101）+四位顺序号
	Quit xCurrDate
}

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description:  更新个案调查表状态
ClassMethod UpdateStatus(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID        =$p(aInputStr,aSeparate,1)
	Set StatusID  =$p(aInputStr,aSeparate,2)
	Set CheckUser =$p(aInputStr,aSeparate,3)
	Set CheckDate =$p(aInputStr,aSeparate,4)
	Set CheckTime =$p(aInputStr,aSeparate,5)
	Quit:(ID="") return
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Quit:'$IsObject(objStatus) return
	Set CheckUser="",CheckDate="",CheckTime=""
	
	If (objStatus.Code=2) {
		Set:CheckDate'="" CheckDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
		Set:CheckDate="" CheckDate=+$h
		Set:CheckTime[":" CheckTime=$zth(CheckTime,1)
		Set:CheckTime="" CheckTime=$p($h,",",2)
	}

	If (ID="") {
		Set obj=##class(DHCMed.EPD.NCPInvestigation).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.NCPInvestigation).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.InvStatusDr       = objStatus
	Set obj.InvCheckUser      = CheckUser
	Set obj.InvCheckDate      = CheckDate
	Set obj.InvCheckTime      = CheckTime 
    
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description:  删除个案调查表
/// Table：       DHCMed.EPD.NCPInvestigation
/// Input：       aId : DHCMed.EPD.NCPInvestigation.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.NCPInvestigation).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.NCPInvestigation).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="NCPInvestigationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InvCardNo</Value>
</Value>
<Value name="3">
<Value>InvEpisodeID</Value>
</Value>
<Value name="4">
<Value>InvPatientID</Value>
</Value>
<Value name="5">
<Value>InvStatusDr</Value>
</Value>
<Value name="6">
<Value>InvIdentity</Value>
</Value>
<Value name="7">
<Value>InvReportDr</Value>
</Value>
<Value name="8">
<Value>InvSymPtomDr</Value>
</Value>
<Value name="9">
<Value>InvTemperature</Value>
</Value>
<Value name="10">
<Value>InvSymPtomExt</Value>
</Value>
<Value name="11">
<Value>InvIsComplication</Value>
</Value>
<Value name="12">
<Value>InvComplication</Value>
</Value>
<Value name="13">
<Value>InvComplicationExt</Value>
</Value>
<Value name="14">
<Value>InvIsBloodTest</Value>
</Value>
<Value name="15">
<Value>InvBloodTestDate</Value>
</Value>
<Value name="16">
<Value>InvWBC</Value>
</Value>
<Value name="17">
<Value>InvLymphocyte</Value>
</Value>
<Value name="18">
<Value>InvLymphocytePer</Value>
</Value>
<Value name="19">
<Value>InvNePer</Value>
</Value>
<Value name="20">
<Value>InvChestXrayDr</Value>
</Value>
<Value name="21">
<Value>InvChestXrayDate</Value>
</Value>
<Value name="22">
<Value>InvChestCTDr</Value>
</Value>
<Value name="23">
<Value>InvChestctDate</Value>
</Value>
<Value name="24">
<Value>InvIsMedical</Value>
</Value>
<Value name="25">
<Value>InvFirstAdmDate</Value>
</Value>
<Value name="26">
<Value>InvAdmHospital</Value>
</Value>
<Value name="27">
<Value>InvIsIsolated</Value>
</Value>
<Value name="28">
<Value>InvIsolatedDate</Value>
</Value>
<Value name="29">
<Value>InvIsInHosp</Value>
</Value>
<Value name="30">
<Value>InvInHospDate</Value>
</Value>
<Value name="31">
<Value>InvIsInICU</Value>
</Value>
<Value name="32">
<Value>InvInICUDate</Value>
</Value>
<Value name="33">
<Value>InvOccupationDr</Value>
</Value>
<Value name="34">
<Value>InvOccupationExt</Value>
</Value>
<Value name="35">
<Value>InvIsGravida</Value>
</Value>
<Value name="36">
<Value>InvPreAnamnesisDr</Value>
</Value>
<Value name="37">
<Value>InvPreAnamnesisExt</Value>
</Value>
<Value name="38">
<Value>InvTravelLiveDr</Value>
</Value>
<Value name="39">
<Value>InvIsContactFever</Value>
</Value>
<Value name="40">
<Value>InvIsContactTrave</Value>
</Value>
<Value name="41">
<Value>InvIsContactDiag</Value>
</Value>
<Value name="42">
<Value>InvGatherDr</Value>
</Value>
<Value name="43">
<Value>InvIsTreatment</Value>
</Value>
<Value name="44">
<Value>InvMarketDr</Value>
</Value>
<Value name="45">
<Value>InvDistance</Value>
</Value>
<Value name="46">
<Value>InvIsMarketDr</Value>
</Value>
<Value name="47">
<Value>InvMarketType</Value>
</Value>
<Value name="48">
<Value>InvReportCompany</Value>
</Value>
<Value name="49">
<Value>InvReportLoc</Value>
</Value>
<Value name="50">
<Value>InvReportUser</Value>
</Value>
<Value name="51">
<Value>InvReportDate</Value>
</Value>
<Value name="52">
<Value>InvReportTime</Value>
</Value>
<Value name="53">
<Value>InvCheckUser</Value>
</Value>
<Value name="54">
<Value>InvCheckDate</Value>
</Value>
<Value name="55">
<Value>InvCheckTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.NCPInvestigationD</DataLocation>
<DefaultData>NCPInvestigationDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.NCPInvestigationD</IdLocation>
<IndexLocation>^DHCMed.EPD.NCPInvestigationI</IndexLocation>
<StreamLocation>^DHCMed.EPD.NCPInvestigationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

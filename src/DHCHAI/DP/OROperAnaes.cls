/// 名称: DHCHAI.DP.OROperAnaes
/// 描述: 手术麻醉记录
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OROperAnaes Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property OREpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 手术ICD
Property OROperICD As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术名称
Property OROperDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 手术类型（急诊、择期）
Property OROperType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 状态(F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
Property OROperStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术日期
Property OROperDate As %Date [ Required ];

/// 手术开始时间
Property ORSttTime As %Time;

/// 手术结束日期
Property OREndDate As %Date;

/// 手术结束时间
Property OREndTime As %Time;

/// 手术持续时间（小时）
Property OROperHour As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术科室
Property OROperLocDr As DHCHAI.BT.Location;

/// 手术科室（ID|Code|Desc）
Property OROperLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术医生（ID|Code|Desc）
Property OROpertor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一助（ID|Code|Desc）
Property ORAssistant1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 二助（ID|Code|Desc）
Property ORAssistant2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口等级
Property ORIncision As %String(MAXLEN = 100, TRUNCATE = 1);

/// 愈合情况
Property ORHealing As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉方式
Property ORAnesMethod As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医生（ID|Code|Desc）
Property ORAnesthesia As %String(MAXLEN = 100, TRUNCATE = 1);

/// ASA评分
Property ORASAScore As %String(MAXLEN = 100, TRUNCATE = 1);

/// NNIS分级
Property ORNNISGrade As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property ORSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property ORXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 术前外周WBC计数
Property ORWBC As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口个数
Property ORIncisionNum As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否使用窥镜
Property ORIsSightGlass As %Boolean;

/// 是否有植入物
Property ORIsImplants As %Boolean;

/// 失血量
Property ORLoseBlood As %String(MAXLEN = 100, TRUNCATE = 1);

/// 输血量
Property ORGotBlood As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术后并发症
Property ORComplication As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property ORIsActive As %Boolean [ Required ];

/// 更新日期
Property ORUpdateDate As %Date;

/// 更新时间
Property ORUpdateTime As %Time;

/// 手术类型(N常规，D诊断性操作，T治疗性操作,I介入治疗,其中NI为手术DT为操作)
Property OROperTypeSoC As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术分类
Property OROperCatDrs As %String(MAXLEN = 200, TRUNCATE = 1);

/// add 20211221 手术类别(风险评估中：浅层组织手术、深部组织手术、器官类别、腔隙手术)
Property OROperTypeValue As %String(MAXLEN = 200, TRUNCATE = 1);

/// 手术来源（E首页、F编目）
Property OROperSource As %String(DISPLAYLIST = ",E,F,O", VALUELIST = ",E,F,O");

/// 手术类别代码
Property OROperTypeCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否附加手术
Property IsSubOper As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一助ID
Property Assistant1ID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 二助ID
Property Assistant2ID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医师ID
Property NarcosisDocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术级别代码
Property OperLevelCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术级别
Property OperLevelDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否主手术代码
Property MainOperCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否主手术
Property MainOperDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术类型代码
Property TypeCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术类型描述(操作，手术)
Property TypeDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术序号
Property Index As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉分级代码
Property NarcosisLevelCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉分级描述
Property NarcosisLevelDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术部位代码
Property OperSiteCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术部位描述
Property OperSiteDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 非计划重返手术代码
Property BackOperCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 非计划重返手术描述
Property BackOperDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术风险等级代码
Property NNISLevelCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术风险等级描述
Property NNISLevelDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否急诊手术代码
Property IsEmergencyCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否急诊手术描述
Property IsEmergencyDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否微创手术代码
Property IsMiniInvaCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否微创手术描述
Property IsMiniInvaDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否择期手术代码
Property IsChooseDateCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否择期手术描述
Property IsChooseDateDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉开始日期
Property NarcosisSttDate As %Date;

/// 麻醉开始时间
Property NarcosisSttTime As %Time;

/// 麻醉结束日期
Property NarcosisEndDate As %Date;

/// 麻醉结束时间
Property NarcosisEndTime As %Time;

/// 就诊记录索引
Index IndexEpisodeDr On OREpisodeDr;

/// 手术开始日期时间索引
Index IndexOperDateTime On (OROperDate, ORSttTime);

/// 手术开始日期时间手术科室索引 
Index IndexOperDateTimeOperLoc On (OROperDate, ORSttTime, OROperLocDr);

/// 手术开始日期时间切口等级索引
Index IndexOperDateTimeIncision On (OROperDate, ORSttTime, ORIncision As Exact);

/// 子系统代码+记录索引码 索引
Index IndexSCodeXCode On (ORSCode As Exact, ORXCode As Exact);

/// 就诊记录 + 手术开始日期 索引
Index IndexEpisodeDrOperDate On (OREpisodeDr, OROperDate);

/// 更新日期 索引
Index IndexEpisUpdateDate On (OREpisodeDr, ORUpdateDate);

/// Creator：     zhufei
/// CreatDate：   2018-03-10
/// Description:  根据ID作废手麻记录
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       id:    DHCHAI.DP.OROperAnaes.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperAnaes).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.OROperAnaes).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.ORIsActive		= 0
	Set obj.ORUpdateDate    = +$h
	Set obj.ORUpdateTime    = $p($h,",",2)
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       ID:    DHCHAI.DP.OROperAnaes.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperAnaes).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OROperAnaes
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OROperAnaes).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OROperAnaes).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-04-16
/// Description:  合并手术切口调查信息到手麻记录表中
/// Table：       DHCHAI.DP.OROperAnaes、DHCHAI.IR.INFOPS
/// Input：       aAnaesDr:DHCHAI.DP.OROperAnaes.ID
/// 			  aEpisodeDr:DHCHAI.DP.PAAdm.ID
/// Return：      返回DHCHAI.DP.OROperAnaes.ID
/// w ##class(DHCHAI.DP.OROperAnaes).OperOPSMerge(15,33)
ClassMethod OperOPSMerge(aEpisodeDr As %String, aAnaesDr As %String) As %String
{
	New (aEpisodeDr,aAnaesDr)
	Set return=""
	Quit:(aAnaesDr="")||(aEpisodeDr="") return
	
	Set AnaesDr=""
	Set xOPSID =""
	For {
		Set xOPSID = $o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",aEpisodeDr,aAnaesDr,xOPSID))
		Quit:xOPSID=""
		
		Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
		Continue:OPSData=""
		Set AnaesDr = ##class(DHCHAI.DP.OROperAnaes).OperINFOPSMerge(aAnaesDr,xOPSID)
	}
	
	Set return=AnaesDr
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-10-18
/// Description:  合并手术切口调查信息到手麻记录表中
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aAnaesDr:DHCHAI.DP.OROperAnaes.ID
/// 			  aOPSDr:DHCHAI.IR.INFOPS.ID
/// Return：      返回DHCHAI.DP.OROperAnaes.ID
/// w ##class(DHCHAI.DP.OROperAnaes).OperINFOPSMerge(8,7)
ClassMethod OperINFOPSMerge(aAnaesDr As %String, aOPSDr As %String) As %String
{
	New (aAnaesDr,aOPSDr)
	Set return=""
	Quit:(aAnaesDr="")||(aOPSDr="") return
	
	Set objOper =##class(DHCHAI.IR.INFOPS).GetObjById(aOPSDr)
	Quit:'$IsObject(objOper) return
	Set objAnae =##class(DHCHAI.DP.OROperAnaes).%OpenId(aAnaesDr)
	Quit:'$IsObject(objAnae) return
	Set IROperType=""
	Set ObjOperType = objOper.IROperTypeDr
	Set:$IsObject(ObjOperType) IROperType=ObjOperType.BTDesc
	// 获取手术数据信息
	Set OROperICD    = "" //objOper.OROperICD
	Set OROperDesc   = objOper.IROperName
	Set OROperType   = IROperType
	Set OROperDate   = objOper.IROperDate
	Set ORSttTime    = objOper.IRSttTime
	Set OREndDate    = objOper.IREndDate
	Set OREndTime    = objOper.IREndTime
	Set OROperHour   = objOper.IROperHours
	Set OROperLocDr  = objOper.IROperLocDr
	Set OROperLoc    = "" //objOper.OROperLoc
	Set OROpertor    = "" //objOper.OROpertor
	Set ORAssistant1 = "" //objOper.ORAssistant1
	Set ORAssistant2 = "" //objOper.ORAssistant2
	Set ORIncision=""
	If ($IsObject(objOper.IRCuteTypeDr)){
		Set ORIncision = objOper.IRCuteTypeDr.BTDesc
	}
	Set ORHealing=""
	If ($IsObject(objOper.IRCuteHealingDr)){
		Set ORHealing = objOper.IRCuteHealingDr.BTDesc
	}
	Set ORAnesMethod=""
	If ($IsObject(objOper.IRAnesthesiaDr)){
		Set ORAnesMethod = objOper.IRAnesthesiaDr.BTDesc
	}
	Set ORAnesthesia = "" //objOper.ORAnesthesia
	Set ORASAScore=""
	If ($IsObject(objOper.IRASAScore)){
		Set ORASAScore = objOper.IRASAScore.BTDesc
	}
	Set ORNNISGrade=""
	If ($IsObject(objOper.IRNNISLevelDr)){
		Set ORNNISGrade = objOper.IRNNISLevelDr.BTDesc
	}
	Set ORWBC          = objOper.IRPreoperWBC
	Set ORIncisionNum  = objOper.IRCuteNumber
	Set ORIsSightGlass = objOper.IREndoscopeFlag
	Set ORIsImplants   = objOper.IRImplantFlag
	Set ORLoseBlood    = objOper.IRBloodLoss
	Set ORGotBlood     = objOper.IRBloodTrans
	Set ORComplication = objOper.IRPostoperComps
	
	//合并数据到手麻记录表
	Set:OROperICD'="" objAnae.OROperICD = OROperICD
	Set:OROperDesc'="" objAnae.OROperDesc = OROperDesc
	Set:OROperType'="" objAnae.OROperType = OROperType
	Set:OROperDate'="" objAnae.OROperDate = OROperDate
	Set:ORSttTime'="" objAnae.ORSttTime = ORSttTime
	Set:OREndDate'="" objAnae.OREndDate = OREndDate
	Set:OREndTime'="" objAnae.OREndTime = OREndTime
	Set:OROperHour'="" objAnae.OROperHour = OROperHour
	Set:OROperLocDr'="" objAnae.OROperLocDr = OROperLocDr
	Set:OROperLoc'="" objAnae.OROperLoc = OROperLoc
	Set:OROpertor'="" objAnae.OROpertor = OROpertor
	Set:ORAssistant1'="" objAnae.ORAssistant1 = ORAssistant1
	Set:ORAssistant2'="" objAnae.ORAssistant2 = ORAssistant2
	Set:ORIncision'="" objAnae.ORIncision = ORIncision
	Set:ORHealing'="" objAnae.ORHealing = ORHealing
	Set:ORAnesMethod'="" objAnae.ORAnesMethod = ORAnesMethod
	Set:ORAnesthesia'="" objAnae.ORAnesthesia = ORAnesthesia
	Set:ORASAScore'="" objAnae.ORASAScore = ORASAScore
	Set:ORNNISGrade'="" objAnae.ORNNISGrade = ORNNISGrade
	Set objAnae.OROperStatus="F"  // 首页过来的数据状态都是完成的手术
	Set:ORWBC'="" objAnae.ORWBC = ORWBC
	Set:ORIncisionNum'="" objAnae.ORIncisionNum = ORIncisionNum
	Set:ORIsSightGlass'="" objAnae.ORIsSightGlass = ORIsSightGlass
	Set:ORIsImplants'="" objAnae.ORIsImplants = ORIsImplants
	Set:ORLoseBlood'="" objAnae.ORLoseBlood = ORLoseBlood
	Set:ORGotBlood'="" objAnae.ORGotBlood = ORGotBlood
	Set:ORComplication'="" objAnae.ORComplication = ORComplication
	
	Set sc=objAnae.%Save()
	//if $system.Status.IsError(sc) { 
	if (sc=1){       //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=objAnae.%Id()
	}
	Do objAnae.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-10-16
/// Description:  根据手术名称+手术日期匹配手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aOperName
/// 			  aOperDate
/// Return：      返回DHCHAI.DP.OROperAnaes.ID
/// w ##class(DHCHAI.DP.OROperAnaes).GetObjByNameDate(12,"化学治疗药物置入,头部缝线去除","2019-02-19")
ClassMethod GetObjByNameDate(aEpisodeDr As %String, aOperName As %String, aOperDate As %String) As %String
{
	New (aEpisodeDr,aOperName,aOperDate)
	Set return=""
	Set aOperDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aOperDate)
	Quit:(aEpisodeDr="")||(aOperName="")||(aOperDate="") return
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeDr,aOperDate,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.ORIsActive'=1
	 	Continue:'$IsObject(obj.OREpisodeDr)
 	
 		Set OperDesc = obj.OROperDesc
 		If (OperDesc = aOperName){
	 		Set return=xID
	 		Quit 
	 	}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-04-16
/// Description:  合并手术编码信息到手麻记录表中
/// Table：       DHCHAI.DP.OROperAnaes、DHCHAI.DP.OROperation
/// Input：       aOperDate:DHCHAI.DP.OROperAnaes.OROperDate
/// 			  aEpisodeDr:DHCHAI.DP.PAAdm.ID
/// Return：      返回ID
/// w ##class(DHCHAI.DP.OROperAnaes).OperationMerge(,"15","33","2021-03-29")
ClassMethod OperationMerge(aEpisodeDr As %String, aAnaesDr As %String, aOperDate As %String) As %String
{
	New (aEpisodeDr,aAnaesDr,aOperDate)
	Set return=""
	Quit:(aAnaesDr="")||(aEpisodeDr="")||(aOperDate="") return
	Set OperDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aOperDate)
	
	Set AnaesDr=""
	Set xOperID =""
	For {
		Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",aEpisodeDr,OperDate,xOperID))
		Quit:xOperID=""
		
		Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
		Continue:OperData=""
		Set AnaesDr = ##class(DHCHAI.DP.OROperAnaes).OperEMRMerge(aAnaesDr,xOperID)
	}
	
	Set return=AnaesDr
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-10-18
/// Description:  合并首页手术信息到手麻记录表中
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aAnaesDr:DHCHAI.DP.OROperAnaes.ID
/// 			  aOperationDr:DHCHAI.DP.OROperation.ID
/// Return：      返回DHCHAI.DP.OROperAnaes.ID
/// w ##class(DHCHAI.DP.OROperAnaes).OperEMRMerge(8,1)
ClassMethod OperEMRMerge(aAnaesDr As %String, aOperationDr As %String) As %String
{
	New (aAnaesDr,aOperationDr)
	Set return=""
	Quit:(aAnaesDr="")||(aOperationDr="") return
	
	Set objOper =##class(DHCHAI.DP.OROperation).GetObjById(aOperationDr)
	Quit:'$IsObject(objOper) return
	Set objAnae =##class(DHCHAI.DP.OROperAnaes).%OpenId(aAnaesDr)
	Quit:'$IsObject(objAnae) return
	// 获取病案首页数据信息
	Set OROperICD    = objOper.OROperICD
	Set OROperDesc   = objOper.OROperDesc
	Set OROperType   = objOper.OROperType
	Set OROperDate   = objOper.OROperDate
	Set ORSttTime    = objOper.ORSttTime
	Set OREndDate    = objOper.OREndDate
	Set OREndTime    = objOper.OREndTime
	Set OROperHour   = objOper.OROperHour
	Set OROperLocDr  = objOper.OROperLocDr
	Set OROperLoc    = objOper.OROperLoc
	Set OROpertor    = objOper.OROpertor
	Set ORAssistant1 = objOper.ORAssistant1
	Set ORAssistant2 = objOper.ORAssistant2
	Set ORIncision   = objOper.ORIncision
	Set TMPORIncision=""
	Set:ORIncision'["类" TMPORIncision=ORIncision_"类"
	Set ORHealing    = objOper.ORHealing
	Set ORAnesMethod = objOper.ORAnesMethod
	Set ORAnesthesia = objOper.ORAnesthesia
	Set ORASAScore   = objOper.ORASAScore
	Set ORNNISGrade  = objOper.ORNNISGrade
	Set ORSCode      = objOper.ORSCode
	//合并数据到手麻记录表
	Set:OROperDate'="" objAnae.OROperDate = OROperDate
	Set:ORSttTime'="" objAnae.ORSttTime = ORSttTime
	Set:OREndDate'="" objAnae.OREndDate = OREndDate
	Set:OREndTime'="" objAnae.OREndTime = OREndTime
	Set:OROperHour'="" objAnae.OROperHour = OROperHour
	Set:OROperLocDr'="" objAnae.OROperLocDr = OROperLocDr
	Set:(OROperLoc'="")&&(OROperLoc'="||") objAnae.OROperLoc = OROperLoc
	Set:OROpertor'="" objAnae.OROpertor = OROpertor
	Set:ORAssistant1'="" objAnae.ORAssistant1 = ORAssistant1
	Set:ORAssistant2'="" objAnae.ORAssistant2 = ORAssistant2
	Set:ORAnesMethod'="" objAnae.ORAnesMethod = ORAnesMethod
	Set:ORAnesthesia'="" objAnae.ORAnesthesia = ORAnesthesia
	Set:ORSCode'="" objAnae.ORSCode = ORSCode
	Set:ORSCode="EMR01" objAnae.OROperSource="E"
	Set:ORSCode="MRS01" objAnae.OROperSource="F"
	Set objAnae.OROperStatus="F"  // 首页过来的数据状态都是完成的手术
	//合并数据比较等级
	If (ORIncision'=""){   //切口等级
		If (objAnae.ORIncision="") {
			Set objAnae.ORIncision = ORIncision
		}Else {
			If (objAnae.ORIncision'=TMPORIncision) {
				Set:(TMPORIncision["Ⅳ类") objAnae.ORIncision=ORIncision
				Set:(TMPORIncision["Ⅲ类")&&(objAnae.ORIncision'["Ⅳ类") objAnae.ORIncision=ORIncision
				Set:(TMPORIncision["Ⅱ类")&&(objAnae.ORIncision'["Ⅳ类")&&(objAnae.ORIncision'["Ⅲ类") objAnae.ORIncision=ORIncision
			    Set:((objAnae.ORIncision["无")||(objAnae.ORIncision["0类")) objAnae.ORIncision=ORIncision
			}
		}
	}
	If (ORHealing'=""){   //愈合情况
		If (objAnae.ORHealing="") {
			Set objAnae.ORHealing = ORHealing
		}Else {
			If (objAnae.ORHealing'=ORHealing) {
				Set:ORHealing="丙" objAnae.ORHealing=ORHealing
				Set:(ORHealing="乙")&&(objAnae.ORHealing'="丙") objAnae.ORHealing=ORHealing
			}
		}
	}
	If (ORASAScore'=""){   //ASA分级
		If (objAnae.ORASAScore="") {
			Set objAnae.ORASAScore = ORASAScore
		}Else {
			If (objAnae.ORASAScore'=ORASAScore) {
				Set:($p(ORASAScore,"P",2)>$p(objAnae.ORASAScore,"P",2)) objAnae.ORASAScore=ORASAScore
			}
		}
	}
	If (ORNNISGrade'=""){   //NNIS分级
		If (objAnae.ORNNISGrade="") {
			Set objAnae.ORNNISGrade = ORNNISGrade
		}Else {
			If (objAnae.ORNNISGrade'=ORNNISGrade) {
				Set:($p(ORNNISGrade,"级",1)>$p(objAnae.ORNNISGrade,"级",1)) objAnae.ORNNISGrade=ORNNISGrade
			}
		}
	}
	
	Set sc=objAnae.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=objAnae.%Id()
	}
	Do objAnae.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-05-22
/// Description:  根据Code取手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aSCode:    DHCHAI.DP.OROperAnaes.ORSCode
/// 				  aXCode:    DHCHAI.DP.OROperAnaes.ORXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperAnaes).GetObjByXCode()
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.OROperAnaes
{
	New (aSCode,aXCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id=$o(^DHCHAI.DP.OROperAnaesI("IndexSCodeXCode",aSCode,aXCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperAnaes).Update("^111^^^择期^2016-09-01^10:30^^^0^ZXYJHYK-中西医结合一科^冯红^411^周玉玲^^Ⅱ类切口^^吸入麻醉,静脉麻醉,基础麻醉^^^^OPS01^102^^^^^^^^1^64505^44432,静脉麻醉,基础麻醉^^^^OPS01^102^^^^^^^^1^64504^60062","^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID					= $p(InStr,aSeparete,1)
	Set EpisodeDr	 		= $p(InStr,aSeparete,2)
	Set OperICD		 		= $p(InStr,aSeparete,3)   
	Set OperDesc	 		= $p(InStr,aSeparete,4)
	Set OperType	 		= $p(InStr,aSeparete,5)
	Set OperDate	 		= $p(InStr,aSeparete,6)
	Set SttTime		 		= $p(InStr,aSeparete,7)
	Set EndDate		 		= $p(InStr,aSeparete,8)
	Set EndTime		 		= $p(InStr,aSeparete,9)
	Set OperHour	 		= $p(InStr,aSeparete,10)
	Set OperLocDr	 		= $p(InStr,aSeparete,11)
	Set OperLoc      		= $p(InStr,aSeparete,12)
	Set Opertor    	 		= $p(InStr,aSeparete,13)
	Set Assistant1	 		= $p(InStr,aSeparete,14)
	Set Assistant2	 		= $p(InStr,aSeparete,15)
	Set Incision	 		= $p(InStr,aSeparete,16)
	Set Healing		 		= $p(InStr,aSeparete,17)
	Set AnesMethod	 		= $p(InStr,aSeparete,18)
	Set Anesthesia	 		= $p(InStr,aSeparete,19)
	Set ASAScore	 		= $p(InStr,aSeparete,20)
	Set NNISGrade	 		= $p(InStr,aSeparete,21)
	Set SCode	 	 		= $p(InStr,aSeparete,22)
	Set XCode	 	 		= $p(InStr,aSeparete,23)
	Set WBC		     		= $p(InStr,aSeparete,24)
	Set IncisionNum  		= $p(InStr,aSeparete,25)
	Set IsSightGlass		= +$p(InStr,aSeparete,26)
	Set IsImplants   		= +$p(InStr,aSeparete,27)
	Set LoseBlood    		= $p(InStr,aSeparete,28)
	Set GotBlood     		= $p(InStr,aSeparete,29)
	Set Complication 		= $p(InStr,aSeparete,30)
	Set IsActive	 		= +$p(InStr,aSeparete,31)
	Set UpdateDate	 		= $p(InStr,aSeparete,32)
	Set UpdateTime	 		= $p(InStr,aSeparete,33)
	Set OperStatus   		= $p(InStr,aSeparete,34)
	Set OPertypesoc  		= $p(InStr,aSeparete,35)
	Set OperTypeValue		= $p(InStr,aSeparete,36)
	Set OROperSource 		= $p(InStr,aSeparete,37)
	Set OROperTypeCode 		= $p(InStr,aSeparete,38)
	Set IsSubOper			= $p(InStr,aSeparete,39)
	Set Assistant1ID		= $p(InStr,aSeparete,40)
	Set Assistant2ID		= $p(InStr,aSeparete,41)
	Set NarcosisDocID		= $p(InStr,aSeparete,42)
	Set OperLevelCode		= $p(InStr,aSeparete,43)
	Set OperLevelDesc		= $p(InStr,aSeparete,44)
	Set MainOperCode		= $p(InStr,aSeparete,45)
	Set MainOperDesc		= $p(InStr,aSeparete,46)
	Set TypeCode			= $p(InStr,aSeparete,47)
	Set TypeDesc			= $p(InStr,aSeparete,48)
	Set Index				= $p(InStr,aSeparete,49)
	Set NarcosisLevelCode	= $p(InStr,aSeparete,50)
	Set NarcosisLevelDesc	= $p(InStr,aSeparete,51)
	Set OperSiteCode		= $p(InStr,aSeparete,52)
	Set OperSiteDesc		= $p(InStr,aSeparete,53)
	Set BackOperCode		= $p(InStr,aSeparete,54)
	Set BackOperDesc		= $p(InStr,aSeparete,55)
	Set NNISLevelCode		= $p(InStr,aSeparete,56)
	Set NNISLevelDesc		= $p(InStr,aSeparete,57)
	Set IsEmergencyCode		= $p(InStr,aSeparete,58)
	Set IsEmergencyDesc		= $p(InStr,aSeparete,59)
	Set IsMiniInvaCode		= $p(InStr,aSeparete,60)
	Set IsMiniInvaDesc		= $p(InStr,aSeparete,61)
	Set IsChooseDateCode	= $p(InStr,aSeparete,62)
	Set IsChooseDateDesc	= $p(InStr,aSeparete,63)
	Set NarcosisSttDate		= $p(InStr,aSeparete,64)
	Set NarcosisSttTime		= $p(InStr,aSeparete,65)
	Set NarcosisEndDate		= $p(InStr,aSeparete,66)
	Set NarcosisEndTime		= $p(InStr,aSeparete,67)
	Set NarcosisEndTime		= $p(InStr,aSeparete,67)
	
	Set:OperDate["-" OperDate = $zdh(OperDate,3)
	Set:SttTime[":" SttTime = $zth(SttTime,1)
	Set:SttTime="" SttTime=0
	Set:EndDate["-" EndDate = $zdh(EndDate,3)
	Set:EndTime[":" EndTime = $zth(EndTime,1)
	Quit:(EpisodeDr="")||(OperDate="")||(Opertor="") return
	Quit:(SCode="")||(XCode="")||(IsActive="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	
	Set objOperLoc = ##class(DHCHAI.BT.Location).GetObjById(OperLocDr)
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.OROperAnaesI("IndexSCodeXCode",SCode,XCode,0))   //判断数据在编目表的唯一性，同一个SCode,XCode需更新
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OROperAnaes).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OROperAnaes).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set OperCatDrs=obj.OROperCatDrs
	Set:OperCatDrs="" OROperCatDrs=##Class(DHCHAI.IRS.CRuleOperCatSrv).CheckKeyCat(OperICD,OperDesc)
	
	Set obj.OREpisodeDr		= objAdm
	Set obj.OROperICD		= OperICD
	Set obj.OROperDesc		= OperDesc	
	Set obj.OROperType		= OperType
	Set obj.OROperDate		= OperDate
	Set obj.ORSttTime		= SttTime
	Set obj.OREndDate		= EndDate
	Set obj.OREndTime		= EndTime
	Set obj.OROperHour		= OperHour
	Set obj.OROperLocDr	    = objOperLoc
	Set obj.OROperLoc	    = OperLoc
	Set obj.OROpertor	    = Opertor
	Set obj.ORAssistant1	= Assistant1
	set obj.OROperSource	= "O"
	Set obj.ORAssistant2	= Assistant2	
	Set obj.ORIncision		= Incision		//1.数据源是手麻,字段数据源是编目(病案首页)
	Set Config=##class(DHCHAI.BT.Config).GetValByCode("OperDataSourceConfig")
	Set MRSDataSource=##class(DHCHAI.BT.Dictionary).GetObjByCode("OperDataSource","1")
	Set MRSDataSourceDesc=MRSDataSource.BTDesc
	Set OperIncision=""
	If ((MRSDataSourceDesc="编目")&Config=1){
		Set xOperID =""
		For {
			Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDr",EpisodeDr,xOperID))
			Quit:xOperID=""
			
			Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
			Continue:OperData=""
			Set OperSource= OperData.OROperSource
			Continue:((OperSource'="F")||(OperSource'=""))
			Set OperIncision	= OperData.ORIncision
			Set TMPOperIncision = OperData.ORIncision_"类"
			
			Set:(TMPOperIncision["Ⅳ类") obj.ORIncision=OperIncision
			Set:(TMPOperIncision["Ⅲ类")&&(obj.ORIncision'["Ⅳ类") obj.ORIncision=OperIncision
			Set:(TMPOperIncision["Ⅱ类")&&(obj.ORIncision'["Ⅳ类")&&(obj.ORIncision'["Ⅲ类") obj.ORIncision=OperIncision
			Set:((obj.ORIncision["无")||(obj.ORIncision["0类")) obj.ORIncision=OperIncision
					
		}
		
	}
	Set EMRDataSource=##class(DHCHAI.BT.Dictionary).GetObjByCode("OperDataSource","2")
	Set EMRDataSourceDesc=EMRDataSource.BTDesc
	If (EMRDataSourceDesc="病案首页"){
		Set xOperID =""
		For {
			Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDr",EpisodeDr,xOperID))
			Quit:xOperID=""
			
			Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
			Continue:OperData=""
			Set OperSource= OperData.OROperSource
			Continue:OperSource'="E"
			Set OperIncision	= OperData.ORIncision
			Set TMPOperIncision = OperData.ORIncision_"类"
			Set:(TMPOperIncision["Ⅳ类") obj.ORIncision=OperIncision
			Set:(TMPOperIncision["Ⅲ类")&&(obj.ORIncision'["Ⅳ类") obj.ORIncision=OperIncision
			Set:(TMPOperIncision["Ⅱ类")&&(obj.ORIncision'["Ⅳ类")&&(obj.ORIncision'["Ⅲ类") obj.ORIncision=OperIncision
			Set:((obj.ORIncision["无")||(obj.ORIncision["0类")) obj.ORIncision=OperIncision
		}
		
	}
	Set obj.ORHealing		= Healing
	Set obj.ORAnesMethod	= AnesMethod
	Set obj.ORAnesthesia	= Anesthesia
	Set obj.ORASAScore		= ASAScore
	Set obj.ORNNISGrade		= NNISGrade
	Set obj.ORSCode			= SCode
	Set obj.ORXCode			= XCode
	Set obj.ORWBC			= WBC
	Set obj.ORIncisionNum   = IncisionNum
	Set obj.ORIsSightGlass  = IsSightGlass
	Set obj.ORIsImplants    = IsImplants
	Set obj.ORLoseBlood		= LoseBlood
	Set obj.ORGotBlood      = GotBlood
	Set obj.ORComplication  = Complication
	Set obj.OROperStatus    = OperStatus
	Set obj.ORIsActive		= IsActive
	Set obj.ORUpdateDate    = +$h
	Set obj.ORUpdateTime    = $p($h,",",2)
	Set obj.OROperTypeSoC   = OPertypesoc
	Set obj.OROperCatDrs    = OperCatDrs
	Set obj.OROperTypeValue = OperTypeValue
	Set obj.OROperTypeCode	= OROperTypeCode
	Set obj.IsSubOper		= IsSubOper
	Set obj.Assistant1ID	= Assistant1ID
	Set obj.Assistant2ID	= Assistant2ID
	Set obj.NarcosisDocID	= NarcosisDocID
	Set obj.OperLevelCode	= OperLevelCode
	Set obj.OperLevelDesc	= OperLevelDesc
	Set obj.MainOperCode	= MainOperCode
	Set obj.MainOperDesc	= MainOperDesc
	Set obj.TypeCode		= TypeCode
	Set obj.TypeDesc		= TypeDesc
	Set obj.Index			= Index
	Set obj.NarcosisLevelCode= NarcosisLevelCode
	Set obj.NarcosisLevelDesc= NarcosisLevelDesc
	Set obj.OperSiteCode	= OperSiteCode
	Set obj.OperSiteDesc	= OperSiteDesc
	Set obj.BackOperCode	= BackOperCode
	Set obj.BackOperDesc	= BackOperDesc
	Set obj.NNISLevelCode	= NNISLevelCode
	Set obj.NNISLevelDesc	= NNISLevelDesc
	Set obj.IsEmergencyCode	= IsEmergencyCode
	Set obj.IsEmergencyDesc	= IsEmergencyDesc
	Set obj.IsMiniInvaCode	= IsMiniInvaCode
	Set obj.IsMiniInvaDesc	= IsMiniInvaDesc
	Set obj.IsChooseDateCode= IsChooseDateCode
	Set obj.IsChooseDateDesc= IsChooseDateDesc
	Set obj.NarcosisSttDate	= NarcosisSttDate
	Set obj.NarcosisSttTime	= NarcosisSttTime
	Set obj.NarcosisEndDate	= NarcosisEndDate
	Set obj.NarcosisEndTime	= NarcosisEndTime
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {  

	      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除手术麻醉记录
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OROperAnaes).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     liutao
/// CreatDate：   2022-11-30
/// Description:  保存编目(病案首页)手术信息到手麻记录表中
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aOperationDr:DHCHAI.DP.OROperation.ID
/// Return：      返回DHCHAI.DP.OROperAnaes.ID
/// w ##class(DHCHAI.DP.OROperAnaes).SaveOper(1)
ClassMethod SaveOper(aOperationDr As %String) As %String
{
	New (aOperationDr)
	Set return=""
	Quit:aOperationDr="" return
	Set objOper =##class(DHCHAI.DP.OROperation).GetObjById(aOperationDr)
	Quit:'$IsObject(objOper) return
	Quit:objOper.OREpisodeDr="" return
	Set ORSCode    		 = objOper.ORSCode //手术信息来源，编目,病案首页
	Set Config=##class(DHCHAI.BT.Config).GetValByCode("OperDataSourceConfig")
	If (Config=2){
		Quit:ORSCode'="MRS01" return 					//过滤出编目手术
	}
	If (Config=3){
		Quit:ORSCode'="EMR01" return 					//过滤出病案首页手术
	}
	Set EpisodeDr 			 = objOper.OREpisodeDr.%Id()
	Set OperICD			 	 = objOper.OROperICD
	Set OperDesc			 = objOper.OROperDesc   
	Set OperType			 = objOper.OROperType	//急诊，择期
	Set OperDate			 = objOper.OROperDate
	Set SttTime				 = objOper.ORSttTime
	Set EndDate				 = objOper.OREndDate
	Set EndTime		 		 = objOper.OREndTime
	Set OperHour 		     = objOper.OROperHour
	Set objOperLoc=""
	Set objOperLoc = objOper.OROperLocDr.%Id()
	Set OperLoc	    		 = objOper.OROperLoc
	Set Opertor	    		 = objOper.OROpertor
	Set Assistant1			 = objOper.ORAssistant1
	Set Assistant2			 = objOper.ORAssistant2
	Set Incision			 = objOper.ORIncision
	//Set:Incision'["类" Incision=Incision_"类"
	Set Healing				 = objOper.ORHealing
	Set AnesMethod			 = objOper.ORAnesMethod
	Set Anesthesia			 = objOper.ORAnesthesia
	Set ASAScore			 = objOper.ORASAScore
	Set NNISGrade			 = objOper.ORNNISGrade
	Set SCode				 = objOper.ORSCode
	Set XCode 				 = objOper.ORXCode         //同步编目表的ID
	Set IsActive			 = objOper.ORIsActive
	Set UpdateDate			 = objOper.ORUpdateDate
	Set UpdateTime			 = objOper.ORUpdateTime
	Set OperCatDrs			 = objOper.OROperCatDrs
	Set OperTypeCode		 = objOper.OROperTypeCode
	Set IsSubOper			 = objOper.IsSubOper
	Set Assistant1ID		 = objOper.Assistant1ID
	Set Assistant2ID		 = objOper.Assistant2ID
	Set NarcosisDocID		 = objOper.NarcosisDocID
	Set OperLevelCode		 = objOper.OperLevelCode
	Set OperLevelDesc		 = objOper.OperLevelDesc
	Set MainOperCode		 = objOper.MainOperCode
	Set MainOperDesc		 = objOper.MainOperDesc
	Set TypeCode			 = objOper.TypeCode		//操作，手术
	Set TypeDesc		 	 = objOper.TypeDesc		//操作，手术
	Set Index				 = objOper.Index
	Set AisOperID			 = objOper.AisOperID    //同步手麻表的ID
	Set NarcosisLevelCode	 = objOper.NarcosisLevelCode
	Set NarcosisLevelDesc	 = objOper.NarcosisLevelDesc
	Set OperSiteCode		 = objOper.OperSiteCode
	Set OperSiteDesc		 = objOper.OperSiteDesc
	Set BackOperCode		 = objOper.BackOperCode
	Set BackOperDesc		 = objOper.BackOperDesc
	Set NNISLevelCode		 = objOper.NNISLevelCode
	Set NNISLevelDesc		 = objOper.NNISLevelDesc
	Set IsEmergencyCode		 = objOper.IsEmergencyCode
	Set IsEmergencyDesc		 = objOper.IsEmergencyDesc
	Set IsMiniInvaCode		 = objOper.IsMiniInvaCode
	Set IsMiniInvaDesc	 	 = objOper.IsMiniInvaDesc
	Set IsChooseDateCode	 = objOper.IsChooseDateCode
	Set IsChooseDateDesc	 = objOper.IsChooseDateDesc
	Set NarcosisSttDate		 = objOper.NarcosisSttDate
	Set NarcosisSttTime		 = objOper.NarcosisSttTime
	Set NarcosisEndDate		 = objOper.NarcosisEndDate
	Set NarcosisEndTime		 = objOper.NarcosisEndTime
	Set OperStatus="F"  // 编目(首页)过来的数据状态都是完成的手术
	Set OperSource 			 = objOper.OROperSource
	
	Quit:(XCode="")||(EpisodeDr="")||(OperDate="") return
	
	
	//保存数据到手麻记录表
	Set OperationDr=$o(^DHCHAI.DP.OROperAnaesI("IndexSCodeXCode",SCode,XCode,"")) 
	Set InputStr = OperationDr           //传值问题
	Set InputStr = InputStr_"^"_EpisodeDr
	Set InputStr = InputStr_"^"_OperICD
	Set InputStr = InputStr_"^"_OperDesc   
	Set InputStr = InputStr_"^"_OperType	//择期，急诊
	Set InputStr = InputStr_"^"_OperDate
	Set InputStr = InputStr_"^"_SttTime
	Set InputStr = InputStr_"^"_EndDate
	Set InputStr = InputStr_"^"_EndTime
	Set InputStr = InputStr_"^"_OperHour
	Set InputStr = InputStr_"^"_objOperLoc
	Set InputStr = InputStr_"^"_OperLoc
	Set InputStr = InputStr_"^"_Opertor
	Set InputStr = InputStr_"^"_Assistant1
	Set InputStr = InputStr_"^"_Assistant2
	Set InputStr = InputStr_"^"_Incision
	Set InputStr = InputStr_"^"_Healing
	Set InputStr = InputStr_"^"_AnesMethod
	Set InputStr = InputStr_"^"_Anesthesia
	Set InputStr = InputStr_"^"_ASAScore
	Set InputStr = InputStr_"^"_NNISGrade
	Set InputStr = InputStr_"^"_SCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_""     //WBC
	Set InputStr = InputStr_"^"_""	   //IncisionNum
	Set InputStr = InputStr_"^"_""	   //IsSightGlass
	Set InputStr = InputStr_"^"_""	   //IsImplants
	Set InputStr = InputStr_"^"_""	   //LoseBlood
	Set InputStr = InputStr_"^"_""	   //GotBlood
	Set InputStr = InputStr_"^"_""	   //Complication
	Set InputStr = InputStr_"^"_IsActive
	Set InputStr = InputStr_"^"_UpdateDate
	Set InputStr = InputStr_"^"_UpdateTime
	Set InputStr = InputStr_"^"_OperStatus
	Set InputStr = InputStr_"^"_""	   //OROperTypeSoC
	Set InputStr = InputStr_"^"_""     //OperTypeValue
	Set InputStr = InputStr_"^"_OperSource
	Set InputStr = InputStr_"^"_OperTypeCode
	Set InputStr = InputStr_"^"_IsSubOper
	Set InputStr = InputStr_"^"_Assistant1ID
	Set InputStr = InputStr_"^"_Assistant2ID
	Set InputStr = InputStr_"^"_NarcosisDocID
	Set InputStr = InputStr_"^"_OperLevelCode
	Set InputStr = InputStr_"^"_OperLevelDesc
	Set InputStr = InputStr_"^"_MainOperCode
	Set InputStr = InputStr_"^"_MainOperDesc
	Set InputStr = InputStr_"^"_TypeCode
	Set InputStr = InputStr_"^"_TypeDesc
	Set InputStr = InputStr_"^"_Index
	Set InputStr = InputStr_"^"_NarcosisLevelCode
	Set InputStr = InputStr_"^"_NarcosisLevelDesc
	Set InputStr = InputStr_"^"_OperSiteCode
	Set InputStr = InputStr_"^"_OperSiteDesc
	Set InputStr = InputStr_"^"_BackOperCode
	Set InputStr = InputStr_"^"_BackOperDesc
	Set InputStr = InputStr_"^"_NNISLevelCode
	Set InputStr = InputStr_"^"_NNISLevelDesc
	Set InputStr = InputStr_"^"_IsEmergencyCode
	Set InputStr = InputStr_"^"_IsEmergencyDesc
	Set InputStr = InputStr_"^"_IsMiniInvaCode
	Set InputStr = InputStr_"^"_IsMiniInvaDesc
	Set InputStr = InputStr_"^"_IsChooseDateCode
	Set InputStr = InputStr_"^"_IsChooseDateDesc
	Set InputStr = InputStr_"^"_NarcosisSttDate
	Set InputStr = InputStr_"^"_NarcosisSttTime
	Set InputStr = InputStr_"^"_NarcosisEndDate
	Set InputStr = InputStr_"^"_NarcosisEndTime
	
	Set OperAnaeDr=##class(DHCHAI.DP.OROperAnaes).Update(InputStr,"^")
	If (+OperAnaeDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.OROperAnaes"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+OperAnaeDr)<1 return
	Set return=OperAnaeDr
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OREpisodeDr</Value>
</Value>
<Value name="3">
<Value>OROperICD</Value>
</Value>
<Value name="4">
<Value>OROperDesc</Value>
</Value>
<Value name="5">
<Value>OROperType</Value>
</Value>
<Value name="6">
<Value>OROperDate</Value>
</Value>
<Value name="7">
<Value>ORSttTime</Value>
</Value>
<Value name="8">
<Value>OREndDate</Value>
</Value>
<Value name="9">
<Value>OREndTime</Value>
</Value>
<Value name="10">
<Value>OROperHour</Value>
</Value>
<Value name="11">
<Value>OROperLocDr</Value>
</Value>
<Value name="12">
<Value>OROperLoc</Value>
</Value>
<Value name="13">
<Value>OROpertor</Value>
</Value>
<Value name="14">
<Value>ORAssistant1</Value>
</Value>
<Value name="15">
<Value>ORAssistant2</Value>
</Value>
<Value name="16">
<Value>ORIncision</Value>
</Value>
<Value name="17">
<Value>ORHealing</Value>
</Value>
<Value name="18">
<Value>ORAnesMethod</Value>
</Value>
<Value name="19">
<Value>ORAnesthesia</Value>
</Value>
<Value name="20">
<Value>ORASAScore</Value>
</Value>
<Value name="21">
<Value>ORNNISGrade</Value>
</Value>
<Value name="22">
<Value>ORSCode</Value>
</Value>
<Value name="23">
<Value>ORXCode</Value>
</Value>
<Value name="24">
<Value>ORWBC</Value>
</Value>
<Value name="25">
<Value>ORIncisionNum</Value>
</Value>
<Value name="26">
<Value>ORIsSightGlass</Value>
</Value>
<Value name="27">
<Value>ORIsImplants</Value>
</Value>
<Value name="28">
<Value>ORLoseBlood</Value>
</Value>
<Value name="29">
<Value>ORGotBlood</Value>
</Value>
<Value name="30">
<Value>ORComplication</Value>
</Value>
<Value name="31">
<Value>ORIsActive</Value>
</Value>
<Value name="32">
<Value>ORUpdateDate</Value>
</Value>
<Value name="33">
<Value>ORUpdateTime</Value>
</Value>
<Value name="34">
<Value>OROperStatus</Value>
</Value>
<Value name="35">
<Value>OROperTypeSoC</Value>
</Value>
<Value name="36">
<Value>OROperCatDrs</Value>
</Value>
<Value name="37">
<Value>OROperTypeValue</Value>
</Value>
<Value name="38">
<Value>OROperSource</Value>
</Value>
<Value name="39">
<Value>OROperTypeCode</Value>
</Value>
<Value name="40">
<Value>IsSubOper</Value>
</Value>
<Value name="41">
<Value>Assistant1ID</Value>
</Value>
<Value name="42">
<Value>Assistant2ID</Value>
</Value>
<Value name="43">
<Value>NarcosisDocID</Value>
</Value>
<Value name="44">
<Value>OperLevelCode</Value>
</Value>
<Value name="45">
<Value>OperLevelDesc</Value>
</Value>
<Value name="46">
<Value>MainOperCode</Value>
</Value>
<Value name="47">
<Value>MainOperDesc</Value>
</Value>
<Value name="48">
<Value>TypeCode</Value>
</Value>
<Value name="49">
<Value>TypeDesc</Value>
</Value>
<Value name="50">
<Value>Index</Value>
</Value>
<Value name="51">
<Value>AisOperID</Value>
</Value>
<Value name="52">
<Value>NarcosisLevelCode</Value>
</Value>
<Value name="53">
<Value>NarcosisLevelDesc</Value>
</Value>
<Value name="54">
<Value>OperSiteCode</Value>
</Value>
<Value name="55">
<Value>OperSiteDesc</Value>
</Value>
<Value name="56">
<Value>BackOperCode</Value>
</Value>
<Value name="57">
<Value>BackOperDesc</Value>
</Value>
<Value name="58">
<Value>NNISLevelCode</Value>
</Value>
<Value name="59">
<Value>NNISLevelDesc</Value>
</Value>
<Value name="60">
<Value>IsEmergencyCode</Value>
</Value>
<Value name="61">
<Value>IsEmergencyDesc</Value>
</Value>
<Value name="62">
<Value>IsMiniInvaCode</Value>
</Value>
<Value name="63">
<Value>IsMiniInvaDesc</Value>
</Value>
<Value name="64">
<Value>IsChooseDateCode</Value>
</Value>
<Value name="65">
<Value>IsChooseDateDesc</Value>
</Value>
<Value name="66">
<Value>NarcosisSttDate</Value>
</Value>
<Value name="67">
<Value>NarcosisSttTime</Value>
</Value>
<Value name="68">
<Value>NarcosisEndDate</Value>
</Value>
<Value name="69">
<Value>NarcosisEndTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OROperAnaesD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OROperAnaesD</IdLocation>
<IndexLocation>^DHCHAI.DP.OROperAnaesI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OROperAnaesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

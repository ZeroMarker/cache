/// 名称: DHCHAI.DP.OROperation
/// 描述: 手术编目信息
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OROperation Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property OREpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 手术ICD
Property OROperICD As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术名称
Property OROperDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 手术类型
Property OROperType As %String(MAXLEN = 100, TRUNCATE = 1);

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

/// 手术来源（E首页、F编目）
Property OROperSource As %String(DISPLAYLIST = ",E,F", VALUELIST = ",E,F") [ Required ];

/// 子系统代码
Property ORSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property ORXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property ORIsActive As %Boolean [ Required ];

/// 更新日期
Property ORUpdateDate As %Date [ Required ];

/// 更新时间
Property ORUpdateTime As %Time [ Required ];

/// 手术分类
Property OROperCatDrs As %String(MAXLEN = 200, TRUNCATE = 1);

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

/// 临床手术ID(手麻表id)
Property AisOperID As %String(MAXLEN = 100, TRUNCATE = 1);

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

/// 手术开始日期索引
Index IndexOperDateTime On OROperDate;

/// 手术开始日期切口等级索引
Index IndexOperDateTimeIncision On (OROperDate, ORIncision As Exact);

/// 手术开始日期手术来源索引
Index IndexOperDateTimeOROperSource On (OROperDate, OROperSource As Exact);

/// 子系统代码+记录索引码 索引
Index IndexSCodeXCode On (ORSCode As Exact, ORXCode As Exact);

/// 子系统代码+就诊记录+是否有效 索引
Index IndexSCodeEpiDrActive On (ORSCode As Exact, OREpisodeDr As Exact, ORIsActive As Exact);

/// add 20191211
/// 就诊记录 + 手术开始日期 索引
Index IndexEpisodeDrOperDate On (OREpisodeDr, OROperDate);

/// 更新日期 索引
Index IndexEpisUpdateDate On (OREpisodeDr, ORUpdateDate);

/// 临床手术ID 索引
Index IndexEpisAisOper On (OREpisodeDr, AisOperID);

/// Creator：     zhufei
/// CreatDate：   2018-03-10
/// Description:  根据ID作废首页手术
/// Table：       DHCHAI.DP.OROperation
/// Input：       id:    DHCHAI.DP.OROperation.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperation).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.OROperation).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.ORIsActive		= 0
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
/// Description:  根据ID取手术编目信息
/// Table：       DHCHAI.DP.OROperation
/// Input：       ID:    DHCHAI.DP.OROperation.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperation).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OROperation
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OROperation).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OROperation).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  根据子系统代码+就诊记录+是否有效索引把当前病人的全部置为无效状态
/// Table：       DHCHAI.DP.OROperation
/// Input：       aSCode:      子系统代码
/// 			  aPaadmAdmDr: 就诊记录ID
/// 			  aIsActive:   是否有效
/// Return：      返回String
/// w ##class(DHCHAI.DP.OROperation).SetObjNoActive("OP01","","1")
ClassMethod SetObjNoActive(aSCode As %String, aPaadmAdmDr As %String, aIsActive As %String = "1") As DHCHAI.DP.OROperation
{
	New (aSCode,aPaadmAdmDr,aIsActive)
	Set return=""
	Quit:(aSCode="")||(aPaadmAdmDr="") return
	Set id=""
	For {
		Set id = $o(^DHCHAI.DP.OROperationI("IndexSCodeEpiDrActive",aSCode,aPaadmAdmDr,aIsActive,id))
		Quit:id=""
		Set obj=##class(DHCHAI.DP.OROperation).%OpenId(id)
		Continue:'$IsObject(obj)
		
		Set obj.ORIsActive = 0
		
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  根据索引码取手术编目信息
/// Table：       DHCHAI.DP.OROperation
/// Input：       aSCode:DHCHAI.DP.OROperation.ORSCode
/// 			  aXCode:DHCHAI.DP.OROperation.ORXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperation).GetObjByXCode("MR","9225||1")
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.OROperation
{
	New (aSCode,aXCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id = $o(^DHCHAI.DP.OROperationI("IndexSCodeXCode",aSCode,aXCode,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新手术编目信息
/// Table：       DHCHAI.DP.OROperation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperation).Update("^1^93.090^破宫产^择期^2017-01-01^18:00:00^2017-01-01^19:00:00^1^妇产科^Doctoer Wang^DC001^一助^二助^I^愈合情况^全身麻醉^麻醉医生^1^1^OR01^12^1^2017-01-01^21:00:00")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID					= $p(InStr,aSeparete,1)
	Set EpisodeDr			= $p(InStr,aSeparete,2)
	Set OperICD				= $p(InStr,aSeparete,3)
	Set OperDesc			= $p(InStr,aSeparete,4)
	Set OperType			= $p(InStr,aSeparete,5)
	Set OperDate			= $p(InStr,aSeparete,6)
	Set SttTime				= $p(InStr,aSeparete,7)
	Set EndDate				= $p(InStr,aSeparete,8)
	Set EndTime				= $p(InStr,aSeparete,9)
	Set OperHour			= $p(InStr,aSeparete,10)
	Set OperLocDr			= $p(InStr,aSeparete,11)
	Set OperLoc	    		= $p(InStr,aSeparete,12)
	Set Opertor	    		= $p(InStr,aSeparete,13)
	Set Assistant1			= $p(InStr,aSeparete,14)
	Set Assistant2			= $p(InStr,aSeparete,15)
	Set Incision			= $p(InStr,aSeparete,16)
	Set Healing				= $p(InStr,aSeparete,17)
	Set AnesMethod			= $p(InStr,aSeparete,18)
	Set Anesthesia			= $p(InStr,aSeparete,19)
	Set ASAScore			= $p(InStr,aSeparete,20)
	Set NNISGrade			= $p(InStr,aSeparete,21)
	Set OperSource 		 	= $p(InStr,aSeparete,22)
	Set SCode				= $p(InStr,aSeparete,23)
	Set XCode				= $p(InStr,aSeparete,24)
	Set IsActive			= +$p(InStr,aSeparete,25)
	Set UpdateDate			= $p(InStr,aSeparete,26)
	Set UpdateTime			= $p(InStr,aSeparete,27)
	Set OperTypeCode		= $p(InStr,aSeparete,28)
	Set IsSubOper			= $p(InStr,aSeparete,29)
	Set Assistant1ID		= $p(InStr,aSeparete,30)
	Set Assistant2ID		= $p(InStr,aSeparete,31)
	Set NarcosisDocID		= $p(InStr,aSeparete,32)
	Set OperLevelCode		= $p(InStr,aSeparete,33)
	Set OperLevelDesc		= $p(InStr,aSeparete,34)
	Set MainOperCode		= $p(InStr,aSeparete,35)
	Set MainOperDesc		= $p(InStr,aSeparete,36)
	Set TypeCode			= $p(InStr,aSeparete,37)
	Set TypeDesc			= $p(InStr,aSeparete,38)
	Set Index				= $p(InStr,aSeparete,39)
	Set AisOperID			= $p(InStr,aSeparete,40)
	Set NarcosisLevelCode	= $p(InStr,aSeparete,41)
	Set NarcosisLevelDesc	= $p(InStr,aSeparete,42)
	Set OperSiteCode		= $p(InStr,aSeparete,43)
	Set OperSiteDesc		= $p(InStr,aSeparete,44)
	Set BackOperCode		= $p(InStr,aSeparete,45)
	Set BackOperDesc		= $p(InStr,aSeparete,46)
	Set NNISLevelCode		= $p(InStr,aSeparete,47)
	Set NNISLevelDesc		= $p(InStr,aSeparete,48)
	Set IsEmergencyCode		= $p(InStr,aSeparete,49)
	Set IsEmergencyDesc		= $p(InStr,aSeparete,50)
	Set IsMiniInvaCode		= $p(InStr,aSeparete,51)
	Set IsMiniInvaDesc		= $p(InStr,aSeparete,52)
	Set IsChooseDateCode	= $p(InStr,aSeparete,53)
	Set IsChooseDateDesc	= $p(InStr,aSeparete,54)
	Set NarcosisSttDate		= $p(InStr,aSeparete,55)
	Set NarcosisSttTime		= $p(InStr,aSeparete,56)
	Set NarcosisEndDate		= $p(InStr,aSeparete,57)
	Set NarcosisEndTime		= $p(InStr,aSeparete,58)
	
	Set:OperDate["-" OperDate = $zdh(OperDate,3)
	Set:SttTime[":" SttTime = $zth(SttTime,1)
	Set:EndDate["-" EndDate = $zdh(EndDate,3)
	Set:EndTime[":" EndTime = $zth(EndTime,1)
	Set:UpdateDate["-" UpdateDate = $zdh(UpdateDate,3)
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:NarcosisSttDate["-" NarcosisSttDate = $zdh(NarcosisSttDate,3)
	Set:NarcosisSttTime[":" NarcosisSttTime = $zth(NarcosisSttTime,1)
	Set:NarcosisEndDate["-" NarcosisEndDate = $zdh(NarcosisEndDate,3)
	Set:NarcosisEndTime[":" NarcosisEndTime = $zth(NarcosisEndTime,1)

	Quit:(EpisodeDr="")||(OperDesc="")||(OperDate="")||(SCode="")||(XCode="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	Set objOperLoc = ##class(DHCHAI.BT.Location).GetObjById(OperLocDr)

	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.OROperationI("IndexSCodeXCode",SCode,XCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	Set obj =""
	if ID="" {
	
		Set obj=##class(DHCHAI.DP.OROperation).%New()
	
	}else{
		Set obj=##class(DHCHAI.DP.OROperation).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set OperCatDrs  = ##Class(DHCHAI.IRS.CRuleOperCatSrv).CheckKeyCat(OperICD,OperDesc)
		
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
	Set obj.ORAssistant2	= Assistant2
	Set obj.ORIncision		= Incision
	Set obj.ORHealing		= Healing
	Set obj.ORAnesMethod	= AnesMethod
	Set obj.ORAnesthesia	= Anesthesia
	Set obj.ORASAScore		= ASAScore
	Set obj.ORNNISGrade		= NNISGrade
	Set obj.OROperSource    = OperSource
	Set obj.ORSCode			= SCode
	Set obj.ORXCode			= XCode
	Set obj.ORIsActive		= IsActive
	Set obj.ORUpdateDate	= UpdateDate
	Set obj.ORUpdateTime	= UpdateTime
	Set obj.OROperCatDrs	= OperCatDrs
	Set obj.OROperTypeCode	= OperTypeCode
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
	Set obj.AisOperID		= AisOperID
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
/// Description:  删除手术编目信息
/// Table：       DHCHAI.DP.OROperation
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OROperation).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
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
<Value>OROperSource</Value>
</Value>
<Value name="23">
<Value>ORSCode</Value>
</Value>
<Value name="24">
<Value>ORXCode</Value>
</Value>
<Value name="25">
<Value>ORIsActive</Value>
</Value>
<Value name="26">
<Value>ORUpdateDate</Value>
</Value>
<Value name="27">
<Value>ORUpdateTime</Value>
</Value>
<Value name="28">
<Value>OROperCatDrs</Value>
</Value>
<Value name="29">
<Value>OROperTypeCode</Value>
</Value>
<Value name="30">
<Value>IsSubOper</Value>
</Value>
<Value name="31">
<Value>Assistant1ID</Value>
</Value>
<Value name="32">
<Value>Assistant2ID</Value>
</Value>
<Value name="33">
<Value>NarcosisDocID</Value>
</Value>
<Value name="34">
<Value>OperLevelCode</Value>
</Value>
<Value name="35">
<Value>OperLevelDesc</Value>
</Value>
<Value name="36">
<Value>MainOperCode</Value>
</Value>
<Value name="37">
<Value>MainOperDesc</Value>
</Value>
<Value name="38">
<Value>TypeCode</Value>
</Value>
<Value name="39">
<Value>TypeDesc</Value>
</Value>
<Value name="40">
<Value>Index</Value>
</Value>
<Value name="41">
<Value>AisOperID</Value>
</Value>
<Value name="42">
<Value>NarcosisLevelCode</Value>
</Value>
<Value name="43">
<Value>NarcosisLevelDesc</Value>
</Value>
<Value name="44">
<Value>OperSiteCode</Value>
</Value>
<Value name="45">
<Value>OperSiteDesc</Value>
</Value>
<Value name="46">
<Value>BackOperCode</Value>
</Value>
<Value name="47">
<Value>BackOperDesc</Value>
</Value>
<Value name="48">
<Value>NNISLevelCode</Value>
</Value>
<Value name="49">
<Value>NNISLevelDesc</Value>
</Value>
<Value name="50">
<Value>IsEmergencyCode</Value>
</Value>
<Value name="51">
<Value>IsEmergencyDesc</Value>
</Value>
<Value name="52">
<Value>IsMiniInvaCode</Value>
</Value>
<Value name="53">
<Value>IsMiniInvaDesc</Value>
</Value>
<Value name="54">
<Value>IsChooseDateCode</Value>
</Value>
<Value name="55">
<Value>IsChooseDateDesc</Value>
</Value>
<Value name="56">
<Value>NarcosisSttDate</Value>
</Value>
<Value name="57">
<Value>NarcosisSttTime</Value>
</Value>
<Value name="58">
<Value>NarcosisEndDate</Value>
</Value>
<Value name="59">
<Value>NarcosisEndTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OROperationD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OROperationD</IdLocation>
<IndexLocation>^DHCHAI.DP.OROperationI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OROperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

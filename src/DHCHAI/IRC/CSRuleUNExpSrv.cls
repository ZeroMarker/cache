/// 名称: DHCHAI.IRC.CSRuleUNExpSrv
/// 描述: 疑似病例筛查组合规则
/// 编写者：pylian
/// 编写日期: 2022-05-06
Class DHCHAI.IRC.CSRuleUNExpSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据筛查结果返回数组
/// set arr=##class(DHCHAI.IRC.CSRuleUNExpSrv).GetSuRuleResult(300,$h-800,$h-1)
/// do $system.OBJ.Dump(arr)
ClassMethod GetSuRuleResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, aIsCntNeg As %String = "1", aIsShowNeg As %String = "1") As %ArrayOfDataTypes
{
	New (aEpisodeDr,aDateFrom,aDateTo,aIsCntNeg,aIsShowNeg)
	
	//输出结果
	Set result=##Class(%ArrayOfDataTypes).%New()

	Set flg=##class(DHCHAI.IRC.CSRuleUNExpSrv).GetResult(aEpisodeDr,"DIAG1",1,1,aDateFrom,aDateTo,.result)
	Set flg=##class(DHCHAI.IRC.CSRuleUNExpSrv).GetResult(aEpisodeDr,"DIAG2",1,1,aDateFrom,aDateTo,.result)
	
	Quit result
}

/// w ##Class(DHCHAI.IRC.CSRuleUNExpSrv).Test(442,$zdh("2020-05-01",3),$zdh("2020-12-31",3))
ClassMethod Test(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo)
	Set arr=##class(DHCHAI.IRC.CSRuleUNExpSrv).GetSuRuleResult(aEpisodeDr,aDateFrom,aDateTo,1,1)
	For indArr=1:1:arr.Count() {
		Set obj=arr.GetAt(indArr)
		Continue:'$IsObject(obj)
		
		Do $system.OBJ.Dump(obj)
	
		Set OutputStr=indArr
		Set OutputStr=OutputStr_"-"_obj.CSIsActive
		Set OutputStr=OutputStr_"-"_obj.CSRstStatus          //结果状态(0触发疑似指标、1触发组合条件、2作废|感染诊断)
		Set OutputStr=OutputStr_"-"_obj.CSItmScreenDr.%Id()  //筛查项目
		Set OutputStr=OutputStr_"|"_obj.CSItmScreenDr.CCDesc 
		Set OutputStr=OutputStr_"|"_obj.CSResultNote
		Set OutputStr=OutputStr_"|"_obj.CSItmScreenTxt
		Set OutputStr=OutputStr_"|"_obj.CSResultDate      //结果日期
		Set OutputStr=OutputStr_"|"_obj.CSResultCnt       //结果数量
		Set OutputStr=OutputStr_"|"_obj.CSRstFromDate     //结果开始日期
		Set OutputStr=OutputStr_"|"_obj.CSRstToDate       //结果截止日期
		Set OutputStr=OutputStr_"|"_obj.CSInfSuKeys       //疑似诊断关键词信息
		Set OutputStr=OutputStr_"|"_obj.CSInfSuPosDr   //(新增)疑似诊断（部位）ID
		Set OutputStr=OutputStr_"|"_obj.CSInfSuDate    //(新增)推荐感染日期
		Set OutputStr=OutputStr_"|"_obj.CSSpecimen     //(新增)标本名称（多值#分隔）
		Set OutputStr=OutputStr_"|"_obj.CSMRBType      //(新增)多耐分类名称（多值#分隔）
		Set OutputStr=OutputStr_"|"_obj.CSInfSuRuleDr  //(新增)规则ID（多值#分隔）
		Set OutputStr=OutputStr_"|"_obj.CSOprStatus
		Set OutputStr=OutputStr_"|"_obj.CSDetails
		
		Write OutputStr,!
		
	}
	Quit "OK"
}

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).GetResult()
ClassMethod GetResult(aEpisodeDr As %String, aRuleType As %String, aIsCntNeg As %String = "1", aIsShowNeg As %String = "1", aDateFrom As %String, aDateTo As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,aRuleType,aIsCntNeg,aIsShowNeg,aDateFrom,aDateTo,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="")||(aRuleType="")||(aDateFrom="")||(aDateTo="") return
	Quit:'$IsObject(%ArrayResult) return
	
	//规则表达式
	
	Kill arrRuleExp
	Kill arrRstDate
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," "_$zcvt(aRuleType,"U"),xRuleDr))
		Quit:xRuleDr=""
		
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(xRuleDr)
		Continue:'$IsObject(objRule)
		Continue:objRule.BTIsActive'=1
		Continue:'$IsObject(objRule.BTItmScreenDr)
		Set ItmScreenDr=objRule.BTItmScreenDr.%Id()
		Set ItmScreenDesc=objRule.BTItmScreenDr.CCDesc
		Set ItmScreenDesc2=objRule.BTItmScreenDr.CCDesc2
		Set:ItmScreenDesc2'="" ItmScreenDesc=ItmScreenDesc2
	
		Set RuleNote = objRule.BTRuleNote
		Set Threshold = objRule.BTThreshold     //阈值（总分）
		Continue:(Threshold=0)||(Threshold="")
	
		Set (InfPosID,InfPosDesc) = ""
		If $IsObject(objRule.BTSuPosDr) {	
			Set InfPosID =  objRule.BTSuPosDr.%Id()  
			Set InfPosDesc = objRule.BTSuPosDr.BTDiagnos
	    }
	    Set DateFrom=aDateFrom
		Set RuleExpList="",Score=0
		Set xChildSub = ""
		For {
			Set xChildSub = $o(^DHCHAI.IR.CRuleInfSuRuleD(xRuleDr,"EXP",xChildSub))
			Quit:xChildSub=""
			
			Set RuleExpID = xRuleDr_"||"_xChildSub
			Set obj = ##class(DHCHAI.IR.CRuleInfSuRuleExp).GetObjById(RuleExpID)
			Continue:'$Isobject(obj)
			
			Set ItemDesc    = obj.BTItemDesc   
			Set InputDicSet = obj.BTInputDicSet
			Set InputMaxSet = +obj.BTInputMaxSet
			Set InputMinSet = +obj.BTInputMinSet
			Set InputDaySet = +obj.BTInputDaySet
			Set InputCntSet = +obj.BTInputCntSet
			Set InputNote   = obj.BTInputNote  
			Set Weight      = obj.BTWeight 
			
			Set SuItemDr=$o(^DHCHAI.IR.CRuleInfSuItemI("IdxOfItemDesc"," "_$zcvt(ItemDesc,"U"),0))
			Set objSuItem = ##class(DHCHAI.IR.CRuleInfSuItem).GetObjById(SuItemDr)
			Continue:'$Isobject(objSuItem)
			Set ItemCate=objSuItem.BTCategory
			
			Set flg=0
			If (ItemCate="细菌检测") {
				Set flg=..CheckLabBact(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="检验项目异常") {
				Set flg=..CheckTestAb(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="体温异常") {
				Set flg=..CheckIsFever(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="大便次数") {
				Set flg=..CheckObsDiarr(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="临床诊断") {
				Set flg=..CheckDiagnos(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="清创术") {
				Set flg=..CheckOpsDebride(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="手术") {
				Set flg=..CheckOpsName(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="医嘱") {
				Set flg=..CheckOrdItem(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="病程症状或体征") {
				Set flg=..CheckEMRSym(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}
			If (ItemCate="影像检查") {
				Set flg=..CheckRISDiag(xRuleDr,xChildSub,ItemDesc,aEpisodeDr,DateFrom,aDateTo)
			}		
			
			If (+flg=1){
				Set:InputNote'="" ItemDesc=InputNote
				Set Score=Score+Weight
				Set:(aIsCntNeg=0)&(Weight<0) Score=Score+$ZABS(Weight)   //负值是否参与权重运算(不能直接赋值Weight，影响展示)
				Continue:(aIsShowNeg=0)&(Weight<0)      //负值是否显示
				
				Set KeyWord=$p(flg,",",2)
				Set ActDates=$p(flg,",",3)
				For indD=1:1:$l(ActDates,"#") {
					Set ResultDate=$p(ActDates,"#",indD)
					Set arrRstDate(ResultDate)=""
				}	
				Set RuleExpList=RuleExpList_$lb(ItemDesc_"(权重: "_Weight_")"_" ("_$zd($p(ActDates,"#",1),3)_": "_KeyWord_")")
			}
		}
		Continue:Score<Threshold
		
		Set ResultDates="",InfSuDate=""
		Set xRstDate=0
		For {
			Set xRstDate=$o(arrRstDate(xRstDate))
			Quit:xRstDate=""
			Set:InfSuDate="" InfSuDate=xRstDate   //取首次异常日期
			Set ResultDates=ResultDates_$lb(xRstDate)
		}
		
		Set ItmScreenTxt=InfPosID			
		Set ResultNote=##class(DHCHAI.Utils.CommonSrv).ListToString(RuleExpList,"#")
		Set ResultNote=$replace(ResultNote,"#","<br>")
		Set ResultDate=ResultDates
		
		Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenDr)
		Continue:'$IsObject(obj)
		Set obj.CSItmScreenTxt = ItmScreenTxt    //附加项目描述
		Set obj.CSResultNote   = ResultNote_"<br><span style=font-weight:700;>总权重: "_Score_"</span>"     //显示结果
		Set obj.CSResultDate   = ResultDate      //结果日期
		Set obj.CSResultCnt    = ""              //结果数量
		Set obj.CSInfSuKeys    = ""              //疑似关键词
		Set obj.CSInfSuPosDr   = InfPosID        //推荐感染部位
		Set obj.CSInfSuDate    = InfSuDate       //推荐感染日期
		Set obj.CSInfSuRuleDr  = xRuleDr         //规则(多值#分隔)
		Set obj.CSRstStatus    = 1               //结果状态(0触发疑似指标、1触发组合条件)
		
		Set ArrCnt=%ArrayResult.Count()
		Do %ArrayResult.SetAt(obj,ArrCnt+1)
		
	}
	
	Kill arrRuleExp
	Kill arrRstDate
	
	Set return=%ArrayResult.Count()
	Quit return
}

/// 判断限定天数是否满足(1:48H后，0:48H内)
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst()
ClassMethod CheckIs48HourRst(obj As DHCHAI.IR.CCResult, aLimitDay As %String, aTimeFlag As %String = 0) As %String
{
	New (obj,aLimitDay,aTimeFlag)
	Set return=0
	Quit:'$IsObject(obj) return
	
	//判断入院48小时项目过滤
	//同行新算法按日历算，入院2个日历日后，就是从第3天开始算
	Set AdmDate=obj.CCEpisodeDr.PAAdmDate
	Set AdmTime=obj.CCEpisodeDr.PAAdmTime

	If aTimeFlag=0 {
		Set ActDate=obj.CCActDate
		Set ActTime=obj.CCActTime
		Quit:ActDate<(AdmDate+aLimitDay) return
	} Else {
		Set ActDate=obj.CCRepDate
		Set ActTime=obj.CCRepTime
		Quit:ActDate<(AdmDate+aLimitDay) return
		Quit:(ActDate=(AdmDate+aLimitDay))&(ActTime<AdmTime) return
	}
	Set return=1
	Quit return
}

ClassMethod Check48HourFlg(aEpisodeID As %String, aSttDate As %String, aSttTime As %String, aLimitDay As %String, aTimeFlag As %String = 0) As %String
{
	New (aEpisodeID,aSttDate,aSttTime,aLimitDay,aTimeFlag)
	Set return=0
	Quit:aEpisodeID="" return
	//判断入院48小时项目过滤
	//同行新算法按日历算，入院2个日历日后，就是从第3天开始算
	Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	Set AdmDate=$lg(PAAdmData,20)
	Set AdmTime=$lg(PAAdmData,21)
	If aTimeFlag=0 {
		Quit:aSttDate<(AdmDate+aLimitDay) return
	} Else {
		Quit:aSttDate<(AdmDate+aLimitDay) return
		Quit:(aSttDate=(AdmDate+aLimitDay))&(aSttTime<AdmTime) return
	}
	Set return=1
	Quit return
}

/// 判断体温异常
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIsFever("41","","体温异常(+)","442",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckIsFever(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
	Quit:ArgStr="" return
	Set ObsMax=+$p(ArgStr,"^",2)   //体温上限
	Set ObsMin=+$p(ArgStr,"^",3)   //体温下限
	Set SerDay=+$p(ArgStr,"^",4)   //连续天数（暂不考虑连续发热）
	Set ObsCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数
  
	//MR-ObsFever	护理-发热
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set OperNextDateList=""
	Set:aRuleExp["术后" OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,SttDay)
	Quit:(aRuleExp["术后")&&(OperNextDateList="") return
	
	Set IsFever=0,Count=0,ActDates="",KeyWord=""
	Set xActDate=(aDateFrom-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		Quit:IsFever=1
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			Quit:IsFever=1
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		    Set Unit=obj.CCUnit
		    Set Result=obj.CCResult
			Set IsError=0
			If (ObsMax'=0)&&(Result>=ObsMax){
				Set IsError=1
			} ElseIf (ObsMin'=0)&&(Result<=ObsMin) {
				Set IsError=1
			}
			Continue:IsError<1
		    If (OperNextDateList'="") {   //术后体温异常
				Continue:(Weight>0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)>0))   //限定术后n天后，触发日期不能小于手术日期
				Continue:(Weight<=0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)<0))  //限定术后n天内，触发日期不能小于手术日期
			}Else {    //入院后体温异常
				Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst(obj,SttDay,0)
						Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
				Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
			}	
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
				Set Count=Count+1
				Continue:(ObsCnt>0)&(Count<ObsCnt)
			}				
			Set IsFever=1
			Set KeyWord="体温: "_Result_Unit
		}
	}
	Quit:IsFever'=1 return
	Set return=IsFever_","_KeyWord_","_$lts(ActDates,"#")
	Quit return
}

/// 大便次数异常
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckOpsDebride("40","腹泻(大便次数)","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckObsDiarr(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
    Kill arrResult
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
 	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set ObsMax=+$p(ArgStr,"^",2)   //大便次数上限
	Set ObsMin=+$p(ArgStr,"^",3)   //大便次下限
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数

	//MR-ObsDiarr	护理-腹泻
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsDiarr")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set IsObs=0,Count=0,ActDates=""
	Set xActDate=(aDateFrom-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		Quit:IsObs=1
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			Quit:IsObs=1
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		    
		    Set IsObsDiarr=0
		    Set Result=obj.CCResult
		    If Result["※" {    //※表示腹泻
				Set IsObsDiarr=1
			} Else {
				Set Result=+Result
				If (ObsMax'="")&&(Result>=ObsMax) {
					Set IsObsDiarr=1
				}
			}
		    Continue:IsObsDiarr<1
		    
		  	Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst(obj,SttDay,0)
			Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
			Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
			}
			Set arrResult(ActDate)=""
			//判断是否持续腹泻SerDay天
			Set CurrActDate=0,AbCnt=0
			Set yActDate=(ActDate-SerDay)
			For {
				Set yActDate=$o(arrResult(yActDate))
				Quit:yActDate=""
				Quit:yActDate>(ActDate+SerDay-1)
				
				If (yActDate-CurrActDate)>1 {
					Set AbCnt=1
				} Else {
					Set AbCnt=AbCnt+1
				}
				Set CurrActDate=yActDate
			}
			Continue:AbCnt<SerDay
			
			Set IsObs=1
		}
	}
	Quit:IsObs'=1 return
	Set return=IsObs_","_"大便次数异常"_","_$lts(ActDates,"#")
	
	Kill arrResult
	Quit return
}

/// 判断检出菌
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckLabBact("42","","特定标本检出菌","442",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckLabBact(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
 
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数

	//LAB-Bacteria	检验-检出菌
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set OperNextDateList="",OperSerDateList="",SerEndDate=""
	Set:aRuleExp["术后" OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,SttDay)
	Quit:(aRuleExp["术后")&&(OperNextDateList="") return
	Set:(aRuleExp["术后")&(SerDay>0) OperSerDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,(SttDay+SerDay)) 
	Set:$ll(OperSerDateList)>0 SerEndDate=$lg(OperSerDateList,$ll(OperSerDateList))
	Set Flg=0
	Set:aRuleExp["特定标本" Flg=1
	Set:aRuleExp["特定细菌" Flg=2
	
	Set IsLabBact=0,Count=0,ActDates="",KeyWord=""
	Set xActDate=(aDateFrom-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		Quit:IsLabBact=1
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			Quit:IsLabBact=1
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		   
		    Set Result=obj.CCResult
			//标本
			Set Specimen=obj.CCSpecimen
			Continue:Specimen=""			
			Set objSpecMap=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			If $IsObject(objSpecMap) {
				Continue:objSpecMap.BTIsActive'=1
				If $IsObject(objSpecMap.BTMapItemDr) {
					Continue:objSpecMap.BTMapItemDr.BTIsActive'=1
					Set Specimen=objSpecMap.BTMapItemDr.BTSpecDesc
				}
			}
			Continue:Specimen=""
			Continue:(Flg=1)&&(("#"_DicSet_"#")'[("#"_Specimen_"#"))   //限定标本项目
			
			//细菌
			Set Bacteria=obj.CCBacteria   
			Continue:Bacteria=""   
			Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
			If $IsObject(objBactMap){
				Continue:objBactMap.BTIsActive'=1
				If $IsObject(objBactMap.BTMapItemDr){
					Set Bacteria=objBactMap.BTMapItemDr.BTBacDesc
				}
			}
			Continue:Bacteria=""
			Set Bacteria=$tr(Bacteria,",","，")
			Continue:(Flg=2)&&(("#"_DicSet_"#")'[("#"_Bacteria_"#"))   //限定细菌项目
			
		    If (OperNextDateList'="") {   //术后
				Continue:(Weight>0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)>0)||((SerEndDate'="")&&(ActDate>SerEndDate)))   //限定术后n天后，触发日期不能小于手术日期,不能大于持续天数最后一天
				Continue:(Weight<=0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)<0))  //限定术后n天内，触发日期不能小于手术日期
			}Else {    //入院后
				Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst(obj,SttDay,0)
				Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
				Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
			}	
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
				Set Count=Count+1
				Continue:(LimCnt>0)&(Count<LimCnt)
			}				
			Set IsLabBact=1
			Set KeyWord=Bacteria_"("_Specimen_")"
		}
	}
	Quit:IsLabBact'=1 return
	Set return=IsLabBact_","_KeyWord_","_$lts(ActDates,"#")
	Quit return
}

/// 判断常规检验异常
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckTestAb("40","体温异常(正值)","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckTestAb(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
 	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数

	//LAB-TestAb	检验-常规检验异常
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-TestAb")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set OperNextDateList="",OperSerDateList="",SerEndDate=""
	Set:aRuleExp["术后" OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,SttDay)
	Quit:(aRuleExp["术后")&&(OperNextDateList="") return
	Set:(aRuleExp["术后")&(SerDay>0) OperSerDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,(SttDay+SerDay)) 
	Set:$ll(OperSerDateList)>0 SerEndDate=$lg(OperSerDateList,$ll(OperSerDateList))

	Set IsTestAb=0,Count=0,ActDates="",Summary=""
	Set xActDate=(aDateFrom-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		Quit:IsTestAb=1
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			Quit:IsTestAb=1
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		   
		    Set Summary=obj.CCSummary
		    Set Unit=obj.CCUnit
		    Set Result=obj.CCResult
			//关键词
			Set KeyWord=obj.CCKeyWordDr.CCDesc
			//Continue:DicSet'=KeyWord       //检验医嘱限定
			Set ObjectID=obj.CCObjectID
			Set LabItemCode=$p(obj.CCObjectID,"||",3)
			Set:LabItemCode="" LabItemCode=$p(obj.CCObjectID,"||",2)
			Continue:DicSet'=LabItemCode   //检验项目限定
			
		    If (OperNextDateList'="") {   //术后
				Continue:(Weight>0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)>0)||((SerEndDate'="")&&(ActDate>SerEndDate)))   //限定术后n天后，触发日期不能小于手术日期,不能大于持续天数最后一天
				Continue:(Weight<=0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)<0))  //限定术后n天内，触发日期不能小于手术日期
			}Else {    //入院后
				Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst(obj,SttDay,0)
				Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
				Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
			}	
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
				Set Count=Count+1
				Continue:(LimCnt>0)&(Count<LimCnt)
			}				
			Set IsTestAb=1
			Set Summary=Summary_Unit
		}
	}
	Quit:IsTestAb'=1 return
	Set return=IsTestAb_","_Summary_","_$lts(ActDates,"#")
	Quit return
}

/// 病程（症状体征）
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckEMRSym("40","体温异常(正值)","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckEMRSym(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数

	//RME-Radiology	语义-症状或体征
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-Symptom")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set OperNextDateList="",OperSerDateList="",SerEndDate=""
	Set:aRuleExp["术后" OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,SttDay)
	Quit:(aRuleExp["术后")&&(OperNextDateList="") return
	Set:(aRuleExp["术后")&(SerDay>0) OperSerDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,(SttDay+SerDay)) 
	Set:$ll(OperSerDateList)>0 SerEndDate=$lg(OperSerDateList,$ll(OperSerDateList))

	Set IsSymptom=0,Count=0,ActDates="",Symptom=""
	Set xActDate=(aDateFrom-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		Quit:IsSymptom=1
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			Quit:IsSymptom=1
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		   
		    Set Result=obj.CCResult
		    Set IsSym = 0
			For len=1:1:$l(Result,";") {
				Set KeyWord= $p(Result,";",len)
				Continue:KeyWord=""
				Continue:("#"_DicSet_"#")'[("#"_KeyWord_"#")  //名称过滤
				Set IsSym=1
			}
			Continue:IsSym<1
			
		    If (OperNextDateList'="") {   //术后
				Continue:(Weight>0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)>0)||((SerEndDate'="")&&(ActDate>SerEndDate)))   //限定术后n天后，触发日期不能小于手术日期,不能大于持续天数最后一天
				Continue:(Weight<=0)&&((ActDate<$lg(OperNextDateList,1))||($listfind(OperNextDateList,ActDate)<0))  //限定术后n天内，触发日期不能小于手术日期
			}Else {    //入院后
				Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst(obj,SttDay,0)
				Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
				Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
			}	
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
				Set Count=Count+1
				Continue:(LimCnt>0)&(Count<LimCnt)
			}				
			Set IsSymptom=1
			Set Symptom=Result
		}
	}
	Quit:IsSymptom'=1 return
	Set return=IsSymptom_","_Symptom_","_$lts(ActDates,"#")
	Quit return
}

/// 清创术
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckOpsDebride("40","体温异常(正值)","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckOpsDebride(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数

	//OR-Debridement	手术-清创手术
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("OR-Debridement")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set IsOps=0,Count=0,ActDates="",KeyWord=""
	Set xActDate=(aDateFrom-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		Quit:IsOps=1
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			Quit:IsOps=1
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		   
		    Set Result=obj.CCResult
		  	Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst(obj,SttDay,0)
			Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
			Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
				Set Count=Count+1
				Continue:(LimCnt>0)&(Count<LimCnt)
			}				
			Set IsOps=1
			Set KeyWord=Result
		}
	}
	Quit:IsOps'=1 return
	Set return=IsOps_","_KeyWord_","_$lts(ActDates,"#")
	Quit return
}

/// 手术名称
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckOpsName("40","体温异常(正值)","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckOpsName(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set IsOps=0,OperDesc=""
	Set xDate = (aDateFrom-1)
	For {
		Set xDate = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:IsOps=1
		
		Set xOperID =""
		For {
			Set xOperID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeDr,xDate,xOperID))
			Quit:xOperID=""
			Quit:IsOps=1
			
			Set objOper = ##class(DHCHAI.DP.OROperAnaes).GetObjById(xOperID)
			Continue:'$isobject(objOper)
			Continue:objOper.ORIsActive'=1
			Set OperDesc = objOper.OROperDesc
			Set OperDate = objOper.OROperDate
			Continue:OperDate=""
		    Continue:("#"_DicSet_"#")'[("#"_OperDesc_"#")  //名称过滤
		
			Set IsOps=1
		}
	}
	Quit:IsOps'=1 return
	
	Set return=IsOps_","_OperDesc_","_OperDate
	Quit return
}

/// 特定医嘱（抗菌药物、三管医嘱、大换药医嘱（是否已经同步了？？）、会诊医嘱（名称是区分开了？？））
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckOrdItem("40","体温异常(正值)","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckOrdItem(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数
	
	Set OperNextDateList="",OperSerDateList="",NextEndDate="",SerEndDate=""
	Set:aRuleExp["术后" OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,SttDay)
	Quit:(aRuleExp["术后")&&(OperNextDateList="") return
	Set:$ll(OperNextDateList)>0 NextEndDate=$lg(OperNextDateList,$ll(OperNextDateList))
	Set:(aRuleExp["术后")&(SerDay>0) OperSerDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,(SttDay+SerDay)) 
	Set:$ll(OperSerDateList)>0 SerEndDate=$lg(OperSerDateList,$ll(OperSerDateList))

	Set IsOrd=0,Count=0,ActDates="",KeyWord=""
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		Quit:IsOrd=1
		
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive=0	// 无效医嘱
		
		Set SCode   = objOrdItem.OESCode		
		Set OrdType = objOrdItem.OEOrdType
		Set OrdDesc = objOrdItem.OEOrdDesc
		Set Priority= objOrdItem.OEPriority
		Set SttDate = objOrdItem.OESttDate
		Set SttTime = objOrdItem.OESttTime
		Set EndDate	= objOrdItem.OEXDate
		Continue:("#"_DicSet_"#")'[("#"_OrdDesc_"#")  //名称过滤
		 
		If (OperNextDateList'="") {   //术后
			Continue:(Weight>0)&&((SttDate<$lg(OperNextDateList,1))||(SttDate<=NextEndDate)||((SerEndDate'="")&&(SttDate>SerEndDate)))   //限定术后n天后，触发日期不能小于手术日期,不能小于最后一天,不能大于持续天数最后一天
			Continue:(Weight<=0)&&((SttDate<$lg(OperNextDateList,1))||(SttDate>NextEndDate))  //限定术后n天内，触发日期不能小于手术日期,不能大于最后一天
		}Else {    //入院后
			Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).Check48HourFlg(aEpisodeDr,SttDate,SttTime,SttDay,0)	
			Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
			Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
		}	
		
		//一天只需记录一次异常
		If SttDate'="" {
			Continue:$listfind(ActDates,SttDate)>0 
			Set ActDates=ActDates_$lb(SttDate)
			Set Count=Count+1
			Continue:(LimCnt>0)&(Count<LimCnt)
		}				
		Set IsOrd=1
		Set KeyWord=OrdDesc
	}
	Quit:IsOrd'=1 return
	Set return=IsOrd_","_KeyWord_","_$lts(ActDates,"#")
	Quit return
}

/// 临床诊断（首页中的诊断在医生诊断规则中，病程诊断规则是否保留待定）
/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckOpsDebride("40","上呼吸道感染","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckDiagnos(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub) 
	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)   //值域
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数
	
	Set IsDiag=0
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		Quit:IsDiag=1
		
		Set obj=##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
		Continue:'$isobject(obj)
		Set IsActive = obj.MRIsActive
		Continue:IsActive'=1
		
		Set SCode	 	= obj.MRSCode
		Set ICD10  		= obj.MRDiagICD10
		Set DiagDesc   	= obj.MRDiagDesc
		Set DiagTpCode  = obj.MRDiagTpCode
		Set DiagTpDesc 	= obj.MRDiagTpDesc

		Set DiagDate    = obj.MRDiagDate
		Set DiagTime    = obj.MRDiagTime
		Set DiagNote    = obj.MRDiagNote
		Set DiagSource  = obj.MRDiagSource
		Continue:(DiagSource'="C")&&(DiagSource'="A")
	    Continue:("#"_DicSet_"#")'[("#"_DiagDesc_"#")  //名称过滤
		
		Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).Check48HourFlg(aEpisodeDr,DiagDate,DiagTime,SttDay,0)	
		Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
		Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
	    Set IsDiag=1   	
	}
	Quit:IsDiag'=1 return
	Set return=IsDiag_","_DiagDesc_","_DiagDate
	Quit return
}

/// w ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckOpsDebride("40","影像诊断","189",$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod CheckRISDiag(aRuleDr As %String, aChildSub As %String = "", aRuleExp As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aRuleDr,aChildSub,aRuleExp,aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aRuleDr="")||(aRuleExp="")||(aEpisodeDr="") return
     
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,aRuleExp,aChildSub)
	Quit:ArgStr="" return
	
	Set DicSet=$p(ArgStr,"^",1)    //值域
	Set SerDay=+$p(ArgStr,"^",4)   //持续天数
	Set LimCnt=+$p(ArgStr,"^",5)   //限定次数
	Set Weight=+$p(ArgStr,"^",6)   //权重
	Set SttDay=+$p(ArgStr,"^",7)   //限定天数

	//RME-Radiology	语义-放射学检查
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-Radiology")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set IsRIS=0,Count=0,ActDates="",KeyWord=""
	Set xActDate=(aDateFrom-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		Quit:IsRIS=1
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			Quit:IsRIS=1
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		   
		    Set Result=obj.CCResult
		    Set IsDiag = 0
			For len=1:1:$l(Result,";") {
				Set KeyWord= $p(Result,";",len)
				Continue:KeyWord=""
				Continue:("#"_DicSet_"#")'[("#"_KeyWord_"#")  //名称过滤
				Set IsDiag=1
			}
			Continue:IsDiag<1
			
		  	Set flg = ##class(DHCHAI.IRC.CSRuleUNExpSrv).CheckIs48HourRst(obj,SttDay,0)
			Continue:(Weight>0)&&(flg'=1)   //限定入院n天后
			Continue:(Weight<=0)&&(flg'=0)  //限定入院n天内
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
				Set Count=Count+1
				Continue:(LimCnt>0)&(Count<LimCnt)
			}				
			Set IsRIS=1
			Set KeyWord=Result
		}
	}
	Quit:IsRIS'=1 return
	Set return=IsRIS_","_KeyWord_","_$lts(ActDates,"#")
	Quit return
}

}

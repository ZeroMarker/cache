/// ClassName:    DHCMed.SPEService.CaseXCtl
/// Description:  特殊患者筛查规则
/// Creator：     zhufei
/// CreatDate:    2019-03-06
Class DHCMed.SPEService.CaseXCtl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-03-06
/// Description:  筛查重点病人（只筛查在院病人）
/// Table：       DHCMed.SPE.CaseX、PA_Adm
/// Input：       aFromDate：开始日期
///               aToDate：结束日期
/// Others:  	  返回String
/// w ##class(DHCMed.SPEService.CaseXCtl).CtrlAdmitCaseX()
ClassMethod CtrlAdmitCaseX(locid As %String = "", userid As %String = "") As %String
{
	New (locid,userid)
	Set return=0
	
	Set $ZT="CtrlAdmitCaseXErr"
	
	Set ScreenItems=..GetScreenItems()
	Quit:ScreenItems="" return
	
	//在院患者列表
	Set xWardID="",Count=0
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^PAADMi("CurrWard",xWardID,xRoomID,xEpisodeID))
				Quit:xEpisodeID=""
				
				Set AdmInfo=$g(^PAADM(xEpisodeID))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤  o门诊 I住院
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				
				Set flg=..CtrlEpisCaseX(xEpisodeID,ScreenItems,locid,userid)
				Set Count=Count+1
			}
		}
	}
	Set return=Count
	Quit return
	
CtrlAdmitCaseXErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-03-06
/// Description:  筛查重点病人（只筛查在院病人）
/// Table：       DHCMed.SPE.CaseX、PA_Adm
/// Input：       aFromDate：开始日期
///               aToDate：结束日期
/// Others:  	  返回String
/// w ##class(DHCMed.SPEService.CaseXCtl).CtrlDischCaseX("2016-01-01","2019-03-01")
ClassMethod CtrlDischCaseX(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="CtrlDischCaseXErr"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCMed.SPEService.CaseXCtl(YY_"-"_MM,DD))
	Set ^DHCMed.SPEService.CaseXCtl(YY_"-"_MM,DD,NUM,"命令")="do ##class(DHCMed.SPEService.CaseXCtl).CtrlDischCaseX("_aDateFrom_","_aDateTo_")"
	Set ^DHCMed.SPEService.CaseXCtl(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	Set ScreenItems=..GetScreenItems()
	Quit:ScreenItems="" return
	
	//出院患者列表
	For xDate=aDateFrom:1:aDateTo {
		Set xEpisodeID=0
		For {
			Set xEpisodeID=$o(^PAADMi("DischDate",xDate,xEpisodeID))
			Quit:xEpisodeID=""
			
			Set AdmInfo=$g(^PAADM(xEpisodeID))
			Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤  o门诊 I住院
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			
			Set flg=..CtrlEpisCaseX(xEpisodeID,ScreenItems)
			Set Count=Count+1
		}
	}
	//记录执行任务日志（成功标记）
	Set ^DHCMed.SPEService.CaseXCtl(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	Set return=Count
	Quit return
	
CtrlDischCaseXErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod CtrlEpisCaseX(aEpisodeID As %String, aScreenItems As %String, locid As %String = "", userid As %String = "") As %String
{
	New (aEpisodeID,aScreenItems,locid,userid)
	Set return=0
	Quit:(aEpisodeID="")||(aScreenItems="") return
	
	Set ScreenItemList=$LISTFROMSTRING(aScreenItems,",")
	Set arrResult=##class(%ListOfDataTypes).%New()
	
	Set ItemCode="CC01"	//危重症病人
	If $listfind(ScreenItemList,"CC01")>0 {
		Set flg=..CheckCriticIll(aEpisodeID,ItemCode,arrResult)
	}
	
	Set ItemCode="CC02"	//行重大手术病人
	If $listfind(ScreenItemList,"CC02")>0 {
		Set flg=..CheckMajorOper(aEpisodeID,ItemCode,arrResult)
	}
	
	Set ItemCode="CC03"	//住院期间两次手术病人
	If $listfind(ScreenItemList,"CC03")>0 {
		Set flg=..CheckRetOper(aEpisodeID,ItemCode,arrResult)
	}
	
	Set ItemCode="CC04"	//一月内重返住院病人
	If $listfind(ScreenItemList,ItemCode)>0 {
		Set flg=..CheckRetHosp30(aEpisodeID,ItemCode,arrResult)
	}
	
	Set ItemCode="CC05"	//住院超过30日病人
	If $listfind(ScreenItemList,ItemCode)>0 {
		Set flg=..CheckAdmDays30(aEpisodeID,ItemCode,arrResult)
	}
	
	Set return=..SaveCtrlResult(arrResult,locid,userid)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-03-06
/// Description:  筛查项目：危重症病人
/// Table：       PA_Adm
/// Input：       aEpisodeID : 就诊号
///               aItemCode  : 筛查项目代码
///               arrResult  : 筛查结果
/// Others:  	  返回String
/// w ##class(DHCMed.SPEService.CaseXCtl).CheckCriticIll(156,"CC01","")
ClassMethod CheckCriticIll(aEpisodeID As %String, aItemCode As %String, ByRef arrResult As %ListOfDataTypes) As %String
{
	New (aEpisodeID,aItemCode,arrResult)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set EpisodeID=$o(^OEORD(0,"Adm",aEpisodeID,""))
	Quit:EpisodeID="" return
	
	Set Sum=0
	Set Code=""
	Set xID = 0
	Set statusDesc=""
	For {
		Set xID = $o(^OEORD(EpisodeID,"I",xID))
		Quit:xID=""
		
		;Set Code = $p(^OEORD(EpisodeID,"I",xID,1),"^",2)
		Set Code = $p($G(^OEORD(EpisodeID,"I",xID,1)),"^",2)	// 此处有修改内容！！！
		Continue:Code=""
		Set Code1=$p(Code,"||",1)
		Set Code2=$p(Code,"||",2)
		Set Desc = $p(^ARCIM(Code1,Code2,1),"^",2)
		//增加医嘱状态过滤
		Set status=$p($G(^OEORD(EpisodeID,"I",xID,1)),"^",13)	
		Set statusDesc=$p($G(^OEC("OSTAT",status)),"^",2)		//医嘱状态
		
		If (Desc="病危")||(Desc="病重"){
			//Continue:(statusDesc="作废")
			Set Sum=Sum+1
			Quit:Sum'=0 
		}
	}
	Quit:Sum=0 return
	
	
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmDoc=$p($g(^PAADM(aEpisodeID)),"^",9)
	Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set AdmWard=$p($g(^PAADM(aEpisodeID)),"^",70)
	Set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
	
	Set (ItemDr,PatTypeDr,ActDate,ActLoc,ActWard,ActDoc,ResultID)=""
	Set objItem=##class(DHCMed.SPE.Screening).GetObjByCode(aItemCode)
	Quit:'$IsObject(objItem) return
	Set ItemDr=objItem.%Id()
	Set PatTypeDr=""
	If $IsObject(objItem.BTPatTypeDr){
		Set PatTypeDr=objItem.BTPatTypeDr.%Id()
	}
	Set ResultID=aEpisodeID
	Set ActDate=AdmDate
	Set ActDoc=AdmDoc
	Set ActLoc=AdmLoc
	Set ActWard=AdmWard
	
	Set tResult=""
	Set $p(tResult,"^",1)=aEpisodeID
	Set $p(tResult,"^",2)=ItemDr
	Set $p(tResult,"^",3)=PatTypeDr
	Set $p(tResult,"^",4)=ActDate
	Set $p(tResult,"^",5)=ActLoc
	Set $p(tResult,"^",6)=ActWard
	Set $p(tResult,"^",7)=ActDoc
	Set $p(tResult,"^",8)=ResultID
	//当医嘱作废时，更新状态为排除 原因为作废
	if (statusDesc="作废"){
		Set $p(tResult,"^",9)=statusDesc
		}
	Do arrResult.Insert(tResult)
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-03-06
/// Description:  筛查项目：行重大手术病人
/// Table：       PA_Adm
/// Input：       aEpisodeID : 就诊号
///               aItemCode  : 筛查项目代码
///               arrResult  : 筛查结果
/// Others:  	  返回String
/// w ##class(DHCMed.SPEService.CaseXCtl).CheckMajorOper()
ClassMethod CheckMajorOper(aEpisodeID As %String, aItemCode As %String, ByRef arrResult As %ListOfDataTypes) As %String
{
	New (aEpisodeID,aItemCode,arrResult)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set Sum=0
	Set opaId=""
	For{
		Set opaId=$o(^DHCANOPArrange(0,"Adm",aEpisodeID,opaId))
		Quit:opaId=""
		
		Set adm=$P(^DHCANOPArrange(opaId),"^",1)  				//就诊表id
		Set chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)		//麻醉表childsub
		Set subchl=0 
		For{
		  Set subchl=$O(^OR(adm,"ANA",chl,"OP",subchl))
		  Quit:(subchl="")
		  
		  Set curAnaopBladeTypeId=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",9)
		  Continue:curAnaopBladeTypeId="" 
		  
		  Set anaopBladeType=$p($g(^ORC("BLDTP",+curAnaopBladeTypeId)),"^",2)
		  Continue:(anaopBladeType'["Ⅲ")
		  Set Sum=Sum+1
		}
	}
	Quit:Sum=0 return
	
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmDoc=$p($g(^PAADM(aEpisodeID)),"^",9)
	Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set AdmWard=$p($g(^PAADM(aEpisodeID)),"^",70)
	Set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
	
	Set objItem=##class(DHCMed.SPE.Screening).GetObjByCode(aItemCode)
	Quit:'$IsObject(objItem) return
	Set ItemDr=objItem.%Id()
	Set PatTypeDr=""
	If $IsObject(objItem.BTPatTypeDr){
		Set PatTypeDr=objItem.BTPatTypeDr.%Id()
	}
	
	Set ResultID=aEpisodeID
	Set ActDate=AdmDate
	Set ActDoc=AdmDoc
	Set ActLoc=AdmLoc
	Set ActWard=AdmWard
	
	Set tResult=""
	Set $p(tResult,"^",1)=aEpisodeID
	Set $p(tResult,"^",2)=ItemDr
	Set $p(tResult,"^",3)=PatTypeDr
	Set $p(tResult,"^",4)=ActDate
	Set $p(tResult,"^",5)=ActLoc
	Set $p(tResult,"^",6)=ActWard
	Set $p(tResult,"^",7)=ActDoc
	Set $p(tResult,"^",8)=ResultID
	Do arrResult.Insert(tResult)

	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-03-06
/// Description:  筛查项目：住院期间两次手术病人
/// Table：       PA_Adm
/// Input：       aEpisodeID : 就诊号
///               aItemCode  : 筛查项目代码
///               arrResult  : 筛查结果
/// Others:  	  返回String
/// w ##class(DHCMed.SPEService.CaseXCtl).CheckRetOper()
ClassMethod CheckRetOper(aEpisodeID As %String, aItemCode As %String, ByRef arrResult As %ListOfDataTypes) As %String
{
	New (aEpisodeID,aItemCode,arrResult)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set OperArr=0
	Set Flag=0
	For {
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",aEpisodeID,OperArr))
		Quit:OperArr=""
		
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)
		Continue:OperStatus="NotApp"
		//手术状态opaStatus："A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室，"F"是完成。""是全部
		Continue:(OperStatus="A")||(OperStatus="D")||(OperStatus="R")
		Set Flag=Flag+1
	}
	If (Flag>1){
		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmDoc=$p($g(^PAADM(aEpisodeID)),"^",9)
		Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
		Set AdmWard=$p($g(^PAADM(aEpisodeID)),"^",70)
		Set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
		
		Set objItem=##class(DHCMed.SPE.Screening).GetObjByCode(aItemCode)
		Quit:'$IsObject(objItem) return
		Set ItemDr=objItem.%Id()
		Set PatTypeDr=""
		If $IsObject(objItem.BTPatTypeDr){
			Set PatTypeDr=objItem.BTPatTypeDr.%Id()
		}
		
		Set ResultID=aEpisodeID
		Set ActDate=AdmDate
		Set ActDoc=AdmDoc
		Set ActLoc=AdmLoc
		Set ActWard=AdmWard
		
		Set tResult=""
		Set $p(tResult,"^",1)=aEpisodeID
		Set $p(tResult,"^",2)=ItemDr
		Set $p(tResult,"^",3)=PatTypeDr
		Set $p(tResult,"^",4)=ActDate
		Set $p(tResult,"^",5)=ActLoc
		Set $p(tResult,"^",6)=ActWard
		Set $p(tResult,"^",7)=ActDoc
		Set $p(tResult,"^",8)=ResultID
		Do arrResult.Insert(tResult)

		Set return=1
		Quit return
	}else{
		Quit return
	}
}

/// Creator：     zhufei
/// CreatDate：   2019-03-06
/// Description:  筛查项目：一月内重返住院病人
/// Table：       PA_Adm
/// Input：       aEpisodeID : 就诊号
///               aItemCode  : 筛查项目代码
///               arrResult  : 筛查结果
/// Others:  	  返回String
/// w ##class(DHCMed.SPEService.CaseXCtl).CheckRetHosp30()
ClassMethod CheckRetHosp30(aEpisodeID As %String, aItemCode As %String, ByRef arrResult As %ListOfDataTypes) As %String
{
	New (aEpisodeID,aItemCode,arrResult)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set PreEpisodeID=$o(^PAPERdr(PatientID,"ADM","I",aEpisodeID))
	Quit:PreEpisodeID="" return
	Set PreAdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(PreEpisodeID)
	Set PreAdmDate=$p(PreAdmDateTime,"^",1)
	Quit:(AdmDate-PreAdmDate)>30 return
	
	Set AdmDoc=$p($g(^PAADM(aEpisodeID)),"^",9)
	Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set AdmWard=$p($g(^PAADM(aEpisodeID)),"^",70)
	Set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
	
	Set (ItemDr,PatTypeDr,ActDate,ActLoc,ActWard,ActDoc,ResultID)=""
	Set objItem=##class(DHCMed.SPE.Screening).GetObjByCode(aItemCode)
	Quit:'$IsObject(objItem) return
	Set ItemDr=objItem.%Id()
	Set PatTypeDr=""
	If $IsObject(objItem.BTPatTypeDr){
		Set PatTypeDr=objItem.BTPatTypeDr.%Id()
	}
	Set ResultID=aEpisodeID
	Set ActDate=AdmDate
	Set ActDoc=AdmDoc
	Set ActLoc=AdmLoc
	Set ActWard=AdmWard
	
	Set tResult=""
	Set $p(tResult,"^",1)=aEpisodeID
	Set $p(tResult,"^",2)=ItemDr
	Set $p(tResult,"^",3)=PatTypeDr
	Set $p(tResult,"^",4)=ActDate
	Set $p(tResult,"^",5)=ActLoc
	Set $p(tResult,"^",6)=ActWard
	Set $p(tResult,"^",7)=ActDoc
	Set $p(tResult,"^",8)=ResultID
	Do arrResult.Insert(tResult)
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-03-06
/// Description:  筛查项目：住院超过30日病人
/// Table：       PA_Adm
/// Input：       aEpisodeID : 就诊号
///               aItemCode  : 筛查项目代码
///               arrResult  : 筛查结果
/// Others:  	  返回String
/// w ##class(DHCMed.SPEService.CaseXCtl).CheckAdmDays30()
ClassMethod CheckAdmDays30(aEpisodeID As %String, aItemCode As %String, ByRef arrResult As %ListOfDataTypes) As %String
{
	New (aEpisodeID,aItemCode,arrResult)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
	Set AdmDays=(+$h)-AdmDate
	Quit:AdmDays<31 return //先做一个初步筛查，主要基于效率考虑
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DisDate=$p(DischDateTime,"^",1)
	If DisDate'="" {
		Set AdmDays=DisDate-AdmDate
	} Else {
		Set AdmDays=(+$h)-AdmDate
	}
	Quit:AdmDays<31 return
	
	Set (ItemDr,PatTypeDr,ActDate,ActLoc,ActWard,ActDoc,ResultID)=""
	Set objItem=##class(DHCMed.SPE.Screening).GetObjByCode(aItemCode)
	Quit:'$IsObject(objItem) return
	Set ItemDr=objItem.%Id()
	Set PatTypeDr=""
	If $IsObject(objItem.BTPatTypeDr){
		Set PatTypeDr=objItem.BTPatTypeDr.%Id()
	}
	Set ResultID=aEpisodeID
	Set ActDate=AdmDate+30
	//科室、病区、医生
	Set CurrDate1=0,CurrDate2=0,CurrDate3=0
	Set xSub=0
	For {
		Set xSub=$o(^PAADM(aEpisodeID,"TRANS",xSub))
		Quit:xSub=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xSub))
		Set StartDate=$p(tmpTrans,"^",1) //开始日期
		Set TransDoc=$p(tmpTrans,"^",5)  //医生
		Set TransLoc=$p(tmpTrans,"^",6)  //科室
		Set TransWard=$p(tmpTrans,"^",9) //病区
		Set:TransWard'="" TransWard=$p($g(^PAWARD(TransWard)),"^",5)
		
		If (StartDate<=ActDate)&&(TransDoc'="") {
			If (StartDate>CurrDate1) {
				Set CurrDate1=StartDate
				Set ActDoc=TransDoc
			}
		}
		If (StartDate<=ActDate)&&(TransLoc'="") {
			If (StartDate>CurrDate2) {
				Set CurrDate2=StartDate
				Set ActLoc=TransLoc
			}
		}
		If (StartDate<=ActDate)&&(TransWard'="") {
			If (StartDate>CurrDate3) {
				Set CurrDate3=StartDate
				Set ActWard=TransWard
			}
		}
	}
	
	Set tResult=""
	Set $p(tResult,"^",1)=aEpisodeID
	Set $p(tResult,"^",2)=ItemDr
	Set $p(tResult,"^",3)=PatTypeDr
	Set $p(tResult,"^",4)=ActDate
	Set $p(tResult,"^",5)=ActLoc
	Set $p(tResult,"^",6)=ActWard
	Set $p(tResult,"^",7)=ActDoc
	Set $p(tResult,"^",8)=ResultID
	Do arrResult.Insert(tResult)
	
	Set return=1
	Quit return
}

ClassMethod SaveCtrlResult(arrResult As %ListOfDataTypes, locid As %String = "", userid As %String = "") As %String
{
	New (arrResult,locid,userid)
	Set return=0, Count=0, cnt=0
	Quit:arrResult.Count()<1 return
	
	// 处理自动标记、自动审核和自动关闭任务（自动关闭任务暂时不实现）。
	// 获取所有有效的需要自动标记、自动审核、自动关闭的特殊患者子分类
	Set AutoMarkStr  = "", AutoCheckStr = "", AutoCloseStr = ""
	
	Set xPatTypeID = ""
	For {
		Set xPatTypeID = $O(^DHCMed.SPED("PatTp",xPatTypeID))
		Quit:xPatTypeID=""

		Set xPatTypeSubID = ""
		For {
			Set xPatTypeSubID = $O(^DHCMed.SPED("PatTp",xPatTypeID,"Sub",xPatTypeSubID))
			Quit:xPatTypeSubID=""

			Set PTSList 		= $G(^DHCMed.SPED("PatTp",xPatTypeID,"Sub",xPatTypeSubID))
			Set PTSisAutoMark 	= $LG(PTSList, 5)					// 获取当前 自动标记 标记
			Set PTSisAutoCheck 	= $LG(PTSList, 6)					// 获取当前 自动审核 标记
			Set PTSisAutoClose 	= $LG(PTSList, 7)					// 获取当前 自动关闭 标记
			Set PTSisActive 	= $LG(PTSList, 8)					// 获取当前 是否有效 标记
			Set PTSID 			= xPatTypeID_"||"_xPatTypeSubID		// 获取特殊患者子分类ID

			// 判断当前特殊患者子分类的有效性
			If PTSisActive {
				If PTSisAutoMark {
					Set AutoMarkStr  = AutoMarkStr_"^"_PTSID
				}
				If PTSisAutoCheck {
					Set AutoCheckStr = AutoCheckStr_"^"_PTSID
				}
				If PTSisAutoClose {
					Set AutoCloseStr = AutoCloseStr_"^"_PTSID
				}
			}
		}
	}

	For indRst=1:1:arrResult.Count() {
		Set tResult=arrResult.GetAt(indRst)
		Continue:tResult=""
		
		Set EpisodeID   = $p(tResult,"^",1)
		Set ItemDr      = $p(tResult,"^",2)
		Set PatTypeDr   = $p(tResult,"^",3)
		Set ActDate     = $p(tResult,"^",4)
		Set ActLoc      = $p(tResult,"^",5)
		Set ActWard     = $p(tResult,"^",6)
		Set ActDoc      = $p(tResult,"^",7)
		Set ResultID    = $p(tResult,"^",8)
		Set statusDesc  = $p(tResult,"^",9)
		
		//确认该条筛查结果是否需要自动标记、自动审核、自动关闭
		Set MarkStr = "", CheckStr = "", CloseStr = "", MarkResult = -1, CheckResult = -1, CloseResult = -1, ID = ""
		Set ID=$o(^DHCMed.SPE.CaseXI("IndexResultID"," "_$zcvt(EpisodeID,"U"),ItemDr," "_$zcvt(ResultID,"U"),""))
		If ID'="" {
			// 自动任务的公用obj变量
			Set objCaseX=##class(DHCMed.SPE.CaseX).GetObjById(ID)
			Continue:'$IsObject(objCaseX)
			if (statusDesc="作废"){
				b ;10
				Set objCaseX.CXStatus=0
				Set objCaseX.CXOpinion="作废"
				Set sc=objCaseX.%Save()
			}
			// 对object的患者类型和筛查类型进行OREF验证
			//Set objPatient = ##class(DHCMed.SPE.Patients).GetObjById(objCaseX.CXLnkPatID)
			//Continue:'$IsObject(objPatient)
			
			// 部分测试数据中，数据存在错误，CXLnkPatID为空，此处过滤掉部分错误数据
			//Continue:'$ISOBJECT(objCaseX.CXPatTypeDr)
			//Continue:'$ISOBJECT(objCaseX.CXScreeningDr)

			// 自动标记
			If objCaseX.CXStatus=-1 {
				If AutoMarkStr[PatTypeDr {
					Set InputStr=""
					Set $P(MarkStr, "^", 1) = ID
					Set $P(MarkStr, "^", 2) = "1"
					Set $P(MarkStr, "^", 3) = ""
					Set $P(MarkStr, "^", 4) = locid //$g(%session.Data("LOGON.CTLOCID"))
					Set $P(MarkStr, "^", 5) = userid //$g(%session.Data("LOGON.USERID"))
					Set InputStr = InputStr_"!"_MarkStr //$P(InputStr, "!", 1)=MarkStr
					Set MarkResult = ##class(DHCMed.SPEService.CaseXSrv).ProcessCaseX(InputStr, "^")
				}
			}
			Set objPatient = ##class(DHCMed.SPE.Patients).GetObjById(objCaseX.CXLnkPatID)
			Continue:'$IsObject(objPatient)
			If objCaseX.CXStatus=1 {
				// 自动审核
				If AutoCheckStr[PatTypeDr {
					Set $P(CheckStr, "^", 1)  = objPatient.%Id()
					Set $P(CheckStr, "^", 2)  = objCaseX.CXEpisodeID
					Set $P(CheckStr, "^", 3)  = objCaseX.CXPatTypeDr.%Id()
					Set $P(CheckStr, "^", 8)  = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objPatient.PSMarkDate)
					Set $P(CheckStr, "^", 9)  = $zt(objPatient.PSMarkTime,1)
					Set $P(CheckStr, "^", 10) = 2						// 1为标记，2为审核，3为关闭
					Set $P(CheckStr, "^", 11) = "系统自动审核"
					Set $P(CheckStr, "^", 17) = userid
					Set $P(CheckStr, "^", 18) = 2						// 1:临床科室 2:管理科
					
					Set CheckResult = ##class(DHCMed.SPEService.PatientsSrv).SaveSpeOper(CheckStr)
				}
				// 自动关闭(暂时停用)
				If 0 {
				// If AutoCloseStr[PatTypeDr {
					Set $P(CloseStr, "^", 1)  = ID
					Set $P(CloseStr, "^", 2)  = objCaseX.CXEpisodeID
					Set $P(CloseStr, "^", 3)  = objCaseX.CXPatTypeDr.%Id()
					Set $P(CloseStr, "^", 8)  = objPatient.PSMarkDate
					Set $P(CloseStr, "^", 9)  = objPatient.PSMarkTime
					Set $P(CloseStr, "^", 10) = 3						// 1为标记，2为审核，3为关闭
					Set $P(CloseStr, "^", 11) = objPatient.PSCheckOpinion
					Set $P(CloseStr, "^", 12) = objPatient.PSCheckDate
					Set $P(CloseStr, "^", 13) = objPatient.PSCheckTime
					Set $P(CloseStr, "^", 18) = 2						// 1:临床科室 2:管理科

					Set CloseResult = ##class(DHCMed.SPEService.PatientsSrv).SaveSpeOper(CloseStr)
				}
			}
		}
		Else {
			// CaseX中ID不存在，需要插入新数据
			Set InputStr=""
			Set $p(InputStr,"^",1)=ID          //ID
			Set $p(InputStr,"^",2)=EpisodeID   //就诊号
			Set $p(InputStr,"^",3)=ItemDr      //筛查项目
			Set $p(InputStr,"^",4)=PatTypeDr   //特殊患者类型
			Set $p(InputStr,"^",5)=ActDate     //日期
			Set $p(InputStr,"^",6)=ActLoc      //科室
			Set $p(InputStr,"^",7)=ActWard     //病区
			Set $p(InputStr,"^",8)=ActDoc      //医生
			Set $p(InputStr,"^",9)=ResultID    //索引记录ID
			if (statusDesc="作废"){
				Set $p(InputStr,"^",10)="0"       //状态（未处置-1、确认1、排除0）
				Set $p(InputStr,"^",11)="作废"    //处置意见
			}else{
				Set $p(InputStr,"^",10)="-1"       //状态（未处置-1、确认1、排除0）
				Set $p(InputStr,"^",11)=""         //处置意见
			}
			//Set $p(InputStr,"^",10)="-1"       //状态（未处置-1、确认1、排除0）
			//Set $p(InputStr,"^",11)=""         //处置意见
			Set $p(InputStr,"^",12)=""         //处置日期
			Set $p(InputStr,"^",13)=""         //处置时间
			Set $p(InputStr,"^",14)=""         //处置科室
			Set $p(InputStr,"^",15)=""         //处置人
			Set flg=##class(DHCMed.SPE.CaseX).Update(InputStr,"^")
			If (+flg)>0 {
				Set Count=Count+1
			}
		}
	}
	Set return=Count
	Quit return
}

/// w ##class(DHCMed.SPEService.CaseXCtl).GetScreenItems()
ClassMethod GetScreenItems() As %String
{
	New
	Set return=""
	
	Set xID=""
	For {
		Set xID=$o(^DHCMed.SPE.ScreeningD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.SPE.Screening).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.BTIsActive'=1
		Set Code=obj.BTCode
		Continue:Code=""
		
		If return'="" {
			Set return=return_","_Code
		} Else {
			Set return=Code
		}
	}
	Quit return
}

}

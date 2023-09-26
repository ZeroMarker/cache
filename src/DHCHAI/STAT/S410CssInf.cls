/// 名称: DHCHAI.STAT.S030InfPre
/// 描述: 医院感染横断面调查
/// 编写者：chenjb
/// 编写日期: 2018-10-10
Class DHCHAI.STAT.S410CssInf Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-12-15
/// Description:  医院感染（例次）现患率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID   ：调查ID
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S410CssInf","QryInfPreByCSS","1")
Query QryInfPreByCSS(aSurNumID As %String) As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,SurPatCnt:%String,SurPatRatio:%String,InfPatCnt:%String,InfPatRatio:%String,InfCaseCnt:%String,InfCaseRatio:%String,ComInfPatCnt:%String,ComInfPatRatio:%String,ComInfCaseCnt:%String,ComInfCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfPreByCSSExecute(ByRef qHandle As %Binary, aSurNumID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aSurNumID="" $$$OK
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber
 	Quit:'$IsObject(objSExec.SEHospDr) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(objSExec.SEHospDr.%Id(),"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	/// 取所有需要调查的科室  默认是全院科室
    Set NIndex="QryInfPreByCSS"
	Kill ^TMP($zn,$j,NIndex)
	
	Set StatDimensStr=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensStr()
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	
    //横断面调查病人就诊列表
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
    For index1=1:1:ListLocArray.Count() {
		Set CSSEpisInfo=ListLocArray.GetAt(index1)
		Continue:CSSEpisInfo=""
		
		Set Paadm       = $lg(CSSEpisInfo,1)
		Set TransID     = $lg(CSSEpisInfo,2)
		Set TransLocDr  = $lg(CSSEpisInfo,3)
		Set LinkLocDr   = $lg(CSSEpisInfo,4)
		Continue:(TransID="")||(TransLocDr="")
		Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(TransID)
		Continue:'$IsObject(objAdmTrans)
		Set TransType=objAdmTrans.PATransType
		If TransType="E" {
			Set objLoc=objAdmTrans.PATransLocDr
			Set objWard=""
		} Else {
			Set objLoc=objAdmTrans.PALinkLocDr
			Set objWard=objAdmTrans.PATransLocDr
		}
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set HospDr=objLoc.BTHospDr.%Id()
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		Set LocDr=objLoc.%Id()
		Set LocDesc=objLoc.BTDesc
		Set WardDr="",WardDesc=""
		If $IsObject(objWard){
			Set WardDr=objWard.%Id()
			Set WardDesc=objWard.BTDesc
		}
		Set GroupDr="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr=objLoc.BTGroupDr.%Id()
			Set GroupDesc=objLoc.BTGroupDr.BTDesc
		}
		
		//取横断面对应感染信息
		Set CSSInfDianosInfo=..GetCSSInfDianosInfo(aSurNumID,Paadm)
		Set CSSReportID=$p(CSSInfDianosInfo,"!!",1)
		Set CSSRepDianos=$p(CSSInfDianosInfo,"!!",3)
		// 感染分类 1：社区感染 0：医院感染
		Set InfCategory=$p(CSSInfDianosInfo,"!!",4)
		//统计维度
		Set StatDimensInfo=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			//应查人数（住院人数）
			Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AdmPat"))
			
			If CSSReportID'="" {
				//实查人数（调查人数）
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
				
				If CSSRepDianos'="" {
					If (InfCategory=0){ // 医院感染
						//感染人数
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
						//感染例数
						Set num=+$g(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfCase")=num+$l(CSSRepDianos,"$$")
					}Else{ // 社区感染
						//感染人数
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfPat"))
						//感染例数
						Set num=+$g(^TMP($zn,$j,NIndex,DimensKey,"ComInfCase"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"ComInfCase")=num+$l(CSSRepDianos,"$$")
					}
				}
			}
		}
	}
	
	Set xDimensKey="",RowIndex=0
	For {
		Set xDimensKey=$o(^TMP($zn,$j,NIndex,xDimensKey))
		Quit:xDimensKey=""
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AdmPat"))  //应查人数
		Set SurPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //实查人数
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数
		Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例数
		
		Set ComInfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"ComInfPat"))  //社区感染人数
		Set ComInfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"ComInfCase")) //社区感染例数
		
		Set SurPatRatio=""
		Set:PatAdmCnt>0 SurPatRatio=$fn((SurPatCnt/PatAdmCnt)*100,"",2)_"%" //实查率
		Set InfPatRatio="0.00%",InfCaseRatio="0.00%"
		Set:SurPatCnt>0 InfPatRatio=$fn((InfPatCnt/SurPatCnt)*100,"",2)_"%" //现患率
		Set:SurPatCnt>0 InfCaseRatio=$fn((InfCaseCnt/SurPatCnt)*100,"",2)_"%" //现患例次率
		Set ComInfPatRatio="0.00%",ComInfCaseRatio="0.00%"
		Set:SurPatCnt>0 ComInfPatRatio=$fn((ComInfPatCnt/SurPatCnt)*100,"",2)_"%" //社区现患率
		Set:SurPatCnt>0 ComInfCaseRatio=$fn((ComInfCaseCnt/SurPatCnt)*100,"",2)_"%" //社区现患例次率
		
		Set DimensDesc=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensDesc(xDimensKey)
		Set RowIndex=RowIndex+1
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,SurPatCnt,SurPatRatio,InfPatCnt,InfPatRatio,InfCaseCnt,InfCaseRatio,ComInfPatCnt,ComInfPatRatio,ComInfCaseCnt,ComInfCaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPreByCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreByCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreByCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreByCSSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2018-12-16
/// Description:  医院感染（例次）现患病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID   ：调查ID
///               aInfTypeFlag: 1:社区感染  0:医院感染
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S410CssInf","QryInfPreDtlByCSS","5","A0-G00000007-E00000057",1)
Query QryInfPreDtlByCSS(aSurNumID As %String, aDimensKey As %String, aTypeFlag As %String, aInfTypeFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,CSSGroupDesc:%String,CSSLocDesc:%String,CSSWardDesc:%String,CSSTransDateTime:%String,CSSOutLocDateTime:%String,CSSRecordID:%String,CSSInfDiagnos:%String,CSSInfDate:%String,CSSInfEffect:%String") [ SqlProc ]
{
}

ClassMethod QryInfPreDtlByCSSExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aTypeFlag As %String, aInfTypeFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="")||(aDimensKey="")||(aTypeFlag="") $$$OK
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber
 	Quit:'$IsObject(objSExec.SEHospDr) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(objSExec.SEHospDr.%Id(),"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set DimensArgs=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensArgs(aDimensKey)
	Set aDimensKey = $p(DimensArgs,"^",1)
	Set aHospDr    = $p(DimensArgs,"^",2)
	Set aGroupDr   = $p(DimensArgs,"^",3)
	Set aLocDr     = $p(DimensArgs,"^",4)
	Set aWardDr    = $p(DimensArgs,"^",5)
	
    Set NIndex="QryInfPreDtlByCSS"
	Kill ^TMP($zn,$j,NIndex)
	
	Set StatDimensStr=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensStr()
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	
    //横断面调查病人就诊列表
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
    For index1=1:1:ListLocArray.Count() {
		Set CSSEpisInfo=ListLocArray.GetAt(index1)
		Continue:CSSEpisInfo=""
		
		Set Paadm       = $lg(CSSEpisInfo,1)
		Set TransID     = $lg(CSSEpisInfo,2)
		Set TransLocDr  = $lg(CSSEpisInfo,3)
		Set LinkLocDr   = $lg(CSSEpisInfo,4)
		Continue:(TransID="")||(TransLocDr="")
		Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(TransID)
		Continue:'$IsObject(objAdmTrans)
		Set TransType=objAdmTrans.PATransType
		If TransType="E" {
			Set objLoc=objAdmTrans.PATransLocDr
			Set objWard=""
		} Else {
			Set objLoc=objAdmTrans.PALinkLocDr
			Set objWard=objAdmTrans.PATransLocDr
		}
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set HospDr=objLoc.BTHospDr.%Id()
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		Set LocDr=objLoc.%Id()
		Set LocDesc=objLoc.BTDesc
		Set WardDr="",WardDesc=""
		If $IsObject(objWard){
			Set WardDr=objWard.%Id()
			Set WardDesc=objWard.BTDesc
		}
		Set GroupDr="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr=objLoc.BTGroupDr.%Id()
			Set GroupDesc=objLoc.BTGroupDr.BTDesc
		}
		Set TransDate=objAdmTrans.PATransDate
		Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set TransTime=objAdmTrans.PATransTime
		Set:TransTime'="" TransTime=$zt(TransTime,1)
		Set OutLocDate=objAdmTrans.PAOutLocDate
		Set:OutLocDate'="" OutLocDate=$zd(OutLocDate,3)
		Set OutLocTime=objAdmTrans.PAOutLocTime
		Set:OutLocTime'="" OutLocTime=$zt(OutLocTime,1)
		Set TransDateTime=TransDate_" "_TransTime
		Set OutLocDateTime=OutLocDate_" "_OutLocTime
		
		Continue:(aHospDr'="")&&(HospDr'=aHospDr)
		Continue:(aGroupDr'="")&&(GroupDr'=aGroupDr)
		Continue:(aLocDr'="")&&(LocDr'=aLocDr)
		Continue:(aWardDr'="")&&(WardDr'=aWardDr)
		
		//取横断面对应感染信息
		//取横断面对应感染信息
		Set CSSInfDianosInfo=..GetCSSInfDianosInfo(aSurNumID,Paadm)
		Set CSSReportID=$p(CSSInfDianosInfo,"!!",1)
		Set CSSRepDianos=$p(CSSInfDianosInfo,"!!",3)
		// 感染分类 1：社区感染 0：医院感染
		Set InfCategory=$p(CSSInfDianosInfo,"!!",4)
		Continue:(aInfTypeFlag'=InfCategory)
		
		Continue:(aTypeFlag=2)&&(CSSReportID="")
		Continue:(aTypeFlag=3)&&(CSSRepDianos="")
		Continue:(aTypeFlag=4)&&(CSSRepDianos="")
		
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    
		If (aTypeFlag=1)||(aTypeFlag=2)||(aTypeFlag=3) {
			//应查人数、实查人数、感染人数
			Set tInfDiagnos="",tInfDate="",tInfEffect=""
			For indRD=1:1:$l(CSSRepDianos,"$$") {
				Set tRepDiagnos=$p(CSSRepDianos,"$$",indRD)
				Continue:tRepDiagnos=""
				Set InfDiagnos=$p(tRepDiagnos,"^",3)
				Set InfDate=$p(tRepDiagnos,"^",4)
				Set:InfDate'["-" InfDate=$zd(InfDate,3)
				Set InfEffect=$p(tRepDiagnos,"^",7)
				
				Set tInfDiagnos=tInfDiagnos_","_InfDiagnos
				Set tInfDate=tInfDate_","_InfDate
				Set tInfEffect=tInfEffect_","_InfEffect
			}
			Set:tInfDiagnos'="" tInfDiagnos=$e(tInfDiagnos,2,$l(tInfDiagnos))
			Set:tInfDate'="" tInfDate=$e(tInfDate,2,$l(tInfDate))
			Set:tInfEffect'="" tInfEffect=$e(tInfEffect,2,$l(tInfEffect))
			Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDateTime,OutLocDateTime,CSSReportID,tInfDiagnos,tInfDate,tInfEffects)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		} ElseIf aTypeFlag=4 {
			//感染例数
			For indRD=1:1:$l(CSSRepDianos,"$$") {
				Set tRepDiagnos=$p(CSSRepDianos,"$$",indRD)
				Continue:tRepDiagnos=""
				Set InfDiagID=$p(tRepDiagnos,"^",1)
				Set InfDiagnos=$p(tRepDiagnos,"^",3)
				Set InfDate=$p(tRepDiagnos,"^",4)
				Set:InfDate'["-" InfDate=$zd(InfDate,3)
				Set InfEffect=$p(tRepDiagnos,"^",7)
				
				Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDateTime,OutLocDateTime,CSSReportID_"||"_InfDiagID,InfDiagnos,InfDate,InfEffect)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPreDtlByCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreDtlByCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreDtlByCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreDtlByCSSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2018-12-16
/// Description:  取现患感染信息
/// Table：       DHCHAI.IR.INFCSS、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
///               aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetCSSInfDianosInfo(1,"74321")
ClassMethod GetCSSInfDianosInfo(aSurNumID As %String, aEpisodeID As %String) As %String
{
	New (aSurNumID,aEpisodeID)
	Set return=""
	Quit:(aSurNumID="")||(aEpisodeID="") return
	
	Set CSSInfFlag=0,CSSInfPos=""
	Set xCSSID=0
	For {
		Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID,xCSSID))
		Quit:xCSSID=""
		
		Set objCSS=##class(DHCHAI.IR.INFCSS).GetObjById(xCSSID)
		Continue:'$IsObject(objCSS)
		Continue:objCSS.IRIsActive'=1
		Continue:'$IsObject(objCSS.IRInfectionDr)
		// 感染分类 1：社区感染 0：医院感染
		Set InfCategory = objCSS.IRInfCategoryDr
		Set InfectionDesc = objCSS.IRInfectionDr.BTDesc
		Set:InfectionDesc="不存在" InfCategory=""
		
		Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFCSS",xCSSID)
		For indRep=1:1:arrReport.Count() {
			Set objRep=arrReport.GetAt(indRep)
			Continue:'$IsObject(objRep)
			Set ReportID=objRep.%Id()
			Continue:'$IsObject(objRep.IRStatusDr)
			Set RepStatus=objRep.IRStatusDr.BTCode
			//1保存、2提交、3审核、4作废、5退回、6取消审核
			Continue:(RepStatus="4")
			
			// 感染诊断信息
			Set CSSInfPos=""
			Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				Continue:'$IsObject(objDiags.IRInfPosDr)
				// 感染日期、感染转归日期
				Set InfDate  = objDiags.IRInfDate
				Set InfXDate = objDiags.IRInfXDate
				// 感染诊断ID、感染诊断名称
				Set InfPosID   = objDiags.IRInfPosDr.%Id()
				Set InfPosDesc = objDiags.IRInfPosDr.BTDesc
				// 转归情况
				Set InfEffectDr="",InfEffect=""
				If $IsObject(objDiags.IRInfEffectDr){
					Set InfEffectDr=objDiags.IRInfEffectDr.%Id()
					Set InfEffect=objDiags.IRInfEffectDr.BTDesc
				}
				
				Set CSSInfPos=CSSInfPos_"$$"_xDiagID_"^"_InfPosID_"^"_InfPosDesc_"^"_InfDate_"^"_InfXDate_"^"_InfEffectDr_"^"_InfEffect
			}
			Set:CSSInfPos'="" CSSInfPos=$e(CSSInfPos,3,$l(CSSInfPos))
			Set:InfectionDesc="不存在" CSSInfPos=""
			Set return=ReportID_"!!"_xCSSID_"!!"_CSSInfPos_"!!"_InfCategory
		}
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-10-10
/// Description:  医院感染（例次）现患率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S410CssInf","CssQryInfPre","5","1")
Query CssQryInfPre(aSurNumID As %String, aLocModel As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInfSum:%Integer,LocCaseSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInfSum:%Integer,WardCaseSum:%Integer,HospInfSum:%Integer,HospCaseSum:%Integer,GroupInfSum:%Integer,GroupCaseSum:%Integer,HospPatSum:%Integer,GroupPatSum:%Integer,LocPatSum:%Integer,WardPatSum:%Integer,HospSurSum:%Integer,GroupSurSum:%Integer,LocSurSum:%Integer,WardSurSum:%Integer") [ SqlProc ]
{
}

ClassMethod CssQryInfPreExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocModel As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:aLocModel="" aLocModel="1"
	Quit:(aSurNumID="")||(aLocModel="") $$$OK
	//Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber	//
 	Quit:'$IsObject(objSExec.SEHospDr) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(objSExec.SEHospDr.%Id(),"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	/// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="CssQryInfPre"
	Kill ^TMP($zn,$j,NIndex)
    
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 // 当天转入不算在内
		//Continue:(Status="A2")              // 当天转入当天转出不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		// 医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
		// 全院住院患者人数
		If '$d(^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm")=num+1
		}
		//横断面是否调查
		if $d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
		{
			// 全院人数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","SurPat",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","SurPat",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","SurPat"))
				Set ^TMP($zn,$j,NIndex,"Hosp","SurPat")=num+1
			}			
		}
			
		// 避免重复获取感染部位
		Set InfPosDescs=""
		If (('$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)))&&($d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))))
		{
			Set InfPosDescs =..GetCurrInfPosInfo(Paadm,aDateFrom,aDateTo)
		}
		Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)=""
		If (InfPosDescs'="") {
			// 全院感染人数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","InfPat",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","InfPat",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
				Set ^TMP($zn,$j,NIndex,"Hosp","InfPat")=num+1
			}
			// 全院感染例次数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","InfCase"))
				Set ^TMP($zn,$j,NIndex,"Hosp","InfCase")=num+$l(InfPosDescs,"|")
			}
		}
		Set ^TMP($zn,$j,NIndex,"TansLoc",TansID) = ""
	}

	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,NIndex,"TansLoc",xTransID))
		Quit:xTransID=""
		
		Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
		Continue:'$IsObject(objTrans)
		
		Set objPaadm = objTrans.PAEpisodeDr
		Set objTransLoc = objTrans.PATransLocDr
		Continue:'$IsObject(objPaadm)
		Continue:'$IsObject(objTransLoc)
		
		Set EpisodeID =objPaadm.%Id()
		Set LocID =  objTransLoc.%Id()
		Set TransDate = objTrans.PATransDate
		Set OutLocDate= objTrans.PAOutLocDate	
	   
	    Set GroupDr="",GroupCode="",GroupDesc=""
		If $IsObject(objTransLoc.BTGroupDr) {
			Set GroupDr 	= objTransLoc.BTGroupDr.%Id()
			Set GroupCode	= objTransLoc.BTGroupDr.BTCode
			Set GroupDesc	= objTransLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="其他科"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm"))
			Set ^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm")=num+1
		}
		
		If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"PatAdm"))
			Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"PatAdm")=num+1
		}
		//实查
		If $d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,EpisodeID)) {
			// 科室人数
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"SurPat",EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"SurPat",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"SurPat"))
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"SurPat")=num+1
			}
			//科室组
			If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"SurPat",EpisodeID))
			{
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"SurPat",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"SurPat"))
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"SurPat")=num+1
			}
		}
		Set:TransDate<aDateFrom TransDate = aDateFrom
		Set:OutLocDate>aDateTo OutLocDate = aDateTo
		//当前未转出,截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate = aDateTo
		Set InfPosDescs =..GetCurrInfPosInfo(EpisodeID,TransDate,EndDate)
		If ((InfPosDescs'="")&&($d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,EpisodeID)))) {
			// 科室感染人数
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat",EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat"))
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat")=num+1
			}
			// 科室感染例次数 
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase",EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase"))
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase")=num+$l(InfPosDescs,"|")
			}
			// 科室组感染人数
			If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat",EpisodeID))
			{
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat"))
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat")=num+1
			}
			// 科室组感染例次数
			If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase",EpisodeID))
			{
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase"))
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase")=num+$l(InfPosDescs,"|")
			}
		}	
	}
	if (aLocModel="2")
	{
		// 同期在病区
	    Set ListWardArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"W","","I") //某段时间的在科人数
	    For index2=1:1:ListWardArray.Count() {
			Set TransInfo=ListWardArray.GetAt(index2)	
			Continue:TransInfo=""
			
			Set Date   = $LIST(TransInfo,1)
			Set Paadm  = $LIST(TransInfo,2)
			Set Status = $LIST(TransInfo,3)			
			Set LocID  = $LIST(TransInfo,4)	
			Set TansID = $LIST(TransInfo,5)
			Continue:(Status="I")                 //当天转入不算在内
			//Continue:(Status="A2")              //当天转入当天转出不算在内
			
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
			Continue:'$IsObject(objLoc)
			//  医院过滤
			Continue:'$IsObject(objLoc.BTHospDr)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
			
			Set ^TMP($zn,$j,NIndex,"TansWard",TansID) = ""
		}
		Set aTransID = ""
		For {
			Set aTransID = $o(^TMP($zn,$j,NIndex,"TansWard",aTransID))
			Quit:aTransID=""
			
			Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(aTransID)
			Continue:'$IsObject(objTrans)
			
			Set objPaadm = objTrans.PAEpisodeDr
			Set objTransLoc = objTrans.PATransLocDr
			Continue:'$IsObject(objPaadm)
			Continue:'$IsObject(objTransLoc)
			
			Set EpisodeID =objPaadm.%Id()
			Set WardID =  objTransLoc.%Id()
			Set TransDate = objTrans.PATransDate
			Set OutLocDate= objTrans.PAOutLocDate	
		   	If '$d(^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm",EpisodeID))
			{
				Set ^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm")=num+1
			}
			If $d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,EpisodeID)) {
				// 病区实查人数
				If '$d(^TMP($zn,$j,NIndex,"Ward",WardID,"SurPat",EpisodeID))
				{   
					Set ^TMP($zn,$j,NIndex,"Ward",WardID,"SurPat",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"SurPat"))
					Set ^TMP($zn,$j,NIndex,"Ward",WardID,"SurPat")=num+1
				}
			}
			//当前未转出,截止为查询结束日期
			Set:TransDate<aDateFrom TransDate = aDateFrom
			Set:OutLocDate>aDateTo OutLocDate = aDateTo
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate = aDateTo
			Set InfPosDescs =..GetCurrInfPosInfo(EpisodeID,TransDate,EndDate)
			//Set InfPosDescs =##class(DHCHAI.STAT.S390InfPos).GetInfPosInfo(EpisodeID,aDateFrom,aDateTo)
			If (InfPosDescs'="") {
				// 病区感染人数
				If '$d(^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat",EpisodeID))
				{   
					Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat"))
					Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat")=num+1
				}
				// 病区感染例次数 
				If '$d(^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase",EpisodeID))
				{   
					Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase"))
					Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase")=num+$l(InfPosDescs,"|")
				}
			}	
		}
	}
	// 全院感染人数、例次数
	Set HospPatSum  =+$g(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))
	Set HospInfSum  =+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
	Set HospCaseSum =+$g(^TMP($zn,$j,NIndex,"Hosp","InfCase"))
	Set HospSurSum  =+$g(^TMP($zn,$j,NIndex,"Hosp","SurPat"))  //全院实查人
	// 输出Data
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Loc",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set GroupDr="",GroupCode="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr 	= objLoc.BTGroupDr.%Id()
			Set GroupCode	= objLoc.BTGroupDr.BTCode
			Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="其他科"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		// 科室组感染人数、例次数
		Set GroupPatSum  =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"PatAdm"))
		Set GroupInfSum  =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat"))
		Set GroupCaseSum =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase"))
		Set GroupSurSum  =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"SurPat"))
		// 科室感染人数、例次数
		Set LocPatSum  =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"PatAdm"))
		Set LocInfSum  =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfPat")) 
		Set LocCaseSum =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfCase"))
		Set LocSurSum  =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"SurPat")) 
		if (aLocModel="2")   //科室病区模式展示
		{
			Set xSubID = ""
		 	For {
				Set xSubID = $o(^DHCHAI.BT.LocationD(xLocID,"Link",xSubID))
				Quit:xSubID=""
				
				Set xID = xLocID_"||"_xSubID
				Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xID)
				Continue:'$IsObject(objLocLink)
				Continue:'$IsObject(objLocLink.BTLinkLocDr)
				Continue:(+objLocLink.BTIsActive)'=1
				
				Set LinkWardID = objLocLink.BTLinkLocDr.%Id()
				Set LinkWardDesc = objLocLink.BTLinkLocDr.BTDesc2
				Set:LinkWardDesc="" LinkWardDesc = objLocLink.BTLinkLocDr.BTDesc
			    Set:$p(LinkWardDesc,"-",2)'="" LinkWardDesc=$p(LinkWardDesc,"-",2)	
			    // 病区感染人数、例次数
			    Set WardPatSum  =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"PatAdm"))   
			    Set WardInfSum  =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfPat"))	 
				Set WardCaseSum =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfCase"))		  
				Set WardSurSum  =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"SurPat"))
				Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInfSum,LocCaseSum,LinkWardID,LinkWardDesc,WardInfSum,WardCaseSum,HospInfSum,HospCaseSum,GroupInfSum,GroupCaseSum,HospPatSum,GroupPatSum,LocPatSum,WardPatSum,HospSurSum,GroupSurSum,LocSurSum,WardSurSum)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		 	}
		}
		else
		{
			Set (LinkWardID,LinkWardDesc)=""
			Set (WardPatSum,WardInfSum,WardCaseSum,WardSurSum) =0
			Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInfSum,LocCaseSum,LinkWardID,LinkWardDesc,WardInfSum,WardCaseSum,HospInfSum,HospCaseSum,GroupInfSum,GroupCaseSum,HospPatSum,GroupPatSum,LocPatSum,WardPatSum,HospSurSum,GroupSurSum,LocSurSum,WardSurSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryInfPreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryInfPreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryInfPreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryInfPreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  判断横断面是否发生医院感染,返回现患感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetCurrInfPosInfo("233","2018-12-01","2018-12-12")
ClassMethod GetCurrInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	Set RepType="7"  //横断面调查

	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
		Quit:xID=""
		Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Continue:'$IsObject(objINFRep)
		Set RepStatus=objINFRep.IRStatusDr
		Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
		Continue:RepStatus.BTCode="4"
		// 感染诊断信息
		Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			// 感染日期
			Set InfDate  = objDiags.IRInfDate
			Set InfXDate = objDiags.IRInfXDate
			Continue:InfDate>aDateTo    // 感染日期大于查询截止日期，非查询期间发生感染
			Continue:(InfXDate'="")&(InfXDate<=aDateTo) // 调查期间感染已结束
			// 感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_objInfPos.BTDesc
			}
		}
	}

	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  判断横断面是否发生医院感染,返回现患感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetSurInfo("3")
ClassMethod GetSurInfo(aSurNumID As %String) As %String
{
	New (aSurNumID)
	
	Set return = ""
	Quit:aSurNumID="" return
	Set objS = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Set DateFrom 	= objS.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set DateTo 	= objS.SESurvEndDate
 	Set SurNumber = objS.SESurvNumber	//
 	Quit:'$IsObject(objS.SEHospDr) return
 	Set DateFrom =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DateFrom)
 	Set DateTo =  ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DateTo)
 
 	Set return = DateFrom_"^"_DateTo_"^"_SurNumber_"^"_objS.SEHospDr.%Id()
 	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  横断面明细表
/// Table：       DHCHAI.DP.PAAdm
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S410CssInf","QryCSSInfPatDtl","5","")
Query QryCSSInfPatDtl(aSurNumID As %String, aTypeFlg As %String = "", aLocDesc As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,RepID:%String,InfType:%String,InfDates:%String,InfPosDescs:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryCSSInfPatDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aTypeFlg As %String = "", aLocDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aTypeFlg="" aTypeFlg=1
	Set xEpisodeID = ""
	For {
		Set xEpisodeID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,xEpisodeID))
		Quit:xEpisodeID=""    
				
		Set PatData =..BuildPaadmData(xEpisodeID)
		Continue:PatData=""
		Set AdmLocDesc=$lg(PatData,10)
		Continue:(aLocDesc'="")&(AdmLocDesc'=aLocDesc)
		Set (RepID,InfType,InfDate,InfDiag,InfZG) =""
		if (aTypeFlg="1")
		{
			Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeID,"7",xRepID))
				Quit:xRepID=""
				//取报告里的信息
				Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				if $Isobject(xObjRep) {
					Set RepID = xRepID
					Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
					Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
					if $IsObject(xObj) {
						Set InfType = xObj.IRInfCategoryDr  //0院内/1社区感染						
					}
					// 感染诊断信息
					Set LinkDiags = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
					
					For indx = 1:1:$l(LinkDiags,","){
						Set xDiagID = $p(LinkDiags,",",indx)
						Continue:xDiagID=""
						
						Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
						Continue:'$IsObject(objDiags)
						// 感染日期
						Set InfDate  = objDiags.IRInfDate
						Set InfXDate = objDiags.IRInfXDate
						
						Continue:InfDate>aDateTo    // 感染日期大于查询截止日期，非查询期间发生感染
						Continue:(InfXDate'="")&(InfXDate<=aDateTo) // 调查期间感染已结束
						Set:$IsObject(objDiags.IRInfEffectDr) InfZG = objDiags.IRInfEffectDr.BTDesc
						// 感染诊断						
						Set objInfPos = objDiags.IRInfPosDr
						Set InfDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
						If $IsObject(objInfPos){
							Set InfDiag = objInfPos.BTDesc							
							Set Data=PatData_$lb(RepID,InfType,InfDate,InfDiag,InfZG)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}						
					}
				}
			}			
		}    
		else
		{			
			Set Data=PatData_$lb(RepID,InfType,InfDate,InfDiag,InfZG)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}

	}
	Quit $$$OK
}

ClassMethod QryCSSInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSInfPatDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildPaadmData(aEpisodeID) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime

	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2019-11-15
/// Description:  医院感染（例次）现患率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S410CssInf","QryInfPreByCSS2","2019-11-19","2019-11-19","1")
Query QryInfPreByCSS2(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,SurPatCnt:%String,SurPatRatio:%String,InfPatCnt:%String,InfPatRatio:%String,InfCaseCnt:%String,InfCaseRatio:%String,ComInfPatCnt:%String,ComInfPatRatio:%String,ComInfCaseCnt:%String,ComInfCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfPreByCSS2Execute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aHospIDs="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Quit:(aDateFrom>+$h) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	/// 取所有需要调查的科室  默认是全院科室
    Set NIndex="QryInfPreByCSS2"
	Kill ^TMP($zn,$j,NIndex)
	
	Set StatDimensStr=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensStr()
	Quit:StatDimensStr="" 
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	
    //横断面调查病人就诊列表
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
    For index1=1:1:ListLocArray.Count() {
		Set CSSEpisInfo=ListLocArray.GetAt(index1)
		Continue:CSSEpisInfo=""
		
		Set Paadm       = $lg(CSSEpisInfo,1)
		Set TransID     = $lg(CSSEpisInfo,2)
		Set TransLocDr  = $lg(CSSEpisInfo,3)
		Set LinkLocDr   = $lg(CSSEpisInfo,4)
		Continue:(TransID="")||(TransLocDr="")
		Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(TransID)
		Continue:'$IsObject(objAdmTrans)
		Set TransType=objAdmTrans.PATransType
		If TransType="E" {
			Set objLoc=objAdmTrans.PATransLocDr
			Set objWard=""
		} Else {
			Set objLoc=objAdmTrans.PALinkLocDr
			Set objWard=objAdmTrans.PATransLocDr
		}
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set HospDr=objLoc.BTHospDr.%Id()
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		Set LocDr=objLoc.%Id()
		Set LocDesc=objLoc.BTDesc
		Set WardDr="",WardDesc=""
		If $IsObject(objWard){
			Set WardDr=objWard.%Id()
			Set WardDesc=objWard.BTDesc
		}
		Set GroupDr="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr=objLoc.BTGroupDr.%Id()
			Set GroupDesc=objLoc.BTGroupDr.BTDesc
		}
		
		//取横断面对应感染信息
		Set CSSInfDianosInfo=..GetInfPosInfo2(Paadm,aDateFrom,aDateTo)
		//Set CSSReportID=$p(CSSInfDianosInfo,"!!",1)
		Set CSSRepDianos=$p(CSSInfDianosInfo,"!!",1)
		// 感染分类 
		Set InfCategory=$p(CSSInfDianosInfo,"!!",2)
		//统计维度
		Set StatDimensInfo=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			//应查人数（住院人数）
			Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AdmPat"))
			
				//实查人数（调查人数）
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
				
				If CSSRepDianos'="" {
					If (InfCategory=1){ // 医院感染
						//感染人数
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
						//感染例数
						Set num=+$g(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfCase")=num+$l(CSSRepDianos,"$$")
					}Else{ // 社区感染
						//感染人数
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfPat"))
						//感染例数
						Set num=+$g(^TMP($zn,$j,NIndex,DimensKey,"ComInfCase"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"ComInfCase")=num+$l(CSSRepDianos,"$$")
					}
				}
		
	 	}
 	}
 	Set xDimensKey="",RowIndex=0
	For {
		Set xDimensKey=$o(^TMP($zn,$j,NIndex,xDimensKey))
		Quit:xDimensKey=""
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AdmPat"))  //应查人数
		Set SurPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //实查人数
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数
		Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例数
		
		Set ComInfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"ComInfPat"))  //社区感染人数
		Set ComInfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"ComInfCase")) //社区感染例数
		
		Set SurPatRatio=""
		Set:PatAdmCnt>0 SurPatRatio=$fn((SurPatCnt/PatAdmCnt)*100,"",2)_"%" //实查率
		Set InfPatRatio="0.00%",InfCaseRatio="0.00%"
		Set:SurPatCnt>0 InfPatRatio=$fn((InfPatCnt/SurPatCnt)*100,"",2)_"%" //现患率
		Set:SurPatCnt>0 InfCaseRatio=$fn((InfCaseCnt/SurPatCnt)*100,"",2)_"%" //现患例次率
		Set ComInfPatRatio="0.00%",ComInfCaseRatio="0.00%"
		Set:SurPatCnt>0 ComInfPatRatio=$fn((ComInfPatCnt/SurPatCnt)*100,"",2)_"%" //社区现患率
		Set:SurPatCnt>0 ComInfCaseRatio=$fn((ComInfCaseCnt/SurPatCnt)*100,"",2)_"%" //社区现患例次率
		
		Set DimensDesc=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensDesc(xDimensKey)
		Set RowIndex=RowIndex+1
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,SurPatCnt,SurPatRatio,InfPatCnt,InfPatRatio,InfCaseCnt,InfCaseRatio,ComInfPatCnt,ComInfPatRatio,ComInfCaseCnt,ComInfCaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		}
	Kill ^TMP($zn,$j,NIndex)
 	Quit $$$OK
}

ClassMethod QryInfPreByCSS2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreByCSS2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreByCSS2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreByCSS2Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhangdc
/// CreatDate：   2019-11-19
/// Description:  取现患感染信息
/// Table：       DHCHAI.IR.INFCSS、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetCSSInfDianosInfo2("153","2019-11-01","2019-11-29")
ClassMethod GetCSSInfDianosInfo2(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set CSSInfFlag=0,CSSInfPos=""
	Set xCSSID=0
	For {
		Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexIREpisodeDr",aEpisodeID,xCSSID))
		Quit:xCSSID=""
		Set objCSS=##class(DHCHAI.IR.INFCSS).GetObjById(xCSSID)
		Continue:'$IsObject(objCSS)
		Continue:objCSS.IRIsActive'=1
		Continue:'$IsObject(objCSS.IRInfectionDr)
		// 感染分类 1：社区感染 0：医院感染
		Set InfCategory = objCSS.IRInfCategoryDr
		Set InfectionDesc = objCSS.IRInfectionDr.BTDesc
		Set:InfectionDesc="不存在" InfCategory=""
		Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFCSS",xCSSID)
		For indRep=1:1:arrReport.Count() {
			Set objRep=arrReport.GetAt(indRep)
			Continue:'$IsObject(objRep)
			Set ReportID=objRep.%Id()
			Continue:'$IsObject(objRep.IRStatusDr)
			Set RepStatus=objRep.IRStatusDr.BTCode
			//1保存、2提交、3审核、4作废、5退回、6取消审核
			Continue:(RepStatus="4")
			
			// 感染诊断信息
			Set CSSInfPos=""
			Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				Continue:'$IsObject(objDiags.IRInfPosDr)
				// 感染日期、感染转归日期
				Set InfDate  = objDiags.IRInfDate
				Set InfXDate = objDiags.IRInfXDate
				//Continue:'(InfDate>=aDateFrom)&&(InfDate<=aDateFrom)&&(InfXDate>aDateTo)
				Continue:((InfDate>aDateTo)||(InfXDate<aDateFrom))
				// 感染诊断ID、感染诊断名称
				Set InfPosID   = objDiags.IRInfPosDr.%Id()
				Set InfPosDesc = objDiags.IRInfPosDr.BTDesc
				// 转归情况
				Set InfEffectDr="",InfEffect=""
				If $IsObject(objDiags.IRInfEffectDr){
					Set InfEffectDr=objDiags.IRInfEffectDr.%Id()
					Set InfEffect=objDiags.IRInfEffectDr.BTDesc
				}
				
				Set CSSInfPos=CSSInfPos_"$$"_xDiagID_"^"_InfPosID_"^"_InfPosDesc_"^"_InfDate_"^"_InfXDate_"^"_InfEffectDr_"^"_InfEffect
			}
			b ;1
			Set:CSSInfPos'="" CSSInfPos=$e(CSSInfPos,3,$l(CSSInfPos))
			Set:InfectionDesc="不存在" CSSInfPos=""
			Set return=ReportID_"!!"_xCSSID_"!!"_CSSInfPos_"!!"_InfCategory
		}
	}
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2019-11-29
/// Description:  判断患者是否发生医院感染,返回感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetInfPosInfo2("153","2019-11-01","2019-11-29")
ClassMethod GetInfPosInfo2(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	//入院日期和出院日期
	Set AdmitDate=objPaadm.PAAdmDate
	Set DischDate=objPaadm.PADischDate
	Set InfPosDescs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			
			Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Quit:'$IsObject(objINFRep)
			Set RepStatus=objINFRep.IRStatusDr
			Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
			Continue:RepStatus.BTCode'="3"
			// 感染诊断信息
			Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				// 感染分类 不是社区感染的就是医院感染
				Set InfCategory = objDiags.IRInfType
				if InfCategory'=0{
					Set InfCategory = 1
				}
				// 感染日期
				Set InfDate  = objDiags.IRInfDate
				Set InfXDate = objDiags.IRInfXDate
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				//Continue:(InfDate>DischDate)||(AdmitDate>InfXDate)	//出院日期
				//Continue:(InfDate>DischDate)||(AdmitDate>InfXDate)
				// 感染诊断
				Set objInfPos = objDiags.IRInfPosDr
				If $IsObject(objInfPos){
					Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_objInfPos.BTDesc_"!!"_InfCategory
				}
			}
			Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
			Set return=InfPosDescs
		}
		
	}
	Quit return
}

}

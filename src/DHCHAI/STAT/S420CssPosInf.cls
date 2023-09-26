/// 名称: DHCHAI.STAT.S390InfPos
/// 描述: 住院患者医院感染部位分布统计表
/// 编写者：chenjb
/// 编写日期: 2018-10-12
Class DHCHAI.STAT.S420CssPosInf Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-01-11
/// Description:  现患科室感染部位分布统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
///               aInfType : 感染类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S420CssPosInf","QryInfPosCSS","1","","")
Query QryInfPosCSS(aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,InfPatCnt:%String,InfCaseCnt:%String,InfDiagDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber	//
 	Quit:'$IsObject(objSExec.SEHospDr) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(objSExec.SEHospDr.%Id(),"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    
    Set NIndex="QryInfPosCSS"
	Kill ^TMP($zn,$j,NIndex)
    //重要：判断标准都是以时间为准，在科期间 框定感染日期是否在期间，并未结束的
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
		//未调查
		Continue:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
		
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
		Set CSSInfDianosInfo =..GetCSSInfDianosInfo(aSurNumID,Paadm,aInfType)
		Set CSSReportID=$p(CSSInfDianosInfo,"!!",1)
		Set CSSRepDianos=$p(CSSInfDianosInfo,"!!",3)
		//统计维度
		Set StatDimensInfo=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			If (CSSReportID'=""){ // 医院感染
				If (CSSRepDianos'=""){
					//感染人数
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
					//感染例数
					Set num=+$g(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"InfCase")=num+$l(CSSRepDianos,"$$")
					//记录感染部位信息
					For indxi=1:1:$l(CSSRepDianos,"$$") {
						Set tmpInfPos     = $p(CSSRepDianos,"$$",indxi)
						Set tmpDiagID     = $p(tmpInfPos,"^",1)
						Set tmpInfPosDesc = $p(tmpInfPos,"^",3)
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",tmpDiagID)=tmpInfPosDesc
					}
				}
			}
		}	
    }
    Set xDimensKey=""
	For {
		Set xDimensKey=$o(^TMP($zn,$j,NIndex,xDimensKey))
		Quit:xDimensKey=""
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数
		Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例数
		Set DimensDesc=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensDesc(xDimensKey)
		Set xDiagID=""
		For {
			Set xDiagID=$o(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList",xDiagID))
			Quit:xDiagID=""
			Set InfDiagDesc =$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList",xDiagID))
			Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,InfDiagDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPosCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2019-01-11
/// Description:  横断面科室感染部位分布统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID： 调查编号ID
/// 			  aDimensKey：维度
/// 			  aPosDesc：  感染部位名称 
///               aInfType:   感染类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S420CssPosInf","QryInfPosCSSDtl","1","A0-G00000001-E00000067","","0")
Query QryInfPosCSSDtl(aSurNumID As %String, aDimensKey As %String, aPosDesc As %String, aInfType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,CSSGroupDesc:%String,CSSLocDesc:%String,CSSWardDesc:%String,CSSTransDateTime:%String,CSSOutLocDateTime:%String,CSSRecordID:%String,CSSInfDiagnos:%String,CSSInfDate:%String,CSSInfEffect:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aPosDesc As %String, aInfType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="")||(aDimensKey="") $$$OK
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
    
    Set NIndex="QryInfPosCSSDtl"
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
		//未调查
		Continue:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
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
		Set CSSInfDianosInfo =..GetCSSInfDianosInfo(aSurNumID,Paadm,aInfType)
		Set CSSReportID=$p(CSSInfDianosInfo,"!!",1)
		Set CSSRepDianos=$p(CSSInfDianosInfo,"!!",3)
		
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    //应查人数、实查人数、感染人数
		Set tInfDiagnos="",tInfDate="",tInfEffect=""
		For indRD=1:1:$l(CSSRepDianos,"$$") {
			Set tRepDiagnos=$p(CSSRepDianos,"$$",indRD)
			Continue:tRepDiagnos=""
			Set InfDiagnos=$p(tRepDiagnos,"^",3)
			// 感染诊断过滤
			Continue:(aPosDesc'="")&&(aPosDesc'=InfDiagnos)
			Set InfDate=$p(tRepDiagnos,"^",4)
			Set:InfDate'["-" InfDate=$zd(InfDate,3)
			Set InfEffect=$p(tRepDiagnos,"^",7)
			
			Set tInfDiagnos=tInfDiagnos_","_InfDiagnos
			Set tInfDate=tInfDate_","_InfDate
			Set tInfEffect=tInfEffect_","_InfEffect
		}
		Continue:tInfDiagnos="" // 当感染信息明细无感染部位时过滤掉
		Set tInfDiagnos=$e(tInfDiagnos,2,$l(tInfDiagnos))
		Set:tInfDate'="" tInfDate=$e(tInfDate,2,$l(tInfDate))
		Set:tInfEffect'="" tInfEffect=$e(tInfEffect,2,$l(tInfEffect))
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDateTime,OutLocDateTime,CSSReportID,tInfDiagnos,tInfDate,tInfEffects)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
    
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPosCSSDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2019-01-11
/// Description:  取现患感染信息
/// Table：       DHCHAI.IR.INFCSS、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
///               aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S420CssPosInf).GetCSSInfDianosInfo(1,"74321","0")
ClassMethod GetCSSInfDianosInfo(aSurNumID As %String, aEpisodeID As %String, aInfType As %String) As %String
{
	New (aSurNumID,aEpisodeID,aInfType)
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
		Continue:(aInfType'="")&&(aInfType'=InfCategory)
		
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
/// CreatDate：   2018-10-12
/// Description:  现患感染部位分布统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
///               aInfType : 感染类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S420CssPosInf","QryCSSInfPos","3","")
Query QryCSSInfPos(aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInfSum:%Integer,LocCaseSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInfSum:%Integer,WardCaseSum:%Integer,HospInfSum:%Integer,HospCaseSum:%Integer,GroupInfSum:%Integer,GroupCaseSum:%Integer,InfDiagDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCSSInfPosExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocModel As %String, aInfType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber	//
 	Quit:'$IsObject(objSExec.SEHospDr) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(objSExec.SEHospDr.%Id(),"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    
    Set NIndex="QryCSSInfPos"
	Kill ^TMP($zn,$j,NIndex)
    //重要：判断标准都是以时间为准，在科期间 框定感染日期是否在期间，并未结束的
    
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
		//未调查
		Continue:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		// 医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
		// 避免重复获取感染部位
		Set InfPosDescs=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm))
		{
			Set InfPosDescs =##class(DHCHAI.STAT.S450CssBacPos).GetCurrInfPosInfo1(Paadm,aDateFrom,aDateTo,aInfType)
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
			Set GroupDesc="默认科室分组"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		//当前未转出,截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
		Set InfPosDescs =##class(DHCHAI.STAT.S450CssBacPos).GetCurrInfPosInfo1(EpisodeID,TransDate,EndDate,aInfType)
		If (InfPosDescs'="") {
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
	   
		//当前未转出,截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate = aDateTo
		Set InfPosDescs =##class(DHCHAI.STAT.S450CssBacPos).GetCurrInfPosInfo1(EpisodeID,TransDate,EndDate,aInfType)
		If (InfPosDescs'="") {
			// 记录病区感染部位信息
			For indxi=1:1:$l(InfPosDescs,"|") {
				Set tmpInfPos     = $p(InfPosDescs,"|",indxi)
				Set tmpDiagID     = $p(tmpInfPos,"^",1)
				Set tmpInfPosDesc = $p(tmpInfPos,"^",2)
				Set ^TMP($zn,$j,NIndex,"InfPosList",WardID,tmpDiagID)=tmpInfPosDesc
			}
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
	// 全院感染人数、例次数
	Set HospInfSum  =+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
	Set HospCaseSum =+$g(^TMP($zn,$j,NIndex,"Hosp","InfCase"))
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
			Set GroupDesc="默认科室分组"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		// 科室组感染人数、例次数
		Set GroupInfSum  =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat"))
		Set GroupCaseSum =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase"))
		// 科室感染人数、例次数
		Set LocInfSum  =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfPat")) 
		Set LocCaseSum =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfCase"))
	
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
		    Set WardInfSum  =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfPat"))	 
			Set WardCaseSum =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfCase"))		  
			
			Set xDiagID=""
			For {
				Set xDiagID=$o(^TMP($zn,$j,NIndex,"InfPosList",LinkWardID,xDiagID))
				Quit:xDiagID=""
				Set InfDiagDesc =$g(^TMP($zn,$j,NIndex,"InfPosList",LinkWardID,xDiagID))
				Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInfSum,LocCaseSum,LinkWardID,LinkWardDesc,WardInfSum,WardCaseSum,HospInfSum,HospCaseSum,GroupInfSum,GroupCaseSum,InfDiagDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	 	}
	   
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCSSInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSInfPosExecute ]
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
/// CreatDate：   2018-08-23
/// Description:  横断面感染部位分布统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// 			  aPosDesc： 感染部位名称 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S420CssPosInf","QryCSSInfPosPatDtl","","2018-08-01","2018-08-10","E","","","")
Query QryCSSInfPosPatDtl(aSurNumID As %String, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aPosDesc As %String, aInfType As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryCSSInfPosPatDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aPosDesc As %String, aInfType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryCSSInfPosPatDtl"
	Kill ^TMP($zn,$j,NIndex)
  
    //同期在科、在病区
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 //当天转入不算在内
		//Continue:(Status="A2")              //当天转入当天转出不算在内
		//未调查
		Continue:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤		
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set GroupDr="",GroupCode="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr 	= objLoc.BTGroupDr.%Id()
			Set GroupCode	= objLoc.BTGroupDr.BTCode
			Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="默认科室分组"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
		Set ^TMP($zn,$j,NIndex,aLocType,TansID) = ""
	}
	If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,NIndex,"W",xTransID))
			Quit:xTransID=""
			
			Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$IsObject(objTrans)
			
			Set objPaadm = objTrans.PAEpisodeDr
			Set objTransLoc = objTrans.PATransLocDr
			Continue:'$IsObject(objPaadm)
			Continue:'$IsObject(objTransLoc)
						
			Set EpisodeID =objPaadm.%Id()
			Set TransWardID =  objTransLoc.%Id()
			Set TransWardDesc = objTransLoc.BTDesc2
			Set:TransWardDesc="" TransWardDesc = objTransLoc.BTDesc
			Continue:TransWardDesc=""
			Set:$p(TransWardDesc,"-",2)'="" TransWardDesc=$p(TransWardDesc,"-",2)
			Set TransDate = objTrans.PATransDate
			Set OutLocDate= objTrans.PAOutLocDate
			//当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate = aDateTo
			
			Set InfPoss =##class(DHCHAI.STAT.S450CssBacPos).GetCurrInfPosInfo1(EpisodeID,TransDate,EndDate,aInfType)
			Set (InfPosDescs,InfDates,InfEffects)=""
			For indxi=1:1:$l(InfPoss,"|") {
				Set tmpInfPos      = $p(InfPoss,"|",indxi)
				Set tmpInfPosID    = $p(InfPoss,"^",1)
				Set tmpInfPosDescs = $p(InfPoss,"^",2)
				Set InfPosDescs    = InfPosDescs_"|"_tmpInfPosDescs
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(tmpInfPosID)
				If ($IsObject(objDiags)){
					// 感染日期
					Set InfEffect=""
					Set InfDate  = objDiags.IRInfDate
					Set InfDate  = $zd(InfDate,3)
					Set InfDates = InfDates_","_InfDate
					Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
					Set InfEffects = InfEffects_","_InfEffect
				}
			}
			Set:InfDates'="" InfDates=$e(InfDates,2,$l(InfDates))
			Set:InfEffects'="" InfEffects=$e(InfEffects,2,$l(InfEffects)) // 感染转归
			Set:InfPosDescs'="" InfPosDescs=InfPosDescs_"|"
			Continue:(aPosDesc'="")&&(InfPosDescs'[("|"_aPosDesc_"|"))  // 感染部位过滤
			
			Set GroupDr="",GroupCode="",GroupDesc=""
			If $IsObject(objTransLoc.BTGroupDr) {
				Set GroupDr 	= objTransLoc.BTGroupDr.%Id()
				Set GroupCode	= objTransLoc.BTGroupDr.BTCode
				Set GroupDesc	= objTransLoc.BTGroupDr.BTDesc	
			}Else {
				Set GroupDesc="默认科室分组"
				Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
				If $IsObject(objGroup) {
					Set GroupDr 	= objGroup.%Id()
					Set GroupCode	= objGroup.BTCode
				}
			}
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime = objTrans.PATransTime
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime =objTrans.PAOutLocTime
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
		    Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InfPosDescs,InfDates,InfEffects)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    
		}
    }
	If (aLocType="E") {
	    Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,NIndex,"E",xTransID))
			Quit:xTransID=""
			
			Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$IsObject(objTrans)
			
			Set objPaadm = objTrans.PAEpisodeDr
			Set objTransLoc = objTrans.PATransLocDr
			Continue:'$IsObject(objPaadm)
			Continue:'$IsObject(objTransLoc)
			
			Set EpisodeID =objPaadm.%Id()
			Set LocID =  objTransLoc.%Id()
			Set LocDesc = objTransLoc.BTDesc2
			Set:LocDesc="" LocDesc = objTransLoc.BTDesc
			Continue:LocDesc=""
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			
			Set TransDate = objTrans.PATransDate
			Set OutLocDate= objTrans.PAOutLocDate
			//当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate = aDateTo
			
			Set InfPoss =##class(DHCHAI.STAT.S450CssBacPos).GetCurrInfPosInfo1(EpisodeID,TransDate,EndDate,aInfType)
			Set (InfPosDescs,InfDates,InfEffects)=""
			For indxi=1:1:$l(InfPoss,"|") {
				Set tmpInfPos      = $p(InfPoss,"|",indxi)
				Set tmpInfPosID    = $p(InfPoss,"^",1)
				Set tmpInfPosDescs = $p(InfPoss,"^",2)
				Set InfPosDescs    = InfPosDescs_"|"_tmpInfPosDescs
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(tmpInfPosID)
				If ($IsObject(objDiags)){
					// 感染日期
					Set InfEffect=""
					Set InfDate  = objDiags.IRInfDate
					Set InfDate  = $zd(InfDate,3)
					Set InfDates = InfDates_","_InfDate
					Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
					Set InfEffects = InfEffects_","_InfEffect
				}
			}
			Set:InfDates'="" InfDates=$e(InfDates,2,$l(InfDates))
			Set:InfEffects'="" InfEffects=$e(InfEffects,2,$l(InfEffects)) // 感染转归
			Set:InfPosDescs'="" InfPosDescs=InfPosDescs_"|"
			Continue:(aPosDesc'="")&&(InfPosDescs'[("|"_aPosDesc_"|"))  // 感染部位过滤
			
			Set GroupDr="",GroupCode="",GroupDesc=""
			If $IsObject(objTransLoc.BTGroupDr) {
				Set GroupDr 	= objTransLoc.BTGroupDr.%Id()
				Set GroupCode	= objTransLoc.BTGroupDr.BTCode
				Set GroupDesc	= objTransLoc.BTGroupDr.BTDesc	
			}Else {
				Set GroupDesc="默认科室分组"
				Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
				If $IsObject(objGroup) {
					Set GroupDr 	= objGroup.%Id()
					Set GroupCode	= objGroup.BTCode
				}
			}			
			Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    
		    Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
			
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xDate,xID))
					Quit:xID=""
				
					Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
					Continue:'$IsObject(objTrans)
					Continue:'$IsObject(objTrans.PATransLocDr)
					
					Set TransWardID=objTrans.PATransLocDr.%Id()
					Set TransWardDesc=objTrans.PATransLocDr.BTDesc2
					Set:TransWardDesc="" TransWardDesc=objTrans.PATransLocDr.BTDesc
				    Set:TransWardDesc["-" TransWardDesc=$p(TransWardDesc,"-",2)
				
					Set TransDate=objTrans.PATransDate
					Set OutLocDate=objTrans.PAOutLocDate
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
						    
					Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InfPosDescs,InfDates,InfEffects)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCSSInfPosPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSInfPosPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSInfPosPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSInfPosPatDtlExecute ]
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

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
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

}

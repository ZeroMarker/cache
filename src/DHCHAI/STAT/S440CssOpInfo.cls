/// 名称: DHCHAI.STAT.S440CssOpInfo
/// 描述: 医院感染横断面调查
/// 编写者：chenjb
/// 编写日期: 2018-10-10
Class DHCHAI.STAT.S440CssOpInfo Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2018-10-10
/// Description:  医院感染（例次）现患率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S440CssOpInfo","CssQryOpInfo","7")
Query CssQryOpInfo(aSurNumID As %String) As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,SurPatCnt:%String,SurPatRatio:%String,OpUseCnt:%String,OpUseI:%String,OpUseII:%String,OpUseIII:%String,OpUseIV:%String,OpUse0:%String") [ SqlProc ]
{
}

ClassMethod CssQryOpInfoExecute(ByRef qHandle As %Binary, aSurNumID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
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
    Set NIndex="CssQryOpInfo"
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
		//1019
		//取横断面对应感染信息
		Set CSSOpInfo=..GetOpInfo(aSurNumID,Paadm)
		Set CSSReportID = $p(CSSOpInfo,"!!",1)
		Set OpUse=+$p(CSSOpInfo,"!!",2)
		Set OpUseDesc=$p(CSSOpInfo,"!!",3)
		
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
				
				If OpUse=1 {
					//手术人数
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OpUse"))
					if (OpUseDesc'="")
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,OpUseDesc))
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
		Set OpUseCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OpUse"))  //手术人数
		Set OpUseI  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅰ类"))
		Set OpUseII =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅱ类"))
		Set OpUseIII=+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅲ类"))
		Set OpUseIV =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅳ类"))
		Set OpUse0  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"无"))
		
		Set SurPatRatio=""
		Set:PatAdmCnt>0 SurPatRatio=$fn((SurPatCnt/PatAdmCnt)*100,"",2)_"%" //实查率
		Set InfPatRatio="0.00%",InfCaseRatio="0.00%"		
		
		Set DimensDesc=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensDesc(xDimensKey)
		Set RowIndex=RowIndex+1
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,SurPatCnt,SurPatRatio,OpUseCnt)
		Set Data=Data_$lb(OpUseI,OpUseII,OpUseIII,OpUseIV,OpUse0)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}

	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryOpInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryOpInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryOpInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryOpInfoExecute ]
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
/// w ##class(DHCHAI.STAT.S410CssInf).GetCurrInfPosInfo("2561","64728","64870")
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
		Quit:'$IsObject(objINFRep)
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

/// Creator：     zhufei
/// CreatDate：   2018-12-16
/// Description:  手术病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID   ：调查ID
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S440CssOpInfo","QryOpDtlByCSS","5","A0-G00000007-E00000057",1)
Query QryOpDtlByCSS(aSurNumID As %String, aDimensKey As %String, aTypeFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,CSSGroupDesc:%String,CSSLocDesc:%String,CSSWardDesc:%String,CSSTransDateTime:%String,CSSOutLocDateTime:%String,CSSRecordID:%String,OpUse:%String,OpUseDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOpDtlByCSSExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aTypeFlag As %String) As %Status
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
	
    Set NIndex="QryOpDtlByCSS"
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
		Set CSSOpInfo=..GetOpInfo(aSurNumID,Paadm)
		Set CSSReportID = $p(CSSOpInfo,"!!",1)
		Set OpUse=+$p(CSSOpInfo,"!!",2)
		Set OpUseDesc=$p(CSSOpInfo,"!!",3)
		
		Continue:(aTypeFlag=1)&&(OpUse'=1)
		
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    Set:WardDesc="" WardDesc=$lg(PatData,11)
		If (aTypeFlag=1){
			//手术人数
			
			Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDateTime,OutLocDateTime,CSSReportID,"是",OpUseDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		} ElseIf aTypeFlag=2 {
			//例数			
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOpDtlByCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpDtlByCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpDtlByCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpDtlByCSSExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  判断横断面是否发生医院感染,返回现患感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S440CssOpInfo).GetOpInfo("7","1019")
ClassMethod GetOpInfo(aSurNumID As %String, aEpisodeID As %String) As %String
{
	New (aSurNumID,aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="")||(aSurNumID="") return
	
	Set xCSSID=0
	For {
		Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID,xCSSID))
		Quit:xCSSID=""
		
		Set objCSS=##class(DHCHAI.IR.INFCSS).GetObjById(xCSSID)
		Continue:'$IsObject(objCSS)
		Continue:objCSS.IRIsActive'=1
		
		Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFCSS",xCSSID)
		Set RepFlag =0   //报告状态位判断
		Set ReportID ="" //最后一份报告ID
		For indRep=1:1:arrReport.Count() {
			Quit:RepFlag=1
			Set objRep=arrReport.GetAt(indRep)
			Continue:'$IsObject(objRep)
			Set ReportID=objRep.%Id()
			Continue:'$IsObject(objRep.IRStatusDr)
			Set RepStatus=objRep.IRStatusDr.BTCode
			//1保存、2提交、3审核、4作废、5退回、6取消审核
			Continue:(RepStatus="4")
			Set RepFlag=1			
		}
		Continue:RepFlag=0
		Set (OperCut)=""
		Set IROperFlag    = +objCSS.IROperFlag      //是否手术
		Set objIROperCuteTypeDr     = objCSS.IROperCuteTypeDr
		Set:$Isobject(objIROperCuteTypeDr) OperCut=objIROperCuteTypeDr.BTDesc		
		Set return = ReportID_"!!"_IROperFlag_"!!"_OperCut
	}
	Quit return
}

}

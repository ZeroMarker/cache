/// 名称:DHCMed.NINFService.BC.CommonSrv
/// 描述: 公用方法
/// 编写者：zhufei
/// 编写日期: 2013-12-06
Class DHCMed.NINFService.BC.CommonSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 取入院时间
/// w ##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(4)
ClassMethod GetInHospDateTime(aEpisodeID As %String) As %String
{
	new (aEpisodeID)
	set return=""
	quit:aEpisodeID="" return
	
	set AdmDate="",AdmTime=""
	set xTransID=""
	for {
		set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		quit:xTransID=""
		quit:AdmDate'=""
		
		set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		continue:tmpTrans=""
		set tmpBedDr=$p(tmpTrans,"^",8)
		continue:tmpBedDr=""
		set AdmDate=$p(tmpTrans,"^",1)
		set AdmTime=+$p(tmpTrans,"^",2)
	}
	if AdmDate="" {
		set AdmDate=$p($g(^PAADM(+aEpisodeID)),"^",6)
		set AdmTime=+$p($g(^PAADM(+aEpisodeID)),"^",7)
	}
	quit:AdmDate="" return
	
	set return=AdmDate_","_AdmTime
	quit return
}

/// 取入科时间
/// w ##class(DHCMed.NINFService.BC.CommonSrv).GetInLocDateTime(4)
ClassMethod GetInLocDateTime(aEpisodeID As %String, aLocType As %String = "E") As %String
{
	new (aEpisodeID,aLocType)
	set return=""
	quit:aEpisodeID="" return
	
	set:aLocType="" aLocType="E"
	
	set AdmDate="",AdmTime="",CurrLocID=""
	set xTransID=""
	for {
		set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID),-1)
		quit:xTransID=""
		
		set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		continue:tmpTrans=""
		if aLocType="E" {
			set TransLoc=$p(tmpTrans,"^",6)
		} else {
			set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			set TransLoc=$p($g(^PAWARD(+TransLoc)),"^",5)
		}
		continue:TransLoc=""
		quit:(CurrLocID'="")&&(CurrLocID'=TransLoc)  //找到上一个不同科室即结束
		
		set CurrLocID=TransLoc
		set AdmDate=$p(tmpTrans,"^",1)
		set AdmTime=+$p(tmpTrans,"^",2)
	}
	quit:AdmDate="" return
	
	set return=AdmDate_","_AdmTime
	quit return
}

/// 取入院科室和病区（入参：就诊号）
/// w ##class(DHCMed.NINFService.BC.CommonSrv).GetInHospLocWard(9)
ClassMethod GetInHospLocWard(aEpisodeID As %String) As %String
{
	new (aEpisodeID)
	set return=""
	quit:aEpisodeID="" return
	
	set LocID="",LocDesc="",WardID="",WardDesc=""
	set xTransID=""
	for {
		set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		quit:xTransID=""
		quit:(LocID'="")&&(WardID'="")
		
		set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		continue:tmpTrans=""
		set TransLoc=$p(tmpTrans,"^",6)
		if TransLoc'="" {
			set:LocID="" LocID=TransLoc
		}
		set TransWard=$p($p(tmpTrans,"^",8),"||",1)
		if TransWard'="" {
			set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
			set:WardID="" WardID=TransWard
		}
	}
	
	set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	set LocDesc=$tr(LocDesc,",","")
	
	set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
	set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
	set WardDesc=$tr(WardDesc,",","")
	
	set return=LocID_","_LocDesc_","_WardID_","_WardDesc
	quit return
}

/// 取就诊科室和病区（入参：就诊号+日期+时间）
/// w ##class(DHCMed.NINFService.BC.CommonSrv).GetAdmitLocWard(9,+$h,$p($h,",",2))
ClassMethod GetAdmitLocWard(aEpisodeID As %String, aActDate As %String, aActTime As %String)
{
	new (aEpisodeID,aActDate,aActTime)
	set return=""
	quit:(aEpisodeID="")||(aActDate="")||(aActTime="") return
	
	set:aActDate["-" aActDate=$zdh(aActDate,3)
	set:aActTime[":" aActTime=$zth(aActTime,1)
	set:aActDate'="" aActTime=+aActTime
	
	set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
	set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
	if (AdmDate>aActDate)||((AdmDate=aActDate)&&(AdmTime>aActTime)) {
		set aActDate=AdmDate
		set aActTime=AdmTime
	}
	
	set LocID="",LocDesc="",WardID="",WardDesc=""
	
	//Add By LiYang 2014-12-28 FixBug :Ward Empty
	Set tWardID=+$p($g(^PAADM(+aEpisodeID)),"^",70)
	Set Ward=$g(^PAWARD(+tWardID))
	Set WardCtlocID=$p(Ward,"^",5)
	Set WardID=WardCtlocID
	//
	
	
	set xTransID=""
	for {
		set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		quit:xTransID=""
		
		set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		continue:tmpTrans=""
		set TransDate=$p(tmpTrans,"^",1)
		set TransTime=$p(tmpTrans,"^",2)
		quit:(TransDate>aActDate)
		quit:(TransDate=aActDate)&&(TransTime>aActTime)
		
		set TransLoc=$p(tmpTrans,"^",6)
		if TransLoc'="" {
			set LocID=TransLoc
		}
		set TransWard=$p($p(tmpTrans,"^",8),"||",1)
		if TransWard'="" {
			set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
			set WardID=TransWard
		}
	}
	
	set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	set LocDesc=$tr(LocDesc,",","")
	
	set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
	set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
	set WardDesc=$tr(WardDesc,",","")
	
	set return=LocID_","_LocDesc_","_WardID_","_WardDesc
	quit return
}

/// 取疑似病例筛查等级
/// w ##class(DHCMed.NINFService.BC.CommonSrv).GetScreenGradeByCode(1)
ClassMethod GetScreenGradeByCode(aCode As %String)
{
	new (aCode)
	set return=$s(aCode="1":"易感人群",aCode="2":"疑似病例",aCode="3":"高度疑似",1:"其它")
	quit return
}

/// 取疑似病例处置等级
/// w ##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(1)
ClassMethod GetHandleGradeByCode(aCode As %String)
{
	new (aCode)
	set return=$s(aCode="1":"排除",aCode="2":"疑似",aCode="3":"确诊",aCode="4":"消息",aCode="5":"感染结束",1:"未处理")
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-02-25
/// Description:  查询医院感染报告信息
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CommonSrv","QryReportByAdm",340545)
Query QryReportByAdm(aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,RepDate:%String,RepTime:%String,RepLoc:%String,RepUser:%String,RepStatus:%String,InfPos:%String,InfDiagnos:%String,InfDate:%String,TestCode:%String")
{
}

ClassMethod QryReportByAdmExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
		Quit:xRepID=""
		
		Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		
		Set (ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)=""
		Set (ReportDate,ReportTime,ReportStatusID,ReportStatusDesc)=""
		
		Continue:'$IsObject(objReport.ReportType)
		Set ReportTypeCode=objReport.ReportType.Code
		Continue:ReportTypeCode'="COMP"
		
		Set ObjectID=objReport.ObjectID
		Set ReportLoc=objReport.ReportLoc
		Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
		If $IsObject(objRepLoc) {
			Set ReportLocID=objRepLoc.Rowid
			Set ReportLocDesc=objRepLoc.Descs
		}
		Set ReportUser=objReport.ReportUser
		Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
		If $IsObject(objRepUser) {
			Set ReportUserID=objRepUser.Rowid
			Set ReportUserDesc=objRepUser.Name
		}
		Set ReportDate=objReport.ReportDate
		;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
		Set ReportTime=objReport.ReportTime
		Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
		
		Continue:'$IsObject(objReport.ReportStatus)
		Set ReportStatusID=objReport.ReportStatus.%Id()
		Set ReportStatusDesc=objReport.ReportStatus.Description
		Continue:ReportStatusDesc["删除"
		
		Set TestCodeList="",TestCodeStr=""
		Set SubID=0
		For {
			Set SubID=$o(^DHCMed.NINF("InfRep",xRepID,"Lab",SubID))
			Quit:SubID=""
			
			Set objLab=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(xRepID_"||"_SubID)
			Continue:'$Isobject(objLab)
			//标本、病原体
			Continue:'$IsObject(objLab.Specimen)
			Set SpecimenDesc=objLab.Specimen.Description
			Continue:SpecimenDesc=""
			For indTestCode=1:1:objLab.TestResults.Count() {
				Set objTestCode=objLab.TestResults.GetAt(indTestCode)
				Continue:'$IsObject(objTestCode)
				Set PathogenyDesc=objTestCode.PathogenyDesc
				Continue:PathogenyDesc=""
				Set PathogenyDesc="["_SpecimenDesc_"]"_PathogenyDesc
				If $listfind(TestCodeList,PathogenyDesc)<1 {
					Set TestCodeStr=TestCodeStr_","_PathogenyDesc
					Set TestCodeList=TestCodeList_$lb(PathogenyDesc)
				}
			}
		}
		Set TestCodeStr=$e(TestCodeStr,2,$l(TestCodeStr))
		
		Set SubID=0
		For {
			Set SubID=$o(^DHCMed.NINF("InfRep",xRepID,"InfPos",SubID))
			Quit:SubID=""
			
			Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xRepID_"||"_SubID)
			Continue:'$IsObject(objInfPos)
			
			Set InfDate=objInfPos.InfDate
			Set:$l(InfDate)>7 InfDate=""
			Continue:InfDate=""
			;Set InfDate=$zd(InfDate,3)
			Set InfDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InfDate)
			Continue:'$IsObject(objInfPos.InfPos)
			Set InfPos=objInfPos.InfPos.IPDesc
			Set InfDiagnos=""
		    If $IsObject(objInfPos.InfDiag) {
				Set InfDiagnos=objInfPos.InfDiag.IDDesc
		    }
		    
		    Set Data=$lb(xRepID,SubID,ReportDate,ReportTime,ReportLocDesc,ReportUserDesc,ReportStatusDesc)
			Set Data=Data_$lb(InfPos,InfDiagnos,InfDate,TestCodeStr)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryReportByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByAdmExecute ]
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

}

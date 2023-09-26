/// 名称: DHCMed.NINFService.Rep.InfReportDiag
/// 描述: 医院感染报告 疾病诊断
/// 编写者：zhufei
/// 编写日期: 2011-06-19
Class DHCMed.NINFService.Rep.InfReportDiag Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 疾病诊断
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input：       DHCMed.NINF.Rep.InfReportDiag.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportDiag).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As DHCMed.NINF.Rep.InfReportDiag
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"Diag",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 疾病诊断
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input：       DHCMed.NINF.Rep.InfReportDiag.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportDiag).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportDiag
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportDiag).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportDiag).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  删除医院感染报告 疾病诊断
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportDiag).DelSubRec(1)
ClassMethod DelSubRec(aId As %String) As %String
{
	New (aId)
	Set return=##Class(DHCMed.NINF.Rep.InfReportDiag).DeleteById(aId)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  保存医院感染报告 疾病诊断
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input：       
/// Return：      返回ID
/// w ##class(DHCMed.NINFService.Rep.InfReportDiag).SaveSubRec("8^^^25689^邪陷心肝,血热动风证^^^","^")
ClassMethod SaveSubRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveSubRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	
	Set RepID=$p(aInput,CHR1,1)
	Quit:RepID="" return
	Quit:'$d(^DHCMed.NINF("InfRep",RepID)) return
	
	Set DiagnosDesc=$p(aInput,CHR1,5)
	Quit:DiagnosDesc="" return
	
	Set DiagnosDate=$p(aInput,CHR1,6)
	;Set:DiagnosDate["-" DiagnosDate=$zdh(DiagnosDate,3)
	Set:DiagnosDate'="" DiagnosDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DiagnosDate)
	Set:DiagnosDate="" DiagnosDate=+$h
	Set DiagnosTime=$p(aInput,CHR1,7)
	Set:DiagnosTime[":" DiagnosTime=$zth(DiagnosTime,1)
	Set:DiagnosTime="" DiagnosTime=$p($h,",",2)
	
	Set $p(aInput,CHR1,6)=DiagnosDate
	Set $p(aInput,CHR1,7)=DiagnosTime
	
	Set return=##Class(DHCMed.NINF.Rep.InfReportDiag).Update(aInput,CHR1)
	Quit return
	
SaveSubRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询疾病诊断信息
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReportDiag","QrySubRec","8","","BASE")
Query QrySubRec(aReportID As %String, aEpisodeID As %String, aTypeCode As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,DiagnosID:%String,DiagnosDesc:%String,DiagnosDate:%String,DiagnosTime:%String,DataSource:%String") [ SqlProc ]
{
}

ClassMethod QrySubRecExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String, aTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aReportID'="" {
		Set:aTypeCode="" aTypeCode="BASE"
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Diag",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.Rep.InfReportDiag).GetObjById(aReportID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			
			Set DiagnosID=objSub.DiagnosID
			Set DiagnosDesc=objSub.DiagnosDesc
			Set DiagnosDate=objSub.DiagnosDate
			;Set:DiagnosDate'="" DiagnosDate=$zd(DiagnosDate,3)
			Set:DiagnosDate'="" DiagnosDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagnosDate)
			Set DiagnosTime=objSub.DiagnosTime
			Set:DiagnosTime'="" DiagnosTime=$zt(DiagnosTime,2)
			Set DataSource=objSub.DataSource
			//检查诊断类型是否符合
			If $IsObject(objSub.DiagnosType) {
				Set TypeCode=objSub.DiagnosType.Code
			} Else {
				Set TypeCode="BASE"
			}
			Continue:(aTypeCode'="")&&(aTypeCode'=TypeCode)
			
			Set Data=$lb(aReportID,xSubID)
			Set Data=Data_$lb(DiagnosID,DiagnosDesc)
			Set Data=Data_$lb(DiagnosDate,DiagnosTime,DataSource)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		Set MRAdm=##class(DHCMed.NINFService.Srv.CommonCls).GetMRAdm(aEpisodeID)
		Set xSubID=0
		For {
			Set xSubID=$o(^MR(+MRAdm,"DIA",xSubID))
			Quit:xSubID=""
			
			Set tmpDiagnos=$g(^MR(+MRAdm,"DIA",xSubID))
			Set ICDDES=$g(^MR(MRAdm,"DIA",xSubID,"DES",1))
			Set ICDDHC=$g(^MR(MRAdm,"DIA",xSubID,"DHC",1))
			
			Set ICDDxID=$p(tmpDiagnos,"^",1)
			Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
			Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
			Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
			
			Set DiagnosDate=$p(tmpDiagnos,"^",7)
			Set DiagnosTime=$p(tmpDiagnos,"^",8)
			;Set:DiagnosDate'="" DiagnosDate=$zd(DiagnosDate,3)
			Set:DiagnosDate'="" DiagnosDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagnosDate)
			Set:DiagnosTime'="" DiagnosTime=$zt(DiagnosTime,2)
			
			Set DataSource="MRDIAG:"_MRAdm_"||"_xSubID
			
			Set Data=$lb("","")
			Set Data=Data_$lb(ICDDxID,ICDDesc)
			Set Data=Data_$lb(DiagnosDate,DiagnosTime,DataSource)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrySubRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySubRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubRecExecute ]
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

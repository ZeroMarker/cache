/// 名称: DHCHAI.DPS.EmrRecordSrv
/// 描述: 病历相关服务
/// 编写者：liyi
/// 编写日期: 2017-08-16
Class DHCHAI.DPS.EmrRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-08-16
/// Description:  查询病人病历文档日期
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       就诊ID、文档类型
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.EmrRecordSrv","QryDocDate","300","")
Query QryDocDate(aEpisodeID As %String, aDocType As %String = "") As %Query(ROWSPEC = "DocDate:%String,DocTitle:%String,IsAbFlg:%String") [ SqlProc ]
{
}

ClassMethod QryDocDateExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDocType As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	Set xDocDate = ""
	For {
		Set xDocDate = $o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",aEpisodeID,xDocDate))
		Quit:xDocDate=""
		
		Set DocTitleList="",IsAbFlg =0
		Set flg = 0
		Set xRecordID = ""
		For {
			Set xRecordID = $o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",aEpisodeID,xDocDate,xRecordID))
			Quit:xRecordID=""
			
			Set objRecord = ##class(DHCHAI.DP.EmrRecord).GetObjById(xRecordID)
			Continue:'$isobject(objRecord)
			Set IsActive = objRecord.EmrIsActive
			Continue:IsActive'=1
			Set objDocType = objRecord.EmrDocTypeDr
			Continue:(aDocType'="")&&(aDocType'=objDocType.BTCode)

			Set SCode      = objRecord.EmrSCode
			Set DocContent = objRecord.EmrDocContent
			Set DocNumber=SCode_"||"_xRecordID
			Set IsAbFlg=##class(DHCHAI.IRS.CCRMEWordSrv).GetDocKeysSignColor(DocNumber,.DocContent)
			Set DocTitle = objRecord.EmrDocTitle
		    Continue:(","_DocTitleList_",")[(","_DocTitle_",")
			Set DocTitleList=DocTitleList_","_DocTitle
			Set flg =1
		}
		Continue:flg=0
		Set DocDate = xDocDate
		Set:DocDate'="" DocDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DocDate)
		Set:DocTitleList'="" DocTitleList=$e(DocTitleList,2,$l(DocTitleList))		
		Set Data = $lb(DocDate,DocTitleList,IsAbFlg)
		//Set Data = $lb($zd(xDocDate,3))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDocDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDocDateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDocDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDocDateExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2017-08-16
/// Description:  查询病人病历
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       就诊ID、文档类型、文档日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.EmrRecordSrv","QryEmrRecord","300","","2017-02-07","2017-02-07")
Query QryEmrRecord(aEpisodeID As %String, aDocType As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "RecordID:%String,DocType:%String,DocTitle:%String,DocDate:%String,DocContent:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryEmrRecordExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDocType As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

	Set xDocDate = ""
	For {
		Set xDocDate = $o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",aEpisodeID,xDocDate))
		Quit:xDocDate=""
		Continue:(aDateFrom'="")&&(aDateTo'="")&&((aDateTo<xDocDate)||(aDateFrom>xDocDate))
			
		Set xRecordID = ""
		For {
			Set xRecordID = $o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",aEpisodeID,xDocDate,xRecordID))
			Quit:xRecordID=""
			
			Set objRecord = ##class(DHCHAI.DP.EmrRecord).GetObjById(xRecordID)
			Continue:'$isobject(objRecord)
			
			Set objDocType = objRecord.EmrDocTypeDr
			Set DocTitle = objRecord.EmrDocTitle
			Set DocDate = objRecord.EmrDocDate
			Set DocContent = objRecord.EmrDocContent
			Set ActDate = objRecord.EmrActDate
			Set ActTime = objRecord.EmrActTime
			Set ActUser = objRecord.EmrActUser
			Set:ActUser'="" ActUser=$p(ActUser,"|",3)
			Set IsActive = objRecord.EmrIsActive
			Continue:IsActive'=1
			Continue:(aDocType'="")&&(aDocType'=objDocType.BTCode)
			
			//Set ActDate=$zd(ActDate,3)
			Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime=$zt(ActTime)
			//Set DocDate=$zd(DocDate,3)
			Set:DocDate'="" DocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DocDate)
			Set DocType=objDocType.BTDesc
			
			Set Data = $lb(xRecordID,DocType,DocTitle,DocDate,DocContent,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryEmrRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmrRecordExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEmrRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmrRecordExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

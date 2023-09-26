/// 名称: DHCHAI.IRS.CCRMEWordSrv
/// 描述: 语义分析相关服务
/// 编写者：zhufei
/// 编写日期: 2017-10-17
Class DHCHAI.IRS.CCRMEWordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-08-16
/// Description:  查询病人病历
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       就诊ID、文档类型、文档日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCRMEWordSrv","QryEmrRecord","4","","2019-02-18","2019-02-18")
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
			Set IsActive   = objRecord.EmrIsActive
			Continue:IsActive'=1
			
			Set ID         = objRecord.%Id()
			Set SCode      = objRecord.EmrSCode
			Set objDocType = objRecord.EmrDocTypeDr
			Set DocTitle   = objRecord.EmrDocTitle
			Set DocDate    = objRecord.EmrDocDate
			Set DocContent = objRecord.EmrDocContent
			Set ActDate    = objRecord.EmrActDate
			Set ActTime    = objRecord.EmrActTime
			Set ActUser    = objRecord.EmrActUser
			Set:ActUser'="" ActUser=$p(ActUser,"|",3)
			Continue:(aDocType'="")&&(aDocType'=objDocType.BTCode)
			
			//Set ActDate=$zd(ActDate,3)
			Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime=$zt(ActTime)
			//Set DocDate=$zd(DocDate,3)
			Set:DocDate'="" DocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DocDate)
			Set DocType=objDocType.BTDesc
			
			Set DocNumber=SCode_"||"_ID
			Set flg=..GetDocKeysSignColor(DocNumber,.DocContent)
			
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

/// Creator：     pylian
/// CreatDate：   2019-04-16
/// Description:  查询病人病历
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       就诊ID、文档类型、文档日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCRMEWordSrv","QryEmrRecordNew","100718","","2019-04-04","2019-04-16")
Query QryEmrRecordNew(aEpisodeID As %String, aDocType As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "RecordID:%String,DocType:%String,DocTitle:%String,DocDate:%String,DocContent:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryEmrRecordNewExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDocType As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Kill ^TMP($zn,$j,"QryEmrRecordNew")
		
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
			Set IsActive   = objRecord.EmrIsActive
			Continue:IsActive'=1
			
			Set ID         = objRecord.%Id()
			Set SCode      = objRecord.EmrSCode
			Set objDocType = objRecord.EmrDocTypeDr
			Set DocTitle   = objRecord.EmrDocTitle
			Set DocDate    = objRecord.EmrDocDate
			Set DocContent = objRecord.EmrDocContent
			Set ActDate    = objRecord.EmrActDate
			Set ActTime    = objRecord.EmrActTime
			Set ActUser    = objRecord.EmrActUser
			Set:ActUser'="" ActUser=$p(ActUser,"|",3)
			Continue:(aDocType'="")&&(aDocType'=objDocType.BTCode)
			Set DocType=objDocType.BTDesc
			
			Set DocNumber=SCode_"||"_ID
			Set flg=..GetDocKeysSignColor(DocNumber,.DocContent)
			
			Set XCode = objRecord.EmrXCode
			Set DocTitleSub = $tr(objRecord.EmrDocTitleSub," ")
			Continue:(DocTitleSub["标题")||(DocTitleSub["发生时间")||(DocTitleSub["创建时间")||(DocTitleSub["记录日期时间")
		    Set:DocTitleSub["HDSD00." DocTitleSub = $e(DocTitleSub,14,$l(DocTitleSub))
			Set:DocTitleSub'="" DocContent = "<span class='DocTitle' style='font-weight: bold;' >"_DocTitleSub_":"_"</span>"_" "_DocContent_"</br>"

			Set ^TMP($ZN,$J,"QryEmrRecordNew",DocDate,XCode,xRecordID)=DocContent
			Set ^TMP($ZN,$J,"QryEmrRecordNew","BaseInfo",DocDate,XCode)=$lb(DocType,DocTitle,DocDate,ActDate,ActTime,ActUser)
		}
	}

	Set xDate=0
	For {
		Set xDate=$o(^TMP($ZN,$J,"QryEmrRecordNew",xDate))
		Quit:xDate=""
		
		Set xCode=""
		For {
			Set xCode=$o(^TMP($ZN,$J,"QryEmrRecordNew",xDate,xCode))
			Quit:xCode=""
			
			Set DocContents = ""
			Set xRecordID=""
			For {
				Set xRecordID=$o(^TMP($ZN,$J,"QryEmrRecordNew",xDate,xCode,xRecordID))
				Quit:xRecordID=""
				
				Set DocContent=$g(^TMP($ZN,$J,"QryEmrRecordNew",xDate,xCode,xRecordID))
				Set:DocContent'="" DocContents=DocContents_" "_DocContent	
			}
			Set:DocContents'="" DocContents=$e(DocContents,2,$l(DocContents))
		   
		    Set EmrRecordInfo=$g(^TMP($ZN,$J,"QryEmrRecordNew","BaseInfo",xDate,xCode))
			Continue:EmrRecordInfo="" 
			Set DocType=$lg(EmrRecordInfo,1)
			Set DocTitle=$lg(EmrRecordInfo,2)
			Set DocDate=$lg(EmrRecordInfo,3)
			Set ActDate=$lg(EmrRecordInfo,4)
			Set ActTime=$lg(EmrRecordInfo,5)
			Set ActUser=$lg(EmrRecordInfo,6)
				
			Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime=$zt(ActTime)
			Set:DocDate'="" DocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DocDate)
				
			Set Data = $lb(xCode,DocType,DocTitle,DocDate,DocContents,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
 	Kill ^TMP($ZN,$J,"QryEmrRecordNew")
 	
 	
	Quit $$$OK
}

ClassMethod QryEmrRecordNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmrRecordNewExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEmrRecordNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmrRecordNewExecute ]
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
/// Description:  查询病人影像报告
/// Table：       DHCHAI.DP.RBReport
/// Input：       就诊ID、文档类型、文档日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCRMEWordSrv","QryRBReport","241","","")
Query QryRBReport(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "ReportID:%String,CheckItem:%String,ExamDesc:%String,ResultDesc:%String,RegDate:%String,RegTime:%String,RepDate:%String,RepTime:%String,RepUser:%String") [ SqlProc ]
{
}

ClassMethod QryRBReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

	Set xRepDate = ""
	For {
		Set xRepDate = $o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",aEpisodeID,xRepDate))
		Quit:xRepDate=""
		
		Continue:(aDateFrom'="")&&(aDateTo'="")&&((aDateTo<xRepDate)||(aDateFrom>xRepDate))
			
		Set xReportID = ""
		For {
			Set xReportID = $o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",aEpisodeID,xRepDate,xReportID))
			Quit:xReportID=""
			
			Set objReport = ##class(DHCHAI.DP.RBReport).GetObjById(xReportID)
			Continue:'$isobject(objReport)
			
			Set ID         = objReport.%Id()
			Set SCode      = objReport.RBSCode
			Set CheckItem  = objReport.RBCheckItem
			Set ExamDesc   = objReport.RBExamDesc
			Set ResultDesc = objReport.RBResultDesc
			Set RegDate    = objReport.RBRegDate
			Set RegTime    = objReport.RBRegTime
			Set RepDate    = objReport.RBRepDate
			Set RepTime    = objReport.RBRepTime
			Set RepUser    = objReport.RBRepUser
			Set Status     = objReport.RBChkStatus
			//Continue:(Status="作废")||(Status="删除")
			Set IsActive   = objReport.RBIsActive
			Continue:IsActive=0
			Set RepUserCode = $p(RepUser,"|",2)
			Set RepUserDesc = $p(RepUser,"|",3)
			
			//Set:RegDate'="" RegDate=$zd(RegDate,3)
			//Set:RepDate'="" RepDate=$zd(RepDate,3)
			Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate)
			Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			Set:RegTime'="" RegTime=$zt(RegTime)
			Set:RepTime'="" RepTime=$zt(RepTime)
			
			Set DocNumber=SCode_"||"_ID
			Set flg=..GetDocKeysSignColor(DocNumber,.ExamDesc)    //检查所见
			Set flg=..GetDocKeysSignColor(DocNumber,.ResultDesc)  //诊断意见
			
			Set Data = $lb(xReportID,CheckItem,ExamDesc,ResultDesc,RegDate,RegTime,RepDate,RepTime,RepUserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryRBReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRBReportExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRBReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRBReportExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-11-19
/// Description:  基于语义分析的关键词高亮
/// Table：       DHCHAI.RME.DocMaster、DHCHAI.RME.DocResult
/// Input：       aDocNumber : 文档编号
///               aDocContent : 文档内容
/// Return：      返回%String  多个同义词“;”分割
/// s docContent="半年前因""褥疮合并感染""就诊于天津医科大学总医院，泌尿系感染，[感染方面]患者于2016年07月30日起患者体温升高，08-01感染内科会诊示:同意目前抗感染治疗，gq8h+万古霉素500mgq8h抗感染治疗方案,感染内科随诊，感染内科指导下，肺部感染，泌尿系感染"
/// w ##class(DHCHAI.IRS.CCRMEWordSrv).GetDocKeysSignColor("EMR01||191831",.docContent)
ClassMethod GetDocKeysSignColor(aDocNumber As %String, ByRef aDocContent As %String) As %String
{
	New (aDocNumber,aDocContent)
	Set return=0
	Quit:(aDocNumber="")||(aDocContent="") return
	
	Set arrResult=..GetRMEKeysByDocNumber(aDocNumber)
	Quit:arrResult.Count()<1 return
	Set CContext="" //update 20221216 使用中间变量，支持一段文本多关键词标红
	For indK=1:1:arrResult.Count() {
		Set objResult=arrResult.GetAt(indK)
		Continue:'$IsObject(objResult)
		Set Context=objResult.DRContext
		Set:CContext'="" Context=CContext //update 20221216 使用中间变量，支持一段文本多关键词标红
		Set ParserWords=objResult.DRParserWords
		Set Formal=objResult.DRFormal
		Set Name=objResult.DRName
		
		//关键词替换
		Set tContext=Context
		Set tFormal="&nbsp;<font>"_Formal_"</font>&nbsp;"
		Set tContext=##class(DHCHAI.Utils.CommonSrv).Replace(tContext,Formal,tFormal)
		Set tName="&nbsp;<font>"_Name_"</font>&nbsp;"
		Set tContext=##class(DHCHAI.Utils.CommonSrv).Replace(tContext,Name,tName)
		For indPW=1:1:$l(ParserWords,";"){
			Set ParserWord=$p(ParserWords,";",indPW)
			Continue:ParserWord=""
			Set tParserWord="&nbsp;<font>"_ParserWord_"</font>&nbsp;"
			Set tContext=##class(DHCHAI.Utils.CommonSrv).Replace(tContext,ParserWord,tParserWord)
		}
	    Set:tContext'="" CContext=tContext   //update 20221216 使用中间变量，支持一段文本多关键词标红
		//句式替换
		Set aDocContent=##class(DHCHAI.Utils.CommonSrv).Replace(aDocContent,Context,tContext)
	}
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-17
/// Description:  取感染相关语义词（同义词）
/// Table：       DHCHAI.RME.DocMaster、DHCHAI.RME.DocResult
/// Input：       aDocNumber : 文档编号
/// Return：      返回%String  多个同义词“;”分割
/// w ##class(DHCHAI.IRS.CCRMEWordSrv).GetRMEKeysByDocNumber("EMR01||191831","INF-HAI")
ClassMethod GetRMEKeysByDocNumber(aDocNumber As %String, aThemeCode As %String = "") As %String
{
	New (aDocNumber,aThemeCode)
	Set return=##Class(%ListOfDataTypes).%New()
	Quit:aDocNumber="" return
	
	If aThemeCode="" {
		Set:aDocNumber["EMR" aThemeCode="INF-HAI"
		Set:aDocNumber["RIS" aThemeCode="INF-RIS"
	}
	Quit:aThemeCode="" return
	
	//语义词库版本
	Set VersionDr=""
	Set objVersion=##class(DHCHAI.RME.ThemeType).GetVersionByThCode(aThemeCode)  //HAI语义分析词库
	If $IsObject(objVersion){
		Set VersionDr=objVersion.%Id()
	}
	Quit:VersionDr="" return
	
	Set objDocMaster=##class(DHCHAI.RME.DocMaster).GetObjByDocNumber(VersionDr,aDocNumber)
	Quit:'$IsObject(objDocMaster) return
	Quit:'$IsObject(objDocMaster.DMVersionDr) return
	Set VersionDr=objDocMaster.DMVersionDr.%Id()
	Set MasterID=objDocMaster.%Id()
	
	Set InfOneWords=""
	Set InfOneWords2=""
	Set InfParserWords=""
	Set xSecSub=0
	For {
		Set xSecSub=$o(^DHCHAI.RME.DocMasterD(MasterID,"DS",xSecSub))
		Quit:xSecSub=""
		
		Set xRstSub=0
		For {
			Set xRstSub=$o(^DHCHAI.RME.DocMasterD(MasterID,"DS",xSecSub,"DR",xRstSub))
			Quit:xRstSub=""
			
			Set objResult=##class(DHCHAI.RME.DocResult).GetObjById(MasterID_"||"_xSecSub_"||"_xRstSub)
			Continue:'$IsObject(objResult)
			Continue:'$IsObject(objResult.DRTypeDr)
			Set TypeCode=objResult.DRTypeDr.BTCode
			Continue:(TypeCode["-")
			
			//同义词（原文关键词）
			Set tParserWords=objResult.DRParserWords
			Continue:tParserWords=""
			Continue:$listfind(InfParserWords,tParserWords)>0
			
			//归一词
			Set OneWords=""
			Set DRFormal=objResult.DRFormal
			Set DRName=objResult.DRName
			If DRFormal=DRName {
				Set OneWords=DRName
			} Else {
				Set OneWords=DRName_"^"_DRFormal
			}
			Continue:OneWords=""
			
			//判断是否感染主题词
			Set IsInfWordFlag=0
			For indOW=1:1:$length(OneWords,"^") {
				Quit:IsInfWordFlag=1
				Set OneWord=$p(OneWords,"^",indOW)
				Continue:OneWord=""
				Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjByOneWord(VersionDr,OneWord)
				Continue:'$IsObject(objOneWord)
				Set OneWordDr=objOneWord.%Id()
				
				Set ThWordDr=0
				For {
					Set ThWordDr=$o(^DHCHAI.RME.ThWordsMapI("IndexOneWordThWord",OneWordDr,ThWordDr))
					Quit:ThWordDr=""
					Quit:IsInfWordFlag=1
					
					Set xThWordMapDr=0
					For {
						Set xThWordMapDr=$o(^DHCHAI.RME.ThWordsMapI("IndexOneWordThWord",OneWordDr,ThWordDr,xThWordMapDr))
						Quit:xThWordMapDr=""
						Quit:IsInfWordFlag=1
						
						Set objThWordMap=##class(DHCHAI.RME.ThWordsMap).GetObjById(xThWordMapDr)
						Continue:'$IsObject(objThWordMap)
						//Continue:objThWord.BTIsActive'=1  //add by zf 20190731 
						//modi by chenjb 0912 ->objThWord=objThWordMap
						Continue:objThWordMap.BTIsActive'=1
						Continue:objThWordMap.BTIsCheck'=1  //add by zf 20190731
						Set objThWord=objThWordMap.BTThWordDr
						Continue:'$IsObject(objThWord)
						Continue:'$IsObject(objThWord.BTThemeTypeDr)
						Set ThemeType=objThWord.BTThemeTypeDr.BTCode
						Continue:ThemeType'=aThemeCode
						
						Set IsInfWordFlag=1
					}
				}
			}
			Continue:IsInfWordFlag'=1
			
			Do return.Insert(objResult)
		}
	}
	Quit return
}

}

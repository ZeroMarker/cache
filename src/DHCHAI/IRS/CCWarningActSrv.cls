/// 名称: DHCHAI.IRS.CCWarningActSrv
/// 描述: 暴发预警处置相关服务
/// 编写者：zhoubo
/// 编写日期: 2019-03-14
Class DHCHAI.IRS.CCWarningActSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-03-14
/// Description:  查询暴发预警疑似聚集病人列表
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aLocID : 科室ID
///               aWarnDate : 预警日期
///               aWarnItems : 预警项目
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningActSrv","QryWarnPatList","2019-03-14","实时现患||3^发热标准差|30|2^发热人数|7|3^检出同种同源菌|7|3^便常规异常|7|3^呼吸机使用|7|3^中心静脉置管|7|3^泌尿道插管|7|3^上呼吸道感染|7|3^下呼吸道感染|7|3^泌尿道感染|7|3^血管相关性感染|7|3^手术切口感染|7|3^入院24H内计入|1")
Query QryWarnPatList(aWarnDate As %String, aWarnItems As %String) As %Query(ROWSPEC = "EpisodeDr:%String,RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLoc:%String,AdmWard:%String,AdmBedDr:%String,AdmBed:%String,InfInfo:%String,AdmDate:%String,DischDate:%String,WarnLocDr:%String,WarnLocDesc:%String,WarnBedDr:%String,WarnBedDesc:%String,DataStr:%String,WarnDate:%String,WarnItem:%String") [ SqlProc ]
{
}

ClassMethod QryWarnPatListExecute(ByRef qHandle As %Binary, aWarnDate As %String, aWarnItems As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:aWarnDate'="" aWarnDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aWarnDate)
 	Quit:(aWarnDate="")||(aWarnItems="") $$$OK
 	Set ZIndex=$zn,JIndex=$j,NIndex="QryWarnPatList"
 	Set xLocDr=""
	For {
		Set xLocDr=$o(^DHCHAI.IR.CCWarningActI("IndexWarnDateLoc",aWarnDate,xLocDr))
		Quit:xLocDr=""			  
		Set xActID=""
		For {
			Set xActID=$o(^DHCHAI.IR.CCWarningActI("IndexWarnDateLoc",aWarnDate,xLocDr,xActID))
			Quit:xActID=""			  
			Set objAct = ##class(DHCHAI.IR.CCWarningAct).GetObjById(xActID)
			Continue:'$IsObject(objAct)
			
			Set ActStatus = objAct.IRActStatus
			Continue:ActStatus'=1  // 过滤非疑似聚集
			Set WarnItem = objAct.IRWarnItem
			
 			Set flg=##class(DHCHAI.IRS.CCWarningSrv).QueryProcess(aWarnDate,aWarnItems,"",xLocDr,WarnItem,"W")
 			Continue:(+flg)<1
 			
 			//输出科室暴发预警结果
			Set xWarnLoc=""
			For {
				Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
				Quit:xWarnLoc=""
				
				Set WarnLocData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
				Continue:WarnLocData=""
				Set WarnLocDr=$listget(WarnLocData,1)
				Set WarnLocDesc=$listget(WarnLocData,2)
				
				Set xEpisodeDr=0
				For {
					Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr))
					Quit:xEpisodeDr=""
					
					Set WarnBedData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr))
					Continue:WarnBedData=""
					Set WarnBedDr=$listget(WarnBedData,3)
					Set WarnBedDesc=$listget(WarnBedData,4)
					Continue:WarnBedDesc=""
					Set:WarnBedDesc'["床" WarnBedDesc=WarnBedDesc_"床"
					
					Set SummaryStr="" // add by zhoubo 2018-03-19
					Set DataStr=""
					Set xInd=0
					For {
						Set xInd=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd))
						Quit:(xInd="")||(DataStr'="")
						
						Set xSub=0
						For {
							Set xSub=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
							Quit:(xSub="")||(DataStr'="")
							
							Set HeaderData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
							Continue:HeaderData=""
							Set HeaderDesc=$listget(HeaderData,1)
							Set ItemDesc=$listget(HeaderData,2)
							Continue:ItemDesc=""
							
							If ItemDesc="检出同种菌" {
								Set Bacteria=HeaderDesc
								Continue:Bacteria=""
								If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc,Bacteria)) {
									Set DataStr=1
									Set SummaryStr=SummaryStr_","_ItemDesc_":"_Bacteria
								}
							} ElseIf ItemDesc="手术切口感染" {
								Set OperDesc=HeaderDesc
								Continue:OperDesc=""
								If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc,OperDesc)) {
									Set DataStr=1
									Set SummaryStr=SummaryStr_","_ItemDesc_":"_OperDesc
								}
							} Else {
								If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc)) {
									Set DataStr=1
									Set SummaryStr=SummaryStr_","_ItemDesc
								}
							}
						}
					}
					Continue:DataStr=""
					Continue:SummaryStr=""
					Set SummaryStr=$e(SummaryStr,2,$l(SummaryStr))
					
					//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、当前床号、预警科室ID、预警科室、预警床位ID、预警床位、预警值列表
				 	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
				 	Continue:'$IsObject(objAdm)
				 	Set RegNo=objAdm.PAPapmiNo
				 	Set MrNo=objAdm.PAMrNo
				 	Set PatName=objAdm.PAPatName
				 	Set Sex=objAdm.PASex
				 	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
				 	Set Age=objAdm.PAAge
				 	Set (AdmLoc,AdmWard,AdmBed,AdmDate,DischDate)=""
				 	If $IsObject(objAdm.PAAdmLocDr){
					 	Set AdmLoc=objAdm.PAAdmLocDr.BTDesc
					 	Set AdmLoc2=objAdm.PAAdmLocDr.BTDesc2
					 	Set:AdmLoc2'="" AdmLoc=AdmLoc2
				 	}
				 	If $IsObject(objAdm.PAAdmWardDr){
					 	Set AdmWard=objAdm.PAAdmWardDr.BTDesc
					 	Set AdmWard2=objAdm.PAAdmWardDr.BTDesc2
					 	Set:AdmWard2'="" AdmWard=AdmWard2
				 	}
				 	Set (AdmBedDr,AdmBed)=""
				 	If $IsObject(objAdm.PAAdmBedDr){
					 	Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
					 	Set AdmBed=objAdm.PAAdmBedDr.BTDesc
				 	}
				 	Set AdmDate=objAdm.PAAdmDate
				 	//Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
				 	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
				 	Set DischDate=objAdm.PADischDate
				 	//Set:DischDate'="" DischDate=$zd(DischDate,3)
			        Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
				
				 	//感染信息
				 	Set InfInfo = ""
				 	Set xInfDiagID = 0
				 	For {
					 	Set xInfDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeDr,xInfDiagID))
					 	Quit:xInfDiagID=""
					 	
					 	Set objInfDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagID)
					 	Continue:'$IsObject(objInfDiag)
				 		Continue:'$IsObject(objInfDiag.IRInfPosDr)
				 		Set InfDate = objInfDiag.IRInfDate
				 		Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
				 		
				 		Set InfInfo = InfInfo_","_InfDate_objInfDiag.IRInfPosDr.BTDesc
					}
					If (InfInfo'=""){Set InfInfo = $e(InfInfo,2,$l(InfInfo))}
				 	Set:aWarnDate'="" WarnDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(aWarnDate)
				 	
				 	Set Data=$lb(xEpisodeDr,RegNo,MrNo,PatName,Sex,Age,AdmLoc,AdmWard,AdmBedDr,AdmBed,InfInfo,AdmDate,DischDate)
					Set Data=Data_$lb(WarnLocDr,WarnLocDesc,WarnBedDr,WarnBedDesc,DataStr,WarnDate,WarnItem)
					Set ^CacheTemp(repid,ind)=Data
				 	Set ind=ind+1
				}
			}
		}
	}
	
 	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryWarnPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarnPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarnPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarnPatListExecute ]
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

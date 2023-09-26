/// 名称: DHCMed.NINFService.Aim.Interface
/// 描述: 临床上报的接口
/// 编写者：zhufei
/// 编写日期: 2010-07-29
Class DHCMed.NINFService.Aim.Interface Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  同步电子病历数据为临床上报数据
/// Table：       DHCMed.CR.Project,DHCMed.CR.ProjectStatus
/// Input：       argPrjID 临床上报项目ID
/// Return：      return<0 : 失败 , return>0 : 成功
/// w ##class(DHCMed.NINFService.Aim.Interface).SyncDataEPRToCR("2")
ClassMethod SyncDataEPRToCR(argPrjID As %String) As %String
{
	New (argPrjID)
	Set return=0
	Set $ZT="SyncDataEPRToCRErr"
	
	Set PrjID=0
	For {
		Set PrjID=$o(^DHCMed.CR.ProjectD(PrjID))
		Quit:PrjID=""
		Continue:(argPrjID'="")&&(PrjID'=argPrjID)
		
		Set DocID="",IsActive=""
		Set objProject=##Class(DHCMed.CR.Project).%OpenId(PrjID)
		If $IsObject(objProject) {
			Set DocID=objProject.TemplateID
			Set IsActive=objProject.Active
		}
		If objProject'="" Do objProject.%Close()
		Continue:DocID=""
		Continue:IsActive'["Y"
		
		Set StartDate=+$g(^DHCMed.CR.ReportC("PrjIDDate",PrjID))
		Set:+$h-StartDate<30 StartDate=+$h-30
		Set EndDate=+$h
		Set rset = ##class(%ResultSet).%New()
		Set rset.ClassName = "DHCMed.NINFService.Aim.Interface"
		Set rset.QueryName = "GetEPRListByDate"
		Set sc = rset.Execute(DocID,StartDate,EndDate,"","")
		While (rset.Next(.sc))
		{
			If ($SYSTEM.Status.IsOK(sc))
			{
				Set InstanceID=rset.Data("InstanceDataID")
				Set EpisodeID=rset.Data("EpisodeID")
				Set CreateDate=rset.Data("CreateDate")
				Set CreateTime=rset.Data("CreateTime")
				Set CreateUserID=rset.Data("CreateUserID")
				Set ModiDate=rset.Data("ModifyDate")
				Set ModiTime=rset.Data("ModifyTime")
				Set CreateCtLocID=rset.Data("CreateCtLocID")
				Set:CreateCtLocID="" CreateCtLocID=0
				Set Status=rset.Data("Status")
				
				//TStart
				
				Set RepID=$o(^DHCMed.CR.ReportI("IndexProjectIDInstanceID"," "_PrjID," "_InstanceID,0))
				Set objReport=##Class(DHCMed.CR.Report).%OpenId(RepID)
				If $IsObject(objReport) {
					Set RepStatus=..GetStatusByRepID(RepID)
					//add by lyh 2012-04-19
					Set ret=##class(DHCMed.NINFService.Aim.ICUSrv).UpdateInfReport(RepID)
				} Else {
					//处理新报告
					Set RepID=""
					Set Status=$s(Status="未完成":"S",1:"D")
					Set RepInput=RepID_"^"_InstanceID_"^"_PrjID_"^"_EpisodeID_"^"_Status_"^"_CreateUserID_"^"_CreateDate_"^"_CreateTime_"^^^^^^^^"_CreateCtLocID
					Set RepID=##Class(DHCMed.CR.Report).Update(RepInput)
					
					//add by lyh 2012-04-19
					Set ret=##class(DHCMed.NINFService.Aim.ICUSrv).UpdateInfReport(RepID)
					//If RepID<0 TRollBack
					Set RepStatusInput=RepID_"^^"_Status_"^"_CreateUserID_"^"_CreateDate_"^"_CreateTime_"^"
					Set ChildID=##Class(DHCMed.CR.RepStatus).Update(RepStatusInput)
					//If +ChildID<0 TRollBack
				}
				If objReport'="" Do objReport.%Close()
				
				//TCommit
				
			} Else {
				Quit
			}
		}
		If $SYSTEM.Status.IsError(sc)
		{
			Set return=-1
			Do $system.OBJ.DisplayError(sc)
		} Else {
			Set return=1
			Set ^DHCMed.CR.ReportC("PrjIDDate",PrjID)=+$h
			Do rset.Close()
		}
	}
	
	Quit return
	
SyncDataEPRToCRErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  获取临床上报报告状态
///               同时同步电子病历修改状态与临床上报状态数据
///               提供给同步临床上报状态的接口
/// Table：       DHCMed.CR.Report,DHCMed.CR.RepStatus
/// Input：       argRepID 临床上报报告ID
/// Return：      "D","Y","R":待审,已审,退回  "":错误数据
/// w ##class(DHCMed.NINFService.Aim.Interface).GetStatusByRepID(RepID)
ClassMethod GetStatusByRepID(argRepID As %String) As %String
{
	New (argRepID)
	Set return=""
	Set $ZT="GetStatusByRepIDErr"
	
	Set objReport=##Class(DHCMed.CR.Report).%OpenId(argRepID)
	If $IsObject(objReport) {
		//处理退回状态报告
		Set RepStatus=objReport.RepStatus
		Set return=RepStatus //S：删除，Y：审核，D：待审，R：退回
		Quit:(RepStatus'="R")&&(RepStatus'="S")&&(RepStatus'="D") return
		Set (ModiDate,ModiTime,ModifyUser,DocID,Status)=""
		Set EpisodeID=objReport.EpisodeID
		Set ProjectID=objReport.ProjectID
		Set objProject=##Class(DHCMed.CR.Project).%OpenId(ProjectID)
		If $IsObject(objProject){
			Set DocID=objProject.TemplateID
		}
		If objProject'="" Do objProject.%Close()
		//add by likai 2013-08-21 
		Set InstanceID=objReport.InstanceID
		set EprNum=$p(InstanceID,"||",2)
		Quit:EprNum=""
		Set EprLogsID=$o(^DHCEPRI.EPRLogsI("IdxMain"," "_EpisodeID," "_DocID,EprNum,""),-1)
		Quit:EprLogsID="" return
		Set objEPRLogs=##Class(EPRinstance.EPRLogs).%OpenId(EprLogsID)
		If $IsObject(objEPRLogs) {
			Set Status=objEPRLogs.EPRStatus  //电子病历模板保存状态
			If (Status'="") {
				&sql(SELECT StatusName into :Status FROM EPRmeta.EPRStatus WHERE StatusCode = :Status)
			}
		}
		If objEPRLogs'="" Do objEPRLogs.%Close()
		Quit:(RepStatus="S")&&(Status="未完成") return
		Quit:(RepStatus="D")&&(Status="完成") return
		If Status="未完成" {
			Set Status="S"
		} Else {
			Set Status="D"
		}
		
		Set objInstanceData=##class(EPRinstance.InstanceData).%OpenId(InstanceID)
		If objInstanceData'=""
		{
			Set ModiDate=objInstanceData.ModifyDate
			Set ModiTime=objInstanceData.ModifyTime
			Set CreateUser=objInstanceData.CreateUser
		}
		If objInstanceData'="" Do objInstanceData.%Close()
		Quit:(ModiDate="")||(ModiTime="")||(ModifyUser) return
		Set ChildID=$o(^DHCMed.CR.RepStatusD(argRepID,""),-1)
		Set RepStatusID=argRepID_"||"_ChildID
		Set objRepStatus=##Class(DHCMed.CR.RepStatus).%OpenId(RepStatusID)
		If $IsObject(objRepStatus) {
			Set UpdateDate=objRepStatus.UpdateDate
			Set UpdateTime=objRepStatus.UpdateTime
			Quit:ModiDate<UpdateDate return
			Quit:ModiTime<UpdateTime return
			Set objReport.RepStatus=Status
		    Set sc=objReport.%Save()
			If $$$ISERR(sc) {
				Do $System.Status.DisplayError(sc)
			} Else {
				Set ChildID=##Class(DHCMed.CR.RepStatus).Update(argRepID_"^^"_Status_"^"_CreateUser_"^"_ModiDate_"^"_ModiTime_"^")
				If (+ChildID)<0 TRollBack
			}
		}
		If objRepStatus'="" Do objRepStatus.%Close()
		
		Set return=objReport.RepStatus
	}
	If objReport'="" Do objReport.%Close()
	
	Quit return
	
GetStatusByRepIDErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  取临床上报报告数据(同时同步临床上报数据)
///               提供给重点患者同步数据的接口
/// Table：       DHCMed.CR.Project,DHCMed.CR.ProjectStatus
/// Input：       argPrjID 临床上报项目ID,argFromID 开始ID
/// Return：      $lb(ReportID)
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.Interface","GetRepListByID","2","0")
Query GetRepListByID(argPrjID As %String, argFromID As %String) As %Query(ROWSPEC = "ReportID:%String")
{
}

ClassMethod GetRepListByIDExecute(ByRef qHandle As %Binary, argPrjID As %String, argFromID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set repidInd=1
 	
 	Quit:(argPrjID="")||(argFromID="") $$$OK
 	
 	//同步电子病历和临床上报数据
 	Set flg=..SyncDataEPRToCR(argPrjID)
 	Quit:flg<0 $$$OK
 	
	Set PrjID=""
	For {
		Set PrjID=$o(^DHCMed.CR.ReportI("IndexProjectID",PrjID))
		Quit:PrjID=""
		
		Set tmpPrjID=$e(PrjID,2,$l(PrjID))
		Continue:(argPrjID'="")&&(argPrjID'=tmpPrjID)
		
		Set ReportID=+argFromID
		For {
			Set ReportID=$o(^DHCMed.CR.ReportI("IndexProjectID",PrjID,ReportID))
			Quit:ReportID=""
			
			//同步临床上报状态数据
			Set RepStatus=..GetStatusByRepID(ReportID)
			
			Set Data=$lb(ReportID)
			Set ^CacheTemp(repid,repidInd)=Data
			Set repidInd=repidInd+1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetRepListByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRepListByIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set repidInd=$LIST(qHandle,3)
 	Set repidInd=$o(^CacheTemp(repid,repidInd))
 	If repidInd="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,repidInd)
 	}
 	Set qHandle=$lb(AtEnd,repid,repidInd)
	Quit $$$OK
}

ClassMethod GetRepListByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRepListByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2010-07-29
/// Description:  以创建日期、创建人科室为条件，获取新框架历次病程/出院记录等列表
///               提供给临床上报同步数据的接口
/// Table：       EPRinstance.EPRLogs
/// Input:        DocID     打印模板ID
///               StartDate 起始日期
///               EndDate   结束日期
///               CTLocID   创建人科室， 预留的参数
///               ByDesc    排序方式：1 正序, -1  逆序， 预留的参数
/// Return：      临床上报报告列表
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.Interface","GetEPRListByDate","","","","","")
Query GetEPRListByDate(DocID As %String, StartDate As %String, EndDate As %String, CTLocID As %String, ByDesc As %String = "1") As %Query(ROWSPEC = "InstanceDataID:%String, EpisodeID:%String, CreateDate:%String, CreateTime:%String, CreateUserID:%String, CreateCtLocID:%String, HappenDate:%String, HappenTime:%String, Status:%String, ModifyDate:%String, ModifyTime:%String")
{
}

ClassMethod GetEPRListByDateExecute(ByRef qHandle As %Binary, DocID As %String, StartDate As %String, EndDate As %String, CTLocID As %String, ByDesc As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set repidInd=1
 	
 	//校验入参合法性
 	Quit:((DocID="")||(StartDate="")||(EndDate="")) $$$OK
 	Quit:(StartDate>EndDate) $$$OK
	
	//开始查询实例数据
	Set Date = " "_StartDate
	For {
		Set Time = ""
		For {
			Set Time = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", Date, Time))
			Quit:(Time="")
			
			Set EpisodeID = ""
			For {
				Set EpisodeID = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", Date, Time, EpisodeID))
				Quit:(EpisodeID="")
				
				Set EprNum = ""
				For {
					Set EprNum = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", Date, Time, EpisodeID, " "_DocID, EprNum))
					Quit:(EprNum="")
					
					//取EPRLogs的RowId
					Set EprLogsID = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", Date, Time, EpisodeID, " "_DocID, EprNum, ""),-1)
					If EprLogsID="" Continue
					
					//********************************************
					//add by zf 2010-07-28
					//解决唯一模板和可重复模板兼容性临床上报问题
					Set ECRecordID=""
					Set BindTemplateID="",ChartItemType=""
					Set EPRTemplateID=$o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_DocID,0))
					If EPRTemplateID="" Continue
					Set objEPRTemplate=##Class(EPRmeta.EPRTemplate).%OpenId(EPRTemplateID)
					If $IsObject(objEPRTemplate) {
						Set BindTemplateID=objEPRTemplate.BindTemplateID
					}
					If objEPRTemplate'="" Do objEPRTemplate.%Close()
					If BindTemplateID'="" {
						Set objTemplate=##Class(EPRmeta.Template).%OpenId(BindTemplateID)
						If $IsObject(objTemplate) {
							Set ChartItemType=objTemplate.ChartItemType
						}
						If objTemplate'="" Do objTemplate.%Close()
					}
					If ChartItemType="Single" {
						Set ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", EpisodeID, " CG"_BindTemplateID, ""))
					}
					If ChartItemType="Multiple" {
						Set ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", EpisodeID, " ML"_DocID, ""))
					}
					
					//取InstanceData的RowId
					//s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", EpisodeID, " ML"_DocID, ""))
					//********************************************
					If (ECRecordID = "") Continue
					Set ChildSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ECRecordID, " "_EprNum, ""))
					If (ChildSub = "") Continue
					Set InstanceId = ECRecordID_"||"_ChildSub
					
					Set retInstanceId = $tr(InstanceId," ",""), retEpisodeId = $e(EpisodeID,2,$l(EpisodeID))
					Set retCreateDate = "", retCreateTime = "", retCreateUserID = "", retCreateCtLocID="", retHappenDate="", retHappenTime="", retStatus=""
					Set retModifyDate = "", retModifyTime = ""
					Set EprLogs = ##class(EPRinstance.EPRLogs).%OpenId(EprLogsID)
					If EprLogs '= ""
					{
						Set retCreateDate = EprLogs.CreateDate
						Set retCreateTime = EprLogs.CreateTime
						Set retCreateUserID = EprLogs.CreateUserID
						Set retHappenDate = EprLogs.HappenDate
						Set retHappenTime = EprLogs.HappenTime
						Set retStatus = EprLogs.EPRStatus
						If (retStatus'="") {
							&sql(SELECT StatusName into :retStatus FROM EPRmeta.EPRStatus WHERE StatusCode = :retStatus)
						}
					}
					If EprLogs'="" Do EprLogs.%Close()
					
					Set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(retInstanceId)
					If objInstanceData '= ""
					{
						Set retModifyDate = objInstanceData.ModifyDate
						Set retModifyTime = objInstanceData.ModifyTime
					}
					If objInstanceData'="" Do objInstanceData.%Close()
					
					//设置返回值					实例数据ID		就诊rowid	创建日期		创建时间		创建人ID		创建科室（暂时为空）
					Set ^CacheTemp(repid, repidInd) = $lb(retInstanceId, retEpisodeId, retCreateDate, retCreateTime, retCreateUserID, retCreateCtLocID, retHappenDate, retHappenTime, retStatus, retModifyDate, retModifyTime)
					Set repidInd = repidInd + 1
				}
			}
		}
		
		Set Date = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", Date))
		Quit:(Date="")
		Quit:(+$e(Date,2,$l(Date)))>EndDate
	}
	
	Quit $$$OK
}

ClassMethod GetEPRListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEPRListByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set repidInd=$LIST(qHandle,3)
 	Set repidInd=$o(^CacheTemp(repid,repidInd))
 	If repidInd="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,repidInd)
 	}
 	Set qHandle=$lb(AtEnd,repid,repidInd)
	Quit $$$OK
}

ClassMethod GetEPRListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEPRListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  增加到电子病历可重复模板“表头列”字符串
///               提供给电子病历的接口
/// Table：       
/// Input：       argTemplateID 模板ID
/// Return：      return 电子病历可重复模板“表头列”字符串
/// w ##class(DHCMed.NINFService.Aim.Interface).GetTHCellsString(argTemplateID)
ClassMethod GetTHCellsString(argTemplateID As %String) As %String
{
	New (argTemplateID)
	Set return=""
	Set $ZT="GetTHCellsStringErr"
	//Quit:argTemplateID="" return
	Set return="报告状态^审核人^审核时间^退回原因"
	Quit return
GetTHCellsStringErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  根据InstanceID取医政组附件单元信息“值”字符串
///               提供给电子病历的接口
/// Table：       
/// Input：       argInstanceID 实例数据ID
/// Return：      return 医政组附件单元信息“值”字符串
/// w ##class(DHCMed.NINFService.Aim.Interface).GetTDCellsString("395420||6")
ClassMethod GetTDCellsString(argInstanceID As %String) As %String
{
	New (argInstanceID)
	Set return="待审^^^"
	Set $ZT="GetTDCellsStringErr"
	
	Quit:argInstanceID="" return
	Set ReportID=0
	For {
		Set ReportID=$o(^DHCMed.CR.ReportI("InstanceID"," "_argInstanceID,ReportID))
		Quit:ReportID=""
		
		//同步临床上报状态数据
		Set RepStatus=..GetStatusByRepID(ReportID)
		
		Set objReport=##Class(DHCMed.CR.Report).%OpenId(ReportID)
		Set RepStatus=objReport.RepStatus
		Set RepStatus=$s(RepStatus="D":"待审",RepStatus="Y":"已审",RepStatus="R":"退回",RepStatus="S":"删除",1:"")
		Set CheckUser=objReport.CheckUser
		If CheckUser'="" {
			Set objSSUser=##Class(User.SSUser).%OpenId(CheckUser)
			If $IsObject(objSSUser){
				Set CheckUser=objSSUser.SSUSRName
			}
			If objSSUser'="" Do objSSUser.%Close()
		}
		Set CheckDate=objReport.CheckDate
		Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
		Set CheckTime=objReport.CheckTime
		Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
		Set ReturnRes=objReport.ReturnRes
		Set:objReport.RepStatus'="R" ReturnRes=""
		If objReport'="" Do objReport.%Close()
		Set return=RepStatus_"^"_CheckUser_"^"_CheckDate_" "_CheckTime_"^"_ReturnRes
	}
	
	Quit return
	
GetTDCellsStringErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  提供在图标定义处显示的内容
///               提供给图标显示的接口
/// Table：       
/// Input：       argEpisodeID  患者就诊号
/// Return：      return=退回原因:退回状态,return="":正常状态
/// w ##class(DHCMed.NINFService.Aim.Interface).GetReturnInfo(argEpisodeID)
ClassMethod GetReturnInfo(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=""
	Set $ZT="GetReturnInfoErr"
	
	Quit:argEpisodeID="" return
	Set ReportID=0,RepStatus=""
	For {
		Set ReportID=$o(^DHCMed.CR.ReportI("EpisodeID"," "_argEpisodeID,ReportID))
		Quit:(ReportID="")&&(return'="")
		Set objReport=##Class(DHCMed.CR.Report).%OpenId(ReportID)
		Set RepStatus=objReport.RepStatus
		Continue:RepStatus'="R"  //退回  返回退回原因
		Set return=objReport.ReturnRes
		If objReport'="" Do objReport.%Close()
	}
	Quit return
	
GetReturnInfoErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  提供在病历书写下病历是否可再修改（保存）
///               提供给电子病历的接口
/// Table：       
/// Input：       argInstanceID 实例数据ID
/// Return：      return=0:表示不可修改  return=1:表示可修改
/// w ##class(DHCMed.NINFService.Aim.Interface).CanEdit(argInstanceID)
ClassMethod CanEdit(argInstanceID As %String) As %String
{
	New (argInstanceID)
	Set return=1
	Set $ZT="CanEditErr"
	
	Quit:argInstanceID="" return
	Set ReportID=0,RepStatus=""
	For {
		Set ReportID=$o(^DHCMed.CR.ReportI("InstanceID"," "_argInstanceID,ReportID))
		Quit:(ReportID="")&&(return'=1)
		Set objReport=##Class(DHCMed.CR.Report).%OpenId(ReportID)
		Set RepStatus=objReport.RepStatus
		Continue:RepStatus'="Y"  //已审  已审核的报告不允许再修改
		Set return=0
		If objReport'="" Do objReport.%Close()
	}
	Quit return
	
CanEditErr
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2012-05-16
/// Description:  同步电子病历数据为临床上报数据
/// Table：       DHCMed.CR.Project,DHCMed.CR.ProjectStatus
/// Input：       
/// Return：      return<0 : 失败 , return>0 : 成功
/// w ##class(DHCMed.NINFService.Aim.Interface).SyncDataEPRByEpisodeID("7",2897021)
ClassMethod SyncDataEPRByEpisodeID(argPrjID As %String, EpisodeID As %String) As %String
{
	New (argPrjID,EpisodeID)
	Set return=0
	Set $ZT="SyncDataEPRToCRErr1"
	Set PrjID=0
	For {
		Set PrjID=$o(^DHCMed.CR.ProjectD(PrjID))
		Quit:PrjID=""
		Continue:(argPrjID'="")&&(PrjID'=argPrjID)
		Set DocIDs="",IsActive=""
			
		Set objProject=##Class(DHCMed.CR.Project).%OpenId(PrjID)
		If $IsObject(objProject)
			 {
				Set DocIDs=objProject.Resume
				Set IsActive=objProject.Active
			 }
		If objProject'="" Do objProject.%Close()
		Quit:DocIDs=""
		Quit:IsActive'["Y"
		Set rset = ##class(%ResultSet).%New()
		Set rset.ClassName = "DHCMed.NINFService.Aim.Interface"
		Set rset.QueryName = "GetEPRListByEpisodeID"
		Set sc = rset.Execute(EpisodeID)
		While (rset.Next(.sc))
		{
			If ($SYSTEM.Status.IsOK(sc))
			{   
				Set InstanceID=rset.Data("InstanceDataID")
				;Set EpisodeID=rset.Data("EpisodeID")
				Set CreateDate=rset.Data("CreateDate")
				Set CreateTime=rset.Data("CreateTime")
				Set CreateUserID=rset.Data("CreateUserID")
				Set ModiDate=rset.Data("ModifyDate")
				Set ModiTime=rset.Data("ModifyTime")
				Set CreateCtLocID=rset.Data("CreateCtLocID")
				Set:CreateCtLocID="" CreateCtLocID=0
				Set Status=rset.Data("Status")
				Set EPRTemplateID=rset.Data("EPRTemplateID")
				Continue:DocIDs'=EPRTemplateID
				//TStart
				Set RepID=$o(^DHCMed.CR.ReportI("IndexProjectIDInstanceID"," "_PrjID," "_InstanceID,0))
				Set objReport=##Class(DHCMed.CR.Report).%OpenId(RepID)
				If $IsObject(objReport) {			
					Set RepStatus=..GetStatusByRepID(RepID)
					//add by lyh 2012-04-19
					Set ret=##class(DHCMed.NINFService.Aim.ICUSrv).UpdateInfReport(RepID)
				
				} Else {
					//处理新报告
					Set RepID=""
					Set Status=$s(Status="未完成":"S",1:"D")
					Set RepInput=RepID_"^"_InstanceID_"^"_PrjID_"^"_EpisodeID_"^"_Status_"^"_CreateUserID_"^"_CreateDate_"^"_CreateTime_"^^^^^^^^"_CreateCtLocID
					Set RepID=##Class(DHCMed.CR.Report).Update(RepInput)
					//add by lyh 2012-04-19
					Set ret=##class(DHCMed.NINFService.Aim.ICUSrv).UpdateInfReport(RepID)
					//If RepID<0 TRollBack
					Set RepStatusInput=RepID_"^^"_Status_"^"_CreateUserID_"^"_CreateDate_"^"_CreateTime_"^"
					Set ChildID=##Class(DHCMed.CR.RepStatus).Update(RepStatusInput)
					//If +ChildID<0 TRollBack
				}
				If objReport'=""{
					 Do objReport.%Close()
				}
			}
		}
	
		If $SYSTEM.Status.IsError(sc)
		{
		
			Set return=-1
			Do $system.OBJ.DisplayError(sc)
		} Else {
			Set return=1
			Do rset.Close()
		}
	}
	
	Quit return
	
SyncDataEPRToCRErr1
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2012-05-16
/// Description:  以创建日期、创建人科室为条件，获取新框架历次病程/出院记录等列表
///               提供给临床上报同步数据的接口
/// Table：       EPRinstance.EPRLogs
/// Input:   
/// Return：      临床上报报告列表
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.Interface","GetEPRListByEpisodeID","2767404")
Query GetEPRListByEpisodeID(EpisodeID As %String) As %Query(ROWSPEC = "InstanceDataID:%String, EpisodeID:%String, CreateDate:%String, CreateTime:%String, CreateUserID:%String, CreateCtLocID:%String, HappenDate:%String, HappenTime:%String, Status:%String, ModifyDate:%String, ModifyTime:%String,EPRTemplateID:%String")
{
}

ClassMethod GetEPRListByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set repidInd=1
 	
 	q:'$d(^DHCEPRI.EPRLogsI("IdxForLink"," "_EpisodeID)) $$$OK
 	s Date=""
 	f  s Date=$o(^DHCEPRI.EPRLogsI("IdxForLink"," "_EpisodeID,Date)) q:Date=""  d
 	.s Time=""
 	.f  s Time=$o(^DHCEPRI.EPRLogsI("IdxForLink"," "_EpisodeID,Date,Time)) q:Time=""  d
 	..s DocID=""
 	..f  s DocID=$o(^DHCEPRI.EPRLogsI("IdxForLink"," "_EpisodeID,Date,Time,DocID)) q:DocID=""  d
  	...s EprLogsID = $o(^DHCEPRI.EPRLogsI("IdxForLink"," "_EpisodeID, Date, Time, DocID, ""),-1)
	...q:EprLogsID=""
	...s ECRecordID=""
	...s BindTemplateID="",ChartItemType=""
	...s EPRTemplateID=$o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID",DocID,0))
	...q:EPRTemplateID=""
	...s objEPRTemplate=##Class(EPRmeta.EPRTemplate).%OpenId(EPRTemplateID)
	...i $IsObject(objEPRTemplate) d
	....Set BindTemplateID=objEPRTemplate.BindTemplateID
	...i objEPRTemplate'="" Do objEPRTemplate.%Close()
	...i BindTemplateID'="" d
	....s objTemplate=##Class(EPRmeta.Template).%OpenId(BindTemplateID)
	...i $IsObject(objTemplate) d
	....s ChartItemType=objTemplate.ChartItemType
	...i objTemplate'="" Do objTemplate.%Close()
	...i ChartItemType="Single" d
	....s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_EpisodeID, " CG"_BindTemplateID, ""))
	...i ChartItemType="Multiple" d
	....s DocStr=" ML"_$tr(DocID," ","")
	....s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_EpisodeID, DocStr, ""))
	...q:ECRecordID=""
	...s EPRLogsObj=##class(EPRinstance.EPRLogs).%OpenId(EprLogsID)
	...q:'$IsObject(EPRLogsObj)
	...s EprNum=EPRLogsObj.EPRNum
	...s ChildSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ECRecordID, " "_EprNum, ""))
	...q:ChildSub=""
	...s InstanceId = ECRecordID_"||"_ChildSub
	...s retInstanceId = $tr(InstanceId," ",""), retEpisodeId = $e(EpisodeID,2,$l(EpisodeID))
	...s retCreateDate = "", retCreateTime = "", retCreateUserID = "", retCreateCtLocID="", retHappenDate="", retHappenTime="", retStatus=""
	...s retModifyDate = "", retModifyTime = ""
	...s EprLogs = ##class(EPRinstance.EPRLogs).%OpenId(EprLogsID)
	...i EprLogs '= "" d
	....s retCreateDate = EprLogs.CreateDate
	....s retCreateTime = EprLogs.CreateTime
	....s retCreateUserID = EprLogs.CreateUserID
	....s retHappenDate = EprLogs.HappenDate
	....s retHappenTime = EprLogs.HappenTime
	....s retStatus = EprLogs.EPRStatus
	....i (retStatus'="") d
	.....&sql(SELECT StatusName into :retStatus FROM EPRmeta.EPRStatus WHERE StatusCode = :retStatus)
	....i EprLogs'="" Do EprLogs.%Close()
	....s objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(retInstanceId)
	....i objInstanceData '= "" d
	.....s retModifyDate = objInstanceData.ModifyDate
	.....s retModifyTime = objInstanceData.ModifyTime
	....i objInstanceData'="" Do objInstanceData.%Close()
	....//设置返回值					实例数据ID		就诊rowid	创建日期		创建时间		创建人ID		创建科室（暂时为空）
	....s ^CacheTemp(repid, repidInd) = $lb(retInstanceId, retEpisodeId, retCreateDate, retCreateTime, retCreateUserID, retCreateCtLocID, retHappenDate, retHappenTime, retStatus, retModifyDate, retModifyTime ,EPRTemplateID )
	....s repidInd = repidInd + 1

	Quit $$$OK
}

ClassMethod GetEPRListByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEPRListByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set repidInd=$LIST(qHandle,3)
 	Set repidInd=$o(^CacheTemp(repid,repidInd))
 	If repidInd="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,repidInd)
 	}
 	Set qHandle=$lb(AtEnd,repid,repidInd)
	Quit $$$OK
}

ClassMethod GetEPRListByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEPRListByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

}

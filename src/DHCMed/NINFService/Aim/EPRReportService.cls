/// 名称: DHCMed.NINFService.Aim.EPRReportService
/// 描述: 临床上报报告查询
/// 编写者：lyh
/// 编写日期: 2012-07-24
Class DHCMed.NINFService.Aim.EPRReportService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReportService","QueryEPRByEpisodeID","76813")
Query QueryEPRByEpisodeID(EpisodeID As %String) As %Query(ROWSPEC = "rowid:%String,EpisodeID:%String,InstanceID,RepStatus:%String,RepDoc:%String,RepCtloc:%String,RepDate:%String,CheckDate:%String,CheckUser:%String,PrintDocID:%String,TemplateDocID:%String,Description:%String")
{
}

ClassMethod QueryEPRByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s ret=..SyncDataEPRByEpisodeID(2,EpisodeID)

	q:(EpisodeID="") $$$OK
	q:'$d(^DHCMed.CR.ReportI("EpisodeID"," "_EpisodeID)) $$$OK
	
	s rowid=""
	f  s rowid=$o(^DHCMed.CR.ReportI("EpisodeID"," "_EpisodeID,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CR.Report).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s InstanceID=obj.InstanceID
	.s RepStatus=obj.RepStatus
	.s:RepStatus="D" RepStatus="待审"
	.s:RepStatus="Y" RepStatus="已审"
	.s:RepStatus="R" RepStatus="退回"
	.s:RepStatus="S" RepStatus="删除"
	.s RepDoc=obj.RepDoc
	.i RepDoc'=""  d
	..s objUser=##class(DHCMed.Base.SSUser).GetObjById(RepDoc)
	..q:'$IsObject(objUser)
	..s RepDoc=objUser.Name
	.s RepCtloc=obj.RepCtloc
	.i +RepCtloc=0 d
	..s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	..q:'$IsObject(objAdm)
	..s RepCtloc=objAdm.Department	//如报告科室为空，则取就诊科室
	.s RepDate=obj.RepDate
	.s:RepDate'="" RepDate=$zd(RepDate,3)
	.s CheckDate=obj.CheckDate
	.s CheckUser=obj.CheckUser
	.i CheckUser'=""  d
	..s objUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	..q:'$IsObject(objUser)
	..s CheckUser=objUser.Name
	.s ProjectID=obj.ProjectID
	.q:ProjectID=""
	.s objPrj=##Class(DHCMed.CR.Project).%OpenId(ProjectID)
	.q:'$IsObject(objPrj)
	.s PrintDocID=objPrj.TemplateID
	.s TemplateDocID=objPrj.Resume
	.s Description=objPrj.Description
	.s $li(data,1)=rowid
	.s $li(data,2)=EpisodeID
	.s $li(data,3)=InstanceID
	.s $li(data,4)=RepStatus
	.s $li(data,5)=RepDoc
	.s $li(data,6)=RepCtloc
	.s $li(data,7)=RepDate
	.s $li(data,8)=CheckDate
	.s $li(data,9)=CheckUser
	.s $li(data,10)=PrintDocID
	.s $li(data,11)=TemplateDocID
	.s $li(data,12)=Description
	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryEPRByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEPRByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEPRByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEPRByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp 
    d Config.%Close()
    s s=WebServerAppURL
	q s
}

/// Creator：     liuyh
/// CreatDate：   2012-05-16
/// Description:  同步电子病历数据为临床上报数据
/// Table：       DHCMed.CR.Project,DHCMed.CR.ProjectStatus
/// Input：       
/// Return：      return<0 : 失败 , return>0 : 成功
/// w ##class(DHCMed.NINFService.Aim.EPRReportService).SyncDataEPRByEpisodeID("7",2767404)
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
		Set rset.ClassName = "DHCMed.CRService.Interface"
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
					Set RepStatus=##class(DHCMed.CRService.Interface).GetStatusByRepID(RepID)		
				} Else {
					//处理新报告
					Set RepID=""
					Set Status=$s(Status="未完成":"S",1:"D")
					Set RepInput=RepID_"^"_InstanceID_"^"_PrjID_"^"_EpisodeID_"^"_Status_"^"_CreateUserID_"^"_CreateDate_"^"_CreateTime_"^^^^^^^^"_CreateCtLocID
					Set RepID=##Class(DHCMed.CR.Report).Update(RepInput)
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

Storage Default
{
<Data name="EPRReportServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INFS5C1.EPRReportSer634D</DataLocation>
<DefaultData>EPRReportServiceDefaultData</DefaultData>
<IdLocation>^DHCMed.INFS5C1.EPRReportSer634D</IdLocation>
<IndexLocation>^DHCMed.INFS5C1.EPRReportSer634I</IndexLocation>
<StreamLocation>^DHCMed.INFS5C1.EPRReportSer634S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

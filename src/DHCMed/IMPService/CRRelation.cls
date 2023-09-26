/// 重点患者对EPR临床上报的接口
Class DHCMed.IMPService.CRRelation Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 通过临床报告标记重点患者~~
/// w ##class(DHCMed.IMPService.CRRelation).MarkIMPByClinicalReportID(1)
ClassMethod MarkIMPByClinicalReportID(ReportID As %String) As %Integer
{
		q:ReportID="" -1 //没有指定报告ID
		s objReport=##class(DHCMed.CR.Report).%OpenId(ReportID)
		q:$IsObject(objReport)=0 -2 //没找到报告
		q:$d(^DHCMed.IMP.ImpRelationCRI("ProjectIDIndex",objReport.ProjectID))=0 -3 //没有对应的重点患者类型
		s objWaitForCheckStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus","1",1)
		s objCheckStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus","4",1)
		s objReturnStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus","5",1)
		s objFinishStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus","2",1)
		s objExitStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus","3",1)
		s objDeleteStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ImpStatus","0",1)
		s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objReport.EpisodeID)
		s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)		
		s relationID="" f  s relationID=$o(^DHCMed.IMP.ImpRelationCRI("ProjectIDIndex",objReport.ProjectID,relationID)) q:relationID=""  d
		.s objRelation=##class(DHCMed.IMP.ImpRelationCR).%OpenId(relationID)
		.s objSubType=##class(DHCMed.IMP.PatientTypeSub).%OpenId(objRelation.SubTypeID)
		.i $d(^DHCMed.IMP.ImpPatientI("TypePaadmIndex",objRelation.SubTypeID,objReport.EpisodeID))=0  d //没有标记过，标记之
		..s ret=$$ReportIMP()
		.e  d
		..s flag=0 //如果以前有过所需的标记，就需要判定上次标记的状态，如果是已审状态便不进行操作，否则需要重新标记！！！
		..s impID="" f  s impID=$o(^DHCMed.IMP.ImpPatientI("TypePaadmIndex",objRelation.SubTypeID,objReport.EpisodeID,impID)) q:impID=""  d
		...s objIMP=##class(DHCMed.IMP.ImpPatient).GetObjById(impID)
		...q:$IsObject(objIMP)=0
		...s:(objIMP.Status=objCheckStatus.%Id()!objIMP.Status=objWaitForCheckStatus.%Id()) flag=1
		...d objIMP.%Close()
		...k objIMP
		..s:flag=0 ret=$$ReportIMP()
		.d objRelation.%Close()
		.k objRelation
		.d objSubType.%Close()
		.k objSubType
		d objWaitForCheckStatus.%Close()
		d objCheckStatus.%Close()
		d objReturnStatus.%Close()
		d objFinishStatus.%Close()
		d objExitStatus.%Close()
		d objDeleteStatus.%Close()
		d objAdm.%Close()
		d objPatient.%Close()
		k objAdm
		k objPatient
		k objWaitForCheckStatus
		k objCheckStatus
		k objReturnStatus
		k objFinishStatus
		k objExitStatus
		k objDeleteStatus	
		
		d objReport.%Close()
		k objReport
		q 1
ReportIMP()
		s arg=""
		s $p(arg,$c(1),1)=""
		s $p(arg,$c(1),2)=objReport.EpisodeID
		s $p(arg,$c(1),3)=objAdm.PatientID
		s $p(arg,$c(1),4)=objPatient.PatientName
		s $p(arg,$c(1),5)=$zd(objReport.RepDate,3)
		s $p(arg,$c(1),6)=$zt(objReport.RepTime,1)
		s $p(arg,$c(1),7)=objSubType.%Id()
		s $p(arg,$c(1),8)=$s(objSubType.NeedCheck=1:objCheckStatus.%Id(),1:objWaitForCheckStatus.%Id()) // $p(arg,$c(1),8)=objWaitForCheckStatus.%Id()
		s $p(arg,$c(1),9)=+##class(DHCMed.Base.SSUser).GetIdByName(objReport.RepDoc) //objReport.RepDoc
		s $p(arg,$c(1),10)=$zd(objReport.RepDate,3)
		s $p(arg,$c(1),11)=$zt(objReport.RepTime,1)
		s $p(arg,$c(1),12)=objReport.Resume
		s $p(arg,$c(1),13)=+##class(DHCMed.Base.SSUser).GetIdByName(objReport.RepDoc) //objReport.RepDoc
		s $p(arg,$c(1),14)=""
		s $p(arg,$c(1),15)=""
		s ret=##class(DHCMed.IMP.ImpPatient).Update(arg,$c(1))
		i objReport.RepStatus="Y"  d
		.s sc=##class(DHCMed.IMP.ImpPatient).ModifyStatus(ret,2,objReport.CheckUser,"",objReport.CheckDate,objReport.CheckTime)
		i (objReport.RepStatus="D")&&(objSubType.NeedCheck=1)  d
		.s sc=##class(DHCMed.IMP.ImpPatient).ModifyStatus(ret,2,"","",objReport.RepDate,objReport.RepTime)
		q 1
}

/// 同步临床上报的报告数据
/// w ##class(DHCMed.IMPService.CRRelation).SynchronizeData("",1,"2010-6-1","2010-6-30","")
ClassMethod SynchronizeData(ImpType As %String, ImpSubType As %String, FromDate As %String, ToDate As %String, Loc As %String) As %Integer
{
	q:ImpSubType=""!ImpType="" -1
	//1.分期分批同步临床报告系统的数据
	i ImpSubType'=""  d
	.s ret=$$SynchronizeCR(ImpSubType,FromDate,ToDate,Loc)
	i ImpType'=""  d
	.s subType="" f  s subType=$o(^DHCMed.IMP.PatientTypeSubI("ParentIDIndex",ImpType,subType)) q:subType=""  d
	..s ret=$$SynchronizeCR(subType,FromDate,ToDate,Loc)
	
	
	
	q 1
	
	//分批同步好临床上报数据	
SynchronizeCR(SubTypeID,FromDate,ToDate,Loc)
	s relationID="" f  s relationID=$o(^DHCMed.IMP.ImpRelationCRI("SubTypeIDIndex",SubTypeID,relationID)) q:relationID=""  d
	.s objRelation=##class(DHCMed.IMP.ImpRelationCR).%OpenId(relationID)
	.q:$IsObject(objRelation)=0
	.s ret=##class(DHCMed.CRService.ReportCtl).InitRepData(objRelation.ProjectID,FromDate,ToDate,Loc)
	.s ret=$$SynchronizeIMP(objRelation.ProjectID,FromDate,ToDate,Loc)
	.d objRelation.%Close()
	.k objRelation	
	q 1
	
	//同步重点患者数据
SynchronizeIMP(ProjectID,FromDate,ToDate,Loc)
	s returnValue=##class(DHCMed.CRService.ReportCtl).QueryA(FromDate,ToDate,Loc,"D^Y^R",ProjectID)
	s JIndex=$p(returnValue,"^",2)
	s ind="" f  s ind=$o(^CacheTemp("DHCMedCL",JIndex,ind)) q:ind=""  d
	.s reportID=$g(^CacheTemp("DHCMedCL",JIndex,ind))
	.s result=..MarkIMPByClinicalReportID(reportID)
	k ^CacheTemp("DHCMedCL",JIndex)
	q 1
}

ClassMethod PrepareTestData()
{
	//##class(DHCMed.IMPService.CRRelation).PrepareTestData()
	/*
	s arg="^1^1^66107^D^1^2010-06-02^12:00:00^^^^^^^^1^^"
	s $p(arg,"^",1)="" //
	s $p(arg,"^",2)=1 // EpisodeID
	s $p(arg,"^",3)=1 // ProjectID
	s $p(arg,"^",4)=66107 // Paadm
	s $p(arg,"^",5)="D" // ReportStatus
	s $p(arg,"^",6)=1 // UpdateUser
	s $p(arg,"^",7)="2010-06-02" //UpdateDate
	s $p(arg,"^",8)="12:00:00" //
	s $p(arg,"^",16)=1 //DutyUser
	w ##class(DHCMed.CR.Report).Update(arg)
	*/
	s $p(arg,"^",1)=""
	s $p(arg,"^",2)=1
	s $p(arg,"^",3)=2
	s $p(arg,"^",4)=68738
	s $p(arg,"^",5)="Y"
	s $p(arg,"^",6)=21
	s $p(arg,"^",7)="2010-06-02"
	s $p(arg,"^",8)="12:00:00"
	s $p(arg,"^",16)=21
	w ##class(DHCMed.CR.Report).Update(arg)	
	
	q ""
}

/// 查询关联的模板
/// d ##Class(%ResultSet).RunQuery("DHCMed.IMPService.CRRelation","QueryTemplateRelation",1)
Query QueryTemplateRelation(SubTypeID As %String) As %Query(ROWSPEC = "check:%String,ProjectID:%String,ProjectName:%String:模板名称,RelationID:%String")
{
}

ClassMethod QueryTemplateRelationExecute(ByRef qHandle As %Binary, SubTypeID As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   Set ind=1
   Set qHandle=$lb(0,repid,0)
	s rowid="" f  s rowid=$o(^DHCMed.CR.ProjectD(rowid)) q:rowid=""  d
	.s objProject=##class(DHCMed.CR.Project).%OpenId(rowid)
	.s data=$lb("")
	.s $li(data,1)=$s($d(^DHCMed.IMP.ImpRelationCRI("ProjectSubTypeIndex",objProject.%Id(),SubTypeID))=0:"0",1:"1")
	.s $li(data,2)=objProject.%Id()
	.s $li(data,3)=objProject.Description
	.s $li(data,4)=$o(^DHCMed.IMP.ImpRelationCRI("ProjectSubTypeIndex",objProject.%Id(),SubTypeID,""))
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryTemplateRelationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTemplateRelationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryTemplateRelationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTemplateRelationExecute ]
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

/// 新建临床上报模板与重点病人系统的关联
ClassMethod Update(ProjectID As %String, SubTypeID As %String) As %Integer
{
	q:(ProjectID=""!SubTypeID="") -1
	s objRelation=##class(DHCMed.IMP.ImpRelationCR).%New()
	s objRelation.ProjectID=ProjectID
	s objRelation.SubTypeID=SubTypeID
	s objRelation.IsActive=1
	s objRelation.ResumeText=""
	s ret=objRelation.%Save()
	d objRelation.%Close()
	k objRelation
	q ret
}

/// 删除关联
ClassMethod DeleteRelation(RelationID As %String)
{
	q:RelationID="" -1
	q ##class(DHCMed.IMP.ImpRelationCR).%DeleteId(RelationID)
}

}

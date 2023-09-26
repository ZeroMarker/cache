/// CTOR: QP
/// DATE: 2020-08-31
/// DESC: 临床药理阶段配置类
Class web.PilotProject.Extend.Stage Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-02
/// DESC: 查询阶段
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("web.PilotProject.Extend.Stage","QryStage",11)
Query QryStage(PrjDR = "", InActive = "") As %Query(ROWSPEC = "id,stageDr,stageDesc,seqno,days,prjDesc,PrjDR")
{
}

ClassMethod QryStageExecute(ByRef qHandle As %Binary, PrjDR = "", InActive = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (PrjDR="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k HList
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	s id=""
	f  s id=$o(^CF.DOC.Pilot.OEStageI("Prj",PrjDR,id)) q:id=""  d
	.s stageDr=""
	.s seqno=$p(^CF.DOC.Pilot.OEStageD(id),"^",3)
	.s days=$p(^CF.DOC.Pilot.OEStageD(id),"^",5)
	.s hosp=$p(^CF.DOC.Pilot.OEStageD(id),"^",6)
	.s active=$p(^CF.DOC.Pilot.OEStageD(id),"^",8)
	.q:active'=1
	.s prjDesc=$p(^DHCDocPP(PrjDR),"^",2)
	.s stageDesc=$p(^CF.DOC.Pilot.OEStageD(id),"^",1)
	.s stageDesc=##class(User.DHCDocPilotProStage).GetTranByDesc("STName",stageDesc,langid)
	.s stageCode=$p(^CF.DOC.Pilot.OEStageD(id),"^",2)
	.s HList(seqno)=$lb(id,stageDr,stageDesc,seqno,days,prjDesc,PrjDR)
 	
 	s order=""
	f  s order=$o(HList(order)) q:order=""  d
	.s outdate=HList(order)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=outdate	//$lb(id,stageDr,stageDesc,seqno,days,prjDesc,PrjDR)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryStageExecuteOld(ByRef qHandle As %Binary, PrjDR = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (PrjDR="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k HList
	s id=""
	f  s id=$o(^CF.DOC.Pilot.ProjectStageI("ProjectDr",PrjDR,id)) q:id=""  d
	.s stageDr=$p(^CF.DOC.Pilot.ProjectStageD(id),"^",2)
	.s seqno=$p(^CF.DOC.Pilot.ProjectStageD(id),"^",3)
	.s days=$p(^CF.DOC.Pilot.ProjectStageD(id),"^",4)
	.s prjDesc=$p(^DHCDocPP(PrjDR),"^",2)
	.s stageDesc=$p(^CF.DOC.Pilot.OEStageD(stageDr),"^",1)
	.s HList(seqno)=$lb(id,stageDr,stageDesc,seqno,days,prjDesc,PrjDR)
 	.;d output1
 	
 	s order=""
	f  s order=$o(HList(order)) q:order=""  d
	.s outdate=HList(order)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=outdate	//$lb(id,stageDr,stageDesc,seqno,days,prjDesc,PrjDR)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryStageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStageExecute ]
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

/// CTOR: QP
/// DATE: 2020-09-02
/// DESC: 查询阶段字典
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("web.PilotProject.Extend.Stage","QryStageDic")
Query QryStageDic(PPRowId = "", PPDesc = "", InHosp = "") As %Query(ROWSPEC = "id,name,code,order,note,days,hosp,project,projectName,active")
{
}

ClassMethod QryStageDicExecute(ByRef qHandle As %Binary, PPRowId = "", PPDesc = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	
 	K TList
	s id=0
	f  s id=$o(^CF.DOC.Pilot.OEStageD(id)) q:id=""  d
	.s name=$p(^CF.DOC.Pilot.OEStageD(id),"^",1)
	.s code=$p(^CF.DOC.Pilot.OEStageD(id),"^",2)
	.s order=$p(^CF.DOC.Pilot.OEStageD(id),"^",3)
	.s note=$p(^CF.DOC.Pilot.OEStageD(id),"^",4)
	.s days=$p(^CF.DOC.Pilot.OEStageD(id),"^",5)
	.s hosp=$p(^CF.DOC.Pilot.OEStageD(id),"^",6)
	.s project=$p(^CF.DOC.Pilot.OEStageD(id),"^",7)
	.s active=$p(^CF.DOC.Pilot.OEStageD(id),"^",8)
	.q:project=""
	.s loc=$p(^DHCDocPP(project),"^",6)
 	.s Hosp=$p($g(^CTLOC(loc)),"^",22)
 	.q:(InHosp'="")&&(InHosp'=Hosp)
	.q:(PPRowId'="")&&(project'=PPRowId)
	.s PPCode=$p(^DHCDocPP(project),"^",1)
	.s projectName=$p(^DHCDocPP(project),"^",2)
	.s isExit=1
	.i PPDesc'="" d
	..s PPDesc=$zcvt(PPDesc,"U")
	..s PPCode=$zcvt(PPCode,"U")
	..s UCode=$zcvt(code,"U")
	..s PPName=$zcvt(projectName,"U")
	..s StageName=$zcvt(name,"U")
	..i UCode[PPDesc s isExit=0 
	..i PPName[PPDesc s isExit=0
	..i StageName[PPDesc s isExit=0
	.e  d
	..s isExit=0
	.q:isExit=1
	.i project="" s project=0
	.s TList(project,order)=$lb(id,name,code,order,note,days,hosp,project,projectName,active)
 	.;d output2
 	
 	s project=""
	f  s project=$o(TList(project)) q:project=""  d
 	.s order=""
	.f  s order=$o(TList(project,order)) q:order=""  d
	..s outdate=TList(project,order)
 	..d output2
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output2
	Set Data=outdate	//$lb(id,name,code,order,note,days,hosp)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryStageDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStageDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStageDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStageDicExecute ]
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

/// CTOR: QP
/// DATE: 2020-09-02
/// DESC: 保存阶段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Stage).Save("147||4")
ClassMethod Save(mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s projectDr=$p(mList,"^",2)
	s stage=$p(mList,"^",3)
	s seqno=$p(mList,"^",4)
	s days=$p(mList,"^",5)
	
	i id="" {
		s a=##class(User.DHCDocPilotProProjectStage).%New()
		i $d(^CF.DOC.Pilot.ProjectStageI("ProjectStage",projectDr,stage)) {
			Q -102	
		}
	} else {
		s a=##class(User.DHCDocPilotProProjectStage).%OpenId(id)
		s oldProjectDr=a.PSProjectDrGetObjectId()
		s oldStageDr=a.PSStageDrGetObjectId()
		i $d(^CF.DOC.Pilot.ProjectStageI("ProjectStage",projectDr,stage)) {
			i (oldProjectDr'=projectDr)||(oldStageDr'=stage) {
				Q -102	
			}
		}

	}
	d a.PSProjectDrSetObjectId(projectDr)
	d a.PSStageDrSetObjectId(stage)
	s a.PSDays=days
	s a.PSSeqno=seqno
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-02
/// DESC: 保存字典
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Stage).Save("147||4")
ClassMethod SaveDic(mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s name=$p(mList,"^",3)
	s seqno=$p(mList,"^",4)
	s project=$p(mList,"^",5)
	s active=$p(mList,"^",6)
	s days=$p(mList,"^",7)
	//自动计算顺序
	s seqno=$o(^CF.DOC.Pilot.OEStageI("PrjOrder",project,""),-1)+1

	i id="" {
		s a=##class(User.DHCDocPilotProStage).%New()
		i $d(^CF.DOC.Pilot.OEStageI("PrjCode",project,code)) {
			Q -102	
		}
		s a.STOrder=seqno
	} else {
		s a=##class(User.DHCDocPilotProStage).%OpenId(id)
		s oldCode=a.STCode
		s oldProject=a.STProjectGetObjectId()
		i $d(^CF.DOC.Pilot.OEStageI("PrjCode",project,code)) {
			i (oldCode'=code)||(oldProject'=project) {
				Q -102	
			}
		}

	}
	s a.STCode=code
	s a.STName=name
	//s a.STProject=project
	d a.STProjectSetObjectId(project)
	s a.STActive=active
	s a.STDays=days
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-22
/// DESC: 删除字典
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Stage).DeleteDic("")
ClassMethod DeleteDic(ID As %String)
{
	Q:ID="" 0
	&SQL(DELETE FROM SQLUser.DHC_DocPilotProStage WHERE ST_RowId=:ID)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-01-22
/// DESC: 字典上调/下调
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Stage).UpOrder("")
ClassMethod UpOrder(oldID, oldSeqno, preID, preSeqno)
{
	Q:(oldID="")||(oldSeqno="")||(preID="")||(preSeqno="") 0
	&SQL(UPDATE SQLUser.DHC_DocPilotProStage SET ST_Order=:preSeqno WHERE ST_RowId=:oldID)
	Q:SQLCODE'=0 SQLCODE
	&SQL(UPDATE SQLUser.DHC_DocPilotProStage SET ST_Order=:oldSeqno WHERE ST_RowId=:preID)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-01-22
/// DESC: 删除阶段设置
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Stage).DeleteDic("")
ClassMethod DeleteStage(ID As %String)
{
	Q:ID="" 0
	&SQL(DELETE FROM SQLUser.DHC_DocPilotProProjectStage WHERE PS_Id=:ID)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-01-22
/// DESC: 阶段设置上调/下调
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Stage).UpOrder("")
ClassMethod UpStageOrder(oldID, oldSeqno, preID, preSeqno)
{
	Q:(oldID="")||(oldSeqno="")||(preID="")||(preSeqno="") 0
	&SQL(UPDATE SQLUser.DHC_DocPilotProProjectStage SET PS_Seqno=:preSeqno WHERE PS_Id=:oldID)
	Q:SQLCODE'=0 SQLCODE
	&SQL(UPDATE SQLUser.DHC_DocPilotProProjectStage	 SET PS_Seqno=:oldSeqno WHERE PS_Id=:preID)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-04-08
/// DESC: 查询药理项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("web.PilotProject.Extend.Stage","QryGCP")
Query QryGCP(inDesc = "", InHosp = "") As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod QryGCPExecute(ByRef qHandle As %Binary, inDesc = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=0
 	f  s id=$o(^DHCDocPP(id)) q:id=""  d
 	.s code=$p(^DHCDocPP(id),"^",1)
 	.s desc=$p(^DHCDocPP(id),"^",2)
 	.s loc=$p(^DHCDocPP(id),"^",6)
 	.s Hosp=$p($g(^CTLOC(loc)),"^",22)
 	.q:(InHosp'="")&&(Hosp'=InHosp)
 	.q:(inDesc'="")&&(desc'[inDesc)
 	.s status=$p(^DHCDocPP(id),"^",16)
 	.;q:(status'="N")&&(status'="V")&&(status'="C")
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryGCPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGCPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGCPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGCPExecute ]
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

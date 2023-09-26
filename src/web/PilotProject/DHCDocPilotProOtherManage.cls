Import SQLUser

Class web.PilotProject.DHCDocPilotProOtherManage Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod UpdateSOP(PPSOPRowId As %String, SOPName As %String, FirstDate As %String, UpdateCount As %String, SOPNewDate As %String) As %String
{
	s myrtn=0
	q:SOPName="" "-101"
	s:FirstDate'="" FirstDate=$zdh(FirstDate,4)
	s:SOPNewDate'="" SOPNewDate=$zdh(SOPNewDate,4)
	if (PPSOPRowId=""){
		Set ProSOP = ##class(User.DHCDocPilotProSOP).%New()
	}
	else {
		Set ProSOP = ##class(User.DHCDocPilotProSOP).%OpenId(PPSOPRowId)
	}
	s ProSOP.SOPDesc=SOPName
	s ProSOP.SOPFirstDate=FirstDate
	s ProSOP.SOPUpdateCount=UpdateCount
	s ProSOP.SOPNewDate=SOPNewDate
	Set sc = ProSOP.%Save()
	If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
		}
  q myrtn
}

Query FindSOP(SOPName, FirstDate, UpdateCount, SOPNewDate) As %Query(ROWSPEC = "RecordSum:%String,TPPSOPRowId:%String,TSOPName:%String,TFirstDate:%String,TUpdateCount:%String,TSOPNewDate:%String,ProcesNo:%String") [ SqlProc ]
{
}

ClassMethod FindSOPClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindSOPExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSOPFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSOPExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
		s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获得SOP信息
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProOtherManage","FindSOP")
ClassMethod FindSOPExecute(ByRef QHandle As %Binary, SOPName, FirstDate, UpdateCount, SOPNewDate) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ^zzy("FindSOP")=FirstDate
	s ind=1
	d ResetVariables
	s USERID=%session.Get("LOGON.USERID")
	k ^TmpFindSOP
	s ProcesNo=$j
	s PPSOPRowId=0
	f  s PPSOPRowId=$o(^DHCDocPPSOP(PPSOPRowId)) q:PPSOPRowId=""  d
	.;s TPPSOPRowId=PPSOPRowId
	.s TSOPName=$p($g(^DHCDocPPSOP(PPSOPRowId)),"^",1)
	.q:TSOPName'[SOPName
	.s TFirstDate=$p($g(^DHCDocPPSOP(PPSOPRowId)),"^",2)
	.q:((TFirstDate'=FirstDate)&&(FirstDate'=""))
	.s TFirstDate1=""
	.s:TFirstDate'="" TFirstDate1=$zd(TFirstDate,3)
	.s:TFirstDate'="" TFirstDate=$zd(TFirstDate,4)
	.s TUpdateCount=$p($g(^DHCDocPPSOP(PPSOPRowId)),"^",3)
	.q:((TUpdateCount'=UpdateCount)&&(UpdateCount'=""))
	.s TSOPNewDate=$p($g(^DHCDocPPSOP(PPSOPRowId)),"^",4)
	.q:((TSOPNewDate'=SOPNewDate)&&(SOPNewDate'=""))
	.s TSOPNewDate1=""
	.s:TSOPNewDate'="" TSOPNewDate1=$zd(TSOPNewDate,3)
	.s:TSOPNewDate'="" TSOPNewDate=$zd(TSOPNewDate,4)
	
	
	
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    s ^TmpFindSOP(USERID,ProcesNo,ind)=TSOPName_"^"_TFirstDate1_"^"_TUpdateCount_"^"_TSOPNewDate1
    s ^TmpFindSOP(USERID,ProcesNo)=ind
	set Data=$lb(0,PPSOPRowId,TSOPName,TFirstDate,TUpdateCount,TSOPNewDate,ProcesNo)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (TPPSOPRowId,TSOPName,TFirstDate,TUpdateCount,TSOPNewDate,TFirstDate1,TSOPNewDate1,ProcesNo)=""
	quit
}

ClassMethod DeleteSOP(PPSOPRowId As %String) As %String
{
	q:PPSOPRowId="" "1"
	;q:PPSOPRowId=" " "1"
	&sql(delete from  DHC_DocPilotProSOP  where PPSOP_RowId=:PPSOPRowId) 
	q SQLCODE
}

ClassMethod GetSOPsNum(ProcessNo As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	s num=^TmpFindSOP(USERID,ProcessNo)
	q num
}

ClassMethod GetSOPs(ProcessNo As %String, Num As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q $g(^TmpFindSOP(USERID,ProcessNo,Num))
}

ClassMethod UpdateTrain(PPTRARowId As %String, TRADesc As %String, TRAType As %String, TRAAddress As %String, TRAPersonNum As %String, TRASttTime As %String, TRAEndTime As %String, TRAUser As %String) As %String
{
	s myrtn=0
	;q:TRADesc="" "-101"
	if (PPTRARowId=""){
		Set ProTrain = ##class(User.DHCDocPilotProTrain).%New()
	}
	else {
		Set ProTrain = ##class(User.DHCDocPilotProTrain).%OpenId(PPTRARowId)
	}
	s:TRASttTime'="" TRASttTime=$zdh(TRASttTime,4)
	s:TRAEndTime'="" TRAEndTime=$zdh(TRAEndTime,4)
	s ProTrain.TRADesc=TRADesc
	s ProTrain.TRAType=TRAType
	;s ProTrain.TRAAddress=TRAAddress
	s ProTrain.TRAPersonNum=TRAPersonNum
    s ProTrain.TRASttTime=TRASttTime
    s ProTrain.TRAUser=TRAUser
    s ProTrain.TRAEndTime=TRAEndTime	
	Set sc = ProTrain.%Save()
	If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
		}
  q myrtn
}

Query FindTrain(TRADesc, TRAType) As %Query(ROWSPEC = "RecordSum:%String,TPPTRARowId,TTRADesc,TTRAType,TTRAAddress,TTRAPersonNum,TTRASttTime,TTRAEndTime,TTRAUser,ProcesNo:%String") [ SqlProc ]
{
}

ClassMethod FindTrainClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindTrainExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrainFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
		s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获得培训情况信息
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProOtherManage","FindTrain")
ClassMethod FindTrainExecute(ByRef QHandle As %Binary, TRADesc, TRAType) As %Status
{
	
	Set repid=$I(^CacheTemp)
	
	s ind=1
	d ResetVariable1
	s USERID=%session.Get("LOGON.USERID")
	;s USERID=3335
	k ^TmpFindTrain
	s ProcesNo=$j
	s PPTRARowId=0
	f  s PPTRARowId=$o(^DHCDocPPTRA(PPTRARowId)) q:PPTRARowId=""  d
	.;s TPPSOPRowId=PPSOPRowId
	.s TTRADesc=$p($g(^DHCDocPPTRA(PPTRARowId)),"^",1)
	.q:TTRADesc'[TRADesc
	.s TTRAType=$p($g(^DHCDocPPTRA(PPTRARowId)),"^",2)
	.q:TTRAType'[TRAType
	.s TTRAAddress=$p($g(^DHCDocPPTRA(PPTRARowId)),"^",3)
	.s TTRAPersonNum=$p($g(^DHCDocPPTRA(PPTRARowId)),"^",5)
	.s TTRASttTime=$p($g(^DHCDocPPTRA(PPTRARowId)),"^",6)
	.s:TTRASttTime'="" TTRASttTime=$zd(TTRASttTime,4)
	.s TTRAEndTime=$p($g(^DHCDocPPTRA(PPTRARowId)),"^",7)
	.s:TTRAEndTime'="" TTRAEndTime=$zd(TTRAEndTime,4)
	.s TPPTRARowId=PPTRARowId
	.s TTRAUser=$p($g(^DHCDocPPTRA(PPTRARowId)),"^",4)
	.Do OutputRow1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    s ^TmpFindTrain(USERID,ProcesNo,ind)=TPPTRARowId_"^"_TTRASttTime_"^"_TTRAEndTime_"^"_TTRADesc_"^"_TTRAUser_"^"_TTRAType_"^"_TTRAPersonNum_"^"_ProcesNo
    s ^TmpFindTrain(USERID,ProcesNo)=ind
	set Data=$lb(0,TPPTRARowId,TTRADesc,TTRAType,TTRAAddress,TTRAPersonNum,TTRASttTime,TTRAEndTime,TTRAUser,ProcesNo)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariable1
	///set (repid)=0
	set (TPPTRARowId,TTRADesc,TTRAType,TTRAAddress,TTRAPersonNum,TTRASttTime,TTRAEndTime,TRAUser,ProcesNo)=""
	quit
}

ClassMethod DeleteTrain(PPTRARowId As %String) As %String
{
	q:PPTRARowId="" "1"
	&sql(delete from  DHC_DocPilotProTrain  where PPTRA_RowId=:PPTRARowId) 
	q SQLCODE
}

ClassMethod GetTrainNum(ProcessNo As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	s num=^TmpFindTrain(USERID,ProcessNo)
	q num
}

ClassMethod GetTrain(ProcessNo As %String, Num As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q $g(^TmpFindTrain(USERID,ProcessNo,Num))
}

ClassMethod UpdateQualityControl(PPQCRowId As %String, QCDate As %String, QCProjectDr As %String, QCUser As %String, QCQuestion As %String) As %String
{
	s myrtn=0
	s:QCDate'="" QCDate=$zdh(QCDate,4)
	if (PPQCRowId=""){
		Set QC = ##class(User.DHCDocPilotProQualityControl).%New()
	}
	else {
		Set QC = ##class(User.DHCDocPilotProQualityControl).%OpenId(PPQCRowId)
	}
	s QC.QCDate=QCDate
	d QC.QCProjectDrSetObjectId(QCProjectDr)
	s QC.QCUser=QCUser
	s QC.QCQuestion=QCQuestion
	Set sc = QC.%Save()
	If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
		}
  q myrtn
}

Query FindQualityControl() As %Query(ROWSPEC = "RecordSum,TPPQCRowId,TQCDate,TQCProjectName,TQCUser,TQCQuestion,TQCProjectDr,ProcesNo:%String") [ SqlProc ]
{
}

ClassMethod FindQualityControlClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindQualityControlExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualityControlFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualityControlExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
		s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获得质控信息
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProOtherManage","FindQualityControl")
ClassMethod FindQualityControlExecute(ByRef QHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	
	s ind=1
	d ResetVariable2
	s USERID=%session.Get("LOGON.USERID")
	;s USERID=3335
	k ^TmpQualityControl
	s ProcesNo=$j
	s PPQCRowId=0
	f  s PPQCRowId=$o(^DHCDocPPQC(PPQCRowId)) q:PPQCRowId=""  d
	.;s TPPSOPRowId=PPSOPRowId
	.s QCProjectName=""
	.s QCDate=$p($g(^DHCDocPPQC(PPQCRowId)),"^",1)
	.s:QCDate'="" QCDate=$zd(QCDate,3)
	.s QCProjectDr=$p($g(^DHCDocPPQC(PPQCRowId)),"^",2)
	.s:QCProjectDr'="" QCProjectName=$p($g(^DHCDocPP(QCProjectDr)),"^",2)
	.s QCUser=$p($g(^DHCDocPPQC(PPQCRowId)),"^",3)
	.s QCQuestion=$p($g(^DHCDocPPQC(PPQCRowId)),"^",4)
	.s TPPQCRowId=PPQCRowId
	.Do OutputRow2
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
    s ^TmpQualityControl(USERID,ProcesNo,ind)=TPPQCRowId_"^"_QCDate_"^"_QCProjectName_"^"_QCUser_"^"_QCQuestion_"^"_ProcesNo
    s ^TmpQualityControl(USERID,ProcesNo)=ind
	set Data=$lb(0,TPPQCRowId,QCDate,QCProjectName,QCUser,QCQuestion,QCProjectDr,ProcesNo)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariable2
	///set (repid)=0
	set (TPPQCRowId,QCDate,QCProjectName,QCUser,QCQuestion,ProcesNo)=""
	quit
}

ClassMethod GetQualityById(PPQCRowId)
{
	s QCProjectName=""
	s QCDate=$p($g(^DHCDocPPQC(PPQCRowId)),"^",1)
	s:QCDate'="" QCDate=$zd(QCDate,4)
	s QCProjectDr=$p($g(^DHCDocPPQC(PPQCRowId)),"^",2)
	s:QCProjectDr'="" QCProjectName=$p($g(^DHCDocPP(QCProjectDr)),"^",2)
	s QCUser=$p($g(^DHCDocPPQC(PPQCRowId)),"^",3)
	s QCQuestion=$p($g(^DHCDocPPQC(PPQCRowId)),"^",4)
	q PPQCRowId_"^"_QCDate_"^"_QCProjectDr_"^"_QCProjectName_"^"_QCUser_"^"_QCQuestion
}

ClassMethod DeleteQualityControl(PPQCRowId As %String) As %String
{
	q:PPQCRowId="" "1"
	&sql(delete from  DHC_DocPilotProQualityControl  where PPQC_RowId=:PPQCRowId) 
	q SQLCODE
}

ClassMethod UpdateGCP(PPGCPRowId As %String, GCPDept As %String, GCPName As %String, GCPWork As %String, GCPTime As %String, GCPHours As %String, GCPCompany As %String, GCPLevel As %String, GCPMethod As %String, GCPDate As %String, GCPBookLabel As %String) As %String
{
	s myrtn=0
	s:GCPDate'="" GCPDate=$zdh(GCPDate,4)
	if (PPGCPRowId=""){
		Set ProGCP = ##class(User.DHCDocPilotProGCP).%New()
	}
	else {
		Set ProGCP = ##class(User.DHCDocPilotProGCP).%OpenId(PPGCPRowId)
	}
	s ProGCP.GCPDept=GCPDept
	s ProGCP.GCPName=GCPName
	s ProGCP.GCPWork=GCPWork
	s ProGCP.GCPTime=GCPTime
	s ProGCP.GCPHours=GCPHours
	s ProGCP.GCPCompany=GCPCompany
	s ProGCP.GCPLevel=GCPLevel
	s ProGCP.GCPMethod=GCPMethod
	s ProGCP.GCPDate=GCPDate
	s ProGCP.GCPBookLabel=GCPBookLabel
	Set sc = ProGCP.%Save()
	If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
		}
  q myrtn
}

Query FindGCP(GCPDept As %String, GCPName, GCPMethod, GCPCompany) As %Query(ROWSPEC = "RecordSum,TPPGCPRowId,TGCPDept,TGCPName,TGCPWork,TGCPTime,TGCPHours,TGCPCompany,TGCPLevel,TGCPMethod,TGCPDate,TGCPBookLabel,ProcesNo:%String") [ SqlProc ]
{
}

ClassMethod FindGCPClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindGCPExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGCPFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualityControlExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
	s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
		s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获得GCP证书信息
/// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProOtherManage","FindGCP")
ClassMethod FindGCPExecute(ByRef QHandle As %Binary, GCPDept As %String, GCPName, GCPMethod, GCPCompany) As %Status
{
	
	Set repid=$I(^CacheTemp)
	
	s ind=1
	d ResetVariable3
	s USERID=%session.Get("LOGON.USERID")
	;s USERID=3335
	k ^TmpGCP
	s ProcesNo=$j
	s PPGCPRowId=0
	f  s PPGCPRowId=$o(^DHCDocPPGCP(PPGCPRowId)) q:PPGCPRowId=""  d
	.;s TPPSOPRowId=PPSOPRowId
	.s GCPDept1=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",1)
	.q:(GCPDept1'[GCPDept&&(GCPDept'=""))
	.s GCPName1=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",2)
	.q:(GCPName1'[GCPName&&(GCPName'=""))
	
	.s GCPWork=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",3)
	.s GCPTime=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",4)
	.s GCPHours=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",5)
	.s GCPCompany1=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",6)
	.q:(GCPCompany1'[GCPCompany&&(GCPCompany'=""))
	.s GCPLevel=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",7)
	.s GCPMethod1=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",8)
	.q:(GCPMethod1'[GCPMethod&&(GCPMethod'=""))
	.s GCPDate=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",9)
	.s GCPDate1=""
	.s:GCPDate'="" GCPDate1=$zd(GCPDate,3)
	.s:GCPDate'="" GCPDate=$zd(GCPDate,4)
	.s GCPBookLabel=$p($g(^DHCDocPPGCP(PPGCPRowId)),"^",10)
	
	.Do OutputRow3
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
    s ^TmpGCP(USERID,ProcesNo,ind)=PPGCPRowId_"^"_GCPDept1_"^"_GCPName1_"^"_GCPWork_"^"_GCPTime_"^"_GCPHours_"^"_GCPCompany1_"^"_GCPLevel_"^"_GCPMethod1_"^"_GCPDate1_"^"_GCPBookLabel
    s ^TmpGCP(USERID,ProcesNo)=ind
	set Data=$lb(0,PPGCPRowId,GCPDept1,GCPName1,GCPWork,GCPTime,GCPHours,GCPCompany1,GCPLevel,GCPMethod1,GCPDate,GCPBookLabel,ProcesNo)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariable3
	///set (repid)=0
	set (PPGCPRowId,GCPDept1,GCPName1,GCPWork,GCPTime,GCPHours,GCPCompany1,GCPLevel,GCPMethod1,GCPDate,GCPBookLabel,ProcesNo)=""
	quit
}

ClassMethod DeleteGCP(PPGCPRowId As %String) As %String
{
	q:PPGCPRowId="" "1"
	&sql(delete from  DHC_DocPilotProGCP  where PPGCP_RowId=:PPGCPRowId) 
	q SQLCODE
}

ClassMethod GetGCPNum(ProcessNo As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	s num=^TmpGCP(USERID,ProcessNo)
	q num
}

ClassMethod GetGCP(ProcessNo As %String, Num As %String) As %String
{
	s USERID=%session.Get("LOGON.USERID")
	q $g(^TmpGCP(USERID,ProcessNo,Num))
}

Query LookUpProject(QCProjectName As %String = "") As %Query(ROWSPEC = "Name:%String:项目名称,hidden:%String,PlanName:%String:方案名称,ProStartUser:%String:主要研究者,PlanNo:%String:方案编号,PPCode:%String:项目编号") [ SqlProc ]
{
}

ClassMethod LookUpProjectClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpProjectExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpProjectExecute(ByRef QHandle As %Binary, QCProjectName As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProOtherManage","LookUpProject","")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ProRowId=0 f  s ProRowId=$o(^DHCDocPP(ProRowId)) q:ProRowId=""  d
	.s ProStartUserDr=$p($g(^DHCDocPP(ProRowId)),"^",10)
	.S ProStartUser=""
	.if ProStartUserDr'="" s ProStartUser=$p(^SSU("SSUSR",ProStartUserDr),"^",2)
	.s PPCode=$p($g(^DHCDocPP(ProRowId)),"^",1)
	.s PlanNo=$p($g(^DHCDocPP(ProRowId)),"^",26)
	.s Name=$p($g(^DHCDocPP(ProRowId)),"^",2)
	.s PlanName=$p($g(^DHCDocPP(ProRowId)),"^",27)
	.q:((QCProjectName'="")&&(Name'[QCProjectName)&&(PlanName'[QCProjectName)&&(PlanNo'[QCProjectName))
	.s child=""
	.f  s child=$o(^DHCDocPPD(ProRowId,child)) q:child=""  d
	..s User=""
	..s UserDr=$p($g(^DHCDocPPD(ProRowId,child)),"^",2)
	..s:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..s:User'="" ProStartUser=ProStartUser_","_User
	.Do OutputRowPro
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPro
	set Data=$lb(Name,ProRowId,PlanName,ProStartUser,PlanNo,PPCode)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod LookUpProjectFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpProjectExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//w ##class(web.PilotProject.DHCDocPilotProOtherManage).InportGCP()

ClassMethod InportGCP()
{
	//写日志文件
	s myrtn=0
	k ^TmpProjectTrain
	Set file=##class(%File).%New("/temp/stream/GCP1213.txt")
	set ExistsFlag=##class(%File).Exists("/temp/stream/GCP1213.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/stream/GCP1213.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s GCPDept=PatList(1)
		
		s GCPName=PatList(3)
		s GCPWork=PatList(4)
		s GCPTime=PatList(5)
		s GCPHours=PatList(6)
		s GCPCompany=PatList(7)
		s GCPLevel=PatList(8)
		s GCPMethod=PatList(9)
		s GCPDate=PatList(10)
		s GCPBookLabel=PatList(11)
		s GCPDate1=""
		i $l(GCPDate,"/")=3 {
			s GCPDate=$tr(GCPDate,"/","-")
			s GCPDate=$zdh(GCPDate,3)
		}  else{
			s GCPDate1=GCPDate
			s GCPDate=""
		}
		s UObj=##class(User.DHCDocPilotProGCP).%New()
		s UObj.GCPDept=GCPDept
		s UObj.GCPName=GCPName
		s UObj.GCPWork=GCPWork
		s UObj.GCPTime=GCPTime
		s UObj.GCPHours=GCPHours
		s UObj.GCPCompany=GCPCompany
		s UObj.GCPLevel=GCPLevel
		s UObj.GCPMethod=GCPMethod
		s UObj.GCPDate=GCPDate
		s UObj.GCPBookLabel=GCPBookLabel
		s UObj.GCPDate1=GCPDate1
		Set sc = UObj.%Save()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

//w ##class(web.PilotProject.DHCDocPilotProOtherManage).InportTrain()

ClassMethod InportTrain()
{
	//写日志文件
	s myrtn=0
	;k ^TmpProjectTrain
	Set file=##class(%File).%New("/temp/DHCDocPilot/Train.txt")
	set ExistsFlag=##class(%File).Exists("/temp/DHCDocPilot/Train.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/temp/DHCDocPilot/Train.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	TS
	s cou=1
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s cou=cou+1
		;w line
		;w line
		for i=1:1:$l(line,"	") {
			;w !,$l(line,"	")
			Set PatList(i)=$p(line,"	",i)
		}
		;w !,PatList(1)
		s TRASttTime=PatList(1)
		s TRAEndTime=PatList(2)
		s TRADesc=PatList(3)
		s TRAUser=PatList(4)
		s TRAType=PatList(5)
		s TRAPersonNum=PatList(6)
		i $l(TRASttTime,"/")=3 {
			s TRASttTime=$tr(TRASttTime,"/","-")
			s TRASttTime=$zdh(TRASttTime,3)
		}  else{
			s TRASttTime=""
		}
		i $l(TRAEndTime,"/")=3 {
			s TRAEndTime=$tr(TRAEndTime,"/","-")
			s TRAEndTime=$zdh(TRAEndTime,3)
		}  else{
			s TRAEndTime=TRASttTime
		}
		s UObj=##class(User.DHCDocPilotProTrain).%New()
		s UObj.TRADesc=TRADesc
		s UObj.TRAEndTime=TRAEndTime
		s UObj.TRAPersonNum=TRAPersonNum
		s UObj.TRASttTime=TRASttTime
		s UObj.TRAType=TRAType
		s UObj.TRAUser=TRAUser
		
		Set sc = UObj.%Save()
		If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-104"
	}
	d UObj.%Close()
	}
	w !,"导入完成!"
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	
	c file
	Q myrtn
}

}

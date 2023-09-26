/// 名称: DHCMed.CCService.ShowRstSrv
/// 描述: 主题监控和应用主题展现程序
/// 编写者：zhufei
/// 编写日期: 2010-04-30
Class DHCMed.CCService.ShowRstSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-04-30
/// Description:  就诊相关监控（监控记录与就诊相关联）
ClassMethod GetDataByEpisodeID(argEpisodeID As %String) As %List
{
	New (argEpisodeID)
	Set return=""
    Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(argEpisodeID)
    If $IsObject(objPaadm)
    {
	    Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objPaadm.PatientID)
	    Set Data=$lb(objPatient.Papmi)
	    Set Data=Data_$lb(objPatient.PapmiNo)
	    Set Data=Data_$lb(objPatient.InPatientMrNo)
	    Set Data=Data_$lb(objPatient.OutPatientMrNo)
	    Set Data=Data_$lb(objPatient.PatientName)
	    Set Data=Data_$lb(objPatient.Sex)
	    Set Data=Data_$lb(objPatient.Birthday)
	    Set Data=Data_$lb(objPatient.Age)
	    Set Data=Data_$lb(objPatient.PersonalID)
	    Set Data=Data_$lb(objPatient.Address)
	    Set Data=Data_$lb(objPatient.WorkAddress)
	    Set Data=Data_$lb(objPatient.Telephone)
    	Set Data=Data_$lb(objPaadm.AdmRowID)
    	Set Data=Data_$lb(objPaadm.AdmType)
    	Set Data=Data_$lb(objPaadm.AdmitDate)
    	Set Data=Data_$lb(objPaadm.AdmitTime)
    	Set Data=Data_$lb(objPaadm.DisDate)
    	Set Data=Data_$lb(objPaadm.DisTime)
    	Set Data=Data_$lb(objPaadm.Department)
    	Set Data=Data_$lb(objPaadm.Ward)
    	Set Data=Data_$lb(objPaadm.Room)
    	Set Data=Data_$lb(objPaadm.Bed)
    	Set Data=Data_$lb(objPaadm.DoctorName)
    	Set Data=Data_$lb(objPaadm.Status)
    	Set Data=Data_$lb(objPaadm.Days)
    	Set return=Data
	} Else {
		Quit return
	}
	
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-04-30
/// Description:  就诊相关监控（监控记录与就诊相关联）
/// Input：       格式 "&AppCode=InPatient&AAA=1"
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ShowRstSrv","QryToEpisodeID","&AppCode=AA")
Query QryToEpisodeID(argAppCode As %String, argMonitor As %String) As %Query(ROWSPEC = "Papmi:%String,PapmiNo:%String:登记号,InPatientMrNo:%String:住院病案,OutPatientMrNo:%String:门诊病案,PatientName:%String:姓名,Sex:%String:性别,Birthday:%String:出生日期,Age:%String:年龄,PersonalID:%String:身份证号,Address:%String:家庭住址,WorkAddress:%String:工作单位,Telephone:%String:电话,AdmRowID:%String:就诊号,AdmType:%String:就诊类型,AdmitDate:%String:就诊日期,AdmitTime:%String:就诊时间,DisDate:%String:出院日期,DisTime:%String:出院时间,Department:%String:科室,Ward:%String:病区,Room:%String:病房,Bed:%String:床号,DoctorName:%String:医生,Status:%String:就诊状态,Days:%String:住院天数,Result:%String:监测结果")
{
}

ClassMethod QryToEpisodeIDExecute(ByRef qHandle As %Binary, argAppCode As %String, argMonitor As %String) As %Status
{
	Set repidz=$I(^CacheTemp)
	Set indz=1
	Set qHandle=$lb(0,repidz,0)
	
	//Set $ZT="QryToEpisodeIDErr"
	Set Jindzex=$j
	
	Set objApp=##class(DHCMed.CC.SubjectApp).GetObjByCode(argAppCode)
	Quit:objApp="" $$$OK
	Set SubDicID=objApp.SASubjectDr
	Set ShowScore=objApp.SAShowScore
	Set ShowDicID=objApp.SAShowDr
	Set objSubDic=##class(DHCMed.CC.SubjectDic).GetObjById(SubDicID)
	Quit:objSubDic="" $$$OK
	Set ClassName=$p(objSubDic.SDMethodName,":",1)
	Set QueryName=$p(objSubDic.SDMethodName,":",2)
	Quit:(ClassName="")||(QueryName="") $$$OK
	
	//格式化入参
	Kill ^TMP(Jindzex,argAppCode,"ARG")
	Set separete="&"
	Set:$g(separete)="" separete=..#SEPARATE
	Set ^TMP(Jindzex,argAppCode,"ARG","aAppCode")=argAppCode
	For aindzex=1:1:$l(argMonitor,separete) {
		Set aMonitorSub=$p(argMonitor,separete,aindzex)
		Set aName=$p(aMonitorSub,"=",1)
		Set aValue=$p(aMonitorSub,"=",2)
		If (aName="")||(aValue="") Continue
		Set ^TMP(Jindzex,argAppCode,"ARG",aName)=aValue
	}
	Set Arguments=""
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	For qryindz=1:1:cdef.Queries.Count()
 	{
	 	If (cdef.Queries.GetAt(qryindz).Name=QueryName)
	 	{
		 	Set FormalSpecs=cdef.Queries.GetAt(qryindz).FormalSpec
		 	For argindz=1:1:$l(FormalSpecs,",")
		 	{
			 	Set FormalSpec=$p(FormalSpecs,",",argindz)
			 	Set FormalSpec=$p(FormalSpec,":",1)
			 	Continue:FormalSpec=""
			 	Set Argument=$g(^TMP(Jindzex,argAppCode,"ARG",FormalSpec))
			 	Set Arguments=Arguments_","_""""_Argument_""""
			}
			Set:Arguments'="" Arguments=$e(Arguments,2,$l(Arguments))
		}
	}
 	Do cdef.%Close()
	
	//执行监控方法
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName=ClassName
	Set rset.QueryName=QueryName
	Set execute="Set sc=rset.Execute("_Arguments_")"
	Xecute execute
	While (rset.Next(.sc))
	{
		If ($SYSTEM.Status.IsOK(sc))
		{
		    Set EpisodeID=rset.Data("EpisodeID")
		    Set Result=rset.Data("Result")
		    Set Data=..GetDataByEpisodeID(EpisodeID)
			Continue:Data=""
			Set Data=Data_$lb(Result)
			Set ^CacheTemp(repidz,indz)=Data
			Set indz=indz+1
		}Else{
		    Quit
		}
	}
	If $system.Status.IsError(sc) Do $system.OBJ.DisplayError(sc)
	
	Kill ^TMP(Jindzex,argAppCode,"ARG")
	Quit $$$OK
	
QryToEpisodeIDErr
	Kill ^TMP(Jindzex,argAppCode,"ARG")
	Quit $$$OK
}

ClassMethod QryToEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryToEpisodeIDExecute ]
{
	Set repidz=$LIST(qHandle,2)
 	;Kill ^CacheTemp(repidz)
 	Quit $$$OK
}

ClassMethod QryToEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryToEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repidz=$LIST(qHandle,2)
 	Set indz=$LIST(qHandle,3)
 	Set indz=$o(^CacheTemp(repidz,indz))
 	If indz="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidz,indz)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repidz,indz)
	Quit $$$OK
}

}

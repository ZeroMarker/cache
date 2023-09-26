/// 当前科室在院患者明细
Class DtPortal.DD.DD01EmphasisFocus.DD0104InPat Extends %RegisteredObject
{

/// Creator：     chengpeng
/// CreatDate：   2015-12-17
/// Description:  DD01.04.01 查询科室在院患者
/// Input：       UserCode    :  用户工号
/// Input：       DocID   	  :  按照主管医生筛选
/// Return：      在院患者信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0104InPat","DD010401","601","")
Query DD010401(UserCode As %String, locGroupID As %String, DocID As %String = "") As DtPortal.Query(ROWSPEC = "BedNum:%String,Name:%String,Sex:%String,Age:%String,CareLevel:%String,MedicareNo:%String,InTime:%String,InDay:%String,EpisodeID:%String,AdmDocID:%String,DocLoc:%String,ManagerDoc:%String,DiagnoseDesc:%String,VitalSign:%String,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID")
{
}

ClassMethod DD010401Execute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String, DocID As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)
	
	set DocCode="",UserID=""
	
	for locIndex=1:1:$l(DocLocStr,"^")
	{
	set loc=$p(DocLocStr,"^",locIndex) 
	continue:loc="" 
	set PaadmStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc","",loc)  //(科室类型，userID，locID)
	set length=$l(PaadmStr,"^")
	
	for index=1:1:length
	{
		set EpisodeID=$p(PaadmStr,"^",index)
		Continue:EpisodeID=""
		set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		set name=$p(PatInfo,"^",2)											//姓名
		set sex=$p(PatInfo,"^",3)											//性别
		set age=$p(PatInfo,"^",4)											//年龄
		set medicareNo=$p(PatInfo,"^",5)									//病案号
		set admReason=$p(PatInfo,"^",6)										//费用类别
		set bedNum=$p(PatInfo,"^",1)										//床号
		;if bedNum="" continue
		
		set aAdmDocID=""
 		set aCPDocID=$p(^PAADM(+EpisodeID),"^",9)
 		//continue:aCPDocID=""   //没有主管医生退出
		set:aCPDocID'="" aAdmDocID=$O(^SSU("SSUSR",0,"CTPCP",aCPDocID,""),-1)
		set:aAdmDocID'="" aname=$p(^SSU("SSUSR",aAdmDocID),"^",2)
		
		continue:(DocID'="")&&(DocID'=aAdmDocID)
		//w !,aCPDocID_"^"_aAdmDocID
		set (InTime,InDay)="" 
		set TRANSId=$o(^PAADM(EpisodeID,"TRANS",0)) 
		if TRANSId'=""
		{
			set InTime=$p($g(^PAADM(EpisodeID,"TRANS",TRANSId)),"^",2)
			set InDate=$p($g(^PAADM(EpisodeID,"TRANS",TRANSId)),"^",1)
			set:InDate'="" InDate=$zd(InDate,3)
			set:InTime'="" InTime=$zt(InTime,2)
			s InTime=InDate_"&nbsp;"_InTime   //加空格，用于前台显示	//入院时间
		}
		Set CPDocID=$p($g(^PAADM(EpisodeID)),"^",9)     //主管医生
		;continue:CPDocID=""
		set ManagerDoc=""
		if CPDocID'="" {
			set UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			set ManagerDoc=$p(^SSU("SSUSR",UserID),"^",2)
		}
		
		Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		continue:'$IsObject(AdmObj)
		
		set PatientID=AdmObj.PatientID
		set CPDocID=AdmObj.DoctorID
		set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
		
		set InDay=AdmObj.Days
		
		//护理级别
		set CareLevel=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeID,ArcIDsNur)
		
		//生命体征
		set VitalSign=""
		Set VitalSignStr=##class(DtPortal.Common.PaadmService).GetVitalSignByAdm(EpisodeID)
		if VitalSignStr'="" s VitalSign="T:"_$p(VitalSignStr,"^",1)_"℃ ,"_"P:"_$p(VitalSignStr,"^",2)_"次/分 ,"_"R:"_$p(VitalSignStr,"^",3)_"次/分 ,"_"BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)	
				
		//诊断
		set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetAdmDiagnosis(EpisodeID)
		
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EMREpisodeID=$p(EMRinfo,"^",5)
		
		Set Data=$lb(bedNum,name,sex,age,CareLevel,medicareNo,InTime,InDay,EpisodeID,AdmDocID,DocLoc,ManagerDoc,DiagnoseDesc,VitalSign,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	}
	Quit $$$OK
}

/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0104InPat","DD010402","ys01","I*95||O*6")
Query DD010402(UserCode As %String, locGroupID As %String, DocID As %String = "") As DtPortal.Query(ROWSPEC = "DocID:%String,Name:%String,value:%String")
{
}

ClassMethod DD010402Execute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String, DocID As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	k ^TempPortalDD010402
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	set all=0
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)
	
	set DocCode="",UserID=""
	
	for locIndex=1:1:$l(DocLocStr,"^")
	{
	set loc=$p(DocLocStr,"^",locIndex) 
	continue:loc="" 
	set PaadmStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc","",loc)  //(科室类型，userID，locID)
	set length=$l(PaadmStr,"^")
	
	for index=1:1:length
	{
		set EpisodeID=$p(PaadmStr,"^",index)
		Continue:EpisodeID=""
		set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
				
		set aAdmDocID=""
 		set aCPDocID=$p(^PAADM(+EpisodeID),"^",9)
 		
		set:aCPDocID'="" aAdmDocID=$O(^SSU("SSUSR",0,"CTPCP",aCPDocID,""),-1)
		set:aAdmDocID'="" aname=$p(^SSU("SSUSR",aAdmDocID),"^",2)
		
		continue:(DocID'="")&&(DocID'=aAdmDocID)
		
		
		Set CPDocID=$p($g(^PAADM(EpisodeID)),"^",9)     //主管医生
		
		set ManagerDoc=""
		if CPDocID'="" {
			set UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			set ManagerDoc=$p(^SSU("SSUSR",UserID),"^",2)
		}
		
		Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		continue:'$IsObject(AdmObj)
		
		set PatientID=AdmObj.PatientID
		set CPDocID=AdmObj.DoctorID
		set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
		set all=all+1
		continue:AdmDocID=""
	
		set ^TempPortalDD010402(AdmDocID)=$g(^TempPortalDD010402(AdmDocID))+1
	    set ^TempPortalDD010402(AdmDocID,"name")=ManagerDoc
	
	}
	}
	
	Set Data=$lb("","全部",all)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1	
	
	set CPDocID=""
	for{
		set CPDocID=$o(^TempPortalDD010402(CPDocID))	
		q:CPDocID=""
		
		set name=$g(^TempPortalDD010402(CPDocID,"name"))
		set value=+$g(^TempPortalDD010402(CPDocID))
		
		Set Data=$lb(CPDocID,name,value)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	
	Quit $$$OK
}

}

/// 未提交病历
Class DtPortal.DD.DD01EmphasisFocus.DD0105UnSubmitMedical Extends %RegisteredObject
{

/// Creator：     bmz
/// CreatDate：   2019-2-13
/// Description:  DD01.05.01 未提交病历
/// Input：       UserCode    :  用户工号
/// Input：       locGroupID   	  :  
/// Return：      在院患者信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0105UnSubmitMedical","DD010501","601","")
Query DD010501(UserCode As %String = "", locGroupID As %String = "") As DtPortal.Query(ROWSPEC = "regNo:%String,medicareNo:%String,name:%String,patLoc:%String,InTime:%String,outTime:%String,DocDes:%String,ManagerDoc,EpisodeID,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID") [ SqlProc ]
{
}

ClassMethod DD010501Execute(ByRef qHandle As %Binary, UserCode As %String = "", locGroupID As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	
	s days=##Class(DtPortal.Common.PublicService).getValueByCode("UNSUBMITDAYS")
	
	s startdate=(+$h)-days
	s enddate=+$h
	f date=startdate:1:enddate d
	.s PAAdm=""
	.f  s PAAdm=$o(^PAADMi("EstDisch",date,PAAdm)) q:PAAdm=""  d
	..s loc=$p(^PAADM(PAAdm),"^",4)
	..q:'$LF($LISTFROMSTRING(DocLocStr,"^"),loc)
	..s FistPageFlag=##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(PAAdm)
	..q:FistPageFlag="1"   //判断病案首页数据是否提交
	..d patinfo

	Quit $$$OK
patinfo
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	s regNo=$p(patInfoStr,"^",7)    //登记号
	s medicareNo=$p(patInfoStr,"^",5)   //病案号
	s name=$p(patInfoStr,"^",2)		//姓名
	s patLoc=$P($g(^CTLOC(loc)),"^",2) //就诊科室
	i patLoc["-" s patLoc=$p(patLoc,"-",2)  //就诊科室
	
	s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(PAAdm)
	s InDate=$p(inDateTimeStr,"^",1)
	s InTime=$p(inDateTimeStr,"^",2)
	i InDate'="" s InDate=$zd(InDate,3)
	i InTime'="" s InTime=$zt(InTime,2)
	s InTime=InDate_"&nbsp;"_InTime  //入院时间
	
	s outDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(PAAdm)
	s outDate=$p(outDateTimeStr,"^",1)
	s outTime=$p(outDateTimeStr,"^",2)
	i outDate'="" s outDate=$zd(outDate,3)
	i outTime'="" s outTime=$zt(outTime,2)
	s outTime=outDate_"&nbsp;"_outTime //出院时间
	
	s DocDes=""
	s admDocDR=$P($g(^PAADM(PAAdm)),"^",9)
	i admDocDR'="" s DocDes=$p(^CTPCP(admDocDR,1),"^",2)   //管床医师
	s EpisodeID=PAAdm
	set CPDocID=$p(^PAADM(+EpisodeID),"^",9)
	set UserID=""
	set ManagerDoc=""
	if CPDocID'="" {
		set UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
		if (UserID'="") {
			set ManagerDoc=$p(^SSU("SSUSR",UserID),"^",2)
		}
	}
	//获取打开电子病历所需要的参数
	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
	set EMRDocID=$p(EMRinfo,"^",1)
	set EMRInstanceID=$p(EMRinfo,"^",2)
	set locID=$p(EMRinfo,"^",3)
	set PatientID=$p(EMRinfo,"^",4)
	set EMREpisodeID=$p(EMRinfo,"^",5)
	
	s Data=$lb(regNo,medicareNo,name,patLoc,InTime,outTime,DocDes,ManagerDoc,EpisodeID,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}

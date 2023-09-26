/// Creator：     jiangpengpeng
/// CreatDate：   2014-2-25
/// Description:  处理历史数据
Class DHCMed.NINFService.Srv.ProcessHisDate Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 取就诊科室和病区（入参：就诊号+日期+时间）
/// w ##class(DHCMed.NINFService.Srv.ProcessHisDate).GetTransLoc(9,+$h,$p($h,",",2))
ClassMethod GetTransLoc(aEpisodeID As %String, aActDate As %String, aActTime As %String)
{
	new (aEpisodeID,aActDate,aActTime)
	set return=""
	quit:(aEpisodeID="")||(aActDate="")||(aActTime="") return
	
	set:aActDate["-" aActDate=$zdh(aActDate,3)
	set:aActTime[":" aActTime=$zth(aActTime,1)
	set:aActDate'="" aActTime=+aActTime
	
	//set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
	//set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	if (AdmDate>aActDate)||((AdmDate=aActDate)&&(AdmTime>aActTime)) {
		set aActDate=AdmDate
		set aActTime=AdmTime
	}
	
	set LocID="",LocDesc="",TransID=""
	set xTransID=""
	for {
		set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		quit:xTransID=""
		quit:TransID'=""
		
		set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		continue:tmpTrans=""
		
		set TransDate=$p(tmpTrans,"^",1)
		set TransTime=$p(tmpTrans,"^",2)
		quit:(TransDate>aActDate)
		quit:(TransDate=aActDate)&&(TransTime>aActTime)
		
		set TransLoc=$p(tmpTrans,"^",6)
		if TransLoc'="" {
			set LocID=TransLoc
			Set TransID=aEpisodeID_"||"_xTransID
		}
	}
	
	set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	set LocDesc=$tr(LocDesc,",","")
	
	set return=TransID_","_LocID_","_LocDesc
	quit return
}

/// d ##class(DHCMed.NINFService.Srv.ProcessHisDate).ProcOldRepData()
ClassMethod ProcOldRepData()
{
	new
	set return=0
	set xRepID=0
	for {
		set xRepID=$o(^DHCMed.NINF("InfRep",xRepID))
		quit:xRepID=""
		
		Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		set EpisodeID=objReport.EpisodeID
		
		set InfDate=""
		set xSubID=0
		for {
			set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"InfPos",xSubID))
			quit:xSubID=""
			quit:InfDate'=""
			
			Set objSub=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xRepID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			
			Set tmpDate=objSub.InfDate
			continue:tmpDate=""
			set InfDate=tmpDate
		}
		
		set ActDate=InfDate
		set ActTime=$zth("00:00:00",1)
		set tmpInfo=..GetTransLoc(EpisodeID,ActDate,ActTime)
		continue:tmpInfo=""
		
		set TransID=$p(tmpInfo,",",1)
		set TransLoc=$p(tmpInfo,",",2)
		
		set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"Summ",""),-1)
		set objSumm=##Class(DHCMed.NINF.Rep.InfReportSumm).%OpenId(xRepID_"||"_xSubID)
		continue:'$IsObject(objSumm)
		
		set objSumm.TransID = TransID
		set objSumm.TransLoc = TransLoc
		
		Set sc=objSumm.%Save()
		If $System.Status.IsError(sc) {  //检查Save是否成功
   			Do $System.OBJ.DisplayError(sc)
   			Set return=-1
		} Else {
			Set return=objSumm.%Id()
		}
		Do objSumm.%Close()
	}
 Quit return
}

Storage Default
{
<Data name="ProcessHisDateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFS42F.ProcessHisDateD</DataLocation>
<DefaultData>ProcessHisDateDefaultData</DefaultData>
<IdLocation>^DHCMed.NINFS42F.ProcessHisDateD</IdLocation>
<IndexLocation>^DHCMed.NINFS42F.ProcessHisDateI</IndexLocation>
<StreamLocation>^DHCMed.NINFS42F.ProcessHisDateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

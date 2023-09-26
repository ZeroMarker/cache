/// 名称： EPRservice.BLL.Consultation.BLConsultationData
/// 描述:  根据EpisodeID或者PatientID,查询患者的会诊信息
/// 创建者：牛才才
/// 创建时间：2014-11-21
Class EPRservice.BLL.Consultation.BLConsultationData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.Consultation.BLConsultationData","GetConsultationData","41","5","1","4","1")
Query GetConsultationData(AEpisodeID As %String, APatientID As %String, ArgStartNum As %String, ArgEndNum As %String, ArgQueryType As %String) As %Query(ROWSPEC = "ConsultDep:%String,ConsultDoc:%String,Attitude:%String,AppDep:%String,AppDoc:%String,AppDate:%String,AppTime:%String,ConsultDate:%String,ConsultTime:%String,ConDestination:%String")
{
}

ClassMethod GetConsultationDataExecute(ByRef qHandle As %Binary, AEpisodeID As %String, APatientID As %String, ArgStartNum As %String, ArgEndNum As %String, ArgQueryType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s count = 1
	
	if (ArgQueryType = "1")
	{
		s EpisodeID = AEpisodeID
		d GetDataByEpisodeID
	}
	else
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(APatientID,"ADM","I",EpisodeID))
			q:(EpisodeID="")
			d GetDataByEpisodeID
		}
		
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(APatientID,"ADM","O",EpisodeID))
			q:(EpisodeID="")
			d GetDataByEpisodeID
		}
	}
	Quit $$$OK
GetDataByEpisodeID
	
	
	s episodeDate = $ZD($p($g(^PAADM(EpisodeID)),"^",6),3)	 	
	s deptId=$p(^PAADM(EpisodeID),"^",4)
	if (deptId'="")
	{
		set episodeDept=$p(^CTLOC(deptId),"^",2)
	}
	else
	{
		set episodeDept=""
	}
	if ($f(episodeDept,"-")'=0)
	{
		s episodeDept = $p(episodeDept,"-",2)
	}
	
	//##Class(web.DHCConsult).GetConDestination(EpisodeID)是护理组提供的接口，项目上有此接口方法方可使用会诊信息引用功能；
	s a = ##Class(web.DHCConsult).GetConDestination(EpisodeID)
	s subStr = ""
	for {
		s subStr = a.ReadLine()
		q:(subStr = "")
		
		if (count >= ArgStartNum) && (count <= ArgEndNum)
		{
		
			s Attitude = $p(subStr,$c(3),1)       //会诊意见
			s ConsultDepDR = $p(subStr,$c(3),2)     //会诊科室
			s ConsultDep = $p($g(^CTLOC(ConsultDepDR)),"^",2)
			s ConsultDoc = $p(subStr,$c(3),3)     //会诊医生
		
			//以下内容留作备用
			s AppDep = ""
			s AppDoc = ""	
			s AppDate = ""	
			s AppTime = ""	
			s ConsultDate = ""
			s ConsultTime = ""
			s ConDestination = ""
		
			set ^CacheTemp(repid,ind) = $LB(ConsultDep,ConsultDoc,Attitude,AppDep,AppDoc,AppDate,AppTime,ConsultDate,ConsultTime,ConDestination)
			set ind = ind + 1
		}
		s count = count + 1
	}
	
	Quit $$$OK
}

ClassMethod GetConsultationDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsultationDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetConsultationDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsultationDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{			
 		Set Row=^CacheTemp(repid,ind)
 	}

 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

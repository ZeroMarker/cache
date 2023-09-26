/// 获取门诊病历分配表的数据
/// d ##class(%ResultSet).RunQuery("EPRservice.Quality.GetSpotCheckOutPatInfo","GetOutPatAssignInfo",9)
Class EPRservice.Quality.GetSpotCheckOutPatInfo Extends %RegisteredObject
{

Query GetOutPatAssignInfo(UserID As %String, QualityFlag As %String = "") As %Query(ROWSPEC = "AssignName,MedName,PAPMIName,EpisodeID,CheckedFlag,PAPMISex,Age,MainDiagnos,FinishRecord")
{
}

ClassMethod GetOutPatAssignInfoExecute(ByRef qHandle As %Binary, UserID As %String, QualityFlag As %String = "") As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	k ^CacheTemp("EPRQuality","AssignInfo")
	
	s rowId=""
	for
	{
		s rowId=$o(^DHCEPRQ.OutPatAssignInfoI("IdxMedDoctorID"," "_UserID,rowId))
		q:(rowId="")
		s OBJAssignInfo=##class(EPRinstance.Quality.OutPatAssignInfo).%OpenId(rowId)
		q:(OBJAssignInfo="")
		s AssignDoc=OBJAssignInfo.AssignUserID
		s EpisodeID=OBJAssignInfo.EpisodeID
		s MedDoc=OBJAssignInfo.MedDoctorID
		
		s mCurrRow = $g(^PAADM(EpisodeID))
		
		s PAPMIDR = $p($g(mCurrRow),"^",1)   //登记号  患者基本信息表rowid
		continue:(PAPMIDR="")
		s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		
		s MedUser = $g(^SSU("SSUSR",MedDoc))
		s MedName = $p(MedUser,"^",2)
		
		s AssignUser = $g(^SSU("SSUSR",AssignDoc))
		s AssignName = $p(AssignUser,"^",2)
		
		//s AdmDate=$P(mCurrRow,"^",6)
		//s AdmTime=$P(mCurrRow,"^",7)
		
		s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
		s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)  //性别
		
		//主要诊断
		s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(EpisodeID)
		if (MainDiagnos = "")
	    {
	        s MainDiagnos = ##class(EMRservice.Ajax.patientInfo).getOPdiagnosis(EpisodeID)
	        //s MainDiagnos = $P(MainDiagnos,"^",3)
	    }
		if (MainDiagnos '= "")
		{	
			s MainDiagnos = $P(MainDiagnos,"^",3)
			s MainDiagnos = $tr(MainDiagnos,"'","\'")
		}
		
		;s FinishRecord=##Class(EPRservice.RQ.FinishStuAboutMJZBLNew).GetRecordInfo(EpisodeID)  //是否有病历
		;s:(FinishRecord'="") FinishRecord="是"
		;s:(FinishRecord="") FinishRecord="否"
		
		s Age  = ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(PAPMIDR,EpisodeID,"","")
		
		//是否质控
		s CheckedFlag=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeOutManualFlag(EpisodeID)
		
		continue:(QualityFlag'="")&&(CheckedFlag'=QualityFlag)
		if CheckedFlag="N"
		{
			s CheckedFlag="否"	
		}else
		{
			s CheckedFlag="是"	
		}
		
		
		
		s Data=$lb(AssignName,MedName,PAPMIName,EpisodeID,CheckedFlag,PAPMISex,Age,MainDiagnos,FinishRecord)
		
		s ^CacheTemp(repid,ind)=Data
		
		s ind=ind+1
		
	}
	
	Quit $$$OK
}

ClassMethod GetOutPatAssignInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutPatAssignInfoExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOutPatAssignInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutPatAssignInfoExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过分配日期段查询分配历史数据
/// d ##class(%ResultSet).RunQuery("EPRservice.Quality.GetSpotCheckOutPatInfo","GetOutPatAssignInfoByDateGap"," 2019-02-01---2019-02-02")
Query GetOutPatAssignInfoByDateGap(DateGap As %String) As %Query(ROWSPEC = "PAADMRowID,AssignName,MedName,PAPMIName,PAPMISex,MainDiagnos,DateGap,CheckedFlag")
{
}

ClassMethod GetOutPatAssignInfoByDateGapExecute(ByRef qHandle As %Binary, DateGap As %String) As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	k ^CacheTemp("EPRQuality","AssignInfo")
	
	s rowId=""
	for
	{
		s rowId=$o(^DHCEPRQ.OutPatAssignInfoI("IdxDateGap",DateGap,rowId))
		q:(rowId="")
		
		s OBJAssignInfo=##class(EPRinstance.Quality.OutPatAssignInfo).%OpenId(rowId)
		s PAADMRowID=OBJAssignInfo.EpisodeID
		q:(PAADMRowID="")
		
		s mCurrRow = $g(^PAADM(PAADMRowID))
		s PAPMIDR = $p($g(mCurrRow),"^",1)   //登记号  患者基本信息表rowid
		s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		
		s MedDoc=OBJAssignInfo.MedDoctorID
		s MedUser = $g(^SSU("SSUSR",MedDoc))
		s MedName = $p(MedUser,"^",2)
		
		s AssignDoc=OBJAssignInfo.AssignUserID
		s AssignUser = $g(^SSU("SSUSR",AssignDoc))
		s AssignName = $p(AssignUser,"^",2)
		
		s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
		s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)  //性别
		
		s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
		s:(MainDiagnos'="") MainDiagnos=$p(MainDiagnos,"^",3)
		//是否质控
		s CheckedFlag=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeOutManualFlag(PAADMRowID)
		if CheckedFlag="N"
		{
			s CheckedFlag="否"	
		}else
		{
			s CheckedFlag="是"	
		}
		
		s Data=$lb(PAADMRowID,AssignName,MedName,PAPMIName,PAPMISex,MainDiagnos,DateGap,CheckedFlag)
		
		s ^CacheTemp(repid,ind)=Data
		
		s ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetOutPatAssignInfoByDateGapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutPatAssignInfoByDateGapExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOutPatAssignInfoByDateGapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutPatAssignInfoByDateGapExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取分配日期段
/// W ##class(EPRservice.Quality.GetSpotCheckOutPatInfo).GetAllDateGap()
ClassMethod GetAllDateGap() As %String
{
	s DateGap="",Result=""
	for
	{
		s DateGap=$o(^DHCEPRQ.OutPatAssignInfoI("IdxDateGap",DateGap))
		q:(DateGap="")
		s Result=Result_DateGap_"/"
	}
	s Result=$e(Result,1,*-1)
	
	q Result
}

}

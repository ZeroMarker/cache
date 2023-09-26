Class DHCEWELL.DCHEPRInterfaceLDYY Extends (%RegisteredObject, %XML.Adaptor)
{

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","AdrHisEmrCourse","2015-12-05","2015-12-05")
/// 兰大一院病程记录
Query AdrHisEmrCourse(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "courseid,patientid,doctorid,doctor,recordtime,item,emrcontent,patientstatus,datein,patientid1,patientid2,patientid3,courseid1,courseid2,courseid3") [ SqlName = adr_his_emr_course, SqlProc ]
{
}

ClassMethod AdrHisEmrCourseExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	/*
	courseid	病程记录ID
	patientid	病人ID
	doctorid	查房医生工号
	doctor	查房医生
	recordtime	查房时间
	item	项目
	emrcontent	病程内容
	patientstatus	在院状态
	datein	入院日期
	patientid1	病人ID1
	patientid2	病人ID2
	patientid3	病人ID3
	courseid1	病程记录ID1
	courseid2	病程记录ID2
	courseid3	病程记录ID3
	*/
	
	s (courseid,patientid,doctorid,doctor,recordtime,item,emrcontent,patientstatus,datein,patientid1,patientid2,patientid3,courseid1,courseid2,courseid3)=""
	
	s YLJGDM="49361024400" 
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s tmpEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
			s tmpEpisodeID=""
			for{
				;s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
				;s tmpEpisodeID= $o(^PAADMi("IndexAdmDateTime",tmpdate,temTime,tmpEpisodeID))
				s tmpEpisodeID= $o(^PAADMi("AdmDateCurr",tmpdate,tmpEpisodeID))
				q:(tmpEpisodeID = "")
				s argPapmiDR=$p(^PAADM(tmpEpisodeID),"^",1)
				s episodeDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(tmpEpisodeID)
				s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
				s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
				s strECRowID = ""
				s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",tmpEpisodeID,"985",strECRowID))
				continue:(strECRowID = "")
				s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
    			continue:(objECRecord = "")
				Set key = ""
				do
				{ 
			    	S objInstanceData = objECRecord.Instances.GetNext(.key)
				    if (objInstanceData '= "")
			     	{ 
						continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
		     	  		//病程记录ID	
						s courseid = strECRowID_"||"_key
						s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(tmpEpisodeID,"HDSD00.14.01",courseid)
						//病人ID	
						s patientid = tmpEpisodeID
						//查房医生工号	
						s doctorid = objInstanceData.CreateUser
						s doctor = $p($g(^SSU("SSUSR",doctorid)),"^",2)
						//s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",doctorid,""))
						//if (SSUSRRowId'="") 
						//{
							//查房医生	
							//s doctor  = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)
						//}
						//查房时间	
						s recordtime = arr.GetAt("HDSD00.14.046")
						//项目	
						s item = objInstanceData.Title
						//病程内容	
						s emrcontent = arr.GetAt("HDSD00.14.137")
						s disDate = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDatePriv(tmpEpisodeID)
						if (disDate'="")
						{
							//在院状态	
							s patientstatus = "2"
						}
						else
						{
							//在院状态	
							s patientstatus = "1"
						}
						//入院日期	
						s datein = 	$zd($p(episodeDateTime,",",1),3)_" "_$zt($p(episodeDateTime,",",2))
						//病人ID1	
						s patientid1 = ""
						//病人ID2	
						s patientid2 = ""
						//病人ID3	
						s patientid3 = ""
						//病程记录ID1	
						s courseid1 = ""
						//病程记录ID2	
						s courseid2 =""
						//病程记录ID3	
						s courseid3 = ""
						set ^CacheTemp(repid, ind) = $LB(courseid,patientid,doctorid,doctor,recordtime,item,emrcontent,patientstatus,datein,patientid1,patientid2,patientid3,courseid1,courseid2,courseid3)
						set ind = ind + 1
				  	} 
				} 
				while (key '="" )
				s strECRowID = ""
				s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",tmpEpisodeID,"66",strECRowID))
				q:(strECRowID = "")
				s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
				Set key = ""
				do
				{ 
			    	S objInstanceData = objECRecord.Instances.GetNext(.key)
				    if (objInstanceData '= "")
			     	{ 
						continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
		     	  		//病程记录ID	
						s courseid = strECRowID _"||"_key
						s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(tmpEpisodeID,"HDSD00.14.02",courseid)
						//病人ID	
						s patientid = tmpEpisodeID
						//查房医生工号	
						s doctorid = objInstanceData.CreateUser
						s doctor = $p($g(^SSU("SSUSR",doctorid)),"^",2)
						//s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",doctorid,""))
						//if (SSUSRRowId'="") 
						//{
							//查房医生	
							//s doctor  = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)
						//}
						//查房时间	
						s recordtime = arr.GetAt("HDSD00.14.030")
						//项目	
						s item = objInstanceData.Title
						//病程内容	
						s emrcontent = arr.GetAt("HDSD00.14.139")
						s disDate = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDatePriv(tmpEpisodeID)
						if (disDate'="")
						{
							//在院状态	
							s patientstatus = "2"
						}
						else
						{
							//在院状态	
							s patientstatus = "1"
						}
						//入院日期	
						s datein = 	$zd($p(episodeDateTime,",",1),3)_" "_$zt($p(episodeDateTime,",",2))
						//病人ID1	
						s patientid1 = ""
						//病人ID2	
						s patientid2 = ""
						//病人ID3	
						s patientid3 = ""
						//病程记录ID1	
						s courseid1 = ""
						//病程记录ID2	
						s courseid2 =""
						//病程记录ID3	
						s courseid3 = ""
						set ^CacheTemp(repid, ind) = $LB(courseid,patientid,doctorid,doctor,recordtime,item,emrcontent,patientstatus,datein,patientid1,patientid2,patientid3,courseid1,courseid2,courseid3)
						set ind = ind + 1
				  	} 
				} 
				while (key '="" )
		}
	}
	Quit $$$OK
}

ClassMethod AdrHisEmrCourseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdrHisEmrCourseExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod AdrHisEmrCourseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdrHisEmrCourseExecute ]
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

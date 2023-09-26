Class EPRservice.BLL.BLOneStepPrintRecord Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// debug: do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLOneStepPrintRecord","GetPrintRecord","","","1","20")
Query GetPrintRecord(APatientID As %String, APatientName As %String, AStart As %String, ALimit As %String) As %Query(ROWSPEC = "PatientName:%String,UserID:%String,UserCTLocID:%String,EpisodeID:%String,PatientID:%String,PrintTempName:%String,FinishDate:%String,FinishTime:%String")
{
}

ClassMethod GetPrintRecordExecute(ByRef qHandle As %Binary, APatientID As %String, APatientName As %String, AStart As %String, ALimit As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s count = 0

 	s FinishDate = ""
 	for {
		s FinishDate =  $o(^DHCEPRI.OneStepPrintRecordI("IdxFinishDateTimeAndUserID", FinishDate),-1)
		q:(FinishDate = "")
		s FinishTime = ""

		for {
			s FinishTime =  $o(^DHCEPRI.OneStepPrintRecordI("IdxFinishDateTimeAndUserID", FinishDate, FinishTime),-1)
			q:(FinishTime = "")
			s UserID = ""

			for {
				s UserID =  $o(^DHCEPRI.OneStepPrintRecordI("IdxFinishDateTimeAndUserID", FinishDate, FinishTime, " "_UserID))
				s UserID = $tr(UserID, " ")
				q:(UserID = "")	
				s rowID = ""

				for {
					s rowID =  $o(^DHCEPRI.OneStepPrintRecordI("IdxFinishDateTimeAndUserID", FinishDate, FinishTime, " "_UserID, rowID))
					q:(rowID = "")

					s log = ##class(EPRinstance.OneStepPrintRecord).%OpenId(rowID)
					continue:(log="")
					//判断病人号是否符合查询条件
					s patientID = log.PatientID
					if (APatientID '= "")
					{
						continue:(patientID '= APatientID)
					}
					//判断患者姓名是否符合查询条件
					s patientName = log.PatientName
					if (APatientName '= "")
					{
						continue:(patientName '= APatientName)
					}
					
					s count = count + 1
					continue:(count <= AStart)  
					q:(count > (AStart + ALimit))
					
					s categoryID = log.CategoryID
					s userID = log.UserID
					s userCTLocID = log.UserCTLocID
					s episodeID = log.EpisodeID
					s printDocID = log.PrintDocID
					s printTempName = ..GetEPRTemplateCategoryDesc(printDocID)
					s finishDate = log.FinishDate
					s finishTime = log.FinishTime
					
					s output = $LB(patientName,userID,userCTLocID,episodeID,patientID,printTempName,finishDate,finishTime)
					s ^CacheTemp(repid, ind) = output
					s ind = ind + 1
				}
				q:(count > (AStart + ALimit))			
			}
			q:(count > (AStart + ALimit))
		}
		q:(count > (AStart + ALimit))
 	}	

	Quit $$$OK
}

ClassMethod GetPrintRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	07病历文书下的模板目录的文字描述
/// Input：	ACategoryChapterDocID - 模板目录ID	
/// Output: OutputDesc - 模板目录的文字描述
ClassMethod GetEPRTemplateCategoryDesc(ACategoryChapterDocID As %String) As %String
{
	//新版电子病历类似CD_1_50_52!CD_5_57_58
	s flag = $l(ACategoryChapterDocID,"_")
	if (flag > 1)
	{
		//新版电子病历
		s OutputDesc = ""
		for index=1:1:$l(ACategoryChapterDocID,"!")
		{
			/*
			s oneCCID = $p($p(ACategoryChapterDocID,"!",index),"_",3)
			s oneCCDesc = ##class(EMRservice.HISInterface.CentralizedPrint).GetTemplateCategoryDesc(ccID)
			if (OutputDesc = "")
			{
				s OutputDesc = oneCCDesc
			}
			else
			{
				s OutputDesc = OutputDesc" "_oneCCDesc
			}
			*/
			s AItem = $p(ACategoryChapterDocID,"!",index)
			s cgID = $p(AItem,"_",2)
			s ccID = $p(AItem,"_",3)
			s docID = $p(AItem,"_",4)
			s cgDesc = ##class(EMRservice.HISInterface.CentralizedPrint).GetTemplateCategoryDesc(cgID)	
			s ccDesc = ##class(EMRservice.HISInterface.CentralizedPrint).GetTemplateCategoryDesc(ccID)
			s docDesc = ##class(EMRservice.HISInterface.CentralizedPrint).GetTemplateCategoryDesc(docID)
			s desc = cgDesc_"."_ccDesc_"."_docDesc
			
			if (OutputDesc = "")
			{
				s OutputDesc = docDesc
			}
			else
			{
				s OutputDesc = OutputDesc_";"_docDesc
			}
		}
	}
	else
	{
		//二版电子病历
		s obj = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(ACategoryChapterDocID)
		q:(obj = "") ""
		s ccDesc = obj.CategoryName
		s ccDesc = $tr(ccDesc, $c(10), "")
		s ccDesc = $tr(ccDesc, $c(13), "")
		s ccDesc = $tr(ccDesc, "'", "")
		
		s OutputDesc = ccDesc
	}
	q OutputDesc
}

/// debug: w ##class(EPRservice.BLL.BLOneStepPrintRecord).GetRecordTotalCount()
ClassMethod GetRecordTotalCount(APatientID As %String, APatientName As %String) As %Integer
{
	s count = 0
	//&sql(select COUNT(*) into :count from EPRinstance.OneStepPrintRecord)
	if (APatientID '= "")&(APatientName = "")
	{
		&sql(select COUNT(*) into :count from EPRinstance.OneStepPrintRecord where PatientID = :APatientID)
	}
	elseif (APatientID = "")&(APatientName '= "")
	{
		&sql(select COUNT(*) into :count from EPRinstance.OneStepPrintRecord where PatientName = :APatientName)
	}
	elseif (APatientID '= "")&(APatientName '= "")
	{
		&sql(select COUNT(*) into :count from EPRinstance.OneStepPrintRecord where PatientID = :APatientID and PatientName = :APatientName)
	}
	elseif (APatientID = "")&(APatientName = "")
	{
		&sql(select COUNT(*) into :count from EPRinstance.OneStepPrintRecord)
	}
	
	q count
}

/// debug: w ##class(EPRservice.BLL.BLOneStepPrintRecord).GetMRPrintRecord(201868,512)
ClassMethod GetMRPrintRecord(AEpisodeID As %String, APrintDocID As %String) As %String
{
	s found = "false"
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRI.OneStepPrintRecordI("IdxEpisodeIDAndPrintDocID", " "_AEpisodeID, " "_APrintDocID, rowID))
		q:(rowID = "")
		
		s obj = ##Class(EPRinstance.OneStepPrintRecord).%OpenId(rowID)
		
		s locID = obj.UserCTLocID
		//w "locID"_locID,!
		//病案室
		s mrLocID=$o(^CTLOC(0,"Code",$Zcvt("病案室","U"),""))
		//w "mrLocID"_mrUserLocID,!
		
		if ($zcvt(locID,"U")=$zcvt(mrLocID,"U"))
		{
			s found = "true"
			q
		}
 	}
 	q:(found = "true") "1"	
 	q "0"
}

}

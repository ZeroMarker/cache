Class EPRservice.BLL.BLCentralizedPrintRecord Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// debug: do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLCentralizedPrintRecord","GetPrintRecord","1","20")
Query GetPrintRecord(AStart As %String, ALimit As %String) As %Query(ROWSPEC = "Name:%String,UserID:%String,EpisodeID:%String,RegisterNo:%String,PatientID:%String,PrintItemsID:%String,StartDate:%String,StartTime:%String,FinishDate:%String,FinishTime:%String")
{
}

ClassMethod GetPrintRecordExecute(ByRef qHandle As %Binary, AStart As %String, ALimit As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s count = 0

 	s StartDate = ""
 	for {
		s StartDate =  $o(^DHCEPRI.CentralizedRecordI("IdxStartDateTimeAndUserID", StartDate),-1)
		q:(StartDate = "")
		s StartTime = ""

		for {
			s StartTime =  $o(^DHCEPRI.CentralizedRecordI("IdxStartDateTimeAndUserID", StartDate, StartTime),-1)
			q:(StartTime = "")
			s UserID = ""

			for {
				s UserID =  $o(^DHCEPRI.CentralizedRecordI("IdxStartDateTimeAndUserID", StartDate, StartTime, " "_UserID))
				s UserID = $tr(UserID, " ")
				q:(UserID = "")	
				s rowID = ""

				for {
					s rowID =  $o(^DHCEPRI.CentralizedRecordI("IdxStartDateTimeAndUserID", StartDate, StartTime, " "_UserID, rowID))
					q:(rowID = "")

					s log = ##class(EPRinstance.CentralizedPrintRecord).%OpenId(rowID)
					continue:(log="")
		
					s count = count + 1
					continue:(count < AStart)
					q:(count > (AStart + ALimit - 1))
		
					s name= log.Name
					s userID = log.UserID
					s episodeID = log.EpisodeID
					s patientID = log.PatientID
					s printItemsID = log.PrintItemsID
					s startDate = log.StartDate
					s startTime = log.StartTime
					s finishDate = log.FinishDate
					s finishTime = log.FinishTime
					s RegisterNo=log.RegisterNo
					
					s printItemsID = $tr(printItemsID,"@","^")
		
					s output = $LB(name,userID,episodeID,RegisterNo,patientID,printItemsID,startDate,startTime,finishDate,finishTime)
					s ^CacheTemp(repid, ind) = output
					s ind = ind + 1 
						
				}
				q:(count > (AStart + ALimit - 1))			
			}
			q:(count > (AStart + ALimit - 1))
		}
		q:(count > (AStart + ALimit - 1))
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

/// 按姓名查询打印记录
/// do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLCentralizedPrintRecord","SearchPrintRecordByName","JHMCS10010","1","20")
Query SearchPrintRecordByName(AName As %String, AStart As %String, ALimit As %String) As %Query(ROWSPEC = "Name:%String,UserID:%String,EpisodeID:%String,RegisterNo:%String,PatientID:%String,PrintItemsID:%String,StartDate:%String,StartTime:%String,FinishDate:%String,FinishTime:%String")
{
}

ClassMethod SearchPrintRecordByNameExecute(ByRef qHandle As %Binary, AName As %String, AStart As %String, ALimit As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s count = 0
	s episodeID=""
	s AName = $zcvt(AName,"U")
	for {
 		s episodeID=$o(^DHCEPRI.CentralizedRecordI("IdxName"," "_AName," "_episodeID))
 		s episodeID=$tr((episodeID)," ","")
 		q:(episodeID ="")
 		s FinishDate =""
 	  	for {
			s FinishDate =  $o(^DHCEPRI.CentralizedRecordI("IdxName"," "_AName," "_episodeID,FinishDate),-1)
			q:(FinishDate = "")
			s FinishTime = ""
			for {
				s FinishTime =  $o(^DHCEPRI.CentralizedRecordI("IdxName"," "_AName," "_episodeID,FinishDate,FinishTime),-1)
				q:(FinishTime = "")
				s rowID = ""
				for {
					s rowID =  $o(^DHCEPRI.CentralizedRecordI("IdxName"," "_AName," "_episodeID,FinishDate,FinishTime, rowID))
					q:(rowID = "")
					s log = ##class(EPRinstance.CentralizedPrintRecord).%OpenId(rowID)
					continue:(log="")
		
					s count = count + 1
					continue:(count < AStart)
					q:(count > (AStart + ALimit - 1))
		
					s name= log.Name
					s userID = log.UserID
					s episodeID = log.EpisodeID
					s patientID = log.PatientID
					s printItemsID = log.PrintItemsID
					s startDate = log.StartDate
					s startTime = log.StartTime
					s finishDate = log.FinishDate
					s finishTime = log.FinishTime
					s RegisterNo=log.RegisterNo
					
					s printItemsID = $tr(printItemsID,"@","^")
		
					s output = $LB(name,userID,episodeID,RegisterNo,patientID,printItemsID,startDate,startTime,finishDate,finishTime)
					s ^CacheTemp(repid, ind) = output
					s ind = ind + 1	
				}
				q:(count > (AStart + ALimit - 1))			
			}
			q:(count > (AStart + ALimit - 1))
		}
		q:(count > (AStart + ALimit - 1))
	}	

	Quit $$$OK
}

ClassMethod SearchPrintRecordByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPrintRecordByNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="")
 	{
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

ClassMethod SearchPrintRecordByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPrintRecordByNameExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按登记号查询打印记录
Query SearchPrintRecordByRegNo(ARegisterNo As %String, AStart As %String, ALimit As %String) As %Query(ROWSPEC = "Name:%String,UserID:%String,EpisodeID:%String,RegisterNo:%String,PatientID:%String,PrintItemsID:%String,StartDate:%String,StartTime:%String,FinishDate:%String,FinishTime:%String")
{
}

ClassMethod SearchPrintRecordByRegNoExecute(ByRef qHandle As %Binary, ARegisterNo As %String, AStart As %String, ALimit As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s count = 0
	s episodeID=""
	
	for {
 		s episodeID=$o(^DHCEPRI.CentralizedRecordI("IdRegisterNo"," "_ARegisterNo," "_episodeID))
 		s episodeID=$tr((episodeID)," ","")
 		q:(episodeID ="")
 		s FinishDate =""
 	  	for {
			s FinishDate =  $o(^DHCEPRI.CentralizedRecordI("IdRegisterNo"," "_ARegisterNo," "_episodeID,FinishDate),-1)
			q:(FinishDate = "")
			s FinishTime = ""
			for {
				s FinishTime =  $o(^DHCEPRI.CentralizedRecordI("IdRegisterNo"," "_ARegisterNo," "_episodeID,FinishDate,FinishTime),-1)
				q:(FinishTime = "")
				s rowID = ""
				for {
					s rowID =  $o(^DHCEPRI.CentralizedRecordI("IdRegisterNo"," "_ARegisterNo," "_episodeID,FinishDate,FinishTime, rowID))
					q:(rowID = "")
					s log = ##class(EPRinstance.CentralizedPrintRecord).%OpenId(rowID)
					continue:(log="")
		
					s count = count + 1
					continue:(count < AStart)
					q:(count > (AStart + ALimit - 1))
		
					s name= log.Name
					s userID = log.UserID
					s episodeID = log.EpisodeID
					s patientID = log.PatientID
					s printItemsID = log.PrintItemsID
					s startDate = log.StartDate
					s startTime = log.StartTime
					s finishDate = log.FinishDate
					s finishTime = log.FinishTime
					s RegisterNo=log.RegisterNo
					
					s printItemsID = $tr(printItemsID,"@","^")
		
					s output = $LB(name,userID,episodeID,RegisterNo,patientID,printItemsID,startDate,startTime,finishDate,finishTime)
					s ^CacheTemp(repid, ind) = output
					s ind = ind + 1	
				}
				q:(count > (AStart + ALimit - 1))			
			}
			q:(count > (AStart + ALimit - 1))
		}
		q:(count > (AStart + ALimit - 1))
 	}	

	Quit $$$OK
}

ClassMethod SearchPrintRecordByRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPrintRecordByRegNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="")
 	{
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

ClassMethod SearchPrintRecordByRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPrintRecordByRegNoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug:	w ##Class(EPRservice.BLL.BLCentralizedPrintRecord).GetRecordTotalCount()
ClassMethod GetRecordTotalCount() As %Integer
{
	s count = 0
	&sql(select COUNT(*) into :count from EPRinstance.CentralizedPrintRecord)
	q count
}

/// 按名字SQL
ClassMethod GetRecordTotalCountByName(AName As %String) As %Integer
{
	s count = 0
	&sql(select COUNT(*) into :count from EPRinstance.CentralizedPrintRecord where Name=:AName)
	q count
}

/// 按登记号SQL
ClassMethod GetRecordTotalCountByRegisterNo(ARegisterNo As %String) As %Integer
{
	s count = 0
	&sql(select COUNT(*) into :count from EPRinstance.CentralizedPrintRecord where RegisterNo=:ARegisterNo)
	q count
}

/// 更新数据
ClassMethod UpdateData()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRI.CentralizedRecordD(rowID))
		q:(rowID = "")
		s print = ##class(EPRinstance.CentralizedPrintRecord).%OpenId(rowID)
		if ((print.Name = "")||(print.RegisterNo=""))
		{
			s patientID=print.PatientID
			s name=##class(EPRservice.HISInterface.PatientInfoAssist).Name(patientID)
			s regno=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
			s print.Name=name
			s print.RegisterNo=regno
		}
		s sc = print.%Save()
		d print.%Close()
		if ($$$ISOK(sc)) continue
		w !,"error"
	}	
	w !,"all finish"
}

ClassMethod GetRecord(AEpisodeID As %String, APrintDocID As %String) As %String
{
	s found = "false"
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRI.CentralizedRecordI("IdxEpisodeID", " "_AEpisodeID, rowID))
		q:(rowID = "")
		
		s obj = ##Class(EPRinstance.CentralizedPrintRecord).%OpenId(rowID)
		s printItemsID = obj.PrintItemsID
		s episodeID = obj.EpisodeID
		
		continue:(episodeID '= AEpisodeID)	
		
 		s totalItemCount = $l(printItemsID,"^")

		for i=1:1:totalItemCount
		{	
			s category = $p(printItemsID,"^",i)
			s categoryIDNum = $e(category,3,4)
			continue:(categoryIDNum '= "07")

			s ccID = $p(category,"#",4)
			s prtID = ""
			for {
				s prtID = $O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_ccID, prtID))
				q:(prtID = "")
				if (prtID = APrintDocID)
				{
					s found = "true"
					q	
				}
			}
			q:(found = "true")
 		}
 		q:(found = "true")
 	}
 	q:(found = "true") "1"	
 	q "0"
}

}

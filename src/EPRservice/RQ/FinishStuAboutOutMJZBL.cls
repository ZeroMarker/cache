Class EPRservice.RQ.FinishStuAboutOutMJZBL Extends %RegisteredObject
{

/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.RQ.FinishStuAboutOutMJZBL","GetFinishStaueAboutMZBL","2022-05-09","2022-05-09","","Y","O","")
Query GetFinishStaueAboutMZBL(AStartDate As %String, AEndDate As %String, ALocID As %String, AllLocs As %String, APatientType As %String = "O", AEPRMZDocIDs As %String, AEPRJZDocIDs As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "LocID,LocDesc,DocID,DoctorDesc,LocDocAdmCount,LocDocFinCount,DocFinishPercent,LocDocSignCount,DocSignPercent") [ SqlProc ]
{
}

ClassMethod GetFinishStaueAboutMZBLExecute(ByRef qHandle As %Binary, AStartDate, AEndDate, ALocID, AllLocs, APatientType, AEMRMZDocIDs, AEMRJZDocIDs = "", AHospitalID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	k ^CacheTemp("EPRQuality","FinishStaueAboutMZBL")
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	q:(ALocID="")&&(AllLocs="") $$$OK
	
    for TmpAdmDate = StartDate:1:EndDate
    {
	    s EpisodeID = ""
		for {
			 s EpisodeID = $o(^PAADMi("PAADM_AdmDate",TmpAdmDate,EpisodeID))
			 q:(EpisodeID = "")
			 s objPaAdm = $g(^PAADM(+EpisodeID))
			 s Type=$p(objPaAdm,"^",2)
			 continue:(Type'=APatientType)&&(APatientType'="")
			 s VisitStatus=$p(objPaAdm,"^",20)
			 continue:(VisitStatus="C")
			 s AdmLocID = $p(objPaAdm,"^",4)
			 s AdmDocID = $p(objPaAdm,"^",9)
			 s:(AdmDocID = "") AdmDocID = "-1"
			 s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
			 s:(AllLocs="Y") ALocID=""
			 continue:(ALocID'="")&&(ALocID'=AdmLocID)
			 s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			 s RowID=""
			 for
				 {
					
				    s RowID = $o(^PAC("ADMLOC",0,"AdmType","O",RowID))
				    q:RowID=""
				    continue:(AdmLocID'=RowID)
	                
	                s ^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID)=$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID))+1
	                s ret=0
	                if (APatientType="O")
	                {  
	                //门诊病历
	                
	                s ret = ..RecStatuEPRDoc(EpisodeID,AEMRMZDocIDs)
	                
	                
	               
	                s:((ret=1)||(ret=2)) ^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"FinishCount")=$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"FinishCount"))+1 
	                s:(ret=2) ^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"SignCount")=$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"SignCount"))+1 
	                }
	                if (APatientType="E")&&(AEMRJZDocIDs'="")
	                {
	                //急诊病历
	                 s ret = ..RecStatuEPRDoc(EpisodeID,AEMRJZDocIDs)
	                
	                
	                 
	                s:((ret=1)||(ret=2)) ^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"FinishCount")=$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"FinishCount"))+1 
	                s:(ret=2) ^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"SignCount")=$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",AdmLocID,AdmDocID,"SignCount"))+1 
	                }
				   
				 }
         }
         
        
    			
	}
   
   s LocID=""
   for
   {
		s LocID=$o(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",LocID)) 
		q:(LocID="")
		
		s DocID=""
		for
		{
		   
			s DocID=$o(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",LocID,DocID))
			
			q:DocID=""
			s DoctorDesc = $s(DocID '= -1:$p($g(^CTPCP((+DocID),1)),"^",2),1:"未指定")
			s LocDocAdmCount=+$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",LocID,DocID))
			s LocDocFinCount=+$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",LocID,DocID,"FinishCount"))
			s LocDocSignCount=+$g(^CacheTemp("EPRQuality","FinishStaueAboutMZBL",LocID,DocID,"SignCount"))
			s:(LocDocFinCount="")||(LocDocFinCount=0) DocFinishPercent="0"_"%"
			s:(LocDocFinCount'="")&&(LocDocFinCount'=0) DocFinishPercent=$s(LocDocFinCount*100#LocDocAdmCount=0:LocDocFinCount*100/LocDocAdmCount,1:$j(LocDocFinCount*100/LocDocAdmCount,2,2))_"%"
		    s:(LocDocSignCount="")||(LocDocSignCount=0) LocDocSignCount="0"_"%"
			s:(LocDocSignCount'="")&&(LocDocSignCount'=0) DocSignPercent=$s(LocDocSignCount*100#LocDocAdmCount=0:LocDocSignCount*100/LocDocAdmCount,1:$j(LocDocSignCount*100/LocDocAdmCount,2,2))_"%"
		    s LocDesc = $p($g(^CTLOC(+LocID)),"^",2)
	        s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		    s Data = $lb(LocID,LocDesc,DocID,DoctorDesc,LocDocAdmCount,LocDocFinCount,DocFinishPercent,LocDocSignCount,DocSignPercent)

	        s ^CacheTemp(repid,ind) = Data
		    s ind=ind+1
		}	
		
   }
    Quit $$$OK
}

ClassMethod GetFinishStaueAboutMZBLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFinishStaueAboutMZBLExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFinishStaueAboutMZBLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFinishStaueAboutMZBLExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(EPRservice.RQ.FinishStuAboutMJZBL).RecStatuEPRDoc(2837,"")
ClassMethod RecStatuEPRDoc(EpisodeID As %String, AEPRMJZDocIDs As %String = "") As %String
{
	s flag=0
	q:(EpisodeID="") flag
	
	s HappenDate=$O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",EpisodeID, " SAVE", "")) 
	q:(HappenDate="") flag
	if (AEPRMJZDocIDs'="")
	{
	s EMRDocIDsl= ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEPRMJZDocIDs,"^")
    for i = 1:1:$listlength(EMRDocIDsl)
    {
	  s EMRDocID = $listget(EMRDocIDsl,i)
	  q:(EMRDocID = "")	  
      s IsExist=$d(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,EMRDocID))
      continue:(IsExist =0)
      s EMRNum=""
	  for {
		  s EMRNum=$o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,EMRDocID,EMRNum))
		  q:(EMRNum="")
	      s EMRLogsID=""				
		  f {
			   s EMRLogsID=$o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,EMRDocID,EMRNum,EMRLogsID))
			   q:(EMRLogsID="")
	           s EMRLogsObj=##class(EMRinstance.EMRLogs).%OpenId(EMRLogsID)
			   s EMRStatus=EMRLogsObj.EMRStatus
			   continue:(EMRStatus="deleted")
			   s flag=1
			   s hisSign=##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(EpisodeID,EMRDocID,EMRNum)
			   s:(hisSign=1) flag=2
			  
	           q:(flag=2)
		  
	  }
    }   
    }		   
			   
	q flag
}
 else
{
	set EMRDocID = ""
	for {	
		set EMRDocID = $o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,EMRDocID))
		quit:EMRDocID=""
		
		set EMRNum = ""
		for {
			set EMRNum = $o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,EMRDocID,EMRNum))
			quit:EMRNum=""
			
			set EMRLogsID = ""
			for {
				set EMRLogsID = $o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,EMRDocID,EMRNum,EMRLogsID))
				quit:EMRLogsID=""
				
				set objEMR = ##class(EMRinstance.EMRLogs).%OpenId(EMRLogsID)
				continue:(objEMR = "")
				continue:(objEMR.EMRStatus ="deleted") 
				s flag=1
			  
				s hisSign=##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(EpisodeID,EMRDocID,EMRNum)
			   s:(hisSign=1) flag=2
			 
			}
		}
	}
}
 q flag
}

/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.RQ.FinishStuAboutOutMJZBL","GetMZJBLFinishDetail","2022-11-20","2022-11-20","","O","102^104","","")
Query GetMZJBLFinishDetail(AStartDate As %String, AEndDate As %String, ALocID As %String, APatientType As %String = "O", AEPRMZDocIDs As %String, AEPRJZDocIDs As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "EpisodeID,Name,RegNo,AdmLocID,LocDesc,AdmDocID,DoctorDesc,AdmitDate,Statu") [ SqlProc ]
{
}

ClassMethod GetMZJBLFinishDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String, APatientType As %String = "O", AEPRMZDocIDs As %String, AEPRJZDocIDs As %String = "", AHospitalID As %String = "") As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((AStartDate="")||(AEndDate="")) $$$OK
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	
    for TmpAdmDate = StartDate:1:EndDate
    {
	    s EpisodeID = ""
		for {
			 s EpisodeID = $o(^PAADMi("PAADM_AdmDate",TmpAdmDate,EpisodeID))
			 q:(EpisodeID = "")
			 s objPaAdm = $g(^PAADM(+EpisodeID))
			 s Type=$p(objPaAdm,"^",2)
			 continue:(Type'=APatientType)&&(APatientType'="")
			 s VisitStatus=$p(objPaAdm,"^",20)
			 continue:(VisitStatus="C")
			 s AdmLocID = $p(objPaAdm,"^",4)
			 s AdmDocID = $p(objPaAdm,"^",9)
			 s:(AdmDocID = "") AdmDocID = "-1"
			 s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
			 continue:(ALocID'="")&&(ALocID'=AdmLocID)
			 s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		     continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			 s RowID=""
			 for
		     {
					
			    s RowID = $o(^PAC("ADMLOC",0,"AdmType","O",RowID))
			    q:RowID=""
			    continue:(AdmLocID'=RowID)
                
               
                s ret=0,Statu="未书写"
                
                if (APatientType="O")
                {  
	                //门诊病历
	                s ret = ..RecStatuEPRDoc(EpisodeID,AEPRMZDocIDs)
                }
                if (APatientType="E")&&(AEPRJZDocIDs'="")
                {
	                 //急诊病历
	                 s ret = ..RecStatuEPRDoc(EpisodeID,AEPRJZDocIDs)
                }
                s:(ret=1) Statu="已书写未签名" 
                s:(ret=2) Statu="已签名" 
				   
			  }
			  
			 s Papmi = $p(objPaAdm,"^",1)
			 s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
			 s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
			 ///科室
			 s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
			 s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			 s AdmitDate = $zd($p(objPaAdm,"^",6),3)
			 s Data=$lb(EpisodeID,Name,RegNo,AdmLocID,LocDesc,AdmDocID,DoctorDesc,AdmitDate,Statu)
			 s ^CacheTemp(repid,ind) = Data
		     s ind=ind+1
         }
         
        
    			
	}
	Quit $$$OK
}

ClassMethod GetMZJBLFinishDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMZJBLFinishDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMZJBLFinishDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMZJBLFinishDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

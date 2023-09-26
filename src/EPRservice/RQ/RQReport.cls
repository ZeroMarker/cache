Class EPRservice.RQ.RQReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		HKY
/// CreatDate:		2012-11-15
/// Description:	电子病历各记录完成情况统计表
/// Input:		    ArgStartDate为起始时间
///                 ArgEndDate  为结束时间
///                 AEPRDocContent 为AEPRDocID||AEPRDocDesc
/// d ##class(%ResultSet).RunQuery("EPRservice.RQ.RQReport","GetPatientInfoByTitle","2010-01-10","2012-12-12","116||主治医师查房记录")
Query GetPatientInfoByTitle(ArgStartDate, ArgEndDate, AEPRDocContent) As %Query(ROWSPEC = "EpisodeID,LocDesc,RegNo,PatientName,AdmitDate,AdmDocID,DoctorDesc,MRNo,AdmWardID,WardDesc,Gender,Birthday")
{
}

ClassMethod GetPatientInfoByTitleExecute(ByRef qHandle As %Binary, ArgStartDate, ArgEndDate, AEPRDocContent) As %Status
{
   
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s StartDate	= $g(ArgStartDate)
	s EndDate	= $g(ArgEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s CreateDate=""
	f CreateDate=StartDate:1:EndDate
	{
		s lCreateTime=""
		f {
			s lCreateTime=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime"," "_CreateDate,lCreateTime))
			q:(lCreateTime="")
			s CreateTime=$e(lCreateTime,2,$l(lCreateTime))
			s AEPRDocID=$p(AEPRDocContent,"||",1)
			s AEPRDocDesc=$p(AEPRDocContent,"||",2)
			s lEpisodeID=""	
			f {	
				s lEpisodeID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime"," "_CreateDate," "_CreateTime,lEpisodeID))
				q:(lEpisodeID="")
				s EpisodeID=$e(lEpisodeID,2,$l(lEpisodeID))
				if AEPRDocID'=116
				{ 
			     s EPRNum=""
			     f {
				    s EPRNum=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime"," "_CreateDate," "_CreateTime," "_EpisodeID," "_AEPRDocID,EPRNum))
				    q:(EPRNum="")
				   
				      s EPRLogsID=""					
				      f { 
					      s EPRLogsID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime"," "_CreateDate," "_CreateTime," "_EpisodeID," "_AEPRDocID,EPRNum,EPRLogsID))
					      q:(EPRLogsID="")   
					      s EPRLogsObj=##class(EPRinstance.EPRLogs).%OpenId(EPRLogsID)
					      s EPRStatus=EPRLogsObj.EPRStatus
					      continue:(EPRStatus="unfinished")||(EPRStatus="")
					      
					      s str=  ..GetPatientInfo(EpisodeID)
                          d OutputRow3
                         }
                        }
				    }
			     
			      else
			         {
				         s TheECRecord=""
				         f {
				           s TheECRecord=$o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," 55",TheECRecord))
				           
				           q:TheECRecord=""
				           
				           s ChildSub=""
	                       f {
		                      
		                     s ChildSub=$o(^DHCEPRI.InstanceDataI("IdxECRecord",TheECRecord,ChildSub))			         
				             q:ChildSub=""
				             s ID=TheECRecord_"||"_ChildSub
				             s obj=##class(EPRinstance.InstanceData).%OpenId(ID)
				             s Title=obj.Title
				             continue:(AEPRDocDesc'="")&&(Title'[AEPRDocDesc)
				             s str=  ..GetPatientInfo(EpisodeID)
	                         continue:($d(^CacheTemp("EPREpisodeID",EpisodeID)))
	                         s ^CacheTemp("EPREpisodeID",EpisodeID)=str
	                         d OutputRow2
	                       }
				         }
				      }
		            }
		          }
	          }
	

	     
	Quit $$$OK
OutputRow2 
	s Data=^CacheTemp("EPREpisodeID",EpisodeID)
   	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
	

OutputRow3 
	s Data=str
   	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod GetPatientInfoByTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoByTitleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 
    Kill ^CacheTemp("EPREpisodeID")
	Quit $$$OK
}

ClassMethod GetPatientInfoByTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoByTitleExecute ]
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

ClassMethod GetPatientInfo(AEpisodeID As %String)
{
	 s objPaAdm = $g(^PAADM(+AEpisodeID))
	 q:(objPaAdm = "") 
	                
	 s AdmLocID = $p(objPaAdm,"^",4)
	 q:(AdmLocID = "") 
	 //q:(ArgCTLocCode '= "")&&(AdmLocID '= ArgCTLocCode) 
		
	 s AdmDocID = $p(objPaAdm,"^",9)
	 s:(AdmDocID = "") AdmDocID = "-1"
	                          
	 s AdmWardID = $p(objPaAdm,"^",70)				
	 q:(AdmWardID="") 

	 // 以下取患者基本信息和就诊信息
	 s Papmi = $p(objPaAdm,"^",1)
	 s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	 s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	 s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	 s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	 s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	 s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	 s WardDesc = $p($g(^PAWARD(+AdmWardID)),"^",2)
	 s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
     s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	 s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	 s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	 s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	 s str=$lb(AEpisodeID,LocDesc,RegNo,PatientName,AdmitDate,AdmDocID,DoctorDesc,MRNo,AdmWardID,WardDesc,Gender,Birthday)
	 q str
}

/// d ##class(%ResultSet).RunQuery("EPRservice.RQ.RQReport","HomeToOutpatient","2010-01-10","2012-12-12")
Query HomeToOutpatient(ArgStartDate, ArgEndDate, ArgCTLocCode As %String = "") As %Query(ROWSPEC = "EpisodeID,LocDesc,RegNo,PatientName,AdmitDate")
{
}

ClassMethod HomeToOutpatientExecute(ByRef qHandle As %Binary, ArgStartDate, ArgEndDate, ArgCTLocCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s Count=0
	s StartDate	= $g(ArgStartDate)
	s EndDate	= $g(ArgEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s CreateDate=""
	f CreateDate=StartDate:1:EndDate
	{
		s lCreateTime=""
		f {
			s lCreateTime=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime"," "_CreateDate,lCreateTime))
			q:(lCreateTime="")
			s CreateTime=$e(lCreateTime,2,$l(lCreateTime))
			
			s lEpisodeID=""	
			f {	
				s lEpisodeID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime"," "_CreateDate," "_CreateTime,lEpisodeID))
				q:(lEpisodeID="")
				s EpisodeID=$e(lEpisodeID,2,$l(lEpisodeID))
				s EPRLogsID=""					
				f {  
				    s Count=Count+1
					s EPRLogsID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime"," "_CreateDate," "_CreateTime," "_EpisodeID," 114",1,EPRLogsID)) 
					q:(EPRLogsID="") 
					    
					s EPRLogsObj=##class(EPRinstance.EPRLogs).%OpenId(EPRLogsID)
					s EPRStatus=EPRLogsObj.EPRStatus
					continue:(EPRStatus="unfinished")||(EPRStatus="")
				
					s objPaAdm = $g(^PAADM(+EpisodeID))
	                q:(objPaAdm = "") 
	                
	
                 	s AdmLocID = $p(objPaAdm,"^",4)
	                q:(AdmLocID = "") 
	                q:(ArgCTLocCode '= "")&&(AdmLocID '= ArgCTLocCode) 
		
	                s AdmDocID = $p(objPaAdm,"^",9)
	                s:(AdmDocID = "") AdmDocID = "-1"

	                // 以下取患者基本信息和就诊信息
	                s Papmi = $p(objPaAdm,"^",1)
	                s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	                s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	                s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	                s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	                s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	                s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	                s ^CacheTemp1(Count)=$lb(EpisodeID,LocDesc,RegNo,PatientName,AdmitDate)
                    d OutputRow4
	
			}
		}
	  }
	}
	     
	Quit $$$OK

OutputRow4 
	s Data=$g(^CacheTemp1(Count))
	k ^CacheTemp1(Count)
   	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod HomeToOutpatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HomeToOutpatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 
 		
	Quit $$$OK
}

ClassMethod HomeToOutpatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HomeToOutpatientExecute ]
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

/// Added By HKY 
/// 质控消息统计报表
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetMessageReport","2008-01-01","2013-01-14")
Query GetMessageReport(AStartDate As %String, AEndDate As %String, ALocID As %String = "") As %Query(ROWSPEC = "MessageBody,CreateDate,CreateTime,CreateUserDesc,ReadDate,ReadTime,ReadUserDesc,ReadStatus,LocDesc,Name,RegNo,DoctorDesc")
{
}

ClassMethod GetMessageReportExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String = "") As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	for IdxCreateDate = StartDate:1:EndDate
	{   
		s MessageID = ""
		for {
			s MessageID = $o(^DHCEPRQ.QualityMessageI("IdxCreateDate",IdxCreateDate,MessageID))
			
			q:(MessageID = "") 
			
			
			
			s objMessage = $g(^DHCEPRQ.QualityMessageD(MessageID))
			continue:(objMessage = "")
			
			s CreateDate = $list(objMessage,2)
			s:(CreateDate '= "") CreateDate = $zd(CreateDate,3)
			
			s CreateTime = $list(objMessage,3)
			s:(CreateTime '= "") CreateTime = $zt(CreateTime,1)
			s CreateUserDR = $list(objMessage,4)
			s CreateUserDesc = ""
			s:(CreateUserDR '= "") CreateUserDesc = $p($g(^SSU("SSUSR",+CreateUserDR)),"^",2)
			s MessageBody = $list(objMessage,5)
			s MessageDR=MessageID
			
			
			s MessageRecipientID=""
			s ReadStatus="未读"
			for {
				s MessageRecipientID=$o(^DHCEPRQ.QualityMsgRecI("IdxMessageDR"," "_MessageDR,MessageRecipientID))
				q:MessageRecipientID=""
				
				
				
				s objRecipient = $g(^DHCEPRQ.QualityMsgRecD(MessageRecipientID))
				s EpisodeID = $list(objRecipient,2)
				
				
				s ReadDate=$list(objRecipient,4)
				s ReadTime=$list(objRecipient,5)
				s ReadUserDR=$list(objRecipient,6)
				s:(ReadUserDR '= "") ReadStatus="已读"
				s ReadUserDesc = ""
			    s:(ReadUserDR '= "") ReadUserDesc = $p($g(^SSU("SSUSR",+ReadUserDR)),"^",2)
			    s objPaAdm = $g(^PAADM(+EpisodeID))
			    s AdmLocID = $p(objPaAdm,"^",4)
	            q:(AdmLocID = "") 
	            q:(ALocID '= "")&&(AdmLocID '= ALocID)
			    s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生

		        s Papmi = $p(objPaAdm,"^",1)
		        s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
		
		        s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
				
		        s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
		        s AdmitDate = $zd($p(objPaAdm,"^",6),3)
		        s DischDate = $p(objPaAdm,"^",17)
		        s:(DischDate '= "") DischDate = $zd(DischDate,3)
		        s LocDesc = $p($g(^CTLOC(AdmLocID)),"^",2)
		        s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		        s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
		        s Data=$lb(MessageBody,CreateDate,CreateTime,CreateUserDesc,ReadDate,ReadTime,ReadUserDesc,ReadStatus,LocDesc,Name,RegNo,DoctorDesc)
			    s ^CacheTemp(repid,ind) = Data
		        s ind = ind + 1	
			   
				}
		    }
			
	  }	
	
	Quit $$$OK
}

ClassMethod GetMessageReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageReportExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMessageReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageReportExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

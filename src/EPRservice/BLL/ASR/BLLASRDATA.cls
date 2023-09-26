Class EPRservice.BLL.ASR.BLLASRDATA Extends %RegisteredObject [ ProcedureBlock ]
{

///  Creator: LiangeWeixi
///  CreatTime: 2016-03-28
///  Input: PID：当PFlag为1时PID为EpisodeID,否则SelectID为patientID，PStartDate：开始时间
///        PEndDate：结束时间，PStartPage：返回分页开始页号，PEendPage：返回分页结束页号
///  OutPut:	
///  d ##class(%ResultSet).RunQuery("ERPservice.BLL.ASR.BLLASRDATA","GetASREpisodeList","50729","","",1,5,1)
Query GetASREpisodeList(PID As %String, PStartDate As %String, PEndDate As %String, PStartPage As %String, PEendPage As %String, PFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,ASRowID:%String,CreateDate:%String,CreateTime:%String,FilePath:%String,FileName:%String,AliasName:%String,HasRet:%String")
{
}

ClassMethod GetASREpisodeListExecute(ByRef qHandle As %Binary, PID As %String, PStartDate As %String, PEndDate As %String, PStartPage As %String, PEendPage As %String, PFlag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	s retCnt = 1
	/*for i = 1:1:9 {
	 	if i#2 =0 {
		 	s data = $lb("503",i,"2016-03-2"_i,"17:34:32","/503/test"_i_"_16k.wav","test"_i_"_16k.wav","第一次查房","0")
	 	}
		else {
			s data = $lb("503",i,"2016-03-2"_i,"17:34:32","/503/test"_i_"_16k.wav","test"_i_"_16k.wav","第一次查房","1")
		}
		s ^CacheTemp(repid,ind) = data
		s ind = ind + 1
	}*/
 	//q:(PID'=530) $$$OK
 	//s (EpisodeID,CreateDate,CreateTime,FileName,AliasName)=""
 	//"EID&ASRowID&日期&时间&FTP路径&文件名&备注&已识别"
 	if ((PStartDate'="0")&&(PEndDate'="0")) {
		 //s ^eprlwx("st") = PStartDate
		 s PStartDate = $zdh(PStartDate,3)
		 s PEndDate = $zdh(PEndDate,3)
 	}
 	
 	if (PFlag="1") {
	 	s oid = ""
	 	for {
		 	s oid = $o(^DHCEPRI.ASREpisodeListI("Idx"," "_PID,oid))
	 		q:(oid = "")
	 		
	 		s obj = ##Class(EPRinstance.ASR.ASREpisodeList).%OpenId(oid)
	 		if obj.AliasName="" {
		 		s data = $lb(PID,oid,$zd(obj.CreateDate,3),$zt(obj.CreateTime),obj.FilePath,obj.FileName,obj.FileName,obj.Recognized)
			}
			else {
				s data = $lb(PID,oid,$zd(obj.CreateDate,3),$zt(obj.CreateTime),obj.FilePath,obj.FileName,obj.AliasName,obj.Recognized)
			}
			if ((retCnt>=PStartPage)&&(retCnt<=PEendPage)){
				s ^CacheTemp(repid,ind) = data
				s ind = ind + 1
			}
			s retCnt = retCnt+1
		}
 	}
 	elseif (PFlag="2") {
		//s PID = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(PID)
		
		set typeRowID = "0" 
		for {
	 		set typeRowID = $o(^PAPERdr(PID,"ADM",typeRowID))
	 		q:(typeRowID = "")
	 		
	 		set episodeID = "0"
	 		for {
		 		s episodeID = $o(^PAPERdr(PID,"ADM",typeRowID,episodeID))
		 		q:(episodeID = "")
		 		//w episodeID
		 		s oid = ""
	 			for {
		 			s oid = $o(^DHCEPRI.ASREpisodeListI("Idx"," "_episodeID,oid))
	 				q:(oid = "")
	 				
	 				s obj = ##Class(EPRinstance.ASR.ASREpisodeList).%OpenId(oid)
	 				if ((PStartDate'="0")&&(PEndDate'="0")) {
		 				//s ^eprlwx("ss") = obj.CreateDate
	 					continue:((obj.CreateDate<PStartDate)||(obj.CreateDate>PEndDate))
	 				}
	 				if obj.AliasName="" {
		 				s data = $lb(episodeID,oid,$zd(obj.CreateDate,3),$zt(obj.CreateTime),obj.FilePath,obj.FileName,obj.FileName,obj.Recognized)
					}
					else {
						s data = $lb(episodeID,oid,$zd(obj.CreateDate,3),$zt(obj.CreateTime),obj.FilePath,obj.FileName,obj.AliasName,obj.Recognized)
					}
					if ((retCnt>=PStartPage)&&(retCnt<=PEendPage)){
						s ^CacheTemp(repid,ind) = data
						s ind = ind + 1
					}
					s retCnt = retCnt+1
				}
				//set ind=ind+1  	
	 		}
		}
	}
	
	Quit $$$OK
}

ClassMethod GetASREpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetASREpisodeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetASREpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetASREpisodeListExecute ]
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
 	Else     
    {				
 		Set Row=^CacheTemp(repid,ind)   // fetch row
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

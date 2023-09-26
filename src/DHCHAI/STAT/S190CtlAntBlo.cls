/// 名称: DHCHAI.STAT.S190CtlAntBlo
/// 描述: 住院患者限制/特殊使用级抗菌药物治疗前血培养送检率统计表
/// 编写者：pylian
/// 编写日期: 2018-07-26
Class DHCHAI.STAT.S190CtlAntBlo Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-26
/// Description:  医院住院患者限制/特殊使用级抗菌药物治疗前血培养送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S190CtlAntBlo","QryHospCtlAntBlo","1","2016-03-01","2018-03-17")
Query QryHospCtlAntBlo(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "HospIDs:%String,HospInSum:%Integer,HospKSS2Use:%Integer,HospKSS2CureBlo:%Integer,HospKSS3Use:%Integer,HospKSS3CureBlo:%Integer") [ SqlProc ]
{
}

ClassMethod QryHospCtlAntBloExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set:aDateFrom>+$h aDateFrom=""
 	Set:aDateTo>+$h aDateTo=+$h
 	
    Kill ^TMP($zn,$j,"QryHospCtlAntBlo")
   
    //同期在院
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") //某天的在院人数
	For index1=1:1:ListArray.Count() {
		Set EpisodeID=ListArray.GetAt(index1)	
		Continue:EpisodeID=""
		
	    Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
		Continue:'$isobject(objPaadm) 
	
	    Set num=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","PatAdm"))
		Set ^TMP($zn,$j,"QryHospCtlAntBlo","PatAdm")=num+1
		Set ^TMP($zn,$j,"QryHospCtlAntBlo","PatAdm",EpisodeID) = ""

		Set AntUseInfo    =..GetAntUseInfo(EpisodeID,aDateFrom,aDateTo)
		Set IsKSS2Use     = $p(AntUseInfo,"^",5)
		Set IsKSS2CureBlo = $p(AntUseInfo,"^",6)
		Set IsKSS3Use     = $p(AntUseInfo,"^",7)
		Set IsKSS3CureBlo = $p(AntUseInfo,"^",8)
		
		If (IsKSS2Use=1) {
			Set num=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS2Use"))
			Set ^TMP($zn,$j,"QryHospCtlAntBlo","KSS2Use")=num+1
			Set ^TMP($zn,$j,"QryHospCtlAntBlo","KSS2Use",EpisodeID) = ""
			
			If (IsKSS2CureBlo=1) {
				Set num=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS2CureBlo"))
				Set ^TMP($zn,$j,"QryHospCtlAntBlo","KSS2CureBlo")=num+1
			}
		}
		If (IsKSS3Use=1) {
			Set num=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS3Use"))
			Set ^TMP($zn,$j,"QryHospCtlAntBlo","KSS3Use")=num+1
			Set ^TMP($zn,$j,"QryHospCtlAntBlo","KSS3Use",EpisodeID) = ""
			
			If (IsKSS3CureBlo=1) {
				Set num=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS3CureBlo"))
				Set ^TMP($zn,$j,"QryHospCtlAntBlo","KSS3CureBlo")=num+1
			}
		}
	}
	
	Set HospInSum=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","PatAdm"))	
	Set HospKSS2Use=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS2Use"))
    Set HospKSS2CureBlo=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS2CureBlo")) 
	Set HospKSS3Use=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS3Use"))
    Set HospKSS3CureBlo=+$g(^TMP($zn,$j,"QryHospCtlAntBlo","KSS3CureBlo"))
    	
    Set Data=$lb(aHospIDs,HospInSum,HospKSS2Use,HospKSS2CureBlo,HospKSS3Use,HospKSS3CureBlo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,"QryHospCtlAntBlo")
	Quit $$$OK
}

ClassMethod QryHospCtlAntBloClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospCtlAntBloExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospCtlAntBloFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospCtlAntBloExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-07-26
/// Description:  住院患者限制/特殊使用级抗菌药物治疗前血培养送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S190CtlAntBlo","QryCtlAntBlo","1","2016-03-01","2018-03-17")
Query QryCtlAntBlo(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInSum:%Integer,LocKSS2Use:%Integer,LocKSS2CureBlo:%Integer,LocKSS3Use:%Integer,LocKSS3CureBlo:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInSum:%Integer,WardKSS2Use:%Integer,WardKSS2CureBlo:%Integer,WardKSS3Use:%Integer,WardKSS3CureBlo:%Integer,HospInSum:%Integer,HospKSS2Use:%Integer,HospKSS2CureBlo:%Integer,HospKSS3Use:%Integer,HospKSS3CureBlo:%Integer,GroupInSum:%Integer,GroupKSS2Use:%Integer,GroupKSS2CureBlo:%Integer,GroupKSS3Use:%Integer,GroupKSS3CureBlo:%Integer") [ SqlProc ]
{
}

ClassMethod QryCtlAntBloExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set:aDateFrom>+$h aDateFrom=""
 	Set:aDateTo>+$h aDateTo=+$h
 	
    Kill ^TMP($zn,$j,"QryCtlAntBlo")
	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    //同期在科
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I") //某段时间的在科人数
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 //当天转入不算在内
		//Continue:(Status="A2")                //当天转入当天转出不算在内

		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
		
		Set (IsKSS2Use,IsKSS2CureBlo,IsKSS3Use,IsKSS3CureBlo)=0
		If '$d(^TMP($zn,$j,"QryCtlAntBlo","Hosp","AntUseInfo",Paadm))
		{
			Set AntUseInfo   =..GetAntUseInfo(Paadm,aDateFrom,aDateTo)  //不重复判断
			Set IsKSS2Use     = $p(AntUseInfo,"^",5)
			Set IsKSS2CureBlo = $p(AntUseInfo,"^",6)
			Set IsKSS3Use     = $p(AntUseInfo,"^",7)
			Set IsKSS3CureBlo = $p(AntUseInfo,"^",8)
	
		}
		Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","AntUseInfo",Paadm)=""
		
		If (IsKSS2Use =1) {
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2Use",Paadm))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2Use",Paadm)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2Use")=num+1
			}
			
			If (IsKSS2CureBlo =1) {
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2CureSub",Paadm))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2CureSub",Paadm)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2CureSub"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2CureSub")=num+1
				}
			}
		}	
		If (IsKSS3Use =1) {
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3Use",Paadm))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3Use",Paadm)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3Use")=num+1
			}
			
			If (IsKSS3CureBlo =1) {
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3CureSub",Paadm))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3CureSub",Paadm)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3CureSub"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3CureSub")=num+1
				}
			}
		}	
				
	    If '$d(^TMP($zn,$j,"QryCtlAntBlo","Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","PatAdm"))
			Set ^TMP($zn,$j,"QryCtlAntBlo","Hosp","PatAdm")=num+1
		}		
		
		Set ^TMP($zn,$j,"QryCtlAntBlo","TansLoc",TansID) = ""
	}

	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,"QryCtlAntBlo","TansLoc",xTransID))
		Quit:xTransID=""
		
		Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
		Continue:'$IsObject(objTrans)
		
		Set objPaadm = objTrans.PAEpisodeDr
		Set objTransLoc = objTrans.PATransLocDr
		Continue:'$IsObject(objPaadm)
		Continue:'$IsObject(objTransLoc)
		
		Set EpisodeID =objPaadm.%Id()
		Set LocID =  objTransLoc.%Id()
		Set TransDate = objTrans.PATransDate
		Set OutLocDate= objTrans.PAOutLocDate	
		
	    If $IsObject(objTransLoc.BTGroupDr) {
			Set GroupDr 	= objTransLoc.BTGroupDr.%Id()
			Set GroupCode	= objTransLoc.BTGroupDr.BTCode
			Set GroupDesc	= objTransLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="其他科"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		
	    //科室分组
		If '$d(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"PatAdm"))
			Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"PatAdm")=num+1
		}
		//科室
		If '$d(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"PatAdm"))
			Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"PatAdm")=num+1
		}
	
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
	    Set AntUseInfo   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
		Set IsKSS2Use     = $p(AntUseInfo,"^",5)
		Set IsKSS2CureBlo = $p(AntUseInfo,"^",6)
		Set IsKSS3Use     = $p(AntUseInfo,"^",7)
		Set IsKSS3CureBlo = $p(AntUseInfo,"^",8)
	
		If (IsKSS2Use =1) {
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2Use",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2Use",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2Use")=num+1
			}
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2Use",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2Use",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2Use")=num+1
			}
			If (IsKSS2CureBlo =1) {
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2CureBlo",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2CureBlo",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2CureBlo"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS2CureBlo")=num+1
				}
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2CureBlo",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2CureBlo",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2CureBlo"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2CureBlo")=num+1
				}
			}
		}	
		If (IsKSS3Use =1) {
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3Use",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3Use",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3Use")=num+1
			}
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3Use",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3Use",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3Use")=num+1
			}
			If (IsKSS3CureBlo =1) {
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3CureBlo",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3CureBlo",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3CureBlo"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","Loc",LocID,"KSS3CureBlo")=num+1
				}
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3CureBlo",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3CureBlo",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3CureBlo"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3CureBlo")=num+1
				}
			}
		}	
	}
	
	//同期在病区
    Set ListWardArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"W","","I") //某段时间的在科人数
    For index2=1:1:ListWardArray.Count() {
		Set TransInfo=ListWardArray.GetAt(index2)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 //当天转入不算在内
		//Continue:(Status="A2")                //当天转入当天转出不算在内
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set ^TMP($zn,$j,"QryCtlAntBlo","TansWard",TansID) = ""
	}
	
	Set aTransID = ""
	For {
		Set aTransID = $o(^TMP($zn,$j,"QryCtlAntBlo","TansWard",aTransID))
		Quit:aTransID=""
		
		Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(aTransID)
		Continue:'$IsObject(objTrans)
		
		Set objPaadm = objTrans.PAEpisodeDr
		Set objTransLoc = objTrans.PATransLocDr
		Continue:'$IsObject(objPaadm)
		Continue:'$IsObject(objTransLoc)
		
		Set EpisodeID =objPaadm.%Id()
		Set WardID =  objTransLoc.%Id()
		Set TransDate = objTrans.PATransDate
		Set OutLocDate= objTrans.PAOutLocDate	
	
		If '$d(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"PatAdm"))
			Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"PatAdm")=num+1
		}
		
	   	//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
	    Set AntUseInfo   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
	    Set IsKSS2Use     = $p(AntUseInfo,"^",5)
		Set IsKSS2CureBlo = $p(AntUseInfo,"^",6)
		Set IsKSS3Use     = $p(AntUseInfo,"^",7)
		Set IsKSS3CureBlo = $p(AntUseInfo,"^",8)
	
		If (IsKSS2Use =1) {
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2Use",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2Use",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2Use")=num+1
			}
			
			If (IsKSS2CureBlo =1) {
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2CureBlo",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2CureBlo",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2CureBlo"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS2CureBlo")=num+1
				}
			}
		}	
		If (IsKSS3Use =1) {
			If '$d(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3Use",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3Use",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3Use"))
				Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3Use")=num+1
			}
			
			If (IsKSS3CureBlo =1) {
				If '$d(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3CureBlo",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3CureBlo",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3CureBlo"))
					Set ^TMP($zn,$j,"QryCtlAntBlo","Ward",WardID,"KSS3CureBlo")=num+1
				}
			}
		}	
	}
    
    Set HospInSum=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","PatAdm")) 
	Set HospKSS2Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2Use"))
	Set HospKSS2CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS2CureBlo"))
	Set HospKSS3Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3Use"))
	Set HospKSS3CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","Hosp","KSS3CureBlo"))
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryCtlAntBlo","Loc",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			
		Set GroupDr="",GroupCode="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr 	= objLoc.BTGroupDr.%Id()
			Set GroupCode	= objLoc.BTGroupDr.BTCode
			Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="其他科"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			Set GroupDr 	= objGroup.%Id()
			Set GroupCode	= objGroup.BTCode
		}
		
		Set GroupInSum=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"PatAdm")) 
		Set GroupKSS2Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2Use"))
		Set GroupKSS2CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS2CureBlo"))
		Set GroupKSS3Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3Use"))
		Set GroupKSS3CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","LocGroup",GroupCode,"KSS3CureBlo"))	  
		
		Set LocInSum=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",xLocID,"PatAdm")) 
		Set LocKSS2Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",xLocID,"KSS2Use"))
		Set LocKSS2CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",xLocID,"KSS2CureBlo"))
		Set LocKSS3Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",xLocID,"KSS3Use"))
		Set LocKSS3CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","Loc",xLocID,"KSS3CureBlo"))	   
		    
		Set xSubID = ""
	 	For {
			Set xSubID = $o(^DHCHAI.BT.LocationD(xLocID,"Link",xSubID))
			Quit:xSubID=""
			
			Set xID = xLocID_"||"_xSubID
			Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xID)
			Continue:'$IsObject(objLocLink)
			Continue:'$IsObject(objLocLink.BTLinkLocDr)
			Continue:(+objLocLink.BTIsActive)'=1
			
			Set LinkWardID = objLocLink.BTLinkLocDr.%Id()
			Set LinkWardDesc = objLocLink.BTLinkLocDr.BTDesc2
			Set:LinkWardDesc="" LinkWardDesc = objLocLink.BTLinkLocDr.BTDesc
		    Set:$p(LinkWardDesc,"-",2)'="" LinkWardDesc=$p(LinkWardDesc,"-",2)	
		        
		    Set WardInSum=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",LinkWardID,"PatAdm"))	 
		    Set WardKSS2Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",LinkWardID,"KSS2Use"))
		    Set WardKSS2CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",LinkWardID,"KSS2CureBlo"))
		    Set WardKSS3Use=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",LinkWardID,"KSS3Use"))
		    Set WardKSS3CureBlo=+$g(^TMP($zn,$j,"QryCtlAntBlo","Ward",LinkWardID,"KSS3CureBlo"))
		   
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInSum,LocKSS2Use,LocKSS2CureBlo,LocKSS3Use,LocKSS3CureBlo,LinkWardID,LinkWardDesc,WardInSum,WardKSS2Use,WardKSS2CureBlo,WardKSS3Use,WardKSS3CureBlo,HospInSum,HospKSS2Use,HospKSS2CureBlo,HospKSS3Use,HospKSS3CureBlo,GroupInSum,GroupKSS2Use,GroupKSS2CureBlo,GroupKSS3Use,GroupKSS3CureBlo)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	   
	}
	Kill ^TMP($zn,$j,"QryCtlAntBlo")
	Quit $$$OK
}

ClassMethod QryCtlAntBloClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlAntBloExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlAntBloFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlAntBloExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-07-27
/// Description:  住院患者限制/特殊使用级抗菌药物治疗前血培养送检率统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S190CtlAntBlo","QryCtlAntBloDtl","1","E","","","2016-03-01","2018-03-17")
Query QryCtlAntBloDtl(aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDate:%String,TransTime:%String,OutLocDate:%String,OutLocTime:%String,DrgPoison:%String,IsCureSubmiss:%String") [ SqlProc ]
{
}

ClassMethod QryCtlAntBloDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set:aDateFrom>+$h aDateFrom=""
 	Set:aDateTo>+$h aDateTo=+$h
 	
    Kill ^TMP($zn,$j,"QryCtlAntBloDtl")
	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
    //同期在科
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I") //某段时间的在科人数

    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 //当天转入不算在内
		//Continue:(Status="A2")                //当天转入当天转出不算在内

		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Continue:(aLocIDs'="")&&($listfind(aLocIDs,objLoc.%Id())<1)		
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set GroupDr="",GroupCode="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr 	= objLoc.BTGroupDr.%Id()
			Set GroupCode	= objLoc.BTGroupDr.BTCode
			Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="其他科"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			Set GroupDr 	= objGroup.%Id()
			Set GroupCode	= objGroup.BTCode
		}	
		Continue:(aLocGroup'="")&(aLocGroup'=GroupCode)
		
		Set ^TMP($zn,$j,"QryCtlAntBloDtl",aLocType,TansID) = ""
	}
   
    If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryCtlAntBloDtl","W",xTransID))
			Quit:xTransID=""
			
			Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$IsObject(objTrans)
			
			Set objPaadm = objTrans.PAEpisodeDr
			Set objTransLoc = objTrans.PATransLocDr
			Continue:'$IsObject(objPaadm)
			Continue:'$IsObject(objTransLoc)
			
			Set EpisodeID =objPaadm.%Id()
			Set TransWardID =  objTransLoc.%Id()
			Set TransWardDesc = objTransLoc.BTDesc2
			Set:TransWardDesc="" TransWardDesc = objTransLoc.BTDesc
			Continue:TransWardDesc=""
			Set:$p(TransWardDesc,"-",2)'="" TransWardDesc=$p(TransWardDesc,"-",2)
			
			Set GroupDr="",GroupCode="",GroupDesc=""
			If $IsObject(objTransLoc.BTGroupDr) {
				Set GroupDr 	= objTransLoc.BTGroupDr.%Id()
				Set GroupCode	= objTransLoc.BTGroupDr.BTCode
				Set GroupDesc	= objTransLoc.BTGroupDr.BTDesc	
			}Else {
				Set GroupDesc="其他科"
				Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
				If $IsObject(objGroup) {
					Set GroupDr 	= objGroup.%Id()
					Set GroupCode	= objGroup.BTCode
				}
			}	
			Set TransDate = objTrans.PATransDate
			Set OutLocDate= objTrans.PAOutLocDate	
			
			//当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate =aDateTo
			Set AntUseInfo   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
			Set IsCureSubmiss = $p(AntUseInfo,"^",4)
			Set IsKSS2Use     = $p(AntUseInfo,"^",5)
			Set IsKSS3Use     = $p(AntUseInfo,"^",7)
		
		    Set IsKSS2Use = $s(IsKSS2Use=1:"KSS2",1:"")
			Set IsKSS3Use = $s(IsKSS3Use=1:"KSS3",1:"")
			Set DrgPoison =""
			Set:IsKSS2Use'="" DrgPoison=IsKSS2Use
			Set:IsKSS3Use'="" DrgPoison=IsKSS3Use
			Set IsCureSubmiss = $s(IsCureSubmiss=1:"是",1:"")
			
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime = objTrans.PATransTime
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime =objTrans.PAOutLocTime
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    
		    Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,DrgPoison,IsCureSubmiss)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    
		}
    }
	
	If (aLocType="E") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryCtlAntBloDtl","E",xTransID))
			Quit:xTransID=""
			
			Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$IsObject(objTrans)
			
			Set objPaadm = objTrans.PAEpisodeDr
			Set objTransLoc = objTrans.PATransLocDr
			Continue:'$IsObject(objPaadm)
			Continue:'$IsObject(objTransLoc)
			
			Set EpisodeID =objPaadm.%Id()
			Set LocID =  objTransLoc.%Id()
			Set LocDesc = objTransLoc.BTDesc2
			Set:LocDesc="" LocDesc = objTransLoc.BTDesc
			Continue:LocDesc=""
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			
			Set GroupDr="",GroupCode="",GroupDesc=""
			If $IsObject(objTransLoc.BTGroupDr) {
				Set GroupDr 	= objTransLoc.BTGroupDr.%Id()
				Set GroupCode	= objTransLoc.BTGroupDr.BTCode
				Set GroupDesc	= objTransLoc.BTGroupDr.BTDesc	
			}Else {
				Set GroupDesc="其他科"
				Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
				If $IsObject(objGroup) {
					Set GroupDr 	= objGroup.%Id()
					Set GroupCode	= objGroup.BTCode
				}
			}			
			Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    Set (TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,TransDateTime,OutLocDateTime)=""
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
			
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xDate,xID))
					Quit:xID=""
				
					Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
					Continue:'$IsObject(objTrans)
					Continue:'$IsObject(objTrans.PATransLocDr)
					
					Set TransWardID=objTrans.PATransLocDr.%Id()
					Set TransWardDesc=objTrans.PATransLocDr.BTDesc2
					Set:TransWardDesc="" TransWardDesc=objTrans.PATransLocDr.BTDesc
				    Set:TransWardDesc["-" TransWardDesc=$p(TransWardDesc,"-",2)
				
					Set TransDate=objTrans.PATransDate
					Set OutLocDate=objTrans.PAOutLocDate
					//当前未转出，截止为查询结束日期
					Set EndDate = OutLocDate
					Set:EndDate="" EndDate =aDateTo
					Set AntUseInfo   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
					Set IsCureSubmiss = $p(AntUseInfo,"^",4)
					Set IsKSS2Use     = $p(AntUseInfo,"^",5)
					Set IsKSS3Use     = $p(AntUseInfo,"^",7)
				
				    Set IsKSS2Use = $s(IsKSS2Use=1:"KSS2",1:"")
					Set IsKSS3Use = $s(IsKSS3Use=1:"KSS3",1:"")
					Set DrgPoison =""
					Set:IsKSS2Use'="" DrgPoison=IsKSS2Use
					Set:IsKSS3Use'="" DrgPoison=IsKSS3Use
					Set IsCureSubmiss = $s(IsCureSubmiss=1:"是",1:"")
					
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	
			    	Set Data=PatData_$lb(xID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,DrgPoison,IsCureSubmiss)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1	    

				}
			}
		}
    }
	
	Kill ^TMP($zn,$j,"QryCtlAntBloDtl")
	Quit $$$OK
}

ClassMethod QryCtlAntBloDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlAntBloDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlAntBloDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlAntBloDtlExecute ]
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

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime
	
	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-07-20
/// Description:  查询患者血培养送检列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.LabVisitNumber
/// Input:        aEpisodeID：就诊ID
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S190CtlAntBlo","QryBlooSubInfo","344","2016-01-01","2018-07-20")
Query QryBlooSubInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeNo:%String,OrdTSDesc:%String,Specimen:%String,LocDesc:%String,CollDate:%String,VisitReportID:%String,AuthDate:%String,ResultList:%String") [ SqlProc ]
{
}

ClassMethod QryBlooSubInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:aEpisodeID="" $$$OK
	Set:aDateTo="" aDateTo=+$h
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 		
	Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
	
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		
		Continue:(aDateFrom'="")&(CollDate<aDateFrom)
		Continue:(aDateTo'="")&(CollDate>aDateTo)
	     
		Set SCode	 	= objVisitNumber.LabSCode
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo
		Set Specimen 	= objVisitNumber.LabSpecimen
		Continue:Specimen'["血"
		
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
	    Set xTestSetDesc = "",checkFlg=0
		For {
			Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			
			Set objTestSetCat = ##class(DHCHAI.DP.LabTestSetMap).GetTSCatByTestSet(SCode,xTestSetDesc)
			Continue:'$isobject(objTestSetCat)
			Continue:objTestSetCat.BTDesc'="微生物送检"
			Set checkFlg = 1
		}
		Continue:checkFlg=0	//不是送检标本	
		
        Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set Status = objVisitReport.LabStatus
				Continue:Status=6	//作废
				Set IsActive = objVisitReport.LabIsActive
				Continue:IsActive=0
				
				Set VisitReportID = objVisitReport.%Id()
				Set LabReportID = objVisitReport.LabReportID
				Set LabRepOrder = objVisitReport.LabRepOrder
				Set AuthDate=objVisitReport.LabAuthDate
				Set AuthTime=objVisitReport.LabAuthTime
				Set:AuthDate'="" AuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
				
				Set objVisitTestSet=objVisitReport.LabTestSetDr
				Continue:'$IsObject(objVisitTestSet)
				Set TestSetDesc=objVisitTestSet.LabTestSetDesc
				Set OrdTsDesc=objVisitTestSet.LabOrdTSDesc
				
				Set CollDateR=CollDate
				Set AuthDateR=AuthDate
				
				Set:CollTime'="" CollDateR=CollDate_" "_CollTime
				Set:AuthTime'="" AuthDateR=AuthDate_" "_AuthTime
				
				Set xResultID="",ResultList=""
				For {
					Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
					Quit:xResultID=""
					Set objResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
					Continue:'$IsObject(objResult)
					Set RstFormat=objResult.LabRstFormat
					Continue:RstFormat=""
					Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
					Continue:MapRstFormat=""
					Continue:MapRstFormat'="M"
					Set Bacteria=objResult.LabResult
					Continue:Bacteria=""
					Continue:(Bacteria["阴性")||(Bacteria["-")
					Continue:(Bacteria["大于3种菌")
					Continue:(Bacteria["无")&&(Bacteria["生长")
					Continue:(Bacteria["未见")&&(Bacteria["菌")
					Continue:(Bacteria["未检出")&&(Bacteria["菌")
					Continue:$listfind(ResultList,Bacteria)>0  //判断是否同种菌
					Set ResultList=ResultList_$lb(Bacteria)		

				}
				
				Set Data=$lb(xVisitNumberDr,EpisodeNo,OrdTsDesc,Specimen,LocDesc,CollDateR,VisitReportID,AuthDateR)_ResultList
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1

			}
		}
		
	}
	
	Quit $$$OK
}

ClassMethod QryBlooSubInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBlooSubInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBlooSubInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBlooSubInfoExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2018-07-26
/// Description:  判断查询时段是否限制/特殊使用级治疗前送检
/// Table：       DHCHAI.DP.OEOrdItem，DHCHAI.DP.LabVisitNumber
/// Input:        aEpisodeID：就诊ID
/// return:       
/// w ##class(DHCHAI.STAT.S190CtlAntBlo).GetAntUseInfo("379","2016-01-01","2018-07-20")
ClassMethod GetAntUseInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return =0
	Quit:aEpisodeID="" return
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
    Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
 	Set InstrucList=","_InstrucList_","
	
    Set (IsAntUse,IsCureUse,IsSubmiss,IsCureSubmiss,IsKSS3Use,IsKSS2Use,IsKSS3CureBloodSubmiss,IsKSS2CureBloodSubmiss)=0
	
	// 首次用药,首次治疗用药,首次特殊治疗用药,首次限制治疗用药
	Set (firstUseDate,fistCureDate,fistKSS3CureDate,fistKSS2CureDate)=""
	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
			Quit:xSttDate=""
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
				
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive'=1
	           
	            Set SttDate = objOrdItem.OESttDate
				Set EndDate = objOrdItem.OEXDate
	            Set Priority = objOrdItem.OEPriority	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
			   
	            If PriorityMap="N"{
					Set EndDate = SttDate
				}else{
					If EndDate=""{		// 长期医嘱未停止只计算到传入结束日期
						Set EndDate = aDateTo
					}
				}
				Continue:EndDate<aDateFrom  // 停药日期在传入日期前
				Continue:SttDate>aDateTo	// 用药日期在传入日期后
               
				Set Instruc = objOrdItem.OEInstruc //给药途径
				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				//Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药	
				//Continue:'$listfind(InstrucList,InstrucMap)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				Set IsAntUse = 1
				
				Set UsePurpose = objOrdItem.OEAntUsePurpose	// 用药目的
				Set:UsePurpose="" UsePurpose="其他"
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Continue:UsePurposeMapStr=""
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
				Set:UsePurpose="治疗" IsCureUse=1
				
				// 首次用药日期
				If firstUseDate=""{
					Set firstUseDate = SttDate
				}else{
					Set:firstUseDate>SttDate firstUseDate = SttDate
				}
				
				// 首次治疗用药日期
				If UsePurpose = "治疗"{
					If fistCureDate=""{
						Set fistCureDate = SttDate
					}else{
						Set:fistCureDate>SttDate fistCureDate = SttDate
					}
				}
				Set DrgPoison = objOrdItem.OEAntDrgPoison	//管制分类
				Set:DrgPoison="KSS3" IsKSS3Use=1	//使用特殊级
				Set:DrgPoison="KSS2" IsKSS2Use=1	//使用限制级
				// 首次特殊治疗用药日期
				If (DrgPoison="KSS3")&&(UsePurpose="治疗"){
					If fistKSS3CureDate=""{
						Set fistKSS3CureDate = SttDate
					}else{
						Set:fistKSS3CureDate>SttDate fistKSS3CureDate = SttDate
					}
				}
				// 首次限制治疗用药日期
				If (DrgPoison="KSS2")&&(UsePurpose="治疗"){
					If fistKSS2CureDate=""{
						Set fistKSS2CureDate = SttDate
					}else{
						Set:fistKSS2CureDate>SttDate fistKSS2CureDate = SttDate
					}
				}
				
			}
		}
	}
	If (IsAntUse=1) {
		Set xVisitNumberDr=""
		For {
			Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
			Quit:xVisitNumberDr=""
			
			Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
			Continue:'$isobject(objVisitNumber)
			Continue:objVisitNumber.LabIsActive'=1
			
			Set SCode   = objVisitNumber.LabSCode
			Set CollDate=objVisitNumber.LabCollDate		//采集日期
			Set RecDate =objVisitNumber.LabRecDate		//接收日期
			Set Specimen= objVisitNumber.LabSpecimen
			Continue:Specimen'["血"
			Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
			Continue:CollDate=""
		
			Set xTestSetDesc = "",checkFlg=0
			For {
				Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
				Quit:xTestSetDesc=""
				
				Set objTestSetCat = ##class(DHCHAI.DP.LabTestSetMap).GetTSCatByTestSet(SCode,xTestSetDesc)
				Continue:'$isobject(objTestSetCat)
				Continue:objTestSetCat.BTDesc'="微生物送检"
				Set checkFlg = 1
			}
			Continue:checkFlg=0	//不是送检标本
			
			Set IsSubmiss = 1
			If CollDate<=fistCureDate{	//治疗前送检
				Set IsCureSubmiss = 1
			}
			If CollDate<=fistKSS3CureDate{	//特殊治疗前送检
				Set IsKSS3CureBloodSubmiss = 1
			}
			If CollDate<=fistKSS2CureDate{	//限制治疗前送检
				Set IsKSS2CureBloodSubmiss = 1
			}
		}
	}
	
	Set return = IsAntUse_"^"_IsCureUse_"^"_IsSubmiss_"^"_IsCureSubmiss_"^"_IsKSS2Use_"^"_IsKSS2CureBloodSubmiss_"^"_IsKSS3Use_"^"_IsKSS3CureBloodSubmiss
	Quit return
}

}

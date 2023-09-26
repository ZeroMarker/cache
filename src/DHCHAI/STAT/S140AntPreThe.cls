/// 名称: DHCHAI.STAT.S140AntPreThe
/// 描述: 抗菌药物预防/治疗使用构成比统计表
/// 编写者：pylian
/// 编写日期: 2018-07-23
Class DHCHAI.STAT.S140AntPreThe Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-23
/// Description:  医院抗菌药物预防/治疗使用构成比统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S140AntPreThe","QryHospAntPreThe","1","2016-03-01","2018-03-17")
Query QryHospAntPreThe(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "HospIDs:%String,HospInSum:%Integer,HospAntSum:%Integer,HospCureSum:%Integer,HospPreSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryHospAntPreTheExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
 	
    Kill ^TMP($zn,$j,"QryHospAntPreThe")
   
    //同期在院
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") //某天的在院人数
	For index1=1:1:ListArray.Count() {
		Set EpisodeID=ListArray.GetAt(index1)	
		Continue:EpisodeID=""
		
	    Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
		Continue:'$isobject(objPaadm) 
	
	    Set num=+$g(^TMP($zn,$j,"QryHospAntPreThe","PatAdm"))
		Set ^TMP($zn,$j,"QryHospAntPreThe","PatAdm")=num+1
		Set ^TMP($zn,$j,"QryHospAntPreThe","PatAdm",EpisodeID) = ""
		
		Set AntUseInfo   =..GetAntUseInfo(EpisodeID,aDateFrom,aDateTo)
		Set IsUseAnt  = $p(AntUseInfo,"^",1)
		Set IsCureUse = $p(AntUseInfo,"^",2)
		Set IsPreUse  = $p(AntUseInfo,"^",3)
		If (IsUseAnt=1) {
			Set num=+$g(^TMP($zn,$j,"QryHospAntPreThe","AntUse"))
			Set ^TMP($zn,$j,"QryHospAntPreThe","AntUse")=num+1
			Set ^TMP($zn,$j,"QryHospAntPreThe","AntUse",EpisodeID) = ""
			
			If (IsCureUse=1) {
				Set num=+$g(^TMP($zn,$j,"QryHospAntPreThe","CureUse"))
				Set ^TMP($zn,$j,"QryHospAntPreThe","CureUse")=num+1
			}
			If (IsPreUse=1) {
				Set num=+$g(^TMP($zn,$j,"QryHospAntPreThe","PreUse"))
				Set ^TMP($zn,$j,"QryHospAntPreThe","PreUse")=num+1
			}
		}
	}
	
	Set HospInSum=+$g(^TMP($zn,$j,"QryHospAntPreThe","PatAdm"))	 
	Set HospAntSum=+$g(^TMP($zn,$j,"QryHospAntPreThe","AntUse"))
	Set HospCureSum=+$g(^TMP($zn,$j,"QryHospAntPreThe","CureUse"))
    Set HospPreSum=+$g(^TMP($zn,$j,"QryHospAntPreThe","PreUse"))
    	
    Set Data=$lb(aHospIDs,HospInSum,HospAntSum,HospCureSum,HospPreSum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,"QryHospAntPreThe")
	Quit $$$OK
}

ClassMethod QryHospAntPreTheClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospAntPreTheExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospAntPreTheFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospAntPreTheExecute ]
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
/// CreatDate：   2018-07-23
/// Description:  抗菌药物预防/治疗使用构成比统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S140AntPreThe","QryAntPreThe","1","2016-03-01","2018-03-17")
Query QryAntPreThe(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInSum:%Integer,LocAntSum:%Integer,LocCureSum:%Integer,LocPreSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInSum:%Integer,WardAntSum:%Integer,WardCureSum:%Integer,WardPreSum:%Integer,HospInSum:%Integer,HospAntSum:%Integer,HospCureSum:%Integer,HospPreSum:%Integer,GroupInSum:%Integer,GroupAntSum:%Integer,GroupCureSum:%Integer,GroupPreSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryAntPreTheExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
 	
    Kill ^TMP($zn,$j,"QryAntPreThe")
	
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
		
		Set (IsUseAnt,IsCureUse,IsPreUse)=0		
		If '$d(^TMP($zn,$j,"QryAntPreThe","Hosp","AntUseInfo",Paadm))
		{
			Set AntUseInfo   =..GetAntUseInfo(Paadm,aDateFrom,aDateTo)  //不重复判断
			Set IsUseAnt  = $p(AntUseInfo,"^",1)
			Set IsCureUse = $p(AntUseInfo,"^",2)
			Set IsPreUse  = $p(AntUseInfo,"^",3)
		}
		Set ^TMP($zn,$j,"QryAntPreThe","Hosp","AntUseInfo",Paadm)=""
		
		If (IsUseAnt=1) {
			If '$d(^TMP($zn,$j,"QryAntPreThe","Hosp","AntUse",Paadm))
			{   
				Set ^TMP($zn,$j,"QryAntPreThe","Hosp","AntUse",Paadm)=""
				Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","AntUse"))
				Set ^TMP($zn,$j,"QryAntPreThe","Hosp","AntUse")=num+1
			}
			If (IsCureUse =1) {
				If '$d(^TMP($zn,$j,"QryAntPreThe","Hosp","CureUse",Paadm))
				{   
					Set ^TMP($zn,$j,"QryAntPreThe","Hosp","CureUse",Paadm)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","CureUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","Hosp","CureUse")=num+1
				}
			}
			If (IsPreUse =1) {
				If '$d(^TMP($zn,$j,"QryAntPreThe","Hosp","PreUse",Paadm))
				{   
					Set ^TMP($zn,$j,"QryAntPreThe","Hosp","PreUse",Paadm)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","PreUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","Hosp","PreUse")=num+1
				}
			}
		}	
			
		If '$d(^TMP($zn,$j,"QryAntPreThe","Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,"QryAntPreThe","Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","PatAdm"))
			Set ^TMP($zn,$j,"QryAntPreThe","Hosp","PatAdm")=num+1
		}		
		
		Set ^TMP($zn,$j,"QryAntPreThe","TansLoc",TansID) = ""
	}
    
	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,"QryAntPreThe","TansLoc",xTransID))
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
		
		//科室分组
		If '$d(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PatAdm"))
			Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PatAdm")=num+1
		}
		//科室
		If '$d(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PatAdm"))
			Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PatAdm")=num+1
		}
		
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
		Set AntUseInfo   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
		Set IsUseAnt  = $p(AntUseInfo,"^",1)
		Set IsCureUse = $p(AntUseInfo,"^",2)
		Set IsPreUse  = $p(AntUseInfo,"^",3)
		
		If (IsUseAnt=1) {
			If '$d(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"AntUse",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"AntUse"))
				Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"AntUse")=num+1
			}
			If '$d(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"AntUse",EpisodeID))
			{
				Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"AntUse"))
				Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"AntUse")=num+1
			}
			
			If (IsCureUse =1) {
				If '$d(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"CureUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"CureUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"CureUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"CureUse")=num+1
				}
				If '$d(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"CureUse",EpisodeID))
				{
					Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"CureUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"CureUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"CureUse")=num+1
				}
			}
			If (IsPreUse =1) {
				If '$d(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PreUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PreUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PreUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","Loc",LocID,"PreUse")=num+1
				}
				If '$d(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PreUse",EpisodeID))
				{
					Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PreUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PreUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PreUse")=num+1
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
		
		Set ^TMP($zn,$j,"QryAntPreThe","TansWard",TansID) = ""
	}
	
	Set aTransID = ""
	For {
		Set aTransID = $o(^TMP($zn,$j,"QryAntPreThe","TansWard",aTransID))
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
	
		If '$d(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PatAdm"))
			Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PatAdm")=num+1
		}
		
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
	    Set AntUseInfo   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
		Set IsUseAnt  = $p(AntUseInfo,"^",1)
		Set IsCureUse = $p(AntUseInfo,"^",2)
		Set IsPreUse  = $p(AntUseInfo,"^",3)
		If (IsUseAnt=1) {
			If '$d(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"AntUse",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"AntUse"))
				Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"AntUse")=num+1
			}			
			If (IsCureUse =1) {
				If '$d(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"CureUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"CureUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"CureUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"CureUse")=num+1
				}
			}
			If (IsPreUse =1) {
				If '$d(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PreUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PreUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PreUse"))
					Set ^TMP($zn,$j,"QryAntPreThe","Ward",WardID,"PreUse")=num+1
				}
			}
		}	
		
	}
    
	Set HospInSum=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","PatAdm")) 
	Set HospAntSum=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","AntUse"))
	Set HospCureSum=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","CureUse"))
	Set HospPreSum=+$g(^TMP($zn,$j,"QryAntPreThe","Hosp","PreUse"))
		 
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryAntPreThe","Loc",xLocID))
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
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		
		Set GroupInSum=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PatAdm")) 
		Set GroupAntSum=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"AntUse"))
		Set GroupCureSum=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"CureUse"))
		Set GroupPreSum=+$g(^TMP($zn,$j,"QryAntPreThe","LocGroup",GroupCode,"PreUse"))
		
		Set LocInSum=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",xLocID,"PatAdm")) 
		Set LocAntSum=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",xLocID,"AntUse"))
		Set LocCureSum=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",xLocID,"CureUse"))
		Set LocPreSum=+$g(^TMP($zn,$j,"QryAntPreThe","Loc",xLocID,"PreUse"))
	
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
		        
		    Set WardInSum=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",LinkWardID,"PatAdm"))	 
			Set WardAntSum=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",LinkWardID,"AntUse"))		  
		    Set WardCureSum=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",LinkWardID,"CureUse"))
		    Set WardPreSum=+$g(^TMP($zn,$j,"QryAntPreThe","Ward",LinkWardID,"PreUse"))
		    
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInSum,LocAntSum,LocCureSum,LocPreSum,LinkWardID,LinkWardDesc,WardInSum,WardAntSum,WardCureSum,WardPreSum,HospInSum,HospAntSum,HospCureSum,HospPreSum,GroupInSum,GroupAntSum,GroupCureSum,GroupPreSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	   
	}
	Kill ^TMP($zn,$j,"QryAntPreThe")
	Quit $$$OK
}

ClassMethod QryAntPreTheClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntPreTheExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntPreTheFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntPreTheExecute ]
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
/// Description:  住院患者抗菌药物使用率明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S140AntPreThe","QryAntPreTheDtl","1","E","","","2016-03-01","2018-03-17")
Query QryAntPreTheDtl(aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDate:%String,TransTime:%String,OutLocDate:%String,OutLocTime:%String,IsUseAnt:%String,IsPreUse:%String,IsCureUse:%String") [ SqlProc ]
{
}

ClassMethod QryAntPreTheDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
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
 	Set aLocType=$zcvt(aLocType,"U")
 		
    Kill ^TMP($zn,$j,"QryAntPreTheDtl")
	
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
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}	
		Continue:(aLocGroup'="")&(aLocGroup'=GroupCode)
		
		Set ^TMP($zn,$j,"QryAntPreTheDtl",aLocType,TansID) = ""
	}
   
    If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryAntPreTheDtl","W",xTransID))
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
			Set IsUseAnt  = $p(AntUseInfo,"^",1)
			Set IsCureUse = $p(AntUseInfo,"^",2)
			Set IsPreUse  = $p(AntUseInfo,"^",3)
		    Set IsUseAnt = $s(IsUseAnt=1:"是",1:"")
			Set IsCureUse = $s(IsCureUse=1:"是",1:"")
			Set IsPreUse = $s(IsPreUse=1:"是",1:"")
			
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime = objTrans.PATransTime
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime =objTrans.PAOutLocTime
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    
		    Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,IsUseAnt,IsPreUse,IsCureUse)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    
		}
    }
	
	If (aLocType="E") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryAntPreTheDtl","E",xTransID))
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
					Set IsUseAnt  = $p(AntUseInfo,"^",1)
					Set IsCureUse = $p(AntUseInfo,"^",2)
					Set IsPreUse  = $p(AntUseInfo,"^",3)
				    Set IsUseAnt = $s(IsUseAnt=1:"是",1:"")
					Set IsCureUse = $s(IsCureUse=1:"是",1:"")
					Set IsPreUse = $s(IsPreUse=1:"是",1:"")
					
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	
			    	Set Data=PatData_$lb(xID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,IsUseAnt,IsPreUse,IsCureUse)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1	    

				}
			}
		}
    }
    
	Kill ^TMP($zn,$j,"QryAntPreTheDtl")
	Quit $$$OK
}

ClassMethod QryAntPreTheDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntPreTheDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntPreTheDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntPreTheDtlExecute ]
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
/// CreatDate：   2018-07-23
/// Description:  判断查询期间治疗/预防使用抗菌药物（全身用药）
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID：就诊ID
/// return:        
/// w ##class(DHCHAI.STAT.S140AntPreThe).GetAntUseInfo("379","2016-01-01","2018-07-23")
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
	
	Set (IsUseAnt,IsCureUse,IsPreUse) =0
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
				Set IsUseAnt = 1
				
				Set UsePurpose = objOrdItem.OEAntUsePurpose	// 用药目的
				Set:UsePurpose="" UsePurpose="其他"
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Continue:UsePurposeMapStr=""
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
				Set:UsePurpose="治疗" IsCureUse=1
				Set:UsePurpose="预防" IsPreUse=1	
			}
		}
	}
	Set return =IsUseAnt_"^"_IsCureUse_"^"_IsPreUse
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-07-23
/// Description:  抗菌药物联用构成比统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S140AntPreThe","QryAntPreCom","1","2018-03-01","2018-03-17")
Query QryAntPreCom(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInSum:%String,LocAntSum:%String,LocDLUseSum:%String,LocELUseSum:%String,LocSLUseSum:%String,LocSILUseSum:%String,LocMLUseSum:%String,LinkWardID:%String,LinkWardDesc:%String,WardInSum:%String,WardAntSum:%String,WardDLUseSum:%String,WardELUseSum:%String,WardSLUseSum:%String,WardSILUseSum:%String,WardMLUseSum:%String,HospInSum:%String,HospAntSum:%String,HospDLUseSum:%String,HospELUseSum:%String,HospSLUseSum:%String,HospSILUseSum:%String,HospMLUseSum:%String,GroupInSum:%String,GroupAntSum:%String,GroupDLUseSum:%String,GroupELUseSum:%String,GroupSLUseSum:%String,GroupSILUseSum:%String,GroupMLUseSum:%String") [ SqlProc ]
{
}

ClassMethod QryAntPreComExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
 	
 	Set QryAntIndexName = "QryAntPreCom"
    Kill ^TMP($zn,$j,QryAntIndexName)
	
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
		Set (IsUseAnt,ComNums)=0		
		If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","AntUseInfo",Paadm))
		{
			Set AntUseInfo   =..GetAntUseInfoCom(Paadm,aDateFrom,aDateTo)  //不重复判断
			Set IsUseAnt  = $p(AntUseInfo,"^",1)
			Set ComNums = $p(AntUseInfo,"^",2)
		}
		Set ^TMP($zn,$j,QryAntIndexName,"Hosp","AntUseInfo",Paadm)=""
		
		If (IsUseAnt=1) {
			If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","AntUse",Paadm))
			{   
				Set ^TMP($zn,$j,QryAntIndexName,"Hosp","AntUse",Paadm)=""
				Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","AntUse"))
				Set ^TMP($zn,$j,QryAntIndexName,"Hosp","AntUse")=num+1
			}
			If (ComNums =1) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","DLUse",Paadm))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","DLUse",Paadm)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","DLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","DLUse")=num+1
				}
			}
			elseIf (ComNums =2) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","ELUse",Paadm))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","ELUse",Paadm)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","ELUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","ELUse")=num+1
				}
			}
			elseIf (ComNums =3) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","SLUse",Paadm))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","SLUse",Paadm)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","SLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","SLUse")=num+1
				}
			}
			elseIf (ComNums =4) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","SILUse",Paadm))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","SILUse",Paadm)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","SILUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","SILUse")=num+1
				}
			}
			elseIf (ComNums >4) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","MLUse",Paadm))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","MLUse",Paadm)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","MLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Hosp","MLUse")=num+1
				}
			}
		}	
			
		If '$d(^TMP($zn,$j,QryAntIndexName,"Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,QryAntIndexName,"Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","PatAdm"))
			Set ^TMP($zn,$j,QryAntIndexName,"Hosp","PatAdm")=num+1
		}		
		
		Set ^TMP($zn,$j,QryAntIndexName,"TansLoc",TansID) = ""
	}
    
	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,QryAntIndexName,"TansLoc",xTransID))
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
		
		//科室分组
		If '$d(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"PatAdm"))
			Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"PatAdm")=num+1
		}
		//科室
		If '$d(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"PatAdm"))
			Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"PatAdm")=num+1
		}
		
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate = aDateTo
		Set:OutLocDate>aDateTo EndDate = aDateTo
		Set FormDate = aDateFrom
		Set:TransDate>aDateFrom FormDate=TransDate  //查询开始日期大于转科日期时
		Set AntUseInfo   =..GetAntUseInfoCom(EpisodeID,FormDate,EndDate)
		Set IsUseAnt  = $p(AntUseInfo,"^",1)
		Set ComNums = $p(AntUseInfo,"^",2)
		
		If (IsUseAnt=1) {
			If '$d(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"AntUse",EpisodeID))
			{   
				Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"AntUse"))
				Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"AntUse")=num+1
			}
			If '$d(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"AntUse",EpisodeID))
			{
				Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"AntUse"))
				Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"AntUse")=num+1
			}
			
			If (ComNums =1) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"DLUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"DLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"DLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"DLUse")=num+1
				}
				If '$d(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"DLUse",EpisodeID))
				{
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"DLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"DLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"DLUse")=num+1
				}
			}
			ElseIf (ComNums =2) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"ELUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"ELUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"ELUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"ELUse")=num+1
				}
				If '$d(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"ELUse",EpisodeID))
				{
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"ELUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"ELUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"ELUse")=num+1
				}
			}
			ElseIf (ComNums =3) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SLUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SLUse")=num+1
				}
				If '$d(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SLUse",EpisodeID))
				{
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SLUse")=num+1
				}
			}
			ElseIf (ComNums =4) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SILUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SILUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SILUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"SILUse")=num+1
				}
				If '$d(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SILUse",EpisodeID))
				{
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SILUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SILUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SILUse")=num+1
				}
			}
			ElseIf (ComNums>4) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"MLUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"MLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"MLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Loc",LocID,"MLUse")=num+1
				}
				If '$d(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"MLUse",EpisodeID))
				{
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"MLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"MLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"MLUse")=num+1
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
		Set BFlg = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransBedByDate(Paadm,Date,Date)
		Continue:BFlg'="1"
		Set ^TMP($zn,$j,QryAntIndexName,"TansWard",TansID) = ""
	}
	
	Set aTransID = ""
	For {
		Set aTransID = $o(^TMP($zn,$j,QryAntIndexName,"TansWard",aTransID))
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
	
		If '$d(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"PatAdm"))
			Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"PatAdm")=num+1
		}
		
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate = aDateTo
		Set:OutLocDate>aDateTo EndDate = aDateTo
		Set FormDate = aDateFrom
		Set:TransDate>aDateFrom FormDate=TransDate  //查询开始日期大于转科日期时
	    Set AntUseInfo   =..GetAntUseInfoCom(EpisodeID,FormDate,EndDate)
		Set IsUseAnt  = $p(AntUseInfo,"^",1)
		Set ComNums = $p(AntUseInfo,"^",2)
		If (IsUseAnt=1) {
			If '$d(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"AntUse",EpisodeID))
			{   
				Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"AntUse"))
				Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"AntUse")=num+1
			}			
			If (ComNums =1) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"DLUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"DLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"DLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"DLUse")=num+1
				}
			}
			ElseIf (ComNums =2) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"ELUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"ELUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"ELUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"ELUse")=num+1
				}
			}
			ElseIf (ComNums =3) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SLUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SLUse")=num+1
				}
			}
			ElseIf (ComNums =4) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SILUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SILUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SILUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"SILUse")=num+1
				}
			}
			ElseIf (ComNums >4) {
				If '$d(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"MLUse",EpisodeID))
				{   
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"MLUse",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"MLUse"))
					Set ^TMP($zn,$j,QryAntIndexName,"Ward",WardID,"MLUse")=num+1
				}
			}
		}	
		
	}
    
	Set HospInSum=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","PatAdm")) 
	Set HospAntSum=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","AntUse"))
	Set HospDLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","DLUse"))
	Set HospELUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","ELUse"))
	Set HospSLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","SLUse"))
	Set HospSILUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","SILUse"))
	Set HospMLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Hosp","MLUse"))
		 
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID))
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
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		
		Set GroupInSum=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"PatAdm")) 
		Set GroupAntSum=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"AntUse"))
		Set GroupDLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"DLUse"))
		Set GroupELUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"ELUse"))
		Set GroupSLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SLUse"))
		Set GroupSILUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"SILUse"))
		Set GroupMLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"LocGroup",GroupCode,"MLUse"))
		
		Set LocInSum=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID,"PatAdm")) 
		Set LocAntSum=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID,"AntUse"))
		Set LocDLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID,"DLUse"))
		Set LocELUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID,"ELUse"))
		Set LocSLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID,"SLUse"))
		Set LocSILUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID,"SILUse"))
		Set LocMLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Loc",xLocID,"MLUse"))
		
	
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
		        
		    Set WardInSum=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",LinkWardID,"PatAdm"))	 
			Set WardAntSum=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",LinkWardID,"AntUse"))		  
		    Set WardDLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",LinkWardID,"DLUse"))
		    Set WardELUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",LinkWardID,"ELUse"))
		    Set WardSLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",LinkWardID,"SLUse"))
		    Set WardSILUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",LinkWardID,"SILUse"))
		    Set WardMLUseSum=+$g(^TMP($zn,$j,QryAntIndexName,"Ward",LinkWardID,"MLUse"))
		    
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInSum,LocAntSum,LocDLUseSum,LocELUseSum,LocSLUseSum,LocSILUseSum,LocMLUseSum)
		    Set Data=Data_$lb(LinkWardID,LinkWardDesc,WardInSum,WardAntSum,WardDLUseSum,WardELUseSum,WardSLUseSum,WardSILUseSum,WardMLUseSum)
		    Set Data=Data_$lb(HospInSum,HospAntSum,HospDLUseSum,HospELUseSum,HospSLUseSum,HospSILUseSum,HospMLUseSum)
		    Set Data=Data_$lb(GroupInSum,GroupAntSum,GroupDLUseSum,GroupELUseSum,GroupSLUseSum,GroupSILUseSum,GroupMLUseSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1		    
	 	}
	   
	}
	Kill ^TMP($zn,$j,QryAntIndexName)
	Quit $$$OK
}

ClassMethod QryAntPreComClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntPreComExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntPreComFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntPreComExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-07-23
/// Description:  判断查询期间联用情况
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID：就诊ID
/// return:        
/// w ##class(DHCHAI.STAT.S140AntPreThe).GetAntUseInfoCom("379","2016-01-01","2018-07-23")
ClassMethod GetAntUseInfoCom(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return =0
	Quit:aEpisodeID="" return
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	Set MthIndexName = "GetAntUseInfoCom"
	Kill ^TMP($zn,$j,MthIndexName)
	
	Set (IsUseAnt,ComNums)=0
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
				
				Set:EndDate>aDateTo EndDate = aDateTo
				Set:SttDate<aDateFrom SttDate = aDateFrom
				
				For xDate=SttDate:1:EndDate {
					Set GenName = objOrdItem.OEGeneric  //通用名
					if '$d(^TMP($zn,$j,MthIndexName,aEpisodeID,xDate,GenName))
					{
						Set ^TMP($zn,$j,MthIndexName,aEpisodeID,xDate,GenName)=""
						Set Nums = +$g(^TMP($zn,$j,MthIndexName,aEpisodeID,xDate))
						Set ^TMP($zn,$j,MthIndexName,aEpisodeID,xDate)=Nums+1  //某日抗菌药物数量
					}					
				}				
			}
		}
	}
	Set xDate= ""
	For {
		Set xDate = $o(^TMP($zn,$j,MthIndexName,aEpisodeID,xDate))	
		Quit:xDate=""
		Set IsUseAnt = 1
		Set RstNums = +$g(^TMP($zn,$j,MthIndexName,aEpisodeID,xDate))
		Set:ComNums<RstNums ComNums = RstNums
	}
	Set return =IsUseAnt_"^"_ComNums
	Kill ^TMP($zn,$j,MthIndexName)
	Quit return
}

}

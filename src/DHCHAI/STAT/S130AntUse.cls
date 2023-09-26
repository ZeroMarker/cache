/// 名称: DHCHAI.STAT.S130AntUse
/// 描述: 住院患者抗菌药物使用率统计表
/// 编写者：pylian
/// 编写日期: 2018-07-20
Class DHCHAI.STAT.S130AntUse Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-20
/// Description:  医院住院患者抗菌药物使用率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S130AntUse","QryHospAntUse","1","2016-03-01","2018-03-17")
Query QryHospAntUse(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "HospIDs:%String,HospInSum:%Integer,HospAntSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryHospAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
 	
    Kill ^TMP($zn,$j,"QryHospAntUse")
   
    //同期在院
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") //某天的在院人数
	For index1=1:1:ListArray.Count() {
		Set EpisodeID=ListArray.GetAt(index1)	
		Continue:EpisodeID=""
		
	    Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
		Continue:'$isobject(objPaadm) 
	
	    Set num=+$g(^TMP($zn,$j,"QryHospAntUse","PatAdm"))
		Set ^TMP($zn,$j,"QryHospAntUse","PatAdm")=num+1
		Set ^TMP($zn,$j,"QryHospAntUse","PatAdm",EpisodeID) = ""
		
		Set AntUseFlg   =..GetAntUseInfo(EpisodeID,aDateFrom,aDateTo)
		If (AntUseFlg=1) {
			Set num=+$g(^TMP($zn,$j,"QryHospAntUse","AntUse"))
			Set ^TMP($zn,$j,"QryHospAntUse","AntUse")=num+1
			Set ^TMP($zn,$j,"QryHospAntUse","AntUse",EpisodeID) = ""
		}
		
	}
	
	Set HospInSum=+$g(^TMP($zn,$j,"QryHospAntUse","PatAdm"))	 
	Set HospAntSum=+$g(^TMP($zn,$j,"QryHospAntUse","AntUse"))
   
    Set Data=$lb(aHospIDs,HospInSum,HospAntSum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,"QryHospAntUse")
	Quit $$$OK
}

ClassMethod QryHospAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospAntUseExecute ]
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
/// CreatDate：   2018-07-20
/// Description:  医院住院患者抗菌药物使用率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S130AntUse","QryAntUse","1","2016-03-01","2018-03-17")
Query QryAntUse(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInSum:%Integer,LocAntSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInSum:%Integer,WardAntSum:%Integer,HospInSum:%Integer,HospAntSum:%Integer,GroupInSum:%Integer,GroupAntSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
 	
    Kill ^TMP($zn,$j,"QryAntUse")
	
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
		
		Set AntUseFlg=0
		If '$d(^TMP($zn,$j,"QryAntUse","Hosp","AntUseFlg",Paadm))
		{
			Set AntUseFlg =..GetAntUseInfo(Paadm,aDateFrom,aDateTo) //不重复判断
		}
		Set ^TMP($zn,$j,"QryAntUse","Hosp","AntUseFlg",Paadm)=""
		
		If '$d(^TMP($zn,$j,"QryAntUse","Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,"QryAntUse","Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,"QryAntUse","Hosp","PatAdm"))
			Set ^TMP($zn,$j,"QryAntUse","Hosp","PatAdm")=num+1
		}
		
		If (AntUseFlg=1) {
			If '$d(^TMP($zn,$j,"QryAntUse","Hosp","AntUse",Paadm))
			{
				Set ^TMP($zn,$j,"QryAntUse","Hosp","AntUse",Paadm)=""
				Set num=+$g(^TMP($zn,$j,"QryAntUse","Hosp","AntUse"))
				Set ^TMP($zn,$j,"QryAntUse","Hosp","AntUse")=num+1
			}
		}
		Set ^TMP($zn,$j,"QryAntUse","TansLoc",TansID) = ""
	}

	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,"QryAntUse","TansLoc",xTransID))
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
		If '$d(^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"PatAdm"))
			Set ^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"PatAdm")=num+1
		}
		//科室
		If '$d(^TMP($zn,$j,"QryAntUse","Loc",LocID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryAntUse","Loc",LocID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryAntUse","Loc",LocID,"PatAdm"))
			Set ^TMP($zn,$j,"QryAntUse","Loc",LocID,"PatAdm")=num+1
		}
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
		Set AntUseFlg   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)

		If (AntUseFlg=1) {
			If '$d(^TMP($zn,$j,"QryAntUse","Loc",LocID,"AntUse",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryAntUse","Loc",LocID,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryAntUse","Loc",LocID,"AntUse"))
				Set ^TMP($zn,$j,"QryAntUse","Loc",LocID,"AntUse")=num+1
			}
			If '$d(^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"AntUse",EpisodeID))
			{
				Set ^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"AntUse"))
				Set ^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"AntUse")=num+1
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
		
		Set ^TMP($zn,$j,"QryAntUse","TansWard",TansID) = ""
	}
	
	Set aTransID = ""
	For {
		Set aTransID = $o(^TMP($zn,$j,"QryAntUse","TansWard",aTransID))
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
	    
		If '$d(^TMP($zn,$j,"QryAntUse","Ward",WardID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryAntUse","Ward",WardID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryAntUse","Ward",WardID,"PatAdm"))
			Set ^TMP($zn,$j,"QryAntUse","Ward",WardID,"PatAdm")=num+1
		}
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
		Set AntUseFlg   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
		If (AntUseFlg=1) {
			If '$d(^TMP($zn,$j,"QryAntUse","Ward",WardID,"AntUse",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryAntUse","Ward",WardID,"AntUse",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryAntUse","Ward",WardID,"AntUse"))
				Set ^TMP($zn,$j,"QryAntUse","Ward",WardID,"AntUse")=num+1
			}
		}	
	}
	
	Set HospInSum=+$g(^TMP($zn,$j,"QryAntUse","Hosp","PatAdm"))	 
    Set HospAntSum=+$g(^TMP($zn,$j,"QryAntUse","Hosp","AntUse"))

	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryAntUse","Loc",xLocID))
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
		Set GroupInSum=+$g(^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"PatAdm"))
		Set GroupAntSum=+$g(^TMP($zn,$j,"QryAntUse","LocGroup",GroupCode,"AntUse"))
		
		Set LocInSum=+$g(^TMP($zn,$j,"QryAntUse","Loc",xLocID,"PatAdm")) 
		Set LocAntSum=+$g(^TMP($zn,$j,"QryAntUse","Loc",xLocID,"AntUse"))
	
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
		        
		    Set WardInSum=+$g(^TMP($zn,$j,"QryAntUse","Ward",LinkWardID,"PatAdm"))	 
			Set WardAntSum=+$g(^TMP($zn,$j,"QryAntUse","Ward",LinkWardID,"AntUse"))		  
		
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInSum,LocAntSum,LinkWardID,LinkWardDesc,WardInSum,WardAntSum,HospInSum,HospAntSum,GroupInSum,GroupAntSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	   
	}
	Kill ^TMP($zn,$j,"QryAntUse")
	Quit $$$OK
}

ClassMethod QryAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseExecute ]
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
/// Description:  住院患者抗菌药物使用率分母明细表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S130AntUse","QryAntUseDenDtl","1","E","","","2016-03-01","2018-03-17")
Query QryAntUseDenDtl(aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AntUseFlg:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseDenDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
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
 	
    Kill ^TMP($zn,$j,"QryAntUseDenDtl")
	
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
		
		Set ^TMP($zn,$j,"QryAntUseDenDtl",aLocType,TansID) = ""
	}
   
    If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryAntUseDenDtl","W",xTransID))
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
			Set AntUseFlg   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)

			Set AntUseFlg = $s(AntUseFlg=1:"是",1:"")
			
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime = objTrans.PATransTime
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime =objTrans.PAOutLocTime
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
		    Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,AntUseFlg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    
		}
    }
	
	If (aLocType="E") {
	    Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryAntUseDenDtl","E",xTransID))
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
					Set AntUseFlg   =..GetAntUseInfo(EpisodeID,TransDate,EndDate)
					Set AntUseFlg = $s(AntUseFlg=1:"是",1:"")
				
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
						    
					Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,AntUseFlg)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1	    

				}
			}
		    
		}
			
    }
	Kill ^TMP($zn,$j,"QryAntUseDenDtl")
	Quit $$$OK
}

ClassMethod QryAntUseDenDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseDenDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseDenDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseDenDtlExecute ]
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
/// Description:  住院患者抗菌药物使用率分子明细表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S130AntUse","QryAntUseMolDtl","1","E","","","2016-03-01","2018-03-17")
Query QryAntUseMolDtl(aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,TransID:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocID:%String,DishLocDesc:%String,DishWardID:%String,DishWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseMolDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
 	Set InstrucList=","_InstrucList_","
 	
 	Set:aDateFrom>+$h aDateFrom=""
 	Set:aDateTo>+$h aDateTo=+$h
 	
    Kill ^TMP($zn,$j,"QryAntUseMolDtl")
	
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
		
		Set ^TMP($zn,$j,"QryAntUseMolDtl",aLocType,TansID) = ""
	}
   
    If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryAntUseMolDtl","W",xTransID))
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
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime = objTrans.PATransTime
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime =objTrans.PAOutLocTime
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
		    Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    Set xScode = ""
			For {
				Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",EpisodeID,xScode))
				Quit:xScode=""
				
				Set xSttDate = ""
				For {
					Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",EpisodeID,xScode,1,xSttDate))
					Quit:xSttDate=""
					Continue:(objTrans.PAOutLocDate'="")&&(xSttDate>objTrans.PAOutLocDate)
					
					Set xOrdItemID =""
					For {
						Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",EpisodeID,xScode,1,xSttDate,xOrdItemID))
						Quit:xOrdItemID=""
				
						Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
						Continue:'$IsObject(objOrdItem)
						Continue:objOrdItem.OEIsActive'=1
			           
			            Set SttDate = objOrdItem.OESttDate
			            Set SttTime = objOrdItem.OESttTime
						Set EndDate = objOrdItem.OEXDate
						Set EndTime	= objOrdItem.OEXTime
						
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
						Continue:EndDate<TransDate  // 停药日期在转入日期前
						If (EndDate=TransDate) {
							If (EndTime'="") {
								Continue:(objTrans.PATransTime'="")&&(EndTime<objTrans.PATransTime)  // 停药日期在转入日期前
							}
						}
						Continue:(objTrans.PAOutLocDate'="")&&(SttDate>objTrans.PAOutLocDate)	// 用药日期在转出日期后
					    If (SttDate=objTrans.PAOutLocDate) {
						    If (SttTime'="") {
								Continue:(objTrans.PAOutLocTime'="")&&(SttTime>objTrans.PAOutLocTime)	// 用药日期在转出日期后
							}
					    }
						
		                Continue:SttDate>aDateTo
		                
		                Set Instruc = objOrdItem.OEInstruc //给药途径
						Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiAdminRoute",Instruc)		
						Continue:InstrucMapStr=""
						Set InstrucMap = $p(InstrucMapStr,"^",3)
						//Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药
						Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
						
						Set OrdDesc = objOrdItem.OEOrdDesc
						Set Generic=objOrdItem.OEGeneric
						Set OrdDate = objOrdItem.OEOrdDate
						Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
						Set OrdTime = objOrdItem.OEOrdTime
						Set:OrdTime'="" OrdTime=$zt(OrdTime)
					    Set OrdDateTime=OrdDate_" "_OrdTime
            
						Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
						Set:SttTime'="" SttTime=$zt(SttTime)
			            Set SttDateTime=SttDate_" "_SttTime
			            
						Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
						Set:EndTime'="" EndTime=$zt(EndTime)
						Set EndDateTime=EndDate_" "_EndTime
						 
						If $IsObject(objOrdItem.OEOrdLocDr) {
							Set OrdLocDesc=objOrdItem.OEOrdLocDr.BTDesc
						} Else {
							Set OrdLocDesc=objOrdItem.OEOrdLoc  //ID|Code|Desc
							Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
						}
						Set OrdDocDesc=objOrdItem.OEDoctor  //ID|Code|Desc
						Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
						Set UsePurpose = objOrdItem.OEAntUsePurpose
						Set:UsePurpose="" UsePurpose="其他"
						Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiMedPurpose",UsePurpose)
						//Continue:UsePurposeMapStr=""
						Set UsePurpose = $p(UsePurposeMapStr,"^",3)

						Set DrgPoison = objOrdItem.OEAntDrgPoison  //抗菌用药等级
        				Set OrdItemID = objOrdItem.OEXCode
			
	    				Set Data = $lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison,xTransID,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)
						Set Data = Data_PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
					
			}    
		}
    }
	
	If (aLocType="E") {
	    Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryAntUseMolDtl","E",xTransID))
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
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
						    
					Set xScode = ""
					For {
						Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",EpisodeID,xScode))
						Quit:xScode=""
						
						Set xSttDate = ""
						For {
							Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",EpisodeID,xScode,1,xSttDate))
							Quit:xSttDate=""
							Continue:(objTrans.PAOutLocDate'="")&&(xSttDate>objTrans.PAOutLocDate)
							
							Set xOrdItemID =""
							For {
								Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",EpisodeID,xScode,1,xSttDate,xOrdItemID))
								Quit:xOrdItemID=""
						
								Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
								Continue:'$IsObject(objOrdItem)
								Continue:objOrdItem.OEIsActive'=1
					           
					            Set SttDate = objOrdItem.OESttDate
					            Set SttTime = objOrdItem.OESttTime
								Set EndDate = objOrdItem.OEXDate
								Set EndTime	= objOrdItem.OEXTime
								
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
								Continue:EndDate<TransDate  // 停药日期在转入日期前
								If (EndDate=TransDate) {
									If (EndTime'="") {
										Continue:(objTrans.PATransTime'="")&&(EndTime<objTrans.PATransTime)  // 停药日期在转入日期前
									}
								}
								Continue:(objTrans.PAOutLocDate'="")&&(SttDate>objTrans.PAOutLocDate)	// 用药日期在转出日期后
							    If (SttDate=objTrans.PAOutLocDate) {
								    If (SttTime'="") {
										Continue:(objTrans.PAOutLocTime'="")&&(SttTime>objTrans.PAOutLocTime)	// 用药日期在转出日期后
									}
							    }
								
				                Continue:SttDate>aDateTo
				                
				                Set Instruc = objOrdItem.OEInstruc //给药途径
								Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiAdminRoute",Instruc)		
								Continue:InstrucMapStr=""
								Set InstrucMap = $p(InstrucMapStr,"^",3)
								//Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药
								Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
								
								Set OrdDesc = objOrdItem.OEOrdDesc
								Set Generic=objOrdItem.OEGeneric
								Set OrdDate = objOrdItem.OEOrdDate
								Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
								Set OrdTime = objOrdItem.OEOrdTime
								Set:OrdTime'="" OrdTime=$zt(OrdTime)
							    Set OrdDateTime=OrdDate_" "_OrdTime
		            
								Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
								Set:SttTime'="" SttTime=$zt(SttTime)
					            Set SttDateTime=SttDate_" "_SttTime
					            
								Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
								Set:EndTime'="" EndTime=$zt(EndTime)
								Set EndDateTime=EndDate_" "_EndTime
								 
								If $IsObject(objOrdItem.OEOrdLocDr) {
									Set OrdLocDesc=objOrdItem.OEOrdLocDr.BTDesc
								} Else {
									Set OrdLocDesc=objOrdItem.OEOrdLoc  //ID|Code|Desc
									Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
								}
								Set OrdDocDesc=objOrdItem.OEDoctor  //ID|Code|Desc
								Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
								Set UsePurpose = objOrdItem.OEAntUsePurpose
								Set:UsePurpose="" UsePurpose="其他"
								Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiMedPurpose",UsePurpose)
								//Continue:UsePurposeMapStr=""
								Set UsePurpose = $p(UsePurposeMapStr,"^",3)

								Set DrgPoison = objOrdItem.OEAntDrgPoison  //抗菌用药等级
		        				Set OrdItemID = objOrdItem.OEXCode
						
			    				Set Data = $lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison,xTransID,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)
								Set Data = Data_PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1
							}
						}
					}
				}
			}
		    
		}
			
    }
	Kill ^TMP($zn,$j,"QryAntUseMolDtl")
	Quit $$$OK
}

ClassMethod QryAntUseMolDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseMolDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseMolDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseMolDtlExecute ]
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
/// Description:  判断查询期间是否使用抗菌药物（全身用药）
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID：就诊ID
/// return:        1：是， 0：否
/// w ##class(DHCHAI.STAT.S130AntUse).GetAntUseInfo("392","2016-07-01","2016-09-30")
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
	Set Flg =0	
	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
		Quit:xScode=""
		Quit:Flg=1
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
			Quit:xSttDate=""
			Quit:Flg=1
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
				Quit:Flg=1
				
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
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set Flg =1		
			}
		}
	}
	Set return =Flg
	Quit return
}

}

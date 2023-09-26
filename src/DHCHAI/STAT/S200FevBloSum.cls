/// 名称: DHCHAI.STAT.S200FevBloSum
/// 描述: 住院患者体温异常血培养送检率统计表
/// 编写者：pylian
/// 编写日期: 2018-07-19
Class DHCHAI.STAT.S200FevBloSum Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-19
/// Description:  住院患者体温异常血培养送检率统计表(只考虑同病区、同科、同分组下的体温异常、血培养)
///               内一科、内二科同属内科，病人由内一科转到内二科，内一科血培养，内二科体温异常，内科 在院人数、体温异常数、血培养送检数如何计算？
///               病人由内科转到外科，内科体温异常，外科血培养，如何计算？
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S200FevBloSum","QryFevBloSum","1","2016-03-01","2018-03-17")
Query QryFevBloSum(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInSum:%Integer,LocFevSum:%Integer,LocBloSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInSum:%Integer,WardFevSum:%Integer,WardBloSum:%Integer,HospInSum:%Integer,HospFevSum:%Integer,HospBloSum:%Integer,GroupInSum:%Integer,GroupFevSum:%Integer,GroupBloSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryFevBloSumExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
 	//Set CurrTime = $h
    Kill ^TMP($zn,$j,"QryFevBloSum")
	
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
	
		Set (AbnoFlg,SubmitFlg)=0
		If '$d(^TMP($zn,$j,"QryFevBloSum","Hosp","AbnoFlg",Paadm))
		{	
			Set AbnoFlg   =..CheckFeverAbno(Paadm,aDateFrom,aDateTo)  //不重复判断
		}
		If '$d(^TMP($zn,$j,"QryFevBloSum","Hosp","SubmitFlg",Paadm))
		{
			Set SubmitFlg =..CheckBloodSub(Paadm,aDateFrom,aDateTo)   //不重复判断
		}
		Set ^TMP($zn,$j,"QryFevBloSum","Hosp","AbnoFlg",Paadm)=""
		Set ^TMP($zn,$j,"QryFevBloSum","Hosp","SubmitFlg",Paadm)=""
	
		//医院
		If '$d(^TMP($zn,$j,"QryFevBloSum","Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,"QryFevBloSum","Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Hosp","PatAdm"))
			Set ^TMP($zn,$j,"QryFevBloSum","Hosp","PatAdm")=num+1
		}
	    
		If (AbnoFlg=1) {
			If '$d(^TMP($zn,$j,"QryFevBloSum","Hosp","FeverAbno",Paadm))
			{
				Set ^TMP($zn,$j,"QryFevBloSum","Hosp","FeverAbno",Paadm)=""
				Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Hosp","FeverAbno"))
				Set ^TMP($zn,$j,"QryFevBloSum","Hosp","FeverAbno")=num+1
			}
			
			If (SubmitFlg =1) {
				If '$d(^TMP($zn,$j,"QryFevBloSum","Hosp","BloodSub",Paadm))
				{
					Set ^TMP($zn,$j,"QryFevBloSum","Hosp","BloodSub",Paadm)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Hosp","BloodSub"))
					Set ^TMP($zn,$j,"QryFevBloSum","Hosp","BloodSub")=num+1
				}
				
			}
		}
		
		Set ^TMP($zn,$j,"QryFevBloSum","TansLoc",TansID) = ""
	}

	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,"QryFevBloSum","TansLoc",xTransID))
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
		If '$d(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"PatAdm"))
			Set ^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"PatAdm")=num+1
		}
		
		//科室
		If '$d(^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"PatAdm"))
			Set ^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"PatAdm")=num+1
		}
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
		Set AbnoFlg   =..CheckFeverAbno(EpisodeID,TransDate,EndDate)
		Set SubmitFlg =..CheckBloodSub(EpisodeID,TransDate,EndDate)

		If (AbnoFlg=1) {
			If '$d(^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"FeverAbno",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"FeverAbno",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"FeverAbno"))
				Set ^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"FeverAbno")=num+1
			}
			If '$d(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"FeverAbno",EpisodeID))
			{
				Set ^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"FeverAbno",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"FeverAbno"))
				Set ^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"FeverAbno")=num+1
			}
					
			If (SubmitFlg =1) {
				If '$d(^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"BloodSub",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"BloodSub",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"BloodSub"))
					Set ^TMP($zn,$j,"QryFevBloSum","Loc",LocID,"BloodSub")=num+1
				}
				
				If '$d(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"BloodSub",EpisodeID))
				{
					Set ^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"BloodSub",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"BloodSub"))
					Set ^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"BloodSub")=num+1
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
		
		Set ^TMP($zn,$j,"QryFevBloSum","TansWard",TansID) = ""
	}
	
	Set aTransID = ""
	For {
		Set aTransID = $o(^TMP($zn,$j,"QryFevBloSum","TansWard",aTransID))
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
	
		If '$d(^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"PatAdm"))
			Set ^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"PatAdm")=num+1
		}
		
		//当前未转出，截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
		Set AbnoFlg   =..CheckFeverAbno(EpisodeID,TransDate,EndDate)
		Set SubmitFlg =..CheckBloodSub(EpisodeID,TransDate,EndDate)		
		//Set SubmitFlg =..CheckBloodSub(EpisodeID)  //不考虑时间范围
		//Set SubmitFlg =..CheckBloodSub(EpisodeID,aDateFrom,aDateTo)  //不考虑是否同个病区
	
		If (AbnoFlg=1) {
			If '$d(^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"FeverAbno",EpisodeID))
			{   
				Set ^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"FeverAbno",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"FeverAbno"))
				Set ^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"FeverAbno")=num+1
			}
					
			If (SubmitFlg =1) {
				If '$d(^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"BloodSub",EpisodeID))
				{   
					Set ^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"BloodSub",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"BloodSub"))
					Set ^TMP($zn,$j,"QryFevBloSum","Ward",WardID,"BloodSub")=num+1
				}
			}
		}
		
	}
	
	Set HospInSum=+$g(^TMP($zn,$j,"QryFevBloSum","Hosp","PatAdm"))	 
    Set HospFevSum=+$g(^TMP($zn,$j,"QryFevBloSum","Hosp","FeverAbno"))
    Set HospBloSum=+$g(^TMP($zn,$j,"QryFevBloSum","Hosp","BloodSub"))
    
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryFevBloSum","Loc",xLocID))
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
		
		Set GroupInSum=+$g(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"PatAdm"))
		Set GroupFevSum=+$g(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"FeverAbno"))
		Set GroupBloSum=+$g(^TMP($zn,$j,"QryFevBloSum","LocGroup",GroupCode,"BloodSub"))	 
	
		Set LocInSum=+$g(^TMP($zn,$j,"QryFevBloSum","Loc",xLocID,"PatAdm")) 
		Set LocFevSum=+$g(^TMP($zn,$j,"QryFevBloSum","Loc",xLocID,"FeverAbno"))
		Set LocBloSum=+$g(^TMP($zn,$j,"QryFevBloSum","Loc",xLocID,"BloodSub"))
		
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
		        
		    Set WardInSum=+$g(^TMP($zn,$j,"QryFevBloSum","Ward",LinkWardID,"PatAdm"))	 
			Set WardFevSum=+$g(^TMP($zn,$j,"QryFevBloSum","Ward",LinkWardID,"FeverAbno"))		  
			Set WardBloSum=+$g(^TMP($zn,$j,"QryFevBloSum","Ward",LinkWardID,"BloodSub"))
			
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInSum,LocFevSum,LocBloSum,LinkWardID,LinkWardDesc,WardInSum,WardFevSum,WardBloSum,HospInSum,HospFevSum,HospBloSum,GroupInSum,GroupFevSum,GroupBloSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	   
	}
	Kill ^TMP($zn,$j,"QryFevBloSum")
	//Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	 
	Quit $$$OK
}

ClassMethod QryFevBloSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFevBloSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFevBloSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFevBloSumExecute ]
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
/// Description:  住院患者体温异常血培养送检率统计表(比原有方法多两个血液透析室的人)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S200FevBloSum","QryFevBloSum2","1","2016-03-01","2018-03-17")
Query QryFevBloSum2(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInSum:%Integer,LocFevSum:%Integer,LocBloSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInSum:%Integer,WardFevSum:%Integer,WardBloSum:%Integer,HospInSum:%Integer,HospFevSum:%Integer,HospBloSum:%Integer,GroupInSum:%Integer,GroupFevSum:%Integer,GroupBloSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryFevBloSum2Execute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
 	
 	//Set CurrTime = $h
    Kill ^TMP($zn,$j,"QryFevBloSum2")
	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    //同期在科
    Set ListLocArray=##class(DHCHAI.STAT.S040MRBInf).GetTransEpisByDate(aDateFrom,aDateTo,"I") //某段时间的在科人数
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
	
		Set LocType = $LIST(TransInfo,1)	
		Set Date    = $LIST(TransInfo,2)
		Set Paadm   = $LIST(TransInfo,3)
		Set Status  = $LIST(TransInfo,4)			
		Set LocID   = $LIST(TransInfo,5)	
		Set TansID  = $LIST(TransInfo,6)
		Continue:(LocType'="E")&&(LocType'="W")
		Continue:(Status="I")                 //当天转入不算在内
		//Continue:(Status="A2")                //当天转入当天转出不算在内
  
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
	
		Set (AbnoFlg,SubmitFlg)=0
		If '$d(^TMP($zn,$j,"QryFevBloSum2","Hosp","AbnoFlg",Paadm))
		{	
			Set AbnoFlg   =..CheckFeverAbno(Paadm,aDateFrom,aDateTo)  //不重复判断
		}
		If '$d(^TMP($zn,$j,"QryFevBloSum2","Hosp","SubmitFlg",Paadm))
		{
			Set SubmitFlg =..CheckBloodSub(Paadm,aDateFrom,aDateTo)   //不重复判断
		}
		Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","AbnoFlg",Paadm)=""
		Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","SubmitFlg",Paadm)=""
	
		//医院
		If '$d(^TMP($zn,$j,"QryFevBloSum2","Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Hosp","PatAdm"))
			Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","PatAdm")=num+1
		}
	    
		If (AbnoFlg=1) {
			If '$d(^TMP($zn,$j,"QryFevBloSum2","Hosp","FeverAbno",Paadm))
			{
				Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","FeverAbno",Paadm)=""
				Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Hosp","FeverAbno"))
				Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","FeverAbno")=num+1
			}
			
			If (SubmitFlg =1) {
				If '$d(^TMP($zn,$j,"QryFevBloSum2","Hosp","BloodSub",Paadm))
				{
					Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","BloodSub",Paadm)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Hosp","BloodSub"))
					Set ^TMP($zn,$j,"QryFevBloSum2","Hosp","BloodSub")=num+1
				}
				
			}
		}
		
		Set ^TMP($zn,$j,"QryFevBloSum2","TansLoc",LocType,TansID) = ""
	}
 
    Set xType = ""
	For {
		Set xType = $o(^TMP($zn,$j,"QryFevBloSum2","TansLoc",xType))
		Quit:xType=""
		
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryFevBloSum2","TansLoc",xType,xTransID))
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
		   
		    //当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate =aDateTo
			Set AbnoFlg   =..CheckFeverAbno(EpisodeID,TransDate,EndDate)
			Set SubmitFlg =..CheckBloodSub(EpisodeID,TransDate,EndDate)
		
		    If (xType="E") {
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
				If '$d(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"PatAdm",EpisodeID))
				{
					Set ^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"PatAdm",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"PatAdm"))
					Set ^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"PatAdm")=num+1
				}
		
				//科室
				If '$d(^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"PatAdm",EpisodeID))
				{
					Set ^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"PatAdm",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"PatAdm"))
					Set ^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"PatAdm")=num+1
				}
				
				If (AbnoFlg=1) {
					If '$d(^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"FeverAbno",EpisodeID))
					{   
						Set ^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"FeverAbno",EpisodeID)=""
						Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"FeverAbno"))
						Set ^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"FeverAbno")=num+1
					}
					If '$d(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"FeverAbno",EpisodeID))
					{
						Set ^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"FeverAbno",EpisodeID)=""
						Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"FeverAbno"))
						Set ^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"FeverAbno")=num+1
					}
							
					If (SubmitFlg =1) {
						If '$d(^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"BloodSub",EpisodeID))
						{   
							Set ^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"BloodSub",EpisodeID)=""
							Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"BloodSub"))
							Set ^TMP($zn,$j,"QryFevBloSum2","Loc",LocID,"BloodSub")=num+1
						}
						
						If '$d(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"BloodSub",EpisodeID))
						{
							Set ^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"BloodSub",EpisodeID)=""
							Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"BloodSub"))
							Set ^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"BloodSub")=num+1
						}
					}
				}	
		    }
		    If (xType="W") {
			    //病区
				If '$d(^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"PatAdm",EpisodeID))
				{
					Set ^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"PatAdm",EpisodeID)=""
					Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"PatAdm"))
					Set ^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"PatAdm")=num+1
				}
				
				If (AbnoFlg=1) {
					If '$d(^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"FeverAbno",EpisodeID))
					{   
						Set ^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"FeverAbno",EpisodeID)=""
						Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"FeverAbno"))
						Set ^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"FeverAbno")=num+1
					}
					
					If (SubmitFlg =1) {
						If '$d(^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"BloodSub",EpisodeID))
						{   
							Set ^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"BloodSub",EpisodeID)=""
							Set num=+$g(^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"BloodSub"))
							Set ^TMP($zn,$j,"QryFevBloSum2","Ward",LocID,"BloodSub")=num+1
						}
					}
				}
			    
		    }
		}
	}
	
	Set HospInSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Hosp","PatAdm"))	 
    Set HospFevSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Hosp","FeverAbno"))
    Set HospBloSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Hosp","BloodSub"))
    
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryFevBloSum2","Loc",xLocID))
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
		
		Set GroupInSum=+$g(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"PatAdm"))
		Set GroupFevSum=+$g(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"FeverAbno"))
		Set GroupBloSum=+$g(^TMP($zn,$j,"QryFevBloSum2","LocGroup",GroupCode,"BloodSub"))	 
	
		Set LocInSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Loc",xLocID,"PatAdm")) 
		Set LocFevSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Loc",xLocID,"FeverAbno"))
		Set LocBloSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Loc",xLocID,"BloodSub"))
		
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
		        
		    Set WardInSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Ward",LinkWardID,"PatAdm"))	 
			Set WardFevSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Ward",LinkWardID,"FeverAbno"))		  
			Set WardBloSum=+$g(^TMP($zn,$j,"QryFevBloSum2","Ward",LinkWardID,"BloodSub"))
			
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInSum,LocFevSum,LocBloSum,LinkWardID,LinkWardDesc,WardInSum,WardFevSum,WardBloSum,HospInSum,HospFevSum,HospBloSum,GroupInSum,GroupFevSum,GroupBloSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	   
	}
	Kill ^TMP($zn,$j,"QryFevBloSum2")
	//Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	 
	Quit $$$OK
}

ClassMethod QryFevBloSum2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFevBloSum2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFevBloSum2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFevBloSum2Execute ]
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
/// Description:  住院患者体温异常血培养送检率统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S200FevBloSum","QryFevBloDtl","1","E","","","2016-03-01","2018-03-17")
Query QryFevBloDtl(aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDate:%String,TransTime:%String,OutLocDate:%String,OutLocTime:%String,AbnoFlg:%String,SubmitFlg:%String") [ SqlProc ]
{
}

ClassMethod QryFevBloDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
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
 	
    Kill ^TMP($zn,$j,"QryFevBloDtl")
	
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

		Set ^TMP($zn,$j,"QryFevBloDtl",aLocType,TansID) = ""
	}
   
    If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryFevBloDtl","W",xTransID))
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
			Set AbnoFlg   =..CheckFeverAbno(EpisodeID,TransDate,EndDate)
			Set SubmitFlg =..CheckBloodSub(EpisodeID,TransDate,EndDate)
	
			Set AbnoFlg = $s(AbnoFlg=1:"是",1:"")
			Set SubmitFlg = $s(SubmitFlg=1:"是",1:"")
					
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime = objTrans.PATransTime
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime =objTrans.PAOutLocTime
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)

		    Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,AbnoFlg,SubmitFlg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    

		}
    }
    If (aLocType="E") {
	    Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,"QryFevBloDtl","E",xTransID))
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
					Set AbnoFlg   =..CheckFeverAbno(EpisodeID,TransDate,EndDate)
					Set SubmitFlg =..CheckBloodSub(EpisodeID,TransDate,EndDate)
				
					Set AbnoFlg = $s(AbnoFlg=1:"是",1:"")
					Set SubmitFlg = $s(SubmitFlg=1:"是",1:"")
					
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	
			    	Set Data=PatData_$lb(xID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,AbnoFlg,SubmitFlg)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1	    

				}
			}
		    
		}
			
    }
	
	Kill ^TMP($zn,$j,"QryFevBloDtl")
	Quit $$$OK
}

ClassMethod QryFevBloDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFevBloDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFevBloDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFevBloDtlExecute ]
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
/// CreatDate：   2018-07-19
/// Description:  判断是否进行血培养送检
/// Return：      1：送检    0：未送检
/// w ##class(DHCHAI.STAT.S200FevBloSum).CheckBloodSub(341,"2016-01-01","2018-07-19")
ClassMethod CheckBloodSub(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		Quit:return=1
		
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
		
        Set return=1		
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-25
/// Description:  判断体温异常
/// Return：      1：体温异常    0：体温正常
/// w ##class(DHCHAI.STAT.S200FevBloSum).CheckFeverAbno(341,"2016-01-01","2018-07-19")
ClassMethod CheckFeverAbno(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeID="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")
    Quit:'$IsObject(objItmMast) return
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" return
    
	For xDate=aDateFrom:1:aDateTo {
		Quit:return=1
 		Set xID=0
		For {
	 		Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,ItemID,xDate,xID))
	 		Quit:(xID="")||(return=1)
	 		Set objRtl=##class(DHCHAI.IR.CCResult).GetObjById(xID)
	 		Continue:'$IsObject(objRtl)
			Continue:objRtl.CCIsActive'=1
	 		Set objKey = objRtl.CCKeyWordDr
	 		Continue:'$IsObject(objKey)
 			Set CCDesc = objKey.CCDesc
 			Continue:CCDesc'="发热"
 			// 排除术后72小时内的异常体温记录
 			Set OperFlg =..CheckOper(aEpisodeID,(xDate-3),xDate)
 			Continue:OperFlg=1
 			Set return=1
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-26
/// Description:  判断一段时间内是否有手术
/// Return：      1：有    0：无
/// w ##class(DHCHAI.STAT.S200FevBloSum).CheckOper(341,"2016-01-01","2018-07-19")
ClassMethod CheckOper(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeID="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate))
		Quit:(xDate="")||(return=1)
		Quit:xDate>aDateTo
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate,xID))
			Quit:(xID="")||(return=1)
			
			Set objOperAnaes=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
			Continue:'$IsObject(objOperAnaes)
			Continue:objOperAnaes.ORIsActive'=1
			Continue:'$IsObject(objOperAnaes.OREpisodeDr)
			Set Incision=objOperAnaes.ORIncision       //手术切口类型
			Continue:Incision=""
			Set return=1
		}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-07-20
/// Description:  查询患者体温异常列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input:        aEpisodeID：就诊ID
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S200FevBloSum","QryFevAbnoInfo","22","2016-07-01","2016-07-05")
Query QryFevAbnoInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ResultID:%String,ObsResult:%String,ObsDateTime:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryFevAbnoInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:aEpisodeID="" $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 		
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
    
    Set PatData =..BuildPaadmData(aEpisodeID)
	Quit:PatData="" $$$OK
		    
	For xDate=aDateFrom:1:aDateTo {
 		Set xID=0
		For {
	 		Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,ItemID,xDate,xID))
	 		Quit:xID=""
	 		Set objRtl=##class(DHCHAI.IR.CCResult).GetObjById(xID)
	 		Continue:'$IsObject(objRtl)
			Continue:objRtl.CCIsActive'=1
	 		Set objKey = objRtl.CCKeyWordDr
	 		Continue:'$IsObject(objKey)
 			Set CCDesc = objKey.CCDesc
 			Continue:CCDesc'="发热"
 			
 			Set ObsResult  = objRtl.CCResult
 			Set ActDate = objRtl.CCActDate
 			Set ActTime = objRtl.CCActTime
            
            Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	        Set:ActTime'="" ActTime=$zt(ActTime)
            Set ObsDateTime = ActDate_" "_ActTime

			Set Data=$lb(xID,ObsResult,ObsDateTime)_PatData
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryFevAbnoInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFevAbnoInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFevAbnoInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFevAbnoInfoExecute ]
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
/// CreatDate：   2018-07-20
/// Description:  查询患者血培养送检列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.LabVisitNumber
/// Input:        aEpisodeID：就诊ID
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S200FevBloSum","QryBlooSubInfo","344","2016-01-01","2018-07-20")
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

}

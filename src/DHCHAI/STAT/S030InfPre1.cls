/// 名称: DHCHAI.STAT.S030InfPre1
/// 描述: HISUI医院感染（例次）现患率统计表
/// 编写者：ShenC
/// 编写日期: 2020-01-19
Class DHCHAI.STAT.S030InfPre1 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2020-01-19
/// Description:  医院感染（例次）现患率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S030InfPre1","QryInfPre","","2020-01-01","2020-01-19")
Query QryInfPre(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInfSum:%Integer,LocComSum:%Integer,LocInfCaseSum:%Integer,LocComCaseSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInfSum:%Integer,WardComSum:%Integer,WardInfCaseSum:%Integer,WardComCaseSum:%Integer,HospInfSum:%Integer,HospComSum:%Integer,HospInfCaseSum:%Integer,HospComCaseSum:%Integer,GroupInfSum:%Integer,GroupComSum:%Integer,GroupInfCaseSum:%Integer,GroupComCaseSum:%Integer,HospPatSum:%Integer,GroupPatSum:%Integer,LocPatSum:%Integer,WardPatSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfPreExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryInfPre"
	Kill ^TMP($zn,$j,NIndex)
    
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		
		Continue:($d(^TMP($zn,$j,NIndex,"TansLoc",TansID)))
		Set ^TMP($zn,$j,NIndex,"TansLoc",TansID) = ""
		
		Continue:(Status="I")                 // 当天转入不算在内
		//Continue:(Status="A2")              // 当天转入当天转出不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		// 医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
		// 全院住院患者人数
		If '$d(^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm")=num+1
		}
		// 避免重复获取感染部位
		Set InfPosDescs=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm))
		{
			Set InfPosDescs =..GetInfPosInfo(Paadm,aDateFrom,aDateTo)
		}
		for indDimens=1:1:$l(InfPosDescs,"|"){
			Quit:InfPosDescs=""
			// 感染信息
			Set InfDianosInfo=$p(InfPosDescs,"|",indDimens)
			// 感染部位
			Set RepDianos=$p(InfDianosInfo,"!!",1)
			 //感染类型
			Set InfCategory=$p(InfDianosInfo,"!!",2)
		
			if (indDimens=1){
				//医院感染人数
				Set:InfPosDescs["!!1" num=$i(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
				//社区感染人数
				Set:InfPosDescs["!!0" num=$i(^TMP($zn,$j,NIndex,"Hosp","ComPat"))
			}
			//医院感染例数
			Set:InfCategory=1 num=$i(^TMP($zn,$j,NIndex,"Hosp","InfCase"))
			//社区感染例数
			Set:InfCategory=0 num=$i(^TMP($zn,$j,NIndex,"Hosp","ComCase"))
		}
	}
	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,NIndex,"TansLoc",xTransID))
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
		If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm"))
			Set ^TMP($zn,$j,NIndex,"Loc",LocID,"PatAdm")=num+1
		}
		If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupDr,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,NIndex,"LocGroup",GroupDr,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupDr,"PatAdm"))
			Set ^TMP($zn,$j,NIndex,"LocGroup",GroupDr,"PatAdm")=num+1
		}
		Set:TransDate<aDateFrom TransDate = aDateFrom
		Set:OutLocDate>aDateTo OutLocDate = aDateTo
		//当前未转出,截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate = aDateTo
		Set InfPosDescs =..GetInfPosInfo(EpisodeID,TransDate,EndDate)
		
		for indDimens=1:1:$l(InfPosDescs,"|"){
			// 感染信息
			Set InfDianosInfo=$p(InfPosDescs,"|",indDimens)
			// 感染部位
			Set RepDianos=$p(InfDianosInfo,"!!",1)
			 //感染类型
			Set InfCategory=$p(InfDianosInfo,"!!",2)
			
			if (indDimens=1){
				Quit:InfPosDescs=""
				//科室感染人数
				Set:InfPosDescs["!!1" num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat"))
				//科室社区感染人数
				Set:InfPosDescs["!!0" num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"ComPat"))
				//科室组感染人数
				Set:InfPosDescs["!!1" num=$i(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat"))
				//科室组社区感染人数
				Set:InfPosDescs["!!0" num=$i(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"ComPat"))
			}
			//科室感染例数
			Set:InfCategory=1 num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase"))
			//科室感染例数
			Set:InfCategory=0 num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"ComCase"))
			//科室组感染例数
			Set:InfCategory=1 num=$i(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase"))
			//科室组感染例数
			Set:InfCategory=0 num=$i(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"ComCase"))
		}
	}
	// 同期在病区
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
		//Continue:(Status="A2")              //当天转入当天转出不算在内
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set ^TMP($zn,$j,NIndex,"TansWard",TansID) = ""
	}
	Set aTransID = ""
	For {
		Set aTransID = $o(^TMP($zn,$j,NIndex,"TansWard",aTransID))
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
	   	If '$d(^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm",EpisodeID))
		{
			Set ^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm",EpisodeID)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm"))
			Set ^TMP($zn,$j,NIndex,"Ward",WardID,"PatAdm")=num+1
		}
		Set:TransDate<aDateFrom TransDate = aDateFrom
		Set:OutLocDate>aDateTo OutLocDate = aDateTo
		//当前未转出,截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate = aDateTo
		Set InfPosDescs =..GetInfPosInfo(EpisodeID,TransDate,EndDate)
		for indDimens=1:1:$l(InfPosDescs,"|"){
			Quit:InfPosDescs=""
			// 感染信息
			Set InfDianosInfo=$p(InfPosDescs,"|",indDimens)
			// 感染部位
			Set RepDianos=$p(InfDianosInfo,"!!",1)
			 //感染类型
			Set InfCategory=$p(InfDianosInfo,"!!",2)
			
			if (indDimens=1){
				//病区感染人数
				Set:InfPosDescs["!!1" num=$i(^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat"))
				//病区社区感染人数
				Set:InfPosDescs["!!0" num=$i(^TMP($zn,$j,NIndex,"Ward",WardID,"ComPat"))
			}
			//病区感染例数
			Set:InfCategory=1 num=$i(^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase"))
			//病区感染例数
			Set:InfCategory=0 num=$i(^TMP($zn,$j,NIndex,"Ward",WardID,"ComCase"))
		}
	}
	// 全院感染人数、例次数
	Set HospPatSum  =$g(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))
	Set HospInfSum  =$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))	//医院感染人数
	Set HospComSum	=$g(^TMP($zn,$j,NIndex,"Hosp","ComPat"))	//社区感染人数
	Set HospInfCaseSum =$g(^TMP($zn,$j,NIndex,"Hosp","InfCase"))	//医院感染例数
	Set HospComCaseSum =$g(^TMP($zn,$j,NIndex,"Hosp","ComCase"))	//社区感染例数
	Set:HospPatSum="" HospPatSum=0 
	Set:HospInfSum="" HospInfSum=0
	Set:HospComSum="" HospComSum=0
	Set:HospInfCaseSum="" HospInfCaseSum=0
	Set:HospComCaseSum="" HospComCaseSum=0
	// 输出Data
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Loc",xLocID))
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
		// 科室组感染人数、例次数
		Set GroupPatSum  =$g(^TMP($zn,$j,NIndex,"LocGroup",GroupDr,"PatAdm"))
		Set GroupInfSum  =$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat"))	//科室组感染人数
		Set GroupComSum  =$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"ComPat"))	//社区感染人数
		Set GroupInfCaseSum =$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase"))	//科室组感染例数
		Set GroupComCaseSum =$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"ComCase"))	//社区感染例数
		Set:GroupPatSum="" GroupPatSum=0
		Set:GroupInfSum="" GroupInfSum=0
		Set:GroupComSum="" GroupComSum=0
		Set:GroupInfCaseSum="" GroupInfCaseSum=0
		Set:GroupComCaseSum="" GroupComCaseSum=0
		// 科室感染人数、例次数
		Set LocPatSum  =$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"PatAdm"))
		Set LocInfSum  =$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfPat")) 	//科室感染人数
		Set LocComSum  =$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"ComPat"))	//社区感染人数
		Set LocInfCaseSum =$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfCase"))	//科室感染例数
		Set LocComCaseSum =$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"ComCase"))	//社区感染例数
		Set:LocPatSum="" LocPatSum=0
		Set:LocInfSum="" LocInfSum=0
		Set:LocComSum="" LocComSum=0
		Set:LocInfCaseSum="" LocInfCaseSum=0
		Set:LocComCaseSum="" LocComCaseSum=0
		
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
		    // 病区感染人数、例次数
		    Set WardPatSum  =$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"PatAdm"))   
		    Set WardInfSum  =$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfPat"))	//病区感染人数
		    Set WardComSum  =$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"ComPat"))	//社区感染人数
			Set WardInfCaseSum =$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfCase"))	//病区感染例数
			Set WardComCaseSum =$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"ComCase"))	//社区感染例数
			Set:WardPatSum="" WardPatSum=0
			Set:WardInfSum="" WardInfSum=0
			Set:WardComSum="" WardComSum=0
			Set:WardInfCaseSum="" WardInfCaseSum=0
			Set:WardComCaseSum="" WardComCaseSum=0
			
			Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInfSum,LocComSum,LocInfCaseSum,LocComCaseSum,LinkWardID,LinkWardDesc,WardInfSum,WardComSum,WardInfCaseSum,WardComCaseSum,HospInfSum,HospComSum,HospInfCaseSum,HospComCaseSum,GroupInfSum,GroupComSum,GroupInfCaseSum,GroupComCaseSum,HospPatSum,GroupPatSum,LocPatSum,WardPatSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	   
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-01-19
/// Description:  医院感染（例次）现患率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S030InfPre1","QryInfPreDtl","","2020-01-01","2020-01-19","E","","","0")
Query QryInfPreDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aInfType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryInfPreDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aInfType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryInfPreDtl"
	Kill ^TMP($zn,$j,NIndex)
  
    //同期在科、在病区
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
		//Continue:(Status="A2")              //当天转入当天转出不算在内

		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤		
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
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
		
		Set ^TMP($zn,$j,NIndex,aLocType,TansID) = ""
	}
	If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,NIndex,"W",xTransID))
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
			Set TransDate = objTrans.PATransDate
			Set OutLocDate= objTrans.PAOutLocDate
			Set:TransDate<aDateFrom TransDate = aDateFrom
			Set:OutLocDate>aDateTo OutLocDate = aDateTo
			//当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate = aDateTo
			Set InfPoss =..GetInfPosInfo(EpisodeID,TransDate,EndDate)
			Continue:InfPoss=""
			Set InfType=""	//设置感染类型
			Set (InfPosDescs,InfDates,InfEffects)=""
			For indxi=1:1:$l(InfPoss,"|") {
				//感染信息
				Set tmpInfPos=$p(InfPoss,"|",indxi)
				//感染部位
				Set CSSRepDianos=$p(tmpInfPos,"!!",1)
				// 感染分类 
				Set InfCategory=$p(tmpInfPos,"!!",2)
				
				Set:InfCategory=1 InfType=InfType_"!!1"
				Set:InfCategory=0 InfType=InfType_"!!0"
				Continue:(InfCategory'=aInfType)
				Set tmpInfPosID    = $p(CSSRepDianos,"^",1)
				Set tmpInfPosDescs = $p(CSSRepDianos,"^",2)
				Set InfPosDescs    = InfPosDescs_"|"_tmpInfPosDescs
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(tmpInfPosID)
				If ($IsObject(objDiags)){
					// 感染日期
					Set InfEffect=""
					Set InfDate  = objDiags.IRInfDate
					Set InfDate  = $zd(InfDate,3)
					Set InfDates = InfDates_","_InfDate
					Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
					Set InfEffects = InfEffects_","_InfEffect
				}
			}
			Set:InfDates'="" InfDates=$e(InfDates,2,$l(InfDates))
			Set:InfEffects'="" InfEffects=$e(InfEffects,2,$l(InfEffects)) // 感染转归
			Set:InfPosDescs'="" InfPosDescs=InfPosDescs_"|"
			
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
		    Continue:'(InfType[("!!"_aInfType))
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InfPosDescs,InfDates,InfEffects)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    
		}
    }
	If (aLocType="E") {
	    Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,NIndex,"E",xTransID))
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
					Set:TransDate<aDateFrom TransDate = aDateFrom
					Set:OutLocDate>aDateTo OutLocDate = aDateTo
					//当前未转出，截止为查询结束日期
					Set EndDate = OutLocDate
					Set:EndDate="" EndDate = aDateTo
					
					Set InfPoss =..GetInfPosInfo(EpisodeID,TransDate,EndDate)
					Continue:InfPoss=""
					Set InfType=""
					Set (InfPosDescs,InfDates,InfEffects)=""
					For indxi=1:1:$l(InfPoss,"|") {
						//感染信息
						Set tmpInfPos=$p(InfPoss,"|",indxi)
						//感染部位
						Set CSSRepDianos=$p(tmpInfPos,"!!",1)
						// 感染分类 
						Set InfCategory=$p(tmpInfPos,"!!",2)
						
						Set:InfCategory=1 InfType=InfType_"!!1"
						Set:InfCategory=0 InfType=InfType_"!!0"
						Continue:(InfCategory'=aInfType)
						Set tmpInfPosID    = $p(CSSRepDianos,"^",1)
						Set tmpInfPosDescs = $p(CSSRepDianos,"^",2)
						Set InfPosDescs    = InfPosDescs_"|"_tmpInfPosDescs
						Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(tmpInfPosID)
						If ($IsObject(objDiags)){
							// 感染日期
							Set InfEffect=""
							Set InfDate  = objDiags.IRInfDate
							Set InfDate  = $zd(InfDate,3)
							Set InfDates = InfDates_","_InfDate
							Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
							Set InfEffects = InfEffects_","_InfEffect
						}
					}
					Set:InfDates'="" InfDates=$e(InfDates,2,$l(InfDates))
					Set:InfEffects'="" InfEffects=$e(InfEffects,2,$l(InfEffects)) // 感染转归
					Set:InfPosDescs'="" InfPosDescs=InfPosDescs_"|"
			
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
					Continue:'(InfType[("!!"_aInfType))
					
					Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InfPosDescs,InfDates,InfEffects)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPreDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreDtlExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-01-19
/// Description:  住院患者明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S030InfPre1","QryInfPatDtl","","2020-01-01","2020-01-19","E","其他科","消化内科")
Query QryInfPatDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryInfPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//Set ^zhoubo=aHospIDs_"^"_aDateFrom_"^"_aDateTo_"^"_aLocType_"^"_aLocGroup_"^"_aLocDesc
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryS010InfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
  
    //同期在科、在病区
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
		//Continue:(Status="A2")              //当天转入当天转出不算在内

		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤		
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
				Set GroupDesc	= objGroup.BTDesc
			}
		}	
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
		
		Set ^TMP($zn,$j,NIndex,aLocType,TansID) = ""
	}
	If (aLocType="W") {
		Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,NIndex,"W",xTransID))
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
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    
		}
    }
	If (aLocType="E") {
	    Set xTransID = ""
		For {
			Set xTransID = $o(^TMP($zn,$j,NIndex,"E",xTransID))
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
			Set PatData =..BuildPaadmData(EpisodeID)
		    Continue:PatData=""
		    
		    //报表默认一个病人一条记录，对应多条转科(防止重复)
		    Continue:$d(^TMP($zn,$j,NIndex,"E",EpisodeID,"PAADM"))
		    Set ^TMP($zn,$j,NIndex,"E",EpisodeID,"PAADM")=""

		    Set IsWardFlag =0  // 存在符合条件的病区标识
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
						    
					Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
					Set IsWardFlag =1
				}
			}
			if (IsWardFlag=0)
			{
				//没有病区信息
				Set (TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)=""
				Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPatDtlExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-01-19
/// Description:  判断患者是否发生医院感染,返回感染类型和感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S030InfPre1).GetInfPosInfo("84","2019-01-01","2020-02-29")
ClassMethod GetInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	//实时现患率的感染数据以确诊感染部位即可,不依赖于临床的院感报告数据。
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aEpisodeID,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xDiaID=0
		For {
			Set xDiaID=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aEpisodeID,xDate,xDiaID))
			Quit:xDiaID=""
			
			Set objDia=##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiaID)
			Continue:'$Isobject(objDia)
			Continue:'$Isobject(objDia.IREpisodeDr)
			Set IRInfDate = objDia.IRInfDate
			// 感染分类 不是社区感染的就是医院感染
			Set InfCategory = objDia.IRInfType
			If InfCategory'=0{
				Set InfCategory = 1
			}
			// 感染诊断
			Set objInfPos = objDia.IRInfPosDr
			If $IsObject(objInfPos){
				Set:InfPosDescs'="" InfPosDescs= InfPosDescs_"|"_xDiaID_"^"_objInfPos.BTDesc_"^"_IRInfDate_"!!"_InfCategory
				Set:InfPosDescs="" InfPosDescs=xDiaID_"^"_objInfPos.BTDesc_"^"_IRInfDate_"!!"_InfCategory
			}
		}
	}
	Set:InfPosDescs'="" return = InfPosDescs

	Quit return
}

}

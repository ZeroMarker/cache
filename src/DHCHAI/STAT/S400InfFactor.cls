/// 名称: DHCHAI.STAT.S400InfFactor
/// 描述: 住院患者医院感染易感因素分布
/// 编写者：zhoubo
/// 编写日期: 2018-08-31
Class DHCHAI.STAT.S400InfFactor Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  住院患者医院感染易感因素分布
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S400InfFactor","QryInfFactor","1","2018-10-01","2018-10-16")
Query QryInfFactor(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInfSum:%Integer,LocCaseSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInfSum:%Integer,WardCaseSum:%Integer,HospInfSum:%Integer,HospCaseSum:%Integer,GroupInfSum:%Integer,GroupCaseSum:%Integer,InfFacDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfFactorExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryInfFactor"
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
		Continue:(Status="I")                 // 当天转入不算在内
		//Continue:(Status="A2")              // 当天转入当天转出不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		// 医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
		// 避免重复获取感染信息
		Set InfRepInfo=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm))
		{
			Set InfRepInfo =..GetFactors(Paadm,aDateFrom,aDateTo)
		}
		Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)=""
		If (InfRepInfo'="") {
			// 全院感染人数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","InfPat",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","InfPat",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
				Set ^TMP($zn,$j,NIndex,"Hosp","InfPat")=num+1
			}
			// 全院感染例次数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","InfCase"))
				Set ^TMP($zn,$j,NIndex,"Hosp","InfCase")=num+$l($p(InfRepInfo,"#",1),"^")
			}
		}
		Set ^TMP($zn,$j,NIndex,"TansLoc",TansID) = ""
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
		//当前未转出,截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate =aDateTo
		Set InfRepInfo =..GetFactors(EpisodeID,TransDate,EndDate)
		If (InfRepInfo'="") {
			// 科室感染人数
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat",EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat"))
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfPat")=num+1
			}
			// 科室感染例次数 
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase",EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase"))
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"InfCase")=num+$l($p(InfRepInfo,"#",1),"^")
			}
			// 科室组感染人数
			If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat",EpisodeID))
			{
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat"))
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat")=num+1
			}
			// 科室组感染例次数
			If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase",EpisodeID))
			{
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase"))
				Set ^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase")=num+$l($p(InfRepInfo,"#",1),"^")
			}
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
	   
		//当前未转出,截止为查询结束日期
		Set EndDate = OutLocDate
		Set:EndDate="" EndDate = aDateTo
		Set InfRepInfo =..GetFactors(EpisodeID,TransDate,EndDate)
		If (InfRepInfo'="") {
			// 记录病区易感因素信息
			Set InfFactors = $p(InfRepInfo,"#",2)
			For indxi=1:1:$l(InfFactors,"|") {
				Set tmpInfFacs    = $p(InfFactors,"|",indxi)
				Set tmpFacID      = $p(tmpInfFacs,"^",1)
				Continue:tmpFacID=""
				Set tmpInfFacDesc = $p(tmpInfFacs,"^",2)
				Set ^TMP($zn,$j,NIndex,"InfPosList",WardID,tmpFacID)=tmpInfFacDesc
			}
			// 病区感染人数
			If '$d(^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat",EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat"))
				Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfPat")=num+1
			}
			// 病区感染例次数 
			If '$d(^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase",EpisodeID))
			{   
				Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase",EpisodeID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase"))
				Set ^TMP($zn,$j,NIndex,"Ward",WardID,"InfCase")=num+$l($p(InfRepInfo,"#",1),"^")
			}
		}	
	}
	// 全院感染人数、例次数
	Set HospInfSum  =+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
	Set HospCaseSum =+$g(^TMP($zn,$j,NIndex,"Hosp","InfCase"))
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
		Set GroupInfSum  =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfPat"))
		Set GroupCaseSum =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupCode,"InfCase"))
		// 科室感染人数、例次数
		Set LocInfSum  =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfPat")) 
		Set LocCaseSum =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"InfCase"))
	
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
		    Set WardInfSum  =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfPat"))	 
			Set WardCaseSum =+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"InfCase"))		  
			
			Set xFacID=""
			For {
				Set xFacID=$o(^TMP($zn,$j,NIndex,"InfPosList",LinkWardID,xFacID))
				Quit:xFacID=""
				Set InfFacDesc =$g(^TMP($zn,$j,NIndex,"InfPosList",LinkWardID,xFacID))
				Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInfSum,LocCaseSum,LinkWardID,LinkWardDesc,WardInfSum,WardCaseSum,HospInfSum,HospCaseSum,GroupInfSum,GroupCaseSum,InfFacDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	 	}
	   
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfFactorExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  住院患者医院易感因素分布统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// 			  aFacDesc： 易感因素名称 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S400InfFactor","QryInfFactorDtl","","2018-08-01","2018-08-10","E","","","")
Query QryInfFactorDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aFacDesc As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String,InfFactors:%String") [ SqlProc ]
{
}

ClassMethod QryInfFactorDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aFacDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryInfFactorDtl"
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
			//当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate = aDateTo
			// 诊断ID^诊断ID#易感因素ID^易感因素|易感因素ID^易感因素
			Set InfRepInfo =..GetFactors(EpisodeID,TransDate,EndDate)
			Continue:InfRepInfo=""
			Set (InfPosDescs,InfDates,InfEffects,InfFactors)=""
			Set InfFacts = $p(InfRepInfo,"#",2)
			Set InfPoss  = $p(InfRepInfo,"#",1)
			For indxi=1:1:$l(InfFacts,"|") {
				Set tmpInfFacIDs = $p(InfFacts,"|",indxi)
				Set tmpInfFacID = $p(tmpInfFacIDs,"^",1)
				Set objFacts = ##class(DHCHAI.IR.INFPreFactor).GetObjById(tmpInfFacID)
				If ($IsObject(objFacts)){
					Continue:'$IsObject(objFacts.IRPreFactorDr)
					Set Factor = objFacts.IRPreFactorDr.BTDesc
					Set:Factor'="" InfFactors = InfFactors_"|"_Factor
				}
			}
			Set:InfFactors'="" InfFactors=InfFactors_"|"
			Continue:(aFacDesc'="")&&(InfFactors'[("|"_aFacDesc_"|"))  // 易感因素过滤
			For indxi=1:1:$l(InfPoss,"^") {
				Set tmpInfPosID = $p(InfPoss,"^",indxi)
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(tmpInfPosID)
				If ($IsObject(objDiags)){
					// 感染日期
					Set InfEffect=""
					Set InfDate  = objDiags.IRInfDate
					Set InfDate  = $zd(InfDate,3)
					Set InfDates = InfDates_","_InfDate
					Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
					Set:InfEffect'="" InfEffects = InfEffects_","_InfEffect
					Set:$IsObject(objDiags.IRInfPosDr) tmpIRInfPos = objDiags.IRInfPosDr.BTDesc
					Set:tmpIRInfPos'="" InfPosDescs = InfPosDescs_"|"_tmpIRInfPos
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
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InfPosDescs,InfDates,InfEffects,InfFactors)
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
			//当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate = aDateTo
			
			// 诊断ID^诊断ID#易感因素ID^易感因素|易感因素ID^易感因素
			Set InfRepInfo =..GetFactors(EpisodeID,TransDate,EndDate)
			Continue:InfRepInfo=""
			Set (InfPosDescs,InfDates,InfEffects,InfFactors)=""
			Set InfFacts = $p(InfRepInfo,"#",2)
			Set InfPoss  = $p(InfRepInfo,"#",1)
			For indxi=1:1:$l(InfFacts,"|") {
				Set tmpInfFacIDs = $p(InfFacts,"|",indxi)
				Set tmpInfFacID = $p(tmpInfFacIDs,"^",1)
				Set objFacts = ##class(DHCHAI.IR.INFPreFactor).GetObjById(tmpInfFacID)
				If ($IsObject(objFacts)){
					Continue:'$IsObject(objFacts.IRPreFactorDr)
					Set Factor = objFacts.IRPreFactorDr.BTDesc
					Set:Factor'="" InfFactors = InfFactors_"|"_Factor
				}
			}
			Set:InfFactors'="" InfFactors=InfFactors_"|"
			Continue:(aFacDesc'="")&&(InfFactors'[("|"_aFacDesc_"|"))  // 易感因素过滤
			For indxi=1:1:$l(InfPoss,"^") {
				Set tmpInfPosID = $p(InfPoss,"^",indxi)
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(tmpInfPosID)
				If ($IsObject(objDiags)){
					// 感染日期
					Set InfEffect=""
					Set InfDate  = objDiags.IRInfDate
					Set InfDate  = $zd(InfDate,3)
					Set InfDates = InfDates_","_InfDate
					Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
					Set:InfEffect'="" InfEffects = InfEffects_","_InfEffect
					Set:$IsObject(objDiags.IRInfPosDr) tmpIRInfPos = objDiags.IRInfPosDr.BTDesc
					Set:tmpIRInfPos'="" InfPosDescs = InfPosDescs_"|"_tmpIRInfPos
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
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
						    
					Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InfPosDescs,InfDates,InfEffects,InfFactors)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfFactorDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfFactorDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfFactorDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfFactorDtlExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  获取患者感染报告中易感因素
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       诊断ID^诊断ID#易感因素ID^易感因素|易感因素ID^易感因素  诊断ID说明患者在期间发生感染，计算感染人数例次数
/// w ##class(DHCHAI.STAT.S400InfFactor).GetFactors("4674","2018-10-16","2018-12-16")
ClassMethod GetFactors(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfFactors=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Quit:'$IsObject(objINFRep)
			Set RepStatus=objINFRep.IRStatusDr
			Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
			Continue:(RepStatus.BTCode'="3")&&(RepStatus.BTCode'="2")
			// 感染诊断信息
			Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			Set InfPosDescs=""
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				// 感染日期
				Set InfDate  = objDiags.IRInfDate
				Set InfXDate = objDiags.IRInfXDate
				Set:InfXDate="" InfXDate=+$h
				Continue:InfDate>aDateTo    // 感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfXDate<aDateFrom // 感染转归日期小雨查询开始日期，非查询期间发生感染
				// 感染诊断
				Set objInfPos = objDiags.IRInfPosDr
				If $IsObject(objInfPos){
					Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_objInfPos.BTDesc
					Set return=return_"^"_xDiagID
				}
			}
			Continue:InfPosDescs=""
			Set LinkPreFactors = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFPreFactor")
			For indx1 = 1:1:$l(LinkPreFactors,","){
				Set xFacID = $p(LinkPreFactors,",",indx1)
				Continue:xFacID=""
				
				Set objFacs = ##class(DHCHAI.IR.INFPreFactor).GetObjById(xFacID)
				Continue:'$IsObject(objFacs)
				Continue:'$IsObject(objFacs.IRPreFactorDr)
				Set Factor = objFacs.IRPreFactorDr.BTDesc
				Set InfFactors = InfFactors_"|"_xFacID_"^"_Factor
			}
		}
	}
	Set:return'="" return = $e(return,2,$l(return))
	Set:InfFactors'="" InfFactors = $e(InfFactors,2,$l(InfFactors))
	Set:InfFactors'="" return=return_"#"_InfFactors
	Quit return
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

}

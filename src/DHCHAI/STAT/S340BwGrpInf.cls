/// 名称: DHCHAI.STAT.S340BwGrpInf
/// 描述: 新生儿住院患者千日医院感染（例次）发病率统计表
/// 编写者：chenjb
/// 编写日期: 2018-10-14
Class DHCHAI.STAT.S340BwGrpInf Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  新生儿住院患者千日医院感染（例次）发病率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S340BwGrpInf","QrySDayInf","","2018-08-01","2018-08-10")
Query QrySDayInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "WtCat:%String,WtCatDesc:%String,PatNum:%Integer,InDays:%Integer,InfNum:%Integer,InfCaseNum:%Integer") [ SqlProc ]
{
}

ClassMethod QrySDayInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QrySDayInf"
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
		
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Continue:'$Isobject(objPaadm)
		Set IsNewBaby=objPaadm.PAIsNewBaby
		Continue:IsNewBaby'=1   // 过滤非新生儿
		Set Weigth=objPaadm.PAAdmitWeight
		Set Weigth=+Weigth
		Set WtCat=1   //默认体重第一类型
		
		// 全院住院患者人数
		If '$d(^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm)=""
			Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm")=num+1
			
			if (Weigth<=1000) 
			{
				Set WtCat=1
			}
			elseif (Weigth>1000)&(Weigth<=1500) 
			{
				Set WtCat=2
				
			}
			elseif (Weigth>1500)&(Weigth<=2500)
			{
				Set WtCat=3
				
			}
			elseif (Weigth>2500)
			{
				Set WtCat=4
			}
			Set num=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"PatAdm"))
			Set ^TMP($zn,$j,NIndex,"WtCat"_WtCat,"PatAdm")=num+1
		}
		// 避免重复获取感染部位
		Set InfPosDescs=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm))
		{
			Set InfPosDescs =##class(DHCHAI.STAT.S390InfPos).GetInfPosInfo(Paadm,aDateFrom,aDateTo)
		}
		Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)=""
		If (InfPosDescs'="") {
			// 全院感染人数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","InfPat",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","InfPat",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
				Set ^TMP($zn,$j,NIndex,"Hosp","InfPat")=num+1
				//不同分组
				Set num=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfPat"))
				Set ^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfPat")=num+1
			}
			// 全院感染例次数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","InfCase"))
				Set ^TMP($zn,$j,NIndex,"Hosp","InfCase")=num+$l(InfPosDescs,"|")
				
				Set num=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfCase"))
				Set ^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfCase")=num+$l(InfPosDescs,"|")				
			}
			
		}
		Set InDays=$i(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InDays")) // 同期在科天数
		Set ^TMP($zn,$j,NIndex,"TansLoc",TansID) = ""
	}
	//四条记录
	Set WtCat ="1"
	Set WtCatDesc = "BW ≤1000g"  //BW 1001g~1500g BW 1501g~2500g BW>2500g
	Set PatNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"PatAdm"))  //在科人数
	Set InDays = +$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InDays"))
	Set InfNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfPat"))
	Set InfCaseNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfCase"))	
	Set Data=$lb(WtCat,WtCatDesc,PatNum,InDays,InfNum,InfCaseNum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set WtCat ="2"
	Set WtCatDesc = "BW 1001g~1500g"  // BW 1501g~2500g BW>2500g
	Set PatNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"PatAdm"))  //在科人数
	Set InDays = +$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InDays"))
	Set InfNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfPat"))
	Set InfCaseNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfCase"))	
	Set Data=$lb(WtCat,WtCatDesc,PatNum,InDays,InfNum,InfCaseNum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set WtCat ="3"
	Set WtCatDesc = "BW 1501g~2500g"  //BW 1001g~1500g  BW>2500g
	Set PatNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"PatAdm"))  //在科人数
	Set InDays = +$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InDays"))
	Set InfNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfPat"))
	Set InfCaseNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfCase"))	
	Set Data=$lb(WtCat,WtCatDesc,PatNum,InDays,InfNum,InfCaseNum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set WtCat ="4"
	Set WtCatDesc = "BW >2500g"  //BW 1001g~1500g  BW>2500g
	Set PatNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"PatAdm"))  //在科人数
	Set InDays = +$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InDays"))
	Set InfNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfPat"))
	Set InfCaseNum=+$g(^TMP($zn,$j,NIndex,"WtCat"_WtCat,"InfCase"))	
	Set Data=$lb(WtCat,WtCatDesc,PatNum,InDays,InfNum,InfCaseNum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QrySDayInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayInfExecute ]
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
/// Description:  住院患者千日医院感染（例次）发病率明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S340BwGrpInf","QrySDayInfDtl","2","2017-08-01","2017-08-30","E","","BW ≤1000g")
Query QrySDayInfDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QrySDayInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QrySDayInfDtl"
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
		//Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤		
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Continue:'$Isobject(objPaadm)
		Set IsNewBaby=objPaadm.PAIsNewBaby
		Continue:IsNewBaby'=1   // 过滤非新生儿
		Set Weigth=objPaadm.PAAdmitWeight
		Set Weigth=+Weigth
		Set WtCat=1   //默认体重第一类型
		//过滤分类
		if (Weigth<=1000) 
		{
			Continue:aLocDesc'="BW ≤1000g"
		}
		elseif (Weigth>1000)&(Weigth<=1500) 
		{
			Continue:aLocDesc'="BW 1001g~1500g"			
		}
		elseif (Weigth>1500)&(Weigth<=2500)
		{
			Continue:aLocDesc'="BW 1501g~2500g"	
		}
		elseif (Weigth>2500)
		{
			Continue:aLocDesc'="BW >2500g"
		}	
		
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
			Set InfPoss =##class(DHCHAI.STAT.S390InfPos).GetInfPosInfo(EpisodeID,TransDate,EndDate)
			Continue:InfPoss=""
			Set (InfPosDescs,InfDates,InfEffects)=""
			For indxi=1:1:$l(InfPoss,"|") {
				Set tmpInfPos      = $p(InfPoss,"|",indxi)
				Set tmpInfPosID    = $p(InfPoss,"^",1)
				Set tmpInfPosDescs = $p(InfPoss,"^",2)
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
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InfPosDescs,InfDates,InfEffects)
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
					
					Set InfPoss =##class(DHCHAI.STAT.S390InfPos).GetInfPosInfo(EpisodeID,TransDate,EndDate)
					Continue:InfPoss=""
					Set (InfPosDescs,InfDates,InfEffects)=""
					For indxi=1:1:$l(InfPoss,"|") {
						Set tmpInfPos      = $p(InfPoss,"|",indxi)
						Set tmpInfPosID    = $p(InfPoss,"^",1)
						Set tmpInfPosDescs = $p(InfPoss,"^",2)
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

ClassMethod QrySDayInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayInfDtlExecute ]
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
/// CreatDate：   2018-08-28
/// Description:  住院患者明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S340BwGrpInf","QrySDayInfPatDtl","2","2017-08-01","2017-08-10","E","","BW ≤1000g")
Query QrySDayInfPatDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InLocWardDays:%String") [ SqlProc ]
{
}

ClassMethod QrySDayInfPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QrySDayInfPatDtl"
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
		//Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤		
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Continue:'$Isobject(objPaadm)
		Set IsNewBaby=objPaadm.PAIsNewBaby
		Continue:IsNewBaby'=1   // 过滤非新生儿
		Set Weigth=objPaadm.PAAdmitWeight
		Set Weigth=+Weigth
		Set WtCat=1   //默认体重第一类型
		//过滤分类
		if (Weigth<=1000) 
		{
			Continue:aLocDesc'="BW ≤1000g"
		}
		elseif (Weigth>1000)&(Weigth<=1500) 
		{
			Continue:aLocDesc'="BW 1001g~1500g"			
		}
		elseif (Weigth>1500)&(Weigth<=2500)
		{
			Continue:aLocDesc'="BW 1501g~2500g"	
		}
		elseif (Weigth>2500)
		{
			Continue:aLocDesc'="BW >2500g"
		}		
		
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
			Set InLocWardDays = $s(OutLocDate'="":OutLocDate,1:(+$h))-TransDate
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
		    
			Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InLocWardDays)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    
		}
    }
	If (aLocType="E") {
	    Set xTransID = ""
		For {
			//QryAntUseDenDtl ->NIndex
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
					Set InLocWardDays = $s(OutLocDate'="":OutLocDate,1:(+$h))-TransDate
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		
                    Set TransTime=objTrans.PATransTime
                    Set:TransTime'="" TransTime=$zt(TransTime)
					Set OutLocTime=objTrans.PAOutLocTime
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
					Set:InLocWardDays=0 InLocWardDays=1 //当天出入的记为1
					Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InLocWardDays)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QrySDayInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayInfPatDtlExecute ]
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

}

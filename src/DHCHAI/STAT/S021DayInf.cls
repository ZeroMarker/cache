/// 名称: DHCHAI.STAT.S021DayInf
/// 描述: 出院患者千日医院感染（例次）发病率统计表
/// 编写者：zhoubo
/// 编写日期: 2018-08-29
Class DHCHAI.STAT.S021DayInf Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-08-28
/// Description:  出院患者千日医院感染（例次）发病率
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S021DayInf","QryS021Inf","","2018-08-01","2018-08-10")
Query QryS021Inf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,LocInfSum:%Integer,LocCaseSum:%Integer,LocDischSum:%Integer,WardDischSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,WardInfSum:%Integer,WardCaseSum:%Integer,GroupInfSum:%Integer,HospInfSum:%Integer,InDaysSum:%Integer,WardDaysSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryS021InfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryS021Inf"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
					Continue:'$IsObject(objPaadm)
					
					// 出院科室/病区
					Set objDishLoc = objPaadm.PADischLocDr
					Continue:'$IsObject(objDishLoc)
                    Set objDishWard = objPaadm.PADischWardDr
					Continue:'$IsObject(objDishWard)
					//  医院过滤
					Continue:'$IsObject(objDishLoc.BTHospDr)
					Continue:(aHospIDs'="")&($listfind(aHospIDs,objDishLoc.BTHospDr.%Id())<1)
					
					Set DishLocID = objDishLoc.%Id()
					Set DishWardID = objDishWard.%Id()
					// 出院科室、病区的出院人数			   
				    Set num=+$g(^TMP($zn,$j,NIndex,"Loc",DishLocID,"PatAdm"))
					Set ^TMP($zn,$j,NIndex,"Loc",DishLocID,"PatAdm")=num+1
					Set num=+$g(^TMP($zn,$j,NIndex,"Ward",DishWardID,"PatAdm"))
					Set ^TMP($zn,$j,NIndex,"Ward",DishWardID,"PatAdm")=num+1
					
					Set xDate=0
					For {
						Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",xPaadm,xDate))
						Quit:xDate=""
						
						Set xTransID=0
						For {
							Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",xPaadm,xDate,xTransID))
							Quit:xTransID=""
						
							Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
							Continue:'$IsObject(objTrans)
							Continue:'$IsObject(objTrans.PATransLocDr)
							Set TLocID     = objTrans.PATransLocDr.%Id()
							Set TransDate  = objTrans.PATransDate
							Set OutLocDate = objTrans.PAOutLocDate
							
							Set GroupDr="",GroupCode="",GroupDesc=""
							If $IsObject(objTrans.PATransLocDr.BTGroupDr) {
								Set GroupDr 	= objTrans.PATransLocDr.BTGroupDr.%Id()
								Set GroupCode	= objTrans.PATransLocDr.BTGroupDr.BTCode
								Set GroupDesc	= objTrans.PATransLocDr.BTGroupDr.BTDesc	
							}Else {
								Set GroupDesc="其他科"
								Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
								If $IsObject(objGroup) {
									Set GroupDr   = objGroup.%Id()
									Set GroupCode = objGroup.BTCode	
								}
							}
							//bug 转科次数 Set InDays=$i(^TMP($zn,$j,NIndex,TLocID,"InDays")) // 同期在科天数
							Set InDays= $s((+OutLocDate)>0:((+OutLocDate)-TransDate),1:((+$h))-TransDate)
							Set ^TMP($zn,$j,NIndex,TLocID,"InDays")=(+$g(^TMP($zn,$j,NIndex,TLocID,"InDays")))+InDays
							
							Set:TransDate<aDateFrom TransDate = aDateFrom
							Set:OutLocDate>aDateTo OutLocDate = aDateTo
							// 当前未转出,截止为查询结束日期
							Set EndDate = OutLocDate
							Set:EndDate="" EndDate = aDateTo
							Set InfPosDescs =##class(DHCHAI.STAT.S390InfPos).GetInfPosInfo(xPaadm,TransDate,EndDate)
							If (InfPosDescs'="") {
								// 全院感染人数
								If '$d(^TMP($zn,$j,NIndex,"Hosp","InfPat",xPaadm))
								{
									Set ^TMP($zn,$j,NIndex,"Hosp","InfPat",xPaadm)=""
									Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))
									Set ^TMP($zn,$j,NIndex,"Hosp","InfPat")=num+1
								}
								// 科室分组感染人数
								If '$d(^TMP($zn,$j,NIndex,"LocGroup",GroupDesc,"InfPat",xPaadm))
								{
									Set ^TMP($zn,$j,NIndex,"LocGroup",GroupDesc,"InfPat",xPaadm)=""
									Set num=+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupDesc,"InfPat"))
									Set ^TMP($zn,$j,NIndex,"LocGroup",GroupDesc,"InfPat")=num+1
								}
								// 科室感染人数
								Set num=+$g(^TMP($zn,$j,NIndex,"InfLoc",TLocID,"InfPat"))
								Set ^TMP($zn,$j,NIndex,"InfLoc",TLocID,"InfPat")=num+1
								// 科室感染例次数
								Set num=+$g(^TMP($zn,$j,NIndex,"InfLoc",TLocID,"InfCase"))
								Set ^TMP($zn,$j,NIndex,"InfLoc",TLocID,"InfCase")=num+$l(InfPosDescs,"|")
							}
						}
					}
					
					Set xDate=0
					For {
						Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",xPaadm,xDate))
						Quit:xDate=""
						
						Set xTransID=0
						For {
							Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",xPaadm,xDate,xTransID))
							Quit:xTransID=""
						
							Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
							Continue:'$IsObject(objTrans)
							Continue:'$IsObject(objTrans.PATransLocDr)
							Set TWardID    = objTrans.PATransLocDr.%Id()
							Set TransDate  = objTrans.PATransDate
							Set OutLocDate = objTrans.PAOutLocDate
							//Set InDays=$i(^TMP($zn,$j,NIndex,TWardID,"InDays")) // 同期在病区天数
							Set InDays= $s((+OutLocDate)>0:((+OutLocDate)-TransDate),1:((+$h))-TransDate)
							Set ^TMP($zn,$j,NIndex,TWardID,"InDays")=(+$g(^TMP($zn,$j,NIndex,TWardID,"InDays")))+InDays
							
							Set:TransDate<aDateFrom TransDate = aDateFrom
							Set:OutLocDate>aDateTo OutLocDate = aDateTo
							// 当前未转出,截止为查询结束日期
							Set EndDate = OutLocDate
							Set:EndDate="" EndDate = aDateTo
							Set InfPosDescs =##class(DHCHAI.STAT.S390InfPos).GetInfPosInfo(xPaadm,TransDate,EndDate)
							If (InfPosDescs'="") {
								// 出院病区感染人数
								Set num=+$g(^TMP($zn,$j,NIndex,"InfWard",TWardID,"InfPat"))
								Set ^TMP($zn,$j,NIndex,"InfWard",TWardID,"InfPat")=num+1
								// 出院病区感染例次数
								Set num=+$g(^TMP($zn,$j,NIndex,"InfWard",TWardID,"InfCase"))
								Set ^TMP($zn,$j,NIndex,"InfWard",TWardID,"InfCase")=num+$l(InfPosDescs,"|")
							}
						}
					}
				}
			}
		}
    }
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
				Set GroupDr   = objGroup.%Id()
				Set GroupCode = objGroup.BTCode	
			}
		}
		Set HospInfSum  =+$g(^TMP($zn,$j,NIndex,"Hosp","InfPat"))                //全院感染人数
		Set GroupInfSum =+$g(^TMP($zn,$j,NIndex,"LocGroup",GroupDesc,"InfPat"))  //分组感染人数
		Set LocDischSum =+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"PatAdm"))          // 科室出院人数
		Set LocInfSum   =+$g(^TMP($zn,$j,NIndex,"InfLoc",xLocID,"InfPat"))	 
		Set LocCaseSum  =+$g(^TMP($zn,$j,NIndex,"InfLoc",xLocID,"InfCase"))
		Set InDaysSum   =+$g(^TMP($zn,$j,NIndex,xLocID,"InDays"))         // 同期在科天数
		Set xSubID = ""
	 	For {
			Set xSubID = $o(^DHCHAI.BT.LocationD(xLocID,"Link",xSubID))
			Quit:xSubID=""
			Set xID = xLocID_"||"_xSubID
			Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xID)
			Continue:'$IsObject(objLocLink)
			Continue:'$IsObject(objLocLink.BTLinkLocDr)
			Continue:(+objLocLink.BTIsActive)'=1
			
			Set LinkWardID   = objLocLink.BTLinkLocDr.%Id()
			Set LinkWardDesc = objLocLink.BTLinkLocDr.BTDesc2
			Set:LinkWardDesc="" LinkWardDesc = objLocLink.BTLinkLocDr.BTDesc
		    Set:$p(LinkWardDesc,"-",2)'="" LinkWardDesc=$p(LinkWardDesc,"-",2)
		   
		    Set WardDischSum=+$g(^TMP($zn,$j,NIndex,"Ward",LinkWardID,"PatAdm"))	    
		    Set WardInfSum  =+$g(^TMP($zn,$j,NIndex,"InfWard",LinkWardID,"InfPat"))	 
			Set WardCaseSum =+$g(^TMP($zn,$j,NIndex,"InfWard",LinkWardID,"InfCase"))
		    Set WardDaysSum =+$g(^TMP($zn,$j,NIndex,LinkWardID,"InDays"))        // 同期在病区天数
		    
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,LocInfSum,LocCaseSum,LocDischSum,WardDischSum,LinkWardID,LinkWardDesc,WardInfSum,WardCaseSum,GroupInfSum,HospInfSum,InDaysSum,WardDaysSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS021InfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS021InfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS021InfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS021InfExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  出院患者千日医院感染（例次）发病率明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S021DayInf","QryS021InfDtl","","2018-08-01","2018-08-10")
Query QryS021InfDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryS021InfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryS021InfDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
					Continue:'$IsObject(objPaadm)
					
					// 出院科室/病区
					Set objDishLoc = objPaadm.PADischLocDr
					Continue:'$IsObject(objDishLoc)
                    Set objDishWard = objPaadm.PADischWardDr
					Continue:'$IsObject(objDishWard)
					//  医院过滤
					Continue:'$IsObject(objDishLoc.BTHospDr)
					Continue:(aHospIDs'="")&($listfind(aHospIDs,objDishLoc.BTHospDr.%Id())<1)
					
					Set PatData =..BuildPaadmData(xPaadm)
					Continue:PatData=""
					If (aLocType="E") {
						Set xDate=0
						For {
							Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",xPaadm,xDate))
							Quit:xDate=""
							
							Set xTransID=0
							For {
								Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",xPaadm,xDate,xTransID))
								Quit:xTransID=""
							
								Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
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
								Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤
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
								Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
							    Set xxDate=0
								For {
									Set xxDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xxDate))
									Quit:xxDate=""
									Quit:xxDate>aDateTo
								
									Set xID=0
									For {
										Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xxDate,xID))
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
					}
					If (aLocType="W") {
						Set xDate=0
						For {
							Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",xPaadm,xDate))
							Quit:xDate=""
							
							Set xTransID=0
							For {
								Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",xPaadm,xDate,xTransID))
								Quit:xTransID=""
							
								Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
								Continue:'$IsObject(objTrans)
								Set objPaadm = objTrans.PAEpisodeDr
								Set objTransLoc = objTrans.PATransLocDr
								Continue:'$IsObject(objPaadm)
								Continue:'$IsObject(objTransLoc)
											
								Set EpisodeID = objPaadm.%Id()
								Set TransWardID =  objTransLoc.%Id()
								Set TransWardDesc = objTransLoc.BTDesc2
								Set:TransWardDesc="" TransWardDesc = objTransLoc.BTDesc
								Continue:TransWardDesc=""
								Set:$p(TransWardDesc,"-",2)'="" TransWardDesc=$p(TransWardDesc,"-",2)
								Continue:(aLocDesc'="")&&(aLocDesc'=TransWardDesc) // 科室过滤
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
								Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
								Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
								Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
								Set TransTime = objTrans.PATransTime
							    Set:TransTime'="" TransTime=$zt(TransTime)
							    Set OutLocTime =objTrans.PAOutLocTime
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
			}
		}
    }
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS021InfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS021InfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS021InfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS021InfDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2018-08-31
/// Description:  出院患者明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aLocType： 科室类型(E/W)
/// 			  aLocGroup：科室分组名称  
/// 			  aLocDesc:  科室、病区名称
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S021DayInf","QryInfPatDtl","1","2018-10-01","2018-10-16","E","妇产科","")
Query QryInfPatDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InLocWardDays:%String") [ SqlProc ]
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
    
    Set NIndex="QryInfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
					Continue:'$IsObject(objPaadm)
					
					// 出院科室/病区
					Set objDishLoc = objPaadm.PADischLocDr
					Continue:'$IsObject(objDishLoc)
                    Set objDishWard = objPaadm.PADischWardDr
					Continue:'$IsObject(objDishWard)
					//  医院过滤
					Continue:'$IsObject(objDishLoc.BTHospDr)
					Continue:(aHospIDs'="")&($listfind(aHospIDs,objDishLoc.BTHospDr.%Id())<1)
					
					Set PatData =..BuildPaadmData(xPaadm)
					Continue:PatData=""
					If (aLocType="E") {
						Set xDate=0
						For {
							Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",xPaadm,xDate))
							Quit:xDate=""
							
							Set xTransID=0
							For {
								Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",xPaadm,xDate,xTransID))
								Quit:xTransID=""
							
								Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
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
								Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤
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
								Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
							    Set xxDate=0
								For {
									Set xxDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xxDate))
									Quit:xxDate=""
									Quit:xxDate>aDateTo
								
									Set xID=0
									For {
										Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeID,xxDate,xID))
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
										Set InLocWardDays = $s((+OutLocDate)>0:(OutLocDate-TransDate),1:((+$h))-TransDate)
										Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
										Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
							
					                    Set TransTime=objTrans.PATransTime
					                    Set:TransTime'="" TransTime=$zt(TransTime)
										Set OutLocTime=objTrans.PAOutLocTime
									    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
								    	Set TransDateTime =TransDate_" "_TransTime
										Set OutLocDateTime =OutLocDate_" "_OutLocTime
										
										//Set:InLocWardDays=0 InLocWardDays=1   //当天入当天出
										Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InLocWardDays)
										Set ^CacheTemp(repid,ind)=Data
										Set ind=ind+1
									}
								}
							}
						}
					}
					If (aLocType="W") {
						Set xDate=0
						For {
							Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",xPaadm,xDate))
							Quit:xDate=""
							
							Set xTransID=0
							For {
								Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",xPaadm,xDate,xTransID))
								Quit:xTransID=""
							
								Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
								Continue:'$IsObject(objTrans)
								Set objPaadm = objTrans.PAEpisodeDr
								Set objTransLoc = objTrans.PATransLocDr
								Continue:'$IsObject(objPaadm)
								Continue:'$IsObject(objTransLoc)
											
								Set EpisodeID = objPaadm.%Id()
								Set TransWardID =  objTransLoc.%Id()
								Set TransWardDesc = objTransLoc.BTDesc2
								Set:TransWardDesc="" TransWardDesc = objTransLoc.BTDesc
								Continue:TransWardDesc=""
								Set:$p(TransWardDesc,"-",2)'="" TransWardDesc=$p(TransWardDesc,"-",2)
								Continue:(aLocDesc'="")&&(aLocDesc'=TransWardDesc) // 科室过滤
								Set TransDate = objTrans.PATransDate
								Set OutLocDate= objTrans.PAOutLocDate
								Set InLocWardDays = $s(OutLocDate'="":OutLocDate-TransDate,1:(+$h))-TransDate
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
								Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
								Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
								Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
								Set TransTime = objTrans.PATransTime
							    Set:TransTime'="" TransTime=$zt(TransTime)
							    Set OutLocTime =objTrans.PAOutLocTime
							    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
							    Set TransDateTime =TransDate_" "_TransTime
								Set OutLocDateTime =OutLocDate_" "_OutLocTime
								
								//Set:InLocWardDays=0 InLocWardDays=1   //当天入当天出
								Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime,InLocWardDays)
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1
							}
						}
					}
				}
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
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
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

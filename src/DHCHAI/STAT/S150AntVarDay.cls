/// 名称: DHCHAI.STAT.S150AntVarDay
/// 描述: 出院患者人均使用抗菌药物品种数和天数统计表
/// 编写者：pylian
/// 编写日期: 2018-07-17
Class DHCHAI.STAT.S150AntVarDay Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-17
/// Description:  出院患者人均使用抗菌药物品种数和天数统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S150AntVarDay","QryAntVarDay","1","2016-01-01","2018-07-17")
Query QryAntVarDay(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,DishSum:%Integer,AntSum:%Integer,AntCount:%Integer,UseDays:%Integer,LinkWardID:%String,LinkWardDesc:%String,DishWardSum:%Integer,AntWardSum:%Integer,AntCountWard:%Integer,UseDaysWard:%Integer") [ SqlProc ]
{
}

ClassMethod QryAntVarDayExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Kill ^TMP($zn,$j,"QryAntVarDay")
    
    Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		For xDishDate = aDateFrom:1:aDateTo{
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
				     
				    Set DischDate = objPaadm.PADischDate
					Set AdmDate = objPaadm.PAAdmDate
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
								   
				    Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"PatAdm"))
					Set ^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"PatAdm")=num+1
					Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"PatAdm"))
					Set ^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"PatAdm")=num+1
					
					// 抗生素使用信息
					Set AntUseInfo = ..GetAntUseInfo(xPaadm,AdmDate,DischDate)
					Set IsUseAnt = $p(AntUseInfo,"^",1)
					Set AntCount = $p(AntUseInfo,"^",2)
					Set UseDays = $p(AntUseInfo,"^",3)
					
					If (AntCount>0){
						
						Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"AntUse"))
						Set ^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"AntUse")=num+1
						Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"AntUse"))
						Set ^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"AntUse")=num+1
						
						Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"AntCount"))
						Set ^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"AntCount")=num+AntCount
						Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"AntCount"))
						Set ^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"AntCount")=num+AntCount
						
						Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"UseDays"))
						Set ^TMP($zn,$j,"QryAntVarDay","Loc",DishLocID,"UseDays")=num+UseDays
						Set num=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"UseDays"))
						Set ^TMP($zn,$j,"QryAntVarDay","Ward",DishWardID,"UseDays")=num+UseDays
						
					}
				}
			}
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryAntVarDay","Loc",xLocID))
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
		
		Set DishSum=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",xLocID,"PatAdm"))	 
		Set AntSum=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",xLocID,"AntUse"))
		Set AntCount=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",xLocID,"AntCount"))
		Set UseDays=+$g(^TMP($zn,$j,"QryAntVarDay","Loc",xLocID,"UseDays"))
		
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
		    Set DishWardSum=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",LinkWardID,"PatAdm"))	 
			Set AntWardSum=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",LinkWardID,"AntUse"))
			Set AntCountWard=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",LinkWardID,"AntCount"))	 
			Set UseDaysWard=+$g(^TMP($zn,$j,"QryAntVarDay","Ward",LinkWardID,"UseDays"))
		    
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,DishSum,AntSum,AntCount,UseDays,LinkWardID,LinkWardDesc,DishWardSum,AntWardSum,AntCountWard,UseDaysWard)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	   
	}
		
	Kill ^TMP($zn,$j,"QryAntVarDay")
	Quit $$$OK
}

ClassMethod QryAntVarDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntVarDayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntVarDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntVarDayExecute ]
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
/// CreatDate：   2018-07-16
/// Description:  出院患者人均使用抗菌药物品种数和天数统计明细表(不考虑转科使用情况)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S150AntVarDay","QryAntVarDayDtl","1","","","","2016-01-01","2016-10-25")
Query QryAntVarDayDtl(aHospIDs As %String = "", aLocType As %String = "", aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DishLocID:%String,DishLocDesc:%String,DishWardID:%String,DishWardDesc:%String,GroupCode:%String,GroupDesc:%String,IsUseAnt:%String,AntCount:%Integer,UseDays:%Integer,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntVarDayDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aLocType As %String = "", aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")

    Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		For xDishDate = aDateFrom:1:aDateTo{
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
                   
                    Set DischDate = objPaadm.PADischDate
					Set AdmDate = objPaadm.PAAdmDate
					// 出院科室/病区
					Set objDishLoc = objPaadm.PADischLocDr
					Continue:'$IsObject(objDishLoc)
                    Set objDishWard = objPaadm.PADischWardDr
					Continue:'$IsObject(objDishWard)
					//  医院过滤
					Continue:'$IsObject(objDishLoc.BTHospDr)
					Continue:(aHospIDs'="")&&($listfind(aHospIDs,objDishLoc.BTHospDr.%Id())<1)
					
					Set DishLocID = objDishLoc.%Id()
					Set DishLocDesc = objDishLoc.BTDesc2
					Set:DishLocDesc="" DishLocDesc=objDishLoc.BTDesc
					Set:DishLocDesc["-" DishLocDesc=$p(DishLocDesc,"-",2)
					If (aLocType="E") {
						Continue:(aLocIDs'="")&&($listfind(aLocIDs,DishLocID)<1)	
					}
					Set DishWardID = objDishWard.%Id()
					Set DishWardDesc = objDishWard.BTDesc2
					Set:DishWardDesc="" DishWardDesc=objDishWard.BTDesc
					Set:DishWardDesc["-" DishWardDesc=$p(DishWardDesc,"-",2)
				    If (aLocType="W") {
						Continue:(aLocIDs'="")&&($listfind(aLocIDs,DishWardID)<1)
					}
					
					If (aLocGroup'="") {
						Set objGroupLoc = objDishLoc.BTGroupDr
						If (objGroupLoc) {
							Set GroupDr 	= objDishLoc.BTGroupDr.%Id()
							Set GroupCode	= objDishLoc.BTGroupDr.BTCode
							Set GroupDesc	= objDishLoc.BTGroupDr.BTDesc	
						}Else {
							Set GroupDesc="其他科"
							Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
							If (objGroup) {
								Set GroupDr 	= objGroup.%Id()
								Set GroupCode	= objGroup.BTCode
							}
						}
						Continue:(aLocGroup'=GroupCode)
					}
					// 抗生素使用信息
					Set AntUseInfo = ..GetAntUseInfo(xPaadm,AdmDate,DischDate)
					Set IsUseAnt = $p(AntUseInfo,"^",1)
					Set AntCount = $p(AntUseInfo,"^",2)
					Set UseDays = $p(AntUseInfo,"^",3)
					Set IsUseAnt = $s(IsUseAnt=1:"是",1:"")
					
					Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData="" 
					Set (TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime,TransDateTime,OutLocDateTime)=""
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
							
							Set TransWardID=objTrans.PATransLocDr.%Id()
							Set TransWardDesc=objTrans.PATransLocDr.BTDesc2
							Set:TransWardDesc="" TransWardDesc=objTrans.PATransLocDr.BTDesc
						    Set:TransWardDesc["-" TransWardDesc=$p(TransWardDesc,"-",2)
						
							Set TransDate=objTrans.PATransDate
							Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
		                    Set TransTime=objTrans.PATransTime
		                    Set:TransTime'="" TransTime=$zt(TransTime)
							Set OutLocDate=objTrans.PAOutLocDate
							Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
							Set OutLocTime=objTrans.PAOutLocTime
						    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
						    Set TransDateTime =TransDate_" "_TransTime
						    Set OutLocDateTime =OutLocDate_" "_OutLocTime
						    
							Set Data = PatData_$lb(DishLocID,DishLocDesc,DishWardID,DishWardDesc,GroupCode,GroupDesc,IsUseAnt,AntCount,UseDays,TransWardDesc,TransDateTime,OutLocDateTime)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
				
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryAntVarDayDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntVarDayDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntVarDayDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntVarDayDtlExecute ]
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

	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-07-167
/// Description:  获取就诊期间使用抗菌药物（全身用药）品种数、用药天数
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID：就诊ID
/// return:       
/// w ##class(DHCHAI.STAT.S150AntVarDay).GetAntUseInfo("331","","")
ClassMethod GetAntUseInfo(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
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
	
	Set (IsUseAnt,AntCount,UseDays) =0
	Set (AntGeneric,firstUseDate,LastUseDate)=""   //品种,首次用药,最后用药
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
				Set Instruc = objOrdItem.OEInstruc //给药途径
				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				//Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药	
				//Continue:'$listfind(InstrucList,InstrucMap)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				Set IsUseAnt = 1
				
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
				
				// 计算单个药物期内用药时间段(日期控制在传入日期内)
				If SttDate<aDateFrom{
					Set SttDate = aDateFrom
				}
				If EndDate>aDateTo{
					Set EndDate = aDateTo
				}
				
				// 首次用药日期
				If firstUseDate=""{
					Set firstUseDate = SttDate
				}else{
					Set:firstUseDate>SttDate firstUseDate = SttDate
				}
				// 最后用药日期
				If LastUseDate=""{
					Set LastUseDate = EndDate
				}else{
					Set:LastUseDate<EndDate LastUseDate = EndDate
				}	
				
				Set Generic = objOrdItem.OEGeneric  // 通用名，用于计算品种
				// 品种
				If '$listfind(AntGeneric,Generic){
					Set AntCount = AntCount+1
				}
				Set AntGeneric = AntGeneric_$lb(Generic)
			}
		}
	}
    If (IsUseAnt=1) {
		Set UseDays = LastUseDate-firstUseDate+1	//用药天数
    }
		
	Set return = IsUseAnt_"^"_AntCount_"^"_UseDays
	Quit return
}

}

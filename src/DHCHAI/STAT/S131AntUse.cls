/// 名称: DHCHAI.STAT.S131AntUse
/// 描述: 出院患者抗菌药物使用率统计表
/// 编写者：pylian
/// 编写日期: 2018-07-16
Class DHCHAI.STAT.S131AntUse Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-16
/// Description:  出院患者抗菌药物使用率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S131AntUse","QryOutPatAntUse","1","2016-01-01","2018-07-17")
Query QryOutPatAntUse(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,DishSum:%Integer,AntSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,DishWardSum:%Integer,AntWardSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryOutPatAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
    Kill ^TMP($zn,$j,"QryOutPatAntUse")
    
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
								   
				    Set num=+$g(^TMP($zn,$j,"QryOutPatAntUse","Loc",DishLocID,"PatAdm"))
					Set ^TMP($zn,$j,"QryOutPatAntUse","Loc",DishLocID,"PatAdm")=num+1
					Set num=+$g(^TMP($zn,$j,"QryOutPatAntUse","Ward",DishWardID,"PatAdm"))
					Set ^TMP($zn,$j,"QryOutPatAntUse","Ward",DishWardID,"PatAdm")=num+1
					
					// 抗生素使用标记
					Set AntUseFlg = ..GetAntUseInfo(xPaadm)
					If (AntUseFlg=1){
						Set num=+$g(^TMP($zn,$j,"QryOutPatAntUse","Loc",DishLocID,"AntUse"))
						Set ^TMP($zn,$j,"QryOutPatAntUse","Loc",DishLocID,"AntUse")=num+1
						Set num=+$g(^TMP($zn,$j,"QryOutPatAntUse","Ward",DishWardID,"AntUse"))
						Set ^TMP($zn,$j,"QryOutPatAntUse","Ward",DishWardID,"AntUse")=num+1
					}
				}
			}
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryOutPatAntUse","Loc",xLocID))
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
		
		Set DishSum=+$g(^TMP($zn,$j,"QryOutPatAntUse","Loc",xLocID,"PatAdm"))	 
		Set AntSum=+$g(^TMP($zn,$j,"QryOutPatAntUse","Loc",xLocID,"AntUse"))
		
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
		    Set DishWardSum=+$g(^TMP($zn,$j,"QryOutPatAntUse","Ward",LinkWardID,"PatAdm"))	 
			Set AntWardSum=+$g(^TMP($zn,$j,"QryOutPatAntUse","Ward",LinkWardID,"AntUse"))
		    
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,DishSum,AntSum,LinkWardID,LinkWardDesc,DishWardSum,AntWardSum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	   
	}
   
	Kill ^TMP($zn,$j,"QryOutPatAntUse")
	Quit $$$OK
}

ClassMethod QryOutPatAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutPatAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutPatAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutPatAntUseExecute ]
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
/// Description:  出院患者抗菌药物使用率明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S131AntUse","QryAntUseDtl","1|2","W","","30","2016-10-01","2016-10-25")
Query QryAntUseDtl(aHospIDs As %String = "", aLocType As %String = "", aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DishLocID:%String,DishLocDesc:%String,DishWardID:%String,DishWardDesc:%String,GroupCode:%String,GroupDesc:%String,AntUseFlg:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aLocType As %String = "", aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
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
					// 抗生素使用标记
					Set AntUseFlg = ..GetAntUseInfo(xPaadm)
					Set AntUseFlg = $s(AntUseFlg=1:"是",1:"")
					
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

							Set Data = PatData_$lb(DishLocID,DishLocDesc,DishWardID,DishWardDesc,GroupCode,GroupDesc,AntUseFlg,TransWardDesc,TransDateTime,OutLocDateTime)
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

ClassMethod QryAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseDtlExecute ]
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
/// CreatDate：   2018-07-16
/// Description:  判断就诊期间是否使用抗菌药物（全身用药）
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID：就诊ID
/// return:        1：是， 0：否
/// w ##class(DHCHAI.STAT.S131AntUse).GetAntUseInfo("379")
ClassMethod GetAntUseInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return =0
	Quit:aEpisodeID="" return
    
    Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
 	Set InstrucList=","_InstrucList_","
 	
	Set Flg =0
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		Quit:Flg=1
		
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive'=1	// 无效医嘱
		Set SCode   = objOrdItem.OESCode
		Set OrdType = objOrdItem.OEOrdType
		Continue:OrdType'="R" //过滤掉非药品医嘱
		Continue:objOrdItem.OEAntUseFlag'=1  //抗菌用药标志
	
		Set Priority = objOrdItem.OEPriority	//医嘱类型		
		Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OEPriority",Priority)
		Continue:PriorityMap=""
		
		Set Instruc = objOrdItem.OEInstruc //给药途径
		Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiAdminRoute",Instruc)
		Continue:InstrucMapStr=""
		Set InstrucMap = $p(InstrucMapStr,"^",3)
		//Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药
		//Continue:'$listfind(InstrucList,InstrucMap)
		Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))	
		
		Set Flg =1		
	}
	Set return =Flg
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-07-16
/// Description:  查询患者抗菌药物（全身用药）医嘱列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID：就诊ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S131AntUse","QryAntUseInfo","331")
Query QryAntUseInfo(aEpisodeID As %String) As %Query(ROWSPEC = "OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDate:%String,OrdTime:%String,SttDate:%String,SttTime:%String,OrdLoc:%String,OrdDoc:%String,EndDate:%String,EndTime:%String,AntUsePurpose:%String,Instruc:%String,DrgPoison:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:aEpisodeID="" $$$OK
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
 	Set InstrucList=","_InstrucList_","
 	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive'=1	// 无效医嘱
		Set SCode   = objOrdItem.OESCode
		Set OrdType = objOrdItem.OEOrdType
		Continue:OrdType'="R" //过滤掉非药品医嘱
		Continue:objOrdItem.OEAntUseFlag'=1  //抗菌用药标志
		Set OrdDesc = objOrdItem.OEOrdDesc
		Set Generic=objOrdItem.OEGeneric
		Set Priority= objOrdItem.OEPriority
		Set OrdDate = objOrdItem.OEOrdDate
		Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
		Set OrdTime = objOrdItem.OEOrdTime
		Set:OrdTime'="" OrdTime=$zt(OrdTime)
		Set SttDate = objOrdItem.OESttDate
		Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set SttTime = objOrdItem.OESttTime
		Set:SttTime'="" SttTime=$zt(SttTime)
		Set EndDate	= objOrdItem.OEXDate
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set EndTime	= objOrdItem.OEXTime
		Set:EndTime'="" EndTime=$zt(EndTime)
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
		
		Set Instruc = objOrdItem.OEInstruc //给药途径
		Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiAdminRoute",Instruc)		
		Continue:InstrucMapStr=""
		Set InstrucMap = $p(InstrucMapStr,"^",3)
		//Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药
		Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
		
		Set DrgPoison = objOrdItem.OEAntDrgPoison  //抗菌用药等级
        Set OrdItemID = objOrdItem.OEXCode
		Set Data=$lb(xID,OrdItemID,OrdDesc,Generic,Priority,OrdDate,OrdTime,SttDate,SttTime,OrdLocDesc,OrdDocDesc,EndDate,EndTime,UsePurpose,Instruc,DrgPoison)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAntUseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseInfoExecute ]
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

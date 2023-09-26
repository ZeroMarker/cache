/// 名称: DHCHAI.STAT.S160AntBacSub
/// 描述: 出院患者使用抗菌药物病原学送检率统计表
/// 编写者：pylian
/// 编写日期: 2018-07-18
Class DHCHAI.STAT.S160AntBacSub Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-18
/// Description:  出院患者使用抗菌药物病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem、DHCHAI.DP.LabVisitNumber
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S160AntBacSub","QryAntBacSub","1","2016-01-01","2018-07-17")
Query QryAntBacSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,GroupCode:%String,GroupDesc:%String,DishSum:%Integer,AntSum:%Integer,CureUseSum:%Integer,AntSubmSum:%Integer,CureSubmSum:%Integer,LinkWardID:%String,LinkWardDesc:%String,DishWard:%Integer,AntWard:%Integer,CureWard:%Integer,AntSubmWard:%Integer,CureSubmWard:%Integer") [ SqlProc ]
{
}

ClassMethod QryAntBacSubExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
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
    Kill ^TMP($zn,$j,"QryAntBacSub")
    
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
								   
				    Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"PatAdm"))
					Set ^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"PatAdm")=num+1
					Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"PatAdm"))
					Set ^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"PatAdm")=num+1
					
					// 抗生素使用、送检信息
					Set AntUseInfo = ..GetAntUseInfo(xPaadm)
					Set IsAntUse  = $p(AntUseInfo,"^",1)
					Set IsCureUse = $p(AntUseInfo,"^",2)
					Set IsSubmiss = $p(AntUseInfo,"^",3)
					If (IsAntUse=1){
						Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"AntUse"))
						Set ^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"AntUse")=num+1
						Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"AntUse"))
						Set ^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"AntUse")=num+1
						
						If (IsSubmiss=1){
							Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"AntSubmiss"))
							Set ^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"AntSubmiss")=num+1
							Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"AntSubmiss"))
							Set ^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"AntSubmiss")=num+1
						}
					}
					If (IsCureUse=1){
						Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"CureUse"))
						Set ^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"CureUse")=num+1
						Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"CureUse"))
						Set ^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"CureUse")=num+1
						
						If (IsSubmiss=1){
							Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"CureSubmiss"))
							Set ^TMP($zn,$j,"QryAntBacSub","Loc",DishLocID,"CureSubmiss")=num+1
							Set num=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"CureSubmiss"))
							Set ^TMP($zn,$j,"QryAntBacSub","Ward",DishWardID,"CureSubmiss")=num+1
						}
					}
				}
			}
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"QryAntBacSub","Loc",xLocID))
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
		
		Set DishSum=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",xLocID,"PatAdm"))	 
		Set AntSum=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",xLocID,"AntUse"))
		Set CureUseSum=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",xLocID,"CureUse"))
		Set AntSubmSum=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",xLocID,"AntSubmiss"))
		Set CureSubmSum=+$g(^TMP($zn,$j,"QryAntBacSub","Loc",xLocID,"CureSubmiss"))
		
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
		    Set DishWard=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",LinkWardID,"PatAdm"))	 
			Set AntWard=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",LinkWardID,"AntUse"))
			Set CureWard=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",LinkWardID,"CureUse"))	 
			Set AntSubmWard=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",LinkWardID,"AntSubmiss"))	 
			Set CureSubmWard=+$g(^TMP($zn,$j,"QryAntBacSub","Ward",LinkWardID,"CureSubmiss"))
		    
		    Set Data=$lb(xLocID,LocDesc,GroupCode,GroupDesc,DishSum,AntSum,CureUseSum,AntSubmSum,CureSubmSum,LinkWardID,LinkWardDesc,DishWard,AntWard,CureWard,AntSubmWard,CureSubmWard)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	 	}
	}
   
	Kill ^TMP($zn,$j,"QryAntBacSub")
	Quit $$$OK
}

ClassMethod QryAntBacSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntBacSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntBacSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntBacSubExecute ]
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
/// Description:  出院患者使用抗菌药物病原学送检率明细(不区分用药、送检是否在一个病区)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem、DHCHAI.DP.LabVisitNumber
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S160AntBacSub","QryAntSubmDtl","1|2","W","","30","2016-10-01","2016-10-25")
Query QryAntSubmDtl(aHospIDs As %String = "", aLocType As %String = "", aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DishLocID:%String,DishLocDesc:%String,DishWardID:%String,DishWardDesc:%String,GroupCode:%String,GroupDesc:%String,IsAntUse:%String,IsCureUse:%String,IsSubmiss:%String,IsCureSubm:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntSubmDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aLocType As %String = "", aLocGroup As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
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
							Set GroupDr 	= objGroup.%Id()
							Set GroupCode	= objGroup.BTCode
						}
						Continue:(aLocGroup'=GroupCode)
					}
					// 抗生素使用标记
					// 抗生素使用、送检信息
					Set AntUseInfo = ..GetAntUseInfo(xPaadm)
					Set IsAntUse  = $p(AntUseInfo,"^",1)
					Set IsCureUse = $p(AntUseInfo,"^",2)
					Set IsSubmiss = $p(AntUseInfo,"^",3)
					Set (IsCureSubm)=0
					If (IsCureUse=1)&&(IsSubmiss=1) {
						Set IsCureSubm =1
					}
					Set IsAntUse = $s(IsAntUse=1:"是",1:"")
					Set IsCureUse = $s(IsCureUse=1:"是",1:"")
					Set IsSubmiss = $s(IsSubmiss=1:"是",1:"")
					Set IsCureSubm = $s(IsCureSubm=1:"是",1:"")

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
						    
							Set Data = PatData_$lb(DishLocID,DishLocDesc,DishWardID,DishWardDesc,GroupCode,GroupDesc,IsAntUse,IsCureUse,IsSubmiss,IsCureSubm,TransWardDesc,TransDateTime,OutLocDateTime)
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

ClassMethod QryAntSubmDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntSubmDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntSubmDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntSubmDtlExecute ]
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
/// CreatDate：   2018-07-18
/// Description:  获取就诊期间使用抗菌药物（全身用药）与送检信息
/// Table：       DHCHAI.DP.OEOrdItem，DHCHAI.DP.LabVisitNumber
/// Input:        aEpisodeID：就诊ID
/// return:       
/// w ##class(DHCHAI.STAT.S160AntBacSub).GetAntUseInfo("379")
ClassMethod GetAntUseInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return =0
	Quit:aEpisodeID="" return
    Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
 	Set InstrucList=","_InstrucList_","
	
    Set (IsAntUse,IsCureUse,IsSubmiss)=0
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
	    Quit:IsCureUse=1
	    
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
		Set IsAntUse =1
		
		Set UsePurpose = objOrdItem.OEAntUsePurpose	// 用药目的
		Set:UsePurpose="" UsePurpose="其他"
		Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiMedPurpose",UsePurpose)
		Continue:UsePurposeMapStr=""
		Set UsePurpose = $p(UsePurposeMapStr,"^",3)		
		Set:UsePurpose="治疗" IsCureUse=1
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
			Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
			Continue:CollDate=""
			
			Set objSpecMap = ##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			If $IsObject(objSpecMap.BTMapItemDr)&&(objSpecMap.BTIsActive=1){
				if objSpecMap.BTMapItemDr.BTIsActive=1{
					Set Specimen = objSpecMap.BTMapItemDr.BTSpecDesc
				}
			}
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
		}
	}
	
	Set return = IsAntUse_"^"_IsCureUse_"^"_IsSubmiss
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-07-18
/// Description:  查询病人检验病原学送检
/// Table：       DHCHAI.DP.LabVisitNumber,DHCHAI.DP.LabVisitReport
/// Input：       aEpisodeID：就诊ID
/// Return：      返回ROWSPEC
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S160AntBacSub","QryLabVisitNumber","62")
Query QryLabVisitNumber(aEpisodeID As %String) As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeNo:%String,OrdTSDesc:%String,Specimen:%String,LocDesc:%String,CollDate:%String,VisitReportID:%String,AuthDate:%String,ResultList:%String") [ SqlProc ]
{
}

ClassMethod QryLabVisitNumberExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
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
		
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
		Set SCode	 	= objVisitNumber.LabSCode
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo
		Set Specimen 	= objVisitNumber.LabSpecimen
		Set LocDesc 	= ""
		If $isobject(objVisitNumber.LabLocDr){
			Set LocDesc=objVisitNumber.LabLocDr.BTDesc
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set LocDesc2=objVisitNumber.LabLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
		}
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

ClassMethod QryLabVisitNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
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

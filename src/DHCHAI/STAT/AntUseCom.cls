/// 名称: DHCHAI.STAT.AntUseCom
/// 描述: 抗菌药物使用公共方法
/// 编写者：pylian
/// 编写日期: 2018-07-17
Class DHCHAI.STAT.AntUseCom Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-07-17
/// Description:  查询科室列表
/// Table：       DHCHAI.BT.Location
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.AntUseCom","QryLocSrv","1")
Query QryLocSrv(aHospIDs As %String) As %Query(ROWSPEC = "LocID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,GroupCode:%String,GroupDesc:%String,LinkLocID:%String,LinkLocDesc:%String,LinkLocDesc2:%String") [ SqlProc ]
{
}

ClassMethod QryLocSrvExecute(ByRef qHandle As %Binary, aHospIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	 
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
	    Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
	    
		Set xLocID=0
		For {
			Set xLocID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xLocID))
			Quit:xLocID=""
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
			Continue:'$isobject(objLoc)
			Set IsActive	= objLoc.BTIsActive
			Continue:IsActive'=1
			
			Set (LocCode,LocDesc,LocDesc2,LocTypeCode,LocTypeDesc,LocCateCode,LocCateDesc,GroupCode,GroupDesc)=""		
			Set LocCode	    = objLoc.BTCode
			Set LocDesc	    = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc)
			Set LocDesc2	= ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc2)
			Continue:((LocDesc["停用")||(LocDesc2["停用"))		
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
		
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
				Set LocTypeDesc	= objLoc.BTTypeDr.BTDesc
			}
			Continue:(LocTypeCode'="E")
			
			Set LocCateDr="",LocCateCode="",LocCateDesc=""
			If $IsObject(objLoc.BTCateDr) {
				Set LocCateDr 	= objLoc.BTCateDr.%Id()
				Set LocCateCode	= objLoc.BTCateDr.BTCode
				Set LocCateDesc	= objLoc.BTCateDr.BTDesc
			}
			Continue:(LocCateCode'="I")&&(LocCateCode'="E")
			
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
			
			Set xSubID = ""
		 	For {
				Set xSubID = $o(^DHCHAI.BT.LocationD(xLocID,"Link",xSubID))
				Quit:xSubID=""
				
				Set xID = xLocID_"||"_xSubID
				Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xID)
				Continue:'$IsObject(objLocLink)
				Continue:'$IsObject(objLocLink.BTLinkLocDr)
				Continue:(+objLocLink.BTIsActive)'=1
				
				Set LinkLocID = objLocLink.BTLinkLocDr.%Id()
				Set LinkLocDesc = objLocLink.BTLinkLocDr.BTDesc
				Set LinkLocDesc2 = objLocLink.BTLinkLocDr.BTDesc2
				Set:LinkLocDesc2="" LinkLocDesc2 = LinkLocDesc
			    Set:$p(LinkLocDesc2,"-",2)'="" LinkLocDesc2=$p(LinkLocDesc2,"-",2)
					
				Set Data=$lb(xLocID,LocCode,LocDesc,LocDesc2,GroupCode,GroupDesc,LinkLocID,LinkLocDesc,LinkLocDesc2)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1

		 	}
		}
	}
	Quit $$$OK
}

ClassMethod QryLocSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocSrvExecute ]
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
/// CreatDate：   2018-07-17
/// Description:  查询就诊信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.AntUseCom","QryAdmInfo","327")
Query QryAdmInfo(aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DishLocID:%String,DishLocDesc:%String,DishWardID:%String,DishWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAdmInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEpisodeID="" $$$OK
 	
 	Set Data = ..BuildPaadmData(aEpisodeID)
 	Quit:Data="" $$$OK
 	
 	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmInfoExecute ]
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
	Set (DishLocID,DishLocDesc)=""
    Set objDishLoc = objPaadm.PADischLocDr
	If $IsObject(objDishLoc) {                   
	    Set DishLocID = objDishLoc.%Id()
		Set DishLocDesc = objDishLoc.BTDesc2
		Set:DishLocDesc="" DishLocDesc=objDishLoc.BTDesc
		Set:DishLocDesc["-" DishLocDesc=$p(DishLocDesc,"-",2)
	}
	Set (DishWardID,DishWardDesc)=""
	Set objDishWard = objPaadm.PADischWardDr
	If $IsObject(objDishWard) {
		Set DishWardID = objDishWard.%Id()
		Set DishWardDesc = objDishWard.BTDesc2
		Set:DishWardDesc="" DishWardDesc=objDishWard.BTDesc
		Set:DishWardDesc["-" DishWardDesc=$p(DishWardDesc,"-",2)
	}
					
	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DishLocID,DishLocDesc,DishWardID,DishWardDesc)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-07-26
/// Description:  查询转病区记录信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.AntUseCom","QryAdmTrans","327","2016-01-01","2018-01-01")
Query QryAdmTrans(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "TransID:%String,GroupCode:%String,GroupDesc:%String,TransWardID:%String,TransWardDesc:%String,TransDate:%String,TransTime:%String,OutLocDate:%String,OutLocTime:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DishLocID:%String,DishLocDesc:%String,DishWardID:%String,DishWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAdmTransExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEpisodeID="" $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set PatData=..BuildPaadmData(aEpisodeID)
	Quit:PatData="" $$$OK
 	Set (TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime)=""

	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",aEpisodeID,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xTransID=0
		For {
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",aEpisodeID,xDate,xTransID))
			Quit:xTransID=""
		
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
			Continue:'$IsObject(objTrans)
			Continue:'$IsObject(objTrans.PATransLocDr)
			
			Set TransWardID=objTrans.PATransLocDr.%Id()
			Set TransWardDesc=objTrans.PATransLocDr.BTDesc2
			Set:TransWardDesc="" TransWardDesc=objTrans.PATransLocDr.BTDesc
		    Set:TransWardDesc["-" TransWardDesc=$p(TransWardDesc,"-",2)
		    
		    Set GroupDr="",GroupCode="",GroupDesc=""
			If $IsObject(objTrans.PATransLocDr.BTGroupDr) {
				Set GroupDr 	= objTrans.PATransLocDr.BTGroupDr.%Id()
				Set GroupCode	= objTrans.PATransLocDr.BTGroupDr.BTCode
				Set GroupDesc	= objTrans.PATransLocDr.BTGroupDr.BTDesc	
			}Else {
				Set GroupDesc="其他科"
				Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
				If $IsObject(objGroup) {
					Set GroupDr 	= objGroup.%Id()
					Set GroupCode	= objGroup.BTCode
				}
			}			
			
			Set TransDate=objTrans.PATransDate
			Set OutLocDate=objTrans.PAOutLocDate
		
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)

            Set TransTime=objTrans.PATransTime
            Set:TransTime'="" TransTime=$zt(TransTime)
			Set OutLocTime=objTrans.PAOutLocTime
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	    	
	    	Set Data=$lb(xTransID,GroupCode,GroupDesc,TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime)_PatData
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	    

		}
	}
	Quit $$$OK
}

ClassMethod QryAdmTransClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmTransExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmTransFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmTransExecute ]
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
/// Description:  查询病人抗菌药物信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID： 就诊ID  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.AntUseCom","QryAntUseDtl","4","2016-01-01","2018-01-01")
Query QryAntUseDtl(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,TransID:%String,TransWardID:%String,TransWardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DishLocID:%String,DishLocDesc:%String,DishWardID:%String,DishWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseDtlExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEpisodeID="" $$$OK
 	Set:aDateTo="" aDateTo=+$h
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Quit:aDateFrom>aDateTo $$$OK
	
	Set PatData=..BuildPaadmData(aEpisodeID)
	Quit:PatData="" $$$OK
 	Set (TransWardID,TransWardDesc,TransDate,TransTime,OutLocDate,OutLocTime)=""
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",aEpisodeID,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xTransID=0
		For {
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",aEpisodeID,xDate,xTransID))
			Quit:xTransID=""
		
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
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
            Set TransDateTime=TransDate_" "_TransTime
            Set OutLocDateTime=OutLocDate_" "_OutLocTime
            
		    Set xScode = ""
			For {
				Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
				Quit:xScode=""
				
				Set xSttDate = ""
				For {
					Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
					Quit:xSttDate=""
					Continue:(objTrans.PAOutLocDate'="")&&(xSttDate>objTrans.PAOutLocDate)
					
					Set xOrdItemID =""
					For {
						Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
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
						Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药
		
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
				
	    				Set Data=$lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison,xTransID,TransWardID,TransWardDesc,TransDateTime,OutLocDateTime)_PatData
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
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

}

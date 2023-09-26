/// 名称: DHCHAI.DPS.OEOrdItemSrv
/// 描述: 医嘱相关服务
/// 编写者：liyi
/// 编写日期: 2017-09-25
Class DHCHAI.DPS.OEOrdItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-09-25
/// Description:  查询病人医嘱
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       aEpisodeID：就诊ID
/// 				  aDateFrom：开始日期
/// 				  aDateTo：结束日期
/// 				  aAntUseFlag : 抗生素标志
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.OEOrdItemSrv","QryOrdItemByEpisodeID","2","","","0")
Query QryOrdItemByEpisodeID(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aAntUseFlag As %String = "") As %Query(ROWSPEC = "OrdItemID:%String,EpisodeID:%String,OrdCode:%String,OrdDesc:%String,OrdTypeCode:%String,OrdType:%String,OrdCat:%String,OrdSubCat:%String,Priority:%String,OrdStatus:%String,OrdDate:%String,OrdTime:%String,OrdLocID:%String,OrdLoc:%String,DocCode:%String,DocName:%String,SttDate:%String,SttTime:%String,XDate:%String,XTime:%String,Generic:%String,InstrucID:%String,Instruc:%String,DoseQty:%String,DoseQtyUomID:%String,DoseQtyUom:%String,FreqDescID:%String,FreqDesc:%String,SCode:%String,XCode:%String,IsActive:%String,UpdateDate:%String,UpdateTime:%String,AntDrgPoison:%String,AntUsePurposeID:%String,AntUsePurpose:%String,AntOthPurpose:%String,AntIsSubmiss:%String,AntInfPos:%String,AntUseDate:%String,AntUseTime:%String,AntUseFlag:%String")
{
}

ClassMethod QryOrdItemByEpisodeIDExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aAntUseFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Quit:aEpisodeID="" $$$OK

	Set xSCode=""
	For {
		Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode))
		Quit:xSCode=""
		
		For xAntUseFlag = ""
		For {
			Set xAntUseFlag = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,xAntUseFlag))
			Quit:xAntUseFlag=""
			Continue:(aAntUseFlag'="")&&(aAntUseFlag'=xAntUseFlag)
			
			Set xSttDate = ""
			For {
				Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,xAntUseFlag,xSttDate))
				Quit:xSttDate=""
				Continue:(aDateFrom'="")&&(aDateFrom<xSttDate)
				Continue:(aDateTo'="")&&(aDateTo>xSttDate)
				
				Set xID = ""
				For {
					Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,xAntUseFlag,xSttDate,xID))
					Quit:xID=""
					
					Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
					Continue:'$IsObject(objOrdItem)
					Continue:objOrdItem.OEIsActive=0
					
					Set Data = ..BuildOrdItemData(xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1 
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryOrdItemByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrdItemByEpisodeIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrdItemByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrdItemByEpisodeIDExecute ]
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

ClassMethod BuildOrdItemData(aOrdItemID As %String) As %String
{
	New (aOrdItemID)
	Set return=""
	Quit:aOrdItemID="" return
	
	Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(aOrdItemID)
	Quit:'$IsObject(objOrdItem) return
	Quit:objOrdItem.OEIsActive'=1 return
	Set objEpisode = objOrdItem.OEEpisodeDr
	Quit:'$IsObject(objEpisode) return
	
	Set EpisodeID  = objEpisode.%Id()
	Set OrdCode = objOrdItem.OEOrdCode
	Set OrdDesc = objOrdItem.OEOrdDesc
	Set OrdType = objOrdItem.OEOrdType
	Set OrdTypeCode=OrdType
	Set OrdType = $s(OrdType="R":"药品",OrdType="L":"检验",OrdType="O":"其他",1:"")
	Set OrdCat = objOrdItem.OEOrdCat
	Set OrdSubCat = objOrdItem.OEOrdSubCat
	Set Priority = objOrdItem.OEPriority
	Set OrdStatus = objOrdItem.OEOrdStatus
	Set OrdDate = objOrdItem.OEOrdDate
	Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
	Set OrdTime = objOrdItem.OEOrdTime
	Set:OrdTime'="" OrdTime=$zt(OrdTime)
	Set objOrdLoc = objOrdItem.OEOrdLocDr
	Set (OrdLocID,OrdLoc)=""
	If $IsObject(objOrdLoc){
		Set OrdLocID = objOrdLoc.%Id()
		Set LocDesc2 = objOrdLoc.BTDesc2
		Set LocDesc = objOrdLoc.BTDesc
		Set OrdLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set Doctor  = objOrdItem.OEDoctor
	Set DocCode = $p(Doctor,"|",2)
	Set DocName = $p(Doctor,"|",3)
	Set SttDate = objOrdItem.OESttDate
	Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
	Set SttTime = objOrdItem.OESttTime
	Set:SttTime'="" SttTime=$zt(SttTime)
	Set XDate = objOrdItem.OEXDate
	Set:XDate'="" XDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(XDate)
	Set XTime = objOrdItem.OEXTime
	Set:XTime'="" XTime=$zt(XTime)
	Set Generic = objOrdItem.OEGeneric
	Set Instruc = objOrdItem.OEInstruc
	
	Set DoseQty = objOrdItem.OEDoseQty
	Set DoseQtyUom = objOrdItem.OEDoseQtyUom
	Set FreqDesc = objOrdItem.OEFreqDesc
	Set SCode = objOrdItem.OESCode
	Set XCode = objOrdItem.OEXCode
	Set IsActive = objOrdItem.OEIsActive
	Set UpdateDate = objOrdItem.OEUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = objOrdItem.OEUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set AntDrgPoison = objOrdItem.OEAntDrgPoison
	Set AntUsePurpose = objOrdItem.OEAntUsePurpose
	Set AntOthPurpose = objOrdItem.OEAntOthPurpose
	Set AntIsSubmiss = objOrdItem.OEAntIsSubmiss
	Set AntInfPos = objOrdItem.OEAntInfPos
	Set AntUseDate = objOrdItem.OEAntUseDate
	Set:AntUseDate'="" AntUseDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AntUseDate)
	Set AntUseTime = objOrdItem.OEAntUseTime
	Set:AntUseTime'="" AntUseTime=$zt(AntUseTime)
	Set AntUseFlag = objOrdItem.OEAntUseFlag
	// 给药途径   
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiAdminRoute",Instruc)
	Set InstrucID = "" 
	If (PhraseMap'="") {
		Set InstrucID  = $p(PhraseMap,"^",1)
		Set Instruc 	= $p(PhraseMap,"^",3)
	}
	// 剂量单位
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OEDoseUnit",DoseQtyUom)
	Set DoseQtyUomID = "" 
	If (PhraseMap'="") {
		Set DoseQtyUomID  = $p(PhraseMap,"^",1)
		Set DoseQtyUom 	= $p(PhraseMap,"^",3)
	}
	// 频次
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OEPhcFreq",FreqDesc)
	Set InstrucID = "" 
	If (PhraseMap'="") {
		Set FreqDescID  = $p(PhraseMap,"^",1)
		Set FreqDesc 	= $p(PhraseMap,"^",3)
	}
	// 使用目的
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiMedPurpose",AntUsePurpose)
	Set AntUsePurposeID = "" 
	If (PhraseMap'="") {
		Set AntUsePurposeID  = $p(PhraseMap,"^",1)
		Set AntUsePurpose 	= $p(PhraseMap,"^",3)
	}
	Set return = $lb(aOrdItemID,EpisodeID,OrdCode,OrdDesc,OrdTypeCode,OrdType,OrdCat,OrdSubCat,Priority,OrdStatus,OrdDate,OrdTime,OrdLocID,OrdLoc,DocCode,DocName,SttDate,SttTime,XDate,XTime,Generic,InstrucID,Instruc,DoseQty,DoseQtyUomID,DoseQtyUom,FreqDescID,FreqDesc,SCode,XCode,IsActive,UpdateDate,UpdateTime,AntDrgPoison,AntUsePurposeID,AntUsePurpose,AntOthPurpose,AntIsSubmiss,AntInfPos,AntUseDate,AntUseTime,AntUseFlag)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-04-18
/// Description:  获取患者隔离医嘱信息
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        EpisodeDr : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEOrdItemSrv","QryOEOrdItemISO",480)
Query QryOEOrdItemISO(aEpisodeDr As %String) As %Query(ROWSPEC = "OrdID:%String,OrdDesc:%String,Priority:%String,OrdDate:%String,OrdTime:%String,SttDate:%String,SttTime:%String,OrdLoc:%String,OrdDoc:%String,EndDate:%String,EndTime:%String") [ SqlProc ]
{
}

ClassMethod QryOEOrdItemISOExecute(ByRef qHandlex As %Binary, aEpisodeDr As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set qHandlex=$lb(0,repidx,0)
 	Set indx=1
	/// 就诊+更新日期索引
	/// Index IndexEpisodeOrdDescDate On (OEEpisodeDr, OESCode As Exact, OEOrdDesc As Exact, OEUpdateDate);
	//Set OESCode="HIS01",OEOrdDesc="多重耐药菌接触隔离"
	Set xxDate=""
	For {
		Set xxDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xxDate))
		Quit:xxDate=""
		Set xOEID=0
		For {
			Set xOEID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xxDate,xOEID))
			Quit:xOEID=""
		
			Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xOEID)
			Continue:'$IsObject(objOrdItem)
			Continue:objOrdItem.OEIsActive=0	// 无效医嘱
			Set SCode   = objOrdItem.OESCode
			Set OrdType = objOrdItem.OEOrdType
			Continue:OrdType="R" //过滤掉药品医嘱
			Set OrdDesc = objOrdItem.OEOrdDesc
			
			//类型过滤
			Set objItmMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(SCode,OrdDesc)
			Continue:'$IsObject(objItmMap)
			Continue:'$IsObject(objItmMap.BTMapItemDr)
			Continue:'$IsObject(objItmMap.BTMapItemDr.BTCatDr)
			Continue:'$IsObject(objItmMap.BTMapItemDr.BTCatDr.BTTypeDr)
			Set TypeCode=objItmMap.BTMapItemDr.BTCatDr.BTTypeDr.BTCode
			Continue:(TypeCode'="ISO") //隔离医嘱
			
			Set Priority= objOrdItem.OEPriority
			Set OrdDate = objOrdItem.OEOrdDate
			//Set:OrdDate'="" OrdDate=$zd(OrdDate,3)
			Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
			Set OrdTime = objOrdItem.OEOrdTime
			Set:OrdTime'="" OrdTime=$zt(OrdTime,2)
			Set SttDate = objOrdItem.OESttDate
			//Set:SttDate'="" SttDate=$zd(SttDate,3)
			Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
			Set SttTime = objOrdItem.OESttTime
			Set:SttTime'="" SttTime=$zt(SttTime,2)
			Set EndDate	= objOrdItem.OEXDate
			//Set:EndDate'="" EndDate=$zd(EndDate,3)
			Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
			Set EndTime	= objOrdItem.OEXTime
			Set:EndTime'="" EndTime=$zt(EndTime,2)
			If $IsObject(objOrdItem.OEOrdLocDr) {
				Set OrdLocDesc=objOrdItem.OEOrdLocDr.BTDesc
			} Else {
				Set OrdLocDesc=objOrdItem.OEOrdLoc  //ID|Code|Desc
				Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
			}
			Set OrdDocDesc=objOrdItem.OEDoctor  //ID|Code|Desc
			Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
			
			Set Data=$lb(xOEID,OrdDesc,Priority,OrdDate,OrdTime,SttDate,SttTime,OrdLocDesc,OrdDocDesc,EndDate,EndTime)
			Set ^CacheTemp(repidx,indx)=Data
			Set indx=indx+1
		}
	}
	Quit $$$OK
}

ClassMethod QryOEOrdItemISOClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryOEOrdItemISOExecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryOEOrdItemISOFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEOrdItemISOExecute ]
{
	set AtEnd=$LIST(qHandlex,1)
 	set repidx=$LIST(qHandlex,2)
 	set indx=$LIST(qHandlex,3)
 	set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else {				// fetch row
 		set Row=^CacheTemp(repidx,indx)
 	}
 	// Save QHandle
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2018-01-11
/// Description:  查询器械相关治疗医嘱列表
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        EpisodeDr : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEOrdItemSrv","QryOEOrdItemByDRT",5948)
Query QryOEOrdItemByDRT(aEpisodeDr As %String, aTypeCode As %String = "DRT") As %Query(ROWSPEC = "OrdID:%String,OrdDesc:%String,Priority:%String,OrdDate:%String,OrdTime:%String,SttDate:%String,SttTime:%String,OrdLoc:%String,OrdDoc:%String,EndDate:%String,EndTime:%String") [ SqlProc ]
{
}

ClassMethod QryOEOrdItemByDRTExecute(ByRef qHandle As %Binary, aEpisodeDr As %String, aTypeCode As %String = "DRT") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive=0	// 无效医嘱
		Set SCode   = objOrdItem.OESCode
		Set OrdType = objOrdItem.OEOrdType
		Continue:OrdType="R" //过滤掉药品医嘱
		Set OrdDesc = objOrdItem.OEOrdDesc
		
		//类型过滤
		Set objItmMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(SCode,OrdDesc)
		Continue:'$IsObject(objItmMap)
		Continue:'$IsObject(objItmMap.BTMapItemDr)
		Continue:'$IsObject(objItmMap.BTMapItemDr.BTCatDr)
		Continue:'$IsObject(objItmMap.BTMapItemDr.BTCatDr.BTTypeDr)
		Set TypeCode=objItmMap.BTMapItemDr.BTCatDr.BTTypeDr.BTCode
		If (aTypeCode="DRT"){
			Continue:(TypeCode'="DRT") //器械相关治疗
			}
		else{
			//addby zzl 20230210新增查询隔离医嘱，会诊医嘱
			Continue:(TypeCode'="DRT")&&(TypeCode'="ISO")&&(TypeCode'="COD") 
			}
		Set Priority= objOrdItem.OEPriority
		Set OrdDate = objOrdItem.OEOrdDate
		//Set:OrdDate'="" OrdDate=$zd(OrdDate,3)
		Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
		Set OrdTime = objOrdItem.OEOrdTime
		Set:OrdTime'="" OrdTime=$zt(OrdTime,2)
		Set SttDate = objOrdItem.OESttDate
		//Set:SttDate'="" SttDate=$zd(SttDate,3)
		Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set SttTime = objOrdItem.OESttTime
		Set:SttTime'="" SttTime=$zt(SttTime,2)
		Set EndDate	= objOrdItem.OEXDate
		//Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set EndTime	= objOrdItem.OEXTime
		Set:EndTime'="" EndTime=$zt(EndTime,2)
		If $IsObject(objOrdItem.OEOrdLocDr) {
			Set OrdLocDesc=objOrdItem.OEOrdLocDr.BTDesc
		} Else {
			Set OrdLocDesc=objOrdItem.OEOrdLoc  //ID|Code|Desc
			Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
		}
		Set OrdDocDesc=objOrdItem.OEDoctor  //ID|Code|Desc
		Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
		
		Set Data=$lb(xID,OrdDesc,Priority,OrdDate,OrdTime,SttDate,SttTime,OrdLocDesc,OrdDocDesc,EndDate,EndTime)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOEOrdItemByDRTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEOrdItemByDRTExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEOrdItemByDRTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEOrdItemByDRTExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2018-01-11
/// Description:  查询抗菌用药医嘱列表
/// Table：       DHCHAI.DP.OEOrdItem
/// Input:        EpisodeDr : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEOrdItemSrv","QryOEOrdItemByANT",165)
Query QryOEOrdItemByANT(aEpisodeDr As %String) As %Query(ROWSPEC = "OrdID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDate:%String,OrdTime:%String,SttDate:%String,SttTime:%String,OrdLoc:%String,OrdDoc:%String,EndDate:%String,EndTime:%String,AntUsePurpose:%String,OEFreqDesc:%String,OEInstruc:%String,OEDoseQty:%String,OEDoseQtyUom:%String,AntDrgPoison:%String") [ SqlProc ]
{
}

ClassMethod QryOEOrdItemByANTExecute(ByRef qHandle As %Binary, aEpisodeDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive=0	// 无效医嘱
		Set SCode   = objOrdItem.OESCode
		Set OrdType = objOrdItem.OEOrdType
		Continue:OrdType'="R" //过滤掉非药品医嘱
		Continue:objOrdItem.OEAntUseFlag'=1  //抗菌用药标志
		//多语言？
		Set OrdDesc = objOrdItem.OEOrdDesc
		Set Generic=objOrdItem.OEGeneric
		Set Priority= objOrdItem.OEPriority
		Set OrdDate = objOrdItem.OEOrdDate
		//Set:OrdDate'="" OrdDate=$zd(OrdDate,3)
		Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
		Set OrdTime = objOrdItem.OEOrdTime
		Set:OrdTime'="" OrdTime=$zt(OrdTime,2)
		Set SttDate = objOrdItem.OESttDate
		//Set:SttDate'="" SttDate=$zd(SttDate,3)
		Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set SttTime = objOrdItem.OESttTime
		Set:SttTime'="" SttTime=$zt(SttTime,2)
		Set EndDate	= objOrdItem.OEXDate
		//Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set EndTime	= objOrdItem.OEXTime
		Set:EndTime'="" EndTime=$zt(EndTime,2)
		If $IsObject(objOrdItem.OEOrdLocDr) {
			Set OrdLocDesc=objOrdItem.OEOrdLocDr.BTDesc
		} Else {
			Set OrdLocDesc=objOrdItem.OEOrdLoc  //ID|Code|Desc
			Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
		}
		Set OrdDocDesc=objOrdItem.OEDoctor  //ID|Code|Desc
		Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
		Set AntUsePurpose = objOrdItem.OEAntUsePurpose
		Set AntOthPurpose = objOrdItem.OEAntOthPurpose
		Set:AntUsePurpose="" AntUsePurpose=AntOthPurpose
		//ADD by chenjb 20190301
		Set (OEFreqDesc,OEInstruc,OEDoseQty,OEDoseQtyUom)=""
		Set OEFreqDesc=objOrdItem.OEFreqDesc
		Set OEInstruc=objOrdItem.OEInstruc
		Set OEDoseQty=objOrdItem.OEDoseQty
		Set OEDoseQtyUom=objOrdItem.OEDoseQtyUom
		Set AntDrgPoison=objOrdItem.OEAntDrgPoison  //等级
		Set:AntDrgPoison="KSS1" AntDrgPoison="非限制使用级"
		Set:AntDrgPoison="KSS2" AntDrgPoison="限制使用级"
		Set:AntDrgPoison="KSS3" AntDrgPoison="特殊使用级"
		//多语言
		//OrdDesc
		//Priority
		//OrdLocDesc
		Set OrdLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",OrdLocDesc,"User.CTLoc")
		//OrdDocDesc
		//Generic
		//AntUsePurpose
		//OEInstruc
		Set Data=$lb(xID,OrdDesc,Generic,Priority,OrdDate,OrdTime,SttDate,SttTime,OrdLocDesc,OrdDocDesc,EndDate,EndTime,AntUsePurpose)
		Set Data=Data_$lb(OEFreqDesc,OEInstruc,OEDoseQty,OEDoseQtyUom,AntDrgPoison)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOEOrdItemByANTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEOrdItemByANTExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEOrdItemByANTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEOrdItemByANTExecute ]
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
/// CreatDate：   2022-07-05
/// Description:  查询当前在院患者抗生素连续使用超过N天的患者
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       aDays：天数
///               aDate: 日期 
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.OEOrdItemSrv","QryAntOverDaysCnt","3")
Query QryAntOverDaysCnt(aDays As %String = "", aDate As %String = "") As %Query(ROWSPEC = "Count:%String") [ SqlProc ]
{
}

ClassMethod QryAntOverDaysCntExecute(ByRef qHandle As %Binary, aDays As %String = "", aDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDays="" aDays=3
	Set:aDate'="" aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set:aDate="" aDate=+$h
	Kill arrOrdItem
 
	Set xDays=-1,Count=0
	Set xAdmType=""
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&(xAdmType'="EP")
		
		Set xDate=0
		For {
			Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
			Quit:xDate=""
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xEpisodeID))
				Quit:xEpisodeID=""
					
				Set IsOver =0	
				Set xSCode=""
				For {
					Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xEpisodeID,xSCode))
					Quit:xSCode=""
					Quit:IsOver=1
					
					Set xSttDate = ""
					For {
						Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xEpisodeID,xSCode,1,xSttDate))
						Quit:xSttDate=""
						Quit:IsOver=1
						Continue:(xSttDate'="")&&(xSttDate>(aDate-aDays))   //开始使用日期范围
						
						Set xOrdItemID = ""
						For {
							Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xEpisodeID,xSCode,1,xSttDate,xOrdItemID))
							Quit:xOrdItemID=""
							
							Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
							Continue:$lg(OEOrdItemData,25)=0
				           
				            Set SttDate = $lg(OEOrdItemData,15)
				            Set SttTime = $lg(OEOrdItemData,16)
							Set EndDate = $lg(OEOrdItemData,17)
							Set EndTime	= $lg(OEOrdItemData,18)
							Set Priority = $lg(OEOrdItemData,8)	//医嘱类型		
							Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xSCode,"OEPriority",Priority)
							Continue:(PriorityMap'="S1")&&(PriorityMap'="S2")
							
							If (EndDate="") {    //当前正在使用
								Continue:(SttDate>(aDate-aDays))
							} Else {   //当前已停止使用
								Continue:(EndDate<aDate)  //起始计算日期之前停药不纳入计算
								Continue:((EndDate-SttDate)<aDays)
							}
							Set IsOver =1
							Quit		
						}
					}
				}
				Continue:IsOver'=1
				
				Set arrOrdItem(xEpisodeID)=""
			    Set Count =Count+1
			}
		}
	}
	
	Kill arrOrdItem
	Set ^CacheTemp(repid,ind)=$lb(Count)
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QryAntOverDaysCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntOverDaysCntExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntOverDaysCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntOverDaysCntExecute ]
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
/// CreatDate：   2022-07-05
/// Description:  查询当前在院患者抗生素连续使用超过N天的患者信息
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       aDays：天数
///               aDate: 日期 
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.OEOrdItemSrv","QryAntOverDaysInfo","3")
Query QryAntOverDaysInfo(aDays As %String = "", aDate As %String = "") As %Query(ROWSPEC = "MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,CurrBed:%String,OrdItemID:%String,EpisodeID:%String,OrdCode:%String,OrdDesc:%String,OrdTypeCode:%String,OrdType:%String,OrdCat:%String,OrdSubCat:%String,Priority:%String,OrdStatus:%String,OrdDate:%String,OrdTime:%String,OrdLocID:%String,OrdLoc:%String,DocCode:%String,DocName:%String,SttDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,Generic:%String,InstrucID:%String,Instruc:%String,DoseQty:%String,DoseQtyUomID:%String,DoseQtyUom:%String,FreqDescID:%String,FreqDesc:%String,SCode:%String,XCode:%String,IsActive:%String,UpdateDate:%String,UpdateTime:%String,AntDrgPoison:%String,AntUsePurposeID:%String,AntUsePurpose:%String,AntOthPurpose:%String,AntIsSubmiss:%String,AntInfPos:%String,AntUseDate:%String,AntUseTime:%String,AntUseFlag:%String")
{
}

ClassMethod QryAntOverDaysInfoExecute(ByRef qHandle As %Binary, aDays As %String = "", aDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDays="" aDays=3
	Set:aDate'="" aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set:aDate="" aDate=+$h

	Set xDays=-1
	Set xAdmType=""
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&(xAdmType'="EP")
		
		Set xDate=0
		For {
			Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
			Quit:xDate=""
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xEpisodeID))
				Quit:xEpisodeID=""
				
				Set AdmData = $g(^DHCHAI.DP.PAAdmD(xEpisodeID))
				Continue:AdmData=""
				Set PapmiNo = $lg(AdmData,4)     //登记号
				Set MrNo    = $lg(AdmData,5)     //病案号
				Set PatName = $lg(AdmData,6)     //姓名
				Set Sex     = $lg(AdmData,7)
				Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")     
				Set CurrBed="",AdmBedData=""      
				Set AdmBedDr=$lg(AdmData,25)
				If AdmBedDr'=""{
					Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
				}
				If AdmBedData'=""{
					Set CurrBed=$lg(AdmBedData,3)
					Set:CurrBed'["床" CurrBed=CurrBed_"床"
				}
				
				Set xSCode=""
				For {
					Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xEpisodeID,xSCode))
					Quit:xSCode=""
					
					Set xSttDate = ""
					For {
						Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xEpisodeID,xSCode,1,xSttDate))
						Quit:xSttDate=""
						Continue:(xSttDate'="")&&(xSttDate>(aDate-aDays))   //开始使用日期范围
						
						Set xOrdItemID = ""
						For {
							Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xEpisodeID,xSCode,1,xSttDate,xOrdItemID))
							Quit:xOrdItemID=""
							
							Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
							Continue:$lg(OEOrdItemData,25)=0
				           
				            Set SttDate = $lg(OEOrdItemData,15)
				            Set SttTime = $lg(OEOrdItemData,16)
							Set EndDate = $lg(OEOrdItemData,17)
							Set EndTime	= $lg(OEOrdItemData,18)
							Set Priority = $lg(OEOrdItemData,8)	//医嘱类型		
							Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xSCode,"OEPriority",Priority)
							Continue:(PriorityMap'="S1")&&(PriorityMap'="S2")
							
							If (EndDate="") {    //当前正在使用
								Continue:(SttDate>(aDate-aDays))
							} Else {   //当前已停止使用
								Continue:(EndDate<aDate)  //起始计算日期之前停药不纳入计算
								Continue:((EndDate-SttDate)<aDays)
							}
							
							Set Data = ..BuildOrdItemData(xOrdItemID)
							Continue:Data=""
							Set ^CacheTemp(repid,ind)=$lb(MrNo,PapmiNo,PatName,Sex,CurrBed)_Data
							Set ind=ind+1 	
						}
					}
				}
			}
		}
	}

	Quit $$$OK
}

ClassMethod QryAntOverDaysInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntOverDaysInfoExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntOverDaysInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntOverDaysInfoExecute ]
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

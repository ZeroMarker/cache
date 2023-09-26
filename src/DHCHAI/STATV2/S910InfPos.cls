/// 名称: DHCHAI.STATV2.S910InfPos
/// 描述: 住院患者社区感染部位分布统计表
/// 编写者：ShenC
/// 编写日期: 2020-09-04
Class DHCHAI.STATV2.S910InfPos Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2020-09-04
/// Description:  住院患者社区感染部位分布统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S910InfPos","QryInfPos","1","2020-02-01","2020-06-01","W","1")
Query QryInfPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatCnt:%String,InfPatCnt:%String,InfCaseCnt:%String,PosDesc:%String,InfDiagDesc:%String,InfDiagCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	Set StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
   	Set:StatType'="W" StatType="E"  //不是病区就是科室
   	
    Set NIndex="QryS910Inf"
	Kill ^TMP($zn,$j,NIndex)
	
    //同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		//获取感染信息
		Set InfPosDescs=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)) // 避免重复获取感染部位
		{
			Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)=""
			Set InfPosDescs =..GetInfPosInfo(Paadm,aDateFrom,aDateTo)
			if (InfPosDescs'="") {
				for InfNo=1:1:$L(InfPosDescs,"|") {
					Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
					continue:InfPosMsg=""
					Set DiagID	= $p(InfPosMsg,"^",1)
					Set InfDate	= $p(InfPosMsg,"^",3)
					Set PosDesc=$p(InfPosMsg,"^",6)			//感染诊断
					Set InfDiagDesc=$p(InfPosMsg,"^",2)		//感染部位
					Set InfType=$p(InfPosMsg,"^",7)			//感染类型
					Continue:InfType'="社区感染"			//只统计社区感染
					Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,DiagID)=PosDesc_"||"_InfDiagDesc
				}
			}
		}
		//计算感染人数及感染例次数
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			// 全院住院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			//如果该次就诊有感染信息，通过感染日期判断该次在科是否感染
			if ($o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,""))'="") {
				if '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
					//记录感染人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
					}
							
					Set xDiagID=""
					for {
						Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,xDiagID))
						Quit:xDiagID=""
								
						//记录感染例次数
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
						//记录感染信息
						Set InfPosDesc=$g(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,xDiagID))
						Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,InfPosDesc))
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",InfPosDesc) = ""
					}
				}
			}
		}
    }
    
	// 输出Data
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	= $lg(DimList,1)
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:xDimensKey=""
		Set PatCnt		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase"))    		//新发感染例次数
		Set xDiag=""
		For {
			Set xDiag=$o(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList",xDiag))
			Quit:xDiag=""
			Set InfDiagDesc =$p(xDiag,"||",1)
			Set InfDiagCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,xDiag)) //感染部位例数
			Set PosDesc     =$p(xDiag,"||",2)
			
			Set Data=$lb(xDimensKey,DimensDesc,PatCnt,InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}	 		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosExecute ]
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
/// CreatDate：   2020-09-04
/// Description:  住院患者社区感染患者明细
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensType ：W -病区 E -科室(统计单位)
/// 			  aPosDesc ：感染部位
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S910InfPos","QryInfPosDtl","2020-03-01","2020-03-31","0000-00-0000-A-1","W","")
Query QryInfPosDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "W", aPosDesc As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "W", aPosDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set aLocDr=""
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    Set NIndex="QryS010InfDtl"
	Kill ^TMP($zn,$j,NIndex)
  	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    //同期在科、在病区
    Set:aDimensType="" aDimensType=aLocType
    Set:aDimensType'="W" aDimensType="E"  //不是病区就是科室
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aDimensType,aLocDr,"I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		Set TransIDs   = $LIST(TransInfo,6)
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&(aLocType="E")&&(LocDr'=aLocDr)		
		Continue:(aLocType'="")&(aLocType="W")&&(WardDr'=aLocDr)	
		//患者转科基本信息
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
		For xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransLocDr	= $li(TranData,5)
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		   	
		   	Set TransLocData 	= $g(^DHCHAI.BT.LocationD(TransLocDr))
		   	Set TransLocDesc	= $li(TransLocData,3)
			Set TransHospDr		= $li(TransLocData,8)
			//院区过滤
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,TransHospDr)<1)
			Set TransGroupDr  = $li(TransLocData,7)
			If TransGroupDr="" {
				Set TransGroupDesc="其他科"
				Set TransGroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
				
			}
			Set TransGroupData=$g(^DHCHAI.BT.LocGroupD(TransGroupDr))
			Set TransGroupDesc=$li(TransGroupData,3)
			
			//按科室组、科室/病区过滤
			Continue:(aLocGroup'="")&(aLocGroup'=TransGroupDr)
			Continue:(aLocType'="")&(TransLocDr'=aLocDr)
		
		   	Set StartDate=TransDate
		   	Set EndDate=OutLocDate
		   	Set:StartDate<aDateFrom StartDate=aDateFrom
		  	Set:(EndDate="")||(EndDate>aDateTo) EndDate=aDateTo
		    //患者感染信息
			Set InfPoss =..GetInfPosInfo(Paadm,StartDate,EndDate)
			Continue:InfPoss=""
		
			Set (InfPosDescs,InfDates,InfEffects)=""
			For indxi=1:1:$l(InfPoss,"|") {
				Set tmpInfPos      	= $p(InfPoss,"|",indxi)
				Set tmpInfPosID    	= $p(tmpInfPos,"^",1)
				Set tmpInfPosDescs 	= $p(tmpInfPos,"^",2)
				Set InfDate		   	= $p(tmpInfPos,"^",3)
				Set InfEffect	    = $p(tmpInfPos,"^",5)
				Set InfType	    	= $p(tmpInfPos,"^",7)
				Continue:InfType'="社区感染"
				Continue:(InfDate<StartDate)||(InfDate>EndDate)
				Continue:(aPosDesc'="")&&(aPosDesc'=tmpInfPosDescs)
				Set InfDate  		= $zd(InfDate,3)
				Set InfData=$lb(tmpInfPosDescs,InfDate,InfEffect)
				
				Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
				Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	        	Set TransTime	= $li(TranData,8)
	        	Set:TransTime'="" TransTime=$zt(TransTime)
				Set OutLocTime	= $li(TranData,11)
		    	Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	    		Set TransDateTime =TransDate_" "_TransTime
				Set OutLocDateTime =OutLocDate_" "_OutLocTime
				Set TransData=$lb(TransID,TransLocDesc,TransDateTime,OutLocDateTime)
				Set Data=PatData_TransData_InfData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
		
    }
    		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosDtlExecute ]
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

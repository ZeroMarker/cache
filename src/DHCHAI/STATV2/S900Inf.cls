/// 名称: DHCHAI.STATV2.S900Inf
/// 描述: 住院患（例次）者社区感染发病率统计表
/// 编写者：ShenC
/// 编写日期: 2020-07-30
Class DHCHAI.STATV2.S900Inf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2020-07-30
/// Description:  住院患者社区感染（例次）发病率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aQryCon：  有效数据筛查
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S900Inf","QryS900Inf","1","2020-02-01","2020-03-01","E","2")
Query QryS900Inf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,InfPatCnt:%String,InfPatRatio:%String,InfCaseCnt:%String,InfCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryS900InfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1") As %Status
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
	
	Set StatDimensStr=..GetStatDimensStr(aLocType)	//AHGE,AHGW
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
   	Set:StatType'="W" StatType="E"  //不是病区就是科室
   	
    Set NIndex="QryS900Inf"
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
			Set InfPosDescs =..GetInfPosInfo(Paadm,aDateFrom,aDateTo)
			if (InfPosDescs'="") {
				for InfNo=1:1:$L(InfPosDescs,"|") {
					Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
					continue:InfPosMsg=""
					Set DiagID	= $p(InfPosMsg,"^",1)
					Set InfDate	= $p(InfPosMsg,"^",3)
					Set InfType	= $p(InfPosMsg,"^",7)
					Continue:InfType'="社区感染"
					Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,DiagID)=""
				}
			}
		}
		//计算社区感染人数及感染例次数
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
			//记录感染人数和例次数
			if ($o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,""))'=""){
				Set xDiagID=""
				for {
					Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,xDiagID))
					Quit:xDiagID=""
						
					//记录感染人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfFlg",Paadm)) {
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfFlg"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfFlg",Paadm)=""
					}		
					//记录感染例次数	
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCaseFlg"))
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
		Continue:(aHospIDs'["|")&(xDimensKey["A")	//单院区不显示全院
		
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfFlg"))  			//社区感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCaseFlg"))    		//社区感染例次数
		Set InfPatRatio="0.00%",InfCaseRatio="0.00%"
		Set:PatAdmCnt>0 InfPatRatio=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%" 	//感染率
		Set:PatAdmCnt>0 InfCaseRatio=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%" 	//感染例次率
		//Continue:(IsActive="0")&&(PatAdmCnt=0)&&(InfPatCnt=0)&&(InfCaseCnt=0)
		Continue:((IsActive'=1)||(DimensDesc["停用")||(DimensDesc["作废"))&&(PatAdmCnt=0)&&(InfPatCnt=0)&&(InfCaseCnt=0)
		Continue:(aQryCon="2")&&(InfPatCnt=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InfPatCnt,InfPatRatio,InfCaseCnt,InfCaseRatio)
		Set ^CacheTemp( repid,ind)=Data
		Set ind=ind+1
	}	 		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS900InfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS010InfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS900InfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS010InfExecute ]
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
/// CreatDate：   2020-07-30
/// Description:  住院患者社区感染（例次）发病率明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey：统计维度
/// 			  aDimensType：统计类型(W,E)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S900Inf","QryS900InfDtl","2010-03-01","2020-04-01","0000-00-0000-A-1")
Query QryS900InfDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfPosDescs:%String,InfDates:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryS900InfDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String) As %Status
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
    Set NIndex="QryS900InfDtl"
	Kill ^TMP($zn,$j,NIndex)
  	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    //同期在科、在病区
    Set StaType=aDimensType
    Set:StaType'="W" StaType="E"  //不是病区就是科室
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StaType,aLocDr,"I")
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
		Set LocDesc	= $li(LocData,3)
		Set HospDr	= $li(LocData,8)
		//院区过滤
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			
		}
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&(aLocType="E")&&(LocDr'=aLocDr)		
		Continue:(aLocType'="")&(aLocType="W")&&(WardDr'=aLocDr)	
		//患者转科基本信息
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    
	    for xTransInd=1:1:$l(TransIDs,",") {
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
		
		   	Set StartDate=TransDate+1	//转科第一天感染算转科前科室感染
		   	Set EndDate=OutLocDate
		   	Set:StartDate<aDateFrom StartDate=aDateFrom
		  	Set:(EndDate="")||(EndDate>aDateTo) EndDate=aDateTo
		    //患者感染信息
			Set InfPoss =..GetInfPosInfo(Paadm,aDateFrom,aDateTo)
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
				Set TransData=$lb(TransID,LocDesc,TransDateTime,OutLocDateTime)
				Set Data=PatData_TransData_InfData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS900InfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS010InfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS900InfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS010InfDtlExecute ]
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
/// Input:        
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey：统计维度
/// 			  aDimensType：统计类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S010Inf","QryS010InfPatDtl","2019-02-01","2020-02-23","0000-00-0000-A-1","W")
Query QryS010InfPatDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "W") As %Query(ROWSPEC = "PatEpisode:%String,PapmiNo:%String,MrNO:%String,PatName:%String,PatAdmDesc:%String,PatAdmDate:%String,PatDishDesc:%String,PatDishDate:%String,TransID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryS010InfPatDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set Count=0
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//根据DimensMark取默认科室类型
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set aLocDr=""
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryS010InfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	//同期在科、在病区
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
		Set LocDesc	= $li(LocData,3)
		Set HospDr	= $li(LocData,8)
		//院区过滤
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			
		}
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&(aLocType="E")&&(LocDr'=aLocDr)
		Continue:(aLocType'="")&(aLocType="W")&&(WardDr'=aLocDr)
		//患者基本信息
	    Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    
	    Set PatEpisode=$li(PatData,1)
		Set PatMino=$li(PatData,2)
		Set PatMrmo=$li(PatData,3)
		Set PatName=$li(PatData,4)
		Set:aDimensType="E" PatAdmDesc=$li(PatData,10)
		Set:aDimensType="W" PatAdmDesc=$li(PatData,11)
		Set PatAdmDate=$li(PatData,9)
		Set:aDimensType="E" PatDishDesc=$li(PatData,15)
		Set:aDimensType="W" PatDishDesc=$li(PatData,16)
		Set PatDishDate=$li(PatData,14)
		Set PatData=$lb(PatEpisode,PatMino,PatMrmo,PatName,PatAdmDesc,PatAdmDate,PatDishDesc,PatDishDate)
		
	    for xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)				
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime 	= $li(TranData,8)
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime 	= $li(TranData,11)
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime	  
			Set Data=PatData_$lb(TransID,LocDesc,TransDateTime,OutLocDateTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	    }
	}	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS010InfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS010InfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS010InfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS010InfPatDtlExecute ]
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

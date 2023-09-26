/// 名称: DHCHAI.STATV2.S340BwGrpInf
/// 描述: 出生体重分组新生儿千日医院感染例次发病率统计表
/// 编写者：蒋朋朋
/// 编写日期: 2019-11-26
Class DHCHAI.STATV2.S340BwGrpInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-26
/// Description:  新生儿患者医院感染例次发病率统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S340BwGrpInf","QrySDayInf","2022-12-01","2022-12-08")
Query QrySDayInf(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "") As %Query(ROWSPEC = "WtCat:%String,WtCatDesc:%String,InCount:%Integer,InDays:%Integer,HAICount:%Integer,HAIRatio:%String,INFCount:%Integer,INFRatio:%String") [ SqlProc ]
{
}

ClassMethod QrySDayInfExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set NIndex="QrySDayInf"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ArrTransEpis=..GetLocEpisByDate(aDateFrom,aDateTo,"W","","I")
	
	//在院人数、感染人数、感染例次数
	Set (InCount,HAICount,INFCount)=0
	//千日感染率、千日感染例次率
	Set (HAIRatio,INFRatio)="0.00‰"
	Set xEpis=""
	For {
		Set xEpisData=ArrTransEpis.GetNext(.xEpis)
		Quit:xEpis=""
		
		Set EpisodeID	= $ListGet(xEpisData,1)
		Set LocID      	= $ListGet(xEpisData,2)
		Set TransDates  = $ListGet(xEpisData,4)
		Set TransIDs    = $ListGet(xEpisData,6)
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeID))
		Continue:PAAdmData=""
		Set InDays=0
		For xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    //Quit:InfFlg=1    //同一次就诊同一个科室感染过即为使用
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		    Set TransTime	= $li(TranData,8)
			Set OutLocTime	= $li(TranData,11)
			// 如果转科起止日期大于统计日期，以统计日期计算
			Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
			Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
			Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
			Set:DateTo>(+$h) DateTo=+$h
			Set DayCount = DateTo-DateFrom
			Set InDays   = InDays+DayCount
		}
		Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
		Continue:LocData=""
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		
		Set IsNewBaby=$lg(PAAdmData,32)
		//Continue:'IsNewBaby //update 20220217 按入院科室取新生儿时，新生儿标记随所在科室变化，根据20220216讨论结果，新生儿统计按NICU科室标记统计（与NICU日志保持一致），不按新生儿标记过滤
		Set IsNICU=$li(LocData,11)
		Continue:IsNICU'=1
		
		Set Weigth=+$lg(PAAdmData,34)
		Set WtCat=$s(((Weigth>0)&&(Weigth<=1000)):1,(Weigth>1000)&&(Weigth<=1500):2,(Weigth>1500)&&(Weigth<=2500):3, (Weigth>2500):4,1:5)
		
		If ('$d(^TMP($zn,$j,NIndex,WtCat,"InCount",EpisodeID))) {
			Set num=$i(^TMP($zn,$j,NIndex,WtCat,"InCount"))
			Set ^TMP($zn,$j,NIndex,WtCat,"InCount",EpisodeID)=""			
			//同期在科天数
			Set:InDays>0 ^TMP($zn,$j,NIndex,WtCat,"InDays") = +$g(^TMP($zn,$j,NIndex,WtCat,"InDays"))+InDays 
					 
		}Else{
			//同期在科天数
			Set:InDays>0 ^TMP($zn,$j,NIndex,WtCat,"InDays") = +$g(^TMP($zn,$j,NIndex,WtCat,"InDays"))+InDays
		}
		
		If ('$d(^TMP($zn,$j,NIndex,WtCat,"HAIPos",EpisodeID))) {
			Set ^TMP($zn,$j,NIndex,WtCat,"HAIPos",EpisodeID)=""
			Set InfPosInfo=..GetInfPosInfo(EpisodeID,aDateFrom,aDateTo,1)
			If (InfPosInfo'="") {
				For PosInd=1:1:$l(InfPosInfo,"|"){
					Set PosInfo=$p(InfPosInfo,"|",PosInd)
					Continue:PosInfo=""
					Set DiagDr    = $p(PosInfo,"^",1)
					Set DiagDesc  = $p(PosInfo,"^",2)
                    Set InfDate   = $p(PosInfo,"^",3)
                    
					Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,InfDate,"00:00:01")
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Set InLocData = $g(^DHCHAI.BT.LocationD(InfLocDr))
					Continue:InLocData=""
					Set tIsNICU=$li(InLocData,11)
					Continue:tIsNICU'=1
					Set:PosInd=1 num=$i(^TMP($zn,$j,NIndex,WtCat,"HAICount"))
					Set num=$i(^TMP($zn,$j,NIndex,WtCat,"INFCount"))
				}
			}
		}
	}
	Set WtCatList=$Lb("BW≤1000g","BW 1001g~1500g","BW 1501g~2500g","BW>2500g","BW未填写")
	For xCatInd=1:1:5 {
		Set WtCatDesc=$Lg(WtCatList,xCatInd)
		Set HAIRatio="0.00‰"
		Set INFRatio="0.00‰"
		Set InCount=+$g(^TMP($zn,$j,NIndex,xCatInd,"InCount"))  //在科人数
		Set InDays = +$g(^TMP($zn,$j,NIndex,xCatInd,"InDays"))
		Set HAICount=+$g(^TMP($zn,$j,NIndex,xCatInd,"HAICount"))
		Set INFCount=+$g(^TMP($zn,$j,NIndex,xCatInd,"INFCount"))
		
		Set:InDays>0 HAIRatio=$fn((HAICount/InDays)*1000,"",2)_"‰"
		Set:InDays>0 INFRatio=$fn((INFCount/InDays)*1000,"",2)_"‰"
		
		Set Data=$lb(xCatInd,WtCatDesc,InCount,InDays,HAICount,HAIRatio,INFCount,INFRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	
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

/// Creator：     ShenC
/// CreatDate：   2021-09-23
/// Description:  新生儿患者医院感染例次发病率统计明细表
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S340BwGrpInf","QrySDayInfDtl","2020-03-02","2023-03-31","1","4")
Query QrySDayInfDtl(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aWtCat As %String, aIsInf As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagID:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,InfRepDate:%String,InfRepUser:%String,InDays:%String") [ SqlProc ]
{
}

ClassMethod QrySDayInfDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aWtCat As %String, aIsInf As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//日期[入参]处理
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	//院区[入参]处理
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//体重分组[入参]处理
	Quit:aWtCat="" $$$OK
	//定义临时Global
	Set NIndex="QrySDayInf"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ArrTransEpis=..GetLocEpisByDate(aDateFrom,aDateTo,"W","","I")
	Set xEpis=""
	For {
		Set xEpisData=ArrTransEpis.GetNext(.xEpis)
		Quit:xEpis=""
		
		Set EpisodeID	= $ListGet(xEpisData,1)
		Set LocID      	= $ListGet(xEpisData,2)
		Set TransDates  = $ListGet(xEpisData,4)
		Set TransIDs    = $ListGet(xEpisData,6)
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeID))
		Continue:PAAdmData=""
		
		Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
		Continue:LocData=""
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)		//过滤院区
		
		Set IsNewBaby=$lg(PAAdmData,32)
		//Continue:'IsNewBaby //update 20220217 按入院科室取新生儿时，新生儿标记随所在科室变化，根据20220216讨论结果，新生儿统计按NICU科室标记统计（与NICU日志保持一致），不按新生儿标记过滤
		Set IsNICU=$li(LocData,11)
		Continue:IsNICU'=1
		
		Set Weigth=+$lg(PAAdmData,34)
		Set WtCat=$s(((Weigth>0)&&(Weigth<=1000)):1,(Weigth>1000)&&(Weigth<=1500):2,(Weigth>1500)&&(Weigth<=2500):3, (Weigth>2500):4,1:5)
		Continue:(aWtCat'="")&(WtCat'=aWtCat)						//过滤体重分组
		
		//患者基本信息
		Set PatData =..BuildPaadmData(EpisodeID)
		Continue:PatData=""
		
		//患者转科信息
		For xTransInd=1:1:$l(TransIDs,",") {
			Set TransID=$p(TransIDs,",",xTransInd)
			Continue:TransID=""
			Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
			Set TransLocDr	= $li(TranData,5)
			Set TransLocData 	= $g(^DHCHAI.BT.LocationD(TransLocDr))
			Set TransLocDesc	= $li(TransLocData,3)
			Set TransDate	= $li(TranData,7)
			Set OutLocDate	= $li(TranData,10)
			Set TransTime	= $li(TranData,8)
			Set OutLocTime	= $li(TranData,11)
			Set DateFrom=TransDate,DateTo=OutLocDate
			Set:OutLocDate="" DateTo = aDateTo
			// 住院天数
            Set InDays=..GetInDays(EpisodeID,DateFrom,DateTo,TransID)
            
            
			Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
			Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
			Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
			
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		 	
		    Set:TransTime'="" TransTime=$zt(TransTime)
			Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		   	Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
			
			If (aIsInf="") {
				Set TransData=$lb(TransID,TransLocDesc,TransDateTime,OutLocDateTime)
				Set Data=PatData_TransData_$lb("","","","","","","","",InDays)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1

			}Else {
				Set InfPosInfo=..GetInfPosInfo(EpisodeID,DateFrom,DateTo,1,"",TransLocDr)
				Continue:(InfPosInfo="")   //过滤感染(非感染)
				Set InfCount=$Length(InfPosInfo,"|")
				For indI=1:1:InfCount{
					Set InfPos=$p(InfPosInfo,"|",indI)
					Continue:InfPos=""
					Set DiagID    = $p(InfPos,"^",1)
					Set DiagDesc  = $p(InfPos,"^",2)
                    Set InfDate   = $p(InfPos,"^",3)
                    Set InfXDate  = $p(InfPos,"^",4)
                    Set InfEffect = $p(InfPos,"^",5)
                    Set InfType   = $p(InfPos,"^",7)
					Set InfRepDate= $p(InfPos,"^",9)
					Set InfRepUser= $p(InfPos,"^",11)  
					Continue:DiagID=""
					Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
		            Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
		                    
					Set TransData=$lb(TransID,TransLocDesc,TransDateTime,OutLocDateTime)
					Set Data=PatData_TransData_$lb(DiagID,DiagDesc,InfDate,InfXDate,InfEffect,InfType,InfRepDate,InfRepUser,InDays)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
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

}

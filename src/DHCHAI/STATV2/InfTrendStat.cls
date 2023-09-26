/// 名称: DHCHAI.STATV2.InfTrendStat
/// 描述: 住院患者趋势表统计
/// 编写者: luotiantian
/// 编写日期: 2020-11-05
Class DHCHAI.STATV2.InfTrendStat Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		luotiantian
/// CreateDate：	2020-11-05
/// Description:	住院患者趋势表统计
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期
///               	aLocID     : 科室/病区ID
/// 				aStatUnit：日期单位，1:月, 2:季度, 3:年
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.InfTrendStat","QryInfTrend","","2022-08","2022-12","1","")
Query QryInfTrend(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStatUnit As %String, aLocID As %Text) As %Query(ROWSPEC = "StatName:%String,PatAdmCnt:%Integer,InfPatCnt:%Integer,InfPatRatio:%String,InfCaseCnt:%Integer,InfCaseRatio:%String,InfPatRatio1:%String,InfCaseRatio1:%String") [ SqlProc ]
{
}

ClassMethod QryInfTrendExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStatUnit As %String, aLocID As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	If (aStatUnit=1) {
		Set aDateFrom = aDateFrom_"-01"
		Set aDateTo   = aDateTo_"-01"
		Set aDateTo   = $zdh(aDateTo,3)
		Set aDateTo   = aDateTo+32
		Set aDateTo   = $zd(aDateTo,3)
		Set aDateTo   = $p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
		Set aDateTo   = $zdh(aDateTo,3)-1
		Set aDateTo   = $zd(aDateTo,3)
	}elseIf(aStatUnit=2){
		Set StatMonth = $p(aDateFrom,"-",2)	
		Set aDateFrom = $s((+StatMonth)<4:+aDateFrom_"-01-01",(+StatMonth)<7:+aDateFrom_"-04-01",(+StatMonth)<10:+aDateFrom_"-07-01",1:+aDateFrom_"-10-01")
		Set StatMonth = $p(aDateTo,"-",2)	
		Set aDateTo = $s((+StatMonth)<4:+aDateTo_"-03-31",(+StatMonth)<7:+aDateTo_"-06-30",(+StatMonth)<10:+aDateTo_"-09-30",1:+aDateTo_"-12-31")
	}elseIf(aStatUnit=3){
		Set aDateFrom=aDateFrom_"-01-01"
		Set aDateTo=aDateTo_"-12-31"
	}
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set aLocIDs=aLocID
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//取统计科室类型
	Set aLocType ="W"
	if (aLocID'=""){
	   Set ConTypeDr = $g(^DHCHAI.BT.LocationD(+aLocID))
	   Set BTTypeDr = $lg(ConTypeDr,5)
	   Set aLocType = $lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
	}
    Set NIndex="QryInfTrend"
	Kill ^TMP($zn,$j,NIndex)
	//同期在科
    Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set HospDr=$li(LocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
			
			Set GroupDr  = $li(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}
		    //同期在科:某段时间的在科人数
		    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
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

					// 查询医院感染的感染信息
					Set InfPosDesc =..GetInfPosInfo(Paadm,DateFrom,DateTo,1,LocDr,WardDr)	
					//感染信息输出
					For PosInd=1:1:$l(InfPosDesc,"|"){
						Set InfPosInfo=$p(InfPosDesc,"|",PosInd)
						Continue:InfPosInfo=""
						Set DiagDr    = $p(InfPosInfo,"^",1)
						Set DiagDesc  = $p(InfPosInfo,"^",2)
	                    Set InfDate   = $p(InfPosInfo,"^",3)
	                    
	                    Set StatNames=..GetStatUnit(InfDate,aStatUnit)
						Set StatName = $lg(StatNames,2)
	                    if '$d(^TMP($zn,$j,NIndex,"ssss",StatName,"InfPat",Paadm)) {
							//记录感染人数
							Set num=$i(^TMP($zn,$j,NIndex,"ssss",StatName,"InfPat"))
							Set ^TMP($zn,$j,NIndex,"ssss",StatName,"InfPat",Paadm)=""
						}
						Continue:$d(^TMP($zn,$j,NIndex,StatName,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,StatName,Paadm,"DiagDr",DiagDr)=""
	                    //记录感染例次数
						Set num=$i(^TMP($zn,$j,NIndex,"ssss",StatName,"InfCase"))
					}
					
					Set TransDates=""
					For xDate=DateFrom:1:DateTo{
						Set TransDates=TransDates_","_xDate
					}
					Set StatNames=..GetStatUnit(TransDates,aStatUnit)
					For xLen=1:1:$LL(StatNames){
						Set xStatName=$lg(StatNames,xLen)
						Continue:xStatName=""
						
						// 全院住院患者人数
						If '$d(^TMP($zn,$j,NIndex,"ssss",xStatName,"PatAdm",Paadm))
						{	Set num=$i(^TMP($zn,$j,NIndex,"ssss",xStatName,"PatAdm")) 
							Set ^TMP($zn,$j,NIndex,"ssss",xStatName,"PatAdm",Paadm)=""
						}
					}
				}
		    }
		}
	}
	// 输出Data
	// 输出
	Set xName=""
	For {
		Set xName=$o(^TMP($zn,$j,NIndex,"ssss",xName))
		Quit:xName=""
		Set StatName = xName
		
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,"ssss",StatName,"PatAdm"))  			//在院患者数
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,"ssss",StatName,"InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,"ssss",StatName,"InfCase"))    		//新发感染例次数
		Set InfPatRatio="0.00%",InfCaseRatio="0.00%"
		Set:PatAdmCnt>0 InfPatRatio=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%" 	//感染率
		Set:PatAdmCnt>0 InfCaseRatio=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%" 	//感染例次率
		
		Set InfPatRatio1="0.00",InfCaseRatio1="0.00"
		Set:PatAdmCnt>0 InfPatRatio1=$fn((InfPatCnt/PatAdmCnt)*100,"",2)      	//感染率
		Set:PatAdmCnt>0 InfCaseRatio1=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)  	//感染例次率
		
		Set Data=$lb(StatName,PatAdmCnt,InfPatCnt,InfPatRatio,InfCaseCnt,InfCaseRatio,InfPatRatio1,InfCaseRatio1)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	 		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfTrendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfTrendExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfTrendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfTrendExecute ]
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

/// Creator：		zhoubo
/// CreateDate：	2021-05-18
/// Description:	住院感染患者明细
/// Input:        	aHospIDs： 多个医院用"|"连接
///               	aLocID     : 科室/病区ID
/// 				aStatUnit ：日期单位，1:月, 2:季度, 3:年
///                 aDimensType :2012年
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.InfTrendStat","QryInfTrendInfPatDtl","","2","","2022年4季度")
Query QryInfTrendInfPatDtl(aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryInfTrendInfPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (aStatUnit=1) {
		//2021年04月
		Set DateYM=+aDimensType_"-"_$e(aDimensType,6,7)
		Set DateInfo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(DateYM)
		Set aDateFrom = $p(DateInfo,"^",1)
		Set aDateTo   = $p(DateInfo,"^",2)
		
	}ElseIf(aStatUnit=2){
		//2021年2季度
		Set JDIndex=$e(aDimensType,6)
		If (JDIndex=1){
			Set aDateFrom =+aDimensType_"-01-01"
			Set aDateTo   =+aDimensType_"-03-31"
		}ElseIf (JDIndex=2){
			Set aDateFrom =+aDimensType_"-04-01"
			Set aDateTo   =+aDimensType_"-06-30"
		}
		ElseIf (JDIndex=3){
			Set aDateFrom =+aDimensType_"-07-01"
			Set aDateTo   =+aDimensType_"-09-30"
		}
		Else{
			Set aDateFrom =+aDimensType_"-10-01"
			Set aDateTo   =+aDimensType_"-12-31"
		}
	}ElseIf(aStatUnit=3){
		Set aDateFrom=+aDimensType_"-01-01"
		Set aDateTo=+aDimensType_"-12-31"
	}
	Quit:(aDateFrom="")||(aDateTo="") $$$OK

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set aLocIDs=aLocID
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//取统计科室类型
	Set aLocType ="W"
	if (aLocID'=""){
	   Set ConTypeDr = $g(^DHCHAI.BT.LocationD(+aLocID))
	   Set BTTypeDr = $lg(ConTypeDr,5)
	   Set aLocType = $lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
	}
	Set DimensMark=aLocType
    Set NIndex="QryInfTrendInfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	//同期在科
    Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
				
			Set HospDr=$lg(LocData,8)
			//医院分组过滤
			Continue:HospDr=""
			Set HospInfo="",HospGroupDr="",HospGrpInfo=""
			Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
			Set HospGroupDr=$lg(HospInfo,5)
			Continue:HospGroupDr=""
			Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
			//院区过滤
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
			
			Set GroupDr  = $lg(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}	
			Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
			Set GroupDesc=$lg(GroupData,3)
			//按科室组、科室/病区过滤

            //取统计维度
			Set DimensDesc =""
			Set:DimensMark="" DimensDesc="全部"
			Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
			Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
			Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
			Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
			
		    //同期在科、在病区
		    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
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
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2	
				//患者转科基本信息
				Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
	            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	            Set AdmTimes = $lg(AdmData,38)   //就诊次数
			    
			    For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
				    Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)
					//如果转科起止日期大于统计日期，以统计日期计算
					Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
					Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
					Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
					//获取感染信息
					Set InfPosDescs =..GetInfPosInfo(Paadm,DateFrom,DateTo,1,LocDr,WardDr)	
					Continue:InfPosDescs=""
					
					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
					
					
					//感染信息输出
					For PosInd=1:1:$l(InfPosDescs,"|"){
						Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
						Continue:InfPosInfo=""
						Set DiagDr    = $p(InfPosInfo,"^",1)
						Set DiagDesc  = $p(InfPosInfo,"^",2)
	                    Set InfDate   = $p(InfPosInfo,"^",3)
	                    Set InfXDate  = $p(InfPosInfo,"^",4)
	                    Set InfEffect = $p(InfPosInfo,"^",5)
	                    Set InfType   = $p(InfPosInfo,"^",7)
	                    Set DimeType=##class(DHCHAI.STATV2.InfTrendStat).GetStatUnit(InfDate,aStatUnit)
						Continue:(aDimensType'="")&&($lf(DimeType,aDimensType)<1)
						
	                    Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
	                    Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
	                    Continue:$d(^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)=""
						Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
		    }
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfTrendInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfTrendInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfTrendInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfTrendInfPatDtlExecute ]
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

/// Creator：		zhoubo
/// CreateDate：	2021-05-18
/// Description:	住院患者明细
/// Input:        	aHospIDs： 多个医院用"|"连接
///               	aLocID     : 科室/病区ID
/// 				aStatUnit：日期单位，1:月, 2:季度, 3:年
///                 aDimensType :2012年
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.InfTrendStat","QryInfTrendPatDtl","","2","","2020年2季度")
Query QryInfTrendPatDtl(aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InfFlag:%String") [ SqlProc ]
{
}

ClassMethod QryInfTrendPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aStatUnit As %String, aLocID As %Text, aDimensType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (aStatUnit=1) {
		//2021年04月
		Set DateYM=+aDimensType_"-"_$e(aDimensType,6,7)
		Set DateInfo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(DateYM)
		Set aDateFrom = $p(DateInfo,"^",1)
		Set aDateTo   = $p(DateInfo,"^",2)
		
	}ElseIf(aStatUnit=2){
		//2021年2季度
		Set JDIndex=$e(aDimensType,6)
		If (JDIndex=1){
			Set aDateFrom =+aDimensType_"-01-01"
			Set aDateTo   =+aDimensType_"-03-31"
		}ElseIf (JDIndex=2){
			Set aDateFrom =+aDimensType_"-04-01"
			Set aDateTo   =+aDimensType_"-06-30"
		}
		ElseIf (JDIndex=3){
			Set aDateFrom =+aDimensType_"-07-01"
			Set aDateTo   =+aDimensType_"-09-30"
		}
		Else{
			Set aDateFrom =+aDimensType_"-10-01"
			Set aDateTo   =+aDimensType_"-12-31"
		}
	}ElseIf(aStatUnit=3){
		Set aDateFrom=+aDimensType_"-01-01"
		Set aDateTo=+aDimensType_"-12-31"
	}
	Quit:(aDateFrom="")||(aDateTo="") $$$OK

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set aLocIDs=aLocID
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//取统计科室类型
	Set aLocType ="W"
	if (aLocID'=""){
	   Set ConTypeDr = $g(^DHCHAI.BT.LocationD(+aLocID))
	   Set BTTypeDr = $lg(ConTypeDr,5)
	   Set aLocType = $lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
	}
	Set DimensMark = aLocType
    Set NIndex="QryInfTrendPatDtl"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科
    Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
				
			Set HospDr=$lg(LocData,8)
			//医院分组过滤
			Continue:HospDr=""
			Set HospInfo="",HospGroupDr="",HospGrpInfo=""
			Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
			Set HospGroupDr=$lg(HospInfo,5)
			Continue:HospGroupDr="" 
			Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
			//院区过滤
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
			
			Set GroupDr  = $lg(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}	
			Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
			Set GroupDesc=$lg(GroupData,3)

            //取统计维度
			Set DimensDesc =""
			Set:DimensMark="" DimensDesc="全部"
			Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
			Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
			Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
			Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
	
			Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
		    For index1=1:1:ListLocArray.Count() {
				Set TransInfo=ListLocArray.GetAt(index1)
				Continue:TransInfo=""
				
				Set Paadm      = $LIST(TransInfo,1)
				Set LocID      = $LIST(TransInfo,2)
				Set TransType  = $LIST(TransInfo,3)
				Set TransDates = $LIST(TransInfo,4)
				Set LnkLocDr   = $LIST(TransInfo,5)
				Set TransIDs   = $LIST(TransInfo,6)
				Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2
				
				Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
	            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	            Set AdmTimes = $lg(AdmData,38)   //就诊次数
	            
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
				    Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)
					//如果转科起止日期大于统计日期，以统计日期计算
					Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
					Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
					Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
					Set InfFlag="否"
					Set tInfFlag=..GetInfPosInfo(Paadm,DateFrom,DateTo,1)
					Set:tInfFlag'="" InfFlag="是"
					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,InfFlag)	
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
				
	}	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfTrendPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfTrendPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfTrendPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfTrendPatDtlExecute ]
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

/// zw ##class(DHCHAI.STATV2.InfTrendStat).GetStatUnit("65634","1")
ClassMethod GetStatUnit(aDates As %String, aStatUnit As %String) As %String
{
	New (aDates,aStatUnit)
	Set return=""
	Quit:(aDates="") return
	Set StatNames=$lb()
	If (aStatUnit=1){ // 按月统计
		For i=1:1:$l(aDates,","){
			Set XDate = $p(aDates,",",i)
			Continue:XDate=""
			Set XDate=$zd(XDate,3)
			Set StatYear  = $p(XDate,"-",1)
			Set StatMonth = $p(XDate,"-",2)	
			Set infStatName = StatYear_"年"_StatMonth_"月" 
			Continue:($lf(StatNames,infStatName)>0)
			Set StatNames=StatNames_$lb(infStatName)
		}
	}ElseIf (aStatUnit=2){ // 按季度统计
		For i=1:1:$l(aDates,","){
			Set XDate = $p(aDates,",",i)
			Continue:XDate=""
			Set XDate=$zd(XDate,3)
			Set StatYear  = $p(XDate,"-",1)
			Set StatMonth = $p(XDate,"-",2)	
			Set infStatName = StatYear_"年"_$s((+StatMonth)<4:"1",(+StatMonth)<7:"2",(+StatMonth)<10:"3",1:"4")_"季度"
			Continue:($lf(StatNames,infStatName)>0)
			Set StatNames=StatNames_$lb(infStatName)
		}
	}Else {  // 按年统计
		For i=1:1:$l(aDates,","){
			Set XDate = $p(aDates,",",i)
			Continue:XDate=""
			Set XDate=$zd(XDate,3)
			Set StatYear  = $p(XDate,"-",1)
			Set StatMonth = $p(XDate,"-",2)	
			Set infStatName = StatYear_"年"
			Continue:($lf(StatNames,infStatName)>0)
			Set StatNames=StatNames_$lb(infStatName)
		}
	}
	Quit StatNames
}

}

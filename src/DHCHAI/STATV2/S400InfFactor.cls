/// 名称: DHCHAI.STATV2.S400InfFactor
/// 描述: 住院患者医院感染易感因素分布
/// 编写者：蒋朋朋
/// 编写日期: 2019-10-21
Class DHCHAI.STATV2.S400InfFactor Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-14
/// Description:  住院患者医院感染易感因素分布统计
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aQryCon：  有效数据筛查
///               aStatDimens :  展示维度
///               aLocIDs :    科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S400InfFactor","QryInfFactor","","2022-11-01","2022-11-22","W","1","","")
Query QryInfFactor(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,InfPatCnt:%Integer,InfCaseCnt:%Integer,FactDesc:%String,InfFactCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfFactorExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
	
    Set NIndex="QryS040Inf"
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
				//获取感染信息
				Set InfFlg=0,PosFactsInfos=""
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
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
					Set PosFactsInfo =..GetINFFactInvInfo(Paadm,DateFrom,DateTo,1,LocDr,WardDr)	
					Set:PosFactsInfo'="" InfFlg=1,PosFactsInfos=PosFactsInfos_"$"_PosFactsInfo
				}
				Set:PosFactsInfos'="" PosFactsInfos = $e(PosFactsInfos,2,$l(PosFactsInfos))
				// 计算感染人数及感染例次数
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					// 感染人数
					If (InfFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
						}
					}
					For xPosI = 1:1:$l(PosFactsInfos,"$") {
						Set PosFactsInfo = $p(PosFactsInfos,"$",xPosI)
						Continue:PosFactsInfo=""
						Set PosInfo   = $p(PosFactsInfo,"#",1)
						Set FactsInfo = $p(PosFactsInfo,"#",2)
						Continue:PosInfo=""
						Set DiagDr = $p(PosInfo,"^",1)
						
						Continue:$d(^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)=""
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
						
						For xFacI = 1:1:$l(FactsInfo,"|") {
							Set Facts = $p(FactsInfo,"|",xFacI)
							Continue:Facts=""
							Set FactDesc = $p(Facts,"^",2)
							
							//记录易感因素
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfFact",FactDesc))
						}
					}
				}
				If (LocCount>1) {
					// 合计感染人数
					If (InfFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfPat"))
							Set ^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)=""
						}
					}
					For xPosI = 1:1:$l(PosFactsInfos,"$") {
						Set PosFactsInfo = $p(PosFactsInfos,"$",xPosI)
						Continue:PosFactsInfo=""
						Set PosInfo   = $p(PosFactsInfo,"#",1)
						Set FactsInfo = $p(PosFactsInfo,"#",2)
						
						Continue:PosInfo=""
						Set DiagDr = $p(PosInfo,"^",1)
						
						Continue:$d(^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)=""
						Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfCase"))
						
						For xFacI = 1:1:$l(FactsInfo,"|") {
							Set Facts = $p(FactsInfo,"|",xFacI)
							Continue:Facts=""
							Set FactDesc = $p(Facts,"^",2)
							
							//记录易感因素
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfFact",FactDesc))
						}
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
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
		
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase"))    		//新发感染例次数
		
		Continue:(IsActive="0")&&(InfPatCnt=0)	
		Continue:(aQryCon="2")&&(InfPatCnt=0)
		Continue:(aQryCon="3")&&(InfPatCnt=0)
		
		//统计单元中所有报告都没有易感因素
	    If ('$d(^TMP($zn,$j,NIndex,xDimensKey,"InfFact"))) {
		    	Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,"","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	    }ELse {
			Set FactDesc=""
			for {
				Set FactDesc=$o(^TMP($zn,$j,NIndex,xDimensKey,"InfFact",FactDesc))
				Quit:FactDesc=""
				
				Set InfFactCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfFact",FactDesc))  	
				Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,FactDesc,InfFactCount)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
	}
	If (LocCount>1) {
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))    		//新发感染例次数
		//统计单元中所有报告都没有易感因素
	    If ('$d(^TMP($zn,$j,NIndex,"Sum","InfFact"))) {
		    	Set Data=$lb("","全部",InfPatCnt,InfCaseCnt,"","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	    }ELse {
			Set FactDesc=""
			for {
				Set FactDesc=$o(^TMP($zn,$j,NIndex,"Sum","InfFact",FactDesc))
				Quit:FactDesc=""
				
				Set InfFactCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfFact",FactDesc))  	
				Set Data=$lb("","全部",InfPatCnt,InfCaseCnt,FactDesc,InfFactCount)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfFactorExecute ]
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
/// CreatDate：   2020-05-12
/// Description:  住院患者易感因素感染患者明细
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型
///               aLocIDs:   合计科室
/// 			  aFactor ：易感因素
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S400InfFactor","QryInfPosDtl","2019-04-27","2022-06-10","0000-00-0000-A-1","W","")
Query QryInfPosDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aFactor As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,Factors:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aFactor As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark	= $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
	Set NIndex="QryInfPosDtl"
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
			Continue:(aLocDr'="")&(aLocDr'=xLocID)
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
			Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
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
			Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)

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

					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
					
					//获取感染信息
					Set InfPosDescs =..GetInfPosInfo(Paadm,DateFrom,DateTo,1,LocDr,WardDr)	
					Continue:InfPosDescs=""
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
	                    
	                    Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
	                    Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
	                    Set Factors=..GetFactorsByDiagID(DiagDr)
						Set:Factors'="" Factors=$p(Factors,"#",2) 
						Continue:(aFactor'="")&&(Factors'[aFactor)
						
						Continue:$d(^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)=""
						
						Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,Factors)
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

/// Creator：     zhoubo
/// CreatDate：   2020-05-12
/// Description:  获取患者感染报告中易感因素
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       易感因素
/// w ##class(DHCHAI.STATV2.S400InfFactor).GetFactorsByDiagID("1")
ClassMethod GetFactorsByDiagID(aDiagID As %String) As %String
{
	New (aDiagID)
	Set return=""
	Quit:(aDiagID="") return
	Set InfFactors=""
	// Add by zhaoyj 2022-06-17 Global方式
	Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFDiagnos",aDiagID)
	Set ReportID=""
	For indRep=1:1:arrReport.Count() {
		Set RepData=arrReport.GetAt(indRep)
		Continue:RepData=""
		Set ReportID=$lg(RepData,$LL(RepData))
		Set IRStatusDr=$lg(RepData,8)
		Continue:IRStatusDr=""
		Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
		//1保存、2提交、3审核、4作废、5退回、6取消审核
		Continue:(RepStatus="4")

		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFPreFactor","U"),ReportID,xSub))
			Quit:xSub=""
		
			Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSub))
			Continue:INFRepExtData=""
			Set DataID=$lg(INFRepExtData,3)
			Continue:DataID=""
			Set FacsData = $g(^DHCHAI.IR.INFPreFactorD(DataID))
			Continue:FacsData=""
			Set IRPreFactorDr=$lg(FacsData,7)
			Continue:IRPreFactorDr=""
			Set Factor = $lg($g(^DHCHAI.BT.PreFactorD(IRPreFactorDr)),3)
			Set InfFactors = InfFactors_","_Factor
		}
	}
	Set:InfFactors'="" InfFactors = $e(InfFactors,2,$l(InfFactors))
	Set:InfFactors'="" return=ReportID_"#"_InfFactors
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2017-04-12
/// Description:  查询易感因素列表
/// Table：       DHCHAI.BT.PreFactor
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S400InfFactor","QueryPreFactor","1","1")
Query QueryPreFactor(aIsNewborn As %String = "", aActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,BTIsActive:%String,IsActive:%String,IsNewborn:%String,BTIsNewborn:%String") [ SqlProc ]
{
}

ClassMethod QueryPreFactorExecute(ByRef qHandle As %Binary, aIsNewborn As %String = "", aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Set:aIsNewborn=0 aIsNewborn=""
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.PreFactorD(xID))
	 	Quit:xID=""
	 	
	 	// Add by zhaoyj 2022-06-17 Global方式
		Set Data=$g(^DHCHAI.BT.PreFactorD(xID))
		Continue:Data=""
		Set Code=$li(Data,2)
		Set Desc=$li(Data,3)
		Set IndNo=$li(Data,4)
		Set IsActive=$li(Data,5)
		Continue:(aActive'="")&&(aActive'=IsActive)
		Set BTIsActive=$s(IsActive=1:"是",1:"否")
		Set IsNewborn=$li(Data,6)
	    Continue:(aIsNewborn'="")&&(aIsNewborn'=IsNewborn)
		Set BTIsNewborn=$s(IsNewborn=2:"是",1:"否")
		set Data=$lb(xID,Code,Desc,IndNo,BTIsActive,IsActive,IsNewborn,BTIsNewborn)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryPreFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPreFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPreFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPreFactorExecute ]
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
/// CreatDate：   2022-11-22
/// Description:  获取患者感染报告感染信息+易感因素+侵害性操作                                                                                                
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
///               aInfTypeCode:1 医院感染 0：社区感染
/// return:       
/// w ##class(DHCHAI.STATV2.S400InfFactor).GetINFFactInvInfo("720","61086","66529")
ClassMethod GetINFFactInvInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInfTypeCode As %String = "", aLocDr As %String = "", aWardDr As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aInfTypeCode,aLocDr,aWardDr)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	Set DiagInfos=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:($lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3")
			//报告日期
			Set RepDate=$lg(INFRepData,4)
			Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			//报告人
			Set RepUser=""
			Set RepUserDr=$lg(INFRepData,7)
			Set RepUserData=$g(^DHCHAI.BT.SysUserD(RepUserDr))
			Set BTDesc=$lg(RepUserData,3)
			Set:RepUserDr'="" RepUser=BTDesc
			//代报标志
			Set ReplaceFlag=$lg(INFRepData,16)
			// 感染诊断信息
			Set InfPosDescs=""
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug
							
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Continue:InfPosData=""
				Set InPosDiag = $lg(InfPosData,3)
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Continue:BigCode=""
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate = $lg(DiagsData,7)
				//1，判断本次感染是否是手术感染，手术感染关联手术是否是历史手术，历史手术本次就诊感染人数就不统计，
				//   按照手术日期统计到历史就诊上。
				Set OperInfFlag=0
				If ((InPosDiag["表浅")||((InPosDiag["深部"))||((InPosDiag["器官和腔隙感染"))){
					Set xxSub=0
					For {
						Set xxSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xxSub))
						Quit:xxSub=""
			
						Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xxSub))
						Continue:INFRepExtData=""
						Set xOPSID = $lg(INFRepExtData,3)
						Continue:xOPSID=""
						Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
						Continue:OPSData=""
						Set OpsEpisodeDr = $lg(OPSData,2)  // 手术对应的就诊号
						Set IROperDr     = $lg(OPSData,3)
						Set IROperDate   = $lg(OPSData,7)
						Continue:IROperDate=""
						Set OperInfFlag=1
						If (OpsEpisodeDr=aEpisodeID){     // 本次就诊的手术，感染日期修改成手术开始日期
							Set InfDate = IROperDate
						}Else{                            // 历史就诊的手术，本次就诊不统计，设置感染日期为空
							Set InfDate="" 
						}
					}
				}
				Continue:InfDate=""
				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set InfTypeCode=1
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
			   		Set:(OperInfFlag'=1)&(InfDate-AdmDate<2) InfType="社区感染",InfTypeCode=0  //社区感染判断
				}
				Continue:(aInfTypeCode'="")&&(aInfTypeCode'=InfTypeCode)
				
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
				If (aWardDr'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardDr)				
				}
				If (aLocDr'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocDr)
				}
				
				//感染科室
				Set InfLocDesc=""
				Set IRInfLocDr=$lg(DiagsData,6)
				If (IRInfLocDr'=""){
					Set IRInfLocData = $g(^DHCHAI.BT.LocationD(IRInfLocDr))
					Set LocDesc2 = $lg(IRInfLocData,4)
					Set LocDesc  = $lg(IRInfLocData,3)
					Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
				}
				//转归情况
				Set InfEffect=""
				Set IRInfEffectDr=$lg(DiagsData,8)
				If (IRInfEffectDr'=""){
					Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
					Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
				}
				If (InfPos'=""){
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_InPosDiag_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_ReplaceFlag_"^"_RepUser
				}
			}
			Continue:InfPosDescs=""
			Set InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
			Set InfFactors=""
			Set xSubFact=0
			For {
				Set xSubFact=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFPreFactor","U"),xID,xSubFact))
				Quit:xSubFact=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSubFact))
				Continue:INFRepExtData=""
				Set FacID=$lg(INFRepExtData,3)
				Continue:FacID=""
				Set FacsData = $g(^DHCHAI.IR.INFPreFactorD(FacID))
				Continue:FacsData=""
				Set IRPreFactorDr=$lg(FacsData,7)
				Continue:IRPreFactorDr=""
				Set Factor = $lg($g(^DHCHAI.BT.PreFactorD(IRPreFactorDr)),3)
				Set:Factor'="" InfFactors = InfFactors_"|"_FacID_"^"_Factor
			}
			Set:InfFactors'="" InfFactors = $e(InfFactors,2,$l(InfFactors))
			//获取侵害性操作
			Set InvOperDescs=""
			Set xInvSub=0
			For {
				Set xInvSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFInvOper","U"),xID,xInvSub))
				Quit:xInvSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xInvSub))
				Continue:INFRepExtData=""
				Set InvOperID=$lg(INFRepExtData,3)
				Continue:InvOperID=""
				Set InvOperData = $g(^DHCHAI.IR.INFInvOperD(InvOperID))
				Continue:InvOperData=""
				
				Set InvOperDic = $lg(InvOperData,3)
				Continue:InvOperDic=""
				
				If (InvOperDic'=""){
					Set InvOperDesc = $lg($g(^DHCHAI.BT.InvasOperD(InvOperDic)),3)
					Set:InvOperDesc'="" InvOperDescs = InvOperDescs_"|"_InvOperID_"^"_InvOperDesc
				}
			}
			Set:InvOperDescs'="" InvOperDescs = $e(InvOperDescs,2,$l(InvOperDescs))
			Set return=return_"$"_InfPosDescs_"#"_InfFactors_"#"_InvOperDescs
		}
	}
	//2，本次就诊的手术是否被后面就诊感染信息关联，关联即按照手术日期统计本次就诊感染。
	// 历史就诊，医院感染关联的手术
	Set LastAdmID=$o(^DHCHAI.IR.INFLastAdmI("IndexLastAdm",aEpisodeID,""))
	Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFLastAdm",LastAdmID)
	If (arrInfRep.Count()>0){
		For indIR=1:1:arrInfRep.Count() {
			Set InfRepData=arrInfRep.GetAt(indIR)
			Continue:InfRepData=""
			Set InfRepType=$lg(InfRepData,3)
			Continue:(InfRepType'=1)&(InfRepType'=2) //感染报告 新生儿感染报告
			Set ReportID=$lg(InfRepData,1)
			Set RepStatus=$lg(InfRepData,8)
			Set LinkEpsodeID=$lg(InfRepData,2)
			Continue:LinkEpsodeID=""
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			//报告日期
			Set RepDate=$lg(InfRepData,4)
			Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			//报告人
			Set RepUser=""
			Set RepUserDr=$lg(InfRepData,7)
			Set RepUserData=$g(^DHCHAI.BT.SysUserD(RepUserDr))
			Set BTDesc=$lg(RepUserData,3)
			Set:RepUserDr'="" RepUser=BTDesc
			//代报标志
			Set ReplaceFlag=$lg(InfRepData,16)
			Set InfPosDescs=""
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),ReportID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug
				
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Continue:InfPosData=""
				Set InPosDiag = $lg(InfPosData,3)
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Continue:BigCode=""
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate = $lg(DiagsData,7)
				//1，判断本次感染是否是手术感染，手术感染关联手术是否是历史手术，历史手术本次就诊感染人数就不统计，
				//   按照手术日期统计到历史就诊上。
				Set OperInfFlag=0
				If ((InPosDiag["表浅")||((InPosDiag["深部"))||((InPosDiag["器官和腔隙感染"))){
					Set xxSub=0
					For {
						Set xxSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),ReportID,xxSub))
						Quit:xxSub=""
			
						Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xxSub))
						Continue:INFRepExtData=""
						Set xOPSID = $lg(INFRepExtData,3)
						Continue:xOPSID=""
						Set OPSData      = $g(^DHCHAI.IR.INFOPSD(xOPSID))
						Continue:OPSData=""
						Set OpsEpisodeDr = $lg(OPSData,2)  // 手术对应的就诊号
						Set IROperDr     = $lg(OPSData,3)
						Set IROperDate   = $lg(OPSData,7)
						Continue:IROperDate=""
						Set OperInfFlag=1
						Set InfDate = IROperDate
					}
				}
				Continue:OperInfFlag'=1   // 非手术感染
				Continue:InfDate=""
				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set InfTypeCode=1
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(LinkEpsodeID)),20)
			   		Set:(OperInfFlag'=1)&(InfDate-AdmDate<2) InfType="社区感染",InfTypeCode=0  //社区感染判断
				}
				Continue:(aInfTypeCode'="")&&(aInfTypeCode'=InfTypeCode)
				
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
				If (aWardDr'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardDr)				
				}
				If (aLocDr'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocDr)
				}
				
				//感染科室
				Set InfLocDesc=""
				Set IRInfLocDr=$lg(DiagsData,6)
				If (IRInfLocDr'=""){
					Set IRInfLocData = $g(^DHCHAI.BT.LocationD(IRInfLocDr))
					Set LocDesc2 = $lg(IRInfLocData,4)
					Set LocDesc  = $lg(IRInfLocData,3)
					Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
				}
				//转归情况
				Set InfEffect=""
				Set IRInfEffectDr=$lg(DiagsData,8)
				If (IRInfEffectDr'=""){
					Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
					Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
				}
				If (InfPos'=""){
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_InPosDiag_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_ReplaceFlag_"^"_RepUser
				}
			}
			Continue:InfPosDescs=""
			Set InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
			Set InfFactors=""
			Set xSubFact=0
			For {
				Set xSubFact=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFPreFactor","U"),ReportID,xSubFact))
				Quit:xSubFact=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSubFact))
				Continue:INFRepExtData=""
				Set FacID=$lg(INFRepExtData,3)
				Continue:FacID=""
				Set FacsData = $g(^DHCHAI.IR.INFPreFactorD(FacID))
				Continue:FacsData=""
				Set IRPreFactorDr=$lg(FacsData,7)
				Continue:IRPreFactorDr=""
				Set Factor = $lg($g(^DHCHAI.BT.PreFactorD(IRPreFactorDr)),3)
				Set:Factor'="" InfFactors = InfFactors_"|"_FacID_"^"_Factor
			}
			Set:InfFactors'="" InfFactors = $e(InfFactors,2,$l(InfFactors))
			//获取侵害性操作
			Set InvOperDescs=""
			Set xInvSub=0
			For {
				Set xInvSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFInvOper","U"),ReportID,xInvSub))
				Quit:xInvSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xInvSub))
				Continue:INFRepExtData=""
				Set InvOperID=$lg(INFRepExtData,3)
				Continue:InvOperID=""
				Set InvOperData = $g(^DHCHAI.IR.INFInvOperD(InvOperID))
				Continue:InvOperData=""
				
				Set InvOperDic = $lg(InvOperData,3)
				Continue:InvOperDic=""
				
				If (InvOperDic'=""){
					Set InvOperDesc = $lg($g(^DHCHAI.BT.InvasOperD(InvOperDic)),3)
					Set:InvOperDesc'="" InvOperDescs = InvOperDescs_"|"_InvOperID_"^"_InvOperDesc
				}
			}
			Set:InvOperDescs'="" InvOperDescs = $e(InvOperDescs,2,$l(InvOperDescs))
			Set return=return_"$"_InfPosDescs_"#"_InfFactors_"#"_InvOperDescs
		}
	}
	
	Set:return'="" return = $e(return,2,$l(return))
	Quit return
}

}

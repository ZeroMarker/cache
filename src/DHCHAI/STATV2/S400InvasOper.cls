/// 名称: DHCHAI.STATV2.S400InvasOper
/// 描述: 住院患者医院感染侵害性操作分布
/// 编写者：蒋朋朋
/// 编写日期: 2019-11-25
Class DHCHAI.STATV2.S400InvasOper Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-25
/// Description:  住院患者医院感染侵害性操作分布统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S400InvasOper","QryInvasOper","","2017-11-01","2022-11-22","W","1","","27,29,31,33,35")
Query QryInvasOper(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,InfPatCnt:%Integer,InfCaseCnt:%Integer,InvDesc:%String,InfInvCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryInvasOperExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
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
					Set PosFactsInfo =##class(DHCHAI.STATV2.S400InfFactor).GetINFFactInvInfo(Paadm,DateFrom,DateTo,1,LocDr,WardDr)	
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
						Set InvInfo = $p(PosFactsInfo,"#",3)
						Continue:PosInfo=""
						Set DiagDr = $p(PosInfo,"^",1)
						
						Continue:$d(^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)=""
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
						
						For xInvI = 1:1:$l(InvInfo,"|") {
							Set InvOpers = $p(InvInfo,"|",xInvI)
							Continue:InvOpers=""
							Set InvOperDesc = $p(InvOpers,"^",2)
							
							//记录侵害性操作
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfInv",InvOperDesc))
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
						Continue:PosInfo=""
						Set DiagDr = $p(PosInfo,"^",1)
						
						Continue:$d(^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)=""
						Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfCase"))
						
						Set InvInfo = $p(PosFactsInfo,"#",3)
						For xInvI = 1:1:$l(InvInfo,"|") {
							Set InvOpers = $p(InvInfo,"|",xInvI)
							Continue:InvOpers=""
							Set InvOperDesc = $p(InvOpers,"^",2)
							
							//记录侵害性操作
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfInv",InvOperDesc))
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
	    If ('$d(^TMP($zn,$j,NIndex,xDimensKey,"InfInv"))) {
		    	Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,"","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	    }ELse {
			Set InvDesc=""
			for {
				Set InvDesc=$o(^TMP($zn,$j,NIndex,xDimensKey,"InfInv",InvDesc))
				Quit:InvDesc=""
				
				Set InfInvCount=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfInv",InvDesc))  	
				Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,InvDesc,InfInvCount)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
	}
	If (LocCount>1) {
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))    		//新发感染例次数
		//统计单元中所有报告都没有易感因素
	    If ('$d(^TMP($zn,$j,NIndex,"Sum","InfInv"))) {
		    	Set Data=$lb("","全部",InfPatCnt,InfCaseCnt,"","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	    }ELse {
			Set InvDesc=""
			for {
				Set InvDesc=$o(^TMP($zn,$j,NIndex,"Sum","InfInv",InvDesc))
				Quit:InvDesc=""
				
				Set InfInvCount=+$g(^TMP($zn,$j,NIndex,"Sum","InfInv",InvDesc))  	
				Set Data=$lb("","全部",InfPatCnt,InfCaseCnt,InvDesc,InfInvCount)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Quit $$$OK
}

ClassMethod QryInvasOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInvasOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInvasOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInvasOperExecute ]
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
/// CreatDate：   2020-05-13
/// Description:  住院患者易感因素感染患者明细
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型
///               aLocIDs:   合计科室
/// 			  aInvOper ：侵害性操作
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S400InvasOper","QryInfPosDtl","","2012-02-01","2022-04-26","0000-00-0000-A-1","W","27,29,31,33,35")
Query QryInfPosDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aInvOper As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,InvOpers:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aInvOper As %String = "") As %Status
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
	                    Set InvOpers=..GetInvOpersByDiagID(DiagDr)
						Set:InvOpers'="" InvOpers=$p(InvOpers,"#",2) 
						Continue:(aInvOper'="")&&(InvOpers'[aInvOper)
						Continue:$d(^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)=""
						Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,InvOpers)
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

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-26
/// Description:  获取患者感染报告中侵害性操作
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       
/// w ##class(DHCHAI.STATV2.S400InvasOper).GetInvasOpers("4674","2018-10-16","2018-12-16")
ClassMethod GetInvasOpers(aEpisodeID, aDateFrom, aDateTo) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set (InfPosDescs,InvOperDescs,InfDiagList)=""
	Set InfPosDescs=""

	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,"1",xID))
		Quit:xID=""
		// Add by zhaoyj 2022-06-17 Global方式
		Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
		Continue:INFRepData=""
		Set RepStatus =$lg(INFRepData,8)
		Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
		Set DicStatus=$g(^DHCHAI.BT.DictionaryD(RepStatus))
		Set StatusCode =$lg(DicStatus,2)
		Continue:(StatusCode'="3")
				
		// 感染诊断信息
		Set xDiagSub=0
		For {
			Set xDiagSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xDiagSub))
			Quit:xDiagSub=""
	
			Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xDiagSub))
			Continue:INFRepExtData=""
			Set DiagID=$lg(INFRepExtData,3)
			Continue:DiagID=""
			Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
			Continue:DiagsData=""
			// 感染日期
			Set InfDate  = $lg(DiagsData,5)
			Set InfXDate  = $lg(DiagsData,7)
			//update  20210907  与公共方法统一修改
			//感染类型过滤
			Set InfType=$lg(DiagsData,18)
			If (InfType="") {
				Set InfType=1
				Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
				Set:InfDate-AdmDate<2 InfType=0
			}
			Continue:InfType'=1		
			Set:InfXDate="" InfXDate=+$h
			Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
			Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
			
			Set InfDiagList=InfDiagList_$lb(xID)  //add 20220822 患者既有医院感染又有社区感染时，侵害性操作明细输出错误修改		
			// 感染诊断
			Set InfPos = $lg(DiagsData,3)
			If (InfPos'=""){
				Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)_"^"_InfDate_"^"_xID
			}
		}
		Continue:InfPosDescs=""
		Continue:$listfind(InfDiagList,xID)<1
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFInvOper","U"),xID,xSub))
			Quit:xSub=""
	
			Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
			Continue:INFRepExtData=""
			Set DataID=$lg(INFRepExtData,3)
			Continue:DataID=""
			Set InvOperData = $g(^DHCHAI.IR.INFInvOperD(DataID))
			Continue:InvOperData=""
			
			Set SttDate = $lg(InvOperData,4)
			Set EndDate = $lg(InvOperData,5)
			
			If ((SttDate'="")&(EndDate'="")){
				Continue:SttDate>aDateTo
				Continue:EndDate<aDateFrom	
			}     
			
			Set InvOperDic = $lg(InvOperData,3)
			Continue:InvOperDic=""
			
			Set (InvOperID,InvOper)=""
			If (InvOperDic'=""){
				Set InvOperID = InvOperDic
				Set InvOperDesc = $lg($g(^DHCHAI.BT.InvasOperD(InvOperDic)),3)
				Set InvOperDescs = InvOperDescs_"|"_InvOperID_"^"_InvOperDesc_"^"_xID
			}
		}
	}

	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InvOperDescs'="" InvOperDescs = $e(InvOperDescs,2,$l(InvOperDescs))
	Set return=InfPosDescs_"#"_InvOperDescs
		
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-05-12
/// Description:  获取患者感染报告中侵害性操作
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       易感因素
/// w ##class(DHCHAI.STATV2.S400InvasOper).GetInvOpersByDiagID("2")
ClassMethod GetInvOpersByDiagID(aDiagID As %String) As %String
{
	New (aDiagID)
	Set return=""
	Quit:(aDiagID="") return
	Set InvOpers=""
	// Add by zhaoyj 2022-06-17 Global方式
	Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFDiagnos",aDiagID)
	Set ReportID=""
	For indRep=1:1:arrReport.Count() {
		Set RepData=arrReport.GetAt(indRep)
		Continue:RepData=""
		Set ReportID=$lg(RepData,$LL(RepData))
		Set IRStatusDr=$lg(RepData,8)
		Continue:IRStatusDr=""
		Continue:ReportID=""
		Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
		//1保存、2提交、3审核、4作废、5退回、6取消审核
		Continue:(RepStatus="4")
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFInvOper","U"),ReportID,xSub))
			Quit:xSub=""
		
			Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSub))
			Continue:INFRepExtData=""
			Set DataID=$lg(INFRepExtData,3)
			Continue:DataID=""
			Set InvOperData = $g(^DHCHAI.IR.INFInvOperD(DataID))
			Continue:InvOperData=""
			Set InvOperDr=$lg(InvOperData,3)
			Continue:InvOperDr=""
			Set InvOper = $lg($g(^DHCHAI.BT.InvasOperD(InvOperDr)),3)
			Set:InvOper'="" InvOpers = InvOpers_","_InvOper
		}
	}
	Set:InvOpers'="" InvOpers = $e(InvOpers,2,$l(InvOpers))
	Set:InvOpers'="" return=ReportID_"#"_InvOpers
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-26
/// Description:  查询侵害性操作字典
/// Table：       DHCHAI.BT.InvasOper
/// Input：       aActive是否有效
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S400InvasOper","QryInvOper","1")
Query QryInvOper(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryInvOperExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.InvasOperD(xID))
	 	Quit:xID=""
	 	
	 	// Add by zhaoyj 2022-06-17 Global方式
		Set Data=$g(^DHCHAI.BT.InvasOperD(xID))
		Continue:Data=""
		Set Code=$lg(Data,2)
		Set Desc=$lg(Data,3)
		Set IndNo=$lg(Data,4)
		Set IsActive=$lg(Data,5)
		Continue:(aActive'="")&&(aActive'=IsActive)
		Set BTIsActive=$s(IsActive=1:"是",1:"否")
		
		set Data=$lb(xID,Code,Desc,IndNo,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInvOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInvOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInvOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInvOperExecute ]
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

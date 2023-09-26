/// 名称: DHCHAI.STATV2.S390InfPos
/// 描述: 住院患者医院感染部位分布统计表
/// 编写者：蒋朋朋
/// 编写日期: 2019-10-21
Class DHCHAI.STATV2.S390InfPos Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-14
/// Description:  住院患者医院感染部位分布统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S390InfPos","QryInfPos","","2022-11-01","2022-11-24","W","1")
Query QryInfPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,InfPatCnt:%Integer,InfCaseCnt:%Integer,PosDesc:%String,InfDiagDesc:%String,InfDiagCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
	
    Set NIndex="QryInfPos"
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
				Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))   // add by zhoubo 
				Set HospDr=$li(LocData,8)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
				Set GroupDr  = $li(LocData,7)
				If GroupDr="" {
					Set GroupDesc="其他科"
					Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
				}
				//获取感染信息
				Set InfFlg=0,InfPosDescs=""
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
					Set:InfPosDesc'="" InfFlg=1,InfPosDescs=InfPosDescs_"|"_InfPosDesc
				}
				Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
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
					// 感染例数
					If (InfFlg=1) {
						For PosInd=1:1:$l(InfPosDescs,"|") {
							Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
							Continue:InfPosInfo=""
							Set DiagDr = $p(InfPosInfo,"^",1)
							Set DiagDesc = $p(InfPosInfo,"^",2)
							Continue:DiagDesc=""
							Set PosDesc = $p(InfPosInfo,"^",6)
							Continue:PosDesc=""
							Continue:$d(^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)=""
							
							//记录感染诊断 
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfDiagDesc",DiagDesc))
							Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",DiagDesc) = PosDesc
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
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
					// 合计感染例数
					If (InfFlg=1) {
						For PosInd=1:1:$l(InfPosDescs,"|") {
							Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
							Continue:InfPosInfo=""
							Set DiagDr = $p(InfPosInfo,"^",1)
							Set DiagDesc = $p(InfPosInfo,"^",2)
							Continue:DiagDesc=""
							Set PosDesc = $p(InfPosInfo,"^",6)
							Continue:PosDesc=""
							Continue:$d(^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)=""
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfCase"))
							//记录感染诊断 
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfDiagDesc",DiagDesc))
							Set ^TMP($zn,$j,NIndex,"Sum","InfPosList",DiagDesc) = PosDesc
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
		
		//统计单元中所有报告都没有感染
	    If ('$d(^TMP($zn,$j,NIndex,xDimensKey,"InfDiagDesc"))) {
		    	Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,"","","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	    }ELse {
			Set InfDiagDesc=""
			for {
				Set InfDiagDesc=$o(^TMP($zn,$j,NIndex,xDimensKey,"InfDiagDesc",InfDiagDesc))
				Quit:InfDiagDesc=""
				Set PosDesc = $g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList",InfDiagDesc))
				Set InfDiagCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfDiagDesc",InfDiagDesc))  	
				Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
	}
	If (LocCount>1) {
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))    		//新发感染例次数
		//统计单元中所有报告都没有感染
	    If ('$d(^TMP($zn,$j,NIndex,"Sum","InfDiagDesc"))) {
		    	Set Data=$lb("","全部",InfPatCnt,InfCaseCnt,"","","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	    }ELse {
			Set InfDiagDesc=""
			for {
				Set InfDiagDesc=$o(^TMP($zn,$j,NIndex,"Sum","InfDiagDesc",InfDiagDesc))
				Quit:InfDiagDesc=""
				Set PosDesc = $g(^TMP($zn,$j,NIndex,"Sum","InfPosList",InfDiagDesc))
				Set InfDiagCnt=+$g(^TMP($zn,$j,NIndex,"Sum","InfDiagDesc",InfDiagDesc))  	
				Set Data=$lb("","全部",InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
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

/// Creator：     zhoubo
/// CreatDate：   2020-05-12
/// Description:  住院患者医院感染患者明细
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型
///               aLocIDs:   合计科室
/// 			  aPosDesc ：感染部位
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S390InfPos","QryInfPosDtl","2020-01-01","2020-05-12","0000-00-0000-A-1","W","")
Query QryInfPosDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aPosDesc As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aPosDesc As %String = "") As %Status
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
	                    Continue:(aPosDesc'="")&&(aPosDesc'=DiagDesc)
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
/// CreatDate：   2017-05-04
/// Description:  查询感染诊断（部位）信息 下拉框使用 按照Code排序
/// Table：       DHCHAI.BT.InfPos
/// Input：       aPosFlg:  1:查询感染部位 2:查询感染诊断 空:查询所有
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S390InfPos","QryInfPosToSelect","")
Query QryInfPosToSelect(aPosFlg As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DiagFlag:%String,GCode:%String,IsActive:%String,PosDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosToSelectExecute(ByRef qHandle As %Binary, aPosFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set:aPosFlg["#" aPosFlg=$p(aPosFlg,"#",2)
    Kill ^TMP($zn,$j,"QryInfPosToSelect")
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-16 Global方式
			Set InfPosData = $g(^DHCHAI.BT.InfPosD(xID))
			Continue:InfPosData=""
			
			Set Code     = $li(InfPosData,2)
			Set Desc     = $li(InfPosData,3)
			Set DiagFlag = $li(InfPosData,4)
			Set GCode    = $li(InfPosData,5)
			Set:GCode="" GCode="9999"
			Set PosCode=Code
			Set:$l(Code=4) PosCode=$e(Code,1,2)
			Set IsActive = $li(InfPosData,6)
			Continue:IsActive'=1
			Continue:(aPosFlg=1)&(DiagFlag'=0)  //查询所有部位
			Continue:(aPosFlg=2)&(DiagFlag'=1)  //查询所有诊断
			
			Set PosID=$o(^DHCHAI.BT.InfPosI("IdxofCode",PosCode,0))
			Continue:PosID=""
			Set InfPos=$g(^DHCHAI.BT.InfPosD(PosID))
			Continue:(InfPos="")
			Set PosDesc=$lg(InfPos,3)  // 感染部位名称
			Set ^TMP($zn,$j,"QryInfPosToSelect"," "_GCode,xID)=$lb(xID,Code,Desc,DiagFlag,GCode,IsActive,PosDesc)
		}
	}
	Set xGCode=""
	For {
		Set xGCode=$o(^TMP($zn,$j,"QryInfPosToSelect",xGCode))
		Quit:xGCode=""
		
		Set xID=0
		For {
			Set xID=$o(^TMP($zn,$j,"QryInfPosToSelect",xGCode,xID))
			Quit:xID=""
			Set Data=$g(^TMP($zn,$j,"QryInfPosToSelect",xGCode,xID))
			Set ^CacheTemp(repid,ind) = Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,"QryInfPosToSelect")
	Quit $$$OK
}

ClassMethod QryInfPosToSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfPosToSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-02-22
/// Description:  住院患者医院感染部位分布统计(用于院感首页环形图)
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S390InfPos","QryInPosInF","1","2021-01-01","2021-02-22","W")
Query QryInPosInF(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "2") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,InfPatCnt:%String,InfCaseCnt:%String,PosDesc:%String,InfDiagDesc:%String,InfDiagCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryInPosInFExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1") As %Status
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
   	
    Set NIndex="QryS010Inf"
	Kill ^TMP($zn,$j,NIndex)
	
    //同期在科:某段时间的在科人数
    //Set ListLocArray=..GetTransEpisByLocDate(aDateFrom,aDateTo,StatType,"","I")
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
					Set PosDesc=$p(InfPosMsg,"^",6)		//感染诊断
					Set InfDiagDesc=$p(InfPosMsg,"^",2)		//感染部位
					Set InfType=$p(InfPosMsg,"^",7)		//感染类型
					Continue:InfType="社区感染"			//不统计社区感染
					Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,DiagID)=PosDesc_"||"_InfDiagDesc
				}
			}
		}
		//计算感染人数及感染例次数
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			//如果该次就诊有感染信息，通过感染日期判断该次在科是否感染
			if ($o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,""))'="") {
				if '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
					
					if (DimensKey["A")||(DimensKey["H") {
						//院级感染人数不判断转科日期
						//记录感染人数
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
						Set InfDate=""
						for {
							Set InfDate=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate))
							Quit:InfDate=""
							
							Set xDiagID=""
							for {
								Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Quit:xDiagID=""
								
								//记录感染例次数
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
								//记录感染信息
								Set InfPosDesc=$g(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,InfPosDesc))
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",InfPosDesc) = ""
							}
						}
					}else{
						//非院级的感染人数需要判断转科日期，计算到感染科室（科别）
						Set InfDate=""
						for {
							Set InfDate=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate))
							Quit:InfDate=""
							Continue:(","_TransDates_",")'[(","_InfDate_",")
							
							//记录感染人数
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
							}
							
							Set xDiagID=""
							for {
								Set xDiagID=$o(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Quit:xDiagID=""
								
								//记录感染例次数
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
								//记录感染信息
								Set InfPosDesc=$g(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm,InfDate,xDiagID))
								Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,InfPosDesc))
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",InfPosDesc) = ""
							}
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
		//统计图只保留汇总数据 Add(2022-02-08) ShenC
		If (aHospIDs["|"){
			Continue:xDimensKey'["A"
		}
		else{
			Continue:xDimensKey'["H"
		}
		
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  			//新发感染人数
		Set InfCaseCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase"))    		//新发感染例次数
		Set xDiag=""
		For {
			Set xDiag=$o(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList",xDiag))
			Quit:xDiag=""
			Set InfDiagDesc =$p(xDiag,"||",1)
			Set InfDiagCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,xDiag)) //感染部位例数
			Set PosDesc     =$p(xDiag,"||",2)
			
			Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}	 		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInPosInFClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInPosInFExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInPosInFFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInPosInFExecute ]
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

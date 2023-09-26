/// 名称: DHCHAI.STATV2.S391InfPos
/// 描述: 出院患者医院感染部位分布统计表
/// 编写者：蒋朋朋
/// 编写日期: 2019-10-21
Class DHCHAI.STATV2.S391InfPos Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-11-24
/// Description:  医院感染部位分布统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aStatDimens:  展示维度    
///               aLocIDs :    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S391InfPos","QryInfPosCSS","","2021-01-01","2023-03-16","W","1","","75,76,77,78,79")
Query QryInfPosCSS(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,InfPatCnt:%Integer,InfCaseCnt:%Integer,PosDesc:%String,InfDiagDesc:%String,InfDiagCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
	
	Set NIndex="QryInfFactor"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					//就诊信息
					Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmInfo=""
					Set VisitStatus = $lg(AdmInfo,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//出院科室/病区
					Set DishLocID	= $List(AdmInfo,28)
					Set DishWardID	= $List(AdmInfo,29)
					Set LocDr=DishLocID
				    Set:aLocType="W" LocDr=DishWardID
				    Continue:LocDr=""
				    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
					
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set HospDr=$li(LocData,8)
					//  医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					 
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					//本次住院区间感染信息
					Set AdmDate = $li(AdmInfo,20)
					Set DischDate = $li(AdmInfo,26)
					Set InfPosDescs=..GetInfPosInfo(xPaadm,AdmDate,DischDate,1)
					Set InfFlg=0
					Set:InfPosDescs'="" InfFlg=1
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID) 
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// 感染人数
						If (InfFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",xPaadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",xPaadm)=""
							}
						}
						// 感染例数
						If (InfFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfCase",xPaadm)) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfCase")=+$g(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))+$L(InfPosDescs,"|")
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfCase",xPaadm)=""
							}
						}
						For xPosI = 1:1:$l(InfPosDescs,"|") {
							Set PosInfo = $p(InfPosDescs,"|",xPosI)
							Continue:PosInfo=""
							Set DiagDesc = $p(PosInfo,"^",2)
							Continue:DiagDesc=""
							Set PosDesc = $p(PosInfo,"^",6)
							Continue:PosDesc=""
							//记录感染诊断 
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfDiagDesc",DiagDesc))
							Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",DiagDesc) = PosDesc
						}
					}
					If (LocCount>1) {
						// 感染人数
						If (InfFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","InfPat",xPaadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfPat"))
								Set ^TMP($zn,$j,NIndex,"Sum","InfPat",xPaadm)=""
							}
						}
						// 感染例数
						If (InfFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","InfCase",xPaadm)) {
								Set ^TMP($zn,$j,NIndex,"Sum","InfCase")=+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))+$L(InfPosDescs,"|")
								Set ^TMP($zn,$j,NIndex,"Sum","InfCase",xPaadm)=""
							}
						}
						For xPosI = 1:1:$l(InfPosDescs,"|") {
							Set PosInfo = $p(InfPosDescs,"|",xPosI)
							Continue:PosInfo=""
							b ;11
							Set DiagDesc = $p(PosInfo,"^",2)
							Continue:DiagDesc=""
							Set PosDesc = $p(PosInfo,"^",6)
							Continue:PosDesc=""
							b ;2
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

ClassMethod QryInfPosCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
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
/// CreatDate：   2022-11-24
/// Description:  医院感染部位分布统计-感染患者明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型
///               aLocIDs:   合计科室
/// 			  aPosDesc ：感染部位
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S391InfPos","QryInfPosCSSDtl","2020-07-01","2020-07-31","0001-07-0000-G-3","W","")
Query QryInfPosCSSDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aPosDesc As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aPosDesc As %String = "") As %Status
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
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	
	Set aLocDr = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
	Set NIndex="QryInfPosCSSDtl"
	Kill ^TMP($zn,$j,NIndex)
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"		//只统计住院患者,急诊单独统计
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					
					Continue:(PAAdmData="")
					Set VisitStatus = $lg(PAAdmData,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
					//就诊开始结束日期
					Set AdmDate   = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes  = $lg(PAAdmData,38)   //就诊次数
				
					// 出院科室/病区
					Set DishLocID  = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set LocDr=DishLocID
				    Set:aLocType="W" LocDr=DishWardID
				    Continue:LocDr=""
				    Continue:(aLocDr'="")&(aLocDr'=LocDr)
				    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
				    
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set LocDesc	= $lg(LocData,3)
					Set LocDesc2= $lg(LocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Set HospDr=$lg(LocData,8)
					Continue:HospDr=""
					//医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					//医院分组过滤
					Set HospInfo="",HospGroupDr=""
					Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
					Set HospGroupDr=$lg(HospInfo,5) 
					Continue:HospGroupDr="" 
					Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
					Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
					
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
					Set GroupDesc=$li(GroupData,3)
					//按科室组、科室/病区过滤
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
				   
				   	//取统计维度
					Set DimensDesc =""
					Set:DimensMark="" DimensDesc="全部"
					Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
					Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
					Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
					Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
					//获取病人基本信息
					Set PatData =..BuildPaadmData(xPaadm)
					Continue:PatData=""
					Set TransInfoArr =..GetTransInfo(xPaadm,"","",aLocType)  //存在转科日期早于入院日期情况，取全部转科记录			
					For TransInd=1:1:TransInfoArr.Count(){
						Set TransInfo=TransInfoArr.GetAt(TransInd)
						Set TransID=$lg(TransInfo,1)
					    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
					    Set TransDate	= $li(TranData,7)
					    Set OutLocDate	= $li(TranData,10)
					    Set TransTime	= $li(TranData,8)
						Set OutLocTime	= $li(TranData,11)
						Set InfPosDescs=..GetInfPosInfo(xPaadm,TransDate,OutLocDate,1)
						Continue:InfPosDescs=""
						
						For PosInd=1:1:$l(InfPosDescs,"|") {
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
		                    Continue:(aPosDesc'="")&&(aPosDesc'=DiagDesc)
		                    
		                    Continue:$d(^TMP($zn,$j,NIndex,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"DiagDr",DiagDr)=""
							
							Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPosCSSDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
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
/// CreatDate：   2019-10-14
/// Description:  住院患者医院感染部位分布统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S391InfPos","QryInfPos","2018-12-01","2019-01-01","","","W","2")
Query QryInfPos(aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aLocIDs As %String = "", aLocType As %String = "E", aQryCon As %String = "2") As %Query(ROWSPEC = "ind:%String,DimenCode:%String,LocID:%String,LocDesc:%String,HAICount:%String,INFCount:%String,PosDesc:%String,InfPosCount:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocIDs As %String = "", aLocType As %String = "E", aQryCon As %String = "2") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set NIndex="QryInfPos"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ArrayStatDimens=..GetArrayStatDimens("AHG"_aLocType,aHospIDs,"",aLocIDs,aLocIDs,"I","","","")
	
	Set xDimen=""
	For {
		Set xDimensData=ArrayStatDimens.GetNext(.xDimen)
		Quit:xDimen=""
		
		Set DimenCode=$ListGet(xDimensData,1)
		Set LocID=$ListGet(xDimensData,2)
		Set LocDesc=$ListGet(xDimensData,3)
		Set IsActive=$ListGet(xDimensData,4)
		
		Set ArrDishEpis=..GetDishPatient("",aDateFrom,aDateTo,aLocType,LocID)
		
		//感染人数、感染例次数
		Set (HAICount,INFCount)=0
		Set xEpis=""
		For {
			Set xEpisData=ArrDishEpis.GetNext(.xEpis)
			Quit:xEpis=""
			
			Set EpisodeID=$ListGet(xEpisData,1)
			
			Set InfPosInfo=..GetInfPosInfo(EpisodeID,aDateFrom,aDateTo)
			Continue:InfPosInfo=""
			Set InfCount=$Length(InfPosInfo,"|")
			Set HAICount=HAICount+1
			Set INFCount=INFCount+InfCount
			
			For pind=1:1:InfCount {
				Set xPosInfo=$p(InfPosInfo,"|",pind)
				Set PosDesc=$p(xPosInfo,"^",6)
				
				Set num=$i(^TMP($zn,$j,NIndex,LocDesc,PosDesc))
			}
		}
		
		Continue:('IsActive)&&(HAICount=0)	//过滤掉没有数据的无效科室
		Continue:(aQryCon=2)&&(HAICount=0)  //过滤没有感染数据的科室
		
		Set xPosDesc=""
		For {
			Set xPosDesc=$o(^TMP($zn,$j,NIndex,LocDesc,xPosDesc))
			Quit:xPosDesc=""
			
			Set InfPosCount=$g(^TMP($zn,$j,NIndex,LocDesc,xPosDesc))
			
			Set Data=$lb(ind,DimenCode,LocID,LocDesc,HAICount,INFCount,xPosDesc,InfPosCount)
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

/// Creator：     zhoubo
/// CreatDate：   2017-05-04
/// Description:  查询感染诊断（部位）信息 下拉框使用 按照Code排序
/// Table：       DHCHAI.BT.InfPos
/// Input：       aPosFlg:  1:查询感染部位 2:查询感染诊断 空:查询所有
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S391InfPos","QryInfPosToSelect","")
Query QryInfPosToSelect(aPosFlg As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DiagFlag:%String,GCode:%String,IsActive:%String") [ SqlProc ]
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
			Set IsActive = $li(InfPosData,6)
			Continue:IsActive'=1
			Continue:(aPosFlg=1)&(DiagFlag'=0)  //查询所有部位
			Continue:(aPosFlg=2)&(DiagFlag'=1)  //查询所有诊断
			Set ^TMP($zn,$j,"QryInfPosToSelect"," "_GCode,xID)=$lb(xID,Code,Desc,DiagFlag,GCode,IsActive)
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

}

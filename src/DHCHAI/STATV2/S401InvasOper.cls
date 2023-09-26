/// 名称: DHCHAI.STATV2.S401InvasOper
/// 描述: 出院患者医院感染侵害性操作分布
/// 编写者：蒋朋朋
/// 编写日期: 2019-11-25
Class DHCHAI.STATV2.S401InvasOper Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-25
/// Description:  出院患者医院感染侵害性操作分布统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aStatDimens :  展示维度    
///               aLocIDs :    科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S401InvasOper","QryInvasOper","","2020-05-01","2020-07-13","W","1","AHGW","")
Query QryInvasOper(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,InfPatCnt:%Integer,InfCaseCnt:%Integer,InvDesc:%String,InfInvCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryInvasOperExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
	
	Set NIndex="QryInvasOper"
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
					Set PosFactsInfos=##class(DHCHAI.STATV2.S400InfFactor).GetINFFactInvInfo(xPaadm,AdmDate,DischDate,1)
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID) 
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						If (PosFactsInfos'="") {
							For xPosI = 1:1:$l(PosFactsInfos,"$") {
								Set PosFactsInfo = $p(PosFactsInfos,"$",xPosI)
								Continue:PosFactsInfo=""
								Set PosInfo = $p(PosFactsInfo,"#",1)
								Set InvInfo = $p(PosFactsInfo,"#",3)  // 侵害性操作
								For xInvI = 1:1:$l(InvInfo,"|") {
									Set Invs = $p(InvInfo,"|",xInvI)
									Continue:Invs=""
									Set InvDesc = $p(Invs,"^",2)
									//记录易感因素
									Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfInv",InvDesc))
								}
								If '$d(^TMP($zn,$j,NIndex,"InfAdm",DimensKey,xPaadm)) {			//去重判断使用
									Set ^TMP($zn,$j,NIndex,"InfAdm",DimensKey,xPaadm)=""
									Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"InfPat")) //感染人次
								}
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfCase")=+$g(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))+$L(PosInfo,"|")
							}
						}
					}
					If (LocCount>1) {
						For xPosI = 1:1:$l(PosFactsInfos,"$") {
							Set PosFactsInfo = $p(PosFactsInfos,"$",xPosI)
							Continue:PosFactsInfo=""
							Set PosInfo = $p(PosFactsInfo,"#",1)
							Set InvInfo = $p(PosFactsInfo,"#",3)  // 侵害性操作
							For xInvI = 1:1:$l(InvInfo,"|") {
								Set Invs = $p(InvInfo,"|",xInvI)
								Continue:Invs=""
								Set InvDesc = $p(Invs,"^",2)
								//记录侵害性操作
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfInv",InvDesc))
							}
							If '$d(^TMP($zn,$j,NIndex,"InfAdm","Sum",xPaadm)) {			//去重判断使用
								Set ^TMP($zn,$j,NIndex,"InfAdm","Sum",xPaadm)=""
								Set num = $i(^TMP($zn,$j,NIndex,"Sum","InfPat")) //感染人次
							}
							Set ^TMP($zn,$j,NIndex,"Sum","InfCase")=+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))+$L(PosInfo,"|")
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
/// CreatDate：   2020-05-12
/// Description:  医院感染易感因素统计-感染患者明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensType ：W -病区 E -科室(统计单位)
/// 			  aInvOper ：易感因素
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S401InvasOper","QryInfFactorDtl","","2020-01-01","2021-05-30","0001-00-0000-H-2","W","")
Query QryInfFactorDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aInvOper As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String,InvOpers:%String") [ SqlProc ]
{
}

ClassMethod QryInfFactorDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aInvOper As %String = "") As %Status
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
	Set NIndex="QryInfFactorDtl"
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
					//就诊开始结束日期
					Set AdmDate   = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes  = $lg(PAAdmData,38)   //就诊次数
					Set VisitStatus = $lg(PAAdmData,19)
					Continue:(VisitStatus="P")||(VisitStatus="C")
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
		                    Set InvOpers=##class(DHCHAI.STATV2.S400InvasOper).GetInvOpersByDiagID(DiagDr)
							Set:InvOpers'="" InvOpers=$p(InvOpers,"#",2)
							Continue:(aInvOper'="")&&(InvOpers'[aInvOper)
							
							Continue:$d(^TMP($zn,$j,NIndex,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"DiagDr",DiagDr)=""
							
							Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType,InvOpers)
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

ClassMethod QryInfFactorDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfFactorDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfFactorDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfFactorDtlExecute ]
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
/// Description:  获取患者感染报告中侵害性操作
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       侵害性操作
/// w ##class(DHCHAI.STATV2.S401InvasOper).GetInvasByRepID("1")
ClassMethod GetInvasByRepID(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:(aReportID="") return
	// Add by zhaoyj 2022-06-17 Global方式
	Set RepData = $g(^DHCHAI.IR.INFReportD(aReportID))
	Quit:RepData="" return
	Set InvasDescs=""
	Set xSub=0
	For {
		Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFInvOper","U"),aReportID,xSub))
		Quit:xSub=""
		
		Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(aReportID,"EXT",xSub))
		Continue:INFRepExtData=""
		Set DataID=$lg(INFRepExtData,3)
		Continue:DataID=""
		Set VasData = $g(^DHCHAI.IR.INFInvOperD(DataID))
		Continue:VasData=""
		Set IRInvOperDr=$lg(VasData,3)
		Continue:IRInvOperDr=""
		Set Invas = $lg($g(^DHCHAI.BT.InvasOperD(IRInvOperDr)),3)
		Set InvasDescs = InvasDescs_","_Invas
	}
	Set:InvasDescs'="" InvasDescs = $e(InvasDescs,2,$l(InvasDescs))
	Set:InvasDescs'="" return=InvasDescs
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-26
/// Description:  获取患者感染报告中侵害性操作
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       
/// w ##class(DHCHAI.STATV2.S401InvasOper).GetInvasOpers("4674","2018-10-16","2018-12-16")
ClassMethod GetInvasOpers(aEpisodeID, aDateFrom, aDateTo) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set (InfPosDescs,InvOperDescs)=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-17 Global方式
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:($lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3")
			
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DataID=$lg(INFRepExtData,3)
				Continue:DataID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DataID))
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
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				If (InfPos'=""){
					Set InfPosDescs = InfPosDescs_"|"_DataID_"^"_$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)
				}
			}
			Continue:InfPosDescs=""
			
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
					Set InvOperDescs = InvOperDescs_"|"_InvOperID_"^"_InvOperDesc
				}
			}
		}
	}
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InvOperDescs'="" InvOperDescs = $e(InvOperDescs,2,$l(InvOperDescs))
	Set return=InfPosDescs_"#"_InvOperDescs
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-11-26
/// Description:  查询侵害性操作字典
/// Table：       DHCHAI.BT.InvasOper
/// Input：       aActive是否有效
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S401InvasOper","QryInvOper","1")
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
		Set Code=$li(Data,2)
		Set Desc=$li(Data,3)
		Set IndNo=$li(Data,4)
		Set IsActive=$li(Data,5)
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

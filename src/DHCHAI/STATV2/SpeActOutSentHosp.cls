/// 名称: DHCHAI.STATV2.SpeActOutSentHosp
/// 描述: 提高住院患者治疗用药前送检率专项行动(2021)-哨点医院监测过程数据
/// 编写者：pylian
/// 编写日期: 2022-04-06
Class DHCHAI.STATV2.SpeActOutSentHosp Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2022-04-14	
/// Description:  科室列表(6.3)
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutSentHosp","QryDeptList","1","E")
Query QryDeptList(aHospIDs As %String, aLocType As %String = "") As %Query(ROWSPEC = "depCode:%String,depName:%String,icu:%String,newborn:%String") [ SqlProc ]
{
}

ClassMethod QryDeptListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
 
 	Set:aLocType'="W" aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryDeptList"
	Kill ^TMP($zn,$j,NIndex)
    
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
	    Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
	    
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			
			Set LocData=$g(^DHCHAI.BT.LocationD(xID))
			Continue:LocData=""
			Set Code=$lg(LocData,2)
			Set Desc=$lg(LocData,3)
			Set TypeDr =$lg(LocData,5)
			Continue:TypeDr=""
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(TypeDr))
			Continue:$lg(TypeData,2)'=aLocType
			Set CateDr =$lg(LocData,6)
			Continue:CateDr=""
			Set CateData=$g(^DHCHAI.BT.DictionaryD(CateDr))
			Continue:$lg(CateData,2)'="I"
			Set IsActive=$lg(LocData,14)
			Set IsICU=$lg(LocData,10)
			
			Set IsNICU=$lg(LocData,11)
			Set:(IsNICU'=1&&Desc["重症"&&Desc["新生儿") IsNICU=1
			Set:(IsNICU'=1&&IsICU'=1&&Desc["重症") IsICU=1
			
			Set Data=$lb(xID,Desc,IsICU,IsNICU)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		
		}
	}	  	

	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryDeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDeptListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDeptListExecute ]
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

/// Creator：     pylian    	
/// CreatDate：   2022-04-06	
/// Description:  出院患者列表(6.4)
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutSentHosp","QryinOutHosp","1","2020-05-01","2020-05-31","E")
Query QryinOutHosp(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Query(ROWSPEC = "zyid:%String,PatName:%String,PapmiNo:%String,visitId:%String,patientId:%String,sex:%String,birthDay:%String,inHospAt:%String,outHospAt:%String,outDeptId:%String,DishLocDesc:%String,inHospDig:%String,outDig:%String,otherDig:%String") [ SqlProc ]
{
}

ClassMethod QryinOutHospExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Status
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
    Set NIndex="QryinOutHosp"
	Kill ^TMP($zn,$j,NIndex)
    
    Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
  	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")	
		For xDishDate = aDateFrom:1:aDateTo{
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
					//add 20221116 处理错误数据问题(有出院日期就诊状态不为D)
				    Set VisitStatus = $lg(PAAdmData,19)
				    Continue:(VisitStatus="P")||(VisitStatus="C")
				    //add 20230207剔除测试患者
                    Set ExcFlg= ##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(xPaadm,ExAdmList)
                    Continue:ExcFlg=1

					// 出院科室/病区
					Set DishLocID = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set:(aLocType="W") DishLocID = DishWardID
				    //院区过滤
					Set LocData = $g(^DHCHAI.BT.LocationD(DishLocID))
					Set HospDr=$lg(LocData,8)
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					Set DishLocDesc = $lg(LocData,3)
				    //取出院科室对照
				    Continue:DishLocID=""
				    Set MapData="",ItemData="",ItemCode="",ItemDesc=""
				    Set MapID = $o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal","LocWard",DishLocID,0))
				    If (MapID'="") {
				    	Set MapData =$g(^CF.MA.HAI.MAP.MapDataD(MapID))
				    	Set ItemDr  = $lg(MapData,5)				    	
						If (ItemDr'=""){
							Set ItemData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
							Set ItemCode = $lg(ItemData,4)
							Set ItemDesc = $lg(ItemData,5)
						}
				    }
				    Set:ItemCode'="" DishLocID = ItemCode
				    Set:ItemDesc'="" DishLocDesc = ItemDesc
					//就诊开始结束日期
					Set AdmDate = $lg(PAAdmData,20)
					Set:AdmDate'="" AdmDate = $zd(AdmDate,3)
					Set AdmTime = $lg(PAAdmData,21)
					Set:AdmTime'="" AdmTime=$zt(AdmTime)
					
					Set DischDate = $lg(PAAdmData,26)
					Set:DischDate'="" DischDate = $zd(DischDate,3)
					Set DischTime = $lg(PAAdmData,27)
					Set:DischTime'="" DischTime=$zt(DischTime)
					Set AdmDateTime=AdmDate_" "_AdmTime
					Set DischDateTime=DischDate_" "_DischTime
					
					Set PapmiNo = $lg(PAAdmData,4)
					Set MrNo = $lg(PAAdmData,5)
					Set PatName = $lg(PAAdmData,6)
					Set Sex = $lg(PAAdmData,7)
					Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
					Set Birthday = $lg(PAAdmData,9)
					Set:Birthday'="" Birthday = $zd(Birthday,3)
					Set AdmTimes = $lg(PAAdmData,38)
					
					Set (AdmitDiag,OtherDiag,DischDiag)=""		// 入院诊断、其他诊断、出院诊断
					Set xDiagnosID = ""
					For {
						Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",xPaadm,xDiagnosID))
						Quit:xDiagnosID=""
						
						Set DiagInfo = $g(^DHCHAI.DP.MRDiagnosD(xDiagnosID))
						Continue:DiagInfo=""
						Continue:$lg(DiagInfo,13)'=1
						Continue:$lg(DiagInfo,10)'="C"  //临床诊断
						
						Set SCode	   = $lg(DiagInfo,11)
						Set ICD10  	   = $lg(DiagInfo,3)
						Set DiagDesc   = $lg(DiagInfo,4)
						Set DiagTpCode = $lg(DiagInfo,6)
						Set DiagTpDesc = $lg(DiagInfo,7)
						Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
						If DiagTypeMap'="" {
							Set DiagTpCode=$p(DiagTypeMap,"^",2)
							Set DiagTpDesc=$p(DiagTypeMap,"^",3)
						}
						
						If DiagTpDesc="入院诊断"{
							Set AdmitDiag = AdmitDiag_","_DiagDesc
						}Elseif DiagTpDesc="出院诊断"{
							Set DischDiag = DischDiag_","_DiagDesc
						}Else {
							Set OtherDiag = OtherDiag_","_DiagDesc
						}
					}
					Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
					Set:$l(AdmitDiag)>256 AdmitDiag=$e(AdmitDiag,1,256)
					Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
					Set:$l(DischDiag)>256 DischDiag=$e(DischDiag,1,256)
					Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
					Set:$l(OtherDiag)>256 OtherDiag=$e(OtherDiag,1,256)
	
					Set Data=$lb(xPaadm,PatName,PapmiNo,AdmTimes,MrNo,Sex,Birthday,AdmDateTime,DischDateTime,DishLocID,DishLocDesc,AdmitDiag,OtherDiag,DischDiag)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}	  	

	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryinOutHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryinOutHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryinOutHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryinOutHospExecute ]
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

/// Creator：     pylian    	
/// CreatDate：   2022-04-06	
/// Description:  感染信息列表(6.5)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutSentHosp","QryInfectList","1","2020-05-01","2020-05-31","E")
Query QryInfectList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Query(ROWSPEC = "zyid:%String,infectCode:%String,infectName:%String,infectDate:%String,conDate:%String,reportDate:%String,infectType:%String,infectDept:%String,interCode:%String") [ SqlProc ]
{
}

ClassMethod QryInfectListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Status
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
    Set NIndex="QryInfectList"
	Kill ^TMP($zn,$j,NIndex)

    Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
  	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")	
		For xDishDate = aDateFrom:1:aDateTo{
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
					//add 20221116 处理错误数据问题(有出院日期就诊状态不为D)
				    Set VisitStatus = $lg(PAAdmData,19)
				    Continue:(VisitStatus="P")||(VisitStatus="C")
				    //add 20230207剔除测试患者
                    Set ExcFlg= ##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(xPaadm,ExAdmList)
                    Continue:ExcFlg=1
	    			// 出院科室/病区
					Set DishLocID = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set:(aLocType="W") DishLocID = DishWardID
				    //院区过滤
					Set LocData = $g(^DHCHAI.BT.LocationD(DishLocID))
					Set HospDr=$lg(LocData,8)
					Continue:(aHospIDs'="")&($lf(aHospIDs,HospDr)<0)
	    			
					Set xID = ""
					For {
						Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,"1",xID))
						Quit:xID=""
						
						Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
						Quit:'$IsObject(objINFRep)
						Set RepStatus=objINFRep.IRStatusDr
						Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
						Continue:RepStatus.BTCode'="3"
						//报告日期
						Set RepDate=objINFRep.IRRepDate
						Set RepTime=objINFRep.IRRepTime
						Set:RepDate'="" RepDate=$zd(RepDate,3)
						Set:RepTime'="" RepTime=$zt(RepTime)
						Set RepDateTime=RepDate_" "_RepTime
						
						// 感染诊断信息
						Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
						For indx = 1:1:$l(LinkDiags,",") {
							Set xDiagID = $p(LinkDiags,",",indx)
							Continue:xDiagID=""
							
							Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
							Continue:'$IsObject(objDiags)
							Continue:'$IsObject(objDiags.IRInfPosDr)
							// 感染日期
							Set InfDate  = objDiags.IRInfDate
							Set InfType = objDiags.IRInfType
							Set InfType=$s(InfType=0:2,1:1)
							
							// 感染诊断
							Set PosCode = objDiags.IRInfPosDr.BTCode
							Set PosDesc = objDiags.IRInfPosDr.BTDesc
							
							//取感染诊断对照
							Continue:PosCode=""
						    Set MapData="",ItemData="",ItemCode="",ItemDesc=""
						    Set MapID = $o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal","InfPos",PosCode,0))
						    If (MapID'="") {
						    	Set MapData =$g(^CF.MA.HAI.MAP.MapDataD(MapID))
						    	Set ItemDr  = $lg(MapData,5)				    	
								If (ItemDr'=""){
									Set ItemData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
									Set ItemCode = $lg(ItemData,4)
									Set ItemDesc = $lg(ItemData,5)
								}
						    }
							Set:ItemCode'="" PosCode= ItemCode
							Set:ItemDesc'="" PosDesc= ItemDesc
							
							Set ActDate="", ActTime=""
							Set xScreenID=""
						   	For {
							   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID))
							   	Quit:xScreenID=""
							   	Quit:(ActDate'="")&(ActTime'="")
							   	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
								Continue:'$IsObject(objScreen)
								Continue:'$IsObject(objScreen.CSItmScreenDr)
								
								Set xSubID=""
						   		For {
							   		Set xSubID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID,xSubID))
							   		Quit:xSubID=""
							   	   
							   		Set xID =xScreenID_"||"_xSubID
							   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
									Continue:'$IsObject(objScreenDtl)
									Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
									Continue:(objScreen.CSStatus'=1)		
									
									Set ActDate=objScreen.CSActDate
									Set ActTime=objScreen.CSActDate
									Quit
						   		}
						   	}
	   	                    Set:ActDate'="" ActDate=$zd(ActDate,3)
	   	                    Set:ActTime'="" ActTime=$zt(ActTime)
	   	                    Set ActDateTime=ActDate_" "_ActTime
	   	                    
							//感染科室
							Set InfLocID=""
							If $IsObject(objDiags.IRInfLocDr) {
								Set InfLocID=objDiags.IRInfLocDr.%Id()   
							}
							If (InfLocID="") {
								Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xPaadm,InfDate,"00:00:01")								
								Set InfLocID=$p(LocInfo,"^",1)   //所在科室
								If (aLocType="W") {
									Set InfLocID=$p(LocInfo,"^",5)   //所在病区
								}
							}
							//取感染科室对照 （住院患者的感染科室编码，参考表1，现在不确定是什么，先做对照）
							Continue:InfLocID=""
						    Set MapLocData="",ItemLocData="",ItemLocCode="",ItemLocDesc=""
						    Set MapLocID = $o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal","LocWard",InfLocID,0))
						    If (MapLocID'="") {
						    	Set MapLocData =$g(^CF.MA.HAI.MAP.MapDataD(MapLocID))
						    	Set ItemDr  = $lg(MapData,5)				    	
								If (ItemDr'=""){
									Set ItemLocData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
									Set ItemLocCode = $lg(ItemLocData,4)
									Set ItemLocDesc = $lg(ItemLocData,5)
								}
						    }
						    Set:ItemLocCode'="" InfLocID = ItemLocCode
							
							Set:InfDate'="" InfDate=$zd(InfDate,3)
							Set InfDateTime=InfDate_" "_"00:00:01"
							
							Set Data=$lb(xPaadm,PosCode,PosDesc,InfDateTime,ActDateTime,RepDateTime,InfType,InfLocID,xDiagID)
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

ClassMethod QryInfectListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfectListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfectListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfectListExecute ]
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

/// Creator：     pylian    	
/// CreatDate：   2022-04-06	
/// Description:  送检信息列表(6.6)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.LabVisitNumber
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutSentHosp","QryInspecteList","1","2020-05-01","2020-05-31","E")
Query QryInspecteList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Query(ROWSPEC = "zyid:%String,testNo:%String,typeCode:%String,typeName:%String,sourceName:%String,itemCode:%String,itemName:%String,submitAt:%String,infectId:%String,interCode:%String") [ SqlProc ]
{
}

ClassMethod QryInspecteListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Status
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
    Set NIndex="QryInspecteList"
	Kill ^TMP($zn,$j,NIndex)

    Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
  	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")	
		For xDishDate = aDateFrom:1:aDateTo{
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
					//add 20221116 处理错误数据问题(有出院日期就诊状态不为D)
				    Set VisitStatus = $lg(PAAdmData,19)
				    Continue:(VisitStatus="P")||(VisitStatus="C")
				    //add 20230207剔除测试患者
                    Set ExcFlg= ##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(xPaadm,ExAdmList)
                    Continue:ExcFlg=1
	    			// 出院科室/病区
					Set DishLocID = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set:(aLocType="W") DishLocID = DishWardID
				    //院区过滤
					Set LocData = $g(^DHCHAI.BT.LocationD(DishLocID))
					Set HospDr=$lg(LocData,8)
					Continue:(aHospIDs'="")&($lf(aHospIDs,HospDr)<0)

	    			Set xVisitNumberDr=""
					For {
						Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",xPaadm,xVisitNumberDr))
						Quit:xVisitNumberDr=""
						Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
						Continue:VisitData=""
						Set LabIsActive		=$lg(VisitData,18)
						Continue:LabIsActive'=1
						
						Set SCode 			=$lg(VisitData,14)
						Set CollDate 		=$lg(VisitData,8)				//采集日期
						Set CollTime		=$lg(VisitData,9)				//采集时间
						Set EpisodeNo		=$lg(VisitData,3)   			//标本号
						Set RecDate 		=$lg(VisitData,11)				//接收日期
						Set RecTime 		=$lg(VisitData,12)				//接收时间
						Set Specimen 		=$lg(VisitData,6)
						//采集日期不为空以采集日期为准
						Set:CollDate="" CollDate=RecDate
						Set:CollTime="" CollTime=RecTime				
						Set:CollDate'="" CollDate=$zd(CollDate,3)
						Set:CollTime'="" CollTime=$zt(CollTime)
						Set CollDateTime=CollDate_" "_CollTime
						
						
						//取标本对照
						Continue:Specimen=""
					    Set MapData="",ItemData="",SpeCode="",SpeDesc="",ItemCode="",ItemDesc=""
					    Set MapID = $o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal","LabSpecimen",Specimen,0))
					    If (MapID'="") {
					    	Set MapData =$g(^CF.MA.HAI.MAP.MapDataD(MapID))
					    	Set ItemDr  = $lg(MapData,5)				    	
							If (ItemDr'=""){
								Set ItemData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
								Set ItemCode = $lg(ItemData,4)
								Set ItemDesc = $lg(ItemData,5)
							}
					    }
					    Set:ItemCode'="" SpeCode = ItemCode
					    Set:ItemDesc'="" SpeDesc = ItemDesc
					    				
					    Set TestSet="",MapTestCode="",MapTestSet=""
						Set xTestSetDesc = "",CheckFlg=0
						For {
							Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
							Quit:xTestSetDesc=""
							Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,0))
							If (TestSetMapID'=""){
								Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
								Continue:TestSetMapData=""
								Continue:'$lg(TestSetMapData,7) 		//无效判断
								Set TSMapItemDr=$lg(TestSetMapData,4)
								Continue:TSMapItemDr=""
								Set LabTestSetData=$g(^DHCHAI.DP.LabTestSetD(TSMapItemDr))
								Continue:LabTestSetData=""
								Set IsSubItem=$lg(LabTestSetData,7)
								Continue:IsSubItem'=1
								Set MapTestCode=$lg(LabTestSetData,2)
								Set MapTestSet=$lg(LabTestSetData,3)
								Set TestSet=xTestSetDesc								
								Set CheckFlg = 1
								Quit				
							}
						}
						
						If (CheckFlg=0) {  //检查检验项目是否存在于检验结果中
							Set xTestSetDr=""
							For {
								Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
								Quit:xTestSetDr=""
								Quit:CheckFlg=1
								
								//最新检验报告
								Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
								Quit:xOrder=""
								Set xVisitReportDr=0
								For {
									Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
									Quit:xVisitReportDr=""
									Quit:CheckFlg=1
									
									Set xTestCode=""
									For {
										Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
										Quit:xTestCode=""
										Quit:CheckFlg=1
									
										Set xMapItemDr=0
										For {
											Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
											Quit:xMapItemDr=""
											
											Set LabTestSetData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
											Continue:LabTestSetData=""
											Set IsSubItem=$lg(LabTestSetData,7)
											Continue:IsSubItem'=1
											Set MapTestCode=$lg(LabTestSetData,2)
											Set MapTestSet=$lg(LabTestSetData,3)
											
											Set TestSetData=$g(^DHCHAI.DP.LabVisitTestSetD(xTestSetDr))
											Set TestSet=$lg(TestSetData,3)
											Set CheckFlg = 1
											Quit										
										}
									}
								}
							}
						}
						Continue:CheckFlg=0	//过滤非指定类型的送检
						
						//取检验(医嘱)项目对照
						Continue:MapTestCode=""
					    Set MapTestData="",ItemTestData="",ItemTestCode="",ItemTestDesc=""
					    Set MapTestID = $o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal","LabTestSet",MapTestCode,0))
					    If (MapTestID'="") {
					    	Set MapTestData =$g(^CF.MA.HAI.MAP.MapDataD(MapTestID))
					    	Set ItemDr  = $lg(MapTestData,5)				    	
							If (ItemDr'=""){
								Set ItemTestData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
								Set ItemTestCode = $lg(ItemTestData,4)
								Set ItemTestDesc = $lg(ItemTestData,5)
							}
					    }
					    Set:ItemTestCode'="" MapTestCode = ItemTestCode
					    Set:ItemTestDesc'="" MapTestSet = ItemTestDesc				
						
						//感染送检  感染表(infectList)中 interCode 字段值，关联此次送检的感染诊断
						Set DiagID=""
						Set xID = ""
						For {
							Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,"1",xID))
							Quit:xID=""
							
							Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
							Quit:'$IsObject(objINFRep)
							Set RepStatus=objINFRep.IRStatusDr
							Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
							Continue:RepStatus.BTCode'="3"
							
							// 送检信息
							Set LinkLabs = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
							Continue:LinkLabs=""
							Set LabFlg=0
							For indx = 1:1:$l(LinkLabs,",") {
								Set xLabID = $p(LinkLabs,",",indx)
								Continue:xLabID=""
							    
							    Set LabInfo=$g(^DHCHAI.IR.INFLabD(xLabID))
							    Continue:LabInfo=""
							    Set LabRepDr=$lg(LabInfo,3)
							    Continue:LabRepDr=""
							    Set LabRepData=$g(^DHCHAI.DP.LabVisitReportD(LabRepDr))
							    Continue:LabRepData=""
							    Set VisitNumberDr=$lg(LabRepData,2)
							    Continue:VisitNumberDr'=xVisitNumberDr
							    Set LabFlg=1
							    Quit
							}
							Continue:LabFlg'=1
							
							// 感染诊断信息
							Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
							For indy = 1:1:$l(LinkDiags,",") {
								Set xDiagID = $p(LinkDiags,",",indy)
								Continue:xDiagID=""					    
							    Set DiagID =xDiagID
							}
						}
					
						Set Data=$lb(xPaadm,EpisodeNo,MapTestCode,MapTestSet,TestSet,SpeCode,SpeDesc,CollDateTime,DiagID,xVisitNumberDr)
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

ClassMethod QryInspecteListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInspecteListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInspecteListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInspecteListExecute ]
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

/// Creator：     pylian    	
/// CreatDate：   2022-04-06	
/// Description:  抗菌药物使用信息列表(6.7)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutSentHosp","QryAntibiList","1","2020-05-01","2020-05-31","E")
Query QryAntibiList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Query(ROWSPEC = "zyid:%String,orderAt:%String,stopAt:%String,orderId:%String,orderName:%String,routeId:%String,usePurpose:%String,drugLine:%String,interCode:%String,execAt:%String") [ SqlProc ]
{
}

ClassMethod QryAntibiListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "") As %Status
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
    Set NIndex="QryAntibiList"
	Kill ^TMP($zn,$j,NIndex)

    Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")    
  	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")	
		For xDishDate = aDateFrom:1:aDateTo{
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
					//add 20221116 处理错误数据问题(有出院日期就诊状态不为D)
				    Set VisitStatus = $lg(PAAdmData,19)
				    Continue:(VisitStatus="P")||(VisitStatus="C")
				    //add 20230207剔除测试患者
                    Set ExcFlg= ##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(xPaadm,ExAdmList)
                    Continue:ExcFlg=1
	    	    	// 出院科室/病区
					Set DishLocID = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set:(aLocType="W") DishLocID = DishWardID
				    //院区过滤
					Set LocData = $g(^DHCHAI.BT.LocationD(DishLocID))
					Set HospDr=$lg(LocData,8)
					Continue:(aHospIDs'="")&($lf(aHospIDs,HospDr)<0)
	    
					Set xScode = ""
					For {
						Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xPaadm,xScode))
						Quit:xScode=""
						
						Set xSttDate = ""
						For {
							Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xPaadm,xScode,1,xSttDate))
							Quit:xSttDate=""
							
							Set xOrdItemID =""
							For {
								Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",xPaadm,xScode,1,xSttDate,xOrdItemID))
								Quit:xOrdItemID=""
						
								Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
								Continue:$lg(OEOrdItemData,25)=0
	            
					 	        Set SCode   = $li(OEOrdItemData,28)
					           	Set OrdDesc = $li(OEOrdItemData,4)	
					           	Continue:OrdDesc=""
				                Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
								Continue:AntiMapID=""
							    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
							    Continue:$lg(AntiMapData,7)'=1   //add 20221122 过滤抗菌药物对照置无效的药物
							    						  
					           	//取抗菌药物对照
						    	Set MapAntData="",AntiMastData="",AntiMapCode="",AntiMapDesc=""
							    Set MapAntID = $o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal","OEAntiMast",OrdDesc,0))
							    If (MapAntID'="") {
							    	Set MapAntData =$g(^CF.MA.HAI.MAP.MapDataD(MapAntID))
							    	Set ItemDr  = $lg(MapAntData,5)				    	
									If (ItemDr'=""){
										Set AntiMastData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
										Set AntiMapCode = $lg(AntiMastData,4)
										Set AntiMapDesc = $lg(AntiMastData,5)
									}
							    }
							  	Continue:(AntiMapCode="")||(AntiMapDesc="")		               
					            Set Priority = $lg(OEOrdItemData,8)	//医嘱类型		
								Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
								Continue:PriorityMap=""
								Continue:PriorityMap="OUT"
								
				                Set Instruc = $lg(OEOrdItemData,20) //给药途径（不过滤非全身用药）
				   			    //取给药途径对照
				   			    Continue:Instruc=""
							    Set MapData="",ItemData="",ItemCode="",ItemDesc=""
							    Set MapID = $o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal","AntiAdminRoute",Instruc,0))
							    If (MapID'="") {
							    	Set MapData =$g(^CF.MA.HAI.MAP.MapDataD(MapID))
							    	Set ItemDr  = $lg(MapData,5)				    	
									If (ItemDr'=""){
										Set ItemData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
										Set ItemCode = $lg(ItemData,4)
										Set ItemDesc = $lg(ItemData,5)
									}
							    }
							    Set:ItemCode'="" Instruc = ItemCode
                                
                                //用药目的
								Set UsePurpose = $lg(OEOrdItemData,30)
								Continue:UsePurpose=""
								Set UsePuCode=1
								Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
								Set UsePurpose = $p(UsePurposeMapStr,"^",3)
				                Set:UsePurpose["治疗" UsePuCode=2
				                //限制级别
				                Set DrgPoCode=""
								Set DrgPoison = $lg(OEOrdItemData,29) //抗菌用药等级
								If (DrgPoison["KSS") {
									Set DrgPoCode=$s(DrgPoison="KSS1":1,DrgPoison="KSS2":2,DrgPoison="KSS3":3)
								}Else {
									Set DrgPoCode=$s(DrgPoison["非限制":1,DrgPoison["特殊":3,1:2)
								}
								
								Set OrdItemID = $lg(OEOrdItemData,24)							
								Set Generic = $lg(OEOrdItemData,19)
								Set OrdDate = $lg(OEOrdItemData,10)   //开医嘱日期
								Set:OrdDate'="" OrdDate=$zd(OrdDate,3)
								Set OrdTime = $lg(OEOrdItemData,11) 
								Set:OrdTime'="" OrdTime=$zt(OrdTime)								
								Set SttDate = $lg(OEOrdItemData,15)   //医嘱开始日期
								Set:SttDate'="" SttDate=$zd(SttDate,3)
					            Set SttTime = $lg(OEOrdItemData,16)
					            Set:SttTime'="" SttTime=$zt(SttTime)
								If PriorityMap="N" {    //临时医嘱
									Set EndDate = SttDate
									Set EndTime	= SttTime
								}Else {
									Set EndDate = $lg(OEOrdItemData,17)  //停医嘱日期
									Set:EndDate'="" EndDate=$zd(EndDate,3)
									Set EndTime	= $lg(OEOrdItemData,18)	
									Set:EndTime'="" EndTime=$zt(EndTime)
								}
								  
							    Set OrdDateTime=OrdDate_" "_OrdTime
					            Set SttDateTime=SttDate_" "_SttTime
					         	Set EndDateTime=EndDate_" "_EndTime
							
								Set Data=$lb(xPaadm,OrdDateTime,EndDateTime,AntiMapCode,AntiMapDesc,Instruc,UsePuCode,DrgPoCode,OrdItemID,SttDateTime)
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1
							}
						}
					}					
				}
			}
		}
    }	  	

	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntibiListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntibiListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntibiListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntibiListExecute ]
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

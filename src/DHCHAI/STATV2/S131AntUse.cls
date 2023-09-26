/// 名称: DHCHAI.STATV2.S131AntUse
/// 描述: 出院患者抗菌药物使用率统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S131AntUse Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-18
/// Description:  出院患者抗菌药物使用率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aQryCon：  有效数据筛查
///               aStatDimens:  展示维度    
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S131AntUse","QryOutPatAntUse","1","2020-05-01","2020-05-30","W",2,"","")
Query QryOutPatAntUse(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatDishCnt:%Integer,UseAntiCnt:%Integer,UseAntiRatio:%String") [ SqlProc ]
{
}

ClassMethod QryOutPatAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
	
    Set NIndex="QryOutPatAntUse"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
    //科室合计住院人数、抗菌药物使用人数
    Set PatDishSum="",UseAntiSum=""
    Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")    //只统计住院患者
		
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
					Set DishLocID = $li(PAAdmData,28)
				    Set DishWardID = $li(PAAdmData,29)
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
					
					//就诊开始结束日期
					Set AdmDate = $li(PAAdmData,20)
					Set DischDate = $li(PAAdmData,26)
					
					//获取抗菌药物使用信息
					Set AntUseFlg=0
					Set AntUseArr =..GetAntUseInfo(xPaadm,AdmDate,DischDate)	
					Set:AntUseArr.Count()>0 AntUseFlg=1
					
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID)  
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// 全院出院患者人数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatDish",xPaadm))
						{
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatDish"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatDish",xPaadm)=""
						}
						//使用抗菌药物人数
						If (AntUseFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseAnti",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"UseAnti"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"UseAnti",xPaadm)=""
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
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))

		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Continue:xDimensKey=""
		Set PatDishCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatDish"))  		//出院患者数
		Set UseAntiCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseAnti"))  		//抗感染药使用人数
		Set UseAntiRatio="0.00%"
		Set:PatDishCnt>0 UseAntiRatio=$fn((UseAntiCnt/PatDishCnt)*100,"",2)_"%" //Anti使用率
		
		Continue:(IsActive="0")&&(PatDishCnt=0)	
		Continue:(aQryCon="2")&&(UseAntiCnt=0)
		Continue:(aQryCon="3")&&(PatDishCnt=0)
		
		If (LocCount>1) {
			Set PatDishSum=PatDishSum+PatDishCnt
			Set UseAntiSum=UseAntiSum+UseAntiCnt
		}
	
		Set Data=$lb(xDimensKey,DimensDesc,PatDishCnt,UseAntiCnt,UseAntiRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	//出院患者住院人数及抗菌药物使用人数可以直接累加
	If (LocCount>1) {
		Set PatDishCnt  =PatDishSum  		    //出院患者数
		Set UseAntiCnt  =UseAntiSum 		    //抗感染药使用人数
		Set UseAntiRatio="0.00%"
		Set:PatDishCnt>0 UseAntiRatio=$fn((UseAntiCnt/PatDishCnt)*100,"",2)_"%" 	//Anti使用率
		
		Set Data=$lb("","全部",PatDishCnt,UseAntiCnt,UseAntiRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  		  	
   
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOutPatAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutPatAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutPatAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutPatAntUseExecute ]
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

/// Creator：     zhugz
/// CreatDate：   2019-11-18
/// Description:  出院患者抗菌药物使用率分母明细表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220922 解决汇总按科室分组统计明细无法区分医院问题     
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：  维度信息
///               aStaType :  科室类型
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC 按患者就诊记录输出
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S131AntUse","QryOutPatDtl","1","2020-06-01","2020-06-30","0001-07-0051-W-4","W","")
Query QryOutPatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,AntUseFlg:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryOutPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Status
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
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
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

					//就诊开始结束日期
					Set AdmDate = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes = $lg(PAAdmData,38)   //就诊次数

					// 出院科室/病区
					Set DishLocID = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set LocDr=DishLocID
				    Set:aStaType="W" LocDr=DishWardID
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
					//获取抗菌药物使用信息,并输出
					Set AntUseFlg=""
					Set AntUseArr =..GetAntUseInfo(xPaadm,AdmDate,DischDate)  
					Set:AntUseArr.Count()>0 AntUseFlg="是"
					
					Set TransInfoArr =..GetTransInfo(xPaadm,"","",aStaType)    //存在转科日期早于入院日期情况，取全部转科记录
					For TransInd=1:1:TransInfoArr.Count(){
						Set TransInfo=TransInfoArr.GetAt(TransInd)

						Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(AntUseFlg)_TransInfo	
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryOutPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutPatDtlExecute ]
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

/// Creator：     zhugz
/// CreatDate：   2019-11-18
/// Description:  出院患者抗菌药物使用率明细(分子)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220922 解决汇总按科室分组统计明细无法区分医院问题
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey： 维度信息
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC  按患者医嘱记录输出
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S131AntUse","QryAntUseDtl","","2020-05-01","2020-05-31","0001-07-0027-W-4","W","")
Query QryAntUseDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,OrdID:%Integer,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Status
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
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
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
				
					//就诊开始结束日期
					Set AdmDate = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
	            	Set AdmTimes = $lg(PAAdmData,38)   //就诊次数

					// 出院科室/病区
					Set DishLocID = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Set LocDr=DishLocID
				    Set:aStaType="W" LocDr=DishWardID
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

					Set TransInfoArr =..GetTransInfo(xPaadm,"","",aStaType)  //存在转科日期早于入院日期情况，取全部转科记录
					For TransInd=1:1:TransInfoArr.Count(){
						Set TransInfo=TransInfoArr.GetAt(TransInd)
						Set TransID=$lg(TransInfo,1)
					    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
					    Set TransDate	= $li(TranData,7)
					    Set OutLocDate	= $li(TranData,10)
					    Set TransTime	= $li(TranData,8)
						Set OutLocTime	= $li(TranData,11)

						//获取抗菌药物使用信息,并输出
						Set AntUseArr =..GetAntUseInfo(xPaadm,TransDate,OutLocDate)
						For AntInd=1:1:AntUseArr.Count(){
							Set OrderInfo=AntUseArr.GetAt(AntInd)
							//抗菌药物级别英文转化为中文
							Set DrgPoison  = $li(OrderInfo,13)
							Set:DrgPoison="KSS1" DrgPoison="非限制使用级"
							Set:DrgPoison="KSS2" DrgPoison="限制使用级"
							Set:DrgPoison="KSS3" DrgPoison="特殊使用级"
							Set $li(OrderInfo,13)=DrgPoison
						    //日期类型转化]
						    Set OrdDateTime  = $li(OrderInfo,6)
							Set SttDateTime  = $li(OrderInfo,7)
							Set EndDateTime  = $li(OrderInfo,10)
							Set OrdDate=$p(OrdDateTime," ",1)
							Set OrdTime=$p(OrdDateTime," ",2)
							Set SttDate=$p(SttDateTime," ",1)
							Set SttTime=$p(SttDateTime," ",2)
							Set EndDate=$p(EndDateTime," ",1)
							Set EndTime=$p(EndDateTime," ",2)
							Set:OrdDate'="" OrdDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
							Set:SttDate'="" SttDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
							Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
							Set:OrdTime'="" OrdTime=$zt(OrdTime)
					        Set:SttTime'="" SttTime=$zt(SttTime)
						    Set:EndTime'="" EndTime=$zt(EndTime)
						    Set OrdDateTime =OrdDate_" "_OrdTime
					    	Set SttDateTime =SttDate_" "_SttTime
							Set EndDateTime =EndDate_" "_EndTime
							Set $li(OrderInfo,6)=OrdDateTime
							Set $li(OrderInfo,7)=SttDateTime
							Set $li(OrderInfo,10)=EndDateTime
							
							Set OrdItemID=$lg(OrderInfo,1)
							Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
							//取医师类型
							Set OrdDocDesc =$lg(OrdItemData,14)  //ID|Code|Desc
							Set OEDocDr=""
							Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
							Set CarPrvTpId="",CarPrvTpDesc=""
							Set:OEDocDr'="" CarPrvTpId=$p(^CTPCP(OEDocDr,1),"^",4)	//CTCarPrvTp
							Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)
		                    Set OrderInfo=OrderInfo_$lb(CarPrvTpDesc)
		                  
							Set Data = $lb(DimensDesc,AdmTimes)_PatData_OrderInfo_TransInfo
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
				
					}
				}
				
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseDtlExecute ]
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

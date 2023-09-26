/// 名称: DHCHAI.STATV2.SpeActOutInfSub
/// 描述: 提高住院患者治疗用药前送检率专项行动(2021)-哨点医院监测统计二
/// 编写者：pylian
/// 编写日期: 2022-04-15
Class DHCHAI.STATV2.SpeActOutInfSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2022-04-15	
/// Description:  出院患者医院感染诊断相关病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
///               aStatDimens:  展示维度    //add 20221012 
///               aLocIDs:    科室  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutInfSub","QryInfSub","1|2","2020-05-01","2021-12-01","W","1,2,9","","G","33,31,29,27")
Query QryInfSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aLabTestSet As %Text = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,InfPatCnt:%Integer,InfSubCnt:%Integer,InfSubRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfSubExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aLabTestSet As %Text = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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

    Set NIndex="QryInfSub"
	Kill ^TMP($zn,$j,NIndex)
    
    Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")

   	//科室合计出院人数、感染人数、送检人数
    Set PatDishSum="",InfPatSum=0,InfSubSum=0
    //同期出院
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
					Set AdmDate = $lg(PAAdmData,20)
					Set AdmTime = $lg(PAAdmData,21)
					Set DischDate = $lg(PAAdmData,26)
					Set DischTime = $lg(PAAdmData,27)

					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID)
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// 住院患者人数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm)=""
						}
						// 全院科室患者
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",xPaadm)) {
							// 科室患者
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",xPaadm)=""
							// 科室患者感染
							Set InfPosInfo=##class(DHCHAI.STATV2.SpeActOutInfSub).GetInfInfo(xPaadm)
							If (InfPosInfo'="") {
								If ('$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",xPaadm))) {
									Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",xPaadm)=""												
									Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
								}
								For indPos=1:1:$l(InfPosInfo,"|") {
									Set tmpInfPos = $p(InfPosInfo,"|",indPos)
									Set DiagID    = $p(tmpInfPos,"^",1)
							
									//病原学送检是否考虑送检科室与感染科室
									Set SubLabInfo=##class(DHCHAI.STATV2.SpeActInfSub).GetInfLabInfo(xPaadm,AdmDate,DischDate,aLabTestSet,DiagID)
									Continue:SubLabInfo.Count()<1
									If ('$d(^TMP($zn,$j,NIndex,DimensKey,"InfSub",xPaadm))) {
										Set ^TMP($zn,$j,NIndex,DimensKey,"InfSub",xPaadm)=""												
										Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfSub"))
									}							
								}
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
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//出院患者数
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  		    //新发感染人数
		Set InfSubCnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfSub"))		    //送检人数
		Set InfSubRatio="0.00%"
		Set:InfSubCnt>0 InfSubRatio=$fn((InfSubCnt/InfPatCnt)*100,"",2)_"%" 	//感染送检率
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(InfSubCnt=0)
		Continue:(aQryCon="3")&&(InfPatCnt=0)
		
		If (LocCount>1) {  //科室合计累加
			Set PatDishSum=PatDishSum+PatAdmCnt
			Set InfPatSum=InfPatSum+InfPatCnt
			Set InfSubSum=InfSubSum+InfSubCnt
		}		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InfPatCnt,InfSubCnt,InfSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  
		
	//出院患者住院人数及感染人数可以直接累加
	If (LocCount>1) {   //科室合计
		Set PatAdmCnt  =PatDishSum  			//出院患者数
		Set InfPatCnt  =InfPatSum 		        //新发感染人数
		Set InfSubCnt  =InfSubSum  	            //送检人数		
		Set InfSubRatio="0.00%"
		Set:InfSubCnt>0 InfSubRatio=$fn((InfSubCnt/InfPatCnt)*100,"",2)_"%" 	//感染送检率
		
		Set Data=$lb("","全部",PatAdmCnt,InfPatCnt,InfSubCnt,InfSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  		  	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfSubExecute ]
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
/// CreatDate：   2022-04-15	
/// Description:  医院感染诊断相关病原学送检率明细表(医院感染、病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   //add 2022012 解决汇总按科室分组统计明细无法区分医院问题
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
/// 			  IsBfCureSubmiss:是否病原学送检
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutInfSub","QryInfSubDtl","1","2020-05-01","2021-12-31","0000-00-0000-A-1","W","1","1,18,22,9,19,20,21,23,24,25,26,27,28,29","")
Query QryInfSubDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsInfSub As %String = 0, aLabTestSet As %Text = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String,InfLocDesc:%String,VisitNumberID:%Integer,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String") [ SqlProc ]
{
}

ClassMethod QryInfSubDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsInfSub As %String = 0, aLabTestSet As %Text = "", aLocIDs As %Text = "") As %Status
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
 	Set aLocType = aStaType	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")

  	Set NIndex="QryInfSubDtl"
	Kill ^TMP($zn,$j,NIndex)

    //出院患者
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
					Set AdmTime = $lg(PAAdmData,21)
					Set DischDate = $lg(PAAdmData,26)
					Set DischTime = $lg(PAAdmData,27)
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
					
					// 患者感染
					Set InfPosInfo=##class(DHCHAI.STATV2.SpeActOutInfSub).GetInfInfo(xPaadm)
					Continue:(InfPosInfo="") 
					For indPos=1:1:$l(InfPosInfo,"|") {
						Set tmpInfPos   = $p(InfPosInfo,"|",indPos)
						Set DiagID    	= $p(tmpInfPos,"^",1)
						Set InfPosDesc  = $p(tmpInfPos,"^",2)
						Set InfDate		= $p(tmpInfPos,"^",3)
						Set InfXDate	= $p(tmpInfPos,"^",4)
						Set InfEffect   = $p(tmpInfPos,"^",5)
						Set InfType		= $p(tmpInfPos,"^",7)
						Set InfLocDesc  = $p(tmpInfPos,"^",8)			
						Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
						Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
						
						Set InfInfo=$lb(DiagID,InfPosDesc,InfType,InfDate,InfEffect,InfXDate,InfLocDesc)
					    
						If (aIsInfSub=1) {    //病原学送检	
							Set (LabInfos,InfPosInfos)=""
							Set SubLabArr=##class(DHCHAI.STATV2.SpeActInfSub).GetInfLabInfo(xPaadm,AdmDate,DischDate,aLabTestSet,DiagID)  //病原学送检
							Continue:SubLabArr.Count()<1
							For indLab=1:1:SubLabArr.Count() {
								Set SubLabInfo=SubLabArr.GetAt(indLab)	
								Continue:SubLabInfo=""
								Set VisitNumberID = $lg(SubLabInfo,1)
								Set EpisodeNo	  = $lg(SubLabInfo,2)
								Set CollDate 	  = $lg(SubLabInfo,3)
								Set CollTime	  = $lg(SubLabInfo,4)
								Set Specimen      = $lg(SubLabInfo,5)
								Set TestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",VisitNumberID,""))
					
								Set:CollDate'="" CollDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
							    Set:CollTime'="" CollTime=$zt(CollTime)
					            Set CollDateTime=CollDate_" "_CollTime
					            
				                If '$d(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID)) {  //存在只送检未报告情况 
				          			Set LabInfo=$lb(VisitNumberID,EpisodeNo,CollDateTime,"",TestSetDesc,Specimen,"","","")			            
				               		Set LabInfos=LabInfos_$lb(LabInfo)			            
				                } Else {
						            Set xTestSetDr=""
									For {
										Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,xTestSetDr))
										Quit:xTestSetDr=""
									 
										//最新检验报告
										Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,xTestSetDr,""),-1)
										Quit:xOrder=""
								
										Set xVisitReportDr=0
										For {
											Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,xTestSetDr,xOrder,xVisitReportDr))
											Quit:xVisitReportDr=""
											
											Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xVisitReportDr))
											Continue:LabReportData=""
											Set RepDate = $lg(LabReportData,10)
											Set RepTime = $lg(LabReportData,11)
											
											Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
								    		Set:RepTime'="" RepTime=$zt(RepTime)
						           		 	Set RepDateTime=RepDate_" "_RepTime
						           		 	Set LabSCode = $lg(LabReportData,14)
						           		 	Set LabReportID = $lg(LabReportData,3)
						           		 	Set LabTestSetDr= $lg(LabReportData,13)
						           		 	Continue:LabTestSetDr=""
						           		 	Set LabVisitTestSet =$g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetDr))
						           		 	Set LabTestSetDesc =$lg(LabVisitTestSet,3)
						           		 	
						           		 	//取细菌检验结果
						           		 	Set (Bacterias,MRBTpDescs)=""
						           		 	Set xResultID=""
											For {
												Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
												Quit:xResultID=""
												
												Set LabResultInfo=$g(^DHCHAI.DP.LabVisitRepResultD(xResultID))
												Set LabInfType=$lg(LabResultInfo,13)
												Set TestCode =$lg(LabResultInfo,4)
												Set RstFormat=$lg(LabResultInfo,5)
												Continue:RstFormat'="M"
												Set Bacteria=$lg(LabResultInfo,6)
												Continue:Bacteria=""
												Set Bacterias=Bacterias_","_Bacteria
												
												Set ObjectID =LabReportID_"||"_TestCode
												Set CCResultDr=$o(^DHCHAI.IR.CCResultI("IndexObjectID",xPaadm,ItemDr,LabSCode,ObjectID,0))
												Continue:CCResultDr=""
												Set ResultInfo=$g(^DHCHAI.IR.CCResultD(CCResultDr))
												Set MRBTpDr = $lg(ResultInfo,24)
											
												Set MRBTpDesc =""
												If (MRBTpDr'="") {
													Set MRBTpInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
													Set MRBTpDesc =$lg(MRBTpInfo,3)					
												}
												
												Continue:MRBTpDesc=""
												Set MRBTpDescs=MRBTpDescs_","_MRBTpDesc
											}
											Set:Bacterias'="" Bacterias=$e(Bacterias,2,$l(Bacterias))
											Set:MRBTpDescs'="" MRBTpDescs=$e(MRBTpDescs,2,$l(MRBTpDescs))
			                                
											Set LabInfo=$lb(VisitNumberID,EpisodeNo,CollDateTime,RepDateTime,LabTestSetDesc,Specimen,Bacterias,MRBTpDescs,LabInfType)
											Set LabInfos = LabInfos_$lb(LabInfo)
										}
									}
				                }						
							}
							Continue:($ll(LabInfos)=0)	
							For LenInd=1:1:$ll(LabInfos) {
								Set SubInfo=$lg(LabInfos,LenInd)														
								Set Data=$lb(DimensDesc,AdmTimes)_PatData_InfInfo_SubInfo
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1	
							}	
						}Else {
							Set Data=$lb(DimensDesc,AdmTimes)_PatData_InfInfo_$lb("","","","","","","","","")
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

ClassMethod QryInfSubDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfSubDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfSubDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfSubDtlExecute ]
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
/// CreatDate：   2022-04-15
/// Description:  判断患者是否发生医院感染,返回感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.SpeActOutInfSub).GetInfInfo("3188")
ClassMethod GetInfInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set InfPosDescs=""
	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,"1",xID))
		Quit:xID=""
		Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Quit:'$IsObject(objINFRep)
		Set RepStatus=objINFRep.IRStatusDr
		Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
		Continue:RepStatus.BTCode'="3"
		//报告日期
		Set RepDate=objINFRep.IRRepDate
		//报告人
		Set RepUser=""
		Set RepUserDr=objINFRep.IRRepUser
		Set:$IsObject(RepUserDr) RepUser=RepUserDr.BTDesc
	
		// 感染诊断信息
		Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			Continue:'$IsObject(objDiags.IRInfPosDr)
			// 感染日期
			Set InfDate  = objDiags.IRInfDate
			Set InfXDate = objDiags.IRInfXDate
			//感染类别
			Set InfType="医院感染"
			Set InfTypeCode=objDiags.IRInfType
			If (InfTypeCode'=""){
				Set:InfTypeCode=0 InfType="社区感染"
			}
			// 感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			Set PosCode=objInfPos.BTCode
			Set BigCode=$e(PosCode,1,2)
			Set objDiag=##class(DHCHAI.BT.InfPos).GetObjByCode(BigCode)
			Set PosDesc=objDiag.BTDesc
			//感染科室
			Set InfLocDesc=""
			Set IRInfLocDr=objDiags.IRInfLocDr
			If (IRInfLocDr'=""){
				Set LocDesc2 = IRInfLocDr.BTDesc2
				Set LocDesc  = IRInfLocDr.BTDesc
				Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
			}
			//转归情况
			Set InfEffect=""
			Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_objInfPos.BTDesc_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_RepUser
			}
		}
	}
	
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

}

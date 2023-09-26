/// 名称: DHCHAI.STATV2.SpeActOutAntComb
/// 描述: 提高住院患者治疗用药前送检率专项行动(2021)-哨点医院监测统计三
/// 编写者：pylian
/// 编写日期: 2022-04-15
Class DHCHAI.STATV2.SpeActOutAntComb Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2022-04-15	
/// Description:  出院的住院患者联合使用重点药物前病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
///               aStatDimens:  展示维度    //add 20221012 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutAntComb","QryAntComb","1|2","2020-01-01","2020-12-31","W","1","0","1","")
Query QryAntComb(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aSubDateType As %String, aSubHourType As %String, aLabTestSet As %Text = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,CombUseCnt:%Integer,BfCureSubCnt:%Integer,BfCureSubRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAntCombExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aSubDateType As %String, aSubHourType As %String, aLabTestSet As %Text = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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

    Set NIndex="QryAntComb"
	Kill ^TMP($zn,$j,NIndex)
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	//科室合计出院人数、抗菌药物联用人数、送检人数
    Set PatDishSum="",CombUseSum=0,BfCureSubSum=0
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
					
					Set CombUseFlg=0,IsBfCureSubmiss=0	            //是否重点抗菌药物联用、是否治疗用药（重点）前送检
					//获取抗菌药物使用信息
					Set FirstCureDate=99999,FirstCureTime=99999  
					Set FirstCombInfo =..GetFristAntComb(xPaadm,aDateFrom,aDateTo)	
					Set FirstCureDate=$p(FirstCombInfo,"^",1)
					Set FirstCureTime=$p(FirstCombInfo,"^",2)
					Set:+(FirstCureDate)>0 CombUseFlg=1
					
					//获取微生物送检记录
					If (CombUseFlg=1) {
						//1-aSubDateType:根据入参取时间类型(采样时间/送检医嘱开立时间)
						//目前数据池无送检医嘱数据,暂时不处理
						//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
						Set LabInfoArr=##class(DHCHAI.STATV2.SpeActAntSub).GetSpeLabInfo(xPaadm,AdmDate,FirstCureDate,aLabTestSet)
						For LabInd=1:1:LabInfoArr.Count(){
							Set LabInfo=LabInfoArr.GetAt(LabInd)
							Set CollDate = $li(LabInfo,3)
							Set CollTime = $li(LabInfo,4)
							//采集日期时间在治疗之前，算作治疗前送检
							if ((CollDate<FirstCureDate)||((CollDate=FirstCureDate)&(CollTime<FirstCureTime))) {
								//规定范围内
								if (aSubHourType=0){
									Set IsBfCureSubmiss=1 	//无限制
								} else{
									Set SubHour=((FirstCureDate-CollDate)*86400+(FirstCureTime-CollTime))\3600
									Set:(aSubHourType=1)&(SubHour<24) IsBfCureSubmiss=1
									Set:(aSubHourType=2)&(SubHour<48) IsBfCureSubmiss=1
									Set:(aSubHourType=3)&(SubHour<72) IsBfCureSubmiss=1
									Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfCureSubmiss=1
								}
							}
						}
					}
				
		       
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,DishLocID,DishWardID)
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// 全院住院患者人数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm)){
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm)=""
						}
						
						//重点联合用药人数
						If (CombUseFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"CombUseFlg",xPaadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"CombUseFlg"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"CombUseFlg",xPaadm)=""
							}
						}
						
						//重点联合用药治疗前送检人数
						If (IsBfCureSubmiss=1) {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss",xPaadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss",xPaadm)=""
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
	
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set DimensKey	= $lg(DimList,1)
		Set LocDr = +$p(DimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))

		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:DimensKey=""
		Continue:(aHospIDs'["|")&(DimensKey["A")		//非全院不显示"全院"
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))  			    //出院患者数
	    Set CombUseCnt =+$g(^TMP($zn,$j,NIndex,DimensKey,"CombUseFlg"))             //重点联合用药人数
		Set BfCureSubmissCnt =+$g(^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss"))  //重点联合用药治疗前送检
		
		Set BfCureSubRatio="0.00%"
		Set:CombUseCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CombUseCnt)*100,"",2)_"%" 			//Anti使用率
	
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(BfCureSubmissCnt=0)
		Continue:(aQryCon="3")&&(CombUseCnt=0)
		
		If (LocCount>1) {  //科室合计累加
			Set PatDishSum=PatDishSum+PatAdmCnt
			Set CombUseSum=CombUseSum+CombUseCnt
			Set BfCureSubSum=BfCureSubSum+BfCureSubmissCnt
		}	
		Set Data=$lb(DimensKey,DimensDesc,PatAdmCnt,CombUseCnt,BfCureSubmissCnt,BfCureSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	
 	 //出院患者住院人数及抗菌药物使用人数可以直接累加
	If (LocCount>1) {   //科室合计
		Set PatAdmCnt  =PatDishSum  			//出院患者数
		Set CombUseCnt  =CombUseSum 		    //重点联合用药人数
		Set BfCureSubmissCnt =BfCureSubSum  	//重点联合用药治疗前送检		
		Set BfCureSubRatio="0.00%"
		Set:CombUseCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CombUseCnt)*100,"",2)_"%" 			//Anti使用率
		
		Set Data=$lb("","全部",PatAdmCnt,CombUseCnt,BfCureSubmissCnt,BfCureSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  		  	
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntCombClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntCombExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntCombFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntCombExecute ]
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
/// Description:  出院的住院患者联合使用重点药物前病原学送检率明细表(病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   //add 2022012 解决汇总按科室分组统计明细无法区分医院问题
///         	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
///               aIsAntComb:是否重点联用
/// 			  aIsBfCureSub:是否病原学送检
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutAntComb","QryAntCombDtl","1","2020-05-01","2020-05-31","0001-00-0000-H-2","W","1","","1","1","0","0")
Query QryAntCombDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsAntComb As %String = "", aCombCount As %String = "", aIsBfCureSub As %String = "0", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,CombCount:%Integer,CombDate:%String,Combime:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryAntCombDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsAntComb As %String = "", aCombCount As %String = "", aIsBfCureSub As %String = "0", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aLocIDs As %Text = "") As %Status
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
  	Set NIndex="QryAntCombDtl"
	Kill ^TMP($zn,$j,NIndex)

	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
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
					If (aIsBfCureSub=1){
						Set IsBfCureSub=##class(DHCHAI.STATV2.SpeActOutAntComb).GetIsBfAntCombSub(xPaadm,AdmDate,DischDate,AdmTime,DischTime,aLabTestSet,aSubDateType,aSubHourType)
						Continue:IsBfCureSub'=1
					}
		    		//获取抗菌药物使用信息
					Set AntUseArr =..GetAntCombInfo(xPaadm,AdmDate,DischDate)
					Continue:AntUseArr.Count()<1
					Set CombCount=$lg(AntUseArr.GetAt(1),15)   //联用数
					Set CombDate=$lg(AntUseArr.GetAt(1),16)   //首次联用日期
					Set CombTime=$lg(AntUseArr.GetAt(1),17)   //首次联用时间
					Continue:(aIsAntComb=1)&&(CombCount<2)
					Continue:(aCombCount'="")&(aCombCount'=4)&(CombCount'=aCombCount)
					Continue:(aCombCount'="")&(aCombCount=4)&(CombCount<aCombCount)	
				
					For AntInd=1:1:AntUseArr.Count(){
					    Set OrderInfo=AntUseArr.GetAt(AntInd)
						Set UsePurpose = $lg(OrderInfo,11)
						Set DrgPoison  = $lg(OrderInfo,13)
						Set:DrgPoison="KSS1" DrgPoison="非限制使用级"
						Set:DrgPoison="KSS2" DrgPoison="限制使用级"
						Set:DrgPoison="KSS3" DrgPoison="特殊使用级"
						Set $li(OrderInfo,13)=DrgPoison
						
						//日期类型转化
					    Set OrdDateTime  = $li(OrderInfo,6)
						Set SttDateTime  = $li(OrderInfo,7)
						Set EndDateTime  = $li(OrderInfo,10)
						Set OrdDate=$p(OrdDateTime," ",1)
						Set OrdTime=$p(OrdDateTime," ",2)
						Set SttDate=$p(SttDateTime," ",1)
						Set SttTime=$p(SttDateTime," ",2)
						Set EndDate=$p(EndDateTime," ",1)
						Set EndTime=$p(EndDateTime," ",2)
										   				
						Set LabDateTo=SttDate  //病原学送检 截止日期到(联合用药)开始使用抗菌药物日期
						Set LabTimeTo=SttTime
						Set:CombDate'="" LabDateTo=CombDate
						Set:CombTime'="" LabTimeTo=CombTime

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

						//获取病人是否治疗前送检
						If (aIsBfCureSub=1) {
							Set (LabInfos,InfPosInfos)=""		
							Set SubLabArr=##class(DHCHAI.STATV2.SpeActAntSub).GetSpeLabInfo(xPaadm,AdmDate,LabDateTo,aLabTestSet,AdmTime,CombTime)  //病原学送检
							Continue:SubLabArr.Count()<1
							For indLab=1:1:SubLabArr.Count() {
								Set SubLabInfo=SubLabArr.GetAt(indLab)	
								Continue:SubLabInfo=""
								Set VisitNumberID = $lg(SubLabInfo,1)
								Set EpisodeNo	  = $lg(SubLabInfo,2)
								Set CollDate 	  = $lg(SubLabInfo,3)
								Set CollTime	  = $lg(SubLabInfo,4)
								Set Specimen      = $lg(SubLabInfo,5)
								Set TestSet       = $lg(SubLabInfo,6)
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
								Set Data=$lb(DimensDesc,AdmTimes)_PatData_OrderInfo_SubInfo
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1	
							}	

						}Else {
					
							Set Data = $lb(DimensDesc,AdmTimes)_PatData_OrderInfo_$lb("","","","","","","","","")
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

ClassMethod QryAntCombDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntCombDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntCombDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntCombDtlExecute ]
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

/// 取出院病人首次联合使用重点抗菌药物时间
/// w ##class(DHCHAI.STATV2.SpeActOutAntComb).GetFristAntComb(342,$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod GetFristAntComb(aPaadm As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aPaadm,aDateFrom,aDateTo)
	Set return=""
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
	
	Set NIndex="GetFristAntComb"
	Kill ^TMP($zn,$j,NIndex)
	Kill arrOrdItem
	
	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0
	            
	            Set SCode   = $li(OEOrdItemData,28)
	           	Set OrdDesc = $li(OEOrdItemData,4)	        
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID="" //过滤未对照
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:AntiMapData=""
			    Set MapItemDr=$lg(AntiMapData,3)
			    Continue:MapItemDr=""
	            Set AntiMastData=$g(^DHCHAI.DP.OEAntiMastD(MapItemDr))
	            Continue:AntiMastData=""
	            Continue:$lg(AntiMastData,7)'=1  //非重点药物过滤
	            Set AntiMapDesc=$lg(AntiMastData,3)  //抗菌药物标准名称
               
	            Set SttDate = $li(OEOrdItemData,15)
	            Set SttTime = $li(OEOrdItemData,16)
				Set EndDate = $li(OEOrdItemData,17)
				Set EndTime	= $li(OEOrdItemData,18)
				
	            Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				Continue:PriorityMap="OUT"
				
	            If PriorityMap="N"{
					Set EndDate = SttDate
					Set EndTime	= SttTime
				}
				Continue:(EndDate<aDateFrom)&&(EndDate'="")  // 停药日期在转入日期前
				Continue:(SttDate>aDateTo)	// 用药日期在转出日期后
			    
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
                Set InstrucList=","_InstrucList_","
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set UsePurpose = $li(OEOrdItemData,30)
				Continue:UsePurpose=""
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
                Continue:UsePurpose'["治疗"
				Set DrgPoison = $li(OEOrdItemData,29) //抗菌用药等级
				Set OrdItemID = $li(OEOrdItemData,24)
				
				Set CombEndDate=EndDate
				Set:CombEndDate="" CombEndDate = aDateTo
					
				For xUseDate=SttDate:1:CombEndDate {
					Set ^TMP($zn,$j,NIndex,"AntComb",xUseDate,AntiMapDesc)=xOrdItemID
				}
				
			}
		}
	}
	
	Set SttDate="",SttTime=""
	For xDate=aDateFrom:1:aDateTo {
		Set xAntiDesc=""
		For{
			Set xAntiDesc=$o(^TMP($zn,$j,NIndex,"AntComb",xDate,xAntiDesc))	
			Quit:xAntiDesc=""
		
			Set OrdItemID=$g(^TMP($zn,$j,NIndex,"AntComb",xDate,xAntiDesc))
			
			Set arrOrdItem(xDate,OrdItemID)=""
		}
		Set Count=0,FirstDate="",FirstTime=""
		Set xOrdItemID=""
		For {
			Set xOrdItemID=$o(arrOrdItem(xDate,xOrdItemID))	
			Quit:xOrdItemID=""
			Quit:(SttDate'="")&&(SttTime'="")
			
			Set Count=Count+1
			If (Count=1) { 
				Set fOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Set FirstDate = $lg(fOrdItemData,15)
				Set FirstTime = $lg(fOrdItemData,16)
			}
			If (Count=2) {   //取联合用药的第二个药品的用药时间
				Set sOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Set SttDate = $lg(sOrdItemData,15)
				Set SttTime = $lg(sOrdItemData,16)
				
				If (FirstDate=SttDate) {
					Set SttTime=$S(FirstTime>SttTime:FirstTime,1:SttTime)
				}
			}			
		}
	}
	Quit:(SttDate="")&&(SttTime="") return
	Set return = SttDate_"^"_SttTime
		
	Kill arrOrdItem
	Kill ^TMP($zn,$j,NIndex)
	
	Quit return
}

/// Creator：     pylian    	
/// CreatDate：   2022-04-15
/// 取出院病人给定时间段内重点抗菌药物使用记录及联用级别
/// zw ##class(DHCHAI.STATV2.SpeActOutAntComb).GetAntCombInfo(342,$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod GetAntCombInfo(aPaadm As %String, aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	new (aPaadm,aDateFrom,aDateTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
	
	Set NIndex="GetAntCombInfo"
	Kill ^TMP($zn,$j,NIndex)
	Kill arrOrdItem
	Kill arrCombOrd
	
	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0
	            
	            Set SCode   = $li(OEOrdItemData,28)
	           	Set OrdDesc = $li(OEOrdItemData,4)	        
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID="" //过滤未对照
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:AntiMapData=""
			    Set MapItemDr=$lg(AntiMapData,3)
			    Continue:MapItemDr=""
	            Set AntiMastData=$g(^DHCHAI.DP.OEAntiMastD(MapItemDr))
	            Continue:AntiMastData=""
	            Continue:$lg(AntiMastData,7)'=1  //非重点药物过滤
	            Set AntiMapDesc=$lg(AntiMastData,3)  //抗菌药物标准名称
               
	            Set SttDate = $li(OEOrdItemData,15)
	            Set SttTime = $li(OEOrdItemData,16)
				Set EndDate = $li(OEOrdItemData,17)
				Set EndTime	= $li(OEOrdItemData,18)
				
	            Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				Continue:PriorityMap="OUT"
				
	            If PriorityMap="N"{
					Set EndDate = SttDate
					Set EndTime	= SttTime
				}
				Continue:(EndDate<aDateFrom)&&(EndDate'="")  // 停药日期在转入日期前
				Continue:(SttDate>aDateTo)	// 用药日期在转出日期后
			   
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
                Set InstrucList=","_InstrucList_","
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set UsePurpose = $li(OEOrdItemData,30)
				Continue:UsePurpose=""
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
                Continue:UsePurpose'["治疗"
				Set DrgPoison = $li(OEOrdItemData,29) //抗菌用药等级
				Set OrdItemID = $li(OEOrdItemData,24)
				
				If (PriorityMap="N") { //update 20220614 平台接口停药那天不算联合用药
					Set CombEndDate=EndDate  
				}Else {
					Set CombEndDate=""
					Set:EndDate'="" CombEndDate=EndDate-1
					Set:CombEndDate="" CombEndDate = aDateTo
					Set:CombEndDate<SttDate CombEndDate=SttDate  //当天开当天停的长期医嘱
				}  
					
				For xUseDate=SttDate:1:CombEndDate {
					Set ^TMP($zn,$j,NIndex,"AntComb",xUseDate,AntiMapDesc)=xOrdItemID
				}
				
				Set Generic=$li(OEOrdItemData,19)
				Set OrdDate = $li(OEOrdItemData,10)
				Set OrdTime = $li(OEOrdItemData,11)
			    Set OrdDateTime=OrdDate_" "_OrdTime
	            Set SttDateTime=SttDate_" "_SttTime
	         	Set EndDateTime=EndDate_" "_EndTime
				Set OEOrdLocDr=$li(OEOrdItemData,12)
				Set OEOrdLocData=$g(^DHCHAI.BT.LocationD(OEOrdLocDr))
				If OEOrdLocData'="" {
					Set OrdLocDesc=$li(OEOrdLocData,3)
				} Else {
					Set OrdLocDesc=$li(OEOrdItemData,39)  //ID|Code|Desc
					Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
				}
				//取医师类型
				Set OrdDocDesc=$li(OEOrdItemData,14)  //ID|Code|Desc
				Set OEDocDr=""
				Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
				Set CarPrvTpId="",CarPrvTpDesc=""
				Set:OEDocDr'="" CarPrvTpId=$p(^CTPCP(OEDocDr,1),"^",4)	//CTCarPrvTp
				Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)
				Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
				
				Set OrdItemInfo=$lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison,CarPrvTpDesc)
				Set arrOrdItem(xOrdItemID)=OrdItemInfo
				
			}
		}
	}
	
	Set CombCount=0,CombDate="",Combime=""
	For xDate=aDateFrom:1:aDateTo {
		Set Count=0
		Set xAntiDesc=""
		For{
			Set xAntiDesc=$o(^TMP($zn,$j,NIndex,"AntComb",xDate,xAntiDesc))	
			Quit:xAntiDesc=""
			
			Set Count=Count+1
			Set OrdItemID=$g(^TMP($zn,$j,NIndex,"AntComb",xDate,xAntiDesc))
			
			Set arrCombOrd(xDate,OrdItemID)=""
		}
		Set:Count>CombCount CombCount=Count
	
		Set Cnt=0,FirstDate="",FirstTime=""
		Set xOrdItemID=""
		For {
			Set xOrdItemID=$o(arrCombOrd(xDate,xOrdItemID))	
			Quit:xOrdItemID=""
			Quit:(CombDate'="")&&(Combime'="")
			
			Set Cnt=Cnt+1
			If (Cnt=1) { 
				Set fOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Set FirstDate = $lg(fOrdItemData,15)
				Set FirstTime = $lg(fOrdItemData,16)
			}
			If (Cnt=2) {   //取联合用药的第二个药品的用药时间
				Set sOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Set CombDate = $lg(sOrdItemData,15)
				Set Combime = $lg(sOrdItemData,16)
				
				If (FirstDate=CombDate) {
					Set Combime=$S(FirstTime>Combime:FirstTime,1:Combime)
				}
			}			
		}
	}
	
	Set Count=0
	Set xOrdItemID=""
	For {
		Set xOrdItemID=$o(arrOrdItem(xOrdItemID))
		Quit:xOrdItemID=""
		
		Set OrdItemInfo=$g(arrOrdItem(xOrdItemID))_$lb(CombCount,CombDate,Combime)
		Set Count=Count+1
		Do return.SetAt(OrdItemInfo,Count)
		
	}
	
	Kill arrCombOrd	
	Kill arrOrdItem
	Kill ^TMP($zn,$j,NIndex)
	
	Quit return
}

/// Creator：     pylian    	
/// CreatDate：   2022-04-15	
/// Description:  判断病人是否重点联合用药治疗前送检
/// Return：      1(是),0(否)
/// w ##class(DHCHAI.STATV2.SpeActOutAntComb).GetIsBfAntCombSub("108",$zdh("2020-01-01",3),$zdh("2020-12-31",3),"","","1","0","0")
ClassMethod GetIsBfAntCombSub(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aLabTestSet As %Text = "", aSubDateType As %String = "", aSubHourType As %String = "0") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aLabTestSet,aSubDateType,aSubHourType)
	Set return=0
   
    Set IsCureUse=0,IsBfCureSubmiss=0	
	Set FirstCombInfo =..GetFristAntComb(aEpisodeID,aDateFrom,aDateTo)	
	Set FirstCureDate=$p(FirstCombInfo,"^",1)
	Set FirstCureTime=$p(FirstCombInfo,"^",2)
	Set:+(FirstCureDate)>0 IsCureUse=1
	
	If (IsCureUse=1) {
		//获取微生物送检记录
		//1-aSubHourType:根据入参取时间类型(采样时间/送检医嘱开立时间)
		//目前数据池无送检医嘱数据,暂时不处理
		//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
		Set LabDatefrom=$li(^DHCHAI.DP.PAAdmD(aEpisodeID),20)
		Set LabDateTo=FirstCureDate
		Set LabInfoArr=##class(DHCHAI.STATV2.SpeActOutAntSub).GetSpeLabInfo(aEpisodeID,LabDatefrom,LabDateTo,aLabTestSet)
		For LabInd=1:1:LabInfoArr.Count(){
			Set LabInfo=LabInfoArr.GetAt(LabInd)
			Set CollDate = $li(LabInfo,3)
			Set CollTime = $li(LabInfo,4)
			//采集日期时间在治疗之前，算作治疗前送检
			if ((CollDate<FirstCureDate)||((CollDate=FirstCureDate)&(CollTime<FirstCureTime))) {
				//规定范围内
				if (aSubHourType=0){
					Set IsBfCureSubmiss=1 	//无限制
				} else{
					Set SubHour=((FirstCureDate-CollDate)*86400+(FirstCureTime-CollTime))\3600
					Set:(aSubHourType=1)&(SubHour<24) IsBfCureSubmiss=1
					Set:(aSubHourType=2)&(SubHour<48) IsBfCureSubmiss=1
					Set:(aSubHourType=3)&(SubHour<72) IsBfCureSubmiss=1
					Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfCureSubmiss=1
				}
			}
			Quit:IsBfCureSubmiss=1
		}
	}
	Set return=IsBfCureSubmiss
	
	Quit return
}

}

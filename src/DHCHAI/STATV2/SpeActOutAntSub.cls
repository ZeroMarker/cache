/// 名称: DHCHAI.STATV2.SpeActOutAntSub
/// 描述: 提高住院患者治疗用药前送检率专项行动(2021)-哨点医院监测统计一
/// 编写者：pylian
/// 编写日期: 2022-04-15
Class DHCHAI.STATV2.SpeActOutAntSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2022-04-15	
/// Description:  出院的住院患者抗菌药物治疗前病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
///               aStatDimens:  展示维度    //add 20221012 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutAntSub","QryAntTheSub","1|2","2020-05-01","2021-05-31","E","1","0","1","")
Query QryAntTheSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aSubDateType As %String, aSubHourType As %String, aLabTestSet As %Text = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,CureUseAntiCnt:%Integer,BfCureSubmissCnt:%Integer,BfCureSubRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aSubDateType As %String, aSubHourType As %String, aLabTestSet As %Text = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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

    Set NIndex="QryAntTheSub"
	Kill ^TMP($zn,$j,NIndex)
    
	//科室合计出院人数、抗菌药物联用人数、送检人数
    Set PatDishSum="",CureUseSum=0,BfCureSubSum=0
	Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
    For index=1:1:DishPatArr.Count() {
	    Set DishPat=DishPatArr.GetAt(index)
	    Set Paadm	= $li(DishPat,1)
	    Set HospDr	= $li(DishPat,2)
	    Set GroupDr	= $li(DishPat,3)
	    Set LocDr	= $li(DishPat,4)
	    Set WardDr	= $li(DishPat,5)
	    Set AdmDate	= $li(DishPat,6)
	    Set DishDate= $li(DishPat,7)
		
		Set LocID = LocDr
		Set:aLocType="W" LocID=WardDr
	    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))    
		Set:aLocType="W" GroupDr  = $li($g(^DHCHAI.BT.LocationD(WardDr)),7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
       
		//获取首次治疗性抗菌药物使用信息
		Set IsCureUse=0,FirstCureDate="",FirstCureTime=""
		Set AntUseInfo=..GetFirstCureAnt(Paadm,AdmDate,DishDate)		
		Set FirstCureDate=$p(AntUseInfo,"^",1)
		Set FirstCureTime=$p(AntUseInfo,"^",2)
		Set:+(FirstCureDate)>0 IsCureUse=1
		
		//获取微生物送检记录
		Set IsBfCureSubmiss=0
		If (IsCureUse=1) {
			//1-aSubDateType:根据入参取时间类型(采样时间/送检医嘱开立时间)
			//目前数据池无送检医嘱数据,暂时不处理
			//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
			Set LabInfoArr=##class(DHCHAI.STATV2.SpeActOutAntSub).GetSpeLabInfo(Paadm,AdmDate,FirstCureDate,aLabTestSet)  //使用就诊开始至抗菌药物使用开始日期，缩短范围
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
	
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 出院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			//治疗使用抗菌药物
			If (IsCureUse=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsCureUse",Paadm))
				{
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsCureUse"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"IsCureUse",Paadm)=""
				}
			}
			//治疗前送检
			If (IsBfCureSubmiss=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss",Paadm))
				{
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss",Paadm)=""
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
		Set PatAdmCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set CureUseAntiCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsCureUse"))		//抗感染药治疗使用人数
		Set BfCureSubmissCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsBfCureSubmiss"))  //治疗前送检
		Set BfCureSubRatio="0.00%"
		Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 			//治疗前送检率
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(BfCureSubmissCnt=0)
		Continue:(aQryCon="3")&&(CureUseAntiCnt=0)
		
		If (LocCount>1) {  //科室合计累加
			Set PatDishSum=PatDishSum+PatAdmCnt
			Set CureUseSum=CureUseSum+CureUseAntiCnt
			Set BfCureSubSum=BfCureSubSum+BfCureSubmissCnt
		}	
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	

 	//出院患者住院人数及抗菌药物使用人数可以直接累加
	If (LocCount>1) {   //科室合计
		Set PatAdmCnt  =PatDishSum  			//出院患者数
		Set CureUseAntiCnt  =CureUseSum 		//重点联合用药人数
		Set BfCureSubmissCnt =BfCureSubSum  	//重点联合用药治疗前送检		
		Set BfCureSubRatio="0.00%"
		Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 			//治疗前送检率
		
		Set Data=$lb("","全部",PatAdmCnt,PatAdmCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  		  	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntTheSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTheSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntTheSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTheSubExecute ]
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
/// Description:  出院患者抗菌药物病原学治疗前送检率明细表(抗菌药物、病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   //add 2022012 解决汇总按科室分组统计明细无法区分医院问题
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
/// 			  aIsBfCureSub:是否病原学送检
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActOutAntSub","QryAntTheSubDtl","","2020-05-01","2020-12-31","0000-00-0000-A-1-1","E","1","1","1","0")
Query QryAntTheSubDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsBfCureSub As %String = "0", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsBfCureSub As %String = "0", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aLocIDs As %Text = "") As %Status
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
  	Set NIndex="QryAntTheSubDtl"
	Kill ^TMP($zn,$j,NIndex)

    //出院患者
	Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
    For index=1:1:DishPatArr.Count() {
	    Set DishPat=DishPatArr.GetAt(index)
	    Set Paadm	= $li(DishPat,1)
	    Set HospDr	= $li(DishPat,2)
	    Set GroupDr	= $li(DishPat,3)
	    Set LocDr	= $li(DishPat,4)
	    Set WardDr	= $li(DishPat,5)
	    Set AdmDate	= $li(DishPat,6)
	    Set DishDate= $li(DishPat,7)
	    
		Set:aStaType="W" LocDr=WardDr
		Continue:(aLocDr'="")&(aLocDr'=LocDr)
	    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))    
		Set:aStaType="W" GroupDr  = $li($g(^DHCHAI.BT.LocationD(WardDr)),7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
        
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
	   
		//取统计维度
		Set DimensDesc =""
		Set:DimensMark="" DimensDesc="全部"
		Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
		Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
		Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
		Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称				   
					
		If (aIsBfCureSub=1){
			Set IsBfCureSub=##class(DHCHAI.STATV2.SpeActOutAntSub).GetIsBfCureSubmiss(Paadm,AdmDate,DishDate,"","",aLabTestSet,aSubDateType,aSubHourType)
			Continue:IsBfCureSub'=1
		}
		
		//获取病人就诊信息
	    Set PatData=..BuildPaadmData(Paadm)
	    Continue:PatData=""
	  	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 	Set AdmTimes = $lg(PAAdmData,38)   //就诊次数
	 	Set LabDatefrom=$lg(PAAdmData,20)
	 	Set LabTimefrom=$lg(PAAdmData,21)
	 	
		Set TransInfoArr =..GetTransInfo(Paadm,"","",aStaType)  //存在转科日期早于入院日期情况，取全部转科记录
		For TransInd=1:1:TransInfoArr.Count(){
			Set TransInfo=TransInfoArr.GetAt(TransInd)
			Set TransID=$lg(TransInfo,1)
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		    Set TransTime	= $li(TranData,8)
			Set OutLocTime	= $li(TranData,11)
			
			//获取抗菌药物使用信息
			Set (OrderInfos,OrderInfo,LabInfos,InfPosInfos,LabDateTo)=""
			Set AntUseArr =..GetAntUseInfo(Paadm,TransDate,OutLocDate,TransTime,OutLocTime)
			Continue:AntUseArr.Count()<1
			For AntInd=1:1:AntUseArr.Count() {
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set DrgPoison  = $li(OrderInfo,13)
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
				
			    Set:LabDateTo="" LabDateTo=SttDate   //病原学送检截止在抗菌药物开始日期
			    Set:LabTimeTo="" LabTimeTo=SttTime
			    
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
				
 				Set OrderInfos=OrderInfos_$lb(OrderInfo)				
			}
            Continue:($ll(OrderInfos)=0) 
			//获取病人是否治疗前送检
			If (aIsBfCureSub=1) {
					
				Set SubLabArr=##class(DHCHAI.STATV2.SpeActAntSub).GetSpeLabInfo(Paadm,LabDatefrom,LabDateTo,aLabTestSet,LabTimefrom,LabTimeTo)  //病原学送检
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
									Set CCResultDr=$o(^DHCHAI.IR.CCResultI("IndexObjectID",Paadm,ItemDr,LabSCode,ObjectID,0))
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
			}
			
			Set Len=$ll(OrderInfos)
			Set:(Len<$ll(LabInfos)) Len=$ll(LabInfos)
			
			For LenInd=1:1:Len {
				Set OrderInfo=$lg(OrderInfos,LenInd)
				Set:OrderInfo="" OrderInfo=$lb("","","","","","","","","","","","","","")
				Set LabInfo=$lg(LabInfos,LenInd)
				Set:LabInfo="" LabInfo=$lb("","","","","","","","","")
			
				Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_OrderInfo_LabInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntTheSubDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTheSubDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntTheSubDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTheSubDtlExecute ]
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
/// 取出院患者首次使用抗菌药物时间
/// w ##class(DHCHAI.STATV2.SpeActOutAntSub).GetFirstCureAnt(2981,$zdh("2020-05-01",3),$zdh("2021-12-31",3))
ClassMethod GetFirstCureAnt(aPaadm As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aPaadm,aDateFrom,aDateTo)
    
    Set return=""
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
		
	Set xScode = "",IsFisrt=0,FirstCureDate="",FirstCureTime=""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
		Quit:xScode=""
		Quit:IsFisrt=1
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
			Quit:xSttDate=""
			Quit:IsFisrt=1
			Continue:(xSttDate>aDateTo)
						
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
				Quit:IsFisrt=1
				
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0
	            
	            Set SCode   = $li(OEOrdItemData,28)
	           	Set OrdDesc = $li(OEOrdItemData,4)	
	           	Continue:OrdDesc=""
                Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID=""
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1   //add 20221122 过滤抗菌药物对照置无效的药物
			    
			    Set SttDate = $li(OEOrdItemData,15)
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
				Set IsFisrt =1			
				Set FirstCureDate=SttDate 
				Set FirstCureTime=SttTime
			}
		}
	}
	Set return=FirstCureDate_"^"_FirstCureTime
	
	Quit return
}

/// Creator：     pylian    	
/// CreatDate：   2022-04-15	
/// Description:  判断病人是否治疗前送检
/// Return：      1(是),0(否)
/// zw ##class(DHCHAI.STATV2.SpeActOutAntSub).GetIsBfCureSubmiss(4130,66079,66079,"","","1","1","0")
ClassMethod GetIsBfCureSubmiss(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aLabTestSet As %Text = "", aSubDateType As %String = "", aSubHourType As %String = "0") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aLabTestSet,aSubDateType,aSubHourType)
	Set return=0
  
    Set IsCureUse=0,IsBfCureSubmiss=0	
	Set FirstCureDate=99999,FirstCureTime=99999
	Set AntUseInfo =..GetFirstCureAnt(aEpisodeID,aDateFrom,aDateTo)	
	Set FirstCureDate=$p(AntUseInfo,"^",1)
	Set FirstCureTime=$p(AntUseInfo,"^",2)
	Set:+(FirstCureDate)>0 IsCureUse=1
   
	//获取微生物送检记录
	If (IsCureUse=1) {
		//1-aSubHourType:根据入参取时间类型(采样时间/送检医嘱开立时间)
		//目前数据池无送检医嘱数据,暂时不处理
		//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
		Set LabDatefrom=$li(^DHCHAI.DP.PAAdmD(aEpisodeID),20)
		Set LabDateTo=FirstCureDate
		Set LabInfoArr=..GetSpeLabInfo(aEpisodeID,LabDatefrom,LabDateTo,aLabTestSet)
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

/// Creator：     pylian    	
/// CreatDate：   2022-04-15
/// 取病人给定时间段内抗菌药物使用记录
/// zw ##class(DHCHAI.STATV2.SpeActOutAntSub).GetAntUseInfo(2981,$zdh("2020-05-01",3),$zdh("2021-12-01",3))
ClassMethod GetAntUseInfo(aPaadm As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "") As %Library.ArrayOfDataTypes
{
	new (aPaadm,aDateFrom,aDateTo,aTimeFrom,aTimeTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
		
	Set xScode = "",Count=0
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
				If (EndDate=aDateFrom) {
					If (EndTime'="") {
						Continue:(aTimeFrom'="")&&(EndTime<aTimeFrom)  // 停药日期在转入日期前
					}
				}
				Continue:(SttDate>aDateTo)	// 用药日期在转出日期后
			    If (SttDate=aDateTo) {
				    If (SttTime'="") {
						Continue:(aTimeTo'="")&&(SttTime>aTimeTo)	// 用药日期在转出日期后
					}
			    }
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
				Set OrdDocDesc=$li(OEOrdItemData,14)  //ID|Code|Desc
				Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
				
				//取医师类型
				Set OrdDocDesc=$li(OEOrdItemData,14)  //ID|Code|Desc
				Set OEDocDr=""
				Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
				Set CarPrvTpId="",CarPrvTpDesc=""
				Set:OEDocDr'="" CarPrvTpId=$p(^CTPCP(OEDocDr,1),"^",4)	//CTCarPrvTp
				Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)
				Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
				
				Set OrdItemInfo=$lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison,CarPrvTpDesc)
				Set Count=Count+1
				Do return.SetAt(OrdItemInfo,Count)
			}
		}
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-04-15
/// Description:  获取病人送检信息
/// Return：      
/// zw ##class(DHCHAI.STATV2.SpeActOutAntSub).GetSpeLabInfo(3220,$zdh("2020-05-01",3),$zdh("2021-12-01",3),"1,9")
ClassMethod GetSpeLabInfo(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aLabTestSet As %Text = "") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aLabTestSet)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Set xVisitNumberDr="",Count=0
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
		Continue:VisitData=""
		Set LabIsActive		=$li(VisitData,18)
		Continue:LabIsActive'=1
		
		Set SCode 			=$li(VisitData,14)
		Set CollDate 		=$li(VisitData,8)				//采集日期
		Set CollTime		=$li(VisitData,9)				//采集时间
		Set EpisodeNo		=$li(VisitData,3)   			//标本号
		Set RecDate 		=$li(VisitData,11)				//接收日期
		Set RecTime 		=$li(VisitData,12)				//接收时间
		Set Specimen 		=$li(VisitData,6)
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)	//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		Continue:CollDate=""
		Continue:(aDateFrom'="")&(CollDate<aDateFrom)
		Continue:(aDateTo'="")&(CollDate>aDateTo)
		//标本名称对照
		Set MapID=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
		Set LabSpecMapData=$lb("","","","","","","","","")
		Set:MapID'="" LabSpecMapData=$g(^DHCHAI.DP.LabSpecMapD(MapID))
		Set MapActive	=$li(LabSpecMapData,6)
		Set MapItemDr	=$li(LabSpecMapData,3)
		if (MapItemDr'="")&&(MapActive=1) {
			Set MapItemData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
			If (MapItemData'=""){
				Set MapItemActive=$li(MapItemData,5)
				Set:MapItemActive Specimen = $li(MapItemData,3)
			}
		}
	    Set TestSet=""
		Set xTestSetDesc = "",CheckFlg=0
		For {
			Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,0))
			If (TestSetMapID'=""){
				Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
				Continue:TestSetMapData=""
				Continue:'$li(TestSetMapData,7) 		//无效判断
				Set TSMapItemDr=$li(TestSetMapData,4)
				Continue:(aLabTestSet'="")&&((","_aLabTestSet_",")'[(","_TSMapItemDr_","))
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
							Continue:(aLabTestSet'="")&&((","_aLabTestSet_",")'[(","_TSMapItemDr_","))
							Set CheckFlg = 1
							
							Set TestSetData=$g(^DHCHAI.DP.LabVisitTestSetD(xTestSetDr))
							Set TestSet=$lg(TestSetData,3)
							Quit										
						}
					}
				}
			}
		}
		Continue:CheckFlg=0	//过滤非指定类型的送检

		Set LabInfo=$lb(xVisitNumberDr,EpisodeNo,CollDate,CollTime,Specimen,TestSet)
		Set Count=Count+1
		Do return.SetAt(LabInfo,Count)
	}	
	Quit return
}

}

/// 名称: DHCHAI.STATV2.SpeActInfSub
/// 描述: 提高住院患者治疗用药前送检率专项行动(2021)-统计二
/// 编写者：pylian
/// 编写日期: 2021-12-03
Class DHCHAI.STATV2.SpeActInfSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2021-12-03	
/// Description:  医院感染诊断相关病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
///               aStatDimens:  展示维度    //add 20221012 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActInfSub","QryInfSub","1|2","2020-05-01","2021-12-01","W","1,2,9","")
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
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
				}
		
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					// 住院患者人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)) {
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
					}
					
					If (LocCount>1) {
						// 合计住院患者
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
						}
					}

					// 全院科室患者
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)) {
						// 科室患者
						Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)=""
						// 科室患者感染
						Set InfPosInfo=##class(DHCHAI.STATV2.SpeActInfSub).GetInfInfo(Paadm,aDateFrom,aDateTo,LocDr,WardDr)
						If (InfPosInfo'="") {
							If ('$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm))) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""												
								Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
							}
							If (LocCount>1) {
								// 合计
								If '$d(^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)){
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfPat"))
									Set ^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)=""
								}
							}
							For indPos=1:1:$l(InfPosInfo,"|") {
								Set tmpInfPos = $p(InfPosInfo,"|",indPos)
								Set DiagID    = $p(tmpInfPos,"^",1)
						
								//病原学送检
								Set SubLabInfo=##class(DHCHAI.STATV2.SpeActInfSub).GetInfLabInfo(Paadm,"","",aLabTestSet,DiagID)
								Continue:SubLabInfo.Count()<1								
								If ('$d(^TMP($zn,$j,NIndex,DimensKey,"InfSub",Paadm))) {
									Set ^TMP($zn,$j,NIndex,DimensKey,"InfSub",Paadm)=""												
									Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfSub"))
								}
								If (LocCount>1) {
									// 合计
									If '$d(^TMP($zn,$j,NIndex,"Sum","InfSub",Paadm)){
										Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfSub"))
										Set ^TMP($zn,$j,NIndex,"Sum","InfSub",Paadm)=""
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
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set InfPatCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  		    //新发感染人数
		Set InfSubCnt   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfSub"))		    //送检人数
		Set InfSubRatio="0.00%"
		Set:InfSubCnt>0 InfSubRatio=$fn((InfSubCnt/InfPatCnt)*100,"",2)_"%" 	//感染送检率
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(InfSubCnt=0)
		Continue:(aQryCon="3")&&(InfPatCnt=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InfPatCnt,InfSubCnt,InfSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If (LocCount>1) {
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			//在院患者数
		Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  		    //新发感染人数
		Set InfSubCnt   =+$g(^TMP($zn,$j,NIndex,"Sum","InfSub"))		    //送检人数
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
/// CreatDate：   2021-12-03	
/// Description:  医院感染诊断相关病原学送检率明细表(医院感染、病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220922 解决汇总按科室分组统计明细无法区分医院问题
/// 			  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
/// 			  IsBfCureSubmiss:是否病原学送检
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActInfSub","QryInfSubDtl","1","2020-05-01","2020-05-31","0000-00-0000-A-1","W","1","1,18,22,9,19,20,21,23,24,25,26,27,28,29")
Query QryInfSubDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsInfSub As %String = 0, aLabTestSet As %Text = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String") [ SqlProc ]
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
	
  	Set NIndex="QryInfSubDtl"
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
				//获取病人基本信息
				Set PatData =..BuildPaadmData(Paadm)
				Continue:PatData=""
				Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 			Set AdmTimes = $lg(PAAdmData,38)   //就诊次数
				Set LabDatefrom=$lg(PAAdmData,20)
		
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
					Set TransInfo=$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
		
					// 患者感染
					Set InfPosInfo=##class(DHCHAI.STATV2.SpeActInfSub).GetInfInfo(Paadm,DateFrom,DateTo,LocDr,WardDr)
					Continue:(InfPosInfo="") 
					For indPos=1:1:$l(InfPosInfo,"|") {
						Set tmpInfPos      	= $p(InfPosInfo,"|",indPos)
						Set DiagID    	    = $p(tmpInfPos,"^",1)
						Set InfPosDesc 	    = $p(tmpInfPos,"^",2)
						Set InfDate		   	= $p(tmpInfPos,"^",3)
						Set InfXDate	    = $p(tmpInfPos,"^",4)
						Set InfEffect		= $p(tmpInfPos,"^",5)
						Set InfType		    = $p(tmpInfPos,"^",7)					
						Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
						Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
						
						Set InfInfo=$lb(DiagID,InfPosDesc,InfType,InfDate,InfEffect,InfXDate)
			    
						If (aIsInfSub=1) {    //病原学送检
							Set LabInfos="",LabInfo=""						
							Set SubLabArr=##class(DHCHAI.STATV2.SpeActInfSub).GetInfLabInfo(Paadm,"","",aLabTestSet,DiagID)  //病原学送检
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
							For LenInd=1:1:$ll(LabInfos) {
								Set SubInfo=$lg(LabInfos,LenInd)														
								Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_InfInfo_SubInfo
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1	
							}						

						}Else {
							Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_InfInfo_$lb("","","","","","","","","")
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
/// CreatDate：   2022-06-17
/// Description:  判断患者是否发生医院感染,返回感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.SpeActInfSub).GetInfInfo("172","65360","66419")
ClassMethod GetInfInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aWardID As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aLocID,aWardID)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:RepType'="1"
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-17 Global方式
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Continue:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			//报告日期
			Set RepDate=$lg(INFRepData,4)
			//报告人
			Set RepUser="",RepUserData=""
			Set RepUserDr=$lg(INFRepData,7)
			Set:RepUserDr'="" RepUserData=$g(^DHCHAI.BT.SysUserD(RepUserDr))
			Set RepUser=$lg(RepUserData,3)
			
			// 感染诊断信息
			Set LinkDiags=""
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
				Set InfPosDr = $lg(DiagsData,3)
				Continue:InfPosDr=""
				// 感染诊断
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPosDr))
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)	
				Continue:BigCode=""
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				
				//1，判断本次感染是否是手术感染，手术感染关联手术是否是历史手术，历史手术本次就诊感染人数就不统计，
				Set OprInfDate="",IsLastOperInf=0
				If ((PosDesc["表浅")||((PosDesc["深部"))||((PosDesc["器官和腔隙感染"))){
					Set xxSub=0
					For {
						Set xxSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xxSub))
						Quit:xxSub=""
			            Continue:IsLastOperInf=1
			            
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
						If (OpsEpisodeDr=aEpisodeID)&(OprInfDate="") {  // 本次就诊的手术,感染日期取第一条手术开始日期
							Set OprInfDate = IROperDate
						}
						If (OpsEpisodeDr'=aEpisodeID) {   // 历史就诊的手术
							Set IsLastOperInf=1
						}
					}
				}
				Continue:IsLastOperInf=1   //历史手术感染不计入本次感染
				Set:OprInfDate'="" InfDate=OprInfDate   //本次就诊为手术感染时，感染日期为手术日期
			
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
			   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
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
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
				If (aWardID'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardID)				
				}
				If (aLocID'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocID)
				}
				//转归情况
				Set InfEffect="",IRInfEffectData=""
				Set IRInfEffectDr=$lg(DiagsData,8)
				Set:IRInfEffectDr'="" IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
				Set InfEffect = $lg(IRInfEffectData,3)
				
				Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_RepUser
			}
		}
	}
	
	//判断本次就诊的手术是否被后面就诊感染信息关联，关联即按照手术日期统计本次就诊感染（历史回顾查看）
	Set LastAdmID=$o(^DHCHAI.IR.INFLastAdmI("IndexLastAdm",aEpisodeID,""))
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFLastAdm","U")," "_LastAdmID,xRepID))
		Quit:xRepID=""
		
		Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
		Continue:RepData=""
		Set InfRepType=$lg(RepData,3)
		Continue:(InfRepType'=1)  //感染报告 
			
		Set RepStatus=$lg(RepData,8)
		Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
		Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
		//报告日期
		Set RepDate=$lg(INFRepData,4)
		//报告人
		Set RepUser="",RepUserData=""
		Set RepUserDr=$lg(INFRepData,7)
		Set:RepUserDr'="" RepUserData=$g(^DHCHAI.BT.SysUserD(RepUserDr))
		Set RepUser=$lg(RepUserData,3)
		
		// 感染诊断信息
		Set LinkDiags=""
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xSub))
			Quit:xSub=""
	
			Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xRepID,"EXT",xSub))
			Continue:INFRepExtData=""
			Set DiagID=$lg(INFRepExtData,3)
			Continue:DiagID=""
			
			Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
			Continue:DiagsData=""
			Set InfPosDr = $lg(DiagsData,3)
			Continue:InfPosDr=""
			// 感染诊断
			Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPosDr))
			Set PosCode=$lg(InfPosData,2)
			Set BigCode=$e(PosCode,1,2)	
			Continue:BigCode=""
			Set PosDiagData=""
			Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
			Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
			Set PosDesc=$lg(PosDiagData,3)			
			// 感染日期
			Set InfDate  = $lg(DiagsData,5)
			Set InfXDate  = $lg(DiagsData,7)
			
			//判断历史就诊报告的感染报告是否手部位术感染，关联的手术是否是本次就诊的手术
			Set OprInfDate="",IsNowOperInf=0
			If ((PosDesc["表浅")||((PosDesc["深部"))||((PosDesc["器官和腔隙感染"))){
				Set xxSub=0
				For {
					Set xxSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xRepID,xxSub))
					Quit:xxSub=""
		            Continue:IsNowOperInf=1
		            
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xRepID,"EXT",xxSub))
					Continue:INFRepExtData=""
					Set xOPSID = $lg(INFRepExtData,3)
					Continue:xOPSID=""
					Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
					Continue:OPSData=""
					Set OpsEpisodeDr = $lg(OPSData,2)  // 手术对应的就诊号
					Set IROperDr     = $lg(OPSData,3)
					Set IROperDate   = $lg(OPSData,7)
					Continue:IROperDate=""
					If (OpsEpisodeDr=aEpisodeID)&(OprInfDate="") {  // 本次就诊的手术,感染日期取第一条手术开始日期
						Set OprInfDate = IROperDate
						Set IsNowOperInf=1				
					}
				}
			}
			Continue:IsNowOperInf'=1   //本次就诊的手术没有关联到历史就诊报告中
			Set:OprInfDate'="" InfDate=OprInfDate   //本次就诊为手术感染时，感染日期为手术日期
		
			Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
			Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
			//感染类别
			Set InfType="医院感染"
			Set InfTypeCode=$lg(DiagsData,18)
			if (InfTypeCode'=""){
				Set:InfTypeCode=0 InfType="社区感染"
			}else{
				Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
		   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
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
			Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
			If (aWardID'="") {
				Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
				Continue:(InfLocDr'=aWardID)				
			}
			If (aLocID'=""){
				Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
				Continue:(InfLocDr'=aLocID)
			}
			//转归情况
			Set InfEffect="",IRInfEffectData=""
			Set IRInfEffectDr=$lg(DiagsData,8)
			Set:IRInfEffectDr'="" IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
			Set InfEffect = $lg(IRInfEffectData,3)
			
			Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_RepUser
		}
	}
	

	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// Creator：     pylian    	
/// CreatDate：   2022-06-14
/// Description:  获取医院感染报告关联送检
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.SpeActInfSub).GetInfLabInfo("555")
ClassMethod GetInfLabInfo(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aLabTestSet As %Text = "", aDiagID As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aLabTestSet,aDiagID)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	Quit:aDateFrom>aDateTo return
	
	Set RepType="",Count=0
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:RepType'="1"
	
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Quit:'$IsObject(objINFRep)
			Set RepStatus=objINFRep.IRStatusDr
			Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
			Continue:RepStatus.BTCode'="3"
			// 感染诊断信息
			Set IsFlg=0
			Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			For indy = 1:1:$l(LinkDiags,",") {
				Set xDiagID = $p(LinkDiags,",",indy)
				Continue:xDiagID=""					    
			    Continue:(aDiagID'="")&(aDiagID'=xDiagID)
			    Set IsFlg=1	
			}
			Continue:IsFlg'=1
			// 送检信息
			Set LinkLabs = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
			Continue:LinkLabs=""
			
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
			    
			    Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(VisitNumberDr))
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
					Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",VisitNumberDr,xTestSetDesc))
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
					Set xTestCode=""
					For {
						Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",LabRepDr,xTestCode))
						Quit:xTestCode=""
						Quit:CheckFlg=1
					
						Set xMapItemDr=0
						For {
							Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
							Quit:xMapItemDr=""
							Continue:(aLabTestSet'="")&&((","_aLabTestSet_",")'[(","_xMapItemDr_","))
							Set CheckFlg = 1
							
							Set TestSetData=$g(^DHCHAI.DP.LabVisitTestSetD(xTestSetDr))
							Set TestSet=$lg(TestSetData,3)
							Quit										
						}
					}
				}
				Continue:CheckFlg=0	//过滤非指定类型的送检

				Set LabInfo=$lb(VisitNumberDr,EpisodeNo,CollDate,CollTime,Specimen,TestSet)
				Set Count=Count+1
				Do return.SetAt(LabInfo,Count)
			}
		}
	}
	    
	Quit return
}

}

/// 名称: DHCHAI.STATV2.S200FevBloSum
/// 描述: 住院患者体温异常血培养送检率统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S200FevBloSum Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-22
/// Description:  住院患者体温异常血培养送检率统计表(只考虑同病区、同科、同分组下的体温异常、血培养)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据   
///               aStatDimens:  展示维度    //add 20220927 
///               aLocIDs:    科室 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S200FevBloSum","QryFevBloSum","","2018-03-01","2019-12-30")
Query QryFevBloSum(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,AbnoCnt:%Integer,SubmitCnt:%Integer,AboSubmitRatio:%String") [ SqlProc ]
{
}

ClassMethod QryFevBloSumExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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

    Set NIndex="QryFevBloSum"
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
	
				Set (AbnoFlg,SubmitFlg)=0
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
					
					//获取体温异常信息
					Set AbnoArr=..GetFeverAbno(Paadm,DateFrom,DateTo)
					Set:AbnoArr.Count()>0 AbnoFlg=1
					//获取血送检记录
					If (AbnoFlg=1) {
						Set LabInfoArr=..GetLabInfo(Paadm,DateFrom,DateTo,"血","细菌检测")
						Set:LabInfoArr.Count()>0 SubmitFlg=1
					}
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
					//体温异常
					If (AbnoFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"AbnoFlg",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AbnoFlg"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"AbnoFlg",Paadm)=""
						}
					}
					//血培养
					If (SubmitFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"SubmitFlg",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SubmitFlg"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"SubmitFlg",Paadm)=""
						}
					}
					If (LocCount>1) {
						// 合计住院患者
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
						}
						// 合计体温异常
						If (AbnoFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","AbnoFlg",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","AbnoFlg"))
								Set ^TMP($zn,$j,NIndex,"Sum","AbnoFlg",Paadm)=""
							}
						}
						// 合计体温异常
						If (SubmitFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","SubmitFlg",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","SubmitFlg"))
								Set ^TMP($zn,$j,NIndex,"Sum","SubmitFlg",Paadm)=""
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
		Set PatAdmCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set AbnoCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"AbnoFlg"))  		//体温异常人数
		Set SubmitCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"SubmitFlg"))		//血培养人数
		Set (AboSubmitRatio)="0.00%"
		Set:AbnoCnt>0 AboSubmitRatio=$fn((SubmitCnt/AbnoCnt)*100,"",2)_"%" 			//体温异常血培养送检率
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(SubmitCnt=0)
		Continue:(aQryCon="3")&&(AbnoCnt=0)
	
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,AbnoCnt,SubmitCnt,AboSubmitRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	
	If (LocCount>1) {
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  		//在院患者数
		Set AbnoCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","AbnoFlg"))  		//体温异常人数
		Set SubmitCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","SubmitFlg"))		//血培养人数
		Set (AboSubmitRatio)="0.00%"
		Set:AbnoCnt>0 AboSubmitRatio=$fn((SubmitCnt/AbnoCnt)*100,"",2)_"%" 		//体温异常血培养送检率
		
		Set Data=$lb("","全部",PatAdmCnt,AbnoCnt,SubmitCnt,AboSubmitRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	  
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryFevBloSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFevBloSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFevBloSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFevBloSumExecute ]
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
/// CreatDate：   2019-11-21
/// Description:  住院患者体温异常血培养送检率统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220927 解决汇总按科室分组统计明细无法区分医院问题
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型    //add 20220927 解决汇总多科室合计没有维度拼接科室问题，防止科室、病区分组不一致时导致汇总与明细数据不一致
///               aLocIDs:   合计科室   
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S200FevBloSum","QryFevBloDtl","","2020-05-01","2020-05-31","0001-07-0000-G-3","W","","","")
Query QryFevBloDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aAbnoFlg As %String = "", aSubmitFlg As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AbnoResult:%String,AbnoActDateTime:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,LabTestSetDesc:%String,Specimen:%String,Bacterias:%String,MRBTpDescs:%String,LabInfType:%String,AbnoFlg:%String,SubmitFlg:%String") [ SqlProc ]
{
}

ClassMethod QryFevBloDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aAbnoFlg As %String = "", aSubmitFlg As %String = "") As %Status
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
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
	//检出菌监测项目
    Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))

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
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
				}
		
				//获取病人基本信息
				Set PatData =..BuildPaadmData(Paadm)
				Continue:PatData=""
				Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 			Set AdmTimes = $lg(PAAdmData,38)   //就诊次数

				//组织输出转科明细以及限制、特殊抗菌药物情况
				Set (AbnoFlg,SubmitFlg)=0  //update 20221201 不判断送检与体温异常是否同一科室或同一次转科
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
					
					
					Set (AbnoInfos,AbnoInfo,LabInfos,LabInfo)=""
					//获取体温异常信息
					Set AbnoArr=..GetFeverAbno(Paadm,DateFrom,DateTo)
					Set:AbnoArr.Count()>0 AbnoFlg=1
					Continue:(aAbnoFlg'="")&&(aAbnoFlg'=AbnoFlg)
					For AbnoInd=1:1:AbnoArr.Count(){
						//获取体温明细
						Set AbnoInfo=AbnoArr.GetAt(AbnoInd)
						Set AbnoResult=$li(AbnoInfo,1)_"℃"
						Set AbnoActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml($li(AbnoInfo,2))
						Set AbnoActTime=$zt($li(AbnoInfo,3))
						Set AbnoInfo=$lb(AbnoResult,AbnoActDate_" "_AbnoActTime)
						Set AbnoInfos=AbnoInfos_$lb(AbnoInfo)	
					}
					//获取血送检记录以及结果
					If (AbnoFlg=1) {
						Set LabInfoArr=..GetLabInfo(Paadm,DateFrom,DateTo,"血","细菌检测")
						Set:LabInfoArr.Count()>0 SubmitFlg=1
						Continue:(aSubmitFlg'="")&&(aSubmitFlg'=SubmitFlg)
						For LabInd=1:1:LabInfoArr.Count(){
							//获取送检结果明细
							Set (ResultList,LabResultInfo)=""
							Set SubLabInfo=LabInfoArr.GetAt(LabInd)
							Set VisitNumberID = $lg(SubLabInfo,1)
							Set EpisodeNo	  = $lg(SubLabInfo,5)
							Set CollDate 	  = $lg(SubLabInfo,2)
							Set CollTime	  = $lg(SubLabInfo,6)
							Set Specimen      = $lg(SubLabInfo,3)
							Set TestSet       = $lg(SubLabInfo,7)
						
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
					}
					Set Len=$ll(AbnoInfos)
					Set:(Len<$ll(LabInfos)) Len=$ll(LabInfos)

					Set AbnoFlg		= $Case(AbnoFlg,1:"是",0:"","":"")
					Set SubmitFlg	= $Case(SubmitFlg,1:"是",0:"","":"")
					If (Len>0) {
						For LenInd=1:1:Len {
							Set AbnoInfo=$lg(AbnoInfos,LenInd)
							Set:AbnoInfo="" AbnoInfo=$lb("","")
							Set LabInfo=$lg(LabInfos,LenInd)
							Set:LabInfo="" LabInfo=$lb("","","","","","","","","")
							Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_AbnoInfo_LabInfo_$lb(AbnoFlg,SubmitFlg)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					} Else{  //针对没有体温异常、送检数据的情况处理
						Set AbnoInfo=$lb("","")
						Set LabInfo=$lb("","","","","","","","","")
						Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_AbnoInfo_LabInfo_$lb(AbnoFlg,SubmitFlg)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
		    }
		}
    }
	Quit $$$OK
}

ClassMethod QryFevBloDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFevBloDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFevBloDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFevBloDtlExecute ]
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

/// 名称: DHCHAI.STATV2.S040MRBInf
/// 描述: 多重耐药菌医疗机构感染发生率
/// 编写者: zhoubo(ShenC改造)
/// 编写日期: 2022-11-15
Class DHCHAI.STATV2.S040MRBInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		zhoubo(ShenC改造)
/// CreateDate：	2022-11-15
/// Description:	多重耐药菌医疗机构感染发生率(按系统参数'MDROInfRatioHAType'判断HA)
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期  
/// 			  	aLocType ：科室/病区类型
/// 			  	aQryCon：  有效数据筛查  
///              	aStatDimens:  展示维度
///               	aLocIDs:    科室
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S040MRBInf","QryMRBInf","1","2020-05-01","2020-05-31","W","2","HGW","")
Query QryMRBInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,M1Pat:%Integer,M1PatCase:%Integer,M1PatRatio:%String,M1CaseRatio:%String,M2Pat:%Integer,M2PatCase:%Integer,M2PatRatio:%String,M2CaseRatio:%String,M3Pat:%Integer,M3PatCase:%Integer,M3PatRatio:%String,M3CaseRatio:%String,M4Pat:%Integer,M4PatCase:%Integer,M4PatRatio:%String,M4CaseRatio:%String,M5Pat:%Integer,M5PatCase:%Integer,M5PatRatio:%String,M5CaseRatio:%String,M6Pat:%Integer,M6PatCase:%Integer,M6PatRatio:%String,M6CaseRatio:%String,M7Pat:%Integer,M7PatCase:%Integer,M7PatRatio:%String,M7CaseRatio:%String,M8Pat:%Integer,M8PatCase:%Integer,M8PatRatio:%String,M8CaseRatio:%String,M9Pat:%Integer,M9PatCase:%Integer,M9PatRatio:%String,M9CaseRatio:%String,MPat:%Integer,MPatCase:%Integer") [ SqlProc ]
{
}

ClassMethod QryMRBInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
 	
 	Set NIndex="QryMRBInf"
	Kill ^TMP($zn,$j,NIndex)
	//HA判断方式--1：只取院感报告关联数据，2：只取感染标记数据，0或其他：取所有类型数据
	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	//统计九大重点菌
	Set MRBList="M1^M2^M3^M4^M5^M6^M7^M8^M9"
	
	//同期在科
	Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType			//过滤科室类型
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))		//过滤科室
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set HospDr=$lg(LocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)				//过滤院区
			
			Set GroupDr  = $lg(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}	
			Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
		    For index1=1:1:ListLocArray.Count() {
				Set TransInfo=ListLocArray.GetAt(index1)
				Continue:TransInfo=""
				
				Set Paadm      = $lg(TransInfo,1)
				Set LocID      = $lg(TransInfo,2)
				Set TransType  = $lg(TransInfo,3)
				Set LnkLocDr   = $lg(TransInfo,5)
				Set TransIDs   = $lg(TransInfo,6)
				If TransType="E" {
					Set LocDr  = LocID
					Set WardDr = ""
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
				}
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
				    Set TransDate	= $lg(TranData,7)		//转科日期
				    Set OutLocDate	= $lg(TranData,10)		//转科时间
				    Set TransTime	= $lg(TranData,8)		//出科日期
					Set OutLocTime	= $lg(TranData,11)		//出科时间
					//如果转科起止日期大于统计日期，以统计日期计算
					Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
					Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom="0"
					Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo="86399"
					
					//患者多耐信息
	    			Set ListMRBArray=..GetPatMRBInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
	    			For xMRBID=1:1:ListMRBArray.Count() {
						Set MRBInfo=ListMRBArray.GetAt(xMRBID)	
						Continue:MRBInfo=""
						
						Set ResID	   = $lg(MRBInfo,1)		//ID
						If (IsUnRepeat="1"){
							//保留UnRepeatType规则的第一株'多耐'
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"2")
							Continue:IsFirstSend'=1
						}
					
						Set MRBCode    = $lg(MRBInfo,2)		//多耐1->Code
						Set MRBDesc    = $lg(MRBInfo,3)		//多耐1->名称
						Set MRB2Code   = $lg(MRBInfo,4)		//多耐2->Code
						Set MRB2Desc   = $lg(MRBInfo,5)		//多耐2->名称
						Set BacDesc    = $lg(MRBInfo,7)		//细菌名称
						Set IsInfMRBFlag = $lg(MRBInfo,11)	//院感
						Continue:BacDesc=""
						Continue:IsInfMRBFlag'=1			//过滤非院感多耐
						
						If (MRBCode'=""){
							//同期检出导致医院感染的多耐人数
							Set MIndex=MRBCode_"Pat"
							If '$d(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)){
								Set ^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)=""
								
								Set num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MIndex))
							}
							//总人数
							If '$d(^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)){
								Set ^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)=""
								
								//总人数
								Set:MRBList[MRBCode num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPat"))
							}
							
							//同期检出导致医院感染的多耐例次数
							Set MCIndex=MRBCode_"PatCase"
							Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MCIndex))
							//总例数
							Set:MRBList[MRBCode num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPatCase"))
						}
						If (MRB2Code'=""){
							Set MIndex=MRB2Code_"Pat"
							If '$d(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)){
								Set ^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)=""
								
								Set num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MIndex))
							}
							//总人数
							If '$d(^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)){
								Set ^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)=""
								
								//总人数
								Set:MRBList[MRB2Code num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPat"))
							}
							
							Set MCIndex=MRB2Code_"PatCase"
							Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MCIndex))
							//总例数
							Set:MRBList[MRB2Code num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPatCase"))
						}
					}
				}
				//统计维度(记录数据)
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					// 住院患者人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
						Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
						
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
					}
					// 感染相关多耐
					If ($d(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm))){
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)){
							Set ^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)=""
							//人数
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M1PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M1PatAdm",Paadm)=""
								
								Set ^TMP($zn,$j,NIndex,DimensKey,"M1Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M1Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M1Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M2PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M2PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M2Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M2Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M2Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M3PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M3PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M3Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M3Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M3Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M4PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M4PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M4Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M4Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M4Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M5PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M5PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M5Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M5Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M5Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M6PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M6PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M6Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M6Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M6Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M7PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M7PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M7Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M7Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M7Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M8PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M8PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M8Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M8Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M8Pat"))
							}
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"M9PatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"M9PatAdm",Paadm)=""
							
								Set ^TMP($zn,$j,NIndex,DimensKey,"M9Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M9Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M9Pat"))
							}
							//合计人数
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"SumPatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"SumPatAdm",Paadm)=""
								
								Set ^TMP($zn,$j,NIndex,DimensKey,"MPat")=$g(^TMP($zn,$j,NIndex,DimensKey,"MPat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPat"))
							}
							
							//例次数
							Set ^TMP($zn,$j,NIndex,DimensKey,"M1PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M1PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M1PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M2PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M2PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M2PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M3PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M3PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M3PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M4PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M4PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M4PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M5PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M5PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M5PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M6PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M6PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M6PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M7PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M7PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M7PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M8PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M8PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M8PatCase"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"M9PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M9PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M9PatCase"))
							
							Set ^TMP($zn,$j,NIndex,DimensKey,"MPatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"MPatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPatCase"))
						}
					}
					If (LocCount>1) {
						// 合计住院患者
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
							
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
						}
						// 合计感染相关多耐
						If ($d(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm))){
							If '$d(^TMP($zn,$j,NIndex,"Sum","LocPatAdm",LocID,Paadm)){
								Set ^TMP($zn,$j,NIndex,"Sum","LocPatAdm",LocID,Paadm)=""
								//人数
								If '$d(^TMP($zn,$j,NIndex,"Sum","M1PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M1PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M1Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M1Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M1Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M2PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M2PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M2Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M2Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M2Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M3PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M3PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M3Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M3Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M3Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M4PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M4PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M4Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M4Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M4Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M5PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M5PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M5Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M5Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M5Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M6PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M6PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M6Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M6Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M6Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M7PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M7PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M7Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M7Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M7Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M8PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M8PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M8Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M8Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M8Pat"))
								}
								If '$d(^TMP($zn,$j,NIndex,"Sum","M9PatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","M9PatAdm",Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,"Sum","M9Pat")=$g(^TMP($zn,$j,NIndex,"Sum","M9Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M9Pat"))
								}
								//合计人数
								If '$d(^TMP($zn,$j,NIndex,"Sum","MPatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","MPatAdm",Paadm)=""
								
									Set ^TMP($zn,$j,NIndex,"Sum","MPat")=$g(^TMP($zn,$j,NIndex,"Sum","MPat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPat"))
								}
								
								//例次数
								Set ^TMP($zn,$j,NIndex,"Sum","M1PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M1PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M1PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M2PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M2PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M2PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M3PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M3PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M3PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M4PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M4PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M4PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M5PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M5PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M5PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M6PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M6PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M6PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M7PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M7PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M7PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M8PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M8PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M8PatCase"))
								Set ^TMP($zn,$j,NIndex,"Sum","M9PatCase")=$g(^TMP($zn,$j,NIndex,"Sum","M9PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M9PatCase"))
								
								Set ^TMP($zn,$j,NIndex,"Sum","MPatCase")=$g(^TMP($zn,$j,NIndex,"Sum","MPatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MPatCase"))
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
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))		//过滤科室
		
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))					//单院区不显示全院
		Continue:xDimensKey=""
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))    	//住院患者人数
		Set M1Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1Pat"))     	//同期检出导致医院感染的M1的人数
		Set M1PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1PatCase")) 	//同期检出导致医院感染的M1的例次数
		Set M1PatRatio="0.00%"
		Set:PatAdmCnt>0 M1PatRatio=$fn((M1Pat/PatAdmCnt)*100,"",2)_"%"	 	//M1医院感染发生率
		Set M1CaseRatio="0.00%"
		Set:PatAdmCnt>0 M1CaseRatio=$fn((M1PatCase/PatAdmCnt)*100,"",2)_"%" //M1医院感染例次发生率
		
		Set M2Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2Pat"))     	//同期检出导致医院感染的M2的人数
		Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2PatCase")) 	//同期检出导致医院感染的M2的例次数
		Set M2PatRatio="0.00%"
		Set:PatAdmCnt>0 M2PatRatio=$fn((M2Pat/PatAdmCnt)*100,"",2)_"%" 		//M2医院感染发生率
		Set M2CaseRatio="0.00%"
		Set:PatAdmCnt>0 M2CaseRatio=$fn((M2PatCase/PatAdmCnt)*100,"",2)_"%" //M2医院感染例次发生率
		
		Set M3Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3Pat"))     	//同期检出导致医院感染的M3的人数
		Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3PatCase")) 	//同期检出导致医院感染的M3的例次数
		Set M3PatRatio="0.00%"
		Set:PatAdmCnt>0 M3PatRatio=$fn((M3Pat/PatAdmCnt)*100,"",2)_"%" 		//M3医院感染发生率
		Set M3CaseRatio="0.00%"
		Set:PatAdmCnt>0 M3CaseRatio=$fn((M3PatCase/PatAdmCnt)*100,"",2)_"%" //M3医院感染例次发生率
		
		Set M4Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M4Pat"))     	//同期检出导致医院感染的M4的人数
		Set M4PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M4PatCase")) 	//同期检出导致医院感染的M4的例次数
		Set M4PatRatio="0.00%"
		Set:PatAdmCnt>0 M4PatRatio=$fn((M4Pat/PatAdmCnt)*100,"",2)_"%" 		//M4医院感染发生率
		Set M4CaseRatio="0.00%"
		Set:PatAdmCnt>0 M4CaseRatio=$fn((M4PatCase/PatAdmCnt)*100,"",2)_"%" //M4医院感染例次发生率
		
		Set M5Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M5Pat"))     	//同期检出导致医院感染的M5的人数
		Set M5PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M5PatCase")) 	//同期检出导致医院感染的M5的例次数
		Set M5PatRatio="0.00%"
		Set:PatAdmCnt>0 M5PatRatio=$fn((M5Pat/PatAdmCnt)*100,"",2)_"%" 		//M5医院感染发生率
		Set M5CaseRatio="0.00%"
		Set:PatAdmCnt>0 M5CaseRatio=$fn((M5PatCase/PatAdmCnt)*100,"",2)_"%" //M5医院感染例次发生率
		
		Set M6Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6Pat"))     	//同期检出导致医院感染的M6的人数
		Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6PatCase")) 	//同期检出导致医院感染的M6的例次数
		Set M6PatRatio="0.00%"
		Set:PatAdmCnt>0 M6PatRatio=$fn((M6Pat/PatAdmCnt)*100,"",2)_"%" 		//M6医院感染发生率
		Set M6CaseRatio="0.00%"
		Set:PatAdmCnt>0 M6CaseRatio=$fn((M6PatCase/PatAdmCnt)*100,"",2)_"%" //M6医院感染例次发生率
		
		Set M7Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7Pat"))     	//同期检出导致医院感染的M7的人数
		Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7PatCase")) 	//同期检出导致医院感染的M7的例次数
		Set M7PatRatio="0.00%"
		Set:PatAdmCnt>0 M7PatRatio=$fn((M7Pat/PatAdmCnt)*100,"",2)_"%" 		//M7医院感染发生率
		Set M7CaseRatio="0.00%"
		Set:PatAdmCnt>0 M7CaseRatio=$fn((M7PatCase/PatAdmCnt)*100,"",2)_"%" //M7医院感染例次发生率
		
		Set M8Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8Pat"))     	//同期检出导致医院感染的M8的人数
		Set M8PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8PatCase")) 	//同期检出导致医院感染的M8的例次数
		Set M8PatRatio="0.00%"
		Set:PatAdmCnt>0 M8PatRatio=$fn((M8Pat/PatAdmCnt)*100,"",2)_"%" 		//M8医院感染发生率
		Set M8CaseRatio="0.00%"
		Set:PatAdmCnt>0 M8CaseRatio=$fn((M8PatCase/PatAdmCnt)*100,"",2)_"%" //M8医院感染例次发生率
		
		Set M9Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9Pat"))     	//同期检出导致医院感染的M9的人数
		Set M9PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9PatCase")) 	//同期检出导致医院感染的M9的例次数
		Set M9PatRatio="0.00%"
		Set:PatAdmCnt>0 M9PatRatio=$fn((M9Pat/PatAdmCnt)*100,"",2)_"%" 		//M9医院感染发生率
		Set M9CaseRatio="0.00%"
		Set:PatAdmCnt>0 M9CaseRatio=$fn((M9PatCase/PatAdmCnt)*100,"",2)_"%" //M9医院感染例次发生率
		//同期检出导致医院感染的的人数
		Set MPat=+$g(^TMP($zn,$j,NIndex,xDimensKey,"MPat")) 	
		//同期检出导致医院感染的的例次数
		Set MPatCase=+$g(^TMP($zn,$j,NIndex,xDimensKey,"MPatCase"))	
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)	
		Continue:(aQryCon="2")&&(MPat=0)
		Continue:(aQryCon="3")&&(PatAdmCnt=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,M1Pat,M1PatCase,M1PatRatio,M1CaseRatio,M2Pat,M2PatCase,M2PatRatio,M2CaseRatio,M3Pat,M3PatCase,M3PatRatio,M3CaseRatio,M4Pat,M4PatCase,M4PatRatio,M4CaseRatio,M5Pat,M5PatCase,M5PatRatio,M5CaseRatio,M6Pat,M6PatCase,M6PatRatio,M6CaseRatio,M7Pat,M7PatCase,M7PatRatio,M7CaseRatio,M8Pat,M8PatCase,M8PatRatio,M8CaseRatio,M9Pat,M9PatCase,M9PatRatio,M9CaseRatio,MPat,MPatCase)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (LocCount>1) {
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))    			//住院患者人数
		Set M1Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M1Pat"))     			//同期检出导致医院感染的M1的人数
		Set M1PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M1PatCase")) 			//同期检出导致医院感染的M1的例次数
		Set M1PatRatio="0.00%"
		Set:PatAdmCnt>0 M1PatRatio=$fn((M1Pat/PatAdmCnt)*100,"",2)_"%"	 	//M1医院感染发生率
		Set M1CaseRatio="0.00%"
		Set:PatAdmCnt>0 M1CaseRatio=$fn((M1PatCase/PatAdmCnt)*100,"",2)_"%" //M1医院感染例次发生率
		
		Set M2Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M2Pat"))     			//同期检出导致医院感染的M2的人数
		Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M2PatCase")) 			//同期检出导致医院感染的M2的例次数
		Set M2PatRatio="0.00%"
		Set:PatAdmCnt>0 M2PatRatio=$fn((M2Pat/PatAdmCnt)*100,"",2)_"%" 		//M2医院感染发生率
		Set M2CaseRatio="0.00%"
		Set:PatAdmCnt>0 M2CaseRatio=$fn((M2PatCase/PatAdmCnt)*100,"",2)_"%" //M2医院感染例次发生率
		
		Set M3Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M3Pat"))     			//同期检出导致医院感染的M3的人数
		Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M3PatCase")) 			//同期检出导致医院感染的M3的例次数
		Set M3PatRatio="0.00%"
		Set:PatAdmCnt>0 M3PatRatio=$fn((M3Pat/PatAdmCnt)*100,"",2)_"%" 		//M3医院感染发生率
		Set M3CaseRatio="0.00%"
		Set:PatAdmCnt>0 M3CaseRatio=$fn((M3PatCase/PatAdmCnt)*100,"",2)_"%" //M3医院感染例次发生率
		
		Set M4Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M4Pat"))     			//同期检出导致医院感染的M4的人数
		Set M4PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M4PatCase")) 			//同期检出导致医院感染的M4的例次数
		Set M4PatRatio="0.00%"
		Set:PatAdmCnt>0 M4PatRatio=$fn((M4Pat/PatAdmCnt)*100,"",2)_"%" 		//M4医院感染发生率
		Set M4CaseRatio="0.00%"
		Set:PatAdmCnt>0 M4CaseRatio=$fn((M4PatCase/PatAdmCnt)*100,"",2)_"%" //M4医院感染例次发生率
		
		Set M5Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M5Pat"))     			//同期检出导致医院感染的M5的人数
		Set M5PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M5PatCase")) 			//同期检出导致医院感染的M5的例次数
		Set M5PatRatio="0.00%"
		Set:PatAdmCnt>0 M5PatRatio=$fn((M5Pat/PatAdmCnt)*100,"",2)_"%" 		//M5医院感染发生率
		Set M5CaseRatio="0.00%"
		Set:PatAdmCnt>0 M5CaseRatio=$fn((M5PatCase/PatAdmCnt)*100,"",2)_"%" //M5医院感染例次发生率
		
		Set M6Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M6Pat"))     			//同期检出导致医院感染的M6的人数
		Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M6PatCase")) 			//同期检出导致医院感染的M6的例次数
		Set M6PatRatio="0.00%"
		Set:PatAdmCnt>0 M6PatRatio=$fn((M6Pat/PatAdmCnt)*100,"",2)_"%" 		//M6医院感染发生率
		Set M6CaseRatio="0.00%"
		Set:PatAdmCnt>0 M6CaseRatio=$fn((M6PatCase/PatAdmCnt)*100,"",2)_"%" //M6医院感染例次发生率
		
		Set M7Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M7Pat"))     			//同期检出导致医院感染的M7的人数
		Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M7PatCase")) 			//同期检出导致医院感染的M7的例次数
		Set M7PatRatio="0.00%"
		Set:PatAdmCnt>0 M7PatRatio=$fn((M7Pat/PatAdmCnt)*100,"",2)_"%" 		//M7医院感染发生率
		Set M7CaseRatio="0.00%"
		Set:PatAdmCnt>0 M7CaseRatio=$fn((M7PatCase/PatAdmCnt)*100,"",2)_"%" //M7医院感染例次发生率
		
		Set M8Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M8Pat"))     			//同期检出导致医院感染的M8的人数
		Set M8PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M8PatCase")) 			//同期检出导致医院感染的M8的例次数
		Set M8PatRatio="0.00%"
		Set:PatAdmCnt>0 M8PatRatio=$fn((M8Pat/PatAdmCnt)*100,"",2)_"%" 		//M8医院感染发生率
		Set M8CaseRatio="0.00%"
		Set:PatAdmCnt>0 M8CaseRatio=$fn((M8PatCase/PatAdmCnt)*100,"",2)_"%" //M8医院感染例次发生率
		
		Set M9Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M9Pat"))     			//同期检出导致医院感染的M9的人数
		Set M9PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M9PatCase")) 			//同期检出导致医院感染的M9的例次数
		Set M9PatRatio="0.00%"
		Set:PatAdmCnt>0 M9PatRatio=$fn((M9Pat/PatAdmCnt)*100,"",2)_"%" 		//M9医院感染发生率
		Set M9CaseRatio="0.00%"
		Set:PatAdmCnt>0 M9CaseRatio=$fn((M9PatCase/PatAdmCnt)*100,"",2)_"%" //M9医院感染例次发生率
		//同期检出导致医院感染的的人数
		Set MPat=+$g(^TMP($zn,$j,NIndex,"Sum","MPat")) 		
		//同期检出导致医院感染的的例次数
		Set MPatCase=+$g(^TMP($zn,$j,NIndex,"Sum","MPatCase"))	
		
		Set Data=$lb("","全部",PatAdmCnt,M1Pat,M1PatCase,M1PatRatio,M1CaseRatio,M2Pat,M2PatCase,M2PatRatio,M2CaseRatio,M3Pat,M3PatCase,M3PatRatio,M3CaseRatio,M4Pat,M4PatCase,M4PatRatio,M4CaseRatio,M5Pat,M5PatCase,M5PatRatio,M5CaseRatio,M6Pat,M6PatCase,M6PatRatio,M6CaseRatio,M7Pat,M7PatCase,M7PatRatio,M7CaseRatio,M8Pat,M8PatCase,M8PatRatio,M8CaseRatio,M9Pat,M9PatCase,M9PatRatio,M9CaseRatio,MPat,MPatCase)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryMRBInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfExecute ]
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

/// Creator：		zhoubo(ShenC改造)
/// CreateDate：	2022-11-15
/// Description:	多重耐药菌感染发现率分子明细表(按系统参数'MDROInfRatioHAType'判断HA)
/// Input:		    aHospIDs：院区
/// 				aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 维度
/// 				aLocType：统计类型
/// 				aLocIDs：科室
/// 			    aMRBCode : 多耐分类代码
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S040MRBInf","QryMRBInfDtl","2020-07-01","2021-07-31","0001-07-0178-W-4","M3","W")
Query QryMRBInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBCode As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//处理日期
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
   
   	//HA判断方式--1：只取院感报告关联数据，2：只取感染标记数据，0或其他：取所有类型数据
	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	//统计九大重点菌
	Set MRBList="M1^M2^M3^M4^M5^M6^M7^M8^M9"
	
	//同期在科
	Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType			//过滤科室类型
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocDr'="")&(aLocDr'=xLocID)
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))		//过滤科室
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set HospDr=$lg(LocData,8)
			Continue:HospDr=""
			//过滤院区
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)				
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
	
			Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
		    For index1=1:1:ListLocArray.Count() {
				Set TransInfo=ListLocArray.GetAt(index1)
				Continue:TransInfo=""
				
				Set Paadm      = $lg(TransInfo,1)
				Set LocID      = $lg(TransInfo,2)
				Set TransType  = $lg(TransInfo,3)
				Set LnkLocDr   = $lg(TransInfo,5)
				Set TransIDs   = $lg(TransInfo,6)
				Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2
				//存储患者基本信息
				Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
	   			Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	            Set AdmTimes = $lg(AdmData,38)   	//就诊次数
	   			
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
				    Set TransDate	= $lg(TranData,7)		//转科日期
				    Set OutLocDate	= $lg(TranData,10)		//转科时间
				    Set TransTime	= $lg(TranData,8)		//出科日期
					Set OutLocTime	= $lg(TranData,11)		//出科时间
					//如果转科起止日期大于统计日期，以统计日期计算
					Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
					Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom="0"
					Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo="86399"
					
					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					//存储转科基本信息
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
					
					//患者多耐信息
	    			Set ListMRBArray=..GetPatMRBInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
	    			For xMRBID=1:1:ListMRBArray.Count() {
						Set MRBInfo=ListMRBArray.GetAt(xMRBID)	
						Continue:MRBInfo=""
						
						Set ResID	   = $lg(MRBInfo,1)		//ID
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"2")
							Continue:IsFirstSend'=1
						}
						
						Set IsInfMRBFlag = $lg(MRBInfo,11)	//院感
						Continue:IsInfMRBFlag'=1			//过滤非院感多耐
						Set BacDesc    = $lg(MRBInfo,7)		//细菌名称
						Continue:BacDesc=""
						Set MRBCode    = $lg(MRBInfo,2)		//多耐1->Code
						Set MRBDesc    = $lg(MRBInfo,3)		//多耐1->名称
						Set MRB2Code   = $lg(MRBInfo,4)		//多耐2->Code
						Set MRB2Desc   = $lg(MRBInfo,5)		//多耐2->名称
						Continue:(MRBCode="")&&(MRB2Code="")
						
						//过滤多耐类别
						Continue:(aMRBCode'="")&&(aMRBCode'=MRBCode)&&(aMRBCode'=MRB2Code)
						//过滤多耐类别(汇总-只统计九大重点菌)
						Continue:(aMRBCode="")&&(MRBList'[MRBCode)&&(MRBList'[MRB2Code)
						
						Set:MRB2Desc'="" MRBDesc=MRBDesc_"|"_MRB2Desc	//合并
						Set SpeDesc    = $lg(MRBInfo,6)		//标本名称
						Set ActDateTime=$lg(MRBInfo,8)		//送检日期
						Set RepDateTime=$lg(MRBInfo,9)		//报告日期
						Set LabEpisodeNo=$lg(MRBInfo,15)	//标本号
						Set LabTestSet=$lg(MRBInfo,16)		//检验医嘱
						//存储检验相关信息
						Set LabInfo=$lb(ResID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpeDesc,BacDesc,"HA")
						
						Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_LabInfo
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
		    }
		}
	}
	
	Quit $$$OK
}

ClassMethod QryMRBInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfDtlExecute ]
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

/// Creator：     zhoubo(ShenC改造)
/// CreatDate：   2022-11-15
/// Description:  住院患者明细表(分母)
/// Table：       DHCHAI.DP.PAAdm
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey:维度
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S040MRBInf","QryMRBInfPatDtl","","2020-05-01","2020-05-31","0000-00-0000-A-1","E")
Query QryMRBInfPatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//处理日期
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
				Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2
				
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
					
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)	
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
				
	}
	Quit $$$OK
}

ClassMethod QryMRBInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfPatDtlExecute ]
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

/// Creator：     zhoubo(ShenC改造)
/// CreatDate：   2022-11-15
/// Description:  获取患者检出菌(多耐)信息
/// Table：       DHCHAI.IR.CCResult
/// Input:        aEpisodeID：就诊ID
/// 				  aDateFrom:开始日期
/// 				  aDateTo:结束日期
/// 				  aTimeFrom:开始时间
/// 				  aTimeTo:结束时间
/// 				  aHAType:感染类型
/// return:       多耐信息
/// zw ##class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo("3220",$zdh("2020-10-01",3),$zdh("2020-10-31",3),$zth("00:00:00"),$zth("23:59:59"),"","")
ClassMethod GetPatMRBInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aHAType As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aHAType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	Quit:(aDateFrom=aDateTo)&&(aTimeFrom>aTimeTo) return
	//计数
	Set Count=0
	//循环监控结果表(取检验信息)
    Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID))
		Quit:xItemID=""
		//过滤非'检出菌'+'常规检验异常'项目
		Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
		Continue:ItemData=""
		Set ItemCode=$lg(ItemData,2)
		Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")
		
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xDate,xID))
				Quit:xID=""
			
				Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
				Continue:RstData=""
				//过滤无效数据
				Continue:$lg(RstData,14)'=1	
						
				Set ActDate=$lg(RstData,8)			//送检日期		
				Set ActTime=$lg(RstData,9)			//送检时间
				Set ActDateTime =$zd(ActDate,3)_" "_$zt(ActTime,1)
				Set RepDate =$lg(RstData,11)		//报告日期
				Set RepTime =$lg(RstData,12)		//报告时间
				Set RepDateTime=$zd(RepDate,3)_" "_$zt(RepTime,1)
				//过滤'非时间范围内'检出
				Continue:(ActDate<aDateFrom)||(ActDate>aDateTo)
				Continue:(ActDate=aDateFrom)&&(ActTime<aTimeFrom)
				Continue:(ActDate=aDateTo)&&(ActTime>aTimeTo)
				
				//标本基本信息
				Set SCode    = $lg(RstData,17)		// 子系统代码(LIS01)
		        Set Specimen = $lg(RstData,22)		// 原始标本名称
		        Set SpeID="",SpeCode="",SpeDesc=""
		        Set SpeMapID = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
				If (SpeMapID'="") {
					Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpeMapID))
					Set MapItemDr = $lg(SpecMapData,3)
					If (MapItemDr'="") {
						Set SpeID=MapItemDr
						Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
						Set:SpecData'="" SpeCode = $lg(SpecData,2)
						Set:SpecData'="" SpeDesc = $lg(SpecData,3)		//标本名称(对照后)
					}
				}
				//未对照取原始标本名称
				Set:SpeDesc="" SpeDesc=Specimen
				
				//细菌基本信息(过滤'未对照'+'非多耐对应细菌')
				Set Bacteria = $lg(RstData,23)    	//原始细菌名称
		        Continue:Bacteria=""
		        Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria) 	//去掉特殊字行
		       	Set BactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,0))
				Continue:BactMapID=""
				Set BactMapData = $g(^DHCHAI.DP.LabBactMapD(BactMapID))
				Set BacID = $lg(BactMapData,3)
				Continue:BacID=""
				Set BactData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Continue:BactData=""
				Set BacCode = $lg(BactData,2)
				Set BacDesc = $lg(BactData,3)		//细菌名称(对照后)
				//过滤非多耐关联菌--统计报表
				Continue:'$d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID))
				//细菌关联多耐类别
				Set MRBTypeList=""
				Set xMRBTypeID=""
				For {
					Set xMRBTypeID=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID,xMRBTypeID))
					Quit:xMRBTypeID=""
					
					Set RuleMRBInfo=$g(^DHCHAI.IR.CRuleMRBD(xMRBTypeID))
					Continue:RuleMRBInfo=""
					Continue:$lg(RuleMRBInfo,4)'=1   //过滤非有效标记
					
					Set MRBType=$lg(RuleMRBInfo,2)
					Set MRBTypeList=MRBTypeList_","_MRBType
				}
				Set:MRBTypeList'="" MRBTypeList=$e(MRBTypeList,2,$l(MRBTypeList))
				
				//多耐基本信息
				Set MRBFlag=0						//多耐菌标志
				Set (MRBID,MRBCode,MRBDesc,MRB2ID,MRB2Code,MRB2Desc)=""
				
				Set MRBTpDr=$lg(RstData,24)			//多耐类型-1
				If (MRBTpDr) {
					Set MRBInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
					Set MRBID    = MRBTpDr
					Set MRBDesc  = $lg(MRBInfo,3)
					Set MRBCode  = $lg(MRBInfo,2)
				}
				Set MRBTp2Dr=$lg(RstData,31)		//多耐类型-2
				If (MRBTp2Dr) {
					Set MRB2Info=$g(^DHCHAI.IR.CRuleMRBD(MRBTp2Dr))
					Set MRB2ID    = MRBTp2Dr
					Set MRB2Desc  = $lg(MRB2Info,3)
					Set MRB2Code  = $lg(MRB2Info,2)
				}
				Set:(MRBDesc'="")||(MRB2Desc'="") MRBFlag=1
				
				//判断'院感'(aHAType--1：只取院感报告关联数据，2：只取感染标记数据，0：取所有类型数据
				Set IsInfMRBFlag=0
				
				Set ResultID=$p($lg(RstData,19),"=",2)  	//检验结果ID	
				//检验结果
				Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
				Continue:RepRstData=""
				//检验报告
				Set LabReportDr     = $lg(RepRstData,2)		
				Set LabReportData   = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
				Continue:LabReportData=""			
				//检验医嘱
				Set LabTestSet=""	
				Set LabTestSetID	= $lg(LabReportData,13)	
				If (LabTestSetID'=""){
					Set LabTestSet=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetID)),3)
				}
				//检验标本
				Set LabVisitID  	= $lg(LabReportData,2)	
				Set LabVisitData   	= $g(^DHCHAI.DP.LabVisitNumberD(LabVisitID))
				Continue:LabVisitData=""	
				Set LabEpisodeNo	= $lg(LabVisitData,3)	//标本号
				
				Set LabInfType       = $lg(RepRstData,13)   //感染类型-->标记数据
				If (aHAType="2"){
					//2:判断院感->感染标记'HA'
					Set:LabInfType=1 IsInfMRBFlag=1    
				}
				else{
					//1:判断院感->院感报告关联
					Set xINFId=""            
					For{
						Set xINFId=$o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",aEpisodeID,LabReportDr,xINFId))
						Quit:xINFId=""
						Continue:IsInfMRBFlag=1
											
						Set xReport=""
						For{
							Set xReport=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," DHCHAI.IR.INFLAB"," "_xINFId,xReport))
							Quit:xReport=""
			
							Set ReportInfo=$g(^DHCHAI.IR.INFReportD(xReport))
							Continue:ReportInfo=""
							Set IRRepType=$lg(ReportInfo,3)
							Continue:IRRepType'=1				//只统计成人感染
							Set IRStatusDr=$lg(ReportInfo,8)
							Set DictionaryInfo=$g(^DHCHAI.BT.DictionaryD(IRStatusDr))
							Continue:DictionaryInfo=""
							Set StatusCode=$lg(DictionaryInfo,2)
							Continue:StatusCode'=3				//只统计'审核'后报告
						
							Set xBactDicDr=""
							For{
								Set xBactDicDr=$o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",xINFId,xBactDicDr))
								Quit:xBactDicDr=""
						    	Continue:xBactDicDr'=BacID   	//判断是否报告的细菌
						    	Set IsInfMRBFlag=1
						    	Quit
							}
						}	
					}
					//0或其他:判断院感->取所有类型数据
					Set:(aHAType'=1)&&(aHAType'=2)&&(LabInfType=1) IsInfMRBFlag=1	//感染标记'HA'计为院感
					If ((aHAType'=1)&&(aHAType'=2)&&(IsInfMRBFlag="0")){
						//疑似筛查确认细菌
						Set xItmScreenDr=""
						For {
							Set xItmScreenDr=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,xItmScreenDr))
							Quit:xItmScreenDr=""
							Continue:IsInfMRBFlag=1	
											
							Set xBactDesc=""
							For {
								Set xBactDesc=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,xItmScreenDr,xBactDesc))
								Quit:xBactDesc=""
								Continue:$p(xBactDesc," ",2)'=BacDesc
							
								Set xScreeningID=""
								For {
									Set xScreeningID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,xItmScreenDr,xBactDesc,xScreeningID))
									Quit:xScreeningID=""
								
									Set xScrDtlID=""
									For {
										Set xScrDtlID=$o(^DHCHAI.IR.CCScreeningD(xScreeningID,"Dtl",xScrDtlID))
										Quit:xScrDtlID=""
									
										Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreeningID,"Dtl",xScrDtlID))
										Continue:ScreenDtl=""
										Set Status=$lg(ScreenDtl,2)
										Continue:Status'=1
								
										Set InfRepPosDr=$lg(ScreenDtl,4)
										Continue:InfRepPosDr=""
								    	Set InfDiagInfo=$g(^DHCHAI.IR.INFDiagnosI(InfRepPosDr))
								   	 	Continue:InfDiagInfo=""
								    	Set IsActive=$lg(InfDiagInfo,17)
								   	 	Continue:IsActive'=1
								    	Set InfType=$lg(InfDiagInfo,18)
								    	Continue:InfType'=1
								    	Set IsInfMRBFlag=1
								    	Quit
									}
								}
							}													
						}
					}
				}
				//判断社区
				Set IsComMRBFlag=0
				Set:LabInfType=2 IsComMRBFlag=1
				//判断污染
				Set IsPollute=0
				Set:LabInfType=4 IsPollute=1
				//判断定值
				Set IsDZFlag=0
				Set:LabInfType=3 IsDZFlag=1  
				
				//输出检出菌数据
				//1.xID,2.MRBCode,3.MRBDesc,4.MRB2Code,5.MRB2Desc,6.SpeDesc,7.BacDesc,8.ActDateTime,9.RepDateTime,10.MRBFlag
				//11.IsInfMRBFlag,12.IsComMRBFlag,13.IsPollute,14.IsDZFlag,15.LabEpisodeNo,16.LabTestSet,17.MRBTypeList	
			   	Set Data=$lb(xID,MRBCode,MRBDesc,MRB2Code,MRB2Desc,SpeDesc,BacDesc,ActDateTime,RepDateTime,MRBFlag,IsInfMRBFlag,IsComMRBFlag,IsPollute,IsDZFlag,LabEpisodeNo,LabTestSet,MRBTypeList)
			   	Set Count=Count+1
				Do return.SetAt(Data,Count)
			}
		}
	}
	Quit return
}

/// Creator：     pylian(ShenC改造)
/// CreatDate：   2022-11-15
/// Description:  判断监控记录是否首次送检检出多耐/细菌
/// Table：       DHCHAI.IR.CCResult
/// Input：       aUnSpec:1-第一株,2-同标本第一株
/// 			  aUnBact:1-第一株细菌,2-第一株多耐
/// Return：      返回ID
/// w ##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend("737","9572","1","2")
ClassMethod IsFirstSend(aEpisodeDr As %String, aResultID As %String, aUnSpec As %String = "", aUnBact As %String = "") As %String
{
	New (aEpisodeDr,aResultID,aUnSpec,aUnBact)
	Set return=0
	Quit:(aEpisodeDr="")||(aResultID="") return
    
    Kill arrResult
    Set RstData=$g(^DHCHAI.IR.CCResultD(aResultID))
    Quit:RstData="" return
    Quit:$lg(RstData,14)="" return			//过滤无效数据
    Quit:$lg(RstData,21)="" return			//过滤'非异常'数据
	Set ActDate=$lg(RstData,8)				//送检日期
	Set ActTime=$lg(RstData,9)				//送检时间
    Set MRBTpDr=$lg(RstData,24)				//多耐类型-1
    Set MRBTpDr2=$lg(RstData,31)			//多耐类型-2
    Set Specimen=$lg(RstData,22)			//原始标本ID
    Set BactDesc=$lg(RstData,23)			//原始细菌ID
    //过滤非多耐菌
    Quit:(aUnBact="2")&&(MRBTpDr="")&&(MRBTpDr2="") return
    
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		
		//过滤非'检出菌'+'常规检验异常'项目
		Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
		Continue:ItemData=""
		Set ItemCode=$lg(ItemData,2)
		Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")
		
		Set xActDate=0
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>ActDate
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set RstData=$g(^DHCHAI.IR.CCResultD(xID))
    			Continue:RstData=""
    			Continue:$lg(RstData,14)="" 			//过滤无效数据
    			Continue:$lg(RstData,21)="" 			//过滤'非异常'数据
    			//保留同种多耐
    			If (aUnBact="2"){
	    			Set MRBTypeDr=$lg(RstData,24)		//多耐类型-1
   		 			Set MRBTypeDr2=$lg(RstData,31)		//多耐类型-2
    				//过滤非多耐菌
    				Continue:(aUnBact="2")&&(MRBTypeDr="")&&(MRBTypeDr2="")
    				//过滤非同种多耐菌
    				Continue:(MRBTpDr'=MRBTypeDr)&&(MRBTpDr'=MRBTypeDr2)
	    		}
	    		//保留同种菌
	    		else{
					Set Bacteria = $lg(RstData,23)    	//原始细菌名称
					//过滤非同种菌
					Continue:Bacteria'=BactDesc
		    	}
    			
    			Set SpecDesc = $lg(RstData,22)    			//原始标本名称
	    		Continue:(aUnSpec=2)&&(Specimen'=SpecDesc)  //同种标本（除本条记录外）
    			
    			Set SendTime = $lg(RstData,9)
				Set arrResult(xActDate,SendTime,xID)="" 

			}
		}
	}
	
	//判断是否第一株
    Set IsIsFirst =""
	Set xActDate=""
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		Quit:IsIsFirst'=""
		
		Set xActTime=""
		For {
			Set xActTime=$o(arrResult(xActDate,xActTime))   //同一日送检分先后顺序
			Quit:xActTime=""
			Quit:IsIsFirst'=""
			
			Set xResultID=""
			For {
				Set xResultID=$o(arrResult(xActDate,xActTime,xResultID))
				Quit:xResultID=""
				Quit:IsIsFirst'=""
				
				Set IsIsFirst=0
				Set:xResultID=aResultID IsIsFirst=1
			}
		}
	}
		
	Set return =IsIsFirst
	
	Kill arrResult
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2022-11-15
/// Description:  查询多耐分类规则列表(M1~M9报表使用)
/// Table：       DHCHAI.IR.CRuleMRB
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S040MRBInf","QryMRBSrv")
Query QryMRBSrv() As %Query(ROWSPEC = "M1Desc:%String,M2Desc:%String,M3Desc:%String,M4Desc:%String,M5Desc:%String,M6Desc:%String,M7Desc:%String,M8Desc:%String,M9Desc:%String") [ SqlProc ]
{
}

ClassMethod QryMRBSrvExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
		
	//M1
	Set M1Desc=""
	Set M1ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M1",""))
	Set M1Data=$g(^DHCHAI.IR.CRuleMRBD(M1ID))
 	If (M1Data'=""){
	 	Set M1Desc=$lg(M1Data,3)
	}
 	//M2
	Set M2Desc=""
	Set M2ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M2",""))
	Set M2Data=$g(^DHCHAI.IR.CRuleMRBD(M2ID))
 	If (M2Data'=""){
	 	Set M2Desc=$lg(M2Data,3)
	}
	//M3
	Set M3Desc=""
	Set M3ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M3",""))
	Set M3Data=$g(^DHCHAI.IR.CRuleMRBD(M3ID))
 	If (M3Data'=""){
	 	Set M3Desc=$lg(M3Data,3)
	}
	//M4
	Set M4Desc=""
	Set M4ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M4",""))
	Set M4Data=$g(^DHCHAI.IR.CRuleMRBD(M4ID))
 	If (M4Data'=""){
	 	Set M4Desc=$lg(M4Data,3)
	}
	//M5
	Set M5Desc=""
	Set M5ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M5",""))
	Set M5Data=$g(^DHCHAI.IR.CRuleMRBD(M5ID))
 	If (M5Data'=""){
	 	Set M5Desc=$lg(M5Data,3)
	}
	//M6
	Set M6Desc=""
	Set M6ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M6",""))
	Set M6Data=$g(^DHCHAI.IR.CRuleMRBD(M6ID))
 	If (M6Data'=""){
	 	Set M6Desc=$lg(M6Data,3)
	}
	//M7
	Set M7Desc=""
	Set M7ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M7",""))
	Set M7Data=$g(^DHCHAI.IR.CRuleMRBD(M7ID))
 	If (M7Data'=""){
	 	Set M7Desc=$lg(M7Data,3)
	}
	//M8
	Set M8Desc=""
	Set M8ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M8",""))
	Set M8Data=$g(^DHCHAI.IR.CRuleMRBD(M8ID))
 	If (M8Data'=""){
	 	Set M8Desc=$lg(M8Data,3)
	}
	//M9
	Set M9Desc=""
	Set M9ID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode","M9",""))
	Set M9Data=$g(^DHCHAI.IR.CRuleMRBD(M9ID))
 	If (M9Data'=""){
	 	Set M9Desc=$lg(M9Data,3)
	}	
 	
 	Set Data=$lb(M1Desc,M2Desc,M3Desc,M4Desc,M5Desc,M6Desc,M7Desc,M8Desc,M9Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryMRBSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBSrvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBSrvExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

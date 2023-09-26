/// 名称: DHCHAI.STATV2.S070DayMRBCol
/// 描述: 千日多重耐药菌定植例次发生率(感染标记判断定值)
/// 编写者：zhoubo(ShenC改造)
/// 编写日期: 2022-11-17
Class DHCHAI.STATV2.S070DayMRBCol Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		zhoubo(ShenC改造)
/// CreateDate：	2022-11-17
/// Description:	千日多重耐药菌定植例次发生率(感染标记判断定值)
/// Input:          aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期  
/// 			  	aLocType ：科室/病区类型
/// 			  	aQryCon：  有效数据筛查  
///              	aStatDimens:  展示维度
///               	aLocIDs:    科室
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S070DayMRBCol","QryMRBCol","1","2020-05-01","2020-05-31","W","2","HGW","")
Query QryMRBCol(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,PatInDays:%Integer,M1Pat:%Integer,M1PatCase:%Integer,M1PatRatio:%String,M1CaseRatio:%String,M2Pat:%Integer,M2PatCase:%Integer,M2PatRatio:%String,M2CaseRatio:%String,M3Pat:%Integer,M3PatCase:%Integer,M3PatRatio:%String,M3CaseRatio:%String,M4Pat:%Integer,M4PatCase:%Integer,M4PatRatio:%String,M4CaseRatio:%String,M5Pat:%Integer,M5PatCase:%Integer,M5PatRatio:%String,M5CaseRatio:%String,M6Pat:%Integer,M6PatCase:%Integer,M6PatRatio:%String,M6CaseRatio:%String,M7Pat:%Integer,M7PatCase:%Integer,M7PatRatio:%String,M7CaseRatio:%String,M8Pat:%Integer,M8PatCase:%Integer,M8PatRatio:%String,M8CaseRatio:%String,M9Pat:%Integer,M9PatCase:%Integer,M9PatRatio:%String,M9CaseRatio:%String,MPat:%Integer,MPatCase:%Integer") [ SqlProc ]
{
}

ClassMethod QryMRBColExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
 	
 	Set NIndex="QryMRBCol"
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
				Set InDays=0			//患者住院天数
				
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    //记录在科天数
				    Set TransDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransID)
				    Set InDays=InDays+TransDays
				    
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
	    			Set ListMRBArray=##Class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
	    			For xMRBID=1:1:ListMRBArray.Count() {
						Set MRBInfo=ListMRBArray.GetAt(xMRBID)	
						Continue:MRBInfo=""
						
						Set ResID	   = $lg(MRBInfo,2)		//ID
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"2")
							Continue:IsFirstSend'=1
						}
					
						Set MRBCode    = $lg(MRBInfo,2)		//多耐1->Code
						Set MRBDesc    = $lg(MRBInfo,3)		//多耐1->名称
						Set MRB2Code   = $lg(MRBInfo,4)		//多耐2->Code
						Set MRB2Desc   = $lg(MRBInfo,5)		//多耐2->名称
						Set BacDesc    = $lg(MRBInfo,7)		//细菌名称
						Set IsDZFlag = $lg(MRBInfo,14)		//定植
						Continue:BacDesc=""
						Continue:IsDZFlag'=1				//过滤非定植多耐
						
						If (MRBCode'=""){
							//同期检出发生定植的多耐人数
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
							//同期检出发生定植的多耐例次数
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
					
					Set LocDr = +$p(DimensKey,"-",3)
					Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))		//过滤科室
					
					// 住院患者人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
						Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
						
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
					}
					// 住院患者天数
					Set:InDays>0 ^TMP($zn,$j,NIndex,DimensKey,"PatInDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"PatInDays"))+InDays 
					
					// 定值相关多耐
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
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"MPat",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"MPat",Paadm)=""
								
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
						// 住院患者天数
						Set:InDays>0 ^TMP($zn,$j,NIndex,"Sum","PatInDays") = +$g(^TMP($zn,$j,NIndex,"Sum","PatInDays"))+InDays 
						
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
		Set PatInDays  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatInDays"))    	//住院患者天数
		
		Set M1Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1Pat"))     	//同期检出发生定植的M1的人数
		Set M1PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1PatCase")) 	//同期检出发生定植的M1的例次数
		Set M1PatRatio="0.00‰"
		Set:PatInDays>0 M1PatRatio=$fn((M1Pat/PatInDays)*1000,"",2)_"‰"	 	//M1定植千日发生率
		Set M1CaseRatio="0.00‰"
		Set:PatInDays>0 M1CaseRatio=$fn((M1PatCase/PatInDays)*1000,"",2)_"‰" //M1定植例次千日发生率
		
		Set M2Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2Pat"))     	//同期检出发生定植的M2的人数
		Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2PatCase")) 	//同期检出发生定植的M2的例次数
		Set M2PatRatio="0.00‰"
		Set:PatInDays>0 M2PatRatio=$fn((M2Pat/PatInDays)*1000,"",2)_"‰" 		//M2定植千日发生率
		Set M2CaseRatio="0.00‰"
		Set:PatInDays>0 M2CaseRatio=$fn((M2PatCase/PatInDays)*1000,"",2)_"‰" //M2定植例次千日发生率
		
		Set M3Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3Pat"))     	//同期检出发生定植的M3的人数
		Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3PatCase")) 	//同期检出发生定植的M3的例次数
		Set M3PatRatio="0.00‰"
		Set:PatInDays>0 M3PatRatio=$fn((M3Pat/PatInDays)*1000,"",2)_"‰" 		//M3定植千日发生率
		Set M3CaseRatio="0.00‰"
		Set:PatInDays>0 M3CaseRatio=$fn((M3PatCase/PatInDays)*1000,"",2)_"‰" //M3定植例次千日发生率
		
		Set M4Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M4Pat"))     	//同期检出发生定植的M4的人数
		Set M4PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M4PatCase")) 	//同期检出发生定植的M4的例次数
		Set M4PatRatio="0.00‰"
		Set:PatInDays>0 M4PatRatio=$fn((M4Pat/PatInDays)*1000,"",2)_"‰" 		//M4定植千日发生率
		Set M4CaseRatio="0.00‰"
		Set:PatInDays>0 M4CaseRatio=$fn((M4PatCase/PatInDays)*1000,"",2)_"‰" //M4定植例次千日发生率
		
		Set M5Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M5Pat"))     	//同期检出发生定植的M5的人数
		Set M5PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M5PatCase")) 	//同期检出发生定植的M5的例次数
		Set M5PatRatio="0.00‰"
		Set:PatInDays>0 M5PatRatio=$fn((M5Pat/PatInDays)*1000,"",2)_"‰" 		//M5定植千日发生率
		Set M5CaseRatio="0.00‰"
		Set:PatInDays>0 M5CaseRatio=$fn((M5PatCase/PatInDays)*1000,"",2)_"‰" //M5定植例次千日发生率
		
		Set M6Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6Pat"))     	//同期检出发生定植的M6的人数
		Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6PatCase")) 	//同期检出发生定植的M6的例次数
		Set M6PatRatio="0.00‰"
		Set:PatInDays>0 M6PatRatio=$fn((M6Pat/PatInDays)*1000,"",2)_"‰" 		//M6定植千日发生率
		Set M6CaseRatio="0.00‰"
		Set:PatInDays>0 M6CaseRatio=$fn((M6PatCase/PatInDays)*1000,"",2)_"‰" //M6定植例次千日发生率
		
		Set M7Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7Pat"))     	//同期检出发生定植的M7的人数
		Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7PatCase")) 	//同期检出发生定植的M7的例次数
		Set M7PatRatio="0.00‰"
		Set:PatInDays>0 M7PatRatio=$fn((M7Pat/PatInDays)*1000,"",2)_"‰" 		//M7定植千日发生率
		Set M7CaseRatio="0.00‰"
		Set:PatInDays>0 M7CaseRatio=$fn((M7PatCase/PatInDays)*1000,"",2)_"‰" //M7定植例次千日发生率
		
		Set M8Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8Pat"))     	//同期检出发生定植的M8的人数
		Set M8PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8PatCase")) 	//同期检出发生定植的M8的例次数
		Set M8PatRatio="0.00‰"
		Set:PatInDays>0 M8PatRatio=$fn((M8Pat/PatInDays)*1000,"",2)_"‰" 		//M8定植千日发生率
		Set M8CaseRatio="0.00‰"
		Set:PatInDays>0 M8CaseRatio=$fn((M8PatCase/PatInDays)*1000,"",2)_"‰" //M8定植例次千日发生率
		
		Set M9Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9Pat"))     	//同期检出发生定植的M9的人数
		Set M9PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9PatCase")) 	//同期检出发生定植的M9的例次数
		Set M9PatRatio="0.00‰"
		Set:PatInDays>0 M9PatRatio=$fn((M9Pat/PatInDays)*1000,"",2)_"‰" 		//M9定植千日发生率
		Set M9CaseRatio="0.00‰"
		Set:PatInDays>0 M9CaseRatio=$fn((M9PatCase/PatInDays)*1000,"",2)_"‰" //M9定植例次千日发生率
		//同期检出发生定植的的人数
		Set MPat=+$g(^TMP($zn,$j,NIndex,xDimensKey,"MPat")) 	
		//同期检出发生定植的的例次数
		Set MPatCase=+$g(^TMP($zn,$j,NIndex,xDimensKey,"MPatCase"))		
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)	
		Continue:(aQryCon="2")&&(MPat=0)
		Continue:(aQryCon="3")&&(PatAdmCnt=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,PatInDays,M1Pat,M1PatCase,M1PatRatio,M1CaseRatio,M2Pat,M2PatCase,M2PatRatio,M2CaseRatio,M3Pat,M3PatCase,M3PatRatio,M3CaseRatio,M4Pat,M4PatCase,M4PatRatio,M4CaseRatio,M5Pat,M5PatCase,M5PatRatio,M5CaseRatio,M6Pat,M6PatCase,M6PatRatio,M6CaseRatio,M7Pat,M7PatCase,M7PatRatio,M7CaseRatio,M8Pat,M8PatCase,M8PatRatio,M8CaseRatio,M9Pat,M9PatCase,M9PatRatio,M9CaseRatio,MPat,MPatCase)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (LocCount>1) {
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))    			//住院患者人数
		Set PatInDays  =+$g(^TMP($zn,$j,NIndex,"Sum","PatInDays"))    		//住院患者天数
		
		Set M1Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M1Pat"))     			//同期检出发生定植的M1的人数
		Set M1PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M1PatCase")) 			//同期检出发生定植的M1的例次数
		Set M1PatRatio="0.00‰"
		Set:PatInDays>0 M1PatRatio=$fn((M1Pat/PatInDays)*1000,"",2)_"‰"	 	//M1定植千日发生率
		Set M1CaseRatio="0.00‰"
		Set:PatInDays>0 M1CaseRatio=$fn((M1PatCase/PatInDays)*1000,"",2)_"‰" //M1定植例次千日发生率
		
		Set M2Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M2Pat"))     			//同期检出发生定植的M2的人数
		Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M2PatCase")) 			//同期检出发生定植的M2的例次数
		Set M2PatRatio="0.00‰"
		Set:PatInDays>0 M2PatRatio=$fn((M2Pat/PatInDays)*1000,"",2)_"‰" 		//M2定植千日发生率
		Set M2CaseRatio="0.00‰"
		Set:PatInDays>0 M2CaseRatio=$fn((M2PatCase/PatInDays)*1000,"",2)_"‰" //M2定植例次千日发生率
		
		Set M3Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M3Pat"))     			//同期检出发生定植的M3的人数
		Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M3PatCase")) 			//同期检出发生定植的M3的例次数
		Set M3PatRatio="0.00‰"
		Set:PatInDays>0 M3PatRatio=$fn((M3Pat/PatInDays)*1000,"",2)_"‰" 		//M3定植千日发生率
		Set M3CaseRatio="0.00‰"
		Set:PatInDays>0 M3CaseRatio=$fn((M3PatCase/PatInDays)*1000,"",2)_"‰" //M3定植例次千日发生率
		
		Set M4Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M4Pat"))     			//同期检出发生定植的M4的人数
		Set M4PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M4PatCase")) 			//同期检出发生定植的M4的例次数
		Set M4PatRatio="0.00‰"
		Set:PatInDays>0 M4PatRatio=$fn((M4Pat/PatInDays)*1000,"",2)_"‰" 		//M4定植千日发生率
		Set M4CaseRatio="0.00‰"
		Set:PatInDays>0 M4CaseRatio=$fn((M4PatCase/PatInDays)*1000,"",2)_"‰" //M4定植例次千日发生率
		
		Set M5Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M5Pat"))     			//同期检出发生定植的M5的人数
		Set M5PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M5PatCase")) 			//同期检出发生定植的M5的例次数
		Set M5PatRatio="0.00‰"
		Set:PatInDays>0 M5PatRatio=$fn((M5Pat/PatInDays)*1000,"",2)_"‰" 		//M5定植千日发生率
		Set M5CaseRatio="0.00‰"
		Set:PatInDays>0 M5CaseRatio=$fn((M5PatCase/PatInDays)*1000,"",2)_"‰" //M5定植例次千日发生率
		
		Set M6Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M6Pat"))     			//同期检出发生定植的M6的人数
		Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M6PatCase")) 			//同期检出发生定植的M6的例次数
		Set M6PatRatio="0.00‰"
		Set:PatInDays>0 M6PatRatio=$fn((M6Pat/PatInDays)*1000,"",2)_"‰" 		//M6定植千日发生率
		Set M6CaseRatio="0.00‰"
		Set:PatInDays>0 M6CaseRatio=$fn((M6PatCase/PatInDays)*1000,"",2)_"‰" //M6定植例次千日发生率
		
		Set M7Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M7Pat"))     			//同期检出发生定植的M7的人数
		Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M7PatCase")) 			//同期检出发生定植的M7的例次数
		Set M7PatRatio="0.00‰"
		Set:PatInDays>0 M7PatRatio=$fn((M7Pat/PatInDays)*1000,"",2)_"‰" 		//M7定植千日发生率
		Set M7CaseRatio="0.00‰"
		Set:PatInDays>0 M7CaseRatio=$fn((M7PatCase/PatInDays)*1000,"",2)_"‰" //M7定植例次千日发生率
		
		Set M8Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M8Pat"))     			//同期检出发生定植的M8的人数
		Set M8PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M8PatCase")) 			//同期检出发生定植的M8的例次数
		Set M8PatRatio="0.00‰"
		Set:PatInDays>0 M8PatRatio=$fn((M8Pat/PatInDays)*1000,"",2)_"‰" 		//M8定植千日发生率
		Set M8CaseRatio="0.00‰"
		Set:PatInDays>0 M8CaseRatio=$fn((M8PatCase/PatInDays)*1000,"",2)_"‰" //M8定植例次千日发生率
		
		Set M9Pat      =+$g(^TMP($zn,$j,NIndex,"Sum","M9Pat"))     			//同期检出发生定植的M9的人数
		Set M9PatCase  =+$g(^TMP($zn,$j,NIndex,"Sum","M9PatCase")) 			//同期检出发生定植的M9的例次数
		Set M9PatRatio="0.00‰"
		Set:PatInDays>0 M9PatRatio=$fn((M9Pat/PatInDays)*1000,"",2)_"‰" 		//M9定植千日发生率
		Set M9CaseRatio="0.00‰"
		Set:PatInDays>0 M9CaseRatio=$fn((M9PatCase/PatInDays)*1000,"",2)_"‰" //M9定植例次千日发生率
		//同期检出发生定植的的人数
		Set MPat=+$g(^TMP($zn,$j,NIndex,"Sum","MPat")) 	
		//同期检出发生定植的的例次数
		Set MPatCase=+$g(^TMP($zn,$j,NIndex,"Sum","MPatCase"))		
		
		Set Data=$lb("","全部",PatAdmCnt,PatInDays,M1Pat,M1PatCase,M1PatRatio,M1CaseRatio,M2Pat,M2PatCase,M2PatRatio,M2CaseRatio,M3Pat,M3PatCase,M3PatRatio,M3CaseRatio,M4Pat,M4PatCase,M4PatRatio,M4CaseRatio,M5Pat,M5PatCase,M5PatRatio,M5CaseRatio,M6Pat,M6PatCase,M6PatRatio,M6CaseRatio,M7Pat,M7PatCase,M7PatRatio,M7CaseRatio,M8Pat,M8PatCase,M8PatRatio,M8CaseRatio,M9Pat,M9PatCase,M9PatRatio,M9CaseRatio,MPat,MPatCase)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryMRBColClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBColExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBColFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBColExecute ]
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
/// CreateDate：	2022-11-17
/// Description:	多重耐药菌定植例次数明细表
/// Input:		    aHospIDs：院区
/// 				aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 维度
/// 				aLocType：统计类型
/// 				aLocIDs：科室
/// 			    aMRBCode : 多耐分类代码
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S070DayMRBCol","QryMRBColDtl","1","2020-05-01","2020-05-31","0001-00-0000-H-2","W","","M4")
Query QryMRBColDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBCode As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TransDays:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryMRBColDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBCode As %String = "") As %Status
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
					//记录在科天数
				    Set TransDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransID)
				    
					//存储转科基本信息
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,TransDays)
					
					//患者多耐信息
	    			Set ListMRBArray=##Class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
	    			For xMRBID=1:1:ListMRBArray.Count() {
						Set MRBInfo=ListMRBArray.GetAt(xMRBID)	
						Continue:MRBInfo=""
						
						Set ResID	   = $lg(MRBInfo,2)		//ID
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"2")
							Continue:IsFirstSend'=1
						}
						
						Set IsDZFlag = $lg(MRBInfo,14)		//定植
						Continue:IsDZFlag'=1				//过滤非定植多耐
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
						Set LabInfo=$lb(ResID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpeDesc,BacDesc,"定植")
						
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

ClassMethod QryMRBColDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBColDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBColDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBColDtlExecute ]
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
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S070DayMRBCol","QryMRBColPatDtl","","2020-05-01","2020-05-31","0000-00-0000-A-1","E")
Query QryMRBColPatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TransDays:%String") [ SqlProc ]
{
}

ClassMethod QryMRBColPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Status
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
					//记录在科天数
				    Set TransDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransID)
				    
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,TransDays)	
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
				
	}
	Quit $$$OK
}

ClassMethod QryMRBColPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBColPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBColPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBColPatDtlExecute ]
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

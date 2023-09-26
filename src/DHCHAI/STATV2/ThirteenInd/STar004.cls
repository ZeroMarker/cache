/// 名称: DHCHAI.STATV2.ThirteenInd.STar004
/// 描述: 多重耐药菌感染发现率--2015十三项指标[4]
/// 编写者: ZZL(ShenC改造)
/// 编写日期: 2023-04-07
Class DHCHAI.STATV2.ThirteenInd.STar004 Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		ZZL(ShenC改造)
/// CreateDate：	2023-04-07
/// Description:	多重耐药菌感染发现率--2015十三项指标[4]
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期  
/// 			  	aLocType ：科室/病区类型
/// 			  	aQryCon：  有效数据筛查  
///              	aStatDimens:  展示维度
///               	aLocIDs:    科室
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.STar004","QryMRBInf","1","2020-05-01","2020-05-31","W","2","HGW","")
Query QryMRBInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,MRBTypeID:%String,MRBType:%String,MRBPat:%Integer,MRBPatCase:%Integer,MRBPatRatio:%String,MRBCaseRatio:%String,MPat:%Integer,MPatCase:%Integer") [ SqlProc ]
{
}

ClassMethod QryMRBInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//院区处理*入参
	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//开始|结束日期处理*入参
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//统计类型处理*入参
 	Set:aLocType'="W" aLocType="E"
 	//展示维度处理*入参
 	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")		//科室、病区入参个数
 	
 	Set NIndex="QryMRBInf"
	Kill ^TMP($zn,$j,NIndex)
	
	//HA判断方式--1：只取院感报告关联数据，2：只取感染标记数据，0或其他：取所有类型数据
	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
	//是否去重--0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重方式--1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	//多耐菌类别[十三项指标]--MRSA|M1#CRE|M2,,,,
	Set MRBTypeList=##class(DHCHAI.BT.Config).GetValByCode("MRBTypeList")
	For xMRBTypeID=1:1:$l(MRBTypeList,"|"){
		Set MRBTypeInfo=$p(MRBTypeList,"|",xMRBTypeID)		//CRE|M4,M5
		
		Set MRBType=$p(MRBTypeInfo,"#",1)
		Set MRBCodeList=$p(MRBTypeInfo,"#",2)
		//存储ID-Type
		Set ^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID)=MRBType
		For xMRBCodeID=1:1:$l(MRBCodeList,"&"){
			Set MRBCode=$p(MRBCodeList,"&",xMRBCodeID)		//CRE|M4,M5
			b
			Set ^TMP($zn,$j,NIndex,"MRBCType",MRBCode)=MRBType
		}
	}
	
	//循环科室
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
			//同期在科患者
			Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
		    For index1=1:1:ListLocArray.Count() {
				Set TransInfo=ListLocArray.GetAt(index1)
				Continue:TransInfo=""
				
				Set Paadm      = $lg(TransInfo,1)		//就诊号
				Set LocID      = $lg(TransInfo,2)		//科室ID
				Set TransType  = $lg(TransInfo,3)		//转科类型
				Set LnkLocDr   = $lg(TransInfo,5)		//关联科室
				Set TransIDs   = $lg(TransInfo,6)		//转科ID
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
	    			Set ListMRBArray=##class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
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
							Set MRBCType=$g(^TMP($zn,$j,NIndex,"MRBCType",MRBCode))		//多耐类别[十三项指标]
							//注:不统计参数中未定义多耐
							If (MRBCType'=""){
								//同期检出导致医院感染的多耐人数
								Set MRBPatIndex=MRBCType_"Pat"
								If '$d(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MRBPatIndex)){
									Set ^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MRBPatIndex)=""
								
									Set num=$i(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MRBPatIndex))
								}
								If '$d(^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)){
									Set ^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)=""
								
									//总人数
									Set num=$i(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,"MPat"))
								}
							
								//同期检出导致医院感染的多耐例次数
								Set MRBCaseIndex=MRBCType_"PatCase"
								Set num = $i(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,MRBCaseIndex))
								//总例数
								Set num=$i(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,"MPatCase"))
							}
						}
						If (MRB2Code'=""){
							Set MRBCType2=$g(^TMP($zn,$j,NIndex,"MRBCType",MRB2Code))		//多耐类别[十三项指标]
							//注:不统计参数中未定义多耐
							If (MRBCType2'=""){
								//同期检出导致医院感染的多耐人数
								Set MRBPatIndex=MRBCType2_"Pat"
								If '$d(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MRBPatIndex)){
									Set ^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MRBPatIndex)=""
								
									Set num=$i(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MRBPatIndex))
								}
								If '$d(^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)){
									Set ^TMP($zn,$j,NIndex,"MRBSumPat",LocID,Paadm)=""
								
									//总人数
									Set num=$i(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,"MPat"))
								}
							
								Set MRBCaseIndex=MRBCType2_"PatCase"
								Set num = $i(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,MRBCaseIndex))
								//总例数
								Set num=$i(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,"MPatCase"))
							}
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
					If ($d(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm))){
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)){
							Set ^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)=""
							
							//感染人数
							Set xMRBIndex=""
							For{
								Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,xMRBIndex))
								Quit:xMRBIndex=""
								Continue:xMRBIndex="MPat"
								
								//各类型多耐人数
								If '$d(^TMP($zn,$j,NIndex,DimensKey,xMRBIndex,Paadm)){
									Set ^TMP($zn,$j,NIndex,DimensKey,xMRBIndex,Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,DimensKey,xMRBIndex)=$g(^TMP($zn,$j,NIndex,DimensKey,xMRBIndex))+$g(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,xMRBIndex))
								}
							}
							//合计感染人数
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"SumPatAdm",Paadm)){
								Set ^TMP($zn,$j,NIndex,DimensKey,"SumPatAdm",Paadm)=""
								
								Set ^TMP($zn,$j,NIndex,DimensKey,"MPat")=$g(^TMP($zn,$j,NIndex,DimensKey,"MPat"))+$g(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,"MPat"))
							}
							
							//感染例次数
							Set xMRBIndex=""
							For{
								Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,xMRBIndex))
								Quit:xMRBIndex=""
								Continue:xMRBIndex="MPatCase"
								
								//各类型多耐例次数
								If '$d(^TMP($zn,$j,NIndex,DimensKey,xMRBIndex,Paadm)){
									Set ^TMP($zn,$j,NIndex,DimensKey,xMRBIndex,Paadm)=""
									
									Set ^TMP($zn,$j,NIndex,DimensKey,xMRBIndex)=$g(^TMP($zn,$j,NIndex,DimensKey,xMRBIndex))+$g(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,xMRBIndex))
								}
							}
							//合计例次数
							Set ^TMP($zn,$j,NIndex,DimensKey,"MPatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"MPatCase"))+$g(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,"MPatCase"))
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
								
								//感染人数
								Set xMRBIndex=""
								For{
									Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,xMRBIndex))
									Quit:xMRBIndex=""
									Continue:xMRBIndex="MPat"
								
									//各类型多耐人数
									If '$d(^TMP($zn,$j,NIndex,"Sum",xMRBIndex,Paadm)){
										Set ^TMP($zn,$j,NIndex,"Sum",xMRBIndex,Paadm)=""
									
										Set ^TMP($zn,$j,NIndex,"Sum",xMRBIndex)=$g(^TMP($zn,$j,NIndex,"Sum",xMRBIndex))+$g(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,xMRBIndex))
									}
								}
								//合计感染人数
								If '$d(^TMP($zn,$j,NIndex,"Sum","SumPatAdm",Paadm)){
									Set ^TMP($zn,$j,NIndex,"Sum","SumPatAdm",Paadm)=""
								
									Set ^TMP($zn,$j,NIndex,"Sum","MPat")=$g(^TMP($zn,$j,NIndex,"Sum","MPat"))+$g(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,"MPat"))
								}
							
								//感染例次数
								Set xMRBIndex=""
								For{
									Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,xMRBIndex))
									Quit:xMRBIndex=""
									Continue:xMRBIndex="MPatCase"
								
									//各类型多耐例次数
									If '$d(^TMP($zn,$j,NIndex,"Sum",xMRBIndex,Paadm)){
										Set ^TMP($zn,$j,NIndex,"Sum",xMRBIndex,Paadm)=""
									
										Set ^TMP($zn,$j,NIndex,"Sum",xMRBIndex)=$g(^TMP($zn,$j,NIndex,"Sum",xMRBIndex))+$g(^TMP($zn,$j,NIndex,"MRBCase",LocID,Paadm,xMRBIndex))
									}
								}
								//合计例次数
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
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))    //住院患者人数
		//同期检出导致医院感染的的人数
		Set MPat=+$g(^TMP($zn,$j,NIndex,xDimensKey,"MPat")) 	
		//同期检出导致医院感染的的例次数
		Set MPatCase=+$g(^TMP($zn,$j,NIndex,xDimensKey,"MPatCase"))	
	
		Continue:(IsActive="0")&&(PatAdmCnt=0)	
		Continue:(aQryCon="2")&&(MPat=0)
		Continue:(aQryCon="3")&&(PatAdmCnt=0)
		
		Set xMRBTypeID=""
		For{
			Set xMRBTypeID=$o(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			Quit:xMRBTypeID=""
			
			Set MRBType=$g(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			
			Set MRBPat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,MRBType_"Pat"))     	//同期检出导致医院感染的M1的人数
			Set MRBPatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,MRBType_"PatCase")) 	//同期检出导致医院感染的M1的例次数
			Set MRBPatRatio="0.00%"
			Set:PatAdmCnt>0 MRBPatRatio=$fn((MRBPat/PatAdmCnt)*100,"",2)_"%"	 	//M1医院感染发生率
			Set MRBCaseRatio="0.00%"
			Set:PatAdmCnt>0 MRBCaseRatio=$fn((MRBPatCase/PatAdmCnt)*100,"",2)_"%" 	//M1医院感染例次发生率
			
			Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,xMRBTypeID,MRBType,MRBPat,MRBPatCase,MRBPatRatio,MRBCaseRatio,MPat,MPatCase)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If (LocCount>1) {
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))    			//住院患者人数
		Set xMRBTypeID=""
		For{
			Set xMRBTypeID=$o(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			Quit:xMRBTypeID=""
			
			Set MRBType=$g(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			
			Set MRBPat      =+$g(^TMP($zn,$j,NIndex,"Sum",MRBType_"Pat"))     	//同期检出导致医院感染的M1的人数
			Set MRBPatCase  =+$g(^TMP($zn,$j,NIndex,"Sum",MRBType_"PatCase")) 	//同期检出导致医院感染的M1的例次数
			Set MRBPatRatio="0.00%"
			Set:PatAdmCnt>0 MRBPatRatio=$fn((MRBPat/PatAdmCnt)*100,"",2)_"%"	 	//M1医院感染发生率
			Set MRBCaseRatio="0.00%"
			Set:PatAdmCnt>0 MRBCaseRatio=$fn((MRBPatCase/PatAdmCnt)*100,"",2)_"%" 	//M1医院感染例次发生率
			
			Set Data=$lb("","全部",PatAdmCnt,xMRBTypeID,MRBType,MRBPat,MRBPatCase,MRBPatRatio,MRBCaseRatio,MPat,MPatCase)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
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
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.STar004","QryMRBInfDtl","1","2020-01-01","2020-12-31","0001-00-0000-H-1","W","","MRSA")
Query QryMRBInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBType As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBType As %String = "") As %Status
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
   
   	Set NIndex="QryMRBInfDtl"
	Kill ^TMP($zn,$j,NIndex)
   	//HA判断方式--1：只取院感报告关联数据，2：只取感染标记数据，0或其他：取所有类型数据
	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	//多耐菌类别[十三项指标]--MRSA|M1#CRE|M2,,,,
	Set MRBLinkCode=""
	If (aMRBType'=""){
		Set MRBTypeList=##class(DHCHAI.BT.Config).GetValByCode("MRBTypeList")
		For xMRBTypeID=1:1:$l(MRBTypeList,"|"){
			Set MRBTypeInfo=$p(MRBTypeList,"|",xMRBTypeID)		//CRE|M4,M5
		
			Set MRBType=$p(MRBTypeInfo,"#",1)
			//过滤多耐类别
			Continue:(aMRBType'="")&&(aMRBType'=MRBType)
			Set MRBLinkCode=MRBLinkCode_"&"_$p(MRBTypeInfo,"#",2)
		}
		Set:MRBLinkCode'="" MRBLinkCode=MRBLinkCode_"&"
	}
	
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
	    			Set ListMRBArray=##Class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
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
						Continue:(MRBLinkCode'="")&&(MRBLinkCode'[("&"_MRBCode_"&"))&&(MRBLinkCode'[("&"_MRB2Code_"&"))
					
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
	Kill ^TMP($zn,$j,NIndex)
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
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.STar004","QryMRBInfPatDtl","","2020-05-01","2020-05-31","0000-00-0000-A-1","E")
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

}

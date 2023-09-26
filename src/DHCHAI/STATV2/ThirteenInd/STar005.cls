/// 名称: DHCHAI.STATV2.ThirteenInd.STar005
/// 描述: 多重耐药菌检出率统计--2015十三项指标[5]
/// 编写者: ZZL(ShenC改造)
/// 编写日期: 2023-04-07
Class DHCHAI.STATV2.ThirteenInd.STar005 Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		ZZL(ShenC改造)
/// CreateDate：	2023-04-07
/// Description:	多重耐药菌检出率--2015十三项指标[5]
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期  
/// 			  	aLocType ：科室/病区类型
/// 			  	aQryCon：  有效数据筛查  
///              	aStatDimens:  展示维度
///               	aLocIDs:    科室
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.STar005","QryMRBPos","1","2020-01-01","2020-12-31","W","2","HGW","")
Query QryMRBPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,xMRBTypeID:%String,MRBType:%String,BacCase:%Integer,MRBCase:%Integer,Ratio:%String,MBacCase:%Integer,MMRBCase:%Integer") [ SqlProc ]
{
}

ClassMethod QryMRBPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
		Continue:MRBTypeInfo=""
		
		Set MRBType=$p(MRBTypeInfo,"#",1)
		Set MRBCodeList=$p(MRBTypeInfo,"#",2)
		//存储ID-Type
		Set ^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID)=MRBType
		For xMRBCodeID=1:1:$l(MRBCodeList,"&"){
			Set MRBCode=$p(MRBCodeList,"&",xMRBCodeID)		//CRE|M4,M5
			Continue:MRBCode=""
			
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
						Set MRBCode    = $lg(MRBInfo,2)		//多耐1->Code
						Set MRBDesc    = $lg(MRBInfo,3)		//多耐1->名称
						Set MRB2Code   = $lg(MRBInfo,4)		//多耐2->Code
						Set MRB2Desc   = $lg(MRBInfo,5)		//多耐2->名称
						Set BacDesc    = $lg(MRBInfo,7)		//细菌名称
						Set IsInfMRBFlag = $lg(MRBInfo,11)	//院感
						Continue:BacDesc=""
						//过滤污染细菌
						Set IsPollute=$lg(MRBInfo,13)
						Continue:IsPollute="1"
						If (IsUnRepeat="1"){
							//是否第一株菌
							Set IsFirstSendBac=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"1")
							//是否第一株多耐
							Set IsFirstSendMrb=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"2")
						}
						//存储检出细菌例次[多耐关联菌]
						//1.不去重统计全部细菌，2.去重统计去重后细菌
						If ((IsUnRepeat'="1")||((IsUnRepeat="1")&&(IsFirstSendBac="1"))){
							Set BacTypeList=$lg(MRBInfo,17)
							For xBacTypeID=1:1:$l(BacTypeList,","){
								Set BacType=$p(BacTypeList,",",xBacTypeID)
								Continue:BacType=""
								
								Set MRBCType=$g(^TMP($zn,$j,NIndex,"MRBCType",BacType))		//多耐类别[十三项指标]
								//注:不统计参数中未定义多耐
								If (MRBCType'=""){
									//细菌例数
									Set BacIndex=MRBCType_"Bac"
									Set num = $i(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,BacIndex))
									//细菌总例数[十三项指标]
									If ('$d(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,"MBac",ResID))){
										Set (^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,"MBac",ResID))=""
										//细菌总例数
										Set num = $i(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,"MBac"))
									}
								}	
							}
						}
						//存储检出多耐例次
						//1.不去重统计全部多耐，2.去重统计去重后多耐
						Continue:(MRBCode="")&&(MRB2Code="")
						If ((IsUnRepeat'="1")||((IsUnRepeat="1")&&(IsFirstSendMrb="1"))){
							If (MRBCode'=""){
								Set MRBCType=$g(^TMP($zn,$j,NIndex,"MRBCType",MRBCode))	//多耐类别[十三项指标]
								//注:不统计参数中未定义多耐
								If (MRBCType'=""){
									//多耐例数
									Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MRBCType_"MRB"))
									//多耐总例数
									Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MMRB"))
								}
							}
							If (MRB2Code'=""){
								Set MRBCType=$g(^TMP($zn,$j,NIndex,"MRBCType",MRB2Code))	//多耐类别[十三项指标]
								//注:不统计参数中未定义多耐
								If (MRBCType'=""){
									//多耐例数
									Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MRBCType_"MRB"))
									//多耐总例数
									Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MMRB"))
								}
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
					// 检出细菌例数
					If ($d(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm))){
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"BacPatAdm",LocID,Paadm)){
							Set ^TMP($zn,$j,NIndex,DimensKey,"BacPatAdm",LocID,Paadm)=""
								
							Set xMRBIndex=""
							For{
								Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,xMRBIndex))
								Quit:xMRBIndex=""
								
								Continue:xMRBIndex="MBac"
								
								//例次数
								Set ^TMP($zn,$j,NIndex,DimensKey,xMRBIndex)=$g(^TMP($zn,$j,NIndex,DimensKey,xMRBIndex))+$g(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,xMRBIndex))
							}
							//合计例次数
							Set ^TMP($zn,$j,NIndex,DimensKey,"MBac")=$g(^TMP($zn,$j,NIndex,DimensKey,"MBac"))+$g(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,"MBac"))	
						}
					}
					// 检出多耐例数
					If ($d(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm))){
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"MRBPatAdm",LocID,Paadm)){
							Set ^TMP($zn,$j,NIndex,DimensKey,"MRBPatAdm",LocID,Paadm)=""
							
							Set xMRBIndex=""
							For{
								Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,xMRBIndex))
								Quit:xMRBIndex=""
								
								Continue:xMRBIndex="MMRB"
								
								//例次数
								Set ^TMP($zn,$j,NIndex,DimensKey,xMRBIndex)=$g(^TMP($zn,$j,NIndex,DimensKey,xMRBIndex))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,xMRBIndex))
							}
							//合计例次数
							Set ^TMP($zn,$j,NIndex,DimensKey,"MMRB")=$g(^TMP($zn,$j,NIndex,DimensKey,"MMRB"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MMRB"))	
						}
					}
					If (LocCount>1) {
						// 合计住院患者
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
							
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
						}
						// 合计检出细菌例数
						If ($d(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm))){
							If '$d(^TMP($zn,$j,NIndex,"Sum","BacPatAdm",LocID,Paadm)){
								Set ^TMP($zn,$j,NIndex,"Sum","BacPatAdm",LocID,Paadm)=""
								
								Set xMRBIndex=""
								For{
									Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,xMRBIndex))
									Quit:xMRBIndex=""
								
									Continue:xMRBIndex="MBac"
								
									//例次数
									Set ^TMP($zn,$j,NIndex,"Sum",xMRBIndex)=$g(^TMP($zn,$j,NIndex,"Sum",xMRBIndex))+$g(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,xMRBIndex))
								}
								//合计例次数
								Set ^TMP($zn,$j,NIndex,"Sum","MBac")=$g(^TMP($zn,$j,NIndex,"Sum","MBac"))+$g(^TMP($zn,$j,NIndex,"Bacteria",LocID,Paadm,"MBac"))	
							}
						}
						// 合计检出多耐例数
						If ($d(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm))){
							If '$d(^TMP($zn,$j,NIndex,"Sum","MRBPatAdm",LocID,Paadm)){
								Set ^TMP($zn,$j,NIndex,"Sum","MRBPatAdm",LocID,Paadm)=""
								
								For{
									Set xMRBIndex=$o(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,xMRBIndex))
									Quit:xMRBIndex=""
									Continue:xMRBIndex="MMRB"
								
									//例次数
									Set ^TMP($zn,$j,NIndex,"Sum",xMRBIndex)=$g(^TMP($zn,$j,NIndex,"Sum",xMRBIndex))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,xMRBIndex))
								}
								//合计例次数
								Set ^TMP($zn,$j,NIndex,"Sum","MMRB")=$g(^TMP($zn,$j,NIndex,"Sum","MMRB"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"MMRB"))	
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
		Set MBacCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"MBac")) 		//细菌总例次数
		Set MMRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"MMRB")) 		//多耐总例次数
		Continue:(IsActive="0")&&(PatAdmCnt=0)	
		Continue:(aQryCon="2")&&(MMRBCase=0)
		Continue:(aQryCon="3")&&(PatAdmCnt=0)
		
		Set xMRBTypeID=""
		For{
			Set xMRBTypeID=$o(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			Quit:xMRBTypeID=""
			
			Set MRBType=$g(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			
			Set BacCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,MRBType_"Bac"))   	//M1同期检出菌的例次数
			Set MRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,MRBType_"MRB")) 	//M1同期检出多耐例次数
			Set Ratio="0.00%"
			Set:BacCase>0 Ratio=$fn((MRBCase/BacCase)*100,"",2)_"%"	 			//M1检出率
			
			Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,xMRBTypeID,MRBType,BacCase,MRBCase,Ratio,MBacCase,MMRBCase)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If (LocCount>1) {
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))    	//住院患者人数
		Set MBacCase  =+$g(^TMP($zn,$j,NIndex,"Sum","MBac")) 		//细菌总例次数
		Set MMRBCase  =+$g(^TMP($zn,$j,NIndex,"Sum","MMRB")) 		//多耐总例次数
		
		Set xMRBTypeID=""
		For{
			Set xMRBTypeID=$o(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			Quit:xMRBTypeID=""
			
			Set MRBType=$g(^TMP($zn,$j,NIndex,"MRBIType",xMRBTypeID))
			
			Set BacCase  =+$g(^TMP($zn,$j,NIndex,"Sum",MRBType_"Bac"))   	//M1同期检出菌的例次数
			Set MRBCase  =+$g(^TMP($zn,$j,NIndex,"Sum",MRBType_"MRB")) 	//M1同期检出多耐例次数
			Set Ratio="0.00%"
			Set:BacCase>0 Ratio=$fn((MRBCase/BacCase)*100,"",2)_"%"	 			//M1检出率
			
			Set Data=$lb("","全部",PatAdmCnt,xMRBTypeID,MRBType,BacCase,MRBCase,Ratio,MBacCase,MMRBCase)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryMRBPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosExecute ]
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
/// Description:	多重耐药菌检出明细表(不统计污染)
/// Input:		    aHospIDs：院区
/// 				aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 维度
/// 				aLocType：统计类型
/// 				aLocIDs：科室
/// 			    aMRBCode : 多耐分类代码
/// 			    aType :1-细菌,2-多耐 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.STar005","QryMRBPosDtl","1","2020-05-01","2020-05-31","0001-00-0000-H-2","W","","M1")
Query QryMRBPosDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBType As %String = "", aType As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryMRBPosDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBType As %String = "", aType As %String = "") As %Status
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
	Set MRBLinkCode=""
	Set MRBTypeList=##class(DHCHAI.BT.Config).GetValByCode("MRBTypeList")
	For xMRBTypeID=1:1:$l(MRBTypeList,"|"){
		Set MRBTypeInfo=$p(MRBTypeList,"|",xMRBTypeID)		//CRE|M4,M5
		
		Set MRBType=$p(MRBTypeInfo,"#",1)
		//过滤多耐类别
		Continue:(aMRBType'="")&&(aMRBType'=MRBType)
		Set MRBLinkCode=MRBLinkCode_"&"_$p(MRBTypeInfo,"#",2)
	}
	Set:MRBLinkCode'="" MRBLinkCode=MRBLinkCode_"&"
	
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
						Set MRBCode    = $lg(MRBInfo,2)		//多耐1->Code
						Set MRBDesc    = $lg(MRBInfo,3)		//多耐1->名称
						Set MRB2Code   = $lg(MRBInfo,4)		//多耐2->Code
						Set MRB2Desc   = $lg(MRBInfo,5)		//多耐2->名称
						Set BacDesc    = $lg(MRBInfo,7)		//细菌名称
						Continue:BacDesc=""
						//过滤污染细菌
						Set IsPollute=$lg(MRBInfo,13)
						Continue:IsPollute="1"
						
						If (IsUnRepeat="1"){
							//是否第一株菌
							Set IsFirstSendBac=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"1")
							Continue:(aType="1")&&(IsFirstSendBac'="1")
							//是否第一株多耐
							Set IsFirstSendMrb=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"2")
							Continue:(aType="2")&&(IsFirstSendMrb'="1")
						}
						//存储检验相关信息
						Set SpeDesc    = $lg(MRBInfo,6)		//标本名称
						Set ActDateTime=$lg(MRBInfo,8)		//送检日期
						Set RepDateTime=$lg(MRBInfo,9)		//报告日期
						Set LabEpisodeNo=$lg(MRBInfo,15)	//标本号
						Set LabTestSet=$lg(MRBInfo,16)		//检验医嘱
						
						Set IsInfMRBFlag=$lg(MRBInfo,11)		//院感
						Set IsComMRBFlag=$lg(MRBInfo,12)		//社区
						Set InfType=""
						Set:IsComMRBFlag="1" InfType="社区感染"
						Set:IsInfMRBFlag="1" InfType="医院感染"
						
						If (aType="1"){			//细菌
							Set MRBType=$lg(MRBInfo,17)
							
							//汇总只统计九大重点菌
							Set IsMRBLinkBac="0"
							For xBacTypeID=1:1:$l(MRBType,","){
								Set BacType=$p(MRBType,",",xBacTypeID)
								Continue:BacType=""
								Continue:(MRBLinkCode'="")&&(MRBLinkCode'[("&"_BacType_"&"))
								
								Set:(MRBLinkCode'="")&&(MRBLinkCode[BacType) IsMRBLinkBac="1"
								Quit:IsMRBLinkBac="1"
							}
							Continue:IsMRBLinkBac'="1"
							
							//存储检验相关信息
							Set LabInfo=$lb(ResID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpeDesc,BacDesc,InfType)
						
							Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_LabInfo
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}						
						else{					//多耐
							If (MRBCode'=""){
								If ((MRBLinkCode'="")&&(MRBLinkCode[("&"_MRBCode_"&"))){
									Set LabInfo=$lb(ResID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpeDesc,BacDesc,InfType)
									
									Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_LabInfo
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
							If (MRB2Code'=""){
								If ((MRBLinkCode'="")&&(MRBLinkCode[("&"_MRB2Code_"&"))){
									Set LabInfo=$lb(ResID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRB2Desc,SpeDesc,BacDesc,InfType)
									
									Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_LabInfo
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
					}
				}
		    }
		}
	}
	Quit $$$OK
}

ClassMethod QryMRBPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosDtlExecute ]
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
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.STar005","QryMRBPosPatDtl","","2020-05-01","2020-05-31","0000-00-0000-A-1","E")
Query QryMRBPosPatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryMRBPosPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Status
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

ClassMethod QryMRBPosPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosPatDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, f inish fetching
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

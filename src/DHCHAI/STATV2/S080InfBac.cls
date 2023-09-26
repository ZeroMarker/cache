/// 名称: DHCHAI.STATV2.S080InfBac
/// 描述: 医院感染病原体构成比统计表
/// 编写者: mayanpeng(ShenC改造)
/// 编写日期: 2022-11-18
Class DHCHAI.STATV2.S080InfBac Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		mayanpeng(ShenC改造)
/// CreateDate：	2022-11-22
/// Description:	采集日期查询检验报告病原体(医院感染病原体构成比、革兰氏阴/阳性菌占比)
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期  
/// 			  	aLocType ：科室/病区类型
/// 			  	aQryCon：  有效数据筛查  
///              	aStatDimens:  展示维度
///               	aLocIDs:    科室
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S080InfBac","QryPathogeny","1","2020-05-01","2020-05-31","W","2","HGW","")
Query QryPathogeny(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,BacDesc:%String,BacCnt:%Integer,SumBacCnt:%Integer,BacRatio:%String") [ SqlProc ]
{
}

ClassMethod QryPathogenyExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
 	
 	Set NIndex="QryPathogeny"
	Kill ^TMP($zn,$j,NIndex)
	//HA判断方式--1：只取院感报告关联数据，2：只取感染标记数据，0或其他：取所有类型数据
	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
	//是否去重：-0：不去重，1：去重
	Set IsUnRepeat=##class(DHCHAI.BT.Config).GetValByCode("IsUnRepeat")
	//去重判断方式-1：保留第一珠菌/多耐,2:保留同标本第一珠菌/多耐
	Set UnRepeatType=##class(DHCHAI.BT.Config).GetValByCode("UnRepeatType")
	
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
				//统计维度(记录数据)
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				//循环转科
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
					
					//患者细菌信息
					Set ListBacArray=..GetBacteriaInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
					For xBacID=1:1:ListBacArray.Count() {
						Set BacInfo=ListBacArray.GetAt(xBacID)	
						Continue:BacInfo=""
					
						Set IsInfFlag = $lg(BacInfo,12)		//是否院感
						Continue:IsInfFlag'=1
							
						Set BacDesc   = $lg(BacInfo,6)		//细菌
						Continue:BacDesc=""
						Set ResID	   = $lg(BacInfo,1)		//ID
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"1")
							Continue:IsFirstSend'=1
						}
						
						For indDimens=1:1:$l(StatDimensInfo,"^") {
							Set DimensKey=$p(StatDimensInfo,"^",indDimens)
							Continue:DimensKey=""
						
							// 医院感染病原体
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"BacCnt",BacDesc))
							// 汇总
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"BacCnt"))
							
							If (LocCount>1) {
								If '$d(^TMP($zn,$j,NIndex,"Sum","BacRst",ResID)){
									Set ^TMP($zn,$j,NIndex,"Sum","BacRst",ResID)=""
							
									// 医院感染病原体
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","BacCnt",BacDesc))
									//汇总
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","BacCnt"))
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
		Set xDimensKey	=$lg(DimList,1)
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))		//过滤科室
		
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))					//单院区不显示全院
		Continue:xDimensKey=""
		
		Set xBacDesc=""
		For {
			Set xBacDesc=$o(^TMP($zn,$j,NIndex,xDimensKey,"BacCnt",xBacDesc))
			Quit:xBacDesc=""
			
			// 医院感染病原体
			Set BacCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"BacCnt",xBacDesc))
			// 汇总
			Set SumBacCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"BacCnt"))	
			// 构成比
			Set Ratio="0.00%"
			Set:SumBacCnt>0 BacRatio=$fn((BacCnt/SumBacCnt)*100,"",2)_"%" 
				
			Set Data=$lb(xDimensKey,DimensDesc,xBacDesc,BacCnt,SumBacCnt,BacRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}				
	}
	If (LocCount>1) {
		Set xBacDesc=""
		For {
			Set xBacDesc=$o(^TMP($zn,$j,NIndex,"Sum","BacCnt",xBacDesc))
			Quit:xBacDesc=""
			
			// 合计医院感染病原体
			Set BacCnt=+$g(^TMP($zn,$j,NIndex,"Sum","BacCnt",xBacDesc))
			// 汇总
			Set SumBacCnt=+$g(^TMP($zn,$j,NIndex,"Sum","BacCnt"))	
			// 构成比
			Set Ratio="0.00%"
			Set:SumBacCnt>0 BacRatio=$fn((BacCnt/SumBacCnt)*100,"",2)_"%" 
				
			Set Data=$lb("ALL","全部",xBacDesc,BacCnt,SumBacCnt,BacRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}	  	
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryPathogenyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathogenyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathogenyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathogenyExecute ]
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
/// CreateDate：	2022-11-22
/// Description:	采集日期查询检验报告病原体(医院感染病原体构成比、革兰氏阴/阳性菌占比)
/// Input:		    aHospIDs：院区
/// 				aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 维度
/// 				aLocType：统计类型
/// 				aLocIDs：科室
/// 			    aBacDesc : 细菌标准名
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S080InfBac","QryPathogenyDtl","1","2020-01-01","2020-12-31","0001-00-0000-H-2","W","","")
Query QryPathogenyDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aBacDesc As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryPathogenyDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aBacDesc As %String = "") As %Status
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
					
					//患者病原体信息
	    			Set ListBacArray=..GetBacteriaInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
	    			For xBacID=1:1:ListBacArray.Count() {
						Set BacInfo=ListBacArray.GetAt(xBacID)	
						Continue:BacInfo=""
						
						Set IsInfFlag = $lg(BacInfo,12)		//是否院感
						Continue:IsInfFlag'=1
							
						Set BacDesc   = $lg(BacInfo,6)		//细菌
						Continue:BacDesc=""
						//过滤细菌
						Continue:(aBacDesc'="")&&(aBacDesc'=BacDesc)
						
						Set ResID	   = $lg(BacInfo,1)		//ID
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"1")
							Continue:IsFirstSend'=1
						}
						Set SpeDesc    = $lg(BacInfo,5)		//标本名称
						Set ActDateTime=$lg(BacInfo,10)		//送检日期
						Set RepDateTime=$lg(BacInfo,11)		//报告日期
						Set LabEpisodeNo=$lg(BacInfo,16)	//标本号
						Set LabTestSet=$lg(BacInfo,17)		//检验医嘱
						Set MRBDesc=$lg(BacInfo,9)			//耐药级别
						Set InfType=""						//感染类型
						Set:$lg(BacInfo,12)="1" InfType="医院感染"
						Set:$lg(BacInfo,13)="1" InfType="社区感染"
						//存储病原体相关信息
						Set LabInfo=$lb(ResID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpeDesc,BacDesc,InfType)
						
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

ClassMethod QryPathogenyDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathogenyDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathogenyDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathogenyDtlExecute ]
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

/// Creator：     pylian(ShenC改造)
/// CreatDate：   2022-11-21
/// Description:  获取患者细菌信息
/// Table：       DHCHAI.IR.CCResult
/// Input:        aEpisodeID：就诊ID
/// return:       细菌送检信息
/// w ##class(DHCHAI.STATV2.S080InfBac).GetBacteriaInfo("535","65200","65690")
ClassMethod GetBacteriaInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aHAType As %String = "") As %Library.ArrayOfDataTypes
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
				//细菌类别
				Set BacTypeCode="",BacTypeDesc=""
				Set BacTypeDr=$List(BactData,5)
				If (BacTypeDr'=""){
					Set TypeInfo = $g(^DHCHAI.DP.LabBactTypeD(BacTypeDr))
					If TypeInfo'="" {
						Set BacTypeCode = $List(TypeInfo,2)
						Set BacTypeDesc = $List(TypeInfo,3)
					}
				}
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
				Set:MRB2Desc'="" MRBDesc=MRBDesc_","_MRB2Desc		//合并
				//判断'院感'(aHAType--1：只取院感报告关联数据，2：只取感染标记数据，0：取所有类型数据
				Set IsInfFlag=0
				
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
					Set:LabInfType=1 IsInfFlag=1    
				}
				else{
					//1:判断院感->院感报告关联
					Set xINFId=""            
					For{
						Set xINFId=$o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",aEpisodeID,LabReportDr,xINFId))
						Quit:xINFId=""
						Continue:IsInfFlag=1
											
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
						    	Set IsInfFlag=1
						    	Quit
							}
						}	
					}
					//0或其他:判断院感->取所有类型数据
					Set:(aHAType'=1)&&(aHAType'=2)&&(LabInfType=1) IsInfFlag=1	//感染标记'HA'计为院感
					If ((aHAType'=1)&&(aHAType'=2)&&(IsInfFlag="0")){
						//疑似筛查确认细菌
						Set xItmScreenDr=""
						For {
							Set xItmScreenDr=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,xItmScreenDr))
							Quit:xItmScreenDr=""
							Continue:IsInfFlag=1	
											
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
								    	Set IsInfFlag=1
								    	Quit
									}
								}
							}													
						}
					}
				}
				//判断社区
				Set IsComFlag=0
				Set:LabInfType=2 IsComFlag=1
				//判断污染
				Set IsPollute=0
				Set:LabInfType=4 IsPollute=1
				//判断定值
				Set IsDZFlag=0
				Set:LabInfType=3 IsDZFlag=1  
				
				//输出检出菌数据
				//1.xID,2.LabVisitID,3.LabReportDr,4.ResultID,5.SpeDesc,6.BacDesc,7.BacTypeCode,8.BacTypeDesc,9.MRBDesc,10.ActDateTime
				//11.RepDateTime,12.IsInfFlag,13.IsComFlag,14.IsPollute,15.IsDZFlag,16.LabEpisodeNo,17.LabTestSet,18.BacID
			   	Set Data=$lb(xID,LabVisitID,LabReportDr,ResultID,SpeDesc,BacDesc,BacTypeCode,BacTypeDesc,MRBDesc,ActDateTime,RepDateTime,IsInfFlag,IsComFlag,IsPollute,IsDZFlag,LabEpisodeNo,LabTestSet,BacID)
			   	Set Count=Count+1
				Do return.SetAt(Data,Count)
			}
		}
	}
	Quit return
}

}

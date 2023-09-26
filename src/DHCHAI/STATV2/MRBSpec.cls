/// 名称: DHCHAI.STATV2.MRBSpec
/// 描述: 多耐检出标本分布统计表
/// 编写者：ShenC
/// 编写日期: 2022-11-15
Class DHCHAI.STATV2.MRBSpec Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		ShenC
/// CreateDate：	2022-11-15
/// Description:	多耐检出标本分布统计表
/// Input:          aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期  
/// 			  	aLocType ：科室/病区类型
/// 			  	aQryCon：  有效数据筛查  
///              	aStatDimens:  展示维度
///               	aLocIDs:    科室
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.MRBSpec","QryMRBSpec","1","2020-05-01","2020-05-31","W","2","HGW","")
Query QryMRBSpec(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "SpeDesc:%String,MRBCode:%String,MRBDesc:%String,Cnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryMRBSpecExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
	
 	Set NIndex="QryMRBSpec"
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
						Set SpeDesc	   = $lg(MRBInfo,6)		//标本名称
						Set BacDesc    = $lg(MRBInfo,7)		//细菌名称
						Set IsInfMRBFlag = $lg(MRBInfo,11)	//院感
						Continue:BacDesc=""
						Continue:(MRBDesc="")&&(MRB2Desc="")
						If (aQryCon="1"){		//九大重点菌(Code包含M)
							Continue:(MRBDesc'["M")&&(MRB2Code'["M")
						}
						
						If (MRBDesc'=""){
							//同期检出多耐的标本例数
							Set num = $i(^TMP($zn,$j,NIndex,"MRB",SpeDesc,MRBCode_"^"_MRBDesc))
						}
						If (MRB2Code'=""){
							Set num = $i(^TMP($zn,$j,NIndex,"MRB",SpeDesc,MRB2Code_"^"_MRB2Desc))
						}
					}
				}
		    }
		}
	}
	// 输出Data
	Set xSpeDesc=""
	For{
		Set xSpeDesc=$o(^TMP($zn,$j,NIndex,"MRB",xSpeDesc))
		Quit:xSpeDesc=""
		
		Set xMRBDesc=""
		For{
			Set xMRBDesc=$o(^TMP($zn,$j,NIndex,"MRB",xSpeDesc,xMRBDesc))
			Quit:xMRBDesc=""
			
			Set Cnt=+$g(^TMP($zn,$j,NIndex,"MRB",xSpeDesc,xMRBDesc))
			Set MRBCode=$p(xMRBDesc,"^",1)
			Set MRBDesc=$p(xMRBDesc,"^",2)
			
			Set Data=$lb(xSpeDesc,MRBCode,MRBDesc,Cnt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}	
	
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryMRBSpecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBSpecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBSpecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBSpecExecute ]
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

/// Creator：		ShenC
/// CreateDate：	2022-11-15
/// Description:	多耐检出标本分布统计表-分子(多耐)
/// Input:		    aHospIDs：院区
/// 				aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 标本名称
/// 				aLocType：统计类型
/// 				aLocIDs：科室
/// 			    aMRBCode : 多耐分类代码
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.MRBSpec","QryMRBSpecDtl","1","2020-05-01","2020-05-31","腹水","W","","")
Query QryMRBSpecDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBCode As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryMRBSpecDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aMRBCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//处理日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
   
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
			Continue:HospDr=""
			//过滤院区
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)				
		
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
						
						Set ResID	   = $lg(MRBInfo,2)		//ID
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"2")
							Continue:IsFirstSend'=1
						}
						Set BacDesc    = $lg(MRBInfo,7)		//细菌名称
						Continue:BacDesc=""
						Set MRBCode    = $lg(MRBInfo,2)		//多耐1->Code
						Set MRBDesc    = $lg(MRBInfo,3)		//多耐1->名称
						Set MRB2Code   = $lg(MRBInfo,4)		//多耐2->Code
						Set MRB2Desc   = $lg(MRBInfo,5)		//多耐2->名称
						Continue:(MRBCode="")&&(MRB2Code="")
						Set SpeDesc    = $lg(MRBInfo,6)		//标本名称
						//过滤标本名称
						Continue:(aDimensKey'="")&&(aDimensKey'=SpeDesc)
						//过滤多耐类别
						Continue:(aMRBCode'="")&&(aMRBCode'=MRBCode)&&(aMRBCode'=MRB2Code)
						
						Set:MRB2Desc'="" MRBDesc=MRBDesc_","_MRB2Desc	//合并
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
						
						//存储检验相关信息
						Set LabInfo=$lb(ResID,LabEpisodeNo,LabTestSet,ActDateTime,RepDateTime,MRBDesc,SpeDesc,BacDesc,InfType)
						
						Set DimensDesc=SpeDesc
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

ClassMethod QryMRBSpecDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBSpecDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBSpecDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBSpecDtlExecute ]
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

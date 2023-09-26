/// 名称: DHCHAI.STATV2.S110InfBacSen
/// 描述: IIHAI-30医院感染病原体对抗菌药物的耐药率
/// 编写者: mayanpeng(ShenC改造)
/// 编写日期: 2022-11-23
Class DHCHAI.STATV2.S110InfBacSen Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		pylian
/// CreateDate：	2017-09-25
/// Description:	查询检验报告病原体药敏结果(医院感染病原体对抗菌药物的耐药率)
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期  
/// 			  	aLocType ：科室/病区类型
/// 			  	aQryCon：  有效数据筛查  
///              	aStatDimens:  展示维度
///               	aLocIDs:    科室
/// 				aBacDescs: 	细菌
/// 				aAntDescs:	抗菌药
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S110InfBacSen","QryRepRstSen","1","2022-01-01","2022-03-31","W","2","HGW","","鲍曼不动杆菌")
Query QryRepRstSen(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aBacDescs As %Text = "", aAntDescs As %Text = "") As %Query(ROWSPEC = "AntDesc:%String,BacDesc:%String,NoSCnt:%Integer,Cnt:%Integer,Ratio:%String") [ SqlProc ]
{
}

ClassMethod QryRepRstSenExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aBacDescs As %Text = "", aAntDescs As %Text = "") As %Status
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
 	
 	Set NIndex="QryRepRstSen"
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
					Set ListBacArray=##class(DHCHAI.STATV2.S080InfBac).GetBacteriaInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
					For xBacID=1:1:ListBacArray.Count() {
						Set BacInfo=ListBacArray.GetAt(xBacID)	
						Continue:BacInfo=""
					
						Set IsInfFlag = $lg(BacInfo,12)		//是否院感
						Continue:IsInfFlag'=1
							
						Set BacDesc   = $lg(BacInfo,6)		//细菌标准名
						Continue:BacDesc=""
						Set BacID	  = $lg(BacInfo,18)
						//过滤细菌
						Continue:(aBacDescs'="")&&((","_aBacDescs_",")'[(","_BacID_","))
						
						Set ResID	   = $lg(BacInfo,1)		//ID
						Set RstData = $g(^DHCHAI.IR.CCResultD(ResID))
						Continue:RstData=""
						Set SCode    = $lg(RstData,17)		// 子系统代码
			
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"1")
							Continue:IsFirstSend'=1
						}
						Set ResultID=$lg(BacInfo,4)			//检验结果ID
						
						Set xSenID = ""
						For {
		    				Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
		    				Quit:xSenID=""
		    	
		    				Set SenInfo=$g(^DHCHAI.DP.LabVisitRepRstSenD(xSenID))
							Continue:SenInfo=""
				
							Set AntCode = $List(SenInfo,3)		//药敏代码
							Set AntDesc = $List(SenInfo,4)		//药敏名称
							Continue:AntDesc=""
							//取抗菌药标准名
							Set MapAntID = $o(^DHCHAI.DP.LabAntiMapI("IndexSCodeAntiDesc","LIS01",AntDesc,""))
							Set MapData=$g(^DHCHAI.DP.LabAntiMapD(MapAntID))
							Continue:MapData=""
							Set AntID=$lg(MapData,3)
							
							//过滤抗菌药
							Continue:(aAntDescs'="")&&((","_aAntDescs_",")'[(","_AntID_","))
							
							Set TestSen = $List(SenInfo,5)		//药敏结果
							Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
			 				Set:MapTestSen="" MapTestSen=TestSen	//药敏结果为空
			 				
			 				//存储数据
			 				Set:MapTestSen'="S" num=$i(^TMP($zn,$j,NIndex,"RstSen",AntDesc,BacDesc,"NoS"))	//非敏感
			 				Set num=$i(^TMP($zn,$j,NIndex,"RstSen",AntDesc,BacDesc))
						}
					}
				}
		    }
		}
	}
	//输出数据
	Set xAntDesc=""
	For{
		Set xAntDesc=$o(^TMP($zn,$j,NIndex,"RstSen",xAntDesc))
		Quit:xAntDesc=""
		
		Set xBacDesc=""
		For{
			Set xBacDesc=$o(^TMP($zn,$j,NIndex,"RstSen",xAntDesc,xBacDesc))
			Quit:xBacDesc=""
			
			Set NoSCnt=+$g(^TMP($zn,$j,NIndex,"RstSen",xAntDesc,xBacDesc,"NoS"))	//非敏感
			Set Cnt=+$g(^TMP($zn,$j,NIndex,"RstSen",xAntDesc,xBacDesc))
			Set Ratio="0.00%"
			Set:Cnt>0 Ratio=$fn((NoSCnt/Cnt)*100,"",2)_"%"	 	//耐药率
			
			Set Data=$lb(xAntDesc,xBacDesc,NoSCnt,Cnt,Ratio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}	
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryRepRstSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepRstSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepRstSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepRstSenExecute ]
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
/// CreateDate：	2022-11-23
/// Description:	查询检验报告病原体药敏结果明细
/// Input:		    aHospIDs：院区
/// 				aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aAntDesc: 抗菌药物
/// 				aLocType：科室类型
/// 				aLocIDs：科室
/// 			    aBacDesc : 细菌标准名
/// 				aTestSenType：药敏类型
/// Return：      返回ROWSPEC
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S110InfBacSen","QryRepRstSenDtl","1","2022-01-01","2022-03-31","","W","","表皮葡萄球菌","1")
Query QryRepRstSenDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aAntDesc As %String, aLocType As %String, aLocIDs As %Text = "", aBacDesc As %String = "", aTestSenType As %String = "") As %Query(ROWSPEC = "AntDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String,TestSen:%String,MapTestSen:%String") [ SqlProc ]
{
}

ClassMethod QryRepRstSenDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aAntDesc As %String, aLocType As %String, aLocIDs As %Text = "", aBacDesc As %String = "", aTestSenType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//处理日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//院区
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
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set HospDr=$lg(LocData,8)
			Continue:HospDr=""
			//过滤院区
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)				
			//医院分组
			Set HospInfo="",HospGroupDr=""
			Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
			Set HospGroupDr=$lg(HospInfo,5) 
			Continue:HospGroupDr="" 
			Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
			
			Set GroupDr  = $lg(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}
			Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
			Set GroupDesc=$li(GroupData,3)
			
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
	    			Set ListBacArray=##class(DHCHAI.STATV2.S080InfBac).GetBacteriaInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,HAType)
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
						Set RstData = $g(^DHCHAI.IR.CCResultD(ResID))
						Continue:RstData=""
						Set SCode    = $lg(RstData,17)		//子系统代码
						//去重
						If (IsUnRepeat="1"){
							Set IsFirstSend=##Class(DHCHAI.STATV2.S040MRBInf).IsFirstSend(Paadm,ResID,UnRepeatType,"1")
							Continue:IsFirstSend'=1
						}
						Set ResultID=$lg(BacInfo,4)			//检验结果ID
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
						
						//循环药敏结果
						Set xSenID = ""
						For {
		    				Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
		    				Quit:xSenID=""
		    	
		    				Set SenInfo=$g(^DHCHAI.DP.LabVisitRepRstSenD(xSenID))
							Continue:SenInfo=""
				
							Set AntCode = $List(SenInfo,3)		//药敏代码
							Set AntDesc = $List(SenInfo,4)		//药敏名称
							Continue:AntDesc=""
							//过滤药敏
							Continue:(aAntDesc'="")&&(aAntDesc'=AntDesc)
							
							Set TestSen = $List(SenInfo,5)		//药敏结果
							Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
			 				Set:MapTestSen="" MapTestSen=TestSen	//药敏结果为空
			 				//过滤药敏类型
			 				Continue:(aTestSenType="1")&&(MapTestSen="S")		//非敏感
			 			
			 				Set Data = $lb(AntDesc,AdmTimes)_PatData_TransInfo_LabInfo_$lb(TestSen,MapTestSen)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1	
						}
					}
				}
		    }
		}
	}
	
	Quit $$$OK
}

ClassMethod QryRepRstSenDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepRstSenDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepRstSenDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepRstSenDtlExecute ]
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

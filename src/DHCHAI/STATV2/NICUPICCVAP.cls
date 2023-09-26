/// 名称: DHCHAI.STATV2.S350BWPICCInf
/// 描述: 出生体重分组新生儿中央血管导管相关血流感染发病率统计表
/// 编写者: zhugz
/// 编写日期: 2019-12-11
Class DHCHAI.STATV2.NICUPICCVAP Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenrui
/// CreatDate：   2021-02-19
/// Description:  NICU插管汇总统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport,DHCHAI.IR.ICULog
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType : 统计类型-病区（和日志相关数据 按病区统计）
/// 			  aQryCon  ：是否筛选有效数据  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.NICUPICCVAP","QryCannulaInf","1|2","2020-05-01","2020-07-31","W",1,"")
Query QryCannulaInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,NewInCount:%Integer,WtCatDesc:%String,WtCat:%String,InDays:%Integer,PatNum:%Integer,InfPatNum:%Integer,InfCase:%Integer,InfRatio:%String,InfCaseRatio:%String,DayInfRatio:%String,DayInfCaseRatio:%String,APICCAdmNum:%Integer,APICCDays:%Integer,PICCUseRatio:%String,PICCInfPat:%Integer,PICCInfCase:%Integer,PICCRatio:%String,AVAPAdmNum:%Integer,AVAPDays:%Integer,VAPUseRatio:%String,VAPInfPat:%Integer,VAPInfCase:%Integer,VAPRatio:%String") [ SqlProc ]
{
}

ClassMethod QryCannulaInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"  //不是病区就是科室
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

    Set NIndex="QryCannulaInf"
	Kill ^TMP($zn,$j,NIndex)
	
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aLocType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
		
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set IsNICU=$lg(LocData,11)
		Continue:IsNICU'=1  		//update 按入院科室取新生儿时，新生儿标记随所在科室变化，根据20220216讨论结果，新生儿统计按NICU科室标记统计（与NICU日志保持一致），不按新生儿标记过滤

		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
	    //同期在科:某段时间的在科人数
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
	
			Set PaadmData = $g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:PaadmData=""
			Set IsNewBaby=$li(PaadmData,32)
			Set Weigth=$li(PaadmData,34)
			Set Weigth=+Weigth
			Set WtCat=5  						//默认体重未分型
			// 取体重等级及对应的天数人数
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"Adm",Paadm)) {
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"Adm",Paadm)=""
				If (Weigth<=1000)&&(Weigth>0) {
					Set WtCat=1	
				}
				ElseIf (Weigth>1000)&(Weigth<=1500) {
					Set WtCat=2
				}
				ElseIf (Weigth>1500)&(Weigth<=2500) {
					Set WtCat=3
				}
				ElseIf (Weigth>2500){
					Set WtCat=4
				}
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"Adm",Paadm,"WtCat")=WtCat
				Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"PatNum"))
			}
			
			//在科天数
	    	Set InDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransIDs)
			Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InDays") = +$g(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InDays"))+InDays
			//感染信息
			Set InfPosInfo =##class(DHCHAI.STATV2.ICUAdOfInfect).GetInfInfo(Paadm,aDateFrom,aDateTo,LocDr,WardDr)		
			
			If '$d(^TMP($zn,$j,NIndex,"PatLocAdm",LocID,Paadm)) { 
				Set ^TMP($zn,$j,NIndex,"PatLocAdm",LocID,Paadm)=""
				
				For xTypeCode = 1:1:2 {
					Set TubeType=$CASE(xTypeCode,"1":"VAP","2":"PICC","3":"0")						
					Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,WtCat,TubeType,aLocType)
					If (Days'=0){
						If ('$d(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubePat",TubeType,Paadm))) {
							Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubePat",TubeType,Paadm)=""												
							Set Num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubeCount",TubeType))
							Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubeDays",TubeType)=$g(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubeDays",TubeType))+Days
						}
					}		
					If (InfPosInfo'="") {
						For InfNo=1:1:$L(InfPosInfo,"|") {
							Set InfPosMsg=$p(InfPosInfo,"|",InfNo)
							Continue:InfPosMsg=""
							Set DiagID	= $p(InfPosMsg,"^",1)
							Set InfDate = $p(InfPosMsg,"^",2)
							Set InfPos  = $p(InfPosMsg,"^",3)
							
							Set DiagData=$g(^DHCHAI.IR.INFDiagnosD(DiagID))
							Set InfType="医院感染"
							Set InfTypeCode=$lg(DiagData,18)
							If (InfTypeCode'=""){
								Set:InfTypeCode=0 InfType="社区感染"
							}Else{
						   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
							}
							
							If ('$d(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPatNum",Paadm))) {
								Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPatNum",Paadm)=""
								Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPatNum"))
							}
							
							If (xTypeCode=1) {   //感染例次只需计算一次
								Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPatCase"))
				       		}
							Set INFSubDr=$li(DiagData,4)
							Continue:INFSubDr=""
							Set INFSubSData=$g(^DHCHAI.BT.InfSubD(INFSubDr))
							Set INFSubDesc=$li(INFSubSData,3)
							
							If (TubeType="PICC")&&(INFSubDesc["CLABSI") { 
								If ('$d(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPat","PICC",Paadm))) {
									Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPat","PICC",Paadm)=""
									Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPat","PICC"))
								}
								Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfCase","PICC"))
							}ElseIf (TubeType="VAP")&&(INFSubDesc["VAP") { 
								If ('$d(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPat","VAP",Paadm))) {
									Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPat","VAP",Paadm)=""
									Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfPat","VAP"))
								}
								Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfCase","VAP"))
							}
						}
					}
				}				
			}
		}
    }
	//科室，体重类别，住院天数，住院人数，感染例次
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Loc",xLocID))
		Quit:xLocID=""
		
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Continue:LocData=""
		Set LocDesc = $li(LocData,3)
		Set LocDesc2 = $li(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set IsActive 	= $li(LocData,14)
			
		Set xWtCat=""
		For {
			Set xWtCat=$o(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat))
			Quit:xWtCat=""			
			
			Set InDays		= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InDays"))			// 住院天数
			Set PatNum		= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"PatNum"))			// 住院人数
			Set InfPatNum 	= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfPatNum"))		// 感染人数
			Set InfCase 	= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfPatCase"))     // 同期感染例次数
			Set PICCInfPat	= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfPat","PICC"))	// 血管导管感染人数
			Set PICCInfCase	= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfCase","PICC"))	// 血管导管感染例次数
			Set VAPInfPat	= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfPat","VAP"))	// 呼吸机感染人数
			Set VAPInfCase	= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfCase","VAP"))	// 呼吸机感染例次数		    
		    Set APICCDays   = +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"TubeDays","PICC"))
		    Set AVAPDays    = +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"TubeDays","VAP"))
		     
		    Set APICCAdmNum = +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"TubeCount","PICC"))
		    Set AVAPAdmNum	= +$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"TubeCount","VAP"))
		      
			Set NewInCount = ..NewInCount(aDateFrom,aDateTo,xLocID,xWtCat)
		 
			Continue:('IsActive)&&(PatNum=0)	
			Continue:(aQryCon=2)&&((InfCase=0)&(APICCDays=0)&(AVAPDays=0))
			Continue:(aQryCon=3)&&(InDays=0)
			
			Set (InfRatio,InfCaseRatio,PICCUseRatio,VAPUseRatio) = "0.00%"
			Set (PICCRatio,VAPRatio,DayInfRatio,DayInfCaseRatio) = "0.000‰"
			
			Set:PatNum>0 InfRatio 			= $fn((InfPatNum/PatNum)*100,"",2)_"%" 			// 同期新发生医院感染率
			Set:PatNum>0 InfCaseRatio 		= $fn((InfCase/PatNum)*100,"",2)_"%" 			// 同期新发生医院感染例次率
			
			Set:InDays>0 DayInfRatio 		= $fn((InfPatNum/InDays)*1000,"",3)_"‰" 		// 同期新发生医院日感染率
			Set:InDays>0 DayInfCaseRatio 	= $fn((InfCase/InDays)*1000,"",3)_"‰" 			// 同期新发生医院日感染例次率
			
			Set:InDays>0 PICCUseRatio 		= $fn((APICCDays/InDays)*100,"",2)_"%" 			// 血管导管使用率
			Set:InDays>0 VAPUseRatio 		= $fn((AVAPDays/InDays)*100,"",2)_"%" 			// 呼吸机使用率
			
			Set:AVAPDays>0 VAPRatio 		= $fn((VAPInfCase/AVAPDays)*1000,"",3)_"‰" 		// 呼吸机感染率
			Set:APICCDays>0 PICCRatio 		= $fn((PICCInfCase/APICCDays)*1000,"",3)_"‰" 	// 血管导管感染率
			Set WtCatDesc=$Case(xWtCat,1:"BW ≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW >2500g",5:"BW未填写")

			Set Data=$lb(xLocID,LocDesc,NewInCount,WtCatDesc,xWtCat,InDays,PatNum,InfPatNum,InfCase,InfRatio,InfCaseRatio,DayInfRatio,DayInfCaseRatio,APICCAdmNum,APICCDays,PICCUseRatio,PICCInfPat,PICCInfCase,PICCRatio,AVAPAdmNum,AVAPDays,VAPUseRatio,VAPInfPat,VAPInfCase,VAPRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCannulaInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCannulaInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCannulaInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCannulaInfExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2022-06-15
/// Description:  三管使用日数
/// Table：       
/// Input：       aLocDr : 科室  aDateFrom,aDateTo : 调查日期  aWtCat : 体重分类(0:成人,1/2/3/4新生儿体重分类)
/// Return：      返回 VAP^PICC^UC使用天数(每天使用人数相加)
/// w ##class(DHCHAI.STATV2.NICUPICCVAP).NewInCount("2019-01-01","2021-01-01","")
ClassMethod NewInCount(aDateFrom As %String, aDateTo As %String, aLocDr As %String = "", aWtCat As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLocDr,aWtCat)
	Set NewCount = 0
	Quit:(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aWtCat=0 aWtCat=5
	If (aLocDr=""){
		Set aLocDr = ""
		For {
			Set aLocDr=$o(^DHCHAI.IR.ICULogI("IndexLocDate",aLocDr))
			Quit:aLocDr=""
			For xDate=aDateFrom:1:aDateTo{
				Set xICULogID=""
				For {
					Set xICULogID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",aLocDr,xDate,xICULogID))
					Quit:xICULogID=""
					
					// Add by zhaoyj 2022-06-15 Global方式
					Set ICULogData=$g(^DHCHAI.IR.ICULogD(xICULogID))
					Continue:ICULogData=""
					Set WtCat =$lg(ICULogData,12)
					Continue:(aWtCat'="")&&(WtCat'=aWtCat)
					Set ILNewCnt =$lg(ICULogData,9)
					Set NewCount	=NewCount + ILNewCnt
				}
			} 
		} 
	} Else {
		Set Len = $L(aLocDr,",")
		If (Len=1){
			For xDate=aDateFrom:1:aDateTo{
				Set xICULogID=""
				For {
					Set xICULogID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",aLocDr,xDate,xICULogID))
					Quit:xICULogID=""
							
					// Add by zhaoyj 2022-06-15 Global方式
					Set ICULogData=$g(^DHCHAI.IR.ICULogD(xICULogID))
					Continue:ICULogData=""
					Set WtCat =$lg(ICULogData,12)
					Continue:(aWtCat'="")&&(WtCat'=aWtCat)
					Set ILNewCnt =$lg(ICULogData,9)
					Set NewCount	=NewCount + ILNewCnt
				}
			} 
		}Else{
			For i=1:1:Len{
				Set xLocDr = $p(aLocDr,",",i)
				For xDate=aDateFrom:1:aDateTo{
					Set xICULogID=""
					For {
						Set xICULogID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",aLocDr,xDate,xICULogID))
						Quit:xICULogID=""
						
						// Add by zhaoyj 2022-06-15 Global方式
						Set ICULogData=$g(^DHCHAI.IR.ICULogD(xICULogID))
						Continue:ICULogData=""
						Set WtCat =$lg(ICULogData,12)
						Continue:(aWtCat'="")&&(WtCat'=aWtCat)
						Set ILNewCnt =$lg(ICULogData,9)
						Set NewCount	=NewCount + ILNewCnt
					}
				} 
			}
		}
		
	}
	Set return=NewCount  //最后结果
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-06-15
/// Description:  使用三管患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aTubeType :  三管类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.NICUPICCVAP","QryTubePatDtl","2021-03-01","2021-07-31","54","4","PICC")
Query QryTubePatDtl(aDateFrom As %String, aDateTo As %String, aLocDr As %String, aWtCat As %String, aTubeType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTubePatDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocDr As %String, aWtCat As %String, aTubeType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="")||(aLocDr="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK

    Set NIndex="QryTubePatDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	// Add by zhaoyj 2022-06-15 Global方式
	Set LocData=$g(^DHCHAI.BT.LocationD(aLocDr))
	Quit:LocData="" $$$OK
	Set IsNICU=$lg(LocData,11)
	Quit:IsNICU'=1 $$$OK

	For xDate=aDateFrom:1:aDateTo {
		Set xAdmID=""
		For {
			Set xAdmID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocDr,xDate,xAdmID))
			Quit:xAdmID=""
			
			Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocDr,xDate,xAdmID,""))
			Continue:xDtlID=""
			Set DtlData=$g(^DHCHAI.IR.ICULogDtlD(xDtlID))
			Continue:DtlData=""
			Set ILEpisodeDr=$lg(DtlData,2)
			Continue:ILEpisodeDr=""
			Set IsNewBaby=$lg($g(^DHCHAI.DP.PAAdmD(ILEpisodeDr)),32)
			//Continue:IsNewBaby'=1   			// 过滤非新生儿	
			Set WtCat=5			
			Set Weigth=$lg($g(^DHCHAI.DP.PAAdmD(ILEpisodeDr)),34)
			Set Weigth=+Weigth
			Set:(Weigth<=1000)&&(Weigth>0) WtCat=1
			Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
			Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
			Set:(Weigth>2500) WtCat=4
			Continue:(aWtCat'="")&&(aWtCat'=WtCat)
			
			//使用呼吸机人数
			If (objDtl.ILIsVAP=1)&&('$d(^TMP($zn,$j,NIndex,"VAP",xAdmID))){
				Set ^TMP($zn,$j,NIndex,"VAP",xAdmID)=""
			}
			//脐/中心静脉置管人数
			If (objDtl.ILIsPICC=1)&&('$d(^TMP($zn,$j,NIndex,"PICC",xAdmID))){
				Set ^TMP($zn,$j,NIndex,"PICC",xAdmID)=""
			}
		}
	}
	
	Set xEpisID=""
	For {
		Set xEpisID=$o(^TMP($zn,$j,NIndex,aTubeType,xEpisID))
		Quit:xEpisID=""
		//患者基本信息
		Set PatData =..BuildPaadmData(xEpisID)
	    Continue:PatData=""
		Set ^CacheTemp(repid,ind)=PatData
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTubePatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubePatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubePatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubePatDtlExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenrui
/// CreatDate：   2022-06-15
/// Description:  查询NICU科室列表
/// Table：       DHCHAI.BT.Location
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.NICUPICCVAP","QryNICULoc","1","","I","E","1")
Query QryNICULoc(aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,LocTypeDr:%String,LocTypeCode:%String,LocTypeDesc:%String,LocCateDr:%String,LocCateCode:%String,LocCateDesc:%String,GroupDr:%String,GroupCode:%String,GroupDesc:%String,HospDr:%String,HospCode:%String,HospDesc:%String,IsOPER:%String,IsICU:%String,IsNICU:%String,ICUTpDr:%String,ICUTpCode:%String,ICUTpDesc:%String,XCode:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,ParLocDr:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryNICULocExecute(ByRef qHandle As %Binary, aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	 
	Set aLocCate=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocCate,"|")	 
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
	    Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
	    
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-15 Global方式
			Set LocData=$g(^DHCHAI.BT.LocationD(xID))
			Continue:LocData=""
			Continue:(aLocID'="")&&(xID'=aLocID)	//增加科室过滤
			Set (LocCode,LocDesc,LocDesc2,LocTypeCode,LocTypeDesc,LocCateCode,LocCateDesc,GroupCode,GroupDesc)=""
			Set (HospCode,HospDesc,IsICU,IsNICU,ICUTpCode,ICUTpDesc,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc)=""
			Set LocCode = $lg(LocData,2)
			Set BTDesc=$lg(LocData,3)
			Set LocDesc = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(BTDesc)
			Set BTDesc2=$lg(LocData,4)
			Set LocDesc2 = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(BTDesc2)
			Continue:(aIsActive'="")&&((LocDesc["停用")||(LocDesc2["停用"))		
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
			Continue:(aAlias'="")&&((LocCode'[aAlias)&&(LocDesc'[aAlias)&&(LocDesc2'[aAlias))
		
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			Set BTTypeDr=$lg(LocData,5)
			If (BTTypeDr'="") {
				Set LocTypeDr 	= BTTypeDr
				Set LocTypeCode	= $lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
				Set LocTypeDesc	= $lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),3)
			}
			Continue:(aLocType'="")&&(aLocType'=LocTypeCode)
			Set LocCateDr="",LocCateCode="",LocCateDesc=""
			Set BTCateDr=$lg(LocData,6)
			If (BTCateDr'="") {
				Set LocCateDr 	= BTCateDr
				Set LocCateCode	= $lg($g(^DHCHAI.BT.DictionaryD(BTCateDr)),2)
				Set LocCateDesc	= $lg($g(^DHCHAI.BT.DictionaryD(BTCateDr)),3)
			}
			Continue:(aLocCate'="")&&($listfind(aLocCate,LocCateCode)<1)
			Set GroupDr="",GroupCode="",GroupDesc=""
			Set BTGroupDr=$lg(LocData,7)
			If (BTGroupDr'="") {
				Set GroupDr 	= BTGroupDr
				Set GroupCode	= $lg($g(^DHCHAI.BT.LocGroupD(BTGroupDr)),2)
				Set GroupDesc	= $lg($g(^DHCHAI.BT.LocGroupD(BTGroupDr)),3)
			}
			
		    Set LocHospDr="",HospCode="",HospDesc=""
		    Set BTHospDr=$lg(LocData,8)
			If (BTHospDr'="") {
				Set LocHospDr 	= BTHospDr
				Set HospCode	= $lg($g(^DHCHAI.BT.HospitalD(BTHospDr)),2)
				Set HospDesc	= $lg($g(^DHCHAI.BT.HospitalD(BTHospDr)),3)
			}
			
			Set IsOPER	    = $lg(LocData,9)
			Set IsOPER=$s(IsOPER=1:"是",IsOPER=0:"否",1:"是")
			Set IsICU	    = $lg(LocData,10)
			Set IsICU=$s(IsICU=1:"是",IsICU=0:"否",1:"是")
			Set IsNICU	    = $lg(LocData,11)
			Continue:IsNICU'=1		// 过滤掉非NICU的科室
			Set IsNICU=$s(IsNICU=1:"是",IsNICU=0:"否",1:"是")
		    Set ICUTpDr="",ICUTpCode="",ICUTpDesc=""
		    Set BTICUTpDr=$lg(LocData,12)
			If (BTICUTpDr'="") {
				Set ICUTpDr 	= BTICUTpDr
				Set ICUTpCode	= $lg($g(^DHCHAI.BT.DictionaryD(BTICUTpDr)),2)
				Set ICUTpDesc	= $lg($g(^DHCHAI.BT.DictionaryD(BTICUTpDr)),3)
			}
			Set XCode = $lg(LocData,13)
			Set IsActive	= $lg(LocData,14)
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActive=$s(IsActive=1:"是",IsActive=0:"否",1:"是")	
			Set ActDate     = $lg(LocData,15)
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime     = $lg(LocData,16)
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			
		    Set ActUserCode="",ActUserDesc=""
		    Set BTActUserDr=$lg(LocData,17)
			If (BTActUserDr'="") {
				Set ActUserCode	= $lg($g(^DHCHAI.BT.SysUserD(BTActUserDr)),2)
				Set ActUserDesc	= $lg($g(^DHCHAI.BT.SysUserD(BTActUserDr)),3)
			}
			Set ParLocDr=""
			Set BTParLocDr=$lg(LocData,18)
			If (BTParLocDr'="") {
				Set ParLocDr=BTParLocDr
			}
			Set IndNo = $lg(LocData,19)
			Set Data=$lb(xID,LocCode,LocDesc,LocDesc2,LocTypeDr,LocTypeCode,LocTypeDesc,LocCateDr,LocCateCode,LocCateDesc,GroupDr,GroupCode,GroupDesc,LocHospDr,HospCode,HospDesc,IsOPER,IsICU,IsNICU,ICUTpDr,ICUTpCode,ICUTpDesc,XCode,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc,ParLocDr,IndNo)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryNICULocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNICULocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryNICULocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNICULocExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenr
/// CreatDate：   2021-04-12
/// Description:  查询体重分组 报表使用 
/// Table：       DHCHAI.BT.InfPos
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.NICUPICCVAP","QryWTToSelect")
Query QryWTToSelect() As %Query(ROWSPEC = "WtCat:%String,WtCatDesc:%String") [ SqlProc ]
{
}

ClassMethod QryWTToSelectExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Kill ^TMP($zn,$j,"QryWTToSelect")
	
	For xWtCat = 1:1:5 {
		Set xWtCatDesc=$Case(xWtCat,1:"BW ≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW >2500g",5:"BW未填写")
		Set ^TMP($zn,$j,"QryWTToSelect",xWtCat,xWtCatDesc)=""
	}
	
	Set WtCat=""
	For{
		Set WtCat=$o(^TMP($zn,$j,"QryWTToSelect",WtCat))
		QUit:WtCat=""
		Set WtCatDesc = ""
		For {
			Set WtCatDesc = $o(^TMP($zn,$j,"QryWTToSelect",WtCat,WtCatDesc))
			Quit:WtCatDesc=""
			
			Set Data=$lb(WtCat,WtCatDesc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,"QryWTToSelect")
	Quit $$$OK
}

ClassMethod QryWTToSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWTToSelectExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWTToSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWTToSelectExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-08-10
/// Description:  获取NICU科室类型
/// Table：       DHCHAI.BT.Location
/// w ##Class(DHCHAI.STATV2.NICUPICCVAP).GetNICULocType("1|3")
ClassMethod GetNICULocType(aHospIDs As %String) As %String
{
	New (aHospIDs)
	Set return=""
	Quit:(aHospIDs="") return
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	Set TypeList=""
	Set xLocID=0
	For {
		Set xLocID = $o(^DHCHAI.BT.LocationD(xLocID))
		Quit:xLocID=""
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set LocDesc=$lg(LocData,3)
		Set IsNICU=$lg(LocData,11)
		Continue:IsNICU'=1
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set CateDr=$lg(LocData,6)
		Continue:CateDr=""
		Set CateDic=$g(^DHCHAI.BT.DictionaryD(CateDr))
		Set CateCode=$lg(CateDic,2)
		Continue:CateCode'="I"
		Set TypeDr=$lg(LocData,5)
		Continue:TypeDr=""
		Set TypeDic=$g(^DHCHAI.BT.DictionaryD(TypeDr))
		Set TypeCode=$lg(TypeDic,2)
        If (TypeList'[TypeCode) {
	        Set TypeList=TypeList_","_TypeCode
        }
	}
	Set:TypeList'="" TypeList=$e(TypeList,2,$l(TypeList))
	Set return=TypeList
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-06-15
/// Description:  查询新入患者明细
/// Table：       DHCHAI.IR.ICULogDtl
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aLocDr ：  科室
/// 			  aWtCat :   体重分组
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.NICUPICCVAP","QryNewInPatDtl","2021-03-01","2021-07-31","54","4")
Query QryNewInPatDtl(aDateFrom As %String, aDateTo As %String, aLocDr As %String, aWtCat As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,InDate:%String,WtCat:%String") [ SqlProc ]
{
}

ClassMethod QryNewInPatDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocDr As %String, aWtCat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="")||(aLocDr="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK

    Set NIndex="QryNewInPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	Set LocData=$g(^DHCHAI.BT.LocationD(aLocDr))
	Quit:LocData="" $$$OK
	Set LocDesc	= $li(LocData,3)
	Set IsNICU=$lg(LocData,11)
	Quit:IsNICU'=1 $$$OK

	For xDate=aDateFrom:1:aDateTo {
		Set xAdmID=""
		For {
			Set xAdmID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocDr,xDate,xAdmID))
			Quit:xAdmID=""
	
			Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocDr,xDate,xAdmID,""))
			Continue:xDtlID=""
			Set DtlData=$g(^DHCHAI.IR.ICULogDtlD(xDtlID))
			Continue:DtlData=""
			Set ILEpisodeDr=$lg(DtlData,2)
			Continue:ILEpisodeDr=""
			Set Status=$lg(DtlData,9)  //患者在科状态（入科人数=新入人数+当天入当天出）
			Continue:(Status'="I")&&(Status'="A2")
			
			Set IsNewBaby=$lg($g(^DHCHAI.DP.PAAdmD(ILEpisodeDr)),32)
			Set WtCat=5			
			Set Weigth=$lg($g(^DHCHAI.DP.PAAdmD(ILEpisodeDr)),34)
			Set Weigth=+Weigth
			Set:(Weigth<=1000)&&(Weigth>0) WtCat=1
			Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
			Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
			Set:(Weigth>2500) WtCat=4
			Continue:(aWtCat'="")&&(aWtCat'=WtCat)
			
			Set WtCatDesc=$Case(WtCat,1:"BW≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW>2500g",5:"BW未填写")

			//患者基本信息
			Set PatData =..BuildPaadmData(xAdmID)
			Continue:PatData=""
			Set AdmData=$g(^DHCHAI.DP.PAAdmD(xAdmID))
    	    Set AdmTimes = $lg(AdmData,38)   //患者就诊次数 
		    
			Set ^CacheTemp(repid,ind)=$lb(LocDesc,AdmTimes)_PatData_$lb($zd(xDate,3),WtCatDesc)
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryNewInPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNewInPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNewInPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNewInPatDtlExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2022-02-11
/// Description:  查询感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aLocDr ：  科室
/// 			  aWtCat :   体重分组
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.NICUPICCVAP","QrInfPatDtl","2022-01-01","2022-02-11","8","5","W")
Query QrInfPatDtl(aDateFrom As %String, aDateTo As %String, aLocDr As %String, aWtCat As %String, aLocType As %String = "W") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,WtCatDesc:%String,TransID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String,DiagID:%String,InfPosDesc:%String,InfDate:%String,InfType:%String,EffectDesc:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QrInfPatDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocDr As %String, aWtCat As %String, aLocType As %String = "W") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="")||(aLocDr="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
  	Set:aLocType'="W" aLocType="E"
  	
  	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")

    Set NIndex="QrInfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	// Add by zhaoyj 2022-06-15 Global方式
	Set LocData=$g(^DHCHAI.BT.LocationD(aLocDr))
	Quit:LocData="" $$$OK
	Set IsNICU=$lg(LocData,11)
	Quit:IsNICU'=1 $$$OK
   
    //同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,aLocDr,"I")
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
		Set LocDesc	= $lg(LocData,3)
		Set HospDr	= $lg(LocData,8)

		Set PaadmData = $g(^DHCHAI.DP.PAAdmD(Paadm))
		Continue:PaadmData=""
		Set IsNewBaby=$li(PaadmData,32)
		Set Weigth=$li(PaadmData,34)
		Set Weigth=+Weigth
		Set WtCat=5  						//默认体重未分型
	
		If (Weigth<=1000)&&(Weigth>0) {
			Set WtCat=1	
		}
		ElseIf (Weigth>1000)&(Weigth<=1500) {
			Set WtCat=2
		}
		ElseIf (Weigth>1500)&(Weigth<=2500) {
			Set WtCat=3
		}
		ElseIf (Weigth>2500){
			Set WtCat=4
		}
		
		Continue:(aWtCat'="")&&(WtCat'=aWtCat)
		Set WtCatDesc=$Case(WtCat,1:"BW≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW>2500g",5:"BW未填写")
		Set AdmTimes = $lg(PaadmData,38)    //患者就诊次数
		Set PatData =..BuildPaadmData(Paadm)    //取病人基本信息
		Continue:PatData=""	
    	Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,WtCat,"ALL",aLocType)
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
			
			Set InfPosInfo =##class(DHCHAI.STATV2.ICUAdOfInfect).GetInfInfo(Paadm,DateFrom,DateTo,LocDr,WardDr)	
			Continue:InfPosInfo=""
		    Set (InfDatas,InfData)=""
			For InfNo=1:1:$l(InfPosInfo,"|") {
				Set InfPosMsg=$p(InfPosInfo,"|",InfNo)
				Continue:InfPosMsg=""
	
				Set DiagID     = $p(InfPosMsg,"^",1)	
				Set InfDate    = $p(InfPosMsg,"^",2)	
				Set InfPosDesc = $p(InfPosMsg,"^",3)	
				Set EffectDesc = $p(InfPosMsg,"^",4)
				Set InfXDate   = $p(InfPosMsg,"^",5)
			
				Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
				Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
				
				Set DiagData=$g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagData,18)
				If (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}Else{
			   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
				}
			    Set InfData=$lb(DiagID,InfPosDesc,InfDate,InfType,EffectDesc,InfXDate)
			    Set InfDatas=InfDatas_$lb(InfData)
			}
			Set Len=$ll(InfDatas)
	
			//转换转科日期格式
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	        Set:TransTime'="" TransTime=$zt(TransTime)
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	    	Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
			Set TransInfo=$lb(TransID,LocDesc,TransDateTime,OutLocDateTime)
			
			Set (TubeInfos,TubeInfo)=""
			Set TubeArr=##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,"ALL",0)
			For ArrInd=1:1:TubeArr.Count(){
				Set TubeInfo=TubeArr.GetAt(ArrInd)
				Set TubeInfos=TubeInfos_$lb(TubeInfo)
			}
			Set Len=$ll(InfDatas)
			Set:($ll(TubeInfos)>Len) Len=$ll(TubeInfos)
			
			For LenInd=1:1:Len {
				Set InfData=$lg(InfDatas,LenInd)
				Set:InfData="" InfData=$lb("","","","","","")
				Set TubeInfo=$lg(TubeInfos,LenInd)

				Set:TubeInfo="" TubeInfo=$lb("","","","","","","","","")
				Set Data = $lb(LocDesc,AdmTimes)_PatData_$lb(WtCatDesc)_TransInfo_$lb(Days)_TubeInfo_InfData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
				
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QrInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrInfPatDtlExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

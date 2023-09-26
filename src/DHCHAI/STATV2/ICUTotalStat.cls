/// 名称: DHCHAI.STATV2.ICUTotalStat
/// 描述: ICU三管汇总统计
/// 编写者：chenR
/// 编写日期: 2020-07-31
Class DHCHAI.STATV2.ICUTotalStat Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenR
/// CreatDate：   2020-07-31
/// Description:  ICU三管汇总统计
///  Input：	  aHospIDs：院区ID
///       		  aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aStatDimens:  展示维度    //add 20221018 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ICUTotalStat","QryTubeInfo","","2020-06-01","2020-06-30","W","1","","","PICC")
Query QryTubeInfo(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "E", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aTubeType As %String = "") As %Query(ROWSPEC = "ind:%String,xDimensKey:%String,DimensDesc:%String,InCount:%Integer,InDays:%Integer,VAPDays:%Integer,VAPRatio:%String,VAPCount:%Integer,VAPInfectPat:%Integer,VAPINFCount:%Integer,VAPINFRatio:%String,PICCDays:%Integer,PICCRatio:%String,PICCCount:%Integer,PICCInfectPat:%Integer,PICCINFCount:%Integer,PICCINFRatio:%String,UCDays:%Integer,UCRatio:%String,UCCount:%Integer,UCInfectPat:%Integer,UCINFCount:%Integer,UCINFRatio:%String,CVCDays:%Integer,CVCRatio:%String,CVCCount:%Integer,CRRTDays:%Integer,CRRTRatio:%String,CRRTCount:%Integer,PORTDays:%Integer,PORTRatio:%String,PORTCount:%Integer,PICCsDays:%Integer,PICCsRatio:%String,PICCsCount:%String") [ SqlProc ]
{
}

ClassMethod QryTubeInfoExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "E", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aTubeType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
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
	
	Set TubeTypeList=$lb("VAP","UC","PICC")   //插管类型
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit") //中心静脉置管是否需要拆分
    If (ICUPatLogSplit=1) {
	    Set TubeTypeList=$lb("VAP","UC","PICC","CVC","CRRT","PORT","PICCs")
    }
    Set ListLen=$ll(TubeTypeList)
    Quit:ListLen=0 $$$OK

	Set NIndex="QryTubeInfo"
	Kill ^TMP($zn,$j,NIndex)
	
	Set (InDaysSum,VAPDaysSum,VAPInfCntSum,UCDaysSum,UCInfCntSum,PICCDaysSum,PICCInfCntSum,CVCDaysSum,CRRTDaysSum,PORTDaysSum,PICCsDaysSum)=0
    //同期在科
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
			//计算插管人数+插管天数
			Set InDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransIDs)
			Set DaysInfo =..GetDaysInfo(LocID,Paadm,aDateFrom,aDateTo,"")
            Set VAPDays  = +$p(DaysInfo,"^",1)
			Set PICCDays = +$p(DaysInfo,"^",2)
			Set UCDays   = +$p(DaysInfo,"^",3)
			Set CVCDays  = +$p(DaysInfo,"^",4)
			Set CRRTDays = +$p(DaysInfo,"^",5)
			Set PORTDays = +$p(DaysInfo,"^",6)
			Set PICCsDays = +$p(DaysInfo,"^",7)
			Set arrTubeDays=$lb(VAPDays,UCDays,PICCDays,CVCDays,CRRTDays,PORTDays,PICCsDays)
			
	    	//计算插管人数+插管天数
			Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
			For indDimens=1:1:$l(StatDimensInfo,"^") {
				Set DimensKey=$p(StatDimensInfo,"^",indDimens)
				Continue:DimensKey=""
				
				// 全院住院患者
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
					//同期在科人数
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
				}
                //同期在科天数
				Set:InDays>0 ^TMP($zn,$j,NIndex,DimensKey,"InDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"InDays"))+InDays 
             	
             	If (LocCount>1) {
					// 合计住院患者
					If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
						//合计同期在科人数
						Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
						Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
					}
				}
				
				// 全院科室患者
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)) {
					Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)=""					
					For xType = 1:1:ListLen {
						Set TubeType=$lg(TubeTypeList,xType)	
						If ($lg(arrTubeDays,xType)>0){
							If ('$d(^TMP($zn,$j,NIndex,DimensKey,"TubePat",Paadm,TubeType))) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"TubePat",Paadm,TubeType)=""												
								Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"TubeCount",TubeType))  //插管人数
							}
							Set ^TMP($zn,$j,NIndex,DimensKey,"TubeDays",TubeType)=$g(^TMP($zn,$j,NIndex,DimensKey,"TubeDays",TubeType))+$lg(arrTubeDays,xType)
						    
						    If $d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)) {
								    If ('$d(^TMP($zn,$j,NIndex,"Sum","TubePat",Paadm,TubeType))) {
									Set ^TMP($zn,$j,NIndex,"Sum","TubePat",Paadm,TubeType)=""												
									Set Num=$i(^TMP($zn,$j,NIndex,"Sum","TubeCount",TubeType))
								}
						    }
						}
						
						// 科室患者插管感染(不判断是否插管患者)
						Continue:((",VAP,UC,PICC,")'[(","_TubeType_","))   //其他类型无需判断
						Set InfPosInfo=##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,TubeType,aDateFrom,aDateTo,LocDr,WardDr)
						If (InfPosInfo'="") {
							If ('$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm,TubeType))) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm,TubeType)=""												
								Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat",TubeType))   //感染人数
							}
							Set InfCount=$Length(InfPosInfo,"|")
							Set ^TMP($zn,$j,NIndex,DimensKey,"InfCount",TubeType)=$g(^TMP($zn,$j,NIndex,DimensKey,"InfCount",TubeType))+InfCount
							
							If $d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)) {
								If ('$d(^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm,TubeType))) {
									Set ^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm,TubeType)=""												
									Set Num=$i(^TMP($zn,$j,NIndex,"Sum","InfPat",TubeType))
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
		Continue:xDimensKey=""
		Set InCount  	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			// 住院人数
		Set InDays		 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InDays"))				// 住院天数
		Set VAPCount	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","VAP"))		// 呼吸机插管人数
		Set VAPDays		 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","VAP"))		// 呼吸机插管天数
		Set VAPInfectPat =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat","VAP"))		// 呼吸机感染人数
		Set VAPINFCount	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCount","VAP"))		// 呼吸机感染例次数
		Set PICCCount	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","PICC")) 	// 血管导管插管人数
		Set PICCDays	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","PICC"))		// 血管导管插管天数
		Set PICCInfectPat=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat","PICC"))		// 血管导管感染人数
		Set PICCINFCount =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCount","PICC"))		// 血管导管感染例次数
		Set UCCount		 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","UC"))		// 导尿管插管人数
		Set UCDays		 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","UC"))		// 导尿管插管天数
		Set UCInfectPat	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat","UC"))			// 导尿管感染人数
		Set UCINFCount   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCount","UC"))		// 导尿管感染例次数
		
		Set CVCCount	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","CVC"))		// 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管人数
		Set CVCDays	     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","CVC"))		// 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管天数
		Set CRRTCount	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","CRRT"))	// 中央血管导管(CRRT)插管人数
		Set CRRTDays	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","CRRT"))		// 中央血管导管(CRRT)插管天数
		Set PORTCount	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","PORT"))	// 中央血管导管(PORT)插管人数
		Set PORTDays	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","PORT"))		// 中央血管导管(PORT)插管天数
		Set PICCsCount	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount","PICCs"))	// 总中央血管导管插管人数
		Set PICCsDays	 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays","PICCs"))	// 总中央血管导管插管天数
		
		Continue:(IsActive="0")&&(InCount=0)	
		Continue:(aQryCon="2")&&(VAPDays=0)&&(PICCDays=0)&&(UCDays=0)&&(CVCDays=0)&&(CRRTDays=0)&&(PORTDays=0)&&(VAPINFCount=0)&&(PICCINFCount=0)&&(UCINFCount=0)
		Continue:(aQryCon="2")&&(aTubeType'="")&&(+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount",aTubeType))=0)&&(+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCount",aTubeType))=0)

		Continue:(aQryCon="3")&&(InDays=0)
		
		Set VAPRatio="0.00%",VAPINFRatio="0.000‰",PICCRatio="0.00%",PICCINFRatio="0.000‰",UCRatio="0.00%",UCINFRatio="0.000‰"
		Set CVCRatio="0.00%",CRRTRatio="0.00%",PORTRatio="0.00%",PICCsRatio="0.00%"
		
		Set:InDays>0 VAPRatio=$fn((VAPDays/InDays)*100,"",2)_"%"
		Set:VAPDays>0 VAPINFRatio=$fn((VAPINFCount/VAPDays)*1000,"",3)_"‰"
		Set:InDays>0 PICCRatio=$fn((PICCDays/InDays)*100,"",2)_"%"
		Set:PICCDays>0 PICCINFRatio=$fn((PICCINFCount/PICCDays)*1000,"",3)_"‰"
		Set:InDays>0 UCRatio=$fn((UCDays/InDays)*100,"",2)_"%"
		Set:UCDays>0 UCINFRatio=$fn((UCINFCount/UCDays)*1000,"",3)_"‰"
		
		Set:InDays>0 CVCRatio=$fn((CVCDays/InDays)*100,"",2)_"%"
		Set:InDays>0 CRRTRatio=$fn((CRRTDays/InDays)*100,"",2)_"%"
		Set:InDays>0 PORTRatio=$fn((PORTDays/InDays)*100,"",2)_"%"
		Set:InDays>0 PICCsRatio=$fn((PICCsDays/InDays)*100,"",2)_"%"
		
		If (LocCount>1) {  //科室合计
		
			Set InDaysSum=InDaysSum+InDays
			Set VAPDaysSum=VAPDaysSum+VAPDays
			Set VAPInfCntSum=VAPInfCntSum+VAPINFCount
			Set UCDaysSum=UCDaysSum+UCDays
			Set UCInfCntSum=UCInfCntSum+UCINFCount
			Set PICCDaysSum=PICCDaysSum+PICCDays
			Set PICCInfCntSum=PICCInfCntSum+PICCINFCount
			Set CVCDaysSum=CVCDaysSum+CVCDays
			Set CRRTDaysSum=CRRTDaysSum+CRRTDays
			Set PORTDaysSum=PORTDaysSum+PORTDays
			Set PICCsDaysSum=PICCsDaysSum+PICCsDays
		}

		Set Data=$lb(ind,xDimensKey,DimensDesc,InCount,InDays,VAPDays,VAPRatio,VAPCount,VAPInfectPat,VAPINFCount,VAPINFRatio,PICCDays,PICCRatio,PICCCount,PICCInfectPat,PICCINFCount,PICCINFRatio,UCDays,UCRatio,UCCount,UCInfectPat,UCINFCount,UCINFRatio)
		Set Data=Data_$lb(CVCDays,CVCRatio,CVCCount,CRRTDays,CRRTRatio,CRRTCount,PORTDays,PORTRatio,PORTCount,PICCsDays,PICCsRatio,PICCsCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If (LocCount>1) {
		Set InCount  	 =+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			    // 住院人数
		Set InDays		 =InDaysSum				                                // 住院天数
		Set VAPCount	 =+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount","VAP"))		// 呼吸机插管人数
		Set VAPDays		 =VAPDaysSum		                                    // 呼吸机插管天数
        Set VAPInfectPat =+$g(^TMP($zn,$j,NIndex,"Sum","InfPat","VAP"))		    // 呼吸机感染人数
        Set VAPINFCount	 =VAPInfCntSum		                                    // 呼吸机感染例次数
        Set PICCCount	 =+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount","PICC")) 	// 血管导管插管人数
        Set PICCDays	 =PICCDaysSum		                                    // 血管导管插管天数
        Set PICCInfectPat=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat","PICC"))		// 血管导管感染人数
        Set PICCINFCount =PICCInfCntSum		                                    // 血管导管感染例次数
        Set UCCount		 =+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount","UC"))		// 导尿管插管人数
        Set UCDays		 =UCDaysSum		                                        // 导尿管管插管天数
        Set UCInfectPat	 =+$g(^TMP($zn,$j,NIndex,"Sum","InfPat","UC"))		    // 导尿管管感染人数
        Set UCINFCount   =UCInfCntSum 	                                        // 导尿管管感染例次数
        
        Set CVCCount	 =+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount","CVC"))		// 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管人数
        Set CVCDays	     =CVCDaysSum		                                    // 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管天数
        Set CRRTCount	 =+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount","CRRT"))	    // 中央血管导管(CRRT)插管人数
        Set CRRTDays	 =CRRTDaysSum		                                    // 中央血管导管(CRRT)插管天数
        Set PORTCount	 =+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount","PORT"))	    // 中央血管导管(PORT)插管人数
        Set PORTDays	 =PORTDaysSum		                                    // 中央血管导管(PORT)插管天数
        Set PICCsCount	 =+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount","PICCs")) 	// 总血管导管插管人数
        Set PICCsDays	 =PICCsDaysSum		                                    // 血管导管插管天数

		Set VAPRatio="0.00%",VAPINFRatio= "0.000‰"
		Set PICCRatio="0.00%",PICCINFRatio= "0.000‰"
		Set UCRatio="0.00%",UCINFRatio= "0.000‰"
		Set CVCRatio="0.00%",CRRTRatio="0.00%",PORTRatio="0.00%",PICCsRatio="0.00%"
		
		Set:InDays>0 VAPRatio=$fn((VAPDays/InDays)*100,"",2)_"%"
		Set:VAPDays>0 VAPINFRatio=$fn((VAPINFCount/VAPDays)*1000,"",3)_"‰"	
		Set:InDays>0 PICCRatio=$fn((PICCDays/InDays)*100,"",2)_"%"
		Set:PICCDays>0 PICCINFRatio=$fn((PICCINFCount/PICCDays)*1000,"",3)_"‰"	
		Set:InDays>0 UCRatio=$fn((UCDays/InDays)*100,"",2)_"%"
		Set:UCDays>0 UCINFRatio=$fn((UCINFCount/UCDays)*1000,"",3)_"‰"	
		
		Set:InDays>0 CVCRatio=$fn((CVCDays/InDays)*100,"",2)_"%"
		Set:InDays>0 CRRTRatio=$fn((CRRTDays/InDays)*100,"",2)_"%"
		Set:InDays>0 PORTRatio=$fn((PORTDays/InDays)*100,"",2)_"%"
		Set:InDays>0 PICCsRatio=$fn((PICCsDays/InDays)*100,"",2)_"%"
		
		Set Data=$lb(ind,"","全部",InCount,InDays,VAPDays,VAPRatio,VAPCount,VAPInfectPat,VAPINFCount,VAPINFRatio,PICCDays,PICCRatio,PICCCount,PICCInfectPat,PICCINFCount,PICCINFRatio,UCDays,UCRatio,UCCount,UCInfectPat,UCINFCount,UCINFRatio)
		Set Data=Data_$lb(CVCDays,CVCRatio,CVCCount,CRRTDays,CRRTRatio,CRRTCount,PORTDays,PORTRatio,PORTCount,PICCsDays,PICCsRatio,PICCsCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTubeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeInfoExecute ]
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
/// CreatDate：   2022-10-25
/// Description:  取患者各类型插管天数
/// Table：       
/// Input：       aLocID:科室ID,aEpisodeID:患者ID,aDateFrom:开始日期,aDateTo"结束日期,aWtCat:体重分类(0:成人,1/2/3/4新生儿体重分类)
/// Return：      返回 Count
/// w ##class(DHCHAI.STATV2.ICUTotalStat).GetDaysInfo("",2333,$zdh("2020-05-01",3),$zdh("2020-05-31",3),"")
ClassMethod GetDaysInfo(aLocID As %String, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aWtCat As %String = "")
{
	New (aLocID,aEpisodeID,aDateFrom,aDateTo,aWtCat)
	Set return=""
	Quit:(aLocID="")||(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set NIndex="GetDaysInfo"
	Kill ^TMP($zn,$j,NIndex)
	
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	//过滤体重分类
	Set WtCat=0
	Set IsNewBaby=$lg(PAAdmData,32)
	If IsNewBaby=1 {
		Set Weigth=+$lg(PAAdmData,34)
		Set:(Weigth<=1000)&&(Weigth>0) WtCat=1
		Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
		Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
		Set:(Weigth>2500) WtCat=4
	}
	Quit:(aWtCat'="")&&(aWtCat'=WtCat) return	

	//记录插管天数
	For xDate=aDateFrom:1:aDateTo {
		Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocID,xDate,aEpisodeID,""))
		Continue:xDtlID=""
		
		Set DtlData=$g(^DHCHAI.IR.ICULogDtlD(xDtlID))
		Continue:DtlData=""
		
		Set IsVAP  =$lg(DtlData,5)
		Set IsPICC =$lg(DtlData,6)
		Set IsUC   =$lg(DtlData,7)
		Set IsCVC  =$lg(DtlData,10)
		Set IsCRRT =$lg(DtlData,11)
		Set IsPORT =$lg(DtlData,12)
		Set Status =$lg(DtlData,9)
		
		//使用呼吸机天数
		If (IsVAP=1){
			Set Num=$i(^TMP($zn,$j,NIndex,"VAPDays"))
		}
		//使用脐/中心静脉置管天数
		If (IsPICC=1){
			Set Num=$i(^TMP($zn,$j,NIndex,"PICCDays"))
		}
		//泌尿道插管天数
		If (IsUC=1){
			Set Num=$i(^TMP($zn,$j,NIndex,"UCDays"))
		}
		//非血透静脉置管天数
		If (IsCVC=1){
			Set Num=$i(^TMP($zn,$j,NIndex,"CVCDays"))
		}
		//血透静脉置管天数
		If (IsCRRT=1){
			Set Num=$i(^TMP($zn,$j,NIndex,"CRRTDays"))
		}
		//输液港静脉置管天数
		If (IsPORT=1){
			Set Num=$i(^TMP($zn,$j,NIndex,"PORTDays"))
		}
		If (IsPICC=1)||(IsCVC=1)||(IsCRRT=1)||(IsPORT=1) {
			Set Num=$i(^TMP($zn,$j,NIndex,"PICCsDays"))
		}
	}
	
	Set VAPDays	 =+$g(^TMP($zn,$j,NIndex,"VAPDays"))		// 呼吸机插管天数
	Set PICCDays =+$g(^TMP($zn,$j,NIndex,"PICCDays"))		// 血管导管插管天数
	Set UCDays	 =+$g(^TMP($zn,$j,NIndex,"UCDays"))		    // 泌尿道插管天数
	Set CVCDays	 =+$g(^TMP($zn,$j,NIndex,"CVCDays"))		// 中心静脉置管天数
	Set CRRTDays =+$g(^TMP($zn,$j,NIndex,"CRRTDays"))		//血透静脉置管天数
	Set PORTDays =+$g(^TMP($zn,$j,NIndex,"PORTDays"))		//输液港静脉置管天数
	Set PICCsDays =+$g(^TMP($zn,$j,NIndex,"PICCsDays"))		//中心静脉置管天数	
	
	Set return=VAPDays_"^"_PICCDays_"^"_UCDays_"^"_CVCDays_"^"_CRRTDays_"^"_PORTDays_"^"_PICCsDays
	
	Kill ^TMP($zn,$j,NIndex)
	Quit return
}

}

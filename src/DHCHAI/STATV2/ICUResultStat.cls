/// 名称: DHCHAI.STATV2.ICUResultStat
/// 描述: ICU三管信息统计表
/// 编写者：zhugz
/// 编写日期: 2019-12-12
Class DHCHAI.STATV2.ICUResultStat Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2023-05-16
/// Description:  ICU科室三管汇总统计（只统计ICU科室）
///  Input：	  aHospIDs：院区ID
///       		  aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ICUResultStat","QryTubeInfo","","2020-06-01","2020-06-30","W","1","","PICC")
Query QryTubeInfo(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "", aTubeType As %String = "") As %Query(ROWSPEC = "ind:%String,DimensKey:%String,DimensDesc:%String,InCount:%Integer,InDays:%Integer,VAPDays:%Integer,VAPRatio:%String,VAPCount:%Integer,VAPInfectPat:%Integer,VAPINFCount:%Integer,VAPINFRatio:%String,PICCDays:%Integer,PICCRatio:%String,PICCCount:%Integer,PICCInfectPat:%Integer,PICCINFCount:%Integer,PICCINFRatio:%String,UCDays:%Integer,UCRatio:%String,UCCount:%Integer,UCInfectPat:%Integer,UCINFCount:%Integer,UCINFRatio:%String,CVCDays:%Integer,CVCRatio:%String,CVCCount:%Integer,CRRTDays:%Integer,CRRTRatio:%String,CRRTCount:%Integer,PORTDays:%Integer,PORTRatio:%String,PORTCount:%Integer,PICCsDays:%Integer,PICCsRatio:%String,PICCsCount:%String") [ SqlProc ]
{
}

ClassMethod QryTubeInfoExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "", aTubeType As %String = "") As %Status
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
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set LocDesc=$lg(LocData,3)
		Set LocDesc2=$lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set IsICU =$lg(LocData,10)   //是否ICU科室，直接用索引“IndexIsICULoc”更为方便，但维护需对应
		/*
		If (IsICU'=1) { 		
			Set LocIDList = ##class(DHCHAI.BT.LocationLink).GetLocLinks(xLocID) // 获取科室D对应的病区
			For indL=1:1:$l(LocIDList,"|") {
				Set LocID =$p(LocIDList,"|",indL)
				Quit:LocID=""
				Set LocInfo= $g(^DHCHAI.BT.LocationD(LocID))
				Continue:LocInfo=""
				Set IsICU=$lg(LocInfo,10)
				Continue:(IsICU'=1)
				Quit
			}
		}
		*/
		Continue:IsICU'=1
		
	    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I","","",1)  //启用虚拟病区统计标识
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
			Set InDays=##class(DHCHAI.STATV2.ICUTotalStat).GetInDays(Paadm,aDateFrom,aDateTo,TransIDs)
			Set DaysInfo =##class(DHCHAI.STATV2.ICUTotalStat).GetDaysInfo(LocID,Paadm,aDateFrom,aDateTo,"")
            Set VAPDays  = +$p(DaysInfo,"^",1)
			Set PICCDays = +$p(DaysInfo,"^",2)
			Set UCDays   = +$p(DaysInfo,"^",3)
			Set CVCDays  = +$p(DaysInfo,"^",4)
			Set CRRTDays = +$p(DaysInfo,"^",5)
			Set PORTDays = +$p(DaysInfo,"^",6)
			Set PICCsDays = +$p(DaysInfo,"^",7)
			Set arrTubeDays=$lb(VAPDays,UCDays,PICCDays,CVCDays,CRRTDays,PORTDays,PICCsDays)
			
			// 住院患者
			If '$d(^TMP($zn,$j,NIndex,LocID,"PatAdm",Paadm)){
				//同期在科人数
				Set num=$i(^TMP($zn,$j,NIndex,LocID,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,LocID,"PatAdm",Paadm)=""
			}
	        //同期在科天数
			Set:InDays>0 ^TMP($zn,$j,NIndex,LocID,"InDays") = +$g(^TMP($zn,$j,NIndex,LocID,"InDays"))+InDays 
	     
			// 合计住院患者
			If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
				//合计同期在科人数
				Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
				Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
			}
		
			// 科室患者
			If '$d(^TMP($zn,$j,NIndex,"PatLocAdm",LocID,Paadm)) {
				Set ^TMP($zn,$j,NIndex,"PatLocAdm",LocID,Paadm)=""					
				For xType = 1:1:ListLen {
					Set TubeType=$lg(TubeTypeList,xType)	
					If ($lg(arrTubeDays,xType)>0){
						If ('$d(^TMP($zn,$j,NIndex,LocID,"TubePat",Paadm,TubeType))) {
							Set ^TMP($zn,$j,NIndex,LocID,"TubePat",Paadm,TubeType)=""												
							Set Num=$i(^TMP($zn,$j,NIndex,LocID,"TubeCount",TubeType))  //插管人数
						}
						Set ^TMP($zn,$j,NIndex,LocID,"TubeDays",TubeType)=$g(^TMP($zn,$j,NIndex,LocID,"TubeDays",TubeType))+$lg(arrTubeDays,xType)
					    
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
						If ('$d(^TMP($zn,$j,NIndex,LocID,"InfPat",Paadm,TubeType))) {
							Set ^TMP($zn,$j,NIndex,LocID,"InfPat",Paadm,TubeType)=""												
							Set Num=$i(^TMP($zn,$j,NIndex,LocID,"InfPat",TubeType))   //感染人数
						}
						Set InfCount=$Length(InfPosInfo,"|")
						Set ^TMP($zn,$j,NIndex,LocID,"InfCount",TubeType)=$g(^TMP($zn,$j,NIndex,LocID,"InfCount",TubeType))+InfCount
						
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
	
		Set InCount  	 =+$g(^TMP($zn,$j,NIndex,xLocID,"PatAdm"))  			// 住院人数
		Set InDays		 =+$g(^TMP($zn,$j,NIndex,xLocID,"InDays"))				// 住院天数
		Set VAPCount	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount","VAP"))		// 呼吸机插管人数
		Set VAPDays		 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeDays","VAP"))		// 呼吸机插管天数
		Set VAPInfectPat =+$g(^TMP($zn,$j,NIndex,xLocID,"InfPat","VAP"))		// 呼吸机感染人数
		Set VAPINFCount	 =+$g(^TMP($zn,$j,NIndex,xLocID,"InfCount","VAP"))		// 呼吸机感染例次数
		Set PICCCount	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount","PICC")) 	// 血管导管插管人数
		Set PICCDays	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeDays","PICC"))		// 血管导管插管天数
		Set PICCInfectPat=+$g(^TMP($zn,$j,NIndex,xLocID,"InfPat","PICC"))		// 血管导管感染人数
		Set PICCINFCount =+$g(^TMP($zn,$j,NIndex,xLocID,"InfCount","PICC"))		// 血管导管感染例次数
		Set UCCount		 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount","UC"))		// 导尿管插管人数
		Set UCDays		 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeDays","UC"))		// 导尿管插管天数
		Set UCInfectPat	 =+$g(^TMP($zn,$j,NIndex,xLocID,"InfPat","UC"))			// 导尿管感染人数
		Set UCINFCount   =+$g(^TMP($zn,$j,NIndex,xLocID,"InfCount","UC"))		// 导尿管感染例次数
		
		Set CVCCount	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount","CVC"))		// 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管人数
		Set CVCDays	     =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeDays","CVC"))		// 中央血管导管(颈内CVC/锁骨下CVC/股静脉CVC)插管天数
		Set CRRTCount	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount","CRRT"))	// 中央血管导管(CRRT)插管人数
		Set CRRTDays	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeDays","CRRT"))		// 中央血管导管(CRRT)插管天数
		Set PORTCount	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount","PORT"))	// 中央血管导管(PORT)插管人数
		Set PORTDays	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeDays","PORT"))		// 中央血管导管(PORT)插管天数
		Set PICCsCount	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount","PICCs"))	// 总中央血管导管插管人数
		Set PICCsDays	 =+$g(^TMP($zn,$j,NIndex,xLocID,"TubeDays","PICCs"))	// 总中央血管导管插管天数
		
		Continue:(aQryCon="2")&&(VAPDays=0)&&(PICCDays=0)&&(UCDays=0)&&(CVCDays=0)&&(CRRTDays=0)&&(PORTDays=0)&&(VAPINFCount=0)&&(PICCINFCount=0)&&(UCINFCount=0)
		Continue:(aQryCon="2")&&(aTubeType'="")&&(+$g(^TMP($zn,$j,NIndex,xLocID,"TubeCount",aTubeType))=0)&&(+$g(^TMP($zn,$j,NIndex,xLocID,"InfCount",aTubeType))=0)
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
		Set Data=$lb(ind,xLocID,LocDesc,InCount,InDays,VAPDays,VAPRatio,VAPCount,VAPInfectPat,VAPINFCount,VAPINFRatio,PICCDays,PICCRatio,PICCCount,PICCInfectPat,PICCINFCount,PICCINFRatio,UCDays,UCRatio,UCCount,UCInfectPat,UCINFCount,UCINFRatio)
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
/// CreatDate：   2023-05-16
/// Description:  三管统计住院患者明细
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aTubeType :  三管类型
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ICUResultStat","QryTubePatDtl","1|2","2020-05-01","2020-05-31","43","W","PICC")
Query QryTubePatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aTubeType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer") [ SqlProc ]
{
}

ClassMethod QryTubePatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aTubeType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	//处理日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aStaType'="W" aStaType="E"
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")		
    Set NIndex="QryTubePatDtl"
	Kill ^TMP($zn,$j,NIndex)
    		
	//同期在科
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aStaType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aDimensKey'="")&(aDimensKey'=xLocID)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
				
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set LocDesc=$lg(LocData,3)
		Set LocDesc2=$lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set IsICU =$lg(LocData,10)   //是否ICU科室，直接用索引“IndexIsICULoc”更为方便，但维护需对应
		Continue:IsICU'=1
		
        //取统计维度
		Set DimensDesc=LocDesc  //科室、病区名称
		Set:aDimensKey="" DimensDesc="全部"

		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aStaType,xLocID,"I","","",1)  //启用虚拟病区统计标识
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
            //插管过滤
			Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aStaType)

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
									
				Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,LocID,LocDesc,TransDateTime,OutLocDateTime,Days)	
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
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

/// Creator：     pylian
/// CreatDate：   2023-05-16
/// Description:  发生三管感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aTubeType :  三管类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ICUResultStat","QryTubeInfDtl","1|2","2022-05-01","2022-10-31","0000-00-0000-A-1","W","UC","")
Query QryTubeInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aTubeType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String,DiagID:%String,InfPosDesc:%String,InfDate:%String,InfType:%String,EffectDesc:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryTubeInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aTubeType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	//处理日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aStaType'="W" aStaType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	
	
	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")

    Set NIndex="QryTubeInfDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	//同期在科
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aStaType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aDimensKey'="")&(aDimensKey'=xLocID)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
				
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set LocDesc=$lg(LocData,3)
		Set LocDesc2=$lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set IsICU =$lg(LocData,10)   //是否ICU科室，直接用索引“IndexIsICULoc”更为方便，但维护需对应
		Continue:IsICU'=1
		
        //取统计维度
		Set DimensDesc=LocDesc  //科室、病区名称
		Set:aDimensKey="" DimensDesc="全部"
		
		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aStaType,xLocID,"I","","",1)  //启用虚拟病区统计标识
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
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			
			Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
            Set AdmDate = $lg(AdmData,20)    //就诊日志 
            Set AdmTimes = $lg(AdmData,38)   //就诊次数
            //插管过滤  与汇总报表一致，不判断是否插管患者
			Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aStaType)		         	
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
		
              	Set (InfDatas,InfData,TubeInfos,TubeInfo)=""
	            Set TubeInfInfo =##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,aTubeType,DateFrom,DateTo,LocDr,WardDr)
	            Continue:TubeInfInfo=""		
				For InfNo=1:1:$L(TubeInfInfo,"|") {
					Set InfPosMsg=$p(TubeInfInfo,"|",InfNo)
					Continue:InfPosMsg=""
					Set InfDate	= $p(InfPosMsg,"^",1)
					Set DiagID= $p(InfPosMsg,"^",5)
					//记录感染信息,加入转科记录，防止转回原科室后，仍显示感染信息
					Continue:$d(^TMP($zn,$j,NIndex,"InfPat",LocID,Paadm,DiagID))   
					Set ^TMP($zn,$j,NIndex,"InfPat",LocID,Paadm,DiagID)=""
			
					Set DiagData=$g(^DHCHAI.IR.INFDiagnosD(DiagID))
				    Continue:DiagData=""
				    Set InfPosDr = $lg(DiagData,3)
				    Continue:InfPosDr=""
				    Set InfPosDic=$g(^DHCHAI.BT.InfPosD(InfPosDr))
					Set InfPosDesc=$lg(InfPosDic,3)
				    Set InfDate	= $lg(DiagData,5)
				    Set EffectDr = $lg(DiagData,8)
				    Set EffectDesc=""
				    If (EffectDr'="") {
				    	Set EffectDic=$g(^DHCHAI.BT.DictionaryD(EffectDr))
						Set EffectDesc=$lg(EffectDic,3)
					}
					Set InfXDate	= $lg(DiagData,7)
					Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
					Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
						
					Set InfType="医院感染"
					Set InfTypeCode=$lg(DiagData,18)
					if (InfTypeCode'=""){
						Set:InfTypeCode=0 InfType="社区感染"
					}else{
				   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
					}
				    Set InfData=$lb(DiagID,InfPosDesc,InfDate,InfType,EffectDesc,InfXDate)
				    Set InfDatas=InfDatas_$lb(InfData)
				}
				Continue:($ll(InfDatas)=0) 
				
				//转换转科日期格式
				Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
				Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		        Set:TransTime'="" TransTime=$zt(TransTime)
			    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    	Set TransDateTime =TransDate_" "_TransTime
				Set OutLocDateTime =OutLocDate_" "_OutLocTime
				Set TransInfo=$lb(TransID,LocID,LocDesc,TransDateTime,OutLocDateTime)
				
				Set TubeArr=##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,aTubeType,ICUPatLogSplit)
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
			
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(Days)_TubeInfo_InfData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
	    }
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTubeInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeInfDtlExecute ]
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
/// CreatDate：   2023-05-16
/// Description:  三管使用明细
/// Table：       DHCHAI.IR.ICULogDtl
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aTubeType :  三管类型
/// Return：      返回ROWSPEC			// 0001-07-0099-W-4,0000-00-0000-A-1
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ICUResultStat","QryTubeDayDtl","","2020-05-01","2020-05-31","0000-00-0000-A-1","W","PICCs")
Query QryTubeDayDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aTubeType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTubeDayDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aTubeType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="")||(aTubeType="") $$$OK

	//处理日期
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aStaType'="W" aStaType="E"
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	

	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")

    Set NIndex="QryTubeDayDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	//同期在科
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aStaType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aDimensKey'="")&(aDimensKey'=xLocID)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
				
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set LocDesc=$lg(LocData,3)
		Set LocDesc2=$lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set IsICU =$lg(LocData,10)   //是否ICU科室，直接用索引“IndexIsICULoc”更为方便，但维护需对应
		Continue:IsICU'=1
		
        //取统计维度
		Set DimensDesc=LocDesc  //科室、病区名称
		Set:aDimensKey="" DimensDesc="全部"
		
		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aStaType,xLocID,"I","","",1)  //启用虚拟病区统计标识
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
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			
			Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
            Set AdmTimes = $lg(AdmData,38)   //就诊次数
			Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aStaType)
			Continue:Days=0    
		  
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
				Set TransInfo=$lb(TransID,LocID,LocDesc,TransDateTime,OutLocDateTime)
				
				//取三管医嘱信息
				Set TubeArr=##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,aTubeType,ICUPatLogSplit)
				If (TubeArr.Count()>0) {
					For ArrInd=1:1:TubeArr.Count(){
						Set TubeInfo=TubeArr.GetAt(ArrInd)
					
					   	Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(Days)_TubeInfo
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}Else {   //有插管记录但无插管医嘱
					Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(Days,"","","","","","","","","")
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
	}
	Quit $$$OK
}

ClassMethod QryTubeDayDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeDayDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeDayDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeDayDtlExecute ]
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

/// 获取三管医嘱明细[查询范围内用药]
ClassMethod GetTubeOrderItemNew(aEpisodeID, aDatefrom, aDateTo, aTubeType) As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDatefrom,aDateTo,aTubeType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aDatefrom="") return
	Set xSCode= "",Count=0
	For {		
		Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode))  //子系统索引
		Quit:xSCode=""
		Set xOrdItemDesc = "" 
		For {
			Set xOrdItemDesc = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc))
			Quit:xOrdItemDesc=""
			Set xUpdateDate =""
			For {
			Set xUpdateDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc,xUpdateDate))
				Quit:xUpdateDate=""
				Set xOrdItemID ="" 
				For {
					Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc,xUpdateDate,xOrdItemID))
					Quit:xOrdItemID="" 
					Set OrdItemData = $g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
					Continue:OrdItemData=""
					Set IsActive=$lg(OrdItemData,25)
					Continue:IsActive'=1
					//取的临床医嘱名称
					Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xSCode,xOrdItemDesc,""))	
					Continue:xMastMapID=""
					Set MapData = $g(^DHCHAI.DP.OEItmMastMapD(xMastMapID))
					Continue:MapData=""
					Set BTMapItemDr=$lg(MapData,3)
					Continue:BTMapItemDr=""  //治疗医嘱项
					Set BTCatDr=$lg($g(^DHCHAI.DP.OEItmMastD(BTMapItemDr)),4)
					Continue:BTCatDr=""  //治疗医嘱分类
					
					Set BTCode = $lg($g(^DHCHAI.DP.OEItmCatD(BTCatDr)),2)
					Set BTSubCode=$p(BTCode,"-",3)
					Continue:(aTubeType'="")&&(BTSubCode'=aTubeType)
					//过滤掉非三管医嘱
					Continue:((",PICC,VAP,UC,")'[(","_BTSubCode_","))
					Set OeItemDesc=$lg(OrdItemData,4)
					Continue:($lg(OrdItemData,15)>aDateTo)		//日期之后开医嘱不显示
					
					Set OESttDate=$zd($lg(OrdItemData,15),3)
					Set OEXDate=""
					if ($lg(OrdItemData,17)'="")
					{
						Continue:$lg(OrdItemData,17)<aDatefrom  //日期之前已停用
						Set OEXDate=$zd($lg(OrdItemData,17),3)
					}
					Set OrderInfo=OeItemDesc_","_OESttDate_","_OEXDate
					Set Count=Count+1
					Do return.SetAt(OrderInfo,Count)
				}
			}
		}
	}
	Quit return
}

}

/// 名称: DHCHAI.IRS.IExAQrySrv
/// 描述: 三管感染核心防控措施执行率统计
/// 编写者：guojun
/// 编写日期: 2023-04-12
Class DHCHAI.IRS.IExAQrySrv Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     guojun
/// CreatDate：   2023-03-24
/// Description:  三管感染核心防控措施执行率统计表，以三管汇总统计表为基础进行扩展
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// 			  aICULocID:选择的病区和科室（没有选择为空）																																																																																																																																																							
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.IExAQrySrv","QryIExARepRatio","","2023-04-01","2023-04-30","W","1","","","")
Query QryIExARepRatio(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "E", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aTubeType As %String = "") As %Query(ROWSPEC = "ind:%String,xDimensKey:%String,DimensDesc:%String,InCount:%Integer,InDays:%Integer,VAPDays:%Integer,VAPRatio:%String,VAPCount:%Integer,VAPInfectPat:%Integer,VAPINFCount:%Integer,VAPINFRatio:%String,PICCDays:%Integer,PICCRatio:%String,PICCCount:%Integer,PICCInfectPat:%Integer,PICCINFCount:%Integer,PICCINFRatio:%String,UCDays:%Integer,UCRatio:%String,UCCount:%Integer,UCInfectPat:%Integer,UCINFCount:%Integer,UCINFRatio:%String,CVCDays:%Integer,CVCRatio:%String,CVCCount:%Integer,CRRTDays:%Integer,CRRTRatio:%String,CRRTCount:%Integer,PORTDays:%Integer,PORTRatio:%String,PORTCount:%Integer,PICCsDays:%Integer,PICCsRatio:%String,PICCsCount:%String,PICCReps:%String,PICCRepExes:%String,PICCRepNExes:%String,PICCRepRatio:%String,PICCRepExeDays:%String,PICCRepRealExeDays:%String,PICCRepRealExeDaysRatio:%String,VAPReps:%String,VAPRepExes:%String,VAPRepNExes:%String,VAPRepRatio:%String,VAPRepExeDays:%String,VAPRepRealExeDays:%String,VAPRepRealExeDaysRatio:%String,UCReps:%String,UCRepExes:%String,UCRepNExes:%String,UCRepRatio:%String,UCRepExeDays:%String,UCRepRealExeDays:%String,UCRepRealExeDaysRatio:%String ") [ SqlProc ]
{
}

ClassMethod QryIExARepRatioExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "E", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aTubeType As %String = "") As %Status
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
	set (TInCount,TInDays,TVAPDays,TVAPCount,TVAPINFCount,TPICCDays,TPICCCount,TPICCINFCount,TUCDays,TUCCount,TUCINFCount,TVAPInfectPat,TPICCInfectPat,TUCInfectPat,TPICCReps,TPICCRepExes,TPICCRepNExes,TPICCRepExeDays,TPICCRepRealExeDays,TVAPReps,TVAPRepExes,TVAPRepNExes,TVAPRepExeDays,TVAPRepRealExeDays,TUCReps,TUCRepExes,TUCRepNExes,TUCRepExeDays,TUCRepRealExeDays)=0
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
			Set DaysInfo = ##class(DHCHAI.STATV2.ICUTotalStat).GetDaysInfo(LocID,Paadm,aDateFrom,aDateTo,"")
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
						
						//督察表总数
					 	Set RepCount =  ##class(DHCHAI.IRS.IExAQrySrv).GetIExARepCountS(Paadm,TubeType)	
					 	If (RepCount'=0){ 				    
					   		If ('$d(^TMP($zn,$j,NIndex,DimensKey,"TubeRepCount",Paadm,TubeType))) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"TubeRepCount",Paadm,TubeType)=""
								Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"TubeRepCount",TubeType),RepCount)
							}
					 	}
																	
						//执行督查表数
					 	Set TubeRepExes = ##class(DHCHAI.IRS.IExAQrySrv).GetIExARepExes(Paadm,TubeType)	
					 	If (TubeRepExes'=0){ 				    
					   		If ('$d(^TMP($zn,$j,NIndex,DimensKey,"TubeRepExes",Paadm,TubeType))) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"TubeRepExes",Paadm,TubeType)=""
								Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"TubeRepExes",TubeType),TubeRepExes)
							}
					 	}
	
						//需执行总天数
					 	Set TubeRepExeDays = ##class(DHCHAI.IRS.IExAQrySrv).GetIExADays(Paadm,TubeType)
					 	If (TubeRepExeDays'=0){	    
					   		If ('$d(^TMP($zn,$j,NIndex,DimensKey,"TubeRepExeDays",Paadm,TubeType))) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"TubeRepExeDays",Paadm,TubeType)=""
								Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"TubeRepExeDays",TubeType),TubeRepExeDays)
							}
					 	}
					 
					 	//实际执行天数
					 	Set RepRealExeDays =  ##class(DHCHAI.IRS.IExAQrySrv).GetIExARepExeDays(Paadm,TubeType)	
					 	If (RepRealExeDays'=0){ 				    
					   		If ('$d(^TMP($zn,$j,NIndex,DimensKey,"RepRealExeDays",Paadm,TubeType))) {
								Set ^TMP($zn,$j,NIndex,DimensKey,"RepRealExeDays",Paadm,TubeType)=""
								Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"RepRealExeDays",TubeType),RepRealExeDays)
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
		
		
		//********************************************************************* ↓↓↓三管感染核心防控措施执行率统计相关
		Set PICCReps		  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepCount","PICC"))   	//PICC督察表总数
		Set PICCRepExes       = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepExes","PICC")) 		//PICC执行督察表数
		Set PICCRepNExes 	  = PICCReps - PICCRepExes 						 			        //PICC未执行督察表数
		Set PICCRepExeDays 	  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepExeDays","PICC"))	    //PICC需执行总天数
		Set PICCRepRealExeDays= +$g(^TMP($zn,$j,NIndex,xDimensKey,"RepRealExeDays","PICC")) 	//PICC实际执行天数

		Set VAPReps           = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepCount","VAP"))   		//VAP督察表总数
		Set VAPRepExes        = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepExes","VAP"))     	//VAP执行督察表数
		Set VAPRepNExes       = VAPReps - VAPRepExes 							  			    //VAP未执行督察表数
		Set VAPRepExeDays     = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepExeDays","VAP")) 		//VAP需执行总天数
		Set VAPRepRealExeDays = +$g(^TMP($zn,$j,NIndex,xDimensKey,"RepRealExeDays","VAP"))      //VAP实际执行天数
		
		Set UCReps			  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepCount","UC"))   		//UC督察表总数
		Set UCRepExes 		  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepExes","UC"))			//UC执行督察表数
		Set UCRepNExes 		  = UCReps - UCRepExes 		                          			    //UC未执行督察表数
		Set UCRepExeDays 	  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeRepExeDays","UC"))   	//UC需执行总天数
		Set UCRepRealExeDays  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"RepRealExeDays","UC"))       //UC实际执行天数
		//********************************************************************* ↑↑↑ 三管感染核心防控措施执行率统计表
		
		Continue:(IsActive="0")&&(InCount=0)	
		Continue:(aQryCon="2")&&(VAPDays=0)&&(PICCDays=0)&&(UCDays=0)&&(CVCDays=0)&&(CRRTDays=0)&&(PORTDays=0)&&(VAPINFCount=0)&&(PICCINFCount=0)&&(UCINFCount=0)
		Continue:(aQryCon="2")&&(aTubeType'="")&&(+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount",aTubeType))=0)&&(+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCount",aTubeType))=0)

		Continue:(aQryCon="3")&&(InDays=0)
		
		Set VAPRatio="0.00%",VAPINFRatio="0.000‰",PICCRatio="0.00%",PICCINFRatio="0.000‰",UCRatio="0.00%",UCINFRatio="0.000‰"
		Set CVCRatio="0.00%",CRRTRatio="0.00%",PORTRatio="0.00%",PICCsRatio="0.00%"
		Set PICCRepRatio="0.00%",PICCRepRealExeDaysRatio="0.00%",VAPRepRatio="0.00%",VAPRepRealExeDaysRatio="0.00%",UCRepRatio="0.00%",UCRepRealExeDaysRatio="0.00%"
		
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
		
		Set:PICCReps>0 PICCRepRatio=$fn((PICCRepExes/PICCReps)*100,"",2)_"%"  							     //PICC执行率
		Set:PICCRepExeDays>0 PICCRepRealExeDaysRatio=$fn((PICCRepRealExeDays/PICCRepExeDays)*100,"",2)_"%"   //PICC天数执行率
		Set:VAPReps>0 VAPRepRatio=$fn((VAPRepExes/VAPReps)*100,"",2)_"%"   									 //VAP执行率
		Set:VAPRepExeDays>0 VAPRepRealExeDaysRatio=$fn((VAPRepRealExeDays/VAPRepExeDays)*100,"",2)_"%"       //VAP天数执行率
		Set:UCReps>0 UCRepRatio=$fn((UCRepExes/UCReps)*100,"",2)_"%"                                         //UC执行率
		Set:UCRepExeDays>0 UCRepRealExeDaysRatio=$fn((UCRepRealExeDays/UCRepExeDays)*100,"",2)_"%"           //UC天数执行率
		
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
			
			Set TPICCReps= TPICCReps+PICCReps  	                                //PICC督察表总数
			Set TPICCRepExes = TPICCRepExes+PICCRepExes 						//PICC执行督察表数
			Set:TPICCReps>0 TPICCRepNExes = TPICCReps - TPICCRepExes 			//PICC未执行督察表数
			Set TPICCRepExeDays = TPICCRepExeDays+PICCRepExeDays  				//PICC需执行总天数
			Set TPICCRepRealExeDays = TPICCRepRealExeDays+PICCRepRealExeDays	//PICC实际执行天数
			Set TVAPReps= TVAPReps+VAPReps  		                            //VAP督察表总数
			Set TVAPRepExes = TVAPRepExes+VAPRepExes 		                    //VAP执行督察表数
			Set:TVAPReps>0 TVAPRepNExes = TVAPReps - TVAPRepExes 		        //VAP未执行督察表数
			Set TVAPRepExeDays = TVAPRepExeDays+VAPRepExeDays 			 		//VAP需执行总天数
			Set TVAPRepRealExeDays = TVAPRepRealExeDays+VAPRepRealExeDays       //VAP实际执行天数
			Set TUCReps= TUCReps +UCReps    		                            //UC督察表总数
			Set TUCRepExes = TUCRepExes+UCRepExes 		                        //UC执行督察表数
			Set:TUCReps>0 TUCRepNExes = TUCReps - TUCRepExes 		            //UC未执行督察表数
			Set TUCRepExeDays = TUCRepExeDays+UCRepExeDays   					//UC需执行总天数
			Set TUCRepRealExeDays = TUCRepRealExeDays+UCRepRealExeDays          //UC实际执行天数
			
		}
		Set PICCRep=$lb(PICCReps,PICCRepExes,PICCRepNExes,PICCRepRatio,PICCRepExeDays,PICCRepRealExeDays,PICCRepRealExeDaysRatio)
		Set VAPRep=$lb(VAPReps,VAPRepExes,VAPRepNExes,VAPRepRatio,VAPRepExeDays,VAPRepRealExeDays,VAPRepRealExeDaysRatio)
		Set UCRep=$lb(UCReps,UCRepExes,UCRepNExes,UCRepRatio,UCRepExeDays,UCRepRealExeDays,UCRepRealExeDaysRatio )
		Set Data=$lb(ind,xDimensKey,DimensDesc,InCount,InDays,VAPDays,VAPRatio,VAPCount,VAPInfectPat,VAPINFCount,VAPINFRatio,PICCDays,PICCRatio,PICCCount,PICCInfectPat,PICCINFCount,PICCINFRatio,UCDays,UCRatio,UCCount,UCInfectPat,UCINFCount,UCINFRatio)
		Set Data=Data_$lb(CVCDays,CVCRatio,CVCCount,CRRTDays,CRRTRatio,CRRTCount,PORTDays,PORTRatio,PORTCount,PICCsDays,PICCsRatio,PICCsCount)_PICCRep_VAPRep_UCRep
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

		Set PICCReps= TPICCReps   	 							//PICC督察表总数
		Set PICCRepExes = TPICCRepExes 							//PICC执行督察表数
		Set PICCRepNExes = TPICCReps - TPICCRepExes 			//PICC未执行督察表数
		Set PICCRepExeDays = TPICCRepExeDays	 				//PICC需执行总天数
		Set PICCRepRealExeDays = TPICCRepRealExeDays			//PICC实际执行天数
		Set VAPReps= TVAPReps   		                        //VAP督察表总数
		Set VAPRepExes = TVAPRepExes 		                    //VAP执行督察表数
		Set VAPRepNExes = TVAPReps - TVAPRepExes 				//VAP未执行督察表数
		Set VAPRepExeDays = TVAPRepExeDays 			 			//VAP需执行总天数
		Set VAPRepRealExeDays = TVAPRepRealExeDays              //VAP实际执行天数
		Set UCReps= TUCReps   		  							//UC督察表总数
		Set UCRepExes = TUCRepExes 		                        //UC执行督察表数
		Set UCRepNExes = TUCReps - TUCRepExes 		    		//UC未执行督察表数
		Set UCRepExeDays = TUCRepExeDays   						//UC需执行总天数
		Set UCRepRealExeDays = TUCRepRealExeDays                //UC实际执行天数
		

		Set VAPRatio="0.00%",VAPINFRatio= "0.000‰"
		Set PICCRatio="0.00%",PICCINFRatio= "0.000‰"
		Set UCRatio="0.00%",UCINFRatio= "0.000‰"
		Set CVCRatio="0.00%",CRRTRatio="0.00%",PORTRatio="0.00%",PICCsRatio="0.00%"
		
		Set PICCRepRatio="0.00%",PICCRepRealExeDaysRatio="0.00%",VAPRepRatio="0.00%",VAPRepRealExeDaysRatio="0.00%",UCRepRatio="0.00%",UCRepRealExeDaysRatio="0.00%"
		
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
		
		Set:PICCReps>0 PICCRepRatio=$fn((PICCRepExes/PICCReps)*100,"",2)_"%"  							     //PICC执行率
		Set:PICCRepExeDays>0 PICCRepRealExeDaysRatio=$fn((PICCRepRealExeDays/PICCRepExeDays)*100,"",2)_"%"   //PICC天数执行率
		Set:VAPReps>0 VAPRepRatio=$fn((VAPRepExes/VAPReps)*100,"",2)_"%"   									 //VAP执行率
		Set:VAPRepExeDays>0 VAPRepRealExeDaysRatio=$fn((VAPRepRealExeDays/VAPRepExeDays)*100,"",2)_"%"       //VAP天数执行率
		Set:UCReps>0 UCRepRatio=$fn((UCRepExes/UCReps)*100,"",2)_"%"                                         //UC执行率
		Set:UCRepExeDays>0 UCRepRealExeDaysRatio=$fn((UCRepRealExeDays/UCRepExeDays)*100,"",2)_"%"           //UC天数执行率
		
		Set PICCRep=$lb(PICCReps,PICCRepExes,PICCRepNExes,PICCRepRatio,PICCRepExeDays,PICCRepRealExeDays,PICCRepRealExeDaysRatio)
		Set VAPRep=$lb(VAPReps,VAPRepExes,VAPRepNExes,VAPRepRatio,VAPRepExeDays,VAPRepRealExeDays,VAPRepRealExeDaysRatio)
		Set UCRep=$lb(UCReps,UCRepExes,UCRepNExes,UCRepRatio,UCRepExeDays,UCRepRealExeDays,UCRepRealExeDaysRatio )
		Set Data=$lb(0,"","全部",InCount,InDays,VAPDays,VAPRatio,VAPCount,VAPInfectPat,VAPINFCount,VAPINFRatio,PICCDays,PICCRatio,PICCCount,PICCInfectPat,PICCINFCount,PICCINFRatio,UCDays,UCRatio,UCCount,UCInfectPat,UCINFCount,UCINFRatio)
		Set Data=Data_$lb(CVCDays,CVCRatio,CVCCount,CRRTDays,CRRTRatio,CRRTCount,PORTDays,PORTRatio,PORTCount,PICCsDays,PICCsRatio,PICCsCount)_PICCRep_VAPRep_UCRep
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryIExARepRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIExARepRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIExARepRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIExARepRatioExecute ]
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

/// Creator：     guojun
/// CreatDate：   2023-04-03
/// Description:  三管感染核心防控措施执行率统计明细表
/// Table：       DHCHAI.IR.ICUExA,DHCHAI.IR.ICUExAExt
/// Input:		  aDateFrom ：开始日期
/// 			  aDateTo   ：结束日期 
/// 			  aDimensKey: 维度
/// 			  aTubeType : 三管类型
///               aIsExe    : 0:全部，1：执行的，2：未执行的
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.IExAQrySrv","QryRepRatioDtl","2023-03-28","2023-03-28","0001-07-0006-W-4","W","UC","6","")
Query QryRepRatioDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "", aIsExe As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TubeType:%String,IAIntuDate:%String,IAExtuDate:%String,xIExAID:%String,IATypeID:%String,IADays:%String,IAEexDays:%String,IANExeDays:%String,IATypeDesc:%String,IsNeedAssert:%String") [ SqlProc ]
{
}

ClassMethod QryRepRatioDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "", aIsExe As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:+aHospIDs="0" aHospIDs=""
	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set aLocDr = "" 
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
  	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set HospGrpDr=""    
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set NIndex="QryRepRatioDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	//插拔管从插管后第几天开始评估(PICC-VAP-UC)
	Set IPStaDay=##class(DHCHAI.BT.Config).GetValByCode("IExAStartDay")		//取配置数据
	Set StaDay=""
	Set:aTubeType="PICC" StaDay=$p(IPStaDay,"-",1)
	Set:aTubeType="VAP" StaDay=$p(IPStaDay,"-",2)
	Set:aTubeType="UC" StaDay=$p(IPStaDay,"-",3)
	Quit:StaDay="" ""
	
	Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aStaType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
    	Set Paadm      = $LIST(TransInfo,1)          //就诊号
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)     
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		Set TransIDs   = $LIST(TransInfo,6)
		
		//过滤重复病人
		Continue:$d(^TMP($zn,$j,NIndex,"AdmPat",Paadm ))
		Set ^TMP($zn,$j,NIndex,"AdmPat",Paadm )=""
		
		Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm ))
		Continue:AdmData=""
		
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		//add 20220304 三管汇总统计多选科室汇总与明细不一致问题修改
		If (aLocIDs'="") {
			Continue:((","_aLocIDs_",")'[(","_LocID_","))
		}

		Set LocDesc	= $li(LocData,3)
		
		//院区过滤
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		//add 20210715 医院分组过滤
		Continue:HospDr=""
		Set HospInfo="",HospGroupDr=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
		Set HospGroupDr=$lg(HospInfo,5)
		Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)    
				
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			
		}
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&(aLocType="E")&&(LocDr'=aLocDr)		
		Continue:(aLocType'="")&(aLocType="W")&&(WardDr'=aLocDr)
	     	
		//患者转科基本信息
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""

		//插拔管基本信息
		Set TubeData=""
		Set xIExAID=""
		For{
			Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",Paadm,xIExAID))
			Quit:xIExAID=""

			Set IExAData=$g(^DHCHAI.IR.ICUIExAD(xIExAID))
			Continue:IExAData=""
			//过滤无效数据
			Set IsActive=$li(IExAData,7)		
			Continue:IsActive'=1	
				
			Set IntuTypeID=$li(IExAData,3)								//'插管类型'字典ID
			Continue:IntuTypeID=""
			Set DicData=$g(^DHCHAI.BT.DictionaryD(IntuTypeID))			//'插管类型'字典
			Continue:DicData=""
			Set DicTypeID=$li(DicData,4)								//'插管类型'字典分类ID
			Continue:DicTypeID=""
			Set DicTypeData=$g(^DHCHAI.BT.DicTypeD(DicTypeID))			//'插管类型'字典分类字典
			Continue:DicTypeData=""
			Set DicTypeCode=$li(DicTypeData,2)							//'插管类型'字典分类字典Code[IExAPICCTubeType]
	
			Set IAIntuDate=$li(IExAData,4)								//插管日期
			Set IAExtuDate=$li(IExAData,5)								//拔管日期
		
			Set IAStartDate=IAIntuDate+StaDay-1	,IAEndDate=IAExtuDate  	//督查开始日期，督察结束日期
			Set:IAEndDate="" IAEndDate=+$h								//督察结束日期-当前
			Set IADays=(IAEndDate-IAStartDate)+1						//督查天数
			Set:(IAStartDate>IAEndDate) IADays=0,IAStartDate="",IAEndDate="",IANExeDays=0
				
			Set IAEexDays=##class(DHCHAI.IRS.IExAQrySrv).GetRepExeDays(xIExAID,aTubeType)	//实际执行天数天数
			Set:IADays>0 IANExeDays=(IADays-IAEexDays)				    //未执行天数
			
			
			Continue:((aIsExe=1)&(IAEexDays'=IADays))      				// 执行完成的督察表
			Continue:((aIsExe=2)&(IAEexDays=IADays))       				//未执行完成的督察表
			//是否需评估(插管后48小时开始) 
			Set IsNeedAssert=0
			For xDay=2:1:IADays{
				Set xExtID=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",xIExAID,xDay,""))
				Set:xExtID="" IsNeedAssert=1   
				Quit:IsNeedAssert=1	
			}
			
			Set IATypeID=IntuTypeID										//插管类型ID(699)
			Set IATypeDesc=$li(DicData,3)								//插管类型(股静脉)
			Set:IAIntuDate'="" IAIntuDate=$zd(IAIntuDate,3)				//转换日期
			Set:IAExtuDate'="" IAExtuDate=$zd(IAExtuDate,3)
			Set:IAStartDate'="" IAStartDate=$zd(IAStartDate,3)			
			Set:IAEndDate'="" IAEndDate=$zd(IAEndDate,3)
			
			If ((DicTypeCode["PICC")&&(aTubeType="PICC")){
				Set TubeData=$lb("PICC",IAStartDate,IAEndDate,xIExAID,IATypeID,IADays,IAEexDays,IANExeDays,IATypeDesc,IsNeedAssert)
				D OutputRow
			}
			elseif((DicTypeCode["VAP")&&(aTubeType="VAP")){
				Set TubeData=$lb("VAP",IAStartDate,IAEndDate,xIExAID,IATypeID,IADays,IAEexDays,IANExeDays,IATypeDesc,IsNeedAssert)
				D OutputRow
			}
			elseif((DicTypeCode["UC")&&(aTubeType="UC")){
				Set TubeData=$lb("UC",IAStartDate,IAEndDate,xIExAID,IATypeID,IADays,IAEexDays,IANExeDays,IATypeDesc,IsNeedAssert)
				D OutputRow
			}			
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
OutputRow
	Set Data=PatData_TubeData
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryRepRatioDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepRatioDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepRatioDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepRatioDtlExecute ]
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

/// Creator：     guojun
/// CreatDate：   2023-04-06
/// Description:  统计一份督察表下的实际执行天数
/// Table：       DHCHAI.IR.ICUExA,DHCHAI.IR.ICUExAExt
/// Input:        aIExAID:督察表ID
/// 		 	  aTubeType:插管类型[PICC|VAP|UC]
/// w ##class(DHCHAI.IRS.IExAQrySrv).GetRepExeDays("18","PICC")
ClassMethod GetRepExeDays(aIExAID As %String, aTubeType As %String) As %String
{

	new (aIExAID, aTubeType)
	Set ret=0
	Quit:(aIExAID="")||(aTubeType="") ret
	
	Set NIndex="GetRepExeDays"
	
	//插拔管从插管后第几天开始评估(PICC-VAP-UC)
	Set IPStaDay=##class(DHCHAI.BT.Config).GetValByCode("IExAStartDay")		//取配置数据
	Set StaDay=""
	Set:aTubeType="PICC" StaDay=$p(IPStaDay,"-",1)
	Set:aTubeType="VAP" StaDay=$p(IPStaDay,"-",2)
	Set:aTubeType="UC" StaDay=$p(IPStaDay,"-",3)
	Quit:StaDay="" ret
	Set DayCounts =0
		
	//'督察表'数据
	Set IExAData=$g(^DHCHAI.IR.ICUIExAD(aIExAID))
	Quit:IExAData="" ret
	
	Set IAIntuDate=$li(IExAData,4)								//插管日期
	Set IAExtuDate=$li(IExAData,5)								//拔管日期
	Set IAStartDate=IAIntuDate+StaDay-1	,IAEndDate=IAExtuDate  	//督查开始日期，督察结束日期
	Set:IAEndDate="" IAEndDate=+$h								//督察结束日期-当前
	Set IADays=(IAEndDate-IAStartDate)						    //督查天数
	Set:(IAStartDate>IAEndDate) IADays=0	
	Set StartDay=StaDay		    								//开始督查(第几天)
	Set EndDay=IADays+StartDay									//结束督查(第几天)
		
	//督查项目-防控措施
	Set Index=4
	Set IExAItems=##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems(aTubeType)	
	Set PreMeCount = 0
	for xDay=StartDay:1:EndDay{	
		Set Count(xDay)=0
	}
	For xID=1:1:$l(IExAItems,"#"){
		Set ItemData=$p(IExAItems,"#",xID)
		Continue:ItemData=""
		
		Set DicID=$p(ItemData,"^",4)
		Set DicCode=$p(ItemData,"^",5)
		Continue:DicCode'["PreMeasure"
		Set:DicCode["PreMeasure" PreMeCount=PreMeCount+1   // 核心防控措施数目
		For xDay=StartDay:1:EndDay{
			Set ItemVal=""
			Set ExtID=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",aIExAID,xDay,DicID,""))
			If (ExtID'=""){
				Set ExtObj=##class(DHCHAI.IR.ICUIExAExt).GetObjById(aIExAID_"||"_ExtID)
				If ($ISObject(ExtObj)){
					Set ItemVal=ExtObj.IExAItemVal
				}
			}
			If (ItemVal="1") {       
				Set Count(xDay)=Count(xDay)+1   //统计督察日期内某一天已经执行的防控措施
			}
		}
		Set Index=Index+1
	}
	For xItem=StartDay:1:EndDay{
		If (Count(xItem)=PreMeCount){  //统计督察日内某一天防控措施是否都执行
			Set DayCounts = DayCounts +1
		}
	}		
	Quit DayCounts
}

/// Creator：     guojun
/// CreatDate：   2023-04-06
/// Description:  实际执行天数-统计该患者某一插管类型下的所有督察表
/// Table：       DHCHAI.IR.ICUExA,DHCHAI.IR.ICUExAExt
/// Input:        aEpisodeID 
/// 		 	  aTubeType:插管类型[PICC|VAP|UC]
/// w ##class(DHCHAI.IRS.IExAQrySrv).GetIExARepExeDays("18","PICC")
ClassMethod GetIExARepExeDays(aEpisodeID As %String, aTubeType As %String) As %String
{

	new (aEpisodeID , aTubeType)
	Quit:(aEpisodeID="")||(aTubeType="") ""
	
	Set NIndex="GetIExARepExeDays"
	Kill ^TMP($zn,$j,NIndex)
	
	//插拔管从插管后第几天开始评估(PICC-VAP-UC)
	Set IPStaDay=##class(DHCHAI.BT.Config).GetValByCode("IExAStartDay")		//取配置数据
	Set StaDay=""
	Set:aTubeType="PICC" StaDay=$p(IPStaDay,"-",1)
	Set:aTubeType="VAP" StaDay=$p(IPStaDay,"-",2)
	Set:aTubeType="UC" StaDay=$p(IPStaDay,"-",3)
	Quit:StaDay="" ""
	Set DayCounts =0
	//循环插拔管评估表
	Set xIExAID=""
	For{
		Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",aEpisodeID,xIExAID))
		Quit:xIExAID=""		
		
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
		Quit:PAAdmData="" 
		
		//'督察表'数据
		Set IExAData=$g(^DHCHAI.IR.ICUIExAD(xIExAID))
		Continue:IExAData=""
		//过滤无效数据
		Set IsActive=$li(IExAData,7)		
		Continue:IsActive'=1	
			
		Set IntuTypeID=$li(IExAData,3)								//'插管类型'字典ID
		Continue:IntuTypeID=""
		Set DicData=$g(^DHCHAI.BT.DictionaryD(IntuTypeID))			//'插管类型'字典
		Continue:DicData=""
		Set DicTypeID=$li(DicData,4)								//'插管类型'字典分类ID
		Continue:DicTypeID=""
		Set DicTypeData=$g(^DHCHAI.BT.DicTypeD(DicTypeID))			//'插管类型'字典分类字典
		Continue:DicTypeData=""
		Set DicTypeCode=$li(DicTypeData,2)							//'插管类型'字典分类字典Code[IExAPICCTubeType]
		Continue:DicTypeCode'[aTubeType	
		Set IAIntuDate=$li(IExAData,4)								//插管日期
		Set IAExtuDate=$li(IExAData,5)								//拔管日期
		
		Set IAStartDate=IAIntuDate+StaDay-1	,IAEndDate=IAExtuDate  	//督查开始日期，督察结束日期
		Set:IAEndDate="" IAEndDate=+$h								//督察结束日期-当前
		Set IADays=(IAEndDate-IAStartDate)						    //督查天数
		Set:(IAStartDate>IAEndDate) IADays=0	
		Set StartDay=StaDay		    								//开始督查(第几天)
		Set EndDay=IADays+StartDay									//结束督查(第几天)
		
		//获取督查项目-防控措施信息
		Set Index=4
		If ((DicTypeCode["PICC")&&(aTubeType="PICC")){ 
			Set TubeType="PICC"
			Set IExAItems=##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems(TubeType) 	
		}
		If ((DicTypeCode["VAP")&&(aTubeType="VAP")){
			Set TubeType="VAP"
			Set IExAItems=##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems(TubeType)  
		}
		If ((DicTypeCode["UC")&&(aTubeType="UC")) {
			Set TubeType="UC"
			Set IExAItems=##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems(TubeType)	 
		}
		Set PreMeCount = 0
		For xDay=StartDay:1:EndDay{	
			Set Count(xDay)=0
		}
		For xID=1:1:$l(IExAItems,"#"){
			Set ItemData=$p(IExAItems,"#",xID)
			Continue:ItemData=""
			
			Set DicTypeID=$p(ItemData,"^",1)	
			Set DicTypeCode=$p(ItemData,"^",2)
			Set DicTypeDesc=$p(ItemData,"^",3)
			Set DicID=$p(ItemData,"^",4)
			Set DicCode=$p(ItemData,"^",5)
			Set DicDesc=$p(ItemData,"^",6)
			
			Continue:DicCode'["PreMeasure"  //过滤非核心防控措施的其他项目
			Set:DicCode["PreMeasure" PreMeCount=PreMeCount+1   // 核心防控措施数目
			Set ItemVals=""					//存储项目值
			for xDay=StartDay:1:EndDay{
				Set ItemVal=""
				Set ExtID=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",xIExAID,xDay,DicID,""))
				If (ExtID'=""){
					Set ExtObj=##class(DHCHAI.IR.ICUIExAExt).GetObjById(xIExAID_"||"_ExtID)
					If ($ISObject(ExtObj)){
						Set ItemVal=ExtObj.IExAItemVal
					}
				}
				If (ItemVal="1") {       
					Set Count(xDay)=Count(xDay)+1   //统计督察日期内某一天已经执行的防控措施
				}
				Set ItemVals=ItemVals_"^"_ItemVal
			}
			Set Index=Index+1
		}
		For xItem=StartDay:1:EndDay{
			If (Count(xItem)=PreMeCount){  //统计督察日内某一天防控措施是否都执行
				Set DayCounts = DayCounts +1
			}
		}
	}		
	Kill ^TMP($zn,$j,NIndex)
	Quit DayCounts
}

/// Creator：     guojun
/// CreatDate：   2023-04-06
/// Description:  执行督查表数-统计该患者某一插管类型下的所有督察表
/// Table：       DHCHAI.IR.ICUExA,DHCHAI.IR.ICUExAExt
/// Input:        aEpisodeID
/// 		 	  aTubeType:插管类型[PICC|VAP|UC]
/// w ##class(DHCHAI.IRS.IExAQrySrv).GetIExARepExes("18","PICC")
ClassMethod GetIExARepExes(aEpisodeID As %String, aTubeType As %String) As %String
{
	new (aEpisodeID , aTubeType)
	Quit:(aEpisodeID="")||(aTubeType="") ""
	
	Set NIndex="QryIExARep"
	Kill ^TMP($zn,$j,NIndex)
	
	//插拔管从插管后第几天开始评估(PICC-VAP-UC)
	Set IPStaDay=##class(DHCHAI.BT.Config).GetValByCode("IExAStartDay")		//取配置数据
	Set StaDay=""
	Set:aTubeType="PICC" StaDay=$p(IPStaDay,"-",1)
	Set:aTubeType="VAP" StaDay=$p(IPStaDay,"-",2)
	Set:aTubeType="UC" StaDay=$p(IPStaDay,"-",3)
	Quit:StaDay="" ""
	Set Counts=0
	//循环插拔管评估表
	Set xIExAID=""
	For{
		Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",aEpisodeID,xIExAID))
		Quit:xIExAID=""		
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
		Quit:PAAdmData="" 
		Set DayCounts=0
		//'督察表'数据
		Set IExAData=$g(^DHCHAI.IR.ICUIExAD(xIExAID))
		Continue:IExAData=""
		
		//过滤无效数据
		Set IsActive=$li(IExAData,7)		
		Continue:IsActive'=1	
			
		Set IntuTypeID=$li(IExAData,3)								//'插管类型'字典ID
		Continue:IntuTypeID=""
		Set DicData=$g(^DHCHAI.BT.DictionaryD(IntuTypeID))			//'插管类型'字典
		Continue:DicData=""
		Set DicTypeID=$li(DicData,4)								//'插管类型'字典分类ID
		Continue:DicTypeID=""
		Set DicTypeData=$g(^DHCHAI.BT.DicTypeD(DicTypeID))			//'插管类型'字典分类字典
		Continue:DicTypeData=""
		Set DicTypeCode=$li(DicTypeData,2)							//'插管类型'字典分类字典Code[IExAPICCTubeType]
		Continue:DicTypeCode'[aTubeType	
		Set IAIntuDate=$li(IExAData,4)								//插管日期
		Set IAExtuDate=$li(IExAData,5)								//拔管日期
		
		Set IAStartDate=IAIntuDate+StaDay-1	,IAEndDate=IAExtuDate  	//督查开始日期，督察结束日期
		Set:IAEndDate="" IAEndDate=+$h								//督察结束日期-当前
		Set IADays=(IAEndDate-IAStartDate)						    
		Set Days=(IAEndDate-IAStartDate)+1						    //督查天数
		Set:(IAStartDate>IAEndDate) Days=0
		Set:(IAStartDate>IAEndDate) IADays=0	
		Set StartDay=StaDay		    								//开始督查(第几天)
		Set EndDay=IADays+StartDay									//结束督查(第几天)
		
		//获取督查项目-防控措施信息
		Set Index=4
		If ((DicTypeCode["PICC")&&(aTubeType="PICC")){ 
			Set TubeType="PICC"
			Set IExAItems=##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems(TubeType) 	
		}
		If ((DicTypeCode["VAP")&&(aTubeType="VAP")){
			Set TubeType="VAP"
			Set IExAItems=##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems(TubeType)  
		}
		If ((DicTypeCode["UC")&&(aTubeType="UC")) {
			Set TubeType="UC"
			Set IExAItems=##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems(TubeType)	 
		}
		Set PreMeCount = 0
		For xDay=StartDay:1:EndDay{	
			Set Count(xDay)=0
		}
		For xID=1:1:$l(IExAItems,"#"){
			Set ItemData=$p(IExAItems,"#",xID)
			Continue:ItemData=""
			
			Set DicTypeID=$p(ItemData,"^",1)	
			Set DicTypeCode=$p(ItemData,"^",2)
			Set DicTypeDesc=$p(ItemData,"^",3)
			Set DicID=$p(ItemData,"^",4)
			Set DicCode=$p(ItemData,"^",5)
			Set DicDesc=$p(ItemData,"^",6)
			
			Continue:DicCode'["PreMeasure"
			Set:DicCode["PreMeasure" PreMeCount=PreMeCount+1   // 核心防控措施数目
			Set ItemVals=""					//存储项目值
			
			For xDay=StartDay:1:EndDay{
				Set ItemVal=""
				Set ExtID=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",xIExAID,xDay,DicID,""))
				If (ExtID'=""){
					Set ExtObj=##class(DHCHAI.IR.ICUIExAExt).GetObjById(xIExAID_"||"_ExtID)
					If ($ISObject(ExtObj)){
						Set ItemVal=ExtObj.IExAItemVal
					}
				}
				If (ItemVal="1") {       
					Set Count(xDay)=Count(xDay)+1   	//统计督察日期内某一天已经执行的防控措施
				}
				Set ItemVals=ItemVals_"^"_ItemVal
			}
		}
		Set Index=Index+1	
		For xItem=StartDay:1:EndDay{      			//统计执行天数
			If (Count(xItem)=PreMeCount){  			//统计督察日内某一天防控措施是否执行
				Set DayCounts = DayCounts +1
			}
		} 
		If (DayCounts=Days){   				//判断督察表是否执行完成
			Set Counts = Counts +1
		}
	}		

	Kill ^TMP($zn,$j,NIndex)
	Quit Counts
}

/// Creator：     guojun
/// CreatDate：   2023-03-25
/// Description:  获取患者插拔管督察表数目(PICC | VAP |UC)-统计该患者某一插管类型下的所有督察表
/// Input：       aEpisodeID
/// 		 	  aTubeType:插管类型[PICC|VAP|UC]
/// Return:		  Count
/// w ##class(DHCHAI.IRS.IExAQrySrv).GetIExARepCountS("335","PICC")
ClassMethod GetIExARepCountS(aEpisodeID As %String, aTubeType As %String) As %String
{
	new (aEpisodeID,aTubeType)
	Set Ret=""
	Quit:(aEpisodeID=""||aTubeType="") Ret
	
	Set NIndex="GetIExARepCountS"
	Kill ^TMP($zn,$j,NIndex)
	//循环插拔管评估表
	Set xIExAID=""
	For{
		Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",aEpisodeID,xIExAID))
		Quit:xIExAID=""
	
		Set obj=##class(DHCHAI.IR.ICUIExA).GetObjById(xIExAID)
		Continue:'$IsObject(obj)
		//过滤无效数据
		Set IsActive=obj.IExAIsActive
		Continue:IsActive'=1
		
		Set IntuTypeDr=obj.IExAIntuTypeDr			//'评估表'插管类别字典
		Continue:'$IsObject(IntuTypeDr)
		Set DicTypeDr=IntuTypeDr.BTTypeDr			//'评估表'插管类别字典分类
		Continue:'$IsObject(DicTypeDr)
		
		Set DicTypeCode=DicTypeDr.BTCode			//字典分类Code[IExAPICCTubeType]
		
		if ((DicTypeCode["PICC")&&(aTubeType="PICC")){ 
			set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
		}
		if ((DicTypeCode["VAP")&&(aTubeType="VAP")){ 
			set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
		}
		if ((DicTypeCode["UC")&&(aTubeType="UC")){
			set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
		}
	}
	
	Set Count=+$g(^TMP($zn,$j,NIndex,"TubeDays"))
	Kill ^TMP($zn,$j,NIndex)
	Quit Count
}

/// Creator：     guojun
/// CreatDate：   2023-03-29
/// Description:  督查天数-统计该患者某一插管类型下的所有督察表
/// Table：       DHCHAI.IR.ICUExA
/// Input：       aEpisodeID，aTubeType:插管类型(PICC/VAP/UC)
/// Return：      IADays
/// w ##class(DHCHAI.IRS.IExAQrySrv).GetIExADays("30","PICC")
ClassMethod GetIExADays(aEpisodeID As %String, aTubeType As %String) As %String
{
	new ( aEpisodeID,aTubeType)
	//插拔管基本信息
	Set xIExAID="",Days=0
	
	//插拔管从插管后第几天开始评估(PICC-VAP-UC)
	Set IPStaDay=##class(DHCHAI.BT.Config).GetValByCode("IExAStartDay")		//取配置数据
	Set StaDay=""
	Set:aTubeType="PICC" StaDay=$p(IPStaDay,"-",1)
	Set:aTubeType="VAP" StaDay=$p(IPStaDay,"-",2)
	Set:aTubeType="UC" StaDay=$p(IPStaDay,"-",3)
	Quit:StaDay="" ""
	
	For{
		Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",aEpisodeID,xIExAID))
		Quit:xIExAID=""
		Set IExAData=$g(^DHCHAI.IR.ICUIExAD(xIExAID))
		Continue:IExAData=""
		//过滤无效数据
		Set IsActive=$li(IExAData,7)		
		Continue:IsActive'=1	
			
		Set IntuTypeID=$li(IExAData,3)								//'插管类型'字典ID
		Continue:IntuTypeID=""
		Set DicData=$g(^DHCHAI.BT.DictionaryD(IntuTypeID))			//'插管类型'字典
		Continue:DicData=""
		Set DicTypeID=$li(DicData,4)								//'插管类型'字典分类ID
		Continue:DicTypeID=""
		Set DicTypeData=$g(^DHCHAI.BT.DicTypeD(DicTypeID))			//'插管类型'字典分类字典
		Continue:DicTypeData=""
		Set DicTypeCode=$li(DicTypeData,2)							//'插管类型'字典分类字典Code[IExAPICCTubeType]
								
		Set IAIntuDate=$li(IExAData,4)								//插管日期
		Set IAExtuDate=$li(IExAData,5)								//拔管日期
		
		Set IAStartDate=IAIntuDate+StaDay-1	,IAEndDate=IAExtuDate  	//督查开始日期，督察结束日期
		Set:IAEndDate="" IAEndDate=+$h								//督察结束日期-当前
		Set IADays=(IAEndDate-IAStartDate)+1						//督查天数
		Set:(IAStartDate>IAEndDate) IADays=0							
		
		If ((DicTypeCode["PICC")&&(aTubeType="PICC")){
			Set Days=IADays+Days
		}
		If ((DicTypeCode["VAP")&&(aTubeType="VAP")){
			Set Days=IADays+Days
		}
		If ((DicTypeCode["UC")&&(aTubeType="UC")){
			Set Days=IADays+Days	
		}
	}
	Quit Days
}

}

Class DHCHAI.STATV2.ICUTubeTrendDtl Extends DHCHAI.STATV2.ICUTubeTrend [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     lzhe
/// CreatDate：   2021-02-01
/// Description:  插管趋势分析在/出院人明细
/// Table：       
/// Input:        	 aTypeFlag  : 出住院标志 I 住院 O 出院
/// 				 aTubeType  ：插管类型 All 全部;VAP 呼吸机；PICC静脉导管 ；UC导尿管
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ICUTubeTrendDtl","QryITTPatDtl","1","2020-01-01","2021-02-22","W","","I","")
Query QryITTPatDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %Text = "", aTypeFlag As %String = "I", aTubeType As %String = "ALL") As websys.Query(ROWSPEC = "EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,AdmTimes:%String") [ SqlProc ]
{
}

ClassMethod QryITTPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %Text = "", aTypeFlag As %String = "I", aTubeType As %String = "ALL") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set NIndex="QryITTPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")	
    Set:(aTubeType="PICC")&(ICUPatLogSplit=1) aTubeType="PICCs"
    
    If (aTypeFlag="O") { //出院患者		
		Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
	    For index=1:1:DishPatArr.Count() {
		    Set DishPat=DishPatArr.GetAt(index)
		    Set Paadm	= $li(DishPat,1)
		    Set HospDr	= $li(DishPat,2)
		    Set GroupDr	= $li(DishPat,3)
		    Set LocDr	= $li(DishPat,4)
		    Set WardDr	= $li(DishPat,5)
		    Set AdmDate	= $li(DishPat,6)
		    Set DishDate= $li(DishPat,7)
		    
		    Set LocID = LocDr
			Set:aLocType="W" LocID=WardDr
		    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))  
		    Continue:Paadm=""
			Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:AdmInfo=""
            Set AdmTimes = $lg(AdmInfo,38)   //就诊次数
            Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""

			Set xTransID=0
			For {
				Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",aLocType,Paadm,xTransID))
				Quit:xTransID=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",aLocType,Paadm,xTransID,xID))
					Quit:xID=""
				
					Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(xID))
					Set TranLocDr   = $li(TranData,5)
					Continue:TranLocDr=""
					Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
					Set TranLocDesc = $lg(TranLocData,3)
					Set TranLocDesc2 = $lg(TranLocData,4)
					Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
					Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)

					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					 	        
 	        		//插管天数
					Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(TranLocDr,Paadm,AdmDate,DishDate,"",aTubeType)	

					Set Data=PatData_$lb(xID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime,Days,AdmTimes)	
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
	    }
	} Else {   //住院患者   
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
				Continue:Paadm=""
				Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(Paadm))
				Continue:AdmInfo=""
	            Set AdmTimes = $lg(AdmInfo,38)   //就诊次数
	            Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
           		 //插管天数
				Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aLocType)

				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set TranLocDr   = $li(TranData,5)
					Continue:TranLocDr=""
					Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
					Set TranLocDesc = $lg(TranLocData,3)
					Set TranLocDesc2 = $lg(TranLocData,4)
					Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
					Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)
			
					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
										
					Set Data=PatData_$lb(TransID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime,Days,AdmTimes)	
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
	}

	Quit $$$OK
}

/// 三管使用明细
///  do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ICUTubeTrendDtl","QryTubePat","1|2","2020-05-01","2020-05-31","W","","I","ALL")
Query QryTubePat(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %String, aTypeFlag As %String = "I", aTubeType As %String = "ALL") As websys.Query(ROWSPEC = "EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,AdmTimes:%String,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTubePatExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %String, aTypeFlag As %String = "I", aTubeType As %String = "ALL") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 		
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
		
	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")
    Set:(aTubeType="PICC")&(ICUPatLogSplit=1) aTubeType="PICCs"

	Set NIndex="QryTubePat"
	Kill ^TMP($zn,$j,NIndex)
 	//同期在科
    If (aTypeFlag="O") { //出院患者		
		Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
	    For index=1:1:DishPatArr.Count() {
		    Set DishPat=DishPatArr.GetAt(index)
		    Set Paadm	= $li(DishPat,1)
		    Set HospDr	= $li(DishPat,2)
		    Set GroupDr	= $li(DishPat,3)
		    Set LocDr	= $li(DishPat,4)
		    Set WardDr	= $li(DishPat,5)
		    Set AdmDate	= $li(DishPat,6)
		    Set DishDate= $li(DishPat,7)
		    
		    Set LocID = LocDr
			Set:aLocType="W" LocID=WardDr
		    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))  
		    Continue:Paadm=""
			Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:AdmInfo=""
            Set AdmTimes = $lg(AdmInfo,38)   //就诊次数
            Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
 	        
 	        //插管天数
			Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays("",Paadm,AdmDate,DishDate,"",aTubeType)	
			Continue:Days=0
			Set xTransID=0
			For {
				Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",aLocType,Paadm,xTransID))
				Quit:xTransID=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",aLocType,Paadm,xTransID,xID))
					Quit:xID=""
				
					Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(xID))
					Set TranLocDr   = $li(TranData,5)
					Continue:TranLocDr=""
					Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
					Set TranLocDesc = $lg(TranLocData,3)
					Set TranLocDesc2 = $lg(TranLocData,4)
					Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
					Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)
					Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
			
					//插管天数
					Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(TranLocDr,Paadm,AdmDate,DishDate,"",aTubeType)	

					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					Set TransInfo=$lb(TransID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime)
										
					//取三管医嘱信息
					Set TubeArr=##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,aTubeType,ICUPatLogSplit)
					If (TubeArr.Count()>0) {
						For ArrInd=1:1:TubeArr.Count(){
							Set TubeInfo=TubeArr.GetAt(ArrInd)
						
						   	Set Data =PatData_TransInfo_$lb(Days,AdmTimes)_TubeInfo
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}Else {   //有插管记录但无插管医嘱
						Set Data =PatData_TransInfo_$lb(Days,AdmTimes)_$lb("","","","","","","","","")
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
				
			}
	    }
	} Else {   //住院患者   
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
				Continue:Paadm=""
				Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(Paadm))
				Continue:AdmInfo=""
	            Set AdmTimes = $lg(AdmInfo,38)   //就诊次数
	            Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
           		 //插管天数
				Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aLocType)
				Continue:Days=0
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set TranLocDr   = $li(TranData,5)
					Continue:TranLocDr=""
					Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
					Set TranLocDesc = $lg(TranLocData,3)
					Set TranLocDesc2 = $lg(TranLocData,4)
					Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
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
					Set TransInfo=$lb(TransID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime)
										
					//取三管医嘱信息
					Set TubeArr=##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,aTubeType,ICUPatLogSplit)
					If (TubeArr.Count()>0) {
						For ArrInd=1:1:TubeArr.Count(){
							Set TubeInfo=TubeArr.GetAt(ArrInd)
						
						   	Set Data =PatData_TransInfo_$lb(Days,AdmTimes)_TubeInfo
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}Else {   //有插管记录但无插管医嘱
						Set Data =PatData_TransInfo_$lb(Days,AdmTimes)_$lb("","","","","","","","","")
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
		    }
		}
	}

	Quit $$$OK
}

/// 获取插管感染例次
/// 获取插管感染患者明细
///  do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.ICUTubeTrendDtl","QryTubeInfCase","1|2","2020-05-01","2020-05-31","W","","I","VAP")
Query QryTubeInfCase(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %Text = "", aTypeFlag As %String = "I", aTubeType As %String = "ALL") As websys.Query(ROWSPEC = "EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TubeDays:%Integer,AdmTimes:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String,DiagID:%String,InfPosDesc:%String,InfDate:%String,InfType:%String,Effect:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryTubeInfCaseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocIDs As %Text = "", aTypeFlag As %String = "I", aTubeType As %String = "ALL") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
		
	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set TubeType=aTubeType
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")
    Set:(TubeType="PICC")&(ICUPatLogSplit=1) TubeType="PICCs" 
    
	Set NIndex="QryTubeInfCase"
	Kill ^TMP($zn,$j,NIndex)
  	//同期在科
    If (aTypeFlag="O") { //出院患者		
		Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
	    For index=1:1:DishPatArr.Count() {
		    Set DishPat=DishPatArr.GetAt(index)
		    Set Paadm	= $li(DishPat,1)
		    Set HospDr	= $li(DishPat,2)
		    Set GroupDr	= $li(DishPat,3)
		    Set LocDr	= $li(DishPat,4)
		    Set WardDr	= $li(DishPat,5)
		    Set AdmDate	= $li(DishPat,6)
		    Set DishDate= $li(DishPat,7)
		    
		    Set LocID = LocDr
			Set:aLocType="W" LocID=WardDr
		    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))  
		    Continue:Paadm=""
			Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:AdmInfo=""
            Set AdmTimes = $lg(AdmInfo,38)   //就诊次数
            Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
 	        
			Set xTransID=0
			For {
				Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",aLocType,Paadm,xTransID))
				Quit:xTransID=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",aLocType,Paadm,xTransID,xID))
					Quit:xID=""
				
					Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(xID))
					Set TranLocDr   = $li(TranData,5)
					Continue:TranLocDr=""
					Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
					Set TranLocDesc = $lg(TranLocData,3)
					Set TranLocDesc2 = $lg(TranLocData,4)
					Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
					Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)
					
					Set (LocDr,WardDr)=""
					Set:aLocType="E" LocDr=TranLocDr
					Set:aLocType="W" WardDr=TranLocDr
					//插管天数
				
					Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(TranLocDr,Paadm,AdmDate,DishDate,"",TubeType)	
					Set (InfDatas,InfData,TubeInfos,TubeInfo)=""
		            Set TubeInfInfo =##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,aTubeType,TransDate,OutLocDate,LocDr,WardDr)
		            Continue:TubeInfInfo=""		
					
					For InfNo=1:1:$L(TubeInfInfo,"|") {
						Set InfPosMsg=$p(TubeInfInfo,"|",InfNo)
						Continue:InfPosMsg=""
						Set InfDate	= $p(InfPosMsg,"^",1)
						Set DiagID= $p(InfPosMsg,"^",5)
						//记录感染信息,加入转科记录，防止转回原科室后，仍显示感染信息
						Continue:$d(^TMP($zn,$j,NIndex,"InfPat",TranLocDr,Paadm,DiagID))   
						Set ^TMP($zn,$j,NIndex,"InfPat",TranLocDr,Paadm,DiagID)=""
				
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
					Set TransInfo=$lb(TransID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime)
					//插管医嘱
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
				
						Set Data=PatData_$lb(Days,AdmTimes)_TransInfo_TubeInfo_InfData
									
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
	    }
	} Else {   //住院患者   
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
				Continue:Paadm=""
				Set AdmInfo=$g(^DHCHAI.DP.PAAdmD(Paadm))
				Continue:AdmInfo=""
	            Set AdmTimes = $lg(AdmInfo,38)   //就诊次数
	            Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
           		 //插管天数
				Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aLocType)
				
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set TranLocDr   = $li(TranData,5)
					Continue:TranLocDr=""
					Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
					Set TranLocDesc = $lg(TranLocData,3)
					Set TranLocDesc2 = $lg(TranLocData,4)
					Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
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
					Set TransInfo=$lb(TransID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime)
					//插管医嘱
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
				
						Set Data=PatData_$lb(Days,AdmTimes)_TransInfo_TubeInfo_InfData
									
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
	    }
	}

	Quit $$$OK
}

}

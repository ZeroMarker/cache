Class DHCHAI.STAS.ResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCHAI.STAS.ResultSrv).Clear(4)
ClassMethod Clear(a)
{
	Set year="2018"
	Set monthf=a
	Set montht=8
	Set ListTarget=$lb("INFOper","INFOper1","INFSuperInc","INFDeepInc","INFOrganInc")
	
	Set xmonth=monthf
	For {
		Quit:xmonth>montht
		Set aMonth=year_"-"_xmonth
		w aMonth,!
		For ind=1:1:$l(ListTarget) {
			Set tmpTarget=$list(ListTarget,ind)
			Set ret=##class(DHCHAI.STA.ECResult).ClearData(aMonth,"DataMonth",tmpTarget)
			w ret,!
		}
		w xmonth,!
		Set xmonth=xmonth+1
	}
	Quit "OK-D"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-13
/// Description:  处理数据
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetEChartsResult("2019-01-01","2019-08-31","DataMonth")
ClassMethod GetEChartsResult(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:aType="" return
	Set aFromDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aFromDate)
	Set aFromDate=$p(aFromDate,"^",1)
	Set aToDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aToDate)
	Set aToDate=$p(aToDate,"^",1)
	Quit:(aFromDate>aToDate) return
	Quit:(aFromDate="")||(aToDate="") return
	
	If (aType="DataMonth") {
		Set xDateFrom=aFromDate
		For {
			Set xDateTo=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(xDateFrom)
			Set xDateTo=$p(xDateTo,"^",2)
			//w xDateFrom_","_xDateTo,!
			
			Set ret01=..GetResult01(xDateFrom,xDateTo,aType) //同期各科室住院人数
			Set ret02=..GetResult02(xDateFrom,xDateTo,aType) //同期各科室感染例次数
			
			Set ret03=..GetNewResult03(xDateFrom,xDateTo,aType) //取三管使用日数(ICU日志中取)
			//Set ret03=..GetResult03(xDateFrom,xDateTo,aType) //取导尿管使用人数/感染人数
			//Set ret04=..GetResult04(xDateFrom,xDateTo,aType) //取中央静脉导管使用人数/感染人数
			//Set ret05=..GetResult05(xDateFrom,xDateTo,aType) //取呼吸机使用人数/感染人数
			//Set ret06=..GetResult06(xDateFrom,xDateTo,aType) //取三管使用日数
			Set ret07=..GetResult07(xDateFrom,xDateTo,aType) //取三管感染人数
			
			Set ret08=..GetResult08(xDateFrom,xDateTo,aType) //取手术部位例数、感染信息
			Set ret09=..GetResult09(xDateFrom,xDateTo,aType) //取多重耐药菌监控出的病例数
			
			//Set ret10=..GetResult10(xDateFrom,xDateTo,aType) //取检出菌查询出的病例数(停用)
			Set ret10=##class(DHCHAI.STAS.MRBDetectionSrv).SyncMRBDetection(xDateFrom,xDateTo,"1") //取多耐检出情况
			
			Set xDateFrom=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xDateFrom)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xDateFrom,aToDate)=0
		}
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	Set return="OK"
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-13
/// Description:  同期各科室住院人数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult01("2018-02-01","2018-02-28","DataMonth")
ClassMethod GetResult01(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set objTarget=##class(DHCHAI.STA.ECTarget).GetObjByCode("InHospCount")
	Quit:'$IsObject(objTarget) return
	Set TargetDr=objTarget.%Id()
	Set objBabyTarget=##class(DHCHAI.STA.ECTarget).GetObjByCode("BabyInHosp")
	Quit:'$IsObject(objBabyTarget) return
	Set BabyTargetDr=objBabyTarget.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	
	Set NIndex="GetResult01"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLoc(aFromDate,aToDate,"E","","I") //某段时间的在科人数
    For index=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index)
		Continue:TransInfo=""
		Set EpisodeID  = $LIST(TransInfo,1)
		Set TransLocDr = $LIST(TransInfo,2)
		Set TransID    = $LIST(TransInfo,3)
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(TransLocDr)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set LocID=objLoc.%Id()
		Set HospID=objLoc.BTHospDr.%Id()
		
		Set objPAAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(objPAAdm)
		Set IsNewBaby=objPAAdm.PAIsNewBaby //新生儿标志
		
		Continue:$d(^TMP($zn,$j,NIndex,HospID,LocID,EpisodeID))  //同科多次转入转出重复计算
		Set ^TMP($zn,$j,NIndex,HospID,LocID,EpisodeID)=""
		Set num=$i(^TMP($zn,$j,NIndex,HospID,LocID,"同期在科人数"))
		Set:IsNewBaby=1 num=$i(^TMP($zn,$j,NIndex,HospID,LocID,"新生儿在科人数"))
    }
    
    Set ListWardArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLoc(aFromDate,aToDate,"W","","I") //某段时间的在科人数
    For index=1:1:ListWardArray.Count() {
		Set TransInfo=ListWardArray.GetAt(index)
		Continue:TransInfo=""
		Set EpisodeID  = $LIST(TransInfo,1)
		Set TransWardDr = $LIST(TransInfo,2)
		Set TransID    = $LIST(TransInfo,3)
		
        Set objWard = ##class(DHCHAI.BT.Location).GetObjById(TransWardDr)
		Continue:'$IsObject(objWard)
		Continue:'$IsObject(objWard.BTHospDr)
		Set WardID=objWard.%Id()
		Set HospID=objWard.BTHospDr.%Id()
		
		Set objPAAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(objPAAdm)
		Set IsNewBaby=objPAAdm.PAIsNewBaby //新生儿标志
		
		Continue:$d(^TMP($zn,$j,NIndex,HospID,WardID,EpisodeID))  //同科多次转入转出重复计算
		Set ^TMP($zn,$j,NIndex,HospID,WardID,EpisodeID)=""
		Set num=$i(^TMP($zn,$j,NIndex,HospID,WardID,"同期在科人数"))
		Set:IsNewBaby=1 num=$i(^TMP($zn,$j,NIndex,HospID,WardID,"新生儿在科人数"))
    }
    Set xHospID=""
    For {
    	Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
    	Quit:xHospID=""
    	
    	Set xLocID=""
    	For {
    		Set xLocID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID))
    		Quit:xLocID=""
    		
    		Set Count=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,"同期在科人数"))
    		Set Inputs="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr_"^"_Count_"^"_Time_"^"_Year
    		Set:Count'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs,"^")
    		
    		Set BabyCount=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,"新生儿在科人数"))
    		Set Inputs="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_BabyTargetDr_"^"_BabyCount_"^"_Time_"^"_Year
    		Set:BabyCount'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs,"^")
    	}
    }
    Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-13
/// Description:  同期各科室感染例次数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult02("2018-02-01","2018-02-28","DataMonth")
ClassMethod GetResult02(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set objTarget=##class(DHCHAI.STA.ECTarget).GetObjByCode("HAICase")
	Quit:'$IsObject(objTarget) return
	Set TargetDr=objTarget.%Id()
	
	Set objBabyTarget=##class(DHCHAI.STA.ECTarget).GetObjByCode("BabyHAICase")
	Quit:'$IsObject(objBabyTarget) return
	Set BabyTargetDr=objBabyTarget.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	
	Set NIndex="GetResult02"
	Kill ^TMP($zn,$j,NIndex)
	
	For xDate=$zdh(aFromDate,3):1:$zdh(aToDate,3) {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xID))
			Quit:xID=""
			
			Set objDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(objDiagnos)
			Continue:'$IsObject(objDiagnos.IRInfLocDr)
			Set EpisodeID=objDiagnos.IREpisodeDr.%Id()
			Set InfLocDr=objDiagnos.IRInfLocDr.%Id()  // 感染科室
			
			Set objLoc=objDiagnos.IRInfLocDr
			Continue:'$IsObject(objLoc.BTHospDr)
			Set LocID=objLoc.%Id()
			Set HospID=objLoc.BTHospDr.%Id()
			
			Set IsNewBaby=objDiagnos.IREpisodeDr.PAIsNewBaby //新生儿标志
			
			Set arrRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xID)
			Continue:arrRep.Count()<1
			
			Continue:$d(^TMP($zn,$j,NIndex,HospID,LocID,EpisodeID))  //同科多个感染部位算一次
			Set ^TMP($zn,$j,NIndex,HospID,LocID,EpisodeID)=""
			Set num=$i(^TMP($zn,$j,NIndex,HospID,LocID,"同期感染例次数"))
			Set:IsNewBaby=1 num=$i(^TMP($zn,$j,NIndex,HospID,LocID,"新生儿感染例次数"))
		}
	}
    Set xHospID=""
    For {
    	Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
    	Quit:xHospID=""
    	
    	Set xLocID=""
    	For {
    		Set xLocID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID))
    		Quit:xLocID=""
    		
    		Set Count=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,"同期感染例次数"))
    		Set Inputs="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr_"^"_Count_"^"_Time_"^"_Year
    		Set:Count'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs,"^")
    		
    		Set BabyCount=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,"新生儿感染例次数"))
    		Set Inputs="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_BabyTargetDr_"^"_BabyCount_"^"_Time_"^"_Year
    		Set:BabyCount'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs,"^")
    	}
    }
    Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-13
/// Description:  取导尿管使用人数/感染人数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult03("2018-02-01","2018-02-28","DataMonth")
ClassMethod GetResult03(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFUC")
	Quit:'$IsObject(objTarget1) return
	Set TargetDr1=objTarget1.%Id()
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountUC")
	Quit:'$IsObject(objTarget2) return
	Set TargetDr2=objTarget2.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	
	Set NIndex="GetResult03"
	Kill ^TMP($zn,$j,NIndex)
	
	Set HospID=2
	Set xDate=$zdh(aFromDate,3)-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"UC","IndexRepDate",xDate))
		Quit:xDate=""
		Quit:xDate>$zdh(aToDate,3)
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"UC","IndexRepDate",xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"UC","IndexRepDate",xDate,RepID,SubID))
				Quit:SubID=""
				
				Set IsInfection=0
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportUC).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode'="2"
				}
				Set InfDate=objRepSub.InfDate	
				Set:InfDate'="" IsInfection=1
				
				Set num=$i(^TMP($zn,$j,NIndex,HospID,TransLoc,IsInfection))
			}
		}
	}
	
	
    
    Set xHospID=""
    For {
    	Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
    	Quit:xHospID=""
    	
    	Set xLocID=""
    	For {
    		Set xLocID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID))
    		Quit:xLocID=""
    		
    		Set Count0=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,0))
    		Set Count1=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,1))
    		Set Count2=Count0+Count1
    		
    		Set Inputs1="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr1_"^"_Count1_"^"_Time_"^"_Year
    		Set:Count1'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs1,"^")
    		Set Inputs2="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr2_"^"_Count2_"^"_Time_"^"_Year
    		Set:Count2'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs2,"^")
    	}
    }
    Quit "OK"
}

/// Creator：     mayanpeng
/// CreatDate：   2020-06-23
/// Description:  取三管使用日数(ICU日志中取)
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetNewResult03("2018-02-01","2018-02-28","DataMonth")
ClassMethod GetNewResult03(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set objTargetUC=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountUC")
	Quit:'$IsObject(objTargetUC) return
	Set TargetUCDr=objTargetUC.%Id()
	Set objTargetPICC=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountPICC")
	Quit:'$IsObject(objTargetPICC) return
	Set TargetPICCDr=objTargetPICC.%Id()
	Set objTargetVAP=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountVAP")
	Quit:'$IsObject(objTargetVAP) return
	Set TargetVAPDr=objTargetVAP.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	
	Set NIndex="GetNewResult03"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID))
		Quit:xLocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Set HospDr=objLoc.BTHospDr
		Continue:'$IsObject(HospDr)
		Set HospID=HospDr.%Id()
		
		Set CountDates=##class(DHCHAI.IRS.ICULogSrv).GetICUDates(xLocID,aFromDate,aToDate,"")
		Set VAPCount=$p(CountDates,"^",1)
		Set PICCCount=$p(CountDates,"^",2)
		Set UCCount=$p(CountDates,"^",3)
		
		Set InputUC="^"_HospID_"^"_xLocID_"^"_TypeDr_"^"_TargetUCDr_"^"_UCCount_"^"_Time_"^"_Year
    	Set:UCCount'=0 flg=##class(DHCHAI.STA.ECResult).Update(InputUC,"^")
    	
    	Set InputPICC="^"_HospID_"^"_xLocID_"^"_TypeDr_"^"_TargetPICCDr_"^"_PICCCount_"^"_Time_"^"_Year
    	Set:PICCCount'=0 flg=##class(DHCHAI.STA.ECResult).Update(InputPICC,"^")
    	
    	Set InputVAP="^"_HospID_"^"_xLocID_"^"_TypeDr_"^"_TargetVAPDr_"^"_VAPCount_"^"_Time_"^"_Year
    	Set:VAPCount'=0 flg=##class(DHCHAI.STA.ECResult).Update(InputVAP,"^")
	}
    Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-13
/// Description:  取中央静脉导管使用人数/感染人数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult04("2018-02-01","2018-02-28","DataMonth")
ClassMethod GetResult04(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFPICC")
	Quit:'$IsObject(objTarget1) return
	Set TargetDr1=objTarget1.%Id()
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountPICC")
	Quit:'$IsObject(objTarget2) return
	Set TargetDr2=objTarget2.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	
	Set NIndex="GetResult03"
	Kill ^TMP($zn,$j,NIndex)
	
	Set HospID=2
	Set xDate=$zdh(aFromDate,3)-1
	For {
		Set xDate=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepDate",xDate))
		Quit:xDate=""
		Quit:xDate>$zdh(aToDate,3)
		Set RepID=0
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepDate",xDate,RepID))
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINFi("AimRep",0,"PICC","IndexRepDate",xDate,RepID,SubID))
				Quit:SubID=""
				
				Set IsInfection=0
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode'="2"
				}
				Set InfDate=objRepSub.InfDate	
				Set:InfDate'="" IsInfection=1
				
				Set num=$i(^TMP($zn,$j,NIndex,HospID,TransLoc,IsInfection))
			}
		}
	}
	
	
    
    Set xHospID=""
    For {
    	Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
    	Quit:xHospID=""
    	
    	Set xLocID=""
    	For {
    		Set xLocID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID))
    		Quit:xLocID=""
    		
    		Set Count0=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,0))
    		Set Count1=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,1))
    		Set Count2=Count0+Count1
    		
    		Set Inputs1="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr1_"^"_Count1_"^"_Time_"^"_Year
    		Set:Count1'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs1,"^")
    		Set Inputs2="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr2_"^"_Count2_"^"_Time_"^"_Year
    		Set:Count2'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs2,"^")
    	}
    }
    Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-13
/// Description:  取呼吸机使用人数/感染人数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult05("2020-04-01","2020-04-30","DataMonth")
ClassMethod GetResult05(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFVAP")
	Quit:'$IsObject(objTarget1) return
	Set TargetDr1=objTarget1.%Id()
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountVAP")
	Quit:'$IsObject(objTarget2) return
	Set TargetDr2=objTarget2.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	
	Set NIndex="GetResult03"
	Kill ^TMP($zn,$j,NIndex)
	
	Set HospID=2
	Set xDate=$zdh(aFromDate,3)-1
	For {
		Set xDate=$o(^DHCHAI.IR.INFICUVAPI("IndexIRInfDate",xDate))
		
		Quit:xDate=""
		Quit:xDate>$zdh(aToDate,3)
		Set RepID=0
		For {
			Set RepID=$o(^DHCHAI.IR.INFICUVAPI("IndexIRInfDate",xDate,RepID))
			//^DHCHAI.IR.INFICUVAPI("IndexIRInfDate",65485,1)
			Quit:RepID=""
			
			Set objRep=##class(DHCHAI.IR.INFICUVAP).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set IRLocDr=objRep.IRLocDr.%Id()
			set IRInfDate=objRep.IRInfDate
			set IsInfection=0
			Set:IRInfDate'="" IsInfection=1
			Set num=$i(^TMP($zn,$j,NIndex,HospID,IRLocDr,IsInfection))
			}
		
	}
	
    
    Set xHospID=""
    For {
    	Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
    	Quit:xHospID=""
    	
    	Set xLocID=""
    	For {
    		Set xLocID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID))
    		Quit:xLocID=""
    		
    		Set Count0=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,0))
    		Set Count1=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,1))
    		Set Count2=Count0+Count1
    		
    		Set Inputs1="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr1_"^"_Count1_"^"_Time_"^"_Year
    		Set:Count1'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs1,"^")
    		Set Inputs2="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr2_"^"_Count2_"^"_Time_"^"_Year
    		Set:Count2'=0 flg=##class(DHCHAI.STA.ECResult).Update(Inputs2,"^")
    	}
    }
    Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-07-30
/// Description:  取三管使用日数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult06("2018-02-01","2018-02-28","DataMonth")
ClassMethod GetResult06(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountUC")
	Quit:'$IsObject(objTarget1) return
	Set TargetDr1=objTarget1.%Id()
	
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountPICC")
	Quit:'$IsObject(objTarget2) return
	Set TargetDr2=objTarget2.%Id()
	
	Set objTarget3=##class(DHCHAI.STA.ECTarget).GetObjByCode("CountVAP")
	Quit:'$IsObject(objTarget3) return
	Set TargetDr3=objTarget3.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	Set ZIndex=$zn,JIndex=$j,NIndex="GetResult06"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//三管信息
	Set ListType=$lb("UC","PICC","VAP")
	For xind=1:1:3 {
		Set xType=$list(ListType,xind)
		Set xDate=$zdh(aFromDate,3)-1
		For {
			Set xDate=$o(^DHCMed.NINFi("AimRep",0,xType,"IndexIntubateDate",xDate))
			Quit:xDate=""
			Quit:xDate>$zdh(aToDate,3)
			
			Set xRepID=0
			For {
				Set xRepID=$o(^DHCMed.NINFi("AimRep",0,xType,"IndexIntubateDate",xDate,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Set TransLoc=objRep.TransLoc
				Set EpisodeID=objRep.EpisodeID
				Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)
				Set SubID=0
				For {
					Set SubID=$o(^DHCMed.NINFi("AimRep",0,xType,"IndexIntubateDate",xDate,xRepID,SubID))
					Quit:SubID=""
					
					Set ReportID=xRepID_"||"_SubID
					Set:xType="UC" objRepSub=##class(DHCMed.NINF.Rep.AimReportUC).GetObjById(ReportID)
					Set:xType="PICC" objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(ReportID)
					Set:xType="VAP" objRepSub=##class(DHCMed.NINF.Rep.AimReportVAP).GetObjById(ReportID)
					Continue:'$IsObject(objRepSub)
					
					Set objRepStatus=objRepSub.RepStatus
					If $IsObject(objRepStatus) {
						Set RepStatusCode=objRepStatus.Code
						Continue:RepStatusCode'="2"  //提交的报告
					}
					
					Set IntubateDate=objRepSub.IntubateDate
					Set ExtubateDate=objRepSub.ExtubateDate
					If ExtubateDate="" 
					{
						If DischDate'="" 
						{
							Set ExtubateDate=DischDate
						} Else 
						{
							Set ExtubateDate=+$h
						}
					}
					
					Set:ExtubateDate>$zdh(aToDate,3) ExtubateDate=$zdh(aToDate,3)
					For xIntuDate=IntubateDate:1:ExtubateDate
					{
						If '$d(^TMP(ZIndex,JIndex,NIndex,TransLoc,xType_"Days",EpisodeID,xIntuDate))
						{
							Set num=$i(^TMP(ZIndex,JIndex,NIndex,TransLoc,xType_"Days"))   //插管日数
							Set ^TMP(ZIndex,JIndex,NIndex,TransLoc,xType_"Days",EpisodeID,xIntuDate)=""
						}
					}
				}
				//手术部位
				/*Set SubID=0
				For 
				{
					Set SubID=$o(^DHCMed.NINF("AimRep",xRepID,"OPR",SubID))
					Quit:SubID=""
					Set AimRepSubID=xRepID_"||"_SubID
					Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(AimRepSubID)
					Continue:'$IsObject(objAimRepSub)
					Set objRepStatus=objAimRepSub.RepStatus
					If $IsObject(objRepStatus) 
					{
						Set RepStatusCode=objRepStatus.Code
						Continue:RepStatusCode'="2"  //提交的报告
					}
		
					Set OperDate=objAimRepSub.OperStartDate
					Continue:OperDate=""
					If (OperDate>=$zdh(aFromDate,3))&&(OperDate<=$zdh(aToDate,3))
					{
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,TransLoc,"OPRNum"))  //手术例数
						Set ^TMP(ZIndex,JIndex,NIndex,TransLoc,"OPRNum",EpisodeID)=""
					}
					
				}*/
			}
		}
	}
		
	Set xHospID=2
	Set xLocID=0
	For 
	{
		Set xLocID=$o(^TMP(ZIndex,JIndex,NIndex,xLocID))
		Quit:xLocID=""
		
		
		//xLocID是HIS系统中病区的ID，现转成院感系统的科室ID
		Set objNewLoc=##class(DHCHAI.BT.Location).GetObjByXCode("HIS01",xLocID)
		Continue:'$IsObject(objNewLoc)
		Set NewLocID=objNewLoc.%Id()	//对应的院感中的病区ID
		Set LocIDList=##class(DHCHAI.BT.LocationLink).GetLocLinks(NewLocID)	//关联的科室ID列表
		Set NLocID=$p(LocIDList,"|",1)	//若有多个，取第一个
		
		Set LocDesc=$p($g(^CTLOC(+xLocID)),"^",2) //HIS系统中病区描述
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Set NLocDesc=##class(DHCHAI.BT.Location).GetObjById(NLocID).BTDesc
		
		//w NLocID_"^"_NLocDesc,!
		Set UCDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"UCDays"))
		Set PICCDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"PICCDays"))
		Set VAPDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"VAPDays"))
		//Set OPRNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRNum"))
		Set ret=##class(DHCMed.NINFService.Rep.AimICUInfoSrv).GetInPatNums($e(aFromDate,1,7),$e(aToDate,1,7),xLocID)
			
		//Set:$p(ret,"^",1)'=0 IPDays=$p(ret,"^",1)
		Set:$p(ret,"^",2)'=0 UCDays=$p(ret,"^",2)
		Set:$p(ret,"^",3)'=0 PICCDays=$p(ret,"^",3)
		Set:$p(ret,"^",4)'=0 VAPDays=$p(ret,"^",4)
		//Set:$p(ret,"^",5)'=0 OPRNum=$p(ret,"^",5)
			
		//w UCDays_"^"_PICCDays_"^"_VAPDays,!
		Set Inputs1="^"_xHospID_"^"_NLocID_"^"_TypeDr_"^"_TargetDr1_"^"_UCDays_"^"_Time_"^"_Year
		Set:UCDays'=0 flg1=##class(DHCHAI.STA.ECResult).Update(Inputs1,"^")
		Set Inputs2="^"_xHospID_"^"_NLocID_"^"_TypeDr_"^"_TargetDr2_"^"_PICCDays_"^"_Time_"^"_Year
		Set:PICCDays'=0 flg2=##class(DHCHAI.STA.ECResult).Update(Inputs2,"^")
		Set Inputs3="^"_xHospID_"^"_NLocID_"^"_TypeDr_"^"_TargetDr3_"^"_VAPDays_"^"_Time_"^"_Year
		Set:VAPDays'=0 flg3=##class(DHCHAI.STA.ECResult).Update(Inputs3,"^")
		
	}
	Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-07-30
/// Description:  取三管感染人数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult07("2018-06-01","2020-06-30","DataMonth")
ClassMethod GetResult07(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFUC")
	Quit:'$IsObject(objTarget1) return
	Set TargetDr1=objTarget1.%Id()
	
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFPICC")
	Quit:'$IsObject(objTarget2) return
	Set TargetDr2=objTarget2.%Id()
	
	Set objTarget3=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFVAP")
	Quit:'$IsObject(objTarget3) return
	Set TargetDr3=objTarget3.%Id()
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	Set ZIndex=$zn,JIndex=$j,NIndex="GetResult07"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	Set xDate=$zdh(aFromDate,3)-1
	For {
		Set xDate=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate))
		Quit:xDate=""
		Quit:xDate>$zdh(aToDate,3)
		
		Set xDiaID=0
		For {
			Set xDiaID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xDiaID))
			Quit:xDiaID=""
			
			Set objDia=##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiaID)
			Continue:'$Isobject(objDia)
			Set EpisodeDr=objDia.IREpisodeDr
			Continue:'$Isobject(EpisodeDr)
			Set EpisodeID=EpisodeDr.%Id()
			//Continue:'$Isobject(objDia.IRInfLocDr)	//感染科室采用转科表中感染当天所在的病区
			Continue:'$Isobject(objDia.IRInfSubDr)
			
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,xDate,"")
			Set TransWardID=$p(TransInfo,"^",2)
			Continue:TransWardID=""
			
			Set LocID=TransWardID
			Set SubCode=objDia.IRInfSubDr.BTCode
			If (SubCode["CAUTI") {
				Continue:$d(^TMP(ZIndex,JIndex,NIndex,LocID,"AdmUC",EpisodeID))
				Set ^TMP(ZIndex,JIndex,NIndex,LocID,"AdmUC",EpisodeID)=""
				
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,LocID,"UC"))
			} ElseIf (SubCode["CRBSI") {
				Continue:$d(^TMP(ZIndex,JIndex,NIndex,LocID,"AdmPICC",EpisodeID))
				Set ^TMP(ZIndex,JIndex,NIndex,LocID,"AdmPICC",EpisodeID)=""
				
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,LocID,"PICC"))
			} ElseIf (SubCode["VAP") {
				Continue:$d(^TMP(ZIndex,JIndex,NIndex,LocID,"AdmVAP",EpisodeID))
				Set ^TMP(ZIndex,JIndex,NIndex,LocID,"AdmVAP",EpisodeID)=""
				
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,LocID,"VAP"))
			}
		}
	}
	
	Set xLocID=0
	For 
	{
		Set xLocID=$o(^TMP(ZIndex,JIndex,NIndex,xLocID))
		Quit:xLocID=""
		
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set xHospID=objLoc.BTHospDr.%Id()
		
		//w xLocID_"^"_LocDesc,!
		Set UCDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"UC"))
		Set PICCDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"PICC"))
		Set VAPDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"VAP"))
		//w LocDesc_"^"_UCDays_"^"_PICCDays_"^"_VAPDays,!
		Set Inputs1="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr1_"^"_UCDays_"^"_Time_"^"_Year
		Set:UCDays'=0 flg1=##class(DHCHAI.STA.ECResult).Update(Inputs1,"^")
		Set Inputs2="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr2_"^"_PICCDays_"^"_Time_"^"_Year
		Set:PICCDays'=0 flg2=##class(DHCHAI.STA.ECResult).Update(Inputs2,"^")
		Set Inputs3="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr3_"^"_VAPDays_"^"_Time_"^"_Year
		Set:VAPDays'=0 flg3=##class(DHCHAI.STA.ECResult).Update(Inputs3,"^")
		
	}
	Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-21
/// Description:  取手术部位例数、感染信息
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult08("2018-02-01","2018-02-28","DataMonth")
ClassMethod GetResult08(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	Set objTarget1=##class(DHCHAI.STA.ECTarget).GetObjByCode("OperCount")
	Quit:'$IsObject(objTarget1) return
	Set TargetDr1=objTarget1.%Id()
	Set objTarget2=##class(DHCHAI.STA.ECTarget).GetObjByCode("Oper1Count")
	Quit:'$IsObject(objTarget2) return
	Set TargetDr2=objTarget2.%Id()
	Set objTarget3=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFOper")
	Quit:'$IsObject(objTarget3) return
	Set TargetDr3=objTarget3.%Id()
	Set objTarget4=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFOper1")
	Quit:'$IsObject(objTarget4) return
	Set TargetDr4=objTarget4.%Id()
	
	Set objTarget5=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFSuperInc")
	Quit:'$IsObject(objTarget5) return
	Set TargetDr5=objTarget5.%Id()
	Set objTarget6=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFDeepInc")
	Quit:'$IsObject(objTarget6) return
	Set TargetDr6=objTarget6.%Id()
	Set objTarget7=##class(DHCHAI.STA.ECTarget).GetObjByCode("INFOrganInc")
	Quit:'$IsObject(objTarget7) return
	Set TargetDr7=objTarget7.%Id()
	
	Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	Set ZIndex=$zn,JIndex=$j,NIndex="GetResult08"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
	Set xDate=$zdh(aFromDate,3)-1
	For {
		Set xDate=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate))
		Quit:xDate=""
		Quit:xDate>$zdh(aToDate,3)
		
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 	Continue:'$IsObject(obj.OREpisodeDr)
				 	Set SCode      = obj.ORSCode            // 子系统代码
				 	Set EpisodeDr  = obj.OREpisodeDr.%Id()
				 	Set OperDate   = obj.OROperDate         // 手术开始日期
				 	Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
					Set SttTime    = obj.ORSttTime          // 手术开始时间
				 	
				 	Set AdmInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,SttTime)
				 	Set CurrLocID = $p(AdmInfo,"^",1)
				 	Set CurrWardID = $p(AdmInfo,"^",2)
				 	
			 		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(CurrLocID)
			 		Continue:'$IsObject(objLoc)
			 		Continue:'$IsObject(objLoc.BTHospDr)
			 		Set HospID=objLoc.BTHospDr.%Id()
			 		
			 		Set CRuleOperLoc=CurrLocID
			 		Set:CRuleOperLoc="" CRuleOperLoc=CurrWardID
			 		Set objRuleLoc=##class(DHCHAI.BT.Location).GetObjById(CRuleOperLoc)
			 		Continue:'$IsObject(objRuleLoc)
				 	
				 	Set OperStatus = obj.OROperStatus         // 手术状态
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:OperStatus'="F"    // 过滤手术状态
				 	Continue:ExclStatus[OperStatus  //20211012 根据配置过滤手术状态
				 	Set Incision  = obj.ORIncision         // 切口等级
				 	Set IsOperInf=0
				 	
				 	Set num=$i(^TMP(ZIndex,JIndex,NIndex,CurrLocID,"OperCount"))
				 	Set:Incision="I" num=$i(^TMP(ZIndex,JIndex,NIndex,CurrLocID,"Oper1Count"))
				 	
				}
			}
		}
	}
	
	Set RepList="",PatList=""
	Set xDate=$zdh(aFromDate,3)-1
	For {
		Set xDate=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate))
		Quit:xDate=""
		Quit:xDate>$zdh(aToDate,3)
		
		Set xDiaID=0
		For {
			Set xDiaID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xDiaID))
			Quit:xDiaID=""
			
			Set objDia=##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiaID)
			Continue:'$Isobject(objDia)
			Continue:'$Isobject(objDia.IREpisodeDr)
			Continue:'$Isobject(objDia.IRInfLocDr)
			
			Set xEpisodeID=objDia.IREpisodeDr.%Id()
			Set InfLocID=objDia.IRInfLocDr.%Id()
			Set DiagCode=objDia.IRInfPosDr.BTCode
			Set SubCode=""
			Set:$IsObject(objDia.IRInfSubDr) SubCode=objDia.IRInfSubDr.BTCode
			
			Set ReportID = $o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xDiaID,""))
			Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
			Continue:'$IsObject(objRep)
			
			Set (StatusCode,StatusDesc)=""
			If $IsObject(objRep.IRStatusDr) {
				Set StatusCode = objRep.IRStatusDr.BTCode
				Set StatusDesc = objRep.IRStatusDr.BTDesc
			}
			//Continue:StatusCode'=3  // 过滤非审核状态的报告
			Continue:(StatusCode=4)||(StatusDesc="删除")  // 过滤删除状态的报告
			
			Continue:$listfind(RepList,ReportID)>0
			Set RepList=RepList_$lb(ReportID)
			//手术相关
			//w:ReportID=632 InfLocID_"^"_SubCode,!
			Set:($e(DiagCode,1,2)="07")||(SubCode="0402") num=$i(^TMP(ZIndex,JIndex,NIndex,InfLocID,"INFOper"))
			Set:$e(DiagCode,1,2)="07" num=$i(^TMP(ZIndex,JIndex,NIndex,InfLocID,DiagCode))
			Set:SubCode="0402" num=$i(^TMP(ZIndex,JIndex,NIndex,InfLocID,"0703"))
			
			If (($e(DiagCode,1,2)="07")||(SubCode="0402")) {
				Set xOperID=""
				For {
					Set xOperID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",xEpisodeID,xOperID))
					Quit:xOperID=""
					//Continue:$listfind(PatList,xEpisodeID)>0
					Set objOper=##class(DHCHAI.DP.OROperAnaes).GetObjById(xOperID)
					Continue:'$IsObject(objOper)
					Continue:'objOper.ORIsActive
					Set Incision=objOper.ORIncision
					Set:Incision="I" num=$i(^TMP(ZIndex,JIndex,NIndex,InfLocID,"INFOper1"))
					Set PatList=PatList_$lb(xEpisodeID)
				}
			}
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP(ZIndex,JIndex,NIndex,xLocID))
		Quit:xLocID=""
		Set xobjLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Set xHospID=xobjLoc.BTHospDr.%Id()
		
		Set OperCount=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"OperCount"))
		Set INFOper=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"INFOper"))
		Set Oper1Count=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"Oper1Count"))
		Set INFOper1=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"INFOper1"))
		//w:xLocID=591 OperCount_"^"_INFOper_"^"_Oper1Count_"^"_INFOper1,!
		Set Inputs1="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr1_"^"_OperCount_"^"_Time_"^"_Year
		Set:OperCount'=0 flg1=##class(DHCHAI.STA.ECResult).Update(Inputs1,"^")
		Set Inputs2="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr2_"^"_Oper1Count_"^"_Time_"^"_Year
		Set:Oper1Count'=0 flg2=##class(DHCHAI.STA.ECResult).Update(Inputs2,"^")
		Set Inputs3="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr3_"^"_INFOper_"^"_Time_"^"_Year
		Set:INFOper'=0 flg3=##class(DHCHAI.STA.ECResult).Update(Inputs3,"^")
		Set Inputs4="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr4_"^"_INFOper1_"^"_Time_"^"_Year
		Set:INFOper1'=0 flg4=##class(DHCHAI.STA.ECResult).Update(Inputs4,"^")
		
		Set INFSuperInc=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"0701"))
		Set INFDeepInc=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"0702"))
		Set INFOrganInc=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,"0703"))
		
		Set Inputs5="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr5_"^"_INFSuperInc_"^"_Time_"^"_Year
		Set:INFSuperInc'=0 flg5=##class(DHCHAI.STA.ECResult).Update(Inputs5,"^")
		Set Inputs6="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr6_"^"_INFDeepInc_"^"_Time_"^"_Year
		Set:INFDeepInc'=0 flg6=##class(DHCHAI.STA.ECResult).Update(Inputs6,"^")
		Set Inputs7="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr7_"^"_INFOrganInc_"^"_Time_"^"_Year
		Set:INFOrganInc'=0 flg7=##class(DHCHAI.STA.ECResult).Update(Inputs7,"^")
		
	}
	Quit "OK"
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-12
/// Description:  取多重耐药菌监控出的病例数
/// Table：       DHCHAI.STA.ECResult
/// w ##class(DHCHAI.STAS.ResultSrv).GetResult09("2018-01-01","2018-01-31","DataMonth")
ClassMethod GetResult09(aFromDate As %String, aToDate As %String, aType As %String) As %String
{
	New (aFromDate,aToDate,aType)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aType="") return
	Set aFromDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aFromDate)
	Set aFromDate=$p(aFromDate,"^",1)
	Set aToDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aToDate)
	Set aToDate=$p(aToDate,"^",2)
	Quit:(aFromDate>aToDate) return
	Quit:(aFromDate="")||(aToDate="") return
	
	If (aType="DataMonth") {
		Set Time=$zdh(aFromDate,3)
		Set Year=$e(aFromDate,1,4)
	} ElseIf (aType="DataSeason") {
	} ElseIf (aType="DataYear") {
	}
	
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	Set objTarget=##class(DHCHAI.STA.ECTarget).GetObjByCode("MRBAdmCount")
	Quit:'$IsObject(objTarget) return
	Set TargetDr=objTarget.%Id()
	
	Set NIndex="MRBAdmCount"
	Kill ^TMP($zn,$j,NIndex)
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.CtlMRBSrv:QryMRBMonitor")
  	Set sc=rs.Execute("","2",aFromDate,aToDate,"","","","")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	While (rs.Next()){
		Set xEpisodeID=rs.Data("EpisodeID")
		Continue:xEpisodeID=""
		Set xLocID=rs.Data("LocID")
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set xHospID=objLoc.BTHospDr.%Id()
		
		Set num=$i(^TMP($zn,$j,NIndex,xHospID,xLocID,"检出多耐患者人数"))
	}
	Do rs.Close()
	Set flg=0
	Set xHospID=""
    For {
    	Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
    	Quit:xHospID=""
    	
    	Set xLocID=""
    	For {
    		Set xLocID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID))
    		Quit:xLocID=""
    		
    		Set Count=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,"检出多耐患者人数"))
    		Continue:Count=0
    		Set Inputs="^"_xHospID_"^"_xLocID_"^"_TypeDr_"^"_TargetDr_"^"_Count_"^"_Time_"^"_Year
    		Set flg=##class(DHCHAI.STA.ECResult).Update(Inputs,"^")
    	}
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit flg
}

}

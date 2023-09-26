/// ClassName:    DHCHAI.IO.ToDtPortal05
///               替换类DtPortal.CEO.CEO08HospitalInfection
/// Description:  院内感染发生率服务
/// Creator：     zhufei
/// CreatDate:    2018-03-21
Class DHCHAI.IO.ToDtPortal05 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description	:	CEO08.06.00 通过月份查询院内感染发生率
/// Input		:	Month（YYYY-MM）
/// Return		:	院内感染发生率
/// w ##class(DHCHAI.IO.ToDtPortal05).CEO080600("2018-03")
ClassMethod CEO080600(Month As %String) As DtPortal.OutPut
{
	New (Month)
	#Dim ret As DtPortal.OutPut
	Set ret=##class(DtPortal.OutPut).%New()
	
	Set $zt="ErrCEO080600"
	TStart
	
	Set Year=$p(Month,"-",1)
	Set Month=$p(Month,"-",2)
	Set StartDate=$zdh(Year_"-"_Month_"-01",3)
	Set EndYear=Year
	Set EndMonth=Month+1
	If (EndMonth=13 )
	{
		Set EndMonth=1
		Set EndYear=+Year+1
	}
	Set EndDate=$zdh(EndYear_"-"_EndMonth_"-"_"01",3)-1
	
	Set InPatNum=0,InfPatNum=0,InfRatio=0
	//同期在院天数
	Set AdmList=""
	Set StartDate = $zd(StartDate,3)
	Set EndDate = $zd(EndDate,3)
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(StartDate,EndDate,"","","I")

	For index=1:1:ListArray.Count() {
		Set EpisodeID=ListArray.GetAt(index)
		Continue:EpisodeID=""
		Continue:$listfind(AdmList,EpisodeID)>0
		Set AdmList=AdmList_$lb(EpisodeID)
		Set InPatNum=InPatNum+1
		
		Set xInfID=""
	    Set xInfPosList ="" //记录部位及时间,相同的使用最新的
	    Set InfCount = 0  //感染例次数
		For {			
	 		Set xInfID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",EpisodeID,xInfID),-1)
			Quit:xInfID=""
			
			Set objInf = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfID)
			Set IRInfDate = objInf.IRInfDate
			Continue:'$IsObject(objInf.IRInfPosDr)
			
			Set IRInfPosDr = objInf.IRInfPosDr.%Id()
			Set IRInfPosDrDesc =objInf.IRInfPosDr.BTDesc
			Continue:xInfPosList[","_(IRInfPosDrDesc_"-"_IRInfDate)  //重复控制
			Set xInfPosList = xInfPosList_","_(IRInfPosDrDesc_"-"_IRInfDate)	    	    	
	    	Set InfCount =InfCount+1 //例次加1
		}
		Set:InfCount>0 InfPatNum=InfPatNum+1
	}
	
	If InfPatNum=0 {
		Set InfRatio=0
	}else{
		Set InfRatio=$fn((InfPatNum/InPatNum)*100,"",2)
	}
		
	TCommit
	Set ret.status=1
	Set ret.errMSG=""
	Set ret.data=InfRatio
	Quit ret
	
ErrCEO080600
	TRollBack
	Set ret.status=-1
	Set ret.errMSG=$ZE
	Set ret.data="Null"
	Quit ret
}

/// Description	:	CEO08.06.01 通过年份查询院内感染发生率
/// Input		:	年份
/// Return		:	月份代号:月份名称:院内感染发生率
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IO.ToDtPortal05","CEO080601","2018")
Query CEO080601(Year As %String) As DtPortal.Query(ROWSPEC = "MonthCode:%String,MonthDesc:%String,InfRatio:%String")
{
}

ClassMethod CEO080601Execute(ByRef qHandle As %Binary, Year As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Set MouthIndex=12
	Set NowDate=$zd($p($h,",",1),3)
	Set NowYear=$p(NowDate,"-",1)
	Set NowMonth=$p(NowDate,"-",2)
	set:Year=NowYear MouthIndex=NowMonth
	For indMonth=1:1:MouthIndex
	{
		Set StartDate=$zdh(Year_"-"_indMonth_"-01",3)
		Set EndYear=Year
		Set EndMonth=indMonth+1
		If (EndMonth=13)
		{
			Set EndMonth=1
			Set EndYear=+Year+1
		}
		Set EndDate=$zdh(EndYear_"-"_EndMonth_"-"_"01",3)-1
		
		Set AdmList="",InPatNum=0,InfPatNum=0,InfRatio=0
		//同期在院天数
		Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(StartDate,EndDate,"","","I")
		For index=1:1:ListArray.Count() {
			Set EpisodeID=ListArray.GetAt(index)	
			Continue:EpisodeID=""
			Continue:$listfind(AdmList,EpisodeID)>0
			Set AdmList=AdmList_$lb(EpisodeID)
			Set InPatNum=InPatNum+1
			
			Set xInfID=""
		    Set xInfPosList ="" //记录部位及时间,相同的使用最新的
		    Set InfCount = 0  //感染例次数
			For {			
		 		Set xInfID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",EpisodeID,xInfID),-1)
				Quit:xInfID=""
				
				Set objInf = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfID)
				Set IRInfDate = objInf.IRInfDate
				Continue:'$IsObject(objInf.IRInfPosDr)
				
				Set IRInfPosDr = objInf.IRInfPosDr.%Id()
				Set IRInfPosDrDesc =objInf.IRInfPosDr.BTDesc
				Continue:xInfPosList[","_(IRInfPosDrDesc_"-"_IRInfDate)  //重复控制
				Set xInfPosList = xInfPosList_","_(IRInfPosDrDesc_"-"_IRInfDate)	    	    	
		    	Set InfCount =InfCount+1 //例次加1
			}
			Set:InfCount>0 InfPatNum=InfPatNum+1
		}		

		If InfPatNum=0 {
			Set InfRatio=0
		} else {
			Set InfRatio=$fn((InfPatNum/InPatNum)*100,"",2)
		}
		
		Set MonthCode=$s($l(indMonth)>1:indMonth,1:("0"_indMonth))
		Set MonthDesc=Year_"-"_MonthCode
		
		Set Data=$lb(indMonth,MonthDesc,InfRatio)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
		
	Quit $$$OK
}

/// Description	:	CEO08.06.02 通过月份查询各个病区院内感染发生数量
/// Input		:	Month (YYYY-MM)
/// Return		:	病区ID:病区名称:感染人数
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IO.ToDtPortal05","CEO080602","2018-03")
Query CEO080602(Month As %String) As DtPortal.Query(ROWSPEC = "WardID:%String,WardDesc:%String,InfPatNum:%String")
{
}

ClassMethod CEO080602Execute(ByRef qHandle As %Binary, Month As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill ^CacheTemp($zn,$j,"CEO080602")
	
	Set Year=$p(Month,"-",1)
	Set Month=$p(Month,"-",2)
	Set StartDate=$zdh(Year_"-"_Month_"-01",3)
	Set EndYear=Year
	Set EndMonth=Month+1
	If EndMonth=13
	{
		Set EndMonth=1
		Set EndYear=+Year+1
	}
	Set EndDate=$zdh(EndYear_"-"_EndMonth_"-"_"01",3)-1
	
	//同期在院天数
	Set AdmList=""
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(StartDate,EndDate,"","","I")
	For index=1:1:ListArray.Count() {
		Set EpisodeID=ListArray.GetAt(index)	
		Continue:EpisodeID=""
		Continue:$listfind(AdmList,EpisodeID)>0
		Set AdmList=AdmList_$lb(EpisodeID)
		
		Set xInfID=""
	    Set xInfPosList ="" //记录部位及时间,相同的使用最新的
	    Set InfCount = 0  //感染例次数
		For {			
	 		Set xInfID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",EpisodeID,xInfID),-1)
			Quit:xInfID=""
			
			Set objInf = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfID)
			Set IRInfDate = objInf.IRInfDate
			Continue:'$IsObject(objInf.IRInfPosDr)
			
			Set IRInfPosDr = objInf.IRInfPosDr.%Id()
			Set IRInfPosDrDesc =objInf.IRInfPosDr.BTDesc
			Continue:xInfPosList[","_(IRInfPosDrDesc_"-"_IRInfDate)  //重复控制
			Set xInfPosList = xInfPosList_","_(IRInfPosDrDesc_"-"_IRInfDate)	    	    	
	    	Set InfCount =InfCount+1 //例次加1
		}
		Continue:InfCount=0
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(objAdm)
		Set AdmWardDr=objAdm.PAAdmWardDr.%Id()
		Set WardDesc=objAdm.PAAdmWardDr.BTDesc
		Set num=$i(^CacheTemp($zn,$j,"CEO080602",AdmWardDr,WardDesc))
	}
	
	Set WardID=""
	For {
		Set WardID=$o(^CacheTemp($zn,$j,"CEO080602",WardID))
		Quit:(WardID="")
		Set WardDesc=$o(^CacheTemp($zn,$j,"CEO080602",WardID,""))
		Set InfPatNum=$g(^CacheTemp($zn,$j,"CEO080602",WardID,WardDesc))
		Set ^||CacheTemp(repid,ind)=$lb(WardID,WardDesc,InfPatNum)
		Set ind=ind+1
	}
	
	Kill ^CacheTemp($zn,$j,"CEO080602")
	Quit $$$OK
}

}

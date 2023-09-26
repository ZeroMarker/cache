/// 名称: DHCHAI.STAS.MRBDetectionSrv
/// 描述: 多重耐药菌检出情况统计服务
/// 编写者: mayanpeng
/// 编写日期: 2018-09-27
Class DHCHAI.STAS.MRBDetectionSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2018-09-27
/// Description:  同步多重耐药菌检出情况
/// Table：       DHCHAI.STA.MRBDetection
/// Input：       aDateFrom,aDateTo报告日期,aType:1月数据,2季度数据,3年数据
/// Return：      返回ok
/// w ##class(DHCHAI.STAS.MRBDetectionSrv).SyncMRBDetection("2018-09-01","2018-09-30","1")
ClassMethod SyncMRBDetection(aDateFrom As %String, aDateTo As %String, aType As %String) As %String
{
	New (aDateFrom,aDateTo,aType)
	Set return=""
	Set aDateFrom=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateFrom,1)
	Set aDateFrom=$p(aDateFrom,"^",1)
	Set aDateTo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateTo,1)
	Set aDateTo=$p(aDateTo,"^",2)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:($ListFind($lb(1,2,3),+aType)<1) return
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.CtlMRBSrv:QryBactResult")
  	Set sc=rs.Execute("","2",aDateFrom,aDateTo,"","","","","")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	Set NIndex="MRBDetection"
  	Kill ^TMP($zn,$j,NIndex)
	While (rs.Next()){
		Set xAdmID=rs.Data("AdmID")
		Continue:xAdmID=""
		Set BactID=rs.Data("BacID")
		Set BactCode=rs.Data("BacCode")
		Set BactDesc=rs.Data("BacDesc")
		Continue:BactID=""
		Set MRBBactID=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BactID,"")) //多耐规则是否维护该细菌
		Continue:MRBBactID=""
		Set ActDate=rs.Data("ActDate")
		Set xLocID=rs.Data("LocID")	//发生科室
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		
		Set xMonth=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(ActDate,1)
		Set xMonth=$p(xMonth,"^",1)
		Continue:xMonth=""
		Set num=$i(^TMP($zn,$j,NIndex,xLocID,xMonth,aType,"Bacteria",BactID))
		
		Set MRBID=rs.Data("MRBID")
		Continue:MRBID=""
		Set MRBID2=rs.Data("MRBID2")
		
		Set MRBRule=..GetMRBRule("",MRBID) //过滤没维护多耐归类规则
		Continue:MRBRule=""
		Set num=$i(^TMP($zn,$j,NIndex,xLocID,xMonth,aType,"MRB",MRBID))
		
		Continue:MRBID2=""
		Continue:MRBID=MRBID2
		Set MRBRule2=..GetMRBRule("",MRBID2) //过滤没维护多耐归类规则
		Continue:MRBRule2=""
		Set num=$i(^TMP($zn,$j,NIndex,xLocID,xMonth,aType,"MRB",MRBID2))
		
	}
	Do rs.Close()
	//存储
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,xLocID))
		Quit:xLocID=""
		
		Set xMonth=""
		For {
			Set xMonth=$o(^TMP($zn,$j,NIndex,xLocID,xMonth))
			Quit:xMonth=""
			//病原体
			Set BacteriaID="",BactCount=0
			For {
				Set BacteriaID=$o(^TMP($zn,$j,NIndex,xLocID,xMonth,aType,"Bacteria",BacteriaID))
				Quit:BacteriaID=""
				
				Set BactCount=+$g(^TMP($zn,$j,NIndex,xLocID,xMonth,aType,"Bacteria",BacteriaID))
				Continue:BactCount=0
				Set InputStr="^"_xLocID_"^"_xMonth_"^"_BacteriaID_"^"_aType_"^0^"_BactCount_"^^"
				Set flg=##class(DHCHAI.STA.MRBDetection).Update(InputStr,"^")
			}
			//多重耐药菌
			Set MRBID="",MRBCount=0
			For {
				Set MRBID=$o(^TMP($zn,$j,NIndex,xLocID,xMonth,aType,"MRB",MRBID))
				Quit:MRBID=""
				
				Set MRBCount=+$g(^TMP($zn,$j,NIndex,xLocID,xMonth,aType,"MRB",MRBID))
				Continue:MRBCount=0
				Set InputStr="^"_xLocID_"^"_xMonth_"^"_MRBID_"^"_aType_"^1^"_MRBCount_"^^"
				Set flg=##class(DHCHAI.STA.MRBDetection).Update(InputStr,"^")
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit "OK"
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-28
/// Description:  查询多重耐药菌整合规则
/// Input:    
/// w ##class(DHCHAI.STAS.MRBDetectionSrv).GetMRBRule("","15")
ClassMethod GetMRBRule(aBactID As %String, aMRBID As %String) As %String
{
	New (aBactID,aMRBID)
	Set return=""
	Set NIndex="MRBRule"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ^TMP($zn,$j,NIndex,"MRSA")				= $lb("M1")
	Set ^TMP($zn,$j,NIndex,"VRE")				= $lb("M2","M3")
	Set ^TMP($zn,$j,NIndex,"ESBL阳性肠杆菌")	= $lb("M4","M5","A401")
	Set ^TMP($zn,$j,NIndex,"CRE")				= $lb("M6","M7","A201","A202","A203","A204","A205","A206","A207","A208")
	Set ^TMP($zn,$j,NIndex,"CRK")				= $lb("M7")
	Set ^TMP($zn,$j,NIndex,"CR-AB")				= $lb("M8")
	Set ^TMP($zn,$j,NIndex,"耐碳青霉烯类的铜绿假单胞菌")	= $lb("M9")
	Set ^TMP($zn,$j,NIndex,"MRScon")			= $lb("A101","A102","A103","A104","A105")
	Set ^TMP($zn,$j,NIndex,"难辨梭菌毒素测定")	= $lb("A301")
	
	Set MRBName=""
	If aBactID'=""{
		Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(aBactID)
		Quit:'$IsObject(objBact) return
		Set xMRBID=""
		For {
			Set xMRBID=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",aBactID,xMRBID))
			Quit:xMRBID=""
			
			Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(xMRBID)
			Continue:'$IsObject(objMRB)
			Set MRBCode=objMRB.BTCode
			Set xMRBIndex=""
			For {
				Set xMRBIndex=$o(^TMP($zn,$j,NIndex,xMRBIndex))
				Quit:xMRBIndex=""
				Set MRBList=^TMP($zn,$j,NIndex,xMRBIndex)
				Set:($ListFind(MRBList,MRBCode)>0) MRBName=MRBName_","_xMRBIndex
			}
		}
		Set:MRBName'="" return=$e(MRBName,2,$Length(MRBName))
	} ElseIf(aMRBID'=""){
		Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(aMRBID)
		Quit:objMRB=""
		Set MRBCode=objMRB.BTCode
		Set xMRBIndex=""
		For {
			Set xMRBIndex=$o(^TMP($zn,$j,NIndex,xMRBIndex))
			Quit:xMRBIndex=""
			
			Set MRBList=^TMP($zn,$j,NIndex,xMRBIndex)
			Set:($ListFind(MRBList,MRBCode)>0) MRBName=MRBName_","_xMRBIndex
		}
		Set:MRBName'="" return=$e(MRBName,2,$Length(MRBName))
	} Else {
		Set JsonStr=""
		Set xMRBIndex=""
		For {
			Set xMRBIndex=$o(^TMP($zn,$j,NIndex,xMRBIndex))
			Quit:xMRBIndex=""
			
			Set MRBDesc="",BactList=""
			Set xMRBCodeList=$g(^TMP($zn,$j,NIndex,xMRBIndex))
			For index=1:1:$ListLength(xMRBCodeList){
				Set xMRBCode=$List(xMRBCodeList,index)
				Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjByCode(xMRBCode)
				Continue:'$IsObject(objMRB)
				Set xMRBID=objMRB.%Id()
				Set MRBDesc=MRBDesc_","_objMRB.BTDesc
				
				//关联的细菌列表
				Set xBactID=""
				For {
					Set xBactID=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact2",xMRBID,xBactID))
					Quit:xBactID=""
					
					Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(xBactID)
					Continue:'$IsObject(objBact)
					Set BactList=BactList_","_objBact.BTBacDesc
				}
			}
			Set:BactList'="" BactList=$e(BactList,2,$l(BactList))
			Set:xMRBCodeList'="" MRBCodeList="("_##class(DHCHAI.Utils.CommonSrv).ListToString(xMRBCodeList,",")_")"
			Set:MRBDesc'="" MRBDesc=$e(MRBDesc,2,$l(MRBDesc))
			
			Set JsonStr=JsonStr_","_""""_xMRBIndex_""":"_"{""MRB"":"""_MRBDesc_MRBCodeList_""",""Bacteria"":"""_BactList_"""}"
		}
		Set:JsonStr'="" JsonStr=$e(JsonStr,2,$l(JsonStr))
		Set JsonStr="{"_JsonStr_"}"
		Set return=JsonStr
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-27
/// Description:  查询多重耐药菌检出率(按多耐)
/// Input:        aType:数据类型(1月数据/2季度数据/3年数据)
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.MRBDetectionSrv","QryMRBDetection","1|2","","2018-01-01","2018-08-30","1")
Query QryMRBDetection(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aType As %String) As %Query(ROWSPEC = "ID:%String,AxisName:%String,Numerator:%String,Denominator:%String,Ratio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBDetectionExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateFrom,1)
	Set aDateFrom=$p(aDateFrom,"^",1)
	Set aDateTo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateTo,1)
	Set aDateTo=$p(aDateTo,"^",2)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Quit:($ListFind($lb(1,2,3),+aType)<1) $$$OK
	
	Set NIndex="MRBDetectionRatio"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID))
		Quit:xLocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:(aLocID'="")&&(xLocID'=aLocID)
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($ListFind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set xDate=aDateFrom
		For {
			Set xDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(xDate,1)
			Set xDate=$p(xDate,"^",1)
			
			//病原体
			Set xBactID=""
			For {
				Set xBactID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,0,xBactID))
				Quit:xBactID=""
				
				Set MRBDeteID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,0,xBactID,""))
				Set objMRBDete=##class(DHCHAI.STA.MRBDetection).GetObjById(MRBDeteID)
				Continue:'$IsObject(objMRBDete)
				Set BactCount=objMRBDete.ECCount
				
				Set ^TMP($zn,$j,NIndex,xBactID,"Bacteria")=+$g(^TMP($zn,$j,NIndex,xBactID,"Bacteria"))+BactCount
			}
			//多耐
			Set xMRBID=""
			For {
				Set xMRBID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,1,xMRBID))
				Quit:xMRBID=""
				
				Set MRBDeteID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,1,xMRBID,""))
				Set objMRBDete=##class(DHCHAI.STA.MRBDetection).GetObjById(MRBDeteID)
				Continue:'$IsObject(objMRBDete)
				Set MRBCount=objMRBDete.ECCount
				
				Set ^TMP($zn,$j,NIndex,xMRBID,"MRB")=+$g(^TMP($zn,$j,NIndex,xMRBID,"MRB"))+MRBCount
			}
			
			Set xDate=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xDate)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xDate,aDateTo)=0
		}
	}
	//整合数据
	Set xID=""
	For {
		Set xID=$o(^TMP($zn,$j,NIndex,xID))
		Quit:xID=""
		
		Set (BactCount,MRBCount)=0
		Set BactCount=+$g(^TMP($zn,$j,NIndex,xID,"Bacteria"))
		If (BactCount>0){
			Set MRBNames=..GetMRBRule(xID,"")
			Continue:MRBNames=""
			For index=1:1:$Length(MRBNames,","){
				Set MRBName=$p(MRBNames,",",index)
				Set ^TMP($zn,$j,NIndex,"Data",MRBName,"Denominator")=+$g(^TMP($zn,$j,NIndex,"Data",MRBName,"Denominator"))+BactCount //分母
			}
		}
		Set MRBCount=+$g(^TMP($zn,$j,NIndex,xID,"MRB"))
		If (MRBCount>0){
			Set MRBNames=..GetMRBRule("",xID)
			Continue:MRBNames=""
			For index=1:1:$Length(MRBNames,","){
				Set MRBName=$p(MRBNames,",",index)
				Set ^TMP($zn,$j,NIndex,"Data",MRBName,"Numerator")=+$g(^TMP($zn,$j,NIndex,"Data",MRBName,"Numerator"))+MRBCount //分子
			}
		}
	}
	//计算检出率
	Set xMRBName=""
	For {
		Set xMRBName=$o(^TMP($zn,$j,NIndex,"Data",xMRBName))
		Quit:xMRBName=""
		
		Set Numerator=+$g(^TMP($zn,$j,NIndex,"Data",xMRBName,"Numerator")) //分子
		Set Denominator=+$g(^TMP($zn,$j,NIndex,"Data",xMRBName,"Denominator")) //分母
		If Denominator'=0{
			Set Ratio=(Numerator/Denominator)*100
		} Else {
			Set Ratio=0
		}
		Set Data=$lb(ind,xMRBName,Numerator,Denominator,Ratio)
	 	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryMRBDetectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBDetectionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBDetectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBDetectionExecute ]
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
/// CreatDate：   2018-10-10
/// Description:  查询多重耐药菌检出率(按时间)
/// Input:        aType:数据类型(1月数据/2季度数据/3年数据)
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.MRBDetectionSrv","QryMRBDeteByTime","1|2","","2018-01-01","2018-08-30","1","")
Query QryMRBDeteByTime(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aType As %String, aMRBType As %String) As %Query(ROWSPEC = "ID:%String,AxisName:%String,Numerator:%String,Denominator:%String,Ratio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBDeteByTimeExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aType As %String, aMRBType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateFrom,1)
	Set aDateFrom=$p(aDateFrom,"^",1)
	Set aDateTo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateTo,1)
	Set aDateTo=$p(aDateTo,"^",2)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Quit:($ListFind($lb(1,2,3),+aType)<1) $$$OK
	
	Set NIndex="MRBDeteByTime"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID))
		Quit:xLocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:(aLocID'="")&&(xLocID'=aLocID)
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($ListFind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set xDate=aDateFrom
		For {
			Set xDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(xDate,1)
			Set xDate=$p(xDate,"^",1)
			
			//病原体
			Set xBactID=""
			For {
				Set xBactID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,0,xBactID))
				Quit:xBactID=""
				Set MRBRule=..GetMRBRule(xBactID,"")
				Continue:MRBRule=""
				Continue:(aMRBType'="")&&((","_MRBRule_",") '[ (","_aMRBType_","))
				
				Set MRBDeteID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,0,xBactID,""))
				Set objMRBDete=##class(DHCHAI.STA.MRBDetection).GetObjById(MRBDeteID)
				Continue:'$IsObject(objMRBDete)
				Set BactCount=objMRBDete.ECCount
				
				Set tDate=$e($zd(xDate,3),1,7)
				Set ^TMP($zn,$j,NIndex,"Month",tDate,"Bacteria")=+$g(^TMP($zn,$j,NIndex,"Month",tDate,"Bacteria"))+BactCount
			}
			//多耐
			Set xMRBID=""
			For {
				Set xMRBID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,1,xMRBID))
				Quit:xMRBID=""
				Set MRBRule=..GetMRBRule("",xMRBID)
				Continue:MRBRule=""
				Continue:(aMRBType'="")&&((","_MRBRule_",") '[ (","_aMRBType_","))
				
				Set MRBDeteID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,1,xMRBID,""))
				Set objMRBDete=##class(DHCHAI.STA.MRBDetection).GetObjById(MRBDeteID)
				Continue:'$IsObject(objMRBDete)
				Set MRBCount=objMRBDete.ECCount
				
				Set tDate=$e($zd(xDate,3),1,7)
				Set ^TMP($zn,$j,NIndex,"Month",tDate,"MRB")=+$g(^TMP($zn,$j,NIndex,"Month",tDate,"MRB"))+MRBCount
			}
			
			Set xDate=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xDate)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xDate,aDateTo)=0
		}
	}
	//计算检出率
	Set xDate=""
	For {
		Set xDate=$o(^TMP($zn,$j,NIndex,"Month",xDate))
		Quit:xDate=""
		
		Set Numerator=+$g(^TMP($zn,$j,NIndex,"Month",xDate,"MRB")) //分子
		Set Denominator=+$g(^TMP($zn,$j,NIndex,"Month",xDate,"Bacteria")) //分母
		If Denominator'=0{
			Set Ratio=(Numerator/Denominator)*100
		} Else {
			Set Ratio=0
		}
		Set Data=$lb(ind,xDate,Numerator,Denominator,Ratio)
	 	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryMRBDeteByTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBDeteByTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBDeteByTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBDeteByTimeExecute ]
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
/// CreatDate：   2018-10-10
/// Description:  查询多重耐药菌检出率(按科室)
/// Input:        aType:数据类型(1月数据/2季度数据/3年数据)
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.MRBDetectionSrv","QryMRBDeteByLoc","1|2","","2018-01-01","2018-08-30","1","")
Query QryMRBDeteByLoc(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aType As %String, aMRBType As %String, aLocCount As %String) As %Query(ROWSPEC = "ID:%String,AxisName:%String,Numerator:%String,Denominator:%String,Ratio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBDeteByLocExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aType As %String, aMRBType As %String, aLocCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateFrom,1)
	Set aDateFrom=$p(aDateFrom,"^",1)
	Set aDateTo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateTo,1)
	Set aDateTo=$p(aDateTo,"^",2)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Quit:($ListFind($lb(1,2,3),+aType)<1) $$$OK
	Set:+$g(aLocCount)=0 aLocCount=10 //默认率为前10个科室
	
	Set NIndex="MRBDeteByLoc"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xLocID=""
	For {
		Set xLocID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID))
		Quit:xLocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:(aLocID'="")&&(xLocID'=aLocID)
		Continue:'$IsObject(objLoc.BTHospDr)
		
		Continue:(aHospIDs'="")&&($ListFind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set xDate=aDateFrom
		For {
			Set xDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(xDate,1)
			Set xDate=$p(xDate,"^",1)
			
			//病原体
			Set xBactID=""
			For {
				Set xBactID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,0,xBactID))
				Quit:xBactID=""
				Set MRBRule=..GetMRBRule(xBactID,"")
				Continue:MRBRule=""
				Continue:(aMRBType'="")&&((","_MRBRule_",") '[ (","_aMRBType_","))
				
				Set MRBDeteID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,0,xBactID,""))
				Set objMRBDete=##class(DHCHAI.STA.MRBDetection).GetObjById(MRBDeteID)
				Continue:'$IsObject(objMRBDete)
				Set BactCount=objMRBDete.ECCount
				
				Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"Bacteria")=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"Bacteria"))+BactCount
			}
			//多耐
			Set xMRBID=""
			For {
				Set xMRBID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,1,xMRBID))
				Quit:xMRBID=""
				Set MRBRule=..GetMRBRule("",xMRBID)
				Continue:MRBRule=""
				Continue:(aMRBType'="")&&((","_MRBRule_",") '[ (","_aMRBType_","))
				
				Set MRBDeteID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",xLocID,xDate,aType,1,xMRBID,""))
				Set objMRBDete=##class(DHCHAI.STA.MRBDetection).GetObjById(MRBDeteID)
				Continue:'$IsObject(objMRBDete)
				Set MRBCount=objMRBDete.ECCount
				
				Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"MRB")=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"MRB"))+MRBCount
			}
			
			Set xDate=##class(DHCHAI.Utils.CommonSrv).GetNextMonth(xDate)
			Quit:##class(DHCHAI.Utils.CommonSrv).MonthLessThan(xDate,aDateTo)=0
		}
	}
	//计算检出率
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Loc",xLocID))
		Quit:xLocID=""
		
		Set Numerator=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"MRB")) //分子
		Set Denominator=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"Bacteria")) //分母
		If Denominator'=0{
			Set Ratio=(Numerator/Denominator)*100
		} Else {
			Set Ratio=0
		}
		Set ^TMP($zn,$j,NIndex,"Ratio",Ratio)=xLocID
	}
	//排序输出
	Set xCount=0
	Set xRatio=""
	For {
		Set xRatio=$o(^TMP($zn,$j,NIndex,"Ratio",xRatio),-1)
		Quit:xRatio=""
		Set xCount=$i(xCount)
		Quit:xCount>aLocCount
		
		Set LocID=$g(^TMP($zn,$j,NIndex,"Ratio",xRatio))
		Continue:LocID=""
		Set Numerator=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"MRB"))
		Set Denominator=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"Bacteria"))
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set LocDesc=objLoc.BTDesc
		Set LocDesc2=objLoc.BTDesc2
		Set:LocDesc2="" LocDesc2 = LocDesc
		Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
		
		Set Data=$lb(ind,LocDesc2,Numerator,Denominator,xRatio)
	 	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryMRBDeteByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBDeteByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBDeteByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBDeteByLocExecute ]
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

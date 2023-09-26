/// 名称: DHCHAI.STAT.S300PICCInf
/// 描述: 三管相关感染发病率统计表
/// 编写者：zhugz
/// 编写日期: 2018-10-10
Class DHCHAI.STAT.S300PICCInf Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2018-10-10
/// Description:  三管相关感染发病率统计表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 				  aType :    三管类型(PICC/UC/VAP)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S300PICCInf","QryS300Msg","","2018-12","2018-12","")
Query QryS300Msg(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aType As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,LocTypeDesc:%String,Paadm:%String,WardDr:%String,WardDesc:%String,UseTubeYN:%Integer,OcuurInf:%Integer,Date:%String") [ SqlProc ]
{
}

ClassMethod QryS300MsgExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aType As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandle=$lb(0,repidx,0)	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:($L(aDateFrom,"-")=2) aDateFrom=aDateFrom_"-01"
	if ($L(aDateTo,"-")=2) {  //月份参数处理
		Set xaDateTo=aDateTo_"-28"
		Set xaDateTo=$zdh(xaDateTo,3)+4
		Set xaDateTo=$zd(xaDateTo,3)
		Set xaDateTo=$p(xaDateTo,"-",1)_"-"_$p(xaDateTo,"-",2)_"-01"
		Set xaDateTo=$zdh(xaDateTo,3)-1
		Set aDateTo=$zd(xaDateTo,3)
	}
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set Nindex="QryS300Msg"
    k ^TMP($zn,$j,Nindex)
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		
		Continue:(Status="I")                 // 当天转入不算在内
		//Continue:(Status="A2")              // 当天转入当天转出不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Continue:'$isobject(objPaadm) 
		Set DischDate = objPaadm.PADischDate
		Set DischTime = objPaadm.PADischTime
	
		// 医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
		Set LWBMsg=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(Paadm,Date,"") //获取当天23::59:59时病人所在科室、病区、床信息
		Continue:LWBMsg=""
		Set LocDr  = $p(LWBMsg,"^",1) // 科室
		Set WardDr = $p(LWBMsg,"^",2) // 病区
		// 科室信息
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
		Continue:'$IsObject(objLoc)
		If ($IsObject(objLoc.BTGroupDr)){
			Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
		}Else {
			Set LocTypeDesc="其他科"
		}
		Set LocDesc=objLoc.BTDesc2
		Set:LocDesc="" LocDesc=objLoc.BTDesc
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		// 病区信息
		Set WardDesc=""
		if (WardDr'=""){
			Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
			Continue:'$isobject(objWard)
			Set WardDesc=objWard.BTDesc2
			Set:WardDesc="" WardDesc=objWard.BTDesc
			Continue:WardDesc=""		
			Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
		}		
		Set UseTubeYN=0    //当天是否使用三管
		Set TubeType=""    //插管类型
		Set aTypeCode=$CASE(aType,"PICC":"1","VAP":"2","UC":"3",:"0")
		
		if '$d(^TMP($zn,$j,Nindex,Paadm,"UseTubeYN")) {   //每人获取一次截止当前为止的插管信息
			Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.ICULogSrv:QryICUAdmOeItem")
		  	Set sc=rs.Execute(Paadm,aTypeCode)
		  	If $$$ISERR(sc) {
			  	Do $System.Status.DisplayError(sc)
		  	}
		    While (rs.Next()){			    
			    Set RowID=rs.Data("RowID")
				Set OeItemDesc=rs.Data("OeItemDesc")
				Set StartDt=rs.Data("StartDt")
				Set EndDt=rs.Data("EndDt")
				Set TypeValue=rs.Data("TypeValue")
				Set TubeType=rs.Data("TubeType")
				continue:TubeType=""	
				Set:TypeValue["临时" EndDt=StartDt
				Set ^TMP($zn,$j,Nindex,Paadm,"UseTubeYN",RowID)=$lb(OeItemDesc,StartDt,EndDt,TypeValue,TubeType)	
		    }			
		}
		Set xRowID=""
		for {
			Set xRowID=$o(^TMP($zn,$j,Nindex,Paadm,"UseTubeYN",xRowID))
			Quit:xRowID=""
			Set xListMsg=$g(^TMP($zn,$j,Nindex,Paadm,"UseTubeYN",xRowID))
			Set xStartDt=$lg(xListMsg,2)
			//Set xStartDate=$zdh($p(xStartDt," ",1),3)
			Set xStartDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical($p(xStartDt," ",1))
			Set xStartTime=$zth($p(xStartDt," ",2),1)
			Continue:((DischDate'="")&&(DischTime'=""))&&((xStartDate>DischDate)||((xStartDate=DischDate)&&(xStartTime>DischTime)))  //出院以后的医嘱不计算
		
			Set xEndDt=$lg(xListMsg,3)
			Set xEndDate=""
			//Set:xEndDt'="" xEndDate=$zdh($p(xEndDt," ",1),3)
			Set xEndDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical($p(xEndDt," ",1))
			Set:xEndDate="" xEndDate=+$h
			Set:(Date>=xStartDate)&&(Date<=xEndDate) UseTubeYN=1 //如果病人当前日期在插管日期范围内，则算当日插管
			Continue:UseTubeYN'=1
			Set xTubeType=$lg(xListMsg,5)
			Set TubeType=TubeType_","_xTubeType
			}
		Set:TubeType'="" TubeType=$e(TubeType,2,$l(TubeType))
		Set OcuurInf=0     //是否发现感染  
		Set TubeInf=..GetTubeInf(Paadm,aType,Date)  //新入院病人未计算，入院当天发生感染不计入统计
		Set:TubeInf'="" OcuurInf=1
		Set Data=$lb(LocDr,LocDesc,LocTypeDesc,Paadm,WardDr,WardDesc,UseTubeYN,OcuurInf,Date)
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1
	 	}
	Quit $$$OK
}

ClassMethod QryS300MsgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS300MsgExecute ]
{
	Set repidx=$LIST(qHandle,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryS300MsgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS300MsgExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repidx=$LIST(qHandle,2)
 	Set indx=$LIST(qHandle,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

/// 获取 一段时间内住院患者信息
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S300PICCInf","QryS300PatDtl","1","2018-04-01","2018-04-15","E","","","1","VAP","1")
Query QryS300PatDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aUseTube As %String = "", aTubeType As %String = "", aTubeInf As %String = "") As %Query(ROWSPEC = "EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupCode:%String,GroupDesc:%String,TransLocID:%Integer,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,UseTubeYN:%Integer,OEOrdItmID:%String,OEOrdDesc:%String,OEStartDT:%String,OEEndDT:%String,OcuurInf:%String,InfPos:%String,InfDate:%String,InfType:%String,DeasResult:%String,ResultDT:%String") [ SqlProc ]
{
}

ClassMethod QryS300PatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocGroup As %String, aLocDesc As %String, aUseTube As %String = "", aTubeType As %String = "", aTubeInf As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandle=$lb(0,repidx,0)
	;Set ^tmpzgz1012=$lb(aHospIDs, aDateFrom, aDateTo, aLocType, aLocGroup, aLocDesc,aTubeInf)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:($L(aDateFrom,"-")=2) aDateFrom=aDateFrom_"-01"
	if ($L(aDateTo,"-")=2) {  //月份参数处理
		Set xaDateTo=aDateTo_"-28"
		Set xaDateTo=$zdh(xaDateTo,3)+4
		Set xaDateTo=$zd(xaDateTo,3)
		Set xaDateTo=$p(xaDateTo,"-",1)_"-"_$p(xaDateTo,"-",2)_"-01"
		Set xaDateTo=$zdh(xaDateTo,3)-1
		Set aDateTo=$zd(xaDateTo,3)
	}
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryS300PatDtl"
	Kill ^TMP($zn,$j,NIndex)
	Set:aLocType="" aLocType="E"
    //同期在科、在病区
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		
		Continue:(Status="I")                 //当天转入不算在内
		//Continue:(Status="A2")              //当天转入当天转出不算在内

		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤		
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set GroupDr="",GroupCode="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr 	= objLoc.BTGroupDr.%Id()
			Set GroupCode	= objLoc.BTGroupDr.BTCode
			Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="其他科"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
				Set GroupDesc	= objGroup.BTDesc
			}
		}	
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDesc)
		Set ^TMP($zn,$j,NIndex,aLocType,TansID) = ""
	}
	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,NIndex,aLocType,xTransID))
		Quit:xTransID=""
		Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
		Continue:'$IsObject(objTrans)
		
		Set objPaadm = objTrans.PAEpisodeDr
		Set objTransLoc = objTrans.PATransLocDr
		Continue:'$IsObject(objPaadm)
		Continue:'$IsObject(objTransLoc)	
		Set EpisodeID =objPaadm.%Id()
		Set TransLocID =  objTransLoc.%Id()
		Set TransLocDesc = objTransLoc.BTDesc2
		Set:TransLocDesc="" TransLocDesc = objTransLoc.BTDesc
		Continue:TransLocDesc=""
		Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
		Set TransDate = objTrans.PATransDate
		Set OutLocDate= objTrans.PAOutLocDate
		Set TransTime = objTrans.PATransTime
		Set OutLocTime =objTrans.PAOutLocTime
		Set GroupDr="",GroupCode="",GroupDesc=""
		If $IsObject(objTransLoc.BTGroupDr) {
			Set GroupDr 	= objTransLoc.BTGroupDr.%Id()
			Set GroupCode	= objTransLoc.BTGroupDr.BTCode
			Set GroupDesc	= objTransLoc.BTGroupDr.BTDesc	
		}Else {
			Set GroupDesc="其他科"
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc(GroupDesc)
			If $IsObject(objGroup) {
				Set GroupDr 	= objGroup.%Id()
				Set GroupCode	= objGroup.BTCode
			}
		}
		//病人基本信息		
	    Set PatData =..BuildPaadmData(EpisodeID)
	    Continue:PatData=""
	    Set AdmDate=$p($lg(PatData,9)," ",1)
	    Set:AdmDate["-" AdmDate=$zdh(AdmDate,3)
		Set (UseTubeYN,OEOrdItmID,OEOrdDesc,OEStartDT,OEEndDT,OcuurInf,InfPos,InfDate,InfType,DeasResult,ResultDT)=""
		Set aTypeCode=$CASE(aTubeType,"PICC":"1","VAP":"2","UC":"3",:"0")		
		if (aUseTube="1") {
			if '$d(^TMP($zn,$j,NIndex,EpisodeID,"UseTubeYN")) {   //每人获取一次截止当前为止的插管信息
				Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.ICULogSrv:QryICUAdmOeItem")
			  	Set sc=rs.Execute(EpisodeID,aTypeCode)
			  	If $$$ISERR(sc) {
				  	Do $System.Status.DisplayError(sc)
		  	}
		    While (rs.Next()){		    
			    Set RowID=rs.Data("RowID")
				Set OEItemDesc=rs.Data("OeItemDesc")
				Set StartDt=rs.Data("StartDt")
				Set EndDt=rs.Data("EndDt")
				Set TypeValue=rs.Data("TypeValue")
				Set:TypeValue["临时" EndDt=StartDt
				Set TubeType=rs.Data("TubeType")
				Set OrdItemID=rs.Data("OrdItemID")
				continue:TubeType=""	
				Set ^TMP($zn,$j,NIndex,EpisodeID,"UseTubeYN",RowID)=$lb(OEItemDesc,StartDt,EndDt,TypeValue,TubeType,OrdItemID)	
		    	}			
			}
			Set xRowID=""
			for {
				Set xRowID=$o(^TMP($zn,$j,NIndex,EpisodeID,"UseTubeYN",xRowID))
				Quit:xRowID=""
				Set xListMsg=$g(^TMP($zn,$j,NIndex,EpisodeID,"UseTubeYN",xRowID))
				Set xStartDt=$lg(xListMsg,2)
				Set xTypeValue=$lg(xListMsg,4)
				//Set xStartDate=$zdh($p(xStartDt," ",1),3)
				Set xStartDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical($p(xStartDt," ",1))
				Set xStartTime=$zth($p(xStartDt," ",2),1)
				Set xStartDTStr=xStartDate_xStartTime
				Set xEndDt=$lg(xListMsg,3)
				Set xEndDate=""
				//Set:xEndDt'="" xEndDate=$zdh($p(xEndDt," ",1),3)
				Set xEndDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical($p(xEndDt," ",1))
				Set:xEndDt'="" xEndTime=$zth($p(xEndDt," ",2),1)
				Set:xEndDt="" xEndDate=+$h,xEndTime=$p($h,",",2)
				Set xEndDTStr=xEndDate_xEndTime
				Set xOutLocDate=OutLocDate
				Set:xOutLocDate="" xOutLocDate=+$h
				Set xOutLocTime=OutLocTime
				Set:xOutLocTime="" xOutLocTime=$p($h,",",2)
				Set xOutLocDTStr=xOutLocDate_xOutLocTime
				Set xTransDate=TransDate
				Set xTransTime=TransTime
				Set xTransDTStr=xTransDate_xTransTime
				//和汇总保持一致,医嘱在转入当天的不计算，但A2类型的如何计算？
				Continue:(xStartDate=xEndDate)&&(xStartDate=xTransDate)
				///插管时间在在转科时间内，且插管时间再统计时间范围内
				//拼接的时间 2019-05-01 00:00:00 (651340) 小于  2019-04-29 16:49:22 (6513260562)
				//Set:(xEndDTStr>=xTransDTStr)&&(xStartDTStr<=xOutLocDTStr)&&(xEndDate>=aDateFrom)&&(xStartDate<=aDateTo) UseTubeYN=1
				Set:((xEndDate>xTransDate)||((xEndDate=xTransDate)&&(xEndDate>xTransTime)))&&((xStartDate<xOutLocDate)||((xStartDate=xOutLocDate)&&(xStartTime<xOutLocTime)))&&(xEndDate>=aDateFrom)&&(xStartDate<=aDateTo) UseTubeYN=1
				If ((UseTubeYN'=1)&&(xOutLocDate=xStartDate)) { //开医嘱当天转出再转入的判断
					Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,xStartDate,xStartTime)
					Set CurrLoc=$p(TransLocInfo,"^",1)
					Set:CurrLoc=TransLocID UseTubeYN=1
				}
				
				Continue:UseTubeYN'=1
				
				Set xOrderItmID=$lg(xListMsg,6)
				Set xOrderType=$lg(xListMsg,4)
				Set xOrderType=$tr(xOrderType,"医嘱","")	
				Set OEOrdItmID=OEOrdItmID_","_xOrderItmID
				Set OEOrdDesc=OEOrdDesc_",【"_xOrderType_"】"_OEItemDesc
				Set OEStartDT=OEStartDT_","_xStartDt
				Set OEEndDT=OEEndDT_","_xEndDt
				}
				Set:OEOrdItmID'="" OEOrdItmID=$e(OEOrdItmID,2,$l(OEOrdItmID))
				Set:OEOrdDesc'="" OEOrdDesc=$e(OEOrdDesc,2,$l(OEOrdDesc))
				Set:OEStartDT'="" OEStartDT=$e(OEStartDT,2,$l(OEStartDT))
				Set:OEEndDT'="" OEEndDT=$e(OEEndDT,2,$l(OEEndDT))
			}
			if (aTubeInf=1)
			{
				Set OcuurInf=0,TubeInf="",xInfType="医院感染"   //是否发现感染 
				for zDate=TransDate:1:xOutLocDate {				
					Set zTubeInf=..GetTubeInf(EpisodeID,aTubeType,zDate)
					continue:zTubeInf=""
					for zindex=1:1:$l(zTubeInf,",") {	
						Set subInfMsg=$p(zTubeInf,",",zindex)
						continue:subInfMsg=""
						continue:$p(subInfMsg,"^",2)=""
						Set:($p(subInfMsg,"^",1)-AdmDate)<2 xInfType="社区感染" //如果感染日期在入院2天内，算作社区感染
						Set xInfDate=$p(subInfMsg,"^",1)
						continue:(xInfDate<aDateFrom)||(xInfDate>aDateTo) //感染日期不在统计范围之内 过滤
						Set OcuurInf=1
						Set InfDate=InfDate_","_$zd($p(subInfMsg,"^",1),3)
						Set InfPos=InfPos_","_ $p(subInfMsg,"^",2)
						Set InfType=InfType_","_xInfType
						Set DeasResult=DeasResult_","_ $p(subInfMsg,"^",3)
						Set ResultDT=ResultDT_","_$s($p(subInfMsg,"^",4)'="":$zd($p(subInfMsg,"^",4),3),1:"")
					}
			}
			Set:InfDate'="" InfDate=$e(InfDate,2,$l(InfDate))	
			Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))
			Set:InfType'="" InfType=$e(InfType,2,$l(InfType))
			Set:DeasResult'="" DeasResult=$e(DeasResult,2,$l(DeasResult))
			Set:ResultDT'="" ResultDT=$e(ResultDT,2,$l(ResultDT))	
		}
		
		Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
		Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	    Set:TransTime'="" TransTime=$zt(TransTime)   
	    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	    Set TransDateTime =TransDate_" "_TransTime
		Set OutLocDateTime =OutLocDate_" "_OutLocTime	
		if (aTubeInf=1) {
			continue:OcuurInf'=1
			}
		elseif(aUseTube=1){
			continue:UseTubeYN'=1
		}
		//转科信息
		Set Data=PatData_$lb(xTransID,GroupCode,GroupDesc,TransLocID,TransLocDesc,TransDateTime,OutLocDateTime)
		//插管及相关感染信息
		Set Data=Data_$LB(UseTubeYN,OEOrdItmID,OEOrdDesc,OEStartDT,OEEndDT,OcuurInf,InfPos,InfDate,InfType,DeasResult,ResultDT)
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1	    
	}

	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryS300PatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS300PatDtlExecute ]
{
	Set repidx=$LIST(qHandle,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryS300PatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS300PatDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repidx=$LIST(qHandle,2)
 	Set indx=$LIST(qHandle,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime

	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// 获取插管感染信息
/// 返回插管相关感染日期
/// w ##class(DHCHAI.STAT.S300PICCInf).GetTubeInf(15)
ClassMethod GetTubeInf(aPaadm As %String, aTubeType As %String = "", aDate As %String = "") As %String
{
	new (aPaadm,aTubeType,aDate)
	//数据来源1 院感报告 
	//血管导管相关血流感染 判断规则：诊断子分类为 导管相关血流感染
	//导尿管相关泌尿道感染 判断规则：诊断子分类为 导尿管相关泌尿系感染
	//呼吸机相关肺炎       判断规则：诊断子分类为 呼吸机相关性肺炎
	Set return=""
	Set xDate=""
	for {
		Set xDate=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aPaadm,xDate))
		Quit:xDate=""
		Continue:(aDate'="")&&(aDate'=xDate)
		Set RowID=""
		for {
			Set RowID=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aPaadm,xDate,RowID))
			Quit:RowID=""
			Set RepList=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",RowID)
			Set objRep=RepList.GetAt(1)
			continue:'$IsObject(objRep)
			Set RepStatus=objRep.IRStatusDr.BTCode
			continue:(RepStatus'=3) ;审核
			Set InfPos=##class(DHCHAI.IR.INFDiagnos).GetObjById(RowID)
			Set InfSubDiag=InfPos.IRInfSubDr.BTDesc
			if (aTubeType="PICC")&&(InfSubDiag["CLABSI") 
			{ 
				Set return=return_","_xDate_"^"_InfPos.IRInfPosDr.BTDesc_"^"_InfPos.IRInfEffectDr.BTDesc_"^"_InfPos.IRInfXDate
			}elseif (aTubeType="UC")&&(InfSubDiag["CA-UTI") { 
				Set return=return_","_xDate_"^"_InfPos.IRInfPosDr.BTDesc_"^"_InfPos.IRInfEffectDr.BTDesc_"^"_InfPos.IRInfXDate
			}elseif (aTubeType="VAP")&&(InfSubDiag["VAP") { 
				Set return=return_","_xDate_"^"_InfPos.IRInfPosDr.BTDesc_"^"_InfPos.IRInfEffectDr.BTDesc_"^"_InfPos.IRInfXDate
			}elseif (aTubeType="")&&(((InfSubDiag["CLABSI"))||(InfSubDiag["CA-UTI")||(InfSubDiag["VAP") ) {
				Set return=return_","_xDate_"^"_InfPos.IRInfPosDr.BTDesc_"^"_InfPos.IRInfEffectDr.BTDesc_"^"_InfPos.IRInfXDate
				}
		}
	}
	Quit:return'="" $e(return,2,$l(return))
	// 数据来源2 ICU调查表
	// PICC感染信息
	/*Set yDate=""
	for {
		Set yDate=$o(^DHCHAI.IR.INFICUPICCI("IndexEpisInfDate",aPaadm,yDate))
		Quit:yDate=""
		Continue:(aDate'="")&&(aDate'=yDate)
		Set xPICCID=""
		For {
			Set xPICCID=$o(^DHCHAI.IR.INFICUPICCI("IndexEpisInfDate",aPaadm,yDate,xPICCID))
			Quit:xPICCID=""
			Set objPICC = ##class(DHCHAI.IR.INFICUPICC).GetObjById(xPICCID)
			Continue:'$IsObject(objPICC)
			Continue:(objPICC.IRIsInf'=1)           // 过滤非感染信息
			Set objAdm  = objPICC.IREpisodeDr
			Continue:'$IsObject(objAdm)
			Continue:(objAdm.PAIsNewBaby=1)         // 过滤新生儿
			Set return=return_","_yDate_"^来自ICU调查表"
		}
		// UC感染信息
		Set xUCID=""
		For {
			Set xUCID=$o(^DHCHAI.IR.INFICUUCI("IndexEpisInfDate",aPaadm,yDate,xUCID))
			Quit:xUCID=""
			Set objUC = ##class(DHCHAI.IR.INFICUUC).GetObjById(xUCID)
			Continue:'$IsObject(objUC)
			Continue:(objUC.IRIsInf'=1)           // 过滤非感染信息
			Set objAdm  = objUC.IREpisodeDr
			Continue:'$IsObject(objAdm)
			Continue:(objAdm.PAIsNewBaby=1)       // 过滤新生儿
			Set return=return_","_yDate_"^来自ICU调查表"
		}
		// VAP感染信息
		Set xVAPID=""
		For {
			Set xVAPID=$o(^DHCHAI.IR.INFICUVAPI("IndexEpisInfDate",aPaadm,yDate,xVAPID))
			Quit:xVAPID=""
			Set objVAP = ##class(DHCHAI.IR.INFICUVAP).GetObjById(xVAPID)
			Continue:'$IsObject(objVAP)
			Continue:(objVAP.IRIsInf'=1)      // 过滤非感染信息
			Set objAdm  = objVAP.IREpisodeDr
			Continue:'$IsObject(objAdm)
			Continue:(objAdm.PAIsNewBaby=1)   // 过滤新生儿
			Set return=return_","_yDate_"^来自ICU调查表"
		}
	}*/
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Description:  查询ICU临床病情等级情况
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       aLocID:科室ID, aYYMM:年月
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S300PICCInf","QryIGByMonth","","2018-09","2018-10")
Query QryIGByMonth(aHospIDs As %String, aDateFrom As %String, aDateTo) As %Query(ROWSPEC = "IGLocID:%String,IGLocDesc:%String,IGPCount:%Integer,IGScore:%Integer") [ SqlProc ]
{
}

ClassMethod QryIGByMonthExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set ^tmp1017=$lb(aHospIDs , aDateFrom , aDateTo)
	Set xSYear=+$p(aDateFrom,"-",1)
	Set xSMonth=+$p(aDateFrom,"-",2)
	Set xEYear=+$p(aDateTo,"-",1)
	Set xEMonth=+$p(aDateTo,"-",2)
	Quit:(xSYear=0)||(xSMonth=0)||(xEYear=0)||(xEMonth=0) $$$OK
	Set xEMonth=(xEYear-xSYear)*12+xEMonth
	Set ZIndex=$zn,JIndex=$j,NIndex="QryIGByMonth"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Set CurrYear=xSYear,YearFlg=0
	for xMonth=xSMonth:1:xEMonth {
		Set:(xMonth#12=1)&(xMonth>12) CurrYear=CurrYear+1
		Set CurrMonth=xMonth
		Set:(xMonth#12>0)&(xMonth>12) CurrMonth=xMonth-((xMonth\12)*12)
		Set:(xMonth#12=0)&(xMonth>23) CurrMonth=xMonth-(((xMonth\12)-1)*12)
		//CurrYear,CurrMonth
		Set aLocID=""
		for {
				Set aLocID=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",aLocID))
				Quit:aLocID=""
				continue:'$d(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",aLocID,CurrYear,CurrMonth))
				For xWeek=1:1:5
				{
					Set (IGItem1,IGItem2,IGItem3,IGItem4,IGItem5,IGItemCount,IGScoreCount)=""
					Set xGradeID=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",aLocID,CurrYear,CurrMonth,xWeek,0))
					Set objGrade=##class(DHCHAI.IR.ICUGrade).GetObjById(xGradeID)
					If $IsObject(objGrade)
					{
						Set IGItem1=objGrade.IGItem1
						Set IGItem2=objGrade.IGItem2
						Set IGItem3=objGrade.IGItem3
						Set IGItem4=objGrade.IGItem4
						Set IGItem5=objGrade.IGItem5
						
						Set IGItemCount=(+IGItem1)+(+IGItem2)+(+IGItem3)+(+IGItem4)+(+IGItem5)
						Set IGScoreCount=((+IGItem1)*1)+((+IGItem2)*2)+((+IGItem3)*3)+((+IGItem4)*4)+((+IGItem5)*5)
					}
					Set ^TMP(ZIndex,JIndex,NIndex,1,xWeek)=IGItem1
					Set ^TMP(ZIndex,JIndex,NIndex,2,xWeek)=IGItem2
					Set ^TMP(ZIndex,JIndex,NIndex,3,xWeek)=IGItem3
					Set ^TMP(ZIndex,JIndex,NIndex,4,xWeek)=IGItem4
					Set ^TMP(ZIndex,JIndex,NIndex,5,xWeek)=IGItem5
					Set ^TMP(ZIndex,JIndex,NIndex,6,xWeek)=IGItemCount
					Set ^TMP(ZIndex,JIndex,NIndex,7,xWeek)=IGScoreCount
				}
				
				Set ItemGradeList=$lb("A","B","C","D","E")
				Set ItemScoreList=$lb(1,2,3,4,5)
				Set (TPeopleNum,AvgICUGrade,TScore)=0
				For indGrade=1:1:5 {
					Set IGItem1=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,1))
					Set IGItem2=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,2))
					Set IGItem3=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,3))
					Set IGItem4=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,4))
					
					Set TPeopleNum = TPeopleNum + IGItem1 + IGItem2 + IGItem3 + IGItem4
					Set TScore = TScore + ((IGItem1 + IGItem2 + IGItem3 + IGItem4)*indGrade)
				}
			Set ^TMP(ZIndex,JIndex,NIndex,aLocID,CurrYear,CurrMonth)=$lb(TPeopleNum,TScore)	
		}
	}	
	Set xLocID=""
	for {
		Set xLocID=$O(^TMP(ZIndex,JIndex,NIndex,xLocID))
		Quit:xLocID=""
		Set xYear="",tPeopleCount=0,tScore=0
		for {
			Set xYear=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xYear))
			Quit:xYear=""
			Set xMonth=""
			for {
				Set xMonth=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xYear,xMonth))
				Quit:xMonth=""
				Set xMonthMsg=$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xYear,xMonth))
				Set tPeopleCount=tPeopleCount+$lg(xMonthMsg,1)
				Set tScore=tScore+$lg(xMonthMsg,2)
				}
			
			}
		continue:+tPeopleCount=0
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Quit:'$IsObject(objLoc)
		Set LocDesc=objLoc.BTDesc2
		Set:LocDesc="" LocDesc=objLoc.BTDesc
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set Data=$lb(xLocID,LocDesc,tPeopleCount,tScore)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
}

ClassMethod QryIGByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIGByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryIGByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIGByMonthExecute ]
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

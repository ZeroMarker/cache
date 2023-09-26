/// 名称: DHCHAI.IRS.ICULogSrv
/// 描述: 目标性监测ICU相关服务
/// 编写者：chenjb
/// 编写日期: 2017-07-06
Class DHCHAI.IRS.ICULogSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-07-06
/// Description:  查询ICU调查日志记录
/// Table：       DHCHAI.IR.ICULog
/// Input:        aYYMM,aLocDr
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICULogSrv","QryAISByMonth","2018-04","2331")
Query QryAISByMonth(aYYMM As %String, aLocDr As %String) As %Query(ROWSPEC = "LogIndex:%String,AISID:%String,LocID:%String,LocDesc:%String,SurveryDate:%String,SurveryDay:%String,AISItem1:%String,AISItem2:%String,AISItem3:%String,AISItem4:%String,AISItem5:%String,AISItem6:%String,AISItem7:%String,AISItem8:%String,AISItem9:%String,AISItem10:%String,AISItem11:%String,AISItem12:%String") [ SqlProc ]
{
}

ClassMethod QryAISByMonthExecute(ByRef qHandle As %Binary, aYYMM As %String, aLocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aYYMM="")||(aLocDr="") $$$OK
	
	Set FormDay=##class(DHCHAI.BT.Config).GetValByCode("ICULogFormDay")
	Set FormDay=+FormDay
	Set:(FormDay="")||(FormDay="0") FormDay="01"
	Set:$l(FormDay)=1 FormDay="0"_+FormDay
	Set:$l(FormDay)>2 FormDay="01"
	Set:FormDay>31 FormDay="01"

	Set xDateFrom=aYYMM_"-"_FormDay
	Set xDateFrom=$zdh(xDateFrom,3)
	Set xDateTo=xDateFrom+32
	Set xDateTo=$zd(xDateTo,3)
	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-"_FormDay
	Set xDateTo=$zdh(xDateTo,3)-1
	Set:xDateTo>+$h xDateTo = +$h    //最大到当天
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocDr)
	Quit:'$Isobject(objLoc) $$$OK
	Quit:objLoc.BTIsNICU=1 $$$OK
	Set LocDesc=objLoc.BTDesc2 //取本地数据对象
	Set:LocDesc="" LocDesc=objLoc.BTDesc
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Quit:LocDesc="" $$$OK
	
	Set LogIndex=0
	For xDate=xDateFrom:1:xDateTo {
		Quit:xDate>(+$h)
		
		Set (LogID,AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8,AISItem9,AISItem10,AISItem11,AISItem12)=""
		
		Set xWtCat=0  //ICU日志默认为0
		Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",aLocDr,xDate,xWtCat,0))  //是否确认
		Continue:xLogID=""
		Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
		If $IsObject(objLog) {
			Set LogID=xLogID
			Set AISItem1 = objLog.ILNewCnt
			Set AISItem2 = objLog.ILAdmCnt
			Set AISItem3 = objLog.ILOutCnt
			Set AISItem4 = objLog.ILIsVAP
			Set AISItem5 = objLog.ILIsPICC
			Set AISItem6 = objLog.ILIsUC
			Set AISItem7 = objLog.ILIsOper
			
			Set AISItem9  = objLog.ILIsCVC
			Set AISItem10 = objLog.ILIsCRRT
			Set AISItem11 = objLog.ILIsPORT
			Set AISItem12 = objLog.ILIsJMZGSum
		}
		
		Set SurveryDay=$p($zd(xDate,3),"-",3)
		Set SurveryDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xDate)
		
		Set LogIndex=LogIndex+1
		//多语言处理
		Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
		Set Data=$lb(LogIndex,LogID,aLocDr,LocDesc,SurveryDate,SurveryDay)
		Set Data=Data_$lb(AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8,AISItem9,AISItem10,AISItem11,AISItem12)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAISByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAISByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAISByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAISByMonthExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-07-07
/// Description:  查询ICU在科患者总数
/// Table：       DHCHAI.DP.PAAdmTrans、DHCHAI.IR.ICULogDtl
/// Input：       aDate  ：日期
///               aLocDr : 科室
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICULogSrv","QryICUAdmStr","2020-05-08",43)
Query QryICUAdmStr(aDate As %String, aLocDr As %String) As %Query(ROWSPEC = "RowID:%String,LocID:%String,LocDesc:%String,AISDate:%String,EpisodeDr:%String,PatType:%String,PapmiNo:%String,Paadm:%String,PatientName:%String,Sex:%String,Age:%String,PAAdmBed:%String,PAAdmDate:%String,PADischDate:%String,IsPICC:%String,IsPICCO:%String,IsUC:%String,IsUCO:%String,IsVAP:%String,IsVAPO:%String,PatWeight:%String,PatApgar:%String,IsCVC:%String,IsCVCO:%String,IsCRRT:%String,IsCRRTO:%String,IsPORT:%String,IsPORTO:%String")
{
}

ClassMethod QryICUAdmStrExecute(ByRef qHandle As %Binary, aDate As %String, aLocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aDate="")||(aLocDr="") $$$OK
 	
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(aLocDr)
	Quit:'$Isobject(objLoc) $$$OK
	Set LocDesc=objLoc.BTDesc2 //取本地数据对象
	Set:LocDesc="" LocDesc=objLoc.BTDesc
	Quit:LocDesc="" $$$OK
	
    //Set:aDate["-" aDate=$zdh(aDate,3)
 	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
 	
 	//通过系统参数'ICUSurveryType'显示科室/病区
	Set ICUSurveryType=##class(DHCHAI.BT.Config).GetValByCode("ICUSurveryType")
	//科室患者就诊号列表
	If (ICUSurveryType="1"){
		Set arrTransEpis=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(aDate,aDate,"W",aLocDr,"I")
	}
	else{
		Set arrTransEpis=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDate,aDate,"E",aLocDr,"I")
	}
 	
	For indEpis=1:1:arrTransEpis.Count() {
		Set TransInfo=arrTransEpis.GetAt(indEpis)
		Set idxDate      = $listget(TransInfo,1)
		Set idxEpisodeDr = $listget(TransInfo,2)
		Set idxStatus    = $listget(TransInfo,3)
		Set idxLocDr     = $listget(TransInfo,4)
		Set idxTransID   = $listget(TransInfo,5)
		Continue:(idxStatus'="A")&(idxStatus'="I")&(idxStatus'="O")&(idxStatus'="A2")  //在科病人=住在病人+新入病人++新出病人+当天入当天出
		Continue:idxLocDr'=aLocDr
	
		Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(idxTransID)  //转科表
		Continue:'$Isobject(objAdmTrans)
		Continue:'$Isobject(objAdmTrans.PAEpisodeDr)
		Set objAdm=objAdmTrans.PAEpisodeDr
		
		Set (PatType,PatientID,PatientName,Sex,Age,Type)=""
		Set EpisodeDr=objAdm.%Id()
		Set PatientID=objAdm.PAPatientIDx
		Set PatientName=objAdm.PAPatName
		Set PapmiNo=objAdm.PAMrNo
		Set Sex=objAdm.PASex   //性别
		Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
		Set Age=objAdm.PAAge
		
		Set PatType="住在患者"
		If (idxStatus["A")&(aDate=objAdmTrans.PATransDate) {
			Set PatType="新住进患者"
		}
		/*
		Set (PAAdmBedDr,PAAdmBed)=""              //床位
		If $IsObject(objAdm.PAAdmBedDr){
			Set PAAdmBedDr=objAdm.PAAdmBedDr.%Id()
			Set PAAdmBed=objAdm.PAAdmBedDr.BTDesc
		}
		*/
		//床位号
		Set BedDesc=""
		If ($IsObject(objAdmTrans.PATransBedDr)){
			Set BedDr=objAdmTrans.PATransBedDr.%Id()
			Set objBed=##class(DHCHAI.BT.PACBed).GetObjById(BedDr)
			If $Isobject(objBed) {
				Set BedDesc=objBed.BTDesc
			}
		}
		else{
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,aDate,"")
			Set BedDesc=$p(TransInfo,"^",4)		//0点床位
		}
		
		// 取患者aDate最近转病区的转科信息 需求：2839992 反复转床，导致转科日期为最近转床日期
		Set objTrans=""
		Set xDate=aDate+1
		For {
			Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeDr,xDate),-1)
			Quit:((xDate="")||($IsObject(objTrans)))
			Set xTranID=""
			For {
				Set xTranID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","W",EpisodeDr,xDate,xTranID),-1)
				Quit:((xTranID="")||($IsObject(objTrans)))
			
				Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTranID)
				Continue:'$IsObject(objTrans)
				Set PATransLocDr = objTrans.PATransLocDr.%Id()
				Set:idxLocDr'=PATransLocDr objTrans=""
				//当天出再入再出，算出O状态，出入科日期该为当天第一次出所对应的出入科时间
				Set:((idxStatus="O")&&(xDate=aDate)) objTrans=""
			}
		}
		
		If (idxStatus="I")||(idxStatus="O")||(idxStatus["A")||((idxStatus["A2")) {
			Set PAAdmDate=objTrans.PATransDate    //转入日期
			//Set:PAAdmDate'="" PAAdmDate=$zd(PAAdmDate,3)
			Set:PAAdmDate'="" PAAdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAAdmDate)
		} Else {
			Set PAAdmDate=""
		}
		If (idxStatus="O")||(idxStatus["A")||(idxStatus["I")||(idxStatus["A2") {
			Set PADischDate=objTrans.PAOutLocDate
			//Set:PADischDate'="" PADischDate=$zd(PADischDate,3)
			Set:PADischDate'="" PADischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PADischDate)
		} Else {
			Set PADischDate=""
		}
		
		Set (IsPICC,IsVAP,IsUC,IsPICCO,IsVAPO,IsUCO,IsCVC,IsCVCO,IsCRRT,IsCRRTO,IsPORT,IsPORTO)=0
		//当天带管情况
		Set ArrCnt = ##class(DHCHAI.IRS.ICULogDtlSrv).GetCntByPaAdm(aLocDr,aDate,EpisodeDr)
		Set PICCCnt = +$p(ArrCnt,"^",1)
		Set VAPCnt  = +$p(ArrCnt,"^",2)
		Set UCCnt   = +$p(ArrCnt,"^",3)
		Set CVCCnt  = +$p(ArrCnt,"^",5)
		Set CRRTCnt = +$p(ArrCnt,"^",6)
		Set PORTCnt = +$p(ArrCnt,"^",7)
		//前一天带管情况
		Set ArrCnt = ##class(DHCHAI.IRS.ICULogDtlSrv).GetCntByPaAdm(aLocDr,aDate-1,EpisodeDr)
		Set PICCCntO = +$p(ArrCnt,"^",1)
		Set VAPCntO  = +$p(ArrCnt,"^",2)
		Set UCCntO   = +$p(ArrCnt,"^",3)
		Set CVCCntO  = +$p(ArrCnt,"^",5)
		Set CRRTCntO = +$p(ArrCnt,"^",6)
		Set PORTCntO = +$p(ArrCnt,"^",7)
		//是否带管情况
		Set:PICCCnt>0 IsPICC = "1"  //是否带管标志
		Set:PICCCntO>0 IsPICCO = "1"  //之前是否带管标志
		Set:UCCnt>0 IsUC = "1"
		Set:UCCntO>0 IsUCO = "1"
		Set:VAPCnt>0 IsVAP = "1"
		Set:VAPCntO>0 IsVAPO = "1"
		
		Set:CVCCnt>0 IsCVC = "1"
		Set:CVCCntO>0 IsCVCO = "1"
		Set:CRRTCnt>0 IsCRRT = "1"
		Set:CRRTCntO>0 IsCRRTO = "1"
		Set:PORTCnt>0 IsPORT = "1"
		Set:PORTCntO>0 IsPORTO = "1"
		//体重
		Set PatWeight = objAdm.PAAdmitWeight
		Set PatApgar =objAdm.PAApgar
		Set:PatApgar["H" PatApgar=$p(PatApgar,"H",1)
		Set Date=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(aDate)
		//多语言处理
		Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
		Set:Age["月" Age=$Replace(Age,"月",##class(websys.Translation).Get("Bill.Com.Age","月"))
		Set:Age["天" Age=$Replace(Age,"天",##class(websys.Translation).Get("Bill.Com.Age","天"))
		Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
		Set Data=$lb(ind,LocID,LocDesc,Date)
		Set Data=Data_$lb(EpisodeDr,PatType,PapmiNo,objAdm.%Id(),PatientName,Sex,Age,BedDesc,PAAdmDate,PADischDate)
		Set Data=Data_$lb(IsPICC,IsPICCO,IsUC,IsUCO,IsVAP,IsVAPO,PatWeight,PatApgar,IsCVC,IsCVCO,IsCRRT,IsCRRTO,IsPORT,IsPORTO)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryICUAdmStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUAdmStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUAdmStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUAdmStrExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-07-07
/// Description:  查询ICU在科患者总数
/// Table：       
/// Input：       flag =0 三管医嘱 flag=1 静脉置管 2 呼吸机 3 导尿管
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICULogSrv","QryICUAdmOeItem","1998","0")
Query QryICUAdmOeItem(aPaAdm As %String, aFlag As %String) As %Query(ROWSPEC = "RowID:%String,PaAdm:%String,OeItemType:%String,OeItemDesc:%String,OeItemBak:%String,StartDt:%String,EndDt:%String,TypeValue:%String,TubeType:%String,OrdItemID:%String")
{
}

ClassMethod QryICUAdmOeItemExecute(ByRef qHandle As %Binary, aPaAdm As %String, aFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aPaAdm="")||(aFlag="") $$$OK 	
 	
	Set (OeItemType,OeItemDesc,OeItemBak,StartDt,EndDt,TypeValue)=""
	//DHCHAI.DP.OEItmCat DHCHAI.DP.OEItmMast DHCHAI.DP.OEItmMastMap DHCHAI.DP.OEOrdItem
	Set xSCode= ""
	For {		
		Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aPaAdm,xSCode))  //子系统索引
		Quit:xSCode=""
		Set xOrdItemDesc = "" 
		For {
			Set xOrdItemDesc = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aPaAdm,xSCode,xOrdItemDesc))
			Quit:xOrdItemDesc=""
			Set xUpdateDate =""
			For {
			Set xUpdateDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aPaAdm,xSCode,xOrdItemDesc,xUpdateDate))
				Quit:xUpdateDate=""
				Set xOrdItemID ="" 
				For {
					Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aPaAdm,xSCode,xOrdItemDesc,xUpdateDate,xOrdItemID))
					Quit:xOrdItemID="" 
					Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
					Continue:'$Isobject(objOrdItem)
					Set IsActive=objOrdItem.OEIsActive
					Continue:IsActive'=1
					Set OrdStatus=objOrdItem.OEOrdStatus
					Continue:OrdStatus="作废"			//过滤作废医嘱
					//取的临床医嘱名称
					Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xSCode,xOrdItemDesc,""))	
					Continue:xMastMapID=""
					Set objMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xMastMapID)
					Continue:'$Isobject(objMap)			
					Continue:'$Isobject(objMap.BTMapItemDr)  //治疗医嘱项  
					Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  //治疗医嘱分类
					
					Set BTCode = objMap.BTMapItemDr.BTCatDr.BTCode 
					Continue:(aFlag=0)&&(BTCode'["PICC")&&(BTCode'["UC")&&(BTCode'["VAP")
					Continue:(aFlag=1)&&(BTCode'["PICC")
					Continue:(aFlag=2)&&(BTCode'["VAP")
					Continue:(aFlag=3)&&(BTCode'["UC")
					
					Set OeItemType=$s(BTCode["PICC":"中央血管导管",BTCode["VAP":"呼吸机",BTCode["UC":"导尿管",1:"其他") 
					Set OeItemDesc =objOrdItem.OEOrdDesc
					Set EndDt=""
					if (objOrdItem.OESttDate'="")
					{
						//Set StartDt = $zd(objOrdItem.OESttDate,3)
						Set StartDt=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objOrdItem.OESttDate)
						Set:objOrdItem.OESttTime'="" StartDt = StartDt_" "_$zt(objOrdItem.OESttTime,1)
					}
					if (objOrdItem.OEXDate'="")
					{
						//Set EndDt = $zd(objOrdItem.OEXDate,3)
						Set EndDt=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objOrdItem.OEXDate)
						Set:objOrdItem.OEXTime'="" EndDt = EndDt_" "_$zt(objOrdItem.OEXTime,1)
					}
					Set TypeValue =objOrdItem.OEPriority  //备用			
					Set Data=$lb(ind,aPaAdm)
					Set TubeType=$p(BTCode,"-",3)
					Set HISOrdItemID=objOrdItem.OEXCode
					//多语言处理
					Set OeItemDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",OeItemDesc,"User.ARCItmMast")
					Set Data=Data_$lb(OeItemType,OeItemDesc,OeItemBak,StartDt,EndDt,TypeValue,TubeType,HISOrdItemID)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}

	}
	
	
	/* 测试数据
	If (aFlag="0")||(aFlag="1") {
		Set OeItemType="中心静脉置管"  //导尿管  呼吸机
		Set OeItemDesc ="三腔静脉导管"
		Set StartDt = "2017-07-01 09:00:00"
		Set Data=$lb(ind,aPaAdm)
		Set Data=Data_$lb(OeItemType,OeItemDesc,OeItemBak,StartDt,EndDt,TypeValue)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (aFlag="0")||(aFlag="3") {
		Set (OeItemType,OeItemDesc,OeItemBak,StartDt,EndDt,TypeValue)=""
		Set OeItemType="导尿管"  //  呼吸机
		Set OeItemDesc ="导尿管(国产)"
		Set StartDt="2017-07-01 09:00:00"
		Set Data=$lb(ind,aPaAdm)
		Set Data=Data_$lb(OeItemType,OeItemDesc,OeItemBak,StartDt,EndDt,TypeValue)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (aFlag="0")||(aFlag="2") {
		Set (OeItemType,OeItemDesc,OeItemBak,StartDt,EndDt,TypeValue)=""
		Set OeItemType="呼吸机"  
		Set OeItemDesc ="呼吸机(国产)"
		Set StartDt="2017-09-01 09:00:00"
		Set Data=$lb(ind,aPaAdm)
		Set Data=Data_$lb(OeItemType,OeItemDesc,OeItemBak,StartDt,EndDt,TypeValue)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	*/
	Quit $$$OK
}

ClassMethod QryICUAdmOeItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUAdmOeItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUAdmOeItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUAdmOeItemExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-07-06
/// Description:  查询NICU调查日志记录
/// Table：       DHCHAI.IR.ICULog
/// Input:        aYYMM,aLocDr
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICULogSrv","QryNAISByMonth","2020-01","28")
Query QryNAISByMonth(aYYMM As %String, aLocDr As %String) As %Query(ROWSPEC = "LogIndex:%String,AISID:%String,LocID:%String,LocDesc:%String,SurveryDate:%String,SurveryDay:%String,AISItem1:%String,AISItem2:%String,AISItem3:%String,AISItem4:%String,AISItem5:%String,AISItem6:%String,AISItem7:%String,AISItem8:%String,AISItem9:%String,AISItem10:%String,AISItem11:%String,AISItem12:%String,AISItem13:%String,AISItem14:%String,AISItem15:%String,AISItem16:%String,AISItem17:%String,AISItem18:%String,AISItem19:%String,AISItem20:%String") [ SqlProc ]
{
}

ClassMethod QryNAISByMonthExecute(ByRef qHandle As %Binary, aYYMM As %String, aLocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aYYMM="")||(aLocDr="") $$$OK
	
	Set FormDay=##class(DHCHAI.BT.Config).GetValByCode("ICULogFormDay")
	Set FormDay=+FormDay
	Set:(FormDay="")||(FormDay="0") FormDay="01"
	Set:$l(FormDay)=1 FormDay="0"_+FormDay
	Set:$l(FormDay)>2 FormDay="01"
	Set:FormDay>31 FormDay="01"

	Set xDateFrom=aYYMM_"-"_FormDay
	Set xDateFrom=$zdh(xDateFrom,3)
	Set xDateTo=xDateFrom+32
	Set xDateTo=$zd(xDateTo,3)
	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-"_FormDay
	Set xDateTo=$zdh(xDateTo,3)-1
	Set:xDateTo>+$h xDateTo = +$h    //最大到当天
	
	Set LocID=aLocDr
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
	Quit:'$Isobject(objLoc) $$$OK
	Quit:objLoc.BTIsNICU'=1 $$$OK
	Set LocDesc=objLoc.BTDesc2 //取本地数据对象
	Set:LocDesc="" LocDesc=objLoc.BTDesc
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Quit:LocDesc="" $$$OK
	
	Set LogIndex=0
	For xDate=xDateFrom:1:xDateTo {
		Quit:xDate>(+$h)
		
		Set (LogID,AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8)=""
		Set (AISItem9,AISItem10,AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)=""
		Set IsApgar=##class(DHCHAI.BT.Config).GetValByCode("NICUISApgar")
		if (IsApgar'=1){
		//NICU日志默认为1\2\3\4\5
		For xWtCat=1:1:5 {
			Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",aLocDr,xDate,xWtCat,0))  //是否确认
			Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
			If $IsObject(objLog) {
				Set LogID=LogID_","_xLogID
				
				If xWtCat=1 {
					Set AISItem1 = objLog.ILNewCnt
					Set AISItem2 = objLog.ILAdmCnt
					Set AISItem3 = objLog.ILIsPICC
					Set AISItem4 = objLog.ILIsVAP
				} ElseIf xWtCat=2 {
					Set AISItem5 = objLog.ILNewCnt
					Set AISItem6 = objLog.ILAdmCnt
					Set AISItem7 = objLog.ILIsPICC
					Set AISItem8 = objLog.ILIsVAP
				} ElseIf xWtCat=3 {
					Set AISItem9  = objLog.ILNewCnt
					Set AISItem10 = objLog.ILAdmCnt
					Set AISItem11 = objLog.ILIsPICC
					Set AISItem12 = objLog.ILIsVAP
				} ElseIf xWtCat=4 {
					Set AISItem13 = objLog.ILNewCnt
					Set AISItem14 = objLog.ILAdmCnt
					Set AISItem15 = objLog.ILIsPICC
					Set AISItem16 = objLog.ILIsVAP
				} ElseIf xWtCat=5 {
					Set AISItem17 = objLog.ILNewCnt
					Set AISItem18 = objLog.ILAdmCnt
					Set AISItem19 = objLog.ILIsPICC
					Set AISItem20 = objLog.ILIsVAP
				}
			}
		}
		}else{
		for xApGroup=0:1:4 {
			Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDateApGroup",aLocDr,xDate,xApGroup,0))  //是否确认
			Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
			If $IsObject(objLog) {
				Set LogID=LogID_","_xLogID
				
				If xApGroup=1 {
					
					Set AISItem1 = objLog.ILNewCnt
					Set AISItem2 = objLog.ILAdmCnt
					Set AISItem3 = objLog.ILIsPICC
					Set AISItem4 = objLog.ILIsVAP
				} ElseIf xApGroup=2 {
					
					Set AISItem5 = objLog.ILNewCnt
					Set AISItem6 = objLog.ILAdmCnt
					Set AISItem7 = objLog.ILIsPICC
					Set AISItem8 = objLog.ILIsVAP
				} ElseIf xApGroup=3 {
					Set AISItem9  = objLog.ILNewCnt
					Set AISItem10 = objLog.ILAdmCnt
					Set AISItem11 = objLog.ILIsPICC
					Set AISItem12 = objLog.ILIsVAP
				} ElseIf xApGroup=4 {
					Set AISItem13 = objLog.ILNewCnt
					Set AISItem14 = objLog.ILAdmCnt
					Set AISItem15 = objLog.ILIsPICC
					Set AISItem16 = objLog.ILIsVAP
				}
			}
			
		}
		}
		Set:LogID'="" LogID=$e(LogID,2,$l(LogID))
		
		Set SurveryDay=$p($zd(xDate,3),"-",3)
		Set SurveryDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xDate)
		
		Set LogIndex=LogIndex+1
		//多语言翻译
		Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
		Set Data=$lb(LogIndex,LogID,LocID,LocDesc,SurveryDate,SurveryDay)
		Set Data=Data_$lb(AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8)
		Set Data=Data_$lb(AISItem9,AISItem10,AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryNAISByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNAISByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryNAISByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNAISByMonthExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTransIDArray(aRstData As %Library.ArrayOfDataTypes, aDate As %String, aLocDr As %String, aStatus As %String) As %Library.ArrayOfDataTypes
{
	New (aRstData,aDate,aLocDr,aStatus)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDate="")||(aStatus="") return
	
	Set Key = 0
	For i=1:1:aRstData.Count()	//
	{
		Set TransInfo=aRstData.GetAt(i)
		Set idxDate = $LIST(TransInfo,1)
		Set idxStatus = $LIST(TransInfo,3)	
		Set idxLocID = 	$LIST(TransInfo,4)	
		Continue:idxDate'=aDate
		Continue:idxLocID'=aLocDr
		Continue:'(aStatus[idxStatus)   //支持多个状态入参	
		Set xTansID= +$LIST(TransInfo,5)    //多条取第一次记录
		Set Key=Key+1
		Do return.SetAt(xTansID,Key)
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-11-19
/// Description:  自动生成ICU日志明细信息
/// Table：       DHCHAI.DP.OEItmCat、DHCHAI.DP.OEItmMast、DHCHAI.DP.OEItmMastMap、DHCHAI.DP.OEOrdItem
/// Input：       aFromDate  :开始日期
///               aToDate    :结束日期
///               aLocDr     :调查科室(病区)
///               aEpisodeDr :就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.ICULogSrv).CreateICULogByOEOrd("2022-09-01","2022-09-01","6","W")
ClassMethod CreateICULogByOEOrd(aDateFrom As %String, aDateTo As %String, aLocDr As %String, aLocType As %String, aEpisodeDr As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLocDr,aLocType,aEpisodeDr)
	Set return=0
	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") return
	
	Set $ZT="CreateICULogByOEOrdErr"
	
	//日期格式转换
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	
	If (aEpisodeDr'=""){
		//根据就诊处理
		//Set arrEpisodeDr=##Class(%Library.ArrayOfDataTypes).%New()
		//Do arrEpisodeDr.SetAt(aEpisodeDr,1)
		Set objEpis=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
		Quit:'$IsObject(objEpis) return
		Set AdmDate=objEpis.PAAdmDate
		Set DischDate=objEpis.PADischDate
		
		For xDate=aDateFrom:1:aDateTo {
			Continue:(AdmDate'="")&(xDate<AdmDate)
			Continue:(DischDate'="")&(xDate>DischDate)
			
			//取某时间点患者所在科室、病区、床位信息
			Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeDr,xDate,"00:00:01")
			If (aLocType="W") {
				Set WardDr=$p(LocInfo,"^",5)   //所在病区
			}Else {
				Set WardDr=$p(LocInfo,"^",1)   //所在科室
			}
			
			//取值0点插管标志（IsVAP_"^"_IsPICC_"^"_IsUC）	
			Set RetStr=..GetICUStatus(aEpisodeDr,xDate,WardDr,aLocType)
			Set IsVAP  =+$p(RetStr,"^",1)
			Set IsPICC =+$p(RetStr,"^",2)
			Set IsUC   =+$p(RetStr,"^",3)
			Set IsCVC  =+$p(RetStr,"^",4)
			Set IsCRRT =+$p(RetStr,"^",5)
			Set IsPORT =+$p(RetStr,"^",6)
			
			Set IsOper = ""
			Set InputStr=""
			Set $p(InputStr,"^",2)=aEpisodeDr
			Set $p(InputStr,"^",3)=WardDr
			Set $p(InputStr,"^",4)=xDate
			Set $p(InputStr,"^",5)=IsVAP
			Set $p(InputStr,"^",6)=IsPICC
			Set $p(InputStr,"^",7)=IsUC
			Set $p(InputStr,"^",8)=IsOper
			Set $p(InputStr,"^",9)="A"
			Set $p(InputStr,"^",10)=IsCVC
			Set $p(InputStr,"^",11)=IsCRRT
			Set $p(InputStr,"^",12)=IsPORT
			
			Set flg=##class(DHCHAI.IR.ICULogDtl).Update(InputStr)
			If (+flg)>0 {
				Set return=return+1
			}
			
		}
		
	} Else {
		//根据日期查询患者
		If (aLocType="W") {
			Set arrEpisodeDr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(aDateFrom,aDateTo,"W",aLocDr,"I")
		}Else {
			Set arrEpisodeDr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E",aLocDr,"I")
		}
		For indEpis=1:1:arrEpisodeDr.Count() {
			Set TransInfo=arrEpisodeDr.GetAt(indEpis)
			Set idxDate = $LIST(TransInfo,1)
			Set idxEpisodeDr = $LIST(TransInfo,2)
			Set idxStatus = $LIST(TransInfo,3)
			Set idxLocID = $LIST(TransInfo,4)
			Continue:idxLocID'=aLocDr
			//取值0点插管标志（IsVAP_"^"_IsPICC_"^"_IsUC）
			Set RetStr=..GetICUStatus(idxEpisodeDr,idxDate,idxLocID,aLocType)
			Set IsVAP  =+$p(RetStr,"^",1)
			Set IsPICC =+$p(RetStr,"^",2)
			Set IsUC   =+$p(RetStr,"^",3)
			Set IsCVC  =+$p(RetStr,"^",4)
			Set IsCRRT =+$p(RetStr,"^",5)
			Set IsPORT =+$p(RetStr,"^",6)
			
			Set IsOper=""	
		
			Set InputStr=""
			Set $p(InputStr,"^",2)=idxEpisodeDr
			Set $p(InputStr,"^",3)=idxLocID
			Set $p(InputStr,"^",4)=idxDate
			Set $p(InputStr,"^",5)=IsVAP
			Set $p(InputStr,"^",6)=IsPICC
			Set $p(InputStr,"^",7)=IsUC
			Set $p(InputStr,"^",8)=IsOper
			Set $p(InputStr,"^",9)=idxStatus
			Set $p(InputStr,"^",10)=IsCVC
			Set $p(InputStr,"^",11)=IsCRRT
			Set $p(InputStr,"^",12)=IsPORT
			
			Set flg=##class(DHCHAI.IR.ICULogDtl).Update(InputStr)
			If (+flg)>0 {
				Set return=return+1
			}
		}
	}
	Quit return
	
CreateICULogByOEOrdErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-02-03
/// Description:  自动生成ICU日志汇总信息
/// Table：       DHCHAI.IR.ICULogDtl、DHCHAI.IR.ICULog
/// Input：       aFromDate :开始日期
///               aToDate   :结束日期
///               aLocDr    :调查科室(病区)
/// Return：      返回string
/// w ##class(DHCHAI.IRS.ICULogSrv).CreateICULogByDay("2018-04-01","2014-04-04","2330")
ClassMethod CreateICULogByDay(aDateFrom As %String, aDateTo As %String, aLocDr As %String, aLocType As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLocDr,aLocType)
	Set return=0
	Quit:(aDateFrom="")||(aDateTo="")||(aLocDr="") return
	
	Set $ZT="CreateICULogByDayErr"
	
	//日期格式转换
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	// ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocDr)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTTypeDr) return
	Set IsNICU=objLoc.BTIsNICU
	Set LocType=aLocType
	Set:LocType="" LocType = objLoc.BTTypeDr.BTCode
	Quit:(LocType'="W")&&(LocType'="E") return
	
	For xDate=aDateFrom:1:aDateTo {
		Kill arrResult
		If (LocType="W") {
			Set RstEpisArr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(xDate,xDate,"W",aLocDr,"I")
		}Else {
			Set RstEpisArr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(xDate,xDate,"E",aLocDr,"I")
		}
		For indEpis=1:1:RstEpisArr.Count(){
			Set TransInfo=RstEpisArr.GetAt(indEpis)
			Set idxDate = $LIST(TransInfo,1)
			Set idxEpisodeDr = $LIST(TransInfo,2)
			Set idxStatus = $LIST(TransInfo,3)
			Set idxLocID = $LIST(TransInfo,4)
			Continue:idxLocID'=aLocDr
			
			Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(idxEpisodeDr)
			Continue:'$IsObject(objEpisode)
			
			Set WtCat=0,ApGroup=0
			If IsNICU=1 {
				Set Weigth=objEpisode.PAAdmitWeight
				Set:Weigth="" WtCat=5
				Set Weigth=+Weigth
				Set:(Weigth>0)&(Weigth<=1000) WtCat=1
				Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
				Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
				Set:(Weigth>2500) WtCat=4
				Set Apgar=objEpisode.PAApgar
				Set:Apgar["H" Apgar=+$p(Apgar,"H",1)
				Set:(Apgar>=8)&(Apgar<=10) ApGroup=1
				Set:(Apgar>=4)&(Apgar<=7) ApGroup=2
				Set:(Apgar>=0)&(Apgar<=3) ApGroup=3
				Set:Apgar="" ApGroup=4
			}
			
			//入科人数=新入人数+当天入当天出
			if (idxStatus="I")||(idxStatus="A2") {
				Set num=$i(arrResult("WtCat",WtCat,"NewCnt"))
				Set num=$i(arrResult("ApGroup",ApGroup,"NewCnt"))
			}
			//在科人数=住在人数+新入人数+出科人数+当天入当天出
			if (idxStatus="A")||(idxStatus="I")||(idxStatus="O")||(idxStatus="A2") {
				Set num=$i(arrResult("WtCat",WtCat,"AdmCnt"))
				Set num=$i(arrResult("ApGroup",ApGroup,"AdmCnt"))
			}
			//出科人数+当天入当天出
			if (idxStatus="O")||(idxStatus="A2") {
				Set num=$i(arrResult("WtCat",WtCat,"OutCnt"))
				Set num=$i(arrResult("ApGroup",ApGroup,"OutCnt"))
			}
			Continue:(idxStatus'="A")&(idxStatus'="I")&(idxStatus'="O")&(idxStatus'="A2")
			Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",idxLocID,xDate,idxEpisodeDr,""))
			Continue:xDtlID=""
			Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xDtlID)
			Continue:'$IsObject(objDtl)
			Continue:'$IsObject(objDtl.ILEpisodeDr)
			
			Set WtCat=0
			If IsNICU=1 {
				Set Weigth=objDtl.ILEpisodeDr.PAAdmitWeight
				Set:Weigth="" WtCat=5
				Set Weigth=+Weigth
				Set:(Weigth>0)&(Weigth<=1000) WtCat=1
				Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
				Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
				Set:(Weigth>2500) WtCat=4
			}
				
			//使用呼吸机人数
			if objDtl.ILIsVAP=1 {
				Set num=$i(arrResult("WtCat",WtCat,"IsVAP"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsVAP"))
			}
			//脐/中心静脉置管人数
			if objDtl.ILIsPICC=1 {
				Set num=$i(arrResult("WtCat",WtCat,"IsPICC"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsPICC"))
			}
			//泌尿道插管人数
			if objDtl.ILIsUC=1 {
				Set num=$i(arrResult("WtCat",WtCat,"IsUC"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsUC"))
			}
			//手术患者人数
			if objDtl.ILIsOper=1 {
				Set num=$i(arrResult("WtCat",WtCat,"IsOper"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsOper"))
			}
			//CVC置管人数
			if objDtl.ILIsCVC=1 {
				Set num=$i(arrResult("WtCat",WtCat,"IsCVC"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsCVC"))
			}
			//CRRT置管人数
			if objDtl.ILIsCRRT=1 {
				Set num=$i(arrResult("WtCat",WtCat,"IsCRRT"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsCRRT"))
			}
			//PORT置管人数
			if objDtl.ILIsPORT=1 {
				Set num=$i(arrResult("WtCat",WtCat,"IsPORT"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsPORT"))
			}
			// ILIsJMZGSum 中心置管总人数
			If ((objDtl.ILIsPICC=1)||(objDtl.ILIsCVC=1)||(objDtl.ILIsCRRT=1)||(objDtl.ILIsPORT=1)){
				Set num=$i(arrResult("WtCat",WtCat,"IsJMZGSum"))
				Set num=$i(arrResult("ApGroup",ApGroup,"IsJMZGSum"))
			}
		}
		
		For xWtCat=0:1:5 {
			Continue:(IsNICU=1)&(xWtCat<1)
			Continue:(IsNICU'=1)&(xWtCat>0)
			
			Set NewCnt    = +$g(arrResult("WtCat",xWtCat,"NewCnt"))
			Set AdmCnt    = +$g(arrResult("WtCat",xWtCat,"AdmCnt"))
			Set OutCnt    = +$g(arrResult("WtCat",xWtCat,"OutCnt"))
			Set IsVAPCnt  = +$g(arrResult("WtCat",xWtCat,"IsVAP"))
			Set IsPICCCnt = +$g(arrResult("WtCat",xWtCat,"IsPICC"))
			Set IsUCCnt   = +$g(arrResult("WtCat",xWtCat,"IsUC"))
			Set IsOperCnt = +$g(arrResult("WtCat",xWtCat,"IsOper"))
			Set IsCVCCnt  = +$g(arrResult("WtCat",xWtCat,"IsCVC"))
			Set IsCRRTCnt = +$g(arrResult("WtCat",xWtCat,"IsCRRT"))
			Set IsPORTCnt = +$g(arrResult("WtCat",xWtCat,"IsPORT"))
			Set IsJMZGSum = +$g(arrResult("WtCat",xWtCat,"IsJMZGSum"))
			Set InputStr=""
			Set $p(InputStr,"^",2)=1   //医嘱来源
			Set $p(InputStr,"^",3)=aLocDr
			Set $p(InputStr,"^",4)=xDate
			Set $p(InputStr,"^",5)=IsVAPCnt
			Set $p(InputStr,"^",6)=IsPICCCnt
			Set $p(InputStr,"^",7)=IsUCCnt
			Set $p(InputStr,"^",8)=IsOperCnt
			Set $p(InputStr,"^",9)=NewCnt
			Set $p(InputStr,"^",10)=AdmCnt
			Set $p(InputStr,"^",11)=OutCnt
			Set $p(InputStr,"^",12)=xWtCat
			Set $p(InputStr,"^",13)=+$h
			Set $p(InputStr,"^",14)=$p($h,",",2)
			Set $p(InputStr,"^",15)=""
			Set $p(InputStr,"^",16)=""
			Set $p(InputStr,"^",17)=IsCVCCnt
			Set $p(InputStr,"^",18)=IsCRRTCnt
			Set $p(InputStr,"^",19)=IsPORTCnt
			Set $p(InputStr,"^",20)=IsJMZGSum
			Set flg=##class(DHCHAI.IR.ICULog).Update(InputStr,"^")
			If (+flg)>0 {
				Set return=return+1
			}
		}
		for xApGroup=0:1:4 {
			Continue:(IsNICU=1)&(xApGroup<1)
			Continue:(IsNICU'=1)&(xApGroup>0)
			Set NewCnt    = +$g(arrResult("ApGroup",xApGroup,"NewCnt"))
			Set AdmCnt    = +$g(arrResult("ApGroup",xApGroup,"AdmCnt"))
			Set OutCnt    = +$g(arrResult("ApGroup",xApGroup,"OutCnt"))
			Set IsVAPCnt  = +$g(arrResult("ApGroup",xApGroup,"IsVAP"))
			Set IsPICCCnt = +$g(arrResult("ApGroup",xApGroup,"IsPICC"))
			Set IsUCCnt   = +$g(arrResult("ApGroup",xApGroup,"IsUC"))
			Set IsOperCnt = +$g(arrResult("ApGroup",xApGroup,"IsOper"))
			Set IsCVCCnt  = +$g(arrResult("ApGroup",xApGroup,"IsCVC"))
			Set IsCRRTCnt = +$g(arrResult("ApGroup",xApGroup,"IsCRRT"))
			Set IsPORTCnt = +$g(arrResult("ApGroup",xApGroup,"IsPORT"))
			Set IsJMZGSum = +$g(arrResult("ApGroup",xApGroup,"IsJMZGSum"))
			Set InputStr=""
			Set $p(InputStr,"^",2)=1   //医嘱来源
			Set $p(InputStr,"^",3)=aLocDr
			Set $p(InputStr,"^",4)=xDate
			Set $p(InputStr,"^",5)=IsVAPCnt
			Set $p(InputStr,"^",6)=IsPICCCnt
			Set $p(InputStr,"^",7)=IsUCCnt
			Set $p(InputStr,"^",8)=IsOperCnt
			Set $p(InputStr,"^",9)=NewCnt
			Set $p(InputStr,"^",10)=AdmCnt
			Set $p(InputStr,"^",11)=OutCnt
			Set $p(InputStr,"^",12)=""
			Set $p(InputStr,"^",13)=+$h
			Set $p(InputStr,"^",14)=$p($h,",",2)
			Set $p(InputStr,"^",15)=""
			Set $p(InputStr,"^",16)=xApGroup
			Set $p(InputStr,"^",17)=IsCVCCnt
			Set $p(InputStr,"^",18)=IsCRRTCnt
			Set $p(InputStr,"^",19)=IsPORTCnt
			Set $p(InputStr,"^",20)=IsJMZGSum
			Set flg=##class(DHCHAI.IR.ICULog).Update(InputStr,"^")
			If (+flg)>0 {
				Set return=return+1
			}
		}
		Kill arrResult
	}
	Quit return
	
CreateICULogByDayErr
	Quit "-999^"_$ZError
}

/// Creator：     chenjb
/// CreatDate：   2017-11-20
/// Description:  是否新开 0 否 1 是 2 新停
/// Table：       
/// Input：       aEpisodeDr : 就诊号
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.ICULogSrv).IsStartOEOrd(1393)
ClassMethod IsStartOEOrd(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aType As %String) As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aType)
	Set return=0
	Quit:(aEpisodeDr="")||(aSttDate="")||(aEndDate="")||(aType="") return
	
	Set aSttDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
	Set aEndDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	
	Set (OeItemType,OeItemDesc,StartDt,EndDt,StartTime)=""
	//DHCHAI.DP.OEItmCat DHCHAI.DP.OEItmMast DHCHAI.DP.OEItmMastMap DHCHAI.DP.OEOrdItem
	/// 就诊医嘱开始日期索引
	//Index IndexEpisAntUseSttDate On (OEEpisodeDr, OESCode As Exact, OEAntUseFlag, OESttDate);
	Set xSCode=""
	For {		
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))  //子系统索引
		Quit:xSCode=""
		
		For xQryDate=aSttDate:1:aEndDate {
			Set xOrdItemID=""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,0,xQryDate,xOrdItemID))			
				Quit:xOrdItemID=""
				
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
				Continue:'$Isobject(objOrdItem)
				Continue:objOrdItem.OEIsActive'=1
				//Continue:objOrdItem.OEPriority["临时"
				//取的临床医嘱名称
				Set xOrdItemDesc = objOrdItem.OEOrdDesc
				Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xSCode,xOrdItemDesc,""))	
				Continue:xMastMapID=""
				Set objMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xMastMapID)
				Continue:'$Isobject(objMap)			
				Continue:'$Isobject(objMap.BTMapItemDr)  //治疗医嘱项  
				Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  //治疗医嘱分类
				Set BTCode = objMap.BTMapItemDr.BTCatDr.BTCode 
				Continue:(BTCode'["PICC")&&(BTCode'["UC")&&(BTCode'["VAP")
				
			    //某日住院科室病区床位信息
			    //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate("14109","2017-07-16","10:00")						
				Set:(BTCode[aType) return=1
				//最后一天不计算
				Quit:return=1
			}
		}
	}	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-11-20
/// Description:  是否新开 0 否 1 是 2 新停
/// Table：       DHCHAI.DP.OEItmCat DHCHAI.DP.OEItmMast DHCHAI.DP.OEItmMastMap DHCHAI.DP.OEOrdItem
/// Input：       aEpisodeDr : 就诊号
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.ICULogSrv).IsEndDtOEOrd(1393)
ClassMethod IsEndDtOEOrd(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aType As %String) As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aType)
	Set return=0
	Quit:(aEpisodeDr="")||(aSttDate="")||(aEndDate="")||(aType="") return
	
	Set aSttDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
	Set aEndDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	
	Set (OeItemType,OeItemDesc,StartDt,EndDt,StartTime)=""
	Set xSCode=""
	For {		
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode))  //子系统索引
		Quit:xSCode=""
		
		For xQryDate=aSttDate:1:aEndDate {
			Set xOrdItemID=""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode,0,xQryDate,xOrdItemID))			
				Quit:xOrdItemID=""
				
				Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
				Continue:'$Isobject(objOrdItem)
				Continue:objOrdItem.OEIsActive'=1
				//Continue:objOrdItem.OEPriority["临时"
				//取的临床医嘱名称
				Set xOrdItemDesc = objOrdItem.OEOrdDesc
				Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xSCode,xOrdItemDesc,""))	
				Continue:xMastMapID=""
				Set objMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xMastMapID)
				Continue:'$Isobject(objMap)			
				Continue:'$Isobject(objMap.BTMapItemDr)  //治疗医嘱项  
				Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  //治疗医嘱分类
				Set BTCode = objMap.BTMapItemDr.BTCatDr.BTCode 
				Continue:(BTCode'["PICC")&&(BTCode'["UC")&&(BTCode'["VAP")
				
			    //某日住院科室病区床位信息
			    //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate("14109","2017-07-16","10:00")						
				Set:(BTCode[aType) return=2
				//最后一天不计算
				Quit:return=2
			}
		}
	}	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-11-20
/// Description:  取0点时三管带管情况  
/// Table：       
/// Input：       aEpisodeDr : 就诊号
/// Return：      返回 VAP^PICC^UC
/// w ##class(DHCHAI.IRS.ICULogSrv).GetICUStatus(429,"2020-05-12")
ClassMethod GetICUStatus(aEpisodeDr As %String, aQryDate As %String, aLocID As %String, aLocType As %String) As %String
{
	New (aEpisodeDr,aQryDate,aLocID,aLocType)
	Set (IsPICC,IsUC,IsVAP,IsCVC,IsCRRT,IsPORT)="0"  //变量初始化
	Set return=IsVAP_"^"_IsPICC_"^"_IsUC_"^"_IsCVC_"^"_IsCRRT_"^"_IsPORT  //默认不带管
	Quit:(aEpisodeDr="")||(aQryDate="")||(aLocID="")||(aLocType="") return
	
	Set aQryDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aQryDate)
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Set DisDate =objPaadm.PADischDate
	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")
	//取0点患者所在科室、病区、床位信息
	Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeDr,aQryDate,"00:00:01")
	If (aLocType="W") {
		Set LocDr=$p(LocInfo,"^",5)   //所在病区
	}Else {
		Set LocDr=$p(LocInfo,"^",1)   //所在科室
	}
	Quit:(aLocID'=LocDr) return   //非0点所在科室，插管记录都为0
	Set IsOnlyStatOrder=##class(DHCHAI.BT.Config).GetValByCode("PICC-OEPriority") //PICC是否只有临时医嘱(与拔管医嘱成对构成长期)
	Kill arrICUOrdDate
	/// 就诊医嘱开始日期索引
	Set xSCode=""
	For {		
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,xSCode))  //子系统索引
		Quit:xSCode=""
		
		Set xOrdItemDesc="" 
		For {
			Set xOrdItemDesc=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,xSCode,xOrdItemDesc))
			Quit:xOrdItemDesc=""
			
			Set objMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(xSCode,xOrdItemDesc)
			Continue:'$Isobject(objMap)
			Continue:objMap.BTIsActive'=1
			Continue:'$Isobject(objMap.BTMapItemDr)          //治疗医嘱项
			Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  //治疗医嘱分类
			Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr.BTTypeDr)  //治疗医嘱类别
			Set OEItmMastDesc = objMap.BTMapItemDr.BTDesc    // 医嘱项名称
			Set OEItemType    = objMap.BTMapItemDr.BTCatDr.BTTypeDr.BTCode
			Continue:OEItemType'="DRT"
			Set OEItemCat = objMap.BTMapItemDr.BTCatDr.BTCode
			Continue:$e(OEItemCat,1,6)'="DRT-I-"
			
			Set xUpdateDate=""
			For {
				Set xUpdateDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,xSCode,xOrdItemDesc,xUpdateDate))
				Quit:xUpdateDate=""
				
				Set xOrdItemID ="" 
				For {
					Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,xSCode,xOrdItemDesc,xUpdateDate,xOrdItemID))
					Quit:xOrdItemID=""
					
					Set (OeItemType,OeItemDesc,StartDt,EndDt,StartTime)=""
					Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
					Continue:'$Isobject(objOrdItem)
					Set IsActive=objOrdItem.OEIsActive
					Continue:IsActive'=1
					
					Set OeItemDesc =objOrdItem.OEOrdDesc
					If (objOrdItem.OESttDate'="") {
						//Set StartDt = objOrdItem.OESttDate
						Set StartDt=##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(objOrdItem.OESttDate)
					}
					If (objOrdItem.OEXDate'=""){
						//Set EndDt = objOrdItem.OEXDate
						Set EndDt = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(objOrdItem.OEXDate)
					}
					Continue:StartDt=""
					
					Set OEPriority=objOrdItem.OEPriority
					If OEPriority["长期" {
						Set:EndDt="" EndDt=DisDate //出院未停医嘱，结束日期算到出院日期
						Set:EndDt="" EndDt=+$h     //未出院未停的医嘱，结束日期算到当前日期
						//Set StartDt=StartDt-1           //计算00:00:01时所在科室，医嘱开始第一天不计入
					} Else {
						//Set StartDt=StartDt-1           //计算00:00:01时所在科室，医嘱开始第一天不计入（PICC临时构成长期医嘱计算方式）
						Set EndDt=StartDt //临时医嘱生成开始日期一次
					}
					Set ICUOEType=""
					
					If (ICUPatLogSplit=1){  // 拆分，通过医嘱项名称去判定
						Set:OEItmMastDesc["PICC" ICUOEType="PICC"
						Set:OEItmMastDesc["CVC" ICUOEType="CVC"
						Set:OEItmMastDesc["CRRT" ICUOEType="CRRT"
						Set:OEItmMastDesc["PORT" ICUOEType="PORT"
						Set:OEItmMastDesc["脐静脉导管" ICUOEType="PICC"
					}Else{
						Set:OEItemCat["PICC" ICUOEType="PICC"
					}
					Set:OEItemCat["UC" ICUOEType="UC"
					Set:OEItemCat["VAP" ICUOEType="VAP"
					Continue:ICUOEType=""
					If ((ICUOEType="PICC")||(ICUOEType="CVC")||(ICUOEType="CRRT")||(ICUOEType="PORT"))&&(OeItemDesc["拔") {
						Set arrICUOrdDate(ICUOEType,0,StartDt,xOrdItemID)=$lb(StartDt,EndDt,OEPriority)
					} Else {
						Set arrICUOrdDate(ICUOEType,1,StartDt,xOrdItemID)=$lb(StartDt,EndDt,OEPriority)
					}
				}
			}
		}
	}
	
	Set xICUOEType=""
	For {
		Set xICUOEType=$o(arrICUOrdDate(xICUOEType))
		Quit:xICUOEType=""
		Quit:(xICUOEType="PICC")&&(IsPICC=1)
		Quit:(xICUOEType="UC")&&(IsUC=1)
		Quit:(xICUOEType="VAP")&&(IsVAP=1)
		Quit:(xICUOEType="CVC")&&(IsCVC=1)
		Quit:(xICUOEType="CRRT")&&(IsCRRT=1)
		Quit:(xICUOEType="PORT")&&(IsPORT=1)
		Set xSttDate=0,IsZero =0
		For {
			Set xSttDate=$o(arrICUOrdDate(xICUOEType,1,xSttDate))
			Quit:xSttDate=""
			Quit:(xICUOEType="PICC")&&(IsPICC=1)
			Quit:(xICUOEType="UC")&&(IsUC=1)
			Quit:(xICUOEType="VAP")&&(IsVAP=1)
			Quit:(xICUOEType="CVC")&&(IsCVC=1)
			Quit:(xICUOEType="CRRT")&&(IsCRRT=1)
			Quit:(xICUOEType="PORT")&&(IsPORT=1)
			Continue:xSttDate>aQryDate
			
			Set xOrdID=""
			For {
				Set xOrdID=$o(arrICUOrdDate(xICUOEType,1,xSttDate,xOrdID))
				Quit:xOrdID=""
				Quit:(xICUOEType="PICC")&&(IsPICC=1)
				Quit:(xICUOEType="UC")&&(IsUC=1)
				Quit:(xICUOEType="VAP")&&(IsVAP=1)
				Quit:(xICUOEType="CVC")&&(IsCVC=1)
				Quit:(xICUOEType="CRRT")&&(IsCRRT=1)
				Quit:(xICUOEType="PORT")&&(IsPORT=1)
				Set tmpInfo=$g(arrICUOrdDate(xICUOEType,1,xSttDate,xOrdID))
				Continue:tmpInfo=""
				Set OEPriority=$listget(tmpInfo,3)
				If ((xICUOEType="PICC")||(xICUOEType="CVC")||(xICUOEType="CRRT")||(xICUOEType="PORT")) {
					If IsOnlyStatOrder=1 {
						Set EndDt=$o(arrICUOrdDate(xICUOEType,0,xSttDate))
						Set:EndDt="" EndDt=DisDate //出院未停医嘱，结束日期算到出院日期
						Set:EndDt="" EndDt=+$h     //未出院未停的医嘱，结束日期算到当前日期
						Continue:EndDt<aQryDate
						Set:(xSttDate<aQryDate)&&(EndDt>=aQryDate) IsZero =1
					}Else {
						Set EndDt=$listget(tmpInfo,2)
						If (OEPriority["长期") {
							Set:(xSttDate<aQryDate)&&(EndDt>=aQryDate) IsZero =1
						}else {
							Set IsZero =0
						}
					}
					Continue:EndDt<aQryDate
				}Else {
					Set EndDt=$listget(tmpInfo,2)
					If (OEPriority["长期") {
						Set:(xSttDate<aQryDate)&&(EndDt>=aQryDate) IsZero =1
					}else {
						Set IsZero =0
					}
					Continue:EndDt<aQryDate
				}

				Set:(xICUOEType="PICC")&&(IsZero=1) IsPICC=1
				Set:(xICUOEType="UC")&&(IsZero=1) IsUC=1
				Set:(xICUOEType="VAP")&&(IsZero=1) IsVAP=1
				Set:(xICUOEType="CVC")&&(IsZero=1) IsCVC=1
				Set:(xICUOEType="CRRT")&&(IsZero=1) IsCRRT=1
				Set:(xICUOEType="PORT")&&(IsZero=1) IsPORT=1
				Quit //退出
			}
		}
	}
	Kill arrICUOrdDate
	Set return=IsVAP_"^"_IsPICC_"^"_IsUC_"^"_IsCVC_"^"_IsCRRT_"^"_IsPORT //最后结果
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-10-19
/// Description:  三管使用日数
/// Table：       
/// Input：       aLocDr : 科室  aDateFrom,aDateTo : 调查日期  aWtCat : 体重分类(0:成人,1/2/3/4新生儿体重分类)
/// Return：      返回 VAP^PICC^UC使用天数(每天使用人数相加)
/// w ##class(DHCHAI.IRS.ICULogSrv).GetICUDates("","2018-01-01","2018-04-10","")
ClassMethod GetICUDates(aLocDr As %String, aDateFrom As %String, aDateTo As %String, aWtCat As %String = "") As %String
{
	New (aLocDr,aDateFrom,aDateTo,aWtCat)
	Set (IsVAP,IsPICC,IsUC)="0"  //变量初始化(呼吸机,中心静脉置管,尿管)
	Set return=IsVAP_"^"_IsPICC_"^"_IsUC  //默认不带管
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	If (aLocDr'=""){
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocDr)
		Quit:'$IsObject(objLoc)
		
		For xDate=aDateFrom:1:aDateTo{
			Set xWtCat=""
			For {
				Set xWtCat=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",aLocDr,xDate,xWtCat))
				Quit:xWtCat=""
				Continue:(aWtCat'="")&&(aWtCat'=xWtCat)
				
				Set xICULogID=""
				For {
					Set xICULogID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",aLocDr,xDate,xWtCat,xICULogID))
					Quit:xICULogID=""
					
					Set objICULog=##class(DHCHAI.IR.ICULog).GetObjById(xICULogID)
					Continue:'$IsObject(objICULog)
					
					Set IsPICC	=IsPICC + objICULog.ILIsPICC
					Set IsVAP	=IsVAP + objICULog.ILIsVAP
					Set IsUC	=IsUC + objICULog.ILIsUC
				}
			}
		}
	} Else {
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",xLocID))
			Quit:xLocID=""
			
			For xDate=aDateFrom:1:aDateTo{
				Set xWtCat=""
				For {
					Set xWtCat=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",xLocID,xDate,xWtCat))
					Quit:xWtCat=""
					Continue:(aWtCat'="")&&(aWtCat'=xWtCat)
					
					Set xICULogID=""
					For {
						Set xICULogID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",xLocID,xDate,xWtCat,xICULogID))
						Quit:xICULogID=""
						
						Set objICULog=##class(DHCHAI.IR.ICULog).GetObjById(xICULogID)
						Continue:'$IsObject(objICULog)
						
						Set IsPICC	=IsPICC + objICULog.ILIsPICC
						Set IsVAP	=IsVAP + objICULog.ILIsVAP
						Set IsUC	=IsUC + objICULog.ILIsUC
					}
				}
			}
		}
	}
	Set return=IsVAP_"^"_IsPICC_"^"_IsUC  //最后结果
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-10-19
/// Description:  三管使用人数
/// Table：       
/// Input：       aLocDr : 科室  aDateFrom,aDateTo : 调查日期  aWtCat : 体重分类(0:成人,1/2/3/4新生儿体重分类)
/// Return：      返回 VAP^PICC^UC使用人数
/// w ##class(DHCHAI.IRS.ICULogSrv).GetICUAdmNum("","2018-01-01","2018-04-10","")
ClassMethod GetICUAdmNum(aLocDr As %String, aDateFrom As %String, aDateTo As %String, aWtCat As %String = "")
{
	New (aLocDr,aDateFrom,aDateTo,aWtCat)
	Set (IsVAP,IsPICC,IsUC)="0"  //变量初始化(呼吸机,中心静脉置管,尿管)
	Set return=IsVAP_"^"_IsPICC_"^"_IsUC  //默认不带管
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set NIndex="ICUAdmNum"
	Kill ^TMP($zn,$j,NIndex)
	If (aLocDr'=""){
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocDr)
		Quit:'$IsObject(objLoc) return
		Set IsNICU=objLoc.BTIsNICU
		
		For xDate=aDateFrom:1:aDateTo{
			Set xAdmID=""
			For {
				Set xAdmID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocDr,xDate,xAdmID))
				Quit:xAdmID=""
				
				Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocDr,xDate,xAdmID,""))
				Continue:xDtlID=""
				Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xDtlID)
				Continue:'$IsObject(objDtl)
				Continue:'$IsObject(objDtl.ILEpisodeDr)
				Set IsNewBaby=objDtl.ILEpisodeDr.PAIsNewBaby
					
				Set WtCat=0
				If IsNewBaby=1 {
					Set Weigth=objDtl.ILEpisodeDr.PAAdmitWeight
					Set Weigth=+Weigth
					Set:(Weigth<=1000) WtCat=1
					Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
					Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
					Set:(Weigth>2500) WtCat=4
				}
				Continue:(aWtCat'="")&&(aWtCat'=WtCat)
				
				//使用呼吸机人数
				If (objDtl.ILIsVAP=1)&&('$d(^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsVAP"))){
					Set ^TMP($zn,$j,NIndex,"IsVAP")=$i(^TMP($zn,$j,NIndex,"IsVAP"))
					Set ^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsVAP")=""
				}
				//脐/中心静脉置管人数
				If (objDtl.ILIsPICC=1)&&('$d(^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsPICC"))){
					Set ^TMP($zn,$j,NIndex,"IsPICC")=$i(^TMP($zn,$j,NIndex,"IsPICC"))
					Set ^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsPICC")=""
				}
				//泌尿道插管人数
				If (objDtl.ILIsUC=1)&&('$d(^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsUC"))){
					Set ^TMP($zn,$j,NIndex,"IsUC")=$i(^TMP($zn,$j,NIndex,"IsUC"))
					Set ^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsUC")=""
				}
			}
			
		}
	} Else {
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",xLocID))
			Quit:xLocID=""
			
			For xDate=aDateFrom:1:aDateTo{
				Set xAdmID=""
				For {
					Set xAdmID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",xLocID,xDate,xAdmID))
					Quit:xAdmID=""
					
					Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",xLocID,xDate,xAdmID,""))
					Continue:xDtlID=""
					Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xDtlID)
					Continue:'$IsObject(objDtl)
					Continue:'$IsObject(objDtl.ILEpisodeDr)
					Set IsNewBaby=objDtl.ILEpisodeDr.PAIsNewBaby
					
					Set WtCat=0
					If IsNewBaby=1 {
						Set Weigth=objDtl.ILEpisodeDr.PAAdmitWeight
						Set Weigth=+Weigth
						Set:(Weigth<=1000) WtCat=1
						Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
						Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
						Set:(Weigth>2500) WtCat=4
					}
					Continue:(aWtCat'="")&&(aWtCat'=WtCat)
					
					//使用呼吸机人数
					If (objDtl.ILIsVAP=1)&&('$d(^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsVAP"))){
						Set ^TMP($zn,$j,NIndex,"IsVAP")=$i(^TMP($zn,$j,NIndex,"IsVAP"))
						Set ^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsVAP")=""
					}
					//脐/中心静脉置管人数
					If (objDtl.ILIsPICC=1)&&('$d(^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsPICC"))){
						Set ^TMP($zn,$j,NIndex,"IsPICC")=$i(^TMP($zn,$j,NIndex,"IsPICC"))
						Set ^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsPICC")=""
					}
					//泌尿道插管人数
					If (objDtl.ILIsUC=1)&&('$d(^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsUC"))){
						Set ^TMP($zn,$j,NIndex,"IsUC")=$i(^TMP($zn,$j,NIndex,"IsUC"))
						Set ^TMP($zn,$j,NIndex,"AdmID",xAdmID,"IsUC")=""
					}
				}
				
			}
		}
		
	}
	
	Set IsVAP=+$g(^TMP($zn,$j,NIndex,"IsVAP"))
	Set IsPICC=+$g(^TMP($zn,$j,NIndex,"IsPICC"))
	Set IsUC=+$g(^TMP($zn,$j,NIndex,"IsUC"))
	
	Kill ^TMP($zn,$j,NIndex)
	Quit IsVAP_"^"_IsPICC_"^"_IsUC
}

}

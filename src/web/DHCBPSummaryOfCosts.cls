Class web.DHCBPSummaryOfCosts Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取病人费用汇总(透析费用、生理盐水、肝素)
/// registerId透析登记号，subType血透H或者腹透P
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfCosts","0000000015","","2022-01-01","2022-01-26","H","5261||1^5253||1^5251||1^5072||1^11006||1^5252||1")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfCosts","0000037443","","2021-02-22","2021-02-22","H","")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfCosts","0000000644","","2021-11-20","2021-11-20","H","2808||1^460||1^462||1^11500||1^11509||1^11510||1^11553||1^11722||1^2809||1^461||1^2810||1^2812||1^463||1^1657||1^2596||1^2601||1^153||1^7761||1^1714||1")
Query FindSummaryOfCosts(regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Query(ROWSPEC = "registerId,ItemName,ColDesc,ResultStr") [ SqlProc ]
{
}

ClassMethod FindSummaryOfCostsExecute(ByRef qHandle As %Binary, regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^tmpDylBlood($j)
	k ^tmpArrangeBlood($j)	
 	i regNum="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	s registerId=##class(web.DHCBPSummaryOfCosts).FindregisterId(regNum)
	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	
	s bpprPatDeptDr=$lg(^DHCBPPatRegister(registerId),30)
	//s locId=249
	s locId=##Class(web.DHCBPCom).GetLinkAdmLocByLocId(bpprPatDeptDr) //科室关联	
	//HD：血液透析(HD)(药费.材料均不另收)(肾内科)
	//s ArcimIdHD="2808||1"
	//s ArcimIdHD1="460||1"
	
	//HDF：血液透析滤过(HDF)基价(其它另收)^
	//s ArcimIdHDF="2810"
	//HP：血液灌流(PE)基价(其它另收)
	//s ArcimIdHP="18597||1"
	;s ArcimIdStr=ArcimIdHD_"^"_ArcimIdHDF_"^"_ArcimIdHD1
	
	s ArcimIdStr=arcimsStr
	s bpoiId="" //实际使用次数(药品)
	f curDate=startDate:1:endDate d
	.f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,registerId,bpoiId)) q:bpoiId=""  d
		..s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
		..
	    ..q:bpoiOrderTypeCode'="N"
	    ..s bpoiStatus=$lg(^DHCBPOrderItem(bpoiId),13)
	    ..q:(bpoiStatus'="E")
	    ..s bpoiExecDate=$li(^DHCBPOrderItem(bpoiId),27)
	    ..s dateYear=$p($zd(bpoiExecDate,3),"-",1)
		..s dateMonth=+$p($zd(bpoiExecDate,3),"-",2)	
		..s arcimId=$li(^DHCBPOrderItem(bpoiId),4)
		..q:("^"_ArcimIdStr_"^")'[("^"_arcimId_"^")  
	    ..s arcimSub=$p(arcimId,"||",1)
	    ..s arcimVer=$p(arcimId,"||",2)
	    ..s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
		..s bpaDate=$zd(curDate,3)
		..s monthCount=0
		..if ($d(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpoiExecDate))>0) s monthCount=$P(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpoiExecDate),"|",6)
		..s phQtyOrd=monthCount+1
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(bpaDate,"-",1,2)_"|"_phQtyOrd
		..s ^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpoiExecDate)=resultStr
		..s ^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=curDate
		..//w arcimDesc_"/"_dateYear_"/"_dateMonth_"/"_bpaDate_"/"_orderLastDate,!
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(bpaDate,"-",1,2)_"|"_"0"
		..s ^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=$zdh(bpaDate,3)
		..s ^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth)="0"
		..s ^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpaDate)=resultStr
	
	s rset=##class(%ResultSet).%New("web.DHCBPOrder:FindHisOrderItemBySummary")	
	;w registerId_"/"_startDate_"/"_endDate_"/"_""_"/"_"N"_"/"_locId,!
	do rset.Execute(registerId,startDate,endDate,"","N",locId,"0")
	while (rset.Next()) {		
		//w rset.GetData(20),!
		s phQtyOrd=rset.GetData(20) //数量
		s createDate=rset.GetData(21) //开医嘱日期
		s createTime=rset.GetData(22) //开医嘱时间
		s orderStatus=rset.GetData(18)
		b ;111
		i orderStatus'="P" CONTINUE 
		//w createDate_"/"_createTime,!
		s orderDate=$zd(createDate,3) //_" "_$zt(createTime,2)
		s dateYear=$p($zd(createDate,3),"-",1)
		s dateMonth=+$p($zd(createDate,3),"-",2)
		s arcimId=rset.GetData(5)
		i ("^"_ArcimIdStr_"^")'[("^"_arcimId_"^") CONTINUE 
		s arcimDesc=rset.GetData(6)
		s monthCount=0,tempdate=createDate
		if ($d(^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth))>0) s monthCount=^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth)
		if ($d(^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth))>0) s tempdate=^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)
		s phQtyOrd=phQtyOrd+monthCount
		
		if ($d(^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))=0) d
		.s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDate,"-",1,2)_"|"_"0"
		.s ^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3))=resultStr
		.s ^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=createDate
		s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_phQtyOrd
		s dayCount=0
		if ($d(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3)))>0) s dayCount=$p(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3)),"|",6)
		
		s tempresultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_(rset.GetData(20)+dayCount)
		
		s ^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=createDate
		s ^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth)=phQtyOrd
		s ^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3))=tempresultStr
		
	}	
	d rset.Close()
	s registerId=""  f  s registerId=$o(^tmpDylBlood($j,"Result",registerId)) q:registerId=""  d
		.s arcimId=""  f  s arcimId=$o(^tmpDylBlood($j,"Result",registerId,arcimId)) q:arcimId=""  d
			..s reStr="",colDesc=""
			..s dateYear=""  f  s dateYear=$o(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear)) q:dateYear=""  d
				...s dateMonth=""  f  s dateMonth=$o(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth)) q:dateMonth=""  d
			 		....s dateMonthStr=""
			 		....s monthCount="",orderDateStr="",arcimDesc="" //,dateYear=""	
			 		....s orderDate=""  f  s orderDate=$o(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
						.....s dateMonthStr=$g(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate))
						.....s arcimDesc=$p(dateMonthStr,"|",3)
						.....s monthCount=monthCount+$p(dateMonthStr,"|",6)
						.....s $p(dateMonthStr,"|",6)=monthCount
						.....;s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
						.....s orderDateStr=$g(^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))
						.....s orderDateStr=$zd(orderDateStr,3)
						.....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)
						.....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
			 		....i dateMonthStr'="" d
						.....i reStr="" s reStr=dateMonthStr
						.....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
						.....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
						.....e  s colDesc=colDesc_"|"_"缴费日期|次数"			
			 		....s arrOrder=$g(^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))
			 		....i arrOrder="" d
						.....s BPCBPMRowId=0,id=""
						.....f  s BPCBPMRowId=$o(^DHCBPC("BloodPurificationMode",BPCBPMRowId)) q:BPCBPMRowId=""  d
	    					......s Code=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),1)	    
	    					......q:Code'=arcimDesc
	    					......s id=BPCBPMRowId
	    				.....q:id=""
						.....s ^tmpArrangeBlood($j,"Result",registerId,id,dateYear,dateMonth,orderDateStr)=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDateStr,"-",1,2)_"|"_"0"
		..d OutputRow
	s registerId=""  f  s registerId=$o(^tmpDylBlood($j,"Result",registerId)) q:registerId=""  d
		.s arcimId=""  f  s arcimId=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId)) q:arcimId=""  d
			..s reStr="",realityStr="",colDesc="",cashstr=""
			..s dateYear=""  f  s dateYear=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear)) q:dateYear=""  d
				...s dateMonth=""  f  s dateMonth=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth)) q:dateMonth=""  d
					....s dateMonthStr=""
					....s monthCount="",orderDateStr="",arcimDesc="",monthTotal=0 //,dateYear=""
					....s orderDate=""  f  s orderDate=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
						.....s dateMonthStr=^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate)
						.....s arcimDesc=$p(dateMonthStr,"|",3)
						.....s monthCount=monthCount+$p(dateMonthStr,"|",6)
						.....s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
						.....//w arcimDesc_"|"_dateYear_"|"_dateMonth_"|"_$p(dateMonthStr,"|",3)_"|"_orderDateStr_"|"_monthCount,!
						.....s orderDateStr=$g(^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))
						.....s orderDateStr=$zd(orderDateStr,3)
						.....//w orderDateStr,!
						.....s dateMonthStr=patName_"|"_regNo_"|"_arcimDesc_"|"_$p(dateMonthStr,"|",4)_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
						.....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)02
						.....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
					....//w monthCount,!
					....//w dateMonthStr,!
					....i dateMonthStr'="" d
						.....
						.....i reStr="" s reStr=dateMonthStr
						.....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount		
						.....s qtyOrdCount=$g(^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth))
						.....i realityStr="" s realityStr=patName_"|"_regNo_"|"_arcimDesc_"|结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
						.....e  s realityStr=realityStr_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
						.....B
						.....s tempdateMonth=dateMonth
						.....i $l(dateMonth)=1 s tempdateMonth=0_dateMonth
						.....s tempdateMonth2=##class(web.DHCBPSummaryOfCosts).convertTheLastMonth(dateYear,tempdateMonth)
						.....i (dateYear=2021)&&(tempdateMonth="01") s lastcash=0
						.....e  s lastcash=##class(web.DHCBPSummaryOfCosts).GetPatMonthTotalSurplus(registerId,arcimId,tempdateMonth2)
						.....s monthTotal=lastcash+qtyOrdCount-monthCount
						.....S rest= ##class(web.DHCBPSummaryOfCosts).UpdatePatSurplus(registerId,arcimId,dateYear_tempdateMonth,monthTotal,"")
						.....q:rest'=0
						.....i cashstr="" s cashstr=patName_"|"_regNo_"|"_arcimDesc_"|上次总结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
						.....e  s cashstr=cashstr_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
						.....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
						.....e  s colDesc=colDesc_"|"_"缴费日期|次数"
			..d OutputRow
			..s reStr=realityStr
			..d OutputRow
			..s reStr=cashstr
			..d OutputRow
	k ^tmpDylBlood($j)
	k ^tmpArrangeBlood($j)			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(registerId,arcimDesc,colDesc,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSummaryOfCostsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSummaryOfCostsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfCostsAllLoc","0000032751","","2021-01-25","2021-02-04","H","2808||1^460||1^462||1^11500||1^11509||1^11510||1^11553||1^11722||1^2809||1^461||1^2810||1^2812||1^463||1^1657||1^2596||1^2601||1")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfCostsAllLoc","0000032751","","2021-02-01","2021-02-02","H")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfCostsAllLoc","0000032751","","2021-01-25","2021-01-26","H")
Query FindSummaryOfCostsAllLoc(regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Query(ROWSPEC = "registerId,ItemName,ColDesc,ResultStr") [ SqlProc ]
{
}

ClassMethod FindSummaryOfCostsAllLocExecute(ByRef qHandle As %Binary, regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^tmpDylBlood($j)
	k ^tmpArrangeBlood($j)	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	S A=0
	s registerId=""
	f  s registerId=$o(^DHCBPPatRegister(registerId),-1) q:(registerId="")!(registerId=0)  d
	.s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	.q:papmiId="" 
	.q:'$d(^PAPER(papmiId,"PAT",1)) 
	.q:$lg(^DHCBPPatRegister(registerId),14)="D"
	.d GetSummaryOfCosts()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetSummaryOfCosts()	
	//s registerId=##class(web.DHCBPSummaryOfCosts).FindregisterId(regNum)
	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	
	s bpprPatDeptDr=$lg(^DHCBPPatRegister(registerId),30)
	//s locId=197
	s locId=##Class(web.DHCBPCom).GetLinkAdmLocByLocId(bpprPatDeptDr) //科室关联	
	//HD：血液透析(HD)(药费.材料均不另收)(肾内科)
	s ArcimIdHD="2808||1"
	s ArcimIdHD1="460||1"
	
	//HDF：血液透析滤过(HDF)基价(其它另收)^
	s ArcimIdHDF="462||1"
	//HP：血液灌流(PE)基价(其它另收)
	s ArcimIdHP="18597||1"
	//s ArcimIdStr=ArcimIdHD_"^"_ArcimIdHDF_"^"_ArcimIdHD1
	
	s ArcimIdStr=arcimsStr
	
	s bpoiId="" //实际使用次数(药品)
	f curDate=startDate:1:endDate d
	.f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,registerId,bpoiId)) q:bpoiId=""  d
		..s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
		..
	    ..q:bpoiOrderTypeCode'="N"
	    ..s bpoiStatus=$lg(^DHCBPOrderItem(bpoiId),13)
	    ..q:(bpoiStatus'="E")
	    ..s bpoiExecDate=$li(^DHCBPOrderItem(bpoiId),27)
	    ..s dateYear=$p($zd(bpoiExecDate,3),"-",1)
		..s dateMonth=+$p($zd(bpoiExecDate,3),"-",2)	
		..s arcimId=$li(^DHCBPOrderItem(bpoiId),4)
		..q:("^"_ArcimIdStr_"^")'[("^"_arcimId_"^")  
	    ..s arcimSub=$p(arcimId,"||",1)
	    ..s arcimVer=$p(arcimId,"||",2)
	    ..s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
		..s bpaDate=$zd(curDate,3)
		..s monthCount=0
		..if ($d(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate))>0) s monthCount=$P(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate),"|",6)
		..s phQtyOrd=monthCount+1
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(bpaDate,"-",1,2)_"|"_phQtyOrd
		..s ^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate)=resultStr
		..s ^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth)=curDate
		..//w arcimDesc_"/"_dateYear_"/"_dateMonth_"/"_bpaDate_"/"_orderLastDate,!
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(bpaDate,"-",1,2)_"|"_"0"
		..s ^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth)=$zdh(bpaDate,3)
		..s ^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth)="0"
		..s ^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,bpaDate)=resultStr
		
	
	s rset=##class(%ResultSet).%New("web.DHCBPOrder:FindHisOrderItemBySummary")	
	;w registerId_"/"_startDate_"/"_endDate_"/"_""_"/"_"N"_"/"_locId,!
	do rset.Execute(registerId,startDate,endDate,"","N",locId,"0")
	while (rset.Next()) {		
		//w rset.GetData(20),!
		s phQtyOrd=rset.GetData(20) //数量
		s createDate=rset.GetData(21) //开医嘱日期
		s createTime=rset.GetData(22) //开医嘱时间
		s orderStatus=rset.GetData(18)
		i orderStatus'="P" CONTINUE 
		//w createDate_"/"_createTime,!
		s orderDate=$zd(createDate,3) //_" "_$zt(createTime,2)
		s dateYear=$p($zd(createDate,3),"-",1)
		s dateMonth=+$p($zd(createDate,3),"-",2)
		s arcimId=rset.GetData(5)
		i ("^"_ArcimIdStr_"^")'[("^"_arcimId_"^") CONTINUE 
		s arcimDesc=rset.GetData(6)
		s monthCount=0,tempdate=createDate
		if ($d(^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth))>0) s monthCount=^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth)
		if ($d(^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth))>0) s tempdate=^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth)
		s phQtyOrd=phQtyOrd+monthCount
		if ($d(^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth))=0) d
		.s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDate,"-",1,2)_"|"_"0"
		.s ^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3))=resultStr
		.s ^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth)=createDate
		s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_phQtyOrd
		s dayCount=0
		if ($d(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3)))>0) s dayCount=$p(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3)),"|",6)
		
	
		s tempresultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_(rset.GetData(20)+dayCount)
		s ^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth)=createDate
		s ^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth)=phQtyOrd
		s ^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3))=tempresultStr
		
	}	
	d rset.Close()
	s arcimId=""  f  s arcimId=$o(^tmpDylBlood($j,"Result",arcimId)) q:arcimId=""  d
		.s reStr="",colDesc=""
		.s dateYear=""  f  s dateYear=$o(^tmpDylBlood($j,"Result",arcimId,dateYear)) q:dateYear=""  d
			..s dateMonth=""  f  s dateMonth=$o(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth)) q:dateMonth=""  d
			 	...s dateMonthStr=""
			 	...s monthCount="",orderDateStr="",arcimDesc="" //,dateYear=""	
			 	...s orderDate=""  f  s orderDate=$o(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					....s dateMonthStr=$g(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate))
					....s arcimDesc=$p(dateMonthStr,"|",3)
					....s monthCount=monthCount+$p(dateMonthStr,"|",6)
					....s $p(dateMonthStr,"|",6)=monthCount
					....;s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
					....s orderDateStr=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth))
					....s orderDateStr=$zd(orderDateStr,3)
					....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)
					....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
			 	...i dateMonthStr'="" d
					....i reStr="" s reStr=dateMonthStr
					....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
					....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
					....e  s colDesc=colDesc_"|"_"缴费日期|次数"			
			 	...s arrOrder=$g(^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth))
			 	...i arrOrder="" d
					....s BPCBPMRowId=0,id=""
					....f  s BPCBPMRowId=$o(^DHCBPC("BloodPurificationMode",BPCBPMRowId)) q:BPCBPMRowId=""  d
	    				.....s Code=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),1)	    
	    				.....q:Code'=arcimDesc
	    				.....s id=BPCBPMRowId
	    			....q:id=""
					....s ^tmpArrangeBlood($j,"Result",id,dateYear,dateMonth,orderDateStr)=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDateStr,"-",1,2)_"|"_"0"
		.d OutputRow
	s arcimId=""  f  s arcimId=$o(^tmpArrangeBlood($j,"Result",arcimId)) q:arcimId=""  d
		.s reStr="",realityStr="",colDesc="",cashstr=""
		.s dateYear=""  f  s dateYear=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear)) q:dateYear=""  d
			..s dateMonth=""  f  s dateMonth=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth)) q:dateMonth=""  d
				...s dateMonthStr=""
				...s monthCount="",orderDateStr="",arcimDesc="" //,dateYear=""
				...s orderDate=""  f  s orderDate=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					....s dateMonthStr=^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)
					....s arcimDesc=$p(dateMonthStr,"|",3)
					....s monthCount=monthCount+$p(dateMonthStr,"|",6)
					....s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
					....//w arcimDesc_"|"_dateYear_"|"_dateMonth_"|"_$p(dateMonthStr,"|",3)_"|"_orderDateStr_"|"_monthCount,!
					....s orderDateStr=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth))
					....s orderDateStr=$zd(orderDateStr,3)
					....//w orderDateStr,!
					....s dateMonthStr=patName_"|"_regNo_"|"_arcimDesc_"|"_$p(dateMonthStr,"|",4)_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
					....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)02
					....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
				...//w monthCount,!
				...//w dateMonthStr,!
				...i dateMonthStr'="" d
					....
					....i reStr="" s reStr=dateMonthStr
					....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount		
					....s qtyOrdCount=$g(^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth))
					....i realityStr="" s realityStr=patName_"|"_regNo_"|"_arcimDesc_"|结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
					....e  s realityStr=realityStr_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
					....s tempdateMonth=dateMonth
					....i $l(dateMonth)=1 s tempdateMonth=0_dateMonth
					....s tempdateMonth2=##class(web.DHCBPSummaryOfCosts).convertTheLastMonth(dateYear,tempdateMonth)
					....i (dateYear=2021)&&(tempdateMonth="01") s lastcash=0
					....e  s lastcash=##class(web.DHCBPSummaryOfCosts).GetPatMonthTotalSurplus(registerId,arcimId,tempdateMonth2)
					....s monthTotal=lastcash+qtyOrdCount-monthCount
					....S rest= ##class(web.DHCBPSummaryOfCosts).UpdatePatSurplus(registerId,arcimId,dateYear_tempdateMonth,monthTotal,"")
					....q:rest'=0
					....i cashstr="" s cashstr=patName_"|"_regNo_"|"_arcimDesc_"|上次总结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
					....e  s cashstr=cashstr_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
					....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
					....e  s colDesc=colDesc_"|"_"缴费日期|次数"
		.d OutputRow
		.s reStr=realityStr
		.d OutputRow
		.s reStr=cashstr
		.d OutputRow
		k ^tmpDylBlood($j)
		k ^tmpArrangeBlood($j)			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(registerId,arcimDesc,colDesc,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSummaryOfCostsAllLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSummaryOfCostsAllLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfCosts","0000000015","","2022-01-26","2022-01-26","H","1044||1^1102||1^1163||1^1451||1")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfOrderCosts","0000032751","","2021-02-01","2021-02-05","H","5772||1^5752||1^5757||1^8166||1^8904||1^10153||1^10928||1^6035||1^9254||1^10359||1^11195||1")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfOrderCosts","0000037444","","2021-01-25","2021-01-31","H","5772||1^5752||1^5757||1^8166||1^8904||1^10153||1^10928||1^6035||1^9254||1^10359||1^11195||1")
Query FindSummaryOfOrderCosts(regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Query(ROWSPEC = "registerId,ItemName,ColDesc,ResultStr") [ SqlProc ]
{
}

ClassMethod FindSummaryOfOrderCostsExecute(ByRef qHandle As %Binary, regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^tmpDylBlood($j)
	k ^tmpArrangeBlood($j)	
 	i regNum="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	
	s registerId=##class(web.DHCBPSummaryOfCosts).FindregisterId(regNum)
	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	
	s bpprPatDeptDr=$lg(^DHCBPPatRegister(registerId),30)
	//s locId=249
	s locId=##Class(web.DHCBPCom).GetLinkAdmLocByLocId(bpprPatDeptDr) //科室关联	
	//HD：血液透析(HD)(药费.材料均不另收)(肾内科)
	s ArcimIdHD="2808||1"
	s ArcimIdHD1="460||1"
	
	//HDF：血液透析滤过(HDF)基价(其它另收)^
	s ArcimIdHDF="2810"
	//HP：血液灌流(PE)基价(其它另收)
	s ArcimIdHP="18597||1"
	;s ArcimIdStr=ArcimIdHD_"^"_ArcimIdHDF_"^"_ArcimIdHD1
	
	s ArcimIdStr=arcimsStr
	
	s bpoiId="" //实际使用次数(药品)
	f curDate=startDate:1:endDate d
	.f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,registerId,bpoiId)) q:bpoiId=""  d
		..s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
		..
	    ..q:bpoiOrderTypeCode'="N"
	    ..s bpoiStatus=$lg(^DHCBPOrderItem(bpoiId),13)
	    ..q:(bpoiStatus'="E")
	    ..s bpoiExecDate=$li(^DHCBPOrderItem(bpoiId),27)
	    ..s dateYear=$p($zd(bpoiExecDate,3),"-",1)
		..s dateMonth=+$p($zd(bpoiExecDate,3),"-",2)	
		..s arcimId=$li(^DHCBPOrderItem(bpoiId),4)
		..q:("^"_ArcimIdStr_"^")'[("^"_arcimId_"^") 
		..;B
		..s equalUomInfo=##class(web.DHCClinicCom).GetEqUomQty(arcimId)
		..s defaultDoseInfo=$p(equalUomInfo,"^",2)
		..i $l(defaultDoseInfo,"|")>1 s defaultDoseInfo=$p(defaultDoseInfo,"|",2)
		..s Dose= $li(^DHCBPOrderItem(bpoiId),5)
		..s qty=Dose\defaultDoseInfo
		..i (Dose#defaultDoseInfo)'=0 s qty=qty+1
	    ..s arcimSub=$p(arcimId,"||",1)
	    ..s arcimVer=$p(arcimId,"||",2)
	    ..s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
		..s bpaDate=$zd(curDate,3)
		..s monthCount=0
		..if ($d(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpoiExecDate))>0) s monthCount=$P(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpoiExecDate),"|",6)
		..s qty=monthCount+qty
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(bpaDate,"-",1,2)_"|"_qty
		..i arcimSub=11195 b
		..;b
		..s ^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpoiExecDate)=resultStr
		..s ^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=curDate
		..//w arcimDesc_"/"_dateYear_"/"_dateMonth_"/"_bpaDate_"/"_orderLastDate,!
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(bpaDate,"-",1,2)_"|"_"0"
		..s ^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=$zdh(bpaDate,3)
		..s ^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth)="0"
		..s ^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,bpaDate)=resultStr
		
	
	s rset=##class(%ResultSet).%New("web.DHCBPOrder:FindHisOrderItemBySummary")	
	;w registerId_"/"_startDate_"/"_endDate_"/"_""_"/"_"N"_"/"_locId,!
	do rset.Execute(registerId,startDate,endDate,"","N",locId,"0")
	while (rset.Next()) {		
		//w rset.GetData(20),!
		s phQtyOrd=rset.GetData(20) //数量
		s createDate=rset.GetData(21) //开医嘱日期
		s createTime=rset.GetData(22) //开医嘱时间
		s orderStatus=rset.GetData(18)
		i orderStatus'="P" CONTINUE 
		//w createDate_"/"_createTime,!
		s orderDate=$zd(createDate,3) //_" "_$zt(createTime,2)
		s dateYear=$p($zd(createDate,3),"-",1)
		s dateMonth=+$p($zd(createDate,3),"-",2)
		s arcimId=rset.GetData(5)
		i ("^"_ArcimIdStr_"^")'[("^"_arcimId_"^") CONTINUE 
		s arcimDesc=rset.GetData(6)
		s monthCount=0,tempdate=createDate
		if ($d(^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth))>0) s monthCount=^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth)
		
		if ($d(^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth))>0) s tempdate=^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)
		b
		s phQtyOrd=phQtyOrd+monthCount
		if ($d(^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))=0) d
		.s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDate,"-",1,2)_"|"_"0"
		.s ^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3))=resultStr
		.s ^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=createDate
		
		s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_phQtyOrd
		s dayCount=0
		if ($d(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3)))>0) s dayCount=$p(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3)),"|",6)
		s tempresultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_(rset.GetData(20)+dayCount)
		
		i arcimId="10359||1" b
		s ^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth)=createDate
		s ^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth)=phQtyOrd
		s ^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,$zd(tempdate,3))=tempresultStr
		
	}	
	d rset.Close()
	b
	s registerId=""  f  s registerId=$o(^tmpDylBlood($j,"Result",registerId)) q:registerId=""  d
	.s arcimId=""  f  s arcimId=$o(^tmpDylBlood($j,"Result",registerId,arcimId)) q:arcimId=""  d
		..s reStr="",colDesc=""
		..s dateYear=""  f  s dateYear=$o(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear)) q:dateYear=""  d
			...S datecountMonthStr=""
			...s dateMonth=""  f  s dateMonth=$o(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth)) q:dateMonth=""  d
			 	....s dateMonthStr=""
			 	....s monthCount="",orderDateStr="",arcimDesc="" //,dateYear=""	
			 	....s orderDate=""  f  s orderDate=$o(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					.....s dateMonthStr=$g(^tmpDylBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate))
					.....//patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_phQtyOrd
					.....s arcimDesc=$p(dateMonthStr,"|",3)
					.....s monthCount=monthCount+$p(dateMonthStr,"|",6)
					.....s $p(dateMonthStr,"|",6)=monthCount
					.....;s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
					.....s orderDateStr=$g(^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))
					.....s orderDateStr=$zd(orderDateStr,3)
					.....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)
					.....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
				....b 	
			 	....i dateMonthStr'="" d
					.....i reStr="" s reStr=dateMonthStr
					.....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
					.....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
					.....e  s colDesc=colDesc_"|"_"缴费日期|次数"			
			 	....s arrOrder=$g(^tmpArrangeBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))
			 	....i arrOrder="" d
					.....s BPCBPMRowId=0,id=""
					.....f  s BPCBPMRowId=$o(^DHCBPC("BloodPurificationMode",BPCBPMRowId)) q:BPCBPMRowId=""  d
	    				......s Code=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),1)	    
	    				......q:Code'=arcimDesc
	    				......s id=BPCBPMRowId
	    			.....q:id=""
					.....s ^tmpArrangeBlood($j,"Result",registerId,id,dateYear,dateMonth,orderDateStr)=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDateStr,"-",1,2)_"|"_"0"
			...//i datecountMonthStr="" s datecountMonthStr=$g(^tmpDylBlood($j,"C",registerId,arcimId,dateYear,dateMonth))
			...//e  d
			...//.e  s datecountMonthStr=datecountMonthStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount 
		..d OutputRow
	s registerId=""  f  s registerId=$o(^tmpDylBlood($j,"Result",registerId)) q:registerId=""  d
	.s arcimId=""  f  s arcimId=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId)) q:arcimId=""  d
		..s reStr="",realityStr="",colDesc="",cashstr=""
		..s dateYear=""  f  s dateYear=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear)) q:dateYear=""  d
			...s dateMonth=""  f  s dateMonth=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth)) q:dateMonth=""  d
				....s dateMonthStr=""
				....s monthCount="",orderDateStr="",arcimDesc="",monthTotal=0 //,dateYear=""
				....s orderDate=""  f  s orderDate=$o(^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					.....s dateMonthStr=^tmpArrangeBlood($j,"Result",registerId,arcimId,dateYear,dateMonth,orderDate)
					.....s arcimDesc=$p(dateMonthStr,"|",3)
					.....s monthCount=monthCount+$p(dateMonthStr,"|",6)
					.....s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
					.....//w arcimDesc_"|"_dateYear_"|"_dateMonth_"|"_$p(dateMonthStr,"|",3)_"|"_orderDateStr_"|"_monthCount,!
					.....s orderDateStr=$g(^tmpDylBlood($j,"T",registerId,arcimDesc,dateYear,dateMonth))
					.....s orderDateStr=$zd(orderDateStr,3)
					.....//w orderDateStr,!
					.....s dateMonthStr=patName_"|"_regNo_"|"_arcimDesc_"|"_$p(dateMonthStr,"|",4)_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
					.....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)02
					.....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
				....//w monthCount,!
				....//w dateMonthStr,!
				....i dateMonthStr'="" d
					.....
					.....i reStr="" s reStr=dateMonthStr
					.....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount		
					.....s qtyOrdCount=$g(^tmpDylBlood($j,"C",registerId,arcimDesc,dateYear,dateMonth))
					.....b
					.....i realityStr="" s realityStr=patName_"|"_regNo_"|"_arcimDesc_"|结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
					.....e  s realityStr=realityStr_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
					.....s tempdateMonth=dateMonth
					.....i $l(dateMonth)=1 s tempdateMonth=0_dateMonth
					.....s tempdateMonth2=##class(web.DHCBPSummaryOfCosts).convertTheLastMonth(dateYear,tempdateMonth)
					.....i (dateYear=2021)&&(tempdateMonth="01") s lastcash=0
					.....e  s lastcash=##class(web.DHCBPSummaryOfCosts).GetPatMonthTotalSurplus(registerId,arcimId,tempdateMonth2)
					.....s monthTotal=lastcash+qtyOrdCount-monthCount
					.....S rest= ##class(web.DHCBPSummaryOfCosts).UpdatePatSurplus(registerId,arcimId,dateYear_tempdateMonth,monthTotal,"")
					.....q:rest'=0
					.....i cashstr="" s cashstr=patName_"|"_regNo_"|"_arcimDesc_"|上次总结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
					.....e  s cashstr=cashstr_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
					.....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
					.....e  s colDesc=colDesc_"|"_"缴费日期|次数"
		..d OutputRow
		..s reStr=realityStr
		..d OutputRow
		..s reStr=cashstr
		..d OutputRow
	k ^tmpDylBlood($j)
	k ^tmpArrangeBlood($j)			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(registerId,arcimDesc,colDesc,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSummaryOfOrderCostsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSummaryOfOrderCostsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfOrderCostsAllLoc","0000032751","","2021-01-25","2021-02-04","H","2808||1^460||1^462||1^11500||1^11509||1^11510||1^11553||1^11722||1^2809||1^461||1^2810||1^2812||1^463||1^1657||1^2596||1^2601||1")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfOrderCostsAllLoc","0000032751","","2021-02-01","2021-02-02","H")
/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfOrderCostsAllLoc","0000032751","","2021-01-25","2021-01-26","H")
Query FindSummaryOfOrderCostsAllLoc(regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Query(ROWSPEC = "registerId,ItemName,ColDesc,ResultStr") [ SqlProc ]
{
}

ClassMethod FindSummaryOfOrderCostsAllLocExecute(ByRef qHandle As %Binary, regNum, ArcimId, startDate, endDate, subType As %String = "", arcimsStr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^tmpDylBlood($j)
	k ^tmpArrangeBlood($j)	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	S A=0
	s registerId=""
	f  s registerId=$o(^DHCBPPatRegister(registerId),-1) q:(registerId="")!(registerId=0)  d
	.s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	.q:papmiId="" 
	.q:'$d(^PAPER(papmiId,"PAT",1)) 
	.q:$lg(^DHCBPPatRegister(registerId),14)="D"
	.d GetSummaryOfCosts()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetSummaryOfCosts()	
	//s registerId=##class(web.DHCBPSummaryOfCosts).FindregisterId(regNum)
	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	
	s bpprPatDeptDr=$lg(^DHCBPPatRegister(registerId),30)
	//s locId=197
	s locId=##Class(web.DHCBPCom).GetLinkAdmLocByLocId(bpprPatDeptDr) //科室关联	
	//HD：血液透析(HD)(药费.材料均不另收)(肾内科)
	s ArcimIdHD="2808||1"
	s ArcimIdHD1="460||1"
	
	//HDF：血液透析滤过(HDF)基价(其它另收)^
	s ArcimIdHDF="2810"
	//HP：血液灌流(PE)基价(其它另收)
	s ArcimIdHP="18597||1"
	;s ArcimIdStr=ArcimIdHD_"^"_ArcimIdHDF_"^"_ArcimIdHD1
	
	s ArcimIdStr=arcimsStr
	
	s bpoiId="" //实际使用次数(药品)
	f curDate=startDate:1:endDate d
	.f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,registerId,bpoiId)) q:bpoiId=""  d
		..s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
		..
	    ..q:bpoiOrderTypeCode'="N"
	    ..s bpoiStatus=$lg(^DHCBPOrderItem(bpoiId),13)
	    ..q:(bpoiStatus'="E")
	    ..s bpoiExecDate=$li(^DHCBPOrderItem(bpoiId),27)
	    ..s dateYear=$p($zd(bpoiExecDate,3),"-",1)
		..s dateMonth=+$p($zd(bpoiExecDate,3),"-",2)	
		..s arcimId=$li(^DHCBPOrderItem(bpoiId),4)
		..q:("^"_ArcimIdStr_"^")'[("^"_arcimId_"^") 
		..s equalUomInfo=##class(web.DHCClinicCom).GetEqUomQty(arcimId)
		..s defaultDoseInfo=$p(equalUomInfo,"^",2)
		..i $l(defaultDoseInfo,"|")>1 s defaultDoseInfo=$p(defaultDoseInfo,"|",2)
		..s Dose= $li(^DHCBPOrderItem(bpoiId),5)
		..s qty=Dose\defaultDoseInfo
		..i (Dose#defaultDoseInfo)'=0 s qty=qty+1
	    ..s arcimSub=$p(arcimId,"||",1)
	    ..s arcimVer=$p(arcimId,"||",2)
	    ..s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
		..s bpaDate=$zd(curDate,3)
		..s monthCount=0
		..if ($d(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate))>0) s monthCount=$P(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate),"|",6)
		..s qty=monthCount+qty
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(bpaDate,"-",1,2)_"|"_qty
		..b
		..s ^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate)=resultStr
		..s ^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth)=curDate
		..//w arcimDesc_"/"_dateYear_"/"_dateMonth_"/"_bpaDate_"/"_orderLastDate,!
		..s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(bpaDate,"-",1,2)_"|"_"0"
		..s ^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth)=$zdh(bpaDate,3)
		..s ^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth)="0"
		..s ^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,bpaDate)=resultStr
		
	
	s rset=##class(%ResultSet).%New("web.DHCBPOrder:FindHisOrderItemBySummary")	
	;w registerId_"/"_startDate_"/"_endDate_"/"_""_"/"_"N"_"/"_locId,!
	do rset.Execute(registerId,startDate,endDate,"","N",locId,"0")
	while (rset.Next()) {		
		//w rset.GetData(20),!
		s phQtyOrd=rset.GetData(20) //数量
		s createDate=rset.GetData(21) //开医嘱日期
		s createTime=rset.GetData(22) //开医嘱时间
		s orderStatus=rset.GetData(18)
		i orderStatus'="P" CONTINUE 
		//w createDate_"/"_createTime,!
		s orderDate=$zd(createDate,3) //_" "_$zt(createTime,2)
		s dateYear=$p($zd(createDate,3),"-",1)
		s dateMonth=+$p($zd(createDate,3),"-",2)
		s arcimId=rset.GetData(5)
		i ("^"_ArcimIdStr_"^")'[("^"_arcimId_"^") CONTINUE 
		s arcimDesc=rset.GetData(6)
		s monthCount=0,tempdate=createDate
		if ($d(^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth))>0) s monthCount=^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth)
		
		if ($d(^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth))>0) s tempdate=^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth)
		
		s phQtyOrd=phQtyOrd+monthCount
		
		if ($d(^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth))=0) d
		.s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDate,"-",1,2)_"|"_"0"
		.s ^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3))=resultStr
		.s ^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth)=createDate
		
		s resultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_phQtyOrd
		s dayCount=0
		if ($d(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3)))>0) s dayCount=$p(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3)),"|",6)
		s tempresultStr=patName_"|"_regNo_"|"_arcimDesc_"|缴费次数"_"|"_$p(orderDate,"-",1,2)_"|"_(rset.GetData(20)+dayCount)
		
		s ^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth)=createDate
		s ^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth)=phQtyOrd
		s ^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,$zd(tempdate,3))=tempresultStr
		
	}	
	d rset.Close()
	s arcimId=""  f  s arcimId=$o(^tmpDylBlood($j,"Result",arcimId)) q:arcimId=""  d
		.s reStr="",colDesc=""
		.s dateYear=""  f  s dateYear=$o(^tmpDylBlood($j,"Result",arcimId,dateYear)) q:dateYear=""  d
			..s dateMonth=""  f  s dateMonth=$o(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth)) q:dateMonth=""  d
			 	...s dateMonthStr=""
			 	...s monthCount="",orderDateStr="",arcimDesc="" //,dateYear=""	
			 	...s orderDate=""  f  s orderDate=$o(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					....s dateMonthStr=$g(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate))
					....s arcimDesc=$p(dateMonthStr,"|",3)
					....s monthCount=monthCount+$p(dateMonthStr,"|",6)
					....s $p(dateMonthStr,"|",6)=monthCount
					....;s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
					....s orderDateStr=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth))
					....s orderDateStr=$zd(orderDateStr,3)
					....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)
					....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
			 	...i dateMonthStr'="" d
					....i reStr="" s reStr=dateMonthStr
					....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
					....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
					....e  s colDesc=colDesc_"|"_"缴费日期|次数"			
			 	...s arrOrder=$g(^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth))
			 	...i arrOrder="" d
					....s BPCBPMRowId=0,id=""
					....f  s BPCBPMRowId=$o(^DHCBPC("BloodPurificationMode",BPCBPMRowId)) q:BPCBPMRowId=""  d
	    				.....s Code=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),1)	    
	    				.....q:Code'=arcimDesc
	    				.....s id=BPCBPMRowId
	    			....q:id=""
					....s ^tmpArrangeBlood($j,"Result",id,dateYear,dateMonth,orderDateStr)=patName_"|"_regNo_"|"_arcimDesc_"|实际次数"_"|"_$p(orderDateStr,"-",1,2)_"|"_"0"
		.d OutputRow
	s arcimId=""  f  s arcimId=$o(^tmpArrangeBlood($j,"Result",arcimId)) q:arcimId=""  d
		.s reStr="",realityStr="",colDesc="",cashstr=""
		.s dateYear=""  f  s dateYear=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear)) q:dateYear=""  d
			..s dateMonth=""  f  s dateMonth=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth)) q:dateMonth=""  d
				...s dateMonthStr=""
				...s monthCount="",orderDateStr="",arcimDesc="",monthTotal=0 //,dateYear=""
				...s orderDate=""  f  s orderDate=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					....s dateMonthStr=^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)
					....s arcimDesc=$p(dateMonthStr,"|",3)
					....s monthCount=monthCount+$p(dateMonthStr,"|",6)
					....s dateYear=$p($p(dateMonthStr,"|",5),"-",1)
					....//w arcimDesc_"|"_dateYear_"|"_dateMonth_"|"_$p(dateMonthStr,"|",3)_"|"_orderDateStr_"|"_monthCount,!
					....s orderDateStr=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth))
					....s orderDateStr=$zd(orderDateStr,3)
					....//w orderDateStr,!
					....s dateMonthStr=patName_"|"_regNo_"|"_arcimDesc_"|"_$p(dateMonthStr,"|",4)_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount
					....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)02
					....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
				...//w monthCount,!
				...//w dateMonthStr,!
				...i dateMonthStr'="" d
					....
					....i reStr="" s reStr=dateMonthStr
					....e  s reStr=reStr_"|"_$p(orderDateStr,"-",1,2)_"|"_monthCount		
					....s qtyOrdCount=$g(^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth))
					....i realityStr="" s realityStr=patName_"|"_regNo_"|"_arcimDesc_"|结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
					....e  s realityStr=realityStr_"|"_$p(orderDateStr,"-",1,2)_"|"_(qtyOrdCount-monthCount)
					....s tempdateMonth=dateMonth
					....i $l(dateMonth)=1 s tempdateMonth=0_dateMonth
					....s tempdateMonth2=##class(web.DHCBPSummaryOfCosts).convertTheLastMonth(dateYear,tempdateMonth)
					....i (dateYear=2021)&&(tempdateMonth="01") s lastcash=0
					....e  s lastcash=##class(web.DHCBPSummaryOfCosts).GetPatMonthTotalSurplus(registerId,arcimId,tempdateMonth2)
					....s monthTotal=lastcash+qtyOrdCount-monthCount
					....S rest= ##class(web.DHCBPSummaryOfCosts).UpdatePatSurplus(registerId,arcimId,dateYear_tempdateMonth,monthTotal,"")
					....q:rest'=0
					....i cashstr="" s cashstr=patName_"|"_regNo_"|"_arcimDesc_"|上次总结余"_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
					....e  s cashstr=cashstr_"|"_$p(orderDateStr,"-",1,2)_"|"_lastcash
					....i colDesc="" s colDesc="姓名|登记号|项目|类型|缴费日期|次数"
					....e  s colDesc=colDesc_"|"_"缴费日期|次数"
		.d OutputRow
		.s reStr=realityStr
		.d OutputRow
		.s reStr=cashstr
		.d OutputRow
		k ^tmpDylBlood($j)
		k ^tmpArrangeBlood($j)			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(registerId,arcimDesc,colDesc,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSummaryOfOrderCostsAllLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSummaryOfOrderCostsAllLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPSummaryOfCosts","FindSummaryOfOrderCosts","26","","2021-02-01","2021-02-02","H")
Query FindSummaryOfOrderbakCosts(registerId, ArcimId, startDate, endDate, subType As %String = "") As %Query(ROWSPEC = "registerId,ItemName,ColDesc,ResultStr") [ SqlProc ]
{
}

ClassMethod FindSummaryOfOrderCostsbakExecute(ByRef qHandle As %Binary, registerId, ArcimId, startDate, endDate, subType As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	//i regNum="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//s registerId=##class(web.DHCBPSummaryOfCosts).FindregisterId(regNum)
	b
	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)	
	s bpprPatDeptDr=$lg(^DHCBPPatRegister(registerId),30)
	//s locId=197
	s locId=##Class(web.DHCBPCom).GetLinkAdmLocByLocId(bpprPatDeptDr) //科室关联	
	//HD：血液透析(HD)(药费.材料均不另收)(肾内科)
	s ArcimIdHD="2808||1"
	//HDF：血液透析滤过(HDF)基价(其它另收)^
	s ArcimIdHDF="2810"
	//HP：血液灌流(PE)基价(其它另收)
	s ArcimIdPTT="5718||1"
	s ArcimIdhc="10890||1"
	s ArcimIdHP="18597||1"
	//生理盐水：氯化钠注射液(百特)[0.9% 1L/袋]
	s ArcimIdSLYS="431||1"
	//肝素：肝素钠注射液[12500U 2ML/支]
	s ArcimIdGS="2215||1"	
	s ArcimIdStr=ArcimIdHD_"^"_ArcimIdHDF_"^"_ArcimIdHP_"^"_ArcimIdSLYS_"^"_ArcimIdGS_"^"_ArcimIdPTT_"^"_ArcimIdhc
	b
	s rset=##class(%ResultSet).%New("web.DHCBPOrder:FindHisOrderItemBySummary")	
	;w registerId_"/"_startDate_"/"_endDate_"/"_""_"/"_"N"_"/"_locId,!
	do rset.Execute(registerId,startDate,endDate,"","N",locId,"0")
	while (rset.Next()) {		
		//w rset.GetData(20),!
		s phQtyOrd=rset.GetData(20) //数量
		s createDate=rset.GetData(21) //开医嘱日期
		s createTime=rset.GetData(22) //开医嘱时间
		s orderStatus=rset.GetData(18)
		i orderStatus'="P" CONTINUE 
		//w createDate_"/"_createTime,!
		s orderDate=$zd(createDate,3) //_" "_$zt(createTime,2)
		s dateYear=$p($zd(createDate,3),"-",1)
		s dateMonth=+$p($zd(createDate,3),"-",2)
		s arcimId=rset.GetData(5)
		i ("^"_ArcimIdStr_"^")'[("^"_arcimId_"^") CONTINUE 
		s arcimDesc=rset.GetData(6)
		i arcimDesc["透析滤过" s arcimDesc="HDF"
		e  i arcimDesc["灌流" s arcimDesc="HP"
		e  i arcimDesc["血液透析" s arcimDesc="HD"
		e  i arcimDesc["氯化钠注射液" s arcimDesc="生理盐水"
		e  i arcimDesc["肝素钠注射液" s arcimDesc="肝素"
		s resultStr=arcimDesc_"|缴费次数"_"|"_orderDate_"|"_phQtyOrd
		//s resultStr=orderDate_"|"_phQtyOrd_"|"_arcimDesc
		s ^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth)=createDate
		s ^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth)=phQtyOrd
		s ^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)=resultStr
	}	
	d rset.Close()
	
	s bpaId="" //实际使用次数(费用)
	f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",registerId,bpaId)) q:bpaId=""  d						
		.s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
		.q:(bpaStatus'="F")&&((subType="H")||(subType=""))
		.s bpaDate=$lg(^DHCBPArrange(bpaId),4)
		.q:bpaDate=""
		.q:bpaDate<startDate
		.q:bpaDate>endDate
		.s resultStr=""
		.s dateYear=$p($zd(bpaDate,3),"-",1)
		.s dateMonth=+$p($zd(bpaDate,3),"-",2)				
		.s modeCode="",modeDesc=""
		.s modeId=$lg(^DHCBPArrange(bpaId),26)
		.q:modeId=""
		.s modeCode=$lg($g(^DHCBPC("BloodPurificationMode",+modeId)),1)
		.s modeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+modeId)),2)
		.//w modeDesc,!
		.i modeCode="HDF" s modeDesc="HDF" //透析滤过
		.e  i modeCode="HP" s modeDesc="HP" //血液灌流
		.e  i modeCode="HD" s modeDesc="HD" //血液透析
		.s modeDescStr=modeDesc
		.s modeSecondId=$lg(^DHCBPArrange(bpaId),27)
		.i modeSecondId'="" d
			..s modeSecondCode=$lg($g(^DHCBPC("BloodPurificationMode",+modeSecondId)),1)
			..s modeSecondDesc=$lg($g(^DHCBPC("BloodPurificationMode",+modeSecondId)),2)
			..i modeSecondCode["HP" s modeSecondDesc="HP"
			..e  s modeSecondDesc="" 
			..s modeDescStr=modeDescStr_"^"_modeSecondDesc
		.f i=1:1:$l(modeDescStr,"^")  d
			..s modeDesc=$p(modeDescStr,"^",i)
			..q:modeDesc=""
			..s orderDate=$g(^tmpDylBlood($j,"T",modeDesc,dateYear,dateMonth))
			..q:orderDate=""
			..s orderLastDate=$g(^tmpDylBlood($j,"T",modeDesc,dateYear,dateMonth-1))
			..s orderNextDate=$g(^tmpDylBlood($j,"T",modeDesc,dateYear,dateMonth+1))
			..i modeDesc["HDF" w $zd(bpaDate,)_"|"_$zd(orderDate,)_"|"_$zd(orderNextDate),!
			..i (bpaDate>=orderDate)&&((bpaDate<orderNextDate)||(orderNextDate="")) d //本月、最后月
				...s bpaDate=$zd(bpaDate,3)
				...s resultStr=modeDesc_"|实际次数"_"|"_bpaDate_"|"_"1"
				...s ^tmpArrangeBlood($j,"Result",modeId,dateYear,dateMonth,bpaDate)=resultStr
				...s ^tmpArrangeBlood($j,"T",modeDesc,dateYear,dateMonth)=orderDate
				...//w modeDesc_"/"_dateYear_"/"_dateMonth_"/"_bpaDate_"/"_orderLastDate,!
			..e  i (bpaDate<orderDate)&&(bpaDate>orderLastDate) d  //算到上一月
				...s bpaDate=$zd(bpaDate,3)
				...q:orderLastDate=""
				...i dateMonth-1=0  d
					....i dateMonth="5" w dateYear_"/"_dateMonth_"/"_bpaDate_"/"_orderLastDate,!
					....q:orderLastDate=""
					....q:bpaDate<orderLastDate
					....s dateYear=+$p($zd(orderLastDate,3),"-",1)	
					....s dateMonth=+$p($zd(orderLastDate,3),"-",2)	
					....//s dateMonth=12
					....//s dateYear=dateYear-1			
				...e  s dateMonth=dateMonth-1
				...s resultStr=modeDesc_"|实际次数"_"|"_bpaDate_"|"_"1"
				...s ^tmpArrangeBlood($j,"Result",modeId,dateYear,dateMonth,bpaDate)=resultStr
				...s ^tmpArrangeBlood($j,"T",modeDesc,dateYear,dateMonth)=orderDate
	s bpoiId="" //实际使用次数(药品)
	f curDate=startDate:1:endDate d
	f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,registerId,bpoiId)) q:bpoiId=""  d
		.s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
	    .q:bpoiOrderTypeCode'="N"
	    .s bpoiStatus=$lg(^DHCBPOrderItem(bpoiId),13)
	    .q:(bpoiStatus'="E")
	    .s bpoiExecDate=$li(^DHCBPOrderItem(bpoiId),27)
	    .s dateYear=$p($zd(bpoiExecDate,3),"-",1)
		.s dateMonth=+$p($zd(bpoiExecDate,3),"-",2)	
		.s arcimId=$li(^DHCBPOrderItem(bpoiId),4)
	    .s arcimSub=$p(arcimId,"||",1)
	    .s arcimVer=$p(arcimId,"||",2)
	    .s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    .s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	    .i arcimDesc["氯化钠" s arcimDesc="生理盐水"
		.i arcimDesc["肝素钠" s arcimDesc="肝素"
		.s orderDate=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth))
		.q:orderDate=""
		.s orderLastDate=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth-1))
		.s orderNextDate=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth+1))
		.i arcimDesc["生理盐水" w $zd(bpaDate,)_"|"_$zd(orderDate,)_"|"_$zd(orderNextDate),!
		.i (bpaDate>=orderDate)&&((bpaDate<orderNextDate)||(orderNextDate="")) d //本月、最后月
			..s bpaDate=$zd(bpaDate,3)
			..s monthCount=0
			..if ($d(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate))>0) s monthCount=$P(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate),"|",6)
			..s qty=monthCount+1
			..s resultStr=arcimDesc_"|实际次数"_"|"_bpaDate_"|"_qty
			..s ^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate)=resultStr
			..s ^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth)=orderDate
			..//w arcimDesc_"/"_dateYear_"/"_dateMonth_"/"_bpaDate_"/"_orderLastDate,!
		.e  i (bpaDate<orderDate)&&(bpaDate>orderLastDate) d  //算到上一月
			..s bpaDate=$zd(bpaDate,3)
			..i dateMonth-1=0  d
				...i dateMonth="5" w dateYear_"/"_dateMonth_"/"_bpoiExecDate_"/"_orderLastDate,!
				...q:orderLastDate=""
				...q:bpaDate<orderLastDate
				...s dateMonth=12
				...s dateYear=dateYear-1				
			..e  s dateMonth=dateMonth-1
			..s monthCount=0
			..if ($d(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate))>0) s monthCount=$P(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate),"|",6)
			..s qty=monthCount+1
			..s resultStr=arcimDesc_"|实际次数"_"|"_bpaDate_"|"_qty
			..s ^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,bpoiExecDate)=resultStr
			..s ^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth)=orderDate
	b
	s arcimId=""  f  s arcimId=$o(^tmpDylBlood($j,"Result",arcimId)) q:arcimId=""  d
		.s reStr="",colDesc=""
		.s dateYear=""  f  s dateYear=$o(^tmpDylBlood($j,"Result",arcimId,dateYear)) q:dateYear=""  d
			..s dateMonth=""  f  s dateMonth=$o(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth)) q:dateMonth=""  d
			 	...s dateMonthStr=""
			 	...s monthCount="",orderDateStr="",arcimDesc="" //,dateYear=""	
			 	...s orderDate=""  f  s orderDate=$o(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					....s dateMonthStr=$g(^tmpDylBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate))
					....s arcimDesc=$p(dateMonthStr,"|",1)
					....s monthCount=monthCount+$p(dateMonthStr,"|",4)
					....s dateYear=$p($p(dateMonthStr,"|",3),"-",1)
					....s orderDateStr=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth))
					....s orderDateStr=$zd(orderDateStr,3)
					....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)
					....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
			 	...i dateMonthStr'="" d
					....i reStr="" s reStr=dateMonthStr
					....e  s reStr=reStr_"|"_orderDateStr_"|"_monthCount
					....i colDesc="" s colDesc="项目|类型|缴费日期|次数"
					....e  s colDesc=colDesc_"|"_"缴费日期|次数"			
			 	...s arrOrder=$g(^tmpArrangeBlood($j,"T",arcimDesc,dateYear,dateMonth))
			 	...i arrOrder="" d
					....s BPCBPMRowId=0,id=""
					....f  s BPCBPMRowId=$o(^DHCBPC("BloodPurificationMode",BPCBPMRowId)) q:BPCBPMRowId=""  d
	    				.....s Code=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),1)	    
	    				.....q:Code'=arcimDesc
	    				.....s id=BPCBPMRowId
	    			....q:id=""
					....s ^tmpArrangeBlood($j,"Result",id,dateYear,dateMonth,orderDateStr)=arcimDesc_"|实际次数"_"|"_orderDateStr_"|"_"0"
		.d OutputRow
	s arcimId=""  f  s arcimId=$o(^tmpArrangeBlood($j,"Result",arcimId)) q:arcimId=""  d
		.s reStr="",realityStr="",colDesc=""
		.s dateYear=""  f  s dateYear=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear)) q:dateYear=""  d
			..s dateMonth=""  f  s dateMonth=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth)) q:dateMonth=""  d
				...s dateMonthStr=""
				...s monthCount="",orderDateStr="",arcimDesc="" //,dateYear=""
				...s orderDate=""  f  s orderDate=$o(^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)) q:orderDate=""  d
					....s dateMonthStr=^tmpArrangeBlood($j,"Result",arcimId,dateYear,dateMonth,orderDate)
					....s arcimDesc=$p(dateMonthStr,"|",1)
					....s monthCount=monthCount+$p(dateMonthStr,"|",4)
					....s dateYear=$p($p(dateMonthStr,"|",3),"-",1)
					....//w arcimDesc_"|"_dateYear_"|"_dateMonth_"|"_$p(dateMonthStr,"|",3)_"|"_orderDateStr_"|"_monthCount,!
					....s orderDateStr=$g(^tmpDylBlood($j,"T",arcimDesc,dateYear,dateMonth))
					....s orderDateStr=$zd(orderDateStr,3)
					....//w orderDateStr,!
					....s dateMonthStr=arcimDesc_"|"_$p(dateMonthStr,"|",2)_"|"_orderDateStr_"|"_monthCount
					....;i orderDateStr="" s orderDateStr=$p(dateMonthStr,"|",5)
					....;e  s orderDateStr=orderDateStr_" "_$p(dateMonthStr,"|",5)
				...//w monthCount,!
				...//w dateMonthStr,!
				...i dateMonthStr'="" d
					....
					....i reStr="" s reStr=dateMonthStr
					....e  s reStr=reStr_"|"_orderDateStr_"|"_monthCount		
					....s qtyOrdCount=$g(^tmpDylBlood($j,"C",arcimDesc,dateYear,dateMonth))
					....i realityStr="" s realityStr=arcimDesc_"|结余"_"|"_orderDateStr_"|"_(qtyOrdCount-monthCount)
					....e  s realityStr=realityStr_"|"_orderDateStr_"|"_(qtyOrdCount-monthCount)
					....i colDesc="" s colDesc="项目|类型|缴费日期|次数"
					....e  s colDesc=colDesc_"|"_"缴费日期|次数"
		.d OutputRow
		.s reStr=realityStr
		.d OutputRow
	k ^tmpDylBlood($j)
	k ^tmpArrangeBlood($j)			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(registerId,arcimDesc,colDesc,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSummaryOfOrderCostsbakFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSummaryOfOrderCostsbakClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryOfCostsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creater:GY
/// CreateDate:2021-02-03
/// Input:registerId(DHCBPPatRegister表RowId),arcimDr(医嘱ID),dateMonth(年月)
/// Description:查询病人当前月份某条医嘱的总结余数量
/// Oupput 结余数量(没有会返回0)
/// w ##class(web.DHCBPSummaryOfCosts).GetPatMonthTotalSurplus("26","2808||1","202101")
ClassMethod GetPatMonthTotalSurplus(registerId As %String, arcimDr As %String, dateMonth As %String) As %String
{
	S ^TEMPBY("UpdatePatSurplus")=registerId_"^"_arcimDr_"^"_dateMonth
	q:((registerId="")||(arcimDr="")||(dateMonth="")) 0
	s result=""
	s rowId=""
	f  s rowId=$o(^DHCBPPatSurplus(0,"RegisterDr",registerId,rowId)) q:((rowId="")||(result'=""))  d
	.s suArcimId=$lg(^DHCBPPatSurplus(rowId),4)
	.q:suArcimId'=arcimDr
	.s sudateMonth=$lg(^DHCBPPatSurplus(rowId),3)
	.q:sudateMonth'=dateMonth
	.s result=$lg(^DHCBPPatSurplus(rowId),5)
	q +result
}

/// Creater:GY
/// CreateDate:2021-02-03
/// Input:registerId(DHCBPPatRegister表RowId),arcimDr(医嘱ID),dateMonth(年月),newMonthSurplus(新的总结余),patMasDr(病人ID)
/// Description:插入/更新病人当月总结余
/// Oupput -1 SQLCODE
/// w ##class(web.DHCBPSummaryOfCosts).UpdatePatSurplus("26","460||1","20211","-2","")
ClassMethod UpdatePatSurplus(registerId As %String, arcimDr As %String, dateMonth As %String, newMonthSurplus As %String, patMasDr As %String) As %String
{
	
	q:((registerId="")||(arcimDr="")||(dateMonth="")||(newMonthSurplus="")) "-1"
	q:$l(dateMonth)'=6 "-1"
	s dateofYear=$E(dateMonth,1,4)
	q:dateofYear<2021 "-1"
	s result=0
	s bppsRowId="",bppsSurplus=""
	&sql(SELECT BPPS_RowId,BPPS_TotalSurplus into:bppsRowId,:bppsSurplus FROM SQLUser.DHC_BP_PatSurplus WHERE BPPS_PatRegisterDr =:registerId AND BPPS_ArcimDr=:arcimDr AND BPPS_DateMonth=:dateMonth)
    i (bppsRowId'="") d
    .i (bppsSurplus'=newMonthSurplus) d
    ..&sql(update SQLUser.DHC_BP_PatSurplus set BPPS_TotalSurplus=:newMonthSurplus where BPPS_RowId=:bppsRowId)
    ..s result=SQLCODE
    e  d
    .&sql(insert into SQLUser.DHC_BP_PatSurplus(BPPS_PatRegisterDr,BPPS_PatMasDr,BPPS_DateMonth,BPPS_ArcimDr,BPPS_TotalSurplus) values(:registerId,:patMasDr,:dateMonth,:arcimDr,:newMonthSurplus))
	.s result=SQLCODE
	q result
}

/// w ##class(web.DHCBPSummaryOfCosts).FindregisterId("0000032751")
ClassMethod FindregisterId(regNo As %String) As %String
{
	s registerId=""
	s papmiIdList=""
	i regNo'="" d
	.s regNolength=$l(regNo)
	.i regNolength=10  s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	.i regNolength<10  d
	..f i=1:1:10-regNolength  d
	...s regNo="0"_regNo
	..s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList'="" d
	.f i=1:1:$l(papmiIdList,"^") d
	..s papmiId=$p(papmiIdList,"^",i)
	..q:papmiId=""
	..s bpprId=""
	..f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d 
	...s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	...q:papmiId="" 
	...q:'$d(^PAPER(papmiId,"PAT",1)) 
	...s registerId=bpprId
	return registerId
}

ClassMethod GetDateFormat(dateYear As %String, dateMonth As %String) As %String
{
	q:dateYear="" ""
	q:dateMonth="" ""
	s dateMonthStr=""
	i $l(dateMonth)=1 s dateMonth=0_dateMonth
	s dateMonthStr=dateYear_dateMonth
	return dateMonthStr
}

/// Creater:GY
/// CreateDate:2021-02-05
/// Input:year(年),month(月)
/// Description:将输入的日期转换成上个月
/// Oupput 年-月
/// w ##class(web.DHCBPSummaryOfCosts).convertTheLastMonth("2021","01")
/// w ##class(web.DHCBPSummaryOfCosts).convertTheLastMonth("2021","12")
/// w ##class(web.DHCBPSummaryOfCosts).convertTheLastMonth("2021","06")
ClassMethod convertTheLastMonth(year As %String, month As %String)
{
	q:($l(year)'=4)||($l(month)'=2) year_"-"_month
	s resultYear=year,resultMonth=month
	s resultMonth=+resultMonth
	i resultMonth<=12 s resultMonth=resultMonth-1
	i resultMonth=0 d
	.s resultMonth=12
	.s resultYear=resultYear-1
	i $l(resultMonth)=1 s resultMonth=0_resultMonth
	q resultYear_resultMonth
}

}

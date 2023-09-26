Class web.DHCBPLab Extends web.DHCClinicCom
{

ClassMethod LoadMedOrderByAdmId(regNo, admId, fromDate, toDate)
{
    // 查找出状态为执行(E)或核实(V)的检验(L)医嘱
    s Config=##Class(websys.Configuration).%OpenId(1)
    s MEDDATA=Config.DataNamespace
    s LABDATA=Config.LabDataNamespace
    s isAdd=0
    s oderRowId=$order(^OEORD(0,"Adm",admId,""))
    q:oderRowId="" isAdd // "202^没有检验医嘱信息!"
	
    s ordChildSub=$g(^tmpCLLastLoad("LabMedOrder",admId,oderRowId))
    f  s ordChildSub=$O(^OEORD(oderRowId,"I",ordChildSub)) q:ordChildSub=""  d
    .s ordItemId=oderRowId_"||"_ordChildSub
    .s ^tmpCLLastLoad("LabMedOrder",admId,oderRowId)=ordChildSub
    .s ordStartDate=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
    .
    .s startDate=+$h //根据开始结束日期过滤数据(结束日期为空不过滤数据) mfc
    .i fromDate'="" s startDate=..ConvertToDateH(fromDate)
    .i toDate'="" s endDate=..ConvertToDateH(toDate)
    .e  s endDate=""
    .;w startDate_"/"_endDate,!
    .;w ordStartDate,!
    .//q:(ordStartDate'="")&&(endDate'="")&&((ordStartDate<startDate)||(ordStartDate>endDate)) //delete by Deng Tijin 2017-09-29
    .
    .s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
    .q:statusId=""
    .s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
    .s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
    .//w "ordStatus"_ordStatus,!
    .q:((statusCode'="E")&&(statusCode'="V"))
    .;q:(statusCode'="E")
    .q:(ordStatus="停止")||(ordStatus="未激活")||(ordStatus="未审核")||(ordStatus="撤消") // 这个判断没有用
    .s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
    .s arcSubCatDr=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",10)
    .q:arcSubCatDr=""
    .s arcCatType=$piece($get(^ARC("IC",arcSubCatDr)),"^",7)
    .q:arcCatType'="L"
    .s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
    .q:ordLabNo=""
    .s arcExCode=..GetExCode(arcimRowId)
    .q:arcExCode=""
    .s labRelatId=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",35)
    .s ordIndex=0
    .d ..AddItem(admId,ordItemId,LABDATA,regNo,ordStatus,ordIndex)

    q isAdd
}

ClassMethod AddItem(admId, ordItemId, LABDATA, regNo, ordStatus, ordIndex)
{
	// w ##class(web.DHCBPDebug).AddItem(admId,ordItemId,LABDATA,regNo)
	s oderRowId=$p(ordItemId,"||",1)
	s ordChildSub=$p(ordItemId,"||",2)
	s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	s arcSubCatDr=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",10)
	s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
	s labRelatId=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",35)
    s ordItemDesc=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",2)
    s arcExCode=##class(web.DHCBPLab).GetExCode(arcimRowId)
    s reportDate="",reportTime="",reportUser="",reportStatus="报告未出",reportException=0
    //add mfc 20200319调用检验接口，根据检验号获取报告号
    s reportDR=##class(web.DHCENS.STBLL.Method.PostReportInfo).QryLISRptIDByLabNo(ordLabNo)
    s ^dhctmpbp(ordLabNo,1)=reportDR 
    //add mfc 20200319调用检验接口，根据报告号获取检验套项目报告
    s rset=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")		
	s ret="",isTooLong=0
	do rset.Execute(reportDR)
	while (rset.Next()) {
		s reportDate=rset.GetData(17) //报告日期
		s reportTime=rset.GetData(18) //报告时间
		q //取到日期退出
    }
	d rset.Close()
	i reportDate'="" s reportDate=$ZD(reportDate,3)
    i reportTime'="" s reportTime=$ZT(reportTime)
    i reportDate="" s reportStatus="报告未出",reportException=0
    e  s reportStatus="报告已出",reportException=1
    s ordLabSpec="",specChildSub=0
    i $d(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))'=0 d
    .s specChildSub=0 f  s specChildSub=$o(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub)) q:specChildSub=""  d
    ..s labSpecCode=$g(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))
    ..s labSpecCode=$p(labSpecCode,"^",1)
    ..;s labSpec=$p($g(^[LABDATA]TTAB("SPEC",labSpecCode)),"\",1) 
    ..q:labSpecCode="" 
    ..s HospitalCode=""
	..i ($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")  
	..s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",$c(32)_HospitalCode,""))
	..i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
    ..s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
	...s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
	...s labSpec=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)  
	...q:labSpec'=labSpecCode
    ...i ordLabSpec="" s ordLabSpec=labSpec
    ...e  s ordLabSpec=ordLabSpec_","_labSpec
    s recDeparmentDr=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",6)
    s recDept=""
    i recDept'="" s recDept=$p($g(^CTLOC(recDeparmentDr)),"^",2)

    s ordStartDate=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
    s ordDate=$ZD(ordStartDate,3)
    s ordStartTime=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",10)
    s ordTime=$ZT(ordStartTime)

    s ordLabSpec=ordLabSpec
    s reportStatus=reportStatus
    s reportUser=reportUser
    s reportDate=reportDate
    s reportTime=reportTime
    s reportException=reportException
        
    w "Add:",ordItemDesc," ",ordDate,ordTime,reportDate,reportTime,reportStatus,!

    set Data=$lb(ordIndex,recDept,ordLabNo,ordItemId,arcimRowId,ordItemDesc,ordStatus,ordDate,ordTime,ordLabSpec,reportStatus,reportUser,reportDate,reportTime,reportException,admId)
    s ^tmpClLabMedOrder(regNo,"TimeIndex",ordStartDate,ordStartTime,arcimRowId,ordItemId)=""
    s ^tmpClLabMedOrder(regNo,"MedOrderCodeIndex",arcimRowId,ordStartDate,ordStartTime,ordItemId)=""
    s ^tmpClLabMedOrder(regNo,"Data",ordItemId)=Data
    q Data
}

// regNo:登记号

// from:从1开始

// count:要加载的数据最大条数

// 该Query返回查验医嘱,^tmpLastLoad存放上一次查询点,^tmpClLabMedOrder缓存已加载的数据

// queryPara // 查询条件

// fromDate;fromTime;toDate;toTime;filterStr(字符串过滤医嘱);medOrderCodeId(医嘱码表Id)

// filterPara //过滤条件

// medOrderCodeId(医嘱Id);arcimId   

// d ##class(%ResultSet).RunQuery("web.DHCBPLab","FindLabMedOrder","0000000019",1,10,"fromDate^2017-08-16;filterStr^")

Query FindLabMedOrder(regNo, from, count, queryPara, filterPara) As %Query(ROWSPEC = "ordIndex,recDept,ordLabNo,orderRowId,arcItemId,ordItemDesc,ordStatus,ordDate,ordTime,ordLabSpec,reportStatus,reportUser,reportDate,reportTime,reportException,admId") [ SqlProc ]
{
}

ClassMethod FindLabMedOrderExecute(ByRef qHandle As %Binary, regNo, from, count, queryPara = "", filterPara = "") As %Status
{
    //优先级：regNo,papmiMedicare,papmiName,ctlocId
    s ^tmpDebug("FindLabMedOrder")=regNo_","_from_","_count_","_queryPara_","_filterPara
    d InitPara
    s ^tmpbpDebug("regNo")=regNo
    //s bufferDays=365 //清空缓存周期
    s bufferDays=-1 //-1每次清空，实时获取
    s date=$g(^tmpCLLastClearDate("date",regNo))
    s span=$h-date    
    i span>bufferDays d
    .b //清除缓存
    .s ^tmpCLLastClearDate("date",regNo)=+$h
    .k ^tmpClLabMedOrder
    .k ^tmpCLLastLoad
    s conLoad="",sort="" //Item
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s Config=##Class(websys.Configuration).%OpenId(1)
    s MEDDATA=Config.DataNamespace
    s LABDATA=Config.LabDataNamespace
    i regNo="" goto QuitBlock
    s papmiId="" f papmiId=$O(^PAPERi("PAPMI_PatNo",regNo,papmiId)) q:papmiId=""  d
    .s patType="" f  s patType=$O(^PAPERdr(papmiId,"ADM",patType)) q:patType=""  d
    ..s admId="" f  s admId=$O(^PAPERdr(papmiId,"ADM",patType,admId)) q:admId=""  d
    ...s isAdd=..LoadMedOrderByAdmId(regNo,admId,fromDate,toDate)
    ...
    d OutputAll
    goto QuitBlock

OutputAll
    s index=0
    s curCount=0
    s date=+$h+1
    
    f  s date=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date),-1) q:((date=""))  d
    .w date,!
    .s time=""
    .;i date=fromDate s time=fromTime //mfc 20180606
    .f  s time=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date,time),-1) q:((time=""))  d
    ..s curArcmId="" f  s curArcmId=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date,time,curArcmId)) q:((curArcmId=""))  d
    ...s sub="" f  s sub=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date,time,curArcmId,sub),-1) q:((sub=""))  d
    ....q:(toDate'="")&&((date>toDate)||((date=toDate)&&(time>toTime)))
    ....q:(fromDate'="")&&((date<fromDate)||((date=fromDate)&&(time<fromTime)))
    ....d LinkData
    ....
    q
LinkData
    set Data=^tmpClLabMedOrder(regNo,"Data",sub)
    s curOrderId=$List(Data,4)
    s curMedOrderCodeId=$List(Data,5)
    s curDesc=$List(Data,6)
    
    w curDesc_"/"_filterStr,!
    // 查询条件：index不增加
    q:curDesc'[filterStr
    q:((medOrderCodeId'="")&&(medOrderCodeId'=curMedOrderCodeId))

    s index=index+1
    w from_"/"_index,!
    q:(from>index)
    // 过滤条件: index要增加
    q:((medOrderCodeIdFilter'="")&&(medOrderCodeIdFilter'=curMedOrderCodeId))
    q:((arcimIdFilter'="")&&(arcimIdFilter'=curOrderId))
    
    i curCount>=count goto QuitBlock
    s $List(Data,1)=index
    s curCount=curCount+1
    d OutputRow
    q
InitPara
	// 查询参数: 满足queryPara条件的seqNo才会增加
	s fromDate=$$GetPara(queryPara,"fromDate")
	s fromTime=$$GetPara(queryPara,"fromTime")
	s toDate=$$GetPara(queryPara,"toDate")
	s toTime=$$GetPara(queryPara,"toTime")
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i fromTime="" s fromTime="0:00:00"
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i toTime="" s toTime="23:59:59"
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s filterStr=$$GetPara(queryPara,"filterStr")
	s medOrderCodeId=$$GetPara(queryPara,"medOrderCodeId")
	
	// 过滤参数:不满足条件也会seqNo
	s medOrderCodeIdFilter=$$GetPara(filterPara,"medOrderCodeId")
	s arcimIdFilter=$$GetPara(filterPara,"arcimId")
	q
GetPara(data,paraName)
	s paraSplit=";"
	s valueSplit="^"
	s len=$L(data,paraSplit)
	s findValue=""
	
	f i=1:1:len d
	.s item=$p(data,paraSplit,i)
	.s name=$p(item,valueSplit,1)
	.s value=$p(item,valueSplit,2)
	.i name=paraName s findValue=value s len=-1
	q findValue
QuitBlock
    Set qHandle=$lb(0,repid,0)
     Quit $$$OK
OutputRow
	 s reportStatus=$List(Data,11)
	 i reportStatus="报告未出" d
	 .s admId=$List(Data,16)
	 .s ordItemId=$List(Data,4)
	 .s ordStatus=$List(Data,7)	
	 .s ordIndex= $List(Data,1) 
	 .s Data=..AddItem(admId,ordItemId,LABDATA,regNo,ordStatus,ordIndex)
     Set ^CacheTemp(repid,ind)=Data
     Set ind=ind+1
    quit
TestData
    s count=100
    s i=1 f i=1:1:count d
    .
    .s ordIndex=i
    .s recDept="" //recDeparment
    .s ordLabNo=1000+i
    .s arcItemId=100+i
    .s ordItemDesc="血糖"_i
    .s ordStatus="aa"
    .s ordDate="2016-09-02"
    .s ordTime="12:00" //ordStartTime
    .s ordLabSpec="" //ordLabSpec
    .s reportStatus="reportStatus"
    .s reportUser="" //reportUser
    .s reportDate="" //reportDate
    .s reportTime="" //reportTime
    .s reportException="reportException"
    .d OutputRow
    Set qHandle=$lb(0,repid,0)
    q
}

ClassMethod FindLabMedOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPOrderExecute ]
{
     Set AtEnd=$LIST(qHandle,1)
     Set repid=$LIST(qHandle,2)
     Set ind=$LIST(qHandle,3)
     Set ind=$o(^CacheTemp(repid,ind))
     If ind="" {                // if there are no more rows, finish fetching
         Set AtEnd=1
         Set Row=""
     }
     Else      {                // fetch row
         Set Row=^CacheTemp(repid,ind)
     }
     s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindLabMedOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPOrderExecute ]
{
    Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
     Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCBPLab","FindLabResult","17082300002")

// 旧方法不在使用，检验号改成医嘱号获取 mfc 20180605

Query FindLabResult(labNo) As %Query(ROWSPEC = "serialNo,itemCode,itemDesc,abbreviation,unit,result,resultValue,flagUpDown,naturalRange") [ SqlProc ]
{
}

ClassMethod FindLabResultExecute(ByRef qHandle As %Binary, labNo) As %Status
{
    s labNo=$TR(labNo,$C(0))
    s conLoad="",sort="" //Item
      Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i (labNo="")  goto QuitBlock // "202^标本号不能为空!"    
    //k ^DHCBPTmpTestResult    
    s needEpisodeID="", regNoList="", ctlocId="", standardCode=""
    s startDate="", startTime="", endDate="", endTime="", ifSingle = 0
    s needNote = "", dataField = ""

	s STX=$c(2)
	s ETX=$c(3)
    s list=##class(web.DHCClinicCom).GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle, needNote, dataField, labNo)
    s len=$L(list,ETX)
    f index=1:1:len  d
    .s testStr=$P(list,ETX,index)
    .q:testStr=""
    .s seqnum=$P(testStr,STX,12)
    .s TmpTestResult(seqnum)=testStr    
    
	s num="" f  s num=$o(TmpTestResult(num)) q:num=""  d	
	.s itemStr=$g(TmpTestResult(num))
    .s serialNo=$P(itemStr,STX,10)
    .s itemCode=$P(itemStr,STX,7)
    .s itemDesc=$P(itemStr,STX,11)
    .s abbreviation=$P(itemStr,STX,11)
    .s unit=$P(itemStr,STX,2)
    .s result=$P(itemStr,STX,1)
    .s resultValue=$P(result,"^",1)
    .s result=$P(result,"^",2)
    .s flagUpDown=$P(itemStr,STX,13)
    .s naturalRange=$P(itemStr,STX,3)
    .d OutputRow

    goto QuitBlock

QuitBlock
    Set qHandle=$lb(0,repid,0)
     Quit $$$OK

OutputRow
    set Data=$lb(serialNo,itemCode,itemDesc,abbreviation,unit,result,resultValue,flagUpDown,naturalRange)
     Set ^CacheTemp(repid,ind)=Data
     Set ind=ind+1
    quit
TestData
    s count=100
    s i=1 f i=1:1:count d
    .
    .s serialNo=2000+i
    .s itemCode="Code"_i
    .s itemDesc="名称"_i
    .s abbreviation="别名"_i
    .s unit="单位"_i
    .s result="result"_i
    .s resultValue="resultValue"_i
    .s flagUpDown="flagUpDown"_i
    .s naturalRange="naturalRange"_i
    .d OutputRow
    Set qHandle=$lb(0,repid,0)
    q
}

ClassMethod FindLabResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLabResultExecute ]
{
     Set AtEnd=$LIST(qHandle,1)
     Set repid=$LIST(qHandle,2)
     Set ind=$LIST(qHandle,3)
     Set ind=$o(^CacheTemp(repid,ind))
     If ind="" {                // if there are no more rows, finish fetching
         Set AtEnd=1
         Set Row=""
     }
     Else      {                // fetch row
         Set Row=^CacheTemp(repid,ind)
     }
     s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindLabResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLabResultExecute ]
{
    Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
     Quit $$$OK
}

/// w ##Class(web.DHCBPLab).GetLisReportState()
ClassMethod GetLisReportState(admId As %String = "", ordLabNo As %String = "") As %String
{
    s reportStatus="报告未出"
    s flagUpDown=""
    s Config=##Class(websys.Configuration).%OpenId(1)
    s LABDATA=Config.LabDataNamespace
    d Config.%Close()
    s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,1,""))
    q:labTSCode="" reportStatus
    s labTSId=$O(^[LABDATA]TEPI(ordLabNo,1,labTSCode,""))
    q:labTSId="" reportStatus
    i ($D(^[LABDATA]TEPI(ordLabNo,1,labTSCode,labTSId))) d
    .s reportId=""
    .f  s reportId=$O(^[LABDATA]TEPI(ordLabNo,reportId)) q:reportId=""  d
    ..s labTSCode=""
    ..f  s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode)) q:labTSCode=""  d
    ...s labTSId=""
    ...f  s labTSId=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId)) q:labTSId=""  d
    ....
    ....s itemCode=""
    ....s serialNo=0
    ....f  s itemCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)) q:itemCode=""  d
    .....s resultStr=$G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode))
    .....q:resultStr=""
    .....s itemDesc=$P(^[LABDATA]TTAB("TC",itemCode),"\",1)
    .....s result=""
    .....s resultValue=$P($G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",1)
    .....i resultValue'="" s reportStatus="报告已出"
    .....i flagUpDown="" s flagUpDown=$P($G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",2)
    //i flagUpDown'="" s reportStatus=reportStatus_"(异常)"
    q reportStatus
}

/// w ##Class(web.DHCBPLab).GetLisReportExp()
ClassMethod GetLisReportExp(admId As %String = "", ordLabNo As %String = "") As %String
{
    s expFlag=""
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,1,""))
    q:labTSCode="" expFlag
    s labTSId=$O(^[LABDATA]TEPI(ordLabNo,1,labTSCode,""))
    q:labTSId="" expFlag
    i ($D(^[LABDATA]TEPI(ordLabNo,1,labTSCode,labTSId))) d
    .s reportId=""
    .f  s reportId=$O(^[LABDATA]TEPI(ordLabNo,reportId)) q:reportId=""  d
    ..s labTSCode=""
    ..f  s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode)) q:labTSCode=""  d
    ...s labTSId=""
    ...f  s labTSId=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId)) q:labTSId=""  d
    ....s itemCode=""
    ....s serialNo=0
    ....f  s itemCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)) q:itemCode=""  d
    .....s resultStr=$G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode))
    .....q:resultStr=""
    .....s resultStr=..GetLisItem(ordLabNo,itemCode,labTSCode,labTSId)
    .....q:resultStr=""
    .....s flagUpDown=$P(resultStr,"^",8)
    .....s flagUpDown=$TR(flagUpDown," ")
    .....//i (flagUpDown'="") s expFlag=1
    .....i (flagUpDown="h")||(flagUpDown="l")||(flagUpDown="H")||(flagUpDown="L")||(flagUpDown="↑")||(flagUpDown="↓")   s expFlag=1
    q expFlag
}

// D ##class(web.DHCBPLab).GetLisItem("2006691668","N6107","N0845","1")

ClassMethod GetLisItem(labNo As %String = "", itemCode As %String = "", labTSCode As %String = "", labTSId As %String = "") As %String
{
    q:(labNo="")||(itemCode="") ""
    s resultStr=$G(^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode))
    q:resultStr="" ""
    s receiveDate=$P($G(^TEPI(labNo,1,labTSCode,labTSId)),"\",21)
    ;q:receiveDate="" ""  //lisong 2014-06-26
    s naturalRange=$G(^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"Ranges"))
    s serialNo=$P(resultStr,"\",9)
    s serialNo=$TR(serialNo," ")
    s resultValue=$P(resultStr,"\",1)
    s result=""
    i (serialNo="") d
    .q:receiveDate="" //add  lisong 2014-06-26
    .s resultStr=##Class(web.DHCLabTestCode).GetTestCodeResult(labNo,itemCode,resultValue,receiveDate)
    .q:resultStr=""
    .s serialNo="空"
     .i $d(^TTAB("TC",itemCode,1,labTSCode)) d
     ..s itemOrder=$p(^TTAB("TC",itemCode,1,labTSCode),"\",1)
     ..q:itemOrder=""
     ..s layOrder=$p(^TTAB("TC",itemCode,1,labTSCode),"\",2)
     ..q:layOrder=""
      ..q:$G(^TTAB("TS",labTSCode,layOrder,itemOrder))=""
     ..s serialNo=$p(^TTAB("TS",labTSCode,layOrder,itemOrder),"\",15)
     .s itemDesc=$P(resultStr,$C(2),2)
     .s abbreviation=$P(resultStr,$C(2),7)
     .s resultValue=$P(resultStr,$C(2),3)
     .s unit=$P(resultStr,$C(2),4)
     .s flagUpDown=$P(resultStr,$C(2),5)
     .s naturalRange=$P(resultStr,$C(2),6)
     .s warnFlag=$P(resultStr,$C(2),8)
     e  d
     .s itemDesc=$P(^TTAB("TC",itemCode),"\",1)
     .s resultValue=$P(resultStr,"\",1)
    .s abbreviation=$P(^TTAB("TC",itemCode),"\",12)
    .s unit=$G(^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"Unit"))
    .s naturalRange=$G(^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"Ranges"))
    .s flagUpDown=$P(resultStr,"\",2)
    .s serialNo=$P(resultStr,"\",9)
    i naturalRange="" s naturalRange=" "
    i serialNo="" s serialNo="空"
    i serialNo=0 s serialNo="空"
     i (flagUpDown="N") s flagUpDown=""
    i (flagUpDown="H") s flagUpDown="↑"
    i (flagUpDown="L") s flagUpDown="↓"
    s flagUpDown=$TR(flagUpDown," ")
    i flagUpDown="" s flagUpDown=" "
    s resultStr=""
    s $P(resultStr,"^",1)=serialNo
    s $P(resultStr,"^",2)=itemCode
    s $P(resultStr,"^",3)=itemDesc
    s $P(resultStr,"^",4)=abbreviation
    s $P(resultStr,"^",5)=unit
    s $P(resultStr,"^",6)=result
    s $P(resultStr,"^",7)=resultValue
    s $P(resultStr,"^",8)=flagUpDown
    s $P(resultStr,"^",9)=naturalRange
    q resultStr
}

ClassMethod IflabnoVer(labno As %String = "", testc As %String = "") As %String
{
   q:testc="" ""
   s Config=##Class(websys.Configuration).%OpenId(1)
   s MEDDATA=Config.DataNamespace
   s LABDATA=Config.LabDataNamespace
   d Config.%Close()
   s status=$P($g(^[LABDATA]TEPI(labno,1,testc,1)),"\",31)
   if status'="A"  q ""
   s ^TMP(labno,testc)=""
   s author=$p(^[LABDATA]TEPI(labno,1,testc,1),"\",3)
   i (author'="") {
       if ($D(^[LABDATA]SSU("SSUSR",1,author))){
           s author=$p(^[LABDATA]SSU("SSUSR",1,author),"^",2)
        }
        else{
            s author=""
        }
    }
    else
    {
        s author=""
    }
    s Adate=$zd($p($G(^[LABDATA]TEPI(labno,1,testc,1)),"\",1),3)
    s Atime=$zt($p($G(^[LABDATA]TEPI(labno,1,testc,1)),"\",2)*60)
    s ret=author_"^"_Adate_"^"_Atime
    i $P(ret,"^",2)="" s ret=""
    q ret
}

ClassMethod GetExCode(ArcimRowid As %String) As %String
{
    s arcsub=$p(ArcimRowid,"||",2)
    q:arcsub="" ""
    s ExCode=""
    s chl="" f  s chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
    .s tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
    .s fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
    .q:(fromd'="")&(fromd>+$h)
    .q:(tod'="")&(tod<+$h)
    .s ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",4)
    q ExCode
}

/// 获取检查相关列表
/// d ##class(%ResultSet).RunQuery("web.DHCBPLab","QueryALLStudyByPaadmDR","17841770")
Query QueryALLStudyByPaadmDR(regNo As %String, paadmdr As %String = "", LocDr As %String = "", startDate As %String = "", enddate As %String = "") As %Query(ROWSPEC = "PatientID,TRegNo,TStudyNo,TItemName,TItemDate,TItemStatus,TOEOrderDr,TIsIll,TLocName,TreplocDr,TIshasImg,TMediumName,TImgBrowse,TImgShut,TOpenRpt,Mem,AppTime,TMBrowse")
{
}

ClassMethod QueryALLStudyByPaadmDRExecute(ByRef qHandle As %Binary, regNo As %String, paadmdr As %String = "", LocDr As %String = "", startDate As %String = "", enddate As %String = "") As %Status
{
	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s Memo="",ItemStatus="",Shut="",AppDateTime=""
	s StudyNo="",strOrderName="",strDate="",ItemStatus="",IsIll="",LocName="",IshasImg="",MediumName=""
	i regNo="" Quit $$$OK
    s papmiId="" f papmiId=$O(^PAPERi("PAPMI_PatNo",regNo,papmiId)) q:papmiId=""  d
	.s PAType="" f  s PAType=$o(^PAPERdr(papmiId,"ADM",PAType)) q:PAType=""  d
	..s PaadmdrOne=paadmdr f  s PaadmdrOne=$o(^PAPERdr(papmiId,"ADM",PAType,PaadmdrOne)) q:(PaadmdrOne="")  d
	...;w !,PaadmdrOne
	...s papatmasmdr=$p(^PAADM(PaadmdrOne),"^",1)
	...s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	...s PatientID=""
	...s PatientID=papatmasmdr	
	...s rset=##class(%ResultSet).%New("web.DHCClinicCom:FindStudyByAdm")
	...do rset.Execute(PaadmdrOne,startDate,enddate)
	...while (rset.Next()) {
		...s StudyNo=rset.GetData(1) //检查号
		...s strOrderName=rset.GetData(2) //医嘱名称
		...s strDate=rset.GetData(3) //开医嘱日期
		...s ItemStatus=rset.GetData(4) //是否发布
		...s oeorditemdr=rset.GetData(5) //医嘱id
		...s IsIll=rset.GetData(6) //是否阳性
		...s LocName=rset.GetData(7) //检查科室名称
		...s replocdr=rset.GetData(8) //检查科室代码
		...s Image=rset.GetData(9) //图像链接
		...s Report=rset.GetData(10) //报告链接
		...s Memo=rset.GetData(11) //备注
		...s MBrowse=rset.GetData(12) //注意事项
		...Do OutputRow1	
	...}
	...d rset.Close()	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow1
	set Data=$lb(PatientID,RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,Image,Shut,Report,Memo,AppDateTime,MBrowse)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryALLStudyByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryALLStudyByPaadmDRExecute ]
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

ClassMethod QueryALLStudyByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryALLStudyByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

///  d ##class(%ResultSet).RunQuery("web.DHCBPLab","FindRptContent","37006")
/// CR：mafucheng
/// 功能：获取检查记录文本结果
/// 入参：StudyNo检查号 
/// 返回：ExamDesc检查结果文本描述
Query FindRptContent(StudyNo As %String) As %Query(ROWSPEC = "ExamDesc:%String,ResultDesc:%String")
{
}

ClassMethod FindRptContentExecute(ByRef qHandle As %Binary, StudyNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    s ret=""
    s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
    s ExamDesc=""
    s ResultDesc=""
    i Rptrowid'="" d
    .s ExamDesc=^DHCRBStudy("Report",Rptrowid,"ExamDescEx")
    .s ResultDesc=^DHCRBStudy("Report",Rptrowid,"ResultDescEx")
    .Do OutALLStudy
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutALLStudy
	set Data=$lb(ExamDesc,ResultDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRptContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRptContentExecute ]
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

ClassMethod FindRptContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRptContentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 20170920 by wq
/// 根据医嘱Id获取检验结果
/// d ##class(%ResultSet).RunQuery("web.DHCBPLab","FindLabResultByOrderId","219||13")
Query FindLabResultByOrderId(OrderId) As %Query(ROWSPEC = "serialNo,itemCode,itemDesc,abbreviation,unit,result,resultValue,flagUpDown,naturalRange") [ SqlProc ]
{
}

ClassMethod FindLabResultByOrderIdExecute(ByRef qHandle As %Binary, OrderId) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i (OrderId="")  goto Quit // "医嘱Id不能为空!" 
    s serialNo="",itemCode="",itemDesc="",abbreviation="",unit="",result="",resultValue="",flagUpDown="",naturalRange =""  
    s retResultStr=$$FindLabValuebyId(OrderId)
    f j=1:1:$l(retResultStr,"@") d
	.s resultStr=$p(retResultStr,"@",j)
	.s itemCode=$p(resultStr,"#",1)
	.s itemDesc=$p(resultStr,"#",2)
	.s unit=$p(resultStr,"#",6)
	.s naturalRange=$p(resultStr,"#",7)
	.s flagUpDown=$p(resultStr,"#",5)
	.s resultValue=$p(resultStr,"#",4)
	.q:resultValue=""
	.s abbreviation=$p(resultStr,"#",3)
	.d OutputById
	
	goto Quit

Quit
    Set qHandle=$lb(0,repid,0)
     Quit $$$OK
FindLabValuebyId(OrderId)
	s rset=##class(%ResultSet).%New("LabService.TSResult:GetResultByOrderId")	
	s ret="",isTooLong=0
	do rset.Execute(OrderId)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_"#"_rset.GetData(2)_"#"_rset.GetData(3)_"#"_rset.GetData(4)_"#"_rset.GetData(5)_"#"_rset.GetData(6)_"#"_rset.GetData(7)_"#"_rset.GetData(8)_"#"_rset.GetData(9)_"#"_rset.GetData(10)
		e  s ret=ret_"@"_rset.GetData(1)_"#"_rset.GetData(2)_"#"_rset.GetData(3)_"#"_rset.GetData(4)_"#"_rset.GetData(5)_"#"_rset.GetData(6)_"#"_rset.GetData(7)_"#"_rset.GetData(8)_"#"_rset.GetData(9)_"#"_rset.GetData(10)
		//w ret,!
	}	
	d rset.Close()
	q ret

OutputById
    set Data=$lb(serialNo,itemCode,itemDesc,abbreviation,unit,result,resultValue,flagUpDown,naturalRange)
     Set ^CacheTemp(repid,ind)=Data
     Set ind=ind+1
    quit
}

ClassMethod FindLabResultByOrderIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLabResultByOrderIdExecute ]
{
     Set AtEnd=$LIST(qHandle,1)
     Set repid=$LIST(qHandle,2)
     Set ind=$LIST(qHandle,3)
     Set ind=$o(^CacheTemp(repid,ind))
     If ind="" {                // if there are no more rows, finish fetching
         Set AtEnd=1
         Set Row=""
     }
     Else      {                // fetch row
         Set Row=^CacheTemp(repid,ind)
     }
     s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindLabResultByOrderIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLabResultByOrderIdExecute ]
{
    Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
     Quit $$$OK
}

}

Class web.DHCANOPLab Extends web.DHCClinicCom
{

ClassMethod LoadMedOrderByAdmId(regNo, admId)
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
    .s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
    .q:statusId=""
    .s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
    .s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
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
    .d ..AddItem(admId,ordItemId,LABDATA,regNo,ordStatus)

    q isAdd
}

ClassMethod AddItem(admId, ordItemId, LABDATA, regNo, ordStatus)
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
    s reportDate="",reportUser="",reportTime="",reportException=""
    i labRelatId'="" d
    .s labTSCode=$p(labRelatId,"||",2)
    .s labTSId=$p(labRelatId,"||",3)
    .q:labTSId=""
    .s reportDate=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",4)
    .i reportDate'="" s reportDate=$ZD(reportDate,3)
    .s reportTime=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",5)
    .i reportTime'="" s reportTime=$ZT(reportTime)
    .s reportUserCode=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",6)
    .
    .i (reportUserCode'="") s reportUser=$P($G(^SSU("SSUSR",1,reportUserCode)),"^",2)
    .s labstatus=##class(web.DHCBPLab).IflabnoVer(ordLabNo,arcExCode)
    .s labCpt=$P(labstatus,"^",1)
    .s labDate=$E($P(labstatus,"^",2),6,10)
    .s labTime=$P(labstatus,"^",3)
    s ordLabSpec="",specChildSub=0
    i $d(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))'=0 d
    .s specChildSub=0 f  s specChildSub=$o(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub)) q:specChildSub=""  d
    ..s labSpecCode=$g(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))
    ..s labSpecCode=$p(labSpecCode,"^",1)
    ..s labSpec=$p(^[LABDATA]TTAB("SPEC",labSpecCode),"\",1)
    ..i ordLabSpec="" s ordLabSpec=labSpec
    ..e  s ordLabSpec=ordLabSpec_","_labSpec

    s reportStatus="报告未出"
    i reportDate'="" s reportStatus="报告已出"
    s reportValuStatus=##Class(DWR.BL.LisReport).GetLisReportState(admId,ordLabNo)
    i reportValuStatus="报告未出" s reportStatus="报告未出"
    s reportException=##Class(DWR.BL.LisReport).GetLisReportExp(admId,ordLabNo)
    i reportException'="" s reportException=1
    e  s reportException=0
    i reportStatus="报告未出" s reportException=0

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

    s ordIndex=0
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

// fromDate:查询起始日期

// fromTime：查询起始时间

// filterStr: 字符串过滤医嘱

// medOrderCodeId: 医嘱码表Id

// filterPara //过滤条件

// arcimId:医嘱Id

// d ##class(%ResultSet).RunQuery("web.DHCBPLab","FindLabMedOrder","16047413",1,10,"2012-08-03","09:27:00","","18754||1")

Query FindLabMedOrder(regNo, from, count, queryPara, filterPara) As %Query(ROWSPEC = "ordIndex,recDept,ordLabNo,orderRowId,arcItemId,ordItemDesc,ordStatus,ordDate,ordTime,ordLabSpec,reportStatus,reportUser,reportDate,reportTime,reportException,admId") [ SqlProc ]
{
}

ClassMethod FindLabMedOrderExecute(ByRef qHandle As %Binary, regNo, from, count, queryPara = "", filterPara = "") As %Status
{
    //优先级：regNo,papmiMedicare,papmiName,ctlocId
    d InitPara
    s ^tmpbpDebug("regNo")=regNo
    //k ^tmpClLabMedOrder
    //k ^tmpCLLastLoad
    s date=$g(^tmpCLLastClearDate("date"))
    s span=$h-date
    i span>7 d
    .b // 每周清除缓存
    .s ^tmpCLLastClearDate("date")=+$h
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
    ...s isAdd=..LoadMedOrderByAdmId(regNo,admId)
    ...
    d OutputAll
    goto QuitBlock

OutputAll
    s index=0
    s curCount=0
    s date=+$h
    i fromDate'="" s date=..ConvertToDateH(fromDate)
	
    f  s date=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date),-1) q:((date=""))  d
    .s time=""
    .i date=fromDate s time=fromTime
    .f  s time=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date,time),-1) q:((time=""))  d
    ..s curArcmId="" f  s curArcmId=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date,time,curArcmId)) q:((curArcmId=""))  d
    ...s sub="" f  s sub=$O(^tmpClLabMedOrder(regNo,"TimeIndex",date,time,curArcmId,sub),-1) q:((sub=""))  d
    ....d LinkData
    ....
    q
LinkData
    set Data=^tmpClLabMedOrder(regNo,"Data",sub)
    s curOrderId=$List(Data,4)
    s curMedOrderCodeId=$List(Data,5)
    s curDesc=$List(Data,6)
    
    // 查询条件：index不增加
    q:curDesc'[filterStr
    q:((medOrderCodeId'="")&&(medOrderCodeId'=curMedOrderCodeId))

    s index=index+1
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
	 .s Data=..AddItem(admId,ordItemId,LABDATA,regNo,ordStatus)
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

// d ##class(%ResultSet).RunQuery("web.DHCBPLab","FindLabResult","2001513836")

Query FindLabResult(labNo) As %Query(ROWSPEC = "serialNo,itemCode,itemDesc,abbreviation,unit,result,resultValue,flagUpDown,naturalRange") [ SqlProc ]
{
}

ClassMethod FindLabResultExecute(ByRef qHandle As %Binary, labNo) As %Status
{
    s labNo=$TR(labNo,$C(0))
    s conLoad="",sort="" //Item
      Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    //d TestData goto QuitBlock // For Test

    i (labNo="")  goto QuitBlock // "202^标本号不能为空!"
    s needEpisodeID="", regNoList="", ctlocId="", standardCode=""
    s startDate="", startTime="", endDate="", endTime="", ifSingle = 0
    s needNote = "", dataField = ""

    s list=##class(web.DHCClinicCom).GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle, needNote, dataField, labNo)
    s len=$L(list,"#")
    f index=1:1:len  d
    .s itemStr=$P(list,"#",index)
    .q:itemStr=""
    .s serialNo=$P(itemStr,"\",10)
    .s itemCode=$P(itemStr,"\",7)
    .s itemDesc=$P(itemStr,"\",11)
    .
    .s abbreviation=$P(itemStr,"\",11)
    .s unit=$P(itemStr,"\",2)
    .s result=$P(itemStr,"\",1)
    .s resultValue=$P(result,"^",1)
    .;b
    .s result=$P(result,"^",2)
    .s flagUpDown=$P(itemStr,"\",12)
    .s naturalRange=$P(itemStr,"\",3)
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

ClassMethod FindLabResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPOrderExecute ]
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

ClassMethod FindLabResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPOrderExecute ]
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
	;s ^dhctmpmfc("1")=regNo_"/"_paadmdr_"/"_LocDr_"/"_startDate_"/"_enddate
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s Memo="",ItemStatus=""
	s StudyNo="",strOrderName="",strDate="",ItemStatus="",IsIll="",LocName="",IshasImg="N",MediumDR=""
	i regNo="" Quit $$$OK
    s papmiId="" f papmiId=$O(^PAPERi("PAPMI_PatNo",regNo,papmiId)) q:papmiId=""  d
	.s PAType="" f  s PAType=$o(^PAPERdr(papmiId,"ADM",PAType)) q:PAType=""  d
	..s PaadmdrOne=paadmdr f  s PaadmdrOne=$o(^PAPERdr(papmiId,"ADM",PAType,PaadmdrOne)) q:(PaadmdrOne="")  d
	...;w !,PaadmdrOne
	...s RegNo="",StudyNo="",strOrderName="",ItemStatus="",IsIll="",MediumName=""
	...s RptNum = 0
	...s OrderRowid=""
 	...s OrderRowid=$o(^OEORD(0,"Adm",PaadmdrOne,OrderRowid)) 
 	...q:OrderRowid="" 	
	...s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	....s Memo=""
	....s RegNo="",StudyNo="",strOrderName="",ItemStatus="N",IsIll="N"
	....s Image="",Shut="",Report="",MBrowse="",MRowid=""
	....s replocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	....q:(replocdr="")
	....s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	....i arcimid'="" s MRowid=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
	....i MRowid'="" s MBrowse="注意事项"
	....;add by wangli20081218
	....s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	....q:ItemStatDR=4
	....i LocDr'="" q:(replocdr'=LocDr)
	....s ClinicRowid=0
	....s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	....i ClinicRowid="" q
	....i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	....s IsVerify="N"  ;没有审核
	....s resrowid="" 
	....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	....s oeoriSttDat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	....q:(startDate'="")&&(oeoriSttDat<startDate)
	....q:(enddate'="")&&(oeoriSttDat>enddate)
	....s oeoriSttTim=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",10)
	....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	....s strDate=$zd(Date1,3)
	....s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	....s strTime=$zt(Time1)
	....s papatmasmdr=$p(^PAADM(PaadmdrOne),"^",1)
	....s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	....s PatientID=""
	....s PatientID=papatmasmdr
	....s oeorditemdr=OrderRowid_"||"_itemsub
	....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	....s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	....q:(ServerMaterial'="S") ;不是检查项目的则退出
	....s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	....q:(ItemStatDR'="1")&&(ItemStatDR'="6")
    ....; 获取预约日期和时间
	....s ResSchduleId="",AppDateTime=""
    ....s AppRowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
    ....i AppRowid'="" s ResSchduleId=$p(^DHCRBCResSchduleDetail("Detail",AppRowid),"^",2) 
    ....i ResSchduleId'="" d
    .....s AppDate=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",2)
    .....s AppTime=$p(^DHCRBCResourceSchdule(ResSchduleId),"^",5) 
    .....s AppDateTime=$zd(AppDate,3)_" "_$zt(AppTime)
    ....i AppDateTime="" d
    .....s AppDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	.....s AppTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	.....s AppDateTime=AppDate_""_AppTime
     
	....i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	....i ($g(^DHCRisVersion)="BJ_DT")&(replocdr="85") d ;地坛医院 心电科 做接口，如果医嘱状态为执行，则报告状态变为发布
	.....i ItemStatusCode="E"  s ItemStatus="Y"
	....//i ItemStatusCode="E"  s ItemStatus="Y"
	....//add by wl1031,for xindian--JH
	....i replocdr=85 s ItemStatus="Y"
	....s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	....i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	....i StudyNo'="" d
	.....s Imgrowid=0
	.....s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	.....i Imgrowid'="" s IshasImg="Y"
	.....s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	......s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	......s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	......s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	......s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	......s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	......i StatusCode="S" d
	.......s ItemStatus="Y"
	.......s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	........s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	........i FullFileName'="" s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	....q:StudyNo=""
	....;w "检查号:"_StudyNo,!
	....;w "入参:"_OrderRowid,itemsub,!
	....s tmpItemStatus=##CLASS(web.DHCRisclinicQueryOEItemDo).GetOEOrdStatus(OrderRowid,itemsub)
	....;w "结果"_tmpItemStatus,!
	....s ItemStatus=$p(tmpItemStatus,"^",1)
	....s ItemCode=$p(tmpItemStatus,"^",2)
	....i ItemCode="RP" d
	.....;s Image="图像"
	.....;s Shut="关闭"
	.....s Report="报告"
	....Do OutputRow1
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

}

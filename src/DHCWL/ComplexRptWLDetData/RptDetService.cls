Class DHCWL.ComplexRptWLDetData.RptDetService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     	yw
/// CreatDate：    	2016-01-05
/// Description：	收入明细查询
/// Table：    		DHCWL_ComplexRpt.RptCfg,DHCWL_ComplexRpt.RowsColCfg
/// Input：       	queryFlag:0-明细,1-汇总,2-还原. 
///                 startDate:开始日期, endDate:结束日期, stCode:合并类型, 
///                 rptCond:统计模式、显示内容、过滤内容串(@符合分隔), dynParams:动态参数
/// Output： 		wlRowid:收入表rowid,kpiDim:统计项目代码,stDesc:统计项目描述,dimAtt:维度属性代码,dimAttName:维度属性名称,
///                 dimAttValue:维度属性值,wlValue:统计项值,serialNo:序号,stDescDimAtt:统计项和维度属性		
/// Return：      
/// Others：j ##class(%ResultSet).RunQuery("DHCWL.ComplexRptWLDetData.RptDetService","QueryReportData","0","2013-07-01","2013-07-02","","","","")
Query QueryReportData(queryFlag, startDate, endDate, stCode, rptCond As %Text, dynParams As %String = "", parDimAttValue As %String = "", detFlag As %String) As %Query(ROWSPEC = "wlRowid:%String,kpiDim:%String,stDesc:%String,dimAtt:%String,dimAttName:%String,dimAttValue:%String,wlValue:%String,serialNo:%String,stDescDimAtt:%String") [ SqlProc ]
{
}

ClassMethod QueryReportDataExecute(ByRef qHandle As %Binary, queryFlag, startDate, endDate, stCode, rptCond As %Text, dynParams As %String = "", parDimAttValue As %String = "", detFlag As %String = "") As %Status
{
	n (qHandle,queryFlag,startDate,endDate,stCode,rptCond,dynParams,map,dims,parDimAttValue,rptName,detFlag)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
   
	q:(startDate="")!(endDate="") $$$OK
	k ^TEMPDHCWL($j)

	
	i queryFlag=0 k ^TEMPDHCWLDet($j)
	i queryFlag=0 k ^TEMPDHCWLSpec($j,"ItemWlRowid")
    //i (detFlag=2) k ^TEMPDHCWLSpec($j,"ItemWlRowid")
    
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
  
    s cntWlRowid="",sumSerialNo=""
    s rptStatMode=$p(rptCond,"@",1)
    s rptCol=$p(rptCond,"@",2)
    s condNum=$l(rptCol,",")
    s filterCon=$p(rptCond,"@",3)
    i dynParams'="" s filterCon=..handleFilterParam(filterCon, dynParams)  //动态参数转换
   
    i (queryFlag=0)!(queryFlag=1) d  //合并数据时当第一个统计项为统计内容时统计条件排序
    .s paraSub=$P(rptCol,",",1)
    .s kpiDim=$P(paraSub,".",1)
	.s statItemId=..GetStatItemID(kpiDim)
	.s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
	.i stType="C" s rptCol=..StatItemSort(rptCol) 
	
    s filterFlag=0
    i filterCon'="" {  //过滤表达式解析
	    s filterFlag=1
    	s filterDim=..ResovleFilterRule(filterCon)
    	s i=filterDim.Next()
		while (i){	
			s dim=$P(filterDim.GetAt(i),".",1)
			s statItemId=..GetStatItemID(dim)
			q:statItemId=""
			s stDimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),5) 
			s map(dim)=stDimDr
			s i=filterDim.Next(i)
		}
    	s filter=##class(DHCWL.MKPIService.Base.Filter).%New()
		d filter.ResovleFilterRule(filterCon,.map)
    }
     
	s colLen=$l(rptCol,",")
	f serialNo=1:1:colLen d
	.s paraSub=$p(rptCol,",",serialNo)
	.s kpiDim=$P(paraSub,".",1)
	.s dimAtt=$P(paraSub,".",2)
	.s statItemId=..GetStatItemID(kpiDim)
	.s wlPiece=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),6) 
	.s stDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),3)
	.s stDimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),5)
	.s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
	.i stType="C" d 
	..s dimAtt=kpiDim
	..s stDimDr=stType
 	.s ^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,"DispCon")=wlPiece_"^"_stDesc_"^"_stDimDr
    
 	i queryFlag=0 d     //查询明细 // serialNo,kpiDim,dimAtt,wlRowid
	.d GetStatMode(rptStatMode)
	.d OutPutSum()
	e  i queryFlag=1 d  //合并数据
	.s serialNo=0 f  s serialNo=$o(^TEMPDHCWLDet($j,serialNo)) q:serialNo=""  d 
 	..s kpiDim=0 f  s kpiDim=$o(^TEMPDHCWLDet($j,serialNo,kpiDim)) q:kpiDim=""  d
	...s statItemId=..GetStatItemID(kpiDim)
	...q:statItemId=""
	...s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4) 
 	...s dimAtt=0 f  s dimAtt=$o(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt)) q:dimAtt=""  d 
 	....s stCodeDimAtt=kpiDim_"."_dimAtt
 	....q:(parDimAttValue="")&&(stCode'="")&&(stCodeDimAtt'=stCode)&&(stType'="C") 
 	....s wlRowid=0 f  s wlRowid=$o(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,wlRowid)) q:wlRowid=""  d 
 	.....;i $d(^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid)) b ;999
 	.....q:'$d(^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid))&&(parDimAttValue'="")
 	.....s detData=0 f  s detData=$o(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,wlRowid,detData)) q:detData=""  d
 	......;q:(parDimAttValue'="")&&(detData'="FilterDetData") //弹出页合并从已过滤数据取数
 	......q:(parDimAttValue'="")&&(stCode'="")&&(stCodeDimAtt'=stCode)&&(stType'="C") 
 	......s dispValue=$g(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,wlRowid,"DetData"))  //new
 	......q:(dispValue="")
 	......s stDesc=$P(dispValue,"^",1)
 	......s dimAttName=$P(dispValue,"^",2)
 	......s dimAttValue=$P(dispValue,"^",3)
 	......s wlValue=$P(dispValue,"^",4)
 	......s flag=$IsValidNum(wlRowid)
 	......q:flag'=1
 	......i stType'="C" s stDescDimAtt=stDesc_dimAttName
 	......e  s stDescDimAtt=stDesc
 	......//
 	......i (parDimAttValue'="") d //调用弹出页时过滤数据
 	......s wlStr=kpiDim_"^"_stDesc_"^"_dimAtt_"^"_dimAttName_"^"_dimAttValue_"^"_wlValue_"^"_stDescDimAtt
 	......i $g(^TEMPDHCWL($j,"wlRowid",wlRowid))="" d
 	.......s ^TEMPDHCWL($j,"wlRowid",wlRowid)=wlStr
 	......e  s ^TEMPDHCWL($j,"wlRowid",wlRowid)=$g(^TEMPDHCWL($j,"wlRowid",wlRowid))_"@"_wlStr
 	.;b ;yy
 	.s wlRowid=0 f  s wlRowid=$o(^TEMPDHCWL($j,"wlRowid",wlRowid)) q:wlRowid=""  d
 	..s wlStr=$g(^TEMPDHCWL($j,"wlRowid",wlRowid))
 	..s len=$l(wlStr,"@")
 	..s combItem=$P(wlStr,"@",1)
 	..f s1=2:1:len d
 	...s cotentStr=$P(wlStr,"@",s1)
 	...s value=$P(cotentStr,"^",5)
 	...s kpiDim=$P(cotentStr,"^",1)
 	...s statItemId=..GetStatItemID(kpiDim)
	...q:statItemId=""
	...s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
 	...s kpiDimFlag=""_kpiDim_""
 	...s ^TEMPDHCWL($j,"CombineData",combItem,kpiDimFlag)=$g(^TEMPDHCWL($j,"CombineData",combItem,kpiDimFlag))+value
 	...s ^TEMPDHCWL($j,"CombineData",combItem,kpiDimFlag,"Content")=s1_"@"_cotentStr
 	...;b ;rr
 	.;显示合并数据
 	.;b ;dd
 	.// wlRowid,kpiDim,stDesc,dimAtt,dimAttName,dimAttValue2,wlValue,serialNo,stDescDimAtt,combineItem
 	.s combItem=0 f  s combItem=$o(^TEMPDHCWL($j,"CombineData",combItem)) q:combItem=""  d
 	..s kpiDim=$p(combItem,"^",1)
 	..s statItemId=..GetStatItemID(kpiDim)
 	..s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
 	..s stDesc=$p(combItem,"^",2)
 	..s dimAtt=$p(combItem,"^",3)
 	..s dimAttName=$p(combItem,"^",4)
 	..s dimAttValue=$p(combItem,"^",5)
 	..q:(+dimAttValue=0)&&($IsValidNum(dimAttValue)=1)
 	..s wlValue=$p(combItem,"^",6)
 	..s stDescDimAtt=$p(combItem,"^",7)
 	..s wlRowid=wlValue
 	..s serialNo=1
 	..d OutPutRow
 	..s kpiDim1="",stDesc1="",dimAtt1="",dimAttName1="",dimAttValue1="",wlValue1="",wlRowid1="合计"
 	..s kpiDimFlag=""_kpiDim_""
 	..s contentStr=kpiDim1_"^"_stDesc1_"^"_dimAtt1_"^"_dimAttName1_"^"_dimAttValue1_"^"_wlValue1_"^"_stDescDimAtt_"^"_wlRowid1
 	..s ^TEMPDHCWL($j,"TotContent",wlRowid,kpiDimFlag)=serialNo_"!"_contentStr
 	..;处理分组小计
 	..s kpiDimFlag=0 f  s kpiDimFlag=$o(^TEMPDHCWL($j,"CombineData",combItem,kpiDimFlag)) q:kpiDimFlag=""  d
 	...s combineValue=$g(^TEMPDHCWL($j,"CombineData",combItem,kpiDimFlag))
 	...s content=$g(^TEMPDHCWL($j,"CombineData",combItem,kpiDimFlag,"Content"))
 	...s serialNo=$P(content,"@",1)
 	...s cotentStr=$P(content,"@",2)
 	...s kpiDim=$p(cotentStr,"^",1)
 	...s statItemId=..GetStatItemID(kpiDim)
 	...s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
 	...s stDesc=$p(cotentStr,"^",2)
 	...s dimAtt=$p(cotentStr,"^",3)
 	...s dimAttName=$p(cotentStr,"^",4)
 	...s dimAttValue=combineValue
 	...q:(+dimAttValue=0)&&($IsValidNum(dimAttValue)=1)
 	...s stDescDimAtt=$p(cotentStr,"^",7)
 	...s wlRowid=wlValue
 	...d OutPutRow
 	...s kpiDim1="",stDesc1="",dimAtt1="",dimAttName1="",dimAttValue1="",wlValue1="",wlRowid1="合计"
 	...s kpiDimFlag=""_kpiDim_""
 	...s contentStr=kpiDim1_"^"_stDesc1_"^"_dimAtt1_"^"_dimAttName1_"^"_dimAttValue1_"^"_wlValue1_"^"_stDescDimAtt_"^"_wlRowid1
 	...i (stType="C") d 
 	....s ^TEMPDHCWL($j,"TotContent",kpiDimFlag)=$g(^TEMPDHCWL($j,"TotContent",kpiDimFlag))+dimAttValue
 	...s ^TEMPDHCWL($j,"TotContent",wlRowid,kpiDimFlag)=serialNo_"!"_contentStr
 	.d OutPutSum()  //合并数据汇总
 	.
 	e  i queryFlag=2 d  //还原数据
 	.s sumSerialNo=0
 	.s cntWlRowid=""
	.s serialNo=0 f  s serialNo=$o(^TEMPDHCWLDet($j,serialNo)) q:serialNo=""  d 
 	..s kpiDim=0 f  s kpiDim=$o(^TEMPDHCWLDet($j,serialNo,kpiDim)) q:kpiDim=""  d
	...s statItemId=..GetStatItemID(kpiDim)
	...s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4) 
 	...s dimAtt=0 f  s dimAtt=$o(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt)) q:dimAtt=""  d
 	....s stCodeDimAtt=kpiDim_"."_dimAtt
 	....s wlRowid=0 f  s wlRowid=$o(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,wlRowid)) q:wlRowid=""  d 
 	.....s flag=$IsValidNum(wlRowid)
 	.....q:flag'=1
 	.....;w "tt="_kpiDim_"^"_dimAtt,!
 	.....d RestoreData()
 	.d OutPutSum()
 	 
 	k ^TEMPDHCWL($j)
 	Quit $$$OK
    
  
GetStatMode(stModeCode)      //取workload数据
 i stModeCode="OrdDate" s stModeCode=$ZCVT(stModeCode,"U") 
 i stModeCode="DISDATE" d  
 .s cntWlRowid=0    
 .f date=startDate:1:endDate d
 ..s admId=0 f  s admId=$o(^PAADMi("DischDate",date,admId)) q:admId=""  d
 ...//s sumFlag=0
 ...s singleFlag=0
 ...s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"PAADM",admId,wlRowid)) q:wlRowid=""  d
 ....s cntWlRowid=cntWlRowid+1
 ....d GetDetailData(wlRowid)
 e  d    
 .s cntWlRowid=0
 .f date=startDate:1:endDate d
 ..//s sumFlag=0
 ..s singleFlag=0
 ..s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,stModeCode,date,wlRowid)) q:wlRowid=""  d
 ...s cntWlRowid=cntWlRowid+1
 ...d GetDetailData(wlRowid)
 q
 
GetDetailData(wlRowid)	
 s flag=0
 s ^TEMPDHCWL($j,"wlRowid",wlRowid)=""
 s statItemId=0 f  s statItemId=$o(^DHCWL.ComplexRpt.StatItemD(statItemId)) q:(statItemId="")  d 
 .s stCode1=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),2)
 .s wlPiece=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),6) 
 .s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
 .q:'$d(map(stCode1))
 .s dims(stCode1)=$P(^DHCWorkLoad(wlRowid),"^",wlPiece)
 i filterFlag=1 s flag=filter.FilterValues(.dims)
 ;b ;aa
 
 i (filterFlag=0)!(flag=1) d //有过滤表达式且过滤条件满足才过滤
 .s serialNo=0 f  s serialNo=$o(^TEMPDHCWLDet($j,serialNo)) q:serialNo=""  d 
 ..s kpiDim=0 f  s kpiDim=$o(^TEMPDHCWLDet($j,serialNo,kpiDim)) q:kpiDim=""  d 
 ...s statItemId=..GetStatItemID(kpiDim)
 ...s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4) 
 ...s dimAtt=0 f  s dimAtt=$o(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt)) q:dimAtt=""  d 
 ....s dispConStr=$g(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,"DispCon"))
 ....q:dispConStr=""
 ....s wlPiece=$P(dispConStr,"^",1)
 ....s stDesc=$P(dispConStr,"^",2)
 ....s stDimDr=$P(dispConStr,"^",3)
 ....s wlValue=$P(^DHCWorkLoad(wlRowid),"^",wlPiece)
 ....i stType'="C" s dimAttStr=..GetDimAttValue(stDimDr,dimAtt,wlValue) 
 ....e  s dimAttStr= stDesc_"^"_wlValue
 ....s dimAttName=$P(dimAttStr,"^",1)
 ....s dimAttValue=$P(dimAttStr,"^",2)
 ....s stCodeDimAtt=kpiDim_"."_dimAtt
 ....q:(stCode'="")&&(stCodeDimAtt'=stCode)&&(stType'="C") 
 ....q:$d(^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid))&&(stCode'="")
 ....q:(+dimAttValue=0)&&($IsValidNum(dimAttValue)=1)
 ....// 下面是明细global
 ....s ^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,wlRowid,"DetData")=stDesc_"^"_dimAttName_"^"_dimAttValue_"^"_wlValue
 ....i stType'="C" s stDescDimAtt=stDesc_dimAttName
 ....e  s stDescDimAtt=stDesc
 ....
 ....d OutPutRow
 ....;//合计:
 ....s kpiDim1="",stDesc1="",dimAtt1="",dimAttName1="",dimAttValue1="",wlValue1="",wlRowid1="合计"
 ....s kpiDimFlag=""_kpiDim_""
 ....s contentStr=kpiDim1_"^"_stDesc1_"^"_dimAtt1_"^"_dimAttName1_"^"_dimAttValue1_"^"_wlValue1_"^"_stDescDimAtt_"^"_wlRowid1
 ....i (stType="C") d 
 .....s ^TEMPDHCWL($j,"TotContent",kpiDimFlag)=$g(^TEMPDHCWL($j,"TotContent",kpiDimFlag))+dimAttValue
 ....s ^TEMPDHCWL($j,"TotContent",wlRowid,kpiDimFlag)=serialNo_"!"_contentStr
 q
 
RestoreData()
 	s dispValue=$g(^TEMPDHCWLDet($j,serialNo,kpiDim,dimAtt,wlRowid,"DetData"))
 	s stDesc=$P(dispValue,"^",1)
 	s dimAttName=$P(dispValue,"^",2)
 	s dimAttValue=$P(dispValue,"^",3)
 	s wlValue=$P(dispValue,"^",4)
 	i stType'="C" s stDescDimAtt=stDesc_dimAttName
 	e  s stDescDimAtt=stDesc
 	i (stCode'="")&&(stCodeDimAtt=stCode)&&(parDimAttValue'="")&&(parDimAttValue=wlValue)&&(stType'="C") d 
 	.i (detFlag=1)||(detFlag="") s ^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid)=""   //每过滤一次存已过滤记录收入wlRowid
 	.i (detFlag=2) d
 	..s ^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid)=""
 	..s ^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid)=$g(^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid))+1
 	q:'$d(^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid))&&(parDimAttValue'="")
 	i (wlRowid=104)&&(stCodeDimAtt="PatLoc.LocDesc") b ;333
 	q:($g(^TEMPDHCWLSpec($j,"ItemWlRowid",wlRowid))<1)&&(detFlag=2)&&(parDimAttValue'="")   //存在rowid则过滤
	i (wlRowid=104)&&(stCodeDimAtt="PatLoc.LocDesc") b ;444
 	s sumSerialNo=sumSerialNo+1
 	i (parDimAttValue'="") d //调用弹出页时过滤数据
 	d OutPutRow
 	;处理合计
 	s kpiDim1="",stDesc1="",dimAtt1="",dimAttName1="",dimAttValue1="",wlValue1="",wlRowid1="合计"
 	s kpiDimFlag=""_kpiDim_""
 	s contentStr=kpiDim1_"^"_stDesc1_"^"_dimAtt1_"^"_dimAttName1_"^"_dimAttValue1_"^"_wlValue1_"^"_stDescDimAtt_"^"_wlRowid1
 	i (stType="C") d 
 	.s ^TEMPDHCWL($j,"TotContent",kpiDimFlag)=$g(^TEMPDHCWL($j,"TotContent",kpiDimFlag))+dimAttValue
 	s ^TEMPDHCWL($j,"TotContent",wlRowid,kpiDimFlag)=serialNo_"!"_contentStr
    q
    
    
    
 
OutPutSum()
 s lastFlag=0
 s wlRowid="" f  s wlRowid=$o(^TEMPDHCWL($j,"TotContent",wlRowid)) q:(wlRowid="")!(lastFlag=1)  d 
 .s lastFlag=1
 .s kpiDimFlag=0 f  s kpiDimFlag=$o(^TEMPDHCWL($j,"TotContent",wlRowid,kpiDimFlag)) q:(kpiDimFlag="")  d 
 ..s lastStr=$g(^TEMPDHCWL($j,"TotContent",wlRowid,kpiDimFlag))
 ..s serialNo=$p(lastStr,"!",1)
 ..s oupStr=$p(lastStr,"!",2)
 ..s kpiDim=$p(oupStr,"^",1)
 ..s statItemId=..GetStatItemID(kpiDimFlag)
 ..s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
 ..s stDesc=$p(oupStr,"^",2)
 ..s dimAtt=$p(oupStr,"^",3)
 ..s dimAttName=$p(oupStr,"^",4)
 ..s totalContent=$g(^TEMPDHCWL($j,"TotContent",kpiDimFlag))
 ..s stDescDimAtt=$p(oupStr,"^",7)
 ..s wlRowid1=$p(oupStr,"^",8)
 ..i stType'="C" d
 ...i (serialNo=1) s totalContent="合计" 
 ...e  i (serialNo=2) d
 ....i cntWlRowid'="" s totalContent=$g(cntWlRowid) 
 ....e  s totalContent=$fn(sumSerialNo/condNum,"","")
 ...e  s totalContent=""
 ..s stCodeDimAtt=kpiDim_"."_dimAtt
 ..w "ret-2-B"_dimAttName_"^"_totalContent_"@@"_dimAttValue,!
 ..d OutPutRow1
 q
 
 	
OutPutRow
    s Data=$lb(wlRowid,kpiDim,stDesc,dimAtt,dimAttName,dimAttValue,wlValue,serialNo,stDescDimAtt)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow1
    s Data=$lb(wlRowid1,kpiDim,stDesc,dimAtt,dimAttName,totalContent,wlValue1,serialNo,stDescDimAtt)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryReportDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportDataExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReportDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportDataExecute ]
{
	n (AtEnd,qHandle,Row)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据维度代码和维度属性代码取维度属性值
/// w ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetDimAttValue("CTLOC","LOCDESC",9)
ClassMethod GetDimAttValue(dimCode, dimAttCode, dimValue) As %String
{
	n (dimCode,dimAttCode,dimValue)
	s dimAttCode=$ZCVT(dimAttCode,"U")
	s dimDr=dimCode
	s dimAttDr=$O(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimAttCode,""))
	;b ;sss
	s dimProName=$lg(^DHCWL.MKPI.DimPropertyD(dimAttDr),4)
	s dimProExeCode=$lg(^DHCWL.MKPI.DimPropertyD(dimAttDr),6)
	s execStr="s desc=$$"_dimProExeCode_"(dimValue)" 
	x execStr
	s dimAttStr=dimProName_"^"_desc
	q $g(dimAttStr)
}

/// 20160503bak
ClassMethod GetDimAttValueOld20160503(dimCode, dimAttCode, dimValue) As %String
{
	n (dimCode,dimAttCode,dimValue)
	s dimCode111=dimCode
	s dimCode=$ZCVT(dimCode,"U")
	s dimDr=$O(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",dimCode,""))
	s dimAttCode=$ZCVT(dimAttCode,"U")
	;b ;hhh
	s dimAttDr=$O(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimAttCode,""))
	;b ;sss
	s dimProName=$lg(^DHCWL.MKPI.DimPropertyD(dimAttDr),4)
	s dimProExeCode=$lg(^DHCWL.MKPI.DimPropertyD(dimAttDr),6)
	s execStr="s desc=$$"_dimProExeCode_"(dimValue)" 
	x execStr
	s dimAttStr=dimProName_"^"_desc
	q $g(dimAttStr)
}

/// Creator：     	hetong
/// CreatDate：    	2015-12-31
/// Description：	根据统计项编码获取对应的描述
/// w ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetContentDesc("PatLoc")
ClassMethod GetContentDesc(stat As %String) As %String
{
	n (stat)
	s statDesc=""
	s statDr=##class(DHCWL.ComplexRptData.SaveData).GetStatItemidByCode(stat)
	q:statDr="" statDesc
	s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statDr),3) ;统计项描述
	q statDesc
}

/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetTransDim("kpi","am,No,I","RegBoc,RegLoc",.str)
ClassMethod GetTransDim(kpi As %String, dimList As %String, col As %String, ByRef dimArr, ByRef dimDescStr) As %Status
{
	n (kpi,dimList,col,dimArr,dimDescStr)
	
	k:$d(dimDescStr) dimDescStr
	q:(kpi="")!(dimList="")!(col="") 1
	s j=0
	f i=1:1:$l(col,","){
		s dimCode=$P(col,",",i)
		continue:dimCode=""
		s pos=$g(dimArr(kpi,dimCode))
		s posDesc=$P(dimList,",",pos)
		s j=j+1
		s $P(dimDescStr,",",j)=posDesc
	}
	q 1
}

/// Creator：     	yw
/// CreatDate：    	2016-01-19
/// Description：	获取临时报表文件
/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetTempRpt()
ClassMethod GetTempRpt() As %Integer
{
	n 	
	s str="",deli=","
	s pid=0 f  s pid=$o(^TEMPDHCWLCon(pid)) q:pid=""  d
	.s text=0 f  s text=$o(^TEMPDHCWLCon(pid,"DispCon",text)) q:text=""  d
	..s str=str_"['"_text_"'"_deli_"'"_text_"'],"
	w "["_$e(str,1,$l(str)-1)_"]"
	q 1
}

ClassMethod CreateKpiByRptId(ByRef rptCfgArr) As %Integer
{
	n (rptCfgArr)
	q 0
}

ClassMethod SaveRptCfgToGlobal(ByRef rptCfgArr)
{
	//n (rptCfgArr)
	k ^TEMPDHCWLCon($j,"DispCon")
	k ^TEMPDHCWLCon($j,"FilterCon")
	s ^YW20160153A(0)=$j
	s rptId=$g(rptCfgArr("RptId"))
	s modeCfg=$g(rptCfgArr("Mode"))
	s contentCfg=$g(rptCfgArr("Content"))
	s rowCfg=$g(rptCfgArr("Row"))
	s colCfg=$g(rptCfgArr("Col"))
	s filterCfg=$g(rptCfgArr("Filter"))
	//s dispCon=modeCfg_"@"_colCfg_"@"_contentCfg
	s dispCon=modeCfg_"@"_colCfg_"@"_contentCfg
	s ^TEMPDHCWLCon($j,"DispCon",dispCon)=""
	s ^TEMPDHCWLCon($j,"FilterCon",filterCfg)=""
	q
}

/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).SetTransDimPos("kpi","PatLoc.LocDesc,PatDoc.DocName","PatLoc.LocDesc,PatDoc.DocName",.dim,.paraStr)
/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).SetTransDimPos("kpi","PatLoc.LocDesc,PatDoc.DocName,TotalPrice.TotalPrice,TarEC.TarEC,TARI.TARIName","PatLoc.LocDesc,PatDoc.DocName,TotalPrice.TotalPrice,TarEC.TarEC,TARI.TARIName",.dim)
ClassMethod SetTransDimPos(kpi As %String, row As %String, col As %String, ByRef dim, ByRef paraStr) As %Status
{
	n (kpi,col,row,dim,paraStr)
	
	k:$d(dim) dim
	k:$d(paraStr) paraStr
	q:row="" 1
	s outStr=row_","_col
	f m=1:1:$l(kpi,","){
		s kpiCode=$P(kpi,",",m)
		s j=0,para=""
		f i=1:1:$l(outStr,","){
			s colCode=$P(outStr,",",i)
			continue:colCode=""
			continue:$d(dim(kpiCode,colCode))
			s j=j+1
			s dim(kpiCode,colCode)=j
			s $P(para,"^",j)=colCode
		}
		s paraLoop=$Case(para,"":kpiCode,:kpiCode_":"_para)
		i $g(paraStr)="" s paraStr=paraLoop
		e  s paraStr=paraStr_","_paraLoop
	}
	s paraStr=""""_paraStr_""""
	q 1
}

/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetCombineItem("")
ClassMethod GetCombineItemOld(condStr As %Text) As %Integer
{
	n (condStr,dim)
	k ^TEMPDHCWL($j,"dim")
	s ^YW20160153A(55)="OrdDate@PatLoc.LocDesc,PatDoc.DocName,TARI.TARIName@[{PatLoc} = 7]"
	//s condStr="OrdDate@PatLoc.LocDesc,PatDoc.DocName,TARI.TARIName@[{PatLoc} = 7]"
	;s ^YW20160153A(66)=$j
	s condStr=$P(condStr,"@",2)
	d ##class(DHCWL.ComplexRptData.RptService).SetTransDimPos("kpi",condStr,condStr,.dim)
	s str="",deli=","
	s statStr=0 f  s statStr=$o(dim("kpi",statStr)) q:statStr=""  d
	.s serialNo=$g(dim("kpi",statStr))
	.s kpiDim=$P(statStr,".",1)
	.s dimAtt=$P(statStr,".",2)
	.s ^TEMPDHCWL($j,"dim",serialNo,kpiDim,dimAtt,"DispCon")=""
	
	s serialNo=0 f  s serialNo=$o(^TEMPDHCWL($j,"dim",serialNo)) q:serialNo=""  d
	.s kpiDim=0 f  s kpiDim=$o(^TEMPDHCWL($j,"dim",serialNo,kpiDim)) q:kpiDim=""  d
	..s statItemId=$O(^DHCWL.ComplexRpt.StatItemI("StCode",""_kpiDim,""))
	..i statItemId="" s statItemId=$O(^DHCWL.ComplexRpt.StatItemI("StCode",kpiDim,"")) 
	..q:statItemId=""
	..s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4) 
	..q:(stType="C")
	..s stDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),3) 
	..s dimAtt=0 f  s dimAtt=$o(^TEMPDHCWL($j,"dim",serialNo,kpiDim,dimAtt)) q:dimAtt=""  d
	...s str=str_"['"_kpiDim_"."_dimAtt_"'"_deli_"'"_stDesc_"'],"
	w "["_$e(str,1,$l(str)-1)_"]"
	q 1
}

/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetCombineItem("")
ClassMethod GetCombineItem(condStr As %Text) As %Integer
{
	n (condStr,dim)
	k ^TEMPDHCWL($j,"dim")
	///s condStr="OrdDate@PatLoc.LocDesc,PatDoc.DocName,TARI.TARIName@[{PatLoc} = 7]"
	//s condStr="OrdDate@PatLoc.LocCode,PatDoc.DocCode,TotalPrice.TotalPrice,Quantity.Quantity@[{PatLoc} = 11]"
	//s condStr="OrdDate@PatLoc.LocDesc,PatDoc.DocName@[{PatLoc} = 7]"
	
	s condStr=$P(condStr,"@",2)
	d ##class(DHCWL.ComplexRptData.RptService).SetTransDimPos("kpi",condStr,condStr,.dim)
	s str="",deli=","
	s statStr=0 f  s statStr=$o(dim("kpi",statStr)) q:statStr=""  d
	.s serialNo=$g(dim("kpi",statStr))
	.s kpiDim=$P(statStr,".",1)
	.s dimAtt=$P(statStr,".",2)
	.s ^TEMPDHCWL($j,"dim",serialNo,kpiDim,dimAtt,"DispCon")=""
	
	;b ;00
	s serialNo=0 f  s serialNo=$o(^TEMPDHCWL($j,"dim",serialNo)) q:serialNo=""  d
	.s kpiDim=0 f  s kpiDim=$o(^TEMPDHCWL($j,"dim",serialNo,kpiDim)) q:kpiDim=""  d
	..s statItemId=..GetStatItemID(kpiDim)
	..s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4) 
	..q:(stType="C")
	..s stDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),3)
	..s stDimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),5)  
	..s dimAtt=0 f  s dimAtt=$o(^TEMPDHCWL($j,"dim",serialNo,kpiDim,dimAtt)) q:dimAtt=""  d
	...s dimAttDr=..GetDimAttID(stDimDr,dimAtt)
	...s dimProName=$lg(^DHCWL.MKPI.DimPropertyD(dimAttDr),4) 
	...s dimAndDimAtt=stDesc_""_dimProName
	...s str=str_"['"_kpiDim_"."_dimAtt_"'"_deli_"'"_dimAndDimAtt_"'],"
	...;s str=str_"['"_kpiDim_"."_dimAtt_"'"_deli_"'"_stDesc_"'],"
	w "["_$e(str,1,$l(str)-1)_"]"
	k ^TEMPDHCWL($j,"dim")
	q 1
}

/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetRptCfgFilter("a11")
ClassMethod GetRptCfgFilter(condStr As %Text)
{
	n (condStr)
	s filterStr=$P(condStr,"@",3)
	s str="",deli=","
	s str=str_"{""filterStr"":"""_filterStr_""""_"},"
	w "{data:"
	w "["_$e(str,1,$l(str)-1)_"]"
	w ",success:true,tip:'ok'}"
}

/// d ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetRptCfgMode("9999")
ClassMethod GetRptCfgMode(condStr As %Text)
{
	n (condStr)
	s str="",deli=","
	i condStr="" {
		w "{data:"
		w "["_$e(str,1,$l(str)-1)_"]"
		w ",success:true,tip:'ok'}"
		q
	}
	s statModeCode=$P(condStr,"@",1)
	//s statModeCode="OrdDate"
	s stModeId=$O(^DHCWL.ComplexRpt.StatModeI("StModeCode"," "_statModeCode,""))
	i stModeId="" s stModeId=$O(^DHCWL.ComplexRpt.StatModeI("StModeCode",statModeCode,"")) 
	;q:stModeId=""
	i stModeId="" {
		w "{data:"
		w "["_$e(str,1,$l(str)-1)_"]"
		w ",success:true,tip:'ok'}"
		q
	}
	s stModeDesc=$lg(^DHCWL.ComplexRpt.StatModeD(stModeId),3) 
	;s str=str_"{""filterStr"":"""_condStr_""""_"},"
	s str=str_"{""modeCode"":"""_statModeCode_""""_"},{""modeDesc"":"""_stModeDesc_""""_"},"
	w "{data:"
	w "["_$e(str,1,$l(str)-1)_"]"
	w ",success:true,tip:'ok'}"
	//q 1
}

/// w ##class(DHCWL.ComplexRptData.RptCfgService).ResovleFilterData("[[[[{PatLoc.LocCode} =C {157001,102000,103000] && [{ResLoc.LocDesc} [ 急诊内科]")
ClassMethod ResovleFilterData(filterStr As %Text) As %String
{
	n (filterStr)
	q:filterStr="" ""
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"[")
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"]")
	s filterStr=##class(DHCWL.util.StringUtil).EscapeStr(filterStr,"[","\")
	s filterStr2=$zcvt(filterStr,"U")
	s choiceFilter="",ind=0,best=0,bestFilter=""
	f {
		s choiceFilter=$o(^DHCWL.MKPI.SysFilterFuncI("Code",choiceFilter))
		q:choiceFilter=""
		s choiceFilter2=##class(DHCWL.util.StringUtil).Trim(choiceFilter)
		if (($l(choiceFilter2)>best)&&($f(filterStr2,choiceFilter2)>0)){
			s best=$l(choiceFilter2),bestFilter=choiceFilter2
			s ind=$f(filterStr2,choiceFilter2)
		}
	}
	q:ind=0 dimArray
	s choiceFilter=bestFilter
	s dimPro=$e(filterStr,1,(ind-$l(choiceFilter)-1))
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"{")
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"}")
	q dimPro
}

/// hetong
/// 2015-10-21
/// 分割过滤规则表达式
/// w ##class(DHCWL.ComplexRptData.RptCfgService).ResovleFilterRule("[{PatLoc.LocCode} =C {157001,&&1020||||00,103000] &&&& [{ResLoc.LocDesc} [ 急诊内科]")
/// w ##class(DHCWL.ComplexRptData.RptCfgService).ResovleFilterRule("[{PatLoc} = 7] && [{TARI.TARIName} = 挂号费]")
ClassMethod ResovleFilterRule(filterStr As %Text) As %AbstractArray
{
	n (filterStr)
	s dimArray=##class(%ArrayOfDataTypes).%New()
	q:filterStr="" dimArray
	s logAnd="&&",logOr="||",ProS="{",ProE="}",indNum=1
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr)
	s len=$l(filterStr,logAnd)
	f i=1:1:len {
		s dataStr=$P(filterStr,logAnd,i)
		i (dataStr [ logOr){
			f j=1:1:$l(dataStr,logOr) {
				s expStr=$P(dataStr,logOr,j)
				continue:((expStr '[ ProS)||(expStr '[ ProE))
				s dimProStr=..ResovleFilterData(expStr)
				continue:('$d(^DHCWL.ComplexRpt.StatItemI("StCode",$P(dimProStr,".",1))))
				d dimArray.SetAt(dimProStr,indNum)
				s indNum=indNum+1
			}
			
		}else{
			continue:((dataStr '[ ProS)||(dataStr '[ ProE))
			s dimProStr=..ResovleFilterData(dataStr)
			continue:('$d(^DHCWL.ComplexRpt.StatItemI("StCode",$P(dimProStr,".",1))))
			d dimArray.SetAt(dimProStr,indNum)
			s indNum=indNum+1
		}
	}
	q dimArray
}

/// Creator：      yw
/// CreatDate：    2016-01-22
/// Description:： 根据统计项代码得到统计项id
/// Table：       DHCWL.MKPI.MKPIData
/// Input：       monId:区间id,kpiId:指标id
/// Output：      
/// Return：      成功返回id,否则返回0
/// Others：
/// w ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetStatItemID("PatLoc")
ClassMethod GetStatItemID(stCode) As %String
{
	n (stCode)
	q:(stCode="")||(stCode=0) ""
	s stCode=$ZCVT(stCode,"U")
	s statItemId=""
	s statItemId=$O(^DHCWL.ComplexRpt.StatItemI("StCode"," "_stCode,""))
	i statItemId="" s statItemId=$O(^DHCWL.ComplexRpt.StatItemI("StCode",stCode,""))
	q statItemId
}

/// Creator by wk
/// Date 2016-01-03
/// w ##class(DHCWL.ComplexRptWLDetData.RptDetService).handleFilterParam("[{PatLoc} = $a] && [{TARI.TARIName} = $b]","$a=1,$b=2")
/// [{PatLoc} = $a] && [{TARI.TARIName} = $b]
ClassMethod handleFilterParam(filterRule, dynParams)
{
	n (filterRule,dynParams)
	q:filterRule="" ""
	q:dynParams="" filterRule
	s dynParamLen=$l(dynParams,",")
	for i=1:1:dynParamLen{
	s dynParam=$p(dynParams,",",i)
	continue:dynParam=""
	s param=$p(dynParam,"=",1)
	continue:param=""
	s value=$p(dynParam,"=",2)
	s filterRule=##class(DHCWL.util.StringUtil).ReplaceStr(filterRule,param,value)
	}
	q filterRule
}

/// 根据维度代码和维度属性代码取维度ID
/// w ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetDimAttID("30","LOCDESC")
ClassMethod GetDimAttID(dimCode, dimAttCode) As %String
{
	n (dimCode,dimAttCode)
	s dimCode=$ZCVT(dimCode,"U")
	;s dimDr=$O(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",dimCode,""))
	s dimDr=dimCode
	s dimAttCode=$ZCVT(dimAttCode,"U")
	s dimAttDr=$O(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimAttCode,""))
	q $g(dimAttDr)
}

/// w ##class(DHCWL.ComplexRptWLDetData.RptDetService).StatItemSort()
ClassMethod StatItemSort(rptCol) As %String
{
	n (rptCol)
	//s rptCol="TotalPrice.TotalPrice,PatLoc.LocDesc,PatDoc.DocName,Quantity.Quantity"
	s contentStr=""
	s statItemStr=""
	
  	s colLen=$l(rptCol,",")
  	f serialNo=1:1:colLen d
  	.s paraSub=$p(rptCol,",",serialNo)
	.s kpiDim=$P(paraSub,".",1)
	.s dimAtt=$P(paraSub,".",2)
	.s statItemId=..GetStatItemID(kpiDim)
	.s stType=$lg(^DHCWL.ComplexRpt.StatItemD(statItemId),4)
	.i stType="C" d
	..i contentStr="" s contentStr=paraSub
	..e  s contentStr=contentStr_","_paraSub
	.e  d
	..i statItemStr="" s statItemStr=paraSub
	..e  s statItemStr=statItemStr_","_paraSub
	s sortStr=statItemStr_","_contentStr
	//w "str="_str,!
	q sortStr
}

/// w ##class(DHCWL.ComplexRptWLDetData.RptDetService).GetRptCond("测试报表5")
ClassMethod GetRptCond(rptName) As %String
{
	n (rptName)
	&sql(select RC_Mode, RC_ColExp,RC_FilterExp into:rcMode,:rcColExp,:rcFilterExp FROM DHCWL_ComplexRptDet.ColCfg where RC_RptDr->Rpt_Name=:rptName)
	q:SQLCODE'=0 ""
	s rtpCond=rcMode_"@"_rcColExp_"@"_rcFilterExp
	q rtpCond
}

/// 清除收入明细查询临时数据
///  d ##class(DHCWL.ComplexRptWLDetData.RptDetService).ClearSRMXTempData()
ClassMethod ClearSRMXTempData() As %String
{
	k ^TEMPDHCWLDet($j)
	k ^TEMPDHCWLSpec($j,"ItemWlRowid")
	q
}

}

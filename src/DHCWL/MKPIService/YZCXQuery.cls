/// 名称: DHCWL.MKPIService.YZCXQuery
/// 描述: 院长查询
/// 编写者：lxc
/// 编写日期:2012-07-30
/// 
Class DHCWL.MKPIService.YZCXQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

//挂号时间段-科室医生-出诊级别分析;flag 为排名报表调用标志  

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.YZCXQuery","GetRegStFx","2008-07-20","2008-08-20","","RegLocStOpNums","D","1")

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.YZCXQuery","GetRegStFx","2012-04","2012-04","","RegLocStOpNums","M")

ClassMethod GetRegStFxExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %String, kpiCodeStrZb As %String, type As %String, flag As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,flag)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
       
    k ^temp($j),^temp2($j),^temppm($j)
	
	s RowidCz="",RowidCzsub="",RowidCzsubDetsub=""
    f  s RowidCz=$o(^DHCWLSTG("GRP",RowidCz)) q:RowidCz=""  d
    .q:RowidCz'=1  //完全定义的出诊级别组
    .s fl1Cz="czxm"
    .s fl2Cz=$p(^DHCWLSTG("GRP",RowidCz),"^",1) ;定义
    .s fl3Cz="czdat"
    .s fl4Cz="SUB"
    
    .i fl4Cz="SUB" d 
    ..s fl4Cznm="出诊级别"
    ..s fl2Cznm=fl2Cz_"["_fl4Cznm_"]"
    ..f  s RowidCzsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)) q:RowidCzsub=""  d
    ...q:RowidCzsub=0
    ...s CZName=$P($G(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)),"^",1)
    ...f  s RowidCzsubDetsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)) q:RowidCzsubDetsub=""  d
    ....q:RowidCzsubDetsub=0
    ....s Czid=$p($g(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)),"^",4)
    ....s ^temp2($j,Czid)=RowidCzsub_"^"_CZName

	s monIdStr=""
 	i type="D"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	i type="M"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	i type="Q"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudQd(startDate,endDate)
	i type="Y"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudYear(startDate,endDate)
	
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
 	q:monIdStr="" 1
 	S kpiCodeStrZb="RegLocStOpNums"
	;q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	d{
	s sc=##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data,.hasMore)
	q:sc'=1
	q:'$d(data)
	
	d SplitMulitData1(dept,,.deptData)
	d SplitMulitData1(kpiIdStrZb,,.kpiIdStrZbData)

	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s dimIdLoc=$p(dimId,",",1)
	...s dimIdSt=$p(dimId,",",2)
	...s dimIdDoc=$p(dimId,",",3)
	...s dimIdRetype=$p(dimId,",",4)
	...s ^temppm($j,kpiId,dimIdLoc)=$g(^temppm($j,kpiId,dimIdLoc))+value
	...s ^temp($j,kpiId,diomIdLc,dimIdSt,dimIdDoc,dimIdRetype)=$g(^temp($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype))+value
	}while(hasMore)
	
	i flag="" d
    .s kpiId=0 f  s kpiId=$o(^temp($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^temp($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdSt=0 f  s dimIdSt=$o(^temp($j,kpiId,dimIdLoc,dimIdSt)) q:dimIdSt=""  d
    ....s dimIdDoc=0 f  s dimIdDoc=$o(^temp($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc)) q:dimIdDoc=""  d
    .....s dimIdRetype=0 f  s dimIdRetype=$o(^temp($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) q:dimIdRetype=""  d
    ......s outdata=$g(^temp($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) 
    ......d OutPutRow1
    
    i flag="1" d
	.s kpiId=0 f  s kpiId=$o(^temppm($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^temppm($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s outdata=$g(^temppm($j,kpiId,dimIdLoc)) 
    ...d OutPutRow1Pm
      
    k ^temp($j),^temp2($j),^temppm($j)
	
	Quit $$$OK
OutPutRow1
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimIdStna=$li($g(^DHCWL.MKPI.DayD(dimIdSt)),3)
	i $d(^CTPCP(dimIdDoc)) s DocNa=$$GetPatDoc^DHCWLCommon(dimIdDoc)
    e  s DocNa="Null"
	
	i ^temp2($j,dimIdRetype) s CzJbId=$p(^temp2($j,dimIdRetype),"^",1),CzJbNa=$p(^temp2($j,dimIdRetype),"^",2)
    e  s CzJbNa="Null"
	
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimIdLoc,dimDesc,dimIdSt,dimIdStna,dimIdDoc,DocNa,CzJbId,CzJbNa,outdata)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow1Pm
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimIdSt="",dimIdStna="",dimIdDoc="",DocNa=""

	s CzJbId="",CzJbNa=""
    e  s CzJbNa="Null"
	
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimIdLoc,dimDesc,dimIdSt,dimIdStna,dimIdDoc,DocNa,CzJbId,CzJbNa,outdata)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
SplitMulitData1(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetRegStFxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegStFxExecute ]
{
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

ClassMethod GetRegStFxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegStFxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRegStFx(startDate As %String, endDate As %String, dept As %String, kpiCodeStrZb As %String, type As %String, flag As %String) As %Query(ROWSPEC = "kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,dimIdSt:%String,dimIdStna:%String,dimIdDoc:%String,DocNa:%String,CzJbId:%String,CzJbNa:%String,outdata:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.YZCXQuery","GetKPIDataBJFX","2008","","GetLocFee,GetLocYLFee,GetLocYaoFee","O,E")

/// Creator：      lxc
/// CreatDate：    2012-08-07	
/// Description:： 按照年度和指标查找值,做年度月份的指标分析(病人科室收入分析用)
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetKPIDataBJFX(year As %String, dept As %String, kpiCodeStrZb As %String, type As %String) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimIdtype:%String,dimId:%String,dimDesc:%String,outdata:%Float") [ SqlProc ]
{
}

ClassMethod GetKPIDataBJFXExecute(ByRef qHandle As %Binary, year As %String, dept As %String, kpiCodeStrZb As %String, type As %String) As %Status
{
	n (qHandle,year,dept,kpiCodeStrZb,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^temp($j)
 	q:year="" $$$OK
	
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
	q:monIdStr="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)

	d SplitMulitData2(dept,,.deptData)
	d SplitMulitData2(type,,.typeData)
	d SplitMulitData2(kpiIdStrZb,,.kpiIdStrZbData)
	d{   ;edit by lhh溢出处理
     s sc=##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1
	q:'$d(data)
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...s dimIdtype=$p(dimId,",",2)
	
	
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	
	...//判断类型是否为所选类型
	...q:(type'="")&&(dimIdtype="") 
	...q:(type'="")&&('$d(typeData(dimIdtype)))

	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s ^temp($j,monId,kpiId,dimIdLoc,dimIdtype)=$g(^temp($j,monId,kpiId,dimIdLoc,dimIdtype))+value
	
	}while(hasMore)
   
	s monId=0 f  s monId=$o(^temp($j,monId)) q:monId=""  d
    .s kpiId=0 f  s kpiId=$o(^temp($j,monId,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^temp($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdtype=0 f  s dimIdtype=$o(^temp($j,monId,kpiId,dimIdLoc,dimIdtype)) q:dimIdtype=""  d
    ....s outdata=$g(^temp($j,monId,kpiId,dimIdLoc,dimIdtype)) 
	....d OutPutRow2
	k ^temp($j)
	Quit $$$OK
OutPutRow2
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdLoc,dimDesc,outdata)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
SplitMulitData2(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetKPIDataBJFXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIDataBJFXExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKPIDataBJFXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIDataBJFXExecute ]
{
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

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.YZCXQuery","GetGhrcDataTBHB","2008","","")

/// Creator：      lxc
/// CreatDate：    2012-08-07	
/// Description:：门诊人次做年度月份的同比环比分析
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetGhrcDataTBHB(year As %String, dept As %String, kpiCodeStrZb As %String) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,dimIdSt:%String,dimIdStna:%String,dimIdDoc:%String,DocNa:%String,CzJbId:%String,CzJbNa:%String,outdata:%Float") [ SqlProc ]
{
}

ClassMethod GetGhrcDataTBHBExecute(ByRef qHandle As %Binary, year As %String, dept As %String, kpiCodeStrZb As %String) As %Status
{
	n (qHandle,year,dept,kpiCodeStrZb)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK

 	k ^temp($j),^temp2($j)
	s RowidCz="",RowidCzsub="",RowidCzsubDetsub=""
    f  s RowidCz=$o(^DHCWLSTG("GRP",RowidCz)) q:RowidCz=""  d
    .q:RowidCz'=1   //完全定义的出诊级别组
    .s fl1Cz="czxm"
    .s fl2Cz=$p(^DHCWLSTG("GRP",RowidCz),"^",1) ;定义
    .s fl3Cz="czdat"
    .s fl4Cz="SUB"
    
    .i fl4Cz="SUB" d 
    ..s fl4Cznm="出诊级别"
    ..s fl2Cznm=fl2Cz_"["_fl4Cznm_"]"
    ..f  s RowidCzsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)) q:RowidCzsub=""  d
    ...q:RowidCzsub=0
    ...s CZName=$P($G(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)),"^",1)
    ...f  s RowidCzsubDetsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)) q:RowidCzsubDetsub=""  d
    ....q:RowidCzsubDetsub=0
    ....s Czid=$p($g(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)),"^",4)
    ....s ^temp2($j,Czid)=RowidCzsub_"^"_CZName
    
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
	q:monIdStr="" 1
 	S kpiCodeStrZb="RegLocStOpNums"
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)

	
	d SplitMulitData3(dept,,.deptData)
	d SplitMulitData3(kpiIdStrZb,,.kpiIdStrZbData)
	d{
	s sc=##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data,.hasMore)
	q:sc'=1 
	q:'$d(data) 
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s dimIdLoc=$p(dimId,",",1)
	...s dimIdSt=$p(dimId,",",2)
	...s dimIdDoc=$p(dimId,",",3)
	...s dimIdRetype=$p(dimId,",",4)
	...s ^temp($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)=$g(^temp($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype))+value
	}while(hasMore)
   
	s monId=0 f  s monId=$o(^temp($j,monId)) q:monId=""  d
    .s kpiId=0 f  s kpiId=$o(^temp($j,monId,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^temp($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdSt=0 f  s dimIdSt=$o(^temp($j,monId,kpiId,dimIdLoc,dimIdSt)) q:dimIdSt=""  d
    ....s dimIdDoc=0 f  s dimIdDoc=$o(^temp($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc)) q:dimIdDoc=""  d
    .....s dimIdRetype=0 f  s dimIdRetype=$o(^temp($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) q:dimIdRetype=""  d
    ......s outdata=$g(^temp($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) 
    ......d OutPutRow3
     
    k ^temp($j),^temp2($j)
	
	Quit $$$OK
OutPutRow3
    s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimIdStna=$li($g(^DHCWL.MKPI.DayD(dimIdSt)),3)
	i $d(^CTPCP(dimIdDoc)) s DocNa=$$GetPatDoc^DHCWLCommon(dimIdDoc)
    e  s DocNa="Null"
	
	i ^temp2($j,dimIdRetype) s CzJbId=$p(^temp2($j,dimIdRetype),"^",1),CzJbNa=$p(^temp2($j,dimIdRetype),"^",2)
    e  s CzJbNa="Null"
	
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdLoc,dimDesc,dimIdSt,dimIdStna,dimIdDoc,DocNa,CzJbId,CzJbNa,outdata)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData3(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetGhrcDataTBHBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGhrcDataTBHBExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetGhrcDataTBHBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGhrcDataTBHBExecute ]
{
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

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.YZCXQuery","GetKPIDataAgxSex","2008","","RegLocSexAge","O,E")

/// Creator：      lxc
/// CreatDate：    2012-08-07	
/// Description:： 按照年度和指标查找值,做年度月份的指标分析(性别、年龄段、类型分析用)
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetKPIDataAgxSex(year As %String, dept As %String, kpiCodeStrZb As %String, type As %String) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimIdtype:%String,dimId:%String,dimDesc:%String,dimIdAge:%Integer,dimIdAgeang:%String,dimIdadmrea:%String,outdata:%Float") [ SqlProc ]
{
}

ClassMethod GetKPIDataAgxSexExecute(ByRef qHandle As %Binary, year As %String, dept As %String, kpiCodeStrZb As %String, type As %String) As %Status
{
	n (qHandle,year,dept,kpiCodeStrZb,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^temp($j)
 	q:year="" $$$OK
	
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
	q:monIdStr="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	d SplitMulitData4(dept,,.deptData)
	d SplitMulitData4(type,,.typeData)
	d SplitMulitData4(kpiIdStrZb,,.kpiIdStrZbData)
    d{
	s sc=##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 
	q:'$d(data) 
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...s dimIdtype=$p(dimId,",",2)
	...s dimIdAge=$p(dimId,",",3)
	...s dimIdadmrea=$p(dimId,",",4)
	
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	
	...//判断类型是否为所选类型
	...q:(type'="")&&(dimIdtype="") 
	...q:(type'="")&&('$d(typeData(dimIdtype)))

	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s ^temp($j,monId,kpiId,dimIdLoc,dimIdtype,dimIdAge,dimIdadmrea)=$g(^temp($j,monId,kpiId,dimIdLoc,dimIdtype,dimIdAge,dimIdadmrea))+value
	
	
    }while(hasMore)
	
	s monId=0 f  s monId=$o(^temp($j,monId)) q:monId=""  d
    .s kpiId=0 f  s kpiId=$o(^temp($j,monId,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^temp($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdtype=0 f  s dimIdtype=$o(^temp($j,monId,kpiId,dimIdLoc,dimIdtype)) q:dimIdtype=""  d
    ....s dimIdAge=0 f  s dimIdAge=$o(^temp($j,monId,kpiId,dimIdLoc,dimIdtype,dimIdAge)) q:dimIdAge=""  d
    .....s dimIdadmrea=0 f  s dimIdadmrea=$o(^temp($j,monId,kpiId,dimIdLoc,dimIdtype,dimIdAge,dimIdadmrea)) q:dimIdadmrea=""  d
    ......s outdata=$g(^temp($j,monId,kpiId,dimIdLoc,dimIdtype,dimIdAge,dimIdadmrea)) 
	......d OutPutRow4
	k ^temp($j)
	Quit $$$OK
OutPutRow4
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimIdAgeang=$li($g(^DHCWL.MKPI.DayD(dimIdAge)),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdLoc,dimDesc,dimIdAge,dimIdAgeang,dimIdadmrea,outdata)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
SplitMulitData4(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetKPIDataAgxSexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIDataAgxSexExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKPIDataAgxSexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIDataAgxSexExecute ]
{
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

}

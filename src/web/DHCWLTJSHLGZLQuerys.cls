Class web.DHCWLTJSHLGZLQuerys Extends %RegisteredObject
{

/// Creator：		CHENYI
/// CreatDate：	2019-08-09
/// Description：	护士补录医嘱费用
/// Table：			pa_adm
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSHLGZLQuerys","QueryNurseFee","2023-03-01","2023-03-23","","","")
Query QueryNurseFee(startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", admTypeCode As %Text = "") As %Query(ROWSPEC = "resDepDesc:%String,resDocDesc:%String,itmMastDesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod QueryNurseFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", admTypeCode As %Text = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k resDepArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(resDepId,",",.resDepArr) 
	k admTypeCodeArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(admTypeCode,",",.admTypeCodeArr) 
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
	.s wlId=0
   .f  s wlId=$o(^DHCWorkLoad(0,"ORDDATE",date,wlId)) q:wlId=""  d
   ..s admType=$p(^DHCWorkLoad(wlId),"^",4)
   ..q:('$d(admTypeCodeArr(admType)))&&($g(admTypeCode)'="")
   ..s resDocDr=$p(^DHCWorkLoad(wlId),"^",19)	//开单医生
   ..q:+resDocDr=0
   ..s carPrvTpDR=$p(^CTPCP(resDocDr,1),"^",4)
   ..s carPrvTpDesc=$p(^CT("CPT",carPrvTpDR),"^",2)
   ..q:(carPrvTpDesc'["护士")&&(carPrvTpDesc'["护师")   //只统计护士补录的医嘱费用
   ..s resDepDr=$p(^DHCWorkLoad(wlId),"^",23)	//开单科室
   ..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(resDepDr)
   ..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
   ..q:('$d(resDepArr(resDepDr)))&&($g(resDepId)'="")
   ..s arcitmDr=$p(^DHCWorkLoad(wlId),"^",2)		//医嘱项
   ..s fee=$p(^DHCWorkLoad(wlId),"^",16)	
   ..s ^||TEMPDHCWL($j,"data",resDepDr,resDocDr,arcitmDr,"fee")=$g(^||TEMPDHCWL($j,"data",resDepDr,resDocDr,arcitmDr,"fee"))+fee
    
   //output
   s resDepDr=""
   f  s resDepDr=$o(^||TEMPDHCWL($j,"data",resDepDr)) q:resDepDr=""  d
   .s resDepDesc=$p(^CTLOC(resDepDr),"^",2)
   .s:resDepDesc["-" resDepDesc=$p(recDepDesc,"-",2)  //开单科室
   .s resDocDr="" f  s resDocDr=$o(^||TEMPDHCWL($j,"data",resDepDr,resDocDr)) q:resDocDr=""  d
   ..s resDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(resDocDr)  //开单医生（补录护士）
   ..s itmMastDR="" f  s itmMastDR=$o(^||TEMPDHCWL($j,"data",resDepDr,resDocDr,itmMastDR)) q:itmMastDR=""  d
   ...s itmMastDesc=$$GetARCIMName^DHCWLBuildDimDataARCIM(itmMastDR)
   ...s fee=$g(^||TEMPDHCWL($j,"data",resDepDr,resDocDr,itmMastDR,"fee"))
   ...d OutRow
   
   k ^||TEMPDHCWL($j)
 	Quit $$$OK
 	
OutRow
	s Data=$lb(resDepDesc,resDocDesc,itmMastDesc,fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryNurseFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNurseFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryNurseFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNurseFeeExecute ]
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

/// Creator：		CHENYI
/// CreatDate：	2019-08-09
/// Description：	护士工作量（只统计代码维护中的内容）
/// Table：			pa_adm
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSHLGZLQuerys","QueryExeOrderInfo","2019-09-01","2019-09-10","","","","HSGZL")
Query QueryExeOrderInfo(startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", recDepId As %Text = "", bsCode As %String = "") As %Query(ROWSPEC = "recDepDesc:%String,nurseDesc:%String,itmMastBSDesc:%String,num:%Float") [ SqlProc ]
{
}

ClassMethod QueryExeOrderInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", recDepId As %Text = "", bsCode As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	k ^||TEMPDHCWL($j)
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k resDepArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(resDepId,",",.resDepArr) 
	k recDepArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(recDepId,",",.recDepArr) 
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
    .s time=0 f  s time=$o(^OEORDi(0,"DateExec",date,time)) q:time=""  d
    ..s ordDr=0 f  s ordDr=$o(^OEORDi(0,"DateExec",date,time,ordDr)) q:ordDr=""  d
    ...s adm=$p(^OEORD(ordDr),"^",1)
    ...q:$p(^PAADM(adm),"^",2)'="I"  //只统计住院患者
    ...s ordSubDr=0 f  s ordSubDr=$o(^OEORDi(0,"DateExec",date,time,ordDr,ordSubDr)) q:ordSubDr=""  d
    ....s itmMastDR=$p(^OEORD(ordDr,"I",ordSubDr,1),"^",2)
    ....s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(itmMastDR,bsCode,"")
    ....q:($p(bsret,"^",1)="")||($ZCVT($p(bsret,"^",1),"U")="NULL")
    ....s recDep=$P($G(^OEORD(ordDr,"I",ordSubDr,3)),"^",6)	;接收科室
    ....q:recDep=""    //执行科室为空?
    ....q:('$d(recDepArr(recDep)))&&($g(recDepId)'="")
    ....s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(recDep)
    ....q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	....;s resDep=$P($G(^OEORD(ordDr,"I",ordSubDr,1)),"^",3)	;下医嘱科室   OEORI_OrdDept_DR
 	....s resDep=$P($G(^OEORD(ordDr,"I",ordSubDr,7)),"^",2)	;下医嘱科室   OEORI_UserDepartment_DR
 	....i resDep="" s resDep="999999"
 	....q:('$d(resDepArr(resDep)))&&($g(resDepId)'="")
 	....;s resDoc=$P($G(^OEORD(ord,"I",ordSub,1)),"^",11)   //20150803   OEORI_Doctor_DR
 	....;s resUser=$P($G(^OEORD(ord,"I",ordSub,7)),"^",1)
 	....;下医嘱医生,根据user去获取下医嘱医生,长期医嘱或者非医护录入,可能导致为空
 	....;i resUser'="" s resDoc=$p($g(^SSU("SSUSR",+resUser)),"^",14)	
 	....;e  s resDoc=""
 	....
    ....s ordExeDr=0 f  s ordExeDr=$o(^OEORDi(0,"DateExec",date,time,ordDr,ordSubDr,ordExeDr)) q:ordExeDr=""  d
    .....s statu=$p(^OEORD(ordDr,"I",ordSubDr,"X",ordExeDr),"^",16)
    .....q:statu=""
    .....s statuDesc=$p(^OEC("STAT",statu),"^",2)   //SELECT * FROM OEC_Order_AdminStatus
    .....q:statuDesc'["执行"
    .....s nurseDr=$p(^OEORD(ordDr,"I",ordSubDr,"X",ordExeDr),"^",15)
    .....;q:nurseDr=""  ;统计护士工作量，没有护士的过滤
    .....i nurseDr="" s nurseDr="999999"
    .....s ^||TEMPDHCWL($j,"data",recDep,nurseDr,itmMastDR)=$g(^||TEMPDHCWL($j,"data",recDep,nurseDr,itmMastDR))+1
    
    //output
    s recDep=""
    f  s recDep=$o(^||TEMPDHCWL($j,"data",recDep)) q:recDep=""  d
    .s recDepDesc=$p(^CTLOC(recDep),"^",2)
    .s:recDepDesc["-" recDepDesc=$p(recDepDesc,"-",2)
    .s nurseDr="" f  s nurseDr=$o(^||TEMPDHCWL($j,"data",recDep,nurseDr)) q:nurseDr=""  d
    ..i nurseDr'="999999" s nurseDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(nurseDr)
    ..e  s nurseDesc="无执行人"
    ..s itmMastDR="" f  s itmMastDR=$o(^||TEMPDHCWL($j,"data",recDep,nurseDr,itmMastDR)) q:itmMastDR=""  d
    ...s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(itmMastDR,bsCode,"")
    ...s itmMastBSDesc=$p(bsret,"^",1)
    ...s num=$g(^||TEMPDHCWL($j,"data",recDep,nurseDr,itmMastDR))
    ...d OutRow
    
    k ^||TEMPDHCWL($j)
 	Quit $$$OK
 	
OutRow
	s Data=$lb(recDepDesc,nurseDesc,itmMastBSDesc,num)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryExeOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExeOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryExeOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExeOrderInfoExecute ]
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

}

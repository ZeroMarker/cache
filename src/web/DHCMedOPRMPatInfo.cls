Import SQLUser

Class web.DHCMedOPRMPatInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 9;

ClassMethod PatInfoQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatInfoQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PatInfoQueryExecute(ByRef qHandle As %Binary, iDate As %String, xCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:iDate="" $$$OK
	q:xCode="" $$$OK
	
	s rowidList=##class(web.DHCMedOPRMCommonFunc).GetXAdmList(iDate, xCode) //获取paadmRowid列表字符串
	;w !,"xCode="_xCode_";rowidList="_rowidList
	f i=1:1:$l(rowidList,"^")  d
	.s paadmRowid=$p(rowidList,"^",i)
	.q:paadmRowid=""
	.;w !,"paAdmDr="_paAdmDr
    .q:'$d(^PAADM(+paadmRowid))
    .s admDoc="",name="",sex="",age="",regNo="",department="",admDate="",RegfeeDoc=""
    .s tmp=$g(^PAADM(+paadmRowid))
    .s deptCode=$p(tmp,"^",4)						//部门代码
    .s admDocCodeDR=$p(tmp,"^",9) 					//就诊医师Dr
    .s admDate=$zd($p(tmp,"^",6),3) 				//就诊日期
    .s papmiDr=$p(tmp,"^",1) 						//指向PA_Patmas表Dr
    .q:'$d(^PAPER(+papmiDr)) 
    .s paperTemp=$g(^PAPER(+papmiDr,"ALL"))
    .s admDoc=$p($g(^CTPCP(admDocCodeDR,1)),"^",2) //就诊医生
    .s name=$p(paperTemp,"^",1) 					//姓名
    .s sexDr=$p(paperTemp,"^",7) 					//性别DR
    .s sex=$p($g(^CT("SEX",sexDr)),"^",2) 			//性别
    .s dob=$p(paperTemp,"^",6) 						//出生日期
    .s age=##class(web.DHCMedOPRMCommonFunc).CalAge(dob,+$h) 						//年龄
    .s regNo=$p($g(^PAPER(+papmiDr,"PAT",1)),"^",1) //就诊号
    .s department=$p($g(^CTLOC(deptCode)),"^",2) 	//部门名称
    .s tmpPaadm=" "_paadmRowid							//下面为取号别代码
    .
    .i $d(^User.DHCRegistrationFeeI("ADM",tmpPaadm)) d
	..s RegRowid=$o(^User.DHCRegistrationFeeI("ADM",tmpPaadm,0))
	..q:RegRowid=""
	..s tmp=$g(^User.DHCRegistrationFeeD(RegRowid))
	..q:tmp=""
	..s RegfeeDocId=$list(tmp,14)
	..s:RegfeeDocId'="" RegfeeDoc=$p($g(^CTPCP(+RegfeeDocId,1)),"^",2)
	..s RegTimeRangeId=$list(tmp,21)
	..s:RegTimeRangeId'="" RegTimeRange=$p($g(^DHCTimeRange(+RegTimeRangeId)),"^",2)
	..s RegfeeDocFinal=RegfeeDoc_" "_RegTimeRange	//号别，RegfeeDoc与RegTimeRange的拼接
    .;w !,"dob="_dob_";sexDr="_sexDr_";admDocCodeDR="_admDocCodeDR_";admDoc="_admDoc
	.s Data=$lb("")
	.Set $li(Data,1)=admDoc           
	.Set $li(Data,2)=name  
	.Set $li(Data,3)=sex  
	.Set $li(Data,4)=age    
	.Set $li(Data,5)=regNo     
	.Set $li(Data,6)=department
	.Set $li(Data,7)=admDate
	.Set $li(Data,8)=RegfeeDocFinal
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

ClassMethod PatInfoQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatInfoQueryExecute ]
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

/*
/查询门诊业务中病人信息Query
*/
Query PatInfoQuery(iDate As %String, xCode As %String) As %Query(ROWSPEC = "admDoc:%String,name:%String,sex:%String,age:%String,regNo:%String,department:%String,admDate:%String,RegfeeDoc:%String")
{
}

ClassMethod XiQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = XiQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod XiQueryExecute(ByRef qHandle As %Binary, startCode As %String, endCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s temp=##class(web.DHCMedOPRMCommonFunc).GetXiString(startCode,endCode)	
	s len=$l(temp,$c(1))
	f i=1:1:len  d
	.s tempData(i)=$p(temp,$c(1),i)
	.s xCode(i)=$p(tempData(i),"^",1)
	.s xName(i)=$p(tempData(i),"^",2)
	.s Data=$lb("")
	.Set $li(Data,1)=xCode(i)           
	.Set $li(Data,2)=xName(i)
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

ClassMethod XiQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = XiQueryExecute ]
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

/*
/查询门诊业务字典（DHC_MedAdmStatus）中X类代码、描述的Query
*/
Query XiQuery(startCode As %String, endCode As %String) As %Query(ROWSPEC = "Xi:%String,XName:%String")
{
}

ClassMethod CtLocQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CtLocQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CtLocQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CtLocQueryExecute ]
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

ClassMethod CtLocQueryExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:type="" $$$OK
	s rowid=0
	s rowidStr=""
	
	f  s rowid=$o(^CTLOC(0,"LocType",type,rowid)) q:rowid=""  d
	.s rowidStr=rowidStr_rowid_"^"
	s rowidStr=$e(rowidStr,1,$l(rowidStr)-1)
	
	s len=$l(rowidStr,"^")
	f i=1:1:len d
	.s rowidArr(i)=$p(rowidStr,"^",i)
	.s temp=$g(^CTLOC(rowidArr(i)))
	.;s desc(i)=$p(temp,"^",2)					//直接得到的科室描述为“CKDMZ-产科东门诊”样式
	.s desc(i)=$p($p(temp,"^",2),"-",2) 		//去除"-'前部分
	.s Data=$lb("")
	.Set $li(Data,1)=desc(i)         
	.Set $li(Data,2)=rowidArr(i)
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

/*
/查询科室类型Query
/d ##class(%Library.ResultSet).RunQuery("web.DHCMedOPRMPatInfo","CtLocQuery","E")
*/
Query CtLocQuery(type As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

}

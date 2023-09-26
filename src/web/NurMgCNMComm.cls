Class web.NurMgCNMComm Extends %RegisteredObject
{

/// Creator: LCY
/// Createdate: 20190826
/// Description: 获取所有的科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output: 所有科室年度工作计划
/// Return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindDPPlan","N","")
Query FindDPPlan(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDPPlanExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s status=$P(parr,"^",3)
	s year = $p(parr,"^",4)
	s subyear = $p(parr,"^",5)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s admdate="" f  s admdate=$O(^DHCNMG.Handbook.MgHNHDPWorkI("PlanDate",admdate)) q:admdate=""  d
	.q:(date'="")&&(admdate'=date)
	.s id="" f  s id=$O(^DHCNMG.Handbook.MgHNHDPWorkI("PlanDate",admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)
	..q:(ward'="")&&(obj.HNHPlanWardDR'="")&&(obj.HNHPlanWardDR.%Id()'=ward)
	..q:(isAll=0)&&(('$IsObject(obj.HNHPlanWardDR))||('$d(tmpWard(obj.HNHPlanWardDR.%Id()))))
	..q:(status'="")&&(obj.HNHPlanStatus'=status)
	..q:(year'="")&&($p($zd(obj.HNHCreateDate,3),"-",1)'=year)
	..q:(subyear'="")&&($p($zd(obj.HNHSubmitDate,3),"-",1)'=subyear)
	..s ret=..GetDPPlan(id)	
	..d OutNurTrain
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurTrain
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDPPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDPPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTrainExecute ]
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

/// Creator: LCY
/// Createdate: 20190826
/// Description: 保存护士长科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output: 保存成功的RowID
/// Return:
/// other: w ##class(web.NurMgCNMComm).SaveDPPlan("HNHPlayDesDR|1^HNHPlanStatus|N^HNHPlanWardDR|1^HNHPlanTitle|2019血液科年度计划^HNHCreateDate|2019-08-26^HNHWorkPlan|123")
ClassMethod SaveDPPlan(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))="" d
	.s obj=##class(DHCNMG.Handbook.MgHNHDPWork).%New()
	.i $g(tmp("HNHPlayDesDR"))'="" d
	..s crtobj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("HNHPlayDesDR"))
	..i $IsObject(crtobj) s obj.HNHPlayDesDR=crtobj
	.e  s obj.HNHPlayDesDR=""
	e  d
	.s obj=##class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(tmp("rw"))
	s obj.HNHPlanStatus=$g(tmp("HNHPlanStatus"))
	i $g(tmp("HNHPlanWardDR"))'="" d
	.s obj.HNHPlanWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("HNHPlanWardDR"))
	e  s obj.HNHPlanWardDR=""
	s obj.HNHPlanTitle=$g(tmp("HNHPlanTitle"))
	s obj.HNHWorkPlan=$g(tmp("HNHWorkPlan"))
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q obj.%Id()
}

/// Creator: LCY
/// Createdate: 20190826
/// Description: 删除科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output: 0：删除失败；1：删除成功
/// Return:
/// other: w ##class(web.NurMgCNMComm).DeleteDPPlan(1)
ClassMethod DeleteDPPlan(id As %String) As %String
{
	q:id="" 0
	s sc=##Class(DHCNMG.Handbook.MgHNHDPWork).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190826
/// Description: 获取科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output:根据RowID返回一条科室年度工作计划
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetDPPlan(2)
ClassMethod GetDPPlan(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)
	s ret="rw|"_id
	q:'$IsObject(obj) ""	
	//病区
	i obj.HNHPlanWardDR'="" d
	.s ret=ret_"^HNHPlanWardDR|"_obj.HNHPlanWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.HNHPlanWardDR.WardDesc	
	//主题
	s ret=ret_"^HNHPlanTitle|"_obj.HNHPlanTitle		
	//工作计划
	s ret=ret_"^HNHWorkPlan|"_obj.HNHWorkPlan	
	//状态
	s ret=ret_"^HNHPlanStatus|"_obj.HNHPlanStatus
	s ret=ret_"^StatusDesc|"_$case(obj.HNHPlanStatus,"N":"未提交","Y":"已提交","S":"审核通过","B":"驳回",:"")	
	//提交时间
	i obj.HNHSubmitDate'="" s ret=ret_"^HNHSubmitDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHSubmitDate)
	i obj.HNHSubmitTime'="" s ret=ret_"^HNHSubmitTime|"_$zt(obj.HNHSubmitTime,2) 	
	//创建者
	i obj.HNHPlayDesDR'="" d
	.s ret=ret_"^HNHPlayDesDR|"_obj.HNHPlayDesDR.%Id()
	.s ret=ret_"^CrtUserName|"_obj.HNHPlayDesDR.PerName
	e  s ret=ret_"^HNHPlayDesDR|0^CrtUserName|超级管理员"	
	//审核人
	//审核通过
	i obj.HNHPlanStatus="S" d	
	.i obj.HNHRevDR'="" d
	..s ret=ret_"^HNHRevDR|"_obj.HNHRevDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHRevDR.PerName
	.e  s ret=ret_"^HNHRevDR|0^HNHRevName|超级管理员"
	//驳回
	i obj.HNHPlanStatus="B" d	
	.i obj.HNHOperDR'="" d
	..s ret=ret_"^HNHOperDR|"_obj.HNHOperDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHOperDR.PerName
	.e  s ret=ret_"^HNHOperDR|0^HNHRevName|超级管理员"	
	//创建时间
	i obj.HNHCreateDate'="" s ret=ret_"^HNHCreateDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHCreateDate)
	i obj.HNHCreateTime'="" s ret=ret_"^HNHCreateTime|"_$zt(obj.HNHCreateTime,1)	
	//审核时间
	//审核通过
	i obj.HNHPlanStatus="S" d
	.i obj.HNHRevDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRevDate)
	.i obj.HNHRevTime'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHCreateTime,1)	
	//驳回
	i obj.HNHPlanStatus="B" d
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRejDate)
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHRejTime,1)	
	//驳回原因
	s ret=ret_"^HNHRejectation|"_obj.HNHRejectation		
	q ret
}

/// Creator: LCY
/// Createdate: 20190827
/// Description: 获取科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output:根据RowID返回一条科室年度工作计划内容
/// Return:
/// other:
ClassMethod GetDPWorkPlan(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)	
	q obj.HNHWorkPlan
}

/// Creator: LCY
/// Createdate: 20190826
/// Description: 提交科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output:1：提交成功；0：提交失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).SubDPPlan(2,"Y")
ClassMethod SubDPPlan(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)
	s obj.HNHPlanStatus=status
	i status="Y" d
	.s obj.HNHSubmitDate=+$h
	.s obj.HNHSubmitTime=$P($h,",",2)
	e  d
	.s obj.HNHSubmitDate=""
	.s obj.HNHSubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190828
/// Description: 撤销提交、审核操作科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output:1：撤销成功；0：撤销失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).CancleOper(14), nurseid As %String = ""
ClassMethod CanclePlan(id As %String) As %String
{
	q:id="" 0
	s obj = ##class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)
	i obj.HNHPlanStatus = "Y" d
	.s obj.HNHPlanStatus = "N"
	i obj.HNHPlanStatus = "S" d  s obj.HNHPlanStatus = "Y"
	s sc = obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190827
/// Description: 审核通过科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output:1：通过成功；0：通过失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).RevDPPlan(2,"S",1)
ClassMethod RevDPPlan(id As %String, status As %String, revdr As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)
	s obj.HNHPlanStatus=status 
	i status="S" d 
	.s obj.HNHRevDR =##Class(DHCNMG.HR.MgPersons).%OpenId(revdr)
	.s obj.HNHRevIdea = idea
	.s obj.HNHRevDate=+$h
	.s obj.HNHRevTime=$P($h,",",2)
	e  d
	.s obj.HNHRevDate=""
	.s obj.HNHRevTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190827
/// Description: 审核驳回科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// input：
/// Output:1：驳回成功；0：驳回失败
/// Return: 
/// other: w ##class(web.NurMgCNMComm).TdownDPPlan(2,"B",1,"工作量太少")
ClassMethod TdownDPPlan(id As %String, status As %String, oper As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)
	s obj.HNHPlanStatus=status
	i status="B" d
	.s obj.HNHOperDR = ##class(DHCNMG.HR.MgPersons).%OpenId(oper)
	.s obj.HNHRejectation = idea
	.s obj.HNHRejDate=+$h
	.s obj.HNHRejTime=$P($h,",",2)
	e  d
	.s obj.HNHRejDate=""
	.s obj.HNHRejTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// w ##class(web.NurMgCNMComm).getValue("2")
ClassMethod getValuePlan(id)
{
	q:id="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.MgHNHDPWork).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.MgHNHDPWork","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.MgHNHDPWork","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1) 
    i tmp("HNHPlanWardDR")'=""  s tmp("HNHPlanWardDR")=obj.HNHPlanWardDR.WardDesc
    i tmp("HNHOperDR")="" s tmp("HNHOperName")="超级管理员"
    e  s tmp("HNHOperDR")=obj.HNHOperDR.%Id(),tmp("HNHOperName")=obj.HNHOperDR.PerName
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
	s ret=ret_"RowId|"_id
	q ret
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgAnnualSum","GetAll")
/// Creator: LCY
/// Createdate: 20190830
/// Description: 保存科室护理工作年终总结
/// Table: DHCNMG.HNH.MgHNHDPWorkSum
/// input：
/// Output: 保存成功的RowID
/// Return:
/// other: w ##class(web.NurMgCNMComm).SaveDPSum("HNHSumDesDR|1^HNHSumStatus|N^HNHSumWardDR|1^HNHSumTitle|2019血液科年度计划^HNHCreDate|2019-08-26^HNHWorkSum|123")
ClassMethod SaveDPSum(parr As %String) As %String
{
	s ^TMP("SaveDPSum")=parr
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))="" d
	.s obj=##class(DHCNMG.Handbook.MgHNHWorkSum).%New()
	.i $g(tmp("HNHSumDesDR"))'="" d
	..s crtobj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("HNHSumDesDR"))
	..i $IsObject(crtobj) s obj.HNHSumDesDR=crtobj
	.e  s obj.HNHSumDesDR=""
	e  d
	.s obj=##class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(tmp("rw"))
	s obj.HNHSumStatus=$g(tmp("HNHSumStatus"))
	i $g(tmp("HNHSumWardDR"))'="" d
	.s obj.HNHSumWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("HNHSumWardDR"))
	e  s obj.HNHSumWardDR=""
	i $g(tmp("HNHCreDate"))'="" s obj.HNHCreDate=$zdh(tmp("HNHCreDate"),3)
	e  s obj.HNHCreDate=""
	s obj.HNHSumTitle=$g(tmp("HNHSumTitle"))
	s obj.HNHWorkSum=$g(tmp("HNHWorkSum"))
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q obj.%Id()
}

/// Creator: LCY
/// Createdate: 20190831
/// Description: 删除科室护理工作年终总结
/// Table: DHCNMG.Handbook.MgHNHWorkSum
/// input：
/// Output: 0：删除失败；1：删除成功
/// Return:
/// other: w ##class(web.NurMgCNMComm).DeleteDPSum(1)
ClassMethod DeleteDPSum(id As %String) As %String
{
	q:id="" 0
	s sc=##Class(DHCNMG.Handbook.MgHNHWorkSum).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190831
/// Description: 获取科室护理工作年终总结
/// Table: DHCNMG.HNH.MgHNHDPWorkSum
/// input：
/// Output:根据RowID返回一条科室护理工作年终总结
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetDPSum(2)
ClassMethod GetDPSum(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)
	s ret="rw|"_id
	q:'$IsObject(obj) ""	
	//病区
	i obj.HNHSumWardDR'="" d
	.s ret=ret_"^HNHSumWardDR|"_obj.HNHSumWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.HNHSumWardDR.WardDesc	
	//主题
	s ret=ret_"^HNHSumTitle|"_obj.HNHSumTitle	
	//工作计划
	s ret=ret_"^HNHWorkSum|"_obj.HNHWorkSum	
	//状态
	s ret=ret_"^HNHSumStatus|"_obj.HNHSumStatus
	s ret=ret_"^StatusDesc|"_$case(obj.HNHSumStatus,"N":"未提交","Y":"已提交","S":"审核通过","B":"驳回",:"")	
	//提交时间
	i obj.HNHSubDate'="" s ret=ret_"^HNHSubDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHSubDate)
	i obj.HNHSubTime'="" s ret=ret_"^HNHSubTime|"_$zt(obj.HNHSubTime,2) 	
	//创建者
	i obj.HNHSumDesDR'="" d
	.s ret=ret_"^HNHSumDesDR"_obj.HNHSumDesDR.%Id()
	.s ret=ret_"^CrtUserName|"_obj.HNHSumDesDR.PerName
	e  s ret=ret_"^HNHSumDesDR|0^CrtUserName|超级管理员"	
	//审核人
	//审核通过
	i obj.HNHSumStatus="S" d	
	.i obj.HNHRevDR'="" d
	..s ret=ret_"^HNHRevDR|"_obj.HNHRevDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHRevDR.PerName
	.e  s ret=ret_"^HNHRevDR|0^HNHRevName|超级管理员"
	//驳回
	i obj.HNHSumStatus="B" d	
	.i obj.HNHOperDR'="" d
	..s ret=ret_"^HNHOperDR|"_obj.HNHOperDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHOperDR.PerName
	.e  s ret=ret_"^HNHOperDR|0^HNHRevName|超级管理员"	
	//创建时间
	i obj.HNHCreDate'="" s ret=ret_"^HNHCreDate|"_$p($zd(obj.HNHCreDate,3),"-",1) ;##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHCreDate)
	i obj.HNHCreTime'="" s ret=ret_"^HNHCreTime|"_$zt(obj.HNHCreTime,1)	
	//审核时间
	//审核通过
	i obj.HNHSumStatus="S" d
	.i obj.HNHRevDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRevDate)
	.i obj.HNHRevTime'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHRevTime,1)	
	//驳回
	i obj.HNHSumStatus="B" d
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRejDate)
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHRejTime,1)	
	//驳回原因
	s ret=ret_"^HNHRejation|"_obj.HNHRejation		
	q ret
}

/// Creator: LCY
/// Createdate: 20190831
/// Description: 获取科室护理工作年终总结
/// Table: DHCNMG.HNH.MgHNHDPWorkSum
/// input：
/// Output:根据RowID返回一条科室护理工作年终总结
/// Return:
/// w ##class(web.NurMgCNMComm).getSumValue("3")
ClassMethod getSumValue(id)
{
	q:id="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.MgHNHWorkSum","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.MgHNHWorkSum","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1) 
    i tmp("HNHSumWardDR")'=""  s tmp("HNHSumWardDR")=obj.HNHSumWardDR.WardDesc
    i tmp("HNHSumDesDR")="" s tmp("CrtUserName")="超级管理员"
    e  s tmp("HNHSumDesDR")=obj.HNHSumDesDR.%Id(),tmp("CrtUserName")=obj.HNHSumDesDR.PerName
    i obj.HNHSumStatus="S" d
    .i tmp("HNHRevDR")="" s tmp("HNHRevName")="超级管理员"
    .e  s tmp("HNHRevDR")=obj.HNHRevDR.%Id(),tmp("HNHRevName")=obj.HNHRevDR.PerName
    i obj.HNHSumStatus="B" d
    .i tmp("HNHOperDR")="" s tmp("HNHOperName")="超级管理员"
    .e  s tmp("HNHOperDR")=obj.HNHOperDR.%Id(),tmp("HNHOperName")=obj.HNHOperDR.PerName
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
	s ret=ret_"RowId|"_id
	q ret
}

/// Creator: LCY
/// Createdate: 20190831
/// Description: 获取科室护理年终总结
/// Table: DHCNMG.HNH.MgHNHDPWorkSum
/// input：
/// Output:根据RowID返回一条科室护理工作年终总结
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetWorkSum(1)
ClassMethod GetWorkSum(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)	
	q obj.HNHWorkSum
}

/// Creator: LCY
/// Createdate: 20190901
/// Description: 获取所有的科室护理年终总结
/// Table: DHCNMG.HNH.MgHNHDPWorkSum
/// input：
/// Output: 所有科室护理工作年终总结
/// Return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindDPSum","^^N^2019^","","0","0")
Query FindDPSum(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDPSumExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s status=$P(parr,"^",3)
	s year = $p(parr,"^",4)
	s subyear = $p(parr,"^",5)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s admdate="" f  s admdate=$O(^DHCNMG.Handbook.MgHNHWorkSumI("SumDate",admdate)) q:admdate=""  d
	.q:(date'="")&&(admdate'=date)
	.s id="" f  s id=$O(^DHCNMG.Handbook.MgHNHWorkSumI("SumDate",admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)
	..q:(ward'="")&&(obj.HNHSumWardDR'="")&&(obj.HNHSumWardDR.%Id()'=ward)
	..q:(isAll=0)&&(('$IsObject(obj.HNHSumWardDR))||('$d(tmpWard(obj.HNHSumWardDR.%Id()))))
	..q:(status'="")&&(obj.HNHSumStatus'=status)
	..q:(year'="")&&($p($zd(obj.HNHCreDate,3),"-",1)'=year)
	..q:(subyear'="")&&($p($zd(obj.HNHSubDate,3),"-",1)'=subyear)
	..q:(role["4")&&(obj.HNHSumStatus="N")
	..s ret=..GetDPSum(id)	
	..d OutNurTrain
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurTrain
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDPSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDPSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTrainExecute ]
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

/// Creator: LCY
/// Createdate: 20190901
/// Description: 提交科室护理工作年终总结
/// Table: DHCNMG.Handbook.MgHNHWorkSum
/// input：
/// Output:1：提交成功；0：提交失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).SubDPSum(2,"Y")
ClassMethod SubDPSum(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)
	s obj.HNHSumStatus=status
	i status="Y" d
	.s obj.HNHSubDate=+$h
	.s obj.HNHSubTime=$P($h,",",2)
	e  d
	.s obj.HNHSubDate=""
	.s obj.HNHSubTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190901
/// Description: 撤销提交、审核操作科室护理工作年终总结
/// Table: DHCNMG.Handbook.MgHNHWorkSum
/// input：
/// Output:1：撤销成功；0：撤销失败
/// Return:
/// other: w ##class(web.NurMgCNMComm)CancleSum(5) 
ClassMethod CancleSum(id As %String) As %String
{
	q:id="" 0
	s obj = ##class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)
	i obj.HNHSumStatus = "Y" d
	.s obj.HNHSumStatus = "N"
	i obj.HNHSumStatus = "S" d  s obj.HNHSumStatus = "Y"
	s sc = obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190901
/// Description: 审核通过科室护理工作年终总结
/// Table: DHCNMG.Handbook.MgHNHWorkSum
/// input：
/// Output:1：通过成功；0：通过失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).RevDPSum(2,"S",1)
ClassMethod RevDPSum(id As %String, status As %String, revdr As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)
	s obj.HNHSumStatus=status 
	i status="S" d 
	.s obj.HNHRevDR =##Class(DHCNMG.HR.MgPersons).%OpenId(revdr)
	.s obj.HNHRevIdea = idea
	.s obj.HNHRevDate=+$h
	.s obj.HNHRevTime=$P($h,",",2)
	e  d
	.s obj.HNHRevDate=""
	.s obj.HNHRevTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190901
/// Description: 审核驳回科室护理工作年终总结
/// Table: DHCNMG.Handbook.MgHNHWorkSum
/// input：
/// Output:1：驳回成功；0：驳回失败
/// Return: 
/// other: w ##class(web.NurMgCNMComm).TdownDPSum(2,"B",1,"工作量太少")
ClassMethod TdownDPSum(id As %String, status As %String, oper As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##class(DHCNMG.Handbook.MgHNHWorkSum).%OpenId(id)
	s obj.HNHSumStatus=status
	i status="B" d
	.s obj.HNHOperDR = ##class(DHCNMG.HR.MgPersons).%OpenId(oper)
	.s obj.HNHRejation = idea
	.s obj.HNHRejDate=+$h
	.s obj.HNHRejTime=$P($h,",",2)
	e  d
	.s obj.HNHRejDate=""
	.s obj.HNHRejTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgAnnualMemo","GetAll")
/// Creator: LCY
/// Createdate: 20190903
/// Description: 保存备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output: 保存成功的RowID
/// Return:
/// other: w ##class(web.NurMgCNMComm).SaveDPMemo("HNHMemoDesDR|1^HNHMemoStatus|N^HNHMemoWardDR|1^HNHMemoTitle|2019血液科年度计划^HNHCreDate|2019-08-26^HNHMemo|123")
ClassMethod SaveDPMemo(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))="" d
	.s obj=##class(DHCNMG.Handbook.MgHNHMemo).%New()
	.i $g(tmp("HNHMemoDesDR"))'="" d
	..s crtobj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("HNHMemoDesDR"))
	..i $IsObject(crtobj) s obj.HNHMemoDesDR=crtobj
	.e  s obj.HNHMemoDesDR=""
	e  d
	.s obj=##class(DHCNMG.Handbook.MgHNHMemo).%OpenId(tmp("rw"))
	s obj.HNHMemoStatus=$g(tmp("HNHMemoStatus"))
	i $g(tmp("HNHMemoWardDR"))'="" d
	.s obj.HNHMemoWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("HNHMemoWardDR"))
	e  s obj.HNHMemoWardDR=""
	s obj.HNHMemoTitle=$g(tmp("HNHMemoTitle"))
	s obj.HNHMemo=$g(tmp("HNHMemo"))
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q obj.%Id()
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 删除备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output: 0：删除失败；1：删除成功
/// Return:
/// other: w ##class(web.NurMgCNMComm).DeleteDPMemo(1)
ClassMethod DeleteDPMemo(id As %String) As %String
{
	q:id="" 0
	s sc=##Class(DHCNMG.Handbook.MgHNHMemo).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 获取备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output:根据RowID返回一条备忘录
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetDPMemo(2)
ClassMethod GetDPMemo(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)
	s ret="rw|"_id
	q:'$IsObject(obj) ""	
	//备忘录病区
	i obj.HNHMemoWardDR'="" d
	.s ret=ret_"^HNHMemoWardDR|"_obj.HNHMemoWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.HNHMemoWardDR.WardDesc	
	//备忘录主题
	s ret=ret_"^HNHMemoTitle|"_obj.HNHMemoTitle		
	//备忘录
	s ret=ret_"^HNHMemo|"_obj.HNHMemo	
	//状态
	s ret=ret_"^HNHMemoStatus|"_obj.HNHMemoStatus
	s ret=ret_"^StatusDesc|"_$case(obj.HNHMemoStatus,"N":"未提交","Y":"已提交","S":"审核通过","B":"驳回",:"")	
	//提交时间
	i obj.HNHSubDate'="" s ret=ret_"^HNHSubDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHSubDate)
	i obj.HNHSubTime'="" s ret=ret_"^HNHSubTime|"_$zt(obj.HNHSubTime,2) 	
	//创建者
	i obj.HNHMemoDesDR'="" d
	.s ret=ret_"^HNHMemoDesDR"_obj.HNHMemoDesDR.%Id()
	.s ret=ret_"^CrtUserName|"_obj.HNHMemoDesDR.PerName
	e  s ret=ret_"^HNHMemoDesDR|0^CrtUserName|超级管理员"	
	//审核人
	//审核通过
	i obj.HNHMemoStatus="S" d	
	.i obj.HNHRevDR'="" d
	..s ret=ret_"^HNHRevDR|"_obj.HNHRevDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHRevDR.PerName
	.e  s ret=ret_"^HNHRevDR|0^HNHRevName|超级管理员"
	//驳回
	i obj.HNHMemoStatus="B" d	
	.i obj.HNHOperDR'="" d
	..s ret=ret_"^HNHOperDR|"_obj.HNHOperDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHOperDR.PerName
	.e  s ret=ret_"^HNHOperDR|0^HNHRevName|超级管理员"	
	//创建时间
	i obj.HNHCreDate'="" s ret=ret_"^HNHCreDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHCreDate)
	i obj.HNHCreTime'="" s ret=ret_"^HNHCreTime|"_$zt(obj.HNHCreTime,1)	
	//审核时间
	//审核通过
	i obj.HNHMemoStatus="S" d
	.i obj.HNHRevDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRevDate)
	.i obj.HNHRevTime'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHRevTime,1)
	//驳回
	i obj.HNHMemoStatus="B" d
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRejDate)
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHRejTime,1)	
	//驳回原因
	s ret=ret_"^HNHRejation|"_obj.HNHRejation		
	q ret
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 获取备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output:根据RowID返回一条备忘录
/// Return:
/// w ##class(web.NurMgCNMComm).getMemoValue("3")
ClassMethod getMemoValue(id)
{
	q:id="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.MgHNHMemo","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.MgHNHMemo","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1) 
    i tmp("HNHMemoWardDR")'=""  s tmp("HNHMemoWardDR")=obj.HNHMemoWardDR.WardDesc
    i tmp("HNHMemoDesDR")="" s tmp("CrtUserName")="超级管理员"
    e  s tmp("HNHMemoDesDR")=obj.HNHMemoDesDR.%Id(),tmp("CrtUserName")=obj.HNHMemoDesDR.PerName
    i obj.HNHMemoStatus="S" d
    .i tmp("HNHRevDR")="" s tmp("HNHRevName")="超级管理员"
    .e  s tmp("HNHRevDR")=obj.HNHRevDR.%Id(),tmp("HNHRevName")=obj.HNHRevDR.PerName
    i obj.HNHMemoStatus="B" d
    .i tmp("HNHOperDR")="" s tmp("HNHOperName")="超级管理员"
    .e  s tmp("HNHOperDR")=obj.HNHOperDR.%Id(),tmp("HNHOperName")=obj.HNHOperDR.PerName
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
	s ret=ret_"RowId|"_id
	q ret
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 获取备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output:根据RowID返回一条备忘录
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetWorkMemo(1)
ClassMethod GetWorkMemo(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)	
	q obj.HNHMemo
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 获取所有的备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output: 所有备忘录
/// Return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindDPMemo","^^N^2019^","","0","0")
Query FindDPMemo(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDPMemoExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s status=$P(parr,"^",3)
	s year = $p(parr,"^",4)
	s subyear = $p(parr,"^",5)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s admdate="" f  s admdate=$O(^DHCNMG.Handbook.MgHNHMemoI("MemoDate",admdate)) q:admdate=""  d
	.q:(date'="")&&(admdate'=date)
	.s id="" f  s id=$O(^DHCNMG.Handbook.MgHNHMemoI("MemoDate",admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)
	..q:(ward'="")&&(obj.HNHMemoWardDR'="")&&(obj.HNHMemoWardDR.%Id()'=ward)
	..q:(isAll=0)&&(('$IsObject(obj.HNHMemoWardDR))||('$d(tmpWard(obj.HNHMemoWardDR.%Id()))))
	..q:(status'="")&&(obj.HNHMemoStatus'=status)
	..q:(year'="")&&($p($zd(obj.HNHCreDate,3),"-",1)'=year)
	..q:(subyear'="")&&($p($zd(obj.HNHSubDate,3),"-",1)'=subyear)
	..q:(role=4)&&(obj.HNHMemoStatus="N")
	..s ret=..GetDPMemo(id)	
	..d OutNurTrain
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurTrain
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDPMemoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDPMemoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTrainExecute ]
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

/// Creator: LCY
/// Createdate: 20190903
/// Description: 提交备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output:1：提交成功；0：提交失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).SubDPMemo(2,"Y")
ClassMethod SubDPMemo(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)
	s obj.HNHMemoStatus=status
	i status="Y" d
	.s obj.HNHSubDate=+$h
	.s obj.HNHSubTime=$P($h,",",2)
	e  d
	.s obj.HNHSubDate=""
	.s obj.HNHSubTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 撤销提交、审核操作
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output:1：撤销成功；0：撤销失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).CancleOper(14)
ClassMethod CancleMemo(id As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)
	i obj.HNHMemoStatus="Y" d
	.s obj.HNHMemoStatus="N"
    i obj.HNHMemoStatus="S" d  s obj.HNHMemoStatus="Y"
	s sc = obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 审核通过科室护理工作年终总结
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output:1：通过成功；0：通过失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).RevDPMemo(2,"S",1)
ClassMethod RevDPMemo(id As %String, status As %String, revdr As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)
	s obj.HNHMemoStatus=status	 
	i status="S" d 
	.s obj.HNHRevDR =##Class(DHCNMG.HR.MgPersons).%OpenId(revdr)
	.s obj.HNHRevIdea = idea
	.s obj.HNHRevDate=+$h
	.s obj.HNHRevTime=$P($h,",",2)
	e  d
	.s obj.HNHRevDate=""
	.s obj.HNHRevTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 审核驳回备忘录
/// Table: DHCNMG.Handbook.MgHNHMemo
/// input：
/// Output:1：驳回成功；0：驳回失败
/// Return: 
/// other: w ##class(web.NurMgCNMComm).TdownDPMemo(2,"B",1,"工作量太少")
ClassMethod TdownDPMemo(id As %String, status As %String, oper As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##class(DHCNMG.Handbook.MgHNHMemo).%OpenId(id)
	s obj.HNHMemoStatus=status
	i status="B" d
	.s obj.HNHOperDR = ##class(DHCNMG.HR.MgPersons).%OpenId(oper)
	.s obj.HNHRejation = idea
	.s obj.HNHRejDate=+$h
	.s obj.HNHRejTime=$P($h,",",2)
	e  d
	.s obj.HNHRejDate=""
	.s obj.HNHRejTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 2019-09-18
/// Description: 按照病区获取护士信息
/// Table: DHCNMG.HR.MgPersons
/// Input：
/// Output:
/// Return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindPerInOfWardList","^^^^","","206","1")
/// other: d ##class(%ResultSet).RunQuery("web.NurMgHNHPerWardList","FindPerInOfWardList","","","冯丹")
Query FindPerInOfWardList(parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerInOfWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	i stdate="" s stdate=+$h
	s:stdate["-" stdate=$zdt(stdate,3)
	s enddate=$P(parr,"^",3)
	i enddate="" s enddate=+$h
	s:enddate["-" enddate=$zdh(enddate,3)
	s type=$P(parr,"^",4)
	s duty=$P(parr,"^",5)
	s input=$zcvt(input,"U")
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgPersonsD(perdr)) q:perdr=""  d
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:perobj.PerTypeDR'="N"
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,enddate)
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.s:curward="" curward=perobj.PerDepDR
	.q:((ward'="")&&(ward'=curward))
	.s leavedate=perobj.PerStateDate //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.;s flag=..CheckNurWard(perdr,ward,stdate,enddate)
	.;q:(ward'="")&&(stdate'="")&&(enddate'="")&&(flag=0)
	.q:(type'="")&&(type'=perobj.PerTypeDR)
	.;q:((ward'="")&&(perobj.PerDepDR'=ward))
	.s flag=0
	.s dutyid="" f  s dutyid=$O(^DHCNMG.HR.MgPostDutyI("ssid",perdr,dutyid)) q:dutyid=""  d
	..s dutyobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(dutyid)
	..q:(dutyobj.PostStDate="")||(dutyobj.PostStDate>enddate)||((dutyobj.PostEndDate'="")&&(dutyobj.PostEndDate<stdate))
	..q:(dutyobj.PostDuty="")||((duty'="")&&(dutyobj.PostDuty'=duty))
	..s flag=1
	.q:(duty'="")&&(flag=0)
	.s perid=perobj.PerID
	.i perid="" s perid=perobj.PerNo
	.s pername=perobj.PerName
	.;q:(name'="")&&(pername'=name)
	.s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	.q:(input'="")&&(pername'[input)&&(perid'[input)&&(pershort'[input)
	.s perward=..GetCurrentWard(perdr,enddate)
	.s warddesc=""
	.i perward'="" d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(perward)
	..s:$IsObject(wardObj) warddesc=wardObj.WardDesc
	.s dutydesc=..GetDutyDesc(perdr,stdate,enddate)
	.s ret="perdr|"_perdr_"^PerID|"_perid_"^PerName|"_pername_"^perward|"_perward_"^WardDesc|"_$g(warddesc)_"^DutyDesc|"_dutydesc
	.d OutPersons
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerInOfWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerInOfWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerInOfWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerInOfWardListExecute ]
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

/// 获取职务
/// w ##class(web.NurMgHRComm).GetDutyDesc("1","2017-12-04","2017-12-10")
ClassMethod GetDutyDesc(perdr As %String, stdate As %String, enddate As %String) As %String
{
	q:(perdr="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	i stdate="" s stdate=+$h
	s:enddate["-" enddate=$zdh(enddate,3)
	i enddate="" s enddate=+$h
	s dutydesc="",maxdate=0
	s id="" f  s id=$O(^DHCNMG.HR.MgPostDutyI("ssid",perdr,id)) q:id=""  d
	.s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(id)
	.q:(obj.PostStDate="")||(obj.PostStDate>enddate)||((obj.PostEndDate'="")&&(obj.PostEndDate<stdate))
	.q:obj.PostDuty=""
	.q:maxdate>obj.PostStDate
	.s duty=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PostDuty)
	.q:'$IsObject(duty)
	.;s dutydesc=dutydesc_duty.SubDesc_","
	.s maxdate=obj.PostStDate
	.s dutydesc=duty.SubDesc
	;s dutydesc=$E(dutydesc,1,$L(dutydesc)-1)
	q dutydesc
}

/// 获取护士当前科室
ClassMethod GetCurrentWard(perdr As %String, date As %String) As %String
{
	q:(perdr="")!(date="") ""
	s:date["-" date=$zdh(date,3)
	q:($d(^DHCNMG.HR.MgPersonsD(perdr))=0) ""
	s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	s leavedate=perobj.PerStateDate //离职或退休日期
	q:((leavedate'="")&&(leavedate<=date)) ""
	s curward=perobj.PerDepDR
	s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("ssdr"," "_perdr,trsid)) q:trsid=""  d
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=..GetTransEndDate(trsid)
	.q:((trsstdate="")||(trsstdate>date)||((trsenddate'="")&&(trsenddate<=date)))
	.s curward=obj.PerDepart
	q:(perobj.PerTypeDR'="P") curward
	// 实习护士
	s plandr="" f  s plandr=$O(^DHCNMG.Intern.MgTransPlanD(plandr)) q:plandr=""  d
	.s planObj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(plandr)
	.q:(planObj.PlanStatus'="S") ;过滤未生效
	.s subdr="" f  s subdr=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanPerson",plandr,perdr,subdr)) q:subdr=""  d
	..s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subdr)
	..q:('$IsObject(subObj))||('$IsObject(subObj.PlanTimeDR))
	..s planstdate=subObj.PlanTimeDR.PlanStDate,planenddate=subObj.PlanTimeDR.PlanEndDate
	..q:((planstdate="")||(planstdate>date))
	..q:((planenddate="")||(planenddate<date))
	..s curward=subObj.PlanWardDR.%Id()
	q curward
}

/// Creator: xbl
/// Createdate: 20170902
/// Description: 获取当前调科记录结束日期
/// Table: DHCNMG.HR.MgTransDep
/// Input： 
/// Output: 
/// other: w ##class(web.NurMgHRComm).GetTransEndDate(17)
ClassMethod GetTransEndDate(trsid As %String) As %String
{
	q:trsid="" ""
	s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	q:obj.PerTranEndDate'="" obj.PerTranEndDate
	s perdr=obj.PerDr,stdate=obj.PerTranStDate
	q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0) ""
	s enddate=999999,flag=0
	s trsdr="" f  s trsdr=$O(^DHCNMG.HR.MgTransDepI("Current"," P"," "_perdr,trsdr)) q:trsdr=""  d
	.i flag=0 s flag=1
	.s trsobj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsdr)
	.s trsstdate=trsobj.PerTranStDate
	.i (trsstdate<enddate)&&(stdate<trsstdate) s enddate=trsstdate
	s trsappObj=##class(DHCNMG.HR.MgTransApp).%OpenId(obj.PerAppID)
	i ($IsObject(trsappObj))&&(obj.PerTransType="T")&&(enddate=999999) s enddate=trsappObj.TransEndDate
	q:flag=0 ""
	q:(flag=1)&&(enddate=999999) ""
	q enddate
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgAnnualMemo","GetAll")
/// Creator: LCY
/// Createdate: 20190927
/// Description: 保存人员信息动态
/// Table: DHCNMG.Handbook.MgHNHPerInfo
/// input：
/// Output: 保存成功的RowID
/// Return:
/// other: w ##class(web.NurMgCNMComm).SavePerInfo("rw|1^HNHInfoDesDR|1^HNHInfoStatus|I^HNHInfoWardDR|131^HNHPerDesDR|33^HNHTranDate|2019-08-09^HNHTranTime|12:00:00^HNHInfoNews|入职")
/// other: w ##class(web.NurMgHNHPerInfoComm).SavePerInfo("HNHInfoDesDR|1^HNHMemoStatus|N^HNHInfoWardDR|1^HNHMemoTitle|2019血液科年度计划^HNHCreDate|2019-08-26^HNHMemo|123")
ClassMethod SavePerInfo(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))="" d
	.s obj=##class(DHCNMG.Handbook.MgHNHPerInfo).%New()
	.i $g(tmp("HNHInfoDesDR"))'="" d
	..s crtobj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("HNHInfoDesDR"))
	..i $IsObject(crtobj) s obj.HNHInfoDesDR=crtobj
	.e  s obj.HNHInfoDesDR=""
	e  d
	.s obj=##class(DHCNMG.Handbook.MgHNHPerInfo).%OpenId(tmp("rw"))
	i $g(tmp("HNHInfoWardDR"))'="" d
	.s obj.HNHInfoWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("HNHInfoWardDR"))
	e  s obj.HNHInfoWardDR=""
	i $g(tmp("HNHPerDesDR"))'="" d
	.s obj.HNHPerDesDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("HNHPerDesDR"))
	e  s obj.HNHPerDesDR=""	
	s obj.HNHInfoStatus=$g(tmp("HNHInfoStatus"))
	i $g(tmp("HNHTranDate"))'="" d
	.s obj.HNHTranDate=$zdh(tmp("HNHTranDate"),3)
	e  s obj.HNHTranDate=""
	i $g(tmp("HNHTranTime"))'="" d
	.s obj.HNHTranTime=$zth(tmp("HNHTranTime"),3)
	e  s obj.HNHTranTime=""	
	s obj.HNHInfoNews=$g(tmp("HNHInfoNews"))
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q obj.%Id()
}

/// Creator: LCY
/// Createdate: 20190927
/// Description: 删除人员动态信息
/// Table: DHCNMG.Handbook.MgHNHPerInfo
/// input：
/// Output: 0：删除失败；1：删除成功
/// Return:
/// other: w ##class(web.NurMgCNMComm).DeleteInfo(1)
ClassMethod DeleteInfo(id As %String) As %String
{
	q:id="" 0
	s sc=##Class(DHCNMG.Handbook.MgHNHPerInfo).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 获取人员动态信息
/// Table: DHCNMG.Handbook.MgHNHPerInfo
/// input：
/// Output:根据RowID返回一条人员动态信息
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetInfo(2)
ClassMethod GetInfo(id As %String) As %String
{
	q:id=""
	s obj = ##class(DHCNMG.Handbook.MgHNHPerInfo).%OpenId(id)
	s ret="rw|"_id
	q:'$IsObject(obj) ""	
	// 创建者
	i obj.HNHInfoDesDR'="" d
	.s ret=ret_"^HNHInfoDesDR|"_obj.HNHInfoDesDR.%Id()
	.s ret=ret_"^CrtUserName|"_obj.HNHInfoDesDR.PerName
	e  s ret=ret_"^HNHInfoDesDR|0^CrtUserName|超级管理员"	
	// 动态人员
	i obj.HNHPerDesDR'="" d
	.s ret=ret_"^HNHPerDesDR|"_obj.HNHPerDesDR.%Id()
	.s ret=ret_"^UserName|"_obj.HNHPerDesDR.PerName	
	// 人员信息动态病区
	i obj.HNHInfoWardDR'="" d
	.s ret=ret_"^HNHInfoWardDR|"_obj.HNHInfoWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.HNHInfoWardDR.WardDesc	
	// 状态
	s ret=ret_"^HNHInfoStatus|"_obj.HNHInfoStatus
	s ret=ret_"^StatusDesc|"_$case(obj.HNHInfoStatus,"I":"调入","O":"调出",:"")	
	// 调入日期、时间
	i obj.HNHInfoStatus="I" d
	.i (obj.HNHTranDate'="")&&(obj.HNHTranTime'="") s ret=ret_"^HNHTrInDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHTranDate)_","_$zt(obj.HNHTranTime,1)
	e  d
	.i (obj.HNHTranDate'="")&&(obj.HNHTranTime'="") s ret=ret_"^HNHTrOutDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHTranDate)_","_$zt(obj.HNHTranTime,1)
	// 调出时间	
	//创建时间
	i obj.HNHCreDate'="" s ret=ret_"^HNHCreDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHCreDate)
	i obj.HNHCreTime'="" s ret=ret_"^HNHCreTime|"_$zt(obj.HNHCreTime,1)	
	// 日期
	i obj.HNHTranDate'="" s ret=ret_"^HNHTranDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHTranDate)
	i obj.HNHTranTime'="" s ret=ret_"^HNHTranTime|"_$zt(obj.HNHTranTime,1)	
	// 外出学习进修等其他情况
	s ret=ret_"^HNHInfoNews|"_obj.HNHInfoNews
	s ret = ret_"^"_..GetPer(obj.HNHPerDesDR.%Id())
	q ret
}

/// Creator: LCY
/// Createdate: 20190903
/// Description: 获取人员动态信息
/// Table: DHCNMG.Handbook.MgHNHPerInfo
/// input：
/// Output:根据RowID返回一条人员信息
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetPer(2)
ClassMethod GetPer(id As %String) As %String
{
	q:id=""
	s obj = ##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj)
	s ret="row|"_id
	q:'$IsObject(obj) ""	
	// 学历 PerCurrentAcade
	i obj.PerCurrentAcade'="" s ret  = ret_"^PerCurrentAcade|"_##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PerCurrentAcade).SubDesc
	e  s ret=ret_"^PerCurrentAcade|"
	// 职称 PerSJHireDuty
	//s ret = ret_"^PerSJHireDuty|"_obj.PerSJHireDuty
	s ret = ret_"^PerSJHireDuty|"
	// 参加工作时间 PerWorkDate
	s ret=ret_"^PerWorkDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)	
	// 联系电话 PerPhone
	s ret = ret_"^PerPhone|"_obj.PerPhone	
	// 身份证号 PerCardId
	s ret = ret_"^PerCardId|"_obj.PerCardId
	q ret
}

/// Creator: LCY
/// Createdate: 20190909
/// Description: 获取所有的人员动态信息
/// Table: DHCNMG.Handbook.MgHNHPerInfo
/// input：
/// Output: 所有人员动态信息
/// Return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindPerInfo","^I^2019","","0","0")
Query FindPerInfo(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerInfoExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s status=$P(parr,"^",3)
	s year = $p(parr,"^",4)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s admdate="" f  s admdate=$O(^DHCNMG.Handbook.MgHNHPerInfoI("tranDate",admdate)) q:admdate=""  d
	.;q:(date'="")&&(admdate'=date)
	.s id="" f  s id=$O(^DHCNMG.Handbook.MgHNHPerInfoI("tranDate",admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Handbook.MgHNHPerInfo).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(ward'="")&&(obj.HNHInfoWardDR'="")&&(obj.HNHInfoWardDR.%Id()'=ward)
	..q:(isAll=0)&&(('$IsObject(obj.HNHInfoWardDR))||('$d(tmpWard(obj.HNHInfoWardDR.%Id()))))
	..q:(status'="")&&(obj.HNHInfoStatus'=status)
	..q:(year'="")&&($p($zd(obj.HNHTranDate,3),"-",1)'=year)
	..s ret=..GetInfo(id)	
	..d OutNurTrain
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurTrain
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTrainExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","GetAll")
/// Creator: LCY
/// Createdate: 20190908
/// Description: 保存科研情况记录
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output: 保存成功的RowID
/// Return:
/// other: HNHBZ|k^HNHSciResDesDR|^HNHSciResStatus|N^HNHSciResWardDR|131^HNHSciProject|课题名称^HNHSciContent|sdgg353^HNHSciWardDR|^HNHSciProPer|作者^HNHSciProDeta|发表刊物名称^HNHSciDetails|gdheer3423^HNHSciComplet|saferh^HNHCreDate|2019-09-12^HNHProDate|2019-09-11^HNHSciPersonnal|36,38^HNHIdea|^HNHRejectation|^HNHRevDR|^HNHOperDR|^HNHRevName|^HNHrevIdea|^rw|7^HNHWorkSciRes|^HNHSciResName|超级管理员^
/// other: w ##class(web.NurMgSetComm).SaveCheckGroup("GroupDesc|测试^GroupMember|2,8,11,16^GroupRemark|测试用途^rw|^loginID|0^loginDep|^loginRoleCode|admin");
/// other: w ##class(web.NurMgHNHSciResComm).SaveDPSciRes("HNHSciResDesDR|1^HNHSciResStatus|N^HNHSciResWardDR|1^HNHSciProject|课题名称^HNHSciContent|临床药物研究^HNHSciProPer|承担者^HNHSciPersonnal|11,12,13^HNHSciProDeta|项目级别及编号^HNHSciDetails|一级，20000001^HNHSciComplet|已完成")
ClassMethod SaveDPSciRes(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))="" d
	.s obj=##class(DHCNMG.Handbook.MgHNHSciRes).%New()
	.i $g(tmp("HNHSciResDesDR"))'="" d
	..s crtobj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("HNHSciResDesDR"))
	..i $IsObject(crtobj) s obj.HNHSciResDesDR=crtobj
	.e  s obj.HNHSciResDesDR=""
	e  d
	.s obj=##class(DHCNMG.Handbook.MgHNHSciRes).%OpenId(tmp("rw"))
	s obj.HNHSciResStatus=$g(tmp("HNHSciResStatus"))
	i $g(tmp("HNHSciResWardDR"))'="" d
	.s obj.HNHSciResWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("HNHSciResWardDR"))
	e  s obj.HNHSciResWardDR=""
	s obj.HNHSciProject=$g(tmp("HNHSciProject"))
	s obj.HNHSciContent=$g(tmp("HNHSciContent"))
	s obj.HNHSciProPer=$g(tmp("HNHSciProPer"))	
	d obj.HNHSciPersonnal.Clear()
	f i=1:1:$L($g(tmp("HNHSciPersonnal")),",") d
	.s perdr=$P($g(tmp("HNHSciPersonnal")),",",i)
	.q:perdr=""
	.d obj.HNHSciPersonnal.Insert(perdr)
	s obj.HNHSciProDeta=$g(tmp("HNHSciProDeta"))
	s obj.HNHSciDetails=$g(tmp("HNHSciDetails"))
	s obj.HNHSciComplet=$g(tmp("HNHSciComplet"))
	i $g(tmp("HNHCreDate"))'="" d
	.s obj.HNHCreDate=$zdh(tmp("HNHCreDate"),3)
	e  s obj.HNHCreDate=""
	i $g(tmp("HNHProDate"))'="" d
	.s obj.HNHProDate=$zdh(tmp("HNHProDate"),3)
	e  s obj.HNHProDate=""
    s obj.HNHCreTime=$P($h,",",2)
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q obj.%Id()
}

/// Creator: LCY
/// Createdate: 20190909
/// Description: 删除科研情况记录
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output: 0：删除失败；1：删除成功
/// Return:
/// other: w ##class(web.NurMgCNMComm).DeleteSciRes(2)
ClassMethod DeleteSciRes(id As %String) As %String
{
	q:id="" 0
	s sc=##Class(DHCNMG.Handbook.MgHNHSciRes).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190909
/// Description: 获取科研情况记录
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output:根据RowID返回一条科研情况记录
/// Return:
/// other: w ##class(web.NurMgCNMComm).GetSciRes(2)
ClassMethod GetSciRes(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.MgHNHSciRes).%OpenId(id)
	s ret="rw|"_id
	q:'$IsObject(obj) ""	
	//科研情况记录病区
	i obj.HNHSciResWardDR'="" d
	.s ret=ret_"^HNHSciResWardDR|"_obj.HNHSciResWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.HNHSciResWardDR.WardDesc	
	//日期
	i obj.HNHProDate'="" s ret=ret_"^HNHProDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHProDate)	
	// 科研项目类别
	s ret = ret_"^HNHSciProject|"_obj.HNHSciProject	
    //科研项目名称
    s ret = ret_"^HNHSciContent|"_obj.HNHSciContent    
    // 科研项目承担人类别
	s ret = ret_"^HNHSciProPer|"_obj.HNHSciProPer
    //科研项目承担人
    s HNHSciPersonnal="",HNHSciPerDesc=""
	f i=1:1:obj.HNHSciPersonnal.Count() d
	.s perdr=obj.HNHSciPersonnal.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.i HNHSciPersonnal="" s HNHSciPersonnal=perdr,HNHSciPerDesc=perobj.PerName
	.e  s HNHSciPersonnal=HNHSciPersonnal_","_perdr,HNHSciPerDesc=HNHSciPerDesc_","_perobj.PerName
     s ret  = ret_"^HNHSciPersonnal|"_HNHSciPersonnal_"^HNHSciPerDesc|"_HNHSciPerDesc
    // 科研项目详情类别
	s ret = ret_"^HNHSciProDeta|"_obj.HNHSciProDeta	
    //科研项目详情
    s ret = ret_"^HNHSciDetails|"_obj.HNHSciDetails    
    //科研项目完成情况
    s ret = ret_"^HNHSciComplet|"_obj.HNHSciComplet	
	//状态
	s ret=ret_"^HNHSciResStatus|"_obj.HNHSciResStatus
	s ret=ret_"^StatusDesc|"_$case(obj.HNHSciResStatus,"N":"未提交","Y":"已提交","S":"审核通过","B":"驳回",:"")	
	//提交时间
	i obj.HNHSubDate'="" s ret=ret_"^HNHSubDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHSubDate)
	i obj.HNHSubTime'="" s ret=ret_"^HNHSubTime|"_$zt(obj.HNHSubTime,2) 	
	//创建者
	i obj.HNHSciResDesDR'="" d
	.s ret=ret_"^HNHSciResDesDR|"_obj.HNHSciResDesDR.%Id()
	.s ret=ret_"^CrtUserName|"_obj.HNHSciResDesDR.PerName
	e  s ret=ret_"^HNHSciResDesDR|0^CrtUserName|超级管理员"	
	//审核人
	//审核通过
	i obj.HNHSciResStatus="S" d	
	.i obj.HNHRevDR'="" d
	..s ret=ret_"^HNHRevDR|"_obj.HNHRevDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHRevDR.PerName
	.e  s ret=ret_"^HNHRevDR|0^HNHRevName|超级管理员"
	//驳回
	i obj.HNHSciResStatus="B" d	
	.i obj.HNHOperDR'="" d
	..s ret=ret_"^HNHOperDR|"_obj.HNHOperDR.%Id()
	..s ret=ret_"^HNHRevName|"_obj.HNHOperDR.PerName
	.e  s ret=ret_"^HNHOperDR|0^HNHRevName|超级管理员"	
	//创建时间
	i obj.HNHCreDate'="" s ret=ret_"^HNHCreDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHCreDate)
	i obj.HNHCreTime'="" s ret=ret_"^HNHCreTime|"_$zt(obj.HNHCreTime,1)	
	//审核时间
	//审核通过
	i obj.HNHSciResStatus="S" d
	.i obj.HNHRevDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRevDate)
	.i obj.HNHRevTime'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHRevTime,1)	
	//驳回
	i obj.HNHSciResStatus="B" d
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.HNHRejDate)
	.i obj.HNHRejDate'="" s ret=ret_"^HNHRevTime|"_$zt(obj.HNHRejTime,1)	
	//驳回原因
	s ret=ret_"^HNHRejation|"_obj.HNHRejation		
	q ret
}

/// Creator: LCY
/// Createdate: 20190909
/// Description: 获取所有的科研情况记录
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output: 所有科研情况记录
/// Return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindSciRes","^^N^2019^","","0","0")
Query FindSciRes(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSciResExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
#;	s type=$P(parr,"^",1)
#;	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s status=$P(parr,"^",3)
	s year = $p(parr,"^",4)
	s subyear = $p(parr,"^",5)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s admdate="" f  s admdate=$O(^DHCNMG.Handbook.MgHNHSciResI("SciResDate",admdate)) q:admdate=""  d
	.q:(date'="")&&(admdate'=date)
	.s id="" f  s id=$O(^DHCNMG.Handbook.MgHNHSciResI("SciResDate",admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Handbook.MgHNHSciRes).%OpenId(id)
	..q:(ward'="")&&(obj.HNHSciResWardDR'="")&&(obj.HNHSciResWardDR.%Id()'=ward)
	..q:(isAll=0)&&(('$IsObject(obj.HNHSciResWardDR))||('$d(tmpWard(obj.HNHSciResWardDR.%Id()))))
	..q:(status'="")&&(obj.HNHSciResStatus'=status)
	..q:(year'="")&&($p($zd(obj.HNHCreDate,3),"-",1)'=year)
	..q:(subyear'="")&&($p($zd(obj.HNHSubDate,3),"-",1)'=subyear)
	..q:(role["4")&&(obj.HNHSciResStatus="N")
	..s ret=..GetSciRes(id)	
	..d OutNurTrain
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurTrain
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSciResClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSciResFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTrainExecute ]
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

/// Creator: LCY
/// Createdate: 20190909
/// Description: 提交科研情况记录
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output:1：提交成功；0：提交失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).SubSciRes(3,"Y")
ClassMethod SubSciRes(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHSciRes).%OpenId(id)
	s obj.HNHSciResStatus=status
	i status="Y" d
	.s obj.HNHSubDate=+$h
	.s obj.HNHSubTime=$P($h,",",2)
	e  d
	.s obj.HNHSubDate=""
	.s obj.HNHSubTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190909
/// Description: 撤销提交、审核操作
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output:1：撤销成功；0：撤销失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).CancleOper(3)
ClassMethod CancleSciRes(id As %String) As %String
{
	q:id="" 0
	s obj = ##class(DHCNMG.Handbook.MgHNHSciRes).%OpenId(id)
	i obj.HNHSciResStatus = "Y" d
	.s obj.HNHSciResStatus = "N"
	i obj.HNHSciResStatus = "S" d  s obj.HNHSciResStatus = "Y"
	s sc = obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190909
/// Description: 审核通过科研情况记录
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output:1：通过成功；0：通过失败
/// Return:
/// other: w ##class(web.NurMgCNMComm).RevSciRes(3,"S",1,"审核通过")
ClassMethod RevSciRes(id As %String, status As %String, revdr As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgHNHSciRes).%OpenId(id)
	s obj.HNHSciResStatus=status	 
	i status="S" d 
	.s obj.HNHRevDR =##Class(DHCNMG.HR.MgPersons).%OpenId(revdr)
	.s obj.HNHRevIdea = idea
	.s obj.HNHRevDate=+$h
	.s obj.HNHRevTime=$P($h,",",2)
	e  d
	.s obj.HNHRevDate=""
	.s obj.HNHRevTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: lcy
/// Createdate: 20190909
/// Description: 审核驳回科研情况记录
/// Table: DHCNMG.Handbook.MgHNHSciRes
/// input：
/// Output:1：驳回成功；0：驳回失败
/// Return: 
/// other: w ##class(web.NurMgCNMComm).TdownSciRes(3,"B",1,"工作量太少")
ClassMethod TdownSciRes(id As %String, status As %String, oper As DHCNMG.HR.MgPersons, idea As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##class(DHCNMG.Handbook.MgHNHSciRes).%OpenId(id)
	s obj.HNHSciResStatus=status
	i status="B" d
	.s obj.HNHOperDR = ##class(DHCNMG.HR.MgPersons).%OpenId(oper)
	.s obj.HNHRejation = idea
	.s obj.HNHRejDate=+$h
	.s obj.HNHRejTime=$P($h,",",2)
	e  d
	.s obj.HNHRejDate=""
	.s obj.HNHRejTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:删除护理部年度计划
/// Table:DHCNMG.Handbook.AnnualYear
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgCNMComm).DeleteData(4)
ClassMethod DeleteDataAP(rowId As %String) As %String
{
    q:rowId="" 0
	s sc=##Class(DHCNMG.Handbook.AnnualYear).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// w ##class(web.NurMgCNMComm).GetValueAP(4)
ClassMethod GetValueAP(rowId As %String) As %String
{
	q:rowId="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.AnnualYear).%OpenId(rowId)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.AnnualYear","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.s type=^oddCOM("DHCNMG.Handbook.AnnualYear","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1)
    ;i tmp("AddPerDr")'=""  s tmp("AddPerDr")=$p($g(^SSU("SSUSR",tmp("AddPerDr"))),"^",2)
    ;s tmp("AddDate")=tmp("AddDate")_" "_$zt(tmp("AddTime"),1)
    ;s tmp("DepDr2")=$P(^CTLOC(tmp("DepDr")),"^",1)
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
	s ret=ret_"RowId|"_rowId
	s ret=ret_"^StatusDesc|"_$Case(obj.Status,"N":"未提交","Y":"已提交","S":"已审核","B":"已驳回",:"")
	s advice=""	
    i obj.Status="S" d
    .s ret=ret_"^Advice|"_obj.CheckOpinion
    i obj.Status="B" d
    .s ret=ret_"^Advice|"_obj.RejectOpinion
	q ret
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:提交护理部年度计划
/// Table:DHCNMG.Handbook.AnnualYear
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgCNMComm).SubmitPlan(13,"Y")
ClassMethod SubmitPlanAP(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.AnnualYear).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status=status
	i status="Y" d
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	e  d
	.s obj.SubmitDate=""
	.s obj.SubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:保存护理部年度计划
/// Table:DHCNMG.Handbook.AnnualYear
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgCNMComm).SavePlan("RowId|^Year|2019^AnnualPlan|789999^TrainCrtUser|0^TraninCrtName|超级管理员^Status|N^RowId|^Creater|^TrainContent|^")
ClassMethod SavePlanAP(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=""
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.AnnualYear).%New()
	. s obj.Status = "N"	
	i $g(tmp("RowId"))'="" d
	.s obj=##class(DHCNMG.Handbook.AnnualYear).%OpenId(tmp("RowId"))
	i $g(tmp("Year"))'="" d
	. s obj.Year=$g(tmp("Year"))
	e  s obj.Year=""
	i $g(tmp("TraninCrtName"))'="" d
	. s obj.Creater =$g(tmp("TraninCrtName")) 
	e  s obj.Creater=""
	i $g(tmp("AnnualPlan"))'="" d
	. s obj.AnnualPlan = $g(tmp("AnnualPlan"))
	;. s obj.AnnualPlan =$replace($tr($g(tmp("AnnualPlan"))," ",""),$c(10),"")
	e  s obj.AnnualPlan=""
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q $$$ISOK(sc)
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindDataAP","","","6","")
Query FindDataAP(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataAPExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s year=$P(parr,"^",1)
	s StatusI=$P(parr,"^",2)
	 	
	s Status="" f  s Status=$o(^DHCNMG.Handbook.AnnualYearI("YearStatus",Status)) q:Status=""  d
	.q:(StatusI'="")&&(StatusI'=$replace(Status," ","")) 
	.s years="" f  s years=$O(^DHCNMG.Handbook.AnnualYearI("YearStatus",Status,years)) q:years=""  d
	..q:(year'="")&&(year'=$replace(years," ",""))
	..s id="" f  s id=$O(^DHCNMG.Handbook.AnnualYearI("YearStatus",Status,years,id)) q:id=""  d
	...s obj=##class(DHCNMG.Handbook.AnnualYear).%OpenId(id)
	...q:(role<6)&&(obj.Status="N")&&(role'=0)
	...s ret=..GetValueAP(id)
	...d OutAnnualPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAnnualPlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:审核或驳回护理部年度计划
/// Table:DHCNMG.Handbook.AnnualYear
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgCNMComm).ChangePlanStatus("53^S^都是^超级管理员","","")
ClassMethod ChangePlanStatusAP(parr, nurseid, role) As %String
{
	s id=$p(parr,"^",1)
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s operator=$p(parr,"^",4)
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.AnnualYear).%OpenId(id)
	q:'$IsObject(obj) ""
	i status="S" d
	.s obj.Status=status
	.s obj.CheckOpinion = reason
	.s obj.Checker = operator
	.s obj.CheckDate=+$h
	.s obj.CheckTime=$P($h,",",2)
	e  d
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	
	i status="B" d
	.s obj.Status=status
	.s obj.RejectOpinion = reason
	.s obj.Rejector = operator
	.s obj.RejectDate=+$h
	.s obj.RejectTime=$P($h,",",2)
	e  d
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:撤销护理部年度计划
/// Table:DHCNMG.Handbook.AnnualYear
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgCNMComm).CancelStatus(62)
ClassMethod CancelStatusAP(rowId) As %String
{
	q:rowId="" 0
	s obj=##class(DHCNMG.Handbook.AnnualYear).%OpenId(rowId)
	q:'$IsObject(obj) 7
	
	q:obj.Status="N"||obj.Status="Y" 0
	
	i obj.Status="S" d
	.s obj.Status="Y"
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	.s obj.Checker=""
	.s obj.CheckOpinion=""
	
	i obj.Status="B" d
	.s obj.Status="Y"
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	.s obj.Rejector=""
	.s obj.RejectOpinion=""

		
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:删除业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgConsultation).DeleteData(4)
ClassMethod DeleteDataC(rowId As %String) As %String
{
    q:rowId="" 0
	s sc=##Class(DHCNMG.Handbook.NurConsultation).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:根据rowId业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgConsultation).GetValueC(1) 
ClassMethod GetValueC(rowId As %String) As %String
{
	q:rowId="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.NurConsultation).%OpenId(rowId)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.NurConsultation","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.NurConsultation","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1)
    i tmp("WardDR")'=""  s tmp("WardDR")=obj.WardDR.%Id()
    ;s tmp("AddDate")=tmp("AddDate")_" "_$zt(tmp("AddTime"),1)
    ;s tmp("DepDr2")=$P(^CTLOC(tmp("DepDr")),"^",1)
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
    s ret=ret_"WardDesc|"_obj.WardDR.WardDesc
    s ret=ret_"^StatusDesc|"_$Case(obj.Status,"N":"未提交","Y":"已提交","S":"已审核","B":"已驳回",:"")
	s ret=ret_"^RowId|"_rowId
	;s PatientName=##class(web.NurMgWardRound).GetPatName(obj.Patient)
	s PatientName=..GetPatNameWR(obj.Patient)
    s ret=ret_"^PatientName|"_PatientName
	q ret
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:保存业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgConsultation).SaveData("RowId|^CheckDate|2019-09-09^WardDesc|1^ExamProject|项目^Examiner|我^ExamObject|你^Examinee|谁^Score|456^Status|N^RowId|^Remarks|^Creater|超级管理员^TrainCrtUser|0^TrainContent|^TrainTeaWardDR|1^")
ClassMethod SaveDataC(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=""
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.NurConsultation).%New()
	.s obj.Status = "N"	
	i $g(tmp("RowId"))'="" d
	.s obj=##class(DHCNMG.Handbook.NurConsultation).%OpenId(tmp("RowId"))
	i $g(tmp("ConDate"))'="" d	
	.s obj.ConDate=$zdh($g(tmp("ConDate")),3)
	e  s obj.ConDate=""
	i $g(tmp("Creater"))'="" d
	. s obj.Creater =$g(tmp("Creater")) 
	e  s obj.Creater=""
	i $g(tmp("Host"))'="" d
	. s obj.Host =$g(tmp("Host")) 
	e  s obj.Host=""
	i $g(tmp("Participant"))'="" d
	. s obj.Participant =$g(tmp("Participant")) 
	e  s obj.Participant=""
	i $g(tmp("Patient"))'="" d
	. s obj.Patient =$g(tmp("Patient")) 
	e  s obj.Patient=""
	i $g(tmp("DiseaseNumber"))'="" d
	. s obj.DiseaseNumber =$g(tmp("DiseaseNumber")) 
	e  s obj.DiseaseNumber=""
	i $g(tmp("Diagnosis"))'="" d
	. s obj.Diagnosis =$g(tmp("Diagnosis")) 
	e  s obj.Diagnosis=""
	i $g(tmp("Remarks"))'="" d
	. s obj.Remarks =$replace($tr($g(tmp("Remarks"))," ",""),$c(10),"") 
	e  s obj.Remarks=""
	i $g(tmp("WardDR"))'="" d
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	s sc=obj.%Save()
	s err = $System.OBJ.DisplayError(sc)
	q:$$$ISERR(sc) err
	q $$$ISOK(sc)
}

/// Test:d ##class(%ResultSet).RunQuery("web.NurMgConsultation","FindDataC","","",0,0)
Query FindDataC(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataCExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)	
	s ConDateI=$P(parr,"^",2)	
	s StatusI=$P(parr,"^",3)	
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)	 	
	s Status="" f  s Status=$o(^DHCNMG.Handbook.NurConsultaI("StatusConDate",Status)) q:Status=""  d
	.q:(StatusI'="")&&(StatusI'=$replace(Status," ","")) 	
	.s ConDate="" f  s ConDate=$O(^DHCNMG.Handbook.NurConsultaI("StatusConDate",Status,ConDate)) q:ConDate=""  d	
	..q:(ConDateI'="")&&($zdh(ConDateI,3)'=$replace(ConDate," ",""))
	..s id="" f  s id=$O(^DHCNMG.Handbook.NurConsultaI("StatusConDate",Status,ConDate,id)) q:id=""  d
	...s obj=##class(DHCNMG.Handbook.NurConsultation).%OpenId(id)
	...q:(role<6)&&(obj.Status="N")&&(role'=0) 	
	...q:(ward'="")&&(obj.WardDR'="")&&(obj.WardDR.%Id()'=ward)
	...q:(isAll=0)&&(('$IsObject(obj.WardDR))||('$d(tmpWard(obj.WardDR.%Id()))))
	...s ret=..GetValueC(id)
	...d OutCheck
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheck
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:提交业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgConsultation).SubmitData(13,"Y")
ClassMethod SubmitDataC(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.NurConsultation).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status=status
	i status="Y" d
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	e  d
	.s obj.SubmitDate=""
	.s obj.SubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:审核或驳回月工作计划
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).ChangeStatus("18^S^哈哈^超级管理员","","")
ClassMethod ChangeStatusC(parr, nurseid, role) As %String
{
	s id=$p(parr,"^",1)
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s operator=$p(parr,"^",4)
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.NurConsultation).%OpenId(id)
	q:'$IsObject(obj) ""
	i status="S" d
	.s obj.Status=status
	.s obj.CheckOpinion = reason
	.s obj.Checker = operator
	.s obj.CheckDate=+$h
	.s obj.CheckTime=$P($h,",",2)
	e  d
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	
	i status="B" d
	.s obj.Status=status
	.s obj.RejectOpinion = reason
	.s obj.Rejector = operator
	.s obj.RejectDate=+$h
	.s obj.RejectTime=$P($h,",",2)
	e  d
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:撤销月工作计划
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).CancelStatus(20)
ClassMethod CancelStatusC(rowId) As %String
{
	q:rowId="" 0
	s obj=##class(DHCNMG.Handbook.NurConsultation).%OpenId(rowId)
	q:'$IsObject(obj) 7
	
	q:obj.Status="N"||obj.Status="Y" 0
	
	i obj.Status="S" d
	.s obj.Status="Y"
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	.s obj.Checker=""
	.s obj.CheckOpinion=""
	
	i obj.Status="B" d
	.s obj.Status="Y"
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	.s obj.Rejector=""
	.s obj.RejectOpinion=""

		
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:删除病例讨论
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgDiscuss).DeleteData(4)
ClassMethod DeleteDataD(rowId As %String) As %String
{
    q:rowId="" 0
	s sc=##Class(DHCNMG.Handbook.IllDiscuss).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:根据rowId病例讨论
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgDiscuss).GetValueD(3) 
ClassMethod GetValueD(rowId As %String) As %String
{
	q:rowId="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.IllDiscuss).%OpenId(rowId)
	q:'$IsObject(obj) ""
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.IllDiscuss","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.IllDiscuss","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1)
    i tmp("WardDR")'=""  s tmp("WardDR")=obj.WardDR.%Id()
    ;s tmp("AddDate")=tmp("AddDate")_" "_$zt(tmp("AddTime"),1)
    ;s tmp("DepDr2")=$P(^CTLOC(tmp("DepDr")),"^",1)
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
    s ret=ret_"WardDesc|"_obj.WardDR.WardDesc
    s ret=ret_"^StatusDesc|"_$Case(obj.Status,"N":"未提交","Y":"已提交","S":"已审核","B":"已驳回",:"")
    s ret=ret_"^CaseTypeDesc|"_$Case(obj.CaseType,"H":"疑难","D":"死亡","O":"其他",:"")
	s ret=ret_"^RowId|"_rowId
	s advice=""	
    i obj.Status="S" d
    .s ret=ret_"^Advice|"_obj.CheckOpinion
    i obj.Status="B" d
    .s ret=ret_"^Advice|"_obj.RejectOpinion
    ;s PatientName=##class(web.NurMgWardRound).GetPatName(obj.Patient)
    s PatientName=..GetPatNameWR(obj.Patient)
    s ret=ret_"^PatientName|"_PatientName
	q ret
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:保存病例讨论
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgDiscuss).SaveData("RowId|^CheckDate|2019-09-09^WardDesc|1^ExamProject|项目^Examiner|我^ExamObject|你^Examinee|谁^Score|456^Status|N^RowId|^Remarks|^Creater|超级管理员^TrainCrtUser|0^TrainContent|^TrainTeaWardDR|1^")
ClassMethod SaveDataD(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=""
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.IllDiscuss).%New()
	.s obj.Status = "N"	
	i $g(tmp("RowId"))'="" d
	.s obj=##class(DHCNMG.Handbook.IllDiscuss).%OpenId(tmp("RowId"))
	i $g(tmp("DiscussDate"))'="" d	
	.s obj.DiscussDate=$zdh($g(tmp("DiscussDate")),3)
	e  s obj.DiscussDate=""
	i $g(tmp("Creater"))'="" d
	. s obj.Creater =$g(tmp("Creater")) 
	e  s obj.Creater=""
	i $g(tmp("CaseType"))'="" d
	. s obj.CaseType =$g(tmp("CaseType")) 
	e  s obj.CaseType=""
	i $g(tmp("DiseaseNumber"))'="" d
	. s obj.DiseaseNumber =$g(tmp("DiseaseNumber")) 
	e  s obj.DiseaseNumber=""
	i $g(tmp("Patient"))'="" d
	. s obj.Patient =$g(tmp("Patient")) 
	e  s obj.Patient=""	
	i $g(tmp("Diagnosis"))'="" d
	. s obj.Diagnosis =$g(tmp("Diagnosis")) 
	e  s obj.Diagnosis=""
	i $g(tmp("Host"))'="" d
	. s obj.Host =$g(tmp("Host")) 
	e  s obj.Host=""
	i $g(tmp("Participant"))'="" d
	. s obj.Participant =$g(tmp("Participant")) 
	e  s obj.Participant=""
	i $g(tmp("Notes"))'="" d
	. s obj.Notes =$replace($tr($g(tmp("Notes"))," ",""),$c(10),"")  
	e  s obj.Notes=""
	i $g(tmp("Remarks"))'="" d
	. s obj.Remarks =$replace($tr($g(tmp("Remarks"))," ",""),$c(10),"") 
	e  s obj.Remarks=""
	i $g(tmp("WardDR"))'="" d
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	s sc=obj.%Save()
	s err = $System.OBJ.DisplayError(sc)
	q:$$$ISERR(sc) err
	q $$$ISOK(sc)
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgDiscuss","FindDataD","","",0,0)
Query FindDataD(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataDExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)	
	s DiscussDateI=$P(parr,"^",2)	
	s StatusI=$P(parr,"^",3)	
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)	 	
	s Status="" f  s Status=$o(^DHCNMG.Handbook.IllDiscussI("StatusDiscussDate",Status)) q:Status=""  d	
	.q:(StatusI'="")&&(StatusI'=$replace(Status," ","")) 		
	.s DiscussDate="" f  s DiscussDate=$O(^DHCNMG.Handbook.IllDiscussI("StatusDiscussDate",Status,DiscussDate)) q:DiscussDate=""  d		
	..q:(DiscussDateI'="")&&($zdh(DiscussDateI,3)'=$replace(DiscussDate," ",""))
	..s id="" f  s id=$O(^DHCNMG.Handbook.IllDiscussI("StatusDiscussDate",Status,DiscussDate,id)) q:id=""  d
	...s obj=##class(DHCNMG.Handbook.IllDiscuss).%OpenId(id)
	...q:(role<6)&&(obj.Status="N")&&(role'=0) 	
	...q:(ward'="")&&(obj.WardDR'="")&&(obj.WardDR.%Id()'=ward)
	...q:(isAll=0)&&(('$IsObject(obj.WardDR))||('$d(tmpWard(obj.WardDR.%Id()))))
	...s ret=..GetValueD(id)
	...d OutCheck
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheck
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:提交病例讨论
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgDiscuss).SubmitData(13,"Y")
ClassMethod SubmitDataD(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.IllDiscuss).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status=status
	i status="Y" d
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	e  d
	.s obj.SubmitDate=""
	.s obj.SubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:审核或驳回病例讨论
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).ChangeStatus("18^S^哈哈^超级管理员","","")
ClassMethod ChangeStatusD(parr, nurseid, role) As %String
{
	s id=$p(parr,"^",1)
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s operator=$p(parr,"^",4)
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.IllDiscuss).%OpenId(id)
	q:'$IsObject(obj) ""
	i status="S" d
	.s obj.Status=status
	.s obj.CheckOpinion = reason
	.s obj.Checker = operator
	.s obj.CheckDate=+$h
	.s obj.CheckTime=$P($h,",",2)
	e  d
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	
	i status="B" d
	.s obj.Status=status
	.s obj.RejectOpinion = reason
	.s obj.Rejector = operator
	.s obj.RejectDate=+$h
	.s obj.RejectTime=$P($h,",",2)
	e  d
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:撤销病例讨论
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).CancelStatus(20)
ClassMethod CancelStatusD(rowId) As %String
{
	q:rowId="" 0
	s obj=##class(DHCNMG.Handbook.IllDiscuss).%OpenId(rowId)
	q:'$IsObject(obj) 7
	
	q:obj.Status="N"||obj.Status="Y" 0
	
	i obj.Status="S" d
	.s obj.Status="Y"
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	.s obj.Checker=""
	.s obj.CheckOpinion=""
	
	i obj.Status="B" d
	.s obj.Status="Y"
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	.s obj.Rejector=""
	.s obj.RejectOpinion=""

		
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:删除业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgHiddenDanageNotes).DeleteData(4)
ClassMethod DeleteDataHD(rowId As %String) As %String
{
    q:rowId="" 0
	s sc=##Class(DHCNMG.Handbook.HiddenDanageNotes).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:根据rowId业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgHiddenDanageNotes).GetValueHD(1) 
ClassMethod GetValueHD(rowId As %String) As %String
{
	q:rowId="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.HiddenDanageNotes).%OpenId(rowId)
	q:'$IsObject(obj) ""
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.HiddenDanageNotes","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.HiddenDanageNotes","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1)
    i tmp("WardDR")'=""  s tmp("WardDR")=obj.WardDR.%Id()
    ;s tmp("AddDate")=tmp("AddDate")_" "_$zt(tmp("AddTime"),1)
    ;s tmp("DepDr2")=$P(^CTLOC(tmp("DepDr")),"^",1)
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
	i obj.Status="S" d
    .s ret=ret_"Advice|"_obj.CheckOpinion
    i obj.Status="B" d
    .s ret=ret_"Advice|"_obj.RejectOpinion
    s ret=ret_"^WardDesc|"_obj.WardDR.WardDesc
    s ret=ret_"^StatusDesc|"_$Case(obj.Status,"N":"未提交","Y":"已提交","S":"已审核","B":"已驳回",:"")
	s ret=ret_"^RowId|"_rowId
	s advice=""	
    i obj.Status="S" d
    .s ret=ret_"^Advice|"_obj.CheckOpinion
    i obj.Status="B" d
    .s ret=ret_"^Advice|"_obj.RejectOpinion
	q ret
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:保存业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgHiddenDanageNotes).SaveData("RowId|^CheckDate|2019-09-09^WardDesc|1^ExamProject|项目^Examiner|我^ExamObject|你^Examinee|谁^Score|456^Status|N^RowId|^Remarks|^Creater|超级管理员^TrainCrtUser|0^TrainContent|^TrainTeaWardDR|1^")
ClassMethod SaveDataHD(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=""
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.HiddenDanageNotes).%New()
	.s obj.Status = "N"	
	i $g(tmp("RowId"))'="" d
	.s obj=##class(DHCNMG.Handbook.HiddenDanageNotes).%OpenId(tmp("RowId"))
	i $g(tmp("NotesDate"))'="" d	
	.s obj.NotesDate=$zdh($g(tmp("NotesDate")),3)
	e  s obj.NotesDate=""
	i $g(tmp("Creater"))'="" d
	. s obj.Creater =$g(tmp("Creater")) 
	e  s obj.Creater=""
	i $g(tmp("Host"))'="" d
	. s obj.Host =$g(tmp("Host")) 
	e  s obj.Host=""
	i $g(tmp("Participant"))'="" d
	. s obj.Participant =$g(tmp("Participant")) 
	e  s obj.Participant=""
	i $g(tmp("Notes"))'="" d
	. s obj.Notes =$replace($tr($g(tmp("Notes"))," ",""),$c(10),"")  
	e  s obj.Notes=""
	i $g(tmp("Remarks"))'="" d
	. s obj.Remarks =$replace($tr($g(tmp("Remarks"))," ",""),$c(10),"")  
	e  s obj.Remarks=""
	i $g(tmp("WardDR"))'="" d
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	s sc=obj.%Save()
	s err = $System.OBJ.DisplayError(sc)
	q:$$$ISERR(sc) err
	q $$$ISOK(sc)
}

/// Test:d ##class(%ResultSet).RunQuery("web.NurMgHiddenDanageNotes","FindDataHD","","",0,0)
Query FindDataHD(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataHDExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)	
	s NotesDateI=$P(parr,"^",2)	
	s StatusI=$P(parr,"^",3)	
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)	 	
	s Status="" f  s Status=$o(^DHCNMG.Handbook.HiddenDNotesI("StatusNotesDate",Status)) q:Status=""  d
	.q:(StatusI'="")&&(StatusI'=$replace(Status," ","")) 	
	.s NotesDate="" f  s NotesDate=$O(^DHCNMG.Handbook.HiddenDNotesI("StatusNotesDate",Status,NotesDate)) q:NotesDate=""  d	
	..q:(NotesDateI'="")&&($zdh(NotesDateI,3)'=$replace(NotesDate," ",""))
	..s id="" f  s id=$O(^DHCNMG.Handbook.HiddenDNotesI("StatusNotesDate",Status,NotesDate,id)) q:id=""  d
	...s obj=##class(DHCNMG.Handbook.HiddenDanageNotes).%OpenId(id)
	...q:(role<6)&&(obj.Status="N")&&(role'=0) 	
	...q:(ward'="")&&(obj.WardDR'="")&&(obj.WardDR.%Id()'=ward)
	...q:(isAll=0)&&(('$IsObject(obj.WardDR))||('$d(tmpWard(obj.WardDR.%Id()))))
	...s ret=..GetValueHD(id)
	...d OutCheck
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheck
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:提交业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgHiddenDanageNotes).SubmitData(13,"Y")
ClassMethod SubmitDataHD(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.HiddenDanageNotes).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status=status
	i status="Y" d
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	e  d
	.s obj.SubmitDate=""
	.s obj.SubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:审核或驳回月工作计划
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).ChangeStatus("18^S^哈哈^超级管理员","","")
ClassMethod ChangeStatusHD(parr, nurseid, role) As %String
{
	s id=$p(parr,"^",1)
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s operator=$p(parr,"^",4)
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.HiddenDanageNotes).%OpenId(id)
	q:'$IsObject(obj) ""
	i status="S" d
	.s obj.Status=status
	.s obj.CheckOpinion = reason
	.s obj.Checker = operator
	.s obj.CheckDate=+$h
	.s obj.CheckTime=$P($h,",",2)
	e  d
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	
	i status="B" d
	.s obj.Status=status
	.s obj.RejectOpinion = reason
	.s obj.Rejector = operator
	.s obj.RejectDate=+$h
	.s obj.RejectTime=$P($h,",",2)
	e  d
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:撤销月工作计划
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).CancelStatus(20)
ClassMethod CancelStatusHD(rowId) As %String
{
	q:rowId="" 0
	s obj=##class(DHCNMG.Handbook.HiddenDanageNotes).%OpenId(rowId)
	q:'$IsObject(obj) 7
	
	q:obj.Status="N"||obj.Status="Y" 0
	
	i obj.Status="S" d
	.s obj.Status="Y"
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	.s obj.Checker=""
	.s obj.CheckOpinion=""
	
	i obj.Status="B" d
	.s obj.Status="Y"
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	.s obj.Rejector=""
	.s obj.RejectOpinion=""

		
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:删除业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRound).DeleteData(4)
ClassMethod DeleteDataWR(rowId As %String) As %String
{
    q:rowId="" 0
	s sc=##Class(DHCNMG.Handbook.WardRound).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:根据rowId业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRound).GetValueWR(10) 
ClassMethod GetValueWR(rowId As %String) As %String
{
	q:rowId="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.WardRound).%OpenId(rowId)
	q:'$IsObject(obj) ""
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.WardRound","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.WardRound","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1)
    i tmp("WardDR")'=""  s tmp("WardDR")=obj.WardDR.%Id()
    ;s tmp("AddDate")=tmp("AddDate")_" "_$zt(tmp("AddTime"),1)
    ;s tmp("DepDr2")=$P(^CTLOC(tmp("DepDr")),"^",1)
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
    s ret=ret_"WardDesc|"_obj.WardDR.WardDesc
    s ret=ret_"^StatusDesc|"_$Case(obj.Status,"N":"未提交","Y":"已提交","S":"已审核","B":"已驳回",:"")
	s ret=ret_"^RowId|"_rowId
	s advice=""	
    i obj.Status="S" d
    .s ret=ret_"^Advice|"_obj.CheckOpinion
    i obj.Status="B" d
    .s ret=ret_"^Advice|"_obj.RejectOpinion
    s PatientName=..GetPatNameWR(obj.Patient)
    s ret=ret_"^PatientName|"_PatientName
	q ret
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:保存业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRound).SaveData("RowId|^CheckDate|2019-09-09^WardDesc|1^ExamProject|项目^Examiner|我^ExamObject|你^Examinee|谁^Score|456^Status|N^RowId|^Remarks|^Creater|超级管理员^TrainCrtUser|0^TrainContent|^TrainTeaWardDR|1^")
ClassMethod SaveDataWR(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=""
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.WardRound).%New()
	.s obj.Status = "N"	
	
	i $g(tmp("RowId"))'="" d
	.s obj=##class(DHCNMG.Handbook.WardRound).%OpenId(tmp("RowId"))
	
	i $g(tmp("CheckRoomDate"))'="" d	
	.s obj.CheckRoomDate=$zdh($g(tmp("CheckRoomDate")),3)
	e  s obj.CheckRoomDate=""
	
	i $g(tmp("Creater"))'="" d
	. s obj.Creater =$g(tmp("Creater")) 
	e  s obj.Creater=""
	
	i $g(tmp("Theme"))'="" d
	. s obj.Theme =$g(tmp("Theme")) 
	e  s obj.Theme=""
	
	i $g(tmp("Host"))'="" d
	. s obj.Host =$g(tmp("Host")) 
	e  s obj.Host=""
	
	i $g(tmp("Participant"))'="" d
	. s obj.Participant =$g(tmp("Participant")) 
	e  s obj.Participant=""
	
	i $g(tmp("Patient"))'="" d
	. s obj.Patient =$g(tmp("Patient")) 
	e  s obj.Patient=""
	
	i $g(tmp("BedNumber"))'="" d
	. s obj.BedNumber =$g(tmp("BedNumber")) 
	e  s obj.BedNumber=""
	
	i $g(tmp("Diagnosis"))'="" d
	. s obj.Diagnosis =$g(tmp("Diagnosis")) 
	e  s obj.Diagnosis=""
	
	i $g(tmp("Remarks"))'="" d
	. s obj.Remarks =$replace($tr($g(tmp("Remarks"))," ",""),$c(10),"") 
	e  s obj.Remarks=""
	
	i $g(tmp("WardDR"))'="" d
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	
	s sc=obj.%Save()
	s err = $System.OBJ.DisplayError(sc)
	q:$$$ISERR(sc) err
	q $$$ISOK(sc)
}

/// Test:d ##class(%ResultSet).RunQuery("web.NurMgWardRound","FindDataWR","","",0,0)
Query FindDataWR(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataWRExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)	
	s CheckRoomDateI=$P(parr,"^",2)	
	s StatusI=$P(parr,"^",3)	
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)	 	
	s Status="" f  s Status=$o(^DHCNMG.Handbook.WardRoundI("StatusCheckRoomDate",Status)) q:Status=""  d
	.q:(StatusI'="")&&(StatusI'=$replace(Status," ","")) 	
	.s CheckRoomDate="" f  s CheckRoomDate=$O(^DHCNMG.Handbook.WardRoundI("StatusCheckRoomDate",Status,CheckRoomDate)) q:CheckRoomDate=""  d	
	..q:(CheckRoomDateI'="")&&($zdh(CheckRoomDateI,3)'=$replace(CheckRoomDate," ",""))
	..s id="" f  s id=$O(^DHCNMG.Handbook.WardRoundI("StatusCheckRoomDate",Status,CheckRoomDate,id)) q:id=""  d
	...s obj=##class(DHCNMG.Handbook.WardRound).%OpenId(id)
	...q:(role<6)&&(obj.Status="N")&&(role'=0) 	
	...q:(ward'="")&&(obj.WardDR'="")&&(obj.WardDR.%Id()'=ward)
	...q:(isAll=0)&&(('$IsObject(obj.WardDR))||('$d(tmpWard(obj.WardDR.%Id()))))
	...s ret=..GetValueWR(id)
	...d OutCheck
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheck
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:提交业务查房
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRound).SubmitData(13,"Y")
ClassMethod SubmitDataWR(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.WardRound).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status=status
	i status="Y" d
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	e  d
	.s obj.SubmitDate=""
	.s obj.SubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:审核或驳回月工作计划
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRound).ChangeStatus("7^S^分^超级管理员","","")
ClassMethod ChangeStatusWR(parr, nurseid, role) As %String
{
	s id=$p(parr,"^",1)
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s operator=$p(parr,"^",4)
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.WardRound).%OpenId(id)
	q:'$IsObject(obj) ""
	i status="S" d
	.s obj.Status=status
	.s obj.CheckOpinion = reason
	.s obj.Checker = operator
	.s obj.CheckDate=+$h
	.s obj.CheckTime=$P($h,",",2)
	e  d
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	
	i status="B" d
	.s obj.Status=status
	.s obj.RejectOpinion = reason
	.s obj.Rejector = operator
	.s obj.RejectDate=+$h
	.s obj.RejectTime=$P($h,",",2)
	e  d
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:撤销审核驳回状态
/// Table:DHCNMG.Handbook.WardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).CancelStatus(20)
ClassMethod CancelStatusWR(rowId) As %String
{
	q:rowId="" 0
	s obj=##class(DHCNMG.Handbook.WardRound).%OpenId(rowId)
	q:'$IsObject(obj) 7
	
	q:obj.Status="N"||obj.Status="Y" 0
	
	i obj.Status="S" d
	.s obj.Status="Y"
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	.s obj.Checker=""
	.s obj.CheckOpinion=""
	
	i obj.Status="B" d
	.s obj.Status="Y"
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	.s obj.Rejector=""
	.s obj.RejectOpinion=""

		
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// 获取病人姓名
/// 参考: web.DHCMGNurComm PatInfo
/// w ##class(web.NurMgWardRound).GetPatNameWR("649")
/// Input：就诊号，登记号
ClassMethod GetPatNameWR(adm As %String = "") As %String
{
	q:(adm="")&&(patno="") ""
	i adm'="" s papmidr=$P(^PAADM(adm),"^",1)
	e  s papmidr=$O(^PAPERi("PAPMI_PatNo",$zcvt("","U"),""))
	q:papmidr="" ""
	s patname=$P($g(^PAPER(papmidr,"ALL")),"^",1)
	q patname
}

/// 获取病人第一次诊断
/// w ##class(web.NurMgWardRound).GetPatFirstDiag(43)
ClassMethod GetPatFirstDiagWR(adm As %String) As %String
{
	q:adm="" ""
	s mradm=$p(^PAADM(adm),"^",61)
	s typ1="入院",typ2="初步"
    f a2=1:1:$g(^MR(mradm,"DIA",0))  d
    .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
    .q:icdr="" 
    .s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
    .s diatype=""
    .i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",2)  ;诊断类型
    .q:(diatype'[typ1)&&(diatype'[typ2)
    .s typ=typ1
    .s:diatype[typ2 typ=typ2
    .s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
    .s:icdcode'="" tmp(typ,a2)=icdcode
    .q:icdcode'=""
    .s MRDIADesc=0 s MRDIADesc=$o(^MR(mradm,"DIA",a2,"DES",MRDIADesc))
    .q:MRDIADesc=""
    .s MRDIADesc=$p(^MR(mradm,"DIA",chl,"DES",MRDIADesc),"^",1)
    .s:MRDIADesc'="" tmp(typ,a2)=MRDIADesc
    s diag=""
    s:$d(tmp(typ1)) diag=tmp(typ1,$O(tmp(typ1,0)))
    s:(diag="")&&($d(tmp(typ2))) diag=tmp(typ2,$O(tmp(typ2,0)))
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")	
    q diag
}

/// 获取床号
/// w ##class(web.NurMgWardRound).GetBedNumber(43)
ClassMethod GetBedNumberWR(adm As %String) As %String
{
    s beddr=$P($g(^PAADM(adm)),"^",73)
	i beddr'="" s bedcode=$P(^PAWARD(+beddr,"BED",$P(beddr,"||",2)),"^",1)
	e  s bedcode=""
	q bedcode
}

/// 获取病案号
/// w ##class(web.NurMgWardRound).GetDiseaseNumber(649)
ClassMethod GetDiseaseNumberWR(adm As %String) As %String
{
    s admType=$p(^PAADM(adm),"^",2)
	s ctlocID=$p(^PAADM(adm),"^",4)
    s hospital=$p($g(^CTLOC(+ctlocID)),"^",22)
    s errmsg=""
    i adm'="" s papmidr=$P(^PAADM(adm),"^",1)
	q:papmidr="" ""
    // 调取接口
	s medicareNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmidr,admType,hospital,.errmsg)
	q medicareNo
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:删除业务查房
/// Table:DHCNMG.Handbook.MgWardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRoundMg).DeleteData(4)
ClassMethod DeleteDataWRM(rowId As %String) As %String
{
    q:rowId="" 0
	s sc=##Class(DHCNMG.Handbook.MgWardRound).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:根据rowId业务查房
/// Table:DHCNMG.Handbook.MgWardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgCNMComm).GetValueWRM(2) 
ClassMethod GetValueWRM(rowId As %String) As %String
{
	q:rowId="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.MgWardRound).%OpenId(rowId)
	q:'$IsObject(obj) ""
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.MgWardRound","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.s type=^oddCOM("DHCNMG.Handbook.MgWardRound","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1)
    i tmp("WardDR")'=""  s tmp("WardDR")=obj.WardDR.%Id()
    ;s tmp("AddDate")=tmp("AddDate")_" "_$zt(tmp("AddTime"),1)
    ;s tmp("DepDr2")=$P(^CTLOC(tmp("DepDr")),"^",1)
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
    s ret=ret_"WardDesc|"_obj.WardDR.WardDesc
    s ret=ret_"^StatusDesc|"_$Case(obj.Status,"N":"未提交","Y":"已提交","S":"已审核","B":"已驳回",:"")
	s ret=ret_"^RowId|"_rowId
	s advice=""	
    i obj.Status="S" d
    .s ret=ret_"^Advice|"_obj.CheckOpinion
    i obj.Status="B" d
    .s ret=ret_"^Advice|"_obj.RejectOpinion
	q ret
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:保存业务查房
/// Table:DHCNMG.Handbook.MgWardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRoundMg).SaveData("RowId|^CheckDate|2019-09-09^WardDesc|1^ExamProject|项目^Examiner|我^ExamObject|你^Examinee|谁^Score|456^Status|N^RowId|^Remarks|^Creater|超级管理员^TrainCrtUser|0^TrainContent|^TrainTeaWardDR|1^")
ClassMethod SaveDataWRM(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=""
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.MgWardRound).%New()
	.s obj.Status = "N"	
	i $g(tmp("RowId"))'="" d
	.s obj=##class(DHCNMG.Handbook.MgWardRound).%OpenId(tmp("RowId"))
	i $g(tmp("CheckRoomDate"))'="" d	
	.s obj.CheckRoomDate=$zdh($g(tmp("CheckRoomDate")),3)
	e  s obj.CheckRoomDate=""
	i $g(tmp("Creater"))'="" d
	. s obj.Creater =$g(tmp("Creater")) 
	e  s obj.Creater=""
	i $g(tmp("Host"))'="" d
	. s obj.Host =$g(tmp("Host")) 
	e  s obj.Host=""
	i $g(tmp("Participant"))'="" d
	. s obj.Participant =$g(tmp("Participant")) 
	e  s obj.Participant=""
	i $g(tmp("Notes"))'="" d
	. s obj.Notes =$replace($tr($g(tmp("Notes"))," ",""),$c(10),"") 
	e  s obj.Notes=""
	i $g(tmp("Remarks"))'="" d
	. s obj.Remarks =$replace($tr($g(tmp("Remarks"))," ",""),$c(10),"") 
	e  s obj.Remarks=""
	i $g(tmp("WardDR"))'="" d
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	s sc=obj.%Save()
	s err = $System.OBJ.DisplayError(sc)
	q:$$$ISERR(sc) err
	q $$$ISOK(sc)
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgWardRoundMg","FindDataWRM","","",0,0)
Query FindDataWRM(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataWRMExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)	
	s CheckRoomDateI=$P(parr,"^",2)	
	s StatusI=$P(parr,"^",3)	
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)	 	
	s Status="" f  s Status=$o(^DHCNMG.Handbook.MgWardRoundI("StatusCheckRoomDate",Status)) q:Status=""  d
	.q:(StatusI'="")&&(StatusI'=$replace(Status," ","")) 	
	.s CheckRoomDate="" f  s CheckRoomDate=$O(^DHCNMG.Handbook.MgWardRoundI("StatusCheckRoomDate",Status,CheckRoomDate)) q:CheckRoomDate=""  d	
	..q:(CheckRoomDateI'="")&&($zdh(CheckRoomDateI,3)'=$replace(CheckRoomDate," ",""))
	..s id="" f  s id=$O(^DHCNMG.Handbook.MgWardRoundI("StatusCheckRoomDate",Status,CheckRoomDate,id)) q:id=""  d
	...s obj=##class(DHCNMG.Handbook.MgWardRound).%OpenId(id)
	...q:(role<6)&&(obj.Status="N")&&(role'=0) 	
	...q:(ward'="")&&(obj.WardDR'="")&&(obj.WardDR.%Id()'=ward)
	...q:(isAll=0)&&(('$IsObject(obj.WardDR))||('$d(tmpWard(obj.WardDR.%Id()))))
	...s ret=..GetValueWRM(id)
	...d OutCheck
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheck
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:提交业务查房
/// Table:DHCNMG.Handbook.MgWardRound
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWardRoundMg).SubmitData(13,"Y")
ClassMethod SubmitDataWRM(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgWardRound).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status=status
	i status="Y" d
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	e  d
	.s obj.SubmitDate=""
	.s obj.SubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:审核或驳回月工作计划
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).ChangeStatus("18^S^哈哈^超级管理员","","")
ClassMethod ChangeStatusWRM(parr, nurseid, role) As %String
{
	s id=$p(parr,"^",1)
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s operator=$p(parr,"^",4)
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.MgWardRound).%OpenId(id)
	q:'$IsObject(obj) ""
	i status="S" d
	.s obj.Status=status
	.s obj.CheckOpinion = reason
	.s obj.Checker = operator
	.s obj.CheckDate=+$h
	.s obj.CheckTime=$P($h,",",2)
	e  d
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	
	i status="B" d
	.s obj.Status=status
	.s obj.RejectOpinion = reason
	.s obj.Rejector = operator
	.s obj.RejectDate=+$h
	.s obj.RejectTime=$P($h,",",2)
	e  d
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:撤销月工作计划
/// Table:DHCNMG.Handbook.MonthPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgMonthPlan).CancelStatus(20)
ClassMethod CancelStatusWRM(rowId) As %String
{
	q:rowId="" 0
	s obj=##class(DHCNMG.Handbook.MgWardRound).%OpenId(rowId)
	q:'$IsObject(obj) 7
	
	q:obj.Status="N"||obj.Status="Y" 0
	
	i obj.Status="S" d
	.s obj.Status="Y"
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	.s obj.Checker=""
	.s obj.CheckOpinion=""
	
	i obj.Status="B" d
	.s obj.Status="Y"
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	.s obj.Rejector=""
	.s obj.RejectOpinion=""	
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:删除月工作计划
/// Table:DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).DeleteData(4)
ClassMethod DeleteDataWP(rowId As %String) As %String
{
    q:rowId="" 0
	s sc=##Class(DHCNMG.Handbook.WorkPlan).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// w ##class(web.NurMgWorkPlan).GetValueWP("1")
ClassMethod GetValueWP(rowId As %String) As %String
{
	q:rowId="" ""
	s ret="",tmp=""
	s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(rowId)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Handbook.WorkPlan","a",p))  q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:p["DR"
	.q:p["Week"
	.s type=^oddCOM("DHCNMG.Handbook.WorkPlan","a",p,"P","XSDTYPE")
	.i ((type="date")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zd(tmp(p),3)
    .i ((type="time")&&(tmp(p)'=""))  d
    ..s tmp(p)=$zt(tmp(p),1)
    i tmp("WardDR")'=""  s tmp("WardDR")=obj.WardDR.%Id()
    ;s tmp("AddDate")=tmp("AddDate")_" "_$zt(tmp("AddTime"),1)
    ;s tmp("DepDr2")=$P(^CTLOC(tmp("DepDr")),"^",1)
    s k=""
    f{
	    s k=$O(tmp(k))
	    q:k=""
	    s ret=ret_k_"|"_tmp(k)_"^"
	 }
    s ret=ret_"WardDesc|"_obj.WardDR.WardDesc
    s ret=ret_"^StatusDesc|"_$Case(obj.Status,"N":"未提交","Y":"已提交","S":"已审核","B":"已驳回",:"")
	s ret=ret_"^RowId|"_rowId
	s advice=""	
    i obj.Status="S" d
    .s ret=ret_"^Advice|"_obj.CheckOpinion
    i obj.Status="B" d
    .s ret=ret_"^Advice|"_obj.RejectOpinion
    s quarterYear = $E(obj.Quarter,1,4)
    s quarter = $E(obj.Quarter,5,5)
    s ret=ret_"^QuarterDesc|"_quarterYear_"年第"_quarter_"季度"
    s ret=ret_"^WeekS|"_$p($zd(obj.Week,3),"-",1)_"年第"_($fn($zd(obj.Week,14)/7,"",0)+1)_"周"
    s ret=ret_"^WeekDesc|"_$zd(obj.Week,3)
    s ret=ret_"^Quarter|"_quarter
    s ret=ret_"^QuarterYear|"_quarterYear
	q ret
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:提交月工作计划
/// Table:DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).SubmitPlan(13,"Y")
ClassMethod SubmitDataWP(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.WorkPlan).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status=status
	i status="Y" d
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	e  d
	.s obj.SubmitDate=""
	.s obj.SubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:保存月工作计划
/// Table:DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).SavePlan("RowId|^year|55^annualPlan|555^TrainCrtUser|0^TraninCrtName|超级管理员^Status|N^RowId|^creater|^TrainContent|^")
ClassMethod SaveDataWP(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=""
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.WorkPlan).%New()
	. s obj.Status = "N"	
	i $g(tmp("RowId"))'="" d
	.s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(tmp("RowId"))
	s obj.WorkPlanType=$g(tmp("WorkPlanType"))
	i obj.WorkPlanType="M" d
	. s obj.Month=$g(tmp("Month"))
	e  s obj.Month=""
	i obj.WorkPlanType="W" d
	. s obj.Week=$zdh($g(tmp("Week")),3) 
	e  s obj.Week=""
	i obj.WorkPlanType="Q" d
	. s obj.Quarter=$g(tmp("Quarter"))
	e  s obj.Quarter=""
	s obj.Creater =$g(tmp("Creater")) 
	s obj.WorkPlan =$replace($tr($g(tmp("WorkPlan"))," ",""),$c(10),"")
	s obj.Completion =$replace($tr($g(tmp("Completion"))," ",""),$c(10),"") 
	s obj.Remarks =$replace($tr($g(tmp("Remarks"))," ",""),$c(10),"")
	i $g(tmp("WardDR"))'="" d 
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
    e  s obj.WardDR=""
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q $$$ISOK(sc)
}

/// Test:  d ##class(%ResultSet).RunQuery("web.NurMgWorkPlan","FindDataWP","^1^^Q","",0,0)
Query FindDataWP(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataWPExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s StatusI=$P(parr,"^",3)
	s workPlanTypeI = $P(parr,"^",4)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)	 	
	s workPlanType="" f  s workPlanType=$o(^DHCNMG.Handbook.WorkPlanI("WorkPlanTypeStatus",workPlanType)) q:workPlanType=""  d
	.q:(workPlanTypeI'="")&&(workPlanTypeI'=$replace(workPlanType," ","")) 	
	.s Status="" f  s Status=$O(^DHCNMG.Handbook.WorkPlanI("WorkPlanTypeStatus",workPlanType,Status)) q:Status=""  d	
	..q:(StatusI'="")&&(StatusI'=$replace(Status," ",""))
	..s id="" f  s id=$O(^DHCNMG.Handbook.WorkPlanI("WorkPlanTypeStatus",workPlanType,Status,id)) q:id=""  d
	...s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(id) 	
    ...q:(role<6)&&(obj.Status="N")&&(role'=0)
	...q:(ward'="")&&(obj.WardDR'="")&&(obj.WardDR.%Id()'=ward)	
	...q:(obj.WorkPlanType="M")&&(date'="")&&(date'=obj.Month)
	...q:(obj.WorkPlanType="W")&&(date'="")&&($zdh(date,3)'=obj.Week)
	...q:(obj.WorkPlanType="Q")&&($l(date)=5)&&(date'=obj.Quarter)		 
	...q:(obj.WorkPlanType="Q")&&($l(date)=4)&&(date'=$e(obj.Quarter,1,4))	
	...q:(obj.WorkPlanType="Q")&&($l(date)=1)&&(date'=$e(obj.Quarter,5,5))
	...q:(isAll=0)&&(('$IsObject(obj.WardDR))||('$d(tmpWard(obj.WardDR.%Id()))))
	...s ret=..GetValueWP(id)
	...d OutPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:审核或驳回月工作计划
/// Table:DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).ChangeStatus("18^S^哈哈^超级管理员","","")
ClassMethod ChangeStatusWP(parr, nurseid, role) As %String
{
	s id=$p(parr,"^",1)
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s operator=$p(parr,"^",4)
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Handbook.WorkPlan).%OpenId(id)
	q:'$IsObject(obj) ""
	i status="S" d
	.s obj.Status=status
	.s obj.CheckOpinion = reason
	.s obj.Checker = operator
	.s obj.CheckDate=+$h
	.s obj.CheckTime=$P($h,",",2)
	e  d
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	
	i status="B" d
	.s obj.Status=status
	.s obj.RejectOpinion = reason
	.s obj.Rejector = operator
	.s obj.RejectDate=+$h
	.s obj.RejectTime=$P($h,",",2)
	e  d
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lwz
/// Createdate:2019-08-23
/// 
/// Description:撤销月工作计划
/// Table:DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).CancelStatus(20)
ClassMethod CancelStatusWP(rowId) As %String
{
	q:rowId="" 0
	s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(rowId)
	q:'$IsObject(obj) 7
	
	q:obj.Status="N"||obj.Status="Y" 0
	
	i obj.Status="S" d
	.s obj.Status="Y"
	.s obj.CheckDate=""
	.s obj.CheckTime=""
	.s obj.Checker=""
	.s obj.CheckOpinion=""
	
	i obj.Status="B" d
	.s obj.Status="Y"
	.s obj.RejectDate=""
	.s obj.RejectTime=""
	.s obj.Rejector=""
	.s obj.RejectOpinion=""
		
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: lcy
/// Createdate: 2019-11-20
/// Description: 保存工作计划
/// Table: DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).SaveWorkPlan(20)
ClassMethod SaveWorkPlan(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("RowId"))="" d
	.s obj=##class(DHCNMG.Handbook.WorkPlan).%New()
	.i $g(tmp("Creater"))'="" d
	..s crtobj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("Creater"))
	..i $IsObject(crtobj) s obj.Creater=crtobj
	.e  s obj.Creater=""
	e  d
	.s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(tmp("RowId"))
	s obj.WorkPlanType=tmp("WorkPlanType")
	s obj.WorkPlanDate = $g(tmp("WorkPlanDate"))
	i $g(tmp("WardDR"))'="" d
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""	
	s obj.WorkPlan=$tr($g(tmp("WorkPlan")),$c(13,10),"")
	s obj.Completion=$tr($g(tmp("Completion")),$c(13,10),"")
	s obj.Remarks=$tr($g(tmp("Remarks")),$c(13,10),"")
	s obj.Status=$g(tmp("Status"))	
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q obj.%Id()
}

/// Creator: lcy
/// Createdate: 2019-11-20
/// Description: 删除工作计划
/// Table: DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).SaveWorkPlan(20)
ClassMethod DeleteWorkPlan(id As %String) As %String
{
	q:id="" "id为空"
	s sc=##Class(DHCNMG.Handbook.WorkPlan).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: lcy
/// Createdate: 2019-11-20
/// Description: 工作计划
/// Table: DHCNMG.Handbook.WorkPlan
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.NurMgWorkPlan).SaveWorkPlan(20)
ClassMethod GetWorkPlan(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(id)
	q:'$IsObject(obj)
	s ret="RowId|"_id
	// 工作计划类型
	s ret = ret_"^WorkPlanType|"_obj.WorkPlanType_"^WorkPlanTypeDesc|"_$case(obj.WorkPlanType,"W":"周工作计划","M":"月工作计划","Q":"季度工作计划","Y":"年工作计划",:"")
	// 工作计划日期
	i obj.WorkPlanType="W" d
	.s WorkPlanDate=obj.WorkPlanDate
	.s WorkPlanTitle=$p(obj.WorkPlanDate,"-",1)_"年第"_($fn($zd($zdh(obj.WorkPlanDate,3),14)/7,"",0)+1)_"周"
	i obj.WorkPlanType="M" s WorkPlanDate=$e(obj.WorkPlanDate,0,4)_"-"_$e($tr(obj.WorkPlanDate," ",""),6,7)_"-01",WorkPlanTitle = $e(obj.WorkPlanDate,0,4)_"年"_$e($tr(obj.WorkPlanDate," ",""),6,7)_"月"
	i obj.WorkPlanType="Y" s WorkPlanDate=$e(obj.WorkPlanDate,0,4),WorkPlanTitle=WorkPlanDate_"年"
	i obj.WorkPlanType="Q" s WorkPlanDate=$e(obj.WorkPlanDate,0,4),WorkPlanTitle=obj.WorkPlanDate,ret=ret_"^WorkPlanDateQ|"_$P(obj.WorkPlanDate,"-",2)
	;s WorkPlanDate=obj.WorkPlanDate,WorkPlanTitle=obj.WorkPlanDate,ret=ret_"^WorkPlanDateQ|"_obj.WorkPlanDate
	;s ret=ret_"^WorkPlanDate|"_obj.WorkPlanDate_"^WorkPlanDateQ|"_obj.WorkPlanDate
	s ret = ret_"^WorkPlanDate|"_WorkPlanDate_"^WorkPlanTitle|"_WorkPlanTitle
	
	// 创建人
	i obj.Creater'="" s ret=ret_"^Creater|"_obj.Creater.%Id(),ret=ret_"^CreaterName|"_obj.Creater.PerName
	e  s ret=ret_"^Creater|0^CreaterName|超级管理员"
	// 病区
	i obj.WardDR'="" s ret=ret_"^WardDR|"_obj.WardDR.%Id(),ret=ret_"^WardDRDesc|"_obj.WardDR.WardDesc
	e  s ret=ret_"^WardDR| ^WardDRDesc| "
	// 工作计划
	s ret = ret_"^WorkPlan|"_obj.WorkPlan
	// 完成情况
	s ret = ret_"^Completion|"_obj.Completion
	// 备注
	s ret = ret_"^Remarks|"_obj.Remarks
	// 状态
	s ret = ret_"^Status|"_obj.Status_"^StatusDesc|"_$case(obj.Status,"N":"已保存","Y":"已提交","S":"已审核","B":"已驳回",:"")
	// 创建日期
	i obj.CreatDate'="" s ret=ret_"^CreatDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CreatDate)
	i obj.CreatTime'="" s ret=ret_"^CreatTime|"_$zt(obj.CreatTime,1)
	// 提交日期
	i obj.SubmitDate'="" s ret=ret_"^SubmitDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubmitDate)
	i obj.SubmitTime'="" s ret=ret_"^SubmitTime|"_$zt(obj.SubmitTime,1)
	// 审核人
	s Checker="",CheckerName=""
	i obj.Status="S" d
	.i $IsObject(obj.Checker) s Checker=obj.Checker.%Id(),CheckerName=obj.Checker.PerName
	.e  s Checker=0,CheckerName="超级管理员"
	.s ret=ret_"^Checker|"_Checker,ret=ret_"^CheckerName|"_CheckerName
	.s ret = ret_"^CheckOpinion|"_obj.CheckOpinion
	.i obj.CheckDate'="" s ret=ret_"^CheckDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CheckDate)
	.i obj.CheckTime'="" s ret=ret_"^CheckTime|"_$zt(obj.CheckTime,1)	
	i obj.Status="B" d
	.i obj.Checker'="" s ret=ret_"^Rejector|"_obj.Rejector.%Id(),ret=ret_"^RejectorName|"_obj.Rejector.PerName
	.s ret = ret_"^CheckOpinion|"_obj.RejectOpinion
	.i obj.CheckDate'="" s ret=ret_"^CheckDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.RejectDate)
	.i obj.CheckTime'="" s ret=ret_"^CheckTime|"_$zt(obj.RejectTime,1)	
	q ret
}

/// Creator: LCY
/// Createdate: 20191120
/// Description: 获取所有的科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// Input：
/// Output: 所有科室年度工作计划
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindWorkPlan","N","")
Query FindWorkPlan(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkPlanExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	i type ="W" d	
	.i date'="" s newDate=$P(date,"-",1)_"-"_($fn($zd($zdh(date,3),14)/7,"",0)+1)
	i type="M" s newDate=date
	i type="Y" s newDate=date
	i type="Q" s newDate=date,newYear=$P(date,"-",1),newQ=$P(date,"-",2)
	//s:date["-" date=$zdh(date,3)
	s ward=$P(parr,"^",3)
	s status=$P(parr,"^",4)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s admdate="" f  s admdate=$O(^DHCNMG.Handbook.WorkPlanI("PlanDate",admdate)) q:admdate=""  d
	.s id="" f  s id = $O(^DHCNMG.Handbook.WorkPlanI("PlanDate",admdate,id)) q:id=""  d
	..q:id=""
	..s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(type'="")&&(obj.WorkPlanType'=type)
	..;q:(date'="")&&(obj.WorkPlanDate'=date)
	..q:(ward'="")&&($IsObject(obj.WardDR))&&(obj.WardDR.%Id()'=ward)
	..s workDate=obj.WorkPlanDate
	..i obj.WorkPlanType="W" s workDate=$P(obj.WorkPlanDate,"-",1)_"-"_($fn($zd($zdh(obj.WorkPlanDate,3),14)/7,"",0)+1)	
	..i obj.WorkPlanType="M" s workDate=$e(obj.WorkPlanDate,1,4)_"-"_$e($tr(obj.WorkPlanDate," ",""),6,7)_"-01"
	..i type="Q" s workDateYear=$P(obj.WorkPlanDate,"-",1)
	..q:(type="Q")&&(newQ'="")&&($p(workDate,"-",2)'=newQ)
	..q:(type="Q")&&(newYear'="")&&($p(workDate,"-",1)'=(newYear_"年"))
	..q:(type'="Q")&&(date'="")&&(workDate'=newDate)
	..q:(status'="")&&(obj.Status'=status)
	..s ret=..GetWorkPlan(id)
	..d OutWorkPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorkPlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWorkPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkPlanExecute ]
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

/// Creator: LCY
/// Createdate: 20190826
/// Description: 获取所有的科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// Input：
/// Output: 所有科室年度工作计划
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindWorkPlan","N","")
ClassMethod ChangeWorkPlanStatus(id As %String, status As %String, operator As %String, content As %String) As %String
{
	q:(id="")||(status="") 0
	s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(id)
	q:'$IsObject(obj) 7
	i status="Y" d
	.s obj.Status=status
	.s obj.SubmitDate=+$h
	.s obj.SubmitTime=$P($h,",",2)
	i status="S" d
	.s obj.Status=status
	.q:(operator="")
	.s obj.Checker=##class(DHCNMG.HR.MgPersons).%OpenId(operator)
	.s obj.CheckOpinion=content
	.s obj.CheckDate=+$H
	.s obj.CheckTime=$P($h,",",2)
	i status="B" d
	.s obj.Status=status
	.q:(operator="")
	.s obj.Rejector=##class(DHCNMG.HR.MgPersons).%OpenId(operator)
	.s obj.RejectOpinion=content
	.s obj.RejectDate=+$H
	.s obj.RejectTime=$P($h,",",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// Createdate: 20190826
/// Description: 获取所有的科室年度工作计划
/// Table: DHCNMG.Handbook.MgHNHDPWork
/// Input：
/// Output: 所有科室年度工作计划
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgCNMComm","FindWorkPlan","N","")
ClassMethod CancleWorkPlanStatus(id As %String) As %String
{
	q:(id="") 0
	s obj=##class(DHCNMG.Handbook.WorkPlan).%OpenId(id)
	q:'$IsObject(obj) 7	
	q:obj.Status="N" 0	
	i obj.Status = "Y" s obj.Status = "N"
	i obj.Status = "S" s obj.Status = "Y"
	i obj.Status = "B" s obj.Status = "Y"	
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

}

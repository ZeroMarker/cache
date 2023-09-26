/// Creator   : wk
/// CreatDate : 2018-07-24
/// Desc      : 任务组配置界面
Class web.DHCWL.V1.KPI.TaskGroupFunction Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-07-24
/// Desc      : 获取任务组信息
/// Other     : do ##Class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.TaskGroupFunction","GetTaskGroupQuery")
Query GetTaskGroupQuery() As websys.Query(ROWSPEC = "ID:%String:ID,groupCode:%String:任务组编码,groupDesc:%String:任务组描述,creator:%String:创建者") [ SqlProc ]
{
}

ClassMethod GetTaskGroupQueryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s sql="select ID,DTask_GroupCode,DTask_GroupDesc,DTask_GroupUser from DHCWL_MKPI.DHCWLConfigTaskGroup"
    s rs=##Class(%Library.ResultSet).%New()
    do rs.Prepare(sql)
    do rs.Execute()
    while(rs.Next()){
	    s ID=rs.Data("ID")
	    s code=rs.Data("DTask_GroupCode")
	    s desc=rs.Data("DTask_GroupDesc")
	    s creator=rs.Data("DTask_GroupUser")
	   	s ^CacheTemp(repid,ind)=$lb(ID,code,desc,creator)
		s ind=ind+1
    }
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-07-14
/// Desc       : 获取任务组下的指标
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.TaskGroupFunction","GetGroupDetailQuery",31)
Query GetGroupDetailQuery(groupID As %String, searchValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,kpiCode:%String:编码,kpiName:%String:描述,kpiDim:%String:维度") [ SqlProc ]
{
}

ClassMethod GetGroupDetailQueryExecute(ByRef qHandle As %Binary, groupID As %String, searchValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    q:groupID="" $$$OK
    s:searchValue'="" searchValue=$ZCVT(searchValue,"U")
    s sql="select a.ID,a.MKPI_Code,a.MKPI_Name from DHCWL_MKPI.DHCWLMKPI a,DHCWL_MKPI.DHCWLTaskGroupDetail b where a.MKPI_Code=b.DTask_KpiDr and b.DTask_GroupDr="_groupID_" order by a.ID"
    s rs=##Class(%Library.ResultSet).%New()
    d rs.Prepare(sql)
    d rs.Execute()
 	while(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("MKPI_Code")
		s desc=rs.Data("MKPI_Name")
 		s tempRes=""
		s tempDim="" 
		k kpiDimOrdered
		f {
			s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",ID,tempDim))
			q:($g(tempDim)="")||(tempDim=$c(0))
			continue:(+tempDim<=0) 
			s kpiDimId=""
			f {
				s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",ID,tempDim,kpiDimId))
				q:kpiDimId=""
				s dimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
				s:(dimOrder="")||(dimOrder=$c(0)) dimOrder=1
				s kpiDimOrdered(dimOrder)=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)   ;$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
			}	
		}
		s dimOrder=""
		f {
			s dimOrder=$o(kpiDimOrdered(dimOrder))
			q:dimOrder=""
			i tempRes="" s tempRes=kpiDimOrdered(dimOrder)
			e  s tempRes=tempRes_","_kpiDimOrdered(dimOrder)
		}
		s dim=$g(tempRes)
		s:(searchValue'="") searchValue=$zcvt(searchValue,"U")
		continue:(searchValue'="")&&((ID '[ searchValue)&&(($zcvt(code,"U"))'[searchValue)&&(($zcvt(desc,"U")) '[ searchValue)&&(($zcvt(dim,"U"))'[ searchValue))
		s ^CacheTemp(repid,ind)=$lb(ID,code,desc,dim)
		s ind=ind+1
 	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-07-26
/// Desc      : 新增任务组
/// Other     : do ##Class(web.DHCWL.V1.KPI.TaskGroupFunction).AddTaskGroup()
ClassMethod UpdateTaskGroup(id As %String = "", code As %String = "", desc As %String, user As %String, type As %String)
{
	if (type="add"){ 
		s sc=##class(web.DHCWL.KPI.TaskService).saveTaskGroup(code,desc,user)
		q:(sc="ok") "保存成功"
		q sc
	}elseif(type="edit"){
		s groupID=id
		s sc=##class(web.DHCWL.KPI.TaskService).modTaskGroup(desc,user,groupID)
		q:(sc="ok") "修改成功"
		q sc
	}
}

/// Creator   : wk
/// CreatDate : 2018-07-26
/// Desc      : 删除任务组
/// Other     : do ##Class(web.DHCWL.V1.KPI.TaskGroupFunction).DeleteGroup()
ClassMethod DeleteGroup(groupID As %String)
{
	s sc=##class(web.DHCWL.KPI.TaskService).DelTaskGroup(groupID)
	q:sc="ok" "删除成功"
	q sc
}

/// Creator   : wk
/// CreatDate : 2018-07-26
/// Desc      : 导出任务组信息
/// Other     : do ##Class(web.DHCWL.V1.KPI.TaskGroupFunction).ExportTaskGroup()
ClassMethod ExportTaskGroup(groupID)
{
	q:($g(groupID)="") "任务组获取失败"
	s taskSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiTaskSystemList(groupID)
	d ##class(DHCWL.MKPIIO.DefaultOutService).OutputTaskToStream(taskSysList,.outStream)
	Set sc =##class(%XML.TextReader).ParseStream(outStream,.reader)
	if (reader="") {
		w "导出错误!"
		q
	}
	d ##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToStr(reader)
	q ""
}

/// creator:   wk
/// creatDate: 2017-07-06
/// desc:      保存任务组明细
/// input:     kpis：保存的指标ID串
/// output:    sc:保存状态
/// other:     s sc=##class(web.DHCWL.V1.KPI.TaskGroupFunction).SaveTaskDetail("","")
ClassMethod SaveTaskDetail(kpis, groupID) As %String
{
	q:((kpis="")||(groupID="")) "指标和任务组不能为空"
	s len=$l(kpis,",")
	s date=+$h,flag=0
	for i=1:1:len {
		s kpi=$p(kpis,",",i)
		continue:kpi=""
		continue:('$d(^DHCWL.MKPI.MKPID(kpi)))
		s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpi),2)
		continue:kpiCode=""
		continue:($d(^DHCWL.MKPI.TaskGroupDetailI("kpiGroup"," "_groupID," "_kpi)))
		q:flag=1
		&sql(insert into DHCWL_MKPI.DHCWLTaskGroupDetail (DTask_GroupDr,DTask_KpiDr,DTask_DetailDate)values (:groupID,:kpiCode,:date))
		if (SQLCODE'=0){
			s flag=1
			q
		}
	}
	s ^||TEMPDHCWLKPIDATA("Login",$j,"fromDate")=$zd(+$h,3)
	s ^||TEMPDHCWLKPIDATA("Login",$j,"toDate")=$zd(+$h,3)
	s ^||TEMPDHCWLKPIDATA("Login",$j,"type")="KpiLogTaskErr"
	s ^||TEMPDHCWLKPIDATA("Login",$j,"CalledFunction")="在任务组"_groupID_"中新增"_kpis
	s loginService=##class(DHCWL.MKPILogin.LoginService).SetDataProcessLog()
	q:flag=0 "保存成功"
	q "保存错误!"
}

/// Creator    : wk
/// CreatDate  : 2018-08-02
/// Desc       : 移除已经配置的任务组明细
/// Other      : do ##Class(web.DHCWL.V1.KPI.TaskGroupFunction).DeleteTaskDetail()
ClassMethod DeleteTaskDetail(kpis, groupID)
{
	if ((kpis="")||(groupID="")){
		w "{success:true,tip:'删除信息为空,请刷新浏览器后重试'}"
		q
	}
	s len=$l(kpis,","),flag=0
	for i=1:1:len {
		s kpi=$p(kpis,",",i)
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpi,"DHCWL.MKPI.MKPI")
		continue:kpiCode=""
		&sql(delete from DHCWL_MKPI.DHCWLTaskGroupDetail where DTask_GroupDr=:groupID and DTask_KpiDr=:kpiCode)
		if (SQLCODE'=0){
			s flag=1
			q
		}
	}
	s ^||TEMPDHCWLKPIDATA("Login",$j,"fromDate")=$zd(+$h,3)
	s ^||TEMPDHCWLKPIDATA("Login",$j,"toDate")=$zd(+$h,3)
	s ^||TEMPDHCWLKPIDATA("Login",$j,"type")="KpiLogTaskErr"
	s ^||TEMPDHCWLKPIDATA("Login",$j,"CalledFunction")="在任务组"_groupID_"中将"_kpis_"移除"
	s loginService=##class(DHCWL.MKPILogin.LoginService).SetDataProcessLog()
	d loginService.LoginEnd()
	d ##class(DHCWL.MKPILogin.LoginService).StopLogRobot()
	s sc="删除失败"
	q:flag=1 sc
	q:flag=0 "删除成功"
	q
}

}

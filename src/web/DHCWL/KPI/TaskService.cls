Class web.DHCWL.KPI.TaskService Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod AutoCreateTask(kpiId, section, ByRef secExc) As %String
{
	n (kpiId,section,secExc)
	q:section="" "请选择区间！"
	s sc=0
	f i=1:1:$l(section,",") d
	.s sec=$p(section,",",i)
	.i ..GetTaskId(kpiId,sec)'="" d
	..;s sc=sc+1
	..q
	.s secId=$o(^DHCWL.MKPI.SectionI("SecCode",sec,""))
	.s task=##class(DHCWL.MKPI.CreatDataTask).%New()
	.s task.DTaskKPIDR=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
	.s task.DTaskSectionDR=##class(DHCWL.MKPI.Section).%OpenId(secId)
	.s task.DTaskExcuteCode=secExc(sec)
	.//	global task variable assert, Added by JEFF @2014-02-26
	.s taskStatus=##class(DHCWL.SysService.SysVarService).GetTaskInitStatus()
	.s taskStatus=$case(taskStatus,"Y":"Y","N":"N",:"N")
	.s task.DTaskActiveFlag=taskStatus
	.s sc=task.%Save()
	.s sc=sc+1
	q "ok"
	;e  q "自动生成任务失败"
}

ClassMethod AddTask(ByRef taskD) As %String
{
	n (taskD)
	s kpi=$g(taskD("DTaskKPIDR"))
	s secCode=$g(taskD("DTaskMonthExcuteCode"))
	q:(kpi="")||(secCode="") "指标或区间不能为空！"
	s kpi=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi,"DHCWL.MKPI.MKPI")  ;##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpi)
	s taskExc=$g(taskD("DTaskExcuteCode"))
	s act=$g(taskD("DTaskActiveFlag"))
	//	global task variable assert, Added by JEFF @2014-02-26
	i (""=act) {
		s act=##class(DHCWL.SysService.SysVarService).GetTaskInitStatus()
		s act=$case(taskStatus,"Y":"Y","N":"N",:"N")
	}
	s secId=$g(taskD("DTaskSectionDR"))
	s taskId=..GetTaskId(kpi,secCode)
	;w "act="_act_" secCode="_secCode,!
	i +taskId=0 {   ;新增任务
		s taskObj=##class(DHCWL.MKPI.CreatDataTask).%New()
		s:act'="" taskObj.DTaskActiveFlag=act
		s:kpi'="" taskObj.DTaskKPIDR=##class(DHCWL.MKPI.MKPI).%OpenId(kpi)
		s:secId'="" taskObj.DTaskSectionDR=##class(DHCWL.MKPI.Section).%OpenId(secId)
		s:secCode'="" taskObj.DTaskMonthExcuteCode=secCode
		s:taskExc'="" taskObj.DTaskExcuteCode=taskExc
	}else{          ;更新任务
		s taskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId)
		s:act'="" taskObj.DTaskActiveFlag=act
		s:kpi'="" taskObj.DTaskKPIDR=##class(DHCWL.MKPI.MKPI).%OpenId(kpi)
		s:secId'="" taskObj.DTaskSectionDR=##class(DHCWL.MKPI.Section).%OpenId(secId)
		s:secCode'="" taskObj.DTaskMonthExcuteCode=secCode
		s:taskExc'="" taskObj.DTaskExcuteCode=taskExc
	}
	s sc=taskObj.%Save()
	i sc=1 q "ok"
	q "更新出错！"_sc
}

ClassMethod UpdateCreateTask(ByRef task) As %String
{
	n (task)
	s id=$g(task("id"))
	s kpiId=$g(task("kpiId"))
	if ($g(id)'="") {
		s sec=$g(task("section"))
		s active=$g(task("active")),taskSecExc=$g(task("taskSecExc"))
		s flag=1
		q:(id="")&&(kpiId="")&&(sec="") "请选择好指标和区间！"
		i id="" {
			s id=..GetTaskId(kpiId,sec)
		}
		q:+id=0 "任务区间不合法！"
		s taskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(id)
		q:taskObj="" "不存在该指标任务"
		s taskObj.DTaskActiveFlag=active
		s taskObj.DTaskExcuteCode=taskSecExc
		s sc=taskObj.%Save()
		i sc=0 q "任务保存失败！"
	}
	if ($g(kpiId)'=""){
		s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
		;s:$g(task("kpiExc"))'="" kpi.MKPIEXCode=$g(task("kpiExc"))
		s kpi.MKPIEXCode=$g(task("kpiExc"))
		s dimId=kpi.MKPITypeDr
		s sc=kpi.%Save()
		i sc=0 q "指标执行代码保存失败！"
		i dimId'="" {;q "指标纬度未定义，要设置纬度代码请先定义纬度！"
			;s dim=##class(DHCWL.MKPI.MKPIDimType).%OpenId(dimId),sc=1
			;if dim'="" d
			;s:$g(task("dimExc"))'="" dimId.KDTEXCode=$g(task("dimExc"))
			s dimId.KDTEXCode=$g(task("dimExc"))
			s sc=dimId.%Save()
			i sc=0 q "纬度执行代码保存失败！"
		}
	}
	q "ok"
}

ClassMethod DeleteTask(kpi, sec) As %String
{
	n (kpi,sec)
	q:($g(kpi)="")||($g(sec)="") "请选择一个指标后再操作"
	&sql(delete from DHCWL_MKPI.DHCWLCreatDataTask where DTask_KPI_DR=:kpi and DTask_Section_DR=:sec)
	q "ok"
}

/// s sc=##class(web.DHCWL.KPI.TaskService).GetKpiTaskList("EPRMRDepUn60Nums",.list)
ClassMethod GetKpiTaskList(kpiCode, ByRef taskList) As %String
{
	n (kpiCode,taskList)
	s kpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIByName(kpiCode)
	if ""=kpiId q "none"
	s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
	i ""=kpi q "none"
	k taskList
	;b ;00
	s taskAct=""  f  s taskAct=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,taskAct)) q:taskAct=""  d
	.s taskId="" f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,taskAct,taskId)) q:taskId=""  d
	..s taskSecId=$list(^DHCWL.MKPI.CreatDataTaskD(taskId),5)
	..i +taskSecId'=0 d
	...s taskSec=$list(^DHCWL.MKPI.SectionD(taskSecId),2)
	...s sectionName=$list(^DHCWL.MKPI.SectionD(taskSecId),4)
	...i taskAct [ "Y" s taskAct2="Y"  
	...e  s taskAct2="N"
	...;w "sec="_taskSec,!
	...s taskList("TSecId",taskSecId)=taskSecId,taskList("TSecCode",taskSecId)=taskSec
	q "ok"
}

/// s sc=##class(web.DHCWL.KPI.TaskService).DeleteTaskRefSection("EPRMRDepUn60Nums")
ClassMethod DeleteTaskRefSection(kpiCode) As %String
{
	n (kpiCode)
	s sc=..GetKpiTaskList(kpiCode,.taskList)
	if sc'="ok" q sc
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")  ;##class(DHCWL.MKPIService.ConfigService).GetKPIByName(kpiCode)
	d ##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.sec)
	s lev="",flag=0,deletSec=""
	f  {
		s lev=$o(sec(lev)) 
		q:(lev="")||(flag=1)
		s secId="" 
		f  {
			s secId=$o(sec(lev,secId)) 
			q:secId="" 
			i flag=1 q
			i ($d(taskList("TSecId",secId)))&&(secId=$g(taskList("TSecId",secId))) {
				s flag=1
				s deletSec=secId
				q
			}
		}
	}
	if deletSec'="" {
		&sql(delete from DHCWL_MKPI.DHCWLCreatDataTask where DTask_KPI_DR=:kpiId and DTask_Section_DR=:deletSec)
		i SQLCODE'=0 q "任务区间"_$g(taskList("TSecCode",deletSec))_"删除失败！"_SQLCODE
		e  q "ok@"_$g(taskList("TSecCode",deletSec))
	}
	q "ok"
}

ClassMethod GetTaskId(kpiId, sec) As %String
{
	n (kpiId,sec)
	q:($g(kpiId)="")||($g(sec)="") ""
	s secId=$o(^DHCWL.MKPI.SectionI("SecCode",sec,""))
	i '$d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId)) q ""
	i '$d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId)) q ""
	s active=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId,""))
	i '$d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId,active)) q ""
	s id=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId,active,""))
	q id
}

ClassMethod GetTaskExc(kpiId, sec) As %String
{
	n (kpiId,sec)
	s id=..GetTaskId(kpiId,sec)
	i id="" q ""
	s exc=$list(^DHCWL.MKPI.CreatDataTaskD(id),3)
	q exc
}

ClassMethod ActiveTask(kpiId) As %String
{
	n (kpiId)
	q:kpiId="" "请选择指标后再操作！"
	i '$d(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId)) q "当前没有生产任务，请先生产任务再激活！"
	&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ActiveFlag='Y' where DTask_KPI_DR=:kpiId)
	q "ok"
}

/// creator:    wk
/// creatDate:  2017-07-05
/// desc:       保存任务组
/// input:      code:任务组编码，desc：任务组描述
/// output:     sc:保存状态
/// other:      s sc=##class(web.DHCWL.KPI.TaskService).saveTaskGroup("","")
ClassMethod saveTaskGroup(code, desc, user) As %String
{
	n (code,desc,user)
	q:(code="")||(desc="") "编码和描述不能为空"
	q:($d(^DHCWL.MKPI.ConfigTaskGroupI("Code"," "_$ZCVT(code,"U")))) "编码不能重复！"
	s date=+$h,sc="增加失败"
	&sql(insert into DHCWL_MKPI.DHCWLConfigTaskGroup (DTask_GroupCode,DTask_GroupDesc,DTask_GroupDate,DTask_GroupUser) values (:code,:desc,:date,:user))
	s:SQLCODE=0 sc="ok"
	q sc
}

/// creator:    wk
/// creatDate:  2017-07-10
/// desc:       修改任务组
/// input:      desc：任务组描述，user:任务组创建人
/// output:     sc:修改状态
/// other:      s sc=##class(web.DHCWL.KPI.TaskService).modTaskGroup("","")
ClassMethod modTaskGroup(desc, user, groupID) As %String
{
	n (desc,user,groupID)
	q:(desc="") "描述不能为空"
	q:('$d(^DHCWL.MKPI.ConfigTaskGroupD(groupID))) "未找到任务组"
	s date=+$h,sc="修改失败"
	&sql(update DHCWL_MKPI.DHCWLConfigTaskGroup set DTask_GroupDesc=:desc ,DTask_GroupDate=:date,DTask_GroupUser=:user where ID=:groupID)
	s:SQLCODE=0 sc="ok"
	q sc
}

/// creator:    wk
/// creatDate:  2017-07-10
/// desc:       删除任务组
/// input:      desc：任务组描述，user:任务组创建人
/// output:     sc:删除状态
/// other:      s sc=##class(web.DHCWL.KPI.TaskService).delTaskGroup("","")
ClassMethod DelTaskGroup(groupID) As %String
{
	n (groupID)
	q:('$d(^DHCWL.MKPI.ConfigTaskGroupD(groupID))) "未找到任务组"
	q:($d(^DHCWL.MKPI.TaskGroupDetailI("kpiGroup",groupID))) "请删除当前任务组下的明细"
	&sql(delete from DHCWL_MKPI.DHCWLConfigTaskGroup where ID=:groupID)
	s:SQLCODE=0 sc="ok"
	q sc
}

/// creator:   wk
/// creatDate: 2017-07-06
/// desc:      保存任务组明细
/// input:     kpis：保存的指标ID串
/// output:    sc:保存状态
/// other:     s sc=##class(web.DHCWL.KPI.TaskService).saveTaskDetail("","")
ClassMethod SaveTaskDetail(kpis, groupID) As %String
{
	n (kpis,groupID)
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
	q:flag=0 "ok"
	q "保存错误!"
}

/// creator:   wk
/// creatDate: 2017-08-03
/// desc:      导入任务组信息
/// input:     tempFile：文件路径    groupInfor：任务组信息
/// output:    导入状态
/// other:     d ##class(web.DHCWL.KPI.TaskService).InputTaskDetail("","")
ClassMethod InputTaskDetail(tempFile, grpInfor)
{
	n (tempFile,grpInfor)
	q:((tempFile="")) "指标文件和任务组不能为空"
	k ^TEMPDHCWL("REALINPUT",$j)
	if (grpInfor'=""){
		for i=$l(grpInfor,","):-1:1 {
			s grp=$p(grpInfor,",",i)
			continue:grp=""
			s ^TEMPDHCWL("REALINPUT",$j,grp)=grp
		}
	}
	s sc=##class(DHCWL.MKPIIO.DefaultInService).InputXML(tempFile)
	k ^TEMPDHCWL("REALINPUT",$j)
	i +sc=1 {
		w "任务组导入成功！" 
	}else{
		w "任务组导入失败"
	}
	q
}

}

///   指标系统标准接口：指标任务接口
Class DHCWL.Interface.MkpiTask Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator：    wk~2016-12-19
/// Description: 将指标任务设置为用户输入的状态，只能是'N'或者'Y'
/// Return:      返回执行状态 
/// Other:       d ##class(DHCWL.Interface.MkpiTask).ActKpiTaskByKpi("K0001,K0002,K0003","Y")
ClassMethod ActKpiTaskByKpi(kpis, status)
{
		n (kpis,status)
		q:(kpis="") "指标不能为空"
		if ((status'="N")&&(status'="Y")){
			q "激活状态只能是'Y'或者'N'"
		}
		s errorFlag=0
		s kpis=##class(DHCWL.Interface.MkpiData).ToKpiId(kpis,",")
		s kpiLen=$l(kpis,",")
		for i=1:1:kpiLen{
			s kpi=$p(kpis,",",i)
			&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ActiveFlag=:status where DTask_KPI_DR=:kpi)
			i SQLCODE'=0{
				w "更新错误,请检查后更新"
				s errorFlag=1
				q
			} 
		}
		if (errorFlag=0){
			w "更新成功！"
		}
}

}

/// Creator   : wk
/// CreatDate : 2018-09-29
/// Desc      : 标准值指标维护
Class web.DHCWL.V1.CheckFun.KPICfg Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-09-29
/// Desc      : 获取考核指标表格信息
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.KPICfg","GetKPI")
Query GetKPI(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,isValid:%String:是否有效,date:%String:更新日期") [ SqlProc ]
{
}

ClassMethod GetKPIExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
	s sql="select ID,CheckKPI_Code,CheckKPI_Desc,CheckKPI_Flag,CheckKPI_UpdateDate,CheckKPI_UpdateUser from DHCWL_CheckFun.DHCWLCheckKPI order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("CheckKPI_Code")
		s desc=rs.Data("CheckKPI_Desc")
		s flag=rs.Data("CheckKPI_Flag")
		s flagDesc=$Case(flag,"Y":"是","N":"否",:"")
		s updateDate=rs.Data("CheckKPI_UpdateDate")
		i updateDate'="" s updateDate=##class(websys.Conversions).DateLogicalToHtml(updateDate)
		continue:((filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(flagDesc,"U") '[ filterValue)&&($zcvt(updateDate,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,code,desc,flagDesc,updateDate)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-09-29
/// Desc       : 考核指标新增
/// Other      : do ##class(web.DHCWL.V1.CheckFun.KPICfg).AddCheckFunKpi()
ClassMethod AddCheckFunKpi(code, desc, isValid)
{
	s dim("KpiCode")=code
	s dim("KpiDesc")=desc
	s dim("KpiFlag")=isValid
	s dim("KpiUpdateUser")=$g(%session.Data("LOGON.USERNAME"))
	s tip=##class(DHCWL.CheckFunData.SaveData).AddCheckFunKpi(.dim)
	q:(tip="ok") "更新成功"
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-09-29
/// Desc       : 考核指标更新
/// Other      : do ##class(web.DHCWL.V1.CheckFun.KPICfg).UpdateCheckFunKpi()
ClassMethod UpdateCheckFunKpi(ID, code, desc, isValid)
{
	s dim("ID")=ID
	
	s originalFlag=$lg(^DHCWL.CheckFun.CheckKPID(ID),4)
	if ((originalFlag="Y")&&(isValid="否")&&($d(^DHCWL.CheckFun.SetKpiReI("Kpi",ID)))){
		q "当前指标已被使用,无法改为无效"
	}
	
	s dim("KpiCode")=code
	s dim("KpiDesc")=desc
	s dim("KpiFlag")=isValid
	s dim("KpiUpdateUser")=$g(%session.Data("LOGON.USERNAME"))
	s tip=##class(DHCWL.CheckFunData.SaveData).UpdateCheckFunKpi(.dim)
	q:(tip="ok") "更新成功"
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-09-29
/// Desc       : 考核指标删除
/// Other      : do ##class(web.DHCWL.V1.CheckFun.KPICfg).DeleteCheckFunKpi()
ClassMethod DeleteCheckFunKpi(ID)
{
	s dim("ID")=ID
	s tip=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunKpi(.dim)
	q:tip="ok" "删除成功"
	q tip
}

}

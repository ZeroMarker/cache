Class DHCWL.RptMgmt.RptCfg Extends %Persistent
{

/// 菜单名称
Property MenuName As %String(COLLATION = "EXACT");

/// raq名称
Property RaqName As %String(COLLATION = "EXACT", MAXLEN = 150);

/// CSP名称
Property CSPName As %String(COLLATION = "EXACT", MAXLEN = 150);

/// 主程序query
Property QueryName As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 统计口径
Property Spec As %String(COLLATION = "EXACT", MAXLEN = 250);

/// 业务表
Property HisTableName As %String(COLLATION = "EXACT", MAXLEN = 250);

/// 指标
Property KPIName As %String(COLLATION = "EXACT", MAXLEN = 500);

/// 数据条件
Property Filter As %String(COLLATION = "EXACT", MAXLEN = 250);

/// 显示条件
Property RowColShow As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 逻辑说明
Property ProgramLogic As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 高级客户
Property AdvUser As %String(COLLATION = "EXACT");

/// 项目工程师
Property ProMaintainer As %String(COLLATION = "EXACT");

/// 开发工程师
Property DepMaintainer As %String(COLLATION = "EXACT");

/// 备注
Property Demo As %String(COLLATION = "EXACT", MAXLEN = 2048);

/// 日期
Property CreateDate As %Date;

/// 最后更新日期
Property UPdateDate As %Date;

/// 页面或标题名称
Property AuxiliaryMenuName As %String(COLLATION = "EXACT");

/// 使用科室
Property UsedByDep As %String(COLLATION = "EXACT", MAXLEN = 200);

Property RaqCSPTitleName As %String(COLLATION = "EXACT", MAXLEN = 250);

/// 单元格-统计子组对应关系
Property CellSubgrpMap As %String(COLLATION = "EXACT", MAXLEN = 200);

Index InxRaqCspTitle On RaqCSPTitleName [ Unique ];

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	
	if $d(^DHCWL.RptMgmt.RptCfgI("InxRaqCspTitle",inParam("RaqName")_"|"_inParam("CSPName")_"|"_inParam("AuxiliaryMenuName"))) {
		s ret="录入的当前页面(标题)名称，raq名称，CSP名称已存在！"
		q ret
	}

	s newObj=##class(DHCWL.RptMgmt.RptCfg).%New()
	s newObj.MenuName=inParam("MenuName")
	s newObj.RaqName=inParam("RaqName")
	s newObj.CSPName=inParam("CSPName")
	s newObj.RaqCSPTitleName=newObj.RaqName_"|"_newObj.CSPName_"|"_inParam("AuxiliaryMenuName")
	s newObj.QueryName=inParam("QueryName")
	s newObj.Spec=inParam("Spec")
	s newObj.HisTableName=inParam("HisTableName")
	s newObj.KPIName=inParam("KPIName")
	s newObj.Filter=inParam("Filter")
	s newObj.RowColShow=inParam("RowColShow")
	s newObj.ProgramLogic=inParam("ProgramLogic")	
	s newObj.AdvUser=inParam("AdvUser")
	s newObj.ProMaintainer=inParam("ProMaintainer")	
	s newObj.DepMaintainer=inParam("DepMaintainer")
	s demo=inParam("Demo")
	s demo=$TR(demo,"""","\")
	s newObj.Demo=demo
	s newObj.CreateDate=+$h
	//w !,"CreateDate="_inParam("CreateDate")
	//w !,"number="_##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(inParam("CreateDate"))
	//w !,##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(inParam("CreateDate"))
	//q "test"
	//w !,newObj.CreateDate
	//w !,##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(inParam("CreateDate"))
	if $g(inParam("CreateDate"))'="" s newObj.CreateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(inParam("CreateDate"))	//导入时，导入创建日期
	if $g(inParam("UPdateDate"))'="" s newObj.UPdateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(inParam("UPdateDate"))
	s newObj.AuxiliaryMenuName=inParam("AuxiliaryMenuName")
	s newObj.UsedByDep=$g(inParam("UsedByDep"))
	s newObj.CellSubgrpMap=$g(inParam("CellSubgrpMap"))
	//
	//w !,newObj.CreateDate
	//q "test"
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="Insert DHCWL.RptMgmt.RptCfg 对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("RptID")=newObj.%Id() 
	d newObj.%Close()

	q ret
	
SQLErr
	if ret="" s ret="Insert DHCWL.RptMgmt.RptCfg 对象失败:未知错误!"
	q ret
}

ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s id=inParam("ID")
	s rptObj=##class(DHCWL.RptMgmt.RptCfg).%OpenId(id)
	if $ISOBJECT(rptObj)=0 {
		s ret="open DHCWL.RptMgmt.RptCfg fail"
		q ret	
	}
	s hisObj=##class(DHCWL.RptMgmt.HistoryRptCfg).%New()
	if $ISOBJECT(hisObj)=0 {
		s ret="open DHCWL.RptMgmt.HistoryRptCfg fail"
		q ret	
	}	//1、把数据复制到HistoryRptCfg表中
	s hisObj.MenuName=rptObj.MenuName
	s hisObj.RaqName=rptObj.RaqName
	s hisObj.CSPName=rptObj.CSPName
	s hisObj.RaqCSPTitleName=rptObj.RaqCSPTitleName
	s hisObj.QueryName=rptObj.QueryName
	s hisObj.Spec=rptObj.Spec
	s hisObj.HisTableName=rptObj.HisTableName
	s hisObj.KPIName=rptObj.KPIName
	s hisObj.Filter=rptObj.Filter
	s hisObj.RowColShow=rptObj.RowColShow
	s hisObj.ProgramLogic=rptObj.ProgramLogic
	s hisObj.AdvUser=rptObj.AdvUser
	s hisObj.ProMaintainer=rptObj.ProMaintainer
	s hisObj.DepMaintainer=rptObj.DepMaintainer
	//s hisObj.Demo=rptObj.Demo
	
	s demo=rptObj.Demo
	s demo=$TR(demo,"""","\")
	s hisObj.Demo=demo	
	
	s hisObj.CreateDate=rptObj.CreateDate
	s hisObj.UPdateDate=+$h
	s hisObj.AuxiliaryMenuName=rptObj.AuxiliaryMenuName
	s hisObj.UsedByDep=rptObj.UsedByDep
	s hisObj.HistoryID=id
	s sc=hisObj.%Save()
	If $$$ISERR(sc) {
		s ret="复制到 DHCWL.RptMgmt.HistoryRptCfg 对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}	
 	d hisObj.%Close()
	
	//2、把页面数据更新到ReportCfg表中
	s rptObj.MenuName=inParam("MenuName")
	s rptObj.RaqName=inParam("RaqName")
	s rptObj.CSPName=inParam("CSPName")
	s rptObj.RaqCSPTitleName=rptObj.RaqName_"|"_rptObj.CSPName_"|"_rptObj.AuxiliaryMenuName
	s rptObj.QueryName=inParam("QueryName")
	s rptObj.Spec=inParam("Spec")
	s rptObj.HisTableName=inParam("HisTableName")
	s rptObj.KPIName=inParam("KPIName")
	s rptObj.Filter=inParam("Filter")
	s rptObj.RowColShow=inParam("RowColShow")
	s rptObj.ProgramLogic=inParam("ProgramLogic")	
	s rptObj.AdvUser=inParam("AdvUser")
	s rptObj.ProMaintainer=inParam("ProMaintainer")	
	s rptObj.DepMaintainer=inParam("DepMaintainer")
	//s rptObj.Demo=inParam("Demo")	
	s demo=inParam("Demo")
	s demo=$TR(demo,"""","\")
	s rptObj.Demo=demo	
	
	s rptObj.UPdateDate=+$h
	if $g(inParam("UPdateDate"))'="" {
		//w inParam("UPdateDate")
		if $ISVALIDNUM(inParam("UPdateDate"))'=1 {
			if $g(inParam("UPdateDate"))'="" s rptObj.UPdateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(inParam("UPdateDate"))
		}
	}
	s rptObj.AuxiliaryMenuName=inParam("AuxiliaryMenuName")
	s rptObj.UsedByDep=inParam("UsedByDep")
	s rptObj.CellSubgrpMap=$g(inParam("CellSubgrpMap"))
	s sc=rptObj.%Save()
	If $$$ISERR(sc) {
		s ret="update DHCWL.RptMgmt.RptCfg 对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("RptID")=rptObj.%Id() 
	d rptObj.%Close()

	q ret
	
SQLErr
	if ret="" s ret="update DHCWL.RptMgmt.RptCfg 对象失败:未知错误!"
	q ret
}

ClassMethod CheckRepeat(ByRef inParam, ByRef outParam) As %String
{
	 s ret=""
	 s inputData=""
	 f {
		 s inputData=$o(inParam(inputData))
		 q:$g(inputData)=""
		 
		 s RaqName=$p(inputData,"^",1)
		 s CSPName=$p(inputData,"^",2)
		 s AuxiliaryMenuName=$p(inputData,"^",3)
		 //w !,$g(RaqName)_"|"_$g(CSPName)
		 if $d(^DHCWL.RptMgmt.RptCfgI("InxRaqCspTitle",$g(RaqName)_"|"_$g(CSPName)_"|"_$g(AuxiliaryMenuName))) {
			 s outParam(inputData)=""
		 }
		 
	 }
	 
	 q ret
}

Storage Default
{
<Data name="RptCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuName</Value>
</Value>
<Value name="3">
<Value>RaqName</Value>
</Value>
<Value name="4">
<Value>CSPName</Value>
</Value>
<Value name="5">
<Value>QueryName</Value>
</Value>
<Value name="6">
<Value>Spec</Value>
</Value>
<Value name="7">
<Value>HisTableName</Value>
</Value>
<Value name="8">
<Value>KPIName</Value>
</Value>
<Value name="9">
<Value>Filter</Value>
</Value>
<Value name="10">
<Value>RowColShow</Value>
</Value>
<Value name="11">
<Value>ProgramLogic</Value>
</Value>
<Value name="12">
<Value>AdvUser</Value>
</Value>
<Value name="13">
<Value>ProMaintainer</Value>
</Value>
<Value name="14">
<Value>DepMaintainer</Value>
</Value>
<Value name="15">
<Value>Demo</Value>
</Value>
<Value name="16">
<Value>CreateDate</Value>
</Value>
<Value name="17">
<Value>UPdateDate</Value>
</Value>
<Value name="18">
<Value>AuxiliaryMenuName</Value>
</Value>
<Value name="19">
<Value>UsedByDep</Value>
</Value>
<Value name="20">
<Value>RaqCSPName</Value>
</Value>
<Value name="21">
<Value>RaqCSPTitleName</Value>
</Value>
<Value name="22">
<Value>CellSubgrpMap</Value>
</Value>
</Data>
<DataLocation>^DHCWL.RptMgmt.RptCfgD</DataLocation>
<DefaultData>RptCfgDefaultData</DefaultData>
<IdLocation>^DHCWL.RptMgmt.RptCfgD</IdLocation>
<IndexLocation>^DHCWL.RptMgmt.RptCfgI</IndexLocation>
<StreamLocation>^DHCWL.RptMgmt.RptCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

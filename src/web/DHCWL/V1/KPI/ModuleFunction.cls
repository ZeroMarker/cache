///  Creator   : wk
///  CreatDate : 2018-05-25
///  Desc      : 模块与报表维护
Class web.DHCWL.V1.KPI.ModuleFunction Extends %RegisteredObject
{

/// Creator    : wk
/// CreatDate  : 2018-04-19
/// Desc       : 模块树
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.ModuleFunction","GetModuleTreeQuery","")
Query GetModuleTreeQuery(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,name:%String:描述,code:%String:编码,state:%String:是否展开,checked:%String:是否选中,_parentId:%String:父节点") [ SqlProc ]
{
}

ClassMethod GetModuleTreeQueryExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
 	
 	if (filterValue=""){
		s ^CacheTemp(repid,ind)=$lb("root","模块管理树","root","open",,"")
		s ind=ind+1
	 	
	 	k ^||TEMPDHCWL($j,"KPI","Module")
	 	do ##Class(web.DHCWL.V1.KPI.ModuleFunction).getModuleGlobal("root")
	 	s parentNode=""
	 	for {
		 	s parentNode=$o(^||TEMPDHCWL($j,"KPI","Module",parentNode))
		 	q:parentNode=""
		 	s code=""
		 	for {
			 	s code=$o(^||TEMPDHCWL($j,"KPI","Module",parentNode,code))
			 	q:code=""
			 	s desc=$o(^||TEMPDHCWL($j,"KPI","Module",parentNode,code,""))
			 	s treeCode=^||TEMPDHCWL($j,"KPI","Module",parentNode,code,desc)
			 	s state="open"
			 	s:($d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgPTreeCodeIndex",treeCode))) state="closed"
			 	/*if (parentNode="root"){
		 			s ^CacheTemp(repid,ind)=$lb(treeCode,desc,code,state,,"")
			 	}else{
				 	s ^CacheTemp(repid,ind)=$lb(treeCode,desc,code,state,,parentNode)
			 	}*/
			 	s ^CacheTemp(repid,ind)=$lb(treeCode,desc,code,state,,parentNode)
				s ind=ind+1
		 	}
	 	}
 	}else{
	 	s ^CacheTemp(repid,ind)=$lb("root","模块管理树","root","open",,"")
		s ind=ind+1
	 	
	 	k moduleNodeList
 		s modID = ""
 		for {
 			s modID=$o(^DHCWL.MKPI.MMgrModuleCfgD(modID))
 			q:modID=""
 			s modCode=$lg(^DHCWL.MKPI.MMgrModuleCfgD(modID),2)
 			s modDesc=$lg(^DHCWL.MKPI.MMgrModuleCfgD(modID),3)
 			continue:(($zcvt(modCode,"U") '[ filterValue)&&($zcvt(modDesc,"U") '[ filterValue))
 			s treeCode=$lg(^DHCWL.MKPI.MMgrModuleCfgD(modID),4)
 			do ##class(web.DHCWL.V1.KPI.ModuleFunction).GetAllParentNode(treeCode,.moduleNodeList)
 		}
 		s index=""
 		for {
	 		s index=$o(moduleNodeList(index))
	 		q:index=""
	 		s treeCode=""
	 		for {
	 			s treeCode=$o(moduleNodeList(index,treeCode))
	 			q:treeCode=""
	 			continue:treeCode="root"
	 			s modID=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode,""))
	 			s modCode=$lg(^DHCWL.MKPI.MMgrModuleCfgD(modID),2)
 				s modDesc=$lg(^DHCWL.MKPI.MMgrModuleCfgD(modID),3)
 				s ptreeCode=$lg(^DHCWL.MKPI.MMgrModuleCfgD(modID),5)
 				s state="open"
			 	s ^CacheTemp(repid,ind)=$lb(treeCode,modDesc,modCode,state,,ptreeCode)
				s ind=ind+1
	 		}
 		}
 		
 	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-05-25
/// Desc       : 递归函数用于获取模块数据
/// Other      : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).getModuleGlobal("root")
ClassMethod getModuleGlobal(parentNode)
{
	q:parentNode=""
	q:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgPTreeCodeIndex",parentNode)))
	s moduleID=""
	for {
		s moduleID=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgPTreeCodeIndex",parentNode,moduleID))
		q:moduleID=""
		s code=$lg(^DHCWL.MKPI.MMgrModuleCfgD(moduleID),2)
		s desc=$lg(^DHCWL.MKPI.MMgrModuleCfgD(moduleID),3)
		s treeCode=$lg(^DHCWL.MKPI.MMgrModuleCfgD(moduleID),4)
		s parentCode=$lg(^DHCWL.MKPI.MMgrModuleCfgD(moduleID),5)
		s ^||TEMPDHCWL($j,"KPI","Module",parentCode,code,desc)=treeCode
		do ##Class(web.DHCWL.V1.KPI.ModuleFunction).getModuleGlobal(treeCode)
	}
}

/// Creator   : wk
/// CreatDate : 2018-11-29
/// Desc      : 根据传入节点获取所有父节点
/// Other     : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).GetAllParentNode("root")
ClassMethod GetAllParentNode(treeCode As %String, ByRef moduleNode)
{
	q:treeCode=""
	s len=$l(treeCode,".")
	for i=1:1:len {
		s moduleNode(i)=""
		s node=$p(treeCode,".",1,i)
		if ('$d(moduleNode(i,node))){
			s moduleNode(i,node)=""
		}
	}
}

/// Creator   : wk
/// CreatDate : 2018-05-25
/// Desc      : 报表数据展示
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.ModuleFunction","GetReportQuery","")
Query GetReportQuery(treeCode As %String = "") As websys.Query(ROWSPEC = "rpID:%String:ID,rpCode:%String:编码,rpName:%String:名称,rpDesc:%String:描述,rpTreeCode:%String:树节点") [ SqlProc ]
{
}

ClassMethod GetReportQueryExecute(ByRef qHandle As %Binary, treeCode As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:treeCode="" $$$OK
 	s sql="select RptCfg_RowID,RptCfg_Code,RptCfg_Desc,RptCfg_Name,RptCfg_TreeCode from DHCWL_MKPI.MMgrRptCfg where rptcfg_TreeCode= '"_treeCode_"'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("RptCfg_RowID"),rs.Data("RptCfg_Code"),rs.Data("RptCfg_Name"),rs.Data("RptCfg_Desc"),rs.Data("RptCfg_TreeCode"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-05-25
/// Desc      : 报表数据展示
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.ModuleFunction","GetDateSetQuery")
Query GetDateSetQuery(treeCode As %String = "", rpCode As %String = "") As websys.Query(ROWSPEC = "dsID:%String:ID,dsCode:%String:编码,dsDesc:%String:描述,dsRule:%String:取数规则,dsFilter:%String:过滤规则") [ SqlProc ]
{
}

ClassMethod GetDateSetQueryExecute(ByRef qHandle As %Binary, treeCode As %String = "", rpCode As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:((treeCode="")||(rpCode="")) $$$OK
 	s sql="select DatasetCfg_RowID,DatasetCfg_Code,DatasetCfg_Desc,DatasetCfg_RuleList,DatasetCfg_FilterList from DHCWL_MKPI.MMgrDatasetCfg where DatasetCfg_TreeCode= '"_treeCode_"' and DatasetCfg_RptCode='"_rpCode_"'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s kpiRuleList=rs.Data("DatasetCfg_RuleList")
		s kpiRuleList=$replace(kpiRuleList,"%","^")
		s ^CacheTemp(repid,ind)=$lb(rs.Data("DatasetCfg_RowID"),rs.Data("DatasetCfg_Code"),rs.Data("DatasetCfg_Desc"),kpiRuleList,rs.Data("DatasetCfg_FilterList"))
		s ind=ind+1
	}
	Quit $$$OK
}

///  Creator   : wk
///  CreatDate : 2018-05-28
///  Desc      : 模块更新
///  Table     : DHCWL_MKPI.MMgrModuleCfg
///  Other     : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).updateModule()
ClassMethod UpdateModule(code As %String, desc As %String, pTreeCode As %String, type As %String)
{
	q:((code="")||(pTreeCode="")) "维护信息不能为空"
	s treeCode=pTreeCode_"."_code
	s pCode=pTreeCode
	if (type="add"){
		s modID="",errorFlag=0
		for {
			s modID=$o(^DHCWL.MKPI.MMgrModuleCfgD(modID))
			q:modID=""
			s modCode=$lg(^DHCWL.MKPI.MMgrModuleCfgD(modID),2)
			if ($zcvt(modCode,"U")=$zcvt(code,"U")){
				s errorFlag=1
				q
			}
		}
		q:(errorFlag=1) "当前编码与已存在模块编码重复,请重新填写"
		&sql(insert into DHCWL_MKPI.MMgrModuleCfg (modulecfg_code,modulecfg_desc,modulecfg_treecode,modulecfg_ptreecode) values (:code,:desc,:treeCode,:pCode))
		i +$g(SQLCODE)=0 q "添加成功"
		e  q "添加失败!"_SQLCODE	
	}elseif(type="modify"){
		&sql(update DHCWL_MKPI.MMgrModuleCfg set modulecfg_desc=:desc where modulecfg_treecode=:pTreeCode)
		i +$g(SQLCODE)=0 q "修改成功"
		e  q "修改失败"	
	}
}

///   Creator    : wk
///   CreatDate  : 2018-05-28
///   Desc       : 模块树节点删除
///   Table      : DHCWL_MKPI.MMgrModuleCfg
///   Other      : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).DeleteModule()
ClassMethod DeleteModule(treeCode As %String)
{
	q:(treeCode="") "树节点不能为空"
	q:$d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode)) "请先删除该模块下的报表数据集等内容"
	q:$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgPTreeCodeIndex",treeCode)) "请删除该模块下的子模块"
	s moduleID=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode,""))
	q:moduleID="" "获取模块失败"
	&sql(delete from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_RowID=:moduleID)
	q:((SQLCODE'=0) && (SQLCODE'=100)) "删除MMgrModuleCfg失败!"_SQLCODE
	q "删除成功啦"
}

///  Creator     : wk
///  CreatDate   : 2018-05-28
///  Desc        : 报表更新
///  Table       : DHCWL_MKPI.MMgrRptCfg
///  Other       : do ##class(web.DHCWL.V1.KPI.ModuleFunction).UpdateRp()
ClassMethod UpdateRp(code As %String, name As %String, desc As %String, treeCode As %String, type As %String)
{
	if ($g(type)="add"){  //添加
		s dsCode="",flag=0
		for {
			s dsCode=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,dsCode))
			q:dsCode=""
			if ($zcvt(dsCode,"U")=$zcvt(code,"U")){
				s flag=1
				q 
			}
		}
		q:flag=1 "当前模块下已存在该报表编码,请重新填写"
		q:($d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,code))) "当前模块下已存在该报表编码,请重新填写"
		&sql(insert into DHCWL_MKPI.MMgrRptCfg (rptCfg_code,rptCfg_desc,RptCfg_TreeCode,RptCfg_Name) values (:code,:desc,:treeCode,:name))
		q:+$g(SQLCODE)=0 "添加成功"
		e  q "添加失败!,SQLCODE:"_SQLCODE		
	}elseif($g(type)="modify"){	 //更新
		s rowid=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,code,""))
		q:($g(rowid)="") "获取修改报表失败"
		&sql(update DHCWL_MKPI.MMgrRptCfg set rptCfg_desc=:desc,RptCfg_Name=:name where rptCfg_RowID=:rowid)
		q:+$g(SQLCODE)=0 "修改成功"
		e  q "添加失败!"_SQLCODE		
	}
}

///  Creator    : wk
///  CreatDate  : 2018-05-28
///  Desc       : 报表删除
///  Table      : DHCWL_MKPI.MMgrRptCfg
///  Other      : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).DeleteRp()
ClassMethod DeleteRp(treeCode As %String, rpCode As %String)
{
	q:$d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rpCode)) "请删除该报表下的数据集后再进行操作"
	s rptID=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rpCode,""))
	//&sql(delete from DHCWL_MKPI.MMgrRptCfg where RptCfg_TreeCode=:treecodes and RptCfg_Code=:rpCode)
	&sql(delete from DHCWL_MKPI.MMgrRptCfg where RptCfg_RowID=:rptID)
	q:((SQLCODE'=0) && (SQLCODE'=100)) "删除报表失败!"_SQLCODE
	q "删除成功啦"
}

///  Creator   : wk
///  CreatDate : 2018-05-30
///  Desc      : 数据集更新
///  Table     : DHCWL_MKPI.MMgrDatasetCfg
///  Other     : do ##class(web.DHCWL.V1.KPI.ModuleFunction).UpdateDs()
ClassMethod UpdateDs(dsID As %String, dsCode As %String, dsDesc As %String, treeCode As %String, rpCode As %String, type As %String)
{
	s rowid=dsID
	s code=dsCode
	s desc=dsDesc
	s treecode=treeCode
	s rptcode=rpCode

	if ($g(type)="add"){  //添加
		s tempDSCode="",flag=""
		for {
			s tempDSCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptcode,tempDSCode))
			q:tempDSCode=""
			if ($zcvt(tempDSCode,"U")=$zcvt(dsCode,"U")){
				s flag=1
				q
			}
		}
		q:(flag=1) "当前数据集下有相同的编码,请重新填写"
		if ($d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptcode,dsCode))){
			q "当前数据集下有相同的编码,请重新填写"
		}
		&sql(insert into DHCWL_MKPI.MMgrDatasetCfg (DatasetCfg_Code,DatasetCfg_desc,DatasetCfg_TreeCode,DatasetCfg_RptCode) values (:code,:desc,:treecode,:rptcode))
		i +$g(SQLCODE)=0 q "添加成功"
		e  q "添加失败"_SQLCODE		
	}elseif($g(type)="modify"){			//更新
		&sql(update DHCWL_MKPI.MMgrDatasetCfg set DatasetCfg_desc=:desc where DatasetCfg_RowID=:rowid)
		i +$g(SQLCODE)=0 q "更新成功"
		e  q "更新失败"_SQLCODE		
	}
}

///  Creator   :  wk
///  CreatDate :  2018-05-30
///  Desc      :  删除数据集
///  Table     :  DHCWL_MKPI.MMgrDatasetCfg
///  Other     :  do ##class(web.DHCWL.V1.KPI.ModuleFunction).DeleteDs()
ClassMethod DeleteDs(rptCode As %String, treeCode As %String, dsCodes As %String)
{
	s $zt="ErrorDel"	
	q:((rptCode="")||(treeCode="")||(dsCodes="")) "数据集信息不全,无法删除"
	TSTART
		s Sql="delete from DHCWL_MKPI.MMgrDatasetCfg where DatasetCfg_RptCode='"_rptCode_"' and DatasetCfg_TreeCode='"_treeCode_"' and DatasetCfg_Code in ('"_dsCodes_"')"
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) {do ErrorDel q errorInfo}
		s st=Rs.Execute() if ($$$ISERR(st)) {do ErrorDel q errorInfo}
		d Rs.Close()

		s Sql="delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_RptCode='"_rptCode_"' and KPICfg_TreeCode='"_treeCode_"' and KPICfg_DatasetCode in ('"_dsCodes_"')"
		s st=Rs.Prepare(Sql)  if ($$$ISERR(st)) {do ErrorDel q errorInfo}
		s st=Rs.Execute() if ($$$ISERR(st)) {do ErrorDel q errorInfo}
		d Rs.Close()
		

	TCOMMIT

		;w "{success:true,tip:'ok'}"
		q "删除成功"
		
ErrorDel
		TROLLBACK
		do DecomposeStatus^%apiOBJ(st,.err,"-d")
		s errorInfo=""
		for i=1:1:err 
		{
			s errorInfo=errorInfo_err(i)
		}
		q
}

///  Creator   : wk
///  CreatDate : 2018-06-27
///  Desc      : 保存数据集的取数规则
///  Other     : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).SaveDSRule()
ClassMethod SaveDSRule(dsID, rulelist)
{
	s rowid=dsID
	
	//"^"无法保存到表里，将其替换成"%"保存
	s rulelist=$TRANSLATE(rulelist,"^","%")
	//更新MMgrDatasetCfg
	&sql(update DHCWL_MKPI.MMgrDatasetCfg set DatasetCfg_RuleList=:rulelist where DatasetCfg_RowID=:rowid)
	i +$g(SQLCODE)'=0 TROLLBACK  q "更新失败,SQLCODE:"_SQLCODE	
	q "更新成功"
}

/// Creator    : wk
/// CreatDate  : 2018-10-30
/// Desc       : 保存数据集的过滤规则
/// Other      : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).SaveDSFilterRule()
ClassMethod SaveDSFilterRule(dsID, filterList As %Text)
{
	s rowid=dsID
	&sql(update DHCWL_MKPI.MMgrDatasetCfg set DatasetCfg_FilterList=:filterList where DatasetCfg_RowID=:rowid)
	i +$g(SQLCODE)'=0 q "更新失败',SQLCODE:"_SQLCODE	
	q "更新成功"
}

///  Creator   : wk
///  CreatDate : 2018-06-27
///  Desc      : 处理过滤规则
///  Other     : do ##Class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.ModuleFunction","GetFilterList",341)
Query GetFilterList(dsID As %String) As websys.Query(ROWSPEC = "kpiCode:%String,kpiRule:%String,filterFun:%String,value:%String,operator:%String:左符号,rightBrackets:%String:右符号") [ SqlProc ]
{
}

ClassMethod GetFilterListExecute(ByRef qHandle As %Binary, dsID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s filterList = $lg(^DHCWL.MKPI.MMgrDataSetCfgD(dsID),7)
	d ##class(DHCWL.MKPIService.KpiFilter).SplitFilterExpression(filterList,.data)
	s kpiCode=""
	for{
		s kpiCode=$o(data(kpiCode))
		q:kpiCode=""
		s kpiFilterList=data(kpiCode)
		s symbolList=$g(data(kpiCode,"LO"))
		s len=$ll(kpiFilterList)
		s step=2
		s relatNum=1
		for{
			s filterCode=$lg(kpiFilterList,step)
			q:((filterCode="")||(step>=len))
			s filterFun=$lg(kpiFilterList,(step+1))
			s filterValue=$lg(kpiFilterList,(step+2))
			s beforeRule=$lg(kpiFilterList,(step+4))
			s afterRule=$lg(kpiFilterList,(step+5))
			s relatSymbol=""
			if (relatNum>1){
				s relatSymbol=$lg(symbolList,(relatNum-1))
			}
			s ^CacheTemp(repid,ind)=$lb(kpiCode,filterCode,filterFun,filterValue,relatSymbol_beforeRule,afterRule)
			s ind=ind+1
			s step=step+7
			s relatNum=relatNum+1
		}
	}
	Quit $$$OK
}

///  Creator   : wk
///  CreatDate : 2018-06-14
///  Desc      : 获取选中模块、报表、数据集包含的指标 ps：MRD---模块、报表、数据集的缩写
///  Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.ModuleFunction","GetKPITaskByMRDQuery","D:CreatYesterdayData^DHCWLAutoCreatMKPIData:N","root.CRZZBB","module")
Query GetKPITaskByMRDQuery(secInfors As %String, treeNodes As %String, sign As %String) As websys.Query(ROWSPEC = "kpiCode:%String:指标编码,secCode:%String:区间编码,secName:%String:区间名称,exeCode:%String:执行代码,activeFlag:%String:激活状态,modal:%String:展示方式") [ SqlProc ]
{
}

ClassMethod GetKPITaskByMRDQueryExecute(ByRef qHandle As %Binary, secInfors As %String, treeNodes As %String, sign As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
   	q:((treeNodes="")||(sign="")) $$$OK
   	k taskInforList,kpiList
   	
   	s len= $l(secInfors,",")     //解析传入的已经配置的指标任务
   	for i=1:1:len {
	   	s secInfor=$p(secInfors,",",i)
	   	continue:secInfor=""
	   	s secCode=$p(secInfor,":",1)
	   	s exeCode=$p(secInfor,":",2)
	   	continue:((secCode="")||(exeCode=""))
	   	s taskInforList(secCode,exeCode)=""
   	}
   	
   	d ##class(web.DHCWL.V1.KPI.ModuleFunction).GetModuleRptKpiInfor(treeNodes,sign,.kpiList)  //调用接口获取模块、报表、数据集中的指标列表
   	
   	s kpiCode=""   //遍历获取的指标,取出指标的任务,并与已配置好的任务做比较
   	for {
	   	s kpiCode=$o(kpiList(kpiCode))
	   	q:kpiCode=""
	   	s kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	   	continue:kpiID=""
	   	s flag=""
	   	for {
		   	s flag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID,flag))
		   	q:flag=""
		   	s taskID=""
		   	for {
			   	s taskID=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID,flag,taskID))
			   	q:taskID=""
			   	s secCode=$lg(^DHCWL.MKPI.CreatDataTaskD(taskID),6)
			   	s secID=$lg(^DHCWL.MKPI.CreatDataTaskD(taskID),5)
			   	s secName=$lg(^DHCWL.MKPI.SectionD(secID),4)
			   	s exeCode=$lg(^DHCWL.MKPI.CreatDataTaskD(taskID),3)
			   	s activeFlag=$lg(^DHCWL.MKPI.CreatDataTaskD(taskID),2)
			   	if (activeFlag="Y"){
			   		s activeFlag="是"
			   	}else{
			   		s activeFlag="否"
			   	}
			   	if ($d(taskInforList(secCode))) {
				   	if ($d(taskInforList(secCode,exeCode))){
					   	s ^CacheTemp(repid,ind)=$lb(kpiCode,secCode,secName,exeCode,activeFlag,0)   //最后一个参数0表示与配置的任务相同,1表示执行代码不同,2表示已配置列表没有改记录
				   		s ind=ind+1
				   	}else{
					   	s ^CacheTemp(repid,ind)=$lb(kpiCode,secCode,secName,exeCode,activeFlag,1)
					   	s ind=ind+1
				   	}
			   	}else{
				   	s ^CacheTemp(repid,ind)=$lb(kpiCode,secCode,secName,exeCode,activeFlag,2)
				   	s ind=ind+1
			   	}
		   	}
	   	}
   	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDesc : 根据传入参数获取模块、报表、数据集下的指标列表
/// CreatDate : 2018-06-24
/// Input     : 树节点、节点类型
/// Other     : do ##class(web.DHCWL.V1.KPI.ModuleFunction).GetKPIListByModule()
ClassMethod GetKPIListByModule(treeCode As %String = "", type As %String = "")
{
	q:((treeCode="")||(type="")) $$$OK
	s kpiCode="",kpiCodes=""
	do ##class(web.DHCWL.V1.KPI.ModuleFunction).GetModuleRptKpiInfor(treeCode,type,.data)
	for {
		s kpiCode=$o(data(kpiCode))
		q:kpiCode=""
		if (kpiCodes=""){
			s kpiCodes=kpiCode
		}else{
			s kpiCodes=kpiCodes_","_kpiCode
		}
	}
	q kpiCodes
}

/// Creator   : wk
/// CreatDate : 2018-06-21
/// CreatDesc : 根据传入的指标和区间任务模版来修改指标的任务
/// Other     : do ##Class(web.DHCWL.V1.KPI.ModuleFunction).SetKPITask()
ClassMethod SetKPITask(secTaskList As %String = "", kpiList As %String = "", treeCode As %String = "", type As %String = "")
{
	q:((secTaskList="")||(kpiList="")||(treeCode="")||(type="")) "获取信息失败"
	s sc=##class(DHCWL.MKPIService.KpiModuleData).SetSectionTask(kpiList,secTaskList,treeCode,type)
	if (sc=1){
		q "保存失败"
	}else{
		q "保存成功"
	}
}

/// Creator   : wk
/// CreatDate : 2018-06-21
/// CreatDesc : 激活传入的指标任务
/// Other     : do ##Class(web.DHCWL.V1.ModuleFunction).ActiveKPITask()
ClassMethod ActiveKPITask(kpiCodes As %String)
{
	s kpiCnt=$l(kpiCodes,",")
	s DTaskKpiIDs="",error=0

	f i=1:1:kpiCnt {
		s kpiCode=$p(kpiCodes,",",i)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		q:kpiId=""
		s CreatDataId=""
		for{
			s CreatDataId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId," N",CreatDataId))
			q:CreatDataId=""
			&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ActiveFlag='Y' where ID=:CreatDataId)
			i +$g(SQLCODE)'=0 {
	 			s error=1
			}
		}
		
	}
	if (error=0){
		q "激活任务成功"
	}else{
		q "激活任务失败"
	}
}

/// Creator   : wk
/// CreatDate : 2018-06-21
/// CreatDesc : 关闭传入的指标任务
/// Other     :
ClassMethod DisActiveKPITask(kpiCodes As %String)
{
	s kpiCnt=$l(kpiCodes,",")
	s DTaskKpiIDs="",error=0

	f i=1:1:kpiCnt {
		s kpiCode=$p(kpiCodes,",",i)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		q:kpiId=""
		s CreatDataId=""
		for{
			s CreatDataId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId," Y",CreatDataId))
			q:CreatDataId=""
			&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ActiveFlag='N' where ID=:CreatDataId)
			i +$g(SQLCODE)'=0 {
	 			s error=1
			}
		}
		
	}
	if (error=0){
		q "关闭任务成功"
	}else{
		q "关闭任务失败"
	}
}

/// Creator    : wk
/// CreatDate  : 2018-06-22
/// CreatDesc  : 导出模块信息
/// Other      : do ##class(web.DHCWL.V1.KPI.ModuleFunction).exportModule()
ClassMethod exportModule(treeCodes, type)
{
	d ##class(DHCWL.ModuleManageServ.MMServ).exportModules(treeCodes,"",type,"","","")
	d %response.Flush()
	q ""
}

/// Creator     : wk
/// CreatDate   : 2018-06-22
/// CreatDesc   : 导出模块内的指标信息
/// Other       : do ##class(web.DHCWL.V1.KPI.ModuleFunction).exportModuleKPI()
ClassMethod exportModuleKPI(treeCodes, type, flag = 0)
{
	s flagValue=flag
	//s list=##Class(%Library.ListOfObjects).%New()
	s list=##class(DHCWL.ModuleManageServ.MMServ).getExportInfor(treeCodes,"",type,"","","")
	s len=list.Count()
	s kpiIds=""
	f i=1:1:len {
	    s obj=list.GetAt(i)
	    s dataName=obj.%ClassName(1)
	    if (dataName="DHCWL.MKPI.MMgrDataSetCfg"){
	    	s ruleList=obj.DatasetRuleList
	    	s ruleLen=$l(ruleList,",")
	    	for j=1:1:ruleLen {
		    	s rule=$p(ruleList,",",j)
		    	continue:rule=""
		    	s kpiCode=$p(rule,":")
		    	continue:kpiCode=""
		    	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		    	continue:kpiId=""
		    	if (kpiIds=""){
		    		s kpiIds=kpiId
		    	}else{
			    	s kpiIds=kpiIds_","_kpiId
		    	}
	    	}
	    }
	}
	s kpiSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiSystemList(kpiIds,flagValue)
	d ##class(DHCWL.MKPIIO.DefaultOutService).OutputMKPIToStream(kpiSysList,.outStream,flagValue)
	Set sc =##class(%XML.TextReader).ParseStream(outStream,.reader)
	if (reader="") {
		w "导出错误!"
		q
	}
	d ##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToStr(reader)
	q ""
}

/// Creator    : wk
/// CreateDate ：2015-10-26---modify:2018-06-21
/// CreatDesc  :返回模块或报表中的指标code
/// Other      :s sign=##class(web.DHCWL.V1.KPI.ModuleFunction).GetModuleRptKpiInfor("2314")
ClassMethod GetModuleRptKpiInfor(treeNodes, kpimoduleRptSign, ByRef saveKpiList)
{
	if (kpimoduleRptSign="module"){  //用户操作的是模块
		s treeNum=$length(treeNodes,",")
		for i=1:1:treeNum{
			s treeNode=$p(treeNodes,",",i)
			q:treeNode=""
			s reportCode=""
			for{
				s reportCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeNode,reportCode))
				q:reportCode=""
				s datasetCode=""
				for{
					s datasetCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeNode,reportCode,datasetCode))
					q:datasetCode=""
					s datasetId=""
					for{
						s datasetId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeNode,reportCode,datasetCode,datasetId))
						q:datasetId=""
						s datasetRule=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(datasetId),5,"")
						continue:datasetRule=""
						s RuleLength=$length(datasetRule,",")
						for j=1:1:RuleLength{
							s kpiRule=$p(datasetRule,",",j)
							s datasetKpiCode=$p(kpiRule,":",1)
							continue:datasetKpiCode=""
							if ($d(saveKpiList(datasetKpiCode))=0){
							s saveKpiList(datasetKpiCode)=""
							}
						}
					}
				}
		}
	}
	}elseif (kpimoduleRptSign="report"){//用户操作的报表
		s rptNum=$length(treeNodes,",")
		for i=1:1:rptNum{
			s treeNode=$p(treeNodes,",",i)
			q:treeNode=""
			s nodeLen=$l(treeNode,".")
			s rptCode=$p(treeNode,".",nodeLen)
			continue:rptCode=""
			s moduleCode=$p(treeNode,".",1,(nodeLen-1))
			continue:moduleCode=""
			s dataSetCode=""
			for{
				s dataSetCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCode,dataSetCode))
				q:dataSetCode=""
				s dataSetId=""
				s dataSetId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCode,dataSetCode,dataSetId))
				continue:dataSetId=""
				s dataSetRule=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(dataSetId),5,"")
				continue:dataSetRule=""
				s RuleLength=$length(dataSetRule,",")
				for j=1:1:RuleLength{
					s kpiRule=$p(dataSetRule,",",j)
					s datasetKpiCode=$p(kpiRule,":",1)
					continue:datasetKpiCode=""
					if ($d(saveKpiList(datasetKpiCode))=0){
						s saveKpiList(datasetKpiCode)=""
					}
				}
			}
		}
	}elseif(kpimoduleRptSign="dateSet"){
		s dsLen=$length(treeNodes,",")
		for i=1:1:dsLen{
			s treeNode=$p(treeNodes,",",i)
			s nodeLen=$l(treeNode,".")
			s dataSetCode=$p(treeNode,".",nodeLen)
			s rptCode=$p(treeNode,".",(nodeLen-1))
			s moduleCode=$p(treeNode,".",1,(nodeLen-2))
			s dataSetId=""
			s dataSetId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCode,dataSetCode,dataSetId))
			continue:dataSetId=""
			s dataSetRule=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(dataSetId),5,"")
			continue:dataSetRule=""
			s RuleLength=$length(dataSetRule,",")
			for j=1:1:RuleLength{
				s kpiRule=$p(dataSetRule,",",j)
				s datasetKpiCode=$p(kpiRule,":",1)
				continue:datasetKpiCode=""
				if ($d(saveKpiList(datasetKpiCode))=0){
					s saveKpiList(datasetKpiCode)=""
				}
			}
		}
	}
}

/// Creator    : wk
/// CreatDate  : 2018/06/26
/// CreatDesc  : 导入模块信息
/// Other      :
ClassMethod InputModule(theStep, inputCont)
{
	//q %request.Data("theStep",1)
	//s ^TEMPDHCWL("wk","param")=
	//w $g(%request.Data("inputCont(str1)",1))
	//q data("str1")
	//zw
	//w inputCont(1) 
	//q 
	s node="NODE"_$g(^DHCWL.MKPI.TEMPCONT("NODEINDEX"))
	s wrong=0,wrongMes=""
	s deli=##class(DHCWL.util.DirectoryFile).SetPathOS()
	s deli=$p(deli,"||",2)
	s tmp=##class(DHCWL.util.DirectoryFile).GetTempDir()
	i $e(tmp,$l(tmp))'=deli s tmp=tmp_deli
	s index=$g(^DHCWL.MKPI.TEMPCONT("NODEINDEX")) 
	s fileName="tempDHCWLXML"_index_".xml"
	s tempFile=tmp_fileName
	s index=+index+1
	s ^DHCWL.MKPI.TEMPCONT("NODEINDEX")=index
	i ##class(%File).Exists(tempFile) d ##class(%File).Delete(tempFile)
	s file=##class(%File).%New(tempFile)
	w tempFile
	d file.Open("WN")
	s step=""
	s i=1
	for{
		s step=$o(inputCont(step))
		q:step=""
		s content=inputCont(step)
		s ^DHCWL.MKPI.TEMPCONT("Node"_i)=content
		s i=i+1
		s sc=file.Write(content)
		if sc'=1 {
			s wrongMes=sc
			s wrong=1
			q
		}
	}
	d:file'="" file.Close()
	s ^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",+$h,index-1)=tempFile
	if wrong=0{
		;w "{success:true,info:'ok',tips:'"_fileName_"'}"
		w "{data:"
		d ##class(DHCWL.ModuleManageServ.MMServ).JsonKpi(tempFile)
		w ",tips:"""_fileName_""",tempFile:"""_tempFile_"""}"
	}else {
		w "{success:true,info:'wrong',tips:'文件上传失败'}"
	}
	d %response.Flush()
	//若历史上有没有删除掉的临时文件
	s day=+$h f  s day=$o(^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day),-1) q:day=""  d
	.s indI="" f  s indI=$o(^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day,indI)) q:indI=""  d
	..s tf=$g(^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day,indI))
	..i tf'="" d
	...i ##class(%File).Exists(tf) d ##class(%File).Delete(tf)
	.k ^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day)
}

}

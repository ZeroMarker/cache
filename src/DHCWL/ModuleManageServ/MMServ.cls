Class DHCWL.ModuleManageServ.MMServ Extends %RegisteredObject
{

// d ##class(DHCWL.ModuleManageServ.MMServ).GetKpisByTabID("CYRS",mydata)

/// 名称: GetKpisByTabCode
/// 描述: 根据报表编码获取该报表下所有指标的指标编码，维度。
/// 参数: tabCode——字符串类型。报表编码
/// 	  kpiData——数组类型。用于存放报表所包含的指标或指标维度。
///       指标或维度的存放顺序与指标序号相同。数组中单个数据元素按下列各式存放数据：
///       kpi1:kpiDimCode1.dimPro1^kpiDimCode1.dimPro2^kpiDimCode2.dimPro1
/// 
/// 编写者： 王峥
/// 编写日期:2013-11-29
ClassMethod GetKpisByTabCode(tabCode As %String, ByRef kpiData)
{
	;&sql(select kpicfg_code, kpicfg_dimcfgrule into :kpicfgCode,:kpicfgdimcfgrule from DHCWL_MKPI.ModeMagKpiCfg where kpicfg_pcode = :tabCode)		
	;i +$g(SQLCODE)=0 w "{success:true,tip:'ok'}" 
	;^DHCWL.MKPI.ModeMagKpiCfgI("RptKpiIndex","CYRS",30)
	q:'$d(^DHCWL.MKPI.ModeMagKpiCfgI("RptKpiIndex",tabCode))
	k kpiData
	s kpiCfgRowID=0
	s defaultOrderNum=1000
	f  s kpiCfgRowID=$o(^DHCWL.MKPI.ModeMagKpiCfgI("RptKpiIndex",tabCode,kpiCfgRowID))  q:kpiCfgRowID=""  d
	.s kpiCode=$li(^DHCWL.MKPI.ModeMagKpiCfgD(kpiCfgRowID),2)
	.s KpiCfgDimCfgRule=$li(^DHCWL.MKPI.ModeMagKpiCfgD(kpiCfgRowID),3)
	.s KpiCfgOrderNum=$li(^DHCWL.MKPI.ModeMagKpiCfgD(kpiCfgRowID),5)
	.i $g(KpiCfgDimCfgRule)="" 	s kpiStr=kpiCode
	.else  d 
	..s KpiCfgDimCfgRule=$TRANSLATE(KpiCfgDimCfgRule,"%","^")
	..s kpiStr=kpiCode_":"_KpiCfgDimCfgRule
	.i +$g(KpiCfgOrderNum)=0  d
	..s KpiCfgOrderNum=defaultOrderNum
	..s defaultOrderNum=defaultOrderNum+1
	.s kpiData(KpiCfgOrderNum)=kpiStr
}

// d ##class(DHCWL.ModuleManageServ.MMServ).GetModuleAncestorsByDesc("门诊收入")

ClassMethod GetModuleAncestorsByDesc2(modeDesc As %String) As %String
{
		
	set sql="select modulecfg_code,modulecfg_desc,modulecfg_treecode from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_desc like "_"'%"_modeDesc_"%'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	
	set retCodes=""
	While(rs.Next()){
		s treecodeData=rs.Data("ModuleCfg_TreeCode")
		s len=$L(treecodeData,".")
		//b
		for inx=1:1:len-1 {
			if (retCodes'="") s retCodes=retCodes_","
			s treeCode=$p(treecodeData,".",1,inx)
			s retCodes=retCodes_treeCode
		}
	}
	d rs.Close()
	q retCodes
}

// s a=##class(DHCWL.ModuleManageServ.MMServ).GetModuleAncestors(1,"门诊收入","root.WHET.MZSR,root.WHET.ZYSR")

/// 名称: GetModuleAncestorsByDesc
/// 描述: 根据模块的描述来模糊查找模块的祖先节点的Treecode。
/// 参数: modeDesc——模块的描述
/// 	  modeCode——模块编码
/// 	  	  type——1，描述；2，编码
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
ClassMethod GetModuleAncestors(type As %String, modeDesc As %String, modeCode As %String) As %String
{
	b
	set sql=""
	if type=1 set sql="select modulecfg_code,modulecfg_desc,modulecfg_treecode from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_desc like "_"'%"_modeDesc_"%'"
	else  set sql="select modulecfg_code,modulecfg_desc,modulecfg_treecode from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_Code like "_"'%"_modeCode_"%'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	
	set retCodes=""
	set TDataStr=""
	While(rs.Next()){
		s codeData=rs.Data("ModuleCfg_TreeCode")
		if (TDataStr'="") s TDataStr=TDataStr_","
		s TDataStr=TDataStr_codeData
	}
	d rs.Close()
	b 
	s retCodes=..GetfirsthalfSubStr(TDataStr)
	
	
	q retCodes
}

// d ##class(DHCWL.ModuleManageServ.MMServ).GetSubStr("root.WHET.MZSR,root.WHET.ZYSR")

/// 名称: GetSubStr
/// 描述: 用“,”和“.”分割字符串，并将分割的子字符串组成新串，子字符串之间用“,”隔开。
/// 参数: dataStr——待处理的串
/// 	  
/// 返回类型：	字符串
/// 返回值：	用“,”隔开的字符串
/// 编写者： 王峥
/// 编写日期:2014-1-14
ClassMethod GetfirsthalfSubStr(dataStr As %String) As %String
{
	k ^TEMPDHCWL($j,"MMServ")
	s retStr=""
	s dataStrLen=$L(dataStr,",")
	f i=1:1:dataStrLen {
		s unitData=$p(dataStr,",",i) 
		s unitDataLen=$L(unitData,".")
		f j=1:1:unitDataLen {
			//if (retStr'="") s retStr=retStr_","
			s ^TEMPDHCWL($j,"MMServ",$p(unitData,".",1,j))=1
		}
	}
	
	s unitD="" 
	f {
		s unitD=$o(^TEMPDHCWL($j,"MMServ",unitD))
		q:$g(unitD)=""
		if retStr'="" s retStr=retStr_","
		s retStr=retStr_unitD
		
	}
	k ^TEMPDHCWL($j,"MMServ")
	q retStr
}

// s a=##class(DHCWL.ModuleManageServ.MMServ).GetModuleAncestorsByCode("MZSR")

/// 名称: GetModuleAncestorsByCode
/// 描述: 根据模块的编码来模糊查找模块的祖先节点的Treecode。
/// 参数: modeCode——模块的编码
/// 	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
ClassMethod GetModuleAncestorsByCode(modeCode As %String) As %String
{
		
	set sql="select modulecfg_code,modulecfg_desc,modulecfg_treecode from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_code like "_"'%"_modeCode_"%'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	
	set retCodes=""
	set TDataStr=""
	While(rs.Next()){
		s codeData=rs.Data("ModuleCfg_TreeCode")
		if (TDataStr'="") s TDataStr=TDataStr_","
		s TDataStr=TDataStr_codeData
	}
	d rs.Close()
	s retCodes=..GetfirsthalfSubStr(TDataStr)
	
	
	q retCodes
}

/// 名称: GetModuleAncestorsByDesc
/// 描述: 根据模块的描述来模糊查找模块的祖先节点的Treecode。
/// 参数: modeDesc——模块的描述
/// 	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
ClassMethod GetModuleDescendant(type As %String, modeDesc As %String, modeCode As %String) As %String
{
	
	set sql=""
	if type=1 set sql="select modulecfg_code,modulecfg_desc,modulecfg_treecode from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_desc like "_"'%"_modeDesc_"%'"
	else  set sql="select modulecfg_code,modulecfg_desc,modulecfg_treecode from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_Code like "_"'%"_modeCode_"%'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	
	set retCodes=""
	set TDataStr=""
	While(rs.Next()){
		s codeData=rs.Data("ModuleCfg_TreeCode")
		if (TDataStr'="") s TDataStr=TDataStr_","
		s TDataStr=TDataStr_codeData
	}
	d rs.Close()
	b 
	s retCodes=..GetfirsthalfSubStr(TDataStr)
	
	
	q retCodes
}

/// 名称: GetSearchedModule
/// 描述: 根据模块的描述来模糊查找模块的祖先节点的Treecode。
/// 参数: modeDesc——模块的描述
/// 	  modeCode——模块编码
/// 	  	  type——1，描述；2，编码
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
/// s a=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedModule("指标","描述","病区转出人数")
ClassMethod GetSearchedModule(objType As %String, objAttrib As %String, objValue As %String) As %String
{
	s $zt="ErrorGetSearchedModule"	
	b
	set sql=""
	if objType="模块" {
		s sql="select modulecfg_treecode from DHCWL_MKPI.MMgrModuleCfg where "
		if objAttrib="描述" s sql=sql_"ModuleCfg_desc like "_"'%"_objValue_"%'"
		else  s sql=sql_" ModuleCfg_Code like "_"'%"_objValue_"%'"
	}
	
	if objType="报表" {
		s sql="select RptCfg_TreeCode from DHCWL_MKPI.MMgrRptCfg where "
		if objAttrib="描述" s sql=sql_"RptCfg_Desc like "_"'%"_objValue_"%'"
		else  s sql=sql_" RptCfg_Code like "_"'%"_objValue_"%'"
	}
	
	if objType="数据集" {
		s sql="select DatasetCfg_TreeCode from DHCWL_MKPI.MMgrDatasetCfg where "
		if objAttrib="描述" {
			s sql=sql_"DatasetCfg_Desc like "_"'%"_objValue_"%'"
		}else{
			s sql=sql_" DatasetCfg_Code like "_"'%"_objValue_"%'"
		}
	}	

	if objType="指标" {
		s sql="select KPICfg_TreeCode from DHCWL_MKPI.MMgrKPICfg where "
		if objAttrib="描述" s sql=sql_" KPICfg_Code in (select MKPI_Code from DHCWL_MKPI.DHCWLMKPI where MKPI_Desc like "_"'%"_objValue_"%')"
		else  s sql=sql_"KPICfg_Code = "_"'"_objValue_"'"
	}	
	
	s rs=##class(%Library.ResultSet).%New()
	s st=rs.Prepare(sql) if ($$$ISERR(st)) goto ErrorGetSearchedModule
	s st=rs.Execute()  if ($$$ISERR(st)) goto ErrorGetSearchedModule
	
	set retCodes=""
	While(rs.Next()){
		s codeData=rs.GetData(1)
		if (retCodes'="") s retCodes=retCodes_","
		s retCodes=retCodes_codeData
	}
	d rs.Close()

	q retCodes
	
	
ErrorGetSearchedModule

	q ""
}

/// 名称: GetSearchedRpt
/// 描述: 根据模块的描述来模糊查找模块的祖先节点的Treecode。
/// 参数: modeDesc——模块的描述
/// 	  modeCode——模块编码
/// 	  	  type——1，描述；2，编码
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
/// s a=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedModule("模块","编码","MZSR")
ClassMethod GetSearchedRpt(objType As %String, objAttrib As %String, objValue As %String) As %String
{
	s $zt="ErrorGetSearchedModule"	
	b
	set sql=""
	
	if objType="报表" {
		s sql="select RptCfg_Code from DHCWL_MKPI.MMgrRptCfg where "
		if objAttrib="描述" s sql=sql_"RptCfg_Desc like "_"'%"_objValue_"%'"
		else  s sql=sql_" RptCfg_Code like "_"'%"_objValue_"%'"
	}
	
	if objType="数据集" {
		s sql="select DatasetCfg_RptCode from DHCWL_MKPI.MMgrDatasetCfg where "
		if objAttrib="描述" s sql=sql_"DatasetCfg_Desc like "_"'%"_objValue_"%'"
		else  s sql=sql_" DatasetCfg_Code like "_"'%"_objValue_"%'"
	}	

	//指标不支持描述
	/*if objType="指标" {
		s sql="select KPICfg_RptCode from DHCWL_MKPI.MMgrKPICfg where "
		s sql=sql_"KPICfg_Code = "_"'"_objValue_"'"
	}
	*/
	if objType="指标" {
		s sql="select KPICfg_RptCode from DHCWL_MKPI.MMgrKPICfg where "
		if objAttrib="描述" s sql=sql_" KPICfg_Code in (select MKPI_Code from DHCWL_MKPI.DHCWLMKPI where MKPI_Desc like "_"'%"_objValue_"%')"
		else  s sql=sql_"KPICfg_Code = "_"'"_objValue_"'"
	}	
	
		
	
	s rs=##class(%Library.ResultSet).%New()
	s st=rs.Prepare(sql) if ($$$ISERR(st)) goto ErrorGetSearchedModule
	s st=rs.Execute()  if ($$$ISERR(st)) goto ErrorGetSearchedModule
	
	set retCodes=""
	While(rs.Next()){
		s codeData=rs.GetData(1)
		if (retCodes'="") s retCodes=retCodes_","
		s retCodes=retCodes_codeData
	}
	d rs.Close()

	q retCodes
	
	
ErrorGetSearchedModule

	q ""
}

/// 名称: GetSearchedRpt
/// 描述: 根据模块的描述来模糊查找模块的祖先节点的Treecode。
/// 参数: modeDesc——模块的描述
/// 	  modeCode——模块编码
/// 	  	  type——1，描述；2，编码
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
/// s a=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedModule("模块","编码","MZSR")
ClassMethod GetSearchedDs(objType As %String, objAttrib As %String, objValue As %String) As %String
{
	s $zt="ErrorGetSearchedModule"	
	b
	set sql=""
	
	if objType="数据集" {
		s sql="select DatasetCfg_Code from DHCWL_MKPI.MMgrDatasetCfg where "
		if objAttrib="描述" s sql=sql_"DatasetCfg_Desc like "_"'%"_objValue_"%'"
		else  s sql=sql_" DatasetCfg_Code like "_"'%"_objValue_"%'"
	}	

	//指标不支持描述
	/*
	if objType="指标" {
		s sql="select KPICfg_DatasetCode from DHCWL_MKPI.MMgrKPICfg where "
		s sql=sql_"KPICfg_Code = "_"'"_objValue_"'"
	}
	*/
	
	if objType="指标" {
		s sql="select KPICfg_DatasetCode from DHCWL_MKPI.MMgrKPICfg where "
		if objAttrib="描述" s sql=sql_" KPICfg_Code in (select MKPI_Code from DHCWL_MKPI.DHCWLMKPI where MKPI_Desc like "_"'%"_objValue_"%')"
		else  s sql=sql_"KPICfg_Code = "_"'"_objValue_"'"
	}	
	
	
	s rs=##class(%Library.ResultSet).%New()
	s st=rs.Prepare(sql) if ($$$ISERR(st)) goto ErrorGetSearchedModule
	s st=rs.Execute()  if ($$$ISERR(st)) goto ErrorGetSearchedModule
	
	set retCodes=""
	While(rs.Next()){
		s codeData=rs.GetData(1)
		if (retCodes'="") s retCodes=retCodes_","
		s retCodes=retCodes_codeData
	}
	d rs.Close()

	q retCodes
	
	
ErrorGetSearchedModule

	q ""
}

/// 名称: GetSearchedRpt
/// 描述: 根据模块的描述来模糊查找模块的祖先节点的Treecode。
/// 参数: modeDesc——模块的描述
/// 	  modeCode——模块编码
/// 	  	  type——1，描述；2，编码
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
/// s a=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedModule("模块","编码","MZSR")
ClassMethod GetSearchedKPIs(objType As %String, objAttrib As %String, objValue As %String) As %String
{
	s $zt="ErrorGetSearchedModule"	
	b
	set sql=""
	
	//指标不支持描述
	/*
	if objType="指标" {
		s sql="select KPICfg_Code from DHCWL_MKPI.MMgrKPICfg where "
		s sql=sql_"KPICfg_Code = "_"'"_objValue_"'"
	}	
	*/
	if objType="指标" {
		s sql="select KPICfg_Code from DHCWL_MKPI.MMgrKPICfg where "
		if objAttrib="描述" s sql=sql_" KPICfg_Code in (select MKPI_Code from DHCWL_MKPI.DHCWLMKPI where MKPI_Desc like "_"'%"_objValue_"%')"
		else  s sql=sql_"KPICfg_Code = "_"'"_objValue_"'"
	}	
	
	s rs=##class(%Library.ResultSet).%New()
	s st=rs.Prepare(sql) if ($$$ISERR(st)) goto ErrorGetSearchedModule
	s st=rs.Execute()  if ($$$ISERR(st)) goto ErrorGetSearchedModule
	
	set retCodes=""
	While(rs.Next()){
		s codeData=rs.GetData(1)
		if (retCodes'="") s retCodes=retCodes_","
		s retCodes=retCodes_codeData
	}
	d rs.Close()

	q retCodes
	
	
ErrorGetSearchedModule

	q ""
}

/// 名称: GetModule
/// 描述: 根据模块的描述来模糊查找模块的祖先节点的Treecode。
/// 参数: modeDesc——模块的描述
/// 	  modeCode——模块编码
/// 	  	  type——1，描述；2，编码
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
/// s a=##class(DHCWL.ModuleManageServ.MMServ).IsAncestor("root","root.WHET.ZYSR")
ClassMethod IsAncestor(Anc As %String, Des As %String) As %Integer
{
	s parent=""
	s DesLen=$L(Des,".")
	f i=DesLen-1:-1:1 {
		s parent=$p(Des,".",1,i)
		q:(Anc=parent)
	}
	q:(Anc=parent) 1
	q 0
}

// s a=##class(DHCWL.ModuleManageServ.MMServ).delRptset("'3','4'","root.WHDSRMYY.MZSR")

ClassMethod delRptset(rptCodes As %String, treecode As %String) As %Integer
{
	b
	s $zt="ErrorDel"	
	
	TSTART
		//s Sql="select * from DHCWL_MKPI.MMgrModuleCfg where modulecfg_treecode in ("_modeIDs_")"
		s Sql="delete from DHCWL_MKPI.MMgrRptCfg where RptCfg_TreeCode='"_treecode_"' and RptCfg_Code in ("_rptCodes_")"
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()

		s Sql="delete from DHCWL_MKPI.MMgrDatasetCfg where DatasetCfg_TreeCode='"_treecode_"' and DatasetCfg_RptCode in ("_rptCodes_")"
		s st=Rs.Prepare(Sql)  if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()
		
		s Sql="delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_TreeCode='"_treecode_"' and KPICfg_RptCode in ("_rptCodes_")"
		s st=Rs.Prepare(Sql)  if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()
		/*
		&sql(delete from DHCWL_MKPI.MMgrRptCfg where RptCfg_TreeCode=:treecode and RptCfg_Code in (:rptCodes))
		if ((SQLCODE'=0) && (SQLCODE'=100)) TROLLBACK  w "{success:true,tip:'删除MMRptCfg失败！',SQLCODE:"_SQLCODE_"}" q

		&sql(delete from DHCWL_MKPI.MMgrDatasetCfg where DatasetCfg_TreeCode=:treecode and DatasetCfg_RptCode in (:rptCodes))
		if ((SQLCODE'=0) && (SQLCODE'=100)) TROLLBACK  w "{success:true,tip:'删除MMgrDatasetCfg失败！',SQLCODE:"_SQLCODE_"}" q

		&sql(delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_TreeCode=:treecode and KPICfg_RptCode in (:rptCodes))
		if ((SQLCODE'=0) && (SQLCODE'=100)) TROLLBACK  w "{success:true,tip:'删除MMgrKPICfg失败！',SQLCODE:"_SQLCODE_"}" q		
		*/
	TCOMMIT

		w "{success:true,tip:'ok'}"
		q 1
		
ErrorDel
		TROLLBACK  
		//Do DisplayError^%apiOBJ(sc)
		w "{success:true,tip:'删除MMRptCfg失败！',SQLCODE:"_0_"}" 
		q 0
		//s ErrorMsg=$ZE
		//Quit "ErrorSave"_ErrorMsg
}

// s a=##class(DHCWL.ModuleManageServ.MMServ).delRptset("'3','4'","root.WHDSRMYY.MZSR")

ClassMethod delDataset(dsCodes As %String, rptCode As %String, treeCode As %String) As %Integer
{
	b
	s $zt="ErrorDel"	
	
	TSTART
		//s Sql="select * from DHCWL_MKPI.MMgrModuleCfg where modulecfg_treecode in ("_modeIDs_")"
		s Sql="delete from DHCWL_MKPI.MMgrDatasetCfg where DatasetCfg_RptCode='"_rptCode_"' and DatasetCfg_TreeCode='"_treeCode_"' and DatasetCfg_Code in ("_dsCodes_")"
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()

		s Sql="delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_RptCode='"_rptCode_"' and KPICfg_TreeCode='"_treeCode_"' and KPICfg_DatasetCode in ("_dsCodes_")"
		s st=Rs.Prepare(Sql)  if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()
		

	TCOMMIT

		w "{success:true,tip:'ok'}"
		q 1
		
ErrorDel
		TROLLBACK  
		//Do DisplayError^%apiOBJ(sc)
		w "{success:true,tip:'MMgrModuleCfg失败！',SQLCODE:"_0_"}" 
		q 0
		//s ErrorMsg=$ZE
		//Quit "ErrorSave"_ErrorMsg
}

/// 名称: getKpiCodesByTreeCode
/// 描述: 得到某个模块树节点下包含的指标CODE。
/// 参数: treeCode——树节点的树形编码
/// 	  	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的指标CODE
/// 编写者： 王峥
/// 编写日期:2014-1-24
/// s a=##class(DHCWL.ModuleManageServ.MMServ).IsAncestor("root","root.WHET.ZYSR")
ClassMethod getKpiCodesByTreeCode(treeCode As %String, validTreeCodes As %String = "Null", validRptCodes As %String = "Null", validDSCodes As %String = "Null", validKPICodes As %String = "Null") As %String
{
	//Index TRDKIdx On (KPITreeCode, KPIRptCode, KPIDatasetCfgCode, KPICfgCode);
	b
	s retStr=""
	i '$d(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode)) q retStr
	s kpiRptCode=""
	s kpiRptCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,kpiRptCode))
	while kpiRptCode'="" {
		//if ((validRptCodes'="Null") && ('..IsIn(kpiRptCode,validRptCodes,","))) continue
		if ((validRptCodes="Null") || (..IsIn(kpiRptCode,validRptCodes,","))) {
			s kpiDsCfgCode=""
			s kpiDsCfgCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,kpiRptCode,kpiDsCfgCode))
			while kpiDsCfgCode'="" {
				//if ((validDSCodes'="Null") && ('..IsIn(kpiDsCfgCode,validDSCodes,","))) continue
				if ((validDSCodes="Null") || (..IsIn(kpiDsCfgCode,validDSCodes,","))) { 
					s kpiCfgCode=""
					s kpiCfgCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,kpiRptCode,kpiDsCfgCode,kpiCfgCode))
					while kpiCfgCode'="" {
						if ((validKPICodes="Null") || (..IsIn(kpiCfgCode,validKPICodes,","))) { 
							//if retStr'="" s retStr=retStr_","
							//s retStr=retStr_kpiCfgCode
							if $g(kpiCfgCode)'="" {
								s ^TEMPDHCWL($j,"kpiCodes",kpiCfgCode)=1
								s ^TEMPDHCWL($j,"kpiCodes-chk",treeCode,kpiRptCode,kpiDsCfgCode,kpiCfgCode)=1
							}
						}
						s kpiCfgCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,kpiRptCode,kpiDsCfgCode,kpiCfgCode))
					}
				}
				s kpiDsCfgCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,kpiRptCode,kpiDsCfgCode))	
			}
		}
		s kpiRptCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,kpiRptCode))
	}

	q 0
	//q retStr
}

/*
ClassMethod handleData(objType As %String, objAttrib As %String, objValue As %String, leafNodes As %String, startDate As %String, endDate As %String, ActType As %String)
{
	B
	s validTreeCodes="Null"
	s validRptCodes="Null"
	s validDSCodes="Null"
	s validKPICodes="Null"
	
	if objType="报表" {
		s validRptCodes=..GetSearchedRpt(objType,objAttrib,objValue)
	}
	if objType="数据集" {
		s validDSCodes=..GetSearchedDs(objType,objAttrib,objValue)
	}
	if objType="指标" {
		
	}

	s kpiCodes=""
	for i=1:1:$l(leafNodes,",") {
		s treeCode=$p(leafNodes,",",i)
		if kpiCodes'="" s kpiCodes=kpiCodes_","
		s kpiCodes=kpiCodes_..getKpiCodesByTreeCode(treeCode,validTreeCodes,validRptCodes,validDSCodes,validKPICodes)
	}
	
	w !,kpiCodes
	if ActType="produceData" {
		s ret=##class(DHCWL.Interface.Interface).CreateKpiData(kpiCodes,startDate,endDate)
		q ret
	}
	if ActType="reproduceData" {
		s ret=##class(DHCWL.Interface.Interface).CreateKpiData(kpiCodes,startDate,endDate,1)
		q ret
	}
	if ActType="cleanData" {
		s ret=##class(DHCWL.Interface.Interface).DeleteKpiData(kpiCodes,startDate,endDate)
		q ret
	}
}
*/
/// 名称: getKpiCodesByTreeCode
/// 描述: 得到某个模块树节点下包含的指标CODE。
/// 参数: treeCode——树节点的树形编码
/// 	  	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的指标CODE
/// 编写者： 王峥
/// 编写日期:2014-1-24
/// s a=##class(DHCWL.ModuleManageServ.MMServ).IsAncestor("root","root.WHET.ZYSR")
/// 名称: handleData2
/// 描述: 得到某个模块树节点下包含的指标CODE。
/// 参数:   objType——查询条件中的对象类型，如“模块”、“报表”、“数据集”
/// 	    objAttrib——查询条件中的对象属性，如“编码“、”描述“
/// 		   	objValue————查询条件中的对象值
/// 			TreeNodes————前台页面勾选的树节点集合
/// 			RptCodes————前台页面勾选的报表的集合
/// 			KPICodes————前台页面勾选的数据集的集合
/// 			startDate————开始日期
/// 			endDate————结束日期
/// 			actType————操作类型：produceData：生成数据；reproduceData：重生数据；cleanData：清除数据
/// 			actFrom————发出请求的panel。包括：模块树，报表，数据集
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的指标CODE
/// 编写者： 王峥
/// 编写日期:2014-1-24
/// s a=##class(DHCWL.ModuleManageServ.MMServ).IsAncestor("root","root.WHET.ZYSR")
/// ClassMethod handleDataOrCheck(objType As %String, objAttrib As %String, objValue As %String, TreeNodes As %String, RptCodes As %String, KPICodes As %String, startDate As %String, endDate As %String, actType As %String, actFrom As %String)
ClassMethod handleDataOrCheck(objType As %String, objAttrib As %String, objValue As %String, TreeNodes As %String, RptCodes As %String, KPICodes As %String, startDate As %String, endDate As %String, actType As %String, actFrom As %String, actFlag As %String, dateSecType As %String, dataFlag As %String = "")
{
	k ^TEMPDHCWL($j,"kpiCodes")
	s validTreeCodes="Null"
	s validRptCodes="Null"
	s validDSCodes="Null"
	s validKPICodes="Null"
	if actFrom="module" {
		if objType="报表" {
			s validRptCodes=..GetSearchedRpt(objType,objAttrib,objValue)
		}
		if objType="数据集" {
			s validDSCodes=..GetSearchedDs(objType,objAttrib,objValue)
		}
		if objType="指标" {
			s validKPICodes=..GetSearchedKPIs(objType,objAttrib,objValue)
		}
	}
	if actFrom="report" {

		s validRptCodes=RptCodes

		if objType="数据集" {
			s validDSCodes=..GetSearchedDs(objType,objAttrib,objValue)
		}
		if objType="指标" {
			s validKPICodes=..GetSearchedKPIs(objType,objAttrib,objValue)
		}
	}

	if actFrom="dataset" {
		//s kpiCodes=KPICodes
		i $g(KPICodes)="" q 0
		s len=$l($g(KPICodes),",")
		for i=1:1:len {
			s kpiCode=$p(KPICodes,",",i)
			s ^TEMPDHCWL($j,"kpiCodes",kpiCode)=1
		}
	}else{
		s kpiCodes=""
		for i=1:1:$l(TreeNodes,",") {
			s treeCode=$p(TreeNodes,",",i)
			//s kpiCode=..getKpiCodesByTreeCode(treeCode,validTreeCodes,validRptCodes,validDSCodes,validKPICodes)
			//if $g(kpiCode)'="" {
			//	if kpiCodes'="" s kpiCodes=kpiCodes_","
			//	s kpiCodes=kpiCodes_kpiCode
			//}
			d ..getKpiCodesByTreeCode(treeCode,validTreeCodes,validRptCodes,validDSCodes,validKPICodes)
			//s kpiCodes=kpiCodes_..getKpiCodesByTreeCode(treeCode,validTreeCodes,validRptCodes,validDSCodes,validKPICodes)
		}
	}
	
	s kpiCode=""
	s kpiCodes=""
	s count=0
	s data=""
	
	f  {
		//Index KTRDIdx On (KPICfgCode, KPITreeCode, KPIRptCode, KPIDatasetCfgCode);
		s kpiCode=$o(^TEMPDHCWL($j,"kpiCodes",kpiCode)) 
		q:kpiCode=""
		i kpiCodes'="" s kpiCodes=$g(kpiCodes)_","
		s kpiCodes=$g(kpiCodes)_kpiCode 
		s treeCode=""
		f {
			s treeCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",kpiCode,treeCode))
			q:treeCode=""
			s rptCode=""
			f {
				s rptCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",kpiCode,treeCode,rptCode))
				q:rptCode=""
				s dsCode=""
				
				f {
					s dsCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",kpiCode,treeCode,rptCode,dsCode))
					q:dsCode=""
					q:$d(^TEMPDHCWL($j,"kpiCodes-chk",treeCode,rptCode,dsCode,kpiCode))
					if count>0 s data=data_","
					s data=data_"["""_kpiCode_""","""_treeCode_""","""_rptCode_""","""_dsCode_"""]"
					s count=count+1
				}
				
			}
			
		}
	
	}
	

	
	if (actFlag=1) {
		w "{success:true,tip:'ok',root:["_data_"],kpiCodes:"""_kpiCodes_"""}"
	}

	//调试用
	s usedDebug=0
	if ($g(usedDebug)=1 ) {
		w !,"actType="_actType_"  kpiCodes="_kpiCodes_"   dateSecType="_dateSecType
		q 1
	}
	
	if ((actFlag=2)&&(actType'="cleanData")) {
		/*s ret= ..handleData(kpiCodes,actType,startDate,endDate,dateSecType)
		if (ret'=0) {
			w "{success:true,tip:'操作失败！'}"		
		}else{
			w "{success:true,tip:'ok'}"
		}*/
		d ..handleData(kpiCodes,actType,startDate,endDate,dateSecType,dataFlag)
		w "{success:true,tip:'ok',dataFlag:"_dataFlag_"}"

	}else{
		if ((actFlag=2)&&(actType="cleanData")){
			s ret= ..handleData(kpiCodes,actType,startDate,endDate,dateSecType)
			if (ret'=0) {
				w "{success:true,tip:'操作失败！'}"		
			}else{
				w "{success:true,tip:'ok'}"
		}
		}
	}	
	k ^TEMPDHCWL($j,"kpiCodes")
	k ^TEMPDHCWL($j,"kpiCodes-chk")

	
	q 0
}

/// 名称: getKpiCodesByTreeCode
/// 描述: 得到某个模块树节点下包含的指标CODE。
/// 参数: treeCode——树节点的树形编码
/// 	  	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的指标CODE
/// 编写者： 王峥
/// 编写日期:2014-1-24
/// s a=##class(DHCWL.ModuleManageServ.MMServ).IsAncestor("root","root.WHET.ZYSR")
/// 名称: handleData2
/// 描述: 得到某个模块树节点下包含的指标CODE。
/// 参数:   objType——查询条件中的对象类型，如“模块”、“报表”、“数据集”
/// 	    objAttrib——查询条件中的对象属性，如“编码“、”描述“
/// 		   	objValue————查询条件中的对象值
/// 			TreeNodes————前台页面勾选的树节点集合
/// 			RptCodes————前台页面勾选的报表的集合
/// 			KPICodes————前台页面勾选的数据集的集合
/// 			startDate————开始日期
/// 			endDate————结束日期
/// 			actType————操作类型：produceData：生成数据；reproduceData：重生数据；cleanData：清除数据
/// 			actFrom————发出请求的panel。包括：模块树，报表，数据集
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的指标CODE
/// 编写者： 王峥
/// 编写日期:2014-1-24
/// s a=##class(DHCWL.ModuleManageServ.MMServ).IsAncestor("root","root.WHET.ZYSR")
/// ClassMethod handleData2(objType As %String, objAttrib As %String, objValue As %String, TreeNodes As %String, RptCodes As %String, KPICodes As %String, startDate As %String, endDate As %String, actType As %String, actFrom As %String)
ClassMethod handleData(kpiCodes As %String, actType As %String, startDate As %String, endDate As %String, dateSecType As %String, dataFlag As %String = "")
{
		//调试用
	s usedDebug=0
	if ($g(usedDebug)=1 ) {
		w !,"actType="_actType_"  kpiCodes="_kpiCodes_"   dateSecType="_dateSecType
		q 1
	}

	if actType="produceData" {
		//s ret=##class(DHCWL.Interface.MkpiData).CreateKpiData(kpiCodes,startDate,endDate)
		//job ##class(DHCWL.Interface.MkpiData).CreateKpiData(kpiCodes,startDate,endDate,0,dataFlag)
		job ##class(DHCWL.Interface.MkpiData).GetKpiDataProgress(startDate,endDate,kpiCodes,0)
		//q ret
	}
	if actType="reproduceData" {
		//job ##class(DHCWL.Interface.MkpiData).CreateKpiData(kpiCodes,startDate,endDate,1,dataFlag)
		job ##class(DHCWL.Interface.MkpiData).GetKpiDataProgress(startDate,endDate,kpiCodes,1)
		//q ret
	}
	if actType="cleanData" {
		//s ret=##class(DHCWL.Interface.MkpiData).DeleteKpiData(kpiCodes,startDate,endDate,dateSecType)
		s ret=##class(DHCWL.Interface.MkpiData).DeleteKpiData(kpiCodes,startDate,endDate,dateSecType)
		q ret
	}
}

/// 名称: IsIn
/// 描述: 某个字符串是否包含于另一个字符串中。
/// 参数: r——源字符串
/// 			d——目标字符串
/// 			delimiter——分隔符
/// 	  	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的指标CODE
/// 编写者： 王峥
/// 编写日期:2014-1-24
/// s a=##class(DHCWL.ModuleManageServ.MMServ).IsAncestor("root","root.WHET.ZYSR")
ClassMethod IsIn(r As %String, d As %String, delimiter As %String) As %Boolean
{
	s ret=0
	for i=1:1:$l(d,delimiter) {
		s t=$p(d,delimiter,i)
		if r=t {
			s ret=1
			q 
		}
	}
	
	q ret
}

/// 名称: GetModuleAncestorsByCode
/// 描述: 根据模块的编码来模糊查找模块的祖先节点的Treecode。
/// 参数: modeCode——模块的编码
/// 	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
ClassMethod exportModules(treeCodes As %String, reportCodes As %String, actFrom As %String, objType As %String, objAttrib As %String, objValue As %String) As %String
{
	s validRptCodes=""
	s validDsCodes=""
	s validKpiCodes=""

	s usedDebug=0
	if actFrom="module" {
		if ((objType'="") &&(objType'="模块") && (objAttrib'="") && (objValue'="")) {
			s validRptCodes=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedRpt(objType,objAttrib,objValue)
		}
	}
	
	if actFrom="report" {
		s validRptCodes=reportCodes
	}
	
	if (((objType="数据集") ||(objType="指标")) && (objAttrib'="") && (objValue'="")) {
		s validDsCodes=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedDs(objType,objAttrib,objValue)
	}



	if (((objType="指标")) && (objAttrib'="") && (objValue'="")) {
		s validKpiCodes=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedKPIs(objType,objAttrib,objValue)
	}
	
	s Ancestors=..GetfirsthalfSubStr(treeCodes)
	//w !,"Ancestors="_Ancestors
	s newAnces=""
	for i=1:1:$l(Ancestors,",") {
		s isSame=0
		s ance=$p(Ancestors,",",i)
		for j=1:1:$l(treeCodes,",") {
			s sel=$p(treeCodes,",",j)
			if ance=sel s isSame=1
			
		}
		if isSame=0 {
			if newAnces'="" s newAnces=newAnces_","
			s newAnces=newAnces_ance	
		}
	}
	s Ancestors=newAnces
	//w !,"Ancestors="_Ancestors
	s list=##Class(%Library.ListOfObjects).%New()
	//加入祖先节点
	if ($g(Ancestors)'="") {
		//f modeInd=$l(Ancestors,","):-1:1 {
		  f modeInd=2:1:$l(Ancestors,",") {	
			s moduleCode=$p(Ancestors,",",modeInd)
			//continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModeCfgCodeUnqIdx1",moduleCode)))
			continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode)))
			s moduleId=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode,""))
			s moduleObj=##class(DHCWL.MKPI.MMgrModuleCfg).%OpenId(moduleId)
			continue:moduleObj=""
			d list.Insert(moduleObj)
			if $g(usedDebug)=1	w !,"module:"_moduleObj.ModuleCfgTreeCode
		}
	}
	//加入勾选的树节点
	//b
	//f modeInd=$l(treeCodes,","):-1:1 {
	f modeInd=1:1:$l(treeCodes,",") {
		s moduleCode=$p(treeCodes,",",modeInd)
		//continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModeCfgCodeUnqIdx1",moduleCode)))
		continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode)))
		s moduleId=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode,""))
		s moduleObj=##class(DHCWL.MKPI.MMgrModuleCfg).%OpenId(moduleId)
		continue:moduleObj=""
		d list.Insert(moduleObj)
		if $g(usedDebug)=1	w !,"module:"_moduleObj.ModuleCfgTreeCode
		//加入报表
		s goOn=0
		s rptCfgCode="" //,alphmoduleCode=$SYSTEM.SQL.ALPHAUP(moduleCode)
		f  {
			//b
			s rptCfgCode=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",moduleCode,rptCfgCode))
			q:rptCfgCode=""
			//if ((objType'="模块") && (objAttrib'="") && (objValue'="")) {	;--modify by wz.2014-4-30
			if (((objType'="模块") && (objAttrib'="") && (objValue'="")) || ($g(validRptCodes)'="") ) {	;--modify by wz.2014-4-30
				if ..IsIn(rptCfgCode,validRptCodes,",") {
					s goOn=1
				}else{
					s goOn=0
				}
			}
			if ((((objType="") && (objAttrib="") && (objValue="")) || (objType="模块")) && (($g(validRptCodes)="")) ) {
				s goOn=1
			}
			if goOn=0 continue
			s rptId=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",moduleCode,rptCfgCode,""))
			s rptObj=##class(DHCWL.MKPI.MMgrRptCfg).%OpenId(rptId)
			continue:rptObj=""
			d list.Insert(rptObj)
			if $g(usedDebug)=1	w !,"rptObj:"_rptObj.RptCfgCode
			//加入数据集
			s DSCfgCode="" 
			f  {
				//^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",
				s DSCfgCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCfgCode,DSCfgCode))
				q:DSCfgCode=""
				
				if (((objType="") && (objAttrib="") && (objValue="")) ||(objType="模块") || (objType="报表")) {
					s goOn=1
				}
				if (((objType="数据集") ||(objType="指标")) && (objAttrib'="") && (objValue'="")) {
					if ..IsIn(DSCfgCode,validDsCodes,",") {
						s goOn=1
					}else{
						s goOn=0
					}
				}
				if goOn=0 continue
				s DSId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCfgCode,DSCfgCode,""))
				s DSObj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(DSId)
				continue:DSObj=""
				
				//modify by wk.2016-2-15.对&进行转义。
			    //s filterList=$REPLACE(DSObj.DatasetFilterList,"&","&amp;amp;amp;")
			    ;s filterList=$REPLACE(DSObj.DatasetFilterList,"&","this is ENG AND.I HATE IT")
			     //s filterList=$REPLACE(DSObj.DatasetFilterList,"&","&amp")
				//s DSObj.filterList=ruleList
				;s DSObj.DatasetFilterList=filterList
				
				
				d list.Insert(DSObj)
				if $g(usedDebug)=1	w !,"DSObj:"_DSObj.DatasetCfgCode
				//加入指标
				/*s KpiCode="" 
				f  {
					s KpiCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",moduleCode,rptCfgCode,DSCfgCode,KpiCode))
					q:KpiCode=""
					
					if (((objType="") && (objAttrib="") && (objValue="")) ||(objType="模块") || (objType="报表") || (objType="数据集")) {
						s goOn=1
					}
					if (((objType="指标")) && (objAttrib'="") && (objValue'="")) {
						if ..IsIn(KpiCode,validKpiCodes,",") {
							s goOn=1
						}else{
							s goOn=0
						}
					}
					
					
					if goOn=0 continue
					
					s kpiId=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",moduleCode,rptCfgCode,DSCfgCode,KpiCode,""))
					s kpiObj=##class(DHCWL.MKPI.MMgrKPICfg).%OpenId(kpiId)
					continue:kpiObj=""
					d list.Insert(kpiObj)
					if $g(usedDebug)=1	w !,"KPICfgCode:"_kpiObj.KPICfgCode
					//加入维度及其他
					
					//s mkpiRule=kpiObj.KPICfgCode
					d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiObj.KPICfgCode,,.resolve)
					s mkpis=resolve("$PARAMKPI")
					s sysMkpiList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiSystemList(mkpis)
					s sysMkpiLen=sysMkpiList.Count()
					f sysMkpiInd=1:1:sysMkpiLen {
						d list.Insert(sysMkpiList.GetAt(sysMkpiInd))
					}
					
				}*/
			}
		}
	}
	b
	//d ##class(DHCWL.MKPIIO.DefaultOutService).OutputMKPIToStream(list,.outStream)
	s service=##class(DHCWL.ModuleManageServ.ModuleOutputIF).%New()
	d ##class(DHCWL.MKPIIO.util.Write).WriteXML(list,.service,,.outStream,"module")
	
	Set sc =##class(%XML.TextReader).ParseStream(outStream,.reader)
	If $$$ISERR(sc) {
		D DecomposeStatus^%apiOBJ(sc,.err,"-d") 
		w "导出错误:"
		For i=1:1:err Write err(i),! 
		q
	}

	d ##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToStr(reader)
	q
}

ClassMethod getExportInfor(treeCodes As %String, reportCodes As %String, actFrom As %String, objType As %String, objAttrib As %String, objValue As %String)
{
	s validRptCodes=""
	s validDsCodes=""
	s validKpiCodes=""

	s usedDebug=0
	if actFrom="module" {
		if ((objType'="") &&(objType'="模块") && (objAttrib'="") && (objValue'="")) {
			s validRptCodes=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedRpt(objType,objAttrib,objValue)
		}
	}
	
	if actFrom="report" {
		s validRptCodes=reportCodes
	}
	
	if (((objType="数据集") ||(objType="指标")) && (objAttrib'="") && (objValue'="")) {
		s validDsCodes=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedDs(objType,objAttrib,objValue)
	}



	if (((objType="指标")) && (objAttrib'="") && (objValue'="")) {
		s validKpiCodes=##class(DHCWL.ModuleManageServ.MMServ).GetSearchedKPIs(objType,objAttrib,objValue)
	}
	
	s Ancestors=..GetfirsthalfSubStr(treeCodes)
	//w !,"Ancestors="_Ancestors
	s newAnces=""
	for i=1:1:$l(Ancestors,",") {
		s isSame=0
		s ance=$p(Ancestors,",",i)
		for j=1:1:$l(treeCodes,",") {
			s sel=$p(treeCodes,",",j)
			if ance=sel s isSame=1
			
		}
		if isSame=0 {
			if newAnces'="" s newAnces=newAnces_","
			s newAnces=newAnces_ance	
		}
	}
	s Ancestors=newAnces
	//w !,"Ancestors="_Ancestors
	s list=##Class(%Library.ListOfObjects).%New()
	//加入祖先节点
	if ($g(Ancestors)'="") {
		//f modeInd=$l(Ancestors,","):-1:1 {
		  f modeInd=2:1:$l(Ancestors,",") {	
			s moduleCode=$p(Ancestors,",",modeInd)
			//continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModeCfgCodeUnqIdx1",moduleCode)))
			continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode)))
			s moduleId=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode,""))
			s moduleObj=##class(DHCWL.MKPI.MMgrModuleCfg).%OpenId(moduleId)
			continue:moduleObj=""
			d list.Insert(moduleObj)
			if $g(usedDebug)=1	w !,"module:"_moduleObj.ModuleCfgTreeCode
		}
	}
	//加入勾选的树节点
	//b
	//f modeInd=$l(treeCodes,","):-1:1 {
	f modeInd=1:1:$l(treeCodes,",") {
		s moduleCode=$p(treeCodes,",",modeInd)
		//continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModeCfgCodeUnqIdx1",moduleCode)))
		continue:('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode)))
		s moduleId=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",moduleCode,""))
		s moduleObj=##class(DHCWL.MKPI.MMgrModuleCfg).%OpenId(moduleId)
		continue:moduleObj=""
		d list.Insert(moduleObj)
		if $g(usedDebug)=1	w !,"module:"_moduleObj.ModuleCfgTreeCode
		//加入报表
		s goOn=0
		s rptCfgCode="" //,alphmoduleCode=$SYSTEM.SQL.ALPHAUP(moduleCode)
		f  {
			//b
			s rptCfgCode=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",moduleCode,rptCfgCode))
			q:rptCfgCode=""
			//if ((objType'="模块") && (objAttrib'="") && (objValue'="")) {	;--modify by wz.2014-4-30
			if (((objType'="模块") && (objAttrib'="") && (objValue'="")) || ($g(validRptCodes)'="") ) {	;--modify by wz.2014-4-30
				if ..IsIn(rptCfgCode,validRptCodes,",") {
					s goOn=1
				}else{
					s goOn=0
				}
			}
			if ((((objType="") && (objAttrib="") && (objValue="")) || (objType="模块")) && (($g(validRptCodes)="")) ) {
				s goOn=1
			}
			if goOn=0 continue
			s rptId=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",moduleCode,rptCfgCode,""))
			s rptObj=##class(DHCWL.MKPI.MMgrRptCfg).%OpenId(rptId)
			continue:rptObj=""
			d list.Insert(rptObj)
			if $g(usedDebug)=1	w !,"rptObj:"_rptObj.RptCfgCode
			//加入数据集
			s DSCfgCode="" 
			f  {
				//^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",
				s DSCfgCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCfgCode,DSCfgCode))
				q:DSCfgCode=""
				
				if (((objType="") && (objAttrib="") && (objValue="")) ||(objType="模块") || (objType="报表")) {
					s goOn=1
				}
				if (((objType="数据集") ||(objType="指标")) && (objAttrib'="") && (objValue'="")) {
					if ..IsIn(DSCfgCode,validDsCodes,",") {
						s goOn=1
					}else{
						s goOn=0
					}
				}
				if goOn=0 continue
				s DSId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCfgCode,DSCfgCode,""))
				s DSObj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(DSId)
				continue:DSObj=""
				d list.Insert(DSObj)
				if $g(usedDebug)=1	w !,"DSObj:"_DSObj.DatasetCfgCode
				//加入指标
				s KpiCode="" 
				f  {
					s KpiCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",moduleCode,rptCfgCode,DSCfgCode,KpiCode))
					q:KpiCode=""
					
					if (((objType="") && (objAttrib="") && (objValue="")) ||(objType="模块") || (objType="报表") || (objType="数据集")) {
						s goOn=1
					}
					if (((objType="指标")) && (objAttrib'="") && (objValue'="")) {
						if ..IsIn(KpiCode,validKpiCodes,",") {
							s goOn=1
						}else{
							s goOn=0
						}
					}
					
					
					if goOn=0 continue
					
					s kpiId=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",moduleCode,rptCfgCode,DSCfgCode,KpiCode,""))
					s kpiObj=##class(DHCWL.MKPI.MMgrKPICfg).%OpenId(kpiId)
					continue:kpiObj=""
					d list.Insert(kpiObj)
					if $g(usedDebug)=1	w !,"KPICfgCode:"_kpiObj.KPICfgCode
					//加入维度及其他
					
					//s mkpiRule=kpiObj.KPICfgCode
					d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiObj.KPICfgCode,,.resolve)
					s mkpis=resolve("$PARAMKPI")
					s sysMkpiList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiSystemList(mkpis)
					s sysMkpiLen=sysMkpiList.Count()
					f sysMkpiInd=1:1:sysMkpiLen {
						d list.Insert(sysMkpiList.GetAt(sysMkpiInd))
					}
					
				}
			}
		}
	}
	q list
}

ClassMethod JsonKpi(xmlPath, ByRef mkpiArr, checkFlag As %Boolean = 0) As %String
{


	//b
	//n (xmlPath,mkpiArr,checkFlag)
	k mkpiArr
	K ^TEMPDHCWL($j,"MODULEIMP")
	s NO=0
	Set sc =##class(%XML.TextReader).ParseFile(xmlPath,.reader)
	s version=##class(DHCWL.MKPIIO.util.Read).GetXmlVersion(xmlPath)
	s generator=..GetXmlGenerator(xmlPath)
	//w "generator="_generator
	q:(generator'="module")
	if ($d(^DHCWL.MKPI.SetConfig("NewIOConfigVersion"))) s ioConfigVersion=^DHCWL.MKPI.SetConfig("NewIOConfigVersion")
	else  s ioConfigVersion=3.22
	if (version<ioConfigVersion){
		 d ##class(DHCWL.MKPIIO.InputFromXML).InputFromXMLChecked(xmlPath,checkFlag)
		 q
	}
	//b
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s cnt=reader.AttributeCountGet()
				if (cnt>=3){
					if (reader.MoveToAttributeName("ClassFullName")){
						s class=reader.Value
						if (reader.MoveToAttributeName("PrimaryFieldValue")){
							s primaryValue=reader.Value
							s mkpiArr(class,primaryValue)=""
							//b
							/*
							if (class="DHCWL.MKPI.MKPI"){
								s mkpiCode=primaryValue
							}
							*/
							if ((class="DHCWL.MKPI.MMgrKPICfg")||(class="DHCWL.MKPI.MMgrModuleCfg")||(class="DHCWL.MKPI.MMgrRptCfg")||(class="DHCWL.MKPI.MMgrDataSetCfg")) {
								s KeyCode=primaryValue
								s NO=NO+1
							}
							
						}
					}
				}
				d reader.MoveToElement()
	   		}
		}elseif (reader.NodeType="chars"){
			/*
			if (nodeName="MKPIName"){
				s mkpiArr("DHCWL.MKPI.MKPI",mkpiCode)=reader.Value
			}
			*/
			//b
			if ((class="DHCWL.MKPI.MMgrKPICfg")||(class="DHCWL.MKPI.MMgrModuleCfg")||(class="DHCWL.MKPI.MMgrRptCfg")||(class="DHCWL.MKPI.MMgrDataSetCfg")) {
				//s mkpiArr(class,KeyCode,nodeName)=reader.Value
				s ^TEMPDHCWL($j,"MODULEIMP",NO,class,KeyCode,nodeName)=reader.Value
			}
		}
	}
	//b
	
	s className=""
	s primaryValue=""
	s fieldName=""
	s filedValue=""
	s NO=0
	s jsonData=""
	s jsonDatas=""
	
	//导入前检查
	if (checkFlag){
		w "{success:true,data:["
		f {
			s NO=$o(^TEMPDHCWL($j,"MODULEIMP",NO))
			q:NO=""
			s className=""
			f {
				s className=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className))
				q:className=""
				s primaryValue=""
				f {
					s primaryValue=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue))
					q:primaryValue=""
					s jsonData="{""className"":"""_className_""""
					s fields=""
					k ^TEMPDHCWL($j,"MODULEIMP","CHECK")
					s fieldName=""
					f {
						s fieldName=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue,fieldName))
						q:fieldName=""
						s ^TEMPDHCWL($j,"MODULEIMP","CHECK",fieldName)=^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue,fieldName)
						
						s fields=fields_ ","
						s fields=fields_""""_fieldName_""":"""_^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue,fieldName)_""""
					}
					//b
					if (className="DHCWL.MKPI.MMgrModuleCfg") {
						s treeCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","ModuleCfgTreeCode")
						i '$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode)) {
							s fields=""
							s jsonData=""
							continue
						} 
						else  
						{
							s jsonData=jsonData_fields_"}"
						}

					}elseif(className="DHCWL.MKPI.MMgrRptCfg") {
						s treeCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","RptCfgTreeCode")
						s rptCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","RptCfgCode")
						i '$d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode)) {
							s fields=""
							s jsonData=""
							continue
						} 
						else  
						{
							s jsonData=jsonData_fields_"}"
						}
					}elseif(className="DHCWL.MKPI.MMgrDataSetCfg") {
						s treeCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","DatasetTreeCode")
						s rptCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","DatasetRptCode")
						s datasetCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","DatasetCfgCode")
						i '$d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,datasetCode)) {
							s fields=""
							s jsonData=""
							continue
						} 
						else  
						{
							s jsonData=jsonData_fields_"}"
						}
					}elseif(className="DHCWL.MKPI.MMgrKPICfg") {
						s treeCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","KPITreeCode")
						s rptCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","KPIRptCode")
						s datasetCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","KPIDatasetCfgCode")
						s kpiCode=^TEMPDHCWL($j,"MODULEIMP","CHECK","KPICfgCode")
						//i '$d(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,rptCode,datasetCode,kpiCode)) {
						s code=$zcvt(kpiCode,"U")
						i '$d(^DHCWL.MKPI.MKPII("MKPICode"," "_code))&&('$d(^DHCWL.MKPI.MKPII("MKPICode",code))) {	
							s fields=""
							s jsonData=""
							continue
						} 
						else  
						{
							s jsonData=jsonData_fields_"}"
						}
						
						
					}
				}
				i jsonData'="" {
					//i jsonDatas'="" s jsonDatas=jsonDatas_","
					//s jsonDatas=jsonDatas_jsonData
					//modify by wangkai 2016-02-16.解决json串溢出
					i jsonDatas="" {
						s jsonDatas=jsonDatas_jsonData
						w jsonData
					}else{
						w ","_jsonData
					}
				}
			}
		}
		//modify by wk 2016-02-16
		//w $g(jsonDatas)
		w "]}"
		q
		
		
		
		/*
		s num=0
		w "{success:true,root:["
		s mkpi=""
		f {
			s mkpi=$o(mkpiArr("DHCWL.MKPI.MKPI",mkpi))
			q:mkpi=""
			s mkpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(mkpi,"DHCWL.MKPI.MKPI")
			if (mkpiId'=""){
				i num>0 w ","
				w "{className:'DHCWL.MKPI.MKPI',propertyCode:'"_mkpi_"',codeValue:'"_mkpi_"',id:'"_mkpiId_"'}"
				s num=num+1
			}
		}
		w "],totalNum:"_num_"}"
		q
		*/
	}
	
	s className=""
	s primaryValue=""
	s fieldName=""
	s filedValue=""
	s NO=0
	s jsonData=""
	s jsonDatas=""

	w "["
	f {
		s NO=$o(^TEMPDHCWL($j,"MODULEIMP",NO))
		q:NO=""
		s className=""
		f {
			s className=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className))
			q:className=""
			s primaryValue=""
			f {
				s primaryValue=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue))
				q:primaryValue=""
				//s jsonData="{""className"":"""_className_""""
				s jsonData="{""className"":"""_className_""""_",""primaryValue"":"""_primaryValue_""""
				b
				s fieldName=""
				f {
					s fieldName=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue,fieldName))
					q:fieldName=""
					s jsonData=jsonData_ ","
					s jsonData=jsonData_""""_fieldName_""":"""_^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue,fieldName)_""""
				}
				s jsonData=jsonData_"}"
			}

			i jsonData'="" {
				//modify by wangkai 2016-02-16.解决json串溢出
				//i jsonDatas'="" s jsonDatas=jsonDatas_","
				//s jsonDatas=jsonDatas_jsonData
				i jsonDatas="" {
					s jsonDatas=jsonDatas_jsonData
					w jsonData
				}else{
					w ","_jsonData
				}	
			}

			/*
			i jsonDatas'="" s jsonDatas=jsonDatas_","
			s jsonDatas=jsonDatas_jsonData
			*/
		}
	}
	//w $g(jsonDatas)
	w "]"
	b	
	K ^TEMPDHCWL($j,"MODULEIMP")
	q
}

ClassMethod InputXML(path) As %Status
{
	//n (path)
	b
	s inService=##class(DHCWL.ModuleManageServ.ModuleInputServ).%New()
	;w "path="_path,!
	s sc= ##class(DHCWL.MKPIIO.util.Read).ReadStructNode(path,.inService)
	q sc
}

ClassMethod GetXmlGenerator(path = "", ByRef stream As %Library.FileBinaryStream = "") As %String
{
	//n (path,stream)
	if (path'=""){
		Set sc =##class(%XML.TextReader).ParseFile(path,.reader)
	}else{
		Set sc =##class(%XML.TextReader).ParseStream(stream,.reader)
	}
	if ($$$ISERR(sc)){ 
		d $system.OBJ.DisplayError(sc) 
		q "解析文档失败，请检查XML文档的格式"
	}
	s version=0,ok=0
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
					d reader.MoveToAttributeIndex(i)
					if ($zcvt(reader.Name,"U")="GENERATOR"){
						s version=reader.Value
						s ok=1
						q
					}
				}
			}
		}
		q:ok=1
	}
	d reader.Rewind()
	q version
}

/// 名称: GetModuleAncestorsByCode
/// 描述: 根据模块的编码来模糊查找模块的祖先节点的Treecode。
/// 参数: modeCode——模块的编码
/// 	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
ClassMethod ActivateKPITaskOld(moduleNodes, rptNodes, dsNodes, actFrom) As %Integer
{
	//n (moduleNodes,rptNodes,dsNodes,actFrom)
	s $zt="ActivateKPITaskERR"
	s kpiCodes=""
	if actFrom="module" {
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByModuleTCode(moduleNodes)
	}elseif(actFrom="report"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByRptCode(moduleNodes,rptNodes)
	}elseif(actFrom="dataset"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByDsCode(moduleNodes,rptNodes,dsNodes)
	}
	
	s kpiCnt=$l(kpiCodes,",")
	s DTaskKpiIDs=""
	s Rs=##class(%Library.ResultSet).%New()

	f i=1:1:kpiCnt {
		s kpiCode=$p(kpiCodes,",",i)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		q:kpiId=""
		s actFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,""))
		q:actFlag="Y"
		s DTaskID=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,actFlag,""))
		q:'$d(^DHCWL.MKPI.CreatDataTaskD(DTaskID))
		if DTaskKpiIDs'="" s DTaskKpiIDs=DTaskKpiIDs_","
		s DTaskKpiIDs=DTaskKpiIDs_kpiId
		//恐怕DTaskIDs保存的数据太长，引发异常，所以当长度大于300字符时就执行一次。
		if $l(DTaskKpiIDs)>300 {
			s Sql="UPDATE DHCWL_MKPI.DHCWLCreatDataTask SET DTask_ActiveFlag = 'Y' WHERE DTask_KPI_DR IN ("_DTaskKpiIDs_")"
			s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ActivateKPITaskERR
			s st=Rs.Execute() if ($$$ISERR(st)) goto ActivateKPITaskERR
			s DTaskKpiIDs=""
		}
	}
	
	if $l(DTaskKpiIDs)>0 {
		s Sql="UPDATE DHCWL_MKPI.DHCWLCreatDataTask SET DTask_ActiveFlag = 'Y' WHERE DTask_KPI_DR IN ("_DTaskKpiIDs_")"
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ActivateKPITaskERR
		s st=Rs.Execute() if ($$$ISERR(st)) goto ActivateKPITaskERR
		s DTaskKpiIDs=""
	}
	d Rs.Close()	
	
	q 0
	
ActivateKPITaskERR
	q 1
}

/// 名称: GetModuleAncestorsByCode
/// 描述: 根据模块的编码来模糊查找模块的祖先节点的Treecode。
/// 参数: modeCode——模块的编码
/// 	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 修改者： wk
/// 修改日期:2016-3-4
ClassMethod ActivateKPITask(moduleNodes, rptNodes, dsNodes, actFrom) As %Integer
{
	//n (moduleNodes,rptNodes,dsNodes,actFrom)
	s $zt="ActivateKPITaskERR"
	s kpiCodes=""
	if actFrom="module" {
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByModuleTCode(moduleNodes)
	}elseif(actFrom="report"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByRptCode(moduleNodes,rptNodes)
	}elseif(actFrom="dataset"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByDsCode(moduleNodes,rptNodes,dsNodes)
	}
	
	s kpiCnt=$l(kpiCodes,",")
	s DTaskKpiIDs=""

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
	 			goto ActivateKPITaskERR
			}
		}
		
	}	
	
	q 0
	
ActivateKPITaskERR
	q 1
}

/// 名称: GetModuleAncestorsByCode
/// 描述: 根据模块的编码来模糊查找模块的祖先节点的Treecode。
/// 参数: modeCode——模块的编码
/// 	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 修改者： wk
/// 修改日期:2016-03-04
ClassMethod DisActivateKPITask(moduleNodes, rptNodes, dsNodes, actFrom, isMul)
{
	s $zt="ActivateKPITaskERR"
	s kpiCodes=""
	if actFrom="module" {
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByModuleTCode(moduleNodes,"","",isMul)
	}elseif(actFrom="report"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByRptCode(moduleNodes,rptNodes,"",isMul)
	}elseif(actFrom="dataset"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByDsCode(moduleNodes,rptNodes,dsNodes,isMul)
	}
	
	s kpiCnt=$l(kpiCodes,",")
	s DTaskKpiIDs=""
	s Rs=##class(%Library.ResultSet).%New()

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
	 			goto ActivateKPITaskERR
			}
		}
	}	
	
	q 0
	
ActivateKPITaskERR
	q 1
}

/// 名称: GetModuleAncestorsByCode
/// 描述: 根据模块的编码来模糊查找模块的祖先节点的Treecode。
/// 参数: modeCode——模块的编码
/// 	  
/// 返回类型：	字符串
/// 返回值：	以“,”分隔的祖先节点的Treecode
/// 编写者： 王峥
/// 编写日期:2014-1-14
ClassMethod DisActivateKPITaskOld(moduleNodes, rptNodes, dsNodes, actFrom, isMul)
{
	s $zt="ActivateKPITaskERR"
	s kpiCodes=""
	if actFrom="module" {
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByModuleTCode(moduleNodes,"","",isMul)
	}elseif(actFrom="report"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByRptCode(moduleNodes,rptNodes,"",isMul)
	}elseif(actFrom="dataset"){
		s kpiCodes=##class(DHCWL.Interface.Module).GetKpiCodeByDsCode(moduleNodes,rptNodes,dsNodes,isMul)
	}
	
	s kpiCnt=$l(kpiCodes,",")
	s DTaskKpiIDs=""
	s Rs=##class(%Library.ResultSet).%New()

	f i=1:1:kpiCnt {
		s kpiCode=$p(kpiCodes,",",i)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		q:kpiId=""
		s actFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,""))
		q:actFlag="N"
		s DTaskID=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,actFlag,""))
		q:'$d(^DHCWL.MKPI.CreatDataTaskD(DTaskID))
		if DTaskKpiIDs'="" s DTaskKpiIDs=DTaskKpiIDs_","
		s DTaskKpiIDs=DTaskKpiIDs_kpiId
		//恐怕DTaskIDs保存的数据太长，引发异常，所以当长度大于300字符时就执行一次。
		if $l(DTaskKpiIDs)>300 {
			s Sql="UPDATE DHCWL_MKPI.DHCWLCreatDataTask SET DTask_ActiveFlag = 'N' WHERE DTask_KPI_DR IN ("_DTaskKpiIDs_")"
			s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ActivateKPITaskERR
			s st=Rs.Execute() if ($$$ISERR(st)) goto ActivateKPITaskERR
			s DTaskKpiIDs=""
		}
	}
	
	if $l(DTaskKpiIDs)>0 {
		s Sql="UPDATE DHCWL_MKPI.DHCWLCreatDataTask SET DTask_ActiveFlag = 'N' WHERE DTask_KPI_DR IN ("_DTaskKpiIDs_")"
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ActivateKPITaskERR
		s st=Rs.Execute() if ($$$ISERR(st)) goto ActivateKPITaskERR
		s DTaskKpiIDs=""
	}
	d Rs.Close()	
	
	q 0
	
ActivateKPITaskERR
	q 1
}

}

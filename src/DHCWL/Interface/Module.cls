Class DHCWL.Interface.Module Extends %RegisteredObject
{

/// 描述: 以模块为单位导出指标系统到xml文件中，导出时会导出该模块下及其该模块下所有的字模块所配置的所有报表到xml文件中。
/// 参数: 	modules：		模块id，多个模块之间用英文逗号分隔
/// 	 	savePath：		要导出xml文件保存的文件路径，该参数为一个字符串表示了要保存文件的磁盘位置。
/// 								该参数和fileStream参数二选一
/// 		fileStream：	导出后返回文件的数据流，该参数和fileStream参数二选一
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-7
/// s a=##class(DHCWL.Interface.Module).CreateReportKpiData(2,"2013-1-1","2013-1-10")
ClassMethod ExportModule(modules As %String, savePath As %String = "", outputfileStream As %FileBinaryStream = "") As %Boolean
{
	b
	//1、得到祖先模块的code
	s sql="select * from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_RowID in ("_modules_")"
	s rs=##class(%Library.ResultSet).%New()
	s st=rs.Prepare(sql) if ($$$ISERR(st)) goto ErrorGetSearchedModule
	s st=rs.Execute()  if ($$$ISERR(st)) goto ErrorGetSearchedModule
	While(rs.Next()){
		s treeCode=rs.Get("ModuleCfg_TreeCode")
		
		s mdlId=rs.Get("ModuleCfg_RowID")
		s ^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-CUR",treeCode)=mdlId
		s ^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-INCRPT",treeCode)=mdlId
		for i=$l(treeCode,".")-1:-1:2 {
			s ances=$p(treeCode,".",1,i)
			s ^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-ANCES",ances)=""
		}
	}
	d rs.Close()

	//2、得到子孙模块的ID和CODE
	b
	s treeCode=""
	for {
		s treeCode=$o(^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-CUR",treeCode))
		q:$g(treeCode)=""
		s ptreeCode=treeCode_"."
		s sql="select * from DHCWL_MKPI.MMgrModuleCfg where ModuleCfg_TreeCode like '"_ptreeCode_"%'"
		s st=rs.Prepare(sql) if ($$$ISERR(st)) goto ErrorGetSearchedModule
		s st=rs.Execute()  if ($$$ISERR(st)) goto ErrorGetSearchedModule
		While(rs.Next()){
			s subTreeCode=rs.Get("ModuleCfg_TreeCode")
			s subMdlId=rs.Get("ModuleCfg_RowID")
			s ^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-SUB",subTreeCode)=subMdlId
			s ^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-INCRPT",subTreeCode)=subMdlId
		}
		d rs.Close()
	}
	
	//3、过滤祖先节点
	s anceCode=""
	s sameCode=""
	for {
		s anceCode=$o(^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-ANCES",anceCode))	
		if (sameCode'="") k ^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-ANCES",sameCode)
		q:anceCode=""
		s incRptCode=""
		s sameCode=""
		for {
			s incRptCode=$o(^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-INCRPT",incRptCode))
			q:incRptCode=""
			i (incRptCode=anceCode) {
				s sameCode=anceCode
				q	
			}
		}
	}
	//4、得到祖先节点的ID
	s moduleIDs=""
	s anceCode=""
	for {
		s anceCode=$o(^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-ANCES",anceCode))	
		q:anceCode=""
		s mdlId=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",anceCode,""))
		s ^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-ANCES",anceCode)=mdlId
		i moduleIDs'="" s moduleIDs=moduleIDs_","
		s moduleIDs=moduleIDs_mdlId
		//s moduleObj=##class(DHCWL.MKPI.MMgrModuleCfg).%OpenId(mdlId)
		//continue:moduleObj=""
		//d list.Insert(moduleObj)
	}
	//5、把模块当前节点及子孙节点所包含的报表加入到global中
	b
	s treeCode=""
	s rptIDs=""
	f {
		s treeCode=$o(^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-INCRPT",treeCode)) 
		q:treeCode=""
		s mdlId=^TEMPDHCWL("MODULEMNG-API",$j,"EXPM-INCRPT",treeCode)
		i moduleIDs'="" s moduleIDs=moduleIDs_","
		s moduleIDs=moduleIDs_mdlId
		s rptCode=""
		f {
			s rptCode=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode))
			q:rptCode=""
			s rptID=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode,""))
			if $g(rptIDs)'="" s rptIDs=rptIDs_","
			s rptIDs=rptIDs_rptID
		}
		
	}
	//6、导出
	k ^TEMPDHCWL("MODULEMNG-API")	
	q ..ExportModuleData(moduleIDs,rptIDs, savePath,outputfileStream)
	
ErrorGetSearchedModule

	q ""
}

/// 描述: 生成该模块及其该模块下所有的子模块的给定区间范围的指标数据。
/// 参数: 	module：模块id，多个模块之间用英文逗号分隔
/// 	 	startDate,endDate：开始日期和结束日期。yyyy-mm-dd格式的日期
/// 			rebuildFlag：重生数据标志，如果为1则在有数据的情况下会删除已有数据然后重新生成，如果没有数据则直接生成。如果为0则在有数据的情况下略过。
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-6
/// s a=##class(DHCWL.Interface.Module).CreateReportKpiData(2,"2013-1-1","2013-1-10")
ClassMethod CreateModuleKpiData(modules As %String, startDate As %String, endDate As %String, rebuildFlag As %String = "0") As %Status
{
	s rptIDs=""
	for i=1:1:$l(modules,",") {
		s mdl=$p(modules,",",i)
		s mdlData=^DHCWL.MKPI.MMgrModuleCfgD(mdl)
		i $g(mdlData)="" continue
		s treeCode=$LISTGET(mdlData,4,"")
		s rptCode=""
		f {
			s rptCode=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode))
			q:rptCode=""
			s rptID=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode,""))
			if rptIDs'="" s rptIDs=rptIDs_","
			s rptIDs=rptIDs_rptID
		}

	}
	b
	s ret=..CreateReportKpiData(rptIDs,startDate,endDate,rebuildFlag)
	q ret
}

/// 描述: 导出报表及属于报表的数据集，指标。
/// 参数: 	
/// 	 	report：报表id，多个报表之间用英文逗号分隔
/// 			savePath:要导出xml文件保存的文件路径，该参数为一个字符串表示了要保存文件的磁盘位置。该参数和fileStream参数二选一。
/// 		outputfileStream:导出后返回文件的数据流，该参数和fileStream参数二选一
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-8
/// s a=##class(DHCWL.Interface.Module).ExportReport(42,"c:\kssryb.xml","")
ClassMethod ExportReport(reports As %String, savePath As %String = "", outputfileStream As %FileBinaryStream = "") As %Status
{
	//b
	//1、得到每个报表所属的模块节点。
	k ^TEMPDHCWL("MODULEMNG-API")
	for i=1:1:$l(reports,",") {
		s rptId=$p(reports,",",i)
		s rptData=^DHCWL.MKPI.MMgrRptCfgD(rptId)
		continue:$g(rptData)=""
		s treeCode=$LG(rptData,5)
		for {
			q:((treeCode="root") || (treeCode=""))
			s mdlId=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode,""))
			s ^TEMPDHCWL("MODULEMNG-API",$j,"MODULECODE",treeCode)=mdlId
			s mdlData=^DHCWL.MKPI.MMgrModuleCfgD(mdlId)
			s treeCode=$LG(mdlData,5,"")
		}
	}
	
	s modules=""
	s treeCode=""
	f {
		s treeCode=$o(^TEMPDHCWL("MODULEMNG-API",$j,"MODULECODE",treeCode))
		q:treeCode=""
		if (modules'="") s modules=modules_","
		s modules=modules_^TEMPDHCWL("MODULEMNG-API",$j,"MODULECODE",treeCode)
	}
	//2、导出模块节点，报表节点
	k ^TEMPDHCWL("MODULEMNG-API")	
	b
	q ..ExportModuleData(modules,reports, savePath,outputfileStream)
}

/// 描述: 导出模块节点，报表及属于报表的数据集，指标。
/// 参数: 	module：模块id，多个模块之间用英文逗号分隔
/// 	 	report：报表id，多个报表之间用英文逗号分隔
/// 			savePath:要导出xml文件保存的文件路径，该参数为一个字符串表示了要保存文件的磁盘位置。该参数和fileStream参数二选一。
/// 		outputfileStream:导出后返回文件的数据流，该参数和fileStream参数二选一
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-6
/// 
ClassMethod ExportModuleData(modules As %String, reports As %String, savePath As %String = "", outputfileStream As %FileBinaryStream = "") As %Status
{
	b
	s list=##Class(%Library.ListOfObjects).%New()
	for i=1:1:$l(modules,",") {
		s moduleId=$p(modules,",",i)
		s moduleObj=##class(DHCWL.MKPI.MMgrModuleCfg).%OpenId(moduleId)
		continue:moduleObj=""
		d list.Insert(moduleObj)
	}
	
	for i=1:1:$l(reports,",") {
		s rptId=$p(reports,",",i)
		s rptObj=##class(DHCWL.MKPI.MMgrRptCfg).%OpenId(rptId)
		continue:rptObj=""
		d list.Insert(rptObj)
		//加入数据集
		s treeCode=$lg(^DHCWL.MKPI.MMgrRptCfgD(rptId),5,"")
		s rptCode=$lg(^DHCWL.MKPI.MMgrRptCfgD(rptId),2,"")
		s datasetCode=""
		f {
			s datasetCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,datasetCode))
			q:datasetCode=""
			s datasetId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,datasetCode,""))
			s datasetObj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(datasetId)
			continue:datasetObj=""
			d list.Insert(datasetObj)
			//加入指标
			s kpiCode=""
			f {
				s kpiCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,rptCode,datasetCode,kpiCode))
				q:kpiCode=""
				s kpiId=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,rptCode,datasetCode,kpiCode,""))
				s kpiObj=##class(DHCWL.MKPI.MMgrKPICfg).%OpenId(kpiId)
				continue:kpiObj=""
				d list.Insert(kpiObj)
				
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
	
	s service=##class(DHCWL.ModuleManageServ.ModuleOutputIF).%New()
	s ret=##class(DHCWL.Interface.IOStream).ExportCustom(list, service, savePath, outputfileStream)
	q ret
}

/// 描述: 生成该报表下配置的所有数据集的指标数据
/// 参数: 	report：报表id，多个模块之间用英文逗号分隔
/// 	 	startDate,endDate：开始日期和结束日期。yyyy-mm-dd格式的日期
/// 			rebuildFlag：重生数据标志，如果为1则在有数据的情况下会删除已有数据然后重新生成，如果没有数据则直接生成。如果为0则在有数据的情况下略过。
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-6
/// s a=##class(DHCWL.Interface.Module).CreateReportKpiData(2,"2013-1-1","2013-1-10")
ClassMethod CreateReportKpiData(reports As %String, startDate As %String, endDate As %String, rebuildFlag As %String = "0") As %Status
{
	k ^TEMPDHCWL("MODULEMNG-API")
	
	for i=1:1:$l(reports,",") {
		s rpt=$p(reports,",",i)
		s rptData=^DHCWL.MKPI.MMgrRptCfgD(rpt)
		i $g(rptData)="" continue
		s treeCode=$LISTGET(rptData,5,"")
		s rptCode=$LISTGET(rptData,2,"")
		s datasetCode=""
		f {
			s datasetCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,rptCode,datasetCode))
			q:datasetCode=""
			s kpiCode=""
			f {
				s kpiCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,rptCode,datasetCode,kpiCode))
				q:kpiCode=""
				s ^TEMPDHCWL("MODULEMNG-API",$j,kpiCode)=kpiCode
			}
		}
		
	}
	
	s kpiCodes=""
	s kpiCode=""
	f {
		s kpiCode=$o(^TEMPDHCWL("MODULEMNG-API",$j,kpiCode))
		q:kpiCode=""
		i kpiCodes'=""  s kpiCodes=kpiCodes_","
		s kpiCodes=kpiCodes_kpiCode	
	}
	
	k ^TEMPDHCWL("MODULEMNG-API")
	
	b
	s ret=##class(DHCWL.Interface.MkpiData).CreateKpiData(kpiCodes,startDate,endDate,rebuildFlag)
	q ret
}

/// 描述: 向数据集中添加指标取数规则的配置
/// 参数: 	report：要添加数据集所在的报表的ID
/// 	 	datasetCode：数据集的编码
/// 		kpiRule：要向该数据集中配置的指标取数规则
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-11
/// s a=##class(DHCWL.Interface.Module).AddKpiRuleToDataSet(46,"ds1","K0027,K0028")
ClassMethod AddKpiRuleToDataSet(report As %String, datasetCode As %String, kpiRule As %String) As %Status
{
	b
	s ret=0
	s rptObj=##class(DHCWL.MKPI.MMgrRptCfg).%OpenId(report)
	q:'$ISOBJECT(rptObj) 0
	s rptCode=rptObj.RptCfgCode
	s treeCode=rptObj.RptCfgTreeCode
	s datasetID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,datasetCode,""))
	q:$g(datasetID)="" 0
	d rptObj.%Close()

	s datasetObj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(datasetID)
	q:'$ISOBJECT(datasetObj) 0
	s datasetCode=datasetObj.DatasetCfgCode
	d datasetObj.%Close()
	
	s rulelist=$TRANSLATE(kpiRule,"^","%")
	//更新MMgrDatasetCfg
	&sql(update DHCWL_MKPI.MMgrDatasetCfg set DatasetCfg_RuleList=:rulelist where DatasetCfg_RowID=:datasetID)
	if (+$g(SQLCODE)'=0) {
		TROLLBACK  
		q 0
	}

	
	//更新MMgrKPICfg
	//1、删除原有的记录
	&sql(delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_DatasetCode=:datasetCode and KPICfg_RptCode=:rptCode and KPICfg_TreeCode=:treeCode )
	i ((SQLCODE'=0) && (SQLCODE'=100)) {
		TROLLBACK	
		q 0
	}
	//2、添加新记录
	s listKpiCode=$LISTFROMSTRING(rulelist,",")
	for i=1:1:$ll(listKpiCode) {
		s kpiCode=$lg(listKpiCode,i)
		s kpiCode=$p(kpiCode,":",1)
		&sql(insert into DHCWL_MKPI.MMgrKPICfg (KPICfg_Code,KPICfg_DatasetCode,KPICfg_RptCode,KPICfg_TreeCode) values (:kpiCode,:datasetCode,:rptCode,:treeCode) )
		i (SQLCODE'=0) {
			TROLLBACK
			s ret=0
			q 	
		}
		s ret=1
	}
	q ret
}

/// 描述: 根据报表参数获取该报表下的数据，返回的数据封装在DataPackage下，可以根据此接口取不同类型的数据。
/// 参数: 	report：要添加数据集所在的报表的ID
/// 	 	param：参数对象
/// 返回类型：	ArrayOfObjects
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-11
ClassMethod GetReportData(report As %String, ByRef param As DHCWL.Interface.Parameter) As %Library.ArrayOfObjects
{
	s aryObjs=##CLASS(%Library.ArrayOfObjects).%New()
	
	s startDate=param.getStartDate()
	s endDate=param.getEndDate()
	s choiceType=param.getChoiceType()
	s isRealData=param.getIsRealData()
	s filterRule=param.getFilterRule()
	
	q:((""=startDate)&&(""=endDate)) aryObjs
	
	s rptObj=##class(DHCWL.MKPI.MMgrRptCfg).%OpenId(report)
	q:'$ISOBJECT(rptObj) aryObjs
	s rptCode=rptObj.RptCfgCode
	s treeCode=rptObj.RptCfgTreeCode
	s dsCode=""
	f {
		s dsCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,dsCode))
		q:$g(dsCode)=""
		
		s datasetID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,dsCode,""))
		s datasetObj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(datasetID)
		q:'$ISOBJECT(datasetObj)
		s ruleList=datasetObj.DatasetRuleList
		continue:(""=ruleList)
		s ruleList=$TRANSLATE(ruleList,"%","^")

		s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
		
		//b
		s sc=rs.Execute(ruleList,startDate,endDate,choiceType,isRealData,filterRule)
		if ($$$ISERR(sc)) {
			//w !,"GetReportData exec fail!"
			Do DisplayError^%apiOBJ(sc)
		}else{
			d aryObjs.SetAt(rs,dsCode)
		}
	}
	//w !,aryObjs.Count()
	q aryObjs
}

/// 描述: 根据入参得到数据集对象
/// 参数: 	code：参数由"模块树节点编码:报表编码:数据集编码"组成
/// 返回类型：	%ObjectHandle
/// 返回值：	如果成功，返回数据集对象；如果失败返回-1
/// 编写者： 王峥
/// 编写日期:2014-3-12
/// s a=##class(DHCWL.Interface.Module).GetDatasetObj("root.WHDYYY.SR:KSSRRB:ds1")
/// s a=##class(DHCWL.Interface.Module).GetDatasetObj("root.WHDYYY.SR!KSSRRB!ds1")
ClassMethod GetDatasetObj(code As %String) As %ObjectHandle
{
	s $zt="ErrorReturn"
	s datasetObj=-1
	s moduleCode=$p(code,":",1)
	s rptCode=$p(code,":",2)
	s datasetCode=$p(code,":",3)
	
	//s moduleCode=$p(code,"!",1)
	//s rptCode=$p(code,"!",2)
	//s datasetCode=$p(code,"!",3)
	
	if (($g(moduleCode)="") || ($g(rptCode)="") || ($g(datasetCode)="")) q datasetObj
	
	s datasetID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCode,datasetCode,""))
	if ($g(datasetID)="") q datasetObj
	s datasetObj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(datasetID)
	q:'$ISOBJECT(datasetObj) -1
	s datasetObj.DatasetRuleList=$TRANSLATE(datasetObj.DatasetRuleList,"%","^")
	q datasetObj

ErrorReturn
	 q -1
}

/// 描述: 生成该模块及其该模块下所有的子模块的给定区间范围的指标数据。
/// 参数: 	module：模块id，多个模块之间用英文逗号分隔
/// 	 	startDate,endDate：开始日期和结束日期。yyyy-mm-dd格式的日期
/// 			rebuildFlag：重生数据标志，如果为1则在有数据的情况下会删除已有数据然后重新生成，如果没有数据则直接生成。如果为0则在有数据的情况下略过。
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-6
/// s a=##class(DHCWL.Interface.Module).AddModule()
ClassMethod AddModule(parentModuleCode As %String, moduleCode As %String, moduleDesc As %String) As %Status
{
	n (parentModuleCode,moduleCode,moduleDesc)
	q:($g(parentModuleCode)="" || $g(moduleCode)="" || $g(moduleDesc)="" ) -1
	s treeCode=parentModuleCode_"."_moduleCode
	if $g(parentModuleCode)="" s parentModuleCode="root"
	&sql(insert into DHCWL_MKPI.MMgrModuleCfg (modulecfg_code,modulecfg_desc,modulecfg_treecode,modulecfg_ptreecode) values (:moduleCode,:moduleDesc,:treeCode,:parentModuleCode))
		
	q SQLCODE
}

/// 描述: 生成该模块及其该模块下所有的子模块的给定区间范围的指标数据。
/// 参数: 	module：模块id，多个模块之间用英文逗号分隔
/// 	 	startDate,endDate：开始日期和结束日期。yyyy-mm-dd格式的日期
/// 			rebuildFlag：重生数据标志，如果为1则在有数据的情况下会删除已有数据然后重新生成，如果没有数据则直接生成。如果为0则在有数据的情况下略过。
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-6
/// s a=##class(DHCWL.Interface.Module).AddModule()
ClassMethod AddRpt(parentModuleCode As %String, rptCode As %String, rptDesc As %String) As %Status
{
	//n (parentModuleCode,rptCode,rptDesc)
	s pcode=parentModuleCode
	s code=rptCode
	s desc=rptDesc
	s name=rptDesc
	
	&sql(insert into DHCWL_MKPI.MMgrRptCfg (rptCfg_code,rptCfg_desc,RptCfg_TreeCode,RptCfg_Name) values (:code,:desc,:pcode,:name))
	q SQLCODE
}

/// 描述: 生成该模块及其该模块下所有的子模块的给定区间范围的指标数据。
/// 参数: 	module：模块id，多个模块之间用英文逗号分隔
/// 	 	startDate,endDate：开始日期和结束日期。yyyy-mm-dd格式的日期
/// 			rebuildFlag：重生数据标志，如果为1则在有数据的情况下会删除已有数据然后重新生成，如果没有数据则直接生成。如果为0则在有数据的情况下略过。
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-6
/// s a=##class(DHCWL.Interface.Module).AddModule()
ClassMethod SearchRpt(parentModuleCode As %String, rptCode As %String) As %Status
{
	s rptCfgRowID=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",parentModuleCode,rptCode,""))
	q rptCfgRowID
}

/// 描述: 
/// 参数: 	
/// 	 	
/// 			
/// 返回类型：	
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:
/// s a=##class(DHCWL.Interface.Module).GetKpiCodeByModuleTCode("root.CRZZBB")
ClassMethod GetKpiCodeByModuleTCode(moduleTCodes As %String, rptCodes = "", dsCodes = "", isMul) As %String
{
	//n (moduleTCodes)
	k ^TEMPDHCWL("GetKpiCodeByModuleTCode")
	k ^TEMPDHCWL("GetKpiCode")
	s strRet=""
	s moduleCnt=$l(moduleTCodes,",")
	f i=1:1:moduleCnt {
		s mCode=$p(moduleTCodes,",",i)
		//DHCWL.MKPI.MMgrKPICfg
		//Index TRDKIdx On (KPITreeCode, KPIRptCode, KPIDatasetCfgCode, KPICfgCode);
		s rptCode=""
		f {
			s rptCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",mCode,rptCode))	
			q:rptCode=""
			s datasetCode=""
			f {
				s datasetCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",mCode,rptCode,datasetCode))
				q:datasetCode=""
				s kpiCode=""
				f {
					s kpiCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",mCode,rptCode,datasetCode,kpiCode))
					q:kpiCode=""
					//Index MKPICode On MKPICode As AlphaUp;
					//DHCWL.MKPI.MKPI
					s alphaCode=$SYSTEM.SQL.ALPHAUP(kpiCode)
					s kpiID=$o(^DHCWL.MKPI.MKPII("MKPICode",alphaCode,""))
					q:kpiID=""
					q:'$d(^DHCWL.MKPI.MKPID(kpiID))
					s ^TEMPDHCWL("GetKpiCodeByModuleTCode",kpiCode)=1
					s ^TEMPDHCWL("GetKpiCode",kpiCode,mCode,rptCode,datasetCode)=1
				}	
			}	
		}	
	}

	if $d(^TEMPDHCWL("GetKpiCodeByModuleTCode")) {
		if $g(isMul)="false" {
			s kpiCode=""
			f {
				s kpiCode=$o(^TEMPDHCWL("GetKpiCodeByModuleTCode",kpiCode))
				q:kpiCode=""
				s mCode=""
				f {
					s mCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",kpiCode,mCode))
					q:mCode=""
					if '$d(^TEMPDHCWL("GetKpiCode",kpiCode,mCode)) {
						k ^TEMPDHCWL("GetKpiCode",kpiCode)
					}
				}
			}
		}		
		
		s kpiCode=""
		f {
			s kpiCode=$o(^TEMPDHCWL("GetKpiCode",kpiCode))
			q:kpiCode=""
			if strRet'="" s strRet=strRet_","
			s strRet=strRet_kpiCode
		}
	}
	q strRet
}

ClassMethod GetKpiCodeByRptCode(moduleTCodes As %String, rptCodes As %String, dsCodes = "", isMul) As %String
{
	//n (moduleTCodes)
	k ^TEMPDHCWL("GetKpiCodeByRptCode")
	k ^TEMPDHCWL("GetKpiCode")
	s strRet=""
	s rptCnt=$l(rptCodes,",")
	s mCode=moduleTCodes
	f i=1:1:rptCnt {
		s rptCode=$p(rptCodes,",",i)
		//DHCWL.MKPI.MMgrKPICfg
		//Index TRDKIdx On (KPITreeCode, KPIRptCode, KPIDatasetCfgCode, KPICfgCode);

		s datasetCode=""
		f {
			s datasetCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",mCode,rptCode,datasetCode))
			q:datasetCode=""
			s kpiCode=""
			f {
				s kpiCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",mCode,rptCode,datasetCode,kpiCode))
				q:kpiCode=""
				//Index MKPICode On MKPICode As AlphaUp;
				//DHCWL.MKPI.MKPI
				s alphaCode=$SYSTEM.SQL.ALPHAUP(kpiCode)
				s kpiID=$o(^DHCWL.MKPI.MKPII("MKPICode",alphaCode,""))
				q:kpiID=""
				q:'$d(^DHCWL.MKPI.MKPID(kpiID))
				s ^TEMPDHCWL("GetKpiCodeByRptCode",kpiCode)=1
				s ^TEMPDHCWL("GetKpiCode",kpiCode,mCode,rptCode,datasetCode)=1
			}	
		}	
	
	}

	if $d(^TEMPDHCWL("GetKpiCodeByRptCode")) {
		if $g(isMul)="false" {
			s kpiCode=""
			f {
				s kpiCode=$o(^TEMPDHCWL("GetKpiCodeByRptCode",kpiCode))
				q:kpiCode=""
				s mCode=""
				f {
					s mCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",kpiCode,mCode))
					q:mCode=""
					if '$d(^TEMPDHCWL("GetKpiCode",kpiCode,mCode)) {
						k ^TEMPDHCWL("GetKpiCode",kpiCode)
					}
				}
			}
		}		
		
		s kpiCode=""
		f {
			s kpiCode=$o(^TEMPDHCWL("GetKpiCode",kpiCode))
			q:kpiCode=""
			if strRet'="" s strRet=strRet_","
			s strRet=strRet_kpiCode
		}
	}

	q strRet
}

ClassMethod GetKpiCodeByDsCode(moduleTCodes As %String, rptCodes As %String, dsCodes As %String, isMul) As %String
{
	//n (moduleTCodes)
	k ^TEMPDHCWL("GetKpiCodeByDsCode")
	k ^TEMPDHCWL("GetKpiCode")
	s strRet=""
	s dsCnt=$l(dsCodes,",")
	s mCode=moduleTCodes
	s rptCode=rptCodes
	f i=1:1:dsCnt {
		s datasetCode=$p(dsCodes,",",i)
		q:datasetCode=""
		s kpiCode=""
		f {
			s kpiCode=$o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",mCode,rptCode,datasetCode,kpiCode))
			q:kpiCode=""
			//Index MKPICode On MKPICode As AlphaUp;
			//DHCWL.MKPI.MKPI
			s alphaCode=$SYSTEM.SQL.ALPHAUP(kpiCode)
			s kpiID=$o(^DHCWL.MKPI.MKPII("MKPICode",alphaCode,""))
			q:kpiID=""
			q:'$d(^DHCWL.MKPI.MKPID(kpiID))
			s ^TEMPDHCWL("GetKpiCodeByDsCode",kpiCode)=1
			s ^TEMPDHCWL("GetKpiCode",kpiCode,mCode,rptCode,datasetCode)=1			
		}	
	}

	if $d(^TEMPDHCWL("GetKpiCodeByDsCode")) {
		if $g(isMul)="false" {
			s kpiCode=""
			f {
				s kpiCode=$o(^TEMPDHCWL("GetKpiCodeByDsCode",kpiCode))
				q:kpiCode=""
				s mCode=""
				f {
					s mCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",kpiCode,mCode))
					q:mCode=""
					if '$d(^TEMPDHCWL("GetKpiCode",kpiCode,mCode)) {
						k ^TEMPDHCWL("GetKpiCode",kpiCode)
					}
				}
			}
		}		
		
		s kpiCode=""
		f {
			s kpiCode=$o(^TEMPDHCWL("GetKpiCode",kpiCode))
			q:kpiCode=""
			if strRet'="" s strRet=strRet_","
			s strRet=strRet_kpiCode
		}
	}
	
	
	k ^TEMPDHCWL("GetKpiCodeByDsCode")
	q strRet
}

}

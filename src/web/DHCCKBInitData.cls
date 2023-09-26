/// 数据初始化相关业务类
Class web.DHCCKBInitData Extends %RegisteredObject
{

/// Creator:		qunianpeng
/// CreatDate:		2022-12-23
/// Description:： 	基础数据导出(不在使用)
/// Input:			dthealth所在的盘符,如D:(window系统), \root(linux系统)		
/// Other:
/// 导出global： d ##class(web.DHCCKBInitData).ExportBaseGlobal("D:")
ClassMethod ExportBaseGlobal(path)
{

	k CList
	k myIdx
	//字典表
	s CList($i(CList))="DHCCKBCD.GBL" 					// 知识库码表字典 CT.CKB.PDSS.CommonDiction.cls	
	s CList($i(CList))="DHCCKBDLA.GBL" 					// 数据关联表    User.DHCCKBDicLinkAttr.cls
	s CList($i(CList))="User.DHCCKBDrugLibaryRefD.GBL" 	// 规则目录关联表 User.DHCCKBDrugLibaryRef.cls
	s CList($i(CList))="User.DHCCKBDrugLibaryRefI.GBL"
	s CList($i(CList))="DHCCKBRULE.GBL"  				// 规则主表 User.DHCCKBRule
	s CList($i(CList))="DHCCKBRD.GBL"  					// 规则明细表 User.DHCCKBRuleData
	s CList($i(CList))="DHCCKBRULEDIC.GBL"				// 规则索引 User.DHCCKBRuleDic
	s CList($i(CList))="DHCCKBRULENODE.GBL"				// 规则节点表 User.DHCCKBRuleNode
	s CList($i(CList))="User.DHCCKBDiagnosisRelationD.GBL" // 疾病病症关系表 User.DHCCKBDiagnosisRelation
	s CList($i(CList))="User.DHCCKBDiagnosisRelationI.GBL"
	s CList($i(CList))="User.DHCCKBIgnoreDataPoolD.GBL" // 审核忽略配置数据池表 User.DHCCKBIgnoreDataPool
	s CList($i(CList))="User.DHCCKBIgnoreDataPoolI.GBL" 
	s CList($i(CList))="DHCCKBIGMAN.GBL" 				// 审核忽略配置表 User.DHCCKBIgnoreManage
	s CList($i(CList))="User.DHCCKBPreconditionDataPoolD.GBL" // 前提条件数据池表 User.DHCCKBPreconditionDataPool
	s CList($i(CList))="CKB.PDSS.DicDataLogD.GBL"		// 知识日志详情表 CKB.PDSS.DicDataLog
	s CList($i(CList))="CKB.PDSS.DicDataLogI.GBL"	
	s CList($i(CList))="CKB.PDSS.DicLogD.GBL"			// 字典日志表 CKB.PDSS.DicLog
	s CList($i(CList))="CKB.PDSS.DicLogI.GBL"	
	s CList($i(CList))="CKB.PDSS.ExtDictionD.GBL"	   	// 外部项目字典表 CKB.PDSS.ExtDiction(只同步疾病部分)
	s CList($i(CList))="CKB.PDSS.ExtDictionI.GBL"
	s CList($i(CList))="CKB.PDSS.RuleLogD.GBL"	   		// 规则日志表 CKB.PDSS.RuleLog
	s CList($i(CList))="CKB.PDSS.RuleLogI.GBL"
	s CList($i(CList))="CKB.PDSS.RuleDataLogD.GBL"	   	// 规则明细日志表 CKB.PDSS.RuleDataLog
	s CList($i(CList))="CKB.PDSS.RuleDataLogI.GBL"
	s CList($i(CList))="CKB.PDSS.RuleCopyLogD.GBL"	   	// 规则复制记录表 CKB.PDSS.RuleCopyLog
	s CList($i(CList))="CKB.PDSS.RuleCopyLogI.GBL"
	s CList($i(CList))="^CKB.PDSS.ComContrastD.GBL"		// 数据映射表 CKB.PDSS.ComContrast (只同步疾病部分)
	s CList($i(CList))="^CKB.PDSS.ComContrastI.GBL"
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zts
	s time = $replace(time,",","_")
	s time = $replace(time,".","_")
	s filename = path_""_"\Dthealth\app\dthis\web\temp\global\CKB.PDSS."_time_".gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-23
/// Description:： 	基础数据导入
/// Input:			path: dthealth所在的盘符,如D:(window系统), \root(linux系统)	
/// 					filename:文件名称含后缀	
/// 				d ##class(web.DHCCKBInitData).ImportBaseGlobal("","CKB.PDSS.66523_47966_912.gof")
ClassMethod ImportBaseGlobal(path, filename)
{
	/* 清除global改造后新表的数据 */
	d ##class(web.DHCCKBCleanData).CleanCKBBaseData()
	d ##class(web.DHCCKBCleanData).CleanCKBConfigData()
	d ##class(web.DHCCKBCleanData).CleanCKBBusinessData()	
	
	s path = path_"\Dthealth\app\dthis\web\temp\global\"
	d $SYSTEM.OBJ.ImportDir(path,filename)	
		
	q "导入成功"
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description:： 	基础数据导出（global改造后）
/// Input:			dthealth所在的盘符,如D:(window系统), \root(linux系统)		
/// Other:
/// 导出global： d ##class(web.DHCCKBInitData).ExportNewBaseGlobal("E:")
ClassMethod ExportNewBaseGlobal(path)
{

	k CList
	k myIdx
	
	s CList($i(CList))="CT.CKB.PDSS.CommonDictionD.GBL" //基础数据码表
	s CList($i(CList))="CT.CKB.PDSS.CommonDictionI.GBL" 
	s CList($i(CList))="CT.CKB.PDSS.DicLinkAttrD.GBL" //属性关联表
	s CList($i(CList))="CT.CKB.PDSS.DicLinkAttrI.GBL" 
	s CList($i(CList))="CT.CKB.PDSS.DrugLibaryRefD.GBL" //规则目录关联表
	s CList($i(CList))="CT.CKB.PDSS.DrugLibaryRefI.GBL" 
	s CList($i(CList))="CT.CKB.PDSS.RuleD.GBL" //规则序号表
	s CList($i(CList))="CT.CKB.PDSS.RuleI.GBL" 
	s CList($i(CList))="CT.CKB.PDSS.RuleDataD.GBL" //规则明细表
	s CList($i(CList))="CT.CKB.PDSS.RuleDataI.GBL" 
	s CList($i(CList))="CT.CKB.PDSS.RuleDicD.GBL" //规则索引表
	s CList($i(CList))="CT.CKB.PDSS.RuleDicI.GBL" 
	s CList($i(CList))="CT.CKB.PDSS.RuleNodeD.GBL" //规则节点表
	s CList($i(CList))="CT.CKB.PDSS.RuleNodeI.GBL" 
	s CList($i(CList))="CT.CKB.PDSS.SourcePoolD.GBL" //规则来源数据池表
	s CList($i(CList))="CT.CKB.PDSS.SourcePoolI.GBL" 
	s CList($i(CList))="CF.CKB.PDSS.DiagRelationD.GBL" //疾病病症关系表
	s CList($i(CList))="CF.CKB.PDSS.DiagRelationI.GBL"
	//s CList($i(CList))="CF.CKB.PDSS.GenIndexD.GBL" //药品通用名索引表(不放)
	//s CList($i(CList))="CF.CKB.PDSS.GenIndexI.GBL"
	s CList($i(CList))="CF.CKB.PDSS.IgnoreDataPoolD.GBL" //审核忽略配置数据池表
	s CList($i(CList))="CF.CKB.PDSS.IgnoreDataPoolI.GBL"
	s CList($i(CList))="CF.CKB.PDSS.IgnoreManageD.GBL" //审核忽略配置表
	s CList($i(CList))="CF.CKB.PDSS.IgnoreManageI.GBL" 
	//s CList($i(CList))="CF.CKB.PDSS.PluginTempD.GBL" //消息插件模板表(不放)
	//s CList($i(CList))="CF.CKB.PDSS.PluginTempI.GBL"
	s CList($i(CList))="CF.CKB.PDSS.PreDataPoolD.GBL" //前提条件数据池表
	s CList($i(CList))="CF.CKB.PDSS.PreDataPoolI.GBL" 
	s CList($i(CList))="CF.CKB.PDSS.SourcePriorityD.GBL" //规则优先级配置表
	s CList($i(CList))="CF.CKB.PDSS.SourcePriorityI.GBL"
	s CList($i(CList))="CF.CKB.PDSS.GrantAuthD.GBL" //审查目录授权表(上线清配置)
	s CList($i(CList))="CF.CKB.PDSS.GrantAuthI.GBL"
	s CList($i(CList))="CKB.PDSS.DicDataLogD.GBL"		// 知识日志详情表 CKB.PDSS.DicDataLog
	s CList($i(CList))="CKB.PDSS.DicDataLogI.GBL"	
	s CList($i(CList))="CKB.PDSS.DicLogD.GBL"			// 字典日志表 CKB.PDSS.DicLog
	s CList($i(CList))="CKB.PDSS.DicLogI.GBL"	
	s CList($i(CList))="CKB.PDSS.ExtDictionD.GBL"	   	// 外部项目字典表 CKB.PDSS.ExtDiction(只同步疾病部分)
	s CList($i(CList))="CKB.PDSS.ExtDictionI.GBL"
	s CList($i(CList))="CKB.PDSS.DicExtLinkAttrD.GBL"	// 外部项目属性关联表CKB.PDSS.DicExtLinkAttr
	s CList($i(CList))="CKB.PDSS.DicExtLinkAttrI.GBL"
	s CList($i(CList))="CKB.PDSS.RuleLogD.GBL"	   		// 规则日志表 CKB.PDSS.RuleLog
	s CList($i(CList))="CKB.PDSS.RuleLogI.GBL"
	s CList($i(CList))="CKB.PDSS.RuleDataLogD.GBL"	   	// 规则明细日志表 CKB.PDSS.RuleDataLog
	s CList($i(CList))="CKB.PDSS.RuleDataLogI.GBL"
	s CList($i(CList))="CKB.PDSS.RuleCopyLogD.GBL"	   	// 规则复制记录表 CKB.PDSS.RuleCopyLog
	s CList($i(CList))="CKB.PDSS.RuleCopyLogI.GBL"
	s CList($i(CList))="CKB.PDSS.ComContrastD.GBL"		// 数据映射表 CKB.PDSS.ComContrast (只同步疾病部分)
	s CList($i(CList))="CKB.PDSS.ComContrastI.GBL"
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zts
	s time = $replace(time,",","_")
	s time = $replace(time,".","_")
	s filename = path_""_"\Dthealth\app\dthis\web\temp\global\CKB.PDSS."_time_".gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// Creator:		qunianpeng
/// CreatDate:		2023-03-01
/// Description:： 	数据导入后，处理外部代码表数据，只保留和当前项目相关的数据(疾病、给药途径、用药频率、药品)
/// Input:			hospId 161上新建的医院id,	realHospId项目真实id
/// Other:
/// 导出global： d ##class(web.DHCCKBInitData).InitExtDictionData(151,2)
ClassMethod InitExtDictionData(hospId, realHospId)
{
	// 删除药品、给药途径、用药频率字典中，不属于当前医院的信息
	// SELECT * FROM CKB_PDSS.ExtDiction WHERE ED_Hospital NOT IN (2,151) AND ED_Type IN ('DrugData','ChineseDrugData','ChineseHerbalMedicineData','DrugFreqData','DrugPreMetData')
	s sqlstr = "Delete FROM CKB_PDSS.ExtDiction WHERE ED_Hospital NOT IN (2,"_hospId_") AND ED_Type IN ('DrugData','ChineseDrugData','ChineseHerbalMedicineData','DrugFreqData','DrugPreMetData')"
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	w "初始化外部项目药品数据成功",!

	// 删除不属于当前医院的疾病
	// SELECT * FROM  CKB_PDSS.ExtDiction WHERE ED_Hospital IS NOT NULL AND ED_Hospital NOT IN (2,151) AND ED_Type='DiseaseData'
	s sqlstr = "delete FROM  CKB_PDSS.ExtDiction WHERE ED_Hospital IS NOT NULL AND ED_Hospital NOT IN (2,"_hospId_") AND ED_Type='DiseaseData'"
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	w "初始化外部项目疾病数据成功",!
		
	// 修改医院为2和当前医院的id的数据，为实际的医院id
	s sqlstr = "UPDATE  CKB_PDSS.ExtDiction SET ED_Hospital="_realHospId_"WHERE ED_Hospital=2 OR ED_Hospital="_hospId
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	
	// 删除医院id不等于真实医院的其他数据
	s sqlstr = "Delete from  CKB_PDSS.ExtDiction WHERE ED_Hospital is NOT NULL AND ED_HospitalNOT IN ("_realHospId_")"
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	
	w "初始化外部项目医院信息成功",!
}

/// Creator:		qunianpeng
/// CreatDate:		2023-03-01
/// Description:： 	数据导入后，处理对照表数据，只保留和当前项目相关的对照数据(疾病、给药途径、用药频率、药品)
/// Input:			hospId 161上新建的医院id,	realHospId项目真实id
/// Other:
/// 导出global： d ##class(web.DHCCKBInitData).InitExtDictionData(151,2)
ClassMethod InitComContrastData(hospId, realHospId)
{
	// 删除不是当前医院的对照数据 对应的日志数据
	s sqlstr = "Delete FROM CKB_PDSS.DicLog WHERE DLG_Dic='DHC_CKBComContrast' AND DLG_Data_Dr IN ( "
	s sqlstr = sqlstr_"SELECT CC_RowID FROM CKB_PDSS.ComContrast WHERE CC_Hospital IS NOT NULL and CC_Hospital NOT IN (2,"_hospId_")"
	s sqlstr = sqlstr_")"
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	w "对照日志初始化成功",!
	
	// 删除不是当前医院的对照数据
	// SELECT * FROM CKB_PDSS.ComContrast WHERE CC_Hospital IS NOT NULL and CC_Hospital NOT IN (2,151)
	s sqlstr ="delete FROM CKB_PDSS.ComContrast WHERE CC_Hospital IS NOT NULL and CC_Hospital NOT IN (2,"_hospId_")"
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	w "对照数据初始化成功",!

	// 修改医院为2和当前医院的id的数据，为实际的医院id
	s sqlstr = "UPDATE CKB_PDSS.ComContrast SET CC_Hospital="_realHospId_" WHERE CC_Hospital=2 OR CC_Hospital="_hospId
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	w "对照数据医院信息初始化成功",!
}

/// Creator:		qunianpeng
/// CreatDate:		2023-03-01
/// Description:： 	数据导入后，处理对照表数据，只保留和当前项目相关的对照数据(疾病、给药途径、用药频率、药品)
/// Input:			hospId 161上新建的医院id,	realHospId项目真实id
/// Other:
/// 导出global： d ##class(web.DHCCKBInitData).InitImportData(151,2)
ClassMethod InitImportData(hospId, realHospId)
{
	/* 导入成功后,处理外部项目表(只保留和当前项目相关的疾病、频次、给药途径、药品) */
	d ##class(web.DHCCKBInitData).InitExtDictionData(hospId, realHospId)
	
	/* 导入成功后,处理对照表(只保留和当前项目相关的疾病、频次、给药途径、药品) */
	d ##class(web.DHCCKBInitData).InitComContrastData(hospId, realHospId)
	
	// 日志表的数据(清除授权日志)
	d ##class(web.DHCCKBConfig).InitPermis()
	
	q "初始化成功"
}

///  d ##class(web.DHCCKBInitData).testA(151,2)
ClassMethod testA(hospId, realHospId)
{
	// 修改医院为2和当前医院的id的数据，为实际的医院id
	s sqlstr = "UPDATE CKB_PDSS.ComContrast SET CC_Hospital="_realHospId_" WHERE CC_Hospital=2 OR CC_Hospital="_hospId
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlstr)
	d result.Execute()
	w "对照数据医院信息初始化成功",!
}

}

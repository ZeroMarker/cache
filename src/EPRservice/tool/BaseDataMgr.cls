Class EPRservice.tool.BaseDataMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 配置基础数据
/// Using: d ##class(EPRservice.tool.BaseDataMgr).ConfigBaseData()
ClassMethod ConfigBaseData() As %String
{
	s info = "基础数据配置发生错误，请根据提示信息检查后再重新配置!"
	
	s isOK = ..ConfigEPRAction()
	if isOK = "0"
	{	
		w info,!
		q
	}
	
	s isOK = ..ConfigEPRStatus()
	if isOK = "0"
	{
		w info,!
		q
	}
	
	s isOK = ..ConfigEPRActStatusCfg()
	if isOK = "0"
	{
		w info,!
		q
	}
	
	//wangwentao add
	d ..CreateRoleFuntion("")
	
	//wangwentao add
	d ..UpdateInitialData()
	
	//wangwentao add
	d ..UpdateGlossaryData()
		
	//系统参数请单独配置
	/*s isOK = ..ConfigSysOption()
	if isOK = "0"
	{
		w info,!
		q
	}
	*/
}

/// Desc: 配置 EPRmeta.EPRAction
/// Using: w ##class(EPRservice.tool.BaseDataMgr).ConfigEPRAction()
ClassMethod ConfigEPRAction() As %String
{
	S $zt = "ErrorHandlerEPRAction"
	
	TSTART
	
	w "Begin of config EPRmeta.EPRAction !!!",!
	
	do ..SetEPRAction("save", "保存")
	do ..SetEPRAction("complete", "完成")
	do ..SetEPRAction("commit", "提交")
	do ..SetEPRAction("print", "打印")
	do ..SetEPRAction("switch", "切换模板") 
	do ..SetEPRAction("attendingCheck", "主治医师审核")
	do ..SetEPRAction("chiefCheck", "主任医师审核")
	do ..SetEPRAction("refreshNecessary", "刷新必填界面模板")
	do ..SetEPRAction("refreshUnnecessary", "刷新非必填界面模板")
	//病历引用基础数据2011-11-29 wangwentao add
	do ..SetEPRAction("reference","引用")
	do ..SetEPRAction("refcomplete","引用完成")
	
	w "Suceed of config EPRmeta.EPRAction !!!",!
	
	TCOMMIT
	
	quit "1"
	
ErrorHandlerEPRAction
	w "Error occured in config EPRmeta.EPRAction !!!",!
	w "Error info is: ", !, $ZError
	TROLLBACK
	w "RollBack configuration on EPRmeta.EPRAction finished !!!",!
	q "0"
}

ClassMethod SetEPRAction(argCode As %String, argName As %String) As %String
{
	s code = $zcvt(argCode,"U")
	s rowid = $O(^DHCEPRM.EPRActionI("IdxActionCode"," "_code,""))
	if rowid=""
	{
		&sql(insert INTO EPRmeta.EPRAction (ActionCode, ActionName) 
			VALUES (:argCode, :argName))
	}
	else
	{
		&sql(update EPRmeta.EPRAction 
			set ActionCode = :argCode, ActionName = :argName
		 	where ID = :rowid)
	}
}

/// Desc: 配置 EPRmeta.EPRStatus
/// Using: w ##class(EPRservice.tool.BaseDataMgr).ConfigEPRStatus()
ClassMethod ConfigEPRStatus() As %String
{
	S $zt = "ErrorHandlerEPRStatus"
	
	TSTART
	
	w !
	w "Begin of config EPRmeta.EPRStatus !!!",!
	
	do ..SetEPRStatus("unfinished", "未完成")
	do ..SetEPRStatus("finished", "完成")
	do ..SetEPRStatus("commited", "已提交")
	do ..SetEPRStatus("attendingChecked", "主治医师审核")
	do ..SetEPRStatus("chiefChecked", "主任医师审核") 
	do ..SetEPRStatus("archieved", "已归档")
	
	w "Suceed of config EPRmeta.EPRStatus !!!",!
	
	TCOMMIT
	
	quit "1"
	
ErrorHandlerEPRStatus
	w "Error occured in config EPRmeta.EPRStatus !!!",!
	w "Error info is: ", !, $ZError
	TROLLBACK
	w "RollBack configuration on EPRmeta.EPRStatus finished !!!",!
	q "0"
}

ClassMethod SetEPRStatus(argCode As %String, argName As %String) As %String
{
	s upperCode = $zcvt(argCode,"U")
	s rowid = $O(^DHCEPRM.EPRStatusI("IdxStatusCode"," "_upperCode,""))
	if rowid = ""
	{
		&sql(insert INTO EPRmeta.EPRStatus (StatusCode, StatusName) 
			VALUES (:argCode, :argName))
	}
	else
	{
		&sql(update EPRmeta.EPRStatus 
			set StatusCode = :argCode, StatusName = :argName
		 	where ID = :rowid)
	}
}

/// Desc: 配置 EPRmeta.EPRActStatusCfg
/// Using: w ##class(EPRservice.tool.BaseDataMgr).ConfigEPRActStatusCfg()
ClassMethod ConfigEPRActStatusCfg() As %String
{
	S $zt = "ErrorHandlerEPRActStatusCfg"
	
	TSTART
	
	w !
	w "Begin of config EPRmeta.EPRActStatusCfg !!!",!
	
	do ..SetEPRActStatusCfg(" ", "save", "unfinished")
	do ..SetEPRActStatusCfg(" ", "complete", "finished")
	do ..SetEPRActStatusCfg(" ", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg(" ", "refreshUnnecessary", "unfinished")
	//病历引用基础数据2011-11-29 wangwentao add / 20120705 wangwentao update PreStatus -> EPRAction -> PostStatus
	do ..SetEPRActStatusCfg(" ","reference","unfinished")
	do ..SetEPRActStatusCfg(" ","refcomplete","finished")
	//
	
	do ..SetEPRActStatusCfg("unfinished", "save", "unfinished")
	do ..SetEPRActStatusCfg("unfinished", "complete", "finished")
	do ..SetEPRActStatusCfg("unfinished", "switch", "unfinished")
	do ..SetEPRActStatusCfg("unfinished", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("unfinished", "refreshUnnecessary", "unfinished")
	//病历引用基础数据2011-11-29 wangwentao add / 20120705 wangwentao update PreStatus -> EPRAction -> PostStatus
	do ..SetEPRActStatusCfg("unfinished","reference","unfinished")
	do ..SetEPRActStatusCfg("unfinished","refcomplete","finished")
	//
	
	
	do ..SetEPRActStatusCfg("finished", "save", "finished")
	do ..SetEPRActStatusCfg("finished", "complete", "finished")
	do ..SetEPRActStatusCfg("finished", "print", "finished")
	do ..SetEPRActStatusCfg("finished", "commit", "commited")
	do ..SetEPRActStatusCfg("finished", "switch", "unfinished")
	do ..SetEPRActStatusCfg("finished", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("finished", "refreshUnnecessary", "finished")
	//病历引用基础数据2011-11-29 wangwentao add / 20120705 wangwentao update PreStatus -> EPRAction -> PostStatus
	do ..SetEPRActStatusCfg("finished","reference","finished")
	do ..SetEPRActStatusCfg("finished","refcomplete","finished")
	//
	
	//do ..SetEPRActStatusCfg("commited", "save", "commited")
	do ..SetEPRActStatusCfg("commited", "complete", "commited")
	do ..SetEPRActStatusCfg("commited", "print", "commited")
	do ..SetEPRActStatusCfg("commited", "switch", "unfinished")
	do ..SetEPRActStatusCfg("commited", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("commited", "refreshUnnecessary", "commited")
	do ..SetEPRActStatusCfg("commited", "attendingCheck", "attendingChecked")
	do ..SetEPRActStatusCfg("commited", "chiefCheck", "chiefChecked")
	//
	
	
	do ..SetEPRActStatusCfg("attendingChecked", "complete", "attendingChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "print", "attendingChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "chiefCheck", "chiefChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("attendingChecked", "refreshUnnecessary", "attendingChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "switch", "unfinished")
	
		
	do ..SetEPRActStatusCfg("chiefChecked", "complete", "chiefChecked")
	do ..SetEPRActStatusCfg("chiefChecked", "print", "chiefChecked")
	do ..SetEPRActStatusCfg("chiefChecked", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("chiefChecked", "refreshUnnecessary", "chiefChecked")
	do ..SetEPRActStatusCfg("chiefChecked", "switch", "unfinished")
	//
	
	
	do ..SetEPRActStatusCfg("archieved", "print", "archieved")
	//

	
	w "Suceed of config EPRmeta.EPRActStatusCfg !!!",!
	
	TCOMMIT
	
	quit "1"
	
ErrorHandlerEPRActStatusCfg
	w "Error occured in config EPRmeta.EPRActStatusCfg !!!",!
	w "Error info is: ", !, $ZError
	TROLLBACK
	w "RollBack configuration on EPRmeta.EPRActStatusCfg finished !!!",!
	q "0"
}

ClassMethod SetEPRActStatusCfg(argPreStatus As %String, argAction As %String, argPostStatus) As %String
{
	
	&sql(select ID into :rowid from EPRmeta.EPRActStatusCfg
		where PreStatus = :argPreStatus and EPRAction = :argAction)
	
	if rowid = ""
	{
		&sql(insert into EPRmeta.EPRActStatusCfg (PreStatus, EPRAction, PostStatus) 
			values (:argPreStatus, :argAction, :argPostStatus))
	}
	else
	{
		&sql(update EPRmeta.EPRActStatusCfg
			set PreStatus = :argPreStatus, EPRAction = :argAction, PostStatus = :argPostStatus
		 	where ID = :rowid)
	}
}

/// Desc: 配置 EPRmeta.SysOption
ClassMethod ConfigSysOption() As %String
{
	S $zt = "ErrorHandlerSysOption"

	w "Begin of config EPRmeta.SysOption !!!",!
	
	//此参数维护程序自动创建
	//s desc = "系统|维护程序的最新版本号"
	//d ..SetSysOption("LastProductVersion", desc,"1.1.1.1","N")
	
	s desc = "系统|医院名称[拼音首字母]"
	d ..SetSysOption("HospitalName", desc,"","Y")
	s desc = "系统|HIS命名空间[NAME1^NAME2]"
	d ..SetSysOption("NameSpaceHIS", desc,"MEDDATA^WEBSRC","Y")
	s desc = "系统|LIS命名空间[NAME1^NAME2]"
	d ..SetSysOption("NameSpaceLIS", desc,"LABDATA^LABSRC","Y")
	s desc = "系统|RIS命名空间[NAME1^NAME2]"
	d ..SetSysOption("NameSpaceRIS", desc,"RIS","Y")
	s desc = "系统|开启多线程模式初始化病历[启用->Y][禁用->N]"
	d ..SetSysOption("UseMultiThreading", desc,"Y","Y")
	s desc = "系统|开启ICD疾病编码副码扩展[启用->Y][禁用->N]"
	d ..SetSysOption("ICDCodeExpand", desc,"N","Y")
	s desc = "系统|记录程序加载过程的时间日志(用于病历运行速度调试 日志位置C盘根目录)[启用->Y][禁用->N]"
	d ..SetSysOption("ProcessLogActivity", desc,"N","Y")
	s desc = "系统|病历书写自动保存时间间隔(单位为秒)[数值型][禁用->-1]"
	d ..SetSysOption("AutoSaveTime", desc,"-1","Y")
	s desc = "系统|新框架是否显示使用说明和质控提示(格式为Y^Y或N^Y或Y^N,须用大写,中间用^分割,第一个Y(N)判断是否显示使用说明标签,第二个Y(N)判断是否显示质控提示标签,若参数配置为N^N,则系统会显示使用说明标签)"
	d ..SetSysOption("ShowHelpAndQuality", desc,"Y^Y","Y")
	s desc = "系统|是否开启病历预览生成服务日志[Y/N]"
	d ..SetSysOption("PreviewLogFlag", desc,"N","Y")
	s desc = "系统|新框架自动打开打开第一个界面模板[Y/N]"
	d ..SetSysOption("OpenFristTemplate", desc,"N","Y")
	
	s desc = "界面|TRAKCARE端病历界面背景颜色[P5->DEDFFF][P7->F4F4F4]"
	d ..SetSysOption("BGColor", desc, "F4F4F4", "Y")
	s desc = "界面|界面模板设计默认字号大小[小五号->9][五号->10.5]"
	d ..SetSysOption("DefaultFontSize", desc,"10.5","Y")
	s desc = "界面|字典单元查询结果每页显示行数[数值型]"
	d ..SetSysOption("DicPageRowCount", desc,"12","Y")
	s desc = "界面|字典查询结果只屏蔽描述字段中第一个横杠"-"前的内容[表名1.字段名1,表名2.字段名2,...]"
	d ..SetSysOption("NotRemoveMinus", desc,"SQLUser.ORC_Operation.OPER_Desc","Y")
	s desc = "界面|复杂单元右键是否可以引用LIS数据[启用->Y][禁用->N]"
	d ..SetSysOption("LISCitation", desc,"Y","Y")
	s desc = "界面|复杂单元右键是否可以引用RIS数据[启用->Y][禁用->N]"
	d ..SetSysOption("RISCitation", desc,"Y","Y")
	
	s desc = "知识库|允许前端编辑知识库[允许->TRUE][禁止->FALSE]"
	d ..SetSysOption("KBEditable", desc,"FALSE","Y")
	s desc = "知识库|设置界面上知识库窗口的宽度(正整数,以像素为单位)"
	d ..SetSysOption("KBPanelWidth", desc,"100","Y")
	s desc = "知识库|允许删除知识库资源管理器中的知识库模板[启用->Y][禁用->N]"
	d ..SetSysOption("CanDeleteKB", desc,"N","Y")
	s desc = "知识库|取消知识库的发布状态进行作废单元清除[启用->Y][禁用->N]"
	d ..SetSysOption("CanKBStatusSwitch", desc,"Y","Y")
	
	s desc = "接口|临床PDA接口[图表ID^模板目录ID^模板ID]"
	d ..SetSysOption("PDAInterface", desc,"^^","Y")
	
	s desc = "历次|允许修改历次病历标题[启用->Y][禁用->N]"
	d ..SetSysOption("ListTitleEditable", desc,"Y","Y")
	s desc = "历次|允许修改历次病历发生时间[启用仅创建时修改->Y][启用随时修改->Y^Y][禁用->N]"
	d ..SetSysOption("ListTimeEditable", desc,"Y^Y","Y")
	s desc = "历次|可重复模板标题下拉列表选项维护[Tid1|Title1-Alias1-Y^Title2-Alias2#Tid2|Title3-Alias3^Title4-Alias4#...]"
	d ..SetSysOption("ListTitleChoice", desc,"Null","Y")
	
	s desc = "打印|可重复打印模板默认标准行高[数值型]"
	d ..SetSysOption("TextRowHeight", desc,"30","Y")
	s desc = "打印|打印模板顺序自动关联项目维护(PTid2第一条记录的起始页及行自动接在PTid1后续打)[PTid1^PTid2|PTid3^PTid4...]"
	d ..SetSysOption("PrtTplOrder", desc,"^","Y")
		
	s desc = "维护|允许删除病历展现结构[启用->Y][禁用->N]"
	d ..SetSysOption("AllowDeleteEPRDoc", desc,"N","Y")
	
	s desc = "权限|开启电子病历留痕修改[启用->Y][禁用->N]"
	d ..SetSysOption("Revision", desc,"N","Y")
	s desc = "权限|开启三级医师操作权限[启用->Y][禁用->N]"
	d ..SetSysOption("PrivControl", desc,"N","Y")
	s desc = "权限|开启动态页签模板权限[启用->Y][禁用->N]"
	d ..SetSysOption("TPrivActivity", desc,"N","Y")
	s desc = "权限|开启安全组目录查看权限[启用->Y][禁用->N]"
	d ..SetSysOption("CPrivActivity", desc,"N","Y")
	s desc = "权限|模板权限多套模板病历类型取数代码"
	d ..SetSysOption("PatCatalogUnitCode", desc,"病历类型#TYPE:Simple#TID:100#TVER:0#SCODE:I0024#VTYPE:C","Y")
	s desc = "权限|模板权限多套模板病历类型逻辑规则[^LocID1^LocID2^@^Type1^Tpye2^||^LocID3^LocID4^@^Type3^Tpye4^||^...^]"
	d ..SetSysOption("TPrivPatTypeString", desc,"^","Y")
	s desc = "权限|模板权限是否启用临时科室[不启用->NULL][全部启用->ALL][个别科室启用->LocID1^LocID2^LocID3]"
	d ..SetSysOption("TPrivTempDept", desc,"NULL","Y")
	
	s desc = "预览|病历预览本地路径(EXE路径,更新服务时dll下载的临时路径,病历浏览需要的内容的xml存放的路径,FTP操作没有返回值后的等待时间)(毫秒)"
	d ..SetSysOption("PreviewLocalPath", desc,"c:\windows\dhceprpreview^c:\windows\dhceprpreview\temp^c:\windows\dhceprpreview\xml^1000","Y")
	s desc = "预览|FTP服务器信息(最后一项是FTP操作没有返回值后的等待时间)(毫秒)"
	d ..SetSysOption("SavePrintImage", desc,"Null","Y")
	s desc = "预览|域管理模式下安装更新病历预览后台服务所需的域管理员信息UserName^DomainName^PassWord"
	d ..SetSysOption("PreviewImpersonator", desc,"Null","Y")
	
	s desc = "质控|唯一模板的质控点(save、commit和print),多个质控点之间用^分隔"
	d ..SetSysOption("SingleQualityCtrl", desc,"Null","Y")
	s desc = "质控|可重复模板的质控点(save、commit和print),多个质控点之间用^分隔"
	d ..SetSysOption("MultiQualityCtrl", desc,"Null","Y")
	
	s hospital = ##class(EPRmeta.SysOption).GetOptionValueByName("HospialName")
	if hospital = "AHSLYY"
	{
		s desc = "合肥专用|开启自动生成病案台账[启用->Y][禁用->N]"
		d ..SetSysOption("AutomakeCaseRecordNo", desc,"N","Y")
		s desc = "合肥专用|开启自动生成病案台账模板(专用一)相关参数[模板ID^出院科室ITEMCODE^出院年份"
		d ..SetSysOption("ParaRecordRoom1", desc,"7^O0001^S0002^S0003","Y")
		s desc = "合肥专用|开启自动生成病案台账模板(专用二)相关参数[模板ID^出院科室ITEMCODE^出院年份"
		d ..SetSysOption("ParaRecordRoom2", desc,"6^O0001^S0002^S0004^S0003","Y")
	}

	w "Suceed of config EPRmeta.SysOption !!!",!
	
	quit "1"
	
ErrorHandlerSysOption
	w "Error occured in config EPRmeta.SysOption !!!",!
	w "Error info is: ", !, $ZError
	q "0"
}

ClassMethod SetSysOption(argName As %String, argDesc As %String, argDefaultValue As %String, argVisible As %String) As %String
{
	s count = 0, optionValue = ""
	&sql(select count(ID), OptionValue into :count, :optionValue from EPRmeta.SysOption
		where Name = :argName)
		
	if count<1
	{
		s value = ..ConfirmSysOptionValue(argName,argDesc,argDefaultValue)
		&sql(insert into EPRmeta.SysOption (Name, Description, OptionValue, IsVisible) 
			values (:argName, :argDesc, :value, :argVisible))
		w "新建系统参数成功",!
	}
	else
	{
		w !
		w "参数: "_argName_"已存在, 参数值为: ",!
		w optionValue,!
		&sql(update EPRmeta.SysOption set Description = :argDesc where Name = :argName)
	}
}

/// Desc:	与用户交互，确认要新增的系统参数值
ClassMethod ConfirmSysOptionValue(argName As %String, argDesc As %String, argDefaultValue As %String) As %String
{
	w !
	w "新建系统参数: ",!
	w "参数名称: "_argName,!
	w "参数描述: "_argDesc,!
	if argDefaultValue = ""
	{	w "默认参数值: 空",!}
	else 
	{	w "默认参数值: "_argDefaultValue,!}
	
	//与用户交互, 是否使用默认参数值
	if (argDefaultValue '= "")
	{
		s useDefaultValue="n"
		for {
			Read "使用默认参数值请输入:y, 否则请输入:n    ", useDefaultValue
			w !
			if ($zcvt(useDefaultValue,"U")="Y")||(($zcvt(useDefaultValue,"U")="N"))
			{	q }
			w "输入错误，请输入 y 或者 n",!
		}
		q:($zcvt(useDefaultValue,"U")="Y") argDefaultValue
	}
	
	//与用户交互，使用新的参数值
	s newValue = ""
	for {
		Read "请输入新的参数值  ", newValue
		w !
		
		if newValue="" 
		{	
			w "参数值不能为空",!
			continue
		}
		
		if $F(newValue," ")>0
		{	
			Read "参数值中含有空格,请确认: y 或 n", isBlankOK
			w !
			q:($zcvt(isBlankOK,"U")="Y")
			continue
		} 
		
		q
	}
	
	q newValue
}

/// Desc: 配置标准字典表,未完成
ClassMethod ConfigStdDictionary()
{
}

ClassMethod SetStdDictionary(argTableName As %String, argRuleTypeTag As %String) As %String
{
	&sql(select count(ID) into :count from EPRmeta.StdDictionary where TableName = :argTableName)
	if count=1
	{ 
		&sql(select ID,Code,Name,TableName,RuleTypeTag into :curid,:code,:name,:tableName,:ruleTypeTag 
			from EPRmeta.StdDictionary where TableName = :argTableName)
		if ruleTypeTag '= argRuleTypeTag
		{
			&sql(update EPRmeta.StdDictionary set IsRuleType = 'Y', RuleTypeTag = :argRuleTypeTag
				where TableName = :argTableName)
			w "代码:"_code_" 名称:"_name_" 对应表名:"_tableName_" 规则类别标识:"_ruleTypeTag,!
			w "规则类别修改为:"_argRuleTypeTag,!
		}
	}
	elseif count>1
	{
		s ruleTypeId = ""
		
		w "字典表: "_argTableName_" 被重复引用 "_count_" 次",!
		w "其信息如下:",!
				
		&sql(declare myCursor cursor for 
			select ID, Code, Name, TableName, IsRuleType, RuleTypeTag into :curid,:code,:name,:tableName,:isRuleType,:RuleTypeTag
			from EPRmeta.StdDictionary where TableName = :argTableName)
		&sql(open myCursor)
		for {
			&sql(fetch myCursor)
			q:(SQLCODE)
			
			s:(isRuleType'="") ruleTypeId = curid
			
			w "字典"
		}
		&sql(close myCursor)
	}
}

///  维护程序角色权限初始化
///   
ClassMethod SetFunction(funcName As %String, funcDesc As %String, parentID As %String, type As %String) As %String
{
	s ID = ""
	&sql(select ID into :ID from EPRMeta.MainDictFunction where FuncName = :funcName)
	
	if (ID = "") || (ID = $c(0))
	{
	&sql(insert into EPRMeta.MainDictFunction (FuncName,FuncDesc,ParentID, Type)
        	values (:funcName, :funcDesc, :parentID, :type))	
	&sql(select ID into :ID from EPRMeta.MainDictFunction where FuncName = :funcName)	
    }
    else
    {
	  &sql(update EPRMeta.MainDictFunction
	       set FuncDesc = :funcDesc , ParentID = :parentID , Type = :type  
	       where FuncName = :funcName)
	}
	
	q ID
}

/// 初始化权限字典
ClassMethod IniDictFunctions()
{
	// 初始化权限字典
    s groupType = "Group"
    s itemType = "Item"
	s funcID = ""
	//&sql(insert into EPRMeta.MainDictFunction (FuncName,FuncDesc,ParentID, Type)
	//values ('Menu_View', '视图', '0', 'Group'))
  	s funcID = ..SetFunction("Menu_View", "视图", "0", groupType)	  	
  	d ..SetFunction("Menu_View_ITemplate", "界面模板资源管理器", funcID, itemType)
	d ..SetFunction("Menu_View_Knowledge", "知识库资源管理器", funcID, itemType)
	d ..SetFunction("Menu_View_PTemplate", "打印模板资源管理器", funcID, itemType)
	d ..SetFunction("Menu_View_RTemplate", "报表模板资源管理器", funcID, itemType)	
	d ..SetFunction("Menu_View_Glossary",  "术语集资源管理器", funcID, itemType)
	d ..SetFunction("Menu_View_ImageLibrary",  "图库资源管理器", funcID, itemType)
	d ..SetFunction("Menu_View_DataElement",  "数据元资源管理器", funcID, itemType)	//20130731 wangwentao add
	

    s funcID = ..SetFunction("Menu_Tools", "设置", "0", groupType)
	d ..SetFunction("Menu_Tools_DictionarySet", "字典表设置", funcID, itemType)
	d ..SetFunction("Menu_Tools_UnitSet", "数量单位设置", funcID, itemType)
	d ..SetFunction("Menu_Tools_EpisodeDataSet", "就诊数据项维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_CategoryTypeSet", "界面模板目录类型维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_CTPropertySet", "界面模板及目录属性维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_DataExport", "导出数据", funcID, itemType)
	d ..SetFunction("Menu_Tools_EPRExport", "导出病历", funcID, itemType)
	d ..SetFunction("Menu_Tools_DataRefersSet", "数据引用设置", funcID, itemType)
	d ..SetFunction("Menu_Tools_ParamsSet", "系统参数维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_SuperUserSet", "用户维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_InsStatusConfig", "病历状态设置", funcID, itemType)
	d ..SetFunction("Menu_Tools_QuotePageSet", "页面引用设置", funcID, itemType)
	d ..SetFunction("Menu_Tools_EPRCategoryShowSet", "病历展现结构设置", funcID, itemType)
	d ..SetFunction("Menu_Tools_DynamicConfigTable", "公用字典集数据维护", funcID, itemType)
	
	s funcID = ..SetFunction("Menu_Tools_PrivConfig", "权限设置", funcID, groupType)
	d ..SetFunction("Menu_Tools_PrivConfig_PrivRuleConfig", "权限规则维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_PrivConfig_UserLevelConfig", "医生级别维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_PrivConfig_SubUserConfig", "下级医生维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_PrivConfig_TempConfig", "模板权限配置", funcID, itemType)
	d ..SetFunction("Menu_Tools_PrivConfig_RoleFunctionSet","角色权限设置",funcID, itemType)
	d ..SetFunction("Menu_Tools_PrivRuleType", "规则类型维护", funcID, itemType)
	d ..SetFunction("Menu_Tools_PrivConfig_RoleKBTreeSet", "角色知识库设置", funcID, itemType) 	//20120701 wangwentao add Version:R20120612

    s funcID = ..SetFunction("Btn_Edit", "编辑", "0", groupType)
    d ..SetFunction("Btn_Edit_AddCategory", "新建目录", funcID, itemType)
	d ..SetFunction("Btn_Edit_AddResource", "添加新项", funcID, itemType)
	d ..SetFunction("Btn_Edit_AddVersion", "新建版本", funcID, itemType)
	d ..SetFunction("Btn_Edit_Open", "打开", funcID, itemType)
	d ..SetFunction("Btn_Edit_Cut", "剪切", funcID, itemType)
	d ..SetFunction("Btn_Edit_Paste", "粘贴", funcID, itemType)
	d ..SetFunction("Btn_Edit_Copy", "复制", funcID, itemType)
	d ..SetFunction("Btn_Edit_Delete", "删除", funcID, itemType)
	d ..SetFunction("Btn_Edit_Property", "属性", funcID, itemType)
	d ..SetFunction("Btn_Edit_Export", "导出", funcID, itemType)
	d ..SetFunction("Btn_Edit_Input", "导入", funcID, itemType)
	d ..SetFunction("Btn_Edit_Refresh", "刷新", funcID, itemType)
	d ..SetFunction("Btn_Edit_Update", "更新", funcID, itemType)
	
    s funcID = ..SetFunction("Btn_File", "文件", "0", "Group")		
    d ..SetFunction("Btn_File_Save", "保存", funcID, itemType)
	d ..SetFunction("Btn_File_SaveAll", "全部保存", funcID, itemType)
	d ..SetFunction("Btn_File_Publish", "发布", funcID, itemType)
	
    w !,"初始化权限字典成功"
}

///  
ClassMethod SetRoleFunction(roleId As %String)
{
	&sql(declare funcCursor cursor for select funcName into :name 
	       from EPRMeta.MainDictFunction where Type = 'Item' order by ID)
	&sql(open funcCursor)
	for {
		&sql(fetch funcCursor)
		q:(SQLCODE)
				
		if (name'=""){
		    s ID = ""
	        &sql(select ID into :ID from eprmeta.MainRoleFunction where RoleId = :roleId and FuncName = :name)
            if ID = ""{
              &sql(insert into EPRMeta.MainRoleFunction (RoleId,FuncName) values (:roleId, :name))
            }		
		}
	}
	&sql(close funcCursor)
}

/*
///        end  维护程序角色权限初始化
/// 初始化术语集
/// 
/// d ##Class(EPRservice.tool.BaseDataMgr).IniGlossaryCategory()
ClassMethod IniGlossaryCategory()
{
	Tstart
	d ..insertRecord("EMR01.00 病历概要数据集","EMR01.00 病历概要数据集","0")

	d ..insertRecord("EMR02.00 门（急）诊病历数据集","EMR02.00 门（急）诊病历数据集","0")
  
	s ID = 0
	&sql(select MAX(ID) into :ID from EPRmeta.GlossaryCategory)  
	s ID = ID - 2

	d ..insertRecord("门(急)诊病历","门(急)诊病历", 2 + ID)

	d ..insertRecord("急诊留观病历","急诊留观病历", 2 + ID)


	d ..insertRecord("EMR03.00 门(急)诊处方数据集","EMR03.00 门(急)诊处方数据集","0")

	d ..insertRecord("西医处方","西医处方", 5 + ID)

	d ..insertRecord("中医处方","中医处方", 5 + ID)


	d ..insertRecord("EMR04.00 检查检验记录数据集","EMR04.00 检查检验记录数据集","0")

	d ..insertRecord("检查记录","检查记录", 8 + ID)

	d ..insertRecord("检验记录","检验记录", 8 + ID)


	d ..insertRecord("治疗处置-一般治疗处置记录数据集","EMR05.01 治疗处置-一般治疗处置","0")

	d ..insertRecord("治疗记录","治疗记录", 11 + ID)

	d ..insertRecord("手术记录","手术记录", 11 + ID)

	d ..insertRecord("麻醉记录","麻醉记录", 11 + ID)

	d ..insertRecord("输血记录","输血记录", 11 + ID)


	d ..insertRecord("治疗处置-助产记录数据集","EMR05.02 治疗处置-助产记录数据","0")

	d ..insertRecord("待产记录","待产记录", 16 + ID)

	d ..insertRecord("剖宫产手术记录","剖宫产手术记录", 16 + ID)

	d ..insertRecord("自然分娩记录","自然分娩记录", 16 + ID)


	d ..insertRecord("护理-护理操作记录数据集","EMR06.01 护理-护理操作记录数据","0")

	d ..insertRecord("一般护理记录","一般护理记录", 20 + ID)

	d ..insertRecord("特殊护理手术记录","特殊护理手术记录", 20 + ID)

	d ..insertRecord("手术护理记录","手术护理记录", 20 + ID)

	d ..insertRecord("生命体征测量记录","生命体征测量记录", 20 + ID)

	d ..insertRecord("注射输液巡视记录","注射输液巡视记录", 20 + ID)


	d ..insertRecord("护理-护理评估与计划数据集","EMR06.02 护理-护理评估与计划","0")

	d ..insertRecord("护理计划","护理计划", 26 + ID)

	d ..insertRecord("一次性卫生耗材使用记录","一次性卫生耗材使用记录", 26 + ID)

	d ..insertRecord("出院评估及指导记录","出院评估及指导记录", 26 + ID)

	d ..insertRecord("入院评估记录","入院评估记录", 26 + ID)


	d ..insertRecord("知情告知信息数据集","EMR07.00 知情告知信息数据集","0")

	d ..insertRecord("手术同意书","手术同意书", 31 + ID)

	d ..insertRecord("特殊检查及治疗同意书","特殊检查及治疗同意书", 31 + ID)

	d ..insertRecord("特殊药品及材料使用同意书","特殊药品及材料使用同意书", 31 + ID)

	d ..insertRecord("输血同意书","输血同意书", 31 + ID)

	d ..insertRecord("病危（重）通知书","病危（重）通知书", 31 + ID)

	d ..insertRecord("麻醉同意书","麻醉同意书", 31 + ID)


	d ..insertRecord("EMR08.01 住院病案首页数据集","EMR08.01 住院病案首页数据集","0")

	d ..insertRecord("中医住院病案首页数据集","EMR08.02 中医住院病案首页数据集","0")


	d ..insertRecord("住院志数据集","EMR09.00 住院志数据集","0")

	d ..insertRecord("","入院记录", 40 + ID)

	d ..insertRecord("二十四小时内入出院记录","二十四小时内入出院记录", 40 + ID)

	d ..insertRecord("二十四小时内入院死亡记录","二十四小时内入院死亡记录", 40 + ID)


	d ..insertRecord("住院病程记录数据集（一）","EMR10.00 住院病程记录数据集 一","0")

	d ..insertRecord("首次病程记录","首次病程记录", 44 + ID)

	d ..insertRecord("日常病程记录","日常病程记录", 44 + ID)

	d ..insertRecord("上级医生查房记录","上级医生查房记录", 44 + ID)

	d ..insertRecord("疑难病例讨论","疑难病例讨论", 44 + ID)

	d ..insertRecord("交接班记录","交接班记录", 44 + ID)

	d ..insertRecord("转科记录","转科记录", 44 + ID)


	d ..insertRecord("住院病程记录数据集（二）","EMR10.00 住院病程记录数据集 二","0")

	d ..insertRecord("死亡记录","死亡记录", 51 + ID)

	d ..insertRecord("死亡病例讨论记录","死亡病例讨论记录", 51 + ID)


	d ..insertRecord("住院病程记录数据集（三）","EMR10.00 住院病程记录数据集 三","0")

	d ..insertRecord("抢救记录","抢救记录", 54 + ID)

	d ..insertRecord("会诊记录","会诊记录", 54 + ID)

	d ..insertRecord("术前小结","术前小结", 54 + ID)

	d ..insertRecord("术前讨论","术前讨论", 54 + ID)

	d ..insertRecord("术后首次病程记录","术后首次病程记录", 54 + ID)

	d ..insertRecord("出院小结","出院小结", 54 + ID)


	d ..insertRecord("住院医嘱数据集","EMR11.00 住院医嘱数据集","0")


	d ..insertRecord("长期医嘱","长期医嘱", 61 + ID)

	d ..insertRecord("临时医嘱","临时医嘱", 61 + ID)


	d ..insertRecord("出院记录数据集","EMR12.00 出院记录数据集","0")

	d ..insertRecord("转诊(院)记录数据集","EMR13.00 转诊(院)记录数据集","0")

	d ..insertRecord("医疗机构信息数据集","EMR14.00 医疗机构信息数据集","0")
	
	i (SQLCODE=0) 
    {
	    Tcommit
	    w !,"初始化术语集完成"
    } 
    else
    {  
        trollback
        w !,"初始化术语集失败 SQLCODE:"_SQLCODE
    }
}

ClassMethod insertRecord(description As %String, name As %String, parentID As %String)
{
	&sql(insert into EPRmeta.GlossaryCategory(Description, Name, ParentID, ResChildCount)
        	values (:description, :name, :parentID, '0'))
}
*/
ClassMethod SetRoleRBtnFunc(roleId As %String)
{
	&sql(declare fCursor cursor for select funcName into :name 
	     from EPRMeta.MainDictFunction where parentID in 
	       (select Id from EPRMeta.MainDictFunction 
	         where funcname = 'Btn_Edit' or funcname = 'Btn_File'))
	&sql(open fCursor)
	for {
		&sql(fetch fCursor)
		q:(SQLCODE)
				
		if (name'=""){
		    s ID = ""
	        &sql(select ID into :ID from eprmeta.MainRoleFunction where RoleId = :roleId and FuncName = :name)
            if ID = ""{
              &sql(insert into EPRMeta.MainRoleFunction (RoleId,FuncName) values (:roleId, :name))
            }		
		}
	}
	&sql(close fCursor)
}

/// 设置默认角色 knowledge/template/guest	
ClassMethod SetDefaultRoleFunc(RoleName As %String, RoleDesc As %String, Template As %String, KnowledgeBase As %String, PrintTemplate As %String, ReportTemplate As %String, Glossary As %String)
{
	s RoleID = ""
	&sql(select ID into :RoleID from EPRMeta.MainRole where RoleName = :RoleName)
	if RoleID=""  // insert
	{
		&sql(insert into EPRMeta.MainRole (RoleName,RoleDesc) values (:RoleName, :RoleDesc))
		&sql(select ID into :RoleID from EPRMeta.MainRole where RoleName = :RoleName)
	}
	
	&sql(delete from EPRMeta.MainRoleFunction where RoleID = :RoleID)
		
	if (Template '=""){
	  &sql(insert into EPRMeta.MainRoleFunction (RoleId,FuncName) values (:RoleID, :Template))
	}	 
	if (KnowledgeBase '=""){
	  &sql(insert into EPRMeta.MainRoleFunction (RoleId,FuncName) values (:RoleID, :KnowledgeBase))
	}  
	if (PrintTemplate '=""){
	  &sql(insert into EPRMeta.MainRoleFunction (RoleId,FuncName) values (:RoleID, :PrintTemplate))
	}  
	if (ReportTemplate '=""){
	  &sql(insert into EPRMeta.MainRoleFunction (RoleId,FuncName) values (:RoleID, :ReportTemplate))
	}  
	if (Glossary '=""){
	  &sql(insert into EPRMeta.MainRoleFunction (RoleId,FuncName) values (:RoleID, :Glossary))
	}
	
	d ..SetRoleRBtnFunc(RoleID)
}

ClassMethod SetUserRole(SupUserID As %String, RoleID As %String)
{
	//2011-12-05 wangwentao add
	s (uID) =""
	
    if (SupUserID '= ""){
	   &sql(select SupUserID into :uID from EPRmeta.SuperUser where SupUserID = :SupUserID) 
	   if (uID '= ""){
		   &sql(update EPRmeta.SuperUser set RoleID = :RoleID where SupUserID = :SupUserID)	
		   w !,"设置用户:"_SupUserID_"为Administrator角色权限成功"   
	   }
	   else{
	       w !,"未找到用户:"_SupUserID
	   }
    }
}

/// end 设置默认角色  
/// Desc: 配置角色权限功能
/// 入参：SupUserID 来自表 EPRmeta.SuperUser 将此用户与Administrator角色关联，拥有全部功能
/// d ##Class(EPRservice.tool.BaseDataMgr).CreateRoleFuntion("demo") 
ClassMethod CreateRoleFuntion(SupUserID As %String)
{
	//2011-11-29 wangwentao update
	q:(($d(SupUserID)=0)) ""
	
    Tstart  
    s roleID = ""
	// 初始化一个角色
    &sql(select ID into :roleID from EPRMeta.MainRole where RoleName = 'Administrator')
    if (roleID = "") || (roleID = $c(0))
    {
	  &sql(insert into EPRMeta.MainRole (RoleName, RoleDesc) values ('Administrator', '超级管理员'))
	  s roleID = ""
	  &sql(select ID into :roleID from EPRMeta.MainRole where RoleName = 'Administrator')
	  w !,"初始化角色：RoleName=Administrator, RoleDesc=超级管理员 成功"
    }
	// 初始化权限字典
	d ..IniDictFunctions()
	
	// 初始化角色权限表
	d ..SetRoleFunction(roleID)		
	w !,"初始化角色Administrator权限成功"	
	
	//设置默认角色 
	//knowledge
	d ..SetDefaultRoleFunc("knowledge", "知识库", "", "Menu_View_Knowledge", "", "", "")
	//template
	d ..SetDefaultRoleFunc("template", "模板库", "Menu_View_ITemplate", "", "Menu_View_PTemplate", "", "")
	//guest
	d ..SetDefaultRoleFunc("guest", "来宾帐户", "", "", "", "", "")


    // d ..SetUserRole("admin", roleID)
    d ..SetUserRole(SupUserID, roleID)
    
    i (SQLCODE=0) 
    {
	    Tcommit
	    w !,"维护程序角色权限初始化完成"
    } 
    else
    {  
        trollback
        w !,"维护程序角色权限初始化失败"
    }
    
    q SQLCODE
}

/// 2011-11-29 wangwentao add
/// d ##class(EPRservice.tool.BaseDataMgr).UpdateInitialData()	
ClassMethod UpdateInitialData()
{

	k SQLCODE
	&SQL(update EPRmeta.StdDictionary set IsDiagnosRuleType = 'N' where IsDiagnosRuleType is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病种与知识库节点多条件组合功能数据初始化成功!"
	W !,""_SQLCODE,!
	
	k SQLCODE
	&SQL(update EPRmeta.KBNode set IsCommon = 'Y' where IsCommon is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病种功能知识库节点默认通用节点数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(Update EPRinstance.AdmPatType Set EPRKBDiagnosID = '' where EPRKBDiagnosID is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病种功能EPRinstance.AdmPatType历史数据初始化成功!"
	W ""_SQLCODE,!

	k SQLCODE
	&SQL(update EPRmeta.KBTree set PersonalKBUserID = '' where PersonalKBUserID is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"个人知识库功能数据初始化成功!"
	W ""_SQLCODE,!	

	k SQLCODE
	&SQL(update EPRmeta.KBTree set Sequence = Id where Sequence is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"知识库EPRmeta.KBTree顺序号数据初始化成功!"
	W ""_SQLCODE,!	
	
	k SQLCODE
	&SQL(update EPRmeta.KBNode set Sequence = Id where Sequence is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"知识库EPRmeta.KBNode顺序号数据初始化成功!"
	W ""_SQLCODE,!	


	///////////////////////////////////////////////////

	k SQLCODE
	&SQL(update eprmeta.eprtemplatecategory set categoryseq = id where categoryseq is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历展现结构顺序号数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(update eprmeta.stddictionary set condition = '',conditioncode = '' where condition is null )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"字典单元筛选条件及环境变量功能数据初始化成功!"
	W ""_SQLCODE,!
	

	
	///////////////////////////////////////////////////
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET DicAliasCol = 'CtmDictAlias', DicCodeCol = 'CtmDictCode', DicDescCol = 'CtmDictDesc', TableName = 'EPRview.CareUnit' WHERE TableName = 'EPRmeta.CustomParameter' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[EPR]重症监护室字典视图重命名初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET TableName = 'EPRview.MedAllergy' WHERE TableName = 'SQLUser.DHCEPRVMedAllergy' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[HIS]药物过敏字典视图重命名初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET TableName = 'EPRview.PatPriv' WHERE TableName = 'SQLUser.DHCEPRVPatPriv' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[EPR]通用模板字典视图重命名初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET TableName = 'EPRview.PatType' WHERE TableName = 'SQLUser.DHCEPRVPatType' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[EPR]病历类型字典重命名初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET TableName = 'EPRview.Infection' WHERE TableName = 'SQLUser.DHCEPRVInfection' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[EPR]院内感染字典视图重命名初始化成功!"
	W ""_SQLCODE,!
	
	
	k SQLCODE
	&SQL(update EPRview.PatType set CtmDictID='^'||CtmDictID||'^'  where CtmDictID is not null and  CtmDictID <> 'ALL' and  CtmDictID <> 'OP' and  CtmDictID <> 'EP' and CtmDictID not like '^%^' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历类型支持多科室配置功能数据初始化成功!"
	w ""_SQLCODE,!
	
	//20120701 wangwentao add
	//Version:R20120401
	k SQLCODE
	&SQL(update EPRmeta.PrintTemplateVersion set NewPageStartOdd = '0' where NewPageStartOdd is null)
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"打印时新起页续打不续打偶数页功能数据初始化成功!"
	w ""_SQLCODE,!
	//Version:R20120401 End
	
	//Version:R20120612
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET Sequence =ID WHERE Sequence IS NULL)
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"字典表维护添加序号功能数据初始化成功!"
	w ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.EPRTemplate SET EPRTemplateSeq = ID WHERE EPRTemplateSeq IS NULL )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历扩展结构添加序号功能数据初始化成功!"
	w ""_SQLCODE,!
	//Version:R20120612 End
	//------20120701 End

	//20120720 wangwentao add
	//Hospital:AHSLYY
	//Version:NULL
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET TableName = 'EPRview.DiagnosisReproduction' WHERE TableName = 'SQLUser.DHCEPRVProcDiag' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[EPR]生殖中心诊断字典视图重命名初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.CustomDictionary SET CtmDictType = 'DiagnosisReproduction' WHERE CtmDictType = 'DHCEPRVProcDiag' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[EPR]生殖中心诊断字典数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta.StdDictionary SET TableName = 'EPRview.CTLocIP',Description = '[HIS]住院科室字典',Name = '[HIS]住院科室字典' WHERE TableName = 'SQLUser.DHCEPRVCTLocIP' )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[HIS]住院科室字典字典视图重命名初始化成功!"
	W ""_SQLCODE,!		
	//------2012072 End
	
	
	//20130221 wangwentao add
	//Hospital:BJDTYY
	//Version:EPR2_V20121229_R20130204_I04_A2012122905
	//[维护程序]-[设置]-[权限设置]-[医生级别维护]中 用户级别和用户职务 基础数据初始化
	
	//------------------------------------
	//用户级别
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserLevel(Description, IsValid, Name) VALUES ('住院医师', '1', 'Resident') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户级别字典]住院医师初始化成功!"
	W "用户级别"_SQLCODE,!
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserLevel(Description, IsValid, Name) VALUES ('主治医师', '1', 'Attending') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户级别字典]主治医师初始化成功!"
	W "用户级别"_SQLCODE,!
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserLevel(Description, IsValid, Name) VALUES ('主任/副主任医师', '1', 'Chief') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户级别字典]主任/副主任医师初始化成功!"
	W "用户级别"_SQLCODE,!
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserLevel(Description, IsValid, Name) VALUES ('未分配', '1', '') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户级别字典]未分配初始化成功!"
	W "用户级别"_SQLCODE,!
	
	//------------------------------------
	//用户职务
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserPost(Description, IsValid, Name, OperAction) VALUES ('科主任', '1', 'Chairman', 'ChairmanCheck') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户职务字典]科主任初始化成功!"
	W "用户职务"_SQLCODE,!
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserPost(Description, IsValid, Name, OperAction) VALUES ('质控医师', '1', 'QCDoc', 'QCDocCheck') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户职务字典]质控医师初始化成功!"
	W "用户职务"_SQLCODE,!
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserPost(Description, IsValid, Name, OperAction) VALUES ('质控护士', '1', 'QCNurse', 'QCNurseCheck') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户职务字典]质控护士初始化成功!"
	W "用户职务"_SQLCODE,!
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserPost(Description, IsValid, Name, OperAction) VALUES ('责任护士', '1', 'ChargeNurse', 'ChargeNurseCheck') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户职务字典]责任护士初始化成功!"
	W "用户职务"_SQLCODE,!
	
	k SQLCODE
	&SQL(INSERT INTO EPRmeta.UserPost(Description, IsValid, Name, OperAction) VALUES ('未分配', '1', '', '') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"[权限设置]-[医生级别维护]-[用户职务字典]未分配初始化成功!"
	W "用户职务"_SQLCODE,!
	
	
	//------------------------------------
	//界面模板目录类型维护
	s (TypeDescription,TypeName)=""
	
	&SQL(SELECT TOP 1 TypeDescription,TypeName INTO :TypeDescription,:TypeName FROM EPRmeta.CategoryType)
	if (TypeDescription="标准模板  ( 直接 )")&&(TypeName="Normal")
	{
		W "界面模板目录类型维护"_"100"_"没有数据被更新!",!	
	}
	else
	{
		k ^DHCEPRM.CategoryTypeD
		k ^DHCEPRM.CategoryTypeI
		
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CategoryType(TypeDescription, TypeName) VALUES ('标准模板  ( 直接 )', 'Normal') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板目录类型维护]Normal初始化成功!"
		W ""_SQLCODE,!
		
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CategoryType(TypeDescription, TypeName) VALUES ('病历主分类( TraCare页签 )', 'Main') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板目录类型维护]Main初始化成功!"
		W ""_SQLCODE,!
	
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CategoryType(TypeDescription, TypeName) VALUES ('组模板    ( 横排 )', 'Group') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板目录类型维护]Group初始化成功!"
		W ""_SQLCODE,!	
	
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CategoryType(TypeDescription, TypeName) VALUES ('组模板成员( 横排子项 )', 'GroupItem') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板目录类型维护]GroupItem初始化成功!"
		W ""_SQLCODE,!	
	
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CategoryType(TypeDescription, TypeName) VALUES ('域模板    ( 暂不用 )', 'GroupParent') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板目录类型维护]GroupParent初始化成功!"
		W ""_SQLCODE,!
	}
	
	//------------------------------------
	//界面模板及目录属性维护
	s (PropertyDesc,PropertyName)=""
	
	&SQL(SELECT TOP 1 PropertyDesc,PropertyName INTO :PropertyDesc,:PropertyName FROM EPRmeta.CTProperty)
	if (PropertyDesc="缺省")&&(PropertyName="Default")
	{
		W "界面模板及目录属性维护"_"100"_"没有数据被更新!",!	
	}
	else
	{
		k ^DHCEPRM.CTPropertyD
		k ^DHCEPRM.CTPropertyI
		
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CTProperty(PropertyDesc, PropertyName) VALUES ('缺省', 'Default') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板及目录属性维护]Default初始化成功!"
		W ""_SQLCODE,!
		
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CTProperty(PropertyDesc, PropertyName) VALUES ('住院病历', 'InPatient') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板及目录属性维护]InPatient初始化成功!"
		W ""_SQLCODE,!
	
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CTProperty(PropertyDesc, PropertyName) VALUES ('门诊病历', 'OutPatient') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板及目录属性维护]OutPatient初始化成功!"
		W ""_SQLCODE,!	
	
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CTProperty(PropertyDesc, PropertyName) VALUES ('急诊病历', 'Emergency') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板及目录属性维护]Emergency初始化成功!"
		W ""_SQLCODE,!	
	
		k SQLCODE
		&SQL(INSERT INTO EPRmeta.CTProperty(PropertyDesc, PropertyName) VALUES ('其他病历', 'Other') )
		s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
		s:(SQLCODE=0) SQLCODE=SQLCODE_"[界面模板及目录属性维护]Other初始化成功!"
		W ""_SQLCODE,!
	}
	
	
	//------------------------------------
	//打印模板系统数据
	d ##Class(EPRmeta.PrintTemplateSysData).IniData()
	w "打印模板系统数据表PrintTemplateSysData初始化成功!",!
	
	//------20130221 End
}

/// 2012-08-13 wangwentao add
/// d ##class(EPRservice.tool.BaseDataMgr).UpdateQualityData()	
ClassMethod UpdateQualityData()
{
	
	//20120813 wangwentao add
	//Hospital:AHSLYY
	//Version:EPRQuality_V20120723_A01_R01.20120723.rar
	k SQLCODE
	&SQL(UPDATE EPRmeta_Quality.QualityEntry SET ChkConditionDR = '' WHERE ChkConditionDR IS NULL )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历质控QualityEntry.ChkConditionDR数据初始化成功!"
	w ""_SQLCODE,!
	
	k SQLCODE
	&SQL(UPDATE EPRmeta_Quality.QualityEntry SET ResumeText = '' WHERE ResumeText IS NULL )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历质控QualityEntry.ResumeText数据初始化成功!"
	w ""_SQLCODE,!	
	
	k SQLCODE
	&SQL(UPDATE EPRmeta_Quality.QualityTemplate SET LUDateTime = '' WHERE LUDateTime IS NULL )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历质控QualityTemplate.LUDateTime数据初始化成功!"
	w ""_SQLCODE,!	
	
	k SQLCODE
	&SQL(UPDATE EPRmeta_Quality.QualityTemplate SET ResumeText = '' WHERE ResumeText IS NULL )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历质控QualityTemplate.ResumeText数据初始化成功!"
	w ""_SQLCODE,!	
	
	k SQLCODE
	&SQL(UPDATE EPRmeta_Quality.QualityEntry SET VetoGrade ='' WHERE VetoGrade IS NULL  )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历质控QualityEntry.VetoGrade数据初始化成功!"
	w ""_SQLCODE,!	
		
	k SQLCODE
	&SQL(UPDATE EPRmeta_Quality.QualityStruct SET CategoryDR = '' WHERE CategoryDR IS NULL )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被更新!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历质控QualityStruct.CategoryDR数据初始化成功!"
	w ""_SQLCODE,!
	
	//------20120813 End
}

/// 2011-11-29 wangwentao add
/// d ##class(EPRservice.tool.BaseDataMgr).RebuildIndex("R20110116","R20111125")
ClassMethod RebuildIndex(ALastRelease As %String, AUpdateRelease As %String, AKeyWord As %String = "")
{
	q:($d(ALastRelease)=0)||($d(AUpdateRelease)=0) ""
	//q:($l(ALastRelease)'="9")||($l(AUpdateRelease)'="9") ""
	
	s LastRelease = $$ConvertData(ALastRelease)
	s UpdateRelease = $$ConvertData(AUpdateRelease)
	
	if ((ALastRelease'="")&&(AUpdateRelease'=""))||(AKeyWord="eprmetadata")
	{
		if ((LastRelease <= $zdh("2010-11-22",3))&&( $zdh("2010-11-22",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			d ##class(EPRmeta.BindParameter).%BuildIndices()		
			d ##class(EPRmeta.EPRTemplate).%BuildIndices()
			d ##class(EPRmeta.PrintTemplate).%BuildIndices()
			d ##class(EPRmeta.PrintTemplateVersion).%BuildIndices()
			
			w "2010-11-22 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2011-09-15",3))&&( $zdh("2011-09-15",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			d ##Class(EPRmeta.Glossary).%BuildIndices()
			
			w "2011-09-15 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2011-09-23",3))&&( $zdh("2011-09-23",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			d ##Class(EPRmeta.KBTree).%BuildIndices()
			d ##Class(EPRmeta.KBNode).%BuildIndices()
			d ##Class(EPRmeta.KBDiagnos).%BuildIndices()
			d ##Class(EPRinstance.AdmPatType).%BuildIndices()
			
			w "2011-09-23 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2011-10-31",3))&&( $zdh("2011-10-31",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			d ##Class(EPRmeta.EPRTemplateCategory).%BuildIndices()
			
			w "2011-10-31 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2012-04-28",3))&&( $zdh("2012-04-28",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			d ##class(EPRmeta.CustomDictionary).%BuildIndices()
			
			w "2012-04-28 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2013-01-15",3))&&( $zdh("2013-01-15",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			// EPR2_V20121229_R20130115_I02_A03
			d ##Class(EPRmeta.MainDictFunction).%BuildIndices()
			d ##Class(EPRmeta.MainRole).%BuildIndices()
			d ##Class(EPRmeta.PrintTemplateSysData).%BuildIndices()
			d ##Class(EPRmeta.UserLevel).%BuildIndices()
			d ##Class(EPRmeta.UserPost).%BuildIndices()
			
			w "2013-01-15 Release 索引重建完成!",!
		}
		
	s:(AKeyWord="") AKeyWord="空值"
	w ALastRelease_"至"_AUpdateRelease_"电子病历程序修改相关索引重建完毕!"_"关键字:"_AKeyWord_"!"
		
	}
	if (ALastRelease="")&&(AUpdateRelease="")&&(AKeyWord="rebuildall")
	{
		d ##Class(EPRmeta.BindParameter).%BuildIndices()
		d ##Class(EPRmeta.DynamicConfigTable).%BuildIndices()
		d ##Class(EPRmeta.EPRActStatusCfg).%BuildIndices()
		d ##Class(EPRmeta.EPRAction).%BuildIndices()
		d ##Class(EPRmeta.EPRStatus).%BuildIndices()
		d ##Class(EPRmeta.EPRTemplate).%BuildIndices()
		d ##Class(EPRmeta.EPRTemplateCategory).%BuildIndices()
		d ##Class(EPRmeta.Glossary).%BuildIndices()
		d ##Class(EPRmeta.GlossaryItem).%BuildIndices()
		d ##Class(EPRmeta.GlossaryKBItem).%BuildIndices()
		d ##Class(EPRmeta.ImageCategory).%BuildIndices()
		d ##Class(EPRmeta.ImageItem).%BuildIndices()
		d ##Class(EPRmeta.ImageLib).%BuildIndices()
		d ##Class(EPRmeta.ImageTree).%BuildIndices()
		d ##Class(EPRmeta.KBDiagnos).%BuildIndices()
		d ##Class(EPRmeta.KBNode).%BuildIndices()
		d ##Class(EPRmeta.KBNodeDiagnos).%BuildIndices()
		d ##Class(EPRmeta.KBNodeDiagnosRule).%BuildIndices()
		d ##Class(EPRmeta.KBTree).%BuildIndices()
		d ##Class(EPRmeta.KBTreeCTLoc).%BuildIndices()
		d ##Class(EPRmeta.MainDictFunction).%BuildIndices()
		d ##Class(EPRmeta.PrintTemplate).%BuildIndices()
		d ##Class(EPRmeta.PrintTemplateVersion).%BuildIndices()
		d ##Class(EPRmeta.SysOption).%BuildIndices()
		d ##Class(EPRmeta.Template).%BuildIndices()
		d ##Class(EPRmeta.TemplateCategory).%BuildIndices()
		
	w "电子病历eprmetadata索引全部重建完毕!"_"关键字:"_AKeyWord_"!"
	}
		
		

	q

ConvertData(ArgData)
	
	q:(ArgData="") ""
	s (Data,TransData)=""
	s Data =$tr(ArgData,"R")
	s Data =$e(Data,1,4)_"-"_$e(Data,5,6)_"-"_$e(Data,7,8)
	s TransData=$zdh(Data,3)
	
	q TransData
}

/// Debug:	d ##Class(EPRservice.tool.BaseDataMgr).UpdateGlossaryData()
ClassMethod UpdateGlossaryData()
{
	w !, "<-----"
	w !, "Init GlossaryCategory Begin : "
	
	
	s gcID = ""
	for {
		s gcID = $O(^DHCEPRM.GlossaryCategoryD(gcID))
		q:(gcID = "")
		
		s objGC = ##Class(EPRmeta.GlossaryCategory).%OpenId(gcID)
		continue:(objGC = "")
		
		if (objGC.InternalID = "")
		{
			s objGC.InternalID = objGC.%Id()
			d objGC.%Save()
			w !, "GlossaryCategory ID : "_objGC.%Id()_ " , Updateed !"
		}
		else
		{
			w !, "GlossaryCategory ID : "_objGC.%Id()_ " , OK !"
		}
	}
	
	
	w !, "Init GlossaryCategory End !"
	w !, "--->"
	
	w !
	w !, "<-----"
	w !, "Init Glossary Begin : "
	
	
	s gID = ""
	for {
		s gID = $O(^DHCEPRM.GlossaryD(gID))
		q:(gID = "")
		
		s objG = ##Class(EPRmeta.Glossary).%OpenId(gID)
		continue:(objGC = "")
		
		if (objG.InternalID = "")
		{
			s objG.InternalID = objG.%Id()
			s objG.MetaID = objG.%Id()
			d objG.%Save()
			w !, "Glossary ID : "_objG.%Id()_ " , Updateed !"
		}
		else
		{
			w !, "Glossary ID : "_objG.%Id()_ " , OK !"
		}
	}
	
	
	w !, "Init Glossary End !"
	w !, "--->"
}

/// *
/// 2012-02-09 wangwentao add
/// d ##class(EPRservice.tool.BaseDataMgr).UpdateQueryData()	
ClassMethod UpdateQueryData()
{
	
	// -------------------------------------------------------------------------------------
	//查询大类
	// -------------------------------------------------------------------------------------

	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) 
				values ('HIS', '基本信息', '0', '1', 'Y', '基本信息') )
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_基本信息_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) 
				values ('Order', '医嘱信息', '0', '2', 'Y', '医嘱信息'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_医嘱信息_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) 
				values ('EPR', '电子病历', '0', '3', 'Y', '电子病历'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_电子病历_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) 
				values ('LIS', '检验信息', '0', '4', 'Y', '检验信息'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_检验信息_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) 
				values ('RIS', '检查信息', '0', '5', 'Y', '检查信息'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_检查信息_数据初始化成功!"
	W ""_SQLCODE,!
	
	//EPR2_Query_V20120508
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) 
				values ('Glossary', '术语信息', '0', '6', 'Y', '术语信息'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_术语信息_数据初始化成功!"
	W ""_SQLCODE,!
	
	// -------------------------------------------------------------------------------------
	//查询子类
	// -------------------------------------------------------------------------------------
	
	// -------------------------------------------------------------------------------------
	//查询子类 - 电子病历
	// -------------------------------------------------------------------------------------
	//k SQLCODE
	//&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
	//			values ('EPRIndexRecord', '病案首页', '3', '7', 'Y', '病案首页'))
	//s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	//s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_电子病历-病案首页_数据初始化成功!"
	//W ""_SQLCODE,!


	// -------------------------------------------------------------------------------------
	//查询子类 - 检验信息
	// -------------------------------------------------------------------------------------

	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISBloodRoutine', '血常规', '4', '4001', 'Y', '血常规'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_血常规_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISUrineRoutine', '尿常规', '4', '4002', 'Y', '尿常规'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_尿常规_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISLiverFunction', '肝功', '4', '4003', 'Y', '肝功'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_肝功_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISRenalFunction', '肾功', '4', '4004', 'Y', '肾功'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_肾功_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISBloodIon', '血离子', '4', '4005', 'Y', '血离子'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_血离子_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISCardiacEnzymes', '心肌酶', '4', '4006', 'Y', '心肌酶'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_心肌酶_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISIsoenzyme', '心肌酶同工酶', '4', '4007', 'Y', '心肌酶同工酶'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_心肌酶同工酶_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISMicroglobulin', 'Beta2微球蛋白测定', '4', '4008', 'N', ' Beta2微球蛋白测定(化学发光法)'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_Beta2微球蛋白测定_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISThreeCoagulationMarkers', '凝血三项', '4', '4009', 'Y', '凝血三项'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_凝血三项_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISDextrose', '葡萄糖测定', '4', '4010', 'Y', '葡萄糖测定(空腹)'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_葡萄糖测定_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISTumorMarker', '肿瘤标志物', '4', '4011', 'Y', '肿瘤标志物'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_肿瘤标志物_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISFDP', '纤维蛋白(原)降解产物测定', '4', '4012', 'Y', '纤维蛋白(原)降解产物测定'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_纤维蛋白(原)降解产物测定_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISBloodDimericDet', '血浆D-二聚体测定', '4', '4013', 'Y', '血浆D-二聚体测定(仪器法) '))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_血浆D-二聚体测定_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISSHSix', '性激素六项', '4', '4014', 'Y', '性激素六项'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_性激素六项_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISTCell', 'T细胞绝对值及亚群', '4', '4015', 'N', 'T细胞绝对值及亚群'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_T细胞绝对值及亚群_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISSMb', '血清肌钙蛋白I测定', '4', '4016', 'N', '血清肌钙蛋白I测定'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_血清肌钙蛋白I测定_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark)
				values ('LISBloodBNP', '血浆B型钠脲肽(BNP)测定', '4', '4017', 'N', '血浆B型钠脲肽(BNP)测定'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_血浆B型钠脲肽(BNP)测定_数据初始化成功!"
	W ""_SQLCODE,!
	

	// -------------------------------------------------------------------------------------
	//数据类型
	// -------------------------------------------------------------------------------------

	// -------------------------------------------------------------------------------------
	//b
	//k ^DHCEPRM.QueryItemTypeD
	//k ^DHCEPRM.QueryItemTypeI
	// -------------------------------------------------------------------------------------
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) 
		values('str','字符型','Y',''))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_字符型_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) 
		values('num','数字型','Y',''))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_数字型_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) 
		values('date','日期型','Y',''))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_日期型_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) 
		values('time','时间型','Y',''))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_时间型_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) 
		values('datetime','日期时间型','Y',''))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_日期时间型_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) 
		values('dic','字典型','Y',''))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_字典型_数据初始化成功!"
	W ""_SQLCODE,!


	// -------------------------------------------------------------------------------------
	//基础数据 - 系统数据
	// -------------------------------------------------------------------------------------

	// -------------------------------------------------------------------------------------
	//b
	//k ^DHCEPRM.QueryItemD
	//k ^DHCEPRM.QueryItemI
	// -------------------------------------------------------------------------------------

	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic) 
		values('EpisodeID','EpisodeID',1,'就诊指针',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_就诊号_数据初始化成功!"
	W ""_SQLCODE,!

	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic) 
		values('EpisodeNo','EpisodeNo',2,'就诊号',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_就诊号_数据初始化成功!"
	W ""_SQLCODE,!

	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic) 
		values('RegNo','RegNo',3,'登记号',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_登记号_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic) 
		values('RecordNo','RecordNo',4,'病案号',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_病案号_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('Name','Name',5,'姓名',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_姓名_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('Gender','Gender',6,'性别',6,0,1,'Y','','S06'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_性别_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('BirthDate','BirthDate',7,'出生日期',3,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_出生日期_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('AdmType','AdmType',8,'就诊类型',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_就诊类型_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('AdmDate','AdmDate',9,'就诊日期',3,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_就诊日期_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('AdmTime','AdmTime',10,'就诊时间',4,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_就诊时间_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('AdmDept','AdmDept',11,'入院科室',6,0,1,'Y','','S07'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_入院科室_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('AdmWard','AdmWard',12,'入院病区',6,0,1,'Y','','S10'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_入院病区_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('DischDate','DischDate',13,'出院日期',3,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_出院日期_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('DischTime','DischTime',14,'出院时间',4,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_出院时间_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('DischDept','DischDept',15,'出院科室',6,0,1,'Y','','S07'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_出院科室_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('DischWard','DischWard',16,'出院病区',6,0,1,'Y','','S10'))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_出院病区_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('MainDoc','MainDoc',17,'主管医生',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_主管医生_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('CurRoom','CurRoom',18,'当前病房',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_当前病房_数据初始化成功!"
	W ""_SQLCODE,!
	
	k SQLCODE
	&SQL(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,stddic)
		values('CurBed','CurBed',19,'当前床位',1,0,1,'Y','',1))
	s:(SQLCODE'=0) SQLCODE=SQLCODE_"没有数据被插入!"
	s:(SQLCODE=0) SQLCODE=SQLCODE_"病历查询功能_当前床位_数据初始化成功!"
	W ""_SQLCODE,!
}

/// 2012-08-13 wangwentao add
/// d ##class(EPRservice.tool.BaseDataMgr).RebuildIndexQuality("","","rebuildall")
ClassMethod RebuildIndexQuality(ALastRelease As %String, AUpdateRelease As %String, AKeyWord As %String = "")
{
	q:($d(ALastRelease)=0)||($d(AUpdateRelease)=0) ""
	//q:($l(ALastRelease)'="9")||($l(AUpdateRelease)'="9") ""
	
	s LastRelease = $$ConvertData(ALastRelease)
	s UpdateRelease = $$ConvertData(AUpdateRelease)
	
	if ((ALastRelease'="")&&(AUpdateRelease'=""))||(AKeyWord="eprmetadata")
	{
		if ((LastRelease <= $zdh("2010-11-22",3))&&( $zdh("2010-11-22",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			
			w "2010-11-22 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2011-09-15",3))&&( $zdh("2011-09-15",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			
			w "2011-09-15 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2011-09-23",3))&&( $zdh("2011-09-23",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			
			w "2011-09-23 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2011-10-31",3))&&( $zdh("2011-10-31",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			
			w "2011-10-31 Release 索引重建完成!",!
		}
		if ((LastRelease <= $zdh("2012-04-28",3))&&( $zdh("2012-04-28",3) <= UpdateRelease))||(AKeyWord="eprmetadata")
		{
			
			w "2012-04-28 Release 索引重建完成!",!
		}
		
	s:(AKeyWord="") AKeyWord="空值"
	w ALastRelease_"至"_AUpdateRelease_"电子病历程序修改相关索引重建完毕!"_"关键字:"_AKeyWord_"!"
		
	}
	if (ALastRelease="")&&(AUpdateRelease="")&&(AKeyWord="rebuildall")
	{
	d ##Class(EPRmeta.Quality.QualityCategory).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityDictionary).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityEntry).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityEntryScore).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityMethod).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityOrderInfo).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityParams).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityPhaseStatus).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityPhasesModify).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityPool).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityQuery).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityRule).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualitySetting).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityStruct).%BuildIndices()
	d ##Class(EPRmeta.Quality.QualityTemplate).%BuildIndices()

		
	w "病历质控索引全部重建完毕!"_"关键字:"_AKeyWord_"!"
	}
		
	q

ConvertData(ArgData)
	
	q:(ArgData="") ""
	s (Data,TransData)=""
	s Data =$tr(ArgData,"R")
	s Data =$e(Data,1,4)_"-"_$e(Data,5,6)_"-"_$e(Data,7,8)
	s TransData=$zdh(Data,3)
	
	q TransData
}

/// d ##Class(EPRservice.tool.BaseDataMgr).InitTeethPosition()
ClassMethod InitTeethPosition()
{
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA1','1','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA2','2','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA3','3','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA4','4','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA5','5','5','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA6','6','6','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA7','7','7','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXA8','8','8','Y','TeethType'))
	
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB1','1','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB2','2','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB3','3','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB4','4','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB5','5','5','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB6','6','6','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB7','7','7','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXB8','8','8','Y','TeethType'))
	
	
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC1','1','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC2','2','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC3','3','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC4','4','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC5','5','5','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC6','6','6','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC7','7','7','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXC8','8','8','Y','TeethType'))
	
	
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD1','1','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD2','2','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD3','3','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD4','4','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD5','5','5','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD6','6','6','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD7','7','7','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btXD8','8','8','Y','TeethType'))
	
	
	
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYA1','Ⅰ','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYA2','Ⅱ','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYA3','Ⅲ','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYA4','Ⅳ','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYA5','Ⅴ','5','Y','TeethType'))
	
	
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYB1','Ⅰ','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYB2','Ⅱ','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYB3','Ⅲ','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYB4','Ⅳ','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYB5','Ⅴ','5','Y','TeethType'))
	
	
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYC1','Ⅰ','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYC2','Ⅱ','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYC3','Ⅲ','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYC4','Ⅳ','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYC5','Ⅴ','5','Y','TeethType'))
	
	
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYD1','Ⅰ','1','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYD2','Ⅱ','2','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYD3','Ⅲ','3','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYD4','Ⅳ','4','Y','TeethType'))
	&sql(insert into EPRmeta.CustomDictionary(CtmDictCode,CtmDictAlias,CtmDictDesc,CtmDictStatus,CtmDictType)values('btYD5','Ⅴ','5','Y','TeethType'))
}

/// d ##Class(EPRservice.tool.BaseDataMgr).InitQuery()
ClassMethod InitQuery()
{
	//查询大类
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('HIS', '基本信息', '0', '1', 'Y', '基本信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('Order', '医嘱信息', '0', '2', 'N', '医嘱信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPR', '电子病历', '0', '3', 'Y', '电子病历'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LIS', '检验信息', '0', '4', 'Y', '检验信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('RIS', '检查信息', '0', '5', 'N', '检查信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('Glossary', '术语信息', '0', '6', 'Y', '术语信息'))
	
	//查询子类
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord', '病案首页', '3', '7', 'Y', '病案首页'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord1', '一般情况', '7', '3001', 'Y', '一般情况'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord2', '出院情况', '7', '3002', 'Y', '出院情况'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord3', '手术情况', '7', '3003', 'Y', '手术情况'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord4', '其它情况', '7', '3004', 'Y', '其它情况'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodRoutine', '血常规', '4', '4001', 'Y', '血常规'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISUrineRoutine', '尿常规', '4', '4002', 'Y', '尿常规'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISLiverFunction', '肝功', '4', '4003', 'Y', '肝功'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISRenalFunction', '肾功', '4', '4004', 'Y', '肾功'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodIon', '血离子', '4', '4005', 'Y', '血离子'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISCardiacEnzymes', '心肌酶', '4', '4006', 'Y', '心肌酶'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISIsoenzyme', '心肌酶同工酶', '4', '4007', 'Y', '心肌酶同工酶'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISMicroglobulin', 'Beta2微球蛋白测定', '4', '4008', 'N', ' Beta2微球蛋白测定(化学发光法)'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISThreeCoagulationMarkers', '凝血三项', '4', '4009', 'Y', '凝血三项'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISDextrose', '葡萄糖测定', '4', '4010', 'Y', '葡萄糖测定(空腹)'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISTumorMarker', '肿瘤标志物', '4', '4011', 'Y', '肿瘤标志物'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISFDP', '纤维蛋白(原)降解产物测定', '4', '4012', 'Y', '纤维蛋白(原)降解产物测定'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodDimericDet', '血浆D-二聚体测定', '4', '4013', 'Y', '血浆D-二聚体测定(仪器法) '))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISSHSix', '性激素六项', '4', '4014', 'Y', '性激素六项'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISTCell', ' T细胞绝对值及亚群', '4', '4015', 'N', ' T细胞绝对值及亚群'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISSMb', '血清肌钙蛋白I测定', '4', '4016', 'N', '血清肌钙蛋白I测定'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodBNP', '血浆B型钠脲肽(BNP)测定', '4', '4017', 'N', '血浆B型钠脲肽(BNP)测定'))
	
	//数据类型
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('str','字符型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('num','数字型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('date','日期型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('time','时间型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('datetime','日期时间型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('dic','字典型','Y',''))

	//查询项目
	//基本信息
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('EpisodeID','EpisodeID',1,'就诊指针',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('EpisodeNo','EpisodeNo',2,'就诊号',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('RegNo','RegNo',3,'登记号',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('RecordNo','RecordNo',4,'病案号',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('Name','Name',5,'姓名',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('Gender','Gender',6,'性别',6,0,1,'Y','','S06'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('BirthDate','BirthDate',7,'出生日期',3,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmType','AdmType',8,'就诊类型',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmDate','AdmDate',9,'就诊日期',3,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmTime','AdmTime',10,'就诊时间',4,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmDept','AdmDept',11,'入院科室',6,0,1,'Y','','S07'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmWard','AdmWard',12,'入院病区',6,0,1,'Y','','S10'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischDate','DischDate',13,'出院日期',3,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischTime','DischTime',14,'出院时间',4,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischDept','DischDept',15,'出院科室',6,0,1,'Y','','S07'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischWard','DischWard',16,'出院病区',6,0,1,'Y','','S10'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('MainDoc','MainDoc',17,'主管医生',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('CurRoom','CurRoom',18,'病房',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('CurBed','CurBed',19,'床位',1,0,1,'Y','',1))
	
	
	
	//初始化病案首页数据
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:S0198#VTYPE:V','EPRItem11', '病案号',1,0,8, 1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:S0003#VTYPE:V','EPRItem12', '姓名',1,0,8, 2,'Y','',1))
	
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0035#VTYPE:V','EPRItem13', '门急诊诊断',1,0,8, 3,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0035#VTYPE:C','EPRItem14', '门急诊诊断ICD码',1,0,8, 4,'Y','',1))
	
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0057#VTYPE:V','EPRItem1', '主要诊断',1,0,9, 1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0057#VTYPE:C','EPRItem2', '主要诊断ICD码',1,0,9, 2,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0056#VTYPE:V','EPRItem3', '其它诊断',1,0,9, 3,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0056#VTYPE:C','EPRItem4', '其它诊断ICD码',1,0,9, 4,'Y','',1))

	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0059#VTYPE:V','EPRItem5', '病理诊断',1,0,9, 5,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0059#VTYPE:C','EPRItem6', '病理诊断编码',1,0,9, 6,'Y','',1))
	
	
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:S0170#VTYPE:V','EPRItem7', '过敏药物',1,0,9, 7,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:I0062#VTYPE:V','EPRItem8', '损伤中毒外部原因',1,0,9, 8,'Y','',1))
	
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:S0400#VTYPE:V','EPRItem9', '抢救次数',1,0,9, 9,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('#TYPE:Simple#TID:22#TVER:0#SCODE:S0403#VTYPE:V','EPRItem10', '成功次数',1,0,9, 10,'Y','',1))
	
	
	//初始化 检验数据 查询项目
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LY','LISItem1','淋巴细胞计数','1','0','11','4001','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('WBC','LISItem2','白细胞计数','1','0','11','4002','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('NE','LISItem3','粒细胞计数','1','0','11','4003','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('MONO','LISItem4','单核细胞计数','1','0','11','4004','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LYP','LISItem5','淋巴细胞比率','1','0','11','4005','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('NEP','LISItem6','粒细胞比率','1','0','11','4006','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('MONOP','LISItem7','单核细胞比率','1','0','11','4007','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('RBC','LISItem8','红细胞计数','1','0','11','4008','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('HGB','LISItem9','血红蛋白浓度','1','0','11','4009','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('MCH','LISItem10','平均红细胞Hb含量','1','0','11','4010','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('MCHC','LISItem11','平均红细胞Hb浓度','1','0','11','4011','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('PLT','LISItem12','血小板计数','1','0','11','4012','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('UGLU','LISItem13','葡萄糖','1','0','12','4013','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('UPRO','LISItem14','蛋白质','1','0','12','4014','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('URBC','LISItem15','红细胞','1','0','12','4015','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('UWBC','LISItem16','白细胞','1','0','12','4016','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('ALT','LISItem17','血清丙氨酸氨基转移酶测定','1','0','13','4017','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('AST','LISItem18','血清天门冬氨酸氨基转移酶测定','1','0','13','4018','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('ALP','LISItem19','血清碱性磷酸酶测定','1','0','13','4019','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('GGT','LISItem20','血清r谷氨酰基转移酶测定','1','0','13','4020','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('TBA','LISItem21','血清总胆汁酸测定','1','0','13','4021','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('TP','LISItem22','血清总蛋白测定','1','0','13','4022','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('ALB','LISItem23','血清白蛋白测定','1','0','13','4023','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('PA','LISItem24','血清前白蛋白测定','1','0','13','4024','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('TBIL','LISItem25','血清总胆红素测定','1','0','13','4025','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('DBIL','LISItem26','血清直接胆红素测定','1','0','13','4026','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('UREA','LISItem27','尿素测定','1','0','14','4027','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CR','LISItem28','肌酐测定','1','0','14','4028','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('K','LISItem29','钾测定','1','0','15','4029','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('NA','LISItem30','钠测定','1','0','15','4030','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CL','LISItem31','氯化物测定','1','0','15','4031','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CA','LISItem32','钙测定','1','0','15','4032','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('P','LISItem33','无机磷测定','1','0','15','4033','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('MG','LISItem34','镁测定','1','0','15','4034','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LDH','LISItem35','血清乳酸脱氢酶测定','3','0','16','4035','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('AST','LISItem36','血清天门冬氨酸氨基转移酶测定','3','0','16','4036','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CK','LISItem37','血清肌酸激酶测定','1','0','16','4037','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CKMM','LISItem38','血清肌酸激酶同工酶CK-MM','1','0','17','4038','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LDH1','LISItem39','血清乳酸脱氢酶同工酶LDH-1','1','0','17','4039','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LDH2','LISItem40','血清乳酸脱氢酶同工酶LDH-2','1','0','17','4040','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LDH3','LISItem41','血清乳酸脱氢酶同工酶LDH-3','1','0','17','4041','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LDH4','LISItem42','血清乳酸脱氢酶同工酶LDH-4','1','0','17','4042','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LDH5','LISItem43','血清乳酸脱氢酶同工酶LDH-5','1','0','17','4043','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('B2MG','LISItem44','血清Beta2微球蛋白测定','1','0','18','4044','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('FIB','LISItem45','血浆纤维蛋白原','1','0','19','4045','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('PT','LISItem46','血浆凝血酶原时间','1','0','19','4046','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('PTA','LISItem47','血浆凝血酶原活动度','1','0','19','4047','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('INR','LISItem48','PT国际标准化比值','1','0','19','4048','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('APTT','LISItem49','血浆活化部分凝血活酶时间','1','0','19','4049','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('GLU0','LISItem50','葡萄糖测定(空腹)','1','0','20','4050','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CEA','LISItem51','癌胚抗原测定','1','0','21','4051','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CA125','LISItem52','糖类抗原测定(CA125)','1','0','21','4052','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CA153','LISItem53','糖类抗原测定(CA153)','1','0','21','4053','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CA199','LISItem54','糖类抗原测定(CA199)','1','0','21','4054','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('AFP','LISItem55','甲胎蛋白测定','1','0','21','4055','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('FDPS','LISItem56','纤维蛋白(原)降解产物测定','1','0','22','4056','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('D2D','LISItem57','血浆D-二聚体测定','1','0','23','4057','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('E2','LISItem58','血清雌二醇测定','1','0','24','4058','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('TES','LISItem59','血清睾酮测定','1','0','24','4059','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('LH','LISItem60','血清促黄体生成素测定','1','0','24','4060','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('FSH','LISItem61','血清促卵泡刺激素测定','1','0','24','4061','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('PRL','LISItem62','血清泌乳素测定','1','0','24','4062','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('PRG','LISItem63','血清孕酮测定','1','0','24','4063','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CD4','LISItem64','血细胞簇分化抗原CD4绝对值','1','0','25','4064','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CD4P','LISItem65','血细胞簇分化抗原CD4百分率','1','0','25','4065','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CD8','LISItem66','血细胞簇分化抗原CD8绝对值','1','0','25','4066','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CD8P','LISItem67','血细胞簇分化抗原CD8百分率','1','0','25','4067','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('CTNI','LISItem68','血清肌钙蛋白I测定','1','0','26','4068','Y','',1))
	&sql(insert into eprmeta_query.queryitem(Code,Name, Title,QueryItemTypeID,ParentID,CategoryID, Sequence,IsActive,Remark,StdDic) values('BNP','LISItem69','血浆B型钠脲肽(BNP)测定','1','0','27','4069','Y','',1))
}

/// Desc:	医嘱项目配置
/// 		支持11类：
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("Care1","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("Care2","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("Care3","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("Care0","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("CareICU","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("CareCCU","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("Salvage","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("Critical","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("Discharge","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("InsideConsult","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("OutsideConsult","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("PathologicalFrozen","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("PathologicalOleoma","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("PathOperAndFrozen","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("BloodWhole","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("BloodPlasma","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("BloodPlatelet","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("BloodRBC","21||1")
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitARCItemMastConfig("BloodOther","21||1")	
/// 		配置的数据供以下方法使用：EPRservice.BLL.BLCustomDictory.GetOrderItemConfig()
ClassMethod InitARCItemMastConfig(ACareName As %String, AItemMastID As %String)
{
	s isParaError = (ACareName'="Care1")&&(ACareName'="Care2")&&(ACareName'="Care3")&&(ACareName'="Care0")&&(ACareName'="CareICU")&&(ACareName'="CareCCU") 
	s isParaError = isParaError && (ACareName'="Salvage")&& (ACareName'="Critical")&& (ACareName'="Discharge")&& (ACareName'="InsideConsult")&& (ACareName'="OutsideConsult")
	s isParaError = isParaError && (ACareName'="PathologicalFrozen")&& (ACareName'="PathologicalOleoma")&& (ACareName'="PathOperAndFrozen")
	s isParaError = isParaError && (ACareName'="BloodWhole")&& (ACareName'="BloodPlasma")&& (ACareName'="BloodPlatelet")&& (ACareName'="BloodRBC")&& (ACareName'="BloodOther")
	
	q:(isParaError) "指定医嘱类型错误"
	
	
	&sql(select top 1 ID into :mastID from EPRmeta.CustomDictionary where CtmDictType = 'ARCItemMast' and CtmDictName=:ACareName and CtmDictStatus='Y')
	if (SQLCODE = 0)
	{
		&sql(update EPRmeta.CustomDictionary set CtmDictID = :AItemMastID where ID = :mastID) 
	}	
	else
	{
		&sql(insert into EPRmeta.CustomDictionary (CtmDictType, CtmDictStatus, CtmDictName, CtmDictID) values ('ARCItemMast', 'Y', :ACareName, :AItemMastID))
	}
	
	if (SQLCODE = "0")
	{
		q SQLCODE_" Succeed!"
	}
	else
	{
		q SQLCODE_" Failed!"
	}
}

/// Desc:	药学项目子类配置
/// 		支持1类：
/// 		w ##Class(EPRservice.tool.BaseDataMgr).InitPHCSubCatConfig("Antibacterials","21||1")
///  		
///  		配置的数据供以下方法使用：EPRservice.BLL.BLCustomDictory.GetAntibacterialsPHCSubCat()
ClassMethod InitPHCSubCatConfig(ASubCatName As %String, ASubCatID As %String)
{
	q:(ASubCatName'="Antibacterials") "指定药学子类类型错误"
	
	
	&sql(select top 1 ID into :mastID from EPRmeta.CustomDictionary where CtmDictType = 'PHCSubCat' and CtmDictName=:ASubCatName and CtmDictStatus='Y')
	if (SQLCODE = 0)
	{
		&sql(update EPRmeta.CustomDictionary set CtmDictID = :ASubCatID where ID = :mastID) 
	}	
	else
	{
		&sql(insert into EPRmeta.CustomDictionary (CtmDictType, CtmDictStatus, CtmDictName, CtmDictID) values ('PHCSubCat', 'Y', :ASubCatName, :ASubCatID))
	}
	
	q SQLCODE
}

/// Desc: 配置 EPRmeta.SysOption 
/// 与SVN【东华软件电子病历系统参数配置说明书[SVN].xls】上进行对应
/// debuger: w ##Class(EPRservice.tool.BaseDataMgr).ConfigSysOptionSVN()
ClassMethod ConfigSysOptionSVN() As %String
{
	S $zt = "ErrorHandlerSysOption"

	w "Begin of config EPRmeta.SysOption !!!",!
    
    //此参数维护程序自动创建
	//s desc = "系统01|维护程序的最新版本号"   
	//d ..SetSysOption("LastProductVersion", desc, "2011.1.1.1", "N")

	s desc = "系统02|医院名称[拼音首字母]"    
	d ..SetSysOption("HospitalName", desc, "DTHealth", "Y")

	s desc = "系统03|HIS命名空间[NAME1^NAME2]"    
	d ..SetSysOption("NameSpaceHIS", desc, "DHC-DATA^DHC-APP", "Y")

	s desc = "系统04|LIS命名空间[NAME1^NAME2]"    
	d ..SetSysOption("NameSpaceLIS", desc, "LABDATA^LABSRC", "Y")

	s desc = "系统05|RIS命名空间[NAME1^NAME2]"    
	d ..SetSysOption("NameSpaceRIS", desc, "RIS", "Y")

	s desc = "系统06|记录程序加载过程的时间日志(用于病历运行速度调试, 日志位置C盘根目录)[启用->Y][禁用->N]"    
	d ..SetSysOption("ProcessLogActivity", desc, "N", "Y")

	s desc = "系统08|开启多线程模式初始化病历[启用->Y][禁用->N]"    
	d ..SetSysOption("UseMultiThreading", desc, "Y", "Y")

	s desc = "系统09|开启ICD疾病编码副码扩展[启用->Y][禁用->N]"    
	d ..SetSysOption("ICDCodeExpand", desc, "N", "Y")

	s desc = "系统10|使用说明和质控提示页签自定义显示设置(格式为大写Y^Y或N^Y或Y^N, 第1个Y(N)判断是否显示使用说明标签, 第2个Y(N)判断是否显示质控提示标签, 若参数配置为N^N, 则默认显示使用说明标签)(仅限新框架V1.1版本使用)"    
	d ..SetSysOption("ShowHelpAndQuality", desc, "Y^Y", "Y")

	s desc = "界面01|DTHealth病历界面背景颜色[P5->DEDFFF][P7->F4F4F4]"    
	d ..SetSysOption("BGColor", desc, "F4F4F4", "Y")

	s desc = "界面02|界面模板设计默认字号大小[小五号->9][五号->10.5]"    
	d ..SetSysOption("DefaultFontSize", desc, "10.5", "Y")

	s desc = "界面03|字典单元查询结果每页显示行数[数值型]"    
	d ..SetSysOption("DicPageRowCount", desc, "12", "Y")

	s desc = "界面04|字典查询结果只屏蔽描述字段中第一个横杠"-"前的内容[表名1.字段名1, 表名2.字段名2, ...]"    
	d ..SetSysOption("NotRemoveMinus", desc, "SQLUser.ORC_Operation.OPER_Desc, SQLUser.MRC_ICDDx.MRCID_Desc", "Y")

	s desc = "界面05|复杂单元右键是否可以引用LIS数据[启用->Y][禁用->N]"    
	d ..SetSysOption("LISCitation", desc, "Y", "Y")

	s desc = "界面06|复杂单元右键是否可以引用RIS数据[启用->Y][禁用->N]"    
	d ..SetSysOption("RISCitation", desc, "Y", "Y")

	s desc = "界面07|允许修改可重复模板的标题[启用->Y][禁用->N]"    
	d ..SetSysOption("ListTitleEditable", desc, "Y", "Y")

	s desc = "界面08|允许修改可重复模板的发生时间[启用仅创建时修改->Y][启用随时修改->Y^Y][禁用->N]"    
	d ..SetSysOption("ListTimeEditable", desc, "N", "Y")

	s desc = "知识库01|允许前端编辑知识库[允许->TRUE][禁止->FALSE]"    
	d ..SetSysOption("KBEditable", desc, "FALSE", "Y")

	s desc = "知识库02|允许取消知识库的发布状态进行清除作废单元操作[启用->Y][禁用->N]"    
	d ..SetSysOption("CanKBStatusSwitch", desc, "Y", "Y")

	s desc = "知识库03|允许删除知识库资源管理器中的知识库模板[启用->Y][禁用->N]"    
	d ..SetSysOption("CanDeleteKB", desc, "Y", "Y")

	s desc = "知识库04|设置界面上知识库窗口的宽度(格式为正整数, 单元为像素)[数值型]"    
	d ..SetSysOption("KBPanelWidth", desc, "180", "Y")

	s desc = "打印01|可重复打印模板默认标准行高[数值型]"    
	d ..SetSysOption("TextRowHeight", desc, "26", "Y")

	s desc = "打印02|打印模板自动续打项目关联顺序维护(当PTid1已经打印之后, 再打印PTid2模板时, 其会自动接在PTid1后续打)[PTid1^PTid2|PTid3^PTid4...]"    
	d ..SetSysOption("PrtTplOrder", desc, "NULL", "Y")

	s desc = "病历树01|允许删除病历展现结构中的节点目录[启用->Y][禁用->N]"    
	d ..SetSysOption("AllowDeleteEPRDoc", desc, "Y", "Y")

	s desc = "集成01|移动护理PDA接口(BJDTYY护理评估单)[图表ID^模板目录ID^模板ID]"    
	d ..SetSysOption("PDAInterface", desc, "NULL", "Y")

	s desc = "个性01|安徽省立医院开启自动生成病案台账[启用->Y][禁用->N]"    
	d ..SetSysOption("AutomakeCaseRecordNo", desc, "N", "Y")

	s desc = "个性02|安徽省立医院开启自动生成病案台账模板(专用2)相关参数[模板ID^出院科室ITEMCODE^出院年份"    
	d ..SetSysOption("ParaRecordRoom2", desc, "6^O0001^S0002^S0004^S0003", "Y")

	s desc = "个性03|安徽省立医院开启自动生成病案台账模板(专用1)相关参数[模板ID^出院科室ITEMCODE^出院年份"    
	d ..SetSysOption("ParaRecordRoom1", desc, "7^O0001^S0002^S0003", "Y")

	s desc = "权限01|开启电子病历留痕修改[启用->Y][禁用->N]"    
	d ..SetSysOption("Revision", desc, "N", "Y")

	s desc = "权限02|开启三级医师操作权限[启用->Y][禁用->N]"    
	d ..SetSysOption("PrivControl", desc, "N", "Y")

	s desc = "权限03|开启动态页签模板权限[启用->Y][禁用->N]"    
	d ..SetSysOption("TPrivActivity", desc, "N", "Y")

	s desc = "权限04|旧框架模板权限多套模板病历类型取数代码"    
	d ..SetSysOption("PatCatalogUnitCode", desc, "病历类型#TYPE:Simple#TID:100#TVER:0#SCODE:I0024#VTYPE:C", "Y")

	s desc = "权限05|旧框架模板权限多套模板病历类型逻辑规则[^LocID1^LocID2^@^Type1^Tpye2^||^LocID3^LocID4^@^Type3^Tpye4^||^...^]"    
	d ..SetSysOption("TPrivPatTypeString", desc, "^1004^1005^1006^1313^1314^1315^1316^1319^@^01^02^||^1106^1341^1028^1300^@^03^04^05^||^1089^1090^1091^@^06^07^08^||^955^1040^@^11^12^13^14^", "Y")

	s desc = "权限06|开启安全组目录查看权限[启用->Y][禁用->N]"    
	d ..SetSysOption("CPrivActivity", desc, "N", "Y")

	s desc = "权限07|模板权限是否启用临时科室[不启用->NULL][全部启用->ALL][个别科室启用->LocID1^LocID2^LocID3]"    
	d ..SetSysOption("TPrivTempDept", desc, "NULL", "Y")

	s desc = "预览01|病历预览本地路径(格式为预览服务的本地路径^更新服务列表的临时路径^生成病历浏览XML的临时路径^FTP请求操作没有返回值的等待时间单位毫秒)[禁用->NULL]"    
	d ..SetSysOption("PreviewLocalPath", desc, "c:\windows\dhceprpreview^c:\windows\dhceprpreview\temp^c:\windows\dhceprpreview\xml^1000", "Y")

	s desc = "预览02|病历预览FTP服务器信息(FTP^FTPIpAddress^FTPPort^User^Password^Timeout)(最后一项是FTP操作没有返回值后的等待时间单位毫秒)[禁用->NULL](示例FTP^127.0.0.1^2121^anonymous^^5)"    
	d ..SetSysOption("SavePrintImage", desc, "FTP^127.0.0.1^2121^anonymous^^5", "Y")

	s desc = "预览03|域管理模式下病历预览安装更新后台服务所需的域管理员信息(UserName^DomainName^PassWord)[禁用->NULL]"    
	d ..SetSysOption("PreviewImpersonator", desc, "NULL", "Y")

	s desc = "质控04|开启唯一模板的save和commit和print操作的质控检查(如需在多个动作同时检查, 则在多个动作之间用^分隔)[全开启->save^commit^print][禁用->NULL]"    
	d ..SetSysOption("SingleQualityCtrl", desc, "save^commit^print", "Y")

	s desc = "质控05|开启可重复模板的save和commit和print动作的质控检查(如需在多个动作同时检查, 则在多个动作之间用^分隔)[全开启->save^commit^print][禁用->NULL]"    
	d ..SetSysOption("MultiQualityCtrl", desc, "save^commit^print", "Y")

	s desc = "系统11|开启新框架界面美化(仅限新框架V1.1版本使用)"    
	d ..SetSysOption("XPStyle", desc, "N", "Y")

	s desc = "预览04|开启病历预览生成服务日志[启用->Y][禁用->N]"    
	d ..SetSysOption("PreviewLogFlag", desc, "N", "Y")

	s desc = "系统12|开启前端加载病历自动打开打开第1个界面模板[启用->Y][禁用->N]"    
	d ..SetSysOption("OpenFristTemplate", desc, "N", "Y")

	s desc = "集成02|医政组院感登记拼字段[数值型][禁用->NULL]"    
	d ..SetSysOption("WMRReportCategory", desc, "NULL", "Y")

	s desc = "质控06|开启保存操作前检查审核公式必填项并控制是否允许保存[禁用->NULL][未通过审核公式给提示禁止保存->Control][未通过审核公式给提示允许保存Prompt]"   
	d ..SetSysOption("CheckFormulaBeforSave", desc, "NULL", "Y")

	s desc = "界面10|欢迎界面病历载入快捷方式维护(CTLOCID1*CTLOCID2*...或ALL#Title1#CategoryChapterID1#tmpDocID1$CTLOCID1*CTLOCID2*...或ALL#Title2#CategoryChapterID2#tmpDocID2$...)[禁用->NULL]"    
	d ..SetSysOption("CommonPrtDocs", desc, "NULL", "Y")

	s desc = "界面11|可重复模板标题自动新起页打印选项维护(PTID1|Title1^Title2^...#PTID1|Title1^Title2^...#...)[禁用->NULL]"    
	d ..SetSysOption("NewPagePrintTitle", desc, "NULL", "Y")

	s desc = "界面12|自定义特殊字符维护(字符间用^分隔)"    
	d ..SetSysOption("CustomSpecialChar", desc, "└1^└2^└3^└4^└5^└6^└7^└8^└I^└II^└III^└IV^└V^└VI^1┘^2┘^3┘^4┘^5┘^6┘^7┘^8┘^I┘^II┘^III┘^IV┘^V┘^VI┘^1┐^2┐^3┐^4┐^5┐^6┐^7┐^8┐^I┐^II┐^III┐^IV┐^V┐^VI┐^┌1^┌2^┌3^┌4^┌5^┌6^┌7^┌8^┌I^┌II^┌III^┌IV^┌V^┌VI", "Y")

	s desc = "知识库05|启动知识库挂接科室权限(知识库节点的第1层目录与相关科室挂接)[启动->Y][禁用->N]"    
	d ..SetSysOption("EnableKBTreeLocConfig", desc, "N", "Y")

	s desc = "系统13|允许查看状态栏中病历书写的详细操作日志[启用->Y][禁用->N]"    
	d ..SetSysOption("ShowDetailOper", desc, "N", "Y")

	s desc = "打印03|病历创建者打印病历时是否显示所有操作过该病历的用户明细[启用->Y][禁用->N]"    
	d ..SetSysOption("PrintDetailOper", desc, "N", "Y")

	s desc = "打印04|打印预览界面隐藏指定的预览显示比例[启用-10^25^50^75^150^200^500^auto][禁用-NULL]"    
	d ..SetSysOption("PrintHiddenZoom", desc, "NULL", "Y")

	s desc = "打印05|打印总页数超出预先设定的页数则不能打印[启用-pid1|page1^pid2|page2|…][禁用-NULL]"    
	d ..SetSysOption("PrintForbidPageOverflow", desc, "NULL", "Y")

	s desc = "打印06|打印禁用新起页新起行选项及更新按钮[启用-Y^Y^Y][禁用-NULL](分别控制新起页, 新起行, 更新按钮)"    
	d ..SetSysOption("PrintDisableConinueOption", desc, "NULL", "Y")

	s desc = "界面13|病历树宽度[系统默认->190][最小值->50]"    
	d ..SetSysOption("EPRTreeWidth", desc, "180", "Y")

	s desc = "系统14|电子病历并发操作同一份病历加锁[启用->Y][禁用->N]"    
	d ..SetSysOption("EPRLock", desc, "N", "Y")

	s desc = "界面14|电子病历引用检验数据引用格式设置(具体含义参考TMS#990详细描述)[启用->{DATE} {TIME} {ORDER}#{\r\n}#{ITEM}{SYNO}{RESULT}{UNIT}#{，|。|*}#{\r\n}][禁用->NULL]"    
	d ..SetSysOption("LisRefScheme", desc, "{DATE} {TIME} {ORDER}#{\r\n}#{ITEM}{SYNO}{RESULT}{UNIT}#{，|。|*}#{\r\n}", "Y")

	s desc = "系统15|开启电子病历患者就诊列表显示设置[显示->Y][不显示->N]"    
	d ..SetSysOption("EpisodeListActivated", desc, "N", "Y")

	s desc = "系统16|开启F单元数据打散处理[打散->Y][不打散->N]"    
	d ..SetSysOption("NeedScatterFigure", desc, "N", "Y")

	s desc = "打印07|开启病历打印操作读取最新版本(包括未发布版本)[读取最新版本->Y][正常打印逻辑流程->N]"    
	d ..SetSysOption("PrintUseLastVersion", desc, "N", "Y")

	s desc = "检索01|查询结果分页行数[数值型]"    
	d ..SetSysOption("QueryPageSize", desc, "25", "Y")

	s desc = "检索02|查询日期最大间隔天数[数值型]"    
	d ..SetSysOption("QueryDataGap", desc, "31", "Y")

	s desc = "知识库06|开启病种关联知识节点及节点通用属性的加载过滤[启动->Y][禁用->N]"    
	d ..SetSysOption("KBDiagnosFilter ", desc, "N", "Y")

	s desc = "知识库07|开启病种关联知识节点及节点通用属性对个人知识库的加载过滤[启动->Y][禁用->N]"    
	d ..SetSysOption("IsPersonalKBBindDiagnos", desc, "N", "Y")

	s desc = "知识库08|开启通过选择病种自动加载关联默认知识节点[启动->Y][禁用->N]"    
	d ..SetSysOption("LoadDefaultDiagnosKB", desc, "N", "Y")

	s desc = "界面15-1|复杂单元右键是否可以引用医嘱数据[启用->Y][禁用->N]"    
	d ..SetSysOption("OrderCitation ", desc, "Y", "Y")

	s desc = "界面15-2|复杂单元右键引用医嘱-医嘱引用显示界面列配置系统参数"    
	d ..SetSysOption("OrderColumnsScheme", desc, "OrdCreateDate:下医嘱日期, ArcimDesc:医嘱名称, DoseQty:剂量, Instr:服用方法, PHFreq:频率", "Y")

	s desc = "界面15-3|复杂单元右键引用医嘱-医嘱引用显示格式配置系统参数"    
	d ..SetSysOption("OrderStyleScheme ", desc, "医嘱名称^剂量^服用方法^下医嘱日期^频率|:^\r\n", "Y")

	s desc = "界面16|电子病历书写区页签支持最大数(欢迎页不算)"    
	d ..SetSysOption("ShowCenterTabCount", desc, "1", "Y")

	s desc = "权限08|控制是否禁用上一页和下一页按钮[Y-禁用][N-启用]"    
	d ..SetSysOption("DisablePreAndNextPage", desc, "Y", "Y")

	s desc = "系统17|是否允许GE单元剪切复制粘贴[启用->Y][关闭->N]"    
	d ..SetSysOption("CanCopyPaste", desc, "Y", "Y")

	s desc = "图库01|图库发布之后可否重新设置热点[启用->Y][关闭->N]"    
	d ..SetSysOption("ImageLibResetEnable", desc, "N", "Y")

	s desc = "界面17|异常值引用是否选中[启用-Y][禁用-N]"    
	d ..SetSysOption("LisSelectUnusualSwich", desc, "N", "Y")

	s desc = "系统18|公用数据集查询结果集分隔符[默认:@@]"    
	d ..SetSysOption("DynamicQuerySpliter", desc, "@@", "Y")

	s desc = "界面18-1|复杂单元右键是否可以引用Diagnos数据[启用->Y][禁用->N]"    
	d ..SetSysOption("DiagnosCitation", desc, "N", "Y")

	s desc = "界面18-2|复杂单元右键引用诊断-诊断疾病字典值"    
	d ..SetSysOption("DiagnosDicCode", desc, "S12", "Y")

	s desc = "界面18-3|复杂单元右键引用诊断-引用诊断样式{模式|格式}格式按级别设置 "    
	d ..SetSysOption("DiagnosStyleScheme", desc, "行模式#, ^;^&^*^$|层级模式#\r\n^\r\n^\r\n^\r\n^\r\n", "Y")

	s desc = "界面19|检验数据引用字典列设置, 分两部分, 以^分隔, 前面一部分是医嘱列设置, 后面一部分是检验项结果列设置;其中检验项结果列必须以{Flag}起始"    
	d ..SetSysOption("LISColumnScheme", desc, "{EpisodeDate}, {EpisodeSection}, {ORDER}, {LabEpisodeNo}, {SpecimenDesc}, {DATE}, {TIME}^{Flag}, {ITEM}, {SYNO}, {RESULT}, {UNIT}, {RANGE}", "Y")

	s desc = "界面22|电子病历引用检查数据引用格式设置{描述:|列名描述+父或子+列号^列描述+父或子+列号|列之间分隔符^多条数据间分隔符}[禁用->NULL] 注：如果是子列再加True/false 表示勾选不勾选"    
	d ..SetSysOption("RISRefScheme", desc, "项目:|就诊日期:+父+1^就诊科室:+父+2^医嘱名称:+父+3^诊断所见:+子+0+True^诊断意见:+子+1+True^检查方法:+子+2+True|, ^\r\n", "Y")

	s desc = "集成03|传染病上报csp地址及参数"    
	d ..SetSysOption("WebUrlMedEpdReport", desc, "{IPAddress}dhcmed.epd.report.csp?PatientID={PatientID}&EpisodeID={EpisodeID}&IFRowID=1&LocFlag=0&USERNAME={UserName}&PASSWORD={Password}&EmployeeNo={EmployeeNo}", "Y")

	s desc = "界面21|复杂单元显示行号[启用->Y][禁用->N]"    
	d ..SetSysOption("ShowLinenum", desc, "Y", "Y")

	s desc = "权限09|是否所有病人的授权可见，值为SSGroupID集合, 以^分隔多个SSGroupID"   
	d ..SetSysOption("AuthorizationSSGroupID", desc, "NULL", "Y")

	s desc = "知识库09|允许删除知识库节点[启用->Y][禁用->N]"    
	d ..SetSysOption("CanDeleteKBTreeOrKBNode", desc, "N", "Y")

	s desc = "知识库10|是否允许开启编辑个人知识库[启动->Y][禁用->N]"    
	d ..SetSysOption("PersonalKBEditable", desc, "N", "Y")

	s desc = "界面22-1|复杂单元右键是否可以引用生命体征信息数据[启用->Y][禁用->N]"    
	d ..SetSysOption("VitalsignsCitation", desc, "N", "Y")

	s desc = "界面22-2|复杂单元右键引用生命体征信息-生命体征信息引用显示界面列配置系统参数"    
	d ..SetSysOption("VitalsignsColumnsScheme", desc, "ITEM1:体温|ITEM2:脉搏|ITEM3:舒张压|ITEM4:收缩压|ITEM5:呼吸", "Y")

	s desc = "界面22-3|复杂单元右键引用生命体征信息-生命体征信息引用显示格式配置系统参数"   
	d ..SetSysOption("VitalsignsStyleScheme", desc, ":%生命体征信息#体温:%体温^脉搏:%脉搏^舒张压:%舒张压^收缩压:%收缩压^呼吸:%呼吸#/r/n, /r/n", "Y")

	//s desc = "权限10|角色知识树分配[启用->Y][禁用->N]"    
	//d ..SetSysOption("
	//leKBTree", desc, "N", "Y")

	s desc = "质控07|病历质控标准评分等级维护(甲级分数标准^乙级分数标准)"    
	d ..SetSysOption("GreadScore", desc, "^", "Y")

	s desc = "界面23|图片标注工具默认配置[属性窗口是否缩起|文本标注默认黑色边框]Y|Y 或Y|N 或 N|Y 或 N|N"    
	d ..SetSysOption("AnnoToolConfig", desc, "Y|N", "Y")

	s desc = "知识库11|是否启用角色知识库权限[启动->Y][禁用->N]"    
	d ..SetSysOption("EnableRoleKBTree", desc, "N", "Y")

	s desc = "界面24|资源区病历信息引用窗体所引用当前医院日常病程记录E单元Code值，如:ChartItemID|#TYPE:**#TID:**#TVER:**#ECODE:**"  
	d ..SetSysOption("MedRecordItemCode", desc, "ML515|#TYPE:TextDesc#TID:5#TVER:0#ECODE:E0001", "Y")

	s desc = "界面28|资源区项目tab格式： tab名称^tab描述^引用图标序号|…… 注：tab名称是固定的"    
	d ..SetSysOption("ResourceTabScheme ", desc, "tpOrdItem^医嘱^1|tpPacs^检查^2|tpLis^检验^3|tpDiagnos^诊断^4|tpVital^生命体征^5|tpMedRecord^病历信息^6 ", "Y")

	s desc = "界面29|资源区tab的宽度：知识库的宽度系数^其它窗体的宽度系数注：宽度系数为点面板的百分比"    
	d ..SetSysOption("ResourceTabWith", desc, "0.7^0.9", "Y")

	s desc = "系统19|CA服务地址"    
	d ..SetSysOption("CALocation", desc, "http://172.21.21.2:8004/Service.asmx", "Y")

	s desc = "系统20|需进行CA验证的科室LocID ['ALL'为全院，为空或为'NULL'则不启用数字签名功能]"   
	d ..SetSysOption("CACTLocIDs", desc, "1^2^3^4", "Y")
	
	w "Suceed of config EPRmeta.SysOption !!!",!
	
	quit "1"
	
ErrorHandlerSysOption
	w "Error occured in config EPRmeta.SysOption !!!",!
	w "Error info is: ", !, $ZError
	q "0"
}

}

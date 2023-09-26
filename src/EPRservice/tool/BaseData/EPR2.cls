Class EPRservice.tool.BaseData.EPR2 Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(EPRservice.tool.BaseData.EPR2).Main()
ClassMethod Main()
{
	w !,"---------重建索引---------",!
	d ..ReBuildIndices()
	
	w !,"---------配置系统参数---------",!
	d ..ConfigSysOption()
		
	w !,"---------初始化维护程序系统功能项---------",!
	d ..IniFunctions()
	
	w !,"---------初始化维护程序系统角色---------",!
	d ..IniRole()	
		
	w !,"---------配置打印模板系统常用数据---------",!
	d ..IniPrintTemplateSysData()
	
	w !,"---------配置用户级别---------",!
	d ..IniUserLevel()

	w !,"---------配置用户职务---------",!
	d ..IniUserPost()
}

/// 重建索引
ClassMethod ReBuildIndices()
{
	d ##class(EPRmeta.BindParameter).%BuildIndices()
			
    d ##class(EPRmeta.EPRTemplate).%BuildIndices()
    d ##class(EPRmeta.PrintTemplateVersion).%BuildIndices() 
	d ##class(EPRmeta.EPRTemplateCategory).%BuildIndices()
    d ##class(EPRmeta.EPRTemplate).%BuildIndices()
    
    d ##Class(EPRmeta.KBDiagnos).%BuildIndices()
    d ##class(EPRmeta.KBTree).%BuildIndices()
    d ##class(EPRmeta.KBNode).%BuildIndices()
    
    d ##Class(EPRinstance.AdmPatType).%BuildIndices()
    
    k ^DHCEPRM.GlossaryItemI("IdxComposite")
	d ##Class(EPRmeta.GlossaryItem).%BuildIndices()
	d ##Class(EPRmeta.GlossaryKBItem).%BuildIndices()
	
	d ##class(EPRmeta.CustomDictionary).%BuildIndices()
	d ##Class(EPRservice.BLL.BLCustomDictory).SetData()
}

/// 配置系统参数
/// d ##Class(EPRservice.tool.BaseData.EPR2).ConfigSysOption()
ClassMethod ConfigSysOption()
{
		s msg="按照SVN上文档配置系统参数 并且保留当前系统的参数值"
		q:"N"=##Class(EPRservice.tool.BaseData.ConfigMgr).UserConfirm(msg)
		
		S $zt = "ErrorHandlerSysOption"
    
   		//此参数维护程序自动创建
		//	s desc = "系统01|维护程序的最新版本号"   
		//	d SetSysOption("LastProductVersion", desc, "2011.1.1.1", "N")

		s desc = "系统02|医院名称[拼音首字母]"    
		d SetSysOption("HospitalName", desc, "DTHealth", "Y")

		s desc = "系统03|HIS命名空间[NAME1^NAME2]"    
		d SetSysOption("NameSpaceHIS", desc, "DHC-DATA^DHC-APP", "Y")

		s desc = "系统04|LIS命名空间[NAME1^NAME2]"    
		d SetSysOption("NameSpaceLIS", desc, "LABDATA^LABSRC", "Y")

		s desc = "系统05|RIS命名空间[NAME1^NAME2]"    
		d SetSysOption("NameSpaceRIS", desc, "RIS", "Y")

		s desc = "系统06|记录程序加载过程的时间日志(用于病历运行速度调试, 日志位置C盘根目录)[启用->Y][禁用->N]"    
		d SetSysOption("ProcessLogActivity", desc, "N", "Y")

		s desc = "系统08|开启多线程模式初始化病历[启用->Y][禁用->N]"    
		d SetSysOption("UseMultiThreading", desc, "Y", "Y")

		s desc = "系统09|开启ICD疾病编码副码扩展[启用->Y][禁用->N]"    
		d SetSysOption("ICDCodeExpand", desc, "N", "Y")

		s desc = "系统10|使用说明和质控提示页签自定义显示设置(格式为大写Y^Y或N^Y或Y^N, 第1个Y(N)判断是否显示使用说明标签, 第2个Y(N)判断是否显示质控提示标签, 若参数配置为N^N, 则默认显示使用说明标签)(仅限新框架V1.1版本使用)"    
		d SetSysOption("ShowHelpAndQuality", desc, "Y^Y", "Y")

		s desc = "界面01|DTHealth病历界面背景颜色[P5->DEDFFF][P7->F4F4F4]"    
		d SetSysOption("BGColor", desc, "F4F4F4", "Y")

		s desc = "界面02|界面模板设计默认字号大小[小五号->9][五号->10.5]"    
		d SetSysOption("DefaultFontSize", desc, "10.5", "Y")

		s desc = "界面03|字典单元查询结果每页显示行数[数值型]"    
		d SetSysOption("DicPageRowCount", desc, "12", "Y")

		s desc = "界面04|字典查询结果只屏蔽描述字段中第一个横杠"-"前的内容[表名1.字段名1, 表名2.字段名2, ...]"    
		d SetSysOption("NotRemoveMinus", desc, "SQLUser.ORC_Operation.OPER_Desc, SQLUser.MRC_ICDDx.MRCID_Desc", "Y")

		s desc = "界面05|复杂单元右键是否可以引用LIS数据[启用->Y][禁用->N]"    
		d SetSysOption("LISCitation", desc, "Y", "Y")

		s desc = "界面06|复杂单元右键是否可以引用RIS数据[启用->Y][禁用->N]"    
		d SetSysOption("RISCitation", desc, "Y", "Y")

		s desc = "界面07|允许修改可重复模板的标题[启用->Y][禁用->N]"    
		d SetSysOption("ListTitleEditable", desc, "Y", "Y")

		s desc = "界面08|允许修改可重复模板的发生时间[启用仅创建时修改->Y][启用随时修改->Y^Y][禁用->N]"    
		d SetSysOption("ListTimeEditable", desc, "N", "Y")

		s desc = "知识库01|允许前端编辑知识库[允许->TRUE][禁止->FALSE]"    
		d SetSysOption("KBEditable", desc, "FALSE", "Y")

		s desc = "知识库02|允许取消知识库的发布状态进行清除作废单元操作[启用->Y][禁用->N]"    
		d SetSysOption("CanKBStatusSwitch", desc, "Y", "Y")

		s desc = "知识库03|允许删除知识库资源管理器中的知识库模板[启用->Y][禁用->N]"    
		d SetSysOption("CanDeleteKB", desc, "Y", "Y")

		s desc = "知识库04|设置界面上知识库窗口的宽度(格式为正整数, 单元为像素)[数值型]"    
		d SetSysOption("KBPanelWidth", desc, "180", "Y")

		s desc = "打印01|可重复打印模板默认标准行高[数值型]"    
		d SetSysOption("TextRowHeight", desc, "26", "Y")

		s desc = "打印02|打印模板自动续打项目关联顺序维护(当PTid1已经打印之后, 再打印PTid2模板时, 其会自动接在PTid1后续打)[PTid1^PTid2|PTid3^PTid4...]"    
		d SetSysOption("PrtTplOrder", desc, "NULL", "Y")

		s desc = "病历树01|允许删除病历展现结构中的节点目录[启用->Y][禁用->N]"    
		d SetSysOption("AllowDeleteEPRDoc", desc, "Y", "Y")

		s desc = "集成01|移动护理PDA接口(BJDTYY护理评估单)[图表ID^模板目录ID^模板ID]"    
		d SetSysOption("PDAInterface", desc, "NULL", "Y")

		s desc = "个性01|安徽省立医院开启自动生成病案台账[启用->Y][禁用->N]"    
		d SetSysOption("AutomakeCaseRecordNo", desc, "N", "Y")

		s desc = "个性02|安徽省立医院开启自动生成病案台账模板(专用2)相关参数[模板ID^出院科室ITEMCODE^出院年份"    
		d SetSysOption("ParaRecordRoom2", desc, "6^O0001^S0002^S0004^S0003", "Y")

		s desc = "个性03|安徽省立医院开启自动生成病案台账模板(专用1)相关参数[模板ID^出院科室ITEMCODE^出院年份"    
		d SetSysOption("ParaRecordRoom1", desc, "7^O0001^S0002^S0003", "Y")

		s desc = "权限01|开启电子病历留痕修改[启用->Y][禁用->N]"    
		d SetSysOption("Revision", desc, "N", "Y")

		s desc = "权限02|开启三级医师操作权限[启用->Y][禁用->N]"    
		d SetSysOption("PrivControl", desc, "N", "Y")

		s desc = "权限03|开启动态页签模板权限[启用->Y][禁用->N]"    
		d SetSysOption("TPrivActivity", desc, "N", "Y")

		s desc = "权限04|旧框架模板权限多套模板病历类型取数代码"    
		d SetSysOption("PatCatalogUnitCode", desc, "病历类型#TYPE:Simple#TID:100#TVER:0#SCODE:I0024#VTYPE:C", "Y")

		s desc = "权限05|旧框架模板权限多套模板病历类型逻辑规则[^LocID1^LocID2^@^Type1^Tpye2^||^LocID3^LocID4^@^Type3^Tpye4^||^...^]"    
		d SetSysOption("TPrivPatTypeString", desc, "^1004^1005^1006^1313^1314^1315^1316^1319^@^01^02^||^1106^1341^1028^1300^@^03^04^05^||^1089^1090^1091^@^06^07^08^||^955^1040^@^11^12^13^14^", "Y")

		s desc = "权限06|开启安全组目录查看权限[启用->Y][禁用->N]"    
		d SetSysOption("CPrivActivity", desc, "N", "Y")

		s desc = "权限07|模板权限是否启用临时科室[不启用->NULL][全部启用->ALL][个别科室启用->LocID1^LocID2^LocID3]"    
		d SetSysOption("TPrivTempDept", desc, "NULL", "Y")

		s desc = "预览01|病历预览本地路径(格式为预览服务的本地路径^更新服务列表的临时路径^生成病历浏览XML的临时路径^FTP请求操作没有返回值的等待时间单位毫秒)[禁用->NULL]"    
		d SetSysOption("PreviewLocalPath", desc, "c:\windows\dhceprpreview^c:\windows\dhceprpreview\temp^c:\windows\dhceprpreview\xml^1000", "Y")

		s desc = "预览02|病历预览FTP服务器信息(FTP^FTPIpAddress^FTPPort^User^Password^Timeout)(最后一项是FTP操作没有返回值后的等待时间单位毫秒)[禁用->NULL](示例FTP^127.0.0.1^2121^anonymous^^5)"    
		d SetSysOption("SavePrintImage", desc, "FTP^127.0.0.1^2121^anonymous^^5", "Y")

		s desc = "预览03|域管理模式下病历预览安装更新后台服务所需的域管理员信息(UserName^DomainName^PassWord)[禁用->NULL]"    
		d SetSysOption("PreviewImpersonator", desc, "NULL", "Y")

		s desc = "质控04|开启唯一模板的save和commit和print操作的质控检查(如需在多个动作同时检查, 则在多个动作之间用^分隔)[全开启->save^commit^print][禁用->NULL]"    
		d SetSysOption("SingleQualityCtrl", desc, "save^commit^print", "Y")

		s desc = "质控05|开启可重复模板的save和commit和print动作的质控检查(如需在多个动作同时检查, 则在多个动作之间用^分隔)[全开启->save^commit^print][禁用->NULL]"    
		d SetSysOption("MultiQualityCtrl", desc, "save^commit^print", "Y")

		s desc = "系统11|开启新框架界面美化(仅限新框架V1.1版本使用)"    
		d SetSysOption("XPStyle", desc, "N", "Y")

		s desc = "预览04|开启病历预览生成服务日志[启用->Y][禁用->N]"    
		d SetSysOption("PreviewLogFlag", desc, "N", "Y")

		s desc = "系统12|开启前端加载病历自动打开打开第1个界面模板[启用->Y][禁用->N]"    
		d SetSysOption("OpenFristTemplate", desc, "N", "Y")

		s desc = "集成02|医政组院感登记拼字段[数值型][禁用->NULL]"    
		d SetSysOption("WMRReportCategory", desc, "NULL", "Y")

		s desc = "质控06|开启保存操作前检查审核公式必填项并控制是否允许保存[禁用->NULL][未通过审核公式给提示禁止保存->Control][未通过审核公式给提示允许保存Prompt]"   
		d SetSysOption("CheckFormulaBeforSave", desc, "NULL", "Y")

		s desc = "界面10|欢迎界面病历载入快捷方式维护(CTLOCID1*CTLOCID2*...或ALL#Title1#CategoryChapterID1#tmpDocID1$CTLOCID1*CTLOCID2*...或ALL#Title2#CategoryChapterID2#tmpDocID2$...)[禁用->NULL]"    
		d SetSysOption("CommonPrtDocs", desc, "NULL", "Y")

		s desc = "界面11|可重复模板标题自动新起页打印选项维护(PTID1|Title1^Title2^...#PTID1|Title1^Title2^...#...)[禁用->NULL]"    
		d SetSysOption("NewPagePrintTitle", desc, "NULL", "Y")

		s desc = "界面12|自定义特殊字符维护(字符间用^分隔)"    
		d SetSysOption("CustomSpecialChar", desc, "└1^└2^└3^└4^└5^└6^└7^└8^└I^└II^└III^└IV^└V^└VI^1┘^2┘^3┘^4┘^5┘^6┘^7┘^8┘^I┘^II┘^III┘^IV┘^V┘^VI┘^1┐^2┐^3┐^4┐^5┐^6┐^7┐^8┐^I┐^II┐^III┐^IV┐^V┐^VI┐^┌1^┌2^┌3^┌4^┌5^┌6^┌7^┌8^┌I^┌II^┌III^┌IV^┌V^┌VI", "Y")

		s desc = "知识库05|启动知识库挂接科室权限(知识库节点的第1层目录与相关科室挂接)[启动->Y][禁用->N]"    
		d SetSysOption("EnableKBTreeLocConfig", desc, "N", "Y")

		s desc = "系统13|允许查看状态栏中病历书写的详细操作日志[启用->Y][禁用->N]"    
		d SetSysOption("ShowDetailOper", desc, "N", "Y")

		s desc = "打印03|病历创建者打印病历时是否显示所有操作过该病历的用户明细[启用->Y][禁用->N]"    
		d SetSysOption("PrintDetailOper", desc, "N", "Y")

		s desc = "打印04|打印预览界面隐藏指定的预览显示比例[启用-10^25^50^75^150^200^500^auto][禁用-NULL]"    
		d SetSysOption("PrintHiddenZoom", desc, "NULL", "Y")

		s desc = "打印05|打印总页数超出预先设定的页数则不能打印[启用-pid1|page1^pid2|page2|…][禁用-NULL]"    
		d SetSysOption("PrintForbidPageOverflow", desc, "NULL", "Y")

		s desc = "打印06|打印禁用新起页新起行选项及更新按钮[启用-Y^Y^Y][禁用-NULL](分别控制新起页, 新起行, 更新按钮)"    
		d SetSysOption("PrintDisableConinueOption", desc, "NULL", "Y")

		s desc = "界面13|病历树宽度[系统默认->190][最小值->50]"    
		d SetSysOption("EPRTreeWidth", desc, "180", "Y")

		s desc = "系统14|电子病历并发操作同一份病历加锁[启用->Y][禁用->N]"    
		d SetSysOption("EPRLock", desc, "N", "Y")

		s desc = "界面14|电子病历引用检验数据引用格式设置(具体含义参考TMS#990详细描述)[启用->{DATE} {TIME} {ORDER}#{\r\n}#{ITEM}{SYNO}{RESULT}{UNIT}#{，|。|*}#{\r\n}][禁用->NULL]"    
		d SetSysOption("LisRefScheme", desc, "{DATE} {TIME} {ORDER}#{\r\n}#{ITEM}{SYNO}{RESULT}{UNIT}#{，|。|*}#{\r\n}", "Y")

		s desc = "系统15|开启电子病历患者就诊列表显示设置[显示->Y][不显示->N]"    
		d SetSysOption("EpisodeListActivated", desc, "N", "Y")

		s desc = "系统16|开启F单元数据打散处理[打散->Y][不打散->N]"    
		d SetSysOption("NeedScatterFigure", desc, "N", "Y")

		s desc = "打印07|开启病历打印操作读取最新版本(包括未发布版本)[读取最新版本->Y][正常打印逻辑流程->N]"    
		d SetSysOption("PrintUseLastVersion", desc, "N", "Y")

		s desc = "检索01|查询结果分页行数[数值型]"    
		d SetSysOption("QueryPageSize", desc, "25", "Y")

		s desc = "检索02|查询日期最大间隔天数[数值型]"    
		d SetSysOption("QueryDateGap", desc, "31", "Y")

		s desc = "知识库06|开启病种关联知识节点及节点通用属性的加载过滤[启动->Y][禁用->N]"    
		d SetSysOption("KBDiagnosFilter ", desc, "N", "Y")

		s desc = "知识库07|开启病种关联知识节点及节点通用属性对个人知识库的加载过滤[启动->Y][禁用->N]"    
		d SetSysOption("IsPersonalKBBindDiagnos", desc, "N", "Y")

		s desc = "知识库08|开启通过选择病种自动加载关联默认知识节点[启动->Y][禁用->N]"    
		d SetSysOption("LoadDefaultDiagnosKB", desc, "N", "Y")

		s desc = "界面15-1|复杂单元右键是否可以引用医嘱数据[启用->Y][禁用->N]"    
		d SetSysOption("OrderCitation ", desc, "Y", "Y")

		s desc = "界面15-2|复杂单元右键引用医嘱-医嘱引用显示界面列配置系统参数"    
		d SetSysOption("OrderColumnsScheme", desc, "OrdCreateDate:下医嘱日期, ArcimDesc:医嘱名称, DoseQty:剂量, Instr:服用方法, PHFreq:频率", "Y")

		s desc = "界面15-3|复杂单元右键引用医嘱-医嘱引用显示格式配置系统参数"    
		d SetSysOption("OrderStyleScheme ", desc, "医嘱名称^剂量^服用方法^下医嘱日期^频率|:^\r\n", "Y")

		s desc = "界面16|电子病历书写区页签支持最大数(欢迎页不算)"    
		d SetSysOption("ShowCenterTabCount", desc, "1", "Y")

		s desc = "权限08|控制是否禁用上一页和下一页按钮[Y-禁用][N-启用]"    
		d SetSysOption("DisablePreAndNextPage", desc, "Y", "Y")

		s desc = "系统17|是否允许GE单元剪切复制粘贴[启用->Y][关闭->N]"    
		d SetSysOption("CanCopyPaste", desc, "Y", "Y")

		s desc = "图库01|图库发布之后可否重新设置热点[启用->Y][关闭->N]"    
		d SetSysOption("ImageLibResetEnable", desc, "N", "Y")

		s desc = "界面17|异常值引用是否选中[启用-Y][禁用-N]"    
		d SetSysOption("LisSelectUnusualSwich", desc, "N", "Y")

		s desc = "系统18|公用数据集查询结果集分隔符[默认:@@]"    
		d SetSysOption("DynamicQuerySpliter", desc, "@@", "Y")

		s desc = "界面18-1|复杂单元右键是否可以引用Diagnos数据[启用->Y][禁用->N]"    
		d SetSysOption("DiagnosCitation", desc, "N", "Y")

		s desc = "界面18-2|复杂单元右键引用诊断-诊断疾病字典值"    
		d SetSysOption("DiagnosDicCode", desc, "S12", "Y")

		s desc = "界面18-3|复杂单元右键引用诊断-引用诊断样式{模式|格式}格式按级别设置 "    
		d SetSysOption("DiagnosStyleScheme", desc, "行模式#, ^;^&^*^$|层级模式#\r\n^\r\n^\r\n^\r\n^\r\n", "Y")

		s desc = "界面19|检验数据引用字典列设置, 分两部分, 以^分隔, 前面一部分是医嘱列设置, 后面一部分是检验项结果列设置;其中检验项结果列必须以{Flag}起始"    
		d SetSysOption("LISColumnScheme", desc, "{EpisodeDate},{EpisodeSection},{ORDER},{LabEpisodeNo},{SpecimenDesc},{DATE},{TIME}^{Flag},{ITEM},{SYNO},{RESULT},{UNIT},{RANGE}", "Y")

		s desc = "界面22|电子病历引用检查数据引用格式设置{描述:|列名描述+父或子+列号^列描述+父或子+列号|列之间分隔符^多条数据间分隔符}[禁用->NULL] 注：如果是子列再加True/false 表示勾选不勾选"    
		d SetSysOption("RISRefScheme", desc, "项目:|就诊日期:+父+1^就诊科室:+父+2^医嘱名称:+父+3^诊断所见:+子+0+True^诊断意见:+子+1+True^检查方法:+子+2+True|, ^\r\n", "Y")

		s desc = "集成03|传染病上报csp地址及参数"    
		d SetSysOption("WebUrlMedEpdReport", desc, "{IPAddress}dhcmed.epd.report.csp?PatientID={PatientID}&EpisodeID={EpisodeID}&IFRowID=1&LocFlag=0&USERNAME={UserName}&PASSWORD={Password}&EmployeeNo={EmployeeNo}", "Y")

		s desc = "界面21|复杂单元显示行号[启用->Y][禁用->N]"    
		d SetSysOption("ShowLinenum", desc, "Y", "Y")

		s desc = "权限09|是否所有病人的授权可见，值为SSGroupID集合, 以^分隔多个SSGroupID"   
		d SetSysOption("AuthorizationSSGroupID", desc, "NULL", "Y")

		s desc = "知识库09|允许删除知识库节点[启用->Y][禁用->N]"    
		d SetSysOption("CanDeleteKBTreeOrKBNode", desc, "N", "Y")

		s desc = "知识库10|是否允许开启编辑个人知识库[启动->Y][禁用->N]"    
		d SetSysOption("PersonalKBEditable", desc, "N", "Y")

		s desc = "界面22-1|复杂单元右键是否可以引用生命体征信息数据[启用->Y][禁用->N]"    
		d SetSysOption("VitalsignsCitation", desc, "N", "Y")

		s desc = "界面22-2|复杂单元右键引用生命体征信息-生命体征信息引用显示界面列配置系统参数"    
		d SetSysOption("VitalsignsColumnsCheme", desc, "ITEM1:体温|ITEM2:脉搏|ITEM3:舒张压|ITEM4:收缩压|ITEM5:呼吸", "Y")

		s desc = "界面22-3|复杂单元右键引用生命体征信息-生命体征信息引用显示格式配置系统参数"   
		d SetSysOption("VitalsignsStyleScheme", desc, ":%生命体征信息#体温:%体温^脉搏:%脉搏^舒张压:%舒张压^收缩压:%收缩压^呼吸:%呼吸#/r/n, /r/n", "Y")
        
        //移动到知识库11|是否启用角色知识库权限[启动->Y][禁用->N]
	    //	s desc = "权限10|角色知识树分配[启用->Y][禁用->N]"    
	    //	d SetSysOption("EnableRoleKBTree", desc, "N", "Y")

		s desc = "质控07|病历质控标准评分等级维护(甲级分数标准^乙级分数标准)"    
		d SetSysOption("GreadScore", desc, "^", "Y")

		s desc = "界面23|图片标注工具默认配置[属性窗口是否缩起|文本标注默认黑色边框]Y|Y 或Y|N 或 N|Y 或 N|N"    
		d SetSysOption("AnnoToolConfig", desc, "Y|N", "Y")

		s desc = "知识库11|是否启用角色知识库权限[启动->Y][禁用->N]"    
		d SetSysOption("EnableRoqj6leKBTree", desc, "N", "Y")

		s desc = "界面24|资源区病历信息引用窗体所引用当前医院日常病程记录E单元Code值，如:ChartItemID|#TYPE:**#TID:**#TVER:**#ECODE:**"  
		d SetSysOption("MedRecordItemCode", desc, "ML515|#TYPE:TextDesc#TID:5#TVER:0#ECODE:E0001", "Y")

		s desc = "界面28|资源区项目tab格式： tab名称^tab描述^引用图标序号|…… 注：tab名称是固定的"    
		d SetSysOption("ResourceTabScheme ", desc, "tpOrdItem^医嘱^1|tpPacs^检查^2|tpLis^检验^3|tpDiagnos^诊断^4|tpVital^生命体征^5|tpMedRecord^病历信息^6 ", "Y")

		s desc = "界面29|资源区tab的宽度：知识库的宽度系数^其它窗体的宽度系数注：宽度系数为点面板的百分比"    
		d SetSysOption("ResourceTabWith", desc, "0.7^0.09", "Y")
        
        //移动到^CF("CA")中
		//s desc = "系统19|CA服务地址"    
		//d SetSysOption("CALocation", desc, "http://172.21.21.2:8004/Service.asmx", "Y")
        
        //移动到^CF("CA")中
		//s desc = "系统20|需进行CA验证的科室LocID ['ALL'为全院，为空或为'NULL'则不启用数字签名功能]"   
		//d SetSysOption("CACTLocIDs", desc, "1^2^3^4", "Y")
	
	    s desc = "系统21|病历操作是否需先检查签名是否有效[是->Y][否->N]"
        d SetSysOption("CheckValidSign", desc, "Y", "Y")
        
        s desc = "界面30|电子病历信息的订阅与发布机制[启用->Y][禁用->N]"
        d SetSysOption("Observer", desc, "N", "Y")
        
        s desc = "权限11|开启集中打印一键打印权限[启用->Y][禁用->其他]，启用后一键打印和集中打印必须在用户对模板有打印权限的时才能作为打印项选择打印"
        d SetSysOption("AuthorizationOneStepPrintSwitch", desc, "N", "Y")
        
		w !,"完成更新系统参数",!
	    q
	 
SetSysOption(name, desc, value, isVisible)
 
		s id=$o(^DHCEPRM.SysOptionI("NameIndex"," "_$zcvt(name,"U"),""))
	    if (""=id)	//新增系统参数
	    {
		    s obj=##Class(EPRmeta.SysOption).%New()
		    s obj.Name=name
		    s obj.Description=desc
		    s obj.IsVisible=isVisible
		    s obj.OptionValue=value
		    d obj.%Save()	
		}
	    else	//更新描述
	    {
		    s obj=##Class(EPRmeta.SysOption).%OpenId(id)
		    s obj.Description=desc
		    d obj.%Save()
		}
			
		q    
ErrorHandlerSysOption
		w "更新系统参数错误: ", !, $ZError	
		q
}

/// 初始化维护程序系统功能项
/// 维护程序每一个功能操作一条记录,管理员默认拥有全部权限
/// d ##Class(EPRservice.tool.BaseData.EPR2).IniFunctions()
ClassMethod IniFunctions()
{
	//重建索引
	d ##Class(EPRmeta.MainDictFunction).%BuildIndices()
	
	s msg="初始化维护程序权限功能"
	q:"N"=##Class(EPRservice.tool.BaseData.ConfigMgr).UserConfirm(msg)
		
	S $zt = "ErrorHandlerFunctions"

    s groupType = "Group"
    s itemType = "Item"
    
    s funcID = $$SetFunction("Menu_View", "视图", "0", groupType)	  	
  	d SetFunction("Menu_View_ITemplate", "界面模板资源管理器", funcID, itemType)
	d SetFunction("Menu_View_Knowledge", "知识库资源管理器", funcID, itemType)
	d SetFunction("Menu_View_PTemplate", "打印模板资源管理器", funcID, itemType)
	d SetFunction("Menu_View_RTemplate", "报表模板资源管理器", funcID, itemType)	
	d SetFunction("Menu_View_Glossary",  "术语集资源管理器", funcID, itemType)
	d SetFunction("Menu_View_ImageLibrary",  "图库资源管理器", funcID, itemType)

    s funcID = $$SetFunction("Menu_Tools", "设置", "0", groupType)
	d SetFunction("Menu_Tools_DictionarySet", "字典表设置", funcID, itemType)
	d SetFunction("Menu_Tools_UnitSet", "数量单位设置", funcID, itemType)
	d SetFunction("Menu_Tools_EpisodeDataSet", "就诊数据项维护", funcID, itemType)
	d SetFunction("Menu_Tools_CategoryTypeSet", "界面模板目录类型维护", funcID, itemType)
	d SetFunction("Menu_Tools_CTPropertySet", "界面模板及目录属性维护", funcID, itemType)
	d SetFunction("Menu_Tools_DataExport", "导出数据", funcID, itemType)
	d SetFunction("Menu_Tools_EPRExport", "导出病历", funcID, itemType)
	d SetFunction("Menu_Tools_DataRefersSet", "数据引用设置", funcID, itemType)
	d SetFunction("Menu_Tools_ParamsSet", "系统参数维护", funcID, itemType)
	d SetFunction("Menu_Tools_SuperUserSet", "用户维护", funcID, itemType)
	d SetFunction("Menu_Tools_InsStatusConfig", "病历状态设置", funcID, itemType)
	d SetFunction("Menu_Tools_QuotePageSet", "页面引用设置", funcID, itemType)
	d SetFunction("Menu_Tools_EPRCategoryShowSet", "病历展现结构设置", funcID, itemType)
	d SetFunction("Menu_Tools_DynamicConfigTable", "公用字典集数据维护", funcID, itemType)
	
	s funcID = $$SetFunction("Menu_Tools_PrivConfig", "权限设置", funcID, groupType)
	d SetFunction("Menu_Tools_PrivConfig_PrivRuleConfig", "权限规则维护", funcID, itemType)
	d SetFunction("Menu_Tools_PrivConfig_UserLevelConfig", "医生级别维护", funcID, itemType)
	d SetFunction("Menu_Tools_PrivConfig_SubUserConfig", "下级医生维护", funcID, itemType)
	d SetFunction("Menu_Tools_PrivConfig_TempConfig", "模板权限配置", funcID, itemType)
	d SetFunction("Menu_Tools_PrivConfig_RoleFunctionSet","角色权限设置",funcID, itemType)
	d SetFunction("Menu_Tools_PrivRuleType", "规则类型维护", funcID, itemType)
	d SetFunction("Menu_Tools_PrivConfig_RoleKBTreeSet", "角色知识库设置", funcID, itemType) 

    s funcID = $$SetFunction("Btn_Edit", "编辑", "0", groupType)
    d SetFunction("Btn_Edit_AddCategory", "新建目录", funcID, itemType)
	d SetFunction("Btn_Edit_AddResource", "添加新项", funcID, itemType)
	d SetFunction("Btn_Edit_AddVersion", "新建版本", funcID, itemType)
	d SetFunction("Btn_Edit_Open", "打开", funcID, itemType)
	d SetFunction("Btn_Edit_Cut", "剪切", funcID, itemType)
	d SetFunction("Btn_Edit_Paste", "粘贴", funcID, itemType)
	d SetFunction("Btn_Edit_Copy", "复制", funcID, itemType)
	d SetFunction("Btn_Edit_Delete", "删除", funcID, itemType)
	d SetFunction("Btn_Edit_Property", "属性", funcID, itemType)
	d SetFunction("Btn_Edit_Export", "导出", funcID, itemType)
	d SetFunction("Btn_Edit_Input", "导入", funcID, itemType)
	d SetFunction("Btn_Edit_Refresh", "刷新", funcID, itemType)
	d SetFunction("Btn_Edit_Update", "更新", funcID, itemType)
 
    s funcID = $$SetFunction("Btn_File", "文件", "0", "Group")		
    d SetFunction("Btn_File_Save", "保存", funcID, itemType)
	d SetFunction("Btn_File_SaveAll", "全部保存", funcID, itemType)
	d SetFunction("Btn_File_Publish", "发布", funcID, itemType)
	
    w !,"完成初始化维护程序权限功能"
	q

SetFunction(funcName, funcDesc, parentID, type)
	    s id=$o(^DHCEPRM.MainDictFunctionI("IdxFuncName"," "_$zcvt(funcName,"U"),""))
	    s obj=""
	   
	    if (""=id)	//新增系统参数
	    {
		    s obj=##Class(EPRmeta.MainDictFunction).%New()
		    s obj.FuncName=funcName
		    s obj.FuncDesc=funcDesc
		    s obj.ParentID=parentID
		    s obj.Type=type
		    d obj.%Save()	
		}
	    else	//更新描述
	    {
		    s obj=##Class(EPRmeta.MainDictFunction).%OpenId(id)
		    s obj.FuncDesc=funcDesc
		    s obj.ParentID=parentID
		    s obj.Type=type
		    d obj.%Save()
		}
		q obj.%Id()
			    
ErrorHandlerFunctions
	w "初始化维护程序权限功能错误: ", !, $ZError	
	q
}

/// 初始化维护程序系统角色
/// d ##Class(EPRservice.tool.BaseData.EPR2).IniRole()
ClassMethod IniRole()
{
	//重建索引
	d ##Class(EPRmeta.MainRole).%BuildIndices()
	
	s msg="初始化维护程序系统角色"
	q:"N"=##Class(EPRservice.tool.BaseData.ConfigMgr).UserConfirm(msg)
		
	S $zt = "ErrorHandlerRole"	
    
    d SetMainRole("Administrator","超级管理员")
    d SetMainRole("knowledge","知识库")
    d SetMainRole("template","模板库")
	d SetMainRole("guest","访客")
	
    w !,"完成初始化维护程序系统角色"
	q
	 
SetMainRole(name,desc)
	s id=$o(^DHCEPRM.MainRoleI("IdxRoleName", " "_$zcvt(name,"U"), ""))
	if (""=id)
	{
		s obj=##Class(EPRmeta.MainRole).%New()
		s obj.RoleName=name
		s obj.RoleDesc=desc
		d obj.%Save()
	}
	else
	{
		s obj=##Class(EPRmeta.MainRole).%OpenId(id)
		s obj.RoleDesc=desc
		d obj.%Save()
	}
    q	    
ErrorHandlerRole
	w "初始化维护程序系统角色错误: ", !, $ZError	
	q
}

/// 配置打印模板系统常用数据
/// d ##Class(EPRservice.tool.BaseData.EPR2).IniPrintTemplateSysData()
ClassMethod IniPrintTemplateSysData()
{
	//重建索引
	d ##Class(EPRmeta.PrintTemplateSysData).%BuildIndices()
	
	s msg="配置打印模板系统常用数据"
	q:"N"=##Class(EPRservice.tool.BaseData.ConfigMgr).UserConfirm(msg)
		
	S $zt = "ErrorHandlerPrtTmpSysData"	
	
	// 唯一模板
	d NewSysData("病历作者", "SAUTHOR", 4)
    d NewSysData("审核医师", "SCHECKUSER", 4)
    d NewSysData("审核日期", "SCHECKDATE", 1)
    d NewSysData("审核医师级别", "SCHECKLEVEL", 4)
    d NewSysData("病历作者签名", "SAUTHORSIGN", 1)
    d NewSysData("病历作者签名图", "SAUTHORIMG", 4)
    d NewSysData("病历作者签名时间", "SAUTHORSIGNDATE", 1) 
    d NewSysData("审核医师签名", "SCHECKSIGN", 1)   
    d NewSysData("审核医师签名图", "SCHECKUSERIMG", 4)   
    d NewSysData("审核医师签名时间", "SCHECKSIGNDATE", 1)   
    d NewSysData("主治医师签名", "SATTENDINGSIGN", 4)   
    d NewSysData("主治医师签名图", "SATTENDINGSIGNIMG", 4) 
    d NewSysData("主任医师签名", "SCHIEFSIGN", 4) 
    d NewSysData("主任医师签名图", "SCHIEFSIGNIMG", 4)  
    d NewSysData("提交者签名图", "SCOMMITTERIMG", 4)   
  	d NewSysData("科主任签名", "SCHAIRMAN", 4)       
    d NewSysData("质控医师签名", "SQCDOC", 4)  
    d NewSysData("质控护士签名", "SQCNURSE", 4)  
    d NewSysData("责任护士签名", "SCHARGENURSE", 4)  
            
	// 可重复模板 
    d NewInstanceData("作者", "AUTHOR", 4) 
    d NewInstanceData("标题", "TITLE", 3) 
    d NewInstanceData("发生日期", "HAPPENDATE", 1)
    d NewInstanceData("发生时间", "HAPPENTIME", 2) 
    d NewInstanceData("顺序号", "LISTNO", 3)  
    d NewInstanceData("审核医师", "CHECKUSER", 3) 
    d NewInstanceData("审核日期", "CHECKDATE", 1)
    d NewInstanceData("审核医师级别", "CHECKLEVEL", 3)   
    d NewInstanceData("作者签名", "AUTHORSIGN", 1) 
    d NewInstanceData("作者签名图", "AUTHORIMG", 4)
    d NewInstanceData("作者签名时间", "AUTHORSIGNDATE", 1) 
    d NewInstanceData("审核医师签名", "CHECKSIGN", 1) 
    d NewInstanceData("审核医师签名图", "CHECKUSERIMG", 4)
    d NewInstanceData("审核医师签名时间", "CHECKSIGNDATE", 1)
    d NewInstanceData("主治医师签名", "ATTENDINGSIGN", 4) 
    d NewInstanceData("主治医师签名图", "ATTENDINGSIGNIMG", 4)       
    d NewInstanceData("主任医师签名", "CHIEFSIGN", 4)
    d NewInstanceData("主任医师签名图", "CHIEFSIGNIMG", 4)  
    d NewInstanceData("提交者签名图", "COMMITTERIMG", 4)  
    d NewInstanceData("编辑者签名", "EDITORSIGN", 4)
    d NewInstanceData("是否打印标题", "ISTITLEPRINT", 3)
    	
    w !,"完成配置打印模板系统常用数据"
	q

NewSysData(sName, sCode, sImage)
	s id=$o(^DHCEPRM.PrintTemplateSysDataI("IdxCode", " "_$zcvt(sCode,"U"), ""))
	if (""=id)
	{
		s obj=##Class(EPRmeta.PrintTemplateSysData).%New()
		s obj.Name=sName,obj.Type="SystemData",obj.Code=sCode,obj.Image=sImage
	}
	else
	{
		s obj=##Class(EPRmeta.PrintTemplateSysData).%OpenId(id)
		s obj.Name=sName,obj.Type="SystemData",obj.Image=sImage
	}
    d obj.%Save()
    q

NewInstanceData(sName, sCode, sImage)
	s id=$o(^DHCEPRM.PrintTemplateSysDataI("IdxCode", " "_$zcvt(sCode,"U"), ""))
	if (""=id)
	{
		s obj=##Class(EPRmeta.PrintTemplateSysData).%New()
		s obj.Name=sName,obj.Type="InstanceData",obj.Code=sCode,obj.Image=sImage
	}
	else
	{
		s obj=##Class(EPRmeta.PrintTemplateSysData).%OpenId(id)
		s obj.Name=sName,obj.Type="InstanceData",obj.Image=sImage
	}
    d obj.%Save() 
	
    q
	
ErrorHandlerPrtTmpSysData
	w "配置打印模板系统常用数据错误: ", !, $ZError	
	q
}

/// 配置用户级别
/// d ##Class(EPRservice.tool.BaseData.EPR2).IniUserLevel()
ClassMethod IniUserLevel()
{
	//重建索引
	d ##Class(EPRmeta.UserLevel).%BuildIndices()
	
	s msg="配置用户级别"
	q:"N"=##Class(EPRservice.tool.BaseData.ConfigMgr).UserConfirm(msg)
		
	S $zt = "ErrorHandlerUserLevel"	
	
	d SetUserLevel("Resident","住院医师","1")
	d SetUserLevel("Attending","主治医师","1")
    d SetUserLevel("Chief","主任/副主任医师","1")
    d SetUserLevel("","未分配","1")

    w !,"完成配置用户级别"
	q
	
SetUserLevel(name,desc,isValid)
	s id=$o(^DHCEPRM.UserLevelI("NameIndex", " "_$zcvt(name,"U"), ""))
	if (""=id)
	{
		s obj=##Class(EPRmeta.UserLevel).%New()
		s obj.Name=name,obj.Description=desc,obj.IsValid=isValid
	}
	else
	{
		s obj=##Class(EPRmeta.UserLevel).%OpenId(id)
		s obj.Description=desc		
	}
	d obj.%Save() 
	
    q 		
ErrorHandlerUserLevel
	w "配置用户级别错误: ", !, $ZError	
	q
}

/// 配置用户职务
/// d ##Class(EPRservice.tool.BaseData.EPR2).IniUserPost()
ClassMethod IniUserPost()
{
	//重建索引
	d ##Class(EPRmeta.UserPost).%BuildIndices()
	
	s msg="配置用户职务"
	q:"N"=##Class(EPRservice.tool.BaseData.ConfigMgr).UserConfirm(msg)
		
	S $zt = "ErrorHandlerUserPost"	
	
	d SetUserPost("Chairman","科主任","ChairmanCheck","1")
	d SetUserPost("QCDoc","质控医师","QCDocCheck","1")
    d SetUserPost("QCNurse","质控护士","QCNurseCheck","1")
    d SetUserPost("ChargeNurse","责任护士","ChargeNurseCheck","1")
    d SetUserPost("","未分配","","1")
    
    w !,"完成配置用户职务"
	q
	
SetUserPost(name,desc,operAct,isValid)
	s id=$o(^DHCEPRM.UserPostI("NameIndex", " "_$zcvt(name,"U"), ""))
	if (""=id)
	{
		s obj=##Class(EPRmeta.UserPost).%New()
		s obj.Name=name,obj.Description=desc,obj.OperAction=operAct,obj.IsValid=isValid
	}
	else
	{
		s obj=##Class(EPRmeta.UserPost).%OpenId(id)
		s obj.Description=desc		
	}
	d obj.%Save() 
	
    q 		
ErrorHandlerUserPost
	w "配置用户职务错误: ", !, $ZError	
	q
}

/// Desc: 配置 EPRmeta.EPRAction
/// Using: w ##class(EPRservice.tool.BaseData.EPR2).ConfigEPRAction()
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
	do ..SetEPRAction("refreshAll", "刷新所有界面模板")  //<+>added by houj on 2013-07-21
	do ..SetEPRAction("reference","引用")  //病历引用基础数据2011-11-29 wangwentao add
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
/// Using: w ##class(EPRservice.tool.BaseData.EPR2).ConfigEPRStatus()
ClassMethod ConfigEPRStatus() As %String
{
	S $zt = "ErrorHandlerEPRStatus"
	
	TSTART
	
	w !
	w "Begin of config EPRmeta.EPRStatus !!!",!
	do ..SetEPRStatus("created", "初始化")
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
/// Using: w ##class(EPRservice.tool.BaseData.EPR2).ConfigEPRActStatusCfg()
ClassMethod ConfigEPRActStatusCfg() As %String
{
	S $zt = "ErrorHandlerEPRActStatusCfg"
	
	TSTART
	
	w !
	w "Begin of config EPRmeta.EPRActStatusCfg !!!",!
	
	do ..SetEPRActStatusCfg(" ", "save", "unfinished")
	do ..SetEPRActStatusCfg(" ", "complete", "finished")
	//do ..SetEPRActStatusCfg(" ", "refreshNecessary", "unfinished")
	//do ..SetEPRActStatusCfg(" ", "refreshUnnecessary", "unfinished")
	do ..SetEPRActStatusCfg(" ", "refreshNecessary", "created")		//<+>未创建的病历直接更新模板应该还是处在初始状态 modified on 2013-07-21 by houj
	do ..SetEPRActStatusCfg(" ", "refreshUnnecessary", "created")	//<+>未创建的病历直接更新模板应该还是处在初始状态 modified on 2013-07-21 by houj
	do ..SetEPRActStatusCfg(" ","reference","unfinished")  //病历引用基础数据2011-11-29 wangwentao add / 20120705 wangwentao update PreStatus -> EPRAction -> PostStatus
	do ..SetEPRActStatusCfg(" ","refcomplete","finished")
	do ..SetEPRActStatusCfg(" ", "refreshAll", "created")
	
	do ..SetEPRActStatusCfg("created", "save", "unfinished")
	do ..SetEPRActStatusCfg("created", "complete", "finished")
	do ..SetEPRActStatusCfg("created","reference","unfinished")
	do ..SetEPRActStatusCfg("created","refcomplete","finished")
	do ..SetEPRActStatusCfg("created", "refreshNecessary", "created")
	do ..SetEPRActStatusCfg("created", "refreshUnnecessary", "created")
	do ..SetEPRActStatusCfg("created", "refreshAll", "created")


	do ..SetEPRActStatusCfg("unfinished", "save", "unfinished")
	do ..SetEPRActStatusCfg("unfinished", "complete", "finished")
	do ..SetEPRActStatusCfg("unfinished", "switch", "unfinished")
	do ..SetEPRActStatusCfg("unfinished", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("unfinished", "refreshUnnecessary", "unfinished")
	do ..SetEPRActStatusCfg("unfinished","reference","unfinished")  //病历引用基础数据2011-11-29 wangwentao add / 20120705 wangwentao update PreStatus -> EPRAction -> PostStatus
	do ..SetEPRActStatusCfg("unfinished","refcomplete","finished")
	do ..SetEPRActStatusCfg("unfinished","refreshAll","created")
	
	
	do ..SetEPRActStatusCfg("finished", "save", "finished")
	do ..SetEPRActStatusCfg("finished", "complete", "finished")
	do ..SetEPRActStatusCfg("finished", "print", "finished")
	do ..SetEPRActStatusCfg("finished", "commit", "commited")
	do ..SetEPRActStatusCfg("finished", "switch", "unfinished")
	do ..SetEPRActStatusCfg("finished", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("finished", "refreshUnnecessary", "finished")
	do ..SetEPRActStatusCfg("finished","reference","finished")  //病历引用基础数据2011-11-29 wangwentao add / 20120705 wangwentao update PreStatus -> EPRAction -> PostStatus
	do ..SetEPRActStatusCfg("finished","refcomplete","finished")
	do ..SetEPRActStatusCfg("finished","refreshAll","created")
	
	do ..SetEPRActStatusCfg("commited", "save", "commited")
	do ..SetEPRActStatusCfg("commited", "complete", "commited")
	do ..SetEPRActStatusCfg("commited", "print", "commited")
	do ..SetEPRActStatusCfg("commited", "switch", "unfinished")
	do ..SetEPRActStatusCfg("commited", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("commited", "refreshUnnecessary", "commited")
	do ..SetEPRActStatusCfg("commited", "attendingCheck", "attendingChecked")
	do ..SetEPRActStatusCfg("commited", "chiefCheck", "chiefChecked")
	do ..SetEPRActStatusCfg("commited","refreshAll","created")
	
	
	do ..SetEPRActStatusCfg("attendingChecked", "complete", "attendingChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "print", "attendingChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "chiefCheck", "chiefChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("attendingChecked", "refreshUnnecessary", "attendingChecked")
	do ..SetEPRActStatusCfg("attendingChecked", "switch", "unfinished")
	do ..SetEPRActStatusCfg("attendingChecked","refreshAll","created")
	
		
	do ..SetEPRActStatusCfg("chiefChecked", "complete", "chiefChecked")
	do ..SetEPRActStatusCfg("chiefChecked", "print", "chiefChecked")
	do ..SetEPRActStatusCfg("chiefChecked", "refreshNecessary", "unfinished")
	do ..SetEPRActStatusCfg("chiefChecked", "refreshUnnecessary", "chiefChecked")
	do ..SetEPRActStatusCfg("chiefChecked", "switch", "unfinished")
	do ..SetEPRActStatusCfg("chiefChecked","refreshAll","created")
	
	do ..SetEPRActStatusCfg("archieved", "print", "archieved")
	
	
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

}

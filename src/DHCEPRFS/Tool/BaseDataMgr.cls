Class DHCEPRFS.Tool.BaseDataMgr Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	基础数据初始化
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).Init()
ClassMethod Init()
{
	d ..InitSysOption2()
	
	d ..InsertQueryFunction()
	d ..InsertQueryCategory()
	d ..InsertQueryField()
	d ..InsertResultColumns()
	d ..InitCustomDic()
	
	d ..InitConfigMetaLC()
	
	d ..InitCTItemType()
	d ..InitCTItemInvokeType()
	
	d ..InitMRAction()
	d ..InitTransiton()
	d ..InitRecordCheck()
	d ..InitFileStoreConfig()
	d ..InitCTTaskType()
	d ..InitASType()
	w !,"基础数据初始化完成"
}

/// Desc:	初始化文件服务器FTP配置
/// Debug: 	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitFileStoreConfig()
ClassMethod InitFileStoreConfig() As %String
{
	s sc = $$InitFileStoreConfig($zdh("1840-12-31",3), $zdh("2840-12-31",3), "127.0.0.1", "/", "DHCEPRFS", "FS_user", "FTP1dhbzh", "21", "5", "edtftp")
	s sc = $$InitFileStoreConfig($zdh("1840-12-31",3), $zdh("2840-12-31",3), "127.0.0.1", "/", "DHCEPRFS_MEDIA", "FS_user", "FTP1dhbzh", "21", "5", "edtftp")
	
InitFileStoreConfig(startDate, endDate, fileServerIP, virtualDir, nameSpace, fileServerUserName, fileServerPassword, fileServerPort, fileServerTimeOut,ftpMethod)
	s rowid =""
	&sql(select ID into :rowid from DHCEPRFS_META.FileStoreConfig where NameSpace = :nameSpace)
	w !,rowid
	if (rowid ="")
	{
		&sql(insert into DHCEPRFS_META.FileStoreConfig(StartDate, EndDate, FileServerIP, VirtualDir, NameSpace, FileServerUserName, FileServerPassword, FileServerPort, FileServerTimeOut, FTPMethod) 
			values (:startDate, :endDate, :fileServerIP, :virtualDir, :nameSpace, :fileServerUserName, :fileServerPassword, :fileServerPort, :fileServerTimeOut,:ftpMethod))
	}
	q "1"
}

/// Desc:	协和使用，初始化所有欲估算页数的项目
/// Debug:	w ##Class(DHCEPRFS.Tool.BaseDataMgr).InitEstimatePages()
ClassMethod InitEstimatePages()
{
	
	s count = 0
	//MRSubCategory
	s cgID = ""
	for {
		s cgID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " 0", cgID))
		q:(cgID = "")
		
		s cgDesc = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetTemplateCategoryDesc(cgID)
		
		w !,"------   Init MRSubCategory "_"EMRSub"_cgID_" "_cgDesc_"   ------ok"
		
		//MRItem
		s ccID = ""
		for {
			s ccID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_cgID, ccID))
			q:(ccID = "")
			
			s ccDesc = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetTemplateCategoryDesc(ccID)
			
			s count = count + 1
			s rowID = ##class(DHCEPRFS.BL.BLEstimatePages).CreateEstimatePagesItem("EMRItem"_ccID,ccDesc,ccDesc,"CD_"_cgID_"_"_ccID,"71","N",count)
			w !,rowID_" Init MRItem "_"EMRItem"_ccID_" "_ccDesc_" ------ok"
			//s docID = ""
			//for
			//{
			//	s docID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_ccID,docID))	
			//	q:(docID = "")
			//	s count = count + 1
			
			//	s docDesc = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetTemplateCategoryDesc(docID)

			//	s rowID = ##class(DHCEPRFS.BL.BLEstimatePages).CreateEstimatePagesItem("EMRItem"_docID,docDesc,docDesc,"CD_"_cgID_"_"_ccID_"_"_docID,"71","N",count)
			//	w !,rowID_" Init MRItem "_"EMRItem"_docID_" "_docDesc_" ------ok"
			//}
		}
	}
	s count = count + 1
	s rowID = ##class(DHCEPRFS.BL.BLEstimatePages).CreateEstimatePagesItem("OrdLongItem01","长期医嘱","长期医嘱","1","31","Y",count)
	w !,rowID_" Init MRItem "_"OrdLongItem01 ------ok"
	
	s count = count + 1
	s rowID = ##class(DHCEPRFS.BL.BLEstimatePages).CreateEstimatePagesItem("OrdTempItem01","临时医嘱","临时医嘱","1","32","Y",count)
	w !,rowID_" Init MRItem "_"OrdTempItem01 ------ok"
	
	s count = count + 1
	s rowID = ##class(DHCEPRFS.BL.BLEstimatePages).CreateEstimatePagesItem("PACSItem01","检查","检查","1","83","Y",count)
	w !,rowID_" Init MRItem "_"PACSItem01 ------ok"
	
	s count = count + 1
	s rowID = ##class(DHCEPRFS.BL.BLEstimatePages).CreateEstimatePagesItem("LISItem01","检验","检验","1","82","Y",count)
	w !,rowID_" Init MRItem "_"LISItem01 ------ok"
}

/// Desc:	初始化新版(三版)病历归档项
/// Debug: 	w ##Class(DHCEPRFS.Tool.BaseDataMgr).InitFS("1")
ClassMethod InitFS(AMRCategoryID As %String)
{
	//CTItemType
	//s sequence = 0
	//&sql(select count(*) into :sequence from DHCEPRFS_META.CTItemType)
	//&sql(insert into DHCEPRFS_META.CTItemType (TypeCode, TypeName, TypeDesc, CSPPath, Sequence) 
	//		values ('71', '病历文书', '病历文书','emr.interface.print.fs.csp', :sequence))
	
	s count = 0
	//MRSubCategory
	s cgID = ""
	for {
		s cgID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " 0", cgID))
		q:(cgID = "")
		
		s cgDesc = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetTemplateCategoryDesc(cgID)
		
		//MRItem
		s ccID = ""
		for {
			s ccID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_cgID, ccID))
			q:(ccID = "")
			
			s ccDesc = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetTemplateCategoryDesc(ccID)
			
			//判断是否有SubCategory存在
			//s mrSubCategoryID = ##Class(DHCEPRFS.BL.BLMRSubCategory).GetSubCategoryIDByCode("EMRSub_"_cgID_"_"_ccID)
			s mrSubCategoryID = ##Class(DHCEPRFS.BL.BLMRSubCategory).GetSubCategoryIDByCode("EMRSub_"_cgID)  //Code:EMRSub_1
			if (mrSubCategoryID="")	//为空生成
			{
				//s mrSubCategoryID = ##Class(DHCEPRFS.BL.BLMRSubCategory).CreateSubCategory("EMRSub_"_cgID_"_"_ccID, cgDesc_" "_ccDesc, cgDesc_" "_ccDesc, AMRCategoryID,cgID_"_"_ccID)
				s mrSubCategoryID = ##Class(DHCEPRFS.BL.BLMRSubCategory).CreateSubCategory("EMRSub_"_cgID, cgDesc, cgDesc, AMRCategoryID,cgID)
				w !,"------   【Init】 MRSubCategory "_"EMRSub_"_cgID_"_"_ccID_" "_cgDesc_" "_ccDesc_"   ------ok"
			}
			else
			{
				d ##Class(DHCEPRFS.BL.BLMRSubCategory).UpdateSubCategory("EMRSub_"_cgID, cgDesc, cgDesc, AMRCategoryID)
				w !,"------   【Update】 MRSubCategory "_"EMRSub_"_cgID_"_"_ccID_" "_cgDesc_" "_ccDesc_"   ------ok"
			}
			
			s docID = ""
			for
			{
				s docID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_ccID,docID))	
				q:(docID = "")
				s count = count + 1

				s docDesc = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetTemplateCategoryDesc(docID)
				s mrItemID=##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType("71",docID)
				if (mrItemID="")	//为空生成
				{
					//s mrItemID = ##Class(DHCEPRFS.BL.BLMRItem).CreateItem("EMRItem"_docID, docDesc, docDesc, mrSubCategoryID, "71", docID)
					s mrItemID = ##Class(DHCEPRFS.BL.BLMRItem).CreateItem("EMRItem"_ccID_"_"_docID, ccDesc_" "_docDesc, docDesc, mrSubCategoryID, "71", docID)
					w !,"【Init】 MRItem: "_"EMRItem"_docID_" "_docDesc_" ------ok"
				}
				else
				{
					d ##Class(DHCEPRFS.BL.BLMRItem).UpdateItem("EMRItem"_ccID_"_"_docID, ccDesc_" "_docDesc, docDesc, mrSubCategoryID, "71", docID)
					w !,"【Update】 MRItem: "_"EMRItem"_docID_" "_docDesc_" ------ok"
				}
			}
		}
	}
}

/// Desc:	初始化系统参数
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitSysOption2()
ClassMethod InitSysOption2()
{
	//通用
	s sc = $$InitSysOption2("SystemName", "电子病历归档管理系统", "电子病历归档管理程序名称", "base")
	s sc = $$InitSysOption2("Version", "Version 4.1.0", "电子病历归档管理程序版本号", "base")
	s sc = $$InitSysOption2("DBVersion", "2016", "数据库版本 2010-Cache2010，2016-Cache2016 5-包括5.0.15的5系列，6-比如6.9的6系列", "base")
	s sc = $$InitSysOption2("DBUserPassword", "Tg8NkyExT3BvDt0H0LYcTQ==^U32dKBWxL39nFiJRSTaxfA==", "数据库Webservice用户的用户名密码，密文", "base")
	s sc = $$InitSysOption2("DataServiceURL", "http://0.0.0.0/imedical/webservice/", "数据访问Web服务地址", "base")
	s sc = $$InitSysOption2("WebURL", "http://0.0.0.0/imedical/web/", "Web地址", "base")
	s sc = $$InitSysOption2("HospitalFlag", "DHSZHYY", "医院标识", "base")
	s sc = $$InitSysOption2("HospitalName", "东华标准版数字化医院", "医院名称", "base")
	s sc = $$InitSysOption2("FTPUsePassive", "Y", "FTP连接使用被动模式(Y,N)", "base")
	s sc = $$InitSysOption2("IsWMROn", "Y", "是否上线病案组病案管理系统", "common")
	s sc = $$InitSysOption2("AutoRetrieve", "N", "是否开启自动回收功能，Y-开启，非Y-不开启", "common")
	s sc = $$InitSysOption2("EnableObservedNo", "Y", "是否启用留观号查询条件，Y-开启，非Y-不开启", "common")
	s sc = $$InitSysOption2("CASWebServiceCheckUrl","http://172.18.1.243:8081/Common_C92_WebService/services/CasValidateServiceImpl?wsdl^CasValidateServiceImpl^validateTicket","portal单点登录配置","common")
	
	//浏览
	s sc = $$InitSysOption2("SysCode", "DHC", "类型代码", "BROWSE")
	s sc = $$InitSysOption2("LocalTMPDirPath", "c:\DHCCPDFView\", "浏览PDF缓存文件夹路径", "BROWSE")
	s sc = $$InitSysOption2("LogPath", "c:\DHCCPDFView\Log\", "浏览日志文件夹路径", "BROWSE")
	s sc = $$InitSysOption2("ShowPreview", "Y", "是否显示缩略图预览", "BROWSE")
	s sc = $$InitSysOption2("BufferSize", "50", "单项缓存的最大页数", "BROWSE")
	s sc = $$InitSysOption2("MouseScrollMode", "1", "鼠标滚轮模式", "BROWSE")
	s sc = $$InitSysOption2("PrivacyLevelVersionType", "CREATEPRIVACY01", "隐私域的级别", "BROWSE")
	s sc = $$InitSysOption2("ShowTimeLine", "Y", "病案复核是否显示示踪时间轴，Y-显示，N-不显示", "BROWSE")
	s sc = $$InitSysOption2("SuperSSGroup", "54^58^62^63", "分配病案复核超级权限的安全组ID，以'^'分隔", "BROWSE")
	s sc = $$InitSysOption2("ShowDeptNotReviewed", "Y", "病案室复核列表是否显示未通过科室复核的就诊", "BROWSE")
	s sc = $$InitSysOption2("ShowWaterMark", "N", "浏览时是否显示水印总开关，Y-开启，非Y-关闭", "BROWSE")
	s sc = $$InitSysOption2("ShowWaterMarkComponent", "QUEUEVIEW^QUERYVIEW^PRINT^EXPORT^ACTIVEXVIEW", "开启水印的控件，QUEUEVIEW-队列管理浏览，QUERYVIEW-简单、综合查询浏览，PRINT-打印，EXPORT-导出，ACTIVEXVIEW-控件浏览，以^分隔", "BROWSE")
	s sc = $$InitSysOption2("ToolStripItemSort", "PageNum^PageLabel^ZoomOut^ZoomIn^FitPage^FitWidth^ActualSize^Mod^Preview^RotateCC^RotateC^Next^Previous", "PDF浏览界面工具栏配置参数", "BROWSE")
	s sc = $$InitSysOption2("ReviewMode", "0", "病案复核模式，0-不分先后，1-先质控科后病案室，2-先病案室后质控科", "BROWSE")
	s sc = $$InitSysOption2("CatalogueFlag", "TreeList", "病案打印PDF浏览树形结构类型", "BROWSE")
	s sc = $$InitSysOption2("BrowseControlType", "pdfjs", "BS浏览控件类型(activex/pdfjs)", "BROWSE")
	s sc = $$InitSysOption2("RegPDFViewerPath", "http://0.0.0.0/imedical/web/addins/client/PDFViewer.cab#version=4,0,0", "PDF浏览注册地址", "BSBROWSE")
	
	//扫描
	s sc = $$InitSysOption2("ScanBtHeight", "110", "扫描按钮区高度", "scan")
	s sc = $$InitSysOption2("ScanPath", "d:\pdfcan", "扫描路径", "scan")
	s sc = $$InitSysOption2("WMRScanItemID", "20", "扫描标志接口", "scan")
	s sc = $$InitSysOption2("ScanOperatorBaseRoleID", "1", "扫描基角色ID", "scan")
	s sc = $$InitSysOption2("ScanButtonSize", "76^55^28^80^15", "BS扫描按钮参数(宽度、高度、水平间距、垂直间距、字号)", "scan")
	s sc = $$InitSysOption2("CardScanMRItemID", "", "证件扫描项目ID", "scan")
	s sc = $$InitSysOption2("NeedAddBox", "N", "装箱开关", "scan")
	s sc = $$InitSysOption2("NeedContinueScan","N","扫描前是否需要判断已扫描","scan")
	s sc = $$InitSysOption2("BSScannerDefaultPath","^","高拍仪路径^图片保存路径","scan")
	
	//打印
	s sc = $$InitSysOption2("WMRPrintItemID", "12", "打印标志接口", "print")
	s sc = $$InitSysOption2("PrintBasePrice", "0", "打印基础费", "print")
	s sc = $$InitSysOption2("PrintPrice", "0.5", "打印单价", "print")
	s sc = $$InitSysOption2("PrintMailPrice", "0", "打印病案邮寄费", "print")
	s sc = $$InitSysOption2("EnablePrintListMode", "N", "启用打印计费模式", "print")
	s sc = $$InitSysOption2("EnableScanID", "Y", "启用打印证件扫描", "print")
	s sc = $$InitSysOption2("PrintRelatedType", "NewBorn", "打印浏览关联类型，以'^'分隔，NewBorn-新生儿，OutPatient-门诊就诊", "print")
	s sc = $$InitSysOption2("RecipientInfo","","打印记录类型,默认是个人,换成RecipientInfoHYD变成机构","print")
	s sc = $$InitSysOption2("A5ToA4Print", "N", "打印时合并A5报告为A4格式", "print")
	
	//生成
	s sc = $$InitSysOption2("PDFCreateURLMM", "http://127.0.0.1/imedical/web/form.html?..", "归档病历生成免密链接", "create")   //病历生成免密链接，对dhc.epr.fs.pdfcreate.csp配免密链接，这个是必须配置的，因为所有的生成的csp，都不应该直接"q 1" 
	s sc = $$InitSysOption2("RISNameSpace", "RIS", "RIS名字空间", "create")
	s sc = $$InitSysOption2("ErrorRecreateMinPriority", "45", "重生成的最低优先级，低于此优先级不进行错误重生成，需人工手动处理", "create")
	s sc = $$InitSysOption2("CREATEPRIVACY01", "15", "隐私级别1", "create")
	s sc = $$InitSysOption2("CREATETEMPERATURE", "5", "补生成体温单", "create")
	s sc = $$InitSysOption2("CREATEORDER", "6", "补生成医嘱单", "create")
	s sc = $$InitSysOption2("CREATEAN", "7", "补生成手术麻醉单", "create")
	s sc = $$InitSysOption2("CREATENURSE", "8", "补生成护理记录", "create")
	s sc = $$InitSysOption2("CREATENURSEPF", "9", "补生成日常生活能力评分", "create")
	s sc = $$InitSysOption2("CREATEICU", "10", "补生成重症监护单", "create")
	s sc = $$InitSysOption2("CREATELIS", "11", "补生成检验", "create")
	s sc = $$InitSysOption2("CREATETOP", "12", "补生成病案首页", "create")
	s sc = $$InitSysOption2("CREATEPIS", "13", "病理专项生成", "create")
	s sc = $$InitSysOption2("NoNeedCheckAtUpload", "ME^PA^P1^P2^P3^P4^P5^P6^P7^L1^AA", "FTP上传时不需要检查是否有报告", "create")
	s sc = $$InitSysOption2("CompleteQueue", "N", "门急诊医生提交后延迟加入队列功能Y开启提交延迟加入队列功能，Y开启，N不开启", "create")
	s sc = $$InitSysOption2("AddEpisodeWhenAddQueue", "N", "在加入队列时就从his获取患者和就诊信息到归档库，Y开启，N不开启", "create")
	s sc = $$InitSysOption2("MREpisodeFPTypeCode", "DHC", "取诊断项目信息的途径", "create")
	s sc = $$InitSysOption2("AutoCompleteFirstTimeSpan", "1", "第一次自动生成提交的时间段", "create")
	s sc = $$InitSysOption2("AutoCompleteSecondTimeSpan", "3", "第二次自动生成提交的时间段", "create")
	s sc = $$InitSysOption2("CreateRelatedType", "NewBorn", "加入队列时关联生成类型，以'^'分隔，NewBorn-新生儿，OutPatient-门诊就诊", "create")
	s sc = $$InitSysOption2("OverwriteTimePoint", "PRINT", "生成时要保留归档历史版本的动作节点", "create")
	s sc = $$InitSysOption2("NoNeedClearAfterCreate", "CREATEIPBILLDAILY", "在生成成功后不需要删除多余项目的方案", "create")
	s sc = $$InitSysOption2("EnableNecessaryConditionConfirm", "N", "医生提交和护士提交之后是否检测必要条件提交，Y-检测，非Y-不检测", "create")
	s sc = $$InitSysOption2("PreferGetEMRPDF", "N", "是否优先获取PDF——电子病历", "create")
	
	s sc = $$InitSysOption2("IsCAEnterpriseDigitalSignOn", "N", "是否启用企业签章", "create")
	s sc = $$InitSysOption2("CAEnterpriseDigitalSignServerIP", "127.0.0.1", "企业签章服务IP", "create")
	s sc = $$InitSysOption2("CAEnterpriseDigitalSignServerPort", "80", "企业签章服务端口", "create")
	s sc = $$InitSysOption2("CAEnterpriseDigitalSignRuleNum", "", "企业签章规则", "create")
	
	//导出
	s sc = $$InitSysOption2("IsExportChild", "Y", "导出产妇病历时是否导出婴儿病历", "export")
	
InitSysOption2(argOptionName,argOptionValue,argOptionDesc,argOptionType)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc:	设置续打
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitAttachment()
ClassMethod InitAttachment()
{
	s attachItemRowID = 11
	s attachItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(attachItemRowID)
	s attachItem.Attachment = "0"
	d attachItem.%Save()
	d attachItem.%Close()
	
	s ItemRowID = 12
	s Item = ##Class(DHCEPRFS.META.MRItem).%OpenId(ItemRowID)
	s attachment = Item.Attachment
	if (attachment = "")
	{
		s Item.Attachment = attachItemRowID
	}
	elseif (attachment = "0")
	{
		w "error"
	}
	elseif (attachment[attachItemRowID)
	{
		// do nothing
	}
	else
	{
		s Item.Attachment = attachment_"^"_attachItemRowID	
	}
	d Item.%Save()
	d Item.%Close()
}

/// Desc:	初始化归档项目-接口对照表
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitCTItemType()
ClassMethod InitCTItemType()
{
	s sc = $$InitCTItemType("01", "检查报告", "检查报告", "", "1","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvPACS.cls?wsdl","DHCCPACS","GetFTPPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","PACS","Common1")
	s sc = $$InitCTItemType("01A", "检查报告PACS", "检查报告-放射", "", "1","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvPACS.cls?wsdl","DHCCPACS","GetPACSFTPPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","PACS","Common1")
	s sc = $$InitCTItemType("01B", "检查报告US", "检查报告-超声", "", "1","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvPACS.cls?wsdl","DHCCPACS","GetUSFTPPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","PACS","Common1")
	s sc = $$InitCTItemType("01C", "检查报告ES", "检查报告-内镜", "", "1","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvPACS.cls?wsdl","DHCCPACS","GetESFTPPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","PACS","Common1")
	s sc = $$InitCTItemType("02", "检验报告", "检验报告", "", "2","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvLIS.cls?wsdl","DHCCLIS","GetLISPDFPath","","","","CREATETYPEFTP","东华软件","检验组","Common2")
	s sc = $$InitCTItemType("04", "体温单", "体温单", "http://127.0.0.1/imedical/web/form.htm?TPSID=10026&AES7UserCode=1&USERNAME=demo&EpisodeID=<EPISODEID>", "4","","","","","","","CREATETYPEFTP","东华软件","护理组","WB")
	//s sc = $$InitCTItemType("05", "住院证", "住院证", "DHCDocIPBookNew.Print.csp", "5","","","","","","","CREATETYPECSP","东华软件","医生站","")
	s sc = $$InitCTItemType("05", "住院证", "住院证", "http://127.0.0.1/imedical/web/form.htm?TPSID=10026&AES7UserCode=1&USERNAME=demo&EpisodeID=<EPISODEID>", "5","","","","","","","CREATETYPEFTP","东华软件","医生站","WB")
	s sc = $$InitCTItemType("06", "护理病历", "护理病历", "DHCNurseIPhulibingliCOMM.FS.csp", "6","","","","","","","CREATETYPECSP","东华软件","护理组","")
	s sc = $$InitCTItemType("06A", "护理病历", "护理病历（新版）", "DHCNurMpIPhulibingliCOMM.csp", "6","","","","","","","CREATETYPECSP","东华软件","护理组","")
	s sc = $$InitCTItemType("06B", "护理病历", "护理病历（新版）", "DHCNurMpIPhulibingliCOMM.csp", "6","","","","","","","CREATETYPECSP","东华软件","护理组","")
	s sc = $$InitCTItemType("07", "病历文书", "病历文书", "dhc.epr.centralizedprintepr.csp", "7","","","","","","","CREATETYPEEPR2","东华软件","电子病历组","")
	s sc = $$InitCTItemType("08", "麻醉记录", "麻醉记录", "", "8","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetANPDFPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("09", "病理报告", "病理报告", "", "9","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvPIS.cls?wsdl","DHCCPIS","GetFTPPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","病理组","Common1")
	s sc = $$InitCTItemType("10", "心电图", "心电图", "", "10","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvEKG.cls?wsdl","DHCCEKG","GetFTPPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","心电组","Common1")
	//s sc = $$InitCTItemType("11", "费用清单", "费用清单", "", "11","","","","","","","CREATETYPECSP","东华软件","计费组","")
	s sc = $$InitCTItemType("11", "费用清单", "费用清单", "https://127.0.0.1:28080/runqianReport159/report/jsp/directprintlocal.jsp?report={DHCBILL-IPBILL-FYQD.rpx(billId=;stDate=;endDate=;episodeId=<EPISODEID>;otherQryStr=!0)}", "11","","","","","","","CREATETYPEFTP","东华软件","计费组","WB")
	s sc = $$InitCTItemType("12", "临床路径", "临床路径", "dhcma.cpw.cp.printformtoemr.csp", "12","","","","","","","CREATETYPECSP","东华软件","医政组","")
	//s sc = $$InitCTItemType("13", "输血申请单", "输血申请单(检验)", "dhclabprintappbloodemr.csp", "13","","","","","","","CREATETYPECSP","东华软件","检验组","")
	s sc = $$InitCTItemType("13", "发血申请单", "输血申请单(检验)", "", "13","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvLIS.cls?wsdl","DHCCLIS","GetBLDApplyPDFPath","","","","CREATETYPEFTP","东华软件","检验组","Common2")
	s sc = $$InitCTItemType("14", "会诊记录", "会诊记录", "DHCNurseIPhulibingliCOMMConsult.csp", "14","","","","","","","CREATETYPECSP","东华软件","护理组","")
	s sc = $$InitCTItemType("15", "手术清点单", "手术清点单", "", "15","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetOperCountPath","127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	//s sc = $$InitCTItemType("16", "产程图", "产程图", "DHCNurseBirthCOMMJZ.FS.csp", "16","","","","","","","CREATETYPECSP","东华软件","护理组","")
	s sc = $$InitCTItemType("16", "产程图", "产程图", "https://127.0.0.1/imedical/web/form.htm?TPSID=10029&AES7UserCode=1&USERNAME=demo&EpisodeID=<EPISODEID>", "16","","","","","","","CREATETYPEFTP","东华软件","护理组","WB")
	s sc = $$InitCTItemType("17", "产时记录", "产时记录", "https://127.0.0.1/imedical/web/form.htm?TPSID=10030&AES7UserCode=1&USERNAME=demo&EpisodeID=<EPISODEID>", "16","","","","","","","CREATETYPEFTP","东华软件","护理组","WB")
	s sc = $$InitCTItemType("18", "重症监护单", "重症监护护理单", "", "18","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetICUPath","127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("19", "高值耗材", "高值耗材", "", "19","","","","","","","CREATETYPECSP","东华软件","药房药库","")
	s sc = $$InitCTItemType("23", "输血记录单", "输血单", "", "23","","","","","","","CREATETYPECSP","东华软件","检验组","")
	s sc = $$InitCTItemType("24", "术前访视", "术前访视", "", "24","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetPREPDFPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("25", "术后访视", "术后访视", "", "25","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetPOSTPDFPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("28", "手术安全核查", "手术安全核查", "", "28","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetOPSPDFPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("29", "麻醉前访视", "麻醉前访视", "", "29","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetPrevVisitPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("30", "CHA手术风险评估", "CHA手术风险评估", "", "30","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetCHARecordPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	//s sc = $$InitCTItemType("31", "长期医嘱", "长期医嘱", "DHCNurseIPCommOrdPrintJZCQ.FS.csp", "31","","","","","","","CREATETYPECSP","东华软件","护理组","")
	//s sc = $$InitCTItemType("32", "临时医嘱", "临时医嘱", "DHCNurseIPCommOrdPrintJZLS.FS.csp", "32","","","","","","","CREATETYPECSP","东华软件","护理组","")
	s sc = $$InitCTItemType("31", "长期医嘱", "长期医嘱", "http://127.0.0.1/imedical/web/form.htm?TPSID=10027&AES7UserCode=1&USERNAME=demo&EpisodeID=<EPISODEID>", "31","","","","","","","CREATETYPEFTP","东华软件","护理组","WB")
	s sc = $$InitCTItemType("32", "临时医嘱", "临时医嘱", "http://127.0.0.1/imedical/web/form.htm?TPSID=10028&AES7UserCode=1&USERNAME=demo&EpisodeID=<EPISODEID>", "32","","","","","","","CREATETYPEFTP","东华软件","护理组","WB")
	s sc = $$InitCTItemType("34", "处方", "处方", "pha.op.v4.prescprint.csp", "33","","","","","","","CREATETYPECSP","东华软件","护理组","")
	s sc = $$InitCTItemType("36", "住院病案首页(编目)", "住院病案首页(编目)", "emr.interface.print.fs.csp", "36","","","","","","","CREATETYPEEMR3FP","东华软件","电子病历","")
	s sc = $$InitCTItemType("51", "会诊记录", "会诊记录（新）", "dhcem.printconinterface.csp", "14","","","","","","","CREATETYPECSP","东华软件","新产品组","")
	s sc = $$InitCTItemType("53", "发血单", "输血申请单(检验)", "", "53","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvLIS.cls?wsdl","DHCCLIS","GetBLDPDFPath","","","","CREATETYPEFTP","东华软件","检验组","Common2")
	s sc = $$InitCTItemType("55", "麻醉后访视", "麻醉后访视", "", "55","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetPostVisitPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("71", "电子病历（第三版）", "电子病历（第三版）", "", "71","","","","","","","CREATETYPEEMR3","东华软件","电子病历","")
	s sc = $$InitCTItemType("81", "恢复式记录单", "恢复式记录单", "", "81","http://127.0.0.1/imedical/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetPACUPath","edtftp^127.0.0.1^21^Anonymous^^5","","","CREATETYPEFTP","东华软件","临床组","Common1")
	s sc = $$InitCTItemType("PA", "检查报告", "检查报告", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("P1", "超声", "超声", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("P2", "放射", "放射", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("P3", "核医学", "核医学", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("P4", "内镜", "内镜", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("P5", "核磁", "核磁", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("P6", "病理", "病理", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("P7", "心电", "心电", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("L1", "检验报告", "检验报告", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	s sc = $$InitCTItemType("AA", "手麻系统报告", "手麻系统报告", "", "82","","","","","","","CREATETYPEFTP","","第三方","Common2")
	
InitCTItemType(argTypeCode, argTypeName, argTypeDesc, argCSPPath, argSequence,typeURL,typeClass,typeMethod,typeFTPConfig,typeNote,typeFlag,createType,company,productTeam,createTypeSub)
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.CTItemType
		where TypeCode = :argTypeCode)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.CTItemType (TypeCode,TypeName,TypeDesc,CSPPath,Sequence,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,TypeNote,TypeFlag,CreateType,Company,ProductTeam,CreateTypeSub) values (:argTypeCode, :argTypeName, :argTypeDesc,:argCSPPath, :argSequence,:typeURL,:typeClass,:typeMethod,:typeFTPConfig,:typeNote,:typeFlag,:createType,:company,:productTeam,:createTypeSub))
	}
	else
	{
		&sql(update DHCEPRFS_META.CTItemType set TypeCode = :argTypeCode,TypeName=:argTypeName,TypeDesc=:argTypeDesc,CSPPath=:argCSPPath,Sequence=:argSequence,TypeURL=:typeURL,TypeClass=:typeClass,TypeMethod=:typeMethod ,TypeFTPConfig=:typeFTPConfig ,TypeNote=:typeNote,TypeFlag=:typeFlag,CreateType=:createType,Company=:company,ProductTeam=:productTeam,CreateTypeSub=:createTypeSub where ID = :rowid)
	}
	
	q "1"
}

/// Desc:	初始化归档项目调用类型
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitCTItemInvokeType()
ClassMethod InitCTItemInvokeType()
{
	s sc = $$InitCTItemInvokeType("CREATETYPECSP", "CSP")
	s sc = $$InitCTItemInvokeType("CREATETYPEEXE", "EXE")
	s sc = $$InitCTItemInvokeType("CREATETYPEFTP", "FTP")
	s sc = $$InitCTItemInvokeType("CREATETYPEPLATFORMFTP", "PLATFORMFTP")
	s sc = $$InitCTItemInvokeType("CREATETYPEEMR3", "EMR3")
	s sc = $$InitCTItemInvokeType("CREATETYPEEPR2", "EPR2")
	
	
InitCTItemInvokeType(invokeTypeCode, invokeTypeName)
	s rowid =""
	&sql(select ID into :rowid from DHCEPRFS_META.CTItemInvokeType where InvokeTypeCode = :invokeTypeCode)
	if (rowid ="")
	{
		&sql(insert into DHCEPRFS_META.CTItemInvokeType (InvokeTypeCode,InvokeTypeName) values (:invokeTypeCode, :invokeTypeName))
	}
	q "1"
}

/// Desc:	设置QR码备选项
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitQRCodeInfo()
ClassMethod InitQRCodeInfo()
{
	d ..InitQRCodeInfoBase("DHCEPRFS.INST.MREpisode")
	d ..InitQRCodeInfoBase("DHCEPRFS.INST.MRPatient")
	d ..InitQRCodeInfoBase("DHCEPRFS.META.MRItem")
	s sequence = $O(^DHCEPRFS.META.QRCodeInfoI("IdxSequence",""),-1)
	if ((sequence = "") || (sequence < 1))
	{
		s sequence = 1	
	}
	s objNew = ##Class(DHCEPRFS.META.QRCodeInfo).%New()
	s objNew.Name = "FileLocalPath"
	s objNew.Description = "文件的本地路径"
	s objNew.ClassName = "FilePath"
	s objNew.ClassProperty = "FileLocalPath"
	s objNew.ClassPropertyType = "FileLocalPath"
	s objNew.Enable = "FALSE"
	s objNew.Sequence = sequence
	w objNew.Name_" "_objNew.Description_" "_objNew.ClassName_" "_objNew.ClassProperty_" "_objNew.ClassPropertyType_" "_objNew.Description_" "_objNew.Enable_" "_objNew.Sequence,!
	s sequence = sequence + 1
	s sc = objNew.%Save()
	s objNew = ##Class(DHCEPRFS.META.QRCodeInfo).%New()
	s objNew.Name = "FileMasterPath"
	s objNew.Description = "文件的逻辑路径"
	s objNew.ClassName = "FilePath"
	s objNew.ClassProperty = "FileMasterPath"
	s objNew.ClassPropertyType = "FileMasterPath"
	s objNew.Enable = "FALSE"
	s objNew.Sequence = sequence
	w objNew.Name_" "_objNew.Description_" "_objNew.ClassName_" "_objNew.ClassProperty_" "_objNew.ClassPropertyType_" "_objNew.Description_" "_objNew.Enable_" "_objNew.Sequence,!
	s sequence = sequence + 1
	s sc = objNew.%Save()
	s objNew = ##Class(DHCEPRFS.META.QRCodeInfo).%New()
	s objNew.Name = "CustemNote"
	s objNew.Description = "用户自定义信息"
	s objNew.ClassName = "CustemNote"
	s objNew.ClassProperty = "CustemNote"
	s objNew.ClassPropertyType = "CustemNote"
	s objNew.Enable = "FALSE"
	s objNew.Sequence = sequence
	w objNew.Name_" "_objNew.Description_" "_objNew.ClassName_" "_objNew.ClassProperty_" "_objNew.ClassPropertyType_" "_objNew.Description_" "_objNew.Enable_" "_objNew.Sequence,!
	s sequence = sequence + 1
	s sc = objNew.%Save()
}

ClassMethod InitQRCodeInfoBase(AClassName As %String)
{
	//取当前最大Sequence
	s sequence = $O(^DHCEPRFS.META.QRCodeInfoI("IdxSequence",""),-1)
	if ((sequence = "") || (sequence < 1))
	{
		s sequence = 1	
	}
	
	s className = AClassName
	s obj = ##Class(%Dictionary.CompiledClass).%OpenId(className)
	if (obj = "")
	{
		q ""
	}

	s count = obj.Properties.Count()
	for i=1:1:count
	{
		s pdef = obj.Properties.GetAt(i)
		if ($f(pdef.Name,"%") <= 0)
		{
			s objNew = ##Class(DHCEPRFS.META.QRCodeInfo).%New()
			s objNew.Name = pdef.Name
			s description = $p(pdef.Description," ",2)
			if ((description = "") || ($f(pdef.Description," ")<0))
			{ 
				s description = $p(pdef.Description," ",1)
			}
			if ($f(pdef.Description, "(")>0)
			{
				s description = $p(pdef.Description,"(",1)	
			}
			s objNew.Description = description
			s objNew.ClassName = className
			s objNew.ClassProperty = pdef.Name
			s objNew.ClassPropertyType = $p(pdef.Type,".",2)
			s objNew.Enable = "FALSE"
			s objNew.Sequence = sequence
			w objNew.Name_" "_objNew.Description_" "_objNew.ClassName_" "_objNew.ClassProperty_" "_objNew.ClassPropertyType_" "_objNew.Description_" "_objNew.Enable_" "_objNew.Sequence,!
			s sequence = sequence + 1
			s sc = objNew.%Save()
			continue:($$$ISOK(sc))
			q
		}
	}
}

/// Desc:	设置归档合并项目关联关系
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitItemCorrelation()
ClassMethod InitItemCorrelation()
{
	s sc = $$InitItemCorrelation("60", "6", "SCAN")
	s sc = $$InitItemCorrelation("60", "12", "SCAN")
	s sc = $$InitItemCorrelation("60", "13", "SCAN")
	s sc = $$InitItemCorrelation("60", "14", "SCAN")
	s sc = $$InitItemCorrelation("60", "15", "SCAN")
	s sc = $$InitItemCorrelation("60", "16", "SCAN")
	s sc = $$InitItemCorrelation("60", "17", "SCAN")
	s sc = $$InitItemCorrelation("60", "18", "SCAN")
	s sc = $$InitItemCorrelation("60", "19", "SCAN")
	s sc = $$InitItemCorrelation("60", "20", "SCAN")
	s sc = $$InitItemCorrelation("60", "21", "SCAN")
	s sc = $$InitItemCorrelation("60", "22", "SCAN")
	s sc = $$InitItemCorrelation("61", "48", "SCAN")
	s sc = $$InitItemCorrelation("61", "49", "SCAN")
	s sc = $$InitItemCorrelation("61", "50", "SCAN")
	s sc = $$InitItemCorrelation("61", "51", "SCAN")
	s sc = $$InitItemCorrelation("61", "52", "SCAN")
	s sc = $$InitItemCorrelation("61", "54", "SCAN")
	s sc = $$InitItemCorrelation("61", "55", "SCAN")
	s sc = $$InitItemCorrelation("61", "56", "SCAN")
	s sc = $$InitItemCorrelation("61", "57", "SCAN")
	s sc = $$InitItemCorrelation("62", "40", "SCAN")
	s sc = $$InitItemCorrelation("62", "41", "SCAN")
	s sc = $$InitItemCorrelation("62", "42", "SCAN")
	s sc = $$InitItemCorrelation("62", "43", "SCAN")
	s sc = $$InitItemCorrelation("62", "44", "SCAN")
	s sc = $$InitItemCorrelation("62", "45", "SCAN")
	s sc = $$InitItemCorrelation("62", "46", "SCAN")
	s sc = $$InitItemCorrelation("64", "53", "SCAN")
	s sc = $$InitItemCorrelation("66", "72", "SCAN")
	s sc = $$InitItemCorrelation("67", "73", "SCAN")	
	
	
InitItemCorrelation(argMritemid,argReleatedmritemid,argType)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ItemCorrelation
		where MRItemID = :argMritemid and ReleatedMRItemID = :argReleatedmritemid)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ItemCorrelation (MRItemID, ReleatedMRItemID, Type) 
			values (:argMritemid, :argReleatedmritemid, :argType))
	}
	
	q "1"
}

/// Desc:	设置归档合并项目（打印）
/// Debug: 	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitPrintItemCorrelation()
ClassMethod InitPrintItemCorrelation()
{
	//打印使用，若某个项目没有扫描件则打印生产件，即扫描件和生产件关联，当打印方案中存在此扫描件，则需要判断扫描件和生成件的存在情况
	//1.扫描件存在，则正常加载所有项目
	//2.扫描件不存在，生成件存在，则加载生成件
	//3.扫描件和生成件都不存在，则都不加载
	&sql(insert into DHCEPRFS_META.PrintItemCorrelation (mritemid,releatedmritemid,type) values ('67','73', 'PRINT'))
	w !,SQLCODE
}

/// Desc:	初始化归档动作表
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitMRAction()
ClassMethod InitMRAction()
{
	s sc = $$InitOneMRAct("CONFIRM","病历确认","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("OLDCONFIRM","老病历确认","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("CREATE","病历生成","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("OLDCREATE","老病历生成","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("REVIEW","病案复核","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("CATALOG","病案编目","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("SCAN","病历扫描","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("CONFIRMSCAN","确认扫描","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("SCANDELETE","删除扫描","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("ARRANGE","扫描分类","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("PRINT","病历打印","1","USE","病案使用")
	s sc = $$InitOneMRAct("QCBACK","质控退回","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("REPLACE","病历替换","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("DEPTQCBACK","科室审核退回","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("DEPTREVIEW","科室审核通过","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("NURCONFIRM","护士结算","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("DOCCONFIRM","医生确认","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("EXPORT","病历导出","1","USE","病案使用")
	s sc = $$InitOneMRAct("RETRIEVEOK","科室回收成功","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("RETRIEVEERROR","科室回收失败","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("DELAYCREATE","迟归生成","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("REGISTER","注册就诊","1","PROCESS","病案处理")
	
InitOneMRAct(argActionCode,argActionName,argIsActive,argCategoryCode,argCategoryName)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.MRAction
		where ActionCode = :argActionCode)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.MRAction (ActionCode, ActionName, IsActive, CategoryCode, CategoryName) 
			values (:argActionCode, :argActionName, :argIsActive, :argCategoryCode, :argCategoryName))
	}
	else
	{
		&sql(update DHCEPRFS_META.MRAction set ActionCode = :argActionCode, ActionName = :argActionName, IsActive = :argIsActive, CategoryCode = :argCategoryCode, CategoryName= :argCategoryName 
		where id = :rowid)
	}
	
	q "1"
}

/// Desc:	初始化归档状态过渡表
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitTransiton()
ClassMethod InitTransiton()
{
	s sc = $$InitOneMRTrans("INITIALIZED", "CONFIRM", "CONFIRMED", "1")
	s sc = $$InitOneMRTrans("INITIALIZED", "CREATE", "CREATED", "1")
	s sc = $$InitOneMRTrans("INITIALIZED", "OLDCONFIRM", "OLDCONFIRMED", "1")
	s sc = $$InitOneMRTrans("CONFIRMED", "CREATE", "CREATED", "1")
	s sc = $$InitOneMRTrans("CONFIRMED", "QCBACK", "INITIALIZED", "1")
	s sc = $$InitOneMRTrans("CREATED", "REVIEW", "REVIEWED", "1")
	s sc = $$InitOneMRTrans("CREATED", "CATALOG", "CATALOGED", "1")
	s sc = $$InitOneMRTrans("CREATED", "SCAN", "SCANNED", "1")
	s sc = $$InitOneMRTrans("CREATED", "QCBACK", "INITIALIZED", "1")
	s sc = $$InitOneMRTrans("REVIEWED", "CATALOG", "CATALOGED", "1")
	s sc = $$InitOneMRTrans("REVIEWED", "SCAN", "SCANNED", "1")
	s sc = $$InitOneMRTrans("REVIEWED", "CONFIRMSCAN", "REPLACED", "1")
	s sc = $$InitOneMRTrans("REVIEWED", "QCBACK", "INITIALIZED", "1")
	s sc = $$InitOneMRTrans("CATALOGED", "SCAN", "SCANNED", "1")
	s sc = $$InitOneMRTrans("CATALOGED", "CONFIRMSCAN", "REPLACED", "1")
	s sc = $$InitOneMRTrans("CATALOGED", "QCBACK", "INITIALIZED", "1")
	s sc = $$InitOneMRTrans("SCANNED", "ARRANGE", "ARRANGED", "1")
	s sc = $$InitOneMRTrans("ARRANGED", "PRINT", "ARRANGED", "1")
	s sc = $$InitOneMRTrans("ARRANGED", "SCAN", "SCANNED", "1")
	s sc = $$InitOneMRTrans("ARRANGED", "REPLACE", "REPLACED", "1")
	s sc = $$InitOneMRTrans("SCANNED", "SCANDELETE", "CREATED", "1")
	s sc = $$InitOneMRTrans("ARRANGED", "SCANDELETE", "CREATED", "1")
	s sc = $$InitOneMRTrans("OLDCONFIRMED", "OLDCREATE", "REPLACED", "1")
	s sc = $$InitOneMRTrans("CREATED", "DEPTQCBACK", "INITIALIZED", "1")
	s sc = $$InitOneMRTrans("CREATED", "DEPTREVIEW", "DEPTREVIEWED", "1")
	s sc = $$InitOneMRTrans("ARRANGED", "QCBACK", "INITIALIZED", "1")
	s sc = $$InitOneMRTrans("INITIALIZED", "REGISTER", "REGISTERED", "1")
	s sc = $$InitOneMRTrans("REGISTERED", "SCAN", "SCANNED", "1")
	
InitOneMRTrans(argPrevStatus, argActionCode, argPostStatus, argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.MRTransition
		where PrevStatusCode = :argPrevStatus and ActionCode = :argActionCode)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.MRTransition (PrevStatusCode, ActionCode, PostStatusCode, IsActive) 
			values (:argPrevStatus, :argActionCode, :argPostStatus, :argIsActive))
	}
	
	q "1"
}

/// Desc:	初始化权限功能列表
/// Debug: 	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InsertQueryFunction()
ClassMethod InsertQueryFunction()
{
	s sc = $$InsertQueryFunction("Menu_Query", "查询", "","0")
	s sc = $$InsertQueryFunction("Menu_Query_Simple", "简单查询", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_Complex", "综合查询", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_MRMedRecordQuery", "病案查询", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_Btn_Column", "结果列设置", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_Btn_ExportResult", "导出查询结果", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_Btn_ExportRecord", "导出病历", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_Btn_Query", "查询", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_TSMI_OPEN", "查看病历内容", "","Menu_Query")
	s sc = $$InsertQueryFunction("Menu_Query_TSMI_EXPORT", "导出病历", "","Menu_Query")
	
	s sc = $$InsertQueryFunction("Menu_Set", "设置", "","0")
	s sc = $$InsertQueryFunction("Menu_Set_Role", "角色设置", "","Menu_Set")
	s sc = $$InsertQueryFunction("Menu_Set_User", "用户设置", "","Menu_Set")
	
	s sc = $$InsertQueryFunction("Menu_Enable", "启用菜单", "","0")
	//配置管理
	s sc = $$InsertQueryFunction("Menu_Enable_ConfigScheme", "方案管理", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_ConfigQRCode", "二维码管理", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_MaintainUser", "用户管理", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_MaintainRole", "角色管理", "","Menu_Enable")
	//s sc = $$InsertQueryFunction("Menu_Enable_ConfigMetaTable", "基础数据维护", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_InputHistoryMedRecord", "历史病案录入", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_AdvancedSecurity", "特殊病历维护", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_SealUp", "病历封存", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_MetaLifeCycleManage", "基础数据生命周期维护", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_BSAuthorization", "借阅审批", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_SetWatermark", "水印设置", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_CTItemTypeMaintain", "归档项目生成方式维护", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_LocalConfig", "本地配置", "","Menu_Enable")
	//病案生成
	s sc = $$InsertQueryFunction("Menu_Enable_PDFCreateQueue", "生成队列管理", "","Menu_Enable")
	//s sc = $$InsertQueryFunction("Menu_Enable_PDFCreateCheck", "生成项检查", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_PDFFileCheck", "归档病历校验", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_FrmAdmMRStatusSet", "病历状态设置", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_MRStatusQuery", "出院病历状态查询", "","Menu_Enable")
	//病案扫描
	s sc = $$InsertQueryFunction("Menu_Enable_RecordScan", "病案扫描", "","Menu_Enable")
	//s sc = $$InsertQueryFunction("Menu_Enable_HDCFileUpload", "高拍仪扫描", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_ScanLogQuery", "扫描记录查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_CheckScanLogQuery", "复核扫描记录查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_BoxMaintain", "箱维护", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_BoxEpisodeSearch", "箱病案就诊查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_MedRecordSummary", "病案扫描汇总查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_ScanWorkload", "操作员扫描工作量查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_DisLocScanItems", "科室扫描明细查询", "","Menu_Enable")
	//病案打印
	s sc = $$InsertQueryFunction("Menu_Enable_PdfArchivePrint", "病案打印", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_PrintLogQuery", "打印记录查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_QueryPrintPagesByMRItem", "归档类型打印查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_ScanIDLogQuery", "扫描证件日志查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_QueryWorkLoadByScheme", "按打印方案工作量查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_QueryPrintChargeByUser", "操作员打印收费查询", "","Menu_Enable")	
	s sc = $$InsertQueryFunction("Menu_Enable_QueryUnChargePrintQuery", "未收费打印记录查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_ReceiptPrintConfig", "打印收据设计", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_PrintListCharge", "病案打印缴费", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_PrintListPrint", "病案打印执行", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_PrintListDailyFoot", "病案打印计费结算查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_PrintTotalFromLog", "打印日志工作量查询", "","Menu_Enable")
	//病案查询	
	s sc = $$InsertQueryFunction("Menu_Enable_MRMedTrackInfo", "病案示踪查询", "","Menu_Enable")	
	s sc = $$InsertQueryFunction("Menu_Enable_ViewLogQuery", "浏览查询", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_QueryExportLog", "病案导出日志", "","Menu_Enable")
	//状态统计	
	s sc = $$InsertQueryFunction("Menu_Enable_DiskStatus", "服务器存储统计", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_ServerStatus", "服务器状态查看", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_Error3rdCreateLog", "第三方生成接口错误监控", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_LocalLogMonitor", "本机日志监控", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_LocalSystemMonitor", "本机系统监控", "","Menu_Enable")
	//报表
	s sc = $$InsertQueryFunction("Menu_Enable_Report_Print", "操作者打印工作量报表", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_Report_Receipt", "逾期签收统计报表", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_Report_QCBack", "质控退回统计报表", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_Report_MRArchiveLate", "归档迟交统计报表", "","Menu_Enable")
	//工具
	s sc = $$InsertQueryFunction("Menu_Enable_WebServiceStudio", "WebService测试工具", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_PDFTool", "PDF工具", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_FTPClient", "FTP客户端工具", "","Menu_Enable")
	s sc = $$InsertQueryFunction("Menu_Enable_ImageProcess", "图像处理工具", "","Menu_Enable")	
	s sc = $$InsertQueryFunction("Menu_Enable_CreateTest", "生成测试", "","Menu_Enable")	
	
	s sc = $$InsertQueryFunction("Menu_Operation", "操作", "","0")
	s sc = $$InsertQueryFunction("Menu_Operation_Recreate", "可重新生成", "","Menu_Operation")
	s sc = $$InsertQueryFunction("Menu_Operation_RecreateGreenChannel", "可使用绿色通道生成", "","Menu_Operation")
	s sc = $$InsertQueryFunction("Menu_Operation_OldCreate", "可老病历生成", "","Menu_Operation")
	s sc = $$InsertQueryFunction("Menu_Operation_WorkFlowManage", "病案流程干预", "","Menu_Operation")
	s sc = $$InsertQueryFunction("Menu_Operation_FrmAdmMRStatusFinish", "病历状态完成", "","Menu_Operation")
	s sc = $$InsertQueryFunction("Menu_Operation_FrmAdmMRStatusBack", "病历状态退回", "","Menu_Operation")
	s sc = $$InsertQueryFunction("Menu_Operation_Create", "队列查看可直接生成", "","Menu_Operation")
	s sc = $$InsertQueryFunction("Scan_Operation_Arrange", "扫描分类权限", "","0")
		
	s sc = $$InsertQueryFunction("Menu_Enable_Scan", "扫描权限", "","0")
	s sc = $$InsertQueryFunction("Menu_Enable_Scan_ScanPatient", "就诊列表", "","Menu_Enable_Scan")
	s sc = $$InsertQueryFunction("Menu_Enable_Scan_NoScanPatient", "待扫描", "","Menu_Enable_Scan")
	s sc = $$InsertQueryFunction("Menu_Enable_Scan_NoSortPatientByOne", "个人待分类", "","Menu_Enable_Scan")
	s sc = $$InsertQueryFunction("Menu_Enable_Scan_NoSortPatientByAll", "全部待分类", "","Menu_Enable_Scan")
	s sc = $$InsertQueryFunction("Menu_Enable_Scan_NoMergePatient", "待替换", "","Menu_Enable_Scan")
	s sc = $$InsertQueryFunction("Menu_Enable_Scan_ConfirmScanPatient", "待确认扫描", "","Menu_Enable_Scan")

InsertQueryFunction(argFuncName,argFuncDesc,argNotes,argParentName)
	s parentID = "0"
	if (argParentName '= "0")
	{
		s parentID = ""
		&sql(select ID into :parentID from DHCEPRFS_META.QueryFunction
		where FuncName = :argParentName)
	}
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFunction
		where FuncName = :argFuncName)
		
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) 
			values (:argFuncName, :argFuncDesc, :parentID, :argNotes))
	}
	
	q "1"
}

/// Desc:	初始化综合查询中查询类别
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InsertQueryCategory() 
ClassMethod InsertQueryCategory()
{
	s sc = $$InsertQueryCategory("PatBaseInfo", "患者基本信息", "1","Y")
	s sc = $$InsertQueryCategory("PatAdmInfo", "患者就诊信息", "2","Y")
	s sc = $$InsertQueryCategory("PatOperInfo", "诊断手术信息", "3","Y")
	s sc = $$InsertQueryCategory("PatOtherInfo", "患者其他信息", "4","Y")	
	s sc = $$InsertQueryCategory("MedRecordFlowInfo", "病案流通信息", "5","Y")	
InsertQueryCategory(argCategoryName,argCategoryDesc,argSequence,argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName and CategoryDesc = :argCategoryDesc)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryCategory (CategoryName,CategoryDesc,Sequence,IsActive) 
			values (:argCategoryName, :argCategoryDesc, :argSequence, :argIsActive))
	}
	
	q "1"
}

/// Desc:	初始化综合查询中查询条件
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InsertQueryField() 
ClassMethod InsertQueryField()
{
	s sc = $$InitOneQueryField("RegNo", "登记号", "TXT", "", "PatBaseInfo", "1", "Y")
	s sc = $$InitOneQueryField("Name", "姓名", "TXT", "", "PatBaseInfo", "2", "Y")
	s sc = $$InitOneQueryField("Gender", "性别", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|Gender", "PatBaseInfo", "3", "Y")
	s sc = $$InitOneQueryField("Birthday", "生日", "DATE", "", "PatBaseInfo", "4", "Y")
	s sc = $$InitOneQueryField("EpisodeID", "就诊号", "TXT", "", "PatAdmInfo", "5", "Y")
	s sc = $$InitOneQueryField("MedRecordNo", "病案号", "TXT", "", "PatAdmInfo", "6", "Y")
	s sc = $$InitOneQueryField("Age", "年龄", "TXT", "", "PatBaseInfo", "7", "Y")
	s sc = $$InitOneQueryField("IDCard", "身份证号", "TXT", "", "PatBaseInfo", "8", "Y")
	s sc = $$InitOneQueryField("AdmLoc", "入院科室", "TXT", "", "PatAdmInfo", "9", "Y")
	s sc = $$InitOneQueryField("DisLoc", "出院科室", "TXT", "", "PatAdmInfo", "10", "Y")
	s sc = $$InitOneQueryField("AdmNum", "就诊总次数", "TXT", "", "PatAdmInfo", "11", "Y")
	s sc = $$InitOneQueryField("InNum", "入院总次数", "TXT", "", "PatAdmInfo", "12", "Y")
	s sc = $$InitOneQueryField("AdmDate", "就诊日期", "DATE", "", "PatAdmInfo", "13", "Y")
	s sc = $$InitOneQueryField("AdmTime", "就诊时间", "DATE", "", "PatAdmInfo", "14", "Y")
	s sc = $$InitOneQueryField("DisDate", "出院日期", "DATE", "", "PatAdmInfo", "15", "Y")
	s sc = $$InitOneQueryField("HospitalDays", "住院天数", "TXT", "", "PatAdmInfo", "16", "Y")
	s sc = $$InitOneQueryField("DisTime", "出院时间", "DATE", "", "PatAdmInfo", "17", "Y")
	s sc = $$InitOneQueryField("DeathDate", "死亡日期", "DATE", "", "PatAdmInfo", "18", "Y")
	s sc = $$InitOneQueryField("DeathTime", "死亡时间", "DATE", "", "PatAdmInfo", "19", "Y")
	s sc = $$InitOneQueryField("AdmWard", "入院病区", "TXT", "", "PatAdmInfo", "20", "Y")
	s sc = $$InitOneQueryField("DisWard", "出院病区", "TXT", "", "PatAdmInfo", "21", "Y")
	s sc = $$InitOneQueryField("MainDoctor", "主管医生", "TXT", "", "PatAdmInfo", "22", "Y")
	s sc = $$InitOneQueryField("TransDept", "转科科别", "TXT", "", "PatAdmInfo", "23", "Y")
	s sc = $$InitOneQueryField("PayMode", "付费方式", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|PayMode", "PatBaseInfo", "24", "Y")
	s sc = $$InitOneQueryField("AllPay", "总费用", "TXT", "", "PatOtherInfo", "25", "Y")
	s sc = $$InitOneQueryField("LocManager", "科主任", "TXT", "", "PatAdmInfo", "26", "Y")
	s sc = $$InitOneQueryField("SeniorDoc", "主任(副)医师", "TXT", "", "PatAdmInfo", "27", "Y")
	s sc = $$InitOneQueryField("InHospitlDoc", "住院医师", "TXT", "", "PatAdmInfo", "28", "Y")
	s sc = $$InitOneQueryField("QualityDoc", "质控医师", "TXT", "", "PatAdmInfo", "29", "Y")
	s sc = $$InitOneQueryField("PatientID", "病人标识号", "TXT", "", "PatAdmInfo", "30", "Y")
	s sc = $$InitOneQueryField("CompanyCode", "医疗组织机构代码", "TXT", "", "PatAdmInfo", "31", "Y")
	s sc = $$InitOneQueryField("Marriage", "婚姻", "TXT", "", "PatBaseInfo", "32", "Y")
	s sc = $$InitOneQueryField("Nationality", "民族", "TXT", "", "PatBaseInfo", "33", "Y")
	s sc = $$InitOneQueryField("InsuType", "医保类型", "TXT", "", "PatBaseInfo", "34", "Y")
	s sc = $$InitOneQueryField("InsuNo", "医保号", "TXT", "", "PatBaseInfo", "35", "Y")
	s sc = $$InitOneQueryField("PhoneNo", "手机号", "TXT", "", "PatBaseInfo", "36", "Y")
	s sc = $$InitOneQueryField("LinkName", "联系人", "TXT", "", "PatBaseInfo", "37", "Y")
	s sc = $$InitOneQueryField("LinkRelation", "联系人关系", "TXT", "", "PatBaseInfo", "38", "Y")
	s sc = $$InitOneQueryField("LinkPhone", "联系人电话", "TXT", "", "PatBaseInfo", "39", "Y")
	s sc = $$InitOneQueryField("Occupation", "职业", "TXT", "", "PatBaseInfo", "40", "Y")
	s sc = $$InitOneQueryField("Company", "工作单位", "TXT", "", "PatBaseInfo", "41", "Y")
	s sc = $$InitOneQueryField("Worktel", "工作电话", "TXT", "", "PatBaseInfo", "42", "Y")
	s sc = $$InitOneQueryField("HouseProvince", "户口省", "TXT", "", "PatBaseInfo", "43", "Y")
	s sc = $$InitOneQueryField("HouseCity", "户口市", "TXT", "", "PatBaseInfo", "44", "Y")
	s sc = $$InitOneQueryField("HouseArea", "户口区", "TXT", "", "PatBaseInfo", "45", "Y")
	s sc = $$InitOneQueryField("HouseAddress", "户口地址", "TXT", "", "PatBaseInfo", "46", "Y")
	s sc = $$InitOneQueryField("HouseZipCode", "户口邮编", "TXT", "", "PatBaseInfo", "47", "Y")
	s sc = $$InitOneQueryField("ResidentProvince", "现住址省", "TXT", "", "PatBaseInfo", "48", "Y")
	s sc = $$InitOneQueryField("ResidentCity", "现住址市", "TXT", "", "PatBaseInfo", "49", "Y")
	s sc = $$InitOneQueryField("ResidentArea", "现住址县区", "TXT", "", "PatBaseInfo", "50", "Y")
	s sc = $$InitOneQueryField("ResidentAddress", "现住址地址", "TXT", "", "PatBaseInfo", "51", "Y")
	s sc = $$InitOneQueryField("ResidentZipCode", "现住址邮编", "TXT", "", "PatBaseInfo", "52", "Y")
	s sc = $$InitOneQueryField("IsCritiCal", "危重病人", "TXT", "", "PatAdmInfo", "53", "Y")
	s sc = $$InitOneQueryField("DiagMainDesc", "主要诊断", "TXT", "", "PatOperInfo", "54", "Y")
	s sc = $$InitOneQueryField("DiagMainDescCode", "主要诊断代码", "TXT", "", "PatOperInfo", "55", "Y")
	s sc = $$InitOneQueryField("DiagDesc", "其它诊断", "TXT", "", "PatOperInfo", "56", "Y")
	s sc = $$InitOneQueryField("DiagDescCode", "其它诊断代码", "TXT", "", "PatOperInfo", "57", "Y")
	s sc = $$InitOneQueryField("Diag01Desc", "其它诊断1", "TXT", "", "PatOperInfo", "58", "Y")
	s sc = $$InitOneQueryField("Diag01Code", "其它诊断2代码", "TXT", "", "PatOperInfo", "59", "Y")
	s sc = $$InitOneQueryField("Diag02Desc", "其它诊断2", "TXT", "", "PatOperInfo", "60", "Y")
	s sc = $$InitOneQueryField("Diag02Code", "其它诊断2代码", "TXT", "", "PatOperInfo", "61", "Y")
	s sc = $$InitOneQueryField("Diag03Desc", "其它诊断3", "TXT", "", "PatOperInfo", "62", "Y")
	s sc = $$InitOneQueryField("Diag03Code", "其它诊断3代码", "TXT", "", "PatOperInfo", "63", "Y")
	s sc = $$InitOneQueryField("Diag04Desc", "其它诊断4", "TXT", "", "PatOperInfo", "64", "Y")
	s sc = $$InitOneQueryField("Diag04Code", "其它诊断4代码", "TXT", "", "PatOperInfo", "65", "Y")
	s sc = $$InitOneQueryField("Diag05Desc", "其它诊断5", "TXT", "", "PatOperInfo", "66", "Y")
	s sc = $$InitOneQueryField("Diag05Code", "其它诊断5代码", "TXT", "", "PatOperInfo", "67", "Y")
	s sc = $$InitOneQueryField("Diag06Desc", "其它诊断6", "TXT", "", "PatOperInfo", "68", "Y")
	s sc = $$InitOneQueryField("Diag06Code", "其它诊断6代码", "TXT", "", "PatOperInfo", "69", "Y")
	s sc = $$InitOneQueryField("Diag07Desc", "其它诊断7", "TXT", "", "PatOperInfo", "70", "Y")
	s sc = $$InitOneQueryField("Diag07Code", "其它诊断7代码", "TXT", "", "PatOperInfo", "71", "Y")
	s sc = $$InitOneQueryField("Diag08Desc", "其它诊断8", "TXT", "", "PatOperInfo", "72", "Y")
	s sc = $$InitOneQueryField("Diag08Code", "其它诊断8代码", "TXT", "", "PatOperInfo", "73", "Y")
	s sc = $$InitOneQueryField("Diag09Desc", "其它诊断9", "TXT", "", "PatOperInfo", "74", "Y")
	s sc = $$InitOneQueryField("Diag09Code", "其它诊断9代码", "TXT", "", "PatOperInfo", "75", "Y")
	s sc = $$InitOneQueryField("Diag10Desc", "其它诊断10", "TXT", "", "PatOperInfo", "76", "Y")
	s sc = $$InitOneQueryField("Diag10Code", "其它诊断10代码", "TXT", "", "PatOperInfo", "77", "Y")
	s sc = $$InitOneQueryField("DiagOutDesc", "门急诊诊断", "TXT", "", "PatOperInfo", "78", "Y")
	s sc = $$InitOneQueryField("DiagOutDescCode", "门急诊诊断代码", "TXT", "", "PatOperInfo", "79", "Y")
	s sc = $$InitOneQueryField("DiagPathDesc", "病理诊断", "TXT", "", "PatOperInfo", "80", "Y")
	s sc = $$InitOneQueryField("DiagPathDescCode", "病理诊断代码", "TXT", "", "PatOperInfo", "81", "Y")
	s sc = $$InitOneQueryField("Oper01Desc", "手术1", "TXT", "", "PatOperInfo", "82", "Y")
	s sc = $$InitOneQueryField("Oper02Desc", "手术2", "TXT", "", "PatOperInfo", "83", "Y")
	s sc = $$InitOneQueryField("Oper03Desc", "手术3", "TXT", "", "PatOperInfo", "84", "Y")
	s sc = $$InitOneQueryField("Oper04Desc", "手术4", "TXT", "", "PatOperInfo", "85", "Y")
	s sc = $$InitOneQueryField("Oper05Desc", "手术5", "TXT", "", "PatOperInfo", "86", "Y")
	s sc = $$InitOneQueryField("Oper06Desc", "手术6", "TXT", "", "PatOperInfo", "87", "Y")
	s sc = $$InitOneQueryField("Oper07Desc", "手术7", "TXT", "", "PatOperInfo", "88", "Y")
	s sc = $$InitOneQueryField("Oper08Desc", "手术8", "TXT", "", "PatOperInfo", "89", "Y")
	s sc = $$InitOneQueryField("Oper01Date", "手术日期1", "DATE", "", "PatOperInfo", "90", "Y")
	s sc = $$InitOneQueryField("Oper02Date", "手术日期2", "DATE", "", "PatOperInfo", "91", "Y")
	s sc = $$InitOneQueryField("Oper03Date", "手术日期3", "DATE", "", "PatOperInfo", "92", "Y")
	s sc = $$InitOneQueryField("Oper04Date", "手术日期4", "DATE", "", "PatOperInfo", "93", "Y")
	s sc = $$InitOneQueryField("Oper05Date", "手术日期5", "DATE", "", "PatOperInfo", "94", "Y")
	s sc = $$InitOneQueryField("Oper06Date", "手术日期6", "DATE", "", "PatOperInfo", "95", "Y")
	s sc = $$InitOneQueryField("Oper07Date", "手术日期7", "DATE", "", "PatOperInfo", "96", "Y")
	s sc = $$InitOneQueryField("Oper08Date", "手术日期8", "DATE", "", "PatOperInfo", "97", "Y")
	s sc = $$InitOneQueryField("Oper01Level", "手术等级1", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "98", "Y")
	s sc = $$InitOneQueryField("Oper02Level", "手术等级2", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "99", "Y")
	s sc = $$InitOneQueryField("Oper03Level", "手术等级3", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "100", "Y")
	s sc = $$InitOneQueryField("Oper04Level", "手术等级4", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "101", "Y")
	s sc = $$InitOneQueryField("Oper05Level", "手术等级5", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "102", "Y")
	s sc = $$InitOneQueryField("Oper06Level", "手术等级6", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "103", "Y")
	s sc = $$InitOneQueryField("Oper07Level", "手术等级7", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "104", "Y")
	s sc = $$InitOneQueryField("Oper08Level", "手术等级8", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|OperLevel", "PatOperInfo", "105", "Y")
	s sc = $$InitOneQueryField("Oper01DocName", "手术1术者", "TXT", "", "PatOperInfo", "106", "Y")
	s sc = $$InitOneQueryField("Oper02DocName", "手术2术者", "TXT", "", "PatOperInfo", "107", "Y")
	s sc = $$InitOneQueryField("Oper03DocName", "手术3术者", "TXT", "", "PatOperInfo", "108", "Y")
	s sc = $$InitOneQueryField("Oper04DocName", "手术4术者", "TXT", "", "PatOperInfo", "109", "Y")
	s sc = $$InitOneQueryField("Oper05DocName", "手术5术者", "TXT", "", "PatOperInfo", "110", "Y")
	s sc = $$InitOneQueryField("Oper06DocName", "手术6术者", "TXT", "", "PatOperInfo", "111", "Y")
	s sc = $$InitOneQueryField("Oper07DocName", "手术7术者", "TXT", "", "PatOperInfo", "112", "Y")
	s sc = $$InitOneQueryField("Oper08DocName", "手术8术者", "TXT", "", "PatOperInfo", "113", "Y")
	s sc = $$InitOneQueryField("Oper01Assist1Name", "手术1助手1", "TXT", "", "PatOperInfo", "114", "Y")
	s sc = $$InitOneQueryField("Oper02Assist1Name", "手术2助手1", "TXT", "", "PatOperInfo", "115", "Y")
	s sc = $$InitOneQueryField("Oper03Assist1Name", "手术3助手1", "TXT", "", "PatOperInfo", "116", "Y")
	s sc = $$InitOneQueryField("Oper04Assist1Name", "手术4助手1", "TXT", "", "PatOperInfo", "117", "Y")
	s sc = $$InitOneQueryField("Oper05Assist1Name", "手术5助手1", "TXT", "", "PatOperInfo", "118", "Y")
	s sc = $$InitOneQueryField("Oper06Assist1Name", "手术6助手1", "TXT", "", "PatOperInfo", "119", "Y")
	s sc = $$InitOneQueryField("Oper07Assist1Name", "手术7助手1", "TXT", "", "PatOperInfo", "120", "Y")
	s sc = $$InitOneQueryField("Oper08Assist1Name", "手术8助手1", "TXT", "", "PatOperInfo", "121", "Y")
	s sc = $$InitOneQueryField("Oper01Assist2Name", "手术1助手2", "TXT", "", "PatOperInfo", "122", "Y")
	s sc = $$InitOneQueryField("Oper02Assist2Name", "手术2助手2", "TXT", "", "PatOperInfo", "123", "Y")
	s sc = $$InitOneQueryField("Oper03Assist2Name", "手术3助手2", "TXT", "", "PatOperInfo", "124", "Y")
	s sc = $$InitOneQueryField("Oper04Assist2Name", "手术4助手2", "TXT", "", "PatOperInfo", "125", "Y")
	s sc = $$InitOneQueryField("Oper05Assist2Name", "手术5助手2", "TXT", "", "PatOperInfo", "126", "Y")
	s sc = $$InitOneQueryField("Oper06Assist2Name", "手术6助手2", "TXT", "", "PatOperInfo", "127", "Y")
	s sc = $$InitOneQueryField("Oper07Assist2Name", "手术7助手2", "TXT", "", "PatOperInfo", "128", "Y")
	s sc = $$InitOneQueryField("Oper08Assist2Name", "手术8助手2", "TXT", "", "PatOperInfo", "129", "Y")
	s sc = $$InitOneQueryField("Oper01AnaMethod", "手术1麻醉方式", "TXT", "", "PatOperInfo", "130", "Y")
	s sc = $$InitOneQueryField("Oper02AnaMethod", "手术2麻醉方式", "TXT", "", "PatOperInfo", "131", "Y")
	s sc = $$InitOneQueryField("Oper03AnaMethod", "手术3麻醉方式", "TXT", "", "PatOperInfo", "132", "Y")
	s sc = $$InitOneQueryField("Oper04AnaMethod", "手术4麻醉方式", "TXT", "", "PatOperInfo", "133", "Y")
	s sc = $$InitOneQueryField("Oper05AnaMethod", "手术5麻醉方式", "TXT", "", "PatOperInfo", "134", "Y")
	s sc = $$InitOneQueryField("Oper06AnaMethod", "手术6麻醉方式", "TXT", "", "PatOperInfo", "135", "Y")
	s sc = $$InitOneQueryField("Oper07AnaMethod", "手术7麻醉方式", "TXT", "", "PatOperInfo", "136", "Y")
	s sc = $$InitOneQueryField("Oper08AnaMethod", "手术8麻醉方式", "TXT", "", "PatOperInfo", "137", "Y")
	s sc = $$InitOneQueryField("Oper01AnaDocName", "手术1麻醉医生", "TXT", "", "PatOperInfo", "138", "Y")
	s sc = $$InitOneQueryField("Oper02AnaDocName", "手术2麻醉医生", "TXT", "", "PatOperInfo", "139", "Y")
	s sc = $$InitOneQueryField("Oper03AnaDocName", "手术3麻醉医生", "TXT", "", "PatOperInfo", "140", "Y")
	s sc = $$InitOneQueryField("Oper04AnaDocName", "手术4麻醉医生", "TXT", "", "PatOperInfo", "141", "Y")
	s sc = $$InitOneQueryField("Oper05AnaDocName", "手术5麻醉医生", "TXT", "", "PatOperInfo", "142", "Y")
	s sc = $$InitOneQueryField("Oper06AnaDocName", "手术6麻醉医生", "TXT", "", "PatOperInfo", "143", "Y")
	s sc = $$InitOneQueryField("Oper07AnaDocName", "手术7麻醉医生", "TXT", "", "PatOperInfo", "144", "Y")
	s sc = $$InitOneQueryField("Oper08AnaDocName", "手术8麻醉医生", "TXT", "", "PatOperInfo", "145", "Y")
	s sc = $$InitOneQueryField("Oper01CutLevel", "手术1切口等级", "TXT", "", "PatOperInfo", "146", "Y")
	s sc = $$InitOneQueryField("Oper02CutLevel", "手术2切口等级", "TXT", "", "PatOperInfo", "147", "Y")
	s sc = $$InitOneQueryField("Oper03CutLevel", "手术3切口等级", "TXT", "", "PatOperInfo", "148", "Y")
	s sc = $$InitOneQueryField("Oper04CutLevel", "手术4切口等级", "TXT", "", "PatOperInfo", "149", "Y")
	s sc = $$InitOneQueryField("Oper05CutLevel", "手术5切口等级", "TXT", "", "PatOperInfo", "150", "Y")
	s sc = $$InitOneQueryField("Oper06CutLevel", "手术6切口等级", "TXT", "", "PatOperInfo", "151", "Y")
	s sc = $$InitOneQueryField("Oper07CutLevel", "手术7切口等级", "TXT", "", "PatOperInfo", "152", "Y")
	s sc = $$InitOneQueryField("Oper08CutLevel", "手术8切口等级", "TXT", "", "PatOperInfo", "153", "Y")
	s sc = $$InitOneQueryField("F00TotalFee", "00总费用", "TXT", "", "PatOtherInfo", "154", "Y")
	s sc = $$InitOneQueryField("F01YBYLFWF", "01一般医疗服务费", "TXT", "", "PatOtherInfo", "155", "Y")
	s sc = $$InitOneQueryField("F02YBZLCZF", "02一般治疗操作费", "TXT", "", "PatOtherInfo", "156", "Y")
	s sc = $$InitOneQueryField("F03HLF", "03护理费", "TXT", "", "PatOtherInfo", "157", "Y")
	s sc = $$InitOneQueryField("F04QTFY", "04其他费用", "TXT", "", "PatOtherInfo", "158", "Y")
	s sc = $$InitOneQueryField("F05BLZDF", "05病理诊断费用", "TXT", "", "PatOtherInfo", "159", "Y")
	s sc = $$InitOneQueryField("F06SYSZDF", "06实验室诊断费", "TXT", "", "PatOtherInfo", "160", "Y")
	s sc = $$InitOneQueryField("F07YXXZDF", "07影像学诊断费", "TXT", "", "PatOtherInfo", "161", "Y")
	s sc = $$InitOneQueryField("F08LCZDXMF", "08临床诊断项目费", "TXT", "", "PatOtherInfo", "162", "Y")
	s sc = $$InitOneQueryField("F09FSSZLF", "09非手术治疗项目费", "TXT", "", "PatOtherInfo", "163", "Y")
	s sc = $$InitOneQueryField("F10SSZLF", "10手术治疗费", "TXT", "", "PatOtherInfo", "164", "Y")
	s sc = $$InitOneQueryField("F11KFF", "11康复费", "TXT", "", "PatOtherInfo", "165", "Y")
	s sc = $$InitOneQueryField("F12ZYZLF", "12中医治疗费", "TXT", "", "PatOtherInfo", "166", "Y")
	s sc = $$InitOneQueryField("F13XYF", "13西药费", "TXT", "", "PatOtherInfo", "167", "Y")
	s sc = $$InitOneQueryField("F14ZCHYF", "14中成药费", "TXT", "", "PatOtherInfo", "168", "Y")
	s sc = $$InitOneQueryField("F15ZCYF", "15中草药费", "TXT", "", "PatOtherInfo", "169", "Y")
	s sc = $$InitOneQueryField("F16XF", "16血费", "TXT", "", "PatOtherInfo", "170", "Y")
	s sc = $$InitOneQueryField("F17BDBLF", "17白蛋白类制品费", "TXT", "", "PatOtherInfo", "171", "Y")
	s sc = $$InitOneQueryField("F18QDBLF", "18球蛋白类制品费", "TXT", "", "PatOtherInfo", "172", "Y")
	s sc = $$InitOneQueryField("F19NXYZF", "19凝血因子类制品费", "TXT", "", "PatOtherInfo", "173", "Y")
	s sc = $$InitOneQueryField("F20XBYZF", "20细胞因子类制品费", "TXT", "", "PatOtherInfo", "174", "Y")
	s sc = $$InitOneQueryField("F21JCYYCXCLF", "21检查用一次性医用材料费", "TXT", "", "PatOtherInfo", "175", "Y")
	s sc = $$InitOneQueryField("F22ZLYYCXCLF", "22治疗用一次性医用材料费", "TXT", "", "PatOtherInfo", "176", "Y")
	s sc = $$InitOneQueryField("F23SSYYCXCLF", "23手术用一次性医用材料费", "TXT", "", "PatOtherInfo", "177", "Y")
	s sc = $$InitOneQueryField("F24QTF", "24其他费", "TXT", "", "PatOtherInfo", "178", "Y")
	s sc = $$InitOneQueryField("F0901LCWLZLF", "0901临床物理治疗费", "TXT", "", "PatOtherInfo", "179", "Y")
	s sc = $$InitOneQueryField("F1001MZF", "1001麻醉费", "TXT", "", "PatOtherInfo", "180", "Y")
	s sc = $$InitOneQueryField("F1002SSF", "1002手术费", "TXT", "", "PatOtherInfo", "181", "Y")
	s sc = $$InitOneQueryField("F1301KJYWF", "1301抗菌药物费", "TXT", "", "PatOtherInfo", "182", "Y")
	s sc = $$InitOneQueryField("AttendingDoc", "主治医师", "TXT", "", "PatAdmInfo", "183", "Y")
	s sc = $$InitOneQueryField("InsuranceType", "医保细分类", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|InsuranceType", "PatBaseInfo", "184", "Y")
	s sc = $$InitOneQueryField("IsCreated", "已生成", "TXT", "", "MedRecordFlowInfo", "185", "Y")
	s sc = $$InitOneQueryField("IsScanned", "已扫描", "TXT", "", "MedRecordFlowInfo", "186", "Y")
	s sc = $$InitOneQueryField("IsHavePDF", "已有PDF", "TXT", "", "MedRecordFlowInfo", "187", "Y")
	s sc = $$InitOneQueryField("InPatientWayDesc", "入院途径", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|InPatientWay", "PatAdmInfo", "188", "Y")
	s sc = $$InitOneQueryField("CatalogOperator", "编目者", "TXT", "", "MedRecordFlowInfo", "189", "Y")
	s sc = $$InitOneQueryField("ReviewOperator", "复核者", "TXT", "", "MedRecordFlowInfo", "190", "Y")
	s sc = $$InitOneQueryField("ScanOperator", "扫描者", "TXT", "", "MedRecordFlowInfo", "191", "Y")
	s sc = $$InitOneQueryField("PrintOperator", "打印者", "TXT", "", "MedRecordFlowInfo", "192", "Y")
	s sc = $$InitOneQueryField("ArrangeOperator", "分类者", "TXT", "", "MedRecordFlowInfo", "193", "Y")
	s sc = $$InitOneQueryField("ReplaceOperator", "替换者", "TXT", "", "MedRecordFlowInfo", "194", "Y")
	s sc = $$InitOneQueryField("Oper01Code", "手术1代码", "TXT", "", "PatOperInfo", "195", "Y")
	s sc = $$InitOneQueryField("Oper02Code", "手术2代码", "TXT", "", "PatOperInfo", "196", "Y")
	s sc = $$InitOneQueryField("Oper03Code", "手术3代码", "TXT", "", "PatOperInfo", "197", "Y")
	s sc = $$InitOneQueryField("Oper04Code", "手术4代码", "TXT", "", "PatOperInfo", "198", "Y")
	s sc = $$InitOneQueryField("Oper05Code", "手术5代码", "TXT", "", "PatOperInfo", "199", "Y")
	s sc = $$InitOneQueryField("Oper06Code", "手术6代码", "TXT", "", "PatOperInfo", "200", "Y")
	s sc = $$InitOneQueryField("Oper07Code", "手术7代码", "TXT", "", "PatOperInfo", "201", "Y")
	s sc = $$InitOneQueryField("Oper08Code", "手术8代码", "TXT", "", "PatOperInfo", "202", "Y")
	s sc = $$InitOneQueryField("DPDiagnose", "损伤中毒", "TXT", "", "PatOperInfo", "203", "Y")
	s sc = $$InitOneQueryField("DPDiagnoseDesc", "损伤中毒描述", "TXT", "", "PatOperInfo", "204", "Y")
	s sc = $$InitOneQueryField("EMRMainDiagCode", "病历主要诊断编码", "TXT", "", "PatOperInfo", "205", "Y")
	s sc = $$InitOneQueryField("EMRMainDiagDesc", "病历主要诊断描述", "TXT", "", "PatOperInfo", "206", "Y")
	s sc = $$InitOneQueryField("MRItemName", "归档项目名称", "TXT", "", "PatOperInfo", "207", "Y")
	
InitOneQueryField(argFieldName,argFieldDesc,argFieldType,argFieldInterface,argCategoryName,argSequence,argIsActive)
	s categoryID = ""
	&sql(select ID into :categoryID from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName)
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFields
		where FieldName = :argFieldName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFields (FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive) 
			values (:argFieldName,:argFieldDesc,:argFieldType,:argFieldInterface,:categoryID,:argSequence,:argIsActive))
	}
	
	q "1"
}

/// Desc:	初始化自定义字典
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitCustomDic()
ClassMethod InitCustomDic()
{
	s sc = $$InitOneCustomDic("1", "城镇职工基本医疗保险", "czzgjbylbx", "PayMode", "1", "1")
	s sc = $$InitOneCustomDic("2", "城镇居民基本医疗保险", "czjmjbylbx", "PayMode", "1", "2")
	s sc = $$InitOneCustomDic("3", "新型农村合作医疗", "xxnchzyl", "PayMode", "1", "3")
	s sc = $$InitOneCustomDic("4", "贫困救助", "pkjz", "PayMode", "1", "4")
	s sc = $$InitOneCustomDic("5", "商业医疗保险", "syylbx", "PayMode", "1", "5")
	s sc = $$InitOneCustomDic("6", "全公费", "qgf", "PayMode", "1", "6")
	s sc = $$InitOneCustomDic("7", "全自费", "qzf", "PayMode", "1", "7")
	s sc = $$InitOneCustomDic("8", "其他社会保险", "qtshbx", "PayMode", "1", "8")
	s sc = $$InitOneCustomDic("9", "其他", "qt", "PayMode", "1", "9")
	s sc = $$InitOneCustomDic("1", "1", "y", "OperLevel", "1", "1")
	s sc = $$InitOneCustomDic("2", "2", "e", "OperLevel", "1", "2")
	s sc = $$InitOneCustomDic("3", "3", "s", "OperLevel", "1", "3")
	s sc = $$InitOneCustomDic("4", "4", "s", "OperLevel", "1", "4")
	s sc = $$InitOneCustomDic("1", "0", "l", "CutLevel", "1", "1")
	s sc = $$InitOneCustomDic("2", "I/甲", "yj", "CutLevel", "1", "2")
	s sc = $$InitOneCustomDic("3", "I/乙", "yy", "CutLevel", "1", "3")
	s sc = $$InitOneCustomDic("4", "I/丙", "yb", "CutLevel", "1", "4")
	s sc = $$InitOneCustomDic("5", "I/其他", "yqt", "CutLevel", "1", "5")
	s sc = $$InitOneCustomDic("6", "II/甲", "ej", "CutLevel", "1", "6")
	s sc = $$InitOneCustomDic("7", "II/乙", "ey", "CutLevel", "1", "7")
	s sc = $$InitOneCustomDic("8", "II/丙", "eb", "CutLevel", "1", "8")
	s sc = $$InitOneCustomDic("9", "II/其他", "eqt", "CutLevel", "1", "9")
	s sc = $$InitOneCustomDic("10", "III/甲", "sj", "CutLevel", "1", "10")
	s sc = $$InitOneCustomDic("11", "III/乙", "sy", "CutLevel", "1", "11")
	s sc = $$InitOneCustomDic("12", "III/丙", "sb", "CutLevel", "1", "12")
	s sc = $$InitOneCustomDic("13", "III/其他", "sqt", "CutLevel", "1", "13")
	s sc = $$InitOneCustomDic("1", "有", "y", "Condition", "1", "1")
	s sc = $$InitOneCustomDic("2", "临床未确定", "lcwqd", "Condition", "1", "2")
	s sc = $$InitOneCustomDic("3", "情况不明", "qkbm", "Condition", "1", "3")
	s sc = $$InitOneCustomDic("4", "无", "w", "Condition", "1", "4")
	s sc = $$InitOneCustomDic("1", "DiagMain-主要诊断", "zyzd", "DiagnosisType", "1", "1")
	s sc = $$InitOneCustomDic("2", "Diag-次要诊断", "cyzd", "DiagnosisType", "1", "2")
	s sc = $$InitOneCustomDic("3", "DiagPath-病理诊断", "blzd", "DiagnosisType", "1", "3")
	s sc = $$InitOneCustomDic("4", "DiagOut-门急诊诊断", "mjzzd", "DiagnosisType", "1", "4")
	s sc = $$InitOneCustomDic("5", "DiagAdm-入院诊断", "ryzd", "DiagnosisType", "1", "5")
	s sc = $$InitOneCustomDic("1", "甲", "jj", "MedQuality", "1", "1")
	s sc = $$InitOneCustomDic("2", "乙", "yj", "MedQuality", "1", "2")
	s sc = $$InitOneCustomDic("3", "丙", "bj", "MedQuality", "1", "3")
	s sc = $$InitOneCustomDic("1", "男", "n", "Gender", "1", "1")
	s sc = $$InitOneCustomDic("2", "女", "n", "Gender", "1", "2")
	s sc = $$InitOneCustomDic("3", "未知性别", "wzxb", "Gender", "1", "3")
	s sc = $$InitOneCustomDic("4", "未说明性别", "wsmxb", "Gender", "1", "4")
	s sc = $$InitOneCustomDic("1", "未婚", "wh", "Marriage", "1", "1")
	s sc = $$InitOneCustomDic("2", "已婚", "yh", "Marriage", "1", "2")
	s sc = $$InitOneCustomDic("3", "初婚", "ch", "Marriage", "1", "3")
	s sc = $$InitOneCustomDic("4", "再婚", "zh", "Marriage", "1", "4")
	s sc = $$InitOneCustomDic("5", "复婚", "fh", "Marriage", "1", "5")
	s sc = $$InitOneCustomDic("6", "丧偶", "so", "Marriage", "1", "6")
	s sc = $$InitOneCustomDic("7", "离婚", "lh", "Marriage", "1", "7")
	s sc = $$InitOneCustomDic("8", "未说明婚姻状况", "wsmhyzk", "Marriage", "1", "8")
	s sc = $$InitOneCustomDic("=", "等于", "dy", "Operator", "1", "1")
	s sc = $$InitOneCustomDic(">", "大于", "dy", "Operator", "1", "2")
	s sc = $$InitOneCustomDic("<", "小于", "xy", "Operator", "1", "3")
	s sc = $$InitOneCustomDic("<>", "不等于", "bdy", "Operator", "1", "4")
	s sc = $$InitOneCustomDic(">=", "大于等于", "dydy", "Operator", "1", "5")
	s sc = $$InitOneCustomDic("<=", "小于等于", "xydy", "Operator", "1", "6")
	s sc = $$InitOneCustomDic("like", "包含", "bh", "Operator", "1", "7")
	s sc = $$InitOneCustomDic("notlike", "不包含", "bbh", "Operator", "1", "8")
	s sc = $$InitOneCustomDic("1", "市医保", "syb", "InsuranceType", "1", "1")
	s sc = $$InitOneCustomDic("2", "省医保", "syb", "InsuranceType", "1", "2")
	s sc = $$InitOneCustomDic("3", "省医保离休", "syblx", "InsuranceType", "1", "3")
	s sc = $$InitOneCustomDic("4", "哈市城镇居民医保", "hsczjmyb", "InsuranceType", "1", "4")
	s sc = $$InitOneCustomDic("5", "外地城镇居民医保", "wdczjmyb", "InsuranceType", "1", "5")
	s sc = $$InitOneCustomDic("6", "外地医保", "wdyb", "InsuranceType", "1", "6")
	s sc = $$InitOneCustomDic("7", "哈市新农合", "hsxnh", "InsuranceType", "1", "7")
	s sc = $$InitOneCustomDic("8", "外地新农合", "wdxnh", "InsuranceType", "1", "8")
	s sc = $$InitOneCustomDic("9", "铁路医保", "tlyb", "InsuranceType", "1", "9")
	s sc = $$InitOneCustomDic("10", "生育", "sy", "InsuranceType", "1", "10")
	s sc = $$InitOneCustomDic("11", "工伤", "gs", "InsuranceType", "1", "11")
	s sc = $$InitOneCustomDic("12", "其他社会保险", "qtshbx", "InsuranceType", "1", "12")
	s sc = $$InitOneCustomDic("13", "商业健康保险", "syjkbx", "InsuranceType", "1", "13")
	s sc = $$InitOneCustomDic("1", "急诊", "jz", "InPatientWay", "1", "1")
	s sc = $$InitOneCustomDic("2", "门诊", "mz", "InPatientWay", "1", "2")
	s sc = $$InitOneCustomDic("3", "其他医疗机构转入", "qtyljgzr", "InPatientWay", "1", "3")
	s sc = $$InitOneCustomDic("9", "其他", "qt", "InPatientWay", "1", "4")
	s sc = $$InitOneCustomDic("01","全身麻醉","QSMZ","NarcosisType","1","1")
	s sc = $$InitOneCustomDic("0101","吸入麻醉 （气管内插管、喉罩、面罩）","XRMZ （QGNCG、HZ、MZ）","NarcosisType","1","2")
	s sc = $$InitOneCustomDic("0102","静脉麻醉 （全凭静脉麻醉）","JMMZ （QPJMMZ）","NarcosisType","1","3")
	
InitOneCustomDic(argCtmDictCode, argCtmDictDesc, argCtmDictAlias, argCtmDictType, argCtmIsActive, argCtmIndex)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.CustomDic
		where CtmDictType  = :argCtmDictType and CtmIndex = :argCtmIndex)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.CustomDic (CtmDictCode, CtmDictDesc, CtmDictAlias, CtmDictType,CtmIsActive,CtmIndex) 
			values (:argCtmDictCode, :argCtmDictDesc, :argCtmDictAlias, :argCtmDictType, :argCtmIsActive, :argCtmIndex))
	}
	
	q "1"
}

/// Desc:	初始化查询功能中结果列
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InsertResultColumns()
ClassMethod InsertResultColumns()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.QueryFieldsD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.META.QueryFields).%OpenId(rowID)
		s ColName = obj.FieldName
		s ColDesc = obj.FieldDesc
		s Sequence = obj.Sequence
		s IsActive = "Y"
		
		s objRC = ##class(DHCEPRFS.META.ResultColumn).%New()
		s objRC.ColName = ColName
		s objRC.ColDesc = ColDesc
		s objRC.IsActive = IsActive
		s objRC.Sequence = Sequence
		
		s sc = objRC.%Save()
		w !,rowID
	}
}

/// Desc:	添加归档项目
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).AddMRItem()
ClassMethod AddMRItem()
{
	//d ..AddOneMRItem("超声检查报告单","BUltrasonic001","BUltrasonicSub001",""BUltrasonicItem001"","91","1","BUltrasonic","xxx.csp")
	//d ..AddOneMRItem("手术麻醉单","Anesthesia001","AnesthesiaSub001","AnesthesiaItem001","92","1","Anesthesia","xxx.csp")
	d ..AddOneMRItem("重症监护单","ICUNursingRecord001","ICUNursingRecordSub001","ICUNursingRecordItem001","18","1","ICUNursingRecord","xxx.csp")
}

/// Desc:	添加一项归档项目
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).AddMRItem()
ClassMethod AddOneMRItem(ACategoryName, ACategoryCode, ASubCategoryCode, AMRItemCode, AType, ATypeParam, AMRItemDesc, ACSPPath)
{
	s sequenceCount = 0
	&sql(select count(*) into :sequenceCount from DHCEPRFS_META.MRCategory)
	s sequenceCount = (+sequenceCount) + 1
	&sql(insert into DHCEPRFS_META.MRCategory(Name,Code,Description,Sequence) values (:ACategoryName,:ACategoryCode,:ACategoryName,:sequenceCount))
	if (SQLCODE = 0)
	{
		w "Insert MRCategory OK: ", %ROWID,!
		s mrCategoryID = %ROWID
		s sequenceCount = 0
		&sql(select count(*) into :sequenceCount from DHCEPRFS_META.MRSubCategory)
		s sequenceCount = (+sequenceCount) + 1
		&sql(insert into DHCEPRFS_META.MRSubCategory(Name,Code,Description,MRCategoryID,Sequence) values (:ACategoryName,:ASubCategoryCode,:ACategoryName,:mrCategoryID,:sequenceCount))
		if (SQLCODE = 0)
		{
			w "Insert MRSubCategory OK: ", %ROWID,!
			s mrSubCategoryID = %ROWID
			s sequenceCount = 0
			&sql(select count(*) into :sequenceCount from DHCEPRFS_META.MRItem)
			s sequenceCount = (+sequenceCount) + 1
			&sql(insert into DHCEPRFS_META.MRItem(Name,Code,Description,MRSubCategoryID,Type,TypeParams,Source,Sequence,Attachment,AttachType) values (:ACategoryName,:AMRItemCode,:ACategoryName,:mrSubCategoryID,:AType,:ATypeParam,:AMRItemDesc,:sequenceCount,"",""))
			if (SQLCODE = 0)
			{
				w "Insert MRItem OK: ", %ROWID,!
				s sequenceCount = 0
				&sql(select count(*) into :sequenceCount from DHCEPRFS_META.CTItemType)
				s sequenceCount = (+sequenceCount) + 1
				&sql(insert into DHCEPRFS_META.CTItemType(TypeCode,TypeName,TypeDesc,CSPPath,Sequence) values (:AType,:ACategoryName,:ACategoryName,:ACSPPath,:sequenceCount))
				if (SQLCODE = 0)
				{
					w "Insert CTItemType OK: ", %ROWID,!
				}
			}
		}
	}
}

/// Desc:	添加归档到全文检索队列中
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).FullTextSearch()
ClassMethod FullTextSearch()
{
	s count = 0
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRFS.INST.MREpisodeD(rowID))	
		q:(rowID = "")
		s count = count + 1
		//q:(count > 10000)
		w !,##class(DHCEPRSearch.BL.BLSearch).Create(rowID,"50")
	}
}

/// Desc:	初始化质控医生
/// Debug:	w ##Class(DHCEPRFS.Tool.BaseDataMgr).InitQADoc("519","chiefCheck","首次")
ClassMethod InitQADoc(AEPRDocID, AActionCode, ATitleList)
{
	&sql(select ID into :rowid from DHCEPRFS_META.QAEPR
		where EPRDocID = :AEPRDocID and ActionCode = :AActionCode)
	
	if rowid = ""
	{
		&sql(insert into DHCEPRFS_META.QAEPR (EPRDocID, ActionCode, TitleList) 
			values (:AEPRDocID, :AActionCode, :ATitleList))
	}
	else
	{
		&sql(update DHCEPRFS_META.QAEPR set TitleList = :ATitleList)
	}
	
	q "1"
}

/// Desc:	初始化版本代码关联表
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitVersionCodeMapping()
ClassMethod InitVersionCodeMapping()
{
	s sc = $$InitVersionCodeMapping("1", "CREATEPRIVACY01", "隐私级别1对应的Version")
	s sc = $$InitVersionCodeMapping("2", "CREATEPRIVACY02", "隐私级别2对应的Version")
	s sc = $$InitVersionCodeMapping("3", "CREATEPRIVACY03", "隐私级别3对应的Version")
	
InitVersionCodeMapping(argVersion, argVersionCode, argVersionDesc)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.VersionCodeMapping
		where Version  = :argVersion and VersionCode = :argVersionCode)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.VersionCodeMapping (Version, VersionCode, VersionDesc) 
			values (:argVersion, :argVersionCode, :argVersionDesc))
	}
	
	q "1"
}

/// d ##Class(DHCEPRFS.Tool.BaseDataMgr).t()
ClassMethod t()
{
	s parentID = $o(^DHCEPRFS.META.QueryFunctionI("IdxFuncName",$zcvt(" Menu_Operation","U"),""))
	&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Operation_Recreate','可重新生成', :parentID,''))
	w !,SQLCODE
	&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Operation_RecreateGreenChannel','可使用绿色通道生成', :parentID,''))
	w !,SQLCODE
	&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Operation_OldCreate','可老病历生成', :parentID,''))
	w !,SQLCODE
}

/// Desc:	初始化扫描状态转换表
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitTransPage()
ClassMethod InitTransPage()
{
	s sc = $$InitOneMRTransPage("INITIALIZED", "REVIEW", "TOSCAN", "1","")
	s sc = $$InitOneMRTransPage("INITIALIZED", "SCAN", "SCANNED", "1","1")
	s sc = $$InitOneMRTransPage("TOSCAN", "SCAN", "SCANNED", "1","1")
	s sc = $$InitOneMRTransPage("SCANNED", "ARRANGE", "ARRANGED", "1","")
	s sc = $$InitOneMRTransPage("ARRANGED", "REPLACE", "REPLACED", "1","")
	s sc = $$InitOneMRTransPage("TOSCAN", "CONFIRMSCAN", "REPLACED", "1","")
	s sc = $$InitOneMRTransPage("SCANNED", "CONFIRMSCAN", "REPLACED", "1","")
	s sc = $$InitOneMRTransPage("ARRANGED", "CONFIRMSCAN", "REPLACED", "1","")
	s sc = $$InitOneMRTransPage("ARRANGED", "SCAN", "SCANNED", "1","1")
	s sc = $$InitOneMRTransPage("REPLACED", "SCAN", "SCANNED", "1","1")
	
InitOneMRTransPage(argPrevStatus, argActionCode, argPostStatus, argIsActive, argExecCondition)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.MRTransPage
		where PrevStatusCode = :argPrevStatus and ActionCode = :argActionCode)
	w !,rowid
	if (rowid = "")
	{
		/*
		&sql(insert into DHCEPRFS_META.MRTransPage (PrevStatusCode, ActionCode, PostStatusCode, IsActive, ExecCondition) 
			values (:argPrevStatus, :argActionCode, :argPostStatus, :argIsActive, :argExecCondition))
		*/
		s obj = ##Class(DHCEPRFS.META.MRTransPage).%New()
		s obj.PrevStatusCode = argPrevStatus
		s obj.ActionCode = argActionCode
		s obj.PostStatusCode = argPostStatus
		s obj.IsActive = argIsActive
		s obj.ExecCondition = argExecCondition
		d obj.%Save()
	}
	
	q "1"
}

/// Desc:	初始化归档状态表
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitMRStatus()
ClassMethod InitMRStatus()
{
	d InitOneMRStatus("INITIALIZED","初始状态","1")
	d InitOneMRStatus("CONFIRMED","病历确认","1")
	d InitOneMRStatus("CREATED","病历生成","1")
	d InitOneMRStatus("REVIEWED","病案复核","1")
	d InitOneMRStatus("CATALOGED","病案编目","1")
	d InitOneMRStatus("TOSCAN","待扫描","1")
	d InitOneMRStatus("SCANNED","病历扫描","1")
	d InitOneMRStatus("ARRANGED","扫描分类","1")
	d InitOneMRStatus("REPLACED","病历替换","1")
	d InitOneMRStatus("CONFIRMSCAN","扫描完成","1")
	
InitOneMRStatus(StatusCode,StatusName,IsActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.MRStatus
		where StatusCode = :StatusCode)
	
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.MRStatus (StatusCode, StatusName, IsActive) 
			values (:StatusCode, :StatusName, :IsActive))
		
		w !, "Insert:"_StatusName
	}
	else
	{
		w !, "IsExisted:"_StatusName
	}
	
	q "1"
}

/// Desc:	初始化打印费用类型
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitMRChargeType()
ClassMethod InitMRChargeType()
{
	&sql(insert into DHCEPRFS_META.MRChargeType (ChargeTypeCode,ChargeTypeName) values ('10', '邮寄费'))
	w !,SQLCODE
	&sql(insert into DHCEPRFS_META.MRChargeType (ChargeTypeCode,ChargeTypeName) values ('20', '基础费'))
	w !,SQLCODE
	&sql(insert into DHCEPRFS_META.MRChargeType (ChargeTypeCode,ChargeTypeName) values ('30', '打印费'))
	w !,SQLCODE
}

/// Desc:	初始化三单一致项目
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitRecordCheck()
ClassMethod InitRecordCheck()
{
	s sc = $$InitRecordCheck("ChargeList","费用清单","dhc.epr.fs.bscheckrecord.csp?MrItemID=19&EpisodeID=[episodeID]","Left","Y","1")
	s sc = $$InitRecordCheck("ChargeQuery","费用明细查询","dhc.epr.fs.jfdetail.csp?PatientID=[patientID]&EpisodeID=[episodeID]&Mradm=[mradm]","Left","Y","1")
	s sc = $$InitRecordCheck("LOrderData","长期医嘱","dhc.epr.fs.bscheckrecord.csp?MrItemID=11&EpisodeID=[episodeID]","Right","Y","1")
	s sc = $$InitRecordCheck("TOrderData","临时医嘱","dhc.epr.fs.bscheckrecord.csp?MrItemID=12&EpisodeID=[episodeID]","Right","Y","1")
	s sc = $$InitRecordCheck("LisData","检验单","epr.chart.csp?PatientID=[patientID]&EpisodeID=[episodeID]&EpisodeIDs=&mradm=[mradm]&ChartID=98&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=","Right","Y","1")
	s sc = $$InitRecordCheck("PacsData","检查单","epr.chart.csp?PatientID=[patientID]&EpisodeID=[episodeID]&EpisodeIDs=&mradm=[mradm]&ChartID=23&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=","Right","Y","1")
	s sc = $$InitRecordCheck("EprData","电子病历","dhc.epr.fs.bscheckrecord.csp?SchemeID=1&ShowLeftNavg=0&EpisodeID=[episodeID]","Right","Y","1")
	s sc = $$InitRecordCheck("EPRData","电子病历","dhc.epr.fs.bscheckrecord.csp?SchemeID=1&ShowLeftNavg=0&EpisodeID=[episodeID]","ViewCatalog","Y","1")
	s sc = $$InitRecordCheck("ChargeQuery2","费用明细查询","dhc.epr.fs.jfdetail.csp?PatientID=[patientID]&EpisodeID=[episodeID]&Mradm=[mradm]","ViewCatalog","Y","1")
	s sc = $$InitRecordCheck("EPRData","电子病历","dhc.epr.fs.bscheckrecord.csp?SchemeID=1&ShowLeftNavg=0&EpisodeID=[episodeID]","Left","Y","1")
	s sc = $$InitRecordCheck("EPRQuality","手工评分","dhc.epr.quality.entrygrid.csp?action=D&EpisodeID=[episodeID]","Right","Y","1")
	
InitRecordCheck(argCheckName,argCheckDesc,argCheckURL,argCheckType,argIsValid,argSequence)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.RecordCheck
		where CheckName = :argCheckName and CheckType = :argCheckType)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.RecordCheck (CheckName,CheckDesc,CheckURL,CheckType,IsValid,Sequence) 
			values (:argCheckName,:argCheckDesc,:argCheckURL,:argCheckType,:argIsValid,:argSequence))
	}
	
	q "1"
}

/// Desc:	初始化历史病案修正表
/// Debug:	d ##Class(DHCEPRFS.Tool.BaseDataMgr).HistoryMedRecordPrefix()
ClassMethod HistoryMedRecordPrefix()
{
	s sc = $$InitHistoryMedRecordPrefix("M")
		
InitHistoryMedRecordPrefix(argPrefix)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.HistoryMedRecordPrefix
		where Prefix = :argPrefix)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.HistoryMedRecordPrefix (Prefix) 
			values (:argPrefix))
	}
	
	q "1"
}

/// Desc: 初始化核心基础数据表的生命周期配置
/// Debug: d ##class(DHCEPRFS.Tool.BaseDataMgr).InitConfigMetaLC()
ClassMethod InitConfigMetaLC()
{
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.SysOption","系统参数","DHCEPRFS.BL.BLMetaLCQuery","GetSysOption","Y","OptionDesc,OptionName,OptionType,OptionValue")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.MRAction","归档动作维护","DHCEPRFS.BL.BLMetaLCQuery","GetMRAction","Y","ActionCode,ActionName,CategoryCode,CategoryName,IsActive,OrderNo")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.RecordCheck","三单一致编目配置","DHCEPRFS.BL.BLMetaLCQuery","GetRecordCheck","Y","CheckDesc,CheckName,CheckType,CheckURL,IsValid,Sequence")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.CTItemType","归档项目csp对照表","DHCEPRFS.BL.BLMetaLCQuery","GetCTItemType","Y","TypeCode,TypeName,TypeDesc,CSPPath,Sequence,ProductSource,InvokeType,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,TypeNote,TypeFlag,CreateType,Company,ProductTeam,CreateTypeSub")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.MRCategory","归档大类","DHCEPRFS.BL.BLMetaLCQuery","GetMRCategory","Y","Name,Code,Description,Sequence")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.MRSubCategory","归档子类","DHCEPRFS.BL.BLMetaLCQuery","GetMRSubCategory","Y","Name,Code,Description,MRCategoryID,Sequence,TypeParam")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.MRItem","归档项目","DHCEPRFS.BL.BLMetaLCQuery","GetMRItem","Y","Name,Code,Description,MRSubCategoryID,Type,TypeParams,Source,Sequence,Attachment,AttachType,SubFlag")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.MRStatus","归档状态","DHCEPRFS.BL.BLMetaLCQuery","GetMRStatus","Y","StatusCode,StatusName,IsActive")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.MRTransition","状态转换","DHCEPRFS.BL.BLMetaLCQuery","GetMRTransition","Y","PrevStatusCode,ActionCode,PostStatusCode,IsActive")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.MRChargeType","收费类型","DHCEPRFS.BL.BLMetaLCQuery","GetMRChargeType","Y","ChargeTypeCode,ChargeTypeName")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.PrintScheme","归档方案","DHCEPRFS.BL.BLMetaLCQuery","GetPrintScheme","Y","SchemeName,SchemeDesc,SchemeType,SchemeOrder,SchemeItems,IsDefault,IsCreate,CreateUserID,CreateDate,CreateTime,ModifyUserID,ModifyDate,ModifyTime,CheckItems,IsAvailable")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.QRCodeInfo","打印二维码内容维护","DHCEPRFS.BL.BLMetaLCQuery","GetQRCodeInfo","Y","Name,Description,ClassName,ClassProperty,ClassPropertyType,Enable,Sequence,CustemNoteInfo")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.QueryFunction","权限功能","DHCEPRFS.BL.BLMetaLCQuery","GetQueryFunction","Y","FuncName,FuncDesc,ParentID,Notes,IsAvailable")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.EstimatePagesItem","计算页数基础项目","DHCEPRFS.BL.BLMetaLCQuery","GetEstimatePagesItem","Y","ItemCode,ItemName,ItemDesc,TypeParam,Type,Available,Sequence,RelatedItems")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.FileStoreConfig","文件系统分布配置","DHCEPRFS.BL.BLMetaLCQuery","GetFileStoreConfig","Y","StartDate,EndDate,FileServerIP,VirtualDir,NameSpace,FileServerUserName,FileServerPassword,FileServerPort,FileServerTimeOut,FTPMethod")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.CTItemInvokeType","归档项目生成调用方式","DHCEPRFS.BL.BLMetaLCQuery","GetCTItemInvokeType","Y","InvokeTypeCode,InvokeTypeName")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.CustomDic","自定义字典","DHCEPRFS.BL.BLMetaLCQuery","GetCustomDic","Y","CtmDictCode,CtmDictDesc,CtmDictAlias,CtmDictType,CtmIsActive,CtmIndex")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.QueryFields","归档查询字段","DHCEPRFS.BL.BLMetaLCQuery","GetQueryFields","Y","FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.ResultColumn","综合查询结果列","DHCEPRFS.BL.BLMetaLCQuery","GetResultColumn","Y","ColDesc,ColName,IsActive,Sequence")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.CreateServer","生成服务器配置","DHCEPRFS.BL.BLMetaLCQuery","GetCreateServer","Y","IP,TaskType")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.ASType","特殊病历类型","DHCEPRFS.BL.BLMetaLCQuery","GetASType","Y","Code,Name,Description")
InitConfigMetaLC(argTableName,argConfigName,argClassName,argQueryFunction,argIsActive,argFields)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ConfigMetaLC
		where TableName = :argTableName)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ConfigMetaLC (TableName,ConfigName,ClassName,QueryFunction,IsActive,Fields) 
			values (:argTableName, :argConfigName, :argClassName, :argQueryFunction, :argIsActive, :argFields))
	}
	
	q "1"
}

/// Desc:	初始化三版病历项目，未增加的添加，已增加的不动
/// Debug:	d ##class(DHCEPRFS.Tool.BaseDataMgr).ReInitFS()
ClassMethod ReInitFS(AMRCategoryID As %String)
{
	d ..InitFS(AMRCategoryID)
	d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitItemDefinition()
	d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitResourceItem()
}

/// Desc: 初始化任务类型
/// Debug: d ##class(DHCEPRFS.Tool.BaseDataMgr).InitCTTaskType()
ClassMethod InitCTTaskType(AMRCategoryID As %String)
{
	&sql(insert into DHCEPRFS_META.CTTaskType(Code,Name,Description,Color) VALUES ('N','普通生成','','255 251 214'))
	&sql(insert into DHCEPRFS_META.CTTaskType(Code,Name,Description,Color) VALUES ('G','绿色通道生成','','148 239 148'))
	&sql(insert into DHCEPRFS_META.CTTaskType(Code,Name,Description,Color) VALUES ('O','老病历生成','','173 219 231'))
	&sql(insert into DHCEPRFS_META.CTTaskType(Code,Name,Description,Color) VALUES ('S','特殊生成','','255 162 123'))
	&sql(insert into DHCEPRFS_META.CTTaskType(Code,Name,Description,Color) VALUES ('D','调试生成','','76 137 192'))
}

/// Desc: 初始化服务器磁盘
/// Debug: d ##class(DHCEPRFS.Tool.BaseDataMgr).InitServerDisk()
ClassMethod InitServerDisk()
{
	s sc=$$InitServerDisk("PDF存储1","D:","本地磁盘D","FTP服务器","127.0.0.1","FTP服务器")

InitServerDisk(argDiskDesc,argDiskDrive,argDiskName,argServerDesc,argServerIP,argServerName)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ServerDisk
		where ServerIP = :argServerIP and DiskDrive = :argDiskDrive)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ServerDisk (DiskDesc,DiskDrive,DiskName,ServerDesc,ServerIP,ServerName) 
			values (:argDiskDesc, :argDiskDrive, :argDiskName, :argServerDesc, :argServerIP, :argServerName))
	}
	
	q "1"
}

/// Desc: 初始化特殊病历类型
/// Debug: d ##class(DHCEPRFS.Tool.BaseDataMgr).InitASType()
ClassMethod InitASType()
{
	s sc=$$InitASType("SEALUP","封存","封存")
	s sc=$$InitASType("DISPUTE","纠纷","纠纷")
	s sc=$$InitASType("SENSITIVITY","敏感","敏感")
InitASType(argCode,argName,argDescription)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ASType
		where Code = :argCode)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ASType (Code,Name,Description) 
			values (:argCode, :argName, :argDescription))
	}
	
	q "1"
}

/// Desc: 初始化新版护理病历归档项目
/// Input: MRSubCategoryID - 护理病历归档子类ID
/// Debug: d ##class(DHCEPRFS.Tool.BaseDataMgr).InitNURItem("")
ClassMethod InitNURItem(AMRSubCategoryID As %String) As %String
{
	s count = 0
	q:(AMRSubCategoryID = "") count
	s strNurCode = ##class(NurMp.Print.FileMedRec).GetCodeStr()
	q:(strNurCode = "") count
	s itemCount = $g(^DHCEPRFS.META.MRItemD)
	
	for i=1:1:$l(strNurCode,"^")
	{
		s oneNurCode = $p(strNurCode,"^",i)
		s printCode = $p(oneNurCode,"|",1)
		s printName = $p(oneNurCode,"|",2)
		s mrItemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType("06B",printCode)
		if (mrItemID = "")
		{
			s itemCount = itemCount+1
			s codeNum = ""
			if $l(itemCount)<4 {
				s $p(codeNum,"0",4-$l(itemCount)) = itemCount
			}
			else {
				s codeNum = itemCount
			}
			s itemCode = "NURItem"_codeNum
			s mrItemID = ##Class(DHCEPRFS.BL.BLMRItem).CreateItem(itemCode,printName,printName,AMRSubCategoryID,"06B",printCode)
			s:(+mrItemID>0) count=count+1
			w "【Init】 MRItem: "_itemCode_" "_printName_" ------ok",!
		}
	}
	q count
}

}

/// 名称:	EMR.OP.COM.ActionFactory
/// 描述:	门诊病历--公用程序层 Request数据请求代理工厂
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.OP.COM.ActionFactory Extends EMR.OP.COM.ActionBase
{

/// Creator：      yejian
/// CreatDate：    2020-12-7
/// Description:   编辑器的命令工厂,解析argInMessage参数，进行分支处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"action":"GET_PATIENTLIST_BYUSERID","params":{"LocID":"6","UserID":"10209","StartDate":"2019-04-01","EndDate":"2020-04-01"},"product":"GlobalEMR"}
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.OP.COM.ActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//定义错误处理函数
	s $ZT="ERROR"
	s array = argInJson
	s strAction = array.action
	d ..DefaultOutMessage(argOutMessage)
	
	//命令分发
	
	if (strAction = "GET_PATIENTLIST_BYUSERID")         
	{	
		//根据用户信息获取患者列表
		d ##Class(EMR.OP.BL.PatientList).GetPatientList(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction ="GET_DEFAULTTEMPLATE")
	{
		//获取门诊病历默认加载的模板
		d ##class(EMR.OP.BL.ClientCategory).GetFirstTmpl(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction ="GET_SAVEDRECORDS")
	{
		//获取门诊病历已保存病历
		d ##class(EMR.OP.BL.ClientCategory).GetSaveRecords(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction ="GET_ALLSAVEDRECORDS")
	{
		//获取门诊病历已保存病历
		d ##class(EMR.OP.BL.ClientCategory).GetAllSaveRecords(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction ="GET_SAVEDRECORDBYDOCUMENTID")
	{
		//根据文档ID获取门诊病历
		d ##class(EMR.OP.BL.ClientCategory).GetSaveRecordByDocumentID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_USER")         
	{	
		//获取用户信息(模拟用的DOC的)
		d ##Class(EMR.DOC.BL.RBACUser).GetUser(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CHEACK_USERID_LOGIC")
	{
		//用户ID验证(模拟用的DOC的)
		d ##Class(EMR.DOC.BL.UserLogin).UserIdLogic(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CHEACK_USER_LOGIN")
	{
		//用户登录验证(模拟用的DOC的)
		d ##Class(EMR.DOC.BL.UserLogin).Login(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PATIENTINFO_BYID")
	{
		//获取患者信息
		d ##class(EMR.OP.BL.PatientList).GetPatientMsg(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_OPRESOURCE")
	{
		//获取门诊病历资源区列表
		d ##class(EMR.OP.BL.OPResource).GetOPResource(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_ALLEPISODEIDBYPATIENTID")
	{
		//根据住院号获取就诊列表
		d ##Class(EMR.DOC.BL.HisData).GetAllEpisodeIDByPID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_OEPEPISODELISTBYPID")
	{
		//获取有门(急)病历记录的就诊列表
		d ##Class(EMR.OP.BL.History).GetOEPEpisodeListByPID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_EPISODE_LIST")
	{
		//获取就诊列表
		d ##Class(EMR.DOC.BL.HisData).GetEpisodeList(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_ORDTYPE")
	{
		//根据住院号获取就诊列表
		d ##Class(EMR.DOC.BL.HisData).GetOrdType(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PACSDATA")
	{
		//获取检查主数据
		d ##Class(EMR.DOC.BL.PacsData).GetPacsData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_SUBPACSDATA")
	{
		//获取检查子数据
		d ##class(EMR.DOC.BL.PacsData).GetSubPacs(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_MULSUBPACSDATA")
	{
		//获取多个检查子数据
		d ##class(EMR.DOC.BL.PacsData).GetMultiSubPacs(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_LISDATA")
	{
		//获取检验主数据
		d ##class(EMR.DOC.BL.LisData).GetLisData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_SUBLISDATA")
	{
		//获取检验子数据
		d ##class(EMR.DOC.BL.LisData).GetSubLisData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_MULSUBLISDATA")
	{
		//获取多个检查子数据
		d ##class(EMR.DOC.BL.LisData).GetMultiSubLis(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PATHOLDATA")
	{
		//获取病理主数据
		d ##class(EMR.OP.BL.PatholData).GetPatholList(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_SUBPATHOL")
	{
		//获取病理子数据
		d ##class(EMR.OP.BL.PatholData).GetSubPatholList(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_OPEMRTOOLBUTTONS")
	{
		//获取门诊病历工具栏按钮数据
		d ##class(EMR.OP.BL.ToolButtons).GetOPEmrToolButtons(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_BINDKBNODE")
	{
		//获取知识库树数据
		d ##class(EMR.DOC.BL.KBTree).GetBindKBNode(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_KB_DOCUMENT")
	{
		//获取文档片段数据
		d ##class(EMR.DOC.BL.KBNode).LoadDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_KBNODETEXT")
	{
		//获取文档片段文本数据
		d ##class(EMR.DOC.BL.KBTree).GetKBNodeText(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_DPCATEGORY")
	{
		//获取个人短语目录树
		d ##class(EMR.DOC.BL.DPCategory).GetDPCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_DPDATA")
	{
		//获取个人短语数据
		d ##class(EMR.DOC.BL.DPCategory).LoadDPData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_DPDATA")
	{
		//新增个人短语
		d ##class(EMR.DOC.BL.DPCategory).CreateDPData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "UP_DPCATENAME")
	{
		//更新个人短语目录名称
		d ##class(EMR.DOC.BL.DPCategory).UpDPCateName(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "STOP_DPDATA")
	{
		//停用个人短语
		d ##class(EMR.DOC.BL.DPCategory).StopDPData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_DPDATA")
	{
		//保存个人短语
		d ##class(EMR.DOC.BL.DPCategory).SaveDPData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SWAP_DPSEQUENCE")
	{
		//个人短语排序
		d ##class(EMR.DOC.BL.DPCategory).SwapDPSequence(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "UP_DPCATEGORYID")
	{
		//个人短语排序
		d ##class(EMR.DOC.BL.DPCategory).UPDPCategoryID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PERCATEGORY_DATA")
	{
		//获取个人模板导航目录
		d ##class(EMR.OP.BL.ClientCategory).GetPerCategoryData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PERCATEGORYBYID")
	{
		//获取个人模板管理目录
		d ##class(EMR.DOC.BL.PerTemplateCategory).GetPerCategroyByID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_PERCATEGORY")
	{
		//新增个人模板目录
		d ##class(EMR.DOC.BL.PerTemplateCategory).CreatePerCategroy(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "UP_PERCATEGORY")
	{
		//更新个人模板目录
		d ##class(EMR.DOC.BL.PerTemplateCategory).UpPerCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "DEL_PERCATEGORY")
	{
		//更新个人模板目录
		d ##class(EMR.DOC.BL.PerTemplateCategory).DelPerCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SWAP_PERSEQUENCE")
	{
		//个人模板节点排序
		d ##class(EMR.DOC.BL.PerTemplateCategory).SwapPerSequence(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "UP_PERCATEGORYID")
	{
		//更新个人节点目录ID
		d ##class(EMR.DOC.BL.PerTemplateCategory).UPPerCategoryID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "ADD_PERTEMPLATE")
	{
		//新增个人模板
		d ##class(EMR.DOC.BL.PerTemplate).AddPerTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_PERTEMPLATE")
	{
		//保存个人模板
		d ##class(EMR.DOC.BL.PerTemplate).SavePerTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_PERTEMPLATE")
	{
		//加载个人模板章节
		d ##class(EMR.DOC.BL.PerTemplate).LoadPerTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "PERIS_SHARETOLOC")
	{
		//判断是否已分享过当前科室的科室模板
		d ##class(EMR.DOC.BL.PerTemplate).PerIsShareToLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "PER_SHARETOLOC")
	{
		//个人模板分享当前科室的科室模板
		d ##class(EMR.DOC.BL.PerTemplate).PerShareToLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_IMAGECATEGORY")
	{
		//获取图库目录树
		d ##class(EMR.DOC.BL.ImageData).GetImageCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_IMAGE_COMMONITEM")
	{
		//获取通用图片节点数据
		d ##class(EMR.DOC.BL.ImageData).GetImageCommonItem(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_IMAGE_USERITEM")
	{
		//获取个人图片节点数据
		d ##class(EMR.DOC.BL.ImageData).GetImageUserItem(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_IMAGEDATA")
	{
		//获取个人图片节点数据
		d ##class(EMR.DOC.BL.ImageData).GetImageData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "ADD_USERIMAGE")
	{
		//收藏个人图片
		d ##class(EMR.DOC.BL.ImageData).AddUserImage(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "DELETE_USERIMAGE")
	{
		//取消收藏个人图片
		d ##class(EMR.DOC.BL.ImageData).DeleteUserImage(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "UP_USERIMGFREQ")
	{
		//更新个人图片使用频次
		d ##class(EMR.DOC.BL.ImageData).UpUserIMGFreq(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_OPTEMPLATECLASSIFY")
	{
		//获取文档目录树数据
		d ##class(EMR.OP.BL.TemplateCategory).GetTemplateTree(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_DOCUMENT")
	{
		//创建门诊病历文档实例
		d ##class(EMR.DOC.BL.DocumentData).CreateDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_DOCUMENT")
	{
		//保存门诊病历文档实例
		d ##class(EMR.DOC.BL.DocumentData).SaveDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "DELETE_DOCUMENT")
	{
		//删除门诊病历文档
		d ##class(EMR.DOC.BL.DocumentData).DeleteDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_EMRSAVEDRECORDS")
	{
		//获取文档实例列表
		d ##class(EMR.OP.BL.InstanceSaveDatas).GetEMRSaveRecords(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_DOCUMENT_INDEX")         
	{	
		//加载文档索引
		d ##Class(EMR.DOC.BL.DirectoryInformation).GetDocumentIndex(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "BROWSE_DOCUMENT_INDEX")         
	{	
		//浏览加载文档索引(加密)
		d ##Class(EMR.DOC.BL.DirectoryInformation).GetEncDocumentIndex(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_DOCUMENT")
	{
		//获取文档实例数据
		d ##class(EMR.DOC.BL.DocumentData).LoadDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "BROWSE_DOCUMENT")
	{
		//浏览获取实例数据(加密)
		d ##class(EMR.DOC.BL.DocumentData).LoadEncDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_DOCCATEGORY_DATA")
	{
		//获取模板导航数据
		d ##class(EMR.OP.BL.ClientCategory).GetDocCategoryData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_LOCCATEGORY_DATA")
	{
		//获取科室模板导航数据
		d ##class(EMR.OP.BL.ClientCategory).GetLocCategoryData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_LOCTEMPLATE")
	{
		//获取科室模板章节
		d ##Class(EMR.DOC.BL.LocTemplateSection).LoadLocTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_GLOBAL_PARAMETERS")
	{
		//获取编辑器全局系统参数
		d ##class(EMR.DOC.BL.SysOption).LoadGlobalParameters(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_SERVER_TIME")
	{
		//获取指定格式的服务器时间
		d ##class(EMR.DOC.BL.DateTimeStandSrv).GetServerTime(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_STANDARD_DATE")
	{
		//获取服务器时间格式
		d ##class(EMR.DOC.BL.DateTimeStandSrv).GeStandardDate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_DATEFORMAT")
	{
		//获取服务器时间格式
		d ##class(EMR.DOC.BL.DateTimeStandSrv).GeDateFormat(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PRIVILEGE")
	{
		//获取权限脚本
		d ##class(EMR.DOC.BL.PrivRuleData).GetPrivilege(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_PRIVILEGE")
	{
		//病历创建权限
		d ##class(EMR.DOC.BL.PrivRuleData).LoadPrivilege(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_PRIVILEGE")
	{
		//获取权限脚本
		d ##class(EMR.DOC.BL.PrivRuleData).CreatePrivilege(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "BROWSE_PRIVILEGE")
	{
		//获取病历浏览权限
		d ##class(EMR.DOC.BL.PrivRuleData).GetBrowsePrivilege(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "QUOTE_PRIVILEGE")
	{
		//获取病历引用权限
		d ##class(EMR.DOC.BL.PrivRuleData).GetQuotePrivilege(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_CURRENT_STATUS")
	{
		//获取病历状态信息
		d ##class(EMR.DOC.BL.UserMessage).GetCurrentStatus(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_DEFAULT_FIELD")
	{
		//取数据绑定值
		d ##Class(EMR.DOC.BL.BindDataSelect).LoadDefaultField(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SET_REFRESHDATA_HIDDENCODE")
	{
		//设置同步项默认不显示
		d ##Class(EMR.DOC.BL.RefreshDataHidden).SetRefreshDataHiddenCode(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_REFRESHDATA_HIDDENCODE")
	{
		//获取数据同步项默认不显示项
		d ##Class(EMR.DOC.BL.RefreshDataHidden).GetRefreshDataHiddenCode(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_USER_DATA")
	{
		//获取用户信息(用户级别)
		d ##Class(EMR.OP.BL.UserData).GetUserData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_SYSOPTION")
	{
		//获取单个系统参数
		d ##Class(EMR.DOC.BL.SysOption).GetSysOption(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_SYSOPTIONS")
	{
		//获取多个系统参数
		d ##Class(EMR.DOC.BL.SysOption).GetSysOptions(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DICTIONARY")
	{
		//获取字典数据
		d ##Class(EMR.DOC.BL.StdDictionary).LoadDictionary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CLOSE_DICTIONARY")
	{
		//清除字典数据
		d ##Class(EMR.DOC.BL.StdDictionary).CloseDictionnary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CLIENTINFO")
	{
		//获取客户端信息
		d ##Class(EMR.OP.BL.ClientMessage).GetClientInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RECORDCREATORINFO")
	{
		//获取病历的创建者信息
		d ##class(EMR.DOC.BL.UserMessage).GetRecordCreatorInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="VERIFY_USER")
	{
		//获取病历的创建者信息
		d ##class(EMR.DOC.BL.UserMessage).VerifyUser(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_LINK")
	{
		//获取门诊病历链接单元配置
		d ##class(EMR.OP.BL.LinkData).GetLink(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_DIAG")
	{
		//获取门诊病历链接单元诊断数据
		d ##class(EMR.OP.BL.LinkData).GetDiag(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_OEORD")
	{
		//获取门诊病历链接单元医嘱数据
		d ##class(EMR.OP.BL.LinkData).GetOeord(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_OEORDCN")
	{
		//获取门诊病历链接单元中草药数据
		d ##class(EMR.OP.BL.LinkData).GetOeordCN(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_ALLERGIC")
	{
		//获取门诊病历链接单元过敏史数据
		d ##class(EMR.OP.BL.LinkData).GetAllergic(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_USER_CONFIG")
	{
		//获取用户配置数据
		d ##class(EMR.DOC.BL.UserConfig).GetUserConfig(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="SET_USER_CONFIG")
	{
		//保存用户配置数据
		d ##class(EMR.DOC.BL.UserConfig).SetUserConfig(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_TEMPLATEBYTID")
	{
		//根据模板ID获取发布模板
		d ##Class(EMR.DOC.BL.TemplateVersion).LoadTemplateByTID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_TEMPLATEDATABYDOCUMENTID")
	{
		//根据文档ID获取病历所用的模板数据
		d ##class(EMR.OP.BL.Template).GetTemplateDataByDocumentID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ISCAN_CREATE")
	{
		//判断患者是否可以创建模板病历
		d ##Class(EMR.DOC.BL.DocumentData).IsCanCreate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CASERVICE")
	{
		//获取CA服务是否开启
		d ##Class(EMR.DOC.BL.CASservice).GetCAService(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CASERVICE_JS")
	{
		//获取CA服务是否开启
		d ##Class(EMR.DOC.BL.CASservice).GetCAServiceJS(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CASIGNDETAIL")
	{
		//获取CA签名值和时间戳
		d ##Class(EMR.DOC.BL.CASservice).GetCASignDetail(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "OUTPUT_HANDSIGNJS")
	{
		//获取患者签是否开启，并返回JS服务
		d ##Class(EMR.DOC.BL.CASservice).OutPutHandSignJS(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ANYSIGN_LOCATION")
	{
		//获取患者签配置信息
		d ##Class(EMR.DOC.BL.CASservice).GetAnySignLocation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_HANDSIGN_TYPE")
	{
		//获取可用患者签名方式列表
		d ##Class(EMR.DOC.BL.PatientSign).GetHandSignType(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_USERINFO")
	{
		//登录用户验证和签名图片
		d ##Class(EMR.DOC.BL.EMRSign).GetUserInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CAUSERINFO")
	{
		//CA登录用户验证和签名图片
		d ##Class(EMR.DOC.BL.EMRSign).GetCAUserInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SIGN_CHARACTER")
	{
		//获取签名角色(签名、撤销签名)
		d ##Class(EMR.DOC.BL.EMRSign).GetSignCharacter(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SIGN_DOCCHARACTER")
	{
		//获取文档签名角色(签名失效、留痕)
		d ##Class(EMR.DOC.BL.EMRSign).GetSignDocCharacter(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "IS_SUPERIORSIGN")
	{
		//判断是否上级医师已签名
		d ##Class(EMR.DOC.BL.EMRSign).IsSuperiorSign(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CHECK_PRIVILEGE")
	{
		//检查签名权限脚本
		d ##Class(EMR.DOC.BL.EMRSign).CheckPrivilege(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RECORDINFO")
	{
		//获取签名文档信息
		d ##Class(EMR.DOC.BL.EMRSign).GetRecordInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "QUALITY_CHECK")
	{
		//病历数据质控
		d ##Class(EMR.OP.BL.QualityCheck).QualityCheck(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_SIGNED_DOCUMENT")
	{
		//保存签名文档(医护签名)
		d ##Class(EMR.DOC.BL.EMRSignDocument).SaveSignedDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_PATIENTSIGNINFO")
	{
		//获取患者签名角色信息
		d ##Class(EMR.DOC.BL.EMRSign).GetPatientSignInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "PATIENT_SIGNED_DOCUMENT")
	{
		//保存签名文档(患者签名)
		d ##Class(EMR.DOC.BL.EMRSignDocument).PatientSignedDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CAN_DOPDF_SIGN")
	{
		//文档是否可以做患者端PDF签名
		d ##Class(EMR.DOC.BL.PDFAuditSignLog).CanDoPDFSign(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_PDF_BASE64")
	{
		//获取患者的PDF数据
		d ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFBase64(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "PDF_PUSH_SIGN")
	{
		//保存签名文档(PDF签名)
		d ##Class(EMR.DOC.BL.EMRSignDocument).PDFPushSign(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_PATPUSHSIGNID")
	{
		//获取推送签名的ID
		d ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPatPushSignID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "FETCH_SIGNRESULT")
	{
		//获取推送签名结果信息
		d ##Class(EMR.DOC.BL.PDFAuditSignLog).FetchSignResult(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "INVALID_SIGNEDPDF")
	{
		//获取推送签名结果信息
		d ##Class(EMR.DOC.BL.PDFAuditSignLog).InvalidSignedPDF(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "REVOKE_SIGNED")
	{
		//失效签名(撤销签名)
		d ##Class(EMR.DOC.BL.EMRSignDocument).RevokeSigned(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "VERIFY_SIGNED_DATA")
	{
		//验签服务
		d ##Class(EMR.DOC.BL.EMRSign).VerifySignedData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RESOURCETABS")
	{
		//获取门诊资源区tab页签配置
		d ##Class(EMR.OP.BL.OPResource).GetOPResource(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ADMBYDOCUMENTID")
	{
		//根据文档ID获取就诊号（判断是否串患者）
		d ##Class(EMR.DOC.BL.DocumentData).GetAdmByDocID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TOOLBUTTONS")
	{
		//获取门诊病历工具栏按钮
		d ##Class(EMR.OP.BL.SysOption).GetEmrButtons(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_REFCREATETEMPLATEID")
	{
		//获取历史就诊引用创建模板服务
		d ##Class(EMR.OP.BL.SysOption).GetRefCreateTemplateID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DETAILLOG")
	{
		//获取门诊当前病历日志
		d ##Class(EMR.DOC.BL.EMRLogsView).GetDetailLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALLLOG")
	{
		//获取门诊患者病历日志
		d ##Class(EMR.DOC.BL.EMRLogsView).GetAllLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SPECHARS")
	{
		//获取门诊工具栏特殊字符
		d ##Class(EMR.DOC.BL.Spechars).GetSpechars(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALLOPHISTORY")
	{
		//获取门诊历史就诊
		d ##Class(EMR.OP.BL.History).GetAllOPHistory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_OPHISTORY")
	{
		//获取指定就诊日期之前的就诊
		d ##Class(EMR.OP.BL.History).GetOPHistory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TODAYPRINTLIST")
	{
		//根据登记号获取当日门诊病历的打印记录
		d ##Class(EMR.OP.BL.SelfPrint).GetTodayPrintList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SELFPRINT_PARAM")
	{
		//获取自助打印的CSP地址
		d ##Class(EMR.OP.BL.SelfPrint).GetSelfPrintParam(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "PRINT_ENCDOCUMENT")
	{
		//打印文档(病历打印、自助打印、归档打印)
		d ##Class(EMR.DOC.BL.DocumentPrintRecord).PrintEncDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "PRINT_DOCUMENT")
	{
		//打印文档(病历打印)
		d ##Class(EMR.DOC.BL.DocumentPrintRecord).PrintDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_OPPATLIST")
	{
		//获取门急诊断证明书审核就诊列表
		d ##Class(EMR.OP.BL.DiagCertificateAudit).GetOPPatList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_OPPATINFO")
	{
		//门急诊断证明书审核获取患者信息
		d ##Class(EMR.OP.BL.DiagCertificateAudit).GetOPPatInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DOCTYPEDATA")
	{
		//门急诊断证明书审核获取文档类型
		d ##Class(EMR.OP.BL.DiagCertificateAudit).GetDocTypeData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SSUSERBYLOCID")
	{
		//门急诊断证明书审获取审核人列表
		d ##Class(EMR.OP.BL.DiagCertificateAudit).GetSSUserByLocID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DIAGAUDITLOG")
	{
		//门急诊断证明书审核获取审核日志
		d ##Class(EMR.OP.BL.DiagCertificateAudit).GetDiagAuditLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "INSERT_DIAGAUDITLOG")
	{
		//门急诊断证明书审核添加审核日志
		d ##Class(EMR.OP.BL.DiagCertificateAudit).InsertDiagAuditLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DIAGAUDITANDPRINTLOG")
	{
		//门急诊断证明书审核获取审核打印日志
		d ##Class(EMR.OP.BL.DiagCertificateAudit).GetDiagAuditAndPrintLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_OPPATCHPRINT")
	{
		//门急诊病历补打获取补打列表
		d ##Class(EMR.OP.BL.PatchPrint).GetOPPatchPrint(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_OPPRINTBROWSEURL")
	{
		//门急诊病历补打获取浏览URL地址
		d ##Class(EMR.OP.BL.PatchPrint).GetOPPrintBrowseUrl(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_VERSIONID")
	{
		//获取病历版本标识(三版、四版)
		d ##Class(EMR.DOC.BL.GlobalData).GetVersionID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DOCUMENT_BYEPISODEID")
	{
		//门急诊病历总览获取该患者所有文档ID
		d ##Class(EMR.OP.BL.DocumentViewPrint).LoadDocumentBYEpisodeID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DOCHASACTION")
	{
		//获取文档是否有打印
		d ##Class(EMR.DOC.BL.EMRLogsView).GetDocHasAction(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TOOTHPOSITION")
	{
		//获取所有牙位信息
		d ##Class(EMR.DOC.BL.Tooth).GetToothPosition(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TOOTHSURFACE")
	{
		//获取所有牙面信息
		d ##Class(EMR.DOC.BL.Tooth).GetToothSerface(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_LASTPRINTDATA")
	{
		//获取最新打印记录信息
		d ##Class(EMR.DOC.BL.DocumentPrintRecord).GetLastPrintData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RECORDBYDOCUMENTID")
	{
		//根据文档ID获取门诊病历实例的数据
		d ##Class(EMR.OP.BL.ClientCategory).GetRecordByDocumentID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "HAS_LOCKED")
	{
		//判断病历是否已经被加锁
		d ##Class(EMR.DOC.BL.Lock).HasLocked(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DOC_LOCK")
	{
		//病历加锁
		d ##Class(EMR.DOC.BL.Lock).DocLock(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UN_LOCK")
	{
		//病历解锁
		d ##Class(EMR.DOC.BL.Lock).UnLock(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ISREFRESH_DOCUMENT")
	{
		//解锁后病历刷新
		d ##Class(EMR.DOC.BL.Lock).IsRefreshDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_LOCKLIST")
	{
		//解锁后病历刷新
		d ##Class(EMR.DOC.BL.Lock).GetLockList(array,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","action操作不存在",2)
	}
	

	q "1"
	
ERROR			
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000",2)
}

}

/// 名称:	EMR.IP.COM.ActionFactory
/// 描述:	住院病历--公用程序层 Request数据请求代理工厂
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.IP.COM.ActionFactory Extends EMR.IP.COM.ActionBase
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
	if (strAction = "GET_VERSIONID")         
	{	
		//获取病历版本标识(三版、四版)
		;d ##Class(EMR.DOC.BL.GlobalData).GetVersionID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_NAVPARAM")         
	{	
		d ##Class(EMR.IP.BL.BLClientCategory).GetNavParam(array,argInData,argOutMessage,argOutData)
		
	}
	elseif(strAction = "GET_HANDSIGNOPTION")         
	{	
		d ##Class(EMR.IP.BL.BLPatSign).GetHandSignOption(array,argInData,argOutMessage,argOutData)
		
	}
	elseif(strAction = "GET_TOOLNAV_SYSOPTION")         
	{	
		d ##Class(EMR.IP.BL.BLToolNav).GetToolNavSysOption(array,argInData,argOutMessage,argOutData)
		
	}
	elseif(strAction = "GET_NAVLIST_SYSOPTION")         
	{	
		d ##Class(EMR.IP.BL.BLToolNav).GetNavListSysOption(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "GET_CDSS_JS")         
	{	
		d ##Class(EMR.IP.BL.BLCDSS).GetCDSSJS(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "GET_PATDISEASE")         
	{	
		d ##Class(EMR.IP.BL.BLPatDisease).GetPatDisease(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "GET_DISEASEBYDIAGNOS")         
	{	
		d ##Class(EMR.IP.BL.BLDiagnos).GetDiseaseByDiagnos(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "SAVE_ADMPATTYPE")         
	{	
		d ##Class(EMR.IP.BL.BLPatDisease).SaveAdmPatType(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "ADD_TEMPLATECOLLECT")         
	{	
		d ##Class(EMR.IP.BL.BLCollectTemplate).AddCollectTemplate(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "REMOVE_TEMPLATECOLLECT")         
	{	
		d ##Class(EMR.IP.BL.BLCollectTemplate).RemoveCollectTemplate(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "SET_INSTANCE_MEMO")         
	{	//增加备注信息
		d ##Class(EMR.IP.BL.BLDocumentData).SetInstanceMemo(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "CHECK_CATEGORYINLOC")         
	{	//验证文件是否有导航权限
		d ##Class(EMR.IP.BL.BLEMRTScheme).CheckCategoryInLoc(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "GET_USERTEMPLATECTLOSCS")         
	{	//获取科室模板科室数据（改名字*）
		d ##Class(EMR.IP.BL.BLLocTemplate).GetLocTemplateCTLoc(array,argInData,argOutMessage,argOutData)	
	}
	elseif(strAction = "GET_INSTANCEJSONBYCATEGORY")         
	{	//获取category下的实例数据
		d ##Class(EMR.IP.BL.BLDocumentData).GetInstanceJsonByCategory(array,argInData,argOutMessage,argOutData)	
	}
	elseif (strAction = "GET_CATEGORYJSON")
	{
		//获取category信息
		d ##class(EMR.IP.BL.BLClientCategory).GetCategoryJson(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_DOCCATEGORY_DATA")
	{
		//获取模板导航数据
		d ##class(EMR.IP.BL.BLClientCategory).GetDocCategoryData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_LOCCATEGORY_DATA")
	{
		//获取科室模板导航数据
		d ##class(EMR.IP.BL.BLClientCategory).GetLocCategoryData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PERCATEGORY_DATA")
	{
		//获取科室模板导航数据
		d ##class(EMR.IP.BL.BLClientCategory).GetPerCategoryData(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_INFORMEDCTLOCS")
	{
		//获取病历展现中知情告知关联的所有科室
		d ##class(EMR.IP.BL.BLEMRTScheme).GetInformedCTLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_TITLECONFIG")
	{
		//获取标题信息 GET_TITLECONFIG
		d ##class(EMR.IP.BL.BLTitle).GetTileConfig(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_INS_CREATEDATETIME")
	{
		//获取实例的创建日期时间 GET_INS_CREATEDATETIME
		d ##class(EMR.IP.BL.BLDocumentData).GetInsCreateDateTime(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CAN_CREATEBYEPSISODETIME")
	{
		//判断病程时间是否小于入院时间大于出院时间
		d ##class(EMR.IP.BL.BLTitle).CanCreateByEpisodeTime(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CAN_CREATEBYFIRSTRECORD")
	{
		//标题发生时间与首次病程日期比较 CAN_CREATEBYFIRSTRECORD
		d ##class(EMR.IP.BL.BLTitle).CanCreateByFirstRecord(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PATIENTINFO_BYEPISODEID")
	{
		//获取患者信息 GET_PATIENTINFO_BYEPISODEID
		d ##class(EMR.IP.BL.BLHIS).GetPatientInfoByEpisodeID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_TITLEDOCTORS")
	{
		//获取标题医师范围 GET_TITLEDOCTORS
		d ##class(EMR.IP.BL.BLTitle).GetTitleDoctors(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_GLOBAL_PARAMETERS")
	{
		//获取编辑器全局系统参数
		d ##class(EMR.DOC.BL.SysOption).LoadGlobalParameters(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_DOCUMENT")
	{
		//创建病历文档实例
		d ##class(EMR.DOC.BL.DocumentData).CreateDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DEFAULT_FIELD")
	{
		//取数据绑定值
		d ##Class(EMR.DOC.BL.BindDataSelect).LoadDefaultField(array,argInData,argOutMessage,argOutData)
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
	
	elseif (strAction = "GET_ALLEPISODEIDBYPATIENTID")
	{
		//根据住院号获取就诊列表
		d ##Class(EMR.DOC.BL.HisData).GetAllEpisodeIDByPID(array,argInData,argOutMessage,argOutData)
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
	elseif(strAction = "LOAD_LOCTEMPLATE")
	{
		//获取科室模板章节
		d ##Class(EMR.DOC.BL.LocTemplateSection).LoadLocTemplate(array,argInData,argOutMessage,argOutData)
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
		//需要处理（w 输出js的逻辑）
		d ##Class(EMR.IP.BL.BLCAService).GetCAServiceJS(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CASIGNDETAIL")
	{
		//获取CA签名值和时间戳
		d ##Class(EMR.DOC.BL.CASservice).GetCASignDetail(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "OUTPUT_HANDSIGNJS")
	{
		//获取患者签是否开启，并返回JS服务
		d ##Class(EMR.IP.BL.BLCAService).OutPutHandSignJS(array,argInData,argOutMessage,argOutData)
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
	elseif(strAction = "GET_ADMBYDOCUMENTID")
	{
		//根据文档ID获取就诊号（判断是否串患者）
		d ##Class(EMR.DOC.BL.DocumentData).GetAdmByDocID(array,argInData,argOutMessage,argOutData)
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
	elseif(strAction = "GET_VERSIONID")
	{
		//获取病历版本标识(三版、四版)
		d ##Class(EMR.DOC.BL.GlobalData).GetVersionID(array,argInData,argOutMessage,argOutData)
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
	elseif (strAction = "GET_CURRENT_STATUS")
	{
		//获取病历状态信息
		d ##class(EMR.DOC.BL.UserMessage).GetCurrentStatus(array,argInData,argOutMessage,argOutData)
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
	elseif (strAction = "GET_SERVER_TIME")
	{
		//获取指定格式的服务器时间
		d ##class(EMR.DOC.BL.DateTimeStandSrv).GetServerTime(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_PATCAOFFREASON")
	{
		//获取患者不能签名原因 GET_PATCAOFFREASON
		d ##class(EMR.IP.BL.BLCAService).GetPatCAOffReason(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_TEMPLATEDATABYDOCUMENTID")
	{
		//8、根据文档ID获取病历所用的模板数据 GET_TEMPLATEDATABYDOCUMENTID
		d ##class(EMR.IP.BL.BLTemplate).GetTemplateDataByDocumentID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_REFRESHDATA_HIDDENCODE")
	{
		//11、获取数据同步项默认不显示项 GET_REFRESHDATA_HIDDENCODE
		d ##Class(EMR.DOC.BL.RefreshDataHidden).GetRefreshDataHiddenCode(array,argInData,argOutMessage,argOutData)

	}
	elseif(strAction = "QUALITY_CHECK")
	{
		//10、检查质控 QUALITY_CHECK
		d ##Class(EMR.IP.BL.BLQualityCheck).QualityCheck(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_COMMITRECORDSTATUS")
	{
		//13、获取病历提交状态 GET_COMMITRECORDSTATUS
		d ##Class(EMR.IP.BL.BLRecordStatus).GetCommitRecordStatus(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CHANGE_RECORDSTATUS")
	{
		////14、修改病历提交状态 CHANGE_RECORDSTATUS
		d ##Class(EMR.IP.BL.BLRecordStatus).ChangeRecordStatus(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RECORDCREATORINFO")
	{
		//获取病历的创建者信息
		d ##class(EMR.DOC.BL.UserMessage).GetRecordCreatorInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "TOOLBAR_PRIVILEGE")
	{
		//12、获取工具栏权限 TOOLBAR_PRIVILEGE
		d ##class(EMR.DOC.BL.PrivRuleData).GetToolBarPrivilege(array,argInData,argOutMessage,argOutData)
	}elseif(strAction = "GET_SERIALINSTIDBYCATEGORY")
	{
		//获取category下连续显示的已保存的创建时间最晚的实例ID GET_SERIALINSTIDBYCATEGORY
		d ##class(EMR.IP.BL.BLDocumentData).GetSerialInstIDByCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction ="GET_SAVEDRECORDBYDOCUMENTID")
	{
		//根据文档ID获取病历
		d ##class(EMR.IP.BL.BLClientCategory).GetSaveRecordByDocumentID(array,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR",strAction_"操作不存在",2)
	}
	
	
	q "1"
	
ERROR			
	q ..SetOutMessage(argOutMessage,"ERROR","服务器异常"_$ze,2)
}

}

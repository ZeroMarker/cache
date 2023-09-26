/// 名称:	EMR.DOC.TOOL.InitStandardDataTool
/// 描述:	通用文档管理模块 Document(Doc) 通用文档初始化工具类
/// 编写者:	yejian
/// 编写日期: 	2020-12-16
/// 产品组：	电子病历产品组
Class EMR.DOC.TOOL.InitStandardDataTool Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Desc:       初始化项目
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitAll()
ClassMethod InitAll()
{
	//初始化项目字典表
	d ##Class(EMR.DOC.BL.Products).InitData()
	//初始化功能字典类型表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDictFunctionType()
	//初始化功能字典表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDictFunction("D:\EMRDOC\01_DicFcuntion.txt")
	//初始化基础字典表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitStdDictionary("D:\EMRDOC\08_StdDictionary.txt")
	//添加角色数据
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACDataTypes()
	//初始化角色类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACRoleTypes()
	//添加数据权限类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACDataPerTypes()
	//初始化模板类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateTypes()
	//初始化元素类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemElementTypes()
	//初始化工具栏
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemToolButtons()
	//初始化元素工具栏
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemElementTools()
	//初始化元素属性
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemElementDatas("D:\EMRDOC\02_TemElementDatas.txt")
	//添加角色
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACRole("D:\EMRDOC\11_CF.EMR.DOC.RBACRole.txt")
	//添加用户
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACUser()
	//添加业务数据模型类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBDMTypes()
	//添加文档目录结构类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateCTypes()
	//初始化业务数据结构目录
	;d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBDMCategory("D:\EMRDOC\03_BDMCategory.txt")
	//初始化数据绑定值类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindValueTypes()
	//初始化数据绑定方法
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindTypes()
	//初始化数据绑定参数集
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindParameterValues()
	//初始化数据集
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindSysData("D:\EMRDOC\04_BindSysData.txt")
	//初始化文档片段目录类型 
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitKBCategoryTypes()
	//将业务数据模型数据初始化为文档片段
	;d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitKBCategory()
	//初始化模板目录数据
	;d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateCategory("D:\EMRDOC\05_TemplateCategory.txt")
	//初始化系统参数（DOC）
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDocSysOption("/import/06_DocSysOption.txt")
	//初始化文档版式目录数据
	;d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitHFFormatCategory("D:\EMRDOC\09_HFFormatCategory.txt")
	//将旧版术语集书记初始化到新版术语集中
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitGlossaryData()
	//初始化术语关联类型
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitGlossaryItemType()
	//初始化元素值类型数据
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitGlossaryItemValues()
	//初始化编辑区工具栏配置数据
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEditToolbar()
	//初始化方案类型码表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRTSchemeType()
	//初始化方案规则类型码表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRTSRuleType()
	//初始化日志类型码表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSysOperateTypes()
	//初始化文档分组数据
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateGroup()
	//初始化图库目录数据
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitImageCategory("D:\EMRDOC\12_CF.EMR.DOC.ImageCategory.txt")
	//初始化菜单路由表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRoutingMenu("D:\EMRDOC\10_RoutingMenu.txt")
	//初始化病历状态表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRStatus("D:\13_CF.EMR.DOC.EMRStatus.txt")
	//初始化病历操作表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRAction("D:\14_CF.EMR.DOC.EMRAction.txt")
	//初始化病历状态、操作关联表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRActStatusCfg("D:\15_CF.EMR.DOC.EMRActStatusCfg.txt")
	//初始化用户级别关联表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSignRoleLinkCPT("D:\16_CF.EMR.DOC.SignRoleLinkCPT.txt")
	//初始化权限规则参数表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitPrivRuleList("D:\17_CF.EMR.DOC.PrivRuleList.txt")
	//初始化权限规则仓库表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitPrivRuleStore("D:\18_CF.EMR.DOC.PrivRuleStore.txt")
	//初始化链接单元配置
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitLinkConfig("D:\19_CF.EMR.DOC.LinkConfig.txt")
	//初始化资源区内容配置
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitResource("D:\20_CF.EMR.DOC.Resource.txt")
	//初始化签名角色表
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSignRole("D:\21_CF.EMR.DOC.SignRole.txt")
	//初始化特殊字符
	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSpechars()
}

/// Desc:       初始化数据节点
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitNodeConfig()
ClassMethod InitNodeConfig()
{
	//&sql(DELETE FROM CF_EMR_DOC.NodeConfig)
	k ^CF.EMR.DOC.NodeConfigI
	k ^CF.EMR.DOC.NodeConfigD
	s sdate = $zdh("01/01/2022"),edate = $zdh("12/31/2022")
	&sql(INSERT INTO CF_EMR_DOC.NodeConfig d(d.NodeID,d.DateFrom,d.DateTo) VALUES ('DB',:sdate,:edate))
	s sdate = $zdh("01/01/2023"),edate = $zdh("12/31/2023")
	&sql(INSERT INTO CF_EMR_DOC.NodeConfig d(d.NodeID,d.DateFrom,d.DateTo) VALUES ('DB1',:sdate,:edate))
}

/// Desc:       初始化菜单路由表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDictFunction("D:\01_DicFcuntion.txt")
ClassMethod InitRoutingMenu(argFile As %String)
{
	k ^CT.EMR.DOC.RoutingMenuI
	k ^CT.EMR.DOC.RoutingMenuD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s Compoent = $p(Line,$c(9),2)
		s Icon = $p(Line,$c(9),5)
		s IsExist = $p(Line,$c(9),6)
		s MenuName = $p(Line,$c(9),7)
		s MenuType = $p(Line,$c(9),8)
		s OrderNum = $p(Line,$c(9),9)
		s ParentId = $p(Line,$c(9),11)
		s Path = $p(Line,$c(9),12)
		s Perms = $p(Line,$c(9),13)
		s Status = $p(Line,$c(9),14)
		s UpdateTime = $p(Line,$c(9),16)
		s Visible = $p(Line,$c(9),17)
		s obj=##Class(CT.EMR.DOC.RoutingMenu).%New()
		s obj.Component = Compoent
		s obj.Icon = Icon
		s obj.IsExist = IsExist
		s obj.MenuName = MenuName
		s obj.MenuType = MenuType
		s obj.OrderNum = OrderNum
		s obj.ParentId = ParentId
		s obj.Path = Path
		s obj.Perms = Perms
		s obj.Status = Status
		s obj.UpdateTime = UpdateTime
		s obj.Visible = Visible
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"10_RoutingMenu: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化图库目录表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDictFunction("D:\01_DicFcuntion.txt")
ClassMethod InitImageCategory(argFile As %String)
{
	k ^CF.EMR.DOC.ImageCategoryI
	k ^CF.EMR.DOC.ImageCategoryD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s obj=##Class(CF.EMR.DOC.ImageCategory).%New()
		s obj.Code = $p(Line,$c(9),1)
		s obj.Description = $p(Line,$c(9),2)
		s obj.ImageCount = $p(Line,$c(9),3)
		s obj.IsExist = $p(Line,$c(9),4)
		s obj.Name = $p(Line,$c(9),5)
		s obj.ParentID = $p(Line,$c(9),6)
		s obj.Sequence = $p(Line,$c(9),7)
		s obj.Type = $p(Line,$c(9),8)
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"12_CF.EMR.DOC.ImageCategory: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化项目字典表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitProducts()
ClassMethod InitProducts()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	k ^CT.EMR.DOC.ProductsI
	k ^CT.EMR.DOC.ProductsD
	s obj=##class(%DynamicAbstractObject).%New()
	s obj.params.productCode="OEP"
	s obj.params.productName="门急诊"
	s argInData=##class(%GlobalBinaryStream).%New()
	s argOutMessage=##class(%DynamicObject).%New()
	s argOutData=##class(%GlobalBinaryStream).%New()
	d ##class(EMR.DOC.BL.Products).AddProductData(obj,argInData,argOutMessage,argOutData)
	s obj.params.productCode="IP"
	s obj.params.productName="住院"
	d ##class(EMR.DOC.BL.Products).AddProductData(obj,argInData,argOutMessage,argOutData)
	s obj.params.productCode="OP"
	s obj.params.productName="门诊"
	d ##class(EMR.DOC.BL.Products).AddProductData(obj,argInData,argOutMessage,argOutData)
	;&sql(INSERT INTO CT_EMR_DOC.Products d(d.ProductCode,d.ProductName) VALUES ('OEP','门急诊'))
	;&sql(INSERT INTO CT_EMR_DOC.Products d(d.ProductCode,d.ProductName) VALUES ('IP','住院'))
	;&sql(INSERT INTO CT_EMR_DOC.Products d(d.ProductCode,d.ProductName) VALUES ('OP','门诊'))
}

/// Desc:       初始化功能字典类型表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDictFunctionType()
ClassMethod InitDictFunctionType()
{
	//&sql(DELETE FROM CT_EMR_DOC.DictFunctionTypes)
	k ^CT.EMR.DOC.DictFunctionTypesI
	k ^CT.EMR.DOC.DictFunctionTypesD
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcGroup','功能菜单分组'))
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcItem','功能菜单项'))
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcMenuNode','右键菜单节点'))
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcMenu','右键菜单'))
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcMenuSub','右键子菜单'))
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcBtnType','编辑'))
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcBtn','功能按钮'))
	&sql(INSERT INTO CT_EMR_DOC.DictFunctionTypes d(d.Code,d.Name) VALUES ('funcTabs','tab菜单项'))
}

/*
/// Desc:       初始化功能字典表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDictFunction()
ClassMethod InitDictFunction()
{
	//&sql(DELETE FROM CT_EMR_DOC.DictFunction)
	
	k ^CT.EMR.DOC.DictFunctionI
	k ^CT.EMR.DOC.DictFunctionD
	
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'MENU_DATA','基础数据管理','基础数据管理','MENU','1','1','',0,dft.id FROM CT_EMR_DOC.DictFunctionTypes dft WHERE  dft.Code = 'funcGroup')
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'MENU_DOC','通用文档管理','通用文档管理','MENU','2','1','',0,dft.id FROM CT_EMR_DOC.DictFunctionTypes dft WHERE  dft.Code = 'funcGroup')
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'MENU_BDM','业务数据模型管理','业务数据模型管理','MENU','3','1','',0,dft.id FROM CT_EMR_DOC.DictFunctionTypes dft WHERE  dft.Code = 'funcGroup')
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'MENU_RBAC','权限管理','权限管理','MENU','4','1','',0,dft.id FROM CT_EMR_DOC.DictFunctionTypes dft WHERE dft.Code = 'funcGroup')
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'MENU_GLOSSARY','术语集管理','术语集管理','MENU','5','1','',0,dft.id FROM CT_EMR_DOC.DictFunctionTypes dft WHERE  dft.Code = 'funcGroup')
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'MENU_DATA_CTPROPERTYSET','基础数据管理','基础数据管理','MENU_DATA','6','1','',df.ID,dft.id FROM CT_EMR_DOC.DictFunction df,CT_EMR_DOC.DictFunctionTypes dft WHERE df.FuncCode ='MENU_DATA' AND dft.Code = 'funcItem')
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'MENU_DOC_TEMPLATE','文档管理','文档管理','MENU_DOC','7','1','',df.ID,dft.id FROM CT_EMR_DOC.DictFunction df,CT_EMR_DOC.DictFunctionTypes dft WHERE df.FuncCode ='MENU_DOC' AND dft.Code = 'funcItem')
	&sql(INSERT INTO CT_EMR_DOC.DictFunction d(d.FuncCode,d.FuncName,d.FuncDesc,d.ParentCode,d.Sequence,d.Product,d.FuncUrl,d.ParentID,d.Type) select 'mi_checkbox','多选','多选','mi_addsimelment','119','1','',df.ID,dft.id FROM CT_EMR_DOC.DictFunction df,CT_EMR_DOC.DictFunctionTypes dft WHERE df.FuncCode ='mi_addsimelment' AND dft.Code = 'funcMenuSub')
	
}
*/
/// Desc:       初始化功能字典表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDictFunction("D:\01_DicFcuntion.txt")
ClassMethod InitDictFunction(argFile As %String)
{
	k ^CT.EMR.DOC.DictFunctionI
	k ^CT.EMR.DOC.DictFunctionD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s FuncCode = $p(Line,$c(9),1)
		s ParentCode = $p(Line,$c(9),4)
		s TypeCode = $p(Line,$c(9),5)
		//s ProductCode = $p(Line,$c(9),7)
		//s strProductID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(ProductCode,"U"),""))
		//continue:(strProductID="")
		s strRowID=$o(^CT.EMR.DOC.DictFunctionI("IdxPCCode"," "_$zcvt(ParentCode,"U")," "_$zcvt(FuncCode,"U"),""))
		continue:(strRowID'="")
		s obj=##Class(CT.EMR.DOC.DictFunction).%New()
		s obj.FuncCode=FuncCode
		s obj.ParentCode=ParentCode
		s obj.FuncName=$p(Line,$c(9),2)
		s obj.FuncDesc=$p(Line,$c(9),3)
		s obj.Sequence=$p(Line,$c(9),6)
		s strParentID = ""
		&sql(select df.ID into:strParentID  FROM CT_EMR_DOC.DictFunction df WHERE df.FuncCode =:ParentCode)
		if (strParentID="")&&(ParentCode="MENU")
		{
			s strParentID ="0"
		}
		//s obj.FuncUrl=""
		s obj.ParentID = strParentID
		s strTypeRowID=$o(^CT.EMR.DOC.DictFunctionTypesI("IdxCode"," "_$zcvt(TypeCode,"U"),""))
		s objDictFuncType = ##class(CT.EMR.DOC.DictFunctionTypes).%OpenId(strTypeRowID)
		s obj.Type = objDictFuncType
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"01_DicFcuntion: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化基础字典表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitStdDictionary("D:\08_StdDictionary.txt")
ClassMethod InitStdDictionary(argFile As %String)
{
	k ^CF.EMR.DOC.StdDictionaryD,^CF.EMR.DOC.StdDictionaryI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.StdDictionary).%New()
		//Code	Condition	ConditionCode	Description	DicAliasCol	DicCodeCol	DicDescCol	IsDiagnosRuleType	IsRuleType	Name	RuleTypeTag	Sequence	TableName
		//net端维护程序对空值做处理，所以将字段处理成$c(0)
		s obj.Code = $p(sRec, $c(9), 2)
 		s:($p(sRec, $c(9), 3)'="") obj.Condition = $p(sRec, $c(9), 3)
 		s:($p(sRec, $c(9), 4)'="") obj.ConditionCode = $p(sRec, $c(9), 4)
		s obj.Description = $p(sRec, $c(9), 5)
		s:($p(sRec, $c(9), 6)'="") obj.DicAliasCol = $p(sRec, $c(9), 6)
 		s obj.DicCodeCol = $p(sRec, $c(9), 7)
 		s obj.DicDescCol = $p(sRec, $c(9), 8)
		s obj.IsDiagnosRuleType = $p(sRec, $c(9), 9)
		s:($p(sRec, $c(9), 10)'="") obj.IsRuleType = $p(sRec, $c(9), 10)
 		s obj.Name = $p(sRec, $c(9), 11)
 		s ruleType = $p(sRec, $c(9), 12)
 		s strRowID=$o(^CF.EMR.DOC.EMRTSRuleTypeI("IdxCode"," "_$zcvt(ruleType,"U"),""))
		if (strRowID'="")
		{
			s objRuleType=##Class(CF.EMR.DOC.EMRTSRuleType).%OpenId(strRowID)
	 		s obj.RuleTypeTag = objRuleType
		}
		
		s obj.Sequence = $p(sRec, $c(9), 13)
		s obj.TableName = $p(sRec, $c(9), 14)

		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"08_StdDictionary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化元素属性
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemElementDatas("D:\02_TemElementDatas.txt")
ClassMethod InitTemElementDatas(argFile As %String)
{
	k ^CT.EMR.DOC.TemElementDatasI
	k ^CT.EMR.DOC.TemElementDatasD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s Code = $p(Line,$c(9),1)
		s ParentCode = $p(Line,$c(9),5)
		s TypeCode = $p(Line,$c(9),7)
		s strTypeRowID=$o(^CT.EMR.DOC.TemElementTypesI("IdxCode"," "_$zcvt(TypeCode,"U"),""))
		continue:(strTypeRowID="")
		s objDictFuncType = ##class(CT.EMR.DOC.TemElementTypes).%OpenId(strTypeRowID)
		continue:(objDictFuncType="")
		s strRowID=$o(^CT.EMR.DOC.TemElementDatasI("IdxTypePCCode",strTypeRowID," "_$zcvt(ParentCode,"U")," "_$zcvt(Code,"U"),""))
		continue:(strRowID'="")
		s obj=##Class(CT.EMR.DOC.TemElementDatas).%New()
		s obj.Code=Code
		s obj.Name = $p(Line,$c(9),2)
		s obj.Value=$p(Line,$c(9),3)
		s obj.Display=$p(Line,$c(9),4)
		s obj.AttrType=$p(Line,$c(9),6)
		s obj.Choices=$p(Line,$c(9),8)
		s obj.Sequence=$p(Line,$c(9),9)
		s obj.ParentCode=ParentCode
		s strParentID = ""
		&sql(select df.ID into:strParentID  FROM CT_EMR_DOC.TemElementDatas df WHERE df.Code =:ParentCode)
		if (strParentID="")&&(ParentCode="GROUP")
		{
			s strParentID ="0"
		}
		//s obj.FuncUrl=""
		s obj.ParentID = strParentID
		s obj.Type = objDictFuncType
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"02_TemElementDatas "_FileCnt_" rows imported"
	quit
}

/// Desc:       添加角色数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACDataTypes()
ClassMethod InitRBACDataTypes()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	k ^CF.EMR.DOC.RBACDataTypesI
	k ^CF.EMR.DOC.RBACDataTypesD
	&sql(INSERT INTO CF_EMR_DOC.RBACDataTypes d(d.Code,d.Name) VALUES ('TEMPLATE','模板'))
	&sql(INSERT INTO CF_EMR_DOC.RBACDataTypes d(d.Code,d.Name) VALUES ('KB','片段'))
	&sql(INSERT INTO CF_EMR_DOC.RBACDataTypes d(d.Code,d.Name) VALUES ('HFF','版式'))
}

/// Desc:       添加角色数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACRoleTypes()
ClassMethod InitRBACRoleTypes()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	k ^CF.EMR.DOC.RBACRoleTypesI
	k ^CF.EMR.DOC.RBACRoleTypesD
	&sql(INSERT INTO CF_EMR_DOC.RBACRoleTypes d(d.Code,d.Name) VALUES ('1','超级管理员'))
	&sql(INSERT INTO CF_EMR_DOC.RBACRoleTypes d(d.Code,d.Name) VALUES ('0','管理员'))
}

/// Desc:       添加数据权限类型
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACDataPerTypes()
ClassMethod InitRBACDataPerTypes()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	k ^CF.EMR.DOC.RBACDataPerTypesI
	k ^CF.EMR.DOC.RBACDataPerTypesD
	&sql(INSERT INTO CF_EMR_DOC.RBACDataPerTypes d(d.Code,d.Name) VALUES ('1','只读'))
	&sql(INSERT INTO CF_EMR_DOC.RBACDataPerTypes d(d.Code,d.Name) VALUES ('2','读写'))
	&sql(INSERT INTO CF_EMR_DOC.RBACDataPerTypes d(d.Code,d.Name) VALUES ('0','隐藏不可编辑'))
	&sql(INSERT INTO CF_EMR_DOC.RBACDataPerTypes d(d.Code,d.Name) VALUES ('-1','隐藏可编辑'))
}

/// Desc:       添加用户
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACUser()
ClassMethod InitRBACUser()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	k ^CF.EMR.DOC.RBACUserI
	k ^CF.EMR.DOC.RBACUserD
	;&sql(INSERT INTO CF_EMR_DOC.RBACUser R(R.IsAdmin,R.RoleID,R.UserCode,R.UserName) VALUES (1,'1','YS01','医生01'))
	;&sql(INSERT INTO CF_EMR_DOC.RBACUser R(R.IsAdmin,R.RoleID,R.UserCode,R.UserName) VALUES (0,'2','0100','李利萍'))
	s obj=##Class(CF.EMR.DOC.RBACUser).%New()
	s obj.IsAdmin = "1"
	s roleId = "1"
	s RoleID = ##class(CF.EMR.DOC.RBACRole).%OpenId(roleId)
	s obj.RoleID = RoleID
	s obj.UserCode = "YS01"
	s obj.UserName = "YS01"
	d obj.%Save()
	d obj.%Close()
	s obj=""
}

/// Desc:       添加角色
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitRBACRole()
ClassMethod InitRBACRole(argFile As %String)
{
	k ^CF.EMR.DOC.RBACRoleI
	k ^CF.EMR.DOC.RBACRoleD
	;&sql(INSERT INTO CF_EMR_DOC.rbacrole R(R.RoleCode,R.RoleName,R.RoleDesc,R.RoleTypes) VALUES ('admin','超级管理员','超级管理员','1'))
	;&sql(INSERT INTO CF_EMR_DOC.rbacrole R(R.RoleCode,R.RoleName,R.RoleDesc,R.RoleTypes) VALUES ('nkadmin','内科管理管','内科管理员','2'))
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s obj=##Class(CF.EMR.DOC.RBACRole).%New()
		s obj.IsExist = $p(Line,$c(9),2)
		s obj.RoleCode = $p(Line,$c(9),3)
		s obj.RoleDesc = $p(Line,$c(9),4)
		s obj.RoleName = $p(Line,$c(9),5)
		s typeId = $p(Line,$c(9),6)
		s roleType = ##class(CF.EMR.DOC.RBACRoleTypes).%OpenId(typeId)
		s obj.RoleTypes = roleType
		s obj.Status = $p(Line,$c(9),7)
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"11_CF.EMR.DOC.RBACRole: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化模板类型
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateTypes()
ClassMethod InitTemplateTypes()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	k ^CT.EMR.DOC.TemplateTypesI
	k ^CT.EMR.DOC.TemplateTypesD
	&sql(INSERT INTO CT_EMR_DOC.TemplateTypes d(d.Code,d.Name) VALUES ('DOC','文档'))
	&sql(INSERT INTO CT_EMR_DOC.TemplateTypes d(d.Code,d.Name) VALUES ('GRID','表单'))
	&sql(INSERT INTO CT_EMR_DOC.TemplateTypes d(d.Code,d.Name) VALUES ('FREEFORM','自由表单'))
}

/// Desc:       初始化元素类型
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemElementTypes()
ClassMethod InitTemElementTypes()
{
	//&sql(DELETE FROM CT_EMR_DOC.TemElementTypes)
	k ^CT.EMR.DOC.TemElementTypesI
	k ^CT.EMR.DOC.TemElementTypesD
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('section','章节','section'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('composite','复合元素','composite'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('string','字符型元素','simple'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('number','数值型元素','simple'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('dateTime','日期型元素','simple'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('dictionary','字典型元素','simple'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('radioGroup','单选型元素','simple'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('checkboxGroup','多选型元素','simple'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('select','下拉元素','simple'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('macro','月经生育史','medformula'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('macroSample','月经生育史子元素','medformula'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('concept','医学概念','concept'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('conceptSample','医学概念子元素','concept'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('header','页眉','hff'))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTypes d(d.Code,d.Name,d.Type) VALUES ('footer','页脚','hff'))
}

/// Desc:       初始化模板工具栏按钮
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemToolButtons()
ClassMethod InitTemToolButtons()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	k ^CT.EMR.DOC.TemToolButtonsI
	k ^CT.EMR.DOC.TemToolButtonsD
	
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnUnmak','撤回','撤回','DOC','icon-back',1))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnUndo','恢复','恢复','DOC','icon-arrow_right_top',2))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnCopy','复制','复制','DOC','icon-copy',3))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnPaste','粘贴','粘贴','DOC','icon-paste',4))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnFontFamily','字体','字体','DOC',NULL,5))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnFontSize','字号','字号','DOC',NULL,6))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnColor','字体颜色','字体颜色','DOC',NULL,7))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnSuperCcript','上标','上标','DOC','icon-superscript',8))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnSubScript','下标','下标','DOC','icon-subscript',9))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnBackgroundColor','背景色','背景色','DOC',NULL,10))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnBold','加粗','加粗','DOC','icon-bold',11))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnDelLine','删除线','删除线','DOC','icon-strikethrough',12))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnUnderline','下划线','下划线','DOC','icon-underline',13))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnItalic','斜体','斜体','DOC','icon-incline',14))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnIndent','增加缩进','增加缩进','DOC','icon-indentation',15))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnUnindent','减少缩进','减少缩进','DOC','icon-unindent',16))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnInsertTable','插入表格','插入表格','DOC',NULL,17))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnAlign','对齐方式','对齐方式','DOC',NULL,18))
	&sql(INSERT INTO CT_EMR_DOC.TemToolButtons d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.ImageName,d.Sequence) VALUES ('btnSave','保存','保存','DOC',NULL,19))
}

/// Desc:       初始化模板元素工具栏按钮
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemElementTools()
ClassMethod InitTemElementTools()
{
	//&sql(DELETE FROM CT_EMR_DOC.Products)
	/*
	k ^CT.EMR.DOC.TemElementToolsI
	k ^CT.EMR.DOC.TemElementToolsD
	
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('smBDMTemplate','模板结构','模板机构','DOC','GROUP',0,1))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('smComElmenets','复合元素','复合元素','DOC','GROUP',0,2))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('smSimElements','简单元素','简单元素','DOC','GROUP',0,3))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('smSections','章节页签','章节页签','DOC','GROUP',0,4))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('smHFF','页眉页脚','页眉页脚','DOC','GROUP',0,5))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miOrder','医嘱','医嘱','DOC','ITEM',2,6))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miDiagnosis','诊断','诊断','DOC','ITEM',2,7))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miAllergic','过敏史','过敏史','DOC','ITEM',2,8))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miSign','签名','签名','DOC','ITEM',2,9))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miMenstrualR','月经生育史','月经生育史','DOC','ITEM',2,10))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miString','字符','字符','DOC','ITEM',3,11))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miNumber','数值','数值','DOC','ITEM',3,12))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miRadioGroup','单选','单选','DOC','ITEM',3,13))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miCheckbox','多选','多选','DOC','ITEM',3,14))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miDateTime','日期时间','日期时间','DOC','ITEM',3,15))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miList','列表','列表','DOC','ITEM',3,16))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miSectionN','章节前','章节前','DOC','ITEM',4,17))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miSectionP','章节后','章节后','DOC','ITEM',4,18))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miSectionL','章节尾','章节尾','DOC','ITEM',4,19))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miSectionS','章节子','章节子','DOC','ITEM',4,20))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miEditHeader','页眉编辑','页眉编辑','DOC','ITEM',5,21))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miEditFooter','页脚编辑','页脚编辑','DOC','ITEM',5,22))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miRemoveHeader','页眉移除','页眉移除','DOC','ITEM',5,23))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miRemoveFooter','页脚移除','页脚移除','DOC','ITEM',5,24))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miInsertPGNum','插入页码','插入页码','DOC','ITEM',5,25))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miInsertPGACount','插入总页码','插入总页码','DOC','ITEM',5,26))
	&sql(INSERT INTO CT_EMR_DOC.TemElementTools d(d.Code,d.Name,d.ToolTip,d.DocTypes,d.Types,d.ParentID,d.Sequence) VALUES ('miDyElement','动态单元','动态单元','DOC','ITEM',5,27))
	*/
}

/// Desc:       初始化业务数据结构类型
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBDMTypes()
ClassMethod InitBDMTypes()
{
	//&sql(DELETE FROM CF_EMR_DOC.BDMTypes)
	k ^CF.EMR.DOC.BDMTypesI
	k ^CF.EMR.DOC.BDMTypesD
	&sql(INSERT INTO CF_EMR_DOC.BDMTypes d(d.Code,d.Name,d.Product) VALUES ('Category','目录','1'))
	&sql(INSERT INTO CF_EMR_DOC.BDMTypes d(d.Code,d.Name,d.Product) VALUES ('Document','文档','1'))
	&sql(INSERT INTO CF_EMR_DOC.BDMTypes d(d.Code,d.Name,d.Product) VALUES ('Section','章节','1'))
	&sql(INSERT INTO CF_EMR_DOC.BDMTypes d(d.Code,d.Name,d.Product) VALUES ('Root','根节点','1'))
}

/// Desc:       初始化文档目录结构类型
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateCTypes()
ClassMethod InitTemplateCTypes()
{
	//&sql(DELETE FROM CF_EMR_DOC.TemplateCTypes)
	k ^CF.EMR.DOC.TemplateCTypesI
	k ^CF.EMR.DOC.TemplateCTypesD
	
	&sql(INSERT INTO CF_EMR_DOC.TemplateCTypes d(d.Code,d.Name,d.Product) VALUES ('Classification','业务活动记录分类','1'))
	&sql(INSERT INTO CF_EMR_DOC.TemplateCTypes d(d.Code,d.Name,d.Product) VALUES ('Record','业务活动记录','1'))
	&sql(INSERT INTO CF_EMR_DOC.TemplateCTypes d(d.Code,d.Name,d.Product) VALUES ('Category','目录','1'))
	&sql(INSERT INTO CF_EMR_DOC.TemplateCTypes d(d.Code,d.Name,d.Product) VALUES ('Document','文档','1'))
	&sql(INSERT INTO CF_EMR_DOC.TemplateCTypes d(d.Code,d.Name,d.Product) VALUES ('Root','根节点','1'))
}

/// Desc:       初始化业务数据结构目录
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut: 
/// debug:	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBDMCategory("D:\03_BDMCategory.txt")
ClassMethod InitBDMCategory(argFile As %String)
{
	k ^CF.EMR.DOC.BDMCategoryI
	k ^CF.EMR.DOC.BDMCategoryD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s obj=##Class(CF.EMR.DOC.BDMCategory).%New()
		s obj.Code=$p(Line,$c(9),2)
		s obj.Description=$p(Line,$c(9),3)
		s obj.IsFixedSection=$p(Line,$c(9),4)
		s obj.Name=$p(Line,$c(9),5)
		s obj.ParentCode=$p(Line,$c(9),6)
		s obj.ParentID=$p(Line,$c(9),7)
		s obj.ResChildCount=$p(Line,$c(9),8)
		s obj.Sequence = $p(Line,$c(9),1)
		s strStructType=$p(Line,$c(9),9)
		s strTypeRowID=$o(^CF.EMR.DOC.BDMTypesI("IdxCode"," "_$zcvt(strStructType,"U"),""))
		continue:(strTypeRowID="")
		s objTypes = ##class(CF.EMR.DOC.BDMTypes).%OpenId(strTypeRowID)
		s obj.StructType=objTypes
		s strProductCode=$p(Line,$c(9),10)
		s strPRowID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(strProductCode,"U"),""))
		continue:(strPRowID="")
		s objProducts = ##class(CT.EMR.DOC.Products).%OpenId(strPRowID)
		s obj.Product = objProducts
		s obj.GlossaryItemIDS=""
		
		
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	
	s id=""
	for {
		s id=$o(^CF.EMR.DOC.BDMCategoryD(id))
		q:(id="")
		s objts=##class(CF.EMR.DOC.BDMCategory).%OpenId(id)
		continue:(objts="")
		s parid=objts.ParentID
		s parcode=objts.ParentCode
		if (parid="") {
			
			CONTINUE:(parcode="")	
			if ($l(parcode,"^")=1)
			{
				
				s parid=$o(^CF.EMR.DOC.BDMCategoryI("IdxCode"," "_$tr(parcode," ",""),parid))
				s objts.ParentID=parid
				s objts.ParentCode=$tr(parcode," ","")
				d objts.%Save()
				d objts.%Close()
			}
			if ($l(parcode,"^")=2)
			{
				s pdocumentcode = $p(parcode,"^",1)
				s psectioncode = $p(parcode,"^",2)
				
				s pdocumentid=$o(^CF.EMR.DOC.BDMCategoryI("IdxCode"," "_$tr(pdocumentcode," ",""),""))
				
				s tmppsectionid=""
				for {
					s tmppsectionid=$o(^CF.EMR.DOC.BDMCategoryI("IdxCode"," "_$tr(psectioncode," ",""),tmppsectionid))
					q:(tmppsectionid="")
					
					s tmpsectionobj=##class(CF.EMR.DOC.BDMCategory).%OpenId(tmppsectionid)
					s tmppdocid=tmpsectionobj.ParentID
					continue:(tmppdocid'= pdocumentid)
					s parid=tmppsectionid
					
				}
				s objts.ParentID=parid
				s objts.ParentCode=$tr(parcode," ","")
				d objts.%Save()
				d objts.%Close()
			}
			
		} 
		
		if (parcode="") {
			
			CONTINUE:(parid="")||(parid=0)
			s parobj=##class(CF.EMR.DOC.BDMCategory).%OpenId(parid)
			continue:(parobj="")
			s pobjcode=parobj.Code
			s objts.ParentCode=pobjcode
			d objts.%Save()
			d objts.%Close()
			d parobj.%Close()
			s parobj=""
			
		} 
		
	}
	w !,"03_Summary: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化数据绑定值类型
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindValueTypes()
ClassMethod InitBindValueTypes()
{
	//&sql(DELETE FROM CF_EMR_DOC.BindValueTypes)
	k ^CF.EMR.DOC.BindValueTypesI
	k ^CF.EMR.DOC.BindValueTypesD
	&sql(INSERT INTO CF_EMR_DOC.BindValueTypes d(d.Code,d.Name,d.Product) VALUES ('Text','纯文本','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindValueTypes d(d.Code,d.Name,d.Product) VALUES ('Style','样式文本','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindValueTypes d(d.Code,d.Name,d.Product) VALUES ('DateTime','日期','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindValueTypes d(d.Code,d.Name,d.Product) VALUES ('List','字典','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindValueTypes d(d.Code,d.Name,d.Product) VALUES ('RadioGroup','单选','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindValueTypes d(d.Code,d.Name,d.Product) VALUES ('Checkbox','多选','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindValueTypes d(d.Code,d.Name,d.Product) VALUES ('Select','下拉','1'))
}

/// Desc:       初始化数据绑定方式
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindTypes()
ClassMethod InitBindTypes()
{
	//&sql(DELETE FROM CF_EMR_DOC.BindTypes)
	k ^CF.EMR.DOC.BindTypesI
	k ^CF.EMR.DOC.BindTypesD
	&sql(INSERT INTO CF_EMR_DOC.BindTypes d(d.Code,d.Name,d.Product) VALUES ('Query','查询','1'))
	;&sql(INSERT INTO CF_EMR_DOC.BindTypes d(d.Code,d.Name,d.Product) VALUES ('ClassMethod','方法','1'))
	;&sql(INSERT INTO CF_EMR_DOC.BindTypes d(d.Code,d.Name,d.Product) VALUES ('ClassProperty','属性','1'))
	;&sql(INSERT INTO CF_EMR_DOC.BindTypes d(d.Code,d.Name,d.Product) VALUES ('JsonMethod','jons方法','1'))
}

/// Desc:       初始化数据集绑定参数集
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindParameterValues()
ClassMethod InitBindParameterValues()
{
	//&sql(DELETE FROM CF_EMR_DOC.BindParameterValues)
	k ^CF.EMR.DOC.BindPValuesI
	k ^CF.EMR.DOC.BindPValuesD
	&sql(INSERT INTO CF_EMR_DOC.BindParameterValues d(d.Code,d.Name,d.Product) VALUES ('EpisodeID','就诊号','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindParameterValues d(d.Code,d.Name,d.Product) VALUES ('UserID','登录号','1'))
	&sql(INSERT INTO CF_EMR_DOC.BindParameterValues d(d.Code,d.Name,d.Product) VALUES ('EventID','手术ID','1'))
}

/// Desc:       初始化数据集数据
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut: 
/// d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitBindSysData("D:\04_BindSysData.txt")
ClassMethod InitBindSysData(argFile As %String)
{
	k ^CF.EMR.DOC.BindQueryI
	k ^CF.EMR.DOC.BindQueryD
	k ^CF.EMR.DOC.BindParameterI
	k ^CF.EMR.DOC.BindParameterD
	k ^CF.EMR.DOC.BindFieldI
	k ^CF.EMR.DOC.BindFieldD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s Flag=$p(sRec, $c(9), 1)
		i (Flag="CF.EMR.DOC.BindQuery"){
			s obj = ##Class(CF.EMR.DOC.BindQuery).%New()
			//ClassName	Description	Mark	Name	QueryName	SingleResult
			s obj.QueryName = $p(sRec, $c(9), 3)
			s obj.Code = $p(sRec, $c(9), 4)
			s obj.Description = $p(sRec, $c(9), 5)
			s strBindType = $p(sRec, $c(9), 6)
			s strTypeRowID=$o(^CF.EMR.DOC.BindTypesI("IdxCode"," "_$zcvt(strBindType,"U"),""))
			continue:(strTypeRowID="")
			s objBindTypes = ##class(CF.EMR.DOC.BindTypes).%OpenId(strTypeRowID)
			s obj.BindType = objBindTypes
			s obj.Name = $p(sRec, $c(9), 7)
			s strProductCode=$p(sRec,$c(9),8)
			s strPRowID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(strProductCode,"U"),""))
			continue:(strPRowID="")
			s objProducts = ##class(CT.EMR.DOC.Products).%OpenId(strPRowID)
			s obj.Product = objProducts

			s isOK = obj.%Save()
		    
			s totCount = totCount + 1
			if (isOK)
			{
				s okCount = okCount + 1
			}
			else
			{
				s failCount = failCount + 1
			}
		}

		i (Flag="CF.EMR.DOC.BindParameter"){
			s objPar = ##Class(CF.EMR.DOC.BindParameter).%New()
			//Description	Name	ParameterName	ParameterType	QueryID
			//s objPar.Description = $p(sRec, $c(9), 3)
			//s objPar.Name = $p(sRec, $c(9), 4)
			s strParameterName = $p(sRec, $c(9), 5)
			s strPVRowID=$o(^CF.EMR.DOC.BindPValuesI("IdxCode"," "_$zcvt(strParameterName,"U"),""))
			continue:(strPVRowID="")
			s objPValues = ##class(CF.EMR.DOC.BindParameterValues).%OpenId(strPVRowID)
			s objPar.Parameter =objPValues
			s strBindQueryID = $p(sRec, $c(9), 6)
			continue:(strBindQueryID="")
			s objBindQuery = ##Class(CF.EMR.DOC.BindQuery).%OpenId(strBindQueryID)
			continue:(objBindQuery="")
			s objPar.BindQuery = objBindQuery

			s isOK = objPar.%Save()
		    
			s totCount = totCount + 1
			if (isOK)
			{
				s okCount = okCount + 1
			}
			else
			{
				s failCount = failCount + 1
			}
		}


		i (Flag="CF.EMR.DOC.BindField"){
			s objField = ##Class(CF.EMR.DOC.BindField).%New()
			//Description	DicID	FieldName	FieldType	Name	QueryID
			s objField.Description = $p(sRec, $c(9), 3)
			s objField.Code = $p(sRec, $c(9), 4)
			s objField.BindFiled = $p(sRec, $c(9), 5)
			s strFieldType = $p(sRec, $c(9), 6)
			s strTypeRowID=$o(^CF.EMR.DOC.BindValueTypesI("IdxCode"," "_$zcvt(strFieldType,"U"),""))
			continue:(strTypeRowID="")
			s objBindTypes = ##class(CF.EMR.DOC.BindValueTypes).%OpenId(strTypeRowID)
			s objField.ValueType =objBindTypes
			s objField.Name = $p(sRec, $c(9), 7)
			s strBindQueryID = $p(sRec, $c(9), 8)
			continue:(strBindQueryID="")
			s objBindQuery = ##Class(CF.EMR.DOC.BindQuery).%OpenId(strBindQueryID)
			continue:(objBindQuery="")
			s objField.BindQuery = objBindQuery
			
			s strValueType = $p(sRec, $c(9), 9)
			s strVTypeRowID=$o(^CF.EMR.DOC.BindValueTypesI("IdxCode"," "_$zcvt(strValueType,"U"),""))
			if (strVTypeRowID'="")
			{
				s objBindTypes = ##class(CF.EMR.DOC.BindValueTypes).%OpenId(strVTypeRowID)
				s objField.ValueType=objBindTypes
			}
			else
			{
				s strVTypeRowID=$o(^CF.EMR.DOC.BindValueTypesI("IdxCode"," TEXT",""))
				s objBindTypes = ##class(CF.EMR.DOC.BindValueTypes).%OpenId(strVTypeRowID)
				s objField.ValueType=objBindTypes
			}
			s isOK = objField.%Save()
		    
			s totCount = totCount + 1
			if (isOK)
			{
				s okCount = okCount + 1
			}
			else
			{
				s failCount = failCount + 1
			}
		}
	}
	w !,"04_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化文档片段目录类型
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitKBCategoryTypes()
ClassMethod InitKBCategoryTypes()
{
	//&sql(DELETE FROM CF_EMR_DOC.KBCategoryTypes)
	k ^CF.EMR.DOC.KBCategoryTypesI
	k ^CF.EMR.DOC.KBCategoryTypesD
	&sql(INSERT INTO CF_EMR_DOC.KBCategoryTypes d(d.Code,d.Name) VALUES ('Root','根节点'))
	&sql(INSERT INTO CF_EMR_DOC.KBCategoryTypes d(d.Code,d.Name) VALUES ('Category','目录'))
	&sql(INSERT INTO CF_EMR_DOC.KBCategoryTypes d(d.Code,d.Name) VALUES ('Document','文档'))
	&sql(INSERT INTO CF_EMR_DOC.KBCategoryTypes d(d.Code,d.Name) VALUES ('Section','章节'))
	&sql(INSERT INTO CF_EMR_DOC.KBCategoryTypes d(d.Code,d.Name) VALUES ('KBTree','节点分类'))
}

/// Desc:       初始化文档片段目录数据（将业务数据模型数据添加到片段目录中）
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitKBCategory()
ClassMethod InitKBCategory()
{
	//&sql(DELETE FROM CF_EMR_DOC.KBCategoryTypes)
	k ^CF.EMR.DOC.KBCategoryI
	k ^CF.EMR.DOC.KBCategoryD
	&sql(INSERT INTO CF_EMR_DOC.KBCategory k(k.BDMCategory,k.Product,k.Name,k.Description,k.KBCategoryTypes,k.ParentID,k.CategorySeq,k.ResChildCount) 
SELECT b.ID,b.Product,b.Name,b.Description,b.StructType,b.ParentID,b.ID,b.ResChildCount FROM CF_EMR_DOC.BDMCategory b)
}

/// Desc:       初始化文档板式数据
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitHFFormatCategory("D:\09_HFFormatCategory.txt")
ClassMethod InitHFFormatCategory(argFile As %String)
{
	k ^CF.EMR.DOC.HFFormatCategoryI
	k ^CF.EMR.DOC.HFFormatCategoryD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.HFFormatCategory).%New()
		//Descriptio   Name    ParentID		PropertyCode	PropertyName	ResChildCount
		s obj.Description = $p(sRec, $c(9), 2)
 		s obj.Name = $p(sRec, $c(9), 3)
 		s obj.ParentID = $p(sRec, $c(9), 4)
		s strProductCode=$p(sRec,$c(9), 5)
		s strPRowID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(strProductCode,"U"),""))
		continue:(strPRowID="")
		s objProducts = ##class(CT.EMR.DOC.Products).%OpenId(strPRowID)
		s obj.Product = objProducts
		s obj.ResChildCount = $p(sRec, $c(9), 6)

		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"05_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化文档目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateCategory("D:\05_TemplateCategory.txt")
ClassMethod InitTemplateCategory(argFile As %String)
{
	k ^CF.EMR.DOC.TemplateCategoryI
	k ^CF.EMR.DOC.TemplateCategoryD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.TemplateCategory).%New()
		//Descriptio   Name    ParentID		PropertyCode	PropertyName	ResChildCount
		s obj.Description = $p(sRec, $c(9), 2)
 		s obj.Name = $p(sRec, $c(9), 3)
 		s obj.ParentID = $p(sRec, $c(9), 4)
		s strProductCode=$p(sRec,$c(9), 5)
		s strPRowID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(strProductCode,"U"),""))
		continue:(strPRowID="")
		s objProducts = ##class(CT.EMR.DOC.Products).%OpenId(strPRowID)
		s obj.Product = objProducts
		s obj.ResChildCount = $p(sRec, $c(9), 6)

		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"05_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化通用系统参数
/// Creator:    huhao
/// CreateDate: 2022/6/14
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitDocSysOption("D:\06_DocSysOption.txt")
ClassMethod InitDocSysOption(argFile As %String)
{
	k ^CF.EMR.DOC.SysOptionI
	k ^CF.EMR.DOC.SysOptionD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.SysOption).%New()
		//Name Description OptionValue IsEditor	IsVisible Product	
		s obj.Name = $p(sRec, $c(9),2)
 		s obj.Description = $p(sRec, $c(9),3)
		s obj.IsEditer=$p(sRec, $c(9),4)
		s obj.IsVisible=$p(sRec, $c(9),5)
		s strProductCode = $p(sRec, $c(9),6)
		s obj.OptionValue = $p(sRec, $c(9),7)
		s strPRowID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(strProductCode,"U"),""))
		continue:(strPRowID="")
		s objProducts = ##class(CT.EMR.DOC.Products).%OpenId(strPRowID)
		s obj.Product = objProducts

		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"06_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       将旧版术语集数据插入到新版病历中
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitGlossaryData()
ClassMethod InitGlossaryData()
{
	//&sql(DELETE FROM CF_EMR_DOC.GlossaryCategory)
	k ^CF.EMR.DOC.GlossaryCategoryI
	k ^CF.EMR.DOC.GlossaryCategoryD
	k ^CF.EMR.DOC.GlossaryI
	k ^CF.EMR.DOC.GlossaryD
	k ^CF.EMR.DOC.DECategoryI
	k ^CF.EMR.DOC.DECategoryD
	k ^CF.EMR.DOC.DEVCategoryI
	k ^CF.EMR.DOC.DEVCategoryD
	k ^CF.EMR.DOC.DataElementI
	k ^CF.EMR.DOC.DataElementD
	k ^CF.EMR.DOC.DataElementValuesI
	k ^CF.EMR.DOC.DataElementValuesD
	&sql(INSERT INTO CF_EMR_DOC.GlossaryCategory c(c.InternalID,c.Name,c.Description,c.ParentID,c.ResChildCount)
SELECT o.InternalID,o.Name,o.Description,o.ParentID,o.ResChildCount FROM eprmeta.GlossaryCategory o)

	&sql(INSERT INTO CF_EMR_DOC.Glossary g(g.InternalID,g.GlossaryCategory,g.GlossaryType,g.MetaID,g.GUID,g.Name,g.Description,g.ParentID,g.CreateDate,g.CreateTime,g.LastModifyDate,g.LastModifyTime)
SELECT o.InternalID,o.GlossaryCategoryID,o.GlossaryType,o.MetaID,o.GUID,o.Name,o.Description,o.ParentID,o.CreateDate,o.CreateTime,o.LastModifyDate,o.LastModifyTime FROM eprmeta.Glossary o)

	&sql(INSERT INTO CF_EMR_DOC.DataElementCategory d(d.InternalID,d.Name,d.Description,d.ParentID) 
SELECT o.InternalID,o.Name,o.Description,o.ParentID FROM eprmeta.DataElementCategory o)

	&sql(INSERT INTO CF_EMR_DOC.DataElementValuesCategory d(d.CategoryID,d.CreateDate,d.CreateTime,d.DECVMID,d.Description,d.LastModifyDate,d.LastModifyTime,d.Name,d.PerName)
SELECT o.CategoryID,o.CreateDate,o.CreateTime,o.DECVMID,o.Description,o.LastModifyDate,o.LastModifyTime,o.Name,o.PerName FROM eprmeta.DataElementValuesCategory o)

	&sql(INSERT INTO CF_EMR_DOC.DataElement d(d.Category,d.ClassModle,d.CreateDate,d.CreateTime,d.DEVID,d.DataType,d.Definition,d.Entifier,d.Environment,d.Format,d.LastModifyDate,d.LastModifyTime,d.Name,d.PutInOrgan,d.RegOrgan,d.ResOrgan,d.State,d.Versions)
SELECT o.CategoryID,o.ClassModle,o.CreateDate,o.CreateTime,o.DEVID,o.DataType,o.Definition,o.Entifier,o.Environment,o.Format,o.LastModifyDate,o.LastModifyTime,o.Name,o.PutInOrgan,o.RegOrgan,o.ResOrgan,o.State,o.Versions FROM eprmeta.DataElement o)

	&sql(INSERT INTO CF_EMR_DOC.DataElementValues d(d.CreateDate,d.CreateTime,d.DECVMID,D.DEVID,d.Description,d.LastModifyDate,d.LastModifyTime,d.Meaning)
SELECT o.CreateDate,o.CreateTime,o.DECVMID,o.DEVID,o.Description,o.LastModifyDate,o.LastModifyTime,o.Meaning FROM eprmeta.DataElementValues o)
}

/// Desc:       初始化术语集关联类型
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitGlossaryItemType()
ClassMethod InitGlossaryItemType()
{
	//&sql(DELETE FROM CF_EMR_DOC.GlossaryItemType)
	k ^CF.EMR.DOC.GlossaryItemTypeI
	k ^CF.EMR.DOC.GlossaryItemTypeD
	
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemType d(d.Code,d.Name) VALUES ('ISECTIONDESC','章节'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemType d(d.Code,d.Name) VALUES ('ICOMPOSITEDESC','段落'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemType d(d.Code,d.Name) VALUES ('ICOMPOSITESAMPLE','结构化元素'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemType d(d.Code,d.Name) VALUES ('ICONCEPTDESC','医学概念'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemType d(d.Code,d.Name) VALUES ('ICONCEPTSAMPLE','医学概念子元素'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemType d(d.Code,d.Name) VALUES ('IMACRODESC','宏对象'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemType d(d.Code,d.Name) VALUES ('IMACROSAMPLE','宏对象子元素'))
}

/// Desc:       初始化元素值类型数据
/// Creator:    yejian
/// CreateDate: 2020-12-25
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitGlossaryItemValues()
ClassMethod InitGlossaryItemValues()
{
	//&sql(DELETE FROM CF_EMR_DOC.InitGlossaryItemValues)
	k ^CF.EMR.DOC.GlossaryItemValuesI
	k ^CF.EMR.DOC.GlossaryItemValuesD
	
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('1','1','{"T":"文本","S":"样式"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('2','2','{"T":"文本","S":"样式"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('3','3','{"V":"值"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('4','3','{"V":"值"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('5','3','{"V":"值","C":"代码","VANDC":"值^代码","YEAR":"年","MONTH":"月","DAY":"日","HOUR":"时","MINUTE":"分","SECOND":"秒"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('6','3','{"V":"值","C":"代码","VC":"值和代码","CV":"代码和值","VANDC":"值^代码","CANDV":"代码^值","I":"ROWID","Dict":"ID^代码^值"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('7','3','{"V":"值","C":"代码","VANDC":"值^代码","CANDV":"代码^值"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('8','3','{"V":"值","C":"代码","VANDC":"值^代码","CANDV":"代码^值"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('10','4','{"T":"文本","S":"样式"}'))
	&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	VALUES ('9','6','{"T":"文本","S":"样式"}'))
	
	//暂时屏蔽牙位和实例数据取值
	//&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	//VALUES ('InstanceData','{"V":"值"}'))
	//&sql(INSERT INTO CF_EMR_DOC.GlossaryItemValues d(d.MiType,ItemType,d.VTypeItem)
	//VALUES ('MITooth','{"V":"值"}'))
}

/// Desc:       初始化编辑区工具栏数据
/// Creator:    huhao
/// CreateDate: 2021-8-18
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEditToolbar()
ClassMethod InitEditToolbar()
{
	/*
	k ^CF.EMR.DOC.GlossaryItemValuesI
	k ^CF.EMR.DOC.GlossaryItemValuesD

	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnSave','保存','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnPrint','打印','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnDelete','删除','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnTemplateclassify','模板','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnSpechars','符号','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnExportDocument','导出','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnPreview','预览','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnRevisionVisible','显示痕迹','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnLogFlagInfo','操作日志','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnAuthRequest','权限申请','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnTooth','牙位图','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnManagePersonal','管理个人模板','Y',''))
	&sql(insert into CF_EMR_OP.ToolConfig d(d.Name,d.Title,d.IsVisible,d.Description) VALUES('btnRefresh','刷新','Y',''))
	*/
}

/// Desc:       初始化方案类型码表
/// Creator:    yejian
/// CreateDate: 2021-9-22
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRTSchemeType()
ClassMethod InitEMRTSchemeType()
{
	//&sql(DELETE FROM CF_EMR_DOC.EMRTSchemeType)
	k ^CF.EMR.DOC.EMRTSchemeTypeI
	k ^CF.EMR.DOC.EMRTSchemeTypeD
	
	&sql(INSERT INTO CF_EMR_DOC.EMRTSchemeType d(d.Code,d.Name) VALUES ('Running','住院在院方案'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSchemeType d(d.Code,d.Name) VALUES ('Outpatient','门急诊在院方案'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSchemeType d(d.Code,d.Name) VALUES ('Archiving','病历归档方案'))
}

/// Desc:       初始化方案规则类型码表
/// Creator:    yejian
/// CreateDate: 2021-9-22
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRTSRuleType()
ClassMethod InitEMRTSRuleType()
{
	//&sql(DELETE FROM CF.EMR.DOC.EMRTSRuleType)
	k ^CF.EMR.DOC.EMRTSRuleTypeI
	k ^CF.EMR.DOC.EMRTSRuleTypeD
	
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('All','PATDEPT','科室'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('Classification','SSGROUP','安全组'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('Document','PATSEX','性别'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('Document','PATWARD','病区'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('Document','PATDIA','ICD10'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('Document','PATPRIV','通用模板'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('Document','PATTYPE','病历类型'))
	&sql(INSERT INTO CF_EMR_DOC.EMRTSRuleType d(d.RuleType,d.Code,d.Name) VALUES ('Document','SSLAN','语言'))
}

/// Desc:       初始化操作日志类型数据
/// Creator:    yejian
/// CreateDate: 2021-9-22
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSysOperateTypes()
ClassMethod InitSysOperateTypes()
{
	//&sql(DELETE FROM CF_EMR_DOC.SysOperateTypes)
	k ^CF.EMR.DOC.SysOperateTypesI
	k ^CF.EMR.DOC.SysOperateTypesD
	
	&sql(INSERT INTO CF_EMR_DOC.SysOperateTypes d(d.Code,d.Name) VALUES ('Template','文档'))
	&sql(INSERT INTO CF_EMR_DOC.SysOperateTypes d(d.Code,d.Name) VALUES ('HFFormat','版式'))
	&sql(INSERT INTO CF_EMR_DOC.SysOperateTypes d(d.Code,d.Name) VALUES ('KB','片段'))
	&sql(INSERT INTO CF_EMR_DOC.SysOperateTypes d(d.Code,d.Name) VALUES ('Scheme','导航方案'))
}

/// Desc:       初始化文档分组数据
/// Creator:    yejian
/// CreateDate: 2021-9-22
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitTemplateGroup()
ClassMethod InitTemplateGroup()
{
	//&sql(DELETE FROM CF_EMR_DOC.TemplateGroup)
	k ^CF.EMR.DOC.TemplateGroupI
	k ^CF.EMR.DOC.TemplateGroupD
	
	&sql(INSERT INTO CF_EMR_DOC.TemplateGroup d(d.Code,d.Name,d.EMRName,d.IsLeadframe) VALUES ('EMR10','病程记录','病程记录','1'))
	&sql(INSERT INTO CF_EMR_DOC.TemplateGroup d(d.Code,d.Name,d.EMRName,d.IsLeadframe) VALUES ('EMR090001','入院记录','入院记录','1'))
}

/// Desc:       初始化病历状态数据
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRStatus("D:\13_CF.EMR.DOC.EMRStatus.txt")
ClassMethod InitEMRStatus(argFile As %String)
{
	//&sql(DELETE FROM CF_EMR_DOC.EMRStatus)
	k ^CF.EMR.DOC.EMRStatusI
	k ^CF.EMR.DOC.EMRStatusD
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.EMRStatus).%New()
		//EMRAction	PostStatus	PreStatus
		s obj.Code = $p(sRec, $c(9), 2)
 		s obj.Name = $p(sRec, $c(9), 3)
		s isOK = obj.%Save()
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"13_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化病历操作数据
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRAction("D:\14_CF.EMR.DOC.EMRAction.txt")
ClassMethod InitEMRAction(argFile As %String)
{
	//&sql(DELETE FROM CF_EMR_DOC.EMRAction)
	k ^CF.EMR.DOC.EMRActionI
	k ^CF.EMR.DOC.EMRActionD
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.EMRAction).%New()
		//EMRAction	PostStatus	PreStatus
		s obj.Code = $p(sRec, $c(9), 2)
 		s obj.Name = $p(sRec, $c(9), 3)
		s isOK = obj.%Save()
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"14_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化病历操作和状态关系数据
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitEMRActStatusCfg("D:\15_CF.EMR.DOC.EMRActStatusCfg.txt")
ClassMethod InitEMRActStatusCfg(argFile As %String)
{
	k ^CF.EMR.DOC.EMRActStatusCfgI
	k ^CF.EMR.DOC.EMRActStatusCfgD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.EMRActStatusCfg).%New()
		//EMRAction	PostStatus	PreStatus
		s objAction = "",objPostStatus = "",objPreStatus =""
		s strEMRAction = $p(sRec, $c(9), 2)
 		s strPostStatus = $p(sRec, $c(9), 3)
		s strPreStatus = $p(sRec, $c(9), 4)
		s strActionID=$o(^CF.EMR.DOC.EMRActionI("IdxCode"," "_$zcvt(strEMRAction,"U"),""))
		s:(strActionID'="") objAction = ##class(CF.EMR.DOC.EMRAction).%OpenId(strActionID)
		continue:(objAction="")
		s strPoStatueID=$o(^CF.EMR.DOC.EMRStatusI("IdxCode"," "_$zcvt(strPostStatus,"U"),""))
		s:(strPoStatueID'="") objPostStatus = ##class(CF.EMR.DOC.EMRStatus).%OpenId(strPoStatueID)
		s strPrStatueID=$o(^CF.EMR.DOC.EMRStatusI("IdxCode"," "_$zcvt(strPreStatus,"U"),""))
		s:(strPrStatueID'="") objPreStatus = ##class(CF.EMR.DOC.EMRStatus).%OpenId(strPrStatueID)
		s obj.EMRAction = objAction
		s obj.PostStatus = objPostStatus
		s obj.PreStatus = objPreStatus
		s isOK = obj.%Save()
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"15_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化HIS医师级别与电子病历签名级别对照表
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSignRoleLinkCPT("D:\16_CF.EMR.DOC.SignRoleLinkCPT.txt")
ClassMethod InitSignRoleLinkCPT(argFile As %String)
{
	k ^CF.EMR.DOC.SignRoleLinkCPTI
	k ^CF.EMR.DOC.SignRoleLinkCPTD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.SignRoleLinkCPT).%New()
		//EMRAction	PostStatus	PreStatus
		s objSignRole = ""
		s CPTCode = $p(sRec, $c(9), 2)
 		s SignRole = $p(sRec, $c(9), 3)
		s strRowID=$o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(SignRole,"U"),""))
		s:(strRowID'="") objSignRole = ##class(CF.EMR.DOC.SignRole).%OpenId(strRowID)
		continue:(objSignRole="")
		s obj.CPTCode = CPTCode
		s obj.SignRole = objSignRole
		s isOK = obj.%Save()
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"16_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化权限规则参数
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:  
/// Debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitPrivRuleList("D:\17_CF.EMR.DOC.PrivRuleList.txt")
ClassMethod InitPrivRuleList(argFile As %String)
{
	k ^CF.EMR.DOC.PrivRuleListI
	k ^CF.EMR.DOC.PrivRuleListD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.PrivRuleList).%New()

		//RuleDesc RuleName RuleType 
		s obj.RuleDesc = $p(sRec, $c(9), 2)
 		s obj.RuleName = $p(sRec, $c(9), 3)
		s obj.RuleType = $p(sRec, $c(9), 4)
		s obj.Status = "1"
		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"17_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化权限规则仓库
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:  
/// Debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitPrivRuleStore("D:\18_CF.EMR.DOC.PrivRuleStore.txt")
ClassMethod InitPrivRuleStore(argFile As %String)
{
	k ^CF.EMR.DOC.PrivRuleStoreI
	k ^CF.EMR.DOC.PrivRuleStoreD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.PrivRuleStore).%New()

		//RuleDesc RuleName RuleType 
		s obj.RuleDesc = $p(sRec, $c(9), 2)
 		s obj.RuleCode = $p(sRec, $c(9), 3)
		s obj.Sequence = $p(sRec, $c(9), 4)
		s obj.Status = "1"
		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"18_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:       初始化链接单元配置数据
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:  
/// Debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitLinkConfig("D:\19_CF.EMR.DOC.LinkConfig.txt")
ClassMethod InitLinkConfig(argFile As %String)
{
	K ^CF.EMR.DOC.LinkConfigD
	K ^CF.EMR.DOC.LinkConfigI
	K ^CF.EMR.DOC.LinkConfigS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s obj=##Class(CF.EMR.DOC.LinkConfig).%New()
		s obj.IsDirectOpen = $p(Line,$c(9),2)
		s obj.Src = $p(Line,$c(9),3)
		s obj.Method=$p(Line,$c(9),4)
		s obj.Code = $p(Line,$c(9),5)
		s obj.Scheme =$p(Line,$c(9),6)
		s obj.Name = $p(Line,$c(9),7)
		s strProductCode = $p(Line, $c(9),8)
		s strProductCode=$tr(strProductCode,$c(13),"")
		s strPRowID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(strProductCode,"U"),""))
		continue:(strPRowID="")
		s objProducts = ##class(CT.EMR.DOC.Products).%OpenId(strPRowID)
		s obj.Product = objProducts
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"19_Summary: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化资源区内容数据
/// Creator:    yejian
/// CreateDate: 2022-9-8
/// Input:      argFile 导入文本路径
/// OutPut:  
/// Debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitResource("D:\20_CF.EMR.DOC.Resource.txt")
ClassMethod InitResource(argFile As %String)
{
	K ^CF.EMR.DOC.ResourceI
	K ^CF.EMR.DOC.ResourceD
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s obj=##Class(CF.EMR.DOC.Resource).%New()
		s obj.Content = $p(Line,$c(9),2)
		s obj.Frame = $p(Line,$c(9),3)
		s obj.Href=$p(Line,$c(9),4)
		s obj.Name = $p(Line,$c(9),5)
		s obj.Position =$p(Line,$c(9),6)
		s obj.RefreshOnSelect = $p(Line,$c(9),7)
		s obj.Scrolling = $p(Line,$c(9),8)
		s obj.Title = $p(Line,$c(9),9)
		s obj.Visible = $p(Line,$c(9),10)
		s obj.Zoom = $p(Line,$c(9),11)
		s strProductCode = $p(Line, $c(9),12)
		s strProductCode=$tr(strProductCode,$c(13),"")
		s strPRowID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(strProductCode,"U"),""))
		continue:(strPRowID="")
		s objProducts = ##class(CT.EMR.DOC.Products).%OpenId(strPRowID)
		s obj.Product = objProducts
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"20_summary: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化特殊字符
/// Creator:    yejian
/// CreateDate: 2022-9-8
/// Input:      argFile 导入文本路径
/// OutPut:  
/// Debug:	d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSpechars()
ClassMethod InitSpechars()
{
	k ^CF.EMR.DOC.SpecharsCategoryI
	k ^CF.EMR.DOC.SpecharsCategoryD
	k ^CF.EMR.DOC.SpecharsI
	k ^CF.EMR.DOC.SpecharsD
	s FileCnt=1
	s strtsFH = "特殊符号 ＃ ＠ ＆ ＊ ※ § 〃 № 〓 ○ ● △ ▲ ◎ ☆ ★ ◇ ◆ □ ■ ▽ ▼ ㊣ ℅ ˉ ￣ ＿ ﹉ ﹊ ﹍ ﹎ ﹋ ﹌ ﹟ ﹠ ﹡ ♀ ♂ ⊕ ⊙ ↑ ↓ ← → ↖ ↗ ↙ ↘ ∥ ∣ ／ ＼ ∕ ﹨"
	s objCatagory = ##Class(CF.EMR.DOC.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strtsFH," ",1)
	s objCatagory.CategoryDesc = $p(strtsFH," ",1)
	s objCatagory.Sequence = 1
	s IDCount = $l(strtsFH," ")
	For I=2:1:IDCount
	 {
		S ACode= $P(strtsFH," ",I)
		s objSpechars = ##Class(CF.EMR.DOC.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
		s FileCnt=FileCnt+1
	 }
	 s strbdFH = "标点符号 ， 、 。 ． ； ： ？ ！ ︰ … ‥ ′ ‵ 々 ～ ‖ ˇ ˉ ﹐ ﹑ ﹒ · ﹔ ﹕ ﹖ ﹗ ｜ – ︱ — ︳ ︴ ﹏ （ ） ︵ ︶｛ ｝ ︷ ︸ 〔 〕 ︹ ︺ 【 】 ︻ ︼ 《 》 ︽ ︾ 〈 〉 ︿ ﹀ 「 」 ﹁ ﹂ 『 』 ﹃ ﹄ ﹙ ﹚ ﹛ ﹜ ﹝ ﹞ ‘ ’ "" "" 〝 〞 ˋ ˊ"
	 s objCatagory = ##Class(CF.EMR.DOC.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strbdFH," ",1)
	s objCatagory.CategoryDesc = $p(strbdFH," ",1)
	s objCatagory.Sequence = 2
	s IDCount = $l(strbdFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strbdFH," ",I)
		s objSpechars = ##Class(CF.EMR.DOC.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
		s FileCnt=FileCnt+1
	}
	s strdwFH = "单位符号 ° ′ ″ ＄ ￥ 〒 ￠ ￡ ％ ＠ ℃ ℉ ﹩ ﹪ ‰ ﹫ ㏕ ㎜ ㎝ ㎞ ㏎ ㎡ ㎎ ㎏ ㏄ ° ○ ¤"
	s objCatagory = ##Class(CF.EMR.DOC.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strdwFH," ",1)
	s objCatagory.CategoryDesc = $p(strdwFH," ",1)
	s objCatagory.Sequence = 3
	s IDCount = $l(strdwFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strdwFH," ",I)
		s objSpechars = ##Class(CF.EMR.DOC.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
		s FileCnt=FileCnt+1
	}
	s strszFH = "数字符号 ⅰ ⅱ ⅲ ⅳ ⅴ ⅵ ⅶ ⅷ ⅸ ⅹ Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ Ⅺ Ⅻ ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗ ⒘ ⒙ ⒚ ⒛ ⑴ ⑵ ⑶ ⑷ ⑸ ⑹ ⑺ ⑻ ⑼ ⑽ ⑾ ⑿ ⒀ ⒁ ⒂ ⒃ ⒄ ⒅ ⒆ ⒇ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ㈠ ㈡ ㈢ ㈣ ㈤ ㈥ ㈦ ㈧ ㈨ ㈩"
	s objCatagory = ##Class(CF.EMR.DOC.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strszFH," ",1)
	s objCatagory.CategoryDesc = $p(strszFH," ",1)
	s objCatagory.Sequence = 4
	s IDCount = $l(strszFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strszFH," ",I)
		s objSpechars = ##Class(CF.EMR.DOC.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
		s FileCnt=FileCnt+1
	}
	s strsxFH = "数学符号 ≈ ≡ ≠ ＝ ≤ ≥ ＜ ＞ ≮ ≯ ∷ ± ＋ － × ÷ ／ ∫ ∮ ∝ ∞ ∧ ∨ ∑ ∏ ∪ ∩ ∈ ∵ ∴ ⊥ ∥ ∠ ⌒ ⊙ ≌ ∽ √ ≦ ≧ ≒ ≡ ﹢ ﹣ ﹤ ﹥ ﹦ ～ ∟ ⊿ ㏒ ㏑" 
	s objCatagory = ##Class(CF.EMR.DOC.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strsxFH," ",1)
	s objCatagory.CategoryDesc = $p(strsxFH," ",1)
	s objCatagory.Sequence = 5
	s IDCount = $l(strsxFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strsxFH," ",I)
		s objSpechars = ##Class(CF.EMR.DOC.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
		s FileCnt=FileCnt+1
	}
	s strxnFH = "希腊子母 α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ σ τ υ φ χ ψ ω Α Β Γ Δ Ε Ζ Η Θ Ι Κ Λ Μ Ν Ξ Ο Π Ρ Σ Τ Υ Φ Χ Ψ Ω"
	s objCatagory = ##Class(CF.EMR.DOC.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strxnFH," ",1)
	s objCatagory.CategoryDesc = $p(strxnFH," ",1)
	s objCatagory.Sequence = 6
	s IDCount = $l(strxnFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strxnFH," ",I)
		s objSpechars = ##Class(CF.EMR.DOC.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
		s FileCnt=FileCnt+1
	}
	s strxnFH = "自定义 ×10<SUP>9</SUP>/L ×10<SUP>12</SUP>/L mmol/L ㎏/㎡ mmHg └1 └2 └3 └4 └5 └6 └7 └8 └I └II └III └IV └V └VI 1┘ 2┘ 3┘ 4┘ 5┘ 6┘ 7┘ 8┘ I┘ II┘ III┘ IV┘ V┘ VI┘ 1┐ 2┐ 3┐ 4┐ 5┐ 6┐ 7┐ 8┐ I┐ II┐ III┐ IV┐ V┐ VI┐ ┌1 ┌2 ┌3 ┌4 ┌5 ┌6 ┌7 ┌8 ┌I ┌II ┌III ┌IV ┌V ┌VI"
	s objCatagory = ##Class(CF.EMR.DOC.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strxnFH," ",1)
	s objCatagory.CategoryDesc = $p(strxnFH," ",1)
	s objCatagory.Sequence = 7
	s IDCount = $l(strxnFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strxnFH," ",I)
		s objSpechars = ##Class(CF.EMR.DOC.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
		s FileCnt=FileCnt+1
	}
	w !,"21_summary: "_FileCnt_" rows imported"
	quit
}

// 初始化导入导航菜单

ClassMethod InitNavMenu(argFile As %String)
{
	k ^CT.EMR.DOC.DictFunctionI
	k ^CT.EMR.DOC.DictFunctionD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s FuncCode = $p(Line,$c(9),2)
		s FuncName = $p(Line,$c(9),3)
		s ParentCode = $p(Line,$c(9),6)
		s ParentID = $p(Line,$c(9),7)
		s Sequence = $p(Line,$c(9),8)
		s Perms = $p(Line,$c(9),9)
		s Type = $p(Line,$c(9),10)
		s Compoent = $p(Line,$c(9),11)
		s Icon = $p(Line,$c(9),12)
		s Path = $p(Line,$c(9),13)
		s UpdateTime = $p(Line,$c(9),14)
		s Visible = $p(Line,$c(9),15)
		s obj=##Class(CT.EMR.DOC.DictFunction).%New()
		s obj.FuncCode = FuncCode
		s obj.FuncName = FuncName
		s obj.ParentCode = ParentCode
		s obj.ParentID = ParentID
		s obj.Sequence = Sequence
		s obj.Perms = Perms
		s obj.Type = ##class(CT.EMR.DOC.DictFunctionTypes).%OpenId(Type)
		s obj.Component = Compoent
		s obj.Icon = Icon
		s obj.Path = Path
		s obj.UpdateTime = UpdateTime
		s obj.Visible = Visible
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
		}
	w !,"10_DictFunction: "_FileCnt_" rows imported"
	quit
}

/// Desc:       初始化HIS医师级别与电子病历签名级别对照表
/// Creator:    yejian
/// CreateDate: 2022-4-18
/// Input:      argFile 导入文本路径
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitSignRole("D:\21_CF.EMR.DOC.SignRole.txt")
ClassMethod InitSignRole(argFile As %String)
{
	k ^CF.EMR.DOC.SignRoleI
	k ^CF.EMR.DOC.SignRoleD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.DOC.SignRole).%New()
		//EMRAction	PostStatus	PreStatus
		s ActionCode = $p(sRec, $c(9), 2)
 		s CanSignOnCheck = $p(sRec, $c(9), 3)
 		s Description = $p(sRec, $c(9), 4)
 		s IsValid = $p(sRec, $c(9), 5)
 		s Name = $p(sRec, $c(9), 6)
 		s NotValidate = $p(sRec, $c(9), 7)
 		s RoleLevel = $p(sRec, $c(9), 8)
 		s SignPrefix = $p(sRec, $c(9), 9)
		s obj.ActionCode = ActionCode
		s obj.CanSignOnCheck = CanSignOnCheck
		s obj.Description = Description
		s obj.IsValid = IsValid
		s obj.Name = Name
		s obj.NotValidate = NotValidate
		s obj.RoleLevel = RoleLevel
		s obj.SignPrefix = SignPrefix
		s isOK = obj.%Save()
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"16_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// ///////////////////////////////////////////////////////////////////////////////////////
/// Desc:       初始化基础数据
/// Creator:    lifengbo
/// CreateDate: 2023-3-13
/// Input:      argFile 导入文本路径
/// OutPut:     
/// debug:		d ##Class(EMR.DOC.TOOL.InitStandardDataTool).InitStandardData("/tmp/txt")
ClassMethod InitStandardData(argFile As %String)
{
	Set tRS=##class(%ResultSet).%New("%Library.File:FileSet")
                
	Set tSC=tRS.Execute(argFile,"*.txt")
	
	While tRS.Next() {
		
		s fileName = tRS.Get("Name")
		s className = $p($p(fileName,".txt",1),"_",2)
		w !,fileName
		
		d ..InitTableData1(fileName,className)
	}
	//重新初始化一次 字典数据
	s extraFileName=argFile_"/08_CF.EMR.DOC.StdDictionary.txt"
	s extraClassName = $p($p(extraFileName,".txt",1),"_",2)
	d ..InitTableData1(extraFileName,extraClassName,"Extra")
}

/// 方案一，头信息通过表头解析
ClassMethod InitTableData1(argFilePath As %String, AClassName As %String, AExtra As %String = "")
{
	s $zt="ERROR"
	TSTART
	//Base:SET ClassDef = ##class(%Library.ClassDefinition).%OpenId(AClassName)
	//通过数据获取表对应的存储global
	
	s globalDataExp = "^oddDEF("""_AClassName_""",""s"",""Default"",24)"
	s globalIdxExp = "^oddDEF("""_AClassName_""",""s"",""Default"",25)"
	s globalStmExp = "^oddDEF("""_AClassName_""",""s"",""Default"",33)"
		
	k @@globalDataExp
	k @@globalIdxExp
	k @@globalStmExp
	
	//获取txt中的数据
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFilePath

	s totCount=0,okCount=0,failCount=0
	s headerLine=""
	s hasHeader=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		//初始化第一行表头信息
		if ((sRec["ID")&&(hasHeader=0))
		{
			Set sRec = $tr(sRec,$c(13),"")
			s headerLine =sRec
			s hasHeader=1
			continue
		}
		
		//导入第二行开始的表格数据
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		//新建对象
		s obj =""
		s objExp = "obj=##class("_AClassName_").%New()"
		s @objExp

		//逐属性赋值
		s propertyLength = $l(sRec,$c(9))
		for i=2:1:propertyLength
		{
			s tmpValue = $p(sRec, $c(9), i)
			s propertyName=$p(headerLine, $c(9), i)
			
			
			///获取属性定义类型，解决指向型数据赋值
			s propertyType=""
			
			s propertyTypeExp = "^oddDEF("""_AClassName_""",""a"","""_propertyName_""",5)"
			s propertyType = @propertyTypeExp
			
			
			//校验是否存在属性定义，输出异常信息
			if (propertyType="")
			{
				w !,"Warning404: ClassName:"_AClassName_",Property:"_propertyName_",出现未定义的情况。"
				continue
			}
			
			if ((propertyType = "%String")||(propertyType = "%Integer"))
			{
				/// UpdateTime [CT.EMR.DOC.DictFunction:UpdateTime As %String]
				/// CreatTime  [CT.EMR.DOC.RoutingMenu:CreatTime As %String]
				/// UpdateTime [CT.EMR.DOC.RoutingMenu:UpdateTime As %String]
				if ((propertyName = "UpdateTime")||(propertyName = "CreatTime"))
				{
					s setValueExp = "obj."_propertyName_"="""_$zdt($h,3,1)_""""
				}
				else
				{
					s setValueExp = "obj."_propertyName_"="""_$replace(tmpValue,"""","""""")_""""
				}
			}
			elseif (propertyType = "%Date")
			{
				if ((propertyName="CreateDate")||(propertyName="LastModifyDate"))
				{
					s setValueExp = "obj."_propertyName_"="_+$h
				}
				else
				{
					//不导入无效数据
					//s setValueExp = "obj."_propertyName_"="_tmpValue
				}
			}
			elseif (propertyType = "%Time")
			{
				if ((propertyName="CreateTime")||(propertyName="LastModifyTime"))
				{
					s setValueExp = "obj."_propertyName_"="_$p($h,",",2)
				}
				else
				{
					//不导入无效数据
					//s setValueExp = "obj."_propertyName_"="_tmpValue
				}
			}
			//包含. 认定为指向性赋值
			elseif (propertyType [".")
			{
				//互相指向型数据，字典执行类型数据，先不进行初始化。
				if ((AClassName = "CF.EMR.DOC.StdDictionary")&&(propertyType ="CF.EMR.DOC.EMRTSRuleType")&&(AExtra=""))
				{
					continue
				}
				if (tmpValue = "")
				{
					continue
				}
				s setValueExp = "obj."_propertyName_"=##class("_propertyType_").%OpenId("_tmpValue_")"
			}
			else
			{
				//导入日志，记录未在枚举范围内的赋值
				//s setValueExp = "obj."_propertyName_"="_tmpValue
				w !,"Waring500: ClassName:"_AClassName_",propertyType:"_propertyType_",类型枚举缺失。"
				continue
			}
			
			s @setValueExp
		}
		
		s isOK = obj.%Save()
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,argFilePath_" Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	TCOMMIT
	quit
ERROR
	s $zt=""
	TROLLBACK
	w !,"ERROR_Info: "_$ze
}

}

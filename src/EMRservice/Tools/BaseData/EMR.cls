Class EMRservice.Tools.BaseData.EMR Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:初始化基础数据	
ClassMethod Main(AVersions As %ListOfDataTypes)
{
	
	s key = ""
	for
	{
		s version = AVersions.GetNext(.key)
		q:(key = "")
		d @(".."_version_"()")
	}
}

ClassMethod V1200()
{
	//初始化特殊字符
	d ##Class(EMRservice.BL.BLSpechars).setDefaultSpechars()
}

ClassMethod V1300()
{
	//初始化事件类型
	d ##Class(EMRservice.BL.Event.BLEventConfig).InitEventType()
	
	//初始化事件配置
	d ##Class(EMRservice.BL.Event.BLEventConfig).InitEventConfig()
	
	//系统参数
	d ##Class(EMRservice.BL.BLSysOption).Insert("CareOrdArcimRowIDStr","<CareOrdArcim><Item><OrdRowID>10337||1</OrdRowID></Item><Item><OrdRowID>10338||1</OrdRowID></Item><Item><OrdRowID>10339||1</OrdRowID></Item><Item><OrdRowID>10340||1</OrdRowID></Item><Item><OrdRowID>10341||1</OrdRowID></Item><Item><OrdRowID>10342||1</OrdRowID></Item><Item><OrdRowID>12878||1</OrdRowID></Item><Item><OrdRowID>12879||1</OrdRowID></Item><Item><OrdRowID>13102||1</OrdRowID></Item><Item><OrdRowID>13103||1</OrdRowID></Item><Item><OrdRowID>13104||1</OrdRowID></Item></CareOrdArcim>","界面17|护理级别医嘱的RowID串","")
	d ##Class(EMRservice.BL.BLSysOption).Insert("PatListTemplateIDStr","<TemplateInfo><Type><TypeCode>OutPat</TypeCode><TypeDesc>出院患者</TypeDesc><Template><ID>15</ID><Code>HomePage</Code><Desc>病案首页</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OutPat</TypeCode><TypeDesc>出院患者</TypeDesc><Template><ID>90</ID><Code>HomePage</Code><Desc>中医病案首页</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>TransPat</TypeCode><TypeDesc>转出患者</TypeDesc><Template><ID>20</ID><Code>Transfer</Code><Desc>转出记录</Desc><TitleCode>7</TitleCode></Template></Type><Type><TypeCode>TransPat</TypeCode><TypeDesc>转出患者</TypeDesc><Template><ID>91</ID><Code>Transfer</Code><Desc>旧版转出记录</Desc><TitleCode>7</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>1</ID><Code>Operation</Code><Desc>手术记录</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>93</ID><Code>Operation</Code><Desc>旧版手术记录</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>2</ID><Code>BeforeOperation</Code><Desc>术前讨论记录</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>92</ID><Code>BeforeOperation</Code><Desc>旧版术前讨论记录</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>20</ID><Code>AfterOperation</Code><Desc>术后首程</Desc><TitleCode>15</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>94</ID><Code>AfterOperation</Code><Desc>旧版术后首程</Desc><TitleCode>15</TitleCode></Template></Type></TemplateInfo>","界面18|TypeCode不能改变；Code不能改变，且要一一对应（病案首页：HomePage、转出记录：Transfer、手术记录：Operation、术前讨论记录：BeforeOperation、术后首程：AfterOperation）；当病历名称有单独的模板时，ID维护成模板ID，TitleCode维护成“null”，当病历名称没有单独的模板时，是模板A下的Title，那么ID维护成模板A的ID，TitleCode维护成相应的值","")
	d ##Class(EMRservice.BL.BLSysOption).Insert("Lis_AbnorFlag_Check","N","界面19|资源区的检验数据引用取消异常值默认勾选[启用->Y][禁用->N]默认为N","")
}

ClassMethod V1400()
{
	//重新索引 
	d ##class(EMRmeta.KBTree).%BuildIndices()
	d ##class(EMRmeta.KBTreeCTLoc).%BuildIndices()
	
	//系统参数
	d ##Class(EMRservice.BL.BLSysOption).Insert("FTP_CONNECT_PARAMS","'server':'127.0.0.1','port':'21','username':'ftpuser','password':'ftpuser','timeout':'3000'","系统21|设置病历图片上传Ftp参数","")
	d ##Class(EMRservice.BL.BLSysOption).Delete("MessageStayTime")
	d ##Class(EMRservice.BL.BLSysOption).Insert("MessageScheme","{'alert':'2000','warning':'5000','forbid':'7000'}","界面20|操作病历时提示信息在界面上停留时间（以毫秒为单位)","")
}

ClassMethod V1500()
{
	//重新索引
  	do ##class(EMRinstance.Lock).%BuildIndices()
  	
  	//系统参数
  	d ##Class(EMRservice.BL.BLSysOption).Delete("SET_PASSWORD")
  	d ##Class(EMRservice.BL.BLSysOption).Delete("SET_USERNAME")
  	//d ##Class(EMRservice.BL.BLSysOption).Insert("DECRYPTKEY","GlobalEMR","系统05|秘钥KEY","") 
  	//d ##Class(EMRservice.BL.BLSysOption).Insert("NET_CONNECT","{""server"":""127.0.0.1"",""port"":""1972"",""nameSpace"":""DHC-APP"",""username"":""_SYSTEM"",""password"":""SYS""}","系统01|基础网络连接参数","")
}

ClassMethod V1600()
{
	//系统参数
	d ##Class(EMRservice.BL.BLSysOption).Insert("PageAttribute","{'DefaultForm':'Nav','Edit.List.Sequence':'Date'}","界面21|界面页面加载属性(DefaultForm 默认页面 值：Eidt(病历编辑页面）/Nav（导航页面）  Edit.List.Sequence 病历编辑页面病历显示顺序 Date（按日期）/LoadScheme(按配置方案)","")
	d ##Class(EMRservice.BL.BLSysOption).Insert("AuthorizationSSGroupID","NULL","权限09|是否所有病人的授权可见,值为SSGroupID集合,以^分隔多个SSGroupID[启用->GroupID1^GroupID2^...][禁用->NULL]","")
  	d ##Class(EMRservice.BL.BLSysOption).Insert("AutoSave","{'switch':'off','interval':''}","系统11|系统自动保存文档（switch值：on 开启 off 关闭，interval 时间间隔以毫秒为单位)","") 
  	d ##Class(EMRservice.BL.BLSysOption).Insert("SignType","Text","系统12|病历签名类型（Graph-图片签名，Text-文字签名)","")
  	d ##Class(EMRservice.BL.BLSysOption).Insert("EnableRoleKBTree","N","知识库11|是否启用角色知识库权限[启动->Y][禁用->N]","")   	
	
	s flag = ""
	r "初始化角色权限和角色知识库数据:请输入MainDictFunction.txt路径及文件名 ",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	d ##Class(EMRservice.Tools.Tool).InitMainDictFunction(flag)
	
	//初始化签名角色数据
	d ##Class(EMRservice.BL.BLSignRole).IniData()
	
	s flag = ""
	w !
	r "初始化状态表,请输入EMRStatus.txt 路径文件名",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	elseif (flag = "q")
	{
		q
	}
	d ##Class(EMRservice.Tools.Tool).InitEMRStatus(flag)

	s flag = ""
	w !
	r "初始化动作表,请输入 EMRAction.txt 路径文件名",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	elseif (flag = "q")
	{
		q
	}
	d ##Class(EMRservice.Tools.Tool).InitEMRAction(flag)
	
	s flag = ""
	w !
	r "初始化状态流转表,请输入 EMRActStatusCfg.txt 路径文件名",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	elseif (flag = "q")
	{
		q
	}
	d ##Class(EMRservice.Tools.Tool).InitEMRActStatusCfg(flag)
	
	w !
	s flag = ""
	r "初始化门诊功能区链接按钮,his版本是否大于8.0 是(y) 否(n)",flag
	if ($zcvt(flag,"U") = "N")
	{
		d ##Class(EMRmeta.OPHisTools).Init()
	}
	else
	{
		d ##Class(EMRmeta.OPHisTools).InitFor8()
	}
}

ClassMethod V1620()
{
	d ##Class(EMRservice.BL.BLSysOption).Insert("PatientNoLength","10","设置患者登记号长度，用于自动补齐输入登记号","") 
	w !,"系统参数初始完毕",!
	
	do ##class(EPRmeta.Glossary).%BuildIndices()
	w !,"重索引初始完毕",!
	
	s flag = ""
	
	r "初始化角色权限,请输入DHCEPRRBAC.META.PrivateDomainDefinition.txt 文件名及路径,[初始文件中版本包/RBAC/inital文件夹下]",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	else
	{
		d ##Class(EMRservice.Tools.Tool).InitDHCEPRRBAC1(flag)
		w !
	}
	
	r "初始化角色权限,请输入DHCEPRRBAC.META.ItemDefinition.txt 文件名及路径,[初始文件中版本包/RBAC/inital文件夹下]",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	else
	{
		d ##Class(EMRservice.Tools.Tool).InitDHCEPRRBAC2(flag)
		w !
	}
	
	r "初始化角色权限,请输入DHCEPRRBAC.INST.ResourceItem.txt 文件名及路径,[初始文件中版本包/RBAC/inital文件夹下]",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	else
	{
		d ##Class(EMRservice.Tools.Tool).InitDHCEPRRBAC3(flag)
		w !
	}
	
	r "初始化角色权限,请输入DHCEPRRBAC.META.RoleDefinition.txt 文件名及路径,[初始文件中版本包/RBAC/inital文件夹下]",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	else
	{
		d ##Class(EMRservice.Tools.Tool).InitDHCEPRRBAC4(flag)
		w !
	}
	
	r "初始化角色权限,请输入DHCEPRRBAC.META.OperationDefinition.txt 文件名及路径,[初始文件中版本包/RBAC/inital文件夹下]",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	else
	{
		d ##Class(EMRservice.Tools.Tool).InitDHCEPRRBAC5(flag)
		w !
	}
	w "文件初始完毕"
}

ClassMethod V1630()
{
	s status = "0"
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("DISABLE_DUPLEX_PRINT","Y","界面22|禁止自动双面打印,默认为N","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 DISABLE_DUPLEX_PRINT 失败"
		q
	}	
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("DISABLE_NEAT_PRINT","Y","界面23|禁止自动整洁打印,默认为N","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 DISABLE_NEAT_PRINT 失败"
		q
	}	
	s objEDic = ##Class(EMRservice.entity.EStdDictionary).%New()
	s objEDic.Code = "S12S"
	s objEDic.Description = "[HIS]ICD10疾病字典[系统]"
	s objEDic.DicAliasCol = "ALIAS_Text"
	s objEDic.DicCodeCol = "MRCID_ICD9CM_Code"
	s objEDic.DicDescCol = "MRCID_Desc"
	s objEDic.IsDiagnosRuleType = "Y"
	s objEDic.IsRuleType = "Y"
	s objEDic.Name  = "[HIS]ICD10疾病字典[系统]"
	s objEDic.RuleTypeTag = "PATDIA"
	s objEDic.TableName = "SQLUser.MRC_ICDDx"
	s status = ##Class(EMRservice.BL.BLStdDictionary).CreateStdDictionary(objEDic)
	if (status '= "1") 
	{
		w !,"初始化 带规则的疾病字典失败"
		q
	}
}

ClassMethod V1640()
{
	w !,"重新索引标题配置表数据"
	d ##class(EMRmeta.TitleConfig).%BuildIndices()
	w !,"标题配置表数据重新索引完毕"
	
	w !,"迁移EMRmeta.MainRoleKBTree Global"
	d ##Class(EMRservice.Tools.Tool).CopyDataByOtherD()
	d ##class(EMRmeta.MainRoleKBTree).%BuildIndices() 
	w !,"迁移EMRmeta.MainRoleKBTree 完毕"
	
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("RequestReasonRequiredStr","Y^N^N","界面25|病历操作权限申请页面，申请原因、修改前内容、修改后内容三个输入框是否为必填项[必填项->Y][非必填项->N]，申请原因、修改前内容、修改后内容按顺序以^分隔；例：Y^N^N","") 
	if (status '= "1") 
	{
		w !,"初始化 RequestReasonRequiredStr 失败"
		q
	}
	else
	{
		w !,"初始化 RequestReasonRequiredStr 成功"
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("OPResSingleSelect","Y","界面26|检查、检验资源区是否单选，默认是Y","") 
	if (status '= "1") 
	{
		w !,"初始化 OPResSingleSelect 失败"
		q
	}
	else
	{
		w !,"初始化 OPResSingleSelect 成功"
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isShowPatInfo","N","界面27|门诊是否显示患者信息栏，默认是N","") 
	if (status '= "1") 
	{
		w !,"初始化 isShowPatInfo 失败"
		q
	}
	else
	{
		w !,"初始化 isShowPatInfo 成功"
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("useResWindowHotkey","N","界面28|门诊资源区可以使用快捷键呼叫出来  默认是N","") 
	if (status '= "1") 
	{
		w !,"初始化 useResWindowHotkey 失败"
		q
	}
	else
	{
		w !,"初始化 useResWindowHotkey 成功"
	}
	//增加一个初始化方法，初始化右侧资源区
	d ##Class(EMRmeta.OPResource).Init() 	
	
	s flag = ""
	r "初始化角色权限和角色知识库数据:请输入MainDictFunction.txt路径及文件名 ",flag
	if (flag = "")
	{
		w !,"没有输入文件名，请手功初始化数据",!
	}
	d ##Class(EMRservice.Tools.Tool).InitMainDictFunction(flag)
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("DISABLE_TABLE_MENU","N","界面30|是否禁用前端书写表格右键菜单,默认为N","Y") 
	if (status '= "1") 
	{
		w !,"初始化 DISABLE_TABLE_MENU 失败"
		q
	}
	else
	{
		w !,"初始化 DISABLE_TABLE_MENU 成功"
	}
}

ClassMethod V1650()
{
	w !,"重新索引EMRinstance.ICompositeSimple"
	d ##class(EMRinstance.ICompositeSimple).%BuildIndices()
	
	w !,"重新索引EPRmeta.GlossaryKBItem"
	d ##class(EPRmeta.GlossaryKBItem).%BuildIndices()
	
	w !,"重新索引EPRmeta.Glossary"
	d ##class(EPRmeta.Glossary).%BuildIndices()
	
	w !,"重新索引EMRmeta.EMRTemplateCategory"
	d ##class(EMRmeta.EMRTemplateCategory).%BuildIndices()
	
	w !,"重新索引EMRinstance.Events.LinkDocumnents"
	do ##class(EMRinstance.Events.LinkDocumnents).%BuildIndices()
	
	w !,"修改初始化标题目录数据"
	d ##Class(EMRservice.Tools.Tool).InitTitleCategory()
	 
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("PatholScheme","<scheme><show><parent><item><code>ordername</code><desc>医嘱项</desc><hidden>N</hidden><width>130</width></item><item><code>AppDate</code><desc>申请日期</desc><hidden>N</hidden></item><item><code>AppTime</code><desc>申请时间</desc><hidden>N</hidden></item><item><code>SpeInfo</code><desc>标本信息</desc><hidden>N</hidden></item><item><code>tmid</code><desc>申请单号</desc><hidden>N</hidden></item><item><code>ClinicDiag</code><desc>临床诊断</desc><hidden>Y</hidden></item><item><code>ClinicRecord</code><desc>临床病历</desc><hidden>Y</hidden></item></parent><child><item><code>Tmrowid</code><desc>Tmrowid</desc><hidden>Y</hidden></item><item><code>RptDate</code><desc>报告日期</desc><hidden>N</hidden><width>70</width></item><item><code>RptTime</code><desc>报告时间</desc><hidden>Y</hidden><width>70</width></item><item><code>Seeing</code><desc>检查所见:</desc><hidden>N</hidden><width>130</width></item><item><code>Diagnosis</code><desc>病理诊断:</desc><hidden>N</hidden><width>130</width></item><item><code>PathId</code><desc>病理号:</desc><hidden>N</hidden></item></child></show><reference><parent><item><code>ordername</code><desc>医嘱项:</desc><separate>,</separate></item><item><code>SpeInfo</code><desc>标本信息:</desc><separate/></item></parent><child><item><code>RptDate</code><desc>报告日期:</desc><separate>,</separate><check>Y</check></item><item><code>RptTime</code><desc>报告时间:</desc><separate>,</separate><check>N</check></item><item><code>Seeing</code><desc>检查所见:</desc><separate>,</separate><check>Y</check></item><item><code>Diagnosis</code><desc>病理诊断:</desc><separate>,</separate><check>Y</check></item><item><code>PathId</code><desc>病理号:</desc><check>Y</check><separate/><check>Y</check></item></child><separate>enter</separate></reference></scheme>","界面29|资源区病理引用格式","") 
	if (status '= "1") 
	{
		w !,"初始化 PatholScheme 失败"
		q
	}
	else
	{
		w !,"初始化 PatholScheme 成功"
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("MessageScheme","{'alert':'2000','warning':'5000','forbid':'7000','height':'30','fontsize':'14'}","界面20|操作病历时提示信息在界面上停留时间（以毫秒为单位),height提示信息框的高度,fontsize为提示信息字体的大小","") 
	if (status '= "1") 
	{
		w !,"初始化 MessageScheme 失败"
		q
	}
	else
	{
		w !,"初始化 MessageScheme 成功"
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("IsSetToPortal","N","系统15|是否启用消息推送给Portal系统，默认为N，如果推送给Portal,设为Y","") 
	if (status '= "1") 
	{
		w !,"初始化 IsSetToPortal 失败"
		q
	}
	else
	{
		w !,"初始化 IsSetToPortal 成功"
	}

	s status = ##Class(EMRservice.BL.BLSysOption).Insert("CreateElementSection","N","系统06|是否屏蔽新建元素和章节显示[屏蔽->Y][不屏蔽->N]","") 
	if (status '= "1") 
	{
		w !,"初始化 CreateElementSection 失败"
		q
	}
	else
	{
		w !,"初始化 CreateElementSection 成功"
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("ZorderScheme","<scheme><show><item><code>OrdCreateDate</code><desc>医嘱日期</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>ArcimDesc</code><desc>医嘱名称</desc><hidden>N</hidden></item><item><code>RecipeInfo</code><desc>处方信息</desc><hidden>N</hidden></item><item><code>DoseQty</code><desc>剂量</desc><hidden>N</hidden></item><item><code>DoseUnit</code><desc>剂量单位</desc><hidden>N</hidden></item><item><code>Instr</code><desc>服用方法</desc><hidden>N</hidden></item><item><code>PHFreq</code><desc>频率</desc><hidden>N</hidden></item><item><code>OrdXDate</code><desc>OrdXDate</desc><hidden>Y</hidden></item><item><code>OrdDepProcNotes</code><desc>OrdDepProcNotes</desc><hidden>Y</hidden></item></show><reference><items><item><code>ArcimDesc</code><desc></desc><separate>enter</separate></item><item><code>RecipeInfo</code><desc></desc><separate>,</separate></item><item><code>Instr</code><desc></desc><separate>,</separate></item><item><code>DoseQty</code><desc></desc><separate></separate></item><item><code>DoseUnit</code><desc></desc><separate>,</separate></item><item><code>PHFreq</code><desc></desc><separate></separate></item></items><separate>enter</separate></reference></scheme>","界面31|资源区中草药引用格式","") 
	if (status '= "1") 
	{
		w !,"初始化 ZorderScheme 失败"
		q
	}
	else
	{
		w !,"初始化 ZorderScheme 成功"
	}

	s status = ##Class(EMRservice.BL.BLSysOption).Insert("OPEmrButtons","btnSave:保 存;btnPrint:打 印;btnDelete:删 除;btnTemplateclassify:模板选择;btnSpechars:特殊符号","界面32|门诊病历的按钮，请从[btnSave:保 存;btnPrint:打 印;btnDelete:删 除;btnTemplateclassify:模板选择;btnSpechars:特殊符号;btnRefreshRefData:刷新数据;btnTest:测试;btnAsrVoice:语音输入]中挑选适用于项目的按钮","") 
	if (status '= "1") 
	{
		w !,"初始化 OPEmrButtons 失败"
		q
	}
	else
	{
		w !,"初始化 OPEmrButtons 成功"
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("Observer","N","系统14|是否启用病历信息订阅与发布，默认为N","") 
	if (status '= "1") 
	{
		w !,"初始化 Observer 失败"
		q
	}
	else
	{
		w !,"初始化 Observer 成功"
	}	
			
	w !,"门诊资源区历史就诊"
	&Sql(update EMRmeta.OPResource set Href = null, Content = 'emr.op.history.csp?PatientID=@patientID&EpisodeID=@episodeID', Frame='admHistoryFrame' where Name = 'admHistory')
	
	w !,"门诊使用住院的知识库"
	&Sql(update EMRmeta.OPResource set Content='emr.resource.kbtree.csp' where name ='knowledgeBase')
}

ClassMethod V1660()
{
	s status = "0"
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("COLOR_PAPER_BACKGROUND","#FFFFFF","界面35|编辑器背景色配置（默认#FFFFFF）","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 COLOR_PAPER_BACKGROUND 失败"
		q
	}	
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("MedicalRecordDocID","NULL","业务01|是否打印病案首页成功后，对外提供访问出院患者列表。若启用该功能，则把此系统参数的值设置为：病案首页展现结构的docID（挂靠界面模板的目录ID）；若不启用此功能，则把值设置为空。默认为空","False") 
	if (status '= "1") 
	{
		w !,"初始化 MedicalRecordDocID 失败"
		q
	}
}

ClassMethod V1700()
{
	s status = "0"
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("DisableFont","","界面37|前台屏蔽工具栏字体等按钮。包括：字体font，粗体bold，斜体italic，下划线underline，删除线strike，增加缩进量indent，减少缩进量unindent，字体颜色fontcolor，两端对齐alignjustify，左对齐alignleft，居中对齐aligncenter，及右对齐alignright。若需要屏蔽，则把按钮ID写上，以英文逗号隔开。默认为空","False") 
	if (status '= "1") 
	{
		w !,"初始化 DisableFont 失败"
		q
	}
	
	w !,"重新索引EMRmeta.EMROrganizationSchemeLoc"
	d ##class(EMRmeta.EMROrganizationSchemeLoc).%BuildIndices()
	
	w !,"重新索引EMRmeta.CTOrganizationSchemeItem"
	d ##class(EMRmeta.CTOrganizationSchemeItem).%BuildIndices()
	
	w !,"重新索引EMRinstance.plugin.RefreshBindData"
	d ##class(EMRinstance.plugin.RefreshBindData).%BuildIndices()	
	
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("START_FROM_LAST_MODIFY","Y","界面38|从上一次修改位置开始书写","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 START_FROM_LAST_MODIFY 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("IsDisplayAllPersonalKBNode","Y","界面39|资源区个人知识库是否显示该医生创建的所有个人知识库，不区分科室。[显示该医生创建的所有个人知识库->Y,只显示当前科室下医生创建的个人知识库->N ]。默认为 Y","False") 
	if (status '= "1") 
	{
		w !,"初始化 IsDisplayAllPersonalKBNode 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SetRecordReferenceLayout","south","界面40|设置病历参考布局左右对照或者上下对照。[病历参考左右对照->east ,上下对照->south]。默认为south","False") 
	if (status '= "1") 
	{
		w !,"初始化 SetRecordReferenceLayout 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("opHistoryCount","3","界面41|门诊历史就诊每次获取的条数，默认为3条","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 opHistoryCount 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isFilterOPHistoryEmr","N","界面42|门诊历史就诊是否过滤掉未书写过病历的接诊，默认为N","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 isFilterOPHistoryEmr 失败"
		q
	}
	
	//修改历史就诊的链接，请执行
    d ##class(EMRmeta.OPResource).UpdateData()
    d ##class(EMRmeta.OPResource2).UpdateData()
    
	//初始化门诊病历链接单元
	d ##Class(EMRmeta.OPUnitLink).Init()
	
	//初始化签名
	&sql(Insert into EMRmeta.SignRole(ActionCode,Description,IsValid,Name) values ('Check','三级医师审核',1,'Check'))
    do ##class(EMRinstance.EMRSign).%BuildIndices()
}

ClassMethod V1710()
{
	s status = "0"
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isIncludeOeordHistory","N","界面43|门诊历史就诊是否包含医嘱信息，默认为N，调用医生站oeorder.opbillinfo.csp","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 isIncludeOeordHistory 失败"
		q
	}
	
	//w !,"重新索引EMRmeta.KBTree"
	//d ##class(EMRmeta.KBTree).%BuildIndices()
	
	//w !,"重新索引EMRmeta.KBNode"
	//d ##class(EMRmeta.KBNode).%BuildIndices()
	
	w !,"门诊范例病历转移至资源区"
	d ##Class(EMRmeta.ModelInstanceData).AddSequence()
	
	w !,"更新签名角色基础数据"
    d ##Class(EMRservice.BL.BLSignRole).IniData()
    
    /* w !,"重新索引签名角色表"
    do ##class(EMRmeta.SignRole).%BuildIndices()	
	*/
	
	//检查状态流转表数据
   &sql(update EMRmeta.EMRActStatusCfg set PostStatus='finished' where EMRAction='save')
  	
  	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SHOW_SELECT_INIT_ELEMENT_DIALOG_LIMIT","Y","系统19|是否限制选中初始单元弹出对话框（Y限制、选中初始单元不弹框）","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 SHOW_SELECT_INIT_ELEMENT_DIALOG_LIMIT 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SET_WIDGET_FONT_SIZE","Y","系统20|设置widget字号大小","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 SET_WIDGET_FONT_SIZE 失败"
		q
	}
	
	w !,"初始化诊断链接单元EMRservice.BL.HyperLink"
	d ##Class(EMRservice.BL.HyperLink).Init()
	
	&sql(INSERT INTO EMRmeta.EMRProduct VALUES ('GlobalEMR','新版电子病历'))
}

ClassMethod V1720()
{
	
	w !,"病种数据迁移"
	d ##class(EMRmeta.DiagnosGroup).%BuildIndices()
    d ##Class(EMRservice.Tools.Tool).DiagnosDatasMoveTo()
	
	w !,"ie前端病种数据初始化"
    d ##class(EMRmeta.DiagnosCategory).%BuildIndices()
    d ##class(EMRmeta.Diagnos).%BuildIndices()
    k ^DHCEMRM.DiagnosGroupDetailI
    d ##class(EMRmeta.DiagnosGroupDetail).%BuildIndices()
    
    w !,"重建标题索引 "
    d ##class(EMRmeta.TitleConfig).%BuildIndices()
    
    w !,"更新基础医师级别关联表 "
    d ##Class(EMRservice.BL.BLSignRoleLinkCarPrvTp).InitData()
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isAutoSelectTemplate","N","界面44|未创建病历时打开门诊病历，是否默认弹出模板选择界面，默认为N","False") 
	if (status '= "1") 
	{
		w !,"初始化 isAutoSelectTemplate 失败"
		q
	}
}

ClassMethod V1730()
{
	
	k ^DHCEMRM.PrivRuleListI
    k ^DHCEMRM.PrivRuleListD
    d ##Class(EMRservice.BL.BLSignRole).IniData()
    
    w !,"重建术语集索引 "
    d ##Class(EPRservice.BLL.BLGlossaryClassProperty).initData()
    
    d ##Class(EMRservice.BL.BLSignRoleLinkCarPrvTp).InitData()
    
    d ##Class(EMRservice.BL.HyperLink).Init()
    
    d ##class(EMRmeta.CategoryViewDisplay).%BuildIndices()
    
    d ##class(EMRmeta.UserPageConfig).%BuildIndices()
	
	d ##Class(EMRservice.BL.BLClientCategory).GetCategoryNameJaneSpellAndFullFight(0)
	
	&sql(UPDATE  EMRmeta.TitleCategory t SET t.Sequence = t.ID)
	
	d ##class(EMRmeta.TitleCategory).%PurgeIndices()
	
    d ##Class(EMRmeta.TitleCategory).%BuildIndices()
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("LevelSource","EMR","系统24｜取病历级别来源[默认值'EMR' 取电子病历级别,'HIS' 取his维护级别]","False") 
	if (status '= "1") 
	{
		w !,"初始化 LevelSource 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SignLogic","EMR","系统25｜设置签名逻辑[默认值'EMR' 使用电子病历三级医师签名逻辑,'Custom'项目定义逻辑，如项目设置患者固定 三级医师]","False") 
	if (status '= "1") 
	{
		w !,"初始化 SignLogic 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("ConsultScheme","","界面49|资源区会诊显示引用格式，<interface></interface>为接口调用设置，默认为HIS自带的接口，即<interface>HIS</interface>，调用其他接口在<interface></interface>中设置即可","False") 
	if (status '= "1") 
	{
		w !,"初始化 ConsultScheme 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("HIDE_EDITOR_RULER","N","界面45|是否隐藏标尺，Y/N[启用->Y][禁用->N]","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 HIDE_EDITOR_RULER 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SetAppointMsgToDoc","N","系统22|病历授权模块，授权或者拒绝时，是否给申请医生发送消息到消息平台，默认为N","False") 
	if (status '= "1") 
	{
		w !,"初始化 SetAppointMsgToDoc 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("IsRevokeSign","N","系统26｜设置是否开启撤销签名功能[Y：开启，N:关闭]","False") 
	if (status '= "1") 
	{
		w !,"初始化 IsRevokeSign 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("RequestReasonLimitStr","False","控制申请原因、修改前内容、修改后内容最少字数。","False") 
	if (status '= "1") 
	{
		w !,"初始化 RequestReasonLimitStr 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("ReturnTemplateIDs","False","系统29｜门诊部分模板必填项没有填写，不能保存病历，维护模板ID，以'^'开始，以'^'结束，多个模板用'^'拼接[^1^2^...^]","False") 
	if (status '= "1") 
	{
		w !,"初始化 ReturnTemplateIDs 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SetOPDefaultFontStyle","'fontFamily':'宋体','fontSize':'12pt','lineSpace':'1.5','fontSpace':'0'","系统27|设置门诊病历默认字体","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 SetOPDefaultFontStyle 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("FilterOrder","N^N^N","界面48|资源区的医嘱数据是否过滤，过滤为Y；不过滤为N；过滤顺序为作废医嘱、停止医嘱、非医生所下医嘱(护士补录医嘱等)，默认为N^N^N","False") 
	if (status '= "1") 
	{
		w !,"初始化 FilterOrder 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SearchAcrossDepartment","<scheme><item><code>6</code><desc>知情同意书</desc></item></scheme>","界面46|病历导航页面知情告知实现跨科搜索模板（code为病历展现结构的DocID）","False") 
	if (status '= "1") 
	{
		w !,"初始化 SearchAcrossDepartment 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("CardClassificationDisplay","N","界面47|病历导航页面卡片分类显示,病历模板和实例分开显示,新建卡片在上,实例病历在下（Y：开启）","False") 
	if (status '= "1") 
	{
		w !,"初始化 CardClassificationDisplay 失败"
		q
	}
}

ClassMethod V1740()
{
	w !,"重建范例病历索引 "
    DO ##class(EMRmeta.ModelInstanceData).%BuildIndices()
    
    w !,"特殊字符上标初始化 "
    d ##Class(EMRservice.BL.BLSpechars).setDefaultSpechars()
    
    w !,"初始化诊断控件引用格式 "
    d ##Class(EMRservice.BL.HyperLink).Init()
    
    d ##Class(EMRservice.BL.BLDicDiagnosPosition).InitData()
    
    w !,"初始化手术事件 "
    d ##Class(EMRservice.BL.Event.BLEventConfig).InitEventConfig()
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("RecordSequence","","界面50|病历目录显示顺序【DESC 倒序，ASC 顺序；NavReord 导航目录,TimeLineRecord 时间轴】","False") 
	if (status '= "1") 
	{
		w !,"初始化 RecordSequence 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("InformedConsentEmrTID","6","维护02|病历分组维护中展现结构树加载的知情告知目录ID集,类型为Category [目录1^目录2]","False") 
	if (status '= "1") 
	{
		w !,"初始化 InformedConsentEmrTID 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("EnableCMVTOOL","N","系统30|是否启用分词工具，默认为N[启用->Y][禁用->N]","False") 
	if (status '= "1") 
	{
		w !,"初始化 EnableCMVTOOL 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("COLOR_PAPER_BACKGROUND","#90EE90","界面35|编辑器背景色配置（默认#FFFFFF）","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 COLOR_PAPER_BACKGROUND 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("DISABLE_DROP_NON_EDITOR","N","界面50|是否禁止拖拽外部数据到编辑器[启用->Y][禁用->N]默认为N","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 DISABLE_DROP_NON_EDITOR 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SignTypeInP","Text","系统34|住院病历签名类型（Graph-图片签名，Text-文字签名)","False") 
	if (status '= "1") 
	{
		w !,"初始化 SignTypeInP 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("ENABLE_DOCTOR_REVISION_MODE","N","系统35|设置客户机编辑器留痕模式，是否开启医生分级留痕显示 默认为N[启用->Y][禁用->N]","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 ENABLE_DOCTOR_REVISION_MODE 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("TaskFPDocID","","要开启队列功能的病案首页DocID","False") 
	if (status '= "1") 
	{
		w !,"初始化 TaskFPDocID 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isDeleteVerification","N","界面51|删除病历时，是否需要用户输入创建者的密码[启用->Y][禁用->N]默认为N ","False") 
	if (status '= "1") 
	{
		w !,"初始化 isDeleteVerification 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("NotRemoveMinus","SQLUser.MRC_ICDDx｜MRCID_Desc","系统31|字典查询中将不去“-”的字典名，描述列出来【如：SQLUser.MRC_ICDDx｜MRCID_Desc】","False") 
	if (status '= "1") 
	{
		w !,"初始化 NotRemoveMinus 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("EnableOPLock","N","系统33|门诊病历是否启用独占锁","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 EnableOPLock 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("AuthRequestByPriented","N","系统36|病历操作权限申请时，如果病历在病案室已经被复印过，是否开启提示功能；[开启->Y][不开启->N]","False") 
	if (status '= "1") 
	{
		w !,"初始化 AuthRequestByPriented 失败"
		q
	}
}

/// 1750基础数据初始化
ClassMethod V1750()
{
    w !,"重建索引 "
    d ##class(EMRmeta.EMRTemplate).%BuildIndices()
    d ##class(EMRmeta.UserTemplate).%BuildIndices()
    d ##class(EMRmeta.UserTemplateGroup).%BuildIndices()
    d ##Class(EMRmeta.TitleConfig).%BuildIndices()
    
    do ##class(EMRmeta.CTOrganizationSchemeItem).%BuildIndices()
    
    d ##Class(EMRservice.BL.BLEPRPageURL).InitAllPageUrlsType()
    
    do ##class(EMRmeta.TextKBCategory).%BuildIndices()
    
    do ##class(EMRinstance.IMacroObjectItems).%BuildIndices()
	
	d ##class(EMRinstance.ApplyEdit).%BuildIndices()
    
    MERGE ^DHCEMRM.Image.UserImageD = ^EMRmeta.Image.UserImageD
    do ##class(EMRmeta.Image.UserImage).%BuildIndices()
    k ^EMRmeta.Image.UserImageD
    k ^EMRmeta.Image.UserImageI
    
    &sql(update EMRmeta.SignRole set SignPrefix= 1 where Name in ('student','intern','Refresher'))
    
    w !,"初始化诊断控件引用格式 "
    d ##Class(EMRservice.BL.HyperLink).Init()
    
    
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("EscapeRevokeSignDocID","","系统46|系统启用签名失效后，有个别模板想屏蔽签名失效。若启用该功能，则把此系统参数的值设置为：屏蔽签名失效展现结构的docID（挂靠界面模板的目录ID）；若不启用此功能，则把值设置为空","False") 
	if (status '= "1") 
	{
		w !,"初始化 EscapeRevokeSignDocID 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isSetCurrentRevisorIP","Y","界面53|是否显示留痕信息中的当前操作者的IP（Y:显示；N：不显示，默认为Y）","False") 
	if (status '= "1") 
	{
		w !,"初始化 isSetCurrentRevisorIP 失败"
		q
	}
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SetInternToDocStation","","系统41|提供给医生站接口，返回最新修改过病历的附属账号，用于医生站病人列表显示患者附属账号","False") 
	if (status '= "1") 
	{
		w !,"初始化 SetInternToDocStation 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isSignGraphNoCA","Y","系统43|未开启CA的科室，当前医生绑定签名图片，并且签名参数设置为Graph时，是否图片签名【Y：是；N：否】，默认为Y","False") 
	if (status '= "1") 
	{
		w !,"初始化 isSignGraphNoCA 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("EMRTemplateGroupCGIDS","","维护03|病历展现中对DOCID分组配置[CG1^CG2],CG为病历展现结构CategoryChapter类型的目录ID如（11^10）","False") 
	if (status '= "1") 
	{
		w !,"初始化 EMRTemplateGroupCGIDS 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SignlogType","Last","系统47|签名历史存储类型【Last只存最后一次签名CA历史,All所有历史信息(非CA签名不存原文）】","False") 
	if (status '= "1") 
	{
		w !,"初始化 SignlogType 失败"
		q
	}	

	s status = ##Class(EMRservice.BL.BLSysOption).Insert("PRINT_SHOW_REVISIONS","Y","系统45|留痕显示状态下，是否打印留痕信息[启用->Y][禁用->N]","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 PRINT_SHOW_REVISIONS 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("ELEMENT_DEFAULT_VALUE","-","系统42|配置前端书写界面，对元素通过右键菜单，手动赋予的缺省值","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 ELEMENT_DEFAULT_VALUE 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SHOW_TABLE_DOTTED_LINE","N","系统38|表格书写是否显示虚线边框 默认为Y[启用->Y][禁用->N]","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 SHOW_TABLE_DOTTED_LINE 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("SHOW_WIGEDIT_BY_LEFTCLICK","Y","系统44|配置前端书写时，对非标准字典进行编辑，在富文本编辑框中触发弹出框方式，默认左键双击弹框，设定值为Y时，通过左键单击弹出对话框","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 SHOW_WIGEDIT_BY_LEFTCLICK 失败"
		q
	}
    s status = ##Class(EMRservice.BL.BLSysOption).Insert("ENABLE_REVISION_LINE_BY_LEVEL","Y","系统37|设置客户机编辑器留痕模式，是否3级医生删除病例内容双线表示,2级以下医生用单线显示新增与删除内容 默认为N[启用->Y][禁用->N]","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 ENABLE_REVISION_LINE_BY_LEVEL 失败"
		q
	}
}

/// 1760基础数据初始化
ClassMethod V1760()
{
    w !,"初始化资源区 "
    d ##Class(EMRservice.BL.IPResource).Init()
    
    w !,"初始化术语集目录与病历模板目录的关联 "
    d ##Class(EPRservice.BOGlossaryCategory).MoveGlossaryTemIDs()
	
	w !,"初始化专科知识库 "
    d ##class(EMRmeta.TextKBCategory).%PurgeIndices()
    d ##Class(EMRmeta.TextKBCategory).%BuildIndices()
    &sql(UPDATE EMRmeta.TextKBContent SET Status = '1')
	
	w !,"初始化集中签名"
	d ##Class(EMRservice.BL.GroupSignType).InitData()
   
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("UserTemplateDefaultGroup","N","维护03|科室模板中重复模板是否启用标题默认分组（启用->Y，禁用->N)","False") 
	if (status '= "1") 
	{
		w !,"初始化 UserTemplateDefaultGroup 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("IsSetToLogOP","N","系统49｜门诊病历是否将打印操作发送至涉密患者信息输出审计日志的模块中，进行审计和记录日志；Y：发送；N：不发送(没有患者密级的项目，设为N，默认为N)","False") 
	if (status '= "1") 
	{
		w !,"初始化 IsSetToLogOP 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("NotesScheme","","界面56|资源区语音病程显示引用格式，<pageConfig>Y</pageConfig>为页签上按钮配置项数据是否记录到后台表中，记录为Y，<server></server>为健康乐提供接口地址，<port></port>为健康乐提供接口端口，<posturl></posturl>为就诊号查询对应病程接口路径，<postdetailurl></postdetailurl>为查询病程详情接口路径","False") 
	if (status '= "1") 
	{
		w !,"初始化 NotesScheme 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("QueryAllDiagnos","38||HDSD00.11.021^HDSD00.11.306^HDSD00.11.310^HDSD00.11.314","界面57|综合查询HIS中增加查询所有诊断术语集配置（模板ID||术语集内部标示符1^术语集内部标识符2^...）","False") 
	if (status '= "1") 
	{
		w !,"初始化 QueryAllDiagnos 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("ImageNoExport","^","维护03|保存病历时插入图片导出队列，屏蔽就诊类型[屏蔽->^I^O^][不屏蔽->^]","False") 
	if (status '= "1") 
	{
		w !,"初始化 ImageNoExport 失败"
		q
	}	

    s status = ##Class(EMRservice.BL.BLSysOption).Insert("OnlyICD","N","系统48|诊断控件是否可以下非ICD诊断【Y：是；N：否】，默认为N","False") 
	if (status '= "1") 
	{
		w !,"初始化 OnlyICD 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("isDefaultviewRevision","N","界面55|住院病历书写界面是否默认显示留痕【Y：是；N：否】，默认为N，不显示留痕","False") 
	if (status '= "1") 
	{
		w !,"初始化 isDefaultviewRevision 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("IsAppendCompositeAdvanced","N","系统59|是否使用知识库嵌套功能：值为Y，有且使用知识库嵌套功能；值为N:没有或不使用知识库嵌套功能；默认值为N；","False") 
	if (status '= "1") 
	{
		w !,"初始化 IsAppendCompositeAdvanced 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("CrisisRolling","Y","系统40|危机值是否滚动提示[滚动->Y][静止->N]","False") 
	if (status '= "1") 
	{
		w !,"初始化 CrisisRolling 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("COLOR_READ_ONLY_ELEMENT_TEXT","#C0C0C0","界面54|编辑器只读元素字体颜色配置（默认值#C0C0C0）","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 COLOR_READ_ONLY_ELEMENT_TEXT 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("DISABLE_AUTO_LINEBREAK","N","系统58|编辑器自动排版控制,[启用->Y][禁用->N]默认为N","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 DISABLE_AUTO_LINEBREAK 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("IGNORE_DICTIONARY_DEFAULT_QUERY","—","忽略字典元素默认值作为检索查询条件","TRUE") 
	if (status '= "1") 
	{
		w !,"初始化 IGNORE_DICTIONARY_DEFAULT_QUERY 失败"
		q
	}
}

/// 1770基础数据初始化
ClassMethod V1770()
{
   
    w ##Class(EMRservice.BL.BLExportQueue).UpdateAdmType()
    
    d ##Class(EMRinstance.Export.Queue).%BuildIndices()
    d ##Class(EMRinstance.Export.Exe).%BuildIndices()
    d ##Class(EMRinstance.Export.Failure).%BuildIndices()
   
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("AllowDefault","N","系统60|申请权限界面是否默认选中权限类型和实例病历[选中->Y][不选中->N]","False") 
	if (status '= "1") 
	{
		w !,"初始化 AllowDefault 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("FTP_CONNECT_CDAXML","'server':'127.0.0.1','port':'21','username':'ftpuser','password':'ftpuser','timeout':'3000'","系统08|设置病历CDAxml上传Ftp参数","False") 
	if (status '= "1") 
	{
		w !,"初始化 FTP_CONNECT_CDAXML 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("resTabPosition","top","界面59|设置门诊病历资源区页签显示在上方还是右侧[页签显示在上->top,显示在右侧->right]。默认为top，此参数只适用于emr.op.main.csp页面","False") 
	if (status '= "1") 
	{
		w !,"初始化 resTabPosition 失败"
		q
	}
	
	s status = ##Class(EMRservice.BL.BLSysOption).Insert("IsClinicPathVerification","N","界面60|在电子病历—入院记录中，医生填写保存时调取临床路径的入径【入院记录模板的DocId】","False") 
	if (status '= "1") 
	{
		w !,"初始化 IsClinicPathVerification 失败"
		q
	}
}

}

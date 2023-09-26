/// Desc:       系统运行必备参数
/// Creator:    Candy
/// CreateDate: 2015-6-9
Class EMRservice.SystemParameter Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       检验数据引用格式化引用单位 数组
///            如:{"string":"10S","subChar1":"S","subChar2":"/","Style":"SUPER"} 内容包含"10S"的10S9/L 将S与/字符中间的内容设置为上标
/// Creator:    Candy
/// CreateDate: 2015-6-9
/// Input:      
/// Output:     [{"string":"10S","subChar1":"S","subChar2":"/","Style":"SUPER"},{"string":"10~","subChar1":"/","Style":"SUPER"}]   
/// Debug:      w ##Class(EMRservice.SystemParameter).LisDataFormat()
ClassMethod LisDataFormat() As %String
{
	s result = "["
	s result = result_"{""string"":""10S"","
	s result = result_"""subChar1"":""S"","
	s result = result_"""subChar2"":""/"","
	s result = result_"""Style"":""SUPER""},"
	s result = result_"{""string"":""10~"","
	s result = result_"""subChar1"":""~"","
	s result = result_"""subChar2"":""/"","
	s result = result_"""Style"":""SUPER""},"
	s result = result_"{""string"":""10*"","
	s result = result_"""subChar1"":""*"","
	s result = result_"""subChar2"":""/"","
	s result = result_"""Style"":""SUPER""},"
	s result = result_"{""string"":""10^"","
	s result = result_"""subChar1"":""^"","
	s result = result_"""subChar2"":""/"","
	s result = result_"""Style"":""SUPER""}"				
	s result = result_"]"
	q result
}

/// Desc:  IE前端的个人知识库默认闭合与展开设置
///        如果默认知识库目录全部展开，则设置为 q "1"  如果默认知识库目录展开到第二层，则设置为 q "2"
/// 	   如果默认知识库目录展开到文件夹的最后一层，折叠知识库节点，则设置为 q "3"
/// Creator:    DongLulu
/// CreateDate: 2015-11-26
/// Input:      无
/// Output:     1/2/3
/// Debug:      w ##Class(EMRservice.SystemParameter).SetKnowledgeBaseCollapse()
ClassMethod SetKnowledgeBaseCollapse() As %String
{
	q "1"
}

/// Desc:  病历展现结构树节点删除控制。
///        允许删除，则设置为 q "1"  不允许删除，则设置为 q "0"
/// Creator:    yejian
/// CreateDate: 2016-1-11
/// Input:      无
/// Output:     1/0
/// Debug:      w ##Class(EMRservice.SystemParameter).SetEMRShowTreeNodeDelete()
ClassMethod SetEMRShowTreeNodeDelete() As %String
{
	q "0"
}

/// Desc:       病历显示属性
///             DefaultForm:病历默认打开显示页面[Nav 导航页面,Edit 病历编辑页面]
///             EditRecordDisplayType:编辑页面.病历导航显示样式[List 列表显示,Tree 树分类显示]
/// Creator:    Candyxu
/// CreateDate: 2016-1-19
/// Debug:      w ##Class(EMRservice.SystemParameter).GetPageAttribute()
ClassMethod GetPageAttribute() As %String
{
    q "{'DefaultForm':'Nav','EditRecordDisplayType':'List'}"
}

///             EditRecordDisplayType:编辑页面.病历导航显示样式[List 列表显示,Tree 树分类显示]
/// Creator:    HouJian
/// CreateDate: 2019-11-05
/// Debug:      w ##Class(EMRservice.SystemParameter).GetEditRecordDisplayType()
ClassMethod GetEditRecordDisplayType() As %String
{
	s config = ..GetPageAttribute()
    q:($f(config, "'EditRecordDisplayType':'Tree'}") > 0) "Tree"
    q "List"
}

/// Desc:       病历浏览目录是否为分类目录显示
///             Display:病历浏览目录默认显示值[All 所有目录都显示,Fold 分类目录显示]
///             Default:病历浏览目录默认显示类型[List 目录列表显示,ZTtree 目录树形显示]
/// Creator:    Lina
/// CreateDate: 2016-1-21
/// Input:      Action:调用病历浏览界面的操作[quality 病历质控页面调用显示,默认或者为空 正常病历浏览页面显示]
/// Debug:      w ##Class(EMRservice.SystemParameter).GetBrowseShow()
ClassMethod GetBrowseShow(Action As %String = "") As %String
{
    // 病历质控页面调用
    if (Action = "quality") {
	    q "{'Display':'All','Default':'List'}"
	}else {
		q "{'Display':'All','Default':'List'}"
	}
}

/// Desc:       必填项检查标志
///            Grid/Word 值为1表示检查必填项,为0不检查
/// Creator:    Candyxu
/// CreateDate: 2016-3-23
/// Debug:      w ##Class(EMRservice.SystemParameter).GetRequiredFlag()
ClassMethod GetRequiredFlag() As %String
{
	q "{'Grid':'0','Word':'0'}"
}

/// Desc:   门诊必填项检查标志
///            Grid/Word 值为1表示检查必填项,为0不检查
/// CreateDate: 2018-11-30
/// Debug:      w ##Class(EMRservice.SystemParameter).GetOPRequiredFlag()
ClassMethod GetOPRequiredFlag() As %String
{
	q "{'Grid':'1','Word':'1'}"
}

/// Desc:       住院病历中病历页签的病历导航框的宽度设置
///             Height:住院病历中病例页签的病历导航框的宽度默认显示值[建议最小值为:190]
/// Creator:    Lina
/// CreateDate: 2016-5-12
/// Debug:      w ##Class(EMRservice.SystemParameter).GetWidth()
ClassMethod GetWidth() As %String
{
    q 280
}

/// 获取后台类当前运行的服务器的IP，有可能是ECP或是DB
/// 如果服务器有双网卡，获取IP之后，需特殊处理
/// 例如：项目经理提供的DB的IP为 172.21.21.3
/// 但是在terminal运行 $P($zu(54,13,$zu(54,0)),",",1)
/// 得到的IP是 172.21.21.21
/// 则需增加 q:(Address="172.21.21.21") "172.21.21.3"
/// 通过terminal  登录上之后，不要进cache，直接敲  netstat -in
ClassMethod GetServerIP() As %String
{
	s Address=$P($zu(54,13,$zu(54,0)),",",1)
	//q:(Address="172.19.19.57") "114.251.235.112"
	q Address
}

/// Desc:病历失效类型
/// Creator:Candy
/// CreateDate:2016-8-1
/// Output: Superior 失效本级及上级
///        All      失效所有
ClassMethod GetRevokeStatus() As %String
{
	///result 值域[All,Superior,Patient]
	s result = "All"
	q result
}

/// 门诊 就诊历史页面取数方法
/// w ##Class(EMRservice.SystemParameter).GetOPHistoryMethod()
ClassMethod GetOPHistoryMethod() As %String
{
	//q "GetOPHistory"  // 按时间排序，第一次获取指定就诊日期之前的就诊
	q "GetOPHistoryAll"  // 第一次从最新的就诊开始获取
}

/// Desc:  住院病案首页(编目)DOCID
///           
/// Creator:    GUOZONGTAO
/// CreateDate: 2016-8-23
ClassMethod GetDHCEMRFPDocID() As %String
{
    q "640"
}

/// Desc:       门诊病历中病历资源区所占的界面宽度设置
/// 			可以设置为固定值，比如800、1000(建议最小值为500)；或者设置为界面百分比，默认0.382(建议最小值为0.3)
/// 			此参数针对emr.opdoc.main.csp界面
/// CreateDate: 2017-3-22
/// Debug:      w ##Class(EMRservice.SystemParameter).GetOPWidth()
ClassMethod GetOPWidth() As %String
{
	q "0.382"
}

/// Desc:        公共csp引用css等文件
/// Creator:		Candy
/// CreateDate:  2017-3-31
ClassMethod GetImportResource(AName As %String = "")
{
	if (AName = "")
	{
		w "<link rel='stylesheet' type='text/css' href='../scripts/emr/css/body.css'/>"
	}
	//获取每个项目上个性化的css样式 add by niucaicai 2018-7-17
	elseif (AName = "CSSofHos")
	{
		s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		if (Hospital = "CQZYY")
		{
			w "<link rel='stylesheet' type='text/css' href='../scripts/emr/css/ip.navigation.template.zTreeStyle.css'/>"
		}
	}
}

/// Desc:        病历系统中引用基础平台要求的ExtJS样式规范css
/// Creator:	 牛才才
/// CreateDate:  2017-6-30
/// d ##Class(EMRservice.SystemParameter).GetExtJSCSS()
ClassMethod GetExtJSCSS(AName As %String = "")
{
	if (AName = "")
	{
		w "<link rel='stylesheet' type='text/css' href='../scripts/emr/css/websys.ext.3.2.1.css'/>"
	}
}

/// Desc:       质控标注颜色
/// Creator:	Candy
/// CreateDate: 2017-8-25
/// w ##Class(EMRservice.SystemParameter).QulaityColor()
ClassMethod QulaityColor() As %String
{
	s result = "{""QCColor"":""ff0000"",""RecoverColor"":""ffffff""}"
	q result
}

/// Desc:        获取语音识别应用产品标识
/// 				 YZS-云之声语音识别，SDTL-时代拓灵语音识别
/// Creator:	 董璐璐
/// CreateDate:  2017-9-13
/// d ##Class(EMRservice.SystemParameter).GetASRProductName()
ClassMethod GetASRProductName() As %String
{
	q "SDTL"
}

/// 资源区检查、检验接口的开始时间是否为建住院证日期，南大二附院个性化修改
/// Output：返回"Y"  按建住院证时间取
///         默认返回"N"  按就诊时间取
/// w ##Class(EMRservice.SystemParameter).GetResourceStartDate()
ClassMethod GetResourceStartDate() As %String
{
	//q "Y" //检查、检验接口的开始时间取建住院证的时间，南大二附院个性化修改
	q "N" //检查、检验接口的开始时间取就诊的时间
}

/// Desc:       创建模板方式 
///             LoadMode:UserTemplate 用户模板创建，否则使用模板创建
///             IsStream:true 当使用用户模板创建 IsStream为 true时使用用户模板流创建
/// Creator:	Candy
/// CreateDate: 2017-12-01
/// w ##Class(EMRservice.SystemParameter).GetCreateStatus()
ClassMethod GetCreateStatus()
{
	q "{""LoadMode"":""UserTemplate"",""IsStream"":""false""}"
}

/// Desc:  是否启用改变病历时间，改变目录的颜色以示区分。【Y:开启；N：关闭】
/// Creator:    Donglulu
/// CreateDate: 2017-12-8
/// Input:      无
/// Output:     1/0
/// Debug:      w ##Class(EMRservice.SystemParameter).IsModifyRecordChangeColor()
ClassMethod IsModifyRecordChangeColor() As %String
{
	q "N"
}

/// 开启兼容模式的项目，请放开方法内的注释
/// d ##Class(EMRservice.SystemParameter).IECompatible()
ClassMethod IECompatible()
{
	w "<meta http-equiv=""X-UA-Compatible"" content=""IE=8"" />"
}

/// Desc:      取住院模板使用类型
/// Creator:   Candy
/// CreateDate:2017-12-26
/// InPut:     
/// OutPut:    UserTemplate(用户模板)/Template(默认实现方式) </Description>
ClassMethod GetIPTemplateType() As %String
{
	q "UserTemplate"
}

/// Desc:      授予检查、检验、病理的接收科室病历浏览权限的时间(以秒为单位)
/// Creator:   Donglulu
/// CreateDate:2018-1-12
/// InPut:     
/// OutPut:    授予浏览权限时间(以秒为单位)
/// Debug:     w ##Class(EMRservice.SystemParameter).GetAppointBrowseTime()
ClassMethod GetAppointBrowseTime() As %String
{
	q "86400"
}

/// Desc:      授予会诊科室病历书写权限的时间(以秒为单位)
/// Creator:   yan
/// CreateDate:2018-7-26
/// InPut:     
/// OutPut:    授予书写权限时间(以秒为单位)
/// Debug:     w ##Class(EMRservice.SystemParameter).GetAppointEditTime()
ClassMethod GetAppointEditTime() As %String
{
	q "86400"
}

/// Desc:      配置病程记录的DocID和titleCode
/// Creator:   Candy
/// CreateDate:2018-1-29 
ClassMethod GetFirstRecordConfig() As %String
{
	q "DocID:66,TitleCode:EMR100001#DocID:641,TitleCode:EMR100001"
}

/// Desc:  		病历导航页面卡片是否显示“待签”标志
/// Creator:    董璐璐
/// CreateDate: 2018-5-16
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsShowToBeSignedSymbol()
ClassMethod IsShowToBeSignedSymbol() As %String
{
	q "Y"
}

/// Desc:  		点击工具栏“送病案室”按钮确认病历全部完成后，是否在导航页显示提示
/// Creator:    董璐璐
/// CreateDate: 2018-5-16
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsShowCompleteSymbol()
ClassMethod IsShowCompleteSymbol() As %String
{
	q "Y"
}

/// Desc:      病历引用是否可以引用同一模板不同版本的病历
/// Creator:   Candy
/// CreateDate:2018-5-31
/// Output:    1 可以引用不同版本病历，0不可以引用不同版本病历
ClassMethod GetQuotationStatus()
{
	q "1"
}

/// Desc:       融合版列表视图默认展开或闭合
///             返回collapse：默认闭合；expand：默认展开
/// Creator:    Donglulu
/// CreateDate: 2018-6-28
/// Debug:      w ##Class(EMRservice.SystemParameter).GetListDisplayExpandType()
ClassMethod GetListDisplayExpandType() As %String
{
    q "collapse"
}

/// Desc:  		医生端病历中右键中是否要段落的设置
/// Creator:    董璐璐
/// CreateDate: 2018-7-3
/// Input:      无
/// Output:     true/false
/// Debug:      w ##Class(EMRservice.SystemParameter).SetMenuEditParagraphVisible()
ClassMethod SetMenuEditParagraphVisible() As %String
{
	q "true"
}

/// Desc:      设置电子病历编辑器每隔多久检查是否为活跃状态(以豪秒为单位)
/// 		   如果为活跃状态(正在书写)，调用平台组接口防止锁屏，不需要的项目q ""
/// Creator:   yan
/// CreateDate:2018-07-20
/// OutPut:    
/// Debug:     w ##Class(EMRservice.SystemParameter).GetEMRHeartBeatTime()
ClassMethod GetEMRHeartBeatTime() As %String
{
	q "600000"     //十分钟
	//q ""           //不需要的项目q ""
}

/// Desc:       设置留痕显示属性
///             mode:		LineByLevel表示按级别区分删除线,默认为空
///             Resident:   实习,见习医生字体显示颜色例如：#000000表示黑色.
///             Attending:  主治医生住院医生字体显示颜色例如：#000000表示黑色.
///             Chief:      副主任，主任医生字体显示颜色例如：#000000表示黑色.
///             LineColor:  删除线颜色例如：#FF0000表示红色.
/// Creator:    Donglulu
/// CreateDate: 2018-7-23
/// Debug:      w ##Class(EMRservice.SystemParameter).GetRevisionSettings()
ClassMethod GetRevisionSettings() As %String
{
    q "{""mode"":"""",""Resident"":"""",""Attending"":"""",""Chief"":"""",""LineColor"":""""}"
}

/// Desc:  		是否启用签名后发消息给病程记录中所选的医师
/// Creator:    董璐璐
/// CreateDate: 2018-7-21
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).SetSendMessageToTitleDoctor()
ClassMethod SetSendMessageToTitleDoctor() As %String
{
	q "Y"
}

/// Desc: 设置自动审批时间
/// Creator: Candy
/// CreateDate: 2018-7-27
/// Input:
/// Output:  返回时间,时间以秒为单位,南方医院要求给24小时时间,返回值为 86400
ClassMethod SetAutoApplyTime() As %String
{
	q 30
}

/// Desc: 设置门诊自动审批时间
/// Creator: 
/// CreateDate: 2019-10-22
/// Input:
/// Output:  返回时间,时间以秒为单位,南方医院要求给24小时时间,返回值为 86400
ClassMethod SetOPAutoApplyTime() As %String
{
	q 60
}

/// Desc:      在打印(保存)特定病历时，调用项目(平台)提供方法进行推送
///            在此方法内写判断条件以及要调用的接口，下方屏蔽的为示例
/// Creator:   yan
/// CreateDate:2018-07-20
/// OutPut:    
/// Debug:     d ##Class(EMRservice.SystemParameter).SetHisService()
ClassMethod SetHisService(AEpisodeID As %String, AEventType As %String, ATemplateID As %String = "", AInstanceIDs As %String = "")
{
	/*if ($p(AEventType,"^",1)="Print")&&(ATemplateID = 20)
	{
		s msg = ##class(DHCENS.NEWEMS.BS.Web).SendpatAllInfoByAdmDr(AEpisodeID)
		d ##class(EMRservice.FirstPage.BOInterfaceLog).SaveLog(msg,AEpisodeID)
	}*/
}

/// Desc:  		病历书写是否需要提供在保存操作时的多人编辑同一份病历的校验功能 
/// Creator:    董璐璐
/// CreateDate: 2018-8-29
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsEnableMultiEditSaveCheck()
ClassMethod IsEnableMultiEditSaveCheck() As %String
{
	q "Y"
}

/// Desc:  		是否允许病程中同时编辑多个病历文档，允许是true，反之是false。
/// Creator:    董璐璐
/// CreateDate: 2018-8-23
/// Input:      无
/// Output:     true/false
/// Debug:      w ##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord()
ClassMethod IsEnableEditMultiRecord() As %String
{
	q "true"
}

/// Desc:  		是否允许弹出签名框时，高级别医师可以选择医师级别，是Y，否N。
/// Creator:    董璐璐
/// CreateDate: 2018-8-27
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsEnableSelectUserLevel()
ClassMethod IsEnableSelectUserLevel() As %String
{
	q "Y"
}

/// Desc:  		设置弹出签名框时，高级别医师可以选择的医师级别范围
/// Creator:    董璐璐
/// CreateDate: 2018-8-27
/// Input:      医师级别
/// Output:     高级别医师可以选择的医师级别范围，用 ^ 分隔
/// Debug:      w ##Class(EMRservice.SystemParameter).GetUserLevelRange("")
ClassMethod GetUserLevelRange(ALevel As %String) As %String
{
	s json = ""
	//主任医师Chief
	if (ALevel = "Chief")
	{
		s json = "Chief^ViceChief^Attending^Resident"
	}
	//副主任医师ViceChief
	elseif (ALevel = "ViceChief")
	{
		s json = "ViceChief^Attending^Resident"
	}
	//主治医师Attending
	elseif (ALevel = "Attending")
	{
		s json = "Attending^Resident"
	}
	//住院医师Resident
	elseif (ALevel = "Resident")
	{
		s json = "Resident"
	}
	else
	{
		s json = ALevel
	}
	q json
}

/// Desc:       门诊病历中病历按钮(保存、打印等)所占的界面高度设置
/// 			设置为固定值，比如38、78(建议最小值为38)
/// 			此参数针对emr.op.main.csp界面
/// CreateDate: 2018-9-10
/// Debug:      w ##Class(EMRservice.SystemParameter).GetOPheigh()
ClassMethod GetOPheigh() As %String
{
    q "38"
}

/// Desc:  		点击“送病案室”按钮之后，是否允许撤销送病案室，是Y，反之是N。
/// Creator:    董璐璐
/// CreateDate: 2018-11-13
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsEnableRevokeComplete()
ClassMethod IsEnableRevokeComplete() As %String
{
	q "Y"
}

/// Desc:       申请权限已打印病历是否开启提示
/// 			"Y"开启提示 "N"不开启提示
/// CreateDate: 2018-12-30
/// Debug:      w ##Class(EMRservice.SystemParameter).hasPrint()
ClassMethod hasPrint() As %String
{
    q "Y"
}

/// Desc:       住院病历--导航页签--病历的前端展示,当本次就诊是首次就诊(即第一次入院)时,卡片视图、表格视图的引用是否显示可用
///             该系统参数配置仅对住院病历导航页面病历的前端展示效果有效
/// Creator:    Lina
/// CreateDate: 2018-5-8
/// Input:      AEpisodeID  就诊ID,默认返回"Y"
/// Output：    返回"Y"  当本次就诊是首次就诊(即第一次入院)时,卡片视图的引用显示出来,表格视图的引用按钮可用;
///             返回"N"  当本次就诊是首次就诊(即第一次入院)时,卡片视图的引用不显示出来,表格视图的引用按钮禁用;
///             入参就诊ID为空,默认返回"Y"
/// Debug:      w ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(211)
ClassMethod SetNavQuoteDisplay(AEpisodeID As %String) As %String
{
	//ret 值域["Y","N"]
	s ret = "Y"
	q:(AEpisodeID = "") ret
	q:(##class(%Dictionary.CompiledClass).%ExistsId("MA.IPMR.IO.OutService") = "0") ret
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("MA.IPMR.IO.OutService||GetIPTimes") = "0") ret
	//病案组 判断入院次数接口
	s num = ##class(MA.IPMR.IO.OutService).GetIPTimes(AEpisodeID)
	s:(num = 1) ret = "N"
	q ret
}

/// Desc: 集中签名界面 科主任 质控医生、质控护士、责任护士默认本科病人 住院医师、主治医师、主任医师默认本医疗组
/// Creator: duan
/// CreateDate: 2019-05-22
/// Input: 无
/// Output: 
/// Debug: w ##Class(EMRservice.SystemParameter).getDefaultGroup()
ClassMethod getDefaultGroup() As %String
{
    q "chiefCheck^attendingCheck^residentCheck#chairmanCheck^qcdocCheck^qcnurseCheck^chargenurseCheck"
}

/// Desc:  		点击送病案室之后是否调用归档统计扫描项目数目页面，开启Y，关闭N。
/// Creator:    董璐璐
/// CreateDate: 2019-6-11
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsSubmitRemarks()
ClassMethod IsSubmitRemarks() As %String
{
	q "N"
}

/// Desc:  		设置数据库模式
/// Creator:    Candy
/// CreateDate: 2019-4-8
/// Input:      无
/// Output:     ""/http
/// Debug: w ##Class(EMRservice.SystemParameter).GetNetConnectType()
ClassMethod GetNetConnectType()
{
	q "http"
}

/// Desc:  		判定CA版本，1是老版 2是新版
/// Creator:    侯健
/// CreateDate: 2019-7-18
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).CAVersion()
ClassMethod CAVersion() As %String
{
	s id = $O(^DHCCERTAUTH.ConfigCommonI("IdxName"," CAVERSION",""))
	q:(id = "") "1"

	s ver = $lg($g(^DHCCERTAUTH.ConfigCommonD(id)),4)
	q ver
}

/// Desc:  		手术相关功能是否显示添加索引按钮，显示Y，不显示N。
/// Creator:    甘玲玲
/// CreateDate: 2019-8-5
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsShowAppendOperations()
ClassMethod IsShowAppendOperations() As %String
{
	q "N"
}

/// Desc:  IE前端的模板库的目录默认全部展开或关闭
///        如果默认模板库的目录全部展开，则设置为 q "Y"  
/// 	   如果默认模板库的目录全部关闭，则设置为 q "N"
/// Creator:    liuyunfei
/// CreateDate: 2019-08-16
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).SetTemplateDirectoryState()
ClassMethod SetTemplateDirectoryState() As %String
{
	q "N"
}

/// Desc:       病种关联模板 下诊断后  诊断关联病种数量为1  病种关联科室为1  是否默认新建病历
/// Input:      无
/// Output:     Y  新建病历
/// Creator:    段礼峻
/// CreateDate: 2019-08-21
/// Debug:      w ##Class(EMRservice.SystemParameter).IsLoadDocument()
ClassMethod IsLoadDocument()
{
	q "Y"
}

/// Desc:       病种关联模板检索
/// Input:      无
/// Output:     Y  开启病种关联模板检索功能
/// Creator:    段礼峻
/// CreateDate: 2019-08-21
/// Debug:      w ##Class(EMRservice.SystemParameter)openDiseaseTemp()
ClassMethod openDiseaseTemp()
{
	q "Y"
}

/// Desc:  		点击“显示（隐藏）留痕”按钮之后，是否保留用户习惯，是Y，反之是N。
/// Creator:    刘笑天
/// CreateDate: 2019-8-19
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsSaveUserConfig()
ClassMethod IsSaveUserConfig() As %String
{
	q "Y"
}

/// 电子病历数据质量的完整性：评级用，扩展病历操作记录表，存储病历打散的章节文本
/// 关联病历操作日志表EMRinstance.InstanceLog，表EMRinstance.InstanceLogSectionData存储病历打散的章节文本
/// Creator:    Lina
/// CreateDate: 2019-8-29
/// Desc:       是否存储病历打散的章节文本，是Y，反之是N；默认是N
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsSaveEMRLogSectionData()
ClassMethod IsSaveEMRLogSectionData() As %String
{
    q "N" //"Y"
}

/// Desc:  住院病案首页DOCID          
/// Creator:    donglulu
/// CreateDate: 2019-9-4
/// Debug:      w ##Class(EMRservice.SystemParameter).GetMedicalRecordDocID()
ClassMethod GetMedicalRecordDocID() As %String
{
    q "640"
}

/// Desc:  中医病案首页DOCID          
/// Creator:    donglulu
/// CreateDate: 2021-5-12
/// Debug:      w ##Class(EMRservice.SystemParameter).GetChineseMedicalRecordDocID()
ClassMethod GetChineseMedicalRecordDocID() As %String
{
    q "639"
}

/// Desc:  		集中签名医生是否显示病区，不显示科室
/// Creator:    董璐璐
/// CreateDate: 2019-9-11
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsGroupSignShowWard()
ClassMethod IsGroupSignShowWard() As %String
{
    q "N"
}

/// Desc:  		病历浏览患者查询界面是否默认选择当前科室
/// Creator:    董璐璐
/// CreateDate: 2019-9-19
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsBrowseSelectDefaultLoc()
ClassMethod IsBrowseSelectDefaultLoc() As %String
{
    q "Y"
}

/// Desc:       根据当前登陆科室ID，获取HISUI版门诊病历-资源区-历史就诊页签-"引用为复诊病历"按钮所用复诊病历模板的emrDocID
/// Creator:    Lina
/// CreateDate: 2019-9-18
/// Input:      当前登陆科室ID
/// Output:     当前登陆科室可创建的复诊病历模板的emrDocID
/// Debug:      w ##Class(EMRservice.SystemParameter).GetRefEmrLastDocID("")
ClassMethod GetRefEmrLastDocID(ALocID As %String = "") As %String
{
    s emrDocID = "" //通用复诊病历模板的emrDocID
    /*if (ALocID = "6") //根据科室所挂复诊病历模板不同而进行条件判断
    {
        s emrDocID = "104"
    }
    elseif (ALocID = ...){....}*/
    q emrDocID
}

/// desc 病历浏览 患者列表 根据床号进行排序
/// createor duan
/// input 无
/// output Y
/// debug ##class(EMRservice.SystemParameter).openSortByPAADMBedNO()
ClassMethod openSortByPAADMBedNO()
{
	q "Y"
}

/// desc: 病历浏览  默认查询入院起始时间n天内的数据  为空则不指定时间
/// creator: duan
/// createdate:2019-11-01
/// debug: w ##Class(EMRservice.SystemParameter).getDateConfig()
ClassMethod getDateConfig()
{
	q ""
}

/// Desc:  		病历书写页面，点击“打印”按钮之后，是否开启单页自动补空白，true开启，false关闭，默认false。
/// Creator:    刘笑天
/// CreateDate: 2019-12-13
/// Input:      无
/// Output:     true/false
/// Debug:      w ##Class(EMRservice.SystemParameter).IsFirstNeedChangePage()
ClassMethod IsFirstNeedChangePage() As %String
{
	q "false"
}

/// desc: 智能诊断工具相关js引入
/// creator：duan
/// createdate: 2020-01-01
/// jsdk地址填写  w "<script type=""text/javascript"" src=""http://10.77.76.191/cdss/jssdk?v=1.0&t=pro&ak=BA95E8BE36A1CC4342F88C9DC7821C89&p=cdss""></script>"
/// debug: d ##class(EMRservice.SystemParameter).getCDSSUrl()
ClassMethod getCDSSUrl()
{
	s cdssType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("cdssType")
	s cdssLock = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("cdssLock")
	q:((cdssType="")||(cdssLock="")||(($P(cdssLock,"^",1)'="Y")&&($P(cdssLock,"^",1)'="ALL"))) ""

	//智能诊断工具 jsdk下载地址    第三方提供
	w ""
	if (cdssType ="HM"){
		w "<script type=""text/javascript"" src=""../scripts/emr/js/hm.js""></script>"
	}
	if (cdssType ="ALI"){
		w "<script type=""text/javascript"" src=""../scripts/emr/js/aLi.js""></script>"
	}
}

/// desc: 智能诊断工具参数配置  第三方提供
/// debug:d ##class(EMRservice.SystemParameter).getCDSSParam()
/// example:"""autherKey"":""DSHOAWERIJKSWRNJ324""" 
ClassMethod getCDSSParam()
{
	s result = "{"
	s result = result_"""autherKey"":""""" 
	s result = result_",""loadType"":"""""
	s result = result_",""iframeAddress"":"""""
	s result = result_"}"
	q result
}

/// desc: 医院ID和名称配置   示例 "2^东华标准版数字化医院"    
/// debug:d ##class(EMRservice.SystemParameter).getCDSSParam()
ClassMethod getHospitalParam()
{
	q ""
}

///  Desc:     	住院病历，链接单元值数据来源  
///  Input:      
///  Output:     Web  / Web+Cache /Cache
///  Creator:    李丰博
///  CreateDate: 2020-02-04
///  Debug:      w ##Class(EMRservice.SystemParameter).DiagRefDataSource()
ClassMethod DiagRefFormatServer() As %String
{
	
	// Web：与改造前效果一致，通过前端代码进行诊断数据格式化。
	// Web+Cache ：将前端医生站传入object数据，传入后台，并在Cache端进行格数据式化。
	// Cache:通过后台接口，直接获取医生站患者对应链接单元配置的诊断类型的诊断数据。
	
	//s dataSource = "Web"	
	//s dataSource = "Web+Cache"
	s dataSource = "Cache"
	q dataSource
}

/// Desc:  		读取配置中病理的命名空间
/// Creator:    王煜
/// CreateDate: 20200111
/// Input:      无
/// Output:     Y/N
/// Debug:      d ##Class(EMRservice.SystemParameter).getPathologyNameSpace()
ClassMethod getPathologyNameSpace() As %String
{
	
				q "DHC-PIS"
}

/// Desc:  		病历资源中引用中草药时将备注添加在药品名的右上方是N，添加在单位的右上方是Y。
/// Creator:    王煜
/// CreateDate: 2019-08-28
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsEnableRemarks()
ClassMethod IsEnableRemarks() As %String
{
	q "N"
}

/// Desc: 门诊补打界面 医生站读卡设备 维护ID
/// Creator:    duan
/// CreateDate: 2020-06-04
/// Input:      无
/// Output:     "2^13"
/// Debug:      w ##Class(EMRservice.SystemParameter).getCards()
ClassMethod getCards()
{
	q "2^13"
}

/// Desc:  门诊病历(兼容非HISUI及HISUI界面)默认闭合与展开设置
///        如果默认目录全部展开，则设置为 q "1"  如果默认目录展开到第二层，则设置为 q "2"
/// 	   如果默认目录全部折叠，则设置为 q "0"  默认为1
/// Creator:    yan
/// CreateDate: 2020-06-24
/// Input:      无
/// Output:     0/1/2
/// Debug:      w ##Class(EMRservice.SystemParameter).SetOPTemplateCollapse()
ClassMethod SetOPTemplateCollapse() As %String
{
	q "1"
}

/// Desc:  		医生在签名时，校验密码与登录密码校验还是与签名密码校验。
/// Creator:    liuyunfei
/// CreateDate: 2020-07-07
/// Input:      hospitalID:院区Id（可配置不同院区id，不同签名校验）
/// Output:     LOGIN/SIGN
/// Debug:      w ##Class(EMRservice.SystemParameter).getSignCheckObj()
ClassMethod getSignCheckObj(hospitalID As %String = "") As %String
{
	/*if (hospitalID="1101")
	{
		q "SIGN"
	}
	else
	{*/
	q "LOGIN"
}

/// Desc:  签名前面取职称描述设置
///        1、如果始终取HIS职称，则设置为 q "HisCTPCP"  2、如果取签名角色，则设置为 q "Character"
/// 	   3、病历签名级别走EMR，则取维护程序配置的医生级别，签名级别走HIS，则取HIS职称，则设置为 q "CTPCP"  默认为"CTPCP"
/// Creator:    Donglulu
/// CreateDate: 2020-07-27
/// Input:      无
/// Output:     "CTPCP"/"Character"/"HisCTPCP"
/// Debug:      w ##Class(EMRservice.SystemParameter).GetSignCTPCPDescType()
ClassMethod GetSignCTPCPDescType() As %String
{
	q "Character"
}

/// Desc:  		维护程序配置种植牙疗程的CategoryId。
/// Creator:    liuyunfei
/// CreateDate: 2020-08-06
/// Input:      无
/// Output:     
/// Debug:      w ##Class(EMRservice.SystemParameter).getPlantToothTreatmentCategoryId()
ClassMethod getPlantToothTreatmentCategoryId() As %String
{
	q ""
}

/// Desc:  		南山人民有个特殊科室-特诊中心：（可配置多个科室ID，用上箭头分隔，例如："93^95"）
/// 			其他科室医师会在这个科室坐诊，需要显示本医师默认登录科室安全组的病例模版和知识库
/// 			在这里配置特诊中心科室id，在取模版和知识库时判断如果是特诊中心就取该医师默认登录科室和安全组的模版和知识库
/// Creator:    liuyunfei
/// CreateDate: 2020-08-31
/// Input:      无
/// Output:     
/// Debug:      w ##Class(EMRservice.SystemParameter).GetSpecialLocId()
ClassMethod GetSpecialLocId() As %String
{
	q ""
}

/// Desc:  		诊断证明书审核界面是否显示所有就诊记录还是只显示关于诊断证明书的记录(显示全部时查询所有就诊，数据量太大)
/// Creator:    liuyunfei
/// CreateDate: 2020-09-27
/// Input:      无
/// Output:     显示全部/显示部分：Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsGetAllDataInAudit()
ClassMethod IsGetAllDataInAudit() As %String
{
	q "N"
}

/// Desc:       病程病历加载模式属性[按业务逻辑(如阶段小结)分段加载 或者 按病程数量分段加载]
///             按业务逻辑(如阶段小结)分段加载设置TitleCode：另起页病历的标题TitleCode，多个以"^"来分隔，默认为空
///             [设置格式：另起页病历TitleCode^另起页病历TitleCode，例如 "EMR100007^EMR1000050"]
///             按病程数量分段加载设置RecordConfig：LoadCondition超过指定病历数开启加载条件，LoadRecord加载病历数目，通过卡片或列表打开的病历时加载的病程数目为2*LoadRecord+1，默认为空
///             [设置格式：{""LoadCondition"":""40"",""LoadRecord"":""10""} 超过40份病历开启按病程条目分段加载]
///             若开启了病程分段加载模式，则可以设置BrowseConfig来控制病历浏览是否开启病程分段加载模式
///             [设置格式：""BrowseConfig"":""Y"" 表开启，默认为不开启，即 ""BrowseConfig"":""N""
///             若开启了病程分段加载模式，则可以设置ReferenceConfig来控制病历参考是否开启病程分段加载模式
///             [设置格式：""ReferenceConfig"":""Y"" 表开启，默认为不开启，即 ""ReferenceConfig"":""N""
/// CreateDate: 2020-8-13
/// Output:     当前病程病历加载模式
/// Debug:      w ##Class(EMRservice.SystemParameter).GetLoadDocMode()
ClassMethod GetLoadDocMode() As %String
{
    // 按业务逻辑(如阶段小结)分段加载设置
    //q "{""TitleCode"":""EMR100007^EMR1000050"",""RecordConfig"":"""",""BrowseConfig"":""Y"",""ReferenceConfig"":""Y""}"
    
    // 按病程数量分段加载设置
    q "{""TitleCode"":"""",""RecordConfig"":{""LoadCondition"":""20"",""LoadRecord"":""3""},""BrowseConfig"":""Y"",""ReferenceConfig"":""Y""}"
    
    // 默认病程全部加载设置
    // q "{""TitleCode"":"""",""RecordConfig"":"""",""BrowseConfig"":""N"",""ReferenceConfig"":""N""}"
}

/// Desc: 患者签名是否是签PDF
/// Creator:    Donglulu
/// CreateDate: 2020-11-13
/// Input:      无
/// Output:     Y:是 N：否
/// Debug:      w ##Class(EMRservice.SystemParameter).IsPatientSignPDF()
ClassMethod IsPatientSignPDF()
{
	q "N"
}

/// Desc: 		门诊资源区在左边显示还是在右边显示
/// Creator:    liuyunfei
/// CreateDate: 2021-01-07
/// Input:      无
/// Output:     R:右边 L：左边	（默认左边）
/// Debug:      w ##Class(EMRservice.SystemParameter).SetOPResourceLocation()
ClassMethod SetOPResourceLocation()
{
	q "R"
}

/// Desc: HISUI版-门诊资源区历史就诊目录页面是否开启显示门诊病历实例标题按钮，Y：开启；N：不开启；默认为N，开启后，可直接通过选择门诊病历实例标题的按钮进入病历内容的查看
///       业务需求功能来源于上海美中嘉和肿瘤门诊验收项目
/// CreateDate: 2021-03-24
/// Input:      无
/// Output:     Y：开启；N：不开启；默认为N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsShowOPHistoryTitlebtn()
ClassMethod IsShowOPHistoryTitlebtn()
{
    q "Y"
}

/// Desc:       HISUI版门诊病历-根据当前登陆科室ID，判断是否为"生殖内分泌、男科、生殖医学科"这三个门诊科室
///             是：返回不孕不育病历模板的emrDocID，否：返回空
///             华西二院门诊病历个性化需求
/// CreateDate: 2021-3-30
/// Input:      当前登陆科室ID
/// Output:     返回病历模板的emrDocID
/// Debug:      w ##Class(EMRservice.SystemParameter).getTmplDocIDByUserLocID("6")
ClassMethod getTmplDocIDByUserLocID(ALocID As %String) As %String
{
    s emrDocID = ""
    q:(ALocID = "") emrDocID
    s userLocIDs = "" // "生殖内分泌、男科、生殖医学科"这三个门诊科室LocID,如"1,2,3"
    s length = $l(userLocIDs,",")
    for i=1:1:length
    {
        s locID = $p(userLocIDs,",",i)
        continue:(locID = "")
        s:(locID = ALocID) emrDocID = "" // 不孕不育病历模板的emrDocID
        q:(emrDocID '= "")
    }
   
    q emrDocID
}

/// Desc:       门诊病历补打页面(emr.op.printAllSearch.csp)，是否显示打印模态窗的关闭按钮,true:显示;false:不显示;默认为显示是否显示模态窗的关闭按钮,true:显示;false:不显示;默认为true显示 -- 山东烟台精神卫生中心 项目个性化设置要求
/// CreateDate: 2021-4-21
/// Input:      无
/// Output:     true/false
/// Debug:      w ##Class(EMRservice.SystemParameter).isShowCloseBtn()
ClassMethod isShowCloseBtn() As %String
{
    q "true"
    //q "false"
}

/// Desc:  		IE前端的科室模板维护界面目录树默认全部展开或关闭
///        		全部展开，则设置为 q "Y" ；全部关闭，则设置为 q "N"
/// Creator:    liuyunfei
/// CreateDate: 2021-08-02
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).SetUserTemplateTreeState()
ClassMethod SetUserTemplateTreeState() As %String
{
	q "N"
}

/// Desc:       门诊病历模板是实时查询还是回车查询
/// CreateDate: 2021-08-09
/// Input:      无
/// Output:     EnterQuery:回车查询 RealQuery:实时查询   （默认回车查询）
/// Debug:      w ##Class(EMRservice.SystemParameter).SetOPTempQMode()
ClassMethod SetOPTempQMode()
{
    q "EnterQuery"
    //q "RealQuery"
}

/// Desc:  		科室模板和个人模板是否按照用户使用频率排序，是Y，否N。
/// Creator:    董璐璐
/// CreateDate: 2019-5-29
/// Input:      无
/// Output:     Y/N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsSortByUserFrequency()
ClassMethod IsSortByUserFrequency()
{
    q "N"
}

/// Desc:       HISUI版住院病历的模板选择界面是否默认勾选全院模板
/// Creator:    Lina
/// CreateDate: 2021-9-23
/// Input:      无
/// Output:     Y/N（默认N）
/// Debug:      w ##Class(EMRservice.SystemParameter).IsCheckAllTemp()
ClassMethod IsCheckAllTemp() As %String
{
    q "N"
}

/// Desc:       HISUI版-住院病历-模板标题弹窗有选择医生下拉框，医生框内为空则不能点确定按钮来修改病历标题
///             业务需求功能来源于沈阳胸科项目
/// CreateDate: 2021-11-16
/// Input:      无
/// Output:     Y：开启；N：不开启；默认为N
/// Debug:      w ##Class(EMRservice.SystemParameter).IsCanModifyTitle()
ClassMethod IsCanModifyTitle()
{
    q "Y"
}

/// Desc:       个人短语的文本内容在目录的右边显示
/// CreateDate: 2021-11-26
/// Input:      无
/// Output:     east:右边 south:下边   （默认下边）
/// Debug:      w ##Class(EMRservice.SystemParameter).SetContentLocation()
ClassMethod SetContentLocation()
{
    //q "east"
    q "south"
}

/// Desc:		是否开启患者签名
/// CreateDate: 2021-09-06
/// Input:      无
/// Output:     1 开启     0 关闭
/// Debug:      w ##Class(EMRservice.SystemParameter).CAHandSign()
ClassMethod CAHandSign(hospitalID = "") As %String
{
	s version = ..CAVersion()
	if ("2"=version) {
		s HandSign=##Class(CA.DigitalSignatureService).IsHandSignCAON(hospitalID)
		q ("1" = HandSign)
	}else{
		s HandSign=$g(^CF("CA","HandSign"))
		q ("Y" = HandSign)
	}
}

/// Desc:		患者签名厂商代码
/// CreateDate: 2021-09-06
/// Input:      无
/// Output:     厂商代码^是否支持PDF^是否需要显示待签二维码
/// 				例如: FAKE^1^0
/// 					  SZXX^1^1
/// Debug:      w ##Class(EMRservice.SystemParameter).CAHandSignVender()
ClassMethod CAHandSignVender(hospitalID = "") As %String
{
	q:(..CAHandSign(hospitalID) = "0") ""
    
    s version = ..CAVersion()
	if ("2"=version) {
        s CAHandSignCompany = ##Class(CA.ConfigCommon).GetValueByName("DefaultHandSignVenderCode",hospitalID) //厂商代码
        s:(CAHandSignCompany = "") CAHandSignCompany = ##Class(CA.ConfigCommon).GetValueByName("DefaultPATPDFVenderCode",hospitalID) //厂商代码
        s IsSupportPDFSign = ##Class(CA.ConfigCommon).GetValueByName("IsSupportPDFSign",hospitalID)           //是否支持PDF
        s IsNeedQrCode = ##Class(CA.ConfigCommon).GetValueByName("IsNeedQrCode",hospitalID)                   //是否需要显示二维码
	}else{
        s CAHandSignCompany = $G(^CF("CA","CAHandSignCompany"))  //厂商代码
        s IsSupportPDFSign = $G(^CF("CA","IsSupportPDFSign"))    //是否支持PDF
        s IsNeedQrCode = $G(^CF("CA","IsNeedQrCode"))            //是否需要显示二维码
	}
    q CAHandSignCompany_"^"_IsSupportPDFSign_"^"_IsNeedQrCode
}

/// Desc:  IE前端的管理个人模板默认闭合与展开设置
///        如果默认目录全部展开，则设置为 q "1"  如果默认知识库目录展开到第二层，则设置为 q "2"
/// 	   如果默认全部收拢，则设置为 q "0"
/// Creator:    yejian
/// CreateDate: 2022-1-17
/// Input:      无
/// Output:     0/1/2
/// Debug:      w ##Class(EMRservice.SystemParameter).SetManagePersonalCollapse()
ClassMethod SetManagePersonalCollapse() As %String
{
	q "1"
}

/// Desc:		加载PDF数据时的消息格式
/// 			其值域为：Xml、Base64， 默认值为：Base64，
/// 			Base64表示直接按照A4纸型加载PDFBase64数据、未处理其他纸型数据， Xml表示按照纸型加载PDFBase64数据
/// 			编辑器按照纸张类型加载PDF，插件版本要求为：8.5.1、 1.7.8.11、 1.7.6.22、 1.7.3.10及以上。 
/// CreateDate: 2022-03-02
/// Creator:    houjian
/// Input:      无
/// Output:     Base64 返回PDF的Base64数据
/// 			Xml 返回Abiword的xml数据(页面设置信息+PDF的Base64数据)
/// Debug:      w ##Class(EMRservice.SystemParameter).PDFLoadFormat()</Description>
ClassMethod PDFLoadFormat() As %String
{
	//q "Base64"
	q "Xml"
}

/// Desc:  IE前端的模板选择中的个人模板
///        如果默认个人模板目录全部展开，则设置为 q "1"  如果默认个人模板目录展开到第二层，则设置为 q "2"
///  	   如果默认个人模板目录展开到文件夹的最后一层，折叠个人模板节点，则设置为 q "3"
/// Creator:    wangyu
/// CreateDate: 2022-04-27
/// Input:      无
/// Output:     1/2/3
/// Debug:      w ##Class(EMRservice.SystemParameter).SetPersonalTemplateCollapse()
ClassMethod SetPersonalTemplateCollapse() As %String
{
	q "1"
}

/// Desc:  		删除实习生创建的未签名病历是否不需要输入创建者密码（若实习生删除都需要输入密码）。
/// Creator:    wangyu
/// CreateDate: 2022-04-27
/// Input:      无
/// Output:     Y 不需要输入密码  N需要
/// Debug:      w ##Class(EMRservice.SystemParameter).IsPassWordByIntern()
ClassMethod IsPassWordByIntern() As %String
{
	q "Y"
}

/// Desc:  		设置科室待签列表待签操作中类型配置
/// Creator:    董璐璐
/// CreateDate: 2022-5-11
/// Input:      
/// Output:     医师级别(用 ^ 分隔)|护士级别(用 ^ 分隔)，例Chief^Attending^Resident|Nurse^ChargeNurse
/// 				级别取EMRmeta.SignRole表的Name字段，在待签列表中的顺序也是根据配置从左往右显示
/// Debug:      w ##Class(EMRservice.SystemParameter).GetSignRange()
ClassMethod GetSignRange() As %String
{
	s result = "Resident^Attending^Chief^Chairman^Patient^Anesthesiologist|Nurse^AnesthesiaNurse"
	q result
}

/// Desc:		是否启用独立存储留痕信息，默认启用
/// CreateDate: 2022-04-27
/// Creator:    lifengbo
/// Input:      无
/// Output:     True,开启存储功能； False,关闭独立存储留痕信息。
/// Debug:      w ##Class(EMRservice.SystemParameter).IsSaveRevisionDocument()
ClassMethod IsSaveRevisionDocument() As %String
{
	q "True"
}

/// Desc:		是否启用按照使用频次依据用户加载
/// CreateDate: 2022-07-11
/// Creator:    lifengbo
/// Input:      AUserID用户ID
/// Output:     Y,启用； N,不启用。 默认不启用
/// Debug:      w ##Class(EMRservice.SystemParameter).IsLoadTemplateByFrequency()
ClassMethod IsLoadTemplateByFrequency(AUserID As %String) As %String
{
	q "N"
}

/// Desc:		是否启用病历压缩
/// CreateDate: 2022-09-01
/// Creator:    lifengbo
/// Input:      
/// Output:     true,启用； false,不启用。 默认启用
/// Debug:      w ##Class(EMRservice.SystemParameter).GetSetOpenCompress()
ClassMethod GetSetOpenCompress() As %String
{
	q "true"
}

}

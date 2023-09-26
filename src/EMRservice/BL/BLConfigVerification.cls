Class EMRservice.BL.BLConfigVerification Extends %RegisteredObject
{

/// w ##class(EMRservice.BL.BLConfigVerification).GetConfigVerification()
ClassMethod GetConfigVerification()
{
	s json={}
	s jsondata=[]
	s jsonmessage = []
	
	//验证项目维护方案：数据不定义独立存储，在业务类中进行维护。
	////////////////////////////////////////////////////////////////////////////
	///系统参数
	////////////////////////////////////////////////////////////////////////////
	//SetDefaultFontStyle
	Try{
		s subJson={}
		s subJson.id=1
		s subJson.configitem = "系统05|设置病历默认字体"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SetDefaultFontStyle","")
		s subJson.recommendedconfig = "'fontFamily':'宋体','fontSize':'12pt','lineSpace':'1.5','fontSpace':'0'"
		s subJson.reason = "按需配置,影响体验"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SetDefaultFontStyle"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	//PatientNoLength
	Try{
		s subJson={}
		s subJson.id=2
		s subJson.configitem = "系统13|患者登记号长度(自动用0补齐登记号长度)"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("PatientNoLength","")
		s subJson.recommendedconfig = "10"
		s subJson.reason = "按需配置,影响体验"
		s subJson.sourcetype = "【维护程序】→【系统参数】:PatientNoLength"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//KBNodeEdit
	Try{
		s subJson={}
		s subJson.id=3
		s subJson.configitem = "界面07|资源区知识库是否可以编辑知识库节点"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("KBNodeEdit","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:KBNodeEdit"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//PersonalKBNodeEdit
	Try{
		s subJson={}
		s subJson.id=4
		s subJson.configitem = "界面08|资源区个人知识库是否可以编辑知识库节点"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("PersonalKBNodeEdit","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:PersonalKBNodeEdit"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//ENABLE_ADVANCE_DAILYRECORD
	Try{
		s subJson={}
		s subJson.id=5
		s subJson.configitem = "界面09|是否提前书写病程记录[启用->Y][禁用->N]默认为N"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ENABLE_ADVANCE_DAILYRECORD","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:ENABLE_ADVANCE_DAILYRECORD"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//ENABLE_PASTE_LIMIT
	Try{
		s subJson={}
		s subJson.id=6
		s subJson.configitem = "界面10|限制跨患者复制粘贴[启用->Y][禁用->N]默认为Y"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ENABLE_PASTE_LIMIT","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:ENABLE_PASTE_LIMIT"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//Lis_AbnorFlag_Check
	Try{
		s subJson={}
		s subJson.id=7
		s subJson.configitem = "界面19|资源区的检验数据引用取消异常值默认勾选[启用->Y][禁用->N]默认为N"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("Lis_AbnorFlag_Check","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:Lis_AbnorFlag_Check"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//DISABLE_PASTE_NON_EDITOR
	Try{
		s subJson={}
		s subJson.id=8
		s subJson.configitem = "界面24|禁止粘贴编辑器外的数据[启用->Y][禁用->N]默认为N"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_PASTE_NON_EDITOR","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:DISABLE_PASTE_NON_EDITOR"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//isShowPatInfo
	Try{
		s subJson={}
		s subJson.id=9
		s subJson.configitem = "界面27|门诊是否显示患者信息栏，默认是N"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isShowPatInfo","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:DISABLE_PASTE_NON_EDITOR"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//REMOVE_COMPOSITE_STYLES
	Try{
		s subJson={}
		s subJson.id=10
		s subJson.configitem = "界面34|前台插入知识库需要清除知识库中的样式属性"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("REMOVE_COMPOSITE_STYLES","")
		s subJson.recommendedconfig = "font-family;font-size;color"
		s subJson.reason = "影响体验、推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:REMOVE_COMPOSITE_STYLES"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	//SetRecordReferenceLayout
	Try{
		s subJson={}
		s subJson.id=11
		s subJson.configitem = "界面40|设置病历参考布局左右对照或者上下对照。[病历参考左右对照->east ,上下对照->south]。"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SetRecordReferenceLayout","")
		s subJson.recommendedconfig = "south"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SetRecordReferenceLayout"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//LevelSource
	Try{
		s subJson={}
		s subJson.id=12
		s subJson.configitem = "系统24｜取病历级别来源[默认值""EMR"" 取电子病历级别,""HIS"" 取his维护级别]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("LevelSource","")
		s subJson.recommendedconfig = "HIS"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:LevelSource"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SignLogic
	Try{
		s subJson={}
		s subJson.id=13
		s subJson.configitem = "系统25｜设置签名逻辑[默认值""EMR"" 使用电子病历三级医师签名逻辑,""Custom""项目定义逻辑，如项目设置患者固定 三级医师]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignLogic","")
		s subJson.recommendedconfig = "EMR"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SignLogic"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsRevokeSign
	Try{
		s subJson={}
		s subJson.id=14
		s subJson.configitem = "系统26｜设置是否开启签名失效功能[Y：开启，N:关闭]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:IsRevokeSign"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SetOPDefaultFontStyle
	Try{
		s subJson={}
		s subJson.id=15
		s subJson.configitem = "系统27|设置门诊病历默认字体  'fontFamily':'宋体','fontSize':'12pt','lineSpace':'1.5','fontSpace':'0'"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SetOPDefaultFontStyle","")
		s subJson.recommendedconfig = "'fontFamily':'宋体','fontSize':'12pt','lineSpace':'1.5','fontSpace':'0'"
		s subJson.reason = "按需配置、影响体验"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SetOPDefaultFontStyle"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//AllowDeleteEMRDoc
	Try{
		s subJson={}
		s subJson.id=16
		s subJson.configitem = "维护01|允许删除病历展现结构[启用->Y][禁用->N]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AllowDeleteEMRDoc","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "数据安全、运行阶段必须禁用"
		s subJson.sourcetype = "【维护程序】→【系统参数】:AllowDeleteEMRDoc"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//CrisisRolling
	Try{
		s subJson={}
		s subJson.id=17
		s subJson.configitem = "系统40|事件是否滚动提示[滚动->Y][静止->N]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("CrisisRolling","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "影响体验、推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:CrisisRolling"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//DISABLE_DROP_NON_EDITOR
	Try{
		s subJson={}
		s subJson.id=18
		s subJson.configitem = "界面50|是否禁止拖拽外部数据到编辑器[启用->Y][禁用->N]默认为N"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_DROP_NON_EDITOR","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "影响业务"
		s subJson.sourcetype = "【维护程序】→【系统参数】:DISABLE_DROP_NON_EDITOR"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SHOW_TABLE_DOTTED_LINE
	Try{
		s subJson={}
		s subJson.id=19
		s subJson.configitem = "系统38|表格书写是否显示虚线边框 默认为Y[启用->Y][禁用->N]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SHOW_TABLE_DOTTED_LINE","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SHOW_TABLE_DOTTED_LINE"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	//isDirectSignOP
	Try{
		s subJson={}
		s subJson.id=20
		s subJson.configitem = "系统66|门诊签名方式是否为直接签名，默认是Y，设为N弹出签名框后进行签名"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isDirectSignOP","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:isDirectSignOP"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	//DateTimeToHISFormat
	Try{
		s subJson={}
		s subJson.id=21
		s subJson.configitem = "界面58|是否启用病历系统展现时间转换为HIS设置标准格式（Y，启用【默认值】；N，不启用【显示格式：日期，yyyy-mm-dd 时间，hh:mm】）"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DateTimeToHISFormat","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:DateTimeToHISFormat"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	//AllowModifyCreateRange
	Try{
		s subJson={}
		s subJson.id=22
		s subJson.configitem = "界面66|允许修改的创建时间范围（允许当前时间往前修改几小时^允许当前时间往后修改几小时）"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AllowModifyCreateRange","")
		s subJson.recommendedconfig = "120000000^120000000"
		s subJson.reason = "按需配置、推荐配置(推荐值为33小时）"
		s subJson.sourcetype = "【维护程序】→【系统参数】:AllowModifyCreateRange"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	//SelfPrintSearchDays
	Try{
		s subJson={}
		s subJson.id=23
		s subJson.configitem = "系统65|设置自助机打印门诊病历时，可查询几天内的病历，默认为1，即只允许查询当天就诊的病历。注意此参数需1.7.8版本以后的程序支持，已经上线自助机打印的项目如果想使用此参数需协同自助机修改程序，详细接口说明请参看【东华电子病历_实施手册_门诊病历自助机打印接口调用说明】文档"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SelfPrintSearchDays","")
		s subJson.recommendedconfig = "1"
		s subJson.reason = "按需配置、影响业务"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SelfPrintSearchDays"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	//resTabPosition
	Try{
		s subJson={}
		s subJson.id=24
		s subJson.configitem = "界面59|设置门诊病历资源区页签显示在上方还是右侧[页签显示在上->top,显示在右侧->right]。默认为top，此参数只适用于emr.op.main.csp页面"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("resTabPosition","")
		s subJson.recommendedconfig = "top"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:resTabPosition"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsOpenEvent
	Try{
		s subJson={}
		s subJson.id=25
		s subJson.configitem = "界面72|是否开启手术或危机值等的事件提醒"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsOpenEvent","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "功能相关"
		s subJson.sourcetype = "【维护程序】→【系统参数】:IsOpenEvent"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SetRecordReferencePresentation
	Try{
		s subJson={}
		s subJson.id=26
		s subJson.configitem = "界面60|设置病历参考布局是内嵌样式还是弹窗样式[内嵌样式->Y,弹窗样式->N]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SetRecordReferencePresentation","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SetRecordReferencePresentation"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//ShowShareHospital
	Try{
		s subJson={}
		s subJson.id=27
		s subJson.configitem = "界面61|共库环境，是否显示全院区数据 Y：显示全院区数据 N：只显示本院区"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "影响业务"
		s subJson.sourcetype = "【维护程序】→【系统参数】:ShowShareHospital"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//DISABLE_DELETE_MACRO
	Try{
		s subJson={}
		s subJson.id=28
		s subJson.configitem = "系统75|是否禁止删除月经史公式（Y禁止，N不禁止）"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_DELETE_MACRO","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:DISABLE_DELETE_MACRO"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SectionLoadKBNode
	Try{
		s subJson={}
		s subJson.id=29
		s subJson.configitem = "界面84|新建病历时，章节根据关联的KBNODEID加载最新的知识库数据[启用->Y][禁用->N]"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SectionLoadKBNode","")
		s subJson.recommendedconfig = "N"
		s subJson.reason = "影响使用"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SectionLoadKBNode"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SignImage_Zoom
	Try{
		s subJson={}
		s subJson.id=30
		s subJson.configitem = "界面85|签名图片缩放比例(ip控制住院，op控制门诊)"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignImage_Zoom","")
		s subJson.recommendedconfig = "{""ip"":""1.2"",""op"":""1.2""}"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:SignImage_Zoom"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//ConfirmAlertType
	Try{
		s subJson={}
		s subJson.id=31
		s subJson.configitem = "界面86|送病案室时弹窗类型（配置为1，则弹原先的质控提示框，内容为触犯的质控条目。配置为2，则弹新改的质控提示表格界面，包括触犯的质控条目，还有维护了待签但未签完的数据。配置为3，则弹新改的质控提示表格界面，包括触犯的质控条目，还有维护了待签但未签完的数据，还有没维护待签属性、没维护不显示待签、并且没有签名的病历。默认为1）"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ConfirmAlertType","")
		s subJson.recommendedconfig = "1"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:ConfirmAlertType"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//AutoConfirmInfo
	Try{
		s subJson={}
		s subJson.id=32
		s subJson.configitem = "系统88|患者出院自动提交病案室设置：Type:计算出院时间按照哪个时间算（NurseSettlement：护士结算，DischargeOrder：出院医嘱）。Time:患者出院多长时间自动提交病案室（以小时为单位），默认为72小时"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AutoConfirmInfo","")
		s subJson.recommendedconfig = "{""Type"":""NurseSettlement"",""Time"":""72""}"
		s subJson.reason = "影响业务"
		s subJson.sourcetype = "【维护程序】→【系统参数】:AutoConfirmInfo"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//opdocResTabPosition
	Try{
		s subJson={}
		s subJson.id=33
		s subJson.configitem = "界面93|设置HISUI版门诊病历资源区页签显示在上方还是左侧[页签显示在上->top,显示在左侧->left]。默认为top，此参数只适用于emr.opdoc.main.csp页面"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("opdocResTabPosition","")
		s subJson.recommendedconfig = "top"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:opdocResTabPosition"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//isDeleteVerificationOP
	Try{
		s subJson={}
		s subJson.id=34
		s subJson.configitem = "界面95|门诊删除病历时，是否需要用户输入创建者的密码[启用->Y][禁用->N]默认为N"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isDeleteVerificationOP","")
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:isDeleteVerificationOP"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//ResourceTabLocation
	Try{
		s subJson={}
		s subJson.id=35
		s subJson.configitem = "界面96|设置住院病历资源区页面的的位置(top:顶部，left：左边，right:右边)"
		s subJson.prjconfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ResourceTabLocation","")
		s subJson.recommendedconfig = "top"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "【维护程序】→【系统参数】:ResourceTabLocation"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////
	//配置类
	///////////////////////////////////////////////////////////////////////////////////////////
	
	//SetEMRShowTreeNodeDelete
	Try{
		s subJson={}
		s subJson.id=36
		s subJson.configitem = "病历展现结构树节点删除控制"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).SetEMRShowTreeNodeDelete()
		s subJson.recommendedconfig = "0"
		s subJson.reason = "数据安全"
		s subJson.sourcetype = "EMRservice.SystemParameter|SetEMRShowTreeNodeDelete"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetRequiredFlag
	Try{
		s subJson={}
		s subJson.id=37
		s subJson.configitem = "住院病历必填项检查标志"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetRequiredFlag()
		s subJson.recommendedconfig = "{'Grid':'1','Word':'1'}"
		s subJson.reason = "影响业务、推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetRequiredFlag"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetOPRequiredFlag
	Try{
		s subJson={}
		s subJson.id=38
		s subJson.configitem = "门诊病历必填项检查标志"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetOPRequiredFlag()
		s subJson.recommendedconfig = "{'Grid':'1','Word':'1'}"
		s subJson.reason = "影响业务、推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetOPRequiredFlag"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetRevokeStatus
	Try{
		s subJson={}
		s subJson.id=39
		s subJson.configitem = "病历失效类型"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetRevokeStatus()
		s subJson.recommendedconfig = "Superior"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetRevokeStatus"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetOPHistoryMethod
	Try{
		s subJson={}
		s subJson.id=40
		s subJson.configitem = "门诊 就诊历史页面取数方法"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetOPHistoryMethod()
		s subJson.recommendedconfig = "GetOPHistoryAll"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetOPHistoryMethod"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetFirstRecordConfig
	//1.病程记录优先完成首次病程记录
	Try{
		s subJson={}
		s subJson.id=41
		s subJson.configitem = "病程记录优先完成首次病程记录"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetFirstRecordConfig()
		s subJson.recommendedconfig = "DocID:66,TitleCode:EMR100001#DocID:641,TitleCode:EMR100001WT"
		s subJson.reason = "影响业务"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetFirstRecordConfig"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsShowToBeSignedSymbol
	Try{
		s subJson={}
		s subJson.id=42
		s subJson.configitem = "病历导航页面卡片是否显示“待签”标志"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsShowToBeSignedSymbol()
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsShowToBeSignedSymbol"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsShowCompleteSymbol
	Try{
		s subJson={}
		s subJson.id=43
		s subJson.configitem = "点击工具栏“送病案室”按钮确认病历全部完成后，是否在导航页显示提示"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsShowCompleteSymbol()
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsShowCompleteSymbol"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetEMRHeartBeatTime
	Try{
		s subJson={}
		s subJson.id=44
		s subJson.configitem = "设置电子病历编辑器每隔多久检查是否为活跃状态(以豪秒为单位)，如果为活跃状态(正在书写)，调用平台组接口防止锁屏，不需要的项目q """
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetEMRHeartBeatTime()
		s subJson.recommendedconfig = "600000"
		s subJson.reason = "影响业务、按情况配置（必须小于平台锁屏时间）"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetEMRHeartBeatTime"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SetSendMessageToTitleDoctor
	Try{
		s subJson={}
		s subJson.id=45
		s subJson.configitem = "是否启用签名后发消息给病程记录中所选的医师"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).SetSendMessageToTitleDoctor()
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|SetSendMessageToTitleDoctor"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsEnableMultiEditSaveCheck
	Try{
		s subJson={}
		s subJson.id=46
		s subJson.configitem = "病历书写是否需要提供在保存操作时的多人编辑同一份病历的校验功能"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsEnableMultiEditSaveCheck()
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsEnableMultiEditSaveCheck"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsEnableEditMultiRecord
	Try{
		s subJson={}
		s subJson.id=47
		s subJson.configitem = "是否允许病程中同时编辑多个病历文档，允许是true，反之是false。"
		s subJson.prjconfig = $zcvt(##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord(),"U")
		s subJson.recommendedconfig = "TRUE"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsEnableEditMultiRecord"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsEnableSelectUserLevel
	Try{
		s subJson={}
		s subJson.id=48
		s subJson.configitem = "是否允许弹出签名框时，高级别医师可以选择医师级别，是Y，否N。"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsEnableSelectUserLevel()
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsEnableSelectUserLevel"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsEnableRevokeComplete
	Try{
		s subJson={}
		s subJson.id=49
		s subJson.configitem = "点击“送病案室”按钮之后，是否允许撤销送病案室，是Y，反之是N。"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsEnableRevokeComplete()
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsEnableRevokeComplete"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//getDefaultGroup
	Try{
		s subJson={}
		s subJson.id=50
		s subJson.configitem = "集中签名界面 科主任 质控医生、质控护士、责任护士默认本科病人 住院医师、主治医师、主任医师默认本医疗组"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).getDefaultGroup()
		s subJson.recommendedconfig = "chiefCheck^attendingCheck^residentCheck#chairmanCheck^qcdocCheck^qcnurseCheck^chargenurseCheck"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|getDefaultGroup"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetNetConnectType
	Try{
		s subJson={}
		s subJson.id=51
		s subJson.configitem = "设置数据库模式"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetNetConnectType()
		s subJson.recommendedconfig = "http"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetNetConnectType"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsShowAppendOperations
	//2.手术与手术模板关联展示页面,是否显示添加索引按钮
	Try{
		s subJson={}
		s subJson.id=52
		s subJson.configitem = "手术与手术模板关联展示页面,是否显示添加索引按钮"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsShowAppendOperations()
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsShowAppendOperations"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsSaveEMRLogSectionData
	Try{
		s subJson={}
		s subJson.id=53
		s subJson.configitem = "电子病历数据质量的完整性：评级用，扩展病历操作记录表，存储病历打散的章节文本"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsSaveEMRLogSectionData()
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsSaveEMRLogSectionData"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//openSortByPAADMBedNO
	Try{
		s subJson={}
		s subJson.id=54
		s subJson.configitem = "病历浏览 患者列表 根据床号进行排序"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).openSortByPAADMBedNO()
		s subJson.recommendedconfig = "Y"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|openSortByPAADMBedNO"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsEnableRemarks
	Try{
		s subJson={}
		s subJson.id=55
		s subJson.configitem = "病历资源中引用中草药时将备注添加在药品名的右上方是N，添加在单位的右上方是Y。"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsEnableRemarks()
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsEnableRemarks"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//getSignCheckObj
	Try{
		s subJson={}
		s subJson.id=56
		s subJson.configitem = "医生在签名时，校验密码与登录密码校验还是与签名密码校验。"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).getSignCheckObj()
		s subJson.recommendedconfig = "LOGIN"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|getSignCheckObj"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetSignCTPCPDescType
	Try{
		s subJson={}
		s subJson.id=57
		s subJson.configitem = "签名前面取职称描述设置1、如果始终取HIS职称，则设置为 q ""HisCTPCP""  2、如果取签名角色，则设置为 q ""Character""3、病历签名级别走EMR，则取维护程序配置的医生级别，签名级别走HIS，则取HIS职称，则设置为 q ""CTPCP""  默认为""CTPCP"""
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetSignCTPCPDescType()
		s subJson.recommendedconfig = "Character"
		s subJson.reason = "影响业务、推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetSignCTPCPDescType"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsGetAllDataInAudit
	Try{
		s subJson={}
		s subJson.id=58
		s subJson.configitem = "诊断证明书审核界面是否显示所有就诊记录还是只显示关于诊断证明书的记录(显示全部时查询所有就诊，数据量太大)"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsGetAllDataInAudit()
		s subJson.recommendedconfig = "N"
		s subJson.reason = "影响业务、推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsGetAllDataInAudit"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//GetLoadDocMode
	Try{
		s subJson={}
		s subJson.id=59
		s subJson.configitem = "病程病历加载模式属性[按业务逻辑(如阶段小结)分段加载 或者 按病程数量分段加载]"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).GetLoadDocMode()
		s subJson.recommendedconfig = "{""TitleCode"":"""",""RecordConfig"":"""",""BrowseConfig"":""N"",""ReferenceConfig"":""N""}"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|GetLoadDocMode"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//SetOPResourceLocation
	Try{
		s subJson={}
		s subJson.id=60
		s subJson.configitem = "门诊资源区在左边显示还是在右边显示"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).SetOPResourceLocation()
		s subJson.recommendedconfig = "R"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|SetOPResourceLocation"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	//IsSortByUserFrequency
	Try{
		s subJson={}
		s subJson.id=61
		s subJson.configitem = "科室模板和个人模板是否按照用户使用频率排序"
		s subJson.prjconfig = ##Class(EMRservice.SystemParameter).IsSortByUserFrequency()
		s subJson.recommendedconfig = "N"
		s subJson.reason = "推荐配置"
		s subJson.sourcetype = "EMRservice.SystemParameter|IsSortByUserFrequency"
		d jsondata.%Push(subJson)
		s count=+$g(count)+1
	}
	Catch
	{
		s subJsonMsg={}
		s subJsonMsg.error = $ze
		d jsonmessage.%Push(subJsonMsg)
	}
	
	s json.total = count
	s json.data = jsondata
	s json.message = jsonmessage
	q json.%ToJSON()
}

}

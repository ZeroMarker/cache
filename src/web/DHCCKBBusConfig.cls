Import sqluser

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		安全用药业务配置类
Class web.DHCCKBBusConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		获取目录的提示方式(该目录是按照最长路径提示，还是多条规则提示) -- 后期需要增加配置
/// Input:			
/// w ##Class(web.DHCCKBBusConfig).GetLibaryDisplayMode()
ClassMethod GetLibaryDisplayMode(label As %String) As %String
{
	n (label)
	
	s mode = "mul"
	if label="用法用量" s mode = "single"

	q mode
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-03
/// Descript: 		获取目录的提示方式(按照规则提示，按照项目提示) -- 后期需要增加配置
/// Input:			
/// w ##Class(web.DHCCKBBusConfig).GetLibaryOutMsgFlag()
ClassMethod GetLibaryOutMsgFlag(label As %String) As %String
{
	n (label)
	s itemList = $lb("用法用量","禁忌","禁忌症","重复用药","用法")	// 按照项目提醒
	s ruleList = $lb("相互作用","配伍禁忌","药物过敏")	// 按照规则提醒
	
	s flag = "rule"	// 默认为规则提醒
	i $listfind(itemList,label)'=0 s flag = "itm"

	q flag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-09-02
/// Descript: 		获取插件配置(预留接口)
/// Input:			
/// Ouput:	{showtime:"显示时间(毫秒)",notallowLevel:"不允许生成医嘱的级别",auditLevel:"强制审核级别",notelists:["医生批注选项"]}
/// w ##Class(web.DHCCKBBusConfig).GetPluginConfig()
ClassMethod GetPluginConfig() As %String
{
	s conObj = {}
	
	s showtime = 5000  //显示时间(毫秒)
	s notallowLevel = "forbid"	//不允许生成医嘱的级别
	s auditLevel = "warn"		//强制审核级别
	s showWinModel = "3"	// 消息提插件显示格式 0:显示简略图标 1:显示明细 其他不显示,若是不显示,则不控制医嘱的生成
	s pluPosition = "top-center" //消息提插件位置,支持两个不同方位词，或一个方位词。当是一个方位词，默认是设置x轴。 默认是上中
								 // 上左(top-left)/左上(left-top) 		上中(top-center)/中上(center-top) 		上右(top-ringht)/右上(ringht-top)  
								 // 中左(center-left)/左中(left-center) 中中(center-center/center)		 		中右(center-right)/右中(ringht-center)    
								 // 下左(bottom-left)/左下(left-bottom) 下中(bottom-center)/中下(center-top)	下右(bottom-right)/右下(ringht-bottom)
	s auditRequiredFlag = "0"	// 强制审核时，医生批注是否必填			
	s notelists = []
	d notelists.%Push("临床指南").%Push("CFDA相关适应症").%Push("新编药物学").%Push("马丁代尔").%Push("药品说明书").%Push("病人病情需要").%Push("其他")
	
	
	s conObj.showtime = showtime
	s conObj.notallowLevel = notallowLevel
	s conObj.auditLevel = auditLevel
	s conObj.notelists = notelists
	s conObj.showWinModel = showWinModel
	s conObj.pluPosition = pluPosition
	s conObj.auditRequiredFlag = auditRequiredFlag
	
	w conObj.%ToJSON()
	
	q ""
}

}

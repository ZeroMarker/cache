Import sqluser

/// Creator: 	qunianpeng
/// CreateDate: 2020-06-11
/// Descript:   药品知识图谱服务类
/// d $system.OBJ.MakeClassDeployed("web.DHCCKBService")
Class web.DHCCKBService Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 	智能审核接口(全部)
/// Input:		jsParamObj:审查入参json
/// 			MsgID:审查日志id
/// 			action:场景(Pass-审查,Temp-获取模板)
/// 				checkFlag:审查标志(Y:每次重新审查,N不审查,通过msgID获取上一次的审查结果)
/// W ##Class(web.DHCCKBService).AcitonProxy("","","Temp","")
/// Other:		W ##Class(web.DHCCKBService).AcitonProxy("{""PatName"":""王菲"",""PatSex"":""女"",""PatBDay"":""1986-05-29"",""Height"":"""",""Weight"":"""",""SpecGrps"":["""",""成人""],""ProFess"":"""",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""434"",""Item"":"""",""id"":""itemDis"",""item"":""感冒""},{""Warn"":""668"",""Item"":"""",""id"":""itemDis"",""item"":""荨麻疹""}],""itemLab"":[],""labItm"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""1062"",""SeqNo"":""1"",""PhDesc"":""马来酸氯苯那敏片"",""PForm"":""片剂"",""DosQty"":""2"",""DosUom"":""mg"",""Instr"":""口服"",""Freq"":""q8h"",""Duration"":""7天"",""LinkSeqNo"":""1"",""id"":""itemOrder""},{""Warn"":""1063"",""SeqNo"":""2"",""PhDesc"":""酚氨咖敏片"",""PForm"":""片剂"",""DosQty"":""1"",""DosUom"":""片"",""Instr"":""口服"",""Freq"":""tid"",""Duration"":""7天"",""LinkSeqNo"":""2"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""PatLoc"":""呼吸内科门诊"",""DocUser"":""魏贺谨"",""Group"":""安全用药智能决策系统(开发)"",""Hospital"":""东华标准版数字化医院[总院]"",""Profess"":""副主任药师"",""ItemHisOrder"":[{""Warn"":""1062"",""SeqNo"":""1"",""PhDesc"":""马来酸氯苯那敏片"",""PForm"":""片剂"",""DosQty"":""2"",""DosUom"":""mg"",""Instr"":""口服"",""Freq"":""q8h"",""Duration"":""7天"",""LinkSeqNo"":""1"",""id"":""itemOrder""},{""Warn"":""1063"",""SeqNo"":""2"",""PhDesc"":""酚氨咖敏片"",""PForm"":""片剂"",""DosQty"":""1"",""DosUom"":""片"",""Instr"":""口服"",""Freq"":""tid"",""Duration"":""7天"",""LinkSeqNo"":""2"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""Action"":""CheckRule"",""ClientIP"":""117.136.81.41""}","","Pass","Y")
ClassMethod AcitonProxy(jsParamObj As %String, MsgID As %String, action As %String = "Pass", checkFlag As %String = "Y") As %String
{
	n (jsParamObj,MsgID, action,checkFlag)
	s ^temptest("4445")=$lb(jsParamObj,MsgID, action,checkFlag)
	/// 增加action，事件分发类型，知识库对外统一入口  bianshuai 2021-01-04
	if (action = "Temp")
	{
		/// 插件模板
		D ##Class(web.DHCCKBRevPlugin).JsGetRevPluginTemp("")
	}
	elseif(action = "Pass")  
	{
		/// 审查
		D ##Class(web.DHCCKBPassNew).AcitonProxy(jsParamObj,MsgID,checkFlag)	
	}
	
	elseif(action = "Config")  
	{
		/// 配置
		D ##Class(web.DHCCKBBusConfig).GetPluginConfig()	
	}
	q ""
}

/// Descript: 	获取知识接口
/// Input：		类型(DiseaseData:疾病字典,SymptomData:症状),
/// 				flag:0 获取数据 1 回传字典对照信息
/// 				conObj: 字典对照json串
/// 				用户信息(用户^职称id^科室id^安全组id^医院id) 
/// Other:		W ##Class(web.DHCCKBService).GetDataList("DrugCategoryData","1^1^1^1^2")
/// W ##Class(web.DHCCKBService).GetDataList("DiseaseData")
/// W ##Class(web.DHCCKBService).GetDataList("SymptomData")
ClassMethod GetDataList(type As %String, flag = 0, conObj = "", loginInfo As %String = "") As %String
{
	n (type,flag, conObj,loginInfo)
	
	s $ZT="ErrMsg"
	
	i flag =0 d
	.d ##class(web.DHCCKBInterface).GetDataListForCdss(type)
	
	q ""
ErrMsg
	q ""
}

/// Descript: 	CDSS回传知识信息
/// Input：		知识信息json串
/// Other:		W ##Class(web.DHCCKBService).TransferData()
ClassMethod TransferData(dataObj As %String) As %String
{
	n (dataObj)
	
	d ##class(web.DHCCKBInterface).SaveCdssDataTmp(dataObj)	
	
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2020-11-30
/// Descript: 	智能审查反馈信息接口(医生站用)
/// Input：		msgID: 唯一标识
/// 			user:  用户id
/// 			date:  日期
/// 			time:  时间
///             ordItemStr: 医嘱id^反馈状态^反馈备注 多条使用 &&       // 反馈状态 R:(强制通过-Review)/P:(Pass:审查通过)/Y:(同意-Yes-审方)/N:(拒绝-No-审方)/F:(提醒错误-False)/T:(提醒正确-True)
/// 			userType: 医护人员类型(Doc(医生)/Pha(药师)/Nur(护士))
/// Other:		w ##Class(web.DHCCKBService).FeedBack("7014","17578","2021-03-27","17:44:12","2258390||168^R^&&2258390||169^R^&&2258390||170^R^&&2258390||171^R^","Doc","[{""item"":""维生素C注射液(天津金耀)5ml:1g"",""seqno"":""2"",""manlevel"":""warn"",""unique"":""3338_2"",""val"":""警示-维生素C12"",""selectReason"":""临床指南!!CFDA相关适应症"",""reagrpId"":""#WL3338_2""},{""item"":""胰岛素针400iu"",""seqno"":""4"",""manlevel"":""tips"",""unique"":""95673_4"",""val"":""提醒-胰岛素13"",""selectReason"":""临床指南!!新编药物学"",""reagrpId"":""#WL95673_4""},{""item"":""盐酸胺碘酮片(可达龙)0.2g*10"",""seqno"":""1"",""manlevel"":""warn"",""unique"":""95717_1"",""val"":""警示-可达龙空""}]")
/// w ##Class(web.DHCCKBService).FeedBack("7026","17578","2021-03-29","17:48:14","2258390||182^P^","Doc","[]")
/// w ##Class(web.DHCCKBService).FeedBack("7038","17578","2021-03-29","18:13:42","2258390||190^R^&&2258390||191^R^","Doc","[{""item"":""维生素C注射液(天津金耀)5ml:1g"",""seqno"":""1"",""manlevel"":""warn"",""unique"":""3338_1"",""val"":""""},{""item"":""盐酸胺碘酮片(可达龙)0.2g*10"",""seqno"":""2"",""manlevel"":""forbid"",""unique"":""95717_2"",""val"":""""}]")
ClassMethod FeedBack(msgID, user, date, time, ordItemStr, userType, reasonStr = "") As %String
{
	n (msgID, user, date, time, ordItemStr, userType,reasonStr)
	
	s ret=##class(web.DHCCKBInterface).FeedBack(msgID, user, date, time, ordItemStr, userType,reasonStr)
	
	s msgObj = ##class(DHCNewPro.COM.Object).%New()
	s msgObj.code = ret
	if ret=0 s msgObj.status = "success"	
	else  s msgObj.status = "fail"

	q msgObj.ToJSON()
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-27
/// Descript: 	药房审方同意或拒绝用药调用接口存储原因
/// Input：		msgID: 唯一标识
/// 			user:  用户id
/// 			date:  日期
/// 			time:  时间
/// 				userType: 医护人员类型(Doc(医生)/Pha(药师)/Nur(护士))
///             input： 医嘱id^日志id^级别^"强制审核"^交互状态^备注^批注勾选(!!分割)^唯一标识 $$$      // 反馈状态 R:(强制通过-Review)/P:(Pass:审查通过)/Y:(同意-Yes-审方)/N:(拒绝-No-审方)/F:(提醒错误-False)/T:(提醒正确-True)
/// Other:		w ##Class(web.DHCCKBService).SaveFeedBackData()
ClassMethod SaveFeedBackData(msgID, user, date, time, userType, input) As %String
{
	n (msgID, user, date, time, userType, input)

	//		 医嘱id		 日志id		级别					   交互状态   备注     批注勾选(!!分割)      唯一标识 $$$
	//input: ordItem_"^"_msgID_"^"_manlevel_"^"_status_"^"_note_"^"_selReason			_"^"_unique

	s ret=##class(web.DHCCKBInterface).SaveFeedBackData(msgID, user, date, time, userType, input)
	
	s msgObj = ##class(DHCNewPro.COM.Object).%New()
	s msgObj.code = ret
	if ret=0 s msgObj.status = "success"	
	else  s msgObj.status = "fail"

	q msgObj.ToJSON()
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-28
/// Descript: 	获取医生批注信息用于初始化
/// Input：		msgID: 日志id
/// Other：		W ##Class(web.DHCCKBService).InitDocNotes(379)
ClassMethod InitDocNotes(msgID, type = "mul") As %String
{
	n (msgID, type)
		
	s $ZT="ErrInitDocNotes"
	
	q:msgID="" "null"
	q:$lg(^CKB.PDSS.MonMasterD(+msgID),15)'="R" "null"	// 不是强制审核状态的不初始化批注
	i type = "mul" d
	.w ##Class(web.DHCCKBFeedBack).GetDocNotes(msgID)
	e  d
	.w ##Class(web.DHCCKBFeedBack).GetMonMasterDocNotes(msgID)
	
	q ""
ErrInitDocNotes
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-28
/// Descript: 	通过医嘱id获取msgID和level级别
/// Input：		oeorItem医嘱id, type(默认为Doc)
/// return:		msgID^级别
/// w ##class(web.DHCCKBService).GetMsgByOeorItem(oeorItem, type)
ClassMethod GetMsgByOeorItem(oeorItem, type = "Doc") As %String
{
	n (oeorItem,type)
	q ##class(web.DHCCKBInterface).GetMsgByOeorItem(oeorItem,type)
	
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-28
/// Descript: 	点击强制审核时,修改强制审核的原因和备注(pass调用)
/// Input：		日志id, 备注信息, 批注勾选原因(!!分割), 状态(合理P,强制R), 消息框多个还是一个
/// return:		msgID^级别
/// w ##class(web.DHCCKBService).UpdateFeedBack("936","[{""val"":""dddew"",""selectReason"":""临床指南!!新编药物学""}]","R","alone")
/// w ##class(web.DHCCKBService).UpdateFeedBack("8170634","[{""item"":""注射用血塞通（冻干）200mg（哈尔滨珍宝制药有限公司）"",""seqno"":""2"",""manlevel"":""forbid"",""unique"":""2_2"",""val"":""雪山同可以用"",""selectReason"":""临床指南!!CFDA相关适应症"",""reagrpId"":""#WL2_2""},{""item"":""银杏达莫注射液5ml(贵州益佰制药股份有限公司）"",""seqno"":""1"",""manlevel"":""forbid"",""unique"":""1_1"",""val"":""硬性不能用兜底"",""selectReason"":""CFDA相关适应症!!新编药物学"",""reagrpId"":""#WL1_1""}]","R","mul","174^1^1^N!!175^2^2^N")
ClassMethod UpdateFeedBack(msgID, reasonsArr, status, way = "mul", drugUniqueStr) As %String
{
	n (msgID, reasonsArr, status, way, drugUniqueStr)
	
	if way = "mul"  d
	.d ##Class(web.DHCCKBFeedBack).UpdateNotesFeedBack(msgID,reasonsArr,status,drugUniqueStr)
	e  d
	.s reasonObj = ##class(DHCNewPro.COM.Object).FromJSON(reasonsArr)
	.s reasonObj = reasonObj.Get(0)
	.s reason = reasonObj.selectReason
	.s notes = reasonObj.val
	.w ##Class(web.DHCCKBFeedBack).UpdateNotesMonMaster(msgID, notes, reason, status)
	
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-28
/// Descript: 	保存医嘱后,调用接口保存医嘱信息
/// Input：		oeordItemStr(医嘱id^药品唯一标识^是否通过Y/N)
/// return:		msgID^级别
/// w ##class(web.DHCCKBService).SaveOeordFeedBack()
ClassMethod SaveOeordFeedBack(oeordItemStr) As %String
{
	n (oeordItemStr)
	s ^temptest("oeordItemStr") = oeordItemStr
	q ##class(web.DHCCKBInterface).SaveOeordFeedBack(oeordItemStr)
	
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-11-12
/// Descript: 	获取说明书
/// Input：		药品id,药品code,药品名称
/// return:		msgID^级别
/// w ##class(web.DHCCKBService).QueryDrugInstrDetail(81885,"","")
ClassMethod QueryDrugInstrDetail(drugId, drugCode, drugName, hisDrugCode, hisDrugName) As %String
{
	n (drugId,drugCode,drugName,hisDrugCode,hisDrugName)

	s exitFlag = 0
	s retObj = ##class(DHCNewPro.COM.Object).%New()
	s retObj.code=0
	s retObj.msg = "没有找到说明书"
	
	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	if (drugId="")&&(drugName'="")  d
	.s drugId =  ##class(web.DHCCKBCommon).GetDicIdByDesc(drugName,drugDataId)
	
	if (+drugId = 0)&&(hisDrugCode'="")&&(hisDrugName'="")  d	
	.s constStr = ##class(web.DHCCKBComContrast).GetSysConst(hisDrugCode,hisDrugName,drugDataId)
	.s drugId = ##class(web.DHCCKBCommon).GetDicIDByCodeDesc($p(constStr,"^",1),$p(constStr,"^",2),drugDataId)

	i +drugId = 0 d	
	.s exitFlag = 1
	q:exitFlag=1 retObj.ToJSON()
	
	s wikiJson = ##class(web.DHCCKBWiki).WikiToJson(drugId)
	q:wikiJson="{}" retObj.ToJSON()
	
	s retObj.code=1 
	s retObj.msg="查询成功"
	s retObj.data = ##class(DHCNewPro.COM.Object).FromJSON(wikiJson)
	
	q retObj.ToJSON()
}

}

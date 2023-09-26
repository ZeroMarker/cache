Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-20
/// Descript: 		安全用药智能决策系统
Class web.DHCCKBPassBack Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  安全用药智能审查	
/// w ##Class(web.DHCCKBPassNew).IntMakPolPass("{""PatName"":""黎明"",""PatSex"":""男"",""PatBDay"":""1988-05-03"",""Height"":""170"",""Weight"":""70"",""SpecGrps"":[""""],""ProFess"":"""",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""743"",""Type"":""诊断"",""item"":""急性"",""id"":""itemDis""}],""ItemSym"":[],""itemLab"":[],""labItm"":[{""Warn"":""77"",""Item"":"""",""Val"":""20"",""Uom"":""μmol/L"",""id"":""itemLab"",""Type"":""LabItm"",""item"":""同型半胱氨酸""}],""itemOper"":[],""itemOrder"":[{""Warn"":""1790"",""SeqNo"":""1"",""PhDesc"":""磷酸奥司他韦胶囊75mg（宜昌东阳光长江药业股份有限公司）"",""PForm"":""片剂"",""DosQty"":""1"",""DosUom"":""片"",""Instr"":""口服"",""Freq"":""qd"",""Duration"":"""",""LinkSeqNo"":""1"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""PatLoc"":""呼吸内科门诊"",""DocUser"":""苏帆"",""Group"":""安全用药智能决策系统(开发)"",""Hospital"":""东华标准版数字化医院[总院]"",""Profess"":""主管药师"",""ItemHisOrder"":[],""PatType"":"""",""Action"":""CheckRule"",""ClientIP"":""223.104.11.29""}")
/// w ##Class(web.DHCCKBPassNew).IntMakPolPass("{""PatName"":""孙慧勇"",""PatSex"":""男"",""PatBDay"":""2022-05-03"",""Height"":""111"",""Weight"":""75"",""SpecGrps"":[""""],""ProFess"":"""",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""702"",""Type"":""诊断"",""item"":""诊断测试"",""id"":""itemDis""}],""ItemSym"":[{""Warn"":""690"",""Type"":""sym"",""item"":""症状测试"",""id"":""itemDis""}],""itemLab"":[],""labItm"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""1718"",""SeqNo"":""1"",""PhDesc"":""注射用青霉素钠80万U(华北制药股份有限公司)"",""PForm"":"""",""DosQty"":"""",""DosUom"":"""",""Instr"":"""",""Freq"":"""",""Duration"":"""",""LinkSeqNo"":""1"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""PatLoc"":""呼吸内科门诊"",""DocUser"":""苏帆"",""Group"":""安全用药智能决策系统(开发)"",""Hospital"":""东华标准版数字化医院[总院]"",""Profess"":""主管药师"",""ItemHisOrder"":[],""PatType"":"""",""Action"":""CheckRule"",""ClientIP"":""113.140.81.66""}")
/// w ##Class(web.DHCCKBPassNew).IntMakPolPass("{""PatName"":""王飞"",""PatSex"":""男"",""PatBDay"":""2018-02-10"",""Height"":"""",""Weight"":""18"",""SpecGrps"":[""""],""ProFess"":"""",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""76"",""Item"":"""",""id"":""itemDis"",""item"":""感冒"",""Type"":""""}],""ItemSym"":[],""itemLab"":[],""labItm"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""1750"",""SeqNo"":""1"",""PhDesc"":""对乙酰氨基酚滴剂40ml(江苏汉晨药业有限公司）"",""PForm"":"""",""DosQty"":""2"",""DosUom"":""ml"",""Instr"":""口服"",""Freq"":""bid"",""Duration"":"""",""LinkSeqNo"":""1"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""PatLoc"":""呼吸内科门诊"",""DocUser"":""屈年鹏"",""Group"":""安全用药智能决策系统(开发)"",""Hospital"":""东华标准版数字化医院[总院]"",""Profess"":""主管药师"",""ItemHisOrder"":[],""PatType"":"""",""Action"":""CheckRule"",""ClientIP"":""113.140.81.66""}")
/// w ##Class(web.DHCCKBPassNew).IntMakPolPass("{""PatName"":""重复用药（通用名）"",""PatSex"":""女"",""PatBDay"":""2000-06-09"",""Height"":"""",""Weight"":"""",""SpecGrps"":[""""],""ProFess"":"""",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[],""ItemSym"":[],""itemLab"":[],""labItm"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""331"",""SeqNo"":""2"",""PhDesc"":""盐酸环丙沙星片0.25g(天津中央药业有限公司)"",""PForm"":""片剂"",""DosQty"":""0.5"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""tid"",""Duration"":""3天"",""LinkSeqNo"":""2"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""},{""Warn"":""332"",""SeqNo"":""3"",""PhDesc"":""盐酸环丙沙星片0.25g(浙江医药股份有限公司新昌制药厂)"",""PForm"":""片剂"",""DosQty"":""0.5"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""tid"",""Duration"":""3天"",""LinkSeqNo"":""3"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""PatLoc"":""呼吸内科门诊"",""DocUser"":""屈年鹏"",""Group"":""安全用药智能决策系统(开发)"",""Hospital"":""东华标准版数字化医院[总院]"",""Profess"":""主管药师"",""ItemHisOrder"":[],""PatType"":"""",""Action"":""CheckRule"",""ClientIP"":""113.140.81.66""}")
/// w ##Class(web.DHCCKBPassNew).IntMakPolPass("{""PatName"":""王明飞"",""PatSex"":""男"",""PatBDay"":""1938-06-16"",""Height"":"""",""Weight"":"""",""SpecGrps"":[""""],""ProFess"":"""",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""684"",""Type"":""诊断"",""item"":""焦虑状态结膜炎"",""id"":""itemDis""}],""ItemSym"":[],""itemLab"":[],""labItm"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""1848"",""SeqNo"":""1"",""PhDesc"":""劳拉西泮[1mg x24片/盒]"",""PForm"":""薄膜衣片"",""DosQty"":""1"",""DosUom"":""mg"",""Instr"":""口服"",""Freq"":""3/日（6am-12n-6pm）"",""Duration"":"""",""LinkSeqNo"":""1"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""PatLoc"":""呼吸内科门诊"",""DocUser"":""屈年鹏"",""Group"":""安全用药智能决策系统(开发)"",""Hospital"":""东华标准版数字化医院[总院]"",""Profess"":""主管药师"",""ItemHisOrder"":[],""PatType"":"""",""Action"":""CheckRule"",""ClientIP"":""113.140.81.66""}")
/// w ##Class(web.DHCCKBPassNew).IntMakPolPass("{""PatName"":""王明飞"",""PatSex"":""男"",""PatBDay"":""2010-10-16"",""Height"":""170"",""Weight"":"""",""SpecGrps"":[""""],""ProFess"":"""",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""684"",""Type"":""诊断"",""item"":""急性疼痛"",""id"":""itemDis""},{""Warn"":""685"",""Type"":""诊断"",""item"":""急性支气管炎"",""id"":""itemDis""}],""ItemSym"":[],""itemLab"":[],""labItm"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""1697"",""SeqNo"":""1"",""PhDesc"":""氨酚曲马多片(宜昌人福药业有限责任公司)"",""PForm"":"""",""DosQty"":""1"",""DosUom"":""片"",""Instr"":""口服"",""Freq"":""q6h"",""Duration"":"""",""LinkSeqNo"":""1"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""},{""Warn"":""1698"",""SeqNo"":""2"",""PhDesc"":""硫酸依替米星注射液2ml:100mg(无锡济民可信山禾药业股份有限公司)"",""PForm"":"""",""DosQty"":""0.1"",""DosUom"":""g"",""Instr"":""静脉滴注"",""Freq"":""qd"",""Duration"":"""",""LinkSeqNo"":""2"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""},{""Warn"":""1699"",""SeqNo"":""3"",""PhDesc"":""0.9%氯化钠注射液100ml(天津百特医疗用品有限公司）"",""PForm"":"""",""DosQty"":""100"",""DosUom"":""ml"",""Instr"":""静脉滴注"",""Freq"":""qd"",""Duration"":"""",""LinkSeqNo"":""2.3"",""id"":""itemOrder"",""OrdDate"":"""",""FirstMark"":"""",""OrdEndDate"":"""",""DrugSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""Skin"":"""",""PrescNum"":""""}],""PatLoc"":""呼吸内科门诊"",""DocUser"":""苏帆"",""Group"":""安全用药智能决策系统(开发)"",""Hospital"":""东华标准版数字化医院[总院]"",""Profess"":""主管药师"",""ItemHisOrder"":[],""PatType"":"""",""Action"":""CheckRule"",""ClientIP"":""117.136.50.132""}")
ClassMethod IntMakPolPass(jsParamObj As %String, RetStr = "", AccFlag = "Y") As %String
{
	n (jsParamObj,RetStr,AccFlag)
	s ^tempsufan("567")=jsParamObj
	s jsParamObj=..ChangeKey(jsParamObj)	//临时将his的入参key,转成知识库的属性

	/// 错误陷阱
	s $ZT="ErrMsg"
	S jsParamObj={}.%FromJSON(jsParamObj)
	//s jsParamObj=..SetJsObj(jsParamObj)		// json数据处理
	s ^TMPMonitor("Monitor")=jsParamObj
	
	k TmpArr, TmpMsgArr
	s TmpArr("AccFlag") = AccFlag
	//Ts
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s TmpArr("pid")=pid
	
	/// 知识库审查	
	s TmpArr("InParams")=jsParamObj
 	
	D ##Class(web.DHCCKBPassNew).InvIntExam(.TmpArr, .TmpMsgArr)

	/// 监测中心
	s TmpArr("InParams")=jsParamObj.%ToJSON()
	s TmpArr("Source")="Own"
	D ##Class(web.DHCCKBMonitor).InsMonitor(.TmpArr, .TmpMsgArr)
	
	d ..killTmpGlobal(pid)
	i $g(TmpArr("OutParams"))'=""  d				// 增加MsgID
	.s TmpStr=TmpArr("OutParams") //MsgID
	.s TmpStr={}.%FromJSON(TmpStr)
	.d TmpStr.%Set("MsgID",TmpMsgArr("MsgID"))
	.s TmpArr("OutParams")=TmpStr.%ToJSON()
	
	//TC
	w $g(TmpArr("OutParams"))
	s RetStr=$g(TmpArr("OutParams"))
	
	Q ""
ErrMsg
	Tro
	D ..TakErrMsg("-99^审查出错！"_$ze)
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-20
/// Descript: 		知识库审查入口
/// w ##Class(web.DHCCKBPassNew).IntMakPolPass("","")
ClassMethod AcitonProxy(jsParamObj As %String, MsgID As %String, checkFlag As %String) As %String
{
	n (jsParamObj, MsgID, checkFlag)

	i (checkFlag="N")&&(MsgID'="")  D
	.d ##Class(web.DHCCKBMonitor).GetCkbExaRes(MsgID) /// 监测日志结果
	E  D
	.d ..IntMakPolPass(jsParamObj) /// 安全用药智能决策
	Q ""
}

/// Descript: 智能审查
/// W ##Class(web.DHCCKBPassNew).InvIntExam("")
ClassMethod InvIntExam(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
		
	/// 错误陷阱
	//s $ZT="ErrorMessage"
	/// 解析json参数

	D ..TrsInsTmpArr($g(TmpArr("InParams")), .TmpArr)

	/// 调用智能决策(知识库审查)
	D ..IntMakPol(.TmpArr, .TmpMsgArr)
	
	/// 结果输出
	D ..InvOutResNew(.TmpArr, .TmpMsgArr)
	Q ""

ErrorMessage
	D ..TakErrMsg("-99^审查出错！")
	Q ""
}

/// Descript:  转成 %ArrayOfDataTypes
ClassMethod TrsInsTmpArr(arrsObj, TmpArr) As %String
{
	n (arrsObj, TmpArr)
	
	/// 初始化使用场景
	d ##class(web.DHCCKBDealParameter).InitRequestAction(arrsObj, .TmpArr)

	/// 初始化医生信息
	d ##Class(web.DHCCKBDealParameter).InitLogin(arrsObj, .TmpArr)
	
	/// 初始化患者信息
	d ##Class(web.DHCCKBDealParameter).InitPatient(arrsObj, .TmpArr)
	
	/// 初始化特殊人群
	d ##Class(web.DHCCKBDealParameter).InitStrArr(arrsObj, .TmpArr,"SpecialPop","SpecialPop")
	
	/// 初始化疾病
	d ##Class(web.DHCCKBDealParameter).InitObjArr(arrsObj, .TmpArr,"Disease","Disease")

	/// 初始化检验套
	d ##Class(web.DHCCKBDealParameter).InitObjArr(arrsObj, .TmpArr,"itemLab","Lab")

	/// 初始化过敏
	d ##Class(web.DHCCKBDealParameter).InitHisAllergy(arrsObj, .TmpArr)

	/// 初始化检验指标
	d ##Class(web.DHCCKBDealParameter).InitLabItm(arrsObj, .TmpArr)

	/// 初始化药品
	d ##Class(web.DHCCKBDealParameter).InitDrug(arrsObj,.TmpArr)
	
	/// 判断患者是否是儿童 qnp 2022-04-16
	d ##Class(web.DHCCKBDealParameter).CheckPatIsChild(.TmpArr)
	
	/// 判断历史医嘱的相互作用 qnp 2022-05-12
	d ##Class(web.DHCCKBDealParameter).InitHisOrder(arrsObj,.TmpArr)
	
	/// 初始化症状 2022-05-13
	d ##Class(web.DHCCKBDealParameter).InitObjArr(arrsObj, .TmpArr,"ItemSym","Symptom")

	Q ""
}

/// Descript:	根据审查项目的值,审查项目获取对照的知识库字典id
/// Author：	qunianpeng 2020/3/9 
/// Input:		his项目描述, 审查代码
/// w ##Class(web.DHCCKBPassNew).GetComDicIdNew("六神曲","Drug")
ClassMethod GetComDicIdNew(itemcode As %String, type = "", hospital = "") As %String
{
	n (itemcode,type,hospital)
	Q:itemcode="" ""
	
	s sourceData=""
	i type'="" s sourceData=##class(web.DHCCKBCommon).GetDataSourceValue(type)	
	s itemcodeList=##class(web.DHCCKBPassNew).GetKnowBaseCode(itemcode,sourceData,hospital)
	Q:itemcodeList="" ""
	Q:$listlength(itemcodeList)=0 ""
	s ohterDataId=##class(web.DHCCKBCommon).GetOtherName()
	s drugDataId=##class(web.DHCCKBCommon).GetDrugData()
	s chineseDrugDataId=##class(web.DHCCKBCommon).GetChineseDrugData()
	s chinaHMDataId=##class(web.DHCCKBCommon).GetChineseHMData()
	s itmidList=""
	f i=1:1:$listlength(itemcodeList)  d
	.s itemcode=$listget(itemcodeList,i)
	.q:$$ALPHAUP^SSUTIL4(itemcode)=""
	.s dicID=""
	.f  s dicID=$o(^DHCCKBCD(0,"Code",$$ALPHAUP^SSUTIL4(itemcode),dicID))	q:(dicID="")  d
	..s parref=$p($g(^DHCCKBCD(dicID)),"^",3)
	..q:parref=""	
	..q:(type'="Drug")&&((+sourceData'=0)&(parref'=sourceData))	
	..q:(type="Drug")&((parref'=drugDataId)&(parref'=chineseDrugDataId))&(parref'=chinaHMDataId)
	..q:(+ohterDataId'=0)&(parref=ohterDataId)	// 过滤掉别名
	..q:0=##class(web.DHCCKBCommon).IsEnabled(dicID)	// 过滤数据被停用
	..q:$listfind(itmidList,dicID)'=0
	..s $list(itmidList,*+1)=dicID

	s itmdescList=""
	f i=1:1:$listlength(itemcodeList)  d
	.s itemcode=$listget(itemcodeList,i)
	.q:$$ALPHAUP^SSUTIL4(itemcode)=""
	.s dicID=""
	.f  s dicID=$o(^DHCCKBCD(0,"Desc",$$ALPHAUP^SSUTIL4(itemcode),dicID))	q:(dicID="")  d
	..s parref=$p(^DHCCKBCD(dicID),"^",3)
	..q:parref=""
	..q:(+sourceData'=0)&(parref'=sourceData)
	..q:(+ohterDataId'=0)&(parref=ohterDataId)	// 过滤掉别名
	..q:(type="Drug")&((parref'=drugDataId)&(parref'=chineseDrugDataId))&(parref'=chinaHMDataId)
	..q:0=##class(web.DHCCKBCommon).IsEnabled(dicID)	// 过滤数据被停用
	..q:$listfind(itmdescList,dicID)'=0
	..s $list(itmdescList,*+1)=dicID

	s itmidList = ##Class(web.DHCCKBCommonUtil).GetUnionList(itmidList,itmdescList)	

	Q itmidList
}

/// Descript:	规则分类代码
/// w ##Class(web.DHCCKBPassNew).GetRuleTypeCode("1522")
ClassMethod GetRuleTypeCode(ID As %String) As %String
{
	n (ID)
	s TypeID=$p(^DHCCKBRULE(ID),"^",5)  /// 规则类型
	Q:TypeID="" ""
	s Type=$p(^DHCCKBCD(TypeID),"^",1)  /// 实体描述
	Q Type
}

/// Descript:	规则分类描述
/// w ##Class(web.DHCCKBPassNew).GetRuleTypeDesc("1522")
ClassMethod GetRuleTypeDesc(ID As %String) As %String
{
	n (ID)
	//s TypeID=$p(^DHCCKBRULE(ID),"^",5)  /// 规则类型
	//Q:TypeID="" ""
	s TypeID=$p(^DHCCKBRD(ID),"^",3)  /// 规则类型
	Q:TypeID="" ""
	s Type=$p(^DHCCKBCD(TypeID),"^",2)  /// 实体描述
	Q Type
}

///  Descript:  当前规则是否有前置条件
///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    0 - 没有、1-有
///  w ##Class(web.DHCCKBPassNew).TakPreConditions("1831",TmpPreConsArr)
ClassMethod TakPreConditions(RulID As %String, TmpPreConsArr, TmpMsgArr) As %String
{
	n (RulID, TmpPreConsArr,TmpMsgArr)
	k TmpPreConsArr
	/// 当前规则前置条件
	s Libary=0
	//s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	//判断规则中是否有目录
	s Dic="" f  s Dic=$o(^DHCCKBRULEDIC(0,"RuleDic",RulID,Dic)) q:Dic=""  d
	.s DicParef=$p(^DHCCKBCD(Dic),"^",3)
	.s:DicParef=DrugLibary Libary=Dic

	q:Libary="" 0
	s PreList=""	// 记录所有的前提条件
	s QuitFlag=0
	s Parent=""
	f  s Parent=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",Parent))  q:Parent=""   d  
	.s Node=""
	.f  s Node=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",Parent,Node))  q:Node=""   d  
	..q:Node=0
	..s RulDataID=""
	..f  s RulDataID=$o(^DHCCKBRD(0,"Node",Node,RulDataID))  q:RulDataID=""   d
	...q:RulDataID=0
	...s LeftDic=$p(^DHCCKBRD(RulDataID),"^",3)	// 实体/属性（前提条件的项目代码）
	...q:'$d(^DHCCKBDLA(0,"LinkDicAttrCode",Libary,LeftDic))
	...s LinkID=""
	...f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",Libary,LeftDic,LinkID)) q:LinkID=""  d	// 前提条件好像存储的不对 03/05
	....q:$p(^DHCCKBDLA(LinkID),"^",4)'="Y"
	....s Attr=$p(^DHCCKBDLA(LinkID),"^",3)
	....q:+Attr=0
	....q:Attr'=##class(web.DHCCKBCommon).GetPreconditions()	//前提条件
	....s QuitFlag=1
	....i QuitFlag d 
	.....s TmpPreConsArr("PropType",RulID,RulDataID)=LeftDic
	.....s:$listfind(PreList,LeftDic)<0 $list(PreList,*+1)=LeftDic

	i PreList="" s $list(PreList)="NULL"	// 无前提
	s TmpMsgArr("PreCondtions",RulID)=PreList
	q QuitFlag
}

///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    0 - 不满足、1-满足
///  w ##Class(web.DHCCKBPassNew).isPreConditions("69", .TmpPreConsArr, .TmpArr)
ClassMethod isPreConditions(RulID As %String, TmpPreConsArr, TmpArr, TmpMsgArr) As %String
{
	n (RulID, TmpPreConsArr, TmpArr,TmpMsgArr)
	
	Q:'$D(TmpPreConsArr("PropType")) 1        /// 当前规则类型未设置前置条件

	/// 当前规则定义是否满足所有的前置条件
	s TipsPath=$g(TmpArr("TipsPath"))	/// 提醒方向
	s CheckDicID=$g(TmpArr("CheckDicID"))
	s RulDataID="",IsFlag=1,Count=0,IsGrpTrue=""
	F  s RulDataID=$o(TmpPreConsArr("PropType",RulID,RulDataID)) Q:(RulDataID="")||(IsFlag=0)  D
	.s TmpArr("ID")=RulDataID
	.s RuleNode=$p(^DHCCKBRD(RulDataID),"^",2)
	.s NodeCondition=$p(^DHCCKBRULENODE(RuleNode),"^",2)	
	.s Ret=..isCorrect(.TmpArr, .TmpMsgArr) //1 满足 0 不满足 -1没有值
	.d ..KillRuleDataMsgStr(CheckDicID,RulID,RulDataID,.TmpMsgArr)	// 前提条件审查的项目,不需要返回值
	.q:Ret=-100
	.//s:Ret=-1 IsFlag=0	// -1 在前提条件中认为，不满足条件
	.//q:Ret=-1
	.i Ret=-1 s Ret=0
	.s Count=Count+1
	.i Count=1 s IsGrpTrue=Ret
	.e  s IsGrpTrue=IsGrpTrue&Ret	// 前提条件都认为是平级 and 关系
			
	q:IsFlag=0 IsFlag
	s IsFlag=$case(IsGrpTrue="",1:1,:IsGrpTrue)

	Q IsFlag
}

///  Descript:  当前规则条件是否可用
///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    0 - 没有、1-有
///  w ##Class(web.DHCCKBPassNew).isEnabled("69", .TmpPreConsArr)
ClassMethod isEnabled(ID As %String) As %String
{
	n (ID)
	/// 当前规则前置条件
	s DicTypeID=$p(^DHCCKBRULE(RulID),"^",5)    /// 规则类型
	s PropTypeID=""
	F  s PropTypeID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicTypeID,PropTypeID)) Q:PropTypeID=""  D
	.s LkID="", QuitFlag=1
	.F  s LkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicTypeID,PropTypeID,LkID)) Q:(LkID="")||(QuitFlag=0)  D
	..Q:$p(^DHCCKBDLA(LkID),"^",4)="Y" /// 是否可用
	..s QuitFlag=0
	.
	Q ""
}

///  Descript:  知识库审查
///  w ##Class(web.DHCCKBPassNew).IntMakPol("63", .TmpArr)
ClassMethod IntMakPol(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	
	s pid=TmpArr("pid")
	s itmList=$g(TmpArr("Drug"))
	s globalAcc=..CheckGlobalAcc($g(TmpArr("UserInfo")))
	s TmpArr("globalAcc")=globalAcc	// 全局规则/重复用药/过敏的权限
	f i=1:1:$listlength(itmList) d
	.s itmid=$list(itmList,i)
	.s TmpArr("CheckDicID")=itmid
	.q:+itmid=0
	.s realItmId=$p(itmid,$c(2),1)
	.s locPassListFlag=##class(web.DHCCKBPassExt).UpdateDrugListNew($listtostring(TmpArr("Office","Ext")),realItmId)      //shy  2021-5-27  科室审查列表过滤 0 通过 1不通过
	.q:locPassListFlag=1
	.d ..CheckAllergyMedical(pid, itmid, .TmpArr, .TmpMsgArr) //药品过敏
	.d ..CheckRepeatMedical(pid,itmid,.TmpArr,.TmpMsgArr)
	.//d ##Class(web.DHCCKBPassExt).CheckSimilarEffect(itmid,.TmpArr,.TmpMsgArr)	// 药品的相似作用 2020/12/11
	.;s CheckSimilarRepeatGenalNewFlag=##class(web.DHCCKBPassExt).IsHealthLocPass($listtostring(TmpArr("Office","Ext")))  //shy 添加（重复用药-中成药）科室限制
	.;i CheckSimilarRepeatGenalNewFlag=1  d    sunhuiyong暂时放开限制  2021-9-9
	.d ##Class(web.DHCCKBPassExt).CheckSimilarRepeatGenalNew(itmid,.TmpArr,.TmpMsgArr)	// 重复用药-中成药 2021/6/9
	.d ##Class(web.DHCCKBPassExt).CheckSimilarComposition(pid,itmid,.TmpArr,.TmpMsgArr)	// 重复用药-成分重复 武汉一院 shy 2021-7-9
	.d ##Class(web.DHCCKBPassExt).CheckPoisonList(pid,itmid,.TmpArr,.TmpMsgArr)	// 重复用药-毒性成分重复 武汉一院 shy 2021-7-21
	.d ##Class(web.DHCCKBPassExt).CheckSimilarEffectNew(itmid,.TmpArr,.TmpMsgArr)	// 药品的相似作用 2021/5/15 武汉一院
	.d ##Class(web.DHCCKBPassExt).CheckVolPurch(itmid,.TmpArr,.TmpMsgArr)	// 带量采购药品范围判断 2021/1/15	武汉一院
	.d ##Class(web.DHCCKBPassExt).CheckSimilarRepeat(itmid,.TmpArr,.TmpMsgArr) // 药学分类同类重复 2021/1/18	武汉一院
	.d ##Class(web.DHCCKBPassExt).CheckDifferentRepeat(itmid,.TmpArr,.TmpMsgArr) // 药学分类异类重复 2021/1/19 (可以放到循环外面) 武汉一院
	.d ##Class(web.DHCCKBPassExt).CheckBaseDrugPriority(itmid,.TmpArr,.TmpMsgArr)	// 基药优先范围判断 2021/2/2
	.d ##Class(web.DHCCKBPassExt).TempCheckHelathIcd(pid,itmid,.TmpArr,.TmpMsgArr) // 健康查体禁忌 2022/4/25 qnp
	.d ..CheckCommonRule(itmid,.TmpArr,.TmpMsgArr)	// 审查药品规则之前,先审查所有全局规则
	.//d ..CheckRule(itmid,.TmpArr, .TmpMsgArr)
	.d ..CheckRuleByLibary(itmid, .TmpArr, .TmpMsgArr) //2022-03-27 使用药品->目录->规则关系 审查
	.d ##Class(web.DHCCKBPassExt).CheckBaseRule(itmid, .TmpArr, .TmpMsgArr)		// 审核日极量、日最大量、次极量、次最大量、日荒诞值、次荒诞值2022-03-29 qnp
	.d ##Class(web.DHCCKBPassExt).CheckIngrRule(itmid,.TmpArr, .TmpMsgArr,"ingr") // 成分规则 qnp 2021/4/25
	.d ##Class(web.DHCCKBPassExt).CheckIngrRule(itmid,.TmpArr, .TmpMsgArr,"prescCope") // 处方应付规则 qnp 2021/5/07
	.d ##Class(web.DHCCKBPassExt).CheckIngrRule(itmid,.TmpArr, .TmpMsgArr,"generName") // 通用名适应症规则 sufan 2022/04/25
	.d ##Class(web.DHCCKBPassExt).CheckOriginalDrugRule(itmid,.TmpArr, .TmpMsgArr)	// 使用本品原研药进行规则判断(需要放在所有审查之后) qunianpeng 2022/04/26 
	.//d ..CheckIndication(itmid,.TmpArr, .TmpMsgArr) //xiaowenwu 2020-03-04 先判断适应症，再判断用法用量
	.d ##Class(web.DHCCKBPassExt).IndicatReview(itmid,.TmpArr, .TmpMsgArr)
	
	// 审核历史医嘱,并且只审核相互作用 2022/05/12
	d ##Class(web.DHCCKBPassExt).CheckHisOrder(.TmpArr, .TmpMsgArr)
	
	
	Q ""
}

///  Descript:  遍历规则
///  Input:     node - 节点,RelType - 关系类型(and,or)
///  Output:    0 - 不符合规则、1-符合规则
///  w ##Class(web.DHCCKBPassNew).InvRuleData("", "", .TmpArr)
ClassMethod InvRuleData(ParentID As %String, TmpArr, TmpMsgArr, RuleStyle = "G") As %String
{
	n (ParentID,TmpArr,TmpMsgArr,RuleStyle)

	s RulID=$g(TmpArr("RulID"))
	// 先判断本节点有没有规则值，有的情况下，先计算本节点的值
	s NodeID="",IsTrue=-1,NodeCount=0
	F  s NodeID=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",ParentID,NodeID)) Q:NodeID=""  D
	.s NodeCount=NodeCount+1
	.s RelType=$p(^DHCCKBRULENODE(NodeID),"^",2)   	// 关系类型
	.i $d(^DHCCKBRD(0,"Node",NodeID))  d
	..s NodeRet=..GetGroupRuleRet(NodeID,RelType,RuleStyle,.TmpArr,.TmpMsgArr)
	..i NodeCount=1  d
	...s IsTrue=NodeRet
	..e  d		//多个子节点之间的值进行合并(如一组频率,一组途径)
	...s ParentRelType=$p(^DHCCKBRULENODE(ParentID),"^",2)
	...//s IsTrue=$Select(ParentRelType="and":IsTrue&NodeRet,ParentRelType="or":IsTrue!NodeRet)
	...s IsTrue=$Select((ParentRelType="and")||(ParentRelType="union"):IsTrue&NodeRet,ParentRelType="or":IsTrue!NodeRet)
	.e  s NodeRet=-1
	.// 计算子节点的值,将子节点和本身的值通过关系结合
	.q:'$d(^DHCCKBRULENODE(0,"Parent",RulID,"if",NodeID))	// 没有子节点
	.s SubRet=..InvRuleData(NodeID,.TmpArr,.TmpMsgArr,RuleStyle)
	.i (NodeRet=-1)&(SubRet=-1) s IsTrue=-1
	.i (NodeRet=-1)&(SubRet'=-1) s IsTrue=SubRet
	.i (NodeRet'=-1)&(SubRet=-1) s IsTrue=IsTrue
	.//i (NodeRet'=-1)&(SubRet'=-1) s IsTrue=$Select(RelType="and":IsTrue&SubRet,RelType="or":IsTrue!SubRet)
	.i (NodeRet'=-1)&(SubRet'=-1) s IsTrue=$Select((RelType="and")||(RelType="union"):IsTrue&SubRet,RelType="or":IsTrue!SubRet)
	i IsTrue=-1 s IsTrue=0
	q IsTrue
}

///  获取最小的一组规则分支的结果
ClassMethod GetGroupRuleRet(ParentID, ParRelType, RuleStyle, TmpArr, TmpMsgArr)
{
	n (ParentID,ParRelType,RuleStyle,TmpArr,TmpMsgArr)
	// 组规则
	s TipsPath=$g(TmpArr("TipsPath"))
	s Label=$g(TmpArr("Label"))
	s UserInfo=$g(TmpArr("UserInfo"))
	s RulID=$g(TmpArr("RulID"))
	s RuleStype=$g(TmpArr("RuleStype",RulID))
	s ID="", IsTrue=-1,Count=0
	F  s ID=$o(^DHCCKBRD(0,"Node",ParentID,ID)) Q:ID=""  D
	.s TmpArr("ID")=ID
	.s LeftID=$p(^DHCCKBRD(ID),"^",3)    /// 关系指针(左)
	.s AccFlag = TmpArr("AccFlag") 
	.q:(RuleStype'="C")&(..CheckLabelItmAcc(Label,LeftID,UserInfo,AccFlag)<=0)
	.s Ret=..isCorrect(.TmpArr, .TmpMsgArr)	// 1 满足(不提醒) 0 不满足(提醒)  -1 没有值的情况 -100 忽略
	.b:ID="4776217"   ;222
	.i (Ret=-100)&&$d(TmpArr("ignoreItm",RulID)) s TmpArr("RuleID",RulID)=1	// 标记-100的规则序号,需要忽略掉整条规则 2020/10/12
	.q:Ret=-100
	.i ($p($g(^DHCCKBCD(+Label)),"^",3)=##class(web.DHCCKBCommon).GetGlobalData())&(Ret=-1) s TmpArr("RuleID",RulID)=1	// 全局规则暂时先认为-1是忽略整条规则状态
	.q:($p($g(^DHCCKBCD(+Label)),"^",3)=##class(web.DHCCKBCommon).GetGlobalData())&(Ret=-1)
	.// 字典规则也需要认为-1 是忽略整条规则 2022-03-24
	.s ruleDic = $o(^DHCCKBRULEDIC(0,"RuleDic",RulID,""))
	.s dicFlag = ""
	.i ruleDic'="" d	
	..s AddRuleFlag = ##class(web.DHCCKBCommon).GetDicIdByCode("AddRuleFlag")
	..s attrDr = $o(^DHCCKBDLA(0,"DicAttr",+ruleDic,+AddRuleFlag,""))
	..s attrValue = $p($g(^DHCCKBCD(+attrDr)),"^",2)
	..i attrValue="Y"  s dicFlag = "Y"
	.i (Ret=-1)&(dicFlag="Y")  s TmpArr("RuleID",RulID)=1	
	.q:(Ret=-1)&(dicFlag="Y") 
	.s CondFlag=##Class(web.DHCCKBPassExt).IsPreConditions(LeftID,RulID)	// 判断是前提条件
	.s:(CondFlag=1)&(Ret=-1) Ret=0	// -1 认为不通过(在his入参没有值的时候，需要忽略该分支,但该分支是前提条件的情况下,又要认为是不通过)
	.b:ID="4776217"   ;Ruslt22
	.q:(CondFlag=0)&(Ret=-1)	//Ret=1
	.//i Ret=-1 s Ret=0						
	.//q:Ret=-1
	.s Count=Count+1
	.i Count=1	d
	..s IsTrue=Ret
	.e   d	
	..//s IsTrue=$Select(ParRelType="and":IsTrue&Ret,ParRelType="or":IsTrue!Ret)
	..s IsTrue=$Select((ParRelType="and")||(ParRelType="union"):IsTrue&Ret,ParRelType="or":IsTrue!Ret)

	d ..KillNodeMsgStrNew(IsTrue,ParentID,.TmpArr,.TmpMsgArr)

	q IsTrue
}

///  Descript:  准备输出数据
///  Other: 输出信息组成：程序拼写提示(错误+正确用法)+错误提醒+进一步说明
///  w ##Class(web.DHCCKBPassNew).ReaOutData("984","1",.TmpMsgArr)
ClassMethod ReaOutData(isFailFlag As %String, TmpArr, TmpMsgArr) As %String
{
	n (isFailFlag,TmpArr, TmpMsgArr)
	
	s LabelDesc=TmpArr("LabelDesc")
	s CheckDicID=TmpArr("CheckDicID")
	s TipsPath=TmpArr("TipsPath")	// 正反向
	s RulID=TmpArr("RulID")

	q:(isFailFlag=1) ""
	s OutType=$select(TipsPath=1:"then",TipsPath=0:"else")	

	s RetList=""
	s ParID=""
	F  s ParID=$o(^DHCCKBRULENODE(0,"Parent",RulID,OutType,0,ParID)) Q:ParID=""  D
	.s ID="", isTrueNum=0, isTrue=0
	.F  s ID=$o(^DHCCKBRD(0,"Node",ParID,ID)) Q:ID=""  D
	..s varCode="",varText=""
	..s LkLDicID=$p(^DHCCKBRD(ID),"^",3)
	..i +LkLDicID'=0 s varCode=$p($g(^DHCCKBCD(LkLDicID)),"^",1)   /// 实体代码
	..s LkRDicID=$p(^DHCCKBRD(ID),"^",7)
	..i +LkRDicID'=0 s varText=$p($g(^DHCCKBCD(LkRDicID)),"^",1)   /// 实体代码
	..E  s varText=$p(^DHCCKBRD(ID),"^",8)
	../// 通过标识
	..i varCode="PassFlag" D
	...s $list(RetList,2)=varText
	...//s $p(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID),"^",1)=varText
	../// 管理级别
	..i varCode="LevelFlag" D	
	...s $list(RetList,3)=varText		
	...//s $p(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID),"^",2)=varText
	../// 提示信息
	..i varCode="WarnMessage" D
	...s $list(RetList,4)=varText
	...//s $p(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID),"^",3)=varText
	../// 管制力度
	..i varCode="ControlLevel" D
	...s $list(RetList,5)=varText
	../// 提示依据
	..i varCode="SourceMsg" D
	...s $list(RetList,6)=varText
	../// 消息提醒标记(Y,则使用维护的消息,没有根据前提条件合并,使用合并消息)
	..i varCode="OutMsgTipsFlag" D
	...s $list(RetList,8)=varText
	..
	
	s $list(RetList,7)="警示信息"	// 警示信息
	s $list(RetList,1)=isFailFlag	// 实际是否通过

	// 必填项没有值时,先默认为最低级别的值
	i $listget(RetList,2)="" s $list(RetList,2)=$case(isFailFlag=1,1:"HasPass",:"NotPass")
	i $listget(RetList,3)="" s $list(RetList,3)="tips"
	i $listget(RetList,8)="" s $list(RetList,8)="N"	
	s $list(RetList,9)= $listget(RetList,3)	// 第三个位置的级别会变动,增加一个位置记录管理级别 2022-04-29
	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记","管理级别(未修改前)")		
	
	// 计算项目的级别   2022-03-28 qnp
	k ItmLevelArr
	s LabelId=$g(TmpArr("Label"))
	s MarkIDList=""
	k MarkIDLevelArr  // 分支级别
	s ID =""
	f  s ID = $o(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID))  q:ID=""  d
	.s CalcItmID=$p(^DHCCKBRD(ID),"^",3) // 计算项目
	.//i (+ID'=0)&&($lf(MarkIDList,ID)=0) s $list(MarkIDList,*+1) = ID	// 记录规则下所有的分支id,用于确定规则的优先级 --只要分支维护了优先级,则以分支的最高优先级为主 qnp 2022-04-25
	.s IDLevelStr =  ##class(web.DHCCKBPassOutPut).GetRuleDataLevelStr(ID,LabelId,.TmpArr)	// 分支级别->项目级别
	.s IDLevelNum=""
	.i IDLevelStr="" d 
	..s IDLevelNum = ##class(web.DHCCKBCommon).GetManLevelNum($lg(RetList,3)) 
	.e  d
	..s IDLevelNum = $p(IDLevelStr,"^",3)
	.s MarkIDLevelArr(+IDLevelNum)=##class(web.DHCCKBCommon).GetManLevelCodeByNum(IDLevelNum)	// 处理之后的规则级别: 分支级别->项目级别->规则级别
	
	// 处理之后的规则级别: 分支级别->项目级别->规则级别(级别最高)	
	s IDLevelNum = $o(MarkIDLevelArr(""),-1)
	i IDLevelNum'="" d
	.s IDLevel = $g(MarkIDLevelArr(IDLevelNum))
	.s $list(RetList,3)=IDLevel 

	i $d(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID))  d
	.s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID)=RetList
	
	
	Q ""
}

///  Descript:  将文字描述转换成具体的运算符
/// ##class(web.DHCCKBPassNew).isCorrect()
ClassMethod TrsOpArith(OpArith As %String) As %String
{
	n (OpArith)
	/// 运算符号转换
	s OpArith=$s(OpArith="Equals":"=",OpArith="GreaterThen":">",OpArith="LessThen":"<",OpArith="LessThenEquals":"<=",OpArith="GreaterThenEquals":">=",OpArith="Between":"L",OpArith="NotEquals":"'=",1:"")
	Q OpArith
}

/// 验证条件 统一模式
ClassMethod isCorrect(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr,TmpMsgArr)
	
	s RuleUsageId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")	// 用法用量目录id
	s ID=$g(TmpArr("ID"))				// 规则明细id
	s CheckDicID=TmpArr("CheckDicID")	// 审查项目(药品)	
	s RulID=TmpArr("RulID")				// 规则序号	
	s TipsPath=TmpArr("TipsPath")		// 计算方向
	s LabelId = $g(TmpArr("Label"))
	s CalcItmID=$p(^DHCCKBRD(ID),"^",3) // 计算项目
	s CalcItm=$p($g(^DHCCKBCD(+CalcItmID)),"^",1) 	
	q:CalcItm="" -1
	s CalcItm=..ChangeClacIem(CalcItm)
	//过滤药品类型不符合属性的值的情况-中成药 shy 2022-5-25
	s ChinDic=##class(web.DHCCKBCommon).GetChineseDrugData()
	s ChinProp=##class(web.DHCCKBCommon).GetChineseDrugProp()
	q:($p(^DHCCKBCD(+CalcItmID),"^",3)=ChinProp)&&($p(^DHCCKBCD(+CheckDicID),"^",3)'=ChinDic) -100
	s isIgnoreFlag = ##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,+CheckDicID,CalcItmID,"I")
	s:isIgnoreFlag=1 TmpArr("ignoreItm",RulID)=""
	q:1=isIgnoreFlag -100 // qnp 2020/1/14 判断目录是否有忽略配置
	q:(ID="")||(CheckDicID="")||(CalcItmID="")||(RulID="") 0	
	s LabelDesc=..GetRuleLabelDesc(RulID)  	// 目录
	q:(LabelDesc="液体配置")&&(CalcItm="Ingredient") -100 // 液体配置中的成分不用计算 qnp 2022-4-15
	q:-100=##Class(web.DHCCKBPassExt).QuitNotCalcItm(CalcItm,ID) -100	//过滤不计算的项目
	q:(LabelDesc="用法")&&($d(TmpArr("MustItemList",CheckDicID,CalcItm,RuleUsageId))) -100 // 2022-3-28 必须计算的项目 已经计算过,则不重复计算(一条规则中一个计算项目,多个分支，需要计算)
	/// 暂时用来处理不能走统一模式的项目	
	s IsModelFlag=##class(web.DHCCKBCommon).IsComModelFlag(CalcItm)	
	q:IsModelFlag=0 ..CheckUnModelItem(RulID,ID,CalcItm,.TmpArr,.TmpMsgArr)
	/// 调用公式计算
	i ..IsRequired(CalcItm)=0	d	// 根据必填配置,0表示从知识库取值
	.d ##Class(web.DHCCKBPassExt).InitValueComplex(.TmpArr,CalcItm,ID)
	.//d ..SetValueForDic(.TmpArr,CalcItm,RulID,ID)
	/// 统一模式计算	
	s RightType=$p(^DHCCKBRD(ID),"^",9)	
	s LibValue=..GetSysValue(ID,.TmpArr)	// 取出知识库规则值
	q:((RightType="InputLimit")||(RightType="InputUom"))&(LibValue="") -1
	q:(LibValue="")||($case($listvalid(LibValue)=0,1:"",:$listget(LibValue))="") -1	 // 取不到值或者转换失败的情况下,忽略这条规则	
	//q:LibValue="" 0	
	//q:(RightType="Constant")&("N"=##class(web.DHCCKBCommon).IsAudit($listget(LibValue))) -100  // 2020/07/17 忽略不审查的字典
	//q:("N"=##class(web.DHCCKBCommon).IsAudit($listget(LibValue))) -100 // 用于频率不选字典的情况，可能存在录入的数值正好是一个id的情况
	s IgnoreRule=0
	i (RightType="Constant")&("N"=##class(web.DHCCKBCommon).IsAudit($listget(LibValue))) s IgnoreRule=1
	//i ("N"=##class(web.DHCCKBCommon).IsAudit($listget(LibValue))) s IgnoreRule=1
	i IgnoreRule=1 s TmpArr("RuleID",RulID)=1
	q:IgnoreRule=1 -100
	s LibValueExt=..GetSysValueExt(ID)		// 知识库别名

	/// 取出his的值	
	s LeftKey=$case(+$d(TmpArr(CalcItm))>0,1:CalcItm,:CalcItm_$c(1)_CheckDicID)
	s HisValue=##Class(web.DHCCKBPassExt).GetHisValue(.TmpArr, LeftKey,LibValue)
	s:(HisValue=0)&(LeftKey'["TreatBettenDayNum") HisValue=""  // 疗程间隔存在0,暂时先不过滤疗程0 qnp 2020/12/17
	//q:(RightType="Constant")&("N"=##class(web.DHCCKBCommon).IsAudit($listget(HisValue))) -100  // 2020/07/17 忽略不审查的字典
	//q:("N"=##class(web.DHCCKBCommon).IsAudit($listget(HisValue))) -100  // 2020/07/17 忽略不审查的字典
	s IgnoreRule=0
	i (RightType="Constant")&("N"=##class(web.DHCCKBCommon).IsAudit($case($listvalid(HisValue),1:$lg(HisValue),:HisValue))) s IgnoreRule=1
	//i ("N"=##class(web.DHCCKBCommon).IsAudit($case($listvalid(HisValue),1:$lg(HisValue),:HisValue))) s IgnoreRule=1
	i IgnoreRule=1 s TmpArr("RuleID",RulID)=1
	q:IgnoreRule=1 -100
	s HisValueExt=$g(TmpArr(LeftKey,"Ext"))
	q:((RightType="InputLimit")||(RightType="InputUom"))&(HisValue="") -1 // his值为空,忽略存在问题(如:特殊人群为空,但是要根据年龄判断)-修复:系统值没有子规则的情况下，在退出(2020/12/1)	
	
	s Value=$p(^DHCCKBRD(ID),"^",7)	
	s IsChildFlag=(Value'="")&&(Value'=+CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",Value)))
	q:(HisValue="")&($case($listvalid(HisValueExt),1:$lts(HisValueExt),:HisValueExt)="")&(IsChildFlag=0) -1 // 取不到值或者转换失败的情况下,忽略这条规则
	/// 计算
	s OpArith=$p($g(^DHCCKBRD(+ID)),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   		// 运算符 
	s Ret=..Compare(HisValue,HisValueExt,LibValue,LibValueExt,OpArith,RightType,.TmpArr)
	
	// 记录必须审查的项目是否审查 2022-03-28	
	//s MustItemList = ##Class(web.DHCCKBCommonUtil).MustCheckItemList()	
	s DoseList = $lb("DayDose","DayDoseMax","DayDoseLimit","OnceDose","OnceDoseMax","OnceDoseLimit","DrugFreq")
	//i $lf(DoseList,CalcItm)&(LabelDesc="用法")  d
	i $lf(DoseList,CalcItm)  d
	.s TmpArr("MustItemList",CheckDicID,CalcItm,LabelId)=""
	
	/// 子规则
	s ChildRule=-1
	//s Value=$p(^DHCCKBRD(ID),"^",7)	// 子规则中若在引用本身或其他子规则,容易会出现死循环
	//s IsChildFlag=(Value'="")&&(Value'=+CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",Value))) 
	// 若表达式的符号是等号,且表达式成立1,则结果以表达式为主.  若表达式不成立,则结果以子规则为主
	
	i (OpArith="=")&(Ret'=1) d
	.i IsChildFlag d
	..s TmpRet=..CheckChildRule(Value,.TmpArr, .TmpMsgArr)
	..i TmpRet=-1 s TmpRet=0 
	..s ChildRule=TmpRet
	..s TmpArr("RulID")=RulID
	..s Ret=ChildRule

	// 若表达式的符号是不等于,且表达式成立1,则结果以以子规则取反为主,其他的表达式为主.
	i (OpArith="'=")&(Ret'=0) d
	.i IsChildFlag d
	..s TmpRet=..CheckChildRule(Value,.TmpArr, .TmpMsgArr)
	..i TmpRet=-1 s TmpRet=0 
	..s ChildRule=TmpRet
	..s TmpArr("RulID")=RulID
	..s Ret='ChildRule
	
	d SetMsg

	q Ret

SetMsg
	
	// 记录返回值
	//s LabelDesc=..GetRuleLabelDesc(RulID)  	// 目录
	s RulID=$g(TmpArr("RulID")) 			// 规则组号
	i $g(TmpArr("RuleStype",RulID))="G" d
	.i ((TipsPath=1)&(Ret=1))||((TipsPath=0)&(Ret=0)) d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=LeftKey
	
	
	q ""
}

/// 规则计算
/// 返回值 1:等式成立 0:等式不成立 空：等式不存在
/// w ##class(web.DHCCKBPassNew).Compare($lb("3","49881","次/日"),$lb("次/日"),$lb("3-4",,"49881"),$lb("次/日"),"L","InputUom")
ClassMethod Compare(HisValue, HisValueExt, LibValue, LibValueExt, OpArith, RightType, TmpArr = "")
{
	n (HisValue,HisValueExt,LibValue,LibValueExt,OpArith,RightType,TmpArr)

	s Ret=-1
	s CalcItm="",LabelDesc=""
	i $d(TmpArr) d
	.s LabelDesc = $g(TmpArr("LabelDesc")) 	// 目录	
	.s ID=$g(TmpArr("ID"))				// 规则明细id	
	.q:ID=""
	.s CalcItmID=$p($g(^DHCCKBRD(+ID)),"^",3) // 计算项目
	.s CalcItm=$p($g(^DHCCKBCD(+CalcItmID)),"^",1)  	
	.s CalcItm=..ChangeClacIem(CalcItm)

	s ExitFlag = 0
	if (CalcItm="Disease") d
	.s ExitFlag = 1
	.if (LabelDesc["禁忌")  d // 禁忌症 模糊匹配（his包含系统）并且不使用映射关系
	..s Ret = ##class(web.DHCCKBPassExt).CheckContrainDications(HisValueExt,LibValueExt)
	..i Ret=1 d
	...d ##Class(web.DHCCKBCommonUtil).CompareBothListToArr(HisValueExt,LibValueExt,.TmpArr)   //xww 2021-10-28 存储相匹配的疾病
	..s:OpArith="'=" Ret='Ret
	.else  d //适应症,用法用量 采用双向模糊匹配（his包含系统，系统包含his）
	..s Ret = ##class(web.DHCCKBPassExt).CheckIndications(HisValue,HisValueExt,LibValue,LibValueExt)
	..s:OpArith="'=" Ret='Ret
	
	q:ExitFlag=1 Ret
	
	if (RightType="Constant")  d	// 数据集
	.s Ret=..CompareConstant(HisValue,HisValueExt,LibValue,LibValueExt)
	.s:OpArith="'=" Ret='Ret		// != 需要反向	
	
	else  if RightType="Input"	d 	// 输入值	
	.s Ret=-1	// 维护规则是应该不存在手工录入的值。因此不考虑这种形式。 主要是为了避免录入的值是字符串，无法运算导致报错 2020/11/9 qnp
	.i OpArith="L" s Ret=0
	.E  d
	..s HisValue=$case($listvalid(HisValue),1:$listtostring(HisValue),0:HisValue)
	..s:HisValue="" Ret=0
	..q:$g(Ret)=0
	..s runStr="s Ret="_""""_HisValue_""""_OpArith_""""_$list(LibValue,1)_"""" x runStr
	
	else  if RightType="InputUom" d // 带单位的输入值 
	.s newHisValue=$listGet(HisValue,1)
	.s newHisValue=$case($listvalid(newHisValue),1:$listtostring(newHisValue),0:newHisValue)
	.s HisUom=$listget(HisValue,2)
	.s HisUomExt=$listget(HisValue,3)
	.s:+newHisValue=0 Ret=0
	.s:(HisUom="")&(HisUomExt="") Ret=0
	.q:$g(Ret)=0
	.s newLibValue=$listget(LibValue,1)
	.s:newLibValue="" Ret=0
	.s LibUom=$listGet(LibValue,3)
	.s:LibUom="" Ret=0
	.q:$g(Ret)=0
	.i OpArith="L" s Ret=0
	.E  s runStr="s Ret="_""""_newHisValue_""""_OpArith_""""_newLibValue_"""" x runStr
	
	else  if RightType="InputLimit"	d // 区间,带单位
	.s newHisValue=$listget(HisValue,1)
	.s newHisValue=$case($listvalid(newHisValue),1:$listtostring(newHisValue),0:newHisValue)
	.s HisUom=$listGet(HisValue,2)
	.s HisUomExt=$listGet(HisValue,3)
	.s:+newHisValue=0 Ret=0
	.s:(HisUom="")&(HisUomExt="") Ret=0
	.q:$g(Ret)=0
	.s newLibValue=$listGet(LibValue,1)
	.s LibValueMax=$listGet(LibValue,2)
	.s LibUom=$listGet(LibValue,3)
	.s:LibUom="" Ret=0
	.q:$g(Ret)=0
	.//if (CalcItm="SolutionVolume")||(CalcItm="SolutionDensity")||(CalcItm="Solventvolume")||(CalcItm="SolventDensity") d 	// 溶液体积,溶液浓度,溶媒体积,溶媒浓度,按照实际计算
	.//.i OpArith="L" s Ret=(newHisValue>=newLibValue)&(newHisValue<=LibValueMax)
	.//.E  s runStr="s Ret="_newHisValue_OpArith_newLibValue x runStr
	.//e  d
	.//.i OpArith="L" s Ret=newHisValue<=LibValueMax	// 2020-11-03 范围值之判断上限
	.//.E  s runStr="s Ret="_newHisValue_OpArith_newLibValue x runStr
	.// 除了日剂量、日最大量、日极量、次剂量、次最大量、次极量 范围值判断上限,其他项目按照实际判断 2022-03-31
	.//s DoseList = $lb("DayDose","DayDoseMax","DayDoseLimit","OnceDose","OnceDoseMax","OnceDoseLimit")
	.//i $lf(DoseList,CalcItm)'=0 d
	.//.i OpArith="L" s Ret=newHisValue<=LibValueMax	// 2020-11-03 范围值之判断上限
	.//.E  s runStr="s Ret="_""""_newHisValue_""""_OpArith_""""_newLibValue_"""" x runStr
	.//e  d
	.i OpArith="L" d
	..i (LabelDesc["用法用量")&&((CalcItm="OnceDose")||(CalcItm="DayDose")) d	// 单次用药量和每日用药量,低于下限时设置为提醒级别
	...s Low = (newHisValue<newLibValue)	// 小于下限
	...s High = (newHisValue>LibValueMax)	// 大于上限
	...i (Low=1) d
	....s TmpArr("SetLevel",ID) = ##class(web.DHCCKBCommon).GetDicIdByCode("tips")
	..i (LabelDesc["液体配置")&&(CalcItm="SolutionDensity") d	// 静脉、鞘内、硬膜外 溶液浓度超过规定浓度范围的上限或特定浓度值设为禁止级别；其他用法警示级别
	...b ;shy
	...s Low = (newHisValue<newLibValue)	// 小于下限
	...s High = (newHisValue>LibValueMax)	// 大于上限
	...i (Low||High)  d
	....s ThisCheckItmID=TmpArr("CheckDicID")
	....i (($lg(TmpArr("DrugPreMet"_$c(1)_ThisCheckItmID))["静脉")||($lg(TmpArr("DrugPreMet"_$c(1)_ThisCheckItmID))["鞘内")||($lg(TmpArr("DrugPreMet"_$c(1)_ThisCheckItmID))["硬膜外"))  d
	.....s TmpArr("SetLevel",ID) = ##class(web.DHCCKBCommon).GetDicIdByCode("forbid") 
	....e  d
	.....s TmpArr("SetLevel",ID) = ##class(web.DHCCKBCommon).GetDicIdByCode("warn") 
	..i (LabelDesc["液体配置")&&(CalcItm="SolutionVolume") d	// 溶液体积不当（低于下限）设置为禁止级别 
	...s Low = (newHisValue<newLibValue)	// 小于下限
	...s High = (newHisValue>LibValueMax)	// 大于上限
	...i (Low=1) d
	....s TmpArr("SetLevel",ID) = ##class(web.DHCCKBCommon).GetDicIdByCode("forbid") 
	...
	...s Ret = '(Low||High)
	..e  d
	...s Ret=(newHisValue>=newLibValue)&(newHisValue<=LibValueMax)
	.E  s runStr="s Ret="_""""_newHisValue_""""_OpArith_""""_newLibValue_"""" x runStr
	q $g(Ret)
}

/// 或者规则明细中的业务值 
/// 字典数据：返回list(包含本身和别名)
/// 范围数据：返回上限,下限，单位(单位含本身和别名)
/// 返回值:list(值,上限值,单位) 
/// w ##Class(web.DHCCKBPassNew).GetSysValue("464724","")
ClassMethod GetSysValue(ID, TmpArr)
{
	n (ID,TmpArr)
	q:ID="" ""
	s RightType=$p(^DHCCKBRD(ID),"^",9)
	s LeftDic=$p($g(^DHCCKBRD(ID)),"^",3)	// 分类需要获取分类的下级(后期加配置2020-03-19)
	s DrugCatProp=##class(web.DHCCKBCommon).GetPhCategory()

	s RetStr=""
	if RightType="Constant"		d 	// 数据集	 
	.s Value=$p(^DHCCKBRD(ID),"^",7)
	.q:Value=""
	.s $list(RetStr,1)=Value
	.if LeftDic=DrugCatProp d	
	..s ListCat=""
	..d ##Class(web.DHCCKBCommon).GetChildCat(.ListCat, Value,1)
	..s TmpStr=##Class(web.DHCCKBCommonUtil).GetUnionList(RetStr,ListCat)	// 获取两个分类的并集
	..s LinkCat=""
	..d ##Class(web.DHCCKBCommon).GetLinkCat(.LinkCat,Value,1)
	..s TmpStr=##Class(web.DHCCKBCommonUtil).GetUnionList(TmpStr,LinkCat)	// 获取两个分类的并集
	..k RetStr
	..s RetStr=TmpStr
	
	else  if RightType="Input"	d 	// 输入值	
	.s Value=$p(^DHCCKBRD(ID),"^",8)
	.s $list(RetStr,1)=Value 
	else  if RightType="InputUom" d // 带单位的输入值 
	.s Value=$p(^DHCCKBRD(ID),"^",8)
	.s ValueUom=$p(^DHCCKBRD(ID),"^",12)
	.s ValueUomCode=$case(ValueUom'="",1:$p($g(^DHCCKBCD(ValueUom)),"^",1),:"")
	.//s Fac=..ChangeQtyFacByUnit(ValueUomCode,.TmpArr)
	.s Fac=##Class(web.DHCCKBComplexArith).CalcExpression(ValueUomCode,.TmpArr)
	.i +Fac'=0 d //i Fac'=-1 	d  // 经过转换
	..s NewValueUom=$p(ValueUomCode,"/",1)
	..s NewValueUom=..GetComDicIdNew(NewValueUom,"")
	..s $list(RetStr,3)=NewValueUom
	..s $list(RetStr,1)=$case(+Fac'=0,1:Value*Fac,:"")
	.e  d			// 不需要转换
	..s $list(RetStr,3)=ValueUom
	..s $list(RetStr,1)=Value
	else  if RightType="InputLimit"	d // 区间,带单位
	.s Value=$p(^DHCCKBRD(ID),"^",8)
	.s ValueMax=$p(^DHCCKBRD(ID),"^",13)
	.s ValueUom=$p(^DHCCKBRD(ID),"^",12)
	.s ValueUomCode=$case(ValueUom'="",1:$p($g(^DHCCKBCD(ValueUom)),"^",1),:"")
	.s Fac=##Class(web.DHCCKBComplexArith).CalcExpression(ValueUomCode,.TmpArr)
	.i +Fac'=0 d //i Fac'=-1 	d  // 经过转换
	..s NewValueUom=$p(ValueUomCode,"/",1)
	..s NewValueUom=..GetComDicIdNew(NewValueUom,"")
	..s $list(RetStr,3)=NewValueUom
	..s $list(RetStr,1)=$case(+Fac'=0,1:Value*Fac,:"")
	..s $list(RetStr,2)=$case(+Fac'=0,1:ValueMax*Fac,:"") 
	.e  d			// 不需要转换
	..s $list(RetStr,3)=ValueUom
	..s $list(RetStr,1)=Value
	..s $list(RetStr,2)=ValueMax
	.	
	q RetStr
}

/// 或者规则明细中的业务值的别名描述
/// 返回值:list
ClassMethod GetSysValueExt(ID)
{
	n (ID)
	s RightType=$p(^DHCCKBRD(ID),"^",9)
	s LeftDic=$p($g(^DHCCKBRD(ID)),"^",3)
	s DrugCatProp=##class(web.DHCCKBCommon).GetPhCategory()

	s RetStr=""
	if RightType="Constant"		d 	// 数据集	 
	.s Value=$p(^DHCCKBRD(ID),"^",7)
	.q:Value=""
	.s RetStr=##class(web.DHCCKBCommon).GetDicSecondName(Value)
	.i $listvalid(RetStr)>0 d
	..i $d(^DHCCKBCD(Value)) s $list(RetStr,*+1)=$p($g(^DHCCKBCD(Value)),"^",2)
	.
	.if LeftDic=DrugCatProp d	
	..s ListCat=""
	..d ##Class(web.DHCCKBCommon).GetChildCat(.ListCat, Value,0)
	..s tmpStr=##Class(web.DHCCKBCommonUtil).GetUnionList(RetStr,ListCat)	// 获取两个分类的并集
	..k RetStr
	..s RetStr=tmpStr 
	
	else  if RightType="InputUom" d // 带单位的输入值    
	.s ValueUom=$p(^DHCCKBRD(ID),"^",12)
	.q:ValueUom="" 
	.s RetStr=##class(web.DHCCKBCommon).GetDicSecondName(ValueUom)
	.i $listvalid(RetStr)>0 d
	..i $d(^DHCCKBCD(ValueUom)) s $list(RetStr,*+1)=$p($g(^DHCCKBCD(ValueUom)),"^",2)
	else  if RightType="InputLimit"	d // 区间,带单位
	.s ValueUom=$p(^DHCCKBRD(ID),"^",12)
	.q:ValueUom=""
	.s RetStr=##class(web.DHCCKBCommon).GetDicSecondName(ValueUom)
	.i $listvalid(RetStr)>0 d
	..i $d(^DHCCKBCD(ValueUom)) s $list(RetStr,*+1)=$p($g(^DHCCKBCD(ValueUom)),"^",2)

	q RetStr
}

/// 字典比较 1匹配上 0 未匹配上
/// w
ClassMethod CompareConstant(HisValue, HisValueExt, LibValue, LibValueExt)
{
	n (HisValue,HisValueExt,LibValue,LibValueExt)
	// 如果不是list,转成list计算
	i $LISTVALID(HisValue)=0 s HisValue=$LISTFROMSTRING(HisValue)
	i $LISTVALID(HisValueExt)=0 s HisValueExt=$LISTFROMSTRING(HisValueExt)
	i $LISTVALID(LibValue)=0 s LibValue=$LISTFROMSTRING(LibValue)
	i $LISTVALID(LibValueExt)=0 s HisValueExt=$LISTFROMSTRING(LibValueExt)	
	
	i $listget(HisValue)'="" d
	.s Ret=##Class(web.DHCCKBCommonUtil).CompareBothList(HisValue,LibValue)
	.s OtherRet=##Class(web.DHCCKBCommonUtil).CompareBothList(HisValueExt,LibValueExt)	// his数据有对照,却是知识库规则数据的别名
	.s Ret=Ret||OtherRet
	e  s Ret=##Class(web.DHCCKBCommonUtil).CompareBothList(HisValueExt,LibValueExt)
	
	q Ret
}

/// Descript:	获取具体项目的值(合并一条规则下，多个分支中相同的项目)
ClassMethod GetItmMsg(ItmNodeList, TmpMsgArr, Item, Label, RuleID) As %String
{
	n (ItmNodeList,TmpMsgArr,Item,Label,RuleID)
	
	s ID=""
	f  s ID=$o(TmpMsgArr("itemOrder",Item,Label,RuleID,ID))	q:ID=""  d
	.s TmpKey=$g(TmpMsgArr("itemOrder",Item,Label,RuleID,ID))
	.s Key=$p(TmpKey,"^",1)
	.s Itm=$p(TmpKey,"^",2)	// 相互作用的药品
	.s Limit=""
	.i Itm="" d
	..i $d(^DHCCKBRD(ID)) s Limit=##class(web.DHCCKBCommon).GetRuleLimitContent(ID)	// 规则限定内容
	.e  d
	..s Limit=$case($listvalid(Itm),1:$listtostring(Itm),:Itm)
	.
	.q:Limit=""
	.s $list(ItmNodeList(Key),*+1)=Limit
		
	Q ""
}

/// Descript:	返回错误信息
ClassMethod TakErrMsg(ListData As %String) As %String
{
	n (ListData)
	w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrorCode^ErrorMessage",ListData)  
	Q ""
}

///  Descript:  通过规则组号ID,获取所属的药品/实例(即是哪个药品的规则)
///  Input:     规则组号id
///  Output:    药品/实例id
///  w ##Class(web.DHCCKBPassNew).GetDicByRuleID(2218)
ClassMethod GetDicByRuleID(RuleID As %String) As %String
{
	n (RuleID)
	
	q:RuleID="" ""
	
	s RetDicID=""
	s DicID=""
	f  s DicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,DicID))	  q:(DicID="")||(RetDicID'="")  d
	.s ParentID=$p(^DHCCKBCD(DicID),"^",3)
	.q:ParentID=""
	.q:ParentID'=##class(web.DHCCKBCommon).GetDrugData()
	.q:'$d(^DHCCKBRULEDIC(0,"RuleParentDic",RuleID,ParentID))
	.s RetDicID=DicID
	
	q RetDicID
}

/// Descript:	目录id
/// w ##Class(web.DHCCKBPassNew).GetRuleLabelID("64453")
ClassMethod GetRuleLabelID(RuleID As %String) As %String
{
	n (RuleID)
	
	q:RuleID="" ""
	
	s RetDicID="",LabelID=0
	s DicID=""
	f  s DicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,DicID))	  q:(DicID="")||(RetDicID'="")  d
	.s ParentID=$p(^DHCCKBCD(DicID),"^",3)
	.q:ParentID=""
	.q:(ParentID'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(ParentID'=##class(web.DHCCKBCommon).GetDrugEduProp())	
	.q:'$d(^DHCCKBRULEDIC(0,"RuleParentDic",RuleID,ParentID))
	.s RetDicID=DicID

	i RetDicID'="" s LabelID=RetDicID
	i LabelID=0  d
	.s LabelID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,""))
		
	q LabelID
}

/// Descript:	目录代码
/// w ##Class(web.DHCCKBPassNew).GetRuleLabelCode("1563")
ClassMethod GetRuleLabelCode(RuleID As %String) As %String
{
	n (RuleID)
	
	q:RuleID="" ""
	
	s RetDicID="",LabelCode=""
	s DicID=""
	f  s DicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,DicID))	  q:(DicID="")||(RetDicID'="")  d
	.s ParentID=$p(^DHCCKBCD(DicID),"^",3)
	.q:ParentID=""
	.//q:ParentID'=##class(web.DHCCKBCommon).GetDrugLibary()
	.q:(ParentID'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(ParentID'=##class(web.DHCCKBCommon).GetDrugEduProp())	
	.q:'$d(^DHCCKBRULEDIC(0,"RuleParentDic",RuleID,ParentID))
	.s RetDicID=DicID
	
	s LabelCode=""
	i RetDicID'="" s LabelCode=$p($g(^DHCCKBCD(RetDicID)),"^",1)
	i LabelCode=""  d
	.s RetDicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,""))
	.i RetDicID'="" s LabelCode=$p($g(^DHCCKBCD(RetDicID)),"^",1)
	
	q LabelCode
}

/// Descript:	目录描述
/// w ##Class(web.DHCCKBPassNew).GetRuleLabelDesc("183956")
ClassMethod GetRuleLabelDesc(RuleID As %String) As %String
{
	n (RuleID)
	
	q:RuleID="" ""
	
	s RetDicID=""
	s DicID=""
	f  s DicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,DicID))	  q:(DicID="")||(RetDicID'="")  d
	.s ParentID=$p(^DHCCKBCD(DicID),"^",3)
	.q:ParentID=""
	.q:(ParentID'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(ParentID'=##class(web.DHCCKBCommon).GetDrugEduProp())
	.q:'$d(^DHCCKBRULEDIC(0,"RuleParentDic",RuleID,ParentID))
	.s RetDicID=DicID
	
	s LabelDesc=""
	i RetDicID'="" s LabelDesc=$p($g(^DHCCKBCD(RetDicID)),"^",2)
	i LabelDesc=""  d
	.s RetDicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,""))
	.i RetDicID'="" s LabelDesc=$p($g(^DHCCKBCD(RetDicID)),"^",2)
	
	q LabelDesc
}

/// Descript:	根据目录，确定提示的正反向，如：用法用量是反向提示，不满足时提示， 禁忌症时正向向提示，满足时提示
/// Returnn:	0 反向 1 正向
/// w ##Class(web.DHCCKBPassNew).GetLabelTipsPath("87398")
ClassMethod GetLabelTipsPath(RulID) As %String
{
	n (RulID)

	s Ret= ..GetCalcPath(RulID)
	q Ret
	//s LabelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(RulID)
	//q $case((LabelDesc["注意事项")||(LabelDesc["不良反应")||(LabelDesc["禁忌")||(LabelDesc["配伍")||(LabelDesc["相互作用")||(LabelDesc["重复用药")||(LabelDesc["警告"),1:1,:0)
}

/// Descript:	根据目录的关系，清除具体项目的返回值信息
/// w ##Class(web.DHCCKBPassNew).GetRuleLabelDesc("1554")
ClassMethod KillNodeMsgStrNew(IsGrpTrue, NodeID, TmpArr, TmpMsgArr) As %String
{
	n (IsGrpTrue,NodeID,TmpArr,TmpMsgArr)
	
	s CheckDicID=TmpArr("CheckDicID") // 实体对象
	s RulID=TmpArr("RulID")
	q:RulID="" ""
	s LabelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(RulID)
	q:LabelDesc="" ""
	s TipsPath=..GetLabelTipsPath(RulID)			/// 提醒方向

	// 禁忌症: 需要清除是0的返回值   适应症：需要清除是1 的值
	i (TipsPath=0)&(IsGrpTrue=1) || ((TipsPath=1)&(IsGrpTrue=0)) d
	.s ID=""
	.f  s ID=$o(^DHCCKBRD(0,"Node",NodeID,ID)) Q:ID=""  D
	..k TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)
}

/// Descript:	根据前提条件的结果，清除具体项目的返回值信息
/// w ##Class(web.DHCCKBPassNew).GetRuleLabelDesc("1554")
ClassMethod KillRuleDataMsgStr(CheckDicID, RulID, RuleDataID, TmpMsgArr) As %String
{
	n (CheckDicID,RulID,RuleDataID,TmpMsgArr)
	
	s LabelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(RulID)
	//k TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,RuleDataID)
	k TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID)
}

/// 提醒规则  是否全部通过，才提醒(预留,从配置取)
/// 判断规则: 用法用量中，如果有多条，需要所有的规则通过。即有一条规则不通过，就需要弹窗提醒出该规则
/// 判断规则: 适应证中有多条规则，满足一条通过，即有一条规则匹配上，则不需要弹窗提醒。若没有一条满足的规则，则会对每条规则进行提醒
/// 判断规则: 禁忌证/相互作用/注意事项/配伍禁忌 中有多条规则，满足一条认为则为不通过，即有一条规则匹配上，则需要弹窗提醒。当所有的规则都不满足时，则不需要弹窗提
/// Return:		1 是 0 否
/// w ##class(web.DHCCKBPassNew).GetLabelRule("限定科室用药")
ClassMethod GetLabelRule(label)
{
	
	n (label)
	
	q $case((label["适应")||(label["液体配置"),1:0,:1) // 2022-04-07 增加溶媒
}

/// Input:	RuleType 区分普通规则("G" -general)和公共规则("C" -common)
ClassMethod CheckRule(ItmID, TmpArr, TmpMsgArr)
{
	
	n (ItmID,TmpArr,TmpMsgArr)
	s UserInfo=$g(TmpArr("UserInfo"))
	/**取成分对应的药品sufan**/
	/****s CheckItmID=ItmID***/
	i $d(TmpArr("IngreDrug"_$c(1)_ItmID))  d
	.s IngreDrug = $listtostring(TmpArr("IngreDrug"_$c(1)_ItmID))
	.i IngreDrug'="" s CheckItmID = IngreDrug
	.e  s CheckItmID = ItmID
	e  s CheckItmID = ItmID

	s ItmID=$p(ItmID,$c(2),1)
	s RuleType=$g(TmpArr("Action"))	
	s TmpArr("CalcItm")=CheckItmID

	K LabelArr
	s RulDicID=""
	F  s RulDicID=$o(^DHCCKBRULEDIC(0,"Dic",ItmID,RulDicID)) Q:RulDicID=""  D
	.s IsFailFlag=1	// 默认通过
	.s RulID=$p(^DHCCKBRULEDIC(RulDicID),"^",1) 	// 规则ID	
	.//q:RulID'=70432
	.Q:$p(^DHCCKBRULE(RulID),"^",3)'="Release"  	// 未发布不加算在内
	.q:..isChildRule(RulID)=1						// 审查项目本身有子规则,不审子规则
	.s TmpArr("RulID")=RulID 
	.s TmpArr("TipsPath")=..GetLabelTipsPath(RulID)	// 提醒方向
	.s TmpArr("CheckDicID")=CheckItmID
	.s TmpArr("RuleStype",RulID)="G"
	.s LabelDesc=..GetRuleLabelDesc(RulID)			// 审查目录
	.s LabelId=..GetRuleLabelID(RulID)
	.s LabelLinkDr=$p($g(^DHCCKBCD(+LabelId)),"^",4)
	.s LabRuleType=##class(web.DHCCKBCommon).GetRuleType(LabelId)	// 规则类型
	.s TmpArr("Label")=LabelId
	.s AccFlag = $g(TmpArr("AccFlag"))
	.//q:..CheckLabelAcc(LabelId,UserInfo)'=1			// 目录授权
	.q:..CheckLabelAcc(LabelId,UserInfo,AccFlag)<=0			// 目录授权
	.s TmpArr("LabelDesc")=LabelDesc
	.q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,ItmID,LabelId,"D") // qnp 2020/1/14 判断目录是否有忽略配置
	.s SkinProp= ##class(web.DHCCKBDrugVO).GetDicValueByPro(ItmID,##class(web.DHCCKBCommon).GetSkinTestDrugProp())
	.q:(LabelDesc="皮试用药")&((SkinProp'="Y")||($lg(TmpArr("DrugPreMet"_$c(1)_CheckItmID,"Ext"))'="皮试"))
	.q:((LabelDesc="用法用量")||(LabelDesc="用法"))&(SkinProp="Y")&($lg(TmpArr("DrugPreMet"_$c(1)_CheckItmID,"Ext"))="皮试")
	.q:LabelDesc="不良反应"							// 不良反应不判断，后期从目录授权中取配置
	.q:(LabelDesc="超说明书适应症")||(LabelDesc="功能主治")||(LabelDesc="用药指导")||(LabelDesc="适应性")
	.s ComDosageId=##class(web.DHCCKBCommon).GetComDosageProp()
	.q:((LabelId=ComDosageId)||(LabelLinkDr=ComDosageId))&($d(TmpMsgArr("itemOrder",CheckItmID,"用法用量")))	// 用法用量目录通过是用法目录的前提条件
	.s LabelRule=..GetLabelRule(LabelDesc)			// 目录的判断规则 
	.q:(LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	// 限定目录有一条通过则通过时，条件若满足，则不进行其他的判断
	.q:(LabRuleType'="")&(RuleType'=LabRuleType)	// 区分审查规则和教育规则
	.s NodeID=0
	.s IsPreCondFlag=..TakPreConditionsNew(NodeID,.TmpArr,.TmpMsgArr,"G")
	.s PreList=$g(TmpMsgArr("PreCondtions",RulID))
	.s PreList=$listtostring(PreList)
	.s CondFlag=$Case((PreList="")||(PreList="NULL"),1:0,:1)	// 1 有前提条件,0没有前提条件
	.q:(CondFlag=1)&(IsPreCondFlag=0) 
	.i CondFlag=0  s TmpMsgArr("PreCondtions",RulID)=$lb("NULL")	// 无前提
	.s TmpArr("RulID")=RulID 						// 判断条件时,若有引用规则，那么RulID会被改变，此时需要重新赋值
	.q:'$d(^DHCCKBRULENODE(0,"Parent",RulID,"if",NodeID))		// 无规则
	.s RuleFlag=..InvRuleData(NodeID,.TmpArr,.TmpMsgArr,"G")
	.s IgnoreRule=$g(TmpArr("RuleID",RulID))					// 规则中有忽略的，忽略整条规则 2020/10/12 
	.i IgnoreRule=1 d ..CleanIgnoreRuleMsg(.TmpArr,.TmpMsgArr)	// 清除规则的忽略信息
	.q:IgnoreRule=1
	.//q:RuleFlag=-1
	.i RuleFlag=-1 s RuleFlag=0
	.s RuleFlag=$case(TmpArr("TipsPath"),1:'RuleFlag,:RuleFlag)		// 根据计算方向 禁忌反向	
	.i RuleFlag=1 k TmpMsgArr("itemOrder",CheckItmID,LabelDesc,RulID)	// 规则通过，则清空规则的
	.s LabelArr(CheckItmID,LabelDesc,RuleFlag)=RuleFlag		
	.i (LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	d // 一条通过则通过, 清除掉目录的返回值
	..k TmpMsgArr("itemOrder",CheckItmID,LabelDesc)	
	.s IsFailFlag=RuleFlag
	.q:IsFailFlag=1
	.D ..ReaOutData(IsFailFlag, .TmpArr,.TmpMsgArr)	// 一组结果的输出
}

/// Input:	RuleType 区分普通规则("G" -general)和公共规则("C" -common)
ClassMethod CheckChildRule(ItmID, TmpArr, TmpMsgArr)
{

	n (ItmID,TmpArr, TmpMsgArr)
	
	s exitFlag=-1	// 默认没有通过
	s RulDicID=""
	F  s RulDicID=$o(^DHCCKBRULEDIC(0,"Dic",ItmID,RulDicID)) Q:(RulDicID="")  D
	.s RulID=$p(^DHCCKBRULEDIC(RulDicID),"^",1) /// 规则ID
	.Q:$p(^DHCCKBRULE(RulID),"^",3)'="Release"  /// 未发布不加算在内
	.s TmpArr("RuleStype",RulID)="C" 	
	.s TmpArr("RulID")=RulID 	
	.s NodeID=0
	.q:'$d(^DHCCKBRULENODE(0,"Parent",RulID,"if",NodeID))		// 无规则
	.s RuleFlag=..InvRuleData(NodeID,.TmpArr,.TmpMsgArr,"C")
	.s IgnoreRule=$g(TmpArr("RuleID",RulID))					// 子规则规则中有忽略的，忽略整条规则 2022-03-31
	.q:IgnoreRule=1 
	.//q:RuleFlag=-1	// 子规则是定义，没有计算方向
	.i RuleFlag=-1 s RuleFlag=0
	.s exitFlag=RuleFlag

	q exitFlag
}

/// Descript:判断规则是子规则还是项目的本身规则（因为没有办法区分子规则和项目本身的规则,使用是否有目录来区分）
/// 是子规则1  不是指规则0
/// w ##Class(web.DHCCKBPassNew).isChildRule(3537)
ClassMethod isChildRule(RulID) As %String
{
	n (RulID)
	//s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()	// 目录
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()	// 目录字典
	s IsExistLibary=$d(^DHCCKBRULEDIC(0,"RuleParentDic",RulID,DrugLibary)) // 0  1
	
	s GlobalData=##class(web.DHCCKBCommon).GetGlobalData()
	s IsExistGlobal=$d(^DHCCKBRULEDIC(0,"RuleParentDic",RulID,GlobalData)) // 0  1
	// 认为不含有目录,且不含有全局规则的规则为  子规则
	
	q IsExistLibary&IsExistGlobal
}

/// Descript:剂量转换系数(根据体重)
/// Input:	患者体重,规则中单位体重
/// w ##Class(web.DHCCKBPassNew).ChangeQtyFacByWeight(100,"kg")
ClassMethod ChangeQtyFacByWeight(PatWeiht, LibWeightUom) As %String
{
	n (PatWeiht,LibWeightUom)
	s hisWeightUom="kg"	//默认his中的体重单位是kg
	q:hisWeightUom=$zcvt(LibWeightUom,"L") PatWeiht
	
	s fac=""
	s fac=##class(web.DHCCKBCommonUtil).GetUomChangeFac(hisWeightUom,LibWeightUom)
	q:fac="" ""
	
	s fac=##class(web.DHCCKBCommonUtil).GetUomChangeFacNew(hisWeightUom,LibWeightUom)
	q:fac="" ""

	q fac*(+PatWeiht)
}

/// Descript:	审查全局的规则
/// Input:		审查对象
/// w ##class(web.DHCCKBPassNew).Label("")
/// w ##Class(web.DHCCKBPassNew).GetRuleLabelID("183956")
/// w ##class(web.DHCCKBPassNew).CheckLabelAcc(LabelId,UserInfo)<=0			// 目录授权
/// ..CheckGlobalAcc($g(TmpArr("UserInfo")))
ClassMethod CheckCommonRule(CheckItmID, TmpArr, TmpMsgArr) As %String
{
	n (CheckItmID,TmpArr,TmpMsgArr)
	
	s RuleType=$g(TmpArr("Action"))	
	s TmpArr("CalcItm")=CheckItmID
	q:RuleType'="CheckRule" ""
	// 遍历全局规则
	// 使用全局规则字典，遍历下面所有的字典列表，看字典列表是否有规则
	s GlobalData=##class(web.DHCCKBCommon).GetGlobalData()
	q:GlobalData="" ""
	s GlobalItmId=""
	f  s GlobalItmId=$o(^DHCCKBCD(0,"Parref",GlobalData,GlobalItmId))   q:GlobalItmId=""  d
	.s RulDicID=""
	.F  s RulDicID=$o(^DHCCKBRULEDIC(0,"Dic",GlobalItmId,RulDicID)) Q:RulDicID=""  D
	..s IsFailFlag=1	// 默认通过
	..s RulID=$p(^DHCCKBRULEDIC(RulDicID),"^",1) 	/// 规则ID
	..Q:$p(^DHCCKBRULE(RulID),"^",3)'="Release"  	/// 未发布不加算在内
	..q:..isChildRule(RulID)=1	// 审查项目本身有子规则,不审子规则
	..//q:RulID'="64642"
	..//q:$g(TmpArr("globalAcc"))<=0 	// 全局规则的权限
	..s TmpArr("RulID")=RulID 
	..k TmpArr("RuleID",RulID)
	..s TmpArr("TipsPath")=..GetLabelTipsPath(RulID)	/// 提醒方向
	..s TmpArr("CheckDicID")=CheckItmID
	..s TmpArr("RuleStype",RulID)="G"
	..s LabelDesc=..GetRuleLabelDesc(RulID)			// 审查目录
	..s TmpArr("LabelDesc")=LabelDesc
	..s LabelId=..GetRuleLabelID(RulID)
	..s TmpArr("Label")=LabelId
	..s AccFlag = $g(TmpArr("AccFlag"))
	..q:(..CheckLabelAcc(LabelId,$g(TmpArr("UserInfo")),AccFlag)<=0) // 目录授权  
	..s LabelRule=..GetLabelRule(LabelDesc)			// 目录的判断规则 
	..q:(LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	// 限定目录有一条通过则通过时，条件若满足，则不进行其他的判断
	..s NodeID=0
	..s IsPreCondFlag=..TakPreConditionsNew(NodeID,.TmpArr,.TmpMsgArr,"G")
	..s PreList=$g(TmpMsgArr("PreCondtions",RulID))
	..s PreList=$listtostring(PreList)
	..s CondFlag=$Case((PreList="")||(PreList="NULL"),1:0,:1)	// 1 有前提条件,0没有前提条件
	..q:(CondFlag=1)&(IsPreCondFlag=0) 
	..i CondFlag=0  s TmpMsgArr("PreCondtions",RulID)=$lb("NULL")	// 无前提
	..
	..s TmpArr("RulID")=RulID 	// 判断条件时,若有引用规则，那么RulID会被改变，此时需要重新赋值
	..s NodeID=0
	..q:'$d(^DHCCKBRULENODE(0,"Parent",RulID,"if",NodeID))		// 无规则
	..s RuleFlag=..InvRuleData(NodeID,.TmpArr,.TmpMsgArr,"G")
	..s IgnoreRule=$g(TmpArr("RuleID",RulID))	// 规则中有忽略的，忽略整条规则 2020/10/12 
	..s:RuleFlag=-1 IgnoreRule=1	// 全局规则在配置前提条件之前,先认为-1为忽略 2020/11/17
	..i IgnoreRule=1 d ..CleanIgnoreRuleMsg(.TmpArr,.TmpMsgArr)	// 清除规则的忽略信息
	..q:IgnoreRule=1
	..//i RuleFlag=-1 s RuleFlag=0
	..s RuleFlag=$case(TmpArr("TipsPath"),1:'RuleFlag,:RuleFlag)		// 根据计算方向 禁忌反向		
	..i RuleFlag=1 k TmpMsgArr("itemOrder",CheckItmID,LabelDesc,RulID)	// 规则通过，则清空规则的
	..s LabelArr(CheckItmID,LabelDesc,RuleFlag)=RuleFlag		
	..i (LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	d // 一条通过则通过, 清除掉目录的返回值
	...k TmpMsgArr("itemOrder",CheckItmID,LabelDesc)	
	..s IsFailFlag=RuleFlag
	..q:IsFailFlag=1
	..D ..ReaOutData(IsFailFlag, .TmpArr,.TmpMsgArr)	// 一组结果的输出
}

/// Descript:	计算方向：用法用量是反向提示，不满足时提示， 禁忌症时正向向提示，满足时提示
/// Return:	0 反向 1 正向
/// w ##Class(web.DHCCKBPassNew).GetCalcPath("81222")
ClassMethod GetCalcPath(RulID) As %String
{
	n (RulID)
	
	q:RulID="" ""
	// 思考：现在的全局规则和子规则维护时,没有目录,因此是将规则直接维护在字典身上
	//       后期如果定义目录模板，是否应该通过关联模板的方式去获取目录，从而在目录的属性中找判定方向
	
	s PathFlag=0  // 默认反向
	s CalcPath=##class(web.DHCCKBCommon).GetCalcPath()
	s RetDicID=""

	s ExistFlag=0
	s DicID=""
	f  s DicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RulID,DicID))	  q:(DicID="")||(ExistFlag=1)  d
	.//q:'$d(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,CalcPath))
	.s LinkDr=$p(^DHCCKBCD(DicID),"^",4)
	.i LinkDr'="" s Parref=$p(^DHCCKBCD(LinkDr),"^",3)
	.e  s Parref=$p(^DHCCKBCD(DicID),"^",3)	// 目录字典和全局变量字典
	.s Parref=..GetDrugLibaryParref(Parref)
	.s Prop=##class(web.DHCCKBCommon).GetProp()
	.q:(Parref'=Prop)&(Parref'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(Parref'=##class(web.DHCCKBCommon).GetGlobalData())  // &(Parref'=##class(web.DHCCKBCommon).GetDrugEduProp())
	.i $d(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,CalcPath)) d
	..s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,CalcPath,""),-1)
	..s CalcPathItm=$p($g(^DHCCKBDLA(+LinkID)),"^",3)
	..s CalcPathDesc=$p($g(^DHCCKBCD(+CalcPathItm)),"^",1)
	..s PathFlag=$select(CalcPathDesc="isFalse":0,CalcPathDesc="isTrue":1,1:PathFlag)
	..s ExistFlag=1
	.e  d
	..s TmpCalcPath=""	// 若是link类型的，属性的值是存在link的id上的
	..f  s TmpCalcPath=$o(^DHCCKBCD(0,"Link",CalcPath,TmpCalcPath))  q:(TmpCalcPath="")||(ExistFlag=1)  d
	...s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,TmpCalcPath,""),-1)
	...s CalcPathItm=$p($g(^DHCCKBDLA(+LinkID)),"^",3)
	...s CalcPathDesc=$p($g(^DHCCKBCD(+CalcPathItm)),"^",1)
	...s PathFlag=$select(CalcPathDesc="isFalse":0,CalcPathDesc="isTrue":1,1:PathFlag)
	...s ExistFlag=1

	q PathFlag
}

/// Descript:根据HIS数据取知识库对照数据（若无对照关系，返回知识库code）
/// Input:HIS描述 如医嘱，手术，特殊人群等
/// Output:知识库描述
/// w ##class(web.DHCCKBPassNew).GetKnowBaseCode("六神曲","105","")
ClassMethod GetKnowBaseCode(HisItmCode, sourceData = "", hospital = "")
{
	n (HisItmCode,sourceData,hospital)
	
	;q:+hospital=0 $lb(HisItmCode)
	s flag=1
	i +hospital'=0 d  //2022-03-02
	.s hospDesc = $p($g(^CT("HOSP",hospital)),"^",2)
	.i ##class(web.DHCCKBConfig).SysUser()[hospDesc s flag=0

	Q:flag=0 $lb(HisItmCode)  //若无对照关系，先返回code，以便在线演示方便(在线演示不走对照)
	s flag=0
	s flag=($d(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(HisItmCode))))||($d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(HisItmCode))))
	Q:flag=0 $lb(HisItmCode)  //若无对照关系，先返回code，以便在线演示方便(在线演示不走对照)

	s ClibIdList=""
	i $d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(HisItmCode))) d
	.s CLibId=""
	.f  s CLibId=$o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(HisItmCode),CLibId)) q:CLibId=""  d
	..q:$lf(ClibIdList,CLibId)'=0
	..s $list(ClibIdList,*+1)=CLibId
	
	i $d(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(HisItmCode))) d
	.s CLibId=""
	.f  s CLibId=$o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(HisItmCode),CLibId)) q:CLibId=""  d
	..q:$lf(ClibIdList,CLibId)'=0
	..s $list(ClibIdList,*+1)=CLibId	
	
	// 需要过滤数据源和医院
	//s LibType=$case(CLibId'="",1:$lg(^CKB.PDSS.ComContrastD(CLibId),6),:"")
	//s CLibHospId=$case(CLibId'="",1:$lg(^CKB.PDSS.ComContrastD(CLibId),7),:"")
	S LibCodeList=""
	f K=1:1:$listlength(ClibIdList)  d
	.s CLibId=$listget(ClibIdList,K)
	.q:+CLibId=0	
	.s ConData = $g(^CKB.PDSS.ComContrastD(CLibId))
	.s hospId = $lg(ConData,7)
	.q:(hospital'="")&(hospital'=hospId)
	.s type = $lg(ConData,6) 
	.q:(+sourceData'=0)&&(+sourceData'=(+type))
	.s LibCode = $lg(ConData,2) 	//Code
	.q:LibCode="" 
	.q:$lf(LibCodeList,LibCode)'=0
	.s $list(LibCodeList,*+1)=LibCode

	Q LibCodeList
}

ClassMethod ChangeKey(objstr)
{

	n (objstr)
	
	s objstr=$REPLACE(objstr,"PatSex","SexProp")
	s objstr=$REPLACE(objstr,"PatBDay","AgeProp")
	s objstr=$REPLACE(objstr,"SpecGrps","SpecialPop")
	s objstr=$REPLACE(objstr,"ProFess","ProfessProp")
	s objstr=$REPLACE(objstr,"itemAyg","HisAllergy")
	s objstr=$REPLACE(objstr,"ItemAyg","HisAllergy")			//sufan 2020-09-09
	s objstr=$REPLACE(objstr,"itemDis","Disease")
	s objstr=$REPLACE(objstr,"ItemDis","Disease")						//sufan 2020-09-09
	s objstr=$REPLACE(objstr,"ProFess","ProfessProp")
	s objstr=$REPLACE(objstr,"itemOrder","Drug")
	s objstr=$REPLACE(objstr,"ItemOrder","Drug")							//sufan 2020-09-09
	s objstr=$REPLACE(objstr,"PhDesc","item")
	s objstr=$REPLACE(objstr,"PForm","FormProp")
	s objstr=$REPLACE(objstr,"Instr","DrugPreMet")
	s objstr=$REPLACE(objstr,"DosQty","OnceDose")
	s objstr=$REPLACE(objstr,"Uom","Unit")
	s objstr=$REPLACE(objstr,"DosUom","Unit")
	s objstr=$REPLACE(objstr,"DosUnit","Unit")
	s objstr=$REPLACE(objstr,"Freq","DrugFreq")
	s objstr=$REPLACE(objstr,"DrugFreqFreq","DrugFreq")
	s objstr=$REPLACE(objstr,"DrugDrugFreq","DrugFreq")
	s objstr=$REPLACE(objstr,"Duration","Treatment")
	s objstr=$REPLACE(objstr,"Skin","SkinTest")
	//s objstr=$tr(obj,"LinkSeqNo","")
	
	q objstr
}

/// 获取his中不传入，但是知识库有判断的项目值,如分类,成分等
ClassMethod SetValueForDic(TmpArr, Key, RuleID, ID)
{
	n (TmpArr,Key,RuleID,ID)
	
	s CheckID=$g(TmpArr("CheckDicID"))

	q:CheckID="" ""
	if (Key="OnceDoseMax")||(Key="OnceDoseLimit"){		// 单次最大量/ 单次极限量
		d ..SetOnceDose(.TmpArr,Key)

	}elseif (Key="DayDose")||(Key="DayDoseMax")||(Key="DayDoseLimit"){	// 每日用药量/每日最大量/每日极限量
		d ..SetDayDose(.TmpArr,Key)
		
	}	
	elseif (Key="TotalDrugTime"){   // xiaowenwu 累计用药时长算法 2020-03-05
		s qty=$listtostring($g(TmpArr("Treatment"_$c(1)_CheckID)))				//疗程
		s qtyUnit=$listtostring($g(TmpArr("Treatment"_$c(1)_CheckID,"Unit")))   //疗程单位
		s qtyUnitExt=$listtostring($g(TmpArr("Treatment"_$c(1)_CheckID,"Unit","Ext"))) //疗程值
		s OrdDate=$listtostring($g(TmpArr("OrdDate"_$c(1)_CheckID)))		//医嘱时间
		s:OrdDate'="" OrdDate=$zdh(OrdDate,3)
		s:OrdDate="" OrdDate=+$h
		s itmList=$g(TmpArr("Drug"))
		f i=1:1:$listlength(itmList) d
		.s itmid=$list(itmList,i)
		.q:+itmid=0
		.i +itmid=+CheckID d
		..s oldOrdDate=$listtostring($g(TmpArr("OrdDate"_$c(1)_itmid)))		//医嘱时间
		..q:oldOrdDate=""
		..s oldOrdDate=$zdh(oldOrdDate,3)
		..q:oldOrdDate'<OrdDate
		..s $list(TmpArr(Key_$c(1)_CheckID))=(qtyUnitExt+$listtostring($g(TmpArr("Treatment"_$c(1)_itmid,"Unit","Ext"))))_qtyUnit			//疗程
		..s $list(TmpArr(Key_$c(1)_CheckID,"Unit"))=qtyUnit   //疗程单位
		..s $list(TmpArr(Key_$c(1)_CheckID,"Unit","Ext"))=qtyUnitExt+$listtostring($g(TmpArr("Treatment"_$c(1)_itmid,"Unit","Ext"))) //疗程值
	}
	elseif(Key="CumuDosage"){		//累积量  sufan 
		s OnceDose=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID)))   					// 单次剂量
		s DosUnit=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit")))
		s DosUnitExt=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit","Ext")))		// 单次剂量单位
		s DrugFreq=$listtostring($g(TmpArr("DrugFreq"_$c(1)_CheckID,"Ext")))				// 频率
		s Treatment=$listtostring($g(TmpArr("Treatment"_$c(1)_CheckID,"Ext")))				// 疗程
		s OrdDate=$listtostring($g(TmpArr("OrdDate"_$c(1)_CheckID)))						// 医嘱日期
		s FreqList=..GetFreqFacUom(DrugFreq)												// 频次转换
		s FreCoe=$list(FreqList,1)															// 系数	
		s OrdDate=$zdh(OrdDate,3)
		s CumuNum=FreCoe*OnceDose*Treatment													// 计算当次的疗程
		s itmList=$g(TmpArr("Drug"))
		f i=1:1:$listlength(itmList) d
		.s itmid=$list(itmList,i)
		.Q:+itmid=0
		.Q:+CheckDicID'=+itmid
		.s ItmOnceDose=$listtostring(TmpArr("OnceDose"_$c(1)_itmid))   					// 单次剂量
		.s ItmDosUnit=$listtostring(TmpArr("OnceDose"_$c(1)_itmid,"Unit","Ext"))		// 单次剂量单位
		.s ItmDrugFreq=$listtostring(TmpArr("DrugFreq"_$c(1)_itmid,"Ext"))				// 频率
		.s ItmTreatment=$listtostring(TmpArr("Treatment"_$c(1)_itmid,"Ext"))			// 疗程
		.s ItmOrdDate=$listtostring(TmpArr("OrdDate"_$c(1)_itmid))						// 医嘱日期
		.s ItmFreqList=..GetFreqFacUom(ItmDrugFreq)										// 频次转换
		.s ItmFreCoe=$list(ItmFreqList,1)												// 系数	
		.s ItmOrdDate=$zdh(ItmOrdDate,3)
		.Q:(ItmOrdDate+ItmTreatment)<OrdDate											// 过滤掉不在范围的疗程
		.i (ItmOrdDate<OrdDate)&&((ItmOrdDate+Treatment)>OrdDate)&&(ItmFreCoe'="")  d	// 计算未完的疗程
		..s ItnCumuNum=FreCoe*OnceDose*((OrdDate+Treatment)-+$h)			
		..s $list(TmpArr(Key_$c(1)_CheckID))=(CumuNum+ItnCumuNum)						//累积量
		..s $list(TmpArr(Key_$c(1)_CheckID),"Ext")=(CumuNum+ItnCumuNum)_DosUnitExt		//累积量_单位
		..s $list(TmpArr(Key_$c(1)_CheckID,"Unit"))=DosUnit  							//累积量单位
		..s $list(TmpArr(Key_$c(1)_CheckID,"Unit","Ext"))=DosUnitExt
	}

	elseif (Key="SolventDensity")||(Key="SolutionDensity"){	// 溶媒浓度/溶液浓度 2020/4/3 qnp
		d ..SetSolutionDensity(RuleID, ID, Key, .TmpArr)
	}
	elseif (Key="Solventvolume")||(Key="SolutionVolume"){	// 溶媒体积/溶液体积 2020/4/3 qnp
		d ..SetSolutionVolume(RuleID, ID, Key, .TmpArr)
	}
		
	elseif (Key="Treatment"){	// 疗程
	
	}
	elseif (Key="Bacteria"){		// 细菌
	
	}
	elseif (Key="BacteriaCat"){		// 菌属
	
	}
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-02-24
/// Descript: 		获取目录的提示内容(暂时拼写，待配置完成后，取配置)
/// Input:			目录,项目
/// w ##class(web.DHCCKBPassNew).GetMsg("禁忌症","Disease")
ClassMethod GetLabelMsg(Label, Key = "")
{
	n (Label,Key)
	
	s Msg=""
	// 优先取目录下的项目的内容,若项目中没有,则取目录的提醒内容. 若两者都没有,则用手动拼写的
	s LabelID=##class(web.DHCCKBCommon).GetDicIdByDesc(Label,##class(web.DHCCKBCommon).GetDrugLibaryData())
	s:+LabelID=0 LabelID=##class(web.DHCCKBCommon).GetDicIdByDesc(Label,##class(web.DHCCKBCommon).GetDrugEduProp())
	s LabelMsg=##class(web.DHCCKBCommon).GetLabelRemindMsg(LabelID)	// 目录提醒
	i LabelMsg'="" s Msg=LabelMsg
	q:Msg'="" Msg
	
	s KeyId=""
	i Key'="" s KeyId=##class(web.DHCCKBCommon).GetDicIdByCode(Key)
	s LabelItmMsg=##class(web.DHCCKBCommon).GetItmRemindMsg(LabelID,KeyId)	// 目录下的项目提醒
	i LabelItmMsg'="" s Msg=LabelItmMsg
	q:Msg'="" Msg
	
	// 没有配置时,用下面自动拼写的
	s KeyName=""
	i Key'="" s KeyName=##class(web.DHCCKBCommon).GetDicDescByCode(Key)	
	if Label["用法"	d	// 用法用量 /用法   在具体的项目上提醒
	.i Key="Disease" s Msg="超适应症"
	.e  i Key'="" d
	..s:(KeyName'="")&(KeyName'=0) Msg=KeyName_"不当"
	.e  d
	..s Msg=Label_"不当"
	
	else  if Label["禁忌"  d	//项目->目录->
	.i Key="Disease" s Msg="存在禁忌症" 
	.else  if Key="HisAllergy" s Msg="存在过敏"
	.else  if (KeyName'="")&(KeyName'=0) s Msg=KeyName_"不当"
	.else  s Msg="存在禁忌"
	
	else  if Label["适应"  d	// 目录提醒 
	.s Msg="超适应症用药"
	else  d						// 目录提醒 
	.s Msg="存在"_Label_"问题"
	
	q Msg
}

/// Descript:	频次的系数和单位
/// w ##Class(web.DHCCKBPassNew).GetFreqFacUom("qd")
ClassMethod GetFreqFacUom(Freq As %String) As %String
{
	n (Freq)
	q:Freq="" ""
	s FreqIDList=..GetComDicIdNew(Freq,"DrugFreq")
	
	s FreqFacUnitProp=##class(web.DHCCKBCommon).GetFreqFactorUnitProp()   /// 用药频次转换因子单位
	s FreqFacProp=##class(web.DHCCKBCommon).GetFreqFactorProp()		/// 用药频次转换因子
	s ExitFlag=0

	s FreqList=""
	f i=1:1:$listlength(FreqIDList) q:(ExitFlag=1)  d
	.s FreqID = $listget(FreqIDList,i)
	.q:+FreqID=0 
	.s Fac=""
	.s Group="",FreqUnit="",FreqUnitDesc="",FreqFac=""
	.s LinkID=""
	.f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",FreqID,FreqFacUnitProp,LinkID))  q:LinkID=""  d
	..s FreqUnit=$p(^DHCCKBDLA(LinkID),"^",3)
	..s DicLinkDr=$p(^DHCCKBCD(FreqUnit),"^",4)
	..q:FreqUnit=""
	..s FreqUnitDesc=$case(+DicLinkDr'=0,1:$p(^DHCCKBCD(DicLinkDr),"^",2),:$p(^DHCCKBCD(FreqUnit),"^",2))
	..s Group=$p(^DHCCKBDLA(LinkID),"^",5)	
	.
	.s LinkID=""
	.f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",FreqID,FreqFacProp,LinkID))  q:(LinkID="")||(ExitFlag=1)  d
	..q:Group'=$p(^DHCCKBDLA(LinkID),"^",5)	
	..s FreqFac=$p(^DHCCKBDLA(LinkID),"^",4)
	..s ExitFlag = 1
	.
	.s FreqList=$lb(FreqFac,FreqUnit,FreqUnitDesc)
	
	q:Freq="" ""
	q:Freq'="" FreqList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-02-24
/// Descript: 		重复用药的规则判断(公式维护完成前,先暂时用此方法做重复用药的判断)
/// Input:			目录,项目
/// w ##class(web.DHCCKBPassNew).CheckRepeatMedical("禁忌症","Disease")
ClassMethod CheckRepeatMedical(pid, Itmid, TmpArr, TmpMsgArr)
{
	n (pid,Itmid,TmpArr,TmpMsgArr)	// 此时数组里面只有入参处理过的信息
	
	s RuleType=$g(TmpArr("Action"))	
	q:RuleType'="CheckRule" ""
	q:$g(TmpArr("globalAcc"))<=0 ""	// 全局规则的权限
	
	s GlobalDataID = ##class(web.DHCCKBCommon).GetGlobalData()
	s LabelDesc="重复用药"
	s LabelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(LabelDesc,GlobalDataID) //##class(web.DHCCKBCommon).GetDrugLibaryData())
	// 提示内容应该是a 和 b 重复
	// 相同药品名称重复  
	// 阿莫西林  和 阿莫西林 重复，  提醒：阿莫西林重复使用
	// 阿莫西林    和 阿莫西林钠的别名重复,此时提醒 ： 阿莫西林 和阿莫西林 重复用药
	//s ItmDesc=$p($g(^DHCCKBCD(Itmid)),"^",2)
	s PreMetList=TmpArr("DrugPreMet"_$c(1)_Itmid,"Ext")
	q:$listfind(PreMetList,"外用")'=0 ""
	s ItmPhCatList=##Class(web.DHCCKBCommon).GetAlonePhCat(+Itmid,0) 
	q:$listfind(ItmPhCatList,"溶媒类")'=0 
	s RealItmId=$p(Itmid,$c(2),1)
	q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,RealItmId,LabelID,"D") "" // 判断目录是否有忽略配置
	s ItmDesc=$listtostring(TmpArr("Drug",Itmid))
	s ItmDesc=$case(ItmDesc'="",1:ItmDesc,:$p($g(^DHCCKBCD(RealItmId)),"^",2))
	s LibValue=TmpArr("Drug")
	
	s HisValue=$g(TmpArr("ItemHisOrder"))		//sufan 2022-05-19 增加历史医嘱的重复用药
	i HisValue'=""  d
	.s LibValue=$listtostring(LibValue,",")_","_$listtostring(HisValue)	
	.s LibValue=$listfromstring(LibValue,",")
	
	s RepeatFlag=0	// 是否重复标志
	f i=1:1:$listlength(LibValue) q:RepeatFlag=1  d
	.s tmpValue=$list(LibValue,i)
	.q:tmpValue=Itmid
	.s TmpArr("CheckDicID")=tmpValue
	.s PreMetList=TmpArr("DrugPreMet"_$c(1)_tmpValue,"Ext")
	.q:$listfind(PreMetList,"外用")'=0 		// 外用 不判断重复用药
	.s PhCatList=##Class(web.DHCCKBCommon).GetAlonePhCat(+Itmid,0) 
	.q:$listfind(PhCatList,"溶媒类")'=0 
	.q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,+tmpValue,LabelID,"D") // 判断目录是否有忽略配置
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue))
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid))
	.
	.s LibValueExt=##class(web.DHCCKBCommon).GetDicSecondName($p(tmpValue,$c(2),1))
	.s Ret=..CheckRepeatDrug(RealItmId,ItmDesc,$p(tmpValue,$c(2),1),LibValueExt)	
	.i Ret=1 s RepeatFlag=1

	//TmpMsgArr("itemOrder",审查项目,目录,规则id)=$lb(实际是否通过,通过标志,级别,提示信息,管制力度,提醒依据,警示信息(目录维护))
	i RepeatFlag=1  d
	.s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue)=""
	.s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid)=""
	.//s TmpMsgArr("Repeat"_$c(1)_Itmid)=ItmDesc_"重复使用"
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R0")=$lb(0,"NotPass","warn","","","","")
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R0",Itmid)="Repeat"_"@@"_ItmDesc_"重复使用"
	.s TmpMsgArr("PreCondtions",Itmid_"R0")=$lb("NULL")	//前提条件
	q:RepeatFlag=1 ""	// 相同名称重复用药了，不需要在看其他情况的重复用药

	s RepeatList=""
	;shy   注释相同成分重复提示
	// 相同成分
	s ItmIngr=##class(web.DHCCKBCommon).GetIngredient(RealItmId,1)
	s ItmIngrExt=##class(web.DHCCKBCommon).GetIngredient(RealItmId,0)

	f i=1:1:$listlength(LibValue) d
	.s tmpValue=$list(LibValue,i)
	.s TmpArr("CheckDicID")=tmpValue
	.q:tmpValue=Itmid
	.//q:$d(RepeatList(tmpValue))	// 通用名已经存在的不重复显示
	.s PreMetList=TmpArr("DrugPreMet"_$c(1)_tmpValue,"Ext")
	.q:$listfind(PreMetList,"外用")'=0
	.s PhCatList=##Class(web.DHCCKBCommon).GetAlonePhCat(+tmpValue,0) 
	.q:$listfind(PhCatList,"溶媒类")'=0 
	.q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,+tmpValue,LabelID,"D") // 判断目录是否有忽略配置
	.s parrefId = $p($g(^DHCCKBCD(+tmpValue)),"^",3)
	.q:(parrefId'="")&&(parrefId'=##class(web.DHCCKBCommon).GetDrugData())	// 只判断西药 2021/7/15 qnp
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue))
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid))
	.s tmpIngrDic=##class(web.DHCCKBCommon).GetIngredient($p(tmpValue,$c(2),1),1)	// 成分（多个）
	.s RepeatFlag=0
	.f k=1:1:$listlength(tmpIngrDic) q:RepeatFlag=1  d
	..s LibIngrDic=$list(tmpIngrDic,k)
	..s LibIngrDicExt=##class(web.DHCCKBCommon).GetDicSecondName(LibIngrDic)	// 成分别名
	..q:(ItmIngr="")&(ItmIngrExt="")
	..q:(LibIngrDic="")&(LibIngrDicExt="")
	..s Ret=..CheckRepeatDrug(ItmIngr,ItmIngrExt,LibIngrDic,LibIngrDicExt)	
	..i Ret=1 s RepeatFlag=1 
	.i RepeatFlag=1 d 
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue)=""
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid)=""
	..s RepeatIngrName = $p($g(^DHCCKBCD(+LibIngrDic)),"^",2) // 记录重复的成分
	..s IngrLevel = ##Class(web.DHCCKBPassExt).GetIngreLevel(LibIngrDic) // 成分重复的级别 2022-04-29
	..s IngrLevelNum = ""
	..i IngrLevel'="" s IngrLevelNum = ##class(web.DHCCKBCommon).GetManLevelNum(IngrLevel) 
	..s RepeatDrug = $case($listtostring($g(TmpArr("Drug",tmpValue)))="",1:$listtostring($g(TmpArr("ItemHisOrder",tmpValue))),:$listtostring($g(TmpArr("Drug",tmpValue))))
	..s RepeatList(tmpValue)=$lb("Ingr",tmpValue,RepeatDrug,RepeatIngrName,IngrLevelNum)

	// 相同化学名
	s ItmGenerDic=##class(web.DHCCKBCommon).GetGeneralName(RealItmId,1)
	s ItmGenerDicExt=##class(web.DHCCKBCommon).GetGeneralName(RealItmId,0)
	f i=1:1:$listlength(LibValue) d
	.s tmpValue=$list(LibValue,i)
	.s TmpArr("CheckDicID")=tmpValue
	.q:tmpValue=Itmid
	.q:$d(RepeatList(tmpValue))	// 通用名已经存在的不重复显示
	.s PreMetList=TmpArr("DrugPreMet"_$c(1)_tmpValue,"Ext")
	.q:$listfind(PreMetList,"外用")'=0 
	.s PhCatList=##Class(web.DHCCKBCommon).GetAlonePhCat(+tmpValue,0) 
	.q:$listfind(PhCatList,"溶媒类")'=0 
	.q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,+tmpValue,LabelID,"D") // 判断目录是否有忽略配置
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue))
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid))
	.s tmpLibGenerDic=##class(web.DHCCKBCommon).GetGeneralName($p(tmpValue,$c(2),1),1)	// 化学（多个）
	.
	.s RepeatFlag=0
	.f k=1:1:$listlength(tmpLibGenerDic) q:RepeatFlag=1  d
	..s LibGenerDic=$list(tmpLibGenerDic,k)
	..s LibGenerDicExt=##class(web.DHCCKBCommon).GetDicSecondName(LibGenerDic)	// 化学名别名
	..q:((ItmGenerDic="")&(ItmGenerDicExt=""))
	..q:((LibGenerDic="")&(LibGenerDicExt=""))
	..s Ret=..CheckRepeatDrug(ItmGenerDic,ItmGenerDicExt,LibGenerDic,LibGenerDicExt)	
	..i Ret=1 s RepeatFlag=1	
	.i RepeatFlag=1 d 
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue)=""
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid)=""
	..s RepeatGenerName = $p($g(^DHCCKBCD(+LibGenerDic)),"^",2) 	// 记录重复的化学名
	..s RepeatDrug = $case($listtostring($g(TmpArr("Drug",tmpValue)))="",1:$listtostring($g(TmpArr("ItemHisOrder",tmpValue))),:$listtostring($g(TmpArr("Drug",tmpValue))))
	..s RepeatList(tmpValue)=$lb("General",tmpValue,RepeatDrug,RepeatGenerName)
 	
	// 相同的药学分类(按照最小分类重复判断) 2021/07/08 qnp
	s newDrugCatId = ##class(web.DHCCKBCommon).GetNewDrugCatId()
	s ItmCat = ##Class(web.DHCCKBCommon).GetAlonePhCat(RealItmId,1) 
	s ItmCatExt = ##Class(web.DHCCKBCommon).GetAlonePhCat(RealItmId,0) 
	s newDrugCatId = ##class(web.DHCCKBCommon).GetNewDrugCatId()
	s UserInfo = $g(TmpArr("UserInfo"))
	s LocId=$p(UserInfo,"^",3)
	s LocId=##class(web.DHCCKBCommon).GetLocIdByDesc(LocId)
	s authFlag = ##Class(web.DHCCKBPassExt).GetDrugCatAuth(LocId,newDrugCatId)
	f i=1:1:$listlength(LibValue)  q:authFlag=0  d
	.q:authFlag=0
	.s tmpValue=$list(LibValue,i)
	.s TmpArr("CheckDicID")=tmpValue
	.q:tmpValue=Itmid
	.q:$d(RepeatList(tmpValue))	// 已经存在的不重复显示
	.s PreMetList=TmpArr("DrugPreMet"_$c(1)_tmpValue,"Ext")
	.q:$listfind(PreMetList,"外用")'=0
	.s PhCatList=##Class(web.DHCCKBCommon).GetAlonePhCat(+tmpValue,0) 
	.q:$listfind(PhCatList,"溶媒类")'=0 
	.q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,+tmpValue,LabelID,"D") // 判断目录是否有忽略配置
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue))
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid))
	.s tmpCatDic=##class(web.DHCCKBCommon).GetAlonePhCat($p(tmpValue,$c(2),1),1)	// 分类（多个）
	.s RepeatFlag=0
	.f k=1:1:$listlength(tmpCatDic) q:RepeatFlag=1  d
	..s LibCatDic=$list(tmpCatDic,k)
	..s SmallCatFlag = ##Class(web.DHCCKBPassExt).CheckSmallCat(LibCatDic)
	..q:SmallCatFlag'=1	// 最小分类重复
	..s parrefCatList=""
	..d ##Class(web.DHCCKBCommon).GetParentCat(.parrefCatList,LibCatDic,1)	// 获取父分类
	..q:$listfind(parrefCatList,newDrugCatId)=0	// 不在新编药物学分类重复下
	..s LibCatDicExt=##class(web.DHCCKBCommon).GetDicSecondName(LibCatDic)	// 分类别名
	..q:(ItmCat="")&(ItmCatExt="")
	..q:(LibCatDic="")&(LibCatDicExt="")
	..s Ret=..CheckRepeatDrug(ItmCat,ItmCatExt,LibCatDic,LibCatDicExt)	
	..i Ret=1 s RepeatFlag=1 
	.i RepeatFlag=1 d 
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,Itmid,tmpValue)=""
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid,tmpValue,Itmid)=""
	..s RepeatCatName = $p($g(^DHCCKBCD(+LibCatDic)),"^",2) // 记录重复的分类
	..i ($p($g(^DHCCKBCD(+LibCatDic)),"^",4)'="")&(RepeatCatName="") d 
	...s LinkCatDic = $p($g(^DHCCKBCD(+LibCatDic)),"^",4)
	...s RepeatCatName = $p($g(^DHCCKBCD(+LinkCatDic)),"^",2) 
	..s RepeatDrug = $case($listtostring($g(TmpArr("Drug",tmpValue)))="",1:$listtostring($g(TmpArr("ItemHisOrder",tmpValue))),:$listtostring($g(TmpArr("Drug",tmpValue))))
	..s RepeatList(tmpValue)=$lb("Cat",tmpValue,RepeatDrug,RepeatCatName)
	
	s IngrList="",GenerList="",RepeatName="",CatList="",RepeatLevel=""
	s id=""
	f  s id=$o(RepeatList(id))  q:id=""  d
	.s type=$list(RepeatList(id),1)
	.if type="Ingr"  d
	..s $list(IngrList,*+1)=$list(RepeatList(id),3)
	..s IngrLevel = $list(RepeatList(id),5)
	..i (IngrLevel'="")&&(IngrLevel>=(+RepeatLevel)) s RepeatLevel = IngrLevel
	.if type="General" d
	..s $list(GenerList,*+1)=$list(RepeatList(id),3)
	.if type="Cat" d
	..s $list(CatList,*+1)=$list(RepeatList(id),3)
	.s $list(RepeatName,*+1) = $list(RepeatList(id),4)

	//s RepeatValue = $case($listlength(RepeatName)>0,1:"【"_$listtostring(RepeatName)_"】",:"")
	s RepeatValue = $case($listlength(RepeatName)>0,1:$listtostring(RepeatName),:"")
	if IngrList'=""  d
	.i RepeatLevel'="" s RepeatLevel = ##class(web.DHCCKBCommon).GetManLevelCodeByNum(RepeatLevel)
	.e  s RepeatLevel="warn"
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R1")=$lb(0,"NotPass",RepeatLevel,"","","","")
	.//s TmpMsgArr("RepeatIngr"_$c(1)_Itmid)=ItmDesc_"和"_$listtostring(IngrList,"、")_"(成分)重复"
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R1",Itmid_"R1")="RepeatIngr"_"@@"_ItmDesc_"和"_$listtostring(IngrList,"、")_"(成分:"_RepeatValue_")重复"
	.s TmpMsgArr("PreCondtions",Itmid_"R1")=$lb("NULL")	//前提条件

	if GenerList'=""  d
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R2")=$lb(0,"NotPass","warn","","","","")
	.//s TmpMsgArr("RepeatGener"_$c(1)_Itmid)=ItmDesc_"和"_$listtostring(GenerList,"、")_"(通用名)重复"
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R2",Itmid_"R2")="RepeatGener"_"@@"_ItmDesc_"和"_$listtostring(GenerList,"、")_"(化学名:"_RepeatValue_")重复"
	.s TmpMsgArr("PreCondtions",Itmid_"R2")=$lb("NULL")	//前提条件

	if CatList'=""  d
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R3")=$lb(0,"NotPass","forbid","","","","")
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"R3",Itmid_"R3")="RepeatCat"_"@@"_ItmDesc_"和"_$listtostring(CatList,"、")_"(分类:"_RepeatValue_")重复"
	.s TmpMsgArr("PreCondtions",Itmid_"R3")=$lb("NULL")	//前提条件
	
	//TmpMsgArr("itemOrder",审查项目,目录,规则id)=$lb(实际是否通过,通过标志,级别,提示信息,管制力度,提醒依据,警示信息(目录维护))
}

/// 检查药品重复bu
ClassMethod CheckRepeatDrug(HisValue, HisValueExt, LibValue, LibValueExt)
{
	n (HisValue,HisValueExt,LibValue,LibValueExt)
	
	s Ret=##Class(web.DHCCKBCommonUtil).CompareBothList(HisValue,LibValue)
	s OtherRet=##Class(web.DHCCKBCommonUtil).CompareBothList(HisValueExt,LibValueExt)	// his数据有对照,却是知识库规则数据的别名
	s Ret=Ret||OtherRet
	
	q Ret
}

/// Creator:sufan
/// CreateDate:2020-03-04
/// Descript:肌酐清楚率计算
ClassMethod CalCreatinClearRate(TmpArr)
{
	n (TmpArr)
	s Age=TmpArr("AgeProp")    				//患者年龄
	s:$listvalid(Age)=1 Age=$listget(Age)
	s Weight=TmpArr("Weight")				//患者体重
	s:$listvalid(Weight)=1 Weight=$listget(Weight)
	s InspectList=$g(TmpArr("LabItm"))		//检验指标
	s LabValue="",CreatinRate=""
	f i=1:1:$listlength(InspectList) d		//循环检验项目，取出血肌酐值进行计算
	.s LabitmId=$list(InspectList,i)
	.Q:LabitmId=""
	.s LabDesc=$p($g(^DHCCKBCD(LabitmId)),"^",2)		//检验项目
	.Q:LabDesc'="血肌酐"
	.s LabValue=$g(TmpArr("LabItmValueLimitProp"_$c(1)_LabitmId))			// 指标值
	.s:$listvalid(LabValue)=1 LabValue=$listget(LabValue)
	//s:LabValue'="" CreatinRate=(140-Age)*Weight/0.181/LabValue	
	s:LabValue'="" CreatinRate=(140-Age)*Weight/0.818/LabValue		// 公式：140-年龄*体重/0.818/血肌酐

	Q CreatinRate
}

/// Creator:sufan
/// CreateDate:2020-03-04
/// Descript:累积量计算
ClassMethod CalCumulative(TmpArr)
{
	
	s OnceDose=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID)))   					// 单次剂量
	s DosUnit=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit")))
	s DosUnitExt=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit","Ext")))			// 单次剂量单位
	s DrugFreq=$listtostring($g(TmpArr("DrugFreq"_$c(1)_CheckID,"Ext")))				// 频率
	s Treatment=$listtostring($g(TmpArr("Treatment"_$c(1)_CheckID,"Ext")))				// 疗程
	s OrdDate=$listtostring($g(TmpArr("OrdDate"_$c(1)_CheckID)))						// 医嘱日期
	s FreqList=..GetFreqFacUom(DrugFreq)												// 频次转换
	s FreCoe=$list(FreqList,1)															// 系数	
	s OrdDate=$zdh(OrdDate,3)
	s CumuNum=FreCoe*OnceDose*Treatment													// 计算当次的疗程
	s itmList=$g(TmpArr("Drug"))
	f i=1:1:$listlength(itmList) d
	.s itmid=$list(itmList,i)
	.Q:+itmid=0
	.Q:+CheckDicID'=+itmid
	.s ItmOnceDose=$listtostring(TmpArr("OnceDose"_$c(1)_itmid))   					// 单次剂量
	.s ItmDosUnit=$listtostring(TmpArr("OnceDose"_$c(1)_itmid,"Unit","Ext"))		// 单次剂量单位
	.s ItmDrugFreq=$listtostring(TmpArr("DrugFreq"_$c(1)_itmid,"Ext"))				// 频率
	.s ItmTreatment=$listtostring(TmpArr("Treatment"_$c(1)_itmid,"Ext"))			// 疗程
	.s ItmOrdDate=$listtostring(TmpArr("OrdDate"_$c(1)_itmid))						// 医嘱日期
	.s ItmFreqList=..GetFreqFacUom(ItmDrugFreq)										// 频次转换
	.s ItmFreCoe=$list(ItmFreqList,1)												// 系数	
	.s ItmOrdDate=$zdh(ItmOrdDate,3)
	.Q:(ItmOrdDate+ItmTreatment)<OrdDate											// 过滤掉不在范围的疗程
	.i (ItmOrdDate<OrdDate)&&((ItmOrdDate+Treatment)>OrdDate)&&(ItmFreCoe'="")  d	// 计算未完的疗程
	..s ItnCumuNum=FreCoe*OnceDose*((OrdDate+Treatment)-+$h)			
	..s $list(TmpArr(Key_$c(1)_CheckID))=(CumuNum+ItnCumuNum)						//累积量
	..s $list(TmpArr(Key_$c(1)_CheckID),"Ext")=(CumuNum+ItnCumuNum)_DosUnitExt		//累积量_单位
	..s $list(TmpArr(Key_$c(1)_CheckID,"Unit"))=DosUnit  							//累积量单位
	..s $list(TmpArr(Key_$c(1)_CheckID,"Unit","Ext"))=DosUnitExt					//累积量
}

/// Creator:  	xiaowenwu
/// CreateDate: 2020-03-04
/// Descript: 	先判断适应症是否未通过，未通过再判断一下用法用量
/// InPut:      
/// w ##Class(web.DHCCKBPassNew).CheckIndication("")
ClassMethod CheckIndication(ItmID, TmpArr, TmpMsgArr)
{
	n (ItmID,TmpArr, TmpMsgArr)
	
	s RuleType=$g(TmpArr("Action"))	
	q:RuleType'="CheckRule" ""
	q:$g(TmpArr("globalAcc"))<=0 ""	// 全局规则的权限
	
	s CheckItmID=ItmID
	s ItmID=$p(ItmID,$c(2),1)
	//q:ItmID'=2741   //卡前列素氨丁三醇注射液 测试用药品
	s Indication="适应症"
	q:'$d(TmpMsgArr("itemOrder",CheckItmID,Indication))   //如果适应症下没有返回值，则不判断用法用量
	K LabelArr
	s RulDicID=""
	F  s RulDicID=$o(^DHCCKBRULEDIC(0,"Dic",ItmID,RulDicID)) Q:RulDicID=""  D
	.s IsFailFlag=1	// 默认通过
	.s RulID=$p(^DHCCKBRULEDIC(RulDicID),"^",1) 	// 规则ID
	.Q:$p(^DHCCKBRULE(RulID),"^",3)'="Release"  	// 未发布不加算在内
	.q:..isChildRule(RulID)=1						// 审查项目本身有子规则,不审子规则
	.s TmpArr("RulID")=RulID 
	.//s TmpArr("TipsPath")=..GetLabelTipsPath(RulID)	// 提醒方向
	.s TmpArr("CheckDicID")=CheckItmID
	.s TmpArr("RuleStype",RulID)="G"
	.s LabelDesc=..GetRuleLabelDesc(RulID)				// 审查目录
	.s TmpArr("LabelDesc")=LabelDesc
	.q:LabelDesc'="用法用量"							// 除用法用量之外的不判断
	.k TmpPreConsArr
	.s condFlag=..TakPreConditionsInd(RulID,.TmpPreConsArr)		// 优先判断规则中的所有前提条件,有前提条件且都满足的情况下,才进行进行后面的项目判断
	.s isPreCondFlag=..isPreConditionsInd(RulID,.TmpPreConsArr,.TmpArr,.TmpMsgArr)
	.q:(condFlag=1)&(isPreCondFlag=1) 		
	.i (isPreCondFlag=0) d 								// 一条通过则通过, 清除掉目录的返回值
	..k TmpMsgArr("itemOrder",CheckItmID,Indication)
}

///  Descript:  当前规则是否有前置条件
///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    0 - 没有、1-有
///  w ##Class(web.DHCCKBPassNew).TakPreConditionsInd("1831",TmpPreConsArr)
ClassMethod TakPreConditionsInd(RulID As %String, TmpPreConsArr) As %String
{
	n (RulID, TmpPreConsArr)
	k TmpPreConsArr
	/// 当前规则前置条件
	s Libary=0
	//s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	//判断规则中是否有目录
	s Dic="" f  s Dic=$o(^DHCCKBRULEDIC(0,"RuleDic",RulID,Dic)) q:Dic=""  d
	.s DicParef=$p(^DHCCKBCD(Dic),"^",3)
	.s:DicParef=DrugLibary Libary=Dic

	q:Libary="" 0
	
	s QuitFlag=0
	s Parent=""
	f  s Parent=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",Parent))  q:Parent=""   d  
	.s Node=""
	.f  s Node=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",Parent,Node))  q:Node=""   d  
	..q:Node=0
	..s RulDataID=""
	..f  s RulDataID=$o(^DHCCKBRD(0,"Node",Node,RulDataID))  q:RulDataID=""   d
	...q:RulDataID=0
	...s LeftDic=$p(^DHCCKBRD(RulDataID),"^",3)					// 实体/属性
	...q:$p(^DHCCKBCD(LeftDic),"^",2)'="疾病"   			//判断表达式左边是否为疾病
	...q:'$d(^DHCCKBDLA(0,"LinkDicAttrCode",Libary,LeftDic))
	...s LinkID=""
	...f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",Libary,LeftDic,LinkID)) q:LinkID=""  d
	....q:$p(^DHCCKBDLA(LinkID),"^",4)'="Y"
	....s Attr=$p(^DHCCKBDLA(LinkID),"^",3)
	....q:+Attr=0
	....q:Attr'=##class(web.DHCCKBCommon).GetPreconditions()	//前提条件
	....s QuitFlag=1
	....i QuitFlag d 
	.....s TmpPreConsArr("PropType",RulID,RulDataID)=LeftDic

	q QuitFlag
}

///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    1 - 不满足、0-满足
///  w ##Class(web.DHCCKBPassNew).isPreConditionsInd("69", .TmpPreConsArr, .TmpArr)
ClassMethod isPreConditionsInd(RulID As %String, TmpPreConsArr, TmpArr, TmpMsgArr) As %String
{
	n (RulID, TmpPreConsArr, TmpArr,TmpMsgArr)
	
	Q:'$D(TmpPreConsArr("PropType")) 1        /// 当前规则类型未设置前置条件
	s RulDataID="",IsFlag=1
	F  s RulDataID=$o(TmpPreConsArr("PropType",RulID,RulDataID)) Q:(RulDataID="")||(IsFlag=0)  D
	.s diseaseList=$g(TmpArr("Disease"))			//疾病
	.s RightDic=$p(^DHCCKBRD(RulDataID),"^",7)   //规则中疾病右边的值
	.f i=1:1:$listlength(diseaseList) d
	..s Disease=$list(diseaseList,i)
	..s:Disease=RightDic IsFlag=0

	Q IsFlag
}

/// 审查目前和统一模式 有出入的项目
ClassMethod CheckUnModelItem(RulID, ID, Key, TmpArr, TmpMsgArr)
{
	n (RulID,ID,Key,TmpArr,TmpMsgArr)

	// 跟药品相关的，如成分,分类,辅料,商品名,通用名
	s CheckDicID=$g(TmpArr("CheckDicID"))
	s TipsPath=$g(TmpArr("TipsPath"))	/// 提醒方向
	s RuleType=$g(TmpArr("Action"))
	s CalcItmID=$p(^DHCCKBRD(ID),"^",3) // 计算项目
	q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,+CheckDicID,CalcItmID,"I") -100 // qnp 2020/1/14 判断目录是否有忽略配置
	q:Key="LabItmValueLimitProp" ..CalcLabItmValueLimit(RulID, ID, .TmpArr, .TmpMsgArr)	
	// 取出规则值 
	s LibValue=..GetSysValue(ID,.TmpArr)
	q:$listlength(LibValue)=0 0
	s LibValueExt=..GetSysValueExt(ID)		// 知识库别名
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   		// 运算符
	s RightType=$p(^DHCCKBRD(ID),"^",9)
	// 判断规则是否有合用类别的限制
	s GroupFlag=-100	// 没维护
	s GroupList=##Class(web.DHCCKBPassNew).GetLinkItm(RulID,ID,"TogetherProp")	// 是否有合用类别(组内,组间)
	i GroupList'=""  d
	.s GroupID=$List(GroupList,1)
	.s GroupDesc=$p($g(^DHCCKBCD(GroupID)),"^",2)
	.s GroupFlag=$case(GroupDesc,"组内":1,"组间":0,:-100)
	
	s LabelDesc=..GetRuleLabelDesc(RulID)  	// 目录
	i (LabelDesc="配伍禁忌")&(GroupFlag=-100) s GroupFlag=1	// 配伍禁忌没有维护合用类别时,默认为组内 20220301 qnp
	
	s Ret="",LinkDrug="",LinkLibValueExt=""
	s ItmList=$g(TmpArr("Drug"))
	s HisValue=$g(TmpArr("ItemHisOrder"))
	i (HisValue'="")&($g(TmpArr("LabelDesc"))["相互作用")  d // 相互作用考虑历史处方 2022-05-12
	.s ItmList=$listtostring(ItmList,",")_","_$listtostring(HisValue)	
	.s ItmList=$listfromstring(ItmList,",")		

	f i=1:1:$listlength(ItmList) d
	.s Itmid=$list(ItmList,i)	
	.//q:(RuleType="CheckRule")&&(LabelDesc["相互作用")&&(Itmid=CheckDicID)	// 排除掉检测药品本身 
	.q:(RuleType="CheckRule")&&(Itmid=CheckDicID)	// 排除掉检测药品本身 
	.s ItmDesc = $p($g(^DHCCKBCD(+Itmid)),"^",2)
	.s CheckDicDesc = $p($g(^DHCCKBCD(+CheckDicID)),"^",2)
	.//q:(RuleType="CheckRule")&&(LabelDesc["相互作用")&&(ItmDesc=CheckDicDesc) // 排除掉检测药品本身 
	.q:(RuleType="CheckRule")&&(ItmDesc=CheckDicDesc) // 排除掉检测药品本身 
	.s RealItmId=$p(Itmid,$c(2),1)
	.s List=""
	.s ListExt=""
	.i (Key="Drug")||(Key="MedDrugNameProp")||(Key="chHerbalMedName")||(Key="ChineseDrugNameProp") d			// 药品
	..s List=$listfromstring(RealItmId)
	..s ListExt=$listfromstring($p(^DHCCKBCD(RealItmId),"^",2))
	.e  i Key="Ingredient"	d	// 成分	
	..s List=##Class(web.DHCCKBCommon).GetIngredient(RealItmId,1)
	..s ListExt=##Class(web.DHCCKBCommon).GetIngredient(RealItmId,0)
	.e  i Key="DrugCategory"	d	// 分类
	..s List=##Class(web.DHCCKBCommon).GetPhCatAlone(RealItmId,1)	//##Class(web.DHCCKBCommon).GetPhCat(RealItmId,1)
	..s ListExt=##Class(web.DHCCKBCommon).GetPhCatAlone(RealItmId,0) //##Class(web.DHCCKBCommon).GetPhCat(RealItmId,0)
	.e  i Key="GenerNameProp"	d	// 通用名
	..s List=##Class(web.DHCCKBCommon).GetGeneralName(RealItmId,1)
	..s ListExt=##Class(web.DHCCKBCommon).GetGeneralName(RealItmId,0)
	.e  i Key="GenerNameFormProp"	d	// 通用名
	..s List=##Class(web.DHCCKBCommon).GetGeneralFrom(RealItmId,1)	// 2022-02-22 qunianpeng
	..s ListExt=##Class(web.DHCCKBCommon).GetGeneralFrom(RealItmId,0)	
	.e  i Key="ProNameProp"	d	// 商品名
	..s List=##Class(web.DHCCKBCommon).GetProName(RealItmId,1)
	..s ListExt=##Class(web.DHCCKBCommon).GetProName(RealItmId,0)
	.e  i Key="PrescriptionCopeProp"	d	// 处方应付	qnp 2021/5/11	
	..s List=##class(web.DHCCKBCommon).GetPrescCopeData(RealItmId,1)
	..s ListExt=##class(web.DHCCKBCommon).GetPrescCopeData(RealItmId,0)
	.e  i Key="ExcipientProp"	d	// 辅料
	..s List=##Class(web.DHCCKBCommon).GetExcipient(RealItmId,1)
	..s ListExt=##Class(web.DHCCKBCommon).GetExcipient(RealItmId,0)
	.e  i (Key="SolventProp")||(Key="SolutionProp")	d // 溶媒/溶液
	..q:(+Itmid)=(+CheckDicID)
	..s GroupFlag=1
	..q:..ISGroup(CheckDicID,Itmid,.TmpArr)=0
	..//s List=$listfromstring(RealItmId)
	..//s ListExt=$listfromstring($p(^DHCCKBCD(RealItmId),"^",2))	
	..s List=##Class(web.DHCCKBCommon).GetGeneralFrom(RealItmId,1) // 溶媒/溶液使用通用名 2021/10/31
	..s ListExt=##Class(web.DHCCKBCommon).GetGeneralFrom(RealItmId,0)
	..s ConstHisItmName = $listGet(TmpArr("Drug",Itmid))
	..i $listfind($g(TmpArr(Key)),RealItmId)=0 s $list(TmpArr(Key),*+1) = RealItmId
	..i $listfind($g(TmpArr(Key,"Ext")),ConstHisItmName)=0 s $list(TmpArr(Key,"Ext"),*+1) =  ConstHisItmName
	.//xww 2021-12-16 start
	.//e  i (Key="SolutionDensity")	d // 浓度
	.//.;b:(RulID=335212)||(ID=2132197) ;ooo1128
	.//.q:(+Itmid)=(+CheckDicID)
	.//.s GroupFlag=1
	.//.q:..ISGroup(CheckDicID,Itmid,.TmpArr)=0
	.//.s List=..GetSolutionDensity(CheckDicID,Itmid,.TmpArr)
	.//.s ListExt="" //##Class(web.DHCCKBCommon).GetGeneralFrom(RealItmId,0)
	.;b:(ID=3149279) ;ooo112
	.//end
	.q:($listtostring(List)="")&($listtostring(ListExt))
	.s HisValue=List
	.s HisValueExt=ListExt
	.//计算	
	.s TmpRet=..Compare(HisValue,HisValueExt,LibValue,LibValueExt,OpArith,RightType,.TmpArr)
	.i TmpRet=1 d
	..s HisGroupFlag=..ISGroup(CheckDicID,Itmid,.TmpArr)				// 组内组间关系判断
	..i (TipsPath=1)&&(GroupFlag=1)&(HisGroupFlag=0) s TmpRet='TmpRet	//禁忌：限定组内不能用，his是组间时,可以用
	..i (TipsPath=0)&&(GroupFlag=0)&(HisGroupFlag=1) s TmpRet='TmpRet	//用法用量： 限定组间可以用,his时组内时，不可以用
	.i Ret="" s Ret=TmpRet
	.e  s Ret=Ret!TmpRet
	.// 记录下来重复的药品
	.i TmpRet=1 d 
	..s DrugName = $listtostring($g(TmpArr("Drug",Itmid)))	
	..i $lf(LinkDrug,DrugName)=0 s $list(LinkDrug,*+1)=DrugName
	..i LabelDesc="重复用药" s $list(LinkLibValueExt,*+1)=$listtostring(LibValueExt)
	..e  d
	...i DrugName'="" s $list(LinkLibValueExt,*+1)=DrugName_"中【"_$listtostring(LibValueExt)_"】"	// 记录相互作用的具体内容 qnp 2021/4/25
	s:Ret="" Ret=0

	// 记录返回值
	s RulID=$g(TmpArr("RulID")) 			// 规则组号
	i $g(TmpArr("RuleStype",RulID))="G" d	
	.i ((TipsPath=1)&(Ret=1))||((TipsPath=0)&(Ret=0)) d
	..s LinkDrug = ##Class(web.DHCCKBPassExt).DealReport(LinkDrug)	//  去掉药品中的重复和空的内容
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=Key_"@@"_$case($listvalid(LinkDrug)>0,1:$listtostring(LinkDrug),:LinkDrug)_"@@"_$case($listvalid(LinkLibValueExt)>0,1:$listtostring(LinkLibValueExt),:LinkLibValueExt)
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID,"Taboo")=Key_"@@"_$case($listvalid(LinkLibValueExt)>0,1:$listtostring(LinkLibValueExt),:LinkLibValueExt)
	..// 增加记录相互作用的药品记录,用于历史医嘱的相互作用判断 2022-05-12
	..d ##class(web.DHCCKBPassExt).MarkRepeatDrug(.TmpMsgArr,CheckDicID,LinkDrug)
	q Ret
}

/// 判断是成组医嘱 
/// 成组(组内)1  不成组(组间)0  
/// w ##Class(web.DHCCKBPassNew).ISGroup(78,77) 
ClassMethod ISGroup(CheckDicID, LinkDicID, TmpArr) As %String
{
	n (CheckDicID,LinkDicID,TmpArr)

	s CheckSeqNo=$listtostring($g(TmpArr("LinkSeqNo"_$c(1)_CheckDicID)))
	q:CheckSeqNo="" 0	//1 1.1 1.2

	s LinkSeqNo=$listtostring($g(TmpArr("LinkSeqNo"_$c(1)_LinkDicID)))
	q:LinkSeqNo="" 0
	
	i $p(CheckSeqNo,".",1)=$p(LinkSeqNo,".",1) q 1

	q 0
}

///  Descript:  知识库输出结构
///  w ##Class(web.DHCCKBPassNew).InvOutRes(.TmpMsgArr)
ClassMethod InvOutResNew(TmpArr As %String, TmpMsgArr As %String) As %String
{
	n (TmpArr, TmpMsgArr)
	s RuleType=$g(TmpArr("Action"))
	s:RuleType="" RuleType="CheckRule"

	//d ##Class(web.DHCCKBPassOutPut).InvOutResForCheck(.TmpArr,.TmpMsgArr)
	//s Ret=$Select(RuleType="CheckRule":..InvOutResForCheck(.TmpArr, .TmpMsgArr),
	s Ret=$Select(RuleType="CheckRule":##Class(web.DHCCKBPassOutPut).InvOutResForCheck(.TmpArr,.TmpMsgArr),
				RuleType="EduRule":..InvOutResForEdu(.TmpArr, .TmpMsgArr),
				1:""
		)

	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-29
/// Descript: 		审查规则的输出信息
/// w ##class(web.DHCCKBCommon).GetRuleType()
ClassMethod InvOutResForCheck(TmpArr As %String, TmpMsgArr As %String)
{
	n (TmpArr,TmpMsgArr)
	
	s MsgObj={},MsgArr=[],ManLevel=0

	i '$d(TmpMsgArr("itemOrder")) d
	.d MsgObj.%Set("passFlag","1")		// 通过标志
	.d MsgObj.%Set("manLevel","tips")	// 级别代码
	.d MsgObj.%Set("manLev","正常")		// 级别描述
	.d MsgObj.%Set("items",MsgArr)		// 整体返回信息	
	.s TmpArr("OutParams")=MsgObj.%ToJSON()
	q:'$d(TmpMsgArr("itemOrder")) ""

	s Item=""
	f  s Item=$o(TmpMsgArr("itemOrder",Item))  q:Item=""  d
	.s ItemsObj={}
	.s ItemID=$p(Item,$c(2),1)
	.s ItemName=$p($g(^DHCCKBCD(ItemID)),"^",2)
	.s HisItemName=$listtostring($g(TmpArr("Drug",Item)))
	.s:HisItemName="" HisItemName=ItemName
	.d ItemsObj.%Set("item",HisItemName)	// his药品描述
	.d ItemsObj.%Set("libitem",ItemName)	// 知识库药品描述
	.d ItemsObj.%Set("itmID",ItemID)	// 药品id
	.//d ItemsObj.%Set("unique",Item)		// 唯一标识
	.d ItemsObj.%Set("unique",ItemID_"_"_$listtostring(TmpArr("SeqNo"_$c(1)_Item)))		// 唯一标识
	.d ItemsObj.%Set("seqno",$listtostring(TmpArr("SeqNo"_$c(1)_Item)))		// 医嘱序号
	.i $g(TmpMsgArr("adviceDrug",Item))'="" d ItemsObj.%Set("adviceDrug",TmpMsgArr("adviceDrug",Item))
	.s libaryList = ""
	.
	./// 以下 药品审查目录排序 2021-01-22 bianshuai
	.s Label=""
	.f  s Label=$o(TmpMsgArr("itemOrder",Item,Label)) q:Label=""  d
	..s LabelManLevel=""
	..k ProConList						
	..d ..MergeMsg(.ProConList,.TmpMsgArr,Item,Label)	// 目录下的消息整理
	..s Index=""
	..f  s Index=$o(ProConList(Index))	q:Index=""  d	// index 是前提条件,或者规则序号
	...s RuleLevelNum=$g(ProConList(Index,"Level"))
	...s RuleLevel=##class(web.DHCCKBCommon).GetManLevelCodeByNum(RuleLevelNum)
	...s LabelManLevel=$case(LabelManLevel>RuleLevelNum,1:LabelManLevel,:RuleLevelNum) // 目录级别取控制最严格的级别
	..s TmpMsgArr("itemOrderManLevel",Item,LabelManLevel_"^"_Label)=""
	./// 以上 药品审查目录排序 2021-01-22 bianshuai
	.
	.s ItemsArr=[]						// 药品提醒信息
	.s DrugManLevel=0					// 药品级别
	.// 目录级别提醒内容
	.//s Label=""
	.//f  s Label=$o(TmpMsgArr("itemOrder",Item,Label)) q:Label=""  d  /// 注释 2021-01-22 bianshuai
	.s mLabel=""
	.f  s mLabel=$o(TmpMsgArr("itemOrderManLevel",Item,mLabel),-1) q:mLabel=""  d   /// 药品审查目录排序 2021-01-22 bianshuai
	..s Label=$p(mLabel,"^",2)
	..s RealLabelManLevel = ##Class(web.DHCCKBPassExt).GetLibaryManLevel(Label)	// 目录设置的级别
	..s LabelObj={}
	..d LabelObj.%Set("key",Label)		// 目录代码
	..//d LabelObj.%Set("keyname",Label_"(院内规则)")	// 目录描述
	..d LabelObj.%Set("keyname",Label)	// 目录描述
	..d LabelObj.%Set("val","")			// 目录提醒内容
	..i $listfind(libaryList,Label)=0 s $list(libaryList,*+1)=Label	
	..// 规则级别提醒内容
	..s RuleArr=[]
	..s LabelManLevel=0	// 目录级别
	..k ProConList						
	..d ..MergeMsg(.ProConList,.TmpMsgArr,Item,Label)	// 目录下的消息整理
	..q:$o(ProConList(""))=""
	..s Index=""
	..f  s Index=$o(ProConList(Index))	q:Index=""  d	// index 是前提条件,或者规则序号
	...s RuleObj={}
	...s RuleLevelNum=$g(ProConList(Index,"Level"))
	...s RuleLevelNum=$case(RealLabelManLevel>RuleLevelNum,1:RealLabelManLevel,:RuleLevelNum) // 规则级别和目录级别取控制最严格的级别
	...s RuleLevel=##class(web.DHCCKBCommon).GetManLevelCodeByNum(RuleLevelNum)
	...s RuleLevelName=##class(web.DHCCKBCommon).GetDicDescByCode(RuleLevel)	// 规则级别
	...s RuleSource=$g(ProConList(Index,"Source"))								// 参考依据
	...s RuleControl=$g(ProConList(Index,"Control"))							// 管控力度
	...s LabelManLevel=$case(LabelManLevel>RuleLevelNum,1:LabelManLevel,:RuleLevelNum) // 目录级别取控制最严格的级别
	...d RuleObj.%Set("manLevel",RuleLevel).%Set("manLev",RuleLevelName)
	...d RuleObj.%Set("control",RuleControl).%Set("source",RuleSource)
	...d RuleObj.%Set("ruleID",1)
	...s RuleTipsFlag=$g(ProConList(Index))	// 根据消息输出标记,确定使用目录输出还是消息输出
	...d RuleObj.%Set("outMsgFlag",RuleTipsFlag)	// 记录标记
	...i RuleTipsFlag="Y"	d		// 按照规则提醒
	....s TmpShowArr=..GetRuleMsgObj(.ProConList,Index,Label) 		// showArr用于前台展示, ItmArr是实际的按照项目提醒的消息
	....s TmpItmArr=..GetItmMsgObj(.TmpArr,.TmpMsgArr,.ProConList,Index,Label,Item,RuleLevelName)
	....d RuleObj.%Set("itms",TmpShowArr)
	....d RuleObj.%Set("markItms",TmpItmArr)	
	...e  d
	....s TmpItmArr=..GetItmMsgObj(.TmpArr,.TmpMsgArr,.ProConList,Index,Label,Item,RuleLevelName)
	....d RuleObj.%Set("itms",TmpItmArr)
	....d RuleObj.%Set("markItms",TmpItmArr)	
	...
	...d RuleArr.%Push(RuleObj)
	...
	..
	..s LabelManLevel=$case(LabelManLevel>RealLabelManLevel,1:LabelManLevel,:RealLabelManLevel) // 目录级别取控制最严格的级别
	..s DrugManLevel=$case(DrugManLevel>LabelManLevel,1:DrugManLevel,:LabelManLevel) // 药品级别取控制最严格的级别
	..s LabelManCode=##class(web.DHCCKBCommon).GetManLevelCodeByNum(LabelManLevel)
	..s LabelLevelName=##class(web.DHCCKBCommon).GetDicDescByCode(LabelManCode)	// 规则级别
	..d LabelObj.%Set("manLevel",LabelManCode)									// 目录级别代码
	..d LabelObj.%Set("manLev",LabelLevelName) // 目录级别描述
	..d LabelObj.%Set("itms",RuleArr)		   // 规则提醒内容加入到目录中
	..d ItemsArr.%Push(LabelObj)
	.
	.s ManLevel=$case(ManLevel>DrugManLevel,1:ManLevel,:DrugManLevel) 	// 整体级别取控制最严格的级别
	.s DrugManCode=##class(web.DHCCKBCommon).GetManLevelCodeByNum(DrugManLevel)
	.s DrugLev=##class(web.DHCCKBCommon).GetManLevelCodeByNum(DrugManCode)
	.d ItemsObj.%Set("manLevel",DrugManCode)	// 药品的级别代码
	.d ItemsObj.%Set("manLev",DrugLev)			// 级别描述
	.i ItemsArr.%Size()=0 k ItemsObj
	.q:ItemsArr.%Size()=0
	.d ItemsObj.%Set("warns",ItemsArr)			// 目录提醒内容加入药品中 
	.d ItemsObj.%Set("overview",##Class(web.DHCCKBPassExt).DealOverView(libaryList))	// 概览信息 2021/5/25
	.
	.s tipsArr=[]
	.s tipsObj={}								// 药品详情内容
	.d tipsObj.%Set("AgeProp",$listtostring($g(TmpArr("AgeProp","Ext")))).%Set("Height",$listtostring($g(TmpArr("Height","Ext")))).%Set("Weight",$listtostring($g(TmpArr("Weight","Ext")))) 
	.d tipsObj.%Set("OnceDose",$listtostring(TmpArr("OnceDose"_$c(1)_Item,"Ext"))).%Set("DayDose",$select($d(TmpArr("DayDose"_$c(1)_Item,"Ext"))>0:$listtostring(TmpArr("DayDose"_$c(1)_Item,"Ext")),1:"")).%Set("DrugFreq",$listtostring(TmpArr("DrugFreq"_$c(1)_Item,"Ext"))) 	//单次剂量
	.d tipsObj.%Set("DrugPreMet",$listtostring(TmpArr("DrugPreMet"_$c(1)_Item,"Ext"))).%Set("Treatment",$listtostring(TmpArr("Treatment"_$c(1)_Item,"Ext")))
	.d tipsArr.%Push(tipsObj)
	.d ItemsObj.%Set("tips",tipsArr)		 // 详细信息
	.d MsgArr.%Push(ItemsObj)
	
	s DrugManCode=##class(web.DHCCKBCommon).GetManLevelCodeByNum(ManLevel)
	d MsgObj.%Set("passFlag",$case(MsgArr.%Size()'=0,1:0,:1))			// 通过标志
	d MsgObj.%Set("manLevel",DrugManCode)	// 级别代码
	d MsgObj.%Set("manLev",##class(web.DHCCKBCommon).GetDicDescByCode(DrugManCode))	// 级别描述
	d MsgObj.%Set("items",MsgArr)		// 整体返回信息

	s TmpArr("passFlag")=$case(MsgArr.%Size()'=0,1:0,:1)	// 监测中心使用
	s TmpArr("manLevel")=DrugManCode
	s TmpArr("manLev")=##class(web.DHCCKBCommon).GetDicDescByCode(DrugManCode)	// 级别描述

	s TmpArr("OutParams")=MsgObj.%ToJSON()
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-29
/// Descript: 		教育规则的输出信息
/// w ##class(web.DHCCKBCommon).GetRuleType()
ClassMethod InvOutResForEdu(TmpArr As %String, TmpMsgArr As %String)
{
	n (TmpArr,TmpMsgArr)

	s MsgObj={},MsgArr=[],ManLevel=0

	i '$d(TmpMsgArr("itemOrder")) d
	.d MsgObj.%Set("passFlag","1")		// 通过标志
	.d MsgObj.%Set("items",MsgArr)		// 整体返回信息	
	.s TmpArr("OutParams")=MsgObj.%ToJSON()
	
	q:'$d(TmpMsgArr("itemOrder")) ""
	
	s Item=""
	f  s Item=$o(TmpMsgArr("itemOrder",Item))  q:Item=""  d
	.s ItemsObj={}
	.s ItemID=$p(Item,$c(2),1)
	.s ItemName=$p($g(^DHCCKBCD(ItemID)),"^",2)
	.d ItemsObj.%Set("item",ItemName)	// 药品描述
	.d ItemsObj.%Set("itmID",ItemID)	// 药品id
	.d ItemsObj.%Set("unique",Item)		// 唯一标识
	.d ItemsObj.%Set("seqno",$listtostring(TmpArr("SeqNo"_$c(1)_Item)))		// 医嘱序号	
	.s ItemsArr=[]						// 药品提醒信息
	.s DrugManLevel=0					// 药品级别
	.// 目录级别提醒内容
	.s Label=""
	.f  s Label=$o(TmpMsgArr("itemOrder",Item,Label)) q:Label=""  d
	..s LabelObj={}
	..d LabelObj.%Set("key",Label)		// 目录代码
	..d LabelObj.%Set("keyname",Label)	// 目录描述
	..// 规则级别提醒内容
	..s RuleArr=[]
	..s RuleID=""
	..f  s RuleID=$o(TmpMsgArr("itemOrder",Item,Label,RuleID)) q:RuleID=""  d
	...s RuleObj={}
	...s RuleInfo=$g(TmpMsgArr("itemOrder",Item,Label,RuleID))
	...s IsPassFlag=$ListGet(RuleInfo,1)
	...//q:IsPassFlag=0	// 不通过不提醒
	...s EduText=$listget(RuleInfo,4)	// 规则中维护的提醒消息
	...s Content=""
	...s RuleSource=$listget(RuleInfo,6)	// 提示依据
	...d RuleObj.%Set("val",EduText).%Set("source",RuleSource)
	...d RuleArr.%Push(RuleObj)
	..
	..d LabelObj.%Set("itms",RuleArr)
	..d ItemsArr.%Push(LabelObj)
	.
	.d ItemsObj.%Set("warns",ItemsArr)			// 目录提醒内容加入药品中
	.s tipsArr=[]
	.s tipsObj={}								// 药品详情内容
	.d tipsObj.%Set("AgeProp",$listtostring($g(TmpArr("AgeProp","Ext")))).%Set("Height",$listtostring($g(TmpArr("Height","Ext")))).%Set("Weight",$listtostring($g(TmpArr("Weight","Ext")))) 
	.d tipsObj.%Set("OnceDose",$listtostring(TmpArr("OnceDose"_$c(1)_Item,"Ext"))).%Set("DayDose",$listtostring(TmpArr("OnceDose"_$c(1)_Item,"Ext"))).%Set("DrugFreq",$listtostring(TmpArr("DrugFreq"_$c(1)_Item,"Ext"))) 	//单次剂量
	.d tipsObj.%Set("DrugPreMet",$listtostring(TmpArr("DrugPreMet"_$c(1)_Item,"Ext"))).%Set("Treatment",$listtostring(TmpArr("Treatment"_$c(1)_Item,"Ext")))
	.d tipsArr.%Push(tipsObj)
	.d ItemsObj.%Set("tips",tipsArr)		 // 详细信息
	.d MsgArr.%Push(ItemsObj)

	d MsgObj.%Set("items",MsgArr)		// 整体返回信息	
	s TmpArr("OutParams")=MsgObj.%ToJSON()
	
	q ""
}

/// 整理消息
ClassMethod MergeMsg(ProConList, TmpMsgArr, Item, Label)
{
	n (ProConList,TmpMsgArr,Item,Label)
	
	k ProConList	
	s RuleID=""
	f  s RuleID=$o(TmpMsgArr("itemOrder",Item,Label,RuleID)) q:RuleID=""  d
	.s RuleInfo=$g(TmpMsgArr("itemOrder",Item,Label,RuleID))
	.s IsPassFlag=$ListGet(RuleInfo,1)
	.q:IsPassFlag=1	// 通过不提醒
	.s MsgTipsFlag=$ListGet(RuleInfo,8)	//  消息提醒标记,Y,不合并，直接使用维护的的消息
	.i MsgTipsFlag="Y"	d
	..d ..SetRuleNodeMsg(.ProConList,.TmpMsgArr, Item, Label, RuleID)	
	.e  d
	..s PreCondtions=$g(TmpMsgArr("PreCondtions",RuleID))		// 当前规则的前提条件
	..q:PreCondtions=""
	..d ..SetProConNodeMsg(.ProConList,.TmpMsgArr,PreCondtions,Item,Label,RuleID)	// 根据前提条件合并提醒消息

	Q ""
}

/// 获取一条规则中的计算项目,同一条规则中计算项目只出现一次
ClassMethod GetRuleItem(ItmNodeList, TmpMsgArr, Item, Label, RuleID)
{
	n (ItmNodeList,TmpMsgArr,Item, Label, RuleID)
		
	k ItmNodeList	// 先合并一条规则下,多个相同子项目的值
	s ItmNodeList=""
	s ID=""
	f  s ID=$o(TmpMsgArr("itemOrder",Item,Label,RuleID,ID))	q:ID=""  d
	.s TmpKey=$g(TmpMsgArr("itemOrder",Item,Label,RuleID,ID))
	.s Key=$p(TmpKey,"@@",1)	// 计算项目
	.s Itm=$p(TmpKey,"@@",2)	// 提醒消息(/相互作用的药品)
	.s Limit=""
	.i Itm="" d
	..i $d(^DHCCKBRD(ID)) s Limit=##class(web.DHCCKBCommon).GetRuleLimitContent(ID)	// 规则限定内容
	.e  d
	..s Limit=$case($listvalid(Itm),1:$listtostring(Itm),:Itm)
	.q:Limit=""
	.s $list(ItmNodeList(Key),*+1)=Limit

	q ""
}

/// 根据规则序号,进行消息整理(不合并)
ClassMethod SetRuleNodeMsg(ProConList, TmpMsgArr, Item, Label, RuleID)
{
	n (ProConList,TmpMsgArr,Item,Label,RuleID)
	
	s ItmNodeList=""
	d ..GetRuleItem(.ItmNodeList,.TmpMsgArr,Item, Label, RuleID)	

	s RuleInfo=$g(TmpMsgArr("itemOrder",Item,Label,RuleID))	
	s SourceRule=$listget(RuleInfo,6)	// 提示依据
	s RuleLevel=$ListGet(RuleInfo,3)		// 规则级别
	s:RuleLevel="" RuleLevel="tips"
	s LevelNum=##class(web.DHCCKBCommon).GetManLevelNum(RuleLevel)	// 目录的提示级别
	s Control=$ListGet(RuleInfo,5)		// 管制力度
	//i $listvalid(Control)=1 s Control=$listtostring(Control)
	s RuleWarnMsg=$listget(RuleInfo,4)	// 规则中维护的提醒消息

	s Key=""
	f  s Key=$o(ItmNodeList(Key))	q:Key=""  d		// 比较项目的返回值是否相同,并且是否已经出现过
	.s NewValue=$g(ItmNodeList(Key))
	.s ProConList(RuleID,"Itm",Key)=NewValue	// 此时,可以把RuleID作为前提条件的节点
	.s ProConList(RuleID,"Source")=$case(SourceRule="系统生成",1:"说明书",:SourceRule)
	.s ProConList(RuleID,"Level")=LevelNum
	.s ProConList(RuleID,"Control")=Control
	.s ProConList(RuleID,"Val")=RuleWarnMsg
	.s ProConList(RuleID)="Y"
}

/// 根据前提条件进行消息整理(合并前提条件)
ClassMethod SetProConNodeMsg(ProConList, TmpMsgArr, PreCondtions, Item, Label, RuleID)
{
	n (ProConList,TmpMsgArr,PreCondtions,Item,Label,RuleID)
	
	s ItmNodeList=""
	d ..GetRuleItem(.ItmNodeList,.TmpMsgArr,Item, Label, RuleID)	
	
	s RuleInfo=$g(TmpMsgArr("itemOrder",Item,Label,RuleID))
	s SourceRule=$listget(RuleInfo,6)	// 提示依据
	s SourceRule=$case(SourceRule="系统生成",1:"说明书",:SourceRule)	// 系统生成依据暂时显示成说明书
	s RuleLevel=$ListGet(RuleInfo,3)
	s:RuleLevel="" RuleLevel="tips"
	s LevelNum=##class(web.DHCCKBCommon).GetManLevelNum(RuleLevel)	// 目录的提示级别
	s Control=$ListGet(RuleInfo,5)		// 管制力度
	s RuleWarnMsg=$listget(RuleInfo,4)
	s IsExistFlag=$case($o(ProConList(""))'="",1:1,:0)
	s Key=""
	f  s Key=$o(ItmNodeList(Key))	q:Key=""  d		// 比较项目的返回值是否相同,并且是否已经出现过
	.s NewValue=$g(ItmNodeList(Key))
	.i IsExistFlag=0 d		// 第一次进来,直接存值	若规则无前提条件,应该怎么存在PreCondtions
	..s ProConList(PreCondtions,"Itm",Key)=NewValue
	..s ProConList(PreCondtions,"Source")=SourceRule //合并依据
	..s ProConList(PreCondtions,"Level")=$case(LevelNum>+$g(ProConList(PreCondtions,"Level")),1:LevelNum,:+$g(ProConList(PreCondtions,"Level")))
	..s ProConList(PreCondtions,"Control")=Control
	.q:IsExistFlag=0
	.s Index="",EqualFlag=0
	.f  s Index=$o(ProConList(Index)) q:Index=""  d
	..s OldSource=$g(ProConList(Index,"Source"))
	..s EqualFlag=##Class(web.DHCCKBCommonUtil).CompareEqualList(Index,PreCondtions)
	..i EqualFlag=1	d // 表示前提条件相同
	...s OldValue=$g(ProConList(Index,"Itm",Key))	
	...q:(OldValue="")&(NewValue="") 			
	...s UnionList=##Class(web.DHCCKBCommonUtil).GetUnionList(OldValue,NewValue)	// 获取返回信息的并集
	...s ProConList(PreCondtions,"Itm",Key)=UnionList	// 合并提示信息
	...s ProConList(PreCondtions,"Level")=$case(LevelNum>+$g(ProConList(PreCondtions,"Level")),1:LevelNum,:$g(ProConList(PreCondtions,"Level")))
	...
	...s UnionSource=##Class(web.DHCCKBCommonUtil).GetUnionList(OldSource,SourceRule)
	...s ProConList(PreCondtions,"Source")=UnionSource	//合并依据
	...s OldControl=$g(ProConList(PreCondtions,"Control"))
	...s UnionConttol=##Class(web.DHCCKBCommonUtil).GetUnionList(OldControl,Control)	// 管理力度
	...s ProConList(PreCondtions,"Control")=UnionConttol
	..
	..e  d
	...s ProConList(PreCondtions,"Itm",Key)=NewValue
	...s ProConList(PreCondtions,"Source")=SourceRule	//合并依据
	...s ProConList(PreCondtions,"Level")=$case(LevelNum>+$g(ProConList(PreCondtions,"Level")),1:LevelNum,:$g(ProConList(PreCondtions,"Level")))
	...s ProConList(PreCondtions,"Control")=Control		// 管制力度

	// ProConList("前提条件",项目)
}

/// Creator: 		kemaolin
/// CreateDate: 	2020-03-04
/// Descript: 		药品本身过敏规则
/// Input:			药品Itmid,项目
/// w ##class(web.DHCCKBPassNew).CheckAllergyMedical("","")
ClassMethod CheckAllergyMedical(pid, Itmid, TmpArr, TmpMsgArr)
{
	n (pid,Itmid,TmpArr,TmpMsgArr)	// 此时数组里面只有入参处理过的信息
	
	s RuleType=$g(TmpArr("Action"))	
	q:RuleType'="CheckRule" ""
	q:$g(TmpArr("globalAcc"))<=0 ""	// 全局规则的权限
	s LabelDesc="本品过敏"
	s RealItmId=$p(Itmid,$c(2),1)
	s ItmDesc=$listtostring(TmpArr("Drug",Itmid))
	s ItmDesc=$case(ItmDesc'="",1:ItmDesc,:$p($g(^DHCCKBCD(RealItmId)),"^",2))
	s AllergyValue=$g(TmpArr("HisAllergy")) ,AllergyValueExt=$g(TmpArr("HisAllergy","Ext"))
	s AllergyFlag=0	// 是否过敏

	// 药品名称
	s Ret=..CheckRepeatDrug("",ItmDesc,"",AllergyValueExt) //过敏源和药品比较
	i Ret=1 s AllergyFlag=1
	i AllergyFlag=0  d
	.s OtherValueExt=##class(web.DHCCKBCommon).GetDicSecondName(RealItmId) //获取别名
	.s Ret=..CheckRepeatDrug("",OtherValueExt,"",AllergyValueExt) //过敏源和药品别名比较
	.i Ret=1 s AllergyFlag=1
	i AllergyFlag=1  d
	.s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckAllergyMedical",pid,Itmid)=""
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid)=$lb(0,"NotPass","warn","","","","")
	.//s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R2")="DrugAllergy"_"@@"_"对"_ItmDesc_"过敏（带剂型通用名）"
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R2")="DrugAllergy"_"@@"_"患者既往对"_$case($listvalid(AllergyValueExt)=1,1:$listtostring(AllergyValueExt),:AllergyValueExt)_"过敏,"_"医嘱中"_ItmDesc_"和患者过敏源相同"
	.s TmpMsgArr("PreCondtions",Itmid)=$lb("NULL")	//前提条件
	q:AllergyFlag=1 ""	
	
	// 过敏源相同化学名
	s RepeatValue = ""
	s ItmGenerDic=##class(web.DHCCKBCommon).GetGeneralName(RealItmId,1)
	s ItmGenerDicExt=##class(web.DHCCKBCommon).GetGeneralName(RealItmId,0)
	s Ret=..CheckRepeatDrug("",ItmGenerDicExt,"",AllergyValueExt)	
	i Ret=1 s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+$lg(ItmGenerDic))),"^",2)
	i AllergyFlag=0  d
	.f k=1:1:$listlength(ItmGenerDic) q:AllergyFlag=1  d
	..s OtherDic=$listget(ItmGenerDic,k)
	..s OtherDicExt=##class(web.DHCCKBCommon).GetDicSecondName(OtherDic)	// 通用名别名
	..s Ret=..CheckRepeatDrug("",OtherDicExt,"",AllergyValueExt)	
	..i Ret=1 d
	...s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+OtherDic)),"^",2)
	i AllergyFlag=1  d
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid)=$lb(0,"NotPass","warn","","","","")
	.//s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R3")="DrugAllergy"_"@@"_"对"_ItmDesc_"过敏（通用名）"
	.i $listvalid(RepeatValue)=1 s RepeatValue = $lts(RepeatValue)
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R3")="DrugAllergy"_"@@"_"患者既往对"_$case($listvalid(AllergyValueExt)=1,1:$listtostring(AllergyValueExt),:AllergyValueExt)_"过敏,"_"医嘱中"_ItmDesc_"和患者过敏源含有相同化学名"_$case(RepeatValue'="",1:"("_RepeatValue_")",:"")
	.s TmpMsgArr("PreCondtions",Itmid)=$lb("NULL")	//前提条件
	q:AllergyFlag=1 ""

	// 过敏源相同成分
	s RepeatValue = ""
	s ItmIngr=##class(web.DHCCKBCommon).GetIngredient(RealItmId,1)
	s ItmIngrExt=##class(web.DHCCKBCommon).GetIngredient(RealItmId,0)
	s Ret=..CheckRepeatDrug("",ItmIngrExt,"",AllergyValueExt)	
	i Ret=1 s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+$lg(ItmIngr))),"^",2)
	i AllergyFlag=0  d
	.f k=1:1:$listlength(ItmIngr) q:AllergyFlag=1  d
	..s OtherDic=$list(ItmIngr,k)
	..s OtherDicExt=##class(web.DHCCKBCommon).GetDicSecondName(OtherDic)	// 成分别名
	..s Ret=..CheckRepeatDrug("",OtherDicExt,"",AllergyValueExt)	
	..i Ret=1 d
	...s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+OtherDic)),"^",2)
	i AllergyFlag=1 d 
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid)=$lb(0,"NotPass","warn","","","","")
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R4")="DrugAllergy"_"@@"_"对"_ItmDesc_"过敏（成分）"
	.i $listvalid(RepeatValue)=1 s RepeatValue = $lts(RepeatValue)
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R4") = "DrugAllergy"_"@@"_"患者既往对"_$case($listvalid(AllergyValueExt)=1,1:$listtostring(AllergyValueExt),:AllergyValueExt)_"过敏,"_"医嘱中"_ItmDesc_"和患者过敏源含有相同成分"_$case(RepeatValue'="",1:"("_RepeatValue_")",:"")
	.s TmpMsgArr("PreCondtions",Itmid)=$lb("NULL")	//前提条件
	q:AllergyFlag=1 ""
	
	//过敏源 商品名	
	s RepeatValue = ""
	s ItmProName=##class(web.DHCCKBCommon).GetProName(RealItmId,1)
	s ItmProNameExt=##class(web.DHCCKBCommon).GetProName(RealItmId,0)
	s Ret=..CheckRepeatDrug("",ItmProNameExt,"",AllergyValueExt)	
	i Ret=1 s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+$lg(ItmProName))),"^",2)
	i AllergyFlag=0  d
	.f k=1:1:$listlength(ItmProName) q:AllergyFlag=1  d
	..s OtherDic=$list(ItmProName,k)
	..s OtherDicExt=##class(web.DHCCKBCommon).GetDicSecondName(OtherDic)	// 商品名别名
	..s Ret=..CheckRepeatDrug("",OtherDicExt,"",AllergyValueExt)	
	..i Ret=1 d
	...s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+OtherDic)),"^",2)
	i AllergyFlag=1 d 
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid)=$lb(0,"NotPass","warn","","","","")
	.//s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R5")="DrugAllergy"_"@@"_"对"_ItmDesc_"过敏（商品名）"
	.i $listvalid(RepeatValue)=1 s RepeatValue = $lts(RepeatValue)
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R5") = "DrugAllergy"_"@@"_"患者既往对"_$case($listvalid(AllergyValueExt)=1,1:$listtostring(AllergyValueExt),:AllergyValueExt)_"过敏,"_"医嘱中"_ItmDesc_"和患者过敏源含有相同商品名"_$case(RepeatValue'="",1:"("_RepeatValue_")",:"")
	.s TmpMsgArr("PreCondtions",Itmid)=$lb("NULL")	//前提条件
	q:AllergyFlag=1 ""
	
	//过敏源药学分类  
	s RepeatValue = ""
	s ItmSupCat=##Class(web.DHCCKBCommon).GetPhCat(RealItmId,1) //药品所有上级分类
	s ItmSupCatExt=##Class(web.DHCCKBCommon).GetPhCat(RealItmId,0)
	s Ret=..CheckRepeatDrug("",ItmSupCatExt,"",AllergyValueExt)
	//s Ret=..CheckRepeatDrug("",ItmSupCatExt,"",AllergyValue) // 检查 是使用allergyExt 还是allergyValue 2021/3/18
	//i Ret=1 s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+$lg(ItmSupCat))),"^",2)
	i Ret=1 d
	.s AllergyFlag=1
	.s mixList = ##Class(web.DHCCKBCommonUtil).GetMixList(AllergyValueExt,ItmSupCatExt)
	.s RepeatValue = $lg(mixList)
	
	i AllergyFlag=0  d
	.f k=1:1:$listlength(ItmSupCat) q:AllergyFlag=1  d
	..s OtherDic=$list(ItmSupCat,k)
	..s OtherDicExt=##class(web.DHCCKBCommon).GetDicSecondName(OtherDic)	// 药学分类别名
	..s Ret=..CheckRepeatDrug("",OtherDicExt,"",AllergyValueExt)	
	..i Ret=1 d
	...s AllergyFlag=1,RepeatValue = $p($g(^DHCCKBCD(+OtherDic)),"^",2)
	
	i AllergyFlag=1 d 
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid)=$lb(0,"NotPass","warn","","","","")
	.//s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R6")="DrugAllergy"_"@@"_"对"_ItmDesc_"过敏（药学分类）"
	.i $listvalid(RepeatValue)=1 s RepeatValue = $lts(RepeatValue)
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid,Itmid_"R6") = "DrugAllergy"_"@@"_"患者既往对"_$case($listvalid(AllergyValueExt)=1,1:$listtostring(AllergyValueExt),:AllergyValueExt)_"过敏,"_"医嘱中"_ItmDesc_"和患者过敏源含有相同分类"_$case(RepeatValue'="",1:"("_RepeatValue_")",:"")
	.s TmpMsgArr("PreCondtions",Itmid)=$lb("NULL")	//前提条件

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-10
/// Descript: 		通过his的过敏源获取到对应知识库里面的数据(成分，分类，药品，通用名)
/// Input:			His过敏源的值
/// w ##class(web.DHCCKBPassNew).GetAllergyByHisValue("盐酸氟奋乃静片")
ClassMethod GetAllergyByHisValueOld(HisValue)
{
	n (HisValue)
		
	//i type'="" s sourceData=##class(web.DHCCKBCommon).GetDataSourceAllValue("HisAllergy")	
	
	s RetStr=""
	// 若HisValue 是药品名称,需要取药品名称id,通用名id,通用名描述,成分id,成分描述,分类id,分类描述,辅料id,辅料描述
	s DrugId=##Class(web.DHCCKBPassNew).GetComDicIdNew(HisValue,"Drug")
	i +DrugId'=0 d
	.s RetStr=DrugId
	.// 通用名
	.s ItmGenerDic=##class(web.DHCCKBCommon).GetGeneralName(DrugId,1)
	.s ItmGenerDicExt=##class(web.DHCCKBCommon).GetGeneralName(DrugId,0)
	.i ItmGenerDic'="" s RetStr=RetStr_"^"_$listtostring(ItmGenerDic,"^")
	.i ItmGenerDicExt'="" s RetStr=RetStr_"^"_$listtostring(ItmGenerDicExt,"^")
	.// 商品名
	.s ItmProName=##class(web.DHCCKBCommon).GetProName(DrugId,1)
	.s ItmProNameExt=##class(web.DHCCKBCommon).GetProName(DrugId,0)
	.i ItmProName'="" s RetStr=RetStr_"^"_$listtostring(ItmProName,"^")
	.i ItmProNameExt'="" s RetStr=RetStr_"^"_$listtostring(ItmProNameExt,"^")
	.// 成分
	.s ItmIngr=##class(web.DHCCKBCommon).GetIngredient(DrugId,1)
	.s ItmIngrExt=##class(web.DHCCKBCommon).GetIngredient(DrugId,0)
	.i ItmIngr'="" s RetStr=RetStr_"^"_$listtostring(ItmIngr,"^")
	.i ItmIngrExt'="" s RetStr=RetStr_"^"_$listtostring(ItmIngrExt,"^")
	.// 分类
	.s ItmSupCat=##Class(web.DHCCKBCommon).GetPhCat(DrugId,1) 
	.s ItmSupCatExt=##Class(web.DHCCKBCommon).GetPhCat(DrugId,0)
	.i ItmSupCat'="" s RetStr=RetStr_"^"_$listtostring(ItmSupCat,"^")
	.i ItmSupCatExt'="" s RetStr=RetStr_"^"_$listtostring(ItmSupCatExt,"^")
	.// 辅料
	.s Excipient=##Class(web.DHCCKBCommon).GetExcipient(DrugId,1)
	.s ExcipientExt=##Class(web.DHCCKBCommon).GetExcipient(DrugId,0)
	.i Excipient'="" s RetStr=RetStr_"^"_$listtostring(Excipient,"^")
	.i ExcipientExt'="" s RetStr=RetStr_"^"_$listtostring(ExcipientExt,"^")
	
	
	// 若HisValue 是分类,需要取分类id
	// 若hisValue 是成分,需要取成分id
	// 若hisValue 是辅料,需要取辅料id
	s dicID=""
	f  s dicID=$o(^DHCCKBCD(0,"Desc",$$ALPHAUP^SSUTIL4(HisValue),dicID))	q:(dicID="")  d
	.s parref=$p(^DHCCKBCD(dicID),"^",3)
	.i RetStr="" s RetStr=dicID
	.e  s RetStr=RetStr_"^"_dicID	
		
		
	q RetStr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-10
/// Descript: 		通过his的过敏源获取到对应知识库里面的数据(成分，分类，药品，通用名)
/// Input:			His过敏源的值
/// w ##class(web.DHCCKBPassNew).GetAllergyByHisValue("青霉素类")
ClassMethod GetAllergyByHisValue(HisValue)
{
	n (HisValue)
	
	s SourceDataStr=##class(web.DHCCKBCommon).GetDataSourceAllValue("HisAllergy")	
	q:SourceDataStr="" ""	// 过敏源有多个数据源  // 带剂型通用名字典,成分字典,药学分类字典,药品商品名字典,通用名字典,辅料字典

	s RetStr=""
	k RetList
	s RetList=""	
	f i=1:1:$length(SourceDataStr,"^")  d
	.s SourceData=$p(SourceDataStr,"^",i)	
	.// 通过字典id,描述,去字典中找对应的知识库id(不需要对照) 
	.s DicID=##class(web.DHCCKBCommon).GetDicIDByType(SourceData,HisValue)
	.q:+DicID=0
	.i +DicID'=0  d
	..i RetStr="" s RetStr=DicID
	..e  s RetStr=RetStr_"^"_DicID
	.s Prop=""
	.// His过敏源是医嘱项字典
	.i SourceData=##class(web.DHCCKBCommon).GetDrugData()  d   
	..s TmpStr=##Class(web.DHCCKBPassExt).GetHisAllergyForDrug(DicID)
	.// 带剂型的通用名
	.e  i SourceData=##class(web.DHCCKBCommon).GetGeneralFromData() d
	..s Prop="GenerNameFormProp" 
	.// 化学名字典
	.e  i SourceData=##class(web.DHCCKBCommon).GetGeneralData()	 d 
	..s Prop="GenerNameProp" 
	.// 商品名字典
	.e  i SourceData=##class(web.DHCCKBCommon).GetDrugProNameData()  d		
	..s Prop="ProNameProp" 
	.// 药学分类字典
	.e  i SourceData=##class(web.DHCCKBCommon).GetDrugCategoryData()	 d	 
	..s ItmCat="",ItmCatExt=""	// 对分类过敏,对该分类的子分类也过敏
	..d ##Class(web.DHCCKBCommon).GetChildCat(.ItmCat,DicID,1)
	..d ##Class(web.DHCCKBCommon).GetChildCat(.ItmCatExt,DicID,0)
	..s:ItmCat'="" RetStr=$case(RetStr="",1:$listtostring(ItmCat,"^"),:RetStr_"^"_$listtostring(ItmCat,"^"))
	..s:ItmCatExt'="" RetStr=$case(RetStr="",1:$listtostring(ItmCatExt,"^"),:RetStr_"^"_$listtostring(ItmCatExt,"^"))
	..s Prop="DrugCategory" 
	..s PropId=##class(web.DHCCKBCommon).GetDicIdByCode(Prop)
	..f Index=1:1:$listlength(ItmCat)  d
	...s ItmDrug=##Class(web.DHCCKBCommon).GetCommonDrugListByProp(PropId,$listget(ItmCat,Index),1)
	...s:ItmDrug'="" RetStr=$case(RetStr="",1:$listtostring(ItmDrug,"^"),:RetStr_"^"_$listtostring(ItmDrug,"^"))
	..
	.// 成分字典
	.e  i SourceData=##class(web.DHCCKBCommon).GetIngreData()  d	 
	..s Prop="Ingredient" 
	..s DrugList=##Class(web.DHCCKBConfig).ChangeItmFromStore("HisAllergy",Prop,DicID,"Drug")
	..s:DrugList'="" RetStr=$case(RetStr="",1:$listtostring(DrugList,"^"),:RetStr_"^"_$listtostring(DrugList,"^"))
	.// 辅料字典 
	.e  i SourceData=##class(web.DHCCKBCommon).GetExcipientData() d  
	..s Prop="ExcipientProp" 
	.
	.s TmpStr=##Class(web.DHCCKBPassExt).GetHisAllergyCommon(DicID,Prop)
	.i TmpStr'="" d
	..i RetStr="" s RetStr=TmpStr
	..e  s RetStr=RetStr_"^"_TmpStr
	
	q RetStr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-10
/// Descript: 		验证目录是否授权
/// Input:			目录id,UserInfo(医生,职称,科室,安全组,医院id)
/// OutPut:			1 授权 0 未授权
/// Other:			授权权限优先级从高到低：医生->职称->科室->安全组->医院id
/// w ##class(web.DHCCKBPassNew).Label("")
ClassMethod CheckLabelAcc(Label, UserInfo, AccFlag = "Y")
{
	n (Label,UserInfo,AccFlag)
 	///q 1
 	q:AccFlag="N" 1 // 不需要授权
	s UserId=$p(UserInfo,"^",1)
	s ProId=$p(UserInfo,"^",2)
	s LocId=$p(UserInfo,"^",3)
	s GroupId=$p(UserInfo,"^",4)
	s HospitalId=$p(UserInfo,"^",5)
	
	// UserInfo 入参中传递的是描述,配置存的是id,暂时先转换一下
	s UserId=##class(web.DHCCKBCommon).GetUserIdByDesc(UserId)
	s ProId=##class(web.DHCCKBCommon).GetProfessIdByDesc(ProId)
	s LocId=##class(web.DHCCKBCommon).GetLocIdByDesc(LocId)
	s HospitalId=##class(web.DHCCKBCommon).GetHospIdByDesc(HospitalId)

	/// DLG_Scope  U医生 C职称 L 科室 G 安全组 D全院
	s ret=0
	// 医生授权
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","U",+UserId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	q:ret'=0 ret
	
	// 职称授权
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","C",+ProId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	q:ret'=0 ret
	
	// 科室
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","L",+LocId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	q:ret'=0 ret
	
	// 安全组
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","G",+GroupId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	q:ret'=0 ret
	
	// 全院
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","D",+HospitalId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	q:ret'=0 ret
	
	q +ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-10
/// Descript: 		验证目录下的项目是否授权
/// Input:			目录id,项目id,UserInfo(医生,职称,科室,安全组,医院id)
/// OutPut:			1 授权 0 未授权
/// Other:			授权权限优先级从高到低：医生->职称->科室->安全组->医院id
/// w ##class(web.DHCCKBPassNew).Label("")
ClassMethod CheckLabelItmAcc(Label, ItmId, UserInfo, AccFlag = "Y")
{
	n (Label,ItmId,UserInfo,AccFlag)
	//q 1
	q:AccFlag="N" 1
	s UserId=$p(UserInfo,"^",1)
	s ProId=$p(UserInfo,"^",2)
	s LocId=$p(UserInfo,"^",3)
	s GroupId=$p(UserInfo,"^",4)
	s HospitalId=$p(UserInfo,"^",5)
	
	//s Parref=$case(ItmId'="",1:$p(^DHCCKBCD(ItmId),"^",3),:"")
	s Parref=$case(Label'="",1:$p(^DHCCKBCD(Label),"^",3),:"")
	s GlobalDataID=##class(web.DHCCKBCommon).GetGlobalData()
	q:Parref=GlobalDataID 1	// 全局规则默认授权
	
	s CheckListProp=##class(web.DHCCKBCommon).GetCheckItmListProp()
	q:+CheckListProp=0 0
	q:'$d(^DHCCKBDLA(0,"DicAttr",Label,CheckListProp,ItmId)) 0
	
	// 通过目录id,项目id 找到目录和项目的关联id
	s LinkID=$o(^DHCCKBDLA(0,"DicAttr",Label,CheckListProp,ItmId,""))
	q:+LinkID="" ""
	
	// UserInfo 入参中传递的是描述,配置存的是id,暂时先转换一下
	s UserId=##class(web.DHCCKBCommon).GetUserIdByDesc(UserId)
	s ProId=##class(web.DHCCKBCommon).GetProfessIdByDesc(ProId)
	s LocId=##class(web.DHCCKBCommon).GetLocIdByDesc(LocId)
	s HospitalId=##class(web.DHCCKBCommon).GetHospIdByDesc(HospitalId)
	
	/// DLG_Scope  U医生 C职称 L 科室 G 安全组 D全院
	s ret=0
	// 医生授权
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","U",+UserId,"DHC_CKBDicLinkAttr",LinkID,"businessAuth"))
	q:ret'=0 ret
	
	// 职称授权
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","C",+ProId,"DHC_CKBDicLinkAttr",LinkID,"businessAuth"))
	q:ret'=0 ret
	
	// 科室
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","L",+LocId,"DHC_CKBDicLinkAttr",LinkID,"businessAuth"))
	q:ret'=0 ret
	
	// 安全组
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","G",+GroupId,"DHC_CKBDicLinkAttr",LinkID,"businessAuth"))
	q:ret'=0 ret
	
	// 全院
	s ret=$d(^CKB.PDSS.DicLogI("SCOPE","D",+HospitalId,"DHC_CKBDicLinkAttr",LinkID,"businessAuth"))
	q:ret'=0 ret
	
	q +ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-11
/// Descript: 		组织输出内容
/// Input:			前提条件,当前检测药品,目录,目录提示信息,知识库限制内容,处方内容
/// OutPut:			1 授权 0 未授权
/// Other:			授权权限优先级从高到低：医生->职称->科室->安全组->医院id
/// w ##class(web.DHCCKBPassNew).Label("")
ClassMethod OutPutMsg(Procondtion, Key, ItemName, Label, ItmVal, Limit, OrderCont, Control = "", HisItemName = "")
{
	n (Procondtion,Key,ItemName,Label,ItmVal,Limit,OrderCont,Control,HisItemName)
	s PassList=$lb("Drug","Ingredient","DrugCategory","GenerNameProp","ProNameProp","ExcipientProp")
	if $listvalid(Control)=1 s Control=$listtostring(Control)
	s Msg=""
	i Label["配伍禁忌" d 
	.q:$listfind(PassList,Key)=0
	.s Msg=$case(ItmVal'="",1:ItmVal_". ",:ItmVal)_HisItemName_"和"_Limit_"配伍禁忌"_Control
	e  i Label["相互作用"	d	// 相互作用只需要输出A和B相互作用,若出现其他项目,则不输出
	.q:$listfind(PassList,Key)=0
	.i $listValid(Limit)=1 s Limit=$listtostring(Limit)
	.s Msg=$case(ItmVal'="",1:ItmVal_". ",:ItmVal)_HisItemName_"和"_Limit_"相互作用"_Control
	e  i Label["重复用药"	d
	.s Msg=$case(ItmVal'="",1:ItmVal_". ",:ItmVal)_Limit_Control
	e  i (Label["十八反")||(Label["十九畏")	d
	.i Limit["【" s Msg=Limit_Control
	.e  s Msg="和"_Limit_Label_Control
	e  d	// 过敏的提醒(需要加区分)	
	.s Val=$case(ItmVal'="",1:ItmVal_". ",:ItmVal)
	.s Limit=$case(Limit'="",1:"【医院协定范围】："_Limit_Control,:"")
	.s OrderCont=$case(OrderCont'="",1:"【处方内容】："_OrderCont,:"")
	.s Msg=Val_"  "_Limit_"  "_OrderCont

	q Msg
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-11
/// Descript: 		按照规则输出，组织输出信息
/// Input:			规则数组,规则序号,目录
/// OutPut:			
/// Other:			
/// w ##class(web.DHCCKBPassNew).Label("")
ClassMethod GetRuleMsgObj(ProConList, index, Label)
{
	n (ProConList,index,Label)
	k ItmObj,ItmArr
	s ItmArr=[]
	s ItmObj={}
	d ItmObj.%Set("key","Rule").%Set("keyname",index)			// 审查项目
	d ItmObj.%Set("msg","").%Set("order","").%Set("limit","")
	s LabelMsg=..GetLabelMsg(Label)	// 目录提醒内容
	s OutPutMsg=$g(ProConList(index,"Val"))
	s Control=$g(ProConList(index,"Control"))
	i $listValid(Control)=1 s Control=$listtostring(Control)
	i Control'=""  s Control="("_Control_")"
	d ItmObj.%Set("val",LabelMsg_"  "_OutPutMsg_Control)
	d ItmArr.%Push(ItmObj)
	
	q ItmArr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-11
/// Descript: 		按照计算项目输出
/// Input:			
/// OutPut:			
/// Other:		
ClassMethod GetItmMsgObj(TmpArr, TmpMsgArr, ProConList, Index, Label, Item, RuleLevelName)
{
	
	n (TmpArr,TmpMsgArr,ProConList,Index,Label,Item,RuleLevelName)
	k ItmArr
	s ItmArr=[]
	s Key=""
	f  s Key=$o(ProConList(Index,"Itm",Key)) q:Key=""  d
	.k ItmObj
	.s ItmObj={}
	.s ItmMsg=$g(ProConList(Index,"Itm",Key))	// 计算项目消息
	.s Limit=$listtostring(ItmMsg)				// 规则限定内容
	.s OrderCont=$listtostring($g(TmpArr(Key,"Ext")))			// 处方内容
	.s OrderCont=$case($listvalid(OrderCont)>0,1:$listtostring(OrderCont),:OrderCont)
	.s KeyVal=$case(Key[$c(1),1:$p(Key,$c(1),1),:Key)	// 计算项目代码
	.s KeyName=##class(web.DHCCKBCommon).GetDicDescByCode(KeyVal)
	.s:KeyName="" KeyName=KeyVal 
	.q:KeyName=""
	.s ItmVal=..GetLabelMsg(Label,KeyVal)				// 提醒内容(从项目优先级维护处获取) 
	.s ItemName=$p($g(^DHCCKBCD(+Item)),"^",2)
	.s ItemID=$p(Item,$c(2),1)
	.s HisItemName=$listtostring($g(TmpArr("Drug",Item)))
	.s:HisItemName="" HisItemName=ItemName
	.s Control=$g(ProConList(Index,"Control"))
	.i $listvalid(Control)=1 s Control=$listtostring(Control)
	.i Control'=""  s Control="("_Control_")"
	.s OutPutMsg=..OutPutMsg(Index,KeyVal,ItemName,Label,ItmVal,Limit,OrderCont,Control,HisItemName)
	.q:OutPutMsg=""
	.d ItmObj.%Set("key",KeyVal).%Set("keyname",KeyName)			// 审查项目
	.d ItmObj.%Set("msg",ItmVal).%Set("order",OrderCont).%Set("limit",Limit)
	.d ItmObj.%Set("val",OutPutMsg)
	.d ItmArr.%Push(ItmObj)
	.s TmpMsgArr("itemOrderMsg",Item,Label,Index,KeyVal)=RuleLevelName_"^"_ItmObj.val /// 记录每个问题项的提示内容 2020-03-10 bianshuai
	.
	
	q ItmArr
}

/// 获取复合条件下相关联的内容 如：溶媒浓度,获取对应的溶媒药品 ，检验范围值,获取对应的检验指标 
/// w ##Class(web.DHCCKBPassNew).GetLinkItm(81081,620858,"TogetherProp")
/// w ##Class(web.DHCCKBPassNew).GetLinkItm(64518,483195,"SolventProp")
ClassMethod GetLinkItm(ruleID, ID, searchProp)
{

	n (ruleID,ID,searchProp)
	q:ID="" ""

	s node=$p($g(^DHCCKBRD(ID)),"^",2)
	q:node="" ""

	s drugList=""
	s newID="",count=0	// and:{溶媒:药品1，浓度：10mg/ml}
	f  s newID=$o(^DHCCKBRD(0,"Node",node,newID))	q:newID=""  d
	.s leftID=$p(^DHCCKBRD(newID),"^",3)      					/// 关系指针(左)
	.i leftID'="" s leftDicCode=$p(^DHCCKBCD(leftID),"^",1)   	/// 相关实体代码
	.q:$g(leftDicCode)'=searchProp
	.s checkDicID=$p($g(^DHCCKBRD(newID)),"^",7)
	.q:checkDicID=""
	.s count=count+1
	.s $list(drugList,count)=checkDicID
	.

	s count=0		//and:{浓度：10mg/ml, and:{溶媒:药品1，药品2}}
	s newNode=""
	f  s newNode=$o(^DHCCKBRULENODE(0,"Parent",ruleID,"if",node,newNode))  q:newNode=""  d
	.s newID=""
	.f  s newID=$o(^DHCCKBRD(0,"Node",newNode,newID))	q:newID=""  d
	..s leftID=$p(^DHCCKBRD(newID),"^",3)      					/// 关系指针(左)
	..i leftID'="" s leftDicCode=$p(^DHCCKBCD(leftID),"^",1)   	/// 相关实体代码
	..q:$g(leftDicCode)'=searchProp
	..s checkDicID=$p($g(^DHCCKBRD(newID)),"^",7)
	..q:checkDicID=""
	..s count=count+1
	..s $list(drugList,count)=checkDicID
	.

	i (searchProp="TogetherProp")&(drugList="") d   // qnp  组内组间存在需要往上一个节点2020/12/18
	.s parrefNode = +$p($g(^DHCCKBRULENODE(+node)),"^",1)
	.s newID="",count=0	// and:{溶媒:药品1，浓度：10mg/ml}
	.f  s newID=$o(^DHCCKBRD(0,"Node",parrefNode,newID))	q:newID=""  d
	..s leftID=$p(^DHCCKBRD(newID),"^",3)      					/// 关系指针(左)
	..i leftID'="" s leftDicCode=$p(^DHCCKBCD(leftID),"^",1)   	/// 相关实体代码
	..q:$g(leftDicCode)'=searchProp
	..s checkDicID=$p($g(^DHCCKBRD(newID)),"^",7)
	..q:checkDicID=""
	..s count=count+1
	..s $list(drugList,count)=checkDicID
	
	q drugList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-18
/// Descript: 		判断属性(检测项目)是不是必填,必填表示要求his要传值,不必填,则通过知识库获取
/// Other:			1 是 0 否
/// w ##class(web.DHCCKBPassNew).IsRequired("DayDose")
ClassMethod IsRequired(ItmCode)
{
	n (ItmCode)
	
	s Itmid=##class(web.DHCCKBCommon).GetDicIdByCode(ItmCode)	// 属性id
	q:+Itmid=0 1
	s attrCode=##class(web.DHCCKBCommon).GetRequiredProp()		// 是否必填属性
	q:'$d(^DHCCKBDLA(0,"DicAttr",Itmid,attrCode)) 0

	s ret=0	
	s attrDr="" 
	f  s attrDr=$o(^DHCCKBDLA(0,"DicAttr",Itmid,attrCode,attrDr))  q:(attrDr="")||(ret=1)  d
	.s attrValue=$p($g(^DHCCKBCD(attrDr)),"^",1)
	.q:attrValue'="Y"
	.s:attrValue="Y" ret=1
		
	q ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-31
/// Descript: 		根据单位判断是否需要根据单位进行转化，如体重用药,体表用药
/// Other:			-1 不需要转换   其他则是转换后的值
/// 根据单位判断是否需要进行转换或者计算
ClassMethod ChangeQtyFacByUnit(UnitCode, TmpArr)
{
	n (UnitCode,TmpArr)
	
	s Fac=""
	s IsChangeFlag=0
	// 含体重单位
	i (UnitCode["/")&(($p(UnitCode,"/",2)["kg")||($p(UnitCode,"/",2)["g")) d
	.s UomWeight=$p(UnitCode,"/",2)	
	.s Weight=$g(TmpArr("Weight"))
	.i $listvalid(Weight)=1 s Weight=$listtostring(Weight)
	.s Fac=..ChangeQtyFacByWeight(Weight,UomWeight)
	.s IsChangeFlag=1
	
	// 含体表面积单位
	i (UnitCode["/")&(($p(UnitCode,"/",2)["m2")||($p(UnitCode,"/",2)["M2")) d
	.s Fac=##Class(web.DHCCKBComplexArith).CalcQty("BodyArea",.TmpArr)
	.s IsChangeFlag=1
	
	q:IsChangeFlag=1 Fac
	q:IsChangeFlag=0 -1
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-20
/// Descript: 		单次最大量/单次极限量
/// Other:			SetDayDose/SetOnceDose
ClassMethod SetOnceDose(TmpArr, Key)
{
	n (TmpArr,Key)
	s CheckID=$g(TmpArr("CheckDicID"))
	
	s TmpArr(Key_$c(1)_CheckID)=$g(TmpArr("OnceDose"_$c(1)_CheckID))
	s TmpArr(Key_$c(1)_CheckID,"Ext")=$g(TmpArr("OnceDose"_$c(1)_CheckID,"Ext"))
	s TmpArr(Key_$c(1)_CheckID,"Unit")=$g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit"))
	s TmpArr(Key_$c(1)_CheckID,"Unit","Ext")=$g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit","Ext"))
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-20
/// Descript: 		每日用药量/每日最大量/每日极限量
/// Other:			
ClassMethod SetDayDose(RulID, Key)
{
	n (TmpArr,Key)
	s CheckID=$g(TmpArr("CheckDicID"))
	
	s Qty=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID)))
	s QtyUnit=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit")))
	s QtyUnitExt=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckID,"Unit","Ext")))
	s Freq=$listtostring($g(TmpArr("DrugFreq"_$c(1)_CheckID)))
	s Fac=##Class(web.DHCCKBCommon).GetFreqFac(Freq,"次/日")
	i Fac'="" d
	.s $list(TmpArr(Key_$c(1)_CheckID))=Qty*Fac
	.s $list(TmpArr(Key_$c(1)_CheckID,"Ext"))=Qty*Fac_QtyUnitExt
	.s $list(TmpArr(Key_$c(1)_CheckID,"Unit"))=QtyUnit
	.s $list(TmpArr(Key_$c(1)_CheckID,"Unit","Ext"))=QtyUnitExt
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-03
/// Descript: 		溶媒/溶液体积
/// Input:			规则组号,规则明细id,计算项目code,入参数组,返回值数组
/// OutPut:			1 体积计算成功,并赋值   0 体积计算失败
/// Other:			
ClassMethod SetSolutionVolume(RulID, ID, CalcItm, TmpArr)
{
	n (RulID,ID,CalcItm,TmpArr)
	
	// 先判断有没有溶媒药品，在判断检测药品是不是和溶媒药品成组,之后再计算体积
	
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)

	s TmpDicID="",IsExistFlag=0,solutionItmID=""
	s DrugList=$g(TmpArr("Drug"))
	f Num=1:1:$listlength(DrugList) q:(IsExistFlag=1)  d
	.s TmpDicID=$list(DrugList,Num)
	.q:CheckDicID=TmpDicID
	.s FindItm=$select(CalcItm="Solventvolume":"SolventProp",CalcItm="SolutionVolume":"SolutionProp",1:"")
	.q:FindItm=""
	.s LinkItmID=..GetLinkItm(RulID,ID,FindItm)	// 需要找到规则中溶媒/溶液药品
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,+TmpDicID)			// 找到入参中的溶媒/溶液药品
	.s HisGroupFlag=..ISGroup(CheckDicID,TmpDicID,.TmpArr)		// 判断找到的his入参中的溶媒,是否和检测药品成组,非成组则不计算
	.q:HisGroupFlag=0
	.s IsExistFlag=1
	.s solutionItmID=TmpDicID

	q:IsExistFlag=0 0
	s HisQty=$g(TmpArr("OnceDose"_$c(1)_solutionItmID))	// his体积
	s HisQtyUom=$g(TmpArr("OnceDose"_$c(1)_solutionItmID,"Unit"))
	s HisQtyUomExt=$g(TmpArr("OnceDose"_$c(1)_solutionItmID,"Unit","Ext"))
	s TmpArr(CalcItm_$c(1)_CheckDicID)=HisQty
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Ext")=HisQty_HisQtyUomExt
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit")=HisQtyUom
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit","Ext")=HisQtyUomExt

	q 1
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-03
/// Descript: 		溶媒/溶液浓度
/// Input:			规则组号,规则明细id,计算项目code,入参数组,返回值数组
/// OutPut:			1 浓度计算成功,并赋值   0 浓度计算失败
/// Other:
/// Other:			
ClassMethod SetSolutionDensity(RulID, ID, CalcItm, TmpArr)
{
	n (RulID,ID,CalcItm,TmpArr)
			
	// 先判断有没有溶媒药品，在判断检测药品是不是和溶媒药品成组,之后再计算浓度
	
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s TmpDicID="",IsExistFlag=0,SolVolume=0,solutionItmID=""
	s DrugList=$g(TmpArr("Drug"))
	f Num=1:1:$listlength(DrugList) q:(IsExistFlag=1)  d
	.s TmpDicID=$list(DrugList,Num)
	.q:CheckDicID=TmpDicID
	.s FindItm=$select(CalcItm="SolventDensity":"SolventProp",CalcItm="SolutionDensity":"SolutionProp",1:"")
	.q:FindItm=""
	.s LinkItmID=..GetLinkItm(RulID,ID,FindItm)	// 需要找到规则中溶媒/溶液药品
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,+TmpDicID)			// 找到入参中的溶媒/溶液药品
	.s HisGroupFlag=..ISGroup(CheckDicID,TmpDicID,.TmpArr)		// 判断找到的his入参中的溶媒,是否和检测药品成组,非成组则不计算
	.q:HisGroupFlag=0
	.s IsExistFlag=1
	.s solutionItmID=TmpDicID
	q:IsExistFlag=0 0
	
	// 计算浓度
	s HisSoluteQty=$g(TmpArr("OnceDose"_$c(1)_CheckDicID))	// his溶质剂量
	s HisSoluteUom=$g(TmpArr("OnceDose"_$c(1)_CheckDicID,"Unit"))
	s HisSoluteUomDesc=$case(HisSoluteUom="",1:"",:$p(^DHCCKBCD($listGet(HisSoluteUom)),"^",2))		
	s HisSolventQty=$g(TmpArr("OnceDose"_$c(1)_solutionItmID))	// his溶媒
	s HisSolventUom=$g(TmpArr("OnceDose"_$c(1)_solutionItmID,"Unit"))
	s HisSolventUomDesc=$case(HisSolventUom="",1:"",:$p(^DHCCKBCD($listget(HisSolventUom)),"^",2))
	
	s HisDensity=$listGet(HisSoluteQty)/$listget(HisSolventQty)		// his浓度
	s HisDensityUomExt=HisSoluteUomDesc_"/"_HisSolventUomDesc
	s HisDensityUom=..GetComDicIdNew(HisDensityUomExt,"")

	// 入参赋值
	s TmpArr(CalcItm_$c(1)_CheckDicID)=$lb(HisDensity)
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Ext")=$lb(HisDensity_HisDensityUomExt)
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit")=$lb(HisDensityUom)
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit","Ext")=$lb(HisDensityUomExt)

	q 1
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-03
/// Descript: 		检验范围值
/// Other:			
ClassMethod CalcLabItmValueLimit(RulID, ID, TmpArr, TmpMsgArr)
{
	n (RulID,ID,TmpArr,TmpMsgArr)

	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s CalcItmID=$p(^DHCCKBRD(ID),"^",3)    /// 关系指针(左)
	s RulID=TmpArr("RulID")	
	s TipsPath=TmpArr("TipsPath")	
	q:(ID="")||(CheckDicID="")||(CalcItmID="")||(RulID="") 0
	s CalcItm=$p(^DHCCKBCD(CalcItmID),"^",1)   /// 检测项目
	q:(CalcItm'="LabItmValueLimitProp") -100

	s IsExistFlag=0,HisItm="",LeftKey="",CcrFlag=0 // Ccr表示计算肌酐清除率
	s LabItm=$g(TmpArr("LabItm"))	
	f Num=1:1:$listlength(LabItm)  q:IsExistFlag=1  d
	.s TmpLabItm=$list(LabItm,Num)
	.s FindItm="LabItm"
	.s LinkItmID=..GetLinkItm(RulID,ID,FindItm)	// 需要找到规则中检验项
	.q:LinkItmID=""
	.s TmpLabItmDesc=$p($g(^DHCCKBCD(+TmpLabItm)),"^",2)
	.q:'$LISTFIND(LinkItmID,+TmpLabItm)&(TmpLabItmDesc'["血肌酐")			// 找到入参中的检验项
	.s IsExistFlag=1
	.//i (TmpLabItmDesc["肌酐清除率")||(TmpLabItmDesc["内生肌酐清除率") s CcrFlag=1
	.f Count=1:1:$listlength(LinkItmID)  q:CcrFlag=1  d
	..s LinkDr=$listget(LinkItmID,Count)
	..s LinkDesc=$p($g(^DHCCKBCD(+LinkDr)),"^",2)
	..i LinkDesc["肌酐清除率"||(LinkDesc["内生肌酐清除率") s CcrFlag=1
	.s HisItm=TmpLabItm
	.s LeftKey="LabItmValueLimitProp"_$c(1)_TmpLabItm
	.i CcrFlag=1 d
	..q:$d(TmpArr(LeftKey,"RepeatValue"))	// 已经转换过则不在多次转换 2022-04-02 qnp
	..s CcrValue=..CalCreatinClearRate(.TmpArr)
	..s TmpArr(LeftKey)=$lb(CcrValue)
	..s TmpArr(LeftKey,"Ext")=$lb(CcrValue_"ml/min")
	..//s TmpArr(LeftKey,"Unit")=$lb(..GetComDicIdNew("ml/min",""))
	..s TmpArr(LeftKey,"Unit")=..GetComDicIdNew("ml/min","")
	..s TmpArr(LeftKey,"Unit","Ext")="ml/min"
	..s TmpArr(LeftKey,"RepeatValue")=""
	
	i IsExistFlag=0	d
	.s Ret=0 
	.s:LeftKey="" LeftKey="LabItmValueLimitProp"
	.d SetRetMsg
	q:IsExistFlag=0 0
	
	// 取出知识库规则值
	s LibValue=..GetSysValue(ID,.TmpArr)
	q:LibValue="" 0
	s LibValueExt=..GetSysValueExt(ID)		// 知识库别名
	s RightType=$p(^DHCCKBRD(ID),"^",9)
	
	// 取出his的值
	s UnitFlag=0
	s HisValue=$g(TmpArr(LeftKey))
	s HisValueExt=$g(TmpArr(LeftKey,"Ext"))	

	i (RightType="InputUom")||(RightType="InputLimit")	d // 区间,带单位 
	.s HisUom=($g(TmpArr(LeftKey,"Unit")))		// 如果含单位的计算，需要取出his值的单位
	.s:HisUom=$listvalid(HisUom)=1 HisUom=$listtostring(HisUom)
	.s HisUomExt=($g(TmpArr(LeftKey,"Unit","Ext")))
	.s:HisUomExt=$listvalid(HisUomExt)=1 HisUomExt=$listtostring(HisUomExt)
	.// 判断单位是否需要转换
	.s:(HisUom="")&(HisUomExt="") Ret=0
	.s newLibValue=$list(LibValue,1)
	.s:newLibValue="" Ret=0
	.s LibUom=$list(LibValue,3)
	.s:LibUom="" Ret=0
	.q:$g(Ret)=0
	.s LibUomExt=##class(web.DHCCKBCommon).GetDicSecondName(LibUom)
	.s IsChangeFlag=..CompareConstant(HisUom,HisUomExt,LibUom,LibUomExt)
	.s Fac=""							// 需要判断单位转换
	.i IsChangeFlag=0 s Fac=##class(web.DHCCKBCommonUtil).GetFactorToLib(HisUomExt,$p(^DHCCKBCD(LibUom),"^",2),+CheckDicID)
	.s:(IsChangeFlag=0)&(Fac="") Ret=0	/// 单位转换不成功
	.q:$g(Ret)=0 
	.s:Fac'="" HisValue=$case($listvalid(HisValue),1:$listtostring(HisValue)*Fac,0:HisValue*Fac)
	.s UnitFlag=1
	.s HisValue=$lb(HisValue,HisUom,HisUomExt)	
	.

	i (UnitFlag=1)&($g(Ret)=0)  d SetRetMsg
	q:(UnitFlag=1)&($g(Ret)=0) 0
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   		// 运算符
	
	//计算
	s Ret=..Compare(HisValue,HisValueExt,LibValue,LibValueExt,OpArith,RightType,.TmpArr)

	d SetRetMsg
	q Ret

SetRetMsg
	
	// 记录返回值
	s LabelDesc=..GetRuleLabelDesc(RulID)  	// 目录
	s RulID=$g(TmpArr("RulID")) 			// 规则组号
	i $g(TmpArr("RuleStype",RulID))="G" d
	.i ((TipsPath=1)&(Ret=1))||((TipsPath=0)&(Ret=0)) d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=LeftKey

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-26
/// Descript: 		当前规则中的前提条件计算项目是否通过
///  w ##Class(web.DHCCKBPassNew).TakPreConditionsNew("1831",TmpPreConsArr)
ClassMethod TakPreConditionsNew(ParentID As %String, TmpArr As %String, TmpMsgArr As %String, RuleStyle As %String) As %String
{
	n (ParentID,TmpArr,TmpMsgArr,RuleStyle)

	s RulID=$g(TmpArr("RulID"))
	s CheckDicID=$g(TmpArr("CheckDicID"))

	// 先判断本节点有没有规则值，有的情况下，先计算本节点的值
	s NodeID="",IsTrue=-1,NodeCount=0
	F  s NodeID=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",ParentID,NodeID)) Q:NodeID=""  D
	.s NodeCount=NodeCount+1
	.s RelType=$p(^DHCCKBRULENODE(NodeID),"^",2)   	// 关系类型
	.i $d(^DHCCKBRD(0,"Node",NodeID))  d
	..s NodeRet=..GetCondGroupRuleRet(NodeID,RelType,RuleStyle,.TmpArr,.TmpMsgArr)	
	..q:NodeRet=-100
	..i NodeCount=1  d
	...s IsTrue=NodeRet
	..e  d		//多个子节点之间的值进行合并(如一组频率,一组途径)
	...s ParentRelType=$p(^DHCCKBRULENODE(ParentID),"^",2)
	...s IsTrue=$Select((ParentRelType="and")||(ParentRelType="union"):IsTrue&NodeRet,ParentRelType="or":IsTrue!NodeRet)
	.e  s NodeRet=-1
	.// 计算子节点的值,将子节点和本身的值通过关系结合
	.q:'$d(^DHCCKBRULENODE(0,"Parent",RulID,"if",NodeID))	// 没有子节点
	.s SubRet=..TakPreConditionsNew(NodeID,.TmpArr,.TmpMsgArr,RuleStyle)
	.q:SubRet=-100
	.i (NodeRet=-1)&(SubRet=-1) s IsTrue=-1
	.i (NodeRet=-1)&(SubRet'=-1) s IsTrue=SubRet
	.i (NodeRet'=-1)&(SubRet=-1) s IsTrue=IsTrue
	.i (NodeRet'=-1)&(SubRet'=-1) s IsTrue=$Select((RelType="and")||(RelType="union"):IsTrue&SubRet,RelType="or":IsTrue!SubRet)

	d ..KillRuleDataMsgStr(CheckDicID,RulID,"",.TmpMsgArr)	// 前提条件审查的项目,不需要返回值
	//i IsTrue=-1 s IsTrue=0
	i IsTrue=-1 s IsTrue=-100	// -1 是被忽略的项目 2020/07/17
	q IsTrue
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-26
/// Descript: 		获取最小的一组规则分支的结果(前提条件)
/// Other:
ClassMethod GetCondGroupRuleRet(ParentID, ParRelType, RuleStyle, TmpArr, TmpMsgArr)
{
	n (ParentID,ParRelType,RuleStyle,TmpArr,TmpMsgArr)
	
	// 组规则
	s TipsPath=$g(TmpArr("TipsPath"))
	s Label=$g(TmpArr("Label"))
	s UserInfo=$g(TmpArr("UserInfo"))
	s RulID=$g(TmpArr("RulID"))
	s RuleStype=$g(TmpArr("RuleStype",RulID))
	s CheckDicID=$g(TmpArr("CheckDicID"))
	s PreList=$g(TmpMsgArr("PreCondtions",RulID))
	s ID="", IsTrue=-1,Count=0
	F  s ID=$o(^DHCCKBRD(0,"Node",ParentID,ID)) Q:ID=""  D
	.s TmpArr("ID")=ID
	.s LeftID=$p(^DHCCKBRD(ID),"^",3)    /// 关系指针(左)
	.s AccFlag = TmpArr("AccFlag") 
	.q:(RuleStype'="C")&(..CheckLabelItmAcc(Label,LeftID,UserInfo,AccFlag)<=0)		// 项目授权(子规则不看授权)
	.s CondFlag=##Class(web.DHCCKBPassExt).IsPreConditions(LeftID,RulID)	// 判断是前提条件
	.q:CondFlag'=1
	.i $listfind(PreList,LeftID)=0 s $list(PreList,*+1)=LeftID
	.s Ret=..isCorrect(.TmpArr, .TmpMsgArr)	// 1 满足(不提醒) 0 不满足(提醒)  -1 没有值的情况  -100 忽略的情况
	.d ..KillRuleDataMsgStr(CheckDicID,RulID,ID,.TmpMsgArr)	// 前提条件审查的项目,不需要返回值
	.q:Ret=-100
	.i Ret=-1 s Ret=0						// -1 认为不通过
	.s Count=Count+1
	.i Count=1	d
	..s IsTrue=Ret
	.e   d	
	..s IsTrue=$Select((ParRelType="and")||(ParRelType="union"):IsTrue&Ret,ParRelType="or":IsTrue!Ret)

	d ..KillNodeMsgStrNew(IsTrue,ParentID,.TmpArr,.TmpMsgArr)
	s TmpMsgArr("PreCondtions",RulID)=PreList
	q:IsTrue=-1 -100	// -100 表示需要忽略 2020/07/17
	q IsTrue
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBPassNew","CheckRepeatMedical",pid)
	k ^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarComposition",pid)
	;k ^TMP("web.DHCCKBPassNew","UpdateDrugListLocPassFlag",pid)
	Q ""
}

/// Input:	RuleType 区分普通规则("G" -general)和公共规则("C" -common)
/// Debug:	w ##Class(web.DHCCKBPassNew).CheckRuleProp(150, 4034, "", 75)
ClassMethod CheckRuleProp(ItmID, CheckItem, UserInfo, CheckLabel)
{
	n (ItmID,CheckItem,UserInfo,CheckLabel)
				
	s RulDicID="",flag=0,remind="",CheckItemDesc="",propDesc="",LabelDesc=""
	f  s RulDicID=$o(^DHCCKBRULEDIC(0,"Dic",ItmID,RulDicID)) q:(RulDicID="")||(flag=1)  d
	.s RulID=$p(^DHCCKBRULEDIC(RulDicID),"^",1) 	// 规则ID
	.q:$p(^DHCCKBRULE(RulID),"^",3)'="Release"  	// 未发布不加算在内
	.s LabelDesc=..GetRuleLabelDesc(RulID)			// 审查目录
	.s LabelId=..GetRuleLabelID(RulID)
	.q:LabelId'=CheckLabel
	.//q:..CheckLabelAcc(LabelId,UserInfo)'=1			// 目录授权
	.q:'$d(^DHCCKBRD(0,"RightDic","Constant",+CheckItem))
	.q:'$d(^DHCCKBRD(0,"RightDic","Constant",+CheckItem,RulID)) 
	.s flag=1
	.s rdID=$o(^DHCCKBRD(0,"RightDic","Constant",+CheckItem,RulID,""))
	.s propID= $p(^DHCCKBRD(rdID),"^",3)
	.s propDesc=$case(propID="",1:"",:$p($g(^DHCCKBCD(propID)),"^",2))
	.s CheckItemDesc=$case(CheckItem="",1:"",:$p($g(^DHCCKBCD(CheckItem)),"^",2))
	.s ParID=""
	.f  s ParID=$o(^DHCCKBRULENODE(0,"Parent",RulID,"then",0,ParID)) q:(ParID="")||(remind'="")  d
	..q:ParID=""
	..s ID=""
	..f  s ID=$o(^DHCCKBRD(0,"Node",ParID,ID)) q:(ID="")||(remind'="")  d
	...q:ID=""
	...s varCode="",varText=""
	...s LkLDicID=$p(^DHCCKBRD(ID),"^",3)
	...i +LkLDicID'=0 s varCode=$p($g(^DHCCKBCD(LkLDicID)),"^",1)   /// 实体代码
	...s LkRDicID=$p(^DHCCKBRD(ID),"^",7)
	...i +LkRDicID'=0 s varText=$p($g(^DHCCKBCD(LkRDicID)),"^",1)   /// 实体代码
	...e  s varText=$p(^DHCCKBRD(ID),"^",8)
	.../// 提示信息
	...i varCode="WarnMessage" s remind=varText

	q flag_"^"_remind_"^"_CheckItemDesc_"^"_propDesc_"^"_LabelDesc
}

/// Creator: 		kemaolin
/// CreateDate: 	2020-03-04
/// Descript: 		药品本身过敏规则
/// Input:			药品Itmid,项目
/// w ##class(web.DHCCKBPassNew).CheckPropInRule(150,4034,77,"")
/// w ##class(web.DHCCKBPassNew).CheckPropInRule(2708,50018,76,"")
ClassMethod CheckPropInRule(Itmid, checkItmId, Label, UserInfo)
{
	n (Itmid,checkItmId,Label,UserInfo)	
	
	s RuleArr=[]
	s RuleObj={}
	
	s ItmDesc=$case(Itmid="",1:"",:$p($g(^DHCCKBCD(Itmid)),"^",2))
	s checkDrugDesc=$case(checkItmId="",1:"",:$p($g(^DHCCKBCD(checkItmId)),"^",2))
	s LabelExt=$case(Label="",1:"",:$p($g(^DHCCKBCD(Label)),"^",2))
	s checkItm=checkItmId
	//药品名
	d checkRule
	// 通用名
	
	s checkItmId=##class(web.DHCCKBCommon).GetGeneralName(checkItm,1)
	d checkRule
	// 成分
	s checkItmId=##class(web.DHCCKBCommon).GetIngredient(checkItm,1)
	d checkRule	
	//商品名	
	s checkItmId=##class(web.DHCCKBCommon).GetProName(checkItm,1)
	d checkRule
	//过敏源药学分类  
	s checkItmId=##Class(web.DHCCKBCommon).GetPhCat(checkItm,1) //药品所有上级分类
	d checkRule
	
	i RuleArr.%Size()=0  d
	.d RuleObj.%Set("title",ItmDesc_"与"_checkDrugDesc_"不存在"_LabelExt)
	.d RuleArr.%Push(RuleObj)
	
	s JsonObj={}
	d JsonObj.%Set("rows",RuleArr)
	d JsonObj.%Set("total",RuleArr.%Size())
	q JsonObj.%ToJSON()
	
checkRule
	i $LISTVALID(checkItmId)=0 s checkItmId=$LISTFROMSTRING(checkItmId)
	s ptr=0,ret=0
	while $LISTNEXT(checkItmId,ptr,value){			
		s retStr= ##Class(web.DHCCKBPassNew).CheckRuleProp(Itmid, value, UserInfo, Label)
		s flag=$p(retStr,"^",1)
		s remind=$p(retStr,"^",2)
		s CheckItemDesc=$p(retStr,"^",3)
		s propDesc=$p(retStr,"^",4)
		s LabelDesc=$p(retStr,"^",5)
		i flag=1  d
		.d RuleObj.%Set("title",remind)   ;ItmDesc_"与"_checkDrugDesc_"("_propDesc_"："_CheckItemDesc_")存在"_LabelExt)
		.d RuleObj.%Set("remind",remind)
		.d RuleArr.%Push(RuleObj)
	}
}

/// Descript:判断药品成分规则
/// Creator:sufan
/// CreateDate:2020-05-29
/// Input:itmId-药品id
/// w ##Class(web.DHCCKBPassNew).CheckdrugIngres(13439711,92719,"","")
ClassMethod CheckdrugIngres(pid, itmId, TmpArr, TmpMsgArr)
{
	n (pid, itmId, TmpArr, TmpMsgArr)
	
	s RuleType=$g(TmpArr("Action"))	
	q:RuleType'="CheckRule" ""
	
	/****先取成分*****/
	s incId = $p(itmId,$c(2),1)
	s ingredient = ##class(web.DHCCKBCommon).GetDrugIngredient()					//成分
	s linkPropId = ##class(web.DHCCKBCommon).GetLinkProp()							//属性关联
	s ingredientData = ##class(web.DHCCKBCommon).GetIngreData()						//成分字典
	s linkAttrId = $o(^DHCCKBDLA(0,"LinkDicAttrCode",ingredient,linkPropId,""))		//关联的属性Id
	s parrPorpId =$p(^DHCCKBDLA(linkAttrId),"^",3)									//成分属性
	s count = 0
	s subId = ""
	for  s subId = $o(^DHCCKBCD(0,"Parref",parrPorpId,subId))  Q:subId=""  d		//取成分模板
	.s attrId = ""
	.for  s attrId = $o(^DHCCKBDLA(0,"LinkDicAttrCode",incId,subId,attrId))  Q:attrId=""  d
	..s dicAttrId = $p(^DHCCKBDLA(attrId),"^",3)									//成分值
	..Q:dicAttrId=""
	..s parrDicId = ..GetDicParrefId(dicAttrId)										//取元素上级
	..Q:parrDicId'=ingredientData													//非成分不进行判断
	..Q:'$d(^DHCCKBRULEDIC(0,"Dic",dicAttrId))										//判断是否存在规则
	..s count = $listtostring(TmpArr("SeqNo"_$c(1)_itmId))
	..s dicAttrId = dicAttrId_$c(2)_count
	..;d ..SetIngresTemp(dicAttrId,count)    										//组织成分数组
	..s $list(TmpArr("FormProp"_$c(1)_dicAttrId))=""								// 剂型
	..s $list(TmpArr("FormProp"_$c(1)_dicAttrId,"Ext"))=""
	..s $list(TmpArr("DrugPreMet"_$c(1)_dicAttrId))=""								// 给药途径
	..s $list(TmpArr("DrugPreMet"_$c(1)_dicAttrId,"Ext"))=""
	..s $list(TmpArr("OnceDose"_$c(1)_dicAttrId))=""								// 单次剂量
	..s $list(TmpArr("OnceDose"_$c(1)_dicAttrId,"Ext"))=""
	..s $list(TmpArr("OnceDose"_$c(1)_dicAttrId,"Unit"))=""							// 单次剂量单位
	..s $list(TmpArr("OnceDose"_$c(1)_dicAttrId,"Unit","Ext"))=""
	..s $list(TmpArr("DrugFreq"_$c(1)_dicAttrId))=""								// 频率
	..s $list(TmpArr("DrugFreq"_$c(1)_dicAttrId,"Ext"))=""			
	..s $list(TmpArr("Treatment"_$c(1)_dicAttrId))=""								// 疗程
	..s $list(TmpArr("Treatment"_$c(1)_dicAttrId,"Ext"))=""	
	..s $list(TmpArr("Treatment"_$c(1)_dicAttrId,"Unit"))=""						// 疗程单位
	..s $list(TmpArr("Treatment"_$c(1)_dicAttrId,"Unit","Ext"))=""
	..s $list(TmpArr("LinkSeqNo"_$c(1)_dicAttrId))=""
	..s $list(TmpArr("SeqNo"_$c(1)_dicAttrId))=count
	..s $list(TmpArr("IsFirstUseProp"_$c(1)_dicAttrId))=""
	..s $list(TmpArr("OrdDate"_$c(1)_dicAttrId))=""			     					//医嘱日期
	..s $list(TmpArr("DrugSpeedProp"_$c(1)_dicAttrId))=""							//给药速度
	..s $list(TmpArr("DrugSpeedProp"_$c(1)_dicAttrId,"Ext"))=""
	..s $list(TmpArr("DrugSpeedProp"_$c(1)_dicAttrId,"Unit"))=""					//给药速度
	..s $list(TmpArr("DrugSpeedProp"_$c(1)_dicAttrId,"Unit","Ext"))=""
	..s $list(TmpArr("IngreDrug"_$c(1)_itmId))=dicAttrId
	..s $list(TmpArr("IngreDrug"_$c(1)_dicAttrId))=itmId							//记录药品成分
	..d ..CheckRule(dicAttrId, .TmpArr, .TmpMsgArr)									//调用规则判断
	Q ""
}

/// Descript:根据元素Id，取元素字典Id
/// Creator:sufan
/// CreateDate:2020-05-29
/// Input:元素Id
/// Output：字典Id
/// w ##class(web.DHCCKBPassNew).GetDicParrefId(4844)
ClassMethod GetDicParrefId(dicId)
{
	n (dicId)
	s parrefId = $p($g(^DHCCKBCD(dicId)),"^",3)
	i parrefId'="" d
	.s prentId = ..GetDicParrefId(parrefId)
	e  s prentId = dicId
	Q prentId
}

/// Descript:根据d
/// Creator:sufan
/// CreateDate:2020-05-29
/// Input:元素Id
/// Output：字典Id
/// w ##class(web.DHCCKBPassNew).GetDrugLibaryParref(75038)
ClassMethod GetDrugLibaryParref(dicId)
{
	n (dicId)
	
	s drugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s parref = $p($g(^DHCCKBCD(+dicId)),"^",3)
	q:parref="" dicId
	q:parref=drugLibaryData drugLibaryData
	
	q ..GetDrugLibaryParref(parref)
}

/// Descript:转换计算项目(入参中只准备了西药疾病、西药节点，没有对应的中医节点，将中医的转成西医)
/// Creator:qunianpeng
/// CreateDate:2020-07-16
/// Input:计算项目代码
/// Output：转换后计算项目代码
/// w ##class(web.DHCCKBPassNew)ChangeClacIem(75038)
ClassMethod ChangeClacIem(ClacIem)
{
	n (ClacIem)
	q $select(ClacIem="DiseaseDesc":"Disease",ClacIem="ChineseDisease":"Disease",ClacIem="ChineseDiseaseName":"Disease",ClacIem="ChineseDrug":"Drug",1:ClacIem)
}

/// Descript:	规则中有不审查标记,则整条规则不提醒.并清除掉记录的提醒内容
/// Creator:	qunianpeng
/// CreateDate:	2020-10-12
/// w ##class(web.DHCCKBPassNew).CleanIgnoreRuleMsg(75038)
ClassMethod CleanIgnoreRuleMsg(TmpArr, TmpMsgArr)
{
	n (TmpArr,TmpMsgArr)
	S CheckDicID=$g(TmpArr("CheckDicID"))
	s LabelDesc=$g(TmpArr("LabelDesc"))
	s RulID=$g(TmpArr("RulID"))

	i (CheckDicID'="")&(LabelDesc'="")&(RulID'="") d
	.i $g(TmpArr("RuleID",RulID))=1 d
	..k TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID)

	q ""
}

/// Descript:	全局规则的权限
/// Creator:	qunianpeng
/// CreateDate:	2020-10-12
/// w ##Class(web.DHCCKBPassNew).CheckGlobalAcc("李慧颖^主任医师^yxb-药学部^安全用药智能决策^哈尔滨医科大学附属第一医院")
ClassMethod CheckGlobalAcc(UserInfo)
{

	n (UserInfo)
	q 1
	s UserId=$p(UserInfo,"^",1)
	s ProId=$p(UserInfo,"^",2)
	s LocId=$p(UserInfo,"^",3)
	s GroupId=$p(UserInfo,"^",4)
	s HospitalId=$p(UserInfo,"^",5)
	
	// UserInfo 入参中传递的是描述,配置存的是id,暂时先转换一下
	s UserId=##class(web.DHCCKBCommon).GetUserIdByDesc(UserId)
	s ProId=##class(web.DHCCKBCommon).GetProfessIdByDesc(ProId)
	s LocId=##class(web.DHCCKBCommon).GetLocIdByDesc(LocId)
	s HospitalId=##class(web.DHCCKBCommon).GetHospIdByDesc(HospitalId)

	/// DLG_Scope  U医生 C职称 L 科室 G 安全组 D全院
	s ret=0
	// 此处改进,遍历目录
	// 医生授权
	s Label=""
	f  s Label=$o(^CKB.PDSS.DicLogI("SCOPE","U",+UserId,"DHC_CKBCommonDiction",Label)) q:(Label="")||(ret'=0)  d
	.s Parref=$p($g(^DHCCKBCD(+Label)),"^",3)
	.q:(Parref'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(Parref'=##class(web.DHCCKBCommon).GetDrugEduProp())
	.s ret=$d(^CKB.PDSS.DicLogI("SCOPE","U",+UserId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	.q:ret'=0
	q:ret>0 1

	// 职称授权
	s Label=""
	f  s Label=$o(^CKB.PDSS.DicLogI("SCOPE","C",+ProId,"DHC_CKBCommonDiction",Label)) q:(Label="")||(ret'=0)  d
	.s Parref=$p($g(^DHCCKBCD(+Label)),"^",3)
	.q:(Parref'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(Parref'=##class(web.DHCCKBCommon).GetDrugEduProp())
	.s ret=$d(^CKB.PDSS.DicLogI("SCOPE","C",+ProId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	.q:ret'=0
	q:ret>0 1

	// 科室
	s Label=""
	f  s Label=$o(^CKB.PDSS.DicLogI("SCOPE","L",+LocId,"DHC_CKBCommonDiction",Label)) q:(Label="")||(ret'=0)  d
	.s Parref=$p($g(^DHCCKBCD(+Label)),"^",3)
	.q:(Parref'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(Parref'=##class(web.DHCCKBCommon).GetDrugEduProp())
	.s ret=$d(^CKB.PDSS.DicLogI("SCOPE","L",+LocId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	.q:ret'=0
	q:ret>0 1

	// 安全组
	s Label=""
	f  s Label=$o(^CKB.PDSS.DicLogI("SCOPE","G",+GroupId,"DHC_CKBCommonDiction",Label)) q:(Label="")||(ret'=0)  d
	.s Parref=$p($g(^DHCCKBCD(+Label)),"^",3)
	.q:(Parref'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(Parref'=##class(web.DHCCKBCommon).GetDrugEduProp())
	.s ret=$d(^CKB.PDSS.DicLogI("SCOPE","G",+GroupId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	.q:ret'=0
	q:ret>0 1

	// 全院 此处慢
	/*s Label=""
	f  s Label=$o(^CKB.PDSS.DicLogI("SCOPE","D",+HospitalId,"DHC_CKBCommonDiction",Label)) q:(Label="")||(ret'=0)  d
	.s Parref=$p($g(^DHCCKBCD(+Label)),"^",3)
	.q:(Parref'=##class(web.DHCCKBCommon).GetDrugLibaryData())&(Parref'=##class(web.DHCCKBCommon).GetDrugEduProp())
	.s ret=$d(^CKB.PDSS.DicLogI("SCOPE","D",+HospitalId,"DHC_CKBCommonDiction",Label,"businessAuth"))
	.q:ret'=0
	*/
	q +ret
}

/// Descript:根据要学分类判断科室审查列表-科室
/// Creator:sunhuiyong
/// CreateDate:2021-05-25
/// Input:PatLoc
/// Output：0：此科室无审查列表（默认全审查）  1：此科室有审查列表
/// w ##class(web.DHCCKBPassNew).IsLocPass("儿科")
ClassMethod IsLocPass(PatLoc)
{
	n (PatLoc)
	//审查科室是否授权
	s LocPass=0  //0：此科室无审查列表（默认全审查）  1：此科室有审查列表
	s Parref=##class(web.DHCCKBCommon).GetDrugLocList() //单科室审查下的所有列表   
	s AcList="",DicID=""
	f  s DicID= $o(^DHCCKBCD(0,"Parref",Parref,DicID)) q:DicID=""  d
	.s StopID=0
	.F  s StopID=$o(^CKB.PDSS.DicLogI("DLGDataDr",DicID,StopID)) Q:StopID=""  D
	..s Scope= $lg(^CKB.PDSS.DicLogD(StopID),8)
	..s ScopeValue= $lg(^CKB.PDSS.DicLogD(StopID),9)
	..q:"DHC_CKBCommonDiction"'=$lg(^CKB.PDSS.DicLogD(StopID),2)
	..s:Scope="L" ScopeValueData= $P($g(^CTLOC(+ScopeValue)),"^",2)
	..s:Scope="" ScopeValueData=""
	..s:ScopeValueData=PatLoc LocPass=1
	q LocPass
}

/// Descript:根据要学分类判断科室审查列表
/// Creator:sunhuiyong
/// CreateDate:2021-05-25
/// Input:PatLoc、DrugList
/// Output：
/// w ##class(web.DHCCKBPassNew).UpdateDrugList("儿科",1)
ClassMethod UpdateDrugList(PatLoc, Pid)
{
	n (PatLoc,Pid)
	//审查科室是否授权
	s LocPassFlag=..IsLocPass(PatLoc)
	s ^TMP("web.DHCCKBPassNew","UpdateDrugListLocPassFlag",Pid)=LocPassFlag
	s ^TMP("web.DHCCKBPassNew","UpdateDrugList",Pid)=""
	q:LocPassFlag=0 0   //全审查
	//获取审查列表
	s Parref=##class(web.DHCCKBCommon).GetDrugLocList() //单科室审查下的所有列表   
	s DrugList="",DicID=""
	f  s DicID= $o(^DHCCKBCD(0,"Parref",Parref,DicID)) q:DicID=""  d
	.s DrugCatId=DicID
    .s DrugCat=$p(^DHCCKBCD(DrugCatId),"^",2)
	.s LinkId= $p(^DHCCKBCD(DrugCatId),"^",4)
	.i (DrugCat="")&&(LinkId'="") s DrugCat=$p(^DHCCKBCD(LinkId),"^",2)
	.s DrugDictionId=##class(web.DHCCKBCommon).GetDrugData()			//默认是西药药品字典
	.s DrugCatAttrId=##class(web.DHCCKBCommon).GetPhCategory()		//药学分类属性
	.s Id=""
	.for  s Id=$o(^DHCCKBCD(0,"Parref",DrugDictionId,Id)) Q:Id=""  d
	..s Code=$p(^DHCCKBCD(Id),"^",1)   		//药品代码
	..s Desc=$p(^DHCCKBCD(Id),"^",2)   		//药品描述
	..Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	..s QuitList=Code_"@"_Desc
	..s CatDesc=##class(web.DHCCKBEditProp).QueryAttrValue(Id,DrugCatAttrId)
	..Q:('##class(web.DHCCKBDiction).IsInclude(CatDesc,DrugCat))  //已选
	..s:DrugList'="" DrugList=DrugList_"^"_QuitList
	..s:DrugList="" DrugList=QuitList
	..s ^TMP("web.DHCCKBPassNew","UpdateDrugList",Pid)=DrugList
	
	
	
	//所有对照药品比对--过滤掉不审查药品-存临时Glb
	;s ItmList=$g(TmpArr("Drug"))
	;f i=1:1:$listlength(ItmList) d
	;.s Itmid=$list(ItmList,i)
	;.q:+Itmid=0
	;.i (DrugList'[$p(DHCCKBCD(Itmid),"^",1))&&(DrugList'[$p(DHCCKBCD(Itmid),"^",2))  d
	;.s:^TMP("web.DHCCKBPassNew","UpdateDrugList",Pid)="" ^TMP("web.DHCCKBPassNew","UpdateDrugList",Pid)=Itmid
	;.s:^TMP("web.DHCCKBPassNew","UpdateDrugList",Pid)'="" ^TMP("web.DHCCKBPassNew","UpdateDrugList",Pid)=^TMP("web.DHCCKBPassNew","UpdateDrugList",Pid)_"^"_Itmid
	
	q ""
}

/// Creator:		xww
/// CreatDate:		2021-12-16
/// Description:： 	获取药品的带剂型的通用名
/// Input:			DicID药品id, 
/// Other:	w ##class(web.DHCCKBCommon).GetSolutionDensity(3784,1)
ClassMethod GetSolutionDensity(CheckDicID, LinkDicID, TmpArr) As %String
{
	n (CheckDicID, LinkDicID, TmpArr)
	s CheckOnceDose=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckDicID)))
	s ItmOnceDose=$listtostring($g(TmpArr("OnceDose"_$c(1)_LinkDicID)))
	s CheckUnitExt=$listtostring($g(TmpArr("OnceDose"_$c(1)_CheckDicID,"Unit","Ext")))
	s ItmUnitExt=$listtostring($g(TmpArr("OnceDose"_$c(1)_LinkDicID,"Unit","Ext")))
	// 获取药品的带剂型通用名	
	s ListData=""
	i +ItmOnceDose'=0 d
	.s $List(ListData,*+1)=$fn(CheckOnceDose/ItmOnceDose,"",5)
	.s $List(ListData,*+1)=CheckUnitExt_"/"_ItmUnitExt
	
	Q ListData
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-27
/// Description: 使用药品->目录->规则的关系结构进行规则审查
/// Input:  
ClassMethod CheckRuleByLibary(ItmID, TmpArr, TmpMsgArr, TmpAgainArr = "")
{
	
	n (ItmID,TmpArr,TmpMsgArr,TmpAgainArr)
	s UserInfo=$g(TmpArr("UserInfo"))
	s RepeatFlag = $g(TmpMsgArr("RepeatModel"))

	/**取成分对应的药品sufan**/
	/****s CheckItmID=ItmID***/
	i $d(TmpArr("IngreDrug"_$c(1)_ItmID))  d
	.s IngreDrug = $listtostring(TmpArr("IngreDrug"_$c(1)_ItmID))
	.i IngreDrug'="" s CheckItmID = IngreDrug
	.e  s CheckItmID = ItmID
	e  s CheckItmID = ItmID
	s ItmID=$p(ItmID,$c(2),1)
	s RuleType=$g(TmpArr("Action"))	
	s TmpArr("CalcItm")=CheckItmID
	s UsageId=##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")		// 用法目录
	s ChildFlag = $g(TmpArr("PatChildFlag"))
	
	K LabelArr
	//^User.DHCCKBDrugLibaryRefI("DrugLibRule",DLRDrugDr,DLRLibaryDr,DLRRuleDr,ID)
	s LibaryList=""
	i $o(TmpAgainArr(""))'="" d
	.s LibaryList = $g(TmpAgainArr("libaryList"))
	.s:$g(TmpAgainArr("orgItmID"))'="" ItmID =$g(TmpAgainArr("orgItmID"))
	e  s LibaryList = ##class(web.DHCCKBCommon).GetSortLibaryList(RuleType)

	f i=1:1:$ll(LibaryList)  d
	.s LabelId = $lg(LibaryList,i)
	.s LabelDesc=$p(^DHCCKBCD(LabelId),"^",2)			// 审查目录
	.q:(RepeatFlag'="")&&(LabelDesc'["相互作用")	// 历史医嘱只审核相互作用
	.s RulID = ""
	.f  s RulID = $o(^User.DHCCKBDrugLibaryRefI("DrugLibRule",ItmID,LabelId,RulID))  q:RulID=""  d
	..s IsFailFlag=1	// 默认通过
	..//q:RulID'=70432
	..Q:$p($g(^DHCCKBRULE(+RulID)),"^",3)'="Release"  	// 未发布不加算在内
	..q:..isChildRule(RulID)=1						// 审查项目本身有子规则,不审子规则
	..s ReMark = $p(^DHCCKBRULE(RulID),"^",1)
	..s ReName = $p(^DHCCKBRULE(RulID),"^",2)
	..q:(UsageId=LabelId)&&(ChildFlag=1)&&((ReMark'["儿童")&&(ReName'["儿童"))  // 过滤非儿童的兜底规则 qnp 2022-04-26
	..q:(UsageId=LabelId)&&(ChildFlag'=1)&&((ReMark["儿童")||(ReName["儿童"))	// // 过滤非成人的兜底规则
	..s TmpArr("RulID")=RulID 
	..s TmpArr("TipsPath")=..GetLabelTipsPath(RulID)	// 提醒方向
	..s TmpArr("CheckDicID")=CheckItmID
	..s TmpArr("RuleStype",RulID)="G"	
	..s LabelLinkDr=$p($g(^DHCCKBCD(+LabelId)),"^",4)
	..s LabRuleType="" //##class(web.DHCCKBCommon).GetRuleType(LabelId)	// 规则类型
	..s TmpArr("Label")=LabelId
	..s AccFlag = $g(TmpArr("AccFlag"))
	..//q:..CheckLabelAcc(LabelId,UserInfo)'=1			// 目录授权
	..q:..CheckLabelAcc(LabelId,UserInfo,AccFlag)<=0			// 目录授权
	..s TmpArr("LabelDesc")=LabelDesc
	..q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,$p(CheckItmID,$c(2),1),LabelId,"D") // qnp 2020/1/14 判断目录是否有忽略配置
	..s SkinProp= ##class(web.DHCCKBDrugVO).GetDicValueByPro($p(CheckItmID,$c(2),1),##class(web.DHCCKBCommon).GetSkinTestDrugProp())
	..q:(LabelDesc="皮试用药")&((SkinProp'="Y")||($lg(TmpArr("DrugPreMet"_$c(1)_CheckItmID,"Ext"))'="皮试"))
	..q:((LabelDesc="用法用量")||(LabelDesc="用法"))&(SkinProp="Y")&($lg(TmpArr("DrugPreMet"_$c(1)_CheckItmID,"Ext"))="皮试")
	..q:LabelDesc="不良反应"							// 不良反应不判断，后期从目录授权中取配置
	..q:(LabelDesc="适应症")||(LabelDesc="超说明书适应症")||(LabelDesc="功能主治")||(LabelDesc="用药指导")||(LabelDesc="适应性")
	..s ComDosageId=##class(web.DHCCKBCommon).GetComDosageProp()
	..//q:((LabelId=ComDosageId)||(LabelLinkDr=ComDosageId))&($d(TmpMsgArr("itemOrder",CheckItmID,"用法用量")))	// 用法用量目录通过是用法目录的前提条件 --用法用量和兜底规则规则都需要计算 qnp 2022-04-25
	..s LabelRule=..GetLabelRule(LabelDesc)			// 目录的判断规则 
	..q:(LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	// 限定目录有一条通过则通过时，条件若满足，则不进行其他的判断
	..q:(LabRuleType'="")&(RuleType'=LabRuleType)	// 区分审查规则和教育规则
	..s NodeID=0
	..s IsPreCondFlag=..TakPreConditionsNew(NodeID,.TmpArr,.TmpMsgArr,"G")
	..s PreList=$g(TmpMsgArr("PreCondtions",RulID))
	..s PreList=$listtostring(PreList)
	..s CondFlag=$Case((PreList="")||(PreList="NULL"),1:0,:1)	// 1 有前提条件,0没有前提条件
	..q:(CondFlag=1)&(IsPreCondFlag=0) 
	..i CondFlag=0  s TmpMsgArr("PreCondtions",RulID)=$lb("NULL")	// 无前提
	..s TmpArr("RulID")=RulID 						// 判断条件时,若有引用规则，那么RulID会被改变，此时需要重新赋值
	..//s NodeID=0
	..q:'$d(^DHCCKBRULENODE(0,"Parent",RulID,"if",NodeID))		// 无规则
	..s RuleFlag=..InvRuleData(NodeID,.TmpArr,.TmpMsgArr,"G")
	..s IgnoreRule=$g(TmpArr("RuleID",RulID))					// 规则中有忽略的，忽略整条规则 2020/10/12 
	..i IgnoreRule=1 d ..CleanIgnoreRuleMsg(.TmpArr,.TmpMsgArr)	// 清除规则的忽略信息
	..q:IgnoreRule=1
	..//q:RuleFlag=-1	
	..i RuleFlag=-1 s RuleFlag=0
	..s RuleFlag=$case(TmpArr("TipsPath"),1:'RuleFlag,:RuleFlag)		// 根据计算方向 禁忌反向
	..i RuleFlag=1 k TmpMsgArr("itemOrder",CheckItmID,LabelDesc,RulID)	// 规则通过，则清空规则的
	..s TmpArr("IndicatJud",CheckItmID,LabelDesc,RuleFlag) = RuleFlag	// sufan  2022-04-29 记录目录的通过条件
	..s LabelArr(CheckItmID,LabelDesc,RuleFlag)=RuleFlag		
	..i (LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	d // 一条通过则通过, 清除掉目录的返回值
	...k TmpMsgArr("itemOrder",CheckItmID,LabelDesc)
	..i (LabelRule=0)&&($d(TmpArr("IndicatJud",CheckItmID,LabelDesc,1)))&&(LabelDesc="适应症")	d // 一条通过则通过, 清除掉目录的返回值
	...k TmpMsgArr("itemOrder",CheckItmID,LabelDesc)		
	..s IsFailFlag=RuleFlag
	..q:IsFailFlag=1
	..D ..ReaOutData(IsFailFlag, .TmpArr,.TmpMsgArr)	// 一组结果的输出
}

}

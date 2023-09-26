Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-20
/// Descript: 		安全用药智能决策系统
Class web.DHCCKBPass Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  安全用药智能审查	// 性别，特殊人群
/// w ##Class(web.DHCCKBPass).IntMakPolPass("{""PatName"":""王明飞"",""PatSex"":""男"",""PatBDay"":""1984-10-16"",""Height"":""170"",""Weight"":"""",""SpecGrps"":[""老年人""],""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""15"",""Item"":"""",""id"":""itemDis"",""item"":""上呼吸道感染""},{""Warn"":""88"",""Item"":"""",""id"":""itemDis"",""item"":""社区获得性肺炎""},{""Warn"":""95"",""Item"":"""",""id"":""itemDis"",""item"":""2型糖尿病""},{""Warn"":""140"",""Item"":"""",""id"":""itemDis"",""item"":""高胆固醇血症""}],""itemLab"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""162"",""SeqNo"":""1"",""PhDesc"":""磷酸西格列汀片"",""PForm"":""片剂"",""DosQty"":""100"",""DosUom"":""mg"",""Instr"":""口服"",""Freq"":""每日1次"",""Duration"":""1个月"",""LinkSeqNo"":""1"",""id"":""itemOrder""},{""Warn"":""165"",""SeqNo"":""2"",""PhDesc"":""盐酸莫西沙星注射液"",""PForm"":""水针剂"",""DosQty"":""0.4"",""DosUom"":""g"",""Instr"":""静脉滴注"",""Freq"":""每日1次"",""Duration"":""5天"",""LinkSeqNo"":""2"",""id"":""itemOrder""},{""Warn"":""171"",""SeqNo"":""3"",""PhDesc"":""注射用头孢米诺钠"",""PForm"":""粉针剂"",""DosQty"":""0.5"",""DosUom"":""g"",""Instr"":""静脉滴注"",""Freq"":""每12小时1次"",""Duration"":""5天"",""LinkSeqNo"":""3"",""id"":""itemOrder""},{""Warn"":""174"",""SeqNo"":""4"",""PhDesc"":""甲地高辛片"",""PForm"":""片剂"",""DosQty"":""100"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""每日1次"",""Duration"":""1个月"",""LinkSeqNo"":""4"",""id"":""itemOrder""},{""Warn"":""175"",""SeqNo"":""5"",""PhDesc"":""阿托伐他汀钙片"",""PForm"":""片剂"",""DosQty"":""40"",""DosUom"":"""",""Instr"":""口服"",""Freq"":""每日1次"",""Duration"":"""",""LinkSeqNo"":""5"",""id"":""itemOrder""},{""Warn"":""724"",""SeqNo"":""6"",""PhDesc"":""依帕司他片"",""PForm"":""片剂"",""DosQty"":""50"",""DosUom"":""毫克"",""Instr"":""口服"",""Freq"":""每日3次"",""Duration"":"""",""LinkSeqNo"":""6"",""id"":""itemOrder""},{""Warn"":""740"",""SeqNo"":""7"",""PhDesc"":""盐酸吗啡片"",""PForm"":""片剂"",""DosQty"":""200"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""q6h"",""Duration"":"""",""LinkSeqNo"":""7"",""id"":""itemOrder""}]}")
/// w ##Class(web.DHCCKBPass).IntMakPolPass("{""PatName"":""fxktest"",""PatSex"":""女"",""PatBDay"":""2000-01-01"",""Height"":""163"",""Weight"":"""",""SpecGrps"":[""成人""],""PreFlag"":"""",""itemAyg"":[{""Warn"":""28"",""Item"":"""",""id"":""itemAyg""}],""itemDis"":[{""Warn"":""133"",""Item"":"""",""id"":""itemDis"",""item"":""骨关节炎""},{""Warn"":""134"",""Item"":"""",""id"":""itemDis"",""item"":""病毒性肺炎""},{""Warn"":""150"",""Item"":"""",""id"":""itemDis"",""item"":""上呼吸道感染""}],""itemLab"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""525"",""SeqNo"":""2"",""PhDesc"":""利巴韦林注射液"",""PForm"":""注射剂"",""DosQty"":""0.25"",""DosUom"":""g"",""Instr"":""静脉滴注"",""Freq"":""每日2次"",""Duration"":""1"",""LinkSeqNo"":""2.2"",""id"":""itemOrder""},{""Warn"":""526"",""SeqNo"":""2"",""PhDesc"":""5%葡萄糖注射液"",""PForm"":""注射剂"",""DosQty"":""200"",""DosUom"":""ml"",""Instr"":""静脉滴注"",""Freq"":""每日2次"",""Duration"":""1"",""LinkSeqNo"":""2"",""id"":""itemOrder""},{""Warn"":""551"",""SeqNo"":""3"",""PhDesc"":""罗红霉素缓释片"",""PForm"":""片剂"",""DosQty"":""2"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""每日2次"",""Duration"":""1"",""LinkSeqNo"":""3"",""id"":""itemOrder""},{""Warn"":""552"",""SeqNo"":""4"",""PhDesc"":""甲磺酸溴隐亭片"",""PForm"":""片剂"",""DosQty"":""1"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""每日1次"",""Duration"":""1"",""LinkSeqNo"":""4"",""id"":""itemOrder""}]}")
/// w ##Class(web.DHCCKBPass).IntMakPolPass("{"PatName":"ACE","PatSex":"男性","PatBDay":"1980-01-05","Weight":"","itemAyg":[],"itemDis":[],"itemOrder":[{"Warn":401884,"SeqNo":401884,"LinkSeqNo":"","PhDesc":"维生素AD滴剂（胶囊型）","PForm":"","DosQty":"200","DosUom":"g","Instr":"口服","Freq":"每日1次","Duration":"1天","id":"itemOrder"}]}")  
/// w ##Class(web.DHCCKBPass).IntMakPolPass("{""PatName"":""fxktest20191223"",""PatSex"":""女"",""PatBDay"":""1989-1 2-31"",""Height"":""163"",""Weight"":"""",""SpecGrps"":[""孕妇""],""PreFlag"":"""",""itemAyg"":[{""Warn"":""52"",""Item"":"""",""id"":""itemAyg"",""item"":""青霉素""}],""itemDis"":[{""Warn"":""166"",""Item"":"""",""id"":""itemDis"",""item"":""急性单纯性淋病""}],""itemLab"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""687"",""SeqNo"":""1"",""PhDesc"":""阿莫西林颗粒"",""PForm"":""颗粒剂"",""DosQty"":""0.5"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""q6h"",""Duration"":""7"",""LinkSeqNo"":""1"",""id"":""itemOrder""}]}")
/// w ##Class(web.DHCCKBPass).IntMakPolPass("{""PatName"":""fxktest20191223"",""PatSex"":""女"",""PatBDay"":""1989-1 2-31"",""Height"":""163"",""Weight"":"""",""SpecGrps"":[""孕妇""],""ProFess"":""  "",""PreFlag"":"""",""itemAyg"":[],""itemDis"":[{""Warn"":""445"",""Item"":"""",""id"":""itemDis"",""item"":""产褥期心功能不全""}],""itemLab"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""687"",""SeqNo"":""1"",""PhDesc"":""注射用苯巴比妥钠"",""PForm"":""粉针剂"",""DosQty"":""100"",""DosUom"":""g"",""Instr"":""口服"",""Freq"":""q6h"",""Duration"":""7"",""LinkSeqNo"":""1"",""id"":""itemOrder""}]}")
ClassMethod IntMakPolPass(jsParamObj As %String) As %String
{
	n (jsParamObj)
	s jsParamObj=$tr(jsParamObj," ","")

	/// 错误陷阱
	//s $ZT="ErrMsg"
	s ^TMPMonitor("Monitor")=jsParamObj
	k TmpArr, TmpMsgArr
	//Ts

	/// 知识库审查
	s TmpArr("InParams")=jsParamObj
	D ##Class(web.DHCCKBPass).InvIntExam(.TmpArr, .TmpMsgArr)

	/// 监测中心
	//D ##Class(web.DHCCKBMonitor).InsMonitor(.TmpArr)
	
	//TC
	Q $g(TmpArr("OutParams"))
ErrMsg
	//Tro
	//D ..TakErrMsg("-99^审查出错！"_$ze)
	Q ""
}

/// Descript: 智能审查
/// W ##Class(web.DHCCKBPass).InvIntExam("")
ClassMethod InvIntExam(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	
	/// 错误陷阱
	//s $ZT="ErrorMessage"
	/// 解析json参数
	D ..TrsInsTmpArr(..TrsToArrs($g(TmpArr("InParams"))), .TmpArr)

	/// 调用智能决策(知识库审查)
	D ..IntMakPol(.TmpArr, .TmpMsgArr)

	/// 结果输出
	D ..InvOutRes(.TmpArr, .TmpMsgArr)

	Q ""

ErrorMessage
	D ..TakErrMsg("-99^审查出错！")
	Q ""
}

/// Descript:  解析json参数；转成 %ArrayOfDataTypes
ClassMethod TrsToArrs(jsParamObj As %String) As %ArrayOfDataTypes
{
	n (jsParamObj)
	s jsParamObj=$replace(jsParamObj,""""_""""""""_"""",""""_""""_"""")
	s TmpStream=##Class(%Stream.GlobalCharacter).%New()
 	Do TmpStream.Write(jsParamObj)
 	s objJson = ##Class(EMRservice.Parser.Json).%New()
	s array = objJson.Deserialize(TmpStream)
	Q array
}

/// Descript:  转成 %ArrayOfDataTypes
ClassMethod TrsInsTmpArr(arrsObj As %ArrayOfDataTypes, TmpArr) As %String
{
	n (arrsObj, TmpArr)

	/// 医生信息
	s TmpArr("CarePrvID")="118"					     /// 医生
	s TmpArr("DocLocID")="114"   	                 /// 科室
	/// 病人信息
	s TmpArr("PatName")=arrsObj.GetAt("PatName") 	 /// 姓名
	s TmpArr("PatSex")=arrsObj.GetAt("PatSex") 	     /// 性别
	s TmpArr("PatBDay")=arrsObj.GetAt("PatBDay") 	 /// 出生日期
#;	s TmpArr("PatAge")=arrsObj.GetAt("PatAge")     	 /// 年龄
#;	s TmpArr("PatAgeUnit")=arrsObj.GetAt("PatAgeUnit")  /// 年龄单位
	s TmpArr("Height")=arrsObj.GetAt("Height")   	 /// 身高
	s TmpArr("Weight")=arrsObj.GetAt("Weight")   	 /// 体重
	s TmpArr("Liver")=arrsObj.GetAt("Liver")   	     /// 肝损状态
	s TmpArr("Renal")=arrsObj.GetAt("Renal")   	     /// 肾损状态
	s SpecGrps = arrsObj.GetAt("SpecGrps")   /// 特殊人群
	s TmpArr("PreFlag")=arrsObj.GetAt("PreFlag")   	 /// 怀孕
	s itemAyg = arrsObj.GetAt("itemAyg")             /// 过敏源
	s TmpArr("ProFess")=..GetComDicId(arrsObj.GetAt("ProFess"))	/// 职业
	
	i SpecGrps'=""  d
	.s Total=SpecGrps.Count()
	.f i=1:1:Total d
	..s itmid=..GetComDicId(SpecGrps.GetAt(i))
	..s TmpArr("SpecGrps")=$s($g(TmpArr("SpecGrps"))="":itmid,1:TmpArr("SpecGrps")_"^"_itmid)
	.
	s TmpArr("SpecGrps")=$LISTFROMSTRING($g(TmpArr("SpecGrps")),"^")
	
	i itemAyg'="" D
	.s Total=itemAyg.Count()
	.F i=1:1:Total D
	..s itmid=..GetComDicId(itemAyg.GetAt(i).GetAt("item"))   /// 过敏-根据描述取字典ID
	..s TmpArr("itemAyg")=$s($g(TmpArr("itemAyg"))="":itmid,1:TmpArr("itemAyg")_"^"_itmid)
	.
	s TmpArr("itemAyg")=$LISTFROMSTRING($g(TmpArr("itemAyg")),"^")
	
	s itemDis = arrsObj.GetAt("itemDis")             /// 疾病诊断
	
	i itemDis'="" D
	.s Total=itemDis.Count()
	.F i=1:1:Total D
	..s itmid=..GetComDicId(itemDis.GetAt(i).GetAt("item"))   /// 疾病-根据描述取字典ID
	..s TmpArr("itemDis")=$s($g(TmpArr("itemDis"))="":itmid,1:TmpArr("itemDis")_"^"_itmid)
	.
	
	s TmpArr("itemDis")=$LISTFROMSTRING($g(TmpArr("itemDis")),"^")
	
	
	s itemOper = arrsObj.GetAt("itemOper")             /// 手术
	i itemOper'="" D
	.s Total=itemOper.Count()
	.F i=1:1:Total D
	..s TmpArr("itemOper")=$s($g(TmpArr("itemOper"))="":itemOper.GetAt(i).GetAt("item"),1:TmpArr("itemOper")_"^"_itemOper.GetAt(i).GetAt("item"))
	.
	s TmpArr("itemOper")=$LISTFROMSTRING($g(TmpArr("itemOper")),"^")
	
	s itemLab = arrsObj.GetAt("itemLab")              /// 检验
	i itemLab'="" D
	.s Total=itemLab.Count()
	.F i=1:1:Total D
	..s labItem=itemLab.GetAt(i).GetAt("item")
	..s itmid=..GetComDicId(labItem)   /// 检验-根据描述取字典ID
	..//Q:itmid=""  /// 知识库未维护
	..i itmid'="" d
	...s TmpArr("itemLab",itmid,"Item")=itemLab.GetAt(i).GetAt("item")
	...s TmpArr("itemLab",itmid,"Val")=itemLab.GetAt(i).GetAt("Val")
	...//s TmpArr("itemLab",itmid,"Min")=itemLab.GetAt(i).GetAt("Min")
	...s TmpArr("itemLab",itmid,"Uom")=itemLab.GetAt(i).GetAt("Uom")
	..e  d
	...s TmpArr("itemLab",labItem,"Item")=itemLab.GetAt(i).GetAt("item")
	...s TmpArr("itemLab",labItem,"Val")=itemLab.GetAt(i).GetAt("Val")
	...//s TmpArr("itemLab",itmid,"Min")=itemLab.GetAt(i).GetAt("Min")
	...s TmpArr("itemLab",labItem,"Uom")=itemLab.GetAt(i).GetAt("Uom")
	.	
	s itemOrder = arrsObj.GetAt("itemOrder")         /// 处方信息
	i itemOrder'="" D
	.s Total=itemOrder.Count()
	.F i=1:1:Total D
	..s itmid=..GetComDicId(itemOrder.GetAt(i).GetAt("PhDesc"))   /// 药品-根据描述取字典ID
	..Q:itmid=""  /// 知识库未维护
	..s TmpArr("itemOrder",itmid,"Unique")=itemOrder.GetAt(i).GetAt("Warn")       /// 唯一标识
	..s TmpArr("itemOrder",itmid,"PhDesc")=itemOrder.GetAt(i).GetAt("PhDesc")     /// 药物名称
	..s TmpArr("itemOrder",itmid,"PForm")=..GetComDicId(itemOrder.GetAt(i).GetAt("PForm"))       /// 药物剂型
	..s TmpArr("itemOrder",itmid,"Instr")=..GetComDicId(itemOrder.GetAt(i).GetAt("Instr"))       /// 给药方式
	..s TmpArr("itemOrder",itmid,"Freq")=..GetComDicId(itemOrder.GetAt(i).GetAt("Freq"))         /// 给药频次
	..s TmpArr("itemOrder",itmid,"Duration")=itemOrder.GetAt(i).GetAt("Duration") /// 给药疗程
	..s TmpArr("itemOrder",itmid,"DosQty")=itemOrder.GetAt(i).GetAt("DosQty")     /// 单次剂量
	..s TmpArr("itemOrder",itmid,"DosUom")=..GetComDicId(itemOrder.GetAt(i).GetAt("DosUom"))     /// 剂量单位
	..s TmpArr("itemOrder",itmid,"SeqNo")=itemOrder.GetAt(i).GetAt("LinkSeqNo")   /// 序号
	.

	Q ""
}

/// Descript:  初始化知识库输出
/// w ##Class(web.DHCCKBPass).TakToOutputMsg()
ClassMethod TakToOutputMsg(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	
	k TmpManLevelArr

	s CheckDicID=""
	F  s CheckDicID=$o(TmpArr("itemOrder",CheckDicID)) Q:CheckDicID=""  D
	.//s mListData=TmpArr("itemOrder",itmid,"Unique")_"^"_TmpArr("itemOrder",itmid,"PhDesc")_"^remind"
	.k TmpDrugLevelArr
	.s LabelDesc=""
	.q:'$d(TmpMsgArr("itemOrder",CheckDicID))
	.f  s LabelDesc=$o(TmpMsgArr("itemOrder",CheckDicID,LabelDesc))  q:LabelDesc=""  d
	..q:$p($g(TmpMsgArr("itemOrder",CheckDicID,LabelDesc)),"^",1)=1	// 目录通过标记
	..s RuleID=""
	..f  s RuleID=$o(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RuleID))  q:RuleID=""  d
	...s RuleLevel=$p($g(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RuleID)),"^",2)	// 目录下 每条规则的级别
	...s RuleLevelNum=##class(web.DHCCKBCommon).GetManLevelNum(RuleLevel)
	...s TmpDrugLevelArr(RuleLevelNum)=RuleLevelNum	
	..
	.
	.q:'$d(TmpDrugLevelArr)
	.s DrugManLevel=$o(TmpDrugLevelArr(""),-1)		// 药品的级别
	.s TmpManLevelArr(DrugManLevel)=##class(web.DHCCKBCommon).GetManLevelCodeByNum(DrugManLevel)	// 整体级别
	.s mListData=TmpArr("itemOrder",CheckDicID,"Unique")_"^"_TmpArr("itemOrder",CheckDicID,"PhDesc")_"^"_$g(TmpManLevelArr(DrugManLevel))
	.s TmpMsgArr("itemOrder",CheckDicID)=mListData		
	s TmpMsgArr("manLevel")=$case($g(TmpManLevelArr),"":"tips",:##class(web.DHCCKBCommon).GetManLevelCodeByNum($o(TmpManLevelArr(""),-1)))	// 最终的级别
	s TmpMsgArr("passFlag")=1  /// 默认通过标志

	k TmpManLevelArr

	Q ""
}

/// Descript:	审查时根据描述取知识库字典ID
ClassMethod GetComDicId(itemcode As %String) As %String
{
	n (itemcode)
	Q:itemcode="" ""
	s itemcode=##class(web.DHCCKBPass).GetKnowBaseCode(itemcode)
	Q:itemcode="" ""
	s itmid=$o(^DHCCKBCD(0,"Desc",$$ALPHAUP^SSUTIL4(itemcode),""))  /// 按描述
	//s itmid=$o(^DHCCKBCD(0,"Code",$$ALPHAUP^SSUTIL4(itemcode),"")) /// 按代码
	Q itmid
}

/// Descript:	规则分类代码
/// w ##Class(web.DHCCKBPass).GetRuleTypeCode("1522")
ClassMethod GetRuleTypeCode(ID As %String) As %String
{
	n (ID)
	s TypeID=$p(^DHCCKBRULE(ID),"^",5)  /// 规则类型
	Q:TypeID="" ""
	s Type=$p(^DHCCKBCD(TypeID),"^",1)  /// 实体描述
	Q Type
}

/// Descript:	规则分类描述
/// w ##Class(web.DHCCKBPass).GetRuleTypeDesc("1522")
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

///  Descript:  根据出生日期获取年龄
///  w ##Class(web.DHCCKBPass).GetAge("2019-01-01")
ClassMethod GetAge(argBirthday As %String) As %String
{
	 n (argBirthday)
	 s argBirthday=$zdh(argBirthday,3)
	 s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
	 s tmpAge=$$CalAge^at182(argBirthday,+$h)
	 i (tmpAge'="")&&($l(tmpAge,"|")'<14) D
	 .s ageYears=$p(tmpAge,"|",12)
	 .s ageMonths=$p(tmpAge,"|",13)
	 .s ageDays=$p(tmpAge,"|",14)
	 Q ageYears
}

///  Descript:  当前规则是否有前置条件
///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    0 - 没有、1-有
///  w ##Class(web.DHCCKBPass).TakPreConditions("13865","")
ClassMethod TakPreConditions(RulID As %String, TmpPreConsArr) As %String
{
	n (RulID, TmpPreConsArr)
	k TmpPreConsArr
	/// 当前规则前置条件
	s Libary=0
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
	...s LeftDic=$p(^DHCCKBRD(RulDataID),"^",3)	// 实体/属性
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

///  Descript:  当前规则前置条件是否满足
///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    0 - 不满足、1-满足
///  w ##Class(web.DHCCKBPass).isPreConditions("69", .TmpPreConsArr, .TmpArr)
ClassMethod isPreConditions(RulID As %String, TmpPreConsArr, TmpArr, TmpMsgArr) As %String
{
	n (RulID, TmpPreConsArr, TmpArr,TmpMsgArr)
	
	Q:'$D(TmpPreConsArr("PropType")) 0        /// 当前规则类型未设置前置条件

	/// 当前规则定义是否满足所有的前置条件
	//s TipsPath=..GetLabelTipsPath(RulID)	/// 提醒方向
	s RulDataID="", isFlag=1,isTrue=""
	F  s RulDataID=$o(TmpPreConsArr("PropType",RulID,RulDataID)) Q:(RulDataID="")  D
	.s TmpArr("ID")=RulDataID
	.s RuleNode=$p(^DHCCKBRD(RulDataID),"^",2)
	.s NodeCondition=$p(^DHCCKBRULENODE(RuleNode),"^",2)	
	.s Ret=..isCorrect(.TmpArr, .TmpMsgArr) //1 满足 0 不满足（用法用量） 1 不过 0 过（禁忌症）
	.i NodeCondition="and" s TmpNodeArr(RuleNode,NodeCondition)=$g(TmpNodeArr(RuleNode,NodeCondition))&Ret	
	.i NodeCondition="or"  s TmpNodeArr(RuleNode,NodeCondition)=$g(TmpNodeArr(RuleNode,NodeCondition))!Ret	// 一组前提条件中,关系为or,则表示满足一个即可。如前提条件是人群。规则中有两个人群的或者
	.q:Ret=1
	.q:$g(TmpNodeArr(RuleNode,NodeCondition))=""
	.q:$g(TmpNodeArr(RuleNode,NodeCondition))=1
	.//q:$d(TmpNodeArr(RuleNode))&($g(TmpNodeArr(RuleNode))="or")
	.s isFlag=0
	.d ..KillRuleDataMsgStr(RulID,RulDataID,.TmpMsgArr)	// 用法用量等于1 没有返回值    禁忌症等于1,有返回值，需要清除返回值
	
	k TmpNodeArr
	Q isFlag
}

///  Descript:  当前规则条件是否可用
///  Table:	    DHC_CKBDicLinkAttr、DHC_CKBRuleData
///  Output:    0 - 没有、1-有
///  w ##Class(web.DHCCKBPass).isEnabled("69", .TmpPreConsArr)
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
///  w ##Class(web.DHCCKBPass).IntMakPol("63", .TmpArr)
ClassMethod IntMakPol(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	
	b  //11
	s itmid=""
	F  s itmid=$o(TmpArr("itemOrder",itmid)) Q:itmid=""  D
	.// 先判断药品有没有规则,药品有规则，则使用药品的规则,药品无规则,则使用药品的分类规则
	.s isExistFlag=##class(web.DHCCKBCommon).IsExistRule(itmid)
	.//s isExistFlag=0
	.i isExistFlag=0 d
	..s drugCatID=##class(web.DHCCKBCommon).GetPhCategory()
	..q:+drugCatID=0
	..q:'$d(^DHCCKBDLA(0,"LinkDicAttrCode",itmid,drugCatID))
	..s linkDr=""
	..f  s linkDr=$o(^DHCCKBDLA(0,"LinkDicAttrCode",itmid,drugCatID,linkDr))  q:linkDr=""  d
	...s drugCat=$p(^DHCCKBDLA(linkDr),"^",3)
	...q:+drugCat=0
	...k LabelArr
	...d ..CheckRule(drugCat,itmid,.TmpArr,.TmpMsgArr,.LabelArr)
	.e  d				// 药品规则
	..b  //22
	..k LabelArr
	..d ..CheckRule("",itmid,.TmpArr, .TmpMsgArr,.LabelArr)
	
	k LabelArr
	Q ""
}

///  Descript:  遍历规则
///  Input:     node - 节点,RelType - 关系类型(and,or)
///  Output:    0 - 不符合规则、1-符合规则
///  w ##Class(web.DHCCKBPass).InvRuleData("", "", .TmpArr)
ClassMethod InvRuleData(ParentID As %String, ParRelType As %String, TmpArr, TmpMsgArr, RuleStyle = "G") As %String
{
	n (ParentID, ParRelType,TmpArr,TmpMsgArr,RuleStyle)

	s RulID=$g(TmpArr("RulID"))
	b:RulID=13865   //33
	/// 关联关系
	s ID="", isGrpTrue=""
	F  s ID=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",ParentID,ID)) Q:ID=""  D
	.s RelType=$p(^DHCCKBRULENODE(ID),"^",2) /// 关系类型
	.s tmpIsGrpTrue=..InvRuleData(ID,RelType,.TmpArr,.TmpMsgArr,RuleStyle)
	.i ParRelType="and" s isGrpTrue=$case(isGrpTrue,"":1,:isGrpTrue)&tmpIsGrpTrue
	.i ParRelType="or"  s isGrpTrue=isGrpTrue!tmpIsGrpTrue	
	.//d ..KillNodeMsgStr(RulID,isGrpTrue,ID,.TmpMsgArr)

	/// 组规则
	s ID="", isTrueArr="", isTrue=""
	F  s ID=$o(^DHCCKBRD(0,"Node",ParentID,ID)) Q:ID=""  D
	.s TmpArr("ID")=ID
	.s tmpIsTrue=..isCorrect(.TmpArr, .TmpMsgArr)
	.q:tmpIsTrue=-1
	.i ParRelType="and" s isTrue=$case(isTrue,"":1,:isTrue)&tmpIsTrue
	.i ParRelType="or"  s isTrue=isTrue!tmpIsTrue
	.i RuleStyle="G" d
	..d ..KillNodeMsgStr(RulID,isTrue,ParentID,.TmpArr,.TmpMsgArr)	// 项目的返回值在icCorrect中已经进行了存储,对于用法用量等or关系的,此时需要把返回值处理掉

	s flag=$d(^DHCCKBRULENODE(0,"Parent",RulID,"if",ParentID))
	q:flag $case(ParRelType,"and":isGrpTrue&$case(isTrue,"":1,:isTrue),"or":isGrpTrue!isTrue)
	q:isTrue="" -1
	q isTrue
}

///  Descript:  准备输出数据
///  Other: 输出信息组成：程序拼写提示(错误+正确用法)+错误提醒+进一步说明
///  w ##Class(web.DHCCKBPass).ReaOutData("984","1",.TmpMsgArr)
ClassMethod ReaOutData(RulID As %String, isFailFlag As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, isFailFlag,TmpArr, TmpMsgArr)

	s LabelCode=..GetRuleLabelCode(RulID)      /// 目录代码
	s LabelDesc=..GetRuleLabelDesc(RulID)      /// 目录描述
	s CheckDicID=TmpArr("CheckDicID") //..GetDicByRuleID(RulID)	   /// 实例
	s TipsPathFlag=##Class(web.DHCCKBPass).GetLabelTipsPath(RulID)	// 正反向
	//i (TipsPathFlag=1)&(isFailFlag=0) s isFailFlag='isFailFlag	// 禁忌症不通过时取if中的返回信息
	//s OutType=$s(isFailFlag=0:"else",1:"then")     /// 输出类型
	s Msg=$Select( ((TipsPathFlag=1)&(isFailFlag=0)) || ((TipsPathFlag=0)&(isFailFlag=1)) :"(进一步说明)",1:"")

	q:(isFailFlag=1) ""
	// 取值： 禁忌 1 返回值类型then     进一步说明else
	// 			   0  返回值类型then    进一步说明else
	//		  用法 1  返回值类型else   进一步说明else
	//			   0 返回值类型 else   进一步说明then
	s OutType=$select(TipsPathFlag=1:"then",TipsPathFlag=0:"else")	
	s ExLanOutType=$select(TipsPathFlag=1:"else",TipsPathFlag=0:"then")	
	s ExlanMsg=..GetExlanMsg(RulID,ExLanOutType)
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
	../// 管理级别
	..i varCode="LevelFlag" D			
	...s $p(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID),"^",2)=varText
	../// 通过标识
	..i varCode="PassFlag" D
	...s $p(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID),"^",1)=varText
	../// 提示信息
	..i varCode="WarnMessage" D
	...s $p(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID),"^",3)=$case((varText=""),1:ExlanMsg,:varText_";"_ExlanMsg) 
	.

	i $d(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID))  d
	.s $p(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID),"^",4)=isFailFlag	// 实际是否通过
		
	Q ""
}

///  Descript:  将文字描述转换成具体的运算符
/// ##class(web.DHCCKBPass).TrsOpArith()
ClassMethod TrsOpArith(OpArith As %String) As %String
{
	n (OpArith)
	/// 运算符号转换
	s OpArith=$s(OpArith="Equals":"=",OpArith="GreaterThen":">",OpArith="LessThen":"<",OpArith="LessThenEquals":"<=",OpArith="GreaterThenEquals":">=",OpArith="Between":"L",OpArith="NotEquals":"'=",1:"")
	Q OpArith
}

///  Descript:  验证条件
///  Output:    0 - 不匹配、1 - 匹配	-1 忽略
///  w ##Class(web.DHCCKBPass).isCorrect("", "", .TmpArr)
ClassMethod isCorrect(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	
	s ID=$g(TmpArr("ID"))				// 规则明细id
	q:ID="" -1
	s LeftDicCode=""
	s LeftID=$p(^DHCCKBRD(ID),"^",3)      /// 关系指针(左)
	i LeftID'="" s LeftDicCode=$p(^DHCCKBCD(LeftID),"^",1)   /// 相关实体代码
	//Q:..isEnabled(LeftDicCode) -1          /// 当前规则条件是否可用
	s tmpRule=TmpArr("RulID")

	/// 应该增加条件判断，如年龄没有维护时，则直接不检测年龄项目
	/// 除外列：表示除了列出来的那个内容，其他的内容都可以用。 因此含有除外列时，要考虑比值符号
	
	/// 1 带剂型的通用名+成组				
	i LeftDicCode="Drug" Q ..isMutEff(.TmpArr, .TmpMsgArr)
	
	/// 2 疾病(含除外的疾病)
	i (LeftDicCode="Disease") Q ..isPermitDis(.TmpArr, .TmpMsgArr)
	
	/// 3 年龄
	i LeftDicCode="AgeProp" Q ..isPermitAge(.TmpArr, .TmpMsgArr) 
	
	/// 4 特殊人群
	i LeftDicCode="SpecialPop" Q ..isSpecialPop(.TmpArr, .TmpMsgArr) 
	
	/// 5 性别
	i LeftDicCode="SexProp" Q ..isPermitSex(.TmpArr, .TmpMsgArr) 
	
	/// 6 体重
	i LeftDicCode="Weight" Q ..isPermitWeight(.TmpArr, .TmpMsgArr) 
	
	/// 7 药品 给药途径
	i LeftDicCode="DrugPreMet" Q ..isPermitPhaProp(.TmpArr, .TmpMsgArr)  
	
	/// 8 药品频率 
	i LeftDicCode="DrugFreq" Q ..isPermitFreq(.TmpArr, .TmpMsgArr)
	
	/// 9 单次给药剂量
	i LeftDicCode="OnceDose" Q ..isPermitDosQty(.TmpArr, .TmpMsgArr)  
	
	/// 10 单次最大量
	i LeftDicCode="OnceDoseMax" Q ..isPermitOnceDoseMax(.TmpArr, .TmpMsgArr)
	
	/// 11 单次极量 
	i LeftDicCode="OnceDoseLimit" Q ..isPermitOnceDoseLimit(.TmpArr, .TmpMsgArr)
	
	/// 12 药品每日用药量
	i LeftDicCode="DayDose" Q ..isPermitDayDose(.TmpArr, .TmpMsgArr) 
	
	/// 13 药品每日最大量
	i LeftDicCode="DayDoseMax" Q ..isPermitDayMaxDose(.TmpArr, .TmpMsgArr)
	
	/// 14 药品每日极量
	i LeftDicCode="DayDoseLimit" Q ..isPermitDayDoseLimit(.TmpArr, .TmpMsgArr)
	
	/// 15 药学分类(含除外的分类)
	i LeftDicCode="DrugCategory" Q ..isPermitDrugCat(.TmpArr, .TmpMsgArr)
	
	/// 16 成分（含除外的成分）
	i LeftDicCode="Ingredient" Q ..isPermitIngredient(.TmpArr, .TmpMsgArr)

	/// 17 过敏史  
	i LeftDicCode="HisAllergy" Q ..isTakPatAgy(.TmpArr, .TmpMsgArr)	

	/// 18 检验指标 
	i LeftDicCode="LabItm" Q ..isLabItm(.TmpArr, .TmpMsgArr)	

	/// 19 检验指标值(未测试--在检验指标中取检验指标,可能会存在问题)带完善
	i LeftDicCode="LabItmValueLimitProp" Q ..isLabItmValueLimitProp(.TmpArr, .TmpMsgArr)	

	/// 20 细菌(包含除外)
	i LeftDicCode="Bacteria" Q ..isBacteria(.TmpArr, .TmpMsgArr)	
	
	/// 21 菌属
	i LeftDicCode="BacteriaCat" Q ..isBacteriaCat(.TmpArr, .TmpMsgArr)	
	
	/// 22 症状(含除外症状)
	i LeftDicCode="Symptom" Q ..isSymptom(.TmpArr, .TmpMsgArr)	
	
	/// 23 溶媒	
	i LeftDicCode="SolventProp" Q ..isSolventProp(.TmpArr, .TmpMsgArr)	
	
	/// 24 溶媒浓度
	i LeftDicCode="SolventDensity" Q ..isSolventDensity(.TmpArr, .TmpMsgArr)
	
	/// 25 溶媒体积
	i LeftDicCode="Solventvolume"  Q ..isSolventVolumeProp(.TmpArr, .TmpMsgArr)
	
	/// 26 溶液
	i LeftDicCode="SolutionProp"  Q ..isSolutionProp(.TmpArr, .TmpMsgArr)
	
	/// 27 溶液浓度
	i LeftDicCode="SolutionDensity" Q ..isSolutionDensity(.TmpArr, .TmpMsgArr)
	
	/// 28 溶液体积 
	i LeftDicCode="SolutionVolume"  Q ..isSolutionVolumeProp(.TmpArr, .TmpMsgArr)
	
	/// 29 疗程
	i LeftDicCode="Treatment" Q ..isPermitDuration(.TmpArr, .TmpMsgArr) 
	
	/// 30 首次用药是否首次
	
	/// 31 疗程间隔
	
	/// 32 疗程内间隔
	
	/// 33 职业 ok
	i LeftDicCode="ProfessProp" Q ..isProfessProp(.TmpArr, .TmpMsgArr)	
		
	/// 34 给药速度
	i LeftDicCode="DurgSpeedProp" Q ..isDurgSpeedProp(.TmpArr, .TmpMsgArr)	
	
	/// 35 给药时间
	i LeftDicCode="DrugUseTime" Q ..isDrugUseTime(.TmpArr, .TmpMsgArr)	
	
	/// 36 阶梯用药
	
	/// 37 连续用药
	
	/// 38 辅料(相互作用、配伍禁忌、重复用药)
	i LeftDicCode="ExcipientProp" Q ..isExcipientProp(.TmpArr, .TmpMsgArr)	
		
	/// 权限设置
	//i RulType="RuleLimitCTLoc" Q:'..isPermitAut(.TmpArr, .TmpMsgArr) 0
	
	
	// 对于没有检测到的项目，不能默认退出1,应该做一个标记，然后过滤掉改标记
	Q -1
}

/// Descript:	权限设置
ClassMethod isPermitAut(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID")) /// 规则组号
	s ID=$g(TmpArr("ID"))       /// 规则明细ID
	s itmid=$p(^DHCCKBRULE(RulID),"^",1)    /// 实体对象
	s LeftID=$p(^DHCCKBRD(ID),"^",3)       /// 关系指针(左)
	s RighID=$p(^DHCCKBRD(ID),"^",7)       /// 关系指针(右)
	s itmCode=$p(^DHCCKBCD(LeftID),"^",1)  /// 实体代码
	i itmCode="Doctor" Q:$g(TmpArr("CarePrvID"))'=RighID 0  /// 医生
	i itmCode="Office" Q:$g(TmpArr("DocLocID"))'=RighID 0   /// 科室
	//i itmCode="" Q:$g(TmpArr("PrvTpID"))'=itmValId 0      /// 职称
	Q 1
}

/// Descript:	疾病/除外疾病
ClassMethod isPermitDis(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	
	s RulID=$g(TmpArr("RulID")) // 规则组号
	s ID=$g(TmpArr("ID"))       // 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	// 关联(病症)
	q:SysItmID="" -1
	s SysItmDesc=$p($g(^DHCCKBCD(SysItmID)),"^",2)  // 疾病
	//s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter

	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=SysItmDesc_"患者禁止使用;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="适用于"_SysItmDesc_"患者;"
	e  d
	.s Ret='TipsPath
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   		/// 运算符	
	.s:$g(TmpArr("itemDis"))="" Ret=-1
	.q:$g(TmpArr("itemDis"))=""
	.s existFlag=$LF($g(TmpArr("itemDis")),SysItmID)
	.i (existFlag>0)&(TipsPath=1) s Ret='Ret
	.i (existFlag=0)&(TipsPath=0) s Ret='Ret	
	.i OpArith="'="	s Ret='Ret			// != 在疾病中表示除外疾病（除xx以外的病）
	.s MTipMessgae=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1)	d
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=SysItmDesc_"患者禁止使用;"
	..i (TipsPath=0)&&(Ret=0)	d
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="适用于"_SysItmDesc_"患者;"

	Q Ret
}

/// Descript:	药学分类(配伍禁忌)
ClassMethod isPermitTaboo(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	// 药学分类的判断规则: 1.判断药品本身是否是这个分类下的内容（还有一个分类别名的问题）。满足则1，不满足则0
	//    					2. 判断其他药品是否是这个分类下的内容。满足则1，不满足则0
	
	
	s RulID=$g(TmpArr("RulID"))   		/// 规则组号
	s ID=$g(TmpArr("ID"))         		/// 规则明细ID
	s itmid=..GetDicByRuleID(RulID)		/// 实体对象
	s itmValId=$p(^DHCCKBRD(ID),"^",7)  /// 关系指针(右)
	s itemid="", Err=1
	F  s itemid=$o(TmpArr("itemOrder",itemid)) Q:(itemid="")||(Err'=1)  D
	.Q:itmValId'=..GetPhCat(itemid)				// 获取药品的分类
	.s Err=0
	.//s RulType=..GetRuleTypeCode(RulID)		/// 类型代码
	.s PropKey=..GetRuleLabelDesc(RulID)     	/// 类型描述
	.//s itmCat=$p(^DHCCKBCD(itmValId),"^",2)  	/// 药学分类
	.s TmpMsgArr("itemOrder",DicID,PropKey,RulID,ID)="药学分类不正确！"
	.
		
	Q Err
}

/// Descript:	药学分类  满足为1  不满足为0  默认为故通过
ClassMethod isPermitDrugCat(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	// 药学分类的判断规则: 
	//	1.判断药品本身是否是这个分类下的内容（还有一个分类别名的问题）。满足则1，不满足则0
	//  2.判断其他药品是否是这个分类下的内容。满足则1，不满足则0
	//  3.分类有层级，需要判断  如：药品的分类属于1.3  则也属于分类1
	
	s RulID=$g(TmpArr("RulID"))   		/// 规则组号
	s ID=$g(TmpArr("ID"))         		/// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录

	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不能与"_SysItmDesc_"类药物一起使用;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="可选择与"_SysItmDesc_"类药物一起使用;"
	e  d	
	.s Ret='TipsPath
	.s HisItemId="", Err=0
	.F  s HisItemId=$o(TmpArr("itemOrder",HisItemId)) Q:(HisItemId="")||(Err=1)  D
	..q:CheckDicID=HisItemId
	..s HisItemIdCat=..GetPhCat(HisItemId)				// 获取药品的分类
	..s Ret=$LISTFIND(HisItemIdCat,SysItmID)
	..s Err=$LISTFIND(HisItemIdCat,SysItmID)
	..s Ret=$case((+Ret>0),1:1,:0)
	..s Err=$case((+Err>0),1:1,:0)
	.
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   /// 运算符	
	.i OpArith="'="	s Ret='Ret			  /// != 在分类中表示除外分类（除xx以外的分类）
	
	.s GroupList=##Class(web.DHCCKBPass).GetLinkItm(RulID,ID,"TogetherProp")	// 是否有合用类别(组内,组间)
	.i GroupList'=""  d
	..s GroupID=$List(GroupList,1)
	..s GroupDesc=$p(^DHCCKBCD(GroupID),"^",2)
	..s GroupFlag=$case(GroupDesc,"组内":1,"组间":0,:0)
	.e  d
	..s GroupFlag=0
	.	
	.s HisGroupFlag=..ISGroup(CheckDicID,SysItmID,.TmpArr)
	.i (TipsPath=1)&&(GroupFlag=1)&(HisGroupFlag=0) s:Ret=0 Ret='Ret	//禁忌：限定组内不能用，his是组间时,可以用
	.i (TipsPath=0)&&(GroupFlag=0)&(HisGroupFlag=1) s:Ret=1 Ret='Ret	//用法用量： 限定组间可以用,his时组内时，不可以用
	
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1)	d 
	...i OpArith="'=" s MTipMessgae="可选择与"_SysItmDesc_"类药物一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="不能与"_SysItmDesc_"一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...//s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=SysItmDesc_"类药物可能发生反应;"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	.	
	..i (TipsPath=0)&&(Ret=0)	d
	...i OpArith="'=" s MTipMessgae=SysItmDesc_"类药物可能发生反应"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="可选择与"_SysItmDesc_"一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	...//s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=SysItmDesc_"类药物可能发生反应;"		
			
	Q Ret
}

/// Descript:	药学分类
/// w ##Class(web.DHCCKBPass).GetPhCat("65")
ClassMethod GetPhCat(DicID As %String) As %String
{
	n (DicID)
	s PhCatID=##Class(web.DHCCKBCommon).GetPhCategory()   /// 药学分类
	
	// 获取药品的分类
	k ListCat
	s ListCat=""
	s LinkID=""
	f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,PhCatID,LinkID))  q:LinkID=""  d
	.s ItmCatID=$p(^DHCCKBDLA(LinkID),"^",3)
	.s ListCat=$lb(ItmCatID)
	.d ..GetParentCat(.ListCat,ItmCatID)						/// 获取分类的所有父分类
	.
	
	Q ListCat
}

/// 获取分类的父分类
ClassMethod GetParentCat(ListCat, ItmCatID) As %String
{
	n (ListCat,ItmCatID)
	
	s ParentCat=$p(^DHCCKBCD(ItmCatID),"^",3)

	// 分类的父类不为空,且不是分类字典时,加入到分类列表
	i (ParentCat'="")&(ParentCat'=##class(web.DHCCKBCommon).GetDrugCategoryData())  d
	.s len=$LISTLENGTH(ListCat)
	.s $LIST(ListCat,len+1)=ParentCat
	.d ..GetParentCat(.ListCat,ParentCat)
	
	
	q 1
}

/// 药品属性限制  成分
ClassMethod isPermitIngredient(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr,TmpMsgArr)
	
	// 药学成分的判断规则: 
	//	1.判断药品本身是否有这个成分（还有一个成分别名的问题）。满足则1，不满足则0
	//  2.判断其他药品是否有这个成分。满足则1，不满足则0
	
	s RulID=$g(TmpArr("RulID"))   		/// 规则组号
	s ID=$g(TmpArr("ID"))         		/// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)  /// 关系指针(右)
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter	
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="与"_SysItmDesc_"成分可能发生不良反应;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="可选择与"_SysItmDesc_"成分一起使用;"
	e  d
	.s Ret='TipsPath
	.s HisItemId="", Err=0
	.F  s HisItemId=$o(TmpArr("itemOrder",HisItemId)) Q:(HisItemId="")||(Err=1)  D
	..//q:DicID=ItemId
	..s HisItemIdCat=..GetIngredient(HisItemId)				// 获取药品的成分
	..s Ret=$LISTFIND(HisItemIdCat,SysItmID)
	..s Err=	$LISTFIND(HisItemIdCat,SysItmID)
	..s Ret=$case((+Ret>0),1:1,:0)
	..s Err=$case((+Err>0),1:1,:0)
	.	
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	.i OpArith="'="	s Ret='Ret			  /// != 在成分中表示除外成分（除xx以外的成分）
	
	.s GroupList=##Class(web.DHCCKBPass).GetLinkItm(RulID,ID,"TogetherProp")	// 是否有合用类别(组内,组间)
	.i GroupList'=""  d
	..s GroupID=$List(GroupList,1)
	..s GroupDesc=$p(^DHCCKBCD(GroupID),"^",2)
	..s GroupFlag=$case(GroupDesc,"组内":1,"组间":0,:0)
	.e  d
	..s GroupFlag=0
	.
	.s HisGroupFlag=..ISGroup(CheckDicID,SysItmID,.TmpArr)
	.i (TipsPath=1)&&(GroupFlag=1)&(HisGroupFlag=0) s:Ret=0 Ret='Ret	//禁忌：限定组内不能用，his是组间时,可以用
	.i (TipsPath=0)&&(GroupFlag=0)&(HisGroupFlag=1) s:Ret=1 Ret='Ret	//用法用量： 限定组间可以用,his时组内时，不可以用
	
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1)	d 
	...i OpArith="'=" s MTipMessgae="可选择与"_SysItmDesc_"成分一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="与"_SysItmDesc_"成分可能发生不良反应"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	..i (TipsPath=0)&&(Ret=0)	d
	...i OpArith="'=" s MTipMessgae=SysItmDesc_"成分可能发生不良反应"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="可选择与"_SysItmDesc_"成分一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	Q Ret
}

/// 获取药品的成分
/// w ##Class(web.DHCCKBPass).GetIngredient("762")
ClassMethod GetIngredient(DicID) As %String
{
	n (DicID)
	//s IngrPropID=##class(web.DHCCKBCommon).GetDrugIngredient()   /// 药品成分属性
	
	// 获取药品的成分
	/*
	s ListIngr=""
	s LinkID=""
	f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,IngrPropID,LinkID))  q:LinkID=""  d
	.s ItmIngrID=$p(^DHCCKBDLA(LinkID),"^",3)
	.i $LISTDATA(ListIngr) d
	..s Len=$LISTLENGTH(ListIngr)
	..s $List(ListIngr,Len+1)=ItmIngrID
	.s ListIngr=$lb(ItmIngrID)
	*/
	s IngrPropID=##class(web.DHCCKBCommon).GetIngredientCode()   /// 药品成分代码
	s ListIngr=""
	s LinkID=""
	f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,IngrPropID,LinkID))  q:LinkID=""  d
	.s ItmIngrID=$p(^DHCCKBDLA(LinkID),"^",3)
	.q:ItmIngrID=""
	.i $LISTDATA(ListIngr) d
	..s Len=$LISTLENGTH(ListIngr)
	..s $List(ListIngr,Len+1)=ItmIngrID
	.s ListIngr=$lb(ItmIngrID)
		
	Q ListIngr
}

/// 获取药品的辅料
/// w ##Class(web.DHCCKBPass).GetExcipient("105")
ClassMethod GetExcipient(DicID) As %String
{
	n (DicID)
	s ExcipientPropID=##class(web.DHCCKBCommon).GetExcipientProp()   /// 药品成分属性
	
	// 获取药品的成分
	//b //1
	s ListExci=""
	s LinkID=""
	f  s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",DicID,ExcipientPropID,LinkID))  q:LinkID=""  d
	.s ItmExciID=$p(^DHCCKBDLA(LinkID),"^",3)
	.i $LISTDATA(ListExci) d
	..s Len=$LISTLENGTH(ListExci)
	..s $List(ListExci,Len+1)=ItmExciID
	.s ListExci=$lb(ItmIngrID)

	Q ListExci
}

/// Descript:	频次单位转化系数
/// w ##Class(web.DHCCKBPass).GetFreqFac("95")
ClassMethod GetFreqFac(id As %String) As %String
{
	n (id)
	q 1
	Q:+id=0 1
	s FactorPropID=##Class(web.DHCCKBCommon).GetFacProp()   /// 单位转化系数实体
	s LinkID=$o(^DHCCKBDLA(0,"LinkDicAttrCode",id,FactorPropID,""))
	Q:LinkID="" 1
	s Fac=$p(^DHCCKBDLA(LinkID),"^",4)
	Q Fac
}

/// Descript:	药品限制  药品每日用药量
ClassMethod isPermitDayDose(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath

	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	s QtyUom=$case((Uom["/"),1:$p(Uom,"/",1),:Uom)
		
	s HisFreq=$g(TmpArr("itemOrder",CheckDicID,"Freq"))	
	s HisDosQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))
	q:HisDoseUom="" -1
	s HisDoseUomDesc=$p(^DHCCKBCD(HisDoseUom),"^",2)	
	s CheckDesc=TmpArr("itemOrder",CheckDicID,"PhDesc")	 /// 药物名称
	// 含体重单位
	i Uom["/" d	
	.s UomWeight=$p(Uom,"/",2)
	.s facWeight=..ChangeQtyFacByWeight($g(TmpArr("Weight")),UomWeight)	
	.q:facWeight=""
	.s Min=$case(Min="",1:Min,:Min*facWeight)
	.s Max=$case(Max="",1:Max,:Max*facWeight)
	
	s Fac=""
	i HisDoseUomDesc'=QtyUom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,QtyUom)
	q:(HisDoseUomDesc'=QtyUom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1
	s NewHisDosQty=HisDosQty*$case(Fac,"":1,:Fac)	

	s HisDosQtyDay=NewHisDosQty*(..GetFreqFac(HisFreq))	// 每日用药量(本次医嘱)
	s HisArciQty=0										// 该药品当天的日用药量
	s HisDosQtyDay=HisDosQtyDay+HisArciQty
	q:+HisDosQtyDay=0 -1
	i OpArith="L" s Ret=(HisDosQtyDay>=Min)&(HisDosQtyDay<Max)
	E  s RunStr="s Ret="_HisDosQtyDay_OpArith_Min x RunStr
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 	
	..i OpArith="L" s RetMsg="当前每日用药量:"_HisDosQtyDay_HisDoseUomDesc_",不应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s RetMsg="当前每日用药量:"_HisDosQtyDay_HisDoseUomDesc_",不应"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg
	
	.i (TipsPath=0)&&(Ret=0) d 
	..i OpArith="L" s RetMsg="当前每日用药量:"_HisDosQtyDay_HisDoseUomDesc_",应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s RetMsg="当前每日用药量:"_HisDosQtyDay_HisDoseUomDesc_",需"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg

	Q Ret
}

/// Descript:	药品每日最大量
ClassMethod isPermitDayMaxDose(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath	
	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	s QtyUom=$case((Uom["/"),1:$p(Uom,"/",1),:Uom)
	
	s HisFreq=$g(TmpArr("itemOrder",CheckDicID,"Freq"))
	s HisDosQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))
	q:HisDoseUom="" -1
	s HisDoseUomDesc=$p(^DHCCKBCD(HisDoseUom),"^",2)	
	s CheckDesc=TmpArr("itemOrder",CheckDicID,"PhDesc")	 /// 药物名称
	// 含体重单位
	i Uom["/" d	
	.s UomWeight=$p(Uom,"/",2)
	.s facWeight=..ChangeQtyFacByWeight($g(TmpArr("Weight")),UomWeight)	
	.q:facWeight=""
	.s Min=$case(Min="",1:Min,:Min*facWeight)
	.s Max=$case(Max="",1:Max,:Max*facWeight)
	
	s Fac=""
	i HisDoseUomDesc'=QtyUom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,QtyUom)
	q:(HisDoseUomDesc'=QtyUom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1
	s NewHisDosQty=HisDosQty*$case(Fac,"":1,:Fac)	
	
	s HisDosQtyDay=NewHisDosQty*(..GetFreqFac(HisFreq))	// 每日用药量(本次医嘱)
	s HisArciQty=0									// 该药品当天的日用药量
	s HisDosQtyDay=HisDosQtyDay+HisArciQty
	q:+HisDosQtyDay=0 -1
	i OpArith="L" s Ret=(HisDosQtyDay>=Min)&(HisDosQtyDay<=Max)
	E  s RunStr="s Ret="_HisDosQtyDay_OpArith_Min x RunStr	
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 
	..i OpArith="L" s RetMsg="当前每日最大量:"_HisDosQtyDay_HisDoseUomDesc_",不应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s RetMsg="当前每日最大量:"_HisDosQtyDay_HisDoseUomDesc_",不应"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg
	
	.i (TipsPath=0)&&(Ret=0) d 
	..i OpArith="L" s RetMsg="当前每日最大量:"_HisDosQtyDay_HisDoseUomDesc_",应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s RetMsg="当前每日最大量:"_HisDosQtyDay_HisDoseUomDesc_",需"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg

	Q Ret
}

/// Descript:	药品每日极量
ClassMethod isPermitDayDoseLimit(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath	
	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	s QtyUom=$case((Uom["/"),1:$p(Uom,"/",1),:Uom)
	
	s HisFreq=$g(TmpArr("itemOrder",CheckDicID,"Freq"))
	s HisDosQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))
	q:HisDoseUom="" -1
	s HisDoseUomDesc=$p(^DHCCKBCD(HisDoseUom),"^",2)
	s CheckDesc=TmpArr("itemOrder",CheckDicID,"PhDesc")	 /// 药物名称
	// 含体重单位
	i Uom["/" d	
	.s UomWeight=$p(Uom,"/",2)
	.s facWeight=..ChangeQtyFacByWeight($g(TmpArr("Weight")),UomWeight)	
	.q:facWeight=""
	.s Min=$case(Min="",1:Min,:Min*facWeight)
	.s Max=$case(Max="",1:Max,:Max*facWeight)
	
	s Fac=""
	i HisDoseUomDesc'=QtyUom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,QtyUom)
	q:(HisDoseUomDesc'=QtyUom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1
	s NewHisDosQty=HisDosQty*$case(Fac,"":1,:Fac)	
	
	s HisDosQtyDay=NewHisDosQty*(..GetFreqFac(HisFreq))	// 每日用药量(本次医嘱)
	s HisArciQty=0								// 该药品当天的日用药量
	s HisDosQtyDay=HisDosQtyDay+HisArciQty
	q:+HisDosQtyDay=0 -1
	i OpArith="L" s Ret=(HisDosQtyDay>=Min)&(HisDosQtyDay<=Max)
	E  s RunStr="s Ret="_HisDosQtyDay_OpArith_Min x RunStr
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 	
	..i OpArith="L" s RetMsg="当前日极量:"_HisDosQtyDay_HisDoseUomDesc_",不应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s RetMsg="当前日极量:"_HisDosQtyDay_HisDoseUomDesc_",不应"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg
	
	.i (TipsPath=0)&&(Ret=0) d 
	..i OpArith="L" s RetMsg="当前日极量:"_HisDosQtyDay_HisDoseUomDesc_",应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s RetMsg="当前日极量:"_HisDosQtyDay_HisDoseUomDesc_",需"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg

	Q Ret
}

/// Descript:	特殊人群
ClassMethod isSpecialPop(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)

	s RulID=$g(TmpArr("RulID"))   		/// 规则组号
	s ID=$g(TmpArr("ID"))         		/// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录

	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID	// 公共规则判断时,会改变TmpArr("RulID"),递归完后，需要重新赋值
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于"_SysItmDesc_"人群患者;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="适用于"_SysItmDesc_"人群患者;"
	e  d
	.s Ret='TipsPath	
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   		/// 运算符	
	.q:$g(TmpArr("SpecGrps"))=""	
	.s existFlag=$LF($g(TmpArr("SpecGrps")),SysItmID)
	.i (existFlag>0)&(TipsPath=1) s Ret='Ret
	.i (existFlag=0)&(TipsPath=0) s Ret='Ret
	.i OpArith="'="	s Ret='Ret			 
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1) D	
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于"_SysItmDesc_"人群患者;"	
	..i (TipsPath=0)&&(Ret=0) D	
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="适用于"_SysItmDesc_"人群患者;"

	Q Ret
}

/// Descript:	药品属性限制 疗程
ClassMethod isPermitDuration(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   		/// 规则组号
	s ID=$g(TmpArr("ID"))         		/// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	s Ret='TipsPath	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	
	s DurationStr=$g(TmpArr("itemOrder",CheckDicID,"Duration"))
	s Duration=+DurationStr
	s DuraUom=$p(DurationStr,Duration,2)
	s:DuraUom="" DuraUom="天"
	s:DuraUom["个月" DuraUom="月"
	s Fac="" 
	i Uom'=DuraUom  d
	.s Fac=##class(web.DHCCKBCommonUtil).GetUomChangeFac(DuraUom,Uom)
	.s:Fac="" Fac=##class(web.DHCCKBCommonUtil).GetUomChangeFacNew(DuraUom,Uom)
	.s Duration=$case(Fac="",1:Duration,:Duration*Fac)

	q:(DuraUom'=Uom)&&(Fac="") -1 //单位转换不成功
	
	i OpArith="L" s Ret=(Duration>=Min)&(Duration<Max)
	E  s runStr="s Ret="_Duration_OpArith_Min x runStr	

	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 
	..i OpArith="L" s retMsg="疗程:"_DurationStr_",不应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="疗程:"_DurationStr_",不应"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg	
	.i (TipsPath=0)&&(Ret=0) d 	
	..i OpArith="L" s retMsg="疗程:"_DurationStr_",应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="疗程:"_DurationStr_",需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	Q Ret
}

/// Descript:	药品属性限制 单次剂量 
ClassMethod isPermitDosQty(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录

	s Ret='TipsPath	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	s QtyUom=$case((Uom["/"),1:$p(Uom,"/",1),:Uom)
	
	s HisDosQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))
	q:HisDoseUom="" -1
	s HisDoseUomDesc=$p(^DHCCKBCD(HisDoseUom),"^",2)
	s CheckDesc=TmpArr("itemOrder",CheckDicID,"PhDesc")	   /// 药物名称
	// 含体重单位
	i Uom["/" d	
	.s UomWeight=$p(Uom,"/",2)
	.s facWeight=..ChangeQtyFacByWeight($g(TmpArr("Weight")),UomWeight)	
	.q:facWeight=""
	.s Min=$case(Min="",1:Min,:Min*facWeight)
	.s Max=$case(Max="",1:Max,:Max*facWeight)

	s Fac=""
	i HisDoseUomDesc'=QtyUom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,QtyUom)
	q:(HisDoseUomDesc'=QtyUom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1
	
	s newHisDosQty=HisDosQty*$case(Fac,"":1,:Fac)
	i OpArith="L" s Ret=(newHisDosQty>=Min)&(newHisDosQty<=Max)
	E  s runStr="s Ret="_newHisDosQty_OpArith_Min x runStr

	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 
	..i OpArith="L" s retMsg="当前单次剂量:"_HisDosQty_HisDoseUomDesc_",不应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s retMsg="当前单次剂量:"_HisDosQty_HisDoseUomDesc_",不应"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg	
	.i (TipsPath=0)&&(Ret=0) d 	
	..i OpArith="L" s retMsg="当前单次剂量:"_HisDosQty_HisDoseUomDesc_",应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s retMsg="当前单次剂量:"_HisDosQty_HisDoseUomDesc_",需"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	Q Ret
}

/// Descript:	药品属性限制 单次最大量
ClassMethod isPermitOnceDoseMax(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath

	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	s QtyUom=$case((Uom["/"),1:$p(Uom,"/",1),:Uom)
	
	s HisDosQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))	
	q:HisDoseUom="" -1
	s HisDoseUomDesc=$p(^DHCCKBCD(HisDoseUom),"^",2)
	s CheckDesc=TmpArr("itemOrder",CheckDicID,"PhDesc")	 /// 药物名称
	// 含体重单位
	i Uom["/" d	
	.s UomWeight=$p(Uom,"/",2)
	.s facWeight=..ChangeQtyFacByWeight($g(TmpArr("Weight")),UomWeight)	
	.q:facWeight=""
	.s Min=$case(Min="",1:Min,:Min*facWeight)
	.s Max=$case(Max="",1:Max,:Max*facWeight)
	
	s Fac=""
	i HisDoseUomDesc'=QtyUom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,QtyUom)
	q:(HisDoseUomDesc'=QtyUom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1

	s NewHisDosQty=HisDosQty*$case(Fac,"":1,:Fac)	
	i OpArith="L" s Ret=(NewHisDosQty>=Min)&(NewHisDosQty<=Max)
	E  s runStr="s Ret="_NewHisDosQty_OpArith_Min x runStr
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 	
	..i OpArith="L" s retMsg="当前单次最大剂量:"_HisDosQty_HisDoseUomDesc_",不应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s retMsg="当前单次最大剂量:"_HisDosQty_HisDoseUomDesc_",不应"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	.i (TipsPath=0)&&(Ret=0) d 
	..i OpArith="L" s retMsg="当前单次最大剂量:"_HisDosQty_HisDoseUomDesc_",应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s retMsg="当前单次最大剂量:"_HisDosQty_HisDoseUomDesc_",需"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	Q Ret
}

/// Descript:	药品属性限制 单次极量
ClassMethod isPermitOnceDoseLimit(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath
	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	s QtyUom=$case((Uom["/"),1:$p(Uom,"/",1),:Uom)	
	
	s HisDosQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))
	q:HisDoseUom="" -1
	s HisDoseUomDesc=$p(^DHCCKBCD(HisDoseUom),"^",2)
	s CheckDesc=TmpArr("itemOrder",CheckDicID,"PhDesc")	 /// 药物名称
	// 含体重单位
	i Uom["/" d	
	.s UomWeight=$p(Uom,"/",2)
	.s facWeight=..ChangeQtyFacByWeight($g(TmpArr("Weight")),UomWeight)	
	.q:facWeight=""
	.s Min=$case(Min="",1:Min,:Min*facWeight)
	.s Max=$case(Max="",1:Max,:Max*facWeight)
	
	s Fac=""
	i HisDoseUomDesc'=QtyUom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,QtyUom)
	q:(HisDoseUomDesc'=QtyUom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1

	s NewHisDosQty=HisDosQty*$case(Fac,"":1,:Fac)	
	i OpArith="L" s Ret=(NewHisDosQty>=Min)&(NewHisDosQty<=Max)
	E  s runStr="s Ret="_NewHisDosQty_OpArith_Min x runStr	
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&(Ret=1) d 	
	..i OpArith="L" s retMsg="当前单次极量:"_HisDosQty_HisDoseUomDesc_",不应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s retMsg="当前单次极量:"_HisDosQty_HisDoseUomDesc_",不应"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	
	.i (TipsPath=0)&(Ret=0) d 
	..i OpArith="L" s retMsg="当前单次极量:"_HisDosQty_HisDoseUomDesc_",应在"_Min_"-"_Max_QtyUom_"之间;"
	..E  s retMsg="当前单次极量:"_HisDosQty_HisDoseUomDesc_",需要"_OpArith_Min_QtyUom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	Q Ret
}

/// Descript:	药品属性限制 用药频率
ClassMethod isPermitFreq(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录

	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)
	q:'$d(^DHCCKBCD(SysItmID)) -1	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于"_SysItmDesc_"频率;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="适用于"_SysItmDesc_"频率;"
	e  d
	.s Ret='TipsPath	
	.s HisFreq=$g(TmpArr("itemOrder",CheckDicID,"Freq"))
	.s:HisFreq="" Ret=-1	
	.q:HisFreq="" 
	.s HisFreqDesc=$p(^DHCCKBCD(HisFreq),"^",2)
	.s Ret = (HisFreq=SysItmID)	
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1) d		
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用"_HisFreqDesc_"频率;"
	..i (TipsPath=0)&&(Ret=0) d	
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用"_HisFreqDesc_"频率;"
			
	q Ret
}

/// Descript:	药品属性限制 给药途径
ClassMethod isPermitPhaProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录

	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用"_SysItmDesc_"给药途径;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用"_SysItmDesc_"给药途径;"
	e  d
	.s Ret='TipsPath
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   /// 运算符	
	.s HisInstr=$g(TmpArr("itemOrder",CheckDicID,"Instr"))
	.s:HisInstr="" Ret=-1
	.q:HisInstr=""
	.s HisInstrDesc=$p(^DHCCKBCD(HisInstr),"^",2)
	.s Ret=(HisInstr=SysItmID)	
	.i OpArith="'="	s Ret='Ret			 
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值	
	..i (TipsPath=1)&&(Ret=1) d
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用"_HisInstrDesc_"给药途径;"	
	..i (TipsPath=0)&&(Ret=0) d
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用"_HisInstrDesc_"给药途径;"

	q Ret
}

/// Descript:	体重限制
ClassMethod isPermitWeight(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID")) 
	s ID=$g(TmpArr("ID"))               	/// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于该患者体重范围;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于该患者体重范围;"
	e  d
	.s Ret='TipsPath	
	.s OpArith=$p($g(^DHCCKBRD(ID)),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)    	 /// 运算符
	.s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	.s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	.s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	.s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	.s Weight=$g(TmpArr("Weight"))
	.s:Weight="" Ret=-1
	.q:Weight=""	//.i OpArith="L" s Ret=(PatAge>=Min)&(PatAge<=Max)
	.i OpArith="L" s Ret=(Weight>=Min)&(Weight<=Max)
	.E  s runStr="s Ret="_Weight_OpArith_Min x runStr
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1) D	
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于该患者体重范围;"
	..i (TipsPath=0)&&(Ret=0) D	
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于该患者体重范围;"	
	
	Q Ret
}

/// Descript:	性别限制
ClassMethod isPermitSex(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))
	s ID=$g(TmpArr("ID"))                    /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 		/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")		/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于"_$g(TmpArr("PatSex"))_";"
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于"_$g(TmpArr("PatSex"))_";"
	e  d
	.s Ret='TipsPath	
	.s:$g(TmpArr("PatSex"))="" Ret=-1
	.q:$g(TmpArr("PatSex"))=""
	.s Ret = (SysItmDesc=$g(TmpArr("PatSex")))	
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   		/// 运算符	
	.i OpArith="'="	s Ret='Ret			 
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1) D		
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于"_$g(TmpArr("PatSex"))_";"
	..i (TipsPath=0)&&(Ret=0) D		
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不适用于"_$g(TmpArr("PatSex"))_";"

	q Ret
}

/// Descript:	年龄限制
ClassMethod isPermitAge(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))
	s ID=$g(TmpArr("ID"))             /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)-between时,第7位是空	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&$d(^DHCCKBRULEDIC(0,"Dic",SysItmID))	d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="超年龄段使用;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="超年龄段使用;"
	e  d
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   /// 运算符	
	.s TipsPath=..GetLabelTipsPath(RulID)	/// 提醒方向
	.s Ret='TipsPath
	.s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	.s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	.s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	.s PatAge=..GetAge($g(TmpArr("PatBDay"))) /// 单位换算
	.s PatAge=$g(TmpArr("PatBDay"))    /// 单位换算
	.s:PatAge="" Ret=-1
	.q:PatAge=""	
	.s Uom=""
	.s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	.s AgeMsg=$case(OpArith,"L":Min_"-"_Max_Uom,:OpArith_Min_Uom)	
	.s:(Uom="岁")||(Uom="年") Min=Min*365,Max=Max*365
	.s:Uom="月" Min=Min*30,Max=Max*30
	.s PatAge=+$H-$zdh(PatAge,3)	
	.i OpArith="L" s Ret=(PatAge>=Min)&(PatAge<=Max)
	.E  s runStr="s Ret="_PatAge_OpArith_Min x runStr
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1) d
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="超年龄段使用,"_"不应"_AgeMsg_";"
	..i (TipsPath=0)&&(Ret=0) d
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="超年龄段使用,"_"适用于"_AgeMsg_";"

	Q Ret
}

///  Descript:  验证条件 药品禁忌/相互作用
///  Output:    0 - 不匹配、1 - 匹配  
///  w ##Class(web.DHCCKBPass).isMutEff(.TmpArr, .TmpMsgArr)
ClassMethod isMutEff(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))
	s ID=$g(TmpArr("ID"))
	s TipsPath=$g(TmpArr("TipsPath")) 		/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")		/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)		// 关联(药品)
	q:SysItmID="" -1
	s SysItmDesc=$p(^DHCCKBCD(SysItmID),"^",2) 
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter

	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不能与"_SysItmDesc_"一起使用;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不能与"_SysItmDesc_"一起使用;"
	e  d
	.s Ret='TipsPath	
	.s existFlag=+$d(TmpArr("itemOrder",SysItmID))
	.i (existFlag>0)&(TipsPath=1) s Ret='Ret
	.i (existFlag=0)&(TipsPath=0) s Ret='Ret	
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)  	// 运算符	
	.i OpArith="'="	s Ret='Ret			// != 在疾病中表示除外疾病（除xx以外的病）
	.// 禁忌：1 无0  用法用量：错0 对 1
	.// 禁忌1 组内,组间  	// 对1 组内，组间	
	.s GroupList=##Class(web.DHCCKBPass).GetLinkItm(RulID,ID,"TogetherProp")	// 是否有合用类别(组内,组间)
	.i GroupList'=""  d
	..s GroupID=$List(GroupList,1)
	..s GroupDesc=$p(^DHCCKBCD(GroupID),"^",2)
	..s GroupFlag=$case(GroupDesc,"组内":1,"组间":0,:0)
	.e  d
	..s GroupFlag=0	
	.s HisGroupFlag=..ISGroup(CheckDicID,SysItmID,.TmpArr)
	.i (TipsPath=1)&&(GroupFlag=1)&(HisGroupFlag=0) s:Ret=0 Ret='Ret	//禁忌：限定组内不能用，his是组间时,可以用
	.i (TipsPath=0)&&(GroupFlag=0)&(HisGroupFlag=1) s:Ret=1 Ret='Ret	//用法用量： 限定组间可以用,his时组内时，不可以用
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1)	d
	...i OpArith="'=" s MTipMessgae="可以与"_SysItmDesc_"一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="不能与"_SysItmDesc_"一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	..i (TipsPath=0)&&(Ret=0)	d
	...i OpArith="'=" s MTipMessgae="不能与"_SysItmDesc_"一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="可以与"_SysItmDesc_"一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae

	Q Ret
}

/// Descript:  检查过敏史 1 过敏  0 不过敏
///  w ##Class(web.DHCCKBPass).isTakPatAgy("67","1",.TMPArr)
ClassMethod isTakPatAgy(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	
	s RulID=$g(TmpArr("RulID")) 			/// 规则组号
	s ID=$g(TmpArr("ID"))       			/// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 		/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")		/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)      /// 关系指针(右)
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))

	q:$g(TmpArr("itemAyg"))="" -1
	s Err=0
	i $LF($g(TmpArr("itemAyg")),SysItmID)  D 
	.s Err=1	
	i Err=1 s Ret='Ret	// 过敏  需要反向，即用法用量过敏为0, 禁忌证过敏为1
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	
	s OpArith=..TrsOpArith(OpArith)   			/// 运算符(不等于，需要反向)
	i OpArith="'="	s Ret='Ret
	s mTipMessgae="过敏;"

	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="患者"_SysItmDesc_mTipMessgae
	.i (TipsPath=0)&&(Ret=0) d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="患者"_SysItmDesc_mTipMessgae

	Q Ret
}

/// Descript:  检查检验指标 1 满足  0 不满足 
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isLabItm(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath

	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(检验指标)(右)
	q:SysItmID="" Ret
	s SysItmDesc=$p(^DHCCKBCD(SysItmID),"^",2)  /// 检验指标
	
	s Ret=$d(TmpArr("itemLab",SysItmID,"Item"))||$d(TmpArr("itemLab",SysItmDesc,"Item"))		
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	i OpArith="'="	s Ret='Ret			  /// != 
	s MTipMessgae=$case(TipsPath,1:"不能用于"_SysItmDesc_"检验指标;",:"适用于"_SysItmDesc_"检验指标;")
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	.i (TipsPath=0)&&(Ret=0)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae

	Q Ret
}

/// Descript:  检查检验指标范围值 1 满足  0 不满足
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isLabItmValueLimitProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath
		
	s RightDicID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(检验指标)(右)
	q:RightDicID="" Ret
	s RightLabItm=$p(^DHCCKBCD(RightDicID),"^",2)  /// 检验指标
	s Ret=$d(TmpArr("itemLab",RightLabItm,"Item"))	// 此处找检验项目好像不对 了
	s Val=$g(TmpArr("itemLab",RightLabItm,"Val"))
	s Uom=$g(TmpArr("itemLab",RightLabItm,"Uom"))
	
	q:(Ret=0) "-1"	// 没有找到对应的检验项目 (好像ID不对了)

	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s DoseUom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述	
	Q:DoseUom'=Uom Ret				
	i OpArith="L" s Ret=(Val>=Min)&(Val<Max)
	E  s RunStr="s Ret="_Val_OpArith_Min x RunStr
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值	
	.i (TipsPath=1)&&(Ret=1) d 	
	..i OpArith="L" s RetMsg="检验指标值需量应在"_Min_"-"_Max_Uom_"之间;"
	..E  s RetMsg="检验指标值需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg
	.
	.i (TipsPath=0)&&(Ret=0) d 
	..i OpArith="L" s RetMsg="检验指标值需量应在"_Min_"-"_Max_Uom_"之间;"
	..E  s RetMsg="检验指标值需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=RetMsg

	Q Ret
}

/// Descript:  细菌/病原体(包含除外) 1 满足  0 不满足 
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isBacteria(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录	

	s Ret='TipsPath		
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)  		/// 关系指针(右)
	q:SysItmID="" -1
	s SysItmDesc=$p(^DHCCKBCD(SysItmID),"^",2)  /// 实体
	s HisVacter=$lb("")
	s Ret=$LISTFIND(HisVacter,SysItmID)||($LISTFIND(HisVacter,SysItmDesc))
	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	i OpArith="'="	s Ret='Ret			  /// != 	
	s MTipMessgae=$case(TipsPath,1:"不能用于"_SysItmDesc_"病原体;",:"适用于"_SysItmDesc_"病原体;")
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	.i (TipsPath=0)&&(Ret=0)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	Q Ret
}

/// Descript:  菌属/病原体组 1 满足  0 不满足 
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isBacteriaCat(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录	
	s Ret='TipsPath	
	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)  		/// 关系指针(右)
	q:SysItmID="" Ret
	s SysItmDesc=$p(^DHCCKBCD(SysItmID),"^",2)  /// 实体
	s HisVacter=$lb("厌氧菌1")
	s Ret=$LISTFIND(HisVacter,SysItmID)||($LISTFIND(HisVacter,SysItmDesc))		
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	i OpArith="'="	s Ret='Ret			  /// != 
	s MTipMessgae=$case(TipsPath,1:"不能用于"_SysItmDesc_"病原体组;",:"适用于"_SysItmDesc_"病原体组;")
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	.i (TipsPath=0)&&(Ret=0)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	Q Ret
}

/// Descript:  症状 1 满足  0 不满足  
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isSymptom(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录	
	s Ret='TipsPath
	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)  		/// 关系指针(右)	
	q:SysItmID="" Ret
	s SysItmDesc=$p(^DHCCKBCD(SysItmID),"^",2)  /// 实体
	s HisSymptom="" //$lb("恶心1")
	s Ret=$LISTFIND(HisSymptom,SysItmID)||($LISTFIND(HisSymptom,SysItmDesc))
	//s Ret=$case(Ret,1:1,:0)		
			
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	i OpArith="'="	s Ret='Ret			  /// != 
	s MTipMessgae=$case(TipsPath,1:"不能用于"_SysItmDesc_"症状;",:"适用于"_SysItmDesc_"症状;")
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	.i (TipsPath=0)&&(Ret=0)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	Q Ret
}

/// Descript:  溶媒 1 满足  0 不满足  
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isSolventProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录	
	s Ret='TipsPath

	s SysItmID=$p(^DHCCKBRD(ID),"^",7)  		/// 关系指针(右)	
	q:+SysItmID=0 -1
	s SysItmDesc=$p($g(^DHCCKBCD(SysItmID)),"^",2)
	
	s tmpDicID="",isExistFlag=0
	f  s tmpDicID=$o(TmpArr("itemOrder",tmpDicID)) q:(tmpDicID="")||(isExistFlag=1)  d
	.q:CheckDicID=tmpDicID
	.s tmpDicDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))
	.//i (tmpDicID=SysItmID)||(tmpDicDesc=SysItmDesc)
	.q:(tmpDicID=SysItmID)&(tmpDicDesc=SysItmDesc)
	.s isExistFlag=1

	s Ret=$case((isExistFlag=1),1:1,:0)				
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	i OpArith="'="	s Ret='Ret			  /// != 
	
	s GroupList=##Class(web.DHCCKBPass).GetLinkItm(RulID,ID,"TogetherProp")	// 是否有合用类别(组内,组间)
	i GroupList'=""  d
	.s GroupID=$List(GroupList,1)
	.s GroupDesc=$p(^DHCCKBCD(GroupID),"^",2)
	.s GroupFlag=$case(GroupDesc,"组内":1,"组间":0,:0)	// 默认为组间
	e  d
	.s GroupFlag=0					// 默认为组间

	s HisGroupFlag=..ISGroup(CheckDicID,SysItmID,.TmpArr)
	i (TipsPath=1)&&(GroupFlag=1)&(HisGroupFlag=0) s:Ret=0 Ret='Ret	//禁忌：限定组内不能用，his是组间时,可以用
	i (TipsPath=0)&&(GroupFlag=0)&(HisGroupFlag=1) s:Ret=1 Ret='Ret	//用法用量： 限定组间可以用,his时组内时，不可以用
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1)	d
	..i OpArith="'=" s MTipMessgae="应选择"_SysItmDesc_"作为溶媒"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..e  s MTipMessgae="不能选择"_SysItmDesc_"作为溶媒"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	.i (TipsPath=0)&&(Ret=0)	d
	..i OpArith="'=" s MTipMessgae="不能选择"_SysItmDesc_"作为溶媒"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..e  s MTipMessgae="应选择"_SysItmDesc_"作为溶媒"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	Q Ret
}

/// Descript:  溶媒浓度 1 满足  0 不满足  
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isSolventDensity(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s CheckDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))	 /// 药物名称
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath	
		
	// 审查信息
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述

	s TmpDicID="",IsExistFlag=0,SolventDicID=""
	f  s TmpDicID=$o(TmpArr("itemOrder",TmpDicID)) q:(TmpDicID="")||(IsExistFlag=1)  d
	.q:CheckDicID=TmpDicID
	.// 需要找到溶媒药品
	.s LinkItmID=..GetLinkItm(RulID,ID,"SolventProp")	// list
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,TmpDicID)
	.//s tmpDicDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))
	.s SolventDicID=$LIST(LinkItmID,$LISTFIND(LinkItmID,TmpDicID))
	.s isExistFlag=1
	
	q:SolventDicID="" Ret
	
	s HisSoluteQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))	// his溶质剂量
	s HisSoluteUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))
	s HisSoluteUomDesc=$case(+HisSoluteUom=0,1:"",:$p(^DHCCKBCD(HisSoluteUom),"^",2))	
	s HisSolventQty=$g(TmpArr("itemOrder",SolventDicID,"DosQty"))	// his溶媒
	s HisSolventUom=$g(TmpArr("itemOrder",SolventDicID,"DosUom"))
	s HisSolventUomDesc=$case(+HisSolventUom=0,1:"",:$p(^DHCCKBCD(HisSolventUom),"^",2))
	
	s HisDensity=HisSoluteQty/HisSolventQty		// his浓度
	s HisDensityUom=HisSoluteUomDesc_"/"_HisSolventUomDesc
	
	s Fac=""
	i HisDoseUomDesc'=Uom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDensityUomDesc,Uom)
	q:(HisDensityUomDesc'=Uom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDensity=0 -1
		
	i OpArith="L" s Ret=(HisDensity>=Min)&(HisDensity<=Max)
	E  s runStr="s Ret="_HisDensity_OpArith_Min x runStr

	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 	
	..i OpArith="L" s retMsg="溶媒浓度应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶媒浓度需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	.i (TipsPath=0)&&(Ret=0) d 
	..i OpArith="L" s retMsg="溶媒浓度应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶媒浓度需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg	

	Q Ret
}

/// Descript:  溶媒体积 1 满足  0 不满足  
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isSolventVolumeProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s CheckDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))	 /// 药物名称	
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录	
	s Ret='TipsPath		
	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	
	s SolventDicID="",TmpDicID="",IsExistFlag=0
	f  s TmpDicID=$o(TmpArr("itemOrder",TmpDicID)) q:(TmpDicID="")||(IsExistFlag=1)  d
	.q:CheckDicID=TmpDicID
	.s LinkItmID=..GetLinkItm(RulID,ID,"SolventProp")	// list
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,TmpDicID)
	.s IsExistFlag=1	
	.s SolventDicID=$LIST(LinkItmID,$LISTFIND(LinkItmID,TmpDicID))

	q:SolventDicID="" Ret
	s HisDosQty=$g(TmpArr("itemOrder",SolventDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",SolventDicID,"DosUom"))
	s HisDoseUomDesc=$case(+HisSolventUom=0,1:"",:$p(^DHCCKBCD(HisDoseUom),"^",2))
	s Fac=""
	i HisDoseUomDesc'=Uom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,Uom)
	q:(HisDoseUomDesc'=Uom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1	
	i OpArith="L" s Ret=(HisDosQty>=Min)&(DosQty<=Max)
	E  s runStr="s Ret="_HisDosQty_OpArith_Min x runStr
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 
	..i OpArith="L" s retMsg="溶媒体积应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶媒体积需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	
	.i (TipsPath=0)&&(Ret=0) d 	
	..i OpArith="L" s retMsg="溶媒体积应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶媒体积需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	
	Q Ret
}

/// Descript:  溶液 1 满足  0 不满足  
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isSolutionProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath		

	s SysItmID=$p(^DHCCKBRD(ID),"^",7)  		/// 关系指针(右)	
	q:+SysItmID=0 Ret
	s SysItmDesc=$p($g(^DHCCKBCD(SysItmID)),"^",2)
	
	s tmpDicID="",isExistFlag=0
	f  s tmpDicID=$o(TmpArr("itemOrder",tmpDicID)) q:(tmpDicID="")||(isExistFlag=1)  d
	.q:CheckDicID=tmpDicID
	.s tmpDicDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))
	.//i (tmpDicID=SysItmID)||(tmpDicDesc=SysItmDesc)
	.q:(tmpDicID=SysItmID)&(tmpDicDesc=SysItmDesc)
	.s isExistFlag=1

	s Ret=$case((isExistFlag=1),1:1,:0)				
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	i OpArith="'="	s Ret='Ret			  /// != 
	
	s GroupList=##Class(web.DHCCKBPass).GetLinkItm(RulID,ID,"TogetherProp")	// 是否有合用类别(组内,组间)
	i GroupList'=""  d
	.s GroupID=$List(GroupList,1)
	.s GroupDesc=$p(^DHCCKBCD(GroupID),"^",2)
	.s GroupFlag=$case(GroupDesc,"组内":1,"组间":0,:1)	// 默认为组内
	e  d
	.s GroupFlag=1					

	s HisGroupFlag=..ISGroup(CheckDicID,SysItmID,.TmpArr)
	i (TipsPath=1)&&(GroupFlag=1)&(HisGroupFlag=0) s:Ret=0 Ret='Ret	//禁忌：限定组内不能用，his是组间时,可以用
	i (TipsPath=0)&&(GroupFlag=0)&(HisGroupFlag=1) s:Ret=1 Ret='Ret	//用法用量： 限定组间可以用,his时组内时，不可以用
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1)	d
	..i OpArith="'=" s MTipMessgae="应选择"_SysItmDesc_"作为溶液"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..e  s MTipMessgae="不能选择"_SysItmDesc_"作为溶液"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae	
	.i (TipsPath=0)&&(Ret=0)	d
	..i OpArith="'=" s MTipMessgae="不能选择"_SysItmDesc_"作为溶液"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..e  s MTipMessgae="应选择"_SysItmDesc_"作为溶液"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae	
	
	Q Ret
}

/// Descript:  溶液浓度 1 满足  0 不满足  
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isSolutionDensity(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s CheckDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))	 /// 药物名称
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath		
	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	
	s TmpDicID="",IsExistFlag=0,SolventDicID=""
	f  s TmpDicID=$o(TmpArr("itemOrder",TmpDicID)) q:(TmpDicID="")||(IsExistFlag=1)  d
	.q:CheckDicID=TmpDicID
	.// 需要找到溶媒药品
	.s LinkItmID=..GetLinkItm(RulID,ID,"SolutionProp")	// list
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,TmpDicID)
	.//s tmpDicDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))
	.s SolventDicID=$LIST(LinkItmID,$LISTFIND(LinkItmID,TmpDicID))
	.s isExistFlag=1

	q:SolventDicID="" Ret
	
	s HisSoluteQty=$g(TmpArr("itemOrder",CheckDicID,"DosQty"))	// his溶质剂量
	s HisSoluteUom=$g(TmpArr("itemOrder",CheckDicID,"DosUom"))	
	s HisSoluteUomDesc=$case(+HisSoluteUom=0,1:"",:$p(^DHCCKBCD(HisSoluteUom),"^",2))
	s HisSolventQty=$g(TmpArr("itemOrder",SolventDicID,"DosQty"))	// his溶液
	s HisSolventUom=$g(TmpArr("itemOrder",SolventDicID,"DosUom"))
	s HisSolventUomDesc=$case(+HisSolventUom=0,1:"",:$p(^DHCCKBCD(HisSolventUom),"^",2))
	s HisDensity=HisSoluteQty/HisSolventQty		// his浓度
	s HisDensityUomDesc=HisSoluteUomDesc_"/"_HisSolventUomDesc

	s Fac=""
	i HisDensityUomDesc'=Uom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDensityUomDesc,Uom)
	q:(HisDensityUomDesc'=Uom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDensity=0 -1
	
	i OpArith="L" s Ret=(HisDensity>=Min)&(HisDensity<=Max)
	E  s runStr="s Ret="_HisDensity_OpArith_Min x runStr

	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 	
	..i OpArith="L" s retMsg="溶液浓度应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶液浓度需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	.i (TipsPath=0)&&(Ret=0) d 
	..i OpArith="L" s retMsg="溶液浓度应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶液浓度需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg	

	Q Ret
}

/// Descript:  溶液体积 1 满足  0 不满足  
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isSolutionVolumeProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s CheckDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))	 /// 药物名称
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath
			
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
				
	s SolventDicID="",TmpDicID="",IsExistFlag=0
	f  s TmpDicID=$o(TmpArr("itemOrder",TmpDicID)) q:(TmpDicID="")||(IsExistFlag=1)  d
	.q:CheckDicID=TmpDicID
	.s LinkItmID=..GetLinkItm(RulID,ID,"SolutionProp")	// list
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,TmpDicID)
	.s IsExistFlag=1	
	.s SolventDicID=$LIST(LinkItmID,$LISTFIND(LinkItmID,TmpDicID))

	q:SolventDicID="" Ret
	
	s HisDosQty=$g(TmpArr("itemOrder",SolventDicID,"DosQty"))
	s HisDoseUom=$g(TmpArr("itemOrder",SolventDicID,"DosUom"))
	s HisDoseUomDesc=$case(+HisDoseUom=0,1:"",:$p(^DHCCKBCD(HisDoseUom),"^",2))
	s Fac=""
	i HisDoseUomDesc'=Uom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisDoseUomDesc,Uom)
	q:(HisDosQty'=Uom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisDosQty=0 -1
		
	i OpArith="L" s Ret=(HisDosQty>=Min)&(HisDosQty<=Max)
	E  s runStr="s Ret="_HisDosQty_OpArith_Min x runStr
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 
	..i OpArith="L" s retMsg="溶液体积应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶液体积需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	
	.i (TipsPath=0)&&(Ret=0) d 	
	..i OpArith="L" s retMsg="溶液体积应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="溶液体积需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	
	Q Ret
}

/// Descript:  职业 1 满足  0 不满足 
///  w ##Class(web.DHCCKBPass).isLabItm("67","1",.TMPArr)
ClassMethod isProfessProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID	
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)	/// 关联实体(右)	
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))	
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="不能用于"_SysItmDesc_"职业;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="适用于"_SysItmDesc_"职业;"
	e  d
	.s Ret='TipsPath	
	.s SysItmDesc=$p(^DHCCKBCD(SysItmID),"^",2)  /// 实体
	.s HisFess=$lb($g(TmpArr("ProFess")))
	.s Ret=$LISTFIND(HisFess,SysItmID)
	.s Ret=$case((+Ret>0),1:1,:0)		

	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	.i OpArith="'="	s Ret='Ret			  /// != 

	s MTipMessgae=$case(TipsPath,1:"不能用于"_SysItmDesc_"职业;",:"适用于"_SysItmDesc_"职业;")
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	.i (TipsPath=0)&&(Ret=0)	d
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	Q Ret
}

/// Descript:	药品给药速度 1 满足  0 不满足 
ClassMethod isDurgSpeedProp(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s CheckDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))	 /// 药物名称
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath	
	
	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	
	s HisSpeed=""
	s HisSpeedUom=""
	s Fac=""
	i HisSpeedUom'=Uom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisSpeedUom,Uom)
	q:(HisSpeedUom'=Uom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisSpeed=0 -1
		
	q:+HisSpeed=0 Ret
	i OpArith="L" s Ret=(HisSpeed>=Min)&(HisSpeed<=Max)
	E  s runStr="s Ret="_HisSpeed_OpArith_Min x runStr
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 
	..i OpArith="L" s retMsg="给药速度应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="给药速度需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	
	.i (TipsPath=0)&&(Ret=0) d 	
	..i OpArith="L" s retMsg="给药速度应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="给药速度需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	Q Ret
}

/// Descript:	药品给药时间  1 满足  0 不满足 
ClassMethod isDrugUseTime(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))   /// 规则组号
	s ID=$g(TmpArr("ID"))         /// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s CheckDesc=$g(TmpArr("itemOrder",CheckDicID,"PhDesc"))	 /// 药物名称
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	s Ret='TipsPath		

	s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	s OpArith=..TrsOpArith(OpArith)   /// 运算符
	s Min=$p(^DHCCKBRD(ID),"^",8)     /// 下线
	s UomID=$p(^DHCCKBRD(ID),"^",12)  /// 单位
	s Max=$p(^DHCCKBRD(ID),"^",13)    /// 上限
	s Uom=$case(+UomID,0:"",:$p(^DHCCKBCD(UomID),"^",2))   /// 单位描述
	
	s HisUseTime=""
	s HisUseTimeUom=""
	s Fac=""
	i HisUseTimeUom'=Uom d
	.s Fac=##class(web.DHCCKBInterface).GetFactorToLib(CheckDesc,"",HisUseTimeUom,Uom)
	q:(HisUseTimeUom'=Uom)&(Fac="") -1	/// 单位转换不成功	
	q:+HisUseTime=0 -1

	i OpArith="L" s Ret=(HisUseTime>=Min)&(HisUseTime<=Max)
	E  s runStr="s Ret="_HisUseTime_OpArith_Min x runStr
	
	i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	.i (TipsPath=1)&&(Ret=1) d 
	..i OpArith="L" s retMsg="给药时间应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="给药时间需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg
	
	.i (TipsPath=0)&&(Ret=0) d 	
	..i OpArith="L" s retMsg="给药时间应在"_Min_"-"_Max_Uom_"之间;"
	..E  s retMsg="给药时间需"_OpArith_Min_Uom_";"
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=retMsg

	Q Ret
}

/// Descript:	药品辅料(相互作用、配伍禁忌、重复用药)  1 满足  0 不满足 
ClassMethod isExcipientProp(TmpArr, TmpMsgArr) As %String
{
	
	n (TmpArr, TmpMsgArr)
	
	// 药品辅料的判断规则: 
	//	1.判断药品本身是否有这个辅料（还有一个辅料别名的问题）。满足则1，不满足则0
	//  2.判断其他药品是否有这个辅料 满足则1，不满足则0
	
	s RulID=$g(TmpArr("RulID"))   		/// 规则组号
	s ID=$g(TmpArr("ID"))         		/// 规则明细ID
	s TipsPath=$g(TmpArr("TipsPath")) 	/// 提示方向
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s LabelDesc=..GetRuleLabelDesc(RulID)  	/// 目录
	
	s SysItmID=$p(^DHCCKBRD(ID),"^",7)  /// 关系指针(右)
	s SysItmDesc=$case(+SysItmID=0,1:"",:$p(^DHCCKBCD(SysItmID),"^",2))
	s RuleStyle=$p(^DHCCKBRD(ID),"^",9)	// 输入值:input 带单位InputUom 	数据集:Constant 规则:Parameter	
	// 存在引用子规则时,先递归判断子规则
	//i (RuleStyle="Parameter")&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))	d
	i (SysItmID'="")&&(SysItmID'=CheckDicID)&&($d(^DHCCKBRULEDIC(0,"Dic",SysItmID)))  d
	.s Ret=..CheckChildRule(TipsPath,SysItmID,.TmpArr, .TmpMsgArr)	
	.s TmpArr("RulID")=RulID
	.i (TipsPath=1)&&(Ret=1) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="与"_SysItmDesc_"辅料可能发生不良反应;"	
	.i (TipsPath=0)&&(Ret=0) D	
	..s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)="可选择与"_SysItmDesc_"成分一起使用;"
	e  d
	.s Ret='TipsPath
	.s HisItemId="", Err=0
	.F  s HisItemId=$o(TmpArr("itemOrder",HisItemId)) Q:(HisItemId="")||(Err=1)  D
	..//q:DicID=ItemId
	..s HisItemIdCat=..GetExcipient(HisItemId)				// 获取药品的辅料
	..s Ret=$LISTFIND(HisItemIdCat,SysItmID)
	..s Err=$LISTFIND(HisItemIdCat,SysItmID)
	..s Ret=$case((+Ret>0),1:1,:0)
	..s Err=$case((+Err>0),1:1,:0)
	.	
	.s OpArith=$p(^DHCCKBRD(ID),"^",6)	
	.s OpArith=..TrsOpArith(OpArith)   	/// 运算符	
	.i OpArith="'="	s Ret='Ret			  /// != 在成分中表示除外成分（除xx以外的成分）
	
	.s GroupList=##Class(web.DHCCKBPass).GetLinkItm(RulID,ID,"TogetherProp")	// 是否有合用类别(组内,组间)
	.i GroupList'=""  d
	..s GroupID=$List(GroupList,1)
	..s GroupDesc=$p(^DHCCKBCD(GroupID),"^",2)
	..s GroupFlag=$case(GroupDesc,"组内":1,"组间":0,:0)
	.e  d
	..s GroupFlag=0
	.
	.s HisGroupFlag=..ISGroup(CheckDicID,SysItmID,.TmpArr)
	.i (TipsPath=1)&&(GroupFlag=1)&(HisGroupFlag=0) s:Ret=0 Ret='Ret	//禁忌：限定组内不能用，his是组间时,可以用
	.i (TipsPath=0)&&(GroupFlag=0)&(HisGroupFlag=1) s:Ret=1 Ret='Ret	//用法用量： 限定组间可以用,his时组内时，不可以用
	
	.i $g(TmpArr("RuleStype",RulID))="G" d	/// 普通规则:需要记录返回值. 公共规则:不需要记录返回值
	..i (TipsPath=1)&&(Ret=1)	d 
	...i OpArith="'=" s MTipMessgae="可选择与"_SysItmDesc_"辅料一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="与"_SysItmDesc_"辅料可能发生不良反应"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	..i (TipsPath=0)&&(Ret=0)	d
	...i OpArith="'=" s MTipMessgae=SysItmDesc_"辅料可能发生不良反应"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...e  s MTipMessgae="可选择与"_SysItmDesc_"辅料一起使用"_$case(GroupFlag,1:"(组内)",0:"(组间)")_";"
	...s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)=MTipMessgae
	
	Q Ret
}

///  Descript:  输出
///  w ##Class(web.DHCCKBPass).PrintReview("67","1",.TMPArr)
ClassMethod PrintReview(RulID As %String, isFailFlag As %String, TmpMsgArr) As %String
{
	n (RulID, isFailFlag, TmpMsgArr)
	s itemID=$p(^DHCCKBRULE(RulID),"^",1)          /// 实体对象
	s RuleType=..GetRuleTypeDesc(RulID)            /// 实体描述
	s OutType=$s(isFailFlag=0:"else",1:"then")     /// 输出类型
	k TmpTipArr
	s Type=""
	F  s Type=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type)) Q:Type=""  D
	.s ID=""
	.F  s ID=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type,ID)) Q:ID=""  D
	..s varVal="",varCode=""
	..s listData = $g(^CKB.PDSS.RuleActionD(ID))
	..s LkDicID= $lg(listData,5)
	..i LkDicID'="" s varCode=$p(^DHCCKBCD(LkDicID),"^",1)   /// 实体代码
	..s varText= $lg(listData,6) 
	..Q:$D(TmpTipArr(varText))
	..s TmpTipArr(varText)=""
	..i '$D(TmpMsgArr("itemOrder",itemID,RuleType,RulID)) D
	...s TmpMsgArr("itemOrder",itemID,RuleType,RulID)=""     /// 初始化输出
	../// 管理级别
	..i varCode="LevelFlag" D
	...s $p(TmpMsgArr("itemOrder",itemID),"^",3)=varText
	...s $p(TmpMsgArr("itemOrder",itemID,RuleType,RulID),"^",2)=varText
	../// 通过标识
	..i varCode="PassFlag" D
	...s $p(TmpMsgArr("itemOrder",itemID,RuleType,RulID),"^",1)=varText
	../// 提示信息
	..i varCode="WarnMessage" D
	...i $p(TmpMsgArr("itemOrder",itemID,RuleType,RulID),"^",3)="" s $p(TmpMsgArr("itemOrder",itemID,RuleType,RulID),"^",3)=varText
	.
	Q ""
}

///  Descript:  取当前规则管控级别
///  w ##Class(web.DHCCKBPass).GetRulManLevel("1554","1")
ClassMethod GetRulManLevel(RulID As %String, isFailFlag) As %String
{
	n (RulID, isFailFlag)
	s OutType=$s(isFailFlag=0:"else",1:"then")     /// 输出类型
	s ManLevel=""
	s Node=""
	F  s Node=$o(^DHCCKBRULENODE(0,"Parent",RulID,OutType,0,Node))	q:Node=""  d
	.s ID=$o(^DHCCKBRD(0,"Node",Node,""))
	.q:ID=""
	.s LeftDicID=$p($g(^DHCCKBRD(ID)),"^",3)	// 实体
	.s VarCode=$p(^DHCCKBCD(LeftDicID),"^",1)	// 实体代码
	.s RightDicID=$p($g(^DHCCKBRD(ID)),"^",7)	// 管理级别
	.q:RightDicID=""
	.s VarText=$p($g(^DHCCKBCD(RightDicID)),"^",1)
	./// 管理级别
	.i VarCode="LevelFlag" s ManLevel=VarText	
	.
	
	Q ManLevel
}

///  Descript:  知识库输出结构
///  w ##Class(web.DHCCKBPass).InvOutRes(.TmpMsgArr)
ClassMethod InvOutRes(TmpArr As %String, TmpMsgArr As %String) As %String
{
	n (TmpArr, TmpMsgArr)

	D ..TakToOutputMsg(.TmpArr, .TmpMsgArr)  /// 初始化知识库输出

	s TmpString="["
	s TmpString=TmpString_##Class(web.DHCAPPJsonCommon).getJsonDataText("passFlag^manLevel",$g(TmpMsgArr("passFlag"))_"^"_$g(TmpMsgArr("manLevel")))
	s TmpString=TmpString_",""items"":["
	s item="", itemNum=0	
	//F  s item=$o(TmpMsgArr("itemOrder",item)) Q:item=""  D
	F  s item=$o(TmpArr("itemOrder",item)) Q:item=""  D
	.s isExistFlag=##class(web.DHCCKBCommon).IsExistRule(item)
	.i (isExistFlag=0)&&('$d(TmpMsgArr("itemOrder",item)))	d
	..s TmpMsgArr("itemOrder",item)=TmpArr("itemOrder",item,"Unique")_"^"_TmpArr("itemOrder",item,"PhDesc")_"^"_"normal"	// 药品无规则,需要提醒（是否还要判断分类有无规则）	
	..s TmpMsgArr("itemOrder",item,"说明书")=0
	.q:'$d(TmpMsgArr("itemOrder",item))
	.q:$o(TmpMsgArr("itemOrder",item,""))=""
	.q:$g(TmpMsgArr("itemOrder",item))=""
	.s itemNum=itemNum+1
	.s Prefix=$s(itemNum=1:"",1:",")	
	.s TmpString=TmpString_Prefix_##Class(web.DHCAPPJsonCommon).getJsonDataText("unique^item^manLevel^itmID",$g(TmpMsgArr("itemOrder",item))_"^"_item)
	.s TmpString=TmpString_",""tips"":["
	.s MaxDosQty=(+$g(TmpArr("itemOrder",item,"DosQty"))*$g(TmpArr("itemOrder",item,"Duration")))_$g(TmpArr("itemOrder",item,"DosUom"))
	.s ListData=$g(TmpArr("PatBDay"))_"^"_$g(TmpArr("Height"))_"^"_$g(TmpArr("Weight"))
	.s ListData=ListData_"^"_$g(TmpArr("itemOrder",item,"Instr"))_"^"_$g(TmpArr("itemOrder",item,"Freq"))_"^"_$g(TmpArr("itemOrder",item,"Duration"))
	.s ListData=ListData_"^"_$g(TmpArr("itemOrder",item,"DosQty"))_$g(TmpArr("itemOrder",item,"DosUom"))_"^"_MaxDosQty
	.s TmpString=TmpString_##Class(web.DHCAPPJsonCommon).getJsonData("Birth^Height^Weight^Instr^Freq^Duration^DoseUom^MaxDosQty",ListData)
	.s TmpString=TmpString_"]"
	.s TmpString=TmpString_",""warns"":["
	.s LabelDesc="", count=0
	.F  s LabelDesc=$o(TmpMsgArr("itemOrder",item,LabelDesc)) Q:LabelDesc=""  D
	..q:$P($g(TmpMsgArr("itemOrder",item,LabelDesc)),"^",1)=1	//目录通过标志
	..s tmpRuleID=$o(TmpMsgArr("itemOrder",item,LabelDesc,""))	// 药品无规则,提示
	..i tmpRuleID=""  d
	...s tmpMsgNode=$p($g(TmpMsgArr("itemOrder",item,LabelDesc)),"^",2)
	...s tmpMsgNode=$case(tmpMsgNode="",1:"无说明书;",:"无匹配的"_$LISTTOSTRING(tmpMsgNode)_"规则;")
	...s ListData=LabelDesc_"^"_tmpMsgNode_"^"_"normal"_"^"_"正常" //kml 2020-03-02 无说明书不应提示正常
	...s count = count+1
	...s Prefix=$s(count=1:"",1:",")
	...s TmpString=TmpString_Prefix_##Class(web.DHCAPPJsonCommon).getJsonData("itemkey^itemval^manLevel^manLev",ListData)
	..
	..q:tmpRuleID=""	
	..s RuleID=""
	..F  s RuleID=$o(TmpMsgArr("itemOrder",item,LabelDesc,RuleID)) Q:RuleID=""  D
	...s RuleValue=$p($g(TmpMsgArr("itemOrder",item,LabelDesc,RuleID)),"^",3)		// 规则的提醒内容
	...s PassFalg=$p($g(TmpMsgArr("itemOrder",item,LabelDesc,RuleID)),"^",1)
	...s SetPassFlag=$p($g(TmpMsgArr("itemOrder",item,LabelDesc,RuleID)),"^",4)		// 实际通过标记
	...//q:(PassFalg="HasPass")	// 通过的标记 不需要项目的返回值
	...//q:SetPassFlag=1
	...s ItmValue=..GetRuleItmValue(.TmpMsgArr,item,LabelDesc,RuleID)				// 规则中具体项目的提示内容
	...s TmpValue=""
	...i ItmValue'="" s TmpValue=ItmValue_" "_RuleValue
	...i ItmValue="" s TmpValue=RuleValue
	...s PropValue=TmpValue
	...Q:PropValue=""
	...s manLevel=$p($g(TmpMsgArr("itemOrder",item,LabelDesc,RuleID)),"^",2)
	...s manLev=##class(web.DHCCKBCommon).GetDicDescByCode(manLevel)	// 没有维护级别时，保持和整体的级别一致
	...s:manLevel="" manLevel=$g(TmpMsgArr("manLevel"))
	...s:manLev="" manLev=##class(web.DHCCKBCommon).GetDicDescByCode(manLevel)
	...//s ListData=PropKey_"("_RuleID_")"_"^"_PropValue_"^"_manLevel_"^"_manLev
	...s ListData=LabelDesc_"^"_PropValue_"^"_manLevel_"^"_manLev
	...s count = count+1
	...s Prefix=$s(count=1:"",1:",")
	...s TmpString=TmpString_Prefix_##Class(web.DHCAPPJsonCommon).getJsonData("itemkey^itemval^manLevel^manLev",ListData)
	..
	.	
	.s TmpString=TmpString_"]}"
	s TmpString=TmpString_"]}]"
	s TmpArr("OutParams")=TmpString

	Q ""
}

///  Descript:  提示信息
///  w ##Class(web.DHCCKBPass).InsErrMessage("", "", .TmpArr)
ClassMethod InsErrMessage(RulID As %String, Parref As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, Parref, TmpArr, TmpMsgArr)
	k TmpTipsArr
	s itmid=$p(^DHCCKBRULE(RulID),"^",1)    /// 实体对象
	s ID=""
	F  s ID=$o(^DHCCKBRD(0,"RuleParref",RulID,Parref,ID)) Q:ID=""  D
	.s LeftID=$p(^DHCCKBRD(ID),"^",3)        /// 关系指针(左)
	.Q:$D(TmpTipsArr(LeftID))
	.s TmpTipsArr(LeftID)=""
	.s LeftDicCode=$p($g(^DHCCKBCD(LeftID)),"^",1)   /// 相关实体代码
	.s itmValId=$p(^DHCCKBRD(ID),"^",7)      /// 关系指针(右)
	.s RulType=..GetRuleTypeCode(RulID)      /// 类型代码
	.s PropKey=..GetRuleTypeDesc(RulID)      /// 类型描述
	.s mTipMessgae=""
	./// 给药途径
	.i LeftDicCode="DrugPreMet" s mTipMessgae="给药途径不正确！"
	./// 频率
	.i LeftDicCode="DrugFreq" s mTipMessgae="给药途径不正确！"
	.s mTipMessgae=$g(TmpArr("itemOrder",itmid,"PhDesc"))_mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",3)=mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",2)=..GetRulManLevel(RulID,0)
	.
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
///  w ##Class(web.DHCCKBPass).GetDicByRuleID(2218)
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

/// Descript:	目录代码
/// w ##Class(web.DHCCKBPass).GetRuleLabelCode("1563")
ClassMethod GetRuleLabelCode(RuleID As %String) As %String
{
	n (RuleID)
	
	q:RuleID="" ""
	
	s RetDicID=""
	s DicID=""
	f  s DicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,DicID))	  q:(DicID="")||(RetDicID'="")  d
	.s ParentID=$p(^DHCCKBCD(DicID),"^",3)
	.q:ParentID=""
	.q:ParentID'=##class(web.DHCCKBCommon).GetDrugLibaryData()
	.q:'$d(^DHCCKBRULEDIC(0,"RuleParentDic",RuleID,ParentID))
	.s RetDicID=DicID
	
	q:RetDicID="" ""
	q $p($g(^DHCCKBCD(RetDicID)),"^",1)
}

/// Descript:	目录描述
/// w ##Class(web.DHCCKBPass).GetRuleLabelDesc("2219")
ClassMethod GetRuleLabelDesc(RuleID As %String) As %String
{
	n (RuleID)
	
	q:RuleID="" ""
	
	s RetDicID=""
	s DicID=""
	f  s DicID=$o(^DHCCKBRULEDIC(0,"RuleDic",RuleID,DicID))	  q:(DicID="")||(RetDicID'="")  d
	.s ParentID=$p(^DHCCKBCD(DicID),"^",3)
	.q:ParentID=""
	.q:ParentID'=##class(web.DHCCKBCommon).GetDrugLibaryData()
	.q:'$d(^DHCCKBRULEDIC(0,"RuleParentDic",RuleID,ParentID))
	.s RetDicID=DicID
	
	q:RetDicID="" ""
	q $p($g(^DHCCKBCD(RetDicID)),"^",2)
}

/// Descript:	具体项目的返回值
/// w ##Class(web.DHCCKBPass).GetRuleLabelDesc("1554")
ClassMethod GetRuleItmValue(TmpMsgArr, Item, PropKey, RuleID) As %String
{
	n (TmpMsgArr,Item,PropKey,RuleID)
	
	s PassFalg=$p($g(TmpMsgArr("itemOrder",Item,PropKey,RuleID)),"^",1)
	//q:(PassFalg="HasPass") ""		// 通过的标记 不需要项目的返回值
	
	s Value=""
	s ID=""
	f  s ID=$o(TmpMsgArr("itemOrder",Item,PropKey,RuleID,ID))  q:ID=""  d
	.s TmpValue=$g(TmpMsgArr("itemOrder",Item,PropKey,RuleID,ID))
	.i Value="" s Value=TmpValue
	.e  s Value=Value_" "_TmpValue
	
	q Value
}

/// Descript:	根据目录，确定提示的正反向，如：用法用量是反向提示，不满足时提示， 禁忌症时正向向提示，满足时提示
/// Returnn:	0 反向 1 正向
/// w ##Class(web.DHCCKBPass).GetLabelTipsPath("1620")
ClassMethod GetLabelTipsPath(RulID) As %String
{
	n (RulID)

	s LabelDesc=##Class(web.DHCCKBPass).GetRuleLabelDesc(RulID)

	q $case((LabelDesc["注意事项")||(LabelDesc["不良反应")||(LabelDesc["禁忌")||(LabelDesc["配伍")||(LabelDesc["相互作用")||(LabelDesc["重复用药")||(LabelDesc["警告"),1:1,:0)
}

/// Descript:	根据目录的关系，清除具体项目的返回值信息
/// w ##Class(web.DHCCKBPass).GetRuleLabelDesc("1554")
ClassMethod KillNodeMsgStr(RulID, IsGrpTrue, NodeID, TmpArr, TmpMsgArr) As %String
{
	n (RulID,IsGrpTrue,NodeID,TmpArr,TmpMsgArr)
	
	s LabelDesc=##Class(web.DHCCKBPass).GetRuleLabelDesc(RulID)
	q:LabelDesc="" ""
	s CheckDicID=TmpArr("CheckDicID") //..GetDicByRuleID(RulID)			/// 实体对象
	s TipsPath=..GetLabelTipsPath(RulID)			/// 提醒方向

	i (TipsPath=0)&(IsGrpTrue=1) || ((TipsPath=1)&(IsGrpTrue=0)) d
	.s ID=""
	.f  s ID=$o(^DHCCKBRD(0,"Node",NodeID,ID)) Q:ID=""  D
	..k TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,ID)
}

/// Descript:	根据前提条件的结果，清除具体项目的返回值信息
/// w ##Class(web.DHCCKBPass).GetRuleLabelDesc("1554")
ClassMethod KillRuleDataMsgStr(RulID, RuleDataID, TmpMsgArr) As %String
{
	n (RulID,RuleDataID,TmpMsgArr)
	
	s LabelDesc=##Class(web.DHCCKBPass).GetRuleLabelDesc(RulID)
	s CheckDicID=..GetDicByRuleID(RulID)			/// 实体对象
	k TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID,RuleDataID)
}

/// 获取相关联的药品 如：溶媒浓度,获取对应的溶媒药品  
/// w ##Class(web.DHCCKBPass).GetLinkItm(2466,45278,"TogetherProp")
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
	
	q drugList
}

/// 判断是成组医嘱 
/// 成组(组内)1  不成组(组间)0  
/// w ##Class(web.DHCCKBPass).ISGroup(78,77) 
ClassMethod ISGroup(CheckDicID, LinkDicID, TmpArr) As %String
{
	n (CheckDicID,LinkDicID,TmpArr)
	
	s CheckSeqNo=$g(TmpArr("itemOrder",CheckDicID,"SeqNo"))
	q:CheckSeqNo="" 0	//1 1.1 1.2

	s LinkSeqNo=$g(TmpArr("itemOrder",LinkDicID,"SeqNo"))
	q:LinkSeqNo="" 0
	
	i $p(CheckSeqNo,".",1)=$p(LinkSeqNo,".",1) q 1

	q 0
}

/// 获取进一步说明
/// w ##Class(web.DHCCKBPass).ISGroup(78,77) 
ClassMethod GetExlanMsg(RulID, OutType) As %String
{
	n (RulID,OutType)
	//s OutType=$s(OutType="else":"then",OutType="then":"else")     /// 进一步说明所在输出类型
	q:OutType="" ""
		
	// 获取进一步说明信息
	//s ExlanMsg=..(RulID,OutType)
	s ExlanMsg=""
	s ParID=""
	F  s ParID=$o(^DHCCKBRULENODE(0,"Parent",RulID,OutType,0,ParID)) Q:ParID=""  D
	.s ID="", isTrueNum=0, isTrue=0
	.F  s ID=$o(^DHCCKBRD(0,"Node",ParID,ID)) Q:ID=""  D
	..s varCode="",varText=""
	..s LkLDicID=$p(^DHCCKBRD(ID),"^",3)
	..i +LkLDicID'=0 s varCode=$p(^DHCCKBCD(LkLDicID),"^",1)   /// 实体代码
	..s LkRDicID=$p(^DHCCKBRD(ID),"^",7)
	..i +LkRDicID'=0 s varText=$p(^DHCCKBCD(LkRDicID),"^",1)   /// 实体代码
	..E  s varText=$p(^DHCCKBRD(ID),"^",8)
	..i varCode="WarnMessage" D
	...s ExlanMsg=$case((varText=""),1:"",:varText_"(进一步说明)")
	
	q ExlanMsg
}

/// 提醒规则  是否全部通过，才提醒(预留,从配置取)
/// 判断规则: 用法用量中，如果有多条，需要所有的规则通过。即有一条规则不通过，就需要弹窗提醒出该规则
/// 判断规则: 适应证中有多条规则，满足一条通过，即有一条规则匹配上，则不需要弹窗提醒。若没有一条满足的规则，则会对每条规则进行提醒
/// 判断规则: 禁忌证/相互作用/注意事项/配伍禁忌 中有多条规则，满足一条认为则为不通过，即有一条规则匹配上，则需要弹窗提醒。当所有的规则都不满足时，则不需要弹窗提
/// Return:		1 是 0 否
/// w ##class(web.DHCCKBPass).GetLabelRule("注意事项")
ClassMethod GetLabelRule(label)
{
	
	n (label)
	
	q $case(label["适应",1:0,:1)
}

/// Input:	RuleType 区分普通规则("G" -general)和公共规则("C" -common)
ClassMethod CheckRule(ItmCatID, ItmID, TmpArr, TmpMsgArr, LabelArr)
{

	n (ItmCatID,ItmID,TmpArr,TmpMsgArr,LabelArr)
				
	s CheckItmID=$case(ItmCatID'="",1:ItmCatID,:ItmID)
	
	s RulDicID=""
	F  s RulDicID=$o(^DHCCKBRULEDIC(0,"Dic",CheckItmID,RulDicID)) Q:RulDicID=""  D
	.s IsFailFlag=1	// 默认通过
	.s RulID=$p(^DHCCKBRULEDIC(RulDicID),"^",1) 	/// 规则ID
	.Q:$p(^DHCCKBRULE(RulID),"^",3)'="Release"  	/// 未发布不加算在内
	.q:..isChildRule(RulID)=1	// 审查项目本身有子规则,不审子规则
	.s TmpArr("RulID")=RulID 
	.s TmpArr("TipsPath")=..GetLabelTipsPath(RulID)	/// 提醒方向
	.s TmpArr("CheckDicID")=ItmID
	.s TmpArr("RuleStype",RulID)="G"
	.s LabelDesc=..GetRuleLabelDesc(RulID)			// 审查目录
	.s TmpArr("LabelDesc")=LabelDesc
	.s LabelRule=..GetLabelRule(LabelDesc)			// 目录的判断规则 
	.k TmpPreConsArr
	.s condFlag=..TakPreConditions(RulID,.TmpPreConsArr)		// 优先判断规则中的所有前提条件,有前提条件且都满足的情况下,才进行进行后面的项目判断
	.s isPreCondFlag=..isPreConditions(RulID,.TmpPreConsArr,.TmpArr,.TmpMsgArr)
	.q:(condFlag=1)&(isPreCondFlag=0)
	.s TmpArr("RulID")=RulID 	// 判断条件时,若有引用规则，那么RulID会被改变，此时需要重新赋值
	.s ID=""
	.F  s ID=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",0,ID)) Q:ID=""  D
	..s RelType=$p(^DHCCKBRULENODE(ID),"^",2)   /// 关系类型
	..//i '..InvRuleData(ID,RelType,.TmpArr,.TmpMsgArr)  s isFailFlag=0       /// 验证不通过（一组规格结果）
	..s RuleFlag=..InvRuleData(ID,RelType,.TmpArr,.TmpMsgArr,"G")
	..q:RuleFlag=-1	
	..s RuleFlag=$case($g(TmpArr("TipsPath")),1:'RuleFlag,:RuleFlag)						
	..s LabelArr(CheckItmID,LabelDesc,RulID)=RuleFlag
	..i 'RuleFlag s IsFailFlag=0 
	..i RuleFlag=1 k TmpMsgArr("itemOrder",ItmID,LabelDesc,RulID)
	..// 记录目录通过标志（关注his中的项目值为空的情形）
	..i (LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,RulID))) s $p(TmpMsgArr("itemOrder",ItmID,LabelDesc),"^",1)=$p($g(TmpMsgArr("itemOrder",ItmID,LabelDesc)),"^",1)||LabelArr(CheckItmID,LabelDesc,RulID)
	..D ..ReaOutData(RulID, IsFailFlag, .TmpArr,.TmpMsgArr)	// 一组结果的输出
}

/// Input:	RuleType 区分普通规则("G" -general)和公共规则("C" -common)
ClassMethod CheckChildRule(TipsPath, ItmID, TmpArr, TmpMsgArr)
{

	n (TipsPath,ItmID,TmpArr, TmpMsgArr)

	s exitFlag=0	// 默认没有通过
	s RulDicID=""
	F  s RulDicID=$o(^DHCCKBRULEDIC(0,"Dic",ItmID,RulDicID)) Q:(RulDicID="")||(exitFlag=1)  D
	.s IsFailFlag=1	// 默认通过
	.s RulID=$p(^DHCCKBRULEDIC(RulDicID),"^",1) /// 规则ID
	.Q:$p(^DHCCKBRULE(RulID),"^",3)'="Release"  /// 未发布不加算在内
	.s TmpArr("RuleStype",RulID)="C" 	
	.s TmpArr("RulID")=RulID 	
	.s exitFlag=0
	.s ID=""
	.F  s ID=$o(^DHCCKBRULENODE(0,"Parent",RulID,"if",0,ID)) Q:ID=""  D
	..s RelType=$p(^DHCCKBRULENODE(ID),"^",2)   /// 关系类型
	..s RuleFlag=..InvRuleData(ID,RelType,.TmpArr,.TmpMsgArr,"C")
	..q:RuleFlag=-1								// 通过是1 不通过是0
	..//i (TipsPath=1) s RuleFlag='RuleFlag		// 用法用量  1 是通过  0 是不通过 	// 禁忌症 	 1 是不通过 0 是通过
	..i RuleFlag=1 s exitFlag=1

	q exitFlag
}

/// Descript:判断规则是子规则还是项目的本身规则（因为没有办法区分子规则和项目本身的规则,使用是否有目录来区分）
/// 是子规则1  不是指规则0
/// w ##Class(web.DHCCKBPass).isChildRule(3537)
ClassMethod isChildRule(RulID) As %String
{
	n (RulID)
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()	// 目录
	
	q:'$d(^DHCCKBRULEDIC(0,"RuleParentDic",RulID,DrugLibary)) 1
	
	q 0
}

/// Descript:剂量转换系数(根据体重)
/// Input:	患者体重,规则中单位体重
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
	
	q fac*PatWeiht
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBPass","InsTmpGlobal",pid)
	k ^TMP("DHCCKB","web.DHCCKBPass","InsTmpErrMsg",pid)
	k ^TMP("Num",pid)
	Q ""
}

/// Descript:根据HIS数据取知识库对照数据（若无对照关系，返回知识库code）
/// Input:HIS描述 如医嘱，手术，特殊人群等
/// Output:知识库描述
/// w ##class(web.DHCCKBPass).GetKnowBaseCode("产褥期心功能不全")
ClassMethod GetKnowBaseCode(HisItmCode)
{
	n (HisItmCode)
	Q:('$d(^CKB.PDSS.ComContrastI("HisCode",HisItmCode)))&&('$d(^CKB.PDSS.ComContrastI("HisDesc",HisItmCode))) HisItmCode  //若无对照关系，先返回code，以便在线演示方便
	s CLibId=$o(^CKB.PDSS.ComContrastI("HisCode",HisItmCode,""))
	s:CLibId="" CLibId=$o(^CKB.PDSS.ComContrastI("HisDesc",HisItmCode,""))
	//s LibDesc=$lg(^CKB.PDSS.ComContrastD(CLibId),3)			//描述
	s LibCode=$lg(^CKB.PDSS.ComContrastD(CLibId),2)	//Code
	Q LibCode
}

/// d ##class(web.DHCCKBPass).testt()
ClassMethod testt()
{
	
	s count=1
	/*
	w $h,!,$zts,!
	f i=1:1:10000 d
	.f j=i:1:10000 d
	..s count=count+i
	w $h,!,$zts,!
	w count
	*/
	
	//f i=1:1:32  d
	//.s TMPQNP(i,i)="除外列：表示除了列出来的那个内容，其他的内容都可以用。 因此含有除外列时，要考虑比值符号除外列：表示除了列出来的那个内容，其他的内容都可以用。 因此含有除外列时，要考虑比值符号除外列：表示除了列出来的那个内容，其他的内容都可以用。 因此含有除外列时，要考虑比值符号"
	//.s TMPQNP1(i,i)="除外列：表示除了"
	//.//f j=1:1:32 d
	//.//.s str="ret=##class(web.DHCCKBPass)."_"test"_j_"(.TMPQNP,.TMPQNP1)"
	s i=1
	s TMPQNP(i,i)="除外列：表示除了列出来的那个内容，其他的内容都可以用。 因此含有除外列时，要考虑比值符号除外列：表示除了列出来的那个内容，其他的内容都可以用。 因此含有除外列时，要考虑比值符号除外列：表示除了列出来的那个内容，其他的内容都可以用。 因此含有除外列时，要考虑比值符号"
	s TMPQNP1(i,i)="除外列：表示除了"

	s ret=##class(web.DHCCKBPass).test1(.TMPQNP,.TMPQNP1,.i)
}

}

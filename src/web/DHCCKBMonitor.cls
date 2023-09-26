Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-06-20
/// Descript: 		知识库监测类
Class web.DHCCKBMonitor Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 知识库审查
/// W ##Class(web.DHCCKBMonitor).InvKnowBaseExam("{""PatName"":""测试患者"",""PatSex"":""男"",""PatBDay"":""1988-03-09"",""Height"":""178"",""Weight"":""158"",""Liver"":""1"",""Renal"":""2"",""SpecGrps"":""70"",""PreFlag"":""否"",""itemAyg"":[],""itemDis"":[{""Warn"":""5"",""Item"":" """,""id"":""itemDis"",""item"":""中耳炎""},{""Warn"":""6"",""Item"":"""",""id""   :""itemDis"",""item"":""鼻窦炎""},{""Warn"":""7"",""Item"":"""",""id"":""itemDis"",""item"":""咽炎""}],""itemLab"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""4"",""Item"":"""",""PForm"":""针剂"",""DosQty"":""1"",""DosUom"":""mg"",""Instr"":""静脉滴注"",""Freq"":""tid"",""Duration"":""6天"",""id"":""itemOrder"",""PhDesc"":""注射用头孢呋辛钠""},{""Warn"":""25"",""PhDesc"":""万古霉素"",""PForm"":"""",""DosQty"":"""",""DosUom"":"""",""Instr"":"""",""Freq"":"""",""Duration"":"""",""id"":""itemOrder"":""""}]}")
/// W ##Class(web.DHCCKBMonitor).InvKnowBaseExam("{""PatName"":""测试患者""}")
/// W ##Class(web.DHCCKBMonitor).InvKnowBaseExam("{""PatName"":""测试患者",""PatSex"":""男"",""PatBDay"":""1988-03-09"",""Height"":""178"",""Weight"":""158"",""Liver"":""1"",""Renal"":""2"",""SpecGrps"":""70"",""PreFlag"":""否"",""itemAyg"":[],""itemDiss"":[{""Warn"":""5"",""Item"":"""",""id"":""itemDis"",""item"":""中耳炎""},{""Warn"":""6"",""Item"":"""",""id"":""itemDis"",""item"":""鼻窦炎""},{""Warn"":""7"",""Item"":"""",""id"":""itemDis"",""item"":""咽炎""}],""itemLab"":[],""itemOper"":[],""itemOrder"":[{""Warn"":""4"",""Item"":"""",""PForm"":""针剂"",""DosQty"":""1"",""DosUom"":""mg"",""Instr"":""静脉滴注"",""Freq"":""tid"",""Duration"":""6天"",""id"":""itemOrder"",""PhDesc"":""注射用头孢呋辛钠""},{""Warn"":""25"",""PhDesc"":""万古霉素"",""PForm"":"""",""DosQty"":"""",""DosUom"":"""",""Instr"":"""",""Freq"":"""",""Duration"":"""",""id"":""itemOrder""}] }")
ClassMethod InvKnowBaseExam(jsParamObj As %String) As %String
{
	n (jsParamObj)
		
	/// 错误陷阱
	//s $ZT="ErrorMessage"
	s ^TMPMonitor("Monitor")=jsParamObj
	k TmpArr, TmpMsgArr
	
	/// 解析json参数
	D ..TrsInsTmpArr(..TrsToArrs(jsParamObj), .TmpArr)

	/// 知识库审查
	D ..IntDecMonitor(.TmpArr, .TmpMsgArr)

	/// 结果输出
	D ##Class(web.DHCCKBMonitor).InvRes(.TmpArr, .TmpMsgArr)
	
	Q ""

ErrorMessage
	D ..TakErrorMessage("-99^审查出错！")
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
	s TmpArr("SpecGrps")=arrsObj.GetAt("SpecGrps")   /// 特殊人群
	s TmpArr("PreFlag")=arrsObj.GetAt("PreFlag")   	 /// 怀孕
	s itemAyg = arrsObj.GetAt("itemAyg")             /// 过敏源

	i itemAyg'="" D
	.s Total=itemAyg.Count()
	.F i=1:1:Total D
	..s itmid=..GetComDicId(itemAyg.GetAt(i).GetAt("item"))   /// 疾病-根据描述取字典ID
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
	..s itmid=..GetComDicId(itemLab.GetAt(i).GetAt("item"))   /// 检验-根据描述取字典ID
	..Q:itmid=""  /// 知识库未维护
	..s TmpArr("itemLab",itmid,"Item")=itemLab.GetAt(i).GetAt("item")
	..s TmpArr("itemLab",itmid,"Val")=itemLab.GetAt(i).GetAt("Val")
	..//s TmpArr("itemLab",itmid,"Min")=itemLab.GetAt(i).GetAt("Min")
	..s TmpArr("itemLab",itmid,"Uom")=itemLab.GetAt(i).GetAt("Uom")
	.	
	s itemOrder = arrsObj.GetAt("itemOrder")         /// 处方信息
	i itemOrder'="" D
	.s Total=itemOrder.Count()
	.F i=1:1:Total D
	..s itmid=..GetComDicId(itemOrder.GetAt(i).GetAt("PhDesc"))   /// 药品-根据描述取字典ID
	..Q:itmid=""  /// 知识库未维护
	..s TmpArr("itemOrder",itmid,"Unique")=itemOrder.GetAt(i).GetAt("Warn")       /// 唯一标识
	..s TmpArr("itemOrder",itmid,"PhDesc")=itemOrder.GetAt(i).GetAt("PhDesc")     /// 药物名称
	..s TmpArr("itemOrder",itmid,"PForm")=itemOrder.GetAt(i).GetAt("PForm")       /// 药物剂型
	..s TmpArr("itemOrder",itmid,"Instr")=itemOrder.GetAt(i).GetAt("Instr")       /// 给药方式
	..s TmpArr("itemOrder",itmid,"Freq")=itemOrder.GetAt(i).GetAt("Freq")         /// 给药频次
	..s TmpArr("itemOrder",itmid,"Duration")=itemOrder.GetAt(i).GetAt("Duration") /// 给药疗程
	..s TmpArr("itemOrder",itmid,"DosQty")=itemOrder.GetAt(i).GetAt("DosQty")     /// 单次剂量
	..s TmpArr("itemOrder",itmid,"DosUom")=itemOrder.GetAt(i).GetAt("DosUom")     /// 剂量单位
	.
	Q ""
}

/// Descript:  初始化知识库输出
/// w ##Class(web.DHCCKBMonitor).TakToOutputMsg()
ClassMethod TakToOutputMsg(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s TmpMsgArr("passFlag")=0  /// 默认通过标志
	s TmpMsgArr("manLevel")=1  /// 默认管控级别
	s itmid=""
	F  s itmid=$o(TmpArr("itemOrder",itmid)) Q:itmid=""  D
	.s mListData=TmpArr("itemOrder",itmid,"Unique")_"^"_TmpArr("itemOrder",itmid,"PhDesc")_"^remind"
	.s TmpMsgArr("itemOrder",itmid)=mListData
	.
	Q ""
}

/// Descript:	根据描述取字典ID
ClassMethod GetComDicId(itemcode As %String) As %String
{
	n (itemcode)
	i itemcode[$c(1) s itemcode = $p(itemcode,$c(1),1)
	Q:itemcode="" ""
	s itmid=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(itemcode),""))  /// 按描述
	i itmid="" s itmid=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(itemcode),"")) /// 按代码
	Q itmid
}

/// Descript:	规则分类代码
/// w ##Class(web.DHCCKBMonitor).GetRuleTypeCode("33")
ClassMethod GetRuleTypeCode(ID As %String) As %String
{
	n (ID)
	s TypeID=$lg($g(^CT.CKB.PDSS.RuleD(ID)),6)  /// 规则类型
	Q:TypeID="" ""
	s Type=$lg($g(^CT.CKB.PDSS.CommonDictionD(TypeID)),2)  /// 实体描述
	Q Type
}

/// Descript:	规则分类描述
/// w ##Class(web.DHCCKBMonitor).GetRuleTypeDesc("33")
ClassMethod GetRuleTypeDesc(ID As %String) As %String
{
	n (ID)
	s TypeID=$lg($g(^CT.CKB.PDSS.RuleD(ID)),6)  /// 规则类型
	Q:TypeID="" ""
	s Type=$lg($g(^CT.CKB.PDSS.CommonDictionD(TypeID)),3)  /// 实体描述
	Q Type
}

/// Descript:  测试方法
/// w ##Class(web.DHCCKBMonitor).Test()
ClassMethod Test() As %String
{
	s TmpStr=^TMPMonitor("Monitor")
	D ..InvKnowBaseExam(TmpStr)
	Q ""
}

///  Descript:  根据出生日期获取年龄
///  w ##Class(web.DHCCKBMonitor).GetAge("2019-01-01")
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
///  Table:	    CT_CKB_PDSS.DicLinkAttr、CT_CKB_PDSS.RuleData
///  Output:    0 - 没有、1-有
///  w ##Class(web.DHCCKBMonitor).TakPreConditions("69", .TmpPreConsArr)
ClassMethod TakPreConditions(RulID As %String, TmpPreConsArr) As %String
{
	n (RulID, TmpPreConsArr)
	k TmpPreConsArr
	/// 当前规则前置条件
	s DicTypeID=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),6)    /// 规则类型
	s PropTypeID=""
	F  s PropTypeID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicTypeID,PropTypeID)) Q:PropTypeID=""  D
	.s LkID="", QuitFlag=1
	.F  s LkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicTypeID,PropTypeID,LkID)) Q:(LkID="")||(QuitFlag=0)  D
	..Q:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LkID)),5)="Y" /// 是否可用
	..s QuitFlag=0
	.i QuitFlag s TmpPreConsArr("PropType",PropTypeID)=""
	.
	Q ""
}

///  Descript:  当前规则是否有前置条件
///  Table:	    CT_CKB_PDSS.DicLinkAttr、CT_CKB_PDSS.RuleData
///  Output:    0 - 没有、1-有
///  w ##Class(web.DHCCKBMonitor).isPreConditions("69", .TmpPreConsArr, .TmpArr)
ClassMethod isPreConditions(RulID As %String, TmpPreConsArr, TmpArr) As %String
{
	n (RulID, TmpPreConsArr, TmpArr)
	
	Q:'$D(TmpPreConsArr("PropType")) 1        /// 当前规则类型未设置前置条件
	/// 当前规则定义是否满足所有的前置条件
	s PropTypeID="", isFlag=0
	F  s PropTypeID=$o(TmpPreConsArr("PropType",PropTypeID)) Q:(PropTypeID="")||(isFlag=1)  D
	.s Parref=$o(^CT.CKB.PDSS.RuleDataI("RuleParref",RulID,0,""))
	.s ID="", isTrue=0
	.F  s ID=$o(^CT.CKB.PDSS.RuleDataI("RuleParref",RulID,Parref,ID)) Q:(ID="")||(isTrue=1)  D
	..Q:$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4)'=PropTypeID      /// 关系指针(左)
	..Q:'..VerRule(RulID, ID, .TmpArr)      /// 前置条件规则判断
	..s isTrue=1
	.i isTrue=0 s isFlag=1  /// 前置条件在规则中不存在
	.
	Q isFlag
}

///  Descript:  知识库审查
///  w ##Class(web.DHCCKBMonitor).IntDecMonitor("63", .TmpArr)
ClassMethod IntDecMonitor(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	D ..TakToOutputMsg(.TmpArr, .TmpMsgArr)  /// 初始化知识库输出

	s itmid=""
	F  s itmid=$o(TmpArr("itemOrder",itmid)) Q:itmid=""  D
	.s RulType=""
	.F  s RulType=$o(^CT.CKB.PDSS.RuleD(0,"codeRelation",itmid,RulType)) Q:RulType=""  D
	..s RulID=""
	..F  s RulID=$o(^CT.CKB.PDSS.RuleD(0,"codeRelation",itmid,RulType,RulID)) Q:RulID=""  D
	...//Q:RulID'=176
	...D ..TakEveRulRev(RulID, .TmpArr, .TmpMsgArr)
	..
	Q ""
}

///  Descript:  单条规则审查
///  w ##Class(web.DHCCKBMonitor).TakEveRulRev(.TmpArr, .TmpMsgArr)
ClassMethod TakEveRulRev(RulID, TmpArr, TmpMsgArr) As %String
{
	n (RulID, TmpArr, TmpMsgArr)
	k TmpPreConsArr
	s RulType=..GetRuleTypeCode(RulID)                     /// 类型代码
	s RulTypeList=$LISTFROMSTRING("Usage")
	D ..TakPreConditions(RulID, .TmpPreConsArr)            /// 获取前置条件
	//i $LF(RulTypeList,RulType) Q:..isPreConditions(RulID, .TmpPreConsArr, .TmpArr) 0  /// 当前规则是否满足前置条件
	s ID="", isFailFlag=0
	F  s ID=$o(^CT.CKB.PDSS.RuleDataI("RuleParref",RulID,0,ID)) Q:ID=""  D
	.//Q:'$D(TmpPreConsArr("PropType",$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4))) /// 前置条件不再验证
	.i ..InvErgRule(RulID, ID, .TmpArr, .TmpMsgArr, .TmpPreConsArr)=1 s isFailFlag=1       /// 验证通过
	.D ..PrintReview(RulID, isFailFlag, .TmpMsgArr)
	.
	Q ""
}

///  Descript:  遍历规则
///  Output:    0 - 不符合规则、1-符合规则
///  w ##Class(web.DHCCKBMonitor).InvErgRule("", "", .TmpArr)
ClassMethod InvErgRule(RulID As %String, Parref As %String, TmpArr, TmpMsgArr, TmpPreConsArr) As %String
{
	n (RulID, Parref, TmpArr, TmpMsgArr, TmpPreConsArr)
	s RelType=$lg($g(^CT.CKB.PDSS.RuleDataD(Parref)),3)  /// 关系类型
	s ID="", isTrue=0, isTrueNum=0, Num=0
	F  s ID=$o(^CT.CKB.PDSS.RuleDataI("RuleParref",RulID,Parref,ID)) Q:(ID="")||((RelType="or")&(isTrue=1))  D
	.Q:$D(TmpPreConsArr("PropType",+$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4))) /// 前置条件不再验证
	.i ..isCorrect(RulID, ID, .TmpArr, .TmpMsgArr) s isTrueNum=isTrueNum+1, isTrue=1
	.//w "Every:ID:"_ID_"; isTrueNum:"_isTrueNum_"; isTrue:"_isTrue,!
	.s Num=Num+1
	.

	/// OR 类型提示信息输出
	i ((RelType="or")&(isTrue'=1))||((RelType="and")&(Num'=isTrueNum)) D
	.s itmid=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),2)    /// 实体对象
	.s RulType=..GetRuleTypeCode(RulID)      /// 类型代码
	.s PropKey=..GetRuleTypeDesc(RulID)      /// 类型描述
	.s mTipMessgae=""
	.s itemDesc=$g(TmpArr("itemOrder",itmid,"PhDesc"))
	./// 限制用药
	.i RulType="RuleLimitCTLoc" s mTipMessgae="您无使用"_itemDesc_"的权限"
	./// 适应症
	.i RulType="RuleIndic" s mTipMessgae=itemDesc_"超出适应证范围，请谨慎使用"
	.Q:mTipMessgae=""
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,0)
	
	i (RelType="or")&(isTrue'=1) D
	./// 用法用量
	.i RulType="Usage" D ..InsErrMessage(RulID, Parref, .TmpArr, .TmpMsgArr)
	
	//w "RelType:"_RelType_"; Parref:"_Parref_";"_"  Num:"_Num_"  isTrueNum:"_isTrueNum,!
	i (RelType="and")&(Num'=isTrueNum) Q 0
	
	Q isTrue
}

///  Descript:  规则是否匹配
ClassMethod isCorrect(RulID As %String, ID As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, ID, TmpArr, TmpMsgArr)
	s isFlag=0
	i $lg($g(^CT.CKB.PDSS.RuleDataD(ID)),10)="Parameter"  D     /// 规则类型
	.s RulID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)             /// 关联规则ID
	.s ID=+$o(^CT.CKB.PDSS.RuleDataI("RuleParref",RulID,0,""))
	.i ..InvErgRule(RulID, ID, .TmpArr, .TmpMsgArr, "") s isFlag=1
	E  i $lg($g(^CT.CKB.PDSS.RuleDataD(ID)),12)=1 D            /// 节点类型
	.i ..InvErgRule(RulID, ID, .TmpArr, .TmpMsgArr, "") s isFlag=1
	E  D
	.i ..VerRule(RulID, ID, .TmpArr, .TmpMsgArr) s isFlag=1
	Q isFlag
}

///  Descript:  验证条件
///  Output:    0 - 不匹配、1 - 匹配
///  w ##Class(web.DHCCKBMonitor).InvErgRule("", "", .TmpArr)
ClassMethod VerRule(RulID As %String, ID As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, ID, TmpArr, TmpMsgArr)
	s TmpArr("RulID")=RulID, TmpArr("ID")=ID
	s LeftDicCode=""
	s LeftID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4)      /// 关系指针(左)
	i LeftID'="" s LeftDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftID)),2)   /// 相关实体代码
	
	/// 商品名
	i LeftDicCode="Drug" Q:'..isMutEff(.TmpArr, .TmpMsgArr) 0
	/// 疾病
	i LeftDicCode="Disease" Q:'..isPermitDis(.TmpArr, .TmpMsgArr) 0
	/// 年龄
	i LeftDicCode="Age" Q:'..isPermitAge(.TmpArr, .TmpMsgArr) 0
	/// 特殊人群
	i LeftDicCode="SpecialPop" Q:'..isSpecialPop(.TmpArr, .TmpMsgArr) 0
	/// 性别
	i LeftDicCode="Sex" Q:'..isPermitSex(.TmpArr, .TmpMsgArr) 0
	/// 体重
	i LeftDicCode="Weight" Q:'..isPermitWeight(.TmpArr, .TmpMsgArr) 0
	/// 药品 给药途径
	i LeftDicCode="DrugPreMet" Q:'..isPermitPhaProp(.TmpArr, .TmpMsgArr) 0
	/// 药品 频率
	i LeftDicCode="DrugFreq" Q:'..isPermitFreq(.TmpArr, .TmpMsgArr) 0
	/// 单次给药剂量
	i LeftDicCode="OnceDose" Q:'..isPermitDosQty(.TmpArr, .TmpMsgArr) 0
	/// 疗程
	i LeftDicCode="Treatment" Q:'..isPermitDuration(.TmpArr, .TmpMsgArr) 0
	/// 药学分类  配伍禁忌
	i LeftDicCode="DrugCategory" Q:..isPermitTaboo(.TmpArr, .TmpMsgArr) 0
	/// 过敏史
	//i LeftDicCode="DrugCategory" Q:..isTakPatAgy(.TmpArr, .TmpMsgArr) 0
	/// 药品每日最大量
	i LeftDicCode="DayDoseMax" Q:'..isPermitDayMaxDose(.TmpArr, .TmpMsgArr) 0
	/// 药品每日用药量
	i LeftDicCode="DayDose" Q:'..isPermitDayDose(.TmpArr, .TmpMsgArr) 0
	/// 权限设置
	i RulType="RuleLimitCTLoc" Q:'..isPermitAut(.TmpArr, .TmpMsgArr) 0

	
	
#;	s itmid=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),2)  /// 实体对象
#;	s RulType=..GetRuleTypeCode(RulID)    /// 类型代码
#;	s LeftID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4)      /// 关系指针(左)
#;	//s LeftVal=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),5)   /// 关系描述
#;	s OpArith=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),7)     /// 运算关系
#;	s RighID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)      /// 关系指针(右)
#;	s RighVal=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)     /// 关系描述
#;	s LeftDicCode="",RighDicCode=""
#;	i LeftID'="" s LeftDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftID)),2)   /// 相关实体代码
#;	i RighID'="" s RighDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(RighID)),2)   /// 相关实体代码
#;	/// 运算符号转换
#;	s OpArith=$s(OpArith="Equals":"=",OpArith="GreaterThen":">",OpArith="LessThen":"<",OpArith="LessThenEquals":"<=",OpArith="GreaterThenEquals":">=",OpArith="Between":"L",1:"")
#;
#;	/// 商品名
#;	i LeftDicCode="Drug" Q:'..isMutEff(RulID, itmid, RighID, .TmpArr, .TmpMsgArr) 0
#;	/// 疾病
#;	i LeftDicCode="Disease" Q:'..isPermitDis(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 年龄
#;	i LeftDicCode="Age" Q:'..isPermitAge(ID, RighVal, OpArith, .TmpArr) 0
#;	/// 特殊人群
#;	i LeftDicCode="SpecialPop" Q:'..isSpecialPop(RulID, itmid, RighID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 性别
#;	i LeftDicCode="Sex" Q:'..isPermitSex(RighID, OpArith, .TmpArr) 0
#;	/// 体重
#;	i LeftDicCode="Weight" Q:'..isPermitWeight(RighVal, OpArith, .TmpArr) 0
#;	/// 药品 给药途径
#;	i LeftDicCode="DrugPreMet" Q:'..isPermitPhaProp(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 药品 频率
#;	i LeftDicCode="DrugFreq" Q:'..isPermitFreq(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 单次给药剂量
#;	i LeftDicCode="OnceDose" Q:'..isPermitDosQty(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 疗程
#;	i LeftDicCode="Treatment" Q:'..isPermitDuration(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 药学分类  配伍禁忌
#;	i LeftDicCode="DrugCategory" Q:..isPermitTaboo(RulID, itmid, RighID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 过敏史
#;	//i LeftDicCode="DrugCategory" Q:$LF($g(TmpArr("itemAyg")),RighID) 0
#;	/// 药品每日最大量
#;	i LeftDicCode="DayDoseMax" Q:'..isPermitDayMaxDose(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 药品每日用药量
#;	i LeftDicCode="DayDose" Q:'..isPermitDayDose(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
#;	/// 权限设置
#;	i RulType="RuleLimitCTLoc" Q:'..isPermitAut(RulID, itmid, ID, OpArith, .TmpArr, .TmpMsgArr) 0
	Q 1
}

/// Descript:	权限设置
ClassMethod isPermitAut(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s LeftID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4)       /// 关系指针(左)
	s RighID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)       /// 关系指针(右)
	s itmCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftID)),2)  /// 实体代码
	i itmCode="Doctor" Q:$g(TmpArr("CarePrvID"))'=RighID 0  /// 医生
	i itmCode="Office" Q:$g(TmpArr("DocLocID"))'=RighID 0   /// 科室
	//i itmCode="" Q:$g(TmpArr("PrvTpID"))'=itmValId 0      /// 职称
	Q 1
}

/// Descript:	疾病 (RuleContr-禁忌症)
ClassMethod isPermitDis(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s itmValId=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)      /// 关系指针(右)
	s ret=$LF($g(TmpArr("itemDis")),itmValId)
	s RelType=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),3)       /// 关系类型
	s RulType=..GetRuleTypeCode(RulID)      /// 类型代码
	i (RelType="and")||(RulType="RuleContr") D
	.s PropKey=..GetRuleTypeDesc(RulID)      /// 类型描述
	.s itmDis=$lg($g(^CT.CKB.PDSS.CommonDictionD(itmValId)),3)  /// 疾病
	.s mTipMessgae=$g(TmpArr("itemOrder",itmid,"PhDesc"))
	.s mTipMessgae=$s(RulType="RuleContr":mTipMessgae_"对"_itmDis_"患者禁止使用",1:"")
	.Q:mTipMessgae=""
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",3)=mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",2)=..GetRulManLevel(RulID,1)
	Q ret
}

/// Descript:	药学分类
ClassMethod isPermitTaboo(RulID As %String, itmid As %String, itmValId As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, itmValId, OpArith, TmpArr, TmpMsgArr)
	s itemid="", Err=1
	F  s itemid=$o(TmpArr("itemOrder",itemid)) Q:(itemid="")||(Err'=1)  D
	.Q:itmValId'=..GetPhCat(itemid)
	.s Err=0
	.s RulType=..GetRuleTypeCode(RulID)      /// 类型代码
	.s PropKey=..GetRuleTypeDesc(RulID)      /// 类型描述
	.s itmCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(itmValId)),3)  /// 药学分类
	.s mTipMessgae=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"与"_itmCat_"药品("_$g(TmpArr("itemOrder",itemid,"PhDesc"))_")"
	.s mTipMessgae=$s(RulType="Taboo":mTipMessgae_"存在配伍禁忌，不可同时使用",RulType="InterEach":mTipMessgae_"存在相互作用，不可同时使用",1:"")
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,0)
	Q Err
}

/// Descript:	药学分类
/// w ##Class(web.DHCCKBMonitor).GetPhCat("95")
ClassMethod GetPhCat(id As %String) As %String
{
	n (id)
	s PhCatID=##Class(web.DHCCKBCommon).GetPhCategory()   /// 药学分类
	s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",id,PhCatID,""))
	Q:LinkID="" 1
	s itmCatID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	Q itmCatID
}

/// Descript:	频次单位转化系数
/// w ##Class(web.DHCCKBMonitor).GetFreqFac("95")
ClassMethod GetFreqFac(id As %String) As %String
{
	n (id)
	Q:+id=0 1
	s FactorPropID=##Class(web.DHCCKBCommon).GetFacProp()   /// 单位转化系数实体
	s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",id,FactorPropID,""))
	Q:LinkID="" 1
	s Fac=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)
	Q Fac
}

/// Descript:	药品每日用药量
ClassMethod isPermitDayDose(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s Min=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)     /// 下线
	s UomID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)  /// 单位
	s Max=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),12)    /// 上限
	s Uom=$lg($g(^CT.CKB.PDSS.CommonDictionD(UomID)),3)  /// 单位描述
	s Freq=$g(TmpArr("itemOrder",itmid,"Freq"))
	s FreqId=..GetComDicId(Freq)
	s DosQty=$g(TmpArr("itemOrder",itmid,"DosQty"))
	s DoseUom=$g(TmpArr("itemOrder",itmid,"DosUom"))
	s DosQtyDay=DosQty*(..GetFreqFac(FreqId))
	i OpArith="L" s ret=(DosQtyDay>=Min)&(DosQtyDay<Max)
	E  s runStr="s ret="_DosQtyDay_OpArith_Min x runStr
	i ret=0 D
	.s PropKey=..GetRuleTypeDesc(RulID)  /// 实体描述
	.i OpArith="L" s retMsg="应在"_Min_"-"_Max_Uom_"之间"
	.E  s retMsg="需"_OpArith_Min_Uom
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"每日用药量"_retMsg
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,0)
	Q ret
}

/// Descript:	药品每日最大量
ClassMethod isPermitDayMaxDose(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s Min=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)     /// 下线
	s UomID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)  /// 单位
	s Uom=$lg($g(^CT.CKB.PDSS.CommonDictionD(UomID)),3)  /// 单位描述
	s Freq=$g(TmpArr("itemOrder",itmid,"Freq"))
	s FreqId=..GetComDicId(Freq)
	s DosQty=$g(TmpArr("itemOrder",itmid,"DosQty"))
	s DoseUom=$g(TmpArr("itemOrder",itmid,"DosUom"))
	s DosQtyDay=DosQty*(..GetFreqFac(FreqId))
	s runStr="s ret="_DosQtyDay_OpArith_Min
	x runStr
	i ret=0 D
	.s PropKey=..GetRuleTypeDesc(RulID)  /// 实体描述
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"超出每日最大量"
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,0)
	Q ret
}

/// Descript:	特殊人群
ClassMethod isSpecialPop(RulID As %String, itmid As %String, itmValId As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, itmValId, OpArith, TmpArr, TmpMsgArr)
	s SpecGrpsId=$g(TmpArr("SpecGrps"))
	s runStr="s ret="_SpecGrpsId_OpArith_itmValId
	x runStr
	i ret=0 D
	.s PropKey=..GetRuleTypeDesc(RulID)  /// 实体描述
	.//s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"不适用于特殊人群"
	Q ret
}

/// Descript:	药品属性限制 疗程
ClassMethod isPermitDuration(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s Min=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)     /// 下线
	s UomID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)  /// 单位
	s Max=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),12)    /// 上限
	s Uom=$lg($g(^CT.CKB.PDSS.CommonDictionD(UomID)),3)  /// 单位描述
	s Duration=+$g(TmpArr("itemOrder",itmid,"Duration"))
	i OpArith="L" s ret=(Duration>=Min)&(Duration<Max)
	E  s runStr="s ret="_Duration_OpArith_Min x runStr
	i ret=0 D
	.s PropKey=..GetRuleTypeDesc(RulID)  /// 实体描述
	.i OpArith="L" s retMsg="应在"_Min_"-"_Max_Uom_"之间"
	.E  s retMsg="需"_OpArith_Min_Uom
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"单次给药疗程"_retMsg
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,0)
	Q ret
}

/// Descript:	药品属性限制 单次剂量
ClassMethod isPermitDosQty(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s Min=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)     /// 下线
	s UomID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)  /// 单位
	s Max=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),12)    /// 上限
	s Uom=$lg($g(^CT.CKB.PDSS.CommonDictionD(UomID)),3)  /// 单位描述
	s DosQty=$g(TmpArr("itemOrder",itmid,"DosQty"))
	s DoseUom=$g(TmpArr("itemOrder",itmid,"DosUom"))
	Q:DoseUom'=Uom 0
	i OpArith="L" s ret=(DosQty>=Min)&(DosQty<Max)
	E  s runStr="s ret="_DosQty_OpArith_Min x runStr
	i ret=0 D
	.s PropKey=..GetRuleTypeDesc(RulID)  /// 实体描述
	.i OpArith="L" s retMsg="应在"_Min_"-"_Max_Uom_"之间"
	.E  s retMsg="需"_OpArith_Min_Uom
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"单次给药剂量"_retMsg
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,0)
	Q ret
}

/// Descript:	药品属性限制
ClassMethod isPermitFreq(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s itmValId=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)      /// 关系指针(右)
	s Freq=$g(TmpArr("itemOrder",itmid,"Freq"))
	s FreqId=..GetComDicId(Freq)
	i FreqId'=itmValId D
	.s PropKey=..GetRuleTypeDesc(RulID)  /// 实体描述
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",3)=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"给药频次错误"
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",2)=..GetRulManLevel(RulID,0)
	Q:FreqId'=itmValId 0
	Q 1
}

/// Descript:	药品属性限制
ClassMethod isPermitPhaProp(RulID As %String, itmid As %String, ID As %String, OpArith As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, itmid, ID, OpArith, TmpArr, TmpMsgArr)
	s itmValId=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)      /// 关系指针(右)
	s Instr=$g(TmpArr("itemOrder",itmid,"Instr"))
	s InstrId=..GetComDicId(Instr)
	s RelType=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),3)       /// 关系类型
	s RulType=..GetRuleTypeCode(RulID)      /// 类型代码
	i (RelType="and")&(InstrId'=itmValId) D
	.s PropKey=..GetRuleTypeDesc(RulID)      /// 类型描述
	.s itmDis=$lg($g(^CT.CKB.PDSS.CommonDictionD(itmValId)),3)  /// 疾病
	.s mTipMessgae=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"给药途径不正确！"
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",3)=mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,ID),"^",2)=..GetRulManLevel(RulID,0)
	Q:InstrId'=itmValId 0
	Q 1
}

/// Descript:	体重限制
ClassMethod isPermitWeight(itmVal As %String, OpArith As %String, TmpArr As %String) As %String
{
	n (itmVal, OpArith, TmpArr)
	s Weight=$g(TmpArr("Weight"))
	s runStr="s ret="_Weight_OpArith_itmVal
	x runStr
	Q ret
}

/// Descript:	性别限制
ClassMethod isPermitSex(itmValId As %String, OpArith As %String, TmpArr As %String) As %String
{
	n (itmValId, OpArith, TmpArr)
	s itmDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(itmValId)),3)  /// 描述
	Q:itmDesc'=$g(TmpArr("PatSex")) 0
	Q 1
}

/// Descript:	年龄限制
ClassMethod isPermitAge(ID As %String, itmVal As %String, OpArith As %String, TmpArr As %String) As %String
{
	n (ID, itmVal, OpArith, TmpArr)
	s Min=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)     /// 下线
	s UomID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)  /// 单位
	s Max=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),12)    /// 上限
	//s PatAge=..GetAge($g(TmpArr("PatBDay"))) /// 单位换算
	s PatAge=$g(TmpArr("PatBDay"))    /// 单位换算
	Q:PatAge="" 0
	s Uom=$lg($g(^CT.CKB.PDSS.CommonDictionD(UomID)),2) /// 取年龄描述
	s:Uom="岁" Min=Min*365,Max=Max*365
	s:Uom="月" Min=Min*30,Max=Max*30
	s PatAge=+$H-$zdh(PatAge,3)
	i OpArith="L" s ret=(PatAge>=Min)&(PatAge<Max)
	E  s runStr="s ret="_PatAge_OpArith_Min x runStr
	Q ret
}

///  Descript:  验证条件 药品禁忌
///  Output:    0 - 不匹配、1 - 匹配
///  w ##Class(web.DHCCKBMonitor).isMutEff(.TmpArr, .TmpMsgArr)
ClassMethod isMutEff(TmpArr, TmpMsgArr) As %String
{
	n (TmpArr, TmpMsgArr)
	s RulID=$g(TmpArr("RulID"))
	s ID=$g(TmpArr("ID"))
	s itmid=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),2)  /// 实体对象
	s RighID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)      /// 关系指针(右)
	
	s itemid="", Err=0
	F  s itemid=$o(TmpArr("itemOrder",itemid)) Q:(itemid="")||(Err'=0)  D
	.Q:itemid'=id
	.s Err=1
	.s RulType=..GetRuleTypeCode(RulID)      /// 类型代码
	.s PropKey=..GetRuleTypeDesc(RulID)      /// 类型描述
	.s mTipMessgae=$g(TmpArr("itemOrder",itmid,"PhDesc"))_"与"_$g(TmpArr("itemOrder",itemid,"PhDesc"))
	.s mTipMessgae=$s(RulType="Taboo":mTipMessgae_"存在配伍禁忌，不可同时使用",RulType="InterEach":mTipMessgae_"存在相互作用，不可同时使用",1:"")
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,1)
	Q Err
}

/// Descript:  检查过敏史
///  w ##Class(web.DHCCKBMonitor).isTakPatAgy("67","1",.TMPArr)
ClassMethod isTakPatAgy(InTmpArr, OutTmpArr) As %String
{
	n (InTmpArr, OutTmpArr)
	s RulID=$g(TmpArr("RulNo")) /// 规则组号
	s ID=$g(TmpArr("ID"))       /// 规则明细ID
	s itmid=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),2)  /// 实体对象
	s RighID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)      /// 关系指针(右)
	
	s Err=0
	i $LF($g(TmpArr("itemAyg")),$g(TmpArr("RulNo")))  D 
	.s Err=1
	.s PropKey=..GetRuleTypeDesc(RulID)      /// 类型描述
	.s mTipMessgae="过敏"
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",3)=mTipMessgae
	.s $p(TmpMsgArr("itemOrder",itmid,PropKey,RulID),"^",2)=..GetRulManLevel(RulID,1)
	Q Err
}

///  Descript:  输出
///  w ##Class(web.DHCCKBMonitor).PrintReview("67","1",.TMPArr)
ClassMethod PrintReview(RulID As %String, isFailFlag As %String, TmpMsgArr) As %String
{
	n (RulID, isFailFlag, TmpMsgArr)
	s itemID=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),2)          /// 实体对象
	s RuleType=..GetRuleTypeDesc(RulID)            /// 实体描述
	s OutType=$s(isFailFlag=0:"else",1:"then")     /// 输出类型
	k TmpTipArr
	s Type=""
	F  s Type=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type)) Q:Type=""  D
	.s ID=""
	.F  s ID=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type,ID)) Q:ID=""  D
	..s varVal="",varCode=""
	..s listData = $g(^CKB.PDSS.RuleActionD(ID))
	..s LkDicID=$lg(listData,5)
	..i LkDicID'="" s varCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LkDicID)),2)   /// 实体代码
	..s varText=$lg(listData,6)
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
///  w ##Class(web.DHCCKBMonitor).GetRulManLevel("138","1")
ClassMethod GetRulManLevelOld(RulID As %String, isFailFlag) As %String
{
	n (RulID, isFailFlag)
	s OutType=$s(isFailFlag=0:"else",1:"then")     /// 输出类型
	s Type="",ManLevel=""
	F  s Type=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type)) Q:Type=""  D
	.s ID=""
	.F  s ID=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type,ID)) Q:ID=""  D
	..s varVal="",varCode=""
	..s listData = $g(^CKB.PDSS.RuleActionD(ID))
	..s LkDicID= $lg(listData,5)
	..i LkDicID'="" s varCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LkDicID)),2)   /// 实体代码
	..s varText= $lg(listData,6)
	../// 管理级别
	..i varCode="LevelFlag" s ManLevel=varText
	.
	Q ManLevel
}

///  Descript:  取当前规则管控级别
///  w ##Class(web.DHCCKBMonitor).GetRulManLevel("138","1")
ClassMethod GetRulManLevel(RulID As %String, isFailFlag) As %String
{
	n (RulID, isFailFlag)
	s OutType=$s(isFailFlag=0:"else",1:"then")     /// 输出类型
	s Type="",ManLevel=""
	F  s Type=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type)) Q:Type=""  D
	.s ID=""
	.F  s ID=$o(^CKB.PDSS.RuleActionI("RuleActionType",RulID,OutType,Type,ID)) Q:ID=""  D
	..s varVal="",varCode=""
	..s listData = $g(^CKB.PDSS.RuleActionD(ID))
	..s LkDicID= $lg(listData,5) 
	..i LkDicID'="" s varCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LkDicID)),2)   /// 实体代码
	..s varText= $lg(listData,6)
	../// 管理级别
	..i varCode="LevelFlag" s ManLevel=varText
	.
	Q ManLevel
}

///  Descript:  知识库输出结构
///  w ##Class(web.DHCCKBMonitor).InvRes(.TmpMsgArr)
ClassMethod InvRes(TmpArr As %String, TmpMsgArr As %String) As %String
{
	n (TmpArr, TmpMsgArr)
	w "["
	w ##Class(web.DHCAPPJsonCommon).getJsonDataText("passFlag^manLevel",$g(TmpMsgArr("passFlag"))_"^"_$g(TmpMsgArr("manLevel")))
	w ",""items"":["
	s item="", itemNum=0
	F  s item=$o(TmpMsgArr("itemOrder",item)) Q:item=""  D
	.Q:$o(TmpMsgArr("itemOrder",item,""))=""
	.s itemNum=itemNum+1
	.s Prefix=$s(itemNum=1:"",1:",")
	.w Prefix_##Class(web.DHCAPPJsonCommon).getJsonDataText("unique^item^manLevel",$g(TmpMsgArr("itemOrder",item)))
	.w ",""tips"":["
	.s MaxDosQty=(+$g(TmpArr("itemOrder",item,"DosQty"))*$g(TmpArr("itemOrder",item,"Duration")))_$g(TmpArr("itemOrder",item,"DosUom"))
	.s ListData=$g(TmpArr("PatBDay"))_"^"_$g(TmpArr("Height"))_"^"_$g(TmpArr("Weight"))
	.s ListData=ListData_"^"_$g(TmpArr("itemOrder",item,"Instr"))_"^"_$g(TmpArr("itemOrder",item,"Freq"))_"^"_$g(TmpArr("itemOrder",item,"Duration"))
	.s ListData=ListData_"^"_$g(TmpArr("itemOrder",item,"DosQty"))_$g(TmpArr("itemOrder",item,"DosUom"))_"^"_MaxDosQty
	.w ##Class(web.DHCAPPJsonCommon).getJsonData("Birth^Height^Weight^Instr^Freq^Duration^DoseUom^MaxDosQty",ListData)
	.w "]"
	.w ",""warns"":["
	.s PropKey="", count=0
	.F  s PropKey=$o(TmpMsgArr("itemOrder",item,PropKey)) Q:PropKey=""  D
	..s ID=""
	..F  s ID=$o(TmpMsgArr("itemOrder",item,PropKey,ID)) Q:ID=""  D
	...s PropValue=$p(TmpMsgArr("itemOrder",item,PropKey,ID),"^",3)
	...Q:PropValue=""
	...s manLevel=$p(TmpMsgArr("itemOrder",item,PropKey,ID),"^",2)
	...s manLev=$s(manLevel="remind":"提醒",manLevel="forbid":"禁止",manLevel="warn":"警示",1:"正常")
	...s ListData=PropKey_"^"_PropValue_"^"_manLevel_"^"_manLev
	...s count = count+1
	...s Prefix=$s(count=1:"",1:",")
	...w Prefix_##Class(web.DHCAPPJsonCommon).getJsonData("itemkey^itemval^manLevel^manLev",ListData)
	.w "]}"
	w "]}]"
	Q ""
}

///  Descript:  提示信息
///  w ##Class(web.DHCCKBMonitor).InsErrMessage("", "", .TmpArr)
ClassMethod InsErrMessage(RulID As %String, Parref As %String, TmpArr, TmpMsgArr) As %String
{
	n (RulID, Parref, TmpArr, TmpMsgArr)
	k TmpTipsArr
	s itmid=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),2)    /// 实体对象
	s ID=""
	F  s ID=$o(^CT.CKB.PDSS.RuleDataI("RuleParref",RulID,Parref,ID)) Q:ID=""  D
	.s LeftID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4)        /// 关系指针(左)
	.Q:$D(TmpTipsArr(LeftID))
	.s TmpTipsArr(LeftID)=""
	.s LeftDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftID)),2)   /// 相关实体代码
	.s itmValId=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)      /// 关系指针(右)
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
ClassMethod TakErrorMessage(ListData As %String) As %String
{
	n (ListData)
	w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrorCode^ErrorMessage",ListData)  
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBMonitor","InsTmpGlobal",pid)
	k ^TMP("DHCCKB","web.DHCCKBMonitor","InsTmpErrMsg",pid)
	k ^TMP("Num",pid)
	Q ""
}

/// Descript:   插入智能决策系统监测主表
ClassMethod InsMonitor(TmpMonArr, TmpMonQueArr) As %String
{
	n (TmpMonArr, TmpMonQueArr)
	
	TS
	/// 监测主表
	s ID=..InsMonMaster(.TmpMonArr)
	i ID<0 tro
	q:ID<0 ID
	;B  //S1
	/// 药品明细表
	s Err = ..InsFeedBack(ID, .TmpMonArr, .TmpMonQueArr)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	/// 监测问题表
	s Err=..InsQueList(ID, .TmpMonQueArr)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	s TmpMonQueArr("MsgID")=ID
	i $g(TmpMonArr("OutParams"))'=""  d				// 增加MsgID
	.s TmpStr=$g(TmpMonArr("OutParams")) 
	.s TmpStr={}.%FromJSON(TmpStr)
	.d TmpStr.%Set("MsgID",$g(TmpMonQueArr("MsgID")))
	.d TmpStr.%Set("DrugUniqueStr",$g(TmpMonQueArr("DrugUniqueStr")))
	.s TmpMonArr("OutParams")=TmpStr.%ToJSON()
	
	TC
	Q Err
}

/// Descript:   插入智能决策系统监测主表
ClassMethod InsQueList(ID As %String, TmpMonQueArr) As %String
{
	n (ID, TmpMonQueArr)

	q:'$d(TmpMonQueArr("itemOrder")) 0
	/// 准备检测数据
	s itmID=""
	F  s itmID=$o(TmpMonQueArr("itemOrder",itmID)) Q:itmID=""  D
	.s Label=""
	.F  s Label=$o(TmpMonQueArr("itemOrder",itmID,Label)) Q:Label=""  D
	../// 监测规则
	..s RuleID=""
	..F  s RuleID=$o(TmpMonQueArr("itemOrder",itmID,Label,RuleID)) Q:RuleID=""  D
	...s mParams=$g(TmpMonQueArr("itemOrder",itmID,Label,RuleID))
	...s ManLev=$lg(mParams,3)            /// 管理级别
	...s ManLevID=..GetComDicId(ManLev)   /// 管理级别ID
	...s TmpMonQueArr("MonRule", itmID, RuleID)=ManLevID
	../// 监测函数
	..s count = 0
	..s index=""
	..F  s index=$o(TmpMonQueArr("itemOrderMsg",itmID,Label,index)) Q:index=""  D	
	...s msgCode=""
	...F  s msgCode=$o(TmpMonQueArr("itemOrderMsg",itmID,Label,index,msgCode)) Q:msgCode=""  D
	....s ProID=..GetComDicId(Label)        /// 产品目录ID
	....s FunID=..GetComDicId(msgCode)      /// 问题项目ID
	....Q:FunID=""
	....q:ProID=""
	....s ManLevID=..GetComDicId(ManLev)    /// 管理级别ID
	....s mParams=$g(TmpMonQueArr("itemOrderMsg",itmID,Label,index,msgCode))
	....s ManLev=$p(mParams,"^",1), TipsMsg=$p(mParams,"^",2)
	....s Oeori=""
	....s mParams=ManLevID_"^"_TipsMsg_"^"_Oeori
	....s count = count + 1 
	....s TmpMonQueArr("MonQue", itmID, ProID, FunID,count)=mParams  /// 监测问题
	..

	/// 监测规则表
	s itmID="", Err=0
	F  s itmID=$o(TmpMonQueArr("MonRule",itmID)) Q:(itmID="")||(Err'=0)  D
	.s RuleID=""
	.F  s RuleID=$o(TmpMonQueArr("MonRule",itmID, RuleID)) Q:(RuleID="")||(Err'=0)  D
	..q:RuleID=""
	..q:'$d(^CT.CKB.PDSS.RuleD(+RuleID))
	..q:$number(RuleID)=""
	..s mParams=$g(TmpMonQueArr("MonRule",itmID, RuleID))
	..s Err=..InsMonRuleList(ID, RuleID, mParams)
	..Q:Err'=0
	.
	
	/// 监测问题表
	s itmID="", Err=0
	F  s itmID=$o(TmpMonQueArr("MonQue",itmID)) Q:(itmID="")||(Err'=0)  D
	.s ProID=""
	.F  s ProID=$o(TmpMonQueArr("MonQue",itmID,ProID)) Q:(ProID="")||(Err'=0)  D
	..q:ProID=""
	..s FunID=""
	..F  s FunID=$o(TmpMonQueArr("MonQue",itmID,ProID,FunID)) Q:(FunID="")||(Err'=0)  D
	...s index = ""
	...f   s index = $o(TmpMonQueArr("MonQue",itmID,ProID,FunID,index))  q:(index="")||(Err'=0)  d
	....s mParams=$g(TmpMonQueArr("MonQue",itmID,ProID,FunID,index))
	....s Err=..InsMonQueList(ID, itmID, ProID, FunID, mParams)
	....Q:Err'=0
	..

	Q Err
}

/// Descript:   插入智能决策系统监测主表
ClassMethod InsMonMaster(TmpMonArr) As %String
{
	n (TmpMonArr)
	s AdmNo=$g(TmpMonArr("EpisodeID"))      /// 就诊标识
	s CreateUser=$g(TmpMonArr("CarePrvID"))      /// 创建人
	s LocDesc=$g(TmpMonArr("DocLocID"))          /// 科室
	s PassFlag=$g(TmpMonArr("passFlag"))    /// 审查结果
	s ManLevID=$g(TmpMonArr("manLevel"))    /// 管理级别
	s ExaParam=$g(TmpMonArr("InParams"))    /// 审查内容
	s ExaRes=$g(TmpMonArr("OutParams"))     /// 审查结果
	s ClientIP=$g(TmpMonArr("ClientIP"))   /// 客户端IP
	s UserInfo = $g(TmpMonArr("UserInfo"))   /// 用户信息
	s HospDesc = $p(UserInfo,"^",5)   /// 用户信息
	s CreateDate=+$H   		       /// 创建日期
	s CreateTime=$p($H,",",2)      /// 创建时间
	s Source = $g(TmpMonArr("Source"))	// 规则来源 2021/5/26
	s UseType = $g(TmpMonArr("UseType"))      /// 调用标识
	s ArrsObj = $g(TmpMonArr("InParams"))	
	s ArrsObj = ##class(DHCNewPro.COM.Object).FromJSON(ArrsObj)
	s LastId = 	ArrsObj.MsgID
	&SQL(Insert into CKB_PDSS.MonMaster(CM_Adm_Dr, CM_CreateDate, CM_CreateTime, CM_CreateUser, CM_PassFlag, CM_ManLev_Dr, CM_ExaParam, CM_ExaRes, CM_LocDesc, CM_Ip, CM_Hosp, CM_Source,CM_UserType,CM_LastId)
		Values(:AdmNo, :CreateDate, :CreateTime, :CreateUser, :PassFlag, :ManLevID, :ExaParam, :ExaRes, :LocDesc,:ClientIP,:HospDesc,:Source,:UseType,:LastId))
	Q +%ROWID
}

/// Descript:   插入智能决策系统监测问题表
ClassMethod InsMonQueList(Parrf As %String, ItemID As %String, ProID As %String, FunID As %String, mParams As %String) As %String
{
	n (Parrf, ItemID, ProID, FunID, mParams)
	s ManLevID=$p(mParams,"^",1)    /// 管理级别
	s TipsMsg=$p(mParams,"^",2)     /// 提示内容
	s OrderID=$p(mParams,"^",3)     /// 医嘱标识
	&SQL(Insert into CKB_PDSS.MonQueList(CM_Parrf_Dr, CM_Item_Dr, CM_Pro_Dr, CM_Fun_Dr, CM_TipsMsg, CM_ManLev_Dr, CM_Order_Dr)
		Values(:Parrf, :ItemID, :ProID, :FunID, :TipsMsg, :ManLevID, :OrderID))
	Q SQLCODE
}

/// Descript:   插入智能决策系统监测规则表
ClassMethod InsMonRuleList(Parrf As %String, RuleID As %String, mParams As %String) As %String
{
	n (Parrf, RuleID, mParams)
	s ManLevID=$p(mParams,"^",1)      /// 管理级别
	s ItemID="" //$lg(mParams,4)      /// 行标识
	&SQL(Insert into CKB_PDSS.MonRuleList(CM_Parrf_Dr, CM_Rule_Dr, CM_ManLev_Dr, CM_Item_Dr)
		Values(:Parrf, :RuleID, :ManLevID, :ItemID))
	Q SQLCODE
}

/// Descript:   更新监测问题表His医嘱标识
ClassMethod UpdMonQueOrder(ID As %String, OrderID As %String) As %String
{
	n (ID, OrderID)
	&SQL(Update CKB_PDSS.MonQueList Set CM_Order_Dr=:OrderID Where CM_RowID=:ID)
	Q SQLCODE
}

/// Descript:   插入智能决策系统监测函数表
ClassMethod InsMonFunList(Parrf As %String, FunID As %String) As %String
{
	n (Parrf, FunID)
#;	s FunID="", Err=0
#;	F  s FunID=$o(TmpMonArr("RULE",RuleID,FunID)) Q:(FunID="")||(Err'=0)  D
#;	.&SQL(Insert into CKB_PDSS.MonFunList(CM_Parrf_Dr, CM_Fun_Dr)
#;		Values(:Parrf, :FunID))
#;	.s Err=SQLCODE
#;	.
    &SQL(Insert into CKB_PDSS.MonFunList(CM_Parrf_Dr, CM_Fun_Dr) Values(:Parrf, :FunID))
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-06-20
/// Descript:       获取知识库监测结果
/// w ##Class(web.DHCCKBMonitor).GetCkbExaRes()
ClassMethod GetCkbExaRes(ID As %String) As %String
{
	n (ID)

	s str = $lg(^CKB.PDSS.MonMasterD(ID),10)
	//s strObj = ##class(DHCNewPro.COM.Object).FromJSON(str)
	s strObj = {}.%FromJSON(str)
	s strObj.MsgID = ID
	
	w strObj.%ToJSON()
	
	Q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-21
/// Descript:       保存审查的药品明细
/// w ##Class(web.DHCCKBMonitor).InsFeedBack()
ClassMethod InsFeedBack(msgID As %String, TmpMonArr, TmpMonQueArr) As %String
{
	n (msgID, TmpMonArr, TmpMonQueArr)
	s err = 0 
	q:msgID="" err
	s arrsObj = $g(TmpMonArr("InParams"))
	s arrsObj = ##class(DHCNewPro.COM.Object).FromJSON(arrsObj)
	q:arrsObj="" err
	
	s drugUniqueStr = ""
	s drug=arrsObj.Get("Drug")	
	f i=1:1:drug.Size()  q:err'=0  d
	.s obj=drug.Get(i-1)
	.q:obj.Size()=0
	.s value=obj.item
	.q:value=""
	.s arciId = obj.ArciMastId
	.s seqNo = obj.SeqNo
	.s:arciId="" arciId=seqNo
	.s unique = arciId_"_"_seqNo
	.s libvalue = $g(TmpMonArr("HisDrug",unique))
	.s hisDrugStr = $lb(arciId,value,seqNo,unique)
	.i libvalue="" s drugPassFlag=""
	.e  s drugPassFlag = $case('$d(TmpMonQueArr("itemOrder",libvalue)),1:"Y",:"N")	// 通过审查标志
	.s drugParams = obj.ToJSON()
	.s ret = ..InsFeedBackDetail(.TmpMonArr, .TmpMonQueArr, msgID, libvalue, hisDrugStr, drugParams)
	.i ret<=0 s err = -1
	.q:err'=0
	.i drugUniqueStr="" s drugUniqueStr = ret_"^"_arciId_"^"_seqNo_"^"_drugPassFlag
	.e  s drugUniqueStr = drugUniqueStr _"!!"_ret_"^"_arciId_"^"_seqNo_"^"_drugPassFlag

	s TmpMonQueArr("DrugUniqueStr") = drugUniqueStr
	q err
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-21
/// Descript:       保存审查的药品明细
/// w ##Class(web.DHCCKBMonitor).InsFeedBackDetail()
ClassMethod InsFeedBackDetail(TmpMonArr, TmpMonQueArr, msgID As %String, libvalue As %String, hisDrugStr As %String, drugParams As %String) As %String
{
	n (TmpMonArr, TmpMonQueArr, msgID, libvalue, hisDrugStr, drugParams)	
	
	s arrsObj = $g(TmpMonArr("InParams"))
	s arrsObj = ##class(DHCNewPro.COM.Object).FromJSON(arrsObj)
	s user = $g(TmpMonArr("CarePrvID")) //arrsObj.Get("LgUser")		// 登录医生(描述)
	i user="" s user = arrsObj.Get("LgUser")
	s userName = $g(TmpMonArr("CarePrvID"))
	i userName="" s userName=arrsObj.Get("LgUser")
	s user = $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(+user),""))
	i (+user=0)&&(userName'="") s user =$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(userName),""))
	
		
	s date = +$h
	s time = $p($h,",",2)
	s useType = arrsObj.Get("UseType")	// Doc(医生)/Pha(药师)/Nur(护士)
	i libvalue="" s drugLevel=""
	e  s drugLevel = $g(TmpMonQueArr("itemOrder",libvalue))	// 药品级别 
	s arciId = $listget(hisDrugStr,1)	// 医嘱项
	s arciName = $listget(hisDrugStr,2)	// 
	s seqNo = $listget(hisDrugStr,3)	// 医嘱序号
	s unique = $listget(hisDrugStr,4)	// 药品唯一标识
	i libvalue="" s passFlag = "Y"
	e  s passFlag = $case('$d(TmpMonQueArr("itemOrder",libvalue)),1:"Y",:"N")	// 通过审查标志
	s status = $case(passFlag="Y",1:"P",:"")
	s params = drugParams	// 入参的药品信息串
	s lastId = ""	// 上一次药品记录的id(流转用-展示药品的变化) 
	i msgID'= "" s lastId = ..GetDrugLastId(msgID, useType, hisDrugStr)

	&sql(insert into CKB_PDSS.FeedBack (FB_MsgID, FB_User,FB_Date,FB_Time,FB_Status,FB_UserType,FB_Level,FB_Unique,FB_ArciId,FB_ArciName,FB_SeqNo,FB_PassFlag,FB_Params,FB_LastId) values
		(:msgID,:user,:date,:time,:status,:useType,:drugLevel,:unique,:arciId,:arciName,:seqNo,:passFlag,:params,:lastId))
	s ret = %ROWID

	q ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-21
/// Descript:       通过日志id,药品信息获取药品的流转id
/// Input:			日志id, 调用类型, 药品串
/// w ##Class(web.DHCCKBMonitor).GetDrugLastId()
ClassMethod GetDrugLastId(msgID, useType, hisDrugStr) As %String
{
	n (msgID, useType, hisDrugStr)	
	s lastMsgID = $lg(^CKB.PDSS.MonMasterD(+msgID),18) 
	q:lastMsgID="" ""
	
	s drugLastId = ""
	s fbRowID = ""
	f  s fbRowID = $o(^CKB.PDSS.FeedBackI("MsgIDType",lastMsgID,useType,fbRowID)) q:(fbRowID="")||(drugLastId'="")  d
	.s feedData = $g(^CKB.PDSS.FeedBackD(fbRowID))
	.s unique = $lg(feedData,12)
	.s oldUnique = $listget(hisDrugStr,4)	
	.q:unique'=oldUnique
	.s drugLastId = fbRowID
	
	q drugLastId
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-21
/// Descript:       通过日志id修改日志是否生成处方标志
/// Input:			日志id, 调用类型, 药品串
/// w ##Class(web.DHCCKBMonitor).UpdateMonMaster()
ClassMethod UpdateMonMaster(msgID, passType, prescFlag) As %String
{
	n (msgID, passType, prescFlag)	
	
	&SQL(Update CKB_PDSS.MonMaster set CM_PassType=:passType,CM_PrescFlag=:prescFlag Where CM_RowID=:msgID)
	
	q SQLCODE
}

}

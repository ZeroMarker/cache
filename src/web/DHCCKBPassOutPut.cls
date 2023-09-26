Import SQLUser

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		安全用药智能决策系统输出信息
Class web.DHCCKBPassOutPut Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		审查规则的输出消息处理
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).InvOutResForCheck()
ClassMethod InvOutResForCheck(TmpArr As %String, TmpMsgArr As %String)
{
	n (TmpArr, TmpMsgArr)
	
	/* 审查通过的提醒消息 */
	i '$d(TmpMsgArr("itemOrder")) d
	.d ##Class(web.DHCCKBPassOutPut).CheckPassMsg(.TmpArr, .TmpMsgArr)
	q:'$d(TmpMsgArr("itemOrder")) ""
	
	/* 审查不通过的提示消息 */
	s OutPutObj = ##class(DHCNewPro.COM.Object).%New()	
	k TMPOutPut
	s WarnMsgArr = ..GetOutPutWarnMsg(.TmpOutPut, .TmpArr, .TmpMsgArr)	// 提示消息
	d OutPutObj.Set("passFlag",0)	// 是否通过
	s OutPutLevelNum = $o(TmpOutPut("Level",""),-1)
	s TmpOutPut("manLevel") = ##class(web.DHCCKBCommon).GetManLevelCodeByNum(OutPutLevelNum)
	s TmpOutPut("manLev") = ##class(web.DHCCKBCommon).GetDicDescByCode($g(TmpOutPut("manLevel")))
	d OutPutObj.Set("manLevel",$g(TmpOutPut("manLevel")))	// 审查级别代码
	d OutPutObj.Set("manLev",$g(TmpOutPut("manLev")))		// 审查级别描述
	d OutPutObj.Set("items",WarnMsgArr)		// 提示信息
	d OutPutObj.Set("UseType",$g(TmpArr("UseType")))	//使用场景
	d OutPutObj.Set("patInfo",..GetPatInfo(.TmpArr))	//患者信息
	
	s TmpArr("OutParams")=OutPutObj.ToJSON()
	
	s TmpArr("passFlag")=0
	s TmpArr("manLevel")=$g(TmpOutPut("manLevel"))
	s TmpArr("manLev")=$g(TmpOutPut("manLev"))
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		审查通过的消息信息
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).CheckPassMsg()
ClassMethod CheckPassMsg(TmpArr As %String, TmpMsgArr As %String)
{
	n (TmpArr, TmpMsgArr)
	q:$d(TmpMsgArr("itemOrder")) ""
	
	s MsgObj = ##class(DHCNewPro.COM.Object).%New()
	s MsgArr = ##class(DHCNewPro.COM.Array).%New()
	d MsgObj.Set("passFlag","1")		// 通过标志
	d MsgObj.Set("manLevel","enable")	// 级别代码
	d MsgObj.Set("manLev","正常")		// 级别描述
	d MsgObj.Set("items",MsgArr)		// 整体返回信息	
	
	s TmpArr("OutParams")=MsgObj.ToJSON()
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		审查的提示信息
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetOutPutWarnMsg()
ClassMethod GetOutPutWarnMsg(TmpOutPut, TmpArr As %String, TmpMsgArr As %String)
{
	n (TmpOutPut, TmpArr, TmpMsgArr)
	s WarnMsgArr = ##class(DHCNewPro.COM.Array).%New()

	s Item=""
	f  s Item=$o(TmpMsgArr("itemOrder",Item))  q:Item=""  d
	.s DrugObj = ..GetDrugWarnMsg(.TmpArr, .TmpMsgArr, Item)
	.s DrugLevel = DrugObj.Get("manLevel")	
	.s DrugLevelNum = ##class(web.DHCCKBCommon).GetManLevelNum(DrugLevel)
	.s TmpOutPut("Level",DrugLevelNum) = ""
	.d WarnMsgArr.Push(DrugObj)
	
	q WarnMsgArr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		审查的药品提示信息
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetDrugWarnMsg()
ClassMethod GetDrugWarnMsg(TmpArr As %String, TmpMsgArr As %String, Item As %String) As %String
{
	n (TmpArr, TmpMsgArr, Item)
	
	s drugObj = ##class(DHCNewPro.COM.Object).%New()
	
	s ItemID=$p(Item,$c(2),1)
	s ItemName=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItemID)),3)
	s HisItemName=$listtostring($g(TmpArr("Drug",Item)))
	s:HisItemName="" HisItemName=ItemName
	
	k TmpDrugOut
	d drugObj.Set("item",HisItemName)	// his药品描述
	d drugObj.Set("libitem",ItemName)	// 知识库药品描述
	d drugObj.Set("itmID",ItemID)		// 药品id
	s seqNo = TmpArr("SeqNo"_$c(1)_Item)
	s arciMastId = TmpArr("ArciMastId"_$c(1)_Item)
	i $listvalid(seqNo)=1 s seqNo = $lts(seqNo)
	s seqNo = $replace(seqNo,";","_")	// 前端把unique作为id,不能有;存在
	i $listvalid(arciMastId)=1 s arciMastId = $lts(arciMastId)	
	s arciMastId = $replace(arciMastId,";","_")	
	//d drugObj.Set("unique",$listtostring(TmpArr("ArciMastId"_$c(1)_Item))_"_"_$listtostring(TmpArr("SeqNo"_$c(1)_Item)))		// 医嘱项id_序号
	//d drugObj.Set("seqno",$listtostring(TmpArr("SeqNo"_$c(1)_Item)))		// 医嘱序号
	d drugObj.Set("unique",arciMastId_"_"_seqNo)		// 医嘱项id_序号
	d drugObj.Set("seqno",seqNo)		// 医嘱序号
	//d drugObj.Set("unique",ItemID_"_"_$listtostring(TmpArr("SeqNo"_$c(1)_Item)))		// 唯一标识
	s adviceDrug = $g(TmpMsgArr("adviceDrug",Item))	
	s:adviceDrug'="" adviceDrug = adviceDrug.%ToJSON()		//sufan 2022-05-07
	//s:adviceDrug'="" adviceDrug = $tr(adviceDrug,"""","“")
	s:adviceDrug'="" adviceDrug = $tr(adviceDrug,"""","")
	d drugObj.Set("adviceDrug",""_adviceDrug) 	// 推荐药品列表
	s libwaryWarn = ..GetLibaryWarnMsg(.TmpDrugOut, .TmpArr, .TmpMsgArr, Item)
	
	d drugObj.Set("warns",libwaryWarn)		// 药品的提示信息
	s DrugLevelNum = $o(TmpDrugOut("Level",""),-1)
	s DrugLevCode = ##class(web.DHCCKBCommon).GetManLevelCodeByNum(DrugLevelNum)	
	s DrugLev = ##class(web.DHCCKBCommon).GetDicDescByCode(DrugLevCode)
	d drugObj.Set("manLevel",DrugLevCode)		// 药品的级别代码 从TmpDrugOut中取值的需要先执行GetRuleWarnMsg才能有值
	d drugObj.Set("manLev",DrugLev)				// 药品的级别描述
	d drugObj.Set("overview",##Class(web.DHCCKBPassExt).DealOverView($g(TmpDrugOut("libaryList"))))	// 药品的概览信息 2021/5/25
	d drugObj.Set("tips",..GetDrugTips(.TmpArr, .TmpMsgArr, Item))		 	// 详细信息
	s TmpMsgArr("itemOrder",Item) = DrugLevCode	// 记录药品的级别
	q drugObj
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		审查的目录的提示信息
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetLibaryWarnMsg()
ClassMethod GetLibaryWarnMsg(TmpDrugOut, TmpArr As %String, TmpMsgArr As %String, Item As %String)
{
	n (TmpDrugOut, TmpArr, TmpMsgArr, Item)
	
	//xww 2021-12-16 适应症为禁止，则后面的非禁止规则不显示
	/*i $d(TmpMsgArr("itemOrder",Item,"适应症")) d
	.s RuleID = ""
	.f  s RuleID = $o(TmpMsgArr("itemOrder",Item,"适应症",RuleID))	 q:RuleID=""  d
	..s RuleInfo = $g(TmpMsgArr("itemOrder",Item,"适应症",RuleID))
	..s RuleLevel = $listget(RuleInfo,3)
	..q:RuleLevel'="forbid"
	..s Label = ""
	..f  s Label = $o(TmpMsgArr("itemOrder",Item,Label))  q:Label=""  d
	...s RuleIDNew = ""
	...s RuleIDNew = $o(TmpMsgArr("itemOrder",Item,Label,RuleIDNew))	 q:RuleIDNew=""  d
	....s RuleInfoNew = $g(TmpMsgArr("itemOrder",Item,Label,RuleIDNew))
	....s RuleLevelNew = $listget(RuleInfoNew,3)
	....q:RuleLevelNew="forbid"
	....k TmpMsgArr("itemOrder",Item,Label,RuleIDNew)
	*/
	/* 消息的整理 */
	s LabelList = ""
	s Label = ""
	f  s Label = $o(TmpMsgArr("itemOrder",Item,Label))  q:Label=""  d
	.d ..MergeLibaryMsg(.TmpArr, .TmpMsgArr, Item, Label)	// 消息整理
	.s LabelInfo = $g(TmpMsgArr("itemOrder",Item,Label))	
	.s LabelLevelNum = $listget(LabelInfo,1)
	.s TmpMsgArr("itemOrderManLevel",Item,LabelLevelNum_"^"_Label)=""	// 消息排序
	
	s LabelArr = ##class(DHCNewPro.COM.Array).%New()
	s MLabel = ""
	f  s MLabel = $o(TmpMsgArr("itemOrderManLevel",Item,MLabel),-1)  q:MLabel=""  d
	.s LabelLevelNum = $p(MLabel,"^",1)
	.s Label = $p(MLabel,"^",2)
	.s LabelConfigLevelNum = ##Class(web.DHCCKBPassExt).GetLibaryManLevel(Label)	// 目录设置的级别
	.s LabelNum = $case(LabelLevelNum<=LabelConfigLevelNum,1:LabelConfigLevelNum,:LabelLevelNum)	// 设置的目录级别和由规则提取的级别 取大值
	.s LabelLevel = ##class(web.DHCCKBCommon).GetManLevelCodeByNum(LabelNum)	
	.s LabelLevelName = ##class(web.DHCCKBCommon).GetDicDescByCode(LabelLevel)
	.s TmpDrugOut("Level", LabelNum) = ""	// 药品记录最高级别
	.s LabelObj = ##class(DHCNewPro.COM.Object).%New() 
	.s LibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	.s LabelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(Label)	// 还有全局规则中的描述
	.s ShowLabel = ##class(web.DHCCKBCommon).GetShowName(LabelID)	
	.d LabelObj.Set("key",ShowLabel)		// 目录代码
	.//d LabelObj.Set("keyname",ShowLabel_"(院内规则)")	// 目录描述
	.d LabelObj.Set("keyname",ShowLabel)	// 目录描述
	.d LabelObj.Set("val","")	
	.d LabelObj.Set("manLevel",LabelLevel)		// 目录级别代码
	.d LabelObj.Set("manLev",LabelLevelName)	// 目录级别描述
	.s RuleWarnMsg = ..GetRuleWarnMsg(.TmpArr, .TmpMsgArr, Item, Label)
	.d LabelObj.Set("itms",RuleWarnMsg)	// 规则提醒内容加入到目录中	
	.d LabelArr.Push(LabelObj)
	.i $listfind(LabelList,Label)=0 s $list(LabelList,*+1) = Label
	.s TmpDrugOut("libaryList") = LabelList
	
	q LabelArr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		审查的规则的提示信息
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetRuleWarnMsg()
ClassMethod GetRuleWarnMsg(TmpArr As %String, TmpMsgArr As %String, Item As %String, Label As %String) As %String
{
	n (TmpArr, TmpMsgArr, Item, Label)
	
	k TmpMarkMsgArr
	s TmpLevelManArr = ""
	/*  规则按照级别排序 */
	s RuleID = ""
	f  s RuleID = $o(TmpMsgArr("itemOrder",Item, Label, RuleID))	q:RuleID=""  d
	.s RuleInfo = $g(TmpMsgArr("itemOrder",Item, Label, RuleID))
	.s RuleLevel = $lg(RuleInfo,3)
	.s RuleLevelNum = ##class(web.DHCCKBCommon).GetManLevelNum(RuleLevel)
	.s TmpLevelManArr("itemOrderRuleManLevel",Item,Label,RuleLevelNum_"^"_RuleID)=""	// 消息排序

	s RuleArr = ##class(DHCNewPro.COM.Array).%New()	
	s TmpRuleID = ""
	f  s TmpRuleID = $o(TmpLevelManArr("itemOrderRuleManLevel",Item,Label,TmpRuleID),-1)	q:TmpRuleID=""  d
	.s RuleID = $p(TmpRuleID,"^",2)
	.s RuleObj = ##class(DHCNewPro.COM.Object).%New()
	.s RuleInfo = $g(TmpMsgArr("itemOrder",Item, Label, RuleID))
	.//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	.s RuleLevel = $listget(RuleInfo,3)
	.s RuleLevelName = ##class(web.DHCCKBCommon).GetDicDescByCode(RuleLevel)	// 规则级别	
	.s RuleControl = $listget(RuleInfo,5)
	.s RuleSource = $listget(RuleInfo,6)
	.s:RuleSource="系统生成" RuleSource=""
	.d RuleObj.Set("manLevel",RuleLevel)
	.d RuleObj.Set("manLev",RuleLevelName)
	.d RuleObj.Set("control",RuleControl)
	.d RuleObj.Set("source",RuleSource)
	.d RuleObj.Set("ruleID",RuleID)
	.d RuleObj.Set("outMsgFlag","")	// 记录标记
	.s OutFlag = ##Class(web.DHCCKBBusConfig).GetLibaryOutMsgFlag(Label)	
	.//s RuleWarnArr = ..GetCalcItmWarnMsg(.TmpArr, .TmpMsgArr, Item, Label, RuleID)
	.s RuleWarnArr = ..GetCalcItmWarnMsgNew(.TmpArr, .TmpMsgArr, Item, Label, RuleID)
	.i OutFlag = "itm" d
	..d RuleObj.Set("itms",RuleWarnArr)	// 此处需要区分,按照项目提醒还是
	.e  d
	..d RuleObj.Set("itms",RuleWarnArr)
	.s Repleatmsg = RuleLevel_$case(RuleWarnArr.Get(0)="",1:"",:RuleWarnArr.Get(0).val)
	.s Repleatmsg=$e(Repleatmsg,1,125)	// 防止超长,截取前125个字符
	.q:$d(TmpMarkMsgArr(Label,Repleatmsg))	// 同一个目录有多条规则提示,若提示内容相同(内容+级别),则只提示一次即可	2022-03-24
	.s TmpMarkMsgArr(Label,Repleatmsg)=""
	.d RuleObj.Set("markItms",RuleWarnArr)
	.d RuleArr.Push(RuleObj)
	.s RuleLevelNum = ##class(web.DHCCKBCommon).GetManLevelNum(RuleLevel)
	
	q RuleArr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		审查的计算项目的提示信息
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetCalcItmWarnMsg()
ClassMethod GetCalcItmWarnMsg(TmpArr As %String, TmpMsgArr As %String, Item As %String, Label As %String, RuleID As %String) As %String
{
	n (TmpArr, TmpMsgArr, Item, Label, RuleID)
	
	s RepeatMsg = ""

	s CalcItmArr = ##class(DHCNewPro.COM.Array).%New()
	s ID = ""
	f  s ID = $o(TmpMsgArr("itemOrder",Item,Label,RuleID,ID)) q:ID=""  d	
	.s CalcItmObj = ##class(DHCNewPro.COM.Object).%New()
	.s TmpKey = $g(TmpMsgArr("itemOrder",Item,Label,RuleID,ID))
	.s Key = $p(TmpKey,"@@",1)	// 计算项目
	.s Itm = $p(TmpKey,"@@",2)	// 程序拼接的提醒消息(相互作用的药品)
	.s LinkCont = $p(TmpKey,"@@",3)	// 相互作用药品的原因(具体成分、分类)
	.s Limit=""
	.i Itm="" d
	..i $d(^CT.CKB.PDSS.RuleDataD(ID)) s Limit=##class(web.DHCCKBCommon).GetRuleLimitContent(ID)	// 规则限定内容
	.e  d
	..s Limit=$case($listvalid(Itm),1:$listtostring(Itm),:Itm)
	.q:Limit=""
	.s KeyVal=$case(Key[$c(1),1:$p(Key,$c(1),1),:Key)	// 计算项目代码
	.s KeyName=##class(web.DHCCKBCommon).GetDicDescByCode(KeyVal)
	.s:KeyName="" KeyName=KeyVal 
	.q:KeyName=""
	.	
	.d CalcItmObj.Set("key",KeyVal)
	.d CalcItmObj.Set("keyname",KeyName)			// 审查项目
	.s ItmMsg =  ##class(web.DHCCKBPassOutPut).GetLabelMsg(Label,KeyVal) // 提醒内容(从项目优先级维护处获取) 
	.d CalcItmObj.Set("msg",ItmMsg)
	.s OrderCont=$listtostring($g(TmpArr(Key,"Ext")))			// 处方内容
	.s OrderCont=$case($listvalid(OrderCont)>0,1:$listtostring(OrderCont),:OrderCont)
	.d CalcItmObj.Set("order",OrderCont)
	.d CalcItmObj.Set("limit",Limit)
	.s ItemID=$p(Item,$c(2),1)
	.s ItemName=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItemID)),3)
	.s HisItemName=$listtostring($g(TmpArr("Drug",Item)))
	.s:HisItemName="" HisItemName=ItemName	
	.s RuleInfo = $g(TmpMsgArr("itemOrder",Item, Label, RuleID))
	.i KeyVal["Disease"&&(Label["禁忌") d
	..s MatchDisease=$g(TmpArr("MatchDisease",Item,RuleID)) 
	..i $listValid(MatchDisease)=1 s MatchDisease=$listtostring(MatchDisease) 
	..s:MatchDisease'="" OrderCont=MatchDisease //xww 2021-10-28
	.//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	.s OutPutMsg = ..OutPutMsg(.TmpArr, ItemID, KeyVal, HisItemName, ItemName, Label, ItmMsg, Limit, OrderCont, $listget(RuleInfo,5), $listget(RuleInfo,4), LinkCont)
	.d CalcItmObj.Set("val",OutPutMsg)
	.s TmpOutPutMsg = OutPutMsg
	.i $length(TmpOutPutMsg)>125 s TmpOutPutMsg=$e(TmpOutPutMsg,1,125) // 长度过长，不能作为节点
	./* 按照项目提示,判断提示内容是否相同,防止出现多条规则提示内容相同的情况*/ // 现在的按照规则提醒的模式：项目内容+规则提示内容
	./* 当前分支是联合节点的情况下,不进行当前节点下项目的输出。如：检验指标和检验值 */
	.s unionFlag = ..GetRuleDataNodeType(ID)
	.//i ($d(RepeatMsg))&&($d(RepeatMsg(TmpOutPutMsg))||(unionFlag="union")) d
	.i ($d(RepeatMsg))&&(TmpOutPutMsg'="")&&($d(RepeatMsg(TmpOutPutMsg))||((unionFlag="union")&&(Label'["液体配置"))) d
	..k CalcItmObj
	.e  d
	..d CalcItmArr.Push(CalcItmObj)
	.q:TmpOutPutMsg=""
	.s RepeatMsg(TmpOutPutMsg) = ""
	./* 记录每个问题项的提示内容 2020-03-10 bianshuai */
	.s LabelInfo = $g(TmpMsgArr("itemOrder",Item,Label))
	.s LabelNum =  $listget(LabelInfo,1)	
	.s LabelLevel = ##class(web.DHCCKBCommon).GetManLevelCodeByNum(LabelNum)	
	.s LabelLevelName = ##class(web.DHCCKBCommon).GetDicDescByCode(LabelLevel)	
	.s TmpMsgArr("itemOrderMsg",Item,Label,RuleID,Key)=LabelLevelName_"^"_OutPutMsg

	q CalcItmArr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-29
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
/// CreateDate: 	2021-05-28
/// Descript: 		审查的药品的详情
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetDrugTips()
ClassMethod GetDrugTips(TmpArr As %String, TmpMsgArr As %String, Item As %String) As %String
{
	n (TmpArr, TmpMsgArr, Item)
	s TipsArr = ##class(DHCNewPro.COM.Array).%New()
	s TipsObj = ##class(DHCNewPro.COM.Object).%New() // 药品详情内容
	
	d TipsObj.Set("AgeProp",$listtostring($g(TmpArr("AgeProp","Ext"))))
	d TipsObj.Set("Height",$listtostring($g(TmpArr("Height","Ext"))))
	d TipsObj.Set("Weight",$listtostring($g(TmpArr("Weight","Ext")))) 
	d TipsObj.Set("OnceDose",$listtostring(TmpArr("OnceDose"_$c(1)_Item,"Ext")))
	d TipsObj.Set("DayDose",$listtostring(TmpArr("OnceDose"_$c(1)_Item,"Ext")))
	d TipsObj.Set("DrugFreq",$listtostring(TmpArr("DrugFreq"_$c(1)_Item,"Ext"))) 	//单次剂量
	d TipsObj.Set("DrugPreMet",$listtostring(TmpArr("DrugPreMet"_$c(1)_Item,"Ext")))
	d TipsObj.Set("Treatment",$listtostring(TmpArr("Treatment"_$c(1)_Item,"Ext")))
	
	d TipsArr.Push(TipsObj)
	
	q TipsArr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		消息的整理
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).MergeLibaryMsg()
ClassMethod MergeLibaryMsg(TmpArr As %String, TmpMsgArr As %String, Item As %String, Label As %String) As %String
{
	n (TmpArr, TmpMsgArr, Item, Label)
	/* 取目录配置(该目录是按照最长路径提示，还是多条规则提示) */
	s Mode = ##Class(web.DHCCKBBusConfig).GetLibaryDisplayMode(Label) 
	
	//i Mode = "single"  d	// 最长路径
	d ..MergeRuleLongestPath(.TmpArr, .TmpMsgArr, Item, Label)
		
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28
/// Descript: 		按照规则的最长路径整理提示消息
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).MergeRuleLongestPath()
ClassMethod MergeRuleLongestPath(TmpArr As %String, TmpMsgArr As %String, Item As %String, Label As %String) As %String
{
	n (TmpArr, TmpMsgArr, Item, Label)
		
	s MaxLen = 0
	s GlobalList = "", MaxList = ""
	s RuleID = ""
	f  s RuleID = $o(TmpMsgArr("itemOrder",Item,Label,RuleID))	 q:RuleID=""  d
	.s RulePreCondtions = $g(TmpMsgArr("PreCondtions",RuleID))
	.i $listGet(RulePreCondtions)="NULL" s $list(GlobalList,*+1) = RuleID
	.q:$listGet(RulePreCondtions)="NULL"
	.s PreLength = $listlength(RulePreCondtions)	// 记录全局规则和最长路径规则,其他的规则给删除
	.i (PreLength'=0)&(PreLength>=MaxLen) d 
	..s MaxLen = PreLength
	..s $list(MaxList,*+1) = RuleID 
	
	k LabelLevelArr
	s RuleID = ""
	f  s RuleID = $o(TmpMsgArr("itemOrder",Item,Label,RuleID))	 q:RuleID=""  d
	.s RuleInfo = $g(TmpMsgArr("itemOrder",Item,Label,RuleID))
	.i ($listfind(GlobalList,RuleID)'=0)||($listfind(MaxList,RuleID)'=0) d
	..s RuleLevel = $listget(RuleInfo,3)
	..s RuleLevelNum = ##class(web.DHCCKBCommon).GetManLevelNum(RuleLevel)
	..s LabelLevelArr(RuleLevelNum) = Label
	.q:$listfind(GlobalList,RuleID)'=0
	.q:$listfind(MaxList,RuleID)'=0
	.k TmpMsgArr("itemOrder",Item,Label,RuleID)
	.q:'$d(TmpMsgArr("itemOrder",Item,Label,RuleID))
	.//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")	
	.s RuleLevel = $listget(RuleInfo,3)
	.s RuleLevelNum = ##class(web.DHCCKBCommon).GetManLevelNum(RuleLevel)
	.s LabelLevelArr(RuleLevelNum) = Label
	
	s LabelMsg = ##class(web.DHCCKBPassOutPut).GetLabelMsg(Label)
	s LabelLevel = $o(LabelLevelArr(""),-1)
	s TmpMsgArr("itemOrder",Item,Label) = $lb(LabelLevel, LabelMsg)	//目录级别, 目录消息
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-29
/// Descript: 		获取目录的提示内容(暂时拼写，待配置完成后，取配置)
/// Input:			目录,项目
/// w ##class(web.DHCCKBPassOutPut).GetLabelMsg("禁忌症","Disease")
ClassMethod GetLabelMsg(Label, Key = "")
{
	n (Label,Key)
	
	s Msg=""
	s LibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s LabelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(Label,LibaryData)
	// 优先取目录下的项目的内容,若项目中没有,则取目录的提醒内容. 若两者都没有,则用手动拼写的
	s KeyId=""
	i Key'="" s KeyId=##class(web.DHCCKBCommon).GetDicIdByCode(Key)
	s LabelItmMsg=##class(web.DHCCKBCommon).GetItmRemindMsg(LabelID,KeyId)	// 目录下的项目提醒
	i LabelItmMsg'="" s Msg=LabelItmMsg
	q:Msg'="" Msg
	
	s LabelID=##class(web.DHCCKBCommon).GetDicIdByDesc(Label,##class(web.DHCCKBCommon).GetDrugLibaryData())
	s:+LabelID=0 LabelID=##class(web.DHCCKBCommon).GetDicIdByDesc(Label,##class(web.DHCCKBCommon).GetDrugEduProp())
	s LabelMsg=##class(web.DHCCKBCommon).GetLabelRemindMsg(LabelID)	// 目录提醒
	i LabelMsg'="" s Msg=LabelMsg
	q:Msg'="" Msg
	
	q Msg
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-04
/// Descript: 		组织输出内容
/// Input:			计算项目,his药品名称,系统药品名称,目录,目录提示信息,知识库限制内容,处方内容,管理级别,规则提醒,触发的具体内容
/// OutPut:			
/// Other:			
/// w ##class(web.DHCCKBPassOutPut).OutPutMsg("")
ClassMethod OutPutMsg(TmpArr, ItemID, Key, HisItemName, ItemName, Label, ItmMsg, Limit, OrderCont, Control, RuleMsg, LinkCont)
{
	n (TmpArr, ItemID, Key, HisItemName, ItemName, Label, ItmMsg, Limit, OrderCont, Control, RuleMsg, LinkCont)
	s PassList=$lb("Drug","Ingredient","CombinedDrugCategory","GenerNameProp","ProNameProp","ExcipientProp","GenerNameFormProp")
	if $listvalid(Control)=1 s Control=$listtostring(Control)
	if $listvalid(LinkCont)=1 s LinkCont=$listtostring(LinkCont)
	if Control'="" s Control = "("_Control_")"
	s Msg=""
	s KeyVal=$case(Key[$c(1),1:$p(Key,$c(1),1),:Key)	// 计算项目代码
	s KeyName=##class(web.DHCCKBCommon).GetDicDescByCode(KeyVal)

	s LabelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(Label)
	s LabelParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+LabelID)),4)
	s GlobalID = ##class(web.DHCCKBCommon).GetGlobalData()
	i LabelParref=GlobalID s msg = RuleMsg_Control
	q:(LabelParref=GlobalID)&&(msg'="") msg	// 全局规则提示规则提示消息 2022-03-04
	
	i Label["配伍禁忌" d 
	.q:$listfind(PassList,Key)=0
	.s Msg=$case(ItmMsg'="",1:ItmMsg_". ",:ItmMsg)_HisItemName_"和"_Limit_"配伍禁忌"_Control
	
	e  i Label["相互作用"	d	// 相互作用只需要输出A和B相互作用,若出现其他项目,则不输出
	.q:$listfind(PassList,Key)=0
	.i $listValid(Limit)=1 s Limit=$listtostring(Limit)
	.s Msg=$case(ItmMsg'="",1:ItmMsg_". ",:ItmMsg)_HisItemName_"和"_Limit_"相互作用"_".原因:"_RuleMsg

	e  i Label["药物过敏"	d
	.s AllergyValueExt=$g(TmpArr("HisAllergy","Ext"))
	.s KeyName = ##class(web.DHCCKBCommon).GetDicDescByCode(Key) // "含有相同通用名"_$case(RepeatValue'="",1:"("_RepeatValue_")",:"")
	.s Msg="患者既往对"_$case($listvalid(AllergyValueExt)=1,1:$listtostring(AllergyValueExt),:AllergyValueExt)_"过敏,"_"医嘱中"_HisItemName_"和患者过敏源含有相同内容"_$case(LinkCont'="",1:"("_LinkCont_")",:"")
	
	e  i Label["重复用药"	d
	.i KeyName="成分累积量" d
	..s IngrSumDose = $g(TmpArr("IngrSumDosageExt"))
	..s IngrSumDose = $case($lts(IngrSumDose)'="",1:$lts(IngrSumDose)_",给药剂量"_Limit,:"")
	..s Msg=IngrSumDose
	.e  d
	..i LinkCont="" s Msg=$case(ItmMsg'="",1:ItmMsg_". ",:ItmMsg)_Limit_Control
	..e  d
	...s Msg=$case(ItmMsg'="",1:ItmMsg_". ",:ItmMsg)_HisItemName_"和"_Limit_"("_KeyName_":"_LinkCont_")重复"
	
	e  i (Label["十八反")||(Label["十九畏")	d	
	.i Limit["【" s Msg=Limit_Control
	.e  s Msg="和"_Limit_Label_Control
	e  i (Label["禁忌症")||(Label["禁忌")||(Label["合理用药")||(Label["政策")||(Label["适应症")  d
	.i Control="" s Control="慎用"
	.s KeyVal=$case(Key[$c(1),1:$p(Key,$c(1),1),:Key)	// 计算项目代码
	.s KeyName=##class(web.DHCCKBCommon).GetDicDescByCode(KeyVal)
	.i KeyName["疾病" s Msg = $case(OrderCont'="",1:"患者诊断为"_OrderCont_".",:"")_$case(RuleMsg="",1:"",:RuleMsg) 
	.e  s Msg = $case(OrderCont'="",1:"处方内容为"_OrderCont_".",:"")_$case(RuleMsg="",1:"",:RuleMsg) 
	.//s Msg = $case(OrderCont'="",1:"患者诊断为"_OrderCont_",",:"")_"."_$case(RuleMsg="",1:"",:RuleMsg) // $case(ItmMsg'="",1:ItmMsg_". ",:ItmMsg)_Limit_Control
	.//s Msg = Control_"于"_$case(KeyName["疾病",1:Limit,:OrderCont)_"."_$case(RuleMsg="",1:"",:RuleMsg) // $case(ItmMsg'="",1:ItmMsg_". ",:ItmMsg)_Limit_Control
	.;i KeyName["疾病"&&(Label["适应症") s Msg = $case(OrderCont'="",1:"超适应症用药,该患诊断为"_OrderCont_".",:"")_$case(RuleMsg="",1:"",:"本品说明书适应症为"_RuleMsg)   //xww 2021-12-16 
	
	e  i (Label["本品过敏")  d	
	.s Msg = Limit
	
	e  i (Label["高危药品")  d
	.s Msg = HisItemName_"属于"_Label_Control
	
	e  i Label["液体配置"  d
	.i (Key="SolventDensity")||(Key="Solventvolume")||(Key="SolutionDensity")||(Key="SolutionVolume")||(Key="SingleSolMass") d 
	..s Msg=$case(OrderCont'="",1:"处方"_KeyName_":"_OrderCont_"。",:"可搭配溶媒使用。")_"说明书指导:"_Limit_$case(RuleMsg="",1:"",:"。"_RuleMsg) 
	.e  i (Key="SolventProp")||(Key="SolutionProp") d 
	..i $length(OrderCont,",")>2 s Msg=KeyName_"选择不当。"_$case(RuleMsg="",1:"",:"说明书指导:"_RuleMsg) 
	..e  s Msg=$case(OrderCont'="",1:"处方"_KeyName_":"_OrderCont_"。",:"可搭配溶媒使用。")_$case(RuleMsg="",1:"",:"说明书指导:"_RuleMsg) 
	.e  i (Key="IngredientDensity") d 
	..s Msg=$case(OrderCont'="",1:"处方"_KeyName_":"_OrderCont_"。")_$case(RuleMsg="",1:"",:"说明书指导:"_RuleMsg) 
	.e  i (Key="AuxDrugsNum") d 
	..s Msg= "本品需单独用药"
	.e  d
	..s Val=$case(ItmMsg'="",1:ItmMsg_".",:ItmMsg)
	..s Msg=Val_OrderCont_Limit
	
	e  i Label["遴选"||(Label="限制用药")||(Label="医保限制")  d
	.s Msg = RuleMsg  // 遴选规格目录 默认使用提示消息
	
	e  d	// 过敏的提醒(需要加区分)	
	.s Val=$case(ItmMsg'="",1:ItmMsg_".",:ItmMsg)
	.i OrderCont'="" s OrderCont="处方内容:"_OrderCont_"."
	.i Label["用法"  d
	..//s Limit = $case(OrderCont'="",1:"推荐:"_Limit_Control_".",:"")
	..s Limit = $case(OrderCont'="",1:"推荐:"_Limit_".",:"")
	..s KeyName = ""
	..i Key'="" s KeyName=##class(web.DHCCKBCommon).GetDicDescByCode(Key)	
	..i (KeyName'="")&(KeyName'=0) s Val=KeyName_"问题."
	..s Msg=Val_""_OrderCont_Control_""_Limit
	.e  d
	..i Limit'="" s Limit = "说明书指导:"_Limit_"."
	..//i Limit'="" s Limit = "说明书指导:"_Limit_Control_"."
	..//s Limit = $case(OrderCont'="",1:"说明书指导:"_Limit_Control_".",:"")
	..s Msg=Val_""_OrderCont_Control_""_Limit

	q Msg
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-04
/// Descript: 		获取当前分支所在节点的类型
/// Input:			RuleDataID
/// OutPut:			and,or,union,var-assign	
/// Other:			
/// w ##class(web.DHCCKBPassOutPut).GetRuleDataNodeType(1635302)
ClassMethod GetRuleDataNodeType(RuleDataID)
{
	n (RuleDataID)
	
	s RuleNodeID = $lg($g(^CT.CKB.PDSS.RuleDataD(+RuleDataID)),3)
	q:RuleNodeID="" ""
	
	s NodeType = $lg($g(^CT.CKB.PDSS.RuleNodeD(+RuleNodeID)),3)
	q NodeType
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-28  2022-04-08修改
/// Descript: 		审查的计算项目的提示信息(按照计算项目提醒处理消息,不是按照RuleID提示,避免一条规则中出现一个项目提醒多次)
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetCalcItmWarnMsgNew()
ClassMethod GetCalcItmWarnMsgNew(TmpArr As %String, TmpMsgArr As %String, Item As %String, Label As %String, RuleID As %String) As %String
{
	n (TmpArr, TmpMsgArr, Item, Label, RuleID)
	
	s RepeatMsg = ""
	k TmpKeyArr 
	s LimitList ="",NodeList="",LinkContList=""
	s ID = ""
	f  s ID = $o(TmpMsgArr("itemOrder",Item,Label,RuleID,ID)) q:ID=""  d		
	.s TmpKey = $g(TmpMsgArr("itemOrder",Item,Label,RuleID,ID))
	.s Key = $p(TmpKey,"@@",1)	// 计算项目
	.s Itm = $p(TmpKey,"@@",2)	// 程序拼接的提醒消息(相互作用的药品)
	.s LinkCont = $p(TmpKey,"@@",3)	// 相互作用药品的原因(具体成分、分类)
	.i $listvalid(LinkCont)>0 s LinkCont=$lts(LinkCont,",")	
	.s Limit=""
	.i Itm="" d
	..i $d(^CT.CKB.PDSS.RuleDataD(ID)) s Limit=##class(web.DHCCKBCommon).GetRuleLimitContent(ID)	// 规则限定内容
	.e  d
	..s Limit=$case($listvalid(Itm),1:$listtostring(Itm),:Itm)
	.q:Limit=""
	.s KeyVal=$case(Key[$c(1),1:$p(Key,$c(1),1),:Key)	// 计算项目代码
	.s KeyName=##class(web.DHCCKBCommon).GetDicDescByCode(KeyVal)
	.s:KeyName="" KeyName=KeyVal 
	.q:KeyName=""
	.i $lf(LimitList,Limit)=0 s $list(LimitList,*+1)=Limit		
	.s UnionFlag = ..GetRuleDataNodeType(ID)
	.i (UnionFlag'="")&&($lf(NodeList,UnionFlag)=0) s $list(NodeList,*+1)=UnionFlag	
	.//s TmpKeyArr(KeyVal)=$lb(Key,KeyName,LimitList,NodeList)
	.s TmpKeyArr(KeyVal)=$lb(Key,KeyName)
	.s LimitList= $g(TmpKeyArr(KeyVal,"Limit"))
	.i (Limit'="")&&($lf(LimitList,Limit)=0) s $list(TmpKeyArr(KeyVal,"Limit"),*+1) = Limit
	.s NodeList= $g(TmpKeyArr(KeyVal,"NodeList"))
	.i (UnionFlag'="")&&($lf(NodeList,UnionFlag)=0) s $list(TmpKeyArr(KeyVal,"NodeList"),*+1) = UnionFlag
	.s IDList=$g(TmpKeyArr(KeyVal,"ID"))
	.i (+ID'=0)&&($lf(IDList,ID)=0) s $list(TmpKeyArr(KeyVal,"ID"),*+1) = ID	// 计算项目中所关联的ruleDataID qnp 2022-04-22
	.s LinkContList=$g(TmpKeyArr(KeyVal,"LinkCont"))
	.i (LinkCont'="")&&($lf(LinkContList,LinkCont)=0) s $list(TmpKeyArr(KeyVal,"LinkCont"),*+1) = LinkCont	// 计算项目中所关联的ruleDataID qnp 2022-04-22
	.//s KeyValLevelStr = ..GetRuleDataLevel(ID)	
	
	s ContrCount = 0
	s CalcItmArr = ##class(DHCNewPro.COM.Array).%New()
	
	s KeyVal = ""
	f  s KeyVal = $o(TmpKeyArr(KeyVal)) q:KeyVal=""  d
	.s List = $g(TmpKeyArr(KeyVal))
	.s Key = $lg(List,1)
	.s KeyName = $lg(List,2)
	.//s Limit = $lg(List,3)
	.s Limit = $g(TmpKeyArr(KeyVal,"Limit"))
	.s Limit = $lts(Limit)
	.//s NodeList = $lg(List,4)
	.s NodeList = $g(TmpKeyArr(KeyVal,"NodeList"))
	.s NodeList = $lts(NodeList)
	.s LinkCont = $g(TmpKeyArr(KeyVal,"LinkCont"))
	.s LinkCont = $lts(LinkCont)
	.s CalcItmObj = ##class(DHCNewPro.COM.Object).%New()	
	.d CalcItmObj.Set("key",$case(Key[$c(1),1:$p(Key,$c(1),1),:Key))	// 计算项目代码)
	.d CalcItmObj.Set("keyname",KeyName)			// 审查项目
	.s ItmMsg =  ##class(web.DHCCKBPassOutPut).GetLabelMsg(Label,KeyVal) // 提醒内容(从项目优先级维护处获取) 
	.d CalcItmObj.Set("msg",ItmMsg)
	.s LabelID = ##Class(web.DHCCKBPassNew).GetRuleLabelID(RuleID)
	.s LabelCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+LabelID)),2)
	.s OrderCont=$listtostring($g(TmpArr(Key,"Ext")))			// 处方内容
	.s OrderCont=$case($listvalid(OrderCont)>0,1:$listtostring(OrderCont),:OrderCont)
	.i (Label["禁忌")&&((KeyVal["LabItm")||(KeyVal["LabItmValueLimitProp")) d
	..s OrderCont=""
	..s ContrCount = ContrCount+1
	..d CalcItmObj.Set("key",LabelCode)
	..d CalcItmObj.Set("keyname",Label)			// 审查项目
	.
	.d CalcItmObj.Set("order",OrderCont)
	.d CalcItmObj.Set("limit",Limit)
	.s IDList = $g(TmpKeyArr(KeyVal,"ID"))
	.s IDList=$lts(IDList)
	.s ItemID=$p(Item,$c(2),1)
	.s ItemName=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItemID)),3)
	.s HisItemName=$listtostring($g(TmpArr("Drug",Item)))
	.s:HisItemName="" HisItemName=ItemName	
	.s RuleInfo = $g(TmpMsgArr("itemOrder",Item, Label, RuleID))
	.s CalcLevel = ..GetRuleDataLevelStr(IDList,LabelID,.TmpArr)	// 分支级别 2022-04-22	
	.i CalcLevel=""	s CalcLevel=$lg(RuleInfo,9)_"^"_##class(web.DHCCKBCommon).GetDicDescByCode($lg(RuleInfo,9))	// 分支级别为空,使用规则级别
	.i (KeyVal["OnceAbsurdValue")||(KeyVal["DayAbsurdValue") s CalcLevel = "forbid^禁止"
	.d CalcItmObj.Set("manLev",$p(CalcLevel,"^",2))	// 级别描述
	.d CalcItmObj.Set("manLevel",$p(CalcLevel,"^",1))
	.i KeyVal["Disease"&&(Label["禁忌") d
	..s MatchDisease=$g(TmpArr("MatchDisease",Item,RuleID)) 
	..i $listValid(MatchDisease)=1 s MatchDisease=$listtostring(MatchDisease) 
	..s:MatchDisease'="" OrderCont=MatchDisease //xww 2021-10-28
	.//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	.s OutPutMsg = ..OutPutMsg(.TmpArr, ItemID, KeyVal, HisItemName, ItemName, Label, ItmMsg, Limit, OrderCont, $listget(RuleInfo,5), $listget(RuleInfo,4),LinkCont)
	.d CalcItmObj.Set("val",OutPutMsg)
	.s TmpOutPutMsg = OutPutMsg
	.i $length(TmpOutPutMsg)>125 s TmpOutPutMsg=$e(TmpOutPutMsg,1,125) // 长度过长，不能作为节点
	./* 按照项目提示,判断提示内容是否相同,防止出现多条规则提示内容相同的情况*/ // 现在的按照规则提醒的模式：项目内容+规则提示内容
	./* 当前分支是联合节点的情况下,不进行当前节点下项目的输出。如：检验指标和检验值 */
	.//s unionFlag = ..GetRuleDataNodeType(ID)
	.//i ($d(RepeatMsg))&&($d(RepeatMsg(TmpOutPutMsg))||(unionFlag="union")) d
	.//i ($d(RepeatMsg))&&(TmpOutPutMsg'="")&&($d(RepeatMsg(TmpOutPutMsg))||((unionFlag="union")&&(Label'["液体配置"))) d
	.//.k CalcItmObj
	.s CleanFlag=0
	.i ($d(RepeatMsg))&&(TmpOutPutMsg'="")&&($d(RepeatMsg(TmpOutPutMsg))) d
	..k CalcItmObj
	..s CleanFlag=1
	.i ((NodeList="union")&&(Label'["液体配置")&&(Label'["重复用药")&&(Label'["禁忌"))  d
	..k CalcItmObj
	..s CleanFlag=1
	.i (NodeList="union")&&(Label["液体配置")&&(KeyName="成分")  d
	..k CalcItmObj
	..s CleanFlag=1
	.
	.i (Label["禁忌")&&((KeyVal["LabItm")||(KeyVal["LabItmValueLimitProp"))  d
	..i ContrCount>1 d
	...k CalcItmObj 
	...s CleanFlag=1
	.
	.i CleanFlag = 0 d
	..d CalcItmArr.Push(CalcItmObj)
	.q:TmpOutPutMsg=""
	.s RepeatMsg(TmpOutPutMsg) = ""
	./* 记录每个问题项的提示内容 2020-03-10 bianshuai */
	.s LabelInfo = $g(TmpMsgArr("itemOrder",Item,Label))
	.s LabelNum =  $listget(LabelInfo,1)	
	.s LabelLevel = ##class(web.DHCCKBCommon).GetManLevelCodeByNum(LabelNum)	
	.s LabelLevelName = ##class(web.DHCCKBCommon).GetDicDescByCode(LabelLevel)	
	.s TmpMsgArr("itemOrderMsg",Item,Label,RuleID,Key)=LabelLevelName_"^"_OutPutMsg
	//s CalcItmArr = ..GetTipMsgByRule(CalcItmArr)
	q CalcItmArr
}

ClassMethod GetTipMsgByRule(CalcItmArr)
{
	n (CalcItmArr)
	Q:CalcItmArr.Size()<2 CalcItmArr
	s msgArr = ##class(DHCNewPro.COM.Array).%New()
	s size = CalcItmArr.Size()
	s obj = ##class(DHCNewPro.COM.Object).%New()
	s retval = ""
	for i=0:1:size-1  d
	.s calcItmObj = CalcItmArr.Get(i)
	.s val = calcItmObj.val
	.s msgDea = $p(val,".",1)
	.s msgLib = $p(val,".",2)
	.i retval = "" s retval = msgDea
	.e  s retval = retval_","_calcItmObj.keyname_"为"_calcItmObj.order
	.i i=0  d
	..d obj.Set("key",calcItmObj.key)
	..d obj.Set("keyname",calcItmObj.keyname)
	..d obj.Set("limit",calcItmObj.limit)
	..d obj.Set("manLev",calcItmObj.manLev)
	..d obj.Set("limit",calcItmObj.limit)
	..d obj.Set("manLevel",calcItmObj.manLevel)
	..d obj.Set("msg",calcItmObj.msg)
	..d obj.Set("order",calcItmObj.order)
	.d obj.Set("val",retval_"."_msgLib)
	d msgArr.Push(obj)
	Q msgArr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-04-22
/// Descript: 		获取规则分支的管理级别
/// Input:			ruleDataID, 目录lid
/// w ##Class(web.DHCCKBPassOutPut).GetRuleDataLevelStr(4180512)
ClassMethod GetRuleDataLevelStr(ruleDataIDStr As %String, labelId = 0, TmpArr) As %String
{
	n (ruleDataIDStr,labelId, TmpArr)
	
	k TmpCalcLevel
	
	f i=1:1:$l(ruleDataIDStr)  d
	.s ruleDataID=$p(ruleDataIDStr,",",i)
	.q:+ruleDataID=0	
	.i $d(TmpArr("SetLevel",ruleDataID)) s levelId=$g(TmpArr("SetLevel",ruleDataID))	// 用法用量下限设置了级别,相当于分支级别 2022-05-19
	.e  s levelId = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),13)	// 分支级别
	.i +levelId=0 d	// 没有维护分支级别,取项目级别
	..s LeftDic =$lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),4)	// 属性
	..s LeftValue =$lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),5)	// 实体
	..s calcItmID = $case(+LeftDic=0,1:+LeftValue,:+LeftDic)
	..q:+calcItmID=0	
	..s calcItmLevel = ##Class(web.DHCCKBCommon).GetLabelItmLevel(labelId,calcItmID)	// 计算项目的级别code
	..i calcItmLevel'="" s levelId = ##class(web.DHCCKBCommon).GetDicIdByCode(calcItmLevel)
	.q:+levelId=0
	.s manLevCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+levelId)),2)
	.s manLevName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+levelId)),3)
	.q:(manLevCode="")||(manLevName="") 
	.s levelNum = ##class(web.DHCCKBCommon).GetManLevelNum(manLevCode)
	.s TmpCalcLevel(levelNum) = manLevCode_"^"_manLevName_"^"_levelNum
	
	q:'$d(TmpCalcLevel) ""
	s levelnum = $o(TmpCalcLevel(""),-1)
	s str= $g(TmpCalcLevel(levelnum))
	q str
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-04-22
/// Descript: 		获取规则分支的管理级别
/// Input:			
/// w ##Class(web.DHCCKBPassOutPut).GetRuleDataLevel(4180512)
ClassMethod GetRuleDataLevel(ruleDataID As %String) As %String
{
	n (ruleDataID)	

	q:+ruleDataID=0 ""
	s levelId = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),13)
	q:+levelId=0
	s manLevCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+levelId)),2)
	s manLevName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+levelId)),3)
	q:(manLevCode="")||(manLevName="") 
	s levelNum = ##class(web.DHCCKBCommon).GetManLevelNum(manLevCode)
	
	s str= levelNum_"^"_manLevCode_"^"_manLevName
	q str
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-09-02
/// Descript: 		获取患者信息
/// Input:			
/// OutPut:			{patSex:"性别",patName:"姓名",patAge:"年龄(28岁)",patHeight:"身高(180cm)",patWeight:"体重(50kg)",mainDoc:"主治医生",patLoc:"科室",billType:"费别",specialPop:[特殊人群],diag:"诊断(感冒,发烧)"}
/// w ##Class(web.DHCCKBPassOutPut).GetPatInfo(TmpArr)
ClassMethod GetPatInfo(TmpArr) As %String
{
	n (TmpArr)	
	s specArr = ##class(DHCNewPro.COM.Array).%New()
	s patObj = ##class(DHCNewPro.COM.Object).%New() 
	
	// 特殊人群
	s speclist = $g(TmpArr("SpecialPop","Ext"))
	s speclist = $case($listvalid(speclist)=0,1:$lfs(speclist),:speclist)
	f i=1:1:$ll(speclist) d
	.s value = $lg(speclist,i)
	.d specArr.Push(value)
	
	// 性别
	s patSex = $g(TmpArr("SexProp","Ext"))
	s patSex = $case($listvalid(patSex)=0,1:patSex,:$lts(patSex))	
	//姓名
	s patName = $g(TmpArr("PatName"))
	s patName = $case($listvalid(patName)=0,1:patName,:$lts(patName))	
	//年龄
	s patAge = $g(TmpArr("AgeProp","Ext"))
	s patAge = $case($listvalid(patAge)=0,1:patAge,:$lts(patAge))
	//身高	
	s patHeight = $g(TmpArr("Height","Ext"))
	s patHeight = $case($listvalid(patHeight)=0,1:patHeight,:$lts(patHeight))
	i +patHeight=0 s patHeight=""
	//体重
	s patWeight = $g(TmpArr("Weight","Ext"))
	s patWeight = $case($listvalid(patWeight)=0,1:patWeight,:$lts(patWeight))
	i +patWeight=0 s patWeight=""
	//医生
	s mainDoc = $g(TmpArr("CarePrvID"))
	s mainDoc = $case($listvalid(mainDoc)=0,1:mainDoc,:$lts(mainDoc))
	//科室
	s patLoc = $g(TmpArr("DocLocID"))
	s patLoc = $case($listvalid(patLoc)=0,1:patLoc,:$lts(patLoc))
	//费别
	s billType = $g(TmpArr("billType","Ext"))
	s billType = $case($listvalid(billType)=0,1:billType,:$lts(billType))
	//诊断
	s diag = $g(TmpArr("Disease","Ext"))
	s diag = $case($listvalid(diag)=0,1:diag,:$lts(diag))
	
  
    d patObj.Set("patSex",patSex)
	d patObj.Set("patName",patName)
	d patObj.Set("patAge",patAge)      
	d patObj.Set("patHeight",patHeight)
	d patObj.Set("patWeight",patWeight)
	d patObj.Set("mainDoc",mainDoc) 
	d patObj.Set("patLoc",patLoc)
	d patObj.Set("billType",billType)
	d patObj.Set("specialPop",specArr) 
	d patObj.Set("diag",diag)
	
	q patObj
}

}

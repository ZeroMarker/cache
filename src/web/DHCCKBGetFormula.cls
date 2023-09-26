/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-20
/// Descript: 		公式取值函数类
Class web.DHCCKBGetFormula Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-20
/// Descript: 		使用属性获取入参中药品节点的属性值(如：药品的单次剂量)
/// w ##Class(web.DHCCKBGetFormula).GetPropValueByCode("","")
ClassMethod GetPropValueByCode(TmpArr, PropCode, Union = "") As %String
{
	n (TmpArr,PropCode,Union)
	
	//s CalcItm = $case($d(TmpArr("UnionItm"))>=0,1:$g(TmpArr("UnionItm")),:$g(TmpArr("CalcItm")))
	s CalcItm = $case(Union="union",1:$g(TmpArr("UnionItm")),:$g(TmpArr("CalcItm")))
	//s CalcItm=$g(TmpArr("CalcItm"))
	q:(CalcItm="")||(PropCode="") ""
	
	s Value=$g(TmpArr(PropCode_$c(1)_CalcItm))
	
	i $listvalid(Value)=1 s Value=$listtostring(Value)
	q:(PropCode["FreqFactorProp")&&(+Value=0) 1	// 频次系数为空时,退1
	q Value
	// TmpArr("FreqFactorProp"_$c(1)_CalcDrug)	// 频次转换系数
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-20
/// Descript: 		使用属性获取入参中的属性值(如：年龄,性别等)
/// w ##Class(web.DHCCKBGetFormula).GetPropValueByCode("","")
ClassMethod GetComPropValueByCode(TmpArr, PropCode) As %String
{
	n (TmpArr,PropCode)

	s CalcItm=$g(TmpArr("CalcItm"))
	q:(CalcItm="")||(PropCode="") ""
	s Value=$g(TmpArr(PropCode))
	
	i $listvalid(Value)=1 s Value=$listtostring(Value)
	
	q Value
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-21
/// Descript: 		取入参的数据集（如：返回溶媒数据集）暂时不用,因为在入参准备时不能区分溶媒，溶液
/// w ##Class(web.DHCCKBGetFormula).GetDataSourceByCode("","")
ClassMethod GetDataSourceByCode(TmpArr, PropCode) As %String
{
	n (TmpArr,PropCode)
	
	q:PropCode="" ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-21
/// Descript: 		获取联合节点中的项目，如溶媒药品、检验项目
/// w ##Class(web.DHCCKBGetFormula).GetUnionValueByCode("","")
ClassMethod GetUnionItm(TmpArr, UnionCode) As %String
{
	n (TmpArr,UnionCode)
	
	s ID=$g(TmpArr("ID"))
	s RuleID=$g(TmpArr("RulID"))
	q:(ID="")||(RuleID="") ""

	s Node=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),3)
	q:Node="" ""
	
	/*
	s ItemList=""
	s NewID="" 		// Union:{溶媒:药品1，浓度：10mg/ml}
	f  s NewID=$o(^CT.CKB.PDSS.RuleDataI("Node",Node,NewID))	q:NewID=""  d
	.s LeftID=$lg($g(^CT.CKB.PDSS.RuleDataD(NewID)),4)      					/// 关系指针(左)
	.i LeftID'="" s LeftDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftID)),2)   	/// 相关实体代码
	.q:$g(LeftDicCode)'=UnionCode
	.s CheckDicID=$lg($g(^CT.CKB.PDSS.RuleDataD(NewID)),8)
	.q:CheckDicID=""
	.s $list(ItemList,*+1)=CheckDicID
	.
	q:$listlength(ItemList)'=0 ItemList	
	
	s NewNode=""		// and:{浓度：10mg/ml, and:{溶媒:药品1，药品2}} 兼容Union之前的and节点
	f  s NewNode=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RuleID,"if",Node,NewNode))  q:NewNode=""  d
	.s NewID=""
	.f  s NewID=$o(^CT.CKB.PDSS.RuleDataI("Node",NewNode,NewID))	q:NewID=""  d
	..s LeftID=$lg($g(^CT.CKB.PDSS.RuleDataD(NewID)),4)      					/// 关系指针(左)
	..i LeftID'="" s LeftDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftID)),2)   	/// 相关实体代码
	..q:$g(LeftDicCode)'=UnionCode
	..s CheckDicID=$lg($g(^CT.CKB.PDSS.RuleDataD(NewID)),8)
	..q:CheckDicID=""
	..s $list(ItemList,*+1)=CheckDicID
	.
	*/
	s ItemList=..GetUnionItmByNode(Node,UnionCode)
	q:$listlength(ItemList)'=0 ItemList	
	
	s NewNode=""		// and:{浓度：10mg/ml, and:{溶媒:药品1，药品2}} 兼容Union之前的and节点
	f  s NewNode=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RuleID,"if",Node,NewNode))  q:NewNode=""  d
	.s tmpList=..GetUnionItmByNode(NewNode,UnionCode)
	.s ItemList = ##Class(web.DHCCKBCommonUtil).GetUnionList(tmpList,ItemList)		
	q:$listlength(ItemList)'=0 ItemList
	
	s NewNode=..GetUpUnionNode(Node) // union:{溶媒:药品1 or:{浓度10mg/ml,浓度15mg/ml}}  
	q:NewNode=Node ""
	s ItemList=..GetUnionItmByNode(NewNode,UnionCode)
	q:$listlength(ItemList)'=0 ItemList	 
	
	s TmpNode=""		// a union:{or:{溶媒:药品1,药品2} or:{浓度10mg/ml,浓度15mg/ml}} 
	f  s NewNode=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RuleID,"if",NewNode,TmpNode))  q:TmpNode=""  d
	.s tmpList=..GetUnionItmByNode(TmpNode,UnionCode)
	.s ItemList = ##Class(web.DHCCKBCommonUtil).GetUnionList(tmpList,ItemList)	
	
	q ItemList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-21
/// Descript: 		使用属性，获取联合节点中的【项目】在入参中的属性值，如溶媒药品的单次剂量
/// w ##Class(web.DHCCKBGetFormula).GetUnionValueByCode("","")
ClassMethod GetUnionItmValue(TmpArr, PropCode, UnionCode) As %String
{
	n (TmpArr,PropCode,UnionCode)
	
	//s ItemList=..GetUnionItm(.TmpArr, UnionCode)
	//s Item=$listget(ItemList)	// 若是药品,则需要一个药品序号，该怎么处理
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s TmpDicID="",IsExistFlag=0,SolutionItmID=""
	s DrugList=$g(TmpArr("Drug"))
	f Num=1:1:$listlength(DrugList) q:(IsExistFlag=1)  d
	.s TmpDicID=$list(DrugList,Num)
	.q:CheckDicID=TmpDicID	
	.s LinkItmID=..GetUnionItm(.TmpArr, UnionCode)		
	.q:LinkItmID=""
	.s comDrugId = TmpDicID
	.i $d(TmpArr("ComOriginDrug"_$c(1)_TmpDicID)) s comDrugId=$lg(TmpArr("ComOriginDrug"_$c(1)_TmpDicID)) // 若存在本源药品,则使用本源药品的属性
	.s GeneralFromList=##class(web.DHCCKBCommon).GetGeneralFrom(+comDrugId,1)
	.//q:'$LISTFIND(LinkItmID,+TmpDicID)			// 找到入参中的溶媒/溶液药品	
	.q:##Class(web.DHCCKBCommonUtil).CompareBothList(GeneralFromList,LinkItmID)=0	// 找到入参中的溶媒/溶液药品
	.s HisGroupFlag=##Class(web.DHCCKBPassNew).ISGroup(CheckDicID,TmpDicID,.TmpArr)		// 判断找到的his入参中的溶媒,是否和检测药品成组,非成组则不计算
	.q:HisGroupFlag=0
	.s IsExistFlag=1
	.s SolutionItmID=TmpDicID
	
	i SolutionItmID'="" s TmpArr("UnionItm")=SolutionItmID	// 记录联合节点项目。如溶媒药品
	s ItmValue=..GetPropValueByCode(.TmpArr, PropCode,"union")

	q:ItmValue="" ""
	q ItmValue
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-25
/// Descript: 		使用属性，获取知识库中的属性值,如药品成分、药品分类、药品名称等
/// w ##Class(web.DHCCKBGetFormula).GetSysPropByCode("","")
ClassMethod GetSysPropByCode(TmpArr, PropCode) As %String
{
	n (TmpArr,PropCode)
	
	s CalcItm=$g(TmpArr("CalcItm"))
	q:(CalcItm="")||(PropCode="") ""	

	s ExistFlag = 0	// 皮试药品有皮试结果,则提示需要皮试 2022-05-19
	i PropCode="SkinTestDrugProp" d	
	.s SkinValue = $listget(TmpArr("SkinResult"_$c(1)_CalcItm))
	.s:SkinValue'="" ExistFlag=1
	q:ExistFlag=1 ""
	
	s ListData=##class(web.DHCCKBCommon).GetSysPropValue(+CalcItm,PropCode)
	
	q ListData
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-25
/// Descript: 		使用节点,属性，获取固定项目的属性值（如：(.TmpArr,"Lab"，"血肌酐","剂量")）
/// w ##Class(web.DHCCKBGetFormula).GetUnionValueByCode("","")
ClassMethod GetLimitItmValueByCode(TmpArr, Node, Itm, PropCode) As %String
{
}

/// 通过过滤条件获取整组信息：如：获取整组液体的体积，累计用药时长，累计用药量等
/// .TmpArr,"溶媒数据集Code",OnceDose，[SeqNo]
ClassMethod GetGroupValue()
{
}

/// 系统函数：累加
ClassMethod Sum(DataList)
{
	n (DataList)
	q:DataList="" ""
	
	s Sum=0
	f Index=1:1:$listlength(DataList)  d
	.s Value=$listget(DataList,Index)
	.s Sum=Sum+(+Value)
	
	q Sum
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		系统函数：重复个数
/// Input:			数据源列表，查找项目列表(如果多个，是且的关系)
/// w ##Class(web.DHCCKBGetFormula).Distinct("","Drug","")
ClassMethod Distinct(TmpArr, Node, KeyArr)
{
	n (TmpArr, Node,KeyArr)
	;s TmpArr = ..GetTempParam(.TmpArr)
	;s KeyArr = $lb("FormProp")
	k ItemArr
	s checkID=TmpArr("CheckDicID")							//当前药品
	s ItemList=$g(TmpArr(Node))								//数据列表
	f i=1:1:$listlength(ItemList) d							//循环数据列表
	.s ItemId=+$list(ItemList,i)
	.Q:ItemId=""
	.s attrLength = $listlength(KeyArr)						//属性数量
	.for j=1:1:attrLength  d
	..s attrCode = $list(KeyArr,j)							//属性code
	..s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode(attrCode)
	..s attrValList = ..GetSysItemValue(ItemId,attrId)		//取值
	..s ItemArr(ItemId,attrId) = attrValList
	
	s ret = 0
	s count = 0
	s comAttrlength = $listlength(KeyArr)					//属性数量
	for i=1:1:comAttrlength  d
	.s attrCode = $list(KeyArr,i)							//属性code
	.s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode(attrCode)
	.s comAttrValList = ItemArr(checkID,attrId)
	.s index = ""
	.for  s index = $o(ItemArr(index))  Q:index=""  d
	..Q:index=checkID
	..s curAttrValList = ItemArr(index,attrId)	
	..s ret = ..Compare(comAttrValList,curAttrValList)
	..i ret '= "" d
	...s count = count+1 
	...s QuitArr(index,attrId) = ret
	.Q:count=0
	.
	Q count
}

/// Descript:比较是否重复
/// Creator:sufan
/// CreateDate:2020-05-27
/// Input:属性值列表，比较属性值列表
/// w ##class(web.DHCCKBGetFormula).Compare("123,321,231","123,321")
ClassMethod Compare(comAttrValList, curAttrValList)
{
	n (comAttrValList,curAttrValList)
	s ret = ""
	Q:(comAttrValList="")||(curAttrValList="") ret
	s valLength = $l(curAttrValList,",")
	
	i valLength = 1 d
	.s:comAttrValList[curAttrValList ret=curAttrValList
	e  d
	.for i=1:1:valLength  d
	..s attrVal = $p(curAttrValList,",",i)
	..i comAttrValList[attrVal  d
	...i ret = "" s ret = attrVal
	...e  s ret = ret _","_ attrVal
	Q ret
}

/// Descript：取知识库属性值
/// Creator:sufan
/// CreateDate:2020-05-27
/// Input:药品，药品属性
ClassMethod GetSysItemValue(drugId, drugAttrId)
{
	n (drugId,drugAttrId)
	s valList = ""
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,drugAttrId,attrId)) Q:attrId=""  d
	.s propId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)			//属性值
	.s propVal = $lg($g(^CT.CKB.PDSS.CommonDictionD(propId)),3)			//描述
	.i valList = "" s valList = propVal
	.e  s valList = valList _","_ propVal
	Q valList
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		系统函数：数量
/// Input:			临时数组，节点(drug),属性值
/// w ##Class(web.DHCCKBGetFormula).CumulatMedDurat(TmpArr,Key)
ClassMethod Count(TmpArr, Node, TempCode)
{
	n (TmpArr,Node,TempCode)
	/*
	 *处方号：PresNo
	 *
	*/
	s CheckID=TmpArr("CheckDicID")	
	s PresNo=TmpArr(TempCode_$c(1)_CheckID)
	s count=0
	s ItmList=$g(TmpArr(Node))
	f i=1:1:$listlength(ItmList) d
	.s Itmid=$list(ItmList,i)
	.q:+Itmid=0
	.s ItmPresNo=$listtostring($g(TmpArr(TempCode_$c(1)_Itmid)))
	.Q:PresNo'=ItmPresNo
	.s count=count+1
	Q count
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		取血肌酐
/// Input:			数据源列表，节点(drug等)，属性code，检验项目
/// w ##Class(web.DHCCKBGetFormula).getScr(TmpArr,"")
ClassMethod getScr(TmpArr, Node, TempCode, LabItem)
{
	n (TmpArr,Node,TempCode,LabItem)
	/*
	 *检验指标：LabItmValueLimitProp
	 *
	*/
	s InspectList=$g(TmpArr(Node))							//数据列表
	f i=1:1:$listlength(InspectList) d						//循环检验项目，取出血肌酐值进行计算
	.s LabitmId=$list(InspectList,i)
	.Q:LabitmId=""
	.s LabDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LabitmId)),3)			//检验项目rop
	.Q:LabDesc'=LabItem			
	.s LabValue=$g(TmpArr(TempCode_$c(1)_LabitmId))			// 指标值
	.s:$listvalid(LabValue)=1 LabValue=$listget(LabValue)
	Q LabValue
}

/// CreateDate: 	2020-12-17
/// Creator:		qunianpeng
/// Descript: 		计算疗程间的间隔时长
/// Input:			
/// w ##Class(web.DHCCKBGetFormula).CalcTreatBettenDayNum(TmpArr,"")
ClassMethod CalcTreatBettenDayNum(TmpArr, PropCode)
{
	n (TmpArr,PropCode)
	
	s CheckItmID = $g(TmpArr("CalcItm"))
	s CheckItmName = $listtostring(TmpArr("Drug",CheckItmID))
	//s CheckItmTreat = $listtostring(TmpArr("Treatment"_$c(1)_CheckItmID))	
	s CheckItmOrderDate = $listtostring(TmpArr("OrdDate"_$c(1)_CheckItmID)) //医嘱日期	
	s JsParamsObj = $g(TmpArr("InParams"))
	
	s ItemHisOrders = JsParamsObj.ItemHisOrder	// 历史医嘱
	s PatType = JsParamsObj.PatType	// 门急诊
	
	// 遍历历史医嘱列表,找到当前处方中的药	
	s TreatDayNum = ""
	s ExitFlag = 0 
	q:ItemHisOrders="" ""
	s Len = ItemHisOrders.%Size()

	f Index = 0:1:Len-1  q:ExitFlag=1  d
	.s HisOrder = ItemHisOrders.%Get(Index)
	.s HisOrderName = HisOrder.item
	.q:HisOrderName'=CheckItmName
	.s OrdEndDate = HisOrder.OrdEndDate	// 医嘱结束日期
	.q:OrdEndDate=""
	.i CheckItmOrderDate'="" s TreatDayNum = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(CheckItmOrderDate)-##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OrdEndDate)
	.e  s TreatDayNum = (+$h)-##class(web.DHCCKBCommonUtil).DateHtmlToLogical(OrdEndDate)
	.s ExitFlag = 1

	q TreatDayNum
}

/// CreateDate: 	2022-04-14
/// Creator:		qunianpeng 
/// Descript: 		计算成分浓度
/// Input:			
/// w ##Class(web.DHCCKBGetFormula).GetIngrDensityValue()
ClassMethod GetIngrDensityValue(TmpArr)
{
	n (TmpArr)
	s UnionCode = "Ingredient"
	s UnionDr = ##class(web.DHCCKBCommon).GetDicIdByCode(UnionCode)
	s LinkItmID=..GetUnionItm(.TmpArr, UnionCode) // 成分id list	
	q:LinkItmID="" ""
	
	k WholeArr
	// 按照组医嘱存储
	s Count = 0
	s DrugList=$g(TmpArr("Drug"))
	f Num=1:1:$listlength(DrugList)  d
	.s TmpDicID=$list(DrugList,Num)
	.s CheckSeqNo=$listtostring($g(TmpArr("LinkSeqNo"_$c(1)_TmpDicID)))
	.s CheckSeqNo = $p(CheckSeqNo,".",1)
	.q:CheckSeqNo=""
	.s Count = Count + 1
	.s WholeArr(CheckSeqNo,Count)=TmpDicID
	
	s IngrDensity = ""
	s SeqNo= ""
	f  s SeqNo = $o(WholeArr(SeqNo))  q:(SeqNo="")||(IngrDensity'="")  d
	.s Start = $o(WholeArr(SeqNo,""))
	.s End = $o(WholeArr(SeqNo,""),-1)
	.q:Start=End  // 不成组
	.s WholeQty = 0,IngrQty = 0
	.s Count = ""
	.f  s Count = $o(WholeArr(SeqNo,Count))	q:Count=""  d
	..s TmpDicID = $g(WholeArr(SeqNo,Count))
	..s TmpQty = $listtostring(TmpArr("OnceDose"_$c(1)_TmpDicID)) 	//单次剂量
	..s TmpQtyUnit = $listtostring(TmpArr("OnceDose"_$c(1)_TmpDicID,"Unit","Ext"))
	..s TmpQtyUnit=$zcvt(TmpQtyUnit,"U")
	..i (TmpQtyUnit'="ML")&&(TmpQtyUnit'="L") d 
	...
	..e  d
	...s WholeQty = WholeQty + TmpQty	// 一组整体剂量
	..	
	..s IngrStr = ##class(web.DHCCKBEditProp).QueryAttrValue(+TmpDicID,UnionDr) //  "g0.25氯唑西林钠,g0.25氨苄西林钠"	
	..f i=1:1:$ll(LinkItmID)  d
	...s TmpLinkItmID = $lg(LinkItmID,i)
	...s TmpLinkItm = $lg($g(^CT.CKB.PDSS.CommonDictionD(+TmpLinkItmID)),3)
	...q:TmpLinkItm=""
	...q:IngrStr'[TmpLinkItm
	...s IngrNumStr = $p(IngrStr,TmpLinkItm,1)
	...s IngrNum = ##class(web.DHCCKBCommonUtil).GetNum(IngrNumStr)	// 成分含量
	...s IngrUnit = $p(IngrNumStr,IngrNum,1)	// 成分单位
	...s IngrUnit = $zcvt(IngrUnit,"U")
	...s IngrQty = IngrQty + IngrNum // 成分浓度
	..
	.q:WholeQty=0
	.s IngrDensity = IngrQty/WholeQty
	
	q IngrDensity
}

/// Descript:计算成分累积量
/// Input:TmpArr,成分id
ClassMethod GetIngrSumDosageValue(TmpArr, propCode, unionCode)
{
	n (TmpArr, propCode,unionCode)	
	
	s ID=$g(TmpArr("ID"))				// 规则明细id
	s libValue = ##Class(web.DHCCKBPassNew).GetSysValue(ID,.TmpArr)
	q:(libValue="") -1	 // 取不到值或者转换失败的情况下,忽略这条规则	
	s libUnit = $lg(libValue,3)
	s libUnitExt = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libUnit)),3)
	
	s ingredientCodeId = ##class(web.DHCCKBCommon).GetIngredientCode()
	s ingredientMeteId = ##class(web.DHCCKBCommon).GetIngredientMete()
	s ingredientUnitId = ##class(web.DHCCKBCommon).GetIngredientUnit()
	s list = ingredientCodeId_"^"_ingredientMeteId_"^"_ingredientUnitId
	
	s outputIngr=""
	s existFlag=0
	s sumIngrDose=0
	s itmList=$g(TmpArr("Drug"))
	f k=1:1:$listlength(itmList)  q:existFlag=1   d
	.s itmid=$list(itmList,k)
	.//s TmpArr("CheckDicID")=itmid
	.q:+itmid=0
	.s checkItmId=$p(itmid,$c(2),1)
	.k GrenArr
	.for i=1:1:3  d
	..s ingredId = $p(list,"^",i)
	..s attrId = ""
	..for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",checkItmId,ingredId,attrId))  Q:attrId=""  d
	...s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	...s result = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5)
	...s resVal = ""
	...i i=2  d 
	....s resVal = result
	...e  d
	....s:dicId'="" resVal = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	...s groupFlag = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	...i $d(GrenArr(groupFlag))  d
	....s GrenArr(groupFlag) = GrenArr(groupFlag)_"^"_resVal
	...e  d
	....s GrenArr(groupFlag) = dicId
	..
	.
	.s index = ""
	.for  s index = $o(GrenArr(index)) Q:index=""  d
	..s ingreList = GrenArr(index)
	..s ingreDesc = $p(ingreList,"^",1)
	..s ingreNum = $p(ingreList,"^",2)
	..s ingreUnit = $p(ingreList,"^",3)
	..s drugId = $o(GrenArr(index,""))
	..s linkItmID=..GetUnionItm(.TmpArr, unionCode)
	..q:linkItmID=""
	..q:##Class(web.DHCCKBCommonUtil).CompareBothList(ingreDesc,linkItmID)=0	// 找到成分累计量的成分
	..s outputIngr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ingreDesc)),3)
	..s ingreDosage = $s(ingreNum'="":ingreNum,1:TmpArr(propCode_$c(1)_itmid))
	..i $listvalid(ingreDosage)>0 s ingreDosage = $lts(ingreDosage)
	..s freqNum = $listtostring(TmpArr("DrugFreq.FreqFactorProp"_$c(1)_itmid))
	..i freqNum=""  s ingreSumDosage = ingreDosage
	..e  s ingreSumDosage = ingreDosage*freqNum
	..s ingreDosUnit = $s(((ingreNum'="")&&(ingreUnit'="")):ingreUnit,1:TmpArr(propCode_$c(1)_itmid,"Unit","Ext"))
	..i $listvalid(ingreDosUnit)>0 s ingreDosUnit = $lts(ingreDosUnit)
	..s fac = ##class(web.DHCCKBCommonUtil).GetUomChangeFacNew(ingreDosUnit,libUnitExt)	// his->lib
	..i fac="" s fac = ##class(web.DHCCKBCommonUtil).GetEqFactor(+itmid,ingreDosUnit,libUnitExt)
	..i fac="" s existFlag = 1
	..q:existFlag=1
	..s newingrDose = fac*ingreSumDosage
	..s sumIngrDose = sumIngrDose + newingrDose
	
	q:existFlag=1 -1
	
	s $list(TmpArr("IngrSumDosage"_$c(1)_TmpArr("CheckDicID"))) = sumIngrDose
	s $list(TmpArr("IngrSumDosage"_$c(1)_TmpArr("CheckDicID"),"Ext")) = sumIngrDose_libUnitExt
	s $list(TmpArr("IngrSumDosage"_$c(1)_TmpArr("CheckDicID"),"Unit")) = libUnit
	s $list(TmpArr("IngrSumDosage"_$c(1)_TmpArr("CheckDicID"),"Unit","Ext")) = libUnitExt
	
	s $list(TmpArr("IngrSumDosageExt")) = "重复成分:"_outputIngr
	//s $list(TmpArr("IngrSumDosageExt")) = "重复成分"_outputIngr_"给药剂量超过"_sumIngrDose_libUnitExt // 用于消息输出
	q ""
}

/// CreateDate: 	2022-05-05
/// Creator:		qunianpeng 
/// Descript: 		计算辅助用药个数(需要排除液体药品(溶媒溶液)个数(不计算限定药品本身))
/// Input:			
/// w ##Class(web.DHCCKBGetFormula).GetAuxDrugsNum()
ClassMethod GetAuxDrugsNum(TmpArr)
{
	n (TmpArr)
		
	s checkDicID=$g(TmpArr("CheckDicID"))
	s ruleType=$g(TmpArr("Action"))

	s drugNum = 0
	s itmList=$g(TmpArr("Drug"))
	f k=1:1:$listlength(itmList)  d
	.s itmid=$list(itmList,k)
	.q:+itmid=0
	.q:(itmid=checkDicID)	// 排除掉检测药品本身 
	.// 不是同组医嘱,不考虑
	.q:##Class(web.DHCCKBPassNew).ISGroup(checkDicID,itmid,.TmpArr)=0
	.s realItmId=$p(itmid,$c(2),1)	
	.s catList=##Class(web.DHCCKBCommon).GetPhCatAlone(realItmId,1)	//##Class(web.DHCCKBCommon).GetPhCat(RealItmId,1)
	.s catListExt=##Class(web.DHCCKBCommon).GetPhCatAlone(realItmId,0) //##Class(web.DHCCKBCommon).GetPhCat(RealItmId,0)
	.// 获取药品分类, 去掉溶媒类的药品
	.s catListExtLen=$ll(catListExt)
	.s catListExtStr=""
	.f j=1:1:catListExtLen  d
	..s catListExtStr=catListExtStr_"^"_$lg(catListExt,j)
	.q:catListExtStr["溶媒类"     //Shy 修改辅助用药类别判断 2022-5-24
	.s drugNum = drugNum + 1
	
	s $list(TmpArr("AuxDrugsNum"_$c(1)_TmpArr("CheckDicID"))) = drugNum

	q ""
}

/// CreateDate: 	2022-07-15
/// Creator:		qunianpeng 
/// Descript: 		计算联合用药个数((不计算限定药品本身))
/// Input:			
/// w ##Class(web.DHCCKBGetFormula).GetCombinaDrugsNum()
ClassMethod GetCombinaDrugsNum(TmpArr)
{
	n (TmpArr)
	
	s checkDicID=$g(TmpArr("CheckDicID"))
	s ruleType=$g(TmpArr("Action"))
	
	s drugNum = 0
	s itmList=$g(TmpArr("Drug"))
	f k=1:1:$listlength(itmList)  d
	.s itmid=$list(itmList,k)
	.q:+itmid=0
	.q:(itmid=checkDicID)	// 排除掉检测药品本身 
	.// 不是同组医嘱,不考虑
	.q:##Class(web.DHCCKBPassNew).ISGroup(checkDicID,itmid,.TmpArr)=0
	.s realItmId=$p(itmid,$c(2),1)	
	.s drugNum = drugNum + 1

	s $list(TmpArr("CombinationDrugsNum"_$c(1)_TmpArr("CheckDicID"))) = drugNum

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-08-23
/// Descript: 		获取联合节点中的项目，如溶媒药品、检验项目
/// w ##Class(web.DHCCKBGetFormula).GetUnionValueByCode("","")
ClassMethod GetUnionItmByNode(Node, UnionCode) As %String
{
	n (Node, UnionCode)
	s ItemList=""
	s NewID="" 		// Union:{溶媒:药品1，浓度：10mg/ml}
	f  s NewID=$o(^CT.CKB.PDSS.RuleDataI("Node",Node,NewID))	q:NewID=""  d
	.s LeftID=$lg($g(^CT.CKB.PDSS.RuleDataD(NewID)),4)      					/// 关系指针(左)
	.i LeftID'="" s LeftDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftID)),2)   	/// 相关实体代码
	.q:$g(LeftDicCode)'=UnionCode
	.s CheckDicID=$lg($g(^CT.CKB.PDSS.RuleDataD(NewID)),8)
	.q:CheckDicID=""
	.s $list(ItemList,*+1)=CheckDicID
	.
	q ItemList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-08-23
/// Descript: 		用当前节点向上找到第一个union节点
/// w ##Class(web.DHCCKBGetFormula).GetUpUnionNode(4091378)
ClassMethod GetUpUnionNode(node) As %String
{
	s parentNode = $lg($g(^CT.CKB.PDSS.RuleNodeD(+node)),2)
	s cond = $lg($g(^CT.CKB.PDSS.RuleNodeD(+node)),3)
	q:(+parentNode=0)||(cond="union") node
	s newNode = ..GetUpUnionNode(parentNode)

	q newNode
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-11-08
/// Descript: 		获取所有药品名称列表
/// w ##Class(web.DHCCKBGetFormula).GetAllDrugName("","")
ClassMethod GetAllDrugName(TmpArr) As %String
{
	n (TmpArr)
	
	s drugList = $g(TmpArr("Drug"))
	q:drugList="" ""
	q:$listvalid(drugList)'=1 ""
	
	s listData = ""
	f i=1:1:$ll(drugList)  d
	.s drugstr = $lg(drugList,i)
	.s drug = $p(drugstr,$c(2),1)	
	.q:$lf(listData,drug)>0
	.s $list(listData,*+1)=drug
		
	q listData
}

}

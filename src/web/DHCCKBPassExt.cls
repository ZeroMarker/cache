/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-12
/// Descript: 		安全用药智能决策系统函数扩展类
Class web.DHCCKBPassExt Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		获取药品过敏相关的属性值
/// Input:			药品id
/// w ##Class(web.DHCCKBPassExt).GetHisAllergyForDrug(DicID)
ClassMethod GetHisAllergyForDrug(DicID)
{
	n (DicID)
	q:+DicID=0 ""
	s RetStr=""
	// His过敏源是医嘱项字典,对医嘱项过敏,则对该医嘱项的通用名/带剂型的通用名/商品名/分类/成分/辅料过敏
  	
  	// 对医嘱项过敏,对带剂型的通用名也过敏
  	s ItmGenerFrom=##class(web.DHCCKBCommon).GetGeneralFrom(DicID,1)	
	s ItmGenerFromExt=##class(web.DHCCKBCommon).GetGeneralFrom(DicID,0)
	s:ItmGenerFrom'="" RetStr=$case(RetStr="",1:$listtostring(ItmGenerFrom,"^"),:RetStr_"^"_$listtostring(ItmGenerFrom,"^"))
	s:ItmGenerFromExt'="" RetStr=$case(RetStr="",1:$listtostring(ItmGenerFromExt,"^"),:RetStr_"^"_$listtostring(ItmGenerFromExt,"^"))
	
	// 对医嘱项过敏,对通用名过敏
	s ItmGenerDic=##class(web.DHCCKBCommon).GetGeneralName(DicID,1)
	s ItmGenerDicExt=##class(web.DHCCKBCommon).GetGeneralName(DicID,0)
	s:ItmGenerDic'="" RetStr=$case(RetStr="",1:$listtostring(ItmGenerDic,"^"),:RetStr_"^"_$listtostring(ItmGenerDic,"^"))
	s:ItmGenerDicExt'="" RetStr=$case(RetStr="",1:$listtostring(ItmGenerDic,"^"),:RetStr_"^"_$listtostring(ItmGenerDicExt,"^"))
	
	// 对医嘱项过敏,对商品名也过敏
	s ItmProName=##class(web.DHCCKBCommon).GetProName(DicID,1)		
	s ItmProNameExt=##class(web.DHCCKBCommon).GetProName(DicID,0)
	s:ItmProName'="" RetStr=$case(RetStr="",1:$listtostring(ItmProName,"^"),:RetStr_"^"_$listtostring(ItmProName,"^"))
	s:ItmProNameExt'="" RetStr=$case(RetStr="",1:$listtostring(ItmProNameExt,"^"),:RetStr_"^"_$listtostring(ItmProNameExt,"^"))
	
	// 对医嘱项过敏,对成分也过敏
	s ItmIngr=##class(web.DHCCKBCommon).GetIngredient(DicID,1)		
	s ItmIngrExt=##class(web.DHCCKBCommon).GetIngredient(DicID,0)
	s:ItmIngr'="" RetStr=$case(RetStr="",1:$listtostring(ItmIngr,"^"),:RetStr_"^"_$listtostring(ItmIngr,"^"))
	s:ItmIngrExt'="" RetStr=$case(RetStr="",1:$listtostring(ItmIngrExt,"^"),:RetStr_"^"_$listtostring(ItmIngrExt,"^"))
	
	// 对医嘱项过敏,对辅料也过敏
	s Excipient=##Class(web.DHCCKBCommon).GetExcipient(DicID,1)		
	s ExcipientExt=##Class(web.DHCCKBCommon).GetExcipient(DicID,0)
	s:Excipient'="" RetStr=$case(RetStr="",1:$listtostring(Excipient,"^"),:RetStr_"^"_$listtostring(Excipient,"^"))
	s:ExcipientExt'="" RetStr=$case(RetStr="",1:$listtostring(ExcipientExt,"^"),:RetStr_"^"_$listtostring(ExcipientExt,"^"))
	
	// 对医嘱项过敏,对分类也过敏
	s ItmSupCat=##Class(web.DHCCKBCommon).GetPhCat(DicID,1) 			
	s ItmSupCatExt=##Class(web.DHCCKBCommon).GetPhCat(DicID,0)
	s:ItmSupCat'="" RetStr=$case(RetStr="",1:$listtostring(ItmSupCat,"^"),:RetStr_"^"_$listtostring(ItmSupCat,"^"))
	s:ItmSupCatExt'="" RetStr=$case(RetStr="",1:$listtostring(ItmSupCat,"^"),:RetStr_"^"_$listtostring(ItmSupCatExt,"^"))
	
	q RetStr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		获取过敏源的二级转换关系（交叉）（如：通用名<>成分 ）
/// Input:			药品id
/// w ##Class(web.DHCCKBPassExt).GetHisAllergyCommon(3910,"ProNameProp")
ClassMethod GetHisAllergyCommon(DicID, Prop)
{
	n (DicID,Prop)
	
	// His过敏源和知识库中的过敏,交叉
	// 如：His过敏源是带剂型的通用名字典,对带剂型的通用名过敏,则对该通用名的医嘱项对应的通用名/商品名/分类/成分/辅料过敏
	q:Prop="" ""
	s RetStr=""
	s PropId=##class(web.DHCCKBCommon).GetDicIdByCode(Prop)
  	s ItmDrug="",ItmDrugExt="" 		
	s ItmDrug=##Class(web.DHCCKBCommon).GetCommonDrugListByProp(PropId,DicID,1)
	s ItmDrugExt=##Class(web.DHCCKBCommon).GetCommonDrugListByProp(PropId,DicID,0)
	s:ItmDrug'="" RetStr=$listtostring(ItmDrug,"^")
	s:ItmDrugExt'="" RetStr=$case(RetStr="",1:listtostring(ItmDrugExt,"^"),:RetStr_"^"_$listtostring(ItmDrugExt,"^"))

	s PropList=$lb("DrugCategory","GenerNameFormProp","GenerNameProp","ProNameProp","Ingredient","ExcipientProp")
	
	s Type="HisAllergy"
	
	f Index=1:1:$listlength(PropList)  d
	.s TmpProp=$listget(PropList,Index)
	.q:TmpProp=Prop
	.s ItmList=##Class(web.DHCCKBConfig).ChangeItmFromStore(Type,Prop,DicID,TmpProp)
	.i ItmList'=""  d
	..i RetStr="" s RetStr=$listtostring(ItmList,"^")
	..e  s RetStr=RetStr_"^"_$listtostring(ItmList,"^")
	
	q RetStr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-26
/// Descript: 		判断计算项目是否是前提条件
/// Input:			药品id
/// OutPut:			1 是, 0 不是
/// w ##Class(web.DHCCKBPassExt).IsPreConditions(91,RuleID)
ClassMethod IsPreConditions(CalcItm, RuleID)
{
	n (CalcItm,RuleID)	
	
	s Libary=0
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s GlobalData = ##class(web.DHCCKBCommon).GetGlobalData()
	
	//判断规则中是否有目录
	s Dic="" 
	f  s Dic=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",RuleID,Dic)) q:Dic=""  d
	.s DicParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(Dic)),4)
	.s:DicParef=DrugLibary Libary=Dic
	.s:DicParef=GlobalData Libary=Dic

	q:(+Libary=0)||(+CalcItm=0)||(+RuleID=0) 0 
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Libary,+CalcItm)) 0

	s QuitFlag=0
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Libary,+CalcItm,LinkID)) q:LinkID=""  d	// 前提条件好像存储的不对 03/05
	.q:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)'="Y"
	.s Attr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:+Attr=0
	.q:Attr'=##class(web.DHCCKBCommon).GetPreconditions()	//前提条件
	.s QuitFlag=1
	
	q QuitFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		通过公式,设置his不传入参数,但是知识库有判断的项目值,如分类,成分,每日最大量等
/// Input:			药品id
/// w ##Class(web.DHCCKBPassExt).InitValueComplex("","kg/ml","")
ClassMethod InitValueComplex(TmpArr = "", Key = "", ID = "")
{
	n (TmpArr, Key,ID)
	q:ID="" ""
	s existFlag = 0 // 日剂量(2023-05-19 增加日剂量, his端的日剂量根据频次可设置每次剂量, 不在等于频次*单次剂量)
	s DayDoseList = $lb("DayDose","DayDoseMax","DayDoseLimit","DayAbsurdValue")
	i $lf(DayDoseList,Key)>0 d
	.s CalcItm=$g(TmpArr("CalcItm"))
	.s DayDose = TmpArr("DayDose"_$c(1)_CalcItm)
	.s DayDoseUnit = TmpArr("DayDose"_$c(1)_CalcItm)
	.i $listvalid(DayDose)=1 s DayDose=$lts(DayDose)	
	.i DayDose'="" d 
	..s TmpArr(Key_$c(1)_CalcItm)=TmpArr("DayDose"_$c(1)_CalcItm)
	..s TmpArr(Key_$c(1)_CalcItm,"Ext")=TmpArr("DayDose"_$c(1)_CalcItm,"Ext")
	..s TmpArr(Key_$c(1)_CalcItm,"Unit")= TmpArr("DayDose"_$c(1)_CalcItm,"Unit")
	..s TmpArr(Key_$c(1)_CalcItm,"Unit","Ext")=TmpArr("DayDose"_$c(1)_CalcItm,"Unit","Ext")	
	..s existFlag=1	
	q:existFlag=1 ""
	
	q:..ExistComplex(Key)=0 ""	// 没有表达式
	k TmpArr("UnionItm")
	s Value=##Class(web.DHCCKBComplexArith).CalcExpression(Key,.TmpArr)
	k:Value="" TmpArr("UnionItm")
	//q:(Value="")||(Value=0) ""
	q:(Value="") ""
	s RightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),10)
	if (RightType="Constant")||(RightType="Input")  d	// 数据集/输入值
	.d ..SetConstantExtValue(.TmpArr, Key, Value)
		
	else  if (RightType="InputUom")||(RightType="InputLimit") d // 带单位的输入值 / 区间,带单位	
	.d ..SetInputExtValue(.TmpArr, Key, Value)	

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		过滤掉不需要计算的项目
/// Input:			药品
/// w ##Class(web.DHCCKBPassExt).QuitNotCalcItm("","OnceDoseMax")
ClassMethod QuitNotCalcItm(CalcItm = "", ID = "") As %String
{
	n (CalcItm,ID)
	
	q:(CalcItm="TogetherProp")||(CalcItm="TipsAtOnceProp") -100
	s TmpLabValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)
	s TmpLabValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(+TmpLabValue)),3)
	q:(CalcItm="LabItm")&((TmpLabValue["内生肌酐清除率")||(TmpLabValue["肌酐清除率")) -100 //肌酐清除率不计算
	
	q 1
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		判断属性是否存在公式
/// Input:			属性代码
/// Return:			1 有公式  0 没有公式
/// w ##Class(web.DHCCKBPassExt).ExistComplex()
ClassMethod ExistComplex(CalcItm) As %String
{
	n (CalcItm)
	
	q 1
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		获取入参中his的值
/// Input:		
/// Return:		
/// w ##Class(web.DHCCKBPassExt).GetHisValue()
ClassMethod GetHisValue(TmpArr, LeftKey, LibValue = "") As %String
{
	n (TmpArr,LeftKey,LibValue)
	
	s ID=$g(TmpArr("ID"))
	s RightType=$lg($g(^CT.CKB.PDSS.RuleDataD(+ID)),10)
	s:ID=0 RightType="InputUom"
	s HisValue=$g(TmpArr(LeftKey))	
	s CheckDicID=$g(TmpArr("CheckDicID"))
	q:(HisValue="")||(HisValue=0) ""
	q:$case($listvalid(HisValue)=0,1:"",:$listget(HisValue))="" ""
	
	s ExistFlag=0,IsAudit="Y"
	i (RightType="InputUom")||(RightType="InputLimit")	d // 区间,带单位 
	.s HisUom=($g(TmpArr(LeftKey,"Unit")))				  // 如果含单位的计算，需要取出his值的单位
	.s:$listvalid(HisUom)=1 HisUom=$listtostring(HisUom)
	.s HisUomExt=($g(TmpArr(LeftKey,"Unit","Ext")))
	.s:$listvalid(HisUomExt)=1 HisUomExt=$listtostring(HisUomExt)
	.// 用药频率特殊转换
	.i LeftKey["DrugFreq"	d	
	..s FreqValue=##class(web.DHCCKBPassNew).GetFreqFacUom($listtostring($g(TmpArr(LeftKey,"Ext"))))
	..q:FreqValue=""
	..s HisValue=$listget(FreqValue,1)
	..s HisUom=$listget(FreqValue,2)
	..s HisUomExt=$listget(FreqValue,3)
	.
	.// 判断单位是否需要转换
	.s:(HisUom="")&(HisUomExt="") ExistFlag=1
	.s newLibValue=$list(LibValue,1)
	.s:newLibValue="" ExistFlag=1
	.s LibUom=$list(LibValue,3)
	.s:LibUom="" ExistFlag=1
	.s:$listValid(LibUom) LibUom=$lg(LibUom)
	.q:ExistFlag=1
	.s LibUomExt=##class(web.DHCCKBCommon).GetDicSecondName(LibUom)
	.s IsChangeFlag=##class(web.DHCCKBPassNew).CompareConstant(HisUom,HisUomExt,LibUom,LibUomExt)
	.s Fac=""							// 需要判断单位转换
	.i IsChangeFlag=0 d	// HisUom是对照后的知识库id,先用知识库的描述找系数,找不到的情况下再用his描述找系数 2020/07/22 （μg知识库->UGC处方）
	..s Fac=##class(web.DHCCKBCommonUtil).GetFactorToLib($lg($g(^CT.CKB.PDSS.CommonDictionD(+HisUom)),3),$lg($g(^CT.CKB.PDSS.CommonDictionD(LibUom)),3),+CheckDicID)
	..s:Fac="" Fac=##class(web.DHCCKBCommonUtil).GetFactorToLib(HisUomExt,$lg($g(^CT.CKB.PDSS.CommonDictionD(LibUom)),3),+CheckDicID)
	.s:(IsChangeFlag=0)&(Fac="") ExistFlag=1 /// 单位转换不成功
	.q:ExistFlag=1
	.s:Fac'="" HisValue=$case($listvalid(HisValue),1:$listtostring(HisValue)*Fac,0:HisValue*Fac)
	.s:HisValue'="" HisValue=$case($listvalid(HisValue),1:$decimal($listtostring(HisValue),6),:$decimal(HisValue,6))
	.s HisValue=$lb(HisValue,HisUom,HisUomExt)
	q $case(ExistFlag,0:HisValue,1:"",:"")	// 转换成功则返回HisValue,不成功给则返回0
}

/// 设置数据集的ext
ClassMethod SetConstantExtValue(TmpArr, Key, Value)
{
	n (TmpArr,Key,Value)
	
	s:$listvalid(Value)'=0 Value=$listtostring(Value)
	// 根据标志确定，是取当前药品的属性值，还是关联药品的值。 如：药品的计量，  溶媒药品的计量
	s RealCalcItm = $case($d(TmpArr("UnionItm"))>0,1:$g(TmpArr("UnionItm")),:$g(TmpArr("CalcItm")))
	s CalcItm=$g(TmpArr("CalcItm"))
	q:(CalcItm="")||(RealCalcItm="") ""
		
	//s TmpArr(Key_$c(1)_CalcItm)=$lb(Value) 
	s TmpArr(Key_$c(1)_CalcItm)=$lfs(Value)
	//s TmpArr(Key_$c(1)_CalcItm,"Ext")=$lb(Value_LinkUnitExt)
	
	k TmpArr("UnionItm")	// 及时清除掉记录的联合节点值，防止影响其他公式取值
	
	q ""
}

/// 设置单位的ext
ClassMethod SetInputExtValue(TmpArr, Key, Value)
{
	n (TmpArr,Key,Value)	
	
	s:$listvalid(Value)'=0 Value=$listtostring(Value)
	// 根据标志确定，是取当前药品的属性值，还是关联药品的值。 如：药品的计量，  溶媒药品的计量
	s RealCalcItm = $case($d(TmpArr("UnionItm"))>0,1:$g(TmpArr("UnionItm")),:$g(TmpArr("CalcItm")))
	s CalcItm=$g(TmpArr("CalcItm"))
	k:(CalcItm="")||(RealCalcItm="") TmpArr("UnionItm")
	q:(CalcItm="")||(RealCalcItm="") ""
	
	s LinkKey=$g(TmpArr("LinkKey"))
	s LinkUnit="",LinkUnitExt=""	
	i (LinkKey'="")&($d(TmpArr(LinkKey_$c(1)_RealCalcItm,"Unit"))) d	 // 公式依赖某个因子，则找到需要依赖的这个因子：如每日最大量依赖单次剂量
	.s LinkUnit=$g(TmpArr(LinkKey_$c(1)_RealCalcItm,"Unit"))
	.s:$listvalid(LinkUnit)'=0 LinkUnit=$listtostring(LinkUnit)
	.s LinkUnitExt=$g(TmpArr(LinkKey_$c(1)_RealCalcItm,"Unit","Ext"))
	.s:$listvalid(LinkUnitExt)'=0 LinkUnitExt=$listtostring(LinkUnitExt)

	s TmpArr(Key_$c(1)_CalcItm)=$lb(Value) 
	s TmpArr(Key_$c(1)_CalcItm,"Ext")=$lb($fn(Value,"N")_LinkUnitExt)
	s TmpArr(Key_$c(1)_CalcItm,"Unit")=$lb(LinkUnit)
	s TmpArr(Key_$c(1)_CalcItm,"Unit","Ext")=$lb(LinkUnitExt)
	
	i (Key="SolutionDensity")||(Key="SolventDensity") d // qnp 2022-04-12
	.q:'$d(TmpArr(LinkKey_$c(1)_CalcItm,"Unit","Ext"))
	.s UnitDesc = $lg(TmpArr(LinkKey_$c(1)_CalcItm,"Unit","Ext"))_"/"_LinkUnitExt
	.s UnitId = ##class(web.DHCCKBCommon).GetDicIdByCode(UnitDesc)	
	.s TmpArr(Key_$c(1)_CalcItm,"Ext")=$lb($fn(Value,"N")_UnitDesc)
	.s TmpArr(Key_$c(1)_CalcItm,"Unit")=$lb(UnitId)
	.s TmpArr(Key_$c(1)_CalcItm,"Unit","Ext")=$lb(UnitDesc)
	
	i (Key="IngredientDensity") d // qnp 2022-04-12
	.s TmpArr(Key_$c(1)_CalcItm)=$lb(Value) 
	.s ID = $g(TmpArr("ID"))
	.s UnitID = $lg($g(^CT.CKB.PDSS.RuleDataD(+ID)),11)
	.s UnitDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(UnitID)),3)
	.s TmpArr(Key_$c(1)_CalcItm,"Ext")=$lb($fn(Value,"N")_UnitDesc)
	.s TmpArr(Key_$c(1)_CalcItm,"Unit")=$lb(UnitID)
	.s TmpArr(Key_$c(1)_CalcItm,"Unit","Ext")=$lb(UnitDesc)
	
	k TmpArr("UnionItm")	// 及时清除掉记录的联合节点值，防止影响其他公式取值
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-12-11
/// Descript: 		相似作用判断(一组(分类)药品中,只能使用一个)
/// Input:			需要判断相似作用的分类,
/// w ##Class(web.DHCCKBPassExt).CheckSimilarEffect()
ClassMethod CheckSimilarEffect(itmid, TmpArr, TmpMsgArr)
{
	n (itmid,TmpArr,TmpMsgArr)
	
	s ruleType=$g(TmpArr("Action"))	
	q:ruleType'="CheckRule" ""
	s labelDesc="辅助用药"

	// 遍历药品,找到药品的分类, 观察药品的分类相同数是否大于1,大于1则提醒
	s catId =##class(web.DHCCKBCommon).GetDicIdByDesc("活血化瘀类中成药辅助用药")
	if catId=""  s catId =##class(web.DHCCKBCommon).GetDicIdByDesc("活血化瘀中成药辅助用药组")
	s catList = $lb(catId)
	k TmpCatArr
	s itmList=$g(TmpArr("Drug"))
	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.q:+tmpItmid=0
	.s drugId = $p(tmpItmid,$c(2),1)	// 
	.s drugCat = ##Class(web.DHCCKBCommon).GetAlonePhCat(drugId,1)
	.s mixList = ##Class(web.DHCCKBCommonUtil).GetMixList(drugCat,catList)	
	.q:$listlength(mixList)=0	// 不在相似作用的分类组里面
	.s len = $listlength(mixList)
	.f k=1:1:len  d
	..s itmCat = $lg(mixList,k)
	..s $list(TmpCatArr(itmCat),*+1) = tmpItmid	// 记录相同分类下的药品,用于输出提示信息时,一组药只输出一次
	..s $list(TmpCatArr(itmCat,"Name"),*+1) = $listtostring($g(TmpArr("Drug",tmpItmid)))
	
	s itmList=$g(TmpArr("Drug"))	// 每一个药品上都要提示出来相似作用(薛-2020/12/11)
	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.//q:tmpItmid=itmid
	.s cat = ""
	.f  s cat=$o(TmpCatArr(cat))  q:cat=""  d
	..s catName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+cat)),3)
	..s drugList = $g(TmpCatArr(cat))
	..q:($listlength(drugList)=1)&($lg(drugList)=tmpItmid)
	..s drugNameList = $g(TmpCatArr(cat,"Name"))
	..s drugName = $listtostring($g(TmpArr("Drug",tmpItmid)))
	..s index = $lf(drugNameList,drugName)
	..s $list(drugNameList,index,index)=""	// 删除本身的药品
	..q:$listfind(drugList,tmpItmid)=0
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid)=$lb(0,"NotPass","warn","与"_$listtostring(drugNameList,",")_"相似作用"_","_catName_"(1组)"_"只能使用(1个)","","","","Y")
	..//s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_$listtostring(drugNameList,",")_"相似作用"_","_catName_"(1组)"_"只能使用(1个)"
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_$listtostring(drugNameList,",")_"相似作用"_","_catName_"(1组)"_"只能使用(1个)"
	..s TmpMsgArr("PreCondtions",tmpItmid)=$lb("NULL")	//前提条件
	// 	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-01-11
/// Descript: 		遍历忽略配置表,判断目录/项目是否审查
/// Input:			药品id,
/// OutPut:			1忽略 0 不忽略
/// w ##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,222,75,"D")
ClassMethod IsIgnoreItm(TmpArr, dicID, item, itemFlag)
{
	n (TmpArr, dicID, item, itemFlag)

	s ret = 0
	s checkItmID=dicID
	i checkItmID="" s checkItmID = $g(TmpArr("CheckDicID")) 
	s ignoreList = ""
	i itemFlag="D" d
	.s ignoreList = $g(TmpArr("InitIgnore","D",checkItmID)) // 忽略目录
	e  i itemFlag="I" d
	.s ignoreList = $g(TmpArr("InitIgnore","I",checkItmID))	// 忽略项目
	
	q:$lf(ignoreList,item)'=0 1

	q ret  // 2022-06-21 使用忽略配置数据池
	
	// 遍历忽略配置表,找到字典类型
	s exitFlag = 0
	//^DHCCKBREMAN(0,"Type",{RM_Type},{RM_Value},{RM_RowID})
	s type = ""
	f  s type = $o(^CF.CKB.PDSS.IgnoreManageI("TypeValue",type))  q:(type="")||(exitFlag=1)  d
	.i (type="DrugFreqData")||(type="DrugPreMetData") d
	..s exitFlag= ..IngnoreHisItm(.TmpArr,type,item,itemFlag) // 给药途径和用药频率需要从入参中取值判断20220221 qunianpeng
	.
	.q:exitFlag=1
	.s propValueList = ""
	.i (type'="DrugData")&&(type'="ChineseDrugData")&&(type'="ChineseHerbalMedicineData") d	// 如果是药品本身,则没有属性值
	..s propList = ##class(web.DHCCKBIgnoreManage).GetPropByDataSource(type)	// 通过字典类型找到属性id集合
	..// 根据属性集合进行取属性值
	..s len = $listlength(propList)	
	..f i=1:1:len  d
	...s prop = $list(propList,i)
	...s valueList = ##class(web.DHCCKBCommonCom).GetSysPropDataValue(dicID,prop)	// 通过属性取属性值list
	...s propValueList = ##class(web.DHCCKBCommonUtil).GetUnionList(valueList,propValueList)
	.e  d
	..s propValueList = $lb(dicID) // 如果是药品本身,则没有属性值,将药品id作为属性值替位
	..
	.// 判断取到的属性值是否属于当前字典类型	
	.f k = 1:1:$listlength(propValueList)  d 
	..s propValue = $list(propValueList,k)
	..s parref = ##class(web.DHCCKBCommon).GetParref(propValue)
	..s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	..//i type'=parref s $list(propValueList,k,k)=""	// 在当前list中清除掉不是当前字典类型下的数据	
	..i type'=parrefCode s $list(propValueList,k)=""	// 在当前list中清除掉不是当前字典类型下的数据	
	.
	.// 判断忽略属性值是否在属性list中
	.s value = "" //^DHCCKBREMAN(0,"ItemFlag",{RM_Type},{RM_Value},{RM_Item},{RM_Flag},{RM_RowID})
	.f  s value =$o(^CF.CKB.PDSS.IgnoreManageI("TypeValue",type,value))  q:(value="")||(exitFlag=1)  d	
	..q:$listfind(propValueList,value)=0
	..i $d(^CF.CKB.PDSS.IgnoreManageI("ItemFlag",type,value,item,itemFlag)) d
	...s exitFlag = 1

	q exitFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-01-11
/// Descript: 		带量采购药品判断提示
/// Input:			
/// w ##Class(web.DHCCKBPassExt).IsIgnoreItm(TmpArr,152,73,"D") //VolPurchProp
ClassMethod CheckVolPurch(checkItmID, TmpArr, TmpMsgArr)
{
	n (checkItmID,TmpArr,TmpMsgArr)
	s ruleType=$g(TmpArr("Action"))	
	s TmpArr("CalcItm")=checkItmID
	q:ruleType'="CheckRule" ""
	s userInfo = $g(TmpArr("UserInfo"))
	s hospitalId=$p(userInfo,"^",5)		
	s hospitalId=##class(web.DHCCKBCommon).GetHospIdByDesc(hospitalId)
	s realItmId = $p(checkItmID,$c(2),1)
	// 判断是否已经是带量采购的药品
	s isVolPurchFlag = ..IsVolPurchFlag(realItmId)
	q:isVolPurchFlag=1 ""	
	// 判断当前的药品是否关联在带量采购同类药品下
	;s catList = ##Class(web.DHCCKBCommon).GetPhCatWithParent(realItmId,1)
	;s volSimilarCat = ##class(web.DHCCKBCommon).GetVolSimilarCat()	// 带量采购药品分类
	;q:$listfind(catList,volSimilarCat)=0 ""

	;s exitFlag = 0
	;s volCat = ""
	;s linkCatList = ##class(web.DHCCKBCommon).GetPhCatAlone(realItmId,1)
	;f i =1:1:$listlength(linkCatList)  q:exitFlag=1  d
	;.s cat = $list(linkCatList,i)
	;.s tmpList = ""
	;.s parrefCatList = ##Class(web.DHCCKBCommon).GetParentCat(.tmpList,cat,1)
	;.i $listfind(tmpList,volSimilarCat)'= 0 s exitFlag = 1,volCat = cat
	;q:volCat="" ""
	// 在当前的带量采购药品分类下,找到替换的药品	
	s drugArr = []
	s exitFlag = 0
	;s replaceDrugList=##Class(web.DHCCKBCommon).GetDrugListByCat(volCat,1)
	s generIdList = ##class(web.DHCCKBCommon).GetGeneralFrom(realItmId,1)
	//取相同通用名的其他药物
	s replaceDrugList=##Class(web.DHCCKBCommon).GetDrugListByGenName(generIdList,hospitalId)
	Q:$listlength(replaceDrugList)<1 ""
	s drugStr = ""
	f i =1:1:$listlength(replaceDrugList)  d
	.s drugId = $list(replaceDrugList,i)
	.q:drugId=realItmId
	.q:..IsVolPurchFlag(drugId)=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(drugId))
	.s drugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	.s:drugName'="" drugName=drugName_"(带量采购)"
	.i drugName'="" d drugArr.%Push(drugName)
	.i drugStr="" s drugStr = drugName
	.e  s drugStr  = drugStr_","_drugName
	.s exitFlag = 1
	q:exitFlag=0 "" // 没有替换的药品
	s LabelDesc="带量采购"  // 是否需要增加一个目录
	//s LabelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(LabelDesc) //##class(web.DHCCKBCommon).GetDrugLibaryData())

	s TmpMsgArr("itemOrder",checkItmID,LabelDesc,checkItmID)=$lb(0,"NotPass","tips","当前药品不在带量采购范围,请使用推荐药品列表中的药物","","","","Y")
	//s TmpMsgArr("itemOrder",checkItmID,LabelDesc,checkItmID,checkItmID)="VolPurchProp"_"@@"_"当前药品不在带量采购范围,可以使用"_drugStr_"替换"
	s TmpMsgArr("itemOrder",checkItmID,LabelDesc,checkItmID,checkItmID)="VolPurchProp"_"@@"_"当前药品不在带量采购范围,请使用推荐药品列表中的药物"
	i drugArr.%Size()'=0 s TmpMsgArr("adviceDrug",checkItmID)=drugArr	// 推荐药品列表
	s TmpMsgArr("PreCondtions",checkItmID)=$lb("NULL")	//前提条件
	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")


	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-01-11
/// Descript: 		判断药品是否维护带药批量采购标记
/// Input:			1 是，0 否
/// w ##Class(web.DHCCKBPassExt).IsVolPurchFlag() //VolPurchProp
ClassMethod IsVolPurchFlag(itmId)
{
	
	n (itmId)
	// 判断是否已经是带量采购的药品
	s volpurchPropList = ##class(web.DHCCKBCommon).GetVolPurchProp()
	s exitFlag = 0
	f i =1:1:$listlength(volpurchPropList) q:exitFlag=1  d
	.s volpurchProp = $list(volpurchPropList,i)
	.s isVolPurchFlag = ##class(web.DHCCKBDrugVO).GetDicValueByPro(itmId,volpurchProp)
	.i isVolPurchFlag="Y" s exitFlag = 1
	
	q exitFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-01-11
/// Descript: 		同类重复的判断
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CheckSimilarRepeat(TmpArr,152,73,"D") //VolPurchProp
ClassMethod CheckSimilarRepeat(checkItmID, TmpArr, TmpMsgArr)
{
	n (checkItmID,TmpArr,TmpMsgArr)
	s ruleType=$g(TmpArr("Action"))	

	s TmpArr("CalcItm")=checkItmID
	q:ruleType'="CheckRule" ""
	
	s similarRepeatCatId = ##class(web.DHCCKBCommon).GetSimilarRepeat()	// 同类重复	
	s checkDicCatList = ##Class(web.DHCCKBCommon).GetPhCatAlone(+checkItmID,1)	

	//s realItmId = $p(checkItmID,$c(2),1)
	// 遍历所有的药品,获取药品的分类,判断药品的分类是否在同类重复的分类下,是则记录该药品提醒,否则通过
	s linkDrugList="",count = 0
	s itmList = $g(TmpArr("Drug"))
	f i=1:1:$listlength(itmList) d
	.s itmid = $list(itmList,i)
	.q:(itmid=checkItmID)	// 排除掉检测药品本身 
	.q:$d(TmpArr("CheckSimilarRepeat",checkItmID,itmid))
	.q:$d(TmpArr("CheckSimilarRepeat",itmid,checkItmID))
	.s realItmId = $p(itmid,$c(2),1)
	.q:realItmId=+checkItmID
	.s itmCatList=##Class(web.DHCCKBCommon).GetPhCatAlone(realItmId,1)	//##Class(web.DHCCKBCommon).GetPhCat(RealItmId,1)
	.s mixList = ##Class(web.DHCCKBCommonUtil).GetMixList(itmCatList,checkDicCatList) // 找到两个list的交集
	.q:$listlength(mixList)=0
	.s mixParrefList = ""
	.f k=1:1:$listLength(mixList)  d
	..s tmpCat = $list(mixList,k)
	..d ##Class(web.DHCCKBCommon).GetParentCat(.mixParrefList,tmpCat,1)	// 获取交集的父分类
	..s tmpRowID = ""
	..//f  s tmpRowID = $o(^CT.CKB.PDSS.CommonDictionI("Link",tmpCat,tmpRowID))  q:tmpRowID=""  d //在同类重复的分类树中展示的是新增的空记录,关联表中存的是link
	..//.d ##Class(web.DHCCKBCommon).GetParentCat(.mixParrefList,tmpRowID,1) // 2021/7/14 取消	同类重复的分类树中展示的是认为是新增
	..//.
	.
	.q:$listfind(mixParrefList,similarRepeatCatId)=0	// 不在同类重复下
	.s $list(linkDrugList,*+1) = $listtostring($g(TmpArr("Drug",itmid)))
	.s TmpArr("CheckSimilarRepeat",checkItmID,itmid)=""
	.s TmpArr("CheckSimilarRepeat",itmid,checkItmID)=""	// 记录重复的药品
	.s count = count + 1 // 找到同类的药品,则计数器加1

	q:$listlength(linkDrugList)=0 ""
	q:count=0 ""
	s labelDesc = "重复用药"
	s TmpMsgArr("itemOrder",checkItmID,labelDesc,checkItmID)=$lb(0,"NotPass","warn","当前药品与"_$listtostring(linkDrugList)_"重复","","","","Y")
	s TmpMsgArr("itemOrder",checkItmID,labelDesc,checkItmID,checkItmID)="DrugCategory"_"@@"_"当前药品与"_$listtostring(linkDrugList)_"重复(同类)"
	s TmpMsgArr("PreCondtions",checkItmID)=$lb("NULL")	//前提条件
	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-01-11
/// Descript: 		异类重复的判断
/// Input:			
/// Other:			异类重复分类的维护层级固定为3层.[异类重复->分组->具体分类]
/// w ##Class(web.DHCCKBPassExt).CheckDifferentRepeat(TmpArr,152,73,"D") //VolPurchProp
ClassMethod CheckDifferentRepeat(checkItmID, TmpArr, TmpMsgArr)
{
	n (checkItmID,TmpArr,TmpMsgArr)
	s ruleType=$g(TmpArr("Action"))	

	s TmpArr("CalcItm")=checkItmID
	q:ruleType'="CheckRule" ""
	q:$d(TmpArr("DifferentRepeat",checkItmID)) ""

	s itmList = $g(TmpArr("Drug"))
	s RepeatArr = ""
	f i=1:1:$listlength(itmList) d
	.s itmid = $list(itmList,i)
	.s TmpArr("DifferentRepeat",itmid)=""  // 记录已经处理过的药品
	.d ..GetDiffRepeatList(.RepeatArr,.TmpArr,itmid)

	s drugArr = ""
	s group = ""
	f  s group = $o(RepeatArr("Repeat","Group",group))  q:group=""  d
	.s index = "",count = 0
	.f  s index = $o(RepeatArr("Repeat","Group",group,index))  q:index=""  d
	..s count = count + 1 
	.// 记录有问题的药品
	.q:count<2 // <=1则没有发生重复
	.s drugList = RepeatArr("Repeat","Group",group)
	.q:(drugList="")||($listlength(drugList)<2)
	.s checkItmID = $list(drugList,1)
	.q:$d(drugArr(checkItmID))	// 已经输出过的不在输出
	.s drugNameList = RepeatArr("Repeat","Drug",group)
	.s $list(drugNameList,1,1)="" // 删除第一个药品
	.f k=1:1:$listlength(drugList)  d	// 用于记录已经输出过的属性
	..s drugArr($list(drugList,k))=""
	.
	.s labelDesc = "重复用药"
	.s TmpMsgArr("itemOrder",checkItmID,labelDesc,checkItmID_"DR")=$lb(0,"NotPass","forbid","当前药品与"_$listtostring(drugNameList)_"重复","","","","Y")		//sufan 2022-05-19 修改级别为禁止
	.s TmpMsgArr("itemOrder",checkItmID,labelDesc,checkItmID_"DR",checkItmID)="DrugCategory"_"@@"_"当前与"_$listtostring(drugNameList)_"重复(异类)"
	.s TmpMsgArr("PreCondtions",checkItmID_"DR")=$lb("NULL")	//前提条件
	
	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-01-11
/// Descript: 		判断异类重复,并按照异类重复下的组别进行记录
/// Input:			
/// Other:			
/// w ##Class(web.DHCCKBPassExt).GetDiffRepeatList(RepeatArr,TmpArr,checkItmID) 
ClassMethod GetDiffRepeatList(RepeatArr, TmpArr, checkItmID)
{
	n (RepeatArr,TmpArr,checkItmID)
	
	// 根据药品找到分类,用分类及其link分类取父级,确定是否在异类重复下
	s differentRepeat = ##class(web.DHCCKBCommon).GetDifferentRepeat()	// 异类重复		
	s linkList = ##Class(web.DHCCKBCommon).GetPhCatAlone(+checkItmID,1)
	s allList = ""
	f i=1:1:$listlength(linkList)  d	// 找到分类的所有linkDr
	.s tmpCat = $list(linkList,i)
	.s tmpRowID = ""
	.f  s tmpRowID = $o(^CT.CKB.PDSS.CommonDictionI("Link",tmpCat,tmpRowID))  q:tmpRowID=""  d 
	..s $list(allList,*+1) = tmpRowID
	
	s allList = ##class(web.DHCCKBCommonUtil).GetUnionList(allList,linkList)	// 药品的所有分类及其linkDr集合

	f k = 1:1:$listlength(allList)  d
	.s tmpCat = $list(allList,k)
	.s allParrefList = ""
	.d ##Class(web.DHCCKBCommon).GetParentCat(.allParrefList,tmpCat,1)	
	.q:$listfind(allParrefList,differentRepeat)=0	// 不在异类重复下
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpCat)),4)	// 直接上级(倒数第二层-组)
	.q:+parref=0
	.s lastParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),4) // 倒数第三层分类(异类重复)
	.q:lastParref'=differentRepeat	// 不在异类重复下
	.s RepeatArr("Repeat","Group",parref,tmpCat) = ""	// RepeatArr("异类重复","组","分类1")
	.s $list(RepeatArr("Repeat","Group",parref),*+1) = checkItmID	// 按组记录药品
	.s $list(RepeatArr("Repeat","Drug",parref),*+1) = $listtostring($g(TmpArr("Drug",checkItmID)))	// 按组记录药品
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-02-02
/// Descript: 		基药优先使用判断提示
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CheckBaseDrugPriority(TmpArr,152,73,"D") //VolPurchProp
ClassMethod CheckBaseDrugPriority(checkItmID, TmpArr, TmpMsgArr)
{
	n (checkItmID,TmpArr,TmpMsgArr)
	s ruleType=$g(TmpArr("Action"))	
	s TmpArr("CalcItm")=checkItmID
	q:ruleType'="CheckRule" ""
	s userInfo = $g(TmpArr("UserInfo"))
	s hospitalId=$p(userInfo,"^",5)
	s hospitalId=##class(web.DHCCKBCommon).GetHospIdByDesc(hospitalId)
	s realItmId = $p(checkItmID,$c(2),1)
	// 判断是否已经是基药
	s isVolPurchFlag = ..IsBaseDrugFlag(realItmId)
	q:isVolPurchFlag=1 ""	
	// 判断当前的药品是否关联在国家基药目录下
	;s catList = ##Class(web.DHCCKBCommon).GetPhCatWithParent(realItmId,1)
	;s baseDrugCat = ##class(web.DHCCKBCommon).GetBaseDrugCat()	// 国家基药目录分类
	;q:$listfind(catList,baseDrugCat)=0 ""
	
	;s exitFlag = 0
	;s baseCat = ""
	;s linkCatList = ##class(web.DHCCKBCommon).GetPhCatAlone(realItmId,1)
	
	;f i =1:1:$listlength(linkCatList)  q:exitFlag=1  d
	;.s cat = $list(linkCatList,i)
	;.s tmpList = ""
	;.s parrefCatList = ##Class(web.DHCCKBCommon).GetParentCat(.tmpList,cat,1)
	;.i $listfind(tmpList,baseDrugCat)'= 0 s exitFlag = 1,baseCat = cat
	
	;q:baseCat="" ""
	// 在当前的国家基药目录分类下,找到替换的药品	
	s drugArr = []
	s exitFlag = 0
	;s replaceDrugList=##Class(web.DHCCKBCommon).GetDrugListByCat(baseCat,1)
	s generIdList = ##class(web.DHCCKBCommon).GetGeneralFrom(realItmId,1)
	
	//取相同通用名的其他药物
	s replaceDrugList=##Class(web.DHCCKBCommon).GetDrugListByGenName(generIdList,hospitalId)
	Q:$listlength(replaceDrugList)<1 ""
	
	s drugStr = ""
	f i =1:1:$listlength(replaceDrugList)  d
	.s drugId = $list(replaceDrugList,i)
	.q:drugId=realItmId
	.q:..IsBaseDrugFlag(drugId)=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(drugId))
	.s drugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	.s:drugName'="" drugName=drugName_"(基药)"
	.i drugName'="" d drugArr.%Push(drugName)
	.i drugStr="" s drugStr = drugName
	.e  s drugStr  = drugStr_","_drugName
	.s exitFlag = 1
	q:exitFlag=0 "" // 没有替换的药品
	s LabelDesc="基药优先"  // 是否需要增加一个目录
	//s LabelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(LabelDesc) //##class(web.DHCCKBCommon).GetDrugLibaryData())
	s TmpMsgArr("itemOrder",checkItmID,LabelDesc,checkItmID)=$lb(0,"NotPass","tips","当前药品不是基药,请使用推荐药品列表中的药物","","","","Y")
	s TmpMsgArr("itemOrder",checkItmID,LabelDesc,checkItmID,checkItmID)="EssDrugFlagProp"_"@@"_"当前药品不是基药,请使用推荐药品列表中的药物"
	i drugArr.%Size()'=0 d
	.s tmpDrugArr=$g(TmpMsgArr("adviceDrug",checkItmID))	// 推荐药品列表
	.i tmpDrugArr'="" d
	..f k=0:1:drugArr.%Size() d
	...d tmpDrugArr.%Push(drugArr.%Get(k))
	.e  d
	..s tmpDrugArr=drugArr
	.s TmpMsgArr("adviceDrug",checkItmID)=tmpDrugArr
	s TmpMsgArr("PreCondtions",checkItmID)=$lb("NULL")	//前提条件
	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-01-11
/// Descript: 		判断药品是否维护国家基本药物标记
/// Input:			1 是，0 否
/// w ##Class(web.DHCCKBPassExt).IsBaseDrugFlag(150) //VolPurchProp
ClassMethod IsBaseDrugFlag(itmId)
{
	
	n (itmId)
	// 判断是否已经是国家基本药物的药品
	s essPropList = ##class(web.DHCCKBCommon).GetEssDrugFlagProp()
	s exitFlag = 0
	f i =1:1:$listlength(essPropList) q:exitFlag=1  d
	.s essProp = $list(essPropList,i)
	.s isBaseFlag = ##class(web.DHCCKBDrugVO).GetDicValueByPro(itmId,essProp)
	.i isBaseFlag="Y" s exitFlag = 1
	
	q exitFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-04-19
/// Descript: 		获取目录/全局规则的管理级别
/// Input:			0,1,2,3(提示、提醒、警示、禁止)
/// w ##Class(web.DHCCKBPassExt).GetLibaryManLevel("用法用量") //VolPurchProp
ClassMethod GetLibaryManLevel(LibaryName)
{
	
	n (LibaryName)
	
	s LibaryDataID = ##class(DHCCKBCommon).GetDrugLibaryData()
	s GlobalDataID = ##class(DHCCKBCommon).GetGlobalData()
	s LibaryID = ##class(DHCCKBCommon).GetDicIdByDesc(LibaryName,LibaryDataID)
	i +LibaryID =0 s LibaryID = ##class(DHCCKBCommon).GetDicIdByDesc(LibaryName,GlobalDataID)
	s LibManLevelProp=##class(web.DHCCKBCommon).GetLibaryManLevelProp()
	s ManLevelNum = 0
	s ExistFlag = 0
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LibaryID,LibManLevelProp)) d
	.s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LibaryID,LibManLevelProp,""),-1)
	.s ManLevelID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+LinkID)),4)
	.s ManLevelCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ManLevelID)),2)
	.s:ManLevelCode="" ManLevelCode="normal"
	.s ManLevelNum=##class(web.DHCCKBCommon).GetManLevelNum(ManLevelCode)
	e  d
	.s TmpLibManLevelProp=""	// 若是link类型的，属性的值是存在link的id上的
	.f  s TmpLibManLevelProp=$o(^CT.CKB.PDSS.CommonDictionI("Link",LibManLevelProp,TmpLibManLevelProp))  q:(TmpLibManLevelProp="")||(ExistFlag=1)  d
	..q:TmpLibManLevelProp=""
	..s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LibaryID,TmpLibManLevelProp,""),-1)
	..s ManLevelID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+LinkID)),4)
	..s ManLevelCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ManLevelID)),2)
	..q:ManLevelCode=""
	..s ManLevelNum=##class(web.DHCCKBCommon).GetManLevelNum(ManLevelCode)
	..s ExistFlag=1

	q ManLevelNum
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-04-23
/// Descript: 		判断成分规则的十八反、十九畏规则
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CheckIngrRule("用法用量") //VolPurchProp
ClassMethod CheckIngrRule(Itmid, TmpArr, TmpMsgArr, Type)
{
	n (Itmid, TmpArr, TmpMsgArr, Type)	
	
	/* 获取药品的成分 */
	s DrugId = $p(Itmid,$c(2),1)
	s IngrList = ""
	i Type = "ingr" d	// 成分
	.s IngrList = ##Class(web.DHCCKBCommon).GetIngredient(DrugId)	
	i Type = "prescCope"  d		// 处方应付
	.s IngrList = ##class(web.DHCCKBCommon).GetPrescCopeData(DrugId,1)
	i Type = "generName"  d	
	.s IngrList = ##class(web.DHCCKBCommon).GetGeneralFrom(DrugId,1)
	
	q:$listlength(IngrList)=0 ""
	s EighteenTaboo = ##class(web.DHCCKBCommon).GetEighteenTaboo() // 十八反目录
	s NineteenTaboo = ##class(web.DHCCKBCommon).GetNineteenTaboo()	// 十九畏目录
	s RuleIndic = ##class(web.DHCCKBCommon).GetRuleIndic()			// 适应证
	s RuleUsage = ##class(web.DHCCKBCommon).GetRuleUsage()			// 用法用量
	s LiquidConfig = ##class(web.DHCCKBCommon).GetLiquidConfig()	// 液体配置
	
	s TabooList = $lb(EighteenTaboo,NineteenTaboo,RuleIndic,RuleUsage,LiquidConfig)	//,RuleUsage,LiquidConfig
	s UserInfo=$g(TmpArr("UserInfo"))	
	s RuleType=$g(TmpArr("Action"))	

	/* 判断成分是否有规则 */
	f i=1:1:$listlength(IngrList)  d
	.s IngrItmId = $listget(IngrList,i)
	.s IngrFlag = ##class(web.DHCCKBCommon).IsExistRule(IngrItmId)
	.q:IngrFlag=0
	.//s CheckItmID = IngrItmId
	.//s TmpArr("CalcItm")=CheckItmID
	./* 计算成分的规则 */
	.s IsFailFlag=..CheckDrugIngrRule(Itmid, IngrItmId, .TmpArr, .TmpMsgArr,TabooList,Type)
	.
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-04-23
/// Descript:  		成分规则单独判断
/// Input:    
/// Output:   
/// w ##Class(web.DHCCKBPassNew).CheckDrugIngrRule("", "", .TmpArr)
ClassMethod CheckDrugIngrRule(DrugItmId, IngrItmid, TmpArr, TmpMsgArr, CheckLabList, Type) As %String
{
	n (DrugItmId, IngrItmid, TmpArr, TmpMsgArr,CheckLabList,Type)
	s UserInfo=$g(TmpArr("UserInfo"))
	s curDrugId = TmpArr("CalcItm")
	s ItmID=IngrItmid
	s CheckItmID=IngrItmid
	s RuleType=$g(TmpArr("Action"))	
	s TmpArr("CalcItm")=CheckItmID
	
	K LabelArr
	s RulDicID=""
	F  s RulDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",ItmID,RulDicID)) Q:RulDicID=""  D
	.s IsFailFlag=1	// 默认通过
	.s RulID=$lg($g(^CT.CKB.PDSS.RuleDicD(RulDicID)),2) 	// 规则ID
	.Q:$lg($g(^CT.CKB.PDSS.RuleD(RulID)),4)'="Release"  	// 未发布不加算在内
	.q:##Class(web.DHCCKBPassNew).isChildRule(RulID)=1	// 审查项目本身有子规则,不审子规则
	.s TmpArr("RulID")=RulID 
	.s TmpArr("TipsPath")=##Class(web.DHCCKBPassNew).GetLabelTipsPath(RulID)	// 提醒方向
	.s TmpArr("CheckDicID")=CheckItmID
	.s TmpArr("RuleStype",RulID)="G"
	.s LabelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(RulID)			// 审查目录
	.s LabelId=##Class(web.DHCCKBPassNew).GetRuleLabelID(RulID)
	.q:$listfind(CheckLabList,LabelId)=0
	.s LabelLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LabelId)),5)
	.s LabRuleType=##class(web.DHCCKBCommon).GetRuleType(LabelId)	// 规则类型
	.s TmpArr("Label")=LabelId
	.s AccFlag = TmpArr("AccFlag") 
	.q:##Class(web.DHCCKBPassNew).CheckLabelAcc(LabelId,.TmpArr,AccFlag)<=0			// 目录授权
	.s TmpArr("LabelDesc")=LabelDesc
	.q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,ItmID,LabelId,"D") // qnp 2020/1/14 判断目录是否有忽略配置
	.s LabelRule=##Class(web.DHCCKBPassNew).GetLabelRule(LabelDesc)			// 目录的判断规则 
	.Q:(LabelRule=0)&&($d(TmpArr("IndicatJud",curDrugId,LabelDesc,1)))
	.q:(LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	// 限定目录有一条通过则通过时，条件若满足，则不进行其他的判断
	.q:(LabRuleType'="")&(RuleType'=LabRuleType)	// 区分审查规则和教育规则
	.s NodeID=-100000000000000
	.s IsPreCondFlag=##Class(web.DHCCKBPassNew).TakPreConditionsNew(NodeID,.TmpArr,.TmpMsgArr,"G")
	.s PreList=$g(TmpMsgArr("PreCondtions",RulID))
	.s PreList=$listtostring(PreList)
	.s CondFlag=$Case((PreList="")||(PreList="NULL"),1:0,:1)	// 1 有前提条件,0没有前提条件	
	.q:(CondFlag=1)&(IsPreCondFlag=0) 
	.i CondFlag=0  s TmpMsgArr("PreCondtions",RulID)=$lb("NULL")	// 无前提
	.s TmpArr("RulID")=RulID 						// 判断条件时,若有引用规则，那么RulID会被改变，此时需要重新赋值
	.q:'$d(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,"if",NodeID))		// 无规则
	.s RuleFlag=##Class(web.DHCCKBPassNew).InvRuleData(NodeID,.TmpArr,.TmpMsgArr,"G")
	.s IgnoreRule=$g(TmpArr("RuleID",RulID))					// 规则中有忽略的，忽略整条规则 2020/10/12 
	.i IgnoreRule=1 d ##Class(web.DHCCKBPassNew).CleanIgnoreRuleMsg(.TmpArr,.TmpMsgArr)	// 清除规则的忽略信息
	.q:IgnoreRule=1
	.i RuleFlag=-1 s RuleFlag=0
	.s RuleFlag=$case(TmpArr("TipsPath"),1:'RuleFlag,:RuleFlag)		// 根据计算方向 禁忌反向	
	.i RuleFlag=1 k TmpMsgArr("itemOrder",CheckItmID,LabelDesc,RulID)	// 规则通过，则清空规则的
	.s LabelArr(CheckItmID,LabelDesc,RuleFlag)=RuleFlag
	.s TmpArr("IndicatJud",DrugItmId,LabelDesc,RuleFlag) = RuleFlag
	.i (LabelRule=0)&&($d(LabelArr(CheckItmID,LabelDesc,1)))	d // 一条通过则通过, 清除掉目录的返回值
	..k TmpMsgArr("itemOrder",CheckItmID,LabelDesc)	
	..k TmpMsgArr("itemOrder",DrugItmId,LabelDesc)					//sufan 2022-04-29  满足时，k掉药品的提示
	.i RuleFlag=0 d  // 成分的规则不通过,将其消息记录在药品身上
	..d ..SetDrugMsgByIngr(DrugItmId, IngrItmid, LabelDesc,RulID, .TmpArr, .TmpMsgArr,Type) // 成分规则触发提醒时,需要组织提醒消息：A药的x成分和B药的x成分十八反	
	.k TmpMsgArr("itemOrder",CheckItmID,LabelDesc,RulID)	// 清除掉成分规则计算中保存的提醒消息
	.s IsFailFlag=RuleFlag
	.q:IsFailFlag=1	
	.d ..ReaOutData(IsFailFlag, DrugItmId, .TmpArr,.TmpMsgArr)	// 一组结果的输出
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-04-23
/// Descript:  		成分规则单独判断
/// Input:    
/// Output:   
/// w ##Class(web.DHCCKBPassNew).CheckDrugIngrRule("", "", .TmpArr)
ClassMethod SetDrugMsgByIngr(DrugItmId, IngrItmid, LabelDesc, RulID, TmpArr, TmpMsgArr, Type) As %String
{
	n (DrugItmId, IngrItmid, LabelDesc, RulID, TmpArr, TmpMsgArr, Type)
	s DrugName = $listtostring($g(TmpArr("Drug",DrugItmId)))
	s IngrName = $lg($g(^CT.CKB.PDSS.CommonDictionD(IngrItmid)),3)	
	q:LabelDesc="" ""
	q:'$d( TmpMsgArr("itemOrder",IngrItmid,LabelDesc)) ""
	q:'$d( TmpMsgArr("itemOrder",IngrItmid,LabelDesc,+RulID)) ""
	
	s ID = ""
	f  s ID = $o(TmpMsgArr("itemOrder",IngrItmid,LabelDesc,RulID,ID)) q:ID=""  d  	
	.i (Type="ingr")&&($d(TmpMsgArr("itemOrder",IngrItmid,LabelDesc,RulID,ID,"Taboo"))) d
	..s Value=$g(TmpMsgArr("itemOrder",IngrItmid,LabelDesc,RulID,ID,"Taboo")) //Key_"@@"_LinkLibValueExt $lb(DrugName,LibValueExt)
	..q:Value=""
	..s Key = $p(Value,"@@",1)
	..s MsgList = $p(Value,"@@",2)
	..s TmpMsgArr("itemOrder",DrugItmId,LabelDesc,RulID,ID)=Key_"@@"_DrugName_"中【"_IngrName_"】和"_$listtostring(MsgList)_LabelDesc
	.i ((Type="prescCope")||(Type="generName"))&&($d(TmpMsgArr("itemOrder",IngrItmid,LabelDesc,RulID,ID))) d
	..s Value=$g(TmpMsgArr("itemOrder",IngrItmid,LabelDesc,RulID,ID)) //Key_"@@"_LinkLibValueExt $lb(DrugName,LibValueExt)
	..q:Value=""	
	..s TmpMsgArr("itemOrder",DrugItmId,LabelDesc,RulID,ID)=Value
	
	q ""
}

///  Descript:  准备输出数据
///  Other: 输出信息组成：程序拼写提示(错误+正确用法)+错误提醒+进一步说明
///  w ##Class(web.DHCCKBPassNew).ReaOutData("984","1",.TmpMsgArr)
ClassMethod ReaOutData(isFailFlag As %String, DrugItmId, TmpArr, TmpMsgArr) As %String
{
	n (isFailFlag,DrugItmId, TmpArr, TmpMsgArr)
	
	s LabelDesc=TmpArr("LabelDesc")
	s CheckDicID=DrugItmId
	s TipsPath=TmpArr("TipsPath")	// 正反向
	s RulID=TmpArr("RulID")
	
	q:(isFailFlag=1) ""
	s OutType=$select(TipsPath=1:"then",TipsPath=0:"else")	

	s RetList=""
	s ParID=""
	F  s ParID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,OutType,0,ParID)) Q:ParID=""  D
	.s ID="", isTrueNum=0, isTrue=0
	.F  s ID=$o(^CT.CKB.PDSS.RuleDataI("Node",ParID,ID)) Q:ID=""  D
	..s varCode="",varText=""
	..s LkLDicID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4)
	..i +LkLDicID'=0 s varCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LkLDicID)),2)   /// 实体代码
	..s LkRDicID=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)
	..i +LkRDicID'=0 s varText=$lg($g(^CT.CKB.PDSS.CommonDictionD(LkRDicID)),2)   /// 实体代码
	..E  s varText=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)
	../// 通过标识
	..i varCode="PassFlag" D
	...s $list(RetList,2)=varText
	../// 管理级别
	..i varCode="LevelFlag" D	
	...s $list(RetList,3)=varText		
	../// 提示信息
	..i varCode="WarnMessage" D
	...s $list(RetList,4)=varText
	../// 管制力度
	..i varCode="ControlLevel" D
	...s $list(RetList,5)=varText
	../// 提示依据
	..i varCode="SourceMsg" D
	...s $list(RetList,6)=varText
	..i varCode="OutMsgTipsFlag" D
	...s $list(RetList,8)=varText

	s $list(RetList,7)="警示信息"	// 警示信息
	s $list(RetList,1)=isFailFlag	// 实际是否通过

	// 必填项没有值时,先默认为最低级别的值
	i $listget(RetList,2)="" s $list(RetList,2)=$case(isFailFlag=1,1:"HasPass",:"NotPass")
	i $listget(RetList,3)="" s $list(RetList,3)="tips"
	i $listget(RetList,8)="" s $list(RetList,8)="N"	
	
	i $d(TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID))  d
	.s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,RulID)=RetList

	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	
	Q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-14
/// Descript: 		相似作用判断(一组(分类)药品中,只能使用一个)
/// Input:			需要判断相似作用的分类
/// w ##Class(web.DHCCKBPassExt).CheckSimilarEffectNew()
ClassMethod CheckSimilarEffectNew(itmid, TmpArr, TmpMsgArr)
{
	n (itmid,TmpArr,TmpMsgArr)
	
	s ruleType=$g(TmpArr("Action"))	
	q:ruleType'="CheckRule" ""
	s labelDesc="辅助用药"
		
	// 遍历药品,找到药品的分类, 观察药品的分类相同数是否大于1,大于1则提醒
	s catId =##class(web.DHCCKBCommon).GetDicIdByDesc("辅助用药分类")	
	s catList = $lb(catId)
	k TmpCatArr
	s itmList=$g(TmpArr("Drug"))

	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.q:+tmpItmid=0
	.s drugId = $p(tmpItmid,$c(2),1)
	.//s drugCat = ##Class(web.DHCCKBCommon).GetAlonePhCat(drugId,1)
	.s drugCat = ##Class(web.DHCCKBCommon).GetPhCatWithParent(drugId,1)
	.s genformList = ##Class(web.DHCCKBCommon).GetGeneralFrom(drugId,1)	// 获取带剂型的通用名的分类
	.s genformCatList = ""
	.f m=1:1:$listlength(genformList)  d
	..s genformId = $listget(genformList,m)
	..s tmpCatList = ##Class(web.DHCCKBCommon).GetPhCatWithParent(genformId,1)
	..s genformList = ##Class(web.DHCCKBCommonUtil).GetUnionList(tmpCatList,genformList)
	.
	.s drugCat = ##Class(web.DHCCKBCommonUtil).GetUnionList(genformList,drugCat)
	.s mixList = ##Class(web.DHCCKBCommonUtil).GetMixList(drugCat,catList)	
	.q:$listlength(mixList)=0	// 不在相似作用的分类组里面
	.s len = $listlength(mixList)
	.f k=1:1:len  d
	..s itmCat = $lg(mixList,k)
	..s $list(TmpCatArr(itmCat),*+1) = tmpItmid	// 记录相同分类下的药品,用于输出提示信息时,一组药只输出一次
	..s $list(TmpCatArr(itmCat,"Name"),*+1) = $listtostring($g(TmpArr("Drug",tmpItmid)))

	s itmList=$g(TmpArr("Drug"))	// 每一个药品上都要提示出来相似作用(薛-2020/12/11)
	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.//q:tmpItmid=itmid
	.s cat = ""
	.f  s cat=$o(TmpCatArr(cat))  q:cat=""  d
	..s catName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+cat)),3)
	..s drugList = $g(TmpCatArr(cat))
	..q:($listlength(drugList)=1)&($lg(drugList)=tmpItmid)
	..s drugNameList = $g(TmpCatArr(cat,"Name"))
	..s drugName = $listtostring($g(TmpArr("Drug",tmpItmid)))
	..s index = $lf(drugNameList,drugName)
	..s $list(drugNameList,index,index)=""	// 删除本身的药品
	..q:$listfind(drugList,tmpItmid)=0
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid)=$lb(0,"NotPass","warn","与"_$listtostring(drugNameList,",")_"相似作用"_","_catName_"(1组)"_"只能使用(1个)","","","","Y")
	..//s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_$listtostring(drugNameList,",")_"相似作用"_","_catName_"(1组)"_"只能使用(1个)"
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_$listtostring(drugNameList,",")_"相似作用"_","_catName_"(1组)"_"只能使用(1个)"
	..s TmpMsgArr("PreCondtions",tmpItmid)=$lb("NULL")	//前提条件
	// 	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

/// Descript:根据要学分类判断科室审查列表-科室
/// Creator:sunhuiyong
/// CreateDate:2021-05-25
/// Input:PatLoc
/// Output：0：此科室无审查列表（默认全审查）  1：此科室有审查列表
/// w ##class(web.DHCCKBPassNewExt).IsLocPass("儿科")
ClassMethod IsLocPass(PatLoc)
{
	n (PatLoc)
	//审查科室是否授权
	s LocPass=0  //0：此科室无审查列表（默认全审查）  1：此科室有审查列表
	s Parref=##class(web.DHCCKBCommon).GetDrugLocList() //单科室审查下的所有列表   
	s AcList="",DicID=""
	f  s DicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,DicID)) q:DicID=""  d
	.s StopID=0
	.F  s StopID=$o(^CKB.PDSS.DicLogI("DLGDataDr",DicID,StopID)) Q:StopID=""  D
	..s ListData = $g(^CKB.PDSS.DicLogD(StopID))
	..s Scope= $lg(ListData,8) 
	..s ScopeValue= $lg(ListData,9)
	..q:"DHC_CKBCommonDiction"'=$lg(ListData,2)
	..s:Scope="L" ScopeValueData=$P($g(^CTLOC(+ScopeValue)),"^",2)
	..s:Scope="" ScopeValueData=""
	..s:ScopeValueData=PatLoc LocPass=1
	q LocPass
}

/// Descript:根据要学分类判断科室审查列表
/// Creator:sunhuiyong
/// CreateDate:2021-05-25
/// Input:PatLoc、DrugList
/// Output：0 审查   1 不审查
/// w ##class(web.DHCCKBPassExt).UpdateDrugListNew("皮肤科","78360")
ClassMethod UpdateDrugListNew(PatLoc, Id)
{
	n (PatLoc,Id)
	s PassLocList=1
	//审查科室是否授权
	s LocPassFlag=..IsLocPass(PatLoc)
	q:LocPassFlag=0 0   //全审查--通过
	//获取审查列表
	s Parref=##class(web.DHCCKBCommon).GetDrugLocList() //单科室审查下的所有列表   
	s DrugList="",DicID=""
	f  s DicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,DicID)) q:DicID=""  d
	.s DrugCatId=DicID
    .s DrugCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugCatId)),3)
	.s LinkId= $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugCatId)),5)
	.s StopID=""
	.F  s StopID=$o(^CKB.PDSS.DicLogI("DLGDataDr",DrugCatId,StopID)) Q:StopID=""  D
	..s ListData = $g(^CKB.PDSS.DicLogD(StopID))
	..s Scope=$lg(ListData,8)
	..s ScopeValue=$lg(ListData,9)
	..q:"DHC_CKBCommonDiction"'=$lg(ListData,2)
	..;q:$lg(ListData,2)'="businessAuth"
	..s:Scope="L" ScopeValueData=$P($g(^CTLOC(+ScopeValue)),"^",2)
	..s:Scope="" ScopeValueData=""
	.q:ScopeValueData'=PatLoc
	.i (DrugCat="")&&(LinkId'="") s DrugCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	.s DrugCatAttrId=##class(web.DHCCKBCommon).GetPhCategory()		//药学分类属性
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.s CatDesc=##class(web.DHCCKBEditProp).QueryAttrValue(Id,DrugCatAttrId)
	.Q:('##class(web.DHCCKBDiction).IsInclude(CatDesc,DrugCat))  //已选
	.s PassLocList=0
	q PassLocList
}

/// Creator: 		sunhuiyong
/// CreateDate: 	2021-06-09
/// Descript: 		重复同类用药-中成药
/// Input:			需要判断相似作用的分类
/// w ##Class(web.DHCCKBPassExt).CheckSimilarRepeatGenalNew()
ClassMethod CheckSimilarRepeatGenalNewO(checkItmID, TmpArr, TmpMsgArr)
{
	n (checkItmID,TmpArr,TmpMsgArr)
	s ruleType=$g(TmpArr("Action"))	

	s TmpArr("CalcItm")=checkItmID
	q:ruleType'="CheckRule" ""
	
	s similarRepeatCatId = ##class(web.DHCCKBCommon).GetYBRepeat()	// 同类重复
	;s drugGenalID=##Class(web.DHCCKBCommon).GetGeneralFromStr(checkItmID,1) //1126893 	
	;s checkDicCatList = ##Class(web.DHCCKBCommon).GetPhCatAlone(+drugGenalID,1)
	;s catList = $lb(catId)	
	s checkDicCatList =$lb(similarRepeatCatId)
	;b ;sss1
	//s realItmId = $p(checkItmID,$c(2),1)
	// 遍历所有的药品,获取药品的分类,判断药品的分类是否在同类重复的分类下,是则记录该药品提醒,否则通过
	s linkDrugList="",count = 0
	s itmList = $g(TmpArr("Drug"))
	f i=1:1:$listlength(itmList) d
	.s itmid = $list(itmList,i)
	.q:(itmid=checkItmID)	// 排除掉检测药品本身 
	.q:$d(TmpArr("CheckSimilarRepeat",checkItmID,itmid))
	.q:$d(TmpArr("CheckSimilarRepeat",itmid,checkItmID))
	.s realItmId = $p(itmid,$c(2),1)
	.q:realItmId=+checkItmID
	.s realItmId=##Class(web.DHCCKBCommon).GetGeneralFromStr(realItmId,1) 
	.s itmCatList=##Class(web.DHCCKBCommon).GetPhCatWithParent(+realItmId,1)    ;##Class(web.DHCCKBCommon).GetPhCatAlone(+realItmId,1)	//##Class(web.DHCCKBCommon).GetPhCat(RealItmId,1)
	.s mixList = ##Class(web.DHCCKBCommonUtil).GetMixList(itmCatList,checkDicCatList) // 找到两个list的交集
	.;b ;sss2
	.q:$listlength(mixList)=0
	.s mixParrefList = ""
	.f k=1:1:$listLength(mixList)  d
	..s tmpCat = $list(mixList,k)
	..d ##Class(web.DHCCKBCommon).GetParentCat(.mixParrefList,tmpCat,1)	// 获取交集的父分类
	..s tmpRowID = ""
	..f  s tmpRowID = $o(^CT.CKB.PDSS.CommonDictionI("Link",tmpCat,tmpRowID))  q:tmpRowID=""  d //在同类重复的分类树中展示的是新增的空记录,关联表中存的是link
	...d ##Class(web.DHCCKBCommon).GetParentCat(.mixParrefList,tmpRowID,1)	
	...
	.;b ;sss3
	.q:$listfind(mixParrefList,similarRepeatCatId)=0	// 不在同类重复下
	.;b   ;sssssss
	.s $list(linkDrugList,*+1) = $listtostring($g(TmpArr("Drug",itmid)))
	.s TmpArr("CheckSimilarRepeat",checkItmID,itmid)=""
	.s TmpArr("CheckSimilarRepeat",itmid,checkItmID)=""	// 记录重复的药品
	.s count = count + 1 // 找到同类的药品,则计数器加1
	;b ;;111
	q:$listlength(linkDrugList)=0 ""
	q:count=0 ""
	s labelDesc = "同类重复用药"
	s TmpMsgArr("itemOrder",checkItmID,labelDesc,checkItmID)=$lb(0,"NotPass","warn","当前药品与"_$listtostring(linkDrugList)_"重复","","","","Y")
	s TmpMsgArr("itemOrder",checkItmID,labelDesc,checkItmID,checkItmID)="DrugCategory"_"@@"_"当前药品与"_$listtostring(linkDrugList)_"重复"
	s TmpMsgArr("PreCondtions",checkItmID)=$lb("NULL")	//前提条件
	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

/// Creator: 		sunhuiyong
/// CreateDate: 	2021-06-09
/// Descript: 		重复同类用药
/// Input:			需要判断相似作用的分类
/// w ##Class(web.DHCCKBPassExt).CheckSimilarRepeatGenalNew()
ClassMethod CheckSimilarRepeatGenalNew(itmid, TmpArr, TmpMsgArr)
{
	n (itmid,TmpArr,TmpMsgArr)
	
	s ruleType=$g(TmpArr("Action"))	
	q:ruleType'="CheckRule" ""
	s labelDesc="同类重复"
		
	// 遍历药品,找到药品的分类, 观察药品的分类相同数是否大于1,大于1则提醒
	s catId =##class(web.DHCCKBCommon).GetDicIdByDesc("中成药分类")	
	s catList = $lb(catId)
	k TmpCatArr
	s itmList=$g(TmpArr("Drug"))

	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.q:+tmpItmid=0
	.s drugId = $p(tmpItmid,$c(2),1)
	.s drugGenalId=##class(web.DHCCKBCommon).GetGeneralFromStr(drugId)   //药品ID->带剂型的通用名ID
	.s genformList=##Class(web.DHCCKBCommon).GetPhCatWithParent(drugGenalId,1) //带剂型通用名分类以及上级分类
	.s drugCatFlag=##Class(web.DHCCKBCommon).GetPhCat(drugGenalId)   //带剂型通用名分类
	.s drugCat=##Class(web.DHCCKBCommon).GetPhCatWithParent(drugGenalId,1)  //用于最后过滤
	.s genformCatList = ""
	.f m=1:1:$listlength(genformList)  d
	..s genformId = $listget(genformList,m)
	..s tmpCatList = ##Class(web.DHCCKBCommon).GetPhCatWithParent(genformId,1)
	..s genformList = ##Class(web.DHCCKBCommonUtil).GetUnionList(tmpCatList,genformList)
	.
	.s drugCat = ##Class(web.DHCCKBCommonUtil).GetUnionList(genformList,drugCat)
	.s mixList = ##Class(web.DHCCKBCommonUtil).GetMixList(drugCat,drugCatFlag)	
	.q:$listlength(mixList)=0	// 不在相似作用的分类组里面
	.s len = $listlength(mixList)
	.f k=1:1:len  d
	..s itmCat = $lg(mixList,k)
	..s $list(TmpCatArr(itmCat),*+1) = tmpItmid	// 记录相同分类下的药品,用于输出提示信息时,一组药只输出一次
	..s $list(TmpCatArr(itmCat,"Name"),*+1) = $listtostring($g(TmpArr("Drug",tmpItmid)))

	s itmList=$g(TmpArr("Drug"))	// 每一个药品上都要提示出来相似作用(薛-2020/12/11)
	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.//q:tmpItmid=itmid
	.s cat = ""
	.f  s cat=$o(TmpCatArr(cat))  q:cat=""  d
	..s catName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+cat)),3)
	..s drugList = $g(TmpCatArr(cat))
	..q:($listlength(drugList)=1)&($lg(drugList)=tmpItmid)
	..s drugNameList = $g(TmpCatArr(cat,"Name"))
	..s drugName = $listtostring($g(TmpArr("Drug",tmpItmid)))
	..s index = $lf(drugNameList,drugName)
	..s $list(drugNameList,index,index)=""	// 删除本身的药品
	..q:$listfind(drugList,tmpItmid)=0
	..s drugNameList = $replace($listtostring(drugNameList,","),drugName,"") //通过名称过滤自身重复 shy
	..s:$e(drugNameList,1)="," $e(drugNameList,1)=""
	..q:drugNameList=""
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid)=$lb(0,"NotPass","forbid","与"_drugNameList_"重复用药"_","_catName_"(1组)"_"只能使用(1个)","","","","Y")
	..//s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_$listtostring(drugNameList,",")_"重复用药"_","_catName_"(1组)"_"只能使用(1个)"
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_drugNameList_"重复用药"_","_catName_"(1组)"_"只能使用(1个)"
	..s TmpMsgArr("PreCondtions",tmpItmid)=$lb("NULL")	//前提条件
	// 	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

// Creator: 		sunhuiyong

/// CreateDate: 	2021-06-09
/// Descript: 		重复同类用药-中成药-武汉一院
/// Input:			需要判断相似作用的分类
/// w ##Class(web.DHCCKBPassExt).CheckSimilarRepeatGenalNew()
ClassMethod CheckSimilarRepeatGenalNewN(itmid, TmpArr, TmpMsgArr)
{
	n (itmid,TmpArr,TmpMsgArr)
	
	s ruleType=$g(TmpArr("Action"))	
	q:ruleType'="CheckRule" ""
	s labelDesc="同类重复"
		
	// 遍历药品,找到药品的分类, 观察药品的分类相同数是否大于1,大于1则提醒
	k TmpCatArr
	s itmList=$g(TmpArr("Drug"))
	
	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.q:+tmpItmid=0
	.s drugId = $p(tmpItmid,$c(2),1)
	.//s drugCat = ##Class(web.DHCCKBCommon).GetAlonePhCat(drugId,1)
	.s drugGenalID=##Class(web.DHCCKBCommon).GetGeneralFromStr(drugId,1)   
	.s drugCat = ##Class(web.DHCCKBCommon).GetPhCatWithParent(drugGenalID,1)
	.s genformList = ##Class(web.DHCCKBCommon).GetGeneralFromNew(drugId,1)	// 获取带剂型的通用名的分类
	.;b ;sss1
	.s genformCatList = ""
	.f m=1:1:$listlength(genformList)  d
	..s genformId = $listget(genformList,m)
	..s tmpCatList = ##Class(web.DHCCKBCommon).GetPhCatWithParent(genformId,1)
	..s genformList = ##Class(web.DHCCKBCommonUtil).GetUnionList(tmpCatList,genformList)
	.;b ;shy
	.s drugCat = ##Class(web.DHCCKBCommonUtil).GetUnionList(genformList,drugCat)
	.s mixList = ##Class(web.DHCCKBCommonUtil).GetMixList(drugCat,drugCat)	
	.q:$listlength(mixList)=0	// 不在相似作用的分类组里面
	.s len = $listlength(mixList)
	.f k=1:1:len  d
	..s itmCat = $lg(mixList,k)
	..q:$d(^CT.CKB.PDSS.CommonDictionI("Parref",itmCat))  
	..s $list(TmpCatArr(itmCat),*+1) = tmpItmid	// 记录相同分类下的药品,用于输出提示信息时,一组药只输出一次
	..s $list(TmpCatArr(itmCat,"Name"),*+1) = $listtostring($g(TmpArr("Drug",tmpItmid)))
	
	s itmList=$g(TmpArr("Drug"))	// 每一个药品上都要提示出来相似作用(薛-2020/12/11)
	f i=1:1:$listlength(itmList) d
	.s tmpItmid = $list(itmList,i)
	.//q:tmpItmid=itmid
	.s cat = ""
	.f  s cat=$o(TmpCatArr(cat))  q:cat=""  d
	..s catName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+cat)),3)
	..s drugList = $g(TmpCatArr(cat))
	..q:($listlength(drugList)=1)&($lg(drugList)=tmpItmid)
	..s drugNameList = $g(TmpCatArr(cat,"Name"))
	..s drugName = $listtostring($g(TmpArr("Drug",tmpItmid)))
	..s index = $lf(drugNameList,drugName)
	..s $list(drugNameList,index,index)=""	// 删除本身的药品
	..q:$listfind(drugList,tmpItmid)=0
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid)=$lb(0,"NotPass","forbid","与"_drugNameList_"重复用药"_","_catName_""_"只能使用(1个)","","","","Y")
	..//s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_$listtostring(drugNameList,",")_"重复用药"_","_catName_""_"只能使用(1个)"
	..s TmpMsgArr("itemOrder",tmpItmid,labelDesc,tmpItmid,tmpItmid)="SimilarEffect"_"@@与"_drugNameList_"重复用药"_","_catName_""_"只能使用(1个)"
	..s TmpMsgArr("PreCondtions",tmpItmid)=$lb("NULL")	//前提条件
	// 	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

/// Descript:根据要学分类判断科室审查列表-科室
/// Creator:sunhuiyong
/// CreateDate:2021-06-22
/// Input:PatLoc
/// Output：0：此科室无审查列表（默认全审查）  1：此科室有审查列表
/// w ##class(web.DHCCKBPassExt).IsHealthLocPass("保健科")
ClassMethod IsHealthLocPass(PatLoc)
{
	n (PatLoc)
	//审查科室是否授权
	s LocPass=0  //0：此科室无审查列表（默认全审查）  1：此科室有审查列表
	s DicID=##class(web.DHCCKBCommon).GetHealthclass() //分类列表
	s StopID=0
	F  s StopID=$o(^CKB.PDSS.DicLogI("DLGDataDr",DicID,StopID)) Q:StopID=""  D
	.s ListData = $g(^CKB.PDSS.DicLogD(StopID))
	.s Scope= $lg(ListData,8)
	.s ScopeValue= $lg(ListData,9) 
	.q:"DHC_CKBCommonDiction"'=$lg(ListData,2)
	.s:Scope="L" ScopeValueData=$P($g(^CTLOC(+ScopeValue)),"^",2)
	.s:Scope="" ScopeValueData=""
	.s:ScopeValueData=PatLoc LocPass=1
	q LocPass
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-14
/// Descript: 		去重list中的重复和空的部分
/// Input:			
/// w ##Class(web.DHCCKBPassExt).DealReport()
ClassMethod DealReport(linkList)
{
	n (linkList)
	q:linkList="" ""
	s markList = ""
	f i=1:1:$listlength(linkList)  d
	.s value = $listget(linkList,i)
	.q:value=""
	.q:$listfind(markList,value)'=0
	.s $list(markList,*+1)=value
	
	q markList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-25
/// Descript: 		药品概览信息
/// Input:			问题目录list
/// w ##Class(web.DHCCKBPassExt).DealOverView()
ClassMethod DealOverView(libaryList)
{
	n (libaryList)
	q:libaryList="" ""
	
	s str = "存在"_$listtostring(libaryList)_"风险"
	
	q str
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-07-08
/// Descript: 		判断分类是不是最小分类
/// Input:			 分类id
/// Return:			1 是最小分类 0 不是最小分类
/// w ##Class(web.DHCCKBPassExt).CheckSmallCat()
ClassMethod CheckSmallCat(catId)
{
	n (catId)
	
	s flag = 0
	q:catId="" flag
	q:##class(web.DHCCKBCommon).IsEnabled(catId)=0 flag	// 停用
	i '$d(^CT.CKB.PDSS.CommonDictionI("Parref",+catId)) s flag=1	
			
	q flag
}

/// Creator: 		sunhuiyong
/// CreateDate: 	2021-07-09
/// Descript: 		成分重复
/// w ##Class(web.DHCCKBPassExt).CheckSimilarComposition()
ClassMethod CheckSimilarComposition(pid, itmid, TmpArr, TmpMsgArr)
{
	n (pid,itmid,TmpArr,TmpMsgArr)
	
	s ruleType=$g(TmpArr("Action"))	
	q:ruleType'="CheckRule" ""
	s labelDesc="成分重复"
	s globalDataID = ##class(web.DHCCKBCommon).GetGlobalData()
	s chineseDrug=##class(web.DHCCKBCommon).GetChineseDrugData()
	s realItmId=$p(itmid,$c(2),1)
	s labelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(labelDesc,globalDataID) //##class(web.DHCCKBCommon).GetDrugLibaryData())
	s repeatList=""
	q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,realItmId,labelID,"D") "" // 判断目录是否有忽略配置
	s itmDesc=$listtostring(TmpArr("Drug",itmid))
	s itmDesc=$case(itmDesc'="",1:itmDesc,:$lg($g(^CT.CKB.PDSS.CommonDictionD(realItmId)),3))
	s drugId = $p(itmid,$c(2),1)
	//分类处方列表
	s parfDrugId = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	q:chineseDrug'=parfDrugId ""
	s drugCompList=##class(web.DHCCKBCommon).GetIngredient(+itmid,1)	// 成分列表
	s drugCompExtList=##class(web.DHCCKBCommon).GetIngredient(+itmid,0)
	s itmList=$g(TmpArr("Drug"))
	f i=1:1:$listlength(itmList) d
	.s tmpValue=$list(itmList,i)
	.;q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarComposition",pid,itmid,tmpValue))
	.;q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarComposition",pid,tmpValue,itmid))
	.s checkDrugId=$p($list(itmList,i),$c(2),1)
	.q:checkDrugId=drugId  //去除本身药品
	.q:($lg($g(^CT.CKB.PDSS.CommonDictionD(checkDrugId)),4)'=parfDrugId)&&(($lg($g(^CT.CKB.PDSS.CommonDictionD(checkDrugId)),4)'=chineseDrug))  //西药/中成药/饮片分类判断 添加限制中成药
	.s repeatFlag=0
	.s chekDrugCompositionList=##class(web.DHCCKBCommon).GetIngredient(checkDrugId,1)	// 成分（多个）
	.;原成分数组长度
	.s drugCompListLen=$listlength(drugCompList)
	.;s:drugId=90117 ^shy("111")=drugCompListLen_"&&&"_drugCompList_"--"_$listtostring($g(TmpArr("Drug",tmpValue)))
	.;s:$listtostring($g(TmpArr("Drug",tmpValue)))="速效救心丸(天津中新药业集团股份有限公司第六中药厂)" ^shy("222")=$listtostring($g(TmpArr("Drug",tmpValue)))
	.;检查成分数组长度
	.s chekDrugCompositionListLen=$listlength(chekDrugCompositionList)
	.s checkLen=drugCompListLen
	.;s:drugCompListLen>chekDrugCompositionListLen checkLen=chekDrugCompositionListLen   ;取最小长度  最大比例
	.; shy 2021-7-12 修改为针对某个药品超过30%比例提醒
	.s comCompositionLen=0
	.s chekDrugCompositionIdStr=""
	.s repeatIngrName=""
	.f k=1:1:$listlength(chekDrugCompositionList) q:repeatFlag=1  d
	..s chekDrugCompositionId=$list(chekDrugCompositionList,k)
	..s chekDrugCompositionExtId=##class(web.DHCCKBCommon).GetDicSecondName(chekDrugCompositionId)	// 成分别名
	..q:(chekDrugCompositionId="")&(chekDrugCompositionExtId="")
	..q:(drugCompList="")&(drugCompExtList="")
	..s ret=##class(web.DHCCKBPassNew).CheckRepeatDrug(chekDrugCompositionId,chekDrugCompositionExtId,drugCompList,drugCompExtList)	
	..i ret=1  d  //如果判定有重复成分需判定比例
	...s comCompositionLen=comCompositionLen+1
	...s:chekDrugCompositionIdStr'="" chekDrugCompositionIdStr=chekDrugCompositionIdStr_"^"_chekDrugCompositionId
	...s:chekDrugCompositionIdStr="" chekDrugCompositionIdStr=chekDrugCompositionId
	.;s:drugId=90117 ^shy("000")=comCompositionLen_"^"_checkLen_"--"_$listtostring($g(TmpArr("Drug",tmpValue)))
	.s:(checkLen'=0)&&((comCompositionLen/checkLen)>0.3) repeatFlag=1
	.i repeatFlag=1 d 
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarComposition",pid,itmid,tmpValue)=""
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarComposition",pid,tmpValue,itmid)=""
	..s lengthIngrNameStr=$l(chekDrugCompositionIdStr,"^")
	..f j=1:1:lengthIngrNameStr  d
	...s thisId=$p(chekDrugCompositionIdStr,"^",j)
	...s:repeatIngrName'="" repeatIngrName =repeatIngrName_","_$lg($g(^CT.CKB.PDSS.CommonDictionD(+thisId)),3) // 记录重复的成分
	...s:repeatIngrName="" repeatIngrName =$lg($g(^CT.CKB.PDSS.CommonDictionD(+thisId)),3) // 记录重复的成分
	..s repeatIngrName=repeatIngrName_";"
	..s repeatList(tmpValue)=$lb("Composition",chekDrugCompositionId,$listtostring($g(TmpArr("Drug",tmpValue))),repeatIngrName)
	
	s ingrList="",repeatName=""
	s id=""
	f  s id=$o(repeatList(id))  q:id=""  d
	.s type=$list(repeatList(id),1)
	.if type="Composition"  d
	..s $list(ingrList,*+1)=$list(repeatList(id),3)
	.s $list(repeatName,*+1) = $list(repeatList(id),4)
	s repeatValue = $case($listlength(repeatName)>0,1:$listtostring(repeatName),:"")
	s:repeatValue'="" repeatValue=$replace(repeatValue,";,",";")
	if ingrList'=""  d
	.;修改成分展示格式（分别跟在药品后边） sunhuiyong 2021-9-6
	.s firstShow=""
	.s firstStr=$listtostring(ingrList,"、")
	.s secondStr=repeatValue
	.s firstLength=$l(firstStr,"、")
	.f i=1:1:firstLength  d
	..s:firstShow'="" firstShow=firstShow_"、"_$p(firstStr,"、",i)_"("_$p(repeatValue,";",i)_")"
	..s:firstShow="" firstShow=$p(firstStr,"、",i)_"("_$p(repeatValue,";",i)_")"
	.;修改展示
	.s TmpMsgArr("itemOrder",itmid,labelDesc,itmid)=$lb(0,"NotPass","forbid","","","","")
	.;s TmpMsgArr("itemOrder",itmid,labelDesc,itmid,itmid_"R1")="RepeatIngr"_"@@"_itmDesc_"和"_$listtostring(ingrList,"、")_"(成分:"_repeatValue_")重复"
	.s TmpMsgArr("itemOrder",itmid,labelDesc,itmid,itmid_"R1")="RepeatIngr"_"@@"_itmDesc_"和"_firstShow_"重复"
	.s TmpMsgArr("PreCondtions",itmid)=$lb("NULL")	//前提条件
	
	// 	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

/// Creator: 		sunhuiyong
/// CreateDate: 	2021-07-21
/// Descript: 		毒性成分重复
/// w ##Class(web.DHCCKBPassExt).CheckSimilarComposition()
ClassMethod CheckPoisonList(pid, itmid, TmpArr, TmpMsgArr)
{
	n (pid,itmid,TmpArr,TmpMsgArr)
	
	s ruleType=$g(TmpArr("Action"))	
	q:ruleType'="CheckRule" ""
	s labelDesc="毒性成分重复"
	s globalDataID = ##class(web.DHCCKBCommon).GetGlobalData()
	s chineseDrug=##class(web.DHCCKBCommon).GetChineseDrugData()
	s realItmId=$p(itmid,$c(2),1)
	s labelID = ##class(web.DHCCKBCommon).GetDicIdByDesc(labelDesc,globalDataID) //##class(web.DHCCKBCommon).GetDrugLibaryData())
	s repeatList=""
	q:1=##Class(web.DHCCKBPassExt).IsIgnoreItm(.TmpArr,realItmId,labelID,"D") "" // 判断目录是否有忽略配置
	s itmDesc=$listtostring(TmpArr("Drug",itmid))
	s itmDesc=$case(itmDesc'="",1:itmDesc,:$lg($g(^CT.CKB.PDSS.CommonDictionD(realItmId)),3))
	s drugId = $p(itmid,$c(2),1)
	;一、分类处方列表
	s parfDrugId = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	;s ^shy("555")=chineseDrug_"^"_parfDrugId
	q:chineseDrug'=parfDrugId ""
	s drugCompList=##class(web.DHCCKBCommon).GetIngredient(+itmid,1)	// 成分列表
	s drugCompExtList=##class(web.DHCCKBCommon).GetIngredient(+itmid,0)
	s itmList=$g(TmpArr("Drug"))
	f i=1:1:$listlength(itmList) d
	.s tmpValue=$list(itmList,i)
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarCompositionPos",pid,itmid,tmpValue))
	.q:$d(^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarCompositionPos",pid,tmpValue,itmid))
	.s checkDrugId=$p($list(itmList,i),$c(2),1)
	.q:checkDrugId=drugId  //去除本身药品
	.q:($lg($g(^CT.CKB.PDSS.CommonDictionD(checkDrugId)),4)'=parfDrugId)&&(($lg($g(^CT.CKB.PDSS.CommonDictionD(checkDrugId)),4)'=chineseDrug))  //西药中成药饮片分类判断
	.s repeatFlag=0
	.s chekDrugCompositionList=##class(web.DHCCKBCommon).GetIngredient(checkDrugId,1)	// 成分（多个）
	.;原成分数组长度
	.s drugCompListLen=$listlength(drugCompList)
	.;s:drugId=90117 ^shy("111")=drugCompListLen_"&&&"_drugCompList_"--"_$listtostring($g(TmpArr("Drug",tmpValue)))
	.;s:$listtostring($g(TmpArr("Drug",tmpValue)))="速效救心丸(天津中新药业集团股份有限公司第六中药厂)" ^shy("222")=$listtostring($g(TmpArr("Drug",tmpValue)))
	.;检查成分数组长度
	.s chekDrugCompositionListLen=$listlength(chekDrugCompositionList)
	.s checkLen=drugCompListLen
	.;s:drugCompListLen>chekDrugCompositionListLen checkLen=chekDrugCompositionListLen   ;取最小长度  最大比例
	.; shy 2021-7-12 修改为针对某个药品超过30%比例提醒
	.s comCompositionLen=0
	.s chekDrugCompositionIdStr=""
	.s repeatIngrName=""
	.;s repeatFlag=##Class(web.DHCCKBPassExt).CheckPosComList(chekDrugCompositionId,drugCompList)
	.f k=1:1:$listlength(chekDrugCompositionList) q:repeatFlag=1  d
	..;b ;err0
	..s chekDrugCompositionId=$list(chekDrugCompositionList,k)
	..s chekDrugCompositionExtId=##class(web.DHCCKBCommon).GetDicSecondName(chekDrugCompositionId)	// 成分别名
	..q:(chekDrugCompositionId="")&(chekDrugCompositionExtId="")
	..q:(drugCompList="")&(drugCompExtList="")
	..s ret=##Class(web.DHCCKBPassExt).CheckPosComList(chekDrugCompositionId,drugCompList)
	..i ret=1  d
	...s comCompositionLen=comCompositionLen+1
	...s:chekDrugCompositionIdStr'="" chekDrugCompositionIdStr=chekDrugCompositionIdStr_"^"_chekDrugCompositionId
	...s:chekDrugCompositionIdStr="" chekDrugCompositionIdStr=chekDrugCompositionId
	.s:comCompositionLen'=0 repeatFlag=1
	. ;b ;err
	.i repeatFlag=1 d 
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarCompositionPos",pid,itmid,tmpValue)=""
	..s ^TMP("DHCCKB","web.DHCCKBPassNew","CheckSimilarCompositionPos",pid,tmpValue,itmid)=""
	..s lengthIngrNameStr=$l(chekDrugCompositionIdStr,"^")
	..f j=1:1:lengthIngrNameStr  d
	...s thisId=$p(chekDrugCompositionIdStr,"^",j)
	...s:repeatIngrName'="" repeatIngrName =repeatIngrName_","_$lg($g(^CT.CKB.PDSS.CommonDictionD(+thisId)),3) // 记录重复的成分
	...s:repeatIngrName="" repeatIngrName =$lg($g(^CT.CKB.PDSS.CommonDictionD(+thisId)),3) // 记录重复的成分
	..s repeatIngrName=repeatIngrName_";"
	..s repeatList(tmpValue)=$lb("CompositionPos",chekDrugCompositionId,$listtostring($g(TmpArr("Drug",tmpValue))),repeatIngrName)
	
	s ingrList="",repeatName=""
	s id=""
	f  s id=$o(repeatList(id))  q:id=""  d
	.s type=$list(repeatList(id),1)
	.if type="CompositionPos"  d
	..s $list(ingrList,*+1)=$list(repeatList(id),3)
	.s $list(repeatName,*+1) = $list(repeatList(id),4)
	
	
	s repeatValue = $case($listlength(repeatName)>0,1:$listtostring(repeatName),:"")
	s:repeatValue'="" repeatValue=$replace(repeatValue,";,",";")
	if ingrList'=""  d
	.;修改成分展示格式（跟在药品后边） sunhuiyong 2021-9-6
	.s firstShow=""
	.s firstStr=$listtostring(ingrList,"、")
	.s secondStr=repeatValue
	.s firstLength=$l(firstStr,"、")
	.f i=1:1:firstLength  d
	..s:firstShow'="" firstShow=firstShow_"、"_$p(firstStr,"、",i)_"("_$p(repeatValue,";",i)_")"
	..s:firstShow="" firstShow=$p(firstStr,"、",i)_"("_$p(repeatValue,";",i)_")"
	.;修改展示
	.s TmpMsgArr("itemOrder",itmid,labelDesc,itmid)=$lb(0,"NotPass","forbid","","","","")
	.;s TmpMsgArr("itemOrder",itmid,labelDesc,itmid,itmid_"R1")="RepeatPosIngr"_"@@"_itmDesc_"和"_$listtostring(ingrList,"、")_"(毒性成分:"_repeatValue_")重复"
	.s TmpMsgArr("itemOrder",itmid,labelDesc,itmid,itmid_"R1")="RepeatPosIngr"_"@@"_itmDesc_"和"_firstShow_"重复"
	.s TmpMsgArr("PreCondtions",itmid)=$lb("NULL")	//前提条件
	
	// 	//$lb("是否通过","通过标识","管理级别","提示信息","管制力度","提示依据","警示信息(目录维护)","提醒消息标记")
	q ""
}

/// Desc：  毒性成分判断
/// Author：Sunhuiyong
/// Input： 成分id、判断成分id list
/// Return: 存在-1 不存在-0
/// w ##Class(web.DHCCKBPassExt).CheckPosComList("120055",$lb("14150","81507","94470","12559","81506","81508","81849","81793","94472","86104"))
ClassMethod CheckPosComList(checkDrugId, posDrugIdList)
{
	n (checkDrugId,posDrugIdList)
	q:$listlength(posDrugIdList)<1 "0"
	s repeatFlag=0
	s resultStr=""
	s checkDrugIdList=##class(web.DHCCKBCommon).GetPhCatAlone(checkDrugId,1)
	s checkDrugIdStr=$listtostring(checkDrugIdList,"^")
	q:checkDrugIdStr="" "0"
	s length=$l(checkDrugIdStr,"^")
	i length>0  d
	.f i=1:1:length  d
	..s singleDrugId=$p(checkDrugIdStr,"^",i)
	..s parentf=##Class(web.DHCCKBCommon).GetPhCatWithParent(singleDrugId,1)
	..s:$listfind(parentf,"124952")>0 resultStr=singleDrugId
	s:resultStr'="" checkDrugIdStr=resultStr
	s posDrugId=""
	s comPosStr=""
	f i=1:1:$listlength(posDrugIdList) q:repeatFlag=1  d
	.s posDrugId=$list(posDrugIdList,i)
	.s comPosStrList=##class(web.DHCCKBCommon).GetPhCatAlone(posDrugId,1)
	.s:comPosStr'="" comPosStr=comPosStr_"^"_$listtostring(comPosStrList,"^")
	.s:comPosStr="" comPosStr=$listtostring(comPosStrList,"^")
	.q:comPosStr=""
	.;s:checkDrugIdStr[+comPosStr repeatFlag=1
	.s comlen=$l(comPosStr,"^")
	.f i=1:1:comlen q:repeatFlag=1  d
	..s comPosId=$p(comPosStr,"^",i)
	..q:comPosId=""
	..s:checkDrugIdStr[comPosId repeatFlag=1
	
	q repeatFlag
}

/// Desc：  判断新编药物学分类是否授权
/// Author：qunianpeng
/// Input： 科室、新编药物学分类id
/// Return: 授权1 未授权 0
/// w ##Class(web.DHCCKBPassExt).GetDrugCatAuth()
ClassMethod GetDrugCatAuth(locId, newDrugCatId) As %String
{
	n (locId, newDrugCatId)
	q:(locId="")||(newDrugCatId="") 0
	s function = "businessAuth"
	
	q:$d(^CKB.PDSS.DicLogI("SCOPE","L",locId,"DHC_CKBCommonDiction",newDrugCatId,function)) 1
	
	q 0
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-09-13
/// Descript: 		禁忌症：疾病判断逻辑 模糊匹配（his包含系统）并且不使用映射关系
/// Input:			药品id
/// w ##Class(web.DHCCKBPassExt).CheckContrainDications($lb("皮炎","头痛"),"辑行皮炎")
ClassMethod CheckContrainDications(HisList, LibList)
{
	n (HisList,LibList)
	
	q ##Class(web.DHCCKBCommonUtil).CompareFuzzyBothList(HisList,LibList)
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-09-13
/// Descript: 		适应症,用法用量: 采用双向模糊匹配（his包含系统，系统包含his）,二者满足其一即可。+映射关系。(映射关系和双向匹配都匹配一次，二者满足一起即可)
/// Input:			药品id
/// w ##Class(web.DHCCKBPassExt).CheckIndications("122",$lb("严重心肌梗塞","头痛"),"12",$lb("d肌梗塞","w头痛"))
ClassMethod CheckIndications(HisValue, HisValueExt, LibValue, LibValueExt)
{
	n (HisValue,HisValueExt,LibValue,LibValueExt)
	
	s Ret = 0
	// 先使用映射关系匹配
	s Ret=##Class(web.DHCCKBCommonUtil).CompareBothList(HisValue,LibValue)
	q:Ret=1 Ret
	
	// his包含系统
	s Ret=##Class(web.DHCCKBCommonUtil).CompareFuzzyBothList(HisValueExt,LibValueExt)
	q:Ret=1 Ret
	
	//系统包含his
	s Ret=##Class(web.DHCCKBCommonUtil).CompareFuzzyBothList(LibValueExt,HisValueExt)
	q:Ret=1 Ret
	
	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	202-02-21
/// Descript: 		his项目的忽略(给药途径和用药频率的忽略配置)
/// Input:			1忽略 0 未忽略
/// w ##Class(web.DHCCKBPassExt).IngnoreHisItm()
ClassMethod IngnoreHisItm(TmpArr, typeData, item, itemFlag)
{
	n (TmpArr,typeData,item,itemFlag)

	s exitFlag = 0 
	s checkID = $g(TmpArr("CheckDicID"))
	q:checkID="" exitFlag
	s typeProp = $select(typeData="DrugFreqData":"DrugFreq",typeData="DrugPreMetData":"DrugPreMet",1:"")
	q:typeProp="" exitFlag
	s valuelist = $g(TmpArr(typeProp_$c(1)_checkID))	// list

	f i=1:1:$ll(valuelist) q:exitFlag=1  d
	.s value = $lg(valuelist,i)
	.i $d(^CF.CKB.PDSS.IgnoreManageI("ItemFlag",typeData,value,item,itemFlag)) s exitFlag = 1

	q exitFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-03-28
/// Descript: 		审核日极量、日最大量、次极量、次最大量、日荒诞值、次荒诞值
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CheckBaseRule()
ClassMethod CheckBaseRule(ItmID, TmpArr, TmpMsgArr)
{
	n (ItmID,TmpArr, TmpMsgArr)

	s ItmID=$p(ItmID,$c(2),1)
	//s TmpArr("MustItemList",CheckDicID,CalcItm,Label)=""
	s CheckDicID=TmpArr("CheckDicID")	// 审查项目(药品)	
	s Parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+CheckDicID)),4)
	q:$lg($g(^CT.CKB.PDSS.CommonDictionD(+Parref)),2)="ChineseHerbalMedicineData" ""	// 中药饮片不审核荒诞值
	s LabelId = ##Class(web.DHCCKBCommon).GetDicIdByCode("ComDosage") 	// 用法-兜底规则
	s PatAge = ..GetPatAge(.TmpArr)	
	s TmpArr("PatAgeNum")=PatAge		
	
	s ChildFlag = $g(TmpArr("PatChildFlag"))
	k DrugBaseRuleArr
	d ..GetLimitRuleList(ItmID,LabelId,.DrugBaseRuleArr,ChildFlag) // 在兜底规则中,寻找每日总量,每日最大量,每日极限量,单次最大量、极量、单次用药量
	i (ChildFlag'=1)&&(($d(^DHCCKBMarkUseLowDose(+CheckDicID,"aldultOnce")))||($d(^DHCCKBMarkUseLowDose(+CheckDicID,"aldultDay"))))  d	// >18岁 药品的最低量不能低于常规量的1/5 2022-05-18
	.d ..CalcLowLimit(.TmpArr,.TmpMsgArr)	
	
	s CheckFlag = ..IsCheckMustItm(.TmpArr)
	s OnceCheckFlag = $lg(CheckFlag,1)
	s DayCheckFlag = $lg(CheckFlag,2)	
	q:(OnceCheckFlag=1)&(DayCheckFlag=1) ""  // 日极限量和单次极限量都审核过了,则不在审核	

	// 没有计算过单次最大量,极限量, 使用兜底规则中,每日总量、每日最大量、每日极量、单次最大量、单次极量和his的单次剂量比较
	q:('$d(DrugBaseRuleArr("OnceDose")))&&('$d(DrugBaseRuleArr("Limit"))) "" //	极限量和单次常规量都没有时，则不计算

	s Ret=0,IsCalcOnce=0
	i OnceCheckFlag=0  d	// 没有计算过单次最大量,极限量, 在兜底规则中,寻找每日总量,或单次最大量、极量和his的单次剂量比较
	.i $d(DrugBaseRuleArr("Limit"))  d  //	兜底规则中有极限量
	..s Ret = ..CalcLimitBaseRule("Limit",.DrugBaseRuleArr,.TmpArr,.TmpMsgArr)
	..s IsCalcOnce=1
	.i ((IsCalcOnce=1)&&(Ret'=0))||((IsCalcOnce=0)&&(Ret=0)) d	
	..i $d(DrugBaseRuleArr("OnceDose")) d //	兜底规则中没有次极限量，只有常规量时：则：单次荒诞值=单次的常规量*2
	...s CalcItm = "OnceAbsurdValue"
	...s Ret = ..CalcAbsurdValueBaseRule(.DrugBaseRuleArr,.TmpArr,.TmpMsgArr,CalcItm,"OnceDose")
	...s IsCalcOnce=1

	q:(Ret=0)&&(IsCalcOnce=1) "" // 单次极量已经控制住了,则不计算日极量	
	
	// 单次最大量,极限量计算通过,且没有计算过日最大量,日极限量    或者单次极限量没有计算,需要计算日极限量
	i (DayCheckFlag=0) d  
	.i $d(DrugBaseRuleArr("DayLimit"))  d  //	兜底规则中有日极量或日最大量
	..s Ret = ..CalcLimitBaseRule("DayLimit",.DrugBaseRuleArr,.TmpArr,.TmpMsgArr)
	.e  d
	..q:'$d(DrugBaseRuleArr("DrugFreq")) // 兜底规则里只有单次给药量，没有频率，没有每日给药剂量时。日荒诞值=单次荒诞值取消 2022-08-24
	..i ($d(DrugBaseRuleArr("OnceDose")))&&('$d(DrugBaseRuleArr("DayDose"))) d //	兜底规则中没有日极限量，只有次常规量时：则：日荒诞值 = 单次荒诞值=最大频次
	...s CalcItm = "DayAbsurdValue"
	...d ..GetMaxFreq(.DrugBaseRuleArr)
	...s Ret = ..CalcAbsurdValueBaseRule(.DrugBaseRuleArr,.TmpArr,.TmpMsgArr,CalcItm,"OnceDose")
	..e  d //	兜底规则中没有日极限量，只有日常规量时：则：日荒诞值 = 日常规量*2
	...s CalcItm = "DayAbsurdValue"
	...s Ret = ..CalcAbsurdValueBaseRule(.DrugBaseRuleArr,.TmpArr,.TmpMsgArr,CalcItm,"DayDose")

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	202-03-28
/// Descript: 		判断(日极限量、日最大量)  (单次极限量、单次最大量) 是否审查过  
/// Input:			1审核过 0 未审核过
/// w ##Class(web.DHCCKBPassExt).CheckBaseRule()
ClassMethod IsCheckMustItm(TmpArr)
{
	n (TmpArr)
	
	s MustItemList = ##Class(web.DHCCKBCommonUtil).MustCheckItemList() //$lb("DayDoseMax","DayDoseLimit","OnceDoseMax","OnceDoseLimit")
	s DayList = $list(MustItemList,1,2) // 两组中每一组必须计算或比较过至少一个，此时不在计算金指标
	s OnceList = $list(MustItemList,3,4)
	s CheckDicID=$g(TmpArr("CheckDicID"))	// 审查项目(药品)	
		
	s OnceCheckFlag = 0
	f i=1:1:$ll(OnceList) d
	.s OnceItem = $lg(OnceList,i)
	.i $d(TmpArr("MustItemList",CheckDicID,OnceItem)) d
	..s OnceCheckFlag = 1
	
	s DayCheckFlag = 0
	f i=1:1:$ll(DayList) d
	.s DayItem = $lg(DayList,i)
	.i $d(TmpArr("MustItemList",CheckDicID,DayItem)) d
	..s DayCheckFlag = 1	
	
	q $lb(OnceCheckFlag,DayCheckFlag)
}

/// Creator: 		qunianpeng
/// CreateDate: 	202-03-28
/// Descript: 		在兜底规则中,寻找每日总量,每日最大量,每日极限量,单次最大量、极量、单次用药量
/// Input:			ChildFlag(1:儿童,其他是成人)
/// w ##Class(web.DHCCKBPassExt).CheckBaseRule()
ClassMethod GetLimitRuleList(ItmID, LabelId, DrugBaseRuleArr, ChildFlag = 0)
{
	
	n (ItmID,LabelId,DrugBaseRuleArr,ChildFlag)
	
	// 在兜底规则中,寻找每日总量,每日最大量,每日极限量,单次最大量、极量、单次用药量
	s CheckList = $lb("DayDose","DayDoseMax","DayDoseLimit","OnceDoseMax","OnceDoseLimit")	 // "OnceDose"
	s DrugFreqList=""
	s RulID = ""
	f  s RulID = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",ItmID,LabelId,RulID))  q:RulID=""   d
	.Q:$lg($g(^CT.CKB.PDSS.RuleD(+RulID)),4)'="Release"  	// 未发布不加算在内
	.s ReMark = $lg($g(^CT.CKB.PDSS.RuleD(RulID)),2)
	.s ReName = $lg($g(^CT.CKB.PDSS.RuleD(RulID)),3)
	.q:(ChildFlag=1)&&((ReMark'["儿童")&&(ReName'["儿童"))  // 过滤非儿童的兜底规则 qnp 2022-04-26
	.q:(ChildFlag'=1)&&((ReMark["儿童")||(ReName["儿童"))	// // 过滤非成人的兜底规则
	.s RuleDataID = "" //^CT.CKB.PDSS.RuleDataI("Rule",{RD_Rule},{RD_RowID})	
	.f  s RuleDataID = $o(^CT.CKB.PDSS.RuleDataI("Rule",RulID,RuleDataID))  q:RuleDataID=""  d
	..s CalcItmID=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4) // 计算项目
	..s CalcItm=$lg($g(^CT.CKB.PDSS.CommonDictionD(+CalcItmID)),2) 
	..i CalcItm = "OnceDose" d
	...s DrugBaseRuleArr("OnceDose",RuleDataID)="OnceDose" // 记录单次用量
	..i CalcItm = "DayDose" d
	...s DrugBaseRuleArr("DayDose",RuleDataID)="DayDose" // 记录日用量
	..i $lf(CheckList,CalcItm)	 d
	...s DrugBaseRuleArr("Limit",RuleDataID)=CalcItm  // 记录每日总量,每日最大量,每日极限量,单次最大量、极量
	..i (CalcItm = "DayDoseMax")||(CalcItm = "DayDoseLimit") d
	...s DrugBaseRuleArr("DayLimit",RuleDataID)=CalcItm  // 记录每日最大量,每日极限量
	..i (CalcItm = "DrugFreq") d
	...q:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),7)="NotEquals"
	...i $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),7)="Between" d
	....s freqValue = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),12)
	....s DrugBaseRuleArr("DrugFreqNum",+freqValue)=freqValue	// 频次区间
	...e  d 
	....s freqValue = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)
	....i $lf(DrugFreqList,freqValue)=0 s $list(DrugFreqList,*+1)=freqValue
	....s DrugBaseRuleArr("DrugFreq")=DrugFreqList  // 记录每日最大量,每日极限量
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	202-03-28
/// Descript: 		计算兜底规则中的极量
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CheckBaseRule()
ClassMethod CalcLimitBaseRule(Node, DrugBaseRuleArr, TmpArr, TmpMsgArr)
{
	n (Node,DrugBaseRuleArr,TmpArr,TmpMsgArr)
	
	s Ret = 0
	s ExitFlag = 0
	s ID = ""	
	//f  s ID = $o(DrugBaseRuleArr("Limit",ID))  q:(ID="")  d
	f  s ID = $o(DrugBaseRuleArr(Node,ID))  q:(ID="")||(ExitFlag=1)  d
	.s TmpArr("ID")=ID
	.s CalcItm = $g(DrugBaseRuleArr(Node,ID))
	.s ExitFlag = ..CalcBaseRuleItem(.TmpArr,.TmpMsgArr, ID,CalcItm,.DrugBaseRuleArr,Node) // ExitFlag=1 表示审查不通过
	
	i ExitFlag=0 s Ret = 1 // 表示审查通过
	i ExitFlag=-1 s Ret = -1 		
	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	202-03-28
/// Descript: 		计算兜底规则中的极量
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CalcBaseRuleItem()
ClassMethod CalcBaseRuleItem(TmpArr, TmpMsgArr, ID, CalcItm, DrugBaseRuleArr, Node)
{
	n (TmpArr,TmpMsgArr,ID,CalcItm,DrugBaseRuleArr,Node)
	
	s CheckDicID = $g(TmpArr("CheckDicID"))	// 审查项目(药品)
	s LabelDesc = "用法用量"
	s ExitFlag = 0
	q:ID="" ExitFlag
	//q:$d(TmpArr("MustItemList",CheckDicID,CalcItm)) ""
	i Node="Limit" s CalcItm="OnceDose"
	
	/// 调用公式计算
	i ##class(web.DHCCKBPassNew).IsRequired(CalcItm)=0	d	// 根据必填配置,0表示从知识库取值
	.d ##Class(web.DHCCKBPassExt).InitValueComplex(.TmpArr,CalcItm,ID)	
	s LibValue=##class(web.DHCCKBPassNew).GetSysValue(ID,.TmpArr)	// 取出知识库规则值
	s RightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),10)	
	q:((RightType="InputLimit")||(RightType="InputUom"))&(LibValue="") -1
	q:(LibValue="")||($case($listvalid(LibValue)=0,1:"",:$listget(LibValue))="") -1	 // 取不到值或者转换失败的情况下,忽略这条规则
	
	s PatAgeNum = $g(TmpArr("PatAgeNum"))
	i CalcItm = "OnceAbsurdValue" d	
	.i (PatAgeNum>80)||((PatAgeNum<14)) d		//>80 或<14 不能超过常规量的1倍 2022/05/18
	..s $list(LibValue,1) = $lg(LibValue,1)
	.e  d	
	..s $list(LibValue,1) = $lg(LibValue,1)*2	// 单次荒诞值=单次量*2	
	
	i CalcItm = "DayAbsurdValue" d
	.i $d(DrugBaseRuleArr("DayDose")) d
	..i (PatAgeNum>80)||((PatAgeNum<14)) s $list(LibValue,1) = $lg(LibValue,1)	//>80 或<14 不能超过常规量的1倍 2022/05/18
	..e  s $list(LibValue,1) = $lg(LibValue,1)*2	// 有日剂量情况: 日荒诞值=日剂量*2
	.e  d
	..i (PatAgeNum>80)||((PatAgeNum<14)) s $list(LibValue,1) =$lg(LibValue,1)*$case($g(DrugBaseRuleArr("MaxDrugFreq"))="",1:1,:$g(DrugBaseRuleArr("MaxDrugFreq"))) // 没有日剂量情况
	..e  s $list(LibValue,1) =$lg(LibValue,1)*2*$case($g(DrugBaseRuleArr("MaxDrugFreq"))="",1:1,:$g(DrugBaseRuleArr("MaxDrugFreq"))) // 没有日剂量情况   每日荒诞值=单次荒诞值*最大频次
	
	s LibValueExt=##class(web.DHCCKBPassNew).GetSysValueExt(ID)		// 知识库别名
	s LeftKey=$case(+$d(TmpArr(CalcItm))>0,1:CalcItm,:CalcItm_$c(1)_CheckDicID) 
	s HisValue=##Class(web.DHCCKBPassExt).GetHisValue(.TmpArr, LeftKey,LibValue)
	s HisValueExt=$g(TmpArr(LeftKey,"Ext"))
	q:((RightType="InputLimit")||(RightType="InputUom"))&(HisValue="") -1 // his值为空,忽略存在问题(如:特殊人群为空,但是要根据年龄判断)-修复:系统值没有子规则的情况下，在退出(2020/12/1)	
	s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)	
	s IsChildFlag=(Value'="")&&(Value'=+CheckDicID)&&($d(^CT.CKB.PDSS.RuleDicI("Dic",Value)))
	q:(HisValue="")&($case($listvalid(HisValueExt),1:$lts(HisValueExt),:HisValueExt)="")&(IsChildFlag=0) -1 // 取不到值或者转换失败的情况下,忽略这条规则
	
	/// 计算
	s OpArith=$lg($g(^CT.CKB.PDSS.RuleDataD(+ID)),7)	
	s OpArith=##Class(web.DHCCKBPassNew).TrsOpArith(OpArith)   		// 运算符 	
	s Ret=##Class(web.DHCCKBPassNew).Compare(HisValue,HisValueExt,LibValue,LibValueExt,OpArith,RightType,.TmpArr)

	i Ret = 0  d
	.s ExitFlag = 1
	.s Limit = ""
	.i (CalcItm = "OnceAbsurdValue")||(CalcItm = "DayAbsurdValue") d
	..s Unit = $list(LibValue,3)
	..s Limit = OpArith_$fn($list(LibValue,1),"N")_$lg($g(^CT.CKB.PDSS.CommonDictionD(+Unit)),3)	// 记录荒诞值用于消息提醒
	.
	.s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,CheckDicID_"ComDosage"_ID)=$lb(0,"NotPass","forbid","","","","")
	.s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,CheckDicID_"ComDosage"_ID,ID)=LeftKey_"@@"_Limit
	.s TmpMsgArr("PreCondtions",CheckDicID_"ComDosage"_ID)=$lb("NULL")	//前提条件

	q ExitFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	202-03-28
/// Descript: 		计算兜底规则中的荒诞值
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CalcAbsurdValueBaseRule()
ClassMethod CalcAbsurdValueBaseRule(DrugBaseRuleArr, TmpArr, TmpMsgArr, CalcItm, Node)
{
	n (DrugBaseRuleArr,TmpArr,TmpMsgArr,CalcItm,Node)
	
	s Ret = 0
	//s ID = $o(DrugBaseRuleArr("OnceDose",""))
	s ID = $o(DrugBaseRuleArr(Node,""))
	s TmpArr("ID")=ID
	//s CalcItm = "OnceAbsurdValue"
	s ExitFlag = ..CalcBaseRuleItem(.TmpArr,.TmpMsgArr,ID,CalcItm,.DrugBaseRuleArr,Node)
	
	i ExitFlag=0 s Ret = 1 // 表示审查通过
	i ExitFlag=-1 s Ret=-1
	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	202-03-28
/// Descript: 		获取最大的频次系数
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CalcAbsurdValueBaseRule()
ClassMethod GetMaxFreq(DrugBaseRuleArr)
{
	n (DrugBaseRuleArr)
	
	s freqList = $g(DrugBaseRuleArr("DrugFreq"))

	k TmpFreqArr
	f i=1:1:$ll(freqList)  d
	.s freq = $lg(freqList,i)
	.s freqCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+freq)),2)
	.s freqFacList = ##Class(web.DHCCKBPassNew).GetFreqFacUom(freqCode) // ("1","49881","次/日")
	.s freq=1
	.i freqFacList="" s freq=1
	.e  s freq = $lg(freqFacList,1)
	.s:freq'="" TmpFreqArr(freq)=""
	
	s maxFreq = $o(TmpFreqArr(""),-1)
	i $d(DrugBaseRuleArr("DrugFreqNum")) d
	.s FreqLimit=$o(DrugBaseRuleArr("DrugFreqNum",""),-1)
	.s maxFreq=$case(maxFreq<FreqLimit,1:FreqLimit,:maxFreq)

	s DrugBaseRuleArr("MaxDrugFreq") = maxFreq
	
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-04-25
/// Descript: 		诊断只有查体、健康查体时，禁止
/// Input:			
/// w ##Class(web.DHCCKBPassExt).TempCheckHelathIcd()
ClassMethod TempCheckHelathIcd(pid, Itmid, TmpArr, TmpMsgArr)
{
	
	n (pid,Itmid,TmpArr,TmpMsgArr)	// 此时数组里面只有入参处理过的信息
	
	s RuleType=$g(TmpArr("Action"))	
	q:RuleType'="CheckRule" ""
	q:$g(TmpArr("globalAcc"))<=0 ""	// 全局规则的权限
	
	s LabelDesc="适应症"
	s LabelID = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr") 
	
	s DiseaseArr = $g(TmpArr("Disease","Ext"))
	s DiseaseStr = $lts(DiseaseArr)
	s Ret = 0
	i ($ll(DiseaseArr)=1)&&((DiseaseStr["健康查体")||(DiseaseStr["查体")) s Ret = 1	

	i Ret=1 d
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"D0")=$lb(0,"NotPass","forbid","适应症不适宜.","","","")
	.s TmpMsgArr("itemOrder",Itmid,LabelDesc,Itmid_"D0",Itmid)="Disease"_"@@适应症不适宜"
	.s TmpMsgArr("PreCondtions",Itmid_"D0")=$lb("NULL")	//前提条件
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-04-26
/// Descript: 		审查本品原研药(朔源药品) --应该考虑增加个配置开关: 是否用本品原研药规则审核当前药品
/// Input:			
/// w ##Class(web.DHCCKBPassExt).CheckOriginalDrugRule()
ClassMethod CheckOriginalDrugRule(itmid, TmpArr, TmpMsgArr)
{
	n (itmid, TmpArr, TmpMsgArr)
	
	// 判断药品是否有本品原研药
	s originalDrugProp = ##class(web.DHCCKBCommon).GetDicIdByCode("OriginalDrug")
	q:+originalDrugProp=0 ""
	s realItmId=$p(itmid,$c(2),1)
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",realItmId,originalDrugProp)) ""
	s attrDr = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",realItmId,originalDrugProp,""))
	q:attrDr="" ""
	s orgItmID = attrDr	
	
	
	// 获取审查目录,记录当前药品没有审核或审核通过的目录
	s ruleType = "CheckRule"
	s userInfo=$g(TmpArr("UserInfo"))
	s libaryUnionList = ##class(web.DHCCKBCommon).GetSortLibaryList(ruleType,0,2)	
	s againLibaryList = ""
	f i=1:1:$ll(libaryUnionList)  d
	.s libaryStr = $lg(libaryUnionList,i)
	.s labelId = $p(libaryStr,"^",1)
	.s labelDesc = $p(libaryStr,"^",2)
	.q:(labelDesc'="")&&($d(TmpMsgArr("itemOrder",itmid,labelDesc)))
	.i $lf(againLibaryList,labelId)=0 s $list(againLibaryList,*+1)=labelId
	
	// 使用原研药的规则,进行判断
	k TmpAgainArr
	s TmpAgainArr("libaryList") = againLibaryList
	s TmpAgainArr("orgItmID") = orgItmID 	
	d ##Class(web.DHCCKBPassNew).CheckRuleByLibary(itmid, .TmpArr, .TmpMsgArr,.TmpAgainArr)
	q ""
}

/// Descript:获取成分的级别
/// Creator:sufan
/// CreateDate:2022-04-27
/// Input:ingreId:成分Id
/// w ##Class(web.DHCCKBPassExt).GetIngreLevel()
ClassMethod GetIngreLevel(ingreId)
{
	n (ingreId)
	Q:+ingreId=0 ""
	s repDrugLevId = ##class(web.DHCCKBCommon).GetDicIdByCode("RepeatDrugLevel")
	q:+repDrugLevId=0 ""
	s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",ingreId,repDrugLevId,""))
	q:+attrId=0 ""
	s levelId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	s levCode = ""
	s:levelId'="" levCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(levelId)),2)
	Q levCode
}

/// Descript:	记录相互作用中的药品信息,用于历史医嘱的相互作用判断
/// Creator:	qunianpeng
/// CreateDate:	2022-05-12
/// Input:		TmpMsgArr, 当前审查药品,重复药品list
/// w ##Class(web.DHCCKBPassExt).MarkRepeatDrug()
ClassMethod MarkRepeatDrug(TmpMsgArr, checkDicID, repeatList)
{
	n (TmpMsgArr,checkDicID,repeatList)
	
	s drugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+checkDicID)),3)
	q:drugName="" ""
	
	f i=1:1:$ll(repeatList)  d
	.s repeatId = $lg(repeatList,i)
	.s repeatName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+repeatId)),3)
	.q:repeatName=""
	.s TmpMsgArr("repeatmsg","repeat",drugName,repeatName)=""
	.s TmpMsgArr("repeatmsg","repeat",repeatName,drugName)=""
	
	q ""
}

/// Descript:	审核历史医嘱,并且只审核相互作用
/// Creator:	qunianpeng
/// CreateDate:	2022-05-12
/// Input:		TmpArr,TmpMsgArr
/// w ##Class(web.DHCCKBPassExt).MarkRepeatDrug()
ClassMethod CheckHisOrder(TmpArr, TmpMsgArr)
{
	n (TmpArr,TmpMsgArr)
	
	s HisValue=$g(TmpArr("ItemHisOrder"))
	s ItmList=HisValue
	f i=1:1:$listlength(ItmList) d
	.s Itmid=$list(ItmList,i)
	.q:+Itmid=0
	.s TmpArr("CheckDicID")=Itmid
	.s DrugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+Itmid)),3)
	.q:DrugName=""
	.q:$d(TmpMsgArr("repeatmsg","repeat",DrugName))	// 已经存在相互作用的药品,则不在审核
	.s TmpMsgArr("RepeatModel")="his"
	.d ##Class(web.DHCCKBPassNew).CheckRuleByLibary(Itmid,.TmpArr, .TmpMsgArr)
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-05-18
/// Descript: 		获取患者年龄
/// Input:			
/// w ##Class(web.DHCCKBPassExt).GetPatAge()
ClassMethod GetPatAge(TmpArr)
{
	n (TmpArr)
	
	s PatAgeNum = ""
	s PatAge = $lts(TmpArr("AgeProp","Ext"))
	i PatAge["岁" d
	.s PatAgeNum = +PatAge
	i PatAge["月" d
	.s PatAgeNum = $fn((+PatAge)/12,"")
	.s PatAgeNum = $fn(PatAgeNum,"",2)
	i PatAge["天" d
	.s PatAgeNum = $fn((+PatAge)/365,"")
	.s PatAgeNum = $fn(PatAgeNum,"",2)
	
	q PatAgeNum
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-05-18
/// Descript: 		计算最低剂量限定
/// Input:			
/// w ##Class(web.DHCCKBPassExt).ClacLowLimit()
ClassMethod CalcLowLimit(TmpArr, TmpMsgArr)
{
	n (TmpArr,TmpMsgArr)

	s CheckDicID = $g(TmpArr("CheckDicID"))	// 审查项目(药品)
	s SysValue = ""
	s ExitFlag=0
	s CalcItm = ""
	i $d(^DHCCKBMarkUseLowDose(+CheckDicID,"aldultOnce")) d
	.s CalcItm="OnceDose"
	.s SysValue = $g(^DHCCKBMarkUseLowDose(+CheckDicID,"aldultOnce"))
	.s ExitFlag=1
	
	i (ExitFlag=0)&&($d(^DHCCKBMarkUseLowDose(+CheckDicID,"aldultDay"))) d
	.s CalcItm="DayDose"
	.s SysValue = $g(^DHCCKBMarkUseLowDose(+CheckDicID,"aldultDay"))
	
	s LibValue = $lb($p(SysValue,",",1),"",$p(SysValue,",",2))	
	s LibUnit = $p(SysValue,",",3)
	q:SysValue="" -1
	q:(CalcItm="") -1

	s ruleDataID = $p(SysValue,",",3)
	i '$d(^CT.CKB.PDSS.RuleDataD(+ruleDataID)) s ruleDataID=0	// 规则的分支和规则存在修改、新增、删除的动作,而存的最低量没有实际更新问题
	s TmpArr("ID")=ruleDataID
	s LabelDesc = "用法用量"
	s RightType="InputUom"
	s $list(LibValue,1) = $lg(LibValue,1)*(1/5)	// 常规量的1/5	
	s LibValueExt= ##class(web.DHCCKBCommon).GetDicSecondName(+LibUnit)		// 知识库别名
	s libUnitDesc = ""
	i $D(^CT.CKB.PDSS.CommonDictionD(+LibUnit)) s libUnitDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+LibUnit)),3)
	i (libUnitDesc'="")&&($lf(LibValueExt,libUnitDesc)=0) s $list(LibValueExt,*+1) = libUnitDesc
	
	s LeftKey=$case(+$d(TmpArr(CalcItm))>0,1:CalcItm,:CalcItm_$c(1)_CheckDicID) 
	s HisValue=##Class(web.DHCCKBPassExt).GetHisValue(.TmpArr, LeftKey,LibValue)
	s HisValueExt=$g(TmpArr(LeftKey,"Ext"))	
	q:(HisValue="") -1	
	q:$lg(HisValue,2)="" -1	// 单位转换有问题则不计算

	/// 计算
	s OpArith=">="	// 运算符 	
	s Ret=##Class(web.DHCCKBPassNew).Compare(HisValue,HisValueExt,LibValue,LibValueExt,OpArith,RightType,.TmpArr)
	i Ret = 0  d
	.s Limit = ""
	.s Unit = $list(LibValue,3)
	.s Limit = OpArith_$fn($list(LibValue,1),"N")_$lg($g(^CT.CKB.PDSS.CommonDictionD(+Unit)),3)	// 记录荒诞值用于消息提醒
	.s Limit = Limit_"(18岁以上患者单次/单日剂量不得低于常规剂量的1/5)"
	.
	.s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,CheckDicID_"ComDosage"_"Low")=$lb(0,"NotPass","forbid","","","","")
	.s TmpMsgArr("itemOrder",CheckDicID,LabelDesc,CheckDicID_"ComDosage"_"Low","Low")=LeftKey_"@@"_Limit
	.s TmpMsgArr("PreCondtions",CheckDicID_"ComDosage"_"Low")=$lb("NULL")	//前提条件

	q ExitFlag
}

/// Creator: 		sufan
/// CreateDate: 	2022-05-19
/// Descript: 		his诊断为空的判断
/// Input:			
/// w ##Class(web.DHCCKBPassExt).IndicatReview()
ClassMethod IndicatReview(itmid, TmpArr, TmpMsgArr)
{
	n (itmid,TmpArr,TmpMsgArr)
	s LabelDesc = "适应症"
	Q:($d(TmpArr("Disease","Ext")))&&($lg(TmpArr("Disease","Ext"))'="") ""
	s TmpMsgArr("itemOrder",itmid,LabelDesc,itmid_"D0")=$lb(0,"NotPass","forbid","诊断为空，请开具诊断！","","","")
	s TmpMsgArr("itemOrder",itmid,LabelDesc,itmid_"D0",itmid)="Disease"_"@@诊断为空，请开具诊断！"
	s TmpMsgArr("PreCondtions",itmid_"D0")=$lb("NULL")	//前提条件
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-06-21
/// Descript: 		判断字典数据是否有字典规则(子规则)
/// Input:			
/// OutPut:			1 有 0 无
/// w ##Class(web.DHCCKBPassExt).hasChildRuleFlag()
ClassMethod hasChildRuleFlag(dicID)
{
	n (dicID)
	s ret = 0 
	s exitList = $lb("ingredientData","GeneralFromData","GeneralData")
	q:+dicID=0 ret
	q:'$d(^CT.CKB.PDSS.CommonDictionD(+dicID)) ret
	q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",+dicID)) ret
	
	s count = 0
	s id = ""
	f  s id = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,id))  q:(id="")||(count>1)  d
	.s parref = $lg($g(^CT.CKB.PDSS.RuleDicD(+id)),4)
	.s parrefCdoe = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	.q:$lf(exitList,parrefCdoe)
	.s count = count + 1
	.q:count>1
	
	i count=1 s ret=1

	q ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-26
/// Descript: 		判断计算目录下的项目是否可用
/// Input:			目录id,计算项目id
/// OutPut:			1 可用, 0 不可用
/// w ##Class(web.DHCCKBPassExt).IsAvailable(91,RuleID)
ClassMethod IsAvailable(LabelID, CalcItmID)
{
	n (LabelID,CalcItmID)	
	
	s Ret = 1
	q:(+LabelID=0)||(+CalcItmID=0) Ret
	
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LabelID,+CalcItmID)) Ret

	s AbleFlag = ##class(web.DHCCKBCommon).GetAvailable()	// 是否可用
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",+LabelID,+CalcItmID,+AbleFlag)) Ret
	
	s RowID = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",+LabelID,+CalcItmID,+AbleFlag,""))
	q:'$d(^CT.CKB.PDSS.DicLinkAttrD(+RowID)) Ret
	
	s Result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+RowID)),5)
	i Result="N" s Ret = 0
	
	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-07-08
/// Descript: 		判断规则是否授权(某个医院的特有规则,只能在当前医院生效)
/// Input:			ruleId(规则序号),userInfo(用户信息)
/// OuPut:			Y 授权(当前医院可用), N 未授权(当前医院不可用)
/// w ##Class(web.DHCCKBPassExt).IsPermisRule(614391,"屈年鹏^主管药师^呼吸内科门诊^安全用药智能决策系统(开发)^东华标准版数字化医院[总院]")
/// w ##Class(web.DHCCKBPassExt).IsPermisRule(614391,"屈年鹏^主管药师^呼吸内科门诊^安全用药智能决策系统(开发)^深圳市中医院")
ClassMethod IsPermisRule(ruleId, userInfo)
{
	n (ruleId,userInfo)
	s ret = "Y"
	q:userInfo="" ret
	q:+ruleId=0 "N"
	
	s hospId=$p(userInfo,"^",5)		
	s hospId = ##class(web.DHCCKBCommon).GetHospIdByDesc(hospId) // userInfo 入参中传递的是描述,配置存的是id,暂时先转换一下	
	q:+hospId=0 ret
	
	q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",+ruleId,"businessAuth")) ret // 规则未做过授权操作,是共有的规则
		
	s pointType="D"	
	s enableFlag = $d(^CKB.PDSS.DicLogI("FunSCOPE","businessAuth","DHC_CKBRule",pointType,hospId,ruleId))	
	i +enableFlag<=0 s ret="N"	
	
	q ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-07-18
/// Descript: 		住院-临时医嘱-频次为once时,不审核频次(包医)
/// Input:			
/// OuPut:			1 审核, 0 不审核
/// w ##Class(web.DHCCKBPassExt).IgnoreSpecFreq()
ClassMethod IgnoreSpecFreq(TmpArr, itmId)
{
	n (TmpArr,itmId)
	
	q:'$d(^CT.CKB.PDSS.CommonDictionD(+itmId)) 0
	s patType = $g(TmpArr("PatType"))
	s patType = $lts(patType)
	q:patType'["住院" 1	// $s(PatType["门诊":"门诊患者",PatType["急诊":"急诊患者",PatType["住院":"住院患者",1:"")

	s checkDicID = TmpArr("CheckDicID")	// 审查项目(药品)	
	s orderPri = $g(TmpArr("OrderPriority"_$c(1)_checkDicID))
	s orderPri = $lts(orderPri)
	q:orderPri'["临时医嘱" 1

	s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+itmId)),5)
	s itmCode = ""
	i linkDr'="" s itmCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),2)
	e  s itmCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+itmId)),2)  
	q:itmCode="" 0
	q:itmCode'="DrugFreq" 1 // 用药频率	

	s leftKey = $case(+$d(TmpArr(itmCode))>0,1:itmCode,:itmCode_$c(1)_checkDicID)
	s hisValue = $g(TmpArr(leftKey,"Ext"))
	s hisValue = $lts(hisValue)

	q:hisValue="" 0
	s hisValue = $zcvt(hisValue,"U")
	q:(hisValue'="一次")&&((hisValue'="ONCE")) 1

	q 0
}

}

Import sqluser

/// Creator: 		wangxin
/// CreateDate: 	2021-2-25
/// Descript: 		知识图谱规则导入标库相关
Class web.DHCCKBRuleUpdCompareToLibrary Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript:		待导入项目列表
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).JsGetImpItemList("30",1,"")
ClassMethod JsGetImpItemList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows, page, Params)
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s num=0,^tmp("DIFF")=0
	k TmpArr
	
	s indexDrug = ""
	for  s indexDrug = $o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","Drug",indexDrug)) Q:indexDrug=""  d
	.s TmpArr(indexDrug) = ^TMPExportDrugRule("web.DHCCKBRuleUpdate","Drug",indexDrug)
	.s ItemId=$p($g(^TMPExportDrugRule("web.DHCCKBRuleUpdate","Drug",indexDrug)),"^",2)
	.D ..JudgeStateById(ItemId,indexDrug)
	.s num=num+1
	
	Q:num=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	///转换数据为Json格式
	s ListTitle="IsDiff^ItemId^ItemCode^ItemDesc^Manf^Form^RelTime^Source"
	
	s del=""""
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	s diffnum=^tmp("DIFF")
	s addnum=num-diffnum
	
	W "]"
	W ","_del_"ALL"_del_":"_num_","_del_"DIFF"_del_":"_diffnum_","_del_"ADD"_del_":"_addnum
	W "}"
	Q ""
}

/// Creator: 		wangxin
/// CreateDate: 	2021-02-24
/// Descript:		根据规则id判断规则状态--
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).JudgeStateById("123563")
ClassMethod JudgeStateById(RowId As %String, indexDrug As %String) As %String
{
	n (RowId)
	s state=$lg($g(^CT.CKB.PDSS.RuleD(RowId)),4)
	i state="Release" d          //如果该规则处于发布状态差异数+1
	.s ^tmp("DIFF")=^tmp("DIFF")+1      //记录规则差异条数
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript:		本地规则列表
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).JsGetLocalRuleList("103970"," 硝苯地平控释片30mg(上海现代制药股份有限公司)","72")
ClassMethod JsGetLocalRuleList(itemID As %String, itemCode As %String, mCataLogID As %String) As %String
{
	n (itemID,itemCode, mCataLogID)
	s ^temptest("333666") = $lb(itemID,itemCode, mCataLogID)
	s num=0
	k TmpArr
	i itemID = ""  s itemID = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(itemCode),""))
	/// 准备数据
	D ..GetImpLocalRule(itemID, mCataLogID, .TmpArr)
	
	b //
	/// 输出Json格式
	
	//s ListTitle="ruleCode^ruleDesc"

	s del=""""
	W "[" //输出json前缀串
	s RulID="",count=0
	F  s RulID=$o(TmpArr(RulID)) Q:(RulID="")||(+RulID=0)  D
	.s ruleCode=$g(TmpArr(RulID, "RulCode"))
	.s ruleDesc=$g(TmpArr(RulID, "RulDesc"))
	.//s ListData=ruleCode_"^"_ruleDesc
	.//Q:ListData=""
	.s count = count+1
	.//i count'=1 D
	.//.W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.//E  D
	.//.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.W $s(count=1:"",1:",")_"{" D ..WriChildRuleList(RulID, .TmpArr)
	.W ","_del_"ruleCode"_del_":"_del_ruleCode_del_","_del_"ruleDesc"_del_":"_del_ruleDesc_del_"}"
	.
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript:		输出规则列表--本地规则列表调用
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).WriChildRuleList("")
ClassMethod WriChildRuleList(RulID As %String, TmpArr As %String) As %String
{
	n (RulID, TmpArr)
	W """rows"":["
	s ListTitle="Level^isRel^Content"
	s Level="",count=0
	F  s Level=$o(TmpArr(RulID,Level)) Q:Level=""  D
	.s mIndex=""
	.F  s mIndex=$o(TmpArr(RulID,Level,mIndex)) Q:mIndex=""  D
	..s ListData=$g(TmpArr(RulID,Level,mIndex))
	..Q:ListData=""
	..s ListData=$s(Level["then":1,Level["else":1,1:Level)_"^"_$s(mIndex=0:"Y",1:"N")_"^"_ListData
	..s count = count+1
	..i count=1 D
	...W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript:		本地规则输出--本地规则列表调用
/// w ##class(web.DHCCKBRuleUpdCompareToLibrary).GetImpLocalRule(150, "72", .TmpArr)
ClassMethod GetImpLocalRule(itemID As %String, mCataLogID As %String, TmpArr) As %String
{
	n (itemID, mCataLogID, TmpArr)
	
	s RulDicID=""
	F  s RulDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",itemID,RulDicID)) Q:RulDicID=""  D
	.s RulID=$lg($g(^CT.CKB.PDSS.RuleDicD(RulDicID)),2) 	/// 规则ID
	.//Q:RulID'="61466"
	.s ruleCataLogID=..GetRuleCataLogID(RulID)		/// 审查目录
	.Q:(mCataLogID'="")&(mCataLogID'=ruleCataLogID)
	.//s CataLogDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleCataLogID)),3)      /// 目录描述
	.s TmpArr("RulID")=RulID, TmpArr("RuleLev")=0
	.;Q:$lg($g(^CT.CKB.PDSS.RuleD(RulID)),4)'="Release"                   /// 未发布不加算在内
	.s TmpArr(RulID, "RulDesc")=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),5)     /// 描述
	.s TmpArr(RulID, "RulCode")=$lg($g(^CT.CKB.PDSS.RuleD(RulID)),3)     /// 标识
	.s ID=""
	.F  s ID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,"if",0,ID)) Q:ID=""  D
	..s RelType=$lg($g(^CT.CKB.PDSS.RuleNodeD(ID)),3)       /// 关系类型
	..D ..ErgRule(ID, RelType, .TmpArr)
	.
	.s TmpArr("RuleLev")="888then"
	.s TmpArr(RulID, "888then", 0)="那么"
	.s ParID=""
	.F  s ParID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,"then",0,ParID)) Q:ParID=""  D
	..s ID=""
	..F  s ID=$o(^CT.CKB.PDSS.RuleDataI("Node",ParID,ID)) Q:ID=""  D
	...D ..GetRuleExp(ID, .TmpArr)
	..
	.
	.s TmpArr("RuleLev")="999else"
	.s TmpArr(RulID, "999else", 0)="否则"
	.s ParID=""
	.F  s ParID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,"else",0,ParID)) Q:ParID=""  D
	..s ID=""
	..F  s ID=$o(^CT.CKB.PDSS.RuleDataI("Node",ParID,ID)) Q:ID=""  D
	...D ..GetRuleExp(ID, .TmpArr)
	.

	Q ""
}

///  Creator: 		bianshuai
///  CreateDate: 	2020-12-17
///  Descript:		规则描述--本地规则输出调用
///  w ##Class(web.DHCCKBRuleUpdCompareToLibrary).GetRuleExp("", .TmpArr)
ClassMethod GetRuleExp(ruleDataId As %String, TmpArr) As %String
{
	n (ruleDataId, TmpArr)
	s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)				   //左侧属性
	s leftDesc=""
	s:leftDic'="" leftDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
	s leftValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),5)				//左侧值
	s leftValDec=""
	s:leftValue'="" leftValDec=$lg($g(^CT.CKB.PDSS.CommonDictionD(leftValue)),3)
	s leftType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),6)				//左侧类型
	s Operate=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),7)				    //计算符
	s OperateDesc=$s(Operate="Equals":"=",Operate="LessThen":"《=",Operate="Between":"Between",1:"")
	s rightDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)				//右侧属性
	s rightDesc=""
	s:rightDic'="" rightDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	s rightValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),9)			    //右侧属性
	s rightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),10)				//右侧类型
	s rightExt=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),11)				//右侧单位
	s rightExtDesc=""
	s:rightExt'="" rightExtDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(rightExt)),3)
	s rightLimit=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),12)			    //区间值
	//s listData=leftDic_"^"_leftDesc_"^"_leftValue_"^"_leftValDec_"^"_leftType_"^"_Operate_"^"_OperateDesc_"^"_rightDic
	//s listData=listData_"^"_rightDesc_"^"_rightValue_"^"_rightType_"^"_rightExt_"^"_rightExtDesc_"^"_rightLimit
	i OperateDesc="Between" s OperateDesc="在 ("_rightValue_" - "_rightLimit_")"_rightExtDesc_" 之间"
	s TmpArr($g(TmpArr("RulID")), $g(TmpArr("RuleLev")), ruleDataId) = leftValDec_""_leftDesc_" "_OperateDesc_" "_rightValue_" "_rightDesc_" "_rightExtDesc
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript:		遍历规则--规则描述调用
///  Input:         ParentID - , ParRelType - 关系类型(and,or)
/// w ##Class(web.DHCCKBRuleUpdCompareToLibrary).ErgRule("", "", .TmpArr)
ClassMethod ErgRule(ParentID As %String, ParRelType As %String, TmpArr) As %String
{
	n (RulID, ParentID, ParRelType, TmpArr)
	
	s RulID=$g(TmpArr("RulID"))       /// 规则ID
	s RuleLev=+$i(TmpArr("RuleLev"))  /// 层级
	s TmpArr(RulID, RuleLev, 0)=$s(ParRelType="and":"并且",ParRelType="or":"或者",1:"")
	
	/// 组规则
	s ID=""
	F  s ID=$o(^CT.CKB.PDSS.RuleDataI("Node",ParentID,ID)) Q:ID=""  D
	.D ..GetRuleExp(ID, .TmpArr)
	.
	
	/// 关联关系
	s ID="", isGrpTrue=""
	F  s ID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,"if",ParentID,ID)) Q:ID=""  D
	.s RelType=$lg($g(^CT.CKB.PDSS.RuleNodeD(ID)),3) /// 关系类型
	.D ..ErgRule(ID, RelType, .TmpArr)	
	.
	
	Q ""
}

///  Creator: 		bianshuai
///  CreateDate: 	2020-12-17
///  Descript:	    目录ID--本地规则输出调用
/// w ##Class(web.DHCCKBRuleUpdCompareToLibrary).GetRuleCataLogID("2219")
ClassMethod GetRuleCataLogID(RuleID As %String) As %String
{
	n (RuleID)
	Q:RuleID="" ""
	s ParID = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s ruleCataLogDicID=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",RuleID,ParID,""))
	Q:ruleCataLogDicID="" ""
	Q $lg($g(^CT.CKB.PDSS.RuleDicD(ruleCataLogDicID)),3)
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript:		输出规则列表
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).JsGetItemCataLog("103970")
ClassMethod JsGetItemCataLog(itemID As %String) As %String
{
	n (itemID)
	s ^tmp("JsGet")=$lb(itemID)
	k TmpArr
	s itemDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(itemID)),3) 	 /// 项目名称
	s itemForm=##Class(web.DHCCKBDrugVO).GetFormType(itemID) /// 剂型
	s itemManf=##Class(web.DHCCKBDrugVO).GetManufacturer(itemID) /// 产地
	s del=""""
	W "{"
	W " "_del_"itemDesc"_del_":"_del_itemDesc_del
	W ","_del_"itemForm"_del_":"_del_itemForm_del
	W ","_del_"itemManf"_del_":"_del_itemManf_del
	W ",""rows"":["
	s RulDicID=""
	F  s RulDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",itemID,RulDicID)) Q:RulDicID=""  D
	.s RulID=$lg($g(^CT.CKB.PDSS.RuleDicD(RulDicID)),2) 	/// 规则ID
	.s ruleCataLogID=..GetRuleCataLogID(RulID)		        /// 审查目录
	.Q:ruleCataLogID=""
	.s ruleLabelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleCataLogID)),3) /// 目录描述
	.Q:$D(TmpArr("RULE",ruleCataLogID))
	.s TmpArr("RULE",ruleCataLogID)=ruleCataLogID_"^"_ruleLabelDesc_"^"_""
	
	s ListTitle="ruleCataLogID^ruleCataLog^isModFlag"
	s index="",count=0
	F  s index=$o(TmpArr("RULE",index)) Q:index=""  D
	.s ListData=$g(TmpArr("RULE",index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]"
	W "}"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-02
/// Descript:		
/// Input:          GlobalName - global名字, FilePath - D:\\EEEE.gbl  
/// W ##Class(web.DHCCKBRuleUpdCompare).ImportGlobal("TMPExportDrugRule", "D:\TMPExportDrugRule.gof")
ClassMethod ImportGlobal(Global As %String, FilePath As %String) As %String
{
	n (Global, FilePath)
	k ^TMPExportDrugRule
	D ##Class(%Library.Global).Import("", Global, FilePath)
	Q 0
}

/// Creator: 		wangxin
/// CreateDate: 	2021-01-26    
/// Descript:		导入规则列表    ^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp","黄体酮注射液20mg（浙江仙琚制药股份有限公司）")
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).JsImportLocalRuleList("黄体酮注射液20mg（浙江仙琚制药股份有限公司）","72")
ClassMethod JsImportLocalRuleList(ItemDesc As %String, mCataLogID) As %String
{
	n (ItemDesc,mCataLogID)
    s del=""""
    s counum=0 
    
    /*W "[" //输出json前缀串
    s ruleCode=""
    f  s ruleCode=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode)) Q:ruleCode=""  D
    .s catId=""
    .f  s catId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId)) Q:catId=""  D
    ..Q:(mCataLogID'="")&(mCataLogID'=catId)
    ..s ruleDesc=""
	..f  s ruleDesc=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc)) Q:ruleDesc=""  D
	...s ruleLev=""
    ...s counum=counum+1
	...W $s(counum=1:"",1:",")_"{" 
	...W """rows"":["
	...s count=0
    ...s flagif=0,flagthen=0,flagelse=0
	...f  s ruleLev=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,ruleLev))  Q:ruleLev=""  D
	....s rowId=""
	....f  s rowId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,ruleLev,rowId))  Q:rowId=""  D
	.....s data=$g(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,ruleLev,rowId))
	.....s leftValDec=$p(data,"^",4)    
	.....s leftDesc=$p(data,"^",2)
	.....s OperateDesc=$p(data,"^",7)
	.....s rightValue=$p(data,"^",10)
	.....s rightDesc=$p(data,"^",9)
	.....s rightExtDesc=$p(data,"^",13)
	.....s rightLimit=$p(data,"^",14)
	.....s type=$p(data,"^",16)
	.....s ListTitle="Level^isRel^Content"
	.....;w type,!
	.....i (type="if")&&(flagif=0) d
	......s count=count+1
	......s flagif=1
	......s ListData=0_"^"_$s(rowId=0:"Y",1:"N")_"^"_"并且"
	......i count=1 d
    .......W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    ......e  d
    .......W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    .....i (type="else")&&(flagelse=0) d
	......s flagelse=1
	......s ListData=0_"^"_$s(rowId=0:"Y",1:"N")_"^"_"否则"
    ......W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    .....i (type="then")&&(flagthen=0) d
	......s flagthen=1
	......s ListData=0_"^"_$s(rowId=0:"Y",1:"N")_"^"_"那么"
    ......W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    ......
	.....i OperateDesc="Between" s OperateDesc="在 ("_rightValue_" - "_rightLimit_")"_rightExtDesc_" 之间"
	.....s ListData=leftValDec_""_leftDesc_" "_OperateDesc_""_rightValue_" "_rightDesc_" "_rightExtDesc
	.....s ListData=$s(ruleLev["then":1,ruleLev["else":1,1:ruleLev)_"^"_$s(rowId=0:"Y",1:"N")_"^"_ListData
	.....W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	...W "]"
	...W ","_del_"ruleCode"_del_":"_del_ruleCode_del_","_del_"ruleDesc"_del_":"_del_ruleDesc_del_"}"
	W "]" */
	
	
	
	W "[" //输出json前缀串
    s ruleCode=""
    f  s ruleCode=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode)) Q:ruleCode=""  D
    .s catId=""
    .f  s catId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId)) Q:catId=""  D
    ..Q:(mCataLogID'="")&(mCataLogID'=catId)
    ..s ruleDesc=""
	..f  s ruleDesc=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc)) Q:ruleDesc=""  D
	...          //根据CopyLog表,使用唯一标识判断该规则是否已经添加到标库,若存在,则前端不再显示
	...s rowId=""
    ...s counum=counum+1
	...W $s(counum=1:"",1:",")_"{" 
	...W """rows"":["
	...s count=0
    ...s flagif=0,flagthen=0,flagelse=0,flagiflev=0
	...f  s rowId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId))  Q:rowId=""  D
	....s ruleLev=""
	....f  s ruleLev=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId,ruleLev))  Q:ruleLev=""  D
	.....s data=$g(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId,ruleLev))
	.....s leftValDec=$p(data,"^",4)    
	.....s leftDesc=$p(data,"^",2)
	.....s OperateDesc=$p(data,"^",7)
	.....s rightValue=$p(data,"^",10)
	.....s rightDesc=$p(data,"^",9)
	.....s rightExtDesc=$p(data,"^",13)
	.....s rightLimit=$p(data,"^",14)
	.....s type=$p(data,"^",16)
	.....s ListTitle="Level^isRel^Content"
	.....i (type="if")&&(flagif=0) d
	......s count=count+1
	......s flagif=1
	......s ListData=0_"^"_$s(rowId=0:"Y",1:"N")_"^"_"并且"
	......i count=1 d
    .......W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    ......e  d
    .......W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    .....i (type="else")&&(flagelse=0) d
	......s flagelse=1
	......s ListData=0_"^"_$s(rowId=0:"Y",1:"N")_"^"_"否则"
    ......W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    .....i (type="then")&&(flagthen=0) d
	......s flagthen=1
	......s ListData=0_"^"_$s(rowId=0:"Y",1:"N")_"^"_"那么"
    ......W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
    ......
	.....i OperateDesc="Between" s OperateDesc="在 ("_rightValue_" - "_rightLimit_")"_rightExtDesc_" 之间"
	.....s ListData=leftValDec_""_leftDesc_" "_OperateDesc_""_rightValue_" "_rightDesc_" "_rightExtDesc
	.....s ListData=$s(ruleLev["then":1,ruleLev["else":1,1:ruleLev)_"^"_$s(rowId=0:"Y",1:"N")_"^"_ListData
	.....W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	...W "]"
	...W ","_del_"ruleCode"_del_":"_del_ruleCode_del_","_del_"ruleDesc"_del_":"_del_ruleDesc_del_"}"
	W "]"
	
	
	Q ""
}

/// Creator: 		wangxin
/// CreateDate: 	2021-01-28 
/// Descript:		插入一条规则到中间表    差异导入
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).GetImportRuleByruleDesc("  硝苯地平控释片30mg(上海现代制药股份有限公司)","dhcckb,65736,80828.792328")
ClassMethod GetImportRuleByruleDesc(ItemDesc As %String, ruleDesc As %String) As %String
{
   n (ItemDesc,ruleDesc)
   k ^tmp("web.DHCCKBRuleUpdCompare","GetImportRuleByruleDesc")
   
   s count=0
   s ruleCode=""
   f  s ruleCode=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode)) Q:ruleCode=""  D
   .s catId=""
   .f  s catId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId)) Q:catId=""  D
   ..s ruleLev=""
   ..f  s ruleLev=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,ruleLev))  Q:ruleLev=""  D
   ...s rowId=""
   ...f  s rowId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,ruleLev,rowId))  Q:rowId=""  D
   ....s data=$g(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,ruleLev,rowId))
   ....s count=count+1
   ....s ^tmp("web.DHCCKBRuleUpdCompare","GetImportRuleByruleDesc",ruleDesc,count)=data
   ...s sqlCode=##class(web.DHCCKBInsertRule).InsertRuleByrule(ItemDesc,ruleDesc,ruleCode,ruleLev)
   s sqlCode=""
   q sqlCode
}

/// Creator: 		wangxin
/// CreateDate: 	2021-02-23
/// Descript:		规则插入中间表    一键导入
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).GetImportIncRuleByruleDescDemo("11870^8^1^289^2")
ClassMethod GetImportIncRuleByruleDescDemo(loginInfo As %String) As %String
{
   n (loginInfo)
   k ^tmp("web.DHCCKBRuleUpdCompare","GetImportIncRuleByruleDesc")
   TS  //开启事务
   s count=0
   s sqlCode=""
   s ItemDesc=""
   f  s ItemDesc=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc)) Q:ItemDesc=""  D
   .s ruleCode=""
   .f  s ruleCode=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode)) Q:ruleCode=""  D
   ..s catId=""
   ..f  s catId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId)) Q:catId=""  D
   ...s ruleDesc=""
   ...f  s ruleDesc=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc))  Q:ruleDesc=""  D
   ....s rowId=""
   ....f  s rowId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId))  Q:rowId=""  D
   .....s ruleLev=""
   .....f  s ruleLev=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId,ruleLev))  Q:ruleLev=""  D
   ......s data=$g(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId,ruleLev))
   ......s count=count+1
   ......s ^tmp("web.DHCCKBRuleUpdCompare","GetImportIncRuleByruleDesc",ruleDesc,count)=data
   ....s sqlCode=##class(web.DHCCKBInsertIncRule).InsertIncRuleByrule(ItemDesc,ruleDesc,ruleCode,loginInfo)  //插入临时规则表
   TC   //关闭事务
   q sqlCode
}

}

Import SQLUser

/// Creator：      zhouxin
/// CreatDate：    2019-06-20
/// Description:： 知识规则主界面
Class web.DHCCKBRuleIndex Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 输出规则项目树
ClassMethod ListRuleIndexTree()
{
	s root=[]
	s projectCKB={}.%Set("id","ckb").%Set("text","知识库")       //知识库
	s projectEM={}.%Set("id","em").%Set("text","急诊")           //急诊
	d root.%Push(projectCKB)
	d root.%Push(projectEM)
	//
	
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() 
	
	
	
	s DrugCat={}
	d DrugCat.%Set("id","DrugCat").%Set("text","药学分类")
	d DrugCat.%Set("children",##class(web.DHCCKBRuleIndex).GetJsonsByParentCode("DrugCat"))
	s GenName={}
	d GenName.%Set("id","GenName").%Set("text","通用名")
	d GenName.%Set("children",##class(web.DHCCKBRuleIndex).GetJsonsByParentCode("GenName"))
	s Drug={}
	d Drug.%Set("id","Drug").%Set("text","药品")
	d Drug.%Set("children",##class(web.DHCCKBRuleIndex).GetJsonsByParentCode(DrugData))
	
	s rootCKB=[].%Push(DrugCat).%Push(GenName).%Push(Drug)
	d projectCKB.%Set("children",rootCKB)

	d root.%ToJSON()
	q ""
}

/// 通过父节点获取子元素
/// q ##class(web.DHCCKBRuleIndex).GetJsonsByParentCode("DrugLibrary")
ClassMethod GetJsonsByParentCode(dr)
{
	n (dr)
	s retArr=[]
	q:+dr=0 retArr
	
	s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(dr)),2)
	
	s h=0
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dr,id)) q:id=""  d
	.q:+id=0
	.s variable=##class(%DynamicObject).%New()
    .s variable.id=id
    .s variable.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .d variable.%Set("children",##class(web.DHCCKBRuleIndex).GetDrugLibrary(id))
    .d retArr.%Push(variable)
	q retArr
}

/// w ##class(web.DHCCKBRuleIndex).GetDrugLibrary("90639",0,"1^1^1^1^2").%ToJSON()
ClassMethod GetDrugLibrary(dicId = 0, rule = 0, userInfo = 0, model = "")
{
	
	n (dicId,rule,userInfo,model)

	s DrugLibrarys=[]
	//s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()

	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugLibary,id)) q:id=""  d
	.q:+id=0
	.q:(model="tmpquit")&(0=##class(web.DHCCKBRulePriority).TmpQuitDrugLibrary($lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)))
	.q:0=##class(web.DHCCKBCommon).IsShow(id,"DHC_CKBCommonDiction",userInfo)	// qunianpeng 2020/3/30 是否停用
	.;q:(+dicId'=0)&("N"=##class(web.DHCCKBCommon).IsExistLibaryRule(dicId,id))	//  qunianpeng 2020/8/03 过滤没有规则的目录
	.s DrugLibrary={}
	.s DrugLibrary.id=id
	.s DrugLibrary.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d
	..d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndex).GetTreeSubNode(dicId,id,rule,userInfo))
	.e  d
	..i +dicId'=0 d
	...s DrugLibrary.relation=dicId
	...//查找有的规则
	...d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dicId,id,rule,userInfo))
	..e  i rule'=0 d
	...d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dicId,id,rule,userInfo))
	.d DrugLibrarys.%Push(DrugLibrary)
	q DrugLibrarys
}

/// Descript:目录多级查询子节点及规则
/// Creator:sufan
/// CreateDate:2020-05-25
/// Input:药品Id,上级，规则，登录信息
ClassMethod GetTreeSubNode(dicId, parentId, rule = 0, userInfo = 0)
{
	n (dicId,parentId,rule,userInfo)
	s subArr = []
	s subId = ""
	for  s subId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parentId,subId)) Q:subId=""  d
	.//q:(+dicId'=0)&("N"=##class(web.DHCCKBCommon).IsExistLibaryRule(dicId,subId))	//  qunianpeng 2020/8/03 过滤没有规则的目录
	.q:0=##class(web.DHCCKBCommon).IsEnabled(subId)
	.s subData = {}
	.d subData.%Set("id",subId)
	.d subData.%Set("text",$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3))
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",subId))  d
  	..d subData.%Set("children",##class(web.DHCCKBRuleIndex).GetTreeSubNode(dicId,subId,rule,userInfo))
	.i +dicId'=0 d
    ..s subData.relation=dicId
    ..//查找有的规则
    ..i ((subData.%IsDefined("children")=1)&&(subData.%Get("children").%ToJSON()="[]"))||(subData.%IsDefined("children")=0) d
    ...d subData.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dicId,subId,rule,userInfo))
    .e  i rule'=0 d
    ..i ((subData.%IsDefined("children")=1)&&(subData.%Get("children").%ToJSON()="[]"))||(subData.%IsDefined("children")=0) d
    ...d subData.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dicId,subId,rule,userInfo))
    .d subArr.%Push(subData)
    Q subArr
}

/// w ##class(web.DHCCKBRuleIndex).GetRuleByDic(22,33).%ToJSON()
ClassMethod GetRuleByDic(dic, relation = 0, rule = 0, userInfo)
{
	n (dic,relation,rule,userInfo)
	s unlock="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/unlock.png' border=0/>"
	s lock="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/lock.png' border=0/>"
	s lockcon = "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>"
	
	s retArr=[]
	i +dic'=0 d
	.s id="" f  s id=$o(^CT.CKB.PDSS.RuleDicI("Dic",dic,id)) q:id=""  d	
	..s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(id)),2)
	..q:$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Stop"
	..s realstatus=$case($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release",1:lock,:unlock)
	..s conFlag=..getRuleSignsNew(ruleId)			//sufan 2020-11-05
	..s:($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release")&&(conFlag=1) realstatus = lockcon
	..i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,relation)) d
	...q:'$d(^CT.CKB.PDSS.RuleD(ruleId))
	...s RdId=$o(^CT.CKB.PDSS.RuleDataI("RightExt","Input",-100000000000000,ruleId,""))
	...s RightValue=""
	...s:RdId'="" RightValue=$lg($g(^CT.CKB.PDSS.RuleDataD(RdId)),9)
	...;s RightValue=$e(RightValue,1,5)
	...q:0=..IsRuleShow(ruleId,userInfo)	// qunianpeng 2020/3/30 判断规则是否显示
	...s ruleJson={}
	...d ruleJson.%Set("id",ruleId)
	...d ruleJson.%Set("ruleId",ruleId)
	...d ruleJson.%Set("text",realstatus_"("_ruleId_RightValue_")"_$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3))
	...d retArr.%Push(ruleJson)
	i rule'=0 d
	.
	.s ruleDicStr=##class(web.DHCCKBRuleIndex).GetRuleDicStr(rule)
	.s id="" f  s id=$o(^CT.CKB.PDSS.RuleDicI("Dic",relation,id)) q:id=""  d
	..
	..s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(id)),2)
	..q:$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Stop"
	..s realstatus=$case($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release",1:lock,:unlock)
	..s conFlag=..getRuleSignsNew(ruleId)			//sufan 2020-11-05
	..s:($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release")&&(conFlag=1) realstatus = lockcon
	..s ruleIdDicStr=##class(web.DHCCKBRuleIndex).GetRuleDicStr(ruleId)
	..//w ruleIdDicStr_"||"_ruleDicStr,!
	..q:ruleDicStr'=ruleIdDicStr
	..s RdId=$o(^CT.CKB.PDSS.RuleDataI("RightExt","Input",-100000000000000,ruleId,""))
	..s RightValue=""
	..s:RdId'="" RightValue=$lg($g(^CT.CKB.PDSS.RuleDataD(RdId)),9)
	..;s RightValue=$e(RightValue,1,5)
	..q:..IsRuleShow(ruleId,userInfo)=0	// qunianpeng 2020/3/30 判断规则是否显示
	..s ruleJson={}
	..d ruleJson.%Set("id",ruleId)
	..d ruleJson.%Set("ruleId",ruleId)
	..d ruleJson.%Set("text",realstatus_"("_ruleId_RightValue_")"_$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3))
	..d retArr.%Push(ruleJson)
	q retArr
}

/// 输出公共规则项目树
/// w ##class(web.DHCCKBRuleIndex).ListCommonRuleIndexTree("11870^8^1^289^2")
ClassMethod ListCommonRuleIndexTree(LoginInfo)
{
	s retArr=[]
	s AddRuleFlag=##class(web.DHCCKBCommon).GetAddRuleFlag()
	s link="" f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",AddRuleFlag,link)) q:link=""  d
	.
	.s dic=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),2)
	.
	.s ruleJson={}
	.d ruleJson.%Set("id",dic)
	.d ruleJson.%Set("relation",AddRuleFlag)
	.d ruleJson.%Set("text",$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3))
	.d ruleJson.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dic,dic,0,LoginInfo))
	.d retArr.%Push(ruleJson)
	d retArr.%ToJSON()
	q ""
}

/// 输出全局规则项目树
/// w ##class(web.DHCCKBRuleIndex).ListGlobalRuleIndexTree()
ClassMethod ListGlobalRuleIndexTree(LoginInfo)
{
	s retArr=[]
	s globalData=##class(web.DHCCKBCommon).GetGlobalData()
	s AddRuleFlag=""
	
	s dic=""
	f  s dic=$o(^CT.CKB.PDSS.CommonDictionI("Parref",globalData,dic))	q:dic=""   d
	.s ruleJson={}
	.d ruleJson.%Set("id",dic)
	.d ruleJson.%Set("code",$case(dic'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),2),:""))
	.d ruleJson.%Set("text",$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3))
	.d ruleJson.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dic,dic,0,LoginInfo))
	.d retArr.%Push(ruleJson)
	d retArr.%ToJSON()
	q ""
}

/// 获取知识目录tree
/// W ##class(web.DHCCKBRuleIndex).GetDrugLibraryTree("123937",0,"11871^8^1^289^2")
ClassMethod GetDrugLibraryTree(dic, rule = 0, userInfo = 0)
{
	n (dic,rule,userInfo)
	w ##class(web.DHCCKBRuleIndex).GetDrugLibrary(dic,+rule,userInfo).%ToJSON()
	q ""
}

/// 输出规则项目树
/// w ##class(web.DHCCKBRuleIndex).ListModelTree("Herbal")
ClassMethod ListModelTree(drugType = "")
{
	n (drugType)
	s retArr=[]
	s DirTemp=##class(web.DHCCKBCommon).GetDirTemp()
	
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DirTemp,id)) q:id=""  d
	.s model={}
    .s model.id=id
    .s model.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .q:1=##class(web.DHCCKBCommon).CheckDrugType(drugType,model.text)	// 增加药品类型过滤 qnp 2021/6/24
    .s children=[]
    .s subId="" f  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,subId)) q:subId=""  d
    ..s subModel={}
    ..s subModel.id=subId
    ..s subModel.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3)
    ..q:1=##class(web.DHCCKBCommon).CheckDrugType(drugType,subModel.text)	// 增加药品类型过滤 qnp 2021/6/24
    ..d children.%Push(subModel)
    .d model.%Set("children",children)
	.d retArr.%Push(model)
	w retArr.%ToJSON()
	q ""
}

/// 动态输出模板的datagrid的表头
/// w ##class(web.DHCCKBRuleIndex).ListModelDataGrid(81839)
ClassMethod ListModelDataGrid(parent)
{
	
	n (parent)
	s columns=[]
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempEleId=##class(web.DHCCKBCommon).GetTempEleId()
	s id="" f  s id=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",parent,TempEleId,id),-1) q:id=""  d
	.s link=id  ;+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.;q:link=0
	.//界面显示列
	.s column={}
	.s data=link  
    .s column.field=data
    .;s column.width=200  ; 2022-05-12 cy 列宽自适应
    .s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),5)
    .i (title="")&&(LinkId'="") s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
    .s column.title=title  //$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .d column.%Set("hidden",0,"boolean")
	.s column.editor={}.%Set("type","validatebox")
	.d columns.%Push(column)
	.//界面隐藏列
	.s columnHidden={}
	.s data=link 
    .s columnHidden.field=data_"Id"
    .s columnHidden.width=200
    .s columnHidden.title=data
	.s columnHidden.editor={}.%Set("type","validatebox")
	.d columnHidden.%Set("hidden",1,"boolean")
	.d columns.%Push(columnHidden)
	w columns.%ToJSON()
	q ""
}

/// 动态输出模板的datagrid的数据
/// w ##class(web.DHCCKBRuleIndex).ListModelData("97","1","30")
ClassMethod ListModelData(parent, page, rows)
{
	
	n (parent,page,rows)
	s ^temptest("model")=$lb(parent,page,rows)
    s start=(page-1)*rows+1
    s end=page*rows
	
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	
	s dic=0,TitleStr="ID",columnCount=1,dicStr=""
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parent,id)) q:id=""  d
	.s link=+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.
	.q:link=0
	.s dic=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic_"Id"
	.
	.i dicStr="" d
	..s dicStr=dic
	.e  d
	..s dicStr=dic_"^"_dicStr

	k ruelDicList
	w "{""rows"":["	
	s count=0
	s ruleDic="" f  s ruleDic=$o(^CT.CKB.PDSS.RuleDicI("ParentDic",dic,ruleDic)) q:ruleDic=""  d
	.
	.s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDic)),2)
	.s ruleDicStr=##class(web.DHCCKBRuleIndex).GetRuleDicStr(rule)
	.q:$d(ruelDicList(ruleDicStr))
	.s ruelDicList(ruleDicStr)=1
	.q:##class(web.DHCCKBRuleIndex).CheckRuleMatch(rule,dicStr)=0
	.s flagCount=1,ValueStr=""
	.s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parent,id)) q:id=""  d
	..s link=+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	..q:link=0
	..s parentDic=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	..s tmp=+$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,parentDic,""))
	..q:tmp=0
	..s dataDic=$lg($g(^CT.CKB.PDSS.RuleDicD(tmp)),3)
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataDic)),3)
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=dataDic
	.
	.
	.s $p(ValueStr,"^",1)=rule
    .s count=count+1
    .q:count<start
    .q:count>end
    .w $case(count,start:"",:",")
    .w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,ValueStr)
    w "],""total"":"_count_"}"
    k ruelDicList
	q ""
}

/// Descript:按照设置的模板取数据
/// Creator:sufan
/// CreateDate:2020-02-14
/// 动态输出模板的datagrid的数据
/// w ##class(web.DHCCKBRuleIndex).ListModelDataNew("89630","2","30","")
ClassMethod ListModelDataNew(parent, page, rows, Input, drugID = "", hospId = "")
{
	
	n (parent,page,rows,Input,drugID,hospId)  //xww 增加drugID 2021-8-06
	
	s hospDesc = $p($g(^CT("HOSP",+hospId)),"^",2)
    s start=(page-1)*rows+1	
    s end=page*rows
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()			//取数据源Id
	s TempEleId=##class(web.DHCCKBCommon).GetTempEleId()
	s PrimaryKey=##class(web.DHCCKBCommon).GetPrimaryKey()			//主键
	s Input=$zcvt(Input,"U")   // xww 2022-07-18 转成大写
	s PaDataId=""
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",PropIdStr=""					//取每列的数据源以及组织输出title
	s id="" f  s id=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",parent,TempEleId,id),-1) q:id=""  d
	.s link=+id  ;+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.q:link=0
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,PrimaryKey))  d
	..s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,PrimaryKey,""))
	..s DictionId=##class(web.DHCCKBRangeCat).GetAddAttrSource(link,"DataSource")
	..s AttrFlagId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	..s:$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrFlagId)),3)="Y" PaDataId=DictionId
	.i PropIdStr=""  d
	..s PropIdStr=id
	.e  d
	..s PropIdStr=PropIdStr_"^"_id
	.s dic=id 
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic_"Id"
	.
	.i dicStr="" d
	..s dicStr=dic
	.e  d
	..s dicStr=dic_"^"_dicStr	
										///每列的数据源串，默认以第一个的数据源为索引取值
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ListModelDataNew")
	///默认以第一个的数据源为索引取值

	k AtrrValueList
	s ParDicId=$p(dicStr,"^",1)
	s ListData=""
	s h=0
	
	//xww 2021-08-06 药品ID不为空，直接取值不进行遍历
	i drugID'="" d
	.s ListData=..GetPropValue(drugID,PropIdStr)
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBRuleIndex","ListModelDataNew",pid,h)=ListData
	
	s DrugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s ChineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s ChinaHMDrugData=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片字典
	s DrugList = $lb(DrugData,ChineseDrugData,ChinaHMDrugData)
	
	s DicId=""
	for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")||(drugID'="")  d
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	.q:Code=""
	.q:($lf(DrugList,PaDataId)>0)&&(hospId'="")&&(hospDesc'["东华标准版数字化医院")&&('$d(^CKB.PDSS.ComContrastI("HospLibCode",+hospId,$$UPPER^SSUTIL4(Code))))
	.s Alias=##class(web.DHCCKBCommonUtil).GetPYCODE(Desc)  //xww 2022-07-18 获取描述首拼 ""  //..GetDrugAlias(DicId)			//取别名
	.s QuitStr=Desc_Code_Alias
	.Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	.Q:(Input'="")&&(QuitStr'[Input)
	.s ListData=..GetPropValue(DicId,PropIdStr)
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBRuleIndex","ListModelDataNew",pid,h)=ListData

	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s count=0
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBRuleIndex","ListModelDataNew",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCCKB","web.DHCCKBRuleIndex","ListModelDataNew",pid,Index)
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ListModelDataNew")
	q ""
}

/// Descript:取别名
/// Creator:sufan
/// CreateDate:2020-04-14
/// Input:药品ID
/// w ##class(web.DHCCKBRuleIndex).GetDrugAlias(100894)
ClassMethod GetDrugAlias(DrugId, Alias = "")
{
	n (DrugId,Alias)
	q ..GetDrugAliastest(DrugId,Alias)
	
	s Parref=##class(web.DHCCKBRuleImport).GetDicParrefId(DrugId)					//取上级元素
	s LinkPropID=##class(web.DHCCKBRangeCat).GetAttrLink(Parref,"LinkProp")			//取属性关联
	s ParPropId=""
	i LinkPropID'="" d
	.s AttrRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Parref,LinkPropID,""))					
	.s:AttrRowID'="" ParPropId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrRowID)),4)									//取关联的属性
	s AliasPropId=##class(web.DHCCKBCommon).GetDicIdByCode("OtherNameProp")			//别名属性
	s LinkAlisId=""
	i ParPropId'=""	 d																//取关联的别名属性
	.s LinkAlisId=..GetLinkAlias(ParPropId,AliasPropId)	
	i LinkAlisId'="" s AliasPropId=LinkAlisId	
	s AliasList=""
	s AliasList=..GetAlias(DrugId,AliasPropId,Alias)								//查询别名
	
	Q AliasList
}

/// Descript:取别名测试
/// Creator:sufan
/// CreateDate:2020-04-14
/// Input:药品ID
/// w ##class(web.DHCCKBRuleIndex).GetDrugAliastest(3913)
ClassMethod GetDrugAliastest(DrugId, Alias = "")
{
	n (DrugId,Alias)

	s AliasPropId=##class(web.DHCCKBCommon).GetDicIdByCode("OtherNameProp")			//别名属性
	
	s ret=""
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DrugId,AliasPropId))  d
	.s ret=AliasPropId
	e  d
	.s Id=""
	.for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Link",AliasPropId,Id))  Q:(Id="")||(ret'="")  d
	..Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DrugId,Id))
	..s ret=Id

	q:(ret="") ""
	s AliasList=..GetAlias(DrugId,ret,Alias)								//查询别名
	
	Q AliasList
}

/// Descript:取关联的别名属性
/// w ##class(web.DHCCKBRuleIndex).GetLinkAlias(49541,26947)
ClassMethod GetLinkAlias(ParPropId, AliasPropId)
{
	n (ParPropId,AliasPropId)
	s ret=""
	s Id=""
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParPropId,Id))  Q:Id=""  d
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),5)
	.Q:AliasPropId'=LinkId
	.s ret=Id
	Q ret
}

/// Descript:取别名
/// Creator:sufan
/// CreateDate:2020-04-14
/// Input:药品ID
/// w ##class(web.DHCCKBRuleIndex).GetAlias(150)
ClassMethod GetAlias(DrugId, AliasPropId, Alias = "")
{
	n (DrugId, AliasPropId,Alias)
	s RetList=""
	s AliasId="0"
	for  s AliasId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",DrugId,AliasPropId,AliasId)) Q:AliasId=""  d
	.s Flag=$d(^CT.CKB.PDSS.CommonDictionD(AliasId))
	.q:Flag=0  ///表内无数据跳过  ld  2022-8-18
	.s AliasDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AliasId)),3)
	.Q:AliasDesc'[Alias
	.i RetList="" s RetList=AliasDesc
	.e  s RetList=RetList_","_AliasDesc
	Q RetList
}

/// Descript:取属性值
/// Creator:sufan
/// CreateDate:2020-02-14
/// w ##class(web.DHCCKBRuleIndex).GetPropValue(150,"81224^44^40")
ClassMethod GetPropValue(DicId, PropList)
{
	n (DicId,PropList)
	s Len=$L(PropList,"^")
	s ListData=""
	k PropValList
	k PropAttrList
	i Len>1  d
	.for i=2:1:Len  d
	..s PropId=$p(PropList,"^",i)
	..s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(PropId)),5)
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,PropId))   d
	...s Index=DicId_"^"_PropId	
	...s LinkAttrId=""		
	...for  s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,PropId,LinkAttrId))  Q:LinkAttrId=""  d
	....s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)		//属性值
	....i AttrId'=""  d									//取属性值
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),3)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	.....i $d(PropAttrList(Index)) s PropAttrList(Index)=PropAttrList(Index)_"&"_AttrId
	.....e  s PropAttrList(Index)=AttrId
	....e   d											//取备注
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),5)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	...s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	...s RuleImg=$s(ruleFlag=1:Img,1:"")
	...s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",DicId,"confirm"))	// 药品核实 2021/1/30 qnp
	...s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	...s confirmImg=$case(drugConfirmFlag>0,1:confirmImg,:"")
	...i ListData="" s ListData=DicId_"^"_RuleImg_confirmImg_$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...e  s ListData=ListData_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	..e  i (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,LinkId))) d
	...s Index=DicId_"^"_LinkId	
	...s LinkAttrId=""
	...for  s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,LinkId,LinkAttrId))  Q:LinkAttrId=""  d
	....s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)		//属性值
	....i AttrId'=""  d									//取属性值
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),3)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	.....i $d(PropAttrList(Index)) s PropAttrList(Index)=PropAttrList(Index)_"&"_AttrId
	.....e  s PropAttrList(Index)=AttrId
	....e  d
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),5)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	...s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	...s RuleImg=$s(ruleFlag=1:Img,1:"")
	...s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",DicId,"confirm"))	// 药品核实 2020/1/30 qnp
	...s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	...s confirmImg=$case(drugConfirmFlag>0,1:confirmImg,:"")
	...i ListData="" s ListData=DicId_"^"_RuleImg_confirmImg_$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...e  s ListData=ListData_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	..e  d
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	...s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	...s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	...s RuleImg=$s(ruleFlag=1:Img,1:"")
	...i ListData="" s ListData=DicId_"^"_RuleImg_DicDesc_"^"_DicId
	e  d
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	.s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	.s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s RuleImg=$s(ruleFlag=1:Img,1:"")
	.s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",DicId,"confirm"))	// 药品核实 2020/1/30 qnp
	.s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	.s confirmImg=$case(drugConfirmFlag>0,1:confirmImg,:"")
	.s ListData=DicId_"^"_RuleImg_confirmImg_DicDesc_"^"_DicId
	k PropValList
	k PropAttrList
	Q ListData
}

/// 获取规则里的字典id串
/// w ##class(web.DHCCKBRuleIndex).GetRuleDicStr(988)
/// 288^643^1195
ClassMethod GetRuleDicStr(rule)
{
	n (rule)
	q:+rule=0 ""
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s count=0,str=""
	s dic="" f  s dic=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,dic)) q:dic=""  d
	.//过滤目录
	.q:$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),4)=DrugLibary
	.s count=count+1
	.s $p(str,"^",count)=dic
	q str
}

/// 获取规则里的字典id串
/// w ##class(web.DHCCKBRuleIndex).CheckRuleMatch(988)
/// 288^643^1195
ClassMethod CheckRuleMatch(rule, dicStr)
{
	n (rule,dicStr)
	//s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	
	
	s dicStr="^"_dicStr_"^"
	s count=2,str="",flag=0
	s dic="" f  s dic=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,dic)) q:dic=""  d
	.q:dic=DrugLibary
	.s:$f(dicStr,"^"_dic_"^")=0 flag=1
	.s count=count+1
	q:flag=1 0
	q:count=$l(dicStr,"^") 1
	q 0
}

/// Descript:拖动目录规则
/// Cretor：sufan
/// Createdate:20200211
/// Input:RuleId,LastCatId,NewCatId
/// w ##class(web.DHCCKBRuleIndex).DragRule(61524,72,73)
ClassMethod DragRule(RuleId, LastCatId, NewCatId)
{
	n (RuleId,LastCatId,NewCatId)
	Q:$d(^CT.CKB.PDSS.RuleDicI("RuleDic",RuleId,NewCatId)) "-1"			//若存在，则不需要重新移动
	s Id=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",RuleId,LastCatId,""))		//取元素的上级
	s DicParent=$lg($g(^CT.CKB.PDSS.RuleDicD(Id)),4)
	&sql(update CT_CKB_PDSS.RuleDic set RD_Dic=:NewCatId where RD_Rule=:RuleId and RD_DicParent=:DicParent)
	Q SQLCODE
}

/// Descript:拖动目录规则
/// Cretor：Sunhuiyong
/// Createdate:20210223
/// Input:RuleId,LastCatId,NewCatId
/// w ##class(web.DHCCKBRuleIndex).DragRules("207261,207262,207263,64717,445782,498568,498932,207266",75,74)
ClassMethod DragRules(RuleId, LastCatId, NewCatId)
{
	n (RuleId,LastCatId,NewCatId)
	s length=$l(RuleId,",")
	s Err=0
	f i=1:1:length  d
	.s rulesingleid=$p(RuleId,",",i)
	.q:$lg($g(^CT.CKB.PDSS.CommonDictionD(rulesingleid)),4)="49551"
	.Q:$d(^CT.CKB.PDSS.RuleDicI("RuleDic",rulesingleid,NewCatId)) ;"-1"			//若存在，则不需要重新移动
	.s Id=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rulesingleid,LastCatId,""))		//取元素的上级
	.s DicParent=$lg($g(^CT.CKB.PDSS.RuleDicD(Id)),4)
	.&sql(update CT_CKB_PDSS.RuleDic set RD_Dic=:NewCatId where RD_Rule=:rulesingleid and RD_DicParent=:DicParent)
	.s:SQLCODE'=0 Err=1
	.i +rulesingleid'=0 d ##class(web.DHCCKBConfig).MoveDrugLibaryRefByRule(rulesingleid) // 修改药品->目录->规则关系 2022-03-30 qnp
	q Err
}

/// Descript:取目录地点
/// Cretor：sufan
/// Createdate:20200211
/// Input:
/// w ##class(web.DHCCKBRuleIndex).QueryCatDic()
ClassMethod QueryCatDic()
{
	
	k TmpArr
	s LibaryDataId=##class(web.DHCCKBCommon).GetDrugLibaryData()
	d ..QueryAllCatDic(.TmpArr,LibaryDataId)
	s count=0
	w "["
	s index=""
	for  s index=$o(TmpArr(index))  Q:index=""  d
	.s data=$g(TmpArr(index))
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",data)	

	w "]"
	
	/*
	s count=0
	w "["
	s DicId=""
	for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",LibaryDataId,DicId))  Q:DicId=""  d
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s ListData=DicId_"^"_Desc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)	

	w "]"
	*/

	q ""
}

/// Descript:取所有目录地点(递归)
/// Cretor：qunianpeng
/// Createdate:20221124
/// Input:
/// w ##class(web.DHCCKBRuleIndex).QueryAllCatDic()
ClassMethod QueryAllCatDic(TmpArr, parref)
{
	n (TmpArr,parref)
	
	s DicId=""
	for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,DicId))  Q:DicId=""  d
	.q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s ListData=DicId_"^"_Desc
	.s TmpArr(DicId)=ListData
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",DicId)) d
	..d ..QueryAllCatDic(.TmpArr,DicId)
	
	q ""
}

/// Descript:	规则是否显示
/// Cretor：	qunianpeng
/// Createdate:	2020-03-30
/// Input:		规则序号,登录信息
/// Output:		1 显示 0 不显示
/// w ##class(web.DHCCKBRuleIndex).IsRuleShow(9020,"1^1^1^1^2")
ClassMethod IsRuleShow(ruleId, loginInfo)
{
	n (ruleId,loginInfo)
	
	s hospital=$p($g(loginInfo),"^",5)
	s hospDesc=$p($g(^CT("HOSP",+hospital)),"^",2)
	q:##class(web.DHCCKBConfig).SysUser()[hospDesc 1	// 内置用户不需要授权
	
	s existFlag=0
	s logId=""
	f  s logId=$o(^CKB.PDSS.RuleLogI("Rule",ruleId,logId)) q:(logId="")||(existFlag=1)  d
	.s logHosp=$lg(^CKB.PDSS.RuleLogD(logId),10)
	.q:logHosp'=hospDesc
	.s existFlag=1
	
	q existFlag
}

/// Descript:取规则核查标志
/// Creator:sufan 
/// CreateDate:2020-11-05
/// w ##class(web.DHCCKBRuleIndex).getRuleSigns(11957)
ClassMethod getRuleSigns(ruleId)
{
	n (ruleId)
	Q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",ruleId)) 0
	s funCode = $o(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",ruleId,""),-1)
	Q:funCode="confirm" 1
	Q 0
}

/// Descript:取规则核查标志
/// Creator:shy
/// CreateDate:2021-7-5
/// w ##class(web.DHCCKBRuleIndex).getRuleSignsNew(8679)
ClassMethod getRuleSignsNew(ruleId)
{
	n (ruleId)
	Q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",ruleId)) 0
	s funConCodeID=0
	s funCanCodeID=0
	s funConCodeID=$o(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",ruleId,"confirm",""),-1)
	s funCanCodeID=$o(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",ruleId,"cancelconfirm",""),-1)
	
	q:+funConCodeID>(+funCanCodeID) 1
	q:+funConCodeID<(+funCanCodeID) 0
	
	q 0
}

/// Descript:导出项目药品涉及每日用药量与单次给药剂量并且关系
/// Creator:Shy
/// CreateDate:2022-6-21
/// w ##class(web.DHCCKBRuleIndex).ExportErrDicDataNew(1,500,"117")
ClassMethod ExportErrDicDataNew(hospid, TmpArr)
{
	
	n (hospid,TmpArr)  
    ;s start=(page-1)*rows+1	
    ;s end=page*rows
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData")
	s ListData=""
	s h=0
	s TitleStr="Desc"  ;"ID^Desc^DicID"
	s PaDataIdStr="105^81790"   //西药 中成药
	s DicId=""
	
	f k=1:1:2   d
	.s PaDataId=$p(PaDataIdStr,"^",k)
	.for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")  d
	..s flag=0
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	..s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	..s Alias=..GetDrugAlias(DicId)			//取别名
	..s QuitStr=Desc_Code_Alias
	..s HisDesc=""  f  s HisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc))  q:HisDesc=""  d
	...s ID="" f  s ID=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc,ID)) q:ID=""  d
	....s:$lg(^CKB.PDSS.ComContrastD(ID),7)=hospid flag=1
	..q:flag=0    //Shy 过滤掉非本院对照数据
	..Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	..s errFlag=0
	..s RDID=""
	..f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:RDID=""  d
	...s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	...q:+Rule=0
	...s Node=""
	...s NodeCheck=""
	...s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:RuleDataID=""  d
	....//单次给药剂量
	....s:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="49") Node=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),3)
	....//每日用药量
	....s:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="52")||($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="53")||($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="54") NodeCheck=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),3)
	...s:(Node'="")&&(NodeCheck=Node)&&($lg($g(^CT.CKB.PDSS.RuleNodeD(Node)),3)="and") errFlag=1
	..q:errFlag=0
	..s ListData=..GetPropValue(DicId,"")
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData",pid,h)=ListData
	s TmpArr(1)="******每日用药量与单次给药剂量并且"
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	;w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s count=1
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData",pid,Index)
	.s Data=$p(Data,"^",2)
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>","")
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>","")
	.s count=count+1
	.s TmpArr(count)=Data
	.;q:(count<start)||(count>end)
	.;i count=start D
	.;.w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.;e  d
	.;.w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	;w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData")
	w "$$"_h
	q ""
}

/// Descript:导出项目药品涉及前提条件有疾病无疾病都包含的药品
/// Creator:Shy
/// CreateDate:2022-6-21
/// w ##class(web.DHCCKBRuleIndex).ExportSickDicData(1,500,"114")
ClassMethod ExportSickDicData(hospid, TmpArr)
{
	
	n (hospid,TmpArr)  //xww 增加drugID 2021-8-06
	
    ;s start=(page-1)*rows+1	
    ;s end=page*rows
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSickDicData")
	s ListData=""
	s h=0
	s TitleStr="Desc"  ;"ID^Desc^DicID"
	s PaDataIdStr="105^81790"   //西药 中成药
	s DicId=""
	
	f k=1:1:2   d
	.s PaDataId=$p(PaDataIdStr,"^",k)
	.for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")  d
	..s flag=0
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	..s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	..s Alias=..GetDrugAlias(DicId)			//取别名
	..s QuitStr=Desc_Code_Alias
	..s CheckStr=""
	..s HisDesc=""  f  s HisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc))  q:HisDesc=""  d
	...s ID="" f  s ID=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc,ID)) q:ID=""  d
	....s:$lg(^CKB.PDSS.ComContrastD(ID),7)=hospid flag=1
	..q:flag=0    //Shy 过滤掉非本院对照数据
	..Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	..s errFlag=0
	..s RDID=""
	..f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:RDID=""  d
	...s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	...q:+Rule=0
	...s Str=""
	...q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,"72"))
	...s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:RuleDataID=""  d
	....//疾病
	....s:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="6") Str=Str_"Y"
	...s:Str["Y" CheckStr=CheckStr_"Y"
	...s:Str'["Y" CheckStr=CheckStr_"N"
	..q:((CheckStr'["Y")||(CheckStr'["N"))
	..s ListData=..GetPropValue(DicId,"")
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSickDicData",pid,h)=ListData
	s TmpArr(1000)="******前提条件有疾病无疾病都包含"
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	;w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s count=0
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSickDicData",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSickDicData",pid,Index)
	.s Data=$p(Data,"^",2)
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>","")
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>","")
	.s count=count+1
	.s TmpArr(count+500)=Data
	.;q:(count<start)||(count>end)
	.;i count=start D
	.;.w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.;e  d
	.;.w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	;w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSickDicData")
	w "$$"_h
	q ""
}

/// Descript:导出项目药品涉及每日用药量与每日最大量、每次最大量、每日极量并且关系
/// Creator:Shy
/// CreateDate:2022-6-21
/// w ##class(web.DHCCKBRuleIndex).ExportMaxDicData(1,500,"114")
ClassMethod ExportMaxDicData(hospid, TmpArr)
{
	
	n (hospid,TmpArr)  //xww 增加drugID 2021-8-06
	
    ;s start=(page-1)*rows+1	
    ;s end=page*rows
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData")
	s ListData=""
	s h=0
	s TitleStr="Desc"  ;"ID^Desc^DicID"
	s PaDataIdStr="105^81790"   //西药 中成药
	s DicId=""
	
	f k=1:1:2   d
	.s PaDataId=$p(PaDataIdStr,"^",k)
	.for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")  d
	..s flag=0
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	..s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	..s Alias=..GetDrugAlias(DicId)			//取别名
	..s QuitStr=Desc_Code_Alias
	..s HisDesc=""  f  s HisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc))  q:HisDesc=""  d
	...s ID="" f  s ID=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc,ID)) q:ID=""  d
	....s:$lg(^CKB.PDSS.ComContrastD(ID),7)=hospid flag=1
	..q:flag=0    //Shy 过滤掉非本院对照数据
	..Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	..s errFlag=0
	..s RDID=""
	..f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:RDID=""  d
	...s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	...q:+Rule=0
	...s Node=""
	...s NodeCheck=""
	...s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:RuleDataID=""  d
	....//单次给药剂量
	....s:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="52") Node=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),3)
	....//每日用药量
	....s:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="50")||($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="53")||($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="54") NodeCheck=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),3)
	...s:(Node'="")&&(NodeCheck=Node)&&($lg($g(^CT.CKB.PDSS.RuleNodeD(Node)),3)="and") errFlag=1
	..q:errFlag=0
	..s ListData=..GetPropValue(DicId,"")
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData",pid,h)=ListData
	s TmpArr(500)="******每日用药量与每日最大量、每次最大量、每日极量并且关系"
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	;w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s count=0
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData",pid,Index)
	.s Data=$p(Data,"^",2)
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>","")
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>","")
	.s count=count+1
	.s TmpArr(count+1000)=Data
	.;q:(count<start)||(count>end)
	.;i count=start D
	.;.w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.;e  d
	.;.w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	;w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportErrDicData")
	w "$$"_h
	q ""
}

/// Descript:导出项目药品液体配置体积和浓度并且关系
/// Creator:Shy
/// CreateDate:2022-7-11
/// w ##class(web.DHCCKBRuleIndex).ExportSolutionDicData(1,500,"114")
ClassMethod ExportSolutionDicData(page, rows, hospid)
{
	
	n (page,rows,hospid)  
	
    s start=(page-1)*rows+1	
    s end=page*rows
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSolutionDicData")
	s ListData=""
	s h=0
	s TitleStr="Desc"  ;"ID^Desc^DicID"
	s PaDataIdStr="105^81790"   //西药 中成药
	s DicId=""
	
	f k=1:1:2   d
	.s PaDataId=$p(PaDataIdStr,"^",k)
	.for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")  d
	..s flag=0
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	..s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	..s Alias=..GetDrugAlias(DicId)			//取别名
	..s QuitStr=Desc_Code_Alias
	..s HisDesc=""  f  s HisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc))  q:HisDesc=""  d
	...s ID="" f  s ID=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc,ID)) q:ID=""  d
	....s:$lg(^CKB.PDSS.ComContrastD(ID),7)=hospid flag=1
	..q:flag=0    //Shy 过滤掉非本院对照数据
	..Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	..s errFlag=0
	..s RDID=""
	..f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:RDID=""  d
	...s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	...q:+Rule=0
	...q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,"91228"))    //液体配置
	...s Node=""
	...s NodeCheck=""
	...s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:RuleDataID=""  d
	....//溶液体积
	....s:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="60") Node=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),3)
	....//溶液浓度
	....s:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="59") NodeCheck=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),3)
	...;s:(Node'="")&&(NodeCheck=Node)&&($lg($g(^CT.CKB.PDSS.RuleNodeD(Node)),3)="and") errFlag=1
	...s:((NodeCheck'="")&&(Node'="")) errFlag=1
	..q:errFlag=0
	..s ListData=..GetPropValue(DicId,"")
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSolutionDicData",pid,h)=ListData

	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s count=0
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSolutionDicData",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSolutionDicData",pid,Index)
	.s Data=$p(Data,"^",2)
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>","")
	.s Data=$replace(Data,"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>","")
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	k ^TMP("DHCCKB","web.DHCCKBRuleIndex","ExportSolutionDicData")
	w "$$"_h
	q ""
}

/// Creator:    	sunhuiyong
/// CreateDate: 	2021-07-11
/// Descript:       输出Excel:矛盾药品列表
/// w ##Class(websys.Query).ToExcel("矛盾药品列表","web.DHCCKBRuleIndex","QueryErrDataList","114")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBRuleIndex","QueryErrDataList","114")
Query QueryErrDataList(hospId As %String) As %Query(ROWSPEC = "药品名称:%String")
{
}

ClassMethod QueryErrDataListExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	n (qHandle,hospId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	k TmpArr

	/// 准备数据
	D ..ExportErrDicDataNew(hospId,.TmpArr)
	
	D ..ExportMaxDicData(hospId,.TmpArr)
	
	D ..ExportSickDicData(hospId,.TmpArr)
	
	/// 输出数据
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D 
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING($g(TmpArr(index)),"^")
	.s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryErrDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryErrDataListExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryErrDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryErrDataListExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Descript:导出项目禁忌证中含有与儿童相关的药品
/// Creator:Shy
/// CreateDate:2022-8-19
/// w ##class(web.DHCCKBRuleIndex).ExportDrugWithChild("109")
ClassMethod ExportDrugWithChild(hospid)
{
	
	n (hospid)  
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s ListData=""
	s h=0
	s TitleStr="Desc"  ;"ID^Desc^DicID"
	s PaDataIdStr="105^81790"   //西药 中成药
	s DicId=""
	
	f k=1:1:2   d
	.s PaDataId=$p(PaDataIdStr,"^",k)
	.for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")  d
	..s flag=0
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	..s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	..s HisDesc=""  f  s HisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc))  q:HisDesc=""  d
	...s ID="" f  s ID=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(Desc,"U"),HisDesc,ID)) q:ID=""  d
	....s:$lg(^CKB.PDSS.ComContrastD(ID),7)=hospid flag=1
	..q:flag=0    //Shy 过滤掉非本院对照数据
	..Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	..s errFlag=0
	..s RDID=""
	..f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:(RDID="")||(errFlag=1)  d
	...s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	...q:+Rule=0
	...s Node="",ret=0
	...s NodeCheck=""
	...q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,"74"))   //只判断禁忌证
	...s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:(RuleDataID="")||(ret=1)  d
	....s SpecialPeople="",SpecialValue="",ret=0,Age=""
	....;
	....s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="91" SpecialPeople = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)
	....s:(",3930,3937,4001,4016,5842,5952,9318,13760,22136,26634,85310,")[(","_($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)_",")) SpecialValue = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)
	....s:(SpecialPeople'="")&&(SpecialValue'="") ret=1
	....;年龄
	....s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="85" Age = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)
	....s:Age'="" ret=1
	....q:ret=1
	...s:ret=1 errFlag=1
	..q:errFlag=0
	..w Code_"^"_Desc,!
	..s h=h+1

	q h
	q ""
}

/// Description:	规则维护术语规则按code排序
/// Creator:		lidong
/// CreateDate:		2022-10-20	
/// Input:			代码^描述
/// return:			
/// other:			w ##class(web.DHCCKBRuleIndex).GetSortTreeJsonData("12018^9^1^289^2")
ClassMethod GetSortTreeJsonData(LoginInfo)
{
	n (LoginInfo)
	//药学类字典按code排序 kml 2020-03-05
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	
	k ^TMP("web.DHCCKBRuleIndex","GetSortTreeJsonData",pid)
	
	s DefRuleId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("DefinitionRuleData"),""))
	
	d ..SortCatByCode(DefRuleId,pid)		//数据排序
	
	d ##class(web.DHCCKBRuleIndex).ListCommonRuleIndexTreeNew(LoginInfo,DefRuleId,pid)		//树查询
	
	k ^TMP("web.DHCCKBRuleIndex","GetSortTreeJsonData",pid)
	Q ""
}

/// Debug d ##class(web.DHCCKBQueryDic).SortCatByCode(106,1)
ClassMethod SortCatByCode(DefRuleId, pid, num = 0)
{
	n (DefRuleId,pid,num)
	s ^TmpSortCatByCode=$lb(DefRuleId,pid,num)
	s CdRowId=""
	f  s CdRowId= $o(^CT.CKB.PDSS.CommonDictionI("Parref",DefRuleId,CdRowId)) q:CdRowId=""  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(CdRowId)),2)
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(CdRowId)),5)
	.s:(dicLink'="")&&(code="") code = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2)
	.s num=num+1
	.s code=code_CdRowId
	.s ^TMP("web.DHCCKBRuleIndex","GetSortTreeJsonData",pid,DefRuleId,code)=CdRowId
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",DefRuleId))  d
	..d ..SortCatByCode(CdRowId,pid,.num)
}

/// Description:	输出公共规则项目树
/// Creator:		ld
/// CreateDate:		2022-9-27
/// OutPut:			
/// w ##class(web.DHCCKBRuleIndex).ListCommonRuleIndexTreeNew("11863^6^1^291^2")
ClassMethod ListCommonRuleIndexTreeNew(LoginInfo, CdRowId, pid)
{
	n (LoginInfo,CdRowId,pid)
	s ^Tmp("ListCommonRuleIndexTreeNew")=$lb(LoginInfo,CdRowId,pid)
	s Info=LoginInfo
	s retArr=[]
	s DefRuleId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("DefinitionRuleData"),""))
	//s CdRowId=""
	s AddRuleFlag=##class(web.DHCCKBCommon).GetAddRuleFlag()
	//f  s CdRowId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DefRuleId,CdRowId))  q:CdRowId=""  d
	q:+pid=0
	s sortCode="" 
	f  s sortCode=$o(^TMP("web.DHCCKBRuleIndex","GetSortTreeJsonData",pid,DefRuleId,sortCode)) q:sortCode=""  d
	.q:sortCode=""
	.s CdRowId=$g(^TMP("web.DHCCKBRuleIndex","GetSortTreeJsonData",pid,DefRuleId,sortCode))
	.q:+CdRowId=0
	.s CdDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(CdRowId)),3)
	.s ruleJson={}
	.d ruleJson.%Set("id",CdRowId)
	.d ruleJson.%Set("relation",AddRuleFlag)
	.d ruleJson.%Set("text",CdDesc)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",CdRowId,""))
	.d ruleJson.%Set("defflag","0")
	.s subFlag=##class(web.DHCCKBQueryDic).IsDisabled(CdRowId, 0)
	.s subFlagNew=##class(web.DHCCKBQueryDic).IsDisabledNew(CdRowId, 0)		
	.i (((subID'="")&&(subFlag=1))||(subFlagNew=1)) d //有子节点
	..d ruleJson.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDicNew(CdRowId,Info))
	..d ruleJson.%Set("state","open")
	.//e  d  //无子节点，直接关闭
	..//d ruleJson.%Set("state","closed")
	.d retArr.%Push(ruleJson)
	d retArr.%ToJSON()
	q ""
}

/// Description:	输出公共规则项目树
/// Creator:		ld
/// CreateDate:		2022-9-27
/// OutPut:	
/// w ##class(web.DHCCKBRuleIndex).GetRuleByDicNew(22,33).%ToJSON()
ClassMethod GetRuleByDicNew(id, Info)
{
	n (id,Info)
	s ^Tmp("GetRuleByDicNew")=$lb(id,Info)
	s retArr=[]
	s Flag=..CheckDicOrLink(id)
	s AddRuleFlag=##class(web.DHCCKBCommon).GetAddRuleFlag()
	i ((Flag=10)||(Flag=11))  d		///只有字典表或两表都有，取字典表数据
	.s CdRowId=""
	.f  s CdRowId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,CdRowId))  q:CdRowId=""  d
	..s CdDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(CdRowId)),3)
	..s ruleJson={}
	..d ruleJson.%Set("id",CdRowId)
	..d ruleJson.%Set("relation",AddRuleFlag)
	..d ruleJson.%Set("text",CdDesc)
	..d ruleJson.%Set("defflag","0")
	..s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",CdRowId,""))
	..s subFlag=##class(web.DHCCKBQueryDic).IsDisabled(CdRowId, 0)
	..s subFlagNew=##class(web.DHCCKBQueryDic).IsDisabledNew(CdRowId, 0)		
	..i (((subID'="")&&(subFlag=1))||(subFlagNew=1)) d //有子节点
	...d ruleJson.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDicNew(CdRowId,Info))
	...d ruleJson.%Set("state","open")
	..//e  d  //无子节点，直接关闭
	...//d ruleJson.%Set("state","closed")
	..d retArr.%Push(ruleJson)
	
	i ((Flag=01)||(Flag=11))  d		///只有引用表或两表都有，取引用表数据
	.s DicId=""
	.f  s DicId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",id,DicId)) q:DicId=""  d
	..s LinkId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DicId)),4)
	..s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),5)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	..s dicDesc = $tr(dicDesc,$c(10),"")
	..s ruleJson={}					
	..d ruleJson.%Set("id",LinkId)
	..d ruleJson.%Set("relation",AddRuleFlag)
	..d ruleJson.%Set("text",dicDesc)
	..d ruleJson.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(LinkId,LinkId,0,Info))
	..d ruleJson.%Set("defflag","1")
	..//d ruleJson.%Set("state","closed")
	..d retArr.%Push(ruleJson)
	q retArr
}

/// Description:	判断全为引用数据还是字典表引用表混合数据
/// Creator:		ld
/// CreateDate:		2022-9-27
/// OutPut:			01:只有引用表   10:只有字典表  11:两个都有
/// other:			w ##class(web.DHCCKBRuleIndex).CheckDicOrLink(235554)
ClassMethod CheckDicOrLink(id)
{
	n (id)
	s CdRowId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,""))
	s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",id,""))
	
	i (CdRowId="")&&(DLARowID'="") d
	.s Flag=01
	i (CdRowId'="")&&(DLARowID="") d
	.s Flag=10
	i (CdRowId'="")&&(DLARowID'="") d
	.s Flag=11
	q Flag
}

}

Import SQLUser

/// Creator：      zhouxin
/// CreatDate：    2019-06-20
/// Description:： 知识规则主界面
Class web.DHCCKBRuleIndexEdit Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
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
	d DrugCat.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetJsonsByParentCode("DrugCat"))
	s GenName={}
	d GenName.%Set("id","GenName").%Set("text","通用名")
	d GenName.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetJsonsByParentCode("GenName"))
	s Drug={}
	d Drug.%Set("id","Drug").%Set("text","药品")
	d Drug.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetJsonsByParentCode(DrugData))
	
	s rootCKB=[].%Push(DrugCat).%Push(GenName).%Push(Drug)
	d projectCKB.%Set("children",rootCKB)

	d root.%ToJSON()
	q ""
}

/// 通过父节点获取子元素
/// q ##class(web.DHCCKBRuleIndexEdit).GetJsonsByParentCode("DrugLibrary")
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
    .d variable.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetDrugLibrary(id))
    .d retArr.%Push(variable)
	q retArr
}

/// w ##class(web.DHCCKBRuleIndexEdit).GetDrugLibrary("79989",0,"12018^9^1^289^2","").%ToJSON()
ClassMethod GetDrugLibrary(dicId = 0, rule = 0, userInfo = 0, model = "")
{
	
	n (dicId,rule,userInfo,model)

	s parref = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),4)
	s parCode = $lg(^CT.CKB.PDSS.CommonDictionD(++parref),2)
	s parName = $lg(^CT.CKB.PDSS.CommonDictionD(++parref),3) 
	s libList = ""
	s showLibCode = $select(parCode="DrugData":"XYDrugLibaryData",parCode="ChineseDrugData":"ChineseDrugLibaryData",parCode="ChineseHerbalMedicineData":"ChineseHerbalMedicineDrugLibaryData",1:"")
	i showLibCode'="" s libList =  ##class(web.DHCCKBCommon).GetDataListByParref(##class(web.DHCCKBCommon).GetDicIdByCode(showLibCode))

	s DrugLibrarys=[]
	//s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	
	s existFlag=0
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugLibary,id)) q:id=""  d
	.q:+id=0
	.q:(model="tmpquit")&(0=##class(web.DHCCKBRulePriority).TmpQuitDrugLibrary($lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)))
	.q:0=##class(web.DHCCKBCommon).IsShow(id,"DHC_CKBCommonDiction",userInfo)	// qunianpeng 2020/3/30 是否停用
	.q:0=##class(web.DHCCKBCommon).IsEnabled(id)
	.s text = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.q:(text="相互作用")&&('$d(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",dicId,id)))
	.i (text="相互作用") s existFlag=1
	.q:(text'="相互作用")&&($lts(libList)'="")&&($lf(libList,text)=0)	// 增加规则显示目录过滤,按照西药、中药、饮片分类的目录显示 qnp 2023/05/16
	.q:(existFlag=1)&&(text="药物相互作用") // 相互作用和药物相互作用只显示一个
	.q:(existFlag=1)&&(text="药品相互作用") // 相互作用和药物相互作用只显示一个
	.;q:(+dicId'=0)&("N"=##class(web.DHCCKBCommon).IsExistLibaryRule(dicId,id))	//  qunianpeng 2020/8/03 过滤没有规则的目录
	.s DrugLibrary={}
	.s DrugLibrary.id=id
	.s DrugLibrary.text=text
	.s DrugLibrary.tiptext=text
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d
	..s childArr = []
	..d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetTreeSubNode(dicId,id,rule,userInfo))
	.e  d
	..i +dicId'=0 d
	...s DrugLibrary.relation=dicId
	...d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(dicId,id,rule,userInfo))
	..e  i rule'=0 d
	...d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(dicId,id,rule,userInfo))
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
	.q:0=##class(web.DHCCKBCommon).IsEnabled(subId)
	.//q:(+dicId'=0)&("N"=##class(web.DHCCKBCommon).IsExistLibaryRule(dicId,subId))	//  qunianpeng 2020/8/03 过滤没有规则的目录
	.s subData = {}
	.d subData.%Set("id",subId)
	.d subData.%Set("text",$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3))
	.d subData.%Set("tiptext",$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3))
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",subId))  d
  	..d subData.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetTreeSubNode(dicId,subId,rule,userInfo))
	.i +dicId'=0 d
    ..s subData.relation=dicId
    ..//查找有的规则
    ..i ((subData.%IsDefined("children")=1)&&(subData.%Get("children").%ToJSON()="[]"))||(subData.%IsDefined("children")=0) d
    ...d subData.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(dicId,subId,rule,userInfo))
    .e  i rule'=0 d
    ..i ((subData.%IsDefined("children")=1)&&(subData.%Get("children").%ToJSON()="[]"))||(subData.%IsDefined("children")=0) d
    ...d subData.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(dicId,subId,rule,userInfo))
    .d subArr.%Push(subData)

    Q subArr
}

/// w ##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(3921,3921,0,"12018^9^1^289^2").%ToJSON()
ClassMethod GetRuleByDic(dic, relation = 0, rule = 0, userInfo)
{
	n (dic,relation,rule,userInfo)
	s unlock="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/unlock.png' border=0/>"
	s lock="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/lock.png' border=0/>"
	s lockcon = "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>"
	
	s retArr=[]
	i +dic'=0 d
	.s id="" f  s id=$o(^CT.CKB.PDSS.RuleDicI("Dic",dic,id)) q:id=""  d
	..
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
	...;s:RdId'="" Rightleftdic=$lg($g(^CT.CKB.PDSS.RuleDataD(RdId)),4)
	...;s RightValue=$e(RightValue,1,5)
	...q:0=..IsRuleShow(ruleId,userInfo)	// qunianpeng 2020/3/30 判断规则是否显示
	...s ruleJson={}
	...d ruleJson.%Set("id",ruleId)
	...d ruleJson.%Set("ruleId",ruleId)
	...s ruleIdnew="" f  s ruleIdnew=$o(^CT.CKB.PDSS.RuleDataI("Rule",ruleId,ruleIdnew)) q:ruleIdnew=""  d
	....s Rightleftdic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleIdnew)),4)
	....q:(+Rightleftdic'=0)&&($lg($g(^CT.CKB.PDSS.CommonDictionD(+Rightleftdic)),2)'="WarnMessage") 
	....s RightValuenew=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleIdnew)),9)
	....i (RightValuenew'="")  d
	.....d ruleJson.%Set("text",realstatus_"("_RightValuenew_")")
	.....d ruleJson.%Set("tiptext","("_ruleId_RightValuenew_")")
	...;d ruleJson.%Set("text",realstatus_"("_ruleId_RightValue_")"_$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3))
	...i ruleJson.text=""  d
	....d ruleJson.%Set("text",$case(RightValue="",1:realstatus_"("_ruleId_")",:realstatus_"("_RightValue_")"))
	....d ruleJson.%Set("tiptext",$case(RightValue="",1:"("_ruleId_")",:"("_ruleId_RightValue_")"))
	...d retArr.%Push(ruleJson)
	
	i rule'=0 d
	.s ruleDicStr=##class(web.DHCCKBRuleIndexEdit).GetRuleDicStr(rule)
	.s id="" f  s id=$o(^CT.CKB.PDSS.RuleDicI("Dic",relation,id)) q:id=""  d
	..s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(id)),2)
	..s realstatus=$case($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release",1:lock,:unlock)
	..s conFlag=..getRuleSignsNew(ruleId)			//sufan 2020-11-05
	..s:($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release")&&(conFlag=1) realstatus = lockcon
	..s ruleIdDicStr=##class(web.DHCCKBRuleIndexEdit).GetRuleDicStr(ruleId)
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
	..;d ruleJson.%Set("text",realstatus_"("_ruleId_RightValue_")"_$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3))
	..i RightValue'="" d ruleJson.%Set("text",realstatus_"("_RightValue_")")
	..i RightValue="" d ruleJson.%Set("text",realstatus_"("_ruleId_")")
	..d ruleJson.%Set("tiptext","("_ruleId_RightValue_")"_$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3))
	..d retArr.%Push(ruleJson)
	q retArr
}

/// 输出公共规则项目树
/// w ##class(web.DHCCKBRuleIndexEdit).ListCommonRuleIndexTree("12018^9^1^289^2")
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
	.d ruleJson.%Set("tiptext",$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3))
	.d ruleJson.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(dic,dic,0,LoginInfo))
	.d retArr.%Push(ruleJson)
	d retArr.%ToJSON()
	q ""
}

/// 输出全局规则项目树
/// w ##class(web.DHCCKBRuleIndexEdit).ListGlobalRuleIndexTree()
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
	.d ruleJson.%Set("tiptext",$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3))
	.d ruleJson.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(dic,dic,0,LoginInfo))
	.d retArr.%Push(ruleJson)
	d retArr.%ToJSON()
	q ""
}

/// 获取知识目录tree
/// W ##class(web.DHCCKBRuleIndexEdit).GetDrugLibraryTree("142","","11863^8^1^291^2")
ClassMethod GetDrugLibraryTree(dic, rule = 0, userInfo = 0)
{
	n (dic,rule,userInfo)
	w ##class(web.DHCCKBRuleIndexEdit).GetDrugLibrary(dic,+rule,userInfo).%ToJSON()
	q ""
}

/// 输出规则项目树
/// w ##class(web.DHCCKBRuleIndexEdit).ListModelTree("Herbal")
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
/// w ##class(web.DHCCKBRuleIndexEdit).ListModelDataGrid(77900)
ClassMethod ListModelDataGrid(parent)
{
	
	n (parent)
	s columns=[]
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempEleId=##class(web.DHCCKBCommon).GetTempEleId()
	;s id="" f  s id=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",parent,TempEleId,id),-1) q:id=""  d
	s attrId ="" 
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",parent,TempEleId,attrId))  Q:attrId=""  d
	.s id = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	.s link=id  ;+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.;q:link=0
	.//界面显示列
	.s column={}
	.s data=link 
    .s column.field=data
    .s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),5)
    .i (title="")&&(LinkId'="") s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
    .s column.title=title  //$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .s:title["规格" column.width=50  ; 2022-05-12 cy 列宽自适应
    .s:title'["规格" column.width=150  ; 2022-05-12 cy 列宽自适应
    .s:title["剂型" column.width=50  ; 2022-05-12 cy 列宽自适应
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
	s column={}
	s column.field="ruleFlag"
	s column.title="已结构化"
    d column.%Set("hidden",0,"boolean")
	s column.editor={}.%Set("type","validatebox")
	s column.width=50
	d columns.%Push(column)
	s column={}
	s column.field="drugConfirmFlag"
	s column.title="已核实"
    d column.%Set("hidden",0,"boolean")
	s column.editor={}.%Set("type","validatebox")
	s column.width=50
	d columns.%Push(column)
	w columns.%ToJSON()
	q ""
}

/// 动态输出模板的datagrid的数据
/// w ##class(web.DHCCKBRuleIndexEdit).ListModelData("97","1","30")
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
	.s ruleDicStr=##class(web.DHCCKBRuleIndexEdit).GetRuleDicStr(rule)
	.q:$d(ruelDicList(ruleDicStr))
	.s ruelDicList(ruleDicStr)=1
	.q:##class(web.DHCCKBRuleIndexEdit).CheckRuleMatch(rule,dicStr)=0
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
/// 动态输出模板的datagrid的数据 isrule-结构化  isconfirm-核实
/// w ##class(web.DHCCKBRuleIndexEdit).ListModelDataNew("77900","1","30","","","1","1","2")
ClassMethod ListModelDataNew(parent, page, rows, Input, drugID = "", isrule = "", isconfirm = "", hospID, parStr)
{
	
	n (parent,page,rows,Input,drugID,isrule,isconfirm,hospID,parStr)  //xww 增加drugID 2021-8-06   ld  2022-9-5 增加hospID
	s ^TMP("ListModelDataNew")=$lb(parent,page,rows,Input,drugID,isrule,isconfirm,hospID,parStr)
    s start=(page-1)*rows+1	
    s end=page*rows
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()			//取数据源Id
	s TempEleId=##class(web.DHCCKBCommon).GetTempEleId()
	s PrimaryKey=##class(web.DHCCKBCommon).GetPrimaryKey()			//主键
	s PaDataId=""
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",PropIdStr=""					//取每列的数据源以及组织输出title
	
	;s id="" f  s id=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",parent,TempEleId,id),-1) q:id=""  d
	s attrId ="" 
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",parent,TempEleId,attrId))  Q:attrId=""  d
	.s id = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
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
	.i dicStr="" d
	..s dicStr=dic
	.e  d
	..s dicStr=dicStr_"^"_dic

	s TitleStr=TitleStr_"^ruleFlag^drugConfirmFlag"								///每列的数据源串，默认以第一个的数据源为索引取值
	k ^TMP("DHCCKB","web.DHCCKBRuleIndexEdit","ListModelDataNew")
	///默认以第一个的数据源为索引取值

	k AtrrValueList
	s ParDicId=$p(dicStr,"^",1)
	s ListData=""
	s h=0
	b ; /1
	//xww 2021-08-06 药品ID不为空，直接取值不进行遍历
	i drugID'="" d
	.s ListData=..GetPropValue(drugID,PropIdStr)
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(drugID)		//判断是否有规则
	.q:(isrule'="")&&(isrule'=ruleFlag)
	.s ruleFlag=$s(ruleFlag=1:"是",ruleFlag=0:"否",1:"")
	.s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",drugID,"confirm"))	// 药品核实 2021/1/30 qnp
	.s:drugConfirmFlag>0 drugConfirmFlag=1
	.q:(isconfirm'="")&&(isconfirm'=drugConfirmFlag)
	.;s drugConfirmFlag=$case(drugConfirmFlag>0,1:drugConfirmFlag,:"否")
	.s drugConfirmFlag=$s(drugConfirmFlag=1:"是",drugConfirmFlag=0:"否",1:"") 
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBRuleIndexEdit","ListModelDataNew",pid,h)=ListData_"^"_ruleFlag_"^"_drugConfirmFlag
	
	s DicId="",contrastFlag=1,QuitFlag=1
	b ;shyshy
	for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")||(drugID'="")  d
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	.s Alias="" ;..GetDrugAlias(DicId)			//取别名  2022-06-13 cy 注释为了加快程序加载速度
	.s QuitStr=Desc_Code_Alias
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	.q:(isrule'="")&&(isrule'=ruleFlag)
	.s ruleFlag=$s(ruleFlag=1:"是",ruleFlag=0:"否",1:"")
	.s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",DicId,"confirm"))	// 药品核实 2021/1/30 qnp
	.s:drugConfirmFlag>0 drugConfirmFlag=1
	.q:(isconfirm'="")&&(isconfirm'=drugConfirmFlag)
	.s drugConfirmFlag=$s(drugConfirmFlag=1:"是",drugConfirmFlag=0:"否",1:"") 
	.Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	.Q:(Input'="")&&(QuitStr'[Input)
	.i hospID'=""  d
	..s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(DicId,hospID) //ld  2022-9-5 添加院区查询
	.q:contrastFlag'=1
	
	.i (($p(parStr,"$",1)'="")&&($p(parStr,"$",2)'="")) d
	..s QuitFlag= ##class(web.DHCCKKBIndex).ProcessInput(parStr,DicId)
	.q:QuitFlag'=1
	
	.s ListData=..GetPropValue(DicId,PropIdStr)
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBRuleIndexEdit","ListModelDataNew",pid,h)=ListData_"^"_ruleFlag_"^"_drugConfirmFlag
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s count=0
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBRuleIndexEdit","ListModelDataNew",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCCKB","web.DHCCKBRuleIndexEdit","ListModelDataNew",pid,Index)
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	k ^TMP("DHCCKB","web.DHCCKBRuleIndexEdit","ListModelDataNew")
	q ""
}

/// Descript:取别名
/// Creator:sufan
/// CreateDate:2020-04-14
/// Input:药品ID
/// w ##class(web.DHCCKBRuleIndexEdit).GetDrugAlias(1843)
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
/// w ##class(web.DHCCKBRuleIndexEdit).GetDrugAliastest(3913)
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
/// w ##class(web.DHCCKBRuleIndexEdit).GetLinkAlias(49541,26947)
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
/// w ##class(web.DHCCKBRuleIndexEdit).GetAlias(150)
ClassMethod GetAlias(DrugId, AliasPropId, Alias = "")
{
	n (DrugId, AliasPropId,Alias)
	s RetList=""
	s AliasId="0"
	for  s AliasId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",DrugId,AliasPropId,AliasId)) Q:AliasId=""  d
	.s AliasDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AliasId)),3)
	.Q:AliasDesc'[Alias
	.i RetList="" s RetList=AliasDesc
	.e  s RetList=RetList_","_AliasDesc
	Q RetList
}

/// Descript:取属性值
/// Creator:sufan
/// CreateDate:2020-02-14
/// w ##class(web.DHCCKBRuleIndexEdit).GetPropValue(150,"81224^77980^40^44")
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
	..s Index=DicId_"^"_PropId
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,PropId))   d
	...	
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
	...;i ListData="" s ListData=DicId_"^"_RuleImg_confirmImg_$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...i ListData="" s ListData=DicId_"^"_$p($lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3),"(",1)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
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
	...;i ListData="" s ListData=DicId_"^"_RuleImg_confirmImg_$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...i ListData="" s ListData=DicId_"^"_$p($lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3),"(",1)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...e  s ListData=ListData_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	..e  d
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	...s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	...s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	...s RuleImg=$s(ruleFlag=1:Img,1:"")
	...;i ListData="" s ListData=DicId_"^"_RuleImg_DicDesc_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...i ListData="" s ListData=DicId_"^"_$p(DicDesc,"(",1)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...e  s ListData=ListData_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	e  d
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	.s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	.s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s RuleImg=$s(ruleFlag=1:Img,1:"")
	.s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",DicId,"confirm"))	// 药品核实 2020/1/30 qnp
	.s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	.s confirmImg=$case(drugConfirmFlag>0,1:confirmImg,:"")
	.;s ListData=DicId_"^"_RuleImg_confirmImg_DicDesc_"^"_DicId_"^^"
	.s ListData=DicId_"^"_$p(DicDesc,"(",1)_"^"_DicId_"^^"
	k PropValList
	k PropAttrList
	Q ListData
}

/// 获取规则里的字典id串
/// w ##class(web.DHCCKBRuleIndexEdit).GetRuleDicStr(988)
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
/// w ##class(web.DHCCKBRuleIndexEdit).CheckRuleMatch(988)
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
/// w ##class(web.DHCCKBRuleIndexEdit).DragRule(61524,72,73)
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
/// w ##class(web.DHCCKBRuleIndexEdit).DragRule(61524,72,73)
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
/// w ##class(web.DHCCKBRuleIndexEdit).QueryCatDic()
ClassMethod QueryCatDic()
{
	s LibaryDataId=##class(web.DHCCKBCommon).GetDrugLibaryData()
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

	q ""
}

/// Descript:	规则是否显示
/// Cretor：	qunianpeng
/// Createdate:	2020-03-30
/// Input:		规则序号,登录信息
/// Output:		1 显示 0 不显示
/// w ##class(web.DHCCKBRuleIndexEdit).IsRuleShow(9020,"1^1^1^1^2")
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
/// w ##class(web.DHCCKBRuleIndexEdit).getRuleSigns(11957)
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
/// w ##class(web.DHCCKBRuleIndexEdit).getRuleSignsNew(8679)
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

/// Description:	规则维护术语规则按code排序
/// Creator:		lidong
/// CreateDate:		2022-10-20	
/// Input:			代码^描述
/// return:			
/// other:			w ##class(web.DHCCKBRuleIndexEdit).GetSortTreeJsonData("12018^9^1^289^2")
ClassMethod GetSortTreeJsonData(LoginInfo)
{
	n (LoginInfo)
	//药学类字典按code排序 kml 2020-03-05
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	
	k ^TMP("web.DHCCKBRuleIndexEdit","GetSortTreeJsonData",pid)
	
	s DefRuleId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("DefinitionRuleData"),""))
	
	d ..SortCatByCode(DefRuleId,pid)		//数据排序
	
	d ##class(web.DHCCKBRuleIndexEdit).ListCommonRuleIndexTreeNew(LoginInfo,DefRuleId,pid)		//树查询
	
	k ^TMP("web.DHCCKBRuleIndexEdit","GetSortTreeJsonData",pid)
	Q ""
}

/// Debug d ##class(web.DHCCKBRuleIndexEdit).SortCatByCode(106,1)
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
	.s ^TMP("web.DHCCKBRuleIndexEdit","GetSortTreeJsonData",pid,DefRuleId,code)=CdRowId
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",DefRuleId))  d
	..d ..SortCatByCode(CdRowId,pid,.num)
}

/// Description:	输出公共规则项目树
/// Creator:		ld
/// CreateDate:		2022-9-27
/// OutPut:			
/// w ##class(web.DHCCKBRuleIndexEdit).ListCommonRuleIndexTreeNew("12018^9^1^289^2")
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
	f  s sortCode=$o(^TMP("web.DHCCKBRuleIndexEdit","GetSortTreeJsonData",pid,DefRuleId,sortCode)) q:sortCode=""  d
	.q:sortCode=""
	.s CdRowId=$g(^TMP("web.DHCCKBRuleIndexEdit","GetSortTreeJsonData",pid,DefRuleId,sortCode))
	.q:+CdRowId=0
	.s Flag=##class(web.DHCCKBCommon).IsEnabled(CdRowId)
	.q:Flag=0
	.s CdDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(CdRowId)),3)
	.s ruleJson={}
	.d ruleJson.%Set("id",CdRowId)
	.d ruleJson.%Set("relation",AddRuleFlag)
	.d ruleJson.%Set("text",CdDesc)
	.d ruleJson.%Set("tiptext",CdDesc)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",CdRowId,""))
	.d ruleJson.%Set("defflag","0")
	.s subFlag=##class(web.DHCCKBQueryDic).IsDisabled(CdRowId, 0)
	.s subFlagNew=##class(web.DHCCKBQueryDic).IsDisabledNew(CdRowId, 0)		
	.i (((subID'="")&&(subFlag=1))||(subFlagNew=1)) d //有子节点
	..d ruleJson.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDicNew(CdRowId,Info))
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
/// w ##class(web.DHCCKBRuleIndex).GetRuleByDicNew(261255,"12018^9^1^289^2").%ToJSON()
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
	..s IsFlag=##class(web.DHCCKBCommon).IsEnabled(CdRowId)
	..q:IsFlag=0
	..s CdDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(CdRowId)),3)
	..s ruleJson={}
	..d ruleJson.%Set("id",CdRowId)
	..d ruleJson.%Set("relation",AddRuleFlag)
	..d ruleJson.%Set("text",CdDesc)
	..d ruleJson.%Set("tiptext",CdDesc)
	..d ruleJson.%Set("defflag","0")
	..s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",CdRowId,""))
	..s subFlag=##class(web.DHCCKBQueryDic).IsDisabled(CdRowId, 0)
	..s subFlagNew=##class(web.DHCCKBQueryDic).IsDisabledNew(CdRowId, 0)		
	..i (((subID'="")&&(subFlag=1))||(subFlagNew=1)) d //有子节点
	...d ruleJson.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDicNew(CdRowId,Info))
	...d ruleJson.%Set("state","open")
	..//e  d  //无子节点，直接关闭
	...//d ruleJson.%Set("state","closed")
	..d retArr.%Push(ruleJson)
	
	i ((Flag=01)||(Flag=11))  d		///只有引用表或两表都有，取引用表数据
	.s DicId=""
	.s TempElementId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("TempElement"),""))
	.f  s DicId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",id,TempElementId,DicId)) q:DicId=""  d
	..s LinkId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DicId)),4)
	..s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),5)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	..s dicDesc = $tr(dicDesc,$c(10),"")
	..s ruleJson={}					
	..d ruleJson.%Set("id",LinkId)
	..d ruleJson.%Set("relation",AddRuleFlag)
	..d ruleJson.%Set("text",dicDesc)
	..d ruleJson.%Set("tiptext",dicDesc)
	..d ruleJson.%Set("children",##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(LinkId,LinkId,0,Info))
	..d ruleJson.%Set("defflag","1")
	..//d ruleJson.%Set("state","closed")
	..d retArr.%Push(ruleJson)
	q retArr
}

/// Description:	判断全为引用数据还是字典表引用表混合数据
/// Creator:		ld
/// CreateDate:		2022-9-27
/// OutPut:			01:只有引用表   10:只有字典表  11:两个都有
/// other:			w ##class(web.DHCCKBRuleIndex).CheckDicOrLink(261255)
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

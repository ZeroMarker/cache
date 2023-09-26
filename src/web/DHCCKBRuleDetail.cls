Import SQLUser

Class web.DHCCKBRuleDetail Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-14
/// Description:： 保存或者新增规则维护子表
/// Table：        DHC_CKBRuleDetail
/// Input：	       RowID^主表组号^组号^代码^名称
/// Return：       保存成功:0，其他:失败
/// w ##class(web.DHCCKBRuleDetail).saveOrUpdate("298488^^cs^药品代码",311809,"")
ClassMethod saveOrUpdate(params, pid, subgroupNo)
{
	n (params,pid,subgroupNo)	
	//q:params="" 0
 	s groupNo=$p(params,"^",1)          //主表组号		
 	s RDCode=$p(params,"^",4)			//属性
 	s RDDesc=$p(params,"^",3)			//属性值	 
 	//s pid=##class(web.DHCCKBCommonUtil).NewPid()	//组号
	i +subgroupNo=0 d
	.s obj=##class(CKB.PDSS.RuleDetail).%New()
	e  d	
	.s rowId=""
	.f  s rowId=$o(^CKB.PDSS.RuleDetailI("GroupNo",groupNo,subgroupNo,rowId)) q:rowId=""  d
	..q:($lg(^CKB.PDSS.RuleDetailD(rowId),4)'=RDCode)
	..s obj=##class(CKB.PDSS.RuleDetail).%OpenId(rowId)
	..s pid=subgroupNo
	d obj.RDGroupNoSetObjectId(groupNo)
	s obj.RDCode=RDCode
	s obj.RDDesc=RDDesc
	s obj.RDSubGroupNo=pid 
	s sc=obj.%Save()
	s code=0,msg=""
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	q code
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-14
/// Description:： 批量保存或者新增规则维护子表
/// Table：        DHC_CKBRuleDetail
/// Input：	       组号^主表组号^代码^名称
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCCKBRuleDetail).save("298488^311916^测试3^药品代码$$298488^311916^测试11^药品名称$$298488^311916^片剂^剂型$$298488^311916^作用于自主神经系统的药物^药学分类"
/// w ##class(web.DHCCKBRuleDetail).save("298488^^cs^药品代码$$298488^^测试^药品名称$$298488^^注射剂^剂型$$298488^^抗感染药物^药学分类")
ClassMethod save(params)
{
  	n (params)
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s pid=##class(web.DHCCKBCommonUtil).NewPid()	//组号
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s data=$p(params,"$$",i)
  	.s subgroupNo=$p(data,"^",2)
  	.s:subgroupNo'="" ret=##class(web.DHCCKBRuleDetail).saveOrUpdate(data,"",subgroupNo)
  	.s:subgroupNo="" ret=##class(web.DHCCKBRuleDetail).saveOrUpdate(data,pid,subgroupNo)
	i ret'=0 TRollback
	q:ret'=0 ret
	TCOMMIT
	q ret
Err
	TRollback
	q -999
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-14
/// Description:： 删除规则维护子表
/// Table：        DHC_CKBRuleDetail 
/// Others：       w ##class(web.DHCCKBRuleDetail).remove("1")
ClassMethod remove(ID As %String)
{
  
	n (ID)
	s code=0,msg="success"
	s sc=##class(CKB.PDSS.RuleDetail).%DeleteId(ID)
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	.s msg=$SYSTEM.Status.GetErrorText(sc)
	d ##class(web.DHCPUECommon).R(code,msg)
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-14
/// Description:： 查询规则维护子表
/// Table：        DHC_CKBRuleDetail 
/// Others：       w ##class(web.DHCCKBRuleDetail).list(10,1,299169)
ClassMethod list(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^CKB.PDSS.RuleDetailI("GroupNo",mID,ID)) Q:ID=""  D
	.s TailData = $g(^CKB.PDSS.RuleDetailD(ID))
	.s Code=$lg(TailData,4)	//代码
	.s Desc=$lg(TailData,5)	//描述
	.s SubGroup=$lg(TailData,3)	//组号
	.s mID=$lg(TailData,2) //主表组号
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_SubGroup_"^"_mID
	.s TmpItemDet(h)=ListData	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^SubGroup^mID"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 	  //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() 		   //输出json结尾符
	Q ""
}

/// 动态输出模板的datagrid的表头
/// w ##class(web.DHCCKBRuleDetail).ListModelDataGrid("禁忌症")
ClassMethod ListModelDataGrid(DrugLibaryData)
{
	
	n (DrugLibaryData)
	s columns=[]
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	;s DicDr=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP(DrugLibaryData),""))  //获取目录中的ID 
	s AttrCode=$o(^CT.CKB.PDSS.CommonDictionI("Desc","模板关联",""))  //获取模板关联的ID
	s parentID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicDr,AttrCode,""))
	s parent=""
	s:parentID'="" parent=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(parentID)),4)
	q:parent="" ""
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parent,id)) q:id=""  d
	.//s link=+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.//q:link=0
	.//界面显示列
	.s column={}
	.s data=id //$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3) //列名
    .s column.field=data
    .s column.width=50
    .s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),5)
    .i (title="")&&(LinkId'="") s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
    .s column.title=title  //$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .d column.%Set("hidden",0,"boolean")
	.s column.editor={}.%Set("type","validatebox")
	.d columns.%Push(column)
	.//界面隐藏列
	.s columnHidden={}
	.s data=id  //$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)   //列名
    .s columnHidden.field=data_"Id"
    .s columnHidden.width=50
    .s columnHidden.title=data
	.s columnHidden.editor={}.%Set("type","validatebox")
	.d columnHidden.%Set("hidden",1,"boolean")
	.d columns.%Push(columnHidden)
	w columns.%ToJSON()
	q ""
}

/* ClassMethod ModelData(DrugLibaryData As %String)
{
	n (DrugLibaryData)
	s str=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP(DrugLibaryData),""))  //获取目录中的ID 
	q str
} */
/// Creator：      xiaowenwu
/// CreatDate：    2020-02-13
/// Description:： 动态输出模板的datagrid的数据
/// Table：        DHC_CKBRuleMaintain
/// 
/// w ##class(web.DHCCKBRuleDetail).ListModelData("禁忌症","299169","1","30")
ClassMethod ListModelData(page, rows, GroupNo, DrugLibaryData As %String)
{
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-13
/// Description:： 动态输出模板的datagrid的数据
/// Table：        web.DHCCKBRuleDetail
/// 
/// w ##class(web.DHCCKBRuleDetail).ListModelData("99","1","30")
ClassMethod ListModelDataold(DrugLibaryData, page, rows)
{
	
	n (DrugLibaryData,page,rows)
    s start=(page-1)*rows+1
    s end=page*rows
	
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	;s DicDr=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP(DrugLibaryData),""))  //获取目录中的ID 
	s AttrCode=$o(^CT.CKB.PDSS.CommonDictionI("Desc","模板关联",""))  //获取模板关联的ID
	s parentID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicDr,AttrCode,""))
	s parent=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(parentID)),4)   //关联的模板
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",length=0,olength=0
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parent,id)) q:id=""  d
	.s link=+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.
	.q:link=0
	.s length=length+1
	.s dic=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.s dic=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),2)
	.s columnCount=columnCount+1
	.s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)   //列名
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
	s GroupNo="" f  s GroupNo=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo))  q:GroupNo=""  d  //组号
	.s rule=GroupNo
	.s flagCount=1,ValueStr=""
	.s id="" f  s id=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,id)) q:id=""  d
	..//s title="" f  s title=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parent,title)) q:title=""  d
	..s tableTitle=$p(^DHCCKBRULEMAINTAIN(id),"^",1)
	..q:##class(web.DHCCKBRuleMaintain).CheckRuleMatch(tableTitle,parent)=0
	..s olength=olength+1
	..s dataDic=$p(^DHCCKBRULEMAINTAIN(id),"^",2)
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=dataDic  //$lg($g(^CT.CKB.PDSS.CommonDictionD(dataDic)),3)
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=id
	.q:length'=olength
	.s olength=0
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

Storage Default
{
<Data name="DHCCKBRuleDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCKBRuleDetailD</DataLocation>
<DefaultData>DHCCKBRuleDetailDefaultData</DefaultData>
<IdLocation>^web.DHCCKBRuleDetailD</IdLocation>
<IndexLocation>^web.DHCCKBRuleDetailI</IndexLocation>
<StreamLocation>^web.DHCCKBRuleDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

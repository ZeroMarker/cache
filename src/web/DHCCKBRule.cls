Import sqluser

Class web.DHCCKBRule Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-12
/// Description:： 保存或者新增规则维护主表
/// Input：	       ID^属性^属性值,组号
/// Return：       保存成功:0，其他:失败
/// w ##class(web.DHCCKBRuleMaintain).saveUpdate("9475501^333^84^81876^0","",9475501)
ClassMethod saveUpdate(params, pid, groupNo)
{
	n (params,pid,groupNo)	
	
	q:params="" 0
 	s groupID=$p(params,"^",1)		
 	s RMCode=$p(params,"^",3)			//属性
 	s RMDesc=$p(params,"^",2)			//属性值
 	s Temp=$p(params,"^",4)				//模板值
 	s Flag=$p(params,"^",5)				//标
 	//s RMDesc=##class(web.DHCCKBRuleMaintain).getDescRowID(RMDesc,RMCode) //获取描述的RowId	 
	i +groupNo=0 d
	.s obj=##class(User.DHCCKBRuleMaintain).%New()
	e  d
	.i (RMCode'="")&&('$d(^DHCCKBRULEMAINTAIN(0,"GroCode",groupNo,Temp,RMCode))) d
	..s obj=##class(User.DHCCKBRuleMaintain).%New()	
	..s pid=groupNo
	.e  d
	..s rowId=""
	..f  s rowId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",groupNo,rowId)) q:rowId=""  d
	...q:(($p(^DHCCKBRULEMAINTAIN(rowId),"^",1))'=RMCode)
	...s obj=##class(User.DHCCKBRuleMaintain).%OpenId(rowId)
	...s pid=groupNo
	
	s obj.RMCode=RMCode
	s obj.RMDesc=RMDesc
	s obj.RMGroupNo=pid
	s obj.RMTemp=Temp
	s obj.RMFlag=Flag
	s obj.RMText=$$ALPHAUP^SSUTIL4(RMDesc)
	s sc=obj.%Save()
	s code=0,msg=""
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	q code
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-2-24
/// Description:： 获取描述的RowId
/// Others：       w ##class(web.DHCCKBRuleMaintain).getDescRowID("测试")
ClassMethod getDescRowID(RMDesc As %String, RMCode As %String) As %String
{
	n (RMDesc,RMCode)
	
	q:RMDesc="" ""
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()					//数据源 28
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDicIdByCode("DrugLibaryData")  //目录字典 49551
	s link=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,RMCode,"")) //是否关联数据源
	s linkId=""
	s:link'="" linkId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)							//关联的数据源
	//s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(RMDesc),""))
	s LibaryData=$lg($g(^CT.CKB.PDSS.CommonDictionD(RMCode)),4)								//上级节点
	s RowID=""
	i ((linkId'="")||(LibaryData=DrugLibaryData)) d
	.s tmpDicID=""
	.f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(RMDesc),tmpDicID)) q:tmpDicID=""  d
	..//s data=##class(web.DHCCKBDiction).CheckDictionRepeat(DateRowID,"",RMDesc,linkId)
	..q:RowID'=""
	..s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	..q:((linkId'=tmpParref)&(linkId'=""))
	..q:((linkId="")&(DrugLibaryData'=tmpParref))
	..s RowID=tmpDicID
	
	//i RowID="" s RowID=##class(web.DHCCKBRuleMaintain).InsDic(RMDesc,linkId)
	q RowID
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-2-24
/// Description:： 保存描述
/// Input:         ListData:描述，linkId：数据源
/// Output:		   ROWID
/// Others：       w ##class(web.DHCCKBRuleMaintain).InsDic("测试")
ClassMethod InsDic(ListData, linkId)
{
	n (ListData,linkId)
	&sql(insert into CT_CKB_PDSS.CommonDiction (CD_Code,CD_Desc,CD_Parref_Dr)
	     values (:ListData,:ListData,:linkId))
	Q %ROWID
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-12
/// Description:： 批量保存或者修改分类字典
/// Input：	       ID^代码^名称
/// Return：       保存成功:0，其他:失败
/// w ##class(web.DHCCKBRuleMaintain).save("^颠茄片10mg(天津力生制药股份有限公司)^81842^81876^0$$^配伍禁忌^75^81876^0$$^^43^81876^0$$^^42^81876^0$$^^39^81876^0$$^^38^81876^0$$^^64^81876^0$$^^83^81876^0$$^^74698^81876^0$$^^81^81876^0$$^^82^81876^0$$^555^84^81876^0$$^555^81960^81876^0")
ClassMethod save(params)
{
  	n (params)
  	s ^temptest("12234",$h)=$lb(params)
  	//s $Zt="Err"
  
  	TStart
  	s ret=0
  	s pid=##class(web.DHCCKBCommonUtil).NewPid()	//组号
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s data=$p(params,"$$",i)
  	.s data=##class(web.DHCCKBDrugRuleMaintain).DealWithSpecSymbols(data)
  	.s groupNo=$p(data,"^",1)
  	.s:groupNo'="" ret=##class(web.DHCCKBRuleMaintain).saveUpdate(data,"",groupNo)
  	.s:groupNo="" ret=##class(web.DHCCKBRuleMaintain).saveUpdate(data,pid,groupNo)
	i ret'=0 TRollback
	q:ret'=0 ret
	TCOMMIT
	q ret
Err
	TRollback
	q -999
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-04-13
/// Description:： 批量保存或者保存多行
/// Input：	       ID^代码^名称
/// Return：       保存成功:0，其他:失败
/// w ##class(web.DHCCKBRuleMaintain).save("1761966^测试药品胶囊剂^74532^77685$$1761966^禁忌症^^77685$$1761966^12岁^85^77685$$1761966^女^89^77685$$1761966^注射用青霉素钠^92^77685$$1761966^小儿^91^77685$$1761966^呼吸道感染^74533^77685$$1761966^^74959^77685$$1761966^^95^77685$$1761966^^77689^77685$$1761966^运动员^93^77685$$1761966^^39^77685$$1761966^注射剂^40^77685")
ClassMethod saveAll(params)
{
  	n (params)
  	s $Zt="Error"
  	TStart
  	s ret=0
  	s len=$l(params,"@@")
  	for i=1:1:len d
  	.q:ret'=0
  	.s data=$p(params,"@@",i)
  	.s ret=##class(web.DHCCKBRuleMaintain).save(data)
	i ret'=0 TRollback
	q:ret'=0 ret
	TCOMMIT
	q ret
Error
	TRollback
	q -999
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-04-15
/// Description:： 批量保存数据到数据源中(暂时没用)
/// Table：        DHC_CKBCommonDiction
/// Input：	       ID^代码^名称;      LoginInfo:登录信息;  ClientIPAddress:IP地址
/// Return：       保存成功:0，其他:失败
/// w ##class(web.DHCCKBRuleMaintain).saveDataSource("")
ClassMethod saveDataSource(params, LoginInfo, ClientIPAddress)
{
  	n (params,LoginInfo,ClientIPAddress)
  	s $Zt="Er"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s data=$p(params,"$$",i)
  	.s ret=##class(web.DHCCKBRuleMaintain).saveOrUpdateData(data,LoginInfo,ClientIPAddress)
	i ret'=0 TRollback
	q:ret'=0 ret
	TCOMMIT
	q ret
Er
	TRollback
	q -888
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-04-15
/// Description:： 保存或者新增保存数据到数据源中
/// Table：        DHC_CKBCommonDiction
/// Input：	       ID^属性^属性值,组号   LoginInfo:登录信息;  ClientIPAddress:IP地址
/// Return：       保存成功:0，其他:失败
/// w ##class(web.DHCCKBRuleMaintain).saveOrUpdateData("^Patheon Inc.^Patheon Inc.^44","1^1^1^1^2","113.140.81.66")
ClassMethod saveOrUpdateData(params, LoginInfo, ClientIPAddress)
{
	n (params,LoginInfo,ClientIPAddress)

 	s ID=$p(params,"^",1) 		//ID
 	s Code=$p(params,"^",2)		//代码
 	s Desc=$p(params,"^",3) 	//名称
 	q:(Code="")&&(Desc="") "-3"   //代码描述都不存在时退出
 	s:Code="" Code=Desc
 	s Fieid=$p(params,"^",4)	//fieid
 	s Code=$replace(Code,"（","(")
 	s Code=$replace(Code,"）",")")
 	s Desc=$replace(Desc,"（","(")
 	s Desc=$replace(Desc,"）",")")
 	s LgUserID=$p($g(LoginInfo),"^",1)  //用户ID
	s LgHospID=$p($g(LoginInfo),"^",5)
 		
 	s DataSource=##class(web.DHCCKBCommon).GetDataSource()			//数据源 28
	s link=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,Fieid,""))
	q:link="" "-4" //数据源不存在
	s linkId="" 
	s:link'="" linkId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)					//关联的数据源Id
	s Flag=""  														//存在标识
	//判断代码是否存在
	s tmpDicID=""
	f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(Code),tmpDicID)) q:tmpDicID=""  d
	.s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	.q:(linkId'=tmpParref)
	.s Flag=1
	q:Flag=1 "-1"   //代码存在，退出
	
	//判断描述是否存在
	s tmpDicID=""
	f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(Desc),tmpDicID)) q:tmpDicID=""  d
	.s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	.q:(linkId'=tmpParref)
	.s Flag=2
	q:Flag=2 "-2"   //描述存在，退出
	TS	 
	i +ID=0 d
	.s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
	e  d
	.s obj=##class(CT.CKB.PDSS.CommonDiction).%OpenId(ID)
	s obj.CDCode=Code
	s obj.CDDesc=Desc
	d obj.CDParrefDrSetObjectId(linkId)
	s sc=obj.%Save()
	s RowId=obj.%Id()   //RowId
	s code=0,msg=""
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	
	i (code=0)&(+ID=0) d 
	.s code=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",RowId,"add",LgUserID,"","","","",ClientIPAddress,"log")
	i (code=0)&(+ID=0) d 
	.s code=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", RowId, "grantAuth", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"acc")
	i code=0 tc
	i code'=0 tro
	
	i code=0 d ##class(web.PredictModel).WebServiceAddWords(Desc,linkId) //kml 2020-06-10 元素更新到jieba词库
	
	q code
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-03-05
/// Description:： 删除分类字典
/// Others：       w ##class(web.DHCCKBRuleMaintain).remove("1")
ClassMethod remove(ID As %String)
{
  
	n (ID)
	s code=0,msg="success"
	s sc=##class(User.DHCCKBRuleMaintain).%DeleteId(ID)
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	.s msg=$SYSTEM.Status.GetErrorText(sc)
	d ##class(web.DHCPUECommon).R(code,msg)
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-13
/// Description:： 动态输出模板的datagrid的数据(旧)
/// Input：		   parent:模板Id
/// Other：		   w ##class(web.DHCCKBRuleMaintain).ListModelData("99","1","30")
ClassMethod ListModelData(parent = "", page, rows)
{
	
	n (parent,page,rows)
    s start=(page-1)*rows+1
    s end=page*rows
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  //模板元素ID 49535
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",length=0,olength=0
	s link=""
	f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+parent,+TempElement,link)) q:link=""  d  //查询表CT_CKB_PDSS.DicLinkAttr
	.q:link=0
	.s length=length+1
	.s dic=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)				//数据源字典RowID
	.s columnCount=columnCount+1
	.s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3)   			//列名
	.s $p(TitleStr,"^",columnCount)=dic
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic_"Id"
	.i dicStr="" d
	..s dicStr=dic
	.e  d
	..s dicStr=dic_"^"_dicStr
	k ruelDicList
	w "{""rows"":["	
	s count=0
	s GroupNo="" f  s GroupNo=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo))  q:GroupNo=""  d  //组号
	.s rule=GroupNo										//保存组号
	.s flagCount=1,ValueStr="",olength=0
	.s id="" f  s id=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,id)) q:id=""  d
	..s tableTitle=$p(^DHCCKBRULEMAINTAIN(id),"^",1)	//标题
	..q:##class(web.DHCCKBRuleMaintain).CheckRuleMatch(tableTitle,parent)=0  //判断这条记录列是否在查询模板中
	..s olength=olength+1
	..s dataDic=""
	..s dataDic=$p(^DHCCKBRULEMAINTAIN(id),"^",2)		//内容
	..i dataDic'="" d
	...s data=$g(^CT.CKB.PDSS.CommonDictionD(dataDic))
	...s:data'="" dataDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataDic)),3)	//内容
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=dataDic  
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=id
	.q:length'=olength									//判断这条记录中的列数量与查询模板中的数量是否一致
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

/// Creator: xiaowenwu
/// Date:	2020-02-13
/// Desc:   判断是否为当前模板内容
/// Input:	tableTitle:标题，parent：模板ID
/// Other: 	w ##class(web.DHCCKBRuleMaintain).CheckRuleMatch(988)
ClassMethod CheckRuleMatch(tableTitle, parent)
{
	n (tableTitle,parent)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  //模板元素ID 49535
	s length=0
	s id="" f  s id=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+parent,+TempElement,id)) q:id=""  d
	.q:id=0
	.s linkId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(id)),4)
	.//s title=""
	.//s:linkId'="" title=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)   //列名
	.q:linkId'=tableTitle
	.s length=length+1
	
	q:length'=0 1
	q 0
}

/// Creator: xiaowenwu
/// Date:	2020-02-13
/// Desc:   动态输出模板的datagrid的表头
/// Input:	dicId：模板ID
/// Other: 	w ##class(web.DHCCKBRuleMaintain).ListModelDataGrid(75369)
ClassMethod ListModelDataGrid(dicId)
{
	
	n (dicId)
	s ^temptest("1256798")=$lb(dicId)
	s columns=[]
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()					//数据源 28
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  	//模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()			//数据目录字典
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRuleMaintain","SortAttrByOrdNum",pid)
	//排序
	d ##class(web.DHCCKBRuleMaintain).SortAttrByOrdNum(dicId,pid)
	//取数据
	s Index=""
	f  s Index=$o(^TMP("DHCCKB","web.DHCCKBRuleMaintain","SortAttrByOrdNum",pid,Index)) q:Index=""  d  
	.s ListData=^TMP("DHCCKB","web.DHCCKBRuleMaintain","SortAttrByOrdNum",pid,Index)
	.s LinkRowId=$p(ListData,"^",1)
	.s attrCodeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkRowId)),3)	// 属性ID
	.s attrValueDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkRowId)),4)	// 属性值ID
	.s attrResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkRowId)),5)	// 内容
	.s attrCodeDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCodeDr)),3)
	.i attrValueDr'="" s attrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)			
	.//界面显示列
	.s column={}
	.s data=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkRowId)),4)			// 属性值ID 
    .s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)	// 标题
    .s catalog=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),4) // 上级目录
    .s:catalog=DrugLibaryData data="catalog"		//	该列为目录列时特殊处理
    .s column.field=data
    .s column.width=200 
    .s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),5)
    .i (title="")&&(LinkId'="") s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
    .s column.title=title 
    .d column.%Set("hidden",0,"boolean")
	.s column.editor={}.%Set("type","validatebox")
	.d columns.%Push(column)
	.//界面隐藏列
	.s columnHidden={}
	.s data=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkRowId)),4) 
	.s catalog=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),4)
    .s:catalog=DrugLibaryData data="catalog"	//该列为目录列时特殊处理
    .s columnHidden.field=data_"Id"
    .s columnHidden.width=200
    .s columnHidden.title=data
	.s columnHidden.editor={}.%Set("type","validatebox")
	.d columnHidden.%Set("hidden",1,"boolean")
	.d columns.%Push(columnHidden)
	w columns.%ToJSON()
	k ^TMP("DHCCKB","web.DHCCKBRuleMaintain","SortAttrByOrdNum",pid)
	q ""
}

/// Creator：      sufan
/// CreatDate：    2020-05-18
/// Description:： 按顺序号排序
/// Table：        
/// Others：       w ##class(web.DHCCKBRuleMaintain).ListModelTree()
ClassMethod SortAttrByOrdNum(dicId, pid)
{
	n (dicId,pid)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()					//数据源 28
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  	//模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()			//数据目录字典
	s OrdNumAttrId=##class(web.DHCCKBCommon).GetOrdNumId()					//顺序号属性
	s count=0
	s linkRowId=""
	f  s linkRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicId,+TempElement,linkRowId)) q:linkRowId=""  d  //查询表CT_CKB_PDSS.DicLinkAttr
	.q:linkRowId=0
	.s attrCodeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),3)	// 属性ID
	.s attrValueDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),4)	// 属性值ID
	.s attrResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),5)	// 内容
	.s attrCodeDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCodeDr)),3)
	.i attrValueDr'="" s attrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)	
	.s count=count+1		
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrValueDr,OrdNumAttrId))  d
	..s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrValueDr,OrdNumAttrId,""))
	..s OrdNum=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)*10000+count
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.e  d
	..s OrdNum=90000000
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)+count
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.s ^TMP("DHCCKB","web.DHCCKBRuleMaintain","SortAttrByOrdNum",pid,OrdNum)=linkRowId_"^"_attrValueDr
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-17
/// Description:： 输出规则项目树
/// Table：        
/// Others：       w ##class(web.DHCCKBRuleMaintain).ListModelTree()
ClassMethod ListModelTree()
{
	s retArr=[]
	s DirTemp=##class(web.DHCCKBCommon).GetDicIdByCode("规则拆分模板")  //模板字典ID  49536	
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DirTemp,id)) q:id=""  d
	.s model={}
    .s model.id=id
    .s model.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    .s children=[]
    .s subId="" f  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,subId)) q:subId=""  d
    ..s subModel={}
    ..s subModel.id=subId
    ..s subModel.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3)
    ..d children.%Push(subModel)
    .d model.%Set("children",children)
	.d retArr.%Push(model)
	w retArr.%ToJSON()
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-17
/// Description:： 规则维护明细
/// Table：        
/// Others：       w ##class(web.DHCCKBRuleMaintain).list(10,1,3)
ClassMethod list(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCCLF(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCCLF(ID),"^",2)    	//代码
	.s Desc=$p(^DHCEMCCLF(ID),"^",3)    	//描述
	.s Function=$p(^DHCEMCCLF(ID),"^",4)    //表达式
	.q:Function=""  s Function=$p(^DHCEMCF(Function),"^",3)
	.s ActCode=$p(^DHCEMCCLF(ID),"^",5) 	//可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s mID=$p(^DHCEMCCLF(ID),"^",1)    		//类型ID
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_Function_"^"_mID
	.s TmpItemDet(h)=ListData	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^Function^mID"
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

/// Description:	查询实体字典列表
/// Creator:		xiaowenwu 
/// CreateDate:		2020-02-17	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBRuleMaintain).QueryDicByID("30","1","","")
ClassMethod QueryDicByID(rows = 30, page = 1, id As %String = "", parDesc = "") As %String
{
	n (rows,page,id,parDesc)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	Q:id="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s field=id
	s AttrcodeId=""
	s CodeDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(field)),2)                     ///--属性code
	s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(field)),5)
	i LinkDr'="" s CodeDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkDr)),2),field=LinkDr
	i AttrcodeId="" s AttrcodeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(CodeDic),""))
	Q:$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId)) ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId))  d
	.s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId,""))
	.s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)
	.d ##class(web.DHCCKBDicLinkAttr).QueryCloByLink(AttrId)
	e  d
	.d ..QueryDicByIDNew(rows,page,field,parDesc)
	q ""
}

/// Description:	查询实体字典列表
/// Creator:		xiaowenwu 
/// CreateDate:		2020-02-17	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBRuleMaintain).QueryDicByIDNew("30","1","92","二氢吡啶类")
ClassMethod QueryDicByIDNew(rows = 30, page = 1, id As %String = "", parDesc = "") As %String
{
	n (rows,page,id,parDesc)
	s ^temptest("33322")=$lb(rows,page,id,parDesc)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s end=page*rows
	s start=(page-1)*rows+1
	s IdList=""														//数据源list
	s link=""														//数据源有多个问题处理sufan20200414
	for  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,link)) Q:link=""  d   //是否关联数据源
	.s:link'="" SourId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)					//关联的数据源
	.i IdList=""  s IdList=SourId
	.e  s IdList=IdList_"^"_SourId									//数据换拼串
	
	
	Q:IdList="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()	
	s h=0
	s Len=$l(IdList,"^")
	for i=1:1:Len  d
	.s Id=$p(IdList,"^",i)
	.s dicID=""  
	.f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Id,dicID))   q:dicID=""  d
	..s dicflag = $d(^CKB.PDSS.DicLogI("DLGDataDr",dicID))
	..q:dicflag=10
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..;s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..;q:(parDesc'="")&&($zcvt(dicCode,"U")'[parDesc)&&(dicDesc'[parDesc)&&(pinDesc'[$zcvt(parDesc,"U"))
	..//q:(parDesc'="")&&(dicDesc'[parDesc)
	..s parref=Id
	..s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	..s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	..s linkDesc=""
	..i linkDr'="" d
	...s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	...s linkDesc=dicDesc
	..;Q:##class(web.DHCCKBCommon).IsEnabled(dicID)=0
	..s h=h+1
	..s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(dicID)
	..s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(dicID)				//别名
	..s data=dicID_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc_"^"_ruleFlag_"^"_Alias
	..s ^TMP("DHCCKB","web.DHCCKBRuleMaintain","QueryDicByID",pid,dicID)=data
	..i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))  d
	...d ..GetSubItem(dicID,pid,parDesc)
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="ID^CDCode^CDDesc^CDParref^CDParrefDesc^CDLinkDr^CDLinkDesc^RuleFlag^Alias"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBRuleMaintain","QueryDicByID",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBRuleMaintain","QueryDicByID",pid,index))
	.s Id=$p(listData,"^",1)
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.s Code=$p(listData,"^",2)
	.s Desc=$p(listData,"^",3)
	.s DicAlias=$p(listData,"^",9)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
	.q:(parDesc'="")&&(($zcvt(Code,"U")'[parDesc)&&(Desc'[parDesc)&&(pinDesc'[$zcvt(parDesc,"U")))&&(DicAlias'[parDesc)
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	//w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	w "],""total"":"_count_"}"
	
	k ^TMP("DHCCKB","web.DHCCKBRuleMaintain","QueryDicByID")
	q ""
}

/// Description:递归取分类数据
/// Creator:		sufan 
/// CreateDate:		2020-04-15
/// Input:			元素Id
/// return:			
/// other:			w ##class(web.DHCCKBRuleMaintain).isDataSource(74)
ClassMethod GetSubItem(ParentId, pid, Input)
{
	n (ParentId,pid,Input)
	s Id=""
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,Id)) Q:Id=""  d
	.s DicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),2)
	.s DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	.s DicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),5) 
	.s ParrefDesc = ""
	.s Parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),4) 
	.s:Parref'="" ParrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Parref)),3)
	.s:(DicLink'="")&&(DicCode="") DicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLink)),2) 
	.s:(DicLink'="")&&(DicDesc="") DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLink)),3)
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(Id)
	.s PinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DicDesc))
	.;q:(Input'="")&($zcvt(DicCode,"U")'[Input)&(DicDesc'[Input)&(PinDesc'[$zcvt(Input,"U"))
	.;Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(Id)				//别名
	.s data=Id_"^"_DicCode_"^"_DicDesc_"^"_Parref_"^"_$g(ParrefDesc)_"^"_DicLink_"^"_DicDesc_"^"_ruleFlag_"^"_Alias
	.s ^TMP("DHCCKB","web.DHCCKBRuleMaintain","QueryDicByID",pid,Id)=data
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",Id))  d
	..d ..GetSubItem(Id,pid,Input)
	Q ""
}

/// Description:	取别名
/// Creator:		sufan 
/// CreateDate:		2020-04-27
/// Input:			元素Id
/// return:			
/// other:			w ##class(web.DHCCKBRuleMaintain).GetAlias(74)
ClassMethod GetAlias(DicId)
{
	n (DicId)
	
	Q ""
}

/// Description:	判断是否有数据源或父节点为目录字典
/// Creator:		xiaowenwu 
/// CreateDate:		2020-02-24
/// Input:			field：列id
/// return:			0 有 ；1没有
/// other:			w ##class(web.DHCCKBRuleMaintain).isDataSource(90975)
ClassMethod isDataSource(field)
{
	n (field)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()			//数据源
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	Q:field="catalog" 0
	s link=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,field,""))
	s id=""
	s:link'="" id=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)						//绑定的数据源	
	s data=0
	i id="" d
	.s data=1
	.s isDrugLibaryData=$lg($g(^CT.CKB.PDSS.CommonDictionD(field)),4)					//判断上级是不是了目录字典，对上级是目录字典的特殊处理
	.s:isDrugLibaryData=DrugLibaryData data=0
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	Q:$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",field,LinkPropId)) 0
	q data
}

/// Description:	获取属性代码
/// Creator:		xiaowenwu 
/// CreateDate:		2020-03-11
/// Input:			属性RowID
/// return:			
/// other:			w ##class(web.DHCCKBRuleMaintain).getDicCode(74)
ClassMethod getDicCode(field)
{
	n (field)
	s DicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(field)),2)
	q DicCode
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-02-13
/// Description:： 动态输出模板的datagrid的数据
/// 
/// w ##class(web.DHCCKBRuleMaintain).ListModelDataNew1("74939","1","15")
ClassMethod ListModelDataNew1(parent = "", page, rows)
{
	
	n (parent,page,rows)
    s start=(page-1)*rows+1
    s end=page*rows
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  //模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",length=0,olength=0
	s link=""
	f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+parent,+TempElement,link)) q:link=""  d  //查询表CT_CKB_PDSS.DicLinkAttr
	.q:link=0
	.//s length=length+1
	.s dic=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)				//数据源字典RowID
	.s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3)   			//列名
	.s catalog=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),4)			//目录字典特殊处理
    .s:catalog=DrugLibaryData dic="catalog"
	.s columnCount=columnCount+1	
	.s $p(TitleStr,"^",columnCount)=dic
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic_"Id"        //列名Id
	.i dicStr="" d
	..s dicStr=dic
	.e  d
	..s dicStr=dic_"^"_dicStr	
	
	k ruelDicList
	w "{""rows"":["	
	s count=0
	s GroupNo="" f  s GroupNo=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo))  q:GroupNo=""  d  //组号
	.s rule=GroupNo										//保存组号
	.s flagCount=1,ValueStr="",olength=0,dataStr=""
	.s id="" f  s id=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,id)) q:id=""  d
	..s tableTitle=$p(^DHCCKBRULEMAINTAIN(id),"^",1)	//标题
	..//q:##class(web.DHCCKBRuleMaintain).CheckRuleMatch(tableTitle,parent)=0  //判断这条记录列是否在查询模板中
	..//s olength=olength+1
	..s isDataSource=##class(web.DHCCKBRuleMaintain).isDataSource(tableTitle)   //是否有数据源或为目录字典
	..s catalogD=$lg($g(^CT.CKB.PDSS.CommonDictionD(tableTitle)),4)
    ..s:catalogD=DrugLibaryData tableTitle="catalog"
	..s dataDic=""
	..s dataDic=$p(^DHCCKBRULEMAINTAIN(id),"^",2)		//内容
	..s fieldIdData=dataDic							    //fieldId显示内容的ID
	..//i (dataDic'="")&(isDataSource=0) d
	..//.s len=$l(dataDic,",")
	..//.s content=""
  	..//.for i=1:1:len d
  	..//..s param=$p(dataDic,",",i)
  	..//..s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(param)),3)         //描述
  	..//..s:content'="" content=content_","_desc  
  	..//..s:content="" content=desc
    ..//.s dataDic=content	
	..//e  d
	..//s dataDic=$g(^CT.CKB.PDSS.CommonDictionD(dataDic))
	..//s:data'="" dataDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataDic)),3)		//内容
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=dataDic  
	..s flagCount=flagCount+1
	..s $p(ValueStr,"^",flagCount)=fieldIdData
	..i dataStr="" d
	...s dataStr=tableTitle
	..e  d
	...s dataStr=tableTitle_"^"_dataStr
	.
	.q:dicStr'[dataStr
	.//q:length'=olength									//判断这条记录中的列数量与查询模板中的数量是否一致
	.//s olength=0
	.s $p(ValueStr,"^",1)=rule
    .s count=count+1
    .q:count<start
    .q:count>end
    .w $case(count,start:"",:",")
    .w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr_"^GroupNo",ValueStr_"^"_GroupNo)
    w "],""total"":"_count_"}"
    k ruelDicList
	q ""
}

/// w ##class(web.DHCCKBRuleMaintain).ListModelDataNew("77679","1","15","1")
ClassMethod ListModelDataNew(parent = "", page, rows, params = "")
{
	
	n (parent,page,rows,params)
	s ^temptest("122")=$lb(parent,page,rows,params)
    s start=(page-1)*rows+1
    s end=page*rows
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  //模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	s Type=$p(params,"^",1)				//类型
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",length=0,olength=0
	s clomnobj={}
	d clomnobj.%Set("ID","")
	s link=""
	f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+parent,+TempElement,link)) q:link=""  d  //查询表CT_CKB_PDSS.DicLinkAttr
	.q:link=0
	.//s length=length+1
	.s dic=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)				//数据源字典RowID
	.s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3)   			//列名
	.s catalog=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),4)			//目录字典特殊处理
    .s:catalog=DrugLibaryData dic="catalog"
	.d clomnobj.%Set(dic,"")	
	.d clomnobj.%Set(dic_"Id","")
	
	w "{""rows"":["	
	s count=0
	s GroupNo="" f  s GroupNo=$o(^DHCCKBRULEMAINTAIN(0,"TempGro",parent,GroupNo),-1)  q:GroupNo=""  d  //组号
	.s rule=GroupNo										//保存组号
	.s Temp=""
	.s id="" f  s id=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,id)) q:id=""  d
	..s tableTitle=$p(^DHCCKBRULEMAINTAIN(id),"^",1)	//标题
	..s isDataSource=##class(web.DHCCKBRuleMaintain).isDataSource(tableTitle)   //是否有数据源或为目录字典
	..s catalogD=$lg($g(^CT.CKB.PDSS.CommonDictionD(tableTitle)),4)
	..s Temp=$lg($g(^CT.CKB.PDSS.CommonDictionD(tableTitle)),5)
    ..s:catalogD=DrugLibaryData tableTitle="catalog"
	..s dataDic=""
	..s dataDic=$p(^DHCCKBRULEMAINTAIN(id),"^",2)		//内容
	..s fieldIdData=dataDic							  //fieldId显示内容的ID
	..d clomnobj.%Set(tableTitle,dataDic)	
	..d clomnobj.%Set(tableTitle_"Id",fieldIdData)
	.s MainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,""))
	.s OperType=$p(^DHCCKBRULEMAINTAIN(MainId),"^",5)
	.Q:OperType=3
	.Q:(Type'="2")&&(OperType'=Type)
	.d clomnobj.%Set("ID",GroupNo)
	.d clomnobj.%Set("GroupNo",GroupNo)
    .s count=count+1
    .q:count<start
    .q:count>end
    .w $case(count,start:"",:",")
    .w clomnobj.%ToJSON()
    .d clomnobj.%Set(tableTitle,"")	
	.d clomnobj.%Set(tableTitle_"Id","")
    w "],""total"":"_count_"}"

	q ""
}

/// Creator   :xiaowenwu
/// CreateDate:2020-03-10
/// Desc      :输出模板绑定的目录ID和描述
/// Input	  :dicId 模板ID
/// Output	  :data:目录ID^目录描述
/// Others	  :w ##class(web.DHCCKBRuleMaintain).DrugLibaryDataID(90409)
ClassMethod DrugLibaryDataID(dicId)
{
	n (dicId)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()				   //数据源		 28
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  //模板元素ID  49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()		   //数据目录字典49551
	s data=""
	s linkRowId=""
	f  s linkRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicId,+TempElement,linkRowId)) q:linkRowId=""  d  //查询表CT_CKB_PDSS.DicLinkAttr
	.q:linkRowId=0
	.s attrValueDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),4)			// 属性值ID
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)	       		// 描述
	.s isDrugLibaryData=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),4)	//判断上级是不是了目录字典，对上级是目录字典的特殊处理
	.s:isDrugLibaryData=DrugLibaryData data=attrValueDr_"^"_Desc
	q data
}

/// w ##class(web.DHCCKBRuleMaintain).QueryColumns("catalog","")
ClassMethod QueryColumns(AttrcodeId, DicCode)
{
	n (AttrcodeId, DicCode)
	//先判断属性关联，若未关联属性，取本身
	//取属性关联数据
	i AttrcodeId="catalog" s AttrcodeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("用药指导"),""))
	i AttrcodeId="" s AttrcodeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(DicCode),""))
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s LInkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrcodeId)),5)
	Q:('$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId)))&&(LInkId="") "[]"
	i ('$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId)))&&(LInkId'="") s AttrcodeId=LInkId
	Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId)) "[]"
	s AttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrcodeId)),2)
	Q:AttrCode="Ingredient" "[]"
	s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId,""))
	s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)
	
	d ##class(web.DHCCKBDicLinkAttr).QueryCloByLink(AttrId)
	Q ""
}

ClassMethod GetDataCombo(DataSource, filed = "", q = "")
{
	n (DataSource,filed,q)
	s q=$zcvt(q,"U")
	s count=0
	w "["
	s AttrID=""
	for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DataSource,AttrID)) Q:AttrID=""  d
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(AttrID)				//别名
	.s QueCode=##class(web.DHCCKBCommonUtil).GetPYCODE(Desc)
	.s QueCode=Desc_QueCode_Alias
	.Q:(q'="")&&(QueCode'[q)
	.Q:##class(web.DHCCKBCommon).IsEnabled(AttrID)=0
	.s tmp=Desc_"^"_Desc_"^"_filed
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text^filed",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text^filed",tmp)
	w "]"
	Q ""
}

/// Descript:提交规则
/// Creator:sufan
/// CreateDate:2020-03-04
/// w ##class(web.DHCCKBRule).SubmitRule("397615654","11870^8^1^289^2")
/// w ##class(web.DHCCKBRule).SubmitRule("398045581","11871^8^1^289^2")
ClassMethod SubmitRule(GroupNo, LoginInfo)
{
	n (GroupNo,LoginInfo)

	s baseObj={}
	s ruleObj={}		//规则
	s outPutObj={}		//输出
	s labGenObj={}
	s linkDoseobj={}
	s emRuleObj={}      //空规则key记录
	s ExlanMsg=""
	s MainId=""
	s Temp=""
	s Err=0
	s count=0
	for  s MainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,MainId))   Q:(MainId="")||(Err'=0)  d
	.s Temp=""
	.s TempId=$p(^DHCCKBRULEMAINTAIN(MainId),"^",4)
	.s:TempId'="" Temp=$lg($g(^CT.CKB.PDSS.CommonDictionD(TempId)),3)		//模板
	.s AttrId=$p(^DHCCKBRULEMAINTAIN(MainId),"^",1)     //属性
	.s AttrId=$p(AttrId,"-") // 模板中支持一个属性维护多次,对于多次维护的属性,格式是90975-mul qnp 2022-09-22	
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),2)					//属性code
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),5)
	.s:(Code="")&&(LinkId'="") Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	.s Value=$p(^DHCCKBRULEMAINTAIN(MainId),"^",2)      //属性指
	.s count=count+1
	.s:(count=1)&&((Code="MedDrugNameProp")||(Code="ChineseDrugNameProp"))&&(Value="") Err=-1
	.Q:Err'=0
	.i (Code="MedDrugNameProp")||(Code="ChineseDrugNameProp")||((count=1)&&(Code="GenerNameFormProp"))  d 					//通用名作为药品名称
	..s generID=..getGenerID(AttrId,Value)
	..d labGenObj.%Set("generID",generID)								//记录药品
	.i (count>1)&&(Code="MedDrugNameProp") d 				//记录西药和中药
	..d labGenObj.%Set("MedDrugName",Value)						//西药
	.i (count>1)&&(Code="ChineseDrugNameProp") d 		//中药
	..d labGenObj.%Set("ChineseDrugName",Value)				
	.i (count>1)&&(Code="GenerNameFormProp")  d						
	..d ruleObj.%Set("linkGeneName",Value)
	.i (Code="GenerNameProp")  d							//通用名
	..d ruleObj.%Set("linkGeneNoDos",Value)
	.s ParentId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),4)
	.i ##class(web.DHCCKBDrugRuleMaintain).GetDrugCatDiction(AttrId)=1  d
	..d labGenObj.%Set("labelID",AttrId)								//记录目录
	.i (Code="DrugCategory")||(Code="CombinedDrugCategory")  d
	..i Value ["!"  d ruleObj.%Set("outLinkCat",$tr(Value,"!",""))		//除外的药品类型
	..e  d ruleObj.%Set("linkCat",Value)								//药学分类
	.i Code="Ingredient"   d																
	..i Value ["!" d ruleObj.%Set("outLinkIngre",Value)					//除外的药品成分
	..e   d ruleObj.%Set("linkIngre",Value)								//成分	
	.i Code="环境因素" d ruleObj.%Set("outDrugAsaveOrUpdateDatallergy",Value)			//过敏
	.i Code="LabItmtemp" d ruleObj.%Set("linkLabItm",Value)				//检验指标
	.i Code="LabItmValueLimitProp" d ruleObj.%Set("linkLabValue",Value)	//检验指标值
	.i Code="AgeProp" d ruleObj.%Set("linkAge",Value)					//年龄
	.i Code="Weight" d ruleObj.%Set("linkWeight",Value)					//体重
	.i Code="SexProp" d ruleObj.%Set("linkSex",Value)					//性别
	.i Code="ProfessProp" d ruleObj.%Set("lilnkProfess",Value)			//职业
	.i Code="DrugPreMet" d ruleObj.%Set("linkPreMet",Value)				//给药途径
	.i Code="SolventProp" d ruleObj.%Set("linkSolvent",Value)			//溶媒（带剂型的通用名）
	.i Code="SolventDensity" d ruleObj.%Set("linkSolDens",Value)		//溶媒浓度
	.i Code="Solventvolume" d ruleObj.%Set("linkSolVolume",Value)		//溶媒体积
	.i Code="SolutionProp" d ruleObj.%Set("linkSolution",Value)			//溶液（带剂型的通用名）
	.i Code="SolutionDensity" d ruleObj.%Set("linkSolutionDens",Value)	//溶液浓度
	.i Code="SolutionVolume" d ruleObj.%Set("linkSolutionVolume",Value)	//溶液体积
	.i Code="DurgSpeedProp" d ruleObj.%Set("linkSpeed",Value)			//给药速度
	.i Code="DrugUseTime" d ruleObj.%Set("linkDrugUseTime",Value)		//给药时间
	.
		
	./*频次剂量用药时长拼串*/												//
	.i Code="OnceDose"  d ruleObj.%Set("OnceDose",Value)					//单次剂量
	.i Code="DayDose"   d linkDoseobj.%Set(Code,Value)					//每日用药量
	.i Code="DrugFreq"  d 
	..d linkDoseobj.%Set(Code,Value)									//用药频率
	..d ruleObj.%Set("DrugFreq",Value)
	.i Code="TreatDayNUm"  d 
	..d linkDoseobj.%Set(Code,Value)									//疗程内用药时长
	..d ruleObj.%Set("TreatDayNUm",Value)
	./*频次剂量用药时长拼串*/
	.
	.i Code="IsFirstUseProp" d ruleObj.%Set("isFirst",Value)			//是否首次
	.i Code="DayDoseMax" d
	..i Value'="" d ruleObj.%Set("linkDoseMax",Value_"/日")				//单日最大量
	.i Code="OnceDoseMax" d
	..i Value'="" d ruleObj.%Set("onceDoseMax",Value_"/次")				//单次最大量
	.i Code="DayDoseLimit"  d
	..i Value'="" d ruleObj.%Set("linkDoseLimit",Value_"/日")			//单日极量
	.i Code="OnceDoseLimit"  d
	..i Value'="" d ruleObj.%Set("onceDoseLimit",Value_"/次")			//单次极量
	.i Code="Treatment" d ruleObj.%Set("linkTreat",Value)				//疗程
	.i Code="TreatBettenDayNum" d ruleObj.%Set("linkSpaceTreat",Value)	//疗程间间隔
	.i Code="carryUseDrugTime" d ruleObj.%Set("carryUseDrug",Value)		//连续用药
	.i Code="TogetherProp" d ruleObj.%Set("togetherType",Value)			//合用类别
	.i Code="SpecialPop" d ruleObj.%Set("linkPeople",Value)				//人群
	.i Code="DiseaseDesc"   d
	..i Value["!" d ruleObj.%Set("outLinkDis",Value)					//除外病症
	..e  d ruleObj.%Set("linkDisease",Value) 							//病症
	.i Code="ChineseDiseaseName"	d									//
	..i Value["!" d ruleObj.%Set("outCHNLinkDis",Value)					//除外中医疾病
	..e  d ruleObj.%Set("linkCHNDisease",Value) 						//中医疾病
	.i Code="BacteriaDesc"  d
	..i Value["!" d ruleObj.%Set("outLinkVirus",Value)					//除外病原体
	..e  d ruleObj.%Set("linkVirus",Value) 								//病原体
	.i Code="BacteriaCaDesc"  d
	..d ruleObj.%Set("linkVirusCat",Value)								//病原体组
	.i Code="SymptomDesc"  d
	..i Value["!" d ruleObj.%Set("outLinkSym",Value)					//除外症状
	..e  d ruleObj.%Set("linkSym",Value) 								//症状
	.i Code="ProNameProp"  d											//商品名
	..d ruleObj.%Set("linkProName",Value)
	.//输出信息
	.i Code="ControlLevel"	 d
	..i Temp["过敏" d outPutObj.%Set("alertCat",Value_"(过敏)")			//警戒类型（慎用）
	..e  d outPutObj.%Set("alertCat",Value)
	.i Code="WarnMessage"  d
	..d outPutObj.%Set("linkErrMsg",Value)								//提示信息
	.s:(Code="LevelFlag")&&(Value="") Err=-2
	.Q:Err<0
	.i Code="LevelFlag"  d 
	..s Value=..GetLevByDesc(Value)
	..d outPutObj.%Set("levelMsg",Value)								//管理级别
	.i Code="SourceMsg"  d outPutObj.%Set("msgSource",Value)			//提示依据
	.i Code="OutMsgTipsFlag"  d outPutObj.%Set("OutMsgTips",Value)		//提醒标记
	.i Code="ExcipientProp" d ruleObj.%Set("itmExcipient",Value)
	.i Code="KnowSource" d outPutObj.%Set("knowledgeSource",Value)		// 知识来源

	./**溶媒溶液**/
	.i Code="SingleSolMass" d ruleObj.%Set("sinSoluMass",Value)			//单支溶质量
	.i Code="NeceSolMed" d ruleObj.%Set("isNeceSolMed",Value)			//是否必用溶媒药品
	.i Code="SingleOrdVehVol" d ruleObj.%Set("sinOrdVehVol",Value)		//单次医嘱对应溶媒量
	.i Code="NeceSolDrug" d ruleObj.%Set("isNeceSolDrug",Value)			//是否必用溶液药品
	.i Code="SingleOrdCorQua" d ruleObj.%Set("sinOrdCor",Value)			//单次医嘱对应溶液量
	.i Code="AuxDrugsNum" d ruleObj.%Set("auxDrugsNum",Value)			//辅助用药个数
	.i Code="BodySurAreaProp" d ruleObj.%Set("bodySurArea",Value)		//体表面积
	.i Code="DiluteProp" d ruleObj.%Set("isDiluteProp",Value)			//必须稀释后给药

	/***溶媒溶液key设置**/
	//单支溶质量 sinSoluMass,是否必用溶媒药品 isNeceSolMed,单次医嘱对应溶媒量 sinOrdVehVol
	//是否必用溶液药品 isNeceSolDrug,单次医嘱对应溶液量 sinOrdCor,辅助用药个数 auxDrugsNum
	
	s DayDos=linkDoseobj.%Get("DayDose")
	//i linkDoseobj.%Get("OnceDose")'=""	s DayDos=linkDoseobj.%Get("OnceDose")	//单次剂量
	//e  i (linkDoseobj.%Get("DayDose")'="")&&(DayDos="")  d
	//.d linkDoseobj.%Set("DayDose",linkDoseobj.%Get("DayDose")_"/日")
	//.s DayDos=linkDoseobj.%Get("DayDose")								//每日用药量
	
	s linkDose=DayDos_","_""_","_linkDoseobj.%Get("TreatDayNUm")
	d ruleObj.%Set("linkDose",linkDose)									//剂量,频次,疗程内用药时长
	
	/*对溶液部分设置空的数组,单独处理*/
	d ruleObj.%Set("linkDrugDose","")	

	//空规则key设置
	s emRuleObj={}      //空规则key记录
	i Temp["用药指导(西药)" d 
	.d emRuleObj.%Set("empRuletip","MedGuidRemProp")
	e  i Temp["用药指导(中成药）"  d
	.d emRuleObj.%Set("empRuletip","ChnGuidRemProp")
	e  d 
	.d emRuleObj.%Set("empRuletip","TipsAtOnceProp")
	
	//病原体,病原体组,病原体除外
	//与适应症相关的不明确列,特别推荐,手术时段
	
	
	s Str="商品名:"_ruleObj.%Get("linkProName")_"^通用名带剂型:"_ruleObj.%Get("linkGeneName")_"^药学分类:"_ruleObj.%Get("linkCat")
	s Str=Str_"^成分:"_ruleObj.%Get("linkIngre")_"^过敏:"_ruleObj.%Get("outDrugAllergy")_"^年龄:"_ruleObj.%Get("linkAge")
	s Str=Str_"^体重:"_ruleObj.%Get("linkWeight")_"^性别:"_ruleObj.%Get("linkSex")_"^职业:"_ruleObj.%Get("lilnkProfess")
	s Str=Str_"^给药途径:"_ruleObj.%Get("linkPreMet")_"^溶媒:"_ruleObj.%Get("linkSolvent")_"^溶媒浓度:"_ruleObj.%Get("linkSolDens")
	s Str=Str_"^溶媒体积:"_ruleObj.%Get("linkSolVolume")_"^溶液:"_ruleObj.%Get("linkSolution")_"^溶液浓度:"_ruleObj.%Get("linkSolutionDens")
	s Str=Str_"^溶液体积:"_ruleObj.%Get("linkSolutionVolume")_"^给药速度:"_ruleObj.%Get("linkSpeed")_"^给药时间:"_ruleObj.%Get("linkDrugUseTime")
	s Str=Str_"^剂量,频次,疗程内用药时长:"_ruleObj.%Get("linkDose")_"^是否首次:"_ruleObj.%Get("isFirst")_"^最大量:"_ruleObj.%Get("linkDoseMax")
	s Str=Str_"^极量:"_ruleObj.%Get("linkDoseLimit")_"^疗程:"_ruleObj.%Get("linkTreat")_"^疗程间间隔:"_ruleObj.%Get("linkSpaceTreat")
	s Str=Str_"^连续用药:"_ruleObj.%Get("carryUseDrug")_"^合用类别:"_ruleObj.%Get("togetherType")_"^人群:"_ruleObj.%Get("linkPeople")
	s Str=Str_"^病症:"_ruleObj.%Get("linkDisease")_"^除外病症:"_ruleObj.%Get("outLinkDis")_"^病原体:"_ruleObj.%Get("linkVirus")
	s Str=Str_"^病原体组:"_ruleObj.%Get("linkVirusCat")_"^症状:"_ruleObj.%Get("linkSym")_"^除外症状:"_ruleObj.%Get("outLinkSym")
	s Str=Str_"^警戒类型（慎用）:"_outPutObj.%Get("alertCat")_"^提示信息:"_outPutObj.%Get("linkErrMsg")_"^提示级别:"_outPutObj.%Get("levelMsg")
	s Str=Str_"^提示依据:"_outPutObj.%Get("msgSource")_"^药品:"_labGenObj.%Get("generID")_"^目录："_labGenObj.%Get("labelID")
	s Str=Str_"^检验指标:"_ruleObj.%Get("linkLabItm")_"^检验指标值:"_ruleObj.%Get("linkLabValue")_"^提醒标记:"_outPutObj.%Get("OutMsgTips")
	s Str=Str_"^过敏:"_outPutObj.%Get("alertCat")_"^通用名:"_outPutObj.%Get("linkGeneNoDos")_"^知识来源:"_outPutObj.%Get("knowledgeSource")
	Q:Err'=0 Err					
	TS

	s Jsonstr=##class(web.DHCCKBRuleImport).ImportNew(baseObj,ruleObj,outPutObj,1,0,1,labGenObj,"",LoginInfo,emRuleObj)
	//s Err=##class(web.DHCCKBRuleImport).Import(baseObj,ruleObj,outPutObj,1,0,1,"","",1,labGenObj)

	s JsonObj=##class(%DynamicAbstractObject).%FromJSON(Jsonstr)
	i JsonObj.code="err" TRO			///提交不成功 ，回滚
	Q:JsonObj.code="err" Jsonstr		///返回错误数据	
	i JsonObj.code="success" d			///更新提价标识	
	.s Err=..UpdSubFlag(GroupNo,1,JsonObj)	
	i Err'=0 TRO	
	Q:Err'=0 Err
	TC
	q Jsonstr
}

/// Descript:更新提交标识
/// Creator:sufan
/// CreateDate:2020-04-01
/// Input:组号
/// return:0:成功，其他：失败
/// w ##class(web.DHCCKBRuleMaintain).UpdSubFlag(1792655)
ClassMethod UpdSubFlag(GroupNo, Flag, JsonObj = "", rule = "")
{
	n (GroupNo,Flag,JsonObj,rule)
	s ^temptest("333311")=$lb(GroupNo,Flag,JsonObj,rule)
	s Err=0
	TS
	///删除之前的规则
	s RuleId=""
	i JsonObj'=""  d
	.s RuleId=JsonObj.rule			//规则ID
	.s RuleMainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,""))
	.s DicRuleId=$p(^DHCCKBRULEMAINTAIN(RuleMainId),"^",6)
	.i (DicRuleId'="")&&($d(^CT.CKB.PDSS.RuleD(DicRuleId)))  d
	..s Err=##class(web.DHCCKBRuleSave).RemoveRule(DicRuleId)
	i Err'=0 tro
	Q:Err'=0 Err
	
	i rule'=""  d
	.s Err=##class(web.DHCCKBRuleSave).RemoveRule(rule)
	i Err'=0 tro
	Q:Err'=0 Err
	///更新新的规则
	s MainId=""
	for  s MainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,MainId)) Q:(MainId="")||(Err'=0)  d
	.s Err=..UpdRuleMain(MainId,Flag,RuleId)
	.Q:Err'=0
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Descript:更新规则维护表提交标识和规则id
/// Creator:sufan
/// CreateDate:2020-05-03
/// Input:维护表ID，提交标识，规则提交返回对象
/// return:0:成功，其他：失败
/// w ##class(web.DHCCKBRuleMaintain).UpdRuleMain(52471,1,1)
ClassMethod UpdRuleMain(MainId, Flag, RuleId = "")
{
	n (MainId, Flag, RuleId)
	&sql(update DHC_CKBRuleMaintain set RM_Flag=:Flag,RM_Rule_Dr=:RuleId where RM_RowId=:MainId)
	Q SQLCODE
}

/// Descript:取药品id
/// Creator:sufan
/// CreateDate:2020-04-01
/// Input:属性，药品名称
/// w ##class(web.DHCCKBRuleMaintain).getGenerID(81224,"西格列汀二甲双胍片(Ⅱ)")
ClassMethod getGenerID(AttrId, DrugDesc)
{
	n (AttrId,DrugDesc)
	s SourceId=##class(web.DHCCKBCommon).GetDataSource()
	s DlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrId,SourceId,""))
	s SouDicId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DlaRowId)),4)
	s Ret=""
	s Id="" 
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(DrugDesc),Id)) Q:Id=""  d
	.s Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),4)
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.Q:Parref'=SouDicId
	.s Ret=Id
	Q Ret
}

/// w ##class(web.DHCCKBRuleMaintain).GetLevByDesc("对用药过程的指导")
ClassMethod GetLevByDesc(LevDesc)
{
	n (LevDesc)
	s LevId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(LevDesc),""))
	Q:LevId="" ""
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LevId)),2)
	s Value=##class(web.DHCCKBCommon).GetManLevelNum(Code)
	Q Value
}

/// w ##class(web.DHCCKBRule).GetIdByDesc("对用药过程的指导")
ClassMethod GetIdByDesc(LevDesc)
{
	n (LevDesc)
	s LevId=""
	s LevId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(LevDesc),""))
	Q LevId
}

/// Descript:批量提交规则
/// Creator:xww
/// CreateDate:2021-08-17
/// w ##class(web.DHCCKBRule).SubmitAllRule("397615654","12018^9^1^289^2")
/// w ##class(web.DHCCKBRule).SubmitAllRule("398044990","11871^8^1^289^2")
ClassMethod SubmitAllRule(AllGroupNo, LoginInfo)
{
	n (AllGroupNo, LoginInfo)

	s retObj = {}
	s retObj.code = "success"
	
	s $zt="SubmitError"
	s resStr=0
	TStart
	for i=1:1:$l(AllGroupNo,"&&") q:(retObj.code'="success")  d
	.s groupNo=$p(AllGroupNo,"&&",i)
    .s resStr=##class(web.DHCCKBRule).SubmitRule(groupNo, LoginInfo)
    .i resStr'["code" s retObj.code = resStr
    .e  s resStr={}.%FromJSON(resStr),retObj = resStr
       
    i (retObj.code'="success") d
    .TRollback
	e  d
	.Tcommit
	
    q retObj.%ToJSON()
SubmitError    
   TRollback
   s retObj.msg=$ze
   q retObj.%ToJSON()
}

}

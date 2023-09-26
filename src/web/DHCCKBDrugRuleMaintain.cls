Import sqluser

Class web.DHCCKBDrugRuleMaintain Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      sufan 
/// CreatDate：    2020-04-23
/// Description:： 取模板类型
/// Table：        
/// Others：       w ##class(web.DHCCKBDrugRuleMaintain).ListModelTree()
ClassMethod ListModelTree()
{
	s DirTemp=##class(web.DHCCKBCommon).GetDicIdByCode("规则拆分模板")  
	s count=0
	w "["
	s id="" 
	for  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DirTemp,id)) q:id=""  d
	.s Text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",id_"^"_Text)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",id_"^"_Text)
	w "]"
	q ""
}

/// Creator：      sufan 
/// CreatDate：    2020-04-24
/// Description:： 取模板
/// Table：        
/// Others：       w ##class(web.DHCCKBDrugRuleMaintain).ListModel()
ClassMethod ListModel(TypeId)
{
	n (TypeId) 
	s count=0
	w "["
	s id="" 
	for  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",TypeId,id)) q:id=""  d
	.s Text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",id_"^"_Text)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",id_"^"_Text)
	w "]"
	q ""
}

/// Creator：      sufan 
/// CreatDate：    2020-04-23
/// Description:： 加载药品列表
/// Table：        
/// Others：       w ##class(web.DHCCKBDrugRuleMaintain).QueryDrugList("30","1","西药模板")
ClassMethod QueryDrugList(rows, page, params = "", UserInfo = "")
{
	n (rows,page,params,UserInfo)
	s ^temptest("12233")=$lb(rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)    				//k掉临时global
	s TempDesc=$p(params,"^",1)  			//模板名称
	s Desc=$p(params,"^",2)					//检索条件
	s WestDrugId=##class(web.DHCCKBCommon).GetDrugData()			//西药字典
	s ChnDrugId=##class(web.DHCCKBCommon).GetChineseDrugData()      //中成药字典
	s GenDrugId=##class(web.DHCCKBCommon).GetGeneralFromData()      //通用名字典
	s PrentId=$s((TempDesc="西药模板")||(TempDesc="西药用药指导"):WestDrugId,TempDesc="中成药模板":ChnDrugId,TempDesc="通用名模板":GenDrugId,1:"")
	Q:PrentId="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) 
	s h=0,count=0
	s DrugId=""
	f  s DrugId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PrentId,DrugId)) q:DrugId=""  d  
	.q:DrugId=0
	.q:0=##class(web.DHCCKBCommon).IsShow(DrugId,"DHC_CKBCommonDiction",UserInfo)	// qunianpeng 2020/05/09 是否停用
	.s DrugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),3)	
	.s DrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),2)	
	.s Pindata=##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(DrugDesc))
	.Q:(Desc'="")&&(DrugDesc'[Desc)&&(DrugCode'[Desc)&&(Pindata'[$$ALPHAUP^SSUTIL4(Desc))
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DrugId)		//判断是否有规则
	.s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	.s RuleImg=$s(ruleFlag=1:Img,1:"")
	.s h=h+1
	.s tempstr=DrugId_"^"_DrugDesc_"^"_RuleImg
	.s ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryDrugList",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="DrugId^DrugDesc^RuleFlag"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryDrugList",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryDrugList",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan 
/// CreatDate：    2020-04-23
/// Description:： 加载模板列表
/// Table：        
/// Others：       w ##class(web.DHCCKBDrugRuleMaintain).QueryTempList("30","1","81869")
ClassMethod QueryTempList(rows, page, params = "")
{
	n (rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)    				//k掉临时global
	s PaTempId=$p(params,"^",1)  			//模板名称
	Q:PaTempId="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) 
	s h=0,count=0
	s TempId=""
	f  s TempId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaTempId,TempId)) q:TempId=""  d  
	.q:TempId=0
	.s TempDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(TempId)),3)	
	.s h=h+1
	.s tempstr=TempId_"^"_TempDesc
	.s ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryTempList",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="TempId^TempDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryTempList",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryTempList",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan 
/// CreatDate：    2020-04-23
/// Description:： 获取字典ID
/// Table：        
/// Others：       w ##class(web.DHCCKBDrugRuleMaintain).getDictionId("西药模板")
ClassMethod getDictionId(Temp)
{
	n (Temp)
	s WestDrugId=##class(web.DHCCKBCommon).GetDrugData()			//西药字典
	s ChnDrugId=##class(web.DHCCKBCommon).GetChineseDrugData()      //中成药字典
	s PrentId=$s(Temp="西药模板":WestDrugId,Temp="中成药模板":ChnDrugId,1:"")
	Q PrentId
}

/// Creator：      sufan 
/// CreatDate：    2020-04-23
/// Description:： 获取字典ID
/// Table：        
/// Others：       w ##class(web.DHCCKBDrugRuleMaintain).getArcFeild("西药模板")
ClassMethod getArcFeild(Temp)
{
	n (Temp)
	s MedDrugId=##class(web.DHCCKBCommon).GetMedDrugNameProp()			//西药名称属性
	s ChiDrugId=##class(web.DHCCKBCommon).GetChineseDrugNameProp()      //中成药名称属性
	s FeildId=$s(Temp="西药模板":MedDrugId,Temp="中成药模板":ChiDrugId,1:"")
	Q FeildId
}

/// w ##class(web.DHCCKBDrugRuleMaintain).ListModelData("77680","1","30","2^262554^81869")
ClassMethod ListModelData(parent = "", page, rows, params = "")
{
	
	n (parent,page,rows,params)
	s ^temptest("122")=$lb(parent,page,rows,params)
    s start=(page-1)*rows+1
    s end=page*rows
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")   //模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()			//数据目录字典
	Q:parent="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) 
	s ChnDrugProp=##class(web.DHCCKBCommon).GetChineseDrugNameProp()
	s MedDrugProp=##class(web.DHCCKBCommon).GetMedDrugNameProp()
	s GenDrugProp=##class(web.DHCCKBCommon).GetGeneralFromProp()
	s Type=$p(params,"^",1)				//类型
	s DrugId=$p(params,"^",2)
	s TempTypeId=$p(params,"^",3)		//模板类型
	s TempType=$lg($g(^CT.CKB.PDSS.CommonDictionD(TempTypeId)),3)
	
	s PropCode=$s((TempType="西药模板"):MedDrugProp,TempType="中成药模板":ChnDrugProp,TempType="通用名模板":GenDrugProp,1:"")
	Q:PropCode="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) 
	s Drug=""
	s:DrugId'="" Drug=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),3)
	s Rmdesc=$$ALPHAUP^SSUTIL4(Drug)
	
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",length=0,olength=0
	s clomnobj={}
	d clomnobj.%Set("ID","")
	s link=""
	f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+parent,+TempElement,link)) q:link=""  d  
	.q:link=0
	.//s length=length+1
	.s dic=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)				//数据源字典RowID
	.s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3)   			//列名
	.s catalog=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),4)			//目录字典特殊处理
    .s:catalog=DrugLibaryData dic="catalog"
	.d clomnobj.%Set(dic,"")	
	.d clomnobj.%Set(dic_"Id","")
	
	//w $h ^DHCCKBRULEMAINTAIN(0,"TempDesc",{RM_Temp},{RM_Code},{RM_Text},{RM_GroupNo},{RM_RowID})
	w "{""rows"":["	
	s count=0
	s GroupNo="" f  s GroupNo=$o(^DHCCKBRULEMAINTAIN(0,"TempDesc",parent,PropCode,Rmdesc,GroupNo),-1)  q:GroupNo=""  d  //组号
	.k newclomnobj
	.s newclomnobj = clomnobj	// 当模板增加列时，若新增的列维护了数据，旧模板中没有维护数据，会导致旧模板中新加的列显示了错误的新模板的数据，因此需要每次重新setObj qnp 2022-09-22
	.s rule=GroupNo		
	.s MainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,""))
	.s OperType = $p(^DHCCKBRULEMAINTAIN(MainId),"^",5)
	.s ruleId = $p(^DHCCKBRULEMAINTAIN(MainId),"^",6)
	.Q:OperType=3
	.Q:(Type'="2")&&(OperType'=Type)	
	.s DrugDesc=""								
	.s Temp="",MarkCount=0
	.s id="" f  s id=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,id)) q:id=""  d
	..s tableTitle=$p(^DHCCKBRULEMAINTAIN(id),"^",1)	//标题
	..s newTableTitle = $p(tableTitle,"-")	// / 模板中支持一个属性维护多次,对于多次维护的属性,格式是90975-mul qnp 2022-09-22
	..d newclomnobj.%Set(tableTitle,"")	
	..d newclomnobj.%Set(tableTitle_"Id","")
	..s LinkId=""
	..s:tableTitle'="" LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(newTableTitle)),5)
	..s Code=""
	..s:tableTitle'="" Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(newTableTitle)),2)
	..s:(Code="")&&(LinkId'="") Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	..s isDataSource=##class(web.DHCCKBRuleMaintain).isDataSource(newTableTitle)   //是否有数据源或为目录字典
	..s catalogD=$lg($g(^CT.CKB.PDSS.CommonDictionD(newTableTitle)),4)
	..s Temp=$lg($g(^CT.CKB.PDSS.CommonDictionD(newTableTitle)),5)
    ..s:##class(web.DHCCKBDrugRuleMaintain).GetDrugCatDiction(newTableTitle)=1 tableTitle="catalog"
	..s dataDic=""
	..s dataDic=$p(^DHCCKBRULEMAINTAIN(id),"^",2)		//内容
	..s:((Code="MedDrugNameProp")||(Code="ChineseDrugNameProp")||((Code="GenerNameFormProp")&&(MarkCount=0)&&(dataDic'=""))) DrugDesc=dataDic
	..s fieldIdData=dataDic							  //fieldId显示内容的ID
	..d newclomnobj.%Set(tableTitle,dataDic)	
	..d newclomnobj.%Set(tableTitle_"Id",fieldIdData)
	..;i Code="GenerNameFormProp" s MarkCount = MarkCount + 1
	..s MarkCount = MarkCount + 1
	.Q:(Drug'="")&&(DrugDesc'="")&&(DrugDesc'[Drug)
	.d newclomnobj.%Set("ID",GroupNo)
	.d newclomnobj.%Set("GroupNo",GroupNo)
	.d newclomnobj.%Set("ruleId",ruleId)
	.// start
	.s ShowFlag=$select(OperType=0:"(保存)",OperType=1:"(提交)",OperType=2:"(删除)",1:"")
	.i ShowFlag'="" s ShowFlag="<span style='color:red'>"_ShowFlag_"</span>"
	.d newclomnobj.%Set("ShowFlag",ShowFlag)
	.// end qunianpeng 2020-04-30 增加状态标识
    .s count=count+1
    .q:count<start
    .q:count>end
    .w $case(count,start:"",:",")
    .w newclomnobj.%ToJSON()
    .d newclomnobj.%Set(tableTitle,"")	
	.d newclomnobj.%Set(tableTitle_"Id","")
    w "],""total"":"_count_"}"
	//w $h
	q ""
}

/// Creator: xiaowenwu
/// Date:	2020-02-13
/// Desc:   动态输出模板的datagrid的表头
/// Input:	dicId：模板ID
/// Other: 	w ##class(web.DHCCKBDrugRuleMaintain).ListModelDataGrid(260716)
ClassMethod ListModelDataGrid(dicId)
{
	
	n (dicId)

	s columns=[]
	
	s column={}	// xww 2021-08-17 多选列
	s column.title="sel" 
 	s column.field="check"
 	s column.checkbox="true"
	d columns.%Push(column)
	
	s column={}	// qunianpeng 2020-04-30 增加状态列
	s column.title="状态" 
 	s column.field="ShowFlag"
	d columns.%Push(column)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()					//数据源 28
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  	//模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()			//数据目录字典
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","SortAttrByOrdNum",pid)
	//排序
	d ##class(web.DHCCKBDrugRuleMaintain).SortAttrByOrdNum(dicId,pid)
	//取数据
	
	k markColArr
	s Index=""
	f  s Index=$o(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","SortAttrByOrdNum",pid,Index)) q:Index=""  d  
	.s ListData=^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","SortAttrByOrdNum",pid,Index)
	.s linkRowId=$p(ListData,"^",1)
	.s attrCodeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),3)	// 属性ID
	.s attrValueDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),4)	// 属性值ID
	.s attrResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),5)	// 内容
	.s attrCodeDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCodeDr)),3)
	.i attrValueDr'="" s attrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)			
	.//界面显示列
	.s column={}
	.s data=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),4)			// 属性值ID 
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),2)	// 标题code
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),5)
	.s:(code="")&&(LinkId'="") code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
    .s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)	// 标题
    .s catalog=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),4) // 上级目录
    .s:catalog=DrugLibaryData data="catalog"		//	该列为目录列时特殊处理
    .i $d(markColArr(data)) s column.field=data_"-mul"  // 模板中支持一个属性维护多次,对于多次维护的属性,格式是90975-mul qnp 2022-09-22
    .e  s column.field=data     
    .s width=$s(code="RuleUsage":80,code="RuleIndic":80,code="RuleContr":80,code="Taboo":80,code="InterEach":80,code="DrugIrri":80,code="FunIndicat":80,code="LevelFlag":80,code="ControlLevel":80,code="OutMsgTipsFlag":80,code="AgeProp":80,code="SexProp":80,code="TogetherProp":80,code="SourceMsg":80,code="DrugPreMet":80,code="OnceDose":100,code="OnceDoseMax":100,code="OnceDoseLimit":100,code="DayDose":100,code="DayDoseMax":100,code="DayDoseLimit":100,code="SolventDensity":100,code="Solventvolume":100,code="SolutionDensity":100,code="SolutionVolume":100,code="Treatment":100,code="DrugFreq":100,code="LabItmValueLimitProp":100,1:200)
    .s column.width=width
    .s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),5)
    .i (title="")&&(LinkId'="") s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
    .i $d(markColArr(data)) s column.title=title_"(规则分支)" 
    .e  s column.title=title 
    .d column.%Set("hidden",0,"boolean")
	.s column.editor={}.%Set("type","validatebox")
	.d columns.%Push(column)
	.//界面隐藏列
	.s columnHidden={}
	.s data=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),4) 
	.s catalog=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),4)
    .s:catalog=DrugLibaryData data="catalog"	//该列为目录列时特殊处理
    .i $d(markColArr(data)) s columnHidden.field=data_"-mul"_"Id"  // 模板中支持一个属性维护多次,对于多次维护的属性,格式是90975-mul qnp 2022-09-22
    .e  s columnHidden.field=data_"Id" 
    .s columnHidden.width=200
    .s columnHidden.title=data
	.s columnHidden.editor={}.%Set("type","validatebox")
	.d columnHidden.%Set("hidden",1,"boolean")
	.d columns.%Push(columnHidden)
	.s markColArr(data)=""  
	w columns.%ToJSON()
	q ""
}

/// Creator：      sufan
/// CreatDate：    2020-05-18
/// Description:： 按顺序号排序
/// Table：        
/// Others：       w ##class(web.DHCCKBDrugRuleMaintain).ListModelTree()
ClassMethod SortAttrByOrdNum(dicId, pid)
{
	n (dicId,pid)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()					//数据源 28
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  	//模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()			//数据目录字典
	s OrdNumAttrId=##class(web.DHCCKBCommon).GetOrdNumId()					//顺序号属性
	
	s count=0
	s linkRowId=""
	f  s linkRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicId,+TempElement,linkRowId)) q:linkRowId=""  d  
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
	.s ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","SortAttrByOrdNum",pid,OrdNum)=linkRowId_"^"_attrValueDr
	q ""
}

/// Description:	查询实体字典列表
/// Creator:		sufan 
/// CreateDate:		2020-04-23
/// Input:			id
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDrugRuleMaintain).QueryDicList("30","1","38","减毒活疫苗")
ClassMethod QueryDicList(rows = 30, page = 1, id As %String = "", parDesc = "") As %String
{
	n (rows,page,id,parDesc)
	s ^temptest("11234")=$lb(rows,page,id,parDesc)
	s h1=$p($h,",",2)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	Q:id="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s Ret=""
	i id="catalog" d
	.s Ret = ..QueryCatData(rows,page,id,parDesc)
	e  d
	.s Ret = ..QueryAtrrData(rows,page,id,parDesc)
	s h2=$p($h,",",2)
	
	s h3=h2-h1
	
	q Ret
}

/// Description:	查询实体字典列表
/// Creator:		sufan 
/// CreateDate:		2020-02-17	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDrugRuleMaintain).QueryAtrrData("30","1","38","喹喏酮类")
ClassMethod QueryAtrrData(rows = 30, page = 1, id As %String = "", parDesc = "")
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
	
	Q:($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId)))&&(CodeDic'="Ingredient") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	if ($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId)))&&(CodeDic'="Ingredient")  d
	.s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId,""))
	.s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)
	.d ##class(web.DHCCKBDicLinkAttr).QueryCloByLink(AttrId)
	e  d
	.s Ret=..QueryEntyList(rows,page,field,parDesc)
	Q Ret
}

/// Description:	查询实体字典列表
/// Creator:		sufan 
/// CreateDate:		2020-02-17	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDrugRuleMaintain).QueryCatData("30","1","75038","")
ClassMethod QueryCatData(rows, page, id, parDes)
{
	n (rows,page,id,parDes)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	d ..killTmpGlobal(pid)	
	Q:id="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("用药指导"),""))
	s h = 0
	s dicId=""
	for  s dicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicId))   q:dicId=""  d
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.s:id'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),5)
	.s linkDesc=""
	.i linkDr'="" d
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc=dicDesc
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(dicId)			//别名
	.s PinCode =""   //##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(DicDesc))
	.q:(dicDesc["作废")||(dicDesc["停用")||(dicDesc["ZF")||(dicDesc["zf")
	.s ExistFlag=##class(web.DHCCKBQueryDic).IsExistSubNode(dicId,parDes)
	.Q:(ExistFlag=0)&&((dicDesc'[parDes)&&(dicCode'[parDes)&&(Alias'[parDes))
	.s h=h+1									
	.i ((dicDesc[parDes)||(dicCode[parDes)||(Alias[parDes)) d
	..s data=dicId_"^"_dicCode_"^"_dicDesc_"^"_id_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc_"^"_Alias
	..s ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid,dicId)=data
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicId))  d
	..d ..GetSubItem(dicId,pid,parDes)
	
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s ListTitle="DicID^DicCode^DicDesc^ParentId^ParrefDesc^LinkDr^LinkDesc^Alias"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid,index))
	.s Id=$p(ListData,"^",1)
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)	
	w "],""total"":"_count_"}"
	d ..killTmpGlobal(pid)
	q ""
}

/// Description:	查询实体字典列表
/// Creator:		sufan 
/// CreateDate:		2020-02-17	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDrugRuleMaintain).QueryEntyList("30","1","38","副交感神经阻滞")
ClassMethod QueryEntyList(rows = 30, page = 1, Id As %String = "", Input = "") As %String
{
	n (rows,page,Id,Input)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s end=page*rows
	s start=(page-1)*rows+1
	s IdList=""														//数据源list
	s Link=""														//数据源有多个问题处理sufan20200414
	for  s Link=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,Id,Link)) Q:Link=""  d   //是否关联数据源
	.s:Link'="" SourId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(Link)),4)					//关联的数据源
	.i IdList=""  s IdList=SourId
	.e  s IdList=IdList_"^"_SourId									//数据换拼串
	
	Q:IdList="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	d ..killTmpGlobal(pid)	
	s h=0
	s Len=$l(IdList,"^")
	for i=1:1:Len  d
	.s ParentId=$p(IdList,"^",i)
	.s DicID=""  
	.f  s DicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,DicID))   q:DicID=""  d
	..s DicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),2)
	..s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),3)
	..s:ParentId'="" ParrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ParentId)),3)
	..s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),5)
	..s LinkDesc=""
	..i LinkDr'="" d
	...s DicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkDr)),2)
	...s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkDr)),3)
	...s LinkDesc=DicDesc
	..s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(DicID)	
	..s PinCode =""   //##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(DicDesc))
	..s ExistFlag=0
	..q:(DicDesc["作废")||(DicDesc["停用")||(DicDesc["ZF")||(DicDesc["zf")
	..s:ParentId=##class(web.DHCCKBCommon).GetDrugCategoryData() ExistFlag=##class(web.DHCCKBQueryDic).IsExistSubNode(DicID,Input)
	..Q:(ExistFlag=0)&&((DicDesc'[Input)&&(DicCode'[Input)&&(Alias'[Input))
	..s h=h+1									//别名
	..i ((DicDesc[Input)||(DicCode[Input)||(Alias[Input)) d
	...s data=DicID_"^"_DicCode_"^"_DicDesc_"^"_ParentId_"^"_$g(ParrefDesc)_"^"_LinkDr_"^"_LinkDesc_"^"_Alias
	...s ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid,DicID)=data
	..i $d(^CT.CKB.PDSS.CommonDictionI("Parref",DicID))  d
	...d ..GetSubItem(DicID,pid,Input)

	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s ListTitle="DicID^DicCode^DicDesc^ParentId^ParrefDesc^LinkDr^LinkDesc^Alias"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid,index))
	.s Id=$p(ListData,"^",1)
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)	
	w "],""total"":"_count_"}"
	d ..killTmpGlobal(pid)
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
	.s PinDesc=""  //##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DicDesc))
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(Id)				//别名
	.s ExistFlag=##class(web.DHCCKBQueryDic).IsExistSubNode(Id,Input)
	.Q:(ExistFlag=0)&&((DicDesc'[Input)&&(DicCode'[Input)&&(Alias'[Input))
	.i ((DicDesc[Input)||(DicCode[Input)||(Alias[Input))  d
	..s data=Id_"^"_DicCode_"^"_DicDesc_"^"_Parref_"^"_$g(ParrefDesc)_"^"_DicLink_"^"_DicDesc_"^"_Alias
	..s ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid,Id)=data
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",Id))  d
	..d ..GetSubItem(Id,pid,Input)
	Q ""
}

/// Descript:取药品实体类别
/// CreateDate:2020-05-07
/// Creator:sufan
/// Input:药品Id
/// Retrun:实体Id
/// w ##class(web.DHCCKBDrugRuleMaintain).GetEntyId(150)
ClassMethod GetEntyId(DrugId)
{
	n (DrugId)
	s EntyId=""
	s ParentId=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),4)
	i ParentId=##class(web.DHCCKBCommon).GetDrugData() s EntyId=##class(web.DHCCKBCommon).GetDrug()
	i ParentId=##class(web.DHCCKBCommon).GetChineseDrugData() s EntyId=##class(web.DHCCKBCommon).GetChineseDrug()
	Q EntyId
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryDrugList",pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryTempList",pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugRuleMaintain","QueryEntyList",pid)
}

/// w ##class(web.DHCCKBDrugRuleMaintain).ListModelDataNew("75369","1","30","2^87100")
ClassMethod ListModelDataNew(parent = "", page, rows, params = "")
{
	
	n (parent,page,rows,params)
	s ^temptest("122")=$lb(parent,page,rows,params)
    s start=(page-1)*rows+1
    s end=page*rows
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s TempElement=##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")  //模板元素ID 49535
	s DrugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	Q:parent="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) 
	s Type=$p(params,"^",1)				//类型
	s DrugId=$p(params,"^",2)
	s Drug=""
	s:DrugId'="" Drug=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),3)
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",length=0,olength=0
	s clomnobj={}
	d clomnobj.%Set("ID","")
	s link=""
	f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+parent,+TempElement,link)) q:link=""  d  
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
	.s rule=GroupNo	
	.s MainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,""))
	.s OperType=$p(^DHCCKBRULEMAINTAIN(MainId),"^",5)
	.Q:OperType=3
	.Q:(Type'="2")&&(OperType'=Type)	
	.s DrugDesc=""								
	.s Temp=""	
	.s id="" f  s id=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,id)) q:id=""  d
	..s tableTitle=$p(^DHCCKBRULEMAINTAIN(id),"^",1)	//标题
	..d clomnobj.%Set(tableTitle,"")	
	..d clomnobj.%Set(tableTitle_"Id","")
	..s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(tableTitle)),5)
	..s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(tableTitle)),2)
	..s:(Code="")&&(LinkId'="") Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	..s isDataSource=##class(web.DHCCKBRuleMaintain).isDataSource(tableTitle)   //是否有数据源或为目录字典
	..s catalogD=$lg($g(^CT.CKB.PDSS.CommonDictionD(tableTitle)),4)
	..s Temp=$lg($g(^CT.CKB.PDSS.CommonDictionD(tableTitle)),5)
    ..s:catalogD=DrugLibaryData tableTitle="catalog"
	..s dataDic=""
	..s dataDic=$p(^DHCCKBRULEMAINTAIN(id),"^",2)		//内容
	..s:((Code="MedDrugNameProp")||(Code="ChineseDrugNameProp")) DrugDesc=dataDic
	..s fieldIdData=dataDic							  //fieldId显示内容的ID
	..d clomnobj.%Set(tableTitle,dataDic)	
	..d clomnobj.%Set(tableTitle_"Id",fieldIdData)
	.Q:(Drug'="")&&(DrugDesc'[Drug)
	.d clomnobj.%Set("ID",GroupNo)
	.d clomnobj.%Set("GroupNo",GroupNo)
	.// start
	.s ShowFlag=$select(OperType=0:"(保存)",OperType=1:"(提交)",OperType=2:"(删除)",1:"")
	.i ShowFlag'="" s ShowFlag="<span style='color:red'>"_ShowFlag_"</span>"
	.d clomnobj.%Set("ShowFlag",ShowFlag)
	.// end qunianpeng 2020-04-30 增加状态标识
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

/// Descript:处理特殊符号问题，规则录入处的符号有：!,>,>=,<,<=,~,!=
/// Creator:sufan
/// CreateDate:2020-05-11
/// w ##class(web.DHCCKBDrugRuleMaintain).DealWithSpecSymbols("!,333g,<=333min>=,333min")
ClassMethod DealWithSpecSymbols(ListData)
{
	n (ListData)
	s ListData=$replace(ListData,"!,","!")
	s ListData=$replace(ListData,">,",">")
	s ListData=$replace(ListData,">=,",">=")
	s ListData=$replace(ListData,"<,","<")
	s ListData=$replace(ListData,"<=,","<=")
	s ListData=$replace(ListData,"~,","~")
	s ListData=$replace(ListData,"!=,","!=")
	Q ListData
}

/// w ##class(web.DHCCKBDrugRuleMaintain).GetConstants(106)
ClassMethod GetConstants(ParentId)
{
	n (ParentId)
	k DataArry
	s id="" 
	for  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,id)) q:(id="")  d
	.s DataArry(id)=id
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(id,.DataArry)
	
	s num=0
	s index="" f  s index=$o(DataArry(index)) q:(index="")  d
	.q:+index=0
	.;Q:##class(web.DHCCKBCommon).IsEnabled(index)=0
	.s num=num+1
    q num
}

ClassMethod QuerySubItm(Parref, DataArry)
{
	n (Parref, DataArry)
	s SubId=""
    for  s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,SubId)) q:(SubId="")  d
    .q:+SubId=0
   	.s DataArry(SubId)=SubId
   	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",SubId))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(SubId,.DataArry)
}

/// Descript:查询药品规则与维护不一致数量
/// Creator:sufan
/// CreateDate:20200522
/// w ##class(web.DHCCKBDrugRuleMaintain).QueryRuleData()
ClassMethod QueryRuleData()
{
	k MainArr															//组号数组，去重
	k RuleArr															//记录维护的规则
	k ^TMP("web.DHCCKBDrugRuleMaintain","QueryRuleData")
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s MainId = "0"
	for  s MainId = $o(^DHCCKBRULEMAINTAIN(MainId))  Q:MainId=""   d
	.s GroupNo = $p(^DHCCKBRULEMAINTAIN(MainId),"^",3)					//组号
	.s Flag = $p(^DHCCKBRULEMAINTAIN(MainId),"^",5)
	.Q:Flag'=1
	.Q:$D(MainArr(GroupNo))
	.s MainArr(GroupNo) = GroupNo
	.s RuleId = $p(^DHCCKBRULEMAINTAIN(MainId),"^",6)						//规则Id
	.s RuleCat = ..getRuelCat(GroupNo)										//目录
	.s Drug = ..getDrug(GroupNo)											//药品
	.Q:RuleCat=""
	.Q:Drug=""
	.s RuleIndex = RuleCat_","_Drug
	.i $d(RuleArr(RuleIndex))  d
	..s $p(RuleArr(RuleIndex),"^",3) = $p(RuleArr(RuleIndex),"^",3)+1
	.e  d
	..s RuleArr(RuleIndex) = RuleCat _"^"_ Drug _ "^"_1
	
	s count = 0
	s RLIndex = ""
	for  s RLIndex = $o(RuleArr(RLIndex)) Q:RLIndex=""  d
	.s Cat = $lg($g(^CT.CKB.PDSS.CommonDictionD($p(RuleArr(RLIndex),"^",1))),3)
	.s RuleDrug = $lg($g(^CT.CKB.PDSS.CommonDictionD($p(RuleArr(RLIndex),"^",2))),3)
	.s Num=$p(RuleArr(RLIndex),"^",3)
	.s DrugNum = ##class(web.DHCCKBDrugRuleMaintain).CountDrugRule($p(RuleArr(RLIndex),"^",2),$p(RuleArr(RLIndex),"^",1))
	.Q:Num=DrugNum
	.s LactNum = DrugNum - Num
	.s count = count+1
	.s ListData = Cat _"^"_ RuleDrug _"^"_ Num _"^"_ DrugNum _"^"_ LactNum
	.s ^TMP("web.DHCCKBDrugRuleMaintain","QueryRuleData",pid,count) = ListData
	q ""
}

/// Descript:取目录
/// Creator:sufan
/// CreateDate:20200522
/// w ##class(web.DHCCKBDrugRuleMaintain).getRuelCat()
ClassMethod getRuelCat(GroupNo)
{
	n (GroupNo)
	s Cat = ""
	s MainId = ""
	for  s MainId = $o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,MainId)) Q:(MainId="")||(Cat'="")  d
	.s AttrId = $p(^DHCCKBRULEMAINTAIN(MainId),"^",1)						//属性
	.s DrugDiction = ##class(web.DHCCKBCommon).GetDrugLibaryData()		//目录字典
	.s ParentId = $lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),4)								//上级
	.Q:ParentId'=DrugDiction
	.s Cat =  AttrId
	Q Cat
}

/// Descript:取药品
/// Creator:sufan
/// CreateDate:20200522
/// w ##class(web.DHCCKBDrugRuleMaintain).getDrug()
ClassMethod getDrug(GroupNo)
{
	n (GroupNo)
	s RruleDrugId = ""
	s MainId = ""
	for  s MainId = $o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,MainId)) Q:(MainId="")||(RruleDrugId'="")  d
	.s AttrId = $p(^DHCCKBRULEMAINTAIN(MainId),"^",1)						//属性
	.s AttrCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),2)								//Code
	.Q:(AttrCode'="MedDrugNameProp")&&(AttrCode'="ChineseDrugNameProp")
	.s Drug = $p(^DHCCKBRULEMAINTAIN(MainId),"^",2)						//属性值
	.Q:Drug=""
	.s Index = AttrId_","_Drug
	.i '$D(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(Drug)))	s ErrDrugArr(Index) = AttrId_","_Drug
	.e  d
	..s DrugId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(Drug),""))
	..s RruleDrugId = DrugId
	Q RruleDrugId
}

/// Descript:取药品目录规则数量
/// Creator:sufan
/// CreateDate:20200522
/// w ##class(web.DHCCKBDrugRuleMaintain).CountDrugRule(160,72)
ClassMethod CountDrugRule(DrugId, CatId)
{
	n (DrugId,CatId)
	s DrugDiction = ##class(web.DHCCKBCommon).GetDrugLibaryData()		//目录字典
	s count=0
	k RuleNumArr
	s RuleDicId = ""
	for  s RuleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",DrugId,RuleDicId)) Q:RuleDicId=""  d
	.s RuleId = $lg($g(^CT.CKB.PDSS.RuleDicD(RuleDicId)),2)
	.s DicCatId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",RuleId,DrugDiction,""))
	.s DrugCat = $lg($g(^CT.CKB.PDSS.RuleDicD(DicCatId)),3)					//目录
	.Q:DrugCat'=CatId
	.s count = count+1
	Q count
}

/// Descript:判断是否是药品目录字典，并返回目录字典id
/// Creator:sufan
/// CreateDate:20200522
/// Input:目录子项
/// w ##class(web.DHCCKBDrugRuleMaintain).GetDrugCatDiction(90395)
ClassMethod GetDrugCatDiction(subCatId)
{
	n (subCatId)
	s ret = 0
	s DrugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()	//数据目录字典
	s parCatId = $lg($g(^CT.CKB.PDSS.CommonDictionD(subCatId)),4)
	Q:parCatId="" ret
	s:DrugLibaryData=parCatId ret=1
	Q:ret'=0 ret
	s ret = ..GetDrugCatDiction(parCatId)
	Q ret
}

/// Descript:更新新增字段
/// Creator:sufan
/// CreateDate:20200522
/// Input:目录子项
/// w ##class(web.DHCCKBDrugRuleMaintain).GetDrugCatDiction(90395)
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("90968")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("90409")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("85466")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("85362")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("81878")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("81877")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("81876")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("81875")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("81874")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("81872")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("81392")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("77900")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("77685")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("77681")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("77680")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("77679")
/// w ##class(web.DHCCKBDrugRuleMaintain).UpdateText("75369")
/// 
ClassMethod UpdateText(parent = "")
{
	
	n (parent)
	s Ret=0
	ts
	s GroupNo="" 
	f  s GroupNo=$o(^DHCCKBRULEMAINTAIN(0,"TempGro",parent,GroupNo),-1)  q:(GroupNo="")||(Ret'=0)  d  //组号
	.s id="" f  s id=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,id)) q:id=""  d
	..s Desc=$p(^DHCCKBRULEMAINTAIN(id),"^",2)			//标题
	..s Text=$$ALPHAUP^SSUTIL4(Desc)
	..&sql(update DHC_CKBRuleMaintain set RM_Text=:Text where RM_RowId=:id)
	..s Ret=SQLCODE
	..q:Ret'="0"
	i Ret'="0" tro
	Q:Ret'="0" Ret
	TC
	q Ret
}

/// Descript:溶媒溶液数据移动
/// Creator:sufan
/// CreateDate:20200610
/// Input:目录子项
/// w ##class(web.DHCCKBDrugRuleMaintain).TransfSolData()
ClassMethod TransfSolData()
{
	s medUsaDosage = ##class(web.DHCCKBCommon).GetDicIdByCode("用法用量")				// 用法用量模板Id
	s chnUsaDosage = ##class(web.DHCCKBCommon).GetDicIdByCode("用法用量（中成药）")		// 中成药用法用量模板Id
	s solTempId = ##class(web.DHCCKBCommon).GetDicIdByCode("溶媒溶液")					// 溶媒溶液模板Id
	s catlog = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")					// 液体配置目录Id
	/*西药名称/液体配置(目录)/溶媒/溶媒体积/溶媒浓度/溶液/溶液体积/溶液浓度*/			// 此处取固定列存储到溶媒模板下
	s medDesc = ##class(web.DHCCKBCommon).GetDicIdByCode("MedDrugNameProp")				// 西药名称属性
	s medSolvent = ##class(web.DHCCKBCommon).GetDicIdByCode("SolventProp")				// 溶媒
	s medSolConc = ##class(web.DHCCKBCommon).GetDicIdByCode("SolventDensity")			// 溶媒浓度
	s medSolVolu = ##class(web.DHCCKBCommon).GetDicIdByCode("Solventvolume")			// 溶媒体积
	s medSolution = ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionProp")			// 溶液
	s medSoluConc = ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionDensity")			// 溶液浓度
	s medSoluVolu = ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionVolume")			// 溶液体积
	s DrugPreMet = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugPreMet")				// 给药途径
	s DiseaseDesc = ##class(web.DHCCKBCommon).GetDicIdByCode("DiseaseDesc")				// 西医疾病名称
	s WarnMessage = ##class(web.DHCCKBCommon).GetDicIdByCode("WarnMessage")				// 提示信息
	s propIdList = medSolvent_","_medSolConc_","_medSolVolu_","_medSolution_","_medSoluConc_","_medSoluVolu
	s listData = "",allListData = "",quitList = ""
	s count = 0
	s groupNo = ""
	for  s groupNo = $o(^DHCCKBRULEMAINTAIN(0,"TempGro",medUsaDosage,groupNo))  Q:groupNo=""  d
	.s drugDesc = ..GetDrugDesc(groupNo,medDesc)				//药品
	.s mindInfo = ..GetDrugDesc(groupNo,WarnMessage)			//提示信息
	.s medDiag = ..GetDrugDesc(groupNo,DiseaseDesc)				//西医疾病
	.s preMet = ..GetDrugDesc(groupNo,DrugPreMet)				//给药途径
	.Q:drugDesc=""
	.s listData = ""_"^"_drugDesc_"^"_medDesc_"^"_solTempId_"^"_0
	.s listData = listData_"$$"_""_"^"_"液体配置"_"^"_catlog_"^"_solTempId_"^"_0
	.i mindInfo'="" s listData = listData_"$$"_""_"^"_mindInfo_"^"_WarnMessage_"^"_solTempId_"^"_0
	.i medDiag'="" s listData = listData_"$$"_""_"^"_medDiag_"^"_DiseaseDesc_"^"_solTempId_"^"_0
	.i preMet'="" s listData = listData_"$$"_""_"^"_preMet_"^"_DrugPreMet_"^"_solTempId_"^"_0
	.s ruleMainId = "",propList = ""
	.for  s ruleMainId = $o(^DHCCKBRULEMAINTAIN(0,"TempGro",medUsaDosage,groupNo,ruleMainId)) Q:ruleMainId=""  d
	..s code = $p(^DHCCKBRULEMAINTAIN(ruleMainId),"^",1)		//属性Id
	..Q:propIdList'[code										//过滤非溶媒溶液列
	..s text = $p(^DHCCKBRULEMAINTAIN(ruleMainId),"^",2)		//取溶媒溶液量
	..Q:text=""
	..i propList = "" s propList = ""_"^"_text _"^"_code_"^"_solTempId_"^"_0
	..e  s propList = propList_"$$"_""_"^"_text _"^"_code_"^"_solTempId_"^"_0
	.i propList = "" s listData=""
	.Q:propList=""
	.s count = count+1
	.Q:count>2
	.s allListData = listData_"$$"_propList
	.s ret=0
	.s ret=##class(web.DHCCKBRuleMaintain).save(allListData)
	.i quitList = "" s quitList = listData_"$$"_propList
	.e  s quitList = quitList_"@@"_listData_"$$"_propList
	Q ret_"&&"_quitList
}

/// Descript:取药品名称
ClassMethod GetDrugDesc(groupNo, medDesc)
{
	n (groupNo,medDesc)
	s ruleMainId = "",drugDesc=""
	for  s ruleMainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",groupNo,ruleMainId)) Q:ruleMainId=""  d
	.s code = $p(^DHCCKBRULEMAINTAIN(ruleMainId),"^",1)
	.Q:code'=medDesc
	.s drugDesc = $p(^DHCCKBRULEMAINTAIN(ruleMainId),"^",2)
	Q drugDesc
}

/// Descript:找用药频率中使用的单位字典
/// Creator:sufan
/// CreateDate:20200618
/// Input:目录Id
/// w ##class(web.DHCCKBDrugRuleMaintain).QueryUnitDic()
ClassMethod QueryUnitDic()
{
	s listData = ""
	k UnitArr
	s unitDataId = ##class(web.DHCCKBCommon).GetUnitData()
	s rightDic = "0"
	for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightExt","InputUom",+rightDic))  Q:rightDic=""  d
	.Q:+rightDic="0"
	.s ruleId = ""
	.for  s ruleId = $o(^CT.CKB.PDSS.RuleDataI("RightExt","InputUom",+rightDic,ruleId))  Q:ruleId=""  d
	..s ruleDataId = ""
	..for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt","InputUom",+rightDic,ruleId,ruleDataId))  Q:ruleDataId=""  d
	...s leftDicId = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	...Q:leftDicId'=45
	...;Q:$d(UnitArr(rightDic))
	...s UnitArr(rightDic) = rightDic
	...s rule = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,105,""))
	...s ruleDicId = ""
	...i rule'="" s ruleDicId = $lg($g(^CT.CKB.PDSS.RuleDicD(rule)),3)
	...s ruleDic = ""
	...i ruleDicId'="" s ruleDic = $lg($g(^CT.CKB.PDSS.CommonDictionD(ruleDicId)),3)
	...s text = $lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	...Q:text="次/日"
	...i listData = "" s listData = "<p>"_text_"%"_ruleId_"%"_ruleDic_"</p>"
	...e  s listData = listData _"<br>"_"<p>"_ text_"%"_ruleId_"%"_ruleDic_"</p>"
	Q listData
}

/// Descript:数据源内容是否多选
/// Creator:sufan
/// CreatDate:2020-07-01
/// Input:
/// Descript:取列的描述
/// w ##class(web.DHCCKBDrugRuleMaintain).GetColFieldTitle(42)
ClassMethod GetColFieldTitle(filed)
{
	n (filed)
	Q:filed="" ""
	s linkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(filed)),5)
	s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(filed)),3)
	i (desc = "")&&(linkId '= "")  s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)
	Q desc
}

}

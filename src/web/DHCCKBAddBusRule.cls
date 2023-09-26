Import sqluser

Class web.DHCCKBAddBusRule Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取医嘱名称列表
/// Creator:		QuNianpeng 
/// CreateDate:		2018-08-16	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).QueryDicList("Drug^Drug_Form^am")
ClassMethod QueryDicList(params As %String = "") As %String
{
	n (params)
	s dicType = $p(params,"^",1)
	s:dicType="" dicType = "Drug"		// 默认查药品
	s queryPointer = $p(params,"^",2)
	s queryPointer = $zcvt(queryPointer,"U")
	s dicName = $p(params,"^",3)
	s dicName = $zcvt(dicName,"U")
    s pid = ##Class(web.DHCAPPExaRepCom).NewPid()	
		
    i (+dicType = 0)&&(dicType '="") d
	.i $d(^DHCCKBCD(0,"Code",$$ALPHAUP^SSUTIL4(dicType))) d
	..s dicType = $o(^DHCCKBCD(0,"Code",$$ALPHAUP^SSUTIL4(dicType),""),-1)
	.e  d 
	..s dicType = ""	
	    
    d ..killTmpGlobal(pid)	
	
	s dlaRowId = "", h = 0
	f  s dlaRowId = $o(^DHCCKBDLA(dlaRowId)) q:dlaRowId=""  d  //查询表DHC_CKBDicLinkAttr
	.q:+dlaRowId=0
	.s dicID = $p(^DHCCKBDLA(dlaRowId),"^",1)	
	.s dicIDDesc = 	$p(^DHCCKBCD(dicID),"^",2)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicIDDesc))
	.q:(dicName'="")&&(dicIDDesc'[dicName)&(pinDicDesc'[dicName)
	.s dicIDType = $p(^DHCCKBCD(dicID),"^",3)
	.q:dicIDType'=dicType
	.s pointerID = $p(^DHCCKBDLA(dlaRowId),"^",2)			// pointer ID
	.s pointerCode = $p(^DHCCKBCD(pointerID),"^",1)			// pointer 代码
	.s pointerDesc = $p(^DHCCKBCD(pointerID),"^",2)			// pointer 描述
	.s pointerTypeID = $p(^DHCCKBCD(pointerID),"^",3)
	.s pointerTypeCode=$p(^DHCCKBCD(pointerTypeID),"^",1)
	.s pointerTypeCode = $zcvt(pointerTypeCode,"U")
	.s pointerTypeDesc = $p(^DHCCKBCD(pointerTypeID),"^",2)
	.//q:(queryPointer'="")&(pointerTypeCode'=queryPointer)
	.q:(queryPointer'="")&(pointerID'=queryPointer)
	.s h=h+1
	.s tempstr=dicID_"^"_dicIDDesc_"^"_pointerID_"^"_pointerDesc
	.s ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryDicList",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符

	
	///转换数据为Json格式
	S listTitle="genRowID^genDesc^formRowID^formDesc"
	
	s count=0
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryDicList",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryDicList",pid,index))
	.s count=count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(listTitle,listData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() 	// 输出json结尾符
	
	d ..killTmpGlobal(pid) 								// k掉临时global
	q ""
}

/// Description:	获取规则列表
/// Creator:		QuNianpeng
/// CreateDate:		2018-01-10
/// Input:			规则表id
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).QueryRuleList("20^45^59^225")
ClassMethod QueryRuleList(params As %String = "") As %String
{
	n (params)	

	s dicID = $p(params,"^",1)
	s pointer = $p(params,"^",2)	
	s range = $p(params,"^",3)	

	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid)		
    
    s h = 0
    s groupNum=""
    f  s groupNum=$o(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum))  q:groupNum=""  d
	.s ruleID=""	
	.f  s ruleID=$o(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum,ruleID))  q:ruleID=""  d
	..//s dicTypeDr=$p($g(^DHCCKBRD),"^",2)
	..//s ruleDicID=$p($g(^DHCCKBRD),"^",3)
	..//s pointerType=$p($g(^DHCCKBRD),"^",4)
	..//s pointer=$p($g(^DHCCKBRD),"^",5)
	..//s linkDicType=$p($g(^DHCCKBRD),"^",7)
	..//s linkDicID=$p($g(^DHCCKBRD),"^",8)
	..//s linkAttrType=$p($g(^DHCCKBRD),"^",9)
	..//s linkAttrID=$p($g(^DHCCKBRD),"^",10)
	..//s sign=$p($g(^DHCCKBRD),"^",11)
	..//s maxValue=$p($g(^DHCCKBRD),"^",12)
	..//s minValue=$p($g(^DHCCKBRD),"^",13)
	..//s unitID=$p($g(^DHCCKBRD),"^",14)
	..//s reation=$p($g(^DHCCKBRD),"^",15)
	..s message = $p($g(^DHCCKBRD(ruleID)),"^",16)
	..//s content=$p($g(^DHCCKBRD),"^",17)
	..//s source=$p($g(^DHCCKBRD),"^",18)
	.
	.s h = h+1
	.s ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleList",pid,h)=groupNum_"^"_message
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) // 输出json结尾符
	q:h=0 "" 
 	b //1
    
    w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) // 输出json前缀串
	
	///转换数据为Json格式
	s h=0
	s ListTitle = "groupNum^message" 
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleList",pid,index))
	.s count=count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() 	// 输出json结尾符
	
	d ..killTmpGlobal(pid) 								// k掉临时global
	q ""
}

/// Description:	查询规则明细
/// Creator:		QuNianpeng
/// CreateDate:		2018-01-10
/// Input:			规则表id
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).QueryRuleItmList("2869^4062^2861^63")
ClassMethod QueryRuleItmList(params As %String = "") As %String
{
	n (params)
	
	s dicID = $p(params,"^",1)
	s pointer = $p(params,"^",2)	
	s range = $p(params,"^",3)	
	s groupNum = $p(params,"^",4)
	
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid)		
    
    s h = 0
    //s groupNum=""
    //f  s groupNum=$o(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum))  q:groupNum=""  d
	s ruleID=""	
	f  s ruleID=$o(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum,ruleID))  q:ruleID=""  d
	.s itmTypeID=$p($g(^DHCCKBRD(ruleID)),"^",7)
	.i itmTypeID'="" s itmTypeDesc=$p($g(^DHCCKBCD(itmTypeID)),"^",2)
	.s itmID=$p($g(^DHCCKBRD(ruleID)),"^",8)
	.i itmID'="" s itmName=$p($g(^DHCCKBCD(itmID)),"^",2)
	.s itmAttrType=$p($g(^DHCCKBRD(ruleID)),"^",9)
	.i itmAttrType'="" s itmAttrTypeDesc=$p($g(^DHCCKBCD(itmAttrType)),"^",2)
	.s itmAttrID=$p($g(^DHCCKBRD(ruleID)),"^",10)
	.i itmAttrID'="" s itmAttrName=$p($g(^DHCCKBCD(itmAttrID)),"^",2)
	.s signID=$p($g(^DHCCKBRD(ruleID)),"^",11)
	.s signDesc=$case(signID,">":"大于","<":"小于","!>":"不大于","!<":"不小于","=":"等于","!=":"不等于","==":"包含","><":"区间",:"")
	.s maxValue=$p($g(^DHCCKBRD(ruleID)),"^",12)
	.s minValue=$p($g(^DHCCKBRD(ruleID)),"^",13)
	.s unitID=$p($g(^DHCCKBRD(ruleID)),"^",14)
	.i unitID'="" s unitDesc=$p($g(^DHCCKBCD(unitID)),"^",2)
	.//s reation=$p($g(^DHCCKBRD),"^",15)
	.//s reationDesc=$case(reation,"fit":"适应","warn":"禁忌")
	.//s message = $p($g(^DHCCKBRD(ruleID)),"^",16)
	.//s content=$p($g(^DHCCKBRD),"^",17)
	.//s source=$p($g(^DHCCKBRD),"^",18)
	.s tmpData=ruleID_"^"_itmTypeID_"^"_$g(itmTypeDesc)_"^"_itmID_"^"_$g(itmName)_"^"_itmAttrType_"^"_$g(itmAttrTypeDesc)_"^"_itmAttrID_"^"_$g(itmAttrName)
	.s tmpData=tmpData_"^"_signID_"^"_$g(signDesc)_"^"_maxValue_"^"_minValue_"^"_unitID_"^"_$g(unitDesc)
	
	.s h = h+1
	.s ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleItmList",pid,h)=tmpData

	//
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) // 输出json结尾符
	q:h=0 "" 
	
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) // 输出json前缀串	
	s h=0
	s ListTitle = "ruleID^itmTypeID^itmTypeDesc^itmID^itmName^itmAttrType^itmAttrTypeDesc^itmAttrID^itmAttrName^signID^signDesc^maxValue^minValue^unit^unitDesc"
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleItmList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleItmList",pid,index))
	.s count=count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() 	// 输出json结尾符
	
	d ..killTmpGlobal(pid) 								// k掉临时global
	q ""
}

/// Description:	获取规则列表
/// Creator:		QuNianpeng
/// CreateDate:		2018-01-10
/// Input:			规则表id
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).JsonRuleMainData("20^45^59^225")
ClassMethod JsonRuleMainData(params As %String) As %String
{
	n (params)
	s ^qnp=params
	i params="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)	
	q:params="" ""
	//var params=dicID +"^"+ pointer +"^"+ range + "^"+ groupNum;
	
	s dicID=$p(params,"^",1)
	s pointer=$p(params,"^",2)
	s range=$p(params,"^",3)
	s groupNum=$p(params,"^",4)
	i groupNum="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	q:groupNum="" ""
	i $d(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum)) s ruleID=$o(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum,""))
	i '$d(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum)) w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	q:'$d(^DHCCKBRD(0,"Group",dicID,pointer,range,groupNum)) ""
	///转换数据为Json格式
	
	s checkWays=$p($g(^DHCCKBRD(ruleID)),"^",15)
	s checkWaysName = $case(checkWays,"fit":"适应","warn":"禁用",:"适应")	
	s message=$p($g(^DHCCKBRD(ruleID)),"^",16)
	s content=$p($g(^DHCCKBRD(ruleID)),"^",17)
	s source=$p($g(^DHCCKBRD(ruleID)),"^",18)
	s levelMan = $p($g(^DHCCKBRD(ruleID)),"^",19)
	s levelManName = $case(levelMan,"C":"管制","W":"警示","C":"提示",:"警示")
	s listTitle = "levelMan^levelManName^checkWays^checkWaysName^message^content^source"
	s listData = levelMan_"^"_levelManName_"^"_checkWays_"^"_checkWaysName_"^"_message_"^"_content_"^"_source
	w ##class(web.DHCAPPJsonCommon).getJsonData(listTitle,listData)

	q ""
}

/// Description:	存储规则
/// Creator:		QuNianpeng
/// CreateDate:		2018-01-10
/// Input:			规则数据
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).SaveRule("1^1^1^1^^C^fit&&描述内容 &&原文说明 &&数据来源&&1^20^^^>^1^11^55@2^21^^^<^2^22^55")
ClassMethod SaveRule(mListData As %String) As %String
{
	 n (mListData)
	
	//s $zt="err"
	//TStart
	//var mListData = ruleListData  +"&&"+ message +"&&"+ context +"&&"+ source +"&&"+ ruleItmListData
	/// 规则数据
	s ruleListData = $p(mListData,"&&",1)	// 主数据 +"&&"+ message +"&&"+ context +"&&"+ source +"^"+ itmListData
	s typeID = $p(ruleListData,"^",1)		// 类型 +"^"+ 实体 +"^"+	剂型 +"^"+ 维度	+"^"+ 组号  +"^"+ 级别  +"^"+ 判定方式 
	s dicID = $p(ruleListData,"^",2)
	s:typeID="" typeID=$p($g(^DHCCKBCD(dicID)),"^",3)
	s pointer = $p(ruleListData,"^",3)
	s pointerDr=$p($g(^DHCCKBCD(pointer)),"^",3)	
	s range = $p(ruleListData,"^",4)
	s groupNum = $p(ruleListData,"^",5)
	s level = $p(ruleListData,"^",6)
	s checkWays = $p(ruleListData,"^",7)

	s message = $p(mListData,"&&",2)
	s context = $p(mListData,"&&",3)
	s source = $p(mListData,"&&",4)
	s itmListData=$p(mListData,"&&",5)		//@ 项目分类 +"^"+项目 +"^"+	相关知识属性代码 +"^"+  相关知识元属性值 +"^"+	比值符号  +"^"+	最小值 +"^"+最大值 +"^"+单位			


	i groupNum = "" d
	.s groupNum = ##Class(web.DHCCKBCommonUtil).NewPid()
	
	s err=0
	TS 
	s len=$l(itmListData,"@")
	f i=1:1:len  q:err'=0  d
	.s tmpData = $p(itmListData,"@",i)
	.s itmLinkDicCode=$p(tmpData,"^",1)
	.s itmLinkDicName=$p(tmpData,"^",2)
	.s itmLinkAttrCode=$p(tmpData,"^",3)
	.s itmLinkAttrName=$p(tmpData,"^",4)
	.s itmSign=$p(tmpData,"^",5)
	.s itmMinValue=$p(tmpData,"^",6)
	.s itmMaxValue=$p(tmpData,"^",7)
	.s itmUnit=$p(tmpData,"^",8)
	.//&sql(insert into DHC_CKBRuleData (RD_Group,RD_DicCode,RD_DicName,RD_AttrCode,RD_AttrName,RD_Relation,RD_LinkDicCode,RD_LinkDicName,RD_LinkAttrCode,RD_LinkAttrName,RD_Sign,RD_MaxValue,RD_MinValue,RD_Unit,RD_LinkRelation,RD_PropInfo,RD_Context,RD_Source,RD_ManLevel) 
	.//values (:groupNum,:typeID,:dicID,:pointerDr,:pointer,:range,:itmLinkDicCode,:itmLinkDicName,:itmLinkAttrCode,:itmLinkAttrName,:itmSign,:itmMaxValue,:itmMinValue,:itmUnit,:checkWays,:message,:context,:source,:level))
	.s err=SQLCODE
	
	i err'=0  tro
	q:err'=0 err
	
	TCommit	
	q err
	
	/*
	.s ruleObj=##class(User.DHCCKBRuleData).%New()
	.s ruleObj.RDGroup=groupNum
	.s ruleObj.RDDicCode=##class(User.DHCCKBCommonDiction).%OpenId(typeID)
	.s ruleObj.RDDicName=##class(User.DHCCKBCommonDiction).%OpenId(dicID)
	.s ruleObj.RDAttrCode=##class(User.DHCCKBCommonDiction).%OpenId(pointerDr)
	.s ruleObj.RDAttrName=##class(User.DHCCKBCommonDiction).%OpenId(pointer)
	.s ruleObj.RDRelation=##class(User.DHCCKBCommonDiction).%OpenId(range)
	.s ruleObj.RDLinkAttrCode=##class(User.DHCCKBCommonDiction).%OpenId(itmLinkDicCode)
	.s ruleObj.RDLinkAttrName=##class(User.DHCCKBCommonDiction).%OpenId(itmLinkDicName)
	.s ruleObj.RDLinkAttrCode=##class(User.DHCCKBCommonDiction).%OpenId(itmLinkAttrCode)
	.s ruleObj.RDLinkAttrName=##class(User.DHCCKBCommonDiction).%OpenId(itmLinkAttrName)
	.s ruleObj.RDSign=itmSign
	.s ruleObj.RDMinValue=itmMinValue
	.s ruleObj.RDMaxValue=itmMaxValue
	.s ruleObj.RDUnit=##class(User.DHCCKBCommonDiction).%OpenId(itmUnit)
	.s ruleObj.RDPropInfo=message
	.s ruleObj.RDContext=context
	.s ruleObj.RDSource=source
	.d ruleObj.%Save()	
	.
	*/
}

/// Description:	修改规则
/// Creator:		QuNianpeng
/// CreateDate:		2018-01-10
/// Input:			规则数据
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).UpDateRule("225","1^20^45^59^225^C^fit&&描述内容11&&原文说明11&&数据来源211&&1^22^^^><^2^22^55@19^34^^^>^1^^")
ClassMethod UpDateRule(groupNum As %String, mListData As %String) As %String
{
	 n (groupNum,mListData)
	b //
	s err=..DeleteRule(groupNum)
	
	q:err'=0 err
	b //1
	
	s err=..SaveRule(mListData)
	
	q err
}

/// Description:	删除规则
/// Creator:		QuNianpeng
/// CreateDate:		2018-01-10
/// Input:			规则数据
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).DeleteRule(10)
ClassMethod DeleteRule(groupNum As %String) As %String
{
	
	n (groupNum)
	
	TS
	//&sql(DELETE FROM DHC_CKBRuleData WHERE RD_Group =:groupNum)

	i SQLCODE'=0 tro
	Q:SQLCODE'=0 SQLCODE
		
	tc
    q SQLCODE
}

/// Description:	获取规则列表
/// Creator:		QuNianpeng
/// CreateDate:		2018-01-10
/// Input:			规则表id
/// return:			
/// other:			w ##class(web.DHCCKBAddBusRule).QueryRuleMainData("^^^")
ClassMethod QueryRuleMainData(params As %String = "") As %String
{
	n (params)	

	s itmID = $p(params,"^",1)
	s pointer = $p(params,"^",2)
	
	q:pointer="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	    
    d ..killTmpGlobal(pid)		// k掉临时global
    
    s h = 0
    s range = ""
    f  s range = $o(^DHCCKBRD(0,"DicRange",itmID,pointer,range))  q:range=""  d    
    .s rangeDesc = $p($g(^DHCCKBCD(range)),"^",2)
    .s h = h+1
    .s:rangeDesc'="" ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleMainData",pid,h)=range_"^"_rangeDesc
	.s tmpRuleID=""	
	.f  s tmpRuleID=$o(^DHCCKBRD(0,"DicRange",itmID,pointer,range,tmpRuleID))  q:tmpRuleID=""  d
	..q:tmpRuleID=""
	..s message = $p(^DHCCKBRD(tmpRuleID),"^",7)
	..s message = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"_message
	..s h = h+1
	..s ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleMainData",pid,h)=tmpRuleID_"^"_message
	
    w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) // 输出json前缀串
	
	///转换数据为Json格式
	s h=0
	s ListTitle = "ruleID^message"
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleMainData",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleMainData",pid,index))
	.s count=count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() 	// 输出json结尾符
	
	d ..killTmpGlobal(pid) 								// k掉临时global
	q ""
}

/// Description:	通过实体id获取对应的pointer
/// Creator:		QuNianpeng 
/// CreateDate:		2018-01-17	
/// Input:			具体实体id
/// return:			pointer Code -实体对应的pointer的分类描述(如阿莫西林->剂型)
/// other:			w ##class(web.DHCCKBAddBusRule).GetPointerByDic("12")
ClassMethod GetPointerByDic(dicID) As %String
{
	n (dicID)
	
	q:dicID="" ""	
		
	s dlaRowId = "",pointerTypeCode=""
	f  s dlaRowId = $o(^DHCCKBDLA(0,"LinkDic",dicID,dlaRowId)) q:(dlaRowId="")||(pointerTypeCode'="")  d  //查询表DHC_CKBDicLinkAttr
	.q:+dlaRowId=0
	.s pointerID = $p(^DHCCKBDLA(dlaRowId),"^",2)			// pointer ID
	.s pointerDesc = $p(^DHCCKBCD(pointerID),"^",2)			// pointer 描述
	.s pointerTypeID = $p(^DHCCKBCD(pointerID),"^",3)
	.s pointerTypeCode=$p(^DHCCKBCD(pointerTypeID),"^",1)
	
	q pointerTypeCode
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	
	
	k ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryGenDetList",pid)
	k ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleList",pid)
	k ^TMP("DHCCKB","web.DHCCKBAddBusRule","QueryRuleItmList",pid)
}

}

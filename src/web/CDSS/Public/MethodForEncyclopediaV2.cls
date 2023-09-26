Class web.CDSS.Public.MethodForEncyclopediaV2 Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：阚延新
/// CreatDate: 2020-11-12
/// Description：查询诊断属性父表内容
/// Table：CT.WDT.CDSS.TermProperty
/// Input：termdr
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetList("1700873")
ClassMethod GetList(termdr As %String) As %String
{
	if (termdr=""){
		q "{""rows"":[], ""total"":0}"
	}
	
				
	// 公有按照 知识库注册的顺序取，私有属性按照现有的顺序
	k myArray
	s MKBTPRowId=0
	for 
	{
		s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
		s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)
		s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
		s MKBTBaseDR=$LISTGET($G(^CT.WDT.CDSS.TermD(termdr)),4)
		s MKBTPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),11)
		if ($d(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR)))&($d(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR," "_MKBTPDescU)))
		{
			s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR," "_MKBTPDescU,""))
			s MKBTBPSequence=0
			s:MKBTBPRowId'="" MKBTBPSequence=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),9)
			s myArray(MKBTBPSequence,MKBTPRowId)=""
		}
		else
		{
			s myArray(MKBTPSequence,MKBTPRowId)=""	
			
		}		
	}
	
	s result="{""rows"":["
    s count=0
	s MKBTPSequence=0
	for  
	{	
		s MKBTPSequence=$o(myArray(MKBTPSequence)) q:MKBTPSequence=""
		
		s MKBTPRowId=0
		for 
		{
			s MKBTPRowId=$o(myArray(MKBTPSequence,MKBTPRowId)) q:MKBTPRowId=""
			s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)
			s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
			s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
			s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetDetail(MKBTPType,MKBTPRowId)  //缩略名
			continue:MKBTPDDesc=""
			s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),6)
			s MKBTPFlag=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),8)
			if (MKBTPTermDr'="")
			{
				 s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),3)  //诊断描述
				 //新型冠状病毒肺炎的诊断展示名,常用名/别名列表,知识应用模板,其他描述不显示
				 continue:(MKBTDesc="新型冠状病毒肺炎")&((MKBTPFlag="S")||(MKBTPFlag="AL")||(MKBTPFlag="DT")||(MKBTPFlag="OD"))
			}
			s Config=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
			if (MKBTPType="S")||(MKBTPType="SD")||(MKBTPType="T")
			{
				 s:Config'="" MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(Config)),3)
				 s:Config="" MKBTPConfig=""
			}
			else
			{
				s MKBTPConfig=Config
			}
			s MKBTPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),7)
			s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),9)
			s DefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),10)
			s:DefinedNode'="" MKBTPDefinedNode=$listget($g(^CT.WDT.CDSS.TermD(DefinedNode)),3) 
			s:DefinedNode="" MKBTPDefinedNode="" 
			if (MKBTPPublic="Y")&(termdr'="")&(MKBTPDesc'="")  //如果是公有属性
			{
				s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(termdr)),4) //知识库注册id
				continue:MKBTBaseDR=""
				s BaseProId=$o(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR," "_$ZCONVERT(MKBTPDesc,"U"),0))  //知识库注册属性id
				continue:BaseProId=""
				s MKBTBPWikiShow=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(BaseProId)),13) //医为百科展示位置20200621
				continue:(MKBTBPWikiShow="hide")||(MKBTBPWikiShow="top")
			}
			s count=count+1
			if count>1 s result=result_","
			s result=result_"{""MKBTPRowId"":"""_MKBTPRowId_""",""MKBTPDesc"":"""_MKBTPDesc_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPType"":"""_MKBTPType_""",""MKBTPTermDr"":"""_MKBTPTermDr_""",""MKBTPConfig"":"""_MKBTPConfig_""",""MKBTPName"":"""_MKBTPName_""",""MKBTPFlag"":"""_MKBTPFlag_""",""MKBTPPublic"":"""_MKBTPPublic_""",""MKBTPDefinedNode"":"""_MKBTPDefinedNode_""",""MKBTPSequence"":"""_MKBTPSequence_"""}"          
		}
	}   
	s result=result_"], ""total"":"_count_"}"    	
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-11-12
/// Description：获取诊断常用名
/// Input: property-属性id
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetSelPropertyList("6")
ClassMethod GetSelPropertyList(property As %String) As %String
{
	
	if (property=""){
		q "{""rows"":[], ""total"":0}"
	}
	s result="{""rows"":["
	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",property,0))
	s MKBTPDDesc=""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
	if (MKBTPDDesc'="")
	{
		s argsLen=$Length(MKBTPDDesc,",")
	    s count=0
	    for i=1:1:argsLen  
	    {
	        s argstr=$p(MKBTPDDesc,",",i)
	        s MKBTPRowId=$p(argstr,"&",1)
	        s MKBTPShowType=$p(argstr,"&",2)  //展示格式
	        s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
	        s MKBTPChoice=$p(argstr,"&",4)  //单选多选 (S/D)
	        s:MKBTPChoice="" MKBTPChoice="S"   //默认是单选
	        s MKBTPRequired=$p(argstr,"&",5)  //是否必填（Y/N）
	        s:MKBTPRequired="" MKBTPRequired="N"  //默认不必填
	        s MKBTPTOrP=$p(argstr,"&",6)  //术语T或属性P
	        s:MKBTPTOrP="" MKBTPTOrP="P"  //默认属性P
	        s MKBTPOrder=i
	        s MKBTPDesc="",MKBTPType=""
	        if (MKBTPTOrP="T")   //术语
	        {
		        s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTPRowId)),3) //术语库描述 
		        s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTPRowId)),4)  //术语库格式
	        }
	        else   //属性
	        {
	          	s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3) //属性描述 
	          	s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)  //属性格式
	        }
            s count=count+1
	        if count>1 s result=result_","
	        s result=result_"{""MKBTPRowId"":"""_MKBTPRowId_""",""MKBTPDesc"":"""_MKBTPDesc_""",""MKBTPShowType"":"""_MKBTPShowType_""",""MKBTPType"":"""_MKBTPType_""",""MKBTPOrder"":"""_MKBTPOrder_""",""MKBTPTreeNode"":"""_MKBTPTreeNode_""",""MKBTPChoice"":"""_MKBTPChoice_""",""MKBTPRequired"":"""_MKBTPRequired_""",""MKBTPTOrP"":"""_MKBTPTOrP_"""}"  
	     }
	     s result=result_"], ""total"":"_count_"}" 	    
	}    
    q result
}

/// Creator：阚延新
/// CreatDate: 2020-11-12
/// Description：引用术语类型-引用列表型术语内容维护模块-获取已选术语列表（新-多选术语存成多个属性内容）
/// Table：CT.WDT.CDSS.Term
/// Input：property-属性id
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetSellistTermList("2")
ClassMethod GetSellistTermList(property As %String) As %String
{
	
	if (property=""){
		q "{""rows"":[], ""total"":0}"
	}
	s result="{""rows"":["
	s MKBTPDRowId=0
	s count=0
	for  
	{	
		s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId=""   //遍历该属性下的内容
		s MKBTPDSequence=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),9)  //顺序
		s MKBTRowId=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //属性内容表描述字段MKBTPDDesc存的值——术语id
		continue:MKBTRowId=""
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
		continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
	    s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
	    s count=count+1
	    if count>1 s result=result_","
        s result=result_"{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDSequence"":"""_MKBTPDSequence_"""}"  
	}
	s result=result_"], ""total"":"_count_"}" 	  
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-11-12
/// Description：获取属性内容列表的数据
/// Input：property-属性id
/// Return:Json格式的字符串
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetMyList("2")
ClassMethod GetMyList(property As %String) As %String
{
	
	if (property="")
	{
		q "{""rows"":[], ""total"":0}"
	}
	s MKBTPDSequence=""
	s result="{""rows"":["
	s count=0
	for  
	{	
		s MKBTPDSequence=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",property,MKBTPDSequence)) q:MKBTPDSequence=""
        s MKBTPDRowId=0
	    for 
	    {   
	        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",property,MKBTPDSequence,MKBTPDRowId)) q:MKBTPDRowId="" 
		    s MKBTPDCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),2)
			s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
			s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
			s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
			s MKBTPDRemark=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),7)
		    s MKBTPDRemark= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
			s MKBTPDSequence=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),9) 
			s MKBTPDPYCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),10)
			s MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
			s ExtendStr=""   //知识点扩展属性子表的字段
			s subId=0  //循环扩展属性子表CT.WDT.CDSS.TermProperty
			for 
			{
			    S subId=$o(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)) q:subId=""
				s MKBTEPVValueStr=##class(web.CDSS.CMKB.TermProDetail).GetExtendProValValue(property,subId,MKBTPDRowId)
				s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
				s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)
				s thisStr="""Extend"_subId_""":"""_MKBTEPVValue_""""
				if (MKBTEPVValueF'="")  //知识点1编辑列的id或者表达式id串
				{
					s thisStr=thisStr_",""Extend"_subId_"F"":"""_MKBTEPVValueF_""""
				}			 		
				s:ExtendStr'="" ExtendStr=ExtendStr_","
				s ExtendStr=ExtendStr_thisStr
			}
		}					
		s count=count+1
	    if count>1 s result=result_","
        s:ExtendStr'="" result=result_"{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""","_ExtendStr_"}"
		s:ExtendStr="" result=result_"{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_"""}" 	
	}
	s result=result_"], ""total"":"_count_"}" 	  
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-11-13
/// Description：获取树形属性内容数据
/// Table：CT.WDT.CDSS.TermProDetail
/// Input：id-父节点,property-属性id
/// Return：treegrid格式数据串
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetJsonList("","9365287")
ClassMethod GetJsonList(id As %String, property As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	s childStr=""
	s count=0
	s result="["
	s mySeq=""
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			//continue:$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),6)'="Y"
			s count=count+1
			s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),3)
			s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
			if count>1 s result=result_","
			s MKBTPDCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),2)
			s MKBTPDRemark=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),7)
			s MKBTPDRemark=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
			s MKBTPDSequence=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),9)
			s MKBTPDPYCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),10)
			s MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
			s MKBTPDLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),4)
			s MKBTPDLastLevel=""
			if MKBTPDLastLevelF'="" 
			{
				s MKBTPDLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDLastLevelF)),3)
				s MKBTPDLastLevel=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDLastLevel)
			}
			s MKBTPDLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),5)
			
			s result=result_"{""id"":"""_myRowID_""""
			s result=result_",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""",""MKBTPDLastLevelF"":"""_MKBTPDLastLevelF_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""""
			s ExtendStr=""   //知识点扩展属性子表的字段
			s subId=0  //循环扩展属性子表CT.WDT.CDSS.TermProperty
			for 
			{
				S subId=$o(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)) q:subId=""
				s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
				s MKBTEPVValueStr=##class(web.CDSS.CMKB.TermProDetail).GetExtendProValValue(property,subId,myRowID)
				s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
				s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)
				s thisStr="""Extend"_subId_""":"""_MKBTEPVValue_""""
				if (MKBTEPVValueF'="")  //知识点1编辑列的id或者表达式id串
				{
					s thisStr=thisStr_",""Extend"_subId_"F"":"""_MKBTEPVValueF_""""
				}			 		
				s:ExtendStr'="" ExtendStr=ExtendStr_","
				s ExtendStr=ExtendStr_thisStr	
				
				//s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_subId_""":"""_MKBTEPVValue_""""
			    //s:ExtendStr="" ExtendStr="""Extend"_subId_""":"""_MKBTEPVValue_""""
			    
			}
			if ExtendStr'=""
			{
				s result=result_","_ExtendStr
			}
			//s childStr=..GetChildOrderedIDStr(myRowID,property)
			//if childStr'=""
			if $d(^CT.WDT.CDSS.TermProDetailI("ProParIndex",property,myRowID))
			{
				//一次性加载   
				s result=result_",""state"":""open"""   //closed节点不展开,open节点展开
				s result=result_",""children"":"
				s result=result_..GetJsonList(myRowID,property)
			}
			else
			{
				s result=result_",""state"":""open"""
			}
			s result=result_"}"
			
		}
	}
	s result=result_"]"
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-11-13
/// Description：给医生站提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input: property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetDocSourseTreeJson("9365276")
ClassMethod GetDocSourseTreeJson(property As %String) As %String
{
	
	q:(property="") "[]"
	s DATSOU=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"
	s selItemIds=##class(web.CDSS.CMKB.TermProDetail).GetSelTermIdsStr(property)
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),10)  //起始节点
	s result=""
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		s result="["
		s result=result_($replace(##class(web.CDSS.CMKB.TermProDetail).NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds),"}{","},{"))_"]"
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
			//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]" //判断是否显示封闭数据	
			
		s strId=","_definedNode_","
		if (selItemIds[strId){
				
			s definedNodeDesc=$listGet($g(^CT.WDT.CDSS.TermD(definedNode)),3)  //已选术语描述
			s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
			s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(definedNode)),7)  //备注
			s comDesc=##class(web.CDSS.CMKB.TermProDetail).GetTermComByTermId(definedNode)
			s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(definedNode)),6)   //检索码

			s spanDesc=comDesc_"^"_MKBTPYCode_"^"_definedNodeDesc_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
		
			s result=result_"["
			s result=result_"{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_spanDesc_"</span>"""
			s result=result_",""state"":""open"""

			if $d(^CT.WDT.CDSS.TermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
			{
				s result=result_",""children"":["
				s result=result_($replace(##class(web.CDSS.CMKB.TermProDetail).NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds),"}{","},{"))_"]"
			}
			s result=result_"}]"
		}
		else{
			s result=result_"["
			s result=result_($replace(##class(web.CDSS.CMKB.TermProDetail).NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds),"}{","},{"))_"]"
		}	
	}	
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-11-13
/// Description：引用起始节点格式的属性内容展示区数据显示，如果有属性内容，则内容区域显示该节点及以下的节点
/// Input: property:属性id
/// return:引用术语的- 起始节点父节点及其所有子节点 Json格式
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetSourseSingleTermJson(9365276)
ClassMethod GetSourseSingleTermJson(property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),5)  //配置项

	q:(DATSOU="") "[]"
    s result=""
	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",property,0))  //属性内容id
	s definedNode=""
	s:MKBTPDRowId'="" definedNode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //属性内容中心词
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		s result=..GetSourseJsonDataForCmb(DATSOU,definedNode,"")
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]"  //判断是否显示封闭数据
		s definedNodeDesc=$listGet($g(^CT.WDT.CDSS.TermD(definedNode)),3)  //已选术语描述
		s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
		s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(definedNode)),6)   //检索码
		if (MKBTPYCode'="")
		{
			s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
			s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
		}
		
		s result=result_"["
		s result=result_"{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_MKBTPYCode_"</span>"""
		s result=result_",""state"":""open"""
		
		if $d(^CT.WDT.CDSS.TermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
		{
			
			s result=result_",""children"":"
			s result=result_..GetSourseJsonDataForCmb(DATSOU,definedNode,"")
		}
		else
		{
			s result=result_",""checked"":false"		
		}
		s result=result_"}"
		s result=result_"]"
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-11-13
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.BDPItemCategory
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.TermProDetail).GetSourseJsonDataForCmb("31","")
ClassMethod GetSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	s result="["
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(myRowID)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
			s Caption=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),6)   //检索码
			if (MKBTPYCode'="")
			{
				s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
			}
			if count>1 s result=result_","
			s result=result_"{""id"":"""_myRowID_""",""text"":"""_Caption_"<span class='hidecls'>"_MKBTPYCode_"</span>"""
			s result=result_",""state"":""open"""
			
			s strId=","_myRowID_","
			
			//s childStr=##class(web.CDSS.CMKB.Term).GetChildOrderedIDStr(base,myRowID)
			//if childStr'=""
			if $d(^CT.WDT.CDSS.TermI("ParentIndex",base,myRowID))
			{
				s result=result_",""children"":"
				s result=result_..GetSourseJsonDataForCmb(base,myRowID,selItemIds)	
			}
			else
			{
				if (selItemIds[strId){
					s result=result_",""checked"":true"
				}
				else{
					s result=result_",""checked"":false"
				}
			
			}
			s result=result_"}"
			
		}
	}
	s result=result_"]"
	q result
}

/// Creator:石萧伟
/// CreatDate:2021-11-15
/// Description:获得文献管理表内容
/// Table: User.DHCDSSDocuManage
/// Input: Desc名称, EngDesc英文名称, Disease诊断, Dept科室, StartDate开始日期, EndDate截止日期, KeyWords关键词, Institution机构, Month年月, Source出处, User操作人, Reviewer审核人, State状态
/// Return:返回所有文献管理表内容
/// Other:w ##class(web.CDSS.Public.MethodForEncyclopediaV2).GetDocList("1700802")
ClassMethod GetDocList(Disease As %String) As %String
{
	if ((Disease="")){
		q "{""rows"":[], ""total"":0}"
	}
	s DiseaseDesc = $listGet($g(^CT.WDT.CDSS.TermD(Disease)),3)
	s Disease = $o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseDesc,"U"),0))
	s result="{""rows"":["
	s count=0
	s date = ""
	for{
		s date=$o(^CT.WDT.CDSS.DocuManageI("DateIndex",date),-1) q:date=""
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuManageI("DateIndex",date,RowId),-1)
			q:RowId=""
			s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2) //文献代码
			s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
			s PINYINDesc=""
			s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4) //英文文献名称
			s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5) //文献路径
			s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
			s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7) //类型
			s DocuInstitution = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构
			s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9) //指南出处
			s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10) //发布年月
			s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
			s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12) //状态
			s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),13) //修改时间
			s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),14) //修改人
			s DocuReviewer = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),15) //审核人
			//关联诊断
			s JoinDisease="",DiseaseStr=""
			s DiseaseDR=""
			for {
				s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",RowId,DiseaseDR)) q:DiseaseDR=""
				s DiseaseStr=DiseaseStr_"<"_DiseaseDR_">"
				
				s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
				if (JoinDisease=""){
					s JoinDisease=DiseaseDesc
				}else{
					s JoinDisease=JoinDisease_"，</br>"_DiseaseDesc
				}
			}
			//关联科室
			s JoinDept="",DeptStr=""
			s DeptDR=""
			for{
				s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
				s DeptStr=DeptStr_"<"_DeptDR_">"	
				
				s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				if (JoinDept=""){
					s JoinDept=DeptName
				}else{
					s JoinDept=JoinDept_"，</br>"_DeptName
				}	
			}
			s DiseaseD="<"_Disease_">"
			if ((DiseaseStr[DiseaseD)&(DocuPath'="")){
				s IsExistsFile=##class("web.CDSS.CMKB.UploadFile").IsExistsFile("scripts/bdp/CDSS/Doc/"_DocuPath)
				if (IsExistsFile=1){
				s count=count+1
			    if count>1 s result=result_","
		        s result=result_"{""RowId"":"""_RowId_""",""DocuDesc"":"""_DocuDesc_""",""DocuPath"":"""_DocuPath_"""}"

				}
		  	}
		}
	}
	s result=result_"], ""total"":"_count_"}" 	  
	q result
}

}

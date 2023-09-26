/// Creator:基础数据平台组-谷雪萍
/// CreatDate:2021-09-08
/// Description：CDSS 医用知识库知识属性明细表 增、删、改、查方法类
/// Table：CT.WDT.CDSS.TermProDetail
Class web.CDSS.CMKB.TermProDetail Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2021-09-08
/// Description：获取属性内容列表的数据
/// Input：rowid-属性内容id，desc-检索内容, property-属性id, rows-每页显示几行, page-第几页
/// Return:Json格式的字符串
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetMyList("","","26316",5,1)
ClassMethod GetMyList(rowid, desc, property, rows, page) As %String
{
	s result="",total=0,jsonstr=""

	if (property=""){
		q "{""rows"":[], ""total"":0}"
	}
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	if (desc'="")
	{
		s desc=$ZCONVERT(desc,"U")
		//s desc=$tr(desc," ","")
	}
	
	w "{""rows"":["
	
	if (rowid'="") //根据rowid返回该条记录
	{
		
		s total=total+1
		s MKBTPDRowId=rowid
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
			s MKBTEPVValueStr=..GetExtendProValValue(property,subId,MKBTPDRowId)
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

		s mainstr=""
		s:ExtendStr'="" mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""","_ExtendStr_"}"
		s:ExtendStr="" mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_"""}"

		//s jsonstr=mainstr
		w mainstr

	}
	else
	{
		s MKBTPDSequence=""
		for  
		{	
			s MKBTPDSequence=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",property,MKBTPDSequence)) q:MKBTPDSequence=""
			s MKBTPDRowId=0
			for 
			{
				s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",property,MKBTPDSequence,MKBTPDRowId)) q:MKBTPDRowId="" 
						
			/*s MKBTPDRowId=0
			for  
			{	
				s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" */
				s MKBTPDDescU=""
				if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
				{
					
				}
				else
				{
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
						s MKBTEPVValueStr=..GetExtendProValValue(property,subId,MKBTPDRowId)
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
				}

				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDescU)
				i ((MKBTPDDescU[desc)||(PINYIN[desc))   //条件
				{
					s total=total+1
				    if (total<stpage) continue
				    if (total<=endpage)
				    {
						s mainstr=""
						s:ExtendStr'="" mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""","_ExtendStr_"}"
						s:ExtendStr="" mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_"""}"
						if (jsonstr'="")
						{ 
							w ","
							s jsonstr=jsonstr_","_mainstr
						}
						else
						{
							s jsonstr=mainstr
						}
						w mainstr
					 }
				}
				
			}
		}
	}
	w "], ""total"":"_total_"}"
	//s result="{""rows"":["_jsonstr_"], ""total"":"_total_"}"
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-06-06
/// Description：获取扩展属性明细表的值
/// Input：property-属性id，subId-扩展属性child，MKBTPDRowId-属性明细表id
/// Return:扩展属性明细表的值（MKBTEPVValue）
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetExtendProValValue(property,subId,MKBTPDRowId)
ClassMethod GetExtendProValValue(property As %String, subId As %String, MKBTPDRowId As %String) As %String
{
	q:((property="")||(subId="")||(MKBTPDRowId="")) ""
	
	s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
	s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
	s MKBTEPVRowId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
	q:MKBTEPVRowId="" ""
    s MKBTEPVValue=$LISTGET($G(^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
    s MKBTEPVValueF=MKBTEPVValue
    if (MKBTEPVValue'="")
    {	
		if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
		{	
			s MKBTEPVValue=##class(web.CDSS.CMKB.Term).GetTreeComboDesc(MKBTEPVValue)  //获取描述，树形的所有上级节点也要显示	

		}
		if (MKBTEPType="CB")   //多选框
		{	
			s MKBTEPVValue=##class(web.BDP.util.String).Replace(MKBTEPVValue,"&%",",")	
		}
		if (MKBTEPType="D")   //日期
		{	
			//s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MKBTEPVValue)
		}
		
    }
	s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTEPVValue)	
	if (MKBTEPType="S")||(MKBTEPType="SD") 
	{
		s MKBTEPVValue=MKBTEPVValue_"[A]"_MKBTEPVValueF   //引用类型的后面拼上它的id
	}
	q MKBTEPVValue
}

/// Creator:谷雪萍
/// CreatDate:2018-08-21
/// Description：处理扩展属性值表的值（引用、多选框、知识表达式的值要进行处理）用于保存、删除时的日志
/// Input：MKBTEPVValue-扩展属性值表的值，subId-扩展属性child，MKBTPDRowId-属性明细表id
/// Return:扩展属性明细表的值（MKBTEPVValue）
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetExtendProValForLog(MKBTEPVValue,MKBTEPType)
ClassMethod GetExtendProValForLog(MKBTEPVValue As %String, MKBTEPType As %String) As %String
{
	q:MKBTEPVValue="" ""
		
	if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
	{	
		s MKBTEPVValue=##class(web.CDSS.CMKB.Term).GetTreeComboDesc(MKBTEPVValue)  //获取描述，树形的所有上级节点也要显示	

	}
	if (MKBTEPType="CB")   //多选框
	{	
		s MKBTEPVValue=##class(web.BDP.util.String).Replace(MKBTEPVValue,"&%",",")	
	}
  
	if (MKBTEPType="D")
	{
		//s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MKBTEPVValue)
	}
	s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTEPVValue)
	s MKBTEPVValue=$tr(MKBTEPVValue,",","，")	
	q MKBTEPVValue
}

/// Creator:谷雪萍
/// CreatDate:2018-08-21
/// Description：处理属性内容（引用、知识应用模板、知识表达式、多选框格式的值要进行处理）用于保存、删除时的日志
/// Input：logDesc-处理之前的属性内容，propertyType-属性类别
/// Return:属性内容描述
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetProDetailDescForLog(logDesc,propertyType)
ClassMethod GetProDetailDescForLog(logDesc As %String, propertyType As %String) As %String
{
	q:logDesc="" ""   //日志描述
	
	if (propertyType="S")||(propertyType="SS")	
	{
		s logDesc=$listGet($g(^CT.WDT.CDSS.TermD(logDesc)),3)
	}	

	if (propertyType="CB")
	{
		s logDesc=##class(web.BDP.util.String).Replace(logDesc,"&%",",")	
	}

	s logDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(logDesc)
	s logDesc=$tr(logDesc,",","，")
	q logDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-03-30
/// Description：获取属性名称，及扩展属性的信息，用来加载组件和生成列
/// Input：property-属性ID
/// Return:属性描述[A]属性扩展表的child串[A]属性扩展表的描述串[A]属性扩展表的类型串[A]配置项串
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).getExtendInfo(29036)
ClassMethod getExtendInfo(property As %String) As %String
{
	q:property="" ""
	s dataIndex=""  //组件dataIndex
	s header=""  //组件标题、列表表头
	s type=""  //组件类型
	s config="" //配置项
	s baseid="" //术语所属术语库id
	s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),6)  //术语id
	s:MKBTPTermDr'="" baseid=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语所属术语库id
	s TermCom=..GetTermCom(property)  //术语常用名
	
	s desc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),7)  //主列名
	s:desc="" desc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),3)
	s count=0  //计数变量，只有一个扩展属性时不带连接符
	/*s subId=0  //循环扩展属性子表CT.WDT.CDSS.TermProperty
	for 
	{
		S subId=$o(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)) q:subId=""
		s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID*/
	s Sequence=""  //按照扩展属性的顺序生成列或者控件
	for {
		s Sequence=$o(^CT.WDT.CDSS.TermExtendProI("SeqIndex",property,Sequence)) q:Sequence=""
		s subId=0
		for 
		{
			S subId=$o(^CT.WDT.CDSS.TermExtendProI("SeqIndex",property,Sequence,subId)) q:subId=""
			s MKBTEPRowId=property_"||"_subId
	
			s MKBTEPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)),2)   //扩展属性名称
			continue:MKBTEPName=""
			s count=count+1
			s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
			s MKBTEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)),4)   //扩展属性配置项
			s:MKBTEPType="" MKBTEPType="TX"
			if (MKBTEPType="S")&(MKBTEPConfig'="")  //如果是引用类型的，且配置项不为空
			{
				s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTEPConfig)),4)  //术语库类型 L/T
				s MKBTEPConfig=MKBTEPConfig_"&%"_MKBTBType   //配置项&%类型
			}

			if (count=1)
			{
				s dataIndex=subId  //child
				s header=MKBTEPName  //标题
				s type=MKBTEPType   //类型
				s config=MKBTEPConfig  //配置项
				
			}
			else
			{
				s dataIndex=dataIndex_"[N]"_subId	  //child串			
				s header=header_"[N]"_MKBTEPName  //标题串
				s type=type_"[N]"_MKBTEPType    //类型串
				s config=config_"[N]"_MKBTEPConfig    //配置项串
			}
			
			
		}
	}
	q desc_"[A]"_dataIndex_"[A]"_header_"[A]"_type_"[A]"_config_"[A]"_baseid_"[A]"_MKBTPTermDr_"[A]"_TermCom
}

/// Creator:谷雪萍
/// CreatDate:2018-12-05
/// Description：根据属性id获取属性名和诊断名
/// Input：id-属性表的ID
/// Return:属性名-诊断名
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetProAndTermDesc(1)
ClassMethod GetProAndTermDesc(id As %String) As %String
{
	q:(id="") ""
	s proDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(id)),3)
	s termDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(id)),6)
	s termdesc=""
	s:termDr'="" termdesc=$LISTGET($G(^CT.WDT.CDSS.TermD(termDr)),3)
	q termdesc_"-"_proDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-03-30
/// Description：用于实现数据校验功能的方法
/// Input：id-属性值表CT.WDT.CDSS.TermProDetail的ID，code-内容code，catdr-属性id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, catdr As %String, rowidflag As %String = "") As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TermProDetailI("CodeIndex",catdr,code))
	if (id="") //如果为空，增加时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TermProDetailI("CodeIndex",catdr,code,0))
		if (idc'="")
		{
			if (rowidflag'="")	//返回重复的id
			{
				s flag=1_"^"_idc
			}
			else
			{
				s flag=1
			}
		}
		else
		{
			s flag=0
		}
		/*
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
		*/
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TermProDetailI("CodeIndex",catdr,code,0))
		if ((idc'="")&(idc'=id)&(flagc>0)) 
		{
			if (rowidflag'="")	//返回重复的id
			{
				s flag=1_"^"_idc
			}
			else
			{
				s flag=1  //返回重复标志
			}
		}
		else  
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:谷雪萍
/// CreatDate:2018-12-12
/// Description：用于实现校验中心词
/// Input：id-属性值表CT.WDT.CDSS.TermProDetail的ID，desc-中心词，catdr-属性id,parentDr-父节点id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).FormValidate("","","")
ClassMethod FormValidateDesc(id As %String, desc As %String, catdr As %String, parentDr As %String, rowidflag As %String = "") As %String
{
	//鉴别诊断去掉重复校验
	s proDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(catdr)),3)
	q:proDesc="鉴别诊断" 0
	s:parentDr="" parentDr=-100000000000000
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag=0
	s MKBTPDRowId=0
	for
	{
		s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProParIndex",catdr,parentDr,MKBTPDRowId)) 
		q:(MKBTPDRowId="")
		s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
		s MKBTPDDesc=$ZCONVERT(MKBTPDDesc,"U") //转换成大写
		if (MKBTPDDesc=desc)&&(MKBTPDRowId'=id)
		{
			if (rowidflag'="")
			{
				s flag=1_"^"_MKBTPDRowId
			}
			else
			{
				s flag=1
			}
			q
		}
	}
	
	q flag
}

/// Creator:丁亚男
/// CreatDate:2018-04-17
/// Description：用于实现数据校验功能的方法 主要校验该属性下是否有属性内容
/// Input：prodr-属性id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).FormValidatePro("97")
ClassMethod FormValidatePro(prodr As %String) As %String
{
	s flag=0
	
	if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",prodr))) //属性下是否有属性内容
	{
		s flag=1
	}
	q flag
}

/// Creator:谷雪萍
/// CreatDate:2018-03-19
/// Description：数据保存测试方法
/// Table：CT.WDT.CDSS.KLMappingDetail
/// Input：str-MKBTPDRowId&%MKBTPDProDR&%MKBTPDDesc&%MKBTPDExtend
/// Return:成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.CDSS.CMKB.TermProDetail).SaveTest()
ClassMethod SaveTest(str)
{
	//s ^TMPGXP=str
	if (str="3@%CSP.CharacterStream")
	{
		q "{success:'false',errorinfo:'录入字符（包含标点）太多,已经达到上限，没法保存，请调整文字！'}"
	}
	s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
	s eobj.MKBTPDRowId=$p(str,"&%",1)
	s eobj.MKBTPDDesc=$p(str,"&%",3)
	s eobj.MKBTPDProDR=$p(str,"&%",2)
	s eobj.MKBTPDExtend=$p(str,"&%",4)
	s result=..SaveData(eobj)
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：保存修改内容
/// Table：CT.WDT.CDSS.TermProDetail
/// Input：web.CDSSEntity.CMKB.TermProDetail 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TermProDetail) As %String
{
	s result = ""
	s newJsonStr = ""  //日志JSON串	
	s oldJsonStr = ""  //原日志JSON串，用于修改
	s newExtendStr=""  //扩展属性明细JSON串
	s oldExtendStr=""  //原扩展属性明细JSON串，用于修改
	if $IsObject(eobj)
	{
		if (eobj.MKBTPDProDR="")
		{
			q "{success:'false',errorinfo:'没有选中属性！'}"

		}		
		if (eobj.MKBTPDCode="")
		{
			//如果代码为空，则自动生成T开头的9位的代码
			s:eobj.MKBTPDRowId'="" eobj.MKBTPDCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(eobj.MKBTPDRowId)),2)
			s:eobj.MKBTPDCode="" eobj.MKBTPDCode=..GetLastCode(eobj.MKBTPDProDR)
		}
		
		if (eobj.MKBTPDDesc="")
		{
			q "{success:'false',errorinfo:'中心词不能为空！'}"
		}
		if (eobj.MKBTPDDesc="3@%CSP.CharacterStream")
		{
			q "{success:'false',errorinfo:'录入字符（包含标点）太多,已经达到上限，没法保存，请调整文字！'}"
		}
		if (eobj.MKBTPDRowId'="")&(eobj.MKBTPDRowId=eobj.MKBTPDLastLevel)
		{
			q "{success:'false',errorinfo:'不能把自己选做上级分类！'}"
		}
		s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),3)	//属性描述
		
		s codeFlagStr=..FormValidate(eobj.MKBTPDRowId,eobj.MKBTPDCode,eobj.MKBTPDProDR,1)  //调用重复验证
		s descFlagStr=..FormValidateDesc(eobj.MKBTPDRowId,eobj.MKBTPDDesc,eobj.MKBTPDProDR,eobj.MKBTPDLastLevel,1)  //调用重复验证
		s codeFlag=$p(codeFlagStr,"^",1)
		s descFlag=$p(descFlagStr,"^",1)
		if ((codeFlag=1)||(descFlag=1))
		{

			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			
		}
		else
		{		

			if (eobj.MKBTPDRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(CT.WDT.CDSS.TermProDetail).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(CT.WDT.CDSS.TermProDetail).%OpenId(eobj.MKBTPDRowId)
				s bobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
				s bobj.MKBTPDRowId = eobj.MKBTPDRowId
				s bobj.MKBTPDCode = obj.MKBTPDCode
				s bobj.MKBTPDDesc = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTPDDesc)
				s:obj.MKBTPDProDR'="" bobj.MKBTPDProDR = obj.MKBTPDProDR.%Id()
				s:obj.MKBTPDLastLevel'="" bobj.MKBTPDLastLevel = obj.MKBTPDLastLevel.%Id()
				s bobj.MKBTPDLevel = obj.MKBTPDLevel
				s bobj.MKBTPDActiveFlag=  obj.MKBTPDActiveFlag
				s bobj.MKBTPDRemark = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTPDRemark)
				s bobj.MKBTPDSequence=  obj.MKBTPDSequence
				s bobj.MKBTPDPYCode = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTPDPYCode)
				
				//如果是修改数据,则先删除索引表的数据
				//d ##class(web.DHCBL.MKB.BDPMKBIndex).DeleteTermIndex(eobj.MKBTPDRowId,"D")
			}
	
			s obj.MKBTPDCode = eobj.MKBTPDCode
			s eobj.MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBTPDDesc)
			s obj.MKBTPDDesc =eobj.MKBTPDDesc
			d:eobj.MKBTPDProDR'="" obj.MKBTPDProDRSetObjectId(eobj.MKBTPDProDR)
			d:eobj.MKBTPDProDR="" obj.MKBTPDProDRSetObjectId("")	 
			d:eobj.MKBTPDLastLevel'="" obj.MKBTPDLastLevelSetObjectId(eobj.MKBTPDLastLevel)
			d:eobj.MKBTPDLastLevel="" obj.MKBTPDLastLevelSetObjectId("")
			//s obj.MKBTPDLevel = eobj.MKBTPDLevel
			s obj.MKBTPDLevel = ..GetTreeLevel(eobj.MKBTPDLastLevel)
			s obj.MKBTPDActiveFlag = "Y"
			s obj.MKBTPDRemark =  ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBTPDRemark)	
			if (eobj.MKBTPDRowId'="")&(eobj.MKBTPDSequence="")
			{
				s eobj.MKBTPDSequence=bobj.MKBTPDSequence
			}
			s:eobj.MKBTPDSequence="" eobj.MKBTPDSequence=..GetLastOrder(eobj.MKBTPDProDR)
			s obj.MKBTPDSequence = eobj.MKBTPDSequence
			if (eobj.MKBTPDPYCode="")
			{
				s eobj.MKBTPDPYCode=..Filter(eobj.MKBTPDDesc)
				s eobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MKBTPDPYCode)
				s eobj.MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBTPDPYCode)
			}
			s obj.MKBTPDPYCode=eobj.MKBTPDPYCode
			
			s propertyType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),4)	//属性格式
			
			Ts
			
		
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				
				s id = obj.%Id()  
				
				if (eobj.MKBTPDExtend'="") //保存到知识点扩展属性值表
				{
					s itemStr= ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBTPDExtend)
					s itemlen=$Length(itemStr,"[N]")
					for i=1:1:itemlen  
					{
						s item=$p(itemStr,"[N]",i)
						if (item'="")
						{
							s child=$p(item,"[A]",1)  //知识点扩展属性子表的child值
							s fieldValue=$p(item,"[A]",2)  //知识点扩展属性子表的字段值
							if (child'="")
							{
								s extendDr=eobj.MKBTPDProDR_"||"_child  //知识点扩展属性子表的id
								s MKBTEPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR,"ChildExtPro",child)),2)   //扩展属性描述
								s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR,"ChildExtPro",child)),3)   //扩展属性类型
								if (MKBTEPName="展示名")&(fieldValue="")&(id'="")   //如果没有展示名则根据中心词自动生成
								{
									s fieldValue =$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(id)),3)  
								}
								if (MKBTEPName="检索码")&(fieldValue="")&(id'="") //如果没有检索码则根据中心词自动生成
								{
									s fieldValue =$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(id)),3)
									s fieldValue=##class(web.DHCBL.BDP.FunLib).GetPYCODE(fieldValue)
								}
								s valId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",id,extendDr,0))
								
								//扩展明细表实体类，用于生成日志
								s eobjv = ##class(web.CDSSEntity.CMKB.TermExtendProVal).%New()
								s eobjv.MKBTEPVRowId = valId
								s eobjv.MKBTEPVExtendDr= extendDr
								s eobjv.MKBTEPVDetailDr= id
								s eobjv.MKBTEPVValue = fieldValue	
							
								s oldFieldValue=""   //原先扩展属性的值
								if (fieldValue'="")  //如果有值则保存
								{
									if (MKBTEPType="D")	//日期类型转换格式
									{
										//s fieldValue=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(fieldValue)  //转换日期
									}								
									if (valId'="")
									{
										s objv=##class(CT.WDT.CDSS.TermExtendProVal).%OpenId(valId)
										s bobjv = ##class(web.CDSSEntity.CMKB.TermExtendProVal).%New()
										s bobjv.MKBTEPVRowId = valId
										s:objv.MKBTEPVExtendDr'="" bobjv.MKBTEPVExtendDr = objv.MKBTEPVExtendDr.%Id()
										s:objv.MKBTEPVDetailDr'="" bobjv.MKBTEPVDetailDr = objv.MKBTEPVDetailDr.%Id()
										s bobjv.MKBTEPVValue = objv.MKBTEPVValue
										s oldFieldValue=bobjv.MKBTEPVValue
										
									}
									else
									{
										s objv=##class(CT.WDT.CDSS.TermExtendProVal).%New()
									}
									d:id'="" objv.MKBTEPVDetailDrSetObjectId(id)
									d objv.MKBTEPVExtendDrSetObjectId(extendDr)
									
									s objv.MKBTEPVValue=fieldValue
									s scv=objv.%Save()

									d objv.%Close()
									If '$$$ISOK(scv)
									{
										s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
									}
									else   //成功后保存引用
									{
										s idv = objv.%Id()
									}
								}								
								else  //如果没有值
								{
								    
									if (valId'="") //如果之前有值现在没值了则删除
									{
										s objv=##class(CT.WDT.CDSS.TermExtendProVal).%OpenId(valId)
										s bobjv = ##class(web.CDSSEntity.CMKB.TermExtendProVal).%New()
										s bobjv.MKBTEPVRowId = valId
										s:objv.MKBTEPVExtendDr'="" bobjv.MKBTEPVExtendDr = objv.MKBTEPVExtendDr.%Id()
										s:objv.MKBTEPVDetailDr'="" bobjv.MKBTEPVDetailDr = objv.MKBTEPVDetailDr.%Id()
										s bobjv.MKBTEPVValue = objv.MKBTEPVValue
										s oldFieldValue=bobjv.MKBTEPVValue
										s scv=##class(CT.WDT.CDSS.TermExtendProVal).%DeleteId(valId)
										If '$$$ISOK(scv)
										{
											s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
										}
										else
										{
											d eobjv.%Close()
										}
									}
									
								}
								
								//处理扩展属性的值,扩展属性明细拼JSON串，用于日志
								s fieldValue=..GetExtendProValForLog(fieldValue,MKBTEPType)
								s:newExtendStr'="" newExtendStr=newExtendStr_","_extendDr_":"""_fieldValue_""""
								s:newExtendStr="" newExtendStr=extendDr_":"""_fieldValue_""""
								if (eobj.MKBTPDRowId'="")  //如果是修改
								{
									//原扩展属性明细拼JSON串，用于日志
									s oldFieldValue=..GetExtendProValForLog(oldFieldValue,MKBTEPType)
									s:oldExtendStr'="" oldExtendStr=oldExtendStr_","_extendDr_":"""_oldFieldValue_""""
									s:oldExtendStr="" oldExtendStr=extendDr_":"""_oldFieldValue_""""
								}
								
							}

						}
							
					}
					
				}
				
				//调用更新术语的编辑人和操作时间的接口
				d ##class(web.CDSS.CMKB.MedicalWikiStatis).UpdateLog(eobj.MKBTPDProDR)
				

			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库属性内容","web.CDSS.CMKB.TermProDetail","SaveData",eobj)
	     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
			}
			if (result["false")
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
			}
			else
			{
				TC
				
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				
				s propertyType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),4)	//属性格式
				//生成全文检索索引
				//d ##class(web.DHCBL.MKB.BDPMKBIndex).AddTermIndex(id,"D")
				
				//调用日志接口

				s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),6)  //术语id
				if (MKBTPTermDr'="")
				{
					if $d(%session)
					{
						d ..SavePersonLiable(MKBTPTermDr)   //保存责任人
					}
					
					s termDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),3)  //描述
					s termDesc=##class(web.DHCBL.BDP.FunLib).Util(termDesc)
					s baseid=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语所属术语库id
					if (baseid'="")  
					{
					    s baseDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(baseid)),3)  //术语所属术语库描述
					    s propertyType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),4)	//属性类型
					    s propertyDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),3)	//属性描述
						
						//处理对象描述
						s logDesc=..GetProDetailDescForLog(eobj.MKBTPDDesc,propertyType)
						//处理上级分类
						s:eobj.MKBTPDLastLevel'="" eobj.MKBTPDLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(eobj.MKBTPDLastLevel)),3)						
						s newJsonStr="MKBTPDDesc:"""_logDesc_""",MKBTPDPYCode:"""_eobj.MKBTPDPYCode_""",MKBTPDRemark:"""_eobj.MKBTPDRemark_""",MKBTPDLastLevel:"""_eobj.MKBTPDLastLevel_""""
						s:newExtendStr'="" newJsonStr=newJsonStr_","_newExtendStr
						s newJsonStr="{"_newJsonStr_"}"
						
						s logDesc=termDesc_"-"_propertyDesc_"-"_logDesc   //属性描述-内容						
					    d:eobj.MKBTPDRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermProDetail","CT.WDT.CDSS.TermProDetail"_eobj.MKBTPDProDR,baseDesc,id,logDesc,"A",newJsonStr)
					    if (eobj.MKBTPDRowId'="")
					    {
						    //处理原对象描述
							s oldlogDesc=..GetProDetailDescForLog(bobj.MKBTPDDesc,propertyType)	
							//处理上级分类
							s:bobj.MKBTPDLastLevel'="" bobj.MKBTPDLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(bobj.MKBTPDLastLevel)),3)	
																		
						    s oldJsonStr="MKBTPDDesc:"""_oldlogDesc_""",MKBTPDPYCode:"""_bobj.MKBTPDPYCode_""",MKBTPDRemark:"""_bobj.MKBTPDRemark_""",MKBTPDLastLevel:"""_bobj.MKBTPDLastLevel_""""
							s:oldExtendStr'="" oldJsonStr=oldJsonStr_","_oldExtendStr
							s oldJsonStr="{"_oldJsonStr_"}"
							
							//s oldlogDesc=termDesc_"-"_propertyDesc_"-"_oldlogDesc  //属性描述-内容	
						    d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermProDetail","CT.WDT.CDSS.TermProDetail"_eobj.MKBTPDProDR,baseDesc,eobj.MKBTPDRowId,logDesc,"U",newJsonStr,oldJsonStr)
					    }
				    }
				}

			}
		}
				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库属性内容","web.CDSS.CMKB.TermProDetail","SaveData","")
   		s ^ERRORLOGINFO(logid)="对象不存在！"   
	}
	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：获取修改时的记录
/// Input：id-属性内容表CT.WDT.CDSS.TermProDetail的id,property-属性id
/// Return：Json格式的 字段和值 信息
/// Other: d ##class(web.CDSS.CMKB.TermProDetail).NewOpenData(id,property)
ClassMethod NewOpenData(id As %String, property As %String) As %String
{
	s jsonstr=""	
	s MKBTPDRowId=id
	s MKBTPDCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),2)
	s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
	s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
	s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
	s MKBTPDLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),4)
	s MKBTPDRemark=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),7)
	s MKBTPDRemark= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
	s MKBTPDSequence=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),9) 
	s MKBTPDPYCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),10)
	s MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
	
	s ExtendStr=""   //知识点扩展属性子表的字段
	s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),3)	//属性描述
	s subId=""  //循环扩展属性子表CT.WDT.CDSS.TermProperty
	for 
	{
		S subId=$o(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)) 
		q:subId=""
		s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID

		s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
		s MKBTEPVRowId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
		s MKBTEPVValue=""
        s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
        if (MKBTEPVValue'="")
        {	
			if (MKBTEPType="CB")   //多选框
			{	
  				s MKBTEPVValue=##class(web.BDP.util.String).Replace(MKBTEPVValue,"&%",",")	
			}
			if (MKBTEPType="D")   //日期
			{
				//s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MKBTEPVValue)	
			}

        }
        s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTEPVValue)
        s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_subId_""":"""_MKBTEPVValue_""""
    	s:ExtendStr="" ExtendStr="""Extend"_subId_""":"""_MKBTEPVValue_""""
	}

	s mainstr=""
	s:ExtendStr'="" mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""","_ExtendStr_"}"
	s:ExtendStr="" mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_"""}"
	if (jsonstr'="")
	{ 
		s jsonstr=jsonstr_","_mainstr
	}
	else
	{
		s jsonstr=mainstr
	}

	q jsonstr
}

/// Creator:谷雪萍
/// CreatDate:2018-05-18
/// Description:删除限制
/// Input：id-诊断rowid
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.TermProDetail).GetRefFlag("2")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""	
	//树形术语判断是否有子菜单 
    s myChildFlag=$d(^CT.WDT.CDSS.TermProDetailI("ParIndex",id))
    if (myChildFlag){
	    s myInfo=myInfo_"有子节点"   
    }
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^"_myInfo
 	q return
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description:根据id删除
/// Table:CT.WDT.CDSS.TermProDetail
/// Input：id-属性内容表CT.WDT.CDSS.TermProDetail的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.TermProDetail).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s oldExtendStr=""  //扩展属性明细JSON串
	s logJsonStr=""   //日志JSON串
	s re=##class(web.CDSS.CMKB.TermProDetail).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0)  //未被引用
	{
		s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
		s pobj = ##class(CT.WDT.CDSS.TermProDetail).%OpenId(id)
		s eobj.MKBTPDRowId = id
		s eobj.MKBTPDCode = pobj.MKBTPDCode
		s eobj.MKBTPDDesc = pobj.MKBTPDDesc
		s eobj.MKBTPDProDR=""
		s:pobj.MKBTPDProDR'="" eobj.MKBTPDProDR = pobj.MKBTPDProDR.%Id()
		s:pobj.MKBTPDLastLevel'="" eobj.MKBTPDLastLevel = pobj.MKBTPDLastLevel.%Id()
		s eobj.MKBTPDLevel = pobj.MKBTPDLevel	
		s eobj.MKBTPDActiveFlag = pobj.MKBTPDActiveFlag
		s eobj.MKBTPDRemark = pobj.MKBTPDRemark
		s eobj.MKBTPDSequence = pobj.MKBTPDSequence
		s eobj.MKBTPDPYCode=pobj.MKBTPDPYCode
		d pobj.%Close()
		k pobj
		Tstart
		//d ##class(web.DHCBL.MKB.BDPMKBIndex).DeleteTermIndex(id,"D")   //调删除全文索引数据接口
		s sc=##class(CT.WDT.CDSS.TermProDetail).%DeleteId(id)
		if $$$ISOK(sc)
		{
			//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermProDetail","CT.WDT.CDSS.TermProDetail"_eobj.MKBTPDProDR,"医用知识库知识属性明细表",id,eobj.MKBTPDDesc,"D",eobj)
			
			//d eobj.%Close()
			//删除知识点扩展属性值表 MKB_TermExtendProVal
			s valId=0
			for
			{
				s valId=$o(^CT.WDT.CDSS.TermExtendProValI("DetailIndex",id,valId))  //术语明细表id
				q:valId=""
				//扩展明细表实体类，用于生成日志
				s eobjv = ##class(web.CDSSEntity.CMKB.TermExtendProVal).%New()
				s eobjv.MKBTEPVRowId = valId
				s eobjv.MKBTEPVExtendDr= $LISTGET($G(^CT.WDT.CDSS.TermExtendProValD(valId)),3) 
				s eobjv.MKBTEPVDetailDr= $LISTGET($G(^CT.WDT.CDSS.TermExtendProValD(valId)),2) 
				s eobjv.MKBTEPVValue = $LISTGET($G(^CT.WDT.CDSS.TermExtendProValD(valId)),4)
				 
				//处理扩展属性的值
				s fieldValue=eobjv.MKBTEPVValue
				if (eobjv.MKBTEPVExtendDr'="")
				{
					s child=$p(eobjv.MKBTEPVExtendDr,"||",2)  //扩展属性的child
					s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR,"ChildExtPro",child)),3)
					s fieldValue=..GetExtendProValForLog(fieldValue,MKBTEPType)
					s:oldExtendStr'="" oldExtendStr=oldExtendStr_","_eobjv.MKBTEPVExtendDr_":"""_fieldValue_""""
					s:oldExtendStr="" oldExtendStr=eobjv.MKBTEPVExtendDr_":"""_fieldValue_""""
				}
				
				s scv=##class(CT.WDT.CDSS.TermExtendProVal).%DeleteId(valId)
				if '$$$ISOK(scv)
				{
					s result= "{success:'false',info:'"_$zconvert(scv,"O","JS")_"'}"  //返回错误信息
					
				}
				else
				{
					//保存日志
					//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermExtendProVal","CT.WDT.CDSS.TermExtendProVal","医用知识库知识扩展属性明细表",valId,eobjv.MKBTEPVValue,"D",eobjv)
					d eobjv.%Close()
				}
				
			}
						
		}
		else
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库属性内容","web.CDSS.CMKB.TermProDetail","DeleteData",eobj)
	     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
		}
		
		if (result["false")
		{
			Trollback
			s result= "{success:'false',info:'删除失败'}"  //返回错误信息
		}
		else
		{
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			//d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("D",id)  //删除引用表数据
			//调用日志接口
			s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),6)  //术语id
			if (MKBTPTermDr'="")
			{
				if $d(%session)
				{
					d ..SavePersonLiable(MKBTPTermDr)  //保存责任人
				}
				s termDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),3)  //描述
				s termDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(termDesc) 
				s baseid=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语所属术语库id
				if (baseid'="")  
				{
				    s baseDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(baseid)),3)  //术语所属术语库描述
				    s propertyType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),4)	//属性类型
				    s propertyDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(eobj.MKBTPDProDR)),3)	//属性描述
					
					//处理对象描述
					s logDesc=..GetProDetailDescForLog(eobj.MKBTPDDesc,propertyType)
					//处理上级分类
					s:eobj.MKBTPDLastLevel'="" eobj.MKBTPDLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(eobj.MKBTPDLastLevel)),3)						
					s logJsonStr="MKBTPDDesc:"""_logDesc_""",MKBTPDPYCode:"""_eobj.MKBTPDPYCode_""",MKBTPDRemark:"""_eobj.MKBTPDRemark_""",MKBTPDLastLevel:"""_eobj.MKBTPDLastLevel_""""
					s:oldExtendStr'="" logJsonStr=logJsonStr_","_oldExtendStr
					s logJsonStr="{"_logJsonStr_"}"
					
					s logDesc=termDesc_"-"_propertyDesc_"-"_logDesc   //属性描述-内容						

					d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermProDetail","CT.WDT.CDSS.TermProDetail"_eobj.MKBTPDProDR,baseDesc,id,logDesc,"D",logJsonStr)
				    //s ^TMP("TextD1")=logJsonStr
					//s ^TMP("TextD2")=baseDesc_"^"_logDesc
			    }
			}	
			
			//调用更新术语的编辑人和操作时间的接口
			if (eobj.MKBTPDProDR'="")
			{
				d ##class(web.CDSS.CMKB.MedicalWikiStatis).UpdateLog(eobj.MKBTPDProDR)	
			}
			
		}
	}
	else  //被引用
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
    q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description:根据id删除属性内容，不加删除判断
/// Table:CT.WDT.CDSS.TermProDetail
/// Input：id-属性内容表CT.WDT.CDSS.TermProDetail的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.TermProDetail).DeleteDataExpectRef("2")
ClassMethod DeleteDataExpectRef(id As %String) As %String
{
	s result=""
	s oldExtendStr=""  //扩展属性明细JSON串
	s logJsonStr=""   //日志JSON串
	
	s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
	s pobj = ##class(CT.WDT.CDSS.TermProDetail).%OpenId(id)
	s eobj.MKBTPDRowId = id
	s eobj.MKBTPDCode = pobj.MKBTPDCode
	s eobj.MKBTPDDesc = pobj.MKBTPDDesc
	s:pobj.MKBTPDProDR'="" eobj.MKBTPDProDR = pobj.MKBTPDProDR.%Id()
	s:pobj.MKBTPDLastLevel'="" eobj.MKBTPDLastLevel = pobj.MKBTPDLastLevel.%Id()
	s eobj.MKBTPDLevel = pobj.MKBTPDLevel	
	s eobj.MKBTPDActiveFlag = pobj.MKBTPDActiveFlag
	s eobj.MKBTPDRemark = pobj.MKBTPDRemark
	s eobj.MKBTPDSequence = pobj.MKBTPDSequence
	s eobj.MKBTPDPYCode=pobj.MKBTPDPYCode
	d pobj.%Close()
	k pobj
	Tstart
	//d ##class(web.DHCBL.MKB.BDPMKBIndex).DeleteTermIndex(id,"D")   //调引用表接口	
	s sc=##class(CT.WDT.CDSS.TermProDetail).%DeleteId(id)
	if $$$ISOK(sc)
	{
		//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermProDetail","CT.WDT.CDSS.TermProDetail"_eobj.MKBTPDProDR,"医用知识库知识属性明细表",id,eobj.MKBTPDDesc,"D",eobj)
		
		//d eobj.%Close()
		//删除知识点扩展属性值表 MKB_TermExtendProVal
		s valId=0
		for
		{
			s valId=$o(^CT.WDT.CDSS.TermExtendProValI("DetailIndex",id,valId))  //术语明细表id
			q:valId=""
			
			s scv=##class(CT.WDT.CDSS.TermExtendProVal).%DeleteId(valId)
			if '$$$ISOK(scv)
			{
				s result= "{success:'false',info:'"_$zconvert(scv,"O","JS")_"'}"  //返回错误信息
				
			}
			else
			{
				//保存日志
				//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermExtendProVal","CT.WDT.CDSS.TermExtendProVal","医用知识库知识扩展属性明细表",valId,eobjv.MKBTEPVValue,"D",eobjv)
				//d eobjv.%Close()
			}
			
		}
		
	}
	else
	{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("CDSS知识库属性内容","web.CDSS.CMKB.TermProDetail","DeleteDataExpectRef",eobj)
     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	
	if (result["false")
	{
		Trollback
		s result= "{success:'false',info:'删除失败'}"  //返回错误信息
	}
	else
	{
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
	
		//d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("D",id)   //删除引用数据	
		

	}

    q result
}

/// Creator:谷雪萍
/// CreatDate:2018-05-08
/// Description:引用-列表型术语内容中 删除全部
/// Input:property-属性ID
/// return：成功或失败的信息
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).DeleteAllSelTerm(property)
ClassMethod DeleteAllSelTerm(property As %String) As %String
{
	q:(property="") "{success:'false',info:'未选中属性'}"
	
	s result=""
	s flag=""
	
	TS
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",property,MKBTPDRowId)) q:((MKBTPDRowId="") ||(flag="N"))

		s res=..DeleteDataExpectRef(MKBTPDRowId)
		if res["false"
		{
			s flag="N"

		}
	}
	
	if (flag="N")
	{
		Trollback
		s result = "{success:'false',info:'删除失败'}"  
	}
	else
	{
		TC
		s result = "{success:'true',info:'删除成功'}" 
	}
	q result
}

/// Creator：谷雪萍
/// CreatDate:2018-03-27
/// Description：拖拽 调整列表型属性的内容 的顺序
/// Return：成功返回'true'；失败返回'false'
/// Input：order  拖拽后按顺序排列的ID串,minSeq-最小的顺序
/// Other: d ##class(web.CDSS.CMKB.TermProDetail).SaveDragListOrder(order)
ClassMethod SaveDragListOrder(order, minSeq As %String = 1) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		q:(result=1)
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(CT.WDT.CDSS.TermProDetail).%OpenId(rowid)		
		s seq=minSeq+i-1
		s obj.MKBTPDSequence=seq
		s sc=obj.%Save()
		d obj.%Close()
		If '$$$ISOK(sc)
		{
			s result = 1
		}
	}
	if (result="")
	{
		Tc	
		s result = "{success:'true',info:'保存成功'}"
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：谷雪萍
/// CreatDate:2018-03-30
/// Description：获得最大的顺序+1，给添加窗口的顺序字段赋值
/// Return：成功返回最大值
/// Input：property 属性ID
/// Other: w ##class(web.CDSS.CMKB.TermProDetail).GetLastOrder(1)
ClassMethod GetLastOrder(property As %String) As %String
{
	q:property="" ""
	s LastOrder=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",property,""),-1)
	s LastOrder=$g(LastOrder)+1
	q LastOrder
}

/// Creator：谷雪萍
/// CreatDate:2018-03-30
/// Description:代码自动生成：属性代码+00001 代码最大值加1
/// Input：property-属性ID
/// Return：成功返回自动生成的Code
/// w ##class(web.CDSS.CMKB.TermProDetail).GetLastCode(1)
ClassMethod GetLastCode(property) As %String
{
	s mycode=""
  	//代码自动生成 属性代码+00001 开始
	s StartCode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),2)_"-"		
	s StartCodeLen=$Length(StartCode)
	s CodeLen=StartCodeLen+5
	s Code="", preCode=""    //寻找符合规则的最大的代码
	if ($d(^CT.WDT.CDSS.TermProDetailI("CodeIndex",property)))
	{
		for {
			s Code=$o(^CT.WDT.CDSS.TermProDetailI("CodeIndex",property,Code),-1)
			q:Code=""
			s realCode=$tr(Code," ","")
			if ($e(realCode,1,StartCodeLen)=$ZCONVERT(StartCode,"U"))
			{
				s preCode=realCode
				q
			}
		
		}
	}
	s CodeNum=""
	if (preCode="")   //如果没有符合规则的代码，则生成第一个数字1
	{
		s CodeNum=1
	}
	else  //如果有符合规则的代码，则起始字符后的数字+1
	{		
		s CodeNum=$p(preCode,$ZCONVERT(StartCode,"U"),2)+1     //起始字符后的数字+1
	}
	s CodeNumLen=$Length(CodeNum)     //数字的长度

	s zeroLen=CodeLen-StartCodeLen-CodeNumLen  //中间0串的长度
	s zeroStr=""  //中间0串
	s count=0
	for
	{
		s count=count+1
		q:count>zeroLen
		s zeroStr=zeroStr_"0"
	}
	
	s mycode=StartCode_zeroStr_CodeNum  //起始字符_0串_数字 的组合

	q mycode
}

/// Creator：谷雪萍
/// CreatDate:2018-03-30
/// Description：获取树形属性内容数据
/// Table：CT.WDT.CDSS.TermProDetail
/// Input：id-父节点,property-属性id
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.TermProDetail).GetJsonList("","")
ClassMethod GetJsonList(id As %String, property As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s childStr=""
	s count=0
	w "["
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
			if count>1 w ","
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
			
			w "{""id"":"""_myRowID_""""
			w ",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""",""MKBTPDLastLevelF"":"""_MKBTPDLastLevelF_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""""
			s ExtendStr=""   //知识点扩展属性子表的字段
			s subId=0  //循环扩展属性子表CT.WDT.CDSS.TermProperty
			for 
			{
				S subId=$o(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)) q:subId=""
				s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
				s MKBTEPVValueStr=..GetExtendProValValue(property,subId,myRowID)
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
				w ","_ExtendStr
			}
			//s childStr=..GetChildOrderedIDStr(myRowID,property)
			//if childStr'=""
			if $d(^CT.WDT.CDSS.TermProDetailI("ProParIndex",property,myRowID))
			{
				//一次性加载   
				w ",""state"":""open"""   //closed节点不展开,open节点展开
				w ",""children"":"
				w ..GetJsonList(myRowID,property)
			}
			else
			{
				w ",""state"":""open"""
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator：谷雪萍
/// CreatDate:2018-05-14
/// Description：根据ID获取树形属性内容数据
/// Table：CT.WDT.CDSS.TermProDetail
/// Input：id-属性内容id,property-属性id
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.TermProDetail).GetTreeJsonListById("","")
ClassMethod GetTreeJsonListById(id As %String, property As %String) As %String
{
	s myRowID=id
	s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),3)
	s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
	s MKBTPDCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),2)
	s MKBTPDRemark=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),7)
	s MKBTPDRemark=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
	s MKBTPDSequence=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),9)
	s MKBTPDPYCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),10)
	s MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
	s MKBTPDLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),4)
	if (MKBTPDLastLevel'="")
	{
		 s MKBTPDLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDLastLevel)),3)
		 s MKBTPDLastLevel=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDLastLevel)
	}
	
	s MKBTPDLevel=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),5)
	w "["	
	w "{""id"":"""_myRowID_""""
	w ",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""""
	s ExtendStr=""   //知识点扩展属性子表的字段
	s subId=0  //循环扩展属性子表CT.WDT.CDSS.TermProperty
	for 
	{
		S subId=$o(^CT.WDT.CDSS.TermPropertyD(property,"ChildExtPro",subId)) q:subId=""
		s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
		s MKBTEPVValueStr=..GetExtendProValValue(property,subId,myRowID)
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
		w ","_ExtendStr
	}		
	w "}"
		

	w "]"
	q ""
}

/// Creator：谷雪萍
/// CreatDate: 2018-03-29
/// Description：查询页面数据
/// Table：CT.WDT.CDSS.TermProDetail
/// Input：property-属性id，id-父节点，rowid-id  
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.TermProDetail).GetJsonDataForCmb("",)
ClassMethod GetJsonDataForCmb(id As %String, property As %String, rowid As %String) As %String
{
	
	//如果rowid为空则只输出一条
	if (rowid'=""){
		s Caption=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(rowid)),3)
		s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
		q "[{""id"":"""_rowid_""",""text"":"""_Caption_""",""state"":""open""}]"
	}
	
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
		
	s childStr=""
	s count=0
	w "["
	s mySeq=""
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			s Caption=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
			w ",""state"":""open"""
			//s childStr=..GetChildOrderedIDStr(myRowID,property)
			//if childStr'=""
			if $d(^CT.WDT.CDSS.TermProDetailI("ProParIndex",property,myRowID))
			{
				w ",""children"":"
				w ..GetJsonDataForCmb(myRowID,property,"")	
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator：谷雪萍
/// CreatDate: 2018-07-05
/// Description：获取术语下拉树控件数据的方法
/// Table：CT.WDT.CDSS.Term
/// Input：base-术语库注册id，id-父节点，rowid-id 
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.TermProDetail).GetJsonDataForTermCmb("31","","")
ClassMethod GetJsonDataForTermCmb(base As %String, id As %String, rowid As %String) As %String
{
	//如果rowid为空则只输出一条
	if (rowid'=""){
		s Caption=$LISTGET($G(^CT.WDT.CDSS.TermD(rowid)),3)
		s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
		q "[{""id"":"""_rowid_""",""text"":"""_Caption_""",""state"":""open""}]"
	}
	
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	w "["
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			s Caption=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
			w ",""state"":""open"""

			if $d(^CT.WDT.CDSS.TermI("ParentIndex",base,myRowID))
			{
				w ",""children"":"
				w ..GetJsonDataForTermCmb(base,myRowID,"")	
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator：谷雪萍
/// CreatDate: 2018-03-30
/// Description：保存拖拽的内容 
/// Table：User.DHCSymptomLev
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.BDPItemCategory).DragNode()
ClassMethod DragNode(id, parentid, orderstr) As %String
{
	s result=""
	q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
	//q:(parentid="") "{success:'false',errorinfo:'没有拖拽到准确的节点下'}"
	s:parentid="TreeRoot" parentid=""
		
	s obj=##class(CT.WDT.CDSS.TermProDetail).%OpenId(id)
		
	d:parentid="" obj.MKBTPDLastLevelSetObjectId("")
	d:parentid'="" obj.MKBTPDLastLevelSetObjectId(parentid)
	
	s MKBTPDDesc=obj.MKBTPDDesc  //描述
	if (obj.MKBTPDProDR'="")
	{
		s MKBTPDProDR = obj.MKBTPDProDR.%Id()  //属性ID
		s descFlag=..FormValidateDesc(id,MKBTPDDesc,MKBTPDProDR,parentid)  //调用重复验证
		if (descFlag=1)
		{
			d obj.%Close()
			q "{success:'false',errorinfo:'该记录已经存在'}"
		}
	}

	Ts	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	
		s orderLen=$Length(orderstr,"^")
		for i=1:1:orderLen   
		{      
			s rowid=$p(orderstr,"^",i)
			s obj=##class(CT.WDT.CDSS.TermProDetail).%OpenId(rowid)
			s obj.MKBTPDSequence =i
			s sc=obj.%Save()
			d obj.%Close()		      
		}
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2018-03-30
/// Description：保存检索码
/// Table：CT.WDT.CDSS.TermProDetail
/// Input： property-属性id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).SaveSearchWord("20797")
ClassMethod SaveSearchWord(property) As %String
{
	s result=""
	q:property="" "{success:'false',errorinfo:'没有获取到属性！'}"
	
	s showLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",property," 展示名"))
	if (showLength)
	{
		s showChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",property," 展示名",0))
		s showCatId=property_"||"_showChildsub
	}

	TS
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 

		s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
		s MKBTPDPYCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),10)
		continue:MKBTPDPYCode'=""
		s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
		s showValue=""
		if (showLength)  //如果有展示名，检索码根据展示名生成
		{
			s showValId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",MKBTPDRowId,showCatId,0))  //扩展属性内容表的id		
	        s:showValId'="" showValue=$LISTGET($G(^CT.WDT.CDSS.TermExtendProValD(showValId)),4) //扩展属性内容的值
		}
		s:showValue="" showValue=MKBTPDDesc     //如果展示名为空，则等于主列名
        if (showValue'="")
        {
	        s showValue=$ZCONVERT(showValue,"U")
	        s showValue=..Filter(showValue)
        	s PYValue= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(showValue)
			s obj=##class(CT.WDT.CDSS.TermProDetail).%OpenId(MKBTPDRowId)
			s obj.MKBTPDPYCode=PYValue
			s sc=obj.%Save()
			d obj.%Close()
			If '$$$ISOK(sc)
			{
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
			}
			
        }        	
		
	}
	If (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'检索码生成失败！'}"   //返回错误信息
	}
	else
	{		
		Tc
		s result = "{success:'true',info:'检索码生成成功！'}"  
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：获取属性内容的id和描述——文本属性内容模块用到
/// Input: property-属性id
/// return:CT.WDT.CDSS.TermProDetail的ID_"[A]"_属性内容
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetTextInfo("3")
ClassMethod GetTextInfo(property As %String) As %String
{
	q:property="" ""
	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",property,0))
	s MKBTPDDesc=""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
	q MKBTPDRowId_"[A]"_MKBTPDDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：获取属性内容描述——引用属性类型属性内容维护模块——定义节点的显示
/// Input: id——属性内容id
/// return:属性内容描述
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetDesc("3")
ClassMethod GetDesc(id As %String) As %String
{
	q:id="" ""
	s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(id)),3)
	q MKBTPDDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-04-03
/// Description：获取诊断常用名
/// Input: property-属性id
/// return:诊断展示名、如果常用名为空则返回诊断描述
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetTermCom("4")
ClassMethod GetTermCom(property As %String) As %String
{
	q:property="" ""
	s termCom=""
	s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(property)),6)  //术语指针
	if (MKBTPTermDr'="")
	{
		s termCom=..GetTermComByTermId(MKBTPTermDr)
	}
	q termCom
}

/// Creator:谷雪萍
/// CreatDate:2018-04-10
/// Description：获取术语的常用名 如果常用名为空的话则返回术语中心词
/// Input：termid -术语id
/// Return:常用名
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetTermComByTermId(1)
ClassMethod GetTermComByTermId(termid As %String) As %String
{
	s termDesc=$listGet($g(^CT.WDT.CDSS.TermD(termid)),3)  //术语中心词	
	q:('$d(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termid," AL"))) termDesc
	s comPropertyId=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termid," AL",0)) //常用名的属性id
	s mySeq=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",comPropertyId,0)) 
	q:mySeq="" termDesc
	s detailId=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",comPropertyId,mySeq,0))
	q:detailId="" termDesc
	s termCom=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(detailId)),3)   //常用名
	s:termCom="" termCom=termDesc
	q termCom
}

/// Creator：谷雪萍
/// CreatDate: 2018-6-01
/// Description：查询列表术语的内容，用于术语下拉框
/// Table：CT.WDT.CDSS.Term
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermProDetail","GetTermCmb","","","")
Query GetTermCmb(rowid As %String, q As %String, base As %String) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTSequence")
{
}

ClassMethod GetTermCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, base As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	  
	if (base'="") //如果子术语库大类未选中
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			s MKBTRowId=rowid
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
			s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)  //顺序
			d OutputTermCmb
		}
		else
		{
			s count=0
			s desc=q
			s:desc'="" desc=$ZCONVERT(desc,"U")
			if ($d(^CT.WDT.CDSS.TermI("BaseIndex",base)))  //该术语库下有数据
			{
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId),-1) q:((MKBTRowId="") ||(count>49))
					
					//封闭的数据不显示
					s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
					continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
					
					s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
					s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
					s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)
								
					s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
					s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
					s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
					s aliasDescU=$ZCONVERT(aliasDesc,"U")
					s aliasKeyU=$ZCONVERT(aliasKey,"U")
					
					i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
					{
						s count=count+1
						d OutputTermCmb
					}		
					
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTermCmb
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTSequence)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTermCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTermCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTermCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTermCmbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：生成索引-过滤特殊字符
/// Input：str-字符串
/// Return:str-过滤后的字符串
/// w ##class(web.CDSS.CMKB.TermProDetail).Filter("血、尿、便常规")
ClassMethod Filter(str As %String) As %String
{
	s str = ##class(web.BDP.util.String).Replace(str,"<br/>","")
	s str = ##class(web.BDP.util.String).Replace(str,"[A]","")
	s str = ##class(web.BDP.util.String).Replace(str,"[N]","")
	s str = ##class(web.BDP.util.String).Replace(str,$c(13),"")
	s str = ##class(web.BDP.util.String).Replace(str,$c(10),"")
	s str = ##class(web.BDP.util.String).Replace(str,$c(0),"")
	s str = ##class(web.BDP.util.String).Replace(str,"\","")
	s str = ##class(web.BDP.util.String).Replace(str,$c(10,10,10),"")
	for i=0:1:47
	{
		continue:i=10
		s:str[$c(i) str = ##class(web.BDP.util.String).Replace(str,$c(i),"")
	}

	for i=158:1:170
	{
		s:str[$c(i) str = ##class(web.BDP.util.String).Replace(str,$c(i),"")
	}
	s:str[" " str=$Translate(str," ","")
	s:str["`" str=$Translate(str,"`","")
	s:str["~" str=$Translate(str,"~","")
	s:str["!" str=$Translate(str,"!","")
	s:str["@" str=$Translate(str,"@","")
	s:str["#" str=$Translate(str,"#","")
	s:str["$" str=$Translate(str,"$","")
	s:str["%" str=$Translate(str,"%","")
	s:str["^" str=$Translate(str,"^","")
	s:str["&" str=$Translate(str,"&","")
	s:str["*" str=$Translate(str,"*","")
	s:str["(" str=$Translate(str,"(","")
	s:str[")" str=$Translate(str,")","")
	s:str["-" str=$Translate(str,"-","")
	s:str["_" str=$Translate(str,"_","")
	s:str["=" str=$Translate(str,"=","")
	s:str["+" str=$Translate(str,"+","")
	s:str["[" str=$Translate(str,"[","")
	s:str["{" str=$Translate(str,"{","")
	s:str["]" str=$Translate(str,"]","")
	s:str["}" str=$Translate(str,"}","")
	s:str["\" str=$Translate(str,"\","")
	s:str["|" str=$Translate(str,"|","")
	s:str[";" str=$Translate(str,";","")
	s:str[":" str=$Translate(str,":","")
	s:str["'" str=$Translate(str,"'","")
	s:str["“" str=$Translate(str,"“","")
	s:str["‘" str=$Translate(str,"‘","")
	s:str["’" str=$Translate(str,"’","")
	s:str["”" str=$Translate(str,"”","")
	s:str["," str=$Translate(str,",","")
	s:str["<" str=$Translate(str,"<","")
	s:str["." str=$Translate(str,".","")
	s:str[">" str=$Translate(str,">","")
	s:str["/" str=$Translate(str,"/","")
	s:str["?" str=$Translate(str,"?","")
	s:str["""" str=$Translate(str,"""","")
	s:str["·" str=$Translate(str,"·","")
	s:str["！" str=$Translate(str,"！","")
	s:str["￥" str=$Translate(str,"￥","")
	s:str["……" str=$Translate(str,"……","")
	s:str["（" str=$Translate(str,"（","")
	s:str["）" str=$Translate(str,"）","")
	s:str["—" str=$Translate(str,"—","")
	s:str["【" str=$Translate(str,"【","")
	s:str["】" str=$Translate(str,"】","")
	s:str["『" str=$Translate(str,"『","")
	s:str["』" str=$Translate(str,"』","")
	s:str["、" str=$Translate(str,"、","")
	s:str["；" str=$Translate(str,"；","")
	s:str["：" str=$Translate(str,"：","")
	s:str["，" str=$Translate(str,"，","")
	s:str["。" str=$Translate(str,"。","")
	s:str["《" str=$Translate(str,"《","")
	s:str["》" str=$Translate(str,"》","")
	s:str["？" str=$Translate(str,"？","")
	s:str["～" str=$Translate(str,"～","")

	Q str
}

/// Creator:谷雪萍
/// CreatDate:2021-03-02
/// Description:编辑数据时保存责任人
/// Input:termId-术语id
/// Return:true/false及错误信息
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).SavePersonLiable(termId)
ClassMethod SavePersonLiable(TermId)
{
	s result=""
	q:TermId="" "{success:'false',info:'没获取到术语id，责任人保存失败！'}"  //返回错误信息
	s PropertyId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",TermId," 责任人",0)) //属性id
	q:PropertyId="" "{success:'true',info:'没有责任人属性不需要保存！'}"  
	s UserName=$g(%session.Data("LOGON.USERNAME"))
	q:UserName="" "{success:'false',info:'没有获取到责任人保存失败！'}" 
	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",PropertyId,0))   //属性内容id
	s MKBTPDCode=""
	s:MKBTPDRowId'="" MKBTPDCode=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),2)
	s:MKBTPDCode="" MKBTPDCode=..GetLastCode(PropertyId)
	if (MKBTPDRowId="")  //如果RowId未赋值则增加
	{
		s obj=##class(CT.WDT.CDSS.TermProDetail).%New()
	}
	else  //如果RowId已赋值则修改
	{
		s obj=##class(CT.WDT.CDSS.TermProDetail).%OpenId(MKBTPDRowId)	
	}
	s obj.MKBTPDCode = MKBTPDCode
	s obj.MKBTPDDesc =UserName
	d obj.MKBTPDProDRSetObjectId(PropertyId)
	s obj.MKBTPDLevel = 1
	s obj.MKBTPDActiveFlag = "Y"
	s obj.MKBTPDSequence =1
	s obj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(UserName)
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{	
		s id = obj.%Id()  
		s result="{success:'true',info:'没有获取到责任人不需要保存！'}" 
	}
	else
	{
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
	}	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-30
/// Input：parentId 上级节点Id
/// Return：级别
/// Description:新增时，根据获取上级节点，来给级别赋值
/// w ##class(web.CDSS.CMKB.TermProDetail).GetTreeLevel("24")
ClassMethod GetTreeLevel(parentId As %String) As %String
{
	
	s count=1
	if (parentId'="")
	{
		s parent=parentId
		for
		{
			s parent=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(parent)),4)
			q:parent=""
			s count=count+1
		}
		s count=count+1
	}
	q count
}

/// Creator:谷雪萍
/// CreatDate:2018-05-03
/// Description：获取属性主列名
/// Input：id-属性表的ID
/// Return:属性的主列名，如果主列名为空则显示属性描述
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).getPropertyName(1)
ClassMethod getPropertyName(id As %String) As %String
{
	q:(id="") ""

	s desc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(id)),7)  //主列名
	s:desc="" desc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(id)),3)
	q desc
}

/// Creator:谷雪萍
/// CreatDate:2021-10-22
/// Description：把百科管理的内容转移到CDSS新建的表
/// Input：
/// Return:1
/// w ##class(web.CDSS.CMKB.TermProDetail).GetDetailByTermIdProName(1736139,"责任人")
ClassMethod GetDetailByTermIdProName(TermId As %String, ProName As %String) As %String
{
	q:(TermId="")||(ProName="") ""
	s PropertyId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",TermId," "_$ZCONVERT(ProName,"U"),0))
	q:(PropertyId="") ""
	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",PropertyId,0))
	q:(MKBTPDRowId="") ""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3) 
	q MKBTPDDesc
}

/// Creator:谷雪萍
/// CreatDate:2021-12-24
/// Description：获取术语库扩展列的值
/// Input：propertyId-属性的id,detailId-属性内容表的ID,extProDesc-扩展属性的描述
/// Return:扩展属性值表的内容
/// w ##class(web.CDSS.CMKB.TermProDetail).GetExtendVal(20,2,"检索码")
ClassMethod GetExtendVal(detailId As %String, propertyId As %String, extProDesc As %String) As %String
{
	
	q:((detailId="")||(propertyId="")||(extProDesc="")) ""
	
	s extProDesc=" "_$ZCONVERT(extProDesc,"U") //转换成大写
	s extendVal=""

	s extProLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",propertyId,extProDesc))
	if (extProLength)
	{
		s extProChild=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",propertyId,extProDesc,0)) 
		s extProId=propertyId_"||"_extProChild
		s MKBTEPVRowId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",detailId,extProId,0))  //扩展属性内容表CT.WDT.CDSS.TermProDetail的id
		s:MKBTEPVRowId'="" extendVal=$LISTGET($G(^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值		
	}
	s extendVal= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(extendVal)
	q extendVal
}

/// Creator:谷雪萍
/// CreatDate:2021-12-24
/// Description:获取百科的某一个属性的内容
/// Input:baseDesc-检查/检验/手术/护理，termDesc-检查名称/检验名称/手术名称/护理名称，proDesc-属性名称
/// Return:Json 数据，其中MKBTPDRowId为属性内容id，MKBTPDDesc为属性内容描述
/// Other:w ##class(web.CDSS.CMKB.TermProDetail).GetWikiProDetails("检验","血常规","注意事项")
ClassMethod GetWikiProDetails(baseDesc As %String, termDesc As %String, proDesc As %String)
{
	s result=""
	q:(baseDesc="")||(termDesc="")||(proDesc="") result
	
	s baseId=##class(web.CDSS.CMKB.TermBase).GetIdByDesc(baseDesc)  //术语库注册id
	q:baseId="" result
	s termId=$o(^CT.WDT.CDSS.TermI("DescIndex",baseId," "_($ZCONVERT(termDesc,"U")),0))   //百科中心词ID
	q:termId="" result
	s proId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",termId," "_($ZCONVERT(proDesc,"U")),0))  //根据属性描述来获取属性ID  
	q:proId="" result 
	s total=0
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",proId,MKBTPDRowId)) q:(MKBTPDRowId="") //遍历改属性下的属性内容		
		s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
		s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
		continue:MKBTPDDesc=""
		s total=total+1

		s:result'="" result=result_"<br/>"
		s result=result_MKBTPDDesc
			
		if (proDesc="检验标本及采集要求")
		{
			s CollectRuquire=..GetExtendVal(MKBTPDRowId,proId,"采集要求")  //获取采集要求
			s:CollectRuquire'="" result=result_"<br/>"_CollectRuquire
		}
		
	}
	q result
}

}

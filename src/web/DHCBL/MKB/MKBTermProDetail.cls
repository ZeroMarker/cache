/// Creator:基础数据平台组-谷雪萍
/// CreatDate:2018-03-27
/// Description：医用知识库知识属性明细表 增、删、改、查方法类
/// Table：User.MKBTermProDetail
Class web.DHCBL.MKB.MKBTermProDetail Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：获取属性内容列表的数据
/// Input：rowid-属性内容id，desc-检索内容, property-属性id, rows-每页显示几行, page-第几页
/// Return:Json格式的字符串
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetMyList("","","26316",5,1)
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
		s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),2)
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
		s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
		s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
		s MKBTPDRemark= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
		s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9) 
		s MKBTPDPYCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),10)
		s MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
		s ExtendStr=""   //知识点扩展属性子表的字段

		s subId=0  //循环扩展属性子表User.MKBTermProperty
		for 
		{
			S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
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
			s MKBTPDSequence=$o(^User.MKBTermProDetailI("SeqIndex",property,MKBTPDSequence)) q:MKBTPDSequence=""
			s MKBTPDRowId=0
			for 
			{
				s MKBTPDRowId=$o(^User.MKBTermProDetailI("SeqIndex",property,MKBTPDSequence,MKBTPDRowId)) q:MKBTPDRowId="" 
						
			/*s MKBTPDRowId=0
			for  
			{	
				s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" */
				s MKBTPDDescU=""
				if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
				{
					
				}
				else
				{
					s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),2)
					s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
					s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
					s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
					s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
					s MKBTPDRemark= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
					s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9) 
					s MKBTPDPYCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),10)
					s MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
					s ExtendStr=""   //知识点扩展属性子表的字段

					s subId=0  //循环扩展属性子表User.MKBTermProperty
					for 
					{
						S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
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
/// CreatDate:2019-8-01
/// Description：获取结构化诊断的描述
/// Input：expValue 表达式的值
/// Return：表达式的描述
/// Other: w ##class(web.DHCBL.MKB.MKBTermProDetail).GetExpData("843")
ClassMethod GetExpDesc(expValue) As %String
{
	s SDSTermDR=$p(expValue,"-",1) //诊断id
	s SDSValue=$p(expValue,"-",2) //属性id串
	q:SDSTermDR="" ""
	s result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(SDSValue,SDSTermDR)
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-06-06
/// Description：获取扩展属性明细表的值
/// Input：property-属性id，subId-扩展属性child，MKBTPDRowId-属性明细表id
/// Return:扩展属性明细表的值（MKBTEPVValue）
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(property,subId,MKBTPDRowId)
ClassMethod GetExtendProValValue(property As %String, subId As %String, MKBTPDRowId As %String) As %String
{
	q:((property="")||(subId="")||(MKBTPDRowId="")) ""
	
	s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
	s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
	s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
	q:MKBTEPVRowId="" ""
    s MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
    s MKBTEPVValueF=MKBTEPVValue
    if (MKBTEPVValue'="")
    {	
		if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
		{	
			s MKBTEPVValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBTEPVValue)  //获取描述，树形的所有上级节点也要显示	

		}
		if (MKBTEPType="CB")   //多选框
		{	
			s MKBTEPVValue=##class(web.BDP.util.String).Replace(MKBTEPVValue,"&%",",")	
		}
		if (MKBTEPType="SD")   //知识表达式
		{	
			//s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)
			s MKBTEPVValue=..GetExpDesc(MKBTEPVValue)	
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
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValForLog(MKBTEPVValue,MKBTEPType)
ClassMethod GetExtendProValForLog(MKBTEPVValue As %String, MKBTEPType As %String) As %String
{
	q:MKBTEPVValue="" ""
		
	if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
	{	
		s MKBTEPVValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBTEPVValue)  //获取描述，树形的所有上级节点也要显示	

	}
	if (MKBTEPType="CB")   //多选框
	{	
		s MKBTEPVValue=##class(web.BDP.util.String).Replace(MKBTEPVValue,"&%",",")	
	}
	if (MKBTEPType="SD")   //知识表达式
	{	
		//s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)	
		s MKBTEPVValue=..GetExpDesc(MKBTEPVValue)	
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
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetProDetailDescForLog(logDesc,propertyType)
ClassMethod GetProDetailDescForLog(logDesc As %String, propertyType As %String) As %String
{
	q:logDesc="" ""   //日志描述
	
	if (propertyType="S")||(propertyType="SS")	
	{
		s logDesc=$listGet($g(^User.MKBTermD(logDesc)),3)
	}	
	if (propertyType="P")
	{
		s logDesc=..GetPropertyLogDesc(logDesc)
	}
	if (propertyType="CB")
	{
		s logDesc=##class(web.BDP.util.String).Replace(logDesc,"&%",",")	
	}
	if (propertyType="SD")   //知识表达式
	{	
		//s logDesc=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(logDesc)
		s logDesc=..GetExpDesc(logDesc)	
	}  
	s logDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(logDesc)
	s logDesc=$tr(logDesc,",","，")
	q logDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-08-14
/// Description：根据属性id获取术语库注册id和术语id
/// Input：property-属性ID
/// Return:术语库注册id^术语id
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetBaseByProperty(29036)
ClassMethod GetBaseByProperty(property As %String) As %String
{
	q:property="" ""

	s baseid="" //术语所属术语库id
	s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(property)),6)  //术语id
	s:MKBTPTermDr'="" baseid=$listGet($g(^User.MKBTermD(MKBTPTermDr)),4)  //术语所属术语库id
	s ProConfig=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //属性配置项
	q baseid_"^"_MKBTPTermDr_"^"_ProConfig
}

/// Creator:谷雪萍
/// CreatDate:2018-03-30
/// Description：获取属性名称，及扩展属性的信息，用来加载组件和生成列
/// Input：property-属性ID
/// Return:属性描述[A]属性扩展表的child串[A]属性扩展表的描述串[A]属性扩展表的类型串[A]配置项串
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).getExtendInfo(29036)
ClassMethod getExtendInfo(property As %String) As %String
{
	q:property="" ""
	s dataIndex=""  //组件dataIndex
	s header=""  //组件标题、列表表头
	s type=""  //组件类型
	s config="" //配置项
	s baseid="" //术语所属术语库id
	s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(property)),6)  //术语id
	s:MKBTPTermDr'="" baseid=$listGet($g(^User.MKBTermD(MKBTPTermDr)),4)  //术语所属术语库id
	s TermCom=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermCom(property)  //术语常用名
	
	s desc=$LISTGET($G(^User.MKBTermPropertyD(property)),7)  //主列名
	s:desc="" desc=$LISTGET($G(^User.MKBTermPropertyD(property)),3)
	s count=0  //计数变量，只有一个扩展属性时不带连接符
	/*s subId=0  //循环扩展属性子表User.MKBTermProperty
	for 
	{
		S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
		s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID*/
	s Sequence=""  //按照扩展属性的顺序生成列或者控件
	for {
		s Sequence=$o(^User.MKBTermExtendProI("SeqIndex",property,Sequence)) q:Sequence=""
		s subId=0
		for 
		{
			S subId=$o(^User.MKBTermExtendProI("SeqIndex",property,Sequence,subId)) q:subId=""
			s MKBTEPRowId=property_"||"_subId
	
			s MKBTEPName=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),2)   //扩展属性名称
			continue:MKBTEPName=""
			s count=count+1
			s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
			s MKBTEPConfig=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),4)   //扩展属性配置项
			s:MKBTEPType="" MKBTEPType="TX"
			if (MKBTEPType="S")&(MKBTEPConfig'="")  //如果是引用类型的，且配置项不为空
			{
				s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(MKBTEPConfig)),4)  //术语库类型 L/T
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
/// CreatDate:2018-03-30
/// Description：获取扩展属性值,用来给组件赋值
/// Input：id-属性值表User.MKBTermProDetail的ID，property-属性ID，child-扩展属性子表的child
/// Return:扩展属性的值 User.MKBTermExtendProVal表的MKBTEPVValue字段保存的值
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).getExtendValue(1,1,1)
ClassMethod getExtendValue(id As %String, property As %String, child As %String) As %String
{
	q:(id="")||(property="")||(child="") ""

	s MKBTEPRowId=property_"||"_child   //知识点扩展属性表User.MKBTermExtendPro的rowid 
	s MKBTEPVValue="" //扩展属性子表字段的值-存在User.MKBTermExtendProVal表
	s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",id,MKBTEPRowId,0))  //扩展属性内容表User.MKBTermProDetail的id
    s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
	q MKBTEPVValue
}

/// Creator:谷雪萍
/// CreatDate:2018-05-03
/// Description：获取属性主列名
/// Input：id-属性表的ID
/// Return:属性的主列名，如果主列名为空则显示属性描述
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).getPropertyName(1)
ClassMethod getPropertyName(id As %String) As %String
{
	q:(id="") ""

	s desc=$LISTGET($G(^User.MKBTermPropertyD(id)),7)  //主列名
	s:desc="" desc=$LISTGET($G(^User.MKBTermPropertyD(id)),3)
	q desc
}

/// Creator:谷雪萍
/// CreatDate:2018-12-05
/// Description：根据属性id获取属性名和诊断名
/// Input：id-属性表的ID
/// Return:属性名-诊断名
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetProAndTermDesc(1)
ClassMethod GetProAndTermDesc(id As %String) As %String
{
	q:(id="") ""
	s proDesc=$LISTGET($G(^User.MKBTermPropertyD(id)),3)
	s termDr=$LISTGET($G(^User.MKBTermPropertyD(id)),6)
	s termdesc=""
	s:termDr'="" termdesc=$LISTGET($G(^User.MKBTermD(termDr)),3)
	q termdesc_"-"_proDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-03-30
/// Description：用于实现数据校验功能的方法
/// Input：id-属性值表User.MKBTermProDetail的ID，code-内容code，catdr-属性id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, catdr As %String, rowidflag As %String = "") As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^User.MKBTermProDetailI("CodeIndex",catdr,code))
	if (id="") //如果为空，增加时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^User.MKBTermProDetailI("CodeIndex",catdr,code,0))
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
		s:code'="" idc=$o(^User.MKBTermProDetailI("CodeIndex",catdr,code,0))
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
/// Input：id-属性值表User.MKBTermProDetail的ID，desc-中心词，catdr-属性id,parentDr-父节点id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).FormValidate("","","")
ClassMethod FormValidateDesc(id As %String, desc As %String, catdr As %String, parentDr As %String, rowidflag As %String = "") As %String
{
	//鉴别诊断去掉重复校验
	s proDesc=$LISTGET($G(^User.MKBTermPropertyD(catdr)),3)
	q:proDesc="鉴别诊断" 0
	s:parentDr="" parentDr=-100000000000000
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag=0
	s MKBTPDRowId=0
	for
	{
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProParIndex",catdr,parentDr,MKBTPDRowId)) 
		q:(MKBTPDRowId="")
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
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
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).FormValidatePro("97")
ClassMethod FormValidatePro(prodr As %String) As %String
{
	s flag=0
	
	if ($d(^User.MKBTermProDetailI("ProIdx",prodr))) //属性下是否有属性内容
	{
		s flag=1
	}
	q flag
}

/// Creator:谷雪萍
/// CreatDate:2018-08-21
/// Description：获取日志对象描述——给日志提供的接口
/// Input：key-Json的key值
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetLogObjectDesc(key)
ClassMethod GetLogObjectDesc(key As %String) As %String
{
	s keyDesc=""
	q:key="" ""
	if (key="MKBTPDDesc")
	{
		s keyDesc="中心词"
	}
	elseif(key="MKBTPDPYCode")
	{
		s keyDesc="检索码"
	}
	elseif(key="MKBTPDRemark")
	{
		s keyDesc="备注"
	}
	elseif(key="MKBTPDLastLevel")
	{
		s keyDesc="上级分类"
	}
	else  //扩展属性的id
	{
		s propertyid=$p(key,"||",1)
		s child=$p(key,"||",2)
		if (propertyid'="")&(child'="")
		{
			s keyDesc=$LISTGET($G(^User.MKBTermPropertyD(propertyid,"ChildExtPro",child)),2)
		}
	}
	q keyDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-12-16
/// Description：调引用表接口
/// Input：propertyType-属性类型,id-属性内容表id,updateId-eobj.MKBTPDRowId，修改id,有的话是修改，没有则是新增，oldValue-修改前的值bobj.MKBTPDDesc，newValue-修改后的值eobj.MKBTPDDesc
/// Return：""
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).UseReferenceInfo(propertyType,id,updateId,oldValue,newValue)
ClassMethod UseReferenceInfo(propertyType As %String, id As %String, updateId As %String, oldValue As %String, newValue As %String) As %String
{
	q:(propertyType="")||(id="") 0
	//调索引接口，生成索引数据
	if (propertyType="S")||(propertyType="SS") //引用
	{
		if (updateId'="")  //如果是修改,则获取到引用表的id
		{												
			s MKBRRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("D", id, "T", oldValue)
		}
		else  //如果是新增，则引用表的id为空
		{
			s MKBRRowId=""
		}
		d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "D", id, "T", newValue)
	}
	if (propertyType="P")  //知识应用模板
	{
		if (updateId'="")  //如果是修改，先执行删除原先的引用数据的操作
		{
			d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("D",id)
		}
		
		//生成索引
		s proDetailDesc=newValue  //属性内容
		if (proDetailDesc'="")
		{
			s argsLen=$Length(proDetailDesc,",")
		    for i=1:1:argsLen   
		    {     
		        s descAndType=$p(proDetailDesc,",",i)  //术语属性id&展示类型&起始节点
		        s catRowId=$p(descAndType,"&",1)  //术语库注册id或属性id
		        s treeNode=$p(descAndType,"&",3) //定义起始节点（术语id或属性内容id）
		        s:treeNode="undefined" treeNode=""
		        s isTOrP=$p(descAndType,"&",6)  //术语T或属性P
		        if (treeNode'="")
		        {
			        if (isTOrP="T")  //术语
			        {
		       			d ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "D", id, "T", treeNode)
			        }
			        else  //属性
			        {
				        d ##class(web.DHCBL.MKB.MKBReference).SaveDataById("", "D", id, "D", treeNode)
			        }
		        }
		    }

		}
		
	}
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-12-16
/// Description：诊断模板保存的时候处理引用术语的模板项，先加一个私有属性，然后把该私有属性保存到诊断模板
/// Input：diaTermId-诊断术语id，proDetailDesc-要处理的诊断模板的数据串
/// Return：处理后的诊断模板数据串
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).ChangeDiaTempleteDesc(diaTermId,proDetailDesc)
ClassMethod ChangeDiaTempleteDesc(diaTermId As %String, proDetailDesc As %String) As %String
{
	q:(proDetailDesc="")||(diaTermId="") ""
	s result=""
	s argsLen=$Length(proDetailDesc,",")
    for i=1:1:argsLen   
    {     
        s descAndType=$p(proDetailDesc,",",i)  //第i行模板项数据串
        s newDescAndType=""  
        s catRowId=$p(descAndType,"&",1)  //术语库注册id或属性id
        s treeNode=$p(descAndType,"&",3) //定义起始节点（术语id或属性内容id）
        s:treeNode="undefined" treeNode=""
        s isTOrP=$p(descAndType,"&",6)  //术语T或属性P
        if (isTOrP="T")||(isTOrP="ST")  //如果新增模板项是术语
        {
	        if (catRowId'="")  //如果模板项id不为空&定义节点不为空
	        {
	   			s baseFlag=$LISTGET($G(^User.MKBTermBaseD(catRowId)),10)
				s addProDR=""
	   			if (baseFlag="Part")&(treeNode'="")&(isTOrP="ST") //同步部位
	   			{
		   			s addProDR=$O(^User.MKBTermPropertyI("DescIndex",diaTermId," 部位",0))	   	//部位属性id		
	   			}
	   			elseif (baseFlag="Pathogeny")&(treeNode'="")&(isTOrP="ST") //同步病因
	   			{
		   			s addProDR=$O(^User.MKBTermPropertyI("DescIndex",diaTermId," 病因",0))		//病因属性id
	   			}
	   			else  //如果诊断模板项是其他术语
	   			{
		   			s addProDesc=""
		   			if (treeNode'="")  //如果有定义节点
		   			{
			   			s addProDesc=$listGet($g(^User.MKBTermD(treeNode)),3)  //把定义节点的描述作为属性名称
		   			}
		   			else  //如果没有定义节点
		   			{
			   			//s addProDesc=$listGet($g(^User.MKBTermBaseD(catRowId)),3)  //把术语库的描述作为属性名称
			   			
			   			s addProDesc=$p(descAndType,"&",7)  //属性名
		   				s:addProDesc="" addProDesc=$listGet($g(^User.MKBTermBaseD(catRowId)),3)  //把术语库的描述作为属性名称
		   			}
		   			//s addProDesc=$p(descAndType,"&",7)  //属性名
		   			//s:addProDesc="" addProDesc=$listGet($g(^User.MKBTermBaseD(catRowId)),3)  //把术语库的描述作为属性名称
		   			if (addProDesc'="")
		   			{
			   			s flagd=$d(^User.MKBTermPropertyI("DescIndex",diaTermId," "_$ZCONVERT(addProDesc,"U")))	
			   			if (flagd>0)	
			   			{
				   			//如果已经有这个属性名了，则在该属性名后面+1
				   			//s addProDesc=addProDesc_"1"
				   			//如果已经有这个属性名了，则直接引用该属性
				   			s addProDR=$O(^User.MKBTermPropertyI("DescIndex",diaTermId," "_$ZCONVERT(addProDesc,"U"),0))
			   			}
			   			else
			   			{   					   			   		
				   			s proeobj=##class(web.Entity.MKB.MKBTermProperty).%New()
				   			s proeobj.MKBTPTermDr=diaTermId
				   			s proeobj.MKBTPDesc=addProDesc
				   			s proeobj.MKBTPType="SS"	
				   			s proeobj.MKBTPConfig=catRowId
				   			s proResult=##class(web.DHCBL.MKB.MKBTermProperty).SaveEntity(proeobj,"")
				 
				   			d proeobj.%Close()
				   			s addProDR=$O(^User.MKBTermPropertyI("DescIndex",diaTermId," "_$ZCONVERT(addProDesc,"U"),0)) 
			   			} 
		   			} 			  			
	   			}

	   			//保存属性内容（诊断模板里定义的节点）
				if (addProDR'="")
	   			{
		   			s addProType=$LISTGET($G(^User.MKBTermPropertyD(addProDR)),4)
		   			if (addProType="SS")   //如果是引用起始节点类型的属性，则修改属性内容的值
		   			{
			   			s addDetailId=$o(^User.MKBTermProDetailI("ProIdx",addProDR,0)) //病因属性内容id
		       			s addeobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		       			s addeobj.MKBTPDRowId=addDetailId
		       			s addeobj.MKBTPDDesc=treeNode
						s addeobj.MKBTPDProDR=addProDR
						s addResult=..SaveData(addeobj)
						d addeobj.%Close()
		   			}
					
					s newDescAndType=addProDR_"&"_$p(descAndType,"&",2)_"&&"_$p(descAndType,"&",4,5)_"&P"
	   			}
	        }
   			
        }
        else
        {
	        s newDescAndType=descAndType  
        }
        if (newDescAndType'="")&'(result[newDescAndType)
        {
	        s:result'="" result=result_","
	        s result=result_newDescAndType
        }
        
    }	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-19
/// Description：数据保存测试方法
/// Table：User.MKBKLMappingDetail
/// Input：str-MKBTPDRowId&%MKBTPDProDR&%MKBTPDDesc&%MKBTPDExtend
/// Return:成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveTest()
ClassMethod SaveTest(str)
{
	//s ^TMPGXP=str
	if (str="3@%CSP.CharacterStream")
	{
		q "{success:'false',errorinfo:'录入字符（包含标点）太多,已经达到上限，没法保存，请调整文字！'}"
	}
	s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
	s eobj.MKBTPDRowId=$p(str,"&%",1)
	s eobj.MKBTPDDesc=$p(str,"&%",3)
	s eobj.MKBTPDProDR=$p(str,"&%",2)
	s eobj.MKBTPDExtend=$p(str,"&%",4)
	s result=..SaveData(eobj)
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-5-11
/// Description：用于实现数据校验功能的方法  主要用于常用诊断表达式
/// Input：id-属性值表User.MKBTermProDetail的ID，catdr-属性id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).FormValidateStruct("","","")
ClassMethod FormValidateStruct(id As %String, catdr As %String, extendstr As %String, rowidflag As %String = "") As %String
{
	s result=""
	s struct=$p(extendstr,"[A]",2)
	s flag=""
	s subId=0  //循环扩展属性子表User.MKBTermProperty
	for 
	{
		S subId=$o(^User.MKBTermPropertyD(catdr,"ChildExtPro",subId)) 
		q:subId=""
		q:flag=1
		s MKBTEPRowId=catdr_"||"_subId  //扩展属性表的ID
		s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(catdr,"ChildExtPro",subId)),3)   //扩展属性类型
		//Index ExtendIndex On MKBTEPVExtendDr As Exact;
		s sameflag=0
		s MKBTEPVRowId=""
		for
		{
			s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ExtendIndex",MKBTEPRowId,MKBTEPVRowId))  //扩展属性内容表的id
			q:MKBTEPVRowId=""
			q:flag=1
			s MKBTEPVDetailDr=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),2) //术语属性明细表指针
			if (id'="")
			{
				continue:MKBTEPVDetailDr=id
			}
		    s MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
		    //比较两个串是否一致
		    s sameflag=..ValidateStructStr(struct,MKBTEPVValue)
		    if (sameflag=0)
		    {
			    s flag=1
			    if (rowidflag'="")	//需要返回重复的id
			    {
				    s result=flag_"^"_MKBTEPVDetailDr
			    }
			    else
			    {
				    s result=flag
			    }
		    }
		}
    
	}
			
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-5-11
/// Description：校验两个表达式是否一致
/// Input：oldStructResultID，newStructResultID
/// Return："1"(数据不一致),"0"(数据一致)
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).ValidateStructStr("14590-1294:1741877*1222617,1714814:S128950","14590-1294:1222617*1741877,1714814:S128950,,1714815:S128951")
ClassMethod ValidateStructStr(oldStructResultID, newStructResultID)
{
	s OldTerm=$p(oldStructResultID,"-",1)
	s OldDetail=$p(oldStructResultID,"-",2)
	
	s NewTerm=$p(newStructResultID,"-",1)
	s NewDetail=$p(newStructResultID,"-",2)
	s flagc=0
	k ^TempStruct
	for i1=1:1:$l(OldDetail,",")
	{
		s OldItem=$p(OldDetail,",",i1)
		continue:OldItem=""
		if (OldItem[":")
		{
			s OldEditItemtemp= $p(OldItem,":",1)
			s OldEditContenttemp= $p(OldItem,":",2)
			for i2=1:1:$l(OldEditContenttemp,"*")
			{
				s OlddetailItem=$p(OldEditContenttemp,"*",i2)
				s ^TempStruct("Old",OldEditItemtemp,OlddetailItem)=""
			}
			
		}

	}
	for i3=1:1:$l(NewDetail,",")
	{
		s NewItem=$p(NewDetail,",",i3)
		continue:NewItem=""
		if (NewItem[":")
		{
			s NewEditItemtemp= $p(NewItem,":",1)
			s NewEditContenttemp=$p(NewItem,":",2)
			for i4=1:1:$l(NewEditContenttemp,"*")
			{
				s NewdetailItem=$p(NewEditContenttemp,"*",i4)
				s ^TempStruct("New",NewEditItemtemp,NewdetailItem)=""
			}
		}
	}
	s OldEditItemtemp=""
	for
	{
		s OldEditItemtemp=$o(^TempStruct("Old",OldEditItemtemp))
		q:OldEditItemtemp=""
		q:flagc=1
		s OlddetailItem=""
		for
		{
			s OlddetailItem=$o(^TempStruct("Old",OldEditItemtemp,OlddetailItem))
			q:OlddetailItem=""
			q:flagc=1
			if ('($d(^TempStruct("New",OldEditItemtemp,OlddetailItem))>0))	//存在不同
			{
				s flagc=1
			}
		}
	}
	s NewEditItemtemp=""
	for
	{
		s NewEditItemtemp=$o(^TempStruct("New",NewEditItemtemp))
		q:NewEditItemtemp=""
		q:flagc=1
		s NewdetailItem=""
		for
		{
			s NewdetailItem=$o(^TempStruct("New",NewEditItemtemp,NewdetailItem))
			q:NewdetailItem=""
			q:flagc=1
			if ('($d(^TempStruct("Old",NewEditItemtemp,NewdetailItem))>0))	//存在不同
			{
				s flagc=1
			}
		}
	}
	q flagc
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：保存修改内容
/// Table：User.MKBTermProDetail
/// Input：web.Entity.MKB.MKBTermProDetail 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.MKB.MKBTermProDetail) As %String
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
			s:eobj.MKBTPDRowId'="" eobj.MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(eobj.MKBTPDRowId)),2)
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
		s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),3)	//属性描述
		
		s codeFlagStr=..FormValidate(eobj.MKBTPDRowId,eobj.MKBTPDCode,eobj.MKBTPDProDR,1)  //调用重复验证
		s descFlagStr=..FormValidateDesc(eobj.MKBTPDRowId,eobj.MKBTPDDesc,eobj.MKBTPDProDR,eobj.MKBTPDLastLevel,1)  //调用重复验证
		s codeFlag=$p(codeFlagStr,"^",1)
		s descFlag=$p(descFlagStr,"^",1)
		if ((codeFlag=1)||(descFlag=1))
		{
			if (MKBTPDesc="常用诊断表达式")	//常用诊断表达式需要根据表达式判断重复
			{
				if (codeFlag=1)
				{	
					s RowID=$p(codeFlagStr,"^",2)   //..FormValidate(eobj.MKBTPDRowId,eobj.MKBTPDCode,eobj.MKBTPDProDR,1)调FormValidate返回重复信息+id 
					s result = "{success:'false',errorinfo:'已存在该代码',RowID:'"_RowID_"'}"
				}
				else
				{	
					s RowID=$p(descFlagStr,"^",2)  //..FormValidateDesc(eobj.MKBTPDRowId,eobj.MKBTPDDesc,eobj.MKBTPDProDR,eobj.MKBTPDLastLevel,1)调FormValidateDesc返回重复信息+id }
					s result = "{success:'false',errorinfo:'已存在该描述',RowID:'"_RowID_"'}"
				}
			}
			else
			{
				s result = "{success:'false',errorinfo:'该记录已经存在'}"
			}
		}
		else
		{		
			if (MKBTPDesc="常用诊断表达式")	//常用诊断表达式需要根据表达式判断重复
			{
				s structFlag=..FormValidateStruct(eobj.MKBTPDRowId,eobj.MKBTPDProDR,eobj.MKBTPDExtend,1)
				if (structFlag'="")
				{
					s RowID=$p(structFlag,"^",2)
					q "{success:'false',errorinfo:'已存在该表达式',RowID:'"_RowID_"'}"
				}
			}

			if (eobj.MKBTPDRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.MKBTermProDetail).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBTermProDetail).%OpenId(eobj.MKBTPDRowId)
				s bobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
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
			
			s propertyType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),4)	//属性格式
			
			Ts
			
			if (propertyType="P") 
			{
				//如果属性格式是引用、引用单节点、诊断模板格式需要调引用接口
				s diaTermId=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),6)	//诊断术语id
				s eobj.MKBTPDDesc= ..ChangeDiaTempleteDesc(diaTermId,eobj.MKBTPDDesc)
				if (eobj.MKBTPDDesc="")
				{
					q "{success:'false',errorinfo:'中心词不能为空！'}"
				}
				s obj.MKBTPDDesc =eobj.MKBTPDDesc			
			     
			}
		
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
								s MKBTEPName=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR,"ChildExtPro",child)),2)   //扩展属性描述
								s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR,"ChildExtPro",child)),3)   //扩展属性类型
								if (MKBTEPName="展示名")&(fieldValue="")&(id'="")   //如果没有展示名则根据中心词自动生成
								{
									s fieldValue =$LISTGET($G(^User.MKBTermProDetailD(id)),3)  
								}
								if (MKBTEPName="检索码")&(fieldValue="")&(id'="") //如果没有检索码则根据中心词自动生成
								{
									s fieldValue =$LISTGET($G(^User.MKBTermProDetailD(id)),3)
									s fieldValue=##class(web.DHCBL.BDP.FunLib).GetPYCODE(fieldValue)
								}
								s valId=$o(^User.MKBTermExtendProValI("ValIndex",id,extendDr,0))
								
								//扩展明细表实体类，用于生成日志
								s eobjv = ##class(web.Entity.MKB.MKBTermExtendProVal).%New()
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
										s objv=##class(User.MKBTermExtendProVal).%OpenId(valId)
										s bobjv = ##class(web.Entity.MKB.MKBTermExtendProVal).%New()
										s bobjv.MKBTEPVRowId = valId
										s:objv.MKBTEPVExtendDr'="" bobjv.MKBTEPVExtendDr = objv.MKBTEPVExtendDr.%Id()
										s:objv.MKBTEPVDetailDr'="" bobjv.MKBTEPVDetailDr = objv.MKBTEPVDetailDr.%Id()
										s bobjv.MKBTEPVValue = objv.MKBTEPVValue
										s oldFieldValue=bobjv.MKBTEPVValue
										
									}
									else
									{
										s objv=##class(User.MKBTermExtendProVal).%New()
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
										if (MKBTEPType="S")  //扩展属性类型是引用
										{
											if (valId'="")  //如果是修改扩展属性值,则获取到引用表的id
											{												
												s MKBRRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("D", id, "T", bobjv.MKBTEPVValue)
											}
											else  //如果是新增扩展属性值，则引用表的id为空
											{
												s MKBRRowId=""
											}
											d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "D", id, "T", fieldValue)
										}
										

									}
								}								
								else  //如果没有值
								{
								    
									if (valId'="") //如果之前有值现在没值了则删除
									{
										s objv=##class(User.MKBTermExtendProVal).%OpenId(valId)
										s bobjv = ##class(web.Entity.MKB.MKBTermExtendProVal).%New()
										s bobjv.MKBTEPVRowId = valId
										s:objv.MKBTEPVExtendDr'="" bobjv.MKBTEPVExtendDr = objv.MKBTEPVExtendDr.%Id()
										s:objv.MKBTEPVDetailDr'="" bobjv.MKBTEPVDetailDr = objv.MKBTEPVDetailDr.%Id()
										s bobjv.MKBTEPVValue = objv.MKBTEPVValue
										s oldFieldValue=bobjv.MKBTEPVValue
										s scv=##class(User.MKBTermExtendProVal).%DeleteId(valId)
										If '$$$ISOK(scv)
										{
											s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
										}
										else
										{
											if (MKBTEPType="S")  //扩展属性类型是引用,则删除引用表的数据
											{
												s MKBRRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("D", id, "T", bobjv.MKBTEPVValue)
												d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "D", id, "T", "")
											}
											//保存日志									
											//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermExtendProVal","User.MKBTermExtendProVal","医用知识库知识扩展属性明细表",valId,bobjv.MKBTEPVValue,"D",bobjv)
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
				

			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
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
				
				s propertyType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),4)	//属性格式
				if (propertyType="S")||(propertyType="SS")||(propertyType="P") 
				{
					//如果属性格式是引用、引用单节点、诊断模板格式需要调引用接口
					s oldValue=""
					s:eobj.MKBTPDRowId'="" oldValue=bobj.MKBTPDDesc					
					d ..UseReferenceInfo(propertyType,id,eobj.MKBTPDRowId,oldValue,eobj.MKBTPDDesc)
				}
				//生成全文检索索引
				//d ##class(web.DHCBL.MKB.BDPMKBIndex).AddTermIndex(id,"D")
				
				//调用日志接口

				s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),6)  //术语id
				if (MKBTPTermDr'="")
				{
					if $d(%session)
					{
						d ..SavePersonLiable(MKBTPTermDr)   //保存责任人
					}
					
					s termDesc=$listGet($g(^User.MKBTermD(MKBTPTermDr)),3)  //描述
					s termDesc=##class(web.DHCBL.BDP.FunLib).Util(termDesc)
					s baseid=$listGet($g(^User.MKBTermD(MKBTPTermDr)),4)  //术语所属术语库id
					if (baseid'="")  
					{
					    s baseDesc=$LISTGET($G(^User.MKBTermBaseD(baseid)),3)  //术语所属术语库描述
					    s propertyType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),4)	//属性类型
					    s propertyDesc=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),3)	//属性描述
						
						//处理对象描述
						s logDesc=..GetProDetailDescForLog(eobj.MKBTPDDesc,propertyType)
						//处理上级分类
						s:eobj.MKBTPDLastLevel'="" eobj.MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(eobj.MKBTPDLastLevel)),3)						
						s newJsonStr="MKBTPDDesc:"""_logDesc_""",MKBTPDPYCode:"""_eobj.MKBTPDPYCode_""",MKBTPDRemark:"""_eobj.MKBTPDRemark_""",MKBTPDLastLevel:"""_eobj.MKBTPDLastLevel_""""
						s:newExtendStr'="" newJsonStr=newJsonStr_","_newExtendStr
						s newJsonStr="{"_newJsonStr_"}"
						
						s logDesc=termDesc_"-"_propertyDesc_"-"_logDesc   //属性描述-内容						
					    d:eobj.MKBTPDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermProDetail","User.MKBTermProDetail"_eobj.MKBTPDProDR,baseDesc,id,logDesc,"A",newJsonStr)
					    if (eobj.MKBTPDRowId'="")
					    {
						    //处理原对象描述
							s oldlogDesc=..GetProDetailDescForLog(bobj.MKBTPDDesc,propertyType)	
							//处理上级分类
							s:bobj.MKBTPDLastLevel'="" bobj.MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(bobj.MKBTPDLastLevel)),3)	
																		
						    s oldJsonStr="MKBTPDDesc:"""_oldlogDesc_""",MKBTPDPYCode:"""_bobj.MKBTPDPYCode_""",MKBTPDRemark:"""_bobj.MKBTPDRemark_""",MKBTPDLastLevel:"""_bobj.MKBTPDLastLevel_""""
							s:oldExtendStr'="" oldJsonStr=oldJsonStr_","_oldExtendStr
							s oldJsonStr="{"_oldJsonStr_"}"
							
							//s oldlogDesc=termDesc_"-"_propertyDesc_"-"_oldlogDesc  //属性描述-内容	
						    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermProDetail","User.MKBTermProDetail"_eobj.MKBTPDProDR,baseDesc,eobj.MKBTPDRowId,logDesc,"U",newJsonStr,oldJsonStr)
					    }
					    /*s ^TMP("Text1")=newJsonStr
						s ^TMP("Text2")=oldJsonStr
						s ^TMP("Text3")=baseDesc_"^"_logDesc*/
				    }
				}

			}
		}
				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：获取修改时的记录
/// Input：id-属性内容表User.MKBTermProDetail的id,property-属性id
/// Return：Json格式的 字段和值 信息
/// Other: d ##class(web.DHCBL.MKB.MKBTermProDetail).NewOpenData(id,property)
ClassMethod NewOpenData(id As %String, property As %String) As %String
{
	s jsonstr=""	
	s MKBTPDRowId=id
	s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),2)
	s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
	s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
	s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
	s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),4)
	s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
	s MKBTPDRemark= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
	s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9) 
	s MKBTPDPYCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),10)
	s MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
	
	s ExtendStr=""   //知识点扩展属性子表的字段
	s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(property)),3)	//属性描述
	s subId=""  //循环扩展属性子表User.MKBTermProperty
	for 
	{
		S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) 
		q:subId=""
		s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
        if (MKBTPDesc="常用诊断表达式")
        {
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
        }
        else
        {
			s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
			s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
			s MKBTEPVValue=""
	        s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
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
/// CreatDate:2018-03-27
/// Description：获取修改时的记录
/// Input：id-属性内容表User.MKBTermProDetail的id
/// Return：Json格式的 字段和值 信息
/// Other: d ##class(web.DHCBL.MKB.MKBTermProDetail).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
	s pobj = ##class(User.MKBTermProDetail).%OpenId(id)
	s eobj.MKBTPDRowId = id
	s eobj.MKBTPDCode = pobj.MKBTPDCode
	s eobj.MKBTPDDesc =  ##class(web.DHCBL.BDP.FunLib).EvalJSONB(pobj.MKBTPDDesc)
	s eobj.MKBTPDDesc =  ##class(web.BDP.util.String).Replace(eobj.MKBTPDDesc,"<br/>","\n")
	if $IsObject(pobj.MKBTPDProDR){
		s eobj.MKBTPDProDR = pobj.MKBTPDProDR.%Id()
	}else{
		s eobj.MKBTPDProDR =""
	}
	if $IsObject(pobj.MKBTPDLastLevel){
		s eobj.MKBTPDLastLevel = pobj.MKBTPDLastLevel.%Id()
	}else{
		s eobj.MKBTPDLastLevel =""
	}
	s eobj.MKBTPDLevel = pobj.MKBTPDLevel
	s eobj.MKBTPDActiveFlag=pobj.MKBTPDActiveFlag
	s:pobj.MKBTPDActiveFlag="Y" eobj.MKBTPDActiveFlag="true"
	s eobj.MKBTPDRemark =  ##class(web.DHCBL.BDP.FunLib).EvalJSONB(pobj.MKBTPDRemark)
    s eobj.MKBTPDRemark = ##class(web.BDP.util.String).Replace(eobj.MKBTPDRemark,"<br/>","\n")
    s eobj.MKBTPDSequence=pobj.MKBTPDSequence
    s eobj.MKBTPDPYCode=pobj.MKBTPDPYCode
    s eobj.MKBTPDPYCode =  ##class(web.DHCBL.BDP.FunLib).EvalJSONB(pobj.MKBTPDPYCode)
	s eobj.MKBTPDPYCode =  ##class(web.BDP.util.String).Replace(eobj.MKBTPDPYCode,"<br/>","\n")
	//s str = eobj.JsonS()	
	s str="{""MKBTPDRowId"":"""_eobj.MKBTPDRowId_""",""MKBTPDCode"":"""_eobj.MKBTPDCode_""",""MKBTPDDesc"":"""_eobj.MKBTPDDesc_""",""MKBTPDProDR"":"""_eobj.MKBTPDProDR_""",""MKBTPDLastLevel"":"""_eobj.MKBTPDLastLevel_""",""MKBTPDLevel"":"""_eobj.MKBTPDLevel_""",""MKBTPDActiveFlag"":"""_eobj.MKBTPDActiveFlag_""",""MKBTPDRemark"":"""_eobj.MKBTPDRemark_""",""MKBTPDSequence"":"""_eobj.MKBTPDSequence_""",""MKBTPDPYCode"":"""_eobj.MKBTPDPYCode_"""}"
	q str
}

/// Creator:谷雪萍
/// CreatDate:2018-05-18
/// Description:删除限制
/// Input：id-诊断rowid
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetRefFlag("2")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""	
	//树形术语判断是否有子菜单 
    s myChildFlag=$d(^User.MKBTermProDetailI("ParIndex",id))
    if (myChildFlag){
	    s myInfo=myInfo_"有子节点"   
    }
    
    //引用判断
    s referInfo=##class(web.DHCBL.MKB.MKBReference).DeleteData("D", id)
	if (referInfo'="")
	{ 
		s:myInfo'="" myInfo=myInfo_","_referInfo
		s:myInfo="" myInfo=referInfo
	}
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^"_myInfo
 	q return
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description:根据id删除
/// Table:User.MKBTermProDetail
/// Input：id-属性内容表User.MKBTermProDetail的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s oldExtendStr=""  //扩展属性明细JSON串
	s logJsonStr=""   //日志JSON串
	s re=##class(web.DHCBL.MKB.MKBTermProDetail).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0)  //未被引用
	{
		s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s pobj = ##class(User.MKBTermProDetail).%OpenId(id)
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
		//d ##class(web.DHCBL.MKB.BDPMKBIndex).DeleteTermIndex(id,"D")   //调删除全文索引数据接口
		s sc=##class(User.MKBTermProDetail).%DeleteId(id)
		if $$$ISOK(sc)
		{
			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermProDetail","User.MKBTermProDetail"_eobj.MKBTPDProDR,"医用知识库知识属性明细表",id,eobj.MKBTPDDesc,"D",eobj)
			
			//d eobj.%Close()
			//删除知识点扩展属性值表 MKB_TermExtendProVal
			s valId=0
			for
			{
				s valId=$o(^User.MKBTermExtendProValI("DetailIndex",id,valId))  //术语明细表id
				q:valId=""
				//扩展明细表实体类，用于生成日志
				s eobjv = ##class(web.Entity.MKB.MKBTermExtendProVal).%New()
				s eobjv.MKBTEPVRowId = valId
				s eobjv.MKBTEPVExtendDr= $LISTGET($G(^User.MKBTermExtendProValD(valId)),3) 
				s eobjv.MKBTEPVDetailDr= $LISTGET($G(^User.MKBTermExtendProValD(valId)),2) 
				s eobjv.MKBTEPVValue = $LISTGET($G(^User.MKBTermExtendProValD(valId)),4)
				 
				//处理扩展属性的值
				s fieldValue=eobjv.MKBTEPVValue
				if (eobjv.MKBTEPVExtendDr'="")
				{
					s child=$p(eobjv.MKBTEPVExtendDr,"||",2)  //扩展属性的child
					s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR,"ChildExtPro",child)),3)
					s fieldValue=..GetExtendProValForLog(fieldValue,MKBTEPType)
					s:oldExtendStr'="" oldExtendStr=oldExtendStr_","_eobjv.MKBTEPVExtendDr_":"""_fieldValue_""""
					s:oldExtendStr="" oldExtendStr=eobjv.MKBTEPVExtendDr_":"""_fieldValue_""""
				}
				
				s scv=##class(User.MKBTermExtendProVal).%DeleteId(valId)
				if '$$$ISOK(scv)
				{
					s result= "{success:'false',info:'"_$zconvert(scv,"O","JS")_"'}"  //返回错误信息
					
				}
				else
				{
					//保存日志
					//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermExtendProVal","User.MKBTermExtendProVal","医用知识库知识扩展属性明细表",valId,eobjv.MKBTEPVValue,"D",eobjv)
					d eobjv.%Close()
				}
				
			}
						
		}
		else
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
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
			d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("D",id)  //删除引用表数据
			//调用日志接口
			s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),6)  //术语id
			if (MKBTPTermDr'="")
			{
				if $d(%session)
				{
					d ..SavePersonLiable(MKBTPTermDr)  //保存责任人
				}
				s termDesc=$listGet($g(^User.MKBTermD(MKBTPTermDr)),3)  //描述
				s termDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(termDesc) 
				s baseid=$listGet($g(^User.MKBTermD(MKBTPTermDr)),4)  //术语所属术语库id
				if (baseid'="")  
				{
				    s baseDesc=$LISTGET($G(^User.MKBTermBaseD(baseid)),3)  //术语所属术语库描述
				    s propertyType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),4)	//属性类型
				    s propertyDesc=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),3)	//属性描述
					
					//处理对象描述
					s logDesc=..GetProDetailDescForLog(eobj.MKBTPDDesc,propertyType)
					//处理上级分类
					s:eobj.MKBTPDLastLevel'="" eobj.MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(eobj.MKBTPDLastLevel)),3)						
					s logJsonStr="MKBTPDDesc:"""_logDesc_""",MKBTPDPYCode:"""_eobj.MKBTPDPYCode_""",MKBTPDRemark:"""_eobj.MKBTPDRemark_""",MKBTPDLastLevel:"""_eobj.MKBTPDLastLevel_""""
					s:oldExtendStr'="" logJsonStr=logJsonStr_","_oldExtendStr
					s logJsonStr="{"_logJsonStr_"}"
					
					s logDesc=termDesc_"-"_propertyDesc_"-"_logDesc   //属性描述-内容						

					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermProDetail","User.MKBTermProDetail"_eobj.MKBTPDProDR,baseDesc,id,logDesc,"D",logJsonStr)
				    //s ^TMP("TextD1")=logJsonStr
					//s ^TMP("TextD2")=baseDesc_"^"_logDesc
			    }
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
/// CreatDate:2019-07-04
/// Description:根据id删除数据及被引用数据
/// Table:User.MKBTermProDetail
/// Input：id-属性内容表User.MKBTermProDetail的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteDataAndRefer("2")
ClassMethod DeleteDataAndRefer(id As %String) As %String
{
	q:id="" "{success:'false',info:'没有获取到ID，删除失败'}"  //返回错误信息
	 //删除引用
	s result=""
    s result=##class(web.DHCBL.MKB.MKBReference).DeleteAll("D", id)
    if (result="")  //删除成功
    {
	    s result=..DeleteData(id)
    }
   	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description:根据id删除属性内容，不加删除判断
/// Table:User.MKBTermProDetail
/// Input：id-属性内容表User.MKBTermProDetail的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteDataExpectRef("2")
ClassMethod DeleteDataExpectRef(id As %String) As %String
{
	s result=""
	s oldExtendStr=""  //扩展属性明细JSON串
	s logJsonStr=""   //日志JSON串
	
	s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
	s pobj = ##class(User.MKBTermProDetail).%OpenId(id)
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
	s sc=##class(User.MKBTermProDetail).%DeleteId(id)
	if $$$ISOK(sc)
	{
		//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermProDetail","User.MKBTermProDetail"_eobj.MKBTPDProDR,"医用知识库知识属性明细表",id,eobj.MKBTPDDesc,"D",eobj)
		
		//d eobj.%Close()
		//删除知识点扩展属性值表 MKB_TermExtendProVal
		s valId=0
		for
		{
			s valId=$o(^User.MKBTermExtendProValI("DetailIndex",id,valId))  //术语明细表id
			q:valId=""
			//扩展明细表实体类，用于生成日志
			/*s eobjv = ##class(web.Entity.MKB.MKBTermExtendProVal).%New()
			s eobjv.MKBTEPVRowId = valId
			s eobjv.MKBTEPVExtendDr= $LISTGET($G(^User.MKBTermExtendProValD(valId)),3) 
			s eobjv.MKBTEPVDetailDr= $LISTGET($G(^User.MKBTermExtendProValD(valId)),2) 
			s eobjv.MKBTEPVValue = $LISTGET($G(^User.MKBTermExtendProValD(valId)),4) 
			
			//处理扩展属性的值
			s fieldValue=eobjv.MKBTEPVValue
			if (eobjv.MKBTEPVExtendDr'="")
			{
				s child=$p(eobjv.MKBTEPVExtendDr,"||",2)  //扩展属性的child
				s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR,"ChildExtPro",child)),3)
				s fieldValue=..GetExtendProValForLog(fieldValue,MKBTEPType)
				s:oldExtendStr'="" oldExtendStr=oldExtendStr_","_eobjv.MKBTEPVExtendDr_":"""_fieldValue_""""
				s:oldExtendStr="" oldExtendStr=eobjv.MKBTEPVExtendDr_":"""_fieldValue_""""
			}*/
			
			s scv=##class(User.MKBTermExtendProVal).%DeleteId(valId)
			if '$$$ISOK(scv)
			{
				s result= "{success:'false',info:'"_$zconvert(scv,"O","JS")_"'}"  //返回错误信息
				
			}
			else
			{
				//保存日志
				//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_TermExtendProVal","User.MKBTermExtendProVal","医用知识库知识扩展属性明细表",valId,eobjv.MKBTEPVValue,"D",eobjv)
				//d eobjv.%Close()
			}
			
		}
		
	}
	else
	{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
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
	
		d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("D",id)   //删除引用数据	
		
		//调用日志接口
		/*s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),6)  //术语id
		if (MKBTPTermDr'="")
		{
			s termDesc=$listGet($g(^User.MKBTermD(MKBTPTermDr)),3)  //描述
			s termDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(termDesc) 
			s baseid=$listGet($g(^User.MKBTermD(MKBTPTermDr)),4)  //术语所属术语库id
			if (baseid'="")  
			{
			    s baseDesc=$LISTGET($G(^User.MKBTermBaseD(baseid)),3)  //术语所属术语库描述
			    s propertyType=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),4)	//属性类型
			    s propertyDesc=$LISTGET($G(^User.MKBTermPropertyD(eobj.MKBTPDProDR)),3)	//属性描述
				
				//处理对象描述
				s logDesc=..GetProDetailDescForLog(eobj.MKBTPDDesc,propertyType)
				//处理上级分类
				s:eobj.MKBTPDLastLevel'="" eobj.MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(eobj.MKBTPDLastLevel)),3)						
				s logJsonStr="MKBTPDDesc:"""_logDesc_""",MKBTPDPYCode:"""_eobj.MKBTPDPYCode_""",MKBTPDRemark:"""_eobj.MKBTPDRemark_""",MKBTPDLastLevel:"""_eobj.MKBTPDLastLevel_""""
				s:oldExtendStr'="" logJsonStr=logJsonStr_","_oldExtendStr
				s logJsonStr="{"_logJsonStr_"}"
				
				s logDesc=termDesc_"-"_propertyDesc_"-"_logDesc   //属性描述-内容						

				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_TermProDetail","User.MKBTermProDetail"_eobj.MKBTPDProDR,baseDesc,id,logDesc,"D",logJsonStr)
			    //s ^TMP("TextD1")=logJsonStr
				//s ^TMP("TextD2")=baseDesc_"^"_logDesc
		    }
		}*/
	}

    q result
}

/// Creator:谷雪萍
/// CreatDate:2018-05-08
/// Description:引用-列表型术语内容中 删除全部
/// Input:property-属性ID
/// return：成功或失败的信息
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteAllSelTerm(property)
ClassMethod DeleteAllSelTerm(property As %String) As %String
{
	q:(property="") "{success:'false',info:'未选中属性'}"
	
	s result=""
	s flag=""
	
	TS
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:((MKBTPDRowId="") ||(flag="N"))

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
/// Description：上移下移 调整列表型属性的内容 的顺序
/// Return：成功返回'true'；失败返回'false'
/// Input：checkId, changeId  互换顺序的两个ID
/// Other: d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveListPropertyOrder()
ClassMethod SaveListPropertyOrder(checkId, changeId) As %String
{
	s $zt="ERROE"
	s result=""

	if ((checkId'="")&(changeId'=""))
	{
		
		//先保存选中行的顺序
		s obj1=##class(User.MKBTermProDetail).%OpenId(checkId)
		s obj2=##class(User.MKBTermProDetail).%OpenId(changeId)
		s OrderNum1=obj1.MKBTPDSequence
		s OrderNum2=obj2.MKBTPDSequence
		s obj1.MKBTPDSequence=OrderNum2
		s obj2.MKBTPDSequence=OrderNum1

		TS
		s sc1=obj1.%Save()
		s sc2=obj2.%Save()
		d obj1.%Close()
		d obj2.%Close()
		s sc=sc1&sc2
		If $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true'}"  
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}	 
	else
	{
		s result = "{success:'true'}"
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：谷雪萍
/// CreatDate:2018-03-27
/// Description：拖拽 调整列表型属性的内容 的顺序
/// Return：成功返回'true'；失败返回'false'
/// Input：order  拖拽后按顺序排列的ID串,minSeq-最小的顺序
/// Other: d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveDragListOrder(order)
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
		s obj=##class(User.MKBTermProDetail).%OpenId(rowid)		
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
/// Other: w ##class(web.DHCBL.MKB.MKBTermProDetail).GetLastOrder(1)
ClassMethod GetLastOrder(property As %String) As %String
{
	q:property="" ""
	s LastOrder=$o(^User.MKBTermProDetailI("SeqIndex",property,""),-1)
	s LastOrder=$g(LastOrder)+1
	q LastOrder
}

/// Creator:谷雪萍
/// CreatDate:2018-05-14
/// Input：id 节点Id
/// Return：父节点
/// Description:新增时，根据获取上级节点，来给上级节点赋值
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTreeParent("24")
ClassMethod GetTreeParent(id As %String) As %String
{
	q:id="" ""
	s parent=$LISTGET($G(^User.MKBTermProDetailD(id)),4)
	q parent
}

/// Creator:谷雪萍
/// CreatDate:2018-03-30
/// Input：parentId 上级节点Id
/// Return：级别
/// Description:新增时，根据获取上级节点，来给级别赋值
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTreeLevel("24")
ClassMethod GetTreeLevel(parentId As %String) As %String
{
	
	s count=1
	if (parentId'="")
	{
		s parent=parentId
		for
		{
			s parent=$LISTGET($G(^User.MKBTermProDetailD(parent)),4)
			q:parent=""
			s count=count+1
		}
		s count=count+1
	}
	q count
}

/// Creator：谷雪萍
/// CreatDate:2018-03-30
/// Description:代码自动生成：属性代码+00001 代码最大值加1
/// Input：property-属性ID
/// Return：成功返回自动生成的Code
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetLastCode(1)
ClassMethod GetLastCode(property) As %String
{
	s mycode=""
  	//代码自动生成 属性代码+00001 开始
	s StartCode=$LISTGET($G(^User.MKBTermPropertyD(property)),2)_"-"		
	s StartCodeLen=$Length(StartCode)
	s CodeLen=StartCodeLen+5
	s Code="", preCode=""    //寻找符合规则的最大的代码
	if ($d(^User.MKBTermProDetailI("CodeIndex",property)))
	{
		for {
			s Code=$o(^User.MKBTermProDetailI("CodeIndex",property,Code),-1)
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
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTermProDetail
/// Input：LastLevel-父节点,property-属性id
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(LastLevel,property)
ClassMethod GetChildOrderedIDStr(LastLevel As %String, property As %String) As %String
{
	if (LastLevel="") s LastLevel=-100000000000000	
	s IDStr=""
	s childStr=""
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq,myRowID)) q:(myRowID="")
		
			s childStr=..GetChildOrderedIDStr(myRowID, property)
			if childStr'="" s childStr=myRowID_"^"_childStr
			if childStr="" s childStr=myRowID
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// Creator：谷雪萍
/// CreatDate:2018-03-30
/// Description：获取树形属性内容数据
/// Table：User.MKBTermProDetail
/// Input：id-父节点,property-属性id
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetJsonList("","")
ClassMethod GetJsonList(id As %String, property As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s childStr=""
	s count=0
	w "["
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			//continue:$LISTGET($G(^User.MKBTermProDetailD(myRowID)),6)'="Y"
			s count=count+1
			s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
			s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
			if count>1 w ","
			s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),2)
			s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
			s MKBTPDRemark=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
			s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),9)
			s MKBTPDPYCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),10)
			s MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
			s MKBTPDLastLevelF=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),4)
			s MKBTPDLastLevel=""
			if MKBTPDLastLevelF'="" 
			{
				s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDLastLevelF)),3)
				s MKBTPDLastLevel=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDLastLevel)
			}
			s MKBTPDLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),5)
			
			w "{""id"":"""_myRowID_""""
			w ",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""",""MKBTPDLastLevelF"":"""_MKBTPDLastLevelF_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""""
			s ExtendStr=""   //知识点扩展属性子表的字段
			s subId=0  //循环扩展属性子表User.MKBTermProperty
			for 
			{
				S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
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
			if $d(^User.MKBTermProDetailI("ProParIndex",property,myRowID))
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
/// Table：User.MKBTermProDetail
/// Input：id-属性内容id,property-属性id
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTreeJsonListById("","")
ClassMethod GetTreeJsonListById(id As %String, property As %String) As %String
{
	s myRowID=id
	s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
	s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
	s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),2)
	s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
	s MKBTPDRemark=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
	s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),9)
	s MKBTPDPYCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),10)
	s MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDPYCode)
	s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),4)
	if (MKBTPDLastLevel'="")
	{
		 s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDLastLevel)),3)
		 s MKBTPDLastLevel=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDLastLevel)
	}
	
	s MKBTPDLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),5)
	w "["	
	w "{""id"":"""_myRowID_""""
	w ",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""",""MKBTPDPYCode"":"""_MKBTPDPYCode_""""
	s ExtendStr=""   //知识点扩展属性子表的字段
	s subId=0  //循环扩展属性子表User.MKBTermProperty
	for 
	{
		S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
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
/// Table：User.MKBTermProDetail
/// Input：property-属性id，id-父节点，rowid-id  
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetJsonDataForCmb("",)
ClassMethod GetJsonDataForCmb(id As %String, property As %String, rowid As %String) As %String
{
	
	//如果rowid为空则只输出一条
	if (rowid'=""){
		s Caption=$LISTGET($G(^User.MKBTermProDetailD(rowid)),3)
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
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			s Caption=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
			w ",""state"":""open"""
			//s childStr=..GetChildOrderedIDStr(myRowID,property)
			//if childStr'=""
			if $d(^User.MKBTermProDetailI("ProParIndex",property,myRowID))
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
/// Table：User.MKBTerm
/// Input：base-术语库注册id，id-父节点，rowid-id 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetJsonDataForTermCmb("31","","")
ClassMethod GetJsonDataForTermCmb(base As %String, id As %String, rowid As %String) As %String
{
	//如果rowid为空则只输出一条
	if (rowid'=""){
		s Caption=$LISTGET($G(^User.MKBTermD(rowid)),3)
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
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
			w ",""state"":""open"""
			//s childStr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,myRowID)
			//if childStr'=""
			if $d(^User.MKBTermI("ParentIndex",base,myRowID))
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
		
	s obj=##class(User.MKBTermProDetail).%OpenId(id)
		
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
			s obj=##class(User.MKBTermProDetail).%OpenId(rowid)
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
/// Table：User.MKBTermProDetail
/// Input： property-属性id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveSearchWord("20797")
ClassMethod SaveSearchWord(property) As %String
{
	s result=""
	q:property="" "{success:'false',errorinfo:'没有获取到属性！'}"
	
	s showLength=$d(^User.MKBTermExtendProI("NameIndex",property," 展示名"))
	if (showLength)
	{
		s showChildsub=$o(^User.MKBTermExtendProI("NameIndex",property," 展示名",0))
		s showCatId=property_"||"_showChildsub
	}

	TS
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 

		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		s MKBTPDPYCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),10)
		continue:MKBTPDPYCode'=""
		s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
		s showValue=""
		if (showLength)  //如果有展示名，检索码根据展示名生成
		{
			s showValId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,showCatId,0))  //扩展属性内容表的id		
	        s:showValId'="" showValue=$LISTGET($G(^User.MKBTermExtendProValD(showValId)),4) //扩展属性内容的值
		}
		s:showValue="" showValue=MKBTPDDesc     //如果展示名为空，则等于主列名
        if (showValue'="")
        {
	        s showValue=$ZCONVERT(showValue,"U")
	        s showValue=..Filter(showValue)
        	s PYValue= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(showValue)
			s obj=##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
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
/// return:User.MKBTermProDetail的ID_"[A]"_属性内容
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTextInfo("3")
ClassMethod GetTextInfo(property As %String) As %String
{
	q:property="" ""
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
	s MKBTPDDesc=""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
	s MKBTPDDesc = ##class(websys.Translation).Get("diagnosentry.v8.csp",MKBTPDDesc) //多语言改造
	q MKBTPDRowId_"[A]"_MKBTPDDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：获取属性内容描述——引用属性类型属性内容维护模块——定义节点的显示
/// Input: id——属性内容id
/// return:属性内容描述
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc("3")
ClassMethod GetDesc(id As %String) As %String
{
	q:id="" ""
	s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(id)),3)
	q MKBTPDDesc
}

/// Description：诊断模板里 有诊断展示名标识的属性 展示格式只能设置为下拉框
/// Input：cat-属性ID
/// Return:属性标识
/// Date:2018-04-03
/// Creator:谷雪萍
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetPropertyFlag(cat)
ClassMethod GetPropertyFlag(property As %String) As %String
{
    s MKBTPFlag=""
    if (property'="")
    {
        s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(property)),8)  //标识
    }
    q MKBTPFlag
}

/// Creator:谷雪萍
/// CreatDate:2018-04-03
/// Description：获取诊断常用名
/// Input: property-属性id
/// return:诊断展示名、如果常用名为空则返回诊断描述
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermCom("4")
ClassMethod GetTermCom(property As %String) As %String
{
	q:property="" ""
	s termCom=""
	s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(property)),6)  //术语指针
	if (MKBTPTermDr'="")
	{
		s termCom=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(MKBTPTermDr)
	}
	q termCom
}

/// Creator：谷雪萍
/// CreatDate: 2018-04-02
/// Description：引用属性类型属性内容维护模块-获取已选属性列表
/// Table：User.MKBTermProperty
/// Input：rowid, code, desc
/// return: id：属性：展示格式：属性格式：顺序：定义节点
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetSelPropertyList","37")
Query GetSelPropertyList(property As %String) As %Query(ROWSPEC = "MKBTPRowId,MKBTPDesc,MKBTPShowType,MKBTPType,MKBTPOrder,MKBTPTreeNode,MKBTPChoice,MKBTPRequired,MKBTPTOrP")
{
}

ClassMethod GetSelPropertyListExecute(ByRef qHandle As %Binary, property As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
  
    if (property'="")
    {
	    s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
		s MKBTPDDesc=""
		s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		if (MKBTPDDesc'="")
		{
	        s argsLen=$Length(MKBTPDDesc,",")
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
		          s MKBTPDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),3) //术语库描述 
		          s MKBTPType=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),4)  //术语库格式
	          }
	          else   //属性
	          {
	          	  s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3) //属性描述 
	          	  s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)  //属性格式
	          }
	          
	          d OutputRowSelPro
	        }
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowSelPro
    set Data=$lb(MKBTPRowId,MKBTPDesc,MKBTPShowType,MKBTPType,MKBTPOrder,MKBTPTreeNode,MKBTPChoice,MKBTPRequired,MKBTPTOrP)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSelPropertyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelPropertyListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSelPropertyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelPropertyListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
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

/// Creator：谷雪萍
/// CreatDate: 2018-04-02
/// Description：引用属性类型属性内容维护模块-获取未选属性列表
/// Table：User.MKBTermProperty
/// Input：property-属性id, desc-术语或属性检索,type-类型 T：术语；P：属性
/// return: id：属性：属性格式：类型
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetUnSelProList","4","")
Query GetUnSelProList(property As %String, desc As %String, textType As %String) As %Query(ROWSPEC = "MKBTPRowId:%String,MKBTPDesc:%String,MKBTPType:%String,MKBTPTOrP:%String")
{
}

ClassMethod GetUnSelProListExecute(ByRef qHandle As %Binary, property As %String, desc As %String, textType As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
	
	if (textType="T")  //如果是选术语
	{
		  s:desc'="" desc=$ZCONVERT(desc,"U")
		  s MKBTPRowId=0
		  for
		  {  
			  s MKBTPRowId=$o(^User.MKBTermBaseD(MKBTPRowId)) 
			  q:MKBTPRowId=""  

			  s MKBTPDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),3)
			  s MKBTPType=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),4)
			  s MKBTBPYCode=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),7)
			  s MKBTPTOrP="T"

			  if (($ZCONVERT(MKBTPDesc,"U")[desc)||($ZCONVERT(MKBTBPYCode,"U")[desc))
			  {
			  	d OutputRowUnPro
			  }
		  }
		
	}
	else   //如果是选属性
	{
	    if (property'="")
	    {
		    s termdr=$LISTGET($G(^User.MKBTermPropertyD(property)),6)  //术语id
		    if (termdr'="")
		    {
			    s:desc'="" desc=$ZCONVERT(desc,"U")
			    s MKBTPRowId=0
				for  
				{	
					s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
					//continue:MKBTPRowId=property
					s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
					s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
					s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
					s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),8)
					s MKBTPTOrP="P"
					
					continue:(MKBTPType="F")||(MKBTPType="P")||(MKBTPType="SD")||(MKBTPType="M")
					
					s PINYIN=""
					s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDescU)
					i ((MKBTPDescU[desc)||(PINYIN[desc))   //条件
					{
						d OutputRowUnPro
					}		
				}

		    }
	    }
	}

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUnPro
    set Data=$lb(MKBTPRowId,MKBTPDesc,MKBTPType,MKBTPTOrP)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelProListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelProListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelProListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelProListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
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
/// CreatDate:2018-04-02
/// Description:判断诊断模板里的引用术语型属性是列表型还是树形
/// Input:property- 属性ID
/// return：L/T或""
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetProListOrTree()
ClassMethod GetProListOrTree(property As %String) As %String
{
    q:property="" ""
    s MKBTBType=""
    s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
    s:DATSOU'="" MKBTBType=$LISTGET($G(^User.MKBTermBaseD(DATSOU)),4)  //术语类型
    q MKBTBType
}

/// Creator:谷雪萍
/// CreatDate:2018-04-04
/// Description:获取引用术语格式的属性配置项信息
/// Input:property- 属性ID
/// return：属性配置项：引用的术语库注册表的id^L/T
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetProConfigInfo(property)
ClassMethod GetProConfigInfo(property As %String) As %String
{
    q:property="" ""
    s MKBTBType=""
    s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
    s:DATSOU'="" MKBTBType=$LISTGET($G(^User.MKBTermBaseD(DATSOU)),4)  //术语类型
    q DATSOU_"^"_MKBTBType
}

/// Creator:谷雪萍
/// CreatDate:2018-12-21
/// Description：引用起始节点格式的属性内容展示区数据显示，如果有属性内容，则内容区域显示该节点及以下的节点
/// Input: property:属性id
/// return:引用术语的- 起始节点父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSourseSingleTermJson(property)
ClassMethod GetSourseSingleTermJson(property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项

	q:(DATSOU="") "[]"

	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))  //属性内容id
	//q:(MKBTPDRowId="") "[]"
	s definedNode=""
	s:MKBTPDRowId'="" definedNode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容中心词
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w ..GetSourseJsonDataForCmb(DATSOU,definedNode,"")
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]"  //判断是否显示封闭数据
		s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
		s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
		s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码
		if (MKBTPYCode'="")
		{
			s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
			s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
		}
		
		w "["
		w "{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_MKBTPYCode_"</span>"""
		w ",""state"":""open"""
		
		if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
		{
			
			w ",""children"":"
			w ..GetSourseJsonDataForCmb(DATSOU,definedNode,"")
			//d ..GetTreeTermJsonForDoc(definedNode,DATSOU)
		}
		else
		{
			w ",""checked"":false"		
		
		}

		w "}"
		w "]"
	}

	
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-05-08
/// Description：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Input: property:属性id
/// return:引用术语的- 起始节点父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSourseTreeTermJson("","7")
ClassMethod GetSourseTreeTermJson(property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"

	s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)	
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
	
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w ..GetSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]" //判断是否显示封闭数据		
		s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
		s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
		s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码
		if (MKBTPYCode'="")
		{
			s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
			s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
		}
		
		w "["
		w "{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_MKBTPYCode_"</span>"""
		w ",""state"":""open"""
		
		s strId=","_definedNode_","
		
		if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
		{
			w ",""children"":"
			w ..GetSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
		}
		else
		{
			if (selItemIds[strId){
				w ",""checked"":true"
			}
			else{
				w ",""checked"":false"
			}
		}
		w "}"
		w "]"
		
	}
	
	q ""
}

/// Creator：谷雪萍
/// CreatDate:2018-05-08
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.BDPItemCategory
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSourseJsonDataForCmb("31","")
ClassMethod GetSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	w "["
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
			s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码
			if (MKBTPYCode'="")
			{
				s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
			}
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_Caption_"<span class='hidecls'>"_MKBTPYCode_"</span>"""
			w ",""state"":""open"""
			
			s strId=","_myRowID_","
			
			//s childStr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,myRowID)
			//if childStr'=""
			if $d(^User.MKBTermI("ParentIndex",base,myRowID))
			{
				w ",""children"":"
				w ..GetSourseJsonDataForCmb(base,myRowID,selItemIds)	
			}
			else
			{
				if (selItemIds[strId){
					w ",""checked"":true"
				}
				else{
					w ",""checked"":false"
				}
			
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-05-07
/// Description:获取引用-树形术语-属性内容的所有术语id串
/// Input:property- 属性ID
/// return：引用术语的id串
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)
ClassMethod GetSelTermIdsStr(property As %String) As %String
{
	q:property="" ""
	s termIds=""
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 

		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)

		s:termIds'="" termIds=termIds_","_MKBTPDDesc
		s:termIds="" termIds=MKBTPDDesc
		
	}
	q termIds
}

/// Creator:谷雪萍
/// CreatDate:2018-05-07
/// Description:引用-树形术语-属性内容中 保存已选术语到属性内容表
/// Input:property- 属性ID,addTermIds-要添加的术语id串,deleteTermIds-要删除的术语id串
/// return：成功或失败
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveSelectTermIds(property,termids)
ClassMethod SaveSelectTermIds(property As %String, addTermIds As %String, deleteTermIds As %String) As %String
{
	q:(property="") "{success:'false',errorinfo:'未选中属性'}"

	
	s result=""
	s flag=""
	Ts
	
	//添加术语
	if (addTermIds'="")
	{
		s addLen=$Length(addTermIds,",")
		for i=1:1:addLen   
		{
		      
		  	s termId=$p(addTermIds,",",i)  	
			s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDRowId = ""
			s eobj.MKBTPDDesc = termId
			s eobj.MKBTPDProDR = property
			s res=..SaveData(eobj)
			d eobj.%Close()
			if res["false"
			{
				s flag="N"
				q
			}
		}
	}
	
	//删除术语 1,2,3
	if (deleteTermIds'="")
	{
		s deleteIdStr=","_deleteTermIds_","   // ,1,2,3,
		s MKBTPDRowId=0
		for    //遍历该属性的内容
		{	
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:(MKBTPDRowId="")||(flag="N")
			s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //描述-存术语id
			 
			s termIdStr=","_MKBTPDDesc_","   //,1, 		
			if (deleteIdStr[termIdStr)    //要删除的术语串里包含该术语
			{
				s res=..DeleteDataExpectRef(MKBTPDRowId)
				if res["false"
				{
					s flag="N"

				}
			
			}
			
		}
	}
	if (flag="N")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"  
	}
	else
	{
		TC
		s result = "{success:'true',info:'保存成功'}" 
	}
					
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-05-07
/// Description:根据选择的术语id 得到属性内容表的id
/// Input:property-属性ID，termid-术语id
/// return：MKBTPDRowId- 属性内容表的ID
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDetailIdBySelTerm(property,termid)
ClassMethod GetDetailIdBySelTerm(property As %String, termid As %String) As %String
{
	q:((property="")||(termid="")) ""
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 

		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		q:termid=MKBTPDDesc
	}
	q MKBTPDRowId
}

/// Creator：谷雪萍
/// CreatDate: 2018-05-08
/// Description：引用术语类型-引用列表型术语内容维护模块-获取已选术语列表（新-多选术语存成多个属性内容）
/// Table：User.MKBTerm
/// Input：property-属性id,rowid-已选术语id
/// return: 术语id：术语代码：术语描述
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetSellistTermList","6")
Query GetSellistTermList(property As %String, rowid As %String) As %Query(ROWSPEC = "MKBTRowId,MKBTCode,MKBTDesc,MKBTPDRowId,MKBTPDSequence")
{
}

ClassMethod GetSellistTermListExecute(ByRef qHandle As %Binary, property As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (property'="")
    {
	    s MKBTPDRowId=0
		for  
		{	
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId=""   //遍历该属性下的内容
			
			s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9)  //顺序
			s MKBTRowId=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容表描述字段MKBTPDDesc存的值——术语id
			continue:MKBTRowId=""
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
			s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
	        s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
	        //如果没有定位到具体的术语id则输出全部数据，如果定位到具体的术语则只输出一条
	        if (rowid="")||((rowid'="")&(rowid=MKBTRowId))
	        {
				d OutputRowSelListTerm
	        }
		}

    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSelListTerm
    set Data=$lb(MKBTRowId,MKBTCode,MKBTDesc,MKBTPDRowId,MKBTPDSequence)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSellistTermListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSellistTermListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSellistTermListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSellistTermListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
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

/// Creator：谷雪萍
/// CreatDate: 2018-04-04
/// Description：引用术语类型属性内容维护模块-获取已选术语列表（旧-多选术语存在一个属性内容id里）
/// Table：User.MKBTerm
/// Input：property-属性id
/// return: 术语id：术语代码：术语描述
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetSelTermList","6")
Query GetSelTermList(property As %String) As %Query(ROWSPEC = "MKBTRowId,MKBTCode,MKBTDesc")
{
}

ClassMethod GetSelTermListExecute(ByRef qHandle As %Binary, property As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (property'="")
    {
	    s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
		s MKBTPDDesc=""
		s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		if (MKBTPDDesc'="")
		{
	        s argsLen=$Length(MKBTPDDesc,",")
	        for i=1:1:argsLen  
	        { 
	          s MKBTRowId=$p(MKBTPDDesc,",",i)
	          continue:MKBTRowId=""
			  //封闭的数据不显示
			  s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
			  continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
	          s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
	          s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
	          d OutputRowSelTerm
	        }
		}
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSelTerm
    set Data=$lb(MKBTRowId,MKBTCode,MKBTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSelTermListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelTermListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSelTermListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelTermListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
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

/// Creator：谷雪萍
/// CreatDate: 2018-04-04
/// Description：引用术语类型属性内容维护模块-获取已选术语列表
/// Table：User.MKBTerm
/// Input：property-属性id，termStr-已选属性串，desc-检索条件
/// return: 术语id：术语描述：术语代码
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetUnSelTermList","6","","")
Query GetUnSelTermList(property As %String, termStr As %String, desc As %String) As %Query(ROWSPEC = "MKBTRowId:%String,MKBTDesc:%String,MKBTCode:%String")
{
}

ClassMethod GetUnSelTermListExecute(ByRef qHandle As %Binary, property As %String, termStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (property'="")
	{
		s base=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
		if (base'="")
		{
			s:desc'="" desc=$ZCONVERT(desc,"U")
			if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
			{
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId=""
					s id = "<"_MKBTRowId_">" 
					//封闭的数据不显示
					s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
					continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
					s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
					s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")				
					i ((MKBTDescU[desc)||(MKBTPYCodeU[desc))&'(termStr[id)   //条件   //条件
					{
						d OutputRowUnSelTerm
					}		
				}
			}
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUnSelTerm
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelTermListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelTermListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelTermListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelTermListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
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

/// Creator：谷雪萍
/// CreatDate: 2018-6-01
/// Description：查询列表术语的内容，用于术语下拉框
/// Table：User.MKBTerm
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetTermCmb","","","")
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
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
			s MKBTSequence=$listGet($g(^User.MKBTermD(MKBTRowId)),8)  //顺序
			d OutputTermCmb
		}
		else
		{
			s count=0
			s desc=q
			s:desc'="" desc=$ZCONVERT(desc,"U")
			if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
			{
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:((MKBTRowId="") ||(count>49))
					
					//封闭的数据不显示
					s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
					continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
					
					s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
					s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
					s MKBTSequence=$listGet($g(^User.MKBTermD(MKBTRowId)),8)
								
					s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowId)  
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
/// CreatDate:2018-04-10
/// Description：根据标识获取诊断的术语库注册表ID
/// Input：flag-术语库注册表的标识字段值：诊断,药品,检验,检查,手术-Diagnose,Drug,Lab,Check,Operation
/// Return:术语库注册表ID
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetBaseIDByFlag("Diagnose")
ClassMethod GetBaseIDByFlag(flag) As %String
{
	s baseId=""
	q:flag="" ""
	s flag=$ZCONVERT(flag,"U") //转换成大写
	s baseId=$o(^User.MKBTermBaseI("FlagIndex"," "_flag,0))
	q baseId
}

/// Creator:谷雪萍
/// CreatDate:2018-04-10
/// Description：获取术语的常用名 如果常用名为空的话则返回术语中心词
/// Input：termid -术语id
/// Return:常用名
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(1)
ClassMethod GetTermComByTermId(termid As %String) As %String
{
	s termDesc=$listGet($g(^User.MKBTermD(termid)),3)  //术语中心词	
	q:('$d(^User.MKBTermPropertyI("FlagIndex",termid," AL"))) termDesc
	s comPropertyId=$o(^User.MKBTermPropertyI("FlagIndex",termid," AL",0)) //常用名的属性id
	s mySeq=$o(^User.MKBTermProDetailI("SeqIndex",comPropertyId,0)) 
	q:mySeq="" termDesc
	s detailId=$o(^User.MKBTermProDetailI("SeqIndex",comPropertyId,mySeq,0))
	q:detailId="" termDesc
	s termCom=$LISTGET($G(^User.MKBTermProDetailD(detailId)),3)   //常用名
	s:termCom="" termCom=termDesc
	q termCom
}

/// Creator:谷雪萍
/// CreatDate:2018-04-10
/// Description：获取术语的常用名和常用名检索码
/// Input：termid -术语id
/// Return:常用名和常用名检索码
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(1)
ClassMethod GetTermComAndPY(termid As %String) As %String
{
	s termComStr="",termAlisaStr=""    //常用名&%检索码 ，别名串
	
	q:('$d(^User.MKBTermPropertyI("FlagIndex",termid," AL"))) ""
	s comPropertyId=$o(^User.MKBTermPropertyI("FlagIndex",termid," AL",0)) //常用名的属性id


	//输出菜单JSON串
	
	s count=0
	s MKBTPDSequence=""
	for  
	{	
		s MKBTPDSequence=$o(^User.MKBTermProDetailI("SeqIndex",comPropertyId,MKBTPDSequence)) q:MKBTPDSequence=""
		s comDetailId=0   //常用名的属性内容ID
		for 
		{
			s comDetailId=$o(^User.MKBTermProDetailI("SeqIndex",comPropertyId,MKBTPDSequence,comDetailId)) q:comDetailId="" 

			s count=count+1
			s termCom=$LISTGET($G(^User.MKBTermProDetailD(comDetailId)),3)   //常用名
			
			s comPY=$LISTGET($G(^User.MKBTermProDetailD(comDetailId)),10)  //检索码
			
			if (count=1){  //排在列表第一位的是常用名
				s termComStr=termCom_"&%"_comPY
			}
			else{  //排在下面的是别名
				s:termAlisaStr'="" termAlisaStr=termAlisaStr_$c(1)_termCom_$c(2)_comPY
				s:termAlisaStr="" termAlisaStr=termCom_$c(2)_comPY
			}
		}
	}
	s cominfo=termComStr_"[A]"_termAlisaStr
	s cominfo= ##class(web.DHCBL.BDP.FunLib).EvalJSON(cominfo) 
	q cominfo
}

/// Creator:谷雪萍
/// CreatDate:2019-05-24
/// Description:生成科室常用诊断的临时global
/// Input:LocId - 实际科室的id
/// return：1
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).CreateLocFreqDiaGlobal(14870)
ClassMethod CreateLocFreqDiaGlobal(LocId As %String) As %String
{
	q:LocId="" 0
	k ^TMPMKBLOCFREQDIA(LocId)
	s MappingBaseId=$o(^User.MKBKLMappingBaseI("IdenIndex"," CD",0))   //科室常用诊断-映射注册表id
	s diaFiledChild=""   //科室常用诊断-诊断列-映射注册子表child
	s freqFiledChild=""  //科室常用诊断-频次列-映射注册子表child
	s:MappingBaseId'="" diaFiledChild=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MappingBaseId," 诊断",0))
	s:MappingBaseId'="" freqFiledChild=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MappingBaseId," 频次",0))
	if (MappingBaseId'="")&(diaFiledChild'="")
	{
		s diaFiledId=MappingBaseId_"||"_diaFiledChild	 //科室常用诊断-诊断列-映射注册子表id
		s LocTermId=0  //专业科室id
		for 
		{
			s LocTermId=$o(^User.MKBLocContrastI("LocIndex",LocId,LocTermId)) 
			q:LocTermId=""
			if ($D(^User.MKBReferenceI("InverAllIndex","T",LocTermId,"MD"))'=0)
			{
				s MDRowId = 0  //引用表id
				for
				{
					s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",LocTermId,"MD",MDRowId))	
					q:MDRowId=""
					continue:($D(^User.MKBKLMappingDetailI("BaseIndex",MappingBaseId,MDRowId))=0)	
					s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)   //行号
					
					continue:RowNum=""
					s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,diaFiledId,0))  //扩展属性内容表的id
					
				    continue:MKBKMDRowId="" 
				    s diaRowId=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),2) //扩展属性内容的值——诊断的值
				    continue:diaRowId=""
				    
				    s diafreq=""	
				    if (freqFiledChild'="")
				    {
					    s freqFiledId=MappingBaseId_"||"_freqFiledChild	 //科室常用诊断-频次列-映射注册子表id
					    s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,freqFiledId,0))  //扩展属性内容表的id					    		    
					    s:MKBKMDRowId'="" diafreq=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),2) //扩展属性内容的值——诊断的值
				    }
				    s:diafreq="" diafreq=0
					s ^TMPMKBLOCFREQDIA(LocId,diafreq,diaRowId)=""
				 			    

				}	
			}	
		}
	}
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-07-17
/// Description:为医生站提供的获取诊断数据的接口：本科室频次最高的数据先输出，然后再取非本科室的按频次排列
/// Table：User.MKBTerm
/// Input：rowid-诊断术语ID,base-术语库注册父表的ID,desc-根据描述、常用名及拼音码查询，rows-每页显示行数 page-第几页
/// return:Json数据
/// d ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermListForDoc(rowid,base, desc, rows, page)
/// d ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermListForDoc("",5,"fj",8,1)
ClassMethod GetTermListForDoc(rowid As %String, base As %String, desc As %String, rows As %String, page As %String) As %String
{
	
	s result="",total=0,jsonstr=""	
	
	if (base="")
	{
		w "{""rows"":[], ""total"":0}"    //术语库注册id为空
		q
	}
	
	w "{""rows"":["
	if (rowid'="") //根据rowid返回该条记录
	{
		s total=1
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述			
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
		s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
		s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)
		s strCom=$p(strComAndAlisa,"[A]",1)
		s comDesc=$p(strCom,"&%",1) //常用名
		s comKey=$p(strCom,"&%",2)	//常用名拼音码	
		s:comDesc="" comDesc=MKBTDesc
		s MKBTDesc=	comDesc_"("_MKBTDesc_")"
		s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
		s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""comKey"":"""_comKey_""",""MKBTNote"":"""_MKBTNote_"""}"
		w mainstr
	}
	else
	{
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s tablename="User.SDSStructDiagnos"
		s tablename=" "_$ZCONVERT(tablename,"U")	
		s baseFlag=##class(web.DHCBL.MKB.MKBTermBase).GetFlagById(base)
		if (baseFlag="Diagnose"){ //西医先取本科室常用诊断，再取其他术语
			s LocId=$g(%session.Data("LOGON.CTLOCID"))
			//s LocId=13
		}
		else{ //中医直接取中医术语
			s LocId=""
		}

		s:desc'="" desc=$ZCONVERT(desc,"U")
		if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
		{
			
			//按操作频次
			/*s BDPDAFFrequency=""
			for
			{
				s BDPDAFFrequency=$o(^User.BDPDataFrequencyI("TableLocFreqIdx",tablename,LocId,BDPDAFFrequency),-1) q:BDPDAFFrequency="" 
				s RowId=""
				for
				{
					s RowId=$o(^User.BDPDataFrequencyI("TableLocFreqIdx",tablename,LocId,BDPDAFFrequency,RowId),-1) q:RowId="" 
					//s MKBTDesc=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
					s MKBTRowId=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
					continue:(MKBTRowId="")||(MKBTRowId["||")

					s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
					s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
					s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
					s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
					s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
					s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
					s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")
					s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)  //常用名别名及拼音码
					s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
					s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
					s comDesc=$p(strCom,"&%",1) //常用名
					s comKey=$p(strCom,"&%",2)	//常用名拼音码	
					s:comDesc="" comDesc=MKBTDesc
					s MKBTDesc=	comDesc_"("_MKBTDesc_")"
					s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)	
							
					i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc)||($ZCONVERT(comDesc,"U")[desc)||($ZCONVERT(comKey,"U")[desc)||($ZCONVERT(strAlias,"U")[desc))   //条件
					{
						s total=total+1
						if (total<stpage) continue
						if (total<=endpage)
						{	
							s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""comKey"":"""_comKey_""",""MKBTNote"":"""_MKBTNote_"""}"					
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
			
			}*/
			
			if (LocId'="")
			{
				//生成科室常用诊断的索引
				d ##class(web.DHCBL.MKB.MKBTermProDetail).CreateLocFreqDiaGlobal(LocId)
			
				//科室常用his诊断
				// ^TMPMKBSTRUCTDIA(his科室id,频次,数据处理工厂子表ID)=数据处理工厂父表描述[A]诊断ID[A]数据处理工厂父表检索码[A]术语常用名[A]常用名拼音码[A]备注
				k ^TMPMKBLOCDIA(LocId)  //科室诊断的global
				if ($d(^TMPMKBLOCFREQDIA(LocId)))
				{
					
					s frequency=""
					for
					{
						s frequency=$o(^TMPMKBLOCFREQDIA(LocId,frequency),-1) q:frequency="" 
						s MKBTRowId=0   //数据处理工厂子表ID
						for
						{
							s MKBTRowId=$o(^TMPMKBLOCFREQDIA(LocId,frequency,MKBTRowId)) q:MKBTRowId="" 
							if $d(^TMPMKBLOCDIA(LocId,MKBTRowId)) continue  //如果已经有这个病了，则跳过
							
							s ^TMPMKBLOCDIA(LocId,MKBTRowId)=""
							//封闭的数据不显示
							s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
							continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
							
							s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
							s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
							s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
							s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
							s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
							s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
							s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")
							s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)  //常用名别名及拼音码
							s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
							s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
							s comDesc=$p(strCom,"&%",1) //常用名
							s comKey=$p(strCom,"&%",2)	//常用名拼音码	
							s:comDesc="" comDesc=MKBTDesc
							s MKBTDesc=	comDesc_"("_MKBTDesc_")"
							s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
							i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc)||($ZCONVERT(comDesc,"U")[desc)||($ZCONVERT(comKey,"U")[desc)||($ZCONVERT(strAlias,"U")[desc))   //条件
							{
								
								s total=total+1
							    if (total<stpage) continue
							    if (total<=endpage)
							    {
								    s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""comKey"":"""_comKey_""",""MKBTNote"":"""_MKBTNote_"""}"
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
			}
			
			
			//再遍历术语表，输出非本科室的数据
			s MKBTRowId=""
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 
				
				//频次表里有则跳过
				/*if (LocId'="")&&($d(^User.BDPDataFrequencyI("TableLocReferenceIdx",tablename,LocId," "_MKBTRowId)))  //如果已经输出了就跳过
				{
					continue
				}*/
				//如果科室常用诊断已经有这个数据则跳过
				if (LocId'="")&&($d(^TMPMKBLOCDIA(LocId,MKBTRowId)))  //如果已经输出了就跳过
				{
					continue
				}
				//封闭的数据不显示
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
				continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
				s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
				s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
				s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
				s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")
				s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)  //常用名别名及拼音码
				s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
				s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
				s comDesc=$p(strCom,"&%",1) //常用名
				s comKey=$p(strCom,"&%",2)	//常用名拼音码	
				s:comDesc="" comDesc=MKBTDesc
				s MKBTDesc=	comDesc_"("_MKBTDesc_")"
				s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)	
				
				i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc)||($ZCONVERT(comDesc,"U")[desc)||($ZCONVERT(comKey,"U")[desc)||($ZCONVERT(strAlias,"U")[desc))   //条件
				{
					s total=total+1
				    if (total<stpage) continue
				    if (total<=endpage)
				    {
					    s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""comKey"":"""_comKey_""",""MKBTNote"":"""_MKBTNote_"""}"
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
		

	q ""
}

/*ClassMethod GetTermListForDiaTemp(rowid As %String, base As %String, desc As %String, rows As %String, page As %String) As %String
{
	
	s result="",total=0,jsonstr=""	
	
	if (base="")
	{
		w "{""rows"":[], ""total"":0}"    //术语库注册id为空
		q
	}
	
	w "{""rows"":["
	if (rowid'="") //根据rowid返回该条记录
	{
		s total=1
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述			
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)
		s strCom=$p(strComAndAlisa,"[A]",1)
		s comDesc=$p(strCom,"&%",1) //常用名
		s comKey=$p(strCom,"&%",2)	//常用名拼音码	
		s:comDesc="" comDesc=MKBTDesc
		s MKBTDesc=	comDesc_"("_MKBTDesc_")"
		s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
		//诊断短语相关数据都为空
		s MKBICDRowid="", MKBICDDesc="", MKBICDRRowid="",MKBICDRRTerm="",MKBICDRResult="",MKBICDRRowid="",MKBICDRRSup="",LinkIcdCode="",LinkIcdDesc="",Result=""
		s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"
		w mainstr
	}
	else
	{
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

	
		s LocId=$g(%session.Data("LOGON.CTLOCID"))
		//s LocId=96
		s LocDesc = $ZCONVERT($P($G(^CTLOC(LocId)),"^",2),"U")
		s IsChinaMed=$P($G(^CTLOC(LocId,"DHC")),"^",16)  //医生站是否录入中医诊断的设置
		s:IsChinaMed="" IsChinaMed=0   //为空的时候不允许					
		s allowNoStandardICD=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSNonstandardICD")  //允许非标ICD
		
		s:desc'="" desc=$ZCONVERT(desc,"U")
		if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
		{
			
			if (LocId'="")
			{
				//生成科室常用诊断的索引
				d ##class(web.DHCBL.MKB.MKBTermProDetail).CreateLocFreqDiaGlobal(LocId)
			
				//科室常用his诊断
				// ^TMPMKBSTRUCTDIA(his科室id,频次,数据处理工厂子表ID)=数据处理工厂父表描述[A]诊断ID[A]数据处理工厂父表检索码[A]术语常用名[A]常用名拼音码[A]备注
				k ^TMPMKBLOCDIA(LocId)  //科室诊断的global
				if ($d(^TMPMKBLOCFREQDIA(LocId)))
				{
					
					s frequency=""
					for
					{
						s frequency=$o(^TMPMKBLOCFREQDIA(LocId,frequency),-1) q:frequency="" 
						s MKBTRowId=0 
						for
						{
							s MKBTRowId=$o(^TMPMKBLOCFREQDIA(LocId,frequency,MKBTRowId)) q:MKBTRowId="" 
							if $d(^TMPMKBLOCDIA(LocId,MKBTRowId)) continue  //如果已经有这个病了，则跳过
							
							s ^TMPMKBLOCDIA(LocId,MKBTRowId)=""
							//封闭的数据不显示
							s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
							continue:MKBTActiveFlag="N"  //判断是否显示封闭数据							
							
							d GetTermData	//执行获取诊断中心词相关数据的语句
							//诊断短语相关数据都为空
							s MKBICDRowid="", MKBICDDesc="", MKBICDRRowid="",MKBICDRRTerm="",MKBICDRResult="",MKBICDRRowid="",MKBICDRRSup="",LinkIcdCode="",LinkIcdDesc="",Result=""

							i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc)||($ZCONVERT(comDesc,"U")[desc)||($ZCONVERT(comKey,"U")[desc)||($ZCONVERT(strAlias,"U")[desc))   //条件
							{
		
								s total=total+1
							    if (total<stpage) continue
							    if (total<=endpage)
							    {
								    s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"
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
			}
			
			//如果诊断短语来源是数据处理工厂且检索条件不为空，则先输出本科室的诊断短语
			s diaDataSourse= ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")  //诊断短语来源
			if (desc'="")&(diaDataSourse'="")&(diaDataSourse'["ICD")
			{
				s tmpnum=0 ///记录关键词个数
				for i=1:1:$L(desc," ")
				{
					s subdesc = $P(desc," ",i)
					continue:((subdesc="")||($zstrip(subdesc,"<>W")=""))
					s tmpnum=tmpnum+1
					s MKBSDRowId=0
					for
					{
						s MKBSDRowId=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(subdesc,"U"),MKBSDRowId))
						q:MKBSDRowId=""
						

						continue:MKBSDRowId["L"
						continue:MKBSDRowId["ICD"
						s MKBSDMergeFlag=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),15)  //合并的数据跳过
						continue:MKBSDMergeFlag'=""
						continue:$D(^User.MKBStructuredDataI("BaseIndex",diaDataSourse,MKBSDRowId))=0  //不是本版本的数据跳过
						s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
						s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
						s ICDDr = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetMRCIDByCodeDesc(ICDCode,ICDDesc)
						
						continue:((allowNoStandardICD'="Y")&(ICDDr="")) //不允许录入非标ICd，则没有匹配出ICD来的数据不输出
						
						if (ICDDr'="")
						{
							s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
							continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	 //不允许录入中医诊断
						}
						
						if $D(tmpdesc(MKBSDRowId))
						{
							s tmpdesc(MKBSDRowId)=tmpdesc(MKBSDRowId)+1	
						}
						else
						{
							s tmpdesc(MKBSDRowId)=1	
						}
					}
				}
				

				s MKBSDRowId=0
				for
				{
					s MKBSDRowId=$O(tmpdesc(MKBSDRowId))
					q:MKBSDRowId=""
					 
					continue:tmpdesc(MKBSDRowId)'=tmpnum  //不满足多条件的去掉
					
					if $d(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U"),MKBSDRowId))   //实际科室频次
					{
						s MKBSDLRowid=$o(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U"),MKBSDRowId,0))						
						s Fre=$lg($g(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",MKBSDLRowid)),3)
						
						s ids(1,Fre,MKBSDRowId)=""	
					}
					else
					{
						s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
						s ids(0,Fre,MKBSDRowId)=""	
					}
					
				}
				
				s flag=0
				
				//本科室的诊断短语优先输出
				s fre=""
				for
				{
					s fre=$O(ids(1,fre),-1)
					q:fre=""
					
					s MKBSDRowId=0
					for
					{
						s MKBSDRowId=$O(ids(1,fre,MKBSDRowId))
						q:MKBSDRowId=""
						
						s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
						
						s MKBSDRChild=""
						s sortindex=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,0))
						if (sortindex'="")
						{
							s MKBSDRChild=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,sortindex,0))	
						}
							
						s MKBSDRTermDr = ""
						s MKBSDRExpId=""
						s MKBSDRExp=""
						s MKBSDRSup=""
						s LinkIcdCode=""
						s LinkIcdDesc=""
						//中心词相关数据设置初始值							
				        s MKBTRowId="",MKBTCode="",MKBTDesc="",MKBTPYCode="",MKBTPYCode="",comDesc=""
						if (MKBSDRChild'="")
						{
							s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
							if (MKBSDRTermDr'="")
							{
								s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
								s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
								s MKBTRowId=MKBSDRTermDr
								d GetTermData
								s MKBTDesc=	comDesc_"["_MKBSDDesc_"]"   //显示中心词【诊断短语】
								
							}
						
							s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
						}	
						
						s LinkIcdCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //在ICD字段取值
						s LinkIcdDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),21)  //在ICD描述字段取值


						s total=total+1
						if (total<stpage) continue
						if (total<=endpage)
						{
							s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						
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
			
			//再遍历术语表，输出非本科室的数据
			s MKBTRowId=""
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 

				//如果科室常用诊断已经有这个数据则跳过
				if (LocId'="")&&($d(^TMPMKBLOCDIA(LocId,MKBTRowId)))  //如果已经输出了就跳过
				{
					continue
				}

				//封闭的数据不显示
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
			    continue:MKBTActiveFlag="N"  //判断是否显示封闭数据	
			    	
			    d GetTermData		//执行获取诊断中心词相关数据的语句
			    
			    //诊断短语相关数据都为空
				s MKBICDRowid="", MKBICDDesc="", MKBICDRRowid="",MKBICDRRTerm="",MKBICDRResult="",MKBICDRRowid="",MKBICDRRSup="",LinkIcdCode="",LinkIcdDesc="",Result=""

				i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc)||($ZCONVERT(comDesc,"U")[desc)||($ZCONVERT(comKey,"U")[desc)||($ZCONVERT(strAlias,"U")[desc))   //条件
				{
					
					s total=total+1
				    if (total<stpage) continue
				    if (total<=endpage)
				    {
					    s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"
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
			
			//如果诊断短语来源是数据处理工厂、输出非本科室的诊断
			if (desc'="")&(diaDataSourse'="")&(diaDataSourse'["ICD")&$d(ids(0))
			{
				//本科室的诊断短语优先输出
				s fre=""
				for
				{
					s fre=$O(ids(0,fre),-1)
					q:fre=""
					
					s MKBSDRowId=0
					for
					{
						s MKBSDRowId=$O(ids(0,fre,MKBSDRowId))
						q:MKBSDRowId=""
						
						s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)

						s MKBSDRChild=""
						s sortindex=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,0))
						if (sortindex'="")
						{
							s MKBSDRChild=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,sortindex,0))	
						}
							
						s MKBSDRTermDr = ""
						s MKBSDRExpId=""
						s MKBSDRExp=""
						s MKBSDRSup=""
						s LinkIcdCode=""
						s LinkIcdDesc=""
						//中心词相关数据设置初始值							
				        s MKBTRowId="",MKBTCode="",MKBTDesc="",MKBTPYCode="",MKBTPYCode="",comDesc=""
						if (MKBSDRChild'="")
						{
							s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
							if (MKBSDRTermDr'="")
							{
								s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
								s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
								s MKBTRowId=MKBSDRTermDr								
								d GetTermData
								s MKBTDesc=	comDesc_"["_MKBSDDesc_"]"   //显示中心词【诊断短语】
								
							}
						
							s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
						}	
						
						s LinkIcdCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //在ICD字段取值
						s LinkIcdDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),21)  //在ICD描述字段取值

						s total=total+1
						if (total<stpage) continue
						if (total<=endpage)
						{
							s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						
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
					
			//如果诊断短语来源是各版本ICD对照且检索条件不为空
			if (desc'="")&(diaDataSourse'="")&(diaDataSourse["ICD")
			{
				s version=$tr(diaDataSourse,"ICD","")
				s desc=$zstrip(desc,"<>W")
				s tmpnum=0        //记录关键词个数
				for i=1:1:$l(desc," ")
				{
					continue:desc=""
					s subdesc = $P(desc," ",i)
					continue:((subdesc="")||($zstrip(subdesc,"<>W")=""))
					s tmpnum=tmpnum+1
					s MKBICDRowid=0
					for
					{
						s MKBICDRowid=$o(^User.MKBStructIndexI("DescIndex"," "_$zconvert(subdesc,"U"),MKBICDRowid))
						q:MKBICDRowid=""
						continue:MKBICDRowid'["ICD"
						s MKBRowid=$e(MKBICDRowid,1,*-3)
						s MKBICD=$lg($g(^User.MKBICDContrastD(MKBRowid)),4)
						continue:MKBICD=""
						s MKBType=$lg($g(^User.MKBICDContrastD(MKBRowid)),6)
						continue:MKBType'[version
						
						s icd=$lg($g(^User.MKBICDContrastD(MKBRowid)),4)
						s extend=$lg($g(^User.MKBICDContrastD(MKBRowid)),5)
						s LinkIcdCode=icd_extend //在ICD字段取值	
						s LinkIcdDesc=$lg($g(^User.MKBICDContrastD(MKBRowid)),3)  //在ICD描述字段取值
						s ICDDr = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetMRCIDByCodeDesc(LinkIcdCode,LinkIcdDesc)					
						continue:((allowNoStandardICD'="Y")&(ICDDr="")) //不允许录入非标ICd，则没有匹配出ICD来的数据不输出
											
						if (ICDDr'="")
						{
							s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
							continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	 //不允许录入中医诊断
						}		
									
						if $D(tmpdesc(MKBRowid))
						{
							s tmpdesc(MKBRowid)=tmpdesc(MKBRowid)+1	
						}
						else
						{
							s tmpdesc(MKBRowid)=1	
						}
					}
				}

				
				s MKBICDRowid=0                      //按汉字ASCII码排序        
				for
				{
					s MKBICDRowid=$o(tmpdesc(MKBICDRowid))
					q:MKBICDRowid=""
					continue:tmpdesc(MKBICDRowid)'=tmpnum   //不满足匹配到每个关键词的则不输出
					s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
					s tempout(MKBICDDesc,MKBICDRowid)=""
				}
				
				s flag=0
				s Desc=""
				for
				{
					s Desc=$o(tempout(Desc))
					q:Desc=""
					s MKBICDRowid=0
					for
					{
						s MKBICDRowid=$o(tempout(Desc,MKBICDRowid))
						q:MKBICDRowid=""  //诊断id
						
						s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
						s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,0))
						if sequence'=""
						{
							s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,0))
							s MKBICDRResult=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)
							s MKBICDRRTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4)
							s MKBICDRRSup=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),5)
							s Result= ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDRResult,MKBICDRRTerm)
							s MKBTRowId=MKBICDRRTerm
							d GetTermData
							s MKBTDesc=	comDesc_"["_MKBICDDesc_"]"   //显示中心词【诊断短语】
							s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						}
						else
						{
							s MKBICDRRSup=""
							s MKBICDRRTerm=""
							s MKBICDRResult=""
							s MKBICDRRowid=""
							s Result=""	
							//中心词相关数据都为空							
						    s MKBTRowId="",MKBTCode="",MKBTDesc="",MKBTPYCode="",MKBTPYCode="",comDesc=""
							s MKBTDesc=MKBICDDesc
						}
						s icd=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
						s extend=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),5)
						s LinkIcdCode=icd_extend //在ICD字段取值	
						s LinkIcdDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)  //在ICD描述字段取值
						s total=total+1
					    if (total<stpage) continue
					    if (total<=endpage)
					    {
						    s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"
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
	}

	w "], ""total"":"_total_"}"
		

	q ""
	
GetTermData
	s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
	s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
	s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
	s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)  //常用名别名及拼音码
	s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
	s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
	s comDesc=$p(strCom,"&%",1) //常用名
	s comKey=$p(strCom,"&%",2)	//常用名拼音码	
	s:comDesc="" comDesc=MKBTDesc
	s MKBTDesc=	comDesc_"("_MKBTDesc_")"
	s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
}
*/
/// Creator:谷雪萍
/// CreatDate:2019-12-12
/// Description:为医生站提供的获取诊断数据的接口：本科室中心词－》本科室诊断短语－》非本科室中心词－》非本科室诊断短语
/// Table：User.MKBTerm
/// Input：rowid-诊断术语ID,base-术语库注册父表的ID,desc-根据描述、常用名及拼音码查询，rows-每页显示行数 page-第几页,ICDType-中医西医标识（0-西医 1-中医 2-证候）^就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
/// return:Json数据
/// d ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermListForDiaTemp(rowid,base, desc, rows, page,ICDType)
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermListForDiaTemp("",5,"伤寒",10,1,0)
ClassMethod GetTermListForDiaTemp(rowid As %String, base As %String, desc As %String, rows As %String, page As %String, ICDType As %String = "") As %String
{
	
	s result="",total=0,jsonstr=""
	
	s ChineseWesternType=$p($g(ICDType),"^",1)	 //中西医类型（0-西医 1-中医 2-证候）
	s ClinicType=$p($g(ICDType),"^",2)  //就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
	
	if (base="")
	{
		w "{""rows"":[], ""total"":0}"    //术语库注册id为空
		q ""
	}
	
	w "{""rows"":["
	if (rowid'="") //根据rowid返回该条记录
	{
		s total=1
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述			
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)
		s strCom=$p(strComAndAlisa,"[A]",1)
		s comDesc=$p(strCom,"&%",1) //常用名
		s comKey=$p(strCom,"&%",2)	//常用名拼音码	
		s:comDesc="" comDesc=MKBTDesc
		s MKBTDesc=	comDesc_"("_MKBTDesc_")"
		s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
		//诊断短语相关数据都为空
		s MKBICDRowid="", MKBICDDesc="", MKBICDRRowid="",MKBICDRRTerm="",MKBICDRResult="",MKBICDRRowid="",MKBICDRRSup="",LinkIcdCode="",LinkIcdDesc="",Result=""
		//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"
		s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_$tr(MKBTCode,"\","")_""",""MKBTDesc"":"""_$Replace(MKBTDesc,"\","")_""",""MKBTPYCode"":"""_$tr(MKBTPYCode,"\","")_""",""comDesc"":"""_$Replace(comDesc,"\","")_""",""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_$Replace(MKBSDDesc,"\","")_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_$Replace(MKBSDRExp,"\","")_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcdDesc"":"""_$Replace(LinkIcdDesc,"\","")_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						

		w mainstr
	}
	else
	{
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		//s LocId=96
		//s LocDesc ="呼吸内科"
		s LocId=$g(%session.Data("LOGON.CTLOCID"))
		s LocDesc = $P($G(^CTLOC(LocId)),"^",2) // "呼吸内科" //科室描述
		s HospId=$G(%session.Data("LOGON.HOSPID"))				
		s allowNoStandardICD=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSNonstandardICD")  //允许非标ICD
		s IsValidMethodName=##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.DHCBL.BDP.BDPMappingHOSP","GetHospShowDataFlag") //判断类方法是否存在
		s:desc'="" desc=$ZCONVERT(desc,"U")
		if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
		{
			//如果诊断短语来源是数据处理工厂且检索条件不为空，则先输出本科室的诊断短语
			s diaDataSourse= ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")  //诊断短语来源
			if (desc'="")&(diaDataSourse'="")&(diaDataSourse'["ICD")
			{
				s tmpnum=0 ///记录关键词个数
				for i=1:1:$L(desc," ")
				{
					s subdesc = $P(desc," ",i)
					continue:((subdesc="")||($zstrip(subdesc,"<>W")=""))
					s tmpnum=tmpnum+1
					s MKBSIRowId=0
					for
					{
						s MKBSIRowId=$O(^User.MKBStructIndexI("DescIndex",diaDataSourse," "_$ZCONVERT(subdesc,"U"),MKBSIRowId))
						q:MKBSIRowId=""
						s MKBSDRowId=$p(MKBSIRowId,"||",1)
						continue:'$d(^User.MKBStructuredDataD(MKBSDRowId))
						s ChildSub=$p(MKBSIRowId,"||",2)
						s:ChildSub="" ChildSub="0"
						continue:MKBSDRowId["L"
						continue:MKBSDRowId["ICD"
						
						s MKBSDMergeFlag=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),15)  //合并的数据跳过
						continue:MKBSDMergeFlag'=""
						s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
						s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
						// 数据处理工厂里都是标准ICD，不需要非标ICD的判断
						/*if (allowNoStandardICD'="Y")  //不允许录入非标ICd，则没有匹配出ICD来的数据不输出
						{
							s ICDDr = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetMRCIDByCodeDesc(ICDCode,ICDDesc)
							continue:(ICDDr="")   
						}*/
						s MRCIDBillFlag3=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),24) //中医诊断标志
						s MRCIDBillFlag1=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),25) //中医证型
						continue:(ChineseWesternType="0")&&(MRCIDBillFlag3="Y")
						continue:(ChineseWesternType="1")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1="Y"))
						continue:(ChineseWesternType="2")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1'="Y"))
						//continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	 //不允许录入中医诊断
						s MRCIDMetastaticSite=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),26) //肿瘤形态学编码标志  
						s MRCIDInjuryPoisoningCode=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),27) //损伤中毒外部原因标志
						continue:(MRCIDMetastaticSite="Y")||(MRCIDInjuryPoisoningCode="Y")	
						s MKBSDHisRowID=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),30) //HIS诊断Id
						if ((IsValidMethodName=1)&&(MKBSDHisRowID'="")){
							s HospShowDataFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("MRC_ICDDx",MKBSDHisRowID,HospId,"") //判断医院授权
							continue:(HospShowDataFlag="N") 
						}
						s MKBSDClinicType=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),33) //就诊类型	
						continue:(MKBSDClinicType'="")&(ClinicType'="")&(MKBSDClinicType'[ClinicType) //如果不属于该就诊类型，则跳过
						s DateFrom=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),28) //开始日期
						s DateTo=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),29) //结束日期
						continue:(DateFrom'="")&&(DateFrom>+$H)
						continue:(DateTo'="")&&(DateTo<+$H)
						
						if $D(tmpdesc(MKBSDRowId,ChildSub))
						{
							s tmpdesc(MKBSDRowId,ChildSub)=tmpdesc(MKBSDRowId,ChildSub)+1	
						}
						else
						{
							s tmpdesc(MKBSDRowId,ChildSub)=1	
						}
					}
				}
				

				s MKBSDRowId=0
				for
				{
					s MKBSDRowId=$O(tmpdesc(MKBSDRowId))
					q:MKBSDRowId=""
					s ChildSub=""
					for
					{
						s ChildSub=$O(tmpdesc(MKBSDRowId,ChildSub))
						q:ChildSub=""
						
						continue:tmpdesc(MKBSDRowId,ChildSub)'=tmpnum  //不满足多条件的去掉
						continue:((ChildSub'="0")&&$d(arrOther(MKBSDRowId))) //别名去重
						s arrOther(MKBSDRowId)=""
						s:ChildSub="0" MKBSIRowId=MKBSDRowId
						s:ChildSub'="0" MKBSIRowId=MKBSDRowId_"||"_ChildSub
						s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2) //诊断名
						s Len=$Length(MKBSDDesc) //诊断名长度
						if $d(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U"),MKBSDRowId))   //实际科室频次
						{
							s MKBSDLRowid=$o(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U"),MKBSDRowId,0))						
							s Fre=$lg($g(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",MKBSDLRowid)),3)
							s:Fre="" Fre=0
							s ids(1,Fre,Len,MKBSIRowId)=""	
						}
						else
						{
							s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
							s:Fre="" Fre=0
							s ids(0,Fre,Len,MKBSIRowId)=""	
						}
					}
				}
			
				s flag=""
				for 
				{
					s flag=$O(ids(flag),-1) //实际科室频次->总频次
					q:flag=""
					s fre=""
					for
					{
						s fre=$O(ids(flag,fre),-1)
						q:fre=""
						s len=""
						for
						{
							s len=$O(ids(flag,fre,len)) //同频次先短后长
							q:len=""
							s MKBSIRowId=0
							for
							{
								s MKBSIRowId=$O(ids(flag,fre,len,MKBSIRowId))
								q:MKBSIRowId=""
								s MKBSDRowId=$p(MKBSIRowId,"||",1)
								d GetStructData
								s total=total+1
								if (total<stpage) continue
								if (total<=endpage)
								{
									//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						
									s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_$tr(MKBTCode,"\","")_""",""MKBTDesc"":"""_$Replace(MKBTDesc,"\","")_""",""MKBTPYCode"":"""_$tr(MKBTPYCode,"\","")_""",""comDesc"":"""_$Replace(comDesc,"\","")_""",""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_$Replace(MKBSDDesc,"\","")_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_$Replace(MKBSDRExp,"\","")_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcdDesc"":"""_$Replace(LinkIcdDesc,"\","")_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						
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
				
	
				
			}
			

				
		
			if (ChineseWesternType'="1")&(ChineseWesternType'="2") //如果中医科室则不显示中心词
			{
				
					
				//如果诊断短语来源是各版本ICD对照且检索条件不为空
				if (desc'="")&(diaDataSourse'="")&(diaDataSourse["ICD")
				{
					s version=$tr(diaDataSourse,"ICD","")
					s desc=$zstrip(desc,"<>W")
					s tmpnum=0        //记录关键词个数
					for i=1:1:$l(desc," ")
					{
						continue:desc=""
						s subdesc = $P(desc," ",i)
						continue:((subdesc="")||($zstrip(subdesc,"<>W")=""))
						s tmpnum=tmpnum+1
						s MKBICDRowid=0
						for
						{
							s MKBICDRowid=$o(^User.MKBStructIndexI("DescIndex"," "_$zconvert(subdesc,"U"),MKBICDRowid))
							q:MKBICDRowid=""
							continue:MKBICDRowid'["ICD"
							s MKBRowid=$e(MKBICDRowid,1,*-3)
							s MKBICD=$lg($g(^User.MKBICDContrastD(MKBRowid)),4)
							continue:MKBICD=""
							s MKBType=$lg($g(^User.MKBICDContrastD(MKBRowid)),6)
							continue:MKBType'[version
							
							s icd=$lg($g(^User.MKBICDContrastD(MKBRowid)),4)
							s extend=$lg($g(^User.MKBICDContrastD(MKBRowid)),5)
							s LinkIcdCode=icd_extend //在ICD字段取值	
							s LinkIcdDesc=$lg($g(^User.MKBICDContrastD(MKBRowid)),3)  //在ICD描述字段取值

							if (allowNoStandardICD'="Y")
							{
								s ICDDr =##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(LinkIcdCode,LinkIcdDesc,ICDType)
								//s ICDDr = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetMRCIDByCodeDesc(LinkIcdCode,LinkIcdDesc)					
								continue:(ICDDr="") //不允许录入非标ICd，则没有匹配出ICD来的数据不输出
							}	
										
							if $D(tmpdesc(MKBRowid))
							{
								s tmpdesc(MKBRowid)=tmpdesc(MKBRowid)+1	
							}
							else
							{
								s tmpdesc(MKBRowid)=1	
							}
						}
					}

					
					s MKBICDRowid=0                      //按汉字ASCII码排序        
					for
					{
						s MKBICDRowid=$o(tmpdesc(MKBICDRowid))
						q:MKBICDRowid=""
						continue:tmpdesc(MKBICDRowid)'=tmpnum   //不满足匹配到每个关键词的则不输出
						s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
						s tempout(MKBICDDesc,MKBICDRowid)=""
					}
					
					s flag=0
					s Desc=""
					for
					{
						s Desc=$o(tempout(Desc))
						q:Desc=""
						s MKBICDRowid=0
						for
						{
							s MKBICDRowid=$o(tempout(Desc,MKBICDRowid))
							q:MKBICDRowid=""  //诊断id
							
							s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
							s MKBICDRRowid="",MKBICDRRTerm=""
							s sequence=0
							for
							{
								s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
								q:sequence=""
								s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,0))
								s MKBICDRRTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4)
								s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBICDRRTerm)),9)		
								if (MKBTActiveFlag="Y")||(MKBTActiveFlag="")
								{
									q
								}	
								else
								{
									s MKBICDRRowid="",MKBICDRRTerm=""
								}	
							}
							if (MKBICDRRowid'="")&(MKBICDRRTerm'="")
							{
								
								s MKBICDRResult=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)
								s MKBICDRRSup=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),5)
								s Result= ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDRResult,MKBICDRRTerm)
								s MKBTRowId=MKBICDRRTerm
								d GetTermData(MKBTRowId)
								s MKBTDesc=	comDesc_"["_MKBICDDesc_"]"   //显示中心词【诊断短语】
								s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
							}
							else
							{
								s MKBICDRRSup=""
								s MKBICDRRTerm=""
								s MKBICDRResult=""
								s MKBICDRRowid=""
								s Result=""	
								//中心词相关数据都为空							
							    s MKBTRowId="",MKBTCode="",MKBTDesc="",MKBTPYCode="",MKBTPYCode="",comDesc=""
								s MKBTDesc=MKBICDDesc
							}
							s icd=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
							s extend=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),5)
							s LinkIcdCode=icd_extend //在ICD字段取值	
							s LinkIcdDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)  //在ICD描述字段取值
							s total=total+1
						    if (total<stpage) continue
						    if (total<=endpage)
						    {
								//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"
								s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_$tr(MKBTCode,"\","")_""",""MKBTDesc"":"""_$Replace(MKBTDesc,"\","")_""",""MKBTPYCode"":"""_$tr(MKBTPYCode,"\","")_""",""comDesc"":"""_$Replace(comDesc,"\","")_""",""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_$Replace(MKBSDDesc,"\","")_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_$Replace(MKBSDRExp,"\","")_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcdDesc"":"""_$Replace(LinkIcdDesc,"\","")_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						
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
			
		}
	}

	w "], ""total"":"_total_"}"
		

	q ""
	
GetStructData
	s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2) //诊断名
	s MKBSDOther=""
	s:($p(MKBSIRowId,"||",2)'="") MKBSDOther= $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",$p(MKBSIRowId,"||",2))),2) //别名
	
	//诊断短语相关数据初始化
	s MKBSDRTermDr = "", MKBSDRExpId="",MKBSDRExp="",MKBSDRSup="",LinkIcdCode="", LinkIcdDesc=""
	//中心词相关数据设置初始值							
    s MKBTRowId="",MKBTCode="",MKBTDesc="",MKBTPYCode="",MKBTPYCode="",comDesc=""
    
    //查找在用的第一个结构化结果
	s MKBSDRChild=""
	s sortindex=0
	for
	{
		s sortindex=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,sortindex))
		q:sortindex=""

		s MKBSDRChild=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,sortindex,0))	
		continue:MKBSDRChild=""
		s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
		continue:MKBSDRTermDr=""
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBSDRTermDr)),9)		
		if (MKBTActiveFlag="Y")||(MKBTActiveFlag="")
		{
			q
		}
		else
		{
			s MKBSDRChild="",MKBSDRTermDr=""
		}
	}
		
	if (MKBSDRChild'="")&(MKBSDRTermDr'="")  //如果诊断短语结构化了
	{
		s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
		s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
		s MKBTRowId=MKBSDRTermDr
		d GetTermData(MKBTRowId)
		s MKBTDesc=	comDesc_"["_MKBSDDesc_"]"   //显示中心词【诊断短语】						
		s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
	}
	else //如果诊断短语没有结构化
	{
		 s MKBTDesc="["_MKBSDDesc_"]"  //只显示【诊断短语】
		//continue  //没有结构化诊断则不显示
	}
	s LinkIcdCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //在ICD字段取值
	s LinkIcdDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),21)  //在ICD描述字段取值
	s LinkIcdDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",LinkIcdDesc) //多语言改造
	
	//新描述：如果检索到的是诊断短语，则只显示诊断短语，如果检索到的是别名，则显示诊断短语（别名）
	s MKBTDesc=MKBSDDesc
	s:MKBSDOther'="" MKBTDesc=MKBSDDesc_"("_MKBSDOther_")"
	s MKBTDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",MKBTDesc) //多语言改造
GetTermData(MKBTRowId)
	s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
	s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
	s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
	s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)  //常用名别名及拼音码
	s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
	s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
	s comDesc=$p(strCom,"&%",1) //常用名
	s comKey=$p(strCom,"&%",2)	//常用名拼音码	
	s:comDesc="" comDesc=MKBTDesc
	s MKBTDesc=	comDesc_"("_MKBTDesc_")"
	s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
}

/// Creator:谷雪萍
/// CreatDate:2018-06-14
/// Description:获取知识应用模板类型的日志描述
/// Input:proDetailDesc -属性内容表的Desc字段的值
/// return：知识应用模板类型的日志描述:术语或属性-术语库注册名或属性名-定义节点(单选/多选、展示格式、是否必填)"
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetPropertyLogDesc(14870)
ClassMethod GetPropertyLogDesc(proDetailDesc As %String) As %String
{
	q:proDetailDesc="" ""
	s propertyLogDesc=""  //知识应用模板类型的日志描述

	s argsLen=$Length(proDetailDesc,",")
    for i=1:1:argsLen   
    {     
        s argstr=$p(proDetailDesc,",",i)  //术语属性id&展示类型&起始节点
        s catRowId=$p(argstr,"&",1)  //术语属性id
        s showType=$p(argstr,"&",2) //展示类型
        s treeNode=$p(argstr,"&",3) //定义起始节点
        s:treeNode="undefined" treeNode=""
        s choiceType=$p(argstr,"&",4)  //单选多选
        s ifRequired=$p(argstr,"&",5)  //是否必填（Y/N）
      	s isTOrP=$p(argstr,"&",6)  //术语T或属性P
        
		s catDesc="",TreeNodeDesc=""
      	if (isTOrP="T") //术语
      	{
	      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
	      	{
		      	//s TreeNodeDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(treeNode)
		      	s TreeNodeDesc=$listGet($g(^User.MKBTermD(treeNode)),3)  //节点描述-术语中心词	
	      	}
	      	s catDesc=$LISTGET($G(^User.MKBTermBaseD(catRowId)),3)  //术语库描述

      	}
      	else    //属性
      	{
	      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
	      	{
		      	/*s TreeNodeDesc=..GetExtendVal(treeNode,catRowId,"展示名")  //获取展示名
				s:TreeNodeDesc="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述*/
				s TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3)  //节点描述-属性内容中心词	
	      	}
	      	s catDesc=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),3)  //术语属性描述

      	}
	    
	    if (showType="G") {s showType="列表"}
		if (showType="C") {s showType="下拉框"}
		if (showType="T"){s showType="下拉树"}
		if (showType="TX"){s showType="文本框"}
		if (showType="TA"){s showType="多行文本框"}
		if (showType="CB"){s showType="单选框"}
		if (showType="CG"){s showType="复选框"}	
		
		if (choiceType="D"){
			s choiceType="复选"
		}
		else{
			s choiceType="单选"
		}
		
		if (ifRequired="Y"){
			s ifRequired="必填"
		}
		else{
			s ifRequired="不必填"
		}
				
		if (isTOrP="T"){
			s isTOrP="术语"
		}
		else{
			s isTOrP="属性"
		}
		
		s str=isTOrP_"-"_catDesc
		if (TreeNodeDesc'="")
		{
			s str=str_"-"_TreeNodeDesc
		}
		s str=str_"("_choiceType_"、"_showType_"、"_ifRequired_")"
	    if (propertyLogDesc="")
	    {
		     s propertyLogDesc=str
	    }
		else
		{
			  s propertyLogDesc=propertyLogDesc_"，"_str
		}

    }
    q propertyLogDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-04-10
/// Description:给医生站提供诊断模板信息
/// Input:dia 诊断id
/// return：诊断模板属性id_"^"_缺省展示效果_"^"_属性模板里引用属性拼串。
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDiaTemplate(15879)
ClassMethod GetDiaTemplate(dia) As %String
{
		
	s emptyInfo=""   //结构化的缺省展示效果：例如糖尿病ID(分型属性ID，并发症属性ID)
	s modeJsonInfo=""  //属性模板里引用属性的信息的Json信息
	q:dia="" ""

	s proId=$o(^User.MKBTermPropertyI("FlagIndex",dia," DT",0)) //诊断模板的属性ID 直接根据标识来获取  
	if (proId'="")
	{
		s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0)) //属性内容的id
		
		if (proDetailId'="")
		{
			s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)   //属性内容
			//b ;
			if (proDetailDesc'="")
			{
				s argsLen=$Length(proDetailDesc,",")
			    for i=1:1:argsLen   
			    {     
			        s argstr=$p(proDetailDesc,",",i)  //术语/属性id&展示类型&起始节点&单选/多选&是否必填&术语/属性标识
			        s catRowId=$p(argstr,"&",1)  //术语属性id 或者术语id 
			        s showType=$p(argstr,"&",2) //展示类型
			        s treeNode=$p(argstr,"&",3) //定义起始节点
			        s:treeNode="undefined" treeNode=""
			        s choiceType=$p(argstr,"&",4)  //单选多选
			        s:choiceType="" choiceType="S"  //默认单选
			        s ifRequired=$p(argstr,"&",5)  //是否必填（Y/N）
		          	s:ifRequired="" ifRequired="N"  //默认不必填
		          	s isTOrP=$p(argstr,"&",6)  //术语T或属性P
		          	s:isTOrP="" isTOrP="P"  //默认属性P
			      	s catDesc="",catType="",TreeNodeDesc="",catFlag=""
			      	if (isTOrP="T") //术语
			      	{
				      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
				      	{
					      	s TreeNodeDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(treeNode)
				      	}
				      	s catDesc=$LISTGET($G(^User.MKBTermBaseD(catRowId)),3) //术语库描述 
					    s:TreeNodeDesc'="" catDesc=TreeNodeDesc 
					    s catType=$LISTGET($G(^User.MKBTermBaseD(catRowId)),4) //术语库类型
					    s catFlag=$LISTGET($G(^User.MKBTermBaseD(catRowId)),10) //术语库标识
			      	}
			      	else    //属性
			      	{
			      		;s:treeNode'="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述
				      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
				      	{
					      	s TreeNodeDesc=..GetExtendVal(treeNode,catRowId,"展示名")  //获取展示名
							s:TreeNodeDesc="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述
				      	}
				      	s catDesc=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),3)  //属性描述
					    s:TreeNodeDesc'="" catDesc=TreeNodeDesc 
					    s catType=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),4) //属性类型
					    s catFlag=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),8)  //属性标识
					    //if (catFlag="S") {s catFlag="Y"}
			      	}
				    
				    //屏蔽"结构化"属性
					continue:(catDesc="结构化")
					s catDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",catDesc) //多语言改造
					
				    //s:treeNode="" treeNode="E"_catRowId  //如果初始节点为空，也要定义一个（E+属性id），结构化诊断录入那边的需求
				    s str="{""catRowId"": """_catRowId_""",""catDesc"": """_catDesc_""",""catType"": """_catType_""",""showType"": """_showType_""",""catFlag"": """_catFlag_""",""treeNode"": """_treeNode_""",""choiceType"": """_choiceType_""",""ifRequired"": """_ifRequired_""",""isTOrP"": """_isTOrP_"""}"
				    i modeJsonInfo="" s modeJsonInfo=str
					e  s modeJsonInfo=modeJsonInfo_","_str
					i emptyInfo'="" s emptyInfo=emptyInfo_","_catRowId
					i emptyInfo="" s emptyInfo=catRowId

			    }
			    //缺省展示效果——诊断ID(分型属性ID，并发症属性ID)
				s emptyInfo=dia_"("_emptyInfo_")"
			}

		}	
	
	}
	
	s modeJsonInfo="["_modeJsonInfo_"]"
	q proId_"^"_emptyInfo_"^"_modeJsonInfo
}

/// Creator:谷雪萍
/// CreatDate:2018-04-11
/// Description:给医生站提供诊断模板信息串
/// Input:dia 诊断id
/// return：诊断模板属性id_"^"_缺省展示效果_"^"_属性模板里引用属性拼串。
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDiaTemplateStr(1)
ClassMethod GetDiaTemplateStr(dia) As %String
{
		
	s emptyInfo=""   //结构化的缺省展示效果：例如糖尿病ID(分型属性ID，并发症属性ID)
	s modeJsonInfo=""  //属性模板里引用属性的信息串, $c(1)连接的引用属性
	q:dia="" ""

	s proId=$o(^User.MKBTermPropertyI("FlagIndex",dia," DT",0)) //诊断模板的属性ID 直接根据标识来获取  
	if (proId'="")
	{
		s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0)) //属性内容的id
		
		if (proDetailId'="")
		{
			s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)   //属性内容
			if (proDetailDesc'="")
			{
				s argsLen=$Length(proDetailDesc,",")
			    for i=1:1:argsLen   
			    {     
			        s argstr=$p(proDetailDesc,",",i)  //术语/属性id&展示类型&起始节点&单选/多选&是否必填&术语/属性标识
			        s catRowId=$p(argstr,"&",1)  //术语属性id 或者术语id 
			        s showType=$p(argstr,"&",2) //展示类型
			        s treeNode=$p(argstr,"&",3) //定义起始节点
			        s:treeNode="undefined" treeNode=""
			        s choiceType=$p(argstr,"&",4)  //单选多选
			        s:choiceType="" choiceType="S"  //默认单选
			        s ifRequired=$p(argstr,"&",5)  //是否必填（Y/N）
		          	s:ifRequired="" ifRequired="N"  //默认不必填
		          	s isTOrP=$p(argstr,"&",6)  //术语T或属性P
		          	s:isTOrP="" isTOrP="P"  //默认属性P
			      	s catDesc="",catType="",TreeNodeDesc="",catFlag=""
			      	if (isTOrP="T") //术语
			      	{
				      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
				      	{
					      	s TreeNodeDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(treeNode)
				      	}
				      	s catDesc=$LISTGET($G(^User.MKBTermBaseD(catRowId)),3) //术语库描述 
					    s:TreeNodeDesc'="" catDesc=TreeNodeDesc 
					    s catType=$LISTGET($G(^User.MKBTermBaseD(catRowId)),4) //术语库类型
					    s catFlag=$LISTGET($G(^User.MKBTermBaseD(catRowId)),10) //术语库标识
			      	}
			      	else    //属性
			      	{
			      		;s:treeNode'="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述
				      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
				      	{
					      	s TreeNodeDesc=..GetExtendVal(treeNode,catRowId,"展示名")  //获取展示名
							s:TreeNodeDesc="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述
				      	}
				      	s catDesc=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),3)  //属性描述
					    s:TreeNodeDesc'="" catDesc=TreeNodeDesc 
					    s catType=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),4) //属性类型
					    s catFlag=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),8)  //属性标识
					    //if (catFlag="S") {s catFlag="Y"}
			      	}
				    //s:treeNode="" treeNode="E"_catRowId  //如果初始节点为空，也要定义一个（E+属性id），结构化诊断录入那边的需求
				    s str=catRowId_$c(2)_catDesc_$c(2)_catType_$c(2)_showType_$c(2)_catFlag_$c(2)_treeNode_$c(2)_choiceType_$c(2)_ifRequired_$c(2)_isTOrP
				    i modeJsonInfo="" s modeJsonInfo=str
					e  s modeJsonInfo=modeJsonInfo_$c(1)_str
					i emptyInfo'="" s emptyInfo=emptyInfo_","_catRowId
					i emptyInfo="" s emptyInfo=catRowId

			    }
			    //缺省展示效果——诊断ID(分型属性ID，并发症属性ID)
				s emptyInfo=dia_"("_emptyInfo_")"
			}

		}	
	
	}
	
	s modeJsonInfo="["_modeJsonInfo_"]"
	q proId_"^"_emptyInfo_"^"_modeJsonInfo
}

/// Creator:谷雪萍
/// CreatDate:2018-04-10
/// Description：获取树型术语库扩展列的值,给医生站提供的接口，在GetDocTreeJson里用到
/// Input：propertyId-属性的id,detailId-属性内容表的ID,extProDesc-扩展属性的描述
/// Return:扩展属性值表的内容
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(20,2,"检索码")
ClassMethod GetExtendVal(detailId As %String, propertyId As %String, extProDesc As %String) As %String
{
	
	q:((detailId="")||(propertyId="")||(extProDesc="")) ""
	
	s extProDesc=" "_$ZCONVERT(extProDesc,"U") //转换成大写
	s extendVal=""

	s extProLength=$d(^User.MKBTermExtendProI("NameIndex",propertyId,extProDesc))
	if (extProLength)
	{
		s extProChild=$o(^User.MKBTermExtendProI("NameIndex",propertyId,extProDesc,0)) 
		s extProId=propertyId_"||"_extProChild
		s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",detailId,extProId,0))  //扩展属性内容表User.MKBTermProDetail的id
		s:MKBTEPVRowId'="" extendVal=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值		
	}
	s extendVal= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(extendVal)
	q extendVal
}

/// Creator:谷雪萍
/// CreatDate:2018-04-11
/// Description：提供列表型属性数据获取接口,展示格式是下拉框、单选框、多选框。
/// Input：desc, cat, start, limit
/// Return:id:中心词:备注：顺序：展示名：别名：拼音码
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetListDetailInfo("","1",0,10)
ClassMethod GetListDetailInfo(desc As %String, property As %String, start As %String, limit As %String, SearchMode As %String = "") As %String
{
	s result="",total=0,jsonstr=""
	q:property="" "{data:[], success:false, total:0}"   //如果子术语库大类未选中
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s start=start+1  ////start=0  从1条开始 不加会导致第一页显示的记录比设置的“每页显示记录数”少一条

	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 
		
		s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),2) //代码
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3) //描述
		s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
		s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7) //说明
		s MKBTPDRemark= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
		s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9)  //顺序


		//s ExtendStr=..GetDocTreeExtendInfo(TKBTDRowId,property)  //别名^拼音码^常用名
		s comDesc=..GetExtendVal(MKBTPDRowId,property,"展示名")  //展示名
		s:comDesc="" comDesc=MKBTPDDesc   //展示名为空则展示中心词
		s comDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",comDesc) //多语言改造
		s AlisaDesc=..GetExtendVal(MKBTPDRowId,property,"别名")   //别名
		//s PYDesc=..GetExtendVal(MKBTPDRowId,property,"检索码")   //检索码
		s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),10)  //检索码
		s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
		s SearchFlag=..GetSearchFlag(MKBTPDDesc, PYDesc, desc, SearchMode)
		i (SearchFlag=1)   //条件
		{
			s total=total+1
			if (total<start) continue
			if ((total<(start+limit)))
			{
				s mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""comDesc"":"""_comDesc_""",""AlisaDesc"":"""_AlisaDesc_""",""PYDesc"":"""_PYDesc_"""}"
				if (jsonstr'="")
				{ 
					s jsonstr=jsonstr_","_mainstr
				}
				else
				{
					s jsonstr=mainstr
				}
			}
		}
		
	}
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-04-12
/// Description：给医生站提供获取树形术语库的接口——不输出定义的初始节点
/// Input:id ：上级节点id，如果模板中定义了起始节点treeNode，则取值为treeNode的值，否则起始节点为空；property:属性id
/// return:所有子节点 Json格式
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTreeDetailJson("","2")
ClassMethod GetTreeDetailJson(id As %String, property As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s childStr=""
	s count=0
	w "["
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			//continue:$LISTGET($G(^User.MKBTermProDetailD(myRowID)),6)'="Y"
			s count=count+1
			
			s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),2) //代码
			s Caption=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
			s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			if count>1 w ","
			s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
			s comDesc=..GetExtendVal(myRowID,property,"展示名")  //展示名
			s:comDesc="" comDesc=Caption   //展示名为空则展示中心词
			s comDesc = ##class(websys.Translation).Get("diagnosentry.v8.csp",comDesc) //多语言改造
			s AlisaDesc=..GetExtendVal(myRowID,property,"别名")   //别名
			//s PYDesc=..GetExtendVal(myRowID,property,"检索码")   //检索码
			s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),10)  //检索码
			s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)

			s spanDesc=AlisaDesc_"^"_PYDesc_"^"_Caption_"^"_MKBTPDRemark_"^"_MKBTPDCode  //别名^拼音码^中心词^备注^代码
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
		
			w "{""id"":"""_""_myRowID_""",""text"":"""_comDesc_"<span class='hidecls'>"_spanDesc_"</span>"""

			//s childStr=..GetChildOrderedIDStr(myRowID,property)
			//if childStr'=""
			if $d(^User.MKBTermProDetailI("ProParIndex",property,myRowID))
			{
				//一次性加载   
				w ",""state"":""open"""   //closed节点不展开,open节点展开
				w ",""children"":"
				w ..GetTreeDetailJson(myRowID,property)
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

/// Creator:谷雪萍
/// CreatDate:2018-04-12
/// Description：给医生站提供的接口 获取属性格式为引用的属性内容
/// Input:cat：属性id
/// return:属性明细表ID串_"[A]"_引用术语id串_"[A]"_引用术语描述串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseDetailInfo("26320")
ClassMethod GetDocSourseDetailInfo(property As %String) As %String
{
	q:property="" ""
	
	s detailIds="",termIds="",termDesc=""
	s MKBTPConfig=$LISTGET($G(^User.MKBTermPropertyD(property)),5)   //属性表配置项（来源于哪个术语）
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId=""   //遍历该属性下的内容
		
		s MKBTRowId=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容表描述字段MKBTPDDesc存的值——术语id
		continue:MKBTRowId=""
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
		continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //已选术语描述
		s:detailIds'="" detailIds=detailIds_","_MKBTPDRowId
		s:detailIds="" detailIds=MKBTPDRowId
		s:termIds'="" termIds=termIds_","_MKBTRowId
		s:termIds="" termIds=MKBTRowId
		s:termDesc'="" termDesc=termDesc_","_MKBTDesc
		s:termDesc="" termDesc=MKBTDesc	
		s termDesc = ##class(websys.Translation).Get("diagnosentry.v8.csp",termDesc) //多语言改造	
	}
	
	q detailIds_"[A]"_termIds_"[A]"_termDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供的接口 如果引用的术语是列表型的则展示格式是下拉框（下拉框数据描述-拼音码）、单选框、多选框、多选下拉框
/// Input：property-属性ID,showType-展示类型,desc-检索条件
/// Return:Json 格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseList("26320","C","")
ClassMethod GetDocSourseList(property As %String, showType As %String, desc As %String, SearchMode As %String = "") As %String
{
	s result="",total=0,jsonstr=""
	q:property="" "{data:[], success:false, total:0}"   //如果子术语库大类未选中
	
	s:desc'="" desc=$ZCONVERT(desc,"U")

    s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId=""   //遍历该属性下的内容
		
		s MKBTRowId=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容表描述字段MKBTPDDesc存的值——术语id
		continue:MKBTRowId=""
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
		continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //已选术语代码
        s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //已选术语描述
        s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //已选术语拼音码
		
		/*if (showType="C"){
		  s MKBTDesc=MKBTDesc_"-"_MKBTPYCode
		}*/
		s MKBTDesc = ##class(websys.Translation).Get("diagnosentry.v8.csp",MKBTDesc) //多语言改造
		s SearchFlag=..GetSearchFlag(MKBTDesc, MKBTPYCode, desc, SearchMode)
		i (SearchFlag=1)   //条件
		{
			s total=total+1
			s mainstr= "{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""PYDesc"":"""_MKBTPYCode_"""}"
			if (jsonstr'="")
			{	   
			  s jsonstr=jsonstr_","_mainstr
			}
			else
			{
			  s jsonstr=mainstr
			}		  	
		}
	}
		
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供的接口 如果引用的术语是列表的:获取选中术语的ID串
/// Input：property-属性ID
/// Return:选中术语的ID串
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseListIds(26320)
ClassMethod GetDocSourseListIds(property As %String) As %String
{
	s result=""  //选中术语的ID串
	q:property="" ""   //如果子术语库大类未选中
	
    s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId=""   //遍历该属性下的内容
		
		s MKBTRowId=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容表描述字段MKBTPDDesc存的值——术语id
		continue:MKBTRowId=""
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
		continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
		
		s:result'="" result=result_"^"_MKBTRowId
	 	s:result="" result=MKBTRowId
	    
	}
	
	q result
}

/*
/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseTreeJson("","29007")
ClassMethod GetDocSourseTreeJson(LastLevel As %String, property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"
	
	s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
	
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w ..GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
			//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]" //判断是否显示封闭数据	
			
		s strId=","_definedNode_","
		if (selItemIds[strId){
				
			s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
			s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
			s MKBTNote=$LISTGET($G(^User.MKBTermD(definedNode)),7)  //备注
			s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(definedNode)
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码

			s spanDesc=comDesc_"^"_MKBTPYCode_"^"_definedNodeDesc_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
		
			w "["
			w "{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_spanDesc_"</span>"""
			w ",""state"":""open"""

			if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
			{
				w ",""children"":"
				w ..GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
			}
			w "}"
			w "]"
		}
		else{
			q "[]"
		}
		
	}
	
	q ""
}
*/
/// Creator：谷雪萍
/// CreatDate:2018-05-09
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.MKBTerm
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseJsonDataForCmb("31","","")
ClassMethod GetDocSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	w "["
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s strId=","_myRowID_","
			if '(selItemIds[strId){
				continue
			}
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
			s count=count+1
			s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
			s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)  //备注
			s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(myRowID)  ////常用名
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码

			s spanDesc=comDesc_"^"_MKBTPYCode_"^"_Caption_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
			//s Caption=$tr(Caption,"""","")
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_Caption_"<span class='hidecls'>"_spanDesc_"</span>"""
			w ",""state"":""open"""
			s childStr=..GetDocChildOrderedIDStr(base,myRowID,selItemIds)
			if childStr'=""
			{	
				w ",""children"":"
				w ..GetDocSourseJsonDataForCmb(base,myRowID,selItemIds)	
			}
	
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator：谷雪萍
/// CreatDate:2018-05-09
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTerm
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocChildOrderedIDStr("","","")
ClassMethod GetDocChildOrderedIDStr(base As %String, LastLevel As %String, selItemIds As %String) As %String
{
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			s strId=","_myRowID_","
			if '(selItemIds[strId){
				continue
			}
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据		
			s childStr=..GetDocChildOrderedIDStr(base,myRowID,selItemIds)
			if childStr'="" s childStr=myRowID_"^"_childStr
			if childStr="" s childStr=myRowID
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// Creator:谷雪萍
/// CreatDate:2018-05-09
/// Description：给医生站提供获取引用树形术语的接口——获取选中术语的ID串，用^链接
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点的ID拼串
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseTreeIds("","29007")
ClassMethod GetDocSourseTreeIds(LastLevel As %String, property As %String) As %String
{
	s myTreeIds=""  //一级节点的子节点及以下节点
	q:(property="") ""
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") ""
	s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)	
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
	
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		s myTreeIds=..GetDocChildOrderedIDStr(DATSOU,definedNode,selItemIds)
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{	
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "" //判断是否显示封闭数据	
		
		s strId=","_definedNode_","
		if (selItemIds[strId){				
			s myTreeIds=definedNode			
			if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
			{
				s myTreeIds=myTreeIds_"^"_..GetDocChildOrderedIDStr(DATSOU,definedNode,selItemIds)
			}
		}
		else{
			q ""
		}
		
	}
	
	q myTreeIds
}

/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供接口——如果是引用属性类型的属性则只能是下拉框（下拉框数据描述-拼音码）、单选框、多选框、多选下拉框
/// Input：property-属性ID,desc-检索条件
/// Return:Json 格式  catRowId:T/P-术语id/属性id-定义节点id 
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocPropertyList("4","")
ClassMethod GetDocPropertyList(property As %String, desc As %String, SearchMode As %String = "") As %String
{
	s result="",total=0,jsonstr=""
	q:property="" "{data:[], success:false, total:0}"   //如果子术语库大类未选中
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
		
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))  //术语明细表id
	if (MKBTPDRowId'="")
	{
	 	s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //术语明细表desc (存已选术语id串)
	    s argsLen=$Length(MKBTPDDesc,",")
	    for i=1:1:argsLen   
	    {
	        s argstr=$p(MKBTPDDesc,",",i)  //术语属性id&展示类型&起始节点
	        s catRowId=$p(argstr,"&",1)  //术语属性id
	        s showType=$p(argstr,"&",2) //展示类型
	        s treeNode=$p(argstr,"&",3) //定义起始节点
	        s:treeNode="undefined" treeNode=""
	        s choiceType=$p(argstr,"&",4)  //单选多选
	        s ifRequired=$p(argstr,"&",5)  //是否必填（Y/N）
	      	s isTOrP=$p(argstr,"&",6)  //术语T或属性P
	        
	      	s TOrPDesc="",TreeNodeDesc=""
			
	      	if (isTOrP="T") //术语
	      	{
		      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
		      	{
			      	//s TreeNodeDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(treeNode)
			      	s TreeNodeDesc=$listGet($g(^User.MKBTermD(treeNode)),3)  //节点描述-术语中心词	
		      	}
		      	
		      	s catDesc=$LISTGET($G(^User.MKBTermBaseD(catRowId)),3)  //术语库描述

	      	}
	      	else    //属性
	      	{
		      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
		      	{
			      	/*s TreeNodeDesc=..GetExtendVal(treeNode,catRowId,"展示名")  //获取展示名
					s:TreeNodeDesc="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述*/
					s TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3)  //节点描述-属性内容中心词	
		      	}

				s catDesc=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),3)  //术语属性描述
	      	}
		   
			s isTOrPDesc=""		
			if (isTOrP="T"){
				s isTOrPDesc="术语"
			}
			else{
				s isTOrPDesc="属性"
			}
			
			s catDesc=isTOrPDesc_"-"_catDesc
			s:TreeNodeDesc'="" catDesc=catDesc_"-"_TreeNodeDesc

			s catRowId=isTOrP_"-"_catRowId
			s:treeNode'="" catRowId=catRowId_"-"_treeNode
			
			s catDesc = ##class(websys.Translation).Get("diagnosentry.v8.csp",catDesc) //多语言改造

			s SearchFlag=..GetSearchFlag(catDesc, "", desc, SearchMode)
		    i (SearchFlag=1)   //条件
			{
			  s total=total+1
			  s mainstr= "{""catRowId"":"""_catRowId_""",""catDesc"":"""_catDesc_"""}"
			  if (jsonstr'="")
			  {	   
			  	  s jsonstr=jsonstr_","_mainstr
			  }
			  else
			  {
				  s jsonstr=mainstr
			  }		  	
			}
	    }
	}
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-11-27
/// Description:给医生站提供接口——如果诊断模板里选的是术语（列表型）则展示格式是下拉框（下拉框数据描述-拼音码）、单选框、多选框、多选下拉框
/// Table：User.MKBTerm
/// Input：rowid-诊断术语ID,base-术语库注册父表的ID,desc-根据描述、常用名及拼音码查询，rows-每页显示行数 page-第几页
/// return:Json数据
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetListTermJsonForDoc(rowid,base, desc, rows, page)
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetListTermJsonForDoc("",5,"fj",8,1)
ClassMethod GetListTermJsonForDoc(rowid As %String, base As %String, desc As %String, rows As %String, page As %String, SearchMode As %String = "") As %String
{
	
	s result="",total=0,jsonstr=""	
	
	if (base="")
	{
		//w "{""rows"":[], ""total"":0}"    //术语库注册id为空
		q "{data:[], success:false, total:0}"  
	}
	
	//w "{""rows"":["
	if (rowid'="") //根据rowid返回该条记录
	{
		s total=1
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc) 			
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
		/*s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
		s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
		s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")*/
		s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_"""}"	
		//w mainstr
		s jsonstr=mainstr
	}
	else
	{
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s:desc'="" desc=$ZCONVERT(desc,"U")
		if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
		{
			s MKBTRowId=""
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 
				
				//封闭的数据不显示
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
				continue:MKBTActiveFlag="N"  //判断是否显示封闭数据

				s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc) 
				s MKBTDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",MKBTDesc) //多语言改造
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
				/*s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
				s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
				s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")*/
				s SearchFlag=..GetSearchFlag(MKBTDesc, MKBTPYCode, desc, SearchMode)
				i (SearchFlag=1)   //条件
				{
					s total=total+1
					if (total<stpage) continue
					if (total<=endpage)
					{	
						s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_"""}"					
						if (jsonstr'="")
						{ 
							//w ","
							s jsonstr=jsonstr_","_mainstr
						}
						else
						{
							s jsonstr=mainstr
						}
						//w mainstr
					}
				}
					
			}			
					
		}
	}

	//w "], ""total"":"_total_"}"	
	//q ""
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-12-24
/// Description：给医生站提供获取引用起始节点的属性内容的接口
/// Input:property-属性id
/// return:返回引用的起始节点的子节点
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSSProDetailJsonForDoc(property)
ClassMethod GetSSProDetailJsonForDoc(property As %String) As %String
{
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"

	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))  //属性内容id

	s definedNode=""
	s:MKBTPDRowId'="" definedNode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容中心词

	d ..GetTreeTermJsonForDoc(definedNode,DATSOU)
	
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-11-27
/// Description：给医生站提供获取树形术语库的接口
/// Input:id ：上级节点id，如果模板中定义了起始节点treeNode，则取值为treeNode的值，否则起始节点为空。base:术语库注册id——取自诊断模板接口里的catRowId
/// return:所有子节点 Json格式
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTreeTermJsonForDoc("16412","6")
ClassMethod GetTreeTermJsonForDoc(id As %String, base As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	w "["
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
							
			s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
			s Caption=$tr(Caption,"""","")
			s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			s MKBTPYCode=$listGet($g(^User.MKBTermD(myRowID)),6)  //检索码
			s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
			s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
			s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)   ///备注
			s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(myRowID)  //常用名别名及拼音码
			s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
			s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
			s comDesc=$p(strCom,"&%",1) //常用名
			s comKey=$p(strCom,"&%",2)	//常用名拼音码
			if (comDesc'="")&(comKey'="")   //把常用名和拼音码也放在别名里
			{
				s:strAlias'="" strAlias=comDesc_$c(2)_comKey_$c(1)_strAlias
				s:strAlias="" strAlias=comDesc_$c(2)_comKey
			}
			s:comDesc="" comDesc=Caption   //展示名为空则展示中心词
			s comDesc = ##class(websys.Translation).Get("diagnosentry.v8.csp",comDesc) //多语言改造

			s spanDesc=strAlias_"^"_MKBTPYCodeU_"^"_Caption_"^"_MKBTNote  //别名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
			
			if count>1 w ","
			w "{""id"":"""_""_myRowID_""",""text"":"""_comDesc_"<span class='hidecls'>"_spanDesc_"</span>"""

			s childStr=##class(web.DHCBL.MKB.MKBTerm).GetTreeChildOrderedIDStr(base,myRowID)
			if childStr'=""
			{
				//一次性加载   
				w ",""state"":""open"""   //closed节点不展开,open节点展开
				w ",""children"":"
				w ..GetTreeTermJsonForDoc(myRowID,base)
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

/// Creator:谷雪萍
/// CreatDate:2018-11-29
/// Description：诊断录入传过来的其他文本描述保存的接口。（其他文本描述下超过50条就不让他继续录入了）
/// Input：proId-其他描述的属性id,text-文本内容
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).AddDataToOtherTextPro(472457,"测试文本")
ClassMethod AddDataToOtherTextPro(proId As %String, text As %String) As %String
{
	q:(proId="") "{success:'false',errorinfo:'没有获取到其他描述的属性id！'}"
	s text=$tr(text," ","")
	s text= ##class(web.DHCBL.BDP.FunLib).EvalJSON(text)
	q:(text="") "{success:'false',errorinfo:'没有需要保存的文本内容！'}"
	s textDetailId=""     //其他文本描述的节点id	
	s parentcatdr=-100000000000000				
	s detailId=0
	for  //遍历其他描述的根节点
	{
		s detailId=$o(^User.MKBTermProDetailI("ProParIndex",proId,parentcatdr,detailId)) 
		q:(detailId="")||(textDetailId'="")
		s detailDesc=$LISTGET($G(^User.MKBTermProDetailD(detailId)),3)
		if (detailDesc="其他文本描述")
		{
			s textDetailId=detailId  //其他文本描述的节点id
		}
	}
	
	q:(textDetailId="") "{success:'false',errorinfo:'其他描述属性内容里没有其他文本描述这一节点！'}"
	s result=""
	s count=0	
	s detailId=0
	for  
	{	
		s detailId=$o(^User.MKBTermProDetailI("ProIdx",proId,detailId)) 
		q:(detailId="")||(result["false")
		s detailDesc=$LISTGET($G(^User.MKBTermProDetailD(detailId)),3)
		if ($ZCONVERT(detailDesc,"U")=$ZCONVERT(text,"U"))
		{
			s result= "{success:'false',errorinfo:'其他描述里已经有该内容了，不能重复添加！'}"
		}
		s detailLastLevel=$LISTGET($G(^User.MKBTermProDetailD(detailId)),4)
		if (detailLastLevel=textDetailId)
		{
			s count=count+1
		}
		if (count>=50)
		{
			s result="{success:'false',errorinfo:'其他文本描述已经超过50条了，请先去知识库整理为结构化文本描述！'}"
		}	
				
	}
	if (result["false")
	{
		q result
	}

	s genChildsub=$o(^User.MKBTermExtendProI("NameIndex",proId," 展示名",0))  //展示名的扩展属性id
	s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
	s eobj.MKBTPDProDR=proId
	s eobj.MKBTPDDesc=text
	s eobj.MKBTPDLastLevel=textDetailId
	s:genChildsub'="" eobj.MKBTPDExtend=genChildsub_"[A]"_text
	s result=..SaveData(eobj)	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-11-27
/// Description：往诊断模板里加数据,并给缺省展示格式赋值
/// Input：proId-诊断模板属性id,argstr-术语或属性id&展示类型&起始节点id&单选多选&是否必填&属性或术语标识，BOrA-加在前B/加在后A
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).AddDataToDiaTemplate(24654,"6&T&128907&S&N&T","B")
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).AddDataToDiaTemplate(24654,"24656&T&49648&S&N&P","A")
ClassMethod AddDataToDiaTemplate(proId As %String, addstr As %String, BOrA As %String) As %String
{
	q:(proId="")||(addstr="") "{success:'false',errorinfo:'没有获取到诊断模板的属性id或者要加的数据串！'}"
	//s proDesc=$LISTGET($G(^User.MKBTermPropertyD(proId)),3)
	//q:proDesc'="诊断模板" "{success:'false',errorinfo:'该属性不是诊断模板！'}"
	s proFlag=$LISTGET($G(^User.MKBTermPropertyD(proId)),8)
	q:proFlag'="DT" "{success:'false',errorinfo:'该属性不是诊断模板！'}"
	
	//新增的这个属性或者术语的缺省展示描述
	s TOrPRowId=$p(addstr,"&",1)  //术语属性id 或者术语id 
	q:TOrPRowId="" "{success:'false',errorinfo:'没有获取到属性或者术语id！'}"
    s treeNode=$p(addstr,"&",3) //定义起始节点
    s:treeNode="undefined" treeNode=""
  	s isTOrP=$p(addstr,"&",6)  //术语T或属性P
  	s TOrPDesc=""
  	if (isTOrP="T") //术语
  	{
      	s TOrPDesc=$LISTGET($G(^User.MKBTermBaseD(TOrPRowId)),3)
      	s:treeNode'="" TOrPDesc=##class(web.DHCBL.MKB.MKBTerm).GetDesc(treeNode)
  	}
  	elseif (isTOrP="ST") //部位、病因公有属性
  	{
	   	s baseFlag=$LISTGET($G(^User.MKBTermBaseD(TOrPRowId)),10)
		if (baseFlag="Part") //部位
		{
   			s TOrPDesc="部位"
		}
		elseif (baseFlag="Pathogeny") //病因
		{
   			s TOrPDesc="病因"
		}
  	}
  	else
  	{
	  	s TOrPDesc=$LISTGET($G(^User.MKBTermPropertyD(TOrPRowId)),3)
      	s:treeNode'="" TOrPDesc=..GetDesc(treeNode)
  	}	
	s emptyChild=$o(^User.MKBTermExtendProI("NameIndex",proId," 缺省展示效果",0)) //缺省展示效果扩展属性child
		
  	//保存到 诊断模板
	s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
	s eobj.MKBTPDProDR=proId
	s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0)) //属性内容的id	
	if (proDetailId'="")   //修改
	{		
		s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)	 //原先诊断模板的内容
		if (proDetailDesc[addstr)  //如果已经有这条数据了
		{
			s result = "{success:'true',id:'"_proDetailId_"'}" //返回RowId
			q result
		}		
		s eobj.MKBTPDRowId=proDetailId
		s eobj.MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),2)  //属性内容Code
			
		if (proDetailDesc'="")
		{		    
          	s emptyDesc=..GetExtendVal(proDetailId,proId,"缺省展示效果")   //缺省展示效果的值
			if (BOrA="B")  //放前面
			{
				s eobj.MKBTPDDesc=addstr_","_proDetailDesc
				
				if (emptyDesc'="")&(TOrPDesc'="")&(emptyChild'="")
				{
					s emptyDesc=$p(emptyDesc,"(",1)_"("_TOrPDesc_","_$p(emptyDesc,"(",2)
					s eobj.MKBTPDExtend=emptyChild_"[A]"_emptyDesc
				}
			}
			else  //放后面
			{
				s eobj.MKBTPDDesc=proDetailDesc_","_addstr
				if (emptyDesc'="")&(TOrPDesc'="")&(emptyChild'="")
				{
					s emptyDesc=$p(emptyDesc,")",1)_","_TOrPDesc_$p(emptyDesc,")",2)_")"
					s eobj.MKBTPDExtend=emptyChild_"[A]"_emptyDesc
				}
			}
		}
		else
		{
			s eobj.MKBTPDDesc=addstr
			if (TOrPDesc'="")&(emptyChild'="")
			{
				s emptyDesc=..GetTermCom(proId)_"("_TOrPDesc_")"
				s eobj.MKBTPDExtend=emptyChild_"[A]"_emptyDesc
			}
		}
	}
	else  //新增
	{
		s eobj.MKBTPDRowId=""
		s eobj.MKBTPDDesc=addstr	
		if (TOrPDesc'="")&(emptyChild'="")
		{
			s emptyDesc=..GetTermCom(proId)_"("_TOrPDesc_")"
			s eobj.MKBTPDExtend=emptyChild_"[A]"_emptyDesc
		}
	}
	s result=..SaveData(eobj)	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-11-27
/// Description：往诊断模板里加数据,并给缺省展示格式赋值
/// Input：proId-诊断模板属性id,termId-术语id（为空时默认引用通用描述）
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).AddPartToDiaTemplate(24654,16413)
ClassMethod AddPartToDiaTemplate(proId As %String, termId As %String) As %String
{
	q:(proId="") "{success:'false',errorinfo:'没有获取到诊断模板的属性id！'}"
	s termDr=$LISTGET($G(^User.MKBTermPropertyD(proId)),6)   //诊断id
	s result=""
	if (termId'="")
	{
		s baseId=$listGet($g(^User.MKBTermD(termId)),4)  //术语库注册id
		q:(baseId="") "{success:'false',errorinfo:'没有获取到术语库注册id！'}"
		s addstr=baseId_"&T&"_termId_"&S&N&T"
		s result=..AddDataToDiaTemplate(proId,addstr,"B")
	}
	else
	{
		s genBaseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("GenDesc")
		q:(genBaseId="") "{success:'false',errorinfo:'没有获取到术语库注册id！'}"
		s addstr=genBaseId_"&T&&S&N&T"
		s result=..AddDataToDiaTemplate(proId,addstr,"B")

	}
	if (result["true")&(termDr'="")
	{
		s ^TMP("mkbTermCR",termDr)=""
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-11-27
/// Description：批处理-往所有诊断的诊断模板里加两条数据：其他描述-其他结构化描述，其他描述-其他文本描述
/// Input：
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).AddTextToDiaTemplate()
ClassMethod AddTextToDiaTemplate() As %String
{
	s result=""
	s baseId=..GetBaseIDByFlag("Diagnose")  //诊断学临床实用诊断的术语库注册id
	q:(baseId="") "{success:'false',errorinfo:'没有获取到诊断学_临床实用诊断的术语库注册id！'}"
	
	if '($d(^User.MKBTermI("BaseIndex",baseId)))  //该术语库下有数据
	{
		s result="{success:'false',errorinfo:'诊断学_临床实用下没有数据！'}"
		q result
	}
	TS
	s termId=0
	for  
	{	
		s termId=$o(^User.MKBTermI("BaseIndex",baseId,termId)) q:(termId="")||(result["false") 
		s result=..AddTextToThisDiaTemplate(termId)
	}

	if (result["false")
	{
		Trollback
		s result= "{success:'false',errorinfo:'批处理失败'}"  //返回错误信息
	}
	else
	{
		Tcommit
		s result="{success:'true',info:'批处理成功！'}"
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-12-06
/// Description：往诊断模板里加两条数据：其他描述-其他结构化描述，其他描述-其他文本描述。（术语新增时要调用的接口)
/// Input：termId-术语id
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).AddTextToThisDiaTemplate(termId)
ClassMethod AddTextToThisDiaTemplate(termId As %String) As %String
{
	q:(termId="") "{success:'false',errorinfo:'没有获取到诊断！'}"
	
	s diaProId=$o(^User.MKBTermPropertyI("FlagIndex",termId," DT",0)) //诊断模板的属性ID 直接根据标识来获取  
	q:(diaProId="") "{success:'false',errorinfo:'没有获取到诊断模板属性！'}"
	//s textProId=$o(^User.MKBTermPropertyI("DescIndex",termId," 其他描述",0))
	s textProId=$o(^User.MKBTermPropertyI("FlagIndex",termId," OD",0)) //其他描述的属性ID 直接根据标识来获取  
	q:(textProId="") "{success:'false',errorinfo:'没有获取到其他描述属性！'}"
	//病情描述
	s ConditionProId=$o(^User.MKBTermPropertyI("DescIndex",termId," 病情描述",0)) //其他描述的属性ID 直接根据标识来获取  
	q:(ConditionProId="") "{success:'false',errorinfo:'没有获取到病情描述属性！'}"
	s result=""
	s structDetailId="" ,textDetailId=""  ,ConditionDetailId=""
	s parentcatdr=-100000000000000				
	s detailId=0
	for  //遍历其他描述的根节点
	{
		s detailId=$o(^User.MKBTermProDetailI("ProParIndex",textProId,parentcatdr,detailId)) 
		q:detailId=""
		s detailDesc=$LISTGET($G(^User.MKBTermProDetailD(detailId)),3)
		if (detailDesc="其他结构化描述")
		{
			s structDetailId=detailId   //其他结构化描述的节点id
		}
		if (detailDesc="其他文本描述")
		{
			s textDetailId=detailId  //其他文本描述的节点id
		}
	}

	s parentcatdr=-100000000000000
	s detailId=0
	for  //遍历病情描述的根节点
	{
		s detailId=$o(^User.MKBTermProDetailI("ProParIndex",ConditionProId,parentcatdr,detailId)) 
		q:(detailId="")||(ConditionDetailId'="")
		s detailDesc=$LISTGET($G(^User.MKBTermProDetailD(detailId)),3)
		if (detailDesc="病情")
		{
			s ConditionDetailId=detailId   //其他结构化描述的节点id
		}
	}
	//诊断模板加一列 其他描述（其他结构化描述）
	if (structDetailId'="")
	{
		s addstr=textProId_"&T&"_structDetailId_"&S&N&P"
		s result=..AddDataToDiaTemplate(diaProId,addstr,"A")
	}
	//诊断模板加一列 其他描述（其他文本描述）
	if (textDetailId'="")
	{
		s addstr=textProId_"&T&"_textDetailId_"&S&N&P"
		s result=..AddDataToDiaTemplate(diaProId,addstr,"A")
	}
	//诊断模板加一列 病情描述（病情）
	if (ConditionDetailId'="")
	{
		s addstr=ConditionProId_"&T&"_ConditionDetailId_"&S&N&P"
		s result=..AddDataToDiaTemplate(diaProId,addstr,"B")
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-12-09
/// Description：对选中的诊断模板进行批处理（部位、病因界面对相关诊断进行批处理的时候调用)
/// Input：diaIds-诊断id串，TempStrs-诊断模板id串
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).MultiAddDiaTemplate("16382,16381","6&T&128907&S&N&T,6&T&16412&S&N&T")
ClassMethod MultiAddDiaTemplate(diaIds As %String, TempStrs As %String) As %String
{
	s result=""
	q:(diaIds="") "{success:'false',errorinfo:'没有获取到要批处理的术语串！'}"
	q:(TempStrs="") "{success:'false',errorinfo:'没有获取到选中的诊断模板的数据！'}"
    s diaLen=$Length(diaIds,"^")
    for i=1:1:diaLen  
    {	     
      	s diaId=$p(diaIds,"^",i)
      	continue:diaId=""
	  	s diaProId=$o(^User.MKBTermPropertyI("FlagIndex",diaId," DT",0)) //诊断模板的属性ID 直接根据标识来获取  
	  	continue:diaProId=""
	  	s tempLen=$Length(TempStrs,",")
	  	s j=tempLen
	  	for 
	  	{
		  	q:j<1
		  	s addstr=$p(TempStrs,",",j)
		  	//新增的这个属性或者术语的缺省展示描述
		  	s isTOrP=$p(addstr,"&",6)  //术语T或属性P
		  	if (isTOrP="T")||(isTOrP="ST")
		  	{
				s result=..AddDataToDiaTemplate(diaProId,addstr,"B")
		  	}	
		  	s j=j-1
		  	
	  	}
	  	s ^TMP("mkbTermCR",diaId)=""

    }
    if (result["false")
	{
		q result
	}
	else
	{
		s result="{success:'true',info:'批处理成功！'}"
	}

    q result
}

/// Creator:谷雪萍
/// CreatDate:2018-12-06
/// Description：根据术语id获取到术语库注册的标识
/// Input：termId-术语id
/// Return:术语库注册的标识
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTermBaseFlag(termId)
ClassMethod GetTermBaseFlag(termId As %String) As %String
{
	q:termId="" "" 
	s termBaseFlag=""
	s termBaseDR=$listGet($g(^User.MKBTermD(termId)),4)  //术语库注册id
	if (termBaseDR'="")
	{
    	s termBaseFlag=$listGet($g(^User.MKBTermBaseD(termBaseDR)),10)
	}
    q termBaseFlag
}

/// Creator:谷雪萍
/// CreatDate:2018-12-13
/// Description：获取其他描述下-其他文本描述下的内容(拼串)——给诊断录入界面提供的接口
/// Input：detailId-其他文本描述的id
/// Return:其他描述下-其他文本描述下的内容串——id1^中心词1[A]id1^中心词1
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocOtherTextDescStr(detailId)
ClassMethod GetDocOtherTextDescStr(detailId As %String) As %String
{
    s result=""
    q:(detailId="") ""
    s property=$LISTGET($G(^User.MKBTermProDetailD(detailId)),6)  //属性id
    q:(property="") ""
	s textDetailIds=..GetChildOrderedIDStr(detailId,property)  //其他文本描述下的所有子节点的id串
	s idsLen=$Length(textDetailIds,"^")
	for i=1:1:idsLen
	{
		s textDetailId=$p(textDetailIds,"^",i)
		continue:textDetailId=""
		s textDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(textDetailId)),3)		
		s:result'="" result=result_"[A]"
		s result=result_textDetailId_"^"_textDetailDesc
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-12-25
/// Description：获取常用模板项信息
/// Input：itemType-常用模板项类型(Type-分型，GenDesc-通用描述，Pathogeny-病因，Part-部位，LR-左右),property-诊断模板属性id，PrivatePath-病因，PrivatePart-部位
/// Return:result-术语或属性id&展示类型&起始节点id&单选多选&是否必填&属性或术语标识&格式&属性/术语描述
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetComTempleteInfo(itemType,property)
ClassMethod GetComTempleteInfo(itemType As %String, property As %String) As %String
{
	s result=""
	q:(property="")||(itemType="") ""
	s diaId=$LISTGET($G(^User.MKBTermPropertyD(property)),6)  //诊断id
	q:diaId="" ""
	if (itemType="Type")  //分型
	{

		s proId=$o(^User.MKBTermPropertyI("DescIndex",diaId," 病情描述",0))  //病情描述的属性ID 直接根据描述来获取 
		q:proId="" ""
		s result=proId_"&T&&S&N&P&T&病情描述"		
	}
	if (itemType="GenDesc")  //通用描述Part,Pathogeny,GenDesc
	{
		s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("GenDesc")  //通用描述的术语库注册id
		q:baseId="" ""
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(baseId)),3)
 		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(baseId)),4)
		s result=baseId_"&T&&S&N&T&"_MKBTBType_"&"_MKBTBDesc
	}
	if (itemType="Part")  //部位
	{
		s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Part")  //部位的术语库注册id
		q:baseId="" ""
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(baseId)),3)
 		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(baseId)),4)
 		s definedNode=""
		s proId=$o(^User.MKBTermPropertyI("DescIndex",diaId," 部位",0))  //部位的属性ID 直接根据描述来获取
		if (proId'="")
		{
			s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0))  //属性内容id		
			s:proDetailId'="" definedNode=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)  //属性内容中心词
		}
		s result=baseId_"&T&"_definedNode_"&S&N&ST&"_MKBTBType_"&部位"
	}
	if (itemType="Pathogeny")  //病因
	{
		s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Pathogeny")  //部位的术语库注册id
		q:baseId="" ""
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(baseId)),3)
 		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(baseId)),4)
 		s definedNode=""
		s proId=$o(^User.MKBTermPropertyI("DescIndex",diaId," 病因",0))  //部位的属性ID 直接根据描述来获取
		if (proId'="")
		{
			s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0))  //属性内容id	
			s:proDetailId'="" definedNode=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)  //属性内容中心词
		}
		s result=baseId_"&T&"_definedNode_"&S&N&ST&"_MKBTBType_"&病因"
	}
	if (itemType="LR")  //左右
	{
		s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("GenDesc")  //通用描述的术语库注册id
		q:baseId="" ""
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(baseId)),3)
 		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(baseId)),4)
		s definedNode=$o(^User.MKBTermI("DescIndex",baseId," 左右",0))
		s result=baseId_"&T&"_definedNode_"&S&N&T&"_MKBTBType_"&左右"
	}
	if (itemType="PrivatePart")  //私有部位
	{
		s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Part")  //部位的术语库注册id
		q:baseId="" ""
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(baseId)),3)
 		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(baseId)),4)
		s result=baseId_"&T&&S&N&T&"_MKBTBType_"&"_MKBTBDesc
	}
	if (itemType="PrivatePath")  //私有病因
	{
		s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Pathogeny")  //部位的术语库注册id
		q:baseId="" ""
		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(baseId)),3)
 		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(baseId)),4)
		s result=baseId_"&T&&S&N&T&"_MKBTBType_"&"_MKBTBDesc
	}

	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-12-25
/// Description：批处理-遍历所有诊断的诊断模板，把直接引用术语的那些都变为2次引用
/// Input：
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GoThroAllDiaTemplate()
ClassMethod GoThroAllDiaTemplate() As %String
{
	s result=""
	s baseId=..GetBaseIDByFlag("Diagnose")  //诊断学临床实用诊断的术语库注册id
	q:(baseId="") "{success:'false',errorinfo:'没有获取到诊断学_临床实用诊断的术语库注册id！'}"
	
	if '($d(^User.MKBTermI("BaseIndex",baseId)))  //该术语库下有数据
	{
		s result="{success:'false',errorinfo:'诊断学_临床实用下没有数据！'}"
		q result
	}
	TS
	s dia=0
	for  
	{	
		s dia=$o(^User.MKBTermI("BaseIndex",baseId,dia)) q:(dia="")||(result["false") 

		s proId=$o(^User.MKBTermPropertyI("FlagIndex",dia," DT",0)) //诊断模板的属性ID 直接根据标识来获取    
		if (proId'="")
		{
			s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0)) //属性内容的id
			
			if (proDetailId'="")
			{
				s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)   //属性内容
				if (proDetailDesc'="")
				{
					s newDetailDesc= ..ChangeDiaTempleteDesc(dia,proDetailDesc)
					if (newDetailDesc="")
					{
						s result= ..DeleteData(proDetailId)
					}
					else
					{
						s obj=##class(User.MKBTermProDetail).%OpenId(proDetailId)	
						s obj.MKBTPDDesc = newDetailDesc
						s sc=obj.%Save()
						d obj.%Close()
						If $$$ISOK(sc)
						{
							s id = obj.%Id()  						
						    d ##class(web.DHCBL.MKB.MKBTermProDetail).UseReferenceInfo("P",id,proDetailId,proDetailDesc,newDetailDesc)
						}
						else
						{
							s result="false"
						}
					}
				}
			}
		}
	}

	if (result["false")
	{
		Trollback
		s result= "{success:'false',errorinfo:'批处理失败'}"  //返回错误信息
	}
	else
	{
		Tcommit
		s result="{success:'true',info:'批处理成功！'}"
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2019-01-31
/// Description：批处理-所有诊断的分型都改为病情描述，病情描述下增加一级节点病情
/// Input：proDesc-属性描述，detailDesc-要添加的属性内容中心词
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GoThroAllDiaAddDetail("病情描述","病情")
ClassMethod GoThroAllDiaAddDetail(proDesc As %String, detailDesc As %String) As %String
{
	s result=""
	q:(proDesc="")||(detailDesc) "{success:'false',errorinfo:'属性名或内容不能为空'}"
	s baseId=..GetBaseIDByFlag("Diagnose")  //诊断学临床实用诊断的术语库注册id
	q:(baseId="") "{success:'false',errorinfo:'没有获取到诊断学_临床实用诊断的术语库注册id！'}"
	
	if '($d(^User.MKBTermI("BaseIndex",baseId)))  //该术语库下有数据
	{
		s result="{success:'false',errorinfo:'诊断学_临床实用下没有数据！'}"
		q result
	}
	
	s proDesc=" "_$ZCONVERT(proDesc,"U") //转换成大写
	TS
	s dia=0
	for  
	{	
		s dia=$o(^User.MKBTermI("BaseIndex",baseId,dia)) q:(dia="")||(result["false") 
		s proId=$o(^User.MKBTermPropertyI("DescIndex",dia,proDesc,0))  //诊断模板的属性ID 直接根据描述来获取   
		if (proId'="")
		{
			s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDRowId = ""
			s eobj.MKBTPDDesc = detailDesc
			s eobj.MKBTPDProDR = proId
			s res=..SaveData(eobj)
			d eobj.%Close()
			if (res["false")&'(res["该记录已经存在")
			{
				s result=res
			}		
		}
	}

	if (result["false")
	{
		Trollback
		s result= "{success:'false',errorinfo:'批处理失败'}"  //返回错误信息
	}
	else
	{
		Tcommit
		s result="{success:'true',info:'批处理成功！'}"
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2019-07-26
/// Description：删除诊断模版-引用起始节点类型的模版项时，要同步删除该属性
/// Input：proIds-属性id串（由^拼成）
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).DeletePropertys(proIds)
ClassMethod DeletePropertys(proIds As %String) As %String
{
	s result=""
	s proIdsLen=$l(proIds,"^")
	for i=1:1:proIdsLen
	{
		s proId=$p(proIds,"^",i)
		if (proId'="")
		{
			s MKBTPPublic=$LISTGET($G(^User.MKBTermPropertyD(proId)),9)
			if (MKBTPPublic="Y") continue  //如果是公有属性则不删除
			s result=##class(web.DHCBL.MKB.MKBTermProperty).DeleteData(proId)
			if (result["false")
			{
				q
			}
		}
		
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：生成索引-过滤特殊字符
/// Input：str-字符串
/// Return:str-过滤后的字符串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).Filter("血、尿、便常规")
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

/// Creator：陈代雷
/// CreatDate:2019-11-25
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.BDPItemCategory
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).NewGetSourseJsonDataForCmb("6","16449",",525737,16388,16389,16392,129357,")
ClassMethod NewGetSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	w "["
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
			s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码
			if (MKBTPYCode'="")
			{
				s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
			}
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(myRowID)  //常用名别名及拼音码
			s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
			s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
			s MKBTPYCode=MKBTPYCode_"&%"_strCom_"&%"_strAlias
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_Caption_"<span class='hidecls'>"_MKBTPYCode_"</span>"""
			w ",""state"":""open"""
			
			s strId=","_myRowID_","
			
			//s childStr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,myRowID)
			//if childStr'=""
			if $d(^User.MKBTermI("ParentIndex",base,myRowID))
			{
				if (selItemIds[strId){
					w ",""checked"":true"
				}
				w ",""children"":"
				w ..NewGetSourseJsonDataForCmb(base,myRowID,selItemIds)	
			}
			else
			{
				if (selItemIds[strId){
					w ",""checked"":true"
				}
				else{
					w ",""checked"":false"
				}
			
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator:陈代雷
/// CreatDate:2019-11-25
/// Description：给医生站提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseTreeJson("","8819567")
ClassMethod GetDocSourseTreeJson(LastLevel As %String, property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"
	
	s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
	
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w "["
		w ($replace(..NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds),"}{","},{"))_"]"
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
			//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]" //判断是否显示封闭数据	
			
		s strId=","_definedNode_","
		if (selItemIds[strId){
				
			s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
			s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
			s MKBTNote=$LISTGET($G(^User.MKBTermD(definedNode)),7)  //备注
			s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(definedNode)
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码

			s spanDesc=comDesc_"^"_MKBTPYCode_"^"_definedNodeDesc_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
			s definedNodeDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",definedNodeDesc) //多语言改造
		
			w "["
			w "{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_spanDesc_"</span>"""
			w ",""state"":""open"""

			if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
			{
				w ",""children"":["
				w ($replace(..NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds),"}{","},{"))_"]"
			}
			w "}"
			w "]"
		}
		else{
			w "["
			w ($replace(..NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds),"}{","},{"))_"]"
		}
		
	}
	
	q ""
}

/// Creator：陈代雷
/// CreatDate:2019-11-25
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.MKBTerm
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).NewGetDocSourseJsonDataForCmb("6","",",16449,16393,16385,129357,16388,525737,16389,")
ClassMethod NewGetDocSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	//输出树形JSON串
	s count=0
	s str=""
	s childStr=""
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s strId=","_myRowID_","
			if '(selItemIds[strId)
			{	//w myRowID_" "
				s str=str_..NewGetDocSourseJsonDataForCmb(base,myRowID,selItemIds)
			}
			else
			{
				//封闭的数据不显示
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
				continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
				s count=count+1
				s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
				s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
				s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)  //备注
				s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(myRowID)  ////常用名
				s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码
				s spanDesc=comDesc_"^"_MKBTPYCode_"^"_Caption_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
				s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
				//s Caption=$tr(Caption,"""","")
				s Caption = ##class(websys.Translation).Get("diagnosentry.v8.csp",Caption) //多语言改造
				if count>1 s str=str_","
				s str=str_"{""id"":"""_myRowID_""",""text"":"""_Caption_"<span class='hidecls'>"_spanDesc_"</span>"""
				s str=str_",""state"":""open"""
				s childStr=..GetDocChildOrderedIDStr(base,myRowID,selItemIds)
				if childStr'=""
				{	
					s str=str_",""children"":["
					s str=str_..NewGetDocSourseJsonDataForCmb(base,myRowID,selItemIds)_"]"	
				}
		
				s str=str_"}"
				if childStr=""
				{
					s str=str_..NewGetDocSourseJsonDataForCmb(base,myRowID,selItemIds)
				}
			}
		}
	}
	q str
}

/// Creator:谷雪萍
/// CreatDate:2018-05-08
/// Description：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Input: property:属性id
/// return:引用术语的- 起始节点父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).NewGetSourseTreeTermJson("","7")
ClassMethod NewGetSourseTreeTermJson(property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"

	s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)	
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
	
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w ..NewGetSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]" //判断是否显示封闭数据		
		s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
		s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
		s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码
		if (MKBTPYCode'="")
		{
			s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
			s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
		}
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(definedNode)  //常用名别名及拼音码
		s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
		s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
		s MKBTPYCode=MKBTPYCode_"&%"_strCom_"&%"_strAlias
		
		w "["
		w "{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_MKBTPYCode_"</span>"""
		w ",""state"":""open"""
		
		s strId=","_definedNode_","
		
		if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
		{
			w ",""children"":"
			w ..NewGetSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
		}
		else
		{
			if (selItemIds[strId){
				w ",""checked"":true"
			}
			else{
				w ",""checked"":false"
			}
		}
		w "}"
		w "]"
		
	}
	
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2020-02-19
/// Description：批处理某个属性内容的描述
/// Input：baseDesc-知识库描述，proDesc-属性描述，olddetailDesc-修改前的属性内容中心词名,newdetailDesc-修改后的属性内容中心词名
/// Return:true/false及详细信息
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).BatchChangeDetailDesc("江苏省中医治疗手术","手术描述","手术分类","整理")
ClassMethod BatchChangeDetailDesc(baseDesc As %String, proDesc As %String, olddetailDesc As %String, newdetailDesc As %String) As %String
{
	s result=""
	q:(proDesc="")||(proDesc)||(olddetailDesc="")||(newdetailDesc="") "{success:'false',errorinfo:'参数不能为空'}"
	s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc(baseDesc)  //术语库注册id
	q:(baseId="") "{success:'false',errorinfo:'没有获取到知识库注册id！'}"
	
	if '($d(^User.MKBTermI("BaseIndex",baseId)))  //该术语库下有数据
	{
		s result="{success:'false',errorinfo:'该知识库下没有数据！'}"
		q result
	}
	
	s proDesc=" "_$ZCONVERT(proDesc,"U") //转换成大写
	TS
	s termId=0  
	for  
	{	
		s termId=$o(^User.MKBTermI("BaseIndex",baseId,termId)) q:(termId="")||(result["false")   //遍历该知识库下的术语
		s proId=$o(^User.MKBTermPropertyI("DescIndex",termId,proDesc,0))  //根据属性描述来获取属性ID   
		if (proId'="")
		{
			s comChildsub=$o(^User.MKBTermExtendProI("NameIndex",proId," 展示名",0))  //展示名的扩展属性id
			s aliasChildsub=$o(^User.MKBTermExtendProI("NameIndex",proId," 别名",0))  //别名的扩展属性id
			s flag=0  //已经处理的标识
			s MKBTPDRowId=0
			for  
			{	
				s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",proId,MKBTPDRowId)) q:(MKBTPDRowId="")||(flag=1)  //遍历改属性下的属性内容
				
				s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
				if (MKBTPDDesc=olddetailDesc)  //找到要修改的属性内容
				{
					s flag=1
					s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
					s eobj.MKBTPDRowId = MKBTPDRowId
					s eobj.MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),2)
					s eobj.MKBTPDDesc = newdetailDesc
					s eobj.MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),4)
					s eobj.MKBTPDLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),5)
					s eobj.MKBTPDProDR = $LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),6)		
					s eobj.MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
					s eobj.MKBTPDActiveFlag=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),8)
					s eobj.MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9)
					s eobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(newdetailDesc)
					s eobj.MKBTPDExtend=comChildsub_"[A]"_newdetailDesc_"[N]"_aliasChildsub_"[A]"
					s res=..SaveData(eobj)
					d eobj.%Close()
					if (res["false")&(res'["该记录已经存在")
					{
						s result=res
					}	
				}
			}	
		}
	}

	if (result["false")
	{
		Trollback
		s result= "{success:'false',errorinfo:'批处理失败'}"  //返回错误信息
	}
	else
	{
		Tcommit
		s result="{success:'true',info:'批处理成功！'}"
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2020-05-15
/// Description:根据术语id 返回文本格式的属性内容，展示在父级和描述下面
/// Input:termid-术语id
/// return：获取ICD11文本类型的属性内容
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetICD11TextDetail(termid)
ClassMethod GetICD11TextDetail(termid As %String) As %String
{
	q:(termid="") ""
	//遍历属性表
	s result=""
	s MKBTPRowId=0
	for 
	{
		s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termid,MKBTPRowId)) q:MKBTPRowId=""
		s MKBTPDesc = $listGet($g(^User.MKBTermPropertyD(MKBTPRowId)),3)  //属性描述
		s MKBTPType = $listGet($g(^User.MKBTermPropertyD(MKBTPRowId)),4)  //属性方式
		if (MKBTPType="TX")||(MKBTPType="TA")
		{
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
			s MKBTPDDesc=""
			s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			if (MKBTPDDesc'="")
			{
				s PropertyDetailDesc=MKBTPDesc_"^"_MKBTPDDesc
				if (result'="")
				{
					s result=result_"&%"_PropertyDetailDesc
				}
				else
				{
					s result=PropertyDetailDesc
				}
			}
		}
		
	}

	q result
}

/// Creator:谷雪萍
/// CreatDate:2020-05-15
/// Description:根据术语id 获取ICD11是否有效
/// Input:termid-术语id
/// return：获取ICD11是否有效 返回"是"则有效，其他情况则无效
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetICD11Active(termid)
ClassMethod GetICD11Active(termid As %String) As %String
{
	q:(termid="") ""

	s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",termid," 是否为有效码",0))  //属性id
	q:MKBTPRowId="" ""
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
	s MKBTPDDesc=""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
	q MKBTPDDesc
}

/// Creator:谷雪萍
/// CreatDate:2020-05-15
/// Description:把ICD11备注中的数据转移到是否为有效码字段中
/// Input:baseId-知识库注册id
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).MoveICD11NoteToActive(baseId)
ClassMethod MoveICD11NoteToActive(baseId)
{
	q:baseId="" ""
	TS
	s result=""
	s flag=""
	s TermId=0
	for
	{
		s TermId=$o(^User.MKBTermI("BaseIndex",baseId,TermId))
		q:TermId=""
		s obj=##class(User.MKBTerm).%OpenId(TermId)
		s Active=obj.MKBTNote
		continue:(Active'="是")&(Active'="否")		
		s obj.MKBTNote=""
		s obj.MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(obj.MKBTDesc)
		s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(obj.MKBTPYCode)
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",TermId," 是否为有效码",0))  //属性id
			continue:(MKBTPRowId="")||(Active="")
			s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
			s eobj.MKBTPDRowId=MKBTPDRowId
			s eobj.MKBTPDDesc=Active
			s eobj.MKBTPDProDR=MKBTPRowId
			s result=..SaveData(eobj)
			if (result["false")
			{
				b ;
				s flag="N"
				q
			}
			
		}
		else
		{
			s flag="N"
			q
		}
	}
	if (flag'="")
	{
		s result="批处理失败"
		tro
	}
	else
	{
		s result="批处理成功"
		tc
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2021-03-02
/// Description:编辑数据时保存责任人
/// Input:termId-术语id
/// Return:true/false及错误信息
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).SavePersonLiable(termId)
ClassMethod SavePersonLiable(TermId)
{
	s result=""
	q:TermId="" "{success:'false',info:'没获取到术语id，责任人保存失败！'}"  //返回错误信息
	s PropertyId=$o(^User.MKBTermPropertyI("DescIndex",TermId," 责任人",0)) //属性id
	q:PropertyId="" "{success:'true',info:'没有责任人属性不需要保存！'}"  
	s UserName=$g(%session.Data("LOGON.USERNAME"))
	q:UserName="" "{success:'false',info:'没有获取到责任人保存失败！'}" 
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",PropertyId,0))   //属性内容id
	s MKBTPDCode=""
	s:MKBTPDRowId'="" MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),2)
	s:MKBTPDCode="" MKBTPDCode=..GetLastCode(PropertyId)
	if (MKBTPDRowId="")  //如果RowId未赋值则增加
	{
		s obj=##class(User.MKBTermProDetail).%New()
	}
	else  //如果RowId已赋值则修改
	{
		s obj=##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)	
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

/// Creator:钟荣枫
/// CreatDate:2021-2-2
/// Description:根据结构化结果，在常用诊断表达式中找到相同结构化结果的项
/// Input:property  structstr 结构化串 eg:伤寒[轻型]
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSameProValValueID("9439792","14727:226601")
ClassMethod GetSameProValValueID(property, structstr)
{
	s RowID=""
	s endflag=0
	s subId=0  //循环扩展属性子表User.MKBTermProperty
	for 
	{
		S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
		s MKBTPDRowId=0
		q:endflag=1
		for 
		{
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) 
			q:MKBTPDRowId="" 
			q:endflag=1
			s MKBTEPVValueStr=..GetExtendProValValue(property,subId,MKBTPDRowId)
			s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
			s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2) 
			if (structstr=MKBTEPVValueF)		//获取相同结构化结果的id
			{
				s RowID=MKBTPDRowId
				s endflag=1
			}
		}
	}
	q RowID
}

/// Creator:谷雪萍
/// CreatDate:2021-06-16
/// Description:获取百科的某一个属性的内容
/// Input:baseDesc-检查/检验/手术/护理，termDesc-检查名称/检验名称/手术名称/护理名称，proDesc-属性名称
/// Return:Json 数据，其中MKBTPDRowId为属性内容id，MKBTPDDesc为属性内容描述
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetWikiProDetails("检验","血常规","注意事项")
ClassMethod GetWikiProDetails(baseDesc As %String, termDesc As %String, proDesc As %String)
{
	s result=""
	q:(baseDesc="")||(termDesc="")||(proDesc="") result
	
	s baseId=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc(baseDesc)  //术语库注册id
	q:baseId="" result
	s termId=$o(^User.MKBTermI("DescIndex",baseId," "_($ZCONVERT(termDesc,"U")),0))   //百科中心词ID
	q:termId="" result
	s proId=$o(^User.MKBTermPropertyI("DescIndex",termId," "_($ZCONVERT(proDesc,"U")),0))  //根据属性描述来获取属性ID  
	q:proId="" result 
	s total=0
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",proId,MKBTPDRowId)) q:(MKBTPDRowId="") //遍历改属性下的属性内容		
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
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

/// Creator:谷雪萍
/// CreatDate:2021-07-06
/// Description:删除多余属性内容数据
/// Input:
/// Return:"over"
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteSurplusDetails()
ClassMethod DeleteSurplusDetails()
{
	s MKBTRowId=0 //遍历术语表
	for  
	{	
		s MKBTRowId=$o(^User.MKBTermD(MKBTRowId)) 
		q:MKBTRowId="" 
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //术语中心词
		s MKBTPRowId=0  //遍历属性表
		for 
		{
			s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId)) q:MKBTPRowId="" 
			s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)  //属性名
			s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)  //属性格式
			if (MKBTPType="TX")||(MKBTPType="TA")||(MKBTPType="ETX") //文本、多行文本框、文本编辑器后台应该只存一条数据
			{
				s count=0
				s MKBTPDRowId=0 //遍历属性内容表
				for  
				{	
					s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
					q:MKBTPDRowId="" 
					s count=count+1
					if (count>1)
					{
						d ..DeleteData(MKBTPDRowId)
						w MKBTDesc_"-"_MKBTPDesc,!
					}					
				}
			}
		}
	}
	q "over"
}

/// Creator:高姗姗
/// CreatDate:2021-09-08
/// Description:获取检索标识，根据检索模式返回是否符合检索条件
/// Input:Desc描述，PinYin描述拼音，q检索条件，SearchMode检索模式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSearchFlag()
ClassMethod GetSearchFlag(Desc As %String, PinYin As %String, q As %String, SearchMode As %String = "") As %String
{
 
   s result=0
   if (q="") q 1
   if (q'="")&(Desc="") q 0
   s:Desc'="" Desc=$zcvt(Desc,"U")
   s:PinYin'="" PinYin=$zcvt(PinYin,"U")
   s:q'="" q=$zcvt(q,"U")
   if (PinYin="")
   {
    	s PinYin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc) 
   } 
    ;1 检索模式为空 模糊检索
    if (SearchMode="")
    {
        if ((Desc[q)||(PinYin[q))
        { 
          s result=1
        }
    }
     
    ;2检索模式 A 精确检索  
     if (SearchMode="A")
     {
        if ((Desc=q)||(PinYin=q)) 
        { 
           s result=1
        }
     }
          
     ;3 检索模式 L 左匹配检索
     if (SearchMode="L")
     { 
        s qLen=$length(q)
        s DescSub=$e(Desc,1,qLen)  
        s PinYinSub=$e(PinYin,1,qLen)  

        if ((DescSub[q)||(PinYinSub[q))
        {
            s result=1
        }   
     }   
   q result
}

}

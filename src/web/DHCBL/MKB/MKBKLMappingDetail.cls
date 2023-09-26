/// Creator:基础数据平台组-谷雪萍
/// CreatDate:2018-05-15
/// Description：医用知识库规则管理明细表 增、删、改、查方法类
/// Table：User.MKBKLMappingDetail
Class web.DHCBL.MKB.MKBKLMappingDetail Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description：获取医用知识库规则管理明细表的数据
/// Input：rowid-行号，desc-描述, base-规则注册表id, searchConfigs-检索列，unsearchConfigs-非检索列，rows-每页显示条数, page-页数,allEn-检索内容是否是英文的标识Y
/// Return:Json格式的数据
/// Other:d ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMyList("","1","","","",10,1)
ClassMethod GetMyList(rowid, base, desc, searchConfigs, unsearchConfigs, rows, page, allEn) As %String
{
	s result="",total=0,jsonstr=""

	if (base="")
	{
		w "{""rows"":[], ""total"":0}"
	}
	else
	{
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
			
			s total=1
			s MKBKMDRowNum=rowid  //行号
			s ExtendStr=""   //知识点扩展属性子表的字段
			s K1Child="",K2Child=""
			s MKBKMBFSequence = 0
			for
			{
				s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
				q:MKBKMBFSequence=""
						
				s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
				s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)   //字段格式
				s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)	  //字段配置项

				
				if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child="")
				{
					s K1Child=MKBKMBFChildSub
				}
				if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child="")
				{
					s K2Child=MKBKMBFChildSub
				}
						
				s MKBKMDValueStr=..GetMappingDetailValue(base, MKBKMBFChildSub,MKBKMDRowNum,K1Child,K2Child)	//获取规则管理明细表的值
				
				s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
				s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
				s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
				if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
				{
					s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
				}
						
				s:ExtendStr'="" ExtendStr=ExtendStr_","
				s ExtendStr=ExtendStr_thisStr
				/*s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
			    s:ExtendStr="" ExtendStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""*/		    
			    
			}

			s mainstr=""
			s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_""","_ExtendStr_"}"
			s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_"""}"

			//s jsonstr=mainstr
			
			w mainstr

		}
		else
		{
			s K1K2ChildStr=..GetK1AndK2EditChild(base)   //获取知识点1和知识点2的编辑列
			s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
			s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
			s pageFlag=0   //
			s MKBKMDRowNum=0
			for  
			{	
				s MKBKMDRowNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",base,MKBKMDRowNum)) q:MKBKMDRowNum="" 
				s ExtendStr=""   //知识点扩展属性子表的字段
				
				s searchStr=""   //检索列的值拼串
				s searchStrPY=""   //检索列的值检索码				
				if (searchConfigs="")  //如果配置检索项为空
				{
					if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
					{
						
					}
					else
					{
						s MKBKMBFSequence = 0
						for
						{
							s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
							q:MKBKMBFSequence=""
							s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
							
							s MKBKMDValueStr=..GetMappingDetailValue(base, MKBKMBFChildSub,MKBKMDRowNum,K1Child,K2Child)  //获取规则管理明细表的值
							
							s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
							s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
							s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
							if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
							{
								s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
							}					 			 		
							s:ExtendStr'="" ExtendStr=ExtendStr_","
							s ExtendStr=ExtendStr_thisStr
												
							//s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
						    //s:ExtendStr="" ExtendStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
						    //检索串
						    if (MKBKMDValue'="")
							{
							 	s:searchStr'="" searchStr=searchStr_"^"_MKBKMDValue
							 	s:searchStr="" searchStr=MKBKMDValue
							}
						}
					}
					
					
					if ((searchStr'="")&(desc'="")&(allEn="Y"))
					{	
						s searchStrPY= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(searchStr)
					}
					i (($ZCONVERT(searchStr,"U")[desc)||(searchStrPY[desc))   //条件
					{
						s total=total+1
					    if (total<stpage) continue
					    if (total<=endpage)
					    {
							s mainstr=""
							s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_""","_ExtendStr_"}"
							s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_"""}"
							
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
				else  //如果配置检索项不为空
				{
					s mainstr=""
					s searchStr=""   //检索列的值拼串
					if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
					{
						
					}
					else
					{
						s argsLen=$Length(searchConfigs,"^")
						for i=1:1:argsLen
						{
							//获取检索列的数据
							s fieldid=$p(searchConfigs,"^",i)
							s MKBKMBFChildSub=$p(fieldid,"||",2)
							s MKBKMDValueStr=..GetMappingDetailValue(base, MKBKMBFChildSub,MKBKMDRowNum,K1Child,K2Child)  //获取规则管理明细表的值
					 		s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
							s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
							s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
							if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
							{
								s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
							}					 			 		
							s:ExtendStr'="" ExtendStr=ExtendStr_","
							s ExtendStr=ExtendStr_thisStr
							
							 //检索串	
							if (MKBKMDValue'="")
							{
								s:searchStr'="" searchStr=searchStr_"^"_MKBKMDValue
								s:searchStr="" searchStr=MKBKMDValue
							}
							//s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
							//s:ExtendStr="" ExtendStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
						}
					}
				
					if ((searchStr'="")&(desc'="")&(allEn="Y"))
					{	
						s searchStrPY= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(searchStr)
					}
					
					if (($ZCONVERT(searchStr,"U")[desc)||(searchStrPY[desc))
					{
						s total=total+1
					    if (total<stpage) continue
					    if (total<=endpage)
					    {
						     //获取未检索列的数据
						    s argsLen=$Length(unsearchConfigs,"^")
							for i=1:1:argsLen
							{
								s fieldid=$p(unsearchConfigs,"^",i)
								s MKBKMBFChildSub=$p(fieldid,"||",2)
								s MKBKMDValueStr=..GetMappingDetailValue(base, MKBKMBFChildSub,MKBKMDRowNum,K1Child,K2Child) //获取规则管理明细表的值
								s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
								s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
								s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
								if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
								{
									s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
								}			 		
								s:ExtendStr'="" ExtendStr=ExtendStr_","
								s ExtendStr=ExtendStr_thisStr	
								//s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
								//s:ExtendStr="" ExtendStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
							}
							s mainstr=""
							s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_""","_ExtendStr_"}"
							s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_"""}"
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
	}
	//s result="{""rows"":["_jsonstr_"], ""total"":"_total_"}"
	q ""
}

/// 李欣 20180815
/// 获取术语在映射表中对照的信息
/// Input:KBRowId 映射注册表id TBRowId TermBase表ID TermId 诊断术语Id 其余参数参照MappingDetail的GetMyList
/// d ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetInfoByTermId(10,12464,"","","",10,1)
ClassMethod GetInfoByTermId(MBRowId, TBRowId, TermId, desc, searchConfigs, unsearchConfigs, rows, page, allEn)
{
	s result="",total=0,jsonstr=""
	
	if ((MBRowId'="")&&(TermId'=""))
	{
		if (TBRowId="A")
		{
			if ($D(^User.MKBReferenceI("InverAllIndex","ASS",TermId,"MD"))'=0)
			{
				s MDRowId = 0
				for
				{
					s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","ASS",TermId,"MD",MDRowId))	
					q:MDRowId=""
					continue:($D(^User.MKBKLMappingDetailI("BaseIndex",MBRowId,MDRowId))=0)	
					s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
					s RNArr(RowNum)=""
				}	
			}	
		}
		elseif (TBRowId="D")
		{
			if ($D(^User.MKBReferenceI("InverAllIndex","DOC",TermId,"MD"))'=0)
			{
				s MDRowId = 0
				for
				{
					s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","DOC",TermId,"MD",MDRowId))	
					q:MDRowId=""
					continue:($D(^User.MKBKLMappingDetailI("BaseIndex",MBRowId,MDRowId))=0)	
					s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
					s RNArr(RowNum)=""
				}	
			}		
		}
		else
		{
			if ($D(^User.MKBReferenceI("InverAllIndex","T",TermId,"MD"))'=0)
			{
				s MDRowId = 0
				for
				{
					s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",TermId,"MD",MDRowId))	
					q:MDRowId=""
					continue:($D(^User.MKBKLMappingDetailI("BaseIndex",MBRowId,MDRowId))=0)	
					s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
					s RNArr(RowNum)=""
				}	
			}	
		}
		
	}
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s:desc'="" desc=$ZCONVERT(desc,"U")
	w "{""rows"":["
	
	s K1K2ChildStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetK1AndK2EditChild(MBRowId)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
	
	s RowNum=0
	for  
	{	
		s RowNum=$o(RNArr(RowNum)) 
		q:RowNum=""
		 
		s ExtendStr=""   //知识点扩展属性子表的字段
		
		if (searchConfigs="")  //如果配置检索项为空
		{
			s searchStr=""   //检索列的值拼串
			s searchStrPY=""   //检索列的值检索码	
			if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
			{
				
			}
			else
			{
				s MKBKMBFSequence = 0
				for
				{
					s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MBRowId,MKBKMBFSequence))
					q:MKBKMBFSequence=""
					s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MBRowId,MKBKMBFSequence,0))
					
					s MKBKMDValueStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(MBRowId, MKBKMBFChildSub,RowNum,K1Child,K2Child)  //获取知识点映射明细表的值
					
					s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
					s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
					s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
					if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
					{
						s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
					}					 			 		
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
										
				    //检索串
				    if (MKBKMDValue'="")
					{
					 	s:searchStr'="" searchStr=searchStr_"^"_MKBKMDValue
					 	s:searchStr="" searchStr=MKBKMDValue
					}
				}
			}
			if ((searchStr'="")&(desc'="")&(allEn="Y"))
			{	
				s searchStrPY= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(searchStr)
			}
			i (($ZCONVERT(searchStr,"U")[desc)||(searchStrPY[desc))   //条件
			{
				s total=total+1
				if (total<stpage) continue
				if (total<=endpage)
				{
					s mainstr=""
					s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_RowNum_""","_ExtendStr_"}"
					s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_RowNum_"""}"
					
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
		else  //如果配置检索项不为空
		{
			s mainstr=""
			s searchStr=""   //检索列的值拼串
			s searchStrPY=""   //检索列的值检索码	
			if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
			{
				
			}
			else
			{
				s argsLen=$Length(searchConfigs,"^")
				for i=1:1:argsLen
				{
					//获取检索列的数据
					s fieldid=$p(searchConfigs,"^",i)
					s MKBKMBFChildSub=$p(fieldid,"||",2)
					s MKBKMDValueStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(MBRowId, MKBKMBFChildSub,RowNum,K1Child,K2Child)  //获取知识点映射明细表的值
			 		s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
					s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
					s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
					if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
					{
						s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
					}					 			 		
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
					
					 //检索串	
					if (MKBKMDValue'="")
					{
						s:searchStr'="" searchStr=searchStr_"^"_MKBKMDValue
						s:searchStr="" searchStr=MKBKMDValue
					}
				}
			}
			s searchStrPY=""   //检索列的值检索码
			if ((searchStr'="")&(desc'="")&(allEn="Y"))
			{	
				s searchStrPY= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(searchStr)
			}
			
			if (($ZCONVERT(searchStr,"U")[desc)||(searchStrPY[desc))
			{
				s total=total+1
				if (total<stpage) continue
				if (total<=endpage)
				{
					
					 //获取未检索列的数据
				    s argsLen=$Length(unsearchConfigs,"^")
					for i=1:1:argsLen
					{
						s fieldid=$p(unsearchConfigs,"^",i)
						s MKBKMBFChildSub=$p(fieldid,"||",2)
						s MKBKMDValueStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(MBRowId, MKBKMBFChildSub,RowNum,K1Child,K2Child) //获取知识点映射明细表的值
						s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
						s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
						s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
						if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
						{
							s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
						}			 		
						s:ExtendStr'="" ExtendStr=ExtendStr_","
						s ExtendStr=ExtendStr_thisStr	
					}
					s mainstr=""
					s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_RowNum_""","_ExtendStr_"}"
					s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_RowNum_"""}"
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
	w "], ""total"":"_total_"}"
	q ""
}

/// 李欣 20180815
/// 获取诊断表达式在映射表中对照的信息
/// Input:MBRowId 映射注册表id Exp 诊断表达式 其余参数参照MappingDetail的GetMyList
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetInfoByExp(1,"14870-4998:10668","","","",10,1)
ClassMethod GetInfoByExp(MBRowId, Exp, desc, searchConfigs, unsearchConfigs, rows, page, allEn)
{
	
	s result="",total=0,jsonstr=""
	/*
	if (MBRowId'="")&&(Exp'="")
	{
		s TermId = $P(Exp,"-",1)
		s ProDet = $P(Exp,"-",2)
		s ProId = $P(ProDet,":",1)
		s DetId = $P(ProDet,":",2)
		
		s Exp = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SortDiag(Exp)
		/*s ProType = $LG($G(^User.MKBTermPropertyD(ProId)),4)
		;s:ProType="S" DetId="S"_DetId
		s DetId="("_DetId_")"
		
		
		s MDRowId = 0
		for
		{
			s MDRowId = $O(^User.MKBMappingTermRelyI("TermIndex",MBRowId,TermId,MDRowId))
			;s MDRowId = $O(^TMP("MKB","DiagTermID",MBRowId,TermId,MDRowId))
			q:MDRowId=""
			
			
			s MDValue = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
			;continue:((MDValue'["-")||(MDValue'[":"))
			if (MDValue'["-")
			{
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
				s RNArr(RowNum)=0	
				continue
			}
			continue:MDValue'[":"
			s DetResult=""
			if (MDValue[";")
			{
				s TL = $L(MDValue,";")
				for i=1:1:TL
				{	
					s SubProDet=""
					if (i=1)
					{
						s SubProDet = $P(MDValue,";",1)
						s DetStr = $P(SubProDet,":",2)
						continue:DetStr=""
						s DL = $L(DetStr,"*")
						s Det=""
						for j=1:1:DL
						{
							s Det = $P(DetStr,",",j)
							s DetResult=DetResult_"("_Det_")"		
						}	
					}	
					else
					{
						s SubProDet=$P(MDValue,";",i)
						s SubProDet = $P(MDValue,2,$L(SubProDet))
						s DetStr = $P(SubProDet,":",2)
						continue:DetStr=""
						s DL = $L(DetStr,"*")
						s Det=""
						for j=1:1:DL
						{
							s Det = $P(DetStr,"*",j)
							s DetResult=DetResult_"("_Det_")"	
						}	
					}
				}	
			}
			else
			{
				s SubProDet = $P(MDValue,"-",2)
				s DetStr = $P(SubProDet,":",2)
				Continue:DetStr=""
				s DL = $L(DetStr,"*")
				for i=1:1:DL
				{
					s DetResult = DetResult_"("_$P(DetStr,"*",i)_")"	
				}	
			}	
			
			continue:DetResult'[DetId
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
			s RNArr(RowNum)=0
		}
		
	}
	*/
	
	if (Exp'="")&&(MBRowId'="")
	{
		if Exp["-"
		{
			
			s Exp = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SortDiag(Exp)	
			s Exp=$p(Exp,"-",2)
			if ($D(^User.MKBMappingRelyI("SortIndex",MBRowId,Exp))'=0)
			{
				s MDRowId=0
				for
				{
					s MDRowId =$O(^User.MKBMappingRelyI("SortIndex",MBRowId,Exp,MDRowId))
					q:MDRowId=""
					s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
					continue:RowNum=""
					s RNArr(RowNum)=1		
				}
			}
		}
		else
		{
			if ($D(^User.MKBMappingRelyI("TermIndex",MBRowId,Exp))'=0)	
			{
				s MDRowId=0
				for
				{
					s MDRowId =$O(^User.MKBMappingRelyI("TermIndex",MBRowId,Exp,MDRowId))
					q:MDRowId=""
					
					s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
					continue:RowNum=""
					s RNArr(RowNum)=1	
				}	
			}
		}
		
	}
	s RowNum=""
	for
	{
		s RowNum=$O(RNArr(RowNum))
		q:RowNum=""
		
		s SortRNArr(RNArr(RowNum),RowNum)=""	
	}
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s:desc'="" desc=$ZCONVERT(desc,"U")
	w "{""rows"":["
	
	s K1K2ChildStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetK1AndK2EditChild(MBRowId)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
	
	s priority=""
	for  
	{	
		s priority=$o(SortRNArr(priority),-1) 
		q:priority=""
		
		s RowNum=0
		for
		{
			s RowNum = $O(SortRNArr(priority,RowNum))
			q:RowNum=""
			
			s ExtendStr=""   //知识点扩展属性子表的字段
		
			if (searchConfigs="")  //如果配置检索项为空
			{
				s searchStr=""   //检索列的值拼串
				s MKBKMBFSequence = 0
				for
				{
					s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MBRowId,MKBKMBFSequence))
					q:MKBKMBFSequence=""
					s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MBRowId,MKBKMBFSequence,0))
					
					s MKBKMDValueStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(MBRowId, MKBKMBFChildSub,RowNum,K1Child,K2Child)  //获取知识点映射明细表的值
					
					s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
					s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
					s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
					if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
					{
						s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
					}					 			 		
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
										
				    //检索串
				    if (MKBKMDValue'="")
					{
					 	s:searchStr'="" searchStr=searchStr_"^"_MKBKMDValue
					 	s:searchStr="" searchStr=MKBKMDValue
					}
				}
				
				s searchStrPY=""   //检索列的值检索码
				if ((searchStr'="")&(desc'="")&(allEn="Y"))
				{	
					s searchStrPY= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(searchStr)
				}
				i (($ZCONVERT(searchStr,"U")[desc)||(searchStrPY[desc))   //条件
				{
					s total=total+1
					if (total<stpage) continue
					if (total<=endpage)
					{
						s mainstr=""
						s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_RowNum_""","_ExtendStr_"}"
						s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_RowNum_"""}"
						
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
			else  //如果配置检索项不为空
			{
				s mainstr=""
				s searchStr=""   //检索列的值拼串
				s argsLen=$Length(searchConfigs,"^")
				for i=1:1:argsLen
				{
					//获取检索列的数据
					s fieldid=$p(searchConfigs,"^",i)
					s MKBKMBFChildSub=$p(fieldid,"||",2)
					s MKBKMDValueStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(MBRowId, MKBKMBFChildSub,RowNum,K1Child,K2Child)  //获取知识点映射明细表的值
			 		s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
					s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
					s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
					if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
					{
						s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
					}					 			 		
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
					
					 //检索串	
					if (MKBKMDValue'="")
					{
						s:searchStr'="" searchStr=searchStr_"^"_MKBKMDValue
						s:searchStr="" searchStr=MKBKMDValue
					}
				}
				s searchStrPY=""   //检索列的值检索码
				if ((searchStr'="")&(desc'="")&(allEn="Y"))
				{	
					s searchStrPY= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(searchStr)
				}
				
				if (($ZCONVERT(searchStr,"U")[desc)||(searchStrPY[desc))
				{
					s total=total+1
					if (total<stpage) continue
					if (total<=endpage)
					{
						
						 //获取未检索列的数据
					    s argsLen=$Length(unsearchConfigs,"^")
						for i=1:1:argsLen
						{
							s fieldid=$p(unsearchConfigs,"^",i)
							s MKBKMBFChildSub=$p(fieldid,"||",2)
							s MKBKMDValueStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(MBRowId, MKBKMBFChildSub,RowNum,K1Child,K2Child) //获取知识点映射明细表的值
							s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
							s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
							s thisStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""	
							if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
							{
								s thisStr=thisStr_",""Extend"_MKBKMBFChildSub_"F"":"""_MKBKMDValueF_""""
							}			 		
							s:ExtendStr'="" ExtendStr=ExtendStr_","
							s ExtendStr=ExtendStr_thisStr	
						}
						s mainstr=""
						s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_RowNum_""","_ExtendStr_"}"
						s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_RowNum_"""}"
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

/// Creator:谷雪萍
/// CreatDate:2018-06-08
/// Description：获取知识点1和知识点2的编辑列
/// Input：base-规则注册表ID
/// Return:知识点1的编辑列^知识点2的编辑列
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetK1AndK2EditChild(base)
ClassMethod GetK1AndK2EditChild(base As %String) As %String
{
	q:(base="") ""
	
	s K1Child="",K2Child=""
	s MKBKMBFSequence = 0
	for
	{
		s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
		q:MKBKMBFSequence=""
				
		s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
		s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)   //字段格式
		s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)	  //字段配置项

		
		if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child="")
		{
			s K1Child=MKBKMBFChildSub
		}
		if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child="")
		{
			s K2Child=MKBKMBFChildSub
		}
					
	}
	
	q K1Child_"^"_K2Child
}

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description：获取规则管理明细表的值
/// Input：base-规则注册表ID，MKBKMBFChildSub-规则注册字段表child，MKBKMDRowNum-知识点明细表行号（MKBKMDRowNum）
/// Return:规则管理明细表的值（MKBKMDValue）
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(1,1,1)
ClassMethod GetMappingDetailValue(base As %String, MKBKMBFChildSub As %String, MKBKMDRowNum As %String, K1Child As %String, K2Child As %String) As %String
{
	q:((base="")||(MKBKMBFChildSub="")||(MKBKMDRowNum="")) ""
	
	s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(base)),5)  //知识点1
	s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(base)),6)  //知识点2
		
	s MKBKMBFRowId = base_"||"_MKBKMBFChildSub   //规则注册字段表的id	
	s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)  //字段展示名
	s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)   //字段格式
	s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)	  //字段配置项

	if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child'=MKBKMBFChildSub)&(K1Child'="")  //如果是知识点1 不可编辑列
	{
		s MKBKMBFRowId = base_"||"_K1Child   //规则注册字段表的id
	}
	if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child'=MKBKMBFChildSub)&(K2Child'="")  //如果是知识点2 不可编辑列
	{
		s MKBKMBFRowId = base_"||"_K2Child   //规则注册字段表的id
	}
			
	s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKMDRowNum,MKBKMBFRowId,0))  //扩展属性内容表的id
	s MKBKMDValue="" ,MKBKMDValueF=""  //描述，id
    s:MKBKMDRowId'="" MKBKMDValue=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),2) //扩展属性内容的值
    if (MKBKMDValue'="")
    {	
    	s MKBKMDValueF=MKBKMDValue
		if (MKBKMBFType="K1")||(MKBKMBFType="K2")  //知识点1或知识点2
		{	
			
			if (MKBKMBFConfig="Exp")  //表达式
			{
				//s MKBKMDValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBKMDValue)  //原来选多个诊断时的表达式描述
				s MKBKMDValue=..GetExpDesc(MKBKMDValue)
			}	
			elseif (MKBKMBFConfig="Desc")  //中心词
			{
				if (((MKBKMBFType="K1")&(MKBKMBKnowledge1="D"))||((MKBKMBFType="K2")&(MKBKMBKnowledge2="D")))  //文献管理
				{
					s MKBKMDValue=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),3)
				}
				elseif(((MKBKMBFType="K1")&(MKBKMBKnowledge1="A"))||((MKBKMBFType="K2")&(MKBKMBKnowledge2="A")))  //评估表
				{
					s MKBKMDValue=$LISTGET($G(^User.MKBAssessmentBaseD(MKBKMDValue)),3)
				}
				else
				{
					s MKBKMDValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBKMDValue)  //获取术语描述，树形的所有上级节点也要显示	
				}
			}
			else  //属性
			{
				//s MKBKMDValue=$LISTGET($G(^User.MKBTermProDetailD(MKBKMDValue)),3)  //属性内容
				s MKBKMDValue=..GetProDetailDesc(MKBKMBFConfig,MKBKMDValue)     //根据术语库注册公有属性id(MKBKMBFConfig)和术语id(MKBKMDValue) 获取该术语的公有属性内容
			}	  	  
		}

		if (MKBKMBFType="CB")   //多选框
		{	
			s MKBKMDValue=##class(web.BDP.util.String).Replace(MKBKMDValue,"&%",",")	
		}
		if (MKBKMBFType="TP")   //引用术语
		{
			if (MKBKMBFConfig="D")  //文献管理
			{
				s MKBKMDValue=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),3)
			}
			elseif(MKBKMBFConfig="A")  //评估表
			{
				s MKBKMDValue=$LISTGET($G(^User.MKBAssessmentBaseD(MKBKMDValue)),3)
			}
			else
			{
				s MKBKMDValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBKMDValue)  //获取术语描述，树形的所有上级节点也要显示	
			}	
    	}
		
		s MKBKMDValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBKMDValue)
    }
    
    if (MKBKMBFChildSub=K1Child)||(MKBKMBFChildSub=K2Child)||((MKBKMBFType="K1")&(MKBKMBFConfig="Exp"))||((MKBKMBFType="K2")&(MKBKMBFConfig="Exp"))||(MKBKMBFType="TP")   //如果是知识点1、2的编辑列或者表达式
	{
		s MKBKMDValue=MKBKMDValue_"[A]"_MKBKMDValueF
	}
	q MKBKMDValue
}

/// Creator:谷雪萍
/// CreatDate:2018-06-21
/// Description：获取不可编辑的知识点1或知识点2的值
/// Input：base-规则注册表的id，MKBKMBFChildSub-规则注册字段表child，MKBKMDValue-可编辑的知识点1或知识点2的值
/// Return:不可编辑的知识点1或知识点2的值
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetNoEditDetailValue(1,1,1)
ClassMethod GetNoEditDetailValue(base As %String, MKBKMBFChildSub As %String, MKBKMDValue As %String, K1Child As %String, K2Child As %String) As %String
{
	q:((base="")||(MKBKMBFChildSub="")||(MKBKMDValue="")) ""
	
	s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(base)),5)  //知识点1
	s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(base)),6)  //知识点2
		
	s MKBKMBFRowId = base_"||"_MKBKMBFChildSub   //规则注册字段表的id
	s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)  //字段展示名
	s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)   //字段格式
	s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)	  //字段配置项

	if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child'=MKBKMBFChildSub)&(K1Child'="")  //如果是知识点1 不可编辑列
	{
		s MKBKMBFRowId = base_"||"_K1Child   //规则注册字段表的id
	}
	if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child'=MKBKMBFChildSub)&(K2Child'="")  //如果是知识点2 不可编辑列
	{
		s MKBKMBFRowId = base_"||"_K2Child   //规则注册字段表的id
	}
			
    if (MKBKMDValue'="")
    {	
		if (MKBKMBFType="K1")||(MKBKMBFType="K2")  //知识点1或知识点2
		{	
			if (MKBKMBFConfig="Exp")  //表达式
			{
				//s MKBKMDValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBKMDValue)  原来选多个诊断时的表达式描述
				s MKBKMDValue=..GetExpDesc(MKBKMDValue)
			}	
			elseif (MKBKMBFConfig="Desc")  //中心词
			{
				if (((MKBKMBFType="K1")&(MKBKMBKnowledge1="D"))||((MKBKMBFType="K2")&(MKBKMBKnowledge2="D")))  //文献管理
				{
					s MKBKMDValue=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),3)
				}
				elseif(((MKBKMBFType="K1")&(MKBKMBKnowledge1="A"))||((MKBKMBFType="K2")&(MKBKMBKnowledge2="A")))  //评估表
				{
					s MKBKMDValue=$LISTGET($G(^User.MKBAssessmentBaseD(MKBKMDValue)),3)
				}
				else
				{
					s MKBKMDValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBKMDValue)  //获取术语描述，树形的所有上级节点也要显示	
				}
			}
			else  //属性
			{
				//s MKBKMDValue=$LISTGET($G(^User.MKBTermProDetailD(MKBKMDValue)),3)  //属性内容
				s MKBKMDValue=..GetProDetailDesc(MKBKMBFConfig,MKBKMDValue)     //根据术语库注册公有属性id(MKBKMBFConfig)和术语id(MKBKMDValue) 获取该术语的公有属性内容
			}	  	  
		}

		if (MKBKMBFType="CB")   //多选框
		{	
			s MKBKMDValue=##class(web.BDP.util.String).Replace(MKBKMDValue,"&%",",")	
		}
		
		s MKBKMDValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBKMDValue)
    }
    
	s MKBKMDValue=$tr(MKBKMDValue,",","，")
	q MKBKMDValue
}

/// Creator:谷雪萍
/// CreatDate:2018-06-07
/// Description：根据术语库注册公有属性id和术语id 获取该术语的公有属性内容
/// Input：baseProId-术语库注册公有属性id，termid-术语id
/// Return:该术语的公有属性内容
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetProDetailDesc(baseProId,termid)
ClassMethod GetProDetailDesc(baseProId As %String, termid As %String) As %String
{
	q:(baseProId="")||(termid="") ""
	s MKBTPDDesc=""

	s baseProDesc=$LISTGET($G(^User.MKBTermBasePropertyD(baseProId)),3)  //公有属性描述			
	if (baseProDesc'="")
	{
		s baseProDesc=$ZCONVERT(baseProDesc,"U") //转换成大写
		s property=$o(^User.MKBTermPropertyI("DescIndex",termid," "_baseProDesc,0))  //属性id
		if (property'="")
		{
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
			s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		}
		
	}	
	
	q MKBTPDDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-06-07
/// Description：根据术语库注册公有属性id和术语id 获取该术语的公有属性内容及拼音码
/// Input：baseProId-术语库注册公有属性id，termid-术语id
/// Return:该术语的公有属性内容
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetProDetailDescAndPY(baseProId,termid)
ClassMethod GetProDetailDescAndPY(baseProId As %String, termid As %String) As %String
{
	q:(baseProId="")||(termid="") ""
	s MKBTPDDesc="",MKBTPDPYCode=""

	s baseProDesc=$LISTGET($G(^User.MKBTermBasePropertyD(baseProId)),3)  //公有属性描述			
	if (baseProDesc'="")
	{
		s baseProDesc=$ZCONVERT(baseProDesc,"U") //转换成大写
		s property=$o(^User.MKBTermPropertyI("DescIndex",termid," "_baseProDesc,0))  //属性id
		if (property'="")
		{
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
			s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			s:MKBTPDRowId'="" MKBTPDPYCode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),10)
		}
		
	}	
	
	q MKBTPDDesc_"[A]"_MKBTPDPYCode
}

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description：获取规则注册表及字段表的信息，用来生成可编辑表格的列
/// Input：base-规则注册表ID
/// Return:标题[A]映射关系[A]知识点1[A]知识点2[A]备注[A]child串[A]标题串[A]类型串[A]配置项串
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).getMappingBaseInfo(29036)
ClassMethod getMappingBaseInfo(base As %String) As %String
{
	q:base="" ""
	s MKBKMBRowId=base
	s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),3)  //标题
	s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),4) // 映射关系
	s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),5)  //知识点1
	s Knowledge1Desc="",Knowledge1Type=""
	s:MKBKMBKnowledge1'="" Knowledge1Desc=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge1)),3)  //知识点1描述
	s:MKBKMBKnowledge1'="" Knowledge1Type=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge1)),4)  //知识点1树形还是列表型
	s MKBKMBKnowledge1=MKBKMBKnowledge1_"[N]"_Knowledge1Desc_"[N]"_Knowledge1Type
	
	s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),6)  //知识点2
	s Knowledge2Desc="",Knowledge2Type=""
	s:MKBKMBKnowledge2'="" Knowledge2Desc=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge2)),3)  //知识点2描述	
	s:MKBKMBKnowledge2'="" Knowledge2Type=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge1)),4)  //知识点2树形还是列表型
	s MKBKMBKnowledge2=MKBKMBKnowledge2_"[N]"_Knowledge2Desc_"[N]"_Knowledge2Type

	
	s MKBKMBNote=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),7)  //备注
	s:MKBKMBNote="" MKBKMBNote="无"

	s extendChild=""  //组件extendChild
	s extendTitle=""  //组件标题、列表表头
	s extendType=""  //组件类型
	s extendConfig="" //配置项
	s count=0  //计数变量，只有一个扩展属性时不带连接符
	s MKBKMBFSequence = 0
	for
	{
		s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
		q:MKBKMBFSequence=""
		s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
		
		s MKBKMBFRowId = base_"||"_MKBKMBFChildSub
		s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)
		continue:MKBKMBFDesc=""
		s count=count+1
		s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)
		s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)
		s:MKBKMBFType="" MKBKMBFType="TX"
		
		if (count=1)
		{
			s extendChild=MKBKMBFChildSub  //child
			s extendTitle=MKBKMBFDesc  //标题
			s extendType=MKBKMBFType   //类型
			s extendConfig=MKBKMBFConfig  //配置项
			
		}
		else
		{
			s extendChild=extendChild_"[N]"_MKBKMBFChildSub	  //child串			
			s extendTitle=extendTitle_"[N]"_MKBKMBFDesc  //标题串
			s extendType=extendType_"[N]"_MKBKMBFType    //类型串
			s extendConfig=extendConfig_"[N]"_MKBKMBFConfig    //配置项串
		}

	}	

	q MKBKMBDesc_"[A]"_MKBKMBMappingRelation_"[A]"_MKBKMBKnowledge1_"[A]"_MKBKMBKnowledge2_"[A]"_MKBKMBNote_"[A]"_extendChild_"[A]"_extendTitle_"[A]"_extendType_"[A]"_extendConfig
}

/// Creator：谷雪萍
/// CreatDate: 2018-05-16
/// Description：查询规则注册及字段表内容
/// Table：User.MKBKLMappingBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetail","GetBaseList","","")
Query GetBaseList(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBKMBRowId,MKBKMBCode,MKBKMBDesc,MKBKMBMappingRelation,MKBKMBKnowledge1,MKBKMBKnowledge2,Knowledge1Type,Knowledge2Type,Knowledge1Desc,Knowledge2Desc,MKBKMBNote,extendChild,extendTitle,extendType,extendConfig,K1Child,K2Child,MKBKMBSequence")
{
}

ClassMethod GetBaseListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		
		s MKBKMBRowId=rowid
		s base=MKBKMBRowId
		s MKBKMBCode=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),2)
		s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),3)  //标题
		s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),4) // 映射关系
		s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),5)  //知识点1
		s Knowledge1Desc="",Knowledge1Type=""
		s:MKBKMBKnowledge1'="" Knowledge1Desc=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge1)),3)  //知识点1描述
		s:MKBKMBKnowledge1'="" Knowledge1Type=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge1)),4)  //知识点1树形还是列表型
		
		s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),6)  //知识点2
		s Knowledge2Desc="",Knowledge2Type=""
		s:MKBKMBKnowledge2'="" Knowledge2Desc=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge2)),3)  //知识点2描述	
		s:MKBKMBKnowledge2'="" Knowledge2Type=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge2)),4)  //知识点2树形还是列表型
		
		s MKBKMBNote=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),7)  //备注
		s:MKBKMBNote="" MKBKMBNote="无"
		s MKBKMBSequence=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),9)	

		s extendChild=""  //组件dataIndex
		s extendTitle=""  //组件标题、列表表头
		s extendType=""  //组件类型
		s extendConfig="" //配置项
		s K1Child=""  //知识点1的可编辑列
		s K2Child=""  //知识点2的可编辑列
		s count=0  //计数变量，只有一个扩展属性时不带连接符
		s MKBKMBFSequence = 0
		for
		{
			s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
			q:MKBKMBFSequence=""
			s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
			
			s MKBKMBFRowId = base_"||"_MKBKMBFChildSub
			s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)
			continue:MKBKMBFDesc=""
			s count=count+1
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)
			
			if (MKBKMBFType="TP")&(MKBKMBFConfig'="")&(MKBKMBFConfig'="D")&(MKBKMBFConfig'="A")  //引用术语格式
			{				
				s MKBKMBFConfig=MKBKMBFConfig_"&"_$LISTGET($G(^User.MKBTermBaseD(MKBKMBFConfig)),4)  //引用术语库id&引用术语库格式
			}
			s:MKBKMBFType="" MKBKMBFType="TX"
			
			if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child="")
			{
				s K1Child=MKBKMBFChildSub
			}
			if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child="")
			{
				s K2Child=MKBKMBFChildSub
			}	
				
			if (count=1)
			{
				s extendChild=MKBKMBFChildSub  //child
				s extendTitle=MKBKMBFDesc  //标题
				s extendType=MKBKMBFType   //类型
				s extendConfig=MKBKMBFConfig  //配置项
				
			}
			else
			{
				s extendChild=extendChild_"[N]"_MKBKMBFChildSub	  //child串			
				s extendTitle=extendTitle_"[N]"_MKBKMBFDesc  //标题串
				s extendType=extendType_"[N]"_MKBKMBFType    //类型串
				s extendConfig=extendConfig_"[N]"_MKBKMBFConfig    //配置项串
			}

		}		
		
		d OutputBaseRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s MKBKMBRowId=""
		for
		{  
			s MKBKMBRowId=$o(^User.MKBKLMappingBaseD(MKBKMBRowId),-1) 
			q:MKBKMBRowId=""  
			
			s base=MKBKMBRowId
			s MKBKMBCode=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),2)
			s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),3)  //标题
			s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),4) // 映射关系
			s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),5)  //知识点1
			s Knowledge1Desc="",Knowledge1Type=""
			s:MKBKMBKnowledge1'="" Knowledge1Desc=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge1)),3)  //知识点1描述
			s:MKBKMBKnowledge1'="" Knowledge1Type=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge1)),4)  //知识点1树形还是列表型
			
			s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),6)  //知识点2
			s Knowledge2Desc="",Knowledge2Type=""
			s:MKBKMBKnowledge2'="" Knowledge2Desc=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge2)),3)  //知识点2描述	
			s:MKBKMBKnowledge2'="" Knowledge2Type=$LISTGET($G(^User.MKBTermBaseD(MKBKMBKnowledge2)),4)  //知识点2树形还是列表型
			
			s MKBKMBNote=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),7)  //备注
			s:MKBKMBNote="" MKBKMBNote="无"
			s MKBKMBSequence=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),9)	

			s extendChild=""  //组件dataIndex
			s extendTitle=""  //组件标题、列表表头
			s extendType=""  //组件类型
			s extendConfig="" //配置项
			s K1Child=""  //知识点1的可编辑列
			s K2Child=""  //知识点2的可编辑列
			s count=0  //计数变量，只有一个扩展属性时不带连接符
			s MKBKMBFSequence = 0
			for
			{
				s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
				q:MKBKMBFSequence=""
				s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
				
				s MKBKMBFRowId = base_"||"_MKBKMBFChildSub
				s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)
				continue:MKBKMBFDesc=""
				s count=count+1
				s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)
				s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)
				if (MKBKMBFType="TP")&(MKBKMBFConfig'="")&(MKBKMBFConfig'="D")&(MKBKMBFConfig'="A")  //引用术语格式  //引用术语格式
				{
					s MKBKMBFConfig=MKBKMBFConfig_"&"_$LISTGET($G(^User.MKBTermBaseD(MKBKMBFConfig)),4)  //引用术语库id&引用术语库格式
				}
				s:MKBKMBFType="" MKBKMBFType="TX"
				
				if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child="")
				{
					s K1Child=MKBKMBFChildSub
				}
				if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child="")
				{
					s K2Child=MKBKMBFChildSub
				}
				
				if (count=1)
				{
					s extendChild=MKBKMBFChildSub  //child
					s extendTitle=MKBKMBFDesc  //标题
					s extendType=MKBKMBFType   //类型
					s extendConfig=MKBKMBFConfig  //配置项
					
				}
				else
				{
					s extendChild=extendChild_"[N]"_MKBKMBFChildSub	  //child串			
					s extendTitle=extendTitle_"[N]"_MKBKMBFDesc  //标题串
					s extendType=extendType_"[N]"_MKBKMBFType    //类型串
					s extendConfig=extendConfig_"[N]"_MKBKMBFConfig    //配置项串
				}

			}	
			
			s MKBKMBDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBKMBDesc)  
			s MKBKMBDescPY = $TR(MKBKMBDescPY,"_","")
			if (($ZCONVERT(MKBKMBDesc,"U")[desc)||(MKBKMBDescPY[desc))
			{
				d OutputBaseRow
			}
		}
	}
 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputBaseRow
    set Data=$lb(MKBKMBRowId,MKBKMBCode,MKBKMBDesc,MKBKMBMappingRelation,MKBKMBKnowledge1,MKBKMBKnowledge2,Knowledge1Type,Knowledge2Type,Knowledge1Desc,Knowledge2Desc,MKBKMBNote,extendChild,extendTitle,extendType,extendConfig,K1Child,K2Child,MKBKMBSequence)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetBaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBaseListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetBaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBaseListExecute ]
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
/// CreatDate:2018-08-21
/// Description：获取日志对象描述——给日志提供的接口
/// Input：key-Json的key值
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetLogObjectDesc(key)
ClassMethod GetLogObjectDesc(key As %String) As %String
{
	s keyDesc=""
	q:key="" ""

	s base=$p(key,"||",1)
	s child=$p(key,"||",2)
	if (base'="")&(child'="")
	{
		s keyDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),3)
	}	
	q keyDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description：保存修改内容
/// Table：User.MKBKLMappingDetail
/// Input：rowNum-行号，base-规则注册id，fieldValueStr-要保存的数据串
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData(rowNum,base,fieldValueStr)
ClassMethod SaveData(rowNum As %String, base As %String, fieldValueStr As %String) As %String
{
	s result = ""      //返回结果
	s newJsonStr = ""  //日志JSON串	
	s oldJsonStr = ""  //原日志JSON串，用于修改
	s col1Val= ""      //列1的值
	s col2Val=""    //列2的值

	s rowid=rowNum     //行号
	if (base="")
	{
		q "{success:'false',errorinfo:'没有选中左侧列表的数据！'}"

	}		
	if (rowNum="")
	{
		//如果代码为空，则自动生成T开头的9位的代码
		s rowNum=..GetLastNum(base)
	}
	q:rowNum="" "{success:'false',errorinfo:'没有获取到行号！'}"
	
	s itemStr= ##class(web.DHCBL.BDP.FunLib).Util(fieldValueStr)
	if (itemStr="")
	{
		q "{success:'false',errorinfo:'内容不能为空'}"   //返回错误信息
	}
	
	s flag=""
	s seq=0
	for{
		s seq=$o(^TMP("MKB","MKBKLMappingDetail",base,seq))
		q:seq=""
		s str=^TMP("MKB","MKBKLMappingDetail",base,seq)
		if ((str=itemStr)&(seq'=rowNum)) {
			s flag="repeat"
		}
	}
	if (flag'="")
 	{
	 	q "{success:'false',errorinfo:'该记录已经存在！'}"
 	}
 	
	s K1K2ChildStr=..GetK1AndK2EditChild(base)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
	
	TS
	
	s itemlen=$Length(itemStr,"[N]")
	for i=1:1:itemlen  
	{
		s item=$p(itemStr,"[N]",i)
		if (item'="")
		{
			s child=$p(item,"[A]",1)  //知识点扩展属性子表的child值
			s fieldValue=$p(item,"[A]",2)  //知识点扩展属性子表的字段值
			
			s oldFieldValue=""   //原先规则明细的值
			s newFieldValue=fieldValue   //新规则明细的值
							
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)   //字段格式
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)	  //字段配置项
			if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child'=child)&(K1Child'="")  //如果是知识点1 不可编辑列
			{
				s fieldValue = ""
			}
			if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child'=child)&(K2Child'="")  //如果是知识点2 不可编辑列
			{
				s fieldValue = ""
			}
			
			if (child'="")
			{
				s fieldDr=base_"||"_child  //知识点扩展属性子表的id

				s valId=$o(^User.MKBKLMappingDetailI("ValIndex",rowNum,fieldDr,0))
				
				//医用知识库规则管理明细表实体类，用于生成日志
				s eobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
				s eobj.MKBKMDRowId = valId
				s eobj.MKBKMDRowNum = rowNum
				s eobj.MKBKMDKMBaseFieldDr =fieldDr 
				s eobj.MKBKMDValue = fieldValue	
				s eobj.MKBKMDKMBaseDr=base
						
				if (fieldValue'="")  //如果有值则保存
				{
					if (valId'="")
					{
						s objv=##class(User.MKBKLMappingDetail).%OpenId(valId)
						s bobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
						s bobj.MKBKMDRowId = valId
						s bobj.MKBKMDRowNum = objv.MKBKMDRowNum
						s:objv.MKBKMDKMBaseFieldDr'="" bobj.MKBKMDKMBaseFieldDr = objv.MKBKMDKMBaseFieldDr.%Id()
						s:objv.MKBKMDKMBaseDr'="" bobj.MKBKMDKMBaseDr = objv.MKBKMDKMBaseDr.%Id()
						s bobj.MKBKMDValue = objv.MKBKMDValue
						s oldFieldValue=bobj.MKBKMDValue  //原先规则明细的值
					}
					else
					{
						s objv=##class(User.MKBKLMappingDetail).%New()
					}
					s objv.MKBKMDRowNum=rowNum
					d objv.MKBKMDKMBaseDrSetObjectId(base)
					d objv.MKBKMDKMBaseFieldDrSetObjectId(fieldDr)
					s objv.MKBKMDValue=fieldValue
					s scv=objv.%Save()

					d objv.%Close()
					If '$$$ISOK(scv)
					{
						s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
					}
					else
					{
						s idv = objv.%Id()
						//d:eobj.MKBKMDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",idv,eobj.MKBKMDValue,"A",eobj)
						//d:eobj.MKBKMDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",eobj.MKBKMDRowId,eobj.MKBKMDValue,"U",eobj,bobj)
						
						
						//s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)  //配置项
						if (MKBKMBFConfig="Exp")   //如果是表达式类型
						{	
							//s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)  //基本类型 K1、K2
							s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(base)),4)   //映射关系
							// 如果映射关系是1对2 且 表达式属于知识点1 或者映射关系是2对1 且 表达式属于知识点2 或者映射关系是双向映射
							if (((MKBKMBMappingRelation="1")&(MKBKMBFType="K1"))||((MKBKMBMappingRelation="2")&(MKBKMBFType="K2")) ||(MKBKMBMappingRelation="3")) 
							{
								if (eobj.MKBKMDRowId="")  //如果是新增
								{
									d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GenerateDiagGlobal(base, fieldValue, idv)								

								}
								else  //如果是修改
								{
									d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).UpdateDiagGlobal(base, bobj.MKBKMDValue, fieldValue, eobj.MKBKMDRowId)
								}
							}
						}
						

						//调引用表接口
						if ((MKBKMBFType="K1")||(MKBKMBFType="K2"))&(MKBKMBFConfig'="Exp")  //知识点1、2的可编辑列（除了条件表达式）
						{
							s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(base)),5)
							s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(base)),6)
							s ReferFlag="T"
							if (MKBKMBFConfig="Desc")&(MKBKMBKnowledge1="D")&(MKBKMBFType="K1")||((MKBKMBFConfig="Desc")&(MKBKMBKnowledge2="D")&(MKBKMBFType="K2"))   //引用文献管理
							{
								s ReferFlag="DOC"
							}
							if (MKBKMBFConfig="Desc")&(MKBKMBKnowledge1="A")&(MKBKMBFType="K1")||((MKBKMBFConfig="Desc")&(MKBKMBKnowledge2="A")&(MKBKMBFType="K2"))  //引用评估表
							{
								s ReferFlag="ASS"
							}
							
							if (eobj.MKBKMDRowId'="")   //如果修改
							{
								s MKBRRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("MD", idv, ReferFlag, bobj.MKBKMDValue)
								
							}
							else    //如果是新增
							{
								s MKBRRowId=""
							}
							
							d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "MD", idv, ReferFlag, fieldValue)
						}

					}
				}								
				else  //如果没有值
				{
				    
					if (valId'="") //如果之前有值现在没值了则删除
					{
						s objv=##class(User.MKBKLMappingDetail).%OpenId(valId)
						s bobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
						s bobj.MKBKMDRowId = valId
						s bobj.MKBKMDRowNum = objv.MKBKMDRowNum
						s:objv.MKBKMDKMBaseFieldDr'="" bobj.MKBKMDKMBaseFieldDr = objv.MKBKMDKMBaseFieldDr.%Id()
						s:objv.MKBKMDKMBaseDr'="" bobj.MKBKMDKMBaseDr = objv.MKBKMDKMBaseDr.%Id()
						s bobj.MKBKMDValue = objv.MKBKMDValue
						
						s oldFieldValue=bobj.MKBKMDValue  //原先规则明细的值
						
						s scv=##class(User.MKBKLMappingDetail).%DeleteId(valId)
						If '$$$ISOK(scv)
						{
							s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
						}
						else
						{
							//删除引用表数据
							d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("MD",valId)  //删除引用表数据
							//s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)  //配置项
							if (MKBKMBFConfig="Exp")   //如果是表达式类型
							{	
								//s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)  //基本类型 K1、K2

								s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(base)),4)   //映射关系
								// 如果映射关系是1对2 且 表达式属于知识点1 或者映射关系是2对1 且 表达式属于知识点2 或者映射关系是双向映射
								if (((MKBKMBMappingRelation="1")&(MKBKMBFType="K1"))||((MKBKMBMappingRelation="2")&(MKBKMBFType="K2")) ||(MKBKMBMappingRelation="3")) 
								{
									d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).DeleteDiagGlobal(base, bobj.MKBKMDValue, valId)
								}								

							}	
								
							//保存日志
							//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",valId,bobj.MKBKMDValue,"D",bobj)
							d eobj.%Close()
						}
					}
					
				}
				
				//处理规则管理的值,扩展属性明细拼JSON串，用于日志
				s newFieldValue=..GetNoEditDetailValue(base, child,newFieldValue,K1Child,K2Child) //获取规则管理明细表的值

				s:i=1 col1Val=newFieldValue
				s:i=2 col2Val=newFieldValue
				
				s:newJsonStr'="" newJsonStr=newJsonStr_","_fieldDr_":"""_newFieldValue_""""
				s:newJsonStr="" newJsonStr=fieldDr_":"""_newFieldValue_""""
				if (rowid'="")  //如果是修改
				{
					//原扩展属性明细拼JSON串，用于日志
					s oldFieldValue=..GetNoEditDetailValue(base, child,oldFieldValue,K1Child,K2Child) //获取规则管理明细表的值
					s:oldJsonStr'="" oldJsonStr=oldJsonStr_","_fieldDr_":"""_oldFieldValue_""""
					s:oldJsonStr="" oldJsonStr=fieldDr_":"""_oldFieldValue_""""
				}
				
			}

		}
			
	}


	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
	}
	else
	{
		TC
		s result = "{success:'true',id:'"_rowNum_"'}" //返回RowId
		
		s ^TMP("MKB","MKBKLMappingDetail",base,rowNum)=itemStr
		
		//调用日志接口
		s baseDesc=$LISTGET($G(^User.MKBKLMappingBaseD(base)),3)  //规则注册描述				
		//处理对象描述
		s newJsonStr="{"_newJsonStr_"}"
		
		s logDesc=col1Val_"对照"_col2Val //对象描述					
	    d:rowid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_KLMappingDetail","User.MKBKLMappingDetail"_base,baseDesc,rowNum,logDesc,"A",newJsonStr)
	    if (rowid'="")
	    {
		    //处理原对象描述
			s oldJsonStr="{"_oldJsonStr_"}"
		    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_KLMappingDetail","User.MKBKLMappingDetail"_base,baseDesc,rowid,logDesc,"U",newJsonStr,oldJsonStr)
	    }
	    /*s ^TMP("Text1")=newJsonStr
		s ^TMP("Text2")=oldJsonStr
		s ^TMP("Text3")=baseDesc_"^"_logDesc */ 
		
	}

	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-07-09
/// Description：保存单元格内容
/// Table：User.MKBKLMappingDetail
/// Input：rowNum-行号, base-规则注册id, child-Extend+规则注册子表child，fieldValue-单元格内容
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveCellData(rowNum, base , child , fieldValue )
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveCellData("24595",1,"Extend2", "128880")
ClassMethod SaveCellData(rowNum As %String, base As %String, child As %String, fieldValue As %String) As %String
{
	s result = ""

	if (base="")
	{
		q "{success:'false',errorinfo:'没有选中左侧列表的数据！'}"
	}
	if (child="")
	{
		q "{success:'false',errorinfo:'没有获取到要粘贴的列！'}"
	}			
	if (rowNum="")
	{
		//如果代码为空，则自动生成T开头的9位的代码
		s rowNum=..GetLastNum(base)
	}
	q:rowNum="" "{success:'false',errorinfo:'没有获取到行号！'}"
	
	s fieldValue= ##class(web.DHCBL.BDP.FunLib).Util(fieldValue)
	if (fieldValue="")
	{
		q "{success:'false',errorinfo:'粘贴的内容不能为空'}"   //返回错误信息
	}
	
	s K1K2ChildStr=..GetK1AndK2EditChild(base)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
	s oldFieldValue=""
	
	TS
	s child=$p(child,"Extend",2)  //知识点扩展属性子表的child值

	
	s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)   //字段格式
	s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)	  //字段配置项
	if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child'=child)&(K1Child'="")  //如果是知识点1 不可编辑列
	{
		s fieldValue = ""
	}
	if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child'=child)&(K2Child'="")  //如果是知识点2 不可编辑列
	{
		s fieldValue = ""
	}
	
	if (child'="")
	{
		s fieldDr=base_"||"_child  //知识点扩展属性子表的id

		s valId=$o(^User.MKBKLMappingDetailI("ValIndex",rowNum,fieldDr,0))
		
		//医用知识库规则管理明细表实体类，用于生成日志
		s eobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
		s eobj.MKBKMDRowId = valId
		s eobj.MKBKMDRowNum = rowNum
		s eobj.MKBKMDKMBaseFieldDr =fieldDr 
		s eobj.MKBKMDValue = fieldValue	
		s eobj.MKBKMDKMBaseDr=base
				
		if (fieldValue'="")  //如果有值则保存
		{
			if (valId'="")
			{
				s objv=##class(User.MKBKLMappingDetail).%OpenId(valId)
				s bobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
				s bobj.MKBKMDRowId = valId
				s bobj.MKBKMDRowNum = objv.MKBKMDRowNum
				s:objv.MKBKMDKMBaseFieldDr'="" bobj.MKBKMDKMBaseFieldDr = objv.MKBKMDKMBaseFieldDr.%Id()
				s:objv.MKBKMDKMBaseDr'="" bobj.MKBKMDKMBaseDr = objv.MKBKMDKMBaseDr.%Id()
				s bobj.MKBKMDValue = objv.MKBKMDValue
				s oldFieldValue=bobj.MKBKMDValue
			}
			else
			{
				s objv=##class(User.MKBKLMappingDetail).%New()
			}
			s objv.MKBKMDRowNum=rowNum
			d objv.MKBKMDKMBaseDrSetObjectId(base)
			d objv.MKBKMDKMBaseFieldDrSetObjectId(fieldDr)
			s objv.MKBKMDValue=fieldValue
			s scv=objv.%Save()

			d objv.%Close()
			If '$$$ISOK(scv)
			{
				s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
			}
			else
			{
				s idv = objv.%Id()
				//d:eobj.MKBKMDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",idv,eobj.MKBKMDValue,"A",eobj)
				//d:eobj.MKBKMDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",eobj.MKBKMDRowId,eobj.MKBKMDValue,"U",eobj,bobj)
				
				
				s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)  //配置项
				if (MKBKMBFConfig="Exp")   //如果是表达式类型
				{	
					s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(base)),4)   //映射关系
					// 如果映射关系是1对2 且 表达式属于知识点1 或者映射关系是2对1 且 表达式属于知识点2 或者映射关系是双向映射
					if (((MKBKMBMappingRelation="1")&(MKBKMBFType="K1"))||((MKBKMBMappingRelation="2")&(MKBKMBFType="K2")) ||(MKBKMBMappingRelation="3")) 
					{
						s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)  //基本类型 K1、K2
						if (eobj.MKBKMDRowId="")  //如果是新增
						{
							d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GenerateDiagGlobal(base, fieldValue, idv)						
						}
						else  //如果是修改
						{
							d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).UpdateDiagGlobal(base, bobj.MKBKMDValue, fieldValue, eobj.MKBKMDRowId)
						}
					}
				}
				
				//调引用表接口
				if ((MKBKMBFType="K1")||(MKBKMBFType="K2"))&(MKBKMBFConfig'="Exp")  //知识点1、2的可编辑列（除了条件表达式）
				{
					s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(base)),5)
					s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(base)),6)
					s ReferFlag="T"
					if (MKBKMBFConfig="Desc")&(MKBKMBKnowledge1="D")&(MKBKMBFType="K1")||((MKBKMBFConfig="Desc")&(MKBKMBKnowledge2="D")&(MKBKMBFType="K2"))   //引用文献管理
					{
						s ReferFlag="DOC"
					}
					if (MKBKMBFConfig="Desc")&(MKBKMBKnowledge1="A")&(MKBKMBFType="K1")||((MKBKMBFConfig="Desc")&(MKBKMBKnowledge2="A")&(MKBKMBFType="K2"))  //引用评估表
					{
						s ReferFlag="ASS"
					}
					
					if (eobj.MKBKMDRowId'="")   //如果修改
					{
						s MKBRRowId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("MD", idv, ReferFlag, bobj.MKBKMDValue)
						
					}
					else    //如果是新增
					{
						s MKBRRowId=""
					}
					
					d ##class(web.DHCBL.MKB.MKBReference).SaveDataById(MKBRRowId, "MD", idv, ReferFlag, fieldValue)
				}

			}
		}								
		else  //如果没有值
		{
		    
			if (valId'="") //如果之前有值现在没值了则删除
			{
				s objv=##class(User.MKBKLMappingDetail).%OpenId(valId)
				s bobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
				s bobj.MKBKMDRowId = valId
				s bobj.MKBKMDRowNum = objv.MKBKMDRowNum
				s:objv.MKBKMDKMBaseFieldDr'="" bobj.MKBKMDKMBaseFieldDr = objv.MKBKMDKMBaseFieldDr.%Id()
				s:objv.MKBKMDKMBaseDr'="" bobj.MKBKMDKMBaseDr = objv.MKBKMDKMBaseDr.%Id()
				s bobj.MKBKMDValue = objv.MKBKMDValue
				s oldFieldValue=bobj.MKBKMDValue
				s scv=##class(User.MKBKLMappingDetail).%DeleteId(valId)
				If '$$$ISOK(scv)
				{
					s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
				}
				else
				{
					//删除引用表数据
					d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("MD",valId)  //删除引用表数据
					
					s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)  //配置项
					if (MKBKMBFConfig="Exp")   //如果是表达式类型
					{	
						s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)  //基本类型 K1、K2

						s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(base)),4)   //映射关系
						// 如果映射关系是1对2 且 表达式属于知识点1 或者映射关系是2对1 且 表达式属于知识点2 或者映射关系是双向映射
						if (((MKBKMBMappingRelation="1")&(MKBKMBFType="K1"))||((MKBKMBMappingRelation="2")&(MKBKMBFType="K2")) ||(MKBKMBMappingRelation="3")) 
						{
							d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).DeleteDiagGlobal(base, bobj.MKBKMDValue, valId)
						}								

					}
					
					//保存日志
					//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",valId,bobj.MKBKMDValue,"D",bobj)
					d eobj.%Close()
				}
			}
			
		}
	}




	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
	}
	else
	{
		TC
		s result = "{success:'true',id:'"_rowNum_"'}" //返回RowId
		
		//更新重复判断的索引
		d ..CreateRowRepeatIndex(base,rowNum,K1Child,K2Child)
		
		//调用日志接口
		s baseDesc=$LISTGET($G(^User.MKBKLMappingBaseD(base)),3)  //规则注册描述
		//单元格现在的值
		s newFieldValue=..GetNoEditDetailValue(base, child,fieldValue,K1Child,K2Child) //获取规则管理明细表的值				
		s newJsonStr=fieldDr_":"""_newFieldValue_""""
		s newJsonStr="{"_newJsonStr_"}"
		
		//单元格原来的值
		s oldFieldValue=..GetNoEditDetailValue(base, child,oldFieldValue,K1Child,K2Child) //获取原规则管理明细表的值
		s oldJsonStr=fieldDr_":"""_oldFieldValue_""""
		s oldJsonStr="{"_oldJsonStr_"}"	
		
		//对象描述
		s keyDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),3)
		s logDesc=keyDesc_"等于"_newFieldValue //对象描述					

	    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_KLMappingDetail","User.MKBKLMappingDetail"_base,baseDesc,rowNum,logDesc,"U",newJsonStr,oldJsonStr)
	    	
	}

	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-07-10
/// Description：删除单元格内容
/// Table：User.MKBKLMappingDetail
/// Input：rowNum-行号, base-规则注册id, child-Extend+规则注册子表child
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteCellData(rowNum, base , child )
ClassMethod DeleteCellData(rowNum As %String, base As %String, child As %String) As %String
{
	s result = ""

	if (base="")
	{
		q "{success:'false',errorinfo:'没有选中左侧列表的数据！'}"
	}
	if (child="")
	{
		q "{success:'false',errorinfo:'没有获取到要粘贴的列！'}"
	}			

	q:rowNum="" "{success:'false',errorinfo:'没有获取到行号！'}"
	
	s K1K2ChildStr=..GetK1AndK2EditChild(base)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
	s oldFieldValue=""	
	
	TS
	s child=$p(child,"Extend",2)  //知识点扩展属性子表的child值
	
	if (child'="")
	{
		s fieldDr=base_"||"_child  //知识点扩展属性子表的id

		s valId=$o(^User.MKBKLMappingDetailI("ValIndex",rowNum,fieldDr,0))
				
		if (valId'="") //如果之前有值现在没值了则删除
		{
			s objv=##class(User.MKBKLMappingDetail).%OpenId(valId)
			s bobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
			s bobj.MKBKMDRowId = valId
			s bobj.MKBKMDRowNum = objv.MKBKMDRowNum
			s:objv.MKBKMDKMBaseFieldDr'="" bobj.MKBKMDKMBaseFieldDr = objv.MKBKMDKMBaseFieldDr.%Id()
			s:objv.MKBKMDKMBaseDr'="" bobj.MKBKMDKMBaseDr = objv.MKBKMDKMBaseDr.%Id()
			s bobj.MKBKMDValue = objv.MKBKMDValue
			s oldFieldValue=bobj.MKBKMDValue
			
			s scv=##class(User.MKBKLMappingDetail).%DeleteId(valId)
			If '$$$ISOK(scv)
			{
				s result= "{success:'false',errorinfo:'"_$zconvert(scv,"O","JS")_"'}"   //返回错误信息
			}
			else
			{
				//删除引用表数据
				d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("MD",valId)  //删除引用表数据
				s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)  //配置项
				if (MKBKMBFConfig="Exp")   //如果是表达式类型
				{	
					s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)  //基本类型 K1、K2

					s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(base)),4)   //映射关系
					// 如果映射关系是1对2 且 表达式属于知识点1 或者映射关系是2对1 且 表达式属于知识点2 或者映射关系是双向映射
					if (((MKBKMBMappingRelation="1")&(MKBKMBFType="K1"))||((MKBKMBMappingRelation="2")&(MKBKMBFType="K2")) ||(MKBKMBMappingRelation="3")) 
					{
						d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).DeleteDiagGlobal(base, bobj.MKBKMDValue, valId)
					}								

				}
				
				//保存日志
				//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",valId,bobj.MKBKMDValue,"D",bobj)
			}
		}
			
		
	}

	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'删除失败'}"   //返回错误信息
	}
	else
	{
		TC
		s result = "{success:'true',id:'"_rowNum_"'}" //返回RowId
		
		//更新重复判断的索引
		d ..CreateRowRepeatIndex(base,rowNum,K1Child,K2Child)
		
		//调用日志接口
		s baseDesc=$LISTGET($G(^User.MKBKLMappingBaseD(base)),3)  //规则注册描述
		
		//单元格原来的值
		s oldFieldValue=..GetNoEditDetailValue(base, child,oldFieldValue,K1Child,K2Child) //获取原规则管理明细表的值
		s oldJsonStr=fieldDr_":"""_oldFieldValue_""""
		s oldJsonStr="{"_oldJsonStr_"}"	
		
		//对象描述
		s keyDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),3)
		s logDesc=keyDesc_"等于"_oldFieldValue //对象描述					

		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_KLMappingDetail","User.MKBKLMappingDetail"_base,baseDesc,rowNum,logDesc,"D",oldJsonStr)
	}

	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description：数据保存测试方法
/// Table：User.MKBKLMappingDetail
/// Input：
/// Return:成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveTest()
ClassMethod SaveTest()
{
	s rowNum=""
	s base =1
	s fieldValueStr="1[A]14626-1898:3132[N]2[A]27474[N]3[A]14626-1893:3086[N]4[A]已映射[N]5[A]备注a"
	s result=..SaveData(rowNum,base,fieldValueStr)
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description:获取新增时的行号
/// Input：base-规则注册表ID
/// Return：成功返回自动生成的行号
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetLastNum(1)
ClassMethod GetLastNum(base) As %String
{
	q:base="" ""
	s MKBKMDRowNum=0
	if ($d(^User.MKBKLMappingDetailI("RowNumIndex",base)))
	{
	
		s MKBKMDRowNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",base,""),-1) 
	}
	s MKBKMDRowNum=MKBKMDRowNum+1
	
	q MKBKMDRowNum
}

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description：获取修改时的记录
/// Input：id-属性内容表User.MKBKLMappingDetail的id
/// Return：Json格式的 字段和值 信息
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingDetail).NewOpenData(1,1)
ClassMethod NewOpenData(rowid As %String, base As %String) As %String
{
	
	s MKBKMDRowNum=rowid  //行号
	s ExtendStr=""   //知识点扩展属性子表的字段

	s K1Child="",K2Child=""
	s MKBKMBFSequence = 0
	for
	{
		s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
		q:MKBKMBFSequence=""
		s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
		
		s MKBKMBFRowId = base_"||"_MKBKMBFChildSub
		
		s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)
		s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)
		s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)	  //字段配置项
		
		if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child="")
		{
			s K1Child=MKBKMBFChildSub
		}
		if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child="")
		{
			s K2Child=MKBKMBFChildSub
		}
		
		
		s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKMDRowNum,MKBKMBFRowId,0))  //扩展属性内容表的id
		s MKBKMDValue=""
        s:MKBKMDRowId'="" MKBKMDValue=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),2) //扩展属性内容的值
        if (MKBKMDValue'="")
        {	
			if (MKBKMBFType="CB")   //多选框
			{	
  				s MKBKMDValue=##class(web.BDP.util.String).Replace(MKBKMDValue,"&%",",")	
			}
        }
      
      	if (MKBKMBFType="K1")&(MKBKMBFConfig'="Exp")&(K1Child'=MKBKMBFChildSub)&(K1Child'="")  //如果是知识点1 不可编辑列
		{
			s MKBKMDValueStr=..GetMappingDetailValue(base, MKBKMBFChildSub,MKBKMDRowNum,K1Child,K2Child)  //获取规则管理明细表的值
			s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
		}
		if (MKBKMBFType="K2")&(MKBKMBFConfig'="Exp")&(K2Child'=MKBKMBFChildSub)&(K2Child'="")  //如果是知识点2 不可编辑列
		{
			s MKBKMDValueStr=..GetMappingDetailValue(base, MKBKMBFChildSub,MKBKMDRowNum,K1Child,K2Child)  //获取规则管理明细表的值
			s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
		}  
		s MKBKMDValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBKMDValue)	
		s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
	    s:ExtendStr="" ExtendStr="""Extend"_MKBKMBFChildSub_""":"""_MKBKMDValue_""""
	}
	s mainstr=""
	s:ExtendStr'="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_""","_ExtendStr_"}"
	s:ExtendStr="" mainstr="{""MKBKMDRowNum"":"""_MKBKMDRowNum_"""}"
	q mainstr
}

/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description:根据id删除
/// Table:User.MKBKLMappingDetail
/// Input：id-规则管理表的的行号，base-规则注册的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData("1",1)
ClassMethod DeleteData(id As %String, base As %String) As %String
{
	q:base="" "{success:'false',info:'没有选中左侧列表的数据'}"  //返回错误信息
	q:id="" "{success:'false',info:'没有选中要删除的行'}"  //返回错误信息
	
	s logJsonStr=""   //日志JSON串
	s K1K2ChildStr=..GetK1AndK2EditChild(base)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
	s col1Val=""   //知识点1的值
	s col2Val=""   //知识点2的值
	
	s result=""
	TS 
	s MKBKMDRowId=0
	for  
	{	
		s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("RowNumIndex",base,id,MKBKMDRowId)) q:MKBKMDRowId="" 
		s eobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
		s pobj = ##class(User.MKBKLMappingDetail).%OpenId(MKBKMDRowId)
		s eobj.MKBKMDRowId = MKBKMDRowId
		s eobj.MKBKMDRowNum = id
		s:pobj.MKBKMDKMBaseFieldDr'="" eobj.MKBKMDKMBaseFieldDr = pobj.MKBKMDKMBaseFieldDr.%Id()
		s:pobj.MKBKMDKMBaseDr'="" eobj.MKBKMDKMBaseDr = pobj.MKBKMDKMBaseDr.%Id()
		s eobj.MKBKMDValue = pobj.MKBKMDValue	
		d pobj.%Close()
		
		//处理扩展属性的值
		s fieldValue=eobj.MKBKMDValue
		if (eobj.MKBKMDKMBaseFieldDr'="")
		{
			s child=$p(eobj.MKBKMDKMBaseFieldDr,"||",2)  //扩展属性的child
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)	  //字段配置项
			s fieldValue=..GetNoEditDetailValue(base, child,fieldValue,K1Child,K2Child) //获取规则管理明细表的值
			if ((child=K1Child)&(col1Val=""))||((MKBKMBFType="K1")&(MKBKMBFConfig="Exp")&(col1Val=""))
			{
				s col1Val=fieldValue
			}
			if ((child=K2Child)&(col2Val=""))||((MKBKMBFType="K2")&(MKBKMBFConfig="Exp")&(col2Val=""))
			{
				s col2Val=fieldValue
			}
			s:logJsonStr'="" logJsonStr=logJsonStr_","_eobj.MKBKMDKMBaseFieldDr_":"""_fieldValue_""""
			s:logJsonStr="" logJsonStr=eobj.MKBKMDKMBaseFieldDr_":"""_fieldValue_""""
		}
		
		s sc=##class(User.MKBKLMappingDetail).%DeleteId(MKBKMDRowId)
		if $$$ISOK(sc)
		{
			//删除引用表数据
			d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("MD",MKBKMDRowId)  //删除引用表数据
			
			//删除临时global，调李欣接口
			s child=$p(eobj.MKBKMDKMBaseFieldDr,"||",2)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),5)  //配置项
			if (MKBKMBFConfig="Exp")   //如果是表达式类型
			{	
				s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",child)),4)  //基本类型 K1、K2

				s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(base)),4)   //映射关系
				// 如果映射关系是1对2 且 表达式属于知识点1 或者映射关系是2对1 且 表达式属于知识点2 或者映射关系是双向映射
				if (((MKBKMBMappingRelation="1")&(MKBKMBFType="K1"))||((MKBKMBMappingRelation="2")&(MKBKMBFType="K2")) ||(MKBKMBMappingRelation="3")) 
				{
					d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).DeleteDiagGlobal(base, eobj.MKBKMDValue, MKBKMDRowId)
				}								

			}
			//保存日志
			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","医用知识库规则管理表",MKBKMDRowId,eobj.MKBKMDValue,"D",eobj)
			//d eobj.%Close()

		}
		else
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
		
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
		k ^TMP("MKB","MKBKLMappingDetail",base,id)
		
		//调用日志接口
		s baseDesc=$LISTGET($G(^User.MKBKLMappingBaseD(base)),3)  //规则注册描述				
		//处理对象描述
		s logJsonStr="{"_logJsonStr_"}"
		
		s logDesc=col1Val_"对照"_col2Val //对象描述	
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_KLMappingDetail","User.MKBKLMappingDetail"_base,baseDesc,id,logDesc,"D",logJsonStr)		

	}
    q result
}

/// Creator：谷雪萍
/// CreatDate: 2018-05-16
/// Description:为如果知识点1和知识点2的配置项为术语库注册的公有属性id，则生成控件为combobox
/// Table：User.MKBTermProDetail
/// Input：rowid-属性内容表id,desc-检索内容,basePro-术语库注册属性id
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetail","GetDataForDetailCmb","","1","")
Query GetDataForDetailCmb(rowid As %String, basePro As %String, q As %String) As %Query(ROWSPEC = "termId:%String,MKBTPDDesc:%String")
{
}

ClassMethod GetDataForDetailCmbExecute(ByRef qHandle As %Binary, rowid As %String, basePro As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s termId=rowid
		s MKBTPDRowId="",MKBTPDDesc=""
		if (basePro'="")
		{ 
			
			s detailDescAndPY=..GetProDetailDescAndPY(basePro,termId)
			s:detailDescAndPY'="" detailDescAndPY=##class(web.DHCBL.BDP.FunLib).EvalJSONB(detailDescAndPY)
			s MKBTPDDesc=$p(detailDescAndPY,"[A]",1)	
			s MKBTPDPYCode=$p(detailDescAndPY,"[A]",2)	
			
		}	
		d OutputRowDetailCmb
	}
	else
	{

		s:q'="" q=$ZCONVERT(q,"U")
		if (basePro'="")
		{
			s baseProDesc=$LISTGET($G(^User.MKBTermBasePropertyD(basePro)),3)  //公有属性描述
			s base=$LISTGET($G(^User.MKBTermBasePropertyD(basePro)),5)
			if (base'="")
			{
				s count=0
				s termId=""  
				for    //循环术语表
				{	
					s termId=$o(^User.MKBTermI("BaseIndex",base,termId)) q:((termId="")||(count>49))
										
					s detailDescAndPY=..GetProDetailDescAndPY(basePro,termId)
					s:detailDescAndPY'="" detailDescAndPY=##class(web.DHCBL.BDP.FunLib).EvalJSONB(detailDescAndPY)
					s MKBTPDDesc=$p(detailDescAndPY,"[A]",1)	
					s MKBTPDPYCode=$p(detailDescAndPY,"[A]",2)	
					continue:(MKBTPDDesc="")
	
					i ($ZCONVERT(MKBTPDDesc,"U")[q)||($ZCONVERT(MKBTPDPYCode,"U")[q)   //条件
					{
						s count=count+1
						d OutputRowDetailCmb
			        }

				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDetailCmb
    set Data=$lb(termId,MKBTPDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForDetailCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForDetailCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForDetailCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForDetailCmbExecute ]
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
/// CreatDate: 2018-6-05
/// Description:取文献管理的下拉框数据
/// Table：User.MKBDocManage
/// Input：rowid,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetail","GetDocManageCmb","","")
Query GetDocManageCmb(rowid As %String, q As %String) As %Query(ROWSPEC = "MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMPath")
{
}

ClassMethod GetDocManageCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String) As %Status
{
	 s repid=$I(^CacheTemp)
	 s ind=1
	 
	 if (rowid'="") //根据rowid返回该条记录
	 {
		s MKBDMRowId=rowid
		s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
		s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
		s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
		d OutputDocManageCmb
	 }
	 else
	 {
		s desc=q
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写

		s MKBDMRowId=0
		for{  
			s MKBDMRowId=$o(^User.MKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""   
			s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
			s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
			s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)

			s PINYIN=""
			s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBDMDesc)  
			if (($ZCONVERT(MKBDMDesc,"U")[desc)||(PINYIN[desc)) {
				d OutputDocManageCmb
			}
		}
	 }
	 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDocManageCmb
	set Data=$lb(MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMPath)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDocManageCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocManageCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocManageCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocManageCmbExecute ]
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
/// CreatDate: 2018-06-05
/// Description：查询评分表注册表内容
/// Table：User.MKBAssessmentBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetail","GetAssBaseCmb","","")
Query GetAssBaseCmb(rowid As %String, q As %String) As %Query(ROWSPEC = "MKBABRowId,MKBABCode,MKBABDesc,MKBABNote")
{
}

ClassMethod GetAssBaseCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1

    if (rowid'="") //根据rowid返回该条记录
    {
        s MKBABRowId=rowid
        s MKBABCode=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),2)
        s MKBABDesc=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),3)
        s MKBABNote=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),4)
        d OutputAssBaseCmb
    }
    else
    {
	    s desc=q
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s MKBABRowId=""
        for
        {  
            s MKBABRowId=$o(^User.MKBAssessmentBaseD(MKBABRowId),-1) 
            q:MKBABRowId=""  

            s MKBABCode=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),2)
            s MKBABDesc=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),3)
            s MKBABNote=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),4)
            
            s MKBABDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBABDesc)  
            s MKBABDescPY = $TR(MKBABDescPY,"_","")
            if (($ZCONVERT(MKBABDesc,"U")[desc)||(MKBABDescPY[desc))
            {
                d OutputAssBaseCmb
            }
        }
    }
 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputAssBaseCmb
    set Data=$lb(MKBABRowId,MKBABCode,MKBABDesc,MKBABNote)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAssBaseCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssBaseCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAssBaseCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssBaseCmbExecute ]
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
/// CreatDate:2018-08-10
/// Description:术语维护界面-属性内容维护区域，生成右键菜单
/// Table:User.MKBKLMappingBase和User.MKBKLMappingBaseField表
/// Input：termBase-术语库注册的id
/// Return: 规则管理的id和描述
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).CreateRightMenu(termBase)
ClassMethod CreateRightMenu(termBase As %String) As %String
{
	q:termBase="" ""
	s result=""
	s MKBKMBRowId=""
	for
	{  
		s MKBKMBRowId=$o(^User.MKBKLMappingBaseD(MKBKMBRowId),-1) 
		q:MKBKMBRowId=""  
		
		s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),3)  //标题
		s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),4) // 映射关系
		s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),5)  //知识点1		
		s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),6)  //知识点2
		s MKBKMBFlag=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),8) //同步生成右键菜单
		
		s flag=0  //输出标识
		//先判断映射关系。1对2的话得满足知识点1=termbase， 2对1的话得满足知识点2=termbase，双向的话知识点1知识点2一个满足就可以。
		if (MKBKMBMappingRelation=1)
		{
			if (termBase=MKBKMBKnowledge1)&(MKBKMBFlag="Y")
			{
				s flag=1
			}
			else
			{
				continue
			}
		}
		elseif(MKBKMBMappingRelation=2)
		{
			if (termBase=MKBKMBKnowledge2)&(MKBKMBFlag="Y")
			{
				s flag=1
			}
			else
			{
				continue
			}		
		}
		else
		{
			if ((termBase=MKBKMBKnowledge1)||(termBase=MKBKMBKnowledge2))&(MKBKMBFlag="Y")
			{
				s flag=1
			}
			else
			{
				continue
			}	
		}

		continue:flag=0
		
		s mainstr=""
		s MKBKMBFSequence = 0
		for
		{
			s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MKBKMBRowId,MKBKMBFSequence))
			q:MKBKMBFSequence=""
			s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MKBKMBRowId,MKBKMBFSequence,0))
			
			s MKBKMBFRowId = MKBKMBRowId_"||"_MKBKMBFChildSub
			s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)),3)
			continue:MKBKMBFDesc=""

			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)),5)
			s:MKBKMBFType="" MKBKMBFType="TX"
		
			if ((MKBKMBFType="K1")&(MKBKMBFConfig="Exp")&(termBase=MKBKMBKnowledge1))||((MKBKMBFType="K2")&(MKBKMBFConfig="Exp")&(termBase=MKBKMBKnowledge2))||(termBase="D")||(termBase="A")
			{
				s mainstr="{""MKBKMBRowId"":"""_MKBKMBRowId_""",""MKBKMBDesc"":"""_MKBKMBDesc_"""}"
				q
					
			}

		}
		
		if (mainstr'="")
		{
		    s:result'="" result=result_"[A]"_mainstr
			s:result="" result=mainstr	
		}
		

	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-08-16
/// Description:根据术语条目id获取术语条目描述、规则管理新增时给单元格赋值
/// Table:User.MKBTerm
/// Input：id 术语条目ID 或者文献管理id或者评估表id,termBase-术语库注册id
/// Return:成功返回术语条目描述或者文献管理描述或者评估表描述
/// Other:d ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetAddDataDesc()
ClassMethod GetAddDataDesc(id As %String, termBase As %String)
{
	q:id="" ""
	s MKBTDesc=""
	if (termBase="D")
	{
		s MKBTDesc=$LISTGET($G(^User.MKBDocManageD(id)),3)  //文献描述
	}
	elseif(termBase="A")
	{
		s MKBTDesc=$LISTGET($G(^User.MKBAssessmentBaseD(id)),3)  //评估表描述
	}
	else
	{
		s MKBTDesc=$listGet($g(^User.MKBTermD(id)),3)  //术语描述
	}	
	q MKBTDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-08-23
/// Description:文献预览菜单
/// Table:User.MKBKLMappingBase和User.MKBKLMappingBaseField表
/// Input：termBase-术语库注册的id
/// Return: 规则管理的id和描述
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).CreateDocRightMenu("5","41084-52657:51485")
ClassMethod CreateDocRightMenu(termBase As %String, Exp As %String) As %String
{
	q:(termBase="")||(Exp="") ""
	
	s result=""
	s docBaseFieldId=""
	s MKBKMBRowId=""
	for
	{  
		s MKBKMBRowId=$o(^User.MKBKLMappingBaseD(MKBKMBRowId),-1) 
		q:(MKBKMBRowId="")||(docBaseFieldId'="")
		
		s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),3)  //标题
		s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),4) // 映射关系
		s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),5)  //知识点1		
		s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),6)  //知识点2
		s MKBKMBFlag=$LISTGET($G(^User.MKBKLMappingBaseD(MKBKMBRowId)),8) //同步生成右键菜单
		
		s docKno=""  //文献属于知识点1还是知识点2
		
		//先判断映射关系。1对2的话得满足知识点1=termbase， 2对1的话得满足知识点2=termbase，双向的话知识点1知识点2一个满足就可以。
		if (MKBKMBMappingRelation=1)
		{
			if (termBase=MKBKMBKnowledge1)&(MKBKMBKnowledge2="D")
			{
				s docKno="K2"
			}
			else
			{
				continue
			}
		}
		elseif(MKBKMBMappingRelation=2)
		{
			if (termBase=MKBKMBKnowledge2)&(MKBKMBKnowledge1="D")
			{
				s docKno="K1"
			}
			else
			{
				continue
			}		
		}
		else
		{
			if (termBase=MKBKMBKnowledge1)&(MKBKMBKnowledge2="D")
			{
				s docKno="K2"
			}
			elseif (termBase=MKBKMBKnowledge2)&(MKBKMBKnowledge1="D")
			{
				s docKno="K1"
			}
			else
			{
				continue
			}	
		}

		continue:docKno=""
		
		s mainstr=""
		s MKBKMBFSequence = 0
		for
		{
			s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MKBKMBRowId,MKBKMBFSequence))
			q:MKBKMBFSequence=""
			s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",MKBKMBRowId,MKBKMBFSequence,0))
			
			s MKBKMBFRowId = MKBKMBRowId_"||"_MKBKMBFChildSub
			s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)),3)
			continue:MKBKMBFDesc=""

			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(MKBKMBRowId,"ChildField",MKBKMBFChildSub)),5)
			s:MKBKMBFType="" MKBKMBFType="TX"
			

			if (MKBKMBFType=docKno)&(MKBKMBFConfig="Desc")
			{
				s docBaseFieldId=MKBKMBFRowId
				q
					
			}

		}
		
		if (docBaseFieldId'="")
		{

			if (Exp'="")&&(MKBKMBRowId'="")
			{
				if Exp["-"
				{
					
					s Exp = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SortDiag(Exp)	
					s Exp=$p(Exp,"-",2)
					if ($D(^User.MKBMappingRelyI("SortIndex",MKBKMBRowId,Exp))'=0)
					{
						s MDRowId=0
						for
						{
							s MDRowId =$O(^User.MKBMappingRelyI("SortIndex",MKBKMBRowId,Exp,MDRowId))
							q:MDRowId=""
							s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
							continue:RowNum=""
							s RNArr(RowNum)=1		
						}
					}
				}
				else
				{
					if ($D(^User.MKBMappingRelyI("TermIndex",MKBKMBRowId,Exp))'=0)	
					{
						s MDRowId=0
						for
						{
							s MDRowId =$O(^User.MKBMappingRelyI("TermIndex",MKBKMBRowId,Exp,MDRowId))
							q:MDRowId=""
							
							s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
							continue:RowNum=""
							s RNArr(RowNum)=1	
						}	
					}
				}
				
				
			}
			s RowNum=""
			for
			{
				s RowNum=$O(RNArr(RowNum))
				q:RowNum=""
				
				s SortRNArr(RNArr(RowNum),RowNum)=""	
			}
		}
			
		s priority=""
		for  
		{	
			s priority=$o(SortRNArr(priority),-1) 
			q:priority=""
			
			s RowNum=0
			for
			{
				s RowNum = $O(SortRNArr(priority,RowNum))
				q:RowNum=""
				
				s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,docBaseFieldId,0))  //扩展属性内容表的id
				continue:MKBKMDRowId=""

				s MKBKMDValue=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),2) //扩展属性内容的值
				continue:MKBKMDValue=""

				s DocDesc=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),3)
				s DocPath=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),4)
				s mainstr="{""DocRowId"":"""_MKBKMDValue_""",""DocDesc"":"""_DocDesc_""",""DocPath"":"""_DocPath_"""}"	
				continue:result[mainstr			
			    s:result'="" result=result_"[A]"_mainstr
				s:result="" result=mainstr	
								
					
			}
		}		

	}
	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2020-02-06
/// Description:医为百科文献接口
/// Input：Exp-术语id,Classify-文献分类
/// Return: 文献信息串——用[A]拼接
/// Other:d ##class(web.DHCBL.MKB.MKBKLMappingDetail).EncyclopediaDocInfo(1701033,"")
ClassMethod EncyclopediaDocInfo(Exp As %String, Classify As %String = "") As %String
{
	q:(Exp="") ""
	
	s result=""
	
	s termId=$p(Exp,"-",1)
	s MKBTDesc=$listGet($g(^User.MKBTermD(termId)),3)  //术语中心词
	q:MKBTDesc="" ""
	s MKBTBaseDR=$listGet($g(^User.MKBTermD(termId)),4)  //知识库注册id
	q:MKBTBaseDR="" ""
	s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBaseDR)),3)  //知识库注册描述
	if (MKBTBDesc="疾病")
	{
		s ContrastID=0  //遍历决策知识库与医为百科对照，找到决策知识库描述
		for  
		{		
			s ContrastID=$o(^User.DHCDSSWikiCMKBContrastI("WikiNameIndex",MKBTDesc,ContrastID)) q:ContrastID=""
			s CMKBName=$lg($g(^User.DHCDSSWikiCMKBContrastD(ContrastID)),4)
			s DiseaseDR=$o(^User.DHCDSSDiseaseDictI("NameIndex"," "_CMKBName,0))  //决策知识库id
			continue:DiseaseDR="" 
			s RowId = 0
			for
			{
				s RowId = $o(^User.DHCDSSDiseJoinliteratureI("DiseaseDRIndex",DiseaseDR,RowId)) q:RowId=""
				s MKBDMCodeDR = $lg($g(^User.DHCDSSDiseJoinliteratureD(RowId)),3)
				continue:MKBDMCodeDR=""

	            s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMCodeDR)),2)
	            s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMCodeDR)),3)
	            s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMCodeDR)),4)
	            s MKBDMNote=$LISTGET($G(^User.MKBDocManageD(MKBDMCodeDR)),11) 
	            s MKBDMClassify=$LISTGET($G(^User.MKBDocManageD(MKBDMCodeDR)),12) 
	            continue:$ZCONVERT(MKBDMClassify,"U")'[$ZCONVERT(Classify,"U")

				s mainstr="{""DocRowId"":"""_MKBDMCodeDR_""",""DocDesc"":"""_MKBDMDesc_""",""DocPath"":"""_MKBDMPath_""",""DocClassify"":"""_MKBDMClassify_"""}"	

				continue:result[mainstr	
	        	if (result'="")
				{ 
					//w "[A]"
					s result=result_"[A]"_mainstr
				}
				else
				{
					s result=mainstr
				}
				//w mainstr
			}
		}
	}
	else
	{

		s MKBKMBRowId=##class(web.DHCBL.MKB.MKBKLMappingBase).GetMBRowId("LC")  //文献对照的规则注册id

		q:(MKBKMBRowId="") ""
		
	    s docBaseFieldId = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKMBRowId," 文献",0))
	    q:(docBaseFieldId="") ""
		s docBaseFieldId=MKBKMBRowId_"||"_docBaseFieldId

		if (Exp'="")&&(MKBKMBRowId'="")
		{

			if ($D(^User.MKBMappingRelyI("TermIndex",MKBKMBRowId,Exp))'=0)	
			{
				s MDRowId=0
				for
				{
					s MDRowId =$O(^User.MKBMappingRelyI("TermIndex",MKBKMBRowId,Exp,MDRowId))
					q:MDRowId=""
					
					s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
					continue:RowNum=""
					s RNArr(RowNum)=1	
				}	
			}	
			
		}
		s RowNum=""
		for
		{
			s RowNum=$O(RNArr(RowNum))
			q:RowNum=""
			
			s SortRNArr(RNArr(RowNum),RowNum)=""	
		}
			
				
		s priority=""
		for  
		{	
			s priority=$o(SortRNArr(priority),-1) 
			q:priority=""
			
			s RowNum=0
			for
			{
				s RowNum = $O(SortRNArr(priority,RowNum))
				q:RowNum=""
				
				s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,docBaseFieldId,0))  //扩展属性内容表的id
				continue:MKBKMDRowId=""

				s MKBKMDValue=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),2) //扩展属性内容的值
				continue:MKBKMDValue=""

	            s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),2)
	            s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),3)
	            s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),4)
	            s MKBDMNote=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),11) 
	            s MKBDMClassify=$LISTGET($G(^User.MKBDocManageD(MKBKMDValue)),12) 
	            continue:$ZCONVERT(MKBDMClassify,"U")'[$ZCONVERT(Classify,"U")

				s mainstr="{""DocRowId"":"""_MKBKMDValue_""",""DocDesc"":"""_MKBDMDesc_""",""DocPath"":"""_MKBDMPath_""",""DocClassify"":"""_MKBDMClassify_"""}"	

				continue:result[mainstr	
	        	if (result'="")
				{ 
					//w "[A]"
					s result=result_"[A]"_mainstr
				}
				else
				{
					s result=mainstr
				}
				//w mainstr
						
			    //s:result'="" result=result_"[A]"_mainstr
				//s:result="" result=mainstr								
					
			}
		}
	}			
	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-09-04
/// Description:保存上传文档，如果有表达式传入的话，在规则管理自动生成一条数据。
/// Table:User.MKBDocManage和User.MKBKLMappingDetail
/// Input：eobj-文献管理的实体类,detailIdStr-表达式,mappingBase-规则注册id,termBase-表达式所在的术语库注册id
/// Return:成功返回术语条目描述或者文献管理描述或者评估表描述
/// Other:d ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveUploadDoc()
ClassMethod SaveUploadDoc(eobj As web.Entity.MKB.MKBDocManage, mappingBase As %String, termBase As %String, detailIdStr As %String)
{
	//先保存文献
	s result=##class(web.DHCBL.MKB.MKBDocManage).SaveData(eobj)
	if (result["true")
	{
		s docid=$p($g(result),"'",4)  //文献id
		
		//如果表达式相关信息不为空，则自动保存数据到规则管理
		if ((docid'="")&(mappingBase'="")&(termBase'="")&(detailIdStr'=""))  
		{
		
			s fieldValueStr=""  //要保存的数据串 
			s expStr="",docStr=""  
		    s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(mappingBase)),5)  //知识点1		
			s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(mappingBase)),6)  //知识点2
			s MKBKMBFSequence = 0
			for
			{
				s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",mappingBase,MKBKMBFSequence))
				q:MKBKMBFSequence=""
						
				s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",mappingBase,MKBKMBFSequence,0))
				s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(mappingBase,"ChildField",MKBKMBFChildSub)),4)   //字段格式
				s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(mappingBase,"ChildField",MKBKMBFChildSub)),5)	  //字段配置项
				continue:((MKBKMBFType'="K1")&(MKBKMBFType'="K2"))
				//如果知识点1或者知识点2是表达式				
				if ((MKBKMBFType="K1")&(MKBKMBKnowledge1=termBase)&(MKBKMBFConfig="Exp"))||((MKBKMBFType="K2")&(MKBKMBKnowledge2=termBase)&(MKBKMBFConfig="Exp"))
				{
					s expStr=MKBKMBFChildSub_"[A]"_detailIdStr
				}
				//如果知识点1或者知识点2是文献
				
				if ((MKBKMBFType="K1")&(MKBKMBKnowledge1="D"))||((MKBKMBFType="K2")&(MKBKMBKnowledge2="D"))
				{
					s docStr=MKBKMBFChildSub_"[A]"_docid
				}
				
			}
			if (expStr'="")&(docStr'="")
			{
				s fieldValueStr=docStr_"[N]"_expStr
				s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",mappingBase,fieldValueStr)	
			}
		}
		//s ^TMP("text")=docid_"^"_mappingBase_"^"_fieldValueStr
		
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-10-25
/// Description:根据国际码获取中文释义-用于his版icd对照界面国际码的悬浮提示
/// Table:User.MKBTermBase、User.MKBTerm、User.MKBTermProperty、User.MKBTermProDetail
/// Input：IntCode-国际码代码
/// Return:国际码中文释义
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetTooltipByIntCode("U85")
ClassMethod GetTooltipByIntCode(IntCode As %String)
{
	q:IntCode="" ""
	//s base = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0)) //术语库注册id
	s base=##class(web.DHCBL.MKB.MKBTermProDetail).GetBaseIDByFlag("ICD10Inter")   //获取ICD10国际码术语库注册id
	
	q:base="" ""
	s IntCode=" "_$ZCONVERT(IntCode,"U") //转换成大写
	s termId=$o(^User.MKBTermI("DescIndex",base,IntCode,0))   //国际码术语id
	
	q:termId="" ""
	s propertyId=$o(^User.MKBTermPropertyI("DescIndex",termId," 中文释义",0))  //中文释义属性id
	q:propertyId="" ""
	
	s detailId=$o(^User.MKBTermProDetailI("ProIdx",propertyId,0))   //中文释义属性内容id
	q:detailId="" ""
	
    s detailDesc=$listGet($g(^User.MKBTermProDetailD(detailId)),3)  //中文释义属性内容描述
    q detailDesc
}

/// Creator:谷雪萍
/// CreatDate:2018-11-01
/// Description:根据国际码和his码id获取标识
/// Table:User.MKBTermBase、User.MKBTerm、User.MKBTermProperty、User.MKBTermProDetail
/// Input：IntCode-国际码代码,hisId-his码id
/// Return:国际码标记：如果国际码中文释义=his码中文释义或描述，则标记为可匹配，如果不等，则为不匹配，没查到则标记为无匹配
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetFlagByIntCode("Y57.9","65650")
ClassMethod GetFlagByIntCode(IntCode As %String, hisId As %String)
{
	s result="无匹配"
	q:(IntCode="")||(hisId="") result
	s intCH=..GetTooltipByIntCode(IntCode)  //获取国际码中文释义
	q:(intCH="") result
    
    s hisDesc=$listGet($g(^User.MKBTermD(hisId)),3)  //his描述
    s hisCH="" //his中文释义
    s propertyId=$o(^User.MKBTermPropertyI("DescIndex",hisId," 中文释义",0))  //中文释义属性id
	if (propertyId'="")
	{
		s detailId=$o(^User.MKBTermProDetailI("ProIdx",propertyId,0))   //中文释义属性内容id
		if (detailId'="")
		{
    		s hisCH=$listGet($g(^User.MKBTermProDetailD(detailId)),3)  //中文释义属性内容描述
		}
	}
    if (hisDesc=intCH)||(hisCH=intCH)
    {
	    s result="可匹配"
    }
    else
    {
	    s result="不匹配"
    }
    q result
}

/// Creator:谷雪萍
/// CreatDate:2019-03-06
/// Description:把规则管理的一行数据复制到另一个规则管理里去。比如科室常用诊断右键-复制到科室专业诊断
/// Table:User.MKBKLMappingDetail
/// Input：id-规则管理表的的行号，base-规则注册的id,toBase-复制到的规则注册的id
/// Return:成功返回"{success:'true',info:成功的ID}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).CopyDetailToOther(2,20,"")
ClassMethod CopyDetailToOther(id As %String, base As %String, toBase As %String) As %String
{
	q:base="" "{success:'false',errorinfo:'没有选中左侧列表的数据'}"  //返回错误信息
	q:id="" "{success:'false',errorinfo:'没有选中要复制的行'}"  //返回错误信息
	s:toBase="" toBase=$o(^User.MKBKLMappingBaseI("IdenIndex"," PD",0))   //科室专业诊断
	q:toBase="" "{success:'false',errorinfo:'没有获取到要复制到的规则管理的ID'}"  //返回错误信息

	s fieldValueStr=""   //复制行的数据串
	s result=""
	
	s MKBKMDRowId=0
	for  
	{	
		s MKBKMDRowId=$o(^User.MKBKLMappingDetailI("RowNumIndex",base,id,MKBKMDRowId)) q:MKBKMDRowId="" 
		s MKBKMDValue=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),2) //科室常用诊断各列的值
		s MKBKMDKMBaseFieldDr=$LISTGET($G(^User.MKBKLMappingDetailD(MKBKMDRowId)),3) //科室常用诊断各列在规则注册子表的ID
		s copyFieldChild=$p(MKBKMDKMBaseFieldDr,"||",2)  //科室常用诊断列的child
		s copyFieldDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",copyFieldChild)),3) //科室常用诊断列的描述
		continue:copyFieldDesc=""
		s toFieldChild=$o(^User.MKBKLMappingBaseFieldI("DescIndex",toBase," "_$ZCONVERT(copyFieldDesc,"U"),0)) //对应科室专业诊断列的child
		continue:toFieldChild=""
		if (fieldValueStr'="")
		{
			s fieldValueStr=fieldValueStr_"[N]"_toFieldChild_"[A]"_MKBKMDValue
		}
		else
		{
			s fieldValueStr=toFieldChild_"[A]"_MKBKMDValue
		}		
	}
	if (fieldValueStr'="")
	{
		s result=..SaveData("",toBase,fieldValueStr)
	}
	else
	{
		s result="{success:'false',errorinfo:'没有获取到同名的列'}"  //返回错误信息
	}
    q result
}

/// Creator:谷雪萍
/// CreatDate:2019-03-28
/// Description：生成某个规则管理界面某一行的重复判断的临时global
/// Input：base-规则注册表ID，rowNum-行，K1Child-知识点1的可编辑列，K2Child-知识点2的可编辑列
/// Return:^TMP("MKB","MKBKLMappingDetail",base,rowNum)
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).CreateRowRepeatIndex(base,rowNum,K1Child,K2Child)
ClassMethod CreateRowRepeatIndex(base As %String, rowNum As %String, K1Child As %String, K2Child As %String) As %String
{
	q:(base="")||(rowNum="") ""

	s fieldValueStr=""
	s MKBKMBFSequence = 0
	for
	{
		s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
		q:MKBKMBFSequence=""
				
		s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,0))
		s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)   //字段格式
		s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)	  //字段配置项			
				
		s MKBKMDValueStr=..GetMappingDetailValue(base, MKBKMBFChildSub,rowNum,K1Child,K2Child)	//获取规则管理明细表的值
		
		s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
		s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
		s thisStr=MKBKMBFChildSub_"[A]"_MKBKMDValue
		if (MKBKMDValueF'="")  //知识点1编辑列的id或者表达式id串
		{
			s thisStr=MKBKMBFChildSub_"[A]"_MKBKMDValueF
		}
		if (fieldValueStr'="")
		{
			s fieldValueStr=fieldValueStr_"[N]"_thisStr
		}
		else
		{
			s fieldValueStr=thisStr
		}	   						
	}
	s fieldValueStr= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(fieldValueStr)
	s ^TMP("MKB","MKBKLMappingDetail",base,rowNum)=fieldValueStr
			
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2019-03-28
/// Description：规则管理生成用于重复判断的临时global
/// Input：
/// Return:1
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).CreateAllRepeatIndex()
ClassMethod CreateAllRepeatIndex() As %String
{
	k ^TMP("MKB","MKBKLMappingDetail")
	s base=""
	for
	{  
		s base=$o(^User.MKBKLMappingBaseD(base),-1) 
		q:base=""  
		s K1K2ChildStr=..GetK1AndK2EditChild(base)   //获取知识点1和知识点2的编辑列
		s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
		s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列	
		s MKBKMDRowNum=0
		for  
		{	
			s MKBKMDRowNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",base,MKBKMDRowNum)) q:MKBKMDRowNum="" 
			d ..CreateRowRepeatIndex(base,MKBKMDRowNum,K1Child,K2Child)
		}
	}
		
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2019-07-10
/// Description:保存科室专业诊断
/// Table:User.MKBKLMappingDetail
/// Input：diaId-诊断ID，locId-专业科室的id,freq-频次,flag-科室常用诊断(CD)/科室专业诊断的标识（PD）
/// Return:成功返回"{success:'true',id:成功的ID}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveLocProfessionalDia(14870,17228,2)
ClassMethod SaveLocProfessionalDia(diaId As %String, locId As %String, freq As %String = "", flag As %String = "PD") As %String
{
	q:(flag'="PD")&(flag'="CD") "{success:'false',errorinfo:'该方法只适用于保存科室常用诊断或者科室专业诊断！'}"  //返回错误信息
	q:diaId="" "{success:'false',errorinfo:'诊断不能为空'}"  //返回错误信息
	q:locId="" "{success:'false',errorinfo:'科室不能为空'}"  //返回错误信息
	
	s base=$o(^User.MKBKLMappingBaseI("IdenIndex"," "_flag,0))
	q:base="" "{success:'false',errorinfo:'没有获取到规则注册的ID'}"  //返回错误信息
	
	s diaChild=$o(^User.MKBKLMappingBaseFieldI("DescIndex",base," 诊断",0))
	q:diaChild="" "{success:'false',errorinfo:'没有获取到诊断列'}"  //返回错误信息
	s locChild=$o(^User.MKBKLMappingBaseFieldI("DescIndex",base," 科室",0))
	q:locChild="" "{success:'false',errorinfo:'没有获取到科室列'}"  //返回错误信息
	
	s freqChild=$o(^User.MKBKLMappingBaseFieldI("DescIndex",base," 频次",0))
	
    s fieldValueStr=diaChild_"[A]"_diaId_"[N]"_locChild_"[A]"_locId
    if (freq'="")&(freqChild'="")
    {
	     s fieldValueStr=fieldValueStr_"[N]"_freqChild_"[A]"_freq
    }

	s result=..SaveData("",base,fieldValueStr)

    q result
}

/// Creator:谷雪萍
/// CreatDate:2019-08-1
/// Description：根据属性id获取诊断模板中的展示格式
/// Input：属性id
/// Other: w ##class(web.DHCBL.MKB.SDSStructDiagnos).GetShowType("4994")
ClassMethod GetShowType(property) As %String
{
	k ^TMPMKBSHOWTYPE
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
          s ^TMPMKBSHOWTYPE(MKBTPRowId)=MKBTPShowType
        }
	}
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2019-08-1
/// Description：根据标识获取属性id
/// Input: termid术语id，desc属性描述
/// return:属性id
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetPropertyIdByFlag("16354","DT")
ClassMethod GetPropertyIdByFlag(termid As %String, flag As %String) As %String
{
	s propertyid=""
	s propertyid=$o(^User.MKBTermPropertyI("FlagIndex",termid," "_flag,0))
	q propertyid
}

/// Creator:谷雪萍
/// CreatDate:2019-8-01
/// Description：获取结构化诊断的信息,用于双击表达式可编辑表格的时候勾选相应信息
/// Input：expValue 表达式的值
/// Return：术语属性内容值串^诊断展示名^诊断备注
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetExpData("843")
ClassMethod GetExpData(expValue) As %String
{
	
	s result=""
	s SDSTermDR=$p(expValue,"-",1) //诊断id	
	q:SDSTermDR="" ""
	s PropertyDR=..GetPropertyIdByFlag(SDSTermDR,"DT")
	q:PropertyDR="" ""
	d ..GetShowType(PropertyDR)
	
	s SDSValue=$p(expValue,"-",2) //属性id串
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	s GridCheckedIdStr=""
	if (SDSValue'=""){
		s len=$Length(SDSValue,",")
		for i=1:1:len{
			s progroup=$p(SDSValue,",",i)
			s key=$p(progroup,":",1)
			s value=$p(progroup,":",2)
			s len2 = $Length(value,"*")		
			for j=1:1:len2{
				s value1=$p(value,"*",j)
				if (value1 [ "S"){
					s value1 = 	$p(value1,"S",2)
				}
			 	if ($g(^TMPMKBSHOWTYPE(key))="T"){
				 	if (TreeCheckedIdStr=""){
						s TreeCheckedIdStr=value1
					}else{
						s TreeCheckedIdStr=TreeCheckedIdStr_"&"_value1
					}
				}	
				if ($g(^TMPMKBSHOWTYPE(key))="C"){
					if (ComboCheckedIdStr=""){
						s ComboCheckedIdStr=value1
					}else{
						s ComboCheckedIdStr=ComboCheckedIdStr_"&"_value1
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="CB"){
					if (RadioCheckedIdStr=""){
						s RadioCheckedIdStr=value1
					}else{
						s RadioCheckedIdStr=RadioCheckedIdStr_"&"_value1
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="CG"){
					if (CheckBoxCheckedIdStr=""){
						s CheckBoxCheckedIdStr=value1
					}else{
						s CheckBoxCheckedIdStr=CheckBoxCheckedIdStr_"&"_value1
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="G"){
					if (GridCheckedIdStr=""){
						s GridCheckedIdStr=value1
					}else{
						s GridCheckedIdStr=GridCheckedIdStr_"&"_value1
					}
				}
			}
		}
	}
	s result=TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_GridCheckedIdStr
	q result
}

/// Creator:谷雪萍
/// CreatDate:2019-8-01
/// Description：获取结构化诊断的描述
/// Input：expValue 表达式的值
/// Return：表达式的描述
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingDetail).GetExpData("843")
ClassMethod GetExpDesc(expValue) As %String
{
	s SDSTermDR=$p(expValue,"-",1) //诊断id
	s SDSValue=$p(expValue,"-",2) //属性id串
	q:SDSTermDR="" ""
	s result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(SDSValue,SDSTermDR)
	q result
}

/// Creator:谷雪萍
/// CreatDate:2020-02-19
/// Description:术语维护界面-映射类型的属性内容维护区域，调的csp中入参是传detailIdStr还是传termRowId
/// Input：termBase-术语库注册的id,mappingBase-规则注册的ID
/// Return: T:传术语的参数-termRowId，E：传表达式的参数-detailIdStr，空:规则注册里没有该术语的对照关系
/// Other:w ##class(web.DHCBL.MKB.MKBKLMappingDetail).InputExpOrTermParam(mappingBase,termBase)
ClassMethod InputExpOrTermParam(mappingBase As %String, termBase As %String) As %String
{
	q:termBase="" ""
	s result="T"  //默认是调术语的接口 
		
	s MKBKMBMappingRelation=$LISTGET($G(^User.MKBKLMappingBaseD(mappingBase)),4) // 映射关系
	s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(mappingBase)),5)  //知识点1		
	s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(mappingBase)),6)  //知识点2
	
	s flag=0  
	//先判断映射关系。1对2的话得满足知识点1=termbase， 2对1的话得满足知识点2=termbase，双向的话知识点1知识点2一个满足就可以。
	if (MKBKMBMappingRelation=1)
	{
		if (termBase=MKBKMBKnowledge1)
		{
			s flag=1
		}
	}
	elseif(MKBKMBMappingRelation=2)
	{
		if (termBase=MKBKMBKnowledge2)
		{
			s flag=1
		}
	
	}
	else
	{
		if ((termBase=MKBKMBKnowledge1)||(termBase=MKBKMBKnowledge2))
		{
			s flag=1
		}

	}
	q:flag=0 ""
	
	s mainstr=""
	s MKBKMBFSequence = 0
	for
	{
		s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",mappingBase,MKBKMBFSequence))
		q:MKBKMBFSequence=""
		s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",mappingBase,MKBKMBFSequence,0))
		
		s MKBKMBFRowId = mappingBase_"||"_MKBKMBFChildSub
		s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(mappingBase,"ChildField",MKBKMBFChildSub)),3)
		continue:MKBKMBFDesc=""

		s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(mappingBase,"ChildField",MKBKMBFChildSub)),4)
		s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(mappingBase,"ChildField",MKBKMBFChildSub)),5)
		s:MKBKMBFType="" MKBKMBFType="TX"
	
		if ((MKBKMBFType="K1")&(MKBKMBFConfig="Exp")&(termBase=MKBKMBKnowledge1))||((MKBKMBFType="K2")&(MKBKMBFConfig="Exp")&(termBase=MKBKMBKnowledge2))
		{
			s result="E"
			q
				
		}

	}
	
	q result
}

}

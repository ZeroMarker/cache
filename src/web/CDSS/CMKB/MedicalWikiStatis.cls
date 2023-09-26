/// Description: 医为百科统计界面
/// Creator: 丁亚男
/// Date: 2021-10-21
Class web.CDSS.CMKB.MedicalWikiStatis Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：获取属性内容列表的数据
/// Input：rowid, desc, BaseDR, rows, page
/// Return:Json格式的字符串
/// Other:w ##class(web.CDSS.CMKB.MedicalWikiStatis).GetMyList("","","测试","","","","","",20,1)
ClassMethod GetMyList(rowid, BaseDR As %String, desc As %String, SStatus As %String, SResponUser As %String, SReviewUser As %String, SUpdateDate As %String, EUpdateDate As %String, rows, page) As %String
{
	s result="",total=0,jsonstr=""

	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	w "{""rows"":["
	
	if (rowid'="") //根据rowid返回该条记录
	{
		
		s total=total+1
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
		s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
		s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //拼音码
		s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
		s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
		s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
		s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
		s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
		s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
		s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
		s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
		s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
		s WikiName=""
		if (WikiMKBTPRowId'="")
		{
			s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
			s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
		}
		
		s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
		s AliasName=""
		if (AliasMKBTPRowId'="")
		{
			s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
			s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
		}
		
		s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
		s MKBTBDesc="",MKBTBCode=""
		s:MKBTBaseDR'="" MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),2)
		s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
		
		s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTDetailCount"":"""_MKBTDetailCount
		_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""",""WikiName"":"""_WikiName
		_""",""AliasName"":"""_AliasName_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTBCode"":"""_MKBTBCode_""",""MKBTBDesc"":"""_MKBTBDesc_"""}"
		w mainstr

	}
	else
	{	
		
		s:SResponUser'="" SResponUser=$ZCONVERT(SResponUser,"U") //转换成大写
		s:SReviewUser'="" SReviewUser=$ZCONVERT(SReviewUser,"U") //转换成大写
		
		//类型不为空单独写，提高检索效率
		if (BaseDR'="")
		{
			s MKBTBaseDR=BaseDR
			s MKBTBDesc="",MKBTBCode=""
			s MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(BaseDR)),2)
			s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(BaseDR)),3)
			
			if ($d(^CT.WDT.CDSS.TermI("BaseDateIndex",BaseDR)))  //该术语库下有数据
			{
				//先输出完全匹配的数据
				if (desc'="")
				{
					s MKBTRowId=0
					for
					{
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",BaseDR," "_$ZCONVERT(desc,"U"),MKBTRowId)) q:MKBTRowId=""
						s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
						s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
						s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
						s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
						s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
						s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
						s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
						s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
						s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
						s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
						s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
						s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
						s WikiName=""
						if (WikiMKBTPRowId'="")
						{
							s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
							s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
						}
						
						s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
						s AliasName=""
						if (AliasMKBTPRowId'="")
						{
							s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
							s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
						}
		
						s UpdateDateUDate="", UpdateDateUTime=""
						if (UpdateDate'="")
						{ 
							s UpdateDateU=$ZDTH(UpdateDate,3)
							s UpdateDateUDate=$p(UpdateDateU,",",1)
							s UpdateDateUTime=$p(UpdateDateU,",",2)
						}	
						
						s SUpdateDateFlag=1
						if (SUpdateDate'="")
						{
							s SUpdateDateU=$ZDTH(SUpdateDate,3)
							s SUpdateDateUDate=$p(SUpdateDateU,",",1)
							s SUpdateDateUTime=$p(SUpdateDateU,",",2)
							if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
							{
								s SUpdateDateFlag=0	
							}
						}
						s EUpdateDateFlag=1
						if (EUpdateDate'="")
						{
							s EUpdateDateU=$ZDTH(EUpdateDate,3)
							s EUpdateDateUDate=$p(EUpdateDateU,",",1)
							s EUpdateDateUTime=$p(EUpdateDateU,",",2)
							if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
							{
								s EUpdateDateFlag=0	
							}
						}
						if (Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)  //条件
						{
							s total=total+1
						    if (total<stpage) continue
						    if (total<=endpage)
						    {
								s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTDetailCount"":"""_MKBTDetailCount
								_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""",""WikiName"":"""_WikiName
								_""",""AliasName"":"""_AliasName_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTBCode"":"""_MKBTBCode_""",""MKBTBDesc"":"""_MKBTBDesc_"""}"
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
				//输出符合检索条件的数据
				s UpdateDate1=""
				for  
				{	
					s UpdateDate1=$o(^CT.WDT.CDSS.TermI("BaseDateIndex",BaseDR,UpdateDate1),-1) q:UpdateDate1=""
					s MKBTRowId=""
					for  
					{	
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseDateIndex",BaseDR,UpdateDate1,MKBTRowId)) q:MKBTRowId=""
						if ((total+1<stpage)||(total+1>endpage))&&(desc="")    //如果不是当前页则只计数，不输出。
						{
							s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
							s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
							s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
							s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
							s UpdateDateUDate="", UpdateDateUTime=""
							if (UpdateDate'="")
							{ 
								s UpdateDateU=$ZDTH(UpdateDate,3)
								s UpdateDateUDate=$p(UpdateDateU,",",1)
								s UpdateDateUTime=$p(UpdateDateU,",",2)
							}	
							
							s SUpdateDateFlag=1
							if (SUpdateDate'="")
							{
								s SUpdateDateU=$ZDTH(SUpdateDate,3)
								s SUpdateDateUDate=$p(SUpdateDateU,",",1)
								s SUpdateDateUTime=$p(SUpdateDateU,",",2)
								if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
								{
									s SUpdateDateFlag=0	
								}
							}
							s EUpdateDateFlag=1
							if (EUpdateDate'="")
							{
								s EUpdateDateU=$ZDTH(EUpdateDate,3)
								s EUpdateDateUDate=$p(EUpdateDateU,",",1)
								s EUpdateDateUTime=$p(EUpdateDateU,",",2)
								if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
								{
									s EUpdateDateFlag=0	
								}
							}
							
						}
						else
						{ 
							s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
							s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
							s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
							s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
							s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
							s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
							s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
							s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
							s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
							s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
							s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
							s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
							s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
							s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
							s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
							s WikiName=""
							if (WikiMKBTPRowId'="")
							{
								s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
								s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
							}
							
							s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
							s AliasName=""
							if (AliasMKBTPRowId'="")
							{
								s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
								s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
							}
			
							s UpdateDateUDate="", UpdateDateUTime=""
							if (UpdateDate'="")
							{ 
								s UpdateDateU=$ZDTH(UpdateDate,3)
								s UpdateDateUDate=$p(UpdateDateU,",",1)
								s UpdateDateUTime=$p(UpdateDateU,",",2)
							}	
							
							s SUpdateDateFlag=1
							if (SUpdateDate'="")
							{
								s SUpdateDateU=$ZDTH(SUpdateDate,3)
								s SUpdateDateUDate=$p(SUpdateDateU,",",1)
								s SUpdateDateUTime=$p(SUpdateDateU,",",2)
								if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
								{
									s SUpdateDateFlag=0	
								}
							}
							s EUpdateDateFlag=1
							if (EUpdateDate'="")
							{
								s EUpdateDateU=$ZDTH(EUpdateDate,3)
								s EUpdateDateUDate=$p(EUpdateDateU,",",1)
								s EUpdateDateUTime=$p(EUpdateDateU,",",2)
								if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
								{
									s EUpdateDateFlag=0	
								}
							}
						}
						if (desc'="")
						{
							continue:$ZCONVERT(desc,"U")=$ZCONVERT(MKBTDesc,"U")
							s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
							s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
							s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
							s aliasDescU=$ZCONVERT(aliasDesc,"U")
							s aliasKeyU=$ZCONVERT(aliasKey,"U")
							
							if ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))&&(Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)
			  					&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)  //条件
							{
								s total=total+1
							    if (total<stpage) continue
							    if (total<=endpage)
							    {
									s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTDetailCount"":"""_MKBTDetailCount
									_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""",""WikiName"":"""_WikiName
									_""",""AliasName"":"""_AliasName_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTBCode"":"""_MKBTBCode_""",""MKBTBDesc"":"""_MKBTBDesc_"""}"
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
						else
						{
							if (Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)
							{
								s total=total+1
							    if (total<stpage) continue
							    if (total<=endpage)
							    {
									s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTDetailCount"":"""_MKBTDetailCount
									_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""",""WikiName"":"""_WikiName
									_""",""AliasName"":"""_AliasName_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTBCode"":"""_MKBTBCode_""",""MKBTBDesc"":"""_MKBTBDesc_"""}"
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
		else
		{
			//先输出完全匹配的数据
			if (desc'="")
			{
				s MKBTRowId=0
				for
				{
					s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DDescIndex"," "_$ZCONVERT(desc,"U"),MKBTRowId)) q:MKBTRowId=""
					s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
					s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
					s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
					s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
					s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
					s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
					s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
					s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
					s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
					s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
					s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
					s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
					s MKBTBDesc="",MKBTBCode=""
					s:MKBTBaseDR'="" MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),2)
					s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
		
		
					s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
					s WikiName=""
					if (WikiMKBTPRowId'="")
					{
						s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
						s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
					}
					
					s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
					s AliasName=""
					if (AliasMKBTPRowId'="")
					{
						s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
						s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
					}
	
					s UpdateDateUDate="", UpdateDateUTime=""
					if (UpdateDate'="")
					{ 
						s UpdateDateU=$ZDTH(UpdateDate,3)
						s UpdateDateUDate=$p(UpdateDateU,",",1)
						s UpdateDateUTime=$p(UpdateDateU,",",2)
					}	
					
					s SUpdateDateFlag=1
					if (SUpdateDate'="")
					{
						s SUpdateDateU=$ZDTH(SUpdateDate,3)
						s SUpdateDateUDate=$p(SUpdateDateU,",",1)
						s SUpdateDateUTime=$p(SUpdateDateU,",",2)
						if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
						{
							s SUpdateDateFlag=0	
						}
					}
					s EUpdateDateFlag=1
					if (EUpdateDate'="")
					{
						s EUpdateDateU=$ZDTH(EUpdateDate,3)
						s EUpdateDateUDate=$p(EUpdateDateU,",",1)
						s EUpdateDateUTime=$p(EUpdateDateU,",",2)
						if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
						{
							s EUpdateDateFlag=0	
						}
					}
					if (Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)  //条件
					{
						s total=total+1
					    if (total<stpage) continue
					    if (total<=endpage)
					    {
							s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTDetailCount"":"""_MKBTDetailCount
							_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""",""WikiName"":"""_WikiName
							_""",""AliasName"":"""_AliasName_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTBCode"":"""_MKBTBCode_""",""MKBTBDesc"":"""_MKBTBDesc_"""}"
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
				
			//输出符合条件的数据	
			s UpdateDate1=""
			for  
			{	
				s UpdateDate1=$o(^CT.WDT.CDSS.TermI("DateIndex",UpdateDate1),-1) q:UpdateDate1=""
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DateIndex",UpdateDate1,MKBTRowId)) q:MKBTRowId=""
					if ((total+1<stpage)||(total+1>endpage))  //如果不是当前页则只计数，不输出。
					{
						s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
						s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
						s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
						s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
						s UpdateDateUDate="", UpdateDateUTime=""
						if (UpdateDate'="")
						{ 
							s UpdateDateU=$ZDTH(UpdateDate,3)
							s UpdateDateUDate=$p(UpdateDateU,",",1)
							s UpdateDateUTime=$p(UpdateDateU,",",2)
						}	
						
						s SUpdateDateFlag=1
						if (SUpdateDate'="")
						{
							s SUpdateDateU=$ZDTH(SUpdateDate,3)
							s SUpdateDateUDate=$p(SUpdateDateU,",",1)
							s SUpdateDateUTime=$p(SUpdateDateU,",",2)
							if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
							{
								s SUpdateDateFlag=0	
							}
						}
						s EUpdateDateFlag=1
						if (EUpdateDate'="")
						{
							s EUpdateDateU=$ZDTH(EUpdateDate,3)
							s EUpdateDateUDate=$p(EUpdateDateU,",",1)
							s EUpdateDateUTime=$p(EUpdateDateU,",",2)
							if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
							{
								s EUpdateDateFlag=0	
							}
						}	
					}
					else
					{ 
						
						s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
						s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
						s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
						s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
						s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
						s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
						s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
						s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
						s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
						s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
						s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
						s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
						s MKBTBDesc="",MKBTBCode=""
						s:MKBTBaseDR'="" MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),2)
						s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
			
			
						s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
						s WikiName=""
						if (WikiMKBTPRowId'="")
						{
							s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
							s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
						}
						
						s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
						s AliasName=""
						if (AliasMKBTPRowId'="")
						{
							s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
							s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
						}
		
						s UpdateDateUDate="", UpdateDateUTime=""
						if (UpdateDate'="")
						{ 
							s UpdateDateU=$ZDTH(UpdateDate,3)
							s UpdateDateUDate=$p(UpdateDateU,",",1)
							s UpdateDateUTime=$p(UpdateDateU,",",2)
						}	
						
						s SUpdateDateFlag=1
						if (SUpdateDate'="")
						{
							s SUpdateDateU=$ZDTH(SUpdateDate,3)
							s SUpdateDateUDate=$p(SUpdateDateU,",",1)
							s SUpdateDateUTime=$p(SUpdateDateU,",",2)
							if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
							{
								s SUpdateDateFlag=0	
							}
						}
						s EUpdateDateFlag=1
						if (EUpdateDate'="")
						{
							s EUpdateDateU=$ZDTH(EUpdateDate,3)
							s EUpdateDateUDate=$p(EUpdateDateU,",",1)
							s EUpdateDateUTime=$p(EUpdateDateU,",",2)
							if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
							{
								s EUpdateDateFlag=0	
							}
						}
				

					}
					if (desc'="")
					{
						continue:$ZCONVERT(desc,"U")=$ZCONVERT(MKBTDesc,"U")
						s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
						s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
						s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
						s aliasDescU=$ZCONVERT(aliasDesc,"U")
						s aliasKeyU=$ZCONVERT(aliasKey,"U")
						
						if ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))&&(Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)
		  					&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)  //条件
						{
							s total=total+1
						    if (total<stpage) continue
						    if (total<=endpage)
						    {
								s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTDetailCount"":"""_MKBTDetailCount
								_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""",""WikiName"":"""_WikiName
								_""",""AliasName"":"""_AliasName_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTBCode"":"""_MKBTBCode_""",""MKBTBDesc"":"""_MKBTBDesc_"""}"
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
					else
					{
						if (Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)
						{
							s total=total+1
						    if (total<stpage) continue
						    if (total<=endpage)
						    {
								s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTDetailCount"":"""_MKBTDetailCount
								_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""",""WikiName"":"""_WikiName
								_""",""AliasName"":"""_AliasName_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTBCode"":"""_MKBTBCode_""",""MKBTBDesc"":"""_MKBTBDesc_"""}"
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
}

/// Creator：丁亚男
/// CreatDate:2021-09-02
/// Description：查询列表子术语库内容
/// Table：CT.WDT.CDSS.Term
/// Input：rowid,desc,BaseDR
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.MedicalWikiStatis","GetList","","","","","","","","")
Query GetList(Rowid As %String, BaseDR As %String, desc As %String, SStatus As %String, SResponUser As %String, SReviewUser As %String, SUpdateDate As %String, EUpdateDate As %String) As %Query(ROWSPEC = "MKBTRowId,MKBTCode,MKBTDesc,MKBTPYCode,MKBTNote,MKBTSequence,MKBTDetailCount,UpdateDate,ResponUser,ReviewUser,Status,MKBTBaseDR,MKBTBCode,MKBTBDesc,WikiName,AliasName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, Rowid As %String, BaseDR As %String, desc As %String, SStatus As %String, SResponUser As %String, SReviewUser As %String, SUpdateDate As %String, EUpdateDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (Rowid'="") //根据rowid返回该条记录
	{
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
		s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
		s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //拼音码
		s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
		s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
		s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
		s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)  //顺序
		s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
		s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
		s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
		s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
		s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
		s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
		s WikiName=""
		if (WikiMKBTPRowId'="")
		{
			s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
			s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
		}
		
		s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
		s AliasName=""
		if (AliasMKBTPRowId'="")
		{
			s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
			s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
		}
		
		s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
		s MKBTBDesc="",MKBTBCode=""
		s:MKBTBaseDR'="" MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),2)
		s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
		
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:SResponUser'="" SResponUser=$ZCONVERT(SResponUser,"U") //转换成大写
		s:SReviewUser'="" SReviewUser=$ZCONVERT(SReviewUser,"U") //转换成大写
		
		//类型不为空单独写，提高检索效率
		if (BaseDR'="")
		{
			s MKBTBaseDR=BaseDR
			s MKBTBDesc="",MKBTBCode=""
			s MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(BaseDR)),2)
			s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(BaseDR)),3)
			
			if ($d(^CT.WDT.CDSS.TermI("BaseDateIndex",BaseDR)))  //该术语库下有数据
			{
				s UpdateDate1=""
				for  
				{	
					s UpdateDate1=$o(^CT.WDT.CDSS.TermI("BaseDateIndex",BaseDR,UpdateDate1),-1) q:UpdateDate1=""
					s MKBTRowId=""
					for  
					{	
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseDateIndex",BaseDR,UpdateDate1,MKBTRowId)) q:MKBTRowId=""
						s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
						s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
						s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
						s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
						s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
						s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
						s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
						s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
						s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
						s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
						s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
						s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
						s WikiName=""
						if (WikiMKBTPRowId'="")
						{
							s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
							s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
						}
						
						s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
						s AliasName=""
						if (AliasMKBTPRowId'="")
						{
							s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
							s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
						}
		
						s UpdateDateUDate="", UpdateDateUTime=""
						if (UpdateDate'="")
						{ 
							s UpdateDateU=$ZDTH(UpdateDate,3)
							s UpdateDateUDate=$p(UpdateDateU,",",1)
							s UpdateDateUTime=$p(UpdateDateU,",",2)
						}	
						
						s SUpdateDateFlag=1
						if (SUpdateDate'="")
						{
							s SUpdateDateU=$ZDTH(SUpdateDate,3)
							s SUpdateDateUDate=$p(SUpdateDateU,",",1)
							s SUpdateDateUTime=$p(SUpdateDateU,",",2)
							if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
							{
								s SUpdateDateFlag=0	
							}
						}
						s EUpdateDateFlag=1
						if (EUpdateDate'="")
						{
							s EUpdateDateU=$ZDTH(EUpdateDate,3)
							s EUpdateDateUDate=$p(EUpdateDateU,",",1)
							s EUpdateDateUTime=$p(EUpdateDateU,",",2)
							if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
							{
								s EUpdateDateFlag=0	
							}
						}
				
						if (desc'=""){
							s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
							s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
							s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
							s aliasDescU=$ZCONVERT(aliasDesc,"U")
							s aliasKeyU=$ZCONVERT(aliasKey,"U")
							
							if ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))&&(Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)
			  					&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)  //条件
							{
								d OutputRow
							}
						}
						else
						{
							if (Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)
							{
								d OutputRow
							}
						}		
						
					}
				}
			}
		}
		else
		{
			s UpdateDate1=""
			for  
			{	
				s UpdateDate1=$o(^CT.WDT.CDSS.TermI("DateIndex",UpdateDate1),-1) q:UpdateDate1=""
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DateIndex",UpdateDate1,MKBTRowId)) q:MKBTRowId=""
					s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
					s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
					s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
					s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
					s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
					s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
					s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
					s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)  
					s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
					s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)  
					s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
					s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
					s MKBTBDesc="",MKBTBCode=""
					s:MKBTBaseDR'="" MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),2)
					s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
		
		
					s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
					s WikiName=""
					if (WikiMKBTPRowId'="")
					{
						s WikiType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(WikiMKBTPRowId)),4)
						s WikiName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(WikiType,WikiMKBTPRowId)
					}
					
					s AliasMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",""))
					s AliasName=""
					if (AliasMKBTPRowId'="")
					{
						s AliasType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(AliasMKBTPRowId)),4)
						s AliasName=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(AliasType,AliasMKBTPRowId)
					}
	
					s UpdateDateUDate="", UpdateDateUTime=""
					if (UpdateDate'="")
					{ 
						s UpdateDateU=$ZDTH(UpdateDate,3)
						s UpdateDateUDate=$p(UpdateDateU,",",1)
						s UpdateDateUTime=$p(UpdateDateU,",",2)
					}	
					
					s SUpdateDateFlag=1
					if (SUpdateDate'="")
					{
						s SUpdateDateU=$ZDTH(SUpdateDate,3)
						s SUpdateDateUDate=$p(SUpdateDateU,",",1)
						s SUpdateDateUTime=$p(SUpdateDateU,",",2)
						if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
						{
							s SUpdateDateFlag=0	
						}
					}
					s EUpdateDateFlag=1
					if (EUpdateDate'="")
					{
						s EUpdateDateU=$ZDTH(EUpdateDate,3)
						s EUpdateDateUDate=$p(EUpdateDateU,",",1)
						s EUpdateDateUTime=$p(EUpdateDateU,",",2)
						if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
						{
							s EUpdateDateFlag=0	
						}
					}
			
					if (desc'=""){
						s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
						s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
						s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
						s aliasDescU=$ZCONVERT(aliasDesc,"U")
						s aliasKeyU=$ZCONVERT(aliasKey,"U")
						
						if ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))&&(Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)
		  					&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)  //条件
						{
							d OutputRow
						}
					}
					else
					{
						if (Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)
						{
							d OutputRow
						}
					}		
					
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTRowId,MKBTCode,MKBTDesc,MKBTPYCode,MKBTNote,MKBTSequence,MKBTDetailCount,UpdateDate,ResponUser,ReviewUser,Status,MKBTBaseDR,MKBTBCode,MKBTBDesc,WikiName,AliasName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:丁亚男
/// CreatDate:2021-10-22
/// Input: MKBTRowId 术语ID Status 状态(编辑中0，已弃用1，已审核2，待审核3)
/// Return:
/// Other:w ##class(web.CDSS.CMKB.MedicalWikiStatis).ChangeStatus(182,"上线")
ClassMethod ChangeStatus(MKBTRowId, Opreation)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
	if (Opreation="提交审核") s eobj.Status=3
	
	if Opreation="审核通过"
	{
		s eobj.Status=2
		s eobj.ReviewUser=%session.Data("LOGON.USERNAME")
	}
	if Opreation="驳回"
	{
		s eobj.Status=0
		s eobj.ReviewUser=%session.Data("LOGON.USERNAME")
	}
	if Opreation="弃用"
	{
		s eobj.Status=1
		s eobj.ReviewUser=%session.Data("LOGON.USERNAME")
	}
	s eobj.UpdateDate=$zdt($h,3)
	s eobj.MKBTRowId=MKBTRowId
	
 	s obj=##class(CT.WDT.CDSS.Term).%OpenId(MKBTRowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.Term).%New()
 	if $IsObject(obj.MKBTBaseDR)
	{
	 	s bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
	}
 	s bobj.Status=obj.Status
 	s bobj.ReviewUser=obj.ReviewUser
 	s bobj.UpdateDate=obj.UpdateDate
 	
 	s obj.Status=eobj.Status
 	s obj.ReviewUser=eobj.ReviewUser
 	s obj.UpdateDate=eobj.UpdateDate
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//保存日志 描述拼接操作，在日志中读取显示
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT.WDT.CDSS.Term","CT.WDT.CDSS.Term","百科术语表",MKBTRowId,bobj.MKBTDesc_"&&"_Opreation,"U",eobj,bobj)  
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("百科术语表","web.CDSS.CMKB.MedicalWikiStatis","ChangeStatus",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}	
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-10-22
/// Description:属性和属性内容更新时，更新术语的编辑人和操作时间
/// Input: MKBTPRowId 术语属性ID
/// Return:
/// Other:w ##class(web.CDSS.CMKB.MedicalWikiStatis).UpdateLog(MKBTPRowId)
ClassMethod UpdateLog(MKBTPRowId)
{
	q:MKBTPRowId="" ""
	s result="{success:'true'}"
	s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),6)
	if (MKBTPTermDr'="")
	{
		s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
		s eobj.MKBTRowId=MKBTPTermDr
		s eobj.UpdateDate=$zdt($h,3)
		s eobj.Status=0
		s eobj.ResponUser=%session.Data("LOGON.USERNAME")
		s eobj.ReviewUser=""
		
	 	s obj=##class(CT.WDT.CDSS.Term).%OpenId(MKBTPTermDr)
	 	s bobj = ##class(web.CDSSEntity.CMKB.Term).%New()
	 	s bobj.Status=obj.Status
	 	s bobj.ResponUser=obj.ResponUser
	 	s bobj.UpdateDate=obj.UpdateDate
	 	
	 	s obj.Status=eobj.Status
	 	s obj.ResponUser=eobj.ResponUser
	 	s obj.UpdateDate=eobj.UpdateDate
	 	s obj.ReviewUser=eobj.ReviewUser
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志 描述拼接操作，在日志中读取显示
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT.WDT.CDSS.Term","CT.WDT.CDSS.Term","百科术语表",MKBTPTermDr,obj.MKBTDesc,"U",eobj,bobj)  
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("百科术语表","web.CDSS.CMKB.MedicalWikiStatis","ChangeStatus",eobj)
	   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}	
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-12-29
/// Description:获得百科术语表的日志
/// Table: CT.WDT.CDSS.Term
/// Input: TermID 术语表RowID
/// Return:返回百科术语表的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.MedicalWikiStatis","GetTermLogList","1702090")
Query GetTermLogList(TermID As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetTermLogListExecute(ByRef qHandle As %Binary, TermID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (TermID'="")
 	{
	 	//s ClassName="CT.WDT.CDSS.Term"
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.Term",TermID,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Opreation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Opreation="编辑"
         	}
         	d OutputRowLog
	    }
	    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTermLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTermLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTermLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2022-01-04
/// Description:根据名称返回状态为"待审核"或者"已审核"状态的百科术语ID
/// Input: 术语名称 术语库名称
/// Return: 术语id
/// Other:w ##class(web.CDSS.CMKB.MedicalWikiStatis).GetTermIDByDesc("疾病","胆囊结石伴慢性胆囊炎")
ClassMethod GetTermIDByDesc(basedesc As %String = "", termdesc) As %String
{
	if (basedesc="") s basedesc="疾病" 
	q:termdesc="" ""
	s MKBTRowId=""
	for
	{
		s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DDescIndex"," "_($ZCONVERT(termdesc,"U")),MKBTRowId)) q:MKBTRowId=""
		s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)  //状态
		s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
		s MKBTBDesc=""
		s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
		q:((MKBTBDesc=basedesc)&((Status=2)||(Status=3)))
		
	}
	q MKBTRowId
}

/// Creator:丁亚男
/// CreatDate:2022-01-26
/// Description:百科不同状态的数据统计
/// Table:CT.WDT.CDSS.Term
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.MedicalWikiStatis).CountData()
ClassMethod CountData()
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s MKBTRowId=0
	for  
	{	
		s MKBTRowId=$o(^CT.WDT.CDSS.TermD(MKBTRowId)) q:MKBTRowId="" 
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
		s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
		s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
		s MKBTBDesc=""
		s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
		//编辑中0，已弃用1，已审核2，待审核3
		if (Status="")||(Status="0")
	 	{
		 	s Totalcount=Totalcount+1
		 	if ((MKBTBDesc="疾病")&$d(^User.DHCDSSDiseaseDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))||((MKBTBDesc="检查")&$d(^User.DHCDSSExamDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))||((MKBTBDesc="检验")&$d(^User.DHCDSSLabInspectionDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))||((MKBTBDesc="手术")&$d(^User.DHCDSSOperationDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))||((MKBTBDesc="护理")&$d(^User.DHCDSSNursingDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))
		 	{
		 		s Editcount=Editcount+1	
		 	}
		}
		elseif (Status="2")
		{
			s Totalcount=Totalcount+1
		 	s Reviewedcount=Reviewedcount+1		
		}
		elseif (Status="3")
		{
			s Totalcount=Totalcount+1
		 	s Tobereviewedcount=Tobereviewedcount+1		
		}
	}
	
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

/// Creator:赵文伟
/// CreatDate:2022-03-15
/// Description:遍历百科中心词，查询中心词在字典中的状态，如果状态为弃用或删除，则删除该百科中心词，也删除在字典中不存在的中心词
/// Input: 
/// Return: num
/// Other:d ##class(web.CDSS.CMKB.MedicalWikiStatis).HandleAbnormalData()
ClassMethod HandleAbnormalData() As %String
{
	s MKBTRowId=0
	s result=""
	s tip=""
	s num=0
	TS
	for
	{
		s MKBTRowId=$o(^CT.WDT.CDSS.TermD(MKBTRowId)) q:MKBTRowId=""
		
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述/中心词
		s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
		s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
		s MKBTBDesc=""
		s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)	//术语库类型【疾病、检查、检验、手术、护理】
		if (MKBTBDesc="疾病"){
			//中心词=名称—（索引）—》字典ID——》状态——》删除
			
				s DiseaseRowId=$o(^User.DHCDSSDiseaseDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0)) 
				s:DiseaseRowId'="" State = $lg($g(^User.DHCDSSDiseaseDictD(DiseaseRowId)),18)
				
				if (DiseaseRowId="")||(State=1){
					s tip= MKBTBDesc_" "_MKBTDesc_" 不存在或状态为已弃用"
					//调用删除接口
					s result=  ##class(web.CDSS.CMKB.Term).DeleteData(MKBTRowId)
					}
			
		} elseif(MKBTBDesc="检查"){
			
				s ExamRowId=$o(^User.DHCDSSExamDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0)) 
				s:ExamRowId'="" State = $lg($g(^User.DHCDSSExamDictD(ExamRowId)),25)	
				
				if (ExamRowId="")||(State=1){
					s tip= MKBTBDesc_" "_MKBTDesc_" 不存在或状态为已弃用"
					//调用删除接口
					s result=  ##class(web.CDSS.CMKB.Term).DeleteData(MKBTRowId)
					}
			
		} elseif(MKBTBDesc="检验"){
			
				s LabRowId=$o(^User.DHCDSSLabInspectionDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))	//检验项目 
				s:LabRowId'="" State = $lg($g(^User.DHCDSSLabInspectionDictD(LabRowId)),24)
				
				s LabOrdersRowId=$o(^User.DHCDSSLabOrdersDictI("DescIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))	//检验医嘱 
				s:LabOrdersRowId'="" OtherState = $lg($g(^User.DHCDSSLabOrdersDictD(LabOrdersRowId)),5)
				
				if ((LabRowId="")&(LabOrdersRowId=""))||(((State=1)&(OtherState=""))||((State="")&(OtherState=1))){
					s tip= MKBTBDesc_" "_MKBTDesc_" 不存在或状态为已弃用"
					//调用删除接口
					s result=  ##class(web.CDSS.CMKB.Term).DeleteData(MKBTRowId)
					}
			
		} elseif(MKBTBDesc="手术"){
			
				s OperationRowId=$o(^User.DHCDSSOperationDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0)) 
				s:OperationRowId'="" State = $lg($g(^User.DHCDSSOperationDictD(OperationRowId)),12)
				
				if (OperationRowId="")||(State=1){
					s tip= MKBTBDesc_" "_MKBTDesc_" 不存在或状态为已弃用"
					//调用删除接口
					s result=  ##class(web.CDSS.CMKB.Term).DeleteData(MKBTRowId)
					}
			
		} elseif(MKBTBDesc="护理"){
			
				s NursingRowId=$o(^User.DHCDSSNursingDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0)) 
				s:NursingRowId'="" State = $lg($g(^User.DHCDSSNursingDictD(NursingRowId)),22)
				
				if (NursingRowId="")||(State=1){
					s tip= MKBTBDesc_" "_MKBTDesc_" 不存在或状态为已弃用"
					//调用删除接口
					s result=  ##class(web.CDSS.CMKB.Term).DeleteData(MKBTRowId)
					}	
		}
		s num=num+1
		w tip,!
		w result,!	
	}
	TC
	w "共处理 "_num_" 条数据！"
}

}

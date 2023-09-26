/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：医用知识库知识维护界面
Class web.CDSS.CMKB.Term Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2021-09-02
/// Description：辅助功能区用查询列表子术语库内容
/// Table：CT.WDT.CDSS.Term
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.Term","GetAssList","","","")
Query GetAssList(rowid, str, base) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTSequence")
{
}

ClassMethod GetAssListExecute(ByRef qHandle As %Binary, rowid, str, base) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	  
	if (base'="") //如果子术语库大类未选中
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			s MKBTRowId=rowid
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)  //顺序
			d OutputRow111
		}
		else
		{
			s:str'="" str=$ZCONVERT(str,"U")
			if ($d(^CT.WDT.CDSS.TermI("BaseIndex",base)))  //该术语库下有数据
			{
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 
					s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
					s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
					s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
					s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)
					
					if (str'=""){
						s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
						s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
						s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
						s aliasDescU=$ZCONVERT(aliasDesc,"U")
						s aliasKeyU=$ZCONVERT(aliasKey,"U")
						
						i ((MKBTDescU[str)||(MKBTPYCodeU[str)||(aliasDescU[str)||(aliasKeyU[str))  //条件
						{
							d OutputRow111
						}
					}
					else
					{
						d OutputRow111
					}		
					
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow111
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTSequence)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAssListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAssListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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
/// CreatDate:2021-09-02
/// Description：获取属性内容列表的数据
/// Input：rowid, desc, base, rows, page, sortway,closeflag
/// Return:Json格式的字符串
/// Other:w ##class(web.CDSS.CMKB.Term).GetMyList("","","120",20,1,"knocount","")
ClassMethod GetMyList(rowid, desc, base, rows, page, sortway, closeflag As %String = "", matchflag As %String = "") As %String
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
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ShowInLeftInfo=..GetShowInLeftInfo(base)
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
			s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)  //顺序
			s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
			s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
			
			s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)
			s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
			s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)
			s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
			
			
			//展示在左侧的数据
			s ExtendStr=""
			if (ShowInLeftInfo'=""){
				s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
				s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
				s len=$length(ShowInLeftDesc,"[N]")
				for i=1:1:len
				{
					s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
					s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
					s MKBTPDDesc=""
					if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
					{
						s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
						s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
						s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
					} 
					s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
				} 
			}
			
			s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount
			_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""","_ExtendStr_"}"
		    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount
		    _""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_"""}"
			w mainstr

		}
		else
		{	
			if ($d(^CT.WDT.CDSS.TermI("SeqIndex",base)))  //该术语库下有数据
			{
				if (sortway="originseq")
				{
					s MKBTSequence=0
					for  
					{	
						s MKBTSequence=$o(^CT.WDT.CDSS.TermI("SeqIndex",base,MKBTSequence)) q:MKBTSequence=""
						s MKBTRowId=0
						for  
						{	
							s MKBTRowId=$o(^CT.WDT.CDSS.TermI("SeqIndex",base,MKBTSequence,MKBTRowId)) q:MKBTRowId="" 
							s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
							continue:(closeflag="")&&(MKBTActiveFlag="N")  //判断是否显示封闭数据
							if ((total+1<stpage)||(total+1>endpage))&&(desc="")  //如果不是当前页则只计数，不输出。
							{
								
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
								if (matchflag'="")
								{
									s sameflag=0
									for m=1:1:$l(MKBTPYCodeU," ")
									{
										s PYCode=$p(MKBTPYCodeU," ",m)
										q:PYCode=""
										s:PYCode=desc sameflag=1
									}
									
									continue:(MKBTDescU'=desc)&&(sameflag=0)
								}
								s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
								s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
								s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
								s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
								s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)
								s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
								s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)
								s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
			
								//展示在左侧的数据
								s ExtendStr=""
								if (ShowInLeftInfo'=""){
									s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
									s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
									s len=$length(ShowInLeftDesc,"[N]")
									for i=1:1:len
									{
										s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
										s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
										s MKBTPDDesc=""
										if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
										{
											s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
											s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
											s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
										} 
										s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
										s:ExtendStr'="" ExtendStr=ExtendStr_","
										s ExtendStr=ExtendStr_thisStr
									} 
								}
							}
							
							if (desc'="")
							{
								s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
								s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
								s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
								s aliasDescU=$ZCONVERT(aliasDesc,"U")
								s aliasKeyU=$ZCONVERT(aliasKey,"U")
								
								i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
								{
									
								    
								    s total=total+1
								    if (total<stpage) continue
								    if (total<=endpage)
								    {
										s mainstr=""
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_"""}"
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
								
								s total=total+1
							    if (total<stpage) continue
							    if (total<=endpage)
							    {
									s mainstr=""
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_"""}"
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
				else
				{
					s MKBTDetailCount=""
					for  
					{	
						s MKBTDetailCount=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount),-1) q:MKBTDetailCount=""
						s MKBTRowId=0
						for  
						{	
							s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount,MKBTRowId)) q:MKBTRowId="" 
							s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
							continue:(closeflag="")&&(MKBTActiveFlag="N")  //判断是否显示封闭数据
							
							if ((total+1<stpage)||(total+1>endpage))&&(desc="")  //如果不是当前页则只计数，不输出。
							{
									
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
								if (matchflag'="")
								{
									s sameflag=0
									for m=1:1:$l(MKBTPYCodeU," ")
									{
										s PYCode=$p(MKBTPYCodeU," ",m)
										q:PYCode=""
										s:PYCode=desc sameflag=1
									}
									
									continue:(MKBTDescU'=desc)&&(sameflag=0)
								}
								s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
								s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
								s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)
								
								s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
								s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
								s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)
								s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
								s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)
								s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
								
								
								
								//展示在左侧的数据
								s ExtendStr=""
								if (ShowInLeftInfo'=""){
									s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
									s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
									s len=$length(ShowInLeftDesc,"[N]")
									for i=1:1:len
									{
										s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
										s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
										s MKBTPDDesc=""
										if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
										{
											s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
											s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
											s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
										} 
										s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
										s:ExtendStr'="" ExtendStr=ExtendStr_","
										s ExtendStr=ExtendStr_thisStr
									} 
								}
							}
						
							if (desc'="")
							{
								s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
								s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
								s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
								s aliasDescU=$ZCONVERT(aliasDesc,"U")
								s aliasKeyU=$ZCONVERT(aliasKey,"U")
								
								i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
								{
								    s total=total+1
								    if (total<stpage) continue
								    if (total<=endpage)
								    {
										s mainstr=""
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_"""}"
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
							    
							    s total=total+1
							    if (total<stpage) continue
							    if (total<=endpage)
							    {
									s mainstr=""
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_"""}"
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
	}
	
	q ""
}

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：根据科室获取科室的专业诊断
/// Input：TBRowId TermBase表ID TermId 诊断术语Id rows-每页显示条数, page-页数
/// Return:Json格式的数据
/// Other:d ##class(web.CDSS.CMKB.Term).GetMyLocList("77547","9",20,1)
ClassMethod GetMyLocList(TermId, TBRowId, rows, page) As %String
{
	s MBRowId=##class(web.CDSS.CMKB.MKBKLMappingBase).GetMBRowId("CD")
	s result="",total=0,jsonstr=""
	s disbasesr=##class(web.CDSS.CMKB.TermBase).GetIdByFlag("Diagnose")
	s ShowInLeftInfo=..GetShowInLeftInfo(disbasesr)
	if ((MBRowId'="")&&(TermId'=""))
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
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	w "{""rows"":["
	
	s K1K2ChildStr=##class(web.CDSS.CMKB.MKBKLMappingDetail).GetK1AndK2EditChild(MBRowId)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
	
	s RowNum=0
	for  
	{	
		s RowNum=$o(RNArr(RowNum)) 
		q:RowNum=""
		 
		s ExtendStr=""   //知识点扩展属性子表的字段
		s searchStr=""   //检索列的值拼串
		s searchStrPY=""   //检索列的值检索码	
		if ((total+1<stpage)||(total+1>endpage))  //如果不是当前页则只计数，不输出。
		{
			
		}
		else
		{
			s MKBKMBFChildSub = K2Child
			s MKBKMDValueStr=##class(web.CDSS.CMKB.MKBKLMappingDetail).GetMappingDetailValue(MBRowId, MKBKMBFChildSub,RowNum,K1Child,K2Child)  //获取知识点映射明细表的值
			
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
		//输出
		s total=total+1
		if (total<stpage) continue
		if (total<=endpage)&(MKBKMDValueF'="")
		{
			s MKBTRowId=MKBKMDValueF
			s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //拼音码
			s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
			s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)  //顺序
			s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
			s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
			
			//展示在左侧的数据
			s ExtendStr=""
			if (ShowInLeftInfo'=""){
				s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
				s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
				s len=$length(ShowInLeftDesc,"[N]")
				for i=1:1:len
				{
					s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
					s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
					s MKBTPDDesc=""
					if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
					{
						s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
						s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
						s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
					} 
					s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
				} 
			}
			
			s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""","_ExtendStr_"}"
		    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_"""}"
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
	w "], ""total"":"_total_"}"
	q ""
}

/// Creator：丁亚男
/// CreatDate:2021-09-02
/// Description：查询列表子术语库内容
/// Table：CT.WDT.CDSS.Term
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.Term","GetList","","","5")
Query GetList(rowid, desc, base) As %Query(ROWSPEC = "MKBTRowId,MKBTCode,MKBTDesc,MKBTPYCode,MKBTNote,MKBTSequence,MKBTDetailCount")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, desc, base) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	  
	if (base'="") //如果子术语库大类未选中
	{
		if (rowid'="") //根据rowid返回该条记录
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
			d OutputRow
		}
		else
		{
			s:desc'="" desc=$ZCONVERT(desc,"U")
			if ($d(^CT.WDT.CDSS.TermI("SeqIndex",base)))  //该术语库下有数据
			{
				s MKBTSequence=0
				for  
				{	
					s MKBTSequence=$o(^CT.WDT.CDSS.TermI("SeqIndex",base,MKBTSequence)) q:MKBTSequence=""
					s MKBTRowId=0
					for  
					{	
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("SeqIndex",base,MKBTSequence,MKBTRowId)) q:MKBTRowId=""
						s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
						s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
						s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
						s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
						s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
						s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
						//s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)
						s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)
						
						if (desc'=""){
							s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
							s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
							s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
							s aliasDescU=$ZCONVERT(aliasDesc,"U")
							s aliasKeyU=$ZCONVERT(aliasKey,"U")
							
							i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
							{
								d OutputRow
							}
						}
						else
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
    set Data=$lb(MKBTRowId,MKBTCode,MKBTDesc,MKBTPYCode,MKBTNote,MKBTSequence,MKBTDetailCount)
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

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description:为combobox查询取数据
/// Table：CT.WDT.CDSS.Term
/// Input：rowid,base,desc
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.Term","GetDataForCmb1","","1","")
Query GetDataForCmb1(rowid As %String, base As %String, desc As %String) As %Query(ROWSPEC = "MKBTRowId:%String,MKBTCode:%String,MKBTDesc:%String,MKBTPYCode:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, base As %String, desc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
		s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
		d OutputRowCmb
	}
	else
	{

		s MKBTRowId=""
		for  
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId)) q:MKBTRowId=""
			s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
			
			s outDiaFlag=""  //输出标识
			if (desc'="")  //如果诊断不为空
			{
				s:desc'="" desc=$ZCONVERT(desc,"U")
				

				//可以根据检索码，描述来查询  				 			
				s isDescKey=($ZCONVERT(MKBTPYCode,"U")[desc) //检索码
				s isDesc=($ZCONVERT(MKBTDesc,"U")[desc)  //描述
				i (isDescKey)||(isDesc)
				{
					s outDiaFlag="Y"
				}
				
			}
			else  //如果诊断为空
			{
				s outDiaFlag="Y"
			}
					
			i (outDiaFlag="Y")   //条件
			{
				d OutputRowCmb
	        }

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBTRowId,MKBTCode,MKBTDesc,MKBTPYCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Input：myRowID 术语Id
/// Return：当前术语及上级描述
/// Description:获取当前树形术语节点及上级的描述,引用多个术语的话，用,分隔
/// w ##class(web.CDSS.CMKB.Term).GetTreeComboDesc("24")
ClassMethod GetTreeComboDesc(myRowID As %String) As %String
{
	
	q:myRowID="" ""
	s mulTermDesc=""
	s ids=myRowID
	s idsLen=$Length(ids,",")
	for i=1:1:idsLen   
	{
		s id=$p(ids,",",i)  	
		s termDesc=$listGet($g(^CT.WDT.CDSS.TermD(id)),3)
		for
		{
			s id=$listGet($g(^CT.WDT.CDSS.TermD(id)),5)
			q:id=""
			s desc=$listGet($g(^CT.WDT.CDSS.TermD(id)),3)
			s termDesc=desc_"-"_termDesc
		}
		s:mulTermDesc'="" mulTermDesc=mulTermDesc_","_termDesc
		s:mulTermDesc="" mulTermDesc=termDesc
	}
	q mulTermDesc
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：获取修改时的记录
/// Table：CT.WDT.CDSS.Term
/// Other: d ##class(web.CDSS.CMKB.Term).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
	
	s eobj.MKBTRowId = id
	s eobj.MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),2)
	s eobj.MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),3)
	s eobj.MKBTBaseDR=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),4)
	s eobj.MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),5)
	s eobj.MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),6)
	s eobj.MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),7)
	s eobj.MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),8)
	s eobj.MKBTActiveFlag=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),9)
	s eobj.MKBTDetailCount=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),10)
	
	
	s str = eobj.JsonS()
	d eobj.%Close()
	
	q str
}

/// Description:用于术语添加时：代码自动生成 根据注册时的编码规则生成
/// Table：CT.WDT.CDSS.Term
/// Date:2021-09-02
/// creator:丁亚男
/// Input：base：术语库注册表ID
/// Return：按照代码生成规则生成的代码-mycode
/// w ##class(web.CDSS.CMKB.Term).GetMultiTermCode(5)
ClassMethod GetMultiTermCode(base) As %String
{
	s mycode=""
  	//如果没有配置代码生成规则，则默认代码自动生成
	s StartCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(base)),12)	 	
	s StartCodeLen=$Length(StartCode)
	s Code="", preCode=""    //寻找符合规则的最大的代码
	if ($d(^CT.WDT.CDSS.TermI("CodeIndex",base)))
	{
		for {
			s Code=$o(^CT.WDT.CDSS.TermI("CodeIndex",base,Code),-1)
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

	s zeroLen=6-CodeNumLen  //中间0串的长度
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-09-02    
/// w ##class(web.CDSS.CMKB.Term).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String, code As %String, base As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TermI("CodeIndex",base,code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.TermI("DescIndex",base,desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TermI("CodeIndex",base,code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.TermI("DescIndex",base,desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-09-02    
/// w ##class(web.CDSS.CMKB.Term).FormValidateTree("","42","测试中心词","41102")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidateTree(id As %String, base As %String, desc As %String, MKBTLastLevel As %String) As %String
{
	
	s:MKBTLastLevel="" MKBTLastLevel=-100000000000000
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s MKBTRowId=0
	s flag=0
	for
	{
		s MKBTRowId=$o(^CT.WDT.CDSS.TermI("ParentIndex",base,MKBTLastLevel,MKBTRowId)) q:(MKBTRowId="")||(flag=1)
		s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)
		s MKBTDesc=$ZCONVERT(MKBTDesc,"U") //转换成大写
		if (MKBTDesc=desc)&&(MKBTRowId'=id)
		{
			s flag=1
		}
	}
	
	q flag
}

/// Creator:丁亚男
/// CreatDate:2018-3-30
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.CDSS.CMKB.Term).GetLastSequence(5)
ClassMethod GetLastSequence(base) As %String
{
  	s LastSequence=0
  	s Sequence=$o(^CT.WDT.CDSS.TermI("SeqIndex",base,""),-1)
  	s LastSequence=$g(Sequence)+1
  	
	q LastSequence
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：保存修改内容
/// Table：CT.WDT.CDSS.Term
/// Input：web.CDSSEntity.CMKB.Term 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.Term) As %String
{

	s result = ""
	if $IsObject(eobj)
	{
		
		if (eobj.MKBTCode="")
		{
			//如果代码为空，按照编码规则生成代码
			s eobj.MKBTCode=..GetMultiTermCode(eobj.MKBTBaseDR)
			q:eobj.MKBTCode="" "{success:'false',errorinfo:'代码不能为空！'}"
			
		}
		if (eobj.MKBTDesc="")
		{
			q "{success:'false',errorinfo:'中心词不能为空！'}"
		}
		s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTBaseDR)),4)  //术语库注册-类型（树形、或者列表型）
		if (MKBTBType="L")
		{
			s flag=..FormValidate(eobj.MKBTRowId,eobj.MKBTDesc,eobj.MKBTCode,eobj.MKBTBaseDR)  //调用重复验证
		}
		else
		{
			s flag=..FormValidateTree(eobj.MKBTRowId,eobj.MKBTBaseDR,eobj.MKBTDesc,eobj.MKBTLastLevel)  //调用重复验证	
		}
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.MKBTRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(CT.WDT.CDSS.Term).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(CT.WDT.CDSS.Term).%OpenId(eobj.MKBTRowId)
				s bobj = ##class(web.CDSSEntity.CMKB.Term).%New()
				s bobj.MKBTRowId = eobj.MKBTRowId
				s bobj.MKBTCode = obj.MKBTCode
				s bobj.MKBTDesc = obj.MKBTDesc
				s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
				s bobj.MKBTPYCode=  obj.MKBTPYCode
				s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
				s bobj.MKBTSequence=  obj.MKBTSequence
				s:obj.MKBTLastLevel'="" bobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
				//如果是修改数据,则先删除索引表的数据
				//d ##class(web.CDSS.CMKB.TermProDetail).DeleteTermIndex(eobj.MKBTRowId,"T")
				s bobj.UpdateDate = obj.UpdateDate
				s bobj.ResponUser = obj.ResponUser
				s bobj.Status = obj.Status
				
			}
	
			s obj.MKBTCode = eobj.MKBTCode
			s obj.MKBTDesc = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBTDesc)
			d:eobj.MKBTBaseDR'="" obj.MKBTBaseDRSetObjectId(eobj.MKBTBaseDR)
			d:eobj.MKBTBaseDR="" obj.MKBTBaseDRSetObjectId("")
			s MKBTBDesc=""
			s:eobj.MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTBaseDR)),3)
			
			if (eobj.MKBTPYCode="")&(eobj.MKBTDesc'="")
			{
				s eobj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.MKBTDesc,"U"))
				
			}
			//s eobj.MKBTPYCode=##class(web.CDSS.CMKB.TermProDetail).Filter(eobj.MKBTPYCode) //去掉特殊字符-等
			s obj.MKBTPYCode = eobj.MKBTPYCode
			s obj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBTNote)
			s:eobj.MKBTSequence'="" obj.MKBTSequence=  eobj.MKBTSequence
			if (obj.MKBTSequence="")&(eobj.MKBTBaseDR'="")
			{
				s obj.MKBTSequence=..GetLastSequence(eobj.MKBTBaseDR)
			}
			d:eobj.MKBTLastLevel'="" obj.MKBTLastLevelSetObjectId(eobj.MKBTLastLevel)
			d:eobj.MKBTLastLevel="" obj.MKBTLastLevelSetObjectId("")
			
			s obj.UpdateDate = $zdt($h,3)
			s obj.ResponUser = %session.Data("LOGON.USERNAME")
			s obj.Status = "0"
				
			Ts
			s sc=obj.%Save()
			
			d obj.%Close()
			s id =""
			If $$$ISOK(sc){
				s id = obj.%Id()
				if (eobj.MKBTRowId="")  //如果是新增则保存公有属性
				{
					//取注册术语扩展(公有)属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
					s sce=..SaveBaseExtToTerm(eobj.MKBTBaseDR,id)
					if (sce["false"){
						s result=sce	
					}

				}
			}else{
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
				
				//保存日志
		 		d:eobj.MKBTRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Term","CT.WDT.CDSS.Term"_eobj.MKBTBaseDR,MKBTBDesc,id,eobj.MKBTDesc,"A",eobj)
				d:eobj.MKBTRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Term","CT.WDT.CDSS.Term"_eobj.MKBTBaseDR,MKBTBDesc,eobj.MKBTRowId,eobj.MKBTDesc,"U",eobj,bobj)
		 		
		 		//d ##class(web.CDSS.CMKB.TermProDetail).AddTermIndex(id,"T")
		 		d eobj.%Close()
			}
		}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-08-12
/// Description：提供保存疾病、手术、检查、检验等术语的接口
/// Table：CT.WDT.CDSS.Term
/// Input：
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveTerm(basedesc, NewDisease, OldDisease) As %String
{
	q:((basedesc="")||(NewDisease="")) ""
	s result=""
	s basedr=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_$ZCONVERT(basedesc,"U"),0))
	if (basedr'="")
	{
		
		if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(NewDisease,"U")))))
		{}
		else
		{
			s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
			s eobj.MKBTBaseDR=basedr
			if (OldDisease'="")
			{
				s termdr=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(OldDisease,"U")),""))
				s eobj.MKBTRowId=termdr
			}
			s eobj.MKBTDesc=NewDisease
			s result=..SaveData(eobj)
			k eobj
		}
			
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-04-09
/// Description：提供删除疾病、手术、检查、检验等术语的接口
/// Table：CT.WDT.CDSS.Term
/// Input：
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.CDSS.CMKB.Term).DeleteTerm("疾病","测试数据dingyanan")
ClassMethod DeleteTerm(basedesc, Name) As %String
{
	q:((basedesc="")||(Name="")) ""
	s result=""
	s basedr=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_$ZCONVERT(basedesc,"U"),0))
	if (basedr'="")
	{
		
		if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(Name,"U")))))
		{
			s MKBTRowId=0
			for  
			{	
				s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(Name,"U")),MKBTRowId)) q:MKBTRowId=""
				s result=..DeleteData(MKBTRowId)
			}
		}	
			
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：保存术语库注册的扩展(公有)属性到术语库界面
/// Table：CT.WDT.CDSS.Term
/// Input：baseDr 术语库注册ID,termID 术语ID
/// Return成功返回success:'true' 失败返回success:'false'
/// Other: d ##class(web.CDSS.CMKB.Term).SaveBaseExtToTerm(baseDr,termID)
ClassMethod SaveBaseExtToTerm(baseDr As %String, termID As %String) As %String
{
	
	s result=""
	q:(baseDr="")||(termID="") ""

    TS
	s MKBTBPRowId=0  //取注册术语扩展(公有)属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
	for  
	{	
		s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("TermBaseIdx",baseDr,MKBTBPRowId)) q:MKBTBPRowId="" 
		s MKBTBPCode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),2)
		
		s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),3)
		s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),4)
		s MKBTBPBaseDr=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),5)
		s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),6)
		s MKBTBPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),7)
		s MKBTBPFlag=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),8)
		s MKBTBPSequence=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),9)
		s MKBTBPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),12)
		s StartCode=$listGet($g(^CT.WDT.CDSS.TermD(termID)),2)  //代码
		s MKBTPCode=StartCode_"-"_MKBTBPCodeRules	
		if '($d(^CT.WDT.CDSS.TermPropertyI("CodeIndex",termID," "_MKBTPCode)))  //若没有该属性则添加
		{
			s objPro=##class(CT.WDT.CDSS.TermProperty).%New()
			s objPro.MKBTPCode = MKBTPCode
			s objPro.MKBTPDesc = MKBTBPDesc
			s objPro.MKBTPType = MKBTBPType
			d objPro.MKBTPTermDrSetObjectId(termID)
			s objPro.MKBTPConfig=MKBTBPConfig
			s objPro.MKBTPName=MKBTBPName
			s objPro.MKBTPFlag=MKBTBPFlag
			s objPro.MKBTPSequence=MKBTBPSequence
			s objPro.MKBTPPublic="Y"  //公有属性标识
			s objPro.MKBTPCodeRules=MKBTBPCodeRules
			s scPro=objPro.%Save()
			
			d objPro.%Close()
			If $$$ISOK(scPro){  //如果保存成功则保存CT.WDT.CDSS.TermBaseExtendPro表的数据到CT.WDT.CDSS.TermExtendPro
				
				s idExt = objPro.%Id()
				if (idExt'="")
				{
					s MKBTBPChildsub=0
					for 
					{  
						S MKBTBPChildsub=$o(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBPChildsub)) q:MKBTBPChildsub=""
						s MKBTBEPRowId=MKBTBPRowId_"||"_MKBTBPChildsub
						s MKBTBEPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBPChildsub)),2)
						s MKBTBEPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBPChildsub)),3)
						s MKBTBEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBPChildsub)),4)
						s uMKBTBEPName=$ZCONVERT(MKBTBEPName,"U")
						s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",idExt," "_uMKBTBEPName))
						if (genLength=0) //若没有扩展属性则添加
						{
							s objCat=##class(CT.WDT.CDSS.TermExtendPro).%New(idExt)  
							d objCat.ParRefSetObjectId(idExt)
							s objCat.MKBTEPConfig=MKBTBEPConfig  
							s objCat.MKBTEPName=MKBTBEPName
							s objCat.MKBTEPType=MKBTBEPType
							
							s scCat=objCat.%Save()
							do objCat.%Close()
							if '$$$ISOK(scCat)
							{
								s result = "{success:'false',errorinfo:'"_$zconvert(scCat,"O","JS")_"'}"    //返回错误信息

							}
							else
							{
								if (MKBTBEPName="展示名")
								{
									s ExtendProDR=objCat.%Id()
									s shownameid=$p(ExtendProDR,"||",2)	
								}	
							}
						}

					}
					if (result'["false")
					{
						if (MKBTBPFlag="OD")  //(MKBTBPDesc="其他描述")&(MKBTBPType="T")&($d(shownameid))
						{
							s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
							s eobj.MKBTPDProDR=idExt
							s eobj.MKBTPDDesc="其他结构化描述"	
							s eobj.MKBTPDExtend=shownameid_"[A]结构化"

							s ProDetail1=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
							do eobj.%Close()
							
							s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
							s eobj.MKBTPDProDR=idExt
							s eobj.MKBTPDDesc="其他文本描述"
							s eobj.MKBTPDExtend=shownameid_"[A]文本"	
							s ProDetail2=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
							do eobj.%Close()
							
							if (ProDetail1["false")||(ProDetail2["false")
							{
								s result = "{success:'false',errorinfo:'其他描述内容保存失败'}"    //返回错误信息
							}

						}
						elseif((MKBTBPDesc="病情描述")&(MKBTBPType="T")){
							s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
							s eobj.MKBTPDProDR=idExt
							s eobj.MKBTPDDesc="病情"	
							s eobj.MKBTPDExtend=shownameid_"[A]病情"
							s ProDetail1=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
							do eobj.%Close()
							if (ProDetail1["false")
							{
								s result = "{success:'false',errorinfo:'病情描述内容保存失败'}"    //返回错误信息
							}
						}
						elseif((MKBTBPDesc="手术描述")&(MKBTBPType="T")){
							s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
							s eobj.MKBTPDProDR=idExt
							s eobj.MKBTPDDesc="整理"	
							s eobj.MKBTPDExtend=shownameid_"[A]整理"
							s ProDetail1=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
							do eobj.%Close()
							if (ProDetail1["false")
							{
								s result = "{success:'false',errorinfo:'病情描述内容保存失败'}"    //返回错误信息
							}
						}
						
					}		
				}
			}
			else{  //如果报错则退出循环
				s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

			}
		}
		
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'扩展属性保存失败！'}"   //返回错误信息
	}
	else
	{
		TC
		s result = "{success:'true',info:'扩展属性保存成功！'}" //成功
		//d ##class(web.CDSS.CMKB.TermProDetail).AddTextToThisDiaTemplate(termID)
	}
	
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description:删除限制
/// Input：id-诊断rowid
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.Term).GetRefFlag("2")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""
	s baseid=$listGet($g(^CT.WDT.CDSS.TermD(id)),4)  //术语  
	
	//树形术语判断是否有子菜单 
    s myChildFlag=$d(^CT.WDT.CDSS.TermI("ParentIndex",baseid,id))
    if (myChildFlag){
	    s myInfo=myInfo_"有子节点"   
    }
    
    //引用判断
    s referInfo=##class(web.CDSS.CMKB.MKBReference).DeleteData("T", id)
	if (referInfo'="")
	{ 
		s:myInfo'="" myInfo=myInfo_","_referInfo
		s:myInfo="" myInfo=referInfo
	}
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^"_myInfo_",不能删除!"
 	q return
}

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description:根据id删除
/// Table:CT.WDT.CDSS.Term
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.Term).DeleteData("41054")
ClassMethod DeleteData(id As %String) As %String
{
	
	s result=""
	/*s re=##class(web.CDSS.CMKB.Term).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0)  //未被引用
	{
		s rescontrast=##class(web.CDSS.CMKB.MKBLocContrast).DeleteJust(id)
		if (rescontrast=""){*/
			s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
	        s pobj = ##class(CT.WDT.CDSS.Term).%OpenId(id)
	        s eobj.MKBTRowId = id
	        s eobj.MKBTCode = pobj.MKBTCode
	        s eobj.MKBTDesc = pobj.MKBTDesc
	        s:pobj.MKBTBaseDR'="" eobj.MKBTBaseDR = pobj.MKBTBaseDR.%Id()
	        s MKBTBDesc=""
	        s:pobj.MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTBaseDR)),3)
	        s:pobj.MKBTLastLevel'="" eobj.MKBTLastLevel = pobj.MKBTLastLevel.%Id()
	        s eobj.MKBTPYCode=pobj.MKBTPYCode
	        s eobj.MKBTNote=pobj.MKBTNote
	        s eobj.MKBTSequence=pobj.MKBTSequence
		        
			Tstart
			//删除术语属性
			s resultallpro=""
			s proId=0
			for
			{
				s proId=$o(^CT.WDT.CDSS.TermPropertyI("TermIndex",id,proId))  //术语明细表id
				q:proId=""
				s resultPro=##class(web.CDSS.CMKB.TermProperty).DeleteData(proId)
				if (resultPro["false")&(resultPro["属性内容")
				{
					s resultallpro=resultPro_"0"
				}
				elseif(resultPro["false")&(resultPro'["属性内容")
				{
					s resultallpro=resultPro_"1"
				}			
			}
			if (resultallpro["0"){
				s result = "{success:'false',info:'术语属性内容删除失败！'}"
			}
			if (resultallpro["1"){
				s result = "{success:'false',info:'术语属性删除失败！'}"
			}
			
			//d ##class(web.CDSS.CMKB.TermProDetail).DeleteTermIndex(id,"T")
			s sc=##class(CT.WDT.CDSS.Term).%DeleteId(id)
			if $$$ISOK(sc)&'(result["false") 
			{
				Tc
				s result="{success:'true',info:'删除成功！'}"
				//删除引用--2018-12-17
	            //d ##class(web.CDSS.CMKB.MKBReference).DeleteViaOriginal("T",id)
				d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Term","CT.WDT.CDSS.Term"_eobj.MKBTBaseDR,MKBTBDesc,id,eobj.MKBTDesc,"D",eobj)
		   		d eobj.%Close()
					
			}
			else
			{
				Trollback
				if '$$$ISOK(sc){
					s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
					s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("医用知识库知识维护表","web.CDSS.CMKB.Term","DeleteData",eobj)
		     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 	
				}
				else{
					s result= result   
				}
		     	
			}
		/*}
		else  //被引用
		{
			s result= "{success:'false',info:'"_rescontrast_"'}"
		}
		
	}
	else  //被引用
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}*/
    q result
}

/// Creator:丁亚男
/// CreatDate:2019-07-23
/// Description:根据id删除数据及被引用数据
/// Table:CT.WDT.CDSS.Term
/// Input：id-术语表CT.WDT.CDSS.Term的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.Term).DeleteDataAndRefer("2")
ClassMethod DeleteDataAndRefer(id As %String) As %String
{
	q:id="" "{success:'false',info:'没有获取到ID，删除失败'}"  //返回错误信息
	 //删除引用
	s result=""
    s result=##class(web.CDSS.CMKB.MKBReference).DeleteAll("T", id)
    if (result="")  //删除成功
    {
	    s result=..DeleteData(id)
    }
   	q result
}

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：保存中心词拖拽的顺序
/// Other: w ##class(web.CDSS.CMKB.Term).SaveDragOrder("9^12^11")
ClassMethod SaveDragOrder(order, seq) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(CT.WDT.CDSS.Term).%OpenId(rowid)
		s obj.MKBTSequence=i+seq-1
		s sc=obj.%Save()
		d obj.%Close()
		
		If $$$ISOK(sc)
		{
			
		}
		else
		{
			s result = "{success:'false'}"  //返回错误信息
		}
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"
	
	}
	else
	{
		Tc
		s result = "{success:'true',errorinfo:'保存成功'}"

	}
	q result
	
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：谷雪萍
/// CreatDate: 2018-03-29
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.BDPItemCategory
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.CMKB.Term).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(base As %String, LastLevel As %String) As %String
{
	
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	/*s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}*/
	//输出菜单JSON串
	
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			
			s childStr=..GetChildOrderedIDStr(base,myRowID)
			if childStr'="" s childStr=myRowID_"^"_childStr
			if childStr="" s childStr=myRowID
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// Creator：丁亚男
/// CreatDate: 2018-12-17
/// Description：下拉框单个描述
/// Table：
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.Term).GetJsonDataForCmbDesc("57","")
ClassMethod GetJsonDataForCmbDesc(base As %String, id As %String) As %String
{
	//如果id不为空则只输出一条
	if (id'=""){
		s Caption=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),3)
		s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSONB(Caption)
		q "[{""id"":"""_id_""",""text"":"""_Caption_""",""state"":""open""}]"
	}
}

/// Creator：谷雪萍
/// CreatDate: 2018-03-29
/// Description：查询页面数据
/// Table：User.BDPItemCategory
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.Term).GetJsonDataForCmb("57","")
ClassMethod GetJsonDataForCmb(base As %String, id As %String) As %String
{
	/*//如果id不为空则只输出一条
	if (id'=""){
		s Caption=$LISTGET($G(^CT.WDT.CDSS.TermD(id)),3)
		s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSONB(Caption)
		q "[{""id"":"""_id_""",""text"":"""_Caption_""",""state"":""open""}]"
	}
	*/
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	/*s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	;d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}*/
	//输出菜单JSON串
	
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			
			s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),3)
			s MKBTActiveFlag=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),9)
			continue:(MKBTActiveFlag="N")
			s MKBTDesc=$tr(MKBTDesc,"""","")
			s count=count+1
			if count>1 w ","
			w "{""id"":"""_myRowID_""",""text"":"""_MKBTDesc_""""
			w ",""state"":""open"""
			s childStr=..GetChildOrderedIDStr(base,myRowID)
			if childStr'=""
			{
				w ",""state"":""open"""
				w ",""children"":"
				w ..GetJsonDataForCmb(base,myRowID)	
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

/// Creator:丁亚男
/// CreatDate:2018-3-30
/// Input：ParentID 父节点Id，nodeid 展开节点 ，base术语库注册ID 
/// Return：Json格式
/// Description:获取树形下拉框的数据
/// w ##class(web.CDSS.CMKB.Term).GetTreeComboJson11("CatTreeRoot","","1")
ClassMethod GetTreeComboJson(ParentID As %String, nodeid As %String, base As %String) As %String
{
	
	if (ParentID="CatTreeRoot") s ParentID=-100000000000000
	
	s myRowID=0
	s myJsonStr=""	
	for {
		s myRowID=$o(^CT.WDT.CDSS.TermI("ParentIndex",base,ParentID,myRowID))
		q:(myRowID="")
		
		s myObj=##Class(CT.WDT.CDSS.Term).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myDesc = myObj.MKBTDesc
			s myLastLevel=myObj.MKBTLastLevel
			
			//判断是否有子菜单 
		    s myChildFlag=$d(^CT.WDT.CDSS.TermI("ParentIndex",base,myRowID))
		    if (myChildFlag) s myChildFlag=1 //有子节点    
		    else  s myChildFlag=0
		    
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
			
			if (+myChildFlag'=0) {
		     	s myJsonStr=myJsonStr_"""leaf"":false"
		    }else {
			     s myJsonStr=myJsonStr_"""parentNode"":"""_""_myLastLevel_""","
			     s myJsonStr=myJsonStr_"""leaf"":true"
		    }
		    
			if (nodeid'=""){
				if (+myChildFlag'=0){ 
					s myJsonStr=myJsonStr_",""expanded"":true"
				}
				else{
					s myJsonStr=myJsonStr_",""expanded"":false"
				}
			}
			else{
				s myJsonStr=myJsonStr_",""expanded"":false"	
			}
			s myJsonStr=myJsonStr_"}"
			
			d myObj.%Close()
		}
	}

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Function:根据id获取值表达式  菜单表CT.WDT.MKB.Menu
/// Creator: 丁亚男
/// CreateDate:2018-3-31
/// Debug: w ##class(web.CDSS.CMKB.Term).GetValueExp("3")
ClassMethod GetValueExp(id As %String) As %String
{
	
    s ValueExpression=""
    s ValueExpression=$LISTGET($G(^CT.WDT.MKB.MenuD(id)),15)
    q ValueExpression
}

/// Function:根据id获取值表达式  菜单表CT.WDT.MKB.Menu
/// Creator: 丁亚男
/// CreateDate:2018-3-31
/// Debug: w ##class(web.CDSS.CMKB.Term).GetValueExp("3")
ClassMethod GetValueExpV1(id As %String) As %String
{
	q:id="" ""
    s ValueExpression=""
    s ValueExpression=$LISTGET($G(^User.BDPMenuD(id)),15)
    q ValueExpression
}

/// Creator:丁亚男
/// CreatDate:2018-4-03
/// Description：复制属性到其他术语 获取术语树
/// Input:diaId-当前选中术语，baseID-诊断术语库注册表ID，AUTCode-已选的术语，start-开始行，limit-显示条数，query-查询条件，FilterCK-选中标识
/// Return: Json格式 w ##class(web.CDSS.CMKB.Term).GetCopyTreeJson("","1", "","","")
/// w ##class(web.CDSS.CMKB.Term).GetCopyTreeJson(baseID,AutCode, start, limit, query, FilterCK)
ClassMethod GetCopyTreeJson(diaId As %String, baseID As %String, AutCode As %String, query, FilterCK) As %String
{
	
	s myJsonStr=""				
	s count=0
	
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",baseID)))  //该术语库下有数据
	{
		s RowId=""
		for  
		{	
			s RowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",baseID,RowId),-1) q:RowId="" 
			continue:RowId=diaId  //当前选中术语不显示在多选树中
			
				//过滤已选、未选
			s AuStr2="{ID:"_RowId_"}"
			if (FilterCK="checked") {
				if (AutCode[AuStr2) 
				else  continue
			}
			elseif (FilterCK="unchecked") {
				if (AutCode[AuStr2) continue
				else  
			}
			
			s Desc=$LISTGET($g(^CT.WDT.CDSS.TermD(RowId)),3)  //描述
			
			//s Desc=$tr(Desc,$c(13,10),"")
			s Desc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(Desc)
			s MKBTPYCode=$LISTGET($g(^CT.WDT.CDSS.TermD(RowId)),6) //拼音码
			
			s outDiaFlag=""  //输出标识
			if (query'="")  //如果诊断不为空
			{
				s:query'="" query=$ZCONVERT(query,"U")
				
				s isDesc=($ZCONVERT(Desc,"U")[query)       //描述
				s isPYcode=($ZCONVERT(MKBTPYCode,"U")[query)   //拼音码
				i (isPYcode)||(isDesc)
				{
					s outDiaFlag="Y"
				}
				
			}
			else
			{
				s outDiaFlag="Y"
			}
			if (outDiaFlag="Y"){
				s count=count+1
				if (AutCode[AuStr2) s myEnable=1
				else  s myEnable=0
			
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_RowId_""",""text"":"""_Desc_""","
			
				if (+myEnable){
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else{
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
			}
		}
	}
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：测试保存方法
/// w ##class(web.CDSS.CMKB.Term).testsavedata()
ClassMethod testsavedata() As %String
{
	
	s obj = ##class(web.CDSSEntity.CMKB.Term).%New()
	s obj.MKBTRowId=""
	s obj.MKBTDesc="测试编码规则"
	s obj.MKBTPYCode="CSBMGZ"
	s obj.MKBTLastLevel=""
	s obj.MKBTNote=""
	s obj.MKBTBaseDR=63
	s rtn=..SaveData(obj)
	q rtn
}

/// Creator：丁亚男
/// CreatDate: 2018-04-09
/// Description：术语库注册界面 添加私有属性时调用的接口
/// Table：CT.WDT.CDSS.Term CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
/// Input：baseDr 术语库注册ID，proId 术语库注册界面私有属性ＩＤ
/// Return：成功返回success:'true' 失败返回success:'false'
/// Other: w ##class(web.CDSS.CMKB.Term).AddBasePro(38,proId)
ClassMethod AddBasePro(baseDr As %String, proId As %String) As %String
{

	q:(baseDr="")||(proId="") ""
	s result="",info="",info1=""
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",baseDr)))  //该术语库下有数据
	{
		s MKBTBPCode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),2)
		s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),3)
		s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),4)
		s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),6)
		s MKBTBPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),7)
		s MKBTBPFlag=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),8)
		s MKBTBPDefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),10)
		
		s MKBTBPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),12)
		//s uMKBTBPCode=$ZCONVERT(MKBTBPCode,"U") //转换成大写
		s uMKBTBPDesc=$ZCONVERT(MKBTBPDesc,"U") //转换成大写
		
		TS
		s MKBTRowId=0
		for    //循环术语表CT.WDT.CDSS.Term
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,MKBTRowId)) q:MKBTRowId="" 
			s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //术语代码
			s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //术语描述
			s uMKBTDesc=$ZCONVERT(MKBTDesc,"U") //转换成大写
			s uMKBTBPCode=MKBTCode_"-"_$ZCONVERT(MKBTBPCodeRules,"U") //转换成大写						
			if '($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_uMKBTBPDesc)))& '($d(^CT.WDT.CDSS.TermPropertyI("CodeIndex",MKBTRowId," "_uMKBTBPCode))) //若没有该属性则添加
			{
				
				//取注册术语属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
				s objPro=##class(CT.WDT.CDSS.TermProperty).%New()
				s objPro.MKBTPCode = uMKBTBPCode
				s objPro.MKBTPDesc = MKBTBPDesc
				s objPro.MKBTPType = MKBTBPType
				s objPro.MKBTPConfig = MKBTBPConfig
				d objPro.MKBTPTermDrSetObjectId(MKBTRowId)
				s:MKBTBPName="" objPro.MKBTPName=MKBTBPDesc
				s:MKBTBPName'="" objPro.MKBTPName=MKBTBPName
				s objPro.MKBTPFlag=MKBTBPFlag
				s objPro.MKBTPPublic="Y"
				s objPro.MKBTPSequence=##class(web.CDSS.CMKB.TermProperty).GetLastSequence(MKBTRowId)
				s objPro.MKBTPDefinedNode=MKBTBPDefinedNode
				s objPro.MKBTPCodeRules=MKBTBPCodeRules
				s scPro=objPro.%Save()
				d objPro.%Close()
				If '$$$ISOK(scPro){ 
					s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

				}
			}
			else
			{
				//取注册术语扩展属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
				s idPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_uMKBTBPDesc,0))
				if (idPro'="")
				{
					s MKBTPCode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),2)  //代码
					s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),3)  //描述
					s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),4)
					s MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),5)
					s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),6)
					s MKBTPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),7)  //描述
					s MKBTPFlag=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),8)  //标识
					s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),9)  //是否是公有属性
					s DefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),10)  //定义初始节点
					s MKBTPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),12)  //编码规则
					
					s strExt=MKBTPCode_"^"_MKBTPDesc_"^"_MKBTPType_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag
					s strBaseExt=uMKBTBPCode_"^"_MKBTBPDesc_"^"_MKBTBPType_"^"_MKBTBPConfig_"^"_MKBTBPName_"^"_MKBTBPFlag
					if (strExt=strBaseExt)  //如果已有属性和术语库注册的相同，则直接修改该属性为公有属性
					{
						s objPro=##class(CT.WDT.CDSS.TermProperty).%OpenId(idPro)
						s objPro.MKBTPPublic="Y"
						s scPro=objPro.%Save()
						d objPro.%Close()
						If '$$$ISOK(scPro){  
							s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

						}
						/*
						else{
							s:info1'="" info1=info1_"、"_MKBTDesc
							s:info1="" info1=MKBTDesc
							}
							*/
					}
					else  //如果已有属性和术语库注册的不同，则记录下来
					{
						s:info'="" info=info_"、"_MKBTDesc
						s:info="" info=MKBTDesc
					}
				}
				else
				{
					s idProC=$o(^CT.WDT.CDSS.TermPropertyI("CodeIndex",MKBTRowId," "_uMKBTBPCode))
					if (idProC'=""){
							s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idProC)),3)  //描述
							s:info'="" info=info_"、"_MKBTDesc
							s:info="" info=MKBTDesc
						}
					
				}
				

			}

		}

		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'私有属性添加失败！'}"   //返回错误信息
		}
		else
		{
			TC
			s:info'="" info=info_"已经有该属性、编码(跳过)!"
			/*s:info1'="" info1=info1_"已经有该属性(同格式私有,已经升级为公有)!"
			s info2=""
			if (info'="")&&(info1'=""){
				s info2=info_"^"_info1
			}
			elseif(info'="")&&(info1=""){
				s info2=info		
			}elseif(info="")&&(info1'=""){
				s info2=info1		
			}*/
			s result = "{success:'true',info:'私有属性添加成功！"_info_"'}" //成功
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-04-08
/// Description：术语库注册界面 修改私有属性时调用的接口
/// Table：CT.WDT.CDSS.Term CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
/// Input：baseDr 术语库注册ID，proId 术语库注册界面私有属性ＩＤ，preProCode　修改的私有属性原来的代码
/// Return：成功返回success:'true' 失败返回success:'false'
/// Other: w ##class(web.CDSS.CMKB.Term).UpdateBasePro(20,375,"病情描述")
ClassMethod UpdateBasePro(baseDr As %String, proId As %String, preProDesc As %String) As %String
{
	
	q:(baseDr="")||(proId="")||(preProDesc="") ""
	
	s result="",info=""
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",baseDr)))  //该术语库下有数据
	{
		s MKBTBPCode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),2)
		s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),3)
		s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),4)
		s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),6)
		s MKBTBPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),7)
		s MKBTBPFlag=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),8)
		s preProDesc=$ZCONVERT(preProDesc,"U") //转换成大写
		s uMKBTBPDesc=$ZCONVERT(MKBTBPDesc,"U") //转换成大写
		s MKBTBPDefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),10)
		s MKBTBPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),12)
		
		TS
		s MKBTRowId=0
		for    //循环术语表CT.WDT.CDSS.Term
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,MKBTRowId)) q:MKBTRowId="" 
			s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //术语代码
			s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //术语描述						
			s uMKBTBPCode=MKBTCode_"-"_$ZCONVERT(MKBTBPCodeRules,"U") //转换成大写
			if (uMKBTBPDesc'=preProDesc)
			{
				if $d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_uMKBTBPDesc))   //术语属性已经存在要改的属性名称
				{
					
					s:info'="" info=info_"、"_MKBTDesc
					s:info="" info=MKBTDesc
				}
				elseif $d(^CT.WDT.CDSS.TermPropertyI("CodeIndex",MKBTRowId," "_uMKBTBPCode))  //术语属性已经存在要改的属性代码，修改属性名称
				{
					s idPro=$o(^CT.WDT.CDSS.TermPropertyI("CodeIndex",MKBTRowId," "_uMKBTBPCode,0))
					if (idPro'="")
					{
						
						s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),9)  //是否是公有属性
						s MKBTPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),11)  //顺序
						if (MKBTPPublic="Y")  //如果是公有属性
						{
							s objPro=##class(CT.WDT.CDSS.TermProperty).%OpenId(idPro)
							s objPro.MKBTPCode = uMKBTBPCode
							s objPro.MKBTPDesc = MKBTBPDesc
							s objPro.MKBTPType = MKBTBPType
							s objPro.MKBTPConfig = MKBTBPConfig
							d objPro.MKBTPTermDrSetObjectId(MKBTRowId)
							s objPro.MKBTPName=MKBTBPName
							s objPro.MKBTPFlag=MKBTBPFlag
							s objPro.MKBTPPublic="Y"
							s objPro.MKBTPSequence=MKBTPSequence
							s objPro.MKBTPDefinedNode=MKBTBPDefinedNode
							s objPro.MKBTPCodeRules=MKBTBPCodeRules
							s scPro=objPro.%Save()
							d objPro.%Close()
							If '$$$ISOK(scPro){  
								s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

							}
						}
					}	
				}
				else
				{
					if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_preProDesc)))  //修改私有属性表CT.WDT.CDSS.TermProperty
					{
						//取注册术语扩展属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
						s idPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_preProDesc,0))
						if (idPro'="")
						{
							
							s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),9)  //是否是公有属性
							s MKBTPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),11)  //顺序
							if (MKBTPPublic="Y")  //如果是公有属性
							{
								s objPro=##class(CT.WDT.CDSS.TermProperty).%OpenId(idPro)
								s objPro.MKBTPCode = uMKBTBPCode
								s objPro.MKBTPDesc = MKBTBPDesc
								s objPro.MKBTPType = MKBTBPType
								s objPro.MKBTPConfig = MKBTBPConfig
								d objPro.MKBTPTermDrSetObjectId(MKBTRowId)
								s objPro.MKBTPName=MKBTBPName
								s objPro.MKBTPFlag=MKBTBPFlag
								s objPro.MKBTPPublic="Y"
								s objPro.MKBTPSequence=MKBTPSequence
								s objPro.MKBTPDefinedNode=MKBTBPDefinedNode
								s objPro.MKBTPCodeRules=MKBTBPCodeRules
								s scPro=objPro.%Save()
								d objPro.%Close()
								If '$$$ISOK(scPro){  
									s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

								}
							}
						}
					}
					else //若没有该属性则添加
					{
						
						//取注册术语扩展属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
						s objPro=##class(CT.WDT.CDSS.TermProperty).%New()
						s objPro.MKBTPCode = uMKBTBPCode
						s objPro.MKBTPDesc = MKBTBPDesc
						s objPro.MKBTPType = MKBTBPType
						s objPro.MKBTPConfig = MKBTBPConfig
						d objPro.MKBTPTermDrSetObjectId(MKBTRowId)
						s objPro.MKBTPName=MKBTBPName
						s objPro.MKBTPFlag=MKBTBPFlag
						s objPro.MKBTPPublic="Y"
						s objPro.MKBTPSequence=##class(web.CDSS.CMKB.TermProperty).GetLastSequence(MKBTRowId)
						s objPro.MKBTPDefinedNode=MKBTBPDefinedNode
						s objPro.MKBTPCodeRules=MKBTBPCodeRules
						s scPro=objPro.%Save()
						d objPro.%Close()
						If '$$$ISOK(scPro)
						{ 
							s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

						}		
					}
				}
			}
			else  //修改属性名称之外的内容
			{
				if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_preProDesc)))  //修改私有属性表CT.WDT.CDSS.TermProperty
				{
					
					
					//取注册术语扩展属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
					s idPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_preProDesc,0))
					if (idPro'="")
					{
						s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),9)  //是否是公有属性
						s MKBTPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),11)  //顺序
						if (MKBTPPublic="Y")  //如果是公有属性
						{
							s objPro=##class(CT.WDT.CDSS.TermProperty).%OpenId(idPro)
							s objPro.MKBTPCode = uMKBTBPCode
							s objPro.MKBTPDesc = MKBTBPDesc
							s objPro.MKBTPType = MKBTBPType
							s objPro.MKBTPConfig = MKBTBPConfig
							d objPro.MKBTPTermDrSetObjectId(MKBTRowId)
							s objPro.MKBTPName=MKBTBPName
							s objPro.MKBTPFlag=MKBTBPFlag
							s objPro.MKBTPPublic="Y"
							s objPro.MKBTPSequence=MKBTPSequence
							s objPro.MKBTPDefinedNode=MKBTBPDefinedNode
							s objPro.MKBTPCodeRules=MKBTBPCodeRules
							s scPro=objPro.%Save()
							d objPro.%Close()
							If '$$$ISOK(scPro){  
								s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

							}
						}
					}
				}
				else
				{					
					if '($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_preProDesc)))  //若没有该属性则添加
					{
						
						//取注册术语扩展属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
						s objPro=##class(CT.WDT.CDSS.TermProperty).%New()
						s objPro.MKBTPCode = uMKBTBPCode
						s objPro.MKBTPDesc = MKBTBPDesc
						s objPro.MKBTPType = MKBTBPType
						s objPro.MKBTPConfig = MKBTBPConfig
						d objPro.MKBTPTermDrSetObjectId(MKBTRowId)
						s objPro.MKBTPName=MKBTBPName
						s objPro.MKBTPFlag=MKBTBPFlag
						s objPro.MKBTPPublic="Y"
						s objPro.MKBTPSequence=##class(web.CDSS.CMKB.TermProperty).GetLastSequence(MKBTRowId)
						s objPro.MKBTPDefinedNode=MKBTBPDefinedNode
						s objPro.MKBTPCodeRules=MKBTBPCodeRules
						s scPro=objPro.%Save()
						d objPro.%Close()
						If '$$$ISOK(scPro)
						{ 
							s result = "{success:'false',errorinfo:'"_$zconvert(scPro,"O","JS")_"'}"   //返回错误信息

						}
					}		
				}
			}
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'私有属性修改失败！'}"   //返回错误信息
		}
		else
		{
			TC
			s:info'="" info=info_"已经有该属性、编码(跳过)!"
			s result = "{success:'true',info:'私有属性修改成功！"_info_"'}" //成功
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-04-09
/// Description：术语库注册界面 删除私有属性时调用的接口
/// Table：CT.WDT.CDSS.Term 删除CT.WDT.CDSS.TermProperty表
/// Input：baseDr 术语库注册ID，proId 术语库注册界面私有属性ＩＤ
/// Return：成功返回success:'true' 失败返回success:'false'
/// Other: w ##class(web.CDSS.CMKB.Term).DeleteBasePro(5,198)
ClassMethod DeleteBasePro(baseDr As %String, proId As %String) As %String
{
	
	q:(baseDr="")||(proId="") ""
	s result = "{success:'true',info:'私有属性删除成功！'}"
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",baseDr)))  //该术语库下有数据
	{
		TS
		s MKBTRowId=0
		for  //循环术语表CT.WDT.CDSS.Term
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,MKBTRowId)) q:MKBTRowId="" 
			s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //术语代码
			s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //术语描述
			s MKBTBPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),12)						
			s uMKBTBPCode=$ZCONVERT(MKBTCode,"U")_"-"_$ZCONVERT(MKBTBPCodeRules,"U") //转换成大写
			
			s MKBTBPCode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),2)
			s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),3)
			s MKBTBPCode=$ZCONVERT(MKBTBPCode,"U") //转换成大写	
			s MKBTBPDesc=$ZCONVERT(MKBTBPDesc,"U") //转换成大写	
			if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc)))  //修改私有属性表CT.WDT.CDSS.TermProperty
			{
				//取注册术语扩展属性表CT.WDT.CDSS.TermBaseProperty的数据保存到CT.WDT.CDSS.TermProperty表
				s idPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc,0))
				if (idPro'="")
				{
					s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(idPro)),9)  //是否是公有属性
					if (MKBTPPublic="Y")  //如果是公有属性
					{
						//删除子术语库大类表
						s LogFlag="N" //调用接口时不加日志
						s sce=##class(web.CDSS.CMKB.TermProperty).DeleteData(idPro,LogFlag)
						if (sce["false")
						{
							s result=sce  //返回错误信息
						}
					}	
				}		
			}
		}
		if (result["false")
		{
			Trollback
			s result = result   //返回错误信息
		}
		else
		{
			TC
			s result = result //成功
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-04-10
/// Description：术语库注册界面 新增扩展属性时调用的接口
/// Table：术语表CT.WDT.CDSS.Term，术语注册私有属性表CT.WDT.CDSS.TermBaseProperty，术语私有属性表CT.WDT.CDSS.TermProperty，术语注册扩展属性表CT.WDT.CDSS.TermBaseExtendPro，术语扩展属性表CT.WDT.CDSS.TermExtendPro
/// Input：baseDr 术语库注册ID，extProId术语库注册界面扩展属性ＩＤ
/// Return：成功返回success:'true' 失败返回success:'false'
/// Other: w ##class(web.CDSS.CMKB.Term).AddBaseExtPro(baseDr,extProId)
ClassMethod AddBaseExtPro(baseDr As %String, extProId As %String) As %String
{
	
	q:(baseDr="")||(extProId="") ""
	s result=""
	s proId=$p(extProId,"||",1)
	s child=$p(extProId,"||",2)
	
	s MKBTBPCode=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),2)
	s MKBTBPCode=$ZCONVERT(MKBTBPCode,"U") //转换成大写	
	s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),3)
	s MKBTBPDesc=$ZCONVERT(MKBTBPDesc,"U") //转换成大写	
	s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),4)
			
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",baseDr)))  //该术语库下有数据
	{
		TS
		s MKBTRowId=0
		for  //循环术语表CT.WDT.CDSS.Term
		{
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,MKBTRowId)) q:MKBTRowId="" 
			if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc)))  //修改私有属性表CT.WDT.CDSS.TermProperty
			{
				//根据扩展属性代码找到术语扩展属性CT.WDT.CDSS.TermBaseProperty表ID
				s idPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc,0))
				if (idPro'="")
				{
					//获取术语库注册扩展属性表CT.WDT.CDSS.TermBaseExtendPro的信息
					s MKBTBEPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),2)
					s MKBTBEPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),3)
					s MKBTBEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),4)
					s MKBTBEPSequence=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),5)
					
					s upMKBTBEPName=$ZCONVERT(MKBTBEPName,"U") //转换成大写	
					s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",idPro," "_upMKBTBEPName))
					if (genLength=0) //若没有该扩展属性则添加到术语扩展属性表CT.WDT.CDSS.TermExtendPro
					{
						//取术语注册扩展属性表CT.WDT.CDSS.TermBaseExtendPro的数据保存到CT.WDT.CDSS.TermExtendPro表
						s objCat=##class(CT.WDT.CDSS.TermExtendPro).%New(idPro)  
						d objCat.ParRefSetObjectId(idPro)
						s objCat.MKBTEPConfig=MKBTBEPConfig  
						s objCat.MKBTEPName=MKBTBEPName
						s objCat.MKBTEPType=MKBTBEPType
						s objCat.MKBTEPSequence=MKBTBEPSequence
	
						s scCat=objCat.%Save()
						do objCat.%Close()
						if '$$$ISOK(scCat)
						{
							s result = "{success:'false',errorinfo:'"_$zconvert(scCat,"O","JS")_"'}"    //返回错误信息

						}

					}
							
				}
			}
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'扩展属性添加失败！'}"   //返回错误信息
		}
		else
		{
			TC
			s result = "{success:'true',info:'扩展属性添加成功！'}" //成功
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-04-10
/// Description：术语库注册界面 修改扩展属性时调用的接口
/// Table：术语表CT.WDT.CDSS.Term，术语注册私有属性表CT.WDT.CDSS.TermBaseProperty，术语私有属性表CT.WDT.CDSS.TermProperty，术语注册扩展属性表CT.WDT.CDSS.TermBaseExtendPro，术语扩展属性表CT.WDT.CDSS.TermExtendPro
/// Input：baseDr 术语库注册ID，extProId术语库注册界面扩展属性ＩＤ,preExtProName 修改前的扩展属性名称
/// Return：成功返回success:'true' 失败返回success:'false'
/// Other: w ##class(web.CDSS.CMKB.Term).UpdateBaseExtPro("5","8||132","别名")
ClassMethod UpdateBaseExtPro(baseDr As %String, extProId As %String, preExtProName As %String) As %String
{
	
	q:(baseDr="")||(extProId="")||(preExtProName="") ""
	s result=""
	s proId=$p(extProId,"||",1)
	s child=$p(extProId,"||",2)
	
	s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),3)			//术语注册私有属性表CT.WDT.CDSS.TermBaseProperty
	s MKBTBPDesc=$ZCONVERT(MKBTBPDesc,"U") //转换成大写	
	
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",baseDr)))  //该术语库下有数据
	{
		TS
		s MKBTRowId=0
		for  //循环术语表CT.WDT.CDSS.Term
		{
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,MKBTRowId)) q:MKBTRowId="" 
			
			if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc)))  //修改私有属性表CT.WDT.CDSS.TermProperty
			{
				//根据扩展属性代码找到术语扩展属性CT.WDT.CDSS.TermBaseProperty表ID
				s idPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc,0))
				if (idPro'="")
				{
					//获取术语库注册扩展属性表CT.WDT.CDSS.TermExtendPro的信息
					s MKBTBEPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),2)
					s MKBTBEPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),3)
					s MKBTBEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),4)
					s MKBTBEPSequence=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),5)
					
					s preExtProName=$ZCONVERT(preExtProName,"U") //转换成大写	
					s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",idPro," "_preExtProName))
					if (genLength) //修改扩展属性表CT.WDT.CDSS.TermExtendPro
					{
						s Childsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",idPro," "_preExtProName,0))
						continue:Childsub=""
						s MKBTEPRowId=idPro_"||"_Childsub  //找到要修改的CT.WDT.CDSS.TermExtendProID
						//取术语注册扩展属性表CT.WDT.CDSS.TermBaseExtendPro的数据保存到CT.WDT.CDSS.TermExtendPro表
						s objCat=##class(CT.WDT.CDSS.TermExtendPro).%OpenId(MKBTEPRowId)
						d objCat.ParRefSetObjectId(idPro)
						s objCat.MKBTEPConfig=MKBTBEPConfig  
						s objCat.MKBTEPName=MKBTBEPName
						s objCat.MKBTEPType=MKBTBEPType
						s objCat.MKBTEPSequence=MKBTBEPSequence

						s scCat=objCat.%Save()
						do objCat.%Close()
						if '$$$ISOK(scCat)
						{
							s result = "{success:'false',errorinfo:'"_$zconvert(scCat,"O","JS")_"'}"    //返回错误信息

						}

					}
					else //若没有该扩展属性则添加到术语扩展属性表CT.WDT.CDSS.TermExtendPro
					{
						//取术语注册扩展属性表CT.WDT.CDSS.TermBaseExtendPro的数据保存到CT.WDT.CDSS.TermExtendPro表
						s objCat=##class(CT.WDT.CDSS.TermExtendPro).%New(idPro)  
						d objCat.ParRefSetObjectId(idPro)
						s objCat.MKBTEPConfig=MKBTBEPConfig  
						s objCat.MKBTEPName=MKBTBEPName
						s objCat.MKBTEPType=MKBTBEPType
						s objCat.MKBTEPSequence=MKBTBEPSequence
	
						s scCat=objCat.%Save()
						do objCat.%Close()
						if '$$$ISOK(scCat)
						{
							s result = "{success:'false',errorinfo:'"_$zconvert(scCat,"O","JS")_"'}"    //返回错误信息

						}

					}		
				}
			}
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'扩展属性修改失败！'}"   //返回错误信息
		}
		else
		{
			TC
			s result = "{success:'true',info:'扩展属性修改成功！'}" //成功
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-04-10
/// Description：术语库注册界面 修改扩展属性时调用的接口
/// Table：术语表CT.WDT.CDSS.Term，术语注册私有属性表CT.WDT.CDSS.TermBaseProperty，术语私有属性表CT.WDT.CDSS.TermProperty，术语注册扩展属性表CT.WDT.CDSS.TermBaseExtendPro，术语扩展属性表CT.WDT.CDSS.TermExtendPro
/// Input：baseDr 术语库注册ID，extProId术语库注册界面扩展属性ＩＤ
/// Return：成功返回success:'true' 失败返回success:'false'
/// Other: w ##class(web.CDSS.CMKB.Term).DeleteBaseExtPro(baseDr,extProId)
ClassMethod DeleteBaseExtPro(baseDr As %String, extProId As %String) As %String
{
	
	q:(baseDr="")||(extProId="") ""
	s result=""
	s proId=$p(extProId,"||",1)
	s child=$p(extProId,"||",2)
	
	s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId)),3)			//术语注册私有属性表CT.WDT.CDSS.TermBaseProperty
	s MKBTBPDesc=$ZCONVERT(MKBTBPDesc,"U") //转换成大写	

	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",baseDr)))  //该术语库下有数据
	{
		TS
		s MKBTRowId=0
		for  //循环术语表CT.WDT.CDSS.Term
		{
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,MKBTRowId)) q:MKBTRowId="" 
			
			if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc)))  //修改私有属性表CT.WDT.CDSS.TermProperty
			{
				//根据扩展属性代码找到术语扩展属性CT.WDT.CDSS.TermBaseProperty表ID
				s idPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDesc,0))
				if (idPro'="")
				{
					//获取术语库注册扩展属性表CT.WDT.CDSS.TermExtendPro的信息
					s MKBTBEPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(proId,"ChildExt",child)),2)				
					s MKBTBEPName=$ZCONVERT(MKBTBEPName,"U") //转换成大写	
					s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",idPro," "_MKBTBEPName))
					if (genLength) //修改扩展属性表CT.WDT.CDSS.TermExtendPro
					{
						s Childsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",idPro," "_MKBTBEPName,0))
						continue:Childsub=""
						s MKBTEPRowId=idPro_"||"_Childsub  //找到要修改的CT.WDT.CDSS.TermExtendProID
						//删除改扩展属性CT.WDT.CDSS.TermBaseExtendPro
						s scCat=##class(web.CDSS.CMKB.TermExtendPro).DeleteData(MKBTEPRowId)
						if (scCat["false")
						{
							s result=scCat  //返回错误信息
						}

					}
							
				}
			}
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'扩展属性删除失败！'}"   //返回错误信息
		}
		else
		{
			TC
			s result = "{success:'true',info:'扩展属性删除成功！'}" //成功
		}
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2018-04-10
/// Description:删除术语的所有数据 给数据导入提供的接口
/// Table:CT.WDT.CDSS.Term
/// Input：base 术语库注册ID
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.Term).DeleteAll("41054")
ClassMethod DeleteAll(base As %String) As %String
{
	
	s result=""

	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",base)))  //该术语库下有数据
	{
		s MKBTRowId=0
		for  
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId)) q:MKBTRowId=""
			s result=..DeleteData(MKBTRowId)
			if (result["false"){
				if (result["有子节点")  //树形 有子节点的术语 也要删除掉
				{
					s result=""  
					s sc=##class(CT.WDT.CDSS.Term).%DeleteId(MKBTRowId)
					if '$$$ISOK(sc)
					{
						s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
					}
				}
				else
				{
					q
				}
			}			
		}
	}
	if (result["false")
	{
		s result= "{success:'false',info:'删除失败'}"  //返回错误信息
	}
	else
	{
		s result="{success:'true',info:'删除成功！'}"
	}
    q result
}

/// Creator:程和贵
/// CreatDate:2018-04-25
/// Description:根据术语条目id获取术语条目描述
/// Table:CT.WDT.CDSS.Term
/// Input：id 术语条目ID
/// Return:成功返回术语条目描述
/// Other:d ##class(web.CDSS.CMKB.Term).GetDesc()
ClassMethod GetDesc(id)
{
		q:id="" ""
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(id)),3)  //描述	
		q MKBTDesc
}

/// Creator:丁亚男
/// CreatDate:2018-04-25
/// Description:根据术语库id获取术语库描述
/// Table:CT.WDT.CDSS.TermBase
/// Input：id 术语库ID
/// Return:成功返回术语描述
/// 获取术语描述
/// w ##class(web.CDSS.CMKB.Term).getTermDesc(118)
ClassMethod getTermDesc(base As %String) As %String
{

	s termDesc=""
	s:base'="" termDesc = $LISTGET($G(^CT.WDT.CDSS.TermBaseD(base)),3)
	q termDesc
}

/// Creator:丁亚男
/// CreatDate:2018-04-25
/// Description:根据术语条目id获取术语条目代码
/// Table:CT.WDT.CDSS.Term
/// Input：id 术语条目ID
/// Return:成功返回术语条目Code
/// Other:d ##class(web.CDSS.CMKB.Term).getTermCodeByID()
ClassMethod getTermCodeByID(id)
{
		q:id="" ""
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(id)),2)  //代码	
		q MKBTCode
}

/// Creator:丁亚男
/// CreatDate:2020-08-12
/// Description:根据术语库描述、术语描述获取术语ID
/// Table:CT.WDT.CDSS.Term
/// Input：id 术语条目ID
/// Return:成功返回术语条目id
/// Other:w ##class(web.CDSS.CMKB.Term).getTermIDByDesc("疾病","恶性肿瘤")
ClassMethod getTermIDByDesc(basedesc, termdesc)
{
		q:basedesc=""||termdesc="" ""
		s id=""
		s basedr=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_$ZCONVERT(basedesc,"U"),0))
		
		if (basedr'="")
		{
			//s WikiName =##class(web.CDSS.CMKB.WikiCMKBContrast).getWikiName(termdesc)
			//s:WikiName'="" termdesc=WikiName
			
			s id=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(termdesc,"U")),""))
			
		}
		q id
}

/// Creator:FANWENKAI
/// CreatDate:2021-06-16
/// Description:根据术语库描述、术语描述获取术语ID
/// Table:CT.WDT.CDSS.Term
/// Input：id 术语条目ID
/// Return:成功返回术语条目id json
/// Other:w ##class(web.CDSS.CMKB.Term).getTermIDByDesc("疾病","恶性肿瘤")
ClassMethod getTermIDByDescJson(basedesc, termdesc)
{
		q:basedesc=""||termdesc="" ""
		s id=""
		s basedr=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_$ZCONVERT(basedesc,"U"),0))
		
		if (basedr'="")
		{
			s WikiName =##class(web.CDSS.CMKB.WikiCMKBContrast).getWikiName(termdesc)
			s:WikiName'="" termdesc=WikiName
			
			s id=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(termdesc,"U")),""))
			
		}
		q "{id:'"_id_"'}"
}

/// Creator:丁亚男
/// CreatDate:2018-04-25
/// Description：获取诊断的术语库注册表ID
/// Input：flag-术语库注册表的标识字段值：诊断,药品,检验,检查,手术-Diagnose,Drug,Lab,Check,Operation
ClassMethod GetBaseID(flag) As %String
{
	
	s baseId=""
	q:flag="" ""
	s flag=$ZCONVERT(flag,"U") //转换成大写
	s baseId=$o(^CT.WDT.CDSS.TermBaseI("FlagIndex"," "_flag,0))
	q baseId
}

/// Creator:丁亚男
/// CreatDate:2018-05-02
/// Description：获取术语类型（树形、或者列表性）
/// Input：术语库注册表的ID
/// Return:成功返回术语类型
/// Other:w ##class(web.CDSS.CMKB.Term).GetBaseTypeByID(5)
ClassMethod GetBaseTypeByID(ID) As %String
{
	
	s MKBTBType=$listget($g(^CT.WDT.CDSS.TermBaseD(ID)),4)
	q MKBTBType
}

/// Creator:丁亚男
/// CreatDate:2018-05-02
/// Description：树形术语库部分
/// Input：上级节点，术语库注册表的ID
/// Return:成功返回术语类型
/// Other:w ##class(web.CDSS.CMKB.Term).GetTreeJson(60,"","")
ClassMethod GetTreeJson(base As %String, id As %String, closeflag As %String = "") As %String
{
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	//s flag=##class(web.CDSS.CMKB.TermBase).GetFlagById(base)
	s CatDesc=##class(web.CDSS.CMKB.TermBase).GetCatDescById(base)
	s myJsonStr=""
	
	s ShowInLeftInfo=..GetShowInLeftInfo(base)
	
	//输出菜单JSON串
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			
			s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(myRowID)),2)  //代码
			s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),3)   ///中心词
			s MKBTDesc=$tr(MKBTDesc,"""","")
			s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),2) ///代码
			s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),5)   ///上级分类
			s MKBTLastLevel=""
			s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
			s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),6)
			s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),8)   ///顺序
			s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),7)   ///备注
			s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			s MKBTActiveFlag=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),9)   ///是否激活
			s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(myRowID)),10)
			continue:(closeflag="")&&(MKBTActiveFlag="N")  //判断是否显示封闭数据
			s count=count+1
			if count>1 w ","
			w "{""id"":"""_myRowID_""""
			w ",""MKBTRowId"":"""_myRowID_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""""
			//展示在左侧的数据
			s ExtendStr=""
			if (ShowInLeftInfo'=""){
				s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
				s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
				s len=$length(ShowInLeftDesc,"[N]")
				for i=1:1:len
				{
					s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
					s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
					s MKBTPDDesc=""
					if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",myRowID," "_MKBTPDesc)))
					{
						s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",myRowID," "_MKBTPDesc,0))
						s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
						s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
					} 
					s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
				} 
			}
			if ExtendStr'="" w ","
			w ExtendStr
			//if (flag="ICD11")||(flag="KnoClass")
			if CatDesc["分级加载"
			{
				if $d(^CT.WDT.CDSS.TermI("ParentIndex",base,myRowID))
				{
					w ",""state"":""closed"""
				}
				else
				{
					w ",""state"":""open"""
				}
				w "}"
			}
			else
			{
				if $d(^CT.WDT.CDSS.TermI("ParentIndex",base,myRowID))
				{
					w ",""state"":""open"""
					w ",""children"":"
					w ..GetTreeJson(base,myRowID,closeflag)	
				}
				else
				{
					w ",""state"":""open"""
					
				}
				w "}"
			}
		}
		
	}
	w "]"
	q ""
}

/// Creator:丁亚男
/// CreatDate:2018-12-19
/// Description：树形术语库部分按照全部是叶子节点的格式输出
/// Input：术语库注册表的ID，术语条目id,desc描述
/// Return:成功返回树形术语条目
/// Other:w ##class(web.CDSS.CMKB.Term).GetTreeJsonList(57,"","","")
ClassMethod GetTreeJsonList(base As %String, rowid As %String, desc As %String, parentcatdr As %String) As %String
{
	//输出菜单JSON串
	w "["
	if (base'="") //如果子术语库大类未选中
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			s MKBTRowId=rowid
			s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2) ///代码
			s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)   ///上级分类
			s MKBTLastLevel=""
			s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
			s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
			s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),8)   ///顺序
			s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),7)   ///顺序
			s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			
			w "{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""""
			w ",""state"":""open""}"	
		}
		else
		{
			s:desc'="" desc=$ZCONVERT(desc,"U")
			s mySeqcount=0
			if ($d(^CT.WDT.CDSS.TermI("ParSeqIndex",base)))  //该术语库下有数据
			{
				if (parentcatdr="") s parentcatdr=-100000000000000
				s mySeq=0
				s count=0
				for {
					
					s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
					s MKBTRowId=0
					
					for  
					{	
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,MKBTRowId)) q:MKBTRowId="" 
						s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
						s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2) ///代码
						s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)   ///上级分类
						s MKBTLastLevel=""
						s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
						s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
						s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
						s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),8)   ///顺序
						s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),7)   ///顺序
						s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
						if (desc'=""){
							s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
							s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
							s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
							s aliasDescU=$ZCONVERT(aliasDesc,"U")
							s aliasKeyU=$ZCONVERT(aliasKey,"U")
							
							i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
							{
								
								s count=count+1
								s mySeqcount=mySeqcount+1
								if count>1 w ","
								w "{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""""	
								w ",""state"":""open""}"
								
							}
						}
						else
						{
							s count=count+1
							s mySeqcount=mySeqcount+1
							if count>1 w ","
							w "{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""""	
							w ",""state"":""open""}"
						}
						//s childStr=..GetTreeChildOrderedIDStr(base,MKBTRowId)
						//if childStr'=""
						if $d(^CT.WDT.CDSS.TermI("ParentIndex",base,MKBTRowId))
						{
							s mySeqcount=..GetTreeJsonChildList(base,"", desc,MKBTRowId,mySeqcount)	
						}		
						
					}
				}
			}
		}
	}
	w "]"
	q ""
}

/// Creator:丁亚男
/// CreatDate:2018-12-20
/// Description：树形术语库部分输出子节点
/// Input：术语库注册表的ID，术语条目id,desc描述,父节点
/// Return:成功返回树形术语条目
/// Other:w ##class(web.CDSS.CMKB.Term).GetTreeJsonList(57,"","")
ClassMethod GetTreeJsonChildList(base As %String, rowid As %String, desc As %String, parentcatdr As %String, mySeqcount As %String) As %String
{
	if (parentcatdr="") Q ""
	//输出菜单JSON串
	if (base'="") //如果子术语库大类未选中
	{
		
			s:desc'="" desc=$ZCONVERT(desc,"U")
			if ($d(^CT.WDT.CDSS.TermI("ParSeqIndex",base)))  //该术语库下有数据
			{
				
				s mySeq=0
				for {
					s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
					s MKBTRowId=0
					for  
					{	
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,MKBTRowId)) q:MKBTRowId="" 
						s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
						s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2) ///代码
						s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)   ///上级分类
						s MKBTLastLevel=""
						s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
						s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
						s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
						s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),8)   ///顺序
						s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),7)   ///顺序
						s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
						
						
						if (desc'=""){
							s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
							s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
							s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
							s aliasDescU=$ZCONVERT(aliasDesc,"U")
							s aliasKeyU=$ZCONVERT(aliasKey,"U")
							
							i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
							{
								s mySeqcount=mySeqcount+1
								if mySeqcount>1 w ","
								w "{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""""	
								w ",""state"":""open""}"
								
							}
						}
						else
						{
							w ","
							w "{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""""	
							w ",""state"":""open""}"
						}
						//s childStr=..GetTreeChildOrderedIDStr(base,MKBTRowId)
						//if childStr'=""
						if $d(^CT.WDT.CDSS.TermI("ParentIndex",base,MKBTRowId))
						{
							s mySeqcount=..GetTreeJsonChildList(base,"", desc,MKBTRowId,mySeqcount)	
						}		
						
					}
				}
			
		}
	}
	q mySeqcount
}

/// Creator:丁亚男
/// CreatDate:2019-02-21
/// Description：树形术语库部分按照列表输出，但是要保持跟左侧列表顺序一致
/// Input：术语库注册表的ID，术语条目id,desc描述
/// Return:成功返回树形术语条目
/// Other:d ##class(web.CDSS.CMKB.Term).GetTreeJsonListForPages(57,"","","",10,1)
ClassMethod GetTreeJsonListForPages(base As %String, rowid As %String, desc As %String, parentcatdr As %String, rows As %String, page As %String) As %String
{
	s result="",total=0,jsonstr="",mainstr=""
	
	//输出JSON串
	if (base'="") //如果子术语库大类未选中
	{
		s ShowInLeftInfo=..GetShowInLeftInfo(base)
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行
		w "{""rows"":["
		if (rowid'="") //根据rowid返回该条记录
		{
			s total=total+1
			s MKBTRowId=rowid
			s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			
			s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)   ///上级分类
			s MKBTLastLevel=""
			s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
			s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
			s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),8)   ///顺序
			s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),7)   ///顺序
			s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			//展示在左侧的数据
			s ExtendStr=""
			if (ShowInLeftInfo'=""){
				s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
				s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
				s len=$length(ShowInLeftDesc,"[N]")
				for i=1:1:len
				{
					s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
					s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
					s MKBTPDDesc=""
					if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
					{
						s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
						s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
						s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
					} 
					s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
				} 
			}
			s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""","_ExtendStr_"}"
		    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_"""}"
			w mainstr
		}
		else
		{
			s:desc'="" desc=$ZCONVERT(desc,"U")
			
			if ($d(^CT.WDT.CDSS.TermI("ParSeqIndex",base)))  //该术语库下有数据
			{
				if (parentcatdr="") s parentcatdr=-100000000000000
				s mySeq=0
				for {
					
					s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
					s MKBTRowId=0
					for  
					{	
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,MKBTRowId)) q:MKBTRowId="" 
						
						if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
						{
							
						}
						else
						{
							s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
							s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
							s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
							s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2) ///代码
							s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)   ///上级分类
							s MKBTLastLevel=""
							s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
							s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
							s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
							s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),8)   ///顺序
							s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),7)   ///顺序
							s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
							//展示在左侧的数据
							s ExtendStr=""
							if (ShowInLeftInfo'=""){
								s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
								s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
								s len=$length(ShowInLeftDesc,"[N]")
								for i=1:1:len
								{
									s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
									s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
									s MKBTPDDesc=""
									if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
									{
										s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
										s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
										s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
									} 
									s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
									s:ExtendStr'="" ExtendStr=ExtendStr_","
									s ExtendStr=ExtendStr_thisStr
								} 
							}
						}
						
						if (desc'="")
						{
							s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
							s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
							s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
							s aliasDescU=$ZCONVERT(aliasDesc,"U")
							s aliasKeyU=$ZCONVERT(aliasKey,"U")
							
							i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
							{
								s total=total+1
								if (total>=stpage)&(total<=endpage)
						    	{
								 	s:ExtendStr'="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""","_ExtendStr_"}"
		    						s:ExtendStr="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_"""}"
									
									
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
							s total=total+1
						    if (total>=stpage)&(total<=endpage)
						    {
								s:ExtendStr'="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""","_ExtendStr_"}"
		    					s:ExtendStr="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_"""}"
									
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
						
						if $d(^CT.WDT.CDSS.TermI("ParSeqIndex",base,MKBTRowId))
						{
							s jsonstrtotal=..GetTreeJsonChildListForPages(base,"", desc,MKBTRowId,jsonstr,total,stpage,endpage,ShowInLeftInfo)	
							s jsonstr=$p(jsonstrtotal,"%&",1)
							s total=$p(jsonstrtotal,"%&",2)
						}		
						
					}
				}
			}
		}
		w "], ""total"":"_total_"}"
	}
	else
	{
		w "{""rows"":[], ""total"":0}"
	}
	q ""
}

/// Creator:丁亚男
/// CreatDate:2018-12-20
/// Description：树形术语库部分输出子节点
/// Input：术语库注册表的ID，术语条目id,desc描述,父节点
/// Return:成功返回树形术语条目
/// Other:w ##class(web.CDSS.CMKB.Term).GetTreeJsonList(57,"","")
ClassMethod GetTreeJsonChildListForPages(base As %String, rowid As %String, desc As %String, parentcatdr As %String, jsonstr As %String, total As %String, stpage As %String, endpage As %String, ShowInLeftInfo As %String) As %String
{
	if (parentcatdr="") Q ""
	s mainstr=""
	//输出菜单JSON串
	if (base'="") //如果子术语库大类未选中
	{
		
		s:desc'="" desc=$ZCONVERT(desc,"U")
		if ($d(^CT.WDT.CDSS.TermI("ParSeqIndex",base)))  //该术语库下有数据
		{
			s mySeq=0
			for {
				s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
				s MKBTRowId=0
				for  
				{	
					s MKBTRowId=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,parentcatdr,mySeq,MKBTRowId)) q:MKBTRowId="" 
					if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
					{
						
					}
					else
					{
						s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),2) ///代码
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
						
						s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)   ///上级分类
						s MKBTLastLevel=""
						s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
						s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
						s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
						s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),8)   ///顺序
						s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),7)   ///顺序
						s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
						//展示在左侧的数据
						s ExtendStr=""
						if (ShowInLeftInfo'=""){
							s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
							s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
							s len=$length(ShowInLeftDesc,"[N]")
							for i=1:1:len
							{
								s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
								s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
								s MKBTPDDesc=""
								if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
								{
									s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
									s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
									s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
								} 
								s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
								s:ExtendStr'="" ExtendStr=ExtendStr_","
								s ExtendStr=ExtendStr_thisStr
							} 
						}
						
					}
					
					if (desc'=""){
						s strAlias=##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)  
						s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
						s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
						s aliasDescU=$ZCONVERT(aliasDesc,"U")
						s aliasKeyU=$ZCONVERT(aliasKey,"U")
						
						i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
						{
							s total=total+1
					    	if (total>=stpage)&(total<=endpage)
					    	{
								s:ExtendStr'="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""","_ExtendStr_"}"
		    					s:ExtendStr="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_"""}"
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
						s total=total+1
				    	if (total>=stpage)&(total<=endpage)
				    	{
							s:ExtendStr'="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""","_ExtendStr_"}"
		    				s:ExtendStr="" mainstr="{""id"":"""_MKBTRowId_""",""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_"""}"
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
					if $d(^CT.WDT.CDSS.TermI("ParSeqIndex",base,MKBTRowId))
					{
						s jsonstrtotal= ..GetTreeJsonChildListForPages(base,"", desc,MKBTRowId,jsonstr,total,stpage,endpage,ShowInLeftInfo)	
						s jsonstr=$p(jsonstrtotal,"%&",1)
						s total=$p(jsonstrtotal,"%&",2)
					}
					else
					{
						s jsonstrtotal=jsonstr_"%&"_total
					}		
					
				}
			}
		
		}
	}
	q jsonstrtotal
}

/// Creator：丁亚男
/// CreatDate: 2018-05-2
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：CT.WDT.CDSS.Term
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.CMKB.Term).GetChildOrderedIDStr("")
ClassMethod GetTreeChildOrderedIDStr(base As %String, LastLevel As %String) As %String
{

	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	/*s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	*/
	//输出菜单JSON串
	
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			
			s childStr=..GetTreeChildOrderedIDStr(base,myRowID)
			if childStr'="" s childStr=myRowID_"^"_childStr
			if childStr="" s childStr=myRowID
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// Description：保存拖拽的内容 2016/9/21     ---HISUI
/// Table：User.DHCSymptomLev
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.CDSS.CMKB.Term).DragNode(41108,41110,"")
ClassMethod DragNode(id, parentid, orderstr) As %String
{
	s result=""
	q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
	s:parentid="TreeRoot" parentid=""

	s obj=##class(CT.WDT.CDSS.Term).%OpenId(id) 
	s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(id)),3)  //描述
	s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(id)),4)
	s flag=..FormValidateTree(id,MKBTBaseDR,MKBTDesc,parentid)  //调用重复验证	
	
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在'}"
	}
	else
	{
		d:parentid="" obj.MKBTLastLevelSetObjectId("")
		d:parentid'="" obj.MKBTLastLevelSetObjectId(parentid)

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
				s obj=##class(CT.WDT.CDSS.Term).%OpenId(rowid)
				s obj.MKBTSequence =i
				s sc=obj.%Save()
				d obj.%Close()           
			}
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}

		
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2018-6-07
/// Description：复制术语条目及下面的信息到新的术语条目
/// Table：CT.WDT.CDSS.Term
/// Input：copytermdr-术语条目id, copyall-不为空的时候完全复制，为空的时候只复制格式,CopyMKBTDesc新的术语名称
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.CDSS.CMKB.Term).CopyTerm("41138","1","复制中心词11")
ClassMethod CopyTerm(copytermdr, copyall, CopyMKBTDesc) As %String
{

    s result = ""
    q:(copytermdr="") "{success:'false',errorinfo:'没有选择术语'}"
    
    s BaseDR = $listGet($g(^CT.WDT.CDSS.TermD(copytermdr)),4)
    s MKBTBDesc=$listGet($g(^CT.WDT.CDSS.TermBaseD(BaseDR)),3)  //术语库描述
    s MKBTBType=$listGet($g(^CT.WDT.CDSS.TermBaseD(BaseDR)),4)  //术语库类型
    
    //自动生成术语编码
    s MKBTCode=..GetMultiTermCode(BaseDR)
    
    //复制术语：CT_WDT_CDSS.Term
    s obj=##class(CT.WDT.CDSS.Term).%OpenId(copytermdr)
    s nobj=##class(CT.WDT.CDSS.Term).%New()
	s flag=..FormValidate("",CopyMKBTDesc,MKBTCode,BaseDR)  //调用重复验证
			 
    s errorinfo="复制失败！"_MKBTBDesc_"已经存在术语"_CopyMKBTDesc_"!"  //错误信息
    q:(flag=1) "{success:'false',errorinfo:'"_errorinfo_"'}"

    s nobj.MKBTCode = MKBTCode
    s nobj.MKBTDesc = CopyMKBTDesc
    d nobj.MKBTBaseDRSetObjectId(BaseDR)
    if (obj.MKBTLastLevel'="")
    {
        s nobj.MKBTLastLevel=obj.MKBTLastLevel
    }
    s nobj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CopyMKBTDesc)
    s nobj.MKBTPYCode=##class(web.CDSS.CMKB.TermProDetail).Filter(nobj.MKBTPYCode) //去掉特殊字符-等
    s nobj.MKBTNote=obj.MKBTNote
	s nobj.MKBTSequence=..GetLastSequence(BaseDR)
	
    TS
    s sc=nobj.%Save()
    d nobj.%Close()
    d obj.%Close()
    If $$$ISOK(sc)
    {
         
         s id = nobj.%Id()
         //保存日志
		 //d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Term","CT.WDT.CDSS.Term"_BaseDR,MKBTBDesc,id,nobj.MKBTDesc,"A",nobj)
         s MKBTPRowId=0
         for
         {
	      	s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("TermIndex",copytermdr,MKBTPRowId)) q:MKBTPRowId=""
	      	s copyresult=##class(web.CDSS.CMKB.TermProperty).CopyToOtherTrem(id,MKBTPRowId,copyall)
	      	if (copyresult["false")
	      	{
		      	s result = "false"
		      	break
		    }
	     }
    }
    else
    {
        s result = "false"

    }
    if (result["false"){
        Trollback
        s result = "{success:'false',errorinfo:'复制失败！'}"
    }else{
        TC
        s result = "{success:'true',id:'"_id_"',info:'复制成功！'}" //返回RowId
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2019-02-21
/// Description：根据扩展界面选中的id展示树状结构
/// Table：CT.WDT.CDSS.Term
/// Input：树形术语id
/// Return：树形的json数据
/// w ##class(web.CDSS.CMKB.Term).SearchTermICD("霍乱","63")
ClassMethod TreeStructure(id As %String, base As %String, closeflag As %String = "") As %String
{
	k ^TMPICDMKBTermI("ParSeqIndex")
	s strChildren=..SearchChildren(id,base)  //生成子节点索引
    s strParents=..SearchParents(id,base)  //生成父节点索引
            
    if (strChildren["true")&(strParents["true")
    {
      s result="success:'true'" 
    }
    else
    {
    	s result="success:'false'" 
    }

    if (result["true")
    {
		d ..GetTreeJsonICD(base,"",closeflag)
	}
	else
	{
		w "[]"	
	}
  q ""
}

/// Creator:丁亚男
/// CreatDate:2019-02-13
/// Description：获取诊断_ICD11满足搜索条件的术语
/// Table：CT.WDT.CDSS.Term
/// Input：搜索框输入的desc
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.CDSS.CMKB.Term).SearchTermICD("","60")
ClassMethod SearchTermICD(desc As %String, base As %String, closeflag As %String = "") As %String
{
	
    //生成满足条件的术语索引
    s rtn=..CreatTermICDIndex(desc,base)
    if (rtn["true")
    {
		d ..GetTreeJsonICD(base,"",closeflag)
	}
	else
	{
		w "[]"	
	}
  q ""
}

/// Creator:丁亚男
/// CreatDate:2018-05-02
/// Description：树形术语库部分
/// Input：上级节点，术语库注册表的ID
/// Return:成功返回术语类型
/// Other:w ##class(web.CDSS.CMKB.Term).GetTreeJson(63,"")
ClassMethod GetTreeJsonICD(base As %String, id As %String, closeflag As %String = "") As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	s ShowInLeftInfo=..GetShowInLeftInfo(base)
	s mySeq=0
	w "["
	s count=0
	for {
		s mySeq=$o(^TMPICDMKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^TMPICDMKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			
			s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),2) ///代码
			s MKBTCode=$tr(MKBTCode,"""","")
			s MKBTCode=$tr(MKBTCode,",","，")
			s MKBTCode= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTCode)
			
			s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),3)   ///中心词
			s MKBTDesc=$tr(MKBTDesc,"""","")
			s MKBTDesc=$tr(MKBTDesc,",","，")
			s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			
			s MKBTLastLevelF=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),5)   ///上级分类
			s MKBTLastLevel=""
			s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevelF)),3)
			if (MKBTLastLevel'="")
			{
				s MKBTLastLevel=$tr(MKBTLastLevel,"""","")
				s MKBTLastLevel=$tr(MKBTLastLevel,",","，")
				s MKBTLastLevel= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTLastLevel)
			}
			
			s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),6)
			s MKBTPYCode=$tr(MKBTPYCode,"""","")
			s MKBTPYCode=$tr(MKBTPYCode,",","，")
			s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			
			s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),8)   ///顺序
			s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),7)   ///备注
			s MKBTNote=$tr(MKBTNote,"""","")
			s MKBTNote=$tr(MKBTNote,",","，")
			s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(myRowID)),9)
			continue:(closeflag="")&&(MKBTActiveFlag="N")  //判断是否显示封闭数据
			s count=count+1
			
			if count>1 w ","
			w "{""id"":"""_myRowID_""""
			w ",""MKBTRowId"":"""_myRowID_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevelF"":"""_MKBTLastLevelF_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""""
			//展示在左侧的数据
			s ExtendStr=""
			if (ShowInLeftInfo'=""){
				s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
				s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
				s len=$length(ShowInLeftDesc,"[N]")
				for i=1:1:len
				{
					s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
					s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
					s MKBTPDDesc=""
					if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",myRowID," "_MKBTPDesc)))
					{
						s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",myRowID," "_MKBTPDesc,0))
						s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
						s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
					} 
					s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
				} 
			}
			if ExtendStr'="" w ","
			w ExtendStr
			
			if $d(^TMPICDMKBTermI("ParSeqIndex",base,myRowID))
			{
				w ",""state"":""open"""
				w ",""children"":"
				d ..GetTreeJsonICD(base,myRowID,closeflag)	
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

/// Creator:李欣
/// CreatDate:2019-02-13
/// Description：获取满足搜索条件的术语id串
/// Table：CT.WDT.CDSS.Term
/// Input：搜索框输入的desc
/// Return：成功返回id串
/// ICD11id串
/// w ##class(web.CDSS.CMKB.Term).GetTermIDs()
ClassMethod GetTermIDs(baseDr, descStr)
{
	q:descStr="" ""
	s result=""
	k termIdArr

	s spiltWord=""
	if (descStr["||")
	{
		s spiltWord="||"
	}
	if (descStr[" ") 
	{
		s spiltWord=" "
	}
	s descLen=1
	if (spiltWord'="")
	{
		s descLen=$Length(descStr,spiltWord) 
	}
	for descCount=1:1:descLen
	{
		if (spiltWord'="")
		{
			s desc=$p(descStr,spiltWord,descCount)
		}
		else
		{
			s desc=descStr
		}
		continue:desc="" 
		s TermIds=0
		for
		{
			s TermIds = $O(^User.BDPMKBIndexI("DescIndex"," "_$ZCONVERT(desc,"U"),TermIds))
			q:TermIds=""
			
			continue:TermIds["D"
			continue:($D(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,TermIds))=0)
			//s:result'="" result=result_"&%"_TermIds
			//s:result="" result=TermIds	
			if $d(termIdArr(TermIds)){
				s termIdArr(TermIds)=termIdArr(TermIds)+1
			}
			else{
				s termIdArr(TermIds)=1
			}
		}	
	}

	if ($d(termIdArr))
	{
		s termId=0
		for
		{
			s termId=$o(termIdArr(termId))
			q:termId=""
			if (descStr["||")
			{
				s:result'="" result=result_"&%"_termId
				s:result="" result=termId										
			}
			else
			{
				if (termIdArr(termId)=descLen){
					s:result'="" result=result_"&%"_termId
					s:result="" result=termId			
				}
			}
		}
	}

	q result
}

/*ClassMethod GetTermIDs(baseDr, desc)
{
	q:desc="" ""
	s result=""
	
	s TermIds=0
	for
	{
		s TermIds = $O(^User.BDPMKBIndexI("DescIndex"," "_$ZCONVERT(desc,"U"),TermIds))
		q:TermIds=""
		
		continue:TermIds["D"
		continue:($D(^CT.WDT.CDSS.TermI("BaseIndex",baseDr,TermIds))=0)
		s:result'="" result=result_"&%"_TermIds
		s:result="" result=TermIds	
	}	
	q result
}*/
/// 备注：暂时弃用2019-04-17
/// Creator:李欣
/// CreatDate:2019-02-13
/// Description：获取满足搜索条件的术语id串
/// Table：CT.WDT.CDSS.Term
/// Input：搜索框输入的desc
/// Return：成功返回id串
/// ICD11id串
/// w ##class(web.CDSS.CMKB.Term).GetIDsForICD11()
ClassMethod GetIDsForICD11(desc)
{
	q:desc="" ""
	s result=""
	s MKBTBRowId=$O(^CT.WDT.CDSS.TermBaseI("FlagIndex"," ICD11",0))
	s TermIds=0
	for
	{
		s TermIds = $O(^User.BDPMKBIndexI("DescIndex"," "_$ZCONVERT(desc,"U"),TermIds))
		q:TermIds=""
		
		continue:TermIds["D"
		continue:($D(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBRowId,TermIds))=0)
		s:result'="" result=result_"&%"_TermIds
		s:result="" result=TermIds	
	}	
	q result
}

/// Creator:丁亚男
/// CreatDate:2019-02-13
/// Description：获取满足搜索条件的术语id，生成临时索引
/// Table：CT.WDT.CDSS.Term
/// Input：搜索框输入的desc
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.CDSS.CMKB.Term).CreatTermICDIndex(desc)
ClassMethod CreatTermICDIndex(desc As %String, base As %String) As %String
{
    k ^TMPICDMKBTermI("ParSeqIndex")
    
    s str="",result=""
    s:desc'="" desc=$ZCONVERT(desc,"U")
    //满足搜索条件的菜单拼串
    s str=##class(web.CDSS.CMKB.Term).GetTermIDs(base,desc)
    s strChildren=""
    s strParents=""
    s strLen=$Length(str,"&%")
    for i=1:1:strLen        
    {           
        s rowid=$p(str,"&%",i)
        if (rowid'=""){ 
            s strChildren=..SearchChildren(rowid,base)  //生成子节点索引
            s strParents=..SearchParents(rowid,base)  //生成父节点索引
            
            if (strChildren["true")&(strParents["true")
            {
	          s result="success:'true'" 
	        }
	        else
	        {
		    	s result="success:'false'" 
		    }
        }
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2019-02-13
/// Description：获取满足搜索条件的子节点
/// Table：CT.WDT.CDSS.Term
/// Input：rowid-术语条目id
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.CDSS.CMKB.Term).SearchChildren("41138")
ClassMethod SearchChildren(rowid As %String, base As %String) As %String
{
    s str="success:'true'"
    
    if ($d(^CT.WDT.CDSS.TermI("ParSeqIndex",base,rowid)))
    {
	    s Sequence=""
	    for{
	        s Sequence=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,rowid,Sequence)) q:Sequence=""
	        s MKBTRowId=""
	        for 
	        {
		        s MKBTRowId=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,rowid,Sequence,MKBTRowId)) q:MKBTRowId=""
	        	s ^TMPICDMKBTermI("ParSeqIndex",base,rowid,Sequence,MKBTRowId)=""
	        } 
	    }
    }
    q str
}

/// Creator:丁亚男
/// CreatDate:2019-02-13
/// Description：获取满足搜索条件的父节点
/// Table：CT.WDT.CDSS.Term
/// Input：rowid-术语条目id
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.CDSS.CMKB.Term).SearchChildren("41138")
ClassMethod SearchParents(rowid As %String, base As %String) As %String
{
    s str="success:'true'"
    s MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(rowid)),5)
    s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(rowid)),8)
    s:MKBTSequence="" MKBTSequence=0
    if (MKBTLastLevel=""){
	    s MKBTLastLevel=-100000000000000
	    s ^TMPICDMKBTermI("ParSeqIndex",base,MKBTLastLevel,MKBTSequence,rowid)=""
    }
    else{
	    s ^TMPICDMKBTermI("ParSeqIndex",base,MKBTLastLevel,MKBTSequence,rowid)=""
        s str= ..SearchParents(MKBTLastLevel,base)  //递归 
    }

    q str
}

/// Creator:丁亚男
/// CreatDate:2019-02-28
/// Description：获取在左侧纵向展示栏展示的属性名称
/// Table：CT.WDT.CDSS.TermBase
/// Input：术语库注册id
/// Return：成功返回属性名称的串 ,失败返回""
/// w ##class(web.CDSS.CMKB.Term).GetShowInLeftInfo("62")
ClassMethod GetShowInLeftInfo(BaseDr As %String) As %String
{
    s result=""
    s dataIndex=""  //组件dataIndex
	s header=""  //组件标题、列表表头
    if (BaseDr="") q ""
    if ($d(^CT.WDT.CDSS.TermBasePropertyI("ShowIndex",BaseDr,"Y")))
    {
		s MKBTBPRowId=0
		for  
		{	s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("ShowIndex",BaseDr,"Y",MKBTBPRowId)) q:MKBTBPRowId="" 
			s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),3)
			s MKBTBPDescU=$ZCONVERT(MKBTBPDesc,"U")
			
			s:dataIndex'="" dataIndex=dataIndex_"[N]"_MKBTBPRowId
			s:dataIndex="" dataIndex=MKBTBPRowId
			
			s:header'="" header=header_"[N]"_MKBTBPDescU
			s:header="" header=MKBTBPDescU
			
		}
			
	}
	s result=dataIndex_"[A]"_header
	q result
}

/// Creator:丁亚男
/// CreatDate:2019-04-17
/// Description：获取全局化诊断词表(列表型)满足搜索条件的术语
/// Table：CT.WDT.CDSS.Term
/// Input：搜索框输入的desc
/// Return：成功返回符合条件的结果
/// w ##class(web.CDSS.CMKB.Term).SearchTerm("64","糖尿病",20,1)
ClassMethod SearchTerm(base As %String, desc As %String, rows, page, closeflag As %String = "", RowID As %String = "") As %String
{
	
    //获取符合检索结果的id串
    if (page=1)
    {
    	k ^TMPTermIDs("IDs")
    	s ^TMPTermIDs("IDs")=##class(web.CDSS.CMKB.Term).GetTermIDs(base,desc)
    }
    
    s rtn=^TMPTermIDs("IDs")
    if (rtn="")&&(RowID'="")
    {
	    s rtn=RowID
    }
    if (rtn'="")
    {
	    s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行
		s ShowInLeftInfo=..GetShowInLeftInfo(base)
		
		s minlen=endpage
	    s rtnLen=$Length(rtn,"&%")
	    s total=rtnLen
	    if (minlen>rtnLen)
	    {
		    s minlen=rtnLen
		}
		
		w "{""rows"":["
	    for j=stpage:1:minlen        
	    {           
	        s rowid=$p(rtn,"&%",j)
	        if (j'=stpage) w ","
	        if (rowid'=""){ 
				s MKBTRowId=rowid
				s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
				s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
				s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //拼音码
				s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
				s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
				s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
				s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)  //顺序
				s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
				continue:(closeflag="")&&(MKBTActiveFlag="N")  //判断是否显示封闭数据
				//展示在左侧的数据
				s ExtendStr=""
				if (ShowInLeftInfo'=""){
					s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
					s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
					s len=$length(ShowInLeftDesc,"[N]")
					for i=1:1:len
					{
						s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
						s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
						s MKBTPDDesc=""
						if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
						{
							s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
							s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
							s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
						} 
						s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
						s:ExtendStr'="" ExtendStr=ExtendStr_","
						s ExtendStr=ExtendStr_thisStr
					} 
				}
				s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTSequence"":"""_MKBTSequence_""","_ExtendStr_"}"
			    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTSequence"":"""_MKBTSequence_"""}"
				w mainstr
	        } 
		}
		w "], ""total"":"_total_"}"
	}
	else
	{
		w "{""rows"":[], ""total"":0}"	
	}
	q ""
}

/// Creator:丁亚男
/// CreatDate:2019-05-21
/// Description:根据id封闭数据
/// Table:CT.WDT.CDSS.Term
/// Return:成功返回"{success:'true',id:'"_id_"'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.Term).CloseData("41054")
ClassMethod CloseData(id As %String) As %String
{
	
	s result=""
    s obj = ##class(CT.WDT.CDSS.Term).%OpenId(id)
    s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
    s bobj = ##class(web.CDSSEntity.CMKB.Term).%New()
    s bobj.MKBTRowId = id
	s bobj.MKBTCode = obj.MKBTCode
	s bobj.MKBTDesc = obj.MKBTDesc
	s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
	s bobj.MKBTPYCode=  obj.MKBTPYCode
	s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
	s bobj.MKBTSequence=  obj.MKBTSequence
	s:obj.MKBTLastLevel'="" bobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
	s bobj.MKBTActiveFlag=  obj.MKBTActiveFlag
				
    s eobj.MKBTRowId=id
    s eobj.MKBTCode = obj.MKBTCode
	s eobj.MKBTDesc = obj.MKBTDesc
	s:obj.MKBTBaseDR'="" eobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
	s MKBTBDesc=""
	s:eobj.MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTBaseDR)),3)
	s eobj.MKBTPYCode=  obj.MKBTPYCode
	s eobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
	s eobj.MKBTSequence=  obj.MKBTSequence
	s:obj.MKBTLastLevel'="" eobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
    s eobj.MKBTActiveFlag="N"
    s obj.MKBTActiveFlag="N"
    TS
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId	
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Term","CT.WDT.CDSS.Term"_eobj.MKBTBaseDR,MKBTBDesc,eobj.MKBTRowId,eobj.MKBTDesc,"U",eobj,bobj)	        
	}
	else
	{
		Trollback
		if '$$$ISOK(sc){
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 	
			}
	}
		
    q result
}

/// Creator:丁亚男
/// CreatDate:2019-05-24
/// Description:根据id解除封闭数据
/// Table:CT.WDT.CDSS.Term
/// Return:成功返回"{success:'true',id:'"_id_"'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.Term).CancelCloseData("41054")
ClassMethod CancelCloseData(id As %String) As %String
{
	
	s result=""
    s obj = ##class(CT.WDT.CDSS.Term).%OpenId(id)
    s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
    s bobj = ##class(web.CDSSEntity.CMKB.Term).%New()
    s bobj.MKBTRowId = id
	s bobj.MKBTCode = obj.MKBTCode
	s bobj.MKBTDesc = obj.MKBTDesc
	s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
	s bobj.MKBTPYCode=  obj.MKBTPYCode
	s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
	s bobj.MKBTSequence=  obj.MKBTSequence
	s:obj.MKBTLastLevel'="" bobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
	s bobj.MKBTActiveFlag=  obj.MKBTActiveFlag
				
    s eobj.MKBTRowId=id
    s eobj.MKBTCode = obj.MKBTCode
	s eobj.MKBTDesc = obj.MKBTDesc
	s:obj.MKBTBaseDR'="" eobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
	s MKBTBDesc=""
	s:eobj.MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTBaseDR)),3)
	s eobj.MKBTPYCode=  obj.MKBTPYCode
	s eobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
	s eobj.MKBTSequence=  obj.MKBTSequence
	s:obj.MKBTLastLevel'="" eobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
    s eobj.MKBTActiveFlag="Y"
    s obj.MKBTActiveFlag="Y"
    
    TS
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId	
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Term","CT.WDT.CDSS.Term"_eobj.MKBTBaseDR,MKBTBDesc,eobj.MKBTRowId,eobj.MKBTDesc,"U",eobj,bobj)		        
	}
	else
	{
		Trollback
		if '$$$ISOK(sc){
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 	
			}
	}
		
    q result
}

/// Creator:钟荣枫
/// CreatDate:2020-9-9
/// Description：获取属性内容列表的数据 下拉框格式
/// Input：rowid, desc, base, rows, page, sortway,closeflag
/// Return:Json格式的字符串
/// Other:w ##class(web.CDSS.CMKB.Term).GetMyListCombo("","","5","","","")
ClassMethod GetMyListCombo(rowid, desc, base, closeflag As %String = "", matchflag, allflag) As %String
{
	s result="",total=0,jsonstr=""
	s combolimit=10,totalcount=0
	if (base="")
	{
		w "{""rows"":[], ""total"":0}"
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ShowInLeftInfo=..GetShowInLeftInfo(base)
		w "{""rows"":["
		
		if (rowid'="") //根据rowid返回该条记录
		{
			
			s total=total+1
			s MKBTRowId=rowid
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s ID=MKBTRowId
			s Desc=MKBTDesc
			
		}
		else
		{
			if ($d(^CT.WDT.CDSS.TermI("BaseIndex",base)))  //该术语库下有数据
			{
				//按照知识数量排序
				s MKBTDetailCount=""
				for  
				{	
					s MKBTDetailCount=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount),-1) q:MKBTDetailCount=""
					s MKBTRowId=0
					for  
					{	
						s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount,MKBTRowId)) q:MKBTRowId=""
						s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
						continue:(closeflag="")&&(MKBTActiveFlag="N")  //判断是否显示封闭数据
						s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
						s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
						s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
						s Alisaflag=0		//判断是否需要到别名中查找
						
						if ((MKBTDesc[desc)||(MKBTPYCode[desc))
						{
							
							if (matchflag=1)		//完全匹配
							{
								s:((MKBTDesc'=desc)&&(MKBTPYCode'=desc)) Alisaflag=1
		 					}
							if (Alisaflag=0)
							{
								s totalcount=totalcount+1
								s ID=MKBTRowId
								s Desc=MKBTDesc
								if (allflag'=1)		//为1输出全部数据，不为1，仅输出10条
								{
									
									if (totalcount=(combolimit+1))  //如果超过十条，显示... 
									{
										s ID="..."
										s Desc="..."
										s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_"""}"
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
									q:(totalcount>combolimit)
								}
								s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_"""}"
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
								//d OutputRowCmb	
								continue
							}
						}
						else
						{
							s Alisaflag=1
						}
						if (Alisaflag=1)
						{
							//别名
							s showCount=0
							s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",MKBTRowId," AL",0))

							s MKBTPDRowId=0
							for  
							{	
								s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) 
								q:MKBTPDRowId="" 
								s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)	//别名描述
								s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
								s comPY=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),10)  //检索码
								if (matchflag'=1)
								{
									continue:(MKBTPDDesc'[desc)&&(comPY'[desc)
								}
								else
								{
									continue:(MKBTPDDesc'=desc)&&(comPY'=desc)
								}
								s showCount=showCount+1
								s:showCount=1 showDesc=MKBTPDDesc	//只取第一个符合的数据
								
							}
							if (showCount>0)
							{

								s Desc=MKBTDesc_"("_showDesc_")"
								s ID=MKBTRowId
								s totalcount=totalcount+1
								
								if (allflag'=1)		//为1输出全部数据，不为1，仅输出10条
								{
									if (totalcount=(combolimit+1))  //如果超过十条，显示... 
									{
										s ID="..."
										s Desc="..."
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
									q:(totalcount>combolimit)
								}	
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
							else
							{
								continue	
							}
			
	
						}
					}
					q:(totalcount>combolimit)
				}
				
			}
		}
		w "], ""total"":"_totalcount_"}"
	}
	q ""
}

/// Creator:钟荣枫
/// CreatDate:2020-9-9
/// Description：获取属性内容列表的数据 下拉框格式
/// Table：CT.WDT.CDSS.Term
/// Input：rowid As %String, base As %String, matchflag, allflag, q As %String
/// Return：ID,Desc
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.Term","GetDataForCmb2","","5","","","","肺")
Query GetDataForCmb2(rowid As %String, base As %String, closeflag, matchflag, allflag, q As %String) As %Query(ROWSPEC = "ID,Desc")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, base As %String, closeflag, matchflag, allflag, q As %String) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	
	s desc=$ZCONVERT(q,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
		s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
		d OutputRowCmb2
	}
	else
	{
		s combolimit=10,totalcount=0
		//按照知识数量排序
		s MKBTDetailCount=""
		for  
		{	
			s MKBTDetailCount=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount),-1) q:MKBTDetailCount=""
			s MKBTRowId=0
			q:endflag=1
			for  
			{	
				s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount,MKBTRowId)) q:MKBTRowId=""
				q:endflag=1
				s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),9)
				continue:(closeflag="")&&(MKBTActiveFlag="N")  //判断是否显示封闭数据
				s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
				s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
				
				s outputflag=0
				if (matchflag=1)		//完全匹配
				{
					if ((MKBTDesc'=desc)&&(MKBTPYCode'=desc))
					{
						s outputflag=1
					}
				}
				else
				{
					if ((MKBTDesc'[desc)&&(MKBTPYCode'[desc))
					{
						s outputflag=1
					}
				}
				if (outputflag=1)
				{
					s ID=MKBTRowId
					s Desc=MKBTDesc
					
					if (allflag'=1)		//为1输出全部数据，不为1，仅输出10条
					{
						s totalcount=totalcount+1
						if (totalcount=(combolimit+1))  //如果超过十条，显示... 
						{
							s ID="..."
							s Desc="..."
						}
						d OutputRowCmb2
						s:(totalcount>combolimit) endflag=1
					}
					else
					{
						s totalcount=totalcount+1
						d OutputRowCmb2
					}
					
				}
				else
				{
					
					//别名
					s showCount=0
					s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",MKBTRowId," AL",0))
					s MKBTPDRowId=0
					for  
					{	
						s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) 
						q:MKBTPDRowId="" 
						s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)	//别名描述
						s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
						s comPY=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),10)  //检索码
						if (matchflag'=1)
						{
							continue:(MKBTPDDesc'[desc)&&(comPY'[desc)
						}
						else
						{
							continue:(MKBTPDDesc'=desc)&&(comPY'=desc)
						}
						s showCount=showCount+1
						s:showCount=1 showDesc=MKBTPDDesc	//只取第一个符合的数据
						
					}
					if (showCount>0)
					{
						s Desc=MKBTDesc_"("_showDesc_")"
						s ID=MKBTRowId
						
						if (allflag'=1)		//为1输出全部数据，不为1，仅输出10条
						{
							
							s totalcount=totalcount+1
							if (totalcount=(combolimit+1))  //如果超过十条，显示... 
							{
								s ID="..."
								s Desc="..."
							}
							d OutputRowCmb2
							s:totalcount>combolimit endflag=1
						}
						else
						{
							s totalcount=totalcount+1
							d OutputRowCmb2
						}
								
					}
					else
					{
						continue	
					}

				}
			}
			q:(totalcount>combolimit)
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb2
    set Data=$lb(ID,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

/// Creator：钟荣枫
/// CreatDate: 2020-10-22
/// Description：获取某个父节点下的所有下一级子节点 用^连接，并按照顺序排列  
/// Table：User.BDPItemCategory
/// Input：父节点
/// Return：所有下一级子节点 用^连接
/// w ##class(web.CDSS.CMKB.Term).GetNextChildIDStr("")
ClassMethod GetNextChildIDStr(base As %String, LastLevel As %String) As %String
{
	
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	
	
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^CT.WDT.CDSS.TermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			
			//s childStr=..GetChildOrderedIDStr(base,myRowID)
			//if childStr'="" s childStr=myRowID_"^"_childStr
			//if childStr="" s childStr=myRowID
			s childStr=myRowID
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// Creator：钟荣枫
/// CreatDate:2021-6-4
/// Description:导出某个base下的数据
/// Input:baseid，
/// OutPut: 成功， 失败
/// w ##class(web.CDSS.CMKB.Term).ExportTermDataOfBase(9)
ClassMethod ExportTermDataOfBase(base)
{
	q:base="" ""
	s basedesc=$lg($g(^CT.WDT.CDSS.TermBaseD(base)),3)	//  MKBTBDesc
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_basedesc_".csv"
	s file=##class(%File).%New(P)
	s filename = basedesc_".csv"
	d file.Open("NWS")
	d file.Write("描述,"_"别名,"_"上级节点")
	d file.WriteLine()
    
	s Num=0
	
	s TermID=""
	for
	{
		s TermID=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,TermID))
		q:TermID=""
		s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(TermID)),3)  //描述
		
		s MKBTLastLevel=$listGet($g(^CT.WDT.CDSS.TermD(TermID)),5)  //上级节点
		s LastLevelDesc=""
		
		s:MKBTLastLevel'="" LastLevelDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTLastLevel)),3)  //描述
		
		s Aliasstr=""
		s MKBProRowid = $o(^CT.WDT.CDSS.TermPropertyI("DescIndex",TermID," 别名",0))
		s MKBTPDSequence=""
		for  
		{	
			s MKBTPDSequence=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",MKBProRowid,MKBTPDSequence)) 
			q:MKBTPDSequence=""
			s MKBTPDRowId=0
			for 
			{
				s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",MKBProRowid,MKBTPDSequence,MKBTPDRowId)) 
				q:MKBTPDRowId="" 
				s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
				if (Aliasstr="")
				{
					s Aliasstr=MKBTPDDesc
				}
				else
				{
					s Aliasstr=Aliasstr_"#"_MKBTPDDesc	
				}
			}
		}
		
				
		d file.Write(MKBTDesc_",")
		d file.Write(Aliasstr_",")
		d file.Write(LastLevelDesc)
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator：钟荣枫
/// CreatDate: 2021-6-22
/// Description：通过别名或描述获取 termdr 
/// Table：CT_WDT_CDSS.Term
/// Input：desc
/// Return：TermDR
/// w ##class(web.CDSS.CMKB.Term).GetTermDRByDesc("120","急性肾损伤")
ClassMethod GetTermDRByDesc(base As %String, desc As %String) As %String
{
	q:((base="")||(desc="")) ""
	s TermDR=""
	s TermDR=$o(^CT.WDT.CDSS.TermI("DescIndex",base," "_$zconvert(desc,"U"),"")) 
	
	if (TermDR="")	//查询别名列表
	{
		s endflag=0
		//Index BaseIndex On MKBTBaseDR;
		s MKBTRowId=0
		for  
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId)) 
			q:((MKBTRowId="")||(endflag=1))
			s MKBProRowid = $o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",0))
			s MKBProDetailID = 0
			for 
			{
				s MKBProDetailID = $o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBProRowid,MKBProDetailID))
				q:((MKBProDetailID="")||(endflag=1))
				s DetailDesc = $lg($g(^CT.WDT.CDSS.TermProDetailD(MKBProDetailID)),3)
				if (desc=DetailDesc)
				{
					s endflag=1
					s TermDR=MKBTRowId
					q	
				}
			}
		}
	}
	q TermDR
}

/// Creator:丁亚男
/// CreatDate:2022-01-26
/// Description:百科不同状态的数据统计
/// Table:CT.WDT.CDSS.Term
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.Term).CountData("疾病")
ClassMethod CountData(BaseDesc)
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s basedr=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_$ZCONVERT(BaseDesc,"U"),0))
	if (basedr'="")
	{
		if ($d(^CT.WDT.CDSS.TermI("BaseIndex",basedr)))
		{
			s MKBTRowId=0
			for  
			{	
				s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",basedr,MKBTRowId)) q:MKBTRowId=""
				s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述 
				s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
				//编辑中0，已弃用1，已审核2，待审核3
				if (Status="")||(Status="0")
			 	{
				 	s Totalcount=Totalcount+1
				 	if ((BaseDesc="疾病")&$d(^User.DHCDSSDiseaseDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))
				 	{
				 		s Editcount=Editcount+1	
				 	}
				 	elseif((BaseDesc="检查")&$d(^User.DHCDSSExamDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))
				 	{
					 	s Editcount=Editcount+1	
					}
					elseif((BaseDesc="检验")&$d(^User.DHCDSSLabInspectionDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))
				 	{
					 	s Editcount=Editcount+1	
					}
					elseif((BaseDesc="手术")&$d(^User.DHCDSSOperationDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))
				 	{
					 	s Editcount=Editcount+1	
					}
					elseif((BaseDesc="护理")&$d(^User.DHCDSSNursingDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"))))
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
		}
	}
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

/// Creator:丁亚男	
/// CreatDate:2022-07-05
/// Description:计算中心词的知识量
/// Table:CT.WDT.CDSS.Term
/// Input:
/// Other:w ##class(web.CDSS.CMKB.Term).CalcuKnoNum()
ClassMethod CalcuKnoNum()
{
	s termconut=0
	s MKBTBRowId=0
	for
	{
		s MKBTBRowId=$O(^CT.WDT.CDSS.TermBaseD(MKBTBRowId))	q:MKBTBRowId=""
		
		s MKBTRowId=0
		for
		{
			s MKBTRowId=$O(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBRowId,MKBTRowId)) q:MKBTRowId=""
			
			s num=0
			s MKBTPRowId=0
			for
			{
				s MKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
				q:MKBTPRowId=""
				
				s MKBTPDRowId=0
				for
				{
					s MKBTPDRowId=$O(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
					q:MKBTPDRowId=""
					
					s num=num+1	
				}	
			}
			s obj = ##class(CT.WDT.CDSS.Term).%OpenId(MKBTRowId)
			s obj.MKBTDetailCount=num
			d obj.%Save()
			s termconut=termconut+1
		}
		
	}
	q termconut
}

}

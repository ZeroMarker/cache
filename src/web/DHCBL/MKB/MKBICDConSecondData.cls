Class web.DHCBL.MKB.MKBICDConSecondData Extends %RegisteredObject
{

/// Creator:张云越
/// CreatDate:2019-12-10
/// Description：各版本ICD左侧是否是最适ICD，如果是 输出Y
/// Input：termdr
/// Return:如果是最适icd则返回1，如果不是返回0
/// Other: w ##class(web.DHCBL.MKB.MKBICDConSecondData).FindTheBestMatchICD(15614)
ClassMethod FindTheBestMatchICD(termdr, source)
{
	s flag="N"
	s MKBICDConRowid=""
	for
	{
		s MKBICDConRowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,MKBICDConRowid)) //term对应的各版本ICD对照id
		q:MKBICDConRowid=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(MKBICDConRowid)),6) //来源标识
		continue:MKBICDDiaSource'[source
		if $d(^User.MKBICDContrastResultI("TermIndex",termdr,MKBICDConRowid)) 
		{
			s MKBInitialICD = $lg($g(^User.MKBICDContrastD(MKBICDConRowid)),17) //是否最优
			continue:MKBInitialICD'="Y"
			s MKBICDConRRowid=0
			for
			{
				s MKBICDConRRowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,MKBICDConRowid,MKBICDConRRowid))
				q:MKBICDConRRowid=""
				s ResultId=$lg($g(^User.MKBICDContrastD(MKBICDConRowid,"MKBICDContrastResult",MKBICDConRRowid)),2)
				if ResultId=""
				{
					s flag="Y"
					q
				}
			} 
		}
		q:flag="Y"
	}
	q flag
}

/// Creator:张云越
/// CreatDate:2019-12-10
/// Description：获取在左侧纵向展示栏展示的属性名称
/// Table：User.MKBTermBase
/// Input：术语库注册id
/// Return：成功返回属性名称的串 ,失败返回""
/// w ##class(web.DHCBL.MKB.MKBICDConSecondData).GetShowInLeftInfo("62")
ClassMethod GetShowInLeftInfo(BaseDr As %String) As %String
{
    s result=""
    s dataIndex=""  //组件dataIndex
	s header=""  //组件标题、列表表头
    if (BaseDr="") q ""
    if ($d(^User.MKBTermBasePropertyI("ShowIndex",BaseDr,"Y")))
    {
		s MKBTBPRowId=0
		for  
		{	s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("ShowIndex",BaseDr,"Y",MKBTBPRowId)) q:MKBTBPRowId="" 
			s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3)
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

/// Creator:张云越
/// CreatDate:2019-12-10
/// Description：获取属性内容列表的数据
/// Input：rowid, desc, base, rows, page, sortway,closeflag
/// Return:Json格式的字符串
/// Other:w ##class(web.DHCBL.MKB.MKBICDConSecondData).GetMyList("","",5,20,1,"orign","seeAll","526474")
ClassMethod GetMyList(rowid, desc, base, rows, page, sortway, closeflag As %String = "", source As %String) As %String
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
			s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
			s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
			s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			s MKBTSequence=$listGet($g(^User.MKBTermD(MKBTRowId)),8)  //顺序
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
			s MKBTDetailCount=$listGet($g(^User.MKBTermD(MKBTRowId)),10)
			s MKBICDInitialICD=..FindTheBestMatchICD(MKBTRowId,source)
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
					if ($d(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
					{
						s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
						s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
						s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
					} 
					s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
				} 
			}
			
			s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_""","_ExtendStr_"}"
		    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"
			//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"}"
			w mainstr

		}
		else
		{	
			if ($d(^User.MKBTermI("SeqIndex",base)))  //该术语库下有数据
			{
				if (sortway="originseq")
				{
					s MKBTSequence=0
					for  
					{	
						s MKBTSequence=$o(^User.MKBTermI("SeqIndex",base,MKBTSequence)) q:MKBTSequence=""
						s MKBTRowId=0
						for  
						{	
							s MKBTRowId=$o(^User.MKBTermI("SeqIndex",base,MKBTSequence,MKBTRowId)) q:MKBTRowId="" 
							s MKBICDInitialICD=..FindTheBestMatchICD(MKBTRowId,source)
							if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
							{
								
							}
							else
							{ 
								s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
								s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
								s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
								s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
								s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
								s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
								s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
								s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
								s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
								s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
								s MKBTDetailCount=$listGet($g(^User.MKBTermD(MKBTRowId)),10)
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
										if ($d(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
										{
											s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
											s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
											s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
										} 
										s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
										s:ExtendStr'="" ExtendStr=ExtendStr_","
										s ExtendStr=ExtendStr_thisStr
									} 
								}
							}
							
							if (desc'="")
							{
								s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowId)  
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
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"
										//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"}"
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
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"
									//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"}"
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
						s MKBTDetailCount=$o(^User.MKBTermI("DCountIndex",base,MKBTDetailCount),-1) q:MKBTDetailCount=""
						s MKBTRowId=0
						for  
						{	
							s MKBTRowId=$o(^User.MKBTermI("DCountIndex",base,MKBTDetailCount,MKBTRowId)) q:MKBTRowId="" 
							s MKBICDInitialICD=..FindTheBestMatchICD(MKBTRowId,source)
							if ((total+1<stpage)||(total+1>endpage))&&(desc="")   //如果不是当前页则只计数，不输出。
							{
								
							}
							else
							{ 
								s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
								s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
								s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
								s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
								s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
								s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
								s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
								s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
								s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
								
								s MKBTSequence=$listGet($g(^User.MKBTermD(MKBTRowId)),8)
								s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)

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
										if ($d(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc)))
										{
											s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTPDesc,0))
											s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
											s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
										} 
										s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
										s:ExtendStr'="" ExtendStr=ExtendStr_","
										s ExtendStr=ExtendStr_thisStr
									} 
								}
							}
						
							if (desc'="")
							{
								s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowId)  
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
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"
										//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"}"
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
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"   
									//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"}"
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

/// Creator:张云越
/// CreatDate:2019-12-10
/// Description:最优icd维护
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBICDConSecondData).InitialICDUpdate()
ClassMethod InitialICDUpdate(rowid As %String, MKBICDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBICDContrast).%OpenId(rowid)        ;先备份再更新
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		d obj.MKBICDConUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBICDConDate=UpdateDate
		s obj.MKBICDInitialICD=MKBICDInitialICD
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
			;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData","数据处理工厂-最优ICD维护",id,Diag,"U",eobj,bobj)
			;d eobj.%Close()
			;d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			
		}
		d obj.%Close()
		quit result			
	}
}

/// Creator：张云越
/// CreatDate: 2019-12-09
/// Description：通过结构化结果ID串和termdr找相同的诊断
/// Table：
/// Input：ids:结构化子表 MKBICD_ConResultID
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDConSecondData","GetSameStructResult","",15614,"","526474")
Query GetSameStructResult(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBICDConDesc,MKBICDConNumber,Result,MKBICDInitialICD,MKBICDDiaSource")
{
}

ClassMethod GetSameStructResultExecute(ByRef qHandle As %Binary, ids As %String, termdr As %String, supplement As %String, source As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(ids,termdr)
	if supplement'=""
	{
		s supplement=$zstrip(supplement,"<>W")
		if Result["]"
		{
			s str=$e(Result,1,*-1)
			s Result=str_",("_supplement_")]"
		}
		else
		{
			s Result=Result_"[("_supplement_")]"
		}
	}
	s Rowid=0
	for
	{
		s Rowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,Rowid)) //相同中心词的各版本ICD对照表记录
		q:Rowid=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(Rowid)),6) //来源标识
		continue:MKBICDDiaSource'[source
		d PrintOut
		s MKBICDConRRowid=0
		for
		{
			s MKBICDConRRowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,Rowid,MKBICDConRRowid)) //结构化子表childsub
			q:MKBICDConRRowid=""
			
			s MKBICDConTermDr=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),4)
			s MKBICDConSupplement=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),5) //补充诊断
			s MKBICDConResultID=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),2)
			
			s MKBICDStructResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr) //结构化描述串
			if MKBICDConSupplement'=""
			{
				s MKBICDConSupplement=$zstrip(MKBICDConSupplement,"<>W")
				if MKBICDConSupplement["]"
				{
					s str=$e(MKBICDConSupplement,1,*-1)
					s MKBICDStructResult=str_",("_MKBICDConSupplement_")]"
				}
				else
				{
					s MKBICDStructResult=MKBICDStructResult_"[("_MKBICDConSupplement_")]"
				}
			}
			if MKBICDStructResult=Result
			{
				d OutputRowCmb
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 

OutputRowCmb

    set Data=$lb(Rowid,MKBICDConDesc,MKBICDConNumber,Result,MKBICDInitialICD,MKBICDDiaSource)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
   
PrintOut
	s MKBICDConNumber=$lg($g(^User.MKBICDContrastD(Rowid)),4) //ICD编码
	s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3) //ICD描述
	s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(Rowid)),17) //是否最优
	s Sources=$lg($g(^User.MKBICDContrastD(Rowid)),6) //数据来源
	s sourcelen=$l(Sources,"&")
	s MKBICDDiaSource=""
	for i=1:1:sourcelen
	{
		s Source=$p(Sources,"&",i)
		continue:Source=""
		s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
		s:MKBICDDiaSource'="" MKBICDDiaSource=MKBICDDiaSource_"&"_SourceString
		s:MKBICDDiaSource="" MKBICDDiaSource=SourceString
	}
}

ClassMethod GetSameStructResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSameStructResultExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSameStructResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSameStructResultExecute ]
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

/// Creator：张云越
/// CreatDate: 2019-12-09
/// Description：通过中心词和结构化结果id串、补充诊断查找相同中心词的，但属性不同的
/// Table：
/// Input：ids:结构化子表 MKBICD_ConResultID
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDConSecondData","GetNotSameIdsButSameItem","","15614","","526474")
Query GetNotSameIdsButSameItem(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBICDConDesc,MKBICDConNumber,Result,MKBICDInitialICD")
{
}

ClassMethod GetNotSameIdsButSameItemExecute(ByRef qHandle As %Binary, ids As %String, termdr As %String, supplement As %String, source As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if ids'=""
	{
		k Det
		for i=1:1:$l(ids,",")
		{
			s subPro=$p(ids,",",i)
			
			s Pro=$p(subPro,":",1)
			s Detail=$p(subPro,":",2)
			for j=1:1:$l(Detail,"*")
			{
				continue:Detail=""
				s Det(Pro,$p(Detail,"*",j))=""      //把传进来的ids通过属性和属性内容的形式保存到Det数组中
			}
		}
		s detNum=0
		s pro=0
		for
		{
			s pro=$o(Det(pro))
			q:pro=""
			s det=0
			for
			{
				s det=$o(Det(pro,det))
				q:det=""
				s detNum=detNum+1               //detNum记录属性内容的个数
			}
		}
	}
	s Rowid=0
	for
	{
		s Rowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,Rowid)) //相同中心词的各版本ICD对照表记录
		q:Rowid=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(Rowid)),6) //来源标识
		continue:MKBICDDiaSource'[source
		
		s MKBICDConRRowid=0
		for
		{
			s MKBICDConRRowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,Rowid,MKBICDConRRowid)) //结构化子表childsub
			q:MKBICDConRRowid=""

			//s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
			s MKBICDConTermDr=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),4)
			s MKBICDConSupplement=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),5) //补充诊断
			s MKBICDConResultID=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),2)
			//s MKBICDInitialICD=$lg($g(^User.MKBStructuredDataD(Rowid)),18)
			s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr)
			if Result["["
			{
				s result=$p(Result,"[",2)
				s result=$p(result,"]",1)
				s resultlen=$l(result,",")
				
			}
			if MKBICDConSupplement'=""
			{
				s MKBICDConSupplement=$zstrip(MKBICDConSupplement,"<>W")
				if Result["]"
				{
					s str=$e(Result,1,*-1)
					s Result=str_",("_MKBICDConSupplement_")]"
				}
				else
				{
					s Result=Result_"[("_MKBICDConSupplement_")]"
				}
			}
			if ids'=""
			{
				s Existflag=0
				s NotExistflag=0
				continue:MKBICDConResultID=""
				for m=1:1:$l(MKBICDConResultID,",")
				{
					s subResPro=$p(MKBICDConResultID,",",m)
					s ResPro=$p(subResPro,":",1)
					s ResDetail=$p(subResPro,":",2)
					for n=1:1:$l(ResDetail,"*")
					{
						s resD=$p(ResDetail,"*",n)
						if $d(Det(ResPro,resD))
						{
							s Existflag=Existflag+1
							continue
						}
						s NotExistflag=NotExistflag+1
					}
				}
				if (supplement="")&(MKBICDConSupplement'="")
				{
					s NotExistflag=NotExistflag+1
				}
			
				if (Existflag=detNum)&(NotExistflag>0)&(MKBICDConSupplement[supplement)
				{
					;b
					d PrintOut
					d OutputRowCmb
				}
			}
			else
			{
				if Result["["
				{
					d PrintOut
					d OutputRowCmb
				}
			}
		}
		
	}
	
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(Rowid,MKBICDConDesc,MKBICDConNumber,Result,MKBICDInitialICD)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
PrintOut
	s MKBICDConNumber=$lg($g(^User.MKBICDContrastD(Rowid)),4) //ICD编码
	s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3) //ICD描述
	s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(Rowid)),17) //是否最优
}

ClassMethod GetNotSameIdsButSameItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNotSameIdsButSameItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNotSameIdsButSameItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNotSameIdsButSameItemExecute ]
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

}

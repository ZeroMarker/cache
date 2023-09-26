Class web.DHCBL.MKB.MKBOpeConSecondData Extends %RegisteredObject
{

/// Creator:张云越
/// CreatDate:2019-12-20
/// Description:最优icd维护
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBOpeConSecondData).InitialICDUpdate(7495,"Y")
ClassMethod InitialICDUpdate(rowid As %String, MKBICDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBOperationContrast).%OpenId(rowid)        ;先备份再更新
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
    	d obj.MKBOperationConUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBOperationConDate=UpdateDate
		s obj.MKBOperationInitialICD=MKBICDInitialICD
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
/// CreatDate: 2019-12-20
/// Description：通过中心词和结构化结果id串、补充诊断查找相同中心词的，但属性不同的
/// Table：
/// Input：ids:结构化子表 MKBICD_ConResultID
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOpeConSecondData","GetNotSameIdsButSameItem","","1438820","","D")
Query GetNotSameIdsButSameItem(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationDiaSource,MKBOperationInitialICD")
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
		s Rowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid)) //相同中心词的各版本手术对照表记录
		q:Rowid=""
		s MKBOperationInitialICD=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //来源标识
		continue:MKBOperationInitialICD'[source
		
		s MKBOpeConRRowid=0
		for
		{
			s MKBOpeConRRowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid,MKBOpeConRRowid)) //结构化子表childsub
			q:MKBOpeConRRowid=""


			s MKBOpeConTermDr=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),4)
			s MKBOpeConSupplement=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),5) //补充诊断
			s MKBOpeConResultID=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),2)

			s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBOpeConResultID,MKBOpeConTermDr)
			if Result["["
			{
				s result=$p(Result,"[",2)
				s result=$p(result,"]",1)
				s resultlen=$l(result,",")
				
			}
			if MKBOpeConSupplement'=""
			{
				s MKBOpeConSupplement=$zstrip(MKBOpeConSupplement,"<>W")
				if Result["]"
				{
					s str=$e(Result,1,*-1)
					s Result=str_",("_MKBOpeConSupplement_")]"
				}
				else
				{
					s Result=Result_"[("_MKBOpeConSupplement_")]"
				}
			}
			if ids'=""
			{
				s Existflag=0
				s NotExistflag=0
				continue:MKBOpeConResultID=""
				for m=1:1:$l(MKBOpeConResultID,",")
				{
					s subResPro=$p(MKBOpeConResultID,",",m)
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
				if (supplement="")&(MKBOpeConSupplement'="")
				{
					s NotExistflag=NotExistflag+1
				}
			
				if (Existflag=detNum)&(NotExistflag>0)&(MKBOpeConSupplement[supplement)
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
    set Data=$lb(Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationDiaSource,MKBOperationInitialICD)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
PrintOut
	s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(Rowid)),4) //ICD编码
	s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(Rowid)),3) //ICD描述
	s MKBOperationInitialICD=$lg($g(^User.MKBOperationContrastD(Rowid)),18) //是否最优
	s Sources=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //数据来源
	s sourcelen=$l(Sources,"&")
	s MKBOperationDiaSource=""
	for i=1:1:sourcelen
	{
		s Source=$p(Sources,"&",i)
		continue:Source=""
		//s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
		s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
		s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
		s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
	}
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

/// Creator：张云越
/// CreatDate: 2019-12-20
/// Description：通过结构化结果ID串和termdr找相同的诊断
/// Table：
/// Input：ids:结构化子表 MKBICD_ConResultID
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOpeConSecondData","GetSameStructResult","8842091:1864201",1438820,"","D")
Query GetSameStructResult(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationDiaSource,MKBOperationInitialICD")
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
		s Rowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid)) //相同中心词的各版本手术对照表记录
		q:Rowid=""
		s MKBOperationDiaSource=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //来源标识
		continue:MKBOperationDiaSource'[source
		d PrintOut
		s MKBOpeConRRowid=0
		for
		{
			s MKBOpeConRRowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid,MKBOpeConRRowid)) //结构化子表childsub
			q:MKBOpeConRRowid=""
			
			s MKBOpeConTermDr=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),4)
			s MKBOpeConSupplement=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),5) //补充诊断
			s MKBOpeConResultID=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),2)
			
			s MKBOpeStructResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBOpeConResultID,MKBOpeConTermDr) //结构化描述串
			if MKBOpeConSupplement'=""
			{
				s MKBOpeConSupplement=$zstrip(MKBOpeConSupplement,"<>W")
				if MKBOpeConSupplement["]"
				{
					s str=$e(MKBOpeConSupplement,1,*-1)
					s MKBOpeStructResult=str_",("_MKBOpeConSupplement_")]"
				}
				else
				{
					s MKBOpeStructResult=MKBOpeStructResult_"[("_MKBOpeConSupplement_")]"
				}
			}
			if MKBOpeStructResult=Result
			{
				d OutputRowCmb
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 

OutputRowCmb

    set Data=$lb(Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationDiaSource,MKBOperationInitialICD)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
   
PrintOut
	s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(Rowid)),4) //ICD编码
	s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(Rowid)),3) //ICD描述
	s MKBOperationInitialICD=$lg($g(^User.MKBOperationContrastD(Rowid)),18) //是否最优
	s Sources=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //数据来源
	s sourcelen=$l(Sources,"&")
	s MKBOperationDiaSource=""
	for i=1:1:sourcelen
	{
		s Source=$p(Sources,"&",i)
		continue:Source=""
		//s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
		s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
		s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
		s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
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

/// Creator:张云越
/// CreatDate:2019-12-19
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
/// CreatDate:2019-12-19
/// Description：各版本手术对照左侧是否是最适ICD，如果是 输出Y
/// Input：termdr
/// Return:如果是最适icd则返回1，如果不是返回0
/// Other: w ##class(web.DHCBL.MKB.MKBOpeConSecondData).FindTheBestMatchICD(1438820,"D")
ClassMethod FindTheBestMatchICD(termdr, source)
{
	s flag="N"
	s MKBOpeConRowid=""
	for
	{
		s MKBOpeConRowid=$o(^User.MKBOperationResultI("TermIndex",termdr,MKBOpeConRowid)) //term对应的各版本ICD对照id
		q:MKBOpeConRowid=""
		s MKBOperationDiaSource=$lg($g(^User.MKBOperationContrastD(MKBOpeConRowid)),6) //来源标识
		continue:MKBOperationDiaSource'[source
		if $d(^User.MKBOperationResultI("TermIndex",termdr,MKBOpeConRowid)) 
		{
			s MKBInitialICD = $lg($g(^User.MKBOperationContrastD(MKBOpeConRowid)),18) //是否最优
			continue:MKBInitialICD'="Y"
			s MKBOpeConRRowid=0
			s flag="Y"
			/*for
			{
				s MKBOpeConRRowid=$o(^User.MKBOperationResultI("TermIndex",termdr,MKBOpeConRowid,MKBOpeConRRowid))
				q:MKBOpeConRRowid=""
				s ResultId=$lg($g(^User.MKBOperationContrastD(MKBOpeConRowid,"MKBOperationResult",MKBOpeConRRowid)),2)
				if ResultId=""
				{
					s flag="Y"
					q
				}
			} */
		}
		q:flag="Y"
	}
	q flag
}

/// Creator:张云越
/// CreatDate:2019-12-19
/// Description：获取属性内容列表的数据
/// Input：rowid, desc, base, rows, page, sortway,closeflag
/// Return:Json格式的字符串
/// Other:w ##class(web.DHCBL.MKB.MKBOpeConSecondData).GetMyList("","",100,20,1,"orign","seeAll","D")
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
			s MKBOperationInitialICD=..FindTheBestMatchICD(MKBTRowId,source)
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
			
			s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_""","_ExtendStr_"}"
		    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"""}"
			//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBOperationInitialICD"":"""MKBOperationInitialICD"}"
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
							s MKBOperationInitialICD=..FindTheBestMatchICD(MKBTRowId,source)
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
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"""}"
										//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBOperationInitialICD"":"""MKBOperationInitialICD"}"
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
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"""}"
									//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"}"
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
							s MKBOperationInitialICD=..FindTheBestMatchICD(MKBTRowId,source)
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
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"""}"
										//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"}"
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
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"""}"   
									//s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_"}"
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

}

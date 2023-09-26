/// Description:ICD诊断结构化处理
/// Creator：李得原
/// Date： 2019-01-16
Class web.DHCBL.MKB.MKBICDContrast Extends %RegisteredObject
{

/// Creator：张云越
/// CreatDate: 2019-12-12
/// Description：通过中心词和结构化结果id串、补充诊断查找相同中心词的，但属性不同的
/// Table：
/// Input：ids:结构化子表 MKBICD_ConResultID
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDContrast","GetNotSameIdsButSameItem","","15614","","526474")
Query GetNotSameIdsButSameItem(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBICDDesc,MKBICDNumber,Result,MKBICDInitialICD,MKBICDCode,MKBICDExtendNumber,MKBICDDiaSource,MKBICDStatus,MKBICDResultRelation,MKBICDType,MKBICDOption,MKBICDCenterWordID,MKBICDRemark,MKBICDConSegmentation,MKBICDConDate,MKBICDConUpdateUser,MKBTPDDesc,MKBICDCenterWord")
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
			s Result=##class(web.DHCBL.MKB.MKBICDContrast).GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr)
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
					s MKBICDCode=$lg($g(^User.MKBICDContrastD(Rowid)),2) //ICD诊断代码
					s MKBICDDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3) //ICD描述
					s MKBICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBICDDesc) //ICD描述
					s MKBICDDescCaption=$zconvert(MKBICDDesc,"U")
					s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(Rowid)),17) //是否最优
					s MKBICDNumber=$lg($g(^User.MKBICDContrastD(Rowid)),4) //ICD主要编码
					s MKBICDStatus=$lg($g(^User.MKBICDContrastD(Rowid)),13) //是否处理
					s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(Rowid)),19) //结构化结果关系
					s MKBICDExtendNumber=$lg($g(^User.MKBICDContrastD(Rowid)),5) //扩展编码
					s MKBICDType=$lg($g(^User.MKBICDContrastD(Rowid)),7) //类别
					s MKBICDOption=$lg($g(^User.MKBICDContrastD(Rowid)),8) //录入选项
					s MKBICDCenterWordID=$lg($g(^User.MKBICDContrastD(Rowid)),9) //参考中心词id
					s MKBICDRemark=$lg($g(^User.MKBICDContrastD(Rowid)),11) //标记(可匹配)
					s MKBICDConSegmentation=$lg($g(^User.MKBICDContrastD(Rowid)),12) //分词
					s MKBICDConDate=$lg($g(^User.MKBICDContrastD(Rowid)),14) //操作时间
					s MKBICDConUpdateUsers=$lg($g(^User.MKBICDContrastD(Rowid)),15) //操作人
					s:MKBICDConUpdateUsers'="" MKBICDConUpdateUser=$p($g(^SSU("SSUSR",MKBICDConUpdateUsers)),"^",2)
					s:MKBICDConUpdateUsers="" MKBICDConUpdateUser=""

					s Result=""
					s sequence=0
					for
					{
						s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence))
						q:sequence=""
						s MKBICDRRowid=0
						for
						{
							s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence,MKBICDRRowid))
							q:MKBICDRRowid=""
							s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
							s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
							s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
							s MKBICDSupplement=$lg(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid),5)
							if MKBICDSupplement'=""
							{
								if SResult["]"
								{
									s str=$e(SResult,1,*-1)
									s SResult=str_",("_MKBICDSupplement_")]"
								}
								else
								{
									s SResult=SResult_"[("_MKBICDSupplement_")]"
								}
							}
							s:Result'="" Result=Result_"<br/>"_SResult
							s:Result="" Result=SResult
						}
					}
					
					s MKBICDTermDr=$lg($g(^User.MKBICDContrastD(Rowid)),10) 
					if MKBICDTermDr'=""
					{
						s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
						s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
						s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
					}
					else
					{
						s MKBTPDDesc="" //中文释义
						s MKBTDesc=""
					}
					
					//s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDDesc)
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
					
					s MKBICDCenterWord=""                         ;通过中心词id获取参考中心词描述
					if MKBICDCenterWordID'=""
					{
						s WordCount=$l(MKBICDCenterWordID,",")
						for i=1:1:WordCount
						{
							s WordEach=$p(MKBICDCenterWordID,",",i)
							s MKBICDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
							s:MKBICDCenterWord'="" MKBICDCenterWord=MKBICDCenterWord_","_MKBICDWord
							s:MKBICDCenterWord="" MKBICDCenterWord=MKBICDWord
						}	
					}
					d OutputRowCmb
				}
			}
			else
			{
				if Result["["
				{
					s MKBICDCode=$lg($g(^User.MKBICDContrastD(Rowid)),2) //ICD诊断代码
					s MKBICDDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3) //ICD描述
					s MKBICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBICDDesc) //ICD描述
					s MKBICDDescCaption=$zconvert(MKBICDDesc,"U")
					s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(Rowid)),17) //是否最优
					s MKBICDNumber=$lg($g(^User.MKBICDContrastD(Rowid)),4) //ICD主要编码
					s MKBICDStatus=$lg($g(^User.MKBICDContrastD(Rowid)),13) //是否处理
					s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(Rowid)),19) //结构化结果关系
					s MKBICDExtendNumber=$lg($g(^User.MKBICDContrastD(Rowid)),5) //扩展编码
					s MKBICDType=$lg($g(^User.MKBICDContrastD(Rowid)),7) //类别
					s MKBICDOption=$lg($g(^User.MKBICDContrastD(Rowid)),8) //录入选项
					s MKBICDCenterWordID=$lg($g(^User.MKBICDContrastD(Rowid)),9) //参考中心词id
					s MKBICDRemark=$lg($g(^User.MKBICDContrastD(Rowid)),11) //标记(可匹配)
					s MKBICDConSegmentation=$lg($g(^User.MKBICDContrastD(Rowid)),12) //分词
					s MKBICDConDate=$lg($g(^User.MKBICDContrastD(Rowid)),14) //操作时间
					s MKBICDConUpdateUsers=$lg($g(^User.MKBICDContrastD(Rowid)),15) //操作人
					s:MKBICDConUpdateUsers'="" MKBICDConUpdateUser=$p($g(^SSU("SSUSR",MKBICDConUpdateUsers)),"^",2)
					s:MKBICDConUpdateUsers="" MKBICDConUpdateUser=""

					s Result=""
					s sequence=0
					for
					{
						s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence))
						q:sequence=""
						s MKBICDRRowid=0
						for
						{
							s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence,MKBICDRRowid))
							q:MKBICDRRowid=""
							s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
							s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
							s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
							s MKBICDSupplement=$lg(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid),5)
							if MKBICDSupplement'=""
							{
								if SResult["]"
								{
									s str=$e(SResult,1,*-1)
									s SResult=str_",("_MKBICDSupplement_")]"
								}
								else
								{
									s SResult=SResult_"[("_MKBICDSupplement_")]"
								}
							}
							s:Result'="" Result=Result_"<br/>"_SResult
							s:Result="" Result=SResult
						}
					}
					
					s MKBICDTermDr=$lg($g(^User.MKBICDContrastD(Rowid)),10) 
					if MKBICDTermDr'=""
					{
						s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
						s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
						s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
					}
					else
					{
						s MKBTPDDesc="" //中文释义
						s MKBTDesc=""
					}
					
					
					//s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDDesc)
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
					
					s MKBICDCenterWord=""                         ;通过中心词id获取参考中心词描述
					if MKBICDCenterWordID'=""
					{
						s WordCount=$l(MKBICDCenterWordID,",")
						for i=1:1:WordCount
						{
							s WordEach=$p(MKBICDCenterWordID,",",i)
							s MKBICDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
							s:MKBICDCenterWord'="" MKBICDCenterWord=MKBICDCenterWord_","_MKBICDWord
							s:MKBICDCenterWord="" MKBICDCenterWord=MKBICDWord
						}	
					}
					d OutputRowCmb
				}
			}
		}
		
	}
	
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(Rowid,MKBICDDesc,MKBICDNumber,Result,MKBICDInitialICD,MKBICDCode,MKBICDExtendNumber,MKBICDDiaSource,MKBICDStatus,MKBICDResultRelation,MKBICDType,MKBICDOption,MKBICDCenterWordID,MKBICDRemark,MKBICDConSegmentation,MKBICDConDate,MKBICDConUpdateUser,MKBTPDDesc,MKBICDCenterWord)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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
/// CreatDate: 2019-12-12
/// Description：通过ICD版本描述获得版本id
/// Table：
/// Input：
/// Return：
/// Other:w ##class(web.DHCBL.MKB.MKBICDContrast).GetICDEdition1("ICD-10 v6.01版")
ClassMethod GetICDEdition1(desc As %String) As %String
{
	q:desc="" ""
	s repid=$I(^CacheTemp)
	s ind=1
	s ICDEdition=$zconvert(desc,"U")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	s MKBTRowid=""
	s:MKBTBRowid'="" MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_ICDEdition,0))
	q MKBTRowid
}

/// Creator：张云越
/// CreatDate: 2019-12-13
/// Description：通过ICD版本id获得版本desc
/// Table：
/// Input：
/// Return：
/// Other:w ##class(web.DHCBL.MKB.MKBICDContrast).GetICDEdition2("526474")
ClassMethod GetICDEdition2(id As %String) As %String
{
	q:id="" ""
	s repid=$I(^CacheTemp)
	s ind=1
	s Desc=$lg($g(^User.MKBTermD(id)),3)
	q Desc
}

/// Creator：张云越
/// CreatDate: 2019-12-11
/// Description：通过结构化结果ID串和termdr找相同的诊断(版本控制)
/// Table：
/// Input：ids:结构化子表 MKBICD_ConResultID
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDContrast","GetSameStructResult","4778:10241",14853,"","526477")
Query GetSameStructResult(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBICDDesc,MKBICDNumber,Result,MKBICDInitialICD,MKBICDCode,MKBICDExtendNumber,MKBICDDiaSource,MKBICDStatus,MKBICDResultRelation,MKBICDType,MKBICDOption,MKBICDCenterWordID,MKBICDRemark,MKBICDConSegmentation,MKBICDConDate,MKBICDConUpdateUser,MKBTPDDesc,MKBICDCenterWord")
{
}

ClassMethod GetSameStructResultExecute(ByRef qHandle As %Binary, ids As %String, termdr As %String, supplement As %String, source As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s MKBICDStructResult=##class(web.DHCBL.MKB.MKBICDContrast).GetChiForNewSeqStrucIDs(ids,termdr)
	if supplement'=""
	{
		s supplement=$zstrip(supplement,"<>W")
		if MKBICDStructResult["]"
		{
			s str=$e(MKBICDStructResult,1,*-1)
			s MKBICDStructResult=str_",("_supplement_")]"
		}
		else
		{
			s MKBICDStructResult=MKBICDStructResult_"[("_supplement_")]"
		}
	}
	s Rowid=0
	for
	{
		s Rowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,Rowid)) //相同中心词的各版本ICD对照表记录
		q:Rowid=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(Rowid)),6) //来源标识
		continue:MKBICDDiaSource'[source
		s MKBICDCode=$lg($g(^User.MKBICDContrastD(Rowid)),2) //ICD诊断代码
		s MKBICDDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3) //ICD描述
		s MKBICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBICDDesc) //ICD描述
		s MKBICDDescCaption=$zconvert(MKBICDDesc,"U")
		s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(Rowid)),17) //是否最优
		s MKBICDNumber=$lg($g(^User.MKBICDContrastD(Rowid)),4) //ICD主要编码
		s MKBICDStatus=$lg($g(^User.MKBICDContrastD(Rowid)),13) //是否处理
		s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(Rowid)),19) //结构化结果关系
		s MKBICDExtendNumber=$lg($g(^User.MKBICDContrastD(Rowid)),5) //扩展编码
		s MKBICDType=$lg($g(^User.MKBICDContrastD(Rowid)),7) //类别
		s MKBICDOption=$lg($g(^User.MKBICDContrastD(Rowid)),8) //录入选项
		s MKBICDCenterWordID=$lg($g(^User.MKBICDContrastD(Rowid)),9) //参考中心词id
		s MKBICDRemark=$lg($g(^User.MKBICDContrastD(Rowid)),11) //标记(可匹配)
		s MKBICDConSegmentation=$lg($g(^User.MKBICDContrastD(Rowid)),12) //分词
		s MKBICDConDate=$lg($g(^User.MKBICDContrastD(Rowid)),14) //操作时间
		s MKBICDConUpdateUsers=$lg($g(^User.MKBICDContrastD(Rowid)),15) //操作人
		s:MKBICDConUpdateUsers'="" MKBICDConUpdateUser=$p($g(^SSU("SSUSR",MKBICDConUpdateUsers)),"^",2)
		s:MKBICDConUpdateUsers="" MKBICDConUpdateUser=""

		s Result=""
		s sequence=0
		for
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence))
			q:sequence=""
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence,MKBICDRRowid))
				q:MKBICDRRowid=""
				s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
				s MKBICDSupplement=$lg(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDRRowid),5)
				if MKBICDSupplement'=""
				{
					if SResult["]"
					{
						s str=$e(SResult,1,*-1)
						s SResult=str_",("_MKBICDSupplement_")]"
					}
					else
					{
						s SResult=SResult_"[("_MKBICDSupplement_")]"
					}
				}
				s:Result'="" Result=Result_"<br/>"_SResult
				s:Result="" Result=SResult
			}
		}
		
		s MKBICDTermDr=$lg($g(^User.MKBICDContrastD(Rowid)),10) 
		if MKBICDTermDr'=""
		{
			s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
			s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
		}
		else
		{
			s MKBTPDDesc="" //中文释义
			s MKBTDesc=""
		}
		
		
		//s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDDesc)
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
		
		s MKBICDCenterWord=""                         ;通过中心词id获取参考中心词描述
		if MKBICDCenterWordID'=""
		{
			s WordCount=$l(MKBICDCenterWordID,",")
			for i=1:1:WordCount
			{
				s WordEach=$p(MKBICDCenterWordID,",",i)
				s MKBICDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
				s:MKBICDCenterWord'="" MKBICDCenterWord=MKBICDCenterWord_","_MKBICDWord
				s:MKBICDCenterWord="" MKBICDCenterWord=MKBICDWord
			}	
		}
		s Result=""
		s sequence=0
		for
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence))
			q:sequence=""
			s MKBICDConRRowid=0
			for
			{
				s MKBICDConRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",Rowid,sequence,MKBICDConRRowid))
				q:MKBICDConRRowid=""
				s MKBICDConTermDr=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),4)
				s MKBICDConSupplement=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),5) //补充诊断
				s MKBICDConResultID=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),2)
				s SResult=##class(web.DHCBL.MKB.MKBICDContrast).GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr)
				
				if MKBICDConSupplement'=""
				{
					s MKBICDConSupplement=$zstrip(MKBICDConSupplement,"<>W")
					if MKBICDConSupplement["]"
					{
						s str=$e(MKBICDConSupplement,1,*-1)
						s SResult=str_",("_MKBICDConSupplement_")]"
					}
					else
					{
						s SResult=SResult_"[("_MKBICDConSupplement_")]"
					}
				}
				s:Result'="" Result=Result_"<br/>"_SResult
				s:Result="" Result=SResult
			}
		}
		if Result[MKBICDStructResult
		{
			d OutputRowCmb
		}
		/*s MKBICDConRRowid=0
		for
		{
			s MKBICDConRRowid=$o(^User.MKBICDContrastResultI("TermIndex",termdr,Rowid,MKBICDConRRowid)) //结构化子表childsub
			q:MKBICDConRRowid=""

			
			s MKBICDConTermDr=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),4)
			s MKBICDConSupplement=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),5) //补充诊断
			s MKBICDConResultID=$lg($g(^User.MKBICDContrastD(Rowid,"MKBICDContrastResult",MKBICDConRRowid)),2)
			
			s MKBICDStructResult=##class(web.DHCBL.MKB.MKBICDContrast).GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr)
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
		}*/
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 

OutputRowCmb

    set Data=$lb(Rowid,MKBICDDesc,MKBICDNumber,Result,MKBICDInitialICD,MKBICDCode,MKBICDExtendNumber,MKBICDDiaSource,MKBICDStatus,MKBICDResultRelation,MKBICDType,MKBICDOption,MKBICDCenterWordID,MKBICDRemark,MKBICDConSegmentation,MKBICDConDate,MKBICDConUpdateUser,MKBTPDDesc,MKBICDCenterWord)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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
/// CreatDate:2019-12-10
/// Description：根据父表id，获取父表和结构化结果子表信息(跳转获取数据方法)
/// Table：User.MKBICDContrastResult
/// Input：父表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).GetRowData(1)
ClassMethod GetRowData(id As %String)
{
	q:id="" ""
	s MKBICDConRowid=$g(id)
	s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(MKBICDConRowid)),3) //ICD描述	
	s MKBICDConNumber=$lg($g(^User.MKBICDContrastD(MKBICDConRowid)),4) //ICD主要编码	
	s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDConRowid,0))
	if sequence'=""
	{
		s MKBICDConRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDConRowid,sequence,0)) //结构化子表childsub
		if MKBICDConRRowid'=""
		{
			s MKBICDConResultID=$lg($g(^User.MKBICDContrastD(MKBICDConRowid,"MKBICDContrastResult",MKBICDConRRowid)),2)  //获取结构化结果串
			s MKBICDConTermDr=$lg($g(^User.MKBICDContrastD(MKBICDConRowid,"MKBICDContrastResult",MKBICDConRRowid)),4) //获取结构化结果Termdr
			
			s Result=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr)
			s MKBICDConSupplement=$lg(^User.MKBICDContrastD(MKBICDConRowid,"MKBICDContrastResult",MKBICDConRRowid),5)
			if MKBICDConSupplement'=""
			{
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
		}
		else
		{
			s MKBICDConResultID=""
			s MKBICDConTermDr=""
			s MKBICDConSupplement=""
			s Result=""
		}
	}
	else
	{
		s MKBICDConResultID=""
		s MKBICDConTermDr=""
		s MKBICDConSupplement=""
		s Result=""
	}
	s thisStr="{""MKBICDConRowid"":"""_MKBICDConRowid_""",""MKBICDConDesc"":"""_MKBICDConDesc_""",""MKBICDConNumber"":"""_MKBICDConNumber_""",""Result"":"""_Result_""",""MKBICDConResultID"":"""_MKBICDConResultID_""",""MKBICDConTermDr"":"""_MKBICDConTermDr_""",""MKBICDConSupplement"":"""_MKBICDConSupplement_"""}"
	q thisStr
}

/// Lixin
/// 通过输入的条件检索国际码
/// tip:编码/中文  desc:检索条件
/// return :TermId&%TermId
/// w ##class(web.DHCBL.MKB.MKBICDContrast).GetNationICD(编码,"S")
ClassMethod GetNationICD(tip, desc)
{
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0))
	s result=""
	if ((tip'="")||(desc'=""))
	{
		s desc = ##class(web.DHCBL.MKB.BDPMKBIndex).Filter(desc)
		s Ids=0
		
		for
		{
			s Ids = $O(^User.BDPMKBIndexI("DescIndex"," "_$ZCONVERT(desc,"U"),Ids))	
			q:Ids=""
			
			if (tip="编码")
			{
				continue:Ids["D"
				continue:($D(^User.MKBTermI("BaseIndex",MKBTBRowId,Ids))=0)	
			
				s:result'="" result=result_"&%"_Ids
				s:result="" result=Ids
			}
			else
			{
				continue:Ids'["D"
				s TermId=$P(Ids,"D",1)
				continue:($D(^User.MKBTermI("BaseIndex",MKBTBRowId,TermId))=0)	
				
				s:result'="" result=result_"&%"_TermId
				s:result="" result=TermId	
			}
		}	
	}
	q result
}

/// Creator:李得原
/// CreatDate:2019-02-15
/// Description:获取诊断数据
/// Table:
/// Input:
/// Return:查询数据
/// Other:w ##class(web.DHCBL.MKB.MKBICDContrast).GetNewList("","","","A","3","526474","100","1")
ClassMethod GetNewList(icd As %String, diag As %String, status As %String, match As %String, sort As %String, source As %String, centerword As %String, rows As %String, page As %String)
{
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s DiagLen=$l(diag)  //描述长度
	if (DiagLen>10)   //如果描述长度大于10，截取前十个   
	{
		s diag=$e(diag,1,10)
	}
	s:diag'="" diag=$ZCONVERT(diag,"U") //转换成大写
	s:diag'="" diag=$zstrip(diag,"<>W")
	s:icd'="" icd=$ZCONVERT(icd,"U")    //转换成大写
	s:icd'="" icd=$zstrip(icd,"<>W")
	s:status'="" status=$ZCONVERT(status,"U")  //转换成大写
	s:centerword'="" centerword=$ZCONVERT(centerword,"U")
	
	s User=%session.Get("LOGON.USERID")
	k Sort
	
	s:source="" SourceOriginal=""
	s total=0
	s jsonstr=""
	w "{""rows"":["
	
	k dt		//描述数组
	k lt		//icd数组
	k arr		//两者的交集
	s Diag=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(diag)
	s ICD=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(icd)
	if (Diag'="")
	{
		if (source'="")	//选择了版本
		{
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$O(^User.MKBStructIndexI("DescIndex","ICD"_source," "_$ZCONVERT(Diag,"U"),MKBICDRowid))
				q:MKBICDRowid=""
				s dt(MKBICDRowid)=""
			}
		}
		else
		{
			s source=""
			for
			{
				s source=$O(^User.MKBStructIndexI("DescIndex",source))
				q:source=""
				continue:(source'["ICD")
				s MKBICDRowid=0
				for
				{
					s MKBICDRowid=$O(^User.MKBStructIndexI("DescIndex",source," "_$ZCONVERT(Diag,"U"),MKBICDRowid))
					q:MKBICDRowid=""
					s dt(MKBICDRowid)=""	
				}
			
			}
		}


	}
	if (ICD'="")
	{
		if (source'="")	//选择了版本
		{
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$O(^User.MKBStructIndexI("DescIndex","ICD"_source," "_$ZCONVERT(ICD,"U"),MKBICDRowid))
				q:MKBICDRowid=""
				s lt(MKBICDRowid)=""
			}
		}
		else
		{
			s source=""
			for
			{
				s source=$O(^User.MKBStructIndexI("DescIndex",source))
				q:source=""
				continue:(source'["ICD")
				s MKBICDRowid=0
				for
				{
					s MKBICDRowid=$O(^User.MKBStructIndexI("DescIndex",source," "_$ZCONVERT(ICD,"U"),MKBICDRowid))
					q:MKBICDRowid=""
					s lt(MKBICDRowid)=""	
				}
			
			}
		}
	}
	if ($D(dt)&&$D(lt)) //diag'="" icd'=""
	{
		s MKBICDRowid=0
		for
		{
			s MKBICDRowid=$O(lt(MKBICDRowid))
			q:MKBICDRowid=""
			continue:$D(dt(MKBICDRowid))=0
			s arr(MKBICDRowid)=""	
		}	

	}
	elseif ($D(dt)) //diag'="" icd=""
	{
		if (ICD'="")
		{
			s arr=""
		}
		else
		{
			merge arr=dt
		}
	}
	elseif ($D(lt)) //diag="" icd'=""
	{
		if (Diag'="")
		{
			s arr=""
		}
		else
		{
			merge arr=lt	
		}
	}
	else //diag="" icd=""
	{
		if ((diag="")&&(icd=""))		//描述和icd都为空
		{
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$O(^User.MKBICDContrastD(MKBICDRowid))	
				q:MKBICDRowid=""
				s arr(MKBICDRowid)=""
			}
		}
		else
		{
			s arr=""	
		}
	}
	k dt
	k lt
	s MKBICDRowid=""
	for
	{
		s MKBICDRowid=$o(arr(MKBICDRowid))
		q:MKBICDRowid=""
		
		if match="B"    //已匹配结构化诊断
		{
			continue:$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",""))<=0
			continue:'$d(^User.MKBICDContrastD(MKBICDRowid))
		}
		elseif match="D"    //未匹配结构化诊断
		{
			continue:$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",""))>0
			continue:'$d(^User.MKBICDContrastD(MKBICDRowid))
		}
		else
		{
			continue:'$d(^User.MKBICDContrastD(MKBICDRowid))
		}
		s MKBICDCode=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),2)
		s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
		s MKBICDDescCaption=$zconvert(MKBICDDesc,"U")
		s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
		if MKBICDNumber=""
		{
			s Number="zzzzz"
		}
		else
		{
			s Number=MKBICDNumber
		}
		s TermDesc=""
		s centerflag=1
		s:(centerword'="") centerflag=0
		s sequence=""
		for
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
			q:sequence=""
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
				q:MKBICDRRowid=""
				s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",MKBICDResultTermdr," 别名",""))
				s TermDesc=$lg($g(^User.MKBTermD(MKBICDResultTermdr)),3)
				if (($zconvert(TermDesc,"U")[centerword)&&(centerword'=""))
				{
					s centerflag=1	
				}
				if (centerflag=0)	//直接用中心词描述匹配时，匹配不了时，取用中心词的展示名
				{
					if ($d(^User.MKBTermProDetailI("SeqIndex",MKBProRowid))>0)	//别名列表中有数据
					{
						s MKBTPDSequence=$o(^User.MKBTermProDetailI("SeqIndex",MKBProRowid,"")) 
						if (MKBTPDSequence'="")
						{
							s MKBTPDRowId=$o(^User.MKBTermProDetailI("SeqIndex",MKBProRowid,MKBTPDSequence,"")) 
							s MKBTPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowId)),3)	//取到展示名
							if (TermDesc="")
							{
								s TermDesc=MKBTPDDesc
							}
							else
							{
								s TermDesc=TermDesc_","_MKBTPDDesc	
							}
							if (($zconvert(MKBTPDDesc,"U")[centerword)&&(centerword'=""))
							{
								s centerflag=1	
							}
							
						}
					}
				}


			}
		}
		
		continue:centerflag=0	
		s:TermDesc="" TermDesc="ZZZZZZZZZZZZZZZZZZ"
		s MKBICDStatus=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),13)
		s PINYINDesc=""
		if diag'="" s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDDesc)
		s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		if ((MKBICDNumber[icd)&&((MKBICDDescCaption[diag)||(PINYINDesc[diag))&&(MKBICDStatus[status)&&(Sources[source))
		{
			//s (MKBTPDDesc,MKBTDesc)=""
			if (sort=0)    //按icd编码排序
			{
				s Sort(User,"ICDNumber",Number,MKBICDRowid)=""
			}
			elseif (sort=1)       //按icd描述排序
			{
				s Sort(User,"ICDDesc",MKBICDDesc,MKBICDRowid)=""
			}
			elseif (sort=2) 
			{
				s Sort(User,"RowID",MKBICDDesc,MKBICDRowid)=""
			}
			elseif (sort=3) 
			{
				//获取结构化结果
				s Result=""
				s sequence=0
				for
				{
					s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
					q:sequence=""
					s MKBICDRRowid=0
					for
					{
						s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
						q:MKBICDRRowid=""
						s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
						s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
						s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
						s MKBICDSupplement=$lg(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid),5)
						if MKBICDSupplement'=""
						{
							if SResult["]"
							{
								s str=$e(SResult,1,*-1)
								s SResult=str_",("_MKBICDSupplement_")]"
							}
							else
							{
								s SResult=SResult_"[("_MKBICDSupplement_")]"
							}
						}
						s:Result'="" Result=Result_"<br/>"_SResult
						s:Result="" Result=SResult
					}
				}
				s:Result="" Result=" "

				s Sort(User,"Result",Result,MKBICDRowid)=""
			}
		}
		
	}
	k arr
	s way=sort
	w ..PrintOut(.Sort,User,.total,way,stpage,endpage)
	
	
	w "], ""total"":"_total_"}"
	q ""
}

ClassMethod PrintOut(ByRef Sort, User As %String, ByRef total, way As %String, stpage As %String, endpage As %String)
{
	s jsonstr=""
	s sort=way
	if (sort=0)    //icd编码排序
	{
		s sortcode="ICDNumber"
	}
	elseif (sort=1) 		 //按icd描述排序
	{
		s sortcode="ICDDesc"
	}
	elseif (sort=2) 					//按rowid排序
	{
		s sortcode="RowID"
	}
	elseif (sort=3) 	//结构化结果排序
	{
		s sortcode="Result"
	}
	s UseCode=""
	for
	{

		s UseCode=$o(Sort(User,sortcode,UseCode))
		
		q:UseCode=""
		s MKBICDRowid=""
		for
		{
			
			s MKBICDRowid=$o(Sort(User,sortcode,UseCode,MKBICDRowid))
			q:MKBICDRowid=""
			s ^TempICDPrintOut(sortcode,UseCode,MKBICDRowid)=""
			s total=total+1
			if (total<stpage) continue
			if (total<=endpage)
			{
				d GetDataOutPut
			}
		}
	}
	
	q ""
GetDataOutPut
	s MKBICDCode=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),2)
	s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
	s MKBICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBICDDesc) //ICD描述
	s MKBICDDescCaption=$zconvert(MKBICDDesc,"U")
	
	s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
	s MKBICDStatus=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),13)
	s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),19)
	//s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDDesc)
	s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
	s sourcelen=$l(Sources,"&")
	s MKBICDSource=""
	for i=1:1:sourcelen
	{
		s Source=$p(Sources,"&",i)
		continue:Source=""
		s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
		s:MKBICDSource'="" MKBICDSource=MKBICDSource_"&"_SourceString
		s:MKBICDSource="" MKBICDSource=SourceString
	}
	s Result=""
	if (sort=3)
	{
		s Result=UseCode
	}
	else
	{
		//获取结构化结果
		s sequence=0
		for
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
			q:sequence=""
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
				q:MKBICDRRowid=""
				s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
				s MKBICDSupplement=$lg(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid),5)
				if MKBICDSupplement'=""
				{
					if SResult["]"
					{
						s str=$e(SResult,1,*-1)
						s SResult=str_",("_MKBICDSupplement_")]"
					}
					else
					{
						s SResult=SResult_"[("_MKBICDSupplement_")]"
					}
				}
				s:Result'="" Result=Result_"<br/>"_SResult
				s:Result="" Result=SResult
			}
		}
	}
	s MKBICDExtendNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),5)
	s MKBICDType=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),7)
	s MKBICDOption=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),8)
	s MKBICDCenterWordID=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),9)
	s MKBICDTermDr=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),10)
	if MKBICDTermDr'=""
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
		s MKBTPDDesc=""
		if (MKBTPRowId'="")
		{
			s detailid=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
			
			s:detailid'="" MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(1)),3)
		}
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
	}
	else
	{
		s MKBTPDDesc=""
		s MKBTDesc=""
	}
	s MKBICDRemark=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),11)
	s MKBICDConSegmentation=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),12)
	s MKBICDConDate=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),14)
	s:MKBICDConDate'="" MKBICDConDate=$zd(MKBICDConDate,3)
	
	s MKBICDConUpdateUsers=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),15) //操作人
	s:MKBICDConUpdateUsers'="" MKBICDConUpdateUser=$p($g(^SSU("SSUSR",MKBICDConUpdateUsers)),"^",2)
	s:MKBICDConUpdateUsers="" MKBICDConUpdateUser=""
	
	
	s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),17)
	s MKBICDCenterWord=""                         ;通过中心词id获取描述
	if MKBICDCenterWordID'=""
	{
		s WordCount=$l(MKBICDCenterWordID,",")
		for i=1:1:WordCount
		{
			s WordEach=$p(MKBICDCenterWordID,",",i)
			s MKBICDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
			s:MKBICDCenterWord'="" MKBICDCenterWord=MKBICDCenterWord_","_MKBICDWord
			s:MKBICDCenterWord="" MKBICDCenterWord=MKBICDWord
		}	
	}
	s thisStr=""
	
	s thisStr="{""Rowid"":"""_MKBICDRowid_""",""MKBICDCode"":"""_MKBICDCode_""",""MKBICDDesc"":"""_MKBICDDesc_""",""MKBICDNumber"":"""_MKBICDNumber_""",""MKBICDExtendNumber"":"""_MKBICDExtendNumber_""",""MKBICDCenterWordID"":"""_MKBICDCenterWordID_""",""MKBICDType"":"""_MKBICDType_""",""MKBICDOption"":"""_MKBICDOption_""",""MKBICDTermDr"":"""_MKBICDTermDr_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBICDRemark"":"""_MKBICDRemark_""",""MKBICDConSegmentation"":"""_MKBICDConSegmentation_""",""MKBICDStatus"":"""_MKBICDStatus_""",""MKBICDConDate"":"""_MKBICDConDate_""",""MKBICDConUpdateUser"":"""_MKBICDConUpdateUser_""",""MKBICDCenterWord"":"""_MKBICDCenterWord_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_""",""MKBICDDiaSource"":"""_MKBICDSource_""",""Result"":"""_Result_""",""MKBICDResultRelation"":"""_MKBICDResultRelation_"""}"    

	if (jsonstr'="")
	{ 
		w ","
		s jsonstr=jsonstr_","_thisStr
	}
	else
	{
		s jsonstr=thisStr
	}
	w thisStr
}

/// Creator:李得原
/// CreatDate:2019-02-15
/// Description:获取诊断数据
/// Table:
/// Input:
/// Return:查询数据
/// Other:d ##class(web.DHCBL.MKB.MKBICDContrast).GetIcdList()
ClassMethod GetIcdList(icd As %String, diag As %String, status As %String, rows As %String, page As %String) As %String
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s:diag'="" diag=$ZCONVERT(diag,"U") //转换成大写
	s:icd'="" icd=$ZCONVERT(icd,"U")    //转换成大写
	s:status'="" status=$ZCONVERT(status,"U")  //转换成大写
	k ^Temp("MKBSortICDContrastDesc")
	s total=0
	s totalF=0
	s flag=""
	if ((icd'="")||(diag'="")||(status'=""))
	{
		s flag=1
		k DiagList
		s NumOfDiag=$l(diag," ")
		for i=1:1:NumOfDiag
		{
			s DiagList(i)=$p(diag," ",i)
		}
		s Rowid=0
		for
		{
			s Rowid=$o(^User.MKBICDContrastD(Rowid))
			q:Rowid=""

			s MKBTPDDesc=""
			s MKBTDesc=""
			s PINYINDiag=""
			s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3)
			s MKBICDConDesc=$ZCONVERT(MKBICDConDesc,"U")
			s MKBICDConNumber=$lg($g(^User.MKBICDContrastD(Rowid)),4)
			s MKBICDStatus=$lg($g(^User.MKBICDContrastD(Rowid)),9)
			s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDConDesc)
			if NumOfDiag=1
			{
				if (MKBICDConNumber[icd)&((MKBICDConDesc[diag)||(PINYINDesc[diag))&(MKBICDStatus[status)
				{
					d ..SortByPinyin(PINYINDesc,Rowid)
				}
			}
			else
			{
				for i=1:1:NumOfDiag
				{
					if (MKBICDConDesc[DiagList(i))&(DiagList(i)'="")
					{
						d ..SortByPinyin(PINYINDesc,Rowid)
						
					}
				}
			}
		}
	}
	else
	{
		s flag=0
		s Rowid=0
		for
		{
			s Rowid=$o(^User.MKBICDContrastD(Rowid))
			q:Rowid=""
			if ((total+1<stpage)||(total+1>endpage)) //如果不是当前页则只计数，不输出。
			{
				
			}
			else
			{
				s MKBICDConCode=$lg($g(^User.MKBICDContrastD(Rowid)),2)
				s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3)
				s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDConDesc)
				d ..SortByPinyin(PINYINDesc,Rowid)
				s totalF=totalF+1
			}
			s total=total+1
		}
	}
	s jsonstr=""
	s desc=""
	w "{""rows"":["
	for
	{
		s desc=$o(^Temp("MKBSortICDContrastDesc",desc),-1)
		q:desc=""
		
		s Rowid=0
		for
		{
			s Rowid=$o(^Temp("MKBSortICDContrastDesc",desc,Rowid))
			q:Rowid=""
			s MKBTPDDesc=""
			s MKBTDesc=""
			s PINYINDiag=""
			s MKBICDConCode=$lg($g(^User.MKBICDContrastD(Rowid)),2)
			s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(Rowid)),3)
			s MKBICDConNumber=$lg($g(^User.MKBICDContrastD(Rowid)),4)
			s MKBICDCenterWordID=$lg($g(^User.MKBICDContrastD(Rowid)),5)
			s MKBICDTermDr=$lg($g(^User.MKBICDContrastD(Rowid)),6)
			if MKBICDTermDr'=""
			{
				s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
				s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
			}
			s MKBICDRemark=$lg($g(^User.MKBICDContrastD(Rowid)),7)
			s MKBICDConSegmentation=$lg($g(^User.MKBICDContrastD(Rowid)),8)
			s MKBICDStatus=$lg($g(^User.MKBICDContrastD(Rowid)),9)
			s MKBICDConDate=$lg($g(^User.MKBICDContrastD(Rowid)),10)
			s MKBICDConUpdateUser=$lg($g(^User.MKBICDContrastD(Rowid)),11)
			s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(Rowid)),13)
			
			s MKBICDCenterWord=""                         ;通过中心词id获取描述
			if MKBICDCenterWordID'=""
			{
				s WordCount=$l(MKBICDCenterWordID,",")
				for i=1:1:WordCount
				{
					s WordEach=$p(MKBICDCenterWordID,",",i)
					s MKBICDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
					s:MKBICDCenterWord'="" MKBICDCenterWord=MKBICDCenterWord_","_MKBICDWord
					s:MKBICDCenterWord="" MKBICDCenterWord=MKBICDWord
				}	
			}
			;Rowid,MKBICDConCode,MKBICDConDesc,MKBICDConNumber,MKBICDCenterWordID,MKBICDTermDr,MKBTPDDesc,MKBTDesc,MKBICDRemark,MKBICDConSegmentation,MKBICDStatus,MKBICDConDate,MKBICDConUpdateUser,MKBICDCenterWord
			if (flag=1)
			{
				s total=total+1
				if (total<stpage) continue
			    if (total<=endpage)
			    {
				    s thisStr=""	
					s thisStr="{""Rowid"":"""_Rowid_""",""MKBICDConCode"":"""_MKBICDConCode_""",""MKBICDConDesc"":"""_MKBICDConDesc_""",""MKBICDConHISNumber"":"""_MKBICDConNumber_""",""MKBICDCenterWordID"":"""_MKBICDCenterWordID_""",""MKBICDTermDr"":"""_MKBICDTermDr_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBICDRemark"":"""_MKBICDRemark_""",""MKBICDConSegmentation"":"""_MKBICDConSegmentation_""",""MKBICDStatus"":"""_MKBICDStatus_""",""MKBICDConDate"":"""_MKBICDConDate_""",""MKBICDConUpdateUser"":"""_MKBICDConUpdateUser_""",""MKBICDCenterWord"":"""_MKBICDCenterWord_"""}"

					if (jsonstr'="")
					{ 
						w ","
						s jsonstr=jsonstr_","_thisStr
					}
					else
					{
						s jsonstr=thisStr
					}
					w thisStr
				 }
			}
			else
			{
				;if (totalF<stpage) continue
			    if (totalF<=endpage)
			    {
				    s thisStr=""	
					s thisStr="{""Rowid"":"""_Rowid_""",""MKBICDConCode"":"""_MKBICDConCode_""",""MKBICDConDesc"":"""_MKBICDConDesc_""",""MKBICDConHISNumber"":"""_MKBICDConNumber_""",""MKBICDCenterWordID"":"""_MKBICDCenterWordID_""",""MKBICDTermDr"":"""_MKBICDTermDr_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBICDRemark"":"""_MKBICDRemark_""",""MKBICDConSegmentation"":"""_MKBICDConSegmentation_""",""MKBICDStatus"":"""_MKBICDStatus_""",""MKBICDConDate"":"""_MKBICDConDate_""",""MKBICDConUpdateUser"":"""_MKBICDConUpdateUser_""",""MKBICDCenterWord"":"""_MKBICDCenterWord_"""}"

					if (jsonstr'="")
					{ 
						w ","
						s jsonstr=jsonstr_","_thisStr
					}
					else
					{
						s jsonstr=thisStr
					}
					w thisStr
				 }
			}
		}
		
	}
	w "], ""total"":"_total_"}"
	q ""
}

/// Creator:李得原
/// CreatDate:2019-2-14
/// Description：查询国际码列表子术语库内容及中文释义
/// Input：rowid-行号，desc-描述, base-规则注册表id, descch-中文释义，rows-每页显示条数, page-页数
/// Return:Json格式的数据
/// Other:d ##class(web.DHCBL.MKB.MKBICDContrast).GetMyList("E76","","1","11","1")
ClassMethod GetMyList(desc, descch, base, rows, page) As %String
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	if (desc'="")
	{
		s desc=$ZCONVERT(desc,"U")
		s desc=$tr(desc,".","")
		s desc=$tr(desc," ","")
	}
	w "{""rows"":["
	if (desc="")&(descch="")
	{
		s total=0
		s jsonstr=""
		s MKBTRowId=0
		for  
		{	
			
			s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) 
			q:MKBTRowId="" 
			
			if ((total+1<stpage)||(total+1>endpage)) //如果不是当前页则只计数，不输出。
			{
				
			}
			else
			{
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
				s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
				s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
				
				s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义",0))
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
				s MKBTPRowIdE = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 英文释义",0))
				s MKBTPDDescE = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowIdE,0)))),3)			
			}
			s total=total+1
		    if (total<stpage) continue
		    if (total<=endpage)
		    {
			    s thisStr=""	
				s thisStr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDDescE"":"""_MKBTPDDescE_"""}"
				
				if (jsonstr'="")
				{ 
					w ","
					s jsonstr=jsonstr_","_thisStr
				}
				else
				{
					s jsonstr=thisStr
				}
				w thisStr
			 }		
		}
		w "], ""total"":"_total_"}"
	}
	elseif (desc'="" || descch'="")
	{
		s total=0
		s jsonstr=""
		s descstr=""
		s descchStr=""
		s str=""
		if desc'=""
		{
			s desc=$ZCONVERT(desc,"U")
			s desc=$tr(desc," ","")
			s descstr=##class(web.DHCBL.MKB.MKBICDContrast).GetNationICD("编码",desc)
			if descch'=""
			{
				s descch=$tr(descch," ","")
				s descchStr=##class(web.DHCBL.MKB.MKBICDContrast).GetNationICD("中文",descch)
				s NumOfStr=$l(descstr,"&%")
				s NumOfDescchstr=$l(descchStr,"&%")
				for i=1:1:NumOfStr
				{
					s EachOfDesc=$p(descstr,"&%",i)
					for j=1:1:NumOfDescchstr
					{
						s EachOfDescch=$p(descchStr,"&%",j)
						if EachOfDesc=EachOfDescch
						{
							s:str'="" str=str_"&%"_EachOfDesc
							s:str="" str=EachOfDesc
						}
					}
				}
				
			}
			else
			{
				s str=descstr
			}	
		}
		else
		{
			s descch=$tr(descch," ","")
			s str=##class(web.DHCBL.MKB.MKBICDContrast).GetNationICD("中文",descch)
		}
		if str'=""
		{
			s NumOfStr=$l(str,"&%")
			for i=1:1:NumOfStr
			{
				s MKBTRowId=$p(str,"&%",i)
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
				s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
				s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义",0))
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
				s MKBTPRowIdE = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 英文释义",0))
				s MKBTPDDescE = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowIdE,0)))),3)
				s total=total+1
			    if (total<stpage) continue
			    if (total<=endpage)
			    {
				    s thisStr=""	
					s thisStr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDDescE"":"""_MKBTPDDescE_"""}"
					
					if (jsonstr'="")
					{ 
						w ","
						s jsonstr=jsonstr_","_thisStr
					}
					else
					{
						s jsonstr=thisStr
					}
					w thisStr
				 }
				 
			}
		}
			w "], ""total"":"_total_"}"
		
	}
	q ""
}

/// Creator：石萧伟
/// CreatDate: 2019-01-28
/// Description：查询国际码列表子术语库内容及中文释义
/// Table：User.MKBTerm
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDContrast","GetInterList","","E76","","1")
Query GetInterList(rowid, desc, descch, base) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTPYCode,MKBTPDDesc,MKBTPDDescE")
{
}

ClassMethod GetInterListExecute(ByRef qHandle As %Binary, rowid, desc, descch, base) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	  
	if (base'="") //如果子术语库大类未选中
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			s MKBTRowId=rowid
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
			s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			
			s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义",0))
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
			
			s MKBTPRowIdE = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 英文释义",0))
			s MKBTPDDescE = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowIdE,0)))),3)
			
			d OutputRow
		}
		else
		{
			s:desc'="" desc=$ZCONVERT(desc,"U")
			s:descch'="" descch=$ZCONVERT(descch,"U")
			if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
			{
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) 
					q:MKBTRowId="" 
					s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
					s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
					s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
					
					s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义",0))
					s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
					s MKBTPRowIdE = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 英文释义",0))
					s MKBTPDDescE = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowIdE,0)))),3)					
					s PINYINDesc=""
					if descch'="" s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDesc)
										
					if ((desc'="") || (descch'=""))
					{
						s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowId)  
						s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
						s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
						s aliasDescU=$ZCONVERT(aliasDesc,"U")
						s aliasKeyU=$ZCONVERT(aliasKey,"U")
						
						i (((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(aliasDescU[desc)||(aliasKeyU[desc))&&((PINYINDesc[descch)||(MKBTPDDesc[descch)))  //条件
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
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTPYCode,MKBTPDDesc,MKBTPDDescE)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetInterListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInterListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInterListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInterListExecute ]
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

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description：结构化结果展示
/// Table：User.MKBICDContrast
/// Input：父表id 
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDContrast","GetResultList","")
Query GetResultList(id As %String) As %Query(ROWSPEC = "Rowid,MKBICDContrast,MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement,MKBICDSequence,MKBTActiveFlag")
{
}

ClassMethod GetResultListExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1

	
	
		if id'=""
		{
		s rowid=0
		for
		{
			s rowid=$o(^User.MKBICDContrastD(id,"MKBICDContrastResult",rowid))
			q:rowid=""
			s Rowid=id_"||"_rowid
			s MKBICDConTermDr=$lg(^User.MKBICDContrastD(id,"MKBICDContrastResult",rowid),4)
			s MKBTActiveFlag=$lg($g(^User.MKBTermD(MKBICDConTermDr)),9)
			s MKBICDConSupplement=$lg(^User.MKBICDContrastD(id,"MKBICDContrastResult",rowid),5)
			s MKBICDContrast=id
			;s MKBICDConResult=$lg(^User.MKBICDContrastD(id,"MKBICDContrastResult",rowid),3)
			s MKBICDConResultID=$lg(^User.MKBICDContrastD(id,"MKBICDContrastResult",rowid),2)
			s MKBICDConResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr)
			s MKBICDSequence=$lg(^User.MKBICDContrastD(id,"MKBICDContrastResult",rowid),7)
			if MKBICDConSupplement'=""
			{
				s MKBICDConSupplement=$zstrip(MKBICDConSupplement,"<>W")
				if MKBICDConResult["]"
				{
					s str=$e(MKBICDConResult,1,*-1)
					s MKBICDConResult=str_",("_MKBICDConSupplement_")]"
				}
				else
				{
					s MKBICDConResult=MKBICDConResult_"[("_MKBICDConSupplement_")]"
				}
			}
			
			d getCTTitle
			

		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(Rowid,MKBICDContrast,MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement,MKBICDSequence,MKBTActiveFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description：结构化结果子表的删除   删除结构化结果的时候，判断是否只剩一条或者为空。是的话，需要同时修改父表的关系字段
/// Table：User.MKBICDContrastResult
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).DeleteData()
ClassMethod DeleteData(id)
{
	if id'=""
	{
		Ts
		s Pid=$p(id,"||",1)
		s Cid=$p(id,"||",2)
		s Diag=$lg($g(^User.MKBICDContrastD(Pid)),3)
		
		s count=0
		s childid=""
		for
		{
			s childid=$o(^User.MKBICDContrastD(Pid,"MKBICDContrastResult",childid))
			q:childid=""
			s count=count+1
		}
		s DiagResultId=$lg($g(^User.MKBICDContrastD(Pid,"MKBICDContrastResult",Cid)),2)
		s DiagTermdr=$lg($g(^User.MKBICDContrastD(Pid,"MKBICDContrastResult",Cid)),4)
		s DiagResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(DiagResultId,DiagTermdr)
		s bobj=##class(web.Entity.MKB.MKBICDContrastResult).%New()
		s bobj.MKBICDConResultID=DiagResultId
		s bobj.MKBICDConTermDr=DiagTermdr
		s sc= ##class(User.MKBICDContrastResult).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			//同步修改数据处理工厂的结构化结果
			d ##class(web.DHCBL.MKB.MKBStructuredData).ChangeStructByICDContrast(Pid)
			
			set result = "{success:'true',info:'删除成功！'}"
			if ((count=1)||(count=0))	//删除后不存在结构化结果,或者只剩下一个
			{
				s pobj=##class(User.MKBICDContrast).%OpenId(Pid)
				s:count=0 pobj.MKBICDChildStructFlag=""
				s pobj.MKBICDResultRelation=""
				s psc=pobj.%Save()
				d pobj.%Close()
			}
			s refResult =  ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("ICDXR",id)
			
			
			d:id'="" ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrastResult","User.MKBICDContrastResult","各版本ICD对照结构化诊断",id,Diag_"-"_DiagResult,"D",bobj)	

		}
		else
		{
			Tro
			s logid= ##class(web.DHCBL.MKB.SysErrorLog).SaveLog("各版本ICD对照结构化诊断","web.DHCBL.MKB.MKBICDContrast","DeleteData",bobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		
			set result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
		}
	}
	else
	{
		set result = "{success:'false',info:'id为空！'}"
	}
	d bobj.%Close()
	q result
}

/// Creator:石萧伟
/// CreatDate:2018-12-10
/// Description：结构化结果子表的新增
/// Table：User.MKBICDContrastResult
/// Input：id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).SaveData()
ClassMethod SaveData(Pid As %String, Cid As %String, StructResultID As %String, StructResult As %String, PropertyDR As %String, Supplement As %String)
{
	if (StructResultID'="")		//有属性
	{
		s SResult=PropertyDR_"-"_StructResultID
		s SResult=##class(web.DHCBL.MKB.MKBStructuredData).StandardizedStructStr(SResult)
		if (SResult="")
		{
			set result ="{success:'false',errorinfo:'中心词已被封闭！'}"
			q result	
		}
		else
		{
			s StructResultID=$p(SResult,"-",2)
		}
	}
	if Cid=""      ;如果为空 则新增子表数据
	{
		s obj=##class(User.MKBICDContrastResult).%New(Pid)
		s sort=0
		if ($d(^User.MKBICDContrastResultI("SeqIndex")))
		{
			s sort=$o(^User.MKBICDContrastResultI("SeqIndex",Pid,""),-1) 
		}
		s obj.MKBICDSequence=sort+1			
	}
	else      ;如果不为空 则修改子表数据
	{
		s obj=##class(User.MKBICDContrastResult).%OpenId(Cid)
		s bobj=##class(web.Entity.MKB.MKBICDContrastResult).%New()
		s bobj.MKBICDConSupplement=obj.MKBICDConSupplement
		s bobj.MKBICDConTermDr=obj.MKBICDConTermDr.%Id()
		s bobj.MKBICDConResultID=obj.MKBICDConResultID
		s bobj.MKBICDConOther=obj.MKBICDConOther
		s bobj.MKBICDSequence=obj.MKBICDSequence
		s bobj.MKBICDCRowid=obj.MKBICDContrast.%Id()
		s bobj.MKBICDCRRowid=obj.%Id()
		d bobj.%Close()

	}
	s eobj=##class(web.Entity.MKB.MKBICDContrastResult).%New()
	s:Pid'="" eobj.MKBICDCRowid=Pid
	s:Cid'="" eobj.MKBICDCRRowid=Cid
	s:StructResultID'="" eobj.MKBICDConResultID=StructResultID
	s:StructResult'="" eobj.MKBICDConResult=StructResult
	s:PropertyDR'="" eobj.MKBICDConTermDr=PropertyDR
	s:Supplement'="" eobj.MKBICDConSupplement=Supplement
	
	
	d obj.MKBICDContrastSetObjectId(Pid)
	d obj.MKBICDConTermDrSetObjectId(PropertyDR)
	s obj.MKBICDConResult=StructResult
	s obj.MKBICDConResultID=StructResultID
	s obj.MKBICDConSupplement=Supplement
	s sc=obj.%Save()
	s errorinfo=""
	Ts
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
	
		set result = "{success:'true',id:'"_id_"'}" 
		//同步修改数据处理工厂的结构化结果
		d ##class(web.DHCBL.MKB.MKBStructuredData).ChangeStructByICDContrast(Pid)
		
		s pobj=##class(User.MKBICDContrast).%OpenId(Pid)
		s pobj.MKBICDChildStructFlag=1
		s psc=pobj.%Save()
		d pobj.%Close()
		if $$$ERROR(psc)
		{
			tro
			s errorinfo=" "_$System.OBJ.DisplayError(psc)_" "
		}
		s delResult=##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("ICDXR",id)
		if (PropertyDR'=""){
			if (Cid=""){
				s resultrefS = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","ICDXR",id,"T",PropertyDR)
			}	
			else{
				s refRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("ICDXR", Cid, "T", PropertyDR)
				
				s resultRef = ##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "ICDXR", Cid, "T", PropertyDR)
			}
	 			
		}
		
		if (StructResultID'=""){
			s resultref = ##class(web.DHCBL.MKB.MKBReference).SaveExpFroReference("ICDXR",id,StructResultID)
		}
		s Diag=$lg($g(^User.MKBICDContrastD(Pid)),3)
		s DiagResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(StructResultID,PropertyDR)			
		d:Cid="" ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrastResult","User.MKBICDContrastResult","各版本ICD对照结构化诊断",id,Diag_"-"_DiagResult,"A",eobj)	
		d:Cid'="" ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrastResult","User.MKBICDContrastResult","各版本ICD对照结构化诊断",id,Diag_"-"_DiagResult,"U",eobj,bobj)
	
	}
	else
	{
		Tro
		s logid= ##class(web.DHCBL.MKB.SysErrorLog).SaveLog("各版本icd对照","web.DHCBL.MKB.MKBICDContrast","SaveData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		set result ="{success:'false',errorinfo:'"_errorinfo_$System.OBJ.DisplayError(sc)_"'}"
	}
	d eobj.%Close()
	d obj.%Close()
	quit result
}

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description:更新数据
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBICDContrast).Update()
ClassMethod Update(rowid As %String, MKBICDConStatus As %String, MKBICDRemark As %String, MKBICDTermDr As %String, MKBICDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBICDContrast).%OpenId(rowid)        ;先备份再更新
		s bobj=##class(web.Entity.MKB.MKBICDContrast).%New()
		s bobj.MKBICDConCode=obj.MKBICDConCode
		s bobj.MKBICDConDesc=obj.MKBICDConDesc
		s bobj.MKBICDConNumber=obj.MKBICDConNumber
		s bobj.MKBICDTermDr = obj.MKBICDTermDr
		s bobj.MKBICDRemark=obj.MKBICDRemark
		s bobj.MKBICDConCenterWordID=obj.MKBICDConCenterWordID
		s bobj.MKBICDConSegmentation=obj.MKBICDConSegmentation
		s bobj.MKBICDConStatus=obj.MKBICDConStatus
		s bobj.MKBICDConDate=obj.MKBICDConDate
		s bobj.MKBICDConUpdateUser=obj.MKBICDConUpdateUser
		s bobj.MKBICDInitialICD=obj.MKBICDInitialICD
		d bobj.%Save()
		d bobj.%Close()
	
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		
		s obj.MKBICDConDate=UpdateDate
		if (MKBICDConStatus'=""){
			s obj.MKBICDConStatus=MKBICDConStatus
		}
		if (MKBICDRemark'=""){
			s obj.MKBICDRemark=MKBICDRemark
		}
		if (MKBICDTermDr'=""){
			d obj.MKBICDTermDrSetObjectId(MKBICDTermDr)
		}
		if (MKBICDInitialICD'=""){
			s obj.MKBICDInitialICD=MKBICDInitialICD
		}
		d obj.MKBICDConUpdateUserSetObjectId(UpdateUserDR)
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
		}
		else
		{
			Tro
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			
		}
		d obj.%Close()
				
	}
	quit result
}

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description:判断同名诊断
/// Table:
/// Input:
/// Return:有则拼串，没有返回“”
/// Other:d ##class(web.DHCBL.MKB.MKBICDContrast).justHasExist(119,26484)
ClassMethod justHasExist(parentid, proid)
{
	s existStr = ""
	if $d(^User.MKBICDContrastD(parentid,"MKBICDContrastResult"))
	{
		s rowid=0
		
		for
		{
			s rowid=$o(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid))
			q:rowid=""
			s MKBICDConTermDr=$lg(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid),4)
			s MKBICDConResult=$lg(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid),3)
			if (proid = MKBICDConTermDr)
			{
				s existStr = parentid_"||"_rowid _"^"_MKBICDConResult
				q
			}
			
		}
		
	}
	//else
	//{
	q existStr	
	//}
}

/// Creator:石萧伟
/// CreatDate:2018-11-27
/// Description:可编辑表格更新数据
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBICDContrast).EditUpdate(4310,"","","12464")
ClassMethod EditUpdate(rowid As %String, MKBICDConStatus As %String, MKBICDRemark As %String, MKBICDTermDr As %String, MKBICDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBICDContrast).%OpenId(rowid)        ;先备份再更新
		s bobj=##class(web.Entity.MKB.MKBICDContrast).%New()
		s bobj.MKBICDConCode=obj.MKBICDConCode
		s bobj.MKBICDConDesc=obj.MKBICDConDesc
		s bobj.MKBICDConNumber=obj.MKBICDConNumber
		s bobj.MKBICDTermDr = obj.MKBICDTermDr
		s bobj.MKBICDRemark=obj.MKBICDRemark
		s bobj.MKBICDConCenterWordID=obj.MKBICDConCenterWordID
		s bobj.MKBICDConSegmentation=obj.MKBICDConSegmentation
		s bobj.MKBICDConStatus=obj.MKBICDConStatus
		s bobj.MKBICDConDate=obj.MKBICDConDate
		s bobj.MKBICDConUpdateUser=obj.MKBICDConUpdateUser
		s bobj.MKBICDInitialICD=obj.MKBICDInitialICD
		d bobj.%Close()
		//MKBICDConStatus As %String, MKBICDRemark As %String, MKBICDTermDr As %String, MKBICDInitialICD
		s eobj=##class(web.Entity.MKB.MKBICDContrast).%New()
		s eobj.MKBICDConStatus=MKBICDConStatus
		s eobj.MKBICDRemark=MKBICDRemark
		s eobj.MKBICDTermDr=MKBICDTermDr
		s eobj.MKBICDInitialICD=MKBICDInitialICD
		d eobj.%Close()
	
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		
		s obj.MKBICDConDate=UpdateDate
		d obj.MKBICDConUpdateUserSetObjectId(UpdateUserDR)
		if (MKBICDConStatus'=""){
			s obj.MKBICDConStatus=MKBICDConStatus
		}
		if (MKBICDRemark'=""){
			s obj.MKBICDRemark=MKBICDRemark
		}
		if (MKBICDTermDr'=""){
			d obj.MKBICDTermDrSetObjectId(MKBICDTermDr)
		}
		if (MKBICDInitialICD'=""){
			s obj.MKBICDInitialICD=MKBICDInitialICD
		}
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
			s Diag=$lg($g(^User.MKBICDContrastD(rowid)),3)
			d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrast","User.MKBICDContrast","各版本ICD对照诊断短语",id,Diag,"U",eobj,bobj)
		}
		else
		{
			Tro
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			
		}
		d obj.%Close()
				
	}
	quit result
}

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description:根据诊断模板获取诊断id
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBICDContrast).GetTermIdByProId("26473")
ClassMethod GetTermIdByProId(ProId)
{
	s MKBTRowId = $LG($G(^User.MKBTermPropertyD(ProId)),6)	
	q MKBTRowId
}

/// Creator:石萧伟
/// CreatDate:2019-0118
/// Description：根据属性id获取诊断模板中的展示格式
/// Table：User.SDSStructDiagnos
/// Input：属性id
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).GetShowType("4989")
ClassMethod GetShowType(property) As %String
{
	k ^TMPMKBSHOWTYPE
	q:property="" ""
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
}

/// Creator:石萧伟
/// CreatDate:2019-03-14
/// Description：根据标识获取属性id
/// Input: termid术语id，desc属性描述
/// return:属性id
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetPropertyIdByFlag("16354","DT")
ClassMethod GetPropertyIdByFlag(termid As %String, flag As %String) As %String
{
	s propertyid=""
	s propertyid=$o(^User.MKBTermPropertyI("FlagIndex",termid," "_flag,0))
	q propertyid
}

/// Creator:石萧伟
/// CreatDate:2018-11-28
/// Description：获取结构化诊断的信息
/// Table：User.MKBStructuredData
/// Input：rowid 结构化诊断id
/// Return：术语属性内容值串^诊断展示名^诊断备注
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).GetData("1","1||1")
ClassMethod GetData(parentid, rowid) As %String
{
	q:parentid="" ""
	q:rowid="" ""
	s result=""
	s parentid = $p($g(rowid),"||",1)
	s rowid = $p($g(rowid),"||",2)
	s SDSTermDR=$lg(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid),4) //诊断id
	s PropertyDR=..GetPropertyIdByFlag(SDSTermDR,"DT")
	d ..GetShowType(PropertyDR)
	
	s SDSValue=$lg(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid),2)   
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
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

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description：获取结构化诊断的信息
/// Table：User.MKBStructuredData
/// Input：rowid 结构化诊断id
/// Return：术语属性内容值串^诊断展示名^诊断备注
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).GetData("1","1||3")
ClassMethod GetPPData(parentid, rowid) As %String
{
	
	s result=""
	s rowid = $p($g(rowid),"||",2)
	s SDSPropertyDR=$lg(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid),4) 
	d ..GetShowType(SDSPropertyDR)
	
	s MKBTRowId=$LISTGET($G(^User.MKBTermPropertyD(SDSPropertyDR)),6) //诊断id
	s SDSValue=$lg(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid),2)   
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	if (SDSValue'=""){
		s len=$Length(SDSValue,"^")
		for i=1:1:len{
			s progroup=$p(SDSValue,"^",i)
			s key=$p(progroup,":",1)
			if (key["P"){ //引用属性/知识应用模板
				s key=$p(key,"P",1)	
			}
			if (key["S"){ //引用列表术语
				s key=$p(key,"S",1)	
			}
			if ((key["M")&(key'["TM")) { //列表术语
				s key=$p(key,"M",1)	
			}
			s value=$p(progroup,":",2)
			if (key["T"){ //树形 包含引用树形术语S及树形术语M
				if (TreeCheckedIdStr=""){
					s TreeCheckedIdStr=value
				}else{
					s TreeCheckedIdStr=TreeCheckedIdStr_"&"_value
				}
			}else{
				if ($g(^TMPMKBSHOWTYPE(key))="C"){
					if (ComboCheckedIdStr=""){
						s ComboCheckedIdStr=value
					}else{
						s ComboCheckedIdStr=ComboCheckedIdStr_"&"_value
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="CB"){
					if (RadioCheckedIdStr=""){
						s RadioCheckedIdStr=value
					}else{
						s RadioCheckedIdStr=RadioCheckedIdStr_"&"_value
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="CG"){
					if (CheckBoxCheckedIdStr=""){
						s CheckBoxCheckedIdStr=value
					}else{
						s CheckBoxCheckedIdStr=CheckBoxCheckedIdStr_"&"_value
					}
				}
			}
		}
	}
	s SDSDisplayName=$lg(^User.MKBICDContrastD(parentid,"MKBICDContrastResult",rowid),3)  //MKBICDConResult
	s SDSNotes=$LISTGET($G(^User.SDSStructDiagnosD(rowid)),5)
	
	//s DiagnosDisPlayName=..GetDiagFormateDesc(DiagnosPRowID) //$p($g(^MR("DIAGP",DiagnosPRowID)),"^",10)
	
	s result=MKBTRowId_"^"_TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_SDSDisplayName_"^"_SDSNotes
	q result
}

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description：清空已选属性列表临时global
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).ClearSelProperty()
ClassMethod ClearSelProperty() As %String
{
	k ^TMPICDSELPROPERTY("SelProperty")
	q 1
}

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description：设置已选属性列表临时global
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateSelProperty()
ClassMethod UpdateSelProperty(index, titleid, title, id, text, type) As %String
{
	s:id="" id=0
	if (type="add"){
		s ^TMPICDSELPROPERTY("SelProperty",index,id)=titleid_"^"_title_"^"_text
	}else{
		if (id=0){
			k ^TMPICDSELPROPERTY("SelProperty",index) //单选框切换时先清空
		}else{
			k ^TMPICDSELPROPERTY("SelProperty",index,id)
		}
	}
	s count=$o(^TMPICDSELPROPERTY("SelProperty",""),-1)
	s result = "{count:'"_count_"',success:'true'}" 
	q result
}

/// Creator：石萧伟
/// CreatDate: 2019-01-18
/// Description：获取已选属性列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetSelProperty")
Query GetSelProperty() As %Query(ROWSPEC = "index, titleid, title, id, text")
{
}

ClassMethod GetSelPropertyExecute(ByRef qHandle As %Binary) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s index=""
 for{
	s index=$o(^TMPICDSELPROPERTY("SelProperty",index)) q:index=""
	
	s id=""
	for 
	{
		s id=$o(^TMPICDSELPROPERTY("SelProperty",index,id)) q:id=""
		if ($o(^TMPICDSELPROPERTY("SelProperty",index,""),-1)'=0){
			continue:id=0 //去除属性内容为空的重复节点信息
		}
		s titleid=$p(^TMPICDSELPROPERTY("SelProperty",index,id),"^",1)
		s title=$p(^TMPICDSELPROPERTY("SelProperty",index,id),"^",2)
		s text=$p(^TMPICDSELPROPERTY("SelProperty",index,id),"^",3)
		d OutputRowSelProperty
	}	
 }    
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowSelProperty
    set Data=$lb(index,titleid, title, id, text)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSelPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelPropertyExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetSelPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelPropertyExecute ]
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

/// Creator:石萧伟
/// CreatDate:2018-12-10
/// Description：修改补充诊断即更新
/// Table：User.MKBStructuredDataResult
/// Input：id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).UpdateSupplement()
ClassMethod UpdateSupplement(Cid As %String, Supplement As %String)
{
	s obj=##class(User.MKBICDContrastResult).%OpenId(Cid)
	s obj.MKBICDConSupplement=Supplement
	s sc=obj.%Save()
	Ts
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		set result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Tro
		set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
	}
	d obj.%Close()
	quit result
}

/// Creator:李得原
/// CreatDate:2019-01-26
/// Description：对GetList中得诊断输出进行拼音排序
/// Table：User.MKBICDContrast
/// Input：desc,rowid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).UpdateSupplement()
ClassMethod SortByPinyin(DescPin As %String, rowid As %String)
{
	s ^Temp("MKBSortICDContrastDesc",DescPin,rowid)=""
	q ""
}

/// Creator:石萧伟
/// CreatDate:2019-02-25
/// Description：根据描述取termid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).findTermDescById(15026)
ClassMethod findTermDescById(termid As %String)
{
	q:termid="" ""  //描述
	s termDesc="" 
	s termDesc=$listGet($g(^User.MKBTermD(termid)),3) 
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termid)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s comDesc=$p(strCom,"&%",1) //常用名
	//s comKey=$p(strCom,"&%",2)	//常用名拼音码	
	s:comDesc="" comDesc=termDesc
	q comDesc
}

/// Creator:李得原
/// CreatDate:2019-05-16
/// Description：结构化结果ID串按照诊断模板顺序输出，如果诊断模板中已经删除属性，但结构化串中还有，也要显示
/// Table：User.MKBStructuredDataResult
/// Input：结构化子表 MKBICD_ConResultID
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs()
ClassMethod GetChiForNewSeqStrucIDs(ids, termdr)
{
	s result=""
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termdr)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s result=$p(strCom,"&%",1) //诊断常用名
	if result=""
	{
		s result=$lg($g(^User.MKBTermD(termdr)),3)
	}
	if ids'=""
	{
		//获取诊断模板id
		s DiagTemplateDr=$o(^User.MKBTermPropertyI("FlagIndex",termdr," DT",0))
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",DiagTemplateDr,0))
		s Detail=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
		s len=$l(Detail,",")
		for i=1:1:len
		{
			s OnePiece=$p(Detail,",",i)
			continue:OnePiece=""
			s Prodr=$p(OnePiece,"&",1)  //属性ID
			s Type=$p(OnePiece,"&",2)
			s ProDetailDr=$p(OnePiece,"&",3) //属性内容ID
			if ProDetailDr'=""
			{
				s Sequence(i,Prodr,ProDetailDr)=""
				s str=##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(ProDetailDr,Prodr)
				s strlen=$l(str,"^")
				for j=1:1:strlen
				{
					s ProDetail=$p(str,"^",j)
					continue:ProDetail=""
					s Details(i,Prodr,ProDetailDr,ProDetail)=""
				}
			}
			else
			{
				s Sequence(i,Prodr)=""
			}
		}
		s ValueString=""
		s ResultLen=$l(ids,",")
		s seq=0
		for
		{
			s seq=$o(Sequence(seq))   //获取顺序
			q:seq=""
			s Pro=0
			for
			{
				s Pro=$o(Sequence(seq,Pro))    //获取顺序中的Prodr
				q:Pro=""
				for i=1:1:ResultLen     
				{
					s Result=$p(ids,",",i)
					s key=$p(Result,":",1)
					s Val=$p(Result,":",2)
					if Pro=key
					{
						s valueslen=$l(Val,"*")
						for k=1:1:valueslen
						{
							s val=$p(Val,"*",k)
							s values=Pro_":"_val
							if values["S"
							{
								d GetDesc
								s tempV(val)=""
								s tempK(Pro)=""
							}
							elseif $d(Sequence(seq,Pro))=1
							{
								d GetDesc
								s tempK(Pro)=""
								s tempV(val)=""
							}
							else
							{
								s DNode=0
								for
								{
									s DNode=$o(Sequence(seq,Pro,DNode))   //引用起始节点
									q:DNode=""
									if $d(Details(seq,Pro,DNode,val))
									{
										if ('$d(^User.MKBTermPropertyD(key)))
										{
											continue
										}
										d GetDesc
										s tempV(val)=""
										s tempK(Pro)=""
									}
								}
							}
						}
					}
				}
			}
		}	
		for j=1:1:ResultLen
		{
			s Result=$p(ids,",",j)
			s key=$p(Result,":",1)
			s Val=$p(Result,":",2)
			s valueslen=$l(Val,"*")
			for k=1:1:valueslen
			{
				s values=""
				s value=$p(Val,"*",k)
				s values=key_":"_value
				if '$d(tempK(key))    //诊断模板中不存在的属性
				{
					d GetDesc
				}
				else
				{
					if '$d(tempV(value))         //诊断模板中不存在的属性内容
					{
						d GetDesc
					}
				}
			}
		}
		if ValueString=""
		{
			s result=result
		}
		else
		{
			s result=result_"["_ValueString_"]"	
		}
	}
	q result 
    
GetDesc             //串转描述
	if values["S"
	{
		s values=$tr(values,"S","")
		s ValueDr=$p(values,":",2)
		s Value=$lg($g(^User.MKBTermD(ValueDr)),3)
		if ValueString'=""
		{
			s ValueString=ValueString_","_Value
		}
		if ValueString=""
		{
			s ValueString=Value
		}	
	}
	else
	{
		s ValueDr=$p(values,":",2)
		s Value= ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(ValueDr,key,"展示名")
		if Value=""
		{
			s Value=$lg($g(^User.MKBTermProDetailD(ValueDr)),3)
		}
		if ValueString'=""
		{
			s ValueString=ValueString_","_Value
		}
		if ValueString=""
		{
			s ValueString=Value
		}
	}
}

/// Creator:石萧伟
/// CreatDate:2019-05-24
/// Description：结构化诊断上移下移顺序
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).SaveDragOrder("9^12^11")
ClassMethod SaveDragOrder(order) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(User.MKBICDContrastResult).%OpenId(rowid)
		s obj.MKBICDSequence=i
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

/// Creator:李得原
/// CreatDate:2019-08-08
/// Description：
/// Table：User.MKBICDContrast
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).GetSingleData()
ClassMethod GetSingleData(id As %String) As %String
{
	s Result=""
	s MKBICDRowid=$g(id)
	if $d(^User.MKBICDContrastD(id))
	{
		s sequence=0
		for
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
			q:sequence=""
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
				q:MKBICDRRowid=""
				s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
				s MKBICDSupplement=$lg(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid),5)
				if MKBICDSupplement'=""
				{
					if SResult["]"
					{
						s str=$e(Result,1,*-1)
						s SResult=str_",("_MKBICDSupplement_")]"
					}
					else
					{
						s SResult=SResult_"[("_MKBICDSupplement_")]"
					}
				}
				s:Result'="" Result=Result_"<br/>"_SResult
				s:Result="" Result=SResult
			}
		}
	}
	else
	{
		q ""
	}
	q Result
}

/// Creator:李得原
/// CreatDate:2019-08-08
/// Description：
/// Table：User.MKBICDContrast
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).SaveResultRelation()
ClassMethod SaveResultRelation(rowid As %String, flag As %String)
{
	s obj=##class(User.MKBICDContrast).%OpenId(rowid)
	s obj.MKBICDResultRelation=flag
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		set result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Tro
		set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
		
	}
	q result
}

/// Creator:石萧伟
/// CreatDate:2019-08-21
/// Description：判断中心词是否封闭
/// Table：User.Term
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).JustTermClose()
ClassMethod JustTermClose(rowid As %String)
{
	q:rowid="" ""
	s MKBTActiveFlag=$lg($g(^User.MKBTermD(rowid)),9)
	q MKBTActiveFlag
}

/// Creator：李得原
/// CreatDate: 2019-08-29
/// Description：
/// Table：通过版本描述获取版本描述和id
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDContrast","GetICDEdition","6.01")
Query GetICDEdition(desc As %String) As %Query(ROWSPEC = "MKBTRowid,MKBTDesc")
{
}

ClassMethod GetICDEditionExecute(ByRef qHandle As %Binary, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	if MKBTBRowid=""
	{
		s MKBTDesc=""
		d OutputRow
	}
	else
	{
		if desc'=""
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
				q:MKBTRowid=""
				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 标识",0)) //标识的属性id
				s:MKBTPRowid'="" MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0)) //标识的属性值id
				s:MKBTPDRowid'="" TPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3) //标识值
				continue:TPDDesc'="诊断"
				s MKBTDesc=$Lg($g(^User.MKBTermD(MKBTRowid)),3)
				if MKBTDesc[desc
				{
					d OutputRow
				}
			}
		}
		else
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
				q:MKBTRowid=""
				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 标识",0)) //标识的属性id
				s:MKBTPRowid'="" MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0)) //标识的属性值id
				s:MKBTPDRowid'="" TPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3) //标识值
				continue:TPDDesc'="诊断"
				s MKBTDesc=$Lg($g(^User.MKBTermD(MKBTRowid)),3)
				d OutputRow
			}
		}
	}
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTRowid,MKBTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDEditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDEditionExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDEditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDEditionExecute ]
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

/// Creater:李得原
/// Date:2019-08-30
/// Description:各版本icd对照中取icd版本界面的是否默认值为是的id
/// w ##class(web.DHCBL.MKB.MKBICDContrast).getYesOrNot()
ClassMethod getYesOrNot()
{
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	q:MKBTBRowid="" "" //不存在ICD版本知识库的时候返回""
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		q:MKBTRowid=""
		s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 标识",0)) //标识的属性id
		continue:MKBTPRowid="" 
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0)) //标识的属性值id
		continue:MKBTPDRowid="" 
		s TPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3) //标识值
		continue:TPDDesc'="诊断"
		s MKBTPDFRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 是否默认",0))
		continue:MKBTPDFRowid=""
		s MKBTPDDFRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPDFRowid,0))
		if MKBTPDDFRowid'=""
		{
			s MKBTPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDDFRowid)),3)
			if MKBTPDDesc="是"
			{
				q 
			}
		}
	}
	q MKBTRowid
}

/// Creator:张云越
/// CreatDate:2019-12-06
/// Description：获取结构化数据和父表 最优ICD设置所需判断数据(目前就默认判断第一条结构化结果)
/// Input：id 父表id 
/// Return：空值 OR result_"*"_parid
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).GetDescAndParid(31309)
ClassMethod GetDescAndParid(id As %String)
{
	s MKBICDConChild=0
	s seq=-1
	s seq=$O(^User.MKBICDContrastResultI("SeqIndex",id,seq))
	q:seq="" ""
	s MKBICDConChild=$O(^User.MKBICDContrastResultI("SeqIndex",id,seq,MKBICDConChild))
	q:MKBICDConChild="" ""	
	s TermId=$LG($G(^User.MKBICDContrastD(id,"MKBICDContrastResult",MKBICDConChild)),4)
	s ResultId=$LG($G(^User.MKBICDContrastD(id,"MKBICDContrastResult",MKBICDConChild)),2) 
	s:ResultId="" ResultId=-100000000000000
	k arr
	k sort
	s sort(TermId,ResultId)=""
	
	s MKBICDConId=0
	for //遍历ICD对照表
	{
		s MKBICDConId=$O(^User.MKBICDContrastResultI("SortIndex",TermId,ResultId,MKBICDConId))
		q:MKBICDConId=""
		s Child=0
		for
		{
			s Child=$O(^User.MKBICDContrastResultI("SortIndex",TermId,ResultId,MKBICDConId,Child))
			q:Child=""
			s tseq=-1
			s tseq=$O(^User.MKBICDContrastResultI("SeqIndex",MKBICDConId,tseq))
			s tMKBICDConChild=$O(^User.MKBICDContrastResultI("SeqIndex",MKBICDConId,tseq,0))
			continue:Child'=tMKBICDConChild
			s:MKBICDConId'=id arr(MKBICDConId)=""	
		}
		
	}	

	s result=""
	s parid=0
	for
	{
		s parid=$O(arr(parid))
		q:parid=""

		s InitFlag=$LG($G(^User.MKBICDContrastD(parid)),17)
		if (InitFlag="Y")
		{
			s result=$LG($G(^User.MKBICDContrastD(parid)),3) //描述
			s Sources=$lg($g(^User.MKBICDContrastD(parid)),6) //数据来源
			s sourcelen=$l(Sources,"&")
			s MKBICDSource=""
			for i=1:1:sourcelen
			{
				s Source=$p(Sources,"&",i)
				continue:Source=""
				s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
				s:MKBICDSource'="" MKBICDSource=MKBICDSource_"&"_SourceString
				s:MKBICDSource="" MKBICDSource=SourceString
			}
			s result = result_"*"_parid_"*"_MKBICDSource
		}	
	}
	q result
}

/// Creator:张云越
/// CreatDate:2019-12-06
/// Description:最优icd维护
/// Input: 对照表id和MKBICDInitialICD(Y/N)
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBICDContrast).InitialICDUpdate(45349,"Y")
ClassMethod InitialICDUpdate(rowid As %String, MKBICDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBICDContrast).%OpenId(rowid)        ;先备份再更新
		/*
		s bobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s bobj.MKBSDInitialICD=obj.MKBSDInitialICD
		s Diag=obj.MKBSDDiag
		
		s eobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s eobj.MKBSDInitialICD=MKBSDInitialICD
		*/
		Set UpdateDate=$p($h,",",1)       //上传日期
		if ($d(%session)>0)
		{
			Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		}
	    	else
	    	{
		    	Set UpdateUserDR=1   //上传人	
	    	}
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
			;d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrast","User.MKBICDContrast","各版本ICD对照-最优ICD维护",id,Diag,"U",eobj,bobj)
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

/// Creator:张云越
/// CreatDate:2019-12-10
/// Description：获取结构化数据相同的父表字段初始icd是否标志为Y
/// Input：id 父表id 
/// Return：1 有Y值  0 无Y值
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).findInitialICD(15614)
ClassMethod findInitialICD(id As %String)
{

	s MKBSDChild=0
	s seq=-1
	s seq=$O(^User.MKBSICDContrastResultI("SeqIndex",id,seq))
	q:seq="" ""
	s MKBSDChild=$O(^User.MKBICDContrastResultI("SeqIndex",id,seq,MKBSDChild))
	q:MKBSDChild="" ""	
	
	s TermId=$LG($G(^User.MKBICDContrastD(id,"MKBSDStructResult",MKBSDChild)),4)
	s ResultId=$LG($G(^User.MKBICDContrastD(id,"MKBSDStructResult",MKBSDChild)),2)
	s:ResultId="" ResultId=-100000000000000
	s sort(TermId,ResultId)=""
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBICDContrastResultI("SortIndex",TermId,ResultId,MKBSDRowId))
		q:MKBSDRowId=""
		
		s Child=0
		for
		{
			s Child=$O(^User.MKBICDContrastResultI("SortIndex",TermId,ResultId,MKBSDRowId,Child))
			q:Child=""
			
			s tseq=-1
			s tseq=$O(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowId,tseq))
			s tMKBSDChild=$O(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowId,tseq,0))
			continue:Child'=tMKBSDChild
			s:MKBSDRowId'=id arr(MKBSDRowId)=""	
		}
		
	}	

	s result=""
	s parid=0
	for
	{
		s parid=$O(arr(parid))
		q:parid=""
		
		/*
		s subnum=0
		s sub=0
		for
		{
			s sub=$O(^User.MKBStructuredDataD(parid,"MKBSDStructResult",sub))
			q:sub=""
			
			s seq=-1
			s seq=$O(^User.MKBStructuredDataResultI("SeqIndex",id,seq))
			continue:seq=""
			s MKBSDChild=$O(^User.MKBStructuredDataResultI("SeqIndex",id,seq,MKBSDChild))
			
			s subnum=subnum+1
		}
		continue:subnum'=num
		*/
		
	
		s InitFlag=$LG($G(^User.MKBICDContrastD(parid)),17)
		if (InitFlag="Y")
		{
			s result=$LG($G(^User.MKBICDContrastD(parid)),3)
			s result = result_"*"_parid
		}	
	}
	q result
}

/// Creator：      	张云越
/// CreatDate：    	2020-04-24
/// Description:     导出各版本ICD界面中的ICD描述、ICD编码和结构化描述,多个结构化描述之间用AND、OR连接
/// Table：          User.MKBICDContrast User.MKBICDContrastResult
/// Input：          ICDDiaSource ：诊断短语数据来源id
/// Output：         文件名 fileName
/// Others：        w ##class(web.DHCBL.MKB.MKBICDContrast).ExportICDConData(526477)
ClassMethod ExportICDConData(ICDDiaSource As %String) As %String
{
	s sum=0
	s DiaSourceDesc=$lg($g(^User.MKBTermD(ICDDiaSource)),3)   //诊断来源描述 
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=DiaSourceDesc_"各版本ICD对照数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("ICD描述,ICD编码,结构化结果")
	s MKBICDRowId=0    
	for           //遍历各版本ICD对照表
	{
		s MKBICDRowId = $o(^User.MKBICDContrastD(MKBICDRowId))
		q:MKBICDRowId=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),6)  //诊断短语数据来源
		if (MKBICDDiaSource'[ICDDiaSource)   //过滤掉不是该版本的数据
		{
			continue
		}
		s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),3)   //ICD描述
		continue:MKBICDConDesc=""
		s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),4) //ICD编码
		s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),19) //诊断1 2 3之间的关系 AND OR
		s sequence="" 
		s Result=""
		for //通过顺序查找子表id
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,sequence)) 
			q:sequence=""
			s MKBICDResultId=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,sequence,0)) //通过父表ID和顺序找到子表ID
			continue:MKBICDResultId=""
			s MKBICDResult=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),2)  //结构化结果的ID串
			s MKBICDTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),4) //中心词
			s ICDResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDResult,MKBICDTerm)  //结构化结果描述
			if MKBICDResultRelation="" //如果关系为空则用空格分隔
			{
				s:Result'="" Result=Result_" "_ICDResult
				s:Result="" Result=ICDResult
			}
			else //如果关系不为空则用AND OR分隔
			{
				s:Result'="" Result=Result_" "_MKBICDResultRelation_" "_ICDResult
				s:Result="" Result=ICDResult
			}
		}
		//将英文逗号转换为中文逗号
		s MKBICDConDesc=$replace(MKBICDConDesc,",","，")
		s MKBICDNumber=$replace(MKBICDNumber,",","，")
		s Result=$replace(Result,",","，")
		
		s str=MKBICDConDesc_","_MKBICDNumber_","_Result
		d file.WriteLine(str)
		s sum = sum+1
	}
	d file.%Save()
	d file.%Close()
	//w sum 
	//q "{fileName:"""_fileName_"""}"
	q fileName
}

/// Creator：钟荣枫
/// CreatDate: 2021-8-4
/// Description：导出各版本ICD界面中的国标2.0里存在多个结构化描述的数据,多个结构化描述之间用AND、OR连接
/// Table：          User.MKBICDContrast User.MKBICDContrastResult
/// Input：      
/// Output：         文件名 fileName
/// d ##class(web.DHCBL.MKB.MKBICDContrast).ExportICDConDataTXT()   
ClassMethod ExportICDConDataTXT() As %String
{
   	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="各版本icd对照数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName
	
    o file:"WNS"
    u file
    w "ICD描述^ICD编码^结构化结果^数据来源"		
   
    s sum=0
    s MKBICDRowId=0    
	for           //遍历各版本ICD对照表
	{
		s MKBICDRowId = $o(^User.MKBICDContrastD(MKBICDRowId))
		q:MKBICDRowId=""
		s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),6)		//诊断短语数据来源
		s MKBICDSource=""
		for i=1:1:$l(Sources,"&")
		{
			s Source=$p(Sources,"&",i)
			continue:Source=""
			s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
			s:MKBICDSource'="" MKBICDSource=MKBICDSource_"&"_SourceString
			s:MKBICDSource="" MKBICDSource=SourceString
		}
	
		s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),3)   //ICD描述
		continue:MKBICDConDesc=""
		s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),4) //ICD编码
		s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),19) //诊断1 2 3之间的关系 AND OR
		s flag=0
		s sequence="" 
		
		s Result=""
		for //通过顺序查找子表id
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,sequence)) 
			q:sequence=""
			s MKBICDResultId=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,sequence,0)) //通过父表ID和顺序找到子表ID
			continue:MKBICDResultId=""
			s MKBICDResult=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),2)  //结构化结果的ID串
			s MKBICDTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),4) //中心词
			s ICDResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDResult,MKBICDTerm)  //结构化结果描述
			if MKBICDResultRelation="" //如果关系为空则用空格分隔
			{
				if (Result'="")
				{
					s Result=Result_" "_ICDResult
					s flag=1
				}
				else
				{
					s Result=ICDResult
				}
			}
			else //如果关系不为空则用AND OR分隔
			{
				if (Result'="")
				{
					s Result=Result_" "_MKBICDResultRelation_" "_ICDResult
					s flag=1
				}
				else
				{
					s Result=ICDResult
				}
			}
		}
		continue:(flag=0)
		w !,MKBICDConDesc_"^"_MKBICDNumber_"^"_Result_"^"_MKBICDSource  //注意此处连接符是tab
		s sum = sum+1
	}
	
	c file
	Q fileName
}

/// Creator：钟荣枫
/// CreatDate: 2021-8-20
/// Description：批处理各版本icd对照里的结构化结果，默认都是或，有且的显示且
/// Table：          User.MKBICDContrast User.MKBICDContrastResult
/// Input：      
/// Output：   失败返回“false”，成功返回修改条数
/// w ##class(web.DHCBL.MKB.MKBICDContrast).HandleStructResult()  
ClassMethod HandleStructResult()
{
	s result=""
	s errorflag=0
	ts
	s updatecount=0
	s MKBICDRowId=0    
	for           //遍历各版本ICD对照表
	{
		s MKBICDRowId = $o(^User.MKBICDContrastD(MKBICDRowId))
		q:MKBICDRowId=""
		q:errorflag=1
		continue:$d(^User.MKBICDContrastI("StructIndex",-100000000000000,MKBICDRowId))
		continue:'$d(^User.MKBICDContrastD(MKBICDRowId))
		s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),19) //诊断1 2 3之间的关系 AND OR
		s count=0
		s Result=""
		s sequence=""
		for //通过顺序查找子表id
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,sequence)) 
			q:sequence=""
			s MKBICDResultId=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,sequence,0)) //通过父表ID和顺序找到子表ID
			continue:MKBICDResultId=""
			s MKBICDResult=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),2)  //结构化结果的ID串
			s MKBICDTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),4) //中心词
			s ICDResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDResult,MKBICDTerm)  //结构化结果描述
			s count=count+1
		}
		if ((count>=2)&&(MKBICDResultRelation=""))
		{
			s updatecount=updatecount+1
			s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowId) 
			s obj.MKBICDResultRelation="OR"
			s re= obj.%Save()
			d obj.%Close()
			s:re'=1 errorflag=1
		}
	}
	if (errorflag=1)
	{
		tro
		s result="false"
	}
	else
	{
		tc
		s result=updatecount	
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2021-9-10
/// Description：ICD编码和扩展编码做合并，暂时不做数据更新，只生成临时global
/// Table：          User.MKBICDContrast User.MKBICDContrastResult
/// Input：      
/// Output：   失败返回“false”，成功返回修改条数
/// w ##class(web.DHCBL.MKB.MKBICDContrast).MergeICDAndExtendICD()  
ClassMethod MergeICDAndExtendICD()
{
	k ^TEMPMergeICD
	s count=0
	s MKBICDRowid=""
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		s sourcelen=$l(Sources,"&")
		s MKBICDSource=""
		for i=1:1:sourcelen
		{
			s Source=$p(Sources,"&",i)
			continue:Source=""
			s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
			s:MKBICDSource'="" MKBICDSource=MKBICDSource_"&"_SourceString
			s:MKBICDSource="" MKBICDSource=SourceString
		}
		continue:MKBICDSource'["疾病分类与代码国家临床版2.0"
		s MKBICDCode=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),2)
		s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
		
		s MKBICDConNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
		s MKBICDConExtendNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),5)
		if ((MKBICDConNumber'="")&&(MKBICDConExtendNumber'=""))
		{
			if (MKBICDConNumber'[MKBICDConExtendNumber)		//主要编码里不包含扩展编码
			{
				s count=count+1
				s ^TEMPMergeICD("old",MKBICDRowid,MKBICDConNumber,MKBICDConExtendNumber)=""
				s NewMKBICDConNumber=MKBICDConNumber_"+"+MKBICDConExtendNumber
				s ^TEMPMergeICD("new",MKBICDRowid,NewMKBICDConNumber)=""
			}
		}
		elseif ((MKBICDConNumber="")&&(MKBICDConExtendNumber'=""))
		{
			s count=count+1
			s ^TEMPMergeICD("old",MKBICDRowid," ",MKBICDConExtendNumber)=""
			s NewMKBICDConNumber=MKBICDConExtendNumber
			s ^TEMPMergeICD("new",MKBICDRowid,NewMKBICDConNumber)=""
		}
	}
	q count
}

/// Creator:zrf    
/// CreatDate:2021-9-10  
/// Description：删除父表的同时删除子表数据	 		
/// Table：User.MKBICDContrast
/// Input： id 父表id
/// Return：true 或false
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).DeleteDataAndChild(4385)
ClassMethod DeleteDataAndChild(id)
{
	s result=""
	if (id'="")
	{
		
		s pobj=##class(User.MKBICDContrast).%OpenId(id)
		s bobj = ##class(web.Entity.MKB.MKBICDContrast).%New()
		s bobj.MKBSDRowid=id
		
		s bobj.MKBICDConCode=pobj.MKBICDConCode		/// ICD诊断code
		s bobj.MKBICDConDesc=pobj.MKBICDConDesc		/// ICD描述
		s bobj.MKBICDConNumber=pobj.MKBICDConNumber	/// ICD主要编码
		s bobj.MKBICDConExtendNumber=pobj.MKBICDConExtendNumber		/// ICD扩展编码
		s bobj.MKBICDDiaSource=pobj.MKBICDDiaSource		/// ICD来源标识
		s bobj.MKBICDConType=pobj.MKBICDConType		/// ICD类别
		s bobj.MKBICDConCenterWordID=pobj.MKBICDConCenterWordID		/// 匹配到的参考中心词	
		s:pobj.MKBICDTermDr'="" bobj.MKBICDTermDr = pobj.MKBICDTermDr.%Id()	/// 国际码指向Term表
		
		s bobj.MKBICDRemark=pobj.MKBICDRemark		/// 国际码标记
		s bobj.MKBICDConSegmentation=pobj.MKBICDConSegmentation		/// 分词结果
		
		s bobj.MKBICDConStatus=pobj.MKBICDConStatus		/// 是否处理
		s bobj.MKBICDConDate=pobj.MKBICDConDate		/// 操作时间

		s:pobj.MKBICDConUpdateUser'="" bobj.MKBICDConUpdateUser = pobj.MKBICDConUpdateUser.%Id()	/// 操作人
		s bobj.MKBICDOther=pobj.MKBICDOther		/// 备用
		s bobj.MKBICDChildStructFlag=pobj.MKBICDChildStructFlag		/// 标识有没有结构化，1为结构化

		s bobj.MKBICDInitialICD=pobj.MKBICDInitialICD		/// 初始ICD
		s bobj.MKBICDResultRelation=pobj.MKBICDResultRelation		/// 诊断1 2 3之间的关系 AND OR

		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.MKBICDContrast).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			d ..DelChildOfData(id)	//删除子表
			//删除全文索引
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteICDIndexByCode(id)
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrast","User.MKBICDContrast","各版本icd对照",id,bobj.MKBICDConDesc,"D",bobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.MKB.SysErrorLog).SaveLog("各版本icd对照","web.DHCBL.MKB.MKBICDContrast","DeleteDataAndChild",bobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		set result = "{success:'false',info:'id为空！'}"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-9-10
/// Description：删除某条数据的子表数据
/// Input：rowid   各版本icd对照数据的id
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBICDContrast).DelChildOfData(3)
ClassMethod DelChildOfData(rowid)
{
	s errorflag=0
	q:rowid="" 1
	//User.MKBICDContrastResult	结构化数据子表
	//删除关联的结构化数据子表数据
	s StructID=0
	for
	{
		s StructID=$o(^User.MKBICDContrastD(rowid,"MKBICDContrastResult",StructID))
		q:StructID=""
		q:errorflag=1
		s RowID=rowid_"||"_StructID
			
		s structre=..DeleteData(RowID)
		s:structre["false" errorflag=1
		
	}
	q errorflag
}

/// Creator:基础数据平台组 钟荣枫
/// CreateDate:2021-9-13  
/// / Description：用于实现数据校验功能的方法
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.MKB.MKBICDContrast).FormValidate("","","")
ClassMethod FormValidate(id As %String, desc As %String, icdcode As %String) As %String
{
	//Index UniqueIndex On (MKBICDConDesc As Exact, MKBICDConNumber As Exact);
	s flag="",flagc="",flagd=""
	
	s:((desc'="")&&(icdcode'="")) flagc=$d(^User.MKBICDContrastI("UniqueIndex",desc,icdcode))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) 
		{
			s flag=1  //返回重复标志
		}
		else  
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:((desc'="")&&(icdcode'="")) idc=$o(^User.MKBICDContrastI("UniqueIndex",desc,icdcode,0))
		
		if ((idc'="")&(idc'=id)&(flagc>0)) 
		{
			s flag=1  //返回重复标志
		}
		else  
		{
			s flag=0 //返回不重复标志
		}

	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate: 2021-9-13
/// Description：保存各版本icd对照父表数据
/// Input: eobj As web.Entity.MKB.MKBICDContrast
/// Table:User.MKBICDContrast
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.MKB.MKBICDContrast).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBICDContrast) As %String
{
	if $IsObject(eobj)
	{	
		s:eobj.MKBICDDiaSource["," eobj.MKBICDDiaSource=$tr(eobj.MKBICDDiaSource,",","&")
		s:eobj.MKBICDConDate'="" eobj.MKBICDConDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MKBICDConDate)
		s:eobj.MKBICDConDate="" eobj.MKBICDConDate=+$h
		//Index UniqueIndex On (MKBICDConDesc As Exact, MKBICDConNumber As Exact);
		s flag=..FormValidate(eobj.MKBSDRowid,eobj.MKBICDConDesc,eobj.MKBICDConNumber)  //调用重复验证
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该诊断数据已存在！'}"
			q result	
		}
		
		if (eobj.MKBSDRowid="")
		{
			s obj=##class(User.MKBICDContrast).%New()
		}
		else
		{
			
			s obj=##class(User.MKBICDContrast).%OpenId(eobj.MKBSDRowid)
			s bobj = ##class(web.Entity.MKB.MKBICDContrast).%New()
			s bobj.MKBSDRowid=eobj.MKBSDRowid
			
			s bobj.MKBICDConCode=obj.MKBICDConCode		/// ICD诊断code
			s bobj.MKBICDConDesc=obj.MKBICDConDesc		/// ICD描述
			s bobj.MKBICDConNumber=obj.MKBICDConNumber	/// ICD主要编码
			s bobj.MKBICDConExtendNumber=obj.MKBICDConExtendNumber		/// ICD扩展编码
			s bobj.MKBICDDiaSource=obj.MKBICDDiaSource		/// ICD来源标识
			s bobj.MKBICDConType=obj.MKBICDConType		/// ICD类别
			s bobj.MKBICDConOption=obj.MKBICDConOption		//ICD录入选项
			s bobj.MKBICDConCenterWordID=obj.MKBICDConCenterWordID		/// 匹配到的参考中心词	
			s:obj.MKBICDTermDr'="" bobj.MKBICDTermDr = obj.MKBICDTermDr.%Id()	/// 国际码指向Term表
			
			s bobj.MKBICDRemark=obj.MKBICDRemark		/// 国际码标记
			s bobj.MKBICDConSegmentation=obj.MKBICDConSegmentation		/// 分词结果
			
			s bobj.MKBICDConStatus=obj.MKBICDConStatus		/// 是否处理
			s bobj.MKBICDConDate=obj.MKBICDConDate		/// 操作时间

			s:obj.MKBICDConUpdateUser'="" bobj.MKBICDConUpdateUser = obj.MKBICDConUpdateUser.%Id()	/// 操作人
			s bobj.MKBICDOther=obj.MKBICDOther		/// 备用
			s bobj.MKBICDChildStructFlag=obj.MKBICDChildStructFlag		/// 标识有没有结构化，1为结构化

			s bobj.MKBICDInitialICD=obj.MKBICDInitialICD		/// 初始ICD
			s bobj.MKBICDResultRelation=obj.MKBICDResultRelation		/// 诊断1 2 3之间的关系 AND OR
			
			s MKBICDRRowid=$o(^User.MKBICDContrastD(eobj.MKBSDRowid,"MKBICDContrastResult",""))
			s:MKBICDRRowid'="" eobj.MKBICDChildStructFlag=1
		}
		s obj.MKBICDConCode=eobj.MKBICDConCode		/// ICD诊断code
		s obj.MKBICDConDesc=eobj.MKBICDConDesc		/// ICD描述
		s obj.MKBICDConNumber=eobj.MKBICDConNumber	/// ICD主要编码
		s obj.MKBICDConExtendNumber=eobj.MKBICDConExtendNumber		/// ICD扩展编码
		s obj.MKBICDDiaSource=eobj.MKBICDDiaSource		/// ICD来源标识
		s obj.MKBICDConType=eobj.MKBICDConType		/// ICD类别
		s obj.MKBICDConOption=eobj.MKBICDConOption		//ICD录入选项
		s obj.MKBICDConCenterWordID=eobj.MKBICDConCenterWordID		/// 匹配到的参考中心词	
		d:eobj.MKBICDTermDr'="" obj.MKBICDTermDrSetObjectId(eobj.MKBICDTermDr)	/// 国际码指向Term表
		d:eobj.MKBICDTermDr="" obj.MKBICDTermDrSetObjectId("")
		
		s obj.MKBICDRemark=eobj.MKBICDRemark		/// 国际码标记
		s obj.MKBICDConSegmentation=eobj.MKBICDConSegmentation		/// 分词结果
		
		s obj.MKBICDConStatus=eobj.MKBICDConStatus		/// 是否处理
		s obj.MKBICDConDate=eobj.MKBICDConDate		/// 操作时间
		
		d obj.MKBICDConUpdateUserSetObjectId(%session.Get("LOGON.USERID"))
		//d:eobj.MKBICDConUpdateUser'="" obj.MKBICDConUpdateUserSetObjectId(eobj.MKBICDConUpdateUser)	/// 操作人
		//d:eobj.MKBICDConUpdateUser="" obj.MKBICDConUpdateUserSetObjectId("")
		
		s obj.MKBICDOther=eobj.MKBICDOther		/// 备用
		s obj.MKBICDChildStructFlag=eobj.MKBICDChildStructFlag		/// 标识有没有结构化，1为结构化
		s:eobj.MKBICDInitialICD'="" obj.MKBICDInitialICD=eobj.MKBICDInitialICD		/// 初始ICD
		s:eobj.MKBICDResultRelation'="" obj.MKBICDResultRelation=eobj.MKBICDResultRelation		/// 诊断1 2 3之间的关系 AND OR
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			//保存日志
			if (eobj.MKBSDRowid="")		//添加全文索引
			{
				s re= ##class(web.DHCBL.MKB.MKBStructIndex).SaveICDIndexByCode(id)
				d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrast","User.MKBICDContrast","各版本icd对照",id,eobj.MKBICDConDesc,"A",eobj)
			}
			else		//删除原先的全文索引后，重新生成
			{
				d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteICDIndexByCode(id)
				d ##class(web.DHCBL.MKB.MKBStructIndex).SaveICDIndexByCode(id)
				d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("MKB_ICDContrast","User.MKBICDContrast","各版本icd对照",id,eobj.MKBICDConDesc,"U",eobj,bobj)
			}
			
		}else{
			tro
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.DHCBL.MKB.SysErrorLog).SaveLog("各版本icd对照","web.DHCBL.MKB.MKBICDContrast","SaveEntity",eobj)
       			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-9-13
/// Description：获取修改时的记录
/// Input：id-各版本icd对照的id
/// Return：Json格式的 字段和值
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).OpenData(45348)
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj=##class(User.MKBICDContrast).%OpenId(id)
	s bobj = ##class(web.Entity.MKB.MKBICDContrast).%New()
	s bobj.MKBSDRowid=id
	
	s bobj.MKBICDConCode=pobj.MKBICDConCode		/// ICD诊断code
	s bobj.MKBICDConDesc=pobj.MKBICDConDesc		/// ICD描述
	s bobj.MKBICDConNumber=pobj.MKBICDConNumber	/// ICD主要编码
	s bobj.MKBICDConExtendNumber=pobj.MKBICDConExtendNumber		/// ICD扩展编码
	s bobj.MKBICDDiaSource=pobj.MKBICDDiaSource		/// ICD来源标识
	s bobj.MKBICDDiaSource=$tr(bobj.MKBICDDiaSource,"&",",")
	
	s bobj.MKBICDConType=pobj.MKBICDConType		/// ICD类别
	s bobj.MKBICDConOption=pobj.MKBICDConOption		//ICD录入选项
	s bobj.MKBICDConCenterWordID=pobj.MKBICDConCenterWordID		/// 匹配到的参考中心词	
	s:pobj.MKBICDTermDr'="" bobj.MKBICDTermDr = pobj.MKBICDTermDr.%Id()	/// 国际码指向Term表
	
	s bobj.MKBICDRemark=pobj.MKBICDRemark		/// 国际码标记
	s bobj.MKBICDConSegmentation=pobj.MKBICDConSegmentation		/// 分词结果
	
	s bobj.MKBICDConStatus=pobj.MKBICDConStatus		/// 是否处理
	s bobj.MKBICDConDate=pobj.MKBICDConDate		/// 操作时间

	s:pobj.MKBICDConUpdateUser'="" bobj.MKBICDConUpdateUser = pobj.MKBICDConUpdateUser.%Id()	/// 操作人
	s bobj.MKBICDOther=pobj.MKBICDOther		/// 备用
	s bobj.MKBICDChildStructFlag=pobj.MKBICDChildStructFlag		/// 标识有没有结构化，1为结构化

	s bobj.MKBICDInitialICD=pobj.MKBICDInitialICD		/// 初始ICD
	s bobj.MKBICDResultRelation=pobj.MKBICDResultRelation		/// 诊断1 2 3之间的关系 AND OR
	s str = bobj.JsonS()	
	q str
}

/// Creator:钟荣枫
/// CreatDate:2021-9-13
/// Description：批处理结构化结果的关联关系  当结构化结果为空或者只有一个的时候，关联关系改为空
/// Input：
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).HandleRelation()
ClassMethod HandleRelation()
{
	s result=""
	s errorflag=0
	s updatecount=0
	ts
	s MKBICDRowid=""
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		q:errorflag=1
		s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),19)
		s count=0
		s MKBICDRRowid=""
		for
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
			q:MKBICDRRowid=""
			s count=count+1
		}
		if (((count=0)||(count=1))&&(MKBICDResultRelation'=""))	//只有一个结构化结果
		{
			s updatecount=updatecount+1
			s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
			s obj.MKBICDResultRelation=""
			s re= obj.%Save()
			d obj.%Close()
			if (re=0)
			{
				s errorflag=1
			}
		}
		
	}
	if (errorflag=1)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result=updatecount
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-12-30
/// Description：批量删除诊断的结构化结果
/// Input：str id串
/// Return：true  或false
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrast).DelResultOfIDStr("64621,64622,64623")
ClassMethod DelResultOfIDStr(str)
{
	q:str="" "false"
	s result=""
	s errorflag=0
	
	for m=1:1:$l(str,",")
	{
		s ID=$p(str,",",m)
		q:errorflag=1
		continue:ID=""
		s Oneresult=..DelChildOfData(ID)
		s:Oneresult=1 errorflag=1
	}
	if (errorflag=1)
	{
		s result="false"	
	}
	else
	{
		s result="true"	
	}
	q result
}

}

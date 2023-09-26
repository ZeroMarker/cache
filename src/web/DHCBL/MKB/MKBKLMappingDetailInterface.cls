Class web.DHCBL.MKB.MKBKLMappingDetailInterface Extends %RegisteredObject
{

/*
/// 李德原
/// 通过ICD代码和描述找MRCID的rowid
ClassMethod GetMRCIDByCodeDesc(code, desc)
{
	q:((code="")||(desc="")) ""
	s code=$zstrip(code,"<>W")
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(desc),MRCRowid))
		q:MRCRowid=""
		s Code=$p(^MRC("ID",MRCRowid),"^",4)
		if Code=code
		{
			q 
		}
	}
	q MRCRowid
}*/
/// 谷雪萍
/// Debug：w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetMRCIDByCodeDesc("A01.005+","伤寒性肝炎")
ClassMethod GetMRCIDByCodeDesc(code, desc)
{
	q:((code="")||(desc="")) ""
	s code=$zstrip(code,"<>W")
	s hisMRCID=""
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(desc),MRCRowid))
		q:MRCRowid=""
		s MRCIDValid=$P($G(^MRC("ID",MRCRowid)),"^",27)
		continue:(MRCIDValid="N")
		s MRCIDDateActiveFrom=$P($G(^MRC("ID",MRCRowid)),"^",6)
		s MRCIDDateActiveTo=$p($g(^MRC("ID",MRCRowid)),"^",7)
		continue:(MRCIDDateActiveFrom'="")&&(MRCIDDateActiveFrom>+$H)
		continue:(MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h)
		s hisMRCID=MRCRowid
		/*s Code=$p(^MRC("ID",MRCRowid),"^",4)
		if Code=code
		{
			q 
		}*/
	}
	q hisMRCID
}

/// Author:lixin
/// Date: 20181227
/// Desc:获取匹配到的第一条ICD
/// Debug：w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetFirstCMBICD(1,"14870-4998:10668")
ClassMethod GetFirstCMBICD(version, str)
{
	s result = ""
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCBL.MKB.MKBKLMappingDetailInterface"
	set rs.QueryName="GetICDForCMB"
	set sc=rs.Execute(version,str)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	if rs.%Next() 
	{
		///DiagExp,MRCID,HISCode,HISDesc
		s DiagExp=rs.Data("DiagExp")
		s MRCID=rs.Data("MRCID")
		
		s HISCode=rs.Data("HISCode")
		s HISDesc=rs.Data("HISDesc")
		s result = DiagExp_"^"_MRCID_"^"_HISCode_"^"_HISDesc	
	}
	
	q result
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetICDForCMB","15882")
Query GetICDForCMB(version, str) As %Query(ROWSPEC = "DiagExp,MRCID,HISCode,HISDesc")
{
}

ClassMethod GetICDForCMBExecute(ByRef qHandle As %Binary, version, str) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k unique
	s resultIds = ..GetDiagViaStruct(version,str)
	if (resultIds'="")	
	{
		s MKBSDRowId=0
		for i=1:1:$L(resultIds,",")
		{
			s MKBSDRowId=$P(resultIds,",",i)
			s MergeFlag=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),15)
			continue:MergeFlag'=""
			s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
			s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
			s MRCID = ..GetMRCIDByCodeDesc(ICDCode,ICDDesc)
			
			if ($D(unique(MRCID))=0)
			{
				s unique(MRCID)=""
			}
			else
			{
				continue	
			}
			s sortindex=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,0))
			continue:sortindex=""
			s MKBSDRChild=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,sortindex,0))
				
			if (MKBSDRChild'="")
			{
				s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
				if (MKBSDRTermDr'="")
				{
					s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
					s DiagDesc = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)	
					//多语言改造	
					s DiagDesc=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelatedicd.csp",DiagDesc)
					s ICDDesc=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelatedicd.csp",ICDDesc)
					d OutputRowCMB	
				}
				
			}
		}	
	}
	else
	{
		set rs=##class(%ResultSet).%New()
		set rs.ClassName="web.DHCBL.MKB.MKBKLMappingDetailInterface"
		set rs.QueryName="GetICDForHIS"
		set sc=rs.Execute(str,"")  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
		while rs.%Next() 
		{
			///DiagExp,MRCID,HISCode,HISDesc
			s DiagDesc=rs.Data("DiagExp")
			s MRCID=rs.Data("MRCID")
			
			s ICDCode=rs.Data("HISCode")
			s ICDDesc=rs.Data("HISDesc")
			//多语言改造	
			s DiagDesc=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelatedicd.csp",DiagDesc)
			s ICDDesc=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelatedicd.csp",ICDDesc)
			d OutputRowCMB		
		}
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCMB
    set Data=$lb(DiagDesc,MRCID,ICDCode,ICDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDForCMBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDForCMBExecute ]
{

	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDForCMBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDForCMBExecute ]
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

/// 转换表达式
/// d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).TransExp()
ClassMethod TransExp(Exps)
{
	if (Exps'="")
	{
		s result=""
		if (Exps'["&%")
		{
			if (Exps["-")
			{
				s TermId=$P(Exps,"-",1)
				s ProDets = $P(Exps,"-",2)
				s Pro = $P(ProDets,":",1)
				s Dets=$P(ProDets,":",2)
				s ProType = $LG($G(^User.MKBTermPropertyD(Pro)),4)
				if ((ProType="S")||(ProType="SS"))
				{
					s result=TermId_"-"_Pro_":"
					for i=1:1:$L(Dets,"*")
					{
						s Det = $P(Dets,"*",i)
						s Det=$P(Det,"S",2)
						if (i=1)
						{
							s result=result_"S"_$P(Dets,"*",i)	
						}	
						else
						{
							s result=result_"*S"_$P(Dets,"*",i)	
						}
					}	
				}
				else
				{
					s result=Exps	
				}	
			}
			else
			{
				s result=Exps	
			}	
		}
		q result
	}
}

/// 诊断数据的接口：本科室频次最高的数据先输出，然后再取非本科室
/// Input：desc-根据描述、拼音码查询，rows-每页显示行数 page-第几页
/// return:Json数据 
/// MKBSDRowId:数据处理工厂父表id    MKBSDDesc:诊断描述    MKBSDRRowId：结构化子表ID    MKBSDRTermDr：结构化数据TermId 
/// MKBSDRExpId：结构化表达式ID串    MKBSDRExp:结构化表达式描述   MKBSDRSup:补充诊断
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetTermListForDocViaIndex("心脏病",1,1000,1)
ClassMethod GetTermListForDocViaIndex(desc, version, rows, page)
{
	s result="",total=0,jsonstr=""
	s ICDNSFlag=$LG($G(^User.MKBStructuredBaseD(version)),7)
	w "{""rows"":["
	s endpage=page*rows ///结束行
	s stpage=((page-1)*rows)+1
	
	;s LocId=95
	s LocId=$G(%session.Data("LOGON.CTLOCID"))
	//s LocId=95
	;s ^lee(0)=LocId
	s IsChinaMed=$P($G(^CTLOC(LocId,"DHC")),"^",16)
	s:IsChinaMed="" IsChinaMed=0
	
	s LocDesc = $ZCONVERT($P($G(^CTLOC(LocId)),"^",2),"U")
	//s:desc'="" desc=$zconvert(desc,"U")

	if ($D(^User.MKBStrucuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U")))) //存在当前实际科室
	{
		if (desc'="")
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
					s MKBSDMergeFlag=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),15)
					continue:MKBSDMergeFlag'=""

					continue:$D(^User.MKBStructuredDataI("BaseIndex",version,MKBSDRowId))=0
					s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
					s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
					s ICDDr = ..GetMRCIDByCodeDesc(ICDCode,ICDDesc)
					if (ICDNSFlag'="Y")
					{
						continue:ICDDr=""
						/*
						s MRCIDMetastaticSite=$p($g(^MRC("ID",ICDDr)),"^",40) //肿瘤形态学编码标志
						s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",ICDDr)),"^",41) //损伤中毒外部原因标志		
						continue:MRCIDMetastaticSite="Y"
						continue:MRCIDInjuryPoisoningCode="Y"
						*/	
						s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
						continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	
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
				
				k:tmpdesc(MKBSDRowId)'=tmpnum tmpdesc(MKBSDRowId)	
			}
			s MKBSDRowId=0
			for
			{
				s MKBSDRowId=$O(tmpdesc(MKBSDRowId))
				q:MKBSDRowId=""
				
				//////////////////////////////////////////////////
				;s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
				//////////////////////////////////////////////////
				
				if $d(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U"),MKBSDRowId))   //实际科室频次
				{
					s MKBSDLRowid=$o(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U"),MKBSDRowId,0))
					
					s Fre=$lg($g(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",MKBSDLRowid)),3)
				}
				else
				{
					s Fre=0
				}
				//////////////////////////////////////////////////////////////////////////////////////////
				
				if ($D(^User.MKBStrucuredDataLocI("LocIndex"," "_$ZCONVERT(LocDesc,"U"),MKBSDRowId)))
				{
					s ids(1,Fre,MKBSDRowId)=""	
				}
				else
				{
					s ids(0,Fre,MKBSDRowId)=""	
				}
			}
			
			s flag=0
			s num = 100
			for
			{
				s num=$O(ids(num),-1)
				q:num=""
				
				s fre=""
				for
				{
					s fre=$O(ids(num,fre),-1)
					q:fre=""
					
					s MKBSDRowId=0
					for
					{
						s MKBSDRowId=$O(ids(num,fre,MKBSDRowId))
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
						if (MKBSDRChild'="")
						{
							s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
							if (MKBSDRTermDr'="")
							{
								s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
								s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
								
							}
						
							s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
						}	
						
						s LinkIcd=""
						s LinkIcdCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //在ICD字段取值
						s LinkIcdDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),21)  //在ICD描述字段取值
						s:LinkIcdCode'="" LinkIcd=$o(^MRC("ID",0,"Code",$ZCONVERT(LinkIcdCode,"U"),0))
						s:((LinkIcd="")&(LinkIcdDesc'="")) LinkIcd=$o(^MRC("ID",0,"Desc",$ZCONVERT(LinkIcdDesc,"U"),0))

						s total=total+1
						if (total<stpage) continue
						if (total<=endpage)
						{
							s mainstr="{""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcd"":"""_LinkIcd_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						
							if (flag=0)
							{
								s flag=1
							}
							else
							{
								w ","
							}
							w mainstr	
						}
						
					}	
				}	
			}	
		}
		else
		{
			s Freq=""
			for
			{
				s Freq=$O(^User.MKBStructuredDataLocI("LocFreIndex",$ZCONVERT(LocDesc,"U"),Freq),-1)
				q:Freq=""
				
			
				s MKBSDRowId=0
				for
				{
					s MKBSDRowId=$O(^User.MKBStructuredDataLocI("LocFreIndex",$ZCONVERT(LocDesc,"U"),Freq,MKBSDRowId))
					q:MKBSDRowId=""
					
					s MKBSDMergeFlag=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),15)
					continue:MKBSDMergeFlag'=""
					continue:$D(^User.MKBStructuredDataI("BaseIndex",version,MKBSDRowId))=0
					s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
					s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
					s ICDDr = ..GetMRCIDByCodeDesc(ICDCode,ICDDesc)
					if (ICDNSFlag'="Y")
					{
						continue:ICDDr=""
						/*
						s MRCIDMetastaticSite=$p($g(^MRC("ID",ICDDr)),"^",40) //肿瘤形态学编码标志
						s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",ICDDr)),"^",41) //损伤中毒外部原因标志		
						continue:MRCIDMetastaticSite="Y"
						continue:MRCIDInjuryPoisoningCode="Y"
						*/	
						s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
						continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	
					}
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
					if (MKBSDRChild'="")
					{
						s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
						if (MKBSDRTermDr'="")
						{
							s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)

							s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
							
							s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
						}
					}
					s LinkIcd=""
					s LinkIcdCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //在ICD字段取值
					s LinkIcdDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),21)  //在ICD描述字段取值
					s:LinkIcdCode'="" LinkIcd=$o(^MRC("ID",0,"Code",$ZCONVERT(LinkIcdCode,"U"),0))
					s:((LinkIcd="")&(LinkIcdDesc'="")) LinkIcd=$o(^MRC("ID",0,"Desc",$ZCONVERT(LinkIcdDesc,"U"),0))	
					s total=total+1
					if (total<stpage) continue
					if (total<=endpage)
					{
						s mainstr="{""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcd"":"""_LinkIcd_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						
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
		if (desc'="")
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
					s MKBSDMergeFlag=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),15)
					continue:MKBSDMergeFlag'=""
					continue:$D(^User.MKBStructuredDataI("BaseIndex",version,MKBSDRowId))=0
					s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
					s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
					s ICDDr = ..GetMRCIDByCodeDesc(ICDCode,ICDDesc)
					if (ICDNSFlag'="Y")
					{
						continue:ICDDr=""
						/*
						s MRCIDMetastaticSite=$p($g(^MRC("ID",ICDDr)),"^",40) //肿瘤形态学编码标志
						s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",ICDDr)),"^",41) //损伤中毒外部原因标志		
						continue:MRCIDMetastaticSite="Y"
						continue:MRCIDInjuryPoisoningCode="Y"
						*/	
						s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
						continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	
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
				
				k:tmpdesc(MKBSDRowId)'=tmpnum tmpdesc(MKBSDRowId)	
			}
		
			s MKBSDRowId=0
			for
			{
				s MKBSDRowId=$O(tmpdesc(MKBSDRowId))
				q:MKBSDRowId=""
				
				//////////////////////////////////////////////////
				s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
				//////////////////////////////////////////////////
				s ids(Fre,MKBSDRowId)=""	
				
			}
			
			s flag=0
	
			s fre=""
			for
			{
				s fre=$O(ids(fre),-1)
				q:fre=""
				
				s MKBSDRowId=0
				for
				{
					s MKBSDRowId=$O(ids(fre,MKBSDRowId))
					q:MKBSDRowId=""
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
					if (MKBSDRChild'="")
					{
						s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
						if (MKBSDRTermDr'="")
						{
							s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
							s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)	
						}
				
						s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
					}
					s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
					s LinkIcd=""
					s LinkIcdCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //在ICD字段取值
					s LinkIcdDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),21)  //在ICD描述字段取值
					s:LinkIcdCode'="" LinkIcd=$o(^MRC("ID",0,"Code",$ZCONVERT(LinkIcdCode,"U"),0))
					s:((LinkIcd="")&(LinkIcdDesc'="")) LinkIcd=$o(^MRC("ID",0,"Desc",$ZCONVERT(LinkIcdDesc,"U"),0))
					s total=total+1
					if (total<stpage) continue
					if (total<=endpage)
					{
						s mainstr="{""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcd"":"""_LinkIcd_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						

						if (flag=0)
						{
							s flag=1
						}
						else
						{
							w ","
						}
						w mainstr	
					}
				
				}	
			}			
		}
		else
		{
			s flag=0
			s Freq = 100000000000000000
			for
			{
				s Freq = $O(^User.MKBStructuredDataI("TotalFreqIndex",Freq),-1)	
				q:Freq=""
				
				s MKBDiag=""
				for
				{
					s MKBDiag=	$O(^User.MKBStructuredDataI("TotalFreqIndex",Freq,MKBDiag))
					q:MKBDiag=""
					
					s MKBSDRowId=0
					for
					{
						s MKBSDRowId = $O(^User.MKBStructuredDataI("TotalFreqIndex",Freq,MKBDiag,MKBSDRowId))	
						q:MKBSDRowId=""
							
						continue:$D(^User.MKBStructuredDataI("BaseIndex",version,MKBSDRowId))=0
						s MKBSDDesc=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
						s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
						s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
						s ICDDr = ..GetMRCIDByCodeDesc(ICDCode,ICDDesc)
						if (ICDNSFlag'="Y")
						{
							continue:ICDDr=""
							/*
							s MRCIDMetastaticSite=$p($g(^MRC("ID",ICDDr)),"^",40) //肿瘤形态学编码标志
							s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",ICDDr)),"^",41) //损伤中毒外部原因标志		
							continue:MRCIDMetastaticSite="Y"
							continue:MRCIDInjuryPoisoningCode="Y"
							*/	
							s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
							continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	
						}
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
						if (MKBSDRChild'="")
						{
							s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
							if (MKBSDRTermDr'="")
							{
								s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
								s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
								
							}
						
							s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
						}
	
						s MKBSDPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDesc)	
						s LinkIcd=""
						s LinkIcdCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //在ICD字段取值
						s LinkIcdDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),21)  //在ICD描述字段取值
						s:LinkIcdCode'="" LinkIcd=$o(^MRC("ID",0,"Code",$ZCONVERT(LinkIcdCode,"U"),0))
						s:((LinkIcd="")&(LinkIcdDesc'="")) LinkIcd=$o(^MRC("ID",0,"Desc",$ZCONVERT(LinkIcdDesc,"U"),0))	
						s total=total+1
						if (total<stpage) continue
						if (total<=endpage)
						{
							s mainstr="{""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_""",""LinkIcd"":"""_LinkIcd_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"    						

							if (flag=0)
							{
								s flag=1
							}
							else
							{
								w ","
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
}

/// 李欣20190410
/// 根据结构化数据获取非结构化数据
/// Input：version-数据处理工厂ID，ids-结构化id串;
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStruct("8","14870-4998:10668")
ClassMethod GetDiagViaStruct(version As %String, ids As %String)
{
	s result=""
	q:(version="")||(ids="") ""    //如果数据处理工厂ID或者结构化id串传过来为空，则直接返回空
	//s ICDNSFlag=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSNonstandardICD")  //是否允许非标ICD，因为数据处理工厂现在全都是标准ICD，所以目前不需要该判断了
	//s LocId=96
	//s LocId=$G(%session.Data("LOGON.CTLOCID"))     //获取当前科室
	;s ^lee(0)=LocId
	//s IsChinaMed=$P($G(^CTLOC(LocId,"DHC")),"^",16)  //中医科室
	
	s TermId=$P(ids,"-",1)
	s ProDets=$P(ids,"-",2)
	if (ProDets'="")
	{
		///记录所有传入属性内容
		k dets
		///包含属性内容串个数
		s len = $L(ProDets,",")
		for i=1:1:len
		{
			s subProDets=$P(ProDets,",",i)
			s Pro=$P(subProDets,":",1)
			s Dets=$P(subProDets,":",2)
			for j=1:1:$L(Dets,"*")
			{
				s dets(Pro,$P(Dets,"*",j))=""	   //把传进来的结构化结果属性 属性内容拼串拆分写入到dets中
			}
				
		}
		///记录属性内容个数	
		s detNum=0
		s pro=0
		for
		{
			s pro=$O(dets(pro))
			q:pro=""
			
			s det=0
			for
			{
				s det=$O(dets(pro,det))
				q:det=""
				
				s detNum=detNum+1	    //查看一共有多少个属性内容值
			}	
		}
		///初始权重，每包含其中一个属性内容累加权重
		s initPriority=1/detNum
		
		///计算权重列表
		s pro=0
		for
		{
			s pro=$O(dets(pro))
			q:pro=""
			
			s det=0
			for
			{
				s det=$O(dets(pro,det))
				q:det=""
				
				s dets(pro,det)=initPriority
				
				s protype = $LG($G(^User.MKBTermPropertyD(pro)),4)
				s config=$LG($G(^User.MKBTermPropertyD(pro)),5)
				s contype=""
				if ((protype="S")||(protype="SS"))      //如果为引用术语或引用起始节点  则contype为T
				{
					s contype=$LG($G(^User.MKBTermBaseD(config)),4)	
				}
				///树性结构
				if ((protype="T")||(((protype="SS")||(protype="S"))&&(contype="T")))
				{
					///树形属性
					if (protype="T")                       //如果为树形  获取上下级节点的属性内容权重
					{
						///先找出所有上级节点
						s tmp=det
						s tmpPrio=1
						while($LG($G(^User.MKBTermProDetailD(tmp)),4)'="")
						{
							s par=$LG($G(^User.MKBTermProDetailD(tmp)),4)
							s tmpPrio=tmpPrio-0.1
							s dets(pro,par)=initPriority*tmpPrio
							s tmp=par
						}
						
						/*///所有下级节点权重暂等于当前节点
						s childs = ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(det,pro)
						if (childs'="")
						{
							for k=1:1:$L(childs,"^")
							{
								s dets(pro,$P(childs,"^",k))=initPriority	
							}		
						}*/ //zhongrongfeng
							
					}
					elseif (protype="SS")||(protype="S")     //如果为引用术语或者引用起始节点，获取上下级节点的属性内容权重
					{
						//当前选中的TermId
						s curTemrId=$P(det,"S",2)
						
						///找出所有上级节点
						s tmp=curTemrId
						s tmpPrio=1
						while($LG($G(^User.MKBTermD(tmp)),5)'="")
						{
							s par=$LG($G(^User.MKBTermD(tmp)),5)
							s tmpPrio=tmpPrio-0.1
							s dets(pro,"S"_par)=initPriority*tmpPrio
							s tmp=par
						}	
						
						/*///所有下级节点暂定权重不变
						
						s childs = ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(config,curTemrId)
						if (childs'="")
						{
							for k=1:1:$L(childs,"^")
							{
								s dets(pro,"S"_$P(childs,"^",k))=initPriority	
							}		
						}*/ //zhongrongfeng
					}	
				}	
			}
		}	
	
		;s SortExp = ##class(web.DHCBL.MKB.MKBICDRely).SortExp(ProDets)	
		if ($D(^User.MKBStructuredDataResultI("SortIndex",TermId,ProDets))'=0) //如果完全匹配
		{
			s MKBSDRowId=""
			for
			{
				s MKBSDRowId=$O(^User.MKBStructuredDataResultI("SortIndex",TermId,ProDets,MKBSDRowId))	
				q:MKBSDRowId=""
				
				s MKBSDInitialICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),18) //最匹配短语
				s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
				s:Fre="" Fre=0
				
				continue:$D(^User.MKBStructuredDataI("BaseIndex",version,MKBSDRowId))=0
				
				s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
				s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
				//s ICDDr = ..GetMRCIDByCodeDesc(ICDCode,ICDDesc)  //获取his id
				/*s ICDDr =##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(ICDCode,ICDDesc)

				if (ICDNSFlag'="Y")  //不允许录入非标ICD的判断。。因为目前数据处理工厂全是标准ICD，所以不需要该判断了
				{
					continue:ICDDr=""
					s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
					continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	
				}*/
				/*s MRCIDBillFlag3=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),24) //中医诊断标志
				s MRCIDBillFlag1=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),25) //中医证型
				continue:(ICDType="0")&&(MRCIDBillFlag3="Y")
				continue:(ICDType="1")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1="Y"))
				continue:(ICDType="2")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1'="Y"))
				//continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	 //不允许录入中医诊断
				s MRCIDMetastaticSite=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),26) //肿瘤形态学编码标志  
				s MRCIDInjuryPoisoningCode=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),27) //损伤中毒外部原因标志
				continue:(MRCIDMetastaticSite="Y")||(MRCIDInjuryPoisoningCode="Y")		
				s DateFrom=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),28) //开始日期
				s DateTo=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),28) //结束日期
				continue:(DateFrom'="")&&(DateFrom>+$H)
				continue:(DateTo'="")&&(DateTo<+$H)*/
				
				if (MKBSDInitialICD="Y")
				{
					s par(100000000002,Fre,MKBSDRowId)=""
				}
				else
				{
					s par(100000000000,Fre,MKBSDRowId)=""	
				}
				
				s all(MKBSDRowId)=""
			}
		}
	}
	if ($D(all)=0)    //如果不存在完全匹配
	{
		s MKBSDRowId=0
		for
		{
			s MKBSDRowId=$O(^User.MKBStructuredDataResultI("TermIndex",TermId,MKBSDRowId))
			q:MKBSDRowId=""

			s MKBSDRRowId=0
			for
			{
				s MKBSDRRowId=$O(^User.MKBStructuredDataResultI("TermIndex",TermId,MKBSDRowId,MKBSDRRowId))	
				q:MKBSDRRowId=""
				
				s MKBSDInitialICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),18) //最匹配短语
				s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
				s ResultExp = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRRowId)),2)
				
				s:Fre="" Fre=0
				if (ProDets="")
				{
					if (ResultExp="")
					{
						if (MKBSDInitialICD="Y") 
						{
							s par(100000000001,Fre,MKBSDRowId)=""		
						}
						else
						{
							s par(1,Fre,MKBSDRowId)=""	
						}
						
					}		
					continue
				}

				//该条记录匹配度
				s priority=0
				
				
				if (ResultExp="")
				{	
					s par(0,Fre,MKBSDRowId)=""	
					continue	
				}
				///存储子表所有结构化结果的属性内容
				k resdets
				
				for i=1:1:$L(ResultExp,",")
				{
					s Pro=$P($P(ResultExp,",",i),":",1)
					s Dets=$P($P(ResultExp,",",i),":",2)
					continue:Pro=""
					continue:Dets=""
					for j=1:1:$L(Dets,"*")
					{
						s resdets(Pro,$P(Dets,"*",j))=""	  //把数据处理工厂所有结构化结果都存成属性 属性内容形式
					}	
				}
				
				///end 存储
				
				///对子表每一个内容进行判断
				s ResPro=0
				for
				{
					s ResPro=$O(resdets(ResPro))
					q:ResPro=""
					
					s ResDet=0
					for
					{
						s ResDet=$O(resdets(ResPro,ResDet))
						q:ResDet=""
						
						if ($D(dets(ResPro,ResDet)))   //如果入参中（包括上下级节点的）有和数据处理工厂中相同的结构化结果
						{
							s priority=priority+dets(ResPro,ResDet)    //权重累加
						}
					}	
				}
				///按权重存储
				s par(priority*10,Fre,MKBSDRowId)=""
			}	
		}
		;b:MKBSDRowId=764	
	}
	k unique
	s result = ""
	s priority = ""
	for 
	{
		s priority = $o(par(priority),-1)
		q:priority=""
		s Fre=""
		for
		{
			s Fre=$O(par(priority,Fre),-1)	
			q:Fre=""
			
			s MKBSDRowId=""
			for
			{
				s MKBSDRowId=$O(par(priority,Fre,MKBSDRowId))
				q:MKBSDRowId=""
				
				continue:$D(^User.MKBStructuredDataI("BaseIndex",version,MKBSDRowId))=0
				
				s ICDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
				s ICDCode = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
				//s ICDDr = ..GetMRCIDByCodeDesc(ICDCode,ICDDesc)  //获取his id
				/*s ICDDr =##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(ICDCode,ICDDesc)
				if (ICDNSFlag'="Y")
				{
					continue:ICDDr=""
					s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
					continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	
				}*/
				/*s MRCIDBillFlag3=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),24) //中医诊断标志
				s MRCIDBillFlag1=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),25) //中医证型
				continue:(ICDType="0")&&(MRCIDBillFlag3="Y")
				continue:(ICDType="1")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1="Y"))
				continue:(ICDType="2")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1'="Y"))
				//continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	 //不允许录入中医诊断
				s MRCIDMetastaticSite=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),26) //肿瘤形态学编码标志  
				s MRCIDInjuryPoisoningCode=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),27) //损伤中毒外部原因标志
				continue:(MRCIDMetastaticSite="Y")||(MRCIDInjuryPoisoningCode="Y")		
				s DateFrom=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),28) //开始日期
				s DateTo=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),28) //结束日期
				continue:(DateFrom'="")&&(DateFrom>+$H)
				continue:(DateTo'="")&&(DateTo<+$H)*/
				
				if $D(unique(MKBSDRowId))=0
				{
					s unique(MKBSDRowId)=""	
				}
				else
				{
					continue	
				}
			
				s:result'="" result=result_","_MKBSDRowId
				s:result="" result=MKBSDRowId		
			}
		}
	}		
	

	q result
}

/// 高姗姗 20210720
/// 根据结构化数据获取非结构化数据后排序，描述较短的排在前面
/// Input：version-数据处理工厂ID，ids-结构化id串;
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStructSort("8","15879-18158:38122")
ClassMethod GetDiagViaStructSort(version As %String, ids As %String)
{
	s result=""
	s diagStr=..GetDiagViaStruct(version,ids)
	s diagLen=$Length(diagStr,",")
	for i=1:1:diagLen{
		s MKBSDRowid=$p(diagStr,",",i)
		s MKBSDDiag=$LISTGET($G(^User.MKBStructuredDataD(MKBSDRowid)),2) 
		s MKBSDICDDesc=$LISTGET($G(^User.MKBStructuredDataD(MKBSDRowid)),21)
		s ICDLen=$Length(MKBSDICDDesc)
		;w i_":"_MKBSDICDDesc_"-"_ICDLen,!
		s arrSort(ICDLen,i)=MKBSDRowid
	}
	;s num=0
	s len=""
	for{
		s len=$o(arrSort(len)) q:len=""
		s j=""
		for {
			s j=$o(arrSort(len,j)) q:j=""
			s diagid=$g(arrSort(len,j))	
			
			;s num=num+1
			;s ^TMPGSS(num)=$LISTGET($G(^User.MKBStructuredDataD(diagid)),21)
			
			if (result=""){
				s result=diagid	
			}else{
				s result=result_","_diagid
			}	
		}	
	}
	q result
}

/// 获取对应诊断标记
/// Input：TermId
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetFlagByTerm(14679)
ClassMethod GetFlagByTerm(TermId)
{
	s result=""
	if ($D(^User.MKBKLMappingBaseI("DescIndex"," 诊断标记"))'=0)
	{
		s MKBMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 诊断标记",0))
		s MKBMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 默认标记",0))
		s MKBRRowId=0
		for
		{
			s MKBRRowId=$O(^User.MKBReferenceI("ReferIndex","T",TermId,MKBRRowId))
			q:MKBRRowId=""
			
			s MDRowId=$LG($G(^User.MKBReferenceD(MKBRRowId)),3)
			continue:$D(^User.MKBKLMappingDetailI("BaseIndex",MKBMBRowId,MDRowId))=0	
			s RowNum=$LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
			s FlagMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_MKBMFChild,0))
			s val = $LG($G(^User.MKBKLMappingDetailD(FlagMDRowId)),2)
			s:result'="" result=result_","_val
			s:result="" result=val
		}	
	}	
	q result
}

/// 诊断数据的接口：本科室频次最高的数据先输出，然后再取非本科室
/// Input：desc-根据描述、拼音码查询，rows-每页显示行数 page-第几页
/// return:Json数据 
/// MKBSDRowId:数据处理工厂父表id    MKBSDDesc:诊断描述    MKBSDRRowId：结构化子表ID    MKBSDRTermDr：结构化数据TermId 
/// MKBSDRExpId：结构化表达式ID串    MKBSDRExp:结构化表达式描述   MKBSDRSup:补充诊断
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetTermListForDoc("",10,1)
ClassMethod GetTermListForDoc(desc, rows, page)
{
	s result="",total=0,jsonstr=""
	
	w "{""rows"":["
	s endpage=page*rows ///结束行
	s stpage=((page-1)*rows)+1
	
	s LocId=$G(%session.Data("LOGON.CTLOCID"))
	//s LocId=1
	
	s LocDesc = $ZCONVERT($P($G(^CTLOC(LocId)),"^",2),"U")
	//s:desc'="" desc=$zconvert(desc,"U")
	
	s Freq=""
	for
	{
		s Freq=$O(^User.MKBStructuredDataLocI("LocFreIndex",$ZCONVERT(LocDesc,"U"),Freq),-1)
		q:Freq=""
		
		s MKBSDRowId=0
		for
		{
			s MKBSDRowId=$O(^User.MKBStructuredDataLocI("LocFreIndex",$ZCONVERT(LocDesc,"U"),Freq,MKBSDRowId))
			q:MKBSDRowId=""
			
			s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
			s MKBSDRChild = $O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",0))
			if (MKBSDRChild'="")
			{
				s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
				if (MKBSDRTermDr'="")
				{
					s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)

					s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
					
					s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
					
					s MKBSDPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDesc)	
					if ((MKBSDPY[$ZCONVERT(desc,"U"))||(MKBSDDesc[desc))
					{
						s total=total+1
						if (total<stpage) continue
						if (total<=endpage)
						{
							s mainstr="{""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_"""}"						
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
	
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		if '($D(^User.MKBStructuredDataLocI("LocIndex",LocDesc,MKBSDRowId)))
		{
			s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
			s MKBSDRChild = $O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",0))
			if (MKBSDRChild'="")
			{
				s MKBSDRTermDr=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)	
				if (MKBSDRTermDr'="")
				{
					s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)

						s MKBSDRExp = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDRExpId,MKBSDRTermDr)
					
					s MKBSDRSup = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),5)
					
					s MKBSDPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDesc)	
					if ((MKBSDPY[$ZCONVERT(desc,"U"))||(MKBSDDesc[desc))
					{
						s total=total+1
						if (total<stpage) continue
						if (total<=endpage)
						{
							s mainstr="{""MKBSDRowId"":"""_MKBSDRowId_""",""MKBSDDesc"":"""_MKBSDDesc_""",""MKBSDRRowId"":"""_MKBSDRowId_"||"_MKBSDRChild_""",""MKBSDRTermDr"":"""_MKBSDRTermDr_""",""MKBSDRExpId"":"""_MKBSDRExpId_""",""MKBSDRExp"":"""_MKBSDRExp_""",""MKBSDRSup"":"""_MKBSDRSup_"""}"				
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
}

/// Author:lixin
/// Date: 20181227
/// Desc:获取匹配到的第一条ICD
/// Debug：w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetFirstHISICD("15359-298013:329656*329654,397696:S128948")
ClassMethod GetFirstHISICD(str, desc)
{
	s result = ""
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCBL.MKB.MKBKLMappingDetailInterface"
	set rs.QueryName="GetICDForHIS"
	set sc=rs.Execute(str,desc)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	if rs.%Next() 
	{
		///DiagExp,MRCID,HISCode,HISDesc
		s DiagExp=rs.Data("DiagExp")
		s MRCID=rs.Data("MRCID")
		
		s HISCode=rs.Data("HISCode")
		s HISDesc=rs.Data("HISDesc")
		s result = DiagExp_"^"_MRCID_"^"_HISCode_"^"_HISDesc	
	}
	
	q result
}

/// Exp:表达式
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetICDForHIS","14679","")
Query GetICDForHIS(str, desc) As %Query(ROWSPEC = "DiagExp,MRCID,HISCode,HISDesc")
{
}

ClassMethod GetICDForHISExecute(ByRef qHandle As %Binary, str, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (str'="")
	{
		s TermId=$P(str,"-",1)
		s ProDets=$P(str,"-",2)
		if (ProDets'="")
		{
			///记录所有传入属性内容
			k dets
			///包含属性内容串个数
			s len = $L(ProDets,",")
			for i=1:1:len
			{
				s subProDets=$P(ProDets,",",i)
				s Pro=$P(subProDets,":",1)
				s Dets=$P(subProDets,":",2)
				for j=1:1:$L(Dets,"*")
				{
					s dets(Pro,$P(Dets,"*",j))=""	
				}
					
			}
			///记录属性内容个数	
			s detNum=0
			s pro=0
			for
			{
				s pro=$O(dets(pro))
				q:pro=""
				
				s det=0
				for
				{
					s det=$O(dets(pro,det))
					q:det=""
					
					s detNum=detNum+1	
				}	
			}
			///初始权重，每包含其中一个属性内容累加权重
			s initPriority=1/detNum
			
			///计算权重列表
			s pro=0
			for
			{
				s pro=$O(dets(pro))
				q:pro=""
				
				s det=0
				for
				{
					s det=$O(dets(pro,det))
					q:det=""
					
					s dets(pro,det)=initPriority
					
					s protype = $LG($G(^User.MKBTermPropertyD(pro)),4)
					s config=$LG($G(^User.MKBTermPropertyD(pro)),5)
					s contype=""
					if (protype="S")
					{
						s contype=$LG($G(^User.MKBTermBaseD(config)),4)	
					}
					///树性结构
					if ((protype="T")||(((protype="SS")||(protype="S"))&&(contype="T")))
					{
						///树形属性
						if (protype="T")
						{
							///先找出所有上级节点
							s tmp=det
							s tmpPrio=1
							while($LG($G(^User.MKBTermProDetailD(tmp)),4)'="")
							{
								s par=$LG($G(^User.MKBTermProDetailD(tmp)),4)
								s tmpPrio=tmpPrio-0.1
								s dets(Pro,par)=initPriority*tmpPrio
								s tmp=par
							}
							
							///所有下级节点权重暂等于当前节点
							s childs = ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(det,pro)
							if (childs'="")
							{
								for k=1:1:$L(childs,"^")
								{
									s dets(pro,$P(childs,"^",k))=initPriority	
								}		
							}
								
						}
						elseif (protype="SS")||(protype="S")
						{
							//当前选中的TermId
							s curTemrId=$P(det,"S",2)
							
							///找出所有上级节点
							s tmp=curTemrId
							s tmpPrio=1
							while($LG($G(^User.MKBTermD(tmp)),5)'="")
							{
								s par=$LG($G(^User.MKBTermD(tmp)),5)
								s tmpPrio=tmpPrio-0.1
								s dets(pro,"S"_par)=initPriority*tmpPrio
								s tmp=par
							}	
							
							///所有下级节点暂定权重不变
							
							s childs = ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(config,curTemrId)
							if (childs'="")
							{
								for k=1:1:$L(childs,"^")
								{
									s dets(pro,"S"_$P(childs,"^",k))=initPriority	
								}		
							}
							
						}	
					}	
				}
			}	
			s SortExp = ##class(web.DHCBL.MKB.MKBICDRely).SortExp(ProDets)	
			if ($D(^User.MKBICDRelyI("SortIndex",SortExp))'=0) //完全匹配
			{
				s ResultId=""
				for
				{
					s ResultId=$O(^User.MKBICDRelyI("SortIndex",SortExp,ResultId))	
					q:ResultId=""
					
					s PaId = $LG($G(^User.MKBHISICDContrastD($P(ResultId,"||",1))),11)
					if (PaId="Y")
					{
						s tmp(10001,ResultId)=""	
					}
					else
					{
						s tmp(10000,ResultId)=""
					}
					s all(ResultId)=""	
				}
			}	
		}
		
		
		
		if ($D(all)=0)
		{
			s ResultId=0
			for
			{
				s ResultId=$O(^User.MKBICDRelyI("TermIndex",TermId,ResultId))
				q:ResultId=""
				
				s PaId = $LG($G(^User.MKBHISICDContrastD($P(ResultId,"||",1))),11)
				if (PaId="Y")
				{
					s tmp(10001,ResultId)=""
					continue	
				}
				
				//该条记录匹配度
				s priority=0
				
				s ResultExp = $LG($G(^User.MKBHISICDContrastD($P(ResultId,"||",1),"MKBHISICDContrastResult",$P(ResultId,"||",2))),2)
				///存储子表中结构化结果的属性内容
				if (ResultExp="")
				{
					if (ProDets="")
					{
						s tmp(1,ResultId)=""
							
					}
					else
					{
						s tmp(0,ResultId)=""	
					}
					continue
					
				}
				k resdets
				
				for i=1:1:$L(ResultExp,",")
				{
					s Pro=$P($P(ResultExp,",",i),":",1)
					s Dets=$P($P(ResultExp,",",i),":",2)
					for j=1:1:$L(Dets,"*")
					{
						s resdets(Pro,$P(Dets,"*",j))=""	
					}	
				}
				
				///end 存储
				
				///对子表每一个内容进行判断
				s ResPro=0
				for
				{
					s ResPro=$O(resdets(ResPro))
					q:ResPro=""
					
					s ResDet=0
					for
					{
						s ResDet=$O(resdets(ResPro,ResDet))
						q:ResDet=""
						
						if ($D(dets(ResPro,ResDet)))
						{
							s priority=priority+dets(ResPro,ResDet)
						}
					}	
				}
				///按权重存储
				s tmp(priority*10,ResultId)=""
			}	
		}
		
		

		k unique
		s result = ""
		s time = 100000
		for 
		{
			s time = $o(tmp(time),-1)
			q:time=""
			s ResultId = ""
			
			for
			{
				s ResultId = $o(tmp(time,ResultId))
				q:ResultId=""
				
				
				if $D(unique(ResultId))=0
				{
					s unique(ResultId)=""	
				}
				else
				{
					continue	
				}
				
				s MRCID = $LG($G(^User.MKBHISICDContrastD($P(ResultId,"||",1))),2)
				

				s TermDr = $LG($G(^User.MKBHISICDContrastD($P(ResultId,"||",1),"MKBHISICDContrastResult",$P(ResultId,"||",2))),4)
				s ExpIds = $LG($G(^User.MKBHISICDContrastD($P(ResultId,"||",1),"MKBHISICDContrastResult",$P(ResultId,"||",2))),2)
				s DiagDesc = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(ExpIds,TermDr)
				
				s Code=$P($G(^MRC("ID",MRCID)),"^",4)
				s Desc=$P($G(^MRC("ID",MRCID)),"^",2)
				
				if (Desc[desc)
				{
					
					d OutputRow	
				}
			}
		}		
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(DiagDesc,MRCID,Code,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDForHISClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDForHISExecute ]
{

	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDForHISFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDForHISExecute ]
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

/// Creator:李欣
/// CreateDate:20180517
/// Desc:继发性病因智能匹配
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetJFXBY("14679")
ClassMethod GetJFXBY(str)
{
	q:str="" ""
	s result=""
	if ($D(^User.MKBKLMappingBaseI("IdenIndex"," CJ"))'=0)
	{
		s KMBRowId = $O(^User.MKBKLMappingBaseI("IdenIndex"," CJ",0))
		s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 触发诊断",0))
		s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 被引用诊断",0))
		
		s ArgTermId = $P(str,"-",1)
		s ProDets = $P(str,"-",2)
		s:ProDets="" ProDets=-100000000000000
		s len = $L(str,",")
		s m=0
		for i=1:1:len //存储入参属性内容
		{
			s DetStr=$P($P(str,",",i),":",2)
			if (DetStr'="")
			{
				s dlen = $L(DetStr,"*")
				for j=1:1:dlen
				{
					s m = m+1
					s a(m)=$P(DetStr,"*",j)
				}		
			}
		}
		s ArgLen = m
		s AllFlag = ""
		s AllStr=""
		if ($D(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets))'=0)
		{
			s AllID = ""
			for
			{
				s AllID = $O(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets,AllID))
				q:AllID=""
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(AllID)),4)
				s FieldDr = $LG($G(^User.MKBKLMappingDetailD(AllID)),3)
				s tmp(AllID,1000)=""	
				s AllStr=AllStr_"&"_AllID
			}
		}
		s KMDRowId = 0
		for
		{
			s KMDRowId = $O(^User.MKBMappingRelyI("TermIndex",KMBRowId,ArgTermId,KMDRowId))
			q:KMDRowId=""
			continue:$D(tmp(KMDRowId))'=0
			
			s time=0
			s value = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
			
			s TermId = $P(value,"-",1)
			s sub = $P(value,"-",2)
			s l=0
			if (sub'="")
			{
				s ProId = $P(sub,":",1)
				s DetStr = $P(sub,":",2)
				s DetNum = $L(DetStr,"*")
				for j=1:1:DetNum
				{
					s l=l+1	
					s d(l)=$P(DetStr,"*",j)		
				}	
			}	

			s ValLen = l
			s n = 0
			for i=1:1:ArgLen
			{
				for j=1:1:ValLen
				{
					if (a(i)=d(j))
					{
						s n=n+1	
					}	
				}	
			}
			if (n'=0)
			{
				s tmp(KMDRowId,0)=""	
			}
		}
		
		s i = 1
		s KMDRowId = 0
		for
		{
			s KMDRowId = $O(tmp(KMDRowId))
			q:KMDRowId=""
			
			s time = $O(tmp(KMDRowId,""))
			if ($D(sort(time))=0)
			{
				s sort(time,KMDRowId)=""	
			}	
			else
			{
				s sort(time+i,KMDRowId)=""
				s i = i+1	
			}
		}	
		s result = ""
		s time = 10000
		for 
		{
			s time = $o(sort(time),-1)
			q:time=""
			s KMDRowId1=""
			
			for
			{
				s KMDRowId1 = $o(sort(time,KMDRowId1))
				q:KMDRowId1=""
				
				s KMDRowId2Desc=""
				s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId1)),4)
				continue:KMDRowNum=""
				s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild2,0))
				
				continue:KMDRowId2=""
				s KMDRowId2DiagId = $LG($G(^User.MKBKLMappingDetailD(KMDRowId2)),2)
				s:KMDRowId2DiagId'="" KMDRowId2Desc = ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs($P(KMDRowId2DiagId,"-",2),$P(KMDRowId2DiagId,"-",1))
				s KMDRowId2DiagId = ..TransExp(KMDRowId2DiagId)
				s:result'="" result=result_"&%"_KMDRowId2DiagId_"&^"_KMDRowId2Desc
				s:result="" result=KMDRowId2DiagId_"&^"_KMDRowId2Desc	
			}	
		}		
	}
	
	q result
}

/// Creator:李欣
/// CreateDate:20180530
/// Input:ProId 属性ID TermID ,属性内容中的TermId
/// Desc:根据传入的引用术语类型属性内容的Desc(术语ID) 获取属性内容ID
/// Debug:w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetSDetailIDByTermID(1768,16419)
ClassMethod GetSDetailIDByTermID(ProId, TermId)
{
	q:TermId="" ""
	q:ProId="" ""
	q:$D(^User.MKBTermD(TermId))=0 ""
	q:$D(^User.MKBReferenceI("InverAllIndex","T",TermId))=0 ""
	
	s DetailId = 0
	for
	{
		s DetailId = $O(^User.MKBReferenceI("InverAllIndex","T",TermId,"D",DetailId))
		q:DetailId=""
		
		s PropertyId = $LG($G(^User.MKBTermProDetailD(DetailId)),6)	
		q:PropertyId=ProId 
	}
	
	q DetailId
}

/// Creator:李欣
/// CreateDate:20180517
/// Desc:结构化诊断-鉴别诊断智能匹配
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetJBZD("15828")
ClassMethod GetJBZD(str)
{
	q:str="" ""
	s result=""
	if ($D(^User.MKBKLMappingBaseI("IdenIndex"," DD"))'=0)
	{
		s KMBRowId = $O(^User.MKBKLMappingBaseI("IdenIndex"," DD",0))
		s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断1",0))
		s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断2",0))
		s KMBFChild3 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 鉴别要点",0))
		
		s ArgTermId = $P(str,"-",1)
		s ProDets = $P(str,"-",2)
		s:ProDets="" ProDets=-100000000000000
		s len = $L(str,",")
		s m=0
		for i=1:1:len //存储入参属性内容
		{
			s DetStr=$P($P(str,",",i),":",2)
			if (DetStr'="")
			{
				s dlen = $L(DetStr,"*")
				for j=1:1:dlen
				{
					s m = m+1
					s a(m)=$P(DetStr,"*",j)
				}		
			}
		}	
		s ArgLen = m
		s AllFlag = ""
		
		if ($D(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets))'=0)
		{
			s AllID = ""
			for
			{
				s AllID = $O(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets,AllID))
				;s AllID = $O(^TMP("MKB","SortInfo",KMBRowId,str,AllID))
				q:AllID=""

				s tmp(AllID,1000)=""	
			}
			
		}
		s KMDRowId = 0
		for
		{
			;s KMDRowId = $O(^TMP("MKB","DiagTermID",KMBRowId,ArgTermId,KMDRowId))
			s KMDRowId = $O(^User.MKBMappingTermRelyI("TermIndex",KMBRowId,ArgTermId,KMDRowId))
			q:KMDRowId=""
			continue:$D(tmp(KMDRowId))'=0
			
			s time=0
			s value = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
			
			s vlen = $L(value,";")
			s l=0
			for i=1:1:vlen
			{
				if (i=1)
				{
					s subvalue = $P(value,";",1)
					s TermId = $P(subvalue,"-",1)
					s sub = $P(subvalue,"-",2)
					if (sub'="")
					{
						s ProId = $P(sub,":",1)
						s DetStr = $P(sub,":",2)
						s DetNum = $L(DetStr,"*")
						for j=1:1:DetNum
						{
							s l=l+1	
							s d(l)=$P(DetStr,"*",j)	
						}	
					}	
				}
				else
				{
					s subvalue = $P(value,";",1)
					s TermId = $E($P(subvalue,"-",1),2,$L($P(subvalue,"-",1)))
					s sub = $P(subvalue,"-",2)
					if (sub'="")
					{
						s ProId = $P(sub,":",1)
						s DetStr = $P(sub,":",2)
						s DetNum = $L(DetStr,"*")
						for j=1:1:DetNum
						{
							s l=l+1	
							s d(l)=$P(DetStr,"*",j)	
						}	
					}	
				}	
			}
			s ValLen = l
			s n = 0
			for i=1:1:ArgLen
			{
				for j=1:1:ValLen
				{
					if (a(i)=d(j))
					{
						s n=n+1	
					}	
				}	
			}
			if (n'=0)
			{
				s tmp(KMDRowId,0)=""	
			}
		}
		s i = 1
		s KMDRowId = 0
		for
		{
			s KMDRowId = $O(tmp(KMDRowId))
			q:KMDRowId=""
			
			s time = $O(tmp(KMDRowId,""))
			if ($D(sort(time))=0)
			{
				s sort(time,KMDRowId)=""	
			}	
			else
			{
				s sort(time+i,KMDRowId)=""
				s i = i+1	
			}
		}	
		s result = ""
		s time = 10000
		for 
		{
			s time = $o(sort(time),-1)
			q:time=""
			s KMDRowId1=""
			
			for
			{
				s KMDRowId1 = $o(sort(time,KMDRowId1))
				q:KMDRowId1=""
				
				s tKMBDChild = $LG($G(^User.MKBKLMappingDetailD(KMDRowId1)),3)
				s KMDRowId2Desc=""
				s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId1)),4)
				continue:KMDRowNum=""
				
				if (tKMBDChild=(KMBRowId_"||"_KMBFChild1))
				{
					
					s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild2,0))
						
				}
				else
				{		
							
					s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild1,0))
				}
				
				continue:KMDRowId2=""
				s KMDRowId2Desc = $LG($G(^User.MKBKLMappingDetailD(KMDRowId2)),2)
				s:KMDRowId2Desc'="" KMDRowId2Desc = ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs($P(KMDRowId2Desc,"-",2),$P(KMDRowId2Desc,"-",1))
				
				s KMDRowId3Desc=""
				s KMDRowId3 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild3,0))
				s KMDRowId3Desc=""
				s:KMDRowId3'="" KMDRowId3Desc = $LG($G(^User.MKBKLMappingDetailD(KMDRowId3)),2)
				
				s:result'="" result=result_"&%"_KMDRowId2Desc_"&^"_KMDRowId3Desc
				s:result="" result=KMDRowId2Desc_"&^"_KMDRowId3Desc				
			}	
		}		
	}
	
	q result
}

/// Creator:李欣
/// CreateDate:20180517
/// Desc:结构化诊断-同义诊断智能匹配
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetTYZD("15879-18158:38125,18159:38131")
ClassMethod GetTYZD(str)
{
	q:str="" ""
	s result=""
	if ($D(^User.MKBKLMappingBaseI("IdenIndex"," SD"))'=0)
	{
		s KMBRowId = $O(^User.MKBKLMappingBaseI("IdenIndex"," SD",0))
		s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断1",0))
		s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断2",0))
		
		s ArgTermId = $P(str,"-",1)
		s ProDets = $P(str,"-",2)
		s:ProDets="" ProDets=-100000000000000
		s len = $L(str,",")
		s m=0
		for i=1:1:len //存储入参属性内容
		{
			s DetStr=$P($P(str,";",i),":",2)
			if (DetStr'="")
			{
				s dlen = $L(DetStr,"*")
				for j=1:1:dlen
				{
					s m = m+1
					s a(m)=$P(DetStr,"*",j)
				}		
			}
		}	
		s ArgLen = m //入参属性内容个数
		s AllFlag = ""
		s AllStr=""
		if ($D(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets))'=0)
		{
			s AllID = ""
			for
			{
				s AllID = $O(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets,AllID))
				q:AllID=""
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(AllID)),4)
				s FieldDr = $LG($G(^User.MKBKLMappingDetailD(AllID)),3)
				s tmp(1000,RowNum,FieldDr)=""	
				s AllStr=AllStr_"&"_AllID
			}
		}
		s KMDRowId = 0
		for
		{
			s KMDRowId = $O(^User.MKBMappingRelyI("TermIndex",KMBRowId,ArgTermId,KMDRowId))
			q:KMDRowId=""
			continue:AllStr[KMDRowId
			continue:$D(^User.MKBKLMappingDetailD(KMDRowId))=0 ///李欣 20181109
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
			continue:$D(tmp(0,RowNum))'=0
			s value = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
			s TermId = $P(value,"-",1)
			s sub = $P(value,"-",2)
			s l=0
			if (sub'="")
			{
				s ProId = $P(sub,":",1)
				s DetStr = $P(sub,":",2)
				s DetNum = $L(DetStr,"*")
				for j=1:1:DetNum
				{
					s l=l+1	
					s d(l)=$P(DetStr,"*",j)		
				}	
			}	
			
			s ValLen = l
			s n = 0
			for i=1:1:ArgLen
			{
				for j=1:1:ValLen
				{
					if (a(i)=d(j))
					{
						s n=n+1	
					}	
				}	
			}
			
			s FieldDr = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),3)
			if (n'=0)
			{
				s tmp(n,RowNum,FieldDr)=""	
			}
		}
		s result = ""
		s time = 10000
		for 
		{
			s time = $o(tmp(time),-1)
			q:time=""
			s RowNum = 0
			for
			{
				s RowNum = $O(tmp(time,RowNum))
				q:RowNum=""
				s FieldDr=0
				for
				{
					s FieldDr = $O(tmp(time,RowNum,FieldDr))
					q:FieldDr=""
					if (FieldDr=(KMBRowId_"||"_KMBFChild1))
					{
						s KMDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,KMBRowId_"||"_KMBFChild2,0))
						continue:KMDRowId=""
						s KMDDiagId= $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
						s KMDDiagDesc =##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs($P(KMDDiagId,"-",2),$P(KMDDiagId,"-",1))
						s KMDDiagId = ..TransExp(KMDDiagId)
						s:result'="" result=result_"&%"_KMDDiagId_"&^"_KMDDiagDesc
						s:result="" result=KMDDiagId_"&^"_KMDDiagDesc
					}
				}	
			}
		}	
	}
	q result
}

/// Author:lixin
/// Date: 20181227
/// Desc:获取匹配到的第一条ICD
/// Debug：w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetFirstICD(14626)
ClassMethod GetFirstICD(str)
{
	s result = ""
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCBL.MKB.MKBKLMappingDetailInterface"
	set rs.QueryName="GetICD"
	set sc=rs.Execute(str)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	if rs.%Next() 
	{
		///DiagExp,MRCID,HISCode,HISDesc
		s KMDRowId1Desc=rs.Data("DiagExp")
		s MRCID=rs.Data("MRCID")
		s ICDDetDesc=rs.Data("HISCode")
		s ChinDetDesc=rs.Data("HISDesc")
		s result = KMDRowId1Desc_"^"_MRCID_"^"_ICDDetDesc_"^"_ChinDetDesc	
	}

	q result
}

/// Desc:返回所有匹配数据
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetICD","15882")
Query GetICD(str) As %Query(ROWSPEC = "DiagExp,MRCID,HISCode,HISDesc")
{
}

ClassMethod GetICDExecute(ByRef qHandle As %Binary, str) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (str'="")
	{
		if ($D(^User.MKBKLMappingBaseI("DescIndex"," HIS版ICD对照"))'=0)
		{
			s KMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," HIS版ICD对照",0))
			s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断",0))
			s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 中文释义",0))
			s KMBFChild3 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 初始ICD",0))

			s ArgTermId = $P(str,"-",1)
			s str=..TranslateDiagToLocale(str)
			s str = ..SortDiag(str)		
			s len = $L(str,";")
			s m=0
			for i=1:1:len
			{
				s DetStr=$P($P(str,";",i),":",2)
				if (DetStr'="")
				{
					s dlen = $L(DetStr,"*")
					for j=1:1:dlen
					{
						s m = m+1
						s a(m)=$P(DetStr,"*",j)
					}		
				}
			}	
			s ArgLen = m
			s AllFlag = ""

			if ($D(^User.MKBMappingSortRelyI("SortIndex",KMBRowId,str))'=0)
			;if ($D(^TMP("MKB","SortInfo",KMBRowId,str))'=0)
			{
				;s AllID = $O(^TMP("MKB","SortInfo",KMBRowId,str,0))
				s AllID = ""
				for
				{
					s AllID = $O(^User.MKBMappingSortRelyI("SortIndex",KMBRowId,str,AllID))	
					q:AllID=""
					
					s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(AllID)),4)
					s KMDRowId3 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild3,0))
					s value3=""
					s:KMDRowId3'="" value3 = $LG($G(^User.MKBKLMappingDetailD(KMDRowId3)),2)
					if (value3="是")
					{
						s tmp(10002,AllID)=""	
					}
					else
					{
						s tmp(10001,AllID)=""	
					}	
					s all(AllID)=""	
				}	
				
			}
 
			s KMDRowId = 0
			for
			{
				;s KMDRowId = $O(^TMP("MKB","DiagTermID",KMBRowId,ArgTermId,KMDRowId))
				s KMDRowId = $O(^User.MKBMappingTermRelyI("TermIndex",KMBRowId,ArgTermId,KMDRowId))
				
				q:KMDRowId=""
				;continue:AllID=KMDRowId
				continue:$D(all(KMDRowId))'=0
				s time=0
				s value = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
				if (value'["-")||($P(value,"-",2)="")
				{
					s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
					s KMDRowId3 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild3,0))
					s value3=""
					s:KMDRowId3'="" value3 = $LG($G(^User.MKBKLMappingDetailD(KMDRowId3)),2)
					if (value3="是")
					{
						s tmp(10000,KMDRowId)=""	
					}
					else
					{
						s tmp(0,KMDRowId)=""	
					}
					continue
				}
				s value = ..DealStr(ArgTermId,value)
				s DetNum = $l(value)-$l($tr(value,"(",""))	//属性内容的个数
				//初始权重
				if (DetNum=0)
				{
					continue
					b	;DetNum=0
				}	
				s weight = 1/DetNum
				for i=1:1:ArgLen
				{
					s ratio=1
					s DetailID = a(i)	
					s DetailStr = "("_DetailID_")"
					s containflag = "" //是否包含入参属性内容或入参属性内容的上级
					if (value[DetailStr)
					{
						s containflag="Y"
					}
					else
					{
						s ParentID = 0
						if (DetailID'["S")
						{
							s tempDetailID = DetailID
							while (ParentID'="")
							{
								q:tempDetailID=""
								s ParentID = $LG($G(^User.MKBTermProDetailD(tempDetailID)),4)
								s tempDetailID = ParentID
								s tempDetailStr = "("_tempDetailID_")"	
								if (value[tempDetailStr)
								{
									s containflag = "Y"
									s ParentID = ""
								} 
							}	
						}
						else
						{
							s tempTermID = $P(DetailID,"S",2)
							while (tempTermID'="")
							{
								q:tempTermID=""
								s ParentID = $LG($G(^User.MKBTermD(tempTermID)),5)	
								s tempTermID = ParentID
								s tempTermStr = "(S"_tempTermID_")"
								if (value[tempTermStr)
								{
									s containflag = "Y"
									s ParentID = ""
								} 
							}
								
						}
					}
					if (containflag="Y") //包含入参或其上级时权重不打折
					{
						s time = time + (weight*ratio)	
					}
					else //判断是否包含入参下级
					{
						s len = $L(value,",")
						s m=0
						k c
						for j=1:1:len
						{
							s sub = $P(value,",",j)	
							
							if ($P(sub,"-",1)[ArgTermId)&&($P(sub,"-",2)'="")
							{
								s DetStr=$P(sub,":",2)
								s DetNum = $L(DetStr,"*")
								for n=1:1:DetNum
								{
									s m = m+1
									if (DetStr["S")
									{
										s c(m)=$E($P($P(DetStr,"*",n),"S",2),1,$L($P($P(DetStr,"*",n),"S",2))-1)		
									}
									else
									{
										s c(m)=$P(DetStr,"*",n)	
									}
									
								}	
							}
						}
						s DLen = m
						s temp = 0
						if (DetailID'["S")
						{
							for j=1:1:DLen
							{
								s ratio = 1-(0.1*..GetRatio(c(j),DetailID,1))
								s:temp<ratio temp=ratio
							}	
						}
						else
						{
							for j=1:1:DLen
							{
								s ratio = 1-(0.1*..GetTermRatio(c(j),$P(DetailID,"S",2),1))
								s:temp<ratio temp=ratio
							}	
						}		
						s time = time + (weight*temp)
					}
					if (time'=0)
					{
						s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
						s KMDRowId3 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild3,0))
						if (KMDRowId3'="")
						{
							s tmp(10000,KMDRowId)=""	
						}
						else
						{
							s time = time * 100
							s tmp(time,KMDRowId)=""	
						}
						
					}
				
				}
			}
			k unique
			s result = ""
			s time = 100000
			for 
			{
				s time = $o(tmp(time),-1)
				q:time=""
				s KMDRowId1 = ""
				
				for
				{
					s KMDRowId1 = $o(tmp(time,KMDRowId1))
					q:KMDRowId1=""
					
					
					if $D(unique(KMDRowId1))=0
					{
						s unique(KMDRowId1)=""	
					}
					else
					{
						continue	
					}
					
					s KMDRowId1Desc = $LG($G(^User.MKBKLMappingDetailD(KMDRowId1)),2)
					s KMDRowId1Desc = ##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(KMDRowId1Desc)
					
					s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId1)),4)
					s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild2,0))
					s TermId = $LG($G(^User.MKBKLMappingDetailD(KMDRowId2)),2)
					
					s ICDProId = $O(^User.MKBTermPropertyI("DescIndex",TermId," ICD编码",0))
					s ICDDetId = $O(^User.MKBTermProDetailI("ProIdx",ICDProId,0))
					s ICDDetDesc = $LG($G(^User.MKBTermProDetailD(ICDDetId)),3)
					
					s ChinProId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 中文释义",0))
					s ChinDetId = $O(^User.MKBTermProDetailI("ProIdx",ChinProId,0))
					s ChinDetDesc = $LG($G(^User.MKBTermProDetailD(ChinDetId)),3) 
					

					s MRCCode = $LG($G(^User.MKBTermD(TermId)),2)
					s MRCID = $O(^MRC("ID",0,"Code",$ZCONVERT(MRCCode,"U"),0))	
					//s MRCID=1
					d OutputRow
				}	
			}	
		}	
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(KMDRowId1Desc,MRCID,ICDDetDesc,ChinDetDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDExecute ]
{

	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDExecute ]
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

/// w ##class(web.DHCBL.BDP.LeeTemp).GetRatio("818-18919:(43041)","43045",1)
/// DiagDetailID 诊断id DetailID 查询的属性内容ID ratio 匹配系数 初始为0
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetRatio("6","3",0)
/// 匹配度为 1-0.1*GetRatio("43112","43040",0)
ClassMethod GetTermRatio(DiagTermID, TermID, ratio)
{
	k ^TEMP("MKB","RATIO")
	q:(TermID=DiagTermID)&(ratio=0) 0	//如果是完全匹配
	s ratio=ratio+1		
	s MKBTLastLevel=$LG($G(^User.MKBTermD(DiagTermID)),5)  //上级	
	if (MKBTLastLevel'="")
	{
		if (MKBTLastLevel=TermID)
		{
			s ^TEMP("MKB","RATIO")="Y"
			q ratio
		}
		else
		{
			q ..GetRatio(MKBTLastLevel,TermID,ratio)
		}
	}
	if '($d(^TEMP("MKB","RATIO")))||(ratio>10)
	{	
		 q 10		 
	}
	q ratio
}

/// Creator:李欣
/// CreateDate:20180517
/// Desc:结构化诊断-鉴别诊断智能匹配
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetAssessment("14870-4998:10665*10668")
ClassMethod GetAssessment(str)
{
	
	q:str="" ""
	s result=""
	if ($D(^User.MKBKLMappingBaseI("IdenIndex"," RF"))'=0)
	{
		s KMBRowId = $O(^User.MKBKLMappingBaseI("IdenIndex"," RF",0))
		s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断",0))
		s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 评估表",0))
		
		s ArgTermId = $P(str,"-",1)
		s ProDets = $P(str,"-",2)
		s:ProDets="" ProDets=-100000000000000
		s len = $L(str,",")
		s m=0
		for i=1:1:len //存储入参属性内容
		{
			s DetStr=$P($P(str,",",i),":",2)
			if (DetStr'="")
			{
				s dlen = $L(DetStr,"*")
				for j=1:1:dlen
				{
					s m = m+1
					s a(m)=$P(DetStr,"*",j)
				}		
			}
		}	
		s ArgLen = m //入参属性内容个数
		s AllFlag = ""
		s AllStr=""
		if ($D(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets))'=0)
		{
			s AllID = ""
			for
			{
				s AllID = $O(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets,AllID))
				q:AllID=""
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(AllID)),4)
				s FieldDr = $LG($G(^User.MKBKLMappingDetailD(AllID)),3)
				s tmp(1000,RowNum,FieldDr)=""	
				s AllStr=AllStr_"&"_AllID
			}
		}

		s KMDRowId = 0
		for
		{
			s KMDRowId = $O(^User.MKBMappingRelyI("TermIndex",KMBRowId,ArgTermId,KMDRowId))
			q:KMDRowId=""
			continue:AllStr[KMDRowId
			
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
			continue:RowNum=""
			continue:$D(tmp(0,RowNum))'=0
			s value = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
			
			s TermId = $P(value,"-",1)
			s sub = $P(value,"-",2)
			s l=0
			if (sub'="")
			{
				s ProId = $P(sub,":",1)
				s DetStr = $P(sub,":",2)
				s DetNum = $L(DetStr,"*")
				for j=1:1:DetNum
				{
					s l=l+1	
					s d(l)=$P(DetStr,"*",j)		
				}	
			}	
			
			s ValLen = l
			s n = 0
			for i=1:1:ArgLen
			{
				for j=1:1:ValLen
				{
					if (a(i)=d(j))
					{
						s n=n+1	
					}	
				}	
			}
			
			;if (n=ValLen)
			s FieldDr = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),3)
			
			;b
			if (n'=0) //仅中心词存在匹配
			{
				s tmp(n,RowNum,FieldDr)=""	
			}
		
		}
		s result = ""
		s time = 10000
		s idresult=""
		for 
		{
			s time = $o(tmp(time),-1)
			q:time=""
			s RowNum = 0
			for
			{
				s RowNum = $O(tmp(time,RowNum))
				q:RowNum=""
				s FieldDr=0
				for
				{
					s FieldDr = $O(tmp(time,RowNum,FieldDr))
					q:FieldDr=""
					if (FieldDr=(KMBRowId_"||"_KMBFChild1))
					{
						s KMDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,KMBRowId_"||"_KMBFChild2,0))
						s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
						continue:KMDRowNum=""
						s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild2,0))
						continue:KMDRowId2=""
						s AssId = $LG($G(^User.MKBKLMappingDetailD(KMDRowId2)),2)
						
						if (AssId'="")
						{
							continue:idresult[("&%"_AssId)
							s idresult = idresult_"&%"_AssId
							s AssDesc = $LG($G(^User.MKBAssessmentBaseD(AssId)),3)
							
							s:result'="" result=result_"&%"_AssId_"&^"_AssDesc
							s:result="" result=AssId_"&^"_AssDesc
						}
					}
				}	
			}
		}	
	}
	q result
}

/// Creator:李欣
/// CreateDate:20180517
/// Desc:结构化诊断-文献管理智能匹配
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDoc("15828")
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDoc("14870-4998:10672")
ClassMethod GetDoc(str)
{
	q:str="" ""
	s result=""
	if ($D(^User.MKBKLMappingBaseI("IdenIndex"," LC"))'=0)
	{
		s KMBRowId = $O(^User.MKBKLMappingBaseI("IdenIndex"," LC",0))
		s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断",0))
		s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 文献",0))
		
		s ArgTermId = $P(str,"-",1)
		s ProDets = $P(str,"-",2)
		s:ProDets="" ProDets=-100000000000000
		s len = $L(str,",")
		s m=0
		for i=1:1:len //存储入参属性内容
		{
			s DetStr=$P($P(str,",",i),":",2)
			if (DetStr'="")
			{
				s dlen = $L(DetStr,"*")
				for j=1:1:dlen
				{
					s m = m+1
					s a(m)=$P(DetStr,"*",j)           //数组中a(第几个)=属性内容
				}		
			}
		}		                                          
		s ArgLen = m //入参属性内容个数
		s AllFlag = ""
		s AllStr=""
		if ($D(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets))'=0)     //Term 和 结构化结果存在 Mapping Detail中的话
		{
			s AllID = ""
			for
			{
				s AllID = $O(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets,AllID))
				q:AllID=""
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(AllID)),4)
				s FieldDr = $LG($G(^User.MKBKLMappingDetailD(AllID)),3)
				s tmp(1000,RowNum,FieldDr)=""	                                //tmp(1000，行，列)
				s AllStr=AllStr_"&"_AllID                                         //AllStr=MappingDetail的rowid
			}
		}

		s KMDRowId = 0
		for
		{
			s KMDRowId = $O(^User.MKBMappingRelyI("TermIndex",KMBRowId,ArgTermId,KMDRowId))          //term如果存在的话
			q:KMDRowId=""
			continue:AllStr[KMDRowId
			
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
			continue:RowNum=""
			continue:$D(tmp(0,RowNum))'=0
			s value = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
			s TermId = $P(value,"-",1)
			s sub = $P(value,"-",2)
			s l=0
			if (sub'="")
			{
				s ProId = $P(sub,":",1)
				s DetStr = $P(sub,":",2)
				s DetNum = $L(DetStr,"*")
				for j=1:1:DetNum
				{
					s l=l+1	
					s d(l)=$P(DetStr,"*",j)		
				}	
			}	
			s ValLen = l
			s n = 0
			for i=1:1:ArgLen
			{
				for j=1:1:ValLen
				{
					if (a(i)=d(j))
					{
						s n=n+1	
					}	
				}	
			}
			
			;if (n=ValLen)
			s FieldDr = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),3)
			
			;b
			if (n'=0) //仅中心词存在匹配
			{
				s tmp(n,RowNum,FieldDr)=""	
			}
		
		}
		s result = ""
		s idresult=""
		s time = 10000
		
		for 
		{
			s time = $o(tmp(time),-1)
			q:time=""
			
			s RowNum = 0
			for
			{
				s RowNum = $O(tmp(time,RowNum))
				q:RowNum=""
				s FieldDr=0
				for
				{
					s FieldDr = $O(tmp(time,RowNum,FieldDr))
					q:FieldDr=""
					if (FieldDr=(KMBRowId_"||"_KMBFChild1))
					{
						s KMDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,KMBRowId_"||"_KMBFChild2,0))
						continue:KMDRowId=""
						s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
						continue:KMDRowNum=""
						s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild2,0))
						continue:KMDRowId2=""
						s DocId = $LG($G(^User.MKBKLMappingDetailD(KMDRowId2)),2)
						
						if (DocId'="")
						{
							continue:idresult[("&%"_DocId)
							s idresult = idresult_"&%"_DocId
							s DocDesc = $LG($G(^User.MKBDocManageD(DocId)),3)
							s num= $L(DocDesc,".")
							s:DocDesc'="" DocDesc=##class(ext.util.String).Replace(DocDesc,"."_$P(DocDesc,".",num),"")
							s DocPath = $LG($G(^User.MKBDocManageD(DocId)),4)
							
							s:result'="" result=result_"&%"_DocDesc_"&^"_DocPath
							s:result="" result=DocDesc_"&^"_DocPath
						}
					}
				}	
			}
		}	
	}
	q result
}

/// d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).Kill()
ClassMethod Kill()
{
	k ^User.MKBKLMappingBaseD
	k ^User.MKBKLMappingBaseI
	k ^User.MKBKLMappingBaseFieldI
	k ^User.MKBKLMappingBaseFieldC
	k ^User.MKBKLMappingDetailD
	k ^User.MKBKLMappingDetailI
	k ^TMP("MKB","SortInfo")
	k ^TMP("MKB","DiagTermID")
	k ^TMP("MKB")
}

/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).TranslateDiagToLocale("14870-4998:9406*9474*9479*9399,457:T343*T654*T435&;123-12:98*7,998:9*11*10")
ClassMethod TranslateDiagToLocale(DiagStr)
{
	s len = $L(DiagStr,",")
	s result=""
	s TermID=""
	for i=1:1:len
	{
		s subDiagStr = $P(DiagStr,",",i)
		
		if (i=1)
		{
			s TermID = $P(subDiagStr,"-",1)
			s result = result_subDiagStr
		}
		else
		{
			s result = result_";&"_TermID_"-"_subDiagStr
		}	
	}	
	q result
}

/*ClassMethod SortDiag(DiagStr)
{
	s len = $L(DiagStr,";")
	for i=1:1:len
	{
		if (i=1)
		{
			s TermId=$P($P(DiagStr,";",i),"-",1)
			s ProId = $P($P($P(DiagStr,";",i),"-",2),":",1)
			s newDetStr = ""
			if (ProId'="")
			{
				s DetStr = $P($P($P(DiagStr,";",i),"-",2),":",2)
				if (DetStr'="")
				{
					s dnum = $L(DetStr,"*")
					k dsort
					for j=1:1:dnum
					{
						s:$P(DetStr,"*",j)["T" dsort($P($P(DetStr,"*",j),"T",2))="T" 
						s:$P(DetStr,"*",j)'["T" dsort($P(DetStr,"*",j))="" 
					}	
					
					s DetID = ""
					for
					{
						s DetID = $O(dsort(DetID))
						q:DetID=""
						s:newDetStr'="" newDetStr=newDetStr_"*"_dsort(DetID)_DetID
						s:newDetStr="" newDetStr=dsort(DetID)_DetID	
					}	
					k dsort	
				}
				else
				{
					s newDetStr = -1	
				}
			}	
			else
			{
				s ProId=-1
				s newDetStr=-1	
			}		
			s sort(TermId,ProId,newDetStr)=""
		}	
		else
		{
			s TermId=$E($P($P(DiagStr,";",i),"-",1),2,$L($P($P(DiagStr,";",i),"-",1)))
			s ProId = $P($P($P(DiagStr,";",i),"-",2),":",1)
			s newDetStr = ""
			if (ProId'="")
			{
				s DetStr = $P($P($P(DiagStr,";",i),"-",2),":",2)
				if (DetStr'="")
				{
					s dnum = $L(DetStr,"*")
					for j=1:1:dnum
					{
						w $P(DetStr,"*",j)
						s:$P(DetStr,"*",j)["T" dsort($P($P(DetStr,"*",j),"T",2))="T"  
						s:$P(DetStr,"*",j)'["T" dsort($P(DetStr,"*",j))="" 
					}
					s DetID = ""
					for
					{
						s DetID = $O(dsort(DetID))
						q:DetID=""
						s:newDetStr'="" newDetStr=newDetStr_"*"_dsort(DetID)_DetID
						s:newDetStr="" newDetStr=dsort(DetID)_DetID	
					}	
					k dsort	
				}
				else
				{
					s newDetStr = -1	
				}	
			}
			else
			{
				s ProId=-1
				s newDetStr=-1	
			}
			s sort(TermId,ProId,newDetStr)=$E($P($P(DiagStr,";",i),"-",1),1)
		}
	}
	
	s TermId = ""
	s result=""
	s i=1
	for
	{
		s TermId = $O(sort(TermId))
		q:TermId=""
		s ProId = ""
		for
		{
			s ProId = $O(sort(TermId,ProId))
			q:ProId=""
			s DetID=""	
			for
			{
				s DetID = $O(sort(TermId,ProId,DetID))
				q:DetID=""
				if (i=1)
				{
					if (ProId=-1)
					{
						s result=TermId	
					}
					else
					{
						s result=TermId_"-"_ProId_":"_DetID	
					}
				}	
				else
				{
					if (sort(TermId,ProId,DetID)="")
					{
						if (ProId=-1)
						{
							s result=result_";&"_TermId	
						}
						else
						{
							s result=result_";&"_TermId_"-"_ProId_":"_DetID		
						}
					}
					else
					{
						if (ProId=-1)
						{
							s result=result_";"_sort(TermId,ProId,DetID)_TermId
						}
						else
						{
							s result = result_";"_sort(TermId,ProId,DetID)_TermId_"-"_ProId_":"_DetID	
						}
					}
					
				}
				s i=i+1
			}
		}
	}
	q result
}
*/
ClassMethod SortDiag(DiagStr)
{
	s len = $L(DiagStr,";")
	for i=1:1:len
	{
		if (i=1)
		{
			s TermId=$P($P(DiagStr,";",i),"-",1)
			s SubProDet = $P($P(DiagStr,";",i),"-",2)
			if (SubProDet'="")
			{
				s SubLen = $L(SubProDet,",")
				for k=1:1:SubLen
				{
					s Sub = $P(SubProDet,",",k)
					s ProId = $P(Sub,":",1)
					s newDetStr=""
					if (ProId'="")
					{
						s DetStr = $P(Sub,":",2)
						if (DetStr'="")
						{
							s dnum = $L(DetStr,"*")
							for j=1:1:dnum
							{
								s:$P(DetStr,"*",j)["S" dsort($P($P(DetStr,"*",j),"S",2))="S" 
								s:$P(DetStr,"*",j)'["S" dsort($P(DetStr,"*",j))=""
							}	
							s DetID = ""
							for
							{
								s DetID = $O(dsort(DetID))
								q:DetID=""
								s:newDetStr'="" newDetStr=newDetStr_"*"_dsort(DetID)_DetID
								s:newDetStr="" newDetStr=dsort(DetID)_DetID	
							}	
							k dsort	 	
						}
						else
						{
							s newDetStr = -1	
						}	
					}
					else
					{
						s ProId=-1
						s newDetStr=-1	
					}	
					s sort(TermId,ProId,newDetStr)=""
				}
			}
			else
			{
				s sort(TermId,-1,-1)=""	
			}
		}	
		else
		{
			s TermId=$E($P($P(DiagStr,";",i),"-",1),2,$L($P($P(DiagStr,";",i),"-",1)))
			s SubProDet = $P($P(DiagStr,";",i),"-",2)
			if (SubProDet'="")
			{
				s SubProDet = $P($P(DiagStr,";",i),"-",2)
				if (SubProDet'="")
				{
					s SubLen = $L(SubProDet,",")
					for k=1:1:SubLen
					{
						s Sub = $P(SubProDet,",",k)
						s ProId = $P(Sub,":",1)
						s newDetStr=""
						if (ProId'="")
						{
							s DetStr = $P(Sub,":",2)
							if (DetStr'="")
							{
								s dnum = $L(DetStr,"*")
								for j=1:1:dnum
								{
									s:$P(DetStr,"*",j)["S" dsort($P($P(DetStr,"*",j),"S",2))="S" 
									s:$P(DetStr,"*",j)'["S" dsort($P(DetStr,"*",j))=""
								}	
								s DetID = ""
								for
								{
									s DetID = $O(dsort(DetID))
									q:DetID=""
									s:newDetStr'="" newDetStr=newDetStr_"*"_dsort(DetID)_DetID
									s:newDetStr="" newDetStr=dsort(DetID)_DetID	
								}	
								k dsort	 	
							}
							else
							{
								s newDetStr = -1	
							}	
						}
						else
						{
							s ProId=-1
							s newDetStr=-1	
						}	
						s sort(TermId,ProId,newDetStr)=$E($P($P(DiagStr,";",i),"-",1),1)
					}
				}	
			}
			else
			{
				s sort(TermId,-1,-1)=$E($P($P(DiagStr,";",i),"-",1),1)
			}
		}
	}
	s TermId = ""
	s result=""
	s i=1
	for
	{
		s TermId = $O(sort(TermId))
		q:TermId=""
		s ProId = ""
		for
		{
			s ProId = $O(sort(TermId,ProId))
			q:ProId=""
			s DetID=""	
			for
			{
				s DetID = $O(sort(TermId,ProId,DetID))
				q:DetID=""
				if (i=1)
				{
					if (ProId=-1)
					{
						s result=TermId	
					}
					else
					{
						s result=TermId_"-"_ProId_":"_DetID	
					}
				}	
				else
				{
					if (sort(TermId,ProId,DetID)="")
					{
						if (ProId=-1)
						{
							s result=result_";&"_TermId	
						}
						else
						{
							s result=result_";&"_TermId_"-"_ProId_":"_DetID		
						}
					}
					else
					{
						if (ProId=-1)
						{
							s result=result_";"_sort(TermId,ProId,DetID)_TermId
						}
						else
						{
							s result = result_";"_sort(TermId,ProId,DetID)_TermId_"-"_ProId_":"_DetID	
						}
					}	
				}
				s i=i+1
			}
		}
	}
	q result
}

/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SortDiag("14870-4998:9406*9474*9479*9399;&14870-457:T343*T654*T435&;123-12:98*7;&14870-998:9*11*10")
/// 为结构化诊断提示生成所需索引
/// Creator:李欣
/// CreateDate:20180522
/// Input:base:MappingBase表的rowid,  value: 诊断表达式,  kmdid : MappingDetail表ID
/// d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GenerateDiagGlobal(29,"16370-24512:156219*156220*156221",199)
ClassMethod GenerateDiagGlobal(base, value, kmdid)
{
	d ##class(web.DHCBL.MKB.MKBMappingRely).SaveData(base,value,kmdid)
}

/// 删除诊断表达式数据时删除索引
/// Creator:李欣
/// CreateDate:20180522
/// Input:base:MappingBase表的rowid,  value: 诊断表达式,  kmdid : MappingDetail表ID
/// Debug: d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).DeleteDiagGlobal(29,"16372-24538:156331*156327",200)
ClassMethod DeleteDiagGlobal(base, value, mdid)
{
	d ##class(web.DHCBL.MKB.MKBMappingRely).DeleteData(base,value,mdid)
}

/// 为结构化诊断提示更新所需索引
/// Creator:李欣
/// CreateDate:20180522
/// Input:base:MappingBase表的rowid,  value: 诊断表达式,  kmdid : MappingDetail表ID
/// ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).UpdateDiagGlobal(3,"70371-217614:205775","70371-217614:205775;&70371-217614:205775",13542)
ClassMethod UpdateDiagGlobal(base, oldvalue, newvalue, kmdid)
{
	d ##class(web.DHCBL.MKB.MKBMappingRely).DeleteData(base,oldvalue,kmdid)
	d ##class(web.DHCBL.MKB.MKBMappingRely).SaveData(base,newvalue,kmdid)
}

/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).DealStr(1920,"1920-5:1*25*15;&1920-4:6*3;|1916-26:12*21")
ClassMethod DealStr(term, str)
{
	s len = $L(str,";")
	s result=""
	for i=1:1:len
	{
		s sub = $P(str,";",i)
		if ($P(sub,"-",1)[term)
		{
			s sub = ##class(ext.util.String).Replace(sub,":",":(")
			s sub = ##class(ext.util.String).Replace(sub,"*",")*(")
			s sub = sub_")"	
		}
		s:result'="" result=result_";"_sub
		s:result="" result=sub
	}
	q result
}

/// w ##class(web.DHCBL.BDP.LeeTemp).GetRatio("818-18919:(43041)","43045",1)
/// DiagDetailID 诊断id DetailID 查询的属性内容ID ratio 匹配系数 初始为0
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetRatio("6","3",0)
/// 匹配度为 1-0.1*GetRatio("43112","43040",0)
ClassMethod GetRatio(DiagDetailID, DetailID, ratio)
{
	k ^TEMP("MKB","RATIO")
	q:(DetailID=DiagDetailID)&(ratio=0) 0	//如果是完全匹配
	s ratio=ratio+1		
	s MKBTPDLastLevel=$LG($G(^User.MKBTermProDetailD(DiagDetailID)),4)  //上级	
	if (MKBTPDLastLevel'="")
	{
		if (MKBTPDLastLevel=DetailID)
		{
			s ^TEMP("MKB","RATIO")="Y"
			q ratio
		}
		else
		{
			q ..GetRatio(MKBTPDLastLevel,DetailID,ratio)
		}
	}
	if '($d(^TEMP("MKB","RATIO")))||(ratio>10)
	{	
		 q 10		 
	}
	q ratio
}

/// d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).ResetTMP()
ClassMethod ResetTMP()
{
	s MKBKLMBRowId=0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s MKBKLMFChild=0
		for
		{
			s MKBKLMFChild=$O(^User.MKBKLMappingBaseFieldI("ParIndex",MKBKLMBRowId,MKBKLMFChild))
			q:MKBKLMFChild=""
			
			s Config = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),5)
			continue:Config'="Exp"
			
			s MKBKLMDRowId=0
			for
			{
				s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("FieldDrIndex",MKBKLMBRowId_"||"_MKBKLMFChild,MKBKLMDRowId))
				q:MKBKLMDRowId=""
				
				s MKBKLMDValue = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
				d ..GenerateDiagGlobal(MKBKLMBRowId,MKBKLMDValue,MKBKLMDRowId)	
			}		
		}	
	}
}

/// 入参：工厂注册id，诊断短语描述
/// 返回值:诊断短语id^ICD代码^ICD描述^结构化TermDr^结构化Value^结构化补充诊断
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetSameDiag(1,"头痛")
ClassMethod GetSameDiag(base As %String, diag As %String)
{
	s result=""
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructIndexI("DescIndex"," "_$zconvert(diag,"U"),MKBSDRowid))
		q:MKBSDRowid=""
		continue:MKBSDRowid["ICD"
		continue:MKBSDRowid["L"
		s (MKBSDDesc,MKBSDBase,MKBSDICD,MKBSDICDDesc)=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
		continue:MKBSDBase'=base
		
		if MKBSDDesc=diag
		{
			s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
			s MKBSDICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值

			s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
			if sequence=""
			{
				s (MKBSDResultID,MKBSDResultTermdr,MKBSDSupplement)=""
			}
			else
			{
				s MKBSDRRowid=0
				for
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
					q:MKBSDRRowid=""
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					continue:MKBSDResultTermdr=""
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
				}
			}
			s result=MKBSDRowid_"^"_MKBSDICD_"^"_MKBSDICDDesc_"^"_MKBSDResultTermdr_"^"_MKBSDResultID_"^"_MKBSDSupplement
			q
		}
	}
	q result
}

/// Creator:李得原
/// Date:2019-10-22
/// Desc:结构化诊断-文献管理智能匹配
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetDocList","14870-4998:10672")
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDoc("15828")
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDoc("14870-4998:10672")
Query GetDoc(str As %String) As %Query(ROWSPEC = "MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMSource,SSUSRName,MKBDMUpdateDate,MKBDMFlag,MKBDMNote,MKBDMUpdateUser,MKBDMType,MKBDMPath")
{
}

ClassMethod GetDocExecute(ByRef qHandle As %Binary, str As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	

	q:str="" ""
	s result=""
	if ($D(^User.MKBKLMappingBaseI("IdenIndex"," LC"))'=0)
	{
		s KMBRowId = $O(^User.MKBKLMappingBaseI("IdenIndex"," LC",0))
		s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断",0))
		s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 文献",0))
		
		s ArgTermId = $P(str,"-",1)
		s ProDets = $P(str,"-",2)
		s:ProDets="" ProDets=-100000000000000
		s len = $L(str,",")
		s m=0
		for i=1:1:len //存储入参属性内容
		{
			s DetStr=$P($P(str,",",i),":",2)
			if (DetStr'="")
			{
				s dlen = $L(DetStr,"*")
				for j=1:1:dlen
				{
					s m = m+1
					s a(m)=$P(DetStr,"*",j)           //数组中a(第几个)=属性内容
				}		
			}
		}		                                          
		s ArgLen = m //入参属性内容个数
		s AllFlag = ""
		s AllStr=""
		if ($D(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets))'=0)     //Term 和 结构化结果存在 Mapping Detail中的话
		{
			s AllID = ""
			for
			{
				s AllID = $O(^User.MKBMappingRelyI("AllIndex",KMBRowId,ArgTermId,ProDets,AllID))
				q:AllID=""
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(AllID)),4)
				s FieldDr = $LG($G(^User.MKBKLMappingDetailD(AllID)),3)
				s tmp(1000,RowNum,FieldDr)=""	                                //tmp(1000，行，列)
				s AllStr=AllStr_"&"_AllID                                         //AllStr=MappingDetail的rowid
			}
		}

		s KMDRowId = 0
		for
		{
			s KMDRowId = $O(^User.MKBMappingRelyI("TermIndex",KMBRowId,ArgTermId,KMDRowId))          //term如果存在的话
			q:KMDRowId=""
			continue:AllStr[KMDRowId
			
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
			continue:RowNum=""
			continue:$D(tmp(0,RowNum))'=0
			s value = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),2)
			s TermId = $P(value,"-",1)
			s sub = $P(value,"-",2)
			s l=0
			if (sub'="")
			{
				s ProId = $P(sub,":",1)
				s DetStr = $P(sub,":",2)
				s DetNum = $L(DetStr,"*")
				for j=1:1:DetNum
				{
					s l=l+1	
					s d(l)=$P(DetStr,"*",j)		
				}	
			}	
			s ValLen = l
			s n = 0
			for i=1:1:ArgLen
			{
				for j=1:1:ValLen
				{
					if (a(i)=d(j))
					{
						s n=n+1	
					}	
				}	
			}
			
			;if (n=ValLen)
			s FieldDr = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),3)
			
			;b
			if (n'=0) //仅中心词存在匹配
			{
				s tmp(n,RowNum,FieldDr)=""	
			}
		
		}
		s result = ""
		s idresult=""
		s time = 10000
		
		for 
		{
			s time = $o(tmp(time),-1)
			q:time=""
			
			s RowNum = 0
			for
			{
				s RowNum = $O(tmp(time,RowNum))
				q:RowNum=""
				s FieldDr=0
				for
				{
					s FieldDr = $O(tmp(time,RowNum,FieldDr))
					q:FieldDr=""
					if (FieldDr=(KMBRowId_"||"_KMBFChild1))
					{
						s KMDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,KMBRowId_"||"_KMBFChild2,0))
						continue:KMDRowId=""
						s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
						continue:KMDRowNum=""
						s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild2,0))
						continue:KMDRowId2=""
						s DocId = $LG($G(^User.MKBKLMappingDetailD(KMDRowId2)),2)
						
						if (DocId'="")
						{
							continue:idresult[("&%"_DocId)
							s idresult = idresult_"&%"_DocId
							s MKBDMRowId=DocId
							s MKBDMDesc = $LG($G(^User.MKBDocManageD(MKBDMRowId)),3)
							s MKBDMCode=$LG($G(^User.MKBDocManageD(MKBDMRowId)),2)
							;MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMSource,SSUSRName,MKBDMUpdateDate,MKBDMFlag,MKBDMNote,MKBDMUpdateUser,MKBDMType,MKBDMPath
							s MKBDMPath = $LG($G(^User.MKBDocManageD(MKBDMRowId)),4)
							s MKBDMSource=$LG($G(^User.MKBDocManageD(MKBDMRowId)),5)
							s MKBDMType=$LG($G(^User.MKBDocManageD(MKBDMRowId)),6)
							s MKBDMUpdateUser=$LG($G(^User.MKBDocManageD(MKBDMRowId)),7)   
							s:MKBDMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBDMUpdateUser)),"^",2)
							s:MKBDMUpdateUser="" SSUSRName=""
							s MKBDMUpdateDate=$LG($G(^User.MKBDocManageD(MKBDMRowId)),8) 
							s:MKBDMUpdateDate'="" MKBDMUpdateDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MKBDMUpdateDate)
							s MKBDMFlag=$LG($G(^User.MKBDocManageD(MKBDMRowId)),10)
							s MKBDMNote=$LG($G(^User.MKBDocManageD(MKBDMRowId)),11)
							
							//多语言改造	
							s MKBDMDesc=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelateddocuments.csp",MKBDMDesc)
							s MKBDMSource=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelateddocuments.csp",MKBDMSource)
							s SSUSRName=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelateddocuments.csp",SSUSRName)
							s MKBDMNote=##class(websys.Translation).Get("dhc.bdp.mkb.mkbrelateddocuments.csp",MKBDMNote)
							d getCTTitle
						}
					}
				}	
			}
		}	
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMSource,SSUSRName,MKBDMUpdateDate,MKBDMFlag,MKBDMNote,MKBDMUpdateUser,MKBDMType,MKBDMPath)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocExecute ]
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

/// Creator:陈代雷
/// CreatDate:2019-12-17
/// Description:导出数据处理工厂中诊断的实际匹配结果
/// Table: User.MKBStructuredData
/// Input: DiaSource ：诊断短语数据来源id
/// Return:ICD描述,结构化结果,实际匹配结果,是否完全匹配
/// d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).ExportStructResult(1)
ClassMethod ExportStructResult(DiaSource As %String)
{
	s sum=0
	s DiaSourceDesc=$lg($g(^User.MKBStructuredBaseD(DiaSource)),2)   //诊断来源描述 
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=DiaSourceDesc_"实际匹配结果.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName
	s file=##class(%File).%New(P)
	
	//s file=##class(%File).%New("E:/DataFile/"_DiaSourceDesc_"实际匹配结果.csv")
	d file.Open("NWS")
	d file.WriteLine("ICD描述,结构化结果,实际匹配结果,是否完全匹配")
	s MKBSRowId=0    
	for           //遍历数据处理工厂表
	{
		//s MKBICDResult=""
		s MKBSRowId = $o(^User.MKBStructuredDataI("BaseIndex",DiaSource,MKBSRowId))  //通过base索引遍历对应数据处理工厂
		q:MKBSRowId=""
		s mergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSRowId)),15)  //数据是否被合并
		continue:mergeFlag'="" 
		s MKBConDesc=$lg($g(^User.MKBStructuredDataD(MKBSRowId)),2)   //诊断短语描述
		s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSRowId,0))   //获得诊断结果中最小的顺序
		if (sequence'="")
		{
			s MKBSDResultId=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSRowId,sequence,0)) //通过父表ID和顺序找到子表ID
		}
		else
		{
			s MKBSDResultId=""
		}
		//s MKBICDResultId =$o(^User.MKBICDContrastResultI("MKBICDContrastIndex",MKBICDRowId,0))  //结构化结果子表ID
		if (MKBSDResultId="")    //是否有结构化结果
		{
			s SDResult=""
			s Matching="否"
			s RealMatchDia=""
		}
		else
		{
			s MKBSDResult=$lg($g(^User.MKBStructuredDataD(MKBSRowId,"MKBSDStructResult",MKBSDResultId)),2)  //结构化结果的ID串
			s MKBSDRTerm=$lg($g(^User.MKBStructuredDataD(MKBSRowId,"MKBSDStructResult",MKBSDResultId)),4)
			//s MKBSDResult=$lg($g(^User.MKBStructuredDataD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),2)  //结构化结果的ID串
			//s MKBICDTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),4)
			s SDResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBSDResult,MKBSDRTerm)  //结构化结果描述
			s RealMatchDiaId=$p(..GetDiagViaStruct(DiaSource,MKBSDRTerm_"-"_MKBSDResult),",",1)   //实际匹配结果
			if (RealMatchDiaId="")
			{
				s RealMatchDia=""
			}
			else
			{
				s RealMatchDia=$LISTGET($G(^User.MKBStructuredDataD(RealMatchDiaId)),2) 
			}
			s Matching="否"
			if (MKBConDesc=RealMatchDia)
			{
				s Matching="是"
			}
		}
		s MKBConDesc=$replace(MKBConDesc,",","，")
		s SDResult=$replace(SDResult,",","，")
		s RealMatchDia=$replace(RealMatchDia,",","，")
		s str=MKBConDesc_","_SDResult_","_RealMatchDia_","_Matching
		d file.WriteLine(str)
		s sum = sum+1

	}
	d file.%Save()
	d file.%Close()
	//w sum
	q "{fileName:"""_fileName_"""}"
}

}

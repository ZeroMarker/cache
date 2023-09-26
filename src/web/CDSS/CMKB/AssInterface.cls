/// 石萧伟
/// 基础数据平台
/// 20181113
Class web.CDSS.CMKB.AssInterface Extends %RegisteredObject
{

/// Creator:李欣
/// CreatDate:20180604
/// Description：树形术语库部分
/// Input：base:术语库ID desc:检索字符串
/// Return:
/// Other:w ##class(web.CDSS.CMKB.AssInterface).GetTreeTerm(6,"展示名:")
ClassMethod GetTreeTerm(base As %String, str As %String) As %String
{
	w:"" (base="")&&(str="")
	k ^TMP("MKB","TreeTerm")
	
	if (str'="")
	{
		if (str["[AND]")
		{
			s separator = "[AND]"	
		}	
		elseif (str["[OR]")
		{
			s separator = "[OR]"	
		}
		else
		{
			s str=str_"[OR]"
			s separator="[OR]"	
		}
		s spnum = $l(str,separator)
		for i=1:1:spnum
		{
			s substr = $p(str,separator,i)
			q:substr="" 
			if (substr="")
			{
				s spnum=spnum-1
				q	
			}
			s pro = $p(substr,":",1)
			s pro = $zconvert(pro,"U")
			s det = $p(substr,":",2)
			s det = $zconvert(det,"U")
			
			s MKBTRowId=0
			for
			{
				s MKBTRowId = $o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId))
				q:MKBTRowId=""
				
				
				s ProId = $o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_pro,0))
				if (ProId="") 
				{
					continue	
				}
					
				s Type = $LG($g(^CT.WDT.CDSS.TermPropertyD(ProId)),4)
				if ((det="")&&($D(^CT.WDT.CDSS.TermProDetailI("ProIdx",ProId))=0))
				{
					if ($d(tmp(MKBTRowId))=0)
					{
						s tmp(MKBTRowId)=""	
					}
				}
				s DetId = 0
				for
				{
					s DetId = $o(^CT.WDT.CDSS.TermProDetailI("ProIdx",ProId,DetId))
					q:DetId=""
					s DetStr=""
					s desc = ""
					s desc=$LG($g(^CT.WDT.CDSS.TermProDetailD(DetId)),3)

					if (Type="S")
					{
						s DetStr = $LG($g(^CT.WDT.CDSS.TermD(desc)),3)	
					}
					elseif (Type="P")
					{
						for k=1:1:$l(desc,",")
						{
							s detstr=""
							if ($L(desc)-$L($TR(desc,"&"))=1)
							{
								continue	
							}
							s detproid = $p($p(desc,",",k),"&",1)
							s detprodetid = $p($p(desc,",",k),"&",3)
							s:detstr'="" detstr=detstr_","_$LG($g(^CT.WDT.CDSS.TermPropertyD(detproid)),3)
							s:detstr="" detstr=$LG($g(^CT.WDT.CDSS.TermPropertyD(detproid)),3)
							if (detprodetid'="")
							{
								s:detstr'="" detstr=detstr_","_$LG($g(^CT.WDT.CDSS.TermProDetailD(detprodetid)),3)	
								s:detstr="" detstr=$LG($g(^CT.WDT.CDSS.TermProDetailD(detprodetid)),3)	
							}	
							s:DetStr'="" DetStr=DetStr_detstr
							s:DetStr="" DetStr=detstr
						}
					}
					else
					{
						s:DetStr'="" DetStr=DetStr_desc
						s:DetStr="" DetStr=desc	
					}

					s DetStr = $zconvert(DetStr,"U")
					s DetStrPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DetStr)
					s det=$ZCONVERT(det,"U")
					if (DetStr[det)||(DetStrPY[det)
					{
						if ($d(tmp(MKBTRowId))=0)
						{
							s tmp(MKBTRowId)=""
							s tempId=MKBTRowId
							while($LG($G(^CT.WDT.CDSS.TermD(tempId)),5)'="")
							{
								
								s tempId = $LG($G(^CT.WDT.CDSS.TermD(tempId)),5)
								if ($D(tmp(tempId))=0)
								{
									s tmp(tempId)=""	
								}	
							}
							s last(MKBTRowId)=""
							s j=1
							while($d(last)'=0)
							{
								s tempId = $O(last(0))
								if ($D(^CT.WDT.CDSS.TermI("ParentIndex",base,tempId))'=0)
								{
									s p = tempId
									if ($D(tmp(tempId))=0)
									{
										s tmp(tempId)=""
										k last(tempId)
										s j =j+1
									}	
									s t = 0
									for
									{
										s t = $O(^CT.WDT.CDSS.TermI("ParentIndex",base,tempId,t))
										q:t=""
										if ($D(last(t))=0)&&($d(tmp(t))=0)
										{
											s last(t)=""	
										}	
									}
									k last(p)
								}
								else
								{
									k last(tempId)
								}
								
							}
						}	
						q
					}

				}

			}	
		}
		s MKBTRowId = 0
		for
		{
			s MKBTRowId = $O(tmp(MKBTRowId))
			q:MKBTRowId=""
			
			s MKBTLast = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)
			s:MKBTLast="" MKBTLast="Root"
			s ^TMP("MKB","TreeTerm",MKBTLast,MKBTRowId)=""	
		}
		w "["
		s i =0
		s MKBTRowId = 0
		for
		{
			s MKBTRowId = $O(^TMP("MKB","TreeTerm","Root",MKBTRowId))
			q:MKBTRowId=""
			
			if (i'=0) w ","
			d ..GetChildStr(MKBTRowId)
			s i=i+1
		}
		w "]"
		q ""
	}
	else
	{
		d ##class(web.CDSS.CMKB.Term).GetTreeJson(base,"")	
		q ""
	}
}

ClassMethod GetChildStr(MKBTRowId)
{
	s Last = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)
	if ((Last'="")&&($O(^TMP("MKB","TreeTerm",Last,""))'=MKBTRowId)) w ","
	s MKBTDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)
	
	s MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),5)   ///上级分类
	s:MKBTLastLevel'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevel)),3)
	s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
	s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),8)   ///顺序
	s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTRowId)),7)   ///顺序
	s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
	w "{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""""
	w ",""state"":""open"""
	if ($D(^TMP("MKB","TreeTerm",MKBTRowId))'=0)
	{

		s MKBTCRowId = 0	
		w ",""children"":["
		for
		{
			s MKBTCRowId = $O(^TMP("MKB","TreeTerm",MKBTRowId,MKBTCRowId))
			q:MKBTCRowId=""	
			
			
			d ..GetChildStr(MKBTCRowId)
			
		}
		w "]" 
	}
	w "}"
}

/// Creator：李欣
/// CreatDate: 2018-03-23
/// Description：查询某个或其他术语库的公有属性接口
/// Input:base : 所属术语库ID	desc:用户输入的检索条件
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssInterface","GetPublicCat","5","")
Query GetPublicCat(base As %String, q As %String) As %Query(ROWSPEC = "ID,Desc")
{
}

ClassMethod GetPublicCatExecute(ByRef qHandle As %Binary, base As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s desc=q
	if (base'="")
	{
		s:desc'="" desc=$zconvert(desc,"U")
		s ID = ""
		for
		{
			s ID = $o(^CT.WDT.CDSS.TermBasePropertyI("TermBaseIdx",base,ID))
			q:ID=""
			s Desc = $lg($g(^CT.WDT.CDSS.TermBasePropertyD(ID)),3)
			if (Desc[desc)
			{
				d OutputRow1		
			}
		}		
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(ID,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPublicCattClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPublicCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPublicCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPublicCatExecute ]
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

/****************************************************************************/
/// Creator:李欣
/// CreateDate:20180329
/// Desc:自定义查询区所有术语库信息
/// Input:
/// Optput:术语库列表的json格式
/// Other:w ##class(web.CDSS.CMKB.AssInterface).GetTermBaseSet("诊断")
ClassMethod GetTermBaseSet(desc)
{
	s ID = ""
	s result=""
	s total = 0
	s desc = $ZCONVERT(desc,"U")
	for
	{
		s ID = $o(^CT.WDT.CDSS.TermBaseD(ID))
		q:ID=""
		s Desc = $LG($G(^CT.WDT.CDSS.TermBaseD(ID)),3)
		s DescPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		if (Desc[desc)||(DescPY[desc)
		{
			s temp = "{""ID"":"""_ID_""",""Desc"":"""_Desc_"""}"	
			s:result'="" result=result_","_temp
			s:result="" result=temp	
		}
		//s total = total + 1
	}	
	s result="{""rows"":["_result_"],""total"":"_total_"}"
	//s result="["_result_"]"
	q result
}

/// Creator:李欣
/// CreateDate:20180329
/// Desc:自定义查询区查询方法
/// Input:base:用户选择的查询术语库 str:查询条件拼串
/// Optput:诊断列表的json格式
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssInterface","GetTerm",5,"部位=肺")
Query GetTerm(base As %String, str As %String) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTPYCode,MKBTNote,MKBTSequence")
{
}

ClassMethod GetTermExecute(ByRef qHandle As %Binary, base As %String, str As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s result=""
	s total = 0
	s:base="" base=5
	if (str'="")
	{
		if (str["[AND]")
		{
			s separator = "[AND]"	
		}	
		elseif (str["[OR]")
		{
			s separator = "[OR]"	
		}
		else
		{
			s str=str_"[OR]"
			s separator="[OR]"	
		}
		s spnum = $l(str,separator)
		for i=1:1:spnum
		{
			s substr = $p(str,separator,i)
			q:substr="" 
			if (substr="")
			{
				s spnum=spnum-1
				q	
			}
			s pro = $p(substr,":",1)
			s pro = $zconvert(pro,"U")
			s det = $p(substr,":",2)
			s det = $zconvert(det,"U")
			
			s MKBTRowId=0
			for
			{
				s MKBTRowId = $o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId))
				q:MKBTRowId=""
				s ProId = $o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_pro,0))
				if (ProId="") 
				{
					continue	
				}

				s Type = $LG($g(^CT.WDT.CDSS.TermPropertyD(ProId)),4)
				s DetId = 0
				for
				{
					s DetId = $o(^CT.WDT.CDSS.TermProDetailI("ProIdx",ProId,DetId))
					q:DetId=""
					s DetStr=""
					s desc=$LG($g(^CT.WDT.CDSS.TermProDetailD(DetId)),3)
					if (Type="S")
					{
						for k=1:1:$l(desc,",")
						{
							s term = $LG($g(^CT.WDT.CDSS.TermD($p(desc,",",k))),3)	
							s:DetStr'="" DetStr=DetStr_","_term
							s:DetStr="" DetStr=term
						}
					}
					elseif (Type="P")
					{
						for k=1:1:$l(desc,",")
						{
							s detstr=""
							if ($L(desc)-$L($TR(desc,"&"))=1)
							{
								continue	
							}
							s detproid = $p($p(desc,",",k),"&",1)
							s detprodetid = $p($p(desc,",",k),"&",3)
							s:detstr'="" detstr=detstr_","_$LG($g(^CT.WDT.CDSS.TermPropertyD(detproid)),3)
							s:detstr="" detstr=$LG($g(^CT.WDT.CDSS.TermPropertyD(detproid)),3)
							if (detprodetid'="")
							{
								s:detstr'="" detstr=detstr_","_$LG($g(^CT.WDT.CDSS.TermProDetailD(detprodetid)),3)	
								s:detstr="" detstr=$LG($g(^CT.WDT.CDSS.TermProDetailD(detprodetid)),3)	
							}	
							s:DetStr'="" DetStr=DetStr_detstr
							s:DetStr="" DetStr=detstr
						}
					}
					elseif (Type="SS")
					{
						s DetStr = $LG($G(^CT.WDT.CDSS.TermD(desc)),3)
						s dbase = $LG($G(^CT.WDT.CDSS.TermD(desc)),4)
						continue:dbase=""
						s childs = ##class(web.CDSS.CMKB.Term).GetChildOrderedIDStr(dbase,desc)
						if (childs'="")
						{
							for k=1:1:$L(childs,"^")
							{
								s child = $P(childs,"^",k)
								s childdesc = $LG($G(^CT.WDT.CDSS.TermD(child)),3)
								s:DetStr'="" DetStr=DetStr_childdesc
								s:DetStr="" DetStr=childdesc	
							}
						}
						
					}
					else
					{
						s:DetStr'="" DetStr=DetStr_desc
						s:DetStr="" DetStr=desc	
					}
					s DetStr = $zconvert(DetStr,"U")
					s DetStrPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DetStr)
					s det=$ZCONVERT(det,"U")
					if (DetStr[det)||(DetStrPY[det)
					{
						if ($d(tmp(MKBTRowId))=0)
						{
							s tmp(MKBTRowId)=1
						}
						else
						{
							s tmp(MKBTRowId)=tmp(MKBTRowId)+1
						}
						q
					}
				}
			}	
		}
		s ID=""
		for
		{
			s ID =$o(tmp(ID))
			q:ID=""
			s temp(tmp(ID),ID)=""	
		}
		s time=1000
		s result=""
		for
		{
			s time=$o(temp(time),-1)
			q:time=""
			s ID=""
			for
			{
				s ID = $o(temp(time,ID))
				q:ID=""
				s Desc = $LG($G(^CT.WDT.CDSS.TermD(ID)),3)
				s PYCode=$listGet($g(^CT.WDT.CDSS.TermD(ID)),6)
				s Note=$listGet($g(^CT.WDT.CDSS.TermD(ID)),7)
				s Seq = $LG($G(^CT.WDT.CDSS.TermD(ID)),8)
				if (separator="[AND]")
				{
					if (time=spnum)
					{
						d OutputRow14
					}
				}
				elseif (separator="[OR]")
				{
				    d OutputRow14
				}
			}	
		}	
	}
	else
	{
		s ID=""
		for  
		{	
			s ID=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,ID),-1) q:ID="" 
			s Desc=$listGet($g(^CT.WDT.CDSS.TermD(ID)),3)  //描述
			s PYCode=$listGet($g(^CT.WDT.CDSS.TermD(ID)),6)
			s Note=$listGet($g(^CT.WDT.CDSS.TermD(ID)),7)
			s Seq=$listGet($g(^CT.WDT.CDSS.TermD(ID)),8)
			d OutputRow14		
		}	
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow14
    set Data=$lb(ID,Desc,PYCode,Note,Seq)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTermClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPublicCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTermFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPublicCatExecute ]
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

/// Creator：丁亚男
/// CreatDate: 2018-3-27
/// Description：查询列表子术语库内容
/// Table：CT.WDT.CDSS.Term
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.Term","GetList","","","")
Query GetList(rowid, str, base) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTSequence")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, str, base) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	  
	if (base'="") //如果子术语库大类未选中
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			s MKBTRowId=rowid
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)  //顺序
			d OutputRow
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
					s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //拼音码
					s MKBTSequence=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),8)
					
					i ((MKBTDesc[str)||($ZCONVERT(MKBTPYCode,"U")[str))   //条件
					{
						d OutputRow
					}		
					//}
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTSequence)
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

/// Creator：李欣
/// CreatDate: 2018-06-13
/// Description：查询科室常用诊断
/// Table：CT.WDT.CDSS.Term
/// Input：DepId :科室ID
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssInterface","GetDepUsualTerm","15","")
Query GetDepUsualTerm(LocId, desc) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTFreq")
{
}

ClassMethod GetDepUsualTermExecute(ByRef qHandle As %Binary, LocId, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	 
	if (LocId'="")
	{
		s DepId = 0
		for
		{
			s DepId = $O(^User.MKBLocContrastI("LocIndex",LocId,DepId))
			q:DepId=""
			s:desc'="" desc=$ZCONVERT(desc,"U")
			s MKBTDRowId = 0
			for
			{
				s MKBTDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",DepId,"D",MKBTDRowId))
				q:MKBTDRowId=""
				s MKBTPRowId = $LG($G(^CT.WDT.CDSS.TermProDetailD(MKBTDRowId)),6)
				continue:MKBTPRowId=""
				s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)  //属性名
				continue:MKBTPDesc'="相关科室"
				s MKBTRowId = $LG($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),6)
				continue:MKBTRowId=""
				
				
				s Freq = 0
				if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_MKBTRowId))'=0)
				{
					s FreqID = $O(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_MKBTRowId,0))	
					s Freq = $LG($G(^User.BDPDataFrequencyD(FreqID)),5) 
				}
				
				s MKBTDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)
				s ComAlias = ##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)
				s MKBTPYCode = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
				
				if (((MKBTDesc[desc)||(MKBTPYCode[desc)||(ComAlias[desc)))
				{
					s UT(Freq,MKBTRowId)=MKBTDesc
				}
			}
		}
		s Freq = ""
		for
		{
			s Freq = $O(UT(Freq),-1)
			q:Freq=""
			s MKBTRowId=0
			for
			{
				s MKBTRowId = $O(UT(Freq,MKBTRowId))
				q:MKBTRowId=""
				
				s MKBTDesc=UT(Freq,MKBTRowId)
				d OutputRowDetUsualTerm
			}	
		}
	}

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDetUsualTerm
    set Data=$lb(MKBTRowId,MKBTDesc,Freq)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDepUsualTermClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepUsualTermExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDepUsualTermFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepUsualTermExecute ]
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

/// Creator：李欣
/// CreatDate: 2018-06-13
/// Description：查询除指定科室外其他诊断
/// Table：CT.WDT.CDSS.Term
/// Input：DepId :科室ID
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssInterface","GetExcLocTerm","15","")
Query GetExcLocTerm(LocId, q) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTFreq")
{
}

ClassMethod GetExcLocTermExecute(ByRef qHandle As %Binary, LocId, q) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	 
	if (LocId'="")
	{
		s DepId = 0
		s LocTerm = ""
		for
		{
			s DepId = $O(^User.MKBLocContrastI("LocIndex",LocId,DepId))
			q:DepId=""
			s:q'="" q=$ZCONVERT(q,"U")
			s MKBTDRowId = 0
			for
			{
				s MKBTDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",DepId,"D",MKBTDRowId))
				q:MKBTDRowId=""
				s MKBTPRowId = $LG($G(^CT.WDT.CDSS.TermProDetailD(MKBTDRowId)),6)
				continue:MKBTPRowId=""
				s MKBTRowId = $LG($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),6)
				
				s:LocTerm'="" LocTerm=LocTerm_"("_MKBTRowId_")"
				s:LocTerm="" LocTerm="("_MKBTRowId_")"
			}
		}

		s MKBTRowId = 0
		s MKBTBRowId = $O(^CT.WDT.CDSS.TermBaseI("FlagIndex"," DIAGNOSE",0))
		for
		{
			s MKBTRowId = $O(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBRowId,MKBTRowId))
			q:MKBTRowId=""	
			continue:LocTerm[("("_MKBTRowId_")")
			
			s Freq = 0
			if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_MKBTRowId))'=0)
			{
				s FreqID = $O(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_MKBTRowId,0))	
				s Freq = $LG($G(^User.BDPDataFrequencyD(FreqID)),5) 
			}
			
			s MKBTDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)
			s ComAlias = ##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(MKBTRowId)
			s MKBTPYCode = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),6)
			if (((MKBTDesc[q)||(MKBTPYCode[q)||(ComAlias[q)))
			{
				d OutputRowExcLocTerm	
			}
		}
		
	}

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowExcLocTerm
    set Data=$lb(MKBTRowId,MKBTDesc,Freq)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetExcLocTermClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExcLocTermExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetExcLocTermFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExcLocTermExecute ]
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

/// 根据base描述获取id
/// 石萧伟
/// w ##class(web.CDSS.CMKB.AssInterface).getIdByDesc("诊断学_临床实用诊断")
ClassMethod getIdByDesc(desc)
{
	s id=""
	s id=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_desc,0)) q:id=""
	q id
}

/// 根据当前登录科室id获取相关科室id
/// 石萧伟
/// w ##class(web.CDSS.CMKB.AssInterface).getLocIdByHis("1")
ClassMethod getLocIdByHis(Id)
{
	s DepId=""
	s DepId = $O(^User.MKBLocContrastI("LocIndex",Id,DepId)) q:DepId=""
	q DepId
}

/// 展开属性
/// 石萧伟
/// 
ClassMethod getProId(Id)
{
	s ProId=""
	s ProId = $O(^CT.WDT.CDSS.TermPropertyI("DescIndex",Id," 科室常用诊断",0)) q:ProId=""
	q ProId
}

/// Creator：李欣
/// CreatDate: 2018-07-05
/// Description:结构化诊断列表辅助功能区添加诊断
/// Table：CT.WDT.CDSS.Term
/// Input：LocId HIS科室ID   TermID术语ID   Freq频次
/// Other: w ##class(web.CDSS.CMKB.AssInterface).SaveLocTerm(65729,202,2222)
ClassMethod SaveLocTerm(TermID, LocId, Freq)
{
	s:Freq="" Freq=0
	s DepId=0
	if (LocId'="")
	{
		s DepId = $O(^User.MKBLocContrastI("LocIndex",LocId,DepId))
		q:DepId="" ""
		s ProId = $O(^CT.WDT.CDSS.TermPropertyI("DescIndex",TermID," 相关科室",0))
		d ##class(web.CDSS.CMKB.TermProDetail).SaveSelectTermIds(ProId,DepId,"")	
	}
	s FreqId=""
	if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_TermID))=0)
	{
		
		s obj = ##class(User.BDPDataFrequency).%New()
		s BDPDAFUserID=$g(%session.Data("LOGON.USERID"))
		s BDPCTLocDR=$g(%session.Data("LOGON.CTLOCID"))
		s obj.BDPDAFTableName = "User.SDSStructDiagnosEntry"
		s obj.BDPDAFDataReference = TermID
		s TermDesc = $LG($G(^CT.WDT.CDSS.TermD(TermID)),3)
		s obj.BDPDAFDesc = TermDesc
		s obj.BDPDAFFrequency = Freq
		d obj.BDPCTLocDRSetObjectId(BDPCTLocDR)
		d obj.BDPDAFUserIDSetObjectId(BDPDAFUserID)
		d obj.%Save()
	}
	else
	{
		s BDPDAFUserID=$g(%session.Data("LOGON.USERID"))
		s BDPCTLocDR=$g(%session.Data("LOGON.CTLOCID"))
		
		s FreqId = $O(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_TermID,0))
		s obj = ##class(User.BDPDataFrequency).%OpenId(FreqId)
		d obj.BDPCTLocDRSetObjectId(BDPCTLocDR)
		d obj.BDPDAFUserIDSetObjectId(BDPDAFUserID)
		s ^lee(0)=obj.BDPCTLocDR.%Id()
		s obj.BDPDAFFrequency = Freq
		d obj.%Save()
	}
	q ""
}

/// Creator：李欣
/// CreatDate: 2018-07-05
/// Description:结构化诊断列表辅助功能区修改诊断频次
/// Table：CT.WDT.CDSS.Term
/// Input：LocId HIS科室ID   TermID术语ID   Freq频次
/// Other: d ##class(web.CDSS.CMKB.AssInterface).UpdataLocTerm(65729,111)
ClassMethod UpdataLocTerm(TermID, Freq)
{
	s FreqId=""
	//w $D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," 65729"))
	//b
	if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_TermID))'=0)&&((Freq'=0)&&(Freq'=""))
	{
		s FreqId = $O(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.SDSSTRUCTDIAGNOSENTRY"," "_TermID,0))
		s obj = ##class(User.BDPDataFrequency).%OpenId(FreqId)	
		s obj.BDPDAFFrequency = Freq
		d obj.%Save()
	}
	q ""
}

/// Creator：李欣
/// CreatDate: 2018-07-05
/// Description:结构化诊断列表辅助功能区删除诊断
/// Table：CT.WDT.CDSS.Term
/// Input：LocId HIS科室ID   TermID术语ID   Freq频次
/// Other: d ##class(web.CDSS.CMKB.AssInterface).DelLocTerm(65729,"1")
ClassMethod DelLocTerm(TermID, LocId)
{
	s DepId=0
	s result=""
	if (LocId'="")
	{
		s DepId = $O(^User.MKBLocContrastI("LocIndex",LocId,DepId))
		q:DepId=""
		
		s ProId = $O(^CT.WDT.CDSS.TermPropertyI("DescIndex",TermID," 相关科室",0))
		s result= ##class(web.CDSS.CMKB.TermProDetail).SaveSelectTermIds(ProId,"",DepId)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_Term","CT.WDT.CDSS.TermLoc"_LocId,"科室相关诊断",TermID,TermID,"D","")	
	
	}
	q ""
}

/// creater: 石萧伟
/// data：2018-11-21
/// description: 将批量处理的id存在临时globle中
/// input：termIds ^
/// other:  d ##class(web.CDSS.CMKB.AssInterface).putIdIntoGloble("")
ClassMethod putIdIntoGloble(termIds)
{
	for i=1:1:$L(termIds,"^")
	{
		s term = $P(termIds,"^",i)
		s ^TMP("mkbTermCR",term)="" 
		k ^TMP("mkbTermCRGUM",term)
	}
	q ""
}

/// creater: 石萧伟
/// data：2018-12-10
/// description: 删除临时globle里的id
/// input：termIds ^
/// other:  d ##class(web.CDSS.CMKB.AssInterface).putIdIntoGloble("")
ClassMethod delIdFromGloble(termIds)
{
	for i=1:1:$L(termIds,"^")
	{
		s term = $P(termIds,"^",i)
		k ^TMP("mkbTermCR",term)
		k ^TMP("mkbTermCRGUM",term)
	}
	q ""
}

/// creater: 石萧伟
/// data：2018-11-21
/// description: 判断termId是否存在与临时globle
/// input：termId
/// other:  d ##class(web.CDSS.CMKB.AssInterface).justTermExist("")
ClassMethod justTermExist(termId)
{
	if ($D(^TMP("mkbTermCR",termId)))
	{
		q "1"	
	}
	else
	{
		q "0"
	}
}

/// creater: 石萧伟
/// data：2018-12-04
/// description: 放弃编辑
/// input：termIds ^
/// other:  d ##class(web.CDSS.CMKB.AssInterface).putIdIntoGloble("")
ClassMethod giveUpManage(termIds)
{
	for i=1:1:$L(termIds,"^")
	{
		s term = $P(termIds,"^",i)
		s ^TMP("mkbTermCRGUM",term)="" 
		k ^TMP("mkbTermCR",term)
	}
	q ""
}

/// creater: 李欣
/// data：2018-11-23
/// description: 根据部位id获取诊断学包含描述的数据
/// input：termId
/// other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssInterface","GetDiagByPart","16393","","") 
Query GetDiagByPart(PartId, desc, deal) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBPartDescF,MKBPartDesc,MKBDisDescF,MKBDisDesc,MKByn")
{
}

ClassMethod GetDiagByPartExecute(ByRef qHandle As %Binary, PartId, desc, deal) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s base = $O(^CT.WDT.CDSS.TermBaseI("FlagIndex"," PART",0))
	
	s partids = PartId_"^"_##class(web.CDSS.CMKB.Term).GetChildOrderedIDStr(base,PartId)
	for i=1:1:$L(partids,"^")
	{
		continue:$P(partids,"^",i)=""
		s PartDesc = $LG($G(^CT.WDT.CDSS.TermD($P(partids,"^",i))),3)
		s pd(PartDesc)=""	
	}
	
	
	s MKBTBRowId = $O(^CT.WDT.CDSS.TermBaseI("FlagIndex"," DIAGNOSE",0))
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)
		s MKBTPRowId = $O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 部位",0))
		continue:MKBTPRowId=""	

		s MKBTPDRowId = $O(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0))
		
		continue:MKBTPDRowId=""
		s MKBTPDDesc = $LG($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
		s MKBPartDescF = MKBTPDDesc
		s MKBPartDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTPDDesc)),3)
		
		s MKBTPOtherRowId = $O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 病因",0))
		s MKBTPDOtherRowId=""		
		s:MKBTPOtherRowId'="" MKBTPDOtherRowId = $O(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPOtherRowId,0))
		
		if (MKBTPDOtherRowId="")
		{
			s MKBDisDescF = ""
			s MKBDisDesc = ""	
		}
		else
		{
			s MKBTPDOtherDesc = $LG($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDOtherRowId)),3)
			s MKBDisDescF=MKBTPDOtherDesc
			s MKBDisDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTPDOtherDesc)),3)	
		}
		
		s PartDesc=""
		for
		{
			s PartDesc=$O(pd(PartDesc))	
			q:PartDesc=""
			
			if (MKBPartDesc=PartDesc)
			{
				if (deal=1)
				{
					if ($D(^TMP("mkbTermCR",MKBTRowId))) && (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							s MKByn=1
							d PartOutput
							s term(MKBTRowId)=""
							q
						}
							
					}		
				}
				elseif(deal=0)
				{
					if ($D(^TMP("mkbTermCR",MKBTRowId))=0) && (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							if ($D(^TMP("mkbTermCRGUM",MKBTRowId)))
							{
								s MKByn=2
							}
							else
							{
								s MKByn=0
							}
							s term(MKBTRowId)=""
							d PartOutput
							q
						}		
					}	
				}
				elseif(deal=2)
				{
					if ($D(^TMP("mkbTermCRGUM",MKBTRowId))) && (MKBTDesc[desc) &&($D(^TMP("mkbTermCR",MKBTRowId))=0)
					{
						if ($D(term(MKBTRowId))=0)
						{
							s MKByn=2
							d PartOutput
							s term(MKBTRowId)=""
							q	
						}
						
					}				
				}
				else
				{
					if (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							if ($D(^TMP("mkbTermCR",MKBTRowId)))
							{
								s MKByn=1
							}
							else
							{
								if ($D(^TMP("mkbTermCRGUM",MKBTRowId)))
								{
									s MKByn=2
								}
								else
								{
									s MKByn=0
								}
							}
							s term(MKBTRowId)=""
							d PartOutput
							q	
						}
					}		
				}	
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PartOutput
    set Data=$lb(MKBTRowId,MKBTDesc,MKBPartDescF,MKBPartDesc,MKBDisDescF,MKBDisDesc,MKByn)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiagByPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagByPartExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagByPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagByPartExecute ]
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

/// creater: 石萧伟
/// data：2018-11-23
/// description: 根据病因id获取诊断学包含描述的数据
/// input：termId
/// other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssInterface","GetDiagByDis","16412","","") 
Query GetDiagByDis(PartId, desc, deal) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBDisDescF,MKBDisDesc,MKBPartDescF,MKBPartDesc,MKByn")
{
}

ClassMethod GetDiagByDisExecute(ByRef qHandle As %Binary, PartId, desc, deal) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	 
	s base = $O(^CT.WDT.CDSS.TermBaseI("FlagIndex"," PATHOGENY",0))
	
	s disids = PartId_"^"_##class(web.CDSS.CMKB.Term).GetChildOrderedIDStr(base,PartId)
	for i=1:1:$L(disids,"^")
	{
		continue:$P(disids,"^",i)=""
		s DisDesc = $LG($G(^CT.WDT.CDSS.TermD($P(disids,"^",i))),3)
		s pd(DisDesc)=""	
	}
	
	
	s MKBTBRowId = $O(^CT.WDT.CDSS.TermBaseI("FlagIndex"," DIAGNOSE",0))
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTRowId)),3)
		s MKBTPRowId = $O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 病因",0))
		continue:MKBTPRowId=""	

		s MKBTPDRowId = $O(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0))
		continue:MKBTPDRowId=""
		s MKBTPDDesc = $LG($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
		s MKBDisDescF = MKBTPDDesc
		s MKBDisDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTPDDesc)),3)
		
		s MKBTPOtherRowId = $O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 部位",0))
		s MKBTPDOtherRowId = $O(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPOtherRowId,0))
		if (MKBTPDOtherRowId="")
		{
			s MKBPartDescF = ""
			s MKBPartDesc = ""	
		}
		else
		{
			s MKBTPDOtherDesc = $LG($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDOtherRowId)),3)
			s MKBPartDescF = MKBTPDOtherDesc
			s MKBPartDesc = $LG($G(^CT.WDT.CDSS.TermD(MKBTPDOtherDesc)),3)	
		}
		
		s DisDesc=""
		for
		{
			s DisDesc=$O(pd(DisDesc))	
			q:DisDesc=""
			
			if (MKBDisDesc=DisDesc)
			{
				if (deal=1)
				{
					if ($D(^TMP("mkbTermCR",MKBTRowId))) && (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							s MKByn=1
							d DisOutput
							s term(MKBTRowId)=""
							q
						}
							
					}		
				}
				elseif(deal=0)
				{
					if ($D(^TMP("mkbTermCR",MKBTRowId))=0) && (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							if ($D(^TMP("mkbTermCRGUM",MKBTRowId)))
							{
								s MKByn=2
							}
							else
							{
								s MKByn=0
							}
							s term(MKBTRowId)=""
							d DisOutput
							q
						}		
					}	
				}
				elseif(deal=2)
				{
					if ($D(^TMP("mkbTermCRGUM",MKBTRowId))) && (MKBTDesc[desc) &&($D(^TMP("mkbTermCR",MKBTRowId))=0)
					{
						if ($D(term(MKBTRowId))=0)
						{
							s MKByn=2
							d DisOutput
							s term(MKBTRowId)=""
							q	
						}
						
					}				
				}
				else
				{
					if (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							if ($D(^TMP("mkbTermCR",MKBTRowId)))
							{
								s MKByn=1
							}
							else
							{
								if ($D(^TMP("mkbTermCRGUM",MKBTRowId)))
								{
									s MKByn=2
								}
								else
								{
									s MKByn=0
								}
							}
							s term(MKBTRowId)=""
							d DisOutput
							q	
						}
					}		
				}	
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DisOutput
    set Data=$lb(MKBTRowId,MKBTDesc,MKBDisDescF,MKBDisDesc,MKBPartDescF,MKBPartDesc,MKByn)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiagByDisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagByDisExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagByDisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagByDisExecute ]
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
/// CreatDate:2018-05-02
/// Description：树形术语库部分
/// Input：上级节点，术语库注册表的ID
/// Return:成功返回术语类型
/// Other:w ##class(web.CDSS.CMKB.Term).GetTreeJson(31,"")
ClassMethod GetTreeJson(base As %String, id As %String) As %String
{
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
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
	;b ;11
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
	;b ;22
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
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		s count=count+1
		s MKBTDesc=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),3)   ///中心词
		s MKBTDesc=$tr(MKBTDesc,"""","")
		s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
		s MKBTCode=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),2) ///代码
		s MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),5)   ///上级分类
		s:MKBTLastLevel'="" MKBTLastLevel=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTLastLevel)),3)
		s MKBTPYCode=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),6)
		s MKBTSequence=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),8)   ///顺序
		s MKBTNote=$LISTGET($G(^CT.WDT.CDSS.TermD(myRowID)),7)   ///顺序
		s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
		if count>1 w ","
		w "{""id"":"""_myRowID_""""
		w ",""MKBTRowId"":"""_myRowID_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""""
		s childStr=..GetTreeChildOrderedIDStr(base,myRowID)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetTreeJson(base,myRowID)	
		}
		else
		{
			w ",""state"":""open"""
		}
		w "}"
		
	}
	w "]"
	q ""
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
	s myRowID=0
	
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
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s childStr=..GetTreeChildOrderedIDStr(base,myRowID)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// creater: 石萧伟
/// data：2018-12-14
/// description: 复制术语以及属性内容
/// input：termIds ^
/// other:  d ##class(web.CDSS.CMKB.AssInterface).putIdIntoGloble("")
ClassMethod copyIdToGloble(flag, id)
{
	Set userId=%session.Get("LOGON.USERID")
	k ^TMP("mkbTermCopyToPaste",userId)
	s ^TMP("mkbTermCopyToPaste",userId,flag,id)=""	 
	q ""
}

/// w ##class(web.CDSS.CMKB.AssInterface).GetNewTerm(5,"病情描述:感染")
ClassMethod GetNewTermOld(base, str)
{
	
	s result=""
	s total = 0
	s:base="" base=5
	if (str'="")
	{
		if (str["[AND]")
		{
			s separator = "[AND]"	
		}	
		elseif (str["[OR]")
		{
			s separator = "[OR]"	
		}
		else
		{
			s str=str_"[OR]"
			s separator="[OR]"	
		}
		s spnum = $l(str,separator)
		for i=1:1:spnum
		{
			s substr = $p(str,separator,i)
			q:substr="" 
			if (substr="")
			{
				s spnum=spnum-1
				q	
			}
			s pro = $p(substr,":",1)
			s pro = $zconvert(pro,"U")
			s det = $p(substr,":",2)
			s det = $zconvert(det,"U")
			
			s MKBTRowId=0
			for
			{
				s MKBTRowId = $o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId))
				q:MKBTRowId=""
				s ProId = $o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_pro,0))
				if (ProId="") 
				{
					continue	
				}

				s Type = $LG($g(^CT.WDT.CDSS.TermPropertyD(ProId)),4)
				s DetId = 0
				for
				{
					s DetId = $o(^CT.WDT.CDSS.TermProDetailI("ProIdx",ProId,DetId))
					q:DetId=""
					s DetStr=""
					s desc=$LG($g(^CT.WDT.CDSS.TermProDetailD(DetId)),3)
					if (Type="S")
					{
						for k=1:1:$l(desc,",")
						{
							s term = $LG($g(^CT.WDT.CDSS.TermD($p(desc,",",k))),3)	
							s:DetStr'="" DetStr=DetStr_","_term
							s:DetStr="" DetStr=term
						}
					}
					elseif (Type="P")
					{
						for k=1:1:$l(desc,",")
						{
							s detstr=""
							if ($L(desc)-$L($TR(desc,"&"))=1)
							{
								continue	
							}
							s detproid = $p($p(desc,",",k),"&",1)
							s detprodetid = $p($p(desc,",",k),"&",3)
							s:detstr'="" detstr=detstr_","_$LG($g(^CT.WDT.CDSS.TermPropertyD(detproid)),3)
							s:detstr="" detstr=$LG($g(^CT.WDT.CDSS.TermPropertyD(detproid)),3)
							if (detprodetid'="")
							{
								s:detstr'="" detstr=detstr_","_$LG($g(^CT.WDT.CDSS.TermProDetailD(detprodetid)),3)	
								s:detstr="" detstr=$LG($g(^CT.WDT.CDSS.TermProDetailD(detprodetid)),3)	
							}	
							s:DetStr'="" DetStr=DetStr_detstr
							s:DetStr="" DetStr=detstr
						}
					}
					elseif (Type="SS")
					{
						s DetStr = $LG($G(^CT.WDT.CDSS.TermD(desc)),3)
						s dbase = $LG($G(^CT.WDT.CDSS.TermD(desc)),4)
						continue:dbase=""
						s childs = ##class(web.CDSS.CMKB.Term).GetChildOrderedIDStr(dbase,desc)
						if (childs'="")
						{
							for k=1:1:$L(childs,"^")
							{
								s child = $P(childs,"^",k)
								s childdesc = $LG($G(^CT.WDT.CDSS.TermD(child)),3)
								s:DetStr'="" DetStr=DetStr_childdesc
								s:DetStr="" DetStr=childdesc	
							}
						}
						
					}
					else
					{
						s:DetStr'="" DetStr=DetStr_desc
						s:DetStr="" DetStr=desc	
					}
					s DetStr = $zconvert(DetStr,"U")
					s DetStrPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DetStr)
					s det=$ZCONVERT(det,"U")
					if (DetStr[det)||(DetStrPY[det)
					{
						if ($d(tmp(MKBTRowId))=0)
						{
							s tmp(MKBTRowId)=1
						}
						else
						{
							s tmp(MKBTRowId)=tmp(MKBTRowId)+1
						}
						q
					}
				}
			}	
		}
		s ID=""
		for
		{
			s ID =$o(tmp(ID))
			q:ID=""
			s temp(tmp(ID),ID)=""	
		}
		s time=1000
		s num=0
		w "["
		s result=""
		for
		{
			s time=$o(temp(time),-1)
			q:time=""
			s ID=""
			for
			{
				s ID = $o(temp(time,ID))
				q:ID=""
				s Desc = $LG($G(^CT.WDT.CDSS.TermD(ID)),3)
				s PYCode=$listGet($g(^CT.WDT.CDSS.TermD(ID)),6)
				s Note=$listGet($g(^CT.WDT.CDSS.TermD(ID)),7)
				s Seq = $LG($G(^CT.WDT.CDSS.TermD(ID)),8)
				if (separator="[AND]")
				{
					
					if (time=spnum)
					{
						d OutputRow15
					}
				}
				elseif (separator="[OR]")
				{
				    d OutputRow15
				}
			}	
		}	
	}
	else
	{
		s num=0
		w "["
		s ID=""
		for  
		{	
			s ID=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,ID),-1) q:ID="" 
			s Desc=$listGet($g(^CT.WDT.CDSS.TermD(ID)),3)  //描述
			s PYCode=$listGet($g(^CT.WDT.CDSS.TermD(ID)),6)
			s Note=$listGet($g(^CT.WDT.CDSS.TermD(ID)),7)
			s Seq=$listGet($g(^CT.WDT.CDSS.TermD(ID)),8)
			d OutputRow15		
		}	
	}
	w "]"
	q ""
OutputRow15
    if num=0
    {
		s num = 1
	}
	else
	{
		w ","	
	}
	w "{""MKBTRowId"":"""_ID_""",""MKBTDesc"":"""_Desc_""",""MKBTPYCode"":"""_PYCode_""",""MKBTNote"":"""_Note_""",""MKBTSequence"":"""_Seq_"""}"
}

/// 石萧伟
/// 根据公有属性id查看类型
ClassMethod getPubType(id)
{
	q:id="" ""
	s type = $LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(id)),4)
	s baseid = $LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(id)),6)
	q type_"*"_baseid
}

/// Creator:谷雪萍
/// CreatDate:2021-11-26
/// Description：百科管理-辅助功能区-多条件检索
/// Input：base术语库注册id，str-检索信息串，rows-每页显示行数，page-第几页
/// Return：成功返回满足条件的术语信息JSON串 ,失败返回"{""rows"":[], ""total"":0}"
/// d ##class(web.CDSS.CMKB.AssInterface).GetNewTerm(120,"责任人:E:周勇;*别名:C:综合",10,1)
ClassMethod GetNewTerm(base As %String, str As %String, rows As %String, page As %String)
{
	q:(base="")||(str="") "{""rows"":[], ""total"":0}"
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s serchLen = $L(str,";")
	s separate="*"  //且
	if (str["|")  //或
	{
		s separate="|"	
	}
	s str=$REPLACE(str,separate,"")
	
	for serchi=1:1:serchLen
	{
		s substr=$P(str,";",serchi)
		s bpdesc=$P(substr,":",1)  //属性描述
		s condition = $P(substr,":",2)  //逻辑条件C-包含/E-等于
		s givedesc = $P(substr,":",3)  //检索条件
		
		s bpid = $O(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",base," "_bpdesc,0))         
		s bptype=$LG($G(^CT.WDT.CDSS.TermBasePropertyD(bpid)),4)                          //属性的格式
		//文本,多行文本框,单选框,复选框,下拉框,文本编辑器、列表、树形
		s MKBTRowId=0
		for
		{
			s MKBTRowId=$O(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId))	
			q:MKBTRowId=""
			s MKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_$ZCONVERT(bpdesc,"U"),0))
			continue:MKBTPRowId=""
			continue:$D(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))=0
			s MKBTPDRowId=0
			for
			{
				s MKBTPDRowId=$O(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
				q:MKBTPDRowId=""
				
				s MKBTPDDesc = $LG($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
				if (condition="E")    //等于
				{
					if (MKBTPDDesc=givedesc)
					{
						s OutPutArr(MKBTRowId)=$g(OutPutArr(MKBTRowId))+1
						q
					}	
				}
				else //包含
				{
					if (MKBTPDDesc[givedesc)
					{
						
						s OutPutArr(MKBTRowId)=$g(OutPutArr(MKBTRowId))+1
						q
					}	
				}

			}
		}		

	}
	
	//*************************************

	s ShowInLeftInfo=##class(web.CDSS.CMKB.Term).GetShowInLeftInfo(base)
	s num=0
	w "{""rows"":["

	s ID=""
	for
	{
		s ID=$O(OutPutArr(ID))
		q:ID=""
		if (separate="*")  //且的话必须满足满所条件才能输出
		{
			continue:OutPutArr(ID)'=serchLen
		}
		s Desc=$listGet($g(^CT.WDT.CDSS.TermD(ID)),3)  //描述
		s PYCode=$listGet($g(^CT.WDT.CDSS.TermD(ID)),6)
		s Note=$listGet($g(^CT.WDT.CDSS.TermD(ID)),7)
		s Seq=$listGet($g(^CT.WDT.CDSS.TermD(ID)),8)
		s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(ID)),10)
		s MKBTActiveFlag=$listGet($g(^CT.WDT.CDSS.TermD(ID)),9)
		s MKBTDetailCount=$listGet($g(^CT.WDT.CDSS.TermD(ID)),10)
		
		s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(ID)),11)
		s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(ID)),12)
		s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(ID)),13)
		s Status=$listGet($g(^CT.WDT.CDSS.TermD(ID)),14)
		//展示在左侧的数据
		s ExtendStr="",mainstr=""
		if (ShowInLeftInfo'="")
		{
			s ShowInLeftDR=$p(ShowInLeftInfo,"[A]",1)
			s ShowInLeftDesc=$p(ShowInLeftInfo,"[A]",2)
			s len=$length(ShowInLeftDesc,"[N]")
			for i=1:1:len
			{
				s MKBTBPRowID=$p(ShowInLeftDR,"[N]",i)
				s MKBTPDesc=$p(ShowInLeftDesc,"[N]",i)
				s MKBTPDDesc=""
				if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",ID," "_MKBTPDesc)))
				{
					s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",ID," "_MKBTPDesc,0))
					s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
					s MKBTPDDesc=##class(web.CDSS.CMKB.TermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
				} 
				s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
				s:ExtendStr'="" ExtendStr=ExtendStr_","
				s ExtendStr=ExtendStr_thisStr
			} 
		}
		
		s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_ID_""",""MKBTDesc"":"""_Desc_""",""MKBTPYCode"":"""_PYCode_""",""MKBTNote"":"""_Note_""",""MKBTSequence"":"""_Seq_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_""","_ExtendStr_"}"
	    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_ID_""",""MKBTDesc"":"""_Desc_""",""MKBTPYCode"":"""_PYCode_""",""MKBTNote"":"""_Note_""",""MKBTSequence"":"""_Seq_""",""MKBTDetailCount"":"""_MKBTDetailCount _""",""UpdateDate"":"""_UpdateDate_""",""ResponUser"":"""_ResponUser_""",""ReviewUser"":"""_ReviewUser_""",""Status"":"""_Status_"""}"
		s num=num+1
		
		if (num<stpage) continue
		if (num<=endpage)
		{
			if num'=stpage
		    {
				w ","	
			}
			w mainstr
		}
					
	}
	k OutPutArr			
	
	w "],""total"":"_num_"}"
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2021-11-26
/// Description：拼接两个用^连接的字串
/// Input：oldstr-用^连接的字串1，newstr--用^连接的字串2，flag-|(拼接所有)，空（只拼接重复的）
/// Return：成功返回属性名称的串 ,失败返回""
/// 输出两个字符串中，相同的字符串
/// d ##class(web.CDSS.CMKB.AssInterface).CompareString("1^2^3^4","2^3^5^6")
ClassMethod CompareString(oldstr As %String, newstr As %String, flag As %String = "")
{
	s str=""
	if (flag="|")
    {

		for newstrj=1:1:$l(newstr)
		{
			s newone=$p(newstr,"^",newstrj)
			continue:newone=""
			if ("^"_oldstr_"^")[("^"_newone_"^")
			{
				continue
			}
			else
			{
				s str=str_"^"_newone
			}
		
		}
		s str=oldstr_str
	}
	else
	{
	    s oldstr="^"_oldstr_"^"
		for newstrj=1:1:$l(newstr)
		{
			s newone=$p(newstr,"^",newstrj)
			continue:newone=""
			if oldstr[("^"_newone_"^")
			{
				s str=str_"^"_newone
			}
		
		}
	}
	q str
}

}

/// Description:数据工厂
/// Creator：李得原
/// Date： 2018-11-26
Class web.DHCBL.MKB.MKBStructuredData Extends %RegisteredObject
{

/// Creator:钟荣枫
/// CreatDate:2021-8-10
/// Description:根据门诊类型字符串返回描述串
/// Table:
/// Input:  MKBSDClinicType
/// Return: 描述串  "门诊,急诊,住院,体检,新生儿"
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetClinicType()
ClassMethod GetClinicType(MKBSDClinicType)
{
	s typestr=""
	if (MKBSDClinicType="")
	{
		s typestr="门诊,急诊,住院,体检,新生儿"
	}
	else
	{
		if (MKBSDClinicType["O")
		{
			s typestr="门诊"
		}
		if (MKBSDClinicType["E")
		{
			if (typestr="")
			{
				s typestr="急诊"
			}
			else
			{
				s typestr=typestr_",急诊"
			}
			
		}
		if (MKBSDClinicType["I")
		{
			if (typestr="")
			{
				s typestr="住院"
			}
			else
			{
				s typestr=typestr_",住院"
			}
		}
		if (MKBSDClinicType["H")
		{
			if (typestr="")
			{
				s typestr="体检"
			}
			else
			{
				s typestr=typestr_",体检"
			}
		}
		if (MKBSDClinicType["N")
		{
			if (typestr="")
			{
				s typestr="新生儿"
			}
			else
			{
				s typestr=typestr_",新生儿"
			}
		}
	}	
	q typestr
}

/// Creator:钟荣枫
/// CreatDate:2021-6-22
/// Description:返回总频次
/// Table:
/// Input:  id
/// Return:freq
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetTotalFreq()
ClassMethod GetTotalFreq(MKBSDRowid)
{
	q:MKBSDRowid="" 0
	s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
	if (SumLoc="")
	{
		s SumLoc=0
		s MKBSDLRowid=0
		for
		{
			s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
			q:MKBSDLRowid=""
			s MKBRealLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2)
			s SumLoc=SumLoc+$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)
		}
	}
	q SumLoc
}

/// Creator:钟荣枫
/// CreatDate:2021-11-10
/// Description:通过代码、描述、科室进行筛选
/// Table:
/// Input:  id
/// Return:freq
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).GetFilterData()
ClassMethod GetFilterData(basedr, diag, icd, loc, rloc)
{
	k ^TempStructI
	s Diag=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(diag)
	s Loc=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(loc)
	s RLoc=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(rloc)
	s ICD=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(icd)
	k icdlist
	k diaglist
	k arr
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex",basedr," "_$ZCONVERT(Diag,"U"),MKBSDRowid))
		q:MKBSDRowid=""
		s diaglist(MKBSDRowid)=""
		
	}
	
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex",basedr," "_$ZCONVERT(ICD,"U"),MKBSDRowid))
		q:MKBSDRowid=""
		s icdlist(MKBSDRowid)=""
		
	}
	
	if ($D(diaglist)&&$D(icdlist)) //diag'="" icd'=""
	{
		s MKBICDRowid=0
		for
		{
			s MKBICDRowid=$O(diaglist(MKBICDRowid))
			q:MKBICDRowid=""
			continue:$D(icdlist(MKBICDRowid))=0
			s arr(MKBICDRowid)=""	
		}	
	}
	elseif ($D(diaglist)) //diag'="" icd=""
	{
		if (ICD'="")
		{
			s arr=""
		}
		else
		{
			merge arr=diaglist
		}
	}
	elseif ($D(icdlist)) //diag="" icd'=""
	{
		if (Diag'="")
		{
			s arr=""
		}
		else
		{
			merge arr=icdlist	
		}
	}
	else //diag="" icd=""
	{
		if ((diag="")&&(icd=""))		//描述和科室都为空
		{
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",basedr,MKBSDRowid))	
				q:MKBSDRowid=""
				s arr(MKBSDRowid)=""
			}
		}
		else
		{
			s arr=""	
		}
	}
	if ($d(arr))		//筛选过滤了icd和描述后，还需要筛选专业科室、科室
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(arr(MKBSDRowid))
			q:MKBSDRowid=""

			if (RLoc'="")		//实际科室
			{
				//User.MKBStructuredDataLoc		
				//Index LocIndex On (MKBSDLoc, MKBSDStructData);
				s rlocflag=0
				for ln=1:1:$l(RLoc,",")
				{
					q:rlocflag=1
					s MKBRLoc=$p(RLoc,",",ln)
					continue:MKBRLoc=""
					s RLocID=$o(^User.MKBStructuredDataLocI("LocIndex"," "_$zconvert(MKBRLoc,"U"),MKBSDRowid,""))
					
					s:RLocID'="" rlocflag=1
				}
				continue:rlocglag=0
					
			}
			if (Loc'="")		//专业科室
			{
				s locflag=0
				//User.MKBStructuredDataProLoc
				//Index ProLocIndex On (MKBSDProLoc, MKBSDStructData);
				s LocID=$o(^User.MKBStructuredDataProLocI("ProLocIndex"," "_$zconvert(Loc,"U"),MKBSDRowid,""))
					
				s:LocID'="" locflag=1
				continue:locflag=0
			}
			s ^TempStructI(MKBSDRowid)=""	
		}
	}
}

/// Creator:李得原
/// CreatDate:2019-04-18
/// Description:获取诊断数据
/// Table:
/// Input:  loc 专业科室，rloc 实际科室
/// Return:查询数据
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetNewList("13","","","","","","","","","4","","B","","","","100","331")
/// 
ClassMethod GetNewList(basedr As %String, icd As %String, diag As %String, types As %String, user As %String, loc As %String, status As %String, minfre As %String, maxfre As %String, sort As %String, mark As %String, match As %String, reason As %String, rloc As %String, centerword As %String, rows As %String, page As %String)
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s:diag'="" diag=$ZCONVERT(diag,"U") //转换成大写
	s:diag'="" diag=$zstrip(diag,"<>W")
	s:icd'="" icd=$ZCONVERT(icd,"U")    //转换成大写
	s:icd'="" icd=$zstrip(icd,"<>W")
	s:status'="" status=$ZCONVERT(status,"U")  //转换成大写
	s:centerword'="" centerword=$ZCONVERT(centerword,"U")
	
	s User=%session.Get("LOGON.USERID")
	//s User=1
	k ^TempPrintOut
	k Sort(User)
	k SortFre(User)
	s total=0
	s jsonstr=""
	s jsonresult=""
	w "{""rows"":["
	//s jsonresult="{""rows"":["
	if (basedr="")
	{
		w ""
	}
	else
	{
		d ..GetFilterData(basedr,icd,diag,loc,rloc)
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$O(^TempStructI(MKBSDRowid))	
			q:MKBSDRowid=""
			s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
			s StructID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",""))
			s MKBSDMatchGlobalFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),41)
			if match="B" /////结构化结构匹配（结构化结构匹配）
			{
				continue:StructID=""
				continue:'$d(^User.MKBStructuredDataD(MKBSDRowid))
			}
			elseif (match="C")	//ICD未匹配
			{
				continue:MKBSDIcd'=""
				continue:'$d(^User.MKBStructuredDataD(MKBSDRowid))
			}
			elseif (match="D")	//结构化未匹配，
			{
				continue:StructID'=""
				continue:'$d(^User.MKBStructuredDataD(MKBSDRowid))
			}
			elseif (match="E")	//ICD匹配
			{
				continue:MKBSDIcd=""
				continue:'$d(^User.MKBStructuredDataD(MKBSDRowid))
			}
			elseif (match="F")	//全局化词表已匹配
			{
				
				continue:MKBSDMatchGlobalFlag'="Y"
				continue:'$d(^User.MKBStructuredDataD(MKBSDRowid))
			}
			elseif (match="G")	//全局化词未匹配
			{
				continue:MKBSDMatchGlobalFlag="Y"
				continue:'$d(^User.MKBStructuredDataD(MKBSDRowid))
			}
			else		//A 全部
			{
				continue:'$d(^User.MKBStructuredDataD(MKBSDRowid))
			}
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
			s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8) //操作人
			s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
			s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
			s PINYINUpdateUser=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDUpdateUser)
			s userU=$zconvert(user,"U")
			if (user'="")&&(user'="空") //输入操作人不为空
			{
				if PINYINUpdateUser'="" //数据表中的操作人不为空
				{
					continue:(MKBSDUpdateUser'[user)&&(PINYINUpdateUser'[userU)
				}
				else
				{
					continue:MKBSDUpdateUser'[user
				}
			}
			elseif user="空" //输入操作人为空
			{
				continue:MKBSDUpdateUser'=""
			}
			//s SumLoc=..GetTotalFreq(MKBSDRowid)
			s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
			s:SumLoc="" SumLoc=0	
			s Status=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)  //处理状态
			s Type=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)		//数据来源
			s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)  //合并状态
			s Reason=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),17)  //上报理由
			s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
			s Base=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
			s MKBSDTCMDiagFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),24)		//中医诊断标识
			s MKBSDTCMSynFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),25)		//中医证型标识
			s MKBSDTumourFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),26)		//肿瘤形态学编码标
			s MKBSDInjuryFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),27)		//损伤中毒外部原因标志
			//types	
			continue:((types["1")&&(MKBSDTCMDiagFlag'="Y"))		//判断是否中医诊断
			continue:((types["2")&&(MKBSDTCMSynFlag'="Y"))		//判断是否中医证型
			continue:((types["3")&&(MKBSDTumourFlag'="Y"))		//判断是否肿瘤形态学
			continue:((types["4")&&(MKBSDInjuryFlag'="Y"))		//判断是否损伤中毒外部原因标志
			continue:((types["5")&&(MKBSDTCMDiagFlag="Y"))		//判断是否中医诊断
			s OrigICD=MKBSDIcd
			if ((MKBSDIcd="0000")||(MKBSDIcd["0000")||(MKBSDIcd["-")||(MKBSDIcd="""")||(MKBSDIcd=""))
			{
				s MKBSDIcd="ZZZZZ"
			}
			s PINYINDesc=""
			if diag'="" s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
			
			s TermDesc=""
			s centerflag=1
			s:(centerword'="") centerflag=0
			
			s sequence=0
			for
			{
				s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence))
				q:sequence=""
				s MKBSDRRowid=""
				for
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
					q:MKBSDRRowid=""
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",MKBSDResultTermdr," 别名",""))
					s TermDesc=$lg($g(^User.MKBTermD(MKBSDResultTermdr)),3)
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
								if (($zconvert(MKBTPDDesc,"U")[centerword)&&(centerword'=""))	//模糊查询
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
			
			if (((MKBSDDiag[diag)||(PINYINDesc[diag))&&(OrigICD[icd)&&(Status[status)&(Type[mark)&(MergeFlag="")&(Reason[reason)&(Base=basedr))
			{	
				s flagA=0		//是否输出
				d GetFreFlag
				if (flagA=1)
				{
					
						
						if sort=0                    //频次排序
						{
							s Sort(User,"pinci",SumLoc,MKBSDRowid)=""
						}
						elseif sort=1         //拼音排序
						{
							s Sort(User,"pinyin",MKBSDDiag,MKBSDRowid)=SumLoc
						}
						elseif (sort=2)			//rowid排序
						{
							s Sort(User,"rowid",MKBSDRowid,MKBSDRowid)=SumLoc	
						}
						elseif sort=3   		//ICD
						{
							s Sort(User,"icd",MKBSDIcd,MKBSDRowid)=SumLoc	
						}
						else 			//中心词排序
						{
							s Pinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TermDesc)
							s Sort(User,"termdesc",Pinyin,MKBSDRowid)=TermDesc
						}
				}
				
			}
		}
		s way=sort
		//s jsonresult=jsonresult_..PrintOut(.Sort,way,User,.total,stpage,endpage)
		d ..PrintOut(.Sort,way,User,.total,stpage,endpage)
		
		
	}
	//s jsonresult=jsonresult_"], ""total"":"_total_"}"
	w "], ""total"":"_total_"}"
	
	q ""
	//q jsonresult
GetFreFlag
	if (maxfre="")
	{
		if (SumLoc>=minfre)
		{
			s flagA=1
		}
	}
	else
	{
		if ((SumLoc>=minfre)&(SumLoc<maxfre))
		{
			s flagA=1
		}
	}
}

ClassMethod PrintOut(ByRef Sort, ByRef way As %String, User As %String, ByRef total, stpage As %String, endpage As %String)
{
	s result=""
	s jsonstr=0
	s sort=way
	s sortcode=""
	if sort=0
	{
		s sortcode="pinci"
	}
	elseif sort=1    //拼音排序
	{
		s sortcode="pinyin"
	}
	elseif (sort=2)
	{
		s sortcode="rowid"
	}
	elseif sort=3
	{
		s sortcode="icd"
	}
	else
	{
		s sortcode="termdesc"	
	}
	s UseCode=""
	for
	{
		if (sortcode="pinci")		//频次排序需要按照频次从高到低
		{	
			s UseCode=$o(Sort(User,sortcode,UseCode),-1)
		}
		else
		{
			s UseCode=$o(Sort(User,sortcode,UseCode))
		}
		q:UseCode=""
		s MKBSDRowid=""
		for
		{
			
			s MKBSDRowid=$o(Sort(User,sortcode,UseCode,MKBSDRowid))
			q:MKBSDRowid=""
			s ^TempPrintOut(sortcode,UseCode,MKBSDRowid)=""
			s total=total+1
			if (total<stpage) continue
			if (total<=endpage)
			{
				
				
				s Result=""
				s sequence=0
				for
				{
					s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence))
					q:sequence=""
					
					s MKBSDRRowid=0
					for
					{
						s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
						q:MKBSDRRowid=""
						s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
						s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
						continue:MKBSDResultTermdr=""
						s SResult=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
						s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
						if MKBSDSupplement'=""
						{
							if SResult["]"
							{
								s str=$e(SResult,1,*-1)
								s SResult=str_",("_MKBSDSupplement_")]"
							}
							else
							{
								s SResult=SResult_"[("_MKBSDSupplement_")]"
							}
						}					
						s:Result'="" Result=Result_"<br/>"_SResult
						s:Result="" Result=SResult
					}
				}
				s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
				s MKBSDDiag=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBSDDiag)
				s MKBSDLocs=""
				s MKBSDLocStr=""
				s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)  //科室串
				if MKBSDLocs'=""
				{
					s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
					s loclen=$l(MKBSDLocs,",")
					for i=1:1:loclen
					{
						s Proid=$p(MKBSDLocs,",",i)
						continue:Proid=""
						s ProLocDesc=$lg($g(^User.MKBTermD(Proid)),3)
						s:MKBSDLocStr'="" MKBSDLocStr=MKBSDLocStr_","_ProLocDesc
						s:MKBSDLocStr="" MKBSDLocStr=ProLocDesc
					}
				}
				s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
				s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),12)    //别名字段
				s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
				s MKBSDICD=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBSDICD)
				s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值
				s MKBSDMrc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBSDMrc)

				s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
				s MKBSDCenterWord=""                         ;通过中心词id获取描述
				if MKBSDCenterWordID'=""
				{
					s WordCount=$l(MKBSDCenterWordID,",")
					for i=1:1:WordCount
					{
						s WordEach=$p(MKBSDCenterWordID,",",i)
						s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
						s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_"、"_MKBSDWord
						s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
					}	
				}
				s MKBSDDates=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),7)
				s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
				s:MKBSDDates="" MKBSDDate=""
				s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8)
				s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
				s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
				s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
				s Type=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
				s SumLoc=..GetTotalFreq(MKBSDRowid)
				//s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
				s MKBSDNote=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),16)    //备注  存上报理由
				s AliasStr=""
				if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
				{
					s MKBSDORowid=0
					for
					{
						s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
						q:MKBSDORowid=""
						s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
						s:AliasStr'="" AliasStr=AliasStr_"、"_MKBSDOAlias
						s:AliasStr="" AliasStr=MKBSDOAlias
					}
				}
				s OtherStr=""
				if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
				{
					s MKBSDORowid=0
					for
					{
						s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
						q:MKBSDORowid=""
						s MKBSDOOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
						s:OtherStr'="" OtherStr=OtherStr_"、"_MKBSDOOther
						s:OtherStr="" OtherStr=MKBSDOOther
					}
				}
				s Reasons=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),17)  //上报理由
				s Reasons=##class(web.DHCBL.BDP.FunLib).EvalJSONB(Reasons)
				s Reason=""
				if Reasons'=""
				{
					s ReasonsLen=$l(Reasons,",")
					for i=1:1:ReasonsLen
					{
						s OneReason=$p(Reasons,",",i)
						s ReasonStr=$select(OneReason="A":"缺诊断短语",OneReason="B":"诊断短语不正确",OneReason="C":"缺诊断表达式",OneReason="D":"诊断表达式不正确",OneReason="E":"缺ICD",OneReason="F":"ICD不正确")
						s:Reason'="" Reason=Reason_","_ReasonStr
						s:Reason="" Reason=ReasonStr
					}
				}
				s MKBSDInitialICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),18)
				s MKBSDDiagPYCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
				s MKBSDDiagPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBSDDiagPYCode)
				s MKBSDResultRelation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),23)
				s MKBSDTCMDiagFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),24)
				s MKBSDTCMSynFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),25)
				s MKBSDTumourFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),26)
				s MKBSDInjuryFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),27)
				s MKBSDDateActiveFrom=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),28)
				s:MKBSDDateActiveFrom'="" MKBSDDateActiveFrom=$zd(MKBSDDateActiveFrom,3)
				s MKBSDDateActiveTo=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),29)
				s:MKBSDDateActiveTo'="" MKBSDDateActiveTo=$zd(MKBSDDateActiveTo,3)
				
				s MKBSDHisRowID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),30)	//his诊断ID
				s MKBSDHisCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),31)		//HIS诊断代码
				s MKBSDDeputyCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),32)	//icd10副编码
				//s MKBSDClinicType=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),33)	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
				s MKBSDClinicType=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),33)
				s MKBSDClinicType=..GetClinicType(MKBSDClinicType)
				
				s MKBSDClassification=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),34)		//icd诊断分类
				s:MKBSDClassification'="" MKBSDClassification=$p($g(^MRC("ICDTYPE",MKBSDClassification)),"^",2)
				
				s MKBSDLimitSex=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),35)		//限制性别
				s:MKBSDLimitSex'="" MKBSDLimitSex=$p($g(^CT("SEX",MKBSDLimitSex)),"^",2)
				
				s MKBSDHisRemark=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),36)		//注释
				s MKBSDAgeFrom=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),37)		// 从年龄
				s MKBSDAgeTo=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),38)		//到年龄
				s MKBSDICD9Code=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),39)		//icd9代码
				s MKBSDNationalDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),40)		// 国家标准名称
				s MKBSDMatchGlobalFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),41)
				
				
					d OutPut
				
				
			}
		}
		
	}
	q ""
		

OutPut  
    s thisStr=""
    ;             Rowid,                        MKBSDDiag,                    ,MKBSDStatus,                       MKBSDCenterWordID ,                               MKBSDCenterWord,                                MKBSDDate,                  MKBSDUpdateUser,                        MKBSDStatusF,MKBSDSegmentation,sumloc	
	s thisStr="{""Rowid"":"""_MKBSDRowid_""",""MKBSDDiag"":"""_MKBSDDiag_""",""MKBSDStatus"":"""_MKBSDStatus_""",""MKBSDCenterWordID"":"""_MKBSDCenterWordID_""",""MKBSDCenterWord"":"""_MKBSDCenterWord_""",""MKBSDDate"":"""_MKBSDDate_""",""MKBSDUpdateUser"":"""_MKBSDUpdateUser_""",""MKBSDSegmentation"":"""_MKBSDSegmentation_""",""sumloc"":"""_SumLoc_""",""MKBSDMrc"":"""_MKBSDMrc_""",""MKBSDMDr"":"""_MKBSDMDr_""",""MKBSDICD"":"""_MKBSDICD_""",""Result"":"""_Result_""",""MKBSDOAlias"":"""_AliasStr_""",""MKBSDOOther"":"""_OtherStr_""",""MKBSDDiaSource"":"""_Type_""",""MKBSDLocStr"":"""_MKBSDLocStr_""",""MKBSDLocs"":"""_MKBSDLocs_""",""MKBSDAlias"":"""_MKBSDAlias_""",""MKBSDNote"":"""_MKBSDNote_""",""Reason"":"""_Reason_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_""",""MKBSDDiagPYCode"":"""_MKBSDDiagPYCode_""",""MKBSDResultRelation"":"""_MKBSDResultRelation_""",""MKBSDTCMDiagFlag"":"""_MKBSDTCMDiagFlag_""",""MKBSDTCMSynFlag"":"""_MKBSDTCMSynFlag_""",""MKBSDTumourFlag"":"""_MKBSDTumourFlag_""",""MKBSDInjuryFlag"":"""_MKBSDInjuryFlag_""",""MKBSDDateActiveFrom"":"""_MKBSDDateActiveFrom_""",""MKBSDDateActiveTo"":"""_MKBSDDateActiveTo
	;						MKBSDHisRowID							MKBSDHisCode						MKBSDDeputyCode								MKBSDClinicType								MKBSDClassification									MKBSDLimitSex								MKBSDHisRemark							MKBSDAgeFrom							MKBSDAgeTo						MKBSDICD9Code							MKBSDNationalDesc
	s thisStr=thisStr_""",""MKBSDHisRowID"":"""_MKBSDHisRowID_""",""MKBSDHisCode"":"""_MKBSDHisCode_""",""MKBSDDeputyCode"":"""_MKBSDDeputyCode_""",""MKBSDClinicType"":"""_MKBSDClinicType_""",""MKBSDClassification"":"""_MKBSDClassification_""",""MKBSDLimitSex"":"""_MKBSDLimitSex_""",""MKBSDHisRemark"":"""_MKBSDHisRemark_""",""MKBSDAgeFrom"":"""_MKBSDAgeFrom_""",""MKBSDAgeTo"":"""_MKBSDAgeTo_""",""MKBSDICD9Code"":"""_MKBSDICD9Code_""",""MKBSDNationalDesc"":"""_MKBSDNationalDesc_""",""MKBSDMatchGlobalFlag"":"""_MKBSDMatchGlobalFlag_"""}" 		
					
	if (jsonstr=1)
	{ 
		w ","
		s jsonstr=1
	}
	else
	{
		s jsonstr=1
	}
	w thisStr
}

/// Creator:李得原
/// CreatDate:2019-03-30
/// Description:获取诊断数据	弃用
/// Table:
/// Input:
/// Return:查询数据
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetNewList("","","P","1","2","1","","2","1")
ClassMethod GetNewOldList(diag As %String, loc As %String, status As %String, minfre As %String, maxfre As %String, sort As %String, mark As %String, match As %String, rows As %String, page As %String)
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s:diag'="" diag = ##class(web.DHCBL.BDP.FunLib).EvalJSON(diag)
	s:loc'="" icd=$ZCONVERT(loc,"U")    //转换成大写
	s:status'="" status=$ZCONVERT(status,"U")  //转换成大写
	s:diag'="" diag=$zconvert(diag,"U")
	
	s User=%session.Get("LOGON.USERID")
	k ^TempSortByFre(User)
	s total=0
	s jsonstr=""
	w "{""rows"":["
	if ((diag'="")||(loc'="")||(status'="")||(minfre'="")||(maxfre'="")||(sort'=""))
	{
		s flag=1
		k DiagList
		s NumOfDiag=$l(diag," ")
		for i=1:1:NumOfDiag
		{
			s SplitStr=$p(diag," ",i)
			s SplitStr=$zconvert(SplitStr,"U")
			s DiagList(i)=SplitStr
		}
		if sort=1          //按拼音排序
		{
			s MKBSDDesc=""
			for
			{
				s MKBSDDesc=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDDesc))
				q:MKBSDDesc=""
				s MKBSDDate=""
				s MKBSDUpdateUser=""
				s flagC=0            //全匹配为3    ICD未匹配为2    结构化未匹配为1
				s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDDesc,0))
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",0))
				if MKBSDRRowid'=""
				{
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					s Result=..GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s flagC=flagC-1
				}
				else
				{
					s Result=""
					s flagC=flagC+1
				}
				s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
				s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
				if MKBSDMDr'=""
				{
					s MKBSDMrc=$p(^MRC("ID",MKBSDMDr),"^",2)                    //MRC中文描述
					s MKBSDICD=$p(^MRC("ID",MKBSDMDr),"^",4)                   //ICD
					s flagC=flagC-10
				}
				else
				{
					s MKBSDMrc=""
					s MKBSDICD=""
					s flagC=flagC+10
				}
				s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
				s MKBSDCenterWord=""                         ;通过中心词id获取描述
				if MKBSDCenterWordID'=""
				{
					s WordCount=$l(MKBSDCenterWordID,",")
					for i=1:1:WordCount
					{
						s WordEach=$p(MKBSDCenterWordID,",",i)
						s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
						s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_","_MKBSDWord
						s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
					}	
				}
				s MKBSDDates=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),7)
				s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
				s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8)
				s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
				s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
				s Type=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
				
				s SumLoc=0
				s flagA=0
				s flagB=0
				
				if NumOfDiag=1
				{
					s PINYINDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
					if (((MKBSDDesc[diag)||(PINYINDiag[diag))&(MKBSDStatus[status)&(Type[mark)&(flagC[match))
					{
						s LocRowid=0
						for
						{
							s LocRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid))
							q:LocRowid=""
							s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),2)
							if (Loc[loc)
							{
								s SumLoc=SumLoc+$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),3)
								s flagB=1
							}
						}
						;s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
						if (maxfre="")
						{
							if (SumLoc>=minfre)
							{
								s flagA=1
							}
						}
						else
						{
							if ((SumLoc>=minfre)&(SumLoc<maxfre))
							{
								s flagA=1
							}
						}
						if (flagA=1)&(flagB=1)
						{
							s total=total+1
							if (total<stpage) continue
							d OutPut
						}
					}
				}
				else
				{
					for i=1:1:NumOfDiag
					{
						if (((MKBSDDiag[DiagList(i)) && (DiagList(i)'=""))&(MKBSDStatus[status)&(Type[mark)&(flagC[match))
						{
							s LocRowid=0
							for
							{
								s LocRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid))
								q:LocRowid=""
								s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),2)
								if (Loc[loc)
								{
									s SumLoc=SumLoc+$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),3)
									s flagB=1
								}
							}
							;s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
							if (maxfre="")
							{
								if (SumLoc>=minfre)
								{
									s flagA=1
								}
							}
							else
							{
								if ((SumLoc>=minfre)&(SumLoc<maxfre))
								{
									s flagA=1
								}
							}
							if (flagA=1)&(flagB=1)
							{
								s total=total+1
								if (total<stpage) continue
								d OutPut
							}
						}
					}
				}
			}
		}
		else	//按频次排序
		{
			s MKBSDDesc=""
			for
			{
				s MKBSDDesc=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDDesc))
				q:MKBSDDesc=""
				s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDDesc,0))
				
				s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
				s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
				s Type=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
				s SumLoc=0
				s flagA=0
				s flagB=0
				s flagC=0
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
				if MKBSDMDr=""
				{
					s flagC=flagC+10
				}
				else
				{
					s flagC=flagC-10
				}
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",0))
				if MKBSDRRowid=""
				{
					s flagC=flagC+1
				}
				else
				{
					s flagC=flagC-1
				}
				if NumOfDiag=1     //频次排序&一个关键字
				{
					s PINYINDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
					if (((MKBSDDesc[diag)||(PINYINDiag[diag))&(MKBSDStatus[status)&(Type[mark)&(flagC[match))
					{
						s LocRowid=0
						for
						{
							s LocRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid))
							q:LocRowid=""
							s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),2)
							if (Loc[loc)
							{
								s SumLoc=SumLoc+$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),3)
								s flagB=1
							}
						}
						;s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
						if (maxfre="")
						{
							if (SumLoc>=minfre)
							{
								s flagA=1
							}
						}
						else
						{
							if ((SumLoc>=minfre)&(SumLoc<maxfre))
							{
								s flagA=1
							}
						}
						if (flagA=1)&(flagB=1)
						{
							s ^TempSortByFre(User,SumLoc,MKBSDRowid)=""
						}
								
					}
				}
				else   //频次排序&多关键字
				{
					for i=1:1:NumOfDiag
					{
						if (((MKBSDDiag[DiagList(i)) && (DiagList(i)'=""))&(MKBSDStatus[status)&(Type[mark)&(flagC[match))
						{
							s LocRowid=0
							for
							{
								s LocRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid))
								q:LocRowid=""
								s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),2)
								if (Loc[loc)
								{
									s SumLoc=SumLoc+$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),3)
									s flagB=1
								}
							}
							;s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
							if (maxfre="")
							{
								if (SumLoc>=minfre)
								{
									s flagA=1
								}
							}
							else
							{
								if ((SumLoc>=minfre)&(SumLoc<maxfre))
								{
									s flagA=1
								}
							}
							if (flagA=1)&(flagB=1)
							{
								s ^TempSortByFre(User,SumLoc,MKBSDRowid)=""
							}
							
						}
					}
				}
			}
			s Fre=""
			for
			{
				s Fre=$o(^TempSortByFre(User,Fre),-1)
				q:Fre=""
				s MKBSDRowid=0
				for
				{
					s MKBSDRowid=$o(^TempSortByFre(User,Fre,MKBSDRowid))
					q:MKBSDRowid=""
					s MKBSDDate=""
					s MKBSDUpdateUser=""
					s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",0))
					if MKBSDRRowid'=""
					{
						s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
						s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
						s Result=..GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					}
					else
					{
						s Result=""
					}
					s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
					s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
					s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
					s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
					if MKBSDMDr'=""
					{
						s MKBSDMrc=$p(^MRC("ID",MKBSDMDr),"^",2)                    //MRC中文描述
						s MKBSDICD=$p(^MRC("ID",MKBSDMDr),"^",4)                   //ICD
					}
					else
					{
						s MKBSDMrc=""
						s MKBSDICD=""
					}
					s MKBSDCenterWord=""                         ;通过中心词id获取描述
					if MKBSDCenterWordID'=""
					{
						s WordCount=$l(MKBSDCenterWordID,",")
						for i=1:1:WordCount
						{
							s WordEach=$p(MKBSDCenterWordID,",",i)
							s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
							s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_","_MKBSDWord
							s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
						}	
					}
					s MKBSDDates=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),7)
					s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
					s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8)
					s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
					s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
					s SumLoc=Fre
					s total=total+1
					if (total<stpage) continue
					d OutPut
				}
			}
		}
	}
	w "], ""total"":"_total_"}"
	q ""
OutPut
	if (total<=endpage)
    {
	    s thisStr=""
	    ;             Rowid,                        MKBSDDiag,                    ,MKBSDStatus,                       MKBSDCenterWordID ,                               MKBSDCenterWord,                                MKBSDDate,                  MKBSDUpdateUser,                        MKBSDStatusF,MKBSDSegmentation,sumloc	
		s thisStr="{""Rowid"":"""_MKBSDRowid_""",""MKBSDDiag"":"""_MKBSDDiag_""",""MKBSDStatus"":"""_MKBSDStatus_""",""MKBSDCenterWordID"":"""_MKBSDCenterWordID_""",""MKBSDCenterWord"":"""_MKBSDCenterWord_""",""MKBSDDate"":"""_MKBSDDate_""",""MKBSDUpdateUser"":"""_MKBSDUpdateUser_""",""MKBSDSegmentation"":"""_MKBSDSegmentation_""",""sumloc"":"""_SumLoc_""",""MKBSDMrc"":"""_MKBSDMrc_""",""MKBSDMDr"":"""_MKBSDMDr_""",""MKBSDICD"":"""_MKBSDICD_""",""Result"":"""_Result_"""}" 	
						

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

/// Creator:石萧伟
/// CreatDate:2018-12-20
/// Description:判断同名诊断
/// Table:
/// Input:
/// Return:有则拼串，没有返回“”
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).justHasExist(119,26484)
ClassMethod justHasExist(parentid, termid)
{
	
	s existStr = ""
	if $d(^User.MKBStructuredDataD(parentid,"MKBSDStructResult"))
	{
		s rowid=0
		
		for
		{
			s rowid=$o(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid))
			q:rowid=""
			s MKBSDTermDR=$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),4)
			s MKBSDStructResult=$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),3)
			if (termid = MKBSDTermDR)
			{
				s existStr = parentid_"||"_rowid _"^"_MKBSDStructResult
				q
			}
			
		}
		
	}
	//else
	//{
	q existStr	
	//}
}

/// Creator:李得原
/// CreatDate:2018-11-26
/// Description:获取诊断数据		
/// Table:
/// Input:
/// Return:查询数据
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetList","","","","","","")	
Query GetList(diag As %String, loc As %String, status As %String, minfre As %String, maxfre As %String, sort As %String) As %Query(ROWSPEC = "Rowid,MKBSDDiag,MKBSDLoc,MKBSDFrequency,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDDate,MKBSDUpdateUser,MKBSDStatusF,MKBSDSegmentation,sumloc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, diag As %String, loc As %String, status As %String, minfre As %String, maxfre As %String, sort As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	s diag = ##class(web.DHCBL.BDP.FunLib).EvalJSON(diag)

	s:diag'="" diag=$ZCONVERT(diag,"U") //转换成大写
	s:loc'="" loc=$ZCONVERT(loc,"U") //转换成大写
	s:status'="" status=$ZCONVERT(status,"U")
	
	if ((diag'="")||(loc'="")||(status'="")||(minfre'="")||(maxfre'="")||(sort'=""))
	{
		k ^TMP("Sort")
		s NumOfDiag=$l(diag," ")
		for i=1:1:NumOfDiag
		{
			s DiagList(i)=$p(diag," ",i)
		}
		s SortRowid=0
		for
		{
			s SortRowid=$o(^User.MKBStructuredDataD(SortRowid))
			q:SortRowid=""
			s PINYINDiag=""
			s PINYINLoc=""	
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(SortRowid)),2)
			s MKBSDDiag=$ZCONVERT(MKBSDDiag,"U")
			s MKBSDLoc=$lg($g(^User.MKBStructuredDataD(SortRowid)),3)
			s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(SortRowid)),5)
			s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(SortRowid)),6)
			s MKBSDCenterWord=""                         ;通过中心词id获取描述
			if MKBSDCenterWordID'=""
			{
				s WordCount=$l(MKBSDCenterWordID,",")
				for i=1:1:WordCount
				{
					s WordEach=$p(MKBSDCenterWordID,",",i)
					s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
					s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_","_MKBSDWord
					s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
				}	
			}
			s MKBSDFrequency=$lg($g(^User.MKBStructuredDataD(SortRowid)),4)
			s MKBSDDates=$lg($g(^User.MKBStructuredDataD(SortRowid)),7)
			s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
			s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(SortRowid)),8)
			s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
			
			s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(SortRowid)),9)
			s MKBSDStatusF = ""
			s PINYINDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
			s PINYINLoc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDLoc)
			if NumOfDiag=1
			{
				if ((MKBSDDiag[diag)||(PINYINDiag[diag))&((MKBSDLoc[loc)||(PINYINLoc[loc))&(MKBSDStatus[status)
				{
					if sort=1
					{
						s PinFlag=1
						d ..SortLoc(SortRowid, MKBSDLoc, MKBSDFrequency, loc,PinFlag,PINYINDiag)
					}
					else
					{
						s PinFlag=0
						d ..SortLoc(SortRowid, MKBSDLoc, MKBSDFrequency, loc,PinFlag,PINYINDiag)
					}
					
				}
			}
			else
			{
				s flag=0
				for i=1:1:NumOfDiag
				{
					if ((MKBSDDiag[DiagList(i)) && (DiagList(i)'=""))
					{

						if ((MKBSDLoc[loc)||(PINYINLoc[loc))&(MKBSDStatus[status)
						{
							if sort=1
							{
								s PinFlag=1
								d ..SortLoc(SortRowid, MKBSDLoc, MKBSDFrequency, loc,PinFlag,PINYINDiag)
							}
							else
							{
								s PinFlag=0
								d ..SortLoc(SortRowid, MKBSDLoc, MKBSDFrequency, loc,PinFlag,PINYINDiag)
							}
						}
					}
				}
			}
		}
		s SumFrequence=""
		for
		{
			s SumFrequence=$o(^TMP("Sort",SumFrequence),-1)
			q:SumFrequence=""
			s Rowid=0
			for
			{
				s Rowid=$o(^TMP("Sort",SumFrequence,Rowid))
				q:Rowid=""
				s MKBSDDate=""
				s MKBSDUpdateUser=""
				s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
				s MKBSDLoc=$lg($g(^User.MKBStructuredDataD(Rowid)),3)
				s MKBSDFrequency=$lg($g(^User.MKBStructuredDataD(Rowid)),4)
				s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(Rowid)),5)
				s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(Rowid)),6)
				s MKBSDCenterWord=""                         ;通过中心词id获取描述
				if MKBSDCenterWordID'=""
				{
					s WordCount=$l(MKBSDCenterWordID,",")
					for i=1:1:WordCount
					{
						s WordEach=$p(MKBSDCenterWordID,",",i)
						s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
						s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_","_MKBSDWord
						s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
					}	
				}
				s MKBSDDates=$lg($g(^User.MKBStructuredDataD(Rowid)),7)
				s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
				s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(Rowid)),8)
				s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
				s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(Rowid)),9)
				s MKBSDStatusF = ""
				s sumloc=""
				s NumFlag=$e(SumFrequence,2)
				if (($a(NumFlag))<=57)
				{
					s sumloc=SumFrequence
					if maxfre=""
					{
						if sumloc>=minfre
						{
							d getCTTitle
						}
					}
					else 
					{
						if ((sumloc>=minfre)&(sumloc<=maxfre))
						{
							d getCTTitle
						}
					}
				}
				else
				{
					s sumloc=$o(^TMP("Sort",SumFrequence,Rowid,""))
					if maxfre=""
					{
						if sumloc>=minfre
						{
							d getCTTitle
						}
					}
					else 
					{
						if ((sumloc>=minfre)&(sumloc<=maxfre))
						{
							d getCTTitle
						}
					}
				}
			}
		}
	}
	else
	{
		s Rowid=0
		for
		{
			s Rowid=$o(^User.MKBStructuredDataD(Rowid))
			q:Rowid=""
			
			s MKBSDDate=""
			s MKBSDUpdateUser=""
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
			s MKBSDLoc=$lg($g(^User.MKBStructuredDataD(Rowid)),3)
			s MKBSDFrequency=$lg($g(^User.MKBStructuredDataD(Rowid)),4)
			s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(Rowid)),5)
			s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(Rowid)),6)
			s MKBSDCenterWord=""                         ;通过中心词id获取描述
			if MKBSDCenterWordID'=""
			{
				s WordCount=$l(MKBSDCenterWordID,",")
				for i=1:1:WordCount
				{
					s WordEach=$p(MKBSDCenterWordID,",",i)
					s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
					s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_","_MKBSDWord
					s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
				}	
			}
			s MKBSDDates=$lg($g(^User.MKBStructuredDataD(Rowid)),7)
			s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
			s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(Rowid)),8)
			s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
			s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(Rowid)),9)
			s MKBSDStatusF = ""
			/*s MKBSDStructResultP=""
			if $d(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult"))
			{
				s rowid=0
				for
				{
					s rowid=$o(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid))
					q:rowid=""
					s MKBSDStructResult=$lg(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid),3)
					s:MKBSDStructResultP'="" MKBSDStructResultP=MKBSDStructResultP_"#"_MKBSDStructResult
					s:MKBSDStructResultP="" MKBSDStructResultP=MKBSDStructResult
				}
			}*/
			s sumloc=""
			d getCTTitle
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(Rowid,MKBSDDiag,MKBSDLoc,MKBSDFrequency,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDDate,MKBSDUpdateUser,MKBSDStatusF,MKBSDSegmentation,sumloc)
 	Set ^CacheTemp(repid,ind)=Data
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

/// Creator:李得原
/// CreatDate:2018-11-27
/// Description:更新数据
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).Update()
ClassMethod Update(rowid As %String, MKBSDStatus As %String, MKBSDStructResultID As %String, MKBSDStructResult As %String, MKBSDTermDR) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)        ;先备份再更新
		s bobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s bobj.MKBSDDiag=obj.MKBSDDiag
		s bobj.MKBSDLoc=obj.MKBSDLoc
		s bobj.MKBSDCenterWordID=obj.MKBSDCenterWordID
		s bobj.MKBSDFrequency=obj.MKBSDFrequency
		s bobj.MKBSDDate=obj.MKBSDDate
		s bobj.MKBSDStatus=obj.MKBSDStatus
		s bobj.MKBSDUpdateUser=obj.MKBSDUpdateUser
		s bobj.MKBSDDiaSource = obj.MKBSDDiaSource
		d bobj.%Close()
	
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		
		s obj.MKBSDDate=UpdateDate
		s obj.MKBSDStatus=MKBSDStatus
		d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
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
			set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			
		}
		d obj.%Close()
		quit result			
	}
}

/// Creator:石萧伟
/// CreatDate:2018-11-27
/// Description:可编辑表格更新数据
/// Table: 
/// Input:	id，MKBSDStatus 状态，MKBSDICD ICD代码,MKBSDICDDesc icd描述 ，MKBSDChildStructFlag  是否结构化标志，MKBSDMergeFlag 是否合并，MKBSDLoc  科室
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).EditUpdate("4385","N","","","","17213")
/// WARG_3: 84866 WARG_4: WARG_5: 1  WARG_6:  WARG_7: WARG_8: 17227
ClassMethod EditUpdate(rowid As %String, MKBSDStatus As %String, MKBSDICD As %String, MKBSDICDDesc As %String, MKBSDChildStructFlag As %String, MKBSDMergeFlag As %String, MKBSDLoc As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)        ;先备份再更新
		s bobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s eobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		if (rowid'="")
		{
			s bobj.MKBSDRowid=rowid
			s eobj.MKBSDRowid=rowid
		}
		
		if (MKBSDLoc'="")	//科室
		{
			s bobj.MKBSDLoc=obj.MKBSDLoc
			s eobj.MKBSDLoc=MKBSDLoc
			s obj.MKBSDLoc=MKBSDLoc
		}
		if (MKBSDICD'="")	//icd
		{
			s bobj.MKBSDICD=obj.MKBSDICD
			s eobj.MKBSDICD=MKBSDICD
			s obj.MKBSDICD=MKBSDICD
		}
		if (MKBSDICDDesc'="")	//icd描述
		{
			s bobj.MKBSDICDDesc=obj.MKBSDICDDesc
			s eobj.MKBSDICDDesc=MKBSDICDDesc
			s obj.MKBSDICDDesc=MKBSDICDDesc
		}
		if (MKBSDStatus'="")	//状态
		{
			s bobj.MKBSDStatus=obj.MKBSDStatus
			s eobj.MKBSDStatus=MKBSDStatus
			s obj.MKBSDStatus=MKBSDStatus
		}
		if (MKBSDChildStructFlag'="")	//结构化标志
		{
			s bobj.MKBSDChildStructFlag=obj.MKBSDChildStructFlag
			s eobj.MKBSDChildStructFlag=MKBSDChildStructFlag
			s obj.MKBSDChildStructFlag=MKBSDChildStructFlag
		}
		if (MKBSDMergeFlag'="")		//合并标志
		{
			s bobj.MKBSDMergeFlag=obj.MKBSDMergeFlag
			s eobj.MKBSDMergeFlag=MKBSDMergeFlag
			s obj.MKBSDMergeFlag=MKBSDMergeFlag
			if (MKBSDMergeFlag = "C"){
				s obj.MKBSDInitialICD = "N"
			}
		}
		

		s Diag=obj.MKBSDDiag
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
    	;Set UpdateUserDR=1
		d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBSDDate=UpdateDate
		
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
			if (MKBSDMergeFlag '= "") //删除子表的数据
			{
				s ChildSub=0
				for
				{
					s ChildSub=$O(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",ChildSub))	
					q:ChildSub=""
					s id=rowid_"||"_ChildSub
					s delResult=##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDR",id)
				}				
			}
			s basedr = $lg($g(^User.MKBStructuredDataD(rowid)),22)
			s Base=$lg($g(^User.MKBStructuredBaseD(basedr)),2)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData",Base_"-诊断短语",id,Diag,"U",eobj,bobj)
			if (eobj.MKBSDICD'=bobj.MKBSDICD)		//修改icd后，修改索引
			{
				d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(basedr,bobj.MKBSDICD,id)
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(basedr,eobj.MKBSDICD,id)
			}
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		d bobj.%Close()
		d eobj.%Close()
		d obj.%Close()
		quit result			
	}
}

/// Creator:李欣
/// CreatDate:2018-11-25
/// Description:根据诊断模板获取诊断id
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetTermIdByProId("26473")
ClassMethod GetTermIdByProId(ProId)
{
	s MKBTRowId = $LG($G(^User.MKBTermPropertyD(ProId)),6)	
	q MKBTRowId
}

/// Creator:石萧伟
/// CreatDate:2018-11-28
/// Description：根据属性id获取诊断模板中的展示格式
/// Table：User.SDSStructDiagnos
/// Input：属性id
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetShowType("4989")
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
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetData("4385","4385||4544")
ClassMethod GetData(parentid, rowid) As %String
{
	q:parentid="" ""
	q:rowid="" ""
	s result=""
	s parentid = $p($g(rowid),"||",1)
	s rowid = $p($g(rowid),"||",2)
	s SDSTermDR=$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),4) //诊断id
	s PropertyDR=..GetPropertyIdByFlag(SDSTermDR,"DT")
	d ..GetShowType(PropertyDR)
	
	s SDSValue=$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),2)   
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

/// Creator:石萧伟
/// CreatDate:2018-11-28
/// Description：获取结构化诊断的信息
/// Table：User.MKBStructuredData
/// Input：rowid 结构化诊断id
/// Return：术语属性内容值串^诊断展示名^诊断备注
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetData("1","1||3")
ClassMethod GetPPData(parentid, rowid) As %String
{
	q:parentid="" ""
	q:rowid="" ""
	s result=""
	s rowid = $p($g(rowid),"||",2)
	s SDSPropertyDR=$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),4)
	q:SDSPropertyDR="" ""
	d ..GetShowType(SDSPropertyDR)
	
	s MKBTRowId=$LISTGET($G(^User.MKBTermPropertyD(SDSPropertyDR)),6) //诊断id
	s SDSValue=$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),2)   
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	s GridCheckedIdStr = ""
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
				if ($g(^TMPMKBSHOWTYPE(key))="G"){
					if (GridCheckedIdStr=""){
						s GridCheckedIdStr=value
					}else{
						s GridCheckedIdStr=GridCheckedIdStr_"&"_value
					}					
				}
			}
		}
	}
	s SDSDisplayName=$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),3)  //MKBSDStructResult
	s SDSNotes=$LISTGET($G(^User.SDSStructDiagnosD(rowid)),5)
	
	//s DiagnosDisPlayName=..GetDiagFormateDesc(DiagnosPRowID) //$p($g(^MR("DIAGP",DiagnosPRowID)),"^",10)
	
	s result=MKBTRowId_"^"_TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_SDSDisplayName_"^"_SDSNotes_"^"_GridCheckedIdStr
	q result
}

/// Creator:李得原
/// CreatDate:2018-12-10
/// Description：结构化结果子表的新增
/// Table：User.MKBStructuredDataResult
/// Input：id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).SaveData(1852751,"1852751||20191870","68027:S16414*S16425","",14626,"")
ClassMethod SaveData(Pid As %String, Cid As %String, StructResultID As %String, StructResult As %String, PropertyDR As %String, Supplement As %String)
{
	s Result=PropertyDR
	s:StructResultID'="" Result=PropertyDR_"-"_StructResultID
	s:Result'="" Result=..StandardizedStructStr(Result)	//保存的时候标准化结构化串
	if (Result'="")
	{
		s PropertyDR=$p(Result,"-",1)
		s StructResultID=$p(Result,"-",2)
		s StructResult=..StdGetChiForNewSeqStrucIDs(StructResultID,PropertyDR)
	}
	if Cid=""      ;如果为空 则新增子表数据
	{
		s obj=##class(User.MKBStructuredDataResult).%New(Pid)
		s sort=0
		if ($d(^User.MKBStructuredDataResultI("SeqIndex")))
		{
			s sort=$o(^User.MKBStructuredDataResultI("SeqIndex",Pid,""),-1) 
		}
		s obj.MKBSDSequence=sort+1	
	}
	else      ;如果不为空 则修改子表数据
	{
		s obj=##class(User.MKBStructuredDataResult).%OpenId(Cid) 
		s bobj=##class(web.Entity.MKB.MKBStructuredDataResult).%New()    //先备份
		s:Pid'="" bobj.MKBSDRowid=Pid
		s:Cid'="" bobj.MKBSDRRowid=Cid
		s:StructResultID'="" bobj.MKBSDStructResultID=StructResultID
		s:StructResult'="" bobj.MKBSDStructResult=StructResult
		s:PropertyDR'="" bobj.MKBSDTermDR=PropertyDR
		if Supplement'="" 
		{
			s EvalSupple=##class(web.DHCBL.BDP.FunLib).EvalJSON(Supplement)
			s bobj.MKBSDSupplement=EvalSupple
		}
	}
	s pobj=##class(User.MKBStructuredData).%OpenId(Pid)
	s pobj.MKBSDChildStructFlag=1 //结构化以后将父表的标志变成1
	Set UpdateDate=$p($h,",",1)       //上传日期
	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
	d pobj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
	s pobj.MKBSDDate=UpdateDate

	
	s eobj=##class(web.Entity.MKB.MKBStructuredDataResult).%New()
	s:Pid'="" eobj.MKBSDRowid=Pid
	s:Cid'="" eobj.MKBSDRRowid=Cid
	s:StructResultID'="" eobj.MKBSDStructResultID=StructResultID
	s:StructResult'="" eobj.MKBSDStructResult=StructResult
	s:PropertyDR'="" eobj.MKBSDTermDR=PropertyDR
	if Supplement'="" 
	{
		s EvalSupple=##class(web.DHCBL.BDP.FunLib).EvalJSON(Supplement)
		s eobj.MKBSDSupplement=EvalSupple
	}
	d obj.MKBSDStructDataSetObjectId(Pid)
	d obj.MKBSDTermDRSetObjectId(PropertyDR)
	s obj.MKBSDStructResult=StructResult
	s obj.MKBSDStructResultID=StructResultID
	//if (Supplement'="") 
	//{
		s EvalSupple=##class(web.DHCBL.BDP.FunLib).EvalJSON(Supplement)
		s obj.MKBSDSupplement=EvalSupple
	//}
	
	s Diag=$lg($g(^User.MKBStructuredDataD(Pid)),2)
	s DiagResult=..StdGetChiForNewSeqStrucIDs(eobj.MKBSDStructResultID,eobj.MKBSDTermDR)
	Ts
	
	s psc=pobj.%Save()
	s sc=obj.%Save()
	
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		
		//引用表
		s delResult=##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDR",id)
		if (PropertyDR'=""){
			if (Cid=""){
				s resultrefS = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDR",obj.%Id(),"T",PropertyDR)
			}	
			else{
				s cobj=##class(User.MKBStructuredDataResult).%OpenId(Cid)
				s refRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("SDR", Cid, "T", cobj.MKBSDTermDR)
				
				s resultRef = ##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "SDR", obj.%Id(), "T", PropertyDR)
			}
	 			
		}
		
		if (StructResultID'=""){
			s resultref = ##class(web.DHCBL.MKB.MKBReference).SaveExpFroReference("SDR",obj.%Id(),StructResultID)
		}
		s basedr = $lg($g(^User.MKBStructuredDataD(Pid)),22)
		s Base=$lg($g(^User.MKBStructuredBaseD(basedr)),2)			
		d:Cid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredDataResult","User.MKBStructuredDataResult",Base_"-结构化诊断",id,Diag_"-"_DiagResult,"A",eobj)	
		d:Cid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredDataResult","User.MKBStructuredDataResult",Base_"-结构化诊断",id,Diag_"-"_DiagResult,"U",eobj,bobj)
		d eobj.%Close()
		d:Cid'="" bobj.%Close()	
		set result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Tro
		s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	
	d obj.%Close()
	d pobj.%Close()
	quit result
}

/// Creator:李得原
/// CreatDate:2018-12-10
/// Description：结构化结果子表的删除
/// Table：User.MKBStructuredDataResult
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).DeleteStructResult()
ClassMethod DeleteStructResult(id)
{
	if (id'="")
	{
		Ts
		s Pid=$p(id,"||",1)
		s Cid=$p(id,"||",2)
		s Diag=$lg($g(^User.MKBStructuredDataD(Pid)),2)
		s DiagResultId=$lg($g(^User.MKBStructuredDataD(Pid,"MKBSDStructResult",Cid)),2)
		s DiagTermdr=$lg($g(^User.MKBStructuredDataD(Pid,"MKBSDStructResult",Cid)),4)
		s DiagResult=..StdGetChiForNewSeqStrucIDs(DiagResultId,DiagTermdr)
		s bobj=##class(web.Entity.MKB.MKBStructuredDataResult).%New()
		s bobj.MKBSDStructResultID=DiagResultId
		s bobj.MKBSDTermDR=DiagTermdr
		s sc= ##class(User.MKBStructuredDataResult).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			//删除子表记录成功后调用
			s refResult =  ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDR",id)
			set result = "{success:'true',info:'删除成功！'}"
			s basedr = $lg($g(^User.MKBStructuredDataD(Pid)),22)
			s Base=$lg($g(^User.MKBStructuredBaseD(basedr)),2)			

			d:id'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredDataResult","User.MKBStructuredDataResult",Base_"-结构化诊断",id,Diag_"-"_DiagResult,"D",bobj)	
			


			s pobj=##class(User.MKBStructuredData).%OpenId(Pid)
			if '$d(^User.MKBStructuredDataD(Pid,"MKBSDStructResult"))
			{	
				s pobj.MKBSDChildStructFlag=""
			}
			Set UpdateDate=$p($h,",",1)       //上传日期
			if ($d(%session)<=0)
			{
				Set UpdateUserDR=1   //上传人
			}
			else
			{
				Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
			}
			
			d pobj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
			s pobj.MKBSDDate=UpdateDate	
			s psc=pobj.%Save()
			d pobj.%Close()
		}
		else
		{
			Tro
			set result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
		}
	}
	else
	{
		set result = "{success:'false',info:'id为空！'}"
	}
	q result
}

/// Creator:李得原
/// CreatDate:2018-12-10
/// Description：结构化结果展示
/// Table：User.MKBStructuredDataResult
/// Input：父表id 
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetDownLoadList","")
Query GetResultList(id As %String) As %Query(ROWSPEC = "Rowid,MKBSDStructData,MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement,MKBSDSequence,MKBTActiveFlag")
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
			s rowid=$o(^User.MKBStructuredDataD(id,"MKBSDStructResult",rowid))
			q:rowid=""
			s Rowid=id_"||"_rowid
			s MKBSDTermDR=$lg($g(^User.MKBStructuredDataD(id,"MKBSDStructResult",rowid)),4)
			s MKBTActiveFlag=$lg($g(^User.MKBTermD(MKBSDTermDR)),9)
			s MKBSDSupplement=$lg(^User.MKBStructuredDataD(id,"MKBSDStructResult",rowid),5)
			s MKBSDStructData=id
			;s MKBSDStructResult=$lg(^User.MKBStructuredDataD(id,"MKBSDStructResult",rowid),3)
			s MKBSDStructResultID=$lg(^User.MKBStructuredDataD(id,"MKBSDStructResult",rowid),2)
			s MKBSDStructResult=..GetChiForNewSeqStrucIDs(MKBSDStructResultID,MKBSDTermDR)
			if MKBSDSupplement'=""
			{
				s MKBSDSupplement=$zstrip(MKBSDSupplement,"<>W")
				if MKBSDStructResult["]"
				{
					s str=$e(MKBSDStructResult,1,*-1)
					s MKBSDStructResult=str_",("_MKBSDSupplement_")]"
				}
				else
				{
					s MKBSDStructResult=MKBSDStructResult_"[("_MKBSDSupplement_")]"
				}
			}
			s MKBSDSequence=$lg(^User.MKBStructuredDataD(id,"MKBSDStructResult",rowid),6)

			d getCTTitle
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(Rowid,MKBSDStructData,MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement,MKBSDSequence,MKBTActiveFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResultListExecute ]
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
/// CreatDate:2018-12-24
/// Description：清空已选属性列表临时global
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).ClearSelProperty()
ClassMethod ClearSelProperty() As %String
{
	k ^TMPSTRSELPROPERTY("SelProperty")
	q 1
}

/// Creator:石萧伟
/// CreatDate:2018-12-24
/// Description：设置已选属性列表临时global
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateSelProperty()
ClassMethod UpdateSelProperty(index, titleid, title, id, text, type) As %String
{
	s:id="" id=0
	if (type="add"){
		s ^TMPSTRSELPROPERTY("SelProperty",index,id)=titleid_"^"_title_"^"_text
	}else{
		if (id=0){
			k ^TMPSTRSELPROPERTY("SelProperty",index) //单选框切换时先清空
		}else{
			k ^TMPSTRSELPROPERTY("SelProperty",index,id)
		}
	}
	s count=$o(^TMPSTRSELPROPERTY("SelProperty",""),-1)
	s result = "{count:'"_count_"',success:'true'}" 
	q result
}

/// Creator：石萧伟
/// CreatDate: 2018-12-24
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
	s index=$o(^TMPSTRSELPROPERTY("SelProperty",index)) q:index=""
	
	s id=""
	for 
	{
		s id=$o(^TMPSTRSELPROPERTY("SelProperty",index,id)) q:id=""
		if ($o(^TMPSTRSELPROPERTY("SelProperty",index,""),-1)'=0){
			continue:id=0 //去除属性内容为空的重复节点信息
		}
		s titleid=$p(^TMPSTRSELPROPERTY("SelProperty",index,id),"^",1)
		s title=$p(^TMPSTRSELPROPERTY("SelProperty",index,id),"^",2)
		s text=$p(^TMPSTRSELPROPERTY("SelProperty",index,id),"^",3)
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
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateSupplement("2613||75802","1111")
ClassMethod UpdateSupplement(Cid As %String, Supplement As %String)
{
	s Supplement=$zstrip($g(Supplement),"<>W")
	s EvalSupple=##class(web.DHCBL.BDP.FunLib).EvalJSON(Supplement)
	s obj=##class(User.MKBStructuredDataResult).%OpenId(Cid)
	s obj.MKBSDSupplement=EvalSupple
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
/// CreatDate:2018-12-28
/// Description：按科室频次排序
/// Table：
/// Input：locstr 科室拼串, frequencestr 频次拼串,loc 搜索科室名
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).SortLoc("","","","","","")
ClassMethod SortLoc(rowid, locstr, frequencestr, loc, PinFlag, PINYINDiag) As %String
{
	if PinFlag=1
	{
		s n=1
		s sum=0
		for
		{
			s EachLoc=$p(locstr,",",n)
			q:EachLoc=""
			if EachLoc[loc
			{
				s sum=sum+$p(frequencestr,",",n)
			}
			s n=n+1
		}
		s ^TMP("Sort",PINYINDiag,rowid,sum)=""
	} 
	else
	{
		s n=1
		s sum=0
		for
		{
			s EachLoc=$p(locstr,",",n)
			q:EachLoc=""
			if EachLoc[loc
			{
				s sum=sum+$p(frequencestr,",",n)
			}
			s n=n+1
		}
		s ^TMP("Sort",sum,rowid)=""
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-01
/// Description：展示排序后的科室子表
/// Table：User.MKBStructuredDataLoc
/// Input：父表id ,诊断类型（出院、门急诊）
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetLocList","","")
Query GetLocList(id As %String, mark As %String) As %Query(ROWSPEC = "Rowid,MKBSDLoc,MKBSDFrequency,MKBSDLocSource")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, id As %String, mark As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	k ^TempGetLocList
	if id'=""
	{
		s rowid=0
		for
		{
			s rowid=$o(^User.MKBStructuredDataD(id,"MKBSDStructLoc",rowid))
			q:rowid=""
			s MKBRowid=id_"||"_rowid
			s Loc=$lg(^User.MKBStructuredDataD(id,"MKBSDStructLoc",rowid),2)
			s Frequency=$lg(^User.MKBStructuredDataD(id,"MKBSDStructLoc",rowid),3)
			s LocSource=$lg(^User.MKBStructuredDataD(id,"MKBSDStructLoc",rowid),4)
			if LocSource[mark
			{
				s ^TempGetLocList(Frequency,MKBRowid,LocSource,Loc)=""
			}
		}
		s MKBSDFrequency=""
		for
		{
			s MKBSDFrequency=$o(^TempGetLocList(MKBSDFrequency),-1)
			q:MKBSDFrequency=""
			s Rowid=0
			for
			{
				s Rowid=$o(^TempGetLocList(MKBSDFrequency,Rowid))
				q:Rowid=""
				s MKBSDLocSource=$o(^TempGetLocList(MKBSDFrequency,Rowid,""))
				s MKBSDLoc=$o(^TempGetLocList(MKBSDFrequency,Rowid,MKBSDLocSource,""))
				d getLoc
			}
			
		}
	}

	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getLoc
	set Data=$lb(Rowid,MKBSDLoc,MKBSDFrequency,MKBSDLocSource)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocExecute ]
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

/// 诊断数据的接口：将结构化ID串转换为中文描述
/// Input：ids：结构化ID串
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs("14965:329627","15632")
ClassMethod GetChiForStrucIDs(ids, termdr)
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
		s ValueString=""
		s ResultLen=$l(ids,",")
		for i=1:1:ResultLen
		{
			s Result=$p(ids,",",i)
			s key=$p(Result,":",1)
			s values=$p(Result,":",2)
			if ('$d(^User.MKBTermPropertyD(key)))
			{
				continue
			}
			if values["S"
			{
				s ValueLen=$l(values,"*")
				
				for j=1:1:ValueLen
				{
					s ValueDr=$p(values,"*",j)
					s ValueDr=$tr(ValueDr,"S","")
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
			}
			else
			{
				s ValueLen=$l(values,"*")
				for j=1:1:ValueLen
				{
					s ValueDr=$p(values,"*",j)
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
		}
		s result=result_"["_ValueString_"]"	
	}
	q result
}

/// Creator:李得原
/// CreatDate:2019-04-11
/// Description：获取诊断短语、结构化诊断、MRC描述和ICD
/// Table：User.MKBStructuredData
/// Input：
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetExtendList","")
Query GetExtendList(desc As %String) As %Query(ROWSPEC = "MKBSDRowid,MKBSDDesc,MKBSDResult,MKBSDMrc,MKBSDICD")
{
}

ClassMethod GetExtendListExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	
	if desc=""      //如果传入参数为空
	{
		s MKBSDRowid=""
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s flag=0
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)   //诊断短语
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			s MKBSDResult=""
			if MKBSDMDr'=""
			{
				s MKBSDMrc=$p(^MRC("ID",MKBSDMDr),"^",2)                    //MRC中文描述
				s MKBSDICD=$p(^MRC("ID",MKBSDMDr),"^",4)                   //ICD
			}
			else
			{
				s MKBSDMrc=""
				s MKBSDICD=""
			}
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s MKBSDResultTerm=""
				s MKBSDResult=""
				s MKBSDResultTerm=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				if MKBSDResultTerm'=""
				{
					s MKBSDResult=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTerm)
					d getLoc
				}
				s flag=1
			}
			if flag=0
			{
				d getLoc
			}
		}
	}
	else			//如果传参不为空
	{
		s:desc'="" desc=$zconvert(desc,"U")
		s desc=$zstrip(desc,"<>W")
		s Desc=""
		for
		{
			s Desc=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",Desc))
			q:Desc=""
			s flag=0
			if (Desc[desc)
			{
				s MKBSDDesc=$zstrip(Desc,"<>W")
				s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",Desc,0))
				s MKBSDResult=""
				s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)   //诊断短语
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
				if MKBSDMDr'=""
				{
					s MKBSDMrc=$p(^MRC("ID",MKBSDMDr),"^",2)                    //MRC中文描述
					s MKBSDICD=$p(^MRC("ID",MKBSDMDr),"^",4)                   //ICD
				}
				else
				{
					s MKBSDMrc=""
					s MKBSDICD=""
				}
				s MKBSDRRowid=0
				for
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
					q:MKBSDRRowid=""
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
					s MKBSDResultTerm=""
					s MKBSDResult=""
					s MKBSDResultTerm=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
					if MKBSDResultTerm'=""
					{
						s Result=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTerm)
						if MKBSDSupplement'=""
						{
							if Result["]"
							{
								s str=$e(Result,1,*-1)
								s MKBSDResult=str_",("_MKBSDSupplement_")]"
							}
							else
							{
								s MKBSDResult=Result_"[("_MKBSDSupplement_")]"
							}
						}
						else
						{
							s MKBSDResult=Result
						}
					}
					s flag=1
					d getLoc
				}
				if flag=0
				{
					d getLoc 
				}
			}
		}
	}

	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getLoc
	set Data=$lb(MKBSDRowid,MKBSDDesc,MKBSDResult,MKBSDMrc,MKBSDICD)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetExtendListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExtendListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetExtendListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExtendListExecute ]
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

/// Creator：chenying
/// CreatDate: 2015-3-27
/// Description：用于获取icd信息
/// Table：User.MRCICDDx
/// Input：rowid,code,desc
/// Return：MRCIDRowId,MRCIDCode,MRCIDDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetDataForCmb1","","","左","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, icd10 As %String) As %Query(ROWSPEC = "MRCIDRowId:%String,MRCIDCode:%String,MRCIDDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, icd10 As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s MRCIDRowId=rowid
		s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)
		s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)
		//s MRCIDCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDCode)
		//s MRCIDDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDDesc)
		d OutputRowCmb
	}
	else
	{
		s:icd10'="" icd10=$ZCVT(icd10,"U") //转换成大写
		s:desc'="" desc=$ZCVT(desc,"U") //转换成大写
		s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("MRC_ICDDx")
		//获取授权
		s AuStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByDefaultSession()
		if ($l(AuStr,"#")=1) {
			s Limited=0
			s AutBit=""
		}
		elseif ($l(AuStr,"#")=2) {
			s Limited=$p(AuStr,"#",1)
			s AutBit=$p(AuStr,"#",2)
		}
		s AuFlag=0
		if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s MRCIDSexDRAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
		s MRCIDSexDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (MRCIDSexDRAuStr="")||(MRCIDSexDRAuStr["limited:0") s MRCIDSexDRAuFlag=1	
		
		s MRCIDRowId=0
		for
		{
			s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""
			
			s MRCIDSexDR=$p($g(^MRC("ID",MRCIDRowId)),"^",10)
			s MRCIDSexDRstrRowId="{ID:"_MRCIDSexDR_"}"
			//筛选授权后的数据
			if (($bit(AutBit,MRCIDRowId)=1)||(AuFlag=1))&&((MRCIDSexDRAuStr[MRCIDSexDRstrRowId)||(MRCIDSexDRAuFlag=1))
			{
				s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)
				s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)
				//s MRCIDCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDCode)
				//s MRCIDDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDDesc)
				continue:(MRCIDCode="-")||(MRCIDDesc="-") //屏蔽垃圾数据
				s MRCIDValid=$p($g(^MRC("ID",MRCIDRowId)),"^",27)
				continue:MRCIDValid="N"
				s MRCIDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)
				continue:(MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h)
				
				if desc'=""
				{
					s AliasFlag=0
					s ALIASText1=""
					s ALIASChildsub=0
					for
					{
						s ALIASChildsub=$o(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
						q:ALIASChildsub=""
						s ALIASText=$g(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
						s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					}
					s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,MRCIDDesc,desc)
					s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MRCIDDesc)
					s Flag2=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
					s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
					if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
				}
				else
				{
					s AliasFlag=1
				}
				
				i ($ZCVT(MRCIDCode,"U")[icd10)&&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(MRCIDRowId,MRCIDCode,MRCIDDesc)
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

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:
/// Table:
/// Input:MRCid
/// Return:Term指向，常用名(中心词),结构化结果拼串
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetData()
ClassMethod GetMRCData(MRCid As %String)
{
	s str=""
	s MKBSDRowid=0

	if $d(^User.MKBStructuredDataI("ICDIndex",MRCid))
	{
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("ICDIndex",MRCid,MKBSDRowid))
			q:MKBSDRowid=""

			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",0))
			q:MKBSDRRowid=""
			s TermStr=""
			s TermDR=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(TermDR)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s ComName=$p(strCom,"&%",1) //诊断常用名
			s TermDesc=$lg($g(^User.MKBTermD(TermDR)),3)
			if ComName=""     //如果常用名为空，中心词(中心词)
			{
				s TermStr=TermDesc_"("_TermDesc_")"
			}
			else               //如果常用名不为空，常用名(中心词)
			{
				s TermStr=ComName_"("_TermDesc_")"
			}
			s Diag=$Lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MRCDesc=$p(^MRC("ID",MRCid),"^",2)
			if Diag=MRCDesc
			{
				s str=TermDR_"&&"_TermStr_"&&"_MKBSDRowid_"||"_MKBSDRRowid
				q
			}
		}	
	}
	q str
}

/// Creator:石萧伟
/// CreatDate:2019-04-18
/// Description：查询别名/其他描述
/// Table：User.MKBStructuredDataOther
/// Input：mark 别名/其他描述  标记
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetOtherList","")
Query GetOtherList(id As %String, mark As %String, desc As %String) As %Query(ROWSPEC = "Rowid,MKBSDOther,MKBSDOtherNote,MKBSDOtherCode,MKBSDOtherMark")
{
}

ClassMethod GetOtherListExecute(ByRef qHandle As %Binary, id As %String, mark As %String, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	if id'=""
	{
		s rowid=0
		for
		{
			s rowid=$o(^User.MKBStructuredDataD(id,"MKBSDStructOther",rowid))
			q:rowid=""
			s Rowid=id_"||"_rowid
			s MKBSDOther=$lg(^User.MKBStructuredDataD(id,"MKBSDStructOther",rowid),2)
			s MKBSDOtherNote=$lg(^User.MKBStructuredDataD(id,"MKBSDStructOther",rowid),3)
			s MKBSDOtherCode=$lg(^User.MKBStructuredDataD(id,"MKBSDStructOther",rowid),4)
			s MKBSDOtherMark=$lg(^User.MKBStructuredDataD(id,"MKBSDStructOther",rowid),5)
			if ((MKBSDOtherMark=mark) && (MKBSDOther[desc))
			{
				d getOther
			}
		}
	}

	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getOther
	set Data=$lb(Rowid,MKBSDOther,MKBSDOtherNote,MKBSDOtherCode,MKBSDOtherMark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOtherListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOtherExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOtherListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOtherExecute ]
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

/// CreatDate:2019-04-18
/// Description:前台右键合并功能
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).AllOtherData(2298381,2298382,"测试2","CS2","")
ClassMethod AllOtherData(rid, ids, dias, pys, icds) As %String
{
	s len = $Length(ids,",")
    for i=1:1:len  
    { 
      s id=$p(ids,",",i)
      s dia=$p(dias,",",i)
      s py=$p(pys,",",i)
      s icd=$p(icds,",",i)
      s result = ..OtherUpdate(rid,"",dia,"",py,"OD")
      if (result["true")
      {
	      //EditUpdate(rowid As %String, MKBSDStatus As %String, MKBSDICD As %String, MKBSDICDDesc As %String, MKBSDChildStructFlag As %String, MKBSDMergeFlag As %String, MKBSDLoc As %String) As %String
	  	s result1 = ..EditUpdate(id,"",icd,"","","C","")
	  	if (result1["true")
	  	{
		  s result2 =  ..SaveCopyOther(id,rid)		//合并其他描述
		  d ..DeleteDataF(id)
		}	 
	  }
    }
    
    q 1
}

/// Creator:石萧伟
/// CreatDate:2019-04-18
/// Description:别名/其他描述更新数据
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).OtherUpdate(1,"","122","222","222","OD")
ClassMethod OtherUpdate(Pid As %String, Cid As %String, MKBSDOther As %String, MKBSDOtherNote As %String, MKBSDOtherCode As %String, MKBSDOtherMark As %String) As %String
{
	
	if Cid=""
	{
		s obj=##class(User.MKBStructuredDataOther).%New(Pid)
	}
	else
	{
		s obj=##class(User.MKBStructuredDataOther).%OpenId(Cid)
		s bobj=##class(web.Entity.MKB.MKBStructuredDataOther).%New()
		s:MKBSDOtherNote'="" bobj.MKBSDOtherNote=obj.MKBSDOtherNote
		s:MKBSDOtherMark'="" bobj.MKBSDOtherMark=obj.MKBSDOtherMark
		s:MKBSDOtherCode'="" bobj.MKBSDOtherCode=obj.MKBSDOtherCode
		s:MKBSDOther'="" bobj.MKBSDOther=obj.MKBSDOther
	}
	s eobj=##class(web.Entity.MKB.MKBStructuredDataOther).%New()
	s:MKBSDOther'="" eobj.MKBSDOther=MKBSDOther
	s:MKBSDOther'="" eobj.MKBSDOther=MKBSDOther
	s:MKBSDOtherNote'="" eobj.MKBSDOtherNote=MKBSDOtherNote
	s:MKBSDOtherCode'="" eobj.MKBSDOtherCode=MKBSDOtherCode
	s:MKBSDOtherMark'="" eobj.MKBSDOtherMark=MKBSDOtherMark
	s Diag=$lg($g(^User.MKBStructuredDataD(Pid)),2)
	s DiagOther=MKBSDOther
	
	d obj.MKBSDStructDataSetObjectId(Pid)
	s obj.MKBSDOtherCode=MKBSDOtherCode
	s obj.MKBSDOtherMark=MKBSDOtherMark
	s obj.MKBSDOtherNote=MKBSDOtherNote
	s obj.MKBSDOther=MKBSDOther
	Ts
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		set result = "{success:'true',id:'"_id_"'}" 
		s Base=$lg($g(^User.MKBStructuredDataD(Pid)),22)
		if (Cid="")
		{
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Base,eobj.MKBSDOtherCode,id)  //拼音码全文索引
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Base,eobj.MKBSDOther,id) //诊断名全文索引	
		}
		else
		{
			
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(Base,bobj.MKBGAPYCode,id)  //拼音码全文索引
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(Base,bobj.MKBGADesc,id) //诊断名全文索引
			
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Base,eobj.MKBSDOtherCode,id)  //拼音码全文索引
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Base,eobj.MKBSDOther,id) //诊断名全文索引
		}
		d:Cid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredDataResult","User.MKBStructuredDataResult","数据处理工厂-别名/其他描述",id,Diag_"-"_DiagOther,"A",eobj)	
		d:Cid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredDataResult","User.MKBStructuredDataResult","数据处理工厂-别名/其他描述",id,Diag_"-"_DiagOther,"U",eobj,bobj)
		d eobj.%Close()
		d:Cid'="" bobj.%Close()
	}
	else
	{
		Tro
		set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
		
	}
	d obj.%Close()
	quit result
}

/// Creator:石萧伟
/// CreatDate:2019-04-18
/// Description：别名/其他描述子表的删除
/// Table：User.MKBStructuredDataOther
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).DeleteOtherData()
ClassMethod DeleteOtherData(id)
{
	if id'=""
	{
		Ts
		s Pid=$p(id,"||",1)
		s Cid=$p(id,"||",2)
		s bobj=##class(web.Entity.MKB.MKBStructuredDataOther).%New()
		s bobj.MKBSDOther=$lg($g(^User.MKBStructuredDataOtherD(Pid,"MKBSDStructOther",Cid)),2)
		s bobj.MKBSDOtherNote=$lg($g(^User.MKBStructuredDataOtherD(Pid,"MKBSDStructOther",Cid)),3)
		s bobj.MKBSDOtherCode=$lg($g(^User.MKBStructuredDataOtherD(Pid,"MKBSDStructOther",Cid)),4)
		s bobj.MKBSDOtherMark=$lg($g(^User.MKBStructuredDataOtherD(Pid,"MKBSDStructOther",Cid)),5)
		
		s Diag=$lg($g(^User.MKBStructuredDataD(Pid,"MKBSDStructOther",Cid)),2)
		s sc=##class(User.MKBStructuredDataOther).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			set result = "{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredDataOther","User.MKBStructuredDataOther","数据处理工厂-别名/其他描述",id,Diag,"D",bobj)
			d bobj.%Close()
		}
		else
		{
			Tro
			set result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
		}
	}
	else
	{
		set result = "{success:'false',info:'id为空！'}"
	}
	q result
}

/// Creator:石萧伟   zrf 2021-8-25   删除父表的同时删除子表数据
/// CreatDate:2019-04-19   
/// Description：父表信息删除	 		
/// Table：User.MKBStructuredData
/// Input： 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).DeleteDataF(1878431)
ClassMethod DeleteDataF(id)
{
	s result=""
	if (id'="")
	{
		//先删除全文索引和子表数据
		s re= ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndexByCode(id)
		s cre= ..DelChildOfData(id)		//删除所有子表数据
		if ((re'["false")&&(cre=0))		//删除成功
		{
			s pobj=##class(User.MKBStructuredData).%OpenId(id)
			s bobj = ##class(web.Entity.MKB.MKBStructuredData).%New()
			s bobj.MKBSDRowid=id
			
			s bobj.MKBSDDiag=pobj.MKBSDDiag		/// 诊断名
			s bobj.MKBSDLoc=pobj.MKBSDLoc		/// 科室名
			s bobj.MKBSDFrequency=pobj.MKBSDFrequency	/// 诊断出现频次
			s bobj.MKBSDStatus=pobj.MKBSDStatus		/// 数据处理状态
			s bobj.MKBSDCenterWordID=pobj.MKBSDCenterWordID		/// 参考中心词
			s bobj.MKBSDDate=pobj.MKBSDDate			/// 操作时间
			s:bobj.MKBSDDate'="" bobj.MKBSDDate=$zd(bobj.MKBSDDate,3)
			s:pobj.MKBSDUpdateUser'="" bobj.MKBSDUpdateUser = pobj.MKBSDUpdateUser.%Id()	/// 操作人(从Session中取)
			
			s bobj.MKBSDSegmentation=pobj.MKBSDSegmentation		/// 分词结果
			s bobj.MKBSDDiaSource=pobj.MKBSDDiaSource			/// 诊断来源
			s:pobj.MKBSDICDTermDr'="" bobj.MKBSDICDTermDr = pobj.MKBSDICDTermDr.%Id()	/// MRCDr
			
			s bobj.MKBSDICD=pobj.MKBSDICD			/// ICD编码
			s bobj.MKBSDICDDesc=pobj.MKBSDICDDesc		/// ICD中文描述
			s bobj.MKBSDTotalFreq=pobj.MKBSDTotalFreq		/// 总频次
			s bobj.MKBSDChildStructFlag=pobj.MKBSDChildStructFlag		/// 结构化标记
			s bobj.MKBSDMergeFlag=pobj.MKBSDMergeFlag		/// 合并标记
			s bobj.MKBSDNote=pobj.MKBSDNote		/// 备注
			s bobj.MKBSDReson=pobj.MKBSDReson		/// 上报理由
			s bobj.MKBSDInitialICD=pobj.MKBSDInitialICD		/// 最优ICD
			s bobj.MKBSDDiagPYCode=pobj.MKBSDDiagPYCode		/// 诊断名拼音码
			s:pobj.MKBSDBaseDr'="" bobj.MKBSDBaseDr = pobj.MKBSDBaseDr.%Id()	/// 工厂指向

			s bobj.MKBSDResultRelation=pobj.MKBSDResultRelation		/// 诊断1 2 3之间的关系 AND OR
			s bobj.MKBSDTCMDiagFlag=pobj.MKBSDTCMDiagFlag		/// 中医诊断
			s bobj.MKBSDTCMSynFlag=pobj.MKBSDTCMSynFlag		/// 中医证型
			s bobj.MKBSDTumourFlag=pobj.MKBSDTumourFlag		/// 肿瘤形态学编码
			s bobj.MKBSDInjuryFlag=pobj.MKBSDInjuryFlag		/// 损伤中毒外部原因
			s bobj.MKBSDDateActiveFrom=pobj.MKBSDDateActiveFrom		/// 开始日期
			s:bobj.MKBSDDateActiveFrom'="" bobj.MKBSDDateActiveFrom=$zd(bobj.MKBSDDateActiveFrom,3)
			s bobj.MKBSDDateActiveTo=pobj.MKBSDDateActiveTo		/// 截止日期
			s:bobj.MKBSDDateActiveTo'="" bobj.MKBSDDateActiveTo=$zd(bobj.MKBSDDateActiveTo,3)
			s bobj.MKBSDHisRowID=pobj.MKBSDHisRowID		///  his诊断ID
			s bobj.MKBSDHisCode=pobj.MKBSDICDDesc		/// HIS诊断代码
			s bobj.MKBSDDeputyCode=pobj.MKBSDDeputyCode		/// 副编码 
			s bobj.MKBSDClinicType=pobj.MKBSDClinicType		/// 就诊类型 （门诊O。急诊E。住院I。体检H。新生儿N）
			s bobj.MKBSDClassification=pobj.MKBSDClassification		/// icd诊断分类
			s bobj.MKBSDLimitSex=pobj.MKBSDLimitSex		/// 限制性别
			s bobj.MKBSDHisRemark=pobj.MKBSDHisRemark		///注释
			s bobj.MKBSDAgeFrom=pobj.MKBSDAgeFrom		/// 从年龄
			s bobj.MKBSDAgeTo=pobj.MKBSDAgeTo		/// 到年龄
			s bobj.MKBSDICD9Code=pobj.MKBSDICD9Code		/// icd9代码
			s bobj.MKBSDNationalDesc=pobj.MKBSDNationalDesc		///国家标准名称
			s bobj.MKBSDMatchGlobalFlag=pobj.MKBSDMatchGlobalFlag	//能否匹配全局化词表
			
			d pobj.%Close()
			kill pobj
			Tstart
			s sc=##class(User.MKBStructuredData).%DeleteId(id)
			IF $$$ISOK(sc)
			{
				s Base=$lg($g(^User.MKBStructuredBaseD(bobj.MKBSDBaseDr)),2)
				
				Tc
				s result="{success:'true',info:'删除成功！'}"
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData",Base_"-诊断短语",id,bobj.MKBSDDiag,"D",bobj)
			}
			else
			{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog(Base_"-诊断短语","web.DHCBL.MKB.MKBStructuredData","DeleteDataAndChild",bobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
		else
		{
			s result = "{success:'false',info:'删除子表/全文索引失败！'}"
			
		}
	}
	else
	{
		set result = "{success:'false',info:'id为空！'}"
	}
	q result
}

/// Creator:石萧伟
/// CreatDate:2019-09-24
/// Description：删除上报列表数据
/// Table：User.MKBDataReviewed
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).DeleteRewData("2161")
ClassMethod DeleteRewData(id)
{
  s result=""


  Tstart
  s sc=##class(User.MKBDataReviewed).%DeleteId(id)
  IF $$$ISOK(sc) {
   Tc
   s result="{success:'true',info:'删除成功'}"
   //保存日志
   //d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_DocManage","User.MKBDocManage","术语文献管理",id,eobj.MKBDMDesc,"D",eobj)
  }
  else 
  {
     Trollback
     s result = "{success:'false',errorinfo:'"_$SYSTEM.Status.GetErrorText(sc)_"'}"
  }
 q result
}

/// Creator:李得原
/// CreatDate:2019-04-22
/// Description：通过父表ID获取所有子表id串
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetChildIdString("2161")
ClassMethod GetChildIdString(Pid As %String)
{
	s str=""
	s MKBRRowid=0
	for
	{
		s MKBRRowid=$o(^User.MKBStructuredDataD(Pid,"MKBSDStructResult",MKBRRowid))
		q:MKBRRowid=""
		
		s ResultID=$lg($g(^User.MKBStructuredDataD(Pid,"MKBSDStructResult",MKBRRowid)),2)
		s TermDR=$lg($g(^User.MKBStructuredDataD(Pid,"MKBSDStructResult",MKBRRowid)),4)

		s:str'="" str=str_"||"_ResultID_"%%"_TermDR
		s:str="" str=ResultID_"%%"_TermDR
	}
	q str
}

/// Creator:李得原
/// CreatDate:2019-04-23
/// Description：通过父表ID和子表别名标识 获取
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetOtherDesc("","")
ClassMethod GetOtherDesc(MKBSDRowid As %String, flag As %String)
{
	s str=""
	if flag="AN"
	{
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:str'="" str=str_"、"_MKBSDOAlias
				s:str="" str=MKBSDOAlias
			}
		}
	}
	else
	{
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:str'="" str=str_"、"_MKBSDOOther
				s:str="" str=MKBSDOOther
			}
		}
	}
	q str
}

/// Creator:李得原
/// CreatDate:2019-04-23
/// Description：通过专业科室ID串取描述
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetProLocDesc("","")
ClassMethod GetProLocDesc(ids As %String, rowid As %String)
{
	s str=""
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s len=$l(ids,",")
	for i=1:1:len
	{
		s id=$p(ids,",",i)
		s ProLocDesc=$lg($g(^User.MKBTermD(id)),3)
		s:str'="" str=str_","_ProLocDesc
		s:str="" str=ProLocDesc
	}
	q str
}

/// Creator：石萧伟
/// CreatDate: 2019-04023
/// Description:根据知识库名称获取id
/// Table：User.MKBTerm
/// Other: w ##class().getTermId("LOC")
ClassMethod getTermId(desc)
{
	s Desc=$zcvt(desc,"U")
	s id=""
	s id=$o(^User.MKBTermBaseI("FlagIndex"," "_Desc,0))
	q id
}

/// Creator:石萧伟
/// CreatDate:2019-04-23
/// Description：树形术语库部分
/// Input：上级节点，术语库注册表的ID
/// Return:成功返回术语类型
/// Other:w ##class(web.DHCBL.MKB.MKBTerm).GetTreeJson(9,"")
ClassMethod GetTreeJson(base As %String, id As %String) As %String
{
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	s flag=##class(web.DHCBL.MKB.MKBTermBase).GetFlagById(base)
	s myJsonStr=""
	
	s ShowInLeftInfo=##class(web.DHCBL.MKB.MKBTerm).GetShowInLeftInfo(base)
	
	//输出菜单JSON串
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			s MKBTCode=$listGet($g(^User.MKBTermD(myRowID)),2)  //代码
			s MKBTDesc=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
			s MKBTDesc=$tr(MKBTDesc,"""","")
			s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTCode=$LISTGET($G(^User.MKBTermD(myRowID)),2) ///代码
			s MKBTLastLevelF=$LISTGET($G(^User.MKBTermD(myRowID)),5)   ///上级分类
			s MKBTLastLevel=""
			s:MKBTLastLevelF'="" MKBTLastLevel=$LISTGET($G(^User.MKBTermD(MKBTLastLevelF)),3)
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)
			s MKBTSequence=$LISTGET($G(^User.MKBTermD(myRowID)),8)   ///顺序
			s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)   ///备注
			s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			if count>1 w ","
			w "{""id"":"""_myRowID_""""
			w ",""id"":"""_myRowID_""",""text"":"""_MKBTDesc_""""
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
					if ($d(^User.MKBTermPropertyI("DescIndex",myRowID," "_MKBTPDesc)))
					{
						s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",myRowID," "_MKBTPDesc,0))
						s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
						s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
					} 
					s thisStr="""Extend"_MKBTBPRowID_""":"""_MKBTPDDesc_""""
					s:ExtendStr'="" ExtendStr=ExtendStr_","
					s ExtendStr=ExtendStr_thisStr
				} 
			}
			if ExtendStr'="" w ","
			w ExtendStr
			if (flag="ICD11")
			{
				if $d(^User.MKBTermI("ParentIndex",base,myRowID))
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
				if $d(^User.MKBTermI("ParentIndex",base,myRowID))
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
		}
	}
	w "]"
	q ""
}

/// Creator:钟荣枫
/// CreatDate:2021-8-12
/// Description：查询需要导出的数据
/// Table：
/// Input：
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetDownLoadList")
Query GetDownLoadList() As %Query(ROWSPEC = "MKBSDDiag,ResultStr,MKBSDLocStr,Status,MKBSDICD,MKBSDMrc,MKBSDCenterWord,MKBSDSegmentation,Type,AliasStr,OtherStr,SumLoc")
{
}

ClassMethod GetDownLoadListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1

	
	s SortCode=$o(^TempPrintOut(""))
	s total=0
	s UseCode=""
	for
	{
		if (SortCode="pinci")		//频次排序需要按照频次从高到低
		{	
			s UseCode=$o(^TempPrintOut(SortCode,UseCode),-1)
		}
		else
		{
			s UseCode=$o(^TempPrintOut(SortCode,UseCode))
		}
		q:UseCode=""
		s MKBSDRowid=""
		for
		{
			s MKBSDRowid=$o(^TempPrintOut(SortCode,UseCode,MKBSDRowid))
			q:MKBSDRowid=""
			s total=total+1
			s ResultStr=""
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
				s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
				s Result=..StdGetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
				s:ResultStr'="" ResultStr=ResultStr_"、"_Result
				s:ResultStr="" ResultStr=Result
			}
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBSDLocs=""
			s MKBSDLocStr=""
			s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)  //科室串
			if MKBSDLocs'=""
			{
				s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
				s loclen=$l(MKBSDLocs,",")
				for i=1:1:loclen
				{
					s Proid=$p(MKBSDLocs,",",i)
					continue:Proid=""
					s ProLocDesc=$lg($g(^User.MKBTermD(Proid)),3)
					s:MKBSDLocStr'="" MKBSDLocStr=MKBSDLocStr_"、"_ProLocDesc
					s:MKBSDLocStr="" MKBSDLocStr=ProLocDesc
				}
			}
			s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
			
			s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值
			
			s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
			s MKBSDCenterWord=""                         ;通过中心词id获取描述
			if MKBSDCenterWordID'=""
			{
				s WordCount=$l(MKBSDCenterWordID,",")
				for i=1:1:WordCount
				{
					s WordEach=$p(MKBSDCenterWordID,",",i)
					s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
					s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_"、"_MKBSDWord
					s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
				}	
			}
			s MKBSDDates=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),7)
			s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
			s:MKBSDDates="" MKBSDDate=""
			s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8)
			s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
			s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
			s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
			s Type=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
			s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)

			s AliasStr=""
			if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
			{
				s MKBSDORowid=0
				for
				{
					s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
					q:MKBSDORowid=""
					s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
					s:AliasStr'="" AliasStr=AliasStr_"、"_MKBSDOAlias
					s:AliasStr="" AliasStr=MKBSDOAlias
				}
			}
			s OtherStr=""
			if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
			{
				s MKBSDORowid=0
				for
				{
					s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
					q:MKBSDORowid=""
					s MKBSDOOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
					s:OtherStr'="" OtherStr=OtherStr_"、"_MKBSDOOther
					s:OtherStr="" OtherStr=MKBSDOOther
				}
			}
			s Status=$case(MKBSDStatus,"Y":"已处理","N":"未处理","P":"预处理","G":"放弃处理","X":"上报待处理","O":"已审核",:"")
			
			d getCTTitle
			/*
			if (json="")
			{
				s json="{""MKBSDDiag"":"""_MKBSDDiag_""",""ResultStr"":"""_ResultStr_""",""MKBSDLocStr"":"""_MKBSDLocStr_""",""Status"":"""_Status_""",""MKBSDICD"":"""_MKBSDICD_""",""MKBSDMrc"":"""_MKBSDMrc_""",""MKBSDCenterWord"":"""_MKBSDCenterWord_""",""MKBSDSegmentation"":"""_MKBSDSegmentation_""",""Type"":"""_Type_""",""AliasStr"":"""_AliasStr_""",""OtherStr"":"""_OtherStr_""",""SumLoc"":"""_SumLoc_"""}" 		
			}
			else
			{
				s json=json_",{""MKBSDDiag"":"""_MKBSDDiag_""",""ResultStr"":"""_ResultStr_""",""MKBSDLocStr"":"""_MKBSDLocStr_""",""Status"":"""_Status_""",""MKBSDICD"":"""_MKBSDICD_""",""MKBSDMrc"":"""_MKBSDMrc_""",""MKBSDCenterWord"":"""_MKBSDCenterWord_""",""MKBSDSegmentation"":"""_MKBSDSegmentation_""",""Type"":"""_Type_""",""AliasStr"":"""_AliasStr_""",""OtherStr"":"""_OtherStr_""",""SumLoc"":"""_SumLoc_"""}"		
			}*/
		}
	}
	
	;MKBSDDiag,ResultStr,MKBSDLocStr,Status,MKBSDICD,MKBSDMrc,MKBSDCenterWord,MKBSDSegmentation,Type,AliasStr,OtherStr,SumLoc
			///"诊断名,"_"结构化结果,"_"专业科室,"_"处理状态,"_"ICD编码,"_"ICD中文描述,"_"参考中心词,"_"分词,"_"数据类型,"_"别名,"_"其他描述,"_"总频次"		d file.Write(Desc_",")
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(MKBSDDiag,ResultStr,MKBSDLocStr,Status,MKBSDICD,MKBSDMrc,MKBSDCenterWord,MKBSDSegmentation,Type,AliasStr,OtherStr,SumLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDownLoadListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDownLoadListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:李得原
/// CreatDate:2019-04-29
/// Description：获取一条带有rowid的数据
/// Input：
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetOne()
ClassMethod GetOne(id As %String)
{
	s MKBSDRowid=$g(id)
	s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",0))
	if MKBSDRRowid'=""
	{
		s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
		s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
		s Result=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
	}
	else
	{
		s Result=""
	}
	s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
	s MKBSDLocs=""
	s MKBSDLocStr=""
	s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)  //科室串
	if MKBSDLocs'=""
	{
		s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
		s loclen=$l(MKBSDLocs,",")
		for i=1:1:loclen
		{
			s Proid=$p(MKBSDLocs,",",i)
			s ProLocDesc=$lg($g(^User.MKBTermD(Proid)),3)
			s:MKBSDLocStr'="" MKBSDLocStr=MKBSDLocStr_"、"_ProLocDesc
			s:MKBSDLocStr="" MKBSDLocStr=ProLocDesc
		}
	}
	s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
	s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
	s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
	s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值
	s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
	s MKBSDCenterWord=""                         ;通过中心词id获取描述
	if MKBSDCenterWordID'=""
	{
		s WordCount=$l(MKBSDCenterWordID,",")
		for i=1:1:WordCount
		{
			s WordEach=$p(MKBSDCenterWordID,",",i)
			s MKBSDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
			s:MKBSDCenterWord'="" MKBSDCenterWord=MKBSDCenterWord_"、"_MKBSDWord
			s:MKBSDCenterWord="" MKBSDCenterWord=MKBSDWord
		}	
	}
	s MKBSDDates=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),7)
	s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
	s:MKBSDDates="" MKBSDDate=""
	s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8)
	s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
	s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
	s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
	s Type=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
	s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
	s MKBSDDiagPYCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
	s AliasStr=""
	if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
	{
		s MKBSDORowid=0
		for
		{
			s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
			q:MKBSDORowid=""
			s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
			s:AliasStr'="" AliasStr=AliasStr_"、"_MKBSDOAlias
			s:AliasStr="" AliasStr=MKBSDOAlias
		}
	}
	s OtherStr=""
	if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
	{
		s MKBSDORowid=0
		for
		{
			s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
			q:MKBSDORowid=""
			s MKBSDOOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
			s:OtherStr'="" OtherStr=OtherStr_"、"_MKBSDOOther
			s:OtherStr="" OtherStr=MKBSDOOther
		}
	}
	s MKBSDNote=""
	s Str="{""Rowid"":"""_MKBSDRowid_""",""MKBSDDiag"":"""_MKBSDDiag_""",""MKBSDStatus"":"""_MKBSDStatus_""",""MKBSDCenterWordID"":"""_MKBSDCenterWordID_""",""MKBSDCenterWord"":"""_MKBSDCenterWord_""",""MKBSDDate"":"""_MKBSDDate_""",""MKBSDUpdateUser"":"""_MKBSDUpdateUser_""",""MKBSDSegmentation"":"""_MKBSDSegmentation_""",""sumloc"":"""_SumLoc_""",""MKBSDMrc"":"""_MKBSDMrc_""",""MKBSDMDr"":"""_MKBSDMDr_""",""MKBSDICD"":"""_MKBSDICD_""",""Result"":"""_Result_""",""MKBSDOAlias"":"""_AliasStr_""",""MKBSDOOther"":"""_OtherStr_""",""MKBSDDiaSource"":"""_Type_""",""MKBSDLocStr"":"""_MKBSDLocStr_""",""MKBSDLocs"":"""_MKBSDLocs_""",""MKBSDNote"":"""_MKBSDNote_""",""MKBSDDiagPYCode"":"""_MKBSDDiagPYCode_"""}"  
	q Str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2021-04-19
/// w ##class(web.DHCBL.MKB.MKBStructuredBase).FormValidateDiagICD("","","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidateDiagICD(id As %String, desc As %String, code As %String, hisid As %String, STBBase As %String) As %String
{
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	if (hisid="")
	{
		s:((code'="")&(desc'="")) flagc=$d(^User.MKBStructuredDataI("DiagICDIndex",STBBase,desc,code))
		if (id="") //如果为空，增加时的重复判断
		{
			if (flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else //如果不为空，修改时的重复判断
		{
			s idc=""
			s:((code'="")&(desc'="")) idc=$o(^User.MKBStructuredDataI("DiagICDIndex",STBBase,desc,code,0))	
			if ((idc'="")&(idc'=id)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	else
	{
		s:(hisid'="") flagc=$d(^User.MKBStructuredDataI("HisIDIndex",STBBase,hisid))
		if (id="") //如果为空，增加时的重复判断
		{
			if (flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else //如果不为空，修改时的重复判断
		{
			s idc=""
			s:(hisid'="") idc=$o(^User.MKBStructuredDataI("HisIDIndex",STBBase,hisid,0))	
			if ((idc'="")&(idc'=id)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate:2021-6-17
/// Description:保存主表
/// Table: 
/// Input: eobj
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructuredData).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBStructuredData) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.MKBSDDateActiveFrom'="" eobj.MKBSDDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MKBSDDateActiveFrom)
		s:eobj.MKBSDDateActiveTo'="" eobj.MKBSDDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MKBSDDateActiveTo)
		s:eobj.MKBSDDate'="" eobj.MKBSDDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MKBSDDate)
		if (eobj.MKBSDStatus = "X")
		{
			s eobj.MKBSDReson="A" //上报默认为缺诊断短语
		}
		s:eobj.MKBSDClinicType="" eobj.MKBSDClinicType="O,E,I,H,N" 	//就诊类型为空时，默认全选
		
		s:eobj.MKBSDTCMDiagFlag="" eobj.MKBSDTCMDiagFlag="N"		/// 中医诊断
		s:eobj.MKBSDTCMSynFlag eobj.MKBSDTCMSynFlag="N"		/// 中医证型
		s:eobj.MKBSDTumourFlag eobj.MKBSDTumourFlag="N"		/// 肿瘤形态学编码
		s:eobj.MKBSDInjuryFlag eobj.MKBSDInjuryFlag	="N"	/// 损伤中毒外部原因
		if (eobj.MKBSDStatus = "X")
		{
			s eobj.MKBSDReson="A" //上报默认为缺诊断短语
		}
		s:eobj.MKBSDStatus="" eobj.MKBSDStatus="N"
		
		
		s flag=..FormValidateDiagICD(eobj.MKBSDRowid,eobj.MKBSDDiag,eobj.MKBSDICD,eobj.MKBSDHisRowID,eobj.MKBSDBaseDr)  //调用重复验证
			
		if (flag=1)
		{	
			q "{success:'false',errorinfo:'该数据已存在！'}" 
		}
		if (eobj.MKBSDRowid="")
		{
			s obj=##class(User.MKBStructuredData).%New()
			
		}
		else
		{
			s obj=##class(User.MKBStructuredData).%OpenId(eobj.MKBSDRowid)
			s bobj = ##class(web.Entity.MKB.MKBStructuredData).%New()
			s bobj.MKBSDRowid=eobj.MKBSDRowid
			
			s bobj.MKBSDDiag=obj.MKBSDDiag		/// 诊断名
			s bobj.MKBSDLoc=obj.MKBSDLoc		/// 科室名
			s bobj.MKBSDFrequency=obj.MKBSDFrequency	/// 诊断出现频次
			s bobj.MKBSDStatus=obj.MKBSDStatus		/// 数据处理状态
			s bobj.MKBSDCenterWordID=obj.MKBSDCenterWordID		/// 参考中心词
			s bobj.MKBSDDate=obj.MKBSDDate			/// 操作时间
			s:obj.MKBSDUpdateUser'="" bobj.MKBSDUpdateUser = obj.MKBSDUpdateUser.%Id()	/// 操作人(从Session中取)
			
			s bobj.MKBSDSegmentation=obj.MKBSDSegmentation		/// 分词结果
			s bobj.MKBSDDiaSource=obj.MKBSDDiaSource			/// 诊断来源
			s:obj.MKBSDICDTermDr'="" bobj.MKBSDICDTermDr = obj.MKBSDICDTermDr.%Id()	/// MRCDr
			
			s bobj.MKBSDICD=obj.MKBSDICD			/// ICD编码
			s bobj.MKBSDICDDesc=obj.MKBSDICDDesc		/// ICD中文描述
			s bobj.MKBSDTotalFreq=obj.MKBSDTotalFreq		/// 总频次
			s bobj.MKBSDChildStructFlag=obj.MKBSDChildStructFlag		/// 结构化标记
			s bobj.MKBSDMergeFlag=obj.MKBSDMergeFlag		/// 合并标记
			s bobj.MKBSDNote=obj.MKBSDNote		/// 备注
			s bobj.MKBSDReson=obj.MKBSDReson		/// 上报理由
			s bobj.MKBSDInitialICD=obj.MKBSDInitialICD		/// 最优ICD
			s bobj.MKBSDDiagPYCode=obj.MKBSDDiagPYCode		/// 诊断名拼音码
			s:obj.MKBSDBaseDr'="" bobj.MKBSDBaseDr = obj.MKBSDBaseDr.%Id()	/// 工厂指向

			s bobj.MKBSDResultRelation=obj.MKBSDResultRelation		/// 诊断1 2 3之间的关系 AND OR
			s bobj.MKBSDTCMDiagFlag=obj.MKBSDTCMDiagFlag		/// 中医诊断
			s bobj.MKBSDTCMSynFlag=obj.MKBSDTCMSynFlag		/// 中医证型
			s bobj.MKBSDTumourFlag=obj.MKBSDTumourFlag		/// 肿瘤形态学编码
			s bobj.MKBSDInjuryFlag=obj.MKBSDInjuryFlag		/// 损伤中毒外部原因
			s bobj.MKBSDDateActiveFrom=obj.MKBSDDateActiveFrom		/// 开始日期
			s bobj.MKBSDDateActiveTo=obj.MKBSDDateActiveTo		/// 截止日期
			s bobj.MKBSDHisRowID=obj.MKBSDHisRowID		///  his诊断ID
			s bobj.MKBSDHisCode=obj.MKBSDICDDesc		/// HIS诊断代码
			s bobj.MKBSDDeputyCode=obj.MKBSDDeputyCode		/// 副编码 
			s bobj.MKBSDClinicType=obj.MKBSDClinicType		/// 就诊类型 （门诊O。急诊E。住院I。体检H。新生儿N）
			s bobj.MKBSDClassification=obj.MKBSDClassification		/// icd诊断分类
			s bobj.MKBSDLimitSex=obj.MKBSDLimitSex		/// 限制性别
			s bobj.MKBSDHisRemark=obj.MKBSDHisRemark		///注释
			s bobj.MKBSDAgeFrom=obj.MKBSDAgeFrom		/// 从年龄
			s bobj.MKBSDAgeTo=obj.MKBSDAgeTo		/// 到年龄
			s bobj.MKBSDICD9Code=obj.MKBSDICD9Code		/// icd9代码
			s bobj.MKBSDNationalDesc=obj.MKBSDNationalDesc		///国家标准名称
			s bobj.MKBSDMatchGlobalFlag=obj.MKBSDMatchGlobalFlag	//能否匹配全局化词表
			
			s:eobj.MKBSDLoc="" eobj.MKBSDLoc=obj.MKBSDLoc
			s:eobj.MKBSDFrequency="" eobj.MKBSDFrequency=obj.MKBSDFrequency
			s:eobj.MKBSDStatus="" eobj.MKBSDStatus=obj.MKBSDStatus
			s:eobj.MKBSDCenterWordID="" eobj.MKBSDCenterWordID=obj.MKBSDCenterWordID
		}
		
		
		s obj.MKBSDDiag=eobj.MKBSDDiag		/// 诊断名
		s obj.MKBSDLoc=eobj.MKBSDLoc		/// 科室名
		s obj.MKBSDFrequency=eobj.MKBSDFrequency	/// 诊断出现频次
		s obj.MKBSDStatus=eobj.MKBSDStatus		/// 数据处理状态
		s obj.MKBSDCenterWordID=eobj.MKBSDCenterWordID		/// 参考中心词
		s:eobj.MKBSDDate="" eobj.MKBSDDate=+$h
		s obj.MKBSDDate=eobj.MKBSDDate			/// 操作时间
		s UpdateUserDR=%session.Get("LOGON.USERID")
		s:eobj.MKBSDUpdateUser="" eobj.MKBSDUpdateUser=UpdateUserDR	
		d:eobj.MKBSDUpdateUser'="" obj.MKBSDUpdateUserSetObjectId(eobj.MKBSDUpdateUser)		/// 操作人(从Session中取)
		d:eobj.MKBSDUpdateUser="" obj.MKBSDUpdateUserSetObjectId("")
		
		s obj.MKBSDSegmentation=eobj.MKBSDSegmentation		/// 分词结果
		s:eobj.MKBSDDiaSource'="" obj.MKBSDDiaSource=eobj.MKBSDDiaSource			/// 诊断来源
		d:eobj.MKBSDICDTermDr'="" obj.MKBSDICDTermDrSetObjectId(eobj.MKBSDICDTermDr)	/// MRCDr
		d:eobj.MKBSDICDTermDr="" obj.MKBSDICDTermDrSetObjectId("")
		
		s obj.MKBSDICD=eobj.MKBSDICD			/// ICD编码
		s:((eobj.MKBSDICDDesc="")&&(eobj.MKBSDDiag'="")) eobj.MKBSDICDDesc=eobj.MKBSDDiag
		s obj.MKBSDICDDesc=eobj.MKBSDICDDesc		/// ICD中文描述
		s:eobj.MKBSDTotalFreq'="" obj.MKBSDTotalFreq=eobj.MKBSDTotalFreq		/// 总频次
		s obj.MKBSDChildStructFlag=eobj.MKBSDChildStructFlag		/// 结构化标记
		s obj.MKBSDMergeFlag=eobj.MKBSDMergeFlag		/// 合并标记
		s obj.MKBSDNote=eobj.MKBSDNote		/// 备注
		s obj.MKBSDReson=eobj.MKBSDReson		/// 上报理由
		s:eobj.MKBSDInitialICD'="" obj.MKBSDInitialICD=eobj.MKBSDInitialICD		/// 最优ICD
		s obj.MKBSDDiagPYCode=eobj.MKBSDDiagPYCode		/// 诊断名拼音码
		d:eobj.MKBSDBaseDr'="" obj.MKBSDBaseDrSetObjectId(eobj.MKBSDBaseDr)	/// 工厂指向
		d:eobj.MKBSDBaseDr="" obj.MKBSDBaseDrSetObjectId("")
		
		s obj.MKBSDResultRelation=eobj.MKBSDResultRelation		/// 诊断1 2 3之间的关系 AND OR
		s obj.MKBSDTCMDiagFlag=eobj.MKBSDTCMDiagFlag		/// 中医诊断
		s obj.MKBSDTCMSynFlag=eobj.MKBSDTCMSynFlag		/// 中医证型
		s obj.MKBSDTumourFlag=eobj.MKBSDTumourFlag		/// 肿瘤形态学编码
		s obj.MKBSDInjuryFlag=eobj.MKBSDInjuryFlag		/// 损伤中毒外部原因
		s obj.MKBSDDateActiveFrom=eobj.MKBSDDateActiveFrom		/// 开始日期
		s obj.MKBSDDateActiveTo=eobj.MKBSDDateActiveTo		/// 截止日期
		s obj.MKBSDHisRowID=eobj.MKBSDHisRowID		///  his诊断ID
		s obj.MKBSDHisCode=eobj.MKBSDHisCode		/// HIS诊断代码
		s obj.MKBSDDeputyCode=eobj.MKBSDDeputyCode		/// 副编码 
		s obj.MKBSDClinicType=eobj.MKBSDClinicType		/// 就诊类型 （门诊O。急诊E。住院I。体检H。新生儿N）
		s obj.MKBSDClassification=eobj.MKBSDClassification		/// icd诊断分类
		s obj.MKBSDLimitSex=eobj.MKBSDLimitSex		/// 限制性别
		s obj.MKBSDHisRemark=eobj.MKBSDHisRemark		///注释
		s obj.MKBSDAgeFrom=eobj.MKBSDAgeFrom		/// 从年龄
		s obj.MKBSDAgeTo=eobj.MKBSDAgeTo		/// 到年龄
		s obj.MKBSDICD9Code=eobj.MKBSDICD9Code		/// icd9代码
		s obj.MKBSDNationalDesc=eobj.MKBSDNationalDesc		///国家标准名称
		s:eobj.MKBSDMatchGlobalFlag'="" obj.MKBSDMatchGlobalFlag=eobj.MKBSDMatchGlobalFlag	//能否匹配全局化词表
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s Base=$lg($g(^User.MKBStructuredBaseD(eobj.MKBSDBaseDr)),2)

	    	if (eobj.MKBSDRowid="") //如果是新增,则生成全文索引
	    	{
		    	d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(id)
	    	}
	    	else
	    	{
		    	if ((eobj.MKBSDDiag'=bobj.MKBSDDiag)||(eobj.MKBSDDiagPYCode'=bobj.MKBSDDiagPYCode)||(eobj.MKBSDICD'=bobj.MKBSDICD))  //如果是修改，且是修改的编码或描述，则需要先删除全文索引，再重新生成索引
		    	{
			    	d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndexByCode(id)
			    	d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(id)
		    	}
	    	}
    	
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.MKBSDRowid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData","数据处理工厂-诊断短语",id,Base_"-"_eobj.MKBSDDiag,"A",eobj)
			d:eobj.MKBSDRowid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData","数据处理工厂-诊断短语",id,Base_"-"_eobj.MKBSDDiag,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("数据处理工厂-诊断短语","web.DHCBL.MKB.MKBStructuredData","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s tip = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				
			if (tip["键不唯一")
			{
				s oldid = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",eobj.MKBSDBaseDr," "_$zconvert(eobj.MKBSDDiag,"U"),0))
				s oobj=##class(User.MKBStructuredData).%OpenId(oldid)
				s oobj.MKBSDStatus = "X"
				TS
				s osc=oobj.%Save()
				if $$$ISOK(osc)
				{
					Tc
				}
				else
				{
					tro	
				}
				d oobj.%Close()
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-6-17
/// Description:获取修改时的记录
/// Table: 
/// Input:诊断id
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).OpenData(1)
ClassMethod OpenData(id)
{
	s str=""
	q:id="" ""
	s obj=##class(User.MKBStructuredData).%OpenId(id)
	s bobj = ##class(web.Entity.MKB.MKBStructuredData).%New()
	s bobj.MKBSDRowid=id
	
	s bobj.MKBSDDiag=obj.MKBSDDiag		/// 诊断名
	s bobj.MKBSDLoc=obj.MKBSDLoc		/// 科室名
	s bobj.MKBSDFrequency=obj.MKBSDFrequency	/// 诊断出现频次
	s bobj.MKBSDStatus=obj.MKBSDStatus		/// 数据处理状态
	s bobj.MKBSDCenterWordID=obj.MKBSDCenterWordID		/// 参考中心词
	s bobj.MKBSDDate=obj.MKBSDDate			/// 操作时间
	s:bobj.MKBSDDate'="" bobj.MKBSDDate=$zd(bobj.MKBSDDate,3)
	s:obj.MKBSDUpdateUser'="" bobj.MKBSDUpdateUser = obj.MKBSDUpdateUser.%Id()	/// 操作人(从Session中取)
	
	s bobj.MKBSDSegmentation=obj.MKBSDSegmentation		/// 分词结果
	s bobj.MKBSDDiaSource=obj.MKBSDDiaSource			/// 诊断来源
	s:obj.MKBSDICDTermDr'="" bobj.MKBSDICDTermDr = obj.MKBSDICDTermDr.%Id()	/// MRCDr
	
	s bobj.MKBSDICD=obj.MKBSDICD			/// ICD编码
	s bobj.MKBSDICDDesc=obj.MKBSDICDDesc		/// ICD中文描述
	s bobj.MKBSDTotalFreq=obj.MKBSDTotalFreq		/// 总频次
	s bobj.MKBSDChildStructFlag=obj.MKBSDChildStructFlag		/// 结构化标记
	s bobj.MKBSDMergeFlag=obj.MKBSDMergeFlag		/// 合并标记
	s bobj.MKBSDNote=obj.MKBSDNote		/// 备注
	s bobj.MKBSDReson=obj.MKBSDReson		/// 上报理由
	s bobj.MKBSDInitialICD=obj.MKBSDInitialICD		/// 最优ICD
	s bobj.MKBSDDiagPYCode=obj.MKBSDDiagPYCode		/// 诊断名拼音码
	s:obj.MKBSDBaseDr'="" bobj.MKBSDBaseDr = obj.MKBSDBaseDr.%Id()	/// 工厂指向

	s bobj.MKBSDResultRelation=obj.MKBSDResultRelation		/// 诊断1 2 3之间的关系 AND OR
	s bobj.MKBSDTCMDiagFlag=obj.MKBSDTCMDiagFlag		/// 中医诊断
	s bobj.MKBSDTCMSynFlag=obj.MKBSDTCMSynFlag		/// 中医证型
	s bobj.MKBSDTumourFlag=obj.MKBSDTumourFlag		/// 肿瘤形态学编码
	s bobj.MKBSDInjuryFlag=obj.MKBSDInjuryFlag		/// 损伤中毒外部原因
	s bobj.MKBSDDateActiveFrom=obj.MKBSDDateActiveFrom		/// 开始日期
	s:bobj.MKBSDDateActiveFrom'="" bobj.MKBSDDateActiveFrom=$zd(bobj.MKBSDDateActiveFrom,3)
	s bobj.MKBSDDateActiveTo=obj.MKBSDDateActiveTo		/// 截止日期
	s:bobj.MKBSDDateActiveTo'="" bobj.MKBSDDateActiveTo=$zd(bobj.MKBSDDateActiveTo,3)
	s bobj.MKBSDHisRowID=obj.MKBSDHisRowID		///  his诊断ID
	s bobj.MKBSDHisCode=obj.MKBSDHisCode		/// HIS诊断代码
	s bobj.MKBSDDeputyCode=obj.MKBSDDeputyCode		/// 副编码 
	s bobj.MKBSDClinicType=obj.MKBSDClinicType		/// 就诊类型 （门诊O。急诊E。住院I。体检H。新生儿N）
	s bobj.MKBSDClassification=obj.MKBSDClassification		/// icd诊断分类
	s bobj.MKBSDLimitSex=obj.MKBSDLimitSex		/// 限制性别
	s bobj.MKBSDHisRemark=obj.MKBSDHisRemark		///注释
	s bobj.MKBSDAgeFrom=obj.MKBSDAgeFrom		/// 从年龄
	s bobj.MKBSDAgeTo=obj.MKBSDAgeTo		/// 到年龄
	s bobj.MKBSDICD9Code=obj.MKBSDICD9Code		/// icd9代码
	s bobj.MKBSDNationalDesc=obj.MKBSDNationalDesc		///国家标准名称
	s bobj.MKBSDMatchGlobalFlag=obj.MKBSDMatchGlobalFlag	//能否匹配全局化词表
	s str = bobj.JsonS()
	d bobj.%Close()
	
	q str
}

/// Creator:石萧伟
/// CreatDate:2019-04-18
/// Description:新增主表数据(上报)
/// Table: 
/// Input:MKBSDDiag 诊断名 state状态  pycode拼音码 termid术语id 备注 ICD编码 开始日期  结束日期 中医诊断 中医证型 肿瘤形态学编码 损伤中毒外部原因
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).SaveParDia("疼痛","X","","")
ClassMethod SaveParDia(savestr) As %String
{
	//basedr, MKBSDDiag, state, pycode, termid, note, ICD, DateActiveFrom, DateActiveTo, TCMDiagFlag, TCMSynFlag, TumourFlag, InjuryFlag
	q:savestr="" "{success:'false',errorinfo:'数据为空'}"
	s basedr=$p(savestr,"^",1)
	s MKBSDDiag=$p(savestr,"^",2)
	s state=$p(savestr,"^",3)
	s pycode=$p(savestr,"^",4)
	s termid=$p(savestr,"^",5)
	s note=$p(savestr,"^",6)
	s ICD=$p(savestr,"^",7)
	s DateActiveFrom=$p(savestr,"^",8)
	s DateActiveTo=$p(savestr,"^",9)
	s TCMDiagFlag=$p(savestr,"^",10)
	s TCMSynFlag=$p(savestr,"^",11)
	s TumourFlag=$p(savestr,"^",12)
	s InjuryFlag=$p(savestr,"^",13)
	s MKBSDHisRowID=$p(savestr,"^",14)	
	s MKBSDHisCode=$p(savestr,"^",15)
	s MKBSDDeputyCode=$p(savestr,"^",16)
	s MKBSDClinicType=$p(savestr,"^",17)
	s MKBSDClassification=$p(savestr,"^",18)
	s MKBSDLimitSex=$p(savestr,"^",19)
	s MKBSDHisRemark=$p(savestr,"^",20)
	s MKBSDAgeFrom=$p(savestr,"^",21)
	s MKBSDAgeTo=$p(savestr,"^",22)
	s MKBSDICD9Code=$p(savestr,"^",23)
	s MKBSDNationalDesc=$p(savestr,"^",24)

	
	s bobj = ##class(web.Entity.MKB.MKBStructuredData).%New()
	s bobj.MKBSDRowid=""
	
	s bobj.MKBSDDiag=MKBSDDiag		/// 诊断名
	s bobj.MKBSDStatus=state		/// 数据处理状态
	s bobj.MKBSDDate=+$h			/// 操作时间
	s bobj.MKBSDUpdateUser = %session.Get("LOGON.USERID")	/// 操作人(从Session中取)
	
	s bobj.MKBSDICDTermDr =termid	/// MRCDr
	
	s bobj.MKBSDICD=ICD			/// ICD编码
	s bobj.MKBSDICDDesc=MKBSDDiag		/// ICD中文描述
	s bobj.MKBSDTotalFreq=0		/// 总频次
	s bobj.MKBSDNote=note		/// 备注
	s bobj.MKBSDDiagPYCode=pycode		/// 诊断名拼音码
	s bobj.MKBSDBaseDr = basedr	/// 工厂指向

	s bobj.MKBSDTCMDiagFlag=TCMDiagFlag		/// 中医诊断
	s bobj.MKBSDTCMSynFlag=TCMSynFlag		/// 中医证型
	s bobj.MKBSDTumourFlag=TumourFlag		/// 肿瘤形态学编码
	s bobj.MKBSDInjuryFlag=InjuryFlag		/// 损伤中毒外部原因
	s bobj.MKBSDDateActiveFrom=DateActiveFrom		/// 开始日期
	s bobj.MKBSDDateActiveTo=DateActiveTo		/// 截止日期
	s bobj.MKBSDHisRowID=MKBSDHisRowID		///  his诊断ID
	s bobj.MKBSDHisCode=MKBSDICDDesc		/// HIS诊断代码
	s bobj.MKBSDDeputyCode=MKBSDDeputyCode		/// 副编码 
	s bobj.MKBSDClinicType=MKBSDClinicType		/// 就诊类型 （门诊O。急诊E。住院I。体检H。新生儿N）
	s bobj.MKBSDClassification=MKBSDClassification		/// icd诊断分类
	s bobj.MKBSDLimitSex=MKBSDLimitSex		/// 限制性别
	s bobj.MKBSDHisRemark=MKBSDHisRemark		///注释
	s bobj.MKBSDAgeFrom=MKBSDAgeFrom		/// 从年龄
	s bobj.MKBSDAgeTo=MKBSDAgeTo		/// 到年龄
	s bobj.MKBSDICD9Code=MKBSDICD9Code		/// icd9代码
	s bobj.MKBSDNationalDesc=MKBSDNationalDesc		///国家标准名称
	
	
	s flag=..FormValidateDiagICD("",MKBSDHisRowID,basedr)  //重复校验
	q:flag=1 "{success:'false',errorinfo:'该诊断已经存在'}"
	s:DateActiveFrom'="" DateActiveFrom=$zdh(DateActiveFrom,15)
	s:DateActiveTo'="" DateActiveTo=$zdh(DateActiveTo,15)
	s obj=##class(User.MKBStructuredData).%New()
	s eobj=##class(web.Entity.MKB.MKBStructuredData).%New()   
	s eobj.MKBSDDiag=MKBSDDiag
	s eobj.MKBSDStatus=state
	s eobj.MKBSDDiagPYCode=pycode
	s eobj.MKBSDTotalFreq=0
	s eobj.MKBSDNote=note
	s eobj.MKBSDBaseDr=basedr
	s eobj.MKBSDICDDesc=MKBSDDiag
	s eobj.MKBSDICD=ICD
	s eobj.MKBSDDateActiveFrom=DateActiveFrom
	s eobj.MKBSDDateActiveTo=DateActiveTo
	s eobj.MKBSDTCMDiagFlag=TCMDiagFlag
	s eobj.MKBSDTCMSynFlag=TCMSynFlag
	s eobj.MKBSDTumourFlag=TumourFlag
	s eobj.MKBSDInjuryFlag=InjuryFlag
	
	s obj.MKBSDDiag=MKBSDDiag
	s obj.MKBSDDiagPYCode=pycode
	s obj.MKBSDTotalFreq=0
	Set UpdateDate=$p($h,",",1)       //上传日期
	Set UpdateUserDR=%session.Get("LOGON.USERID")
	d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
	s obj.MKBSDDate=UpdateDate	
	s obj.MKBSDStatus=state
	s obj.MKBSDNote=note
	d obj.MKBSDBaseDrSetObjectId(basedr)
	if (state = "X")
	{
		s obj.MKBSDReson="A" //上报默认为缺诊断短语
	}
	s obj.MKBSDICDDesc=MKBSDDiag
	s obj.MKBSDICD=ICD
	s obj.MKBSDDateActiveFrom=DateActiveFrom
	s obj.MKBSDDateActiveTo=DateActiveTo
	s obj.MKBSDTCMDiagFlag=TCMDiagFlag
	s obj.MKBSDTCMSynFlag=TCMSynFlag
	s obj.MKBSDTumourFlag=TumourFlag
	s obj.MKBSDInjuryFlag=InjuryFlag
	Ts
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		if (termid'="")
		{	
			d ..SaveData(id,"","","",termid,"")
		}
		//s PINYINDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
		d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(id)
		
		//d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(pycode,id)
		//d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(MKBSDDiag,id)
		set result = "{success:'true',id:'"_id_"'}"
		s Base=$lg($g(^User.MKBStructuredBaseD(basedr)),2)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData","数据处理工厂-诊断短语",id,Base_"-"_MKBSDDiag,"A",eobj)
	}
	else
	{

		s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
		s tip = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				
		Tro	
		if (tip["键不唯一")
		{
			s oldid = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr," "_MKBSDDiag,0))
			s oobj=##class(User.MKBStructuredData).%OpenId(oldid)
			s oobj.MKBSDStatus = "X"
			TS
			s osc=oobj.%Save()
			if $$$ISOK(osc)
			{
				Tc
			}
			
		}
	}
	d eobj.%Close()
	d obj.%Close()
	quit result
}

/// Creator:石萧伟
/// CreatDate:2018-11-27
/// Description:上报理由维护
/// Table: 
/// Input:rowid  MKBSDNote备注 MKBSDReson上报理由 structuredataids诊断表达式id串（termid-属性ids）
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).SaveParNote(959,"1","A","15292-70583:S129230")
ClassMethod SaveParNote(rowid As %String, MKBSDNote As %String, MKBSDReson As %String, structuredataids As %String) As %String
{
	s:MKBSDNote'="" MKBSDNote = ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBSDNote)
	s:MKBSDNote'="" MKBSDNote = $zstrip(MKBSDNote,"<>W")	
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)        ;先备份再更新
		s bobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s:MKBSDNote'="" bobj.MKBSDNote=obj.MKBSDNote
		s:MKBSDReson'="" bobj.MKBSDReson=obj.MKBSDReson
		s bobj.MKBSDStatus=obj.MKBSDStatus
		
		s eobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s:MKBSDNote'="" eobj.MKBSDNote=MKBSDNote
		s:MKBSDReson'="" eobj.MKBSDReson=MKBSDReson
		s eobj.MKBSDStatus=obj.MKBSDStatus
		
		s Diag=obj.MKBSDDiag
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=1 //%session.Get("LOGON.USERID")   //上传人
		d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBSDDate=UpdateDate
		s obj.MKBSDNote=MKBSDNote
		s obj.MKBSDReson=MKBSDReson
		s obj.MKBSDStatus="X"
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			if (structuredataids'="")
			{
				s sameflag="N"
				s termid = $p(structuredataids,"-",1)
				s structuredata = $p(structuredataids,"-",2)
				s StructDesc=..StdGetChiForNewSeqStrucIDs(structuredata,termid)
				s MKBSDRRowid=0
				for
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termid,rowid,MKBSDRRowid))
					q:MKBSDRRowid=""
					s MKBSDRResultId=$lg($g(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",MKBSDRRowid)),2)
					s MKBSDRRTermId=$lg($g(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",MKBSDRRowid)),4)
					s MKBSDRRDesc=..StdGetChiForNewSeqStrucIDs(MKBSDRResultId,MKBSDRRTermId)
					if StructDesc=MKBSDRRDesc
					{
						s sameflag = "Y"
					}
				}
				if (sameflag="N")
				{
					d ..SaveData(id,"",structuredata,"",termid,"")
				}	
			}
			set result = "{success:'true',id:'"_id_"'}" 
			s basedr = $lg($g(^User.MKBStructuredDataD(id)),22)
			s Base=$lg($g(^User.MKBStructuredBaseD(basedr)),2)			
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData",Base_"-上报理由",id,Diag,"U",eobj,bobj)
			d bobj.%Close()
			d eobj.%Close()
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

/// Creator:石萧伟
/// CreatDate:2019-05-08
/// Description:最优icd维护
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).InitialICDUpdate()
ClassMethod InitialICDUpdate(rowid As %String, MKBSDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)        ;先备份再更新
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
    	
		d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBSDDate=UpdateDate
		s obj.MKBSDInitialICD=MKBSDInitialICD
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

/// Creator:李欣
/// CreatDate:2019-05-05
/// Description：获取结构化数据相同的父表字段初始icd是否标志为Y
/// Input：id 父表id 
/// Return：1 有Y值  0 无Y值
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).findInitialICD(12864)
ClassMethod findInitialICD(id As %String)
{
	s PresentBase=$lg($g(^User.MKBStructuredDataD(id)),22)  //当前所属base
	s MKBSDChild=0
	s seq=-1
	s seq=$O(^User.MKBStructuredDataResultI("SeqIndex",id,seq))
	q:seq="" ""
	s MKBSDChild=$O(^User.MKBStructuredDataResultI("SeqIndex",id,seq,MKBSDChild))
	q:MKBSDChild="" ""	
	
	s TermId=$LG($G(^User.MKBStructuredDataD(id,"MKBSDStructResult",MKBSDChild)),4)
	s ResultId=$LG($G(^User.MKBStructuredDataD(id,"MKBSDStructResult",MKBSDChild)),2)
	s:ResultId="" ResultId=-100000000000000
	k sort
	k arr
	s sort(TermId,ResultId)=""
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataResultI("SortIndex",TermId,ResultId,MKBSDRowId))
		q:MKBSDRowId=""
		s base=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),22)
		continue:PresentBase'=base
		s Child=0
		for
		{
			s Child=$O(^User.MKBStructuredDataResultI("SortIndex",TermId,ResultId,MKBSDRowId,Child))
			q:Child=""
			s tseq=-1
			s tseq=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,tseq))
			s tMKBSDChild=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,tseq,0))
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
		
	
		s InitFlag=$LG($G(^User.MKBStructuredDataD(parid)),18)
		if (InitFlag="Y")
		{
			s result=$LG($G(^User.MKBStructuredDataD(parid)),2)
			s result = result_"*"_parid
		}	
	}
	q result
}

/// Creator:李得原
/// CreatDate:2019-05-13
/// Description：结构化结果ID串按照诊断模板顺序输出
/// Table：User.MKBStructuredDataResult
/// Input：子表id 
/// Return：
/// Other: /// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForSeqStrucIDs()
ClassMethod GetChiForSeqStrucIDs(ids, termdr)
{
	s result=""
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termdr)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s result=$p(strCom,"&%",1) //诊断常用名
	if result=""
	{
		s result=$lg($g(^User.MKBTermD(termdr)),3)
	}
	//获取诊断模板id
	s DiagTemplateDr=$o(^User.MKBTermPropertyI("FlagIndex",termdr," DT",0))
	q:DiagTemplateDr="" ""
	s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",DiagTemplateDr,0))
	q:MKBTPDRowid="" ""
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
						}
						elseif $d(Sequence(seq,Pro))=1
						{
							d GetDesc
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
								}
							}
						}
					}
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

/// Creator:李得原
/// CreatDate:2019-05-16
/// Description：封闭了的引用术语标红，结构化结果ID串按照诊断模板顺序输出，如果诊断模板中已经删除属性，但结构化串中还有，也要显示
/// Table：User.MKBStructuredDataResult
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs("9885:2814284,68644:S525510","15243")
ClassMethod GetChiForNewSeqStrucIDs(ids, termdr)
{
	s result=""
	q:termdr="" ""
	if '$d(^User.MKBTermD(termdr))
	{
		q ""
	}
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
		q:DiagTemplateDr="" ""
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",DiagTemplateDr,0))
		
		q:MKBTPDRowid="" result
		if '$d(^User.MKBTermProDetailD(MKBTPDRowid))
		{
			q result	
		}
		
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
							elseif $d(Sequence(seq,Pro))
							{
								if $d(Sequence(seq,Pro))=1
								{
									d GetDesc
									s tempK(Pro)=""
									s tempV(val)=""
								}
								else
								{
									s SMark=0
									for
									{
										s SMark=$o(Sequence(seq,Pro,SMark))
										q:SMark=""
										if $d(Details(seq,Pro,SMark,val))
										{
											if ('$d(tempV(val)))&('$d(tempK(Pro)))
											{
												d GetDesc
												s tempK(Pro)=""
												s tempV(val)=""
											}
										}
									}
								}

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
					continue:'$d(^User.MKBTermPropertyD(key))
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
	;2020-1-6新增
	s ActiveFlag=$lg($g(^User.MKBTermD(termdr)),9)
	s:ActiveFlag="N" result="<font color=red>"_result_"</font>"
	
	q result 
    
GetDesc             //串转描述
	if values["S"
	{
		s values=$tr(values,"S","")
		s ValueDr=$p(values,":",2)
		s Value=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(ValueDr)
		s ActiveFlag=$lg($g(^User.MKBTermD(ValueDr)),9)
		;s Value=$lg($g(^User.MKBTermD(ValueDr)),3)
		
		if ValueString'=""
		{
			s ValueString=ValueString_","_Value
		}
		if ValueString=""
		{
			s ValueString=Value
		}	
		if ActiveFlag="N"
		{
			s ValueString="<font color=red>"_ValueString_"</font>"
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

/// Creator:李得原
/// CreatDate:2019-06-27
/// Description：Std为不带颜色的标准输出，结构化结果ID串按照诊断模板顺序输出，如果诊断模板中已经删除属性，但结构化串中还有，也要显示
/// Table：User.MKBStructuredDataResult
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs("ICD526477","15879-18158:38125,18159:38129")
ClassMethod StdGetChiForNewSeqStrucIDs(ids, termdr)
{
	s result=""
	q:termdr="" ""
	if '$d(^User.MKBTermD(termdr))
	{
		q ""
	}
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
		q:DiagTemplateDr="" ""
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",DiagTemplateDr,0))
		
		q:MKBTPDRowid="" result
		if '$d(^User.MKBTermProDetailD(MKBTPDRowid))
		{
			q result	
		}
		
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
							elseif $d(Sequence(seq,Pro))
							{
								if $d(Sequence(seq,Pro))=1
								{
									d GetDesc
									s tempK(Pro)=""
									s tempV(val)=""
								}
								else
								{
									s SMark=0
									for
									{
										s SMark=$o(Sequence(seq,Pro,SMark))
										q:SMark=""
										if $d(Details(seq,Pro,SMark,val))
										{
											if ('$d(tempV(val)))&('$d(tempK(Pro)))
											{
												d GetDesc
												s tempK(Pro)=""
												s tempV(val)=""
											}
										}
									}
								}

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
					continue:'$d(^User.MKBTermPropertyD(key))
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
		s Value=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(ValueDr)
		s ActiveFlag=$lg($g(^User.MKBTermD(ValueDr)),9)
		;s Value=$lg($g(^User.MKBTermD(ValueDr)),3)
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
/// CreatDate:2019-05-14
/// Description:修改主表数据的诊断名
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).UpdateParDia("342349","糖尿病2","","","C852","","","","","","")
ClassMethod UpdateParDia(rowid, MKBSDDiag, pycode, note, ICD, DateActiveFrom, DateActiveTo, TCMDiagFlag, TCMSynFlag, TumourFlag, InjuryFlag) As %String
{
	s:MKBSDDiag'="" MKBSDDiag = ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBSDDiag)
	s:MKBSDDiag'="" MKBSDDiag = $zstrip(MKBSDDiag,"<>W")
	s:note'="" note = ##class(web.DHCBL.BDP.FunLib).EvalJSON(note)
	s:note'="" note = $zstrip(note,"<>W")
	s:ICD'="" ICD = ##class(web.DHCBL.BDP.FunLib).EvalJSON(ICD)
	s:ICD'="" ICD = $zstrip(ICD,"<>W")
	s:DateActiveFrom'="" DateActiveFrom=$zdh(DateActiveFrom,15)
	s:DateActiveTo'="" DateActiveTo=$zdh(DateActiveTo,15)
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)        ;先备份再更新
		
		s BaseDr=$lg($g(^User.MKBStructuredDataD(rowid)),22)
		s flag=..FormValidateDiagICD(rowid,MKBSDDiag,ICD,BaseDr)  //重复校验
		q:flag=1 "{success:'false',errorinfo:'该诊断已经存在'}"
		
		s bobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s:MKBSDDiag'="" bobj.MKBSDDiag=obj.MKBSDDiag
		s:ICD'="" bobj.MKBSDICD=obj.MKBSDICD
		s:pycode'="" bobj.MKBSDDiagPYCode=obj.MKBSDDiagPYCode
		s:rowid'="" bobj.MKBSDRowid=rowid
		s:note'="" bobj.MKBSDNote=obj.MKBSDNote
		s:DateActiveFrom'="" bobj.MKBSDDateActiveFrom=obj.MKBSDDateActiveFrom
		s:DateActiveTo'="" bobj.MKBSDDateActiveTo=obj.MKBSDDateActiveTo
		s:TCMDiagFlag'="" bobj.MKBSDTCMDiagFlag=obj.MKBSDTCMDiagFlag
		s:TCMSynFlag'="" bobj.MKBSDTCMSynFlag=obj.MKBSDTCMSynFlag
		s:TumourFlag'="" bobj.MKBSDTumourFlag=obj.MKBSDTumourFlag
		s:InjuryFlag'="" bobj.MKBSDInjuryFlag=obj.MKBSDInjuryFlag
		
		s eobj=##class(web.Entity.MKB.MKBStructuredData).%New()
		s:MKBSDDiag'="" eobj.MKBSDDiag=MKBSDDiag
		s:ICD'="" eobj.MKBSDICD=ICD
		s:pycode'="" eobj.MKBSDDiagPYCode=pycode
		s:rowid'="" eobj.MKBSDRowid=rowid
		s:note'="" eobj.MKBSDNote=note
		s:DateActiveFrom'="" eobj.MKBSDDateActiveFrom=DateActiveFrom
		s:DateActiveTo'="" eobj.MKBSDDateActiveTo=DateActiveTo
		s:TCMDiagFlag'="" eobj.MKBSDTCMDiagFlag=TCMDiagFlag
		s:TCMSynFlag'="" eobj.MKBSDTCMSynFlag=TCMSynFlag
		s:TumourFlag'="" eobj.MKBSDTumourFlag=TumourFlag
		s:InjuryFlag'="" eobj.MKBSDInjuryFlag=InjuryFlag
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
    	;Set UpdateUserDR=1
		d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBSDDate=UpdateDate
		s obj.MKBSDDiag=MKBSDDiag
		s obj.MKBSDICD=ICD
		s obj.MKBSDDiagPYCode=pycode
		s obj.MKBSDNote=note
		s obj.MKBSDDateActiveFrom=DateActiveFrom
		s obj.MKBSDDateActiveTo=DateActiveTo
		s obj.MKBSDTCMDiagFlag=TCMDiagFlag
		s obj.MKBSDTCMSynFlag=TCMSynFlag
		s obj.MKBSDTumourFlag=TumourFlag
		s obj.MKBSDInjuryFlag=InjuryFlag
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			//删除诊断名全文索引
			//添加新的诊断名全文索引
			if (bobj.MKBSDDiag'=MKBSDDiag)
			{
				d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(BaseDr,bobj.MKBSDDiag,rowid)
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(BaseDr,MKBSDDiag,rowid)
			}
			if (bobj.MKBSDDiagPYCode'=pycode)
			{
				d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(BaseDr,bobj.MKBSDDiagPYCode,rowid)
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(BaseDr,pycode,rowid)
			}
			
			//s PINYINDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(bobj.MKBSDDiag)
			
			
			//s PINYINNewDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
			
			
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredData","User.MKBStructuredData","数据处理工厂-诊断短语",id,MKBSDDiag,"U",eobj,bobj)
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		d bobj.%Close()
		d eobj.%Close()
		d obj.%Close()
		quit result			
	}
}

/// Creator:石萧伟
/// CreatDate:2018-12-20
/// Description:判断诊断学id是否存在
/// Table:
/// Input:
/// Return:有则返回1，没有返回“”
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredData).justIdExist(119,26484)
ClassMethod justIdExist(id)
{
	q:id="" ""
	s flag = ""
	if ($d(^User.MKBTermD(id)))
	{
		s flag = 1
	}
	
	q flag
}

/// Creator：石萧伟
/// CreatDate: 2019-05-17
/// Description：修改ICD时打开的数据
/// Table：User.MRCICDDx
/// input: id(ICD诊断的rowid)
/// Ruturn： Json字符串
/// w ##class(web.DHCBL.MKB.MKBStructuredData).OpenData(1)
ClassMethod OpenICDData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.CT.MRCICDDx).%New()
	s eobj.MRCIDRowId = id
	s eobj.MRCIDCode=$p($g(^MRC("ID",id)),"^",1)
	s eobj.MRCIDDesc=$p($g(^MRC("ID",id)),"^",2)
	s eobj.MRCIDICD9CMCode=$p($g(^MRC("ID",id)),"^",4)
	s eobj.MRCIDDateActiveFrom=$p($g(^MRC("ID",id)),"^",6)
	s eobj.MRCIDDateActiveTo=$p($g(^MRC("ID",id)),"^",7)
	s eobj.MRCIDAgeFrom=$p($g(^MRC("ID",id)),"^",8)
	s eobj.MRCIDAgeTo=$p($g(^MRC("ID",id)),"^",9)
	s eobj.MRCIDSexDR=$p($g(^MRC("ID",id)),"^",10)
	s eobj.MRCIDValid=$p($g(^MRC("ID",id)),"^",27)
	s eobj.MRCIDICD9Map=$p($g(^MRC("ID",id)),"^",35)
	s eobj.MRCIDLongDescription=$p($g(^MRC("ID",id)),"^",36)
	s eobj.MRCIDMetastaticSite=$p($g(^MRC("ID",id)),"^",40) //肿瘤形态学编码标志
	s eobj.MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",id)),"^",41) //损伤中毒外部原因标志
	s eobj.MRCIDBillFlag3=$p($g(^MRC("ID",id)),"^",15) //中医诊断标志
	s eobj.MRCIDBillFlag1=$p($g(^MRC("ID",id)),"^",13) //中医标志证型
	s eobj.MRCID2ndCodeInPair=$p($g(^MRC("ID",id)),"^",43)
	
	s eobj.MRCIDDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveFrom)
	s eobj.MRCIDDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveTo)
	s eobj.MRCIDCode=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDCode)
	s eobj.MRCIDDesc=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDDesc)
	s eobj.MRCIDICD9CMCode =##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDICD9CMCode)
	s eobj.MRCIDICD9Map=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDICD9Map)
	s eobj.MRCIDLongDescription =##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDLongDescription)
	set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.MRCICDDx||MRCIDTypeDR",0)
	i $IsObject(PropObj)
	{
		s eobj.MRCIDTypeDR=$p($g(^MRC("ID",id)),"^",46)
	}
	s str = eobj.JsonS()	
	q str
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
		s obj=##class(User.MKBStructuredDataResult).%OpenId(rowid)
		s obj.MKBSDSequence=i
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

/// Creator:李欣
/// CreatDate:2019-05-24
/// Description：合并其他描述
ClassMethod SaveCopyOther(fromid, toid)
{
	s OtherChild=0
	for
	{
		s OtherChild=$O(^User.MKBStructuredDataD(fromid,"MKBSDStructOther",OtherChild))
		q:OtherChild=""
		
		s bobj = ##class(User.MKBStructuredDataOther).%OpenId(fromid_"||"_OtherChild)
		s obj = ##class(User.MKBStructuredDataOther).%New(toid)
		s obj.MKBSDOtherCode = bobj.MKBSDOtherCode
		s obj.MKBSDOtherMark = bobj.MKBSDOtherMark
		s obj.MKBSDOtherNote = bobj.MKBSDOtherNote
		s obj.MKBSDOther = bobj.MKBSDOther
		d obj.MKBSDStructDataSetObjectId(toid)
		s sc = obj.%Save()
			
	}
	q 1
}

/// Creator:李得原
/// CreatDate:2019-06-19
/// Description：根据诊断短语或拼音  获取描述和rowid
/// Table：
/// Input：Desc
/// Return：Desc rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetDataForDiaCmb","tnb")
Query GetDataForDiaCmb(q As %String) As %Query(ROWSPEC = "MKBSDRowid,MKBSDDiag")
{
}

ClassMethod GetDataForDiaCmbExecute(ByRef qHandle As %Binary, q As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s Diag=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(q)
		
	if (Diag'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(Diag,"U"),MKBSDRowid))
			q:MKBSDRowid=""
			continue:MKBSDRowid["ICD"
			continue:MKBSDRowid["L"
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			d getCTTitle
		}
		
	}
	else
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			d getCTTitle
		}
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(MKBSDRowid,MKBSDDiag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataForDiaCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForDiaCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDataForDiaCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForDiaCmbExecute ]
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
/// CreatDate:2019-06-19
/// Description：根据id串获取结构化诊断的信息
ClassMethod GetReviewedData(termid, ids) As %String
{

	s result=""
	s SDSTermDR=termid    //$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),4) //诊断id
	s PropertyDR=..GetPropertyIdByFlag(SDSTermDR,"DT")
	d ..GetShowType(PropertyDR)
	
	s SDSValue=ids   //$lg(^User.MKBStructuredDataD(parentid,"MKBSDStructResult",rowid),2)   
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

/// 已传入id为模板，批处理相同中心词TNM分期
/// w ##class(web.DHCBL.MKB.MKBStructuredData).DealTNM(53086)
ClassMethod DealTNM(id)
{

	s result="{success:'true'}"
	s GeneralTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 通用描述",0))
	s DiagALL = $LG($G(^User.MKBStructuredDataD(id)),2)
	if ((DiagALL'["T")||(DiagALL'["N")||(DiagALL'["M"))
	{
		s result = 	"{success:'false',errorinfo:'选中数据不包含TNM'}"
		q result	
	}
	s DiagTNM = $P(DiagALL,"（",2)
	if DiagTNM["Tis"
	{
		s start=$F(DiagTNM,"T")-1
		s end = start + 7
		s DiagTNM=$E(DiagTNM,start,end)
		s TDesc = $E(DiagTNM,1,3)	
		s NDesc = $E(DiagTNM,4,5)
		s MDesc = $E(DiagTNM,6,7)
		
	}
	else
	{
		s start=$F(DiagTNM,"T")-1
		s end = start + 6
		s DiagTNM=$E(DiagTNM,start,end)	
		s TDesc = $E(DiagTNM,1,2)
		s NDesc = $E(DiagTNM,3,4)
		s MDesc = $E(DiagTNM,5,6)	
	}
	
	s TRowId="S"_$O(^User.MKBTermI("DescIndex",GeneralTBRowId," "_$ZCONVERT(TDesc,"U"),0))
	s NRowId="S"_$O(^User.MKBTermI("DescIndex",GeneralTBRowId," "_$ZCONVERT(NDesc,"U"),0))
	s MRowId="S"_$O(^User.MKBTermI("DescIndex",GeneralTBRowId," "_$ZCONVERT(MDesc,"U"),0))
	s sortindex=$O(^User.MKBStructuredDataResultI("SeqIndex",id,0))
	if (sortindex="")
	{
		s result = 	"{success:'false',errorinfo:'未给定参考中心词'}"
		q result	
	}
	s Child=$O(^User.MKBStructuredDataResultI("SeqIndex",id,sortindex,0))
	s ModuleExpId = $LG($G(^User.MKBStructuredDataD(id,"MKBSDStructResult",Child)),2)
	
	s ModuleTermDR = $LG($G(^User.MKBStructuredDataD(id,"MKBSDStructResult",Child)),4)	
	s ModuleICDDr = $LG($G(^User.MKBStructuredDataD(id)),11)	
	s ModuleICDCode = $LG($G(^User.MKBStructuredDataD(id)),20)
	s ModuleICDDesc = $LG($G(^User.MKBStructuredDataD(id)),21)
	s TNMTPRowId=$O(^User.MKBTermPropertyI("DescIndex",ModuleTermDR," 肿瘤TNM分期",0))
	if (TNMTPRowId="")
	{
		s result = 	"{success:'false',errorinfo:'不存在属性-肿瘤TNM分期'}"
		q result
	}
	
	if (ModuleExpId'[TNMTPRowId) ///第一条未结构化TNM
	{
		
		if (ModuleExpId'="")
		{
			s NewExpId=ModuleExpId_","_TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId
			s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(id,id_"||"_Child,NewExpId,"",ModuleTermDR,"")		
		}
		else
		{
			s NewExpId=TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId
			s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(id,id_"||"_Child,NewExpId,"",ModuleTermDR,"")		
		}
	}
	else
	{
		s ModuleExpId=$REPLACE($REPLACE(ModuleExpId,","_TNMTPRowId_":",""),TNMTPRowId_":","")
		s ModuleExpId=$REPLACE($REPLACE($REPLACE(ModuleExpId,"*"_TRowId_",",""),"*"_TRowId,""),TRowId,"")
		s ModuleExpId=$REPLACE($REPLACE($REPLACE(ModuleExpId,"*"_NRowId_",",""),"*"_NRowId,""),NRowId,"")
		s ModuleExpId=$REPLACE($REPLACE($REPLACE(ModuleExpId,"*"_MRowId_",",""),"*"_MRowId,""),MRowId,"")	
	}
	
			
		
	s Diag = $P(DiagALL,"（",1)
	s tDiag = $E(Diag,1,10)
	s TNMFlag=0
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(tDiag,"U"),MKBSDRowId))
		q:MKBSDRowId=""
					
		continue:MKBSDRowId["L"
		continue:MKBSDRowId["ICD"
		continue:MKBSDRowId=id
		
		s MKBSDDiag = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		continue:((MKBSDDiag'["（")||(MKBSDDiag'["T")||(MKBSDDiag'["N")||(MKBSDDiag'["M"))
		s MKBSDDiagCenter = $P(MKBSDDiag,"（",1)
		continue:MKBSDDiagCenter'=Diag
		s tDiagTNM = $P(MKBSDDiag,"（",2)
		if tDiagTNM["Tis"
		{
			s start=$F(tDiagTNM,"T")-1
			s end = start + 7
			s DiagTNM=$E(tDiagTNM,start,end)
			s TDesc = $E(tDiagTNM,1,3)	
			s NDesc = $E(tDiagTNM,4,5)
			s MDesc = $E(tDiagTNM,6,7)
			
		}
		else
		{
			s start=$F(tDiagTNM,"T")-1
			s end = start + 6
			s tDiagTNM=$E(tDiagTNM,start,end)	
			s TDesc = $E(tDiagTNM,1,2)
			s NDesc = $E(tDiagTNM,3,4)
			s MDesc = $E(tDiagTNM,5,6)	
		}

		s TRowId="S"_$O(^User.MKBTermI("DescIndex",GeneralTBRowId," "_$ZCONVERT(TDesc,"U"),0))
		s NRowId="S"_$O(^User.MKBTermI("DescIndex",GeneralTBRowId," "_$ZCONVERT(NDesc,"U"),0))
		s MRowId="S"_$O(^User.MKBTermI("DescIndex",GeneralTBRowId," "_$ZCONVERT(MDesc,"U"),0))
		if ((TRowId="S")||(NRowId="S")||(MRowId="S"))
		{
			s TNMFlag="{success:'false',errorinfo:'"_MKBSDDiag_"中TNM数据不存在肿瘤TNM分期之中'}"
			continue	
		}
		///匹配ICD
		s ICDDr = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),11)
		if (ICDDr="")
		{
			s pobj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			d pobj.MKBSDICDTermDrSetObjectId(ModuleICDDr)
			s pobj.MKBSDICD = ModuleICDCode
			s pobj.MKBSDICDDesc = ModuleICDDesc
			d pobj.%Save()	
		}
		///自动结构化
		s tindex=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,0))
		
		if (tindex'="") //已经存在结构化数据
		{
			s MKBSDRChild=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowId,tindex,0))
			d ..DeleteStructResult(MKBSDRowId_"||"_MKBSDRChild)
			if (ModuleExpId'="")
			{
				s NewExpId=ModuleExpId_","_TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId		
			}
			else
			{
				s NewExpId=TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId	
			}
			s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowId,"",NewExpId,"",ModuleTermDR,"")	
			/*
			s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowId,"",NewExpId,"",ModuleTermDR,"")	
			s MKBSDRExpId = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),2)
			s MKBSDRTermDR = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild)),4)
			
			s NewExpId=NewExpId_","_TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId
			s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowId,MKBSDRowId_"||"_MKBSDRChild,NewExpId,"",ModuleTermDR,"")
			/*
			if (MKBSDRExpId'="")
			{
				k arr
				if (MKBSDRExpId'[TNMTPRowId) ///未结构化TNM
				{
					s Len=$L(ModuleExpId,",")
					for i=1:1:Len
					{
						s Pro=$P($P(ModuleExpId,",",i),":",1)
						continue:MKBSDRExpId[Pro
						s arr($P(ModuleExpId,",",i))=""	
					}	
					
					s NewExpId=MKBSDRExpId
					s arrstr=""
					for
					{
						s arrstr=$O(arr(arrstr))
						q:arrstr=""	
						s NewExpId=arrstr_","_NewExpId
					}
					s NewExpId=NewExpId_","_TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId
					s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowId,MKBSDRowId_"||"_MKBSDRChild,NewExpId,"",ModuleTermDR,"")		
				}
				else
				{
					s Len=$L(ModuleExpId,",")
					for i=1:1:Len
					{
						s Pro=$P($P(ModuleExpId,",",i),":",1)
						continue:MKBSDRExpId[Pro
						s arr($P(ModuleExpId,",",i))=""	
					}	
					
					s NewExpId=MKBSDRExpId
					s arrstr=""
					for
					{
						s arrstr=$O(arr(arrstr))
						q:arrstr=""	
						s NewExpId=arrstr_","_NewExpId
					}

					s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowId,MKBSDRowId_"||"_MKBSDRChild,NewExpId,"",ModuleTermDR,"")		
					
				}
				
			}	
			else
			{
				s NewExpId=TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId
				s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowId,MKBSDRowId_"||"_MKBSDRChild,NewExpId,"",ModuleTermDR,"")			
			}
			*/	
		}
		else
		{
			
			if (ModuleExpId'="")
			{
				s NewExpId=ModuleExpId_","_TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId		
			}
			else
			{
				s NewExpId=TNMTPRowId_":"_TRowId_"*"_NRowId_"*"_MRowId	
			}
			s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowId,"",NewExpId,"",ModuleTermDR,"")			
		}	
	}
	if TNMFlag'=0
	{
		s result=TNMFlag	
	}
	

	q result
}

/// 通过其他描述重新计算总频次
/// d ##class(web.DHCBL.MKB.MKBStructuredData).ReCalAllFrequency()
ClassMethod ReCalAllFrequency(basedr As %String)
{
	TS
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowId))
		q:MKBSDRowId=""
		
		s AllFreq=0
		s MKBSDLChild=0
		for
		{
			s MKBSDLChild=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",MKBSDLChild))	
			q:MKBSDLChild=""
			
			s Freq=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",MKBSDLChild)),3)
			s AllFreq=AllFreq+Freq
		}
		
		s OtherAllFreq=0
		s MKBSDOChild = 0
		for
		{
			s MKBSDOChild = $O(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowId,MKBSDOChild))
			q:MKBSDOChild=""
			
			s OtherDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",MKBSDOChild)),2)
			continue:((OtherDesc["(")||(OtherDesc[")"))
			b:OtherDesc=""
			s OtherSDRowId=$O(^User.MKBStructuredDataI("MKBSDDiagIndex",basedr," "_$ZCONVERT(OtherDesc,"U"),0))
			b:OtherSDRowId=""
			
			s OtherSDLChild=0
			for
			{
				s OtherSDLChild=$O(^User.MKBStructuredDataD(OtherSDRowId,"MKBSDStructLoc",OtherSDLChild))	
				q:OtherSDLChild=""
				
				s OtherFreq=$LG($G(^User.MKBStructuredDataD(OtherSDRowId,"MKBSDStructLoc",OtherSDLChild)),3)
				s OtherAllFreq=OtherAllFreq+OtherFreq
			}
			
		}	
		s AllFreq=AllFreq+OtherAllFreq
		s obj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
		s obj.MKBSDTotalFreq = AllFreq
		d obj.%Save()
	}
}

/// Creator:李得原
/// CreatDate:2019-07-01
/// Description：根据父表id，获取父表和结构化结果子表信息
/// Table：User.MKBStructuredDataResult
/// Input：父表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).GetSingleData(1)
ClassMethod GetSingleData(id As %String)
{
	q:id="" ""
	s MKBSDRowid=$g(id)
	s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
	s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
	s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),12)    //别名字段
	s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
	s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值
	s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
	if sequence'=""
	{
		s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
		if MKBSDRRowid'=""
		{
			s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
			s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
			
			s Result=..StdGetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
			s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
			if MKBSDSupplement'=""
			{
				if Result["]"
				{
					s str=$e(Result,1,*-1)
					s Result=str_",("_MKBSDSupplement_")]"
				}
				else
				{
					s Result=Result_"[("_MKBSDSupplement_")]"
				}
			}					
		}
		else
		{
			s MKBSDResultID=""
			s MKBSDResultTermdr=""
			s MKBSDSupplement=""
			s Result=""
		}
	}
	else
	{
		s MKBSDResultID=""
		s MKBSDResultTermdr=""
		s MKBSDSupplement=""
		s Result=""
	}
	s thisStr="{""MKBSDRowid"":"""_MKBSDRowid_""",""MKBSDDiag"":"""_MKBSDDiag_""",""MKBSDMrc"":"""_MKBSDMrc_""",""MKBSDMDr"":"""_MKBSDMDr_""",""MKBSDICD"":"""_MKBSDICD_""",""Result"":"""_Result_""",""MKBSDResultID"":"""_MKBSDResultID_""",""MKBSDResultTermdr"":"""_MKBSDResultTermdr_""",""MKBSDSupplement"":"""_MKBSDSupplement_"""}"
	q thisStr
}

/// Creator:李得原
/// CreatDate:2019-07-29
/// Description：根据
/// Table：User.MKBTerm
/// Input：父表id 
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetICDTermList","","1","10")
Query GetICDTermList(base As %String, desc As %String, number As %String) As %Query(ROWSPEC = "MKBTRowid,MKBDesc,MKBNumber")
{
}

ClassMethod GetICDTermListExecute(ByRef qHandle As %Binary, base As %String, desc As %String, number As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s Desc=$zstrip(desc,"<>W")
	s Number=$zstrip(number,"<>W")
	if base'="" //要有ICD指向，体现在工厂注册中ICD配置
	{
		if ((desc'="") || (number'=""))
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("BaseIndex",base,MKBTRowid))
				q:MKBTRowid=""
				s MKBTPICDRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," ICD编码",0))
				s MKBTPDICDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPICDRowid,0))
				s MKBDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
				s MKBNumber=$lg($g(^User.MKBTermProDetailD(MKBTPDICDRowid)),3)
				if ((MKBDesc[Desc)&(MKBNumber[Number))
				{
					d getCTTitle
				}
			}
		}
		else
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("BaseIndex",base,MKBTRowid))
				q:MKBTRowid=""
				
				s MKBTPICDRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," ICD编码",0))
				;s MKBTPCHIRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 中心词",0))
				s MKBTPDICDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPICDRowid,0))
				;s MKBTPDCHIRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPCHIRowid,0))
				;s MKBDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDCHIRowid)),3)
				s MKBDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
				s MKBNumber=$lg($g(^User.MKBTermProDetailD(MKBTPDICDRowid)),3)
				d getCTTitle
			}
		}
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(MKBTRowid,MKBDesc,MKBNumber)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetICDTermListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDTermListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetICDTermListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDTermListExecute ]
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

/// 判断是否为当前医院
ClassMethod JustHosptial(id)
{
	q:id="" ""
	s flag = ""
	s flag = $LISTGET($G(^User.MKBStructuredBaseD(id)),5)	
	q flag
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 石萧伟
/// CreateDate:2019-07-18    
/// w ##class(web.DHCBL.MKB.MKBStructuredBase).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(desc As %String, STBBase As %String) As %String
{
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc=""
    s:desc'="" flagc=$d(^User.MKBStructuredDataI("MKBSDDiagIndex",STBBase," "_$zconvert(desc,"U")))

    if (flagc>0) 
    {
	    s flag=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",STBBase," "_$zconvert(desc,"U"),0))
    }

    q flag
}

/// 导入保存方法	
/// 石萧伟
ClassMethod SaveImportData(dataStr, STBBase)
{
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
	
	s diag=$replace($p(dataStr,"[next]",1),",","，")
	q:diag="" ""
	s icdcode=$p(dataStr,"[next]",2)
	s icddesc=$p(dataStr,"[next]",3)
	s locs=$p(dataStr,"[next]",4)
	s alias=$p(dataStr,"[next]",5)
	s source=$p(dataStr,"[next]",6)
	s pycode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
	s pysource = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(source)
	
	s flag=..FormValidate(diag,STBBase)
	if (flag="")
	{
		s obj=##class(User.MKBStructuredData).%New()
	
		s obj.MKBSDDiag=diag
		s obj.MKBSDDiagPYCode=pycode
		s:icdcode'="" obj.MKBSDICD=icdcode
		s:icddesc'="" obj.MKBSDICDDesc=icddesc
		s obj.MKBSDTotalFreq=0
		Set UpdateDate=$p($h,",",1)       //上传日期
		Set UpdateUserDR=%session.Get("LOGON.USERID")
		d obj.MKBSDUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBSDDate=UpdateDate	
		s obj.MKBSDStatus="N"
		s obj.MKBSDDiaSource=source
		s locbase =$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
		s locid = $o(^User.MKBTermI("DescIndex",locbase," "_$zconvert(locs,"U"),0))
		if (locid'="")
		{
			s obj.MKBSDLoc= locid
		}
		d obj.MKBSDBaseDrSetObjectId(STBBase)
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(flag)
		s oldsource = obj.MKBSDDiaSource
		if (oldsource="")
		{
			s obj.MKBSDDiaSource=source
		}
		else
		{
			s obj.MKBSDDiaSource=oldsource_"&"_source
		}
		
	}
	Ts
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(STBBase,pycode,id)  //拼音码全文索引
		d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(STBBase,diag,id) //诊断名全文索引
		s alias = $replace(alias,",","，")
		s apycode =##class(web.DHCBL.BDP.FunLib).GetPYCODE(alias)
		d:icdcode'="" ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(STBBase,icdcode,id)
		d ..OtherUpdate(id,"",alias,"",apycode,"OD")
		
		//d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(locs,id_"L") //科室全文索引

		/*s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 术语分类",0))
		s MKBRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," 数据来源",0))
		//将数据来源添加到知识库
		s eobj=##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTDesc=source
		s eobj.MKBTLastLevel=MKBRowid
		s eobj.MKBTBaseDR=MKBTBRowid
		s eobj.MKBTPYCode=pysource
		s eobj.MKBTActiveFlag="Y"
		
		
		d ##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)*/
		s sourcedata = $lg($g(^User.MKBStructuredBaseD(STBBase)),6) //数据来源
		if (sourcedata'[source)
		{
			s eobj=##class(web.Entity.MKB.MKBStructuredBase).%New()
			s eobj.Rowid = STBBase
			s eobj.MKBSTBDesc = $lg($g(^User.MKBStructuredBaseD(STBBase)),2)  
		    s eobj.MKBSTBICDDr = $lg($g(^User.MKBStructuredBaseD(STBBase)),3)
		    s eobj.MKBSTBStrDr = $lg($g(^User.MKBStructuredBaseD(STBBase)),4)
		    s eobj.MKBSTBFlag = $lg($g(^User.MKBStructuredBaseD(STBBase)),5)
		    

			s obj=##class(User.MKBStructuredBase).%OpenId(STBBase)
			s MKBSTBSource=""
			if (sourcedata'="")
			{
				s MKBSTBSource = sourcedata_","_source
			}
			elseif (sourcedata="")
			{
				s MKBSTBSource = source 	
			}
			s eobj.MKBSTBSource = MKBSTBSource
			d ##class(web.DHCBL.MKB.MKBStructuredBase).SaveData(eobj)
		}

		
		
		s wordstr=""
		s dict=##class(%ArrayOfDataTypes).%New()
		s dict=..AutoProcessingCenterData(diag)
		for i=1:1:dict.Count()
		{
			s Worddr=dict.GetNext(.key)
			s:wordstr'="" wordstr=wordstr_","_key 
			s:wordstr="" wordstr=key
		}
		if wordstr'=""
		{
			s wobj=##class(User.MKBStructuredData).%OpenId(id)          //自动匹配参考中心词
			s wobj.MKBSDCenterWordID=wordstr
			s wsc=obj.%Save()
			d wobj.%Close()
		}
		d ..AutoProcessingStructData(diag,id)    //通过数据处理工厂已处理的进行自动结构化
		if ((STBBase'="")&(icdcode'="")&(icddesc'=""))
		{
			s MKBICDTBRowid=$lg($g(^User.MKBStructuredBaseD(STBBase)),3)   //获取ICD来源
			s MKBICDTRowid=0
			for
			{
				s MKBICDTRowid=$o(^User.MKBTermI("DescIndex",MKBICDTBRowid," "_$zconvert(icddesc,"U"),MKBICDTRowid))
				q:MKBICDTRowid=""
				s MKBICDDesc=$lg($g(^User.MKBTerm(MKBICDTRowid)),3)
				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBICDTRowid," ICD编码",0))
				continue:MKBTPRowid=""
				s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0))
				s MKBICDNumber=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
				if MKBICDNumber=icdcode
				{
					s iobj=##class(User.MKBStructuredData).%OpenId(id)
					d iobj.MKBSDICDTermDrSetObjectId(MKBICDTRowid)
					d iobj.%Save()
					d iobj.%Close()
				}
			}
			
		}
		set result = "true"
	}
	else
	{
		s result = "false"  
		s tip = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		Tro	
	}
	d obj.%Close()
	quit result
}

/// Creator:李得原
/// CreatDate:2019-08-01
/// Description：根据
/// Table：User.MKBTerm
/// Input：父表id 
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetSourceComList")
Query GetSourceComList() As %Query(ROWSPEC = "MKBTRowid,MKBTDesc")
{
}

ClassMethod GetSourceComListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 术语分类",0))
	s MKBRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," 数据来源",0))
	s MKBSquence=0
	for
	{
		s MKBSquence=$o(^User.MKBTermI("ParSeqIndex",MKBTBRowid,MKBRowid,MKBSquence))
		q:MKBSquence=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParSeqIndex",MKBTBRowid,MKBRowid,MKBSquence,MKBTRowid))
			q:MKBTRowid=""
			s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
			d getCTTitle
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(MKBTRowid,MKBTDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSourceComListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSourceComListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSourceComListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSourceComListExecute ]
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

/// Creator:李得原
/// CreatDate:2019-08-02
/// Description：数据处理工厂上传数据时候自动匹配中心词		弃用
/// Table：User.MKBTerm
/// Input：父表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).AutoProcessingData()
ClassMethod AutoProcessingCenterData(desc As %String) As %ArrayOfDataTypes
{
	s TempTermData=##class(%ArrayOfDataTypes).%New()
	set MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBTRowid = 0
	for
	{
		set MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		quit:MKBTRowid="" 
		set TermData=$lg($g(^User.MKBTermD(MKBTRowid)),3)  ;获取中心词
		
		if desc[TermData
		{
			d TempTermData.SetAt(desc,MKBTRowid)    ;存储中心词rowid
		}
		else
		{
			set AliasItem=""
			;获取未匹配到的中心词的别名
			s AliasNum=0
			set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowid)    
			set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
			set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
			for i=1:1:AliasNum
			{
				set AliasItem=$p(TermDataAlias,",",i)
				if desc[AliasItem
				{
					d TempTermData.SetAt(desc,MKBTRowid)
				}
			}
		}
	}
	q TempTermData
}

/// Creator:李得原
/// CreatDate:2019-08-02
/// Description：数据处理工厂上传数据时候自动结构化		弃用
/// Table：User.MKBStructuredData
/// Input：父表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).AutoProcessingStructData()
ClassMethod AutoProcessingStructData(desc As %String, rowid As %String) As %String
{
	s result=""
	s desc=$zconvert(desc,"U")
	s AnzhenBasedr=$o(^User.MKBStructuredBaseI("DescIndex"," 安贞数据处理工厂",0))
	s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",AnzhenBasedr," "_desc,0))
	if MKBSDRowid'=""
	{
		if $d(^User.MKBStructuredDataI("StructIndex",1,MKBSDRowid))
		{
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSequence=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),6)
				s MKBRTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				s MKBRResult=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s sobj=##class(User.MKBStructuredDataResult).%New(rowid)
				d sobj.MKBSDStructDataSetObjectId(rowid)
				s sobj.MKBSDSequence=MKBSequence
				s sobj.MKBSDStructResultID=MKBRResult
				d sobj.MKBSDTermDRSetObjectId(MKBRTermdr)
				s ssc=sobj.%Save()
				d sobj.%Close()
				if $$$ISERR(ssc)
				{
					s result=$system.OBJ.DisplayError(ssc)
				}
				else
				{
					s result="true"
				}
			}
		}
	}
	q result
}

/// Creator:石萧伟
/// CreatDate:2019-08-14
/// Description：
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).SaveResultRelation()
ClassMethod SaveResultRelation(rowid As %String, flag As %String)
{
	s obj=##class(User.MKBStructuredData).%OpenId(rowid)
	s obj.MKBSDResultRelation=flag
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

ClassMethod GetAllResultData(id As %String) As %String
{
	s Result=""
	s MKBSDRowid=$g(id)
	if $d(^User.MKBStructuredDataD(id))
	{
		s sequence=0
		for
		{
			s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence))
			q:sequence=""
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDRResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
				s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
	
				
				s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDRResultID,MKBSDResultTermdr)
				s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
				if MKBSDSupplement'=""
				{
					if SResult["]"
					{
						s str=$e(Result,1,*-1)
						s SResult=str_",("_MKBSDSupplement_")]"
					}
					else
					{
						s SResult=SResult_"[("_MKBSDSupplement_")]"
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

/// Creator：钟荣枫 		
/// CreatDate: 2021-8-18
/// Description：导出数据处理工厂诊断模板数据
/// Table:
/// Input:base 数据处理工厂id，reallocs 实际科室描述串
/// Output:
/// Other:##class(web.DHCBL.MKB.MKBStructuredData).GetYGRHTermGlobalList(9)
ClassMethod GetYGRHTermGlobalList(base)
{
	q:base="" "{""rows"":[], ""total"":0}"
	k ^term
	s str=""
	s result=""
	//Index BaseIndex On MKBSDBaseDr;
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s MKBSDRRTermid=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			continue:MKBSDRRTermid=""
			continue:'$d(^User.MKBTermD(MKBSDRRTermid))
			if ($d(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc"))>0)		//有实际科室
			{
				s MKBSDLRowid=""
				for
				{
					s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
					q:MKBSDLRowid=""
					s MKBLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2) //科室名
					s MKBFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)  //频次
					s MKBSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),4) //来源
					if $d(^term(MKBSDRRTermid))
					{
						s ^term(MKBSDRRTermid,MKBSource)=$g(^term(MKBSDRRTermid,MKBSource))+MKBFre
					}
					else
					{
						s ^term(MKBSDRRTermid,MKBSource)=MKBFre
					}
				}
			}
			else
			{
				s MKBSource="O"
				s MKBFre=0
				if $d(^term(MKBSDRRTermid))
				{
					s ^term(MKBSDRRTermid,MKBSource)=$g(^term(MKBSDRRTermid,MKBSource))+MKBFre
				}
				else
				{
					s ^term(MKBSDRRTermid,MKBSource)=MKBFre
				}
			}
		}
	}
	//对频次再排序
	k ^TempArr
	s MKBTerm=0
	for
	{
		s MKBTerm=$o(^term(MKBTerm)) q:MKBTerm=""
		s count=0
		s Source=""
		for
		{
			s Source=$o(^term(MKBTerm,Source)) q:Source=""
			s fre=$g(^term(MKBTerm,Source))
			s:fre="" fre=0
			s count=count+fre
		}
		s ^TempArr(count,MKBTerm)=""
	}
	w "{""rows"":["
	s total= ..ExportYDYTermProDetail()
	w "], ""total"":"_total_"}"
	q ""
}

/// Creator: 李得原
/// CreatDate: 2019-11-20
/// Description: 把该诊断的诊断模板里的数据都导出到excel中。
/// Input: filename-实际科室名字
/// w ##class(web.DHCBL.MKB.MKBStructuredData).ExportYDYTermProDetail()
ClassMethod ExportYDYTermProDetail()
{
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))   //获取baseid
	s jsonStr=""
	s Frequnce=""
	s AliasName=""
	s CenterWord=""
	s Proterty=""
	s PropertyDetail=""
	s DescL1=""		//详情下的4层
	s DescL2=""
	s DescL3=""
	s DescL4=""
	s total=0
	
	s Frequ=""
	for
	{
		s Frequ=$o(^TempArr(Frequ),-1)
		q:Frequ=""
		s MKBTermRowid=0
		for
		{
			s MKBTermRowid=$o(^TempArr(Frequ,MKBTermRowid))
			q:MKBTermRowid=""
			continue:'$d(^User.MKBTermD(MKBTermRowid))
			s MKBTermDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)  //获取临床实用诊断中心词
			
			set AliasItem=""
			;获取未匹配到的中心词的别名
			s AliasNum=0
			set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTermRowid)    
			set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
			set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
			s AliasString=""
			for n=1:1:AliasNum
			{
				set AliasItem=$p(TermDataAlias,",",n)
				//s AliasItem=$replace(AliasItem,",","，")
				s:AliasString'="" AliasString=AliasString_","_AliasItem
				s:AliasString="" AliasString=AliasItem
			}
			s L=0
			s O=0
			
			s LocFlag=""
			if $d(^term(MKBTermRowid,"L"))		//住院频次
			{
				s L=^term(MKBTermRowid,"L")
			}
			if $d(^term(MKBTermRowid,"O"))		//门急诊频次
			{
				s O=^term(MKBTermRowid,"O")
			}
			s LO=L+O
			b:LO'=Frequ
			s Frequnce="总频次("_Frequ_")，"_"住院("_L_")，门急诊("_O_")"
			s AliasName="别名("_AliasString_")"
			s CenterWord=MKBTermDesc
			s Proterty=""
			s PropertyDetail=""
			s thisstr="{""Frequnce"":"""_Frequnce_""",""AliasName"":"""_AliasName_""",""CenterWord"":"""_CenterWord_""",""Proterty"":"""",""PropertyDetail"":"""",""DescL1"":"""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
			s total=total+1
			if (total>1)
			{
				w ","
			}
			w thisstr
			
			
			
			
			//d file.WriteLine("总频次("_Frequ_")，"_"住院("_L_")，门急诊("_O_")"_","_"别名("_AliasString_")"_","_MKBTermDesc)
			
			s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
			continue:MKBTermProRowid=""
			s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
			s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
			s length=$l(MKBTemplate,",")
			for i=1:1:length
			{
				continue:i=""
				s OnePiece=$p(MKBTemplate,",",i)
				s TempProRowid=$p(OnePiece,"&",1)    //属性ID
				s DefineNode=$p(OnePiece,"&",3)  //定义节点
				s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
				s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
				s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)
				continue:PDesc="其他描述"
				s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""_PDesc_""",""PropertyDetail"":"""",""DescL1"":"""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
				w ","_thisstr
				s total=total+1
						
				//d file.WriteLine(",,,"_PDesc)
				s Desc=""
				if "TX,TA,R,CB,C,L,T,F"[MKBTPType
				{
					if DefineNode'=""
					{
						s Property=$lg($g(^User.MKBTermProDetailD(DefineNode)),3)
						s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""_Property_""",""DescL1"":"""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
						w ","_thisstr
						s total=total+1
						//d file.WriteLine(",,,,"_Property)
						s DescStr=..GetChildOrderedIDStr(DefineNode,TempProRowid,0,1)
						continue:DescStr=""
						s desclen=$l(DescStr,"^")
						
						for k=1:1:desclen
						{
							continue:k=""
							s Desc=$p(DescStr,"^",k)
							s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""""
							
							if (Desc[$c(9))
							{
								s lengtht=$l(Desc,$c(9))-1
								s DescL1=""
								s DescL2=""
								s DescL3=""
								s DescL4=""
								if (lengtht=1)
								{
									s DescL1=Desc
								}
								elseif (lengtht=2)
								{
									s DescL2=Desc
								}
								elseif (lengtht=4)
								{
									s DescL3=Desc
								}
								else
								{
									s DescL4=Desc
								}
								
								s thisstr=thisstr_",""DescL1"":"""_DescL1_""",""DescL2"":"""_DescL2_""",""DescL3"":"""_DescL3_""",""DescL4"":"""_DescL4_"""}"
							}
							else
							{
								s thisstr=thisstr_",""DescL1"":"""_Desc_""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
							}
							//s Desc=$replace(Desc,",","，")
							w ","_thisstr
							s total=total+1
							//d file.WriteLine(" ,,,,,"_Desc)
						}
					}
					else
					{
						

						s DescStr=..GetChildOrderedIDStr("",TempProRowid,0,1)
						continue:DescStr=""
						s desclen=$l(DescStr,"^")
						for k=1:1:desclen
						{
							continue:k=""
							s Desc=$p(DescStr,"^",k)
							s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""""
							
							if (Desc[$c(9))
							{
								s lengtht=$l(Desc,$c(9))-1
								s DescL1=""
								s DescL2=""
								s DescL3=""
								s DescL4=""
								if (lengtht=1)
								{
									s DescL1=Desc
								}
								elseif (lengtht=2)
								{
									s DescL2=Desc
								}
								elseif (lengtht=4)
								{
									s DescL3=Desc
								}
								else
								{
									s DescL4=Desc
								}
								
								s thisstr=thisstr_",""DescL1"":"""_DescL1_""",""DescL2"":"""_DescL2_""",""DescL3"":"""_DescL3_""",""DescL4"":"""_DescL4_"""}"
							}
							else
							{
								s thisstr=thisstr_",""DescL1"":"""_Desc_""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
							}
							
							w ","_thisstr
							s total=total+1
							//s Desc=$replace(Desc,",","，")
							//d file.WriteLine(" ,,,,,"_Desc)
						}
						
					}
				} 
				elseif MKBTPType="S"    //引用术语
				{
					
					if DefineNode'=""
					{

						set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(DefineNode)    
						s strCom=$p(strComAndAlisa,"[A]",1)
						s Desc=$p(strCom,"&%",1) //诊断常用名
						if Desc=""
						{
							s Desc=$lg($g(^User.MKBTermD(Term)),3)
						}
						s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""""
							
						if (Desc[$c(9))
						{
							s lengtht=$l(Desc,$c(9))-1
							s DescL1=""
							s DescL2=""
							s DescL3=""
							s DescL4=""
							if (lengtht=1)
							{
								s DescL1=Desc
							}
							elseif (lengtht=2)
							{
								s DescL2=Desc
							}
							elseif (lengtht=4)
							{
								s DescL3=Desc
							}
							else
							{
								s DescL4=Desc
							}
							
							s thisstr=thisstr_",""DescL1"":"""_DescL1_""",""DescL2"":"""_DescL2_""",""DescL3"":"""_DescL3_""",""DescL4"":"""_DescL4_"""}"
						}
						else
						{
							s thisstr=thisstr_",""DescL1"":"""_Desc_""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
						}
						w ","_thisstr
						s total=total+1
						//s Desc=$replace(Desc,",","，")
						//d file.WriteLine(",,,,,"_Desc)
					
					}
					s sd=""      //用来存储选中的引用术语
					s MKBTinD=0
					for
					{
						s MKBTinD=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTinD))
						q:MKBTinD=""
						s MKBt=$lg($g(^User.MKBTermProDetailD(MKBTinD)),3)
						s sd(MKBt)=""
					}
					s sstr=""
					d ..GetSTermTree(.sstr, MKBConfig, DefineNode, TempProRowid,.sd,1)
					s ls=$l(sstr,"&")
					for p=1:1:ls
					{
						if p=1
						{
							s Desc=$p(sstr,"&",1)
							s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""_Desc_""",""DescL1"":"""_Desc_""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
							w ","_thisstr
							s total=total+1
							//d file.WriteLine(",,,,"_Desc)
						}
						else
						{
							s Desc=$p(sstr,"&",p)
							s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""""
							
							if (Desc[$c(9))
							{
								s lengtht=$l(Desc,$c(9))-1
								s DescL1=""
								s DescL2=""
								s DescL3=""
								s DescL4=""
								if (lengtht=1)
								{
									s DescL1=Desc
								}
								elseif (lengtht=2)
								{
									s DescL2=Desc
								}
								elseif (lengtht=4)
								{
									s DescL3=Desc
								}
								else
								{
									s DescL4=Desc
								}
								
								s thisstr=thisstr_",""DescL1"":"""_DescL1_""",""DescL2"":"""_DescL2_""",""DescL3"":"""_DescL3_""",""DescL4"":"""_DescL4_"""}"
							}
							else
							{
								s thisstr=thisstr_",""DescL1"":"""_Desc_""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
							}
						
							w ","_thisstr
							s total=total+1
							//d file.WriteLine(",,,,,"_Desc)
						}
					}
				}
				elseif MKBTPType="P"
				{
					s MKBTPDRowid=0
					for
					{
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
						//s Desc=$replace(Desc,",","，")
						s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""_Desc_""",""DescL1"":"""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}}"
						w ","_thisstr
						s total=total+1
						//d file.WriteLine(" , ,,,"_Desc)
					}
				}
				elseif MKBTPType="SS"   //引用单节点
				{
					s MKBTPDRowid=0
					for
					{
						
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						
						s str=""
						;s term=$lg($g(^User.MKBTermD(Term)),3)
						s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)
						s strCom=$p(strComAndAlisa,"[A]",1)
						s term=$p(strCom,"&%",1) //诊断常用名
						if term=""
						{
							s term=$lg($g(^User.MKBTermD(Term)),3)
						}
						s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""_term_""",""DescL1"":"""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
						w ","_thisstr
						s total=total+1
						//d file.WriteLine(",,,,"_term)
						s DescStr=..GetSSData(.str,MKBConfig,Term,0,1)
						continue:DescStr=""
						s desclen=$l(DescStr,"^")
						for j=1:1:desclen
						{
							s Desc=$p(DescStr,"^",j)
							continue:Desc=""
							s thisstr="{""Frequnce"":"""",""AliasName"":"""",""CenterWord"":"""",""Proterty"":"""",""PropertyDetail"":"""""
							
							if (Desc[$c(9))
							{
								s lengtht=$l(Desc,$c(9))-1
								s DescL1=""
								s DescL2=""
								s DescL3=""
								s DescL4=""
								if (lengtht=1)
								{
									s DescL1=Desc
								}
								elseif (lengtht=2)
								{
									s DescL2=Desc
								}
								elseif (lengtht=4)
								{
									s DescL3=Desc
								}
								else
								{
									s DescL4=Desc
								}
								
								s thisstr=thisstr_",""DescL1"":"""_DescL1_""",""DescL2"":"""_DescL2_""",""DescL3"":"""_DescL3_""",""DescL4"":"""_DescL4_"""}"
							}
							else
							{
								s thisstr=thisstr_",""DescL1"":"""_Desc_""",""DescL2"":"""",""DescL3"":"""",""DescL4"":""""}"
							}
							
							w ","_thisstr
							s total=total+1
							//d file.WriteLine(" ,,,,,"_desc)
						}
					}
					
				}
				else		//过滤了树形
				{
					continue
				}
			}
		}
	}
	q total
}

/// 递归遍历引用术语
ClassMethod GetSTermTree(ByRef sstr, base, lastlevel, pro, ByRef sd, first)
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s first=first+1
		s mark=""
		for i=1:1:first
		{
			s mark="    "_mark
		}
	}
	if first=1
	{
		if lastlevel=""
		{
			s lastlevel=-100000000000000
			s MKBTRowid=0
			
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("ParentIndex",base,lastlevel,MKBTRowid))
				q:MKBTRowid=""
				
				if $d(sd(MKBTRowid))
				{
					set strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)    
					s strCom=$p(strComAndAlisa,"[A]",1)
					s Desc=$p(strCom,"&%",1) //诊断常用名
					if Desc=""
					{
						s Desc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
					}
					
					s Desc=$replace(Desc,",","，")
					if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))
					{
						d ..GetSTermTree(.sstr,base,MKBTRowid,pro,.sd,2)
					}
					
					s:sstr'="" sstr=Desc_"&"_sstr
					s:sstr="" sstr=Desc
				}
			}
		}
		else
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("ParentIndex",base,lastlevel,MKBTRowid))
				q:MKBTRowid=""
				if $d(sd(MKBTRowid))
				{
					set strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)    
					s strCom=$p(strComAndAlisa,"[A]",1)
					s Desc=$p(strCom,"&%",1) //诊断常用名
					if Desc=""
					{
						s Desc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
					}
					s Desc=$replace(Desc,",","，")
					
					if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))
					{
						d ..GetSTermTree(.sstr,base,MKBTRowid,pro,.sd,2)
					}
					s:sstr'="" sstr=mark_Desc_"&"_sstr
					s:sstr="" sstr=mark_Desc
				}
			}
		}
	}
	else
	{
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParentIndex",base,lastlevel,MKBTRowid))
			q:MKBTRowid=""
			if $d(sd(MKBTRowid))
			{
				set strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)    
				s strCom=$p(strComAndAlisa,"[A]",1)
				s Desc=$p(strCom,"&%",1) //诊断常用名
				if Desc=""
				{
					s Desc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
				}
				s Desc=$replace(Desc,",","，")
				if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))
				{
					d ..GetSTermTree(.sstr,base,MKBTRowid,pro,.sd,first)
				}
				s:sstr'="" sstr=mark_Desc_"&"_sstr
				s:sstr="" sstr=mark_Desc
			}
		}
	}

	q sstr
}

/// Creator: 李得原
/// CreatDate: 2019-11-20
/// Description: 引用起始节点遍历方法
/// w ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr("52","128958")
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetSSData(.str,52,128958)
ClassMethod GetSSData(ByRef str, base As %String, id As %String, flags As %String, first As %String)
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark="    "_mark
		}
	}
	s seq=0
	for
	{
		s seq=$o(^User.MKBTermI("ParSeqIndex",base,id,seq))
		
		q:seq=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParSeqIndex",base,id,seq,MKBTRowid))
			q:MKBTRowid=""
			
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s MKBTDesc=$p(strCom,"&%",1) //诊断常用名
			if MKBTDesc=""
			{
				s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
			}
			s:str'="" str=str_"^"_mark_MKBTDesc
			s:str="" str=mark_MKBTDesc
			if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))  //如果有子节点
			{
				d ..GetSSData(.str,base,MKBTRowid,flags,2)
			}
		}
	}
	q str
}

/// Creator: 李得原
/// CreatDate: 2019-11-20
/// Description: 病情描述等遍历方法
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetChildOrderedIDStr()
ClassMethod GetChildOrderedIDStr(LastLevel As %String, property As %String, flags As %String, first As %String) As %String
{
	if first=1
	{
		s mark=""
		if (LastLevel="") s LastLevel=-100000000000000
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark=$c(9)_mark
		}
	}
		
	s IDStr=""
	s childStr=""
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq,myRowID)) q:(myRowID="")
			
			s childStr=..GetChildOrderedIDStr(myRowID, property,flags,2)
			
			s desc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(myRowID,property,"展示名")  //获取展示名
			s:desc="" desc=$lg($g(^User.MKBTermProDetailD(myRowID)),3)
			if childStr'="" s childStr=mark_desc_"^"_childStr
			if childStr="" s childStr=mark_desc
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// Creator:钟荣枫
/// CreatDate:2021-3-5
/// Description：将处理工厂里有结构化的状态都改为预处理
/// Input：base
/// Return:预处理的有多少条
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateState()
ClassMethod UpdateState(base)
{
	q:base="" "false"
	//Index BaseIndex On MKBSDBaseDr;
	s errorflag=0
	s tresult=""
	TS
	s num=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))
		q:MKBSDRowid=""
		q:errorflag=1
		s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)	//N 未处理，P 预处理
		s StructuredDataID=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",MKBSDRowid,""))
		s State=""
		if (StructuredDataID'="")	//有结构化
		{
			if (MKBSDStatus="N")	//状态为未处理
			{
				s State="P"
					
				//修改状态为预处理
			}	
			elseif (MKBSDStatus="P")	//预处理
			{
				s num=num+1
			}
		}
		else
		{
			if (MKBSDStatus="P")
			{
				s State="N"
			}
				
		}
		if (State'="")
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid) 
			s obj.MKBSDStatus=State
			s UpdateDate=$p($h,",",1)       //上传日期
			s obj.MKBSDDate=UpdateDate
			
			s sc=obj.%Save()
			if $$$ISOK(sc)
			{
				s num=num+1
			}
			
			else
			{
				s errorflag=1
			}
			
			d obj.%Close()
		}
	}
	if (errorflag=1)
	{
		tro
		s tresult="false"	
	}
	else
	{
		tc
		s tresult="true"	
	}
	q tresult
}

/// Creator:钟荣枫
/// CreatDate:2021-3-5
/// Description：获取结构化诊断描述
/// Input：id
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetStruct()
ClassMethod GetStruct(MKBSDRowid)
{
	s Result=""
	s sequence=0
	for
	{
		s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence))
		q:sequence=""
		
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
			q:MKBSDRRowid=""
			s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
			s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
			continue:MKBSDResultTermdr=""
			s SResult=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
			s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
			if MKBSDSupplement'=""
			{
				if SResult["]"
				{
					s str=$e(SResult,1,*-1)
					s SResult=str_",("_MKBSDSupplement_")]"
				}
				else
				{
					s SResult=SResult_"[("_MKBSDSupplement_")]"
				}
			}					
			s:Result'="" Result=Result_"<br/>"_SResult
			s:Result="" Result=SResult
		}
	}
	q Result
}

/// Creator:钟荣枫
/// CreatDate:20217-28
/// Description：删除数据处理工厂下某条数据的子表数据
/// Input：MKBSDRowid  数据处理工厂数据的id 
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).DelChildOfData(3)
ClassMethod DelChildOfData(MKBSDRowid)
{
	s errorflag=0
	
	q:MKBSDRowid="" 1
	s base=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
	//User.MKBStructuredDataResult	结构化数据子表
	//删除关联的结构化数据子表数据
	s StructID=0
	for
	{
		s StructID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID))
		q:StructID=""
		q:errorflag=1
		s RowID=MKBSDRowid_"||"_StructID
			
		s structre=..DeleteStructResult(RowID) 	// ##class(User.MKBStructuredDataResult).%DeleteId(RowID)
		s:structre["false" errorflag=1
		//s structre= ##class(User.MKBStructuredDataResult).%DeleteId(RowID)
		//s:structre'=1 errorflag=1
		
	}
	//删除父表指向专业科室	User.MKBStructuredDataProLoc
	//MKBSDStructProLoc
	s ProLocID=0
	for
	{
		s ProLocID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructProLoc",ProLocID))
		q:ProLocID=""
		q:errorflag=1
		s RowID=MKBSDRowid_"||"_ProLocID
		s prolocre= ##class(User.MKBStructuredDataProLoc).%DeleteId(RowID)
		s:prolocre'=1 errorflag=1
		
	}
	//删除父表指向科室频次子表字段	User.MKBStructuredDataLoc
	s LocID=0
	for
	{
		s LocID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocID))
		q:LocID=""
		q:errorflag=1
		s RowID=MKBSDRowid_"||"_LocID
		s locre= ##class(User.MKBStructuredDataLoc).%DeleteId(RowID)
		;b ;User.MKBStructuredDataLoc
		s:locre'=1 errorflag=1
	}
	
	//别名  User.MKBStructuredDataOther
	s OtherID=0
	for
	{
		s OtherID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",OtherID))
		q:OtherID=""
		q:errorflag=1
		s OtherDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",OtherID)),2)
		s MKBSDOtherCode=$LG($G(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",OtherID)),4)
		
		s RowID=MKBSDRowid_"||"_OtherID
		s otherre= ##class(User.MKBStructuredDataOther).%DeleteId(RowID)
		;b ;User.MKBStructuredDataOther
		if (otherre'=1)
		{
			s errorflag=1
		}
		else		//删除索引
		{
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(base,OtherDesc,RowID)	
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(base,MKBSDOtherCode,RowID)
		}
		
	}
	q errorflag
}

/// Creator:钟荣枫
/// CreatDate:2021-3-10
/// Description：删除某个数据处理工厂的所有数据，以及关联科室，结构化等
/// Input：base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).DelDataOfBase(3)
ClassMethod DelDataOfBase(base)
{
	s errorflag=0
	s result=""
	TS

	s count=0
	s MKBSDRowid=0
	for
	{
		//Index BaseIndex On MKBSDBaseDr;
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		q:errorflag=1
		
		s errorflag=..DelChildOfData(MKBSDRowid)
		
		if (errorflag=0)
		{
			//删除索引
			d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndexByCode(MKBSDRowid)
			
			s datare= ##class(User.MKBStructuredData).%DeleteId(MKBSDRowid)
			s count=count+1
			w !,count
			s:datare'=1 errorflag=1
			if (datare'=1)
			{
				s errorflag=1	
			}
			else
			{
				
				//d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SD",MKBSDRowid)	
			}
		}
	}
	if (errorflag=1)
	{
		
		s result="false"
		tro	
	}
	else
	{
		s result="true"
		tc	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-3-10
/// Description：删除某个数据处理工厂的所有数据的结构化数据，并重新结构化  
/// Input：base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).DelStructOfBase(3)
ClassMethod DelStructOfBase(base, aliasflag = "")
{
	s result=""
	s errorflag=0
	TS
	s MKBSDRowid=0
	for
	{
		//Index BaseIndex On MKBSDBaseDr;
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		q:errorflag=1
		s delre= ..DelStructOfDiag(MKBSDRowid,aliasflag)
		s:delre="false" errorflag=1
		
	}
	if (errorflag=1)
	{
		s result="false"
		tro	
	}
	else
	{
		d ..StructData(base,aliasflag)
		s result="true"
		tc	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-12-8
/// Description：删除某个诊断数据的结构化结果、别名	
/// Input：
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).DelStructOfDiag(1800816)
ClassMethod DelStructOfDiag(MKBSDRowid As %String, aliasflag As %String = "")
{
	s result=""
	s errorflag=0
	q:MKBSDRowid="" "false"
	ts
	//删除关联的结构化数据子表数据
	s StructID=0
	for
	{
		s StructID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID))
		q:StructID=""
		q:errorflag=1
		s RowID=MKBSDRowid_"||"_StructID
		s structre= ##class(User.MKBStructuredDataResult).%DeleteId(RowID)
		s:structre'=1 errorflag=1
		
	}
	if (aliasflag'="")	//是否删除子表
	{
		//别名  User.MKBStructuredDataOther
		s OtherID=0
		for
		{
			s OtherID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",OtherID))
			q:OtherID=""
			q:errorflag=1
			s OtherDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",OtherID)),2)
			s MKBSDOtherCode=$LG($G(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",OtherID)),4)
			
			s RowID=MKBSDRowid_"||"_OtherID
			s otherre= ##class(User.MKBStructuredDataOther).%DeleteId(RowID)
			;b ;User.MKBStructuredDataOther
			if (otherre'=1)
			{
				s errorflag=1
			}
			else		//删除索引
			{
				d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(base,OtherDesc,RowID)	
				d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(base,MKBSDOtherCode,RowID)
			}
			
		}
	}
	if (errorflag'=1) 	//没有出错时，修改结构化标志和状态
	{
		s nobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
	   	s nobj.MKBSDChildStructFlag = 0
	   	s nobj.MKBSDStatus="N"
	   	s fwk = nobj.%Save()
	   	d nobj.%Close()
	   	tc
	   	s result="true"
	}
	else
	{
		tro
		s result="false"	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-3-10	
/// Description：将某个数据处理工厂的所有数据结构化  全局化词表-》国标2.0-》数据处理工厂	
/// 2021-7-15 只匹配全局化词表	2021-12-6 各版本icd对照-》数据处理工厂
/// Input：base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).StructData(base)
ClassMethod StructData(base, aliasflag = "")
{
	d ##class(web.DHCBL.MKB.MKBGlobal).ExportGlobalData("D:\GlobalData\")
	s count=0
	s addcount=0
	s MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(base)),2)
	s thebaseid=$o(^User.MKBTermBaseI("DescIndex"," 全局化词表标记",""))
    if (thebaseid'="")
    {
	    //Index DescIndex On (MKBTBaseDR, MKBTDesc);
	    s TermID=$o(^User.MKBTermI("DescIndex",thebaseid," "_$zconvert(MKBSTBDesc,"U"),""))	//词表标记
	    if (TermID="")	//新建标记，不用手动添加
	    {
		    s lastlevel=$o(^User.MKBTermI("DescIndex",thebaseid," 数据处理工厂",""))
		    s bobj = ##class(web.Entity.MKB.MKBTerm).%New()
			s bobj.MKBTDesc = MKBSTBDesc
			s bobj.MKBTBaseDR = thebaseid
			s bobj.MKBTLastLevel =lastlevel
			d ##class(web.DHCBL.MKB.MKBTerm).SaveData(bobj)
	    }
    }
				    
	s MKBSDRowid=0
	for
	{
		//Index BaseIndex On MKBSDBaseDr;
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  
		s MKBSDTCMDiagFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),24) 	//中医诊断标识
		continue:((MKBSDTCMDiagFlag="Y")||(MKBSDTCMDiagFlag=1))
		
		s MKBSDTumourFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),26) 	//肿瘤形态学编码标识
		continue:((MKBSDTumourFlag="Y")||(MKBSDTumourFlag=1))
		s addcount=addcount+1
		d:aliasflag'="" ..AddAliasInAutoStructData(MKBSDRowid)
		s StructuredDataID=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",MKBSDRowid,""))
		continue:(StructuredDataID'="")
		
		s structedflag=0
		//2021-12-6 先用各版本icd对照处理，后用全局化词表
		s icdre=..StructFromICDConstrast(MKBSDRowid)
		if (icdre="false")			//各版本icd对照没有匹配上
		{

		    //在全局化词表中找到完全一致的术语描述，得到他的引用位置
		    s reother= ##class(web.DHCBL.MKB.MKBGlobal).AutoProcessingStructData(MKBSDRowid)
			
		    if (reother="false")
		    {
			    //还不能结构化且频次大于3，保存到全局化词表  
			    s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
				if (MKBSDTotalFreq>=3)		//科室频次大于3
				{
					s Diag = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBSDDiag,0)		//全角转半角
					s Diag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod1(Diag)
					s Diag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod2(Diag)
					s Diag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod3(Diag)

					s existstr= ##class(web.DHCBL.MKB.MKBGlobal).IsExist(Diag,"")
					s existflag=$p(existstr,"^",1)
					if (existflag=0)		//不存在
					{
						s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()	
						s eobj.MKBGRowId=""
						
						s eobj.MKBGDesc = Diag
						s eobj.MKBGMark = "常用诊断描述"
						s eobj.MKBGState="U"  
						 
						s gre = ##class(web.DHCBL.MKB.MKBGlobal).SaveGlobalEntity(eobj)	//保存术语同时新增别名
						if (gre["true")	//保存成功
						{
							s id=$p($p(gre,":",3),"}",1)
							//$p(gre,"""",4)
							s eaobj=##class(web.Entity.MKB.MKBGloAlias).%New()
						 	s eaobj.MKBGADesc=Diag
						 	s eaobj.MKBGAParRef=id
						 	s eaobj.MKBGACEFlag="C"
						 	s eaobj.MKBGAMark="展示名,"_MKBSTBDesc	//设为展示名
						 	s eaobj.IsDisplayName="Y"
						 	s alisare= ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasEntity(eaobj)
						 	if (alisare'="false")
						 	{
								d ##class(web.DHCBL.MKB.MKBGlobal).RefHandle("1","1,2",id)
						 	}
						}
					}
					else	//存在其他术语
					{
						s Globalflag=$p(existstr,"^",2)		//是否是术语
						s TheID=$p(existstr,"^",3)
						s GlobalAlias=""
						s existGlobal=""
						if (Globalflag=1)	//是术语
						{
							s existGlobal=TheID
							s AlisaID=$o(^User.MKBGloAliasI("DescIndex",existGlobal," "_Diag,""))
						}
						else
						{
							s existGlobal=$p(TheID,"||",1)
							s GlobalAlias=$p(TheID,"||",2)
						}
						if (GlobalAlias'="")
						{
							s MKBGAMark = $lg($g(^User.MKBGlobalD(existGlobal,"ChildGloAlias",GlobalAlias)),8)
							if (MKBGAMark'[MKBSTBDesc)
							{
								//SaveAliasLog(parref, AliasRowId, desc, note, activeflag, state, seq, mark, display)
								d ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasLog(existGlobal,GlobalAlias,"", "", "", "", "", MKBGAMark_","_MKBSTBDesc, "")
							}
						}
						
					}
				}

		    }
		    else
		    {
			    s structedflag=1
		    }
		}
		else
		{
			s structedflag=1
		}
			    
		
		if (structedflag=1)	//已结构化
		{
			s count=count+1	
			s snobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		   	s snobj.MKBSDChildStructFlag = 1
		   	s snobj.MKBSDStatus="P"
			s UpdateDate=$p($h,",",1)       //上传日期
			s snobj.MKBSDDate=UpdateDate
				
		   	s fwk = snobj.%Save()
		   	d snobj.%Close()
		   	
		}
	}

 	//d ..UpdateState(base)
	q count
}

/// Creator:钟荣枫
/// CreatDate:2021-12-6
/// Description：根据各版本icd对照某个诊断，来对各个医院的诊断数据的结构化结果进行修改
/// Input：MKBICDRowid
/// Return:true 或false
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).ChangeStructByICDContrast(45349)
ClassMethod ChangeStructByICDContrast(MKBICDRowid)
{
	s result=""
	q:MKBICDRowid="" "false"
	s errorflag=0
	s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
	ts
	//Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag);
	s base=""
	for
	{
		s base=$O(^User.MKBStructuredDataI("MKBSDDiagIndex",base))	
		q:base=""
		q:errorflag=1
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$O(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(MKBICDDesc,"U"),MKBSDRowid))	
			q:MKBSDRowid=""
			q:errorflag=1
			s delre= ..DelStructOfDiag(MKBSDRowid)
			if (delre="true")	//删除结构化结果后，重新添加
			{
				//可能会出现返回false的情况，是正常的，有的各版本icd对照没有结构化结果
				s re= ..StructDataByICDContrastData(MKBICDRowid,MKBSDRowid)
			}
			else
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
		s result="true"	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-12-6
/// Description：根据各版本icd对照来进行结构化处理
/// Input：MKBSDRowid
/// Return:true 或false
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).StructFromICDConstrast(3)
ClassMethod StructFromICDConstrast(MKBSDRowid)
{
	s result="true"
	s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2) 
	
	//DescIndex On MKBICDConDesc;
	s MKBICDRowid=""
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_$zconvert(MKBSDDiag,"U"),MKBICDRowid))
		q:MKBICDRowid=""
		s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		continue:Sources'[526477
		q:MKBICDRowid'=""
	}
	if (MKBICDRowid'="")
	{
		//返回false时，没能结构化
		s re= ..StructDataByICDContrastData(MKBICDRowid,MKBSDRowid)
		s:re="false" errorflag=1
	}
	else
	{
		s result="false"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-12-8
/// Description：根据某个各版本icd对照数据，给某个数据处理工厂数据结构化处理
/// Input：MKBICDRowid 各版本icd对照数据id，MKBSDRowid 数据处理工厂数据id
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).StructDataByICDContrastData()
ClassMethod StructDataByICDContrastData(MKBICDRowid, MKBSDRowid)
{
	s result="true"
	s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,""))
	if (sequence'="")
	{
		s sequence=""
		for
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
			q:sequence=""
			q:result="false"
			s MKBICDRRowid=""
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
				q:MKBICDRRowid=""
				q:result="false"
				s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				
				s MKBICDSupplement=$lg(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid),5)
				
				s sobj=##class(User.MKBStructuredDataResult).%New(MKBSDRowid)
				d sobj.MKBSDStructDataSetObjectId(MKBSDRowid)
				s sobj.MKBSDSequence=sequence
				s sobj.MKBSDStructResultID=MKBICDRResultID
				d sobj.MKBSDTermDRSetObjectId(MKBICDResultTermdr)
				s ssc=sobj.%Save()
				d sobj.%Close()
				if (ssc'=1)
				{
					s result="false"
					b ;;false	
				}
			}
		}
	}
	else
	{
		s result="false"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-3-10
/// Description：删除某个数据处理工厂的所有数据的icd描述改为诊断描述 
/// Input：MKBSDRowid
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateICDDesc(3)
ClassMethod UpdateICDDesc(base)
{
	s errorflag=0
	s result=""
	TS
	s MKBSDRowid=0
	for
	{
		//Index BaseIndex On MKBSDBaseDr;
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		q:errorflag=1
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21) 
		s MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
		
		if (MKBSDICDDesc'=MKBSDDiag)
		{
			s snobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		   	s snobj.MKBSDICDDesc = snobj.MKBSDDiag
		   	s fwk = snobj.%Save()
		   	d snobj.%Close()
		   	if (fwk'=1)
		   	{
			   	s errorflag=1
			   	s res=$system.OBJ.DisplayError(fwk)
		   	}
		}
		if (MKBSDDiaSource["出院")
		{
			s snobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s snobj.MKBSDDiaSource ="HIS诊断"
		   	s fwk = snobj.%Save()
		   	d snobj.%Close()
		   	if (fwk'=1)
		   	{
			   	s errorflag=1
			   	s res=$system.OBJ.DisplayError(fwk)
		   	}
		}
		
		
	}
	if (errorflag=0)
	{
		tc
		s result="true"	
	}
	else
	{
		tro
		s result="false"	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-3-26
/// Description：根据文档，工厂里有这个表上没有的就删掉。
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).DeleteStructData(3)
ClassMethod DeleteStructData(path, base)
{
	s delcount=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    
	s count=0
	s errorflag=0
	
	TS
	s MKBSDRowid=0
	for
	{
		//Index BaseIndex On MKBSDBaseDr;
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		q:errorflag=1
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		
		s count=count+1
		w !,count
		
		s number=0
		s existflag=0
		Set tfile=##class(%File).%New(path)
    		d tfile.Open("R")
		for m=1:1:tfile.Size 
		{
			s tdata=tfile.Read()
			q:tdata=""
			s number=number+1
			continue:number=1  //跳过第一行
			//诊断代码	诊断名称	诊断ICD10	开始日期	结束日期	是否中医诊断

			s DataCode=$p(tdata,"	",1)	//诊断代码
			s DataDesc=$p(tdata,"	",2)	//诊断名称
			if (DataDesc="") 	//诊断描述为空
			{
				continue
			}
			
			s ICDCode=$p(tdata,"	",3)	//诊断ICD10
			s StartDate=$p(tdata,"	",4)	//开始日期
			s EndDate=$p(tdata,"	",5)	//结束日期
			if (EndDate'="")	//过滤过期数据
			{
				if (EndDate<$h)
				{
					continue	
				}
			}
			s IsFlag=$p(tdata,"	",6)	//是否中医诊断
			if (IsFlag="Y")		//是中医诊断
			{
				continue	
			}
		
			if (MKBSDDiag=DataDesc)
			{
				s existflag=1
				q
			}
		}
		c tfile
		if (existflag=0)	//删除掉数据
		{
			s delcount=delcount+1
			
			s errorflag=..DelChildOfData(MKBSDRowid)
			
			
			if (errorflag=0)
			{
				//s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)        ;先备份再更新
				//s bobj=##class(web.Entity.MKB.MKBStructuredData).%New()
				s datare= ##class(User.MKBStructuredData).%DeleteId(MKBSDRowid)
				if (datare'=1)
				{
					s errorflag=1	
				}
				else
				{
					//删除索引
					d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndexByCode(MKBSDRowid)
					d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SD",MKBSDRowid)		
				}
				
				
			}
		
		}
		
		
	}
	w "删除数据:"_delcount,!
	q "success"
}

/// Creator:钟荣枫
/// CreatDate:2021-3-26
/// Description：根据文档，工厂里没有，这表上有的（在用的西医诊断）补充上。工厂里有，表上有的检查下编码对不对，不对的修改下编码。
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateStructData(3)
ClassMethod UpdateStructData(path, base)
{
	s savecount=0
	s nosavecount=0
	s continuecount=0
	s noupcount=0
	s upcount=0
	s delcount=0
	Set file=##class(%File).%New(path)
	
	d file.Open("R")
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		//诊断代码	诊断名称	诊断ICD10	开始日期	结束日期	是否中医诊断

		s DataCode=$p(data,"	",1)	//诊断代码
		s DataDesc=$p(data,"	",2)	//诊断名称
		if (DataDesc="") 	//诊断描述为空
		{
			s continuecount=continuecount+1
			continue
		}
		
		s ICDCode=$p(data,"	",3)	//诊断ICD10
		s StartDate=$p(data,"	",4)	//开始日期
		s EndDate=$p(data,"	",5)	//结束日期
		if (EndDate'="")	//过滤过期数据
		{
			//2018/7/5 0:00:00
			if (EndDate<$h)
			{
				s continuecount=continuecount+1
				continue	
			}
		}
		s IsCFlag=$p(data,"	",6)	//是否中医诊断
		s:IsCFlag="" IsCFlag="N"
		s IsCType=$p(data,"	",7)	//是否中医症型
		s:IsCType="" IsCType="N"
		s CodeFlag=$p(data,"	",8)	//肿瘤形态学编码标志
		s:IsCType="" IsCType="N"
		s ReasonFlag=$p(data,"	",9)	//损伤中毒外部原因标志
		s:ReasonFlag="" ReasonFlag="N"
		s Remark=IsCFlag_"#"_IsCType_"#"_CodeFlag_"#"_ReasonFlag
		;w !,num
		//Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag) [ Unique ];
		s StructureID=$O(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,ICDCode,""))		//诊断+ICD编码为唯一索引 2021-04-15
		//s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(DataDesc,"U"),""))    //判断该诊断是否存在
		if (StructureID="")	//新增
		{
			s obj=##class(User.MKBStructuredData).%New()		//保存到父表
		    s obj.MKBSDDiag = DataDesc
		    d obj.MKBSDBaseDrSetObjectId(base)
		    s obj.MKBSDDiaSource = "HIS诊断"
		    s obj.MKBSDICD = ICDCode
		    s obj.MKBSDICDDesc = DataDesc
		    s obj.MKBSDDiagPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DataDesc)
		    s obj.MKBSDStatus = "N"
		    s obj.MKBSDTotalFreq = "0"
		    s obj.MKBSDNote=Remark
		    
		    s sc=obj.%Save()
		    d obj.%Close()
		    if (sc=1)		//成功
		    {
			    s savecount=savecount+1
			    ;w !,savecount
			    s id = obj.%Id()
			    d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(id)
		    }
		    else
		    {
			    ;s re=$system.OBJ.DisplayError(sc)
			    s nosavecount=nosavecount+1
		    }
		}
		else	//修改icd代码
		{
			s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(StructureID)),20)  //在ICD字段取值
			if (MKBSDIcd'=ICDCode)	//新的数据和原先的数据的icd代码不一致
			{
				s obj=##class(User.MKBStructuredData).%OpenId(StructureID) 		//保存到父表
			    s obj.MKBSDICD = ICDCode
			    s sc=obj.%Save()
			    d obj.%Close()
			    if (sc=1)		//成功
			    {
				    
				    s upcount=upcount+1
				    //删除索引
					d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(base,MKBSDIcd,StructureID)
					d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(base,ICDCode,StructureID)
					
					
				    ;w !,savecount
			    }
			    else
			    {
				    //s re=$system.OBJ.DisplayError(sc)
				    s noupcount=noupcount+1
			    }
			}
		}
	}
	c file
	k file
	w "读取数据总共"_(num-1)_"条",!
	w "保存字典:"_savecount,!
	w "保存字典失败:"_nosavecount,!
	w "修改字典:"_upcount,!
	w "修改字典失败:"_noupcount,!
	w "跳过："_continuecount,!
	w "删除字典"_delcount,!
	q "success"
}

/// Creator:钟荣枫
/// CreatDate:2021-3-29
/// Description：根据文档，判断数据处理工厂的数据和文档数据的代码差别
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).CheckSanmeData(3)
ClassMethod CheckSanmeData(path, base)
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
   	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName1=time_"数据处理工厂中没有的数据.txt"
	s exportfile1=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName1
	
    o exportfile1:"WNS"
    u exportfile1
    w "诊断代码	诊断名称	icd代码"   //注意此处是用tab隔开
    
    k ^TEMPStruct
	Set file=##class(%File).%New(path)
	
	d file.Open("R")
	s unexistcount=0
	
	s num=0
	k myFileAry
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行

		s DataCode=$p(data,"	",3)	//诊断代码
		s DataDesc=$p(data,"	",2)	//诊断名称
		if (DataDesc="") 	//诊断描述为空
		{
			continue
		}
		
		s ICDCode=$p(data,"	",3)	//诊断ICD10
		s StartDate=$p(data,"	",4)	//开始日期
		s EndDate=$p(data,"	",5)	//结束日期

		
		if (StartDate[":")		//带有时间
		{
			s StartDate=$p(StartDate," ",1)	
		}
		if (EndDate[":")		//带有时间
		{
			s EndDate=$p(EndDate," ",1)	
		}
		if (StartDate'="")
		{
			s:StartDate["/" StartDate=$Replace(StartDate,"/","-")
			s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
		}
		if (EndDate'="")
		{
			s:EndDate["/" EndDate=$Replace(EndDate,"/","-")
			s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过期
		{
			continue
		}
		
		s IsCFlag=$p(data,"	",6)	//是否中医诊断
		s:IsCFlag="" IsCFlag="N"
		s IsCType=$p(data,"	",7)	//是否中医症型
		s:IsCType="" IsCType="N"
		s CodeFlag=$p(data,"	",8)	//肿瘤形态学编码标志
		s:IsCType="" IsCType="N"
		s ReasonFlag=$p(data,"	",9)	//损伤中毒外部原因标志
		s:ReasonFlag="" ReasonFlag="N"
		s ^TEMPStruct("temp",DataCode,DataDesc,ICDCode,num)=data
		
		s StructureID=$O(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,DataCode,""))		//诊断+ICD编码为唯一索引 2021-04-15
		//s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(DataDesc,"U"),""))    //判断该诊断是否存在
		if (StructureID="")	//判断差异
		{
			s unexistcount=unexistcount+1
			w !,DataCode_"	"_DataDesc_"	"_ICDCode
		}
	}
	c file
	k file
	
	c exportfile1
	
	s fileName2=time_"Excel中没有的数据.txt"
	s exportfile2=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName2
	
    o exportfile2:"WNS"
    u exportfile2
    w "诊断代码	诊断名称	原先的icd代码"   //注意此处是用tab隔开
    
	s MKBSDRowid=0
	for
	{
		//Index BaseIndex On MKBSDBaseDr;
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
		s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
		s MKBSDTCMDiagFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),24)
		s MKBSDTCMSynFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),25)
		s MKBSDTumourFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),26)
		s MKBSDInjuryFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),27)
		s MKBSDDateActiveFrom=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),28)
		s MKBSDDateActiveTo=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),29)
		
		
		if ($d(^TEMPStruct("temp",MKBSDIcd,MKBSDDiag,MKBSDIcd))<=0)	//在Excel里不存在
		{
			w !,MKBSDIcd_"	"_MKBSDDiag_"	"_MKBSDIcd
		}
		else
		{
			s count=$o(^TEMPStruct("temp",MKBSDIcd,MKBSDDiag,MKBSDIcd,""))
			s data=^TEMPStruct("temp",MKBSDIcd,MKBSDDiag,MKBSDIcd,count)
			s DataCode=$p(data,"	",3)	//诊断代码
			s DataDesc=$p(data,"	",2)	//诊断名称
			if (DataDesc="") 	//诊断描述为空
			{
				w !,MKBSDIcd_"	"_MKBSDDiag_"	"_MKBSDIcd
			}
			s ICDCode=$p(data,"	",3)	//诊断ICD10
			s StartDate=$p(data,"	",4)	//开始日期
			s EndDate=$p(data,"	",5)	//结束日期
			if (StartDate[":")		//带有时间
			{
				s StartDate=$p(StartDate," ",1)	
			}
			if (EndDate[":")		//带有时间
			{
				s EndDate=$p(EndDate," ",1)	
			}
			if (StartDate'="")
			{
				s:StartDate["/" StartDate=$Replace(StartDate,"/","-")
				s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
			}
			if (EndDate'="")
			{
				s:EndDate["/" EndDate=$Replace(EndDate,"/","-")
				s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
			}
			if ((EndDate'="")&&(EndDate<+$h))	//过期
			{
				w !,MKBSDIcd_"	"_MKBSDDiag_"	"_MKBSDIcd
			}
			s IsCFlag=$p(data,"	",6)	//是否中医诊断
			s:IsCFlag="" IsCFlag="N"
			s IsCType=$p(data,"	",7)	//是否中医症型
			s:IsCType="" IsCType="N"
			s CodeFlag=$p(data,"	",8)	//肿瘤形态学编码标志
			s:IsCType="" IsCType="N"
			s ReasonFlag=$p(data,"	",9)	//损伤中毒外部原因标志
			s:ReasonFlag="" ReasonFlag="N"
			
			if ((IsCFlag'=MKBSDTCMDiagFlag)||(IsCType'=MKBSDTCMSynFlag)||(CodeFlag'=MKBSDTumourFlag)||(MKBSDInjuryFlag'=ReasonFlag))
			{
				w !,MKBSDIcd_"	"_MKBSDDiag_"	"_MKBSDIcd
			}
			
		}
		
		
	}
	c exportfile2
	
	k ^TEMPStruct
	Q fileName1
}

/// Creator:钟荣枫
/// CreatDate:2021-3-26
/// Description：根据比对代码不一致文档，第三列带M的数据，需要替换原先的代码
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).ChangeICDCodeByFile(3)
ClassMethod ChangeICDCodeByFile(path, base)
{
	s noupcount=0
	s upcount=0
	s continuecount=0
	Set file=##class(%File).%New(path)
	
	d file.Open("R")
	k ^TempmyFileAry
	
	s num=0
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		//诊断代码	诊断名称	诊断ICD10	开始日期	结束日期	是否中医诊断
		s ^TempmyFileAry(i)=data
		
	}
	s number=0
	for
	{
		s number=$o(^TempmyFileAry(number))
		q:number=""
		s DataCode=$p(^TempmyFileAry(number),"	",1)	//诊断代码
		s DataDesc=$p(^TempmyFileAry(number),"	",2)	//诊断名称
		
		if (DataDesc="") 	//诊断描述为空
		{
			s continuecount=continuecount+1
			continue
		}
		
		s OldCode=$p(^TempmyFileAry(number),"	",3)	//诊断ICD10
		continue:(OldCode'["M")
		
		s samecount=0
		s newnumber=0
		for
		{
			s newnumber=$o(^TempmyFileAry(newnumber))
			q:newnumber=""
			s NewDataDesc=$p(^TempmyFileAry(newnumber),"	",2)	//诊断名称
			s:NewDataDesc=DataDesc samecount=samecount+1
		}
		
		if (samecount>=2)	//在表里的数据超过两个
		{
			continue
		}
		;w !,num
		//Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag) [ Unique ];
		s StructureID=$O(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,OldCode,""))		//诊断+ICD编码为唯一索引 2021-04-15
		//s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(DataDesc,"U"),""))    //判断该诊断是否存在
		if (StructureID="")	//新增
		{
			s continuecount=continuecount+1
		}
		else	//修改icd代码
		{
			
			s obj=##class(User.MKBStructuredData).%OpenId(StructureID) 		//保存到父表
			s oldICDCode=obj.MKBSDICD
		    s obj.MKBSDICD = DataCode
		    s sc=obj.%Save()
		    d obj.%Close()
		    if (sc=1)		//成功
		    {
			    s upcount=upcount+1
			    d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(base,oldICDCode,StructureID)
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(base,DataCode,StructureID)
			    ;w !,savecount
		    }
		    else
		    {
			    //s re=$system.OBJ.DisplayError(sc)
			    s noupcount=noupcount+1
		    }
			
		}
	}
	c file
	k file
	w "读取数据总共"_(num-1)_"条",!
	w "修改字典:"_upcount,!
	w "修改字典失败:"_noupcount,!
	w "跳过："_continuecount,!
	q "success"
}

/// Creator:钟荣枫
/// CreatDate:2021-3-31
/// Description：根据文档，导入数据到西南医大数据处理工厂，原先只导入西医，如今也要导入中医诊断，同时将几个标志保存到备注里
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).ImportStructData(3)
ClassMethod ImportStructData(path, base)
{
	s savecount=0
	s nosavecount=0
	s continuecount=0
	s noupcount=0
	s upcount=0
	s delcount=0
	Set file=##class(%File).%New(path)
	
	d file.Open("R")
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		//诊断代码	诊断名称	诊断ICD10	开始日期	结束日期	是否中医诊断

		s DataCode=$p(data,"	",1)	//诊断代码
		s DataDesc=$p(data,"	",2)	//诊断名称
		if (DataDesc="") 	//诊断描述为空
		{
			s continuecount=continuecount+1
			continue
		}
		
		s ICDCode=$p(data,"	",3)	//诊断ICD10
		s StartDate=$p(data,"	",4)	//开始日期
		s EndDate=$p(data,"	",5)	//结束日期
		if (EndDate'="")	//过滤过期数据
		{
			//2018/7/5 0:00:00
			if (EndDate<$h)
			{
				s continuecount=continuecount+1
				continue	
			}
		}
		s IsCFlag=$p(data,"	",6)	//是否中医诊断
		s:IsCFlag="" IsCFlag="N"
		s IsCType=$p(data,"	",7)	//是否中医症型
		s:IsCType="" IsCType="N"
		s CodeFlag=$p(data,"	",8)	//肿瘤形态学编码标志
		s:IsCType="" IsCType="N"
		s ReasonFlag=$p(data,"	",9)	//损伤中毒外部原因标志
		s:ReasonFlag="" ReasonFlag="N"
		s Remark=IsCFlag_"#"_IsCType_"#"_CodeFlag_"#"_ReasonFlag
		
		s StructureID=$O(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,ICDCode,""))		//诊断+ICD编码为唯一索引 2021-04-15
		//s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(DataDesc,"U"),""))    //判断该诊断是否存在
		if (StructureID="")	//新增
		{
			s obj=##class(User.MKBStructuredData).%New()		//保存到父表
		    s obj.MKBSDDiag = DataDesc
		    d obj.MKBSDBaseDrSetObjectId(base)
		    s obj.MKBSDDiaSource = "HIS诊断"
		    s obj.MKBSDICD = ICDCode
		    s obj.MKBSDICDDesc = DataDesc
		    s obj.MKBSDDiagPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DataDesc)
		    s obj.MKBSDStatus = "N"
		    s obj.MKBSDTotalFreq = "0"
		    s obj.MKBSDNote=Remark
		    
		    s sc=obj.%Save()
		    d obj.%Close()
		    if (sc=1)		//成功
		    {
			    s savecount=savecount+1
			    s id = obj.%Id()
			    d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(id)
		    }
		    else
		    {
			    s nosavecount=nosavecount+1
		    }
		}
		else	//修改icd代码
		{
			//保存备注
			s obj=##class(User.MKBStructuredData).%OpenId(StructureID) 		//保存到父表
			s obj.MKBSDNote=Remark
		    s sc=obj.%Save()
		    d obj.%Close()
		    if (sc=1)		//成功
		    {
			    s upcount=upcount+1
		    }
		    else
		    {
			    s noupcount=noupcount+1
		    }
			
		}
	}
	w "读取数据总共"_(num-1)_"条",!
	w "保存字典:"_savecount,!
	w "保存字典失败:"_nosavecount,!
	w "修改字典:"_upcount,!
	w "修改字典失败:"_noupcount,!
	w "跳过："_continuecount,!
	w "删除字典"_delcount,!
	q "success"
}

/// Creator：钟荣枫		
/// CreatDate: 2021-4-6
/// Description：获取数据处理工厂中的数据，或者各版本icd对照的数据
/// Table:
/// Input:basedesc  医院描述,code icd代码， desc icd描述，structdesc 结构化结果，logicalstr 逻辑关系 ，relationstr 条件关系详情
/// Output:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetICDJsonList("东华ICD","","","","条件1","1:诊断表达式:E:15038","",20,1)
ClassMethod GetICDJsonList(basedesc As %String, code As %String, desc As %String, structdesc As %String, logicalstr, relationstr, presearchstr As %String, rows As %String, page As %String)
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s:$d(^TEMPICDOutPut)<=0 ^TEMPICDOutPut=""
	w "{""rows"":["
	s jsonstr=""
	s total=0	
	if (basedesc'="")
	{
		s Source=basedesc
		s:(basedesc="东华ICD") basedesc="东华数据处理工厂"
		
		s logicalstr = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(logicalstr,0)	//全角转半角
		s base=$o(^User.MKBStructuredBaseI("DescIndex"," "_basedesc,0))
		if ($O(^User.MKBStructuredDataI("BaseIndex",base,""))'="")
		{
			s str=""
			if (presearchstr'="")		//有指定深入查询范围
			{
				s str=presearchstr
			}
			else	//没有指定，按照条件包含来
			{
				s newlo=""
				for
				{
					s newlo=$o(^TEMPICDOutPut(basedesc,newlo))
					q:newlo=""
					q:str'=""
					continue:logicalstr'[newlo
					s newrel=""
					for
					{
						s newrel=$o(^TEMPICDOutPut(basedesc,newlo,newrel))
						q:newrel=""
						continue:relationstr'[newrel
						s str=newlo_"----"_newrel
						q:str'=""
					}
				} 
			}
			k ^TEMPICDSearch
			if (str'="")	//可以得到一个特定的范围
			{
				s newlo=$p(str,"----",1)
				s newrel=$p(str,"----",2)
				s ID=""
				for
				{
					s ID=$o(^TEMPICDOutPut(basedesc,newlo,newrel,ID))
					q:ID=""
					s ^TEMPICDSearch(ID)=""
				}
			}
			else		//在全部中查询
			{
				if ($l(relationstr,"^")=1)		//只有一个条件
				{
					//且条件是代码或者描述	1:ICD代码:E:A00.100
					s casedesc=$p(relationstr,":",2)
					s icd=""
					s diag=""
					if (casedesc="ICD代码")
					{
						s icd=$p(relationstr,":",4)
					}
					elseif (casedesc="ICD描述")	
					{
						s diag=$p(relationstr,":",4)
					}
					d ..GetFilterData(base,icd,diag,"","")
					MERGE ^TEMPICDSearch=^TempStructI
				}
				else		//查找全部
				{
					s ID=""
					for
					{
						s ID=$o(^User.MKBStructuredDataI("BaseIndex",base,ID))
						q:ID=""
						s ^TEMPICDSearch(ID)=""
					}
				}
			}
			if ($d(^TEMPICDSearch)>0)
			{
				s RowID=""
				for
				{
					s RowID=$O(^TEMPICDSearch(RowID))	
					q:RowID=""
					s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(RowID)),2) 
					//continue:(MKBSDDiag'="外下唇恶性肿瘤")
					s ICDNumber=$lg($g(^User.MKBStructuredDataD(RowID)),20)  //在ICD字段取值
					s ICDNumber=##class(web.DHCBL.BDP.FunLib).EvalJSONB(ICDNumber)
					s ICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBSDDiag)

						
					s Result=""
					s StructResultIDs=""
					s sequence=0
					for
					{
						s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",RowID,sequence))
						q:sequence=""
						
						s MKBSDRRowid=0
						for
						{
							s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",RowID,sequence,MKBSDRRowid))
							q:MKBSDRRowid=""
							s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(RowID,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
							s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(RowID,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
							continue:MKBSDResultTermdr=""
							s SResult=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
							s MKBSDSupplement=$lg(^User.MKBStructuredDataD(RowID,"MKBSDStructResult",MKBSDRRowid),5)
							if MKBSDSupplement'=""
							{
								if SResult["]"
								{
									s str=$e(SResult,1,*-1)
									s SResult=str_",("_MKBSDSupplement_")]"
								}
								else
								{
									s SResult=SResult_"[("_MKBSDSupplement_")]"
								}
							}					
							s:Result'="" Result=Result_"<br/>"_SResult
							s:Result="" Result=SResult
							s StructResultID=""
							s:MKBSDResultID="" StructResultID=MKBSDResultTermdr
							s:MKBSDResultID'="" StructResultID=MKBSDResultTermdr_"-"_MKBSDResultID
							if (StructResultIDs="")
							{
								s StructResultIDs=StructResultID
							}
							else
							{
								s StructResultIDs=StructResultIDs_"<br/>"_StructResultID
							}
							
						}
					}
					s outputflag=0
					k ^TEMPICDCount
					if (logicalstr'="")		//逻辑关系不为空
					{
						s newlogicalstr="("_logicalstr_")"
						s newlogicalstr=$Replace(newlogicalstr,"且","&&")
						s newlogicalstr=$Replace(newlogicalstr,"或","||")
						
						//重新置0
						for s1=1:1:$l(relationstr,"^")
						{
							s relation=$p(relationstr,"^",s1)
							s num=$p(relation,":",1)
							s Title=$p(relation,":",2)
							s rel=$p(relation,":",3)
							s Value=$p(relation,":",4,*)	//有可能是表达式
							continue:(Title="")
							s ^TEMPICDCount(s1,Title,rel,Value)=0
						}
						s Number=""
						for
						{
							s Number=$o(^TEMPICDCount(Number))
							q:Number=""
							//一个Number对应一个title、一个关系和一个value
							s Title=$o(^TEMPICDCount(Number,""))
							q:Title=""
							s rel=$o(^TEMPICDCount(Number,Title,""))
							q:rel=""
							s Value=$o(^TEMPICDCount(Number,Title,rel,""))
							q:Value=""
							
							continue:(^TEMPICDCount(Number,Title,rel,Value)=1)		//已满足条件
							if (Title="ICD代码")
							{
								if (rel="E")	//等于
								{
									if (ICDNumber=Value)
									{
										s ^TEMPICDCount(Number,Title,rel,Value)=1
									}
								}
								else		//包含
								{
									if (ICDNumber[Value)
									{
										s ^TEMPICDCount(Number,Title,rel,Value)=1
									}
								}
									
							}
							elseif (Title="ICD描述")
							{
								if (rel="E")	//等于
								{
									if (ICDDesc=Value)
									{
										s ^TEMPICDCount(Number,Title,rel,Value)=1
									}
								}
								else		//包含
								{
									if (ICDDesc[Value)
									{
										s ^TEMPICDCount(Number,Title,rel,Value)=1
									}
								}
							}
							elseif (Title="诊断表达式")
							{
								for s1=1:1:$p(StructResultIDs,"<br/>")
								{
									s StructResultID=$p(StructResultIDs,"<br/>",s1)
									continue:StructResultID=""
									if (rel="E")	//等于
									{
										if (StructResultID=Value)
										{
											s ^TEMPICDCount(Number,Title,rel,Value)=1
										}
									}
									else		//包含
									{
										s oldTerm=$p(StructResultID,"-",1)
										s sTerm=$p(Value,"-",1)
										if (oldTerm=sTerm)		//中心词一致
										{
											s newStruct= ##class(web.DHCBL.MKB.MKBBirthToDeadDiaArrange).AttributeAppend(StructResultID,Value)
											if (newStruct=StructResultID)	//属性全包含
											{
												s ^TEMPICDCount(Number,Title,rel,Value)=1
											}
										}
									}
								}
							
							}
						}
						b ;1				
						//组合条件拼接
						s endflag=0
						s count=""
						for
						{
							s count=$o(^TEMPICDCount(count),-1)
							q:count=""
							q:endflag=1
							s Title=$o(^TEMPICDCount(count,""))
							q:Title=""
							s rel=$o(^TEMPICDCount(count,Title,""))
							q:rel=""
							s Value=$o(^TEMPICDCount(count,Title,rel,""))
							q:Value=""
							s flag=^TEMPICDCount(count,Title,rel,Value)
							for s2=20:-1:1
							{
								//s flag=^TEMPICDCount(count)
								if (newlogicalstr[("条件"_s2))	//条件序号可能不是全都有    如 1,2,4,7
								{
									s newlogicalstr=$Replace(newlogicalstr,"条件"_s2,flag)
									q
								}
							}
								
						}
						
						s TheValue=##class(web.DHCBL.BDP.FunLib).XcodeStr(newlogicalstr)
						s:TheValue=1 outputflag=1

					}
					else
					{
						s outputflag=1
					}
					if (outputflag=1)
					{
						
						s total=total+1
						s ^TEMPICDOutPut(basedesc,logicalstr,relationstr,RowID)=""
						//s ^TEMPICDOutPut(basedesc,newlo,newrel,ID)=""
						if (total<stpage) continue
						if (total<=endpage)
						{
							//RowID,ICDNumber,ICDDesc,Result,Source
							s thisStr="{""RowID"":"""_RowID_""",""ICDNumber"":"""_ICDNumber_""",""ICDDesc"":"""_ICDDesc_""",""Result"":"""_Result_""",""Source"":"""_Source_"""}"
							if (jsonstr'="")
							{ 
								w ","
								s jsonstr=thisStr
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
		}
	}
	w "], ""total"":"_total_"}"
	q ""
}

/// Creator：钟荣枫		
/// CreatDate: 2021-4-6
/// Description：获取数据处理工厂中的数据，或者各版本icd对照的数据
/// Table:
/// Input:basedesc  医院描述,code icd代码， desc icd描述，structdesc 结构化结果，logicalstr 逻辑关系 ，relationstr 条件关系详情
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetICDList","东华ICD","","","","条件1且条件2","1:ICD描述:C:恶性肿瘤^2:ICD代码:C:C00.1")
Query GetICDList(basedesc As %String, code As %String, desc As %String, structdesc As %String, logicalstr, relationstr, presearchstr As %String, rows As %String, page As %String) As %Query(ROWSPEC = "RowID,ICDNumber,ICDDesc,Result,Source")
{
}

ClassMethod GetICDListExecute(ByRef qHandle As %Binary, basedesc As %String, code As %String, desc As %String, structdesc As %String, logicalstr, relationstr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1 
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	w "{""rows"":["
	s jsonstr=""
	s total=0	
	
	q:basedesc="" ""
	s Source=basedesc
	s:(basedesc="东华ICD") basedesc="东华数据处理工厂"
	
	s logicalstr = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(logicalstr,0)	//全角转半角
	s base=$o(^User.MKBStructuredBaseI("DescIndex"," "_basedesc,0))
	q:$O(^User.MKBStructuredDataI("BaseIndex",base,""))="" ""
	
	
	// ^TEMPICDOutPut 	//查询历史
	s str=""
	
	
	k ^TempStructI
	k ^TEMPICDCount
	k ^TEMPICDSearch
	
	if ($l(relationstr,"^")=1)		//只有一个条件
	{
		//且条件是代码或者描述	1:ICD代码:E:A00.100
		s casedesc=$p(relationstr,":",2)
		s icd=""
		s diag=""
		if (casedesc="ICD代码")
		{
			s icd=$p(relationstr,":",4)
		}
		elseif (casedesc="ICD描述")	
		{
			s diag=$p(relationstr,":",4)
		}
		d ..GetFilterData(base,icd,diag,"","")
		MERGE ^TEMPICDSearch=^TempStructI
	}
	else
	{
		s RowID=0
		for
		{
			//Index BaseIndex On MKBSDBaseDr;
			s RowID=$O(^User.MKBStructuredDataI("BaseIndex",base,RowID))	
			q:RowID=""
			s ^TEMPICDSearch(RowID)=""
		}
	}
	
	b ;1
	if ($d(^TEMPICDSearch)>0)
	{
		
		s RowID=0
		for
		{
			s RowID=$O(^TEMPICDSearch(RowID))	
			q:RowID=""
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(RowID)),2) 
			//continue:(MKBSDDiag'="外下唇恶性肿瘤")
			s ICDNumber=$lg($g(^User.MKBStructuredDataD(RowID)),20)  //在ICD字段取值
			s ICDNumber=##class(web.DHCBL.BDP.FunLib).EvalJSONB(ICDNumber)
			s ICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBSDDiag)

				
			s Result=""
			s StructResultIDs=""
			s sequence=0
			for
			{
				s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",RowID,sequence))
				q:sequence=""
				
				s MKBSDRRowid=0
				for
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",RowID,sequence,MKBSDRRowid))
					q:MKBSDRRowid=""
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(RowID,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(RowID,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					continue:MKBSDResultTermdr=""
					s SResult=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(RowID,"MKBSDStructResult",MKBSDRRowid),5)
					if MKBSDSupplement'=""
					{
						if SResult["]"
						{
							s str=$e(SResult,1,*-1)
							s SResult=str_",("_MKBSDSupplement_")]"
						}
						else
						{
							s SResult=SResult_"[("_MKBSDSupplement_")]"
						}
					}					
					s:Result'="" Result=Result_"<br/>"_SResult
					s:Result="" Result=SResult
					s StructResultID=""
					s:MKBSDResultID="" StructResultID=MKBSDResultTermdr
					s:MKBSDResultID'="" StructResultID=MKBSDResultTermdr_"-"_MKBSDResultID
					if (StructResultIDs="")
					{
						s StructResultIDs=StructResultID
					}
					else
					{
						s StructResultIDs=StructResultIDs_"<br/>"_StructResultID
					}
					
				}
			}
			s outputflag=0
			if (logicalstr'="")		//逻辑关系不为空
			{
				s newlogicalstr="("_logicalstr_")"
				s newlogicalstr=$Replace(newlogicalstr,"且","&&")
				s newlogicalstr=$Replace(newlogicalstr,"或","||")
				
				//重新置0
				for s1=1:1:$l(relationstr,"^")
				{
					s relation=$p(relationstr,"^",s1)
					s num=$p(relation,":",1)
					s Title=$p(relation,":",2)
					s rel=$p(relation,":",3)
					s Value=$p(relation,":",4,*)	//有可能是表达式
					continue:(Title="")
					s ^TEMPICDCount(s1,Title,rel,Value)=0
				}
				s Number=""
				for
				{
					s Number=$o(^TEMPICDCount(Number))
					q:Number=""
					//一个Number对应一个title、一个关系和一个value
					s Title=$o(^TEMPICDCount(Number,""))
					q:Title=""
					s rel=$o(^TEMPICDCount(Number,Title,""))
					q:rel=""
					s Value=$o(^TEMPICDCount(Number,Title,rel,""))
					q:Value=""
					
					continue:(^TEMPICDCount(Number,Title,rel,Value)=1)		//已满足条件
					if (Title="ICD代码")
					{
						if (rel="E")	//等于
						{
							if (ICDNumber=Value)
							{
								s ^TEMPICDCount(Number,Title,rel,Value)=1
							}
						}
						else		//包含
						{
							if (ICDNumber[Value)
							{
								s ^TEMPICDCount(Number,Title,rel,Value)=1
							}
						}
							
					}
					elseif (Title="ICD描述")
					{
						if (rel="E")	//等于
						{
							if (ICDDesc=Value)
							{
								s ^TEMPICDCount(Number,Title,rel,Value)=1
							}
						}
						else		//包含
						{
							if (ICDDesc[Value)
							{
								s ^TEMPICDCount(Number,Title,rel,Value)=1
							}
						}
					}
					elseif (Title="诊断表达式")
					{
						for s1=1:1:$p(StructResultIDs,"<br/>")
						{
							s StructResultID=$p(StructResultIDs,"<br/>",s1)
							continue:StructResultID=""
							if (rel="E")	//等于
							{
								if (StructResultID=Value)
								{
									s ^TEMPICDCount(Number,Title,rel,Value)=1
								}
							}
							else		//包含
							{
								s oldTerm=$p(StructResultID,"-",1)
								s sTerm=$p(Value,"-",1)
								if (oldTerm=sTerm)		//中心词一致
								{
									s newStruct= ##class(web.DHCBL.MKB.MKBBirthToDeadDiaArrange).AttributeAppend(StructResultID,Value)
									if (newStruct=StructResultID)	//属性全包含
									{
										s ^TEMPICDCount(Number,Title,rel,Value)=1
									}
								}
							}
						}
					
					}
				}
				s endflag=0
				s count=""
				for
				{
					s count=$o(^TEMPICDCount(count),-1)
					q:count=""
					q:endflag=1
					s Title=$o(^TEMPICDCount(count,""))
					q:Title=""
					s rel=$o(^TEMPICDCount(count,Title,""))
					q:rel=""
					s Value=$o(^TEMPICDCount(count,Title,rel,""))
					q:Value=""
					s flag=^TEMPICDCount(count,Title,rel,Value)
					for s2=20:-1:1
					{
						//s flag=^TEMPICDCount(count)
						if (newlogicalstr[("条件"_s2))	//条件序号可能不是全都有    如 1,2,4,7
						{
							s newlogicalstr=$Replace(newlogicalstr,"条件"_s2,flag)
							q
						}
					}
						
				}
				
				s TheValue=##class(web.DHCBL.BDP.FunLib).XcodeStr(newlogicalstr)
				b ;re
				s:TheValue=1 outputflag=1

			}
			else
			{
				s outputflag=1
			}
			if (outputflag=1)
			{
				d OutputRow
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,ICDNumber,ICDDesc,Result,Source)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDListExecute ]
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

/// Creator:钟荣枫
/// CreatDate:2021-4-21
/// Description：北京大学第一医院  根据文档，计算科室频次
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).ImportFileToCountFreq(3)
ClassMethod ImportFileToCountFreq(path, base)
{
	s continuecount=0
	s nullcount=0
	s upcount=0
	s noupcount=0
	Set file=##class(%File).%New(path)
	
	d file.Open("R")
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行

		s DataDesc=$p(data,"	",1)	//诊断名称
		
		s ICDCode=$p(data,"	",2)	//ICD
		s Freq=$p(data,"	",3)	//频次
		s DataDesc = $Zstrip(DataDesc,"<>W")
		s ICDCode = $Zstrip(ICDCode,"<>W")
		s Freq = $Zstrip(Freq,"<>W")
		if (DataDesc="") 	//诊断描述为空
		{
			s continuecount=continuecount+1
			continue
		}
		
		s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(DataDesc,"U"),""))    //判断该诊断是否存在
		if (StructureID="")
		{
			s newDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(DataDesc,0)
			s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
			if (StructureID="")
			{
				s newDesc=" "_DataDesc
				s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
			}
			if (StructureID="")
			{
				s newDesc=DataDesc_" "
				s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
			}
			
			if ((ICDCode'="")&&(StructureID=""))	//有的诊断的诊断名称分成两份了
			{
				if (ICDCode[" ")
				{
					s newCode="("_$p(ICDCode," ",1)_")"_$p(ICDCode," ",2)
					s newDesc=DataDesc_newCode
					s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
					if (StructureID="")
					{
						s newCode=" ("_$p(ICDCode," ",1)_")"_$p(ICDCode," ",2)
						s newDesc=DataDesc_newCode
						s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
						if (StructureID="")
						{
							s newDesc=" "_newDesc
							s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
						}
					
					}
				}
				
				if (StructureID="")
				{
					s newDesc=DataDesc_"("_ICDCode_")"
					s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
					if (StructureID="")
					{
						s newDesc=" "_newDesc
						s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
					}
				}
				if (StructureID="")
				{
					s newDesc=DataDesc_" ("_ICDCode_")"
					s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
					if (StructureID="")
					{
						s newDesc=" "_newDesc
						s StructureID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",base," "_$zconvert(newDesc,"U"),""))    //判断该诊断是否存在
					}
				}
			}
		}
		
		if (StructureID'="")	//修改
		{
				
			//保存备注
			s obj=##class(User.MKBStructuredData).%OpenId(StructureID) 		//保存到父表
			s:obj.MKBSDTotalFreq="" obj.MKBSDTotalFreq=0
			s obj.MKBSDTotalFreq = obj.MKBSDTotalFreq+Freq
		    s sc=obj.%Save()
		    d obj.%Close()
		    if (sc=1)		//成功
		    {
			    s upcount=upcount+1
		    }
		    else
		    {
			    s noupcount=noupcount+1
		    }
			
		}
		else
		{
			s nullcount=nullcount+1	
		}
	}
	c file
	k file
	w "读取数据总共"_(num-1)_"条",!
	w "修改字典:"_upcount,!
	w "修改字典失败:"_noupcount,!
	w "跳过："_continuecount,!
	w "诊断为空："_nullcount,!
	q "success"
}

/// Creator:钟荣枫
/// CreatDate:2021-4-21
/// Description：删除中医诊断的结构化
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).DelStructOfTCMDiag()
ClassMethod DelStructOfTCMDiag()
{
	s result=""
	s errorflag=0
	s count=0
	TS
	s base=""
	for
	{
		s base=$O(^User.MKBStructuredDataI("BaseIndex",base))
		q:base=""
		s MKBSDRowid=0
		for
		{
			//Index BaseIndex On MKBSDBaseDr;
			s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
			q:MKBSDRowid=""
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  
			s MKBSDTCMDiagFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),24) 	//中医诊断标识
			continue:(MKBSDTCMDiagFlag'="Y")		//过滤非中医诊断
			s StructuredDataID=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",MKBSDRowid,""))
			continue:(StructuredDataID="")		//过滤没结构化数据
			//删除关联的结构化数据子表数据
			s sequence=""
			for
			{
				s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence))
				q:sequence=""
				q:errorflag=1
			 
				s MKBSDRRowid=""
				for
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
					q:MKBSDRRowid=""
					q:errorflag=1
					s RowID=MKBSDRowid_"||"_MKBSDRRowid
					s structre= ##class(User.MKBStructuredDataResult).%DeleteId(RowID)
					s:structre'=1 errorflag=1
				}
			}
			if (errorflag'=1) 
			{
				s count=count+1
				s nobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			   	s nobj.MKBSDChildStructFlag = 0
			   	s nobj.MKBSDStatus="N"
			   	s fwk = nobj.%Save()
			   	d nobj.%Close()
			}
			
		}
	}
	if (errorflag=1)
	{
		s result="false"
		tro	
	}
	else
	{
		s result=count
		tc	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-6-4
/// Description：通过诊断描述获取结构化表达式描述和id串
/// Input：MKBSDDiag诊断描述
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetStructStrByDiag()
ClassMethod GetStructStrByDiag(MKBSDDiag)
{
	//全局化词表
	s result=""
	s structvalue=##class(web.DHCBL.MKB.MKBGlobal).GetStructValueByDesc(MKBSDDiag)
	if (structvalue="")
	{
		s MatchRowID=""
		//Index DescIndex On MKBICDConDesc;
		//国标2.0对照
		s MKBICDRowid=""
		for
		{
			s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_$zconvert(MKBSDDiag,"U"),MKBICDRowid))
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
			continue:(MKBICDSource'["疾病分类与代码国家临床版2.0")
			//s MatchRowID=MKBICDRowid
			s seq=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,""))
			s:seq'="" MatchRowID=MKBICDRowid
			
			q:MatchRowID'=""
		}
		
	
		//剩下的用其他三个版本的对照
		if (MatchRowID="")	
		{
			for
			{
				s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_$zconvert(MKBSDDiag,"U"),MKBICDRowid))
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
				s seq=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,""))
				s:seq'="" MatchRowID=MKBICDRowid
				q:MatchRowID'=""
			}
		}
			
		if (MatchRowID'="")
		{
			s sequence=0
			for
			{
				s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MatchRowID,sequence))
				q:sequence=""
				s MKBICDRRowid=0
				for
				{
					s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MatchRowID,sequence,MKBICDRRowid))
					q:MKBICDRRowid=""
					s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MatchRowID,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
					s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MatchRowID,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
					if (structvalue="")
					{
						s structvalue=MKBICDRResultID_"-"_MKBICDResultTermdr
					}
					else
					{
						s structvalue=structvalue_"&&"_MKBICDRResultID_"-"_MKBICDResultTermdr
					}
				}
			}
		}
	}
	if (structvalue'="")
	{
		for m=1:1:$l(structvalue,"&&")
		{
			s piece=$p(structvalue,"&&",m)
			continue:piece=""
			s TermDR=$p(piece,"-",1)
			s DetailValue=$p(piece,"-",2)
			s structdesc=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(DetailValue,TermDR)
			s result=piece_"#"_structdesc
		}
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-6-8
/// Description：根据文档，修改处理工厂中开始日期和结束日期与Excel不一致的数据
/// Input：path ,base
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).UPdateDateByFile()
ClassMethod UPdateDateByFile(path, base)
{

	Set file=##class(%File).%New(path)
	
	d file.Open("R")
	s updatecount=0
	
	s num=0
	k myFileAry
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行

		s DataCode=$p(data,"	",3)	//诊断代码
		s DataDesc=$p(data,"	",2)	//诊断名称
		if (DataDesc="") 	//诊断描述为空
		{
			continue
		}
		
		s ICDCode=$p(data,"	",3)	//诊断ICD10
		s StartDate=$p(data,"	",4)	//开始日期
		s EndDate=$p(data,"	",5)	//结束日期

		
		if (StartDate[":")		//带有时间
		{
			s StartDate=$p(StartDate," ",1)	
		}
		if (EndDate[":")		//带有时间
		{
			s EndDate=$p(EndDate," ",1)	
		}
		if (StartDate'="")
		{
			s:StartDate["/" StartDate=$Replace(StartDate,"/","-")
			s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
		}
		if (EndDate'="")
		{
			s:EndDate["/" EndDate=$Replace(EndDate,"/","-")
			s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过期
		{
			continue
		}
		
		s IsCFlag=$p(data,"	",6)	//是否中医诊断
		s:IsCFlag="" IsCFlag="N"
		s IsCType=$p(data,"	",7)	//是否中医症型
		s:IsCType="" IsCType="N"
		s CodeFlag=$p(data,"	",8)	//肿瘤形态学编码标志
		s:IsCType="" IsCType="N"
		s ReasonFlag=$p(data,"	",9)	//损伤中毒外部原因标志
		s:ReasonFlag="" ReasonFlag="N"
		
		s MKBSDRowid=$O(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,DataCode,""))		//诊断+ICD编码为唯一索引 2021-04-15
		if (MKBSDRowid'="")	//判断存在
		{
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
			s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
			s MKBSDTCMDiagFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),24)
			s MKBSDTCMSynFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),25)
			s MKBSDTumourFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),26)
			s MKBSDInjuryFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),27)
			s MKBSDDateActiveFrom=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),28)
			s MKBSDDateActiveTo=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),29)
			if ((StartDate'=MKBSDDateActiveFrom)||(EndDate'=MKBSDDateActiveTo))
			{
				s updatecount=updatecount+1
				s obj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				s UpdateDate=$p($h,",",1)       //上传日期
				s obj.MKBSDDate=UpdateDate
				s obj.MKBSDDateActiveFrom=StartDate
				s obj.MKBSDDateActiveTo=EndDate
					
			   	s fwk = obj.%Save()
			   	d obj.%Close()
			}
		}
	}
	c file
	k file
	Q updatecount
}

/// Creator:钟荣枫
/// CreatDate:2021-6-8
/// Description：删除数据处理工厂、各版本icd结构化数据为空或者已封闭的数据
/// Input：
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).DelNullStructResult()
ClassMethod DelNullStructResult()
{
	s errorflag=0
	s result=""
	ts
	s count=0
	s icdcount=0
	s base=""
	for
	{
		s base=$O(^User.MKBStructuredDataI("BaseIndex",base))	
		q:base=""
		q:errorflag=1
		s MKBSDRowid=0
		for
		{
			//Index BaseIndex On MKBSDBaseDr;
			s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
			q:MKBSDRowid=""
			q:errorflag=1
			//删除关联的结构化数据子表数据
			s SDDRowid=""
			for
			{
				s SDDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",SDDRowid))
				q:SDDRowid=""
				q:errorflag=1
				s MKBRTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",SDDRowid)),4)
				s MKBTActiveFlag=""
				s:MKBRTermdr'="" MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBRTermdr)),9)
				if ((MKBRTermdr="")||(MKBRTermdr="false")||(MKBTActiveFlag="N"))
				{
					s re= ##class(User.MKBStructuredDataResult).%DeleteId(MKBSDRowid_"||"_SDDRowid)
					s count=count+1
					s:re'=1 errorflag=1
				}
			}	
		}
	}
	s ICDContrastID=""
	for
	{
		s ICDContrastID=$o(^User.MKBICDContrastD(ICDContrastID))
		q:ICDContrastID=""
		q:errorflag=1
		s MKBICDRRowid=""
		for
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",MKBICDRRowid))
			q:MKBICDRRowid=""
			q:errorflag=1
			s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
			s MKBRTermdr=$lg($g(^User.MKBICDContrastD(ICDContrastID,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
			s MKBTActiveFlag=""
			s:MKBRTermdr'="" MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBRTermdr)),9)
			if ((MKBRTermdr="")||(MKBRTermdr="false")||(MKBTActiveFlag="N"))
			{
				s re= ##class(User.MKBICDContrastResult).%DeleteId(ICDContrastID_"||"_MKBICDRRowid)
				s icdcount=icdcount+1
				s:re'=1 errorflag=1
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
		s result=count_"^"_icdcount
		tc	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-6-22
/// Description:根据子表实际科室频次，计算总频次
/// Table:
/// Input:  id
/// Return:freq
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetTotalFreqByStructLoc()
ClassMethod GetTotalFreqByStructLoc()
{
	s result=""
	s errorflag=0
	ts
	
	s base=""
	for
	{
		s base=$O(^User.MKBStructuredDataI("BaseIndex",base))
		q:base=""
		q:errorflag=1
		s MKBSDRowid=0
		for
		{
			//Index BaseIndex On MKBSDBaseDr;
			s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
			q:MKBSDRowid=""
			q:errorflag=1
			s locfreq=0
			s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
			
			//Index NewLocIndex On (MKBSDStructData, MKBSDLoc);
			s LocDesc=""
			for
			{
				s LocDesc=$o(^User.MKBStructuredDataLocI("NewLocIndex",MKBSDRowid,LocDesc))
				q:LocDesc=""
				s LOCid=""
				for
				{
					s LOCid=$o(^User.MKBStructuredDataLocI("NewLocIndex",MKBSDRowid,LocDesc,LOCid))
					q:LOCid=""
					s MKBSDFrequency=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LOCid)),3)
					s locfreq=locfreq+MKBSDFrequency
				}
				
			}
			
			if ((locfreq'=0)&&(SumLoc'=locfreq))		//修改科室总频次
			{
				
				s snobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			 	s snobj.MKBSDTotalFreq = locfreq
			    s mastersc = snobj.%Save()
			    d snobj.%Close()
			    s:mastersc'=1 errorflag=1
			}
			
		}
	}
	if (errorflag=0)
	{
		tc
		s result="true"	
	}
	else
	{
		tro
		s result="false"	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-7-15
/// Description:匹配的时候，把全局化词表的别名导入到数据处理工厂对应的别名里 ，诊断短语的别名、别名检索码 也加到全文索引
/// Table:
/// Input:  id
/// Return:freq
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).AddAliasInAutoStructData()
ClassMethod AddAliasInAutoStructData(rowid)
{
	q:rowid="" "false"
	
	s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(rowid)),2)
	s Base=$lg($g(^User.MKBStructuredDataD(rowid)),22)
	
	s MKBSDDiag = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBSDDiag,0)		//全角转半角
	s MKBSDDiag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod1(MKBSDDiag)
	s MKBSDDiag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod2(MKBSDDiag)
	s MKBSDDiag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod3(MKBSDDiag)
	
	s termbase=$o(^User.MKBTermBaseI("DescIndex"," 全局化词表标记",0))
	s markstrid=$o(^User.MKBTermI("DescIndex",termbase," 诊断",0))	//获取诊断
	
	s fixedmarkstr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(termbase,markstrid)
		
	s TheID=0
	s existID=0
	for			//取用频率最高的数据
	{
		s existID=$o(^User.MKBGlobalI("DescIndex"," "_$ZCONVERT(MKBSDDiag,"U"),existID))
		q:existID=""
		s MKBGState=$lg($g(^User.MKBGlobalD(existID)),8)
	    continue:(MKBGState'="U")	//过滤非在使用的
	    s MKBGMark=$lg($g(^User.MKBGlobalD(existID)),10)
	    s markflag=0		//只处理诊断的数据
		for m=1:1:$l(fixedmarkstr,"^")
		{
			s markid=$p(fixedmarkstr,"^",m)
			q:(markid="")
			s MKBTDesc=$LISTGET($G(^User.MKBTermD(markid)),3)   ///中心词
			s:(MKBGMark[MKBTDesc) markflag=1
				
		}
		continue:markflag=0
		s TheID=existID
	}
	s errorflag=0
	TS
	if (TheID'="")		//有匹配的术语条目	新增它下面的除它本身之外的所有别名
	{
		//^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))
		s AliasId=""
		for
		{
			s AliasId=$o(^User.MKBGlobalD(TheID,"ChildGloAlias",AliasId))
			q:AliasId=""
			q:errorflag=1
			s MKBGADesc = $lg($g(^User.MKBGlobalD(TheID,"ChildGloAlias",AliasId)),2)
			s MKBGAPYCode=$lg($g(^User.MKBGlobalD(TheID,"ChildGloAlias",AliasId)),3)
  			continue:(MKBSDDiag= MKBGADesc) //过滤自身			
			s obj = ##class(User.MKBStructuredDataOther).%New(rowid)
			s obj.MKBSDOtherCode = MKBGAPYCode
			s obj.MKBSDOtherMark = "AN"
			s obj.MKBSDOtherNote = ""
			s obj.MKBSDOther = MKBGADesc
			d obj.MKBSDStructDataSetObjectId(rowid)
			s sc = obj.%Save()
			if $$$ISOK(sc)
			{
				s id = obj.%Id()
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Base,MKBGAPYCode,id)  //拼音码全文索引
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Base,MKBGADesc,id) //诊断名全文索引	
			}
			else{
				s errorflag=1
					
			}
		}
	}
	if (errorflag'=1)
	{
		tc
		s result="true"	
	}
	else
	{
		tro
		s result="false"	
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-8-6
/// Description: 数据处理工厂数据处理 给数据添加是否能匹配全局化词表标记
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBStructuredData).AddMatchFlag(13)
ClassMethod AddMatchFlag(baseid As %String)
{
	q:(baseid="") "false"
	//k ^TempMarkSortList
	//d ..SortGlobal("termsort","","")
	//s mark="部位,临床实用诊断,常用诊断描述,业务诊断,展示名"	
	s count=0
	//各个医院的数据处理工厂
	
	if (baseid'["ICD")
	{
		k ^TempUnsave
		s unsavecount=0
		
		//Index BaseIndex On MKBSDBaseDr;

		s MKBSDRowid=""
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",baseid,MKBSDRowid))
			q:MKBSDRowid=""
			continue:($d(^TempUnsave(MKBSDRowid))>0)
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
			s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)		//icd
			
			s NewDesc=""
			s NewDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBSDDiag,0)		//全角转半角
			s NewDesc=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod1(NewDesc)
			s NewDesc=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod2(NewDesc)
			s NewDesc=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod3(NewDesc)
			s MatchGlobal=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(NewDesc,"U"),0))
			if (MatchGlobal'="")
			{
				s count=count+1
				s snobj =##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			 	s snobj.MKBSDMatchGlobalFlag = "Y"
			    s sc = snobj.%Save()
			    d snobj.%Close()
			}
		}
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-8-12
/// Description: 检查各个数据处理工厂里的结构化结果 ，当属性已经不存在时，当删除的只剩下一个中心词的时候，把这个中心词也删除了
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBStructuredData).CheckStructResult(13)
ClassMethod CheckStructResult(base)
{
	s count=0
	s baseid=""
	for
	{
		s baseid=$o(^User.MKBStructuredDataI("BaseIndex",baseid))
		q:baseid=""
		continue:((base'="")&&(baseid'=base))
		s MKBSDRowid=""
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",baseid,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
			s StructID=0
			for
			{
				s StructID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID))
				q:StructID=""
				s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID)),2)  //获取结构化结果串
				s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID)),4) //获取结构化结果Termdr
				s termDesc=$listGet($g(^User.MKBTermD(MKBSDResultTermdr)),3)
				
				continue:(MKBSDResultID="")		//结构化串为空的过滤掉
				s newMKBSDResultID=""
				s newMKBSDResultID=..StandardizedStructStr(MKBSDResultID)	//标准化结构化串
				/*
				s DiagTemplateDr=$o(^User.MKBTermPropertyI("FlagIndex",MKBSDResultTermdr," DT",0))
				s falseflag=0
				s NewMKBSDResultID=""
				if (DiagTemplateDr="")	//这个诊断模板已经不存在了
				{
					s NewMKBSDResultID=""
				}
				s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",DiagTemplateDr,0))
		
				s:MKBTPDRowid="" NewMKBSDResultID=""
				if '$d(^User.MKBTermProDetailD(MKBTPDRowid))		//属性详情不存在
				{
					s NewMKBSDResultID=""	
				}
				
				for j=1:1:$l(MKBSDResultID,",")
				{
					s Result=$p(MKBSDResultID,",",j)
					continue:(Result="")
					s key=$p(Result,":",1)
					s newVals=""
					if ('$d(^User.MKBTermPropertyD(key)))	//诊断模板中不存在的属性
					{
						continue
					}
					else
					{
						s Val=$p(Result,":",2)
						s valueslen=$l(Val,"*")
						for k=1:1:valueslen
						{
							s value=$p(Val,"*",k)
							s:value["<br/>" value=$p(value,"<br/>",1)
							s thevalue=""
							if value["S"
							{
								s valueDR=$tr(value,"S","")
								continue:'$d(^User.MKBTermD(valueDR))
								
								s thevalue="S"_valueDR
							}
							else
							{
								continue:'$d(^User.MKBTermProDetailD(value))
								s thevalue=value
							}
							if (newVals="")
							{
								s:thevalue'="" newVals=thevalue	
							}
							else
							{
								s:thevalue'="" newVals=newVals_"*"_thevalue	
							}
						}
					}
					continue:((newVals="")||(key=""))
					if (NewMKBSDResultID="")
					{
						s NewMKBSDResultID=key_":"_newVals
					}
					else
					{
						s NewMKBSDResultID=NewMKBSDResultID_","_key_":"_newVals
					}
				}
				*/
				if (NewMKBSDResultID'=MKBSDResultID)	//和原先的不符,修改
				{
					s count=count+1
					s sobj=##class(User.MKBStructuredDataResult).%OpenId(MKBSDRowid_"||"_StructID)
					if (NewMKBSDResultID="")
					{
						//d ##class(User.MKBStructuredDataResult).%DeleteId(MKBSDRowid_"||"_StructID)
					}
					else
					{
						d sobj.MKBSDStructDataSetObjectId(MKBSDRowid)
						s sobj.MKBSDStructResultID=NewMKBSDResultID
						d sobj.MKBSDTermDRSetObjectId(MKBSDResultTermdr)
						s ssc=sobj.%Save()
						
						if $$$ISERR(ssc)
						{
							s result=$system.OBJ.DisplayError(ssc)
						}
					}
					d sobj.%Close()
				}
		
			}
		}
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-8-12
/// Description: 处理检查各个数据处理工厂里的结构化结果方法导致的增加重复，以及修改去除<br/>后的去重
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBStructuredData).CheckSameStructResult(13)
ClassMethod CheckSameStructResult(base)
{
	s count=0
	s baseid=""
	for
	{
		s baseid=$o(^User.MKBStructuredDataI("BaseIndex",baseid))
		q:baseid=""
		continue:((base'="")&&(baseid'=base))
		s MKBSDRowid=""
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",baseid,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
			k ^TempStruct
			s num=0
			s StructID=""
			for
			{
				s StructID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID))
				q:StructID=""
				s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID)),2)  //获取结构化结果串
				s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID)),4) //获取结构化结果Termdr
				s:MKBSDResultID="" MKBSDResultID=0
				s num=num+1
				s sameflag=0
				s oldMKBSDResultID=""
				for
				{
					s oldMKBSDResultID=$o(^TempStruct(MKBSDRowid,MKBSDResultTermdr,oldMKBSDResultID))
					q:oldMKBSDResultID=""
					q:sameflag=1
					s:oldMKBSDResultID[MKBSDResultID sameflag=1
					
				}

				if (sameflag=1)
				{
					s count=count+1
					//s sobj=##class(User.MKBStructuredDataResult).%OpenId(MKBSDRowid_"||"_StructID)
					d ##class(User.MKBStructuredDataResult).%DeleteId(MKBSDRowid_"||"_StructID)
				}
				else
				{
					s ^TempStruct(MKBSDRowid,MKBSDResultTermdr,MKBSDResultID)=""
				}
			}
			
		}
	}
	q count
}

/// Creator:钟荣枫
/// CreatDate:2021-8-12
/// Description：查询需要导出的数据
/// Table：
/// Input：
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetRealStructResultList",15)
Query GetRealStructResultList(DiaSource As %String) As %Query(ROWSPEC = "MKBConDesc,SDResult,RealMatchDia,Matching")
{
}

ClassMethod GetRealStructResultListExecute(ByRef qHandle As %Binary, DiaSource As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s DiaSourceDesc=$lg($g(^User.MKBStructuredBaseD(DiaSource)),2)   //诊断来源描述 
	
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
			s RealMatchDiaId=$p(##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStruct(DiaSource,MKBSDRTerm_"-"_MKBSDResult),",",1)   //实际匹配结果
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
		b ;1
		d outputRow
		/*
		s thisStr="{""MKBConDesc"":"""_MKBConDesc_""",""SDResult"":"""_SDResult_""",""RealMatchDia"":"""_RealMatchDia_""",""Matching"":"""_Matching_"""}"
		if (jsonstr'="")
		{ 
			w ","
			s jsonstr=jsonstr_","_thisStr
		}
		else
		{
			s jsonstr=thisStr
		}
		s sum = sum+1
		w thisStr
		*/

	}
	//s thisStr="{""MKBConDesc"":"""_MKBConDesc_""",""SDResult"":"""_SDResult_""",""RealMatchDia"":"""_RealMatchDia_""",""Matching"":"""_Matching_"""}"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
outputRow
	set Data=$lb(MKBConDesc,SDResult,RealMatchDia,Matching)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRealStructResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetRealStructResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:zrf 
/// CreatDate:2021-8-30
/// Description:导出数据处理工厂中诊断的实际匹配结果
/// Table: User.MKBStructuredData
/// Input: DiaSource ：诊断短语数据来源id
/// Return:ICD描述,结构化结果,实际匹配结果,是否匹配
/// d ##class(web.DHCBL.MKB.MKBStructuredData).ExportStructResult(15)
ClassMethod ExportStructResult(DiaSource As %String)
{
	s sum=0
	s DiaSourceDesc=$lg($g(^User.MKBStructuredBaseD(DiaSource)),2)   //诊断来源描述 
	w "{""rows"":["
	s jsonstr=""
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
			s RealMatchDiaId=$p(##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStruct(DiaSource,MKBSDRTerm_"-"_MKBSDResult),",",1)   //实际匹配结果
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
		s thisStr="{""MKBConDesc"":"""_MKBConDesc_""",""SDResult"":"""_SDResult_""",""RealMatchDia"":"""_RealMatchDia_""",""Matching"":"""_Matching_"""}"
		if (jsonstr'="")
		{ 
			w ","
			s jsonstr=jsonstr_","_thisStr
		}
		else
		{
			s jsonstr=thisStr
		}
		s sum = sum+1
		w thisStr

	}
	w "], ""total"":"_sum_"}"
	q ""
}

/// Creator:钟荣枫
/// CreatDate:2021-11-11
/// Description: 获取属性下的数据id串
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).GetChildDataStr(69357,"16392")
ClassMethod GetChildDataStr(prorerty, Node)
{
	s idstr=""
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(prorerty)),5)  //配置项
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",prorerty,0))  //属性内容id	
	s definedNode=""
	s:MKBTPDRowId'="" definedNode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容中心词
	s Type=$lg($g(^User.MKBTermPropertyD(prorerty)),4)
	
	if ((Type="S")||(Type="SS"))	//引用的术语
	{
		s idstr= ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(DATSOU,Node)
	}
	elseif ((Type="T"))		//树形
	{
		s idstr= ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(Node,prorerty)
	}
	else	//列表型
	{
		s MKBTPDRowId=0
        for  
        {   
            s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",prorerty,MKBTPDRowId)) 
            q:MKBTPDRowId="" 
            if (idstr="")
            {
	         	s idstr= MKBTPDRowId  
            }
            else
            {
	         	s idstr=idstr_"^"_MKBTPDRowId   
            }
        }
	}
	q idstr
}

/// Creator:钟荣枫
/// CreatDate:2021-08-31
/// Description: 标准化结构化串  包括判断中心词是否封闭，属性去重，校验属性数据是否存在，属性按照id从小到大排序  校验属性是否在诊断模板中存在
/// Input:结构化串
/// Return:标准化处理后的表达式串
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredData).StandardizedStructStr("16053-20444:1225858,71344:S317725")
ClassMethod StandardizedStructStr(StructResult)
{
	s result=""
	s Term=$p(StructResult,"-",1)
	s OldDetail=$p(StructResult,"-",2)
	s:OldDetail["<br/>" OldDetail=$p(OldDetail,"<br/>",1)	//带有两行的表达式
	if ($d(^User.MKBTermD(Term))>0)	//判断是否存在
	{
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(Term)),9)
		if (MKBTActiveFlag'="N")	//没有封闭
		{
			k ^TempTermpleData
			s property = $o(^User.MKBTermPropertyI("DescIndex",Term," 诊断模板",0))
			
	
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
			          	//7426&T&331830&S&N&P
			          
			          	s MKBTPRowId=$p(argstr,"&",1)
			          	s Node=$p(argstr,"&",3)
			          	s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
			          	s MKBTPTOrP=$p(argstr,"&",6)  //术语T或属性P
	          			s:MKBTPTOrP="" MKBTPTOrP="P"  //默认属性P
	          
			          	if (MKBTPTreeNode'="")
			          	{
				      		s ^TempTermpleData(MKBTPRowId,MKBTPTreeNode)="" 
			         	}
			         	else
			         	{
				         	s ^TempTermpleData(MKBTPRowId)=""
			         	}
			        }
				}
			}
			k ^TempStruct
			for i1=1:1:$l(OldDetail,",")
			{
				s OldItem=$p(OldDetail,",",i1)
				continue:OldItem=""
				if (OldItem[":")
				{
					s OldEditItemtemp= $p(OldItem,":",1)
					continue:('$d(^User.MKBTermPropertyD(OldEditItemtemp)))			//属性列表中不存在的属性
					continue:('$d(^TempTermpleData(OldEditItemtemp)))		//诊断模板中不存在的属性
					s MKBTPDesc=$lg($g(^User.MKBTermPropertyD(OldEditItemtemp)),2)
					if ((MKBTPDesc="其他结构化描述")||(MKBTPDesc="其他文本描述"))
					{
						continue
					}
					s MKBTPTermDr=$lg($g(^User.MKBTermPropertyD(OldEditItemtemp)),6)
					continue:MKBTPTermDr'=Term
					
					//判断是否在这个节点下
					
					k ^TempNodeIDS
					if ($o(^TempTermpleData(OldEditItemtemp,""))'="")		//有多个节点
					{
						
						if ($d(^TempTermpleData(OldEditItemtemp))=11)
						{
							s orderstr=..GetChildDataStr(OldEditItemtemp,"")
							s orderstr="^"_orderstr_"^"	
							s ^TempNodeIDS(1)=orderstr
						}
						else
						{
							
							s cout=0
							s Node=""
							for
							{
								s Node=$o(^TempTermpleData(OldEditItemtemp,Node))		//诊断模板中的节点	//一个属性下可能取多个节点
								q:Node=""
								s cout=cout+1
								s orderstr=""	//属性下的所有id串拼接
									//取用全部的属性数据
								s orderstr=..GetChildDataStr(OldEditItemtemp,Node)
									
								
								s orderstr="^"_orderstr_"^"	
								s ^TempNodeIDS(cout)=orderstr
							}
						}
					}
					else
					{
						s orderstr=..GetChildDataStr(OldEditItemtemp,"")
						s orderstr="^"_orderstr_"^"	
						s ^TempNodeIDS(1)=orderstr
					}
					
					s OldEditContenttemp= $p(OldItem,":",2)
					for i2=1:1:$l(OldEditContenttemp,"*")
					{
						s OlddetailItem=$p(OldEditContenttemp,"*",i2)
						continue:OlddetailItem=""
						s value=""
						if OlddetailItem["S"		//检验属性是否已被删除
						{
							s value=$tr(OlddetailItem,"S","")
							continue:'$d(^User.MKBTermD(value))
						}
						else
						{
							s value=OlddetailItem
							continue:'$d(^User.MKBTermProDetailD(OlddetailItem))
						}
						s value="^"_value_"^"
						
						s flag=0	//在所属的数据串中存不存在
						s num=""
						for
						{
							s num=$o(^TempNodeIDS(num))
							q:num=""
							s orderstr=^TempNodeIDS(num)
							if (orderstr'[value)	//在所属的数据串中不存在
							{
								continue
							}
							else
							{
								s flag=1	
							}
						}
						continue:flag=0
						s ^TempStruct("Old",OldEditItemtemp,OlddetailItem)=""
					}
				}
			}
			//重新拼接
			s NewDetail=""
			
			s OldEditItemtemp=""
			for
			{
				s OldEditItemtemp=$o(^TempStruct("Old",OldEditItemtemp))
				q:OldEditItemtemp=""
				s Items=""
				s OlddetailItem=""
				for
				{
					s OlddetailItem=$o(^TempStruct("Old",OldEditItemtemp,OlddetailItem))
					q:OlddetailItem=""
					if (Items="")
					{
						s Items=OlddetailItem	
					}
					else
					{
						s Items=Items_"*"_OlddetailItem	
					}
				}
				
				if (NewDetail="")
				{
					s:Items'="" NewDetail=OldEditItemtemp_":"_Items
				}
				else
				{
					s:Items'="" NewDetail=NewDetail_","_OldEditItemtemp_":"_Items
				}
			}
			
			if (NewDetail'="")
			{
				s result=Term_"-"_NewDetail
			}
			else
			{
				s result=Term
			}
		}
	}
	k ^TempTermpleData
	k ^TempStruct
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-8-12
/// Description: 检查数据处理工厂、各版本icd、临床实用诊断-常用诊断表达式的结构化串，标准化结构化串，处理包括判断中心词是否封闭，属性去重，校验属性数据是否存在，属性按照id从小到大排序
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBStructuredData).HandleResult()
ClassMethod HandleResult(case)
{
	ts
	s delcount=0
	s count=0
	if (case["1")
	{
		//数据处理工厂
		s baseid=""
		for
		{
			s baseid=$o(^User.MKBStructuredDataI("BaseIndex",baseid))
			q:baseid=""
			s MKBSDRowid=""
			for
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",baseid,MKBSDRowid))
				q:MKBSDRowid=""
				s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
				s MKBSDInitialICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),18)
				s StructID=0
				for
				{
					s StructID=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID))
					q:StructID=""
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",StructID)),4) //获取结构化结果Termdr
					s termDesc=$listGet($g(^User.MKBTermD(MKBSDResultTermdr)),3)
					
					if (MKBSDResultID'="")
					{
						s OldStruct=MKBSDResultTermdr_"-"_MKBSDResultID
					}
					else
					{
						s OldStruct=MKBSDResultTermdr
					}
					
					s NewStruct=..StandardizedStructStr(OldStruct)
					if (OldStruct'=NewStruct)	//和原先的不符,修改
					{
						s count=count+1
						w !,count
						if (NewStruct'="")	//只是不一致，修改
						{
							s NewMKBSDResultID=$p(NewStruct,"-",2)
							
							s sobj=##class(User.MKBStructuredDataResult).%OpenId(MKBSDRowid_"||"_StructID)
							d sobj.MKBSDStructDataSetObjectId(MKBSDRowid)
							s sobj.MKBSDStructResultID=NewMKBSDResultID
							d sobj.MKBSDTermDRSetObjectId(MKBSDResultTermdr)
							s ssc=sobj.%Save()
							
							if $$$ISERR(ssc)
							{
								s result=$system.OBJ.DisplayError(ssc)
							}
							
							d sobj.%Close()
						}
						else	//被封闭的中心词，直接将整个结构化结果删除
						{
							s delcount=delcount+1
							d ##class(User.MKBStructuredDataResult).%DeleteId(MKBSDRowid_"||"_StructID)	
						}
					}
				}
				//处理最优标记
			
				s icdFlag=..findInitialICD(MKBSDRowid)
				if (icdFlag'="")
				{
					s icdflagdesc = $p(icdFlag,"*",1) //之前最优匹配的描述
		            s icdflagid = $p(icdFlag,"*",2)	//最优匹配在对照表中的id
		            
		            if (MKBSDInitialICD="Y")	//原先被标记了最优
		            {
			            //将这个诊断的最优标记去除
			            d ..InitialICDUpdate(MKBSDRowid,"N")
		            }
				}
				
			}
		}
	}
	if (case["2")
	{
		s icddelcount=0
		s icdcount=0
		//各版本icd对照
		s MKBICDRowid=""
		for
		{
			s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
			q:MKBICDRowid=""
			continue:$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",""))=""
			s MKBICDInitialICD=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),17) 
			
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
		
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
				q:MKBICDRRowid=""
				s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				if (MKBICDRResultID'="")
				{
					s OldStruct=MKBICDResultTermdr_"-"_MKBICDRResultID
				}
				else
				{
					s OldStruct=MKBICDResultTermdr
				}
				s NewStruct=..StandardizedStructStr(OldStruct)
				
				if (OldStruct'=NewStruct)	//和原先的不符,修改
				{
					s count=count+1
					w !,count
					if (NewStruct'="")	//只是不一致，修改
					{
						s NewMKBICDRResultID=$p(NewStruct,"-",2)
						s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(NewMKBICDRResultID,MKBICDResultTermdr)
						s obj=##class(User.MKBICDContrastResult).%OpenId(MKBICDRowid_"||"_MKBICDRRowid)
						d obj.MKBICDContrastSetObjectId(MKBICDRowid)
						d obj.MKBICDConTermDrSetObjectId(MKBICDResultTermdr)
						s obj.MKBICDConResult=SResult
						s obj.MKBICDConResultID=NewMKBICDRResultID
						s sc=obj.%Save()
						if $$$ISERR(sc)
						{
							s result=$system.OBJ.DisplayError(sc)
						}
						d obj.%Close()
					}
					else	//被封闭的中心词，直接将整个结构化结果删除
					{
						s delcount=delcount+1
						d ##class(User.MKBICDContrastResult).%DeleteId(MKBICDRowid_"||"_MKBICDRRowid)	
					}
				}
			}
			//处理最优标记
			
			s icdFlag=##Class(web.DHCBL.MKB.MKBICDContrast).GetDescAndParid(MKBICDRowid)
			if (icdFlag'="")
			{
				s icdflagdesc = $p(icdFlag,"*",1) //之前最优匹配的描述
	            s icdflagid = $p(icdFlag,"*",2)	//最优匹配在对照表中的id
	            s icdSource = $p(icdFlag,"*",3)	 //数据来源
	            
	            s inflag=0
	            for m=1:1:$l(icdSource,",")
	            {
		            s source=$p(icdSource,",",m)
		            continue:source=""
		            if (MKBICDSource[source)
		            {
			            s inflag=1
			            q
		            }
	            }
	            if ((inflag=1)&&(MKBICDInitialICD="Y"))	//在同一个版本中
	            {
		            //将这个诊断的最优标记去除
		            d ##Class(web.DHCBL.MKB.MKBICDContrast).InitialICDUpdate(MKBICDRowid,"N")
	            }
			}			
		}
	}
	if (case["3")
	{
		//临床实用诊断
		s deltcount=0
		s tcount=0
		s MKBTRowId=""
		FOR
		{
			//Index BaseIndex On MKBTBaseDR;
			s MKBTRowId=$o(^User.MKBTermI("BaseIndex",5,MKBTRowId))
			q:MKBTRowId=""
			s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 常用诊断表达式",0))
			s sub= $o(^User.MKBTermPropertyD(MKBProRowid,"ChildExtPro",0))
			s MKBTPDRowId=""
			for  
			{	
				s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBProRowid,MKBTPDRowId)) 
				q:MKBTPDRowId=""
				
				s MKBTEPVValueStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(MKBProRowid,sub,MKBTPDRowId)
				s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
				s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)	//id串
				s NewStruct=..StandardizedStructStr(MKBTEPVValueF)
					
				if (MKBTEPVValueF'=NewStruct)	//和原先的不符,修改
				{
					s count=count+1
					w !,count
					if (NewStruct'="")	//只是不一致，修改
					{
						s MKBTEPRowId=MKBProRowid_"||"_sub  //扩展属性表的ID
						
						s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
						
						s objv=##class(User.MKBTermExtendProVal).%OpenId(MKBTEPVRowId)
						s objv.MKBTEPVValue = NewStruct
						d objv.%Save()
						
						d objv.%Close()
						
					}
					else	//被封闭的中心词， 删除整条常用诊断表达式
					{
						s delcount=delcount+1
						d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(MKBTPDRowId)	
					}
				}
				
			}
			
			
		}
	}
	//q count_"("_delcount_")"_"--"_icdcount_"("_icddelcount_")"_"--"_tcount_"("_deltcount_")"
	q count_"("_delcount
}

/// Creator：钟荣枫
/// CreatDate:2021-9-7
/// Description: 西南医大的his诊断修改完成，但是由于已经上线用了一段时间，数据清空再导入容易影响原先的历史记录，只能根据现有诊断来修改数据处理工厂数据
/// Input:文件path
/// w ##class(web.DHCBL.MKB.MKBStructuredData).CheckXNDiagData("")
ClassMethod CheckXNDiagData(path)
{
	s base=8
	k ^TEMPXNDiag
	TS
	s MKBSDRowid=""
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))
		q:MKBSDRowid=""
		s ^TEMPXNDiag("old",MKBSDRowid)=""
		
	}
	s savecount=0
	s nosavecount=0
	s continuecount=0
	s existcount=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	s num=0
	k myFileAry
	
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		//诊断代码^诊断名称^诊断ICD10^开始日期^结束日期^是否中医诊断^是否中医症型^肿瘤形态学编码标志^损伤中毒外部原因标志
		//^HIS RowId^就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）^诊断类型描述^性别描述^开始年龄^结束年龄^副编码^ICD9代码^注释^国家标准名称
		s splitsymbol=$c(9)
		s:$l(data,"^")>=4 splitsymbol="^"
		s DataCode=$p(data,splitsymbol,1)	//诊断代码
		s DataDesc=$p(data,splitsymbol,2)	//诊断名称
		if (DataDesc="") 
		{
			s continuecount=continuecount+1
			continue
		}
		s ICDCode=$p(data,splitsymbol,3)	//诊断ICD10
		if ((ICDCode="")&&(DataCode=""))
		{
			s continuecount=continuecount+1
			continue
		}
		s:ICDCode["?" ICDCode=$tr(ICDCode,"?","†")		//替换特殊符号小剑
		s StartDate=$p(data,splitsymbol,4)	//开始日期
		s EndDate=$p(data,splitsymbol,5)	//结束日期
		if (StartDate'="")
		{
			s StartDate=$p(StartDate," ",1)
			s StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
			s:StartDate="" StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate)
			//##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate) 
		}
		if (EndDate'="")
		{
			s EndDate=$p(EndDate," ",1)
			s EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
			s:EndDate="" EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过滤过期数据
		{
			//2018/7/5 0:00:00
			s continuecount=continuecount+1
			continue	
			
		}
		
		s IsCFlag=$p(data,splitsymbol,6)	//是否中医诊断
		s:IsCFlag="" IsCFlag="N"
		s IsCType=$p(data,splitsymbol,7)	//是否中医症型
		s:IsCType="" IsCType="N"
		s CodeFlag=$p(data,splitsymbol,8)	//肿瘤形态学编码标志
		s:IsCType="" IsCType="N"
		s ReasonFlag=$p(data,splitsymbol,9)	//损伤中毒外部原因标志
		s:ReasonFlag="" ReasonFlag="N"
		
		s HisRowID=$p(data,splitsymbol,10)	//his诊断ID
		s ClinicType=$p(data,splitsymbol,11)	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
		s Classification=$p(data,splitsymbol,12)		//icd诊断分类
		s LimitSex=$p(data,splitsymbol,13)		//限制性别
		s AgeFrom=$p(data,splitsymbol,14)		// 从年龄
		s AgeTo=$p(data,splitsymbol,15)		//到年龄
		s DeputyCode=$p(data,splitsymbol,16)	//icd10副编码
		s ICD9Code=$p(data,splitsymbol,17)		//icd9代码
		s HisRemark=$p(data,splitsymbol,18)		//注释
		s NationalDesc=$p(data,splitsymbol,19)	// 国家标准名称
				
		
		//s Remark=IsCFlag_"#"_IsCType_"#"_CodeFlag_"#"_ReasonFlag
		//Index HisIDIndex On (MKBSDBaseDr, MKBSDHisRowID As Exact);
		//由于西南医大原先导入的时候没有导入hisid，采用描述索引
		s StructureID=$o(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,ICDCode,0))
		/*
		if (HisRowID="")
		{
			s StructureID=$o(^User.MKBStructuredDataI("DiagICDIndex",base,DataDesc,ICDCode,0))
		}
		else
		{
			s StructureID = $o(^User.MKBStructuredDataI("HisIDIndex",base,HisRowID,"")) 
		}
		*/
		//s StructureID = $o(^User.MKBStructuredDataI("HisIDIndex",base,HisRowID,""))    //判断该诊断是否存在
		if (StructureID="")
		{
			//Index NumberIndex On MKBICDConNumber;
			s obj=##class(User.MKBStructuredData).%New()		//保存到父表
		    s obj.MKBSDDiag = DataDesc
		    d obj.MKBSDBaseDrSetObjectId(base)
		    s obj.MKBSDDiaSource = "HIS诊断"
		    s obj.MKBSDICD = ICDCode
		    s obj.MKBSDICDDesc = DataDesc
		    s obj.MKBSDDiagPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DataDesc)
		    s obj.MKBSDStatus = "N"
		    s obj.MKBSDTotalFreq = "0"
		    s obj.MKBSDTCMDiagFlag=IsCFlag	/// 中医诊断标识
			s obj.MKBSDTCMSynFlag=IsCType	/// 中医证型标识
			s obj.MKBSDTumourFlag=CodeFlag		/// 肿瘤形态学编码标识
			s obj.MKBSDInjuryFlag=ReasonFlag	/// 损伤中毒外部原因标志
			s obj.MKBSDDateActiveFrom=StartDate		/// 开始日期
			s obj.MKBSDDateActiveTo=EndDate			/// 截止日期
			
			s obj.MKBSDHisRowID=HisRowID	//his诊断ID
			s obj.MKBSDHisCode=DataCode		//HIS诊断代码
			s obj.MKBSDDeputyCode=DeputyCode	//icd10副编码
			s obj.MKBSDClinicType=ClinicType	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
			s obj.MKBSDClassification=Classification		//icd诊断分类
			s obj.MKBSDLimitSex=LimitSex		//限制性别
			s obj.MKBSDHisRemark=HisRemark		//注释
			s obj.MKBSDAgeFrom=AgeFrom		// 从年龄
			s obj.MKBSDAgeTo=AgeTo		//到年龄
			s obj.MKBSDICD9Code=ICD9Code		//icd9代码
			s obj.MKBSDNationalDesc=NationalDesc		// 国家标准名称

		    s sc=obj.%Save()
		    d obj.%Close()
		    if (sc=1)		//成功
		    {
			    s savecount=savecount+1
			    w !,savecount
			    s id = obj.%Id()
			    s ^TEMPXNDiag("new",id)=""
			    d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(id)
		    }
		    else
		    {
			    s re=$system.OBJ.DisplayError(sc)
			    s nosavecount=nosavecount+1
		    }
		    
		}
		else
		{
			s existcount=existcount+1
			s ^TEMPXNDiag("new",StructureID)=""
			s obj=##class(User.MKBStructuredData).%OpenId(StructureID) 		//保存到父表
		    s obj.MKBSDTCMDiagFlag=IsCFlag	/// 中医诊断标识
			s obj.MKBSDTCMSynFlag=IsCType	/// 中医证型标识
			s obj.MKBSDTumourFlag=CodeFlag		/// 肿瘤形态学编码标识
			s obj.MKBSDInjuryFlag=ReasonFlag	/// 损伤中毒外部原因标志
			s obj.MKBSDDateActiveFrom=StartDate		/// 开始日期
			s obj.MKBSDDateActiveTo=EndDate			/// 截止日期
			s:obj.MKBSDNote["N" obj.MKBSDNote=""
			
			s obj.MKBSDHisRowID=HisRowID	//his诊断ID
			s obj.MKBSDHisCode=DataCode		//HIS诊断代码
			s obj.MKBSDDeputyCode=DeputyCode	//icd10副编码
			s obj.MKBSDClinicType=ClinicType	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
			s obj.MKBSDClassification=Classification		//icd诊断分类
			s obj.MKBSDLimitSex=LimitSex		//限制性别
			s obj.MKBSDHisRemark=HisRemark		//注释
			s obj.MKBSDAgeFrom=AgeFrom		// 从年龄
			s obj.MKBSDAgeTo=AgeTo		//到年龄
			s obj.MKBSDICD9Code=ICD9Code		//icd9代码
			s obj.MKBSDNationalDesc=NationalDesc		// 国家标准名称
		    s sc=obj.%Save()
		    d obj.%Close()
		}
	}
	c file
	k file
	
	s endcount=0
	s RowID=""
	for
	{
		s RowID=$o(^TEMPXNDiag("old",RowID))
		q:RowID=""
		if ($d(^TEMPXNDiag("new",RowID))<=0)	//在新数据里不存在，时间截止为今天
		{
			s endcount=endcount+1
			s MKBSDDateActiveTo=$lg($g(^User.MKBStructuredDataD(RowID)),29)
			if (MKBSDDateActiveTo="")||(MKBSDDateActiveTo>=+$h)		//已经修改截止日期的不用再改，但是为空或者日期大于当前的需要改
			{
				s oobj=##class(User.MKBStructuredData).%OpenId(StructureID) 		//保存到父表
				s oobj.MKBSDDateActiveTo=+$h-1			/// 截止日期
				s osc=oobj.%Save()
			    d oobj.%Close()
			}
		}
	}
	w "读取数据总共"_(num-1)_"条",!
	
	w "保存成功:"_savecount,!
	w "保存失败:"_nosavecount,!
	w "修改数据："_existcount,!
	w "跳过数据："_continuecount,!
	
	w "停用数据："_endcount,!
	
	q "ok"
}

/// Creator：钟荣枫
/// CreatDate:2021-10-15
/// Description: 处理数据处理工厂由于无法识别“†” 导致his诊断的icd与数据处理工厂不一致的情况
/// Input:base
/// w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateSymbol(15)
ClassMethod UpdateSymbol(base As %String = "")
{
	s count=0
	s baseid=""
	for
	{
		s baseid=$o(^User.MKBStructuredDataI("BaseIndex",baseid))
		q:baseid=""
		continue:((base'="")&&(base'=baseid))
		s MKBSDRowid=""
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",baseid,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
			if (MKBSDICD["?")
			{
				s MKBSDICD=$tr(MKBSDICD,"?","†")
				s count=count+1
				s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				s obj.MKBSDICD=MKBSDICD
				s sc=obj.%Save()
				d obj.%Close()
				
			}
		}
		
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-11-12
/// Description: 获取一个诊断的结构化结果描述
/// Input:base
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetStructDesc()
ClassMethod GetStructDesc(MKBSDRowid)
{
	s Result=""
	s sequence=0
	for
	{
		s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence))
		q:sequence=""
		
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
			q:MKBSDRRowid=""
			s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
			s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
			continue:MKBSDResultTermdr=""
			s SResult=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
			s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
			if MKBSDSupplement'=""
			{
				if SResult["]"
				{
					s str=$e(SResult,1,*-1)
					s SResult=str_",("_MKBSDSupplement_")]"
				}
				else
				{
					s SResult=SResult_"[("_MKBSDSupplement_")]"
				}
			}					
			s:Result'="" Result=Result_"<br/>"_SResult
			s:Result="" Result=SResult
		}
	}
	q Result
}

/// Creator：钟荣枫
/// CreatDate:2021-11-17
/// Description: 解决驻马店中医his诊断和数据处理工厂中的诊断描述胡不一致的问题
/// Input:base
/// w ##class(web.DHCBL.MKB.MKBStructuredData).KeepSameDesc()
ClassMethod KeepSameDesc()
{
	s baseid=12
	s count=0
	s MRCIDRowId=0
	for
	{
		s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:((MRCIDRowId="")||(MRCIDRowId'>0))
		s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)  //代码
		s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)   //名称
		s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)     ///ICD10
		s StartDate=$p($g(^MRC("ID",MRCIDRowId)),"^",6)  //开始日期
		s EndDate=$p($g(^MRC("ID",MRCIDRowId)),"^",7)  //结束日期
		if (StartDate'="")
		{
			s StartDate=$p(StartDate," ",1)
			s StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
			s:StartDate="" StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate)
			//##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate) 
		}
		if (EndDate'="")
		{
			s EndDate=$p(EndDate," ",1)
			s EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
			s:EndDate="" EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过滤过期数据
		{
			//2018/7/5 0:00:00
			continue	
		}
		s StructureID=$o(^User.MKBStructuredDataI("DiagICDIndex",12,MRCIDDesc,MRCIDICD9CMCode,0))
		if (StructureID="")
		{
			s count=count+1
			s Diag = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MRCIDDesc,0)		//全角转半角
			s StructureID=$o(^User.MKBStructuredDataI("DiagICDIndex",12,Diag,MRCIDICD9CMCode,0))
			if ((StructureID'="")&&(Diag'=MRCIDDesc))
			{
				s obj=##class(User.MKBStructuredData).%OpenId(StructureID)
				s obj.MKBSDDiag=MRCIDDesc
				s obj.MKBSDICDDesc=MRCIDDesc
				s sc=obj.%Save()
				d obj.%Close()
				if (sc=1)
				{
					d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndexByCode(StructureID)
			    	d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(StructureID)
				}
				
			}
			
		}
		
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-11-22
/// Description: 解决版本较旧，导致现在的医院的数据处理工厂数据没有对应的hisrowid的问题
/// Input:base
/// w ##class(web.DHCBL.MKB.MKBStructuredData).KeepHisRowID()
ClassMethod KeepHisRowID()
{
	s baseid=15
	s count=0
	k ^TEMPSData
	s MRCIDRowId=0
	for
	{
		s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:((MRCIDRowId="")||(MRCIDRowId'>0))
		s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)  //代码
		s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)   //名称
		s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)     ///ICD10
		s StartDate=$p($g(^MRC("ID",MRCIDRowId)),"^",6)  //开始日期
		s EndDate=$p($g(^MRC("ID",MRCIDRowId)),"^",7)  //结束日期
		if (StartDate'="")
		{
			s StartDate=$p(StartDate," ",1)
			s StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
			s:StartDate="" StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate)
			//##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate) 
		}
		if (EndDate'="")
		{
			s EndDate=$p(EndDate," ",1)
			s EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
			s:EndDate="" EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过滤过期数据
		{
			//2018/7/5 0:00:00
			continue	
		}
		s StructureID=$o(^User.MKBStructuredDataI("DiagICDIndex",baseid,MRCIDDesc,MRCIDICD9CMCode,0))
		if (StructureID'="")	//能匹配上
		{
			s ^TEMPSData(StructureID)=""
			s MKBSDHisRowID=$lg($g(^User.MKBStructuredDataD(StructureID)),30)
			if (MKBSDHisRowID="")	//数据处理工厂中没有hisrowid
			{
				s obj=##class(User.MKBStructuredData).%OpenId(StructureID)
				s obj.MKBSDTCMDiagFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",15)	/// 中医诊断标识
				s obj.MKBSDTCMSynFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",13)	/// 中医证型标识
				s obj.MKBSDTumourFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",40)		/// 肿瘤形态学编码标识
				s obj.MKBSDInjuryFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",41)	/// 损伤中毒外部原因标志
				s obj.MKBSDDateActiveFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",6)		/// 开始日期
				s obj.MKBSDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)			/// 截止日期
				
				s obj.MKBSDHisRowID=MRCIDRowId	//his诊断ID
				s obj.MKBSDHisCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)		//HIS诊断代码
				s obj.MKBSDDeputyCode=$p($g(^MRC("ID",MRCIDRowId)),"^",43)	//icd10副编码
				s obj.MKBSDClinicType=$p($g(^MRC("ID",MRCIDRowId)),"^",47)	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
				s obj.MKBSDClassification=$p($g(^MRC("ID",MRCIDRowId)),"^",46)		//icd诊断分类
				s obj.MKBSDLimitSex=$p($g(^MRC("ID",MRCIDRowId)),"^",10)		//限制性别
				s obj.MKBSDHisRemark=$p($g(^MRC("ID",MRCIDRowId)),"^",36)		//注释
				s obj.MKBSDAgeFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",8)		// 从年龄
				s obj.MKBSDAgeTo=$p($g(^MRC("ID",MRCIDRowId)),"^",9)		//到年龄
				s obj.MKBSDICD9Code=$p($g(^MRC("ID",MRCIDRowId)),"^",35)		//icd9代码
				s obj.MKBSDNationalDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",49)		// 国家标准名称
				
				
				s sc=obj.%Save()
				d obj.%Close()
				if (sc=1)
				{
					s count=count+1
					w !,count
				}
				
			}
			
		}
		else
		{
			//看数据处理工厂有没有对上hiscode
			//BaseIndex
			s StructureID=$o(^User.MKBStructuredDataI("HisCodeIndex",baseid,MRCIDCode,""))
			
			if (StructureID'="")
			{
				s ^TEMPSData(StructureID)=""
				s MKBSDHisRowID=$lg($g(^User.MKBStructuredDataD(StructureID)),30)
				if (MKBSDHisRowID="")	//数据处理工厂中没有hisrowid
				{
					s obj=##class(User.MKBStructuredData).%OpenId(StructureID)
					s obj.MKBSDTCMDiagFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",15)	/// 中医诊断标识
					s obj.MKBSDTCMSynFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",13)	/// 中医证型标识
					s obj.MKBSDTumourFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",40)		/// 肿瘤形态学编码标识
					s obj.MKBSDInjuryFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",41)	/// 损伤中毒外部原因标志
					s obj.MKBSDDateActiveFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",6)		/// 开始日期
					s obj.MKBSDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)			/// 截止日期
					
					s obj.MKBSDHisRowID=MRCIDRowId	//his诊断ID
					s obj.MKBSDHisCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)		//HIS诊断代码
					s obj.MKBSDDeputyCode=$p($g(^MRC("ID",MRCIDRowId)),"^",43)	//icd10副编码
					s obj.MKBSDClinicType=$p($g(^MRC("ID",MRCIDRowId)),"^",47)	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
					s obj.MKBSDClassification=$p($g(^MRC("ID",MRCIDRowId)),"^",46)		//icd诊断分类
					s obj.MKBSDLimitSex=$p($g(^MRC("ID",MRCIDRowId)),"^",10)		//限制性别
					s obj.MKBSDHisRemark=$p($g(^MRC("ID",MRCIDRowId)),"^",36)		//注释
					s obj.MKBSDAgeFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",8)		// 从年龄
					s obj.MKBSDAgeTo=$p($g(^MRC("ID",MRCIDRowId)),"^",9)		//到年龄
					s obj.MKBSDICD9Code=$p($g(^MRC("ID",MRCIDRowId)),"^",35)		//icd9代码
					s obj.MKBSDNationalDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",49)		// 国家标准名称
					
					
					s sc=obj.%Save()
					d obj.%Close()
					if (sc=1)
					{
						s count=count+1
						w !,count
					}
				
				}
			
			}
			else
			{
				;b ;break	
			}
		}
		
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-11-22
/// Description: 解决版本较旧，导致现在的医院的数据处理工厂数据没有对应的hisrowid的问题  通过导出的his诊断文件
/// Input:base
/// w ##class(web.DHCBL.MKB.MKBStructuredData).KeepHisRowIDByFile()
ClassMethod KeepHisRowIDByFile(path)
{
	s baseid=15
	s count=0
	k ^TEMPSData
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	s num=0
	k myFileAry
	s continuecount=0
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		//诊断代码^诊断名称^诊断ICD10^开始日期^结束日期^是否中医诊断^是否中医症型^肿瘤形态学编码标志^损伤中毒外部原因标志
		//^HIS RowId^就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）^诊断类型描述^性别描述^开始年龄^结束年龄^副编码^ICD9代码^注释^国家标准名称
		s splitsymbol=$c(9)
		s:$l(data,"^")>=4 splitsymbol="^"
		s DataCode=$p(data,splitsymbol,1)	//诊断代码
		s DataDesc=$p(data,splitsymbol,2)	//诊断名称
		if (DataDesc="") 
		{
			s continuecount=continuecount+1
			continue
		}
		s ICDCode=$p(data,splitsymbol,3)	//诊断ICD10
		if ((ICDCode="")&&(DataCode=""))
		{
			s continuecount=continuecount+1
			continue
		}
		s:ICDCode["?" ICDCode=$tr(ICDCode,"?","†")		//替换特殊符号小剑
		s StartDate=$p(data,splitsymbol,4)	//开始日期
		s EndDate=$p(data,splitsymbol,5)	//结束日期
		if (StartDate'="")
		{
			s StartDate=$p(StartDate," ",1)
			s StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
			s:StartDate="" StartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate)
			//##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(StartDate) 
		}
		if (EndDate'="")
		{
			s EndDate=$p(EndDate," ",1)
			s EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
			s:EndDate="" EndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogicalYmd(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过滤过期数据
		{
			//2018/7/5 0:00:00
			s continuecount=continuecount+1
			continue	
			
		}
		s IsCFlag=$p(data,splitsymbol,6)	//是否中医诊断
		s:IsCFlag="" IsCFlag="N"
		s IsCType=$p(data,splitsymbol,7)	//是否中医症型
		s:IsCType="" IsCType="N"
		s CodeFlag=$p(data,splitsymbol,8)	//肿瘤形态学编码标志
		s:IsCType="" IsCType="N"
		s ReasonFlag=$p(data,splitsymbol,9)	//损伤中毒外部原因标志
		s:ReasonFlag="" ReasonFlag="N"
		
		s HisRowID=$p(data,splitsymbol,10)	//his诊断ID
		s ClinicType=$p(data,splitsymbol,11)	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
		s Classification=$p(data,splitsymbol,12)		//icd诊断分类
		s LimitSex=$p(data,splitsymbol,13)		//限制性别
		s AgeFrom=$p(data,splitsymbol,14)		// 从年龄
		s AgeTo=$p(data,splitsymbol,15)		//到年龄
		s DeputyCode=$p(data,splitsymbol,16)	//icd10副编码
		s ICD9Code=$p(data,splitsymbol,17)		//icd9代码
		s:ICD9Code["?" ICD9Code=$tr(ICD9Code,"?","†")		//替换特殊符号小剑
		s HisRemark=$p(data,splitsymbol,18)		//注释
		s NationalDesc=$p(data,splitsymbol,19)	// 国家标准名称
		
	
		s StructureID=$o(^User.MKBStructuredDataI("DiagICDIndex",baseid,DataDesc,ICDCode,0))
		if (StructureID'="")	//能匹配上
		{
			s ^TEMPSData(StructureID)=""
			s MKBSDHisRowID=$lg($g(^User.MKBStructuredDataD(StructureID)),30)
			if (MKBSDHisRowID="")	//数据处理工厂中没有hisrowid
			{
				s obj=##class(User.MKBStructuredData).%OpenId(StructureID)
				 s obj.MKBSDTCMDiagFlag=IsCFlag	/// 中医诊断标识
				s obj.MKBSDTCMSynFlag=IsCType	/// 中医证型标识
				s obj.MKBSDTumourFlag=CodeFlag		/// 肿瘤形态学编码标识
				s obj.MKBSDInjuryFlag=ReasonFlag	/// 损伤中毒外部原因标志
				s obj.MKBSDDateActiveFrom=StartDate		/// 开始日期
				s obj.MKBSDDateActiveTo=EndDate			/// 截止日期
				
				s obj.MKBSDHisRowID=HisRowID	//his诊断ID
				s obj.MKBSDHisCode=DataCode		//HIS诊断代码
				s obj.MKBSDDeputyCode=DeputyCode	//icd10副编码
				s obj.MKBSDClinicType=ClinicType	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
				s obj.MKBSDClassification=Classification		//icd诊断分类
				s obj.MKBSDLimitSex=LimitSex		//限制性别
				s obj.MKBSDHisRemark=HisRemark		//注释
				s obj.MKBSDAgeFrom=AgeFrom		// 从年龄
				s obj.MKBSDAgeTo=AgeTo		//到年龄
				s obj.MKBSDICD9Code=ICD9Code		//icd9代码
				s obj.MKBSDNationalDesc=NationalDesc		// 国家标准名称
				
				
				s sc=obj.%Save()
				d obj.%Close()
				if (sc=1)
				{
					s count=count+1
					w !,count
				}
				
			}
			
		}
		else
		{
			//看数据处理工厂有没有对上hiscode
			s StructureID=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",baseid," "_$zconvert(DataDesc,"U"),""))
			
			//看数据处理工厂有没有对上hiscode
			//BaseIndex
			s:StructureID="" StructureID=$o(^User.MKBStructuredDataI("HisCodeIndex",baseid,DataCode,""))
			
			if (StructureID'="")
			{
				s ^TEMPSData(StructureID)=""
				s MKBSDHisRowID=$lg($g(^User.MKBStructuredDataD(StructureID)),30)
				if (MKBSDHisRowID="")	//数据处理工厂中没有hisrowid
				{
					s obj=##class(User.MKBStructuredData).%OpenId(StructureID)
					s obj.MKBSDTCMDiagFlag=IsCFlag	/// 中医诊断标识
					s obj.MKBSDTCMSynFlag=IsCType	/// 中医证型标识
					s obj.MKBSDTumourFlag=CodeFlag		/// 肿瘤形态学编码标识
					s obj.MKBSDInjuryFlag=ReasonFlag	/// 损伤中毒外部原因标志
					s obj.MKBSDDateActiveFrom=StartDate		/// 开始日期
					s obj.MKBSDDateActiveTo=EndDate			/// 截止日期
					
					s obj.MKBSDHisRowID=HisRowID	//his诊断ID
					s obj.MKBSDHisCode=DataCode		//HIS诊断代码
					s obj.MKBSDDeputyCode=DeputyCode	//icd10副编码
					s obj.MKBSDClinicType=ClinicType	//就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）
					s obj.MKBSDClassification=Classification		//icd诊断分类
					s obj.MKBSDLimitSex=LimitSex		//限制性别
					s obj.MKBSDHisRemark=HisRemark		//注释
					s obj.MKBSDAgeFrom=AgeFrom		// 从年龄
					s obj.MKBSDAgeTo=AgeTo		//到年龄
					s obj.MKBSDICD9Code=ICD9Code		//icd9代码
					s obj.MKBSDNationalDesc=NationalDesc		// 国家标准名称
					
					
					s sc=obj.%Save()
					d obj.%Close()
					if (sc=1)
					{
						s count=count+1
						w !,count
					}
				
				}
			
			}
			else
			{
				b ;break	
			}
		}
		
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-11-22
/// Description: 处理多音字转拼音码导致的保存、显示错误问题   pinyin应该大写
/// Input:base
/// w ##class(web.DHCBL.MKB.MKBStructuredData).HandlePYByDesc("膀胱","PG")
ClassMethod HandlePYByDesc(desc, pinyin)
{
	q:(desc="")||(pinyin="") "false"
	s fpinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc)
	q:fpinyin=pinyin "false"	//重新给的拼音和原先的一致
	s errorflag=0
	s result=""
	s count=0
	ts
	//Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag);
	s MKBSDBaseDr=""
	for
	{
		s MKBSDBaseDr=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDBaseDr))
		q:MKBSDBaseDr=""
		q:errorflag=1
		s MKBSDDiag=""
		for
		{
			s MKBSDDiag=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDBaseDr,MKBSDDiag))
			q:MKBSDDiag=""
			q:errorflag=1
			s pycode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
			if (MKBSDDiag[desc)&&(pycode[fpinyin)	//包含这个描述的所有诊断
			{
				s MKBSDRowid=""
				for
				{
					s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDBaseDr,MKBSDDiag,MKBSDRowid))
					q:MKBSDRowid=""
					q:errorflag=1
					s NewDesc=$replace(MKBSDDiag,desc,pinyin)
					s NewPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(NewDesc)
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					s obj.MKBSDDiagPYCode=NewPinyin		/// 诊断名拼音码
					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						s count=count+1
						w count,!
						d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndexByCode(MKBSDRowid)
				    	d ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(MKBSDRowid)
					}
					else
					{
						s errorflag=1	
					}
					
				}
				
			}
		}
	}
	if (errorflag=0)
	{
		tc
		s result="true"	
	}
	else
	{
		tro
		s result="false"	
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate:2022-3-9
/// Description: 根据各版本ICD对照中已经标记好的国标2.0的最优，来标记其他数据处理工厂的诊断
/// Input:base
/// w ##class(web.DHCBL.MKB.MKBStructuredData).SynchronousOptimal(baseid)
ClassMethod SynchronousOptimal(baseid As %String = "")
{
	//Index InitialICDIndex On MKBICDInitialICD As Exact;
	s result=""
	s errorflag=0
	s count=0
	ts
	s MKBICDRowid=""
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastI("InitialICDIndex","Y",MKBICDRowid))
		q:MKBICDRowid=""
		
		q:errorflag=1
		s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		continue:Sources'[526477	//过滤不是国标2.0的数据
		//Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag);
		s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
		s MKBICDDesc=" "_$zconvert(MKBICDDesc,"U")
		s MKBSDBaseDr=""
		for
		{
			s MKBSDBaseDr=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",	MKBSDBaseDr))
			q:MKBSDBaseDr=""
			q:errorflag=1
			continue:((baseid'="")&&(baseid'=MKBSDBaseDr))
			s MKBSDRowid=""
			for
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",MKBSDBaseDr,MKBICDDesc,MKBSDRowid))
				q:MKBSDRowid=""
				q:errorflag=1
				s re=##class(web.DHCBL.MKB.MKBStructuredData).InitialICDUpdate(MKBSDRowid,"Y")
				if (re["false")
				{
					s errorflag=1
				}
				else
				{
					s count=count+1	
				}
			}
		}
	}
	if (errorflag=1)
	{
		s result="false"
		tro	
	}
	else
	{
		s result=count
		tc	
	}
	q result
}

}

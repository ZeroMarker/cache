Class web.DHCBL.MKB.MKBStructuredSecondData Extends %RegisteredObject
{

/// Creator：lideyuan
/// CreatDate: 2019-05-28
/// Description：通过结构化结果ID串和termdr找相同的诊断
/// Table：
/// Input：
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredSecondData","GetSameStructResult","","15701","")
Query GetSameStructResult(basedr As %String, ids As %String, termdr As %String, supplement As %String) As %Query(ROWSPEC = "Rowid,MKBSDLocStr,MKBSDLocs,Reason,MKBSDDiag,MKBSDAlias,MKBSDNote,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDOOther,MKBSDDate,MKBSDUpdateUser,MKBSDSegmentation,sumloc,MKBSDMrc,MKBSDMDr,MKBSDICD,Result,MKBSDOAlias,MKBSDDiaSource,MKBSDInitialICD,MKBSDDiagPYCode")
{
}

ClassMethod GetSameStructResultExecute(ByRef qHandle As %Binary, basedr As %String, ids As %String, termdr As %String, supplement As %String) As %Status
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
		s Rowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,Rowid))
		q:Rowid=""
		
		
		s MKBMergeFlag=$lg($g(^User.MKBStructuredDataD(Rowid)),15)
		s Base=$lg($g(^User.MKBStructuredDataD(Rowid)),22)
		continue:MKBMergeFlag'=""
		continue:Base'=basedr
		d PrintOut
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,Rowid,MKBSDRRowid))
			q:MKBSDRRowid=""

			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
			s MKBSDTermdr=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s MKBSDSupplement=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",MKBSDRRowid)),5)
			s MKBSDStructResultID=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",MKBSDRRowid)),2)
			s MKBSDInitialICD=$lg($g(^User.MKBStructuredDataD(Rowid)),18)
			s MKBSDStructResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDStructResultID,MKBSDTermdr)
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
			if MKBSDStructResult=Result
			{
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)    //MRC指向
				s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(Rowid)),12)    //别名字段
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)    //MRC指向
				s MKBSDICD=$lg($g(^User.MKBStructuredDataD(Rowid)),20)  //在ICD字段取值
				s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(Rowid)),21)  //在ICD描述字段取值

				d OutputRowCmb
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 

OutputRowCmb

    set Data=$lb(Rowid,MKBSDLocStr,MKBSDLocs,Reason,MKBSDDiag,MKBSDAlias,MKBSDNote,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDOOther,MKBSDDate,MKBSDUpdateUser,MKBSDSegmentation,sumloc,MKBSDMrc,MKBSDMDr,MKBSDICD,Result,MKBSDOAlias,MKBSDDiaSource,MKBSDInitialICD,MKBSDDiagPYCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
PrintOut
	s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
	s MKBSDLocs=""
	s MKBSDLocStr=""
	s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(Rowid)),3)  //科室串
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
	s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(Rowid)),5)
	s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(Rowid)),12)    //别名字段
	s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)    //MRC指向
	s MKBSDICD=$lg($g(^User.MKBStructuredDataD(Rowid)),20)  //在ICD字段取值
	s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(Rowid)),21)  //在ICD描述字段取值
	s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(Rowid)),6)
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
	s MKBSDDates=$lg($g(^User.MKBStructuredDataD(Rowid)),7)
	s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
	s:MKBSDDates="" MKBSDDate=""
	s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(Rowid)),8)
	s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
	s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
	s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(Rowid)),9)
	s MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(Rowid)),10)
	s sumloc=$lg($g(^User.MKBStructuredDataD(Rowid)),13)
	s MKBSDNote=$lg($g(^User.MKBStructuredDataD(Rowid)),16)    //备注  存上报理由
	s MKBSDOAlias=""
	if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",Rowid)))  //存在别名
	{
		s MKBSDORowid=0
		for
		{
			s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",Rowid,MKBSDORowid))
			q:MKBSDORowid=""
			s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructOther",MKBSDORowid)),2)
			s:MKBSDOAlias'="" MKBSDOAlias=MKBSDOAlias_"、"_MKBSDOAlias
			s:MKBSDOAlias="" MKBSDOAlias=MKBSDOAlias
		}
	}
	s MKBSDOOther=""
	if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",Rowid)))  //存在其他描述
	{
		s MKBSDORowid=0
		for
		{
			s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",Rowid,MKBSDORowid))
			q:MKBSDORowid=""
			s MKBSDOOthers=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructOther",MKBSDORowid)),2)
			s:MKBSDOOther'="" MKBSDOOther=MKBSDOOther_"、"_MKBSDOOthers
			s:MKBSDOOther="" MKBSDOOther=MKBSDOOthers
		}
	}
	s Reasons=$lg($g(^User.MKBStructuredDataD(Rowid)),17)  //上报理由
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
	s MKBSDInitialICD=$lg($g(^User.MKBStructuredDataD(Rowid)),18)
	s MKBSDDiagPYCode=$lg($g(^User.MKBStructuredDataD(Rowid)),19)
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

/// Creator：lideyuan
/// CreatDate: 2019-05-28
/// Description：通过中心词和结构化结果id串、补充诊断查找相同中心词的，但属性不同的
/// Table：
/// Input：
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredSecondData","GetNotSameIdsButSameItem","1","4998:10670*10738","14870","")
Query GetNotSameIdsButSameItem(basedr As %String, ids As %String, termdr As %String, supplement As %String) As %Query(ROWSPEC = "Rowid,MKBSDLocStr,MKBSDLocs,Reason,MKBSDDiag,MKBSDAlias,MKBSDNote,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDOOther,MKBSDDate,MKBSDUpdateUser,MKBSDSegmentation,sumloc,MKBSDMrc,MKBSDMDr,MKBSDICD,Result,MKBSDOAlias,MKBSDDiaSource,MKBSDInitialICD,MKBSDDiagPYCode")
{
}

ClassMethod GetNotSameIdsButSameItemExecute(ByRef qHandle As %Binary, basedr As %String, ids As %String, termdr As %String, supplement As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	/*
	s MKBStruct=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(ids,termdr)
	if supplement'=""
	{
		s supplement=$zstrip(supplement,"<>W")
		if MKBSDStructResult["]"
		{
			s str=$e(MKBStruct,1,*-1)
			s MKBStruct=str_",("_supplement_")]"
		}
		else
		{
			s MKBStruct=MKBStruct_"[("_supplement_")]"
		}
	}
	*/
	
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
		s Rowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,Rowid))
		q:Rowid=""
		s MKBMergeFlag=$lg($g(^User.MKBStructuredDataD(Rowid)),15)
		s Base=$lg($g(^User.MKBStructuredDataD(Rowid)),22)
		continue:MKBMergeFlag'=""
		continue:Base'=basedr
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,Rowid,MKBSDRRowid))
			q:MKBSDRRowid=""

			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
			s MKBSDTermdr=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s MKBSDSupplement=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",MKBSDRRowid)),5)
			s MKBSDStructResultID=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",MKBSDRRowid)),2)
			s MKBSDInitialICD=$lg($g(^User.MKBStructuredDataD(Rowid)),18)
			s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDStructResultID,MKBSDTermdr)
			if Result["["
			{
				s result=$p(Result,"[",2)
				s result=$p(result,"]",1)
				s resultlen=$l(result,",")
				
			}
			if MKBSDSupplement'=""
			{
				s MKBSDSupplement=$zstrip(MKBSDSupplement,"<>W")
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
			if ids'=""
			{
				s Existflag=0
				s NotExistflag=0
				continue:MKBSDStructResultID=""
				for m=1:1:$l(MKBSDStructResultID,",")
				{
					s subResPro=$p(MKBSDStructResultID,",",m)
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
				if (supplement="")&(MKBSDSupplement'="")
				{
					s NotExistflag=NotExistflag+1
				}
			
				if (Existflag=detNum)&(NotExistflag>0)&(MKBSDSupplement[supplement)
				{
					b
					s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(Rowid)),12)    //别名字段
					s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)    //MRC指向
					s MKBSDICD=$lg($g(^User.MKBStructuredDataD(Rowid)),20)  //在ICD字段取值
					s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(Rowid)),21)  //在ICD描述字段取值
					d PrintOut
					d OutputRowCmb
				}
			}
			else
			{
				if Result["["
				{
					s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(Rowid)),12)    //别名字段
					s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)    //MRC指向
					s MKBSDICD=$lg($g(^User.MKBStructuredDataD(Rowid)),20)  //在ICD字段取值
					s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(Rowid)),21)  //在ICD描述字段取值
					d PrintOut
					d OutputRowCmb
				}
			}
		}
		
	}
	
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(Rowid,MKBSDLocStr,MKBSDLocs,Reason,MKBSDDiag,MKBSDAlias,MKBSDNote,MKBSDStatus,MKBSDCenterWordID,MKBSDCenterWord,MKBSDOOther,MKBSDDate,MKBSDUpdateUser,MKBSDSegmentation,sumloc,MKBSDMrc,MKBSDMDr,MKBSDICD,Result,MKBSDOAlias,MKBSDDiaSource,MKBSDInitialICD,MKBSDDiagPYCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
PrintOut
	s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
	s MKBSDLocs=""
	s MKBSDLocStr=""
	s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(Rowid)),3)  //科室串
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
	s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(Rowid)),5)
	s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(Rowid)),12)    //别名字段
	s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)    //MRC指向
	s MKBSDICD=$lg($g(^User.MKBStructuredDataD(Rowid)),20)  //在ICD字段取值
	s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(Rowid)),21)  //在ICD描述字段取值
	s MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(Rowid)),6)
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
	s MKBSDDates=$lg($g(^User.MKBStructuredDataD(Rowid)),7)
	s:MKBSDDates'="" MKBSDDate=$zd(MKBSDDates)
	s:MKBSDDates="" MKBSDDate=""
	s MKBSDUpdateUsers=$lg($g(^User.MKBStructuredDataD(Rowid)),8)
	s:MKBSDUpdateUsers'="" MKBSDUpdateUser=$p($g(^SSU("SSUSR",MKBSDUpdateUsers)),"^",2)
	s:MKBSDUpdateUsers="" MKBSDUpdateUser=""
	s MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(Rowid)),9)
	s MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(Rowid)),10)
	s sumloc=$lg($g(^User.MKBStructuredDataD(Rowid)),13)
	s MKBSDNote=$lg($g(^User.MKBStructuredDataD(Rowid)),16)    //备注  存上报理由
	s MKBSDOAlias=""
	if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",Rowid)))  //存在别名
	{
		s MKBSDORowid=0
		for
		{
			s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",Rowid,MKBSDORowid))
			q:MKBSDORowid=""
			s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructOther",MKBSDORowid)),2)
			s:MKBSDOAlias'="" MKBSDOAlias=MKBSDOAlias_"、"_MKBSDOAlias
			s:MKBSDOAlias="" MKBSDOAlias=MKBSDOAlias
		}
	}
	s MKBSDOOther=""
	if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",Rowid)))  //存在其他描述
	{
		s MKBSDORowid=0
		for
		{
			s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",Rowid,MKBSDORowid))
			q:MKBSDORowid=""
			s MKBSDOOthers=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructOther",MKBSDORowid)),2)
			s:MKBSDOOther'="" MKBSDOOther=MKBSDOOther_"、"_MKBSDOOthers
			s:MKBSDOOther="" MKBSDOOther=MKBSDOOthers
		}
	}
	s Reasons=$lg($g(^User.MKBStructuredDataD(Rowid)),17)  //上报理由
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
	s MKBSDInitialICD=$lg($g(^User.MKBStructuredDataD(Rowid)),18)
	s MKBSDDiagPYCode=$lg($g(^User.MKBStructuredDataD(Rowid)),19)
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

/// Creator:石萧伟
/// CreatDate:2019-05-08
/// Description:最优icd维护
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBStructuredSecondData).InitialICDUpdate()
ClassMethod InitialICDUpdate(rowid As %String, MKBSDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)        ;先备份再更新
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
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

/// Creator:丁亚男
/// CreatDate:2018-07-30
/// Description：获取属性内容列表的数据
/// Input：rowid, desc, base, rows, page, sortway,closeflag
/// Return:Json格式的字符串
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredSecondData).GetMyList("41142","","5",10,1)
ClassMethod GetMyList(rowid, desc, base, rows, page, sortway, closeflag As %String = "", stbbase) As %String
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
			s MKBSDInitialICD=..FindTheBestMatchICD(MKBTRowId,stbbase)
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
			
			s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_""","_ExtendStr_"}"
		    s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_"""}"
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
							s MKBSDInitialICD=..FindTheBestMatchICD(MKBTRowId,stbbase)
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
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_"""}"
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
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_"""}"
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
							s MKBSDInitialICD=..FindTheBestMatchICD(MKBTRowId,stbbase)
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
										s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_""","_ExtendStr_"}"
			    						s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_"""}"
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
									s:ExtendStr'="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_""","_ExtendStr_"}"
			    					s:ExtendStr="" mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTActiveFlag"":"""_MKBTActiveFlag_""",""MKBTDetailCount"":"""_MKBTDetailCount_""",""MKBSDInitialICD"":"""_MKBSDInitialICD_"""}"   
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
/// CreatDate:2019-02-28
/// Description：获取在左侧纵向展示栏展示的属性名称
/// Table：User.MKBTermBase
/// Input：术语库注册id
/// Return：成功返回属性名称的串 ,失败返回""
/// w ##class(web.DHCBL.MKB.MKBTerm).GetShowInLeftInfo("62")
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

/*/// Creator:李得原
/// CreatDate:2019-06-11
/// Description：数据处理二场左侧是否是最适ICD，如果是 输出Y
/// Input：termdr
/// Return:如果是最适icd则返回1，如果不是返回0
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredSecondData).FindTheBestMatchICD(termdr)
ClassMethod FindTheBestMatchICD(termdr)
{
	s flag="N"
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataI("InitialICDIndex","Y",MKBSDRowid))
		q:MKBSDRowid=""
		if $d(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid))
		{
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid,MKBSDRRowid))
				q:MKBSDRRowid=""
				s ResultId=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				if ResultId=""
				{
					s flag="Y"
				}
			}
		}
	}
	q flag
}*/
/// Creator:张云越
/// CreatDate:2019-12-16
/// Description：各版本ICD左侧是否是最适ICD，如果是 输出Y
/// Input：termdr
/// Return:如果是最适icd则返回1，如果不是返回0
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredSecondData).FindTheBestMatchICD(15614)
ClassMethod FindTheBestMatchICD(termdr, stbbase)
{
	s flag="N"	
	s MKBSDRowid=""
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid)) //term对应的各版本ICD对照id
		q:MKBSDRowid=""

		if $d(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid)) 
		{
			s MKBSDBaseDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22) 
			continue:MKBSDBaseDr'=stbbase
			s MKBSDInitialICD = $lg($g(^User.MKBStructuredDataD(MKBSDRowid)),18) //是否最优
			continue:MKBSDInitialICD'="Y"
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid,MKBSDRRowid))
				q:MKBSDRRowid=""
				s ResultId=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
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

/// Creator:陈代雷
/// CreatDate:2020-02-05
/// Description:根据数据处理工厂id获取对应二厂描述
/// Table:User.MKBTerm
/// Input：id 数据处理工厂ID
/// Return:成功返回对应二厂描述
/// w ##class(web.DHCBL.MKB.MKBStructuredSecondData).getSecondStruDesc()
ClassMethod getSecondStruDesc(base As %String) As %String
{

	s termDesc=""
	s:base'="" termDesc = $LISTGET($G(^User.MKBStructuredBaseD(base)),2)
	s termDesc=$replace(termDesc,"工厂","二厂")
	q termDesc
}

}

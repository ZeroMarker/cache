Class web.DHCBL.MKB.MKBStructIndex Extends %RegisteredObject
{

/// 入参：flag-为空：默认只生成数据处理工厂索引，flag-1：只生成各版本ICD对照索引，flag-2:既生成各版本ICD对照又生成数据处理工厂全文索引
/// 数据处理工厂
/// d ##class(web.DHCBL.MKB.MKBStructIndex).GenerateIndex()
ClassMethod GenerateIndex(flag As %String = "")
{
	k ^User.MKBStructIndexD
	k ^User.MKBStructIndexI
	
	if (flag="")||(flag="2")
	{
		s MKBSDRowId=0
		for
		{
			s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
			q:MKBSDRowId=""
			
			s MKBSDDiag = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2) ///诊断短语
			;s MKBSDAlias = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),12) ///诊断别名
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),11)    //MRC指向
			s Base=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),22)
			if (Base'="")
			{
				if (MKBSDDiag'="")
				{
					s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),19)
					d ..SingleSave(Base,PY,MKBSDRowId)
					d ..SingleSave(Base,MKBSDDiag,MKBSDRowId)	
				}
				//生成别名的索引
				s OtherID=0
				for
				{
					s OtherID=$o(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",OtherID))
					q:OtherID=""
					s RowID=MKBSDRowId_"||"_OtherID
					s OtherDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",OtherID)),2)
					d ..SingleSave(Base,OtherDesc,RowID)
					s PYCode=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructOther",OtherID)),4)
					d ..SingleSave(Base,PYCode,RowID)
				}
				/*	
				if (MKBSDAlias'="")
				{
					d ..SingleSave(##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDAlias),MKBSDRowId)	
					d ..SingleSave(MKBSDAlias,MKBSDRowId)	
				}
				*/
				s MKBSDICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
				if MKBSDICD'=""
				{
					;s MKBSDMrc=$p(^MRC("ID",MKBSDMDr),"^",2)                    //MRC中文描述
					                
					d ..SingleSave(Base,MKBSDICD,MKBSDRowId)      //ICD
				}
			}
			
		}
		w "数据处理工厂全文索引生成完成！"_$zdt($h,3),!
		//w ##class(web.DHCBL.MKB.MKBStructIndex).GenerateProLocIndexinColumn()
		//w ";数据处理工厂专业科室查询索引生成完成"_$zdt($h,3),!
	}
	if (flag="1")||(flag="2")
	{
		d ##class(web.DHCBL.MKB.MKBStructIndex).GenerateICD()
		w ";各版本ICD对照界面索引生成完成"_$zdt($h,3),!
	}
	s ^TMP("web.DHCBL.MKB.MKBStructIndex")=$zdt($h,3)
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-18
/// Description:生成各版本icd对照数据的索引
/// Table:
/// Input:
/// Return:查询数据
/// Other:w ##class(web.DHCBL.MKB.MKBStructIndex).GenerateICD()
ClassMethod GenerateICD()
{
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		d ..SaveICDIndexByCode(MKBICDRowid)
	}
}

/// Creator:李欣
/// CreatDate:2021-04-28
/// Description:单个描述/icd/拼音生成索引
/// Table:
/// Input:
/// Return:查询数据
/// Other:w ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave("abcd","1")
ClassMethod SingleSave(MKBSIBase, str, MKBSDRowId)
{
	q:((str="")||(MKBSIBase="")||(MKBSDRowId="")) 0
	s str = ##class(web.DHCBL.MKB.BDPMKBIndex).Filter(str)
	s len = $l(str)
	for i=1:1:len
	{
		s char(i) = $e(str,i)
		s arr(i) = char(i)	
	}
	s count = len + 1
	if (len>=20)
	{
		for l=1:1:len
		{
			if (l+19>=len)
			{
				s tlen = len 	
			}
			else
			{
				s tlen = l+19	
			}
			for m=l+1:1:tlen
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	else
	{
		for l=1:1:len
		{
			for m=l+1:1:len
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	for p=1:1:count-1
	{   
	    s desc=arr(p)	
	    s upDesc=" "_$ZCONVERT(desc,"U") //转换成大写  
	    if ($D(^User.MKBSrtuctIndexI("DescIndex",MKBSIBase,upDesc,MKBSDRowId))=0)
		{
			s obj=##class(User.MKBStructIndex).%New()
			s obj.MKBSICode=MKBSDRowId
			s obj.MKBSIDesc = desc          //修改描述
			s obj.MKBSIBase=MKBSIBase		//数据处理工厂或各版本ICD对照指向
			s sc=obj.%Save()
			d obj.%Close()
		}
	}

	q 1
}

/// Creator:李得原
/// CreatDate:2019-04-24
/// Description：删除数据处理工厂或者各版本icd数据的索引
/// Table：
/// Input：MKBSIBase  数据处理工厂或者各版本icd的指向 （各版本icd带有“ICD”的前缀），MKBSDRowId 对应的id
/// Return：
/// d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex("",643)
ClassMethod DeleteIndex(MKBSIBase, str, MKBSDRowId)
{
	s start=$zdt($now())
	s result=""
	q:((str="")||(MKBSIBase="")||(MKBSDRowId="")) 0
	s str = ##class(web.DHCBL.MKB.BDPMKBIndex).Filter(str)
	s len = $l(str)
	for i=1:1:len
	{
		s char(i) = $e(str,i)
		s arr(i) = char(i)	
	}
	s count = len + 1
	if (len>=10)
	{
		for l=1:1:len
		{
			if (l+9>=len)
			{
				s tlen = len 	
			}
			else
			{
				s tlen = l+9	
			}
			for m=l+1:1:tlen
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	else
	{
		for l=1:1:len
		{
			for m=l+1:1:len
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	
	for p=1:1:count-1
	{   
	    s desc=arr(p)	
	    s upDesc=" "_$ZCONVERT(desc,"U") //转换成大写 
	    if ($D(^User.MKBStructIndexI("DescIndex",MKBSIBase,upDesc,MKBSDRowId)))
		{
			Ts
			s rowid=$o(^User.MKBStructIndexI("DescIndex",MKBSIBase,upDesc,MKBSDRowId,0))
			s sc=##class(User.MKBStructIndex).%DeleteId(rowid)
			if $$$ISOK(sc)
			{
				Tc
				set result = "{success:'true',info:'删除成功！'}"
			}
			else
			{
				Tro
				set result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
			}
		}
	}
	s end=$zdt($now())
	;w start_"-->"_end
	q result
}

/// Creator:李得原
/// CreatDate:2019-04-24
/// Description：数据处理工厂通过父表科室字段中的科室ID串生成科室全文索引	暂时没有用，没有生成科室的索引
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructIndex).GenerateProLocIndexinColumn()
ClassMethod GenerateProLocIndexinColumn()
{
	s sum=0
	s MKBTermBase=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s ProLocIds=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
		continue:ProLocIds=""
		s sum=sum+1
		s len=$l(ProLocIds,",")
		for i=1:1:len
		{
			s ProLocId=$p(ProLocIds,",",i)
			continue:ProLocId=""
			s ProLoc=$lg($g(^User.MKBTermD(ProLocId)),3)
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(ProLoc, MKBSDRowid_"L")
		}
	}
	q sum
}

/// Creator:钟荣枫 
/// CreatDate:2021-9-10
/// Description：删除各版本icd对照的单条数据的全文索引
/// Table：User.MKBStructIndex
/// Input：Code-各版本icd对照的id
/// Return：true/false
/// Other: w ##class(web.DHCBL.MKB.MKBStructIndex).DeleteICDIndexByCode(Code)
ClassMethod DeleteICDIndexByCode(Code As %String) As %String
{
	q:(Code="") "{success:'false',info:'传入的各版本icd对照的ID为空！'}"
	s MKBICDRowid=Code
	s result=""
	TS
	s SourceStr=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
	for m=1:1:$l(SourceStr,",")
	{
		s Source=$p(SourceStr,",",m)
		continue:Source=""
		s rowid=""
		for
		{   
			s rowid=$o(^User.MKBStructIndexI("CodeIndex","ICD"_Source,Code,rowid))
			q:rowid=""
			s sc=##class(User.MKBStructIndex).%DeleteId(rowid)
			if $$$ISOK(sc)
			{
				s result = "{success:'true',info:'删除成功！'}"
			}
			else
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
			}		
		}
		q:result["false"
	}
	
	
	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"
	}

	q result
}

/// Creator:谷雪萍
/// CreatDate:2021-04-15
/// Description：修改数据处理工厂数据时要先删除全文索引，再重新生成   2021-9-10钟荣枫 允许删除各版本icd对照的全文索引
/// Table：User.MKBStructIndex
/// Input：Code-数据处理工厂的id
/// Return：true/false
/// Other: w ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndexByCode(Code)
ClassMethod DeleteIndexByCode(Code As %String) As %String
{
	q:(Code="") "{success:'false',info:'传入的ID为空！'}"
	s result=""
	TS
	s Base=$lg($g(^User.MKBStructuredDataD(Code)),22)
	q:Base="" "{success:'false',info:'所属的数据工厂为空！'}"
	s rowid=""
	for
	{   
		s rowid=$o(^User.MKBStructIndexI("CodeIndex",Base,Code,rowid))
		q:rowid=""
		s sc=##class(User.MKBStructIndex).%DeleteId(rowid)
		if $$$ISOK(sc)
		{
			s result = "{success:'true',info:'删除成功！'}"
		}
		else
		{
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
		}		
	}
	
	
	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"
	}

	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-09-10
/// Description：生成一条各版本icd对照数据的索引 	
/// Table：User.MKBStructIndex
/// Input：Code-各版本icd对照的id
/// Return：1-成功，0-失败
/// Other: w ##class(web.DHCBL.MKB.MKBStructIndex).SaveICDIndexByCode(Code)
ClassMethod SaveICDIndexByCode(Code As %String) As %String
{
	q:Code="" "{success:'false',info:'传入的各版本icd对照ID为空！'}"
	s MKBICDRowid=Code
	
	s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
	
	s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
	s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
	s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)

	if (MKBICDDesc'="")		//描述
	{
		for i=1:1:$l(Sources,"&")
		{
			s Source=$p(Sources,"&",i)
			continue:Source=""
			d ..SingleSave("ICD"_Source,MKBICDDesc,MKBICDRowid)			//描述
			s PY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDDesc)
			d ..SingleSave("ICD"_Source,PY,MKBICDRowid)					//拼音
		}
	
	}
	if (MKBICDNumber'="")	//icd
	{
		for i=1:1:$l(Sources,"&")
		{
			s Source=$p(Sources,"&",i)
			continue:Source=""
			d ..SingleSave("ICD"_Source,MKBICDNumber,MKBICDRowid)					//拼音
		}
	}
	
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2021-04-15
/// Description：生成一条数据处理工厂数据的索引 	
/// Table：User.MKBStructIndex
/// Input：Code-数据处理工厂的id
/// Return：1-成功，0-失败
/// Other: w ##class(web.DHCBL.MKB.MKBStructIndex).SaveIndexByCode(Code)
ClassMethod SaveIndexByCode(Code As %String) As %String
{
	q:Code="" "{success:'false',info:'传入的数据处理工厂ID为空！'}"
	s MKBSDRowId=Code
	s MKBSDDiag = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2) ///诊断短语
	s Base=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),22)
	if (MKBSDDiag'="")
	{
		s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),19)
		if (PY'="")
		{
			d ..SingleSave(Base,PY,MKBSDRowId)
		}
		d ..SingleSave(Base,MKBSDDiag,MKBSDRowId)	
	}
	s MKBSDICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
	if MKBSDICD'=""
	{               
		d ..SingleSave(Base,MKBSDICD,MKBSDRowId)      //ICD
	}
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-03-30
/// Description：用于数据处理工厂数据新增修改时实现数据校验功能的方法
/// Input：id-数据处理工厂的ID，baseDr-工厂注册ID，desc-诊断名，code-ICD代码
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.MKB.MKBStructIndex).FormValidate("","","")
ClassMethod FormValidate(id As %String, baseDr As %String, desc As %String, code As %String) As %String
{
	q:(baseDr="")||(desc="")||(code="") 1
	s flag="",flagc=""
	s flagc=$d(^User.MKBStructuredDataI("DiagICDIndex",baseDr,desc,code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=$o(^User.MKBStructuredDataI("DiagICDIndex",baseDr,desc,code,0))
		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:谷雪萍
/// CreatDate:2021-04-15
/// Description：提供接口：新增、修改his诊断要同步数据处理工厂。
/// Table：User.MKBStructuredData、User.MKBStructIndex
/// Input：ICD代码^ICD描述^是否中医诊断^是否中医症型^肿瘤形态学编码标志^损伤中毒外部原因标志^开始日期^结束日期^修改前ICD代码^修改前ICD描述
/// Return：true/false
/// Other: w ##class(web.DHCBL.MKB.MKBStructIndex).HisICDSyncToDataFactory()
ClassMethod HisICDSyncToDataFactory(dataStr As %String) As %String
{
	s result=""
	s MKBSDBaseDr= ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")  //诊断短语来源
	if (MKBSDBaseDr["ICD")||(MKBSDBaseDr="")
	{
		q "{success:'true',info:'平台配置里诊断来源不是数据处理工厂，不需要同步数据！'}"
	}
	q:dataStr="" "{success:'false',info:'his诊断传过来的数据为空，数据处理工厂数据同步失败！'}"
	s NewDiagCode=$p($g(dataStr),"^",1)
	s NewDiagDesc=$p($g(dataStr),"^",2)
	if (NewDiagCode="")||(NewDiagDesc="")
	{
		q "{success:'false',info:'his诊断传过来的代码或描述为空，数据处理工厂数据同步失败！'}"
	}
    s BeforeDiagCode=$p($g(dataStr),"^",9)
	s BeforeDiagDesc=$p($g(dataStr),"^",10)
	s MKBSDRowId=""
	if (BeforeDiagCode'="")&(BeforeDiagDesc'="") //如果修改前的代码和描述不为空，则为修改，获取数据处理工厂rowid 
	{
		s MKBSDRowId=$o(^User.MKBStructuredDataI("DiagICDIndex",MKBSDBaseDr,BeforeDiagDesc,BeforeDiagCode,""))
	}
	s:MKBSDRowId="" MKBSDRowId=$o(^User.MKBStructuredDataI("DiagICDIndex",MKBSDBaseDr,NewDiagDesc,NewDiagCode,""))
	s codeFlag=..FormValidate(MKBSDRowId,MKBSDBaseDr,NewDiagDesc,NewDiagCode)  //调用重复验证

	if (codeFlag=1)
	{
		q "{success:'false',errorinfo:'数据处理工厂中该记录已经存在！'}"
	}
	
	if (MKBSDRowId'="")
	{
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowId) 
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%New()
	} 
    s obj.MKBSDDiag =NewDiagDesc
    d obj.MKBSDBaseDrSetObjectId(MKBSDBaseDr)
    s obj.MKBSDDiaSource = "HIS诊断"
    s obj.MKBSDICD = NewDiagCode
    s obj.MKBSDICDDesc = NewDiagDesc
    s obj.MKBSDDiagPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(NewDiagDesc)
    s obj.MKBSDStatus = "N"
    s obj.MKBSDTotalFreq = "0"
    s obj.MKBSDTCMDiagFlag=$p($g(dataStr),"^",3)
    s obj.MKBSDTCMSynFlag=$p($g(dataStr),"^",4)
    s obj.MKBSDTumourFlag=$p($g(dataStr),"^",5)
    s obj.MKBSDInjuryFlag=$p($g(dataStr),"^",6)
    s obj.MKBSDDateActiveFrom=$p($g(dataStr),"^",7)
    s obj.MKBSDDateActiveTo=$p($g(dataStr),"^",8)
    TS
    s sc=obj.%Save()
    d obj.%Close()
    if (sc=1)		//保存成功则生成全文索引
    {
	    tc
	    set id=obj.%Id()
	    s result = "{success:'true',info:'同步成功！'}"
	    if (MKBSDRowId'="")&((NewDiagCode'=BeforeDiagCode)||(NewDiagDesc'=BeforeDiagDesc))  //如果是修改，且是修改的编码或描述，则需要先删除全文索引，再重新生成索引
    	{
	    	d ..DeleteIndexByCode(id)
	    	d ..SaveIndexByCode(id)
    	}
    	if (MKBSDRowId="") //如果是新增,则生成全文索引
    	{
	    	d ..SaveIndexByCode(id)
    	}
    }
    else
    {
	    tro
	    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
    }
    q result
}

/// Creator:谷雪萍
/// CreatDate:2021-06-16
/// Description：提供接口：新增、修改his诊断要同步数据处理工厂。
/// Table：User.MKBStructuredData、User.MKBStructIndex
/// Input：ICDJson：his诊断的JSon信息
/// Return：true/false
/// Other: w ##class(web.DHCBL.MKB.MKBStructIndex).HisICDJsonSyncToDataFactory(ICDJson)
ClassMethod HisICDJsonSyncToDataFactory(ICDJson As %String) As %String
{
	s ICDJson=[].%FromJSON(ICDJson)
	s result=""
	s MKBSDBaseDr= ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")  //诊断短语来源
	if (MKBSDBaseDr["ICD")||(MKBSDBaseDr="")
	{
		q "{success:'true',info:'平台配置里诊断来源不是数据处理工厂，不需要同步数据！'}"
	}
	s NewDiagCode=ICDJson.MRCIDICD9CMCode
	s NewDiagDesc=ICDJson.MRCIDDesc
	if (NewDiagCode="")||(NewDiagDesc="")
	{
		q "{success:'false',info:'his诊断传过来的代码或描述为空，数据处理工厂数据同步失败！'}"
	}
    s MKBSDHisRowID=ICDJson.MRCIDRowId
	s MKBSDRowId="",BeforeDiagCode="",BeforeDiagDesc=""
	if (MKBSDHisRowID'="") //通过his诊断ID获取数据处理工厂rowid 
	{
		s MKBSDRowId=$o(^User.MKBStructuredDataI("HisIDIndex",MKBSDBaseDr,MKBSDHisRowID,"")) //数据处理工厂ID
		if (MKBSDRowId'="")  //如果数据处理工厂ID已存在则为修改
		{
			s BeforeDiagCode=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),20)  //数据处理工厂诊断编码
			s BeforeDiagDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),2)  //数据处理工厂诊断描述
		}
		else		//原先录入his诊断数据时，没有录入his的id ,但现在采用的同步方法都会传his的id
		{

			s MKBSDRowId=$o(^User.MKBStructuredDataI("DiagICDIndex",MKBSDBaseDr,NewDiagDesc,NewDiagCode,"")) //数据处理工厂ID
		}
	}
	
	
	if (MKBSDRowId'="")
	{
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowId) 
	}
	else
	{
		s obj=##class(User.MKBStructuredData).%New()
	} 
    s obj.MKBSDDiag =NewDiagDesc
    d obj.MKBSDBaseDrSetObjectId(MKBSDBaseDr)
    s obj.MKBSDDiaSource = "HIS诊断"
    s obj.MKBSDICD = NewDiagCode
    s obj.MKBSDICDDesc = NewDiagDesc
    s obj.MKBSDDiagPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(NewDiagDesc)
    s obj.MKBSDStatus = "N"
    s obj.MKBSDTotalFreq = "0"
    s obj.MKBSDTCMDiagFlag=ICDJson.MRCIDBillFlag3  //中医诊断标识
    s obj.MKBSDTCMSynFlag=ICDJson.MRCIDBillFlag1  //中医证型标识
    s obj.MKBSDTumourFlag=ICDJson.MRCIDMetastaticSite  //肿瘤形态学编码标识
    s obj.MKBSDInjuryFlag=ICDJson.MRCIDInjuryPoisoningCode  //损伤中毒外部原因标志
    s MRCIDDateActiveFrom=ICDJson.MRCIDDateActiveFrom
    s:MRCIDDateActiveFrom'="" MRCIDDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(MRCIDDateActiveFrom)
    s obj.MKBSDDateActiveFrom=MRCIDDateActiveFrom //开始日期
    s MRCIDDateActiveTo=ICDJson.MRCIDDateActiveTo
    s:MRCIDDateActiveTo'="" MRCIDDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(MRCIDDateActiveTo)
    s obj.MKBSDDateActiveTo= MRCIDDateActiveTo //截止日期
    s obj.MKBSDHisRowID=ICDJson.MRCIDRowId //his诊断id 
    s obj.MKBSDHisCode=ICDJson.MRCIDCode  //his诊断代码
    s obj.MKBSDDeputyCode=ICDJson.MRCID2ndCodeInPair  //付编码
    s obj.MKBSDClinicType=ICDJson.MRCIDClinicType  //就诊类型
    s obj.MKBSDClassification=ICDJson.MRCIDTypeDR  //ICD诊断分类
    s obj.MKBSDLimitSex=ICDJson.MRCIDSexDR  //限制性别
    s obj.MKBSDHisRemark=ICDJson.MRCIDLongDescription  //注释
    s obj.MKBSDAgeFrom=ICDJson.MRCIDAgeFrom // 从年龄
 	s obj.MKBSDAgeTo=ICDJson.MRCIDAgeTo // 到年龄
  	s obj.MKBSDICD9Code=ICDJson.MRCIDICD9Map // ICD9 Code
   	s obj.MKBSDNationalDesc=ICDJson.MRCIDNationalDesc // 国家标准编码

    TS
    s sc=obj.%Save()
    d obj.%Close()
    if (sc=1)		//保存成功则生成全文索引
    {
	    tc
	    set id=obj.%Id()
	    s result = "{success:'true',info:'同步成功！'}"
	    if (MKBSDRowId'="")&((NewDiagCode'=BeforeDiagCode)||(NewDiagDesc'=BeforeDiagDesc))  //如果是修改，且是修改的编码或描述，则需要先删除全文索引，再重新生成索引
    	{
	    	d ..DeleteIndexByCode(id)
	    	d ..SaveIndexByCode(id)
    	}
    	if (MKBSDRowId="") //如果是新增,则生成全文索引
    	{
	    	d ..SaveIndexByCode(id)
    	}
    }
    else
    {
	    tro
	    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
    }
    q result
}

}

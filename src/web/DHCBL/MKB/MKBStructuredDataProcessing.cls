/// Description： 读取excel数据中诊断与科室，统计诊断频次以及匹配中心词
/// Creator：李得原
/// Date： 2018-11-22
Class web.DHCBL.MKB.MKBStructuredDataProcessing Extends %RegisteredObject
{

/// Creator:李得原
/// CreatDate:2018-11-22
/// Description:获取excel中数据处理后并计算频次
/// Table:
/// Input:
/// Return:匹配结果
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredDataProcessing).DataProcessing("D:\cache\北京安贞医院.csv")
ClassMethod DataProcessing(path As %String) As %String
{
	 k ^TempDiag
	 k ^UniqueDiag
	 k ^TempTermData
	 s flag=0
	 if ##class(%File).Exists(path) 
	 {
		Set file=##class(%File).%New(path)
		d file.Open("RS")
		s a= file.ReadLine()
		while 'file.AtEnd
		{
			s DiagLine= file.ReadLine()
			s GetLocs=$p(DiagLine,",",7)       ;获取科室列
			s GetLoc=$Zstrip(GetLocs,"<>W")
			s Loc=GetLoc_"(安贞)"
			s Diags=$p(DiagLine,",",8)		;获取诊断列
			s Diag=$Replace(Diags,"；",";")
			s Diag=$Replace(Diag,")","）")
			s Diag=$Replace(Diag,"(","（")
			s DiagLength=$l(Diag,";")
			for i=1:1:DiagLength
			{
				s EveryDiag=$p(Diag,";",i)
				s DiagDesc=$p(EveryDiag,".",2)
				s DiagData=$Zstrip(DiagDesc,"<>W")
				if DiagData'=""
				{
					s Diagid=$d(^TempDiag(DiagData))
					if Diagid>0
					{
						s LocFlag=$d(^TempDiag(DiagData,Loc))
						if LocFlag>0            ;如果已存在，则计数加1
						{
							s ^TempDiag(DiagData,Loc)=^TempDiag(DiagData,Loc)+1
						}
						else                    ;如果不存在,则置值为1
						{
							s ^TempDiag(DiagData,Loc)=1
						}
					}
					else
					{
						s ^TempDiag(DiagData,Loc)=1
					}
				}
			}		
		}
		d file.Close()
		d ..GetUnique()
		s ProgressValue= ..DataMatch()
		s result=..SaveData()
	}
	else
	{
		set result = "{success:'false',info:'文件不存在'}"
	}
	quit result
}

/// Creator:李得原
/// CreatDate:2018-11-22
/// Description:去除重复诊断数据用于和中心词匹配
/// Table:
/// Input:
/// Return:匹配结果
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredDataProcessing).GetUnique()
ClassMethod GetUnique() As %String
{
	s Diag=""
	s Sum=0
	for
	{
		s Diag=$o(^TempDiag(Diag))
		q:Diag=""
		s Diag=$Zstrip(Diag,"<>W")
		if $d(^UniqueDiag(Diag))
		{
			s ^UniqueDiag(Diag)=^UniqueDiag(Diag)+1
		}
		else
		{
			s ^UniqueDiag(Diag)=1
			s Sum=Sum+1
		}
	}
	quit "完成数据去重操作，共"_Sum_"个诊断"
}

/// Creator:李得原
/// CreatDate:2018-11-22
/// Description:把能匹配到中心词的诊断记录下来
/// Table:
/// Input:
/// Return:匹配结果
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredDataProcessing).DataMatch()
ClassMethod DataMatch() As %String
{
	set m=0
	set Diag=""
	for
	{
		s Diag=$o(^UniqueDiag(Diag))   ;获取诊断数据
		q:Diag=""
		s DiagTemp=$Zstrip(Diag,"<>W")
		set MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
		s MKBTRowid = 0
		for
		{
			set MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
			quit:MKBTRowid="" 
			set TermData=$lg($g(^User.MKBTermD(MKBTRowid)),3)  ;获取中心词
			if Diag[TermData
			{
				s ^TempTermData(DiagTemp,MKBTRowid)=""     ;存储中心词rowid
				s m=m+1
			}
			else
			{
				set AliasItem=""
				;获取未匹配到的中心词的别名
				s AliasNum=0
				set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowid)    
				set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
				set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
				s n=0
				for i=1:1:AliasNum
				{
					set AliasItem=$p(TermDataAlias,",",i)
					if Diag[AliasItem
					{
						s ^TempTermData(DiagTemp,MKBTRowid)=""
						s n=n+1
						if n=1
						{
							s m=m+1
						}
					}
				}
			}
		}
	} 
	quit "匹配到的个数："_m
}

/// Creator:李得原
/// CreatDate:2018-11-22
/// Description:保存诊断科室、中心词、频次
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructuredDataProcessing).SaveData()
ClassMethod SaveData() As %String
{
	Ts
	s n=0
	s diag=""
	for
	{
		s n=n+1
		s diag=$o(^UniqueDiag(diag))
		q:diag=""
		s diag=$Zstrip(diag,"<>W")
		k ^TempFrequent
		s locstr=""
		s wordstr=""
		s frequent=""
		s flag=0
		s frank=""
		s loc=""
		
		if ($d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(diag,"U"))))   ;如果存在相同诊断
		{
			for
			{
				s loc=$o(^TempDiag(diag,loc))
				q:loc=""		
				           
				s TempCount=^TempDiag(diag,loc)  ;通过科室取到新增频次
				s DiagRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(diag,"U"),0))
				;s UserDiag=^User.MKBStructuredDataD(DiagRowid)
				s UserLoc=$lg(^User.MKBStructuredDataD(DiagRowid),3)
				s UserF=$lg(^User.MKBStructuredDataD(DiagRowid),4)         ;获取原来频次字符串
				s UserLocLen=$l(UserLoc,",")
				s Tempstr=""
				s Sign=0   ;用来标记是否存在相同科室
				if UserLoc[loc
				{
					for i=1:1:UserLocLen
					{
						s TempUserLoc=$p(UserLoc,",",i)
						if TempUserLoc=loc                      ;如果相同诊断存在相同科室
						{
							s OldF=""
							s NewF=""
							s OldF=$p(UserF,",",i)
							s NewF=OldF+TempCount      			;频次相加
							
							;替换原数据库中的频次字符串
							if i=1
							{
								if UserLocLen=1
								{
									s Tempstr=NewF
								}
								else
								{
									s Tempstr=NewF_","_$p(UserF,",",2,UserLocLen) 
								}
							}
							elseif i=UserLocLen
							{
								 s Tempstr=$p(UserF,",",1,UserLocLen-1)_","_NewF
							}
							else
							{
								s Tempstr=$p(UserF,",",0,i-1)_","_NewF_","_$p(UserF,",",i+1,UserLocLen)
							}
							s Sign=Sign+1
						}
						
					}
				}
				if Sign=0    							 ;不存在相同科室
				{
					s Tempstr=UserF_","_TempCount
					s locstr=UserLoc_","_loc
				}
				if Tempstr'=""
				{
					
					s obj= ##class(User.MKBStructuredData).%OpenId(DiagRowid)
					s obj.MKBSDFrequency=Tempstr
					s:locstr'="" obj.MKBSDLoc=locstr
				
					s sc= obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						
						set result = "{success:'true',info:'上传成功！'}"
					}
					else
					{
						
						set result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						q
					}
				}
			}

		}
		else
		{
			for
			{
				s loc=$o(^TempDiag(diag,loc))
				q:loc=""		
				s frank=^TempDiag(diag,loc)
				s ^TempFrequent(frank,loc)=""                
			}
			s frank=""
			for
			{
				s frank=$o(^TempFrequent(frank),-1)
				q:frank=""
				s lloc=""
				for
				{
					s lloc=$o(^TempFrequent(frank,lloc))
					q:lloc=""
					s:locstr'="" locstr=locstr_","_lloc   ;拼接科室字符串
					s:locstr="" locstr=lloc
					s:frequent'="" frequent=frequent_","_frank    ;拼接频次字符串
					s:frequent="" frequent=frank
				}
			}
			s wordstr=""
			if $d(^TempTermData(diag))
			{
				s word=""     ;中心词
				for
				{
					s word=$o(^TempTermData(diag,word))
					q:word=""
					s:wordstr'="" wordstr=wordstr_","_word  ;拼接中心词字符串
					s:wordstr="" wordstr=word		
				}			
			}
			s obj= ##class(User.MKBStructuredData).%New()
			s diag=$Zstrip(diag,"<>W")
			s obj.MKBSDDiag=diag
			s obj.MKBSDLoc=locstr
			s obj.MKBSDFrequency=frequent
			s obj.MKBSDStatus="N" 
			s obj.MKBSDCenterWordID=wordstr
			
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				
				set result = "{success:'true',info:'上传成功！'}"
			}
			else
			{
				
				set result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
				q
			}
		}
		

	}
	if result["上传成功"
	{
		Tc
	}
	else
	{
		Tro
	}
	quit result
}

/// Creator:李得原
/// CreatDate:2018-11-22
/// Description:把分词结果保存到表中
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructuredDataProcessing).ReadExcel()
ClassMethod ReadExcel()
{
	s file=##class(%File).%New("C:/Users/Administrator/Desktop/石小伟/diag.csv")
	d file.Open("RS")
	s str= file.ReadLine()
	While 'file.AtEnd
	{
		s Diagstrs=""
		s Wordstr=""
		
		s str= file.ReadLine()
		s Diagstrs=$p(str,",",1)
		s Wordstr=$p(str,",",2)
		s Feature=$p(str,",",3)
		s mix=""
		s Diagstr=$zstrip(Diagstrs,"<>W")
		s Diagstr=$ZCONVERT(Diagstr,"U") //转换成大写	
		s:Feature'="" mix=Wordstr_"("_Feature_")"
		s:Feature="" mix=Wordstr
		s rowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Diagstr,0))
		if rowid=""
		{
			b ;rowid为空
		}
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)
		s obj.MKBSDSegmentation=mix
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s result=1
		}
		else
		{
			s error = $SYSTEM.Status.GetErrorText(sc)
			s result=0
		}	
		

	}
	d file.Close()
	q ""
}

}

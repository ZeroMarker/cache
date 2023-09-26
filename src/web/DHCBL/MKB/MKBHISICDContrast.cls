/// Description： HISICD诊断结构化数据
/// 石萧伟
/// Date： 2019-03-01
Class web.DHCBL.MKB.MKBHISICDContrast Extends %RegisteredObject
{

/// Creator:李得原
/// CreatDate:2019-03-01
/// Description:HISICD对照界面GetNewList输出
/// Table:User.MKBHISICDContrast
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBHISICDContrast).GetNewList()
ClassMethod GetNewList(icd As %String, diag As %String, status As %String, rows As %String, page As %String)
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s:diag'="" diag=$$ALPHAUP^SSUTIL4(diag) //转换成大写
	s:icd'="" icd=$ZCONVERT(icd,"U")    //转换成大写
	s:status'="" status=$ZCONVERT(status,"U")  //转换成大写
	s total=0
	s flag=""
	s jsonstr=""
	w "{""rows"":["
	if ((icd'="")||(diag'="")||(status'=""))
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

		s MRCRowid=0
		for
		{
			s MRCRowid=$o(^MRC("ID",MRCRowid))        //获取MRC表的Rowid
			q:MRCRowid=""
			s MRCDesc=$p($g(^MRC("ID",MRCRowid)),"^",2)
			s MKBICDConHISDesc=$zstrip(MRCDesc,"<>W")
			s HISDesc=$ZCONVERT(MKBICDConHISDesc,"U")

			s MKBICDConHISNumber=$p($g(^MRC("ID",MRCRowid)),"^",4)
			s Valid=$p($g(^MRC("ID",MRCRowid)),"^",27)
			continue:Valid="N"
			s MKBICDConHISNumber=$ZCONVERT(MKBICDConHISNumber,"U")
			s ICDRowid=$o(^User.MKBHISICDContrastI("MRCIndex",MRCRowid,0)) //获取HISICD的rowid
			if ICDRowid'=""
			{
				s MKBICDStatus=$lg($g(^User.MKBHISICDContrastD(ICDRowid)),7)    //获取HISICD的状态
			}
			else
			{
				s MKBICDStatus="N"
			}
			s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HISDesc)
			if NumOfDiag=1
			{
				if (MKBICDConHISNumber[icd)&((HISDesc[diag)||(PINYINDesc[diag))&(MKBICDStatus[status)
				{
					s MKBTPDDesc=""
					s MKBTDesc=""
					s PINYINDiag=""
					s Rowid=""
					s Rowid=ICDRowid
					s MKBICDConHISCode=$p($g(^MRC("ID",MRCRowid)),"^",1)
					s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HISDesc)
					s MKBICDConHISDesc=$p(^MRC("ID",MRCRowid),"^",2)
					s MKBICDConHISNumber=$p($g(^MRC("ID",MRCRowid)),"^",4)
					if Rowid'=""
					{
						s MKBICDCenterWordID=$lg($g(^User.MKBHISICDContrastD(Rowid)),3)
						s MKBICDTermDr=$lg($g(^User.MKBHISICDContrastD(Rowid)),4)
						if MKBICDTermDr'=""
						{
							s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
							s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
							s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
						}
						s MKBICDRemark=$lg($g(^User.MKBHISICDContrastD(Rowid)),5)
						s MKBICDConSegmentation=$lg($g(^User.MKBHISICDContrastD(Rowid)),6)
						s MKBICDStatus=$lg($g(^User.MKBHISICDContrastD(Rowid)),7)
						s MKBICDConDate=$lg($g(^User.MKBHISICDContrastD(Rowid)),8)
						s MKBICDConUpdateUser=$lg($g(^User.MKBHISICDContrastD(Rowid)),9)
						s MKBICDInitialICD=$lg($g(^User.MKBHISICDContrastD(Rowid)),11)
						
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
					}
					else
					{
						s MKBICDCenterWordID=""
						s MKBICDCenterWord=""
						s MKBICDTermDr=""
						s MKBICDRemark=""
						s MKBICDConSegmentation=""
						s MKBICDStatus="N"
						s MKBICDConDate=""
						s MKBICDConUpdateUser=""
						s MKBICDInitialICD=""
					}
					s total=total+1
					if (total<stpage) continue
				    if (total<=endpage)
				    {
					    s thisStr=""	
						s thisStr="{""Rowid"":"""_Rowid_""",""MRCRowid"":"""_MRCRowid_""",""MKBICDConHISCode"":"""_MKBICDConHISCode_""",""MKBICDConHISDesc"":"""_MKBICDConHISDesc_""",""MKBICDConHISNumber"":"""_MKBICDConHISNumber_""",""MKBICDCenterWordID"":"""_MKBICDCenterWordID_""",""MKBICDTermDr"":"""_MKBICDTermDr_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBICDRemark"":"""_MKBICDRemark_""",""MKBICDConSegmentation"":"""_MKBICDConSegmentation_""",""MKBICDStatus"":"""_MKBICDStatus_""",""MKBICDConDate"":"""_MKBICDConDate_""",""MKBICDConUpdateUser"":"""_MKBICDConUpdateUser_""",""MKBICDCenterWord"":"""_MKBICDCenterWord_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"    

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
			else
			{
				for i=1:1:NumOfDiag
				{
					if (HISDesc[DiagList(i))&(DiagList(i)'="")
					{
						s MKBTPDDesc=""
						s MKBTDesc=""
						s PINYINDiag=""
						;s MKBICDConHISDesc=$zstrip(Desc,"<>W")
						s Rowid=""
						s Rowid=ICDRowid
						s MKBICDConHISCode=$p($g(^MRC("ID",MRCRowid)),"^",1)
						s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HISDesc)
						s MKBICDConHISDesc=$p(^MRC("ID",MRCRowid),"^",2)
						s MKBICDConHISNumber=$p($g(^MRC("ID",MRCRowid)),"^",4)
						if Rowid'=""
						{
							s MKBICDCenterWordID=$lg($g(^User.MKBHISICDContrastD(Rowid)),3)
							s MKBICDTermDr=$lg($g(^User.MKBHISICDContrastD(Rowid)),4)
							if MKBICDTermDr'=""
							{
								s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
								s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
								s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
							}
							s MKBICDRemark=$lg($g(^User.MKBHISICDContrastD(Rowid)),5)
							s MKBICDConSegmentation=$lg($g(^User.MKBHISICDContrastD(Rowid)),6)
							s MKBICDStatus=$lg($g(^User.MKBHISICDContrastD(Rowid)),7)
							s MKBICDConDate=$lg($g(^User.MKBHISICDContrastD(Rowid)),8)
							s MKBICDConUpdateUser=$lg($g(^User.MKBHISICDContrastD(Rowid)),9)
							s MKBICDInitialICD=$lg($g(^User.MKBHISICDContrastD(Rowid)),11)
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
						}
						else
						{
							s MKBICDCenterWordID=""
							s MKBICDCenterWord=""
							s MKBICDTermDr=""
							s MKBICDRemark=""
							s MKBICDConSegmentation=""
							s MKBICDStatus="N"
							s MKBICDConDate=""
							s MKBICDConUpdateUser=""
							s MKBICDInitialICD=""
						}
						s total=total+1
						if (total<stpage) continue
					    if (total<=endpage)
					    {
						    s thisStr=""	
							s thisStr="{""Rowid"":"""_Rowid_""",""MRCRowid"":"""_MRCRowid_""",""MKBICDConHISCode"":"""_MKBICDConHISCode_""",""MKBICDConHISDesc"":"""_MKBICDConHISDesc_""",""MKBICDConHISNumber"":"""_MKBICDConHISNumber_""",""MKBICDCenterWordID"":"""_MKBICDCenterWordID_""",""MKBICDTermDr"":"""_MKBICDTermDr_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBICDRemark"":"""_MKBICDRemark_""",""MKBICDConSegmentation"":"""_MKBICDConSegmentation_""",""MKBICDStatus"":"""_MKBICDStatus_""",""MKBICDConDate"":"""_MKBICDConDate_""",""MKBICDConUpdateUser"":"""_MKBICDConUpdateUser_""",""MKBICDCenterWord"":"""_MKBICDCenterWord_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"    

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
		}
		
	}
	else
	{
		s flag=0
		s MRCRowid=0
		for
		{
			s MRCRowid=$o(^MRC("ID",MRCRowid))
			q:MRCRowid=""
			s MRCDesc=$p($g(^MRC("ID",MRCRowid)),"^",2)
			s MKBICDConHISDesc=$zstrip(MRCDesc,"<>W")
			s HISDesc=$zcvt(MKBICDConHISDesc,"U")
			s Valid=$p($g(^MRC("ID",MRCRowid)),"^",27)
			s activeto=$p(^MRC("ID",MRCRowid),"^",7)
			continue:activeto'=""
			continue:Valid="N"
			s ICDRowid=$o(^User.MKBHISICDContrastI("MRCIndex",MRCRowid,0))

			if ((total+1<stpage)||(total+1>endpage)) //如果不是当前页则只计数，不输出。
			{
				
			}
			else
			{
				s MKBTPDDesc=""
				s MKBTDesc=""
				s PINYINDiag=""
				;s MKBICDConHISDesc=$zstrip(Desc,"<>W")
				s Rowid=""
				s Rowid=ICDRowid
				;s MRCRowid=$lg($g(^User.MKBHISICDContrastD(ICDRowid)),2)
				s MKBICDConHISCode=$p($g(^MRC("ID",MRCRowid)),"^",1)
				s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HISDesc)
				;s MKBICDConHISDesc=$p(^MRC("ID",MRCRowid),"^",2)
				s MKBICDConHISNumber=$p($g(^MRC("ID",MRCRowid)),"^",4)
				s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDConHISDesc)
				if Rowid'=""
				{
					s MKBICDCenterWordID=$lg($g(^User.MKBHISICDContrastD(Rowid)),3)
					s MKBICDTermDr=$lg($g(^User.MKBHISICDContrastD(Rowid)),4)
					if MKBICDTermDr'=""
					{
						s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
						s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
						s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
					}
					s MKBICDRemark=$lg($g(^User.MKBHISICDContrastD(Rowid)),5)
					s MKBICDConSegmentation=$lg($g(^User.MKBHISICDContrastD(Rowid)),6)
					s MKBICDStatus=$lg($g(^User.MKBHISICDContrastD(Rowid)),7)		
					s MKBICDConDate=$lg($g(^User.MKBHISICDContrastD(Rowid)),8)
					s MKBICDConUpdateUser=$lg($g(^User.MKBHISICDContrastD(Rowid)),9)
					s MKBICDInitialICD=$lg($g(^User.MKBHISICDContrastD(Rowid)),11)
				
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
				}
				else
				{
					s MKBICDCenterWordID=""
					s MKBICDCenterWord=""
					s MKBICDTermDr=""
					s MKBICDRemark=""
					s MKBICDConSegmentation=""
					s MKBICDStatus="N"
					s MKBICDConDate=""
					s MKBICDConUpdateUser=""
					s MKBICDInitialICD=""
				}
			
			}
			s total=total+1
			if (total<stpage) continue
		    if (total<=endpage)
		    {
			    s thisStr=""	
				s thisStr="{""Rowid"":"""_Rowid_""",""MRCRowid"":"""_MRCRowid_""",""MKBICDConHISCode"":"""_MKBICDConHISCode_""",""MKBICDConHISDesc"":"""_MKBICDConHISDesc_""",""MKBICDConHISNumber"":"""_MKBICDConHISNumber_""",""MKBICDCenterWordID"":"""_MKBICDCenterWordID_""",""MKBICDTermDr"":"""_MKBICDTermDr_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBICDRemark"":"""_MKBICDRemark_""",""MKBICDConSegmentation"":"""_MKBICDConSegmentation_""",""MKBICDStatus"":"""_MKBICDStatus_""",""MKBICDConDate"":"""_MKBICDConDate_""",""MKBICDConUpdateUser"":"""_MKBICDConUpdateUser_""",""MKBICDCenterWord"":"""_MKBICDCenterWord_""",""MKBICDInitialICD"":"""_MKBICDInitialICD_"""}"    

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
	q ""
}

/// Lixin
/// 通过输入的条件检索国际码
/// tip:编码/中文  desc:检索条件
/// return :TermId&%TermId
/// w ##class(web.DHCBL.MKB.MKBDataProcessing).GetNationICD(编码,"S")
ClassMethod GetNationICD(tip, desc)
{
	s MKBTBRowId=$O(^User.MKBTermBaseI("FlagIndex"," ICD10INTER",0))
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
/// CreatDate:2019-2-14
/// Description：查询国际码列表子术语库内容及中文释义
/// Input：rowid-行号，desc-描述, base-规则注册表id, descch-中文释义，rows-每页显示条数, page-页数
/// Return:Json格式的数据
/// Other:d ##class(web.DHCBL.MKB.MKBHISICDContrast).GetMyList("E76","","1","11","1")
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
			s descstr=##class(web.DHCBL.MKB.MKBHISICDContrast).GetNationICD("编码",desc)
			if descch'=""
			{
				s descch=$tr(descch," ","")
				s descchStr=##class(web.DHCBL.MKB.MKBHISICDContrast).GetNationICD("中文",descch)
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
			s str=##class(web.DHCBL.MKB.MKBHISICDContrast).GetNationICD("中文",descch)
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

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description：结构化结果展示
/// Table：User.MKBHISICDContrast
/// Input：父表id 
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBHISICDContrast","GetResultList","")
Query GetResultList(id As %String) As %Query(ROWSPEC = "Rowid,MKBICDContrast,MKBICDConResultID,MKBICDConResult,MKBHISICDConTermDr,MKBICDConSupplement,MKBHISICDSequence")
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
			s rowid=$o(^User.MKBHISICDContrastD(id,"MKBHISICDContrastResult",rowid))
			q:rowid=""
			s Rowid=id_"||"_rowid
			s MKBHISICDConTermDr=$lg($g(^User.MKBHISICDContrastD(id,"MKBHISICDContrastResult",rowid)),4)
			s MKBICDContrast=id
			;s MKBICDConResult=$lg($g(^User.MKBHISICDContrastD(id,"MKBHISICDContrastResult",rowid)),3)
			s MKBICDConResultID=$lg($g(^User.MKBHISICDContrastD(id,"MKBHISICDContrastResult",rowid)),2)
			s MKBICDConSupplement=$lg($g(^User.MKBHISICDContrastD(id,"MKBHISICDContrastResult",rowid)),5)
			s MKBHISICDSequence=$lg($g(^User.MKBHISICDContrastD(id,"MKBHISICDContrastResult",rowid)),7)
			s MKBICDConResult=..GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBHISICDConTermDr)
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
	set Data=$lb(Rowid,MKBICDContrast,MKBICDConResultID,MKBICDConResult,MKBHISICDConTermDr,MKBICDConSupplement,MKBHISICDSequence)
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
/// Description：结构化结果子表的删除
/// Table：User.MKBHISICDContrastResult
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBHISICDContrast).DeleteData()
ClassMethod DeleteData(id)
{
	s result=""
	if id'=""
	{
		Ts
		s sc= ##class(User.MKBHISICDContrastResult).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			
			d ##class(web.DHCBL.MKB.MKBICDRely).Delete(id)
			//删除子表记录成功后调用
			s refResult =  ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("ICD",id)
			
			set result = "{success:'true',info:'删除成功！'}"
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

/// Creator:石萧伟
/// CreatDate:2018-12-10
/// Description：结构化结果子表的新增
/// Table：User.MKBHISICDContrastResult
/// Input：id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBHISICDContrast).SaveData()
ClassMethod SaveData(Pid As %String, Cid As %String, StructResultID As %String, StructResult As %String, PropertyDR As %String, Supplement As %String, MRCRowId As %String)
{
	if (Pid="")
	{
		s obj=##class(User.MKBHISICDContrast).%New()
		d obj.MKBHISICDDrSetObjectId(MRCRowId)
		s obj.MKBHISICDConStatus="N"
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		
		s obj.MKBHISICDConDate=UpdateDate
		d obj.MKBHISICDConUpdateUserSetObjectId(UpdateUserDR)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set Pid=id
			set result = "{success:'true',id:'"_id_"'}" 
		}
		else
		{
			Tro
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
		}		
	}
	if Cid=""      ;如果为空 则新增子表数据
	{
		s obj=##class(User.MKBHISICDContrastResult).%New(Pid)
		s sort=0
		if ($d(^User.MKBHISICDContrastResultI("SeqIndex")))
		{
			s sort=$o(^User.MKBHISICDContrastResultI("SeqIndex",Pid,""),-1) 
		}
		s obj.MKBHISICDSequence=sort+1			
	}
	else      ;如果不为空 则修改子表数据
	{
		s obj=##class(User.MKBHISICDContrastResult).%OpenId(Cid)
	}
	d obj.MKBHISICDContrastSetObjectId(Pid)
	d obj.MKBHISICDConTermDrSetObjectId(PropertyDR)
	s obj.MKBHISICDConResult=StructResult
	s obj.MKBHISICDConResultID=StructResultID
	s obj.MKBHISICDConSupplement=Supplement
	s sc=obj.%Save()
	Ts
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		//辅助表
		s a1 =  ##class(web.DHCBL.MKB.MKBICDRely).SaveData(obj.%Id(),PropertyDR,StructResultID)
		
		//引用表
		
		if (PropertyDR'=""){
			if (Cid=""){
				s resultrefS = ##class(web.DHCBL.MKB.MKBReference).SaveData("","ICD",obj.%Id(),"T",PropertyDR)
			}
			else{
				s cobj=##class(User.MKBHISICDContrastResult).%OpenId(Cid)
				s refRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("ICD", Cid, "T", cobj.MKBHISICDConTermDr)
				
				s resultRef = ##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "ICD", obj.%Id(), "T", PropertyDR)	 
			}
		}
		if (StructResultID'=""){
			s resultref = ##class(web.DHCBL.MKB.MKBReference).SaveExpFroReference("ICD",obj.%Id(),StructResultID)
		}
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

/// Creator:石萧伟
/// CreatDate:2019-01-18
/// Description:判断同名诊断
/// Table:
/// Input:
/// Return:有则拼串，没有返回“”
/// Other:d ##class(web.DHCBL.MKB.MKBHISICDContrast).justHasExist(119,26484)
ClassMethod justHasExist(parentid, proid, MRCRowId)
{
	s existStr = ""
	if (parentid = "")
	{
		s obj=##class(User.MKBHISICDContrast).%New()
		d obj.MKBHISICDDrSetObjectId(MRCRowId)
		s obj.MKBHISICDConStatus="N"
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		
		s obj.MKBHISICDConDate=UpdateDate
		d obj.MKBHISICDConUpdateUserSetObjectId(UpdateUserDR)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set parentid=id
			s existStr = id
			set result = "{success:'true',id:'"_id_"'}" 
		}
		else
		{
			Tro
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
		}
	}
	if $d(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult"))
	{
		s rowid=0
		
		for
		{
			s rowid=$o(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid))
			q:rowid=""
			s MKBHISICDConTermDr=$lg(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid),4)
			s MKBHISICDConResult=$lg(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid),3)
			if (proid = MKBHISICDConTermDr)
			{
				s existStr = parentid_"||"_rowid _"^"_MKBHISICDConResult
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
/// Other:d ##class(web.DHCBL.MKB.MKBHISICDContrast).EditUpdate(4310,"","","12464")
ClassMethod EditUpdate(rowid As %String, MKBHISICDConStatus As %String, MKBHISICDRemark As %String, MKBHISICDTermDr As %String, MKBHISICDInitialICD As %String, MRCRowId) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBHISICDContrast).%OpenId(rowid)        ;先备份再更新	
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		
		s obj.MKBHISICDConDate=UpdateDate
		d obj.MKBHISICDConUpdateUserSetObjectId(UpdateUserDR)
		if (MKBHISICDConStatus'=""){
			s obj.MKBHISICDConStatus=MKBHISICDConStatus
		}
		if (MKBHISICDRemark'=""){
			s obj.MKBHISICDRemark=MKBHISICDRemark
		}
		if (MKBHISICDTermDr'=""){
			d obj.MKBHISICDTermDrSetObjectId(MKBHISICDTermDr)
		}
		if (MKBHISICDInitialICD'=""){
			s obj.MKBHISICDInitialICD=MKBHISICDInitialICD
		}
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
/// Description:根据诊断模板获取诊断id
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBHISICDContrast).GetTermIdByProId("26473")
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
/// Other: w ##class(web.DHCBL.MKB.MKBHISICDContrast).GetShowType("4989")
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
/// CreatDate:2019-01-18
/// Description：获取结构化诊断的信息
/// Table：User.MKBStructuredData
/// Input：rowid 结构化诊断id
/// Return：术语属性内容值串^诊断展示名^诊断备注
/// Other: w ##class(web.DHCBL.MKB.MKBHISICDContrast).GetData("1","1||3")
ClassMethod GetData(parentid, rowid) As %String
{
	q:parentid="" ""
	q:rowid="" ""
	s result=""
	s rowid = $p($g(rowid),"||",2)
	s SDSTermDR=$lg(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid),4) //诊断id
	s PropertyDR=..GetPropertyIdByFlag(SDSTermDR,"DT")
	d ..GetShowType(PropertyDR)
	
	s SDSValue=$lg(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid),2)   
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
/// CreatDate:2019-01-18
/// Description：获取结构化诊断的信息
/// Table：User.MKBStructuredData
/// Input：rowid 结构化诊断id
/// Return：术语属性内容值串^诊断展示名^诊断备注
/// Other: w ##class(web.DHCBL.MKB.MKBHISICDContrast).GetData("1","1||3")
ClassMethod GetPPData(parentid, rowid) As %String
{
	
	s result=""
	s rowid = $p($g(rowid),"||",2)
	s SDSPropertyDR=$lg(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid),4) 
	d ..GetShowType(SDSPropertyDR)
	
	s MKBTRowId=$LISTGET($G(^User.MKBTermPropertyD(SDSPropertyDR)),6) //诊断id
	s SDSValue=$lg(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid),2)   
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
	s SDSDisplayName=$lg(^User.MKBHISICDContrastD(parentid,"MKBHISICDContrastResult",rowid),3)  //MKBHISICDConResult
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
	k ^TMPHISSELPROPERTY("SelProperty")
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
		s ^TMPHISSELPROPERTY("SelProperty",index,id)=titleid_"^"_title_"^"_text
	}else{
		if (id=0){
			k ^TMPHISSELPROPERTY("SelProperty",index) //单选框切换时先清空
		}else{
			k ^TMPHISSELPROPERTY("SelProperty",index,id)
		}
	}
	s count=$o(^TMPHISSELPROPERTY("SelProperty",""),-1)
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
	s index=$o(^TMPHISSELPROPERTY("SelProperty",index)) q:index=""
	
	s id=""
	for 
	{
		s id=$o(^TMPHISSELPROPERTY("SelProperty",index,id)) q:id=""
		if ($o(^TMPHISSELPROPERTY("SelProperty",index,""),-1)'=0){
			continue:id=0 //去除属性内容为空的重复节点信息
		}
		s titleid=$p(^TMPHISSELPROPERTY("SelProperty",index,id),"^",1)
		s title=$p(^TMPHISSELPROPERTY("SelProperty",index,id),"^",2)
		s text=$p(^TMPHISSELPROPERTY("SelProperty",index,id),"^",3)
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
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredData).UpdateSupplement()
ClassMethod UpdateSupplement(Cid As %String, Supplement As %String)
{
	s obj=##class(User.MKBHISICDContrastResult).%OpenId(Cid)
	s obj.MKBHISICDConSupplement=Supplement
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
/// Table：User.MKBHISICDContrast
/// Input：desc,rowid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBHISICDContrast).UpdateSupplement()
ClassMethod SortByPinyin(DescPin As %String, rowid As %String)
{
	s ^Temp("MKBSortICDContrastDesc",DescPin,rowid)=""
	q ""
}

/// Creator:石萧伟
/// CreatDate:2019-02-25
/// Description：根据描述取termid
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBHISICDContrast).findTermDescById(15026)
ClassMethod findTermDescById(termid As %String)
{
	q:termid="" "" //描述
	s termDesc=""
	s termDesc=$listGet($g(^User.MKBTermD(termid)),3) 
	q termDesc
}

/// Creator:石萧伟
/// CreatDate:2019-05-29
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
		s obj=##class(User.MKBHISICDContrastResult).%OpenId(rowid)
		s obj.MKBHISICDSequence=i
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
/// CreatDate:2019-05-16
/// Description：结构化结果ID串按照诊断模板顺序输出，如果诊断模板中已经删除属性，但结构化串中还有，也要显示
/// Table：User.MKBStructuredDataResult
/// Input：子表id 
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
		q:DiagTemplateDr="" ""
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
		s Value=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(ValueDr)
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

}

/// Description: CDSS疾病字典表维护数据方法集合(增删改查)
/// Creator: 范文凯
/// Date: 2020-02-14
Class web.CDSS.CMKB.DiseaseDictDetail Extends %RegisteredObject
{

/// Creator:ZWW
/// CreatDate:2022-09-15
/// Description:获得疾病字典表内容
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input:code,desc, quoteflag,IsUseFlag,aliasname,opername,version,state,starttime,endtime,remarks,sortmethod 
/// Return:返回所有疾病字典表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDictDetail","GetList","592","","","","","","","","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, version As %String, state As %String, timescope As %String, remarks As %String, sortmethod As %String, type As %String, rareflag As %String) As %Query(ROWSPEC = "CDSSDiseaseRowId,DiseaseCode,DiseaseName,DiseaseEnName,DiseaseDeptCode,DiseaseDeptName,DiseaseAliasName,DiseaseBodyPartDR,MedicalCompanyCode,ICD9Code,ICD9Name,ICD10Code,ICD10Name,ICD10LocalCode,ICD10LocalName,ICD11Code,ICD11Name,UseFlag,RareDiseaseFlag,CreateDate,CreateUserID,Remarks,QuoteFlag,KnowledgeTotal,Version,DiseaseType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, version As %String, state As %String, timescope As %String, remarks As %String, sortmethod As %String, type As %String, rareflag As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (rowid'="")
 	{
	 	s CDSSDiseaseRowId=rowid
	 	s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),2)
 		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),3)
 		s:DiseaseName'="" DiseaseName = ##class(web.BDP.util.String).Replace(DiseaseName,"\","\\")
 		s DiseaseEnName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),4)
 		s DiseaseDeptCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),5)
 		s DiseaseDeptName  = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),6)
 		s DiseaseAliasName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),7)
 		s DiseaseBodyPartDR = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),8)
 		s MedicalCompanyCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),9)
 		s ICD9Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),10)
 		s ICD9Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),11)
 		s ICD10Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),12)
 		s ICD10Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),13)
 		s ICD10LocalCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),14)
 		s ICD10LocalName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),15)
 		s ICD11Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),16)
 		s ICD11Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),17)
 		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),18)
 		s:UseFlag="" UseFlag=0
 		s RareDiseaseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),19)
		s CreateDate=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),20)		//创建时间
		s:CreateDate="" CreateDate="2021-01-01 00:00:00"
 		s CreateUserID = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),21)
 		s Remarks = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),22)
 		s QuoteFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),23) 		//引用标志
 		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
 		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),24)	//知识数量
 		s:KnowledgeTotal="" KnowledgeTotal=0
 		s Version=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),25)			//版本
 		s DiseaseType=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),26)		//疾病类型
	 	d OutputRow8
	}
	else
	{
	 	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") 
		s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U")
		s:opername'="" opername=$ZCONVERT(opername,"U") 
		s:version'="" version=$ZCONVERT(version,"U") 
		s:remarks'="" remarks=$ZCONVERT(remarks,"U") 
		s:type'="" type=$ZCONVERT(type,"U") 
		s:rareflag'="" rareflag=$ZCONVERT(rareflag,"U") 
		//默认时间倒序输出
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.DiseaseDictD(ID)) q:ID=""
				s DiseaseName= $lg($g(^CT.WDT.CDSS.DiseaseDictD(ID)),3)		//名称
				s length=$l(DiseaseName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=""
			for 
			{
				s ID=$o(^CT.WDT.CDSS.DiseaseDictD(ID)) q:ID=""
				s CreateDate= $lg($g(^CT.WDT.CDSS.DiseaseDictD(ID)),20)		//编辑时间
				s:CreateDate="" CreateDate="2021-01-01"
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",CreateDate,ID)=ID
			}
		}
		s le=""
		for
		{
			if (sortmethod="Short"){
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le)) 
			} else{
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le),-1) 
			}
			q:le="" 
			s CDSSDiseaseRowId=0
			for
			{
				s CDSSDiseaseRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,CDSSDiseaseRowId)) q:CDSSDiseaseRowId=""
				s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),2)
			 	s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),3)
			 	s:DiseaseName'="" DiseaseName = ##class(web.BDP.util.String).Replace(DiseaseName,"\","\\")
			 	s DiseaseEnName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),4)
			 	s DiseaseDeptCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),5)
			 	s DiseaseDeptName  = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),6)
			 	s DiseaseAliasName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),7)
			 	continue:((aliasname'="")&&($ZCONVERT(DiseaseAliasName,"U")'[aliasname))
			 	s DiseaseBodyPartDR = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),8)
		 		s MedicalCompanyCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),9)
		 		s ICD9Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),10)
		 		s ICD9Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),11)
		 		s ICD10Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),12)
		 		s ICD10Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),13)
		 		s ICD10LocalCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),14)
		 		s ICD10LocalName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),15)
		 		s ICD11Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),16)
		 		s ICD11Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),17)
		 		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),18)
		 		s:UseFlag="" UseFlag=0
		 		continue:((state'="")&&(UseFlag'=state))
				continue:((state="")&&(UseFlag="1"))
		 		s RareDiseaseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),19)
		 		continue:((rareflag'="")&&($ZCONVERT(RareDiseaseFlag,"U")'[rareflag))
		 		s starttime=$p(timescope,"^",1)
				s endtime=$p(timescope,"^",2)
				s CreateDate=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),20)	//创建时间
				s:CreateDate="" CreateDate="2021-01-01 00:00:00"
				continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
				continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		 		s CreateUserID = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),21)
		 		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
		 		s Remarks = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),22)
		 		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		 		s QuoteFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),23) //引用标志
		 		continue:(QuoteFlag'[quoteflag)
		 		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
		 		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),24)	//知识数量
		 		s:KnowledgeTotal="" KnowledgeTotal=0
		 		s Version=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),25)	//版本
		 		continue:((version'="")&&($ZCONVERT(Version,"U")'[version))
		 		s DiseaseType=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),26)	//疾病类型
		 		continue:((type'="")&&($ZCONVERT(DiseaseType,"U")'[type))
		 		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName)
			  	if (($ZCONVERT(DiseaseName,"U")[desc)||(PINYIN[desc)||($ZCONVERT(DiseaseAliasName,"U")[desc))&&($ZCONVERT(DiseaseCode,"U")[code)	//过滤条件
			  	{
			  		d OutputRow8
			 	}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(CDSSDiseaseRowId,DiseaseCode,DiseaseName,DiseaseEnName,DiseaseDeptCode,DiseaseDeptName,DiseaseAliasName,DiseaseBodyPartDR,MedicalCompanyCode,ICD9Code,ICD9Name,ICD10Code,ICD10Name,ICD10LocalCode,ICD10LocalName,ICD11Code,ICD11Name,UseFlag,RareDiseaseFlag,CreateDate,CreateUserID,Remarks,QuoteFlag,KnowledgeTotal,Version,DiseaseType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯
/// CreatDate:2020-02-14
/// Description:获得疾病下拉框内容
/// Table: CT.WDT.CDSS.DiseJoinDiffDiag
/// Input:疾病字典表id
/// Return:返回所有疾病下拉框内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDictDetail","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "DiseaseID:%String,DiseaseCode:%String,DiseaseName:%String,DiseaseDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s DiseaseID=rowid
	 	s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),2)
  		s DiseaseName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),3)
  		
  		d OutputRowCmb
 	}
 	else
 	{
	 	if (desc="") s desc=q
	 	s Desc=$ZCONVERT(desc,"U")
	 	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DiseaseDictD(ID))
			q:ID=""
			s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ID)),3)		//名称
			s length=$l(DiseaseName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s DiseaseID=0
			for
			{
				s DiseaseID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DiseaseID))
				q:DiseaseID=""
				s DiseaseDR=DiseaseID
				s DiseaseCode=$LISTGET($G(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),2)  
  				s DiseaseName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),3)
  				s DiseaseAliasName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),7)
  				s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),18)
  				
  				if (($ZCONVERT(DiseaseName,"U")[Desc)||($ZCONVERT(DiseaseAliasName,"U")[Desc)&(UseFlag="2"))
				{
					d OutputRowCmb
				}
				continue:(Desc'="")
				s num=num+1
				q:num=10000
			}
	        q:num=10000
	    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DiseaseID,DiseaseCode,DiseaseName,DiseaseDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:钟荣枫
/// Editor：ZWW 2022-05-30 [添加循证规则与预警规则引用标志]
/// CreatDate:2020-7-2
/// Description:获取引用标志对应的中文
/// Input: QuoteFlag 引用str
/// Return:描述
/// Other:w ##class(web.CDSS.CMKB.DiseaseDictDetail).GetQuoteFlag("D,K,R,M,E,W")
ClassMethod GetQuoteFlag(QuoteFlag)
{
	/// 引用标志： K（Knowledge） 被医为百科引用 ;R（Rule） 被规则知识库引用 ;M（Mapping）被数据对照2.0引用 ;E（Evidence-based）被循证规则库引用 ;W（Warning）被预警规则库引用
  	s value=""
	if QuoteFlag'=""
	{
		s QuoteFlagDesc=""
		
		if QuoteFlag["K"	//被医为百科引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="医为百科"
			}
			else			//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"医为百科"
			}
		}
		if QuoteFlag["R"	//被规则知识库引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="规则知识库"
			}
			else			//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"规则知识库"
			}
		}
		if QuoteFlag["M"	//被数据对照引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="数据对照"
			}
			else			//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"数据对照"
			}
		}
		if QuoteFlag["E"	//被循证规则引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="循证规则库"
			}
			else			//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"循证规则库"
			}
		}
		if QuoteFlag["W"	//被预警规则引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="预警规则库"
			}
			else			//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"预警规则库"
			}
		}
		s value=QuoteFlagDesc
	}
	q value
}

/// Creator:高姗姗
/// CreatDate:2020-09-10
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.DiseaseDictDetail).RemoveQuoteFlag("","R")
ClassMethod RemoveQuoteFlag(OldFlag, RemoveFlag)
{
	q:(OldFlag="") ""
	s result=""
	s Len=$Length(OldFlag,",")
	for i=1:1:Len{	
		s flag=$p(OldFlag,",",i)
  	 	continue:flag=RemoveFlag
  	  	if (result=""){
	  	  	s result=flag
	  	}else{
		  	s result=result_","_flag
	  	}	
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-06-12
/// Editor: 赵文伟 2022-06 【修改百科、字典对照2.0；添加预警规则】
/// Description:生成被引用数据，当数据大于0时，修改标识
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: id 疾病字典表id
/// Return:
/// others:w ##class(web.CDSS.CMKB.DiseaseDictDetail).CreateDiseDetailCount()
ClassMethod CreateDiseDetailCount()
{
	s CDSSDiseaseRowId=0
	for
	{
 		s CDSSDiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)) q:CDSSDiseaseRowId=""
 		s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(CDSSDiseaseRowId)
 		s QuoteFlag = obj.QuoteFlag
 		s DiseaseName = obj.DiseaseName
 		s DiseaseCode = obj.DiseaseCode
 		
		;K（Knowledge） 被医为百科引用
		s basedr=##class(web.CDSS.CMKB.TermBase).GetIdByDesc("疾病")	//疾病知识库注册id
		if (basedr'="")
		{
			if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(DiseaseName,"U")))))
			{
				s termdr=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(DiseaseName,"U")),""))
				if (termdr'="")
				{
					if ($d(^CT.WDT.CDSS.TermPropertyI("TermIndex",termdr)))
					{
						if (QuoteFlag["K")
						{}
						else
						{
							if (QuoteFlag="")
							{
								s obj.QuoteFlag="K"
							}
							else
							{
								s obj.QuoteFlag=QuoteFlag_",K"
							}
						}
					}
					else
					{
						s obj.QuoteFlag=##class(web.CDSS.CMKB.DiseaseDictDetail).RemoveQuoteFlag(QuoteFlag,"K")	
					}
				}
			}
		}
		s QuoteFlag = obj.QuoteFlag
		;M（Mapping）被字典对照V2.0引用
		s ContrastType="诊断"
		s MappingFlag=0
		s ContrastDictDR=""

		if ($d(^CT.WDT.CDSS.ContrastDictI("ContrastDictIndex"," "_DiseaseName,ContrastType,CDSSDiseaseRowId))) s MappingFlag=1
		if (MappingFlag=1)
		{
			if (QuoteFlag["M")
			{}
			else
			{
				
				if (QuoteFlag="")
				{
					s obj.QuoteFlag="M"
				}
				else
				{
					s obj.QuoteFlag=QuoteFlag_",M"
				}
			}
		}
		else
		{
			s obj.QuoteFlag=##class(web.CDSS.CMKB.DiseaseDictDetail).RemoveQuoteFlag(QuoteFlag,"M")	
		}
		s QuoteFlag = obj.QuoteFlag
		;R（Rule） 被规则知识库引用
		s Exist =##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.CDSS.CMKB.RuleTrigger")
		if (Exist="1"){
			s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("诊断",DiseaseName) //被诊疗规则引用判断
			s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("诊断",DiseaseName) //被诊疗子规则引用判断
			if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1)){
				if (QuoteFlag["R")
				{}
				else
				{
					if (QuoteFlag="")
					{
						s obj.QuoteFlag="R"
					}
					else
					{
						s obj.QuoteFlag=QuoteFlag_",R"
					}
				}
			}
			else
			{
				s obj.QuoteFlag=##class(web.CDSS.CMKB.DiseaseDictDetail).RemoveQuoteFlag(QuoteFlag,"R")	
			}
			s QuoteFlag = obj.QuoteFlag
		}
		
		;E（Evidence-based）被循证规则库引用  ;W（Warning）被预警规则库引用
		s RuleFlag=0,WarningFlag=0
		s FlagR=##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("诊断",DiseaseName,CDSSDiseaseRowId) //被循证规则库引用判断
		s RuleFlag=$p(FlagR,"^",1)
		s WarningFlag=$p(FlagR,"^",2)
		//询证规则标志
		if (RuleFlag=1){
			if (QuoteFlag["E")
			{}
			else
			{
				if (QuoteFlag="")
				{
					s obj.QuoteFlag="E"
				}
				else
				{
					s obj.QuoteFlag=QuoteFlag_",E"
				}
			}
		}
		else
		{
			s obj.QuoteFlag=##class(web.CDSS.CMKB.DiseaseDictDetail).RemoveQuoteFlag(QuoteFlag,"E")	
		}
		s QuoteFlag = obj.QuoteFlag
		//预警规则标志
		if (WarningFlag=1){
			if (QuoteFlag["W")
			{}
			else
			{
				if (QuoteFlag="")
				{
					s obj.QuoteFlag="W"
				}
				else
				{
					s obj.QuoteFlag=QuoteFlag_",W"
				}
			}
		}
		else
		{
			s obj.QuoteFlag=##class(web.CDSS.CMKB.DiseaseDictDetail).RemoveQuoteFlag(QuoteFlag,"W")	
		}
		s sc=obj.%Save()
		d obj.%Close()
	}
	q "疾病数据处理完成！"
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2018-03-27    
/// w ##class(web.DHCBL.MKB.MKBTerm).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String, code As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.DiseaseDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.DiseaseDictI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.DiseaseDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.DiseaseDictDetail).ValidateAlias("25067","WE")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, name As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias="") continue  //别名为空，则跳过
		if (Alias=name)
		{
			s flag=1  //如果别名=名称，则数据重复
			q
		}
		
		s Alias=" "_$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DiseaseDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.DiseaseDictI("NameIndex",Alias))
	    if (id="") //如果为空，增加时的重复判断
	    {
	        if ((flagA>0)||(flagN>0)) 
	        {
		        s flag=1  //返回重复标志
		        q
	        }
	    }
	    else //如果不为空，修改时的重复判断
	    {
	        s idA="",idN=""
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DiseaseDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex",Alias,0))  //字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:范文凯
/// CreatDate:2020-02-14
/// Description:保存疾病字典表
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: eobj 疾病字典表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DiseaseDictDetail).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseaseDict)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.DiseaseName=$tr(eobj.DiseaseName," ","")
		s flag=..FormValidate(eobj.RowId,eobj.DiseaseName,eobj.DiseaseCode)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.RowId,eobj.DiseaseName,eobj.DiseaseAliasName)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiseaseDict).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
		    s bobj.DiseaseCode = obj.DiseaseCode
			s bobj.DiseaseName = obj.DiseaseName
			s bobj.DiseaseEnName = obj.DiseaseEnName
			s bobj.DiseaseDeptName = obj.DiseaseDeptName
			s bobj.DiseaseAliasName = obj.DiseaseAliasName
			s bobj.ICD9Code = obj.ICD9Code
			s bobj.ICD9Name = obj.ICD9Name
			s bobj.ICD10Code = obj.ICD10Code
			s bobj.ICD10Name = obj.ICD10Name
			s bobj.ICD10LocalCode = obj.ICD10LocalCode
			s bobj.ICD10LocaName = obj.ICD10LocaName
			s bobj.ICD11Code = obj.ICD11Code
			s bobj.ICD11Name = obj.ICD11Name
			s bobj.RareDiseaseFlag=obj.RareDiseaseFlag
			s bobj.UseFlag = obj.UseFlag
			s bobj.CreateDate=obj.CreateDate
			s bobj.CreateUserID = obj.CreateUserID
			s bobj.Remarks = obj.Remarks
			s bobj.QuoteFlag = obj.QuoteFlag
			s bobj.KnowledgeTotal = obj.KnowledgeTotal	
			s bobj.Version = obj.Version
			s bobj.DiseaseType = obj.DiseaseType	
		}
		s obj.DiseaseCode = eobj.DiseaseCode
		s obj.DiseaseName = eobj.DiseaseName
		s obj.DiseaseEnName = eobj.DiseaseEnName
		s obj.DiseaseDeptName = eobj.DiseaseDeptName
		s obj.DiseaseAliasName = eobj.DiseaseAliasName
		s obj.ICD9Code = eobj.ICD9Code
		s obj.ICD9Name = eobj.ICD9Name
		s obj.ICD10Code = eobj.ICD10Code
		s obj.ICD10Name = eobj.ICD10Name
		s obj.ICD10LocalCode = eobj.ICD10LocalCode
		s obj.ICD10LocaName = eobj.ICD10LocaName
		s obj.ICD11Code = eobj.ICD11Code
		s obj.ICD11Name = eobj.ICD11Name
		s obj.RareDiseaseFlag=eobj.RareDiseaseFlag
		s obj.UseFlag = eobj.UseFlag
		if (eobj.CreateDate="")
		{
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s obj.CreateDate=eobj.CreateDate
		}
		else
		{
			s obj.CreateDate=eobj.CreateDate
		}
		s obj.CreateUserID = eobj.CreateUserID
		s obj.Remarks = eobj.Remarks
		s obj.Version = eobj.Version
		s obj.DiseaseType = eobj.DiseaseType
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDict","CT.WDT.CDSS.DiseaseDict","疾病字典",id,eobj.DiseaseName,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDict","CT.WDT.CDSS.DiseaseDict","疾病字典",eobj.RowId,eobj.DiseaseName,"U",eobj,bobj)
			
			//[新]疾病百科增加一条同名数据    2021-11-25
			d:eobj.RowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("疾病",eobj.DiseaseName,"")
			d:eobj.RowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("疾病",eobj.DiseaseName,bobj.DiseaseName)
			
			//同步修改对照数据
			d:eobj.RowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("诊断",bobj.DiseaseCode_"[A]"_bobj.DiseaseName,eobj.DiseaseCode_"[A]"_eobj.DiseaseName)
			
			//同步修改识别词项目数据
			d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("诊断名称",eobj.DiseaseName,bobj.DiseaseName)
			d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("诊断症状名称",eobj.DiseaseName,bobj.DiseaseName)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.RowId="")&&(eobj.DiseaseAliasName'=""))||((eobj.RowId'="")&&(eobj.DiseaseAliasName'=bobj.DiseaseAliasName))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDict",id,eobj.DiseaseAliasName)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病字典","web.CDSS.CMKB.DiseaseDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病字典","web.CDSS.CMKB.DiseaseDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2020-08-19
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// 目前没有引用手术的表、病因等用到但是保存的是手术名称，不影响
/// w ##class(web.CDSS.CMKB.DiseaseDictDetail).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    s DictDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),3)
    //诊疗规则引用接口 
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("诊断",DictDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("诊断",DictDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
	//规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("诊断",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	//识别词项目引用接口    2021-11-25
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("诊断名称",DictDesc)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("诊断症状名称",DictDesc)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	//字典对照引用接口	2022-04-07 ZWW
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("诊断",DictDesc)
	s myInfo=myInfo_Mappinginfo
	
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用!"
    q return
}

/// Creator:范文凯
/// CreatDate:2020-02-14
/// Description:删除疾病字典表
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: id 疾病字典表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DiseaseDictDetail).DeleteData("25012")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
	s bobj.DiseaseCode = obj.DiseaseCode
	s bobj.DiseaseName = obj.DiseaseName
	s bobj.DiseaseEnName = obj.DiseaseEnName
	s bobj.DiseaseDeptName = obj.DiseaseDeptName
	s bobj.DiseaseAliasName = obj.DiseaseAliasName
	s bobj.ICD9Code = obj.ICD9Code
	s bobj.ICD9Name = obj.ICD9Name
	s bobj.ICD10Code = obj.ICD10Code
	s bobj.ICD10Name = obj.ICD10Name
	s bobj.ICD10LocalCode = obj.ICD10LocalCode
	s bobj.ICD10LocaName = obj.ICD10LocaName
	s bobj.ICD11Code = obj.ICD11Code
	s bobj.ICD11Name = obj.ICD11Name
	s bobj.RareDiseaseFlag=obj.RareDiseaseFlag
	s bobj.UseFlag = obj.UseFlag
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID = obj.CreateUserID
	s bobj.Remarks = obj.Remarks
	s bobj.Version = obj.Version	
	s bobj.QuoteFlag = obj.QuoteFlag
	s bobj.KnowledgeTotal = obj.KnowledgeTotal
	s bobj.DiseaseType = obj.DiseaseType
	Ts	
	//同步删除对照数据 2022-01-21
	s re =  ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("诊断",obj.DiseaseCode_"[A]"_obj.DiseaseName)
	if (re="true[A]true"){
			
		s sc=##class(CT.WDT.CDSS.DiseaseDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			//关联诊断因子删除
			s DJFactorID=""
			for
			{
				s DJFactorID=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",id,DJFactorID)) 
				q:DJFactorID=""
				s DJFactorresult= ##class(web.CDSS.CMKB.DiseJFactor).DeleteData(DJFactorID,id)
				if (DJFactorresult["false")
				{
					tro
					s result = "{success:'false',info:'疾病关联诊断因子同步删除失败！'}"
				}
			}
			//关联属性删除
			s DJPropertyID=""
			for
			{
				s DJPropertyID=$o(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",id,DJPropertyID)) 
				q:DJPropertyID=""
				
				s DJPropertyresult= ##class(web.CDSS.CMKB.DiseJProperty).DeleteData(DJPropertyID)
				if (DJPropertyresult["false")
				{
					tro
					s result = "{success:'false',info:'疾病关联属性同步删除失败！'}"
				}
			}
			//关联识别词删除
			s DJIWordID=""
			for
			{
				s DJIWordID=$o(^CT.WDT.CDSS.DiseJIWordsI("DiseaseDRIndex",id,DJIWordID)) 
				q:DJIWordID=""
				
				s DJIWordresult= ##class(web.CDSS.CMKB.DiseJIWord).DeleteData(DJIWordID)
				if (DJIWordresult["false")
				{
					tro
					s result = "{success:'false',info:'疾病关联识别词同步删除失败！'}"
				}
			}
			//关联诊断因子组合删除
			s DJFactorCombID=""
			for
			{
				s DJFactorCombID=$o(^CT.WDT.CDSS.DiseJFactorCombI("DiseaseDRIndex",id,DJFactorCombID)) 
				q:DJFactorCombID=""
				
				s DJFactorCombresult= ##class(web.CDSS.CMKB.DiseJFactorComb).DeleteData(DJFactorCombID)
				if (DJFactorCombresult["false")
				{
					tro
					s result = "{success:'false',info:'疾病关联诊断因子组合同步删除失败！'}"
				}
			}
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDict","CT.WDT.CDSS.DiseaseDict","疾病字典",id,bobj.DiseaseName,"D",bobj)
			
			//[新]疾病百科删除同名数据    2021-11-25
			//d ##class(web.CDSS.CMKB.Term).DeleteTerm("疾病",bobj.DiseaseName)
			
			//删除别名通用表中数据 2021-11-18 
	        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.DiseaseDict",id)
	        d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				
		    s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病字典","web.CDSS.CMKB.DiseaseDictDetail","DeleteData",bobj)
		    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    } else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	    }
	q result
}

/// Creator:范文凯
/// CreatDate:2020-02-14
/// Description:通过id获取疾病字典表内容
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: id 疾病字典表id
/// Return: 疾病字典表内容
/// others:w ##class(web.CDSS.CMKB.DiseaseDictDetail).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
	s eobj.RowId = id
    s eobj.DiseaseCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),2)
    s eobj.DiseaseName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),3)
    s eobj.DiseaseEnName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),4)
    s eobj.DiseaseDeptName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),6)
    s eobj.DiseaseAliasName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),7)
	s eobj.ICD9Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),10)
	s eobj.ICD9Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),11)
	s eobj.ICD10Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),12)
	s eobj.ICD10Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),13)
	s eobj.ICD10LocalCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),14)
	s eobj.ICD10LocaName= $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),15)
	s eobj.ICD11Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),16)
	s eobj.ICD11Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),17)
	s eobj.UseFlag = $LISTGET($G(^CT.WDT.CDSS.DiseaseDictD(id)),18)
	s eobj.RareDiseaseFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),19)
	s eobj.CreateDate = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),20)
	s:eobj.CreateDate'="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
	s eobj.CreateUserID = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),21)
	s eobj.Remarks = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),22)	
	s eobj.QuoteFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),23)
	s eobj.KnowledgeTotal = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),24)
	s eobj.Version = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),25)
	s eobj.DiseaseType = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),26)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-11-30
/// Description:导出疾病字典表数据【暂不用】
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.DiseaseDictDetail).ExportDiseaseCSVData("","","","","","","","","","")
ClassMethod ExportDiseaseCSVData(code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, version As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, sortmethod As %String, type As %String) As %String
{
	s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"疾病字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	o file:"NWS"
	u file
	w "疾病编码	疾病名称	疾病别名名称	疾病类型	引用标志	知识数量	版本	操作人员	操作时间	状态	备注"
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
	s:version'="" version=$ZCONVERT(version,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	s:type'="" type=$ZCONVERT(type,"U") //转换成大写
	
	s TotalNum=""
	for
	{
 		s TotalNum = $o(^CT.WDT.CDSS.DiseaseDictI("TotalIndex",TotalNum),-1) q:TotalNum=""	
		s CDSSDiseaseRowId=0
		for
		{
			s CDSSDiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictI("TotalIndex",TotalNum,CDSSDiseaseRowId)) 
			q:CDSSDiseaseRowId=""
	 		s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),2)
	 		continue:((code'="")&&($ZCONVERT(DiseaseCode,"U")'[code))
	 		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),3)
	 		continue:(($ZCONVERT(DiseaseName,"U")'[desc)&&(desc'=""))
	 		s DiseaseEnName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),4)
	 		s DiseaseAliasName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),7)
	 		continue:((aliasname'="")&&($ZCONVERT(DiseaseAliasName,"U")'[aliasname))
	 		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),18)
	 		if (state=""){
				continue:(UseFlag=1)			
			}
			else{
				continue:((state'="")&&(UseFlag'=state))
			}
			s UseFlag=$case(UseFlag,0:"编辑中",1:"已删除",2:"已审核","":"编辑中")
	 		s CreateDate = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),20)
	 		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
	 		s CreateUserID = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),21)
	 		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
	 		s Remarks = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),22)
	 		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
	 		s QuoteFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),23) //引用标志
	 		
	 		continue:(QuoteFlag'[quoteflag)
	 		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	 		
	 		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),24)	//知识数量
	 		s:KnowledgeTotal="" KnowledgeTotal=0
	 		
	 		s Version=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),25)	//版本
	 		continue:((version'="")&&($ZCONVERT(Version,"U")'[version))
	 		s DiseaseType=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),26)	//版本
	 		continue:((type'="")&&($ZCONVERT(DiseaseType,"U")'[type))
	 		
	 		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName)
	 		continue:(PINYIN'[desc)
		  	/*if (($ZCONVERT(DiseaseName,"U")[desc)||(PINYIN[desc)||($ZCONVERT(DiseaseAliasName,"U")[desc))&&($ZCONVERT(DiseaseCode,"U")[code)	//过滤条件
		  	{
		  		d OutputRow8
		 	}*/
		
	 		//替换双引号
			/*s DiseaseCode=$replace(DiseaseCode,"""","”")
			s DiseaseName=$replace(DiseaseName,"""","”")
			
			//将英文逗号转换为中文逗号
			s DiseaseCode=$replace(DiseaseCode,",","，")
			s DiseaseName=$replace(DiseaseName,",","，")
			s CreateDate=$replace(CreateDate,"""","")
			s CreateUserID=$replace(CreateUserID,",","，")*/
			
			w !,DiseaseCode_"	"_DiseaseName_"	"_DiseaseAliasName_"	"_DiseaseType_"	"_QuoteFlag_"	"_KnowledgeTotal_"	"_Version_"	"_CreateUserID_"	"_CreateDate_"	"_UseFlag_"	"_Remarks
			;s sum = sum+1
		}
	}
	
	c file
	//w sum 
	//q "{fileName:"""_fileName_"""}"
	q fileName
}

/// Creator：赵文伟
/// CreatDate:2021-11-10
/// Description：导出疾病字典表数据【在用】
/// Other:w ##class(web.CDSS.CMKB.DiseaseDictDetail).ExportDiseaseDictTXT()
/// code,desc,quoteflag,aliasname,version,opername,state,starttime,endtime,remarks,type,rareflag
ClassMethod ExportDiseaseDictTXT(code, desc, quoteflag, aliasname, version, opername, state, starttime, endtime, remarks, type, rareflag) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"疾病字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
	u file
	w "疾病编码	疾病名称	疾病别名名称	疾病类型	引用标志	版本	操作人员	操作时间	状态	备注"
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") 
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U")
	s:opername'="" opername=$ZCONVERT(opername,"U") 
	s:version'="" version=$ZCONVERT(version,"U") 
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") 
	s:type'="" type=$ZCONVERT(type,"U") 
	s:rareflag'="" rareflag=$ZCONVERT(rareflag,"U") 
	s CDSSDiseaseRowId=""
	for
	{ 
		s CDSSDiseaseRowId=$o(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId),-1) q:CDSSDiseaseRowId="" 
		
		s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),2)
		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),3)
		s:DiseaseName'="" DiseaseName = ##class(web.BDP.util.String).Replace(DiseaseName,"\","\\")
		s DiseaseEnName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),4)
		s DiseaseDeptCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),5)
		s DiseaseDeptName  = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),6)
		s DiseaseAliasName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),7)
		continue:((aliasname'="")&&($ZCONVERT(DiseaseAliasName,"U")'[aliasname))
		s DiseaseBodyPartDR = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),8)
		s MedicalCompanyCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),9)
		s ICD9Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),10)
		s ICD9Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),11)
		s ICD10Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),12)
		s ICD10Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),13)
		s ICD10LocalCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),14)
		s ICD10LocalName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),15)
		s ICD11Code = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),16)
		s ICD11Name = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),17)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),18)
		s:UseFlag="" UseFlag=0
		continue:((state'="")&&(UseFlag'=state))
		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
		s RareDiseaseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),19)
		continue:((rareflag'="")&&($ZCONVERT(RareDiseaseFlag,"U")'[rareflag))
		s CreateDate=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),20)	//创建时间
		s:CreateDate="" CreateDate="2021-01-01 00:00:00"
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
		continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),21)
		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
		s Remarks = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),22)
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s QuoteFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),23) //引用标志
		continue:(QuoteFlag'[quoteflag)
		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),24)	//知识数量
		s:KnowledgeTotal="" KnowledgeTotal=0
		s Version=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),25)	//版本
		continue:((version'="")&&($ZCONVERT(Version,"U")'[version))
		s DiseaseType=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),26)	//疾病类型
		continue:((type'="")&&($ZCONVERT(DiseaseType,"U")'[type))
		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName)
		if (($ZCONVERT(DiseaseName,"U")[desc)||(PINYIN[desc)||($ZCONVERT(DiseaseAliasName,"U")[desc))&&($ZCONVERT(DiseaseCode,"U")[code)	//过滤条件
		{
			 w !,DiseaseCode_"	"_DiseaseName_"	"_DiseaseAliasName_"	"_DiseaseType_"	"_QuoteFlag_"	"_Version_"	"_CreateUserID_"	"_CreateDate_"	"_UseFlag_"	"_Remarks
		}
			
	 	//CDSSDiseaseRowId,DiseaseCode,DiseaseName,DiseaseEnName,DiseaseDeptCode,DiseaseDeptName,DiseaseAliasName,DiseaseBodyPartDR,MedicalCompanyCode,ICD9Code,ICD9Name,ICD10Code,ICD10Name,ICD10LocalCode,ICD10LocalName,ICD11Code,ICD11Name,UseFlag,RareDiseaseFlag,CreateDate,CreateUserID,Remarks,QuoteFlag,KnowledgeTotal,Version,DiseaseType	
			
	}
	c file
	q fileName
}

/// Creator：钟荣枫 
/// CreatDate: 2021-1-13
/// Description：导入疾病字典表
/// Table:CT.WDT.CDSS.DiseaseDict
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).ImportDiseData("F:\基础数据平台文档\CDSS\疾病字典数据调整新增-0427版.csv")
ClassMethod ImportDiseData(path)
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s id=0
	
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		s DiseaseCode=$p(str,",",1)	//对接方字典代码
		continue:DiseaseCode=""
		s DiseaseName=$p(str,",",2)
		continue:DiseaseName=""
		s Version=$p(str,",",3)
		
		s DiseaseCode=$Zstrip(DiseaseCode,"<>W")
		s DiseaseName=$zstrip(DiseaseName,"<>W")
		s Version=$zstrip(Version,"<>W")
		s readcount=readcount+1
		
		s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
	    s bobj.DiseaseCode = DiseaseCode
		s bobj.DiseaseName = DiseaseName
		s bobj.Version = Version
		s bobj.DiseaseType = DiseaseType
		s bobj.UseFlag = "0"
		s bobj.CreateDate=""
		s bobj.CreateUserID = "dhcc"
		
		s result=..SaveData(bobj)
		if ((result'["false"))
		{
			s savecount=savecount+1
		}
		else
		{
			s nosavecount=nosavecount+1
			w !,DiseaseName_"导入失败"
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator:zhaowenwei
/// CreatDate:2021-11-26
/// Input:RowId  Operation 操作
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseaseDictDetail).ChangeStatus(1,"通过")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.CreateDate=eobj.CreateDate
 	s obj.CreateUserID=eobj.CreateUserID
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//同步删除对照数据【当状态变为已弃用或驳回时】  2021-12-21
		if (obj.UseFlag="1")||(obj.UseFlag="0"){
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("诊断",obj.DiseaseCode_"[A]"_obj.DiseaseName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag="2"){
			//【line=识别词名称,属性,类型,满足条件个数,项目,名称,是否有属性】
            s lineD=obj.DiseaseName_",诊断条件,主要条件-识别词,1,诊断名称,"_obj.DiseaseName_",0"
            s lineI=obj.DiseaseName_",识别条件,主要条件-识别词,1,诊断症状名称,"_obj.DiseaseName_",0"
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineD)
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDict","CT.WDT.CDSS.DiseaseDict","疾病字典",RowId,obj.DiseaseName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:xuwenhu
/// CreatDate:2021-02-05
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: id-疾病表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDictDetail","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s DiseaseAlias = $lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),7)
		s Len=$Length(DiseaseAlias,",")
		for i=1:1:Len{
			s Desc=$p(DiseaseAlias,",",i)
			continue:(Desc="")
			d OutputRowKeyWords
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowKeyWords
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasListExecute ]
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

ClassMethod GetAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：丁亚男 
/// CreatDate: 2021-4-30
/// Description：按照静静给的数据格式和要求处理数据
/// Table:CT.WDT.CDSS.DiseaseDict
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).DealDiseData("F:\基础数据平台文档\CDSS\疾病字典数据调整修改删除-0427版.csv")
ClassMethod DealDiseData(path)
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s id=0
	
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		s DiseaseCode=$p(str,",",1)	//字典代码
		s DiseaseCode=$Zstrip(DiseaseCode,"<>W")
		continue:DiseaseCode=""
		s DiseaseName=$p(str,",",2)
		s DiseaseName=$zstrip(DiseaseName,"<>W")
		continue:DiseaseName=""
		s Version=$p(str,",",3)
		s Version=$zstrip(Version,"<>W")
		
		s Operation=$p(str,",",4)
		s Alia=$p(str,",",5)
		s NewData=$p(str,",",6)
		
		s idc=$o(^CT.WDT.CDSS.DiseaseDictI("CodeIndex"," "_$ZCONVERT(DiseaseCode,"U"),0))
		s idd=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		s readcount=readcount+1
		
		if (idc'=idd)||(idc="")
		{
			w !,DiseaseCode_"-"_DiseaseName_"数据跟库里不一致"	
		}
		else
		{
			if (Operation["修改编码")
			{
				s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(idc)
				s obj.DiseaseCode = DiseaseCode
				s obj.Version = Version
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					Tc
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}" //返回RowId
					//同步修改对照数据
					d:idc'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("诊断",obj.DiseaseCode_"[A]"_obj.DiseaseName,DiseaseCode_"[A]"_obj.DiseaseName)
					s savecount=savecount+1
				}
				else
				{
					Trollback
					s nosavecount=nosavecount+1
					w !,DiseaseCode_"-"_DiseaseName_"编码没有导入成功"	
				}
			}
			elseif (Operation["修改名称")
			{
				s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(idc)
				s obj.DiseaseName = DiseaseName
				s obj.Version = Version
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					Tc
					s id = obj.%Id()
					//同步修改对照数据
					d:idc'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("诊断",obj.DiseaseCode_"[A]"_obj.DiseaseName,obj.DiseaseCode_"[A]"_DiseaseName)
					s savecount=savecount+1
				}
				else
				{
					Trollback
					s nosavecount=nosavecount+1
					w !,DiseaseCode_"-"_DiseaseName_"名称没有导入成功"	
				}
					
			}
			elseif (Operation["删除")
			{
				s result=..DeleteData(idc)
				If (result["true")
				{
					s savecount=savecount+1
					s AliaID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Alia,"U"),0))
					if (AliaID'="")
					{
						s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(AliaID)
						s obj.DiseaseAliasName = DiseaseName
						Ts
						s sc=obj.%Save()
						d obj.%Close()
						If $$$ISOK(sc)
						{
							Tc
							s id = obj.%Id()
							s savecount=savecount+1
						}
						else
						{
							Trollback
							s nosavecount=nosavecount+1
							w !,DiseaseCode_"-"_DiseaseName_"别名没有导入成功"	
						}
					}
					
				}
				else
				{
					s nosavecount=nosavecount+1
					w !,DiseaseCode_"-"_DiseaseName_"没有删除成功"	
				}
					
			}
			else
			{
				s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(idc)
				s obj.Version = Version
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					Tc
					s id = obj.%Id()
					s savecount=savecount+1
				}
				else
				{
					Trollback
					s nosavecount=nosavecount+1
					w !,DiseaseCode_"-"_DiseaseName_"版本没有导入成功"	
				}
			}
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量通过
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).ChangeStatusPass("")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result="",flag=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeStatus(id,"通过")
#;			s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(id)
#;			s obj.UseFlag=2
#;			s obj.CreateDate=$zdt($h,3)
#; 			s obj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))
#;			s sc=obj.%Save()
#;			d obj.%Close()
#;			If $$$ISOK(sc)
#;			{
#;				continue
#;			}
#;			else{
#;				s errorflag = errorflag+1
#;			}
			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
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

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).ChangeStatusBack("")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result="",flag=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeStatus(id,"驳回")
			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
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

/// Creator：赵文伟 
/// CreatDate: 2021-11-18
/// Description：疾病字典别名数据转存到别名通用表中
/// Table:CT.WDT.CDSS.DiseaseDict
/// Other: d ##class(web.CDSS.CMKB.DiseaseDictDetail).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),7)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDict",RowId,Alias)
		}	 	
	}
	q ""
}

/// Creator：赵文伟 
/// CreatDate: 2023-03-10
/// Description：疾病字典别名数据转存到别名通用表中【清空别名表疾病别名重新转存全部数据】
/// Table:CT.WDT.CDSS.DiseaseDict
/// Other: d ##class(web.CDSS.CMKB.DiseaseDictDetail).ReSaveAliasData() 
ClassMethod ReSaveAliasData() As %String
{
	
	s RowId=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDictD(RowId))
		q:RowId=""
		s result = ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.DiseaseDict",RowId)
		s Alias = $lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),7)        
		if Alias'=""
		{
			s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDict",RowId,Alias)
		}	 	
	}
	q ""
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.DiseaseDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),18)       
		if (UseFlag'="")
		{
			if (UseFlag=0){
				s editcount=editcount+1
			} elseif (UseFlag=2){
				s auditcount=auditcount+1
			}
		}
		s totalcount=editcount+auditcount	 	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator：赵文伟
/// CreatDate: 2022-04-07
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.DiseaseDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.DiseaseDictDetail).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.DiseaseDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		s flag=..FormValidate(eobj.RowId,eobj.DiseaseName,eobj.DiseaseCode)   //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.RowId,eobj.DiseaseName,eobj.DiseaseAliasName)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.DiseaseDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
			
			s bobj.DiseaseCode = obj.DiseaseCode
			s bobj.DiseaseName = obj.DiseaseName
			s bobj.DiseaseAliasName = obj.DiseaseAliasName
			s bobj.CreateDate=obj.CreateDate		//创建时间
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			
		}
		s obj.DiseaseCode = eobj.DiseaseCode
		s obj.DiseaseName = eobj.DiseaseName
		s obj.DiseaseAliasName = eobj.DiseaseAliasName
		s eobj.CreateDate=$ZDATETIME($H,3)
		s obj.CreateDate=eobj.CreateDate	
		s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))	
		s obj.CreateUserID=eobj.CreateUserID
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDict","CT.WDT.CDSS.DiseaseDict","疾病字典",id,eobj.DiseaseName,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDict","CT.WDT.CDSS.DiseaseDict","疾病字典",eobj.RowId,eobj.DiseaseName,"U",eobj,bobj)
			
			//[新]疾病百科增加一条同名数据    2021-11-25
			d:eobj.RowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("疾病",eobj.DiseaseName,"")
			d:eobj.RowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("疾病",eobj.DiseaseName,bobj.DiseaseName)
			//同步修改对照数据
			d:eobj.RowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("诊断",bobj.DiseaseCode_"[A]"_bobj.DiseaseName,eobj.DiseaseCode_"[A]"_eobj.DiseaseName)
			//同步修改识别词项目数据
			d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("诊断名称",eobj.DiseaseName,bobj.DiseaseName)
			d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("诊断症状名称",eobj.DiseaseName,bobj.DiseaseName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.RowId="")&&(eobj.DiseaseAliasName'=""))||((eobj.RowId'="")&&(eobj.DiseaseAliasName'=bobj.DiseaseAliasName))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDict",id,eobj.DiseaseAliasName)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病字典","web.CDSS.CMKB.DiseaseDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病字典","web.CDSS.CMKB.DiseaseDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：赵文伟
/// CreatDate: 2022-06-24
/// Description：导入疾病字典表
/// Table:CT.WDT.CDSS.DiseaseDict
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).ImportDiseVersionData("D:\ZWW\疾病字典数据版本调整.csv")
ClassMethod ImportDiseVersionData(path)
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s id=0
	
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		
		s DiseaseName=$p(str,",",1)
		continue:DiseaseName=""
		s DiseaseCode=$p(str,",",2)
		s Version=$p(str,",",3)
		s readcount=readcount+1
		
		s RowId=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0)) q:RowId=""
		s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(RowId)
		if (DiseaseCode'=""){
			s obj.DiseaseCode=DiseaseCode
		}
		if (Version'=""){
			s obj.Version=Version
		}
		s obj.CreateDate=$zdt($h,3)
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s savecount=savecount+1
		}
		else{
			s nosavecount=nosavecount+1
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回文献表的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDictDetail","GetLogList","20")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Operation")
{
}

ClassMethod GetLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.DiseaseDict",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Operation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Operation="编辑"
         	}
         	d OutputRowLog
	    }
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Operation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogListExecute ]
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

ClassMethod GetLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：赵文伟
/// CreatDate: 2023-01-10
/// Description：转存疾病字典数据到疾病百科【百科中不存在的数据】
/// Table：CT.WDT.CDSS.DiseaseDict	疾病字典
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.DiseaseDictDetail).TransferSaveData()
ClassMethod TransferSaveData() As %String
{
	
	s CDSSDiseaseRowId=""
	s count=0
	for
	{ 	
		s CDSSDiseaseRowId=$o(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId),-1) q:CDSSDiseaseRowId="" 
		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),3)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),18)
		continue:(UseFlag=1)	//过滤已弃用数据
		s BaseDR=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_"疾病",0))
		if (BaseDR'="")
		{
			//如果百科中不存在，调用接口保存
			if ('$d(^CT.WDT.CDSS.TermI("DescIndex",BaseDR," "_($ZCONVERT(DiseaseName,"U")))))	
			{
				d ##class(web.CDSS.CMKB.Term).SaveTerm("疾病",DiseaseName,"")
				s count=count+1
			}	
		}
	}
	//w "共检测到"_count_"条数据。"
	w "处理完成,共处理"_count_"条数据。"
}

/// Creator：赵文伟
/// CreatDate: 2023-02-27
/// Description：导出诊疗规则1.0触发条件在对应字典中不存在的数据
/// Table：CT.WDT.CDSS.DiseaseDict User.DHCDSSRuleTrigger
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.DiseaseDictDetail).ExportRuleData()
ClassMethod ExportRuleData() As %String
{
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="诊疗规则触发条件数据导出.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("触发条件表ID,"_"触发项目,"_"数据类型,"_"触发条件")
	d file.WriteLine()
	
	
	s RuleTriggerId=""
	s num=0
	s TempDiag={},TempDrug={},TempExam={},TempLab={},TempInsp={},TempOper={},TempNurse={},TempBlood={},TempExamR={},TempSympT={},TempSymp={}
	for
	{ 
		s RuleTriggerId=$o(^User.DHCDSSRuleTriggerD(RuleTriggerId),-1) q:RuleTriggerId="" 
		s TriggerClass=$lg($g(^User.DHCDSSRuleTriggerD(RuleTriggerId)),4)
		s TriggerItem=$lg($g(^User.DHCDSSRuleTriggerD(RuleTriggerId)),5)
		s TriggerItemValue=$lg($g(^User.DHCDSSRuleTriggerD(RuleTriggerId)),7)
		
		if (TriggerItem="DiagnosisName"){	//疾病
			if ('$d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempDiag.%Get(TriggerItemValue)
				if (flag="")
				{
					d TempDiag.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}
			
		} elseif (TriggerItem="DrugName"){	//药品  ($ZCONVERT(TriggerItemValue,"U"))
			if ('$d(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempDrug.%Get(TriggerItemValue)
				if (flag="")
				{
					d TempDrug.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}
			
		} elseif (TriggerItem="ExamName"){	//检查
			if ('$d(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempExam.%Get(TriggerItemValue)
				if (flag="")
				{	
					d TempExam.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}

		} elseif (TriggerItem="LabItemName"){	//检验项目
			if ('$d(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempLab.%Get(TriggerItemValue)
				if (flag="")
				{	
					d TempLab.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}

		} elseif (TriggerItem="InspectionName"){	//检验医嘱
			if ('$d(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempInsp.%Get(TriggerItemValue)
				if (flag="")
				{	
					d TempInsp.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}

		} elseif (TriggerItem="OperName"){	//手术
			if ('$d(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempOper.%Get(TriggerItemValue)
				if (flag="")
				{
					d TempOper.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}

		} elseif (TriggerItem="NursingItemName"){	//护理
			if ('$d(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempNurse.%Get(TriggerItemValue)
				if (flag="")
				{	
					d TempNurse.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}

		} elseif (TriggerItem="BloodTransClass"){	//输血品
			if ('$d(^CT.WDT.CDSS.BloodProductDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempBlood.%Get(TriggerItemValue)
				if (flag="")
				{	
					d TempBlood.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}

		} elseif (TriggerItem="ExamResult"){	//检查结果
			if ('$d(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
				
				s flag=TempExamR.%Get(TriggerItemValue)
				if (flag="")
				{	
					d TempExamR.%Set(TriggerItemValue,TriggerItemValue)
					d file.Write(RuleTriggerId_",")
					d file.Write(TriggerItem_",")
					d file.Write(TriggerClass_",")
					d file.Write(TriggerItemValue)
					d file.WriteLine()
					
				}
			}
			
		} elseif (TriggerItem="Symptom"){	//体格检查&症状
			if (TriggerClass="CDD00219"){	//体格检查
				if ('$d(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
					
					s flag=TempSympT.%Get(TriggerItemValue)
					if (flag="")
					{	
						d TempSympT.%Set(TriggerItemValue,TriggerItemValue)
						d file.Write(RuleTriggerId_",")
						d file.Write(TriggerItem_",")
						d file.Write(TriggerClass_",")
						d file.Write(TriggerItemValue)
						d file.WriteLine()
						
					}
				}
				
			} elseif (TriggerClass="CDD00204"){	//症状
				if ('$d(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_($ZCONVERT(TriggerItemValue,"U"))))){
					
					s flag=TempSymp.%Get(TriggerItemValue)
					if (flag="")
					{	
						d TempSymp.%Set(TriggerItemValue,TriggerItemValue)
						d file.Write(RuleTriggerId_",")
						d file.Write(TriggerItem_",")
						d file.Write(TriggerClass_",")
						d file.Write(TriggerItemValue)
						d file.WriteLine()
						
					}
				}
			}
		}
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2023-03-06
/// Description：字典导入新增的别名数据【遍历判断如果表中已存在当前别名不新增，不存在追加在后面】,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:疾病字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).ImportAliasData("D:\ZWW\需新增别名数据.txt")
ClassMethod ImportAliasData(path) As %String
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("R")
	k myFileAry
	
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s readcount=readcount+1
		s myFileAry(i)=data
		
		s DiseaseName=$p(data,$c(9),1)	//名称
		s Alias=$p(data,$c(9),2)		//别名
		s flag=0
		s RowId=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		TS
		if (RowId'=""){
		
			s obj=##class(CT.WDT.CDSS.DiseaseDict).%OpenId(RowId)
			s OldAlias=obj.DiseaseAliasName
			s lenN=$l(Alias,",")
			for n=1:1:lenN		//遍历导入的别名
			{
				s AliasN=$p(Alias,",",n)
				s len=$l(OldAlias,",")
				for j=1:1:len		//遍历表中已有的别名
				{
					s AliasT=$p(OldAlias,",",j)
					if (AliasN=AliasT){		//判断是否有已存在的数据
						s flag=1
					}
				}
			}
			if (flag=0){
				if (obj.DiseaseAliasName=""){
					s obj.DiseaseAliasName=Alias
				}else{
					s obj.DiseaseAliasName=obj.DiseaseAliasName_","_Alias
				}
				s sc= obj.%Save()
				
				if $$$ISOK(sc)
				{
					s id = obj.%Id()
					s result = "{success:'true'}"
					//同步保存别名到别名通用表
		            if (RowId'="")
		            {
		            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDict",id,obj.DiseaseAliasName)
		            }
		            d obj.%Close()
		            TC
				}
				else
				{
					s result = "{success:'false'}"
					TRO
				}
				
				if (result["true")
				{
					s savecount=savecount+1
				}
				else
				{
					s nosavecount=nosavecount+1
				}
			}else{
				w !,DiseaseName_"^"_Alias_" 存在重复别名"
				TRO
			}
		}else{
			w !,DiseaseName_"不存在"
			TRO
		}
	}
	close file
    k file
	w !,"readcount："_(readcount-1),!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator：赵文伟 
/// CreatDate: 2023-04-20
/// Description：根据名称取编码
/// Table:CT.WDT.CDSS.DiseaseDict
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).GetCodeByName("金属中毒") 
ClassMethod GetCodeByName(name) As %String
{
	q:name="" ""
	s RowId=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(name,"U"),0))
	s DiseaseCode=""
	s:RowId'="" DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),2)
	
	q DiseaseCode
}

/// Creator：赵文伟
/// CreatDate: 2023-05-18
/// Description：导入新增疾病数据
/// Table:CT.WDT.CDSS.DiseaseDict
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).ImportNewDiseData("D:\ZWW\疾病字典待新增数据-0518.csv")
ClassMethod ImportNewDiseData(path)
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s id=0
	
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s DiseaseCode=$p(str,",",1)
		s DiseaseName=$p(str,",",2)
		continue:DiseaseName=""
		s DiseaseAlias=$p(str,",",3)
		s Version=$p(str,",",4)
		s UseFlag=$p(str,",",5)
		if (UseFlag="已审核"){
			s UseFlag=2
		}elseif(UseFlag="已弃用"){
			s UseFlag=1
		}elseif(UseFlag="编辑中"){
			s UseFlag=0
		}
		s readcount=readcount+1
		
		//s RowId=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		if ($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U")))){
			w DiseaseName_"已存在",!
		} else{
			s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDict).%New()
			s eobj.RowId=""
			s eobj.DiseaseCode=DiseaseCode
			s eobj.DiseaseName=DiseaseName
			s eobj.DiseaseAliasName=DiseaseAlias
			s eobj.UseFlag=UseFlag
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUserID="dhcc"
			s eobj.Version = Version

			TS
			s result=..SaveData(eobj)
			if (result["true"){
				s savecount=savecount+1
				if (eobj.UseFlag=2){	//已审核数据识别词同步新增数据
					s lineD=eobj.DiseaseName_",诊断条件,主要条件-识别词,1,诊断名称,"_eobj.DiseaseName_",0"
	            	s lineI=eobj.DiseaseName_",识别条件,主要条件-识别词,1,诊断症状名称,"_eobj.DiseaseName_",0"
	            	d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineD)
	            	d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
				}
				TC
			}else{
				w DiseaseName_"保存失败",!
				s nosavecount=nosavecount+1
				TRO
			}
		}
		
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate:2023-05-18
/// Description:获得版本下拉框数据【取表中版本去重数据】
/// Table: CT.WDT.CDSS.DiseaseDict
/// Input: 疾病字典表id
/// Return:返回所有版本下拉框内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseaseDictDetail","GetVersionForCmb1","","","")
Query GetVersionForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "RowId,Version")
{
}

ClassMethod GetVersionForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s RowId=rowid
  		s Version=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),25)			//版本
  		d OutputRowCmb
 	}
 	else
 	{
	 	if (desc="") s desc=q
	 	s desc=$ZCONVERT(desc,"U")
	 	s store={}
	 	s RowId=""
		for
		{ 
			s RowId=$o(^CT.WDT.CDSS.DiseaseDictD(RowId),-1) q:RowId="" 
			s Version=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),25)			//版本
			continue:(Version="")
			s flag=store.%Get(Version)
			if (flag=""){
				d store.%Set(Version,Version)
				if ($ZCONVERT(Version,"U")[desc)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,Version)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetVersionForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVersionForCmb1Execute ]
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

ClassMethod GetVersionForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVersionForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：赵文伟 
/// CreatDate: 2023-05-19
/// Description：批量删除已弃用数据[未被引用或只被字典对照引用]
/// Table:CT.WDT.CDSS.DiseaseDict
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).DeleteDeprecatedData() 
ClassMethod DeleteDeprecatedData() As %String
{
	s count=0
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.DiseaseDictD(RowId),-1) q:RowId="" 
		s Name=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),3)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),18)
		if (UseFlag=1){
			s quoteInfo=..GetRefFlag(RowId)
			if '((quoteInfo["诊疗规则关联触发条件表")||(quoteInfo["规则管理")||(quoteInfo["识别词规则")){
				d ##class(web.CDSS.CMKB.DiseaseDictDetail).DeleteData(RowId)
				w Name_"已删除",!
				s count=count+1
			}
		}
	}
	q "success,已删除"_count_"条数据！"
}

/// Creator：赵文伟 
/// CreatDate: 2023-05-19
/// Description：统一导出已弃用数据及被引用信息【疾病，药品，检查，手术，护理】
/// Table: CT.WDT.CDSS.DiseaseDict
/// Other: w ##class(web.CDSS.CMKB.DiseaseDictDetail).ExportDeprecatedData() 
ClassMethod ExportDeprecatedData() As %String
{
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="统一导出已弃用数据及被引用信息.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("字典,"_"RowId,"_"名称,"_"引用信息")
	d file.WriteLine()
	
	//疾病
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.DiseaseDictD(RowId),-1) q:RowId="" 
		s Name=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),3)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(RowId)),18)
		if (UseFlag=1){
			s quoteInfo=..GetRefFlag(RowId)
#;			if ((quoteInfo["诊疗规则关联触发条件表")||(quoteInfo["规则管理")||(quoteInfo["识别词规则")){
#;			}
			d file.Write("疾病,")
			d file.Write(RowId_",")
			d file.Write(Name_",")
			d file.Write(quoteInfo)
			d file.WriteLine()
		}
	}
	//药物
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.DrugDictD(RowId),-1) q:RowId="" 
		s Name = $LISTGET($G(^CT.WDT.CDSS.DrugDictD(RowId)),4)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DrugDictD(RowId)),30)
		if (UseFlag=1){
			s quoteInfo=##class(web.CDSS.CMKB.DrugDict).GetRefFlag(RowId)
			d file.Write("药物,")
			d file.Write(RowId_",")
			d file.Write(Name_",")
			d file.Write(quoteInfo)
			d file.WriteLine()
		}
	}
	//检查
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.ExamDictD(RowId),-1) q:RowId="" 
		s Name = $LISTGET($G(^CT.WDT.CDSS.ExamDictD(RowId)),4)
		s UseFlag = $lg($g(^CT.WDT.CDSS.ExamDictD(RowId)),25)
		if (UseFlag=1){
			s quoteInfo=##class(web.CDSS.CMKB.ExamDictDetail).GetRefFlag(RowId)
			d file.Write("检查,")
			d file.Write(RowId_",")
			d file.Write(Name_",")
			d file.Write(quoteInfo)
			d file.WriteLine()
		}
	}
	//手术
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.OperationDictD(RowId),-1) q:((RowId="")) 
		s Name=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(RowId)),4)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(RowId)),12)
		if (UseFlag=1){
			s quoteInfo=##class(web.CDSS.CMKB.OperationDictDetail).GetRefFlag(RowId)
			d file.Write("手术,")
			d file.Write(RowId_",")
			d file.Write(Name_",")
			d file.Write(quoteInfo)
			d file.WriteLine()
		}
	}
	//护理
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.NursingDictD(RowId),-1) q:RowId="" 
		s Name=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RowId)),4)
		s UseFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(RowId)),22)
		if (UseFlag=1){
			s quoteInfo=##class(web.CDSS.CMKB.NursingDictDetail).GetRefFlag(RowId)
			d file.Write("护理,")
			d file.Write(RowId_",")
			d file.Write(Name_",")
			d file.Write(quoteInfo)
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

}

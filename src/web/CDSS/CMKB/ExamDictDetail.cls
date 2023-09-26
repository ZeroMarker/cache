/// Description：检查字典表
/// Table：CT.WDT.CDSS.ExamDict 
Class web.CDSS.CMKB.ExamDictDetail Extends %RegisteredObject
{

/// Creator：ZWW
/// CreatDate: 2022-09-15
/// Description：查询检查字典
/// Table：CT.WDT.CDSS.ExamDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ExamDictDetail","GetList","","","测试1","","","","","","","","")
Query GetList(rowid, code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "ExamRowId,ExamNationCode,ExamCode,ExamName,ExamNamePinyin,ExamNameFirstPinyin,ExamEnglishName,ExamFirstClassF,ExamFirstClass,ExamSecondClassF,ExamSecondClass,ExamClassF,ExamClass,ExamDesc,ExamParts,ExamProcess,IndicationOverview,ExamTaboo,AdverseReactions,ExamPrecautions,ExamResult,Remarks,QuoteFlag,KnowledgeTotal,CreateDate,CreateUserID,Alias,UseFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, sortmethod As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s ExamRowId=rowid
	s ExamNationCode=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),2)
	s ExamCode=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),3)
	s ExamName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),4)
	s ExamNamePinyin=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),5)
	s ExamNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),6)
	s ExamEnglishName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),7)
	
	s ExamFirstClass=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),8)
	s ExamSecondClass=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),9)
	s ExamClass=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),10)
	
	s ExamDesc=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),11)
	s ExamParts=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),12)
	s ExamProcess=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),13)
	s IndicationOverview=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),14)
	s ExamTaboo=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),15)
	s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),16)
	s ExamPrecautions=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),17)
	s ExamResult=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),18)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),19)
	s QuoteFlag=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),20) //引用标志
	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),21)	//知识数量
	s:KnowledgeTotal="" KnowledgeTotal=0
	s CreateDate=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),22)	//创建时间
	s CreateUserID=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),23)	//创建人员
	s Alias=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),24)	//别名
	s UseFlag=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),25)	//状态
	s:UseFlag="" UseFlag=0
	d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写 
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写 
	//默认时间倒序输出
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ExamDictD(ID))
			q:ID=""
			s ExamName= $lg($g(^CT.WDT.CDSS.ExamDictD(ID)),4)		//名称
			s length=$l(ExamName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ExamDictD(ID))
			q:ID=""
			s CreateDate= $lg($g(^CT.WDT.CDSS.ExamDictD(ID)),22)		//编辑时间 
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
		s ExamRowId=0
		for
		{
			s ExamRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,ExamRowId)) q:ExamRowId=""
			s ExamNationCode=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),2)
			s ExamCode=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),3)
			s ExamName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),4)
			s ExamNamePinyin=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),5)
			s ExamNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),6)
			s ExamEnglishName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),7)

			s ExamFirstClass=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),8)
			s ExamSecondClass=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),9)
			s ExamClass=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),10)
			
			s ExamDesc=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),11)
			s ExamParts=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),12)
			s ExamProcess=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),13)
			s IndicationOverview=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),14)
			s ExamTaboo=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),15)
			s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),16)
			s ExamPrecautions=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),17)
			s ExamResult=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),18)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),19)
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))	
			s QuoteFlag=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),20) //引用标志
		 	continue:(QuoteFlag'[quoteflag)
		 	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
		 	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),21)	//知识数量
		 	s:KnowledgeTotal="" KnowledgeTotal=0
		 	s CreateDate=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),22)	//创建时间
		 	continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
	        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
			s CreateUserID=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),23)	//创建人员
			continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
			s Alias=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),24)	//别名
			continue:((aliasname'="")&&($ZCONVERT(Alias,"U")'[aliasname))
			s UseFlag=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),25)	//状态
			s:UseFlag="" UseFlag=0
			if (state=""){
				continue:(UseFlag="1")			
			}
			else{
				continue:((state'="")&&(UseFlag'=state))
			}
			if (($ZCONVERT(ExamName,"U")[desc)||($ZCONVERT(ExamNamePinyin,"U")[desc)||($ZCONVERT(ExamNameFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(ExamCode,"U")[code)
			{
				d OutputRow
			}
		}
	}
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ExamRowId,ExamNationCode,ExamCode,ExamName,ExamNamePinyin,ExamNameFirstPinyin,ExamEnglishName,ExamFirstClassF,ExamFirstClass,ExamSecondClassF,ExamSecondClass,ExamClassF,ExamClass,ExamDesc,ExamParts,ExamProcess,IndicationOverview,ExamTaboo,AdverseReactions,ExamPrecautions,ExamResult,Remarks,QuoteFlag,KnowledgeTotal,CreateDate,CreateUserID,Alias,UseFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
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
/// CreatDate:2020-7-2
/// Description:获取引用标志对应的中文
/// Input: QuoteFlag 引用str
/// Return:描述
/// Other:w ##class(web.CDSS.CMKB.ExamDictDetail).GetQuoteFlag("D,K,R")
ClassMethod GetQuoteFlag(QuoteFlag)
{
	/// 引用标志  K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照 ;W（Warning）被预警规则引用
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
			else		//前面数据不为空
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
			else	//前面数据不为空
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
			else		//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"数据对照"
		
			}
		}
		if QuoteFlag["W"	//被预警规则引用
		{
			if QuoteFlagDesc=""	//前面数据为空
			{
				s QuoteFlagDesc="预警规则库"
			}
			else		//前面数据不为空
			{
				s QuoteFlagDesc=QuoteFlagDesc_","_"预警规则库"
		
			}
		}
		s value=QuoteFlagDesc
		
	}
	q value
}

/// Creator:钟荣枫 
/// CreatDate:2020-6-21
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.ExamDict	检查字典
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.ExamDictDetail).FormValidate("","00696","眼底检查")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagn="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.ExamDictI("CodeIndex"," "_code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_desc))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idn="",idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.ExamDictI("CodeIndex"," "_code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_desc,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.ExamDictDetail).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.ExamDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.ExamDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.ExamDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.ExamDictI("NameIndex",Alias,0))  							//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2020-06-19
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.ExamDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.ExamDictDetail).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.ExamDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.ExamRowId,eobj.ExamCode,eobj.ExamName) //校验重复
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ExamRowId,eobj.ExamName,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ExamRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.ExamDict).%New() 
			s obj.UseFlag=0
			
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(eobj.ExamRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.ExamDict).%New()
			s bobj.ExamNationCode = obj.ExamNationCode  
			s bobj.ExamCode = obj.ExamCode  
			s bobj.ExamName = obj.ExamName  
			s bobj.ExamNamePinyin = obj.ExamNamePinyin 
			s bobj.ExamNameFirstPinyin = obj.ExamNameFirstPinyin
			s bobj.ExamEnglishName = obj.ExamEnglishName 
			
			s bobj.ExamFirstClass = obj.ExamFirstClass
			s bobj.ExamSecondClass = obj.ExamSecondClass
			s bobj.ExamClass = obj.ExamClass
			
			s bobj.ExamDesc = obj.ExamDesc  
			s bobj.ExamParts = obj.ExamParts  
			s bobj.ExamProcess = obj.ExamProcess 
			s bobj.IndicationOverview = obj.IndicationOverview
			s bobj.ExamTaboo = obj.ExamTaboo  
			s bobj.AdverseReactions = obj.AdverseReactions  
			s bobj.ExamPrecautions = obj.ExamPrecautions 
			s bobj.ExamResult = obj.ExamResult
			s bobj.Remarks = obj.Remarks
			s bobj.QuoteFlag = obj.QuoteFlag
			s bobj.KnowledgeTotal = obj.KnowledgeTotal
			s bobj.CreateDate = obj.CreateDate
			s bobj.CreateUserID = obj.CreateUserID
			s bobj.Alias=obj.Alias
			s bobj.UseFlag=obj.UseFlag
		}
		
		s obj.ExamNationCode = eobj.ExamNationCode  
		s obj.ExamCode = eobj.ExamCode  
		s obj.ExamName = eobj.ExamName  
		s obj.ExamNamePinyin = eobj.ExamNamePinyin 
		s obj.ExamNameFirstPinyin = eobj.ExamNameFirstPinyin
		s obj.ExamEnglishName = eobj.ExamEnglishName 
		
		s obj.ExamFirstClass = eobj.ExamFirstClass
		s obj.ExamSecondClass = eobj.ExamSecondClass
		s obj.ExamClass = eobj.ExamClass
		
		s obj.ExamDesc = eobj.ExamDesc  
		s obj.ExamParts = eobj.ExamParts  
		s obj.ExamProcess = eobj.ExamProcess 
		s obj.IndicationOverview = eobj.IndicationOverview
		s obj.ExamTaboo = eobj.ExamTaboo  
		s obj.AdverseReactions = eobj.AdverseReactions  
		s obj.ExamPrecautions = eobj.ExamPrecautions 
		s obj.ExamResult = eobj.ExamResult
		s obj.Remarks = eobj.Remarks
		
		s obj.CreateDate = eobj.CreateDate
		s obj.CreateUserID = eobj.CreateUserID
		s obj.Alias=eobj.Alias
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			
			//保存日志
			d:eobj.ExamRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ExamDict","CT.WDT.CDSS.ExamDict","检查字典",id,eobj.ExamName,"A",eobj)
			d:eobj.ExamRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ExamDict","CT.WDT.CDSS.ExamDict","检查字典",eobj.ExamRowId,eobj.ExamName,"U",eobj,bobj)
			
			//[新]检查百科增加一条同名数据   2021-11-25
			d:eobj.ExamRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("检查",eobj.ExamName,"")
			d:eobj.ExamRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("检查",eobj.ExamName,bobj.ExamName)
			
			//调用字典对照接口
			d:eobj.ExamRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检查", bobj.ExamCode_"[A]"_bobj.ExamName,eobj.ExamCode_"[A]"_eobj.ExamName)
			
			//同步修改识别词项目数据    2021-11-25
			d:eobj.ExamRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("检查项目名称",eobj.ExamName,bobj.ExamName)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表 2022-01-12
            if ((eobj.ExamRowId="")&&(eobj.Alias'=""))||((eobj.ExamRowId'="")&&(eobj.Alias'=bobj.Alias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.ExamDict",id,eobj.Alias)
            }
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检查字典","web.CDSS.CMKB.ExamDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检查字典","web.CDSS.CMKB.ExamDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2020-06-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.ExamDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.ExamDict).%New()
	s bobj.ExamNationCode = obj.ExamNationCode  
	s bobj.ExamCode = obj.ExamCode  
	s bobj.ExamName = obj.ExamName  
	s bobj.ExamNamePinyin = obj.ExamNamePinyin 
	s bobj.ExamNameFirstPinyin = obj.ExamNameFirstPinyin
	s bobj.ExamEnglishName = obj.ExamEnglishName 
	
	s bobj.ExamFirstClass = obj.ExamFirstClass 
	s bobj.ExamSecondClass = obj.ExamSecondClass 
	s bobj.ExamClass = obj.ExamClass 
	
	s bobj.ExamDesc = obj.ExamDesc  
	s bobj.ExamParts = obj.ExamParts  
	s bobj.ExamProcess = obj.ExamProcess 
	s bobj.IndicationOverview = obj.IndicationOverview
	s bobj.ExamTaboo = obj.ExamTaboo  
	s bobj.AdverseReactions = obj.AdverseReactions  
	s bobj.ExamPrecautions = obj.ExamPrecautions 
	s bobj.ExamResult = obj.ExamResult
	s bobj.Remarks = obj.Remarks
	
	s bobj.QuoteFlag = obj.QuoteFlag
	s bobj.KnowledgeTotal = obj.KnowledgeTotal
	s bobj.CreateDate = obj.CreateDate
	s bobj.CreateUserID = obj.CreateUserID
	s bobj.Alias=obj.Alias
	s bobj.UseFlag=obj.UseFlag
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()
	q str
}

/// Creator：高姗姗
/// CreatDate: 2020-08-18
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).GetRefFlag("167")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s DictDesc=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(id)),4)
	//诊疗规则引用接口
	s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("检查",DictDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("检查",DictDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
	
	//识别词项目引用接口
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("检查项目名称",DictDesc)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr

	//字典对照引用接口	2022-04-08 ZWW
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("检查",DictDesc)
	s myInfo=myInfo_Mappinginfo
	
	//规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("检查",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用"
 	q return
}

/// Creator:丁亚男
/// CreatDate:2020-06-18
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.ExamDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.ExamDictDetail).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.ExamDict).%New()
	s bobj.ExamNationCode = obj.ExamNationCode  
	s bobj.ExamCode = obj.ExamCode  
	s bobj.ExamName = obj.ExamName  
	s bobj.ExamNamePinyin = obj.ExamNamePinyin 
	s bobj.ExamNameFirstPinyin = obj.ExamNameFirstPinyin
	s bobj.ExamEnglishName = obj.ExamEnglishName 
	
	s bobj.ExamFirstClass = obj.ExamFirstClass 
	s bobj.ExamSecondClass = obj.ExamSecondClass 
	s bobj.ExamClass = obj.ExamClass 
		
	s bobj.ExamDesc = obj.ExamDesc  
	s bobj.ExamParts = obj.ExamParts  
	s bobj.ExamProcess = obj.ExamProcess 
	s bobj.IndicationOverview = obj.IndicationOverview
	s bobj.ExamTaboo = obj.ExamTaboo  
	s bobj.AdverseReactions = obj.AdverseReactions  
	s bobj.ExamPrecautions = obj.ExamPrecautions 
	s bobj.ExamResult = obj.ExamResult
	s bobj.Remarks = obj.Remarks
		
	s bobj.QuoteFlag = obj.QuoteFlag
	s bobj.KnowledgeTotal = obj.KnowledgeTotal
		
	s bobj.CreateDate = obj.CreateDate
	s bobj.CreateUserID = obj.CreateUserID
	s bobj.Alias=obj.Alias
	s bobj.UseFlag=obj.UseFlag
	Ts
	//同步删除对照数据 2022-01-21
	s re = ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("检查",obj.ExamCode_"[A]"_obj.ExamName)
	if (re="true[A]true"){
		s sc=##class(CT.WDT.CDSS.ExamDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//[新]检查百科删除同名数据    2021-11-25
			//d ##class(web.CDSS.CMKB.Term).DeleteTerm("检查",bobj.ExamName)
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ExamDict","CT.WDT.CDSS.ExamDict","检查字典",id,bobj.ExamName,"D",bobj)
					
			//删除别名通用表中数据 2022-01-12 
	        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.ExamDict",id)
			d bobj.%Close()
				
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("检查字典","web.CDSS.CMKB.ExamDictDetail","DeleteData",bobj)
		    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	} else{
		s result = "{success:'false',info:'字典对照同步删除失败！'}"
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 检查
/// Table：CT.WDT.CDSS.ExamDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ExamDictDetail","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "ExamID:%String,ExamName:%String,ExamCodeDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{

	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s ExamID=rowid
		s ExamName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamID)),4)
		d OutputRowCmb
	}
	else
	{
		if (desc="") s desc=q
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		//s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ExamDictD(ID))
			q:ID=""
			s ExamName=$lg($g(^CT.WDT.CDSS.ExamDictD(ID)),4)		//名称
			s length=$l(ExamName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s ExamID=0
			for
			{
				s ExamID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,ExamID))
				q:ExamID=""
				s ExamCodeDR=ExamID
				s ExamName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamID)),4)
		  		s ExamNamePinyin=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamID)),5)
		 		s ExamNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamID)),6) 
		 		s Alias=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamID)),24)	//别名
		 		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamID)),25)
		 		
		  		if ((($ZCONVERT(ExamName,"U")[desc)||(ExamNamePinyin[desc)||(ExamNameFirstPinyin[desc)||($ZCONVERT(Alias,"U")[desc))&(UseFlag="2")) {
		  			d OutputRowCmb
		  		}
		  		continue:(desc'="")
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ExamID,ExamName,ExamCodeDR)
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
		//if there are no more rows,finish fetching
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

/// Creator:高姗姗
/// CreatDate:2020-09-10
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.ExamDictDetail).RemoveQuoteFlag("A,R,M","R")
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

/// Creator:高姗姗
/// CreatDate:2020-07-17
/// Editor: 赵文伟 2022-06 【修改百科、字典对照2.0；添加预警规则】
/// Description:保存知识数量
/// Table: CT.WDT.CDSS.ExamDict	检查字典
/// others:w ##class(web.CDSS.CMKB.ExamDictDetail).SaveKnowledgeTotal()
ClassMethod SaveKnowledgeTotal()
{
	s ExamID=""
	for
	{ 
		s ExamID=$o(^CT.WDT.CDSS.ExamDictD(ExamID)) q:ExamID="" 
		s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(ExamID)
	
 		s QuoteFlag = obj.QuoteFlag
 		s ExamCode = obj.ExamCode
 		s ExamName = obj.ExamName
		
		;K（Knowledge） 被医为百科引用
		s basedr=##class(web.CDSS.CMKB.Term).GetIdByDesc("检查")
		if (basedr'="")
		{
			if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(ExamName,"U")))))
			{
				s termdr=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(ExamName,"U")),""))
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
					}else{
						s obj.QuoteFlag=##class(web.CDSS.CMKB.ExamDictDetail).RemoveQuoteFlag(QuoteFlag,"K")	
					}
				}
			}
		}
		
		s QuoteFlag = obj.QuoteFlag
		;M（Mapping）数据对照2.0
		
		s ContrastType="检查检验"
		s MappingFlag=0
		s ContrastDictDR=""
		
		if ($d(^CT.WDT.CDSS.ContrastDictI("ContrastDictIndex"," "_ExamName,ContrastType,ExamID)))  s MappingFlag=1
		
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
		}else{
			s obj.QuoteFlag=##class(web.CDSS.CMKB.ExamDictDetail).RemoveQuoteFlag(QuoteFlag,"M")	
		}
		
		s QuoteFlag = obj.QuoteFlag
		s Exist =##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.CDSS.CMKB.RuleTrigger")
		if (Exist="1"){
			;R（Rule） 被规则知识库引用
			s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("检查",ExamName) //被诊疗规则引用判断
			s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("检查",ExamName) //被诊疗子规则引用判断
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
			}else{
				s obj.QuoteFlag=##class(web.CDSS.CMKB.ExamDictDetail).RemoveQuoteFlag(QuoteFlag,"R")	
			}
			
			s QuoteFlag = obj.QuoteFlag
		}
		;W（Warning）被预警规则库引用
		s WarningFlag=0
		
		s Flag =##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("检查",ExamName,ExamID) //被预警规则库（检查合理性）引用判断
		
		s WarningFlag=$p(Flag,"^",2)
		
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
			s obj.QuoteFlag=##class(web.CDSS.CMKB.ExamDictDetail).RemoveQuoteFlag(QuoteFlag,"W")	
		}
		
		s sc=obj.%Save()
		
		d obj.%Close()	
	}
	q "检查数据处理完成！"
}

/// Creator:丁亚男
/// CreatDate:2021-09-01
/// Description：导入检查数据
/// Table：CT.WDT.CDSS.ExamDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.ExamDictDetail).ImportExamData()
ClassMethod ImportExamData()
{
	
	s acount =0,dcount=0,Aliascount=0,ucount=0
	s file=##class(%File).%New("F:\基础数据平台文档\CDSS\检查字典数据梳理结果-0831.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s ExamName=$p(Line,",",2)
		s ExamName=$tr(ExamName,"&",",")
		s Operation=$p(Line,",",3)
		s Remark=$p(Line,",",4)
		s Remark=$tr(Remark,"&",",")
		if (Operation="新增")
		{
			s Erowid=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ExamName,"U"),0))
			if (Erowid="")
			{
				s obj=##class(CT.WDT.CDSS.ExamDict).%New() 
				s obj.ExamName=ExamName
				s obj.ExamCode=##class(web.CDSS.CMKB.ExamDictDetail).GetCode()
				s obj.ExamNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ExamName) 
				s obj.ExamNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(ExamName,3)
				s obj.Alias=Remark
				s obj.CreateDate=$ZDATETIME($NOW(),3,1,3)
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					Tc
					s acount =acount+1
				}
				else
				{
					Tro
					w !, ExamName_"新增失败"
				}
			}	
		}
		elseif (Operation="删除")
		{
			s Erowid=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ExamName,"U"),0))
			if (Erowid'="")
			{
				s result=##class(web.CDSS.CMKB.ExamDictDetail).DeleteData(Erowid)
				if (result["true")
				{
					s dcount=dcount+1
				}
				else
				{
					w !, ExamName_"删除失败"	
				}
			}
		}
		elseif (Operation="别名")
		{
			s Erowid=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ExamName,"U"),0))
			if (Erowid'="")
			{
				s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(Erowid)
				s obj.Alias=Remark
				
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					Tc
					set Aliascount=Aliascount+1
				}
				else
				{
					w !, ExamName_"别名修改失败"
				}
			}
			else
			{
				w !, ExamName_"别名修改失败"
			}
		}
		elseif (Operation="修改名称")
		{
			s Erowid=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ExamName,"U"),0))
			if (Erowid'="")
			{
				s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(Erowid)
				s obj.ExamName=Remark
				
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					Tc
					set ucount=ucount+1
				}
				else
				{
					w !, ExamName_"名称修改失败"
				}
			}
			else
			{
				w !, ExamName_"名称修改失败"
			}
		}		
	}
	q "新增"_acount_"条！删除"_dcount_"条！修改别名"_Aliascount_"条！修改名称"_ucount_"条！"
}

/// Creator:丁亚男
/// CreatDate:2020-09-27
/// Description：删除检查数据
/// Table：CT.WDT.CDSS.ExamDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.ExamDictDetail).DeleteExamData()
ClassMethod DeleteExamData()
{
	
	s result ="" 
	s file=##class(%File).%New("F:\基础数据平台文档\CDSS\老库剔除数据检查20200929.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s ExamName=$p(Line,",",1)
		s ExamName=$tr(ExamName,"&",",")
		s rowid=""
		if ExamName'="" s rowid=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ExamName,"U"),0))
		if (rowid'="")
		{
			s result=##class(web.CDSS.CMKB.ExamDictDetail).DeleteData(rowid)
			if (result["false") w !,"删除"_ExamName_"失败"
		}
		else
		{
			w !,"删除"_ExamName_"失败"
		}
			
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-11-30
/// Description：导出检查字典表数据
/// Other:w ##class(web.CDSS.CMKB.ExamDictDetail).ExportExamData("","","","","","","","")
ClassMethod ExportExamData(code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String)
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检查字典数据.txt"		
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
	w "检查编码	检查名称	别名	引用标志	备注	操作时间	操作人员	状态"
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写 
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写 
	
	s ExamRowId=""
	for
	{ 
		s ExamRowId=$o(^CT.WDT.CDSS.ExamDictD(ExamRowId),-1) q:ExamRowId="" 
		s ExamCode=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),3)
		continue:((code'="")&&($ZCONVERT(ExamCode,"U")'[code))
		//s ExamCode=$tr(ExamCode,",","，")
		s ExamName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),4)
		continue:((desc'="")&&($ZCONVERT(ExamName,"U")'[desc))
		//s ExamName=$tr(ExamName,",","，")
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),19)
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s QuoteFlag=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),20) //引用标志
	 	continue:(QuoteFlag'[quoteflag)
	 	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	 	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),21)	//知识数量
	 	s:KnowledgeTotal="" KnowledgeTotal=0
	 	
	 	s CreateDate=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),22)	//创建时间
	 	continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
        
		s CreateUserID=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),23)	//创建人员
		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
		s Alias=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),24)	//别名
		continue:((aliasname'="")&&($ZCONVERT(Alias,"U")'[aliasname))
		s UseFlag=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),25)	//状态
		continue:((state'="")&&(UseFlag'=state))
		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
			
		w !,ExamCode_"	"_ExamName_"	"_Alias_"	"_QuoteFlag_"	"_Remarks_"	"_CreateDate_"	"_CreateUserID_"	"_UseFlag
			
	}
	c file
	q fileName
}

/// Creator：高姗姗
/// CreatDate: 2021-01-26
/// Description:状态修改
/// Input:id useflag(0编辑中,1已删除,2已审核)
/// Table：CT.WDT.CDSS.ExamDict
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).UpdateUseFlag(1,1)
ClassMethod UpdateUseFlag(RowId, Operation) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.ExamDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.ExamDict).%New()
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
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("检查",obj.ExamCode_"[A]"_obj.ExamName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){ 
            s lineI=obj.ExamName_",识别条件,主要条件-识别词,1,检查项目名称,"_obj.ExamName_",0"
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ExamDict","CT.WDT.CDSS.ExamDict","检查字典",RowId,obj.ExamName_"&&"_Operation,"U",eobj,bobj)	
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
/// Table: CT.WDT.CDSS.ExamDict
/// Input: id-检查表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ExamDictDetail","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s ExamAlias = $lg($g(^CT.WDT.CDSS.ExamDictD(id)),24)
		s Len=$Length(ExamAlias,",")
		for i=1:1:Len{
			s Desc=$p(ExamAlias,",",i)
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

/// Creator：xuwenhu
/// CreatDate: 2021-05-07
/// Description: 批量处理数据，将代码更改为纯数字递增
/// Input:
/// Table：CT.WDT.CDSS.ExamDict
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).BatchChangeCode()
ClassMethod BatchChangeCode() As %String
{
	s ID=0
	s code=0
	s count=0 		//总处理数
	s failcount=0	//失败数
	for
	{
		s ID=$o(^CT.WDT.CDSS.ExamDictD(ID))
		q:ID=""
		s code=code+1
		s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(ID)
		s OldCode=obj.ExamCode													//旧代码
		
		s obj.ExamCode=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(code,5)		//新代码
		s sc=obj.%Save()
		d obj.%Close()
		TS
		If $$$ISOK(sc)
		{
			tc
			s count=count+1
			
			//调用字典对照接口
			d ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检查", OldCode_"[A]"_obj.ExamName,obj.ExamCode_"[A]"_obj.ExamName)
		}
		else{
			tro
			s failcount=failcount+1
		}
	}
	q "总处理"_count_"条,失败"_failcount_"条"
}

/// Creator:xuwenhu
/// CreatDate:2021-5-12
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.ExamDictDetail).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	//s ExamID=0
	
	s Code=$o(^CT.WDT.CDSS.ExamDictD(""),-1)
	
	if (Code="")
	{
		s:Code="" Code="00001"
	}
	else
	{
		s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code+1,5)	//补0
		//s Code="PE"_Code
	}
  
	q Code
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量通过
/// Table: CT.WDT.CDSS.ExamDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).ChangeStatusPass("")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..UpdateUseFlag(id,"通过")

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
/// Table: CT.WDT.CDSS.ExamDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).ChangeStatusBack("")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..UpdateUseFlag(id,"驳回")
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
/// CreatDate: 2022-01-12
/// Description：检查字典别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.ExamDict
/// Other: d ##class(web.CDSS.CMKB.ExamDictDetail).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.ExamDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.ExamDictD(RowId)),24)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.ExamDict",RowId,Alias)
		}	 	
	}
	q ""
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.ExamDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.ExamDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.ExamDictD(RowId)),25)       
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
/// Table：CT.WDT.CDSS.ExamDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.ExamDictDetail).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.ExamDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 	
		
		s flag=..FormValidate(eobj.ExamRowId,eobj.ExamCode,eobj.ExamName) //校验重复
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ExamRowId,eobj.ExamName,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ExamRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.ExamDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(eobj.ExamRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.ExamDict).%New()
			s bobj.ExamCode = obj.ExamCode  
			s bobj.ExamName = obj.ExamName 
			s bobj.Alias = obj.Alias
			
			s bobj.CreateDate=obj.CreateDate		//创建时间
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			
		}
		s obj.ExamCode = eobj.ExamCode  
		s obj.ExamName = eobj.ExamName 
		s obj.Alias = eobj.Alias
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
			d:eobj.ExamRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ExamDict","CT.WDT.CDSS.ExamDict","检查字典",id,eobj.ExamName,"A",eobj)
			d:eobj.ExamRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ExamDict","CT.WDT.CDSS.ExamDict","检查字典",eobj.ExamRowId,eobj.ExamName,"U",eobj,bobj)
			
			//[新]检查百科增加一条同名数据   2021-11-25
			d:eobj.ExamRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("检查",eobj.ExamName,"")
			d:eobj.ExamRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("检查",eobj.ExamName,bobj.ExamName)
			
			//调用字典对照接口
			d:eobj.ExamRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检查", bobj.ExamCode_"[A]"_bobj.ExamName,eobj.ExamCode_"[A]"_eobj.ExamName)
			
			//同步修改识别词项目数据    2021-11-25
			d:eobj.ExamRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("检查项目名称",eobj.ExamName,bobj.ExamName)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表 2022-01-12
            if ((eobj.ExamRowId="")&&(eobj.Alias'=""))||((eobj.ExamRowId'="")&&(eobj.Alias'=bobj.Alias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.ExamDict",id,eobj.Alias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检查字典","web.CDSS.CMKB.ExamDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检查字典","web.CDSS.CMKB.ExamDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回文献表的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ExamDictDetail","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.ExamDict",RowId,LogID),-1) q:LogID=""
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
/// Description：转存检查字典数据到检查百科【百科中不存在的数据】
/// Table： CT.WDT.CDSS.ExamDict	检查字典
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.ExamDictDetail).TransferSaveData()
ClassMethod TransferSaveData() As %String
{
	s count=0
	s ExamRowId=""
	for
	{ 
		s ExamRowId=$o(^CT.WDT.CDSS.ExamDictD(ExamRowId),-1) q:ExamRowId="" 
		
		s ExamName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),4)
		s UseFlag=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),25)	//状态
		continue:(UseFlag=1)	//过滤已弃用数据
		s BaseDR=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_"检查",0))
		if (BaseDR'="")
		{
			//如果百科中不存在，调用接口保存
			if ('$d(^CT.WDT.CDSS.TermI("DescIndex",BaseDR," "_($ZCONVERT(ExamName,"U")))))	
			{
				d ##class(web.CDSS.CMKB.Term).SaveTerm("检查",ExamName,"")
				s count=count+1
			}	
		}
	}
	//w "共检测到"_count_"条数据。"
	w "处理完成,共处理"_count_"条数据。"
}

/// Creator：赵文伟 
/// CreatDate: 2023-03-06
/// Description：字典导入新增的别名数据【遍历判断如果表中已存在当前别名不新增，不存在追加在后面】,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table: 检查字典
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).ImportAliasData("D:\ZWW\检查新增别名.txt")
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
		
		s ExamName=$p(data,$c(9),1)	//名称
		s Alias=$p(data,$c(9),2)		//别名
		s flag=0
		s RowId=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ExamName,"U"),0))
		TS
		if (RowId'=""){
		
			s obj=##class(CT.WDT.CDSS.ExamDict).%OpenId(RowId)
			s OldAlias=obj.Alias
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
				if (obj.Alias=""){
					s obj.Alias=Alias
				}else{
					s obj.Alias=obj.Alias_","_Alias
				}
				s sc= obj.%Save()
				
				if $$$ISOK(sc)
				{
					s id = obj.%Id()
					s result = "{success:'true'}"
					//同步保存别名到别名通用表
		            if (RowId'="")
		            {
		            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.ExamDict",id,obj.Alias)
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
				w !,ExamName_"^"_Alias_" 存在重复别名"
				TRO
			}
		}else{
			w !,ExamName_"不存在"
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

/// Creator:赵文伟
/// CreatDate:2023-03-30
/// Description：导出检验医嘱字典表重复的别名数据
/// Other:w ##class(web.CDSS.CMKB.ExamDictDetail).ExportRepeatAlisaData()
ClassMethod ExportRepeatAlisaData()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检查重复别名数据.txt"		
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
	w "存在重复的别名	对应的检查名称	对应重复数据名称"
	
	
	s ExamRowId=""
	for
	{
		s ExamRowId=$o(^CT.WDT.CDSS.ExamDictD(ExamRowId),-1) q:ExamRowId="" 
		s ExamCode=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),3)
		s ExamName=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(ExamRowId)),4)
		s Alias=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamRowId)),24)	//别名
		
        
		s flag=0
		s len = $l(Alias,",")
		for i=1:1:len
		{
			s OneAlias=$p(Alias,",",i)
			if (OneAlias'=""){
				s AliasId=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.ExamDict",OneAlias,ExamRowId,0))
			
				
				s flagN=""
				for {
					
					s flagN=$o(^CT.WDT.CDSS.ExamDictI("DescIndex"," "_$ZCONVERT(OneAlias,"U"),flagN))
					q:flagN=""
					if ((flagN'="")&&(flagN'=ExamRowId)){	//当前别名与名称重复
						s Name=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(flagN)),4)
						w !,OneAlias_"	"_ExamName_"	"_Name
					}
				}
				s flagA=""
				for {
					s flagA=$o(^CT.WDT.CDSS.AliasI("TableAliasIndex","CT.WDT.CDSS.ExamDict",OneAlias,flagA))	
					q:flagA=""
					if ((flagA'="")&&(flagA'=AliasId)){	//当前别名与其他别名重复
						s DataReference=$lg($g(^CT.WDT.CDSS.AliasD(flagA)),4)
						s Name=$LISTGET($G(^CT.WDT.CDSS.ExamDictD(DataReference)),4)
						w !,OneAlias_"	"_ExamName_"	"_Name
					}
				}
			}
		}
	}
	c file
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2023-05-19
/// Description：批量删除已弃用数据[未被引用或只被字典对照引用]
/// Table: CT.WDT.CDSS.ExamDict
/// Other: w ##class(web.CDSS.CMKB.ExamDictDetail).DeleteDeprecatedData() 
ClassMethod DeleteDeprecatedData() As %String
{
	s count=0
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.ExamDictD(RowId),-1) q:RowId="" 
		s Name = $LISTGET($G(^CT.WDT.CDSS.ExamDictD(RowId)),4)
		s UseFlag = $lg($g(^CT.WDT.CDSS.ExamDictD(RowId)),25)
		if (UseFlag=1){
			s quoteInfo=..GetRefFlag(RowId)
			if '((quoteInfo["诊疗规则关联触发条件表")||(quoteInfo["规则管理")||(quoteInfo["识别词规则")){
				
				d ##class(web.CDSS.CMKB.ExamDictDetail).DeleteData(RowId)
				w Name_"已删除",!
				s count=count+1
			}
		}
	}
	q "success,已删除"_count_"条数据！"
}

}

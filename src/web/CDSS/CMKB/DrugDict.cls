/// Description：药物字典表 
/// Table：CT.WDT.CDSS.DrugDict
Class web.CDSS.CMKB.DrugDict Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-06-05
/// Description：查询 药物
/// Table：CT.WDT.CDSS.DrugDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DrugDict","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String, category As %String = "") As %Query(ROWSPEC = "DrugID:%String,DrugName:%String,DrugCategory:%String,DrugDictDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String, category As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s DrugID=rowid
  		s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugID)),4)
  		s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),26)	//药物类
  		s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),25)	//别名
  		d OutputRowCmb
 	}
 	else
 	{
	 	if (desc="") s desc=q
  		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  		
  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DrugDictD(ID))
			q:ID=""
			s DrugName=$lg($g(^CT.WDT.CDSS.DrugDictD(ID)),4)		//名称
			s length=$l(DrugName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s DrugID=0
			for
			{
				s DrugID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DrugID))
				q:DrugID=""
				s DrugDictDR=DrugID
				//s DrugDictDR=$o(^CT.WDT.CDSS.DrugDictD(DrugDictDR),-1) q:DrugDictDR=""  
  				s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugID)),4)
  				s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),26)	//药物类
  				s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),25)	//别名
  				s PINYIN=""
  				s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DrugName)  
  				s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),30)	//状态
  					
  				if (($ZCONVERT(DrugName,"U")[desc)||(PINYIN[desc)||($ZCONVERT(DrugAlias,"U")[desc)&(($ZCONVERT(DrugCategory,"U")[category))&(MaintainFlag="2")) {
  					d OutputRowCmb
  				}  		
  				continue:((desc'="")||(category'=""))		
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DrugID,DrugName,DrugCategory,DrugDictDR)
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

/// Creator：ZWW
/// CreatDate: 2022-09-15
/// Description：查询药物字典
/// Table：CT.WDT.CDSS.DrugDict
/// Input：rowid,code,desc,chemicalname,tradename, quoteflag,state,aliasname,approvalflag,drugtype,drugcategory,drugcomposition,opername,starttime,endtime,remarks,sortmethod 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DrugDict","GetList","","","","","","","1","","","","","","","","","Short")
Query GetList(rowid As %String, code As %String, desc As %String, chemicalname As %String, tradename As %String, quoteflag As %String, state As %String, aliasname As %String, approvalflag As %String, drugtype As %String, drugcategory As %String, drugcomposition As %String, opername As %String, timescope As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "DrugRowId,DrugNationCode,DrugCode,DrugName,DrugNamePinyin,DrugNameFirstPinyin,DrugEnglishName,DrugFirstClass,DrugSecondClass,DrugClass,DrugOverview,IndicationOverview,DosageOverview,AdverseReactions,Contraindications,DrugAccessories,DrugApplication,DrugInteraction,DrugOverdose,Remarks,QuoteFlag,KnowledgeTotal,ApprovalFlag,DrugType,DrugAlias,DrugCategory,DrugChemicalName,DrugComposition,DrugTradeName,MaintainFlag,CreateDate,CreateUserID")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, chemicalname As %String, tradename As %String, quoteflag As %String, state As %String, aliasname As %String, approvalflag As %String, drugtype As %String, drugcategory As %String, drugcomposition As %String, opername As %String, timescope As %String, remarks As %String, sortmethod As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s DrugRowId=rowid
	s DrugNationCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),2)	//国家（国际）编码
	s DrugCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),3)		//公司编码
	s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),4)		//通用名（中文名）
	s DrugNamePinyin=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),5)		//汉语拼音
	s DrugNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),6)	//汉语首拼
	s DrugEnglishName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),7)		//英文名
	
	s DrugFirstClassF=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),8)		//药物一级分类编码
	s DrugFirstClass=""
	s:DrugFirstClassF'="" DrugFirstClass=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugFirstClassF)),4)
	s DrugSecondClassF=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),9)		//药物二级分类编码
	s DrugSecondClass=""
	s:DrugSecondClassF'="" DrugSecondClass=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugSecondClassF)),4)
	s DrugClassF=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),10)		//药物三级分类编码
	s DrugClass=""
	s:DrugClassF'="" DrugClass=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugClassF)),4)
	
	s DrugOverview=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),11)	//药物概述
	s IndicationOverview=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),12)		//适应症概述
	s DosageOverview=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),13)		//用法用量概述
	s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),14)	//不良反应概述
	s Contraindications=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),15)	//禁忌症概述
	s DrugAccessories=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),16)		//辅料信息概述
	s DrugApplication=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),17)		//适用情况概述

	s DrugInteraction=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),18)		//相互作用概述
	s DrugOverdose=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),19)		//药物过量概述
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),20)		//备注
	s QuoteFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),21) //引用标志
	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),22)	//知识数量
	
	s ApprovalFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),23)	//药监局报批
	s DrugType=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),24)	//剂型
	s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),25)	//别名
	s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),26)	//药物类
	s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),27)	//化学名
	s DrugComposition=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),28)	//成分
	s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),29)	//商品名
	s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),30)	//状态
	s:MaintainFlag="" MaintainFlag=0
	s CreateDate=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),31)	//创建时间
	s CreateUserID=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),32)	//创建人员
	
	d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:chemicalname'="" chemicalname=$ZCONVERT(chemicalname,"U") //转换成大写 
	s:tradename'="" tradename=$ZCONVERT(tradename,"U") //转换成大写 
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写 
	s:drugcomposition'="" drugcomposition=$ZCONVERT(drugcomposition,"U") //转换成大写 
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写 
	//默认时间倒序输出
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DrugDictD(ID))
			q:ID=""
			s DrugName=$lg($g(^CT.WDT.CDSS.DrugDictD(ID)),4)		//名称
			s length=$l(DrugName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else 
	{
		s ID=""
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DrugDictD(ID))
			q:ID=""
			s CreateDate= $lg($g(^CT.WDT.CDSS.DrugDictD(ID)),31)				//编辑时间
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
		s DrugRowId=0
		for
		{
	        s DrugRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,DrugRowId)) q:DrugRowId=""
			s DrugNationCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),2)	//国家（国际）编码
			s DrugCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),3)		//公司编码
			s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),4)		//通用名（中文名）
			s DrugNamePinyin=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),5)		//汉语拼音
			s DrugNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),6)	//汉语首拼
			s DrugEnglishName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),7)		//英文名
			s DrugFirstClassF=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),8)		//药物一级分类编码
			s DrugFirstClass=""
			s:DrugFirstClassF'="" DrugFirstClass=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugFirstClassF)),4)

			s DrugSecondClassF=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),9)		//药物二级分类编码
			s DrugSecondClass=""
			s:DrugSecondClassF'="" DrugSecondClass=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugSecondClassF)),4)
			s DrugClassF=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),10)		//药物三级分类编码
			s DrugClass=""
			s:DrugClassF'="" DrugClass=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugClassF)),4)

			s DrugOverview=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),11)	//药物概述
			s IndicationOverview=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),12)		//适应症概述
			s DosageOverview=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),13)		//用法用量概述
			s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),14)	//不良反应概述

			s Contraindications=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),15)	//禁忌症概述
			s DrugAccessories=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),16)		//辅料信息概述
			s DrugApplication=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),17)		//适用情况概述
			s DrugInteraction=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),18)		//相互作用概述
			s DrugOverdose=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),19)		//药物过量概述
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),20)		//备注
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
			s QuoteFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),21) //引用标志
			continue:(QuoteFlag'[quoteflag)
			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
			s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),22)	//知识数量
			
			s ApprovalFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),23)	//药监局报批
			continue:((approvalflag'="")&&(ApprovalFlag'=approvalflag))
			s DrugType=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),24)	//剂型
			continue:((drugtype'="")&&(DrugType'=drugtype))
			s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),25)	//别名
			continue:((aliasname'="")&&($ZCONVERT(DrugAlias,"U")'[aliasname))
			s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),26)	//药物类
			continue:((drugcategory'="")&&(DrugCategory'=drugcategory))
			s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),27)	//化学名
			continue:(chemicalname'="")&&($ZCONVERT(DrugChemicalName,"U")'[chemicalname)
			s DrugComposition=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),28)	//成分
			continue:(drugcomposition'="")&&($ZCONVERT(DrugComposition,"U")'[drugcomposition)
			s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),29)	//商品名
			continue:(tradename'="")&&($ZCONVERT(DrugTradeName,"U")'[tradename)
			s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),30)	//状态
			s:MaintainFlag="" MaintainFlag=0
			if (state="")
			{
				continue:(MaintainFlag="1")	
			}else{
				continue:(MaintainFlag'=state)
			}
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			s CreateDate=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),31)	//创建时间
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
			s CreateUserID=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),32)	//创建人员
			continue:(opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername)

			if (($ZCONVERT(DrugName,"U")[desc)||($ZCONVERT(DrugNamePinyin,"U")[desc)||($ZCONVERT(DrugNameFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(DrugCode,"U")[code)
			{
				d OutputRow
			}
		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(DrugRowId,DrugNationCode,DrugCode,DrugName,DrugNamePinyin,DrugNameFirstPinyin,DrugEnglishName,DrugFirstClass,DrugSecondClass,DrugClass,DrugOverview,IndicationOverview,DosageOverview,AdverseReactions,Contraindications,DrugAccessories,DrugApplication,DrugInteraction,DrugOverdose,Remarks,QuoteFlag,KnowledgeTotal,ApprovalFlag,DrugType,DrugAlias,DrugCategory,DrugChemicalName,DrugComposition,DrugTradeName,MaintainFlag,CreateDate,CreateUserID)
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
/// Other:w ##class(web.CDSS.CMKB.DrugDict).GetQuoteFlag("D,K,R")
ClassMethod GetQuoteFlag(QuoteFlag)
{
	/// 引用标志  K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照 ;W（Warning）被预警规则库引用
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
			else		//前面数据不为空
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
/// CreatDate:2020-7-29
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.DrugDict
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.DrugDict).FormValidate("","1111","1111","100.01")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	
	s flag=0
	if ($ZCONVERT(code,"U")'="")	//校验代码重复
    {
        s idc=0
        for
        {
            s idc=$o(^CT.WDT.CDSS.DrugDictI("CodeIndex"," "_$ZCONVERT(code,"U"),idc)) q:idc=""
            if (idc'=id)	//重复
            {
				s flag=1
            }
        }
    }
    if ($ZCONVERT(desc,"U")'="")	//校验描述重复
    {
        s idd=0
        for
        {
            s idd=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(desc,"U"),idd)) q:idd=""
            if (idd'=id)	//重复
            {
				s flag=1
            }
        }
    }
    q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.DrugDict).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DrugDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.DrugDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DrugDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.DrugDictI("NameIndex",Alias,0))  //字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator：钟荣枫
/// CreatDate: 2020-07-4
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.DrugDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.DrugDict).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DrugDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s:eobj.MaintainFlag="" eobj.MaintainFlag=0
		s flag=..FormValidate(eobj.DrugRowId,eobj.DrugCode,eobj.DrugName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.DrugRowId,eobj.DrugName,eobj.DrugAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.DrugRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.DrugDict).%New() 
		}
		
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(eobj.DrugRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
			
			s bobj.DrugNationCode=obj.DrugNationCode		//国家（国际）编码
			s bobj.DrugCode=obj.DrugCode					//公司编码
			s bobj.DrugName=obj.DrugName					//通用名（中文名）
			s bobj.DrugNamePinyin=obj.DrugNamePinyin		//汉语拼音
			s bobj.DrugNameFirstPinyin=obj.DrugNameFirstPinyin	//汉语首拼
			s bobj.DrugEnglishName=obj.DrugEnglishName		//英文名
			s bobj.DrugFirstClass=obj.DrugFirstClass 		//药物一级分类编码
			s bobj.DrugSecondClass=obj.DrugSecondClass		//药物一级分类编码
			s bobj.DrugClass=obj.DrugClass					//药物二级分类编码
			s bobj.DrugOverview=obj.DrugOverview			//药物概述
			s bobj.IndicationOverview=obj.IndicationOverview		//适应症概述
			s bobj.DosageOverview=obj.DosageOverview		//用法用量概述
			s bobj.AdverseReactions=obj.AdverseReactions	//不良反应概述
			
			s bobj.Contraindications=obj.Contraindications	//禁忌症概述
			s bobj.DrugAccessories=obj.DrugAccessories		//辅料信息概述
			s bobj.DrugApplication=obj.DrugApplication		//适用情况概述
			s bobj.DrugInteraction=obj.DrugInteraction		//相互作用概述
			s bobj.DrugOverdose=obj.DrugOverdose			//药物过量概述
			s bobj.Remarks=obj.Remarks						//备注
			s bobj.QuoteFlag=obj.QuoteFlag 					//引用标志
			s bobj.KnowledgeTotal=obj.KnowledgeTotal		//知识数量
			
			s bobj.ApprovalFlag=obj.ApprovalFlag			//药监局报批
			s bobj.DrugType=obj.DrugType					//剂型
			s bobj.DrugAlias=obj.DrugAlias					//别名
			s bobj.DrugCategory=obj.DrugCategory			//药物类
			s bobj.DrugChemicalName=obj.DrugChemicalName	//化学名
			s bobj.DrugComposition=obj.DrugComposition		//成分
			s bobj.DrugTradeName=obj.DrugTradeName			//商品名
			s bobj.MaintainFlag=obj.MaintainFlag			//状态
			s bobj.CreateDate=obj.CreateDate				//创建时间
			s bobj.CreateUserID=obj.CreateUserID			//创建人员
			
		}
		s obj.DrugNationCode=eobj.DrugNationCode		//国家（国际）编码
		s obj.DrugCode=eobj.DrugCode					//公司编码
		s obj.DrugName=eobj.DrugName					//通用名（中文名）
		s obj.DrugNamePinyin=eobj.DrugNamePinyin		//汉语拼音
		s obj.DrugNameFirstPinyin=eobj.DrugNameFirstPinyin	//汉语首拼
		s obj.DrugEnglishName=eobj.DrugEnglishName		//英文名
		s obj.DrugFirstClass=eobj.DrugFirstClass		//药物一级分类编码
		s obj.DrugSecondClass=eobj.DrugSecondClass 		//药物二级分类编码
		s obj.DrugClass=eobj.DrugClass					//药物三级分类编码
		s obj.DrugOverview=eobj.DrugOverview			//药物概述
		s obj.IndicationOverview=eobj.IndicationOverview		//适应症概述
		s obj.DosageOverview=eobj.DosageOverview		//用法用量概述
		s obj.AdverseReactions=eobj.AdverseReactions	//不良反应概述
		
		s obj.Contraindications=eobj.Contraindications	//禁忌症概述
		s obj.DrugAccessories=eobj.DrugAccessories		//辅料信息概述
		s obj.DrugApplication=eobj.DrugApplication		//适用情况概述
		s obj.DrugInteraction=eobj.DrugInteraction		//相互作用概述
		s obj.DrugOverdose=eobj.DrugOverdose			//药物过量概述
		s obj.Remarks=eobj.Remarks						//备注
		s obj.QuoteFlag=eobj.QuoteFlag 					//引用标志
		s obj.KnowledgeTotal=eobj.KnowledgeTotal		//知识数量
		
		s obj.ApprovalFlag=eobj.ApprovalFlag			//药监局报批
		s obj.DrugType=eobj.DrugType					//剂型
		s obj.DrugAlias=eobj.DrugAlias					//别名
		s obj.DrugCategory=eobj.DrugCategory			//药物类
		s obj.DrugChemicalName=eobj.DrugChemicalName	//化学名
		s obj.DrugComposition=eobj.DrugComposition		//成分
		s obj.DrugTradeName=eobj.DrugTradeName			//商品名
		s obj.MaintainFlag=eobj.MaintainFlag			//状态
		
		s obj.CreateDate=eobj.CreateDate				//创建时间
		s obj.CreateUserID=eobj.CreateUserID			//创建人员
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.DrugRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DrugDict","CT.WDT.CDSS.DrugDict","药物字典",id,eobj.DrugName,"A",eobj)
			d:eobj.DrugRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DrugDict","CT.WDT.CDSS.DrugDict","药物字典",eobj.DrugRowId,eobj.DrugName,"U",eobj,bobj)
			//同步修改对照数据
			d:eobj.DrugRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("药品",bobj.DrugCode_"[A]"_bobj.DrugName,eobj.DrugCode_"[A]"_eobj.DrugName)
			//同步修改识别词项目数据    2021-11-25
			d:eobj.DrugRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("药品名称",eobj.DrugName,bobj.DrugName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.DrugRowId="")&&(eobj.DrugAlias'=""))||((eobj.DrugRowId'="")&&(eobj.DrugAlias'=bobj.DrugAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DrugDict",id,eobj.DrugAlias)
            }
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物字典","web.CDSS.CMKB.DrugDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物字典","web.CDSS.CMKB.DrugDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：钟荣枫
/// CreatDate: 2020-07-4
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.DrugDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.DrugDict).OpenData("16922")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
	
	s bobj.DrugNationCode=obj.DrugNationCode	//国家（国际）编码
	s bobj.DrugCode=obj.DrugCode		//公司编码
	s bobj.DrugName=obj.DrugName		//通用名（中文名）
	s bobj.DrugNamePinyin=obj.DrugNamePinyin		//汉语拼音
	s bobj.DrugNameFirstPinyin=obj.DrugNameFirstPinyin	//汉语首拼
	s bobj.DrugEnglishName=obj.DrugEnglishName		//英文名
	
	s:obj.DrugFirstClass'="" bobj.DrugFirstClass=obj.DrugFirstClass.%Id()		//药物一级分类编码
	s:obj.DrugSecondClass'="" bobj.DrugSecondClass=obj.DrugSecondClass.%Id()		//药物一级分类编码
	s:obj.DrugClass'="" bobj.DrugClass=obj.DrugClass.%Id()		//药物二级分类编码
	s bobj.DrugOverview=obj.DrugOverview	//药物概述
	s bobj.IndicationOverview=obj.IndicationOverview		//适应症概述
	s bobj.DosageOverview=obj.DosageOverview		//用法用量概述
	s bobj.AdverseReactions=obj.AdverseReactions	//不良反应概述
	
	s bobj.Contraindications=obj.Contraindications	//禁忌症概述
	s bobj.DrugAccessories=obj.DrugAccessories		//辅料信息概述
	s bobj.DrugApplication=obj.DrugApplication	//适用情况概述
	s bobj.DrugInteraction=obj.DrugInteraction		//相互作用概述
	s bobj.DrugOverdose=obj.DrugOverdose		//药物过量概述
	s bobj.Remarks=obj.Remarks		//备注
	s bobj.QuoteFlag=obj.QuoteFlag //引用标志
	s bobj.KnowledgeTotal=obj.KnowledgeTotal	//知识数量
	
	s bobj.ApprovalFlag=obj.ApprovalFlag	//药监局报批
	s bobj.DrugType=obj.DrugType	//剂型
	s bobj.DrugAlias=obj.DrugAlias	//别名
	s bobj.DrugCategory=obj.DrugCategory	//药物类
	s bobj.DrugChemicalName=obj.DrugChemicalName	//化学名
	s bobj.DrugComposition=obj.DrugComposition	//成分
	s bobj.DrugTradeName=obj.DrugTradeName	//商品名
	s bobj.MaintainFlag=obj.MaintainFlag	//状态
	s:bobj.MaintainFlag="" bobj.MaintainFlag=0
	s bobj.CreateDate=obj.CreateDate	//创建时间
	s bobj.CreateUserID=obj.CreateUserID	//创建人员
		
	d obj.%Close()	
	k obj		
	s str = bobj.JsonS()	
	q str
}

/// Creator：钟荣枫
/// CreatDate: 2020-11-4
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.DrugDict).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{

	s return="",myInfo=""
	s DictDesc=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(id)),4)
	//诊疗规则引用接口 2023-02-28
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("药品",DictDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("药品",DictDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
	//识别词项目引用接口    2021-11-25
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("药物名称",DictDesc)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	//字典对照引用接口
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("药品",DictDesc)
	s myInfo=myInfo_Mappinginfo
	
	//规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("药品",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	//规则(处置明细)引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("药物",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用"
 	q return
}

/// Creator:钟荣枫
/// CreatDate:2020-07-4
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.DrugDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DrugDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
	
	s bobj.DrugNationCode=obj.DrugNationCode	//国家（国际）编码
	s bobj.DrugCode=obj.DrugCode		//公司编码
	s bobj.DrugName=obj.DrugName		//通用名（中文名）
	s bobj.DrugNamePinyin=obj.DrugNamePinyin		//汉语拼音
	s bobj.DrugNameFirstPinyin=obj.DrugNameFirstPinyin	//汉语首拼
	s bobj.DrugEnglishName=obj.DrugEnglishName		//英文名
	
	s bobj.DrugFirstClass=obj.DrugFirstClass		//药物一级分类编码
	s bobj.DrugSecondClass=obj.DrugSecondClass		//药物一级分类编码
	s bobj.DrugClass=obj.DrugClass		//药物二级分类编码
	s bobj.DrugOverview=obj.DrugOverview	//药物概述
	s bobj.IndicationOverview=obj.IndicationOverview		//适应症概述
	s bobj.DosageOverview=obj.DosageOverview		//用法用量概述
	s bobj.AdverseReactions=obj.AdverseReactions	//不良反应概述
	
	s bobj.Contraindications=obj.Contraindications	//禁忌症概述
	s bobj.DrugAccessories=obj.DrugAccessories		//辅料信息概述
	s bobj.DrugApplication=obj.DrugApplication	//适用情况概述
	s bobj.DrugInteraction=obj.DrugInteraction		//相互作用概述
	s bobj.DrugOverdose=obj.DrugOverdose		//药物过量概述
	s bobj.Remarks=obj.Remarks		//备注
	s bobj.QuoteFlag=obj.QuoteFlag //引用标志
	s bobj.KnowledgeTotal=obj.KnowledgeTotal	//知识数量
	
	s bobj.ApprovalFlag=obj.ApprovalFlag	//药监局报批
	s bobj.DrugType=obj.DrugType	//剂型
	s bobj.DrugAlias=obj.DrugAlias	//别名
	s bobj.DrugCategory=obj.DrugCategory	//药物类
	s bobj.DrugChemicalName=obj.DrugChemicalName	//化学名
	s bobj.DrugComposition=obj.DrugComposition	//成分
	s bobj.DrugTradeName=obj.DrugTradeName	//商品名
	s bobj.MaintainFlag=obj.MaintainFlag	//状态
	s bobj.CreateDate=obj.CreateDate	//创建时间
	s bobj.CreateUserID=obj.CreateUserID	//创建人员
	Ts
	//同步删除对照数据 
	s re =  ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("药品",obj.DrugCode_"[A]"_obj.DrugName)
	if (re="true[A]true"){
		s sc=##class(CT.WDT.CDSS.DrugDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DrugDict","CT.WDT.CDSS.DrugDict","药物字典",id,bobj.DrugName,"D",bobj)
			//同步删除别名通用表中数据 
	        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.DrugDict",id)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物字典","web.CDSS.CMKB.DrugDict","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	} else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	    }
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-8-27
/// Description：导入药物字典
/// Table:CT.WDT.CDSS.DrugDict 药物字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DrugDict).ImportDrugDada()
ClassMethod ImportDrugDada()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	s id=0
	
	//s file=##class(%File).%New(path)
	s file=##class(%File).%New("F:\基础数据平台文档\CDSS\药物字典新增数据.csv")
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s MaintainFlag=$p(str,",",5)	//状态
		s MaintainFlag=$case(MaintainFlag,"已审核":"1","编辑中":"0",:"0")	
		s DrugName=$p(str,",",2)	//通用名
		continue:DrugName=""
		s DrugCode=$o(^CT.WDT.CDSS.DrugDictD(""),-1)
		s DrugCode=$Zstrip(DrugCode,"<>W")
  		s DrugCode=$g(DrugCode)+1		//公司编码
		s ApprovalFlag=$p(str,",",3)		/// 药监局报批
		s ApprovalFlag=$case(ApprovalFlag,"是":"1","否":"0",:"0")
		s DrugType=$p(str,",",4)	//剂型
		s DrugAlias=$p(str,",",6)	//别名
		s:DrugAlias'="" DrugAlias=##class(web.BDP.util.String).Replace(DrugAlias," ",",")
		
		s DrugCategory=$p(str,",",7)	//药物类
		s DrugChemicalName=$p(str,",",8)	//化学名
		s DrugOverview=$p(str,",",9)	//说明
		s DrugComposition=$p(str,",",10)	//成分
		s:DrugComposition'="" DrugComposition=##class(web.BDP.util.String).Replace(DrugComposition," ",",")
		s DrugTradeName=$p(str,",",11)	//商品名
		s:DrugTradeName'="" DrugTradeName=##class(web.BDP.util.String).Replace(DrugTradeName," ",",")
		
		s DrugName=$Zstrip(DrugName,"<>W")
		s ApprovalFlag=$zstrip(ApprovalFlag,"<>W")
		s DrugType=$zstrip(DrugType,"<>W")
		s DrugAlias=$zstrip(DrugAlias,"<>W")
		s DrugCategory=$zstrip(DrugCategory,"<>W")
		s DrugChemicalName=$zstrip(DrugChemicalName,"<>W")
		s DrugOverview=$zstrip(DrugOverview,"<>W")
		s DrugComposition=$zstrip(DrugComposition,"<>W")
		s DrugTradeName=$zstrip(DrugTradeName,"<>W")
		
		s readcount=readcount+1
		s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugName,"U"),0))
		if (DrugID'="")	
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugID)
			s obj.DrugNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(DrugName,3,"")
			s obj.DrugNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(DrugName,4,"")
			s obj.DrugOverview=DrugOverview	//药物概述
			s obj.ApprovalFlag=ApprovalFlag	//药监局报批
			s obj.DrugType=DrugType	//剂型
			s obj.DrugAlias=DrugAlias	//别名
			s obj.DrugCategory=DrugCategory	//药物类
			s obj.DrugChemicalName=DrugChemicalName	//化学名
			s obj.DrugComposition=DrugComposition	//成分
			s obj.DrugTradeName=DrugTradeName	//商品名
			s obj.MaintainFlag=MaintainFlag	//状态
			s sc= obj.%Save()
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		}
		else
		{
			s eobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
			s eobj.DrugNationCode=DrugCode
			s eobj.DrugName=DrugName		//通用名（中文名）
			s eobj.DrugCode=DrugCode
			s eobj.DrugNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(DrugName,3,"")	//汉语拼音		
			s eobj.DrugNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DrugName)	//汉语首拼
			s eobj.DrugOverview=DrugOverview	//药物概述
			s eobj.ApprovalFlag=ApprovalFlag	//药监局报批
			s eobj.DrugType=DrugType	//剂型
			s eobj.DrugAlias=DrugAlias	//别名
			s eobj.DrugCategory=DrugCategory	//药物类
			s eobj.DrugChemicalName=DrugChemicalName	//化学名
			s eobj.DrugComposition=DrugComposition	//成分
			s eobj.DrugTradeName=DrugTradeName	//商品名
			s eobj.MaintainFlag=MaintainFlag	//状态

			s result=..SaveData(eobj)
		}	
		if (result["true")
		{
			s savecount=savecount+1
			if (DrugID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			s nosavecount=nosavecount+1
			
		}	
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	
	q "{success:'true'}"
}

/// Creator:钟荣枫
/// CreatDate:2020-10-23
/// Description:  部分数据的别名成分中前面多一个逗号，需要批量处理
/// Table: CT.WDT.CDSS.DrugDict
/// Input: id 
/// Return:"success"
/// others:w ##class(web.CDSS.CMKB.DrugDict).UpdateDrugData()
ClassMethod UpdateDrugData()
{
	s result=""
	s DrugRowId=""
	for
	{ 
		s DrugRowId=$o(^CT.WDT.CDSS.DrugDictD(DrugRowId),-1) q:DrugRowId=""
		s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),25)	//别名
		s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),27)	//化学名
		s DrugComposition=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),28)	//成分
		s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),29)	//商品名
		
		s newDrugAlias=DrugAlias
		s newDrugComposition=DrugComposition
		s newDrugTradeName=DrugTradeName
		if (($p(DrugAlias,",",1)="")&&(DrugAlias[","=1))	//存在",xx"的数据
		{
			s newDrugAlias=$p(DrugAlias,",",2)
		}
		if (($p(DrugComposition,",",1)="")&&(DrugComposition[","=1))	//存在",xx"的数据
		{
			s newDrugComposition=$p(DrugComposition,",",2)
		}
		s:DrugTradeName'="" DrugTradeName=##class(web.BDP.util.String).Replace(DrugTradeName," ",",")	
		if ((newDrugAlias'=DrugAlias)||(newDrugComposition'=DrugComposition)||(DrugTradeName'=newDrugTradeName))	//已修改
		{	
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugRowId)
			s obj.DrugAlias=newDrugAlias
			s obj.DrugComposition=newDrugComposition
			s obj.DrugTradeName=newDrugTradeName
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
			}
		}
	}
	q "success"
}

/// Creator：钟荣枫 
/// CreatDate: 2020-8-27
/// Description：给后一批导入的药品数据增加已审核状态
/// Table:CT.WDT.CDSS.DrugDict 药物字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DrugDict).AddState()
ClassMethod AddState()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	s id=0
	Ts
	//s file=##class(%File).%New(path)
	s file=##class(%File).%New("C:\Users\Administrator\Desktop\zrf\2020-8\药品.csv")
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s MaintainFlag=$p(str,",",5)	//状态
		continue:(MaintainFlag'="已审核")
		s MaintainFlag=$case(MaintainFlag,"已审核":"1","编辑中":"0",:"0")
		s DrugName=$p(str,",",2)	//通用名
		continue:DrugName=""
		
		s DrugName=$Zstrip(DrugName,"<>W")
		s readcount=readcount+1
		s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugName,"U"),0))
		if (DrugID'="")	
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugID)
			
			s obj.MaintainFlag=MaintainFlag	//状态
			s sc= obj.%Save()
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		}
		if ((result'["false"))
		{
			s savecount=savecount+1
			if (DrugID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			s nosavecount=nosavecount+1
		}	
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	
	q "{success:'true'}"
}

/// Creator:钟荣枫
/// CreatDate:2020-11-30
/// Description：导出药物字典表数据【停用】
/// Other:w ##class(web.CDSS.CMKB.DrugDict).ExportDrugData()
ClassMethod ExportDrugData()
{
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="药物字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("RowID,"_"药品编码,"_"药品通用名,"_"别名,"_"化学名,"_"商品名,"_"状态,"_"剂型,"_"操作时间,"_"操作人")
	d file.WriteLine()
	s DrugRowId=""
	for
	{ 
		s DrugRowId=$o(^CT.WDT.CDSS.DrugDictD(DrugRowId),-1) q:DrugRowId="" 
		
		s DrugCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),3)		//公司编码
		s DrugCode=$tr(DrugCode,",","，")
		s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),4)		//通用名（中文名）
		s DrugName=$tr(DrugName,",","，")
		s DrugType=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),24)	//剂型
		s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),25)	//别名
		s DrugAlias=$tr(DrugAlias,",","，")
		s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),27)	//化学名
		s DrugChemicalName=$tr(DrugChemicalName,",","，")
		s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),29)	//商品名
		s DrugTradeName=$tr(DrugTradeName,",","，")
		s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),30)	//状态
		s MaintainFlag=$case(MaintainFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中")
		s CreateDate=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),31)	//创建时间
		s CreateUserID=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),32)	//创建人员
		
		d file.Write(DrugRowId_",")
		d file.Write(DrugCode_",")
		d file.Write(DrugName_",")
		d file.Write(DrugAlias_",")
		d file.Write(DrugChemicalName_",")
		d file.Write(DrugTradeName_",")
		d file.Write(MaintainFlag_",")
		d file.Write(DrugType_",")
		d file.Write(CreateDate_",")
		d file.Write(CreateUserID)
		d file.WriteLine()
		
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:zww
/// CreatDate:2021-11-26
/// Input:RowId  Operation 操作
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DrugDict).ChangeStatus(182,"1")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
	
	s:Operation="通过" eobj.MaintainFlag="2"	//已审核
	s:Operation="弃用" eobj.MaintainFlag="1"	//已弃用
	s:Operation="恢复" eobj.MaintainFlag="0"	//编辑中
	s:Operation="驳回" eobj.MaintainFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
	s bobj.MaintainFlag=obj.MaintainFlag
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
	
	s obj.MaintainFlag=eobj.MaintainFlag
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
		if (obj.MaintainFlag="1")||(obj.MaintainFlag="0"){
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("药品",obj.DrugCode_"[A]"_obj.DrugName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.MaintainFlag= "2"){
            s lineI=obj.DrugName_",识别条件,主要条件-识别词,1,药物名称,"_obj.DrugName_",0"
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DrugDict","CT.WDT.CDSS.DrugDict","药物字典",RowId,obj.DrugName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-30
/// Description：导出药物字典表数据【暂不用】
/// Other:w ##class(web.CDSS.CMKB.DrugDict).ExportDrugData()
ClassMethod ExportDrugDataTXT()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"药物字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	o file:"NWS"
	u file
	w "RowID	药品编码	药品通用名	别名	化学名	商品名	状态	剂型	操作时间	操作人"
	//d file.WriteLine()
	s DrugRowId=""
	for
	{ 
		s DrugRowId=$o(^CT.WDT.CDSS.DrugDictD(DrugRowId),-1) q:DrugRowId="" 
		s DrugCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),3)		//公司编码
		s DrugCode=$tr(DrugCode,",","，")
		s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),4)		//通用名（中文名）
		s DrugName=$tr(DrugName,",","，")
		s DrugType=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),24)	//剂型
		s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),25)	//别名
		s DrugAlias=$tr(DrugAlias,",","，")
		s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),27)	//化学名
		s DrugChemicalName=$tr(DrugChemicalName,",","，")
		s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),29)	//商品名
		s DrugTradeName=$tr(DrugTradeName,",","，")
		s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),30)	//状态
		s MaintainFlag=$case(MaintainFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中")
		s CreateDate=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),31)	//创建时间
		s CreateUserID=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),32)	//创建人员
		
		/*d file.Write(DrugRowId_",")
		d file.Write(DrugCode_",")
		d file.Write(DrugName_",")
		d file.Write(DrugAlias_",")
		d file.Write(DrugChemicalName_",")
		d file.Write(DrugTradeName_",")
		d file.Write(MaintainFlag_",")
		d file.Write(DrugType_",")
		d file.Write(CreateDate_",")
		d file.Write(CreateUserID)
		d file.WriteLine()*/
		w !,DrugRowId_"	"_DrugCode_"	"_DrugName_"	"_DrugAlias_"	"_DrugChemicalName_"	"_DrugTradeName_"	"_MaintainFlag_"	"_DrugType_"	"_CreateDate_"	"_CreateUserID
		
	}
	c file
	//d file.%Save()
	//d file.%Close()
	q fileName
}

/// Creator:xuwenhu
/// CreatDate:2021-02-03
/// Description:导出药品字典表数据【在用】
/// Table:CT.WDT.CDSS.DrugDict
/// Input：code,desc,chemicalname,tradename, quoteflag,state,aliasname,approvalflag,drugtype,drugcategory,drugcomposition,opername,starttime,endtime,remarks,sortmethod 
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.DrugDict).ExportDrugTXTData("","","","","","","","","","","","","","","")
ClassMethod ExportDrugTXTData(code As %String, desc As %String, chemicalname As %String, tradename As %String, quoteflag As %String, state As %String, aliasname As %String, approvalflag As %String, drugtype As %String, drugcategory As %String, drugcomposition As %String, opername As %String, starttime As %String, endtime As %String, remarks As %String) As %String
{
	s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"药品字典数据.txt"		
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
	///药物通用名，别名化学名商品名药监局报批剂型药物类成分引用标志知识数量备注	
	///操作人操作时间状态
	w "药物编码	药物通用名	别名	主要成分	商品名	药监局报批	剂型	药物类	成分	引用标志	备注	操作人	操作时间	状态"
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:chemicalname'="" chemicalname=$ZCONVERT(chemicalname,"U") //转换成大写 
	s:tradename'="" tradename=$ZCONVERT(tradename,"U") //转换成大写 
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写 
	s:drugcomposition'="" drugcomposition=$ZCONVERT(drugcomposition,"U") //转换成大写 
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写 
	
	s DrugRowId=""
	for
	{ 	
		s DrugRowId=$o(^CT.WDT.CDSS.DrugDictD(DrugRowId),-1) q:DrugRowId=""	
			
		s DrugNationCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),2)	//国家（国际）编码
		s DrugCode=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),3)		//公司编码
		s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),4)		//通用名（中文名）
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugRowId)),20)		//备注
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s QuoteFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),21) //引用标志
		continue:(QuoteFlag'[quoteflag)
		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),22)	//知识数量
		
		s ApprovalFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),23)	//药监局报批
		continue:((approvalflag'="")&&(ApprovalFlag'=approvalflag))
		s ApprovalFlag=$case(ApprovalFlag,1:"是",0:"否",:"否")
		s DrugType=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),24)	//剂型
		continue:((drugtype'="")&&(DrugType'=drugtype))
		s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),25)	//别名
		continue:((aliasname'="")&&($ZCONVERT(DrugAlias,"U")'[aliasname))
		s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),26)	//药物类
		continue:((drugcategory'="")&&(DrugCategory'=drugcategory))
		s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),27)	//主要成分（化学名）
		continue:(chemicalname'="")&&($ZCONVERT(DrugChemicalName,"U")'[chemicalname)
		s DrugComposition=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),28)	//成分
		continue:(drugcomposition'="")&&($ZCONVERT(DrugComposition,"U")'[drugcomposition)
		s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),29)	//商品名
		continue:(tradename'="")&&($ZCONVERT(DrugTradeName,"U")'[tradename)
		s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),30)	//状态
		s:MaintainFlag="" MaintainFlag=0
		continue:((state'="")&&(MaintainFlag'=state))
		s MaintainFlag=$case(MaintainFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
        s CreateDate=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),31)	//创建时间
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),32)	//创建人员
		continue:(opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername)
		
		if (($ZCONVERT(DrugName,"U")[desc)||($ZCONVERT(DrugNamePinyin,"U")[desc)||($ZCONVERT(DrugNameFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(DrugCode,"U")[code)
		{
	 		//替换双引号
			/*s DrugCode=$replace(DrugCode,"""","”")
			s DrugName=$replace(DrugName,"""","”")
			
			//将英文逗号转换为中文逗号
			s DrugCode=$replace(DrugCode,",","，")
			s DrugName=$replace(DrugName,",","，")
			s CreateDate=$replace(CreateDate,"""","")
			s CreateUserID=$replace(CreateUserID,",","，")*/
			///药物编码,药物通用名,别名,化学名,商品名,药监局报批,剂型,药物类,成分,引用标志,知识数量,备注,操作人,操作时间,状态
			
			w !,DrugCode_"	"_DrugName_"	"_DrugAlias_"	"_DrugChemicalName_"	"_DrugTradeName_"	"_ApprovalFlag_"	"_DrugType_"	"_DrugCategory_"	"_DrugComposition_"	"_QuoteFlag_"	"_Remarks_"	"_CreateUserID_"	"_CreateDate_"	"_MaintainFlag
			
		}
	}
	c file
	
	q fileName
}

/// Creator:xuwenhu
/// CreatDate:2021-02-05
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.DrugDict
/// Input: id-药品表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DrugDict","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s DrugAlias = $lg($g(^CT.WDT.CDSS.DrugDictD(id)),25)
		s Len=$Length(DrugAlias,",")
		for i=1:1:Len{
			s Desc=$p(DrugAlias,",",i)
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

/// Creator:xuwenhu
/// CreatDate:2021-02-05
/// Description:获得商品名列表
/// Table: CT.WDT.CDSS.DrugDict
/// Input: id-药品表id
/// Return:返回商品名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DrugDict","GetDrugTradeList","2")
Query GetDrugTradeList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetDrugTradeListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s DrugTrade = $lg($g(^CT.WDT.CDSS.DrugDictD(id)),29)
		s Len=$Length(DrugTrade,",")
		for i=1:1:Len{
			s Desc=$p(DrugTrade,",",i)
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

ClassMethod GetDrugTradeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugTradeListExecute ]
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

ClassMethod GetDrugTradeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugTradeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:xuwenhu
/// CreatDate:2021-03-08
/// Description:获得药物类列表
/// Table: CT.WDT.CDSS.DrugDict
/// Input: id-药品表id
/// Return:返回商品名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DrugDict","GetDrugCategoryList","2")
Query GetDrugCategoryList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetDrugCategoryListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s DrugCategory = $lg($g(^CT.WDT.CDSS.DrugDictD(id)),26)
		s Len=$Length(DrugCategory,",")
		for i=1:1:Len{
			s Desc=$p(DrugCategory,",",i)
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

ClassMethod GetDrugCategoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugCategoryListExecute ]
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

ClassMethod GetDrugCategoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugCategoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:钟荣枫
/// CreatDate:2021-4-29
/// Description：处理由于前台中已审核状态为1，本应该是2，导致的保存的状态错误
/// Other:w ##class(web.CDSS.CMKB.DrugDict).Handele()
ClassMethod Handele()
{
	s result=""
	s errorflag=0
	ts
	s DrugRowId=""
	for
	{ 
		s DrugRowId=$o(^CT.WDT.CDSS.DrugDictD(DrugRowId),-1) q:DrugRowId="" 
		q:errorflag=1
		s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),30)	//状态
		s CreateUserID=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugRowId)),32)
		s State=""
		if (((MaintainFlag="")||(MaintainFlag=1))&&(CreateUserID'="dhcc"))	//改为已删除
		{
			s State="1"
		}
		if ((MaintainFlag=1)&&(State=""))	//改为已审核
		{
			s State="2"
			
		}
		if (State'="")
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
			s bobj.DrugRowId=DrugRowId
			
			s bobj.DrugNationCode=obj.DrugNationCode	//国家（国际）编码
			s bobj.DrugCode=obj.DrugCode		//公司编码
			s bobj.DrugName=obj.DrugName		//通用名（中文名）
			s bobj.DrugNamePinyin=obj.DrugNamePinyin		//汉语拼音
			s bobj.DrugNameFirstPinyin=obj.DrugNameFirstPinyin	//汉语首拼
			s bobj.DrugEnglishName=obj.DrugEnglishName		//英文名
			
			s bobj.DrugFirstClass=obj.DrugFirstClass		//药物一级分类编码
			s bobj.DrugSecondClass=obj.DrugSecondClass 		//药物一级分类编码
			s bobj.DrugClass=obj.DrugClass 		//药物二级分类编码
			s bobj.DrugOverview=obj.DrugOverview	//药物概述
			s bobj.IndicationOverview=obj.IndicationOverview		//适应症概述
			s bobj.DosageOverview=obj.DosageOverview		//用法用量概述
			s bobj.AdverseReactions=obj.AdverseReactions	//不良反应概述
			
			s bobj.Contraindications=obj.Contraindications	//禁忌症概述
			s bobj.DrugAccessories=obj.DrugAccessories		//辅料信息概述
			s bobj.DrugApplication=obj.DrugApplication	//适用情况概述
			s bobj.DrugInteraction=obj.DrugInteraction		//相互作用概述
			s bobj.DrugOverdose=obj.DrugOverdose		//药物过量概述
			s bobj.Remarks=obj.Remarks		//备注
			s bobj.QuoteFlag=obj.QuoteFlag //引用标志
			s bobj.KnowledgeTotal=obj.KnowledgeTotal	//知识数量
			
			
			s bobj.ApprovalFlag=obj.ApprovalFlag	//药监局报批
			s bobj.DrugType=obj.DrugType	//剂型
			s bobj.DrugAlias=obj.DrugAlias	//别名
			s bobj.DrugCategory=obj.DrugCategory	//药物类
			s bobj.DrugChemicalName=obj.DrugChemicalName	//化学名
			s bobj.DrugComposition=obj.DrugComposition	//成分
			s bobj.DrugTradeName=obj.DrugTradeName	//商品名
			s bobj.MaintainFlag=State	//状态
			
			s bobj.CreateDate=obj.CreateDate	//创建时间
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			s re=..SaveData(bobj)
			if (re["false")
			{
				s errorflag=1
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
		//tc
	}
	q result
}

/// Creator:xuwenhu
/// CreatDate:2021-06-09
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.DrugDict).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	//s LabSpecimenID=0
	
	s Code=$o(^CT.WDT.CDSS.DrugDictD(""),-1)
	
	if (Code="")
	{
		s:Code="" Code="00001"
	}
	else
	{
		s Code=Code+1
	}
	q Code
}

/// Creator：丁亚男 
/// CreatDate: 2021-9-08
/// Description：导入药物字典
/// Table:CT.WDT.CDSS.DrugDict 药物字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DrugDict).ImportDrugDictData()
ClassMethod ImportDrugDictData()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	s id=0

	//s file=##class(%File).%New(path)
	s file=##class(%File).%New("D:\更新文件\丁亚男\20210908\药物字典新增数据.csv")
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s DrugName=$p(str,",",1)	//通用名
		continue:DrugName=""
		s DrugAlias=$p(str,",",2)	//别名
		s:DrugAlias'="" DrugAlias=##class(web.BDP.util.String).Replace(DrugAlias,"&",",")
		s DrugChemicalName=$p(str,",",3)	//化学名
		s DrugTradeName=$p(str,",",4)	//商品名
		s:DrugTradeName'="" DrugTradeName=##class(web.BDP.util.String).Replace(DrugTradeName,"&",",")
		s ApprovalFlag=$p(str,",",5)		/// 药监局报批
		s ApprovalFlag=$case(ApprovalFlag,"是":"1","否":"0",:"0")
		s DrugType=$p(str,",",6)	//剂型
		s DrugCategory=$p(str,",",7)	//药物类
		s DrugComposition=$p(str,",",8)	//成分
		s:DrugComposition'="" DrugComposition=##class(web.BDP.util.String).Replace(DrugComposition,"&",",")
		
		s MaintainFlag=$p(str,",",9)	//状态
		s MaintainFlag=$case(MaintainFlag,"已审核":"2","编辑中":"0",:"0")
		
		s DrugCode=$o(^CT.WDT.CDSS.DrugDictD(""),-1)
		s DrugCode=$Zstrip(DrugCode,"<>W")
  		s DrugCode=$g(DrugCode)+1		//公司编码
		
		
		s DrugName=$Zstrip(DrugName,"<>W")
		s DrugAlias=$zstrip(DrugAlias,"<>W")
		s DrugChemicalName=$zstrip(DrugChemicalName,"<>W")
		s DrugTradeName=$zstrip(DrugTradeName,"<>W")
		s ApprovalFlag=$zstrip(ApprovalFlag,"<>W")
		s DrugType=$zstrip(DrugType,"<>W")
		s DrugCategory=$zstrip(DrugCategory,"<>W")
		s DrugComposition=$zstrip(DrugComposition,"<>W")
		
		
		s readcount=readcount+1
		s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugName,"U"),0))
		if (DrugID'="")
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugID)
			
			s obj.DrugNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(DrugName,3,"")
			s obj.DrugNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(DrugName,4,"")
			s obj.CreateDate=$zdt($h,3)
			s obj.ApprovalFlag=ApprovalFlag	//药监局报批
			s obj.DrugType=DrugType	//剂型
			s obj.DrugAlias=DrugAlias	//别名
			s obj.DrugCategory=DrugCategory	//药物类
			s obj.DrugChemicalName=DrugChemicalName	//化学名
			s obj.DrugComposition=DrugComposition	//成分
			s obj.DrugTradeName=DrugTradeName	//商品名
			s obj.MaintainFlag=MaintainFlag	//状态
			s sc= obj.%Save()
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		
		}
		else
		{
			s eobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
			s eobj.DrugNationCode=DrugCode
			s eobj.DrugName=DrugName		//通用名（中文名）
			s eobj.DrugCode=DrugCode
			s eobj.DrugNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(DrugName,3,"")	//汉语拼音
			//obj.DrugNamePinyin		
			s eobj.DrugNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DrugName)	//汉语首拼
			
			s eobj.ApprovalFlag=ApprovalFlag	//药监局报批
			s eobj.DrugType=DrugType	//剂型
			s eobj.DrugAlias=DrugAlias	//别名
			s eobj.DrugCategory=DrugCategory	//药物类
			s eobj.DrugChemicalName=DrugChemicalName	//化学名
			s eobj.DrugComposition=DrugComposition	//成分
			s eobj.DrugTradeName=DrugTradeName	//商品名
			s eobj.MaintainFlag=MaintainFlag	//状态

			s result=..SaveData(eobj)
		}	
		
		
		if ((result["true"))
		{
			s savecount=savecount+1
			if (DrugID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			s nosavecount=nosavecount+1
			
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	
	q "{success:'true'}"
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量通过
/// Table: CT.WDT.CDSS.DrugDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).ChangeStatusPass("")
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
			s flag=..ChangeStatus(id,"通过")

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
/// Table: CT.WDT.CDSS.DrugDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).ChangeStatusBack("")
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
/// CreatDate: 2021-11-30
/// Description：导入药物字典【药物类补充】
/// Table:CT.WDT.CDSS.DrugDict 药物字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DrugDict).ImportDrugClassData()
ClassMethod ImportDrugClassData()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	//s DrugID=0
	s DrugCode=""
	s result=""
	
	//s file=##class(%File).%New(path)
	s file=##class(%File).%New("D:\字典导入数据\药物类补充-导入-1.csv")
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		
		s DrugCode=$p(str,",",1)
		s DrugName=$p(str,",",2)
		
		//s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex",DrugName,DrugID))
		s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugName,"U"),0))
		s DrugCategory=$p(str,",",6)
		
		s readcount=readcount+1
		
		if (DrugID'="")	
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugID)
			s obj.DrugCategory=DrugCategory	//药物类
			s sc= obj.%Save()
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		}
		else
		{
			w DrugCode_"不存在",!
		}	
		
		if (result["true")
		{
			s savecount=savecount+1
			if (DrugID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			s nosavecount=nosavecount+1
			
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	
	q "{success:'true'}"
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.DrugDict
/// Other: w ##class(web.CDSS.CMKB.DrugDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DrugDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.DrugDictD(RowId)),25)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DrugDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.DrugDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.DrugDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DrugDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.DrugDictD(RowId)),30)       
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
/// CreatDate: 2022-04-02
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.DrugDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.DrugDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.DrugDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.DrugRowId,eobj.DrugCode,eobj.DrugName)   //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.DrugRowId,eobj.DrugName,eobj.DrugAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.DrugRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.DrugDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(eobj.DrugRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DrugDict).%New()
			
			//s bobj.DrugNationCode=obj.DrugNationCode	//国家（国际）编码
			s bobj.DrugCode=obj.DrugCode		//公司编码
			s bobj.DrugName=obj.DrugName		//通用名（中文名）
			s bobj.DrugAlias=obj.DrugAlias
			s bobj.DrugCategory=obj.DrugCategory
			s bobj.CreateDate=obj.CreateDate	//创建时间
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			
		}
		
		s obj.DrugCode=eobj.DrugCode		//公司编码
		s obj.DrugName=eobj.DrugName		//通用名（中文名）
		s obj.DrugAlias=eobj.DrugAlias
		s obj.DrugCategory=eobj.DrugCategory
		s eobj.CreateDate=$ZDATETIME($H,3)
		s obj.CreateDate=eobj.CreateDate	//创建时间
		s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))	//创建人员
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
			d:eobj.DrugRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DrugDict","CT.WDT.CDSS.DrugDict","药物字典",id,eobj.DrugName,"A",eobj)
			d:eobj.DrugRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DrugDict","CT.WDT.CDSS.DrugDict","药物字典",eobj.DrugRowId,eobj.DrugName,"U",eobj,bobj)
			//同步修改对照数据
			d:eobj.DrugRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("药品",bobj.DrugCode_"[A]"_bobj.DrugName,eobj.DrugCode_"[A]"_eobj.DrugName)
			//同步修改识别词项目数据    2021-11-25
			d:eobj.DrugRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("药品名称",eobj.DrugName,bobj.DrugName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.DrugRowId="")&&(eobj.DrugAlias'=""))||((eobj.DrugRowId'="")&&(eobj.DrugAlias'=bobj.DrugAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DrugDict",id,eobj.DrugAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物字典","web.CDSS.CMKB.DrugDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物字典","web.CDSS.CMKB.DrugDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-05-30
/// Description:生成字典数据被引用标志
/// Table: CT.WDT.CDSS.DrugDict
/// Input: 
/// Return: result
/// others:w ##class(web.CDSS.CMKB.DrugDict).CreateQuoteFlagData()
ClassMethod CreateQuoteFlagData()
{
	s RowId=0
	for
	{
 		s RowId = $o(^CT.WDT.CDSS.DrugDictD(RowId)) q:RowId=""
 		
 		s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(RowId)
 		s QuoteFlag = obj.QuoteFlag
 		s DrugName = obj.DrugName
 		s DrugCode = obj.DrugCode
 		
		;M（Mapping）被字典对照V2.0引用
		s ContrastType="药品"
		s MappingFlag=0
		s ContrastDictDR=""

		if ($d(^CT.WDT.CDSS.ContrastDictI("ContrastDictIndex"," "_DrugName,ContrastType,RowId))) s MappingFlag=1
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
			s obj.QuoteFlag=##class(web.CDSS.CMKB.DrugDict).RemoveQuoteFlag(QuoteFlag,"M")	
		}

		s QuoteFlag = obj.QuoteFlag
		;W（Warning）被预警规则库引用
		s WarningFlag=0
		s Flag=##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("药品",DrugName,RowId) //被预警规则库（药品合理性）引用判断
		
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
			s obj.QuoteFlag=##class(web.CDSS.CMKB.DrugDict).RemoveQuoteFlag(QuoteFlag,"W")	
		}
		
		s sc=obj.%Save()
		d obj.%Close()
	}
	q "药品数据处理完成！"
}

/// Creator:赵文伟
/// CreatDate:2022-05-30
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.DrugDict).RemoveQuoteFlag("","R")
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

/// Creator：赵文伟
/// CreatDate: 2022-06-06
/// Description：药物类重复数据处理
/// Table: CT.WDT.CDSS.DrugDict 
/// Other: w ##class(web.CDSS.CMKB.DrugDict).HandleDrugCategoryData()
ClassMethod HandleDrugCategoryData() As %String
{
	s RowId=0
	s DrugCategory=""
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DrugDictD(RowId)) q:RowId=""
		
		s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(RowId)
		s DrugCategory=obj.DrugCategory
		
		if (DrugCategory'=""){
			s len=$l(DrugCategory,",")				//以,作为分隔符取数据长度
			s DrugCategoryStr=""
	       	for j=1:1:len 
	       	{ 
	         	s Category=$p(DrugCategory,",",j)		//遍历取每一项
	         
	         	if (DrugCategoryStr=""){
		         	s DrugCategoryStr=Category
		        } 
		        else
		        {
			        if (DrugCategoryStr[Category)
			        {}
			        else
			        {
				      s DrugCategoryStr=DrugCategoryStr_","_Category
				    }
			        
			    }
	      	}
			s obj.DrugCategory=DrugCategoryStr
		} 
		s sc=obj.%Save()
		d obj.%Close()
	}
	
	q "数据处理完成！"
}

/// Creator：赵文伟
/// CreatDate: 2022-06-07
/// Description：校验药物类数据——【药物分类字典】
/// Table: CT.WDT.CDSS.DrugDict 
/// Other: d ##class(web.CDSS.CMKB.DrugDict).VerifyDrugCategoryDataT()
ClassMethod VerifyDrugCategoryDataT() As %String
{
	s RowId=0
	s DrugCategory=""
	s TempDataStr=""
	w "药物分类字典中不存在的药物类数据：",!
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DrugDictD(RowId)) q:RowId=""
		
		s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(RowId)
		s DrugCategory=obj.DrugCategory
		
		if (DrugCategory'=""){
			s len=$l(DrugCategory,",")				//以,作为分隔符取数据长度
			
	       	for j=1:1:len 
	       	{
	         	s Category=$p(DrugCategory,",",j)		//遍历取每一项
	         	if ('$d(^CT.WDT.CDSS.DrugTypeDictI("DescIndex"," "_($ZCONVERT(Category,"U"))))){
	         		if '(TempDataStr[Category)
		         	{
			         	s TempDataStr=TempDataStr_Category
			         	w Category,!
			        }
			       
		        }
	      	}
		} 
		
		d obj.%Close()
	}
	w "数据校验完成！"
}

/// Creator：赵文伟
/// CreatDate: 2022-06-07
/// Description：校验药物类数据——【药物分类字典】
/// Table: CT.WDT.CDSS.DrugDict 
/// Other: d ##class(web.CDSS.CMKB.DrugDict).VerifyDrugCategoryData()
ClassMethod VerifyDrugCategoryData() As %String
{
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="药物类校验数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("药品编码,"_"药品通用名,"_"药物类,"_"是否存在于药物分类字典")
	d file.WriteLine()
	
	
	s RowId=0
	s DrugCategory=""
	s TempDataStr=""
	//w "药物分类字典中不存在的药物类数据：",!
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DrugDictD(RowId)) q:RowId=""
		
		s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(RowId)
		s DrugCode=obj.DrugCode
		s DrugName=obj.DrugName
		s DrugCategory=obj.DrugCategory
		
		if (DrugCategory'=""){
			s len=$l(DrugCategory,",")				//以,作为分隔符取数据长度
			s Category=""
	       	for j=1:1:len 
	       	{
	         	s Category=$p(DrugCategory,",",j)		//遍历取每一项
	         	if ('$d(^CT.WDT.CDSS.DrugTypeDictI("DescIndex"," "_($ZCONVERT(Category,"U"))))){
#;	         		if '(TempDataStr[Category)
#;		         	{
#;			         	s TempDataStr=TempDataStr_Category
#;			         	w Category,!
#;			        }
					s flag="否"
					d file.Write(DrugCode_",")
					d file.Write(DrugName_",")
					d file.Write(Category_",")
					d file.Write(flag)
					d file.WriteLine()
			       
		        }
	      	}
		} 
		
		d obj.%Close()
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2022-06-10
/// Description：药物类检验数据再处理【删除+修改】
/// Table:CT.WDT.CDSS.DrugDict 药物字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DrugDict).HandleVerifyData("D:\WORK\DictData\药物类校验数据.csv")
ClassMethod HandleVerifyData(path)
{
	s readcount=0
	s updatecount=0
	s result=""
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		
		s DrugCode=$p(str,",",1)
		s DrugName=$p(str,",",2)
		s DrugCategory=$p(str,",",3)
		s Remark=$p(str,",",4)
		
		s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugName,"U"),0))
	
		s readcount=readcount+1
		if (DrugID'="")	
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugID)
			if (Remark="已新增药物类，无需处理"){	//第一类
				s updatecount=updatecount+1
			} 
			elseif(Remark="删除不存在药物类")	//删掉该条药物类，第二类
			{
				s len=$l(obj.DrugCategory,",")				//以,作为分隔符取数据长度
				s Category=""
				s FinalCategory=""
	       		for j=1:1:len 
	       		{
	         		s Category=$p(obj.DrugCategory,",",j)		//遍历取每一项
	         		if (Category'=DrugCategory){
		         		if (FinalCategory=""){
			         		s FinalCategory=Category
			         	}else{
				         	s FinalCategory=FinalCategory_","_Category
				         }
		         	}
	       		}
	       		s obj.DrugCategory=FinalCategory	//药物类
	       		s sc= obj.%Save()
	       		s updatecount=updatecount+1

			} 
			else 	//修改当前药物类数据，第三类
			{
				s len=$l(obj.DrugCategory,",")				//以,作为分隔符取数据长度
				s Category=""
				s FinalCategory=""
	       		for j=1:1:len 
	       		{
	         		s Category=$p(obj.DrugCategory,",",j)		
	         		if (Category=DrugCategory){		//要修改的项
		         		if (FinalCategory=""){
			         		s FinalCategory=Remark
			         	}else{
				         	s FinalCategory=FinalCategory_","_Remark
				         }
		         	} else {				//原药物类不变
			         	if (FinalCategory=""){
			         		s FinalCategory=Category
			         	}else{
				         	s FinalCategory=FinalCategory_","_Category
				        }
			        }
	       		}
	       		s obj.DrugCategory=FinalCategory	//药物类
	       		s sc= obj.%Save()
				s updatecount=updatecount+1
			}
		}
		else
		{
			w DrugName_"不存在",!
		}	
	}
	w "readcount："_readcount,!
	w "updatecount："_updatecount,!
	q "数据处理完成！"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回文献表的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DrugDict","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.DrugDict",RowId,LogID),-1) q:LogID=""
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
/// CreatDate: 2023-02-11
/// Description：查询 药物
/// Table：CT.WDT.CDSS.DrugDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DrugDict","GetDataForCmb2","","木")
Query GetDataForCmb2(desc As %String, q As %String) As %Query(ROWSPEC = "DrugID:%String,DrugName:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	
	 	if (desc="") s desc=q
  		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  		
  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DrugDictD(ID))
			q:ID=""
			s DrugName=$lg($g(^CT.WDT.CDSS.DrugDictD(ID)),4)		//名称
			s length=$l(DrugName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s DrugID=0
			for
			{
				s DrugID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DrugID))
				q:DrugID=""
  				s DrugName=$LISTGET($G(^CT.WDT.CDSS.DrugDictD(DrugID)),4)
  				s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),26)	//药物类
  				s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),25)	//别名
  				s PINYIN=""
  				s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DrugName)  
  				s MaintainFlag=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),30)	//状态
  					
  				if (($ZCONVERT(DrugName,"U")[desc)||(PINYIN[desc)||($ZCONVERT(DrugAlias,"U")[desc)&(MaintainFlag="2")) {
  					d OutputRowCmb
  				}  		
  				continue:(desc'="")		
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
		//中药
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMMedicineD(ID))
			q:ID=""
			s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(ID)),3)
			s length=$l(MedicineName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			if (desc="") s desc=q
			s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s MedicineRowId=0
			for
			{
				s MedicineRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,MedicineRowId))
				q:MedicineRowId=""
				s MedicineDR=MedicineRowId
  				s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)
  				s State=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),13)
  				s PINYIN=""
  				s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MedicineName)  
  				if (($ZCONVERT(MedicineName,"U")[desc)&(State=2)){
	  				s DrugID=MedicineRowId
	  				s DrugName=MedicineName
  					d OutputRowCmb
  				}
  				continue:(desc'="")		
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DrugID,DrugName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：赵文伟 
/// CreatDate: 2023-03-06
/// Description：药物字典主要成分数据导入（如果已存在主要成分则修改为新导入的）
/// Table:CT.WDT.CDSS.DrugDict 药物字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DrugDict).ImportMainIngredientData()
ClassMethod ImportMainIngredientData()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	s DrugCode=""
	s result=""
	
	s file=##class(%File).%New("D:\WORK\DictData\药物主要成分修正-导入版0303.csv")
	if '##class(%File).Exists(path) {	//文件路径不存在
		w "文件路径不存在"
	}
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		
		s DrugCode=$p(str,",",1)
		s DrugName=$p(str,",",2)
		
		//s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex",DrugName,DrugID))
		s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugName,"U"),0))
		s DrugChemicalName=$p(str,",",3)	//主要成分（化学名）
		
		s readcount=readcount+1
		
		if (DrugID'="")	
		{
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugID)
			s obj.DrugChemicalName=DrugChemicalName	//主要成分（化学名）
			s sc= obj.%Save()
			
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		}
		else
		{
			w DrugCode_","_DrugName_"不存在",!
		}	
		
		if (result["true")
		{
			s savecount=savecount+1
			if (DrugID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			s nosavecount=nosavecount+1
			
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	
	q "{success:'true'}"
}

/// Creator：赵文伟 
/// CreatDate: 2023-03-06
/// Description：药物字典主要成分数据导入（如果已存在主要成分则修改为新导入的）,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:CT.WDT.CDSS.DrugDict 药物字典
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DrugDict).ImportMainIngredientTXT("D:\ZWW\药物主要成分修正-导入版0303.txt")
ClassMethod ImportMainIngredientTXT(path) As %String
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
		
		s DrugCode=$p(data,$c(9),1)	//编码
		s DrugName=$p(data,$c(9),2)		//名称
		s DrugChemicalName=$p(data,$c(9),3)	//主要成分
		
		s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugName,"U"),0))
		if (DrugID'=""){
		
			s obj=##class(CT.WDT.CDSS.DrugDict).%OpenId(DrugID)
			s obj.DrugChemicalName=DrugChemicalName	//主要成分（化学名）
			s sc= obj.%Save()
			
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
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
			w !,DrugCode_","_DrugName_"不存在"
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
/// CreatDate: 2023-05-19
/// Description：批量删除已弃用数据[未被引用或只被字典对照引用]
/// Table: ^CT.WDT.CDSS.DrugDictD
/// Other: w ##class(web.CDSS.CMKB.DrugDict).DeleteDeprecatedData() 
ClassMethod DeleteDeprecatedData() As %String
{
	s count=0
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.DrugDictD(RowId),-1) q:RowId="" 
		s Name = $LISTGET($G(^CT.WDT.CDSS.DrugDictD(RowId)),4)
		s UseFlag = $lg($g(^CT.WDT.CDSS.DrugDictD(RowId)),30)
		if (UseFlag=1){
			s quoteInfo=..GetRefFlag(RowId)
			if '((quoteInfo["诊疗规则关联触发条件表")||(quoteInfo["规则管理")||(quoteInfo["识别词规则")){
				
				d ##class(web.CDSS.CMKB.DrugDict).DeleteData(RowId)
				w Name_"已删除",!
				s count=count+1
			}
		}
	}
	q "success,已删除"_count_"条数据！"
}

}

/// Description：检验项目字典表 
/// Table：CT.WDT.CDSS.LabInspectionDict
Class web.CDSS.CMKB.LabInspectionDictDetail Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 检验项目
/// Table：CT.WDT.CDSS.LabInspectionDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabInspectionDictDetail","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "LabID:%String,LabName:%String,LabDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s LabID=rowid
		s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabID)),4)
		d OutputRowCmb
	}
	else
	{
		s:desc="" desc=q
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		//s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.LabInspectionDictD(ID))
			q:ID=""
			s LabName=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),4)		//名称
			s length=$l(LabName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s LabID=0
			for
			{
				s LabID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,LabID))
				q:LabID=""
				s LabDR=LabID
				s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabID)),4)
				s LabNamePinyin=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabID)),5)	//汉语拼音
		  		s LabNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabID)),6)	//汉语首拼
		  		s Alias=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabID)),23)	//别名
		  		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabID)),24)
		  		continue:UseFlag=1
		  		if ((($ZCONVERT(LabName,"U")[desc)||(LabNamePinyin[desc)||(LabNameFirstPinyin[desc)||($ZCONVERT(Alias,"U")[desc))&(UseFlag="2")) {
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
	set Data=$lb(LabID,LabName,LabDR)
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
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：ZWW
/// CreatDate: 2022-09-15
/// Description：查询检验字典
/// Table：CT.WDT.CDSS.LabInspectionDict	检验字典
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabInspectionDictDetail","GetList","","","","","","","1","","","","CreateDate")
Query GetList(rowid, code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "LabRowId,LabNationCode,LabCode,LabName,LabNamePinyin,LabNameFirstPinyin,LabEnglishName,LabClassCodeDR,LabClassName,LabDesc,LabSpecimen,LabProcess,IndicationOverview,LabTaboo,AdverseReactions,LabPrecautions,LabResult,LabResultExp,Remarks,QuoteFlag,KnowledgeTotal,CreateDate,CreateUserID,Alias,UseFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, sortmethod As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
 s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s LabRowId=rowid
	s LabNationCode=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),2)	//国家（国际）编码
	s LabCode=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),3)	//公司编码
	s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),4)	//检验项目名称
	s LabNamePinyin=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),5)	//汉语拼音
	s LabNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),6)	//汉语首拼
	s LabEnglishName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),7)	//英文名
	s LabClassCodeDR=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),8)	//检验项目类型DR
	s LabClassName=""
	//s:LabClassCodeDR'="" LabClassName=$LISTGET($G(^CT.WDT.CDSS.LabClassDictD(LabClassCodeDR)),4)
	s LabDesc=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),9)	//检验项目概述
	s LabSpecimen=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),10)		//检验标本概述
	s LabProcess=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),11)	//检验过程概述
	s IndicationOverview=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),12)	//适用症概述
	s LabTaboo=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),13)		//禁忌症概述
	s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),14)	//不良反应概述
	s LabPrecautions=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),15)	//注意事项概述
	s LabResult=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),16)		//检验结果概述
	s LabResultExp=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),17)		//检验结果有效期（天）
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),18)		//备注
	s QuoteFlag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),19) //引用标志
	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),20)	//知识数量
	s:KnowledgeTotal="" KnowledgeTotal=0
	s CreateDate=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),21)	//创建时间
	s CreateUserID=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),22)	//创建人员
	s Alias=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),23)	//别名
	s UseFlag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),24)	//状态
	s:UseFlag="" UseFlag=0
	d OutputRow
 }
 else
 {
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	//默认时间倒序输出
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.LabInspectionDictD(ID))
			q:ID=""
			s LabName= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),4)		//名称
			s length=$l(LabName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.LabInspectionDictD(ID))
			q:ID=""
			s CreateDate= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),21)	//编辑时间
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
		s LabRowId=0
		for
		{
	        s LabRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,LabRowId)) q:LabRowId=""
			s LabNationCode=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),2)	//国家（国际）编码
			s LabCode=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),3)	//公司编码
			s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),4)	//检验项目名称
			s LabNamePinyin=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),5)	//汉语拼音
			s LabNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),6)	//汉语首拼
			s LabEnglishName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),7)	//英文名
			s LabClassCodeDR=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),8)	//检验项目类型DR
			//continue:((labclass'="")&&(LabClassCodeDR'=labclass))
			s LabClassName=""
			//s:LabClassCodeDR'="" LabClassName=$LISTGET($G(^CT.WDT.CDSS.LabClassDictD(LabClassCodeDR)),4)
			
			s LabDesc=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),9)	//检验项目概述
			s LabSpecimen=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),10)		//检验标本概述

			s LabProcess=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),11)	//检验过程概述
			s IndicationOverview=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),12)	//适用症概述
			s LabTaboo=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),13)		//禁忌症概述
			s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),14)	//不良反应概述
			s LabPrecautions=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),15)	//注意事项概述
			s LabResult=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),16)		//检验结果概述
			s LabResultExp=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),17)		//检验结果有效期（天）
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),18)		//备注
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
			
			s QuoteFlag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),19) //引用标志
			continue:(QuoteFlag'[quoteflag)
			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
			s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),20)	//知识数量
			s:KnowledgeTotal="" KnowledgeTotal=0
			s CreateDate=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),21)	//创建时间
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
	    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
			s CreateUserID=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),22)	//创建人员
			continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
			s Alias=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),23)	//别名
			continue:((aliasname'="")&&($ZCONVERT(Alias,"U")'[aliasname))
			s UseFlag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),24)	//状态
			s:UseFlag="" UseFlag=0
			if (state=""){
				continue:(UseFlag=1)			
			}
			else{
				continue:((state'="")&&(UseFlag'=state))
			}
			
			if (($ZCONVERT(LabName,"U")[desc)||($ZCONVERT(LabNamePinyin,"U")[desc)||($ZCONVERT(LabNameFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(LabCode,"U")[code) 
			{
				d OutputRow
			}
		}
	}
}
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
    set Data=$lb(LabRowId,LabNationCode,LabCode,LabName,LabNamePinyin,LabNameFirstPinyin,LabEnglishName,LabClassCodeDR,LabClassName,LabDesc,LabSpecimen,LabProcess,IndicationOverview,LabTaboo,AdverseReactions,LabPrecautions,LabResult,LabResultExp,Remarks,QuoteFlag,KnowledgeTotal,CreateDate,CreateUserID,Alias,UseFlag)
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
/// Other:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).GetQuoteFlag("D,K,R")
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
/// Table：CT.WDT.CDSS.LabInspectionDict	检验字典
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).FormValidate("","1")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.LabInspectionDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.LabInspectionDictI("NameIndex",desc))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.LabInspectionDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
#;	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
#;	s flag="",flagn="",flagc="",flagd=""
#;	s:desc'="" flagd=$d(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_desc))
#;	
#;	if (id="") //如果为空，增加时的重复判断
#;	{
#;		if ((flagd>0)) s flag=1  //返回重复标志
#;		else  s flag=0 //返回不重复标志
#;	}
#;	else //如果不为空，修改时的重复判断
#;	{
#;		s idn="",idc="",idd=""
#;		
#;  		s:desc'="" idd=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_desc,0))
#;  		
#;  		if ((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
#;  		else  s flag=0 //返回不重复标志
#;
#;	}
#;	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.LabInspectionDictDetail).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabInspectionDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.LabInspectionDictI("NameIndex",Alias))
	    if (id="")	//如果为空，增加时的重复判断
	    {
	        if ((flagA>0)||(flagN>0)) 
	        {
		        s flag=1  //返回重复标志
		        q
	        }
	    }
	    else 	//如果不为空，修改时的重复判断
	    {
	        s idA="",idN=""
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabInspectionDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// CreatDate: 2020-06-21
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.LabInspectionDict	检验字典
/// Input：eobj web.CDSSEntity.CMKB.LabInspectionDict
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.LabInspectionDictDetail).SaveData()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.LabInspectionDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.LabRowId,eobj.LabCode,eobj.LabName) //校验重复
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.LabRowId,eobj.LabName,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.LabRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.LabInspectionDict).%New() 
			s obj.UseFlag=0
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(eobj.LabRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.LabInspectionDict).%New()
			
			s bobj.LabNationCode=obj.LabNationCode	//国家（国际）编码
			s bobj.LabCode=obj.LabCode	//公司编码
			s bobj.LabName=obj.LabName	//检验项目名称
			s bobj.LabNamePinyin=obj.LabNamePinyin	//汉语拼音
			s bobj.LabNameFirstPinyin=obj.LabNameFirstPinyin	//汉语首拼
			s bobj.LabEnglishName=obj.LabEnglishName	//英文名
			
			s bobj.LabClassCodeDR=obj.LabClassCodeDR
			s bobj.LabDesc=obj.LabDesc	//检验项目概述
			s bobj.LabSpecimen=obj.LabSpecimen		//检验标本概述
			s bobj.LabProcess=obj.LabProcess	//检验过程概述
			s bobj.IndicationOverview=obj.IndicationOverview	//适用症概述
			s bobj.LabTaboo=obj.LabTaboo		//禁忌症概述
			s bobj.AdverseReactions=obj.AdverseReactions	//不良反应概述
			s bobj.LabPrecautions=obj.LabPrecautions	//注意事项概述
			s bobj.LabResult=obj.LabResult		//检验结果概述
			s bobj.LabResultExp=obj.LabResultExp		//检验结果有效期（天）
			s bobj.Remarks=obj.Remarks		//备注
			s bobj.QuoteFlag=obj.QuoteFlag		//引用标志
			s bobj.KnowledgeTotal=obj.KnowledgeTotal		//知识数量
			s bobj.CreateDate=obj.CreateDate
			s bobj.CreateUserID=obj.CreateUserID
			s bobj.Alias=obj.Alias
			s bobj.UseFlag=obj.UseFlag
		}
		
		
		s obj.LabNationCode=eobj.LabNationCode	//国家（国际）编码
		s obj.LabCode=eobj.LabCode	//公司编码
		s obj.LabName=eobj.LabName	//检验项目名称
		s obj.LabNamePinyin=eobj.LabNamePinyin	//汉语拼音
		s obj.LabNameFirstPinyin=eobj.LabNameFirstPinyin	//汉语首拼
		s obj.LabEnglishName=eobj.LabEnglishName	//英文名
		
		s obj.LabClassCodeDR=eobj.LabClassCodeDR
		s obj.LabDesc=eobj.LabDesc	//检验项目概述
		s obj.LabSpecimen=eobj.LabSpecimen		//检验标本概述
		s obj.LabProcess=eobj.LabProcess	//检验过程概述
		s obj.IndicationOverview=eobj.IndicationOverview	//适用症概述
		s obj.LabTaboo=eobj.LabTaboo		//禁忌症概述
		s obj.AdverseReactions=eobj.AdverseReactions	//不良反应概述
		s obj.LabPrecautions=eobj.LabPrecautions	//注意事项概述
		s obj.LabResult=eobj.LabResult		//检验结果概述
		s obj.LabResultExp=eobj.LabResultExp		//检验结果有效期（天）
		s obj.Remarks=eobj.Remarks		//备注
		
		//s obj.QuoteFlag=eobj.QuoteFlag		//引用标志
		//s obj.KnowledgeTotal=eobj.KnowledgeTotal		//知识数量
		s obj.CreateDate=eobj.CreateDate
		s obj.CreateUserID=eobj.CreateUserID
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
			d:eobj.LabRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabInspectionDict","CT.WDT.CDSS.LabInspectionDict","检验项目字典",id,eobj.LabName,"A",eobj)
			d:eobj.LabRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabInspectionDict","CT.WDT.CDSS.LabInspectionDict","检验项目字典",id,eobj.LabName,"U",eobj,bobj)
			/*
			//检验百科增加一条同名数据
			d:eobj.LabRowId="" ##class(web.DHCBL.MKB.MKBTerm).SaveTerm("检验",eobj.LabName,"")
			d:eobj.LabRowId'="" ##class(web.DHCBL.MKB.MKBTerm).SaveTerm("检验",eobj.LabName,bobj.LabName)
			*/
			//[新]检验百科增加一条同名数据    2021-11-25
			d:eobj.LabRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabName,"")
			d:eobj.LabRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabName,bobj.LabName)
			
			//调用字典对照接口
			d:eobj.LabRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验", bobj.LabCode_"[A]"_bobj.LabName,eobj.LabCode_"[A]"_eobj.LabName)
			
			//同步修改识别词项目数据    2021-11-25
			d:eobj.LabRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("检验项目名称",eobj.LabName,bobj.LabName)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.LabRowId="")&&(eobj.Alias'=""))||((eobj.LabRowId'="")&&(eobj.Alias'=bobj.Alias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabInspectionDict",id,eobj.Alias)
            }
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验项目字典","web.CDSS.CMKB.LabInspectionDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验项目字典","web.CDSS.CMKB.LabInspectionDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：钟荣枫
/// CreatDate: 2020-06-21
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.LabInspectionDict	检验字典
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.LabInspectionDict).%New()
	
	s bobj.LabNationCode=obj.LabNationCode	//国家（国际）编码
	s bobj.LabCode=obj.LabCode	//公司编码
	s bobj.LabName=obj.LabName	//检验项目名称
	s bobj.LabNamePinyin=obj.LabNamePinyin	//汉语拼音
	s bobj.LabNameFirstPinyin=obj.LabNameFirstPinyin	//汉语首拼
	s bobj.LabEnglishName=obj.LabEnglishName	//英文名
	s bobj.LabClassCodeDR=obj.LabClassCodeDR
	
	s bobj.LabDesc=obj.LabDesc	//检验项目概述
	s bobj.LabSpecimen=obj.LabSpecimen		//检验标本概述
	s bobj.LabProcess=obj.LabProcess	//检验过程概述
	s bobj.IndicationOverview=obj.IndicationOverview	//适用症概述
	s bobj.LabTaboo=obj.LabTaboo		//禁忌症概述
	s bobj.AdverseReactions=obj.AdverseReactions	//不良反应概述
	s bobj.LabPrecautions=obj.LabPrecautions	//注意事项概述
	s bobj.LabResult=obj.LabResult		//检验结果概述
	s bobj.LabResultExp=obj.LabResultExp		//检验结果有效期（天）
	s bobj.Remarks=obj.Remarks		//备注
	
	s bobj.QuoteFlag=obj.QuoteFlag		//引用标志
	s bobj.KnowledgeTotal=obj.Remarks		//知识数量
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
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
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).GetRefFlag("2020")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
    s DictDesc=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(id)),4)
	//诊疗规则引用接口 2023-02-28
	s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("检验项目",DictDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("检验项目",DictDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
	//识别词项目引用接口    2021-11-25
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("检验项目名称",DictDesc)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	//字典对照引用接口	2022-04-08 ZWW
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("检验",DictDesc)
	s myInfo=myInfo_Mappinginfo
	
	//规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("检验",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用"
 	q return
}

/// Creator:钟荣枫
/// CreatDate:2020-06-21
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.LabInspectionDict	检验字典
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.LabInspectionDict).%New()
	s bobj.LabNationCode=obj.LabNationCode	//国家（国际）编码
	s bobj.LabCode=obj.LabCode	//公司编码
	s bobj.LabName=obj.LabName	//检验项目名称
	s bobj.LabNamePinyin=obj.LabNamePinyin	//汉语拼音
	s bobj.LabNameFirstPinyin=obj.LabNameFirstPinyin	//汉语首拼
	s bobj.LabEnglishName=obj.LabEnglishName	//英文名
	s bobj.LabClassCodeDR=obj.LabClassCodeDR
		
	s bobj.LabDesc=obj.LabDesc	//检验项目概述
	s bobj.LabSpecimen=obj.LabSpecimen		//检验标本概述
	s bobj.LabProcess=obj.LabProcess	//检验过程概述
	s bobj.IndicationOverview=obj.IndicationOverview	//适用症概述
	s bobj.LabTaboo=obj.LabTaboo		//禁忌症概述
	s bobj.AdverseReactions=obj.AdverseReactions	//不良反应概述
	s bobj.LabPrecautions=obj.LabPrecautions	//注意事项概述
	s bobj.LabResult=obj.LabResult		//检验结果概述
	s bobj.LabResultExp=obj.LabResultExp		//检验结果有效期（天）
	s bobj.Remarks=obj.Remarks		//备注
		
	s bobj.QuoteFlag=obj.QuoteFlag		//引用标志
	s bobj.KnowledgeTotal=obj.KnowledgeTotal		//知识数量
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
	s bobj.Alias=obj.Alias
	s bobj.UseFlag=obj.UseFlag
		
	Ts
	//同步删除对照数据 2022-01-21
	s re =  ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("检验",obj.LabCode_"[A]"_obj.LabName)
	if (re="true[A]true"){
		s sc=##class(CT.WDT.CDSS.LabInspectionDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
				
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			
			//{新]检验百科删除同名数据    2021-11-25
			//d ##class(web.CDSS.CMKB.Term).DeleteTerm("检验",bobj.LabName)
					
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabInspectionDict","CT.WDT.CDSS.LabInspectionDict","检验项目字典",id,bobj.LabName,"D",bobj)
					
			//同步删除别名通用表中数据 
	        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.LabInspectionDict",id)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("检验项目字典","web.CDSS.CMKB.LabInspectionDictDetail","DeleteData",bobj)
		       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	} else{
		s result = "{success:'false',info:'字典对照同步删除失败！'}"
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-07-14
/// Description:根据名称获取id
/// Table: CT.WDT.CDSS.LabInspectionDict	检验字典
/// Input: name
/// others:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).GetIdByName("微生物")
ClassMethod GetIdByName(name As %String)
{
	q:name="" ""
	s name=$ZCONVERT(name,"U") //转换成大写
	s id=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_name,""))
	q id
}

/// Creator:高姗姗
/// CreatDate:2020-09-10
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).RemoveQuoteFlag("","R")
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
/// Table: CT.WDT.CDSS.LabInspectionDict	检验字典
/// others:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).SaveKnowledgeTotal()
ClassMethod SaveKnowledgeTotal()
{
	s LabID=""
	for
	{ 
		s LabID=$o(^CT.WDT.CDSS.LabInspectionDictD(LabID)) q:LabID=""  //检验字典
		s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(LabID)
 		s QuoteFlag = obj.QuoteFlag
 		s LabCode = obj.LabCode
 		s LabName = obj.LabName
 		s basedr=##class(web.CDSS.CMKB.Term).GetIdByDesc("检验")
 		
		;K（Knowledge） 被医为百科引用
		if (basedr'="")
		{
			if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(LabName,"U")))))
			{
				s termdr=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(LabName,"U")),""))
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
						s obj.QuoteFlag=##class(web.CDSS.CMKB.LabInspectionDictDetail).RemoveQuoteFlag(QuoteFlag,"K")		
					}
				}
			}
		}
		s QuoteFlag = obj.QuoteFlag
		;M（Mapping）数据对照
		
		s ContrastType="检查检验"
		s MappingFlag=0
		s ContrastDictDR=""

		if ($d(^CT.WDT.CDSS.ContrastDictI("ContrastDictIndex"," "_LabName,ContrastType,LabID))) s MappingFlag=1
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
			s obj.QuoteFlag=##class(web.CDSS.CMKB.LabInspectionDictDetail).RemoveQuoteFlag(QuoteFlag,"M")		
		}
		s QuoteFlag = obj.QuoteFlag
		s Exist =##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.CDSS.CMKB.RuleTrigger")
		if (Exist="1"){
			;R（Rule） 被规则知识库引用
			s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("检验",LabName) //被诊疗规则引用判断
			s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("检验",LabName) //被诊疗子规则引用判断
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
				s obj.QuoteFlag=##class(web.CDSS.CMKB.LabInspectionDictDetail).RemoveQuoteFlag(QuoteFlag,"R")		
			}
			s QuoteFlag = obj.QuoteFlag
		}
		;W（Warning）被预警规则库引用
		s WarningFlag=0
		s Flag=##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("检验",LabName,LabID) //被预警规则库（检验合理性）引用判断
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
			s obj.QuoteFlag=##class(web.CDSS.CMKB.LabInspectionDictDetail).RemoveQuoteFlag(QuoteFlag,"W")	
		}
		s sc=obj.%Save()
		d obj.%Close()	
	}
	q "检验数据处理完成！"
}

/// Creator:丁亚男
/// CreatDate:2020-09-28
/// Description：导入检验数据
/// Table：CT.WDT.CDSS.LabInspectionDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.LabInspectionDictDetail).ImportLabData()
ClassMethod ImportLabData()
{
	
	s result ="" 
	s file=##class(%File).%New("F:\基础数据平台文档\CDSS\标准检验字典-new.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s StandName=$p(Line,",",2)
		s StandName=$tr(StandName,"&",",")
		if (StandName'="")
		{
			s Srowid=""
			s Srowid=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(StandName,"U"),0))
			s LabName=$p(Line,",",1)
			
			s LabName=$tr(LabName,"&",",")
			s rowid=""
			if LabName'="" s rowid=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"),0))
			
			if (rowid'="")&(Srowid="")
			{
				s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(rowid)
				s obj.LabName=StandName
				s obj.LabCode=StandName
				s obj.LabNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(StandName) 
				s obj.LabNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(StandName,3)
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
					w !, StandName_"修改失败"
				}
			}
			elseif (rowid="")&(Srowid="")
			{
				s obj=##class(CT.WDT.CDSS.LabInspectionDict).%New() 
				s obj.LabName=StandName
				s obj.LabCode=StandName
				s obj.LabNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(StandName) 
				s obj.LabNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(StandName,3)
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
					w !, StandName_"导入失败"
				}
		
			}
			elseif(rowid'="")&(Srowid'="")&(Srowid'=rowid)
			{
				s SKnowledgeTotal=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(Srowid)),20)
				s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(rowid)),20)
				
				if (SKnowledgeTotal>KnowledgeTotal)
				{
					s result=##class(web.CDSS.CMKB.LabInspectionDictDetail).DeleteData(rowid)
					w !,"删除"_LabName
				}
				else
				{
					s result=##class(web.CDSS.CMKB.LabInspectionDictDetail).DeleteData(Srowid)
					s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(rowid)
					s obj.LabName=StandName
					s obj.LabCode=StandName
					s obj.LabNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(StandName) 
					s obj.LabNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(StandName,3)
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
						w !, StandName_"修改失败"
					}
				}
			}
		}
		
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-09-27
/// Description：删除检查数据
/// Table：CT.WDT.CDSS.ExamDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.LabInspectionDictDetail).DeleteLabData()
ClassMethod DeleteLabData()
{
	
	s result ="" 
	s file=##class(%File).%New("F:\基础数据平台文档\CDSS\老库剔除数据检验20200929.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s LabName=$p(Line,",",1)
		s LabName=$tr(LabName,"&",",")
		s rowid=""
		if LabName'="" s rowid=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"),0))
		if (rowid'="")
		{
			s result=##class(web.CDSS.CMKB.LabInspectionDictDetail).DeleteData(rowid)
			if (result["false") w !,"1删除"_LabName_"失败"
		}
		else
		{
			w !,"2删除"_LabName_"失败"
		}
			
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-11-30
/// Description：导出检验字典表数据
/// Other:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).ExportLabData("","","","","","","","","","")
ClassMethod ExportLabData(code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检验项目字典数据.txt"		
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
	w "检验编码	检验名称	别名	引用标志	备注	操作人员	操作时间	状态"
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
 	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
 	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	
	
	s LabRowId=""
	for
	{ 	
		s LabRowId=$o(^CT.WDT.CDSS.LabInspectionDictD(LabRowId),-1) q:LabRowId="" 
		s LabCode=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),3)	//公司编码
		continue:((code'="")&&($ZCONVERT(LabCode,"U")'[code))
		//s LabCode=$tr(LabCode,",","，")
		s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),4)	//检验项目名称
		continue:((desc'="")&&($ZCONVERT(LabName,"U")'[desc))
		//s LabName=$tr(LabName,",","，")
			
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),18)		//备注
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s QuoteFlag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),19) //引用标志
		continue:(QuoteFlag'[quoteflag)
		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),20)	
		s:KnowledgeTotal="" KnowledgeTotal=0
		s CreateDate=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),21)	//创建时间
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),22)	//创建人员
		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")[opername))
		s Alias=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),23)	//别名
		continue:((aliasname'="")&&($ZCONVERT(Alias,"U")'[aliasname))
		s UseFlag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),24)	//状态
		continue:((state'="")&&(UseFlag'=state))
		
        s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
			
		w !,LabCode_"	"_LabName_"	"_Alias_"	"_QuoteFlag_"	"_Remarks_"	"_CreateUserID_"	"_CreateDate_"	"_UseFlag
			
		
	}
	c file
	q fileName
}

/// Creator：高姗姗
/// CreatDate: 2021-01-26
/// Description:状态修改
/// Input:id useflag(0编辑中,1已删除,2已审核)
/// Table：CT.WDT.CDSS.LabInspectionDict
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).UpdateUseFlag(1,1)
ClassMethod UpdateUseFlag(RowId, Operation) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.LabInspectionDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.LabInspectionDict).%New()
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
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("检验",obj.LabCode_"[A]"_obj.LabName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){ 
            s lineI=obj.LabName_",识别条件,主要条件-识别词,1,检验项目名称,"_obj.LabName_",0"
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabInspectionDict","CT.WDT.CDSS.LabInspectionDict","检验项目字典",RowId,obj.LabName_"&&"_Operation,"U",eobj,bobj)	
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
/// Table: CT.WDT.CDSS.DocuManage
/// Input: id-检验表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabInspectionDictDetail","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s LabAlias = $lg($g(^CT.WDT.CDSS.LabInspectionDictD(id)),23)
		s Len=$Length(LabAlias,",")
		for i=1:1:Len{
			s Desc=$p(LabAlias,",",i)
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
/// Table：CT.WDT.CDSS.LabInspectionDict
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).BatchChangeCode()
ClassMethod BatchChangeCode() As %String
{
	s ID=0
	s code=0
	s count=0 		//总处理数
	s failcount=0	//失败数
	for
	{
		s ID=$o(^CT.WDT.CDSS.LabInspectionDictD(ID))
		q:ID=""
		s code=code+1
		s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(ID)
		s OldCode=obj.LabCode
		
		s obj.LabCode=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(code,5)
		s sc=obj.%Save()
		d obj.%Close()
		TS
		If $$$ISOK(sc)
		{
			tc
			s count=count+1
			
			//调用字典对照接口
			d ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验", OldCode_"[A]"_obj.LabName,obj.LabCode_"[A]"_obj.LabName)
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
/// Other:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	//s LabInspectionID=0
	
	s Code=$o(^CT.WDT.CDSS.LabInspectionDictD(""),-1)
	
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

/// Creator:丁亚男
/// CreatDate:2021-07-22
/// Description：处理检验数据（新增或者删除）检验项目表拆分为检验项目和检验医嘱
/// Table：CT.WDT.CDSS.LabInspectionDict/CT.WDT.CDSS.LabOrdersDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.LabInspectionDictDetail).DealLabData("D:\更新文件\丁亚男\20210723\检验字典数据-大小项拆分-0721.csv")
ClassMethod DealLabData(filepath)
{
	s delcount=0,labcount=0,labordercount=0
	s file=##class(%File).%New(filepath)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s LabCode=$p(Line,",",1)
		s LabName=$p(Line,",",2)
		s Type=$p(Line,",",3) //检验项目 检验医嘱
		s Operate=$p(Line,",",4) //操作
		s Alias=$p(Line,",",5)
		s Remarks=$p(Line,",",6)
		s LabName=$tr(LabName,"，",",")
		s Alias=$tr(Alias,"，",",")
		if (Operate="删除")
		{
			s LabRowId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"),0))
			if (LabRowId'="")
			{
				s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(LabRowId)
				s obj.UseFlag=1
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					Tc
					s delcount=delcount+1
				}
				else
				{
					Trollback
					w !,LabName_"删除失败！"
				}
			}
			else
			{
				w !,LabName_"不存在，不用删除！"
			}
		}
		else //需要保留的数据
		{
			if (Type="检验医嘱")
			{
				//在检验项目表删除该项目
				s LabRowId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"),0))
				if (LabRowId'="")
				{
					s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(LabRowId)
					s obj.UseFlag=1
					Ts
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s delcount=delcount+1
					}
					else
					{
						Trollback
						w !,LabName_"删除失败！"
					}
				}
				else
				{
					w !,LabName_"不存在，不用删除！"
				}
				//在检验医嘱表增加此项目
				if ('$d(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(LabName,"U"))))
				{
					s Code=$o(^CT.WDT.CDSS.LabOrdersDictD(""),-1)+1
					s:Code="" Code=1 
					s obj=##class(CT.WDT.CDSS.LabOrdersDict).%New()
					s obj.LabOrdersCode=Code
					s obj.LabOrdersDesc=LabName
					s obj.Alias=Alias
					
					s obj.UseFlag=0
					s obj.UpdateUser="dhcc"
					s obj.UpdateDate=$zdt($h,3)
					s obj.Remarks=Remarks
					
					Ts
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						Tc
						s labordercount=labordercount+1
					}
					else
					{
						Tro
						w !, LabName_"检验医嘱导入失败"
					}
				}
				
			}
			else
			{
				//存在检验项目并且别名不为空，修改别名
				if ($d(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"))))&&(Alias'="")
				{
					s LabRowId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"),0))
					if (LabRowId'="")
					{
						s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(LabRowId)
						s obj.Alias=Alias
						Ts
						s sc=obj.%Save()
						d obj.%Close()
						If $$$ISOK(sc)
						{
							Tc
							s labcount=labcount+1
						}
						else
						{
							Trollback
							w !,LabName_"别名新增失败！"
						}
					}
					
				}
				elseif '$d(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U")))
				{
					s Code=$o(^CT.WDT.CDSS.LabInspectionDictD(""),-1)
					s:Code="" Code=1 
					s obj=##class(CT.WDT.CDSS.LabInspectionDict).%New()
					s obj.LabCode=Code
					s obj.LabName=LabName
					s obj.LabNamePinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(LabName,3)	//汉语拼音
					s obj.LabNameFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(LabName)	//汉语首拼
					s obj.Remarks=Remarks		//备注
					s obj.Alias=Alias
					s obj.CreateDate=$zdt($h,3)
					s obj.CreateUserID="dhcc"
					s obj.UseFlag=0
					
					
					Ts
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						Tc
						s labcount=labcount+1
					}
					else
					{
						Tro
						w !, LabName_"检验项目导入失败"
					}
					
				}		
				
			}
		}
	}
	
	q delcount_"条数据删除成功！"_labcount_"条检验项目导入成功！"_labordercount_"条检验医嘱导入成功！"
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-19
/// Description: 批量通过
/// Table: CT.WDT.CDSS.LabInspectionDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).ChangeStatusPass("")
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
/// CreatDate: 2021-10-19
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.LabInspectionDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).ChangeStatusBack("")
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
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.LabInspectionDict
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.LabInspectionDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(RowId)),23)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabInspectionDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.LabInspectionDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.LabInspectionDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.LabInspectionDictD(RowId)),24)       
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

/// Creator：杨继鸿
/// CreatDate: 2022-03-02
/// Description：查询 检验项目字典 检验医嘱字典
/// Table：CT.WDT.CDSS.LabInspectionDict、CT.WDT.CDSS.LabOrdersDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabInspectionDictDetail","GetDataForLabOrder","","","")
Query GetDataForLabOrder(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "LabID:%String,LabName:%String,DictType:%String")
{
}

ClassMethod GetDataForLabOrderExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s LabID=rowid
		s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabID)),4)
		d OutputRowCmb
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		//遍历检验项目字典
		s itemID=0
		for 
		{
			s itemID=$o(^CT.WDT.CDSS.LabInspectionDictD(itemID))
			q:itemID=""
			s LabName=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(itemID)),4)		//名称
			s length=$l(LabName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,"itemDict",itemID)=itemID
		}
		//遍历检验医嘱字典
		s orderID=0
		for 
		{
			s orderID=$o(^CT.WDT.CDSS.LabOrdersDictD(orderID))
			q:orderID=""
			s LabOrdDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(orderID)),3)		//名称
			s length=$l(LabOrdDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,"orderDict",orderID)=orderID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s dict=""
			for
			{
				s dict=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,dict))
				q:dict=""
				s id=""
				for
				{
					s id=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,dict,id))
					q:id=""
					
					s LabID=id
					if (dict="itemDict")
					{
						s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(id)),4)
						s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(id)),24)
						s DictType="LabInspectionDict"
					}
					else
					{
						s LabName=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(id)),3)
						s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(id)),5)
						s DictType="LabOrdersDict"
					}
					if (($ZCONVERT(LabName,"U")[desc))&(($ZCONVERT(LabName,"U")[q)&(UseFlag="2"))
					{
						d OutputRowCmb
					}
					continue:((desc'="")||(q'=""))
					s num=num+1
					q:num=1000
				}
				q:num=1000
			}
			q:num=1000
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(LabID,LabName,DictType)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDataForLabOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForLabOrderExecute ]
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

ClassMethod GetDataForLabOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForLabOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：赵文伟
/// CreatDate: 2022-04-07
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.LabInspectionDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.LabInspectionDictDetail).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.LabInspectionDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.LabRowId,eobj.LabCode,eobj.LabName) //校验重复
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.LabRowId,eobj.LabName,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.LabRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.LabInspectionDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(eobj.LabRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.LabInspectionDict).%New()
			s bobj.LabCode = obj.LabCode  
			s bobj.LabName = obj.LabName 
			s bobj.Alias = obj.Alias 
			s bobj.CreateDate=obj.CreateDate		//创建时间
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			
		}
		s obj.LabCode = eobj.LabCode  
		s obj.LabName = eobj.LabName 
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
			d:eobj.LabRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabInspectionDict","CT.WDT.CDSS.LabInspectionDict","检验项目字典",id,eobj.LabName,"A",eobj)
			d:eobj.LabRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabInspectionDict","CT.WDT.CDSS.LabInspectionDict","检验项目字典",id,eobj.LabName,"U",eobj,bobj)
			
			//[新]检验百科增加一条同名数据    2021-11-25
			d:eobj.LabRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabName,"")
			d:eobj.LabRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabName,bobj.LabName)
			
			//调用字典对照接口
			d:eobj.LabRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验", bobj.LabCode_"[A]"_bobj.LabName,eobj.LabCode_"[A]"_eobj.LabName)
			
			//同步修改识别词项目数据    2021-11-25
			d:eobj.LabRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("检验项目名称",eobj.LabName,bobj.LabName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.LabRowId="")&&(eobj.Alias'=""))||((eobj.LabRowId'="")&&(eobj.Alias'=bobj.Alias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabInspectionDict",id,eobj.Alias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验项目字典","web.CDSS.CMKB.LabInspectionDictDetail","SaveAmendData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验项目字典","web.CDSS.CMKB.LabInspectionDictDetail","SaveAmendData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabInspectionDictDetail","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.LabInspectionDict",RowId,LogID),-1) q:LogID=""
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
/// Description：转存检验项目字典数据到检验百科【百科中不存在的数据】
/// Table：CT.WDT.CDSS.LabInspectionDict	检验项目字典
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.LabInspectionDictDetail).TransferSaveData()
ClassMethod TransferSaveData() As %String
{
	s LabRowId=""
	s count=0
	for
	{ 	
		s LabRowId=$o(^CT.WDT.CDSS.LabInspectionDictD(LabRowId),-1) q:LabRowId=""
		s LabName=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),4)	//检验项目名称
		s UseFlag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),24)	//状态
		continue:(UseFlag=1)	//过滤已弃用数据
		s BaseDR=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_"检验",0))
		if (BaseDR'="")
		{
			//如果百科中不存在，调用接口保存
			if ('$d(^CT.WDT.CDSS.TermI("DescIndex",BaseDR," "_($ZCONVERT(LabName,"U")))))	
			{
				//w LabName
				d ##class(web.CDSS.CMKB.Term).SaveTerm("检验",LabName,"")
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
/// Table: 检验项目字典
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.LabInspectionDictDetail).ImportAliasData("D:\ZWW\检验项目新增别名 - 副本.txt")
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
		
		s LabName=$p(data,$c(9),1)	//名称
		s Alias=$p(data,$c(9),2)		//别名
		s flag=0
		s RowId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"),0))
		//TS
		if (RowId'=""){
		
			s obj=##class(CT.WDT.CDSS.LabInspectionDict).%OpenId(RowId)
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
		            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabInspectionDict",id,obj.Alias)
		            }
		            d obj.%Close()
		            //TC
				}
				else
				{
					s result = "{success:'false'}"
					//TRO
				}
				
				if (result["true")
				{
					s savecount=savecount+1
				}
				else
				{
					s nosavecount=nosavecount+1
					w !,LabName_"^"_Alias_" 保存失败"
				}
			}else{
				w !,LabName_"^"_Alias_" 存在重复别名"
				//TRO
			}
			
		}else{
			w !,LabName_"不存在"
			//TRO
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
/// Description：导出检验项目字典表重复的别名数据
/// Other:w ##class(web.CDSS.CMKB.LabInspectionDictDetail).ExportRepeatAlisaData()
ClassMethod ExportRepeatAlisaData()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检验项目重复别名数据.txt"		
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
	w "存在重复的别名	对应的检验名称	对应重复数据名称"
	
	s LabRowId=""
	for
	{ 	
		s LabRowId=$o(^CT.WDT.CDSS.LabInspectionDictD(LabRowId),-1) q:LabRowId="" 
		s LabCode=$LISTGET($G(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),3)	//公司编码
		s LabName=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),4)		//名称
		s Alias=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabRowId)),23)	//别名
		
		s flag=0
		s len = $l(Alias,",")
		for i=1:1:len
		{
			s OneAlias=$p(Alias,",",i)
			if (OneAlias'=""){
				s AliasId=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabInspectionDict",OneAlias,LabRowId,0))
					/*s flagN=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(OneAlias,"U"),0))
					
					if ((flagN'="")&&(flagN'=LabRowId)){	//当前别名与名称重复
						s Name=LabName
						
						w !,OneAlias_"	"_LabName_"	"_Name
					}
					s flagA=$o(^CT.WDT.CDSS.AliasI("TableAliasIndex","CT.WDT.CDSS.LabInspectionDict",OneAlias,0))	
					
					if ((flagA'="")&&(flagA'=AliasId)){	//当前别名与其他别名重复
						s DataReference=$lg($g(^CT.WDT.CDSS.AliasD(flagA)),4)
						s Name=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(DataReference)),4)
						
						w !,OneAlias_"	"_LabName_"	"_Name
					}*/	
				s flagN=""
				for {
					s flagN=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(OneAlias,"U"),flagN))
					q:flagN=""
					if ((flagN'="")&&(flagN'=LabRowId)){	//当前别名与名称重复
						s Name=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(flagN)),4)
						w !,OneAlias_"	"_LabName_"	"_Name
					}
				}
				s flagA=""
				for {
					s flagA=$o(^CT.WDT.CDSS.AliasI("TableAliasIndex","CT.WDT.CDSS.LabInspectionDict",OneAlias,flagA))	
					q:flagA=""
					if ((flagA'="")&&(flagA'=AliasId)){	//当前别名与其他别名重复
						s DataReference=$lg($g(^CT.WDT.CDSS.AliasD(flagA)),4)
						s Name=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(DataReference)),4)
						
						w !,OneAlias_"	"_LabName_"	"_Name
					}
				}
			}
		}
	}
	c file
	q fileName
}

}

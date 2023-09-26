/// Description：输血品字典表  
/// Table：CT.WDT.CDSS.BloodProductDict
Class web.CDSS.CMKB.BloodProductDictDetail Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-06-20
/// Description：查询输血品字典
/// Table：CT.WDT.CDSS.BloodProductDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BloodProductDictDetail","GetList","","","","","","","","","","","","UpdateDate")
Query GetList(rowid, code, desc, alias, quoteflag, state, bpclassdr, operuser, starttime, endtime, remarks, sortmethod) As %Query(ROWSPEC = "BPRowId,BPNationCode,BPCode,BPName,BPOverview,BPNamePinyin,BPNameFirstPinyin,BPEnglishName,BPClassCodeDR,BPClassName,BloodTypeDesc,IndicationDesc,TabooDesc,PrecautionDesc,AdverseReactionsDesc,DiseaseDesc,ComplicationDesc,SubstituteDesc,QuoteFlag,KnowledgeTotal,UpdateDate,UpdateUser,UseFlag,Remarks,BPAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, alias, quoteflag, state, bpclassdr, operuser, starttime, endtime, remarks, sortmethod) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s BPRowId=rowid
	s BPNationCode=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),2)
	s BPCode=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),3)
	s BPName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),4)
	s BPOverview=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),5)
	s BPNamePinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),6)
	s BPNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),7)
	s BPEnglishName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),8)	
	s BPClassCodeDR=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),9)
	s BPClassName=""
	s:BPClassCodeDR'="" BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassCodeDR)),3)	
	s BloodTypeDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),10)
	s IndicationDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),11)
	s TabooDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),12)
	s PrecautionDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),13)
	s AdverseReactionsDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),14)
	s DiseaseDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),15)
	s ComplicationDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),16)
	s SubstituteDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),17)
	s QuoteFlag=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),18)	//引用标志
	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),19)	//知识数量
	s:KnowledgeTotal="" KnowledgeTotal=0
	s UpdateDate=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),20)	//更新时间
	s UpdateUser=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),21)	//更新人员
	s UseFlag=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),22)	//使用标识（0编辑中，1已弃用，2已审核）
	s Remarks=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),23)	//备注
	s BPAlias=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),24)	//别名
	d OutputRow
 }
 else
 {
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:operuser'="" operuser=$ZCONVERT(operuser,"U") //转换成大写 
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.BloodProductDictD(ID)) q:ID=""
			s BPName= $lg($g(^CT.WDT.CDSS.BloodProductDictD(ID)),3)		//名称
			s length=$l(BPName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.BloodProductDictD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.BloodProductDictD(ID)),20)			//编辑时间
			s:UpdateDate="" UpdateDate="2021-01-01"
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",UpdateDate,ID)=ID
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
		s BPRowId=0
		for
		{
			s BPRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,BPRowId)) q:BPRowId=""
	
			s BPNationCode=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),2)
			s BPCode=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),3)
			s BPName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),4)
			s BPOverview=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),5)
			s BPNamePinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),6)
			s BPNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),7)
			s BPEnglishName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),8)	
			s BPClassCodeDR=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),9)
			s BPClassName=""
			s:BPClassCodeDR'="" BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassCodeDR)),3)
			continue:((bpclassdr'="")&&(BPClassCodeDR'=bpclassdr))	
			s BloodTypeDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),10)
			s IndicationDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),11)
			s TabooDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),12)
			s PrecautionDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),13)
			s AdverseReactionsDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),14)
			s DiseaseDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),15)
			s ComplicationDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),16)
			s SubstituteDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),17)
			s QuoteFlag=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),18)	//引用标志
			continue:(QuoteFlag'[quoteflag)
			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
			s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),19)	//知识数量
			s:KnowledgeTotal="" KnowledgeTotal=0
			
			s UpdateDate=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),20)	//更新时间
			s:UpdateDate="" UpdateDate="2021-01-01 00:00:00"
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
			s UpdateUser=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),21)	//更新人员
			continue:((operuser'="")&&($ZCONVERT(UpdateUser,"U")'[operuser))
			s UseFlag=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),22)	//使用标识（0编辑中，1已弃用，2已审核）
			s:UseFlag="" UseFlag=0
			continue:((state'="")&&(UseFlag'=state))
			continue:((state="")&&(UseFlag="1"))
			s Remarks=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),23)	//备注
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
			s BPAlias=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),24)	//别名
			continue:((alias'="")&&($ZCONVERT(BPAlias,"U")'[alias))

			if (($ZCONVERT(BPName,"U")[desc)||($ZCONVERT(BPNameFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(BPCode,"U")[code)
			{
				d OutputRow
			}
		}
	}
		
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(BPRowId,BPNationCode,BPCode,BPName,BPOverview,BPNamePinyin,BPNameFirstPinyin,BPEnglishName,BPClassCodeDR,BPClassName,BloodTypeDesc,IndicationDesc,TabooDesc,PrecautionDesc,AdverseReactionsDesc,DiseaseDesc,ComplicationDesc,SubstituteDesc,QuoteFlag,KnowledgeTotal,UpdateDate,UpdateUser,UseFlag,Remarks,BPAlias)
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
/// CreatDate:2020-7-8
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.BloodProductDict
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.BloodProductDictDetail).FormValidate("","1111","1111","100.02")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, nationcode As %String) As %String
{
	
	s flag=0
	if ($ZCONVERT(nationcode,"U")'="")	//校验国家编码重复
    {
        s idnc=0
        for
        {
            s idnc=$o(^CT.WDT.CDSS.BloodProductDictI("NationCodeIndex"," "_$ZCONVERT(nationcode,"U"),idnc)) q:idnc=""
            if (idnc'=id)	//重复
            {
				s flag=1
            }
        }
    }
    if ($ZCONVERT(code,"U")'="")	//校验代码重复
    {
        s idc=0
        for
        {
            s idc=$o(^CT.WDT.CDSS.BloodProductDictI("CodeIndex"," "_$ZCONVERT(code,"U"),idc)) q:idc=""
            if (idc'=id)	//重复
            {
				s flag=1
            }
        }
    }
    if ($ZCONVERT(desc,"U")'="")	//校验代码重复
    {
        s idd=0
        for
        {
            s idd=$o(^CT.WDT.CDSS.BloodProductDictI("NameIndex"," "_$ZCONVERT(desc,"U"),idd)) q:idd=""
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
/// w ##class(web.CDSS.CMKB.BloodProductDictDetail).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.BloodProductDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.BloodProductDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.BloodProductDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.BloodProductDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// Table：CT.WDT.CDSS.BloodProductDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.BloodProductDictDetail).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.BloodProductDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.BPRowId,eobj.BPCode,eobj.BPName,eobj.BPNationCode)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.BPRowId,eobj.BPName,eobj.BPAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.BPRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.BloodProductDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.BloodProductDict).%OpenId(eobj.BPRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.BloodProductDict).%New()
			s bobj.BPNationCode = obj.BPNationCode  
			s bobj.BPCode = obj.BPCode  
			s bobj.BPName = obj.BPName 
			s bobj.BPOverview = obj.BPOverview  
			s bobj.BPNamePinyin = obj.BPNamePinyin 
			s bobj.BPNameFirstPinyin = obj.BPNameFirstPinyin
			s bobj.BPEnglishName = obj.BPEnglishName 
			s:obj.BPClassCodeDR'="" bobj.BPClassCodeDR = obj.BPClassCodeDR.%Id()
			
			s bobj.BloodTypeDesc = obj.BloodTypeDesc  
			s bobj.IndicationDesc = obj.IndicationDesc  
			s bobj.TabooDesc = obj.TabooDesc 
			s bobj.PrecautionDesc = obj.PrecautionDesc  
			s bobj.AdverseReactionsDesc = obj.AdverseReactionsDesc 
			s bobj.DiseaseDesc = obj.DiseaseDesc
			s bobj.ComplicationDesc = obj.ComplicationDesc
			s bobj.SubstituteDesc = obj.SubstituteDesc
			
			s bobj.QuoteFlag = obj.QuoteFlag	//引用标志
			s bobj.KnowledgeTotal = obj.KnowledgeTotal	//知识数量
			
			s bobj.UpdateDate=obj.UpdateDate	//更新时间
			s bobj.UpdateUser=obj.UpdateUser	//更新人员
			s bobj.UseFlag=obj.UseFlag	//使用标识（0编辑中，1已弃用，2已审核）
			s bobj.Remarks=obj.Remarks	//备注
			s bobj.BPAlias=obj.BPAlias	//别名
		}	
		s obj.BPNationCode = eobj.BPNationCode  
		s obj.BPCode = eobj.BPCode  
		s obj.BPName = eobj.BPName 
		s obj.BPOverview = eobj.BPOverview  
		s obj.BPNamePinyin = eobj.BPNamePinyin 
		s obj.BPNameFirstPinyin = eobj.BPNameFirstPinyin
		s obj.BPEnglishName = eobj.BPEnglishName 
		d:eobj.BPClassCodeDR'="" obj.BPClassCodeDRSetObjectId(eobj.BPClassCodeDR)  
		d:eobj.BPClassCodeDR="" obj.BPClassCodeDRSetObjectId("")  
		s obj.BloodTypeDesc = eobj.BloodTypeDesc  
		s obj.IndicationDesc = eobj.IndicationDesc  
		s obj.TabooDesc = eobj.TabooDesc 
		s obj.PrecautionDesc = eobj.PrecautionDesc  
		s obj.AdverseReactionsDesc = eobj.AdverseReactionsDesc 
		s obj.DiseaseDesc = eobj.DiseaseDesc
		s obj.ComplicationDesc = eobj.ComplicationDesc
		s obj.SubstituteDesc = eobj.SubstituteDesc	
		s obj.UpdateDate=eobj.UpdateDate	//更新时间
		s obj.UpdateUser=eobj.UpdateUser	//更新人员
		s obj.UseFlag=eobj.UseFlag	//使用标识（0编辑中，1已弃用，2已审核）
		s obj.Remarks=eobj.Remarks
		s obj.BPAlias=eobj.BPAlias	//别名
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.BPRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BloodProductDict","CT.WDT.CDSS.BloodProductDict","输血品字典",id,eobj.BPName,"A",eobj)
			d:eobj.BPRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BloodProductDict","CT.WDT.CDSS.BloodProductDict","输血品字典",eobj.BPRowId,eobj.BPName,"U",eobj,bobj)		
			
			//同步修改对照数据
			d:eobj.BPRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("输血品",bobj.BPCode_"[A]"_bobj.BPName,eobj.BPCode_"[A]"_eobj.BPName) 
		
			//同步修改识别词项目数据
			d:eobj.BPRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("输血品名称",eobj.BPName,bobj.BPName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.BPRowId="")&&(eobj.BPAlias'=""))||((eobj.BPRowId'="")&&(eobj.BPAlias'=bobj.BPAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BloodProductDict",id,eobj.BPAlias)
            }
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品字典","web.CDSS.CMKB.BloodProductDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品字典","web.CDSS.CMKB.BloodProductDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2020-06-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.BloodProductDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.BloodProductDictDetail).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.BloodProductDict).%OpenId(id)
	s bobj =##class(web.CDSSEntity.CMKB.BloodProductDict).%New()
	s bobj.BPNationCode = obj.BPNationCode  
	s bobj.BPCode = obj.BPCode  
	s bobj.BPName = obj.BPName 
	s bobj.BPOverview = obj.BPOverview  
	s bobj.BPNamePinyin = obj.BPNamePinyin 
	s bobj.BPNameFirstPinyin = obj.BPNameFirstPinyin
	s bobj.BPEnglishName = obj.BPEnglishName 
	s bobj.BPClassCodeDR="",bobj.BPClassDesc=""
	s:obj.BPClassCodeDR'="" bobj.BPClassCodeDR = obj.BPClassCodeDR.%Id()
	s:obj.BPClassCodeDR'="" bobj.BPClassDesc = $LISTGET($G(^CT.WDT.CDSS.BPClassDictD(bobj.BPClassCodeDR)),3)
	
	s bobj.BloodTypeDesc = obj.BloodTypeDesc  
	s bobj.IndicationDesc = obj.IndicationDesc  
	s bobj.TabooDesc = obj.TabooDesc 
	s bobj.PrecautionDesc = obj.PrecautionDesc  
	s bobj.AdverseReactionsDesc = obj.AdverseReactionsDesc 
	s bobj.DiseaseDesc = obj.DiseaseDesc
	s bobj.ComplicationDesc = obj.ComplicationDesc
	s bobj.SubstituteDesc = obj.SubstituteDesc
	
	s bobj.QuoteFlag = obj.QuoteFlag	//引用标志
	s bobj.KnowledgeTotal = obj.KnowledgeTotal	//知识数量
	
	s bobj.UpdateDate=obj.UpdateDate	//更新时间
	s bobj.UpdateUser=obj.UpdateUser	//更新人员
	s bobj.UseFlag=obj.UseFlag	//使用标识（0编辑中，1已弃用，2已审核）
	s bobj.Remarks=obj.Remarks
	s bobj.BPAlias=obj.BPAlias	//别名
	d obj.%Close()	
	k obj	
	s str = bobj.JsonS()	
	q str
}

/// Creator：钟荣枫
/// CreatDate: 2020-08-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.BloodProductDictDetail).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
    s BPName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(id)),4)
	
	//诊疗规则引用接口 2023-02-28
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("输血",BPName) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("输血",BPName) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
    //识别词项目引用接口
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("输血品名称",BPName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	//字典对照引用接口
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("输血品",BPName)
	if Mappinginfo'="" s myInfo=myInfo_Mappinginfo
    
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用"
 	q return
}

/// Creator:丁亚男
/// CreatDate:2020-06-18
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.BloodProductDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.BloodProductDictDetail).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(CT.WDT.CDSS.BloodProductDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.BloodProductDict).%New()
	s bobj.BPNationCode = obj.BPNationCode  
	s bobj.BPCode = obj.BPCode  
	s bobj.BPName = obj.BPName 
	s bobj.BPOverview = obj.BPOverview  
	s bobj.BPNamePinyin = obj.BPNamePinyin 
	s bobj.BPNameFirstPinyin = obj.BPNameFirstPinyin
	s bobj.BPEnglishName = obj.BPEnglishName 
	s:obj.BPClassCodeDR'="" bobj.BPClassCodeDR = obj.BPClassCodeDR.%Id()
	
	s bobj.BloodTypeDesc = obj.BloodTypeDesc  
	s bobj.IndicationDesc = obj.IndicationDesc  
	s bobj.TabooDesc = obj.TabooDesc 
	s bobj.PrecautionDesc = obj.PrecautionDesc  
	s bobj.AdverseReactionsDesc = obj.AdverseReactionsDesc 
	s bobj.DiseaseDesc = obj.DiseaseDesc
	s bobj.ComplicationDesc = obj.ComplicationDesc
	s bobj.SubstituteDesc = obj.SubstituteDesc
		
	s bobj.QuoteFlag = obj.QuoteFlag	//引用标志
	s bobj.KnowledgeTotal = obj.KnowledgeTotal	//知识数量
	s bobj.UpdateDate=obj.UpdateDate	//更新时间
	s bobj.UpdateUser=obj.UpdateUser	//更新人员
	s bobj.UseFlag=obj.UseFlag	//使用标识（0编辑中，1已弃用，2已审核）
	s bobj.Remarks=obj.Remarks	//备注
	s bobj.BPAlias=obj.BPAlias	//别名
	Ts
	//同步删除对照数据 2022-01-21
	s re = ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("输血品",obj.BPCode_"[A]"_obj.BPName)
	if (re="true[A]true"){
		
		s sc=##class(CT.WDT.CDSS.BloodProductDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BloodProductDict","CT.WDT.CDSS.BloodProductDict","输血品字典",id,bobj.BPName,"D",bobj)
			//同步删除别名通用表中数据 
			d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT_WDT_CDSS.BloodProductDict",id)
					
			d bobj.%Close()	
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品字典","web.CDSS.CMKB.BloodProductDictDetail","DeleteData",bobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	} else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-05
/// Description：查询 输血品
/// Table：CT.WDT.CDSS.BloodProductDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BloodProductDictDetail","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "BPRowId:%String,BPName:%String,BPDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s BPRowId=rowid
		s BPName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),4)
		d OutputRowCmb
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.BloodProductDictD(ID))
			q:ID=""
			s BPName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(ID)),4)	//名称
			s length=$l(BPName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s BPRowId=0
			for
			{
				s BPRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,BPRowId))
				q:BPRowId=""
				s BPDR=BPRowId
				s BPName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),4)
	  			s QuoteFlag=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),18)	//引用标志
	  			//continue:(QuoteFlag'[quoteflag)
	  			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	  			s BPNamePinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),6)
	  			s BPNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),7)
	  			s UseFlag=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),22)
	  			if ((($ZCONVERT(BPName,"U")[desc)||(BPNamePinyin[desc)||(BPNameFirstPinyin[desc))&(($ZCONVERT(BPName,"U")[q)||(BPNamePinyin[q)||(BPNameFirstPinyin[q))&(UseFlag=2)) {
	  				d OutputRowCmb
		  		}
		  		continue:((desc'="")||(q'=""))
		        s num=num+1
		        q:num=1000
			}
			q:num=1000
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(BPRowId,BPName,BPDR)
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

/// Creator:钟荣枫
/// CreatDate:2020-7-2
/// Description:获取引用标志对应的中文
/// Input: QuoteFlag 引用str
/// Return:描述
/// Other:w ##class(web.CDSS.CMKB.BloodProductDictDetail).GetQuoteFlag("D,K,R")
ClassMethod GetQuoteFlag(QuoteFlag)
{
	/// 引用标志  K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照;W（Warning）被预警规则库引用
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
		if QuoteFlag["W"	//被预警规则库引用
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
/// CreatDate:2020-06-17
/// Editor: 赵文伟 2022-06 【修改百科、字典对照2.0；添加预警规则】
/// Description:生成知识数量保存在输血品字典的表，当数据大于0时，修改标识
/// Table: CT.WDT.CDSS.BloodProductDict
/// Input: id 输血品字典表id
/// Return:
/// others:w ##class(web.CDSS.CMKB.BloodProductDictDetail).CreateDetailCount()
ClassMethod CreateDetailCount()
{
	s CDSSRowId=0
	for
	{
 		s CDSSRowId = $o(^CT.WDT.CDSS.BloodProductDictD(CDSSRowId)) q:CDSSRowId=""
 		
 		s obj=##class(CT.WDT.CDSS.BloodProductDict).%OpenId(CDSSRowId)
 		s QuoteFlag = obj.QuoteFlag
 		s BPCode = obj.BPCode  
		s BPName = obj.BPName 
		
		;K（Knowledge） 被医为百科引用
		if (basedr'="")
		{
			if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(BPName,"U")))))
			{
				s termdr=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(BPName,"U")),""))
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
						s obj.QuoteFlag = ..RemoveQuoteFlag(obj.QuoteFlag,"K")	
					}
				}
			}
		}
		s QuoteFlag = obj.QuoteFlag
		;M（Mapping）数据对照2.0

		s ContrastType="输血品"
		s MappingFlag=0
		s ContrastDictDR=""

		if ($d(^CT.WDT.CDSS.ContrastDictI("ContrastDictIndex"," "_BPName,ContrastType,CDSSRowId))) s MappingFlag=1
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
				s obj.QuoteFlag = ..RemoveQuoteFlag(obj.QuoteFlag,"M")
			}
		
		s QuoteFlag = obj.QuoteFlag
		s Exist =##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.CDSS.CMKB.RuleTrigger")
		if (Exist="1"){
			;R（Rule） 被规则知识库引用
			s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("输血品",BPName) //被诊疗规则引用判断
			s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("输血品",BPName) //被诊疗子规则引用判断
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
				s obj.QuoteFlag = ..RemoveQuoteFlag(obj.QuoteFlag,"R")
			}
			s QuoteFlag = obj.QuoteFlag
		}
		;W（Warning）被预警规则库引用
		s WarningFlag=0
		s Flag=##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("输血品",BPName,CDSSRowId) //被预警规则库（输血预警）引用判断
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
			s obj.QuoteFlag = ..RemoveQuoteFlag(obj.QuoteFlag,"W")	
		}
		s sc=obj.%Save()
		d obj.%Close()	
			
	}
	q "输血品数据处理完成！"
}

/// Creator:钟荣枫
/// CreatDate:2020-09-10
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.BloodProductDictDetail).RemoveQuoteFlag("","R")
ClassMethod RemoveQuoteFlag(OldFlag, RemoveFlag)
{
	s OldFlag = ##class(web.BDP.util.String).Replace(OldFlag,RemoveFlag_",","")
	s OldFlag = ##class(web.BDP.util.String).Replace(OldFlag,","_RemoveFlag,"")
	s OldFlag = ##class(web.BDP.util.String).Replace(OldFlag,RemoveFlag,"")
	q OldFlag
}

/// Creator:赵文伟
/// CreatDate:2021-11-30
/// Input:RowId  Operation 操作
/// Return:
/// Other:w ##class(web.CDSS.CMKB.BloodProductDictDetail).ChangeStatus(182,"")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.BloodProductDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.BloodProductDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.BloodProductDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//同步删除对照数据【当状态变为已弃用或驳回时】	2022-04-08 ZWW
		if (obj.UseFlag= "1")||(obj.UseFlag="0"){ 	
		d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("输血品",obj.BPCode_"[A]"_obj.BPName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){ 
	        s lineI=obj.BPName_",识别条件,主要条件-识别词,1,输血品名称,"_obj.BPName_",0"
	        d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BloodProductDict","CT.WDT.CDSS.BloodProductDict","输血品字典",RowId,obj.BPName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator：xuwenhu
/// CreatDate: 2021-06-04
/// Description: 批量处理数据，将代码更改为纯数字递增
/// Input:
/// Table：CT.WDT.CDSS.LabSpcimenDict
/// Other: w ##class(web.CDSS.CMKB.BloodProductDictDetail).BatchChangeCode()
ClassMethod BatchChangeCode() As %String
{
	s ID=0
	s code=0
	s count=0 		//总处理数
	s failcount=0	//失败数
	for
	{
		s ID=$o(^CT.WDT.CDSS.BloodProductDictD(ID))
		q:ID=""
		s code=code+1
		s obj=##class(CT.WDT.CDSS.BloodProductDict).%OpenId(ID)
		s OldCode=obj.BPCode													//旧代码
		
		s obj.BPCode=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(code,5)		//新代码
		s sc=obj.%Save()
		d obj.%Close()
		TS
		If $$$ISOK(sc)
		{
			tc
			s count=count+1
			
			//调用字典对照接口
			//d ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("输血品字典", OldCode_"[A]"_obj.SpecimenDesc,obj.SpecimenCode_"[A]"_obj.SpecimenDesc)
		}
		else{
			tro
			s failcount=failcount+1
		}
	}
	q "总处理"_count_"条,失败"_failcount_"条"
}

/// Creator:xuwenhu
/// CreatDate:2021-06-04
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.BloodProductDictDetail).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	//s LabSpecimenID=0
	
	s Code=$o(^CT.WDT.CDSS.BloodProductDictD(""),-1)
	
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

/// Creator：赵文伟
/// CreatDate:2020-11-03
/// Description：导出输血品字典表数据
/// Other:w ##class(web.CDSS.CMKB.BloodProductDictDetail).ExportBloodProductDictTXT()
ClassMethod ExportBloodProductDictTXT(code, desc, alias, quoteflag, bpclassdr, operuser, state, starttime, endtime, remarks) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"输血品字典数据.txt"		
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
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:operuser'="" operuser=$ZCONVERT(operuser,"U") //转换成大写 
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	w "RowID	输血品编码	输血品名称	别名	输血品分类	引用标志	操作时间	操作人员	备注	状态"
	
	s BPRowId=""
		for
		{ 
			s BPRowId=$o(^CT.WDT.CDSS.BloodProductDictD(BPRowId),-1) q:BPRowId="" 
			s BPNationCode=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),2)
			s BPCode=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),3)
			s BPName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),4)
			s BPOverview=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),5)
			s BPNamePinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),6)
			s BPNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),7)
			s BPEnglishName=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),8)	
			s BPClassCodeDR=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),9)
			s BPClassName=""
			s:BPClassCodeDR'="" BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassCodeDR)),3)
			continue:((bpclassdr'="")&&(BPClassCodeDR'=bpclassdr))	
			s BloodTypeDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),10)
			s IndicationDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),11)
			s TabooDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),12)
			s PrecautionDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),13)
			s AdverseReactionsDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),14)
			s DiseaseDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),15)
			s ComplicationDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),16)
			s SubstituteDesc=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),17)
			s QuoteFlag=$LISTGET($G(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),18)	//引用标志
			continue:(QuoteFlag'[quoteflag)
			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
			s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),19)	//知识数量
			s:KnowledgeTotal="" KnowledgeTotal=0
			
			s UpdateDate=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),20)	//更新时间
			s:UpdateDate="" UpdateDate="2021-01-01 00:00:00"
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
			s UpdateUser=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),21)	//更新人员
			continue:((operuser'="")&&($ZCONVERT(UpdateUser,"U")'[operuser))
			s UseFlag=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),22)	//使用标识（0编辑中，1已弃用，2已审核）
			s:UseFlag="" UseFlag=0
			continue:((state'="")&&(UseFlag'=state))
			continue:((state="")&&(UseFlag="1"))
			s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
			s Remarks=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),23)	//备注
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
			s BPAlias=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPRowId)),24)	//别名
			continue:((alias'="")&&($ZCONVERT(BPAlias,"U")'[alias))

			if (($ZCONVERT(BPName,"U")[desc)||($ZCONVERT(BPNameFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(BPCode,"U")[code)
			{
				w !,BPRowId_"	"_BPCode_"	"_BPName_"	"_BPAlias_"	"_BPClassName_"	"_QuoteFlag_"	"_UpdateDate_"	"_UpdateUser_"	"_Remarks_"	"_UseFlag
			}
		}	
	
	c file
	q fileName
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-20
/// Description: 批量通过
/// Table: CT.WDT.CDSS.BloodProductDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.BloodProductDictDetail).ChangeStatusPass("")
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
/// CreatDate: 2021-10-20
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.BloodProductDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.BloodProductDictDetail).ChangeStatusBack("")
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

/// Creator:赵文伟
/// CreatDate:2022-01-17
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.BloodProductDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BloodProductDictDetail","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s BPAlias = $lg($g(^CT.WDT.CDSS.BloodProductDictD(id)),24)
		s Len=$Length(BPAlias,",")
		for i=1:1:Len{
			s Desc=$p(BPAlias,",",i)
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

/// Creator：赵文伟 
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.BloodProductDict
/// Other: w ##class(web.CDSS.CMKB.BloodProductDictDetail).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.BloodProductDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.BloodProductDictD(RowId)),24)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BloodProductDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.BloodProductDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.BloodProductDictDetail).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.BloodProductDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.BloodProductDictD(RowId)),22)       
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
/// CreatDate: 2022-04-08
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.BloodProductDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.BloodProductDictDetail).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.BloodProductDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.BPRowId,eobj.BPCode,eobj.BPName,eobj.BPNationCode)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.BPRowId,eobj.BPName,eobj.BPAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.BPRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.BloodProductDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.BloodProductDict).%OpenId(eobj.BPRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.BloodProductDict).%New()
			s bobj.BPCode = obj.BPCode  
			s bobj.BPName = obj.BPName 
			s bobj.BPAlias = obj.BPAlias 
			s bobj.UpdateDate=obj.UpdateDate		//创建时间
			s bobj.UpdateUser=obj.UpdateUser	//创建人员
			
		}
		s obj.BPCode = eobj.BPCode  
		s obj.BPName = eobj.BPName 
		s obj.BPAlias = eobj.BPAlias 
		s eobj.UpdateDate=$ZDATETIME($H,3)	
		s obj.UpdateDate=eobj.UpdateDate
		s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
		s obj.UpdateUser=eobj.UpdateUser
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.BPRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BloodProductDict","CT.WDT.CDSS.BloodProductDict","输血品字典",id,eobj.BPName,"A",eobj)
			d:eobj.BPRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BloodProductDict","CT.WDT.CDSS.BloodProductDict","输血品字典",eobj.BPRowId,eobj.BPName,"U",eobj,bobj)		
			
			//同步修改识别词项目数据
			d:eobj.BPRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("输血品名称",eobj.BPName,bobj.BPName)
			//同步修改对照数据
			d:eobj.BPRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("输血品",bobj.BPCode_"[A]"_bobj.BPName,eobj.BPCode_"[A]"_eobj.BPName) 
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.BPRowId="")&&(eobj.BPAlias'=""))||((eobj.BPRowId'="")&&(eobj.BPAlias'=bobj.BPAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BloodProductDict",id,eobj.BPAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品字典","web.CDSS.CMKB.BloodProductDictDetail","SaveAmendData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品字典","web.CDSS.CMKB.BloodProductDictDetail","SaveAmendData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BloodProductDictDetail","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.BloodProductDict",RowId,LogID),-1) q:LogID=""
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

}

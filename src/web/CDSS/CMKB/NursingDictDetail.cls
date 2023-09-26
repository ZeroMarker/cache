/// Description：护理字典表 
/// Table：CT.WDT.CDSS.NursingDict
Class web.CDSS.CMKB.NursingDictDetail Extends %RegisteredObject
{

/// Creator：ZWW
/// CreatDate: 2022-09-16
/// Description：查询护理字典
/// Table：CT.WDT.CDSS.NursingDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.NursingDictDetail","GetList","","","","","","","","1","","","CreateDate")
Query GetList(rowid, code As %String, desc As %String, quoteflag As %String, opername As %String, nursingtype As %String, aliasname As %String, state As %String, starttime As %String, endtime As %String, sortmethod As %String) As %Query(ROWSPEC = "NursingRowId,NursingNationCode,NursingCode,NursingName,NursingOverview,NursingNamePinyin,NursingNameFirstPinyin,NursingEnglishName,NursingClassCodeDR,NursingClassName,NursingContent,NursingIndication,NursingTaboo,AdverseReactions,NursingPrecaution,Complication,ChildFlag,QuoteFlag,KnowledgeTotal,CreateDate,CreateUserID,NursingType,UseFlag,NursingAliasName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code As %String, desc As %String, quoteflag As %String, opername As %String, nursingtype As %String, aliasname As %String, state As %String, starttime As %String, endtime As %String, sortmethod As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s NursingRowId=rowid
	s NursingNationCode=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),2)
	s NursingCode=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),3)
	s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),4)
	s NursingOverview=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),5)
	
	s NursingNamePinyin=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),6)
	s NursingNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),7)
	s NursingEnglishName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),8)

	s NursingClassCodeDR=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),9)
	s NursingClassName=""
	//s:NursingClassCodeDR'="" NursingClassName=$LISTGET($G(^CT.WDT.CDSS.NursingClassDictD(NursingClassCodeDR)),3)

	s NursingContent=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),10)
	s NursingIndication=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),11)
	s NursingTaboo=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),12)
	
	s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),13)
	s NursingPrecaution=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),14)
	s Complication=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),15)
	s ChildFlag=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),16)
	
	s QuoteFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),17) //引用标志
	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),18)	//知识数量
	s:KnowledgeTotal="" KnowledgeTotal=0
	
	s CreateDate=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),19)	//创建时间	
	s CreateUserID=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),20)	//创建人员
	s NursingType=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),21)	//类型  护理/处置
	s UseFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),22)	//状态 0 编辑中,1 已删除，2 已审核
	s:UseFlag="" UseFlag=0
	s NursingAliasName=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),23)		//别名
	d OutputRow
 }
 else
 {
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	//默认时间倒序输出
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.NursingDictD(ID))
			q:ID=""
			s NursingName= $lg($g(^CT.WDT.CDSS.NursingDictD(ID)),4)		//名称
			s length=$l(NursingName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.NursingDictD(ID))
			q:ID=""
			s CreateDate= $lg($g(^CT.WDT.CDSS.NursingDictD(ID)),19)				//编辑时间
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
		s NursingRowId=0
		for
		{
			s NursingRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,NursingRowId)) q:NursingRowId=""
			s NursingNationCode=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),2)
			s NursingCode=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),3)
			s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),4)
			s NursingOverview=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),5)
			
			s NursingNamePinyin=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),6)
			s NursingNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),7)
			s NursingEnglishName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),8)

			s NursingClassCodeDR=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),9)
			s NursingClassName=""
			//s:NursingClassCodeDR'="" NursingClassName=$LISTGET($G(^CT.WDT.CDSS.NursingClassDictD(NursingClassCodeDR)),3)

			s NursingContent=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),10)
			s NursingIndication=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),11)
			s NursingTaboo=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),12)
			
			s AdverseReactions=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),13)
			s NursingPrecaution=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),14)
			s Complication=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),15)
			s ChildFlag=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),16)
			
			s QuoteFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),17) //引用标志
			continue:(QuoteFlag'[quoteflag)
			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
			s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),18)	//知识数量
			s:KnowledgeTotal="" KnowledgeTotal=0
			s CreateDate=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),19)	//创建时间	
			s:CreateDate="" CreateDate="2021-01-01 00:00:00"
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
	    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
			s CreateUserID=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),20)	//创建人员
			continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
			s NursingType=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),21)	//类型  护理/处置
			continue:((nursingtype'="")&&(NursingType'=nursingtype))
			s UseFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),22)	//状态 0 编辑中,1 已删除，2 已审核
			s:UseFlag="" UseFlag=0
			if (state=""){
				continue:(UseFlag=1)			
			}
			else{
				continue:((state'="")&&(UseFlag'=state))
			}
			s NursingAliasName=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),23)		//别名
			continue:((aliasname'="")&&($ZCONVERT(NursingAliasName,"U")'[aliasname))
			
			if (($ZCONVERT(NursingName,"U")[desc)||($ZCONVERT(NursingNamePinyin,"U")[desc)||($ZCONVERT(NursingNameFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(NursingCode,"U")[code) 
			{
				d OutputRow
			}
		}
	}
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(NursingRowId,NursingNationCode,NursingCode,NursingName,NursingOverview,NursingNamePinyin,NursingNameFirstPinyin,NursingEnglishName,NursingClassCodeDR,NursingClassName,NursingContent,NursingIndication,NursingTaboo,AdverseReactions,NursingPrecaution,Complication,ChildFlag,QuoteFlag,KnowledgeTotal,CreateDate,CreateUserID,NursingType,UseFlag,NursingAliasName)
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
/// Table：CT.WDT.CDSS.NursingDict
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.NursingDictDetail).FormValidate("","01620","1111","100.01")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, nursingtype As %String) As %String
{
	
#;	s flag=0
#;    
#;    if ($ZCONVERT(desc,"U")'="")	//校验名称重复
#;    {
#;        s idd=0
#;        for
#;        {
#;            s idd=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$ZCONVERT(desc,"U"),idd)) q:idd=""
#;            if (idd'=id)	//重复
#;            {
#;				s flag=1
#;            }
#;        }
#;    }
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	
	s:code'="" flagc=$d(^CT.WDT.CDSS.NursingDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.NursingDictI("NameIndex",desc))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.NursingDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.NursingDictI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	
    if ($ZCONVERT(nursingtype,"U")'="")	//校验类型重复
    {
        s idnc=0
        for
        {
            s idnc=$o(^CT.WDT.CDSS.NursingDictI("NameTypeIndex"," "_$ZCONVERT(desc,"U")," "_$ZCONVERT(nursingtype,"U"),idnc)) q:idnc=""
            if (idnc'=id)	//重复
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
/// w ##class(web.CDSS.CMKB.NursingDictDetail).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.NursingDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.NursingDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.NursingDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.NursingDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// Table：CT.WDT.CDSS.NursingDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.NursingDictDetail).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.NursingDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.NursingRowId,eobj.NursingCode,eobj.NursingName,eobj.NursingType )  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.NursingRowId,eobj.NursingName,eobj.NursingAliasName)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.NursingRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.NursingDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(eobj.NursingRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.NursingDict).%New()
			s bobj.NursingNationCode = obj.NursingNationCode  
			s bobj.NursingCode = obj.NursingCode  
			s bobj.NursingName = obj.NursingName 
			s bobj.NursingOverview = obj.NursingOverview  
			s bobj.NursingNamePinyin = obj.NursingNamePinyin 
			s bobj.NursingNameFirstPinyin = obj.NursingNameFirstPinyin
			s bobj.NursingEnglishName = obj.NursingEnglishName 
			//s:obj.NursingClassCodeDR'="" bobj.NursingClassCodeDR = obj.NursingClassCodeDR.%Id()
			s bobj.NursingClassCodeDR = obj.NursingClassCodeDR 
			s bobj.NursingContent = obj.NursingContent  
			s bobj.NursingIndication = obj.NursingIndication  
			s bobj.NursingTaboo = obj.NursingTaboo 
			
			s bobj.AdverseReactions = obj.AdverseReactions  
			s bobj.NursingPrecaution = obj.NursingPrecaution 
			s bobj.Complication = obj.Complication
			s bobj.ChildFlag = obj.ChildFlag
			s bobj.QuoteFlag = obj.QuoteFlag	//引用标志
			s bobj.KnowledgeTotal = obj.KnowledgeTotal	//知识数量
			
			s bobj.CreateDate=obj.CreateDate	//创建时间	
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			
			s bobj.NursingType=obj.NursingType	//类型  护理/处置
			s bobj.UseFlag=obj.UseFlag	//状态 0 编辑中,1 已删除，2 已审核
			s bobj.NursingAliasName=obj.NursingClassCodeDR		//别名
			
		}
		
		s obj.NursingNationCode = eobj.NursingNationCode  
		s obj.NursingCode = eobj.NursingCode  
		s obj.NursingName = eobj.NursingName 
		s obj.NursingOverview = eobj.NursingOverview  
		s obj.NursingNamePinyin = eobj.NursingNamePinyin 
		s obj.NursingNameFirstPinyin = eobj.NursingNameFirstPinyin
		s obj.NursingEnglishName = eobj.NursingEnglishName 
		//d:eobj.NursingClassCodeDR'="" obj.NursingClassCodeDRSetObjectId(eobj.NursingClassCodeDR)  
		//d:eobj.NursingClassCodeDR="" obj.NursingClassCodeDRSetObjectId("")
		s obj.NursingClassCodeDR = eobj.NursingClassCodeDR 
		s obj.NursingContent = eobj.NursingContent  
		s obj.NursingIndication = eobj.NursingIndication  
		s obj.NursingTaboo = eobj.NursingTaboo 
		
		s obj.AdverseReactions = eobj.AdverseReactions  
		s obj.NursingPrecaution = eobj.NursingPrecaution 
		s obj.Complication = eobj.Complication
		s obj.ChildFlag = eobj.ChildFlag
		
		s obj.QuoteFlag = eobj.QuoteFlag					//引用标志
		s obj.KnowledgeTotal = eobj.KnowledgeTotal			//知识数量
		s obj.CreateDate=eobj.CreateDate					//创建时间	
		s obj.CreateUserID=eobj.CreateUserID				//创建人员
		
		s obj.NursingType=eobj.NursingType					//类型  护理/处置
		s obj.UseFlag=eobj.UseFlag							//状态 0 编辑中,1 已删除，2 已审核
		s obj.NursingAliasName=eobj.NursingAliasName		//别名
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			if (eobj.NursingRowId'="")		//修改时，同步修改对照数据
			{
				s oldstr=bobj.NursingCode_"[A]"_bobj.NursingName
				s newstr=eobj.NursingCode_"[A]"_eobj.NursingName
				d:(oldstr'=newstr) ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("护理", oldstr,newstr)
			}
			//保存日志
			d:eobj.NursingRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.NursingDict","CT.WDT.CDSS.NursingDict","护理字典",id,eobj.NursingName,"A",eobj)
			d:eobj.NursingRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.NursingDict","CT.WDT.CDSS.NursingDict","护理字典",eobj.NursingRowId,eobj.NursingName,"U",eobj,bobj)
			/*
			//护理百科增加一条同名数据
			d:eobj.NursingRowId="" ##class(web.DHCBL.MKB.MKBTerm).SaveTerm("护理",eobj.NursingName,"")
			d:eobj.NursingRowId'="" ##class(web.DHCBL.MKB.MKBTerm).SaveTerm("护理",eobj.NursingName,bobj.NursingName)
			*/
			//[新]护理百科增加一条同名数据
			d:eobj.NursingRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("护理",eobj.NursingName,"")
			d:eobj.NursingRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("护理",eobj.NursingName,bobj.NursingName)
		
			//同步修改识别词项目数据    2021-11-25
			d:eobj.NursingRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("护理项目名称",eobj.NursingName,bobj.NursingName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.NursingRowId="")&&(eobj.NursingAliasName'=""))||((eobj.NursingRowId'="")&&(eobj.NursingAliasName'=bobj.NursingAliasName))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.NursingDict",id,eobj.NursingAliasName)
            }
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("护理字典","web.CDSS.CMKB.NursingDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("护理字典","web.CDSS.CMKB.NursingDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2020-06-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.NursingDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.NursingDict).%New()
	s bobj.NursingNationCode = obj.NursingNationCode  
	s bobj.NursingCode = obj.NursingCode  
	s bobj.NursingName = obj.NursingName 
	s bobj.NursingOverview = obj.NursingOverview  
	s bobj.NursingNamePinyin = obj.NursingNamePinyin 
	s bobj.NursingNameFirstPinyin = obj.NursingNameFirstPinyin
	s bobj.NursingEnglishName = obj.NursingEnglishName 
	//s:obj.NursingClassCodeDR'="" bobj.NursingClassCodeDR = obj.NursingClassCodeDR.%Id()
	s bobj.NursingClassCodeDR = obj.NursingClassCodeDR 
	s bobj.NursingClassDesc=""
	//s:obj.NursingClassCodeDR'="" bobj.NursingClassDesc = $LISTGET($G(^CT.WDT.CDSS.NursingClassDictD(bobj.NursingClassCodeDR)),3)
	
	s bobj.NursingContent = obj.NursingContent  
	s bobj.NursingIndication = obj.NursingIndication  
	s bobj.NursingTaboo = obj.NursingTaboo 
	
	s bobj.AdverseReactions = obj.AdverseReactions  
	s bobj.NursingPrecaution = obj.NursingPrecaution 
	s bobj.Complication = obj.Complication
	s bobj.ChildFlag = obj.ChildFlag
	
	s bobj.QuoteFlag = obj.QuoteFlag	//引用标志
	s bobj.KnowledgeTotal = obj.KnowledgeTotal	//知识数量
	
	s bobj.CreateDate=obj.CreateDate	//创建时间	
	s bobj.CreateUserID=obj.CreateUserID	//创建人员
	
	s bobj.NursingType=obj.NursingType	//类型  护理/处置
	s bobj.UseFlag=obj.UseFlag	//状态 0 编辑中,1 已删除，2 已审核
	s bobj.NursingAliasName=obj.NursingAliasName	//别名
	
	d obj.%Close()	
	k obj
	s str = bobj.JsonS()	
	q str
}

/// Creator：钟荣枫
/// CreatDate: 2020-08-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s DictDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(id)),4)
	
	//诊疗规则引用接口 2023-02-28
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("护理",DictDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("护理",DictDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
    //字典对照
    s info=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("护理",DictDesc)
    s myInfo=myInfo_info
    
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.CDSS.CMKB.RuleTrigger")
	if (Exist="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("护理",DictDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("护理",DictDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
	//识别词项目引用接口    2021-11-25
	s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(id)),4)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("护理项目名称",NursingName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	//规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("处置",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("护理措施",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用"
 	q return
}

/// Creator:丁亚男
/// CreatDate:2020-06-18
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.NursingDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.NursingDictDetail).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.NursingDict).%New()
	s bobj.NursingNationCode = obj.NursingNationCode  
	s bobj.NursingCode = obj.NursingCode  
	s bobj.NursingName = obj.NursingName 
	s bobj.NursingOverview = obj.NursingOverview  
	s bobj.NursingNamePinyin = obj.NursingNamePinyin 
	s bobj.NursingNameFirstPinyin = obj.NursingNameFirstPinyin
	s bobj.NursingEnglishName = obj.NursingEnglishName 
	//s:obj.NursingClassCodeDR'="" bobj.NursingClassCodeDR = obj.NursingClassCodeDR.%Id()
	s bobj.NursingClassCodeDR = obj.NursingClassCodeDR
	s bobj.NursingContent = obj.NursingContent  
	s bobj.NursingIndication = obj.NursingIndication  
	s bobj.NursingTaboo = obj.NursingTaboo 
		
	s bobj.AdverseReactions = obj.AdverseReactions  
	s bobj.NursingPrecaution = obj.NursingPrecaution 
	s bobj.Complication = obj.Complication
	s bobj.ChildFlag = obj.ChildFlag
		
	s bobj.QuoteFlag = obj.QuoteFlag	//引用标志
	s bobj.KnowledgeTotal = obj.KnowledgeTotal	//知识数量
	s bobj.CreateDate=obj.CreateDate	//创建时间	
	s bobj.CreateUserID=obj.CreateUserID	//创建人员
	s bobj.NursingType=obj.NursingType	//类型  护理/处置
	s bobj.UseFlag=obj.UseFlag	//状态 0 编辑中,1 已删除，2 已审核
	s bobj.NursingAliasName=obj.NursingAliasName  		//别名
		
	Ts
	//同步删除对照数据 2022-01-21
	s re = ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("护理",obj.NursingCode_"[A]"_obj.NursingName)
	if (re="true[A]true"){
		
		s sc=##class(CT.WDT.CDSS.NursingDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.NursingDict","CT.WDT.CDSS.NursingDict","护理字典",id,bobj.NursingName,"D",bobj)
					
			//[新]护理百科删除同名数据    2021-11-25
			//d ##class(web.CDSS.CMKB.Term).DeleteTerm("护理",bobj.NursingName)
			//同步删除别名通用表中数据 
			d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.NursingDict",id)
					
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("护理字典","web.CDSS.CMKB.NursingDictDetail","DeleteData",bobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	} else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-05
/// Description：查询 护理
/// Table：CT.WDT.CDSS.NursingDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.NursingDictDetail","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "NursingID:%String,NursingName:%String,NursingDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s NursingID=rowid
		s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingID)),4)
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
			s ID=$o(^CT.WDT.CDSS.NursingDictD(ID))
			q:ID=""
			s NursingName=$lg($g(^CT.WDT.CDSS.NursingDictD(ID)),4)		//名称
			s length=$l(NursingName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s NursingID=0
			for
			{
				s NursingID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,NursingID))
				q:NursingID=""
				s NursingDR=NursingID
				s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingID)),4)
				s NursingNamePinyin=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingID)),6)
		  		s NursingNameFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingID)),7)
		 		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingID)),22)
		  		if ((($ZCONVERT(NursingName,"U")[desc)||(NursingNamePinyin[desc)||(NursingNameFirstPinyin[desc))&(($ZCONVERT(NursingName,"U")[q)||(NursingNamePinyin[q)||(NursingNameFirstPinyin[q))&(UseFlag=2)) {
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
	set Data=$lb(NursingID,NursingName,NursingDR)
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
/// Other:w ##class(web.CDSS.CMKB.NursingDictDetail).GetQuoteFlag("D,K,R")
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
/// Description:生成知识数量,保在护理字典表，当数据大于0时，修改标识
/// Table: CT.WDT.CDSS.NursingDict
/// Input: id 护理字典表id
/// Return:
/// others:w ##class(web.CDSS.CMKB.NursingDictDetail).CreateDetailCount()
ClassMethod CreateDetailCount()
{
	s CDSSRowId=0
	for
	{
 		s CDSSRowId = $o(^CT.WDT.CDSS.NursingDictD(CDSSRowId)) q:CDSSRowId=""
 		s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(CDSSRowId)
 		s QuoteFlag = obj.QuoteFlag
 		s NursingCode = obj.NursingCode  
		s NursingName = obj.NursingName 
		
		;K（Knowledge） 被医为百科引用
		if (basedr'="")
		{
			if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(NursingName,"U")))))
			{
				s termdr=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(NursingName,"U")),""))
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
	
		s ContrastType="护理"
		s MappingFlag=0
		s ContrastDictDR=""

		if ($d(^CT.WDT.CDSS.ContrastDictI("ContrastDictIndex"," "_NursingName,ContrastType,CDSSRowId))) s MappingFlag=1
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
			s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("护理",NursingName) //被诊疗规则引用判断
			s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("护理",NursingName) //被诊疗子规则引用判断
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
		s Flag=##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("护理",NursingName,CDSSRowId) //被预警规则库（处理/处置合理性）引用判断
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
	q "护理数据处理完成！"
}

/// Creator:钟荣枫
/// CreatDate:2020-09-10
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.NursingDictDetail).RemoveQuoteFlag("K,R","R")
ClassMethod RemoveQuoteFlag(OldFlag, RemoveFlag)
{
	s OldFlag = ##class(web.BDP.util.String).Replace(OldFlag,RemoveFlag_",","")
	s OldFlag = ##class(web.BDP.util.String).Replace(OldFlag,","_RemoveFlag,"")
	s OldFlag = ##class(web.BDP.util.String).Replace(OldFlag,RemoveFlag,"")
	q OldFlag
}

/// Creator:钟荣枫
/// CreatDate:2020-11-27
/// Description：导出护理字典表数据
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.NursingDictDetail).ExportNursing()
ClassMethod ExportNursing(code As %String, desc As %String, quoteflag As %String, opername As %String, nursingtype As %String, state As %String, starttime As %String, endtime As %String, aliasname As %String)
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"护理字典数据.txt"		
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
	w "护理编码	护理名称	别名	引用标志	操作人	操作时间	类型	状态"
	s NursingRowId=""
	for
	{ 
		s NursingRowId=$o(^CT.WDT.CDSS.NursingDictD(NursingRowId)) q:NursingRowId="" 
		
		s NursingCode=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),3)
		continue:((code'="")&&($ZCONVERT(NursingCode,"U")'[code))
		//s NursingCode=$tr(NursingCode,",","，")
		s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),4)
		continue:((desc'="")&&($ZCONVERT(NursingName,"U")'[desc))
		//s NursingName=$tr(NursingName,",","，")
		s QuoteFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),17) //引用标志
		continue:(QuoteFlag'[quoteflag)
		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),18)	//知识数量
		s:KnowledgeTotal="" KnowledgeTotal=0
		s CreateDate=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),19)	//创建时间	
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),20)	//创建人员
		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
		s NursingType=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),21)	//类型  护理/处置
		continue:((nursingtype'="")&&(NursingType'=nursingtype))
		s UseFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),22)	//状态 0 编辑中,1 已删除，2 已审核
		if (state=""){
			continue:(UseFlag=1)			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核","":"编辑中")
		s NursingAliasName=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),23)		//别名
		
		w !,NursingCode_"	"_NursingName_"	"_NursingAliasName_"	"_QuoteFlag_"	"_CreateUserID_"	"_CreateDate_"	"_NursingType_"	"_UseFlag
	}
	
	c file
	q fileName
}

/// Creator：钟荣枫
/// CreatDate: 2021-02-05
/// Description：将字典对照数据  导出到Excel表
/// Table:
/// Input：
/// d ##class(web.CDSS.CMKB.NursingDictDetail).ExportNursingTXT()   
ClassMethod ExportNursingTXT()
{
   	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
    Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"护理字典数据.txt"		
	s file=""			 	
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
    o file:"WNS"
    u file
    w "RowID	护理编码	护理名称	操作人	操作时间"   //注意此处是用tab隔开
    
    s Num=0
    s NursingRowId=""
	for
	{ 
		s NursingRowId=$o(^CT.WDT.CDSS.NursingDictD(NursingRowId)) q:NursingRowId="" 
		
		s NursingCode=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),3)
		s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),4)
		s CreateDate=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),19)	//创建时间	
		s CreateUserID=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),20)	//创建人员
		s Num=Num+1
		w !,NursingRowId_"	"_NursingCode_"	"_NursingName_"	"_CreateUserID_"	"_CreateDate   //注意此处连接符是tab
		
	}
    
	c file
	;W !,file_" 生成成功，共"_Num_"条"
	Q fileName
}

/// Creator:钟荣枫
/// CreatDate:2020-11-27
/// Description：修改原先的护理字典表数据，修改时间为 2020-11-27,修改人为dhcc
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.NursingDictDetail).UpdateNursDate()
ClassMethod UpdateNursDate()
{
	s NursingRowId=""
	for
	{ 
		s NursingRowId=$o(^CT.WDT.CDSS.NursingDictD(NursingRowId)) q:NursingRowId="" 
		
		s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(NursingRowId)
		s bobj = ##class(web.CDSSEntity.CMKB.NursingDict).%New()
		s eobj.NursingRowId=NursingRowId
		s bobj.NursingNationCode = obj.NursingNationCode  
		s bobj.NursingCode = obj.NursingCode  
		s bobj.NursingName = obj.NursingName 
		s bobj.NursingOverview = obj.NursingOverview  
		s bobj.NursingNamePinyin = obj.NursingNamePinyin 
		s bobj.NursingNameFirstPinyin = obj.NursingNameFirstPinyin
		s bobj.NursingEnglishName = obj.NursingEnglishName 
		//s:obj.NursingClassCodeDR'="" bobj.NursingClassCodeDR = obj.NursingClassCodeDR.%Id()
		s bobj.NursingClassCodeDR = obj.NursingClassCodeDR 
		s bobj.NursingContent = obj.NursingContent  
		s bobj.NursingIndication = obj.NursingIndication  
		s bobj.NursingTaboo = obj.NursingTaboo 
		
		s bobj.AdverseReactions = obj.AdverseReactions  
		s bobj.NursingPrecaution = obj.NursingPrecaution 
		s bobj.Complication = obj.Complication
		s bobj.ChildFlag = obj.ChildFlag
		s bobj.QuoteFlag = obj.QuoteFlag	//引用标志
		s bobj.KnowledgeTotal = obj.KnowledgeTotal	//知识数量
		
		s bobj.CreateDate="2020-11-27 00:00:00"	//创建时间	
		s bobj.CreateUserID="dhcc"	//创建人员
		
		s bobj.NursingType=obj.NursingType	//类型  护理/处置
		s bobj.UseFlag=obj.UseFlag	//状态 0 编辑中,1 已删除，2 已审核
		s bobj.NursingAliasName=obj.NursingAliasName	//别名
		d obj.%Close()
		d ..SaveData(bobj)
	}
	q "done"
}

/// Creator:钟荣枫
/// CreatDate:2021-1-26
/// Description：修改原先的护理字典表数据的状态
/// Input：id, state 状态
/// Return: result
/// Other:w ##class(web.CDSS.CMKB.NursingDictDetail).UpdateState(38,1)
ClassMethod UpdateState(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.NursingDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.NursingDict).%New()
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
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("护理",obj.NursingCode_"[A]"_obj.NursingName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){ 
	        s lineI=obj.NursingName_",识别条件,主要条件-识别词,1,护理项目名称,"_obj.NursingName_",0"
	        d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.NursingDict","CT.WDT.CDSS.NursingDict","护理字典",RowId,obj.NursingName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator：xuwenhu
/// CreatDate: 2021-05-12
/// Description: 批量处理数据，将代码更改为纯数字递增
/// Input:
/// Table：CT.WDT.CDSS.NursingDict
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).BatchChangeCode()
ClassMethod BatchChangeCode() As %String
{
	s ID=0
	s code=0
	s count=0 		//总处理数
	s failcount=0	//失败数
	for
	{
		s ID=$o(^CT.WDT.CDSS.NursingDictD(ID))
		q:ID=""
		s code=code+1
		s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(ID)
		s OldCode=obj.NursingCode													//旧代码
		
		s obj.NursingCode=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(code,5)		//新代码
		s sc=obj.%Save()
		d obj.%Close()
		TS
		If $$$ISOK(sc)
		{
			tc
			s count=count+1
			
			//调用字典对照接口
			d ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("护理", OldCode_"[A]"_obj.NursingName,obj.NursingCode_"[A]"_obj.NursingName)
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
/// Return：code
/// Other:w ##class(web.CDSS.CMKB.NursingDictDetail).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	//s NursingID=0
  	
	s Code=$o(^CT.WDT.CDSS.NursingDictD(""),-1)
	
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

/// Creator:xuwenhu
/// CreatDate:2021-06-07
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.NursingDict
/// Input: id-疾病表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.NursingDictDetail","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s NursingAlias = $lg($g(^CT.WDT.CDSS.NursingDictD(id)),23)
		s Len=$Length(NursingAlias,",")
		for i=1:1:Len{
			s Desc=$p(NursingAlias,",",i)
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

/// Creator: 赵文伟 
/// CreatDate: 2021-10-20
/// Description: 批量通过
/// Table: CT.WDT.CDSS.NursingDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).ChangeStatusPass("")
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
			s flag=..UpdateState(id,"通过")

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
/// Table: CT.WDT.CDSS.NursingDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).ChangeStatusBack("")
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
			s flag=..UpdateState(id,"驳回")

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
/// Table: CT.WDT.CDSS.NursingDict
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.NursingDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.NursingDictD(RowId)),23)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.NursingDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.NursingDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).CountData()
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.NursingDictD(RowId))
		q:RowId=""
		s UseFlag = $lg($g(^CT.WDT.CDSS.NursingDictD(RowId)),22)       
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
/// Table：CT.WDT.CDSS.NursingDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.NursingDictDetail).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.NursingDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.NursingRowId,eobj.NursingCode,eobj.NursingName,eobj.NursingType )  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.NursingRowId,eobj.NursingName,eobj.NursingAliasName)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.NursingRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.NursingDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(eobj.NursingRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.NursingDict).%New()
			s bobj.NursingCode = obj.NursingCode  
			s bobj.NursingName = obj.NursingName 
			s bobj.NursingAliasName = obj.NursingAliasName 
			s bobj.CreateDate=obj.CreateDate		//创建时间
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			
		}
		s obj.NursingCode = eobj.NursingCode  
		s obj.NursingName = eobj.NursingName 
		s obj.NursingAliasName = eobj.NursingAliasName 
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
			if (eobj.NursingRowId'="")		//修改时，同步修改对照数据
			{
				s oldstr=bobj.NursingCode_"[A]"_bobj.NursingName
				s newstr=eobj.NursingCode_"[A]"_eobj.NursingName
				d:(oldstr'=newstr) ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("护理", oldstr,newstr)
			}
			//保存日志
			d:eobj.NursingRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.NursingDict","CT.WDT.CDSS.NursingDict","护理字典",id,eobj.NursingName,"A",eobj)
			d:eobj.NursingRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.NursingDict","CT.WDT.CDSS.NursingDict","护理字典",eobj.NursingRowId,eobj.NursingName,"U",eobj,bobj)
			
			//[新]护理百科增加一条同名数据
			d:eobj.NursingRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("护理",eobj.NursingName,"")
			d:eobj.NursingRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("护理",eobj.NursingName,bobj.NursingName)
		
			//同步修改识别词项目数据    2021-11-25
			d:eobj.NursingRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("护理项目名称",eobj.NursingName,bobj.NursingName)
			
			//同步修改对照数据
			d:eobj.NursingRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("护理",bobj.NursingCode_"[A]"_bobj.NursingName,eobj.NursingCode_"[A]"_eobj.NursingName) 
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.NursingRowId="")&&(eobj.NursingAliasName'=""))||((eobj.NursingRowId'="")&&(eobj.NursingAliasName'=bobj.NursingAliasName))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.NursingDict",id,eobj.NursingAliasName)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("护理字典","web.CDSS.CMKB.NursingDictDetail","SaveAmendData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("护理字典","web.CDSS.CMKB.NursingDictDetail","SaveAmendData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.NursingDictDetail","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.NursingDict",RowId,LogID),-1) q:LogID=""
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
/// Description：转存护理字典数据到护理百科【百科中不存在的数据】
/// Table： CT.WDT.CDSS.NursingDict	护理字典
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.NursingDictDetail).TransferSaveData()
ClassMethod TransferSaveData() As %String
{
	s count=0
	s NursingRowId=""
	for
	{ 
		s NursingRowId=$o(^CT.WDT.CDSS.NursingDictD(NursingRowId),-1) q:NursingRowId="" 
		
		s NursingName=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(NursingRowId)),4)
		s UseFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(NursingRowId)),22)	//状态 0 编辑中,1 已删除，2 已审核
		continue:(UseFlag=1)	//过滤已弃用数据
		s BaseDR=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_"护理",0))
		if (BaseDR'="")
		{
			//如果百科中不存在，调用接口保存
			if ('$d(^CT.WDT.CDSS.TermI("DescIndex",BaseDR," "_($ZCONVERT(NursingName,"U")))))	
			{
				d ##class(web.CDSS.CMKB.Term).SaveTerm("护理",NursingName,"")
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
/// Table: 护理字典
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).ImportAliasData("D:\ZWW\护理新增别名最新.txt")
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
		
		s NursingName=$p(data,$c(9),1)	//名称
		s Alias=$p(data,$c(9),2)		//别名
		s flag=0
		s RowId=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$ZCONVERT(NursingName,"U"),0))
		//TS
		if (RowId'=""){
		
			s obj=##class(CT.WDT.CDSS.NursingDict).%OpenId(RowId)
			s OldAlias=obj.NursingAliasName //表中原有别名
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
				if (obj.NursingAliasName=""){
					s obj.NursingAliasName=Alias
				}else{
					s obj.NursingAliasName=obj.NursingAliasName_","_Alias
				}
				s sc= obj.%Save()
				
				if $$$ISOK(sc)
				{
					s id = obj.%Id()
					s result = "{success:'true'}"
					//同步保存别名到别名通用表
		            if (RowId'="")
		            {
		            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.NursingDict",id,obj.NursingAliasName)
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
					w !,NursingName_"^"_Alias_" 保存失败"
				}
			}else{
				w !,NursingName_"^"_Alias_" 存在重复别名"
				//TRO
			}
		}else{
			w !,NursingName_"不存在"
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

/// Creator：赵文伟 
/// CreatDate: 2023-05-19
/// Description：批量删除已弃用数据[未被弃用或只被字典对照引用]
/// Table: CT.WDT.CDSS.NursingDict
/// Other: w ##class(web.CDSS.CMKB.NursingDictDetail).DeleteDeprecatedData() 
ClassMethod DeleteDeprecatedData() As %String
{
	s count=0
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.NursingDictD(RowId),-1) q:RowId="" 
		s Name=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RowId)),4)
		s UseFlag=$lg($g(^CT.WDT.CDSS.NursingDictD(RowId)),22)
		if (UseFlag=1){
			s quoteInfo=..GetRefFlag(RowId)
			if '((quoteInfo["诊疗规则关联触发条件表")||(quoteInfo["规则管理")||(quoteInfo["识别词规则")){
				
				d ##class(web.CDSS.CMKB.NursingDictDetail).DeleteData(RowId)
				w Name_"已删除",!
				s count=count+1
			}
		}
	}
	q "success,已删除"_count_"条数据！"
}

}

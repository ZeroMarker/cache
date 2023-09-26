/// Description：手术字典表 
/// Table：CT.WDT.CDSS.OperationDict
Class web.CDSS.CMKB.OperationDictDetail Extends %RegisteredObject
{

/// Creator：ZWW
/// CreatDate: 2022-09-16
/// Description：查询手术字典
/// Table：CT.WDT.CDSS.OperationDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.OperationDictDetail","GetList","15373","","","","","","","","","","","","","","")
Query GetList(rowid, code As %String, desc As %String, quoteflag As %String, IsUseFlag As %String = "", aliasname As %String, opername As %String, opertype As %String, state As %String, starttime As %String, endtime As %String, version As %String, grade As %String, category As %String, sortmethod As %String) As %Query(ROWSPEC = "OperationRowId,OperationNationCode,OperationCode,OperationName,OperationPinyin,OperationFirstPinyin,OperationEnglishName,ICD9Code,ICD9Name,DeptName,OperationClass,UseFlag,UpdateDate,UpdateUser,Remarks,QuoteFlag,KnowledgeTotal,OperAliasName,Version,GradeStr,CategoryStr,AnesthesiaMode,AnesthesiaModeDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code As %String, desc As %String, quoteflag As %String, IsUseFlag As %String = "", aliasname As %String, opername As %String, opertype As %String, state As %String, starttime As %String, endtime As %String, version As %String, grade As %String, category As %String, sortmethod As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s OperationRowId=rowid
	s OperationNationCode=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),2)
	s OperationCode=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),3)
	s OperationName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),4)
	s OperationPinyin=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),5)
	s OperationFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),6)
	s OperationEnglishName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),7)
	
	s ICD9Code=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),8)
	s ICD9Name=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),9)
	s DeptName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),10)
	s OperationClass=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),11)	//手术类别
	s UseFlag=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),12)
	s:UseFlag="" UseFlag=0
	s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),13)
	s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),14)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),15)
	s QuoteFlag=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),16) //引用标志
	s QuoteFlag=..GetQuoteFlag(QuoteFlag)
	s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),17)	//知识数量
	s:KnowledgeTotal="" KnowledgeTotal=0
	s OperAliasName=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),18)	//别名
	//s OperationCategory=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),20)	//手术分类
	//s OperationGrade=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),21)	//手术分级
	//手术分级,手术分类
	s JoinDR=""
	s GradeStr=""
	s CategoryStr=""
	for {
		s JoinDR=$o(^CT.WDT.CDSS.OperJoinDeptI("OperationIndex",OperationRowId,JoinDR)) q:JoinDR=""
		s OperationGrade=$lg($g(^CT.WDT.CDSS.OperJoinDeptD(JoinDR)),4)	//手术分级DR
		s Grade=""
		s:OperationGrade'="" Grade=$lg($g(^CT.WDT.CDSS.CommonDictD(OperationGrade)),4) //通用名名称[手术分级]
		
		if (GradeStr=""){
			s GradeStr=Grade
		}else{
			s GradeStr=GradeStr_"，"_Grade
		}
		s OperationCategory=$lg($g(^CT.WDT.CDSS.OperJoinDeptD(JoinDR)),5)	//手术分类
		s Category=$case(OperationCategory,"1":"一类","2":"二类","3":"三类","4":"四类",:"")
		if (CategoryStr=""){
			s CategoryStr=Category
		}else{
			s CategoryStr=CategoryStr_"，"_Category
		}
	}
	s AnesthesiaMode=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),20)	//麻醉方式DR
	s:AnesthesiaMode'="" AnesthesiaModeDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(AnesthesiaMode)),4)	//麻醉方式名称
	s:AnesthesiaMode="" AnesthesiaModeDesc=""
	d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
	s:version'="" version=$ZCONVERT(version,"U") //转换成大写
	//默认时间倒序输出
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.OperationDictD(ID))
			q:ID=""
			s OperaName= $lg($g(^CT.WDT.CDSS.OperationDictD(ID)),4)		//名称
			s length=$l(OperaName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.OperationDictD(ID))
			q:ID=""
			s CreateDate= $lg($g(^CT.WDT.CDSS.OperationDictD(ID)),13)	//编辑时间
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
		s OperationRowId=0
		for
		{
			s OperationRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,OperationRowId)) q:OperationRowId=""
			s OperationNationCode=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),2)
			s OperationCode=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),3)
			s OperationName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),4)
			s OperationPinyin=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),5)
			s OperationFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),6)
			s OperationEnglishName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),7)
			
			s ICD9Code=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),8)
			s ICD9Name=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),9)
			s DeptName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),10)
			s OperationClass=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),11)
			continue:((opertype'="")&&(OperationClass'=opertype))
			s UseFlag=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),12)
			s:UseFlag="" UseFlag=0
			if IsUseFlag="true"  continue:UseFlag=1
			if (state=""){
				continue:(UseFlag="1")			
			}else{
				continue:((state'="")&&(UseFlag'=state))
			}
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),13)
			s:UpdateDate="" UpdateDate="2021-01-01 00:00:00"
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
			
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),14)
			continue:((opername'="")&&($ZCONVERT(UpdateUser,"U")'[opername))
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),15)
			
			s QuoteFlag=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),16) //引用标志
			continue:(QuoteFlag'[quoteflag)
			s QuoteFlag=..GetQuoteFlag(QuoteFlag)
			s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),17)	//知识数量
			s:KnowledgeTotal="" KnowledgeTotal=0
			s OperAliasName=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),18)
			continue:((aliasname'="")&&($ZCONVERT(OperAliasName,"U")'[aliasname))
			s Version=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),19)
			continue:((version'="")&&($ZCONVERT(Version,"U")'[version))
			
			//手术分级,手术分类
			s JoinDR=""
			s GradeStr=""
			s CategoryStr=""
			for {
				s JoinDR=$o(^CT.WDT.CDSS.OperJoinDeptI("OperationIndex",OperationRowId,JoinDR)) q:JoinDR=""
				s OperationGrade=$lg($g(^CT.WDT.CDSS.OperJoinDeptD(JoinDR)),4)				//手术分级DR
				s Grade=""
				s:OperationGrade'="" Grade=$lg($g(^CT.WDT.CDSS.CommonDictD(OperationGrade)),4) //通用名名称[手术分级]
				
				if (GradeStr=""){
					s GradeStr=Grade
				}else{
					s GradeStr=GradeStr_"，"_Grade
				}
				s OperationCategory=$lg($g(^CT.WDT.CDSS.OperJoinDeptD(JoinDR)),5)			//手术分类
				s Category=$case(OperationCategory,"1":"一类","2":"二类","3":"三类","4":"四类",:"")
				if (CategoryStr=""){
					s CategoryStr=Category
				}else{
					s CategoryStr=CategoryStr_"，"_Category
				}
			}
			continue:((grade'="")&&($ZCONVERT(GradeStr,"U")'[grade))
			continue:((category'="")&&($ZCONVERT(CategoryStr,"U")'[category))
			s AnesthesiaMode=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),20)	//麻醉方式DR
			s:AnesthesiaMode'="" AnesthesiaModeDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(AnesthesiaMode)),4)	//麻醉方式名称
			s:AnesthesiaMode="" AnesthesiaModeDesc=""
			if (($ZCONVERT(OperationName,"U")[desc)||($ZCONVERT(OperationPinyin,"U")[desc)||($ZCONVERT(OperationFirstPinyin,"U")[desc)||(desc=""))&&($ZCONVERT(OperationCode,"U")[code) 
			{
				d OutputRow
			}
		}
	}
}
	Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(OperationRowId,OperationNationCode,OperationCode,OperationName,OperationPinyin,OperationFirstPinyin,OperationEnglishName,ICD9Code,ICD9Name,DeptName,OperationClass,UseFlag,UpdateDate,UpdateUser,Remarks,QuoteFlag,KnowledgeTotal,OperAliasName,Version,GradeStr,CategoryStr,AnesthesiaMode,AnesthesiaModeDesc)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2018-03-27    
/// w ##class(web.CDSS.CMKB.OperationDictDetail).FormValidate("","333","222","111")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String, code As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.OperationDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.OperationDictI("NameIndex",desc))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.OperationDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.OperationDictI("NameIndex",desc,0))
		
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.OperationDictDetail).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.OperationDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.OperationDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.OperationDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.OperationDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// Table：CT.WDT.CDSS.OperationDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.OperationDictDetail).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.OperationDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.OperationRowId,eobj.OperationName,eobj.OperationCode)  //调用重复验证
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		s flagAlias=..ValidateAlias(eobj.OperationRowId,eobj.OperationName,eobj.OperAliasName)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.OperationRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.OperationDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.OperationDict).%OpenId(eobj.OperationRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.OperationDict).%New()
			s bobj.OperationNationCode = obj.OperationNationCode  
			s bobj.OperationCode = obj.OperationCode  
			s bobj.OperationName = obj.OperationName 
			s bobj.OperationPinyin = obj.OperationPinyin 
			s bobj.OperationFirstPinyin = obj.OperationFirstPinyin
			s bobj.OperationEnglishName = obj.OperationEnglishName 
			
			s bobj.ICD9Code = obj.ICD9Code  
			s bobj.ICD9Name = obj.ICD9Name  
			s bobj.DeptName = obj.DeptName 
			s bobj.OperationClass = obj.OperationClass  
			s bobj.UseFlag = obj.UseFlag 
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.UpdateUser = obj.UpdateUser
			s bobj.Remarks = obj.Remarks
			s bobj.QuoteFlag = obj.QuoteFlag
			s bobj.KnowledgeTotal = obj.KnowledgeTotal
			s bobj.OperAliasName = obj.OperAliasName
			s bobj.Version=obj.Version
			
			if $IsObject(obj.AnesthesiaMode)
			{
				s bobj.AnesthesiaMode=obj.AnesthesiaMode.%Id()	//麻醉方式
			}
			
			
		}
		
		s obj.OperationNationCode = eobj.OperationNationCode  
		s obj.OperationCode = eobj.OperationCode  
		s obj.OperationName = eobj.OperationName 
		s obj.OperationPinyin = eobj.OperationPinyin 
		s obj.OperationFirstPinyin = eobj.OperationFirstPinyin
		s obj.OperationEnglishName = eobj.OperationEnglishName 
		s obj.ICD9Code = eobj.ICD9Code  
		s obj.ICD9Name = eobj.ICD9Name  
		s obj.DeptName = eobj.DeptName 
		s obj.OperationClass = eobj.OperationClass  
		s obj.UseFlag = eobj.UseFlag 
		s obj.UpdateDate = eobj.UpdateDate
		s obj.UpdateUser = eobj.UpdateUser
		s obj.Remarks = eobj.Remarks
		s obj.OperAliasName = eobj.OperAliasName
		s obj.Version=eobj.Version
		
		d obj.AnesthesiaModeSetObjectId(eobj.AnesthesiaMode)
		
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.OperationRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.OperationDict","CT.WDT.CDSS.OperationDict","手术字典",id,eobj.OperationName,"A",eobj)
			d:eobj.OperationRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.OperationDict","CT.WDT.CDSS.OperationDict","手术字典",eobj.OperationRowId,eobj.OperationName,"U",eobj,bobj)
		
			//同步修改对照数据
			d:eobj.OperationRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("手术",bobj.OperationCode_"[A]"_bobj.OperationName,eobj.OperationCode_"[A]"_eobj.OperationName)
			
			//[新]手术百科增加一条同名数据    2021-11-25
			d:eobj.OperationRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("手术",eobj.OperationName,"")
			d:eobj.OperationRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("手术",eobj.OperationName,bobj.OperationName)
			
			//同步修改识别词项目数据    2021-11-25
			d:eobj.OperationRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("手术名称",eobj.OperationName,bobj.OperationName)
		
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.OperationRowId="")&&(eobj.OperAliasName'=""))||((eobj.OperationRowId'="")&&(eobj.OperAliasName'=bobj.OperAliasName))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.OperationDict",id,eobj.OperAliasName)
            }
            
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("手术字典","web.CDSS.CMKB.OperationDictDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("手术字典","web.CDSS.CMKB.OperationDictDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2020-06-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.OperationDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.OperationDictDetail).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.OperationDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.OperationDict).%New()
	s bobj.OperationNationCode = obj.OperationNationCode  
	s bobj.OperationCode = obj.OperationCode  
	s bobj.OperationName = obj.OperationName
	s bobj.OperationPinyin = obj.OperationPinyin 
	s bobj.OperationFirstPinyin = obj.OperationFirstPinyin
	s bobj.OperationEnglishName = obj.OperationEnglishName 
	
	s bobj.ICD9Code = obj.ICD9Code  
	s bobj.ICD9Name = obj.ICD9Name  
	s bobj.DeptName = obj.DeptName 
	s bobj.OperationClass = obj.OperationClass  
	s bobj.UseFlag = obj.UseFlag 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.UpdateUser = obj.UpdateUser
	s bobj.Remarks = obj.Remarks
	
	s bobj.QuoteFlag = obj.QuoteFlag
	s bobj.KnowledgeTotal = obj.KnowledgeTotal
	s bobj.OperAliasName = obj.OperAliasName
	s bobj.Version=obj.Version
	
	s:obj.AnesthesiaMode'="" bobj.AnesthesiaMode=obj.AnesthesiaMode.%Id() //麻醉方式
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-08-19
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// 目前没有引用手术的表、病因等用到但是保存的是手术名称，不影响
/// w ##class(web.CDSS.CMKB.OperationDictDetail).GetRefFlag("124")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s DictDesc=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(id)),4)
    //诊疗规则引用接口 2023-02-28
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("手术",DictDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("手术",DictDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
    //规则引用
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("手术",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	//识别词项目引用接口    2021-11-25
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("手术名称",DictDesc)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	//字典对照引用接口
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("手术",DictDesc)
	if Mappinginfo'="" s myInfo=myInfo_Mappinginfo
	
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用!"
    q return
}

/// Creator:丁亚男
/// CreatDate:2020-06-18
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.OperationDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.OperationDictDetail).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
		s obj=##class(CT.WDT.CDSS.OperationDict).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.OperationDict).%New()
		s bobj.OperationNationCode = obj.OperationNationCode  
		s bobj.OperationCode = obj.OperationCode  
		s bobj.OperationName = obj.OperationName 
		s bobj.OperationPinyin = obj.OperationPinyin 
		s bobj.OperationFirstPinyin = obj.OperationFirstPinyin
		s bobj.OperationEnglishName = obj.OperationEnglishName 
		
		s bobj.ICD9Code = obj.ICD9Code  
		s bobj.ICD9Name = obj.ICD9Name  
		s bobj.DeptName = obj.DeptName 
		s bobj.OperationClass = obj.OperationClass  
		s bobj.UseFlag = obj.UseFlag 
		s bobj.UpdateDate = obj.UpdateDate
		s bobj.UpdateUser = obj.UpdateUser
		s bobj.Remarks = obj.Remarks
		s bobj.OperAliasName = obj.OperAliasName
		s bobj.QuoteFlag = obj.QuoteFlag
		s bobj.KnowledgeTotal = obj.KnowledgeTotal
		//s bobj.OperationCategory=obj.OperationCategory
		//s bobj.OperationGrade=obj.OperationGrade
		s bobj.AnesthesiaMode=obj.AnesthesiaMode	//麻醉方式
		Ts
		//同步删除对照数据 2022-01-21
		s re = ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("手术",obj.OperationCode_"[A]"_obj.OperationName)
	 	
	 	if (re="true[A]true"){

			s sc=##class(CT.WDT.CDSS.OperationDict).%DeleteId(id)
			if $$$ISOK(sc)
			{
				Tc
				s result = "{success:'true',info:'删除成功！'}"	
				//保存日志
				d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.OperationDict","CT.WDT.CDSS.OperationDict","手术字典",id,bobj.OperationName,"D",bobj)
				//[新]手术百科删除同名数据    2021-11-25
				//d ##class(web.CDSS.CMKB.Term).DeleteTerm("手术",bobj.OperationName)
				//同步删除别名通用表中数据 
				d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.OperationDict",id)
				//同步删除手术关联科室表中数据[科室，手术分级，手术分类] 2022-05-25 ZWW
				d ##class(web.CDSS.CMKB.OperJoinDept).DeleteLinkData(id)
				d bobj.%Close()
			}
			else
			{
				Tro
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("手术字典","web.CDSS.CMKB.OperationDictDetail","DeleteData",bobj)
		       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		} else{
	    	s result = "{success:'false',info:'字典对照同步删除失败！'}"
	 }
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-05
/// Description：查询 手术
/// Table：CT.WDT.CDSS.OperationDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.OperationDictDetail","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "OperationID:%String,OperationName:%String,OperationDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s OperationID=rowid
		s OperationName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationID)),4)
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
			s ID=$o(^CT.WDT.CDSS.OperationDictD(ID))
			q:ID=""
			s OperationName=$lg($g(^CT.WDT.CDSS.OperationDictD(ID)),4)		//名称
			s length=$l(OperationName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s OperationID=0
			for
			{
				s OperationID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,OperationID))
				q:OperationID=""
				s OperationDR=OperationID
				s OperationName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationID)),4)
				s OperationPinyin=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationID)),5)
		  		s OperationFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationID)),6)
		  		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationID)),12)
		  		s OperAliasName=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationID)),18)
				if (($ZCONVERT(OperationName,"U")[desc)||(OperationPinyin[desc)||(OperationFirstPinyin[desc)||($ZCONVERT(OperAliasName,"U")[desc))&(UseFlag=2) {
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
	set Data=$lb(OperationID,OperationName,OperationDR)
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
/// Other:w ##class(web.CDSS.CMKB.OperationDictDetail).GetQuoteFlag("D,K,R")
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

/// Creator:高姗姗
/// CreatDate:2020-09-10
/// Description:移除被取消引用的引用标志
/// others:w ##class(web.CDSS.CMKB.OperationDictDetail).RemoveQuoteFlag("","R")
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
/// Description:生成知识数量保存在手术字典的表，当数据大于0时，修改标识
/// Table: CT.WDT.CDSS.OperationDict
/// Input: id 疾病字典表id
/// Return:
/// others:w ##class(web.CDSS.CMKB.OperationDictDetail).CreateOperDetailCount()
ClassMethod CreateOperDetailCount()
{
	s OperationRowId=""
	for
	{ 
		s OperationRowId=$o(^CT.WDT.CDSS.OperationDictD(OperationRowId)) q:OperationRowId="" 
 		s obj=##class(CT.WDT.CDSS.OperationDict).%OpenId(OperationRowId)
 		s QuoteFlag = obj.QuoteFlag
 		s OperationCode = obj.OperationCode
 		s OperationName = obj.OperationName
 		
		;K（Knowledge） 被医为百科引用
		s basedr=##class(web.CDSS.CMKB.Term).GetIdByDesc("手术")
		if (basedr'="")
		{
			if ($d(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(OperationName,"U")))))
			{
				s termdr=$o(^CT.WDT.CDSS.TermI("DescIndex",basedr," "_($ZCONVERT(OperationName,"U")),""))
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
						s obj.QuoteFlag=##class(web.CDSS.CMKB.OperationDictDetail).RemoveQuoteFlag(QuoteFlag,"K")	
					}
				}
			}
		}
		s QuoteFlag = obj.QuoteFlag
		;M（Mapping）数据对照2.0
		
		s ContrastType="手术"
		s MappingFlag=0
		s ContrastDictDR=""

		if ($d(^CT.WDT.CDSS.ContrastDictI("ContrastDictIndex"," "_OperationName,ContrastType,OperationRowId))) {s MappingFlag=1}
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
			s obj.QuoteFlag=##class(web.CDSS.CMKB.OperationDictDetail).RemoveQuoteFlag(QuoteFlag,"M")	
		}
		s QuoteFlag = obj.QuoteFlag
		s Exist =##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.CDSS.CMKB.RuleTrigger")
		if (Exist="1"){
			;R（Rule） 被规则知识库引用
			s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("手术",OperationName) //被诊疗规则引用判断
			s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("手术",OperationName) //被诊疗子规则引用判断
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
				s obj.QuoteFlag=##class(web.CDSS.CMKB.OperationDictDetail).RemoveQuoteFlag(QuoteFlag,"R")	
			}
			s QuoteFlag = obj.QuoteFlag
		}
		;W（Warning）被预警规则库引用
		s WarningFlag=0
		s Flag=##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("手术",OperationName,OperationRowId) //被预警规则库（手术合理性）引用判断
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
			s obj.QuoteFlag=##class(web.CDSS.CMKB.OperationDictDetail).RemoveQuoteFlag(QuoteFlag,"W")	
		}
		s sc=obj.%Save()
		d obj.%Close()
	}
	q "手术数据处理完成！"
}

/// Creator:丁亚男
/// CreatDate:2020-10-20
/// Description：导入手术数据
/// Table：CT.WDT.CDSS.OperationDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.OperationDictDetail).ImportOperData()
ClassMethod ImportOperData()
{
	
	s result ="" 
	s file=##class(%File).%New("D:\更新文件\丁亚男\20201020\手术表20201020.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s OperationName=$p(Line,",",3)
		s OperationName=$tr(OperationName,"&",",")
		if ('$d(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(OperationName,"U"))))
		{
			s OperationNationCode=$p(Line,",",1)
			s OperationCode=$p(Line,",",2)
			s ICD9Code=$p(Line,",",4)
			s ICD9Name=$p(Line,",",5)
			s ICD9Name=$tr(ICD9Name,"&",",")
			s OperationClass=$p(Line,",",6)
			s obj=##class(CT.WDT.CDSS.OperationDict).%New()
			s obj.OperationNationCode=OperationNationCode
			s obj.OperationCode=OperationCode
			s obj.OperationName=OperationName
			s obj.OperationPinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(OperationName,3)
			s obj.OperationFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OperationName)
			s obj.ICD9Code=ICD9Code
			s obj.ICD9Name=ICD9Name
			s obj.OperationClass=OperationClass
			
			
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
				w !, OperationName_"导入失败"
			}
			
		}		
		
	}
	q "OK"
}

/// Creator:丁亚男
/// CreatDate:2020-11-30
/// Description:导出手术字典表数据
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.OperationDictDetail).ExportOperCSVData()
ClassMethod ExportOperData(code As %String, desc As %String, quoteflag As %String, aliasname As %String, opername As %String, opertype As %String, state As %String, starttime As %String, endtime As %String, version As %String) As %String
{
	s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"手术字典数据.txt"		
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

	w "手术编码	手术名称	别名	版本	手术类别	操作时间	操作人	引用标志	状态	手术分级	手术分类	麻醉方式"
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:aliasname'="" aliasname=$ZCONVERT(aliasname,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
	s:version'="" version=$ZCONVERT(version,"U") //转换成大写
	//s:category'="" category=$ZCONVERT(category,"U") //转换成大写
	//s:grade'="" grade=$ZCONVERT(grade,"U") //转换成大写
	s OperationRowId=""
	for
	{ 
		s OperationRowId=$o(^CT.WDT.CDSS.OperationDictD(OperationRowId),-1) q:OperationRowId="" 
		//s OperationNationCode=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),2)
		s OperationCode=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),3)
		continue:((code'="")&&($ZCONVERT(OperationCode,"U")'[code))
		s OperationName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),4)
		continue:((desc'="")&&($ZCONVERT(OperationName,"U")'[desc))
		s OperationClass=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),11)
		continue:((opertype'="")&&($ZCONVERT(OperationClass,"U")'[opertype))
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),12)
		continue:((state'="")&&(UseFlag'=state))
			
        s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
		s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),13)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
		s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),14)
		continue:((opername'="")&&($ZCONVERT(UpdateUser,"U")'[opername))
			
		s QuoteFlag=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),16) //引用标志
		continue:(QuoteFlag'[quoteflag)
		s QuoteFlag=..GetQuoteFlag(QuoteFlag)
		s KnowledgeTotal=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),17)	//知识数量
		s:KnowledgeTotal="" KnowledgeTotal=0
		s OperAliasName=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),18)
		continue:((aliasname'="")&&($ZCONVERT(OperAliasName,"U")'[aliasname))
		s Version=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),19)
		continue:((version'="")&&($ZCONVERT(Version,"U")'[version))
		//s OperationCategory=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),20)	//手术分类
		//continue:((category'="")&&($ZCONVERT(OperationCategory,"U")'[category))
		//s OperationGrade=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),21)	//手术分级
		//continue:((grade'="")&&($ZCONVERT(OperationGrade,"U")'[grade))
	 	//替换双引号
		//s OperationNationCode=$replace(OperationNationCode,"""","”")
		/*s OperationCode=$replace(OperationCode,"""","”")
		s OperationName=$replace(OperationName,"""","”")
			
		//将英文逗号转换为中文逗号
		//s OperationNationCode=$replace(OperationNationCode,",","，")
		s OperationCode=$replace(OperationCode,",","，")
		s OperationName=$replace(OperationName,",","，")
		s OperationClass=$replace(OperationClass,"""","")
		s UpdateUser=$replace(UpdateUser,",","，")*/
		//手术分级,手术分类，麻醉方式
		s JoinDR=""
		s GradeStr=""
		s CategoryStr=""
		for {
			s JoinDR=$o(^CT.WDT.CDSS.OperJoinDeptI("OperationIndex",OperationRowId,JoinDR)) q:JoinDR=""
			s OperationGrade=$lg($g(^CT.WDT.CDSS.OperJoinDeptD(JoinDR)),4)	//手术分级DR
			s Grade=""
			s:OperationGrade'="" Grade=$lg($g(^CT.WDT.CDSS.CommonDictD(OperationGrade)),4) //通用名名称[手术分级]
				
			if (GradeStr=""){
				s GradeStr=Grade
			}else{
				s GradeStr=GradeStr_"，"_Grade
			}
			s OperationCategory=$lg($g(^CT.WDT.CDSS.OperJoinDeptD(JoinDR)),5)	//手术分类
			s Category=$case(OperationCategory,"1":"一类","2":"二类","3":"三类","4":"四类",:"")
			if (CategoryStr=""){
				s CategoryStr=Category
			}else{
				s CategoryStr=CategoryStr_"，"_Category
			}
		}
		s AnesthesiaMode=$lg($g(^CT.WDT.CDSS.OperationDictD(OperationRowId)),21)	//麻醉方式DR
		s:AnesthesiaMode'="" AnesthesiaModeDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(AnesthesiaMode)),4)	//麻醉方式名称
		s:AnesthesiaMode="" AnesthesiaModeDesc=""
			
		w !,OperationCode_"	"_OperationName_"	"_OperAliasName_"	"_Version_"	"_OperationClass_"	"_UpdateDate_"	"_UpdateUser_"	"_QuoteFlag_"	"_UseFlag_"	"_GradeStr_"	"_CategoryStr_"	"_AnesthesiaModeDesc
			
	}
	c file
	q fileName
}

/// Creator:zww
/// CreatDate:2021-11-26
/// Input:RowId 手术ID Operation 操作
/// Return:
/// Other:w ##class(web.CDSS.CMKB.OperationDictDetail).ChangeStatus(182,"")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.OperationDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.OperationDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.OperationDict).%New()
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
		//同步删除对照数据【当状态变为已弃用或驳回时】  2021-12-21
		if (obj.UseFlag="1")||(obj.UseFlag="0"){
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("手术",obj.OperationCode_"[A]"_obj.OperationName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){
	        s lineI=obj.OperationName_",识别条件,主要条件-识别词,1,手术名称,"_obj.OperationName_",0"
	        d:eobj.OperationRowId="" ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.OperationDict","CT.WDT.CDSS.OperationDict","手术字典",RowId,obj.OperationName_"&&"_Operation,"U",eobj,bobj)	
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
/// Table: CT.WDT.CDSS.OperationDict
/// Input: id-手术表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.OperationDictDetail","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s OperationAlias = $lg($g(^CT.WDT.CDSS.OperationDictD(id)),18)
		s Len=$Length(OperationAlias,",")
		for i=1:1:Len{
			s Desc=$p(OperationAlias,",",i)
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

/// Creator:丁亚男
/// CreatDate:2021-07-15
/// Description：修改手术数据
/// Table：CT.WDT.CDSS.OperationDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.OperationDictDetail).UpdateOperData("D:\更新文件\丁亚男\20210715\修改手术字典数据0708.csv")
ClassMethod UpdateOperData(filepath)
{
	s count=0
	s file=##class(%File).%New(filepath)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s OperationCodeO=$p(Line,",",1)
		s OperationNameO=$p(Line,",",2)
		s OperationNameO=$tr(OperationNameO,"&",",")
		s OperIDC=$o(^CT.WDT.CDSS.OperationDictI("CodeIndex"," "_$ZCONVERT(OperationCodeO,"U"),""))
		s OperIDN=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(OperationNameO,"U"),""))
		if (OperIDC'=OperIDN)||((OperIDC="")&(OperIDN=""))
		{
			w !, OperationCodeO_"-"_OperationNameO_"该数据代码跟描述不一致"
			continue
		}
		else
		{
			s OperationNameN=$p(Line,",",3)
			s OperationAlaN=$p(Line,",",4)
			s OperationCodeN=$p(Line,",",5)
			s VersionN=$p(Line,",",6)
			s OperationClassN=$p(Line,",",7)
			
			s obj=##class(CT.WDT.CDSS.OperationDict).%OpenId(OperIDC)
			if (OperationNameN'="")
			{
				s obj.OperationName=OperationNameN
				s obj.OperationPinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(OperationNameN,3)
				s obj.OperationFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OperationNameN)
			}
			if (OperationAlaN'="")
			{
				s obj.OperAliasName=OperationAlaN
			}
			if (OperationCodeN'="")
			{
				s obj.OperationCode=OperationCodeN
				s obj.OperationNationCode=OperationCodeN
			}
			if (VersionN'="")
			{
				s obj.Version=VersionN
			}
			if (OperationClassN'="")
			{
				s obj.OperationClass=OperationClassN
			}
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				Tc
				s count=count+1
			}
			else
			{
				Tro
				set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				w !, OperationCodeO_"-"_OperationNameO_"导入失败"
			}
		}
	}
	q count_"条数据修改成功！"
}

/// Creator:丁亚男
/// CreatDate:2021-07-15
/// Description：删除手术数据
/// Table：CT.WDT.CDSS.OperationDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.OperationDictDetail).DeleteOperData("D:\更新文件\丁亚男\20210715\删除手术字典数据0708.csv")
ClassMethod DeleteOperData(filepath)
{
	s count=0
	s file=##class(%File).%New(filepath)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s OperationCodeO=$p(Line,",",1)
		s OperationNameO=$p(Line,",",2)
		s OperationNameO=$tr(OperationNameO,"&",",")
		s OperIDC=$o(^CT.WDT.CDSS.OperationDictI("CodeIndex"," "_$ZCONVERT(OperationCodeO,"U"),""))
		s OperIDN=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(OperationNameO,"U"),""))
		if (OperIDC'=OperIDN)||((OperIDC="")&(OperIDN=""))
		{
			w !, OperationCodeO_"-"_OperationNameO_"该数据代码跟描述不一致"
			continue
		}
		else
		{
			s result=##class(web.CDSS.CMKB.OperationDictDetail).DeleteData(OperIDC)
			if result["true"
			{
				s count=count+1 
			}
			else
			{
				w !, OperationCodeO_"-"_OperationNameO_result
			}
		}		
		
	}
	q count_"条数据删除成功！"
}

/// Creator:丁亚男
/// CreatDate:2021-07-15
/// Description：删除手术数据
/// Table：CT.WDT.CDSS.OperationDict
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.OperationDictDetail).AddOperData("D:\更新文件\丁亚男\20210715\新增手术字典数据0708.csv")
ClassMethod AddOperData(filepath)
{
	s count=0
	s file=##class(%File).%New(filepath)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s OperationCode=$p(Line,",",1)
		s OperationName=$p(Line,",",2)
		s OperationName=$tr(OperationName,"&",",")
		if ('$d(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(OperationName,"U"))))&('$d(^CT.WDT.CDSS.OperationDictI("CodeIndex"," "_$ZCONVERT(OperationCode,"U"))))
		{
			s OperationClass=$p(Line,",",3)
			s Version=$p(Line,",",4)
			s obj=##class(CT.WDT.CDSS.OperationDict).%New()
			s obj.OperationNationCode=OperationCode
			s obj.OperationCode=OperationCode
			s obj.OperationName=OperationName
			s obj.OperationPinyin=##class(web.DHCBL.BDP.FunLib).GetCNCODE(OperationName,3)
			s obj.OperationFirstPinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OperationName)
			s obj.OperationClass=OperationClass
			s obj.Version=Version
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				Tc
				s count=count+1
			}
			else
			{
				Tro
				w !, OperationCode_"-"_OperationName_"导入失败"
			}
		}
		else
		{
			w !, OperationCode_"-"_OperationName_"该数据代码跟描述不一致"
			
		}
	}
	q count_"条数据删除成功！"
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-20
/// Description: 批量通过
/// Table: CT.WDT.CDSS.OperationDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.OperationDictDetail).ChangeStatusPass("")
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
/// Table: CT.WDT.CDSS.OperationDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.OperationDictDetail).ChangeStatusBack("")
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
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.OperationDict
/// Other: w ##class(web.CDSS.CMKB.OperationDictDetail).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.OperationDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.OperationDictD(RowId)),18)
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.OperationDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.OperationDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.OperationDictDetail).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.OperationDictD(RowId))
		q:RowId=""
		s UseFlag = $lg($g(^CT.WDT.CDSS.OperationDictD(RowId)),12)       
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
/// Table：CT.WDT.CDSS.OperationDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.OperationDictDetail).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.OperationDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.OperationRowId,eobj.OperationCode,eobj.OperationName) //校验重复
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.OperationRowId,eobj.OperationName,eobj.OperAliasName)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.OperationRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.OperationDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.OperationDict).%OpenId(eobj.OperationRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.OperationDict).%New()
			s bobj.OperationCode = obj.OperationCode  
			s bobj.OperationName = obj.OperationName 
			s bobj.OperAliasName = obj.OperAliasName
			s bobj.UpdateDate=obj.UpdateDate		//创建时间
			s bobj.UpdateUser=obj.UpdateUser	//创建人员
			
		}
		s obj.OperationCode = eobj.OperationCode  
		s obj.OperationName = eobj.OperationName 
		s obj.OperAliasName = eobj.OperAliasName 
		s obj.UpdateDate=$ZDATETIME($H,3)	
		s obj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))	
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.OperationRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.OperationDict","CT.WDT.CDSS.OperationDict","手术字典",id,eobj.OperationName,"A",eobj)
			d:eobj.OperationRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.OperationDict","CT.WDT.CDSS.OperationDict","手术字典",eobj.OperationRowId,eobj.OperationName,"U",eobj,bobj)
		
			//同步修改对照数据
			d:eobj.OperationRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("手术",bobj.OperationCode_"[A]"_bobj.OperationName,eobj.OperationCode_"[A]"_eobj.OperationName)
			
			//[新]手术百科增加一条同名数据    2021-11-25
			d:eobj.OperationRowId="" ##class(web.CDSS.CMKB.Term).SaveTerm("手术",eobj.OperationName,"")
			d:eobj.OperationRowId'="" ##class(web.CDSS.CMKB.Term).SaveTerm("手术",eobj.OperationName,bobj.OperationName)
			
			//同步修改识别词项目数据    2021-11-25
			d:eobj.OperationRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("手术名称",eobj.OperationName,bobj.OperationName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.OperationRowId="")&&(eobj.OperAliasName'=""))||((eobj.OperationRowId'="")&&(eobj.OperAliasName'=bobj.OperAliasName))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.OperationDict",id,eobj.OperAliasName)
            }
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("手术字典","web.CDSS.CMKB.OperationDictDetail","SaveAmendData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("手术字典","web.CDSS.CMKB.OperationDictDetail","SaveAmendData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-05-25
/// Description:数据批量删除处理（根据静静给的删除数据名称批量删除）
/// Table: CT.WDT.CDSS.OperationDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.OperationDictDetail).BatchDeleteData("C:\Users\墨羽旌\Desktop\需删除的手术数据.csv")
ClassMethod BatchDeleteData(path)
{
	s readcount=0   	//读取总数
	s delcount=0		//删除成功总数
	s nodelcount=0 		//删除失败总数
	s nocount=0			//不存在总数
	s result=""
	
	TS
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		s OperationName=$p(str,",",1)	//手术名称
		//去除两端空白
		s OperationName=$zstrip(OperationName,"<>W")
		s readcount=readcount+1
		
		s RowId=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_OperationName,0))
		
		if (RowId'="")
		{
			s result=..DeleteData(RowId)
			
			if (result["true")
			{
				s delcount=delcount+1
			}
			else
			{
				s nodelcount=nodelcount+1
				w OperationName_"删除失败",!
			}
		}
		else
		{
			s nocount=nocount+1
			w OperationName_"不存在",!
			continue	
		}
	}
	w "readcount："_readcount,!
	w "delcount："_delcount,!
	w "nodelcount:"_nodelcount,!
	w "nocount:"_nocount,!
	
	TC
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.OperationDictDetail","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.OperationDict",RowId,LogID),-1) q:LogID=""
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
/// Description：转存手术字典数据到手术百科【百科中不存在的数据】
/// Table： CT.WDT.CDSS.OperationDict	手术字典
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.OperationDictDetail).TransferSaveData()
ClassMethod TransferSaveData() As %String
{
	s count=0
	s OperationRowId=""
	for
	{ 
		s OperationRowId=$o(^CT.WDT.CDSS.OperationDictD(OperationRowId),-1) q:OperationRowId="" 
		s OperationName=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),4)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(OperationRowId)),12)
		continue:(UseFlag=1)	//过滤已弃用数据
		s BaseDR=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_"手术",0))
		if (BaseDR'="")
		{
			//如果百科中不存在，调用接口保存
			if ('$d(^CT.WDT.CDSS.TermI("DescIndex",BaseDR," "_($ZCONVERT(OperationName,"U")))))	
			{
				d ##class(web.CDSS.CMKB.Term).SaveTerm("手术",OperationName,"")
				s count=count+1
			}	
		}
	}
	//w "共检测到"_count_"条数据。"
	w "处理完成,共处理"_count_"条数据。"
}

/// Creator：赵文伟 
/// CreatDate: 2023-05-19
/// Description：批量删除已弃用数据[未被引用或只被字典对照引用]
/// Table: CT.WDT.CDSS.OperationDict
/// Other: w ##class(web.CDSS.CMKB.OperationDictDetail).DeleteDeprecatedData() 
ClassMethod DeleteDeprecatedData() As %String
{
	s count=0
	s RowId=""
	for
	{ 	
		s RowId=$o(^CT.WDT.CDSS.OperationDictD(RowId),-1) q:RowId="" 
		s Name=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(RowId)),4)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.OperationDictD(RowId)),12)
		if (UseFlag=1){
			s quoteInfo=..GetRefFlag(RowId)
			if '((quoteInfo["诊疗规则关联触发条件表")||(quoteInfo["规则管理")||(quoteInfo["识别词规则")){
				
				d ##class(web.CDSS.CMKB.OperationDictDetail).DeleteData(RowId)
				w Name_"已删除",!
				s count=count+1
			}
		}
	}
	q "success,已删除"_count_"条数据！"
}

}

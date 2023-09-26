Import SQLUser

/// Function: 医嘱项别名
/// update by chenying
/// chenying
Class web.DHCBL.CT.ARCAlias Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:查询别名操作
/// Table:   ARC_Alias
/// Input:   ParRef 医嘱项id
/// CreateDate:2013-8-27  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCAlias","GetList","")
Query GetList(ParRef As %String) As %Query(ROWSPEC = "ALIASRowId:%String,ALIASText:%String,ALIASDateFrom:%String,ALIASDateTo:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if ParRef'=""
	{
		s ALIASRowId=0
		for
		{
			s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ParRef,ALIASRowId)) q:ALIASRowId=""
			s ALIASType=$p($g(^ARC("ALIAS",ALIASRowId)),"^",5)
			//if ALIASType="ARCIM"
			//{
				s ALIASARCIMDR=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
				//i (ParRef'=ALIASARCIMDR) continue
				s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
				s ALIASDateFrom=$p($g(^ARC("ALIAS",ALIASRowId)),"^",12)
				s ALIASDateTo=$p($g(^ARC("ALIAS",ALIASRowId)),"^",13)
				
				s:ALIASDateFrom'="" ALIASDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ALIASDateFrom) //转换日期格式
				s:ALIASDateTo'="" ALIASDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ALIASDateTo) //转换日期格式
				d OutputRow
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ALIASRowId,ALIASText,ALIASDateFrom,ALIASDateTo)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
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

/// Function: 新增别名
/// CreateDate:2013-5-16 
/// Creator: chenying 
/// Table:   ARC_Alias
/// Others:  w ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias("3||1^www^2018-03-31^")
ClassMethod AddOrderAlias(SaveDataStr As %String) As %String
{
	n (%session,SaveDataStr)

	s eobj = ##class(web.Entity.CT.ARCAlias).%New()
	s eobj.ALIASRowId=""
	s eobj.ALIASARCIMDR=$p(SaveDataStr,"^",1)
	s eobj.ALIASText=$p(SaveDataStr,"^",2)
	s eobj.ALIASDateFrom=$p(SaveDataStr,"^",3)
	s eobj.ALIASDateTo=$p(SaveDataStr,"^",4)
	s Result=##class(web.DHCBL.CT.ARCAlias).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "{""success"":""true"",""info"":""保存成功!""}"
	else  s Ret="{""success"":""false"",""info"":"""_$p($p(Result,"errorinfo:'",2),"'}",1)_"""}"
	q Ret
}

/// Function:  修改别名
/// CreateDate:2013-8-22
/// Creator:   chenying
/// Debug:     w ##class(web.DHCBL.CT.ARCAlias).UpdateOrderAlias("163039^saa^16/05/2016^^13374||1")
ClassMethod UpdateOrderAlias(editorderalias As %String) As %String
{
	n (editorderalias,%session)
	s eobj = ##class(web.Entity.CT.ARCAlias).%New()
	s eobj.ALIASRowId=$p(editorderalias,"^",1)
	s eobj.ALIASARCIMDR=$p(editorderalias,"^",5)
	s eobj.ALIASText=$p(editorderalias,"^",2)
	s eobj.ALIASDateFrom=$p(editorderalias,"^",3)
	s eobj.ALIASDateTo=$p(editorderalias,"^",4)
	s Result=##class(web.DHCBL.CT.ARCAlias).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "{""success"":""true"",""info"":""保存成功!""}"
	else  s Ret="{""success"":""false"",""info"":"""_$p($p(Result,"errorinfo:'",2),"'}",1)_"""}"
	q Ret
}

/// Function: 删除别名
/// CreateDate:2013-8-22
/// Creator: chenying
/// Debug:  w ##class(web.DHCBL.CT.ARCAlias).DeleteData("163039")
ClassMethod DeleteData(rowid As %String) As %String
{
	n (rowid,%session)
	Quit:rowid="" "{success:'false',info:'未选择医嘱项别名,不能删除!'}"

	//用于保存日志
	s obj = ##class(User.ARCAlias).%OpenId(rowid)
	s eobj = ##class(web.Entity.CT.ARCAlias).%New()
	s eobj.ALIASRowId=rowid
	s:obj.ALIASARCIMDR'="" eobj.ALIASARCIMDR=obj.ALIASARCIMDR.%Id()
	s eobj.ALIASText=obj.ALIASText
	s eobj.ALIASDateFrom=obj.ALIASDateFrom
	s eobj.ALIASDateTo=obj.ALIASDateTo
	s eobj.ALIASDesc=obj.ALIASDesc		
	
	s ALIASRowId=rowid
	d ##class(web.DHCBL.CT.ARCAlias).UpdateAliasIndex(ALIASRowId)
	
	Tstart
	s sc=##class(User.ARCAlias).%DeleteId(rowid)
	i $$$ISOK(sc)
	{
		Tc
		//删除时，日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_Alias","User.ARCAlias","医嘱项别名",rowid,eobj.ALIASText,"D",eobj)
		d eobj.%Close()
		Quit "{success:'true',info:'删除成功!'}"
	}
	else
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项别名","web.DHCBL.CT.ARCAlias","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		Quit "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
}

/// Function: 获取医嘱项所有别名
/// CreateDate: 2013-8-22
/// Creator:  chenying
/// Others:   w ##class(web.DHCBL.CT.ARCAlias).GetAliasStr("")
ClassMethod GetAliasStr(arcimrowid As %String) As %String
{
	s aliasStr=""
	s ALIASRowId=0
	for 
	{
		s ALIASRowId=$o(^ARC("ALIAS",ALIASRowId)) q:ALIASRowId=""
		s ALIASARCIMDR=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
		if (arcimrowid=ALIASARCIMDR) 
		{
			s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
			if (aliasStr="")
			{
				s aliasStr=ALIASText
			}
			else 
			{
				s aliasStr=aliasStr_"/"_ALIASText
			}
		}
	}
	q aliasStr
}

/// Function: 获取医嘱项所有别名
/// CreateDate: 2022-09-16
/// Creator:  chenying
/// Others:   w ##class(web.DHCBL.CT.ARCAlias).GetAliasByARCIMRowId("1||1")
ClassMethod GetAliasByARCIMRowId(arcimrowid As %String) As %String
{
	n (arcimrowid)
	s aliasStr=""
	Q:arcimrowid="" ""
	s ALIASRowId=0
	for 
	{
		s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",arcimrowid,ALIASRowId)) q:ALIASRowId=""
		s ALIASARCIMDR=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
		s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
		continue:ALIASText=""
		if (aliasStr="")
		{
			s aliasStr=ALIASText
		}
		else 
		{
			s aliasStr=aliasStr_"^"_ALIASText
		}
	}
	q aliasStr
}

/// rowid (医嘱项rowid)
ClassMethod MultiAddAlias(rowid As %String, AddAliasStr As %String) As %String
{
	n (rowid,AddAliasStr,%session)
	q:AddAliasStr="" "{success:'true'}"
	s flag=0,result=""
	s Aliaslength=$length(AddAliasStr,"*")
	for i=1:1:Aliaslength 
	{
		Set AliasStrI=$P(AddAliasStr,"*",i)
		s eobj = ##class(web.Entity.CT.ARCAlias).%New()
		s eobj.ALIASRowId=""
		s eobj.ALIASARCIMDR=rowid
		s eobj.ALIASText=$p(AliasStrI,"^",1)
		s eobj.ALIASDateFrom=$p(AliasStrI,"^",2)
		s eobj.ALIASDateTo=$p(AliasStrI,"^",3)
		s eobj.ALIASType= "ARCIM" 
		s Result=##class(web.DHCBL.CT.ARCAlias).SaveEntity(eobj)
		if Result["success:'false'" s flag=1
	}
	if flag=1 q "{success:'false',info:'医嘱项别名添加失败, 请通过<医嘱项别名>页签添加!'}"
	else  q "{success:'true'}"
}

/// Creator:陈莹
/// CreatDate:2016-11-28
/// Description:添加或修改医嘱项别名
/// Table:User.ARCAlias
/// Input:id(ARCAlias的ALIASRowId) 
/// Return:成功返回"{success:'true',id:'55！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ARCAlias).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCAlias) As %String
{
	n (%session,eobj)
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.ALIASARCIMDR="" "{success:'false',errorinfo:'没有获取到医嘱项ID!'}"
		S eobj.ALIASDesc=$p($g(^ARCIM($p(eobj.ALIASARCIMDR,"||",1),$p(eobj.ALIASARCIMDR,"||",2),1)),"^",2)  //医嘱项描述
		S eobj.ALIASOrderSubCatDR=$p($g(^ARCIM($p(eobj.ALIASARCIMDR,"||",1),$p(eobj.ALIASARCIMDR,"||",2),1)),"^",10) //医嘱子类Dr
		
		///2018-03-31 医嘱别名里 独立医嘱标志与医嘱项的独立医嘱标志保持一致。
		///而且 独立医嘱新增或者修改时，都会自动另生成一条 0,"DescVIOS",$$ALPHAUP^SSUTIL4(Desc),Desc的索引 
		s eobj.ALIASOrderOnItsOwn = $p($g(^ARCIM($p(eobj.ALIASARCIMDR,"||",1),$p(eobj.ALIASARCIMDR,"||",2),7)),"^",13)    ;独立医嘱
		s:eobj.ALIASDateFrom'="" eobj.ALIASDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALIASDateFrom)
		s:eobj.ALIASDateTo'="" eobj.ALIASDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALIASDateTo)
		s:eobj.ALIASDateFrom="" eobj.ALIASDateFrom=+$h
		
		s:eobj.ALIASText'="" eobj.ALIASText=$ZCONVERT(eobj.ALIASText,"U")
		s flag=##class(web.DHCBL.CT.ARCAlias).FormValidate(eobj.ALIASRowId,eobj.ALIASARCIMDR,eobj.ALIASText)
		if (flag=1) Quit "{success:'false',errorinfo:'医嘱项别名已经存在!'}"
		if (eobj.ALIASRowId="")       
		{
  			s obj = ##class(User.ARCAlias).%New()
		}
		else
		{
			s obj=##class(User.ARCAlias).%OpenId(eobj.ALIASRowId)
			s bobj = ##class(web.Entity.CT.ARCAlias).%New()
			s bobj.ALIASRowId=eobj.ALIASRowId
			s bobj.ALIASARCIMDR=$p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",1)
			s bobj.ALIASType= $p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",5)
			s bobj.ALIASText= $p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",6)
			s bobj.ALIASDesc= $p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",3)
			s bobj.ALIASDateFrom=$p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",12)
			s bobj.ALIASOrderSubCatDR=$p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",4)
			s bobj.ALIASDateTo=$p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",13)	
			s bobj.ALIASOrderOnItsOwn=$p($g(^ARC("ALIAS",eobj.ALIASRowId)),"^",7)
			
			s ALIASRowId=eobj.ALIASRowId
			d ##class(web.DHCBL.CT.ARCAlias).UpdateAliasIndex(ALIASRowId)
		}
		
		Tstart
		d obj.ALIASARCIMDRSetObjectId(eobj.ALIASARCIMDR)
		s obj.ALIASText=eobj.ALIASText
		s obj.ALIASDesc=eobj.ALIASDesc
		d:eobj.ALIASOrderSubCatDR'="" obj.ALIASOrderSubCatDRSetObjectId(eobj.ALIASOrderSubCatDR)
		d:eobj.ALIASOrderSubCatDR="" obj.ALIASOrderSubCatDRSetObjectId("")
		s obj.ALIASDateFrom=eobj.ALIASDateFrom
		s obj.ALIASDateTo=eobj.ALIASDateTo
		s obj.ALIASType="ARCIM"
		s obj.ALIASOrderOnItsOwn =eobj.ALIASOrderOnItsOwn
		
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ALIASRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_Alias","User.ARCAlias","医嘱项别名",id,eobj.ALIASText,"A",eobj)		
			d:eobj.ALIASRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_Alias","User.ARCAlias","医嘱项别名",id,eobj.ALIASText,"U",eobj,bobj)		
		
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项别名","web.DHCBL.CT.ARCAlias","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2016-12-13
/// Description：数据重复校验
/// Table： ARCAlias
/// Input：id,arcimrowid,aliastext
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.ARCAlias).FormValidate(22,"9||1","bd")
ClassMethod FormValidate(id, arcimrowid As %String, aliastext1 As %String) As %String
{
	n (id,arcimrowid,aliastext1)
	q:(arcimrowid="")||(aliastext1="") 0
	s flag=0
	s rowid=0
	for
	{
		s rowid=$o(^ARC("ALIAS",0,"ARCIM",arcimrowid,rowid)) q:(rowid="")||(flag=1)
		s Text=$p($g(^ARC("ALIAS",rowid)),"^",6)
		if ((aliastext1=Text)&(id=""))||((id'="")&(aliastext1=Text)&(rowid'=id)) s flag=1
	}
	q flag
}

/// k ^ARC("ALIAS",0,"DescVIOS",$$ALPHAUP^SSUTIL4(oldALIASDesc),$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
/// k ^ARC("ALIAS",0,"DescVI",$$ALPHAUP^SSUTIL4(oldALIASDesc),$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
/// k ^ARC("ALIAS",0,"DescVIOS",$$ALPHAUP^SSUTIL4(oldALIASDesc),$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
/// k ^ARC("ALIAS",0,"OrderCat-DescVIOS",1,$$ALPHAUP^SSUTIL4(oldALIASDesc),$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
/// chenying 2018-09-02 
/// 解决更新了别名后 部分索引没更新的问题
/// d ##class(web.DHCBL.CT.ARCAlias).UpdateAliasIndex("1270")
ClassMethod UpdateAliasIndex(ALIASRowId) As %String
{
	n (ALIASRowId)
	s updateflag=0
	s oldALIASDesc=$p($g(^ARC("ALIAS",ALIASRowId)),"^",3)
	s oldALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
	s oldALIASOrderSubCatDR=$p($g(^ARC("ALIAS",ALIASRowId)),"^",4)
	s oldALIASOrderOnItsOwn=$p($g(^ARC("ALIAS",ALIASRowId)),"^",7)
	s ALIASARCIMDR=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
	s ARCIMSubscript=$p(ALIASARCIMDR,"||",1)
	s ARCIMVersion=$p(ALIASARCIMDR,"||",2)
	s newALIASDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	S newALIASOrderSubCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子类Dr
	s newALIASOrderOnItsOwn=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)
	if (oldALIASDesc'="")&&(newALIASDesc'=oldALIASDesc)
	{
		K ^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		K ^ARC("ALIAS",0,"DescI",$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		K ^ARC("ALIAS",0,"DescVI",$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		K ^ARC("ALIAS",0,"DescVIOS",$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		s updateflag=1
	}
	if (oldALIASOrderSubCatDR'="")&&(oldALIASDesc'="")&&((newALIASDesc'=oldALIASDesc)||((oldALIASOrderSubCatDR'="")&&(newALIASOrderSubCatDR'=oldALIASOrderSubCatDR)))
	{
		K ^ARC("ALIAS",0,"OrderCat-Desc",oldALIASOrderSubCatDR,$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		K ^ARC("ALIAS",0,"OrderCat-DescI",oldALIASOrderSubCatDR,$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		K ^ARC("ALIAS",0,"OrderCat-DescVI",oldALIASOrderSubCatDR,$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		K ^ARC("ALIAS",0,"OrderCat-DescVIOS",oldALIASOrderSubCatDR,$$ALPHAUP^SSUTIL4(oldALIASText)_" ",$$ALPHAUP^SSUTIL4(oldALIASDesc),ALIASRowId,1)
		s updateflag=1
	}
	
	if (oldALIASOrderOnItsOwn'=newALIASOrderOnItsOwn)
	{
		s updateflag=1
	}
	q updateflag
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2020-12-29
/// Description：同步更新一条医嘱项的所有别名（医嘱项修改时更新别名里医嘱项描述、医嘱子分类和医嘱项独立标志）
///               独立和非独立医嘱时索引不同,独立医嘱的索引 ARC("ALIAS",0,"DescVIOS",TEXT,Desc)
/// Table： ARC_Alias
/// Input：arcimrowid(医嘱项id)
/// Return：修改标志(1修改，0没修改）
/// w ##class(web.DHCBL.CT.ARCAlias).BatchUpdate("1||1")
ClassMethod BatchUpdate(arcimrowid) As %String
{
	n (arcimrowid)
	if arcimrowid'=""
	{
		s ALIASRowId=0
		for
		{
			s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",arcimrowid,ALIASRowId)) Q:ALIASRowId=""
			s ALIASType=$p($g(^ARC("ALIAS",ALIASRowId)),"^",5)
			if ALIASType="ARCIM"
			{
				s updateflag=##class(web.DHCBL.CT.ARCAlias).UpdateAliasIndex(ALIASRowId)
				if (updateflag=1)
				{
					s obj=##class(User.ARCAlias).%OpenId(ALIASRowId)
					s ARCIMSubscript=$p(arcimrowid,"||",1)
					s ARCIMVersion=$p(arcimrowid,"||",2)
					S ALIASOrderSubCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子类Dr
					d obj.ALIASOrderSubCatDRSetObjectId(ALIASOrderSubCatDR)	
					s obj.ALIASDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)  //医嘱项描述
					s obj.ALIASOrderOnItsOwn=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)				
					s sc=obj.%Save()
					do obj.%Close()
				}
			}	
		}
	}
	
	q ""
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2020-12-29
/// Description：同步更新所有医嘱项的别名（医嘱项修改时更新别名里医嘱项描述、医嘱子分类和医嘱项独立标志）
///               独立和非独立医嘱时索引不同,独立医嘱的索引 ARC("ALIAS",0,"DescVIOS",TEXT,Desc)
/// Table： ARC_Alias
/// w ##class(web.DHCBL.CT.ARCAlias).BatchUpdateAllAlias("2020-11-01","2020-11-30")
/// w ##class(web.DHCBL.CT.ARCAlias).BatchUpdateAllAlias("","")
ClassMethod BatchUpdateAllAlias(datefrom As %String, dateto As %String) As %String
{
	s:datefrom'="" datefrom=$zdh(datefrom,3)
	s:dateto'="" dateto=$zdh(dateto,3)
	
	S ALIASRowId=0
	for
	{
		S ALIASRowId=$O(^ARC("ALIAS",ALIASRowId)) q:ALIASRowId=""
		s ALIASType=$p($g(^ARC("ALIAS",ALIASRowId)),"^",5)
		if ALIASType="ARCIM"
		{
			s ALIASARCIMDR=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
			s ARCIMSubscript=$p(ALIASARCIMDR,"||",1)
			s ARCIMVersion=$p(ALIASARCIMDR,"||",2)
			S ARCIMOrderOnItsOwn=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)
			CONTINUE:ARCIMOrderOnItsOwn'="Y"
			s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
			s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
			s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
			if (ARCIMEffDate'="")&&((ARCIMEffDate>datefrom)||(datefrom=""))&&((ARCIMEffDate<=dateto)||(dateto=""))
			{
				s updateflag=##class(web.DHCBL.CT.ARCAlias).UpdateAliasIndex(ALIASRowId)
				if (updateflag=1)
				{
					s obj=##class(User.ARCAlias).%OpenId(ALIASRowId)
					
					w $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2),!   //输出数据看
					s obj.ALIASType="ARCIM"
					s obj.ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
					S ALIASOrderSubCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子类Dr
					d obj.ALIASOrderSubCatDRSetObjectId(ALIASOrderSubCatDR)
					s obj.ALIASDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)  //医嘱项描述
					s obj.ALIASOrderOnItsOwn=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)
					s sc=obj.%Save()
					do obj.%Close()	
				}
			}
		}
	}
	
	q ""
}

/*
/// 去掉医嘱项，收费项，库存项别名里的符号
/// w ##class(web.DHCBL.CT.ARCAlias).BatchUpdateAliasText()
ClassMethod BatchUpdateAliasText() As %String
{
	s ALIASRowId=0
	for
	{
		s ALIASRowId=$o(^ARC("ALIAS",ALIASRowId)) Q:ALIASRowId=""
		s ALIASType=$p($g(^ARC("ALIAS",ALIASRowId)),"^",5)
		if ALIASType="ARCIM"
		{
			
			s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
			s ALIASText=##class(web.DHCBL.BDP.FunLib).RemoveSpecialSymbols(ALIASText)
			s obj=##class(User.ARCAlias).%OpenId(ALIASRowId)
			s obj.ALIASText=ALIASText
			d obj.%Save()
			d obj.%Close()
			
		}	
	}
	
	s TIARowId=0
	for
	{
		s TIARowId=$o(^DHCTARAL(TIARowId))  q:(TIARowId="")||(TIARowId="A")
		s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
		s TIAAlias=##class(web.DHCBL.BDP.FunLib).RemoveSpecialSymbols(TIAAlias)
		s obj=##class(User.DHCTarItemAlias).%OpenId(TIARowId)
		s obj.TIAAlias=TIAAlias
		d obj.%Save()
		d obj.%Close()
	}
	
	s INCAROWID=0
	for
	{
		s INCAROWID=$o(^INCALIAS(INCAROWID))  q:(INCAROWID="")
		s Alias=$p($g(^INCALIAS(INCAROWID)),"^",4)
		s Alias=##class(web.DHCBL.BDP.FunLib).RemoveSpecialSymbols(Alias)
		s obj=##class(User.INCALIAS).%OpenId(INCAROWID)
		s obj.INCATEXT=Alias
		d obj.%Close()
		d obj.%Save()
	}
	q ""
}

/// CreateDate: 2020-04-07
/// Function:批量生成别名
/// Creator:陈莹
/// Debug: D ##class(web.DHCBL.CT.ARCAlias).BatchAddAlias()
ClassMethod BatchAddAlias() As %String
{
	s sub=0
	for
	{
		s sub=$o(^ARCIM(sub)) q:sub=""
		s version=0
		for
		{
			s version=$o(^ARCIM(sub,version)) q:version=""
			s code=$p($G(^ARCIM(sub,version,1)),"^",1)
			s desc=$p($G(^ARCIM(sub,version,1)),"^",2)
			s arcimrowid=sub_"||"_version
			s arcitemcatdr=$p($G(^ARCIM(sub,version,1)),"^",10)
			//s alias=code   //医嘱项代码
			//s alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc)  //医嘱项名称对应的首拼码
			//s alias=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(desc,1)  //医嘱项名称对应的五笔码
			s alias=desc   //医嘱项名称
			//s alias=##class(web.DHCBL.BDP.FunLib).RemoveSpecialSymbols(desc)     //医嘱项名称去掉符号
			s alias=$zcvt(alias,"U") 
			
			s flag= ##class(web.DHCBL.CT.ARCAlias).FormValidate("",arcimrowid,alias)
			continue:flag=1
			if alias'=""
			{			
				k aobj1
				s aobj1=##class(User.ARCAlias).%New()
				d aobj1.ALIASARCIMDRSetObjectId(arcimrowid)
				s aobj1.ALIASText=alias
				s aobj1.ALIASType= "ARCIM" 
				s aobj1.ALIASOrderOnItsOwn="Y" 
				s aobj1.ALIASDateFrom=+$h
				s aobj1.ALIASDesc=desc
				d aobj1.ALIASOrderSubCatDRSetObjectId(arcitemcatdr)
				//s aobj1.ALIASGenType="PY"
				s sc=aobj1.%Save()
			}
			
		}
	}
}


*/
/// CreateDate: 2023-03-27
/// Function:批量set医嘱项名称索引
/// Creator:陈莹
/// Debug: D ##class(web.DHCBL.CT.ARCAlias).SetDescAlias()
ClassMethod SetDescAlias() As %String
{
	s sub=0
	for
	{
		s sub=$o(^ARCIM(sub)) q:sub=""
		s version=0
		for
		{
			s version=$o(^ARCIM(sub,version)) q:version=""
			s desc=$p($G(^ARCIM(sub,version,1)),"^",2)
			continue:desc=""
			s alias=$$ALPHAUP^SSUTIL4(desc)	
			continue:alias=""
			if $d(^ARC("ALIAS",0,"DescVIOS",alias,alias,sub,1))=0
			{
				s ^ARC("ALIAS",0,"DescVIOS",alias,alias,sub,1)=sub_"||"_version_"^"_"ARCIM"
				w desc_" "_alias,!
			}
			b ;1
		}
	}
}

}

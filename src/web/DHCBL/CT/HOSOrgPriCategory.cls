/// Function: 机构分类大类字典
/// Table：CT_BDP_CT.HOS_OrgPriCategory
/// CreateDate:2022-11-24
/// Creator:lujunwen
Class web.DHCBL.CT.HOSOrgPriCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-24
/// Description：机构分类大类字典查询
/// Table：CT_BDP_CT.HOS_OrgPriCategory
/// input id code(机构分类大类代码) desc(机构分类大类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgPriCategory","GetList","","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OPCCode:%String,OPCDesc:%String,OPCSource:%String,OPCActivity:%String,OPCStartDate:%Date,OPCEndDate:%Date,OPCSeqNo:%Float,OPCPYCode:%String,OPCWBCode:%String,OPCMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s OPCCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),2) /// 机构分类大类代码
	    s OPCDesc=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),3) /// 机构分类大类名称
	    s OPCSource=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),4) ///分类来源
		s OPCActivity=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),5) ///是否有效
		s OPCStartDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),6) ///开始日期
		s OPCEndDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),7) //结束日期
	    s:OPCStartDate'="" OPCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OPCStartDate) ///转日期格式
	    s:OPCEndDate'="" OPCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OPCEndDate)	///转日期格式
		s OPCSeqNo=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),11) ///系统排序号
		s OPCPYCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),15) ///拼音码
		s OPCWBCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),16) ///五笔码
		s OPCMark=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),17) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSOrgPriCategoryD(ID)) q:ID=""  ///RowID
		    s OPCCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),2) /// 机构分类大类代码
		    s OPCDesc=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),3) /// 机构分类大类名称
		    s OPCSource=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),4) /// 职务分类来源
			s OPCActivity=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),5) ///是否有效
			s OPCStartDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),6) ///开始日期
			s OPCEndDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),7) //结束日期
		    s:OPCStartDate'="" OPCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OPCStartDate) ///转日期格式
		    s:OPCEndDate'="" OPCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OPCEndDate)	///转日期格式
			s OPCSeqNo=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),11) ///系统排序号	
			s OPCPYCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),15) ///拼音码
			s OPCWBCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),16) ///五笔码
			s OPCMark=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),17) ///备注
	    	if ($ZCONVERT(OPCCode,"U")[code)&(($ZCONVERT(OPCDesc,"U")[desc)||($ZCONVERT(OPCPYCode,"U")[desc))
	    	{
	            d OutputRow
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,OPCCode,OPCDesc,OPCSource,OPCActivity,OPCStartDate,OPCEndDate,OPCSeqNo,OPCPYCode,OPCWBCode,OPCMark)
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

/// Creator:鲁俊文
/// CreatDate:2022-11-24
/// Description:为combobox查询取数据
/// Table：CT_BDP_CT.HOS_OrgPriCategory
/// input id code(机构分类大类代码) desc(机构分类大类名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgPriCategory","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OPCCode:%String,OPCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s OPCCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),2) /// 机构分类大类代码
	    s OPCDesc=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),3) /// 机构分类大类名称
		s OPCActivity=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),5) ///是否有效
		s OPCStartDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),6) ///开始日期
		s OPCEndDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),7) //结束日期

	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSOrgPriCategoryD(ID)) q:ID=""  ///RowID
		    s OPCCode=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),2) /// 机构分类大类代码
		    s OPCDesc=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),3) /// 机构分类大类名称
			s OPCActivity=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),5) ///是否有效
			continue:OPCActivity="N"
			s OPCStartDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),6) ///开始日期
			continue:(OPCStartDate'="")&&(OPCStartDate>+$h)
			s OPCEndDate=$lg($g(^CT.BDP.CT.HOSOrgPriCategoryD(ID)),7) //结束日期
			continue:(OPCEndDate'="")&&(OPCEndDate<+$h)
	    	s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OPCDesc)
	    	if ($ZCONVERT(OPCCode,"U")[code)&(($ZCONVERT(OPCDesc,"U")[desc)||(PINYIN[desc))
	    	{
	            d OutputRowCmb
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,OPCCode,OPCDesc)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:    鲁俊文
/// CreatDate:  2022-11-24
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSOrgPriCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgPriCategory).%New()
    s obj = ##class(CT.BDP.CT.HOSOrgPriCategory).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.OPCCode=obj.OPCCode /// 机构分类大类代码
    s eobj.OPCDesc=obj.OPCDesc /// 机构分类大类名称
    s eobj.OPCSource=obj.OPCSource /// 分类来源
    s eobj.OPCActivity=obj.OPCActivity  ///是否有效
    s eobj.OPCStartDate=obj.OPCStartDate  ///开始日期
    s eobj.OPCEndDate=obj.OPCEndDate  ///结束日期
    s:obj.OPCStartDate'="" eobj.OPCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OPCStartDate) ///开始日期(转格式)
    s:obj.OPCEndDate'="" eobj.OPCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OPCEndDate) ///结束日期(转格式) 	
    s eobj.OPCSeqNo=obj.OPCSeqNo  ///系统排序号
    s eobj.OPCPYCode=obj.OPCPYCode  ///拼音码
    s eobj.OPCWBCode=obj.OPCWBCode  ///五笔码
    s eobj.OPCMark=obj.OPCMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-24
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_OrgPriCategory
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSOrgPriCategory).FormValidate("","","测试")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSOrgPriCategoryI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSOrgPriCategoryI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
		
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}	
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月24日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSOrgPriCategory).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSOrgPriCategory).%New()
	s eobj.OPCCode="002"
	s eobj.OPCDesc="测试2"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-24
/// Description：保存机构分类大类代码
/// Table：CT_BDP_CT.HOS_OrgPriCategory
/// Others：w ##class(web.DHCBL.CT.HOSOrgPriCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgPriCategory) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OPCStartDate'="" eobj.OPCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OPCStartDate) ///转日期格式
    	s:eobj.OPCEndDate'="" eobj.OPCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OPCEndDate)	///转日期格式
		s:eobj.OPCStartDate="" eobj.OPCStartDate=+$h
		s:eobj.OPCActivity="" eobj.OPCActivity="N"		
		s eobj.OPCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.OPCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.OPCCreateUser="") s eobj.OPCCreateUser=USERID   ///系统创建人
			if (eobj.OPCLastUpdateUser="") s eobj.OPCLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.OPCCode,eobj.OPCDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSOrgPriCategory).%New()
			d obj.OPCCreateUserSetObjectId(eobj.OPCCreateUser)  ///系统创建人
			s obj.OPCCreateDate=+$H           ///系统创建日期
			s obj.OPCCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSOrgPriCategory).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSOrgPriCategory).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.OPCCode=obj.OPCCode /// 机构分类大类代码
			s bobj.OPCDesc=obj.OPCDesc ///机构分类大类名称
			s bobj.OPCSource=obj.OPCSource ///职务分类来源
			s bobj.OPCActivity=obj.OPCActivity ///是否有效
					
			s bobj.OPCStartDate=obj.OPCStartDate ///开始日期
			s bobj.OPCEndDate=obj.OPCEndDate ///结束日期
			s bobj.OPCCreateDate=obj.OPCCreateDate ///系统创建日期
			s bobj.OPCCreateTime=obj.OPCCreateTime ///系统创建时间
			if $IsObject(obj.OPCCreateUser)
			{   
				s bobj.OPCCreateUser = obj.OPCCreateUser.%Id()   ///系统创建人
			}
			s bobj.OPCSeqNo=obj.OPCSeqNo ///系统排序号
			
			s bobj.OPCLastUpdateDate=obj.OPCLastUpdateDate ///系统最后更新日期
			s bobj.OPCLastUpdateTime=obj.OPCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.OPCLastUpdateUser)
			{   
				s bobj.OPCLastUpdateUser = obj.OPCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.OPCPYCode=obj.OPCPYCode ///拼音码
			s bobj.OPCWBCode=obj.OPCWBCode ///五笔码
			s bobj.OPCMark=obj.OPCMark ///备注
		}
		
		s obj.OPCCode=eobj.OPCCode ///机构分类大类代码
		s obj.OPCDesc=eobj.OPCDesc ///机构分类大类名称
		s obj.OPCSource=eobj.OPCSource ///职务分类来源
		s obj.OPCActivity=eobj.OPCActivity		  ///是否有效
		s obj.OPCStartDate= eobj.OPCStartDate     ///开始日期
	    s obj.OPCEndDate= eobj.OPCEndDate 		 ///结束日期
		s obj.OPCSeqNo=eobj.OPCSeqNo ///系统排序号
		s obj.OPCLastUpdateDate=eobj.OPCLastUpdateDate ///系统最后更新日期
		s obj.OPCLastUpdateTime=eobj.OPCLastUpdateTime ///系统最后更新时间
		d obj.OPCLastUpdateUserSetObjectId(eobj.OPCLastUpdateUser)  ///系统最新更新人
		s:eobj.OPCPYCode="" eobj.OPCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.OPCDesc,4) //自动生成拼音码
		s obj.OPCPYCode=eobj.OPCPYCode ///拼音码
		s:eobj.OPCWBCode="" eobj.OPCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.OPCDesc,1) //自动生成五笔码
		s obj.OPCWBCode=eobj.OPCWBCode ///五笔码
		s obj.OPCMark=eobj.OPCMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgPriCategory","CT.BDP.CT.HOSOrgPriCategory","机构分类大类字典",eobj.ID,eobj.OPCDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgPriCategory","CT.BDP.CT.HOSOrgPriCategory","机构分类大类字典",id,eobj.OPCDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("机构分类大类字典","web.DHCBL.CT.HOSOrgPriCategory","SaveEntity",eobj) 
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:鲁俊文
/// CreatDate:2022-12-5
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s SecCategoryParRef=0
	s ChildSub=0
	for
	{
	s SecCategoryParRef=$o(^CT.BDP.CT.HOSOrgPriCategoryD(id,"ChildOrgSecCategory",SecCategoryParRef)) q:ChildSub=""
		for
		{
		s ChildSub=$o(^CT.BDP.CT.HOSOrgPriCategoryD(id,"ChildOrgSecCategory",SecCategoryParRef,"ChildOrgFinCategory",ChildSub)) q:ChildSub=""
		s ID=id_"||"_SecCategoryParRef_"||"_ChildSub			
		if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGFCCode",ID))
		{
			s myInfo=myInfo_"<组织机构树>"
		}		
		i myInfo="" s return="0^未被引用可删除！"
		else  s return="1^在"_myInfo_"表里被引用,不能删除！"
		}
	}
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-10
/// Description：根据ID删除机构分类大类字典的内容
/// Table：CT_BDP_CT.HOS_OrgPriCategory
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgPriCategory).DeleteData("3")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSOrgPriCategory).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		
	s pobj = ##class(CT.BDP.CT.HOSOrgPriCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSOrgPriCategory).%New()
	s eobj.OPCCode=pobj.OPCCode ///机构分类大类代码
	s eobj.OPCDesc=pobj.OPCDesc ///机构分类大类名称
	s eobj.OPCSource=pobj.OPCSource ///职务分类来源
	s eobj.OPCActivity=pobj.OPCActivity ///是否有效		
	s eobj.OPCStartDate=pobj.OPCStartDate ///开始日期
	s eobj.OPCEndDate=pobj.OPCEndDate ///结束日期
	
	s eobj.OPCCreateDate=pobj.OPCCreateDate ///系统创建日期
	s eobj.OPCCreateTime=pobj.OPCCreateTime ///系统创建时间
	if $IsObject(pobj.OPCCreateUser)
	{   
		s eobj.OPCCreateUser = pobj.OPCCreateUser.%Id()   ///系统创建人
	}
	s eobj.OPCSeqNo=pobj.OPCSeqNo ///系统排序号
	s eobj.OPCLastUpdateDate=pobj.OPCLastUpdateDate ///系统最后更新日期
	s eobj.OPCLastUpdateTime=pobj.OPCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.OPCLastUpdateUser)
	{   
		s eobj.OPCLastUpdateUser = pobj.OPCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.OPCPYCode=pobj.OPCPYCode ///拼音码
	s eobj.OPCWBCode=pobj.OPCWBCode ///五笔码
	s eobj.OPCMark=pobj.OPCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSOrgPriCategory).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgPriCategory","CT.BDP.CT.HOSOrgPriCategory","机构分类大类字典",id,eobj.OPCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("机构分类大类字典","web.DHCBL.CT.HOSOrgPriCategory","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	 
	q result
}

}

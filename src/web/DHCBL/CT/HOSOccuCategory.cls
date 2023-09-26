/// Function: 职业大类字典
/// Table：CT_BDP_CT.HOS_OccuCategory
/// CreateDate:2022-11-14
/// Creator:lujunwen
Class web.DHCBL.CT.HOSOccuCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-18
/// Description：职业大类信息查询
/// Table：CT_BDP_CT.HOS_OccuCategory
/// input id code(职业大类代码) desc(职业大类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOccuCategory","GetList","1","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OCCUCCode:%String,OCCUCDesc:%String,OCCUCActivity:%String,OCCUCStartDate:%Date,OCCUCEndDate:%Date,OCCUCSeqNo:%Float,OCCUCPYCode:%String,OCCUCWBCode:%String,OCCUCMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSOccuCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s OCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),2) /// 职业大类代码
	    s OCCUCDesc=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),3) /// 职业大类名称
		s OCCUCActivity=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),4) ///是否有效
		s OCCUCStartDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),5) ///开始日期
		s OCCUCEndDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),6) //结束日期
	    s:OCCUCStartDate'="" OCCUCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUCStartDate) ///转日期格式
	    s:OCCUCEndDate'="" OCCUCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUCEndDate)	///转日期格式
		s OCCUCSeqNo=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),10) ///系统排序号	
		s OCCUCPYCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),14) ///拼音码
		s OCCUCWBCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),15) ///五笔码
		s OCCUCMark=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),16) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSOccuCategoryD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{			
			    s OCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),2) /// 职业大类代码
			    s OCCUCDesc=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),3) /// 职业大类名称
				s OCCUCActivity=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),4) ///是否有效
				s OCCUCStartDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),5) ///开始日期
				s OCCUCEndDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),6) //结束日期
			    s:OCCUCStartDate'="" OCCUCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUCStartDate) ///转日期格式
			    s:OCCUCEndDate'="" OCCUCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUCEndDate)	///转日期格式
				s OCCUCSeqNo=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),10) ///系统排序号
				s OCCUCPYCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),14) ///拼音码
				s OCCUCWBCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),15) ///五笔码
				s OCCUCMark=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),16) ///备注
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OCCUCDesc)
		    	if ($ZCONVERT(OCCUCCode,"U")[code)&(($ZCONVERT(OCCUCDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRow
		    	}
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,OCCUCCode,OCCUCDesc,OCCUCActivity,OCCUCStartDate,OCCUCEndDate,OCCUCSeqNo,OCCUCPYCode,OCCUCWBCode,OCCUCMark)
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
/// CreatDate:2022-11-18
/// Description:为combobox查询取数据
/// Table：Table：CT_BDP_CT.HOS_OccuCategory
/// input id code(职业大类代码) desc(职业大类名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOccuCategory","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OCCUCCode:%String,OCCUCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1 
    s AuStr=##class(web.DHCBL.Authorize.HOSOccuCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s OCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),2) /// 职业大类代码
	    s OCCUCDesc=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),3) /// 职业大类名称
		s OCCUCActivity=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),4) ///是否有效
		s OCCUCStartDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),5) ///开始日期
		s OCCUCEndDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),6) //结束日期
	    d OutputRowCmb
	}
	else
	{
    	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSOccuCategoryD(ID)) q:ID=""  ///RowID
			s ID=$o(^CT.BDP.CT.HOSOccuCategoryD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{					
			    s OCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),2) /// 职业大类代码
			    s OCCUCDesc=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),3) /// 职业大类名称
				s OCCUCActivity=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),4) ///是否有效
				continue:OCCUCActivity="N"
				s OCCUCStartDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),5) ///开始日期
				continue:(OCCUCStartDate'="")&&(OCCUCStartDate>+$h)
				s OCCUCEndDate=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(ID)),6) //结束日期		
				continue:(OCCUCEndDate'="")&&(OCCUCEndDate<+$h)
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OCCUCDesc)
		    	if (($ZCONVERT(OCCUCDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	}
			} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,OCCUCCode,OCCUCDesc)
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
/// CreatDate:  2022-11-18
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSOccuCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOccuCategory).%New()
    s obj = ##class(CT.BDP.CT.HOSOccuCategory).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.OCCUCCode=obj.OCCUCCode /// 职业大类代码
    s eobj.OCCUCDesc=obj.OCCUCDesc /// 职业大类名称
    s eobj.OCCUCActivity=obj.OCCUCActivity  ///是否有效
    s eobj.OCCUCStartDate=obj.OCCUCStartDate  ///开始日期
    s eobj.OCCUCEndDate=obj.OCCUCEndDate  ///结束日期
    s:obj.OCCUCStartDate'="" eobj.OCCUCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OCCUCStartDate) ///开始日期(转格式)
    s:obj.OCCUCEndDate'="" eobj.OCCUCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OCCUCEndDate) ///结束日期(转格式) 
    s eobj.OCCUCSeqNo=obj.OCCUCSeqNo  ///系统排序号
    s eobj.OCCUCPYCode=obj.OCCUCPYCode  ///拼音码
    s eobj.OCCUCWBCode=obj.OCCUCWBCode  ///五笔码
    s eobj.OCCUCMark=obj.OCCUCMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-18
/// Description：重复校验
/// Table：Table：CT_BDP_CT.HOS_OccuCategory
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSOccuCategory).FormValidate("2","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSOccuCategoryI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSOccuCategoryI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}		
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月18日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSOccuCategory).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSOccuCategory).%New()
	s eobj.OCCUCCode="001"
	s eobj.OCCUCDesc="工人"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-18
/// Description：保存职业大类代码
/// Table：Table：CT_BDP_CT.HOS_OccuCategory
/// Others：w ##class(web.DHCBL.CT.HOSOccuCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOccuCategory) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OCCUCStartDate'="" eobj.OCCUCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OCCUCStartDate) ///转日期格式
    	s:eobj.OCCUCEndDate'="" eobj.OCCUCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OCCUCEndDate)	///转日期格式
		s:eobj.OCCUCStartDate="" eobj.OCCUCStartDate=+$h
		s:eobj.OCCUCActivity="" eobj.OCCUCActivity="N"
		
		s eobj.OCCUCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.OCCUCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.OCCUCCreateUser="") s eobj.OCCUCCreateUser=USERID   ///系统创建人
			if (eobj.OCCUCLastUpdateUser="") s eobj.OCCUCLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.OCCUCCode,eobj.OCCUCDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSOccuCategory).%New()
			d obj.OCCUCCreateUserSetObjectId(eobj.OCCUCCreateUser)  ///系统创建人
			s obj.OCCUCCreateDate=+$H           ///系统创建日期
			s obj.OCCUCCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSOccuCategory).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSOccuCategory).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.OCCUCCode=obj.OCCUCCode /// 职业大类代码
			s bobj.OCCUCDesc=obj.OCCUCDesc ///职业大类名称
			s bobj.OCCUCActivity=obj.OCCUCActivity ///是否有效
					
			s bobj.OCCUCStartDate=obj.OCCUCStartDate ///开始日期
			s bobj.OCCUCEndDate=obj.OCCUCEndDate ///结束日期
			s bobj.OCCUCCreateDate=obj.OCCUCCreateDate ///系统创建日期
			s bobj.OCCUCCreateTime=obj.OCCUCCreateTime ///系统创建时间
			if $IsObject(obj.OCCUCCreateUser)
			{   
				s bobj.OCCUCCreateUser = obj.OCCUCCreateUser.%Id()   ///系统创建人
			}
			s bobj.OCCUCSeqNo=obj.OCCUCSeqNo ///系统排序号
			
			s bobj.OCCUCLastUpdateDate=obj.OCCUCLastUpdateDate ///系统最后更新日期
			s bobj.OCCUCLastUpdateTime=obj.OCCUCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.OCCUCLastUpdateUser)
			{   
				s bobj.OCCUCLastUpdateUser = obj.OCCUCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.OCCUCPYCode=obj.OCCUCPYCode ///拼音码
			s bobj.OCCUCWBCode=obj.OCCUCWBCode ///五笔码
			s bobj.OCCUCMark=obj.OCCUCMark ///备注
		}
		
		s obj.OCCUCCode=eobj.OCCUCCode ///职业大类代码
		s obj.OCCUCDesc=eobj.OCCUCDesc ///职业大类名称
		s obj.OCCUCActivity=eobj.OCCUCActivity		  ///是否有效
		s obj.OCCUCStartDate= eobj.OCCUCStartDate     ///开始日期
	    s obj.OCCUCEndDate= eobj.OCCUCEndDate 		 ///结束日期
		s obj.OCCUCSeqNo=eobj.OCCUCSeqNo ///系统排序号
		s obj.OCCUCLastUpdateDate=eobj.OCCUCLastUpdateDate ///系统最后更新日期
		s obj.OCCUCLastUpdateTime=eobj.OCCUCLastUpdateTime ///系统最后更新时间
		d obj.OCCUCLastUpdateUserSetObjectId(eobj.OCCUCLastUpdateUser)  ///系统最新更新人
		s:eobj.OCCUCPYCode="" eobj.OCCUCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.OCCUCDesc,4) ///自动生成拼音码
		s obj.OCCUCPYCode=eobj.OCCUCPYCode ///拼音码
		s:eobj.OCCUCWBCode="" eobj.OCCUCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.OCCUCDesc,1) ///自动生成五笔码
		s obj.OCCUCWBCode=eobj.OCCUCWBCode ///五笔码
		s obj.OCCUCMark=eobj.OCCUCMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OccuCategory","CT.BDP.CT.HOSOccuCategory","职业大类代码",eobj.ID,eobj.OCCUCDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OccuCategory","CT.BDP.CT.HOSOccuCategory","职业大类代码",id,eobj.OCCUCDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业大类代码","web.DHCBL.CT.HOSOccuCategory","SaveEntity",eobj) 
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
/// CreatDate:2023-2-6
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s ID=0,flag=0
	for
	{
		s ID=$o(^CT("OCC",ID)) q:(ID="")||(flag=1)  
		s OCCUOCCUCCode=$p($g(^CT("OCC",ID)),"^",5)
		i OCCUOCCUCCode=id
		{
			s flag=1
			s myInfo=myInfo_"<职业代码>"
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-18
/// Description：根据ID删除职业大类代码的内容
/// Table：CT_BDP_CT.HOS_OccuCategory
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOccuCategory).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSOccuCategory).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){	
	s pobj = ##class(CT.BDP.CT.HOSOccuCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSOccuCategory).%New()
	s eobj.OCCUCCode=pobj.OCCUCCode ///职业大类代码
	s eobj.OCCUCDesc=pobj.OCCUCDesc ///职业大类名称
	
	s eobj.OCCUCActivity=pobj.OCCUCActivity ///是否有效		
	s eobj.OCCUCStartDate=pobj.OCCUCStartDate ///开始日期
	s eobj.OCCUCEndDate=pobj.OCCUCEndDate ///结束日期
	
	s eobj.OCCUCCreateDate=pobj.OCCUCCreateDate ///系统创建日期
	s eobj.OCCUCCreateTime=pobj.OCCUCCreateTime ///系统创建时间
	if $IsObject(pobj.OCCUCCreateUser)
	{   
		s eobj.OCCUCCreateUser = pobj.OCCUCCreateUser.%Id()   ///系统创建人
	}
	s eobj.OCCUCSeqNo=pobj.OCCUCSeqNo ///系统排序号
	s eobj.OCCUCLastUpdateDate=pobj.OCCUCLastUpdateDate ///系统最后更新日期
	s eobj.OCCUCLastUpdateTime=pobj.OCCUCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.OCCUCLastUpdateUser)
	{   
		s eobj.OCCUCLastUpdateUser = pobj.OCCUCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.OCCUCPYCode=pobj.OCCUCPYCode ///拼音码
	s eobj.OCCUCWBCode=pobj.OCCUCWBCode ///五笔码
	s eobj.OCCUCMark=pobj.OCCUCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSOccuCategory).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OccuCategory","CT.BDP.CT.HOSOccuCategory","职业大类代码",id,eobj.OCCUCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业大类代码","web.DHCBL.CT.HOSOccuCategory","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	
	q result
}

}

/// Function: 职务大类代码
/// Table：CT_BDP_CT.HOS_ProfCategory
/// CreateDate:2022-11-10
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-10
/// Description：职务大类代码信息查询
/// Table：CT_BDP_CT.HOS_ProfCategory
/// input id code(职务大类代码) desc(职务大类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfCategory","GetList","1","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFCCode:%String,PROFCDesc:%String,PROFCSource:%String,PROFCActivity:%String,PROFCStartDate:%Date,PROFCEndDate:%Date,PROFCSeqNo:%Float,PROFCPYCode:%String,PROFCWBCode:%String,PROFCMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFCCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),2) /// 职务大类代码
	    s PROFCDesc=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),3) /// 职务大类名称
	    s PROFCSource=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),4) /// 职务分类来源
		s PROFCActivity=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),5) ///是否有效
		s PROFCStartDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),6) ///开始日期
		s PROFCEndDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),7) //结束日期
	    s:PROFCStartDate'="" PROFCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFCStartDate) ///转日期格式
	    s:PROFCEndDate'="" PROFCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFCEndDate)	///转日期格式
		//s PROFCCreateDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),7) ///系统创建日期
		//s PROFCCreateTime=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),8) ///系统创建时间
		
		//s PROFCCreateUser=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),9) ///系统创建人
		s PROFCSeqNo=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),11) ///系统排序号
		//s PROFCLastUpdateDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),12) ///系统最后更新日期
		//s PROFCLastUpdateTime=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),13) ///系统最后更新时间
		//s PROFCLastUpdateUser=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),14) ///系统最后更新人	
		s PROFCPYCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),15) ///拼音码
		s PROFCWBCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),16) ///五笔码
		s PROFCMark=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),17) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfCategoryD(ID)) q:ID=""  ///RowID
		    s PROFCCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),2) /// 职务大类代码
		    s PROFCDesc=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),3) /// 职务大类名称
		    s PROFCSource=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),4) /// 职务分类来源
			s PROFCActivity=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),5) ///是否有效
			s PROFCStartDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),6) ///开始日期
			s PROFCEndDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),7) //结束日期
		    s:PROFCStartDate'="" PROFCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFCStartDate) ///转日期格式
		    s:PROFCEndDate'="" PROFCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFCEndDate)	///转日期格式
			//s PROFCCreateDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),8) ///系统创建日期
			//s PROFCCreateTime=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),9) ///系统创建时间
			//s PROFCCreateUser=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),10) ///系统创建人
			s PROFCSeqNo=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),11) ///系统排序号
			//s PROFCLastUpdateDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),12) ///系统最后更新日期
			//s PROFCLastUpdateTime=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),13) ///系统最后更新时间
			//s PROFCLastUpdateUser=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),14) ///系统最后更新人	
			s PROFCPYCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),15) ///拼音码
			s PROFCWBCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),16) ///五笔码
			s PROFCMark=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),17) ///备注
	    	if ($ZCONVERT(PROFCCode,"U")[code)&(($ZCONVERT(PROFCDesc,"U")[desc)||($ZCONVERT(PROFCPYCode,"U")[desc))
	    	{
	            d OutputRow
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFCCode,PROFCDesc,PROFCSource,PROFCActivity,PROFCStartDate,PROFCEndDate,PROFCSeqNo,PROFCPYCode,PROFCWBCode,PROFCMark)
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
/// CreatDate:2022-11-14
/// Description:为combobox查询取数据
/// Table：CT_BDP_CT.HOS_ProfCategory
/// input id code(职务代码) desc(职务名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfCategory","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFCCode:%String,PROFCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFCCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),2) /// 职务大类代码
	    s PROFCDesc=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),3) /// 职务大类名称
		s PROFCActivity=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),5) ///是否有效
		s PROFCStartDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),6) ///开始日期
		s PROFCEndDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),7) //结束日期
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfCategoryD(ID)) q:ID=""  ///RowID
		    s PROFCCode=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),2) /// 职务大类代码
		    s PROFCDesc=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),3) /// 职务大类名称
			s PROFCActivity=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),5) ///是否有效
			continue:PROFCActivity="N"
			s PROFCStartDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),6) ///开始日期
			continue:(PROFCStartDate'="")&&(PROFCStartDate>+$h)
			s PROFCEndDate=$lg($g(^CT.BDP.CT.HOSProfCategoryD(ID)),7) //结束日期			
			continue:(PROFCEndDate'="")&&(PROFCEndDate<+$h)
	    	s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFCDesc)
	    	if ($ZCONVERT(PROFCCode,"U")[code)&(($ZCONVERT(PROFCDesc,"U")[desc)||(PINYIN[desc))
	    	{
	            d OutputRowCmb
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PROFCCode,PROFCDesc)
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
/// CreatDate:  2022-11-14
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSProfCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSProfCategory).%New()
    s obj = ##class(CT.BDP.CT.HOSProfCategory).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PROFCCode=obj.PROFCCode /// 职务大类代码
    s eobj.PROFCDesc=obj.PROFCDesc /// 职务大类名称
    s eobj.PROFCSource=obj.PROFCSource /// 职务分类来源
    s eobj.PROFCActivity=obj.PROFCActivity  ///是否有效
    s eobj.PROFCStartDate=obj.PROFCStartDate  ///开始日期
    s eobj.PROFCEndDate=obj.PROFCEndDate  ///结束日期
    s:obj.PROFCStartDate'="" eobj.PROFCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFCStartDate) ///开始日期(转格式)
    s:obj.PROFCEndDate'="" eobj.PROFCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFCEndDate) ///结束日期(转格式) 	
    s eobj.PROFCSeqNo=obj.PROFCSeqNo  ///系统排序号
    s eobj.PROFCPYCode=obj.PROFCPYCode  ///拼音码
    s eobj.PROFCWBCode=obj.PROFCWBCode  ///五笔码
    s eobj.PROFCMark=obj.PROFCMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-11
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_ProfCategory
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSProfCategory).FormValidate("2","","技术类")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfCategoryI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfCategoryI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}		
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月10日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSProfCategory).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSProfCategory).%New()
	s eobj.PROFCCode="002"
	s eobj.PROFCDesc="营销类"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-10
/// Description：保存职务大类代码
/// Table：CT_BDP_CT.HOS_ProfCategory
/// Others：w ##class(web.DHCBL.CT.HOSProfCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfCategory) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFCStartDate'="" eobj.PROFCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFCStartDate) ///转日期格式
    	s:eobj.PROFCEndDate'="" eobj.PROFCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFCEndDate)	///转日期格式
		s:eobj.PROFCStartDate="" eobj.PROFCStartDate=+$h
		s:eobj.PROFCActivity="" eobj.PROFCActivity="N"
		
		s eobj.PROFCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PROFCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFCCreateUser="") s eobj.PROFCCreateUser=USERID   ///系统创建人
			if (eobj.PROFCLastUpdateUser="") s eobj.PROFCLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.PROFCCode,eobj.PROFCDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProfCategory).%New()
			d obj.PROFCCreateUserSetObjectId(eobj.PROFCCreateUser)  ///系统创建人
			s obj.PROFCCreateDate=+$H           ///系统创建日期
			s obj.PROFCCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfCategory).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfCategory).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.PROFCCode=obj.PROFCCode /// 职务大类代码
			s bobj.PROFCDesc=obj.PROFCDesc ///职务大类名称
			s bobj.PROFCSource=obj.PROFCSource ///职务分类来源
			s bobj.PROFCActivity=obj.PROFCActivity ///是否有效
					
			s bobj.PROFCStartDate=obj.PROFCStartDate ///开始日期
			s bobj.PROFCEndDate=obj.PROFCEndDate ///结束日期
			s bobj.PROFCCreateDate=obj.PROFCCreateDate ///系统创建日期
			s bobj.PROFCCreateTime=obj.PROFCCreateTime ///系统创建时间
			if $IsObject(obj.PROFCCreateUser)
			{   
				s bobj.PROFCCreateUser = obj.PROFCCreateUser.%Id()   ///系统创建人
			}
			s bobj.PROFCSeqNo=obj.PROFCSeqNo ///系统排序号
			
			s bobj.PROFCLastUpdateDate=obj.PROFCLastUpdateDate ///系统最后更新日期
			s bobj.PROFCLastUpdateTime=obj.PROFCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFCLastUpdateUser)
			{   
				s bobj.PROFCLastUpdateUser = obj.PROFCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFCPYCode=obj.PROFCPYCode ///拼音码
			s bobj.PROFCWBCode=obj.PROFCWBCode ///五笔码
			s bobj.PROFCMark=obj.PROFCMark ///备注
		}
		
		s obj.PROFCCode=eobj.PROFCCode ///职务大类代码
		s obj.PROFCDesc=eobj.PROFCDesc ///职务大类名称
		s obj.PROFCSource=eobj.PROFCSource ///职务分类来源
		s obj.PROFCActivity=eobj.PROFCActivity		  ///是否有效
		s obj.PROFCStartDate= eobj.PROFCStartDate     ///开始日期
	    s obj.PROFCEndDate= eobj.PROFCEndDate 		 ///结束日期
		s obj.PROFCSeqNo=eobj.PROFCSeqNo ///系统排序号
		s obj.PROFCLastUpdateDate=eobj.PROFCLastUpdateDate ///系统最后更新日期
		s obj.PROFCLastUpdateTime=eobj.PROFCLastUpdateTime ///系统最后更新时间
		d obj.PROFCLastUpdateUserSetObjectId(eobj.PROFCLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFCPYCode="" eobj.PROFCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFCDesc,4) //自动生成拼音码
		s obj.PROFCPYCode=eobj.PROFCPYCode ///拼音码
		s:eobj.PROFCWBCode="" eobj.PROFCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFCDesc,1) //自动生成五笔码
		s obj.PROFCWBCode=eobj.PROFCWBCode ///五笔码
		s obj.PROFCMark=eobj.PROFCMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfCategory","CT.BDP.CT.HOSProfCategory","职务大类代码",eobj.ID,eobj.PROFCDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfCategory","CT.BDP.CT.HOSProfCategory","职务大类代码",id,eobj.PROFCDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务大类代码","web.DHCBL.CT.HOSProfCategory","SaveEntity",eobj) 
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
/// CreatDate:2022-11-10
/// Description：根据ID删除职务大类代码的内容
/// Table：CT_BDP_CT.HOS_ProfCategory
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfCategory).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s pobj = ##class(CT.BDP.CT.HOSProfCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfCategory).%New()
	s eobj.PROFCCode=pobj.PROFCCode ///职务大类代码
	s eobj.PROFCDesc=pobj.PROFCDesc ///职务大类名称
	s eobj.PROFCSource=pobj.PROFCSource ///职务分类来源
	s eobj.PROFCActivity=pobj.PROFCActivity ///是否有效		
	s eobj.PROFCStartDate=pobj.PROFCStartDate ///开始日期
	s eobj.PROFCEndDate=pobj.PROFCEndDate ///结束日期
	
	s eobj.PROFCCreateDate=pobj.PROFCCreateDate ///系统创建日期
	s eobj.PROFCCreateTime=pobj.PROFCCreateTime ///系统创建时间
	if $IsObject(pobj.PROFCCreateUser)
	{   
		s eobj.PROFCCreateUser = pobj.PROFCCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFCSeqNo=pobj.PROFCSeqNo ///系统排序号
	s eobj.PROFCLastUpdateDate=pobj.PROFCLastUpdateDate ///系统最后更新日期
	s eobj.PROFCLastUpdateTime=pobj.PROFCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFCLastUpdateUser)
	{   
		s eobj.PROFCLastUpdateUser = pobj.PROFCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFCPYCode=pobj.PROFCPYCode ///拼音码
	s eobj.PROFCWBCode=pobj.PROFCWBCode ///五笔码
	s eobj.PROFCMark=pobj.PROFCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfCategory).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfCategory","CT.BDP.CT.HOSProfCategory","职务大类代码",id,eobj.PROFCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务大类代码","web.DHCBL.CT.HOSProfCategory","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

}

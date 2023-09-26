/// Function: 职务类型代码
/// Table：CT_BDP_CT.HOS_ProfType
/// CreateDate:2022-11-10
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-10
/// Description：职务类型代码信息查询
/// Table：CT_BDP_CT.HOS_ProfType
/// input id code(职务类型代码) desc(职务类型名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfType","GetList","1","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFTYCode:%String,PROFTYDesc:%String,PROFTYActivity:%String,PROFTYStartDate:%Date,PROFTYEndDate:%Date,PROFTYSeqNo:%Float,PROFTYPYCode:%String,PROFTYWBCode:%String,PROFTYMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFTYCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),2) /// 职务类型代码
	    s PROFTYDesc=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),3) /// 职务类型名称
		s PROFTYActivity=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),4) ///是否有效
		s PROFTYStartDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),5) ///开始日期
		s PROFTYEndDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),6) //结束日期
	    s:PROFTYStartDate'="" PROFTYStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTYStartDate) ///转日期格式
	    s:PROFTYEndDate'="" PROFTYEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTYEndDate)	///转日期格式
		s PROFTYSeqNo=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),10) ///系统排序号
		s PROFTYPYCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),14) ///拼音码
		s PROFTYWBCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),15) ///五笔码
		s PROFTYMark=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),16) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfTypeD(ID)) q:ID=""  ///RowID
		    s PROFTYCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),2) /// 职务类型代码
		    s PROFTYDesc=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),3) /// 职务类型名称
			s PROFTYActivity=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),4) ///是否有效
			s PROFTYStartDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),5) ///开始日期
			s PROFTYEndDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),6) //结束日期
		    s:PROFTYStartDate'="" PROFTYStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTYStartDate) ///转日期格式
		    s:PROFTYEndDate'="" PROFTYEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTYEndDate)	///转日期格式
			s PROFTYSeqNo=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),10) ///系统排序号	
			s PROFTYPYCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),14) ///拼音码
			s PROFTYWBCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),15) ///五笔码
			s PROFTYMark=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),16) ///备注
	    	if ($ZCONVERT(PROFTYCode,"U")[code)&(($ZCONVERT(PROFTYDesc,"U")[desc)||($ZCONVERT(PROFTYPYCode,"U")[desc))
	    	{
	            d OutputRow
	    	} 
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFTYCode,PROFTYDesc,PROFTYActivity,PROFTYStartDate,PROFTYEndDate,PROFTYSeqNo,PROFTYPYCode,PROFTYWBCode,PROFTYMark)
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
/// Table：CT_BDP_CT.HOS_ProfType
/// input id code(职务类型代码) desc(职务类型名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfType","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFTYCode:%String,PROFTYDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFTYCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),2) /// 职务类型代码
	    s PROFTYDesc=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),3) /// 职务类型名称
		s PROFTYActivity=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),4) ///是否有效
		s PROFTYStartDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),5) ///开始日期
		s PROFTYEndDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),6) //结束日期	
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfTypeD(ID)) q:ID=""  ///RowID
		    s PROFTYCode=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),2) /// 职务类型代码
		    s PROFTYDesc=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),3) /// 职务类型名称 
			s PROFTYActivity=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),4) ///是否有效(Y/N)
			continue:PROFTYActivity="N"
			s PROFTYStartDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),5) ///开始日期
			continue:(PROFTYStartDate'="")&&(PROFTYStartDate>+$h)
			s PROFTYEndDate=$lg($g(^CT.BDP.CT.HOSProfTypeD(ID)),6) //结束日期
			continue:(PROFTYEndDate'="")&&(PROFTYEndDate<+$h)		
	    	s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFTYDesc)
	    	if ($ZCONVERT(PROFTYCode,"U")[code)&(($ZCONVERT(PROFTYDesc,"U")[desc)||(PINYIN[desc))
	    	{
	            d OutputRowCmb
	    	} 
			}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PROFTYCode,PROFTYDesc)
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
/// CreatDate:  2022-11-10
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSProfType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSProfType).%New()
    s obj = ##class(CT.BDP.CT.HOSProfType).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PROFTYCode=obj.PROFTYCode /// 职务类型代码
    s eobj.PROFTYDesc=obj.PROFTYDesc /// 职务类型名称
    s eobj.PROFTYActivity=obj.PROFTYActivity  ///是否有效
    s eobj.PROFTYStartDate=obj.PROFTYStartDate  ///开始日期
    s eobj.PROFTYEndDate=obj.PROFTYEndDate  ///结束日期
    s:obj.PROFTYStartDate'="" eobj.PROFTYStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFTYStartDate) ///开始日期(转格式)
    s:obj.PROFTYEndDate'="" eobj.PROFTYEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFTYEndDate) ///结束日期(转格式) 
    s eobj.PROFTYPYCode=obj.PROFTYPYCode  ///拼音码
    s eobj.PROFTYWBCode=obj.PROFTYWBCode  ///五笔码
    s eobj.PROFTYMark=obj.PROFTYMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-11
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_ProfType
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSProfType).FormValidate("2","","公务员")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfTypeI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfTypeI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
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
/// debug：d ##class(web.DHCBL.CT.HOSProfType).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSProfType).%New()
	s eobj.PROFTYCode="002"
	s eobj.PROFTYDesc="专业技术人员"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-10
/// Description：保存职务类型代码
/// Table：CT_BDP_CT.HOS_ProfType
/// Others：w ##class(web.DHCBL.CT.HOSProfType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfType) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFTYStartDate'="" eobj.PROFTYStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFTYStartDate) ///转日期格式
    	s:eobj.PROFTYEndDate'="" eobj.PROFTYEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFTYEndDate)	///转日期格式
		s:eobj.PROFTYStartDate="" eobj.PROFTYStartDate=+$h
		s:eobj.PROFTYActivity="" eobj.PROFTYActivity="N"
		s eobj.PROFTYLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PROFTYLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFTYCreateUser="") s eobj.PROFTYCreateUser=USERID   ///系统创建人
			if (eobj.PROFTYLastUpdateUser="") s eobj.PROFTYLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.PROFTYCode,eobj.PROFTYDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProfType).%New()
			d obj.PROFTYCreateUserSetObjectId(eobj.PROFTYCreateUser)  ///系统创建人
			s obj.PROFTYCreateDate=+$H           ///系统创建日期
			s obj.PROFTYCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfType).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfType).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.PROFTYCode=obj.PROFTYCode /// 职务类型代码
			s bobj.PROFTYDesc=obj.PROFTYDesc ///职务类型名称
			s bobj.PROFTYActivity=obj.PROFTYActivity ///是否有效
					
			s bobj.PROFTYStartDate=obj.PROFTYStartDate ///开始日期
			s bobj.PROFTYEndDate=obj.PROFTYEndDate ///结束日期
			s bobj.PROFTYCreateDate=obj.PROFTYCreateDate ///系统创建日期
			s bobj.PROFTYCreateTime=obj.PROFTYCreateTime ///系统创建时间
			if $IsObject(obj.PROFTYCreateUser)
			{   
				s bobj.PROFTYCreateUser = obj.PROFTYCreateUser.%Id()   ///系统创建人
					
				
			}
			s bobj.PROFTYSeqNo=obj.PROFTYSeqNo ///系统排序号
			
			s bobj.PROFTYLastUpdateDate=obj.PROFTYLastUpdateDate ///系统最后更新日期
			s bobj.PROFTYLastUpdateTime=obj.PROFTYLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFTYLastUpdateUser)
			{   
				s bobj.PROFTYLastUpdateUser = obj.PROFTYLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFTYPYCode=obj.PROFTYPYCode ///拼音码
			s bobj.PROFTYWBCode=obj.PROFTYWBCode ///五笔码
			s bobj.PROFTYMark=obj.PROFTYMark ///备注
		}
		
		s obj.PROFTYCode=eobj.PROFTYCode ///职务类型代码
		s obj.PROFTYDesc=eobj.PROFTYDesc ///职务类型名称
		s obj.PROFTYActivity=eobj.PROFTYActivity		  ///是否有效
		s obj.PROFTYStartDate= eobj.PROFTYStartDate     ///开始日期
	    s obj.PROFTYEndDate= eobj.PROFTYEndDate 		 ///结束日期
		s obj.PROFTYSeqNo=eobj.PROFTYSeqNo ///系统排序号
		s obj.PROFTYLastUpdateDate=eobj.PROFTYLastUpdateDate ///系统最后更新日期
		s obj.PROFTYLastUpdateTime=eobj.PROFTYLastUpdateTime ///系统最后更新时间
		d obj.PROFTYLastUpdateUserSetObjectId(eobj.PROFTYLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFTYPYCode="" eobj.PROFTYPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFTYDesc,4) ///自动生成拼音码
		s obj.PROFTYPYCode=eobj.PROFTYPYCode ///拼音码
		s:eobj.PROFTYWBCode="" eobj.PROFTYWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFTYDesc,1) ///自动生成五笔码
		s obj.PROFTYWBCode=eobj.PROFTYWBCode ///五笔码
		s obj.PROFTYMark=eobj.PROFTYMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfType","CT.BDP.CT.HOSProfType","职务类型代码",eobj.ID,eobj.PROFTYDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfType","CT.BDP.CT.HOSProfType","职务类型代码",id,eobj.PROFTYDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务类型代码","web.DHCBL.CT.HOSProfType","SaveEntity",eobj) 
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
/// Description：根据ID删除职务类型代码的内容
/// Table：CT_BDP_CT.HOS_ProfType
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfType).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s pobj = ##class(CT.BDP.CT.HOSProfType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfType).%New()
	s eobj.PROFTYCode=pobj.PROFTYCode ///职务类型代码
	s eobj.PROFTYDesc=pobj.PROFTYDesc ///职务类型名称
	
	s eobj.PROFTYActivity=pobj.PROFTYActivity ///是否有效		
	s eobj.PROFTYStartDate=pobj.PROFTYStartDate ///开始日期
	s eobj.PROFTYEndDate=pobj.PROFTYEndDate ///结束日期
	
	s eobj.PROFTYCreateDate=pobj.PROFTYCreateDate ///系统创建日期
	s eobj.PROFTYCreateTime=pobj.PROFTYCreateTime ///系统创建时间
	if $IsObject(pobj.PROFTYCreateUser)
	{   
		s eobj.PROFTYCreateUser = pobj.PROFTYCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFTYSeqNo=pobj.PROFTYSeqNo ///系统排序号
	s eobj.PROFTYLastUpdateDate=pobj.PROFTYLastUpdateDate ///系统最后更新日期
	s eobj.PROFTYLastUpdateTime=pobj.PROFTYLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFTYLastUpdateUser)
	{   
		s eobj.PROFTYLastUpdateUser = pobj.PROFTYLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFTYPYCode=pobj.PROFTYPYCode ///拼音码
	s eobj.PROFTYWBCode=pobj.PROFTYWBCode ///五笔码
	s eobj.PROFTYMark=pobj.PROFTYMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfType).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfType","CT.BDP.CT.HOSProfType","职务类型代码",id,eobj.PROFTYDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务类型代码","web.DHCBL.CT.HOSProfType","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

}

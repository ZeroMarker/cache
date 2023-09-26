/// Function: 人员状态
/// Table：CT_BDP_CT.HOS_PersonStatusDict
/// CreateDate:2022-11-23
/// Creator:lujunwen
Class web.DHCBL.CT.HOSPersonStatusDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-18
/// Description：人员状态信息查询
/// Table：CT_BDP_CT.HOS_PersonStatusDict
/// input id code(人员状态代码) desc(人员状态名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPersonStatusDict","GetList","1","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PSDCode:%String,PSDDesc:%String,PSDActivity:%String,PSDStartDate:%Date,PSDEndDate:%Date,PSDSeqNo:%Float,PSDPYCode:%String,PSDWBCode:%String,PSDMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPersonStatusDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PSDCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),2) /// 人员状态代码
	    s PSDDesc=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),3) /// 人员状态名称
		s PSDActivity=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),4) ///是否有效
		s PSDStartDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),5) ///开始日期
		s PSDEndDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),6) //结束日期
	    s:PSDStartDate'="" PSDStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PSDStartDate) ///转日期格式
	    s:PSDEndDate'="" PSDEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PSDEndDate)	///转日期格式
		s PSDSeqNo=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),10) ///系统排序号	
		s PSDPYCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),14) ///拼音码
		s PSDWBCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),15) ///五笔码
		s PSDMark=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),16) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSPersonStatusDictD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{			
			    s PSDCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),2) /// 人员状态代码
			    s PSDDesc=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),3) /// 人员状态名称
				s PSDActivity=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),4) ///是否有效
				s PSDStartDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),5) ///开始日期
				s PSDEndDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),6) //结束日期
			    s:PSDStartDate'="" PSDStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PSDStartDate) ///转日期格式
			    s:PSDEndDate'="" PSDEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PSDEndDate)	///转日期格式
				s PSDSeqNo=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),10) ///系统排序号
				s PSDPYCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),14) ///拼音码
				s PSDWBCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),15) ///五笔码
				s PSDMark=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),16) ///备注
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PSDDesc)
		    	if ($ZCONVERT(PSDCode,"U")[code)&(($ZCONVERT(PSDDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRow
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PSDCode,PSDDesc,PSDActivity,PSDStartDate,PSDEndDate,PSDSeqNo,PSDPYCode,PSDWBCode,PSDMark)
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
/// Table：Table：CT_BDP_CT.HOS_PersonStatusDict
/// input id code(人员状态代码) desc(人员状态名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPersonStatusDict","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PSDCode:%String,PSDDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1 
    s AuStr=##class(web.DHCBL.Authorize.HOSPersonStatusDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	 	 
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PSDCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),2) /// 人员状态代码
	    s PSDDesc=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),3) /// 人员状态名称
		s PSDActivity=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),4) ///是否有效
		s PSDStartDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),5) ///开始日期
		s PSDEndDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),6) //结束日期
	    d OutputRowCmb
	}
	else
	{
    	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSPersonStatusDictD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{				
			    s PSDCode=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),2) /// 人员状态代码
			    s PSDDesc=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),3) /// 人员状态名称
				s PSDActivity=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),4) ///是否有效
				continue:PSDActivity="N"
				s PSDStartDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),5) ///开始日期
				continue:(PSDStartDate'="")&&(PSDStartDate>+$h)
				s PSDEndDate=$lg($g(^CT.BDP.CT.HOSPersonStatusDictD(ID)),6) //结束日期
				continue:(PSDEndDate'="")&&(PSDEndDate<+$h)
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PSDDesc)
		    	if (($ZCONVERT(PSDDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	}
			} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PSDCode,PSDDesc)
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
/// Other: w ##class(web.DHCBL.CT.HOSPersonStatusDict).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPersonStatusDict).%New()
    s obj = ##class(CT.BDP.CT.HOSPersonStatusDict).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PSDCode=obj.PSDCode /// 人员状态代码
    s eobj.PSDDesc=obj.PSDDesc /// 人员状态名称
    s eobj.PSDActivity=obj.PSDActivity  ///是否有效
    s eobj.PSDStartDate=obj.PSDStartDate  ///开始日期
    s eobj.PSDEndDate=obj.PSDEndDate  ///结束日期
    s:obj.PSDStartDate'="" eobj.PSDStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PSDStartDate) ///开始日期(转格式)
    s:obj.PSDEndDate'="" eobj.PSDEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PSDEndDate) ///结束日期(转格式) 
    s eobj.PSDSeqNo=obj.PSDSeqNo  ///系统排序号
    s eobj.PSDPYCode=obj.PSDPYCode  ///拼音码
    s eobj.PSDWBCode=obj.PSDWBCode  ///五笔码
    s eobj.PSDMark=obj.PSDMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-18
/// Description：重复校验
/// Table：Table：CT_BDP_CT.HOS_PersonStatusDict
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSPersonStatusDict).FormValidate("2","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSPersonStatusDictI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSPersonStatusDictI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
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
/// debug：d ##class(web.DHCBL.CT.HOSPersonStatusDict).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSPersonStatusDict).%New()
	s eobj.PSDCode="001"
	s eobj.PSDDesc="在职"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-18
/// Description：保存人员状态代码
/// Table：Table：CT_BDP_CT.HOS_PersonStatusDict
/// Others：w ##class(web.DHCBL.CT.HOSPersonStatusDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPersonStatusDict) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PSDStartDate'="" eobj.PSDStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PSDStartDate) ///转日期格式
    	s:eobj.PSDEndDate'="" eobj.PSDEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PSDEndDate)	///转日期格式
		s:eobj.PSDStartDate="" eobj.PSDStartDate=+$h
		s:eobj.PSDActivity="" eobj.PSDActivity="N"
		
		s eobj.PSDLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PSDLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PSDCreateUser="") s eobj.PSDCreateUser=USERID   ///系统创建人
			if (eobj.PSDLastUpdateUser="") s eobj.PSDLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.PSDCode,eobj.PSDDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSPersonStatusDict).%New()
			d obj.PSDCreateUserSetObjectId(eobj.PSDCreateUser)  ///系统创建人
			s obj.PSDCreateDate=+$H           ///系统创建日期
			s obj.PSDCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSPersonStatusDict).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSPersonStatusDict).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.PSDCode=obj.PSDCode /// 人员状态代码
			s bobj.PSDDesc=obj.PSDDesc ///人员状态名称
			s bobj.PSDActivity=obj.PSDActivity ///是否有效
					
			s bobj.PSDStartDate=obj.PSDStartDate ///开始日期
			s bobj.PSDEndDate=obj.PSDEndDate ///结束日期
			s bobj.PSDCreateDate=obj.PSDCreateDate ///系统创建日期
			s bobj.PSDCreateTime=obj.PSDCreateTime ///系统创建时间
			if $IsObject(obj.PSDCreateUser)
			{   
				s bobj.PSDCreateUser = obj.PSDCreateUser.%Id()   ///系统创建人
			}
			s bobj.PSDSeqNo=obj.PSDSeqNo ///系统排序号
			
			s bobj.PSDLastUpdateDate=obj.PSDLastUpdateDate ///系统最后更新日期
			s bobj.PSDLastUpdateTime=obj.PSDLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PSDLastUpdateUser)
			{   
				s bobj.PSDLastUpdateUser = obj.PSDLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PSDPYCode=obj.PSDPYCode ///拼音码
			s bobj.PSDWBCode=obj.PSDWBCode ///五笔码
			s bobj.PSDMark=obj.PSDMark ///备注
		}
		
		s obj.PSDCode=eobj.PSDCode ///人员状态代码
		s obj.PSDDesc=eobj.PSDDesc ///人员状态名称
		s obj.PSDActivity=eobj.PSDActivity		  ///是否有效
		s obj.PSDStartDate= eobj.PSDStartDate     ///开始日期
	    s obj.PSDEndDate= eobj.PSDEndDate 		 ///结束日期
		s obj.PSDSeqNo=eobj.PSDSeqNo ///系统排序号
		s obj.PSDLastUpdateDate=eobj.PSDLastUpdateDate ///系统最后更新日期
		s obj.PSDLastUpdateTime=eobj.PSDLastUpdateTime ///系统最后更新时间
		d obj.PSDLastUpdateUserSetObjectId(eobj.PSDLastUpdateUser)  ///系统最新更新人
		s:eobj.PSDPYCode="" eobj.PSDPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PSDDesc,4) ///自动生成拼音码
		s obj.PSDPYCode=eobj.PSDPYCode ///拼音码
		s:eobj.PSDWBCode="" eobj.PSDWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PSDDesc,1) ///自动生成五笔码
		s obj.PSDWBCode=eobj.PSDWBCode ///五笔码
		s obj.PSDMark=eobj.PSDMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PersonStatusDict","CT.BDP.CT.HOSPersonStatusDict","人员状态代码",eobj.ID,eobj.PSDDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PersonStatusDict","CT.BDP.CT.HOSPersonStatusDict","人员状态代码",id,eobj.PSDDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员状态代码","web.DHCBL.CT.HOSPersonStatusDict","SaveEntity",eobj) 
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
/// CreatDate:2022-11-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^CT.BDP.CT.HOSPersonI("IndexStatus",id)){
		s myInfo=myInfo_"<人员基本信息>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-18
/// Description：根据ID删除人员状态代码的内容
/// Table：CT_BDP_CT.HOS_PersonStatusDict
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPersonStatusDict).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HOSPersonStatusDict).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		 
	s pobj = ##class(CT.BDP.CT.HOSPersonStatusDict).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSPersonStatusDict).%New()
	s eobj.PSDCode=pobj.PSDCode ///人员状态代码
	s eobj.PSDDesc=pobj.PSDDesc ///人员状态名称
	
	s eobj.PSDActivity=pobj.PSDActivity ///是否有效		
	s eobj.PSDStartDate=pobj.PSDStartDate ///开始日期
	s eobj.PSDEndDate=pobj.PSDEndDate ///结束日期
	
	s eobj.PSDCreateDate=pobj.PSDCreateDate ///系统创建日期
	s eobj.PSDCreateTime=pobj.PSDCreateTime ///系统创建时间
	if $IsObject(pobj.PSDCreateUser)
	{   
		s eobj.PSDCreateUser = pobj.PSDCreateUser.%Id()   ///系统创建人
	}
	s eobj.PSDSeqNo=pobj.PSDSeqNo ///系统排序号
	s eobj.PSDLastUpdateDate=pobj.PSDLastUpdateDate ///系统最后更新日期
	s eobj.PSDLastUpdateTime=pobj.PSDLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PSDLastUpdateUser)
	{   
		s eobj.PSDLastUpdateUser = pobj.PSDLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PSDPYCode=pobj.PSDPYCode ///拼音码
	s eobj.PSDWBCode=pobj.PSDWBCode ///五笔码
	s eobj.PSDMark=pobj.PSDMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSPersonStatusDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PersonStatusDict","CT.BDP.CT.HOSPersonStatusDict","人员状态代码",id,eobj.PSDDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员状态代码","web.DHCBL.CT.HOSPersonStatusDict","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}		
	q result
}

}

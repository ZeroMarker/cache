/// Function: 人员工作状态
/// Table：CT_BDP_CT.HOS_EmpStatusDict
/// CreateDate:2023-2-7
/// Creator:lujunwen
Class web.DHCBL.CT.HOSEmpStatusDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2023-2-7
/// Description：人员工作状态信息查询
/// Table：CT_BDP_CT.HOS_EmpStatusDict
/// input id code(人员工作状态代码) desc(人员工作状态名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSEmpStatusDict","GetList","","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ESDCode:%String,ESDDesc:%String,ESDActivity:%String,ESDStartDate:%Date,ESDEndDate:%Date,ESDSeqNo:%Float,ESDPYCode:%String,ESDWBCode:%String,ESDMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1 
    s AuStr=##class(web.DHCBL.Authorize.HOSEmpStatusDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s ESDCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),2) /// 人员工作状态代码
	    s ESDDesc=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),3) /// 人员工作状态名称
		s ESDActivity=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),4) ///是否有效
		s ESDStartDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),5) ///开始日期
		s ESDEndDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),6) //结束日期
	    s:ESDStartDate'="" ESDStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ESDStartDate) ///转日期格式
	    s:ESDEndDate'="" ESDEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ESDEndDate)	///转日期格式
		s ESDSeqNo=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),10) ///系统排序号	
		s ESDPYCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),14) ///拼音码
		s ESDWBCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),15) ///五笔码
		s ESDMark=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),16) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSEmpStatusDictD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
			    s ESDCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),2) /// 人员工作状态代码
			    s ESDDesc=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),3) /// 人员工作状态名称
				s ESDActivity=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),4) ///是否有效
				s ESDStartDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),5) ///开始日期
				s ESDEndDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),6) //结束日期
			    s:ESDStartDate'="" ESDStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ESDStartDate) ///转日期格式
			    s:ESDEndDate'="" ESDEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ESDEndDate)	///转日期格式
				s ESDSeqNo=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),10) ///系统排序号
				s ESDPYCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),14) ///拼音码
				s ESDWBCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),15) ///五笔码
				s ESDMark=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),16) ///备注
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ESDDesc)
		    	if ($ZCONVERT(ESDCode,"U")[code)&(($ZCONVERT(ESDDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRow
		    	}
	    	}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,ESDCode,ESDDesc,ESDActivity,ESDStartDate,ESDEndDate,ESDSeqNo,ESDPYCode,ESDWBCode,ESDMark)
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
/// Table：Table：CT_BDP_CT.HOS_EmpStatusDict
/// input id code(人员工作状态代码) desc(人员工作状态名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSEmpStatusDict","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ESDCode:%String,ESDDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSEmpStatusDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{		
		s ID=id
	    s ESDCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),2) /// 人员工作状态代码
	    s ESDDesc=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),3) /// 人员工作状态名称
		s ESDActivity=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),4) ///是否有效
		s ESDStartDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),5) ///开始日期
		s ESDEndDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),6) //结束日期
	    d OutputRowCmb
	}
	else
	{
    	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSEmpStatusDictD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{			
			    s ESDCode=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),2) /// 人员工作状态代码
			    s ESDDesc=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),3) /// 人员工作状态名称
				s ESDActivity=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),4) ///是否有效
				continue:ESDActivity="N"
				s ESDStartDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),5) ///开始日期
				continue:(ESDStartDate'="")&&(ESDStartDate>+$h)
				s ESDEndDate=$lg($g(^CT.BDP.CT.HOSEmpStatusDictD(ID)),6) //结束日期
				continue:(ESDEndDate'="")&&(ESDEndDate<+$h)
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ESDDesc)
		    	if (($ZCONVERT(ESDDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,ESDCode,ESDDesc)
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
/// Other: w ##class(web.DHCBL.CT.HOSEmpStatusDict).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSEmpStatusDict).%New()
    s obj = ##class(CT.BDP.CT.HOSEmpStatusDict).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.ESDCode=obj.ESDCode /// 人员工作状态代码
    s eobj.ESDDesc=obj.ESDDesc /// 人员工作状态名称
    s eobj.ESDActivity=obj.ESDActivity  ///是否有效
    s eobj.ESDStartDate=obj.ESDStartDate  ///开始日期
    s eobj.ESDEndDate=obj.ESDEndDate  ///结束日期
    s:obj.ESDStartDate'="" eobj.ESDStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.ESDStartDate) ///开始日期(转格式)
    s:obj.ESDEndDate'="" eobj.ESDEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.ESDEndDate) ///结束日期(转格式) 
    s eobj.ESDSeqNo=obj.ESDSeqNo  ///系统排序号
    s eobj.ESDPYCode=obj.ESDPYCode  ///拼音码
    s eobj.ESDWBCode=obj.ESDWBCode  ///五笔码
    s eobj.ESDMark=obj.ESDMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-18
/// Description：重复校验
/// Table：Table：CT_BDP_CT.HOS_EmpStatusDict
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSEmpStatusDict).FormValidate("","001","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSEmpStatusDictI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSEmpStatusDictI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
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
/// debug：d ##class(web.DHCBL.CT.HOSEmpStatusDict).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSEmpStatusDict).%New()
	s eobj.ESDCode="001"
	s eobj.ESDDesc="在职"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-18
/// Description：保存人员工作状态代码
/// Table：Table：CT_BDP_CT.HOS_EmpStatusDict
/// Others：w ##class(web.DHCBL.CT.HOSEmpStatusDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSEmpStatusDict) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ESDStartDate'="" eobj.ESDStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ESDStartDate) ///转日期格式
    	s:eobj.ESDEndDate'="" eobj.ESDEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ESDEndDate)	///转日期格式
		s:eobj.ESDStartDate="" eobj.ESDStartDate=+$h
		s:eobj.ESDActivity="" eobj.ESDActivity="N"
		
		s eobj.ESDLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.ESDLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.ESDCreateUser="") s eobj.ESDCreateUser=USERID   ///系统创建人
			if (eobj.ESDLastUpdateUser="") s eobj.ESDLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.ESDCode,eobj.ESDDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSEmpStatusDict).%New()
			d obj.ESDCreateUserSetObjectId(eobj.ESDCreateUser)  ///系统创建人
			s obj.ESDCreateDate=+$H           ///系统创建日期
			s obj.ESDCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSEmpStatusDict).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSEmpStatusDict).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.ESDCode=obj.ESDCode /// 人员工作状态代码
			s bobj.ESDDesc=obj.ESDDesc ///人员工作状态名称
			s bobj.ESDActivity=obj.ESDActivity ///是否有效
					
			s bobj.ESDStartDate=obj.ESDStartDate ///开始日期
			s bobj.ESDEndDate=obj.ESDEndDate ///结束日期
			s bobj.ESDCreateDate=obj.ESDCreateDate ///系统创建日期
			s bobj.ESDCreateTime=obj.ESDCreateTime ///系统创建时间
			if $IsObject(obj.ESDCreateUser)
			{   
				s bobj.ESDCreateUser = obj.ESDCreateUser.%Id()   ///系统创建人
			}
			s bobj.ESDSeqNo=obj.ESDSeqNo ///系统排序号
			
			s bobj.ESDLastUpdateDate=obj.ESDLastUpdateDate ///系统最后更新日期
			s bobj.ESDLastUpdateTime=obj.ESDLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.ESDLastUpdateUser)
			{   
				s bobj.ESDLastUpdateUser = obj.ESDLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.ESDPYCode=obj.ESDPYCode ///拼音码
			s bobj.ESDWBCode=obj.ESDWBCode ///五笔码
			s bobj.ESDMark=obj.ESDMark ///备注
		}
		
		s obj.ESDCode=eobj.ESDCode ///人员工作状态代码
		s obj.ESDDesc=eobj.ESDDesc ///人员工作状态名称
		s obj.ESDActivity=eobj.ESDActivity		  ///是否有效
		s obj.ESDStartDate= eobj.ESDStartDate     ///开始日期
	    s obj.ESDEndDate= eobj.ESDEndDate 		 ///结束日期
		s obj.ESDSeqNo=eobj.ESDSeqNo ///系统排序号
		s obj.ESDLastUpdateDate=eobj.ESDLastUpdateDate ///系统最后更新日期
		s obj.ESDLastUpdateTime=eobj.ESDLastUpdateTime ///系统最后更新时间
		d obj.ESDLastUpdateUserSetObjectId(eobj.ESDLastUpdateUser)  ///系统最新更新人
		s:eobj.ESDPYCode="" eobj.ESDPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.ESDDesc,4) ///自动生成拼音码
		s obj.ESDPYCode=eobj.ESDPYCode ///拼音码
		s:eobj.ESDWBCode="" eobj.ESDWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ESDDesc,1) ///自动生成五笔码
		s obj.ESDWBCode=eobj.ESDWBCode ///五笔码
		s obj.ESDMark=eobj.ESDMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpStatusDict","CT.BDP.CT.HOSEmpStatusDict","人员工作状态代码",eobj.ID,eobj.ESDDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpStatusDict","CT.BDP.CT.HOSEmpStatusDict","人员工作状态代码",id,eobj.ESDDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员工作状态代码","web.DHCBL.CT.HOSEmpStatusDict","SaveEntity",eobj) 
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
/// Description：根据ID删除人员工作状态代码的内容
/// Table：CT_BDP_CT.HOS_EmpStatusDict
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSEmpStatusDict).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HOSEmpStatusDict).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		 
	s pobj = ##class(CT.BDP.CT.HOSEmpStatusDict).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSEmpStatusDict).%New()
	s eobj.ESDCode=pobj.ESDCode ///人员工作状态代码
	s eobj.ESDDesc=pobj.ESDDesc ///人员工作状态名称
	
	s eobj.ESDActivity=pobj.ESDActivity ///是否有效		
	s eobj.ESDStartDate=pobj.ESDStartDate ///开始日期
	s eobj.ESDEndDate=pobj.ESDEndDate ///结束日期
	
	s eobj.ESDCreateDate=pobj.ESDCreateDate ///系统创建日期
	s eobj.ESDCreateTime=pobj.ESDCreateTime ///系统创建时间
	if $IsObject(pobj.ESDCreateUser)
	{   
		s eobj.ESDCreateUser = pobj.ESDCreateUser.%Id()   ///系统创建人
	}
	s eobj.ESDSeqNo=pobj.ESDSeqNo ///系统排序号
	s eobj.ESDLastUpdateDate=pobj.ESDLastUpdateDate ///系统最后更新日期
	s eobj.ESDLastUpdateTime=pobj.ESDLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.ESDLastUpdateUser)
	{   
		s eobj.ESDLastUpdateUser = pobj.ESDLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.ESDPYCode=pobj.ESDPYCode ///拼音码
	s eobj.ESDWBCode=pobj.ESDWBCode ///五笔码
	s eobj.ESDMark=pobj.ESDMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSEmpStatusDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpStatusDict","CT.BDP.CT.HOSEmpStatusDict","人员工作状态代码",id,eobj.ESDDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员工作状态代码","web.DHCBL.CT.HOSEmpStatusDict","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}		
	q result
}

}

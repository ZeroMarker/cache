/// Function: 岗位类型
/// Table：CT_BDP_CT.HOS_PostType
/// CreateDate:2023-3-2
/// Creator:lujunwen
Class web.DHCBL.CT.HOSPostType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2023-2-2
/// Description：岗位类型
/// Table：CT_BDP_CT.HOS_PostType
/// input id code(岗位类型代码) desc(岗位类型名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostType","GetList","1","","")
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PTCode:%String,PTDesc:%String,PTActivity:%String,PTStartDate:%Date,PTEndDate:%Date,PTSeqNo:%Float,PTPYCode:%String,PTWBCode:%String,PTMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPostType).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PTCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),2) /// 岗位类型代码
	    s PTDesc=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),3) /// 岗位类型名称
		s PTActivity=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),4) ///是否有效
		s PTStartDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),5) ///开始日期
		s PTEndDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),6) //结束日期
	    s:PTStartDate'="" PTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PTStartDate) ///转日期格式
	    s:PTEndDate'="" PTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PTEndDate)	///转日期格式
		s PTSeqNo=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),10) ///系统排序号	
		s PTPYCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),14) ///拼音码
		s PTWBCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),15) ///五笔码
		s PTMark=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),16) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSPostTypeD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{					
			    s PTCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),2) /// 岗位类型代码
			    s PTDesc=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),3) /// 岗位类型名称
				s PTActivity=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),4) ///是否有效
				s PTStartDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),5) ///开始日期
				s PTEndDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),6) //结束日期
			    s:PTStartDate'="" PTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PTStartDate) ///转日期格式
			    s:PTEndDate'="" PTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PTEndDate)	///转日期格式
				s PTSeqNo=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),10) ///系统排序号
				s PTPYCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),14) ///拼音码
				s PTWBCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),15) ///五笔码
				s PTMark=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),16) ///备注
				s PINYIN=""
			    s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PTDesc)
				if ($ZCONVERT(PTCode,"U")[code)&(($ZCONVERT(PTDesc,"U")[desc)||(PINYIN[desc))
				{
			        d OutputRow
				} 
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PTCode,PTDesc,PTActivity,PTStartDate,PTEndDate,PTSeqNo,PTPYCode,PTWBCode,PTMark)
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
/// CreatDate:2023-2-2
/// Description:为combobox查询取数据
/// Table：Table：CT_BDP_CT.HOS_PostType
/// input id code(岗位类型代码) desc(岗位类型名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostType","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PTCode:%String,PTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
    s AuStr=##class(web.DHCBL.Authorize.HOSPostType).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PTCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),2) /// 岗位类型代码
	    s PTDesc=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),3) /// 岗位类型名称
		s PTActivity=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),4) ///是否有效
		s PTStartDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),5) ///开始日期
		s PTEndDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),6) //结束日期
	    d OutputRowCmb
	}
	else
	{
    	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSPostTypeD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{				
			    s PTCode=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),2) /// 岗位类型代码
			    s PTDesc=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),3) /// 岗位类型名称
				s PTActivity=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),4) ///是否有效
				continue:PTActivity="N"
				s PTStartDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),5) ///开始日期
				continue:(PTStartDate'="")&&(PTStartDate>+$h)
				s PTEndDate=$lg($g(^CT.BDP.CT.HOSPostTypeD(ID)),6) //结束日期			
				continue:(PTEndDate'="")&&(PTEndDate<+$h)	
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PTDesc)
		    	if (($ZCONVERT(PTDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PTCode,PTDesc)
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
/// CreatDate:  2023-2-2
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSPostType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPostType).%New()
    s obj = ##class(CT.BDP.CT.HOSPostType).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PTCode=obj.PTCode /// 岗位类型代码
    s eobj.PTDesc=obj.PTDesc /// 岗位类型名称
    s eobj.PTActivity=obj.PTActivity  ///是否有效
    s eobj.PTStartDate=obj.PTStartDate  ///开始日期
    s eobj.PTEndDate=obj.PTEndDate  ///结束日期
    s:obj.PTStartDate'="" eobj.PTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PTStartDate) ///开始日期(转格式)
    s:obj.PTEndDate'="" eobj.PTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PTEndDate) ///结束日期(转格式) 
    s eobj.PTSeqNo=obj.PTSeqNo  ///系统排序号
    s eobj.PTPYCode=obj.PTPYCode  ///拼音码
    s eobj.PTWBCode=obj.PTWBCode  ///五笔码
    s eobj.PTMark=obj.PTMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-2-2
/// Description：重复校验
/// Table：Table：CT_BDP_CT.HOS_PostType
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSPostType).FormValidate("","001","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSPostTypeI("IndexPTCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSPostTypeI("IndexPTDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}		
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年2月2日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSPostType).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSPostType).%New()
	s eobj.PTCode="002"
	s eobj.PTDesc="保存测试"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-2-2
/// Description：保存岗位类型
/// Table：Table：CT_BDP_CT.HOS_PostType
/// Others：w ##class(web.DHCBL.CT.HOSPostType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPostType) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PTStartDate'="" eobj.PTStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PTStartDate) ///转日期格式
    	s:eobj.PTEndDate'="" eobj.PTEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PTEndDate)	///转日期格式
		s:eobj.PTStartDate="" eobj.PTStartDate=+$h
		s:eobj.PTActivity="" eobj.PTActivity="N"
		
		s eobj.PTLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PTLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PTCreateUser="") s eobj.PTCreateUser=USERID   ///系统创建人
			if (eobj.PTLastUpdateUser="") s eobj.PTLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.PTCode,eobj.PTDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSPostType).%New()
			d obj.PTCreateUserSetObjectId(eobj.PTCreateUser)  ///系统创建人
			s obj.PTCreateDate=+$H           ///系统创建日期
			s obj.PTCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSPostType).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSPostType).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.PTCode=obj.PTCode /// 岗位类型代码
			s bobj.PTDesc=obj.PTDesc ///岗位类型名称
			s bobj.PTActivity=obj.PTActivity ///是否有效
					
			s bobj.PTStartDate=obj.PTStartDate ///开始日期
			s bobj.PTEndDate=obj.PTEndDate ///结束日期
			s bobj.PTCreateDate=obj.PTCreateDate ///系统创建日期
			s bobj.PTCreateTime=obj.PTCreateTime ///系统创建时间
			if $IsObject(obj.PTCreateUser)
			{   
				s bobj.PTCreateUser = obj.PTCreateUser.%Id()   ///系统创建人
			}
			s bobj.PTSeqNo=obj.PTSeqNo ///系统排序号
			
			s bobj.PTLastUpdateDate=obj.PTLastUpdateDate ///系统最后更新日期
			s bobj.PTLastUpdateTime=obj.PTLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PTLastUpdateUser)
			{   
				s bobj.PTLastUpdateUser = obj.PTLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PTPYCode=obj.PTPYCode ///拼音码
			s bobj.PTWBCode=obj.PTWBCode ///五笔码
			s bobj.PTMark=obj.PTMark ///备注
		}
		
		s obj.PTCode=eobj.PTCode ///岗位类型代码
		s obj.PTDesc=eobj.PTDesc ///岗位类型名称
		s obj.PTActivity=eobj.PTActivity		  ///是否有效
		s obj.PTStartDate= eobj.PTStartDate     ///开始日期
	    s obj.PTEndDate= eobj.PTEndDate 		 ///结束日期
		s obj.PTSeqNo=eobj.PTSeqNo ///系统排序号
		s obj.PTLastUpdateDate=eobj.PTLastUpdateDate ///系统最后更新日期
		s obj.PTLastUpdateTime=eobj.PTLastUpdateTime ///系统最后更新时间
		d obj.PTLastUpdateUserSetObjectId(eobj.PTLastUpdateUser)  ///系统最新更新人
		s:eobj.PTPYCode="" eobj.PTPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PTDesc,4) ///自动生成拼音码
		s obj.PTPYCode=eobj.PTPYCode ///拼音码
		s:eobj.PTWBCode="" eobj.PTWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PTDesc,1) ///自动生成五笔码
		s obj.PTWBCode=eobj.PTWBCode ///五笔码
		s obj.PTMark=eobj.PTMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostType","CT.BDP.CT.HOSPostType","岗位类型代码",eobj.ID,eobj.PTDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostType","CT.BDP.CT.HOSPostType","岗位类型代码",id,eobj.PTDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位类型代码","web.DHCBL.CT.HOSPostType","SaveEntity",eobj) 
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
/// CreatDate:2022-11-18
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^CT.BDP.CT.HOSPostDictI("IndexType",id)){
		s myInfo=myInfo_"岗位字典"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除岗位类型代码的内容
/// Table：CT_BDP_CT.HOS_PostType
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPostType).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSPostType).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){	
	s pobj = ##class(CT.BDP.CT.HOSPostType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSPostType).%New()
	s eobj.PTCode=pobj.PTCode ///岗位类型代码
	s eobj.PTDesc=pobj.PTDesc ///岗位类型名称
	
	s eobj.PTActivity=pobj.PTActivity ///是否有效		
	s eobj.PTStartDate=pobj.PTStartDate ///开始日期
	s eobj.PTEndDate=pobj.PTEndDate ///结束日期
	
	s eobj.PTCreateDate=pobj.PTCreateDate ///系统创建日期
	s eobj.PTCreateTime=pobj.PTCreateTime ///系统创建时间
	if $IsObject(pobj.PTCreateUser)
	{   
		s eobj.PTCreateUser = pobj.PTCreateUser.%Id()   ///系统创建人
	}
	s eobj.PTSeqNo=pobj.PTSeqNo ///系统排序号
	s eobj.PTLastUpdateDate=pobj.PTLastUpdateDate ///系统最后更新日期
	s eobj.PTLastUpdateTime=pobj.PTLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PTLastUpdateUser)
	{   
		s eobj.PTLastUpdateUser = pobj.PTLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PTPYCode=pobj.PTPYCode ///拼音码
	s eobj.PTWBCode=pobj.PTWBCode ///五笔码
	s eobj.PTMark=pobj.PTMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSPostType).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostType","CT.BDP.CT.HOSPostType","岗位类型代码",id,eobj.PTDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位类型代码","web.DHCBL.CT.HOSPostType","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	q result
}

}

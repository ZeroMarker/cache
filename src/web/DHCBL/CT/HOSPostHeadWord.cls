Class web.DHCBL.CT.HOSPostHeadWord Extends %RegisteredObject
{

/// Creator:lujunwen
/// CreateDate:2023-2-2
/// Description：岗位中心词
/// Table：CT_BDP_CT.HOS_PostHeadWord
/// input id code(岗位中心词代码) desc(岗位中心词名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostHeadWord","GetList","1","","")
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PHWCode:%String,PHWDesc:%String,PHWDomainCode:%String,PHWActivity:%String,PHWStartDate:%Date,PHWEndDate:%Date,PHWSeqNo:%Float,PHWPYCode:%String,PHWWBCode:%String,PHWMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPostHeadWord).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s DomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s DomainAuFlag=0	
	if (DomainAuStr="")||(DomainAuStr["limited:0") s DomainAuFlag=1	 	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PHWCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),2) /// 岗位中心词代码
	    s PHWDesc=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),3) /// 岗位中心词名称
	    s PHWDomainCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),4) ///业务域指针
	    s:PHWDomainCode'="" PHWDomainCode=$lg($g(^CT.BDP.CT.HOSBusiDomainD(PHWDomainCode)),3) ///业务域描述
		s PHWActivity=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),5) ///是否有效
		s PHWStartDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),6) ///开始日期
		s PHWEndDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),7) //结束日期
	    s:PHWStartDate'="" PHWStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PHWStartDate) ///转日期格式
	    s:PHWEndDate'="" PHWEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PHWEndDate)	///转日期格式
		s PHWSeqNo=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),11) ///系统排序号	
		s PHWPYCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),15) ///拼音码
		s PHWWBCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),16) ///五笔码
		s PHWMark=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),17) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSPostHeadWordD(ID)) q:ID=""  ///RowID
			s strRowId = "{ID:"_ID_"}"
		    s PHWDomainCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),4) ///业务域
		    s DomainstrRowId = "{ID:"_PHWDomainCode_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((DomainAuStr[DomainstrRowId)||(DomainAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{	    		
			    s PHWCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),2) /// 岗位中心词代码
			    s PHWDesc=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),3) /// 岗位中心词名称
			    s:PHWDomainCode'="" PHWDomainCode=$lg($g(^CT.BDP.CT.HOSBusiDomainD(PHWDomainCode)),3) ///业务域描述
				s PHWActivity=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),5) ///是否有效
				s PHWStartDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),6) ///开始日期
				s PHWEndDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),7) //结束日期
			    s:PHWStartDate'="" PHWStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PHWStartDate) ///转日期格式
			    s:PHWEndDate'="" PHWEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PHWEndDate)	///转日期格式
				s PHWSeqNo=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),11) ///系统排序号	
				s PHWPYCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),15) ///拼音码
				s PHWWBCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),16) ///五笔码
				s PHWMark=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),17) ///备注
				s PINYIN=""
			    s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHWDesc)
				if ($ZCONVERT(PHWCode,"U")[code)&(($ZCONVERT(PHWDesc,"U")[desc)||(PINYIN[desc))
				{
			        d OutputRow
				} 
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PHWCode,PHWDesc,PHWDomainCode,PHWActivity,PHWStartDate,PHWEndDate,PHWSeqNo,PHWPYCode,PHWWBCode,PHWMark)
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
/// Table：Table：CT_BDP_CT.HOS_PostHeadWord
/// input id code(岗位中心词代码) desc(岗位中心词名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostHeadWord","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PHWCode:%String,PHWDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPostHeadWord).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s DomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s DomainAuFlag=0	
	if (DomainAuStr="")||(DomainAuStr["limited:0") s DomainAuFlag=1	 	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PHWCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),2) /// 岗位中心词代码
	    s PHWDesc=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),3) /// 岗位中心词名称
		s PHWActivity=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),5) ///是否有效
		s PHWStartDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),6) ///开始日期
		s PHWEndDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),7) //结束日期
	    d OutputRowCmb
	}
	else
	{
    	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSPostHeadWordD(ID)) q:ID=""  ///RowID
			s strRowId = "{ID:"_ID_"}"
			s FHWDomainCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),4) ///业务域
		    s DomainstrRowId = "{ID:"_FHWDomainCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuStr[DomainstrRowId)||(DomainAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{							
			    s PHWCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),2) /// 岗位中心词代码
			    s PHWDesc=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),3) /// 岗位中心词名称
				s PHWActivity=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),5) ///是否有效
				continue:PHWActivity="N"
				s PHWStartDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),6) ///开始日期
				
				continue:(PHWStartDate'="")&&(PHWStartDate>+$h)
				s PHWEndDate=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(ID)),7) //结束日期			
				continue:(PHWEndDate'="")&&(PHWEndDate<+$h)	
		    	s PINYIN=""
		    	
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHWDesc)
		    	if ($ZCONVERT(PHWCode,"U")[code)&(($ZCONVERT(PHWDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PHWCode,PHWDesc)
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
/// Other: w ##class(web.DHCBL.CT.HOSPostHeadWord).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPostHeadWord).%New()
    s obj = ##class(CT.BDP.CT.HOSPostHeadWord).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PHWCode=obj.PHWCode /// 岗位中心词代码
    s eobj.PHWDesc=obj.PHWDesc /// 岗位中心词名称
	if $IsObject(obj.PHWDomainCode)
	{
		s eobj.PHWDomainCode = obj.PHWDomainCode.%Id() ///业务域
	}    
    s eobj.PHWActivity=obj.PHWActivity  ///是否有效
    s eobj.PHWStartDate=obj.PHWStartDate  ///开始日期
    s eobj.PHWEndDate=obj.PHWEndDate  ///结束日期
    s:obj.PHWStartDate'="" eobj.PHWStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PHWStartDate) ///开始日期(转格式)
    s:obj.PHWEndDate'="" eobj.PHWEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PHWEndDate) ///结束日期(转格式) 
    s eobj.PHWSeqNo=obj.PHWSeqNo  ///系统排序号
    s eobj.PHWPYCode=obj.PHWPYCode  ///拼音码
    s eobj.PHWWBCode=obj.PHWWBCode  ///五笔码
    s eobj.PHWMark=obj.PHWMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-2-2
/// Description：重复校验
/// Table：Table：CT_BDP_CT.HOS_PostHeadWord
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSPostHeadWord).FormValidate("","001","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, domin As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSPostHeadWordI("IndexPHWCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	/*
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSPostHeadWordI("IndexPHWDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}		
	}
	*/
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年2月2日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSPostHeadWord).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSPostHeadWord).%New()
	s eobj.PHWCode="002"
	s eobj.PHWDesc="保存测试"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-2-2
/// Description：保存岗位中心词
/// Table：Table：CT_BDP_CT.HOS_PostHeadWord
/// Others：w ##class(web.DHCBL.CT.HOSPostHeadWord).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPostHeadWord) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PHWStartDate'="" eobj.PHWStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHWStartDate) ///转日期格式
    	s:eobj.PHWEndDate'="" eobj.PHWEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHWEndDate)	///转日期格式
		s:eobj.PHWStartDate="" eobj.PHWStartDate=+$h
		s:eobj.PHWActivity="" eobj.PHWActivity="N"
		
		s eobj.PHWLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PHWLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PHWCreateUser="") s eobj.PHWCreateUser=USERID   ///系统创建人
			if (eobj.PHWLastUpdateUser="") s eobj.PHWLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.PHWCode,eobj.PHWDesc,eobj.PHWDomainCode)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSPostHeadWord).%New()
			d obj.PHWCreateUserSetObjectId(eobj.PHWCreateUser)  ///系统创建人
			s obj.PHWCreateDate=+$H           ///系统创建日期
			s obj.PHWCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSPostHeadWord).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSPostHeadWord).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.PHWCode=obj.PHWCode /// 岗位中心词代码
			s bobj.PHWDesc=obj.PHWDesc ///岗位中心词名称 
			if $IsObject(obj.PHWDomainCode){
			s bobj.PHWDomainCode = obj.PHWDomainCode.%Id() ///业务域
			}			
			s bobj.PHWActivity=obj.PHWActivity ///是否有效
					
			s bobj.PHWStartDate=obj.PHWStartDate ///开始日期
			s bobj.PHWEndDate=obj.PHWEndDate ///结束日期
			s bobj.PHWCreateDate=obj.PHWCreateDate ///系统创建日期
			s bobj.PHWCreateTime=obj.PHWCreateTime ///系统创建时间
			if $IsObject(obj.PHWCreateUser)
			{   
				s bobj.PHWCreateUser = obj.PHWCreateUser.%Id()   ///系统创建人
			}
			s bobj.PHWSeqNo=obj.PHWSeqNo ///系统排序号
			
			s bobj.PHWLastUpdateDate=obj.PHWLastUpdateDate ///系统最后更新日期
			s bobj.PHWLastUpdateTime=obj.PHWLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PHWLastUpdateUser)
			{   
				s bobj.PHWLastUpdateUser = obj.PHWLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PHWPYCode=obj.PHWPYCode ///拼音码
			s bobj.PHWWBCode=obj.PHWWBCode ///五笔码
			s bobj.PHWMark=obj.PHWMark ///备注
		}
		
		s obj.PHWCode=eobj.PHWCode ///岗位中心词代码
		s obj.PHWDesc=eobj.PHWDesc ///岗位中心词名称
		d obj.PHWDomainCodeSetObjectId(eobj.PHWDomainCode) ///业务域
		s obj.PHWActivity=eobj.PHWActivity		  ///是否有效
		s obj.PHWStartDate= eobj.PHWStartDate     ///开始日期
	    s obj.PHWEndDate= eobj.PHWEndDate 		 ///结束日期
		s obj.PHWSeqNo=eobj.PHWSeqNo ///系统排序号
		s obj.PHWLastUpdateDate=eobj.PHWLastUpdateDate ///系统最后更新日期
		s obj.PHWLastUpdateTime=eobj.PHWLastUpdateTime ///系统最后更新时间
		d obj.PHWLastUpdateUserSetObjectId(eobj.PHWLastUpdateUser)  ///系统最新更新人
		s:eobj.PHWPYCode="" eobj.PHWPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PHWDesc,4) ///自动生成拼音码
		s obj.PHWPYCode=eobj.PHWPYCode ///拼音码
		s:eobj.PHWWBCode="" eobj.PHWWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PHWDesc,1) ///自动生成五笔码
		s obj.PHWWBCode=eobj.PHWWBCode ///五笔码
		s obj.PHWMark=eobj.PHWMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostHeadWord","CT.BDP.CT.HOSPostHeadWord","岗位中心词代码",eobj.ID,eobj.PHWDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostHeadWord","CT.BDP.CT.HOSPostHeadWord","岗位中心词代码",id,eobj.PHWDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位中心词代码","web.DHCBL.CT.HOSPostHeadWord","SaveEntity",eobj) 
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
	if $d(^CT.BDP.CT.HOSPostDictI("IndexPHWCode",id)){
		s myInfo=myInfo_"岗位字典"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除岗位中心词代码的内容
/// Table：CT_BDP_CT.HOS_PostHeadWord
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPostHeadWord).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSPostHeadWord).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){	
	s pobj = ##class(CT.BDP.CT.HOSPostHeadWord).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSPostHeadWord).%New()
	s eobj.PHWCode=pobj.PHWCode ///岗位中心词代码
	s eobj.PHWDesc=pobj.PHWDesc ///岗位中心词名称
	if $IsObject(pobj.PHWDomainCode){
	s eobj.PHWDomainCode = pobj.PHWDomainCode.%Id() ///业务域
	}	
	s eobj.PHWActivity=pobj.PHWActivity ///是否有效		
	s eobj.PHWStartDate=pobj.PHWStartDate ///开始日期
	s eobj.PHWEndDate=pobj.PHWEndDate ///结束日期
	
	s eobj.PHWCreateDate=pobj.PHWCreateDate ///系统创建日期
	s eobj.PHWCreateTime=pobj.PHWCreateTime ///系统创建时间
	if $IsObject(pobj.PHWCreateUser)
	{   
		s eobj.PHWCreateUser = pobj.PHWCreateUser.%Id()   ///系统创建人
	}
	s eobj.PHWSeqNo=pobj.PHWSeqNo ///系统排序号
	s eobj.PHWLastUpdateDate=pobj.PHWLastUpdateDate ///系统最后更新日期
	s eobj.PHWLastUpdateTime=pobj.PHWLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PHWLastUpdateUser)
	{   
		s eobj.PHWLastUpdateUser = pobj.PHWLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PHWPYCode=pobj.PHWPYCode ///拼音码
	s eobj.PHWWBCode=pobj.PHWWBCode ///五笔码
	s eobj.PHWMark=pobj.PHWMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSPostHeadWord).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostHeadWord","CT.BDP.CT.HOSPostHeadWord","岗位中心词代码",id,eobj.PHWDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位中心词代码","web.DHCBL.CT.HOSPostHeadWord","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	q result
}

}

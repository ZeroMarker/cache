Class web.DHCBL.CT.HOSFlowHeadWord Extends %RegisteredObject
{

/// Creator:lujunwen
/// CreateDate:2023-2-2
/// Description：流程中心词
/// Table：CT_BDP_CT.HOS_FlowHeadWord
/// input id code(流程中心词代码) desc(流程中心词名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSFlowHeadWord","GetList","1","","")
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,FHWCode:%String,FHWDesc:%String,FHWDomainCode:%String,FHWActivity:%String,FHWStartDate:%Date,FHWEndDate:%Date,FHWSeqNo:%Float,FHWPYCode:%String,FHWWBCode:%String,FHWMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1 
    s AuStr=##class(web.DHCBL.Authorize.HOSFlowHeadWord).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s DomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s DomainAuFlag=0	
	if (DomainAuStr="")||(DomainAuStr["limited:0") s DomainAuFlag=1	 
	
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s FHWCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),2) /// 流程中心词代码
	    s FHWDesc=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),3) /// 流程中心词名称
	    s FHWDomainCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),4) ///业务域
	    s:FHWDomainCode'="" FHWDomainCode=$lg($g(^CT.BDP.CT.HOSBusiDomainD(FHWDomainCode)),3) ///业务域描述
		s FHWActivity=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),5) ///是否有效
		s FHWStartDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),6) ///开始日期
		s FHWEndDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),7) //结束日期
	    s:FHWStartDate'="" FHWStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FHWStartDate) ///转日期格式
	    s:FHWEndDate'="" FHWEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FHWEndDate)	///转日期格式
		s FHWSeqNo=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),11) ///系统排序号	
		s FHWPYCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),15) ///拼音码
		s FHWWBCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),16) ///五笔码
		s FHWMark=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),17) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSFlowHeadWordD(ID)) q:ID=""  ///RowID
		    s strRowId = "{ID:"_ID_"}"
		    s FHWDomainCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),4) ///业务域
		    s DomainstrRowId = "{ID:"_FHWDomainCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((DomainAuStr[DomainstrRowId)||(DomainAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{	
				s FHWCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),2) /// 流程中心词代码
			    s FHWDesc=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),3) /// 流程中心词名称    
			    s:FHWDomainCode'="" FHWDomainCode=$lg($g(^CT.BDP.CT.HOSBusiDomainD(FHWDomainCode)),3) ///业务域描述
				s FHWActivity=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),5) ///是否有效
				s FHWStartDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),6) ///开始日期
				s FHWEndDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),7) //结束日期
			    s:FHWStartDate'="" FHWStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FHWStartDate) ///转日期格式
			    s:FHWEndDate'="" FHWEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FHWEndDate)	///转日期格式
				s FHWSeqNo=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),11) ///系统排序号	
				s FHWPYCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),15) ///拼音码
				s FHWWBCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),16) ///五笔码
				s FHWMark=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),17) ///备注
				s PINYIN=""
			    s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(FHWDesc)
				if ($ZCONVERT(FHWCode,"U")[code)&(($ZCONVERT(FHWDesc,"U")[desc)||(PINYIN[desc))
				{
			        d OutputRow
				} 
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,FHWCode,FHWDesc,FHWDomainCode,FHWActivity,FHWStartDate,FHWEndDate,FHWSeqNo,FHWPYCode,FHWWBCode,FHWMark)
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
/// Table：Table：CT_BDP_CT.HOS_FlowHeadWord
/// input id code(流程中心词代码) desc(流程中心词名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSFlowHeadWord","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,FHWCode:%String,FHWDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSFlowHeadWord).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s DomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s DomainAuFlag=0	
	if (DomainAuStr="")||(DomainAuStr["limited:0") s DomainAuFlag=1	 	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s FHWCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),2) /// 流程中心词代码
	    s FHWDesc=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),3) /// 流程中心词名称
		s FHWActivity=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),5) ///是否有效
		s FHWStartDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),6) ///开始日期
		s FHWEndDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),7) //结束日期
	    d OutputRowCmb
	}
	else
	{
    	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSFlowHeadWordD(ID)) q:ID=""  ///RowID
		    s strRowId = "{ID:"_ID_"}"
		    s FHWDomainCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),4) ///业务域
		    s DomainstrRowId = "{ID:"_FHWDomainCode_"}"	
			i ((AuStr[strRowId)||(AuFlag=1))&&((DomainAuStr[DomainstrRowId)||(DomainAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{		    		
			    s FHWCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),2) /// 流程中心词代码
			    s FHWDesc=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),3) /// 流程中心词名称
				s FHWActivity=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),5) ///是否有效
				continue:FHWActivity="N"
				s FHWStartDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),6) ///开始日期
				continue:(FHWStartDate'="")&&(FHWStartDate>+$h)
				s FHWEndDate=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(ID)),7) //结束日期			
				continue:(FHWEndDate'="")&&(FHWEndDate<+$h)	
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(FHWDesc)
		    	if ($ZCONVERT(FHWCode,"U")[code)&(($ZCONVERT(FHWDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,FHWCode,FHWDesc)
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
/// Other: w ##class(web.DHCBL.CT.HOSFlowHeadWord).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSFlowHeadWord).%New()
    s obj = ##class(CT.BDP.CT.HOSFlowHeadWord).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.FHWCode=obj.FHWCode /// 流程中心词代码
    s eobj.FHWDesc=obj.FHWDesc /// 流程中心词名称
	if $IsObject(obj.FHWDomainCode)
	{
		s eobj.FHWDomainCode = obj.FHWDomainCode.%Id() ///业务域
	}    
    s eobj.FHWActivity=obj.FHWActivity  ///是否有效
    s eobj.FHWStartDate=obj.FHWStartDate  ///开始日期
    s eobj.FHWEndDate=obj.FHWEndDate  ///结束日期
    s:obj.FHWStartDate'="" eobj.FHWStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.FHWStartDate) ///开始日期(转格式)
    s:obj.FHWEndDate'="" eobj.FHWEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.FHWEndDate) ///结束日期(转格式) 
    s eobj.FHWSeqNo=obj.FHWSeqNo  ///系统排序号
    s eobj.FHWPYCode=obj.FHWPYCode  ///拼音码
    s eobj.FHWWBCode=obj.FHWWBCode  ///五笔码
    s eobj.FHWMark=obj.FHWMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-2-2
/// Description：重复校验
/// Table：Table：CT_BDP_CT.HOS_FlowHeadWord
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSFlowHeadWord).FormValidate("","001","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, domin As %String) As %String
{
	s flag=0
	//s:domin="" domin="-100000000000000"
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSFlowHeadWordI("IndexFHWCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	/*
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSFlowHeadWordI("IndexFHWDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}		
	}
	*/
	//b:code="dts0814" ;2
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年2月2日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSFlowHeadWord).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSFlowHeadWord).%New()
	s eobj.FHWCode="002"
	s eobj.FHWDesc="保存测试"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-2-2
/// Description：保存流程中心词
/// Table：Table：CT_BDP_CT.HOS_FlowHeadWord
/// Others：w ##class(web.DHCBL.CT.HOSFlowHeadWord).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSFlowHeadWord) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.FHWStartDate'="" eobj.FHWStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.FHWStartDate) ///转日期格式
    	s:eobj.FHWEndDate'="" eobj.FHWEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.FHWEndDate)	///转日期格式
		s:eobj.FHWStartDate="" eobj.FHWStartDate=+$h
		s:eobj.FHWActivity="" eobj.FHWActivity="N"
		
		s eobj.FHWLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.FHWLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.FHWCreateUser="") s eobj.FHWCreateUser=USERID   ///系统创建人
			if (eobj.FHWLastUpdateUser="") s eobj.FHWLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.FHWCode,eobj.FHWDesc,eobj.FHWDomainCode)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSFlowHeadWord).%New()
			d obj.FHWCreateUserSetObjectId(eobj.FHWCreateUser)  ///系统创建人
			s obj.FHWCreateDate=+$H           ///系统创建日期
			s obj.FHWCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSFlowHeadWord).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSFlowHeadWord).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.FHWCode=obj.FHWCode /// 流程中心词代码
			s bobj.FHWDesc=obj.FHWDesc ///流程中心词名称
			if $IsObject(obj.FHWDomainCode){
			s bobj.FHWDomainCode = obj.FHWDomainCode.%Id() ///业务域
			}				
			s bobj.FHWActivity=obj.FHWActivity ///是否有效
					
			s bobj.FHWStartDate=obj.FHWStartDate ///开始日期
			s bobj.FHWEndDate=obj.FHWEndDate ///结束日期
			s bobj.FHWCreateDate=obj.FHWCreateDate ///系统创建日期
			s bobj.FHWCreateTime=obj.FHWCreateTime ///系统创建时间
			if $IsObject(obj.FHWCreateUser)
			{   
				s bobj.FHWCreateUser = obj.FHWCreateUser.%Id()   ///系统创建人
			}
			s bobj.FHWSeqNo=obj.FHWSeqNo ///系统排序号
			
			s bobj.FHWLastUpdateDate=obj.FHWLastUpdateDate ///系统最后更新日期
			s bobj.FHWLastUpdateTime=obj.FHWLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.FHWLastUpdateUser)
			{   
				s bobj.FHWLastUpdateUser = obj.FHWLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.FHWPYCode=obj.FHWPYCode ///拼音码
			s bobj.FHWWBCode=obj.FHWWBCode ///五笔码
			s bobj.FHWMark=obj.FHWMark ///备注
		}
		
		s obj.FHWCode=eobj.FHWCode ///流程中心词代码
		s obj.FHWDesc=eobj.FHWDesc ///流程中心词名称
		d obj.FHWDomainCodeSetObjectId(eobj.FHWDomainCode) ///业务域		
		s obj.FHWActivity=eobj.FHWActivity		  ///是否有效
		s obj.FHWStartDate= eobj.FHWStartDate     ///开始日期
	    s obj.FHWEndDate= eobj.FHWEndDate 		 ///结束日期
		s obj.FHWSeqNo=eobj.FHWSeqNo ///系统排序号
		s obj.FHWLastUpdateDate=eobj.FHWLastUpdateDate ///系统最后更新日期
		s obj.FHWLastUpdateTime=eobj.FHWLastUpdateTime ///系统最后更新时间
		d obj.FHWLastUpdateUserSetObjectId(eobj.FHWLastUpdateUser)  ///系统最新更新人
		s:eobj.FHWPYCode="" eobj.FHWPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.FHWDesc,4) ///自动生成拼音码
		s obj.FHWPYCode=eobj.FHWPYCode ///拼音码
		s:eobj.FHWWBCode="" eobj.FHWWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.FHWDesc,1) ///自动生成五笔码
		s obj.FHWWBCode=eobj.FHWWBCode ///五笔码
		s obj.FHWMark=eobj.FHWMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_FlowHeadWord","CT.BDP.CT.HOSFlowHeadWord","流程中心词代码",eobj.ID,eobj.FHWDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_FlowHeadWord","CT.BDP.CT.HOSFlowHeadWord","流程中心词代码",id,eobj.FHWDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("流程中心词代码","web.DHCBL.CT.HOSFlowHeadWord","SaveEntity",eobj) 
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
	if $d(^CT.BDP.CT.HOSPostDictI("IndexFHWCode",id)){
		s myInfo=myInfo_"岗位字典"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除流程中心词代码的内容
/// Table：CT_BDP_CT.HOS_FlowHeadWord
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSFlowHeadWord).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSFlowHeadWord).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){	
	s pobj = ##class(CT.BDP.CT.HOSFlowHeadWord).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSFlowHeadWord).%New()
	s eobj.FHWCode=pobj.FHWCode ///流程中心词代码
	s eobj.FHWDesc=pobj.FHWDesc ///流程中心词名称
	if $IsObject(pobj.FHWDomainCode){
	s eobj.FHWDomainCode = pobj.FHWDomainCode.%Id() ///业务域
	}		
	s eobj.FHWActivity=pobj.FHWActivity ///是否有效		
	s eobj.FHWStartDate=pobj.FHWStartDate ///开始日期
	s eobj.FHWEndDate=pobj.FHWEndDate ///结束日期
	
	s eobj.FHWCreateDate=pobj.FHWCreateDate ///系统创建日期
	s eobj.FHWCreateTime=pobj.FHWCreateTime ///系统创建时间
	if $IsObject(pobj.FHWCreateUser)
	{   
		s eobj.FHWCreateUser = pobj.FHWCreateUser.%Id()   ///系统创建人
	}
	s eobj.FHWSeqNo=pobj.FHWSeqNo ///系统排序号
	s eobj.FHWLastUpdateDate=pobj.FHWLastUpdateDate ///系统最后更新日期
	s eobj.FHWLastUpdateTime=pobj.FHWLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.FHWLastUpdateUser)
	{   
		s eobj.FHWLastUpdateUser = pobj.FHWLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.FHWPYCode=pobj.FHWPYCode ///拼音码
	s eobj.FHWWBCode=pobj.FHWWBCode ///五笔码
	s eobj.FHWMark=pobj.FHWMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSFlowHeadWord).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_FlowHeadWord","CT.BDP.CT.HOSFlowHeadWord","流程中心词代码",id,eobj.FHWDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("流程中心词代码","web.DHCBL.CT.HOSFlowHeadWord","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	q result
}

}

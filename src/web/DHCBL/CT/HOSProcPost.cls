/// Function:流程岗位
/// Table：CT_BDP_CT.HOS_ProcPost
/// CreateDate:2023-2-7
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProcPost Extends %RegisteredObject
{

/// Creator:lujunwen
/// CreateDate:2023-2-7
/// Description：流程岗位查询
/// Table：CT_BDP_CT.HOS_ProcPost
/// input id code(流程岗位代码) desc(流程岗位名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProcPost","GetList","","","") 	
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PPOSTCode:%String,PPOSTDesc:%String,PPOSTBUCode:%String,PPOSTPOSTCCode:%String,PPOSTActivity:%String,PPOSTStartDate:%Date,PPOSTEndDate:%Date,PPOSTSeqNo:%Float,PPOSTPYCode:%String,PPOSTWBCode:%String,PPOSTMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSProcPost).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1

	
	s CTlocAuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
	s CTlocAuFlag=0	
	if (CTlocAuStr="")||(CTlocAuStr["limited:0") s CTlocAuFlag=1
	
	s ProcPostAuStr=##class(web.DHCBL.Authorize.HOSPostDict).DHCGetDataByDefaultSession()
	s ProcPostAuFlag=0	
	if (ProcPostAuStr="")||(ProcPostAuStr["limited:0") s ProcPostAuFlag=1
		  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PPOSTCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),2) /// 流程岗位代码
	    s PPOSTDesc=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),3) /// 流程岗位名称
	    s PPOSTBUCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),4) /// 业务单元代码指针
	    s:PPOSTBUCode'="" PPOSTBUCode=$p($g(^CTLOC(PPOSTBUCode)),"^",2) ///业务单元代码
	        
	    s PPOSTPOSTCCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),5) /// 岗位字典代码指针
	    s:PPOSTPOSTCCode'="" PPOSTPOSTCCode=$LISTGET($G(^CT.BDP.CT.HOSPostDictD(PPOSTPOSTCCode)),3) ///岗位字典代码	    
		s PPOSTActivity=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),6) ///是否有效
		s PPOSTStartDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),7) ///开始日期
		s PPOSTEndDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),8) //结束日期
	    s:PPOSTStartDate'="" PPOSTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPOSTStartDate) ///转日期格式
	    s:PPOSTEndDate'="" PPOSTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPOSTEndDate)	///转日期格式
		s PPOSTSeqNo=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),12) ///系统排序号	
		s PPOSTPYCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),16) ///拼音码
		s PPOSTWBCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),17) ///五笔码
		s PPOSTMark=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),18) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProcPostD(ID)) q:ID=""  ///RowID
			
            s strRowId = "{ID:"_ID_"}"
            s PPOSTBUCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),4) /// 业务单元代码指针
		    s PPOSTPOSTCCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),5) /// 岗位字典代码指针
		    
            s CTlocstrRowId = "{ID:"_PPOSTBUCode_"}"
            s ProcPoststrRowId = "{ID:"_PPOSTPOSTCCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((CTlocAuStr[CTlocstrRowId)||(CTlocAuFlag=1))&&((ProcPostAuStr[ProcPoststrRowId)||(ProcPostAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{				
			    s PPOSTCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),2) /// 流程岗位代码
			    s PPOSTDesc=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),3) /// 流程岗位名称
			    
			    s:PPOSTBUCode'="" PPOSTBUCode=$p($g(^CTLOC(PPOSTBUCode)),"^",2) ///业务单元代码	    

			    s:PPOSTPOSTCCode'="" PPOSTPOSTCCode=$LISTGET($G(^CT.BDP.CT.HOSPostDictD(PPOSTPOSTCCode)),3) ///岗位字典代码	    
				s PPOSTActivity=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),6) ///是否有效
				s PPOSTStartDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),7) ///开始日期
				s PPOSTEndDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),8) //结束日期
			    s:PPOSTStartDate'="" PPOSTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPOSTStartDate) ///转日期格式
			    s:PPOSTEndDate'="" PPOSTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPOSTEndDate)	///转日期格式
				s PPOSTSeqNo=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),12) ///系统排序号	
				s PPOSTPYCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),16) ///拼音码
				s PPOSTWBCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),17) ///五笔码
				s PPOSTMark=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),18) ///备注
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PPOSTDesc)
		    	if ($ZCONVERT(PPOSTCode,"U")[code)&(($ZCONVERT(PPOSTDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRow
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PPOSTCode,PPOSTDesc,PPOSTBUCode,PPOSTPOSTCCode,PPOSTActivity,PPOSTStartDate,PPOSTEndDate,PPOSTSeqNo,PPOSTPYCode,PPOSTWBCode,PPOSTMark)
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
/// CreatDate:2023-2-6
/// Description:为combobox查询取数据
/// Table：CT_BDP_CT.HOS_ProcPost
/// input id code(流程岗位代码) desc(流程岗位名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProcPost","GetDataForCmb1","","","")	
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PPOSTCode:%String,PPOSTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSProcPost).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1

	
	s CTlocAuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
	s CTlocAuFlag=0	
	if (CTlocAuStr="")||(CTlocAuStr["limited:0") s CTlocAuFlag=1
	
	s ProcPostAuStr=##class(web.DHCBL.Authorize.HOSPostDict).DHCGetDataByDefaultSession()
	s ProcPostAuFlag=0	
	if (ProcPostAuStr="")||(ProcPostAuStr["limited:0") s ProcPostAuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PPOSTCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),2) /// 流程岗位代码
	    s PPOSTDesc=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),3) /// 流程岗位名称
		s PPOSTActivity=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),6) ///是否有效
		s PPOSTStartDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),7) ///开始日期
		s PPOSTEndDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),8) //结束日期
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProcPostD(ID)) q:ID=""  ///RowID				
            s strRowId = "{ID:"_ID_"}"
            s PPOSTBUCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),4) /// 业务单元代码指针
		    s PPOSTPOSTCCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),5) /// 岗位字典代码指针
            s CTlocstrRowId = "{ID:"_PPOSTBUCode_"}"
            s ProcPoststrRowId = "{ID:"_PPOSTPOSTCCode_"}"  			
			i ((AuStr[strRowId)||(AuFlag=1))&&((CTlocAuStr[CTlocstrRowId)||(CTlocAuFlag=1))&&((ProcPostAuStr[ProcPoststrRowId)||(ProcPostAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{							
			    s PPOSTCode=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),2) /// 流程岗位代码
			    s PPOSTDesc=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),3) /// 流程岗位名称
				s PPOSTActivity=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),6) ///是否有效
				continue:PPOSTActivity="N"
				s PPOSTStartDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),7) ///开始日期
				continue:(PPOSTStartDate'="")&&(PPOSTStartDate>+$h)
				s PPOSTEndDate=$lg($g(^CT.BDP.CT.HOSProcPostD(ID)),8) //结束日期
				continue:(PPOSTEndDate'="")&&(PPOSTEndDate<+$h)		
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PPOSTDesc)
		    	if ($ZCONVERT(PPOSTCode,"U")[code)&(($ZCONVERT(PPOSTDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PPOSTCode,PPOSTDesc)
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

/// Creator:鲁俊文
/// CreatDate:  2023-2-6
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSProcPost).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSProcPost).%New()
    s obj = ##class(CT.BDP.CT.HOSProcPost).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PPOSTCode=obj.PPOSTCode /// 流程岗位代码
    s eobj.PPOSTDesc=obj.PPOSTDesc /// 流程岗位名称
	if $IsObject(obj.PPOSTBUCode)
	{
		s eobj.PPOSTBUCode = obj.PPOSTBUCode.%Id()   //业务单元代码
	}
	if $IsObject(obj.PPOSTPOSTCCode)
	{
		s eobj.PPOSTPOSTCCode = obj.PPOSTPOSTCCode.%Id() //岗位字典代码
	}	
    s eobj.PPOSTActivity=obj.PPOSTActivity  ///是否有效
    s eobj.PPOSTStartDate=obj.PPOSTStartDate  ///开始日期
    s eobj.PPOSTEndDate=obj.PPOSTEndDate  ///结束日期
    s:obj.PPOSTStartDate'="" eobj.PPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PPOSTStartDate) ///开始日期(转格式)
    s:obj.PPOSTEndDate'="" eobj.PPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PPOSTEndDate) ///结束日期(转格式) 
    s eobj.PPOSTPYCode=obj.PPOSTPYCode  ///拼音码
    s eobj.PPOSTWBCode=obj.PPOSTWBCode  ///五笔码
    s eobj.PPOSTMark=obj.PPOSTMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-18
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_ProcPost
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSProcPost).FormValidate("","001","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProcPostI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProcPostI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}		
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2023-2-6
/// Description：保存职务代码 
/// Table：CT_BDP_CT.HOS_ProcPost
/// Others：w ##class(web.DHCBL.CT.HOSProcPost).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProcPost) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PPOSTStartDate'="" eobj.PPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PPOSTStartDate)	//开始日期
	    s:eobj.PPOSTEndDate'="" eobj.PPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PPOSTEndDate)	//结束日期
		s:eobj.PPOSTStartDate="" eobj.PPOSTStartDate=+$h
		s:eobj.PPOSTActivity="" eobj.PPOSTActivity="N"
		s eobj.PPOSTLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PPOSTLastUpdateTime=$p($h,",",2) ///系统最后更新时间
	    s flag=..FormValidate(eobj.ID,eobj.PPOSTCode,eobj.PPOSTDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PPOSTCreateUser="") s eobj.PPOSTCreateUser=USERID   ///系统创建人
			if (eobj.PPOSTLastUpdateUser="") s eobj.PPOSTLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProcPost).%New()
			s obj.PPOSTCreateDate=+$H           ///系统创建日期
			s obj.PPOSTCreateTime=$p($h,",",2)  ///系统创建时间			
			d obj.PPOSTLastUpdateUserSetObjectId(eobj.PPOSTLastUpdateUser)  ///系统创建人
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProcPost).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProcPost).%New()
						
			s bobj.PPOSTCode=obj.PPOSTCode /// 流程岗位代码
			s bobj.PPOSTDesc=obj.PPOSTDesc ///流程岗位名称
			if $IsObject(obj.PPOSTBUCode){
			s bobj.PPOSTBUCode = obj.PPOSTBUCode.%Id()   //业务单元代码
			}	
			if $IsObject(obj.PPOSTPOSTCCode){
			s bobj.PPOSTPOSTCCode = obj.PPOSTPOSTCCode.%Id()   //岗位字典代码
			}						
			s bobj.PPOSTActivity=obj.PPOSTActivity ///是否有效	
			s bobj.PPOSTStartDate=obj.PPOSTStartDate ///开始日期
			s bobj.PPOSTEndDate=obj.PPOSTEndDate ///结束日期
			s bobj.PPOSTCreateDate=obj.PPOSTCreateDate ///系统创建日期
			s bobj.PPOSTCreateTime=obj.PPOSTCreateTime ///系统创建时间
			if $IsObject(obj.PPOSTCreateUser)
			{   
				s bobj.PPOSTCreateUser = obj.PPOSTCreateUser.%Id()   ///系统创建人
			}
			s bobj.PPOSTSeqNo=obj.PPOSTSeqNo ///系统排序号
			
			s bobj.PPOSTLastUpdateDate=obj.PPOSTLastUpdateDate ///系统最后更新日期
			s bobj.PPOSTLastUpdateTime=obj.PPOSTLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PPOSTLastUpdateUser)
			{   
				s bobj.PPOSTLastUpdateUser = obj.PPOSTLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PPOSTPYCode=obj.PPOSTPYCode ///拼音码
			s bobj.PPOSTWBCode=obj.PPOSTWBCode ///五笔码
			s bobj.PPOSTMark=obj.PPOSTMark ///备注
		}
		s obj.PPOSTCode=eobj.PPOSTCode ///流程岗位代码
		s obj.PPOSTDesc=eobj.PPOSTDesc ///流程岗位名称
		d obj.PPOSTBUCodeSetObjectId(eobj.PPOSTBUCode) ///业务单元代码
		d obj.PPOSTPOSTCCodeSetObjectId(eobj.PPOSTPOSTCCode) //岗位字典代码
		s obj.PPOSTActivity=eobj.PPOSTActivity	///是否有效
		s obj.PPOSTStartDate= eobj.PPOSTStartDate    ///开始日期
	    s obj.PPOSTEndDate= eobj.PPOSTEndDate 	///结束日期
		s obj.PPOSTSeqNo=eobj.PPOSTSeqNo ///系统排序号
		s obj.PPOSTLastUpdateDate=eobj.PPOSTLastUpdateDate ///系统最后更新日期
		s obj.PPOSTLastUpdateTime=eobj.PPOSTLastUpdateTime ///系统最后更新时间
		d obj.PPOSTLastUpdateUserSetObjectId(eobj.PPOSTLastUpdateUser)  ///系统最新更新人
		s:eobj.PPOSTPYCode="" eobj.PPOSTPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PPOSTDesc,4) ///自动生成拼音码
		s obj.PPOSTPYCode=eobj.PPOSTPYCode ///拼音码
		s:eobj.PPOSTWBCode="" eobj.PPOSTWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PPOSTDesc,1) ///自动生成五笔码
		s obj.PPOSTWBCode=eobj.PPOSTWBCode ///五笔码
		s obj.PPOSTMark=eobj.PPOSTMark ///备注
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProcPost","CT.BDP.CT.HOSProcPost","流程岗位代码",eobj.ID,eobj.PPOSTDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProcPost","CT.BDP.CT.HOSProcPost","流程岗位代码",id,eobj.PPOSTDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("流程岗位代码","web.DHCBL.CT.HOSProcPost","DeleteData",eobj)
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
	if $d(^CT.BDP.CT.HOSProcPostRelPostI("IndexPPRPProcPost",id)){
		s myInfo=myInfo_"流程岗位与业务岗位关系"
	}	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除流程岗位的内容
/// Table：CT_BDP_CT.HOS_ProcPost
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProcPost).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""	
	s re=##class(web.DHCBL.CT.HOSProcPost).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){			 
	s pobj = ##class(CT.BDP.CT.HOSProcPost).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProcPost).%New()
	s eobj.PPOSTCode=pobj.PPOSTCode ///流程岗位代码
	s eobj.PPOSTDesc=pobj.PPOSTDesc ///流程岗位名称	
	
	if $IsObject(pobj.PPOSTBUCode){
	s eobj.PPOSTBUCode = pobj.PPOSTBUCode.%Id()   //业务单元代码
	}	

	if $IsObject(pobj.PPOSTPOSTCCode){
	s eobj.PPOSTPOSTCCode = pobj.PPOSTPOSTCCode.%Id() //岗位字典代码
	}			
	s eobj.PPOSTActivity=pobj.PPOSTActivity ///是否有效		
	s eobj.PPOSTStartDate=pobj.PPOSTStartDate ///开始日期
	s eobj.PPOSTEndDate=pobj.PPOSTEndDate ///结束日期
	
	s eobj.PPOSTCreateDate=pobj.PPOSTCreateDate ///系统创建日期
	s eobj.PPOSTCreateTime=pobj.PPOSTCreateTime ///系统创建时间
	if $IsObject(pobj.PPOSTCreateUser)
	{   
		s eobj.PPOSTCreateUser = pobj.PPOSTCreateUser.%Id()   ///系统创建人
	}
	s eobj.PPOSTSeqNo=pobj.PPOSTSeqNo ///系统排序号
	s eobj.PPOSTLastUpdateDate=pobj.PPOSTLastUpdateDate ///系统最后更新日期
	s eobj.PPOSTLastUpdateTime=pobj.PPOSTLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PPOSTLastUpdateUser)
	{   
		s eobj.PPOSTLastUpdateUser = pobj.PPOSTLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PPOSTPYCode=pobj.PPOSTPYCode ///拼音码
	s eobj.PPOSTWBCode=pobj.PPOSTWBCode ///五笔码
	s eobj.PPOSTMark=pobj.PPOSTMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProcPost).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProcPost","CT.BDP.CT.HOSProcPost","流程岗位代码",id,eobj.PPOSTDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("流程岗位代码","web.DHCBL.CT.HOSProcPost","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}		 
	q result
}

}

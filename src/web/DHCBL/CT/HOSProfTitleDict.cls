/// Function:职务字典代码
/// Table：CT_BDP_CT.HOS_ProfTitleDict
/// CreateDate:2023-2-2
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfTitleDict Extends %RegisteredObject
{

/// Creator:lujunwen
/// CreateDate:2023-2-2
/// Description：职务字典代码查询
/// Table：CT_BDP_CT.HOS_ProfTitleDictDict
/// input id code(职务代码) desc(职务名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfTitleDict","GetList","","","","") 	
Query GetList(id As %String, code As %String, desc As %String, proftctypesearch As %String) As %Query(ROWSPEC = "ID:%String,PROFTCCode:%String,PROFTCDesc:%String,PROFTCType:%String,PROFTCPROFRCode:%String,PROFTCRankRange:%String,PROFTCActivity:%String,PROFTCStartDate:%Date,PROFTCEndDate:%Date,PROFTCSeqNo:%Float,PROFTCPYCode:%String,PROFTCWBCode:%String,PROFTCMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String, proftctypesearch As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
  	s AuStr=##class(web.DHCBL.Authorize.HOSProfTitleDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1

	s ProftcAuStr=##class(web.DHCBL.Authorize.CTOccupation).DHCGetDataByDefaultSession()
	s ProftcAuFlag=0	
	if (ProftcAuStr="")||(ProftcAuStr["limited:0") s ProftcAuFlag=1
	
	s ProfrAuStr=##class(web.DHCBL.Authorize.HOSProfRank).DHCGetDataByDefaultSession()
	s ProfrAuFlag=0	
	if (ProfrAuStr="")||(ProfrAuStr["limited:0") s ProfrAuFlag=1	
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
		
	    s PROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),2) /// 职务代码
	    s PROFTCDesc=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),3) /// 职务名称
	    
	    s PROFTCType=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),4) ///职务分类指针
	    s:PROFTCType'="" PROFTCType=$p($g(^CT("OCC",PROFTCType)),"^",2) ///职务分类描述
	    
	    s PROFTCPROFRCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),5) ///职务等级指针
	    s:PROFTCPROFRCode'="" PROFTCPROFRCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(PROFTCPROFRCode)),3) ///职务等级描述
	    
	    s PROFTCRankRange=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),6) ///职级范围
	    
		s PROFTCActivity=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),7) ///是否有效
		s PROFTCStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),8) ///开始日期
		s PROFTCEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),9) //结束日期
	    s:PROFTCStartDate'="" PROFTCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTCStartDate) ///转日期格式
	    s:PROFTCEndDate'="" PROFTCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTCEndDate)	///转日期格式
		s PROFTCSeqNo=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),13) ///系统排序号	
		s PROFTCPYCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),17) ///拼音码
		s PROFTCWBCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),18) ///五笔码
		s PROFTCMark=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),19) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfTitleDictD(ID)) q:ID=""  ///RowID
			s strRowId = "{ID:"_ID_"}"
			s PROFTCType=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),4) ///职务分类指针
			s ProftcstrRowId = "{ID:"_PROFTCType_"}"
			s PROFTCPROFRCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),5) ///职务等级指针
			s ProfrstrRowId = "{ID:"_PROFTCPROFRCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((ProftcAuStr[ProftcstrRowId)||(ProftcAuFlag=1))&&((ProfrAuStr[ProfrstrRowId)||(ProfrAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{					
			    s PROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),2) /// 职务代码
			    s PROFTCDesc=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),3) /// 职务名称
			    
			    
			    s:PROFTCPROFRCode'="" PROFTCPROFRCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(PROFTCPROFRCode)),3) ///职务等级描述
			    
			    s PROFTCRankRange=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),6) ///职级范围
			    
				s PROFTCActivity=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),7) ///是否有效
				s PROFTCStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),8) ///开始日期
				s PROFTCEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),9) //结束日期
			    s:PROFTCStartDate'="" PROFTCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTCStartDate) ///转日期格式
			    s:PROFTCEndDate'="" PROFTCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTCEndDate)	///转日期格式
				s PROFTCSeqNo=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),13) ///系统排序号	
				s PROFTCPYCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),17) ///拼音码
				s PROFTCWBCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),18) ///五笔码
				s PROFTCMark=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),19) ///备注
		    	s PINYIN=""
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFTCDesc)
		    	if ($ZCONVERT(PROFTCCode,"U")[code)&(($ZCONVERT(PROFTCDesc,"U")[desc)||(PINYIN[desc)&((proftctypesearch="")||(proftctypesearch=PROFTCType)))
		    	{
			    	s:PROFTCType'="" PROFTCType=$p($g(^CT("OCC",PROFTCType)),"^",2) ///职务分类描述
		            d OutputRow
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFTCCode,PROFTCDesc,PROFTCType,PROFTCPROFRCode,PROFTCRankRange,PROFTCActivity,PROFTCStartDate,PROFTCEndDate,PROFTCSeqNo,PROFTCPYCode,PROFTCWBCode,PROFTCMark)
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
/// Table：CT_BDP_CT.HOS_ProfTitleDictDict
/// input id code(职务代码) desc(职务名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfTitleDict","GetDataForCmb1","","","")	
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFTCCode:%String,PROFTCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSProfTitleDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1

	s ProftcAuStr=##class(web.DHCBL.Authorize.CTOccupation).DHCGetDataByDefaultSession()
	s ProftcAuFlag=0	
	if (ProftcAuStr="")||(ProftcAuStr["limited:0") s ProftcAuFlag=1
	
	s ProfrAuStr=##class(web.DHCBL.Authorize.HOSProfRank).DHCGetDataByDefaultSession()
	s ProfrAuFlag=0	
	if (ProfrAuStr="")||(ProfrAuStr["limited:0") s ProfrAuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),2) /// 职务代码
	    s PROFTCDesc=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),3) /// 职务名称
		s PROFTCActivity=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),7) ///是否有效
		s PROFTCStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),8) ///开始日期
		s PROFTCEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),9) //结束日期
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfTitleDictD(ID)) q:ID=""  ///RowID
			s strRowId = "{ID:"_ID_"}"
			s PROFTCType=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),4) ///职务分类指针
			s ProftcstrRowId = "{ID:"_PROFTCType_"}"
			s PROFTCPROFRCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),5) ///职务等级指针
			s ProfrstrRowId = "{ID:"_PROFTCPROFRCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((ProftcAuStr[ProftcstrRowId)||(ProftcAuFlag=1))&&((ProfrAuStr[ProfrstrRowId)||(ProfrAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
			    s PROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),2) /// 职务代码
			    s PROFTCDesc=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),3) /// 职务名称
			     
				s PROFTCActivity=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),7) ///是否有效
				continue:PROFTCActivity="N"
				s PROFTCStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),8) ///开始日期
				continue:(PROFTCStartDate'="")&&(PROFTCStartDate>+$h)
				s PROFTCEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(ID)),9) //结束日期
				continue:(PROFTCEndDate'="")&&(PROFTCEndDate<+$h)		
				
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFTCDesc)
		    	if ($ZCONVERT(PROFTCCode,"U")[code)&(($ZCONVERT(PROFTCDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PROFTCCode,PROFTCDesc)
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
/// Other: w ##class(web.DHCBL.CT.HOSProfTitleDict).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSProfTitleDict).%New()
    s obj = ##class(CT.BDP.CT.HOSProfTitleDict).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PROFTCCode=obj.PROFTCCode /// 职务代码
    s eobj.PROFTCDesc=obj.PROFTCDesc /// 职务名称
	if $IsObject(obj.PROFTCType)
	{
		s eobj.PROFTCType = obj.PROFTCType.%Id()   //职务分类
	}
	if $IsObject(obj.PROFTCPROFRCode)
	{
		s eobj.PROFTCPROFRCode = obj.PROFTCPROFRCode.%Id()   //职务等级
	}	
	s eobj.PROFTCRankRange=obj.PROFTCRankRange ///职级范围
    s eobj.PROFTCActivity=obj.PROFTCActivity  ///是否有效
    s eobj.PROFTCStartDate=obj.PROFTCStartDate  ///开始日期
    s eobj.PROFTCEndDate=obj.PROFTCEndDate  ///结束日期
    s:obj.PROFTCStartDate'="" eobj.PROFTCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFTCStartDate) ///开始日期(转格式)
    s:obj.PROFTCEndDate'="" eobj.PROFTCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFTCEndDate) ///结束日期(转格式) 
    s eobj.PROFTCSeqNo=obj.PROFTCSeqNo ///排序号
    s eobj.PROFTCPYCode=obj.PROFTCPYCode  ///拼音码
    s eobj.PROFTCWBCode=obj.PROFTCWBCode  ///五笔码
    s eobj.PROFTCMark=obj.PROFTCMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-18
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_OccuSubCate
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSProfTitleDict).FormValidate("1","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfTitleDictI("IndexPROFTCCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfTitleDictI("IndexPROFTCDesc"," "_$ZCONVERT(desc,"U"),0)) 
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
/// Table：CT_BDP_CT.HOS_ProfTitleDictDict
/// Others：w ##class(web.DHCBL.CT.HOSProfTitleDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfTitleDict) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFTCStartDate'="" eobj.PROFTCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFTCStartDate)	//开始日期
	    s:eobj.PROFTCEndDate'="" eobj.PROFTCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFTCEndDate)	//结束日期
		s:eobj.PROFTCStartDate="" eobj.PROFTCStartDate=+$h
		s:eobj.PROFTCActivity="" eobj.PROFTCActivity="N"
		s eobj.PROFTCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PROFTCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
	    s flag=..FormValidate(eobj.ID,eobj.PROFTCCode,eobj.PROFTCDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFTCCreateUser="") s eobj.PROFTCCreateUser=USERID   ///系统创建人
			if (eobj.PROFTCLastUpdateUser="") s eobj.PROFTCLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProfTitleDict).%New()
			s obj.PROFTCCreateDate=+$H           ///系统创建日期
			s obj.PROFTCCreateTime=$p($h,",",2)  ///系统创建时间			
			d obj.PROFTCLastUpdateUserSetObjectId(eobj.PROFTCLastUpdateUser)  ///系统创建人
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfTitleDict).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfTitleDict).%New()
						
			s bobj.PROFTCCode=obj.PROFTCCode /// 职务代码
			s bobj.PROFTCDesc=obj.PROFTCDesc ///职务名称
			if $IsObject(obj.PROFTCType){
			s bobj.PROFTCType = obj.PROFTCType.%Id()   //职务分类
			}	
			if $IsObject(obj.PROFTCPROFRCode){
			s bobj.PROFTCPROFRCode = obj.PROFTCPROFRCode.%Id()   //职务等级
			}
			s bobj.PROFTCRankRange=obj.PROFTCRankRange ///职级范围						
			s bobj.PROFTCActivity=obj.PROFTCActivity ///是否有效	
			s bobj.PROFTCStartDate=obj.PROFTCStartDate ///开始日期
			s bobj.PROFTCEndDate=obj.PROFTCEndDate ///结束日期
			s bobj.PROFTCCreateDate=obj.PROFTCCreateDate ///系统创建日期
			s bobj.PROFTCCreateTime=obj.PROFTCCreateTime ///系统创建时间
			if $IsObject(obj.PROFTCCreateUser)
			{   
				s bobj.PROFTCCreateUser = obj.PROFTCCreateUser.%Id()   ///系统创建人
			}
			s bobj.PROFTCSeqNo=obj.PROFTCSeqNo ///系统排序号
			
			s bobj.PROFTCLastUpdateDate=obj.PROFTCLastUpdateDate ///系统最后更新日期
			s bobj.PROFTCLastUpdateTime=obj.PROFTCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFTCLastUpdateUser)
			{   
				s bobj.PROFTCLastUpdateUser = obj.PROFTCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFTCPYCode=obj.PROFTCPYCode ///拼音码
			s bobj.PROFTCWBCode=obj.PROFTCWBCode ///五笔码
			s bobj.PROFTCMark=obj.PROFTCMark ///备注
		}
		s obj.PROFTCCode=eobj.PROFTCCode ///职务代码
		s obj.PROFTCDesc=eobj.PROFTCDesc ///职务名称
		d obj.PROFTCTypeSetObjectId(eobj.PROFTCType) ///职务分类
		d obj.PROFTCPROFRCodeSetObjectId(eobj.PROFTCPROFRCode) ///职务等级
		s obj.PROFTCRankRange=eobj.PROFTCRankRange ///职级范围
		s obj.PROFTCActivity=eobj.PROFTCActivity	///是否有效
		s obj.PROFTCStartDate= eobj.PROFTCStartDate    ///开始日期
	    s obj.PROFTCEndDate= eobj.PROFTCEndDate 	///结束日期
		s obj.PROFTCSeqNo=eobj.PROFTCSeqNo ///系统排序号
		s obj.PROFTCLastUpdateDate=eobj.PROFTCLastUpdateDate ///系统最后更新日期
		s obj.PROFTCLastUpdateTime=eobj.PROFTCLastUpdateTime ///系统最后更新时间
		d obj.PROFTCLastUpdateUserSetObjectId(eobj.PROFTCLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFTCPYCode="" eobj.PROFTCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFTCDesc,4) ///自动生成拼音码
		s obj.PROFTCPYCode=eobj.PROFTCPYCode ///拼音码
		s:eobj.PROFTCWBCode="" eobj.PROFTCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFTCDesc,1) ///自动生成五笔码
		s obj.PROFTCWBCode=eobj.PROFTCWBCode ///五笔码
		s obj.PROFTCMark=eobj.PROFTCMark ///备注
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfTitleDict","CT.BDP.CT.HOSProfTitleDict","职务代码",eobj.ID,eobj.PROFTCDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfTitleDict","CT.BDP.CT.HOSProfTitleDict","职务代码",id,eobj.PROFTCDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务代码","web.DHCBL.CT.HOSProfTitleDict","DeleteData",eobj)
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
	if $d(^CT.BDP.CT.HOSProfTitleI("IndexPROFTCCode",id)){
		s myInfo=myInfo_"组织职务"
	}	
	if $d(^CT.BDP.CT.HOSPostDictI("IndexPROFTCode",id)){
	s myInfo=myInfo_"岗位字典"
	}	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除职务代码的内容
/// Table：CT_BDP_CT.HOS_ProfTitle
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfTitleDict).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HOSProfTitleDict).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){			 
	s pobj = ##class(CT.BDP.CT.HOSProfTitleDict).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfTitleDict).%New()
	s eobj.PROFTCCode=pobj.PROFTCCode ///职务代码
	s eobj.PROFTCDesc=pobj.PROFTCDesc ///职务名称	
	
	if $IsObject(pobj.PROFTCType){
	s eobj.PROFTCType = pobj.PROFTCType.%Id()   //职务分类
	}	

	if $IsObject(pobj.PROFTCPROFRCode){
	s eobj.PROFTCPROFRCode = pobj.PROFTCPROFRCode.%Id()   //职务等级
	}	
	s eobj.PROFTCRankRange=pobj.PROFTCRankRange ///职级范围			
	s eobj.PROFTCActivity=pobj.PROFTCActivity ///是否有效		
	s eobj.PROFTCStartDate=pobj.PROFTCStartDate ///开始日期
	s eobj.PROFTCEndDate=pobj.PROFTCEndDate ///结束日期
	
	s eobj.PROFTCCreateDate=pobj.PROFTCCreateDate ///系统创建日期
	s eobj.PROFTCCreateTime=pobj.PROFTCCreateTime ///系统创建时间
	if $IsObject(pobj.PROFTCCreateUser)
	{   
		s eobj.PROFTCCreateUser = pobj.PROFTCCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFTCSeqNo=pobj.PROFTCSeqNo ///系统排序号
	s eobj.PROFTCLastUpdateDate=pobj.PROFTCLastUpdateDate ///系统最后更新日期
	s eobj.PROFTCLastUpdateTime=pobj.PROFTCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFTCLastUpdateUser)
	{   
		s eobj.PROFTCLastUpdateUser = pobj.PROFTCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFTCPYCode=pobj.PROFTCPYCode ///拼音码
	s eobj.PROFTCWBCode=pobj.PROFTCWBCode ///五笔码
	s eobj.PROFTCMark=pobj.PROFTCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfTitleDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfTitleDict","CT.BDP.CT.HOSProfTitleDict","职务代码",id,eobj.PROFTCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务代码","web.DHCBL.CT.HOSProfTitleDict","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}		 
	q result
}

}

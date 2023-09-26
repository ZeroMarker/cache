/// Function: 职务等级代码
/// Table：CT_BDP_CT.HOS_ProfRank
/// CreateDate:2022-11-10
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfRank Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-10
/// Description：职务等级代码信息查询
/// Table：CT_BDP_CT.HOS_ProfRank
/// input id code(职务等级代码) desc(职务等级名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfRank","GetList","1","","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFRCode:%String,PROFRDesc:%String,PROFRRankValue:%String,PROFRActivity:%String,PROFRStartDate:%Date,PROFREndDate:%Date,PROFRSeqNo:%Float,PROFRPYCode:%String,PROFRWBCode:%String,PROFRMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
    s AuStr=##class(web.DHCBL.Authorize.HOSProfRank).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	
	if (id'="") //根据rowid返回该条记录
	{	
		s ID=id //子表RowId		
	    s PROFRCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),2) /// 职务等级代码
	    s PROFRDesc=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),3) /// 职务等级名称
	    s PROFRRankValue=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),4) ///职务等级
		s PROFRActivity=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),5) ///是否有效
		s PROFRStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),6) ///开始日期
		s PROFREndDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),7) //结束日期
	    s:PROFRStartDate'="" PROFRStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFRStartDate) ///转日期格式
	    s:PROFREndDate'="" PROFREndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFREndDate)	///转日期格式
		s PROFRSeqNo=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),11) ///系统排序号
		s PROFRPYCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),15) ///拼音码
		s PROFRWBCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),16) ///五笔码
		s PROFRMark=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),17) ///备注
	    d OutputRow
	}
	else
	{
		s ID=0
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfRankD(ID)) q:ID=""  ///RowID
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
			    s PROFRCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),2) /// 职务等级代码
			    s PROFRDesc=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),3) /// 职务等级名称
			    s PROFRRankValue=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),4) ///职务等级
				s PROFRActivity=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),5) ///是否有效
				s PROFRStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),6) ///开始日期
				s PROFREndDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),7) //结束日期
			    s:PROFRStartDate'="" PROFRStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFRStartDate) ///转日期格式
			    s:PROFREndDate'="" PROFREndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFREndDate)	///转日期格式
				s PROFRSeqNo=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),11) ///系统排序号	
				s PROFRPYCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),15) ///拼音码
				s PROFRWBCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),16) ///五笔码
				s PROFRMark=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),17) ///备注
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFRDesc)   
		    	if ($ZCONVERT(PROFRCode,"U")[code)&(($ZCONVERT(PROFRDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRow
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFRCode,PROFRDesc,PROFRRankValue,PROFRActivity,PROFRStartDate,PROFREndDate,PROFRSeqNo,PROFRPYCode,PROFRWBCode,PROFRMark)
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

/// Creator:lujunwen
/// CreateDate:2022-11-10
/// Description：为combox提供下拉数据
/// Table：CT_BDP_CT.HOS_ProfRank
/// input: id code(职务等级代码) desc(职务等级名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfRank","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFRCode:%String,PROFRDesc:%String,PROFRRankValue:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSProfRank).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id //子表RowId
	    s PROFRCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),2) /// 职务等级代码
	    s PROFRDesc=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),3) /// 职务等级名称
	    s PROFRRankValue=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),4) ///职务等级
		s PROFRActivity=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),5) ///是否有效
		s PROFRStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),6) ///开始日期
		s PROFREndDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),7) //结束日期
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
			for 
			{
				s ID=$o(^CT.BDP.CT.HOSProfRankD(ID)) q:ID=""  ///RowID
	            s strRowId = "{ID:"_ID_"}"
				i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效	
				{			
				    s PROFRCode=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),2) /// 职务等级代码
				    s PROFRDesc=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),3) /// 职务等级名称
				    s PROFRRankValue=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),4) ///职务等级
					s PROFRActivity=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),5) ///是否有效
					continue:PROFRActivity="N"
					s PROFRStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),6) ///开始日期
					continue:(PROFRStartDate'="")&&(PROFRStartDate>+$h)
					s PROFREndDate=$LISTGET($G(^CT.BDP.CT.HOSProfRankD(ID)),7) //结束日期					
					continue:(PROFREndDate'="")&&(PROFREndDate<+$h)
			        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFRDesc)
			    	if ($ZCONVERT(PROFRCode,"U")[code)&(($ZCONVERT(PROFRDesc,"U")[desc)||(PINYIN[desc))
			    	{
			            d OutputRowCmb
			    	} 
				}
			}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PROFRCode,PROFRDesc,PROFRRankValue)
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
/// CreatDate:  2022-11-11
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// debug: w ##class(web.DHCBL.CT.HOSProfRank).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.HOSProfRank).%New()
	s obj = ##class(CT.BDP.CT.HOSProfRank).%OpenId(id)
	s eobj.ID=id //RowId
	s eobj.PROFRCode=obj.PROFRCode /// 职务等级代码
	s eobj.PROFRDesc=obj.PROFRDesc /// 职务等级名称
	s eobj.PROFRRankValue=obj.PROFRRankValue /// 职务等级
	s eobj.PROFRActivity=obj.PROFRActivity /// 是否有效(Y/N)
	s eobj.PROFRStartDate= obj.PROFRStartDate  //开始日期
	s eobj.PROFREndDate= obj.PROFREndDate    //结束日期
	s eobj.PROFRSeqNo= obj.PROFRSeqNo    /// 系统排序号
	s eobj.PROFRPYCode= obj.PROFRPYCode   /// 拼音码
	s eobj.PROFRWBCode= obj.PROFRWBCode   /// 五笔码
	s eobj.PROFRMark= obj.PROFRMark    /// 备注
	s:eobj.PROFRStartDate'="" eobj.PROFRStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.PROFRStartDate) //转日期格式
	s:eobj.PROFRStartDate'="" eobj.PROFRStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.PROFRStartDate)       //转日期格式
	s str = eobj.JsonS()    
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-11
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_ProfRank
/// Input：id,code(代码),desc(描述)
/// Others：w ##class(web.DHCBL.CT.HOSProfRank).FormValidate("","001","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0	
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfRankI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}	
	}
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfRankI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
			
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月11日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSProfRank).savetest()
ClassMethod savetest()
{
	
	s eobj=##class(web.Entity.CT.HOSProfRank).%New()
	s eobj.PROFRCode="001"  /// 职务等级代码
	s eobj.PROFRDesc="测试" ///职务等级名称
	s eobj.PROFRRankValue="3" /// 职务等级
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-11
/// Description：保存职务等级代码 
/// Table：CT_BDP_CT.HOS_ProfRank
/// Others：w ##class(web.DHCBL.CT.HOSProfRank).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfRank) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFRStartDate'="" eobj.PROFRStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFRStartDate)	//开始日期
	    s:eobj.PROFREndDate'="" eobj.PROFREndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFREndDate)	//结束日期
		s:eobj.PROFRStartDate="" eobj.PROFRStartDate=+$h 
		s:eobj.PROFRActivity="" eobj.PROFRActivity="N"
	    s flag=..FormValidate(eobj.ID,eobj.PROFRCode,eobj.PROFRDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFRCreateUser="") s eobj.PROFRCreateUser=USERID   ///系统创建人
			if (eobj.PROFRLastUpdateUser="") s eobj.PROFRLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{	s obj=##class(CT.BDP.CT.HOSProfRank).%New()
			d obj.PROFRLastUpdateUserSetObjectId(eobj.PROFRLastUpdateUser)  ///系统创建人
			s obj.PROFRCreateDate=+$H           ///系统创建日期
			s obj.PROFRCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfRank).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfRank).%New()			
			s bobj.PROFRCode=obj.PROFRCode /// 职务等级代码
			s bobj.PROFRDesc=obj.PROFRDesc ///职务等级名称
			s bobj.PROFRRankValue=obj.PROFRRankValue /// 职务等级
			s bobj.PROFRActivity=obj.PROFRActivity ///是否有效	
			s bobj.PROFRStartDate=obj.PROFRStartDate ///开始日期
			s bobj.PROFREndDate=obj.PROFREndDate ///结束日期
			s bobj.PROFRCreateDate=obj.PROFRCreateDate ///系统创建日期
			s bobj.PROFRCreateTime=obj.PROFRCreateTime ///系统创建时间
			if $IsObject(obj.PROFRCreateUser)
			{   
				s bobj.PROFRCreateUser = obj.PROFRCreateUser.%Id()   ///系统创建人
			}
			s bobj.PROFRSeqNo=obj.PROFRSeqNo ///系统排序号
			
			s bobj.PROFRLastUpdateDate=obj.PROFRLastUpdateDate ///系统最后更新日期
			s bobj.PROFRLastUpdateTime=obj.PROFRLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFRLastUpdateUser)
			{   
				s bobj.PROFRLastUpdateUser = obj.PROFRLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFRPYCode=obj.PROFRPYCode ///拼音码
			s bobj.PROFRWBCode=obj.PROFRWBCode ///五笔码
			s bobj.PROFRMark=obj.PROFRMark ///备注
		}
		
		s obj.PROFRCode=eobj.PROFRCode ///职务等级代码
		s obj.PROFRDesc=eobj.PROFRDesc ///职务等级名称
		s obj.PROFRRankValue=eobj.PROFRRankValue /// 职务等级
		s obj.PROFRActivity=eobj.PROFRActivity	///是否有效
		s obj.PROFRStartDate= eobj.PROFRStartDate    ///开始日期
	    s obj.PROFREndDate= eobj.PROFREndDate 	///结束日期
		s obj.PROFRSeqNo=eobj.PROFRSeqNo ///系统排序号
		s obj.PROFRLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s obj.PROFRLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		d obj.PROFRLastUpdateUserSetObjectId(eobj.PROFRLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFRPYCode="" eobj.PROFRPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFRDesc,4) ///自动生成拼音码
		s obj.PROFRPYCode=eobj.PROFRPYCode ///拼音码
		s:eobj.PROFRWBCode="" eobj.PROFRWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFRDesc,1) ///自动生成五笔码
		s obj.PROFRWBCode=eobj.PROFRWBCode ///五笔码
		s obj.PROFRMark=eobj.PROFRMark ///备注
		s obj.PROFRStartDate= eobj.PROFRStartDate	//开始日期
		s obj.PROFREndDate= eobj.PROFREndDate		//结束日期
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfRank","CT.BDP.CT.HOSProfRank","职务等级代码",eobj.ID,eobj.PROFRDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfRank","CT.BDP.CT.HOSProfRank","职务等级代码",id,eobj.PROFRDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务等级代码","web.DHCBL.CT.HOSProfRank","DeleteData",eobj)
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
	if $d(^CT.BDP.CT.HOSProfTitleDictI("IndexPROFRCode",id)){
		s myInfo=myInfo_"<职务字典>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-11
/// Description：根据ID删除职务等级代码的内容
/// Table：CT_BDP_CT.HOS_ProfRank
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfRank).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HOSProfRank).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		
	s pobj = ##class(CT.BDP.CT.HOSProfRank).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfRank).%New()
	s eobj.PROFRCode=pobj.PROFRCode ///职务等级代码
	s eobj.PROFRDesc=pobj.PROFRDesc ///职务等级名称
	s eobj.PROFRRankValue=pobj.PROFRRankValue ///职务等级
	s eobj.PROFRActivity=pobj.PROFRActivity ///是否有效		
	s eobj.PROFRStartDate=pobj.PROFRStartDate ///开始日期
	s eobj.PROFREndDate=pobj.PROFREndDate ///结束日期
	
	s eobj.PROFRCreateDate=pobj.PROFRCreateDate ///系统创建日期
	s eobj.PROFRCreateTime=pobj.PROFRCreateTime ///系统创建时间
	if $IsObject(pobj.PROFRCreateUser)
	{   
		s eobj.PROFRCreateUser = pobj.PROFRCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFRSeqNo=pobj.PROFRSeqNo ///系统排序号
	s eobj.PROFRLastUpdateDate=pobj.PROFRLastUpdateDate ///系统最后更新日期
	s eobj.PROFRLastUpdateTime=pobj.PROFRLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFRLastUpdateUser)
	{   
		s eobj.PROFRLastUpdateUser = pobj.PROFRLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFRPYCode=pobj.PROFRPYCode ///拼音码
	s eobj.PROFRWBCode=pobj.PROFRWBCode ///五笔码
	s eobj.PROFRMark=pobj.PROFRMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfRank).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志 
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfRank","CT_BDP_CT.HOS_ProfRank","职务等级代码",id,eobj.PROFRDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务等级代码","web.DHCBL.CT.HOSProfRank","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	
	q result
}

}

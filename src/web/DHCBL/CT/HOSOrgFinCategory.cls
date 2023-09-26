/// Function: 机构分类小类
/// Table：CT_BDP_CT.HOS_OrgFinCategory
/// CreateDate:2022-11-25
/// Creator:lujunwen
Class web.DHCBL.CT.HOSOrgFinCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-25
/// Description：机构小类信息查询
/// Table：CT_BDP_CT.HOS_OrgFinCategory
/// input id code(机构小类代码) desc(机构小类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgFinCategory","GetList","","","","") 
Query GetList(parref As %String, id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OFCCode:%String,OFCDesc:%String,OFCComments:%String,OFCSource:%String,OFCActivity:%String,OFCStartDate:%Date,OFCEndDate:%Date,OFCSeqNo:%Float,OFCPYCode:%String,OFCWBCode:%String,OFCMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ChildSub=$p(id,"||",3) //子表ID
		s ID=id //子表RowId
		s PriCategoryParRef=$p(id,"||",1) //父表父ID
		s SecPriCategoryParRef=$p(id,"||",1,2) //父表ID
		s ParRef=$p(id,"||",2)
		
	    s OFCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),2) /// 机构小类代码
	    s OFCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),3) /// 机构小类名称
	    s OFCComments=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),4) /// 注释
	    
	    s OFCSource=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),5) /// 分类来源
	    s OFCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),6) /// 是否有效	    
	    s OFCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),7) /// 开始日期	        
		s OFCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),8) //结束日期
	    s:OFCStartDate'="" OFCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OFCStartDate) ///转日期格式
	    s:OFCEndDate'="" OFCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OFCEndDate)	///转日期格式
		s OFCSeqNo=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),12) ///系统排序号
		s OFCPYCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),16) ///拼音码
		s OFCWBCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),17) ///五笔码
		s OFCMark=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),18) ///备注
	    d OutputRow
	}
	else
	{
	    s ChildSub=0
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s PriCategoryParRef=$p(parref,"||",1) //父表父ID
	    s SecPriCategoryParRef=$p(parref,"||",1,2) //父表ID   
	    s ParRef=$p(parref,"||",2)
		for 
		{ 
			s ChildSub=$o(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)) q:ChildSub=""
			s ID=parref_"||"_ChildSub //子表RowId
			s PriCategoryParRef=$p(parref,"||",1) //父表父ID
		    s OFCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),2) /// 机构小类代码
		    s OFCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),3) /// 机构小类名称
		    s OFCComments=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),4) /// 注释
		    
		    s OFCSource=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),5) /// 分类来源
		    s OFCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),6) /// 是否有效	    
		    s OFCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),7) /// 开始日期	        
			s OFCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),8) //结束日期
		    s:OFCStartDate'="" OFCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OFCStartDate) ///转日期格式
		    s:OFCEndDate'="" OFCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OFCEndDate)	///转日期格式
			s OFCSeqNo=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),12) ///系统排序号
			s OFCPYCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),16) ///拼音码
			s OFCWBCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),17) ///五笔码
			s OFCMark=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),18) ///备注
	    	if ($ZCONVERT(OFCCode,"U")[code)&(($ZCONVERT(OFCDesc,"U")[desc)||($ZCONVERT(OFCPYCode,"U")[desc))
	    	{
	            d OutputRow
	    	} 
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,OFCCode,OFCDesc,OFCComments,OFCSource,OFCActivity,OFCStartDate,OFCEndDate,OFCSeqNo,OFCPYCode,OFCWBCode,OFCMark)
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
/// CreateDate:2022-11-25
/// Description：为combox提供下拉数据
/// Table：CT_BDP_CT.HOS_OrgFinCategory
/// input:parref(父表id) id code(机构小类代码) desc(机构小类名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgFinCategory","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OFCCode:%String,OFCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ChildSub=$p(id,"||",3) //子表ID
		s ID=id //子表RowId
	    s PriCategoryParRef=$p(id,"||",1) //父表父ID
	    s SecPriCategoryParRef=$p(id,"||",1,2) //父表ID
	    s ParRef=$p(id,"||",2)
	    s OFCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),2) /// 机构小类代码
	    s OFCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),3) /// 机构小类名称
	    s OFCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),6) /// 是否有效	    
	    s OFCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),7) /// 开始日期
		s OFCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),8) //结束日期	        
	    d OutputRowCmb
	}
	else
	{	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s PriCategoryParRef=0
		for
		{	
			s PriCategoryParRef=$o(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef)) q:PriCategoryParRef=""
			s ParRef=0
			for
			{	
				s ParRef=$o(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef)) q:ParRef=""
				s ChildSub=0
				for 
				{	s ChildSub=$o(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)) q:ChildSub=""
					s ID=PriCategoryParRef_"||"_ParRef_"||"_ChildSub
				    s OFCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),2) /// 机构小类代码
				    s OFCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),3) /// 机构小类名称
				    s OFCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),6) /// 是否有效
	    			continue:OFCActivity="N"
				    s OFCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),7) /// 开始日期
				    continue:(OFCStartDate'="")&&(OFCStartDate>+$h)	        
					s OFCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ParRef,"ChildOrgFinCategory",ChildSub)),8) //结束日期				
					continue:(OFCEndDate'="")&&(OFCEndDate<+$h)
					s PINYIN=""
					s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OFCDesc)	
					if (($ZCONVERT(OFCDesc,"U")[desc)||(PINYIN[desc))
					{						
        				d OutputRowCmb
					}
				}
				
			}
		
		}
		
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,OFCCode,OFCDesc)
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
/// CreatDate:  2022-11-25
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// debug: w ##class(web.DHCBL.CT.HOSOrgFinCategory).OpenData("1||2||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.HOSOrgFinCategory).%New()
	s obj = ##class(CT.BDP.CT.HOSOrgFinCategory).%OpenId(id)
	s eobj.ID=id //RowId
	s eobj.OFCCode=obj.OFCCode /// 机构小类代码
	s eobj.OFCDesc=obj.OFCDesc /// 机构小类名称
	s eobj.OFCComments=obj.OFCComments ///注释
	s eobj.OFCSource=obj.OFCSource /// 分类来源	
	s eobj.OFCActivity=obj.OFCActivity /// 是否有效(Y/N)
	s eobj.OFCStartDate= obj.OFCStartDate  //开始日期
	s eobj.OFCEndDate= obj.OFCEndDate    //结束日期
	s eobj.OFCSeqNo= obj.OFCSeqNo    /// 系统排序号
	s eobj.OFCPYCode= obj.OFCPYCode   /// 拼音码
	s eobj.OFCWBCode= obj.OFCWBCode   /// 五笔码
	s eobj.OFCMark= obj.OFCMark    /// 备注
	s:eobj.OFCStartDate'="" eobj.OFCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.OFCStartDate) //转日期格式
	s:eobj.OFCStartDate'="" eobj.OFCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.OFCStartDate)       //转日期格式
	s str = eobj.JsonS()    
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-25
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_OrgFinCategory
/// Input：id(子表RowId右部),code(代码),desc(描述)
/// Others：w ##class(web.DHCBL.CT.HOSOrgFinCategory).FormValidate("1||2","","005","保存测试")
ClassMethod FormValidate(seccategoryparref As %String, id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	s PriCategoryParRef=$p(seccategoryparref,"||",1)
	s ParRef=$p(seccategoryparref,"||",2)
	if (code'="")
	{	
		s ChildSub=$o(^CT.BDP.CT.HOSOrgFinCategoryI("IndexParRefCode",PriCategoryParRef,ParRef," "_$ZCONVERT(code,"U"),0))
		if (ChildSub'="")
		{
			s ID=PriCategoryParRef_"||"_ParRef_"||"_ChildSub
			if (ID'="")&&(id'=ID)
			{	
				s flag=1
			}			
	
		}	
	
	}
	
	if (desc'="")
	{	
		s ChildSub=$o(^CT.BDP.CT.HOSOrgFinCategoryI("IndexParRefDesc",PriCategoryParRef,ParRef," "_$ZCONVERT(desc,"U"),0))
		if (ChildSub'="")
		{
			s ID=PriCategoryParRef_"||"_ParRef_"||"_ChildSub
			
			if (ID'="")&&(id'=ID)
			{	
				s flag=1
				
			}			
	
		}	
	
	}	
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月25日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSOrgFinCategory).savetest()
ClassMethod savetest()
{
	
	s eobj=##class(web.Entity.CT.HOSOrgFinCategory).%New()
	s eobj.SecCategoryParRef="1||2"
	s eobj.OFCCode="003"  /// 职务专业代码
	s eobj.OFCDesc="保存测试" ///职务专业名称
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-25
/// Description：保存机构小类代码 
/// Table：CT_BDP_CT.HOS_OrgFinCategory
/// Others：w ##class(web.DHCBL.CT.HOSOrgFinCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgFinCategory) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OFCStartDate'="" eobj.OFCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OFCStartDate)	//开始日期
	    s:eobj.OFCEndDate'="" eobj.OFCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OFCEndDate)	//结束日期
		s:eobj.OFCStartDate="" eobj.OFCStartDate=+$h
		s:eobj.OFCActivity="" eobj.OFCActivity="N"   
	    s flag=..FormValidate(eobj.SecCategoryParRef,eobj.ID,eobj.OFCCode,eobj.OFCDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.OFCCreateUser="") s eobj.OFCCreateUser=USERID   ///系统创建人
			if (eobj.OFCLastUpdateUser="") s eobj.OFCLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSOrgFinCategory).%New(eobj.SecCategoryParRef)
			d obj.OFCLastUpdateUserSetObjectId(eobj.OFCLastUpdateUser)  ///系统创建人
			s obj.OFCCreateDate=+$H           ///系统创建日期
			s obj.OFCCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSOrgFinCategory).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSOrgFinCategory).%New()			
			s bobj.OFCCode=obj.OFCCode /// 职务专业代码
			s bobj.OFCDesc=obj.OFCDesc ///职务专业名称
			s bobj.OFCSource=obj.OFCSource /// 分类来源
			s bobj.OFCComments=obj.OFCComments ///注释
			s bobj.OFCActivity=obj.OFCActivity ///是否有效	
			s bobj.OFCStartDate=obj.OFCStartDate ///开始日期
			s bobj.OFCEndDate=obj.OFCEndDate ///结束日期
			s bobj.OFCCreateDate=obj.OFCCreateDate ///系统创建日期
			s bobj.OFCCreateTime=obj.OFCCreateTime ///系统创建时间
			if $IsObject(obj.OFCCreateUser)
			{   
				s bobj.OFCCreateUser = obj.OFCCreateUser.%Id()   ///系统创建人
			}
			s bobj.OFCSeqNo=obj.OFCSeqNo ///系统排序号
			
			s bobj.OFCLastUpdateDate=obj.OFCLastUpdateDate ///系统最后更新日期
			s bobj.OFCLastUpdateTime=obj.OFCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.OFCLastUpdateUser)
			{   
				s bobj.OFCLastUpdateUser = obj.OFCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.OFCPYCode=obj.OFCPYCode ///拼音码
			s bobj.OFCWBCode=obj.OFCWBCode ///五笔码
			s bobj.OFCMark=obj.OFCMark ///备注
		}
		
		d:eobj.SecCategoryParRef'="" obj.SecCategoryParRefSetObjectId(eobj.SecCategoryParRef) //修改数据时ParRef为空
		s obj.OFCCode=eobj.OFCCode ///职务专业代码
		s obj.OFCDesc=eobj.OFCDesc ///职务专业名称
		s obj.OFCComments=eobj.OFCComments ///注释
		s obj.OFCSource=eobj.OFCSource /// 分类来源
		s obj.OFCActivity=eobj.OFCActivity	///是否有效
		s obj.OFCStartDate= eobj.OFCStartDate    ///开始日期
	    s obj.OFCEndDate= eobj.OFCEndDate 	///结束日期
		s obj.OFCSeqNo=eobj.OFCSeqNo ///系统排序号
		s obj.OFCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s obj.OFCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		d obj.OFCLastUpdateUserSetObjectId(eobj.OFCLastUpdateUser)  ///系统最新更新人
		s:eobj.OFCPYCode="" eobj.OFCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.OFCDesc,4) ///自动生成拼音码
		s obj.OFCPYCode=eobj.OFCPYCode ///拼音码
		s:eobj.OFCWBCode="" eobj.OFCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.OFCDesc,1) ///自动生成五笔码
		s obj.OFCWBCode=eobj.OFCWBCode ///五笔码
		s obj.OFCMark=eobj.OFCMark ///备注
		s obj.OFCStartDate= eobj.OFCStartDate	//开始日期
		s obj.OFCStartDate= eobj.OFCStartDate		//结束日期
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgFinCategory","CT.BDP.CT.HOSOrgFinCategory","机构小类",eobj.ID,eobj.OFCDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgFinCategory","CT.BDP.CT.HOSOrgFinCategory","机构小类",id,eobj.OFCDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("机构小类代码","web.DHCBL.CT.HOSOrgFinCategory","DeleteData",eobj)
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
/// CreatDate:2022-12-5
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGFCCode",id)){
		s myInfo=myInfo_"<组织机构树>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-24
/// Description：根据ID删除机构分类小类代码的内容
/// Table：CT_BDP_CT.HOS_OrgFinCategory
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgFinCategory).DeleteData("3||6||4")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HOSOrgFinCategory).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		 
	s pobj = ##class(CT.BDP.CT.HOSOrgFinCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSOrgFinCategory).%New()
	s eobj.OFCCode=pobj.OFCCode ///机构小类代码
	s eobj.OFCDesc=pobj.OFCDesc ///机构小类名称
	s eobj.OFCComments=pobj.OFCComments ///注释
	s eobj.OFCSource=pobj.OFCSource ///分类来源
	s eobj.OFCActivity=pobj.OFCActivity ///是否有效		
	s eobj.OFCStartDate=pobj.OFCStartDate ///开始日期
	s eobj.OFCEndDate=pobj.OFCEndDate ///结束日期
	
	s eobj.OFCCreateDate=pobj.OFCCreateDate ///系统创建日期
	s eobj.OFCCreateTime=pobj.OFCCreateTime ///系统创建时间
	if $IsObject(pobj.OFCCreateUser)
	{   
		s eobj.OFCCreateUser = pobj.OFCCreateUser.%Id()   ///系统创建人
	}
	s eobj.OFCSeqNo=pobj.OFCSeqNo ///系统排序号
	s eobj.OFCLastUpdateDate=pobj.OFCLastUpdateDate ///系统最后更新日期
	s eobj.OFCLastUpdateTime=pobj.OFCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.OFCLastUpdateUser)
	{   
		s eobj.OFCLastUpdateUser = pobj.OFCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.OFCPYCode=pobj.OFCPYCode ///拼音码
	s eobj.OFCWBCode=pobj.OFCWBCode ///五笔码
	s eobj.OFCMark=pobj.OFCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSOrgFinCategory).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgFinCategory","CT.BDP.CT.HOSOrgFinCategory","机构小类",id,eobj.OFCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("机构小类","web.DHCBL.CT.HOSOrgFinCategory","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	 
	else
	q result
}

}

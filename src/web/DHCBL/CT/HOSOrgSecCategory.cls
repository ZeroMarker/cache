/// Function: 机构分类中类
/// Table：CT_BDP_CT.HOS_OrgSecCategory
/// CreateDate:2022-11-24
/// Creator:lujunwen
Class web.DHCBL.CT.HOSOrgSecCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-24
/// Description：机构分类中类查询
/// Table：CT_BDP_CT.HOS_OrgSecCategory
/// input id code(机构分类中类代码) desc(机构分类中类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgSecCategory","GetList","1","","","") 
Query GetList(parref As %String, id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OSCCode:%String,OSCDesc:%String,OSCSource:%String,OSCActivity:%String,OSCStartDate:%Date,OSCEndDate:%Date,OSCSeqNo:%Float,OSCPYCode:%String,OSCWBCode:%String,OSCMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ChildSub=$p(id,"||",2) //子表ID
		s ID=id //子表RowId
		s PriCategoryParRef=$p(id,"||",1) //父表ID
	    s OSCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),2) /// 机构分类中类代码
	    s OSCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),3) /// 机构分类中类名称
	    s OSCSource=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),4) ///分类来源
		s OSCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),5) ///是否有效
		s OSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),6) ///开始日期
		s OSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),7) //结束日期
	    s:OSCStartDate'="" OSCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OSCStartDate) ///转日期格式
	    s:OSCEndDate'="" OSCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OSCEndDate)	///转日期格式		
		s OSCSeqNo=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),11) ///系统排序号	
		s OSCPYCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),15) ///拼音码
		s OSCWBCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),16) ///五笔码
		s OSCMark=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),17) ///备注
	    d OutputRow
	}
	else
	{
		s ChildSub=0
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		for 
		{
			s ChildSub=$o(^CT.BDP.CT.HOSOrgPriCategoryD(parref,"ChildOrgSecCategory",ChildSub)) q:ChildSub=""
			s ID=parref_"||"_ChildSub //子表RowId
			s PriCategoryParRef=parref ///父表ID
		    s OSCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),2) /// 机构分类中类代码
		    s OSCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),3) /// 机构分类中类名称
		    s OSCSource=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),4) ///分类来源
			s OSCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),5) ///是否有效
			s OSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),6) ///开始日期
			s OSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),7) //结束日期
		    s:OSCStartDate'="" OSCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OSCStartDate) ///转日期格式
		    s:OSCEndDate'="" OSCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OSCEndDate)	///转日期格式		
			s OSCSeqNo=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),11) ///系统排序号
			s OSCPYCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),15) ///拼音码
			s OSCWBCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),16) ///五笔码
			s OSCMark=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),17) ///备注	        
	    	if ($ZCONVERT(OSCCode,"U")[code)&(($ZCONVERT(OSCDesc,"U")[desc)||($ZCONVERT(OSCPYCode,"U")[desc))
	    	{
	            d OutputRow
	    	} 
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,OSCCode,OSCDesc,OSCSource,OSCActivity,OSCStartDate,OSCEndDate,OSCSeqNo,OSCPYCode,OSCWBCode,OSCMark)
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
/// CreateDate:2022-11-24
/// Description：为combox提供下拉数据
/// Table：CT_BDP_CT.HOS_OrgSecCategory
/// input:parref(父表id) id code(机构分类中类代码) desc(机构分类中类名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgSecCategory","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OSCCode:%String,OSCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ChildSub=$p(id,"||",2) //子表ID
		s ID=id //子表RowId
		s PriCategoryParRef=$p(id,"||",1) //父表ID
	    s OSCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),2) /// 机构分类中类代码
	    s OSCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),3) /// 机构分类中类名称
		s OSCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),5) ///是否有效
		s OSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),6) ///开始日期
		s OSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),7) //结束日期
	    d OutputRowCmb
	}
	else
	{		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
			s PriCategoryParRef=0
			for
			{
				s PriCategoryParRef=$o(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef)) q:PriCategoryParRef=""	
				s ChildSub=0
				for 
				{
					s ChildSub=$o(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)) q:ChildSub=""
					s ID=PriCategoryParRef_"||"_ChildSub //子表RowId		
				    s OSCCode=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),2) /// 机构分类中类代码
				    s OSCDesc=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),3) /// 机构分类中类名称
					s OSCActivity=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),5) ///是否有效
					continue:OSCActivity="N"
					s OSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),6) ///开始日期
					continue:(OSCStartDate'="")&&(OSCStartDate>+$h)
					s OSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",ChildSub)),7) //结束日期				
					continue:(OSCEndDate'="")&&(OSCEndDate<+$h)					
			        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OSCDesc)
			    	if (($ZCONVERT(OSCDesc,"U")[desc)||(PINYIN[desc))
			    	{
			            d OutputRowCmb
			    	} 
				}
			}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,OSCCode,OSCDesc)
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
/// CreatDate:  2022-11-24
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// debug: w ##class(web.DHCBL.CT.HOSOrgSecCategory).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.HOSOrgSecCategory).%New()
	s obj = ##class(CT.BDP.CT.HOSOrgSecCategory).%OpenId(id)
	s eobj.ID=id //RowId
	s eobj.PriCategoryParRef=$P(id,"||",1) //PriCategoryParRef
	s eobj.OSCCode=obj.OSCCode /// 机构分类中类代码
	s eobj.OSCDesc=obj.OSCDesc /// 机构分类中类名称
	s eobj.OSCSource=obj.OSCSource /// 分类来源
	s eobj.OSCActivity=obj.OSCActivity /// 是否有效(Y/N)
	s eobj.OSCStartDate= obj.OSCStartDate  //开始日期
	s eobj.OSCEndDate= obj.OSCEndDate    //结束日期
	s eobj.OSCSeqNo= obj.OSCSeqNo    /// 系统排序号
	s eobj.OSCPYCode= obj.OSCPYCode   /// 拼音码
	s eobj.OSCWBCode= obj.OSCWBCode   /// 五笔码
	s eobj.OSCMark= obj.OSCMark    /// 备注
	s:eobj.OSCStartDate'="" eobj.OSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.OSCStartDate) //转日期格式
	s:eobj.OSCStartDate'="" eobj.OSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.OSCStartDate)       //转日期格式
	s str = eobj.JsonS()    
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-24
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_OrgSecCategory
/// Input：id(子表RowId右部),code(代码),desc(描述)
/// Others：w ##class(web.DHCBL.CT.HOSOrgSecCategory).FormValidate("","","","")
ClassMethod FormValidate(pricategoryparref As %String, id As %String, code As %String, desc As %String) As %String
{
	s flag=0	
	if (code'="")
	{
		s ChildSub=$o(^CT.BDP.CT.HOSOrgSecCategoryI("IndexParRefCode",pricategoryparref," "_$ZCONVERT(code,"U"),0))
		if (ChildSub'="")
		{
		s ID=pricategoryparref_"||"_ChildSub
		
			if (ID'="")&&(id'=ID)
			{	
				s flag=1
			}
		}	

	}

	if (desc'="")
	{
		s ChildSub=$o(^CT.BDP.CT.HOSOrgSecCategoryI("IndexParRefDesc",pricategoryparref," "_$ZCONVERT(desc,"U"),0))
		if (ChildSub'="")
		{
		s ID=pricategoryparref_"||"_ChildSub
		
			if (ID'="")&&(id'=ID)
			{	
				s flag=1
			}
		}			
		
	}	
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月14日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSOrgSecCategory).savetest()
ClassMethod savetest()
{
	
	s eobj=##class(web.Entity.CT.HOSOrgSecCategory).%New()
	s eobj.PriCategoryParRef="1"
	s eobj.OSCCode="003"  /// 机构分类中类代码
	s eobj.OSCDesc="测试3" ///机构分类中类名称
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-24
/// Description：保存机构分类中类代码 
/// Table：CT_BDP_CT.HOS_OrgSecCategory
/// Others：w ##class(web.DHCBL.CT.HOSOrgSecCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgSecCategory) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OSCStartDate'="" eobj.OSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OSCStartDate)	//开始日期
	    s:eobj.OSCEndDate'="" eobj.OSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OSCEndDate)	//结束日期
		s:eobj.OSCStartDate="" eobj.OSCStartDate=+$h
		s:eobj.OSCActivity="" eobj.OSCActivity="N"
	    s flag=..FormValidate(eobj.PriCategoryParRef,eobj.ID,eobj.OSCCode,eobj.OSCDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.OSCCreateUser="") s eobj.OSCCreateUser=USERID   ///系统创建人
			if (eobj.OSCLastUpdateUser="") s eobj.OSCLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSOrgSecCategory).%New(eobj.PriCategoryParRef)
			d obj.OSCLastUpdateUserSetObjectId(eobj.OSCLastUpdateUser)  ///系统创建人
			s obj.OSCCreateDate=+$H           ///系统创建日期
			s obj.OSCCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSOrgSecCategory).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSOrgSecCategory).%New()			
			s bobj.OSCCode=obj.OSCCode /// 机构分类中类代码
			s bobj.OSCDesc=obj.OSCDesc ///机构分类中类名称
			s bobj.OSCSource=obj.OSCSource /// 分类来源
			s bobj.OSCActivity=obj.OSCActivity ///是否有效	
			s bobj.OSCStartDate=obj.OSCStartDate ///开始日期
			s bobj.OSCEndDate=obj.OSCEndDate ///结束日期
			s bobj.OSCCreateDate=obj.OSCCreateDate ///系统创建日期
			s bobj.OSCCreateTime=obj.OSCCreateTime ///系统创建时间
			if $IsObject(obj.OSCCreateUser)
			{   
				s bobj.OSCCreateUser = obj.OSCCreateUser.%Id()   ///系统创建人
			}
			s bobj.OSCSeqNo=obj.OSCSeqNo ///系统排序号
			
			s bobj.OSCLastUpdateDate=obj.OSCLastUpdateDate ///系统最后更新日期
			s bobj.OSCLastUpdateTime=obj.OSCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.OSCLastUpdateUser)
			{   
				s bobj.OSCLastUpdateUser = obj.OSCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.OSCPYCode=obj.OSCPYCode ///拼音码
			s bobj.OSCWBCode=obj.OSCWBCode ///五笔码
			s bobj.OSCMark=obj.OSCMark ///备注
		}
		
		d:eobj.PriCategoryParRef'="" obj.PriCategoryParRefSetObjectId(eobj.PriCategoryParRef) //修改数据时ParRef为空
		s obj.OSCCode=eobj.OSCCode ///机构分类中类代码
		s obj.OSCDesc=eobj.OSCDesc ///机构分类中类名称
		s obj.OSCSource=eobj.OSCSource /// 分类来源
		s obj.OSCActivity=eobj.OSCActivity	///是否有效
		s obj.OSCStartDate= eobj.OSCStartDate    ///开始日期
	    s obj.OSCEndDate= eobj.OSCEndDate 	///结束日期
		s obj.OSCSeqNo=eobj.OSCSeqNo ///系统排序号
		s obj.OSCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s obj.OSCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		d obj.OSCLastUpdateUserSetObjectId(eobj.OSCLastUpdateUser)  ///系统最新更新人
		s:eobj.OSCPYCode="" eobj.OSCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.OSCDesc,4) ///自动生成拼音码
		s obj.OSCPYCode=eobj.OSCPYCode ///拼音码
		s:eobj.OSCWBCode="" eobj.OSCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.OSCDesc,1) ///自动生成五笔码
		s obj.OSCWBCode=eobj.OSCWBCode ///五笔码
		s obj.OSCMark=eobj.OSCMark ///备注
		s obj.OSCStartDate= eobj.OSCStartDate	//开始日期
		s obj.OSCStartDate= eobj.OSCStartDate		//结束日期
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSecCategory","CT.BDP.CT.HOSOrgSecCategory","机构分类中类",eobj.ID,eobj.OSCDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSecCategory","CT.BDP.CT.HOSOrgSecCategory","机构分类中类",id,eobj.OSCDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("机构分类中类","web.DHCBL.CT.HOSOrgSecCategory","DeleteData",eobj)
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
	s ChildSub=0
	s PriCategoryParRef=$p(id,"||",1)
	s SecCategoryParRef=$p(id,"||",2)
	for{
		s ChildSub=$o(^CT.BDP.CT.HOSOrgPriCategoryD(PriCategoryParRef,"ChildOrgSecCategory",SecCategoryParRef,"ChildOrgFinCategory",ChildSub)) q:ChildSub=""
		s ID=PriCategoryParRef_"||"_SecCategoryParRef_"||"_ChildSub
		
		if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGFCCode",ID)){
			s myInfo=myInfo_"<组织机构树>"
		}	
		i myInfo="" s return="0^未被引用可删除！"
		else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	}	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-24
/// Description：根据ID删除机构分类中类代码的内容
/// Table：CT_BDP_CT.HOS_OrgSecCategory
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgSecCategory).DeleteData("3||7")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSOrgSecCategory).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		
	s pobj = ##class(CT.BDP.CT.HOSOrgSecCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSOrgSecCategory).%New()
	s eobj.OSCCode=pobj.OSCCode ///机构分类中类代码
	s eobj.OSCDesc=pobj.OSCDesc ///机构分类中类名称
	s eobj.OSCSource=pobj.OSCSource ///分类来源
	s eobj.OSCActivity=pobj.OSCActivity ///是否有效		
	s eobj.OSCStartDate=pobj.OSCStartDate ///开始日期
	s eobj.OSCEndDate=pobj.OSCEndDate ///结束日期
	
	s eobj.OSCCreateDate=pobj.OSCCreateDate ///系统创建日期
	s eobj.OSCCreateTime=pobj.OSCCreateTime ///系统创建时间
	if $IsObject(pobj.OSCCreateUser)
	{   
		s eobj.OSCCreateUser = pobj.OSCCreateUser.%Id()   ///系统创建人
	}
	s eobj.OSCSeqNo=pobj.OSCSeqNo ///系统排序号
	s eobj.OSCLastUpdateDate=pobj.OSCLastUpdateDate ///系统最后更新日期
	s eobj.OSCLastUpdateTime=pobj.OSCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.OSCLastUpdateUser)
	{   
		s eobj.OSCLastUpdateUser = pobj.OSCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.OSCPYCode=pobj.OSCPYCode ///拼音码
	s eobj.OSCWBCode=pobj.OSCWBCode ///五笔码
	s eobj.OSCMark=pobj.OSCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSOrgSecCategory).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSecCategory","CT.BDP.CT.HOSOrgSecCategory","机构分类中类代码",id,eobj.OSCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("机构分类中类代码","web.DHCBL.CT.HOSOrgSecCategory","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	
	q result
}

}

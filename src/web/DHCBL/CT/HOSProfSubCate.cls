/// Function: 职务子类代码
/// Table：CT_BDP_CT.HOS_ProfSubCate
/// CreateDate:2022-11-14
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfSubCate Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-14
/// Description：职务子类代码查询
/// Table：CT_BDP_CT.HOS_ProfSubCate
/// input id code(职务子类代码) desc(职务子类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfSubCate","GetList","4","","","") 
Query GetList(parref As %String, id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFSCCode:%String,PROFSCDesc:%String,PROFSCSource:%String,PROFSCActivity:%String,PROFSCStartDate:%Date,PROFSCEndDate:%Date,PROFSCSeqNo:%Float,PROFSCPYCode:%String,PROFSCWBCode:%String,PROFSCMark:%String")
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
		s CategoryParRef=$p(id,"||",1) //父表ID
	    s PROFSCCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),2) /// 职务子类代码
	    s PROFSCDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),3) /// 职务子类名称
	    s PROFSCSource=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),4) ///分类来源
		s PROFSCActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),5) ///是否有效
		s PROFSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),6) ///开始日期
		s PROFSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),7) //结束日期
	    s:PROFSCStartDate'="" PROFSCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSCStartDate) ///转日期格式
	    s:PROFSCEndDate'="" PROFSCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSCEndDate)	///转日期格式		
		s PROFSCSeqNo=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),11) ///系统排序号	
		s PROFSCPYCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),15) ///拼音码
		s PROFSCWBCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),16) ///五笔码
		s PROFSCMark=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),17) ///备注
	    d OutputRow
	}
	else
	{
		s ChildSub=0
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		for 
		{
			s ChildSub=$o(^CT.BDP.CT.HOSProfCategoryD(parref,"ChildSubCate",ChildSub)) q:ChildSub=""
			s ID=parref_"||"_ChildSub //子表RowId
			s CategoryParRef=parref ///父表ID
			
		    s PROFSCCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),2) /// 职务子类代码
		    s PROFSCDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),3) /// 职务子类名称
		    s PROFSCSource=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),4) ///分类来源
			s PROFSCActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),5) ///是否有效
			s PROFSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),6) ///开始日期
			s PROFSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),7) //结束日期
		    s:PROFSCStartDate'="" PROFSCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSCStartDate) ///转日期格式
		    s:PROFSCEndDate'="" PROFSCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSCEndDate)	///转日期格式		
			s PROFSCSeqNo=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),11) ///系统排序号
			s PROFSCPYCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),15) ///拼音码
			s PROFSCWBCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),16) ///五笔码
			s PROFSCMark=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),17) ///备注
	        
	    	if ($ZCONVERT(PROFSCCode,"U")[code)&(($ZCONVERT(PROFSCDesc,"U")[desc)||($ZCONVERT(PROFSCPYCode,"U")[desc))
	    	{
	            d OutputRow
	    	} 
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFSCCode,PROFSCDesc,PROFSCSource,PROFSCActivity,PROFSCStartDate,PROFSCEndDate,PROFSCSeqNo,PROFSCPYCode,PROFSCWBCode,PROFSCMark)
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
/// CreateDate:2022-11-14
/// Description：为combox提供下拉数据
/// Table：CT_BDP_CT.HOS_ProfSubCate
/// input:parref(父表id) id code(职务子类代码) desc(职务子类名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfSubCate","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFSCCode:%String,PROFSCDesc:%String")
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
		s CategoryParRef=$p(id,"||",1) //父表ID
	    s PROFSCCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),2) /// 职务子类代码
	    s PROFSCDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),3) /// 职务子类名称
		s PROFSCActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),5) ///是否有效		
		s PROFSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),6) ///开始日期
		s PROFSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),7) //结束日期	
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写		
		s CategoryParRef=0
		for 
		{
			s CategoryParRef=$o(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef)) q:CategoryParRef=""
			s ChildSub=0
			for
			{					
				s ChildSub=$o(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)) q:ChildSub=""
				s ID=CategoryParRef_"||"_ChildSub //子表RowId			
			    s PROFSCCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),2) /// 职务子类代码
			    s PROFSCDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),3) /// 职务子类名称
				s PROFSCActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),5) ///是否有效
				continue:PROFSCActivity="N"
				s PROFSCStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),6) ///开始日期
				continue:(PROFSCStartDate'="")&&(PROFSCStartDate>+$h)
				s PROFSCEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ChildSub)),7) //结束日期
				continue:(PROFSCEndDate'="")&&(PROFSCEndDate<+$h)	
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFSCDesc)		        
		    	if ($ZCONVERT(PROFSCCode,"U")[code)&(($ZCONVERT(PROFSCDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PROFSCCode,PROFSCDesc)
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
/// CreatDate:  2022-11-14
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// debug: w ##class(web.DHCBL.CT.HOSProfSubCate).OpenData("4||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.HOSProfSubCate).%New()
	s obj = ##class(CT.BDP.CT.HOSProfSubCate).%OpenId(id)
	s eobj.ID=id //RowId
	s eobj.CategoryParRef=$P(id,"||",1) //CategoryParRef
	s eobj.PROFSCCode=obj.PROFSCCode /// 职务子类代码
	s eobj.PROFSCDesc=obj.PROFSCDesc /// 职务子类名称
	s eobj.PROFSCSource=obj.PROFSCSource /// 分类来源
	s eobj.PROFSCActivity=obj.PROFSCActivity /// 是否有效(Y/N)
	s eobj.PROFSCStartDate= obj.PROFSCStartDate  //开始日期
	s eobj.PROFSCEndDate= obj.PROFSCEndDate    //结束日期
	s eobj.PROFSCSeqNo= obj.PROFSCSeqNo    /// 系统排序号
	s eobj.PROFSCPYCode= obj.PROFSCPYCode   /// 拼音码
	s eobj.PROFSCWBCode= obj.PROFSCWBCode   /// 五笔码
	s eobj.PROFSCMark= obj.PROFSCMark    /// 备注
	s:eobj.PROFSCStartDate'="" eobj.PROFSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.PROFSCStartDate) //转日期格式
	s:eobj.PROFSCStartDate'="" eobj.PROFSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.PROFSCStartDate)       //转日期格式
	s str = eobj.JsonS()    
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-14
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_ProfSubCate
/// Input：id(子表RowId右部),code(代码),desc(描述)
/// Others：w ##class(web.DHCBL.CT.HOSProfSubCate).FormValidate("","","","")
ClassMethod FormValidate(categoryparref As %String, id As %String, code As %String, desc As %String) As %String
{
	s flag=0	
	if (code'="")
	{
		s ChildSub=$o(^CT.BDP.CT.HOSProfSubCateI("IndexParRefCode",categoryparref," "_$ZCONVERT(code,"U"),0))
		if (ChildSub'="")
		{
		s ID=categoryparref_"||"_ChildSub
		
			if (ID'="")&&(id'=ID)
			{	
				s flag=1
				b //1
			}
		}	

	}

	if (desc'="")
	{
		s ChildSub=$o(^CT.BDP.CT.HOSProfSubCateI("IndexParRefDesc",categoryparref," "_$ZCONVERT(desc,"U"),0))
		if (ChildSub'="")
		{
		s ID=categoryparref_"||"_ChildSub
		
			if (ID'="")&&(id'=ID)
			{	
				s flag=1
				b //1
			}
		}			
		
	}	
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月14日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSProfSubCate).savetest()
ClassMethod savetest()
{
	
	s eobj=##class(web.Entity.CT.HOSProfSubCate).%New()
	s eobj.CategoryParRef="4"
	s eobj.PROFSCCode="002"  /// 职务子类代码
	s eobj.PROFSCDesc="网络类" ///职务子类名称
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-14
/// Description：保存职务子类代码 
/// Table：CT_BDP_CT.HOS_ProfSubCate
/// Others：w ##class(web.DHCBL.CT.HOSProfSubCate).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfSubCate) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFSCStartDate'="" eobj.PROFSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFSCStartDate)	//开始日期
	    s:eobj.PROFSCEndDate'="" eobj.PROFSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFSCEndDate)	//结束日期
		s:eobj.PROFSCStartDate="" eobj.PROFSCStartDate=+$h
		s:eobj.PROFSCActivity="" eobj.PROFSCActivity="N"
	    s flag=..FormValidate(eobj.CategoryParRef,eobj.ID,eobj.PROFSCCode,eobj.PROFSCDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFSCCreateUser="") s eobj.PROFSCCreateUser=USERID   ///系统创建人
			if (eobj.PROFSCLastUpdateUser="") s eobj.PROFSCLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProfSubCate).%New(eobj.CategoryParRef)
			d obj.PROFSCLastUpdateUserSetObjectId(eobj.PROFSCLastUpdateUser)  ///系统创建人
			s obj.PROFSCCreateDate=+$H           ///系统创建日期
			s obj.PROFSCCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfSubCate).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfSubCate).%New()			
			s bobj.PROFSCCode=obj.PROFSCCode /// 职务子类代码
			s bobj.PROFSCDesc=obj.PROFSCDesc ///职务子类名称
			s bobj.PROFSCSource=obj.PROFSCSource /// 分类来源
			s bobj.PROFSCActivity=obj.PROFSCActivity ///是否有效	
			s bobj.PROFSCStartDate=obj.PROFSCStartDate ///开始日期
			s bobj.PROFSCEndDate=obj.PROFSCEndDate ///结束日期
			s bobj.PROFSCCreateDate=obj.PROFSCCreateDate ///系统创建日期
			s bobj.PROFSCCreateTime=obj.PROFSCCreateTime ///系统创建时间
			if $IsObject(obj.PROFSCCreateUser)
			{   
				s bobj.PROFSCCreateUser = obj.PROFSCCreateUser.%Id()   ///系统创建人
			}
			s bobj.PROFSCSeqNo=obj.PROFSCSeqNo ///系统排序号
			
			s bobj.PROFSCLastUpdateDate=obj.PROFSCLastUpdateDate ///系统最后更新日期
			s bobj.PROFSCLastUpdateTime=obj.PROFSCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFSCLastUpdateUser)
			{   
				s bobj.PROFSCLastUpdateUser = obj.PROFSCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFSCPYCode=obj.PROFSCPYCode ///拼音码
			s bobj.PROFSCWBCode=obj.PROFSCWBCode ///五笔码
			s bobj.PROFSCMark=obj.PROFSCMark ///备注
		}
		
		d:eobj.CategoryParRef'="" obj.CategoryParRefSetObjectId(eobj.CategoryParRef) //修改数据时ParRef为空
		s obj.PROFSCCode=eobj.PROFSCCode ///职务子类代码
		s obj.PROFSCDesc=eobj.PROFSCDesc ///职务子类名称
		s obj.PROFSCSource=eobj.PROFSCSource /// 分类来源
		s obj.PROFSCActivity=eobj.PROFSCActivity	///是否有效
		s obj.PROFSCStartDate= eobj.PROFSCStartDate    ///开始日期
	    s obj.PROFSCEndDate= eobj.PROFSCEndDate 	///结束日期
		s obj.PROFSCSeqNo=eobj.PROFSCSeqNo ///系统排序号
		s obj.PROFSCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s obj.PROFSCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		d obj.PROFSCLastUpdateUserSetObjectId(eobj.PROFSCLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFSCPYCode="" eobj.PROFSCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFSCDesc,4) ///自动生成拼音码
		s obj.PROFSCPYCode=eobj.PROFSCPYCode ///拼音码
		s:eobj.PROFSCWBCode="" eobj.PROFSCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFSCDesc,1) ///自动生成五笔码
		s obj.PROFSCWBCode=eobj.PROFSCWBCode ///五笔码
		s obj.PROFSCMark=eobj.PROFSCMark ///备注
		s obj.PROFSCStartDate= eobj.PROFSCStartDate	//开始日期
		s obj.PROFSCStartDate= eobj.PROFSCStartDate		//结束日期
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfSubCate","CT.BDP.CT.HOSProfSubCate","职务子类代码",eobj.ID,eobj.PROFSCDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfSubCate","CT.BDP.CT.HOSProfSubCate","职务子类代码",id,eobj.PROFSCDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务子类代码","web.DHCBL.CT.HOSProfSubCate","DeleteData",eobj)
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
/// CreatDate:2022-11-11
/// Description：根据ID删除职务子类代码的内容
/// Table：CT_BDP_CT.HOS_ProfSubCate
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfSubCate).DeleteData("4||2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s pobj = ##class(CT.BDP.CT.HOSProfSubCate).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfSubCate).%New()
	s eobj.PROFSCCode=pobj.PROFSCCode ///职务子类代码
	s eobj.PROFSCDesc=pobj.PROFSCDesc ///职务子类名称
	s eobj.PROFSCSource=pobj.PROFSCSource ///分类来源
	s eobj.PROFSCActivity=pobj.PROFSCActivity ///是否有效		
	s eobj.PROFSCStartDate=pobj.PROFSCStartDate ///开始日期
	s eobj.PROFSCEndDate=pobj.PROFSCEndDate ///结束日期
	
	s eobj.PROFSCCreateDate=pobj.PROFSCCreateDate ///系统创建日期
	s eobj.PROFSCCreateTime=pobj.PROFSCCreateTime ///系统创建时间
	if $IsObject(pobj.PROFSCCreateUser)
	{   
		s eobj.PROFSCCreateUser = pobj.PROFSCCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFSCSeqNo=pobj.PROFSCSeqNo ///系统排序号
	s eobj.PROFSCLastUpdateDate=pobj.PROFSCLastUpdateDate ///系统最后更新日期
	s eobj.PROFSCLastUpdateTime=pobj.PROFSCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFSCLastUpdateUser)
	{   
		s eobj.PROFSCLastUpdateUser = pobj.PROFSCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFSCPYCode=pobj.PROFSCPYCode ///拼音码
	s eobj.PROFSCWBCode=pobj.PROFSCWBCode ///五笔码
	s eobj.PROFSCMark=pobj.PROFSCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfSubCate).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfSubCate","CT.BDP.CT.HOSProfSubCate","职务子类代码",id,eobj.PROFSCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务子类代码","web.DHCBL.CT.HOSProfSubCate","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

}

/// Function: 职务专业代码
/// Table：CT_BDP_CT.HOS_ProfMajor
/// CreateDate:2022-11-15
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfMajor Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-15
/// Description：职务专业代码信息查询
/// Table：CT_BDP_CT.HOS_ProfMajor
/// input id code(职务专业代码) desc(职务专业名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfMajor","GetList","4||1","","","") 
Query GetList(parref As %String, id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFMCode:%String,PROFMDesc:%String,PROFMSource:%String,PROFMActivity:%String,PROFMStartDate:%Date,PROFMEndDate:%Date,PROFMSeqNo:%Float,PROFMPYCode:%String,PROFMWBCode:%String,PROFMMark:%String")
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
		s CategoryParRef=$p(id,"||",1) //父表父ID
		s SubCateParRef=$p(id,"||",1,2) //父表ID
		s ParRef=$p(id,"||",2)
	    s PROFMCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),2) /// 职务专业代码
	    s PROFMDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),3) /// 职务专业名称
	    s PROFMSource=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),4) /// 分类来源
	    s PROFMActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),5) /// 是否有效	    
	    s PROFMStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),6) /// 开始日期	        
		s PROFMEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),7) //结束日期
	    s:PROFMStartDate'="" PROFMStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFMStartDate) ///转日期格式
	    s:PROFMEndDate'="" PROFMEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFMEndDate)	///转日期格式
		s PROFMSeqNo=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),11) ///系统排序号
		s PROFMPYCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),15) ///拼音码
		s PROFMWBCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),16) ///五笔码
		s PROFMMark=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),17) ///备注
	    d OutputRow
	}
	else
	{
		s ChildSub=0
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s CategoryParRef=$p(parref,"||",1) //父表父ID
	    s SubCateParRef=$p(parref,"||",1,2) //父表ID
	    s ParRef=$p(parref,"||",2)
		for 
		{
			s ChildSub=$o(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)) q:ChildSub=""
			s ID=parref_"||"_ChildSub //子表RowId
			s ParRef=$p(parref,"||",2) 
			s CategoryParRef=$p(parref,"||",1) //父表父ID
		    s PROFMCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),2) /// 职务专业代码
		    s PROFMDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),3) /// 职务专业名称
		    s PROFMSource=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),4) /// 分类来源
		    s PROFMActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),5) /// 是否有效	    
		    s PROFMStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),6) /// 开始日期	        
			s PROFMEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),7) //结束日期
		    s:PROFMStartDate'="" PROFMStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFMStartDate) ///转日期格式
		    s:PROFMEndDate'="" PROFMEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFMEndDate)	///转日期格式
			s PROFMSeqNo=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),11) ///系统排序号	
			s PROFMPYCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),15) ///拼音码
			s PROFMWBCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),16) ///五笔码
			s PROFMMark=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),17) ///备注
	    	if ($ZCONVERT(PROFMCode,"U")[code)&(($ZCONVERT(PROFMDesc,"U")[desc)||($ZCONVERT(PROFMPYCode,"U")[desc))
	    	{
	            d OutputRow
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFMCode,PROFMDesc,PROFMSource,PROFMActivity,PROFMStartDate,PROFMEndDate,PROFMSeqNo,PROFMPYCode,PROFMWBCode,PROFMMark)
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
/// CreateDate:2022-11-15
/// Description：为combox提供下拉数据
/// Table：CT_BDP_CT.HOS_ProfMajor
/// input:parref(父表id) id code(职务专业代码) desc(职务专业名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfMajor","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFMCode:%String,PROFMDesc:%String")
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
	    s CategoryParRef=$p(id,"||",1) //父表父ID
	    s SubCateParRef=$p(id,"||",1,2) //父表ID
	    s ParRef=$p(id,"||",2)
	    s PROFCDesc=$lg($g(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef)),3) /// 职务大类名称
	    s PROFSCDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef)),3) /// 职务子类名称
	    s PROFMCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),2) /// 职务专业代码
	    s PROFMDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),3) /// 职务专业名称
	    s PROFMDesc=PROFCDesc_"-"_PROFSCDesc_"-"_PROFMDesc    
	    s PROFMActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),5) /// 是否有效	    
	    s PROFMStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),6) /// 开始日期	        
		s PROFMEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),7) //结束日期
	    d OutputRowCmb
	}
	else
	{	s:desc'="" desc=$ZCONVERT(desc,"U")
		s CategoryParRef=0
		for
		{	
			s CategoryParRef=$o(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef)) q:CategoryParRef=""
			s PROFCDesc=$lg($g(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef)),3) /// 职务大类名称
			s ParRef=0
			for
			{	
				s ParRef=$o(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef)) q:ParRef=""
				s PROFSCDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef)),3) /// 职务子类名称
				s ChildSub=0
				for 
				{	
					s ChildSub=$o(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)) q:ChildSub=""
					s PROFMDesc=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),3) /// 职务专业名称
					s PROFMDesc=PROFCDesc_"-"_PROFSCDesc_"-"_PROFMDesc
					s ID=CategoryParRef_"||"_ParRef_"||"_ChildSub			    					
				    s PROFMCode=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),2) /// 职务专业代码
				    s PROFMActivity=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),5) /// 是否有效
	    			continue:PROFMActivity="N"
				    s PROFMStartDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),6) /// 开始日期
				    continue:(PROFMStartDate'="")&&(PROFMStartDate>+$h)	        
					s PROFMEndDate=$LISTGET($G(^CT.BDP.CT.HOSProfCategoryD(CategoryParRef,"ChildSubCate",ParRef,"ChildMajor",ChildSub)),7) //结束日期
					continue:(PROFMEndDate'="")&&(PROFMEndDate<+$h)
					s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFMDesc)
					if (($ZCONVERT(PROFMDesc,"U")[desc)||(PINYIN[desc))
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
	set Data=$lb(ID,PROFMCode,PROFMDesc)
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
/// CreatDate:  2022-11-15
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// debug: w ##class(web.DHCBL.CT.HOSProfMajor).OpenData("4||1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.HOSProfMajor).%New()
	s obj = ##class(CT.BDP.CT.HOSProfMajor).%OpenId(id)
	s eobj.ID=id //RowId
	s eobj.SubCateParRef=$P(id,"||",1,2) //SubCateParRef
	s eobj.PROFMCode=obj.PROFMCode /// 职务专业代码
	s eobj.PROFMDesc=obj.PROFMDesc /// 职务专业名称
	s eobj.PROFMSource=obj.PROFMSource /// 分类来源
	s eobj.PROFMActivity=obj.PROFMActivity /// 是否有效(Y/N)
	s eobj.PROFMStartDate= obj.PROFMStartDate  //开始日期
	s eobj.PROFMEndDate= obj.PROFMEndDate    //结束日期
	s eobj.PROFMSeqNo= obj.PROFMSeqNo    /// 系统排序号
	s eobj.PROFMPYCode= obj.PROFMPYCode   /// 拼音码
	s eobj.PROFMWBCode= obj.PROFMWBCode   /// 五笔码
	s eobj.PROFMMark= obj.PROFMMark    /// 备注
	s:eobj.PROFMStartDate'="" eobj.PROFMStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.PROFMStartDate) //转日期格式
	s:eobj.PROFMStartDate'="" eobj.PROFMStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.PROFMStartDate)       //转日期格式
	s str = eobj.JsonS()    
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-15
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_OrgFinCategory
/// Input：id(子表RowId右部),code(代码),desc(描述)
/// Others：w ##class(web.DHCBL.CT.HOSProfMajor).FormValidate("4||10","","003","胸透")
ClassMethod FormValidate(subcateparref As %String, id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	s CategoryParRef=$p(subcateparref,"||",1)
	s ParRef=$p(subcateparref,"||",2)
	b //1
	if (code'="")
	{	
		s ChildSub=$o(^CT.BDP.CT.HOSProfMajorI("IndexParRefCode",CategoryParRef,ParRef," "_$ZCONVERT(code,"U"),0))
		if (ChildSub'="")
		{
			s ID=CategoryParRef_"||"_ParRef_"||"_ChildSub
			if (ID'="")&&(id'=ID)
			{	
				s flag=1
			}			
	
		}	
	
	}
	
	if (desc'="")
	{	
		s ChildSub=$o(^CT.BDP.CT.HOSProfMajorI("IndexParRefDesc",CategoryParRef,ParRef," "_$ZCONVERT(desc,"U"),0))
		
		if (ChildSub'="")
		{
			s ID=CategoryParRef_"||"_ParRef_"||"_ChildSub
			
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
/// debug：d ##class(web.DHCBL.CT.HOSProfMajor).savetest()
ClassMethod savetest()
{
	
	s eobj=##class(web.Entity.CT.HOSProfMajor).%New()
	s eobj.SubCateParRef="4||1"
	s eobj.PROFMCode="004"  /// 职务专业代码
	s eobj.PROFMDesc="软件工程" ///职务专业名称
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-15
/// Description：保存职务专业代码 
/// Table：CT_BDP_CT.HOS_ProfMajor
/// Others：w ##class(web.DHCBL.CT.HOSProfMajor).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfMajor) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFMStartDate'="" eobj.PROFMStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFMStartDate)	//开始日期
	    s:eobj.PROFMEndDate'="" eobj.PROFMEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFMEndDate)	//结束日期
		s:eobj.PROFMStartDate="" eobj.PROFMStartDate=+$h
		s:eobj.PROFMActivity="" eobj.PROFMActivity="N"   
	    s flag=..FormValidate(eobj.SubCateParRef,eobj.ID,eobj.PROFMCode,eobj.PROFMDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFMCreateUser="") s eobj.PROFMCreateUser=USERID   ///系统创建人
			if (eobj.PROFMLastUpdateUser="") s eobj.PROFMLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProfMajor).%New(eobj.SubCateParRef)
			d obj.PROFMLastUpdateUserSetObjectId(eobj.PROFMLastUpdateUser)  ///系统创建人
			s obj.PROFMCreateDate=+$H           ///系统创建日期
			s obj.PROFMCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfMajor).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfMajor).%New()			
			s bobj.PROFMCode=obj.PROFMCode /// 职务专业代码
			s bobj.PROFMDesc=obj.PROFMDesc ///职务专业名称
			s bobj.PROFMSource=obj.PROFMSource /// 分类来源
			s bobj.PROFMActivity=obj.PROFMActivity ///是否有效	
			s bobj.PROFMStartDate=obj.PROFMStartDate ///开始日期
			s bobj.PROFMEndDate=obj.PROFMEndDate ///结束日期
			s bobj.PROFMCreateDate=obj.PROFMCreateDate ///系统创建日期
			s bobj.PROFMCreateTime=obj.PROFMCreateTime ///系统创建时间
			if $IsObject(obj.PROFMCreateUser)
			{   
				s bobj.PROFMCreateUser = obj.PROFMCreateUser.%Id()   ///系统创建人
			}
			s bobj.PROFMSeqNo=obj.PROFMSeqNo ///系统排序号
			
			s bobj.PROFMLastUpdateDate=obj.PROFMLastUpdateDate ///系统最后更新日期
			s bobj.PROFMLastUpdateTime=obj.PROFMLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFMLastUpdateUser)
			{   
				s bobj.PROFMLastUpdateUser = obj.PROFMLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFMPYCode=obj.PROFMPYCode ///拼音码
			s bobj.PROFMWBCode=obj.PROFMWBCode ///五笔码
			s bobj.PROFMMark=obj.PROFMMark ///备注
		}
		
		d:eobj.SubCateParRef'="" obj.SubCateParRefSetObjectId(eobj.SubCateParRef) //修改数据时ParRef为空
		s obj.PROFMCode=eobj.PROFMCode ///职务专业代码
		s obj.PROFMDesc=eobj.PROFMDesc ///职务专业名称
		s obj.PROFMSource=eobj.PROFMSource /// 分类来源
		s obj.PROFMActivity=eobj.PROFMActivity	///是否有效
		s obj.PROFMStartDate= eobj.PROFMStartDate    ///开始日期
	    s obj.PROFMEndDate= eobj.PROFMEndDate 	///结束日期
		s obj.PROFMSeqNo=eobj.PROFMSeqNo ///系统排序号
		s obj.PROFMLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s obj.PROFMLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		d obj.PROFMLastUpdateUserSetObjectId(eobj.PROFMLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFMPYCode="" eobj.PROFMPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFMDesc,4) ///自动生成拼音码
		s obj.PROFMPYCode=eobj.PROFMPYCode ///拼音码
		s:eobj.PROFMWBCode="" eobj.PROFMWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFMDesc,1) ///自动生成五笔码
		s obj.PROFMWBCode=eobj.PROFMWBCode ///五笔码
		s obj.PROFMMark=eobj.PROFMMark ///备注
		s obj.PROFMStartDate= eobj.PROFMStartDate	//开始日期
		s obj.PROFMStartDate= eobj.PROFMStartDate		//结束日期
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfMajor","CT.BDP.CT.HOSrofMajor","职务专业代码",eobj.ID,eobj.PROFMDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfMajor","CT.BDP.CT.HOSrofMajor","职务专业代码",id,eobj.PROFMDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务专业代码","web.DHCBL.CT.HOSProfMajor","DeleteData",eobj)
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
	if $d(^CT.BDP.CT.HOSProfTitleI("IndexPROFMCode",id)){
		s myInfo=myInfo_"<职务代码>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-11
/// Description：根据ID删除职务子类代码的内容
/// Table：CT_BDP_CT.HOS_ProfMajor
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfMajor).DeleteData("4||1||1")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSProfMajor).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		s pobj = ##class(CT.BDP.CT.HOSProfMajor).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfMajor).%New()
	s eobj.PROFMCode=pobj.PROFMCode ///职务专业代码
	s eobj.PROFMDesc=pobj.PROFMDesc ///职务专业名称
	s eobj.PROFMSource=pobj.PROFMSource ///分类来源
	s eobj.PROFMActivity=pobj.PROFMActivity ///是否有效		
	s eobj.PROFMStartDate=pobj.PROFMStartDate ///开始日期
	s eobj.PROFMEndDate=pobj.PROFMEndDate ///结束日期
	
	s eobj.PROFMCreateDate=pobj.PROFMCreateDate ///系统创建日期
	s eobj.PROFMCreateTime=pobj.PROFMCreateTime ///系统创建时间
	if $IsObject(pobj.CTRLGCreateUser)
	{   
		s eobj.CTRLGCreateUser = pobj.CTRLGCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFMSeqNo=pobj.PROFMSeqNo ///系统排序号
	s eobj.PROFMLastUpdateDate=pobj.PROFMLastUpdateDate ///系统最后更新日期
	s eobj.PROFMLastUpdateTime=pobj.PROFMLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFMLastUpdateUser)
	{   
		s eobj.PROFMLastUpdateUser = pobj.PROFMLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFMPYCode=pobj.PROFMPYCode ///拼音码
	s eobj.PROFMWBCode=pobj.PROFMWBCode ///五笔码
	s eobj.PROFMMark=pobj.PROFMMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfMajor).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfMajor","CT.BDP.CT.HOSProfMajor","职务专业代码",id,eobj.PROFMDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务专业代码","web.DHCBL.CT.HOSProfMajor","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	
	q result
}

}

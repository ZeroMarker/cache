/// Function: 职业子类字典
/// Table：CT_BDP_CT.HOS_OccuSubCate
/// CreateDate:2022-11-14
/// Creator:lujunwen
Class web.DHCBL.CT.HOSOccuSubCate Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-10
/// Description：职业子类信息查询
/// Table：CT_BDP_CT.HOS_OccuSubCate
/// input id code(职业子类代码) desc(职业子类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOccuSubCate","GetList","1","","") 
Query GetList(id As %String, code As %String, desc As %String, occupation As %String) As %Query(ROWSPEC = "ID:%String,OCCUSCCode:%String,OCCUSCDesc:%String,OCCUSCOCCUCCode:%String,OCCUSCActivity:%String,OCCUSCStartDate:%Date,OCCUSCEndDate:%Date,OCCUSCSeqNo:%Float,OCCUSCPYCode:%String,OCCUSCWBCode:%String,OCCUSCMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String, occupation As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s OCCUSCCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),2) /// 职业子类代码
	    s OCCUSCDesc=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),3) /// 职业子类名称
	    s OCCUSCOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),4) ///职业大类指针
	    s:OCCUSCOCCUCCode'="" OCCUSCOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(OCCUSCOCCUCCode)),3) ///职业大类描述
		s OCCUSCActivity=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),5) ///是否有效
		s OCCUSCStartDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),6) ///开始日期
		s OCCUSCEndDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),7) //结束日期
	    s:OCCUSCStartDate'="" OCCUSCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUSCStartDate) ///转日期格式
	    s:OCCUSCEndDate'="" OCCUSCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUSCEndDate)	///转日期格式
		s OCCUSCSeqNo=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),11) ///系统排序号	
		s OCCUSCPYCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),15) ///拼音码
		s OCCUSCWBCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),16) ///五笔码
		s OCCUSCMark=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),17) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSOccuSubCateD(ID)) q:ID=""  ///RowID
		    s OCCUSCCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),2) /// 职业子类代码
		    s OCCUSCDesc=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),3) /// 职业子类名称
		    s OCCUSCOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),4) ///职业大类指针	    
			s OCCUSCActivity=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),5) ///是否有效
			s OCCUSCStartDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),6) ///开始日期
			s OCCUSCEndDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),7) //结束日期
		    s:OCCUSCStartDate'="" OCCUSCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUSCStartDate) ///转日期格式
		    s:OCCUSCEndDate'="" OCCUSCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OCCUSCEndDate)	///转日期格式
			s OCCUSCSeqNo=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),11) ///系统排序号
			s OCCUSCPYCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),15) ///拼音码
			s OCCUSCWBCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),16) ///五笔码
			s OCCUSCMark=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),17) ///备注
	    	if ($ZCONVERT(OCCUSCCode,"U")[code)&(($ZCONVERT(OCCUSCDesc,"U")[desc)||($ZCONVERT(OCCUSCPYCode,"U")[desc)&((occupation="")||(occupation=OCCUSCOCCUCCode)))
	    	{
		    	s:OCCUSCOCCUCCode'="" OCCUSCOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(OCCUSCOCCUCCode)),3) ///职业大类描述
	            d OutputRow
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,OCCUSCCode,OCCUSCDesc,OCCUSCOCCUCCode,OCCUSCActivity,OCCUSCStartDate,OCCUSCEndDate,OCCUSCSeqNo,OCCUSCPYCode,OCCUSCWBCode,OCCUSCMark)
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
/// CreateDate:2022-11-18
/// Description：职业子类信息查询
/// Table：CT_BDP_CT.HOS_OccuSubCate
/// input id code(职业子类) desc(职业子类名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOccuSubCate","GetDataForCmb1","1","","") 
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,OCCUSCCode:%String,OCCUSCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s OCCUSCCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),2) /// 职业子类代码
	    s OCCUSCDesc=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),3) /// 职业子类名称
		s OCCUSCActivity=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),5) ///是否有效
		s OCCUSCStartDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),6) ///开始日期
		s OCCUSCEndDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),7) //结束日期

	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSOccuSubCateD(ID)) q:ID=""  ///RowID
		    s OCCUSCCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),2) /// 职业子类代码
		    s OCCUSCDesc=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),3) /// 职业子类名称
		    s OCCUSCOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),4) ///职业大类指针
		    s:OCCUSCOCCUCCode'="" OCCUSCOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(OCCUSCOCCUCCode)),3) ///职业大类描述	    
			s OCCUSCActivity=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),5) ///是否有效
			continue:OCCUSCActivity="N"
			s OCCUSCStartDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),6) ///开始日期
			continue:(OCCUSCStartDate'="")&&(OCCUSCStartDate>+$h)
			s OCCUSCEndDate=$lg($g(^CT.BDP.CT.HOSOccuSubCateD(ID)),7) //结束日期		
			continue:(OCCUSCEndDate'="")&&(OCCUSCEndDate<+$h)			
	    	s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OCCUSCDesc)
	    	if ($ZCONVERT(OCCUSCCode,"U")[code)&(($ZCONVERT(OCCUSCDesc,"U")[desc)||(PINYIN[desc))
	    	{
	            d OutputRowCmb
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,OCCUSCCode,OCCUSCDesc)
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
/// CreatDate:  2022-10-18
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSOccuSubCate).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOccuSubCate).%New()
    s obj = ##class(CT.BDP.CT.HOSOccuSubCate).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.OCCUSCCode=obj.OCCUSCCode /// 职业子类代码
    s eobj.OCCUSCDesc=obj.OCCUSCDesc /// 职业子类名称
	if $IsObject(obj.OCCUSCOCCUCCode)
	{
		s eobj.OCCUSCOCCUCCode = obj.OCCUSCOCCUCCode.%Id()   //职业大类
	}
    s eobj.OCCUSCActivity=obj.OCCUSCActivity  ///是否有效
    s eobj.OCCUSCStartDate=obj.OCCUSCStartDate  ///开始日期
    s eobj.OCCUSCEndDate=obj.OCCUSCEndDate  ///结束日期
    s:obj.OCCUSCStartDate'="" eobj.OCCUSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OCCUSCStartDate) ///开始日期(转格式)
    s:obj.OCCUSCEndDate'="" eobj.OCCUSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OCCUSCEndDate) ///结束日期(转格式) 
    s eobj.OCCUSCPYCode=obj.OCCUSCPYCode  ///拼音码
    s eobj.OCCUSCWBCode=obj.OCCUSCWBCode  ///五笔码
    s eobj.OCCUSCMark=obj.OCCUSCMark  ///备注   
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
/// Others：w ##class(web.DHCBL.CT.HOSOccuSubCate).FormValidate("1","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSOccuSubCateI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSOccuSubCateI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}		
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月14日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.HOSOccuSubCate).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSOccuSubCate).%New()
	s eobj.OCCUSCCode="002"
	s eobj.OCCUSCDesc="教师"
	s eobj.OCCUSCOCCUCCode="1"	
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-17
/// Description：保存职业子类代码 
/// Table：CT_BDP_CT.HOS_OccuSubCate
/// Others：w ##class(web.DHCBL.CT.HOSOccuSubCate).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOccuSubCate) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OCCUSCStartDate'="" eobj.OCCUSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OCCUSCStartDate)	//开始日期
	    s:eobj.OCCUSCEndDate'="" eobj.OCCUSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OCCUSCEndDate)	//结束日期
		s:eobj.OCCUSCStartDate="" eobj.OCCUSCStartDate=+$h
		s:eobj.OCCUSCActivity="" eobj.OCCUSCActivity="N"
		s eobj.OCCUSCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.OCCUSCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
	    s flag=..FormValidate(eobj.ID,eobj.OCCUSCCode,eobj.OCCUSCDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.OCCUSCCreateUser="") s eobj.OCCUSCCreateUser=USERID   ///系统创建人
			if (eobj.OCCUSCLastUpdateUser="") s eobj.OCCUSCLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSOccuSubCate).%New()
			d obj.OCCUSCLastUpdateUserSetObjectId(eobj.OCCUSCLastUpdateUser)  ///系统创建人
			s obj.OCCUSCCreateDate=+$H           ///系统创建日期
			s obj.OCCUSCCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSOccuSubCate).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSOccuSubCate).%New()
						
			s bobj.OCCUSCCode=obj.OCCUSCCode /// 职业子类代码
			s bobj.OCCUSCDesc=obj.OCCUSCDesc ///职业子类名称
			if $IsObject(obj.OCCUSCOCCUCCode){
			s bobj.OCCUSCOCCUCCode = obj.OCCUSCOCCUCCode.%Id()   //职业大类
			}
			s bobj.OCCUSCActivity=obj.OCCUSCActivity ///是否有效	
			s bobj.OCCUSCStartDate=obj.OCCUSCStartDate ///开始日期
			s bobj.OCCUSCEndDate=obj.OCCUSCEndDate ///结束日期
			s bobj.OCCUSCCreateDate=obj.OCCUSCCreateDate ///系统创建日期
			s bobj.OCCUSCCreateTime=obj.OCCUSCCreateTime ///系统创建时间
			if $IsObject(obj.OCCUSCCreateUser)
			{   
				s bobj.OCCUSCCreateUser = obj.OCCUSCCreateUser.%Id()   ///系统创建人
			}
			s bobj.OCCUSCSeqNo=obj.OCCUSCSeqNo ///系统排序号
			
			s bobj.OCCUSCLastUpdateDate=obj.OCCUSCLastUpdateDate ///系统最后更新日期
			s bobj.OCCUSCLastUpdateTime=obj.OCCUSCLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.OCCUSCLastUpdateUser)
			{   
				s bobj.OCCUSCLastUpdateUser = obj.OCCUSCLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.OCCUSCPYCode=obj.OCCUSCPYCode ///拼音码
			s bobj.OCCUSCWBCode=obj.OCCUSCWBCode ///五笔码
			s bobj.OCCUSCMark=obj.OCCUSCMark ///备注
		}
		s obj.OCCUSCCode=eobj.OCCUSCCode ///职业子类代码
		s obj.OCCUSCDesc=eobj.OCCUSCDesc ///职业子类名称
		d obj.OCCUSCOCCUCCodeSetObjectId(eobj.OCCUSCOCCUCCode) ///职业大类
		s obj.OCCUSCActivity=eobj.OCCUSCActivity	///是否有效
		s obj.OCCUSCStartDate= eobj.OCCUSCStartDate    ///开始日期
	    s obj.OCCUSCEndDate= eobj.OCCUSCEndDate 	///结束日期
		s obj.OCCUSCSeqNo=eobj.OCCUSCSeqNo ///系统排序号
		s obj.OCCUSCLastUpdateDate=eobj.OCCUSCLastUpdateDate ///系统最后更新日期
		s obj.OCCUSCLastUpdateTime=eobj.OCCUSCLastUpdateTime ///系统最后更新时间
		d obj.OCCUSCLastUpdateUserSetObjectId(eobj.OCCUSCLastUpdateUser)  ///系统最新更新人
		s:eobj.OCCUSCPYCode="" eobj.OCCUSCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.OCCUSCDesc,4) ///自动生成拼音码
		s obj.OCCUSCPYCode=eobj.OCCUSCPYCode ///拼音码
		s:eobj.OCCUSCWBCode="" eobj.OCCUSCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.OCCUSCDesc,1) ///自动生成五笔码
		s obj.OCCUSCWBCode=eobj.OCCUSCWBCode ///五笔码
		s obj.OCCUSCMark=eobj.OCCUSCMark ///备注
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OccuSubCate","CT.BDP.CT.HOSOccuSubCate","职业子类",eobj.ID,eobj.OCCUSCDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OccuSubCate","CT.BDP.CT.HOSOccuSubCate","职业子类子类",id,eobj.OCCUSCDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业子类代码","web.DHCBL.CT.HOSOccuSubCate","DeleteData",eobj)
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
/// CreatDate:2022-12-2
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^CT("OCC",0,"OCCUCCode",id)){
		s myInfo=myInfo_"<职业>"
	}		
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除职业子类代码的内容
/// Table：CT_BDP_CT.HOS_OccuSubCate
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOccuSubCate).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HOSOccuSubCate).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){	
	s pobj = ##class(CT.BDP.CT.HOSOccuSubCate).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSOccuSubCate).%New()
	s eobj.OCCUSCCode=pobj.OCCUSCCode ///职业子类代码
	s eobj.OCCUSCDesc=pobj.OCCUSCDesc ///职业子类名称
	if $IsObject(pobj.OCCUSCOCCUCCode){
	s eobj.OCCUSCOCCUCCode = pobj.OCCUSCOCCUCCode.%Id()   //职业大类
	}
	s eobj.OCCUSCActivity=pobj.OCCUSCActivity ///是否有效		
	s eobj.OCCUSCStartDate=pobj.OCCUSCStartDate ///开始日期
	s eobj.OCCUSCEndDate=pobj.OCCUSCEndDate ///结束日期
	
	s eobj.OCCUSCCreateDate=pobj.OCCUSCCreateDate ///系统创建日期
	s eobj.OCCUSCCreateTime=pobj.OCCUSCCreateTime ///系统创建时间
	if $IsObject(pobj.OCCUSCCreateUser)
	{   
		s eobj.OCCUSCCreateUser = pobj.OCCUSCCreateUser.%Id()   ///系统创建人
	}
	s eobj.OCCUSCSeqNo=pobj.OCCUSCSeqNo ///系统排序号
	s eobj.OCCUSCLastUpdateDate=pobj.OCCUSCLastUpdateDate ///系统最后更新日期
	s eobj.OCCUSCLastUpdateTime=pobj.OCCUSCLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.OCCUSCLastUpdateUser)
	{   
		s eobj.OCCUSCLastUpdateUser = pobj.OCCUSCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.OCCUSCPYCode=pobj.OCCUSCPYCode ///拼音码
	s eobj.OCCUSCWBCode=pobj.OCCUSCWBCode ///五笔码
	s eobj.OCCUSCMark=pobj.OCCUSCMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSOccuSubCate).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OccuSubCate","CT.BDP.CT.HOSOccuSubCate","职业子类",id,eobj.OCCUSCDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业子类","web.DHCBL.CT.HOSOccuSubCate","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}

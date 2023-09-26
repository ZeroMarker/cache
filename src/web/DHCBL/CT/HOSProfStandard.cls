/// Function: 职务标准代码
/// Table：CT_BDP_CT.HOS_ProfStandard
/// CreateDate:2022-11-14
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfStandard Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-10
/// Description：职务标准代码信息查询
/// Table：CT_BDP_CT.HOS_ProfStandard
/// input id code(职务标准代码) desc(职务标准名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfStandard","GetList","1","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFSCode:%String,PROFSDesc:%String,PROFSActivity:%String,PROFSStartDate:%Date,PROFSEndDate:%Date,PROFSSeqNo:%Float,PROFSPYCode:%String,PROFSWBCode:%String,PROFSMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFSCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),2) /// 职务标准代码
	    s PROFSDesc=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),3) /// 职务标准名称
		s PROFSActivity=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),4) ///是否有效
		s PROFSStartDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),5) ///开始日期
		s PROFSEndDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),6) //结束日期
	    s:PROFSStartDate'="" PROFSStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSStartDate) ///转日期格式
	    s:PROFSEndDate'="" PROFSEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSEndDate)	///转日期格式
		s PROFSSeqNo=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),10) ///系统排序号	
		s PROFSPYCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),14) ///拼音码
		s PROFSWBCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),15) ///五笔码
		s PROFSMark=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),16) ///备注
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfStandardD(ID)) q:ID=""  ///RowID
		    s PROFSCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),2) /// 职务标准代码
		    s PROFSDesc=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),3) /// 职务标准名称
			s PROFSActivity=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),4) ///是否有效
			s PROFSStartDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),5) ///开始日期
			s PROFSEndDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),6) //结束日期
		    s:PROFSStartDate'="" PROFSStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSStartDate) ///转日期格式
		    s:PROFSEndDate'="" PROFSEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFSEndDate)	///转日期格式
			s PROFSSeqNo=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),10) ///系统排序号
			s PROFSPYCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),14) ///拼音码
			s PROFSWBCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),15) ///五笔码
			s PROFSMark=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),16) ///备注
			if ($ZCONVERT(PROFSCode,"U")[code)&(($ZCONVERT(PROFSDesc,"U")[desc)||($ZCONVERT(PROFSPYCode,"U")[desc))
			{
		        d OutputRow
			} 
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFSCode,PROFSDesc,PROFSActivity,PROFSStartDate,PROFSEndDate,PROFSSeqNo,PROFSPYCode,PROFSWBCode,PROFSMark)
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
/// CreatDate:2022-11-14
/// Description:为combobox查询取数据
/// Table：Table：CT_BDP_CT.HOS_ProfStandard
/// input id code(职务标准代码) desc(职务标准名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfStandard","GetDataForCmb1","","","")
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFSCode:%String,PROFSDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFSCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),2) /// 职务标准代码
	    s PROFSDesc=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),3) /// 职务标准名称
		s PROFSActivity=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),4) ///是否有效
		s PROFSStartDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),5) ///开始日期
		s PROFSEndDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),6) //结束日期
	    d OutputRowCmb
	}
	else
	{
    	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfStandardD(ID)) q:ID=""  ///RowID
		    s PROFSCode=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),2) /// 职务标准代码
		    s PROFSDesc=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),3) /// 职务标准名称
			s PROFSActivity=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),4) ///是否有效
			continue:PROFSActivity="N"
			s PROFSStartDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),5) ///开始日期
			continue:(PROFSStartDate'="")&&(PROFSStartDate>+$h)
			s PROFSEndDate=$lg($g(^CT.BDP.CT.HOSProfStandardD(ID)),6) //结束日期			
			continue:(PROFSEndDate'="")&&(PROFSEndDate<+$h)	
	    	s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFSDesc)
	    	if (($ZCONVERT(PROFSDesc,"U")[desc)||(PINYIN[desc))
	    	{
	            d OutputRowCmb
	    	} 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PROFSCode,PROFSDesc)
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
/// Other: w ##class(web.DHCBL.CT.HOSProfStandard).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSProfStandard).%New()
    s obj = ##class(CT.BDP.CT.HOSProfStandard).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PROFSCode=obj.PROFSCode /// 职务标准代码
    s eobj.PROFSDesc=obj.PROFSDesc /// 职务标准名称
    s eobj.PROFSActivity=obj.PROFSActivity  ///是否有效
    s eobj.PROFSStartDate=obj.PROFSStartDate  ///开始日期
    s eobj.PROFSEndDate=obj.PROFSEndDate  ///结束日期
    s:obj.PROFSStartDate'="" eobj.PROFSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFSStartDate) ///开始日期(转格式)
    s:obj.PROFSEndDate'="" eobj.PROFSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFSEndDate) ///结束日期(转格式) 
    s eobj.PROFSSeqNo=obj.PROFSSeqNo  ///系统排序号
    s eobj.PROFSPYCode=obj.PROFSPYCode  ///拼音码
    s eobj.PROFSWBCode=obj.PROFSWBCode  ///五笔码
    s eobj.PROFSMark=obj.PROFSMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-11
/// Description：重复校验
/// Table：Table：CT_BDP_CT.HOS_ProfStandard
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSProfStandard).FormValidate("2","","国家")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfStandardI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfStandardI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
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
/// debug：d ##class(web.DHCBL.CT.HOSProfStandard).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSProfStandard).%New()
	s eobj.PROFSCode="002"
	s eobj.PROFSDesc="行业"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-14
/// Description：保存职务标准代码
/// Table：Table：CT_BDP_CT.HOS_ProfStandard
/// Others：w ##class(web.DHCBL.CT.HOSProfStandard).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfStandard) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFSStartDate'="" eobj.PROFSStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFSStartDate) ///转日期格式
    	s:eobj.PROFSEndDate'="" eobj.PROFSEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFSEndDate)	///转日期格式
		s:eobj.PROFSStartDate="" eobj.PROFSStartDate=+$h
		s:eobj.PROFSActivity="" eobj.PROFSActivity="N"
		
		s eobj.PROFSLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PROFSLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFSCreateUser="") s eobj.PROFSCreateUser=USERID   ///系统创建人
			if (eobj.PROFSLastUpdateUser="") s eobj.PROFSLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.ID,eobj.PROFSCode,eobj.PROFSDesc)  //调用重复验证


		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProfStandard).%New()
			d obj.PROFSCreateUserSetObjectId(eobj.PROFSCreateUser)  ///系统创建人
			s obj.PROFSCreateDate=+$H           ///系统创建日期
			s obj.PROFSCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfStandard).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfStandard).%New()
			s bobj.ID=eobj.ID    ////RowId
			s bobj.PROFSCode=obj.PROFSCode /// 职务标准代码
			s bobj.PROFSDesc=obj.PROFSDesc ///职务标准名称
			s bobj.PROFSActivity=obj.PROFSActivity ///是否有效
					
			s bobj.PROFSStartDate=obj.PROFSStartDate ///开始日期
			s bobj.PROFSEndDate=obj.PROFSEndDate ///结束日期
			s bobj.PROFSCreateDate=obj.PROFSCreateDate ///系统创建日期
			s bobj.PROFSCreateTime=obj.PROFSCreateTime ///系统创建时间
			if $IsObject(obj.PROFSCreateUser)
			{   
				s bobj.PROFSCreateUser = obj.PROFSCreateUser.%Id()   ///系统创建人
			}
			s bobj.PROFSSeqNo=obj.PROFSSeqNo ///系统排序号
			
			s bobj.PROFSLastUpdateDate=obj.PROFSLastUpdateDate ///系统最后更新日期
			s bobj.PROFSLastUpdateTime=obj.PROFSLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFSLastUpdateUser)
			{   
				s bobj.PROFSLastUpdateUser = obj.PROFSLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFSPYCode=obj.PROFSPYCode ///拼音码
			s bobj.PROFSWBCode=obj.PROFSWBCode ///五笔码
			s bobj.PROFSMark=obj.PROFSMark ///备注
		}
		
		s obj.PROFSCode=eobj.PROFSCode ///职务标准代码
		s obj.PROFSDesc=eobj.PROFSDesc ///职务标准名称
		s obj.PROFSActivity=eobj.PROFSActivity		  ///是否有效
		s obj.PROFSStartDate= eobj.PROFSStartDate     ///开始日期
	    s obj.PROFSEndDate= eobj.PROFSEndDate 		 ///结束日期
		s obj.PROFSSeqNo=eobj.PROFSSeqNo ///系统排序号
		s obj.PROFSLastUpdateDate=eobj.PROFSLastUpdateDate ///系统最后更新日期
		s obj.PROFSLastUpdateTime=eobj.PROFSLastUpdateTime ///系统最后更新时间
		d obj.PROFSLastUpdateUserSetObjectId(eobj.PROFSLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFSPYCode="" eobj.PROFSPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFSDesc,4) ///自动生成拼音码
		s obj.PROFSPYCode=eobj.PROFSPYCode ///拼音码
		s:eobj.PROFSWBCode="" eobj.PROFSWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFSDesc,1) ///自动生成五笔码
		s obj.PROFSWBCode=eobj.PROFSWBCode ///五笔码
		s obj.PROFSMark=eobj.PROFSMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfStandard","CT.BDP.CT.HOSProfStandard","职务标准代码",eobj.ID,eobj.PROFSDesc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfStandard","CT.BDP.CT.HOSProfStandard","职务标准代码",id,eobj.PROFSDesc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务标准代码","web.DHCBL.CT.HOSProfStandard","SaveEntity",eobj) 
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
	if $d(^CT.BDP.CT.HOSProfTitleI("IndexPROFSCode",id)){
		s myInfo=myInfo_"<职务代码>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除职务标准代码的内容
/// Table：CT_BDP_CT.HOS_ProfStandard
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfStandard).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.HOSProfStandard).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){	
	s pobj = ##class(CT.BDP.CT.HOSProfStandard).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfStandard).%New()
	s eobj.PROFSCode=pobj.PROFSCode ///职务标准代码
	s eobj.PROFSDesc=pobj.PROFSDesc ///职务标准名称
	
	s eobj.PROFSActivity=pobj.PROFSActivity ///是否有效		
	s eobj.PROFSStartDate=pobj.PROFSStartDate ///开始日期
	s eobj.PROFSEndDate=pobj.PROFSEndDate ///结束日期
	
	s eobj.PROFSCreateDate=pobj.PROFSCreateDate ///系统创建日期
	s eobj.PROFSCreateTime=pobj.PROFSCreateTime ///系统创建时间
	if $IsObject(pobj.PROFSCreateUser)
	{   
		s eobj.PROFSCreateUser = pobj.PROFSCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFSSeqNo=pobj.PROFSSeqNo ///系统排序号
	s eobj.PROFSLastUpdateDate=pobj.PROFSLastUpdateDate ///系统最后更新日期
	s eobj.PROFSLastUpdateTime=pobj.PROFSLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFSLastUpdateUser)
	{   
		s eobj.PROFSLastUpdateUser = pobj.PROFSLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFSPYCode=pobj.PROFSPYCode ///拼音码
	s eobj.PROFSWBCode=pobj.PROFSWBCode ///五笔码
	s eobj.PROFSMark=pobj.PROFSMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfStandard).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfStandard","CT.BDP.CT.HOSProfStandard","职务标准代码",id,eobj.PROFSDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务标准代码","web.DHCBL.CT.HOSProfStandard","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	q result
}

}

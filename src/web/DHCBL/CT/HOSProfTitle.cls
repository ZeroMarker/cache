/// Function: 组织职务
/// Table：CT_BDP_CT.HOS_ProfTitle
/// CreateDate:2022-11-16
/// Creator:lujunwen
Class web.DHCBL.CT.HOSProfTitle Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:lujunwen
/// CreateDate:2022-11-16
/// Description：组织职务信息查询
/// Table：CT_BDP_CT.HOS_ProfTitle
/// input id code(职务代码) desc(职务名称)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfTitle","GetList","","","") 
Query GetList(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFTCode:%String,PROFTDesc:%String,PROFTDeptCode:%String,PROFTPROFTCCode:%String,PROFTLimitedNum:%String,PROFTActivity:%String,PROFTStartDate:%Date,PROFTEndDate:%Date,PROFTSeqNo:%Float,PROFTPYCode:%String,PROFTWBCode:%String,PROFTMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1 
	 
  	s AuStr=##class(web.DHCBL.Authorize.HOSProfTitle).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1

	s DeptAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DeptAuFlag=0	
	if (DeptAuStr="")||(DeptAuStr["limited:0") s DeptAuFlag=1
	
	s ProftAuStr=##class(web.DHCBL.Authorize.HOSProfTitleDict).DHCGetDataByDefaultSession()
	s ProftAuFlag=0	
	if (ProftAuStr="")||(ProftAuStr["limited:0") s ProftAuFlag=1	
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFTCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),2) /// 职务代码
	    s PROFTDesc=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),3) /// 职务名称
	    s PROFTDeptCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),4) ///所属部门指针
	    s:PROFTDeptCode'="" PROFTDeptCode=$lg($g(^CT.BDP.CT.HOSDepartmentD(PROFTDeptCode)),3) ///所属部门描述
	    s PROFTPROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),5) ///职务字典编码指针
	    s:PROFTPROFTCCode'="" PROFTPROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(PROFTPROFTCCode)),3) ///职务字典描述
	    s PROFTLimitedNum=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),6) ///额定人数
		s PROFTActivity=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),7) ///是否有效
		s PROFTStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),8) ///开始日期
		s PROFTEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),9) //结束日期
	    s:PROFTStartDate'="" PROFTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTStartDate) ///转日期格式
	    s:PROFTEndDate'="" PROFTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTEndDate)	///转日期格式
		s PROFTSeqNo=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),13) ///系统排序号
		s PROFTPYCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),17) ///拼音码
		s PROFTWBCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),18) ///五笔码
		s PROFTMark=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),19) ///备注
	    d OutputRow
	}
	else
	{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfTitleD(ID)) q:ID=""  ///RowID
			s strRowId = "{ID:"_ID_"}"
			s PROFTDeptCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),4) ///所属部门指针
			s DeptstrRowId = "{ID:"_PROFTDeptCode_"}"
			s PROFTPROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),5) ///职务字典编码指针
			s ProftstrRowId = "{ID:"_PROFTPROFTCCode_"}"	
			i ((AuStr[strRowId)||(AuFlag=1))&&((DeptAuStr[DeptstrRowId)||(DeptAuFlag=1))&&((ProftAuStr[ProftstrRowId)||(ProftAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{			
			    s PROFTCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),2) /// 职务代码
			    s PROFTDesc=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),3) /// 职务名称
			    
			    s:PROFTDeptCode'="" PROFTDeptCode=$lg($g(^CT.BDP.CT.HOSDepartmentD(PROFTDeptCode)),3) ///所属部门描述
			    
			    s:PROFTPROFTCCode'="" PROFTPROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(PROFTPROFTCCode)),3) ///职务字典描述
			    s PROFTLimitedNum=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),6) ///额定人数
				s PROFTActivity=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),7) ///是否有效
				s PROFTStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),8) ///开始日期
				s PROFTEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),9) //结束日期
			    s:PROFTStartDate'="" PROFTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTStartDate) ///转日期格式
			    s:PROFTEndDate'="" PROFTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PROFTEndDate)	///转日期格式
				s PROFTSeqNo=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),13) ///系统排序号
				s PROFTPYCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),17) ///拼音码
				s PROFTWBCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),18) ///五笔码
				s PROFTMark=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),19) ///备注	
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFTDesc)
		    	if ($ZCONVERT(PROFTCode,"U")[code)&(($ZCONVERT(PROFTDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRow
		    	} 
			}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PROFTCode,PROFTDesc,PROFTDeptCode,PROFTPROFTCCode,PROFTLimitedNum,PROFTActivity,PROFTStartDate,PROFTEndDate,PROFTSeqNo,PROFTPYCode,PROFTWBCode,PROFTMark)
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
/// CreatDate:2022-11-16
/// Description:为combobox查询取数据
/// Table：CT_BDP_CT.HOS_ProfTitle
/// input id code(职务代码) desc(职务名称)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSProfTitle","GetDataForCmb1","","","")	
Query GetDataForCmb1(id As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,PROFTCode:%String,PROFTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSProfTitle).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1

	s DeptAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DeptAuFlag=0	
	if (DeptAuStr="")||(DeptAuStr["limited:0") s DeptAuFlag=1
	
	s ProftAuStr=##class(web.DHCBL.Authorize.HOSProfTitleDict).DHCGetDataByDefaultSession()
	s ProftAuFlag=0	
	if (ProftAuStr="")||(ProftAuStr["limited:0") s ProftAuFlag=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PROFTCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),2) /// 职务代码
	    s PROFTDesc=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),3) /// 职务名称
		s PROFTActivity=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),7) ///是否有效
		s PROFTStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),8) ///开始日期
		s PROFTEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),9) //结束日期
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProfTitleD(ID)) q:ID=""  ///RowID
			s PROFTDeptCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),4) ///所属部门指针
			s DeptstrRowId = "{ID:"_PROFTDeptCode_"}"
			s PROFTPROFTCCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),5) ///职务字典编码指针
			s ProftstrRowId = "{ID:"_PROFTPROFTCCode_"}"	
			i ((AuStr[strRowId)||(AuFlag=1))&&((DeptAuStr[DeptstrRowId)||(DeptAuFlag=1))&&((ProftAuStr[ProftstrRowId)||(ProftAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{					
			    s PROFTCode=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),2) /// 职务代码
			    s PROFTDesc=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),3) /// 职务名称
				s PROFTActivity=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),7) ///是否有效
				continue:PROFTActivity="N"
				s PROFTStartDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),8) ///开始日期
				continue:(PROFTStartDate'="")&&(PROFTStartDate>+$h)
				s PROFTEndDate=$lg($g(^CT.BDP.CT.HOSProfTitleD(ID)),9) //结束日期
				continue:(PROFTEndDate'="")&&(PROFTEndDate<+$h)		
		        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROFTDesc)
		    	if ($ZCONVERT(PROFTCode,"U")[code)&(($ZCONVERT(PROFTDesc,"U")[desc)||(PINYIN[desc))
		    	{
		            d OutputRowCmb
		    	} 
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,PROFTCode,PROFTDesc)
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
/// CreatDate:  2022-10-11
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSProfTitle).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSProfTitle).%New()
    s obj = ##class(CT.BDP.CT.HOSProfTitle).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.PROFTCode=obj.PROFTCode /// 职务代码
    s eobj.PROFTDesc=obj.PROFTDesc /// 职务名称
	if $IsObject(obj.PROFTDeptCode)
	{
		s eobj.PROFTDeptCode = obj.PROFTDeptCode.%Id()   //所属部门
	}
	if $IsObject(obj.PROFTPROFTCCode)
	{
		s eobj.PROFTPROFTCCode = obj.PROFTPROFTCCode.%Id()   //职务字典编码
	} 	    
    s eobj.PROFTLimitedNum=obj.PROFTLimitedNum  ///额定人数		
    s eobj.PROFTActivity=obj.PROFTActivity  ///是否有效
    s eobj.PROFTStartDate=obj.PROFTStartDate  ///开始日期
    s eobj.PROFTEndDate=obj.PROFTEndDate  ///结束日期
    s:obj.PROFTStartDate'="" eobj.PROFTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFTStartDate) ///开始日期(转格式)
    s:obj.PROFTEndDate'="" eobj.PROFTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PROFTEndDate) ///结束日期(转格式) 
    s eobj.PROFTPYCode=obj.PROFTPYCode  ///拼音码
    s eobj.PROFTWBCode=obj.PROFTWBCode  ///五笔码
    s eobj.PROFTMark=obj.PROFTMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-11
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_ProfTitle
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.HOSProfTitle).FormValidate("1","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfTitleI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProfTitleI("IndexDesc"," "_$ZCONVERT(desc,"U"),0)) 
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
/// debug：d ##class(web.DHCBL.CT.HOSProfTitle).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.HOSProfTitle).%New()
	s eobj.PROFTCode="002"
	s eobj.PROFTDesc="信息科主任"
	s eobj.PROFTPROFRCode="1||2"
	s eobj.PROFTPROFSCode="1"
	s eobj.PROFTPROFMCode="4||1||2"	
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-11-17
/// Description：保存组织职务 
/// Table：CT_BDP_CT.HOS_ProfTitle
/// Others：w ##class(web.DHCBL.CT.HOSProfTitle).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProfTitle) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PROFTStartDate'="" eobj.PROFTStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFTStartDate)	//开始日期
	    s:eobj.PROFTEndDate'="" eobj.PROFTEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROFTEndDate)	//结束日期
		s:eobj.PROFTStartDate="" eobj.PROFTStartDate=+$h
		s:eobj.PROFTActivity="" eobj.PROFTActivity="N"
		s eobj.PROFTLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PROFTLastUpdateTime=$p($h,",",2) ///系统最后更新时间
	    s flag=..FormValidate(eobj.ID,eobj.PROFTCode,eobj.PROFTDesc)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PROFTCreateUser="") s eobj.PROFTCreateUser=USERID   ///系统创建人
			if (eobj.PROFTLastUpdateUser="") s eobj.PROFTLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProfTitle).%New()
			s obj.PROFTCreateDate=+$H           ///系统创建日期
			s obj.PROFTCreateTime=$p($h,",",2)  ///系统创建时间			
			d obj.PROFTLastUpdateUserSetObjectId(eobj.PROFTLastUpdateUser)  ///系统创建人
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProfTitle).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProfTitle).%New()							
			s bobj.PROFTCode=obj.PROFTCode /// 职务代码
			s bobj.PROFTDesc=obj.PROFTDesc ///职务名称
			if $IsObject(obj.PROFTDeptCode)
			{
				s bobj.PROFTDeptCode = obj.PROFTDeptCode.%Id()   //所属部门
			}
			if $IsObject(obj.PROFTPROFTCCode)
			{
				s bobj.PROFTPROFTCCode = obj.PROFTPROFTCCode.%Id()   //职务字典编码
			} 
			s bobj.PROFTLimitedNum=obj.PROFTLimitedNum ///额定人数			
			s bobj.PROFTActivity=obj.PROFTActivity ///是否有效	
			s bobj.PROFTStartDate=obj.PROFTStartDate ///开始日期
			s bobj.PROFTEndDate=obj.PROFTEndDate ///结束日期
			s bobj.PROFTCreateDate=obj.PROFTCreateDate ///系统创建日期
			s bobj.PROFTCreateTime=obj.PROFTCreateTime ///系统创建时间
			if $IsObject(obj.PROFTCreateUser)
			{   
				s bobj.PROFTCreateUser = obj.PROFTCreateUser.%Id()   ///系统创建人
			}
			s bobj.PROFTSeqNo=obj.PROFTSeqNo ///系统排序号
			
			s bobj.PROFTLastUpdateDate=obj.PROFTLastUpdateDate ///系统最后更新日期
			s bobj.PROFTLastUpdateTime=obj.PROFTLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PROFTLastUpdateUser)
			{   
				s bobj.PROFTLastUpdateUser = obj.PROFTLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PROFTPYCode=obj.PROFTPYCode ///拼音码
			s bobj.PROFTWBCode=obj.PROFTWBCode ///五笔码
			s bobj.PROFTMark=obj.PROFTMark ///备注
		}
		s obj.PROFTCode=eobj.PROFTCode ///职务代码
		s obj.PROFTDesc=eobj.PROFTDesc ///职务名称
		d obj.PROFTDeptCodeSetObjectId(eobj.PROFTDeptCode) //所属部门
		d obj.PROFTPROFTCCodeSetObjectId(eobj.PROFTPROFTCCode) //职务字典编码
		s obj.PROFTLimitedNum=eobj.PROFTLimitedNum ///额定人数
		s obj.PROFTActivity=eobj.PROFTActivity	///是否有效
		s obj.PROFTStartDate= eobj.PROFTStartDate    ///开始日期
	    s obj.PROFTEndDate= eobj.PROFTEndDate 	///结束日期
		s obj.PROFTSeqNo=eobj.PROFTSeqNo ///系统排序号
		s obj.PROFTLastUpdateDate=eobj.PROFTLastUpdateDate ///系统最后更新日期
		s obj.PROFTLastUpdateTime=eobj.PROFTLastUpdateTime ///系统最后更新时间
		d obj.PROFTLastUpdateUserSetObjectId(eobj.PROFTLastUpdateUser)  ///系统最新更新人
		s:eobj.PROFTPYCode="" eobj.PROFTPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.PROFTDesc,4) ///自动生成拼音码
		s obj.PROFTPYCode=eobj.PROFTPYCode ///拼音码
		s:eobj.PROFTWBCode="" eobj.PROFTWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROFTDesc,1) ///自动生成五笔码
		s obj.PROFTWBCode=eobj.PROFTWBCode ///五笔码
		s obj.PROFTMark=eobj.PROFTMark ///备注
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfTitle","CT.BDP.CT.HOSProfTitle","职务代码",eobj.ID,eobj.PROFTDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfTitle","CT.BDP.CT.HOSProfTitle","职务代码",id,eobj.PROFTDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务代码","web.DHCBL.CT.HOSProfTitle","DeleteData",eobj)
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
/// CreatDate:2022-11-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^CT.BDP.CT.HOSEmpProfTitleI("IndexPOSCode",id)){
		s myInfo=myInfo_"<组织人员-职务>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:鲁俊文
/// CreatDate:2022-11-14
/// Description：根据ID删除组织职务的内容
/// Table：CT_BDP_CT.HOS_ProfTitle
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSProfTitle).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HOSProfTitle).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){		 
	s pobj = ##class(CT.BDP.CT.HOSProfTitle).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProfTitle).%New()
	s eobj.PROFTCode=pobj.PROFTCode ///职务代码
	s eobj.PROFTDesc=pobj.PROFTDesc ///职务名称	
	if $IsObject(pobj.PROFTDeptCode)
	{
		s eobj.PROFTDeptCode = pobj.PROFTDeptCode.%Id()   //所属部门
	}
	if $IsObject(pobj.PROFTPROFTCCode)
	{
		s eobj.PROFTPROFTCCode = pobj.PROFTPROFTCCode.%Id()   //职务字典编码
	}
	s eobj.PROFTLimitedNum=pobj.PROFTLimitedNum ///额定人数			
	s eobj.PROFTActivity=pobj.PROFTActivity ///是否有效		
	s eobj.PROFTStartDate=pobj.PROFTStartDate ///开始日期
	s eobj.PROFTEndDate=pobj.PROFTEndDate ///结束日期
	
	s eobj.PROFTCreateDate=pobj.PROFTCreateDate ///系统创建日期
	s eobj.PROFTCreateTime=pobj.PROFTCreateTime ///系统创建时间
	if $IsObject(pobj.PROFTCreateUser)
	{   
		s eobj.PROFTCreateUser = pobj.PROFTCreateUser.%Id()   ///系统创建人
	}
	s eobj.PROFTSeqNo=pobj.PROFTSeqNo ///系统排序号
	s eobj.PROFTLastUpdateDate=pobj.PROFTLastUpdateDate ///系统最后更新日期
	s eobj.PROFTLastUpdateTime=pobj.PROFTLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PROFTLastUpdateUser)
	{   
		s eobj.PROFTLastUpdateUser = pobj.PROFTLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PROFTPYCode=pobj.PROFTPYCode ///拼音码
	s eobj.PROFTWBCode=pobj.PROFTWBCode ///五笔码
	s eobj.PROFTMark=pobj.PROFTMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProfTitle).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProfTitle","CT.BDP.CT.HOSProfTitle","职务代码",id,eobj.PROFTDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职务代码","web.DHCBL.CT.HOSProfTitle","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}	 
	q result
}

}

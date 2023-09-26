/// 描述:系统账户岗位表
/// 创建人：基础数据平台 gaoshanshan
/// 创建日期：2022-11-30
Class web.DHCBL.CT.HOSUserAccountPost Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  系统账户岗位查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-30
/// Table：     User.HOSUserAccountPost   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSUserAccountPost","GetList","","11868")
Query GetList(rowid As %String, parref As %String) As %Query(ROWSPEC = "USERPOSTRowId,USERPOSTParRef,USERPOSTPostCode,USERPOSTPostDesc,USERPOSTActivity,USERPOSTStartDate,USERPOSTEndDate,USERPOSTSeqNo,USERPOSTPYCode,USERPOSTWBCode,USERPOSTMark,USERPOSTDefault")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
      	s ChildSub=$p(rowid,"||",2)
      	s USERPOSTRowId=rowid
      	s USERPOSTParRef=parref
        s USERPOSTPostCode =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",1) /// 岗位字典-外键
        s USERPOSTPostDesc=""
        s:USERPOSTPostCode'="" USERPOSTPostDesc=$listget($g(^CT.BDP.CT.HOSPostD(USERPOSTPostCode)),3)
        s USERPOSTActivity =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",2) /// 是否有效(Y/N)
        s USERPOSTStartDate =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",3) /// 开始日期
        s:USERPOSTStartDate'="" USERPOSTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(USERPOSTStartDate)
        s USERPOSTEndDate =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",4) /// 结束日期
        s:USERPOSTEndDate'="" USERPOSTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(USERPOSTEndDate)
        s USERPOSTSeqNo =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",8) /// 系统排序号
        s USERPOSTPYCode =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",12) /// 拼音码
        s USERPOSTWBCode =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",13) /// 五笔码
        s USERPOSTMark =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",14) /// 备注
        s USERPOSTDefault =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",15) /// 默认
    	d OutputRow
    }
    else
    {  
        s ChildSub=0
        for 
        {
            s ChildSub=$o(^SSU("SSUSR",parref,"USERPOST",ChildSub))
            q:ChildSub="" 
            s USERPOSTRowId=parref_"||"_ChildSub
            s USERPOSTParRef=parref
	        s USERPOSTPostCode =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",1) /// 岗位字典-外键
	        s USERPOSTPostDesc=""
	        s:USERPOSTPostCode'="" USERPOSTPostDesc=$listget($g(^CT.BDP.CT.HOSPostD(USERPOSTPostCode)),3)
	        s USERPOSTActivity =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",2) /// 是否有效(Y/N)
	        s USERPOSTStartDate =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",3) /// 开始日期
	        s:USERPOSTStartDate'="" USERPOSTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(USERPOSTStartDate)
	        s USERPOSTEndDate =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",4) /// 结束日期
	        s:USERPOSTEndDate'="" USERPOSTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(USERPOSTEndDate)
	        s USERPOSTSeqNo =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",8) /// 系统排序号
	        s USERPOSTPYCode =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",12) /// 拼音码
	        s USERPOSTWBCode =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",13) /// 五笔码
	        s USERPOSTMark =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",14) /// 备注
	        s USERPOSTDefault =$p($g(^SSU("SSUSR",parref,"USERPOST",ChildSub)),"^",15) /// 默认
           
            d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(USERPOSTRowId,USERPOSTParRef,USERPOSTPostCode,USERPOSTPostDesc,USERPOSTActivity,USERPOSTStartDate,USERPOSTEndDate,USERPOSTSeqNo,USERPOSTPYCode,USERPOSTWBCode,USERPOSTMark,USERPOSTDefault)
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

/// Function： 修改时打开的数据
/// Creator:   gaoshanshan
/// CreatDate: 2022-11-30
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSUserAccountPost).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSUserAccountPost).%New()
    s obj = ##class(User.HOSUserAccountPost).%OpenId(id)
    s eobj.USERPOSTRowId=id
    s eobj.USERPOSTParRef = $p(id,"||",1)
    s:$IsObject(obj.USERPOSTPostCode) eobj.USERPOSTPostCode = obj.USERPOSTPostCode.%Id()
    s eobj.USERPOSTActivity = obj.USERPOSTActivity 
    s:obj.USERPOSTStartDate'="" eobj.USERPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.USERPOSTStartDate) 
    s:obj.USERPOSTEndDate'="" eobj.USERPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.USERPOSTEndDate) 
    s eobj.USERPOSTSeqNo= obj.USERPOSTSeqNo
    s eobj.USERPOSTPYCode= obj.USERPOSTPYCode
    s eobj.USERPOSTWBCode= obj.USERPOSTWBCode
    s eobj.USERPOSTMark= obj.USERPOSTMark
    s eobj.USERPOSTDefault= obj.USERPOSTDefault
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-30
/// Table：   User.HOSUserAccountPost
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSUserAccountPost).FormValidate("2||2","2","1")
ClassMethod FormValidate(id As %String, parref As %String, code As %String) As %String
{
    s flag=0
    if ((parref'="")&(code'="")){
	    s idc=$o(^SSU("SSUSR",parref,"USERPOST",0,"Post",code,0)) 
		if ((id="")||((id'="")&&(idc'=$p(id,"||",2))))&&(idc>0) s flag=1  //返回重复标志
	}
    q flag
}

/// Function    保存内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-30
/// Table：     User.HOSUserAccountPost
/// Input：     web.Entity.CT.HOSUserAccountPost  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSUserAccountPost).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSUserAccountPost) As %String
{
 
    s result="" 
    s:eobj.USERPOSTStartDate'="" eobj.USERPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.USERPOSTStartDate) 
    s:eobj.USERPOSTEndDate'="" eobj.USERPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.USERPOSTEndDate) 
    s:eobj.USERPOSTStartDate="" eobj.USERPOSTStartDate=+$h
    
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID"))
    s eobj.USERPOSTLastUpdateDate=+$h  ///系统最后更新日期
    s eobj.USERPOSTLastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    if (eobj.USERPOSTLastUpdateUser="") s eobj.USERPOSTLastUpdateUser=USERID  ///系统最新更新人
    s:eobj.USERPOSTActivity="" eobj.USERPOSTActivity="N"		//是否有效
    
    s flag=  ..FormValidate(eobj.USERPOSTRowId,eobj.USERPOSTParRef,eobj.USERPOSTPostCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.USERPOSTRowId="")  
        {
            s obj=##class(User.HOSUserAccountPost).%New(eobj.USERPOSTParRef)
            s eobj.USERPOSTCreateDate=+$h  ///系统创建日期
            s eobj.USERPOSTCreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.USERPOSTCreateUser="" eobj.USERPOSTCreateUser=USERID   ///系统创建人
            s obj.USERPOSTCreateDate=eobj.USERPOSTCreateDate
            s obj.USERPOSTCreateTime=eobj.USERPOSTCreateTime
            d obj.USERPOSTCreateUserSetObjectId(eobj.USERPOSTCreateUser)
        }
        else              
        {
            s obj=##class(User.HOSUserAccountPost).%OpenId(eobj.USERPOSTRowId)
            s bobj=##class(web.Entity.CT.HOSUserAccountPost).%New()
            s bobj.USERPOSTRowId=eobj.USERPOSTRowId 
		    s bobj.USERPOSTParRef = $p(eobj.USERPOSTRowId,"||",1)
		    s:$IsObject(obj.USERPOSTPostCode) bobj.USERPOSTPostCode = obj.USERPOSTPostCode.%Id()
		    s bCTLOCDR=$listget($g(^CT.BDP.CT.HOSPostD(bobj.USERPOSTPostCode)),4)
		    s bobj.USERPOSTActivity = obj.USERPOSTActivity 
		    s:obj.USERPOSTStartDate'="" bobj.USERPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.USERPOSTStartDate) 
		    s:obj.USERPOSTEndDate'="" bobj.USERPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.USERPOSTEndDate) 
		    s:obj.USERPOSTCreateDate'="" bobj.USERPOSTCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.USERPOSTCreateDate) 
		    s:obj.USERPOSTCreateTime'="" bobj.USERPOSTCreateTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.USERPOSTCreateTime) 
		    s:$IsObject(obj.USERPOSTCreateUser) bobj.USERPOSTCreateUser= obj.USERPOSTCreateUser.%Id()
		    s bobj.USERPOSTSeqNo= obj.USERPOSTSeqNo
		    s:obj.USERPOSTLastUpdateDate'="" bobj.USERPOSTLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.USERPOSTLastUpdateDate) 
		    s bobj.USERPOSTLastUpdateTime= obj.USERPOSTLastUpdateTime
		    s:$IsObject(obj.USERPOSTLastUpdateUser) bobj.USERPOSTLastUpdateUser= obj.USERPOSTLastUpdateUser.%Id()
		    s bobj.USERPOSTPYCode= obj.USERPOSTPYCode
		    s bobj.USERPOSTWBCode= obj.USERPOSTWBCode
		    s bobj.USERPOSTMark= obj.USERPOSTMark
		    s bobj.USERPOSTDefault= obj.USERPOSTDefault
        }
       
	    d:eobj.USERPOSTParRef'="" obj.USERPOSTParRefSetObjectId(eobj.USERPOSTParRef)
	    d:eobj.USERPOSTPostCode'="" obj.USERPOSTPostCodeSetObjectId(eobj.USERPOSTPostCode)
	    s obj.USERPOSTActivity = eobj.USERPOSTActivity 
	    s obj.USERPOSTStartDate= eobj.USERPOSTStartDate
	    s obj.USERPOSTEndDate= eobj.USERPOSTEndDate
	    s obj.USERPOSTSeqNo= eobj.USERPOSTSeqNo
	    s obj.USERPOSTLastUpdateDate= eobj.USERPOSTLastUpdateDate
	    s obj.USERPOSTLastUpdateTime= eobj.USERPOSTLastUpdateTime
	    d obj.USERPOSTLastUpdateUserSetObjectId(eobj.USERPOSTLastUpdateUser)
	    s obj.USERPOSTPYCode= eobj.USERPOSTPYCode
	    s obj.USERPOSTWBCode= eobj.USERPOSTWBCode
	    s obj.USERPOSTMark= eobj.USERPOSTMark 
	    s obj.USERPOSTDefault= eobj.USERPOSTDefault
	    
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            
            //同步到资源表RB_Resource
            s CareProvDR=$p($g(^SSU("SSUSR",eobj.USERPOSTParRef)),"^",14)
            s CTLOCDR=$listget($g(^CT.BDP.CT.HOSPostD(eobj.USERPOSTPostCode)),4)
			if (CareProvDR'="")&(CTLOCDR)
			{
				if (eobj.USERPOSTRowId="")
				{
					if (CTLOCDR'="")
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvDR,CTLOCDR,"Add",eobj.USERPOSTStartDate,eobj.USERPOSTEndDate,id)	
					}
				}
				else
				{
					if ((bCTLOCDR'="")&(CTLOCDR'=bCTLOCDR))
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvDR,bCTLOCDR,"Update",eobj.USERPOSTStartDate,+$h)
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvDR,CTLOCDR,"Add",eobj.USERPOSTStartDate,eobj.USERPOSTEndDate)											
					}
					if (eobj.USERPOSTEndDate'=bobj.USERPOSTEndDate)
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvDR,CTLOCDR,"Update",eobj.USERPOSTStartDate,eobj.USERPOSTEndDate)											
					}
		  		}
			}
            
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.USERPOSTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("HOS_UserAccountPost","User.HOSUserAccountPost","系统账户岗位",id,eobj.USERPOSTPostCode,"A",eobj)
            d:eobj.USERPOSTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("HOS_UserAccountPost","User.HOSUserAccountPost","系统账户岗位",eobj.USERPOSTRowId,eobj.USERPOSTPostCode,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("系统账户岗位","web.DHCBL.CT.HOSUserAccountPost","SaveData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
    q result
}

/// Function:保存多条系统账户岗位数据
/// CreateDate:2022-11-30
/// Creator:gaoshanshan
/// Tables: User.HOSUserAccountPost
/// w ##class(web.DHCBL.CT.HOSUserAccountPost).SaveAll("11868","^1^Y^2022-11-30^^^")
ClassMethod SaveAll(ssusrrowid As %String, poststr As %String) As %String
{
	s result=""
	if (poststr'="")
	{
		s postlength=$Length(poststr,"*")
		for i=1:1:postlength
		{
			s eobj=##class(web.Entity.CT.HOSUserAccountPost).%New()
			s str=$p(poststr,"*",i)
			s eobj.USERPOSTParRef = ssusrrowid
			s eobj.USERPOSTRowId = $p(str,"^",1)
			s eobj.USERPOSTPostCode = $p(str,"^",2)
			s eobj.USERPOSTActivity = $p(str,"^",3)
			s eobj.USERPOSTStartDate = $p(str,"^",4)
			s eobj.USERPOSTEndDate = $p(str,"^",5)
			s eobj.USERPOSTSeqNo = $p(str,"^",6)
			s eobj.USERPOSTMark = $p(str,"^",7)
			s eobj.USERPOSTDefault = $p(str,"^",8)

			s result= ##class(web.DHCBL.CT.HOSUserAccountPost).SaveEntity(eobj)	
			
		}	
	}
	q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-30
/// Description：根据ID删除内容
/// Table：User.HOSUserAccountPost
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSUserAccountPost).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(User.HOSUserAccountPost).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSUserAccountPost).%New()
    s eobj.USERPOSTRowId = id
    s eobj.USERPOSTParRef = $p(id,"||",1)
    s:$IsObject(pobj.USERPOSTPostCode) eobj.USERPOSTPostCode = pobj.USERPOSTPostCode.%Id()
    s eobj.USERPOSTActivity = pobj.USERPOSTActivity 
    s:pobj.USERPOSTStartDate'="" eobj.USERPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.USERPOSTStartDate) 
    s:pobj.USERPOSTEndDate'="" eobj.USERPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.USERPOSTEndDate) 
    s:pobj.USERPOSTCreateDate'="" eobj.USERPOSTCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.USERPOSTCreateDate) 
    s eobj.USERPOSTCreateTime= pobj.USERPOSTCreateTime
    s:$IsObject(pobj.USERPOSTCreateUser) eobj.USERPOSTCreateUser= pobj.USERPOSTCreateUser.%Id()
    s eobj.USERPOSTSeqNo= pobj.USERPOSTSeqNo
    s:pobj.USERPOSTLastUpdateDate'="" eobj.USERPOSTLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.USERPOSTLastUpdateDate) 
    s eobj.USERPOSTLastUpdateTime= pobj.USERPOSTLastUpdateTime
    s:$IsObject(pobj.USERPOSTLastUpdateUser) eobj.USERPOSTLastUpdateUser= pobj.USERPOSTLastUpdateUser.%Id()
    s eobj.USERPOSTPYCode= pobj.USERPOSTPYCode
    s eobj.USERPOSTWBCode= pobj.USERPOSTWBCode
    s eobj.USERPOSTMark= pobj.USERPOSTMark
    s eobj.USERPOSTDefault= pobj.USERPOSTDefault
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.HOSUserAccountPost).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("HOS_UserAccountPost","User.HOSUserAccountPost","系统账户岗位",id,eobj.USERPOSTPostCode,"D",eobj)
        d eobj.%Close()
        
        ;指定科室截止关联
		s CareProvDR=$p($g(^SSU("SSUSR",eobj.USERPOSTParRef)),"^",14) 
		s CTLOCDR=$listget($g(^CT.BDP.CT.HOSPostD(eobj.USERPOSTPostCode)),4)
		if (CareProvDR'="")&&(CTLOCDR'="")
		{
			D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvDR,CTLOCDR,"Update","",+$h)
		}
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("系统账户岗位","web.DHCBL.CT.HOSUserAccountPost","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

/// Creator: gaoshanshan
/// CreatDate: 2022-11-30
/// Description: 删除某个用户的所有关联岗位数据
/// Input: 系统账户岗位rowid串
/// Return: 1
ClassMethod DeleteSelections(idstr As %String) As %String
{
	q:idstr="" ""
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s re=..DeleteData(id)
	}
	q 1
}

}

/// Function: HOS 组织人员表-组织和人员的关联表
/// CreateDate:2022-11-14
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSORGEmployee Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织人员查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-14
/// Table：     CT_BDP_CT.HOS_ORGEmployee   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSORGEmployee","GetList","","","")
Query GetList(rowid As %String, personid As %String, code As %String, personno As %String) As %Query(ROWSPEC = "ID,EMPORGDesc,EMPPAPersonCode,EMPPAPersonName,EMPPAPersonNo,EMPJoinDate,EMPStatus,EMPSeparationDate,EMPActivity,EMPStartDate,EMPEndDate,EMPSeqNo,EMPPYCode,EMPWBCode,EMPMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, personid As %String, code As %String, personno As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
      	s EMPORGDesc="",EMPPAPersonCode="",EMPPAPersonName=""
        s EMPORGCode =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),2) /// 组织代码
        s:EMPORGCode'="" EMPORGDesc=$listget($g(^CT.BDP.CT.HOSOrganizationD(EMPORGCode)),3)
        s EMPPAPersonID =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),3) /// 人员唯一标识码
        s:EMPPAPersonID'="" EMPPAPersonCode=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPAPersonID)),2)
        s:EMPPAPersonID'="" EMPPAPersonName=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPAPersonID)),3)
        s EMPPAPersonNo =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),4) /// 工号
        s EMPJoinDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),5) /// 入职日期
        s:EMPJoinDate'="" EMPJoinDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPJoinDate)
       	s EMPStatus =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),6) /// 工作状态-外键？？
       	s:EMPStatus'="" EMPStatus=$listget($g(^CT.BDP.CT.HOSEmpStatusDictD(EMPStatus)),3)
        s EMPSeparationDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),7) /// 离职日期
        s:EMPSeparationDate'="" EMPSeparationDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPSeparationDate)
        s EMPActivity =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),8) /// 是否有效(Y/N)
        s EMPStartDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),9) /// 开始日期
        s:EMPStartDate'="" EMPStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPStartDate)
        s EMPEndDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),10) /// 结束日期
        s:EMPEndDate'="" EMPEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPEndDate)
        s EMPSeqNo =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),14) /// 系统排序号
        s EMPPYCode =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),18) /// 拼音码
        s EMPWBCode =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),19) /// 五笔码
        s EMPMark =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),20) /// 备注
        
        d OutputRow
    }
    else
    {  
    	
  		s:personno'="" personno=$zcvt(personno,"U")
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSORGEmployeeD(ID))
            q:ID="" 
	      	s EMPORGDesc="",EMPPAPersonCode="",EMPPAPersonName=""
	        s EMPORGCode =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),2) /// 组织代码
	        s:EMPORGCode'="" EMPORGDesc=$listget($g(^CT.BDP.CT.HOSOrganizationD(EMPORGCode)),3)
	        s EMPPAPersonID =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),3) /// 人员唯一标识码
	        s:EMPPAPersonID'="" EMPPAPersonCode=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPAPersonID)),2)
	        s:EMPPAPersonID'="" EMPPAPersonName=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPAPersonID)),3)
	        s EMPPAPersonNo =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),4) /// 工号
	        s EMPJoinDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),5) /// 入职日期
	        s:EMPJoinDate'="" EMPJoinDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPJoinDate)
	       	s EMPStatus =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),6) /// 工作状态-外键？？	
	        s:EMPStatus'="" EMPStatus=$listget($g(^CT.BDP.CT.HOSEmpStatusDictD(EMPStatus)),3)
	        s EMPSeparationDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),7) /// 离职日期
	        s:EMPSeparationDate'="" EMPSeparationDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPSeparationDate)
	        s EMPActivity =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),8) /// 是否有效(Y/N)
	        s EMPStartDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),9) /// 开始日期
	        s:EMPStartDate'="" EMPStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPStartDate)
	        s EMPEndDate =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),10) /// 结束日期
	        s:EMPEndDate'="" EMPEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPEndDate)
	        s EMPSeqNo =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),14) /// 系统排序号
	        s EMPPYCode =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),18) /// 拼音码
	        s EMPWBCode =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),19) /// 五笔码
	        s EMPMark =$listget($g(^CT.BDP.CT.HOSORGEmployeeD(ID)),20) /// 备注
            if ((EMPPAPersonID=personid)||(personid=""))&((EMPORGCode=code)||(code=""))&($zcvt(EMPPAPersonNo,"U")[personno)
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,EMPORGDesc,EMPPAPersonCode,EMPPAPersonName,EMPPAPersonNo,EMPJoinDate,EMPStatus,EMPSeparationDate,EMPActivity,EMPStartDate,EMPEndDate,EMPSeqNo,EMPPYCode,EMPWBCode,EMPMark)
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
/// CreatDate: 2022-11-14
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSORGEmployee).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSORGEmployee).%New()
    s obj = ##class(CT.BDP.CT.HOSORGEmployee).%OpenId(id)
    s eobj.ID=id
  
    s:$IsObject(obj.EMPORGCode) eobj.EMPORGCode = obj.EMPORGCode.%Id()
    s:$IsObject(obj.EMPPAPersonID) eobj.EMPPAPersonID = obj.EMPPAPersonID.%Id()
    s eobj.EMPPAPersonNo= obj.EMPPAPersonNo
    s:obj.EMPJoinDate'="" eobj.EMPJoinDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPJoinDate) 
  	s:$IsObject(obj.EMPStatus) eobj.EMPStatus = obj.EMPStatus.%Id()
    s:obj.EMPSeparationDate'="" eobj.EMPSeparationDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPSeparationDate) 
    s eobj.EMPActivity = obj.EMPActivity 
    s:obj.EMPStartDate'="" eobj.EMPStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPStartDate) 
    s:obj.EMPEndDate'="" eobj.EMPEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPEndDate) 
    s eobj.EMPSeqNo= obj.EMPSeqNo
    s eobj.EMPPYCode= obj.EMPPYCode
    s eobj.EMPWBCode= obj.EMPWBCode
    s eobj.EMPMark= obj.EMPMark
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-14
/// Table：   CT.BDP.CT.HOSORGEmployee
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSORGEmployee).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String, personid As %String) As %String
{
    s flag=0
    if ((code'="")&(personid'="")){
	    s idc=$o(^CT.BDP.CT.HOSORGEmployeeI("IndexMain",code,personid,0)) 
		if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	}
    q flag
}

/// Function    保存内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-14
/// Table：     CT.BDP.CT.HOSORGEmployee
/// Input：     web.Entity.CT.HOSORGEmployee  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSORGEmployee).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSORGEmployee) As %String
{
 
    s result="" 
    s:eobj.EMPJoinDate'="" eobj.EMPJoinDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPJoinDate) 
    s:eobj.EMPSeparationDate'="" eobj.EMPSeparationDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPSeparationDate) 
    s:eobj.EMPStartDate'="" eobj.EMPStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPStartDate) 
    s:eobj.EMPEndDate'="" eobj.EMPEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPEndDate) 
    s:eobj.EMPStartDate="" eobj.EMPStartDate=+$h
    
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s eobj.EMPLastUpdateDate=+$h  ///系统最后更新日期
    s eobj.EMPLastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    if (eobj.EMPLastUpdateUser="") s eobj.EMPLastUpdateUser=USERID  ///系统最新更新人
    s:eobj.EMPActivity="" eobj.EMPActivity="N"		//是否有效
    
    s flag=  ..FormValidate(eobj.ID,eobj.EMPORGCode,eobj.EMPPAPersonID)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSORGEmployee).%New()
            s eobj.EMPCreateDate=+$h  ///系统创建日期
            s eobj.EMPCreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.EMPCreateUser="" eobj.EMPCreateUser=USERID   ///系统创建人
            s obj.EMPCreateDate=eobj.EMPCreateDate
            s obj.EMPCreateTime=eobj.EMPCreateTime
            d obj.EMPCreateUserSetObjectId(eobj.EMPCreateUser)
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSORGEmployee).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSORGEmployee).%New()
            s bobj.ID=eobj.ID 
		    s:$IsObject(obj.EMPORGCode) bobj.EMPORGCode = obj.EMPORGCode.%Id()
		    s:$IsObject(obj.EMPPAPersonID) bobj.EMPPAPersonID = obj.EMPPAPersonID.%Id()
		    s bobj.EMPPAPersonNo= obj.EMPPAPersonNo
		    s:obj.EMPJoinDate'="" bobj.EMPJoinDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPJoinDate) 
		  	s:$IsObject(obj.EMPStatus) bobj.EMPStatus = obj.EMPStatus.%Id()
		    s:obj.EMPSeparationDate'="" bobj.EMPSeparationDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPSeparationDate) 
		    s bobj.EMPActivity = obj.EMPActivity 
		    s:obj.EMPStartDate'="" bobj.EMPStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPStartDate) 
		    s:obj.EMPEndDate'="" bobj.EMPEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPEndDate) 
		    s:obj.EMPCreateDate'="" bobj.EMPCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPCreateDate) 
		    s:obj.EMPCreateTime'="" bobj.EMPCreateTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.EMPCreateTime)
		    s:$IsObject(obj.EMPCreateUser) bobj.EMPCreateUser= obj.EMPCreateUser.%Id()
		    s bobj.EMPSeqNo= obj.EMPSeqNo
		    s:obj.EMPLastUpdateDate'="" bobj.EMPLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPLastUpdateDate) 
		    s bobj.EMPLastUpdateTime= obj.EMPLastUpdateTime
		    s:$IsObject(obj.EMPLastUpdateUser) bobj.EMPLastUpdateUser= obj.EMPLastUpdateUser.%Id()
		    s bobj.EMPPYCode= obj.EMPPYCode
		    s bobj.EMPWBCode= obj.EMPWBCode
		    s bobj.EMPMark= obj.EMPMark
		    
        }
       
	    d:eobj.EMPORGCode'="" obj.EMPORGCodeSetObjectId(eobj.EMPORGCode)
	    d:eobj.EMPPAPersonID'="" obj.EMPPAPersonIDSetObjectId(eobj.EMPPAPersonID)
	    s obj.EMPPAPersonNo= eobj.EMPPAPersonNo 
	    s obj.EMPJoinDate = eobj.EMPJoinDate 
	 	d:eobj.EMPStatus'="" obj.EMPStatusSetObjectId(eobj.EMPStatus)
	    s obj.EMPSeparationDate = eobj.EMPSeparationDate 
	    s obj.EMPActivity = eobj.EMPActivity 
	    s obj.EMPStartDate= eobj.EMPStartDate
	    s obj.EMPEndDate= eobj.EMPEndDate
	    s obj.EMPSeqNo= eobj.EMPSeqNo
	    s obj.EMPLastUpdateDate= eobj.EMPLastUpdateDate
	    s obj.EMPLastUpdateTime= eobj.EMPLastUpdateTime
	    d obj.EMPLastUpdateUserSetObjectId(eobj.EMPLastUpdateUser)
	    s obj.EMPPYCode= eobj.EMPPYCode
	    s obj.EMPWBCode= eobj.EMPWBCode
	    s obj.EMPMark= eobj.EMPMark 
	    
	    
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ORGEmployee","CT.BDP.CT.HOSORGEmployee","组织人员",id,eobj.EMPORGCode,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ORGEmployee","CT.BDP.CT.HOSORGEmployee","组织人员",eobj.ID,eobj.EMPORGCode,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织人员","web.DHCBL.CT.HOSORGEmployee","SaveData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-14
/// Description：根据ID删除内容
/// Table：CT.BDP.CT.HOSORGEmployee
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSORGEmployee).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSORGEmployee).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSORGEmployee).%New()
    s eobj.ID = id
    s:$IsObject(pobj.EMPORGCode) eobj.EMPORGCode = pobj.EMPORGCode.%Id()
    s:$IsObject(pobj.EMPPAPersonID) eobj.EMPPAPersonID = pobj.EMPPAPersonID.%Id()
    s eobj.EMPPAPersonNo= pobj.EMPPAPersonNo
    s:pobj.EMPJoinDate'="" eobj.EMPJoinDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPJoinDate) 
    s:$IsObject(pobj.EMPStatus) eobj.EMPStatus = pobj.EMPStatus.%Id()
    s:pobj.EMPSeparationDate'="" eobj.EMPSeparationDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPSeparationDate) 
    s eobj.EMPActivity = pobj.EMPActivity 
    s:pobj.EMPStartDate'="" eobj.EMPStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPStartDate) 
    s:pobj.EMPEndDate'="" eobj.EMPEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPEndDate) 
    s:pobj.EMPCreateDate'="" eobj.EMPCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPCreateDate) 
    s eobj.EMPCreateTime= pobj.EMPCreateTime
    s:$IsObject(pobj.EMPCreateUser) eobj.EMPCreateUser= pobj.EMPCreateUser.%Id()
    s eobj.EMPSeqNo= pobj.EMPSeqNo
    s:pobj.EMPLastUpdateDate'="" eobj.EMPLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPLastUpdateDate) 
    s eobj.EMPLastUpdateTime= pobj.EMPLastUpdateTime
    s:$IsObject(pobj.EMPLastUpdateUser) eobj.EMPLastUpdateUser= pobj.EMPLastUpdateUser.%Id()
    s eobj.EMPPYCode= pobj.EMPPYCode
    s eobj.EMPWBCode= pobj.EMPWBCode
    s eobj.EMPMark= pobj.EMPMark
    
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSORGEmployee).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ORGEmployee","CT.BDP.CT.HOSORGEmployee","组织人员",id,eobj.EMPORGCode,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织人员","web.DHCBL.CT.HOSORGEmployee","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}

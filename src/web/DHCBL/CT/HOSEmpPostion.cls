/// Function: HOS 人员职位表
/// CreateDate:2022-11-14
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSEmpPostion Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  人员职位查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-14
/// Table：     CT_BDP_CT.HOS_EmpPostion   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSEmpPostion","GetList","","2")
Query GetList(rowid As %String, personid As %String, deptcode As %String, poscode As %String) As %Query(ROWSPEC = "ID,EMPPOSPAPersonDesc,EMPPOSORGDesc,EMPPOSPOSDesc,EMPPOSAppointDate,EMPPOSRemoveDate,EMPPOSStatus,EMPPOSAdminFlag,EMPPOSActivity,EMPPOSStartDate,EMPPOSEndDate,EMPPOSSeqNo,EMPPOSPYCode,EMPPOSWBCode,EMPPOSMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, personid As %String, deptcode As %String, poscode As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
      	s ID=rowid
      	s EMPPOSPAPersonDesc="",EMPPOSORGDesc="",EMPPOSPOSDesc=""
      	s EMPPOSPAPersonID =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),2) /// 人员唯一标识码
      	s:EMPPOSPAPersonID'="" EMPPOSPAPersonDesc=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPOSPAPersonID)),3)
      	s EMPPOSDeptCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),3) /// 组织部门代码
      	s:EMPPOSDeptCode'="" EMPPOSORGDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(EMPPOSDeptCode)),3)
        s EMPPOSPOSCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),4) /// 职位代码
        s:EMPPOSPOSCode'="" EMPPOSPOSDesc=$listget($g(^CT.BDP.CT.HOSPositionD(EMPPOSPOSCode)),3)
        s EMPPOSAppointDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),5) /// 任职日期
        s:EMPPOSAppointDate'="" EMPPOSAppointDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSAppointDate)
        s EMPPOSRemoveDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),6) /// 免职日期
        s:EMPPOSRemoveDate'="" EMPPOSRemoveDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSRemoveDate)
        s EMPPOSStatus =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),7) /// 任职状态 -外键？？
        s EMPPOSAdminFlag =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),8) /// 是否行政归属部门
        s EMPPOSActivity =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),9) /// 是否有效(Y/N)
        s EMPPOSStartDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),10) /// 开始日期
        s:EMPPOSStartDate'="" EMPPOSStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSStartDate)
        s EMPPOSEndDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),11) /// 结束日期
        s:EMPPOSEndDate'="" EMPPOSEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSEndDate)
        s EMPPOSSeqNo =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),15) /// 系统排序号
        s EMPPOSPYCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),19) /// 拼音码
        s EMPPOSWBCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),20) /// 五笔码
        s EMPPOSMark =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),21) /// 备注
        
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSEmpPostionI("IndexPAPersonID",personid,ID)) q:ID=""
	      	s EMPPOSPAPersonDesc="",EMPPOSORGDesc="",EMPPOSPOSDesc=""
	      	s EMPPOSPAPersonID =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),2) /// 人员唯一标识码
	      	s:EMPPOSPAPersonID'="" EMPPOSPAPersonDesc=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPOSPAPersonID)),3)
	      	s EMPPOSDeptCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),3) /// 组织部门代码
	      	s:EMPPOSDeptCode'="" EMPPOSORGDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(EMPPOSDeptCode)),3)
	        s EMPPOSPOSCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),4) /// 职位代码
	        s:EMPPOSPOSCode'="" EMPPOSPOSDesc=$listget($g(^CT.BDP.CT.HOSPositionD(EMPPOSPOSCode)),3)
	        s EMPPOSAppointDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),5) /// 任职日期
	        s:EMPPOSAppointDate'="" EMPPOSAppointDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSAppointDate)
	        s EMPPOSRemoveDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),6) /// 免职日期
	        s:EMPPOSRemoveDate'="" EMPPOSRemoveDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSRemoveDate)
	        s EMPPOSStatus =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),7) /// 任职状态 -外键？？
	        s EMPPOSAdminFlag =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),8) /// 是否行政归属部门
	        s EMPPOSActivity =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),9) /// 是否有效(Y/N)
	        s EMPPOSStartDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),10) /// 开始日期
	        s:EMPPOSStartDate'="" EMPPOSStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSStartDate)
	        s EMPPOSEndDate =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),11) /// 结束日期
	        s:EMPPOSEndDate'="" EMPPOSEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSEndDate)
	        s EMPPOSSeqNo =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),15) /// 系统排序号
	        s EMPPOSPYCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),19) /// 拼音码
	        s EMPPOSWBCode =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),20) /// 五笔码
	        s EMPPOSMark =$listget($g(^CT.BDP.CT.HOSEmpPostionD(ID)),21) /// 备注
            if (((EMPPOSDeptCode=deptcode)||(deptcode=""))&((EMPPOSPOSCode=poscode)||(poscode="")))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,EMPPOSPAPersonDesc,EMPPOSORGDesc,EMPPOSPOSDesc,EMPPOSAppointDate,EMPPOSRemoveDate,EMPPOSStatus,EMPPOSAdminFlag,EMPPOSActivity,EMPPOSStartDate,EMPPOSEndDate,EMPPOSSeqNo,EMPPOSPYCode,EMPPOSWBCode,EMPPOSMark)
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
/// Other:     w ##class(web.DHCBL.CT.HOSEmpPostion).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSEmpPostion).%New()
    s obj = ##class(CT.BDP.CT.HOSEmpPostion).%OpenId(id)
    s eobj.ID=id
    s:$IsObject(obj.EMPPOSPAPersonID) eobj.EMPPOSPAPersonID = obj.EMPPOSPAPersonID.%Id()
    s:$IsObject(obj.EMPPOSDeptCode) eobj.EMPPOSDeptCode = obj.EMPPOSDeptCode.%Id()
    s:$IsObject(obj.EMPPOSPOSCode) eobj.EMPPOSPOSCode = obj.EMPPOSPOSCode.%Id()
    s:obj.EMPPOSAppointDate'="" eobj.EMPPOSAppointDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSAppointDate) 
    s:obj.EMPPOSRemoveDate'="" eobj.EMPPOSRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSRemoveDate) 
    s eobj.EMPPOSStatus = obj.EMPPOSStatus 
    s eobj.EMPPOSAdminFlag= obj.EMPPOSAdminFlag
    s eobj.EMPPOSActivity = obj.EMPPOSActivity 
    s:obj.EMPPOSStartDate'="" eobj.EMPPOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSStartDate) 
    s:obj.EMPPOSEndDate'="" eobj.EMPPOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSEndDate) 
    s eobj.EMPPOSSeqNo= obj.EMPPOSSeqNo
    s eobj.EMPPOSPYCode= obj.EMPPOSPYCode
    s eobj.EMPPOSWBCode= obj.EMPPOSWBCode
    s eobj.EMPPOSMark= obj.EMPPOSMark
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-14
/// Table：   CT.BDP.CT.HOSEmpPostion
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSEmpPostion).FormValidate("2","2","2","1")
ClassMethod FormValidate(id As %String, PAPersonID As %String, DeptCode As %String, POSCode As %String) As %String
{
    s flag=0
    if ((PAPersonID'="")&(DeptCode'="")&(POSCode'="")){
	    s idc=$o(^CT.BDP.CT.HOSEmpPostionI("IndexCode",PAPersonID,DeptCode,POSCode,0)) 
		if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	}
    q flag
}

/// Function    保存内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-14
/// Table：     CT.BDP.CT.HOSEmpPostion
/// Input：     web.Entity.CT.HOSEmpPostion  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSEmpPostion).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSEmpPostion) As %String
{
 
    s result="" 
    s:eobj.EMPPOSAppointDate'="" eobj.EMPPOSAppointDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSAppointDate) 
    s:eobj.EMPPOSRemoveDate'="" eobj.EMPPOSRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSRemoveDate) 
    s:eobj.EMPPOSStartDate'="" eobj.EMPPOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSStartDate) 
    s:eobj.EMPPOSEndDate'="" eobj.EMPPOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSEndDate) 
    s:eobj.EMPPOSStartDate="" eobj.EMPPOSStartDate=+$h
    
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s eobj.EMPPOSLastUpdateDate=+$h  ///系统最后更新日期
    s eobj.EMPPOSLastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    if (eobj.EMPPOSLastUpdateUser="") s eobj.EMPPOSLastUpdateUser=USERID  ///系统最新更新人
    s:eobj.EMPPOSActivity="" eobj.EMPPOSActivity="N"		//是否有效
    
    s flag=  ..FormValidate(eobj.ID,eobj.EMPPOSPAPersonID,eobj.EMPPOSDeptCode,eobj.EMPPOSPOSCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSEmpPostion).%New()
            s eobj.EMPPOSCreateDate=+$h  ///系统创建日期
            s eobj.EMPPOSCreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.EMPPOSCreateUser="" eobj.EMPPOSCreateUser=USERID   ///系统创建人
            s obj.EMPPOSCreateDate=eobj.EMPPOSCreateDate
            s obj.EMPPOSCreateTime=eobj.EMPPOSCreateTime
            d obj.EMPPOSCreateUserSetObjectId(eobj.EMPPOSCreateUser)
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSEmpPostion).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSEmpPostion).%New()
            s bobj.ID=eobj.ID 
		    s:$IsObject(obj.EMPPOSPAPersonID) bobj.EMPPOSPAPersonID = obj.EMPPOSPAPersonID.%Id()
		    s:$IsObject(obj.EMPPOSDeptCode) bobj.EMPPOSDeptCode = obj.EMPPOSDeptCode.%Id()
		    s:$IsObject(obj.EMPPOSPOSCode) bobj.EMPPOSPOSCode = obj.EMPPOSPOSCode.%Id()
		    s:obj.EMPPOSAppointDate'="" bobj.EMPPOSAppointDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSAppointDate) 
		    s:obj.EMPPOSRemoveDate'="" bobj.EMPPOSRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSRemoveDate) 
		    s bobj.EMPPOSStatus = obj.EMPPOSStatus 
		    s bobj.EMPPOSAdminFlag= obj.EMPPOSAdminFlag
		    s bobj.EMPPOSActivity = obj.EMPPOSActivity 
		    s:obj.EMPPOSStartDate'="" bobj.EMPPOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSStartDate) 
		    s:obj.EMPPOSEndDate'="" bobj.EMPPOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSEndDate) 
		    s:obj.EMPPOSCreateDate'="" bobj.EMPPOSCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSCreateDate) 
		    s:obj.EMPPOSCreateTime'="" bobj.EMPPOSCreateTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.EMPPOSCreateTime) 
		    s:$IsObject(obj.EMPPOSCreateUser) bobj.EMPPOSCreateUser= obj.EMPPOSCreateUser.%Id()
		    s bobj.EMPPOSSeqNo= obj.EMPPOSSeqNo
		    s:obj.EMPPOSLastUpdateDate'="" bobj.EMPPOSLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSLastUpdateDate) 
		    s bobj.EMPPOSLastUpdateTime= obj.EMPPOSLastUpdateTime
		    s:$IsObject(obj.EMPPOSLastUpdateUser) bobj.EMPPOSLastUpdateUser= obj.EMPPOSLastUpdateUser.%Id()
		    s bobj.EMPPOSPYCode= obj.EMPPOSPYCode
		    s bobj.EMPPOSWBCode= obj.EMPPOSWBCode
		    s bobj.EMPPOSMark= obj.EMPPOSMark
		    
        }

	    d:eobj.EMPPOSPAPersonID'="" obj.EMPPOSPAPersonIDSetObjectId(eobj.EMPPOSPAPersonID)
	    d:eobj.EMPPOSDeptCode'="" obj.EMPPOSDeptCodeSetObjectId(eobj.EMPPOSDeptCode)
	    d:eobj.EMPPOSPOSCode'="" obj.EMPPOSPOSCodeSetObjectId(eobj.EMPPOSPOSCode)
	    s obj.EMPPOSAppointDate = eobj.EMPPOSAppointDate 
	    s obj.EMPPOSRemoveDate = eobj.EMPPOSRemoveDate 
	    s obj.EMPPOSStatus = eobj.EMPPOSStatus 
	    s obj.EMPPOSAdminFlag= eobj.EMPPOSAdminFlag 
	    s obj.EMPPOSActivity = eobj.EMPPOSActivity 
	    s obj.EMPPOSStartDate= eobj.EMPPOSStartDate
	    s obj.EMPPOSEndDate= eobj.EMPPOSEndDate
	    s obj.EMPPOSSeqNo= eobj.EMPPOSSeqNo
	    s obj.EMPPOSLastUpdateDate= eobj.EMPPOSLastUpdateDate
	    s obj.EMPPOSLastUpdateTime= eobj.EMPPOSLastUpdateTime
	    d obj.EMPPOSLastUpdateUserSetObjectId(eobj.EMPPOSLastUpdateUser)
	    s obj.EMPPOSPYCode= eobj.EMPPOSPYCode
	    s obj.EMPPOSWBCode= eobj.EMPPOSWBCode
	    s obj.EMPPOSMark= eobj.EMPPOSMark 
	    
	    
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpPostion","CT.BDP.CT.HOSEmpPostion","人员职位",id,eobj.EMPPOSPOSCode,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpPostion","CT.BDP.CT.HOSEmpPostion","人员职位",eobj.ID,eobj.EMPPOSPOSCode,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员职位","web.DHCBL.CT.HOSEmpPostion","SaveData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-14
/// Description：根据ID删除内容
/// Table：CT.BDP.CT.HOSEmpPostion
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSEmpPostion).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSEmpPostion).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSEmpPostion).%New()
    s eobj.ID = id
    s:pobj.EMPPOSPAPersonID'="" eobj.EMPPOSPAPersonID = pobj.EMPPOSPAPersonID.%Id()
    s:pobj.EMPPOSDeptCode'="" eobj.EMPPOSDeptCode = pobj.EMPPOSDeptCode.%Id()
    s:pobj.EMPPOSPOSCode'="" eobj.EMPPOSPOSCode = pobj.EMPPOSPOSCode.%Id()
    s:pobj.EMPPOSAppointDate'="" eobj.EMPPOSAppointDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSAppointDate) 
    s:pobj.EMPPOSRemoveDate'="" eobj.EMPPOSRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSRemoveDate) 
    s eobj.EMPPOSStatus = pobj.EMPPOSStatus 
    s eobj.EMPPOSAdminFlag= pobj.EMPPOSAdminFlag
    s eobj.EMPPOSActivity = pobj.EMPPOSActivity 
    s:pobj.EMPPOSStartDate'="" eobj.EMPPOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSStartDate) 
    s:pobj.EMPPOSEndDate'="" eobj.EMPPOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSEndDate) 
    s:pobj.EMPPOSCreateDate'="" eobj.EMPPOSCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSCreateDate) 
    s eobj.EMPPOSCreateTime= pobj.EMPPOSCreateTime
    s:$IsObject(pobj.EMPPOSCreateUser) eobj.EMPPOSCreateUser= pobj.EMPPOSCreateUser.%Id()
    s eobj.EMPPOSSeqNo= pobj.EMPPOSSeqNo
    s:pobj.EMPPOSLastUpdateDate'="" eobj.EMPPOSLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSLastUpdateDate) 
    s eobj.EMPPOSLastUpdateTime= pobj.EMPPOSLastUpdateTime
    s:$IsObject(pobj.EMPPOSLastUpdateUser) eobj.EMPPOSLastUpdateUser= pobj.EMPPOSLastUpdateUser.%Id()
    s eobj.EMPPOSPYCode= pobj.EMPPOSPYCode
    s eobj.EMPPOSWBCode= pobj.EMPPOSWBCode
    s eobj.EMPPOSMark= pobj.EMPPOSMark
    
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSEmpPostion).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpPostion","CT.BDP.CT.HOSEmpPostion","人员职位",id,eobj.EMPPOSPOSCode,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员职位","web.DHCBL.CT.HOSEmpPostion","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}

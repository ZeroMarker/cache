/// Function: HOS 人员职务表
/// CreateDate:2022-11-15
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSEmpProfTitle Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  人员职务查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-15
/// Table：     CT_BDP_CT.HOS_EmpProfTitle   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSEmpProfTitle","GetList","","2","")
Query GetList(rowid As %String, personid As %String, deptcode As %String, proftcode As %String) As %Query(ROWSPEC = "ID,EMPPROFPAPersonDesc,EMPPROFORGDesc,EMPPROFPROFTDesc,EMPPROFEngageDate,EMPPROFRemoveDate,EMPPROFStatus,EMPPROFActivity,EMPPROFStartDate,EMPPROFEndDate,EMPPROFSeqNo,EMPPROFPYCode,EMPPROFWBCode,EMPPROFMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, personid As %String, deptcode As %String, proftcode As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
      	s ID=rowid
      	s EMPPROFPAPersonDesc="",EMPPROFORGDesc="",EMPPROFPROFTDesc=""
      	s EMPPROFPAPersonID =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),2) /// 人员唯一标识码
      	s:EMPPROFPAPersonID'="" EMPPROFPAPersonDesc=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPROFPAPersonID)),3)
      	s EMPPROFDeptCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),3) /// 组织部门代码
      	s:EMPPROFDeptCode'="" EMPPROFORGDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(EMPPROFDeptCode)),3)
        s EMPPROFPROFTCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),4) /// 部门职务代码
        s:EMPPROFPROFTCode'="" EMPPROFPROFTDesc=$listget($g(^CT.BDP.CT.HOSProfTitleD(EMPPROFPROFTCode)),3)
        s EMPPROFEngageDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),5) /// 聘用日期
        s:EMPPROFEngageDate'="" EMPPROFEngageDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFEngageDate)
        s EMPPROFRemoveDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),6) /// 解聘日期
        s:EMPPROFRemoveDate'="" EMPPROFRemoveDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFRemoveDate)
        s EMPPROFStatus =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),7) /// 任职状态 -外键？？										
        s EMPPROFActivity =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),8) /// 是否有效(Y/N)
        s EMPPROFStartDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),9) /// 开始日期
        s:EMPPROFStartDate'="" EMPPROFStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFStartDate)
        s EMPPROFEndDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),10) /// 结束日期
        s:EMPPROFEndDate'="" EMPPROFEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFEndDate)
        s EMPPROFSeqNo =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),14) /// 系统排序号
        s EMPPROFPYCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),18) /// 拼音码
        s EMPPROFWBCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),19) /// 五笔码
        s EMPPROFMark =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),20) /// 备注
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSEmpProfTitleI("IndexPAPersonID",personid,ID)) q:ID="" 
	      	s EMPPROFPAPersonDesc="",EMPPROFORGDesc="",EMPPROFPROFTDesc=""
	      	s EMPPROFPAPersonID =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),2) /// 人员唯一标识码
	      	s:EMPPROFPAPersonID'="" EMPPROFPAPersonDesc=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPROFPAPersonID)),3)
	      	s EMPPROFDeptCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),3) /// 组织部门代码
	      	s:EMPPROFDeptCode'="" EMPPROFORGDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(EMPPROFDeptCode)),3)
	        s EMPPROFPROFTCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),4) /// 部门职务代码
	        s:EMPPROFPROFTCode'="" EMPPROFPROFTDesc=$listget($g(^CT.BDP.CT.HOSProfTitleD(EMPPROFPROFTCode)),3)
	        s EMPPROFEngageDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),5) /// 聘用日期
	        s:EMPPROFEngageDate'="" EMPPROFEngageDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFEngageDate)
	        s EMPPROFRemoveDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),6) /// 解聘日期
	        s:EMPPROFRemoveDate'="" EMPPROFRemoveDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFRemoveDate)
	        s EMPPROFStatus =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),7) /// 任职状态 -外键？？										
	        s EMPPROFActivity =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),8) /// 是否有效(Y/N)
	        s EMPPROFStartDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),9) /// 开始日期
	        s:EMPPROFStartDate'="" EMPPROFStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFStartDate)
	        s EMPPROFEndDate =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),10) /// 结束日期
	        s:EMPPROFEndDate'="" EMPPROFEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPROFEndDate)
	        s EMPPROFSeqNo =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),14) /// 系统排序号
	        s EMPPROFPYCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),18) /// 拼音码
	        s EMPPROFWBCode =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),19) /// 五笔码
	        s EMPPROFMark =$listget($g(^CT.BDP.CT.HOSEmpProfTitleD(ID)),20) /// 备注
            if (((EMPPROFDeptCode=deptcode)||(deptcode=""))&((EMPPROFPROFTCode=proftcode)||(proftcode="")))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,EMPPROFPAPersonDesc,EMPPROFORGDesc,EMPPROFPROFTDesc,EMPPROFEngageDate,EMPPROFRemoveDate,EMPPROFStatus,EMPPROFActivity,EMPPROFStartDate,EMPPROFEndDate,EMPPROFSeqNo,EMPPROFPYCode,EMPPROFWBCode,EMPPROFMark)
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
/// CreatDate: 2022-11-15
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSEmpProfTitle).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSEmpProfTitle).%New()
    s obj = ##class(CT.BDP.CT.HOSEmpProfTitle).%OpenId(id)
    s eobj.ID=id
    s:$IsObject(obj.EMPPROFPAPersonID) eobj.EMPPROFPAPersonID = obj.EMPPROFPAPersonID.%Id()
    s:$IsObject(obj.EMPPROFDeptCode) eobj.EMPPROFDeptCode = obj.EMPPROFDeptCode.%Id()
    s:$IsObject(obj.EMPPROFPROFTCode) eobj.EMPPROFPROFTCode = obj.EMPPROFPROFTCode.%Id()
    s:obj.EMPPROFEngageDate'="" eobj.EMPPROFEngageDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFEngageDate) 
    s:obj.EMPPROFRemoveDate'="" eobj.EMPPROFRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFRemoveDate) 
    s eobj.EMPPROFStatus = obj.EMPPROFStatus
    s eobj.EMPPROFActivity = obj.EMPPROFActivity 
    s:obj.EMPPROFStartDate'="" eobj.EMPPROFStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFStartDate) 
    s:obj.EMPPROFEndDate'="" eobj.EMPPROFEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFEndDate) 
    s eobj.EMPPROFSeqNo= obj.EMPPROFSeqNo
    s eobj.EMPPROFPYCode= obj.EMPPROFPYCode
    s eobj.EMPPROFWBCode= obj.EMPPROFWBCode
    s eobj.EMPPROFMark= obj.EMPPROFMark
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-15
/// Table：   CT.BDP.CT.HOSEmpProfTitle
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSEmpProfTitle).FormValidate("2||2","2","1")
ClassMethod FormValidate(id As %String, PAPersonID As %String, DeptCode As %String, PROFTCode As %String) As %String
{
    s flag=0
    if ((PAPersonID'="")&(DeptCode'="")&(PROFTCode'="")){
	    s idc=$o(^CT.BDP.CT.HOSEmpProfTitleI("IndexCode",PAPersonID,DeptCode,PROFTCode,0)) 
		if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	}
    q flag
}

/// Function    保存内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-15
/// Table：     CT.BDP.CT.HOSEmpProfTitle
/// Input：     web.Entity.CT.HOSEmpProfTitle  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSEmpProfTitle).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSEmpProfTitle) As %String
{
    s result="" 
    
    s:eobj.EMPPROFEngageDate'="" eobj.EMPPROFEngageDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPROFEngageDate) 
    s:eobj.EMPPROFRemoveDate'="" eobj.EMPPROFRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPROFRemoveDate) 
    s:eobj.EMPPROFStartDate'="" eobj.EMPPROFStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPROFStartDate) 
    s:eobj.EMPPROFEndDate'="" eobj.EMPPROFEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPROFEndDate) 
    s:eobj.EMPPROFStartDate="" eobj.EMPPROFStartDate=+$h
    
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s eobj.EMPPROFLastUpdateDate=+$h  ///系统最后更新日期
    s eobj.EMPPROFLastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    if (eobj.EMPPROFLastUpdateUser="") s eobj.EMPPROFLastUpdateUser=USERID  ///系统最新更新人
    s:eobj.EMPPROFActivity="" eobj.EMPPROFActivity="N"		//是否有效
    
    s flag=  ..FormValidate(eobj.ID,eobj.EMPPROFPAPersonID,eobj.EMPPROFDeptCode,eobj.EMPPROFPROFTCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSEmpProfTitle).%New()
            s eobj.EMPPROFCreateDate=+$h  ///系统创建日期
            s eobj.EMPPROFCreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.EMPPROFCreateUser="" eobj.EMPPROFCreateUser=USERID   ///系统创建人
            s obj.EMPPROFCreateDate=eobj.EMPPROFCreateDate
            s obj.EMPPROFCreateTime=eobj.EMPPROFCreateTime
            d obj.EMPPROFCreateUserSetObjectId(eobj.EMPPROFCreateUser)
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSEmpProfTitle).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSEmpProfTitle).%New()
            s bobj.ID=eobj.ID 
		    s:$IsObject(obj.EMPPROFPAPersonID) bobj.EMPPROFPAPersonID = obj.EMPPROFPAPersonID.%Id()
		    s:$IsObject(obj.EMPPROFDeptCode) bobj.EMPPROFDeptCode = obj.EMPPROFDeptCode.%Id()
		    s:$IsObject(obj.EMPPROFPROFTCode) bobj.EMPPROFPROFTCode = obj.EMPPROFPROFTCode.%Id()
		    s:obj.EMPPROFEngageDate'="" bobj.EMPPROFEngageDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFEngageDate) 
		    s:obj.EMPPROFRemoveDate'="" bobj.EMPPROFRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFRemoveDate) 
		    s bobj.EMPPROFStatus = obj.EMPPROFStatus
		    s bobj.EMPPROFActivity = obj.EMPPROFActivity 
		    s:obj.EMPPROFStartDate'="" bobj.EMPPROFStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFStartDate) 
		    s:obj.EMPPROFEndDate'="" bobj.EMPPROFEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFEndDate) 
		    s:obj.EMPPROFCreateDate'="" bobj.EMPPROFCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFCreateDate) 
		    s:obj.EMPPROFCreateTime'="" bobj.EMPPROFCreateTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.EMPPROFCreateTime)
		    s:$IsObject(obj.EMPPROFCreateUser) bobj.EMPPROFCreateUser= obj.EMPPROFCreateUser.%Id()
		    s bobj.EMPPROFSeqNo= obj.EMPPROFSeqNo
		    s:obj.EMPPROFLastUpdateDate'="" bobj.EMPPROFLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPROFLastUpdateDate) 
		    s bobj.EMPPROFLastUpdateTime= obj.EMPPROFLastUpdateTime
		    s:$IsObject(obj.EMPPROFLastUpdateUser) bobj.EMPPROFLastUpdateUser= obj.EMPPROFLastUpdateUser.%Id()
		    s bobj.EMPPROFPYCode= obj.EMPPROFPYCode
		    s bobj.EMPPROFWBCode= obj.EMPPROFWBCode
		    s bobj.EMPPROFMark= obj.EMPPROFMark
        }
       
	    d:eobj.EMPPROFPAPersonID'="" obj.EMPPROFPAPersonIDSetObjectId(eobj.EMPPROFPAPersonID)
	    d:eobj.EMPPROFDeptCode'="" obj.EMPPROFDeptCodeSetObjectId(eobj.EMPPROFDeptCode)
	    d:eobj.EMPPROFPROFTCode'="" obj.EMPPROFPROFTCodeSetObjectId(eobj.EMPPROFPROFTCode)
	    s obj.EMPPROFEngageDate = eobj.EMPPROFEngageDate 
	    s obj.EMPPROFRemoveDate = eobj.EMPPROFRemoveDate 
	    s obj.EMPPROFStatus=eobj.EMPPROFStatus 
	    s obj.EMPPROFActivity = eobj.EMPPROFActivity 
	    s obj.EMPPROFStartDate= eobj.EMPPROFStartDate
	    s obj.EMPPROFEndDate= eobj.EMPPROFEndDate
	    s obj.EMPPROFSeqNo= eobj.EMPPROFSeqNo
	    s obj.EMPPROFLastUpdateDate= eobj.EMPPROFLastUpdateDate
	    s obj.EMPPROFLastUpdateTime= eobj.EMPPROFLastUpdateTime
	    d obj.EMPPROFLastUpdateUserSetObjectId(eobj.EMPPROFLastUpdateUser)
	    s obj.EMPPROFPYCode= eobj.EMPPROFPYCode
	    s obj.EMPPROFWBCode= eobj.EMPPROFWBCode
	    s obj.EMPPROFMark= eobj.EMPPROFMark 
	    
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpProfTitle","CT.BDP.CT.HOSEmpProfTitle","人员职务",id,eobj.EMPPROFPROFTCode,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpProfTitle","CT.BDP.CT.HOSEmpProfTitle","人员职务",eobj.ID,eobj.EMPPROFPROFTCode,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员职务","web.DHCBL.CT.HOSEmpProfTitle","SaveData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-15
/// Description：根据ID删除内容
/// Table：CT.BDP.CT.HOSEmpProfTitle
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSEmpProfTitle).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSEmpProfTitle).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSEmpProfTitle).%New()
    s eobj.ID = id
    s:$IsObject(pobj.EMPPROFPAPersonID) eobj.EMPPROFPAPersonID = pobj.EMPPROFPAPersonID.%Id()
    s:$IsObject(pobj.EMPPROFDeptCode) eobj.EMPPROFDeptCode = pobj.EMPPROFDeptCode.%Id()
    s:$IsObject(pobj.EMPPROFPROFTCode) eobj.EMPPROFPROFTCode = pobj.EMPPROFPROFTCode.%Id()
    s:pobj.EMPPROFEngageDate'="" eobj.EMPPROFEngageDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPROFEngageDate) 
    s:pobj.EMPPROFRemoveDate'="" eobj.EMPPROFRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPROFRemoveDate) 
    s eobj.EMPPROFStatus = pobj.EMPPROFStatus
    s eobj.EMPPROFActivity = pobj.EMPPROFActivity 
    s:pobj.EMPPROFStartDate'="" eobj.EMPPROFStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPROFStartDate) 
    s:pobj.EMPPROFEndDate'="" eobj.EMPPROFEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPROFEndDate) 
    s:pobj.EMPPROFCreateDate'="" eobj.EMPPROFCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPROFCreateDate) 
    s eobj.EMPPROFCreateTime= pobj.EMPPROFCreateTime
    s:$IsObject(pobj.EMPPROFCreateUser) eobj.EMPPROFCreateUser= pobj.EMPPROFCreateUser.%Id()
    s eobj.EMPPROFSeqNo= pobj.EMPPROFSeqNo
    s:pobj.EMPPROFLastUpdateDate'="" eobj.EMPPROFLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPROFLastUpdateDate) 
    s eobj.EMPPROFLastUpdateTime= pobj.EMPPROFLastUpdateTime
    s:$IsObject(pobj.EMPPROFLastUpdateUser) eobj.EMPPROFLastUpdateUser= pobj.EMPPROFLastUpdateUser.%Id()
    s eobj.EMPPROFPYCode= pobj.EMPPROFPYCode
    s eobj.EMPPROFWBCode= pobj.EMPPROFWBCode
    s eobj.EMPPROFMark= pobj.EMPPROFMark
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSEmpProfTitle).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpProfTitle","CT.BDP.CT.HOSEmpProfTitle","人员职务",id,eobj.EMPPROFPROFTCode,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员职务","web.DHCBL.CT.HOSEmpProfTitle","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}

/// Function: HOS 岗位角色字典=岗位关联角色
/// CreateDate:2022-11-16
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSPostRole Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  岗位角色查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-16
/// Table：     CT_BDP_CT.HOS_PostRole   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostRole","GetList","","","")
Query GetList(rowid As %String, code As %String, role As %String) As %Query(ROWSPEC = "ID,POROPOSTDesc,POROROLEDesc,POROActivity,POROStartDate,POROEndDate,POROSeqNo,POROPYCode,POROWBCode,POROMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, role As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
      	s POROPOSTDesc="",POROROLEDesc=""
        s POROPOSTCode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),2) /// 岗位代码
        s:POROPOSTCode'="" POROPOSTDesc=$listget($g(^CT.BDP.CT.HOSPostD(POROPOSTCode)),3)
        s POROROLECode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),3) /// 角色代码
        s:POROROLECode'="" POROROLEDesc=$p($g(^SSU("SSGRP",POROROLECode)),"^",1) 
        s POROActivity =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),4) /// 是否有效(Y/N)
        s POROStartDate =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),5) /// 开始日期
        s:POROStartDate'="" POROStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POROStartDate)
        s POROEndDate =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),6) /// 结束日期
        s:POROEndDate'="" POROEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POROEndDate)
        s POROSeqNo =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),10) /// 系统排序号
        s POROPYCode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),14) /// 拼音码
        s POROWBCode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),15) /// 五笔码
        s POROMark =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),16) /// 备注
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSPostRoleD(ID))
            q:ID="" 
            s POROPOSTDesc="",POROROLEDesc=""
	        s POROPOSTCode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),2) /// 岗位代码
	        s:POROPOSTCode'="" POROPOSTDesc=$listget($g(^CT.BDP.CT.HOSPostD(POROPOSTCode)),3)
	        s POROROLECode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),3) /// 角色代码
	        s:POROROLECode'="" POROROLEDesc=$p($g(^SSU("SSGRP",POROROLECode)),"^",1) 
	        s POROActivity =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),4) /// 是否有效(Y/N)
	        s POROStartDate =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),5) /// 开始日期
	        s:POROStartDate'="" POROStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POROStartDate)
	        s POROEndDate =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),6) /// 结束日期
	        s:POROEndDate'="" POROEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POROEndDate)
	        s POROSeqNo =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),10) /// 系统排序号
	        s POROPYCode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),14) /// 拼音码
	        s POROWBCode =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),15) /// 五笔码
	        s POROMark =$listget($g(^CT.BDP.CT.HOSPostRoleD(ID)),16) /// 备注
            if ((POROPOSTCode=code)||(code=""))&((POROROLECode=role)||(role=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,POROPOSTDesc,POROROLEDesc,POROActivity,POROStartDate,POROEndDate,POROSeqNo,POROPYCode,POROWBCode,POROMark)
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
/// CreatDate: 2022-11-16
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSPostRole).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPostRole).%New()
    s obj = ##class(CT.BDP.CT.HOSPostRole).%OpenId(id)
    s eobj.ID=id
    s:$IsObject(obj.POROPOSTCode) eobj.POROPOSTCode = obj.POROPOSTCode.%Id()
    s:$IsObject(obj.POROROLECode) eobj.POROROLECode = obj.POROROLECode.%Id()
    s eobj.POROActivity = obj.POROActivity 
    s:obj.POROStartDate'="" eobj.POROStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.POROStartDate) 
    s:obj.POROEndDate'="" eobj.POROEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.POROEndDate) 
    s eobj.POROSeqNo= obj.POROSeqNo
    s eobj.POROPYCode= obj.POROPYCode
    s eobj.POROWBCode= obj.POROWBCode
    s eobj.POROMark= obj.POROMark
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-16
/// Table：   CT.BDP.CT.HOSPostRole
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSPostRole).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String, role As %String) As %String
{
    s flag=0
    if ((code'="")&(role'="")){
	    s idc=$o(^CT.BDP.CT.HOSPostRoleI("IndexPOSTROLE",code,role,0)) 
		if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	}
    q flag
}

/// Function    保存内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-16
/// Table：     CT.BDP.CT.HOSPostRole
/// Input：     web.Entity.CT.HOSPostRole  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSPostRole).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPostRole) As %String
{
 
    s result="" 
    s:eobj.POROStartDate'="" eobj.POROStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POROStartDate) 
    s:eobj.POROEndDate'="" eobj.POROEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POROEndDate) 
    s:eobj.POROStartDate="" eobj.POROStartDate=+$h
    
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s eobj.POROLastUpdateDate=+$h  ///系统最后更新日期
    s eobj.POROLastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    if (eobj.POROLastUpdateUser="") s eobj.POROLastUpdateUser=USERID  ///系统最新更新人
    s:eobj.POROActivity="" eobj.POROActivity="N"		//是否有效
    
    s flag=  ..FormValidate(eobj.ID,eobj.POROPOSTCode,eobj.POROROLECode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSPostRole).%New()
            s eobj.POROCreateDate=+$h  ///系统创建日期
            s eobj.POROCreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.POROCreateUser="" eobj.POROCreateUser=USERID   ///系统创建人
            s obj.POROCreateDate=eobj.POROCreateDate
            s obj.POROCreateTime=eobj.POROCreateTime
            d obj.POROCreateUserSetObjectId(eobj.POROCreateUser)
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSPostRole).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSPostRole).%New()
            s bobj.ID=eobj.ID 
		    s:$IsObject(obj.POROPOSTCode) bobj.POROPOSTCode = obj.POROPOSTCode.%Id()
		    s:$IsObject(obj.POROROLECode) bobj.POROROLECode = obj.POROROLECode.%Id()
		    s bobj.POROActivity = obj.POROActivity 
		    s:obj.POROStartDate'="" bobj.POROStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.POROStartDate) 
		    s:obj.POROEndDate'="" bobj.POROEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.POROEndDate) 
		    s:obj.POROCreateDate'="" bobj.POROCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.POROCreateDate) 
		    s bobj.POROCreateTime= obj.POROCreateTime
		    s:$IsObject(obj.POROCreateUser) bobj.POROCreateUser= obj.POROCreateUser.%Id()
		    s bobj.POROSeqNo= obj.POROSeqNo
		    s:obj.POROLastUpdateDate'="" bobj.POROLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.POROLastUpdateDate) 
		    s:obj.POROLastUpdateTime'="" bobj.POROLastUpdateTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.POROLastUpdateTime)
		    s:$IsObject(obj.POROLastUpdateUser) bobj.POROLastUpdateUser= obj.POROLastUpdateUser.%Id()
		    s bobj.POROPYCode= obj.POROPYCode
		    s bobj.POROWBCode= obj.POROWBCode
		    s bobj.POROMark= obj.POROMark
        }
       
	    d:eobj.POROPOSTCode'="" obj.POROPOSTCodeSetObjectId(eobj.POROPOSTCode)
	    d:eobj.POROROLECode'="" obj.POROROLECodeSetObjectId(eobj.POROROLECode)
	    s obj.POROActivity = eobj.POROActivity 
	    s obj.POROStartDate= eobj.POROStartDate
	    s obj.POROEndDate= eobj.POROEndDate
	    s obj.POROSeqNo= eobj.POROSeqNo
	    s obj.POROLastUpdateDate= eobj.POROLastUpdateDate
	    s obj.POROLastUpdateTime= eobj.POROLastUpdateTime
	    d obj.POROLastUpdateUserSetObjectId(eobj.POROLastUpdateUser)
	    s obj.POROPYCode= eobj.POROPYCode
	    s obj.POROWBCode= eobj.POROWBCode
	    s obj.POROMark= eobj.POROMark 
	    
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostRole","CT.BDP.CT.HOSPostRole","岗位角色",id,eobj.POROPOSTCode,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostRole","CT.BDP.CT.HOSPostRole","岗位角色",eobj.ID,eobj.POROPOSTCode,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位角色","web.DHCBL.CT.HOSPostRole","SaveData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-16
/// Description：根据ID删除内容
/// Table：CT.BDP.CT.HOSPostRole
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPostRole).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSPostRole).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSPostRole).%New()
    s eobj.ID = id
    s:$IsObject(pobj.POROPOSTCode) eobj.POROPOSTCode = pobj.POROPOSTCode.%Id()
    s:$IsObject(pobj.POROROLECode) eobj.POROROLECode = pobj.POROROLECode.%Id()
    s eobj.POROActivity = pobj.POROActivity 
    s:pobj.POROStartDate'="" eobj.POROStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.POROStartDate) 
    s:pobj.POROEndDate'="" eobj.POROEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.POROEndDate) 
    s:pobj.POROCreateDate'="" eobj.POROCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.POROCreateDate) 
    s eobj.POROCreateTime= pobj.POROCreateTime
    s:$IsObject(pobj.POROCreateUser) eobj.POROCreateUser= pobj.POROCreateUser.%Id()
    s eobj.POROSeqNo= pobj.POROSeqNo
    s:pobj.POROLastUpdateDate'="" eobj.POROLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.POROLastUpdateDate) 
    s eobj.POROLastUpdateTime= pobj.POROLastUpdateTime
    s:$IsObject(pobj.POROLastUpdateUser) eobj.POROLastUpdateUser= pobj.POROLastUpdateUser.%Id()
    s eobj.POROPYCode= pobj.POROPYCode
    s eobj.POROWBCode= pobj.POROWBCode
    s eobj.POROMark= pobj.POROMark
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSPostRole).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostRole","CT.BDP.CT.HOSPostRole","岗位角色",id,eobj.POROPOSTCode,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位角色","web.DHCBL.CT.HOSPostRole","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}

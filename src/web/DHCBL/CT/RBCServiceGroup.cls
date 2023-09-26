/// CreateDate:2012-08-29
/// Creator:基础数据平台 ，孙凤超
/// Function: 资源预约 服务组维护
/// Tables: RBC_ServiceGroup 
Class web.DHCBL.CT.RBCServiceGroup Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "RBC_ServiceGroup";

/// Function:进行数据检索，查询服务组信息
/// CreateDate:2012-08-29
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: RBC_ServiceGroup 
/// Input: rowid, code, desc, query
/// Output:SG_RowId，SG_Code SG_Desc，SG_PreadmissionCheck， SG_BypassDateCheck， SG_AllowBookAfterDischarge ，SG_DateFrom ，SG_DateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCServiceGroup", "GetList","","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, active1 As %String, active2 As %String, active3 As %String, hospid As %String) As %Query(ROWSPEC = "SGRowId:%String,SGCode:%String,SGDesc:%String,SGPreadmissionCheck:%String,SGBypassDateCheck:%String,SGAllowBookAfterDischarge:%String,SGDateFrom,SGDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active1 As %String, active2 As %String, active3 As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.RBCServiceGroup).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 if (rowid'="")  
 {
   s SGRowId=rowid
   s SGCode=$p($g(^RBC("SG",SGRowId)),"^",1)
   s SGDesc=$p($g(^RBC("SG",SGRowId)),"^",2)
   S SGPreadmissionCheck=$p($g(^RBC("SG",SGRowId)),"^",3)
   S SGBypassDateCheck=$p($g(^RBC("SG",SGRowId)),"^",4)
   s SGAllowBookAfterDischarge=$p($g(^RBC("SG",SGRowId)),"^",5)
   s SGDateFrom=$p($g(^RBC("SG",SGRowId)),"^",6)
   s SGDateTo=$p($g(^RBC("SG",SGRowId)),"^",7)
   s:SGDateFrom'="" SGDateFrom=$zd(SGDateFrom,1)
   s:SGDateTo'="" SGDateTo=$zd(SGDateTo,1)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_ServiceGroup",SGRowId)
   s BDPInternalCode =$p($g(resultStr),"^",1)       
   s BDPInternalDesc = $p($g(resultStr),"^",2)  
   s BDPHospNationalCode=$p($g(resultStr),"^",3)         
   s BDPHospNationalDesc = $p($g(resultStr),"^",4)
   d OutputRow
 }
 else
 {
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   s SGRowId=0
   for
   {
     s SGRowId=$o(^RBC("SG",SGRowId)) q:SGRowId=""  
     s strSGRowId="{ID:"_SGRowId_"}"
     if (AuStr[strSGRowId)||(AuFlag=1)
     {
       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SGRowId,hospid)
       continue:showflag="N"
       s SGCode=$p($g(^RBC("SG",SGRowId)),"^",1)
       s SGDesc=$p($g(^RBC("SG",SGRowId)),"^",2)   
       S SGPreadmissionCheck=$p($g(^RBC("SG",SGRowId)),"^",3)
       S SGBypassDateCheck=$p($g(^RBC("SG",SGRowId)),"^",4)
       s SGAllowBookAfterDischarge=$p($g(^RBC("SG",SGRowId)),"^",5)
       s SGDateFrom=$p($g(^RBC("SG",SGRowId)),"^",6)
       s SGDateTo=$p($g(^RBC("SG",SGRowId)),"^",7)
       s:SGDateFrom'="" SGDateFrom=$zd(SGDateFrom,1)
       s:SGDateTo'="" SGDateTo=$zd(SGDateTo,1)
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_ServiceGroup",SGRowId)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4)
       if (desc'="")
       {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ServiceGroup",SGRowId,SGDesc,desc)
       }
       else
       {
           s AliasFlag=1   
       } 
       if ($ZCVT(SGCode,"U")[code)&(AliasFlag=1)&(SGPreadmissionCheck[active1)&(SGBypassDateCheck[active2)&(SGAllowBookAfterDischarge[active3) 
       {
         d OutputRow
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(SGRowId,SGCode,SGDesc,SGPreadmissionCheck,SGBypassDateCheck,SGAllowBookAfterDischarge,SGDateFrom,SGDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:进行数据检索，为combo提供查询服务组信息的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:RBC_ServiceGroup 
/// Input:  desc 
/// Output:SG_RowId，SG_Code SG_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCServiceGroup", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "SGRowId:%String, SGCode:%String,SGDesc:%String ")
{
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s:code'="" code=$ZCVT(code,"U")  
  s:desc'="" desc=$ZCVT(desc,"U") 
  s AuStr=##class(web.DHCBL.Authorize.RBCServiceGroup).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="")  
  {
   s SGRowId=rowid
   s SGCode=$p($g(^RBC("SG",SGRowId)),"^",1)
   s SGDesc=$p($g(^RBC("SG",SGRowId)),"^",2)
   d OutputRow2
  }
  else
  {
   s SGRowId=0
   for
   {
     s SGRowId=$o(^RBC("SG",SGRowId)) 
     q:SGRowId=""
     s SGDateFrom=$p($g(^RBC("SG",SGRowId)),"^",6)
     continue:(SGDateFrom'="")&&(SGDateFrom>+$h) 
     s SGDateTo=$p($g(^RBC("SG",SGRowId)),"^",7) 
     continue:(SGDateTo'="")&&(SGDateTo<+$h) 
     s strSGRowId="{ID:"_SGRowId_"}"
     if (AuStr[strSGRowId)||(AuFlag=1)
     {
       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SGRowId,hospid)
       continue:showflag="N"
       s SGCode=$p($g(^RBC("SG",SGRowId)),"^",1)
       s SGDesc=$p($g(^RBC("SG",SGRowId)),"^",2)
       if (desc'="")
       {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ServiceGroup",SGRowId,SGDesc,desc)
       }
       else
       {
           s AliasFlag=1   
       } 
       if ($ZCVT(SGCode,"U")[code)&(AliasFlag=1) 
       {
         d OutputRow2
       }
     }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
  set Data=$lb(SGRowId,SGCode,SGDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:显示打开窗口时查询服务组信息
/// CreateDate:2012-08-29
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:RBC_ServiceGroup 
/// Others:w ##class(web.DHCBL.CT.RBCServiceGroup).OpenData("47")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.RBCServiceGroup).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.RBCServiceGroup).%New()
 s eobj.SGRowId=sid
 s eobj.SGCode = pobj.SGCode
 s eobj.SGDesc = pobj.SGDesc
 s:eobj.SGPreadmissionCheck="Y" eobj.SGPreadmissionCheck="true"
 s:eobj.SGBypassDateCheck="Y" eobj.SGBypassDateCheck="true"
 S:eobj.SGAllowBookAfterDischarge="Y" eobj.SGAllowBookAfterDischarge="true"
 s:pobj.SGDateFrom'="" eobj.SGDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SGDateFrom)
 s:pobj.SGDateTo'="" eobj.SGDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SGDateTo)
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator:孙凤超
/// CreatDate:2013-8-27
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 s found1=0
 if ($d(^ARCIM(0,"SERGRP",+id)))  s found1=1
 if (found1=1)  s myInfo=myInfo_"<医嘱项>"
 if (myInfo="")
{
  s return="0^未被引用可删除！"
}
 else 
{
  s return="1^在"_myInfo_"表里被引用,不能删除!"
}
 q return
}

/// Function:实现对查询服务组的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid来删除查询服务组
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: RBC_ServiceGroup 
/// Others:d ##class(web.DHCBL.CT.RBCServiceGroup).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result=""
   Tstart
   s pobj = ##class(User.RBCServiceGroup).%OpenId(id)
   s eobj = ##class(web.Entity.CT.RBCServiceGroup).%New()
   s eobj.SGRowId=id
   s eobj.SGCode = pobj.SGCode
   s eobj.SGDesc = pobj.SGDesc
   s:eobj.SGPreadmissionCheck="Y" eobj.SGPreadmissionCheck="true"
   s:eobj.SGBypassDateCheck="Y" eobj.SGBypassDateCheck="true"
   S:eobj.SGAllowBookAfterDischarge="Y" eobj.SGAllowBookAfterDischarge="true"
   s:pobj.SGDateFrom'="" eobj.SGDateFrom=pobj.SGDateFrom
   s:pobj.SGDateTo'="" eobj.SGDateTo=pobj.SGDateTo
   s re=##class(web.DHCBL.CT.RBCServiceGroup).GetRefFlag(id)
   s RefFlag=$p(re,"^",1)
   if (RefFlag=1)
   { 
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   }
   else
   {
   s sc=##class(User.RBCServiceGroup).%DeleteId(id)
   IF $$$ISOK(sc)
  {
   Tc
   s result="{success:'true',info:'删除成功！'}"
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ServiceGroup","User.RBCServiceGroup","服务组",id,eobj.SGDesc,"D",eobj)
   d eobj.%Close()
  }
 else
 {
   Trollback
   s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("服务组","web.DHCBL.CT.RBCServiceGroup","DeleteData",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
}
 q result
}

/// Function:进行数据的校验功能
/// Creator：基础数据平台 孙凤超
/// CreateDate:2012-11-16
/// Table:RBC_ServiceGroup
/// Input：id, code, desc,hospid(医院id)
/// Others:d ##class(web.DHCBL.CT.RBCServiceGroup).FormValidate("","","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
     s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^RBC("SG",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
	            //2022-12-30限制代码跨院区也不能重复
                //s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
                //continue:showflag="N"
                s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
            s idd=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    q flag
}

/// Function:实现对资源预约查询服务组的修改操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid来资源修改添加预约查询服务组 
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: RBC_ServiceGroup 
/// Others: d ##class(web.DHCBL.CT.RBCServiceGroup).SaveRBCServiceGroup("")
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCServiceGroup) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
    s flag=..FormValidate(eobj.SGRowId,eobj.SGCode,eobj.SGDesc,eobj.LinkHospId)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
      s:eobj.SGDateFrom'="" eobj.SGDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SGDateFrom)  
      s:eobj.SGDateTo'="" eobj.SGDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SGDateTo)      
      s:eobj.SGDateFrom="" eobj.SGDateFrom=+$h
      if (eobj.SGRowId="")       
      {
       s obj=##class(User.RBCServiceGroup).%New()
      }else                           
      {
       //RowId已存在,修改
        s obj=##class(User.RBCServiceGroup).%OpenId(eobj.SGRowId)
        s bobj=##class(web.Entity.CT.RBCServiceGroup).%New()
        s bobj.SGRowId= eobj.SGRowId
        s bobj.SGCode = obj.SGCode                      
        s bobj.SGDesc= obj.SGDesc                      
        s bobj.SGPreadmissionCheck=obj.SGPreadmissionCheck  
        s bobj.SGBypassDateCheck=obj.SGBypassDateCheck 
        s bobj.SGAllowBookAfterDischarge=obj.SGAllowBookAfterDischarge
        s bobj.SGDateFrom=obj.SGDateFrom
        s bobj.SGDateTo=obj.SGDateTo
      }
       s obj.SGCode = eobj.SGCode                      
       s obj.SGDesc= eobj.SGDesc                      
       s:eobj.SGPreadmissionCheck="" eobj.SGPreadmissionCheck="N"
       s obj.SGPreadmissionCheck=eobj.SGPreadmissionCheck
       s:eobj.SGBypassDateCheck="" eobj.SGBypassDateCheck="N"
       s obj.SGBypassDateCheck=eobj.SGBypassDateCheck 
       s:eobj.SGAllowBookAfterDischarge="" eobj.SGAllowBookAfterDischarge="N"
       s obj.SGAllowBookAfterDischarge=eobj.SGAllowBookAfterDischarge
       s obj.SGDateFrom=eobj.SGDateFrom
       s obj.SGDateTo=eobj.SGDateTo
       Tstart
       s sc=obj.%Save()
       if $$$ISOK(sc)
      {
         Tcommit
         s id = obj.%Id()
         s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
         d:eobj.SGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ServiceGroup","User.RBCServiceGroup","服务组",eobj.SGRowId,eobj.SGDesc,"U",eobj,bobj)
         d:eobj.SGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ServiceGroup","User.RBCServiceGroup","服务组",id,eobj.SGDesc,"A",eobj)
       }
       else
       {
         Trollback
         s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
         s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("服务组","web.DHCBL.CT.RBCServiceGroup","SaveEntity",eobj)
         s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
       } 
    }
 }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("服务组","web.DHCBL.CT.RBCServiceGroup","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
  q result
ERROR
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("服务组","web.DHCBL.CT.RBCServiceGroup","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'保存失败！'}"
}

}

/// CreateDate:2012-08-31
/// Creator:基础数据平台 ，孙凤超
/// Function: 资源预约 预约方法维护
Class web.DHCBL.CT.RBCAppointMethod Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，为comb提供查询预约方法的接口 
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: RBC_AppointMethod
/// Input: desc 
/// Output:  APTM_RowId APTM_Code APTM_Desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCAppointMethod","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "APTMRowId:%String, APTMCode:%String,APTMDesc:%String ")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   s AuStr=##class(web.DHCBL.Authorize.RBCAppointMethod).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   if (rowid'="")  
   {
     s APTMRowId=rowid
     s APTMCode=$p($g(^RBC("APTM",APTMRowId)),"^",1)
     s APTMDesc=$p($g(^RBC("APTM",APTMRowId)),"^",2)
     d OutputRow2
   }
  else
  {
   s APTMRowId=0
   for
   {
     s APTMRowId=$o(^RBC("APTM",APTMRowId)) 
     q:APTMRowId=""
     s APTMDateFrom=$p($g(^RBC("APTM",APTMRowId)),"^",4)
     continue:(APTMDateFrom'="")&&(APTMDateFrom>+$h)
     s APTMDateTo=$p($g(^RBC("APTM",APTMRowId)),"^",5)
     continue:(APTMDateTo'="")&&(APTMDateTo<+$h)
     s strAPTMRowId="{ID:"_APTMRowId_"}"
     if (AuStr[strAPTMRowId)||(AuFlag=1)
     {
       s APTMCode=$p($g(^RBC("APTM",APTMRowId)),"^",1)
       s APTMDesc=$p($g(^RBC("APTM",APTMRowId)),"^",2)
       if (desc'="")
       {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_AppointMethod",APTMRowId,APTMDesc,desc)
       }
       else
       {
          s AliasFlag=1   
        } 
       if ($ZCVT(APTMCode,"U")[code)&(AliasFlag=1) 
       {
         d OutputRow2
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(APTMRowId,APTMCode,APTMDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:进行数据检索，查询预约方法 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  RBC_AppointMethod
/// Input:  rowid, code, desc, query
/// Output:  APTM_RowId APTM_Code APTM_Desc APTM_CollectMoney APTM_DateFrom APTM_DateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCAppointMethod","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, active As %String) As %Query(ROWSPEC = "APTMRowId:%String,APTMCode:%String,APTMDesc:%String,APTMCollectMoney:%String,APTMDateFrom:%String,APTMDateTo:%String,APTMAppropriateRegist,APTMRegistRestrict,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.RBCAppointMethod).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s APTMRowId=rowid
   s APTMCode=$p($g(^RBC("APTM",APTMRowId)),"^",1)
   s APTMDesc=$p($g(^RBC("APTM",APTMRowId)),"^",2)
   s APTMCollectMoney=$p($g(^RBC("APTM",APTMRowId)),"^",3)
   s APTMDateFrom=$p($g(^RBC("APTM",APTMRowId)),"^",4)
   s:APTMDateFrom'="" APTMDateFrom=$zd(APTMDateFrom,1)
   s APTMDateTo=$p($g(^RBC("APTM",APTMRowId)),"^",5)
   s:APTMDateTo'="" APTMDateTo=$zd(APTMDateTo,1)
   s APTMAppropriateRegist=$p($g(^RBC("APTM",APTMRowId)),"^",6)
   s APTMRegistRestrict=$p($g(^RBC("APTM",APTMRowId)),"^",7)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_AppointMethod",APTMRowId)
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
   
   s APTMRowId=0
   for
   {
     s APTMRowId=$o(^RBC("APTM",APTMRowId)) q:APTMRowId=""
     s strAPTMRowId="{ID:"_APTMRowId_"}"
     if (AuStr[strAPTMRowId)||(AuFlag=1)
     {
       s APTMCode=$p($g(^RBC("APTM",APTMRowId)),"^",1)
       s APTMDesc=$p($g(^RBC("APTM",APTMRowId)),"^",2) 
       s APTMCollectMoney=$p($g(^RBC("APTM",APTMRowId)),"^",3)
       s APTMDateFrom=$p($g(^RBC("APTM",APTMRowId)),"^",4)
       s:APTMDateFrom'="" APTMDateFrom=$zd(APTMDateFrom,1)
       s APTMDateTo=$p($g(^RBC("APTM",APTMRowId)),"^",5)
       s:APTMDateTo'="" APTMDateTo=$zd(APTMDateTo,1)
       s APTMAppropriateRegist=$p($g(^RBC("APTM",APTMRowId)),"^",6)
       s APTMRegistRestrict=$p($g(^RBC("APTM",APTMRowId)),"^",7)
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_AppointMethod",APTMRowId)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
       if (desc'="")
       {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_AppointMethod",APTMRowId,APTMDesc,desc)
       }
       else
       {
          s AliasFlag=1   
        } 
       if ($ZCVT(APTMCode,"U")[code)&(AliasFlag=1)&(APTMCollectMoney [active) 
       {
          d OutputRow
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(APTMRowId,APTMCode,APTMDesc,APTMCollectMoney,APTMDateFrom,APTMDateTo,APTMAppropriateRegist,APTMRegistRestrict,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:显示预约方法 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables: RBC_AppointMethod
/// Others:w ##class(web.DHCBL.CT.RBCAppointMethod).OpenData("18")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.RBCAppointMethod).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.RBCAppointMethod).%New()
 s eobj.APTMRowId=sid
 s eobj.APTMCode = pobj.APTMCode
 s eobj.APTMDesc = pobj.APTMDesc
 s:eobj.APTMCollectMoney="Y" eobj.APTMCollectMoney="true"
 s:pobj.APTMDateFrom'="" eobj.APTMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.APTMDateFrom)
 s:pobj.APTMDateTo'="" eobj.APTMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.APTMDateTo)
 s eobj.APTMAppropriateRegist=pobj.APTMAppropriateRegist
 s eobj.APTMRegistRestrict=pobj.APTMRegistRestrict
 s:eobj.APTMAppropriateRegist="Y" eobj.APTMAppropriateRegist="true"
 s:eobj.APTMRegistRestrict="Y" eobj.APTMRegistRestrict="true"
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对预约方法的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid号来删除预约方法 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: RBC_AppointMethod
/// Others:d ##class(web.DHCBL.CT.RBCAppointMethod).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s pobj = ##class(User.RBCAppointMethod).%OpenId(id)
    s eobj = ##class(web.Entity.CT.RBCAppointMethod).%New()
    s eobj.APTMRowId=id
    s eobj.APTMCode = pobj.APTMCode
    s eobj.APTMDesc = pobj.APTMDesc
    s:eobj.APTMCollectMoney="Y" eobj.APTMCollectMoney="true"
    s:pobj.APTMDateFrom'="" eobj.APTMDateFrom=pobj.APTMDateFrom
    s:pobj.APTMDateTo'="" eobj.APTMDateTo=pobj.APTMDateTo
    s eobj.APTMAppropriateRegist=pobj.APTMAppropriateRegist
    s eobj.APTMRegistRestrict=pobj.APTMRegistRestrict
    s:eobj.APTMAppropriateRegist="Y" eobj.APTMAppropriateRegist="true"
    s:eobj.APTMRegistRestrict="Y" eobj.APTMRegistRestrict="true"
    s sc=##class(User.RBCAppointMethod).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_AppointMethod","User.RBCAppointMethod","预约方法",id,eobj.APTMDesc,"D",eobj)
      d eobj.%Close()
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("预约方法","web.DHCBL.CT.RBCAppointMethod","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
   q result
}

/// Creator：基础数据平台 孙凤超
/// CreatDate: 2012-11-28
/// Description：数据校验功能
/// Table：RBC_AppointMethod
/// s sc=##class(web.DHCBL.CT.RBCAppointMethod).FormValidate("2","包2","APCVCCode")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
  s flag="",flagc="",flagd=""
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
  s:code'="" flagc=$d(^RBC("APTM",0,"Code",code))
  s:desc'="" flagd=$d(^RBC("APTM",0,"Desc",desc))
  if (id="") //如果为空，增加时的重复判断
 {
   if ((flagc>0)||(flagd>0))
  {
   s flag=1  //返回重复标志
  }
  else
  {
   s flag=0 //返回不重复标志
  }
 }
 else //如果不为空，修改时的重复判断
 {
   s idc=""
   s idd=""
   s:code'="" idc=$o(^RBC("APTM",0,"Code",code,0))
   s:desc'="" idd=$o(^RBC("APTM",0,"Desc",desc,0))
   if (desc="")
  {
    if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
  }
  else
  {
   if (code="")
   {
     if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
   else
   {
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1 //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Function:实现对预约方法的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改预约方法
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: RBC_AppointMethod 
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCAppointMethod) As %String
{
 s result=""
 s $zt="ERROR"
 if $IsObject(eobj)
 {
  s:eobj.APTMDateFrom'="" eobj.APTMDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.APTMDateFrom)  
  s:eobj.APTMDateTo'="" eobj.APTMDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.APTMDateTo)       
  s:eobj.APTMDateFrom="" eobj.APTMDateFrom=+$h
  if (eobj.APTMRowId="")       
  {
   s obj=##class(User.RBCAppointMethod).%New()
  }  
  else    //如果RowId已赋值则修改                 
  {
   s obj=##class(User.RBCAppointMethod).%OpenId(eobj.APTMRowId)
   s bobj=##class(web.Entity.CT.RBCAppointMethod).%New()
   s bobj.APTMRowId=eobj.APTMRowId
   s bobj.APTMCode = obj.APTMCode                       
   s bobj.APTMDesc= obj.APTMDesc                      
   ;s:eobj.APTMCollectMoney="" eobj.APTMCollectMoney="N"
   s bobj.APTMCollectMoney=obj.APTMCollectMoney
   s bobj.APTMDateFrom=obj.APTMDateFrom
   s bobj.APTMDateTo=obj.APTMDateTo
   s bobj.APTMAppropriateRegist=obj.APTMAppropriateRegist
   s bobj.APTMRegistRestrict=obj.APTMRegistRestrict
   s:bobj.APTMAppropriateRegist="Y" bobj.APTMAppropriateRegist="true"
   s:bobj.APTMRegistRestrict="Y" bobj.APTMRegistRestrict="true"
  }
   s obj.APTMCode = eobj.APTMCode                       
   s obj.APTMDesc= eobj.APTMDesc                      
   s:eobj.APTMCollectMoney="" eobj.APTMCollectMoney="N"
   s obj.APTMCollectMoney=eobj.APTMCollectMoney
   s obj.APTMDateFrom=eobj.APTMDateFrom
   s obj.APTMDateTo=eobj.APTMDateTo
   s:eobj.APTMAppropriateRegist="" eobj.APTMAppropriateRegist="N"
   s:eobj.APTMRegistRestrict="" eobj.APTMRegistRestrict="N"
   s obj.APTMAppropriateRegist=eobj.APTMAppropriateRegist
   s obj.APTMRegistRestrict=eobj.APTMRegistRestrict
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
      Tcommit
      s id = obj.%Id()
      s result = "{success:'true',id:'"_id_"'}"   //保存数据后,通过RowId返回到这条数据
      d:eobj.APTMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_AppointMethod","User.RBCAppointMethod","预约方法",eobj.APTMRowId,eobj.APTMDesc,"U",eobj,bobj)
      d:eobj.APTMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_AppointMethod","User.RBCAppointMethod","预约方法",id,eobj.APTMDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("预约方法","web.DHCBL.CT.RBCAppointMethod","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
  } 
  else
  {
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("预约方法","web.DHCBL.CT.RBCAppointMethod","SaveEntity","")
    s ^ERRORLOGINFO(logid)="对象不存在！"
    s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
  q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("预约方法","web.DHCBL.CT.RBCAppointMethod","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

/// CreateDate:2012-08-31
/// Creator:基础数据平台 ，孙凤超
/// Function: 分娩方法维护
/// Tables: PAC_DeliveryMethod
Class web.DHCBL.CT.PACDeliveryMethod Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询分娩方法
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Table: PAC_DeliveryMethod
/// Input:  rowid, code, desc 
/// Output: DLMTHRowId ,DLMTHCode, DLMTHDesc,DLMTHDateFrom, DLMTHDateTo  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACDeliveryMethod", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DLMTHRowId:%String, DLMTHCode:%String,DLMTHDesc:%String,DLMTHDateFrom:%Date,DLMTHDateTo:%Date,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc  ")
{
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

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s ret=0
  s AuStr=##class(web.DHCBL.Authorize.PACDeliveryMethod).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
    s DLMTHRowId=rowid
    s DLMTHCode=$p($g(^PAC("DLMTH",rowid)),"^",1)
    s DLMTHDesc=$p($g(^PAC("DLMTH",rowid)),"^",2)
    s DLMTHDateFrom=$p($g(^PAC("DLMTH",rowid)),"^",5) 
    s:DLMTHDateFrom'="" DLMTHDateFrom=$zd(DLMTHDateFrom,1) 
    s DLMTHDateTo=$p($g(^PAC("DLMTH",rowid)),"^",6) 
    s:DLMTHDateTo'="" DLMTHDateTo=$zd(DLMTHDateTo,1)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_DeliveryMethod",DLMTHRowId)
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
   s DLMTHRowId=0
   for
   { 
    s DLMTHRowId=$o(^PAC("DLMTH",DLMTHRowId)) q:DLMTHRowId=""    
    s strDLMTHRowId="{ID:"_DLMTHRowId_"}"
    if (AuStr[strDLMTHRowId)||(AuFlag=1)
    {
      s DLMTHCode=$p($g(^PAC("DLMTH",DLMTHRowId)),"^",1)
      s DLMTHDesc=$p($g(^PAC("DLMTH",DLMTHRowId)),"^",2) 
      s DLMTHDateFrom=$p($g(^PAC("DLMTH",DLMTHRowId)),"^",5) 
      s:DLMTHDateFrom'="" DLMTHDateFrom=$zd(DLMTHDateFrom,1)
      s DLMTHDateTo=$p($g(^PAC("DLMTH",DLMTHRowId)),"^",6) 
      s:DLMTHDateTo'="" DLMTHDateTo=$zd(DLMTHDateTo,1)  
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_DeliveryMethod",DLMTHRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_DeliveryMethod",DLMTHRowId,DLMTHDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(DLMTHCode,"U")[code)&(AliasFlag=1)  
      {
        d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(DLMTHRowId,DLMTHCode,DLMTHDesc,DLMTHDateFrom,DLMTHDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:进行数据检索，为combo提供查询分娩方法的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_DeliveryMethod
/// Input: desc
/// Output: DLMTH_RowId DLMTH_Code DLMTH_Desc   
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACDeliveryMethod","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DLMTHRowId:%String, DLMTHCode:%String,DLMTHDesc:%String ")
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
   s AuStr=##class(web.DHCBL.Authorize.PACDeliveryMethod).DHCGetDataByDefaultSession()
   s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
   s DLMTHRowId=rowid
   s DLMTHCode=$p($g(^PAC("DLMTH",rowid)),"^",1)
   s DLMTHDesc=$p($g(^PAC("DLMTH",rowid)),"^",2)
   d OutputRowCmb
  }
  else
  {
   s DLMTHRowId=0
   for
   { 
    s DLMTHRowId=$o(^PAC("DLMTH",DLMTHRowId)) 
    q:DLMTHRowId=""   
    s DLMTHDateFrom=$p($g(^PAC("DLMTH",rowid)),"^",5) 
    continue:(DLMTHDateFrom'="")&&(DLMTHDateFrom>+$h) 
    s DLMTHDateTo=$p($g(^PAC("DLMTH",rowid)),"^",6) 
    continue:(DLMTHDateTo'="")&&(DLMTHDateTo<+$h) 
    s strDLMTHRowId="{ID:"_DLMTHRowId_"}"
    if (AuStr[strDLMTHRowId)||(AuFlag=1)
    {
      s DLMTHCode=$p($g(^PAC("DLMTH",DLMTHRowId)),"^",1)
      s DLMTHDesc=$p($g(^PAC("DLMTH",DLMTHRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_DeliveryMethod",DLMTHRowId,DLMTHDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(DLMTHCode,"U")[code)&(AliasFlag=1)   
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(DLMTHRowId,DLMTHCode,DLMTHDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:用于双击修改时的数据加载 
/// CreateDate:2012-10-17
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid 
/// Others:w ##class(web.DHCBL.CT.PACDeliveryMethod).OpenData("2") 
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACDeliveryMethod).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.PACDeliveryMethod).%New()
 s eobj.DLMTHRowId = sid
 S eobj.DLMTHCode=pobj.DLMTHCode
 s eobj.DLMTHDesc= pobj.DLMTHDesc
 s:pobj.DLMTHDateFrom'="" eobj.DLMTHDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DLMTHDateFrom)
 s:pobj.DLMTHDateTo'="" eobj.DLMTHDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DLMTHDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对分娩方法删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-31
/// Desc:通过rowid号来删除分娩方法
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  PAC_DeliveryMethod
/// Others:d ##class(web.DHCBL.CT.PACDeliveryMethod).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
     s result="",flag=""
     Tstart
     s pobj = ##class(User.PACDeliveryMethod).%OpenId(id)
     s eobj = ##class(web.Entity.CT.PACDeliveryMethod).%New()
     s eobj.DLMTHRowId = id
     s eobj.DLMTHCode=pobj.DLMTHCode
     s eobj.DLMTHDesc= pobj.DLMTHDesc
     s:pobj.DLMTHDateFrom'="" eobj.DLMTHDateFrom=pobj.DLMTHDateFrom
     s:pobj.DLMTHDateTo'="" eobj.DLMTHDateTo=pobj.DLMTHDateTo
        
      s sc=##class(User.PACDeliveryMethod).%DeleteId(id)
      if $$$ISOK(sc)
     {
       Tc
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_DeliveryMethod","User.PACDeliveryMethod","分娩方法",id,eobj.DLMTHDesc,"D",eobj)
       s result="{success:'true',info:'删除成功！'}"
       d eobj.%Close()
     }
    else
   {
    Trollback
    s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩方法","web.DHCBL.CT.PACDeliveryMethod","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
   q result
}

/// Function:实现对分娩方法修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改分娩方法
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_DeliveryMethod
ClassMethod SaveEntity(eobj As web.Entity.CT.PACDeliveryMethod) As %String
{
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.DLMTHDateFrom'="" eobj.DLMTHDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DLMTHDateFrom)  //转换日期
  s:eobj.DLMTHDateTo'="" eobj.DLMTHDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DLMTHDateTo)      //转换日期
  s:eobj.DLMTHDateFrom="" eobj.DLMTHDateFrom=+$h
  if (eobj.DLMTHRowId="")  //如果RowId未赋值则增加
  {    
    s obj=##class(User.PACDeliveryMethod).%New() 
  }   else  //如果RowId已赋值则修改
  { 
   s obj=##class(User.PACDeliveryMethod).%OpenId(eobj.DLMTHRowId)
   s bobj=##class(web.Entity.CT.PACDeliveryMethod).%New() 
   s bobj.DLMTHRowId=eobj.DLMTHRowId
   s bobj.DLMTHCode = obj.DLMTHCode                      
   s bobj.DLMTHDesc= obj.DLMTHDesc                     
   s bobj.DLMTHDateFrom = obj.DLMTHDateFrom 
   s bobj.DLMTHDateTo=obj.DLMTHDateTo    
  }
   s obj.DLMTHCode = eobj.DLMTHCode                      
   s obj.DLMTHDesc= eobj.DLMTHDesc                     
   s obj.DLMTHDateFrom = eobj.DLMTHDateFrom 
   s obj.DLMTHDateTo=eobj.DLMTHDateTo     
   Tstart
    s sc=obj.%Save()
    if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.DLMTHRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_DeliveryMethod","User.PACDeliveryMethod","分娩方法",eobj.DLMTHRowId,eobj.DLMTHDesc,"U",eobj,bobj)
    d:eobj.DLMTHRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_DeliveryMethod","User.PACDeliveryMethod","分娩方法",id,eobj.DLMTHDesc,"A",eobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩方法","web.DHCBL.CT.PACDeliveryMethod","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
 }else{
  s result = "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩方法","web.DHCBL.CT.PACDeliveryMethod","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩方法","web.DHCBL.CT.PACDeliveryMethod","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:进行数据重复校验功能，并返回一个标志位
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-12-03
/// Table:PAC_DeliveryMethod
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s:code'="" flagc=$d(^PAC("DLMTH",0,"DLMTH_Code",code))
 s:desc'="" flagd=$d(^PAC("DLMTH",0,"DLMTH_Desc",desc))
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
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("DLMTH",0,"DLMTH_Code",code,0))
  s:desc'="" idd=$o(^PAC("DLMTH",0,"DLMTH_Desc",desc,0))
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

}

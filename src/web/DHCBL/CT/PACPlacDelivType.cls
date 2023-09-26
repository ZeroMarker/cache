/// CreateDate:2012-08-31
/// Creator:基础数据平台 ，孙凤超
/// Function: 胎盘分娩类型 维护
/// Tables: PAC_PlacDelivType
Class web.DHCBL.CT.PACPlacDelivType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询胎盘分娩类型
/// CreateDate:2012-08-1
/// Creator:基础数据平台公共产品组 孙凤超
/// Table:  PAC_PlacDelivType 
/// Output: PLDTRowId ,PLDTCode,PLDTDesc,PLDTDateFrom,PLDTDateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPlacDelivType", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PLDTRowId:%String,PLDTCode:%String,PLDTDesc:%String,PLDTDateFrom:%String,PLDTDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.PACPlacDelivType).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
   s PLDTRowId=rowid
   s PLDTCode=$p($g(^PAC("PLDT",PLDTRowId)),"^",1)
   s PLDTDesc=$p($g(^PAC("PLDT",PLDTRowId)),"^",2)
   s PLDTDateFrom=$p($g(^PAC("PLDT",PLDTRowId)),"^",3)
   s:PLDTDateFrom'="" PLDTDateFrom=$zd(PLDTDateFrom,1)
   s PLDTDateTo=$p($g(^PAC("PLDT",PLDTRowId)),"^",4)
   s:PLDTDateTo'="" PLDTDateTo=$zd(PLDTDateTo,1)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_PlacDelivType",PLDTRowId)
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
   s PLDTRowId=0
   for
   {
     s PLDTRowId=$o(^PAC("PLDT",PLDTRowId)) q:PLDTRowId=""   
     s strPLDTRowId="{ID:"_PLDTRowId_"}"
     if (AuStr[strPLDTRowId)||(AuFlag=1)
     {
          s PLDTCode=$p($g(^PAC("PLDT",PLDTRowId)),"^",1)
          s PLDTDesc=$p($g(^PAC("PLDT",PLDTRowId)),"^",2) 
          s PLDTDateFrom=$p($g(^PAC("PLDT",PLDTRowId)),"^",3)
          s:PLDTDateFrom'="" PLDTDateFrom=$zd(PLDTDateFrom,1)
          s PLDTDateTo=$p($g(^PAC("PLDT",PLDTRowId)),"^",4)
          s:PLDTDateTo'="" PLDTDateTo=$zd(PLDTDateTo,1)
          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PLDTDesc) 
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
          s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_PlacDelivType",PLDTRowId)
          s BDPInternalCode =$p($g(resultStr),"^",1)       
          s BDPInternalDesc = $p($g(resultStr),"^",2)  
          s BDPHospNationalCode=$p($g(resultStr),"^",3)         
          s BDPHospNationalDesc = $p($g(resultStr),"^",4)
          if (desc'="")
          {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PlacDelivType",PLDTRowId,PLDTDesc,desc)
          }
          else
          {
             s AliasFlag=1   
          } 
          if ($ZCVT(PLDTCode,"U")[code)&(AliasFlag=1) 
          {
             d OutputRow
          }
        }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(PLDTRowId,PLDTCode,PLDTDesc,PLDTDateFrom,PLDTDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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

/// Function:进行数据检索,为combo提供查询胎盘分娩类型的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_PlacDelivType
/// Input:  desc
/// Output: PLDT_RowId PLDT_Code,PLDT_Desc,  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPlacDelivType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PLDTRowId:%String, PLDTCode:%String,PLDTDesc:%String ")
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
 s AuStr=##class(web.DHCBL.Authorize.PACPlacDelivType).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s PLDTRowId=rowid
   s PLDTCode=$p($g(^PAC("PLDT",PLDTRowId)),"^",1)
   s PLDTDesc=$p($g(^PAC("PLDT",PLDTRowId)),"^",2)
   d OutputRowCmb
 }
 else
 {
   s PLDTRowId=0
   for
   {
      s PLDTRowId=$o(^PAC("PLDT",PLDTRowId)) 
      q:PLDTRowId=""   
      s PLDTDateFrom=$p($g(^PAC("PLDT",PLDTRowId)),"^",3)
      continue:(PLDTDateFrom'="")&&(PLDTDateFrom>+$h)
      s PLDTDateTo=$p($g(^PAC("PLDT",PLDTRowId)),"^",4) 
      continue:(PLDTDateTo'="")&&(PLDTDateTo<+$h)
      s strPLDTRowId="{ID:"_PLDTRowId_"}"
      if (AuStr[strPLDTRowId)||(AuFlag=1)
      {
       s PLDTCode=$p($g(^PAC("PLDT",PLDTRowId)),"^",1)
       s PLDTDesc=$p($g(^PAC("PLDT",PLDTRowId)),"^",2)  
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PlacDelivType",PLDTRowId,PLDTDesc,desc)
       }
       else
       {
         s AliasFlag=1   
       } 
       if ($ZCVT(PLDTCode,"U")[code)&(AliasFlag=1)  
       {
         d OutputRowCmb
       }
     }
   }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(PLDTRowId,PLDTCode,PLDTDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 q
}

/// Function:显示胎盘分娩类型
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:PAC_PlacDelivType 
/// Others:w ##class(web.DHCBL.CT.PACPlacDelivType).OpenData("1")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACPlacDelivType).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.PACPlacDelivType).%New()
 s eobj.PLDTRowId=sid
 s eobj.PLDTCode= pobj.PLDTCode
 s eobj.PLDTDesc = pobj.PLDTDesc
 s:pobj.PLDTDateFrom'="" eobj.PLDTDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PLDTDateFrom)
 s:pobj.PLDTDateTo'="" eobj.PLDTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PLDTDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对胎盘分娩类型删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-31
/// Desc:通过rowid号来删除胎盘分娩类型 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  PAC_PlacDelivType 
/// Others:d ##class(web.DHCBL.CT.PACPlacDelivType).DeletePACPlacDelivType("")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""  
    Tstart
    s pobj = ##class(User.PACPlacDelivType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACPlacDelivType).%New()
    s eobj.PLDTRowId=id
    s eobj.PLDTCode= pobj.PLDTCode
    s eobj.PLDTDesc = pobj.PLDTDesc
    s:pobj.PLDTDateFrom'="" eobj.PLDTDateFrom = pobj.PLDTDateFrom
    s:pobj.PLDTDateTo'="" eobj.PLDTDateTo=pobj.PLDTDateTo
   
    s sc=##class(User.PACPlacDelivType).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PlacDelivType","User.PACPlacDelivType","胎盘分娩类型",id,eobj.PLDTDesc,"D",eobj)
      d eobj.%Close()
    }
   else
   {
      Trollback
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘分娩类型","web.DHCBL.CT.PACPlacDelivType","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
   }
 q result
}

/// Creator：孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table：PAC_PlacDelivType
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="", flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s:code'="" flagc=$d(^PAC("PLDT",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("PLDT",0,"Desc",desc))
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
  s idc="", idd=""
  s:code'="" idc=$o(^PAC("PLDT",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("PLDT",0,"Desc",desc,0))
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

/// Function:实现对胎盘分娩类型修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改胎盘分娩类型
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_PlacDelivType
ClassMethod SaveEntity(eobj As web.Entity.CT.PACPlacDelivType) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.PLDTDateFrom'="" eobj.PLDTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PLDTDateFrom)  //转换日期
  s:eobj.PLDTDateTo'="" eobj.PLDTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PLDTDateTo)      //转换日期
  s:eobj.PLDTDateFrom="" eobj.PLDTDateFrom=+$h
  //如果RowId未赋值则增加
  if (eobj.PLDTRowId="")       
  {
   //RowId未赋值,增加
   s obj=##class(User.PACPlacDelivType).%New()
  }else                           
  {
   //RowId已存在,修改
    s obj=##class(User.PACPlacDelivType).%OpenId(eobj.PLDTRowId)
    s bobj=##class(web.Entity.CT.PACPlacDelivType).%New() 
    
    s bobj.PLDTRowId=eobj.PLDTRowId
    s bobj.PLDTCode = obj.PLDTCode                      
    s bobj.PLDTDesc= obj.PLDTDesc                     
    s bobj.PLDTDateFrom = obj.PLDTDateFrom 
    s bobj.PLDTDateTo= obj.PLDTDateTo
  }
   s obj.PLDTCode = eobj.PLDTCode                      
   s obj.PLDTDesc= eobj.PLDTDesc                     
   s obj.PLDTDateFrom = eobj.PLDTDateFrom 
   s obj.PLDTDateTo=eobj.PLDTDateTo
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.PLDTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PlacDelivType","User.PACPlacDelivType","胎盘分娩类型",eobj.PLDTRowId,eobj.PLDTDesc,"U",eobj,bobj)
    d:eobj.PLDTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PlacDelivType","User.PACPlacDelivType","胎盘分娩类型",id,eobj.PLDTDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘分娩类型","web.DHCBL.CT.PACPlacDelivType","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     } 
   }
  else
  {
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘分娩类型","web.DHCBL.CT.PACPlacDelivType","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
  q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘分娩类型","web.DHCBL.CT.PACPlacDelivType","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

/// CreateDate:2012-08-30
/// Creator:基础数据平台 ，孙凤超
/// Function: 分娩状态维护
Class web.DHCBL.CT.PACPregStatus Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询分娩状态
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_PregStatus
/// Input: rowid, code, desc, query 
/// Output: PREGST_RowId PREGST_Code PREGST_Desc PREGST_DateFrom PREGST_DateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPregStatus","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PREGSTRowId:%String,PREGSTCode:%String,PREGSTDesc:%String,PREGSTDateFrom:%String,PREGSTDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
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
 s AuStr=##class(web.DHCBL.Authorize.PACPregStatus).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
  s PREGSTRowId=rowid
  s PREGSTCode=$p($g(^PAC("PREGST",PREGSTRowId)),"^",1)
  s PREGSTDesc=$p($g(^PAC("PREGST",PREGSTRowId)),"^",2)
  s PREGSTDateFrom=$p($g(^PAC("PREGST",PREGSTRowId)),"^",3)
  s:PREGSTDateFrom'="" PREGSTDateFrom=$zd(PREGSTDateFrom,1)
  s PREGSTDateTo=$p($g(^PAC("PREGST",PREGSTRowId)),"^",4)
  s:PREGSTDateTo'="" PREGSTDateTo=$zd(PREGSTDateTo,1)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_PregStatus",PREGSTRowId)
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
   s PREGSTRowId=0
   for
  {
     s PREGSTRowId=$o(^PAC("PREGST",PREGSTRowId)) q:PREGSTRowId=""   
     s strPREGSTRowId="{ID:"_PREGSTRowId_"}"
     if (AuStr[strPREGSTRowId)||(AuFlag=1)
     {
      s PREGSTCode=$p($g(^PAC("PREGST",PREGSTRowId)),"^",1)
      s PREGSTDesc=$p($g(^PAC("PREGST",PREGSTRowId)),"^",2) 
      s PREGSTDateFrom=$p($g(^PAC("PREGST",PREGSTRowId)),"^",3)
      s:PREGSTDateFrom'="" PREGSTDateFrom=$zd(PREGSTDateFrom,1)
      s PREGSTDateTo=$p($g(^PAC("PREGST",PREGSTRowId)),"^",4)
      s:PREGSTDateTo'="" PREGSTDateTo=$zd(PREGSTDateTo,1)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_PregStatus",PREGSTRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PregStatus",PREGSTRowId,PREGSTDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(PREGSTCode,"U")[code)&(AliasFlag=1)   
      {
         d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(PREGSTRowId,PREGSTCode,PREGSTDesc,PREGSTDateFrom,PREGSTDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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

/// Function:进行数据检索，为comb提供查询系统分娩状态的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_PregStatus
/// Input:desc
/// Output: PREGST_RowId PREGST_Code PREGST_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPregStatus","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PREGSTRowId:%String, PREGSTCode:%String,PREGSTDesc:%String ")
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
  s AuStr=##class(web.DHCBL.Authorize.PACPregStatus).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="")  
  {
    s PREGSTRowId=rowid
    s PREGSTCode=$p($g(^PAC("PREGST",PREGSTRowId)),"^",1)
    s PREGSTDesc=$p($g(^PAC("PREGST",PREGSTRowId)),"^",2)
    d OutputRowCmb
  }
  else
  {
   s PREGSTRowId=0
   for
   {
     s PREGSTRowId=$o(^PAC("PREGST",PREGSTRowId)) 
     q:PREGSTRowId=""   
     s PREGSTDateFrom=$p($g(^PAC("PREGST",PREGSTRowId)),"^",3)
     continue:(PREGSTDateFrom'="")&&(PREGSTDateFrom>+$h)
     s PREGSTDateTo=$p($g(^PAC("PREGST",PREGSTRowId)),"^",4) 
     continue:(PREGSTDateTo'="")&&(PREGSTDateTo<+$h)
     s strPREGSTRowId="{ID:"_PREGSTRowId_"}"
     if (AuStr[strPREGSTRowId)||(AuFlag=1)
     {
      s PREGSTCode=$p($g(^PAC("PREGST",PREGSTRowId)),"^",1)
      s PREGSTDesc=$p($g(^PAC("PREGST",PREGSTRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PregStatus",PREGSTRowId,PREGSTDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(PREGSTCode,"U")[code)&(AliasFlag=1)  
      {
        d OutputRowCmb
      }
    }
  }
 }
 
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK 
OutputRowCmb    
   set Data=$lb(PREGSTRowId,PREGSTCode,PREGSTDesc)
   Set ^CacheTemp(repid,ind)=Data
   Set ind=ind+1
  q
}

/// Function:显示系统分娩状态
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:PAC_PregStatus
/// Others:w ##class(web.DHCBL.CT.PACPregStatus).OpenData("3")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACPregStatus).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.PACPregStatus).%New()
 s eobj.PREGSTRowId=sid
 s eobj.PREGSTCode = pobj.PREGSTCode
 s eobj.PREGSTDesc = pobj.PREGSTDesc
 s:pobj.PREGSTDateFrom'="" eobj.PREGSTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PREGSTDateFrom)
 s:pobj.PREGSTDateTo'="" eobj.PREGSTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PREGSTDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对系统分娩状态的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid号来删除系统分娩状态 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_PregStatus
/// Others:d ##class(web.DHCBL.CT.PACPregStatus).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    Tstart
    s pobj = ##class(User.PACPregStatus).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACPregStatus).%New()
    s eobj.PREGSTRowId=id
    s eobj.PREGSTCode = pobj.PREGSTCode
    s eobj.PREGSTDesc = pobj.PREGSTDesc
    s:pobj.PREGSTDateFrom'="" eobj.PREGSTDateFrom=pobj.PREGSTDateFrom
    s:pobj.PREGSTDateTo'="" eobj.PREGSTDateTo=pobj.PREGSTDateTo
    s sc=##class(User.PACPregStatus).%DeleteId(id)
    IF $$$ISOK(sc)
   {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PregStatus","User.PACPregStatus","分娩状态",id,eobj.PREGSTDesc,"D",eobj)
     d eobj.%Close()
   }
   else
   {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩状态","web.DHCBL.CT.PACPregStatus","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
 q result
}

/// Creator：基础数据平台组，孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table：PAC_PregStatus 
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s:code'="" flagc=$d(^PAC("PREGST",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("PREGST",0,"Desc",desc)) 
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
  s:code'="" idc=$o(^PAC("PREGST",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("PREGST",0,"Desc",desc,0))
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

/// Function:实现对分娩状态的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改分娩状态
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_PregStatus   
ClassMethod SaveEntity(eobj As web.Entity.CT.PACPregStatus) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.PREGSTDateFrom'="" eobj.PREGSTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PREGSTDateFrom)  //转换日期
  s:eobj.PREGSTDateTo'="" eobj.PREGSTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PREGSTDateTo)      //转换日期
  s:eobj.PREGSTDateFrom="" eobj.PREGSTDateFrom=+$h
  //如果RowId未赋值则增加
  if (eobj.PREGSTRowId="")       
  {
   //RowId未赋值,增加
   s obj=##class(User.PACPregStatus).%New()
  }else {
   //RowId已存在,修改
   s obj=##class(User.PACPregStatus).%OpenId(eobj.PREGSTRowId)
   s bobj=##class(web.Entity.CT.PACPregStatus).%New()
   s bobj.PREGSTRowId=eobj.PREGSTRowId
   s bobj.PREGSTCode = obj.PREGSTCode
   s bobj.PREGSTDesc= obj.PREGSTDesc                      
   s bobj.PREGSTDateFrom=obj.PREGSTDateFrom
   s bobj.PREGSTDateTo=obj.PREGSTDateTo
  } 
   s obj.PREGSTCode = eobj.PREGSTCode                      
   s obj.PREGSTDesc= eobj.PREGSTDesc                      
   s obj.PREGSTDateFrom=eobj.PREGSTDateFrom
   s obj.PREGSTDateTo=eobj.PREGSTDateTo
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.PREGSTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PregStatus","User.PACPregStatus","分娩状态",eobj.PREGSTRowId,eobj.PREGSTDesc,"U",eobj,bobj)
    d:eobj.PREGSTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PregStatus","User.PACPregStatus","分娩状态",id,eobj.PREGSTDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩状态","web.DHCBL.CT.PACPregStatus","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
 }
 else
 {
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩状态","web.DHCBL.CT.PACPregStatus","DeleteData","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩状态","web.DHCBL.CT.PACPregStatus","DeleteData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

Import SQLUSER

/// CreateDate:2012-08-30
/// Creator:基础数据平台 ，孙凤超
/// Function: 先天畸形维护
/// Tables: PAC_CongenitalAnomalies
Class web.DHCBL.CT.PACCongenitalAnomalies Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询先天畸形 
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Table:  PAC_CongenitalAnomalies  
/// Output: CONGANOMRowId，CONGANOMCode,CONGANOMDesc，CONGANOMDateFrom,CONGANOMDateTo, CONGANOMActive 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACCongenitalAnomalies", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, active As %String) As %Query(ROWSPEC = "CONGANOMRowId:%String,CONGANOMCode:%String,CONGANOMDesc:%String,CONGANOMDateFrom:%String,CONGANOMDateTo:%String,CONGANOMActive:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
 s AuStr=##class(web.DHCBL.Authorize.PACCongenitalAnomalies).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s CONGANOMRowId=rowid
  s CONGANOMCode=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",1)
  s CONGANOMDesc=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",2)
  s CONGANOMDateFrom=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",3)
  s:CONGANOMDateFrom'="" CONGANOMDateFrom=$zd(CONGANOMDateFrom,1)
  s CONGANOMDateTo=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",4)
  s:CONGANOMDateTo'="" CONGANOMDateTo=$zd(CONGANOMDateTo,1)
  s CONGANOMActive=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",6)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_CongenitalAnomalies",CONGANOMRowId)
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
   s CONGANOMRowId=0
   for
   { 
      s CONGANOMRowId=$o(^PAC("CONGANOM",CONGANOMRowId)) q:CONGANOMRowId=""  
      s strCONGANOMRowId="{ID:"_CONGANOMRowId_"}"
      if (AuStr[strCONGANOMRowId)||(AuFlag=1)
      {
         s CONGANOMCode=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",1)
         s CONGANOMDesc=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",2) 
         s CONGANOMDateFrom=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",3)
         s:CONGANOMDateFrom'="" CONGANOMDateFrom=$zd(CONGANOMDateFrom,1)
         s CONGANOMDateTo=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",4)
         s:CONGANOMDateTo'="" CONGANOMDateTo=$zd(CONGANOMDateTo,1)
         s CONGANOMActive=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",6)  
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_CongenitalAnomalies",CONGANOMRowId)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)
         if (desc'="")
         {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_CongenitalAnomalies",CONGANOMRowId,CONGANOMDesc,desc)
         }
         else
         {
             s AliasFlag=1   
         } 
         if ($ZCVT(CONGANOMCode,"U")[code)&(AliasFlag=1)&(CONGANOMActive[active)   
         {
            d OutputRow
         }
      }
   }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CONGANOMRowId,CONGANOMCode,CONGANOMDesc,CONGANOMDateFrom,CONGANOMDateTo,CONGANOMActive,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，查询comb先天畸形提供接口 
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_CongenitalAnomalies 
/// Input:  desc
/// Output: CONGANOM_RowId，CONGANOM_Code ，CONGANOM_Desc        
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACCongenitalAnomalies", "GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CONGANOMRowId:%String,CONGANOMCode:%String,CONGANOMDesc:%String ")
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
  s AuStr=##class(web.DHCBL.Authorize.PACCongenitalAnomalies).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="") 
  {
    s CONGANOMRowId=rowid
    s CONGANOMCode=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",1)
    s CONGANOMDesc=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",2)
    d OutputRowCmb
  }
  else
  { 
    s CONGANOMRowId=0
    for
    { 
      s CONGANOMRowId=$o(^PAC("CONGANOM",CONGANOMRowId)) 
      q:CONGANOMRowId=""
      s CONGANOMDateFrom=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",3)
      continue:(CONGANOMDateFrom'="")&&(CONGANOMDateFrom>+$h)  
      s CONGANOMDateTo=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",4) 
      continue:(CONGANOMDateTo'="")&&(CONGANOMDateTo<+$h)  
      s strCONGANOMRowId="{ID:"_CONGANOMRowId_"}"
      if (AuStr[strCONGANOMRowId)||(AuFlag=1)
      {
        s CONGANOMCode=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",1)
        s CONGANOMDesc=$p($g(^PAC("CONGANOM",CONGANOMRowId)),"^",2)
        if (desc'="")
         {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_CongenitalAnomalies",CONGANOMRowId,CONGANOMDesc,desc)
         }
         else
         {
             s AliasFlag=1   
         } 
        if ($ZCVT(CONGANOMCode,"U")[code)&(AliasFlag=1) 
        {
          d OutputRowCmb
        }
     }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(CONGANOMRowId,CONGANOMCode,CONGANOMDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:用于双击修改时的数据加载 
/// CreateDate:2012-10-17
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables: PAC_CongenitalAnomalies 
/// Others :w ##class(web.DHCBL.CT.PACCongenitalAnomalies).OpenData("54")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACCongenitalAnomalies).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.PACCongenitalAnomalies).%New()
 s eobj.CONGANOMRowId = sid
 S eobj.CONGANOMCode=pobj.CONGANOMCode
 s eobj.CONGANOMDesc= pobj.CONGANOMDesc
 s:pobj.CONGANOMDateFrom'="" eobj.CONGANOMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CONGANOMDateFrom)
 s:pobj.CONGANOMDateTo'="" eobj.CONGANOMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CONGANOMDateTo)
 s:eobj.CONGANOMActive="Y" eobj.CONGANOMActive="true"
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对新生儿先天畸形删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid号来删除新生儿先天畸形
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_CongenitalAnomalies  
/// Others:d ##class(web.DHCBL.CT.PACCongenitalAnomalies).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result=""
   Tstart
   s pobj = ##class(User.PACCongenitalAnomalies).%OpenId(id)
   s eobj = ##class(web.Entity.CT.PACCongenitalAnomalies).%New()
   s eobj.CONGANOMRowId = id
   S eobj.CONGANOMCode=pobj.CONGANOMCode
   s eobj.CONGANOMDesc= pobj.CONGANOMDesc
   s:pobj.CONGANOMDateFrom'="" eobj.CONGANOMDateFrom=pobj.CONGANOMDateFrom 
   s:pobj.CONGANOMDateTo'="" eobj.CONGANOMDateTo=pobj.CONGANOMDateTo 
   s:pobj.CONGANOMActive="" pobj.CONGANOMActive="N"
   s eobj.CONGANOMActive=pobj.CONGANOMActive
   s sc=##class(User.PACCongenitalAnomalies).%DeleteId(id)
   IF $$$ISOK(sc)
   {
      Tc
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_CongenitalAnomalies","User.PACCongenitalAnomalies","先天畸形",id,eobj.CONGANOMDesc,"D",eobj)
      s result="{success:'true',info:'删除成功！'}"
      d eobj.%Close()
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("先天畸形","web.DHCBL.CT.PACCongenitalAnomalies","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
   q result
}

/// Creator：基础数据平台 孙凤超
/// CreatDate: 2012-11-28
/// Description：数据校验功能
/// Table：RBC_AppointMethod
/// s sc=##class(web.Entity.CT.RBCSessionType).FormValidate("2","包2","APCVCCode")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s:code'="" flagc=$d(^PAC("CONGANOM",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("CONGANOM",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("CONGANOM",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("CONGANOM",0,"Desc",desc,0))
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

/// Function:实现对新生儿先天畸形修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_CongenitalAnomalies  
ClassMethod SaveEntity(eobj As web.Entity.CT.PACCongenitalAnomalies) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CONGANOMDateFrom'="" eobj.CONGANOMDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CONGANOMDateFrom)  //转换日期
  s:eobj.CONGANOMDateTo'="" eobj.CONGANOMDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CONGANOMDateTo)      //转换日期
  s:eobj.CONGANOMDateFrom="" eobj.CONGANOMDateFrom=+$h
  //如果RowId未赋值则增加
  if (eobj.CONGANOMRowId="")       
  {
   s obj=##class(User.PACCongenitalAnomalies).%New()
  }else                           
  {
   s obj=##class(User.PACCongenitalAnomalies).%OpenId(eobj.CONGANOMRowId)
   s bobj=##class(web.Entity.CT.PACCongenitalAnomalies).%New()
   s bobj.CONGANOMRowId=eobj.CONGANOMRowId
   s bobj.CONGANOMCode = obj.CONGANOMCode                      
   s bobj.CONGANOMDesc= obj.CONGANOMDesc                       
   s bobj.CONGANOMDateFrom = obj.CONGANOMDateFrom 
   s bobj.CONGANOMDateTo=obj.CONGANOMDateTo
   ;s:eobj.CONGANOMActive="" eobj.CONGANOMActive="N"
   s bobj.CONGANOMActive=obj.CONGANOMActive 
  }
   s obj.CONGANOMCode = eobj.CONGANOMCode                      
   s obj.CONGANOMDesc= eobj.CONGANOMDesc                       
   s obj.CONGANOMDateFrom = eobj.CONGANOMDateFrom 
   s obj.CONGANOMDateTo=eobj.CONGANOMDateTo
   s:eobj.CONGANOMActive="" eobj.CONGANOMActive="N"
   s obj.CONGANOMActive=eobj.CONGANOMActive 
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.CONGANOMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_CongenitalAnomalies","User.PACCongenitalAnomalies","先天畸形",eobj.CONGANOMRowId,eobj.CONGANOMDesc,"U",eobj,bobj)
    d:eobj.CONGANOMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_CongenitalAnomalies","User.PACCongenitalAnomalies","先天畸形",id,eobj.CONGANOMDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("先天畸形","web.DHCBL.CT.PACCongenitalAnomalies","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
  else
  {
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("先天畸形","web.DHCBL.CT.PACCongenitalAnomalies","DeleteData","")
    s ^ERRORLOGINFO(logid)="对象不存在！"
    s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
  q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("先天畸形","web.DHCBL.CT.PACCongenitalAnomalies","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

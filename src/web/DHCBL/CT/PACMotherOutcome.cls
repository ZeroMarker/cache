/// CreateDate:2012-08-30
/// Creator:基础数据平台 ，孙凤超
/// Function: 分娩结果维护
Class web.DHCBL.CT.PACMotherOutcome Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询分娩结果
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: PAC_MotherOutcome  
/// Output:  MTHROC_RowId MTHROC_Code MTHROC_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACMotherOutcome","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "MTHROCRowId:%String,MTHROCCode:%String,MTHROCDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
 s AuStr=##class(web.DHCBL.Authorize.PACMotherOutcome).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s MTHROCRowId=rowid
  s MTHROCCode=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",1)
  s MTHROCDesc=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",2)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_MotherOutcome",MTHROCRowId)
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
   s MTHROCRowId=0
   for
   {
     s MTHROCRowId=$o(^PAC("MTHROC",MTHROCRowId)) q:MTHROCRowId=""  
     s strMTHROCRowId="{ID:"_MTHROCRowId_"}"
     if (AuStr[strMTHROCRowId)||(AuFlag=1)
     {
       s MTHROCCode=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",1)
       s MTHROCDesc=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",2) 
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_MotherOutcome",MTHROCRowId)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4)
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_MotherOutcome",MTHROCRowId,MTHROCDesc,desc)
       }
       else
       {
         s AliasFlag=1   
       } 
       if ($ZCVT(MTHROCCode,"U")[code)&(AliasFlag=1) 
       {
         d OutputRow
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MTHROCRowId,MTHROCCode,MTHROCDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:显示分娩结果
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:id
/// Tables: PAC_MotherOutcome
/// Other:w ##class(web.DHCBL.CT.PACMotherOutcome).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACMotherOutcome).%OpenId(id)
 s eobj = ##class(web.Entity.CT.PACMotherOutcome).%New()
 
 s eobj.MTHROCRowId=id
 s eobj.MTHROCCode = pobj.MTHROCCode 
 s eobj.MTHROCDesc = pobj.MTHROCDesc
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:进行数据检索，为comb提供查询分娩结果的接口
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_MotherOutcome 
/// Input:  code,desc
/// Output:  MTHROC_RowId MTHROC_Code MTHROC_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACMotherOutcome","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "MTHROCRowId:%String, MTHROCCode:%String,MTHROCDesc:%String ")
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
 s AuStr=##class(web.DHCBL.Authorize.PACMotherOutcome).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
  s MTHROCRowId=rowid
  s MTHROCCode=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",1)
  s MTHROCDesc=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",2)
  d OutputRowCmb 
 }
 else
 { 
  s MTHROCRowId=0
  for
  {
     s MTHROCRowId=$o(^PAC("MTHROC",MTHROCRowId)) q:MTHROCRowId=""  
     s strMTHROCRowId="{ID:"_MTHROCRowId_"}"
     if (AuStr[strMTHROCRowId)||(AuFlag=1)
     {
       s MTHROCCode=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",1)
       s MTHROCDesc=$p($g(^PAC("MTHROC",MTHROCRowId)),"^",2) 
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_MotherOutcome",MTHROCRowId,MTHROCDesc,desc)
       }
       else
       {
         s AliasFlag=1   
       } 
       if ($ZCVT(MTHROCCode,"U")[code)&(AliasFlag=1) 
       {
         d OutputRowCmb
       }
     }
   }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
   
 set Data=$lb(MTHROCRowId,MTHROCCode,MTHROCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:实现对分娩结果的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid号来删除分娩结果
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_MotherOutcome
/// Others:d ##class(web.DHCBL.CT.PACMotherOutcome).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart 
    s pobj = ##class(User.PACMotherOutcome).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACMotherOutcome).%New()
    s eobj.MTHROCRowId=id
    s eobj.MTHROCCode = pobj.MTHROCCode 
    s eobj.MTHROCDesc = pobj.MTHROCDesc
   
    s sc=##class(User.PACMotherOutcome).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_MotherOutcome","User.PACMotherOutcome","分娩结果",id,eobj.MTHROCDesc,"D",eobj)
      d eobj.%Close()
   }
    else
    {
     Trollback
     s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩结果","web.DHCBL.CT.PACMotherOutcome","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  q result
}

/// Creator：孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table：PAC_BabyPosition 
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="", flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s:code'="" flagc=$d(^PAC("MTHROC",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("MTHROC",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("MTHROC",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("MTHROC",0,"Desc",desc,0))
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

/// Function:实现对分娩结果的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改分娩结果
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_MotherOutcome 
ClassMethod SaveEntity(eobj As web.Entity.CT.PACMotherOutcome) As %String
{
  s $zt="ERROR"
  s result=""
  ;s ^SUN("session")="del"_"^"_%session.Data("LOGON.USERNAME")
 if $IsObject(eobj)
 {
  if (eobj.MTHROCRowId="")       
  {
   s obj=##class(User.PACMotherOutcome).%New()
  }else                           
  {
   //RowId已存在,修改
   s obj=##class(User.PACMotherOutcome).%OpenId(eobj.MTHROCRowId)
   s bobj=##class(web.Entity.CT.PACMotherOutcome).%New()
   s bobj.MTHROCRowId=eobj.MTHROCRowId
   s bobj.MTHROCCode = obj.MTHROCCode                    
   s bobj.MTHROCDesc= obj.MTHROCDesc       
  }
   s obj.MTHROCCode = eobj.MTHROCCode                    
   s obj.MTHROCDesc= eobj.MTHROCDesc                     
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
     Tcommit
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
     d:eobj.MTHROCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_MotherOutcome","User.PACMotherOutcome","分娩结果",eobj.MTHROCRowId,eobj.MTHROCDesc,"U",eobj,bobj)
     d:eobj.MTHROCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_MotherOutcome","User.PACMotherOutcome","分娩结果",id,eobj.MTHROCDesc,"A",eobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩结果","web.DHCBL.CT.PACMotherOutcome","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }   
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩结果","web.DHCBL.CT.PACMotherOutcome","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分娩结果","web.DHCBL.CT.PACMotherOutcome","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

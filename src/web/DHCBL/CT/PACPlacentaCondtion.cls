/// CreateDate:2012-08-30
/// Creator:基础数据平台 ，孙凤超
/// Function: 胎盘情况维护
Class web.DHCBL.CT.PACPlacentaCondtion Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询胎盘情况
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_PlacentaCondtion
/// Input: rowid, code, desc, query 
/// Output: PLCON_RowId PLCON_Code PLCON_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPlacentaCondtion","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PLCONRowId:%String,PLCONCode:%String,PLCONDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
 s AuStr=##class(web.DHCBL.Authorize.PACPlacentaCondtion).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s PLCONRowId=rowid
   s PLCONCode=$p($g(^PAC("PLCON",PLCONRowId)),"^",1)
   s PLCONDesc=$p($g(^PAC("PLCON",PLCONRowId)),"^",2) 
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_PlacentaCondtion",PLCONRowId)
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
   s PLCONRowId=0
   for
  { 
    s PLCONRowId=$o(^PAC("PLCON",PLCONRowId)) q:PLCONRowId=""   
    s strPLCONRowId="{ID:"_PLCONRowId_"}"
    if (AuStr[strPLCONRowId)||(AuFlag=1)
    {
      s PLCONCode=$p($g(^PAC("PLCON",PLCONRowId)),"^",1)
      s PLCONDesc=$p($g(^PAC("PLCON",PLCONRowId)),"^",2)  
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_PlacentaCondtion",PLCONRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PlacentaCondtion",PLCONRowId,PLCONDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(PLCONCode,"U")[code)&(AliasFlag=1)  
      {
         d OutputRow
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(PLCONRowId,PLCONCode,PLCONDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为comb提供查询胎盘情况的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_PlacentaCondtion
/// Input:desc 
/// Output: PLCON_RowId PLCON_Code PLCON_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPlacentaCondtion","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PLCONRowId:%String, PLCONCode:%String,PLCONDesc:%String ")
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
  s AuStr=##class(web.DHCBL.Authorize.PACPlacentaCondtion).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="")  
  {
   s PLCONRowId=rowid
   s PLCONCode=$p($g(^PAC("PLCON",PLCONRowId)),"^",1)
   s PLCONDesc=$p($g(^PAC("PLCON",PLCONRowId)),"^",2) 
   d OutputRowCmb
  }
  else
  {
   s PLCONRowId=0
   for
   { 
    s PLCONRowId=$o(^PAC("PLCON",PLCONRowId)) q:PLCONRowId=""   
    s strPLCONRowId="{ID:"_PLCONRowId_"}"
    if (AuStr[strPLCONRowId)||(AuFlag=1)
    {
      s PLCONCode=$p($g(^PAC("PLCON",PLCONRowId)),"^",1)
      s PLCONDesc=$p($g(^PAC("PLCON",PLCONRowId)),"^",2) 
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PlacentaCondtion",PLCONRowId,PLCONDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(PLCONCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(PLCONRowId,PLCONCode,PLCONDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:显示胎盘情况
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:PAC_PlacentaCondtion  
/// Others:w ##class(web.DHCBL.CT.PACPlacentaCondtion).OpenData("18")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACPlacentaCondtion).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.PACPlacentaCondtion).%New()
 s eobj.PLCONRowId=sid
 s eobj.PLCONCode = pobj.PLCONCode
 s eobj.PLCONDesc = pobj.PLCONDesc
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table：PAC_PlacentaCondtion
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写 
 s:code'="" flagc=$d(^PAC("PLCON",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("PLCON",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("PLCON",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("PLCON",0,"Desc",desc,0))
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

/// Function:实现对胎盘情况的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid号来删除胎盘情况
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_PlacentaCondtion  
/// Others:d ##class(web.DHCBL.CT.PACPlacentaCondtion).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    Tstart
    s pobj = ##class(User.PACPlacentaCondtion).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACPlacentaCondtion).%New()
    s eobj.PLCONRowId=id
    s eobj.PLCONCode = pobj.PLCONCode
    s eobj.PLCONDesc = pobj.PLCONDesc
   
    s sc=##class(User.PACPlacentaCondtion).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PlacentaCondtion","User.PACPlacentaCondtion","胎盘情况",id,eobj.PLCONDesc,"D",eobj)
      d eobj.%Close()
    }
    else
    {
      Trollback
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘情况","web.DHCBL.CT.PACPlacentaCondtion","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
   }
   q result
}

/// Function:实现对胎盘情况的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改胎盘情况
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_PlacentaCondtion  
ClassMethod SaveEntity(eobj As web.Entity.CT.PACPlacentaCondtion) As %String
{
  s $zt="ERROR"
  s result=""
  if $IsObject(eobj)
 {
  if (eobj.PLCONRowId="")       
  {
   //RowId未赋值,增加
   s obj=##class(User.PACPlacentaCondtion).%New()
  }else                           
  { 
   s obj=##class(User.PACPlacentaCondtion).%OpenId(eobj.PLCONRowId)
   s bobj=##class(web.Entity.CT.PACPlacentaCondtion).%New()
   s bobj.PLCONRowId=eobj.PLCONRowId
   s bobj.PLCONCode = obj.PLCONCode                      
   s bobj.PLCONDesc= obj.PLCONDesc  
  }
   s obj.PLCONCode = eobj.PLCONCode                      
   s obj.PLCONDesc= eobj.PLCONDesc                    
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
     Tcommit
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"        
     d:eobj.PLCONRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PlacentaCondtion","User.PACPlacentaCondtion","胎盘情况",eobj.PLCONRowId,eobj.PLCONDesc,"U",eobj,bobj)
     d:eobj.PLCONRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PlacentaCondtion","User.PACPlacentaCondtion","胎盘情况",id,eobj.PLCONDesc,"A",eobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘情况","web.DHCBL.CT.PACPlacentaCondtion","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    } 
  }
  else
  {
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘情况","web.DHCBL.CT.PACPlacentaCondtion","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)="对象不存在！"
    s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
 q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎盘情况","web.DHCBL.CT.PACPlacentaCondtion","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

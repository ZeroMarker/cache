/// CreateDate:2012-08-30
/// Creator:基础数据平台 ，孙凤超
/// Function: 胎位维护
Class web.DHCBL.CT.PACBabyPosition Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询胎位
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_BabyPosition 
/// Input: rowid, code, desc, query 
/// Output: BABYPOS_RowId BABYPOS_Code BABYPOS_Desc BABYPOS_NationalCode 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBabyPosition ","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BABYPOSRowId:%String,BABYPOSCode:%String,BABYPOSDesc:%String,BABYPOSNationalCode:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr= ##class(web.DHCBL.Authorize.PACBabyPosition).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
  s BABYPOSRowId=rowid
  s BABYPOSCode=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",1)
  s BABYPOSDesc=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",2)
  s BABYPOSNationalCode=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",3)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BabyPosition",BABYPOSRowId)
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
  s BABYPOSRowId=0
  for
  {
    s BABYPOSRowId=$o(^PAC("BABYPOS",BABYPOSRowId)) q:BABYPOSRowId=""  
    s strBABYPOSRowId="{ID:"_BABYPOSRowId_"}"
    if (AuStr[strBABYPOSRowId)||(AuFlag=1) 
    {
      s BABYPOSCode=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",1)
      s BABYPOSDesc=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",2) 
      s BABYPOSNationalCode=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",3)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BabyPosition",BABYPOSRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BabyPosition",BABYPOSRowId,BABYPOSDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(BABYPOSCode,"U")[code)&(AliasFlag=1)  
      {
        d OutputRow
      }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(BABYPOSRowId,BABYPOSCode,BABYPOSDesc,BABYPOSNationalCode,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为combo提供查询胎位的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_BabyPosition 
/// Input: desc
/// Output: BABYPOS_RowId BABYPOS_Code BABYPOS_Desc BABYPOS_NationalCode 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBabyPosition","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BABYPOSRowId:%String, BABYPOSCode:%String,BABYPOSDesc:%String ")
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
  s AuStr=##class(web.DHCBL.Authorize.PACBabyPostion).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
    s BABYPOSRowId=rowid
    s BABYPOSCode=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",1)
    s BABYPOSDesc=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",2)
    d OutputRowCmb
 }
 else
 {
  s BABYPOSRowId=0
  for
  {
    s BABYPOSRowId=$o(^PAC("BABYPOS",BABYPOSRowId)) q:BABYPOSRowId=""  
    s strBABYPOSRowId="{ID:"_BABYPOSRowId_"}"
    if (AuStr[strBABYPOSRowId)||(AuFlag=1) 
    {
      s BABYPOSCode=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",1)
      s BABYPOSDesc=$p($g(^PAC("BABYPOS",BABYPOSRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BabyPosition",BABYPOSRowId,BABYPOSDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(BABYPOSCode,"U")[code)&(AliasFlag=1)   
      {
        d OutputRowCmb
      }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(BABYPOSRowId,BABYPOSCode,BABYPOSDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:   显示胎位结果
/// CreateDate: 2012-08-30
/// Creator:    基础数据平台公共产品组 孙凤超
/// Input:      id
/// Tables:     PAC_BabyPosition  
ClassMethod OpenData(id As %String) As %String
{
 ;w ##class(web.DHCBL.CT.PACBabyPosition).OpenData("1")
 s str=""
 s pobj = ##class(User.PACBabyPosition).%OpenId(id)
 s eobj = ##class(web.Entity.CT.PACBabyPosition).%New()
 s eobj.BABYPOSRowId=id
 s eobj.BABYPOSCode = pobj.BABYPOSCode
 s eobj.BABYPOSDesc = pobj.BABYPOSDesc
 s eobj.BABYPOSNationalCode=pobj.BABYPOSNationalCode
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对胎位的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid号来删除分娩结果
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_BabyPosition 
/// Others:d ##class(web.DHCBL.CT.PACBabyPosition).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    Tstart
    s pobj = ##class(User.PACBabyPosition).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACBabyPosition).%New()
    s eobj.BABYPOSRowId=id
    s eobj.BABYPOSCode = pobj.BABYPOSCode
    s eobj.BABYPOSDesc = pobj.BABYPOSDesc
    s eobj.BABYPOSNationalCode=pobj.BABYPOSNationalCode
    
    s sc=##class(User.PACBabyPosition).%DeleteId(id)
    IF $$$ISOK(sc)
   {
      Tc
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BabyPosition","User.PACBabyPosition","胎位",id,eobj.BABYPOSDesc,"D",eobj)
      s result= "{success:'true',info:'删除成功！'}" 
      d eobj.%Close()
   }
   else
  {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎位","web.DHCBL.CT.PACBabyPosition","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
 q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table：PAC_BabyPosition 
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="", flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s:code'="" flagc=$d(^PAC("BABYPOS",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("BABYPOS",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("BABYPOS",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("BABYPOS",0,"Desc",desc,0))
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

/// Function:实现对胎位的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改分娩结果
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_BabyPosition 
ClassMethod SaveEntity(eobj As web.Entity.CT.PACBabyPosition) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  //如果RowId未赋值则增加
  if (eobj.BABYPOSRowId="")       
  {
   s obj=##class(User.PACBabyPosition).%New()
  }
  else 
 {
   s obj=##class(User.PACBabyPosition).%OpenId(eobj.BABYPOSRowId)
   s bobj=##class(web.Entity.CT.PACBabyPosition).%New()
   s bobj.BABYPOSRowId=eobj.BABYPOSRowId
   s bobj.BABYPOSCode = obj.BABYPOSCode                       
   s bobj.BABYPOSDesc= obj.BABYPOSDesc
   s bobj.BABYPOSNationalCode=obj.BABYPOSNationalCode
 }
  s obj.BABYPOSCode = eobj.BABYPOSCode                       
  s obj.BABYPOSDesc= eobj.BABYPOSDesc
  s obj.BABYPOSNationalCode=eobj.BABYPOSNationalCode
  Tstart
  s sc=obj.%Save()
  if $$$ISOK(sc)
  {
   Tcommit
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
   d:eobj.BABYPOSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BabyPosition","User.PACBabyPosition","胎位",eobj.BABYPOSRowId,eobj.BABYPOSDesc,"U",eobj,bobj)
   d:eobj.BABYPOSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BabyPosition","User.PACBabyPosition","胎位",id,eobj.BABYPOSDesc,"A",eobj)
  }
  else
 {
   Trollback
   s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎位","web.DHCBL.CT.PACBabyPosition","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 } 
}
 else
 {
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎位","web.DHCBL.CT.PACBabyPosition","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
ERROR
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("胎位","web.DHCBL.CT.PACBabyPosition","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'保存失败！'}"
}

}

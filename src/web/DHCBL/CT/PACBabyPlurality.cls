/// CreateDate:2012-08-30
/// Creator:基础数据平台 ，孙凤超
/// Function: 婴儿数量维护
/// Tables:PAC_BabyPlurality
Class web.DHCBL.CT.PACBabyPlurality Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询婴儿数量
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_BabyPlurality  
/// Output:  PLUR_RowId PLUR_Code PLUR_Desc PLUR_BabyCount 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBabyPlurality", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, count As %String) As %Query(ROWSPEC = "PLURRowId:%String,PLURCode:%String,PLURDesc:%String,PLURBabyCount:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, count As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.PACBabyPlurality).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s PLURRowId=rowid
  s PLURCode=$p($g(^PAC("PLUR",PLURRowId)),"^",1)
  s PLURDesc=$p($g(^PAC("PLUR",PLURRowId)),"^",2)
  s PLURBabyCount=$p($g(^PAC("PLUR",PLURRowId)),"^",3)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BabyPlurality",PLURRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  s BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4)
  d OutputRow
 }
 else
 {
   s:code'="" code=$zcvt(code,"U") 
   s:desc'="" desc=$zcvt(desc,"U")
   s PLURRowId=0
   for
   {
    s PLURRowId=$o(^PAC("PLUR",PLURRowId)) q:PLURRowId="" 
    s strPLURRowId="{ID:"_PLURRowId_"}"
    if (AuStr[strPLURRowId)||(AuFlag=1)
    {
      s PLURCode=$p($g(^PAC("PLUR",PLURRowId)),"^",1)
      s PLURDesc=$p($g(^PAC("PLUR",PLURRowId)),"^",2) 
      s PLURBabyCount=$p($g(^PAC("PLUR",PLURRowId)),"^",3)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BabyPlurality",PLURRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BabyPlurality",PLURRowId,PLURDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(PLURCode,"U")[code)&(AliasFlag=1)&(PLURBabyCount[count)  
      {
        d OutputRow
      }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(PLURRowId,PLURCode,PLURDesc,PLURBabyCount,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，查询婴儿数量
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_BabyPlurality  
/// Input:  desc
/// Output:  PLUR_RowId PLUR_Code PLUR_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBabyPlurality", "GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PLURRowId:%String, PLURCode:%String,PLURDesc:%String ")
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
 s AuStr=##class(web.DHCBL.Authorize.PACBabyPlurality).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 if (rowid'="")  
 {
   s PLURRowId=rowid
   s PLURCode=$p($g(^PAC("PLUR",PLURRowId)),"^",1)
   s PLURDesc=$p($g(^PAC("PLUR",PLURRowId)),"^",2)
   d OutputRowCmb
 }
 else
{
  s PLURRowId=0
  for
  {
    s PLURRowId=$o(^PAC("PLUR",PLURRowId)) q:PLURRowId="" 
    s strPLURRowId="{ID:"_PLURRowId_"}"
    if (AuStr[strPLURRowId)||(AuFlag=1)
    {
      s PLURCode=$p($g(^PAC("PLUR",PLURRowId)),"^",1)
      s PLURDesc=$p($g(^PAC("PLUR",PLURRowId)),"^",2) 
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BabyPlurality",PLURRowId,PLURDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(PLURCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRowCmb
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(PLURRowId,PLURCode,PLURDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:实现对新生儿数量的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid号来删除新生儿数量信息
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_BabyPlurality 
/// Others:d ##class(web.DHCBL.CT.PACBabyPlurality).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s pobj = ##class(User.PACBabyPlurality).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACBabyPlurality).%New()
    s eobj.PLURRowId = id
    S eobj.PLURCode=pobj.PLURCode
    s eobj.PLURDesc= pobj.PLURDesc
    s eobj.PLURBabyCount=pobj.PLURBabyCount
    
    s sc=##class(User.PACBabyPlurality).%DeleteId(id)
    IF $$$ISOK(sc)
   {
     Tc
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BabyPlurality","User.PACBabyPlurality","婴儿数量",id,eobj.PLURDesc,"D",eobj)
     d eobj.%Close()
   }
    else
   {
      Trollback
      s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婴儿数量","web.DHCBL.CT.PACBabyPlurality","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
    q result
}

/// Function:用于双击修改时的数据加载 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:PAC_BabyPlurality 
/// Others:w ##class(web.DHCBL.CT.PACBabyPlurality).OpenData("200")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACBabyPlurality).%OpenId(id)
 s eobj = ##class(web.Entity.CT.PACBabyPlurality).%New()
 s eobj.PLURRowId = id
 S eobj.PLURCode=pobj.PLURCode
 s eobj.PLURDesc= pobj.PLURDesc
 s eobj.PLURBabyCount=pobj.PLURBabyCount
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:进行数据重复校验功能，并返回一个标志位
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-12-03
/// Table:PAC_BabyPlurality 
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 
 s flag="",flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s:code'="" flagc=$d(^PAC("PLUR",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("PLUR",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0))
  {
   s flag=1   
  }
  else
  {
   s flag=0  
  }
 }
 else  
 {
  s idc="", idd=""
  s:code'="" idc=$o(^PAC("PLUR",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("PLUR",0,"Desc",desc,0))
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

/// Function:实现对新生儿数量的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改新生儿数量
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_BabyPlurality   
ClassMethod SaveEntity(eobj As web.Entity.CT.PACBabyPlurality) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  //如果RowId未赋值则增加
  if (eobj.PLURRowId="")       
  {
   s obj=##class(User.PACBabyPlurality).%New()
  } 
  else 
  { //RowId已存在,修改
   s obj=##class(User.PACBabyPlurality).%OpenId(eobj.PLURRowId)
   s bobj=##class(web.Entity.CT.PACBabyPlurality).%New()
   
   s bobj.PLURRowId=eobj.PLURRowId
   s bobj.PLURCode = obj.PLURCode
   s bobj.PLURDesc = obj.PLURDesc
   s bobj.PLURBabyCount = obj.PLURBabyCount
  }
   s obj.PLURCode = eobj.PLURCode
   s obj.PLURDesc = eobj.PLURDesc
   s obj.PLURBabyCount = eobj.PLURBabyCount
  Tstart
  s sc=obj.%Save()
  if $$$ISOK(sc)
  {
   Tcommit
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
   d:eobj.PLURRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BabyPlurality","User.PACBabyPlurality","婴儿数量",eobj.PLURRowId,eobj.PLURDesc,"U",eobj,bobj)
   d:eobj.PLURRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BabyPlurality","User.PACBabyPlurality","婴儿数量",id,eobj.PLURDesc,"A",eobj)
  }
  else
  {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婴儿数量","web.DHCBL.CT.PACBabyPlurality","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
 }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婴儿数量","web.DHCBL.CT.PACBabyPlurality","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婴儿数量","web.DHCBL.CT.PACBabyPlurality","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

/// CreateDate:2012-08-29
/// Creator:基础数据平台 ，孙凤超
/// Function: 新生儿评分(阿氏评分)
/// Tables:PAC_ApgarScore   
Class web.DHCBL.CT.PACApgarScore Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询新生儿评分(阿氏评分)信息
/// CreateDate:2012-08-29
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: PAC_ApgarScore   
/// Output: APGS_RowId,APGS_Code,APGS_Desc,APGS_NationalCode,APGS_Count
/// LastUpdate: 2014/10/31 增加 "别名"查找
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACApgarScore", "GetList","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, nationalcode As %String, score As %String) As %Query(ROWSPEC = "APGSRowId:%String,APGSCode:%String,APGSDesc:%String,APGSNationalCode:%String,APGSCount:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, nationalcode As %String, score As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.PACApgarScore).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s APGSRowId=rowid
  s APGSCode=$p($g(^PAC("APGS",APGSRowId)),"^",1)
  s APGSDesc=$p($g(^PAC("APGS",APGSRowId)),"^",2)
  s APGSNationalCode=$p($g(^PAC("APGS",APGSRowId)),"^",3)
  s APGSCount=$p($g(^PAC("APGS",APGSRowId)),"^",4)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ApgarScore",APGSRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  s BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4)
  d OutputRow
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U")  
   s:desc'="" desc=$ZCONVERT(desc,"U")
   s APGSRowId=0
   for
   {
      s APGSRowId=$o(^PAC("APGS",APGSRowId)) q:APGSRowId=""  
      s strAPGSRowId="{ID:"_APGSRowId_"}"
      if (AuStr[strAPGSRowId)||(AuFlag=1) 
      {
        s APGSCode=$p($g(^PAC("APGS",APGSRowId)),"^",1)
        s APGSDesc=$p($g(^PAC("APGS",APGSRowId)),"^",2)
        s APGSNationalCode=$p($g(^PAC("APGS",APGSRowId)),"^",3)
        s APGSCount=$p($g(^PAC("APGS",APGSRowId)),"^",4)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ApgarScore",APGSRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ApgarScore",APGSRowId,APGSDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        }    
        if ($ZCVT(APGSCode,"U")[code)&(AliasFlag=1)&(APGSNationalCode[nationalcode)&(APGSCount[score)  
        {
          d OutputRow
        }
      }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(APGSRowId,APGSCode,APGSDesc,APGSNationalCode,APGSCount,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    if (Data=""){
     s Data="{success:'false',info:'no data！'}"
    }
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

/// Function:为CombBox提供查询新生儿评分(阿氏评分)信息的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:PAC_ApgarScore    
/// Output: APGS_RowId,APGS_Code,APGS_Desc,APGS_NationalCode,APGS_Count
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACApgarScore", "GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "APGSRowId:%String, APGSCode:%String,APGSDesc:%String ")
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
 s:code'="" code=$ZCONVERT(code,"U")  
 s:desc'="" desc=$ZCONVERT(desc,"U")  
 s AuStr=##class(web.DHCBL.Authorize.PACApgarScore).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
  s APGSRowId=rowid
  s APGSCode=$p($g(^PAC("APGS",APGSRowId)),"^",1)
  s APGSDesc=$p($g(^PAC("APGS",APGSRowId)),"^",2) 
  d OutputRowCmb
 }
 else
 {
   s APGSRowId=0
   for
   {
    s APGSRowId=$o(^PAC("APGS",APGSRowId)) q:APGSRowId=""  
    s strAPGSRowId="{ID:"_APGSRowId_"}"
    if (AuStr[strAPGSRowId)||(AuFlag=1) 
    {
      s APGSCode=$p($g(^PAC("APGS",APGSRowId)),"^",1)
      s APGSDesc=$p($g(^PAC("APGS",APGSRowId)),"^",2)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ApgarScore",APGSRowId,APGSDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(APGSCode,"U")[code)&(AliasFlag=1)  
      {
        d OutputRowCmb
      }
    }
   }
 }
OutputRowCmb   
 set Data=$lb(APGSRowId,APGSCode,APGSDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:用于双击修改时加载新生儿评分(阿氏评分)信息 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables:PAC_ApgarScore
/// Others:w ##class(web.DHCBL.CT.PACApgarScore).OpenData("109")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACApgarScore).%OpenId(id)
 s eobj = ##class(web.Entity.CT.PACApgarScore).%New()
 s eobj.APGSRowId = id
 s eobj.APGSCode = pobj.APGSCode
 s eobj.APGSDesc = pobj.APGSDesc
 s eobj.APGSNationalCode=pobj.APGSNationalCode
 s eobj.APGSCount=pobj.APGSCount
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对新生儿评分(阿氏评分)信息的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过输入id号来删除新生儿评分(阿氏评分)的信息
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_ApgarScore 
/// Others:d ##class(web.DHCBL.CT.PACApgarScore)DeleteData("16")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart  
    s pobj = ##class(User.PACApgarScore).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACApgarScore).%New()
    s eobj.APGSRowId = id
    s eobj.APGSCode = pobj.APGSCode
    s eobj.APGSDesc = pobj.APGSDesc
    s eobj.APGSNationalCode=pobj.APGSNationalCode
    s eobj.APGSCount=pobj.APGSCount
     
    s sc=##class(User.PACApgarScore).%DeleteId(id)
    IF ($$$ISOK(sc)) 
    {
      Tc  
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ApgarScore","User.PACApgarScore","新生儿得分(阿氏评分)",id,eobj.APGSDesc,"D",eobj)
      d eobj.%Close()
    }
     else
     {
      Trollback
      s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新生儿得分(阿氏评分)","web.DHCBL.CT.PACApgarScore","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
   q result
}

/// Function:进行数据重复校验功能，并返回一个标志位
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-12-03
/// Table:PAC_ApgarScore
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 
 s flag="", flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^PAC("APGS",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("APGS",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("APGS",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("APGS",0,"Desc",desc,0))
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

/// Function:实现对新生儿评分(阿氏评分)的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-30
/// Desc:通过rowid来修改新生儿评分(阿氏评分)
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_ApgarScore 
ClassMethod SaveEntity(eobj As web.Entity.CT.PACApgarScore) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  if (eobj.APGSRowId="")       
  {
   s obj=##class(User.PACApgarScore).%New()
  }else                           
  {
   s obj=##class(User.PACApgarScore).%OpenId(eobj.APGSRowId)
   s bobj=##class(web.Entity.CT.PACApgarScore).%New()
   s bobj.APGSRowId=eobj.APGSRowId
   s bobj.APGSCode = obj.APGSCode                      
   s bobj.APGSDesc= obj.APGSDesc                      
   s bobj.APGSNationalCode = obj.APGSNationalCode 
   s bobj.APGSCount=obj.APGSCount   
  }
   s obj.APGSCode = eobj.APGSCode                      
   s obj.APGSDesc= eobj.APGSDesc                      
   s obj.APGSNationalCode = eobj.APGSNationalCode 
   s obj.APGSCount=eobj.APGSCount    
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
  {
   Tcommit
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
   d:eobj.APGSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ApgarScore","User.PACApgarScore","新生儿评分(阿氏评分)",eobj.APGSRowId,eobj.APGSDesc,"U",eobj,bobj)
   d:eobj.APGSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ApgarScore","User.PACApgarScore","新生儿评分(阿氏评分)",id,eobj.APGSDesc,"A",eobj)
  }
    else
  {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新生儿评分(阿氏评分)","web.DHCBL.CT.PACApgarScore","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  } 
 }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新生儿评分(阿氏评分)","web.DHCBL.CT.PACApgarScore","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("新生儿评分(阿氏评分)","web.DHCBL.CT.PACApgarScore","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

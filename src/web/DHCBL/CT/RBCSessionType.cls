/// CreateDate:2012-08-31
/// Creator:基础数据平台 ，孙凤超
/// Function: 资源预约 挂号职称维护
Class web.DHCBL.CT.RBCSessionType Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "RBC_SessionType";

/// Function:进行数据检索，查询挂号职称 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Table:  RBC_SessionType
/// Input:  rowid, code, desc, query
/// Output: SESSRowId,SESSCode,SESSDesc,SESSSessionTypeDR,SESSNumberOfDays,SESSEnableByDefault,SESSDateFrom,SESSDateTo  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCSessionType","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, active As %String, hospid As %String) As %Query(ROWSPEC = "SESSRowId:%String,SESSCode:%String,SESSDesc:%String,SESSCategory:%String,SESSSessionTypeDR:%String,SESSNumberOfDays:%String,SESSEnableByDefault:%String,SESSDateFrom:%String,SESSDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.RBCSessionType).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s SESSRowId=rowid
   s SESSCode=$p($g(^RBC("SESS",SESSRowId)),"^",1)
   s SESSDesc=$p($g(^RBC("SESS",SESSRowId)),"^",2)
   s SESSSessionTypeDR=$p($g(^RBC("SESS",SESSRowId)),"^",3)
   s:SESSSessionTypeDR'="" SESSSessionTypeDR=$p($g(^RBC("SESS",SESSSessionTypeDR)),"^",2)   
   s SESSNumberOfDays=$p($g(^RBC("SESS",SESSRowId)),"^",4)
   s SESSEnableByDefault=$p($g(^RBC("SESS",SESSRowId)),"^",5)
   s SESSDateFrom=$p($g(^RBC("SESS",SESSRowId)),"^",6)
   s SESSDateTo=$p($g(^RBC("SESS",SESSRowId)),"^",7)
   s:SESSDateFrom'="" SESSDateFrom=$zd(SESSDateFrom,1)
   s:SESSDateTo'="" SESSDateTo=$zd(SESSDateTo,1) 
   s SESSCategory=$p($g(^RBC("SESS",SESSRowId)),"^",12) // N,S,D,DP,E 普通Normal、专家Specialist、主任Director、副主任DeputyDirector、急诊Emergency
   s:SESSCategory="N" SESSCategory="普通"
   s:SESSCategory="S" SESSCategory="专家"
   s:SESSCategory="D" SESSCategory="主任"
   s:SESSCategory="DP" SESSCategory="副主任"
   s:SESSCategory="E" SESSCategory="急诊"
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_SessionType",SESSRowId)
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
   s SESSRowId=0
   for
   {
     s SESSRowId=$o(^RBC("SESS",SESSRowId))  q:SESSRowId="" 
     s strSESSRowId="{ID:"_SESSRowId_"}"
     if (AuStr[strSESSRowId)||(AuFlag=1)
     {
        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SESSRowId,hospid)
        continue:showflag="N" 
        s SESSCode=$p($g(^RBC("SESS",SESSRowId)),"^",1)
        s SESSDesc=$p($g(^RBC("SESS",SESSRowId)),"^",2) 
        s SESSSessionTypeDR=$p($g(^RBC("SESS",SESSRowId)),"^",3)
        s:SESSSessionTypeDR'="" SESSSessionTypeDR=$p($g(^RBC("SESS",SESSSessionTypeDR)),"^",2)
        s SESSNumberOfDays=$p($g(^RBC("SESS",SESSRowId)),"^",4)
        s SESSEnableByDefault=$p($g(^RBC("SESS",SESSRowId)),"^",5)
        s SESSDateFrom=$p($g(^RBC("SESS",SESSRowId)),"^",6)
        s SESSDateTo=$p($g(^RBC("SESS",SESSRowId)),"^",7)
        s:SESSDateFrom'="" SESSDateFrom=$zd(SESSDateFrom,1)
        s:SESSDateTo'="" SESSDateTo=$zd(SESSDateTo,1) 
        s SESSCategory=$p($g(^RBC("SESS",SESSRowId)),"^",12) // N,S,D,DP,E 普通Normal、专家Specialist、主任Director、副主任DeputyDirector、急诊Emergency
        s:SESSCategory="N" SESSCategory="普通"
        s:SESSCategory="S" SESSCategory="专家"
        s:SESSCategory="D" SESSCategory="主任"
        s:SESSCategory="DP" SESSCategory="副主任"
        s:SESSCategory="E" SESSCategory="急诊"
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_SessionType",SESSRowId) 
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_SessionType",SESSRowId,SESSDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        } 
        if ($ZCVT(SESSCode,"U")[code)&(AliasFlag=1)&(SESSEnableByDefault[active) 
        {
          d OutputRow
        }
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(SESSRowId,SESSCode,SESSDesc,SESSCategory,SESSSessionTypeDR,SESSNumberOfDays,SESSEnableByDefault,SESSDateFrom,SESSDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，查询SESSSessionTypeDR挂号职称 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  RBC_SessionType  
/// Output: SESS_RowId SESS_Code SESS_Desc    
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCSessionType","GetDataForCmb1","","") 
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "SESSRowId:%String, SESSCode:%String,SESSDesc:%String ")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
 
  s repid=$I(^CacheTemp)
  s ind=1
  
  s:desc'="" desc=$ZCONVERT(desc,"U")
  s:code'="" code=$ZCONVERT(code,"U")
  s AuStr=##class(web.DHCBL.Authorize.RBCSessionType).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="")  
  {
   s SESSRowId=rowid
   s SESSCode=$p($g(^RBC("SESS",SESSRowId)),"^",1)
   s SESSDesc=$p($g(^RBC("SESS",SESSRowId)),"^",2)
   d OutputRow2
  }
 else
 {
   s SESSRowId=0
   for
   {
     s SESSRowId=$o(^RBC("SESS",SESSRowId))  
     q:SESSRowId="" 
     s SESSDateFrom=$p($g(^RBC("SESS",SESSRowId)),"^",6)
     continue:(SESSDateFrom'="")&&(SESSDateFrom>+$h)
     s SESSDateTo=$p($g(^RBC("SESS",SESSRowId)),"^",7)
     continue:(SESSDateTo'="")&&(SESSDateTo<+$h)
     s strSESSRowId="{ID:"_SESSRowId_"}"
     if (AuStr[strSESSRowId)||(AuFlag=1)
     {
        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SESSRowId,hospid)
        continue:showflag="N" 
        s SESSCode=$p($g(^RBC("SESS",SESSRowId)),"^",1)
        s SESSDesc=$p($g(^RBC("SESS",SESSRowId)),"^",2)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_SessionType",SESSRowId,SESSDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        } 
        if ($ZCVT(SESSCode,"U")[code)&(AliasFlag=1) 
        {
          d OutputRow2
        }
     }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(SESSRowId,SESSCode,SESSDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:显示挂号职称 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables: RBC_SessionType
/// Others:w ##class(web.DHCBL.CT.RBCSessionType).OpenData("12")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.RBCSessionType).%OpenId(id)
 s eobj = ##class(web.Entity.CT.RBCSessionType).%New()
 s eobj.SESSRowId = id
 S eobj.SESSCode=pobj.SESSCode
 s eobj.SESSDesc= pobj.SESSDesc
 if (pobj.SESSSessionTypeDR'="")
 {
   s eobj.SESSSessionTypeDR = pobj.SESSSessionTypeDR.%Id() 
 }
 else
 {
   s eobj.SESSSessionTypeDR=""
 }
 s eobj.SESSCategory=pobj.SESSCategory
 s eobj.SESSNumberOfDays=pobj.SESSNumberOfDays
 s:eobj.SESSEnableByDefault="Y" eobj.SESSEnableByDefault="true" 
 s:pobj.SESSDateFrom'="" eobj.SESSDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SESSDateFrom)    
 s:pobj.SESSDateTo'="" eobj.SESSDateTo =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SESSDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：基础数据平台 孙凤超
/// CreatDate: 2012-11-28
/// Description：数据校验功能
/// Table：RBC_AppointMethod
/// s sc=##class(web.Entity.CT.RBCSessionType).FormValidate("2","包2","APCVCCode")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^RBC("SESS",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
                //2022-12-30限制代码跨院区也不能重复
                //s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
                //continue:showflag="N"
                s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)
            {
                ///私有数据
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    q flag
}

/// Function: 用于删除时的逻辑判断 
/// Creator: 基础数据平台组 孙凤超
/// CreateDate: 2013-11-14
/// Debug:w ##class(web.DHCBL.CT.RBCSessionType).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s SESSRowId=0,found1=0
    for
    {
      s SESSRowId=$o(^RBC("SESS",SESSRowId))  
      q:SESSRowId="" 
      q:found1  
      s SESSSessionTypeDR=$p($g(^RBC("SESS",SESSRowId)),"^",3) 
      i SESSSessionTypeDR=id s found1=1
   }
   i (found1=1)  s myInfo=myInfo_"<挂号职称>"
   if (myInfo="")
   {
    s return="0^未被引用可删除！"
   }
   else 
   {
    s return="1^在"_myInfo_"表里被引用,不能删除!"
   }
    q return
}

/// Function:实现对挂号职称的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-31
/// Desc:通过rowid号来删除挂号职称 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: RBC_SessionType
/// Others:d ##class(web.DHCBL.CT.RBCSessionType).DeleteRBCSessionType("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.CT.RBCSessionType).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=1)
    {
      s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {  
        s pobj = ##class(User.RBCSessionType).%OpenId(id)
        s eobj = ##class(web.Entity.CT.RBCSessionType).%New()
        s eobj.SESSRowId = id
        S eobj.SESSCode=pobj.SESSCode
        s eobj.SESSDesc= pobj.SESSDesc
        if (pobj.SESSSessionTypeDR'="")
        {
          s eobj.SESSSessionTypeDR = pobj.SESSSessionTypeDR.%Id() 
        }
        else
        {
         s eobj.SESSSessionTypeDR=""
        }
        s eobj.SESSNumberOfDays=pobj.SESSNumberOfDays
        s:eobj.SESSEnableByDefault="Y" eobj.SESSEnableByDefault="true"
        s:pobj.SESSDateFrom'="" eobj.SESSDateFrom =pobj.SESSDateFrom   
        s:pobj.SESSDateTo'="" eobj.SESSDateTo = pobj.SESSDateTo 
        s eobj.SESSCategory=pobj.SESSCategory
        Tstart
        s sc=##class(User.RBCSessionType).%DeleteId(id)
        if $$$ISOK(sc)
        {
           Tcommit
           d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_SessionType","User.RBCSessionType","挂号职称",id,eobj.SESSDesc,"D",eobj)
           s result="{success:'true',info:'删除成功！'}"
           d eobj.%Close()
        }
        else
        {
          Trollback
          s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
          s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("挂号职称","web.DHCBL.CT.RBCSessionType","DeleteData",eobj)
          s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
  }
 q result
}

/// Function:实现对挂号职称 的修改增加操作
/// Creator:孙凤超
/// Tables: RBC_SessionType
/// CreateDate:2012-08-31
/// Desc:通过rowid来修改挂号职称 
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCSessionType) As %String
{
 
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.SESSDateFrom'="" eobj.SESSDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SESSDateFrom)   
  s:eobj.SESSDateTo'="" eobj.SESSDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SESSDateTo)        
  s:eobj.SESSDateFrom="" eobj.SESSDateFrom=+$h 
  s:eobj.SESSCategory="普通" eobj.SESSCategory="N"
  s:eobj.SESSCategory="专家" eobj.SESSCategory="S"
  s:eobj.SESSCategory="主任" eobj.SESSCategory="D"
  s:eobj.SESSCategory="副主任" eobj.SESSCategory="DP"
  s:eobj.SESSCategory="急诊" eobj.SESSCategory="E"
  if (eobj.SESSRowId="")       
  {
   //RowId未赋值,增加
   s obj=##class(User.RBCSessionType).%New()
  }else                           
  {
   //RowId已存在,修改
   s obj=##class(User.RBCSessionType).%OpenId(eobj.SESSRowId)
   s bobj=##class(web.Entity.CT.RBCSessionType).%New()
   s bobj.SESSRowId=eobj.SESSRowId
   s bobj.SESSCode = obj.SESSCode                      
   s bobj.SESSDesc= obj.SESSDesc  
   s:obj.SESSSessionTypeDR'="" bobj.SESSSessionTypeDR=obj.SESSSessionTypeDR.%Id()
   s bobj.SESSNumberOfDays=obj.SESSNumberOfDays //天数
   s bobj.SESSEnableByDefault=obj.SESSEnableByDefault //默认
   s bobj.SESSDateFrom=obj.SESSDateFrom
   s bobj.SESSDateTo=obj.SESSDateTo     
  }
  s obj.SESSCode = eobj.SESSCode                      
  s obj.SESSDesc= eobj.SESSDesc  
  d obj.SESSSessionTypeDRSetObjectId(eobj.SESSSessionTypeDR)        
  s obj.SESSNumberOfDays=eobj.SESSNumberOfDays //天数
  s:eobj.SESSEnableByDefault="" eobj.SESSEnableByDefault="N"
  s obj.SESSEnableByDefault=eobj.SESSEnableByDefault //默认 
  s obj.SESSCategory=eobj.SESSCategory  
  s obj.SESSDateFrom=eobj.SESSDateFrom
  s obj.SESSDateTo=eobj.SESSDateTo    
  Tstart
  s sc=obj.%Save()
  if $$$ISOK(sc)
  {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.SESSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_SessionType","User.RBCSessionType","挂号职称",eobj.SESSRowId,eobj.SESSDesc,"U",eobj,bobj)
    d:eobj.SESSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_SessionType","User.RBCSessionType","挂号职称",id,eobj.SESSDesc,"A",eobj)
  }
 else
 {
   Trollback
   s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("挂号职称","web.DHCBL.CT.RBCSessionType","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 } 
}
 else
 {
    s result = "{success:'false',errorinfo:'对象不存在！'}"
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("挂号职称","web.DHCBL.CT.RBCSessionType","SaveEntity","")
    s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
  q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("挂号职称","web.DHCBL.CT.RBCSessionType","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

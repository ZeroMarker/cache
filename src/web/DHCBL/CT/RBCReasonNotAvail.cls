/// CreateDate:2012-08-29
/// Creator:基础数据平台 ，孙凤超
/// Function: 资源预约 不可用原因维护
/// Tables: RBC_ReasonNotAvail   
Class web.DHCBL.CT.RBCReasonNotAvail Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询资源预约不可用原因的信息
/// CreateDate:2012-08-29
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: RBC_ReasonNotAvail
/// Input: rowid, code, desc, query
/// Output:RNAV_RowId,RNAV_Code ,RNAV_Desc, RNAV_Type ,RNAV_DateFrom ,RNAV_DateTo 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCReasonNotAvail", "GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, active As %String) As %Query(ROWSPEC = "RNAVRowId:%String,RNAVCode:%String,RNAVDesc:%String,RNAVType:%String,RNAVDateFrom:%String,RNAVDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
 s AuStr=  ##class(web.DHCBL.Authorize.RBCReasonNotAvail).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s RNAVRowId=rowid
   s RNAVCode=$p($g(^RBC("NA",RNAVRowId)),"^",1)
   s RNAVDesc=$p($g(^RBC("NA",RNAVRowId)),"^",2)
   s RNAVType=$p($g(^RBC("NA",RNAVRowId)),"^",3)
   s RNAVDateFrom=$p($g(^RBC("NA",RNAVRowId)),"^",4)
   s:RNAVDateFrom'="" RNAVDateFrom=$zd(RNAVDateFrom,1)
   s RNAVDateTo=$p($g(^RBC("NA",RNAVRowId)),"^",5)
   s:RNAVDateTo'="" RNAVDateTo=$zd(RNAVDateTo,1)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_ReasonNotAvail",RNAVRowId)
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
 
   s RNAVRowId=0
   for
   {
      s RNAVRowId=$o(^RBC("NA",RNAVRowId))  q:RNAVRowId=""   
      s strRNAVRowId="{ID:"_RNAVRowId_"}"
      if (AuStr[strRNAVRowId)||(AuFlag=1)
      {
        s RNAVCode=$p($g(^RBC("NA",RNAVRowId)),"^",1)
        s RNAVDesc=$p($g(^RBC("NA",RNAVRowId)),"^",2) 
        s RNAVType=$p($g(^RBC("NA",RNAVRowId)),"^",3)
        s RNAVDateFrom=$p($g(^RBC("NA",RNAVRowId)),"^",4)
        s:RNAVDateFrom'="" RNAVDateFrom=$zd(RNAVDateFrom,1)
        s RNAVDateTo=$p($g(^RBC("NA",RNAVRowId)),"^",5)
        s:RNAVDateTo'="" RNAVDateTo=$zd(RNAVDateTo,1)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_ReasonNotAvail",RNAVRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ReasonNotAvail",RNAVRowId,RNAVDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        } 
        if ($ZCVT(RNAVCode,"U")[code)&(AliasFlag=1)&(RNAVType[active) 
        {
          d OutputRow
        }
     }
   } 
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RNAVRowId,RNAVCode,RNAVDesc,RNAVType,RNAVDateFrom,RNAVDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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

/// Function:进行数据检索，为comb提供查询资源预约不可用原因信息的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:RBC_ReasonNotAvail
/// Input: desc 
/// Output:RNAV_RowId,RNAV_Code ,RNAV_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCReasonNotAvail", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RNAVRowId:%String, RNAVCode:%String,RNAVDesc:%String ")
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
  s AuStr=##class(web.DHCBL.Authorize.RBCReasonNotAvail).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="")  
  {
    s RNAVRowId=rowid
    s RNAVCode=$p($g(^RBC("NA",RNAVRowId)),"^",1)
    s RNAVDesc=$p($g(^RBC("NA",RNAVRowId)),"^",2)
    d OutputRow2
  }
  else
  {
    s RNAVRowId=0
    for
    {
      s RNAVRowId=$o(^RBC("NA",RNAVRowId))  
      q:RNAVRowId=""
      s RNAVDateFrom=$p($g(^RBC("NA",RNAVRowId)),"^",4)
      continue:(RNAVDateFrom'="")&&(RNAVDateFrom>+$h)   
      s RNAVDateTo=$p($g(^RBC("NA",RNAVRowId)),"^",5) 
      continue:(RNAVDateTo'="")&&(RNAVDateTo<+$h)   
      s strRNAVRowId="{ID:"_RNAVRowId_"}"
      if (AuStr[strRNAVRowId)||(AuFlag=1)
      {
        s RNAVCode=$p($g(^RBC("NA",RNAVRowId)),"^",1)
        s RNAVDesc=$p($g(^RBC("NA",RNAVRowId)),"^",2) 
        s RNAVType=$p($g(^RBC("NA",RNAVRowId)),"^",3)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ReasonNotAvail",RNAVRowId,RNAVDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        } 
        if ($ZCVT(RNAVCode,"U")[code)&(AliasFlag=1) 
        {
           d OutputRow2
        }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
  set Data=$lb(RNAVRowId,RNAVCode,RNAVDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:显示打开窗口时的资源预约不可用原因的信息 
/// CreateDate:2012-08-29
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:RBC_ReasonNotAvail
/// Others:w ##class(web.DHCBL.CT.RBCReasonNotAvail).OpenData("")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.RBCReasonNotAvail).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.RBCReasonNotAvail).%New()
 s eobj.RNAVRowId=sid
 s eobj.RNAVCode = pobj.RNAVCode
 s eobj.RNAVDesc = pobj.RNAVDesc
 
 s:pobj.RNAVType="F" eobj.RNAVType="Functional"
 s:pobj.RNAVType="S" eobj.RNAVType="Structural"
 s:pobj.RNAVDateFrom'="" eobj.RNAVDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RNAVDateFrom)
 s:pobj.RNAVDateTo'="" eobj.RNAVDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RNAVDateTo)
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对资源预约不可用原因的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid来删除资源预约不可用原因
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: RBC_ReasonNotAvail
/// Others:d ##class(web.DHCBL.CT.RBCReasonNotAvail).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
  s result="",flag=""
  Tstart
  s pobj = ##class(User.RBCReasonNotAvail).%OpenId(id)
  s eobj = ##class(web.Entity.CT.RBCReasonNotAvail).%New()
  s eobj.RNAVRowId=id
  s eobj.RNAVCode = pobj.RNAVCode
  s eobj.RNAVDesc = pobj.RNAVDesc
  s:pobj.RNAVType="F" eobj.RNAVType="Functional"
  s:pobj.RNAVType="S" eobj.RNAVType="Structural"
  s:pobj.RNAVDateFrom'="" eobj.RNAVDateFrom=pobj.RNAVDateFrom
  s:pobj.RNAVDateTo'="" eobj.RNAVDateTo=pobj.RNAVDateTo
  
   s sc=##class(User.RBCReasonNotAvail).%DeleteId(id)
   IF $$$ISOK(sc)
   {
     Tc
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ReasonNotAvail","User.RBCReasonNotAvail","不可用原因",id,eobj.RNAVDesc,"D",eobj)
     s result="{success:'true',info:'删除成功！'}"
   }
   else
   {
     Trollback
     s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("不可用原因","web.DHCBL.CT.RBCReasonNotAvail","DeleteData",eobj)
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
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^RBC("NA",0,"Code",code))
 s:desc'="" flagd=$d(^RBC("NA",0,"Desc",desc))
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
  s:code'="" idc=$o(^RBC("NA",0,"Code",code,0))
  s:desc'="" idd=$o(^RBC("NA",0,"Desc",desc,0))
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
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1   //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Function:实现对资源预约不可用原因的修改操作
/// Creator:孙凤超
/// CreateDate:2012-08-29
/// Desc:通过rowid来修改资源预约不可用原因
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: RBC_ReasonNotAvail
/// Others: d ##class(web.DHCBL.CT.RBCReasonNotAvail).SaveRBCReasonNotAvail("")
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCReasonNotAvail) As %String
{
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.RNAVDateFrom'="" eobj.RNAVDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RNAVDateFrom)  
  s:eobj.RNAVDateTo'="" eobj.RNAVDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RNAVDateTo)      
  s:eobj.RNAVDateFrom="" eobj.RNAVDateFrom=+$H
  if (eobj.RNAVRowId="")  //如果RowId未赋值则增加
  { 
   s obj=##class(User.RBCReasonNotAvail).%New()
  }
  else  //如果RowId已赋值则修改
  {
    s obj=##class(User.RBCReasonNotAvail).%OpenId(eobj.RNAVRowId)
    s bobj=##class(web.Entity.CT.RBCReasonNotAvail).%New()
    s bobj.RNAVRowId=eobj.RNAVRowId
    s bobj.RNAVCode = obj.RNAVCode                       
    s bobj.RNAVDesc= obj.RNAVDesc  
    s bobj.RNAVType= obj.RNAVType
    s bobj.RNAVDateFrom= obj.RNAVDateFrom
    s bobj.RNAVDateTo= obj.RNAVDateTo
  }
   
  s obj.RNAVCode = eobj.RNAVCode                       
  s obj.RNAVDesc= eobj.RNAVDesc   
  if (eobj.RNAVType'="")   
  {                 
    S:eobj.RNAVType="Functional" eobj.RNAVType="F"
    S:eobj.RNAVType="Structural" eobj.RNAVType="S"
  }
  else
  {
    s eobj.RNAVType=""
  } 
  s obj.RNAVType=eobj.RNAVType
  s obj.RNAVDateFrom=eobj.RNAVDateFrom
  s obj.RNAVDateTo=eobj.RNAVDateTo
  Tstart
  s sc=obj.%Save()
  if $$$ISOK(sc)
  {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         
    d:eobj.RNAVRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ReasonNotAvail","User.RBCReasonNotAvail","不可用原因",eobj.RNAVRowId,eobj.RNAVDesc,"U",eobj,bobj)
    d:eobj.RNAVRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ReasonNotAvail","User.RBCReasonNotAvail","不可用原因",id,eobj.RNAVDesc,"A",eobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("不可用原因","web.DHCBL.CT.RBCReasonNotAvail","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    } 
  }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("不可用原因","web.DHCBL.CT.RBCReasonNotAvail","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("不可用原因","web.DHCBL.CT.RBCReasonNotAvail","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

/// CreateDate:2012-08-31
/// Creator:基础数据平台 ，孙凤超
/// Function: 资源预约 资源取消原因维护
Class web.DHCBL.CT.RBCReasonForCancel Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询资源取消原因 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Table: RBC_ReasonForCancel
/// Input:  rowid, code, desc, query
/// Output: RFC_RowId RFC_Code RFC_Desc RFC_Initiator RFC_DateFrom RFC_DateTo RFC_Default  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCReasonForCancel","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, cancel As %String) As %Query(ROWSPEC = "RFCRowId:%String,RFCCode:%String,RFCDesc:%String,RFCInitiator:%String,RFCDateFrom:%String,RFCDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, cancel As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.RBCReasonForCancel).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s RFCRowId=rowid
   s RFCCode=$p($g(^RBC("RFC",RFCRowId)),"^",1)
   s RFCDesc=$p($g(^RBC("RFC",RFCRowId)),"^",2)
   s RFCInitiator=$p($g(^RBC("RFC",RFCRowId)),"^",3)
   s RFCDateFrom=$p($g(^RBC("RFC",RFCRowId)),"^",4)
   s:RFCDateFrom'="" RFCDateFrom=$zd(RFCDateFrom,1)
   s RFCDateTo=$p($g(^RBC("RFC",RFCRowId)),"^",5)
   s:RFCDateTo'="" RFCDateTo=$zd(RFCDateTo,1)
   s RFCInitiator=$Case(RFCInitiator,"H":"Hospital","P":"Patient","PU":"Purchaser",:"")
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_ReasonForCancel",RFCRowId)
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
   
   s RFCRowId=0
   for
   {
     s RFCRowId=$o(^RBC("RFC",RFCRowId))  q:RFCRowId=""   
     s strRFCRowId="{ID:"_RFCRowId_"}"
     if (AuStr[strRFCRowId)||(AuFlag=1)
     {
      s RFCCode=$p($g(^RBC("RFC",RFCRowId)),"^",1)
      s RFCDesc=$p($g(^RBC("RFC",RFCRowId)),"^",2) 
      s RFCInitiator=$p($g(^RBC("RFC",RFCRowId)),"^",3)
      s RFCDateFrom=$p($g(^RBC("RFC",RFCRowId)),"^",4)
      s:RFCDateFrom'="" RFCDateFrom=$zd(RFCDateFrom,1)
      s RFCDateTo=$p($g(^RBC("RFC",RFCRowId)),"^",5)
      s:RFCDateTo'="" RFCDateTo=$zd(RFCDateTo,1)
     
      s RFCInitiator=$Case(RFCInitiator,"H":"Hospital","P":"Patient","PU":"Purchaser",:"")
      s:cancel="H" cancel="Hospital"
      s:cancel="P" cancel="Patient"
      s:cancel="PU" cancel="Purchaser" 
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_ReasonForCancel",RFCRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      if (desc'="")
      {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ReasonForCancel",RFCRowId,RFCDesc,desc)
      }
      else
      {
         s AliasFlag=1   
      } 
      if ($ZCVT(RFCCode,"U")[code)&(AliasFlag=1)&(RFCInitiator[cancel)   
      {
        d OutputRow
      }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RFCRowId,RFCCode,RFCDesc,RFCInitiator,RFCDateFrom,RFCDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为combo提供查询资源取消原因的原因
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Table: RBC_ReasonForCancel
/// Input:  desc
/// Output: RFC_RowId RFC_Code RFC_Desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCReasonForCancel","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RFCRowId:%String, RFCCode:%String,RFCDesc:%String ")
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
   s AuStr=##class(web.DHCBL.Authorize.RBCReasonForCancel).DHCGetDataByDefaultSession()
   s AuFlag=0
  ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   if (rowid'="")  
   {
      s RFCRowId=rowid
      s RFCCode=$p($g(^RBC("RFC",RFCRowId)),"^",1)
      s RFCDesc=$p($g(^RBC("RFC",RFCRowId)),"^",2)
      d OutputRow2
   }
   else
   {
     s RFCRowId=0
     for
     {
        s RFCRowId=$o(^RBC("RFC",RFCRowId))  
        q:RFCRowId=""  
        s RFCDateFrom=$p($g(^RBC("RFC",RFCRowId)),"^",4)
        continue:(RFCDateFrom'="")&&(RFCDateFrom>+$h) 
        s RFCDateTo=$p($g(^RBC("RFC",RFCRowId)),"^",5)
        continue:(RFCDateTo'="")&&(RFCDateTo<+$h) 
        s strRFCRowId="{ID:"_RFCRowId_"}"
        if (AuStr[strRFCRowId)||(AuFlag=1)
        {
         s RFCCode=$p($g(^RBC("RFC",RFCRowId)),"^",1)
         s RFCDesc=$p($g(^RBC("RFC",RFCRowId)),"^",2)
         if (desc'="")
         {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ReasonForCancel",RFCRowId,RFCDesc,desc)
         }
         else
         {
            s AliasFlag=1   
         } 
         if ($ZCVT(RFCCode,"U")[code)&(AliasFlag=1) 
         {
            d OutputRow2
         }
       }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(RFCRowId,RFCCode,RFCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:显示预约方法 
/// CreateDate:2012-08-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Table: RBC_ReasonForCancel
/// Others:w ##class(web.DHCBL.CT.RBCReasonForCancel).OpenData("25")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s pobj = ##class(User.RBCReasonForCancel).%OpenId(sid)
 s eobj = ##class(web.Entity.CT.RBCReasonForCancel).%New()
 s eobj.RFCRowId=sid
 s eobj.RFCCode = pobj.RFCCode
 s eobj.RFCDesc = pobj.RFCDesc
 s eobj.RFCInitiator=pobj.RFCInitiator
 s:eobj.RFCInitiator="H" eobj.RFCInitiator="Hospital"
 s:eobj.RFCInitiator="P" eobj.RFCInitiator="Patient"
 s:eobj.RFCInitiator="PU" eobj.RFCInitiator="Purchaser"
 s eobj.RFCInitiator=pobj.RFCInitiator
 s:pobj.RFCDateFrom'="" eobj.RFCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RFCDateFrom)
 s:pobj.RFCDateTo'="" eobj.RFCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RFCDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对预约方法的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-31
/// Desc:通过rowid号来删除预约方法  
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Table:RBC_ReasonForCancel
/// Others:d ##class(web.DHCBL.CT.RBCReasonForCancel).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
   s result="",flag=""
   Tstart
   s pobj = ##class(User.RBCReasonForCancel).%OpenId(id)
   s eobj = ##class(web.Entity.CT.RBCReasonForCancel).%New()
   s eobj.RFCRowId=id
   s eobj.RFCCode = pobj.RFCCode
   s eobj.RFCDesc = pobj.RFCDesc
   s eobj.RFCInitiator=pobj.RFCInitiator
   s:eobj.RFCInitiator="H" eobj.RFCInitiator="Hospital"
   s:eobj.RFCInitiator="P" eobj.RFCInitiator="Patient"
   s:eobj.RFCInitiator="PU" eobj.RFCInitiator="Purchaser"
   s eobj.RFCInitiator=pobj.RFCInitiator
   s:pobj.RFCDateFrom'="" eobj.RFCDateFrom=pobj.RFCDateFrom
   s:pobj.RFCDateTo'="" eobj.RFCDateTo=pobj.RFCDateTo
   
    s sc=##class(User.RBCReasonForCancel).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ReasonForCancel","User.RBCReasonForCancel","资源取消原因",id,eobj.RFCDesc,"D",eobj)
      d eobj.%Close()
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源取消原因","web.DHCBL.CT.RBCReasonForCancel","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
   q result
}

/// Function:实现对预约方法的修改增加操作
/// Creator:孙凤超
/// CreateDate:2012-08-31
/// Desc:通过rowid来修改预约方法
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Table:RBC_ReasonForCancel
/// Others: d ##class(web.DHCBL.CT.RBCReasonForCancel).SaveEntity
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCReasonForCancel) As %String
{
  s result=""
  s:eobj.RFCDateFrom'="" eobj.RFCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RFCDateFrom)  
  s:eobj.RFCDateTo'="" eobj.RFCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RFCDateTo)     
  s:eobj.RFCDateFrom="" eobj.RFCDateFrom=+$h
  s:eobj.RFCInitiator="Hospital" eobj.RFCInitiator="H"
  s:eobj.RFCInitiator="Patient" eobj.RFCInitiator="P"
  s:eobj.RFCInitiator="Purchaser" eobj.RFCInitiator="PU"
  if (eobj.RFCRowId="")  //如果RowId未赋值则增加
  {  
    s obj=##class(User.RBCReasonForCancel).%New()
  }  
  else                           
  {
    s obj=##class(User.RBCReasonForCancel).%OpenId(eobj.RFCRowId)
    s bobj=##class(web.Entity.CT.RBCReasonForCancel).%New()
    s bobj.RFCRowId=eobj.RFCRowId
    s bobj.RFCCode = obj.RFCCode                      
    s bobj.RFCDesc= obj.RFCDesc                      
    s bobj.RFCInitiator=obj.RFCInitiator
    s bobj.RFCDateFrom=obj.RFCDateFrom
    s bobj.RFCDateTo=obj.RFCDateTo
  } 
  s obj.RFCCode = eobj.RFCCode                      
  s obj.RFCDesc= eobj.RFCDesc                      
  s obj.RFCInitiator=eobj.RFCInitiator
  s obj.RFCDateFrom=eobj.RFCDateFrom
  s obj.RFCDateTo=eobj.RFCDateTo
  Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
     Tcommit
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"          
     d:eobj.RFCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ReasonForCancel","User.RBCReasonForCancel","资源取消原因",eobj.RFCRowId,eobj.RFCDesc,"U",eobj,bobj)
     d:eobj.RFCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ReasonForCancel","User.RBCReasonForCancel","资源取消原因",id,eobj.RFCDesc,"A",eobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("资源取消原因","web.DHCBL.CT.RBCReasonForCancel","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
   }
  q result
}

/// Function:进行数据的校验功能
/// Creator：基础数据平台 孙凤超
/// CreateDate:2012-11-16
/// Table:RBC_ReasonForCancel
/// Others:d ##class(web.DHCBL.CT.RBCReasonForCancel).FormValidate()
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^RBC("RFC",0,"Code",code))
 s:desc'="" flagd=$d(^RBC("RFC",0,"Desc",desc))
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
  s:code'="" idc=$o(^RBC("RFC",0,"Code",code,0))
  s:desc'="" idd=$o(^RBC("RFC",0,"Desc",desc,0))
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

}

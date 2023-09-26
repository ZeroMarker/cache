Import SQLUSER

/// CreateDate:2013-07-04
/// Creator:基础数据平台  孙凤超
/// Function:职称维护
/// Tables: CT_Title
Class web.DHCBL.CT.CTTitle Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据检索，查询职称
/// CreateDate:2013-07-04
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  CT_Title
/// Output: TTLRowId TTLCode TTLDesc TTLDateFrom TTLDateTo
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTTitle", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TTLRowId:%String,TTLCode:%String,TTLDesc:%String,TTLDateFrom:%String,TTLDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
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
 s AuStr=##class(web.DHCBL.Authorize.CTTitle).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
   s TTLRowId=rowid
   s TTLCode=$p($g(^CT("TTL",TTLRowId)),"^",1)
   s TTLDesc=$p($g(^CT("TTL",TTLRowId)),"^",2)
   s TTLDateFrom=$p($g(^CT("TTL",TTLRowId)),"^",3)
   s:TTLDateFrom'="" TTLDateFrom=$zd(TTLDateFrom,1)
   s TTLDateTo=$p($g(^CT("TTL",TTLRowId)),"^",4)
   s:TTLDateTo'="" TTLDateTo=$zd(TTLDateTo,1)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Title",TTLRowId)
   s BDPInternalCode =$p($g(resultStr),"^",1)       
   s BDPInternalDesc = $p($g(resultStr),"^",2)  
   s BDPHospNationalCode=$p($g(resultStr),"^",3)         
   s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
   d OutputRow
 }
 else
 {
   s:code'="" code=$zcvt(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U") 
   s TTLRowId=0
   for
   {
       s TTLRowId=$o(^CT("TTL",TTLRowId)) q:TTLRowId="" 
       s strTTLRowId="{ID:"_TTLRowId_"}"
       if (AuStr[strTTLRowId)||(AuFlag=1) 
       {
            s TTLCode=$p($g(^CT("TTL",TTLRowId)),"^",1)
            s TTLDesc=$p($g(^CT("TTL",TTLRowId)),"^",2)  
            s TTLDateFrom=$p($g(^CT("TTL",TTLRowId)),"^",3)
            s:TTLDateFrom'="" TTLDateFrom=$zd(TTLDateFrom,1)
            s TTLDateTo=$p($g(^CT("TTL",TTLRowId)),"^",4)
            s:TTLDateTo'="" TTLDateTo=$zd(TTLDateTo,1)
            s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
            s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Title",TTLRowId)
            s BDPInternalCode =$p($g(resultStr),"^",1)       
            s BDPInternalDesc = $p($g(resultStr),"^",2)  
            s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            if (desc'="")
            {
                 ;需要对描述或者别名进行检索      
                 s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Title",TTLRowId,TTLDesc,desc)
            }
            else
            {
                 s AliasFlag= 1   
            }   
            if ($ZCVT(TTLCode,"U")[code)&(AliasFlag=1)   
            {
                d OutputRow
            }
        }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TTLRowId,TTLCode,TTLDesc,TTLDateFrom,TTLDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索,为combo提供查询职称的接口
/// CreateDate:2013-7-04
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: CT_Title
/// Input: rowid，code，desc
/// Output: TTLRowId ，TTLCode,TTLDesc,  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTTitle", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TTLRowId:%String,TTLCode:%String,TTLDesc:%String ")
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
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$ZCVT(desc,"U") 
  s AuStr=##class(web.DHCBL.Authorize.CTTitle).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
   s TTLRowId=rowid
   s TTLCode=$p($g(^CT("TTL",TTLRowId)),"^",1)
   s TTLDesc=$p($g(^CT("TTL",TTLRowId)),"^",2) 
   d OutputRow2
  }
  else
  {
   s TTLRowId=0
   for
   {
     s TTLRowId=$o(^CT("TTL",TTLRowId)) 
     q:TTLRowId="" 
     s TTLDateFrom=$p($g(^CT("TTL",TTLRowId)),"^",3)
     continue:(TTLDateFrom'="")&&(TTLDateFrom>+$h)
     s TTLDateTo=$p($g(^CT("TTL",TTLRowId)),"^",4) 
     continue:(TTLDateTo'="")&&(TTLDateTo<+$h)
     s strTTLRowId="{ID:"_TTLRowId_"}"
     if (AuStr[strTTLRowId)||(AuFlag=1) 
     {
       s TTLCode=$p($g(^CT("TTL",TTLRowId)),"^",1)
       s TTLDesc=$p($g(^CT("TTL",TTLRowId)),"^",2)
       if (desc'="")
       {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Title",TTLRowId,TTLDesc,desc)
       }
       else
       {
          s AliasFlag= 1   
       }   
       if ($ZCVT(TTLCode,"U")[code)&(AliasFlag=1)   
       {
         d OutputRow2
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(TTLRowId,TTLCode,TTLDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:双击时 显示职称
/// CreateDate:2013-07-04
/// Creator:基础数据平台公共产品组 孙凤超
/// Input: id
/// Tables:CT_Title
/// Others:w ##class(web.DHCBL.CT.CTTitle).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTTitle).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTTitle).%New()
 s eobj.TTLRowId=id
 s eobj.TTLCode= pobj.TTLCode
 s eobj.TTLDesc = pobj.TTLDesc
 s:pobj.TTLDateFrom'="" eobj.TTLDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.TTLDateFrom)
 s:pobj.TTLDateTo'="" eobj.TTLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.TTLDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// CreatDate:2016-8-18
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  s return="0^未被引用可删除！"
  s flag=0
  s CTPCPRowId=0
  for  
  {       
    s CTPCPRowId=$o(^CTPCP(CTPCPRowId)) q:CTPCPRowId=""
    s CTPCPTitleDR=$p($g(^CTPCP(CTPCPRowId,3)),"^",29)  //医护人员职称
    i CTPCPTitleDR=id s flag=1
  }
  if (flag) s myInfo=myInfo_"<医护人员>"   ;CTCareProv

  
  i myInfo="" s return="0^未被引用可删除!"
  else  s return="1^在"_myInfo_"表里被引用,不能删除!"
  q return
}

/// Function:实现对职称的删除操作
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-07-04
/// Desc:通过rowid号来删除职称
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  CT_Title
/// Others:d ##class(web.DHCBL.CT.CTTitle).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
  s result=""
  s re=##class(web.DHCBL.CT.CTTitle).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag'=0)
  {
    s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {
      Tstart
      s pobj = ##class(User.CTTitle).%OpenId(id)
      s eobj = ##class(web.Entity.CT.CTTitle).%New()
      s eobj.TTLRowId=id
      s eobj.TTLCode= pobj.TTLCode
      s eobj.TTLDesc = pobj.TTLDesc
      s:pobj.TTLDateFrom'="" eobj.TTLDateFrom = pobj.TTLDateFrom
      s:pobj.TTLDateTo'="" eobj.TTLDateTo=pobj.TTLDateTo
    
      s sc=##class(User.CTTitle).%DeleteId(id)
      if $$$ISOK(sc)
      {
        Tc
          s result="{success:'true',info:'删除成功！'}"
          d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Title","User.CTTitle","职称",id,eobj.TTLDesc,"D",eobj)
        d eobj.%Close()
      }
      else
      {
          Trollback
          s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
          s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职称","web.DHCBL.CT.CTTitle","DeleteData",eobj)
          s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      }
  }
    q result
}

/// Creator：孙凤超
/// CreatDate: 2013-07-04
/// Description：数据重复校验
/// Table：CT_Title
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="", flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)   
 s:code'="" flagc=$d(^CT("TTL",0,"Code",code))
 s:desc'="" flagd=$d(^CT("TTL",0,"Desc",desc))
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
  s:code'="" idc=$o(^CT("TTL",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("TTL",0,"Desc",desc,0))
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

/// Function:实现对职称的修改增加操作
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-07-04
/// Desc:通过rowid来修改职称，或者添加职称维护
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: CT_Title
ClassMethod SaveEntity(eobj As web.Entity.CT.CTTitle) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.TTLDateFrom'="" eobj.TTLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TTLDateFrom)   
  s:eobj.TTLDateTo'="" eobj.TTLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TTLDateTo)     
  s:eobj.TTLDateFrom="" eobj.TTLDateFrom=+$h
  if (eobj.TTLRowId="")       
  {
   s obj=##class(User.CTTitle).%New()
  }else                           
  {
   s obj=##class(User.CTTitle).%OpenId(eobj.TTLRowId)
   s bboj=##class(web.Entity.CT.CTTitle).%New()
   s bboj.TTLRowId=eobj.TTLRowId
   s bboj.TTLCode = obj.TTLCode                    
   s bboj.TTLDesc= obj.TTLDesc                      
   s bboj.TTLDateFrom = obj.TTLDateFrom 
   s bboj.TTLDateTo=obj.TTLDateTo
  }
   s obj.TTLCode = eobj.TTLCode                    
   s obj.TTLDesc= eobj.TTLDesc                      
   s obj.TTLDateFrom = eobj.TTLDateFrom 
   s obj.TTLDateTo=eobj.TTLDateTo
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.TTLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Title","User.CTTitle","职称",eobj.TTLRowId,eobj.TTLDesc,"U",eobj,bboj)
    d:eobj.TTLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Title","User.CTTitle","职称",id,eobj.TTLDesc,"A",eobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职称","web.DHCBL.CT.CTTitle","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
 }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职称","web.DHCBL.CT.CTTitle","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
  q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职称","web.DHCBL.CT.CTTitle","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}

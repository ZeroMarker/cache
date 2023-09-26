/// Creator:基础数据平台组  孙凤超
/// CreateDate:2013-9-16
/// Function: 过敏改变原因维护
Class web.DHCBL.CT.PACAllergyReasonForChang Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：查询过敏改变原因的内容
/// Table： PAC_AllergyReasonForChang
/// Input：rowid,code,desc
/// Return： ALRFC_RowId ALRFC_Code ALRFC_Desc ALRFC_DateFrom ALRFC_DateTo
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergyReasonForChang", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALRFCRowId:%String,ALRFCCode:%String,ALRFCDesc:%String,ALRFCDateFrom:%String,ALRFCDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
  s AuStr=  ##class(web.DHCBL.Authorize.PACAllergyReasonForChang).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
    s ALRFCRowId=rowid
    s ALRFCCode=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",1)
    s ALRFCDesc=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",2)
    s ALRFCDateFrom=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",3)
    s ALRFCDateTo=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",4)
    s:ALRFCDateFrom'="" ALRFCDateFrom=$zd(ALRFCDateFrom,1)
    s:ALRFCDateTo'="" ALRFCDateTo=$zd(ALRFCDateTo,1)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AllergyReasonForChang",ALRFCRowId)
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
   s ALRFCRowId=0
   for
   {
     s ALRFCRowId=$o(^PAC("ALRFC",ALRFCRowId)) q:ALRFCRowId=""   
     s strALRFCRowId="{ID:"_ALRFCRowId_"}"
     if (AuStr[strALRFCRowId)||(AuFlag=1)
     {
       s ALRFCCode=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",1)
       s ALRFCDesc=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",2) 
       s ALRFCDateFrom=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",3)
       s ALRFCDateTo=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",4)
       s:ALRFCDateFrom'="" ALRFCDateFrom=$zd(ALRFCDateFrom,1)
       s:ALRFCDateTo'="" ALRFCDateTo=$zd(ALRFCDateTo,1)
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AllergyReasonForChang",ALRFCRowId)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4)
       if (desc'="")
       {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AllergyReasonForChang",ALRFCRowId,ALRFCDesc,desc)
       }
       else
       {
           s AliasFlag= 1   
       }    
       if ($ZCVT(ALRFCCode,"U")[code)&(AliasFlag=1)  
       {  
          d OutputRow
       }
     }
  }
 }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutputRow
    set Data=$lb(ALRFCRowId,ALRFCCode,ALRFCDesc,ALRFCDateFrom,ALRFCDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为combox查询过敏源改变原因提供接口 
/// CreateDate:2013-9-16
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_AllergyReasonForChang
/// Input:   code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergyReasonForChang", "GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALRFCRowId:%String,ALRFCCode:%String,ALRFCDesc:%String")
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
 s:desc'="" desc=$zcvt(desc,"U") 
 s AuStr=##class(web.DHCBL.Authorize.PACAllergyReasonForChang).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")
 {
  s ALRFCRowId=rowid
  s ALRFCCode=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",1)
  s ALRFCDesc=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",2) 
  d OutputRow2 
 }  
 else
 {
  s ALRFCRowId=0
  for
  {
    s ALRFCRowId=$o(^PAC("ALRFC",ALRFCRowId)) q:ALRFCRowId=""   
    s strALRFCRowId="{ID:"_ALRFCRowId_"}"
    if (AuStr[strALRFCRowId)||(AuFlag=1)
    {
       s ALRFCDateFrom=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",3)
       continue:(ALRFCDateFrom'="")&&(ALRFCDateFrom>+$h)
       s ALRFCDateTo=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",4) 
       continue:(ALRFCDateTo'="")&&(ALRFCDateTo<+$h)
       s ALRFCCode=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",1)
       s ALRFCDesc=$p($g(^PAC("ALRFC",ALRFCRowId)),"^",2)
       if (desc'="")
       {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AllergyReasonForChang",ALRFCRowId,ALRFCDesc,desc)
       }
       else
       {
           s AliasFlag= 1   
       }    
       if ($ZCVT(ALRFCCode,"U")[code)&(AliasFlag=1)    
       {  
          d OutputRow2
       }
     }
   }
 }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutputRow2
    set Data=$lb(ALRFCRowId,ALRFCCode,ALRFCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：根据ID删除过敏改变原因的内容
/// Table：PAC_AllergyReasonForChang
/// Input：id 
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
 s result="",flag=""
 Tstart
 s eobj = ##class(web.Entity.CT.PACAllergyReasonForChang).%New()
 s eobj.ALRFCRowId = id
 s eobj.ALRFCCode=$p($g(^PAC("ALRFC",id)),"^",1)
 s eobj.ALRFCDesc=$p($g(^PAC("ALRFC",id)),"^",2)
 s eobj.ALRFCDateFrom=$p($g(^PAC("ALRFC",id)),"^",3)
 s eobj.ALRFCDateTo=$p($g(^PAC("ALRFC",id)),"^",4)
 s:eobj.ALRFCDateFrom'="" eobj.ALRFCDateFrom=eobj.ALRFCDateFrom
 s:eobj.ALRFCDateTo'="" eobj.ALRFCDateTo=eobj.ALRFCDateTo
 
  s sc=##class(User.PACAllergyReasonForChang).%DeleteId(id)
   IF $$$ISOK(sc)
 {
  Tc
  s result="{success:'true',info:'删除成功！'}"
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergyReasonForChang","User.PACAllergyReasonForChang","过敏改变原因",id,eobj.ALRFCDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
    Trollback
    s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏改变原因","web.DHCBL.CT.PACAllergyReasonForChang","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Function:用于双击修改时的数据加载 
/// CreateDate:2013-9-16
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Others :w ##class(web.DHCBL.CT.PACAllergyReasonForChang).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACAllergyReasonForChang).%OpenId(id)
 s eobj = ##class(web.Entity.CT.PACAllergyReasonForChang).%New()
 s eobj.ALRFCRowId = id
 S eobj.ALRFCCode=pobj.ALRFCCode
 s eobj.ALRFCDesc= pobj.ALRFCDesc
 s:pobj.ALRFCDateFrom'="" eobj.ALRFCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ALRFCDateFrom)
 s:pobj.ALRFCDateTo'="" eobj.ALRFCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ALRFCDateTo)
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对过敏改变原因修改增加操作
/// Creator: 基础数据平台组 孙凤超
/// CreateDate:2013-9-16
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:  PAC_AllergyReasonForChang
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAllergyReasonForChang) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.ALRFCDateFrom'="" eobj.ALRFCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALRFCDateFrom)   
  s:eobj.ALRFCDateTo'="" eobj.ALRFCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALRFCDateTo)     
  s:eobj.ALRFCDateFrom="" eobj.ALRFCDateFrom=+$h
  //如果RowId未赋值则增加
  if (eobj.ALRFCRowId="")       
  {
   s obj=##class(User.PACAllergyReasonForChang).%New()
  }else                           
  {
   s obj=##class(User.PACAllergyReasonForChang).%OpenId(eobj.ALRFCRowId)
   s bobj=##class(web.Entity.CT.PACAllergyReasonForChang).%New()
   
   s bobj.ALRFCRowId=eobj.ALRFCRowId
   s bobj.ALRFCCode = obj.ALRFCCode                      
   s bobj.ALRFCDesc= obj.ALRFCDesc                      
   s bobj.ALRFCDateFrom = obj.ALRFCDateFrom 
   s bobj.ALRFCDateTo=obj.ALRFCDateTo
  }
   s obj.ALRFCCode = eobj.ALRFCCode                      
   s obj.ALRFCDesc= eobj.ALRFCDesc                      
   s obj.ALRFCDateFrom = eobj.ALRFCDateFrom 
   s obj.ALRFCDateTo=eobj.ALRFCDateTo
  
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.ALRFCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergyReasonForChang","User.PACAllergyReasonForChang","过敏改变原因",eobj.ALRFCRowId,eobj.ALRFCDesc,"U",eobj,bobj)
    d:eobj.ALRFCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergyReasonForChang","User.PACAllergyReasonForChang","过敏改变原因",id,eobj.ALRFCDesc,"A",eobj)
   }
   else
    {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏改变原因","web.DHCBL.CT.PACAllergyReasonForChang","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  }
 else
 {
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏改变原因","web.DHCBL.CT.PACAllergyReasonForChang","SaveEntity","")
    s ^ERRORLOGINFO(logid)= "对象不存在！"
    s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
   q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏改变原因","web.DHCBL.CT.PACAllergyReasonForChang","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：对过敏改变原因维护中的代码，描述进行数据校验
/// Table： PAC_AllergyReasonForChang
/// Input：id,code,desc
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^PAC("ALRFC",0,"Code",code))  
 s:desc'="" flagd=$d(^PAC("ALRFC",0,"Desc",desc))
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
  s idc="", idd=""
  s:code'="" idc=$o(^PAC("ALRFC",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("ALRFC",0,"Desc",desc,0))
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

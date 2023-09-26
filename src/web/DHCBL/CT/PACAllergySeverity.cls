/// 名称:电子病历-过敏严重程度业务类
/// 编写者:基础平台组 - 孙凤超
/// 编写日期:2013-9-16
Class web.DHCBL.CT.PACAllergySeverity Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：查询过敏严重程度的内容
/// Table： PAC_AllergySeverity
/// Input：rowid,code,desc
/// Return： ALRGSEV_RowId ALRGSEV_Code ALRGSEV_Desc ALRGSEV_DateFrom ALRGSEV_DateTo ALRGSEV_Priority
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergySeverity", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALRGSEVRowId:%String,ALRGSEVCode:%String,ALRGSEVDesc:%String,ALRGSEVDateFrom:%String,ALRGSEVDateTo:%String,ALRGSEVPriority:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.PACAllergySeverity).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    if (rowid'="")  
    {
      s ALRGSEVRowId=rowid
      s ALRGSEVCode= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",1)
      s ALRGSEVDesc= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",2)
      s ALRGSEVDateFrom= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",5)
      s ALRGSEVDateTo= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",6)
      s ALRGSEVPriority=$p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",7)
      s:ALRGSEVDateFrom'="" ALRGSEVDateFrom=$zd(ALRGSEVDateFrom,1)
      s:ALRGSEVDateTo'="" ALRGSEVDateTo=$zd(ALRGSEVDateTo,1)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AllergySeverity",ALRGSEVRowId)
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
       s ALRGSEVRowId=0
       for
       {
          s ALRGSEVRowId=$o(^PAC("ALRGSEV",ALRGSEVRowId)) q:ALRGSEVRowId=""  
          s strALRGSEVRowId="{ID:"_ALRGSEVRowId_"}"
          if (AuStr[strALRGSEVRowId)||(AuFlag=1)
          {
             s ALRGSEVCode= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",1)
             s ALRGSEVDesc= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",2)   
             s ALRGSEVDateFrom= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",5)
             s ALRGSEVDateTo= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",6)
             s ALRGSEVPriority=$p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",7)
             s:ALRGSEVDateFrom'="" ALRGSEVDateFrom=$zd(ALRGSEVDateFrom,1)
             s:ALRGSEVDateTo'="" ALRGSEVDateTo=$zd(ALRGSEVDateTo,1)
             s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
             s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AllergySeverity",ALRGSEVRowId)
             s BDPInternalCode =$p($g(resultStr),"^",1)       
             s BDPInternalDesc = $p($g(resultStr),"^",2)  
             s BDPHospNationalCode=$p($g(resultStr),"^",3)         
             s BDPHospNationalDesc = $p($g(resultStr),"^",4)
             if (desc'="")
             {
               ;需要对描述或者别名进行检索      
               s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AllergySeverity",ALRGSEVRowId,ALRGSEVDesc,desc)
             }
            else
            {
               s AliasFlag=1   
            }    
            if ($ZCVT(ALRGSEVCode,"U")[code)&(AliasFlag=1)  
            {
               d OutputRow
            }
         }
    }
 }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutputRow
    set Data=$lb(ALRGSEVRowId,ALRGSEVCode,ALRGSEVDesc,ALRGSEVDateFrom,ALRGSEVDateTo,ALRGSEVPriority,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为combox查询过敏严重程度提供接口 
/// CreateDate:2013-9-16
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_AllergySeverity
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergySeverity", "GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALRGSEVRowId:%String,ALRGSEVCode:%String,ALRGSEVDesc:%String")
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
 s AuStr=##class(web.DHCBL.Authorize.PACAllergySeverity).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s ALRGSEVRowId=rowid
  s ALRGSEVCode= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",1)
  s ALRGSEVDesc= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",2)
  d OutputRow2
 }
 else{
   s ALRGSEVRowId=0
   for
  {
    s ALRGSEVRowId=$o(^PAC("ALRGSEV",ALRGSEVRowId)) q:ALRGSEVRowId=""  
    s strALRGSEVRowId="{ID:"_ALRGSEVRowId_"}"
    if (AuStr[strALRGSEVRowId)||(AuFlag=1)
    {
        s ALRGSEVDateFrom= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",5)
        continue:(ALRGSEVDateFrom'="")&&(ALRGSEVDateFrom>+$h)
        s ALRGSEVDateTo= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",6) 
        continue:(ALRGSEVDateTo'="")&&(ALRGSEVDateTo<+$h)
        s ALRGSEVCode= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",1)
        s ALRGSEVDesc= $p($g(^PAC("ALRGSEV",ALRGSEVRowId)),"^",2)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AllergySeverity",ALRGSEVRowId,ALRGSEVDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        }    
        if ($ZCVT(ALRGSEVCode,"U")[code)&(AliasFlag=1)  
        {
           d OutputRow2
        }
     }
   }
 }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutputRow2
    set Data=$lb(ALRGSEVRowId,ALRGSEVCode,ALRGSEVDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：根据ID删除过敏严重程度的内容
/// Table：PAC_AllergySeverity
/// Input：id 
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
  s result="",flag=""
  Tstart 
  s eobj = ##class(web.Entity.CT.PACAllergySeverity).%New()
  s eobj.ALRGSEVRowId = id
  s eobj.ALRGSEVCode=$p($g(^PAC("ALRGSEV",id)),"^",1)
  s eobj.ALRGSEVDesc=$p($g(^PAC("ALRGSEV",id)),"^",2)
  s eobj.ALRGSEVDateFrom=$p($g(^PAC("ALRGSEV",id)),"^",5)
  s eobj.ALRGSEVDateTo=$p($g(^PAC("ALRGSEV",id)),"^",6)
  s eobj.ALRGSEVPriority=$p($g(^PAC("ALRGSEV",id)),"^",7)
  s:eobj.ALRGSEVDateFrom'="" eobj.ALRGSEVDateFrom=eobj.ALRGSEVDateFrom
  s:eobj.ALRGSEVDateTo'="" eobj.ALRGSEVDateTo=eobj.ALRGSEVDateTo

  s sc=##class(User.PACAllergySeverity).%DeleteId(id)
  IF $$$ISOK(sc)
  {
    Tc
    s result="{success:'true',info:'删除成功！'}"
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergySeverity","User.PACAllergySeverity","过敏严重程度",id,eobj.ALRGSEVDesc,"D",eobj)
    d eobj.%Close()
  }
  else
  {
   Trollback
   s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏严重程度","web.DHCBL.CT.PACAllergySeverity","DeleteData",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
 q result
}

/// Function:用于双击修改时的数据加载 
/// CreateDate:2013-9-16
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Others :w ##class(web.DHCBL.CT.PACAllergySeverity).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACAllergySeverity).%OpenId(id)
 s eobj = ##class(web.Entity.CT.PACAllergySeverity).%New()
 s eobj.ALRGSEVRowId = id
 S eobj.ALRGSEVCode=pobj.ALRGSEVCode
 s eobj.ALRGSEVDesc= pobj.ALRGSEVDesc
 s:pobj.ALRGSEVDateFrom'="" eobj.ALRGSEVDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ALRGSEVDateFrom)
 s:pobj.ALRGSEVDateTo'="" eobj.ALRGSEVDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ALRGSEVDateTo)
 s eobj.ALRGSEVPriority=pobj.ALRGSEVPriority
 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对过敏严重程度修改增加操作
/// Creator: 基础数据平台组 孙凤超
/// CreateDate:2013-9-16
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:  PAC_AllergySeverity
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAllergySeverity) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.ALRGSEVDateFrom'="" eobj.ALRGSEVDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALRGSEVDateFrom)   
  s:eobj.ALRGSEVDateTo'="" eobj.ALRGSEVDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ALRGSEVDateTo)     
  s:eobj.ALRGSEVDateFrom="" eobj.ALRGSEVDateFrom=+$h
  //如果RowId未赋值则增加
  if (eobj.ALRGSEVRowId="")       
  {
   s obj=##class(User.PACAllergySeverity).%New()
  }else                           
  {
   s obj=##class(User.PACAllergySeverity).%OpenId(eobj.ALRGSEVRowId)
   s bobj=##class(web.Entity.CT.PACAllergySeverity).%New()
   s bobj.ALRGSEVCode = obj.ALRGSEVCode                      
   s bobj.ALRGSEVDesc= obj.ALRGSEVDesc                      
   s bobj.ALRGSEVDateFrom = obj.ALRGSEVDateFrom 
   s bobj.ALRGSEVDateTo=obj.ALRGSEVDateTo
   s bobj.ALRGSEVPriority=obj.ALRGSEVPriority
  }
   s obj.ALRGSEVCode = eobj.ALRGSEVCode                      
   s obj.ALRGSEVDesc= eobj.ALRGSEVDesc                      
   s obj.ALRGSEVDateFrom = eobj.ALRGSEVDateFrom 
   s obj.ALRGSEVDateTo=eobj.ALRGSEVDateTo
   s obj.ALRGSEVPriority=eobj.ALRGSEVPriority
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.ALRGSEVRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergySeverity","User.PACAllergySeverity","过敏严重程度",eobj.ALRGSEVRowId,eobj.ALRGSEVDesc,"U",eobj,bobj)
    d:eobj.ALRGSEVRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergySeverity","User.PACAllergySeverity","过敏严重程度",id,eobj.ALRGSEVDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏严重程度","web.DHCBL.CT.PACAllergySeverity","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
 }
 else
 {
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏严重程度","web.DHCBL.CT.PACAllergySeverity","SaveEntity","")
    s ^ERRORLOGINFO(logid)="对象不存在！"
    s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
   q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏严重程度","web.DHCBL.CT.PACAllergySeverity","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：对过敏严重程度维护中的代码，描述进行数据校验
/// Table： PAC_AllergySeverity
/// Input：id,code,desc
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写 
 s:code'="" flagc=$d(^PAC("ALRGSEV",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("ALRGSEV",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("ALRGSEV",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("ALRGSEV",0,"Desc",desc,0))
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

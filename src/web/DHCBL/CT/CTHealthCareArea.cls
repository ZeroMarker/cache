/// Function: 健康监护区域业务类
/// Creator:  sunfengchao
/// CreateDate: 2015-3-4
Class web.DHCBL.CT.CTHealthCareArea Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：   sunfengchao
/// CreatDate:   2015-3-4
/// Description：查询健康监护区域的内容
/// Table：      CT_HealthCareArea
/// Input：      rowid,code,desc
/// OutPut:      HCARowId HCACode HCADesc HCADateFrom HCADateTo HCAHCRDR
/// Debug:       d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHealthCareArea","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "HCARowId,HCACode,HCADesc,HCADateFrom,HCADateTo,HCAHCRDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
 
   s AuStr=##class(web.DHCBL.Authorize.CTHealthCareArea).DHCGetDataByDefaultSession()
   s AuHCAHCRDRStr=##class(web.DHCBL.Authorize.CTHealthCareRegion).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
   s AuHCAHCRDRFlag=0
   if (AuHCAHCRDRStr="")||(AuHCAHCRDRStr["limited:0") s AuHCAHCRDRFlag=1 
   if (rowid'="") 
   {  
     s HCARowId=rowid
     s HCACode=$p($g(^CT("HCA",HCARowId)),"^",1)
     s HCADesc=$p($g(^CT("HCA",HCARowId)),"^",2)
     s HCAHCRDR= $p($g(^CT("HCA",HCARowId)),"^",3)
     S:HCAHCRDR'="" HCAHCRDR=$p($g(^CT("HCR",HCAHCRDR)),"^",2)
     s:HCAHCRDR="" HCAHCRDR=""
     s HCADateFrom=$p($g(^CT("HCA",HCARowId)),"^",4)
     s HCADateTo=$p($g(^CT("HCA",HCARowId)),"^",5)
     s:HCADateFrom'="" HCADateFrom=$zd(HCADateFrom,1)  
     s:HCADateTo'="" HCADateTo=$zd(HCADateTo,1)
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_HealthCareArea",HCARowId)
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
     s HCARowId=0
     for 
     {
        s HCARowId=$o(^CT("HCA",HCARowId))
        q:HCARowId=""
        s strRowId="{ID:"_HCARowId_"}"
        s HCAHCRDR= $p($g(^CT("HCA",HCARowId)),"^",3)
        s strHCAHCRDR="{ID:"_HCAHCRDR_"}"
        if ((AuStr[strRowId)||(AuFlag=1))&((AuHCAHCRDRStr[strHCAHCRDR)||(AuHCAHCRDRFlag=1)) 
        {
           s HCACode=$p($g(^CT("HCA",HCARowId)),"^",1)
           s HCADesc=$p($g(^CT("HCA",HCARowId)),"^",2)    
           S:HCAHCRDR'="" HCAHCRDR=$p($g(^CT("HCR",HCAHCRDR)),"^",2)
           s:HCAHCRDR="" HCAHCRDR=""
           s HCADateFrom=$p($g(^CT("HCA",HCARowId)),"^",4)
           s HCADateTo=$p($g(^CT("HCA",HCARowId)),"^",5)
           s:HCADateFrom'="" HCADateFrom=$zd(HCADateFrom,1)  
           s:HCADateTo'="" HCADateTo=$zd(HCADateTo,1)  
           s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""       
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_HealthCareArea",HCARowId)
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           s BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc = $p($g(resultStr),"^",4)
           if (desc'="")
           {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_HealthCareArea",HCARowId,HCADesc,desc)
           }
           else
           {
             s AliasFlag= 1   
           }  
           if ($ZCONVERT(HCACode,"U")[code)&(AliasFlag=1)  
           {
             d OutputRow
           }
       }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(HCARowId,HCACode,HCADesc,HCADateFrom,HCADateTo,HCAHCRDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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
  //if there are no more rows,finish fetching
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

/// Creator：    sunfengchao
/// CreatDate:   2015-3-4
/// Description：查询健康监护区域的combox 数据源
/// Table：      CT_HealthCareArea
/// Input：      rowid,code,desc
/// OutPut:      HCARowId HCACode HCADesc 
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHealthCareArea","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "HCARowId:%String,HCACode:%String,HCADesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 s AuStr=##class(web.DHCBL.Authorize.CTHealthCareArea).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 s AuHCAHCRDRStr=##class(web.DHCBL.Authorize.CTHealthCareRegion).DHCGetDataByDefaultSession()
 s AuHCAHCRDRFlag=0
 if (AuHCAHCRDRStr="")||(AuHCAHCRDRStr["limited:0") s AuHCAHCRDRFlag=1  
 if (rowid'="")  
 {  
   s HCARowId=rowid
   s HCACode=$p($g(^CT("HCA",HCARowId)),"^",1)
   s HCADesc=$p($g(^CT("HCA",HCARowId)),"^",2)
   d OutputRow2
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U")  
   s:desc'="" desc=$ZCONVERT(desc,"U") 
   s HCARowId=0
   for 
   {
    s HCARowId=$o(^CT("HCA",HCARowId))
    q:HCARowId=""
    s HCADateFrom=$p($g(^CT("HCA",HCARowId)),"^",4)
    continue:(HCADateFrom'="")&&(HCADateFrom>+$h) 
    s HCADateTo=$p($g(^CT("HCA",HCARowId)),"^",5) 
    continue:(HCADateTo'="")&&(HCADateTo<+$h) 
    s strRowId="{ID:"_HCARowId_"}"
    s HCAHCRDR= $p($g(^CT("HCA",HCARowId)),"^",3)
    s strHCAHCRDR="{ID:"_HCAHCRDR_"}"
    if ((AuStr[strRowId)||(AuFlag=1))&((AuHCAHCRDRStr[strHCAHCRDR)||(AuHCAHCRDRFlag=1)) 
    {
       s HCACode=$p($g(^CT("HCA",HCARowId)),"^",1)
       s HCADesc=$p($g(^CT("HCA",HCARowId)),"^",2) 
       if (desc'="")
       {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_HealthCareArea",HCARowId,HCADesc,desc)
       }
       else
       {
         s AliasFlag= 1   
       }  
       if ($ZCONVERT(HCACode,"U")[code)&(AliasFlag=1)  
       {
         d OutputRow2
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(HCARowId,HCACode,HCADesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Description：修改时打开数据
/// Creator：sunfengchao
/// CreatDate: 2015-3-3
/// Table：CT_HealthCareArea
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTHealthCareArea).%New()
 s obj=##class(User.CTHealthCareArea).%OpenId(id)
 s eobj.HCARowId = id
 s eobj.HCACode=obj.HCACode
 s eobj.HCADesc=obj.HCADesc
 s eobj.HCADateFrom=obj.HCADateFrom
 s eobj.HCADateTo=obj.HCADateTo
 s:eobj.HCADateFrom'="" eobj.HCADateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HCADateFrom) 
 s:eobj.HCADateTo'="" eobj.HCADateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HCADateTo) 
 if $IsObject(obj.HCAHCRDR)
 {
   s eobj.HCAHCRDR = obj.HCAHCRDR.%Id() 
 }
 else
 {
  s eobj.HCAHCRDR =""
 }
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Function： 数据重复验证方法，由js调用
/// Creator：  sunfengchao
/// CreatDate: 2015-3-3
/// Table：    CHealthCareArea
/// Input：    id, code, desc
/// Return：   "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^CT("HCA",0,"Code",code))
 s:desc'="" flagd=$d(^CT("HCA",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("HCA",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("HCA",0,"Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  elseif (code="")
  {
   if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2015-3-3
/// Description：保存修改内容
/// Table：CT_HealthCareArea
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHealthCareArea) As %String
{
 s result="",flag=""
 if $IsObject(eobj)
 {
  s:eobj.HCADateFrom="" eobj.HCADateFrom=+$h
  s:eobj.HCADateFrom'="" eobj.HCADateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HCADateFrom)  
  s:eobj.HCADateTo'="" eobj.HCADateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HCADateTo)       
 
   if (eobj.HCARowId="")   
   {
    s obj=##class(User.CTHealthCareArea).%New()
   }
   else                      
   {
    s obj=##class(User.CTHealthCareArea).%OpenId(eobj.HCARowId)
    s bobj=##class(web.Entity.CT.CTHealthCareArea).%New()
    s bobj.HCARowId=eobj.HCARowId
    s bobj.HCACode = obj.HCACode         
    s bobj.HCADesc = obj.HCADesc           
    s bobj.HCADateFrom = obj.HCADateFrom  
    s bobj.HCADateTo = obj.HCADateTo    
    s bobj.HCAHCRDR=obj.HCAHCRDR  
   }
   Ts
   s obj.HCACode = eobj.HCACode          
   s obj.HCADesc = eobj.HCADesc           
   s obj.HCADateFrom = eobj.HCADateFrom   
   s obj.HCADateTo= eobj.HCADateTo
   d obj.HCAHCRDRSetObjectId(eobj.HCAHCRDR)
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"  
    d:eobj.HCARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareArea","User.CTHealthCareArea","健康监护区域",id,eobj.HCADesc,"A",eobj)
    d:eobj.HCARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareArea","User.CTHealthCareArea","健康监护区域",eobj.HCARowId,eobj.HCADesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护区域","web.DHCBL.CT.CTHealthCareArea","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }    
 
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护区域","web.DHCBL.CT.CTHealthCareArea","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
}

/// Function:  健康监护区域 -用于数据删除时的逻辑判断
/// CreateDate:2015-3-17
/// Ctreator:  BDP-Sunfengchao
/// Input:     rowid   
/// Output:    返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s HCPRowId=0,found1=0
    for
   {
      s HCPRowId=$o(^CT("HCP",HCPRowId)) 
      q:HCPRowId=""   
      q:found1  
      s HCPHCADR=$p($g(^CT("HCP",HCPRowId)),"^",3)
      if HCPHCADR=id s found1=1
   }
   i (found1=1)  s myInfo=myInfo_"<合同单位>"
   
  //2 是否被"邮编"引用
  s found2=0
  s CTZIPRowId=0 
  for
  {
   s CTZIPRowId=$o(^CT("ZIP",CTZIPRowId)) 
   q:CTZIPRowId="" 
   q:found2 
   s CTZIPDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",5) 
   if CTZIPDR=id s found2=1
  }
   i (found2=1) s myInfo=myInfo_"<邮编>"
   
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

/// Function：根据ID删除数据
/// Creator： Sunfengchao
/// CreatDate:2015-3-3
/// Table：   CT_HealthCareArea
/// Input：   id
/// Return：  成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 s re=..GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 
 if (RefFlag=1)
 {
   s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护区域","web.DHCBL.CT.CTHealthCareArea","DeleteData","")
   s ^ERRORLOGINFO(logid)=$p(re,"^",2) 
 }
 else
{  
 s eobj = ##class(web.Entity.CT.CTHealthCareArea).%New()
 s obj=##class(User.CTHealthCareArea).%OpenId(id)
 s eobj.HCARowId = id
 s eobj.HCACode=obj.HCACode
 s eobj.HCADesc=obj.HCADesc
 s eobj.HCADateFrom=obj.HCADateFrom
 s eobj.HCADateTo=obj.HCADateTo
 s eobj.HCAHCRDR=obj.HCAHCRDR
 TStart
 s sc=##class(User.CTHealthCareArea).%DeleteId(id)
 if $$$ISOK(sc)
 {
  Tcommit
  s result = "{success:'true',info:'删除成功！'}" 
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareArea","User.CTHealthCareArea","健康监护区域",id,eobj.HCADesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
   Trollback
   s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护区域","web.DHCBL.CT.CTHealthCareArea","DeleteData",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
 }
}
 q result
}

}

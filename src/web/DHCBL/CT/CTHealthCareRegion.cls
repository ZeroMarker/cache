/// Function: CTHealthCareRegion 业务类
/// CreateDate: 2015-3-3
/// Creator:　　sunfengchao
Class web.DHCBL.CT.CTHealthCareRegion Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：    sunfengchao
/// CreatDate:   2015-3-3
/// Description：查询健康监护地区的内容
/// Table：      CT_HealthCareRegion
/// Input：      rowid,code,desc
/// OutPut:      HCR_RowId HCR_Code HCR_Desc HCR_DateFrom HCR_DateTo
/// Debug:       d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHealthCareRegion","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "HCRRowId,HCRCode,HCRDesc,HCRDateFrom,HCRDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
 
   s AuStr=##class(web.DHCBL.Authorize.CTHealthCareRegion).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示 
   if (rowid'="") //根据rowid返回该条记录
   {  
     s HCRRowId=rowid
     s HCRCode=$p($g(^CT("HCR",HCRRowId)),"^",1)
     s HCRDesc=$p($g(^CT("HCR",HCRRowId)),"^",2)
     s HCRDateFrom=$p($g(^CT("HCR",HCRRowId)),"^",3)
     s HCRDateTo=$p($g(^CT("HCR",HCRRowId)),"^",4)
     s:HCRDateFrom'="" HCRDateFrom=$zd(HCRDateFrom,1)  
     s:HCRDateTo'="" HCRDateTo=$zd(HCRDateTo,1)  
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_HealthCareRegion",HCRRowId)
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
     s HCRRowId=0
     for 
     {
        s HCRRowId=$o(^CT("HCR",HCRRowId))
        q:HCRRowId=""
        s strRowId="{ID:"_HCRRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {
           s HCRCode=$p($g(^CT("HCR",HCRRowId)),"^",1)
           s HCRDesc=$p($g(^CT("HCR",HCRRowId)),"^",2)  
           s HCRDateFrom=$p($g(^CT("HCR",HCRRowId)),"^",3)
           s HCRDateTo=$p($g(^CT("HCR",HCRRowId)),"^",4)
           s:HCRDateFrom'="" HCRDateFrom=$zd(HCRDateFrom,1)  
           s:HCRDateTo'="" HCRDateTo=$zd(HCRDateTo,1) 
           s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_HealthCareRegion",HCRRowId)
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           s BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_HealthCareRegion",HCRRowId,HCRDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }  
           if ($zcvt(HCRCode,"U")[code)&(AliasFlag=1) 
           {
             d OutputRow
           }
       }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(HCRRowId,HCRCode,HCRDesc,HCRDateFrom,HCRDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：    sunfengchao
/// CreatDate:   2015-3-3
/// Description：查询健康监护地区的combox 数据源
/// Table：      CT_HealthCareRegion
/// Input：      rowid,code,desc
/// OutPut:      HCR_RowId HCR_Code HCR_Desc 
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHealthCareRegion","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "HCRRowId:%String,HCRCode:%String,HCRDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 s AuStr=##class(web.DHCBL.Authorize.CTHealthCareRegion).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示 
 if (rowid'="")  
 {  
   s HCRRowId=rowid
   s HCRCode=$p($g(^CT("HCR",HCRRowId)),"^",1)
   s HCRDesc=$p($g(^CT("HCR",HCRRowId)),"^",2)
   d OutputRow2
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U")  
   s:desc'="" desc=$ZCONVERT(desc,"U") 
   s HCRRowId=0
   for 
   {
        s HCRRowId=$o(^CT("HCR",HCRRowId))
        q:HCRRowId=""
        s HCRDateFrom=$p($g(^CT("HCR",HCRRowId)),"^",3)
        continue:(HCRDateFrom'="")&&(HCRDateFrom>+$h)
        s HCRDateTo=$p($g(^CT("HCR",HCRRowId)),"^",4) 
        continue:(HCRDateTo'="")&&(HCRDateTo<+$h)
        s strRowId="{ID:"_HCRRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {
           s HCRCode=$p($g(^CT("HCR",HCRRowId)),"^",1)
           s HCRDesc=$p($g(^CT("HCR",HCRRowId)),"^",2)
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_HealthCareRegion",HCRRowId,HCRDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }  
          if ($zcvt(HCRCode,"U")[code)&(AliasFlag=1) 
          {
            d OutputRow2
          }
       }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(HCRRowId,HCRCode,HCRDesc)
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
/// Table：CT_HealthCareRegion
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTHealthCareRegion).%New()
 s obj=##class(User.CTHealthCareRegion).%OpenId(id)
 s eobj.HCRRowId = id
 s eobj.HCRCode=obj.HCRCode
 s eobj.HCRDesc=obj.HCRDesc
 s eobj.HCRDateFrom=obj.HCRDateFrom
 s eobj.HCRDateTo=obj.HCRDateTo
 s:eobj.HCRDateFrom'="" eobj.HCRDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HCRDateFrom) //转换日期格式
 s:eobj.HCRDateTo'="" eobj.HCRDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HCRDateTo) //转换日期格式
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Function： 数据重复验证方法，由js调用
/// Creator：  sunfengchao
/// CreatDate: 2015-3-3
/// Table：    CHealthCareRegion
/// Input：    id, code, desc
/// Return：   "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写 
 s:code'="" flagc=$d(^CT("HCR",0,"Code",code))
 s:desc'="" flagd=$d(^CT("HCR",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("HCR",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("HCR",0,"Desc",desc,0))
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
/// Table：CT_HealthCareRegion
/// Input：web.Entity.CT.CTAcuity 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHealthCareRegion) As %String
{
 s result="",flag=""
 if $IsObject(eobj)
 {
   s:eobj.HCRDateFrom'="" eobj.HCRDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HCRDateFrom)  
   s:eobj.HCRDateTo'="" eobj.HCRDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HCRDateTo)       
   s:eobj.HCRDateFrom="" eobj.HCRDateFrom=+$h
   if (eobj.HCRRowId="")   
   {
    s obj=##class(User.CTHealthCareRegion).%New()
   }
   else                      
   {
    s obj=##class(User.CTHealthCareRegion).%OpenId(eobj.HCRRowId)
    s bobj=##class(web.Entity.CT.CTHealthCareRegion).%New()
    s bobj.HCRRowId=eobj.HCRRowId
    s bobj.HCRCode = obj.HCRCode         
    s bobj.HCRDesc = obj.HCRDesc           
    s bobj.HCRDateFrom = obj.HCRDateFrom  
    s bobj.HCRDateTo = obj.HCRDateTo      
   }
   Ts
   s obj.HCRCode = eobj.HCRCode          
   s obj.HCRDesc = eobj.HCRDesc           
   s obj.HCRDateFrom = eobj.HCRDateFrom   
   s obj.HCRDateTo= eobj.HCRDateTo    
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"  
    d:eobj.HCRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareRegion","User.CTHealthCareRegion","健康监护地区",id,eobj.HCRDesc,"A",eobj)
    d:eobj.HCRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareRegion","User.CTHealthCareRegion","健康监护地区",eobj.HCRRowId,eobj.HCRDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护地区","web.DHCBL.CT.CTHealthCareRegion","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
 }    
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护地区","web.DHCBL.CT.CTHealthCareRegion","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
}

/// Function:  用于数据删除时的逻辑判断
/// CreateDate:2015-3-17
/// Ctreator:  BDP-Sunfengchao
/// Input:     rowid   
/// Output:    返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// Debug      w ##class(web.DHCBL.CT.CTHealthCareRegion).GetRefFlag("3")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s HCARowId=0,found1=0
    for
    {
      s HCARowId=$o(^CT("HCA",HCARowId))
      q:HCARowId=""
      q:found1  
      s HCAHCRDR= $p($g(^CT("HCA",HCARowId)),"^",3)
      if HCAHCRDR=id s found1=1
     }
     if (found1=1)  s myInfo=myInfo_"<健康监护区域>"
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

/// Function：健康监护地区 根据ID删除数据
/// Creator： Sunfengchao
/// CreatDate:2015-3-3
/// Table：   CT_HealthCareRegion
/// Input：   id
/// Return：  成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 s re=##class(web.DHCBL.CT.CTHealthCareRegion).GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 
 if (RefFlag=1)
 {
   s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护地区","web.DHCBL.CT.CTHealthCareRegion","DeleteData","")
   s ^ERRORLOGINFO(logid)=$p(re,"^",2) 
 }
 else
{  
 s eobj = ##class(web.Entity.CT.CTHealthCareRegion).%New()
 s obj=##class(User.CTHealthCareRegion).%OpenId(id)
 s eobj.HCRRowId = id
 s eobj.HCRCode=obj.HCRCode
 s eobj.HCRDesc=obj.HCRDesc
 s eobj.HCRDateFrom=obj.HCRDateFrom
 s eobj.HCRDateTo=obj.HCRDateTo
  
  s sc=##class(User.CTHealthCareRegion).%DeleteId(id)
 
  if $$$ISOK(sc)
  {
   s result = "{success:'true',info:'删除成功！'}" 
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareRegion","User.CTHealthCareRegion","健康监护地区",id,eobj.HCRDesc,"D",eobj)
   d eobj.%Close()
 }
  else 
 {
   s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("健康监护地区","web.DHCBL.CT.CTHealthCareRegion","DeleteData",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
}
  q result
}

}

/// 名称: 严重事故类型维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.PACTrafAccidCode Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACTrafAccidCode
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACTrafAccidCode).%New()
 s eobj.TRFRowId = id
 s eobj.TRFCode=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",1)
 s eobj.TRFDesc=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",2)
 s eobj.TRFDateFrom=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",3)
 s eobj.TRFDateTo=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",4)
 s:eobj.TRFDateFrom'="" eobj.TRFDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.TRFDateFrom) //转换日期格式
 s:eobj.TRFDateTo'="" eobj.TRFDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.TRFDateTo) //转换日期格式
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACTrafAccidCode
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("TRF",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("TRF",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("TRF",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("TRF",0,"Desc",desc,0))
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
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.PACTrafAccidCode
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("TRF",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("TRF",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("TRF",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("TRF",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：保存修改严重事故类型的内容
/// Table：User.PACTrafAccidCode
/// Input：web.Entity.CT.PACTrafAccidCode 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACTrafAccidCode).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACTrafAccidCode) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.TRFDateFrom'="" eobj.TRFDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TRFDateFrom)  //转换日期
  s:eobj.TRFDateTo'="" eobj.TRFDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TRFDateTo)      //转换日期
  s:eobj.TRFDateFrom="" eobj.TRFDateFrom=+$h
  s flag=..Validate(eobj.TRFRowId,eobj.TRFCode,eobj.TRFDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.TRFRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACTrafAccidCode).%New()
   }
   else                   
   {
    s obj=##class(User.PACTrafAccidCode).%OpenId(eobj.TRFRowId)
    s bobj=##class(web.Entity.CT.PACTrafAccidCode).%New()
    s bobj.TRFRowId=eobj.TRFRowId
    s bobj.TRFCode = obj.TRFCode         
    s bobj.TRFDesc = obj.TRFDesc           
    s bobj.TRFDateFrom = obj.TRFDateFrom   
    s bobj.TRFDateTo = obj.TRFDateTo       
   }
   Ts                    
   s obj.TRFCode = eobj.TRFCode         
   s obj.TRFDesc = eobj.TRFDesc           
   s obj.TRFDateFrom = eobj.TRFDateFrom  
   s obj.TRFDateTo = eobj.TRFDateTo      
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         
    //保存日志
    d:eobj.TRFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_TrafAccidCode","User.PACTrafAccidCode","严重事故类型",id,eobj.TRFDesc,"A",eobj)
    d:eobj.TRFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_TrafAccidCode","User.PACTrafAccidCode","严重事故类型",eobj.TRFRowId,eobj.TRFDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("严重事故类型","web.DHCBL.CT.PACTrafAccidCode","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("严重事故类型","web.DHCBL.CT.PACTrafAccidCode","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("严重事故类型","web.DHCBL.CT.PACTrafAccidCode","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除严重事故类型的内容
/// Table：User.PACTrafAccidCode
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACTrafAccidCode).%New()
 s eobj.TRFRowId = id
 s eobj.TRFCode=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",1)
 s eobj.TRFDesc=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",2)
 s eobj.TRFDateFrom=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",3)
 s eobj.TRFDateTo=$p($g(^PAC("TRF",eobj.TRFRowId)),"^",4)
 
 s sc=##class(User.PACTrafAccidCode).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}" 
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_TrafAccidCode","User.PACTrafAccidCode","严重事故类型",id,eobj.TRFDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("严重事故类型","web.DHCBL.CT.PACTrafAccidCode","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询严重事故类型的内容
/// Table： PAC_TrafAccidCode
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACTrafAccidCode","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TRFRowId:%String,TRFCode:%String,TRFDesc:%String,TRFDateFrom:%String,TRFDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACTrafAccidCode).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TRFRowId=rowid
  s TRFCode=$p($g(^PAC("TRF",TRFRowId)),"^",1)
  s TRFDesc=$p($g(^PAC("TRF",TRFRowId)),"^",2)
  s TRFDateFrom=$p($g(^PAC("TRF",TRFRowId)),"^",3)
  s TRFDateTo=$p($g(^PAC("TRF",TRFRowId)),"^",4)
  s:TRFDateFrom'="" TRFDateFrom=$zd(TRFDateFrom,1)  
  s:TRFDateTo'="" TRFDateTo=$zd(TRFDateTo,1)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_TrafAccidCode",TRFRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  s BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
  d OutputRow
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) 
  s TRFRowId=0
  for 
  {
    s TRFRowId=$o(^PAC("TRF",TRFRowId))
    q:TRFRowId=""
    //筛选授权后的数据
    s strRowId="{ID:"_TRFRowId_"}"
    if (AuStr[strRowId)||(AuFlag=1) 
    {
      s TRFCode=$p($g(^PAC("TRF",TRFRowId)),"^",1)
      s TRFDesc=$p($g(^PAC("TRF",TRFRowId)),"^",2)
     s TRFDateFrom=$p($g(^PAC("TRF",TRFRowId)),"^",3)
     s TRFDateTo=$p($g(^PAC("TRF",TRFRowId)),"^",4)
     s:TRFDateFrom'="" TRFDateFrom=$zd(TRFDateFrom,1) 
     s:TRFDateTo'="" TRFDateTo=$zd(TRFDateTo,1)  
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_TrafAccidCode",TRFRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     if (desc'="")
     {
       ;需要对描述或者别名进行检索      
       s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_TrafAccidCode",TRFRowId,TRFDesc,desc)
     }
     else
     {
       s AliasFlag=1   
     } 
     if ($ZCVT(TRFCode,"U")[code)&(AliasFlag=1) 
     {
       d OutputRow
     }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TRFRowId,TRFCode,TRFDesc,TRFDateFrom,TRFDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：sunfengchao
/// CreatDate: 2012-12-10
/// Description：查询严重事故类型的内容,用于combox查询
/// Table：User.PACTrafAccidCode
/// Input：rowid,code,desc
/// Return：TRFRowId,TRFCode,TRFDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACTrafAccidCode","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TRFRowId:%String,TRFCode:%String,TRFDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACTrafAccidCode).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s TRFRowId=rowid
  s TRFCode=$p($g(^PAC("TRF",TRFRowId)),"^",1)
  s TRFDesc=$p($g(^PAC("TRF",TRFRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s TRFRowId=0
  for
  {
   s TRFRowId=$o(^PAC("TRF",TRFRowId))
   q:TRFRowId=""
   s TRFDateFrom=$p($g(^PAC("TRF",TRFRowId)),"^",3)
   continue:(TRFDateFrom'="")&&(TRFDateFrom>+$h)
   s TRFDateTo=$p($g(^PAC("TRF",TRFRowId)),"^",4) 
   continue:(TRFDateTo'="")&&(TRFDateTo<+$h)
   //筛选授权后的数据
   s strRowId="{ID:"_TRFRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
      s TRFCode=$p($g(^PAC("TRF",TRFRowId)),"^",1)
      s TRFDesc=$p($g(^PAC("TRF",TRFRowId)),"^",2)
      if (desc'="")
      {
       ;需要对描述或者别名进行检索      
       s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_TrafAccidCode",TRFRowId,TRFDesc,desc)
      }
      else
      {
       s AliasFlag=1   
      } 
      if ($ZCVT(TRFCode,"U")[code)&(AliasFlag=1) {
       d OutputRow2
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(TRFRowId,TRFCode,TRFDesc)
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

}

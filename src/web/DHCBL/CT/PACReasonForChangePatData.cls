/// 名称: 改变理由维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.PACReasonForChangePatData Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACReasonForChangePatData
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACReasonForChangePatData).%New()
 s eobj.RCHRowId = id
 s eobj.RCHCode=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",1)
 s eobj.RCHDesc=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",2)
 s eobj.RCHDateFrom=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",3)
 s eobj.RCHDateTo=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",4)
 s:eobj.RCHDateFrom'="" eobj.RCHDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RCHDateFrom) //转换日期格式
 s:eobj.RCHDateTo'="" eobj.RCHDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RCHDateTo) //转换日期格式
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACReasonForChangePatData
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("RCH",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("RCH",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("RCH",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("RCH",0,"Desc",desc,0))
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
/// Table：User.PACReasonForChangePatData
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("RCH",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("RCH",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("RCH",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("RCH",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：保存修改改变理由的内容
/// Table：User.PACReasonForChangePatData
/// Input：web.Entity.CT.PACReasonForChangePatData 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACReasonForChangePatData).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACReasonForChangePatData) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.RCHDateFrom'="" eobj.RCHDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RCHDateFrom)  //转换日期
  s:eobj.RCHDateTo'="" eobj.RCHDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RCHDateTo)      //转换日期
  s:eobj.RCHDateFrom="" eobj.RCHDateFrom=+$h
  s flag=..Validate(eobj.RCHRowId,eobj.RCHCode,eobj.RCHDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.RCHRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACReasonForChangePatData).%New()
   }
   else                   //如果RowId已赋值则修改
   {
    s obj=##class(User.PACReasonForChangePatData).%OpenId(eobj.RCHRowId)
    s bobj=##class(web.Entity.CT.PACReasonForChangePatData).%New()
    s bobj.RCHRowId=eobj.RCHRowId
    s bobj.RCHCode = obj.RCHCode         
    s bobj.RCHDesc = obj.RCHDesc          
    s bobj.RCHDateFrom = obj.RCHDateFrom   
    s bobj.RCHDateTo = obj.RCHDateTo      
   }
   Ts                    
   s obj.RCHCode = eobj.RCHCode          
   s obj.RCHDesc = eobj.RCHDesc          
   s obj.RCHDateFrom = eobj.RCHDateFrom   
   s obj.RCHDateTo = eobj.RCHDateTo       
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         
    //保存日志
    d:eobj.RCHRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReasonForChangePatData","User.PACReasonForChangePatData","改变理由",id,eobj.RCHDesc,"A",eobj)
    d:eobj.RCHRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReasonForChangePatData","User.PACReasonForChangePatData","改变理由",eobj.RCHRowId,eobj.RCHDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("改变理由","web.DHCBL.CT.PACReasonForChangePatData","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }    
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("改变理由","web.DHCBL.CT.PACReasonForChangePatData","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("改变理由","web.DHCBL.CT.PACReasonForChangePatData","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除改变理由的内容
/// Table：User.PACReasonForChangePatData
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACReasonForChangePatData).%New()
 s eobj.RCHRowId = id
 s eobj.RCHCode=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",1)
 s eobj.RCHDesc=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",2)
 s eobj.RCHDateFrom=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",3)
 s eobj.RCHDateTo=$p($g(^PAC("RCH",eobj.RCHRowId)),"^",4)
 
 s sc=##class(User.PACReasonForChangePatData).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}" 
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReasonForChangePatData","User.PACReasonForChangePatData","改变理由",id,eobj.RCHDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("改变理由","web.DHCBL.CT.PACReasonForChangePatData","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询改变理由的内容
/// Table： PAC_ReasonForChangePatData
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReasonForChangePatData","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RCHRowId:%String,RCHCode:%String,RCHDesc:%String,RCHDateFrom:%String,RCHDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACReasonForChangePatData).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
   s RCHRowId=rowid
   s RCHCode=$p($g(^PAC("RCH",RCHRowId)),"^",1)
   s RCHDesc=$p($g(^PAC("RCH",RCHRowId)),"^",2)
   s RCHDateFrom=$p($g(^PAC("RCH",RCHRowId)),"^",3)
   s RCHDateTo=$p($g(^PAC("RCH",RCHRowId)),"^",4)
   s:RCHDateFrom'="" RCHDateFrom=$zd(RCHDateFrom,1)  
   s:RCHDateTo'="" RCHDateTo=$zd(RCHDateTo,1)  
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ReasonForChangePatData",RCHRowId)
   s BDPInternalCode =$p($g(resultStr),"^",1)       
   s BDPInternalDesc = $p($g(resultStr),"^",2)  
   s BDPHospNationalCode=$p($g(resultStr),"^",3)         
   s BDPHospNationalDesc = $p($g(resultStr),"^",4)
   d OutputRow
 }
 else
 {
   s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
   s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
   s RCHRowId=0
   for 
   {
     s RCHRowId=$o(^PAC("RCH",RCHRowId))
     q:RCHRowId=""
     ;筛选授权后的数据
     s strRowId="{ID:"_RCHRowId_"}"
     if (AuStr[strRowId)||(AuFlag=1) 
     {
          s RCHCode=$p($g(^PAC("RCH",RCHRowId)),"^",1)
          s RCHDesc=$p($g(^PAC("RCH",RCHRowId)),"^",2)  
          s RCHDateFrom=$p($g(^PAC("RCH",RCHRowId)),"^",3)
          s RCHDateTo=$p($g(^PAC("RCH",RCHRowId)),"^",4)
          s:RCHDateFrom'="" RCHDateFrom=$zd(RCHDateFrom,1) 
          s:RCHDateTo'="" RCHDateTo=$zd(RCHDateTo,1)
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
          s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ReasonForChangePatData",RCHRowId)
          s BDPInternalCode =$p($g(resultStr),"^",1)       
          s BDPInternalDesc = $p($g(resultStr),"^",2)  
          s BDPHospNationalCode=$p($g(resultStr),"^",3)         
          s BDPHospNationalDesc = $p($g(resultStr),"^",4)
          if (desc'="")
          {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ReasonForChangePatData",RCHRowId,RCHDesc,desc)
          }
          else
          {
             s AliasFlag=1   
          } 
          if ($ZCVT(RCHCode,"U")[code)&(AliasFlag=1)   
          {
            d OutputRow
          }
        }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RCHRowId,RCHCode,RCHDesc,RCHDateFrom,RCHDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询改变理由的内容,用于combox查询
/// Table：User.PACReasonForChangePatData
/// Input：rowid,code,desc
/// Return：RCHRowId,RCHCode,RCHDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReasonForChangePatData","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RCHRowId:%String,RCHCode:%String,RCHDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
 
  //获取授权Json
  s AuStr=##class(web.DHCBL.Authorize.PACReasonForChangePatData).DHCGetDataByDefaultSession()
  s AuFlag=0
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
  if (rowid'="") //根据rowid返回该条记录
  {
   s RCHRowId=rowid
   s RCHCode=$p($g(^PAC("RCH",RCHRowId)),"^",1)
   s RCHDesc=$p($g(^PAC("RCH",RCHRowId)),"^",2)
   d OutputRow2
  }
 else
 {
   s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
   s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
   s RCHRowId=0
   for
   {
     s RCHRowId=$o(^PAC("RCH",RCHRowId))
     q:RCHRowId=""
     s RCHDateFrom=$p($g(^PAC("RCH",RCHRowId)),"^",3)
     continue:(RCHDateFrom'="")&&(RCHDateFrom>+$h)
     s RCHDateTo=$p($g(^PAC("RCH",RCHRowId)),"^",4) 
     continue:(RCHDateTo'="")&&(RCHDateTo<+$h)
     //筛选授权后的数据
     s strRowId="{ID:"_RCHRowId_"}"
     if (AuStr[strRowId)||(AuFlag=1) 
     {
       s RCHCode=$p($g(^PAC("RCH",RCHRowId)),"^",1)
       s RCHDesc=$p($g(^PAC("RCH",RCHRowId)),"^",2)
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ReasonForChangePatData",RCHRowId,RCHDesc,desc)
        }
        else
        {
         s AliasFlag=1   
        } 
        if ($ZCVT(RCHCode,"U")[code)&(AliasFlag=1) 
        {
          d OutputRow2
        }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(RCHRowId,RCHCode,RCHDesc)
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

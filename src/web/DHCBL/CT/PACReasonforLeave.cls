/// 名称: 病人回家原因
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-29
Class web.DHCBL.CT.PACReasonforLeave Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACReasonforLeave
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACReasonforLeave).%New()
 s eobj.RFLRowId = id
 s eobj.RFLCode=$p($g(^PAC("LEA",id)),"^",1)
 s eobj.RFLDesc=$p($g(^PAC("LEA",id)),"^",2)
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACReasonforLeave
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("LEA",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("LEA",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("LEA",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("LEA",0,"Desc",desc,0))
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
/// Table：User.PACReasonforLeave
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("LEA",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("LEA",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("LEA",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("LEA",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：保存修改病人回家原因的内容
/// Table：User.PACReasonforLeave
/// Input：web.Entity.CT.PACReasonforLeave 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACReasonforLeave).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACReasonforLeave) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.RFLRowId,eobj.RFLCode,eobj.RFLDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.RFLRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACReasonforLeave).%New()
   }
   else                   //如果RowId已赋值则修改
   {
    s obj=##class(User.PACReasonforLeave).%OpenId(eobj.RFLRowId)
    s bobj=##class(web.Entity.CT.PACReasonforLeave).%New()
    s bobj.RFLRowId=eobj.RFLRowId
    s bobj.RFLCode = obj.RFLCode           
    s bobj.RFLDesc = obj.RFLDesc           
   }
   Ts                    
   s obj.RFLCode = eobj.RFLCode          
   s obj.RFLDesc = eobj.RFLDesc          
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"        
    //保存日志
    d:eobj.RFLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Reason_for_Leave","User.PACReasonforLeave","病人回家原因",id,eobj.RFLDesc,"A",eobj)
    d:eobj.RFLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Reason_for_Leave","User.PACReasonforLeave","病人回家原因",eobj.RFLRowId,eobj.RFLDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病人回家原因","web.DHCBL.CT.PACReasonforLeave","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病人回家原因","web.DHCBL.CT.PACReasonforLeave","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病人回家原因","web.DHCBL.CT.PACReasonforLeave","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：根据ID删除病人回家原因的内容
/// Table：User.PACReasonforLeave
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACReasonforLeave).%New()
 s eobj.RFLRowId = id
 s eobj.RFLCode=$p($g(^PAC("LEA",id)),"^",1)
 s eobj.RFLDesc=$p($g(^PAC("LEA",id)),"^",2)
 
 s sc=##class(User.PACReasonforLeave).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Reason_for_Leave","User.PACReasonforLeave","病人回家原因",id,eobj.RFLDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病人回家原因","web.DHCBL.CT.PACReasonforLeave","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：查询病人回家原因的内容
/// Table： PAC_Reason_for_Leave
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReasonforLeave","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RFLRowId:%String,RFLCode:%String,RFLDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACReasonforLeave).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s RFLRowId=rowid
  s RFLCode=$p($g(^PAC("LEA",RFLRowId)),"^",1)
  s RFLDesc=$p($g(^PAC("LEA",RFLRowId)),"^",2)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_Reason_for_Leave",RFLRowId)
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
   s RFLRowId=0
   for
   {
        s RFLRowId=$o(^PAC("LEA",RFLRowId))
        q:RFLRowId=""
        ;筛选授权后的数据
        s strRowId="{ID:"_RFLRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) {
        s RFLCode=$p($g(^PAC("LEA",RFLRowId)),"^",1)
        s RFLDesc=$p($g(^PAC("LEA",RFLRowId)),"^",2)
     
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_Reason_for_Leave",RFLRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_Reason_for_Leave",RFLRowId,RFLDesc,desc)
        }
        else
        {
           s AliasFlag=1   
        } 
        if ($ZCVT(RFLCode,"U")[code)&(AliasFlag=1)  
        {
          d OutputRow
        }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RFLRowId,RFLCode,RFLDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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
/// Description：查询病人回家原因的内容,用于combox查询
/// Table：User.PACReasonforLeave
/// Input：rowid,code,desc
/// Return：RFLRowId,RFLCode,RFLDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReasonforLeave","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RFLRowId:%String,RFLCode:%String,RFLDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACReasonforLeave).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s RFLRowId=rowid
  s RFLCode=$p($g(^PAC("LEA",RFLRowId)),"^",1)
  s RFLDesc=$p($g(^PAC("LEA",RFLRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s RFLRowId=0
  f {
   s RFLRowId=$o(^PAC("LEA",RFLRowId))
   q:RFLRowId=""
   //筛选授权后的数据
   s strRowId="{ID:"_RFLRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
     s RFLCode=$p($g(^PAC("LEA",RFLRowId)),"^",1)
     s RFLDesc=$p($g(^PAC("LEA",RFLRowId)),"^",2)
     if (desc'="")
     {
       ;需要对描述或者别名进行检索      
       s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_Reason_for_Leave",RFLRowId,RFLDesc,desc)
     }
     else
     {
       s AliasFlag=1   
     } 
     if ($ZCVT(RFLCode,"U")[code)&(AliasFlag=1) 
     {
       d OutputRow2
     }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(RFLRowId,RFLCode,RFLDesc)
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

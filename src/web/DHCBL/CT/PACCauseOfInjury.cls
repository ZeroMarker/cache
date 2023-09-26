Import SQLUser

/// 名称: 伤害原因维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.PACCauseOfInjury Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACCauseOfInjury
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACCauseOfInjury).%New()
 s eobj.INJURowId = id
 s eobj.INJUCode=$p($g(^PAC("INJU",eobj.INJURowId)),"^",1)
 s eobj.INJUDesc=$p($g(^PAC("INJU",eobj.INJURowId)),"^",2)
 s eobj.INJUDateFrom=$p($g(^PAC("INJU",eobj.INJURowId)),"^",3)
 s eobj.INJUDateTo=$p($g(^PAC("INJU",eobj.INJURowId)),"^",4)
 s:eobj.INJUDateFrom'="" eobj.INJUDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.INJUDateFrom) //转换日期格式
 s:eobj.INJUDateTo'="" eobj.INJUDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.INJUDateTo) //转换日期格式
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACCauseOfInjury
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("INJU",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("INJU",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("INJU",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("INJU",0,"Desc",desc,0))
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
/// Table：User.PACCauseOfInjury
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("INJU",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("INJU",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("INJU",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("INJU",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：保存修改伤害原因的内容
/// Table：User.PACCauseOfInjury
/// Input：web.Entity.CT.PACCauseOfInjury 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACCauseOfInjury).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACCauseOfInjury) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.INJUDateFrom'="" eobj.INJUDateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.INJUDateFrom)  //转换日期
  s:eobj.INJUDateTo'="" eobj.INJUDateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.INJUDateTo)      //转换日期
  s:eobj.INJUDateFrom="" eobj.INJUDateFrom=+$h
  s flag=..Validate(eobj.INJURowId,eobj.INJUCode,eobj.INJUDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.INJURowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACCauseOfInjury).%New()
   }
   else                    //如果RowId已赋值则修改
   {
    s obj=##class(User.PACCauseOfInjury).%OpenId(eobj.INJURowId)
    s bobj=##class(web.Entity.CT.PACCauseOfInjury).%New()
    s bobj.INJURowId=eobj.INJURowId
    s bobj.INJUCode = obj.INJUCode           
    s bobj.INJUDesc = obj.INJUDesc         
    s bobj.INJUDateFrom = obj.INJUDateFrom   
    s bobj.INJUDateTo = obj.INJUDateTo       
   }
   Ts                    
   s obj.INJUCode = eobj.INJUCode          //修改代码
   s obj.INJUDesc = eobj.INJUDesc          //修改描述
   s obj.INJUDateFrom = eobj.INJUDateFrom  //修改开始日期
   s obj.INJUDateTo = eobj.INJUDateTo      //修改结束日期
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.INJURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_CauseOfInjury","User.PACCauseOfInjury","伤害原因",id,eobj.INJUDesc,"A",eobj)
    d:eobj.INJURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_CauseOfInjury","User.PACCauseOfInjury","伤害原因",eobj.INJURowId,eobj.INJUDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
   }
  }  
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除伤害原因的内容
/// Table：User.PACCauseOfInjury
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACCauseOfInjury).%New()
 s eobj.INJURowId = id
 s eobj.INJUCode=$p($g(^PAC("INJU",eobj.INJURowId)),"^",1)
 s eobj.INJUDesc=$p($g(^PAC("INJU",eobj.INJURowId)),"^",2)
 s eobj.INJUDateFrom=$p($g(^PAC("INJU",eobj.INJURowId)),"^",3)
 s eobj.INJUDateTo=$p($g(^PAC("INJU",eobj.INJURowId)),"^",4)
 
 s sc=##class(User.PACCauseOfInjury).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}" 
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_CauseOfInjury","User.PACCauseOfInjury","伤害原因",id,eobj.INJUDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询伤害原因的内容
/// Table ： PAC_CauseOfInjury
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACCauseOfInjury","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "INJURowId:%String,INJUCode:%String,INJUDesc:%String,INJUDateFrom:%String,INJUDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACCauseOfInjury).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
   s INJURowId=rowid
   s INJUCode=$p($g(^PAC("INJU",INJURowId)),"^",1)
   s INJUDesc=$p($g(^PAC("INJU",INJURowId)),"^",2)
   s INJUDateFrom=$p($g(^PAC("INJU",INJURowId)),"^",3)
   s INJUDateTo=$p($g(^PAC("INJU",INJURowId)),"^",4)
   s:INJUDateFrom'="" INJUDateFrom=$zd(INJUDateFrom,1) 
   s:INJUDateTo'="" INJUDateTo=$zd(INJUDateTo,1) 
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_CauseOfInjury",INJURowId)
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
   s INJURowId=0
   for
   {
     s INJURowId=$o(^PAC("INJU",INJURowId))
     q:INJURowId=""
     ;筛选授权后的数据
     s strRowId="{ID:"_INJURowId_"}"
     if (AuStr[strRowId)||(AuFlag=1) 
     {
       s INJUCode=$p($g(^PAC("INJU",INJURowId)),"^",1)
       s INJUDesc=$p($g(^PAC("INJU",INJURowId)),"^",2) 
       s INJUDateFrom=$p($g(^PAC("INJU",INJURowId)),"^",3)
       s INJUDateTo=$p($g(^PAC("INJU",INJURowId)),"^",4)
       s:INJUDateFrom'="" INJUDateFrom=$zd(INJUDateFrom,1)  
       s:INJUDateTo'="" INJUDateTo=$zd(INJUDateTo,1)  
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_CauseOfInjury",INJURowId)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4)
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_CauseOfInjury",INJURowId,INJUDesc,desc)
       }
       else
       {
         s AliasFlag=1   
       } 
       if ($ZCVT(INJUCode,"U")[code)&(AliasFlag=1)   
       {
         d OutputRow
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(INJURowId,INJUCode,INJUDesc,INJUDateFrom,INJUDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询伤害原因的内容,用于combox查询
/// Table：User.PACCauseOfInjury
/// Input：rowid,code,desc
/// Return：INJURowId,INJUCode,INJUDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACCauseOfInjury","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "INJURowId:%String,INJUCode:%String,INJUDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACCauseOfInjury).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s INJURowId=rowid
  s INJUCode=$p($g(^PAC("INJU",INJURowId)),"^",1)
  s INJUDesc=$p($g(^PAC("INJU",INJURowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s INJURowId=0
  for
  {
   s INJURowId=$o(^PAC("INJU",INJURowId))
   q:INJURowId=""
   s INJUDateFrom=$p($g(^PAC("INJU",INJURowId)),"^",3)
   continue:(INJUDateFrom'="")&&(INJUDateFrom>+$h)
   s INJUDateTo=$p($g(^PAC("INJU",INJURowId)),"^",4) 
   continue:(INJUDateTo'="")&&(INJUDateTo<+$h)
   //筛选授权后的数据
   s strRowId="{ID:"_INJURowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
    s INJUCode=$p($g(^PAC("INJU",INJURowId)),"^",1)
    s INJUDesc=$p($g(^PAC("INJU",INJURowId)),"^",2)
    if (desc'="")
    {
     ;需要对描述或者别名进行检索      
     s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_CauseOfInjury",INJURowId,INJUDesc,desc)
    }
    else
    {
     s AliasFlag=1   
    } 
    if ($ZCVT(INJUCode,"U")[code)&(AliasFlag=1)      
    {
        d OutputRow2
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(INJURowId,INJUCode,INJUDesc)
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

/// 名称: 急诊优先级维护
/// 描述: 包含增\删\改\查功能
/// 编写者：sunfengchao
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.CTAcuity Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTAcuity
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTAcuity).%New()
 s eobj.CTACURowId = id
 s eobj.CTACUCode=$p($g(^CT("ACU",id)),"^",1)
 s eobj.CTACUDesc=$p($g(^CT("ACU",id)),"^",2)
 s eobj.CTACUWaitTime=$p($g(^CT("ACU",id)),"^",3)
 s eobj.CTACUDateFrom=$p($g(^CT("ACU",id)),"^",8)
 s eobj.CTACUDateTo=$p($g(^CT("ACU",id)),"^",9)
 s eobj.CTACUColour=$p($g(^CT("ACU",id)),"^",11)
 s:eobj.CTACUDateFrom'="" eobj.CTACUDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTACUDateFrom) //转换日期格式
 s:eobj.CTACUDateTo'="" eobj.CTACUDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTACUDateTo) //转换日期格式
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-11-28
/// Description：数据重复验证方法，由js调用
/// Table：User.CTAcuity
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$ZCONVERT(code,"U") //转换成大写
 s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("ACU",0,"Code",code))
 s:desc'="" flagd=$d(^CT("ACU",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("ACU",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("ACU",0,"Desc",desc,0))
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
/// Table：User.CTAcuity
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("ACU",0,"Code",code))
 s:desc'="" flagd=$d(^CT("ACU",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("ACU",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("ACU",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator: sunfengchao
/// CreatDate: 2012-8-30
/// Description：保存修改急诊优先级的内容
/// Table：User.CTAcuity
/// Input：web.Entity.CT.CTAcuity 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTAcuity).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTAcuity) As %String
{
 s $zt="ERROE"
 s result="",flag=""
 if $IsObject(eobj)
 {
  s:eobj.CTACUDateFrom="" eobj.CTACUDateFrom=+$h
  s:eobj.CTACUDateFrom'="" eobj.CTACUDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTACUDateFrom) //转换日期
  s:eobj.CTACUDateTo'="" eobj.CTACUDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTACUDateTo)      //转换日期
  
  s flag=..Validate(eobj.CTACURowId,eobj.CTACUCode,eobj.CTACUDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.CTACURowId="")  
   {
    s obj=##class(User.CTAcuity).%New()
   }
   else                    
   {
    s obj=##class(User.CTAcuity).%OpenId(eobj.CTACURowId)
    s bobj=##class(web.Entity.CT.CTAcuity).%New()
    s bobj.CTACURowId=eobj.CTACURowId
    s bobj.CTACUCode = obj.CTACUCode          
    s bobj.CTACUDesc = obj.CTACUDesc          
    s bobj.CTACUWaitTime = obj.CTACUWaitTime
    s bobj.CTACUDateFrom = obj.CTACUDateFrom  //修改开始日期
    s bobj.CTACUDateTo = obj.CTACUDateTo      //修改结束日期
    s bobj.CTACUColour=obj.CTACUColour
   }
   Ts
   s obj.CTACUCode = eobj.CTACUCode          //修改代码
   s obj.CTACUDesc = eobj.CTACUDesc          //修改描述
   s obj.CTACUWaitTime = eobj.CTACUWaitTime
   s obj.CTACUDateFrom = eobj.CTACUDateFrom  //修改开始日期
   s obj.CTACUDateTo = eobj.CTACUDateTo      //修改结束日期
   s obj.CTACUColour=eobj.CTACUColour
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"  //返回RowId
    //新增时，日志
    d:eobj.CTACURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Acuity","User.CTAcuity","急诊优先级",id,eobj.CTACUDesc,"A",eobj)
    //修改时，日志
    d:eobj.CTACURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Acuity","User.CTAcuity","急诊优先级",eobj.CTACURowId,eobj.CTACUDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊优先级","web.DHCBL.CT.CTAcuity","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
   }
  }    
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊优先级","web.DHCBL.CT.CTAcuity","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊优先级","web.DHCBL.CT.CTAcuity","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：根据ID删除急诊优先级的内容
/// Table：User.CTAcuity
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 //new Entity对象，用于保存日志
 s eobj = ##class(web.Entity.CT.CTAcuity).%New()
 s eobj.CTACURowId = id
 s eobj.CTACUCode=$p($g(^CT("ACU",id)),"^",1)
 s eobj.CTACUDesc=$p($g(^CT("ACU",id)),"^",2)
 s eobj.CTACUWaitTime=$p($g(^CT("ACU",id)),"^",3)
 s eobj.CTACUDateFrom=$p($g(^CT("ACU",id)),"^",8)
 s eobj.CTACUDateTo=$p($g(^CT("ACU",id)),"^",9)
 s eobj.CTACUColour=$p($g(^CT("ACU",id)),"^",11)
 
 s sc=##class(User.CTAcuity).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result = "{success:'true',info:'删除成功！'}" 
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Acuity","User.CTAcuity","急诊优先级",id,eobj.CTACUDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("急诊优先级","web.DHCBL.CT.CTAcuity","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：查询急诊优先级的内容
/// Table： CT_Acuity
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTAcuity","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTACURowId:%String,CTACUCode:%String,CTACUDesc:%String,CTACUWaitTime:%String,CTACUDateFrom:%String,CTACUDateTo:%String,CTACUColour:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
 
   s AuStr= ##class(web.DHCBL.Authorize.CTAcuity).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示 
   if (rowid'="") //根据rowid返回该条记录
   {
     s CTACURowId=rowid
     s CTACUCode=$p($g(^CT("ACU",CTACURowId)),"^",1)
     s CTACUDesc=$p($g(^CT("ACU",CTACURowId)),"^",2)
     s CTACUWaitTime=$p($g(^CT("ACU",CTACURowId)),"^",3)
     s CTACUDateFrom=$p($g(^CT("ACU",CTACURowId)),"^",8)
     s CTACUDateTo=$p($g(^CT("ACU",CTACURowId)),"^",9)
     s CTACUColour=$p($g(^CT("ACU",CTACURowId)),"^",11)
     s:CTACUDateFrom'="" CTACUDateFrom=$zd(CTACUDateFrom,1) 
     s:CTACUDateTo'="" CTACUDateTo=$zd(CTACUDateTo,1)  
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s BDPStandardRowId=$o(^User.BDPStandardCodeI("DataRef","CT_Acuity",CTACURowId,0))  
     if (BDPStandardRowId'="")
     {
      s BDPInternalCode = $listget(^User.BDPStandardCodeD(BDPStandardRowId),6)          
      s BDPInternalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),7)
      s BDPHospNationalCode=$listget(^User.BDPStandardCodeD(BDPStandardRowId),8)          
      s BDPHospNationalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),9)
     }
     d OutputRow
   }
   else
   {
     s:code'="" code=$ZCONVERT(code,"U") //转换成大写
     s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
     s CTACURowId=0
     for 
     {
        s CTACURowId=$o(^CT("ACU",CTACURowId))
        q:CTACURowId=""
        //筛选授权后的数据
        s strRowId="{ID:"_CTACURowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {
           s CTACUCode=$p($g(^CT("ACU",CTACURowId)),"^",1)
           s CTACUDesc=$p($g(^CT("ACU",CTACURowId)),"^",2) 
           s CTACUWaitTime=$p($g(^CT("ACU",CTACURowId)),"^",3)
           s CTACUDateFrom=$p($g(^CT("ACU",CTACURowId)),"^",8)
           s CTACUDateTo=$p($g(^CT("ACU",CTACURowId)),"^",9)
           s CTACUColour=$p($g(^CT("ACU",CTACURowId)),"^",11)
           s:CTACUDateFrom'="" CTACUDateFrom=$zd(CTACUDateFrom,1) 
           s:CTACUDateTo'="" CTACUDateTo=$zd(CTACUDateTo,1) 
           s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
           s BDPStandardRowId=$o(^User.BDPStandardCodeI("DataRef","CT_Acuity",CTACURowId,0))  
           if (BDPStandardRowId'="")
           {
            s BDPInternalCode = $listget(^User.BDPStandardCodeD(BDPStandardRowId),6)          
            s BDPInternalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),7)
            s BDPHospNationalCode=$listget(^User.BDPStandardCodeD(BDPStandardRowId),8)          
            s BDPHospNationalDesc = $listget(^User.BDPStandardCodeD(BDPStandardRowId),9)
           }
           if (desc'="")
           {
             ;需要对描述或者别名进行检索      
             s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Acuity",CTACURowId,CTACUDesc,desc)
           }
           else
           {
             s AliasFlag= 1   
           }    
           if ($ZCONVERT(CTACUCode,"U")[code)&(AliasFlag=1) 
           {
             d OutputRow
           }
       }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTACURowId,CTACUCode,CTACUDesc,CTACUWaitTime,CTACUDateFrom,CTACUDateTo,CTACUColour,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询急诊优先级的内容,用于combox查询
/// Table：User.CTAcuity
/// Input：rowid,code,desc
/// Return：CTACURowId,CTACUCode,CTACUDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTAcuity","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTACURowId:%String,CTACUCode:%String,CTACUDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权
 s AuStr=##class(web.DHCBL.Authorize.CTAcuity).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTACURowId=rowid
  s CTACUCode=$p($g(^CT("ACU",CTACURowId)),"^",1)
  s CTACUDesc=$p($g(^CT("ACU",CTACURowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s CTACURowId=0
  for {
   s CTACURowId=$o(^CT("ACU",CTACURowId))
   q:CTACURowId=""
   //筛选授权后的数据
   s strRowId="{ID:"_CTACURowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) {
    s CTACUCode=$p($g(^CT("ACU",CTACURowId)),"^",1)
    s CTACUDesc=$p($g(^CT("ACU",CTACURowId)),"^",2) 
    s CTACUDateFrom=$p($g(^CT("ACU",CTACURowId)),"^",8)
    continue:(CTACUDateFrom'="")&&(CTACUDateFrom>+$h)
    s CTACUDateTo=$p($g(^CT("ACU",CTACURowId)),"^",9) 
    continue:(CTACUDateTo'="")&&(CTACUDateTo<+$h)
    if (desc'="")
    {
     ;需要对描述或者别名进行检索      
     s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Acuity",CTACURowId,CTACUDesc,desc)
    }
    else
    {
     s AliasFlag= 1   
    }    
    if ($ZCONVERT(CTACUCode,"U")[code)&(AliasFlag=1) 
    {
        d OutputRow2
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(CTACURowId,CTACUCode,CTACUDesc)
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

ClassMethod GetIPAddress()
{
   s ipaddress="",browerinfo=""
   s ipaddress=$Get(%session.Data("REMOTE_ADDR"))
   s browerinfo=$g(^tmp("dhc.bdp.errorlog",ipaddress))
   q browerinfo
}

}

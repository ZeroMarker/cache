/// 名称: 银行卡类型维护 
/// 描述: 银行卡类型维护，包含增删改查功能
/// 编写者：基础平台组 孙凤超
/// 编写日期: 2013-5-13
Class web.DHCBL.CT.ARCBankCardType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：孙凤超
/// CreatDate:2013-5-13
/// Description：查询银行卡类型的内容
/// Table： ARC_BankCardType
/// Input：rowid,code,desc 
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCBankCardType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CARDRowId:%String,CARDCode:%String,CARDDesc:%String,CARDDateFrom:%String,CARDDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s resultStr="",BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
   s AuStr= ##class(web.DHCBL.Authorize.ARCBankCardType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   if (rowid'="") //根据rowid返回该条记录
   {
     s CARDRowId=rowid
     s CARDCode=$p($g(^ARC("CARD",CARDRowId)),"^",1)
     s CARDDesc=$p($g(^ARC("CARD",CARDRowId)),"^",2)
     s CARDDateFrom=$p($g(^ARC("CARD",CARDRowId)),"^",4)
     s CARDDateTo=$p($g(^ARC("CARD",CARDRowId)),"^",5)
     s:CARDDateFrom CARDDateFrom=$zd(CARDDateFrom,1)   
     s:CARDDateTo CARDDateTo=$zd(CARDDateTo,1)  

     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_BankCardType",CARDRowId)
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
     s CARDRowId=0
     for
     {  
        s CARDRowId=$o(^ARC("CARD",CARDRowId)) q:CARDRowId=""   
        s strCARDRowId="{ID:"_CARDRowId_"}"
        if (AuStr[strCARDRowId)||(AuFlag=1) 
        {
           s CARDCode=$p($g(^ARC("CARD",CARDRowId)),"^",1)
           s CARDDesc=$p($g(^ARC("CARD",CARDRowId)),"^",2)
           s CARDDateFrom=$p($g(^ARC("CARD",CARDRowId)),"^",4)
           s CARDDateTo=$p($g(^ARC("CARD",CARDRowId)),"^",5)
           s:CARDDateFrom CARDDateFrom=$zd(CARDDateFrom,1) //转换日期格式
           s:CARDDateTo CARDDateTo=$zd(CARDDateTo,1) //转换日期格式
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_BankCardType",CARDRowId)
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           s BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc =$p($g(resultStr),"^",4) 
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_BankCardType",CARDRowId,CARDDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }
           if ($$ALPHAUP^SSUTIL4(CARDCode)[code)&(AliasFlag= 1)
           {
              d OutputRow
           }
        }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CARDRowId,CARDCode,CARDDesc,CARDDateFrom,CARDDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索,为combo提供查询银行卡类型的接口
/// CreateDate:2013-5-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables: User.ARCBankCardType
/// Input:  code, desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCBankCardType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CARDRowId:%String,CARDCode:%String,CARDDesc:%String")
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
  s AuStr=##class(web.DHCBL.Authorize.ARCBankCardType).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
  if (rowid'="") //根据rowid返回该条记录
  {
    s CARDRowId=rowid
    s CARDCode=$p($g(^ARC("CARD",CARDRowId)),"^",1)
    s CARDDesc=$p($g(^ARC("CARD",CARDRowId)),"^",2)
    d OutputRowCmb
  }
  else
  {
    s:code'="" code=$zcvt(code,"U") 
    s:desc'="" desc=$zcvt(desc,"U") 
    s CARDRowId=0
    for
    {  
      s CARDRowId=$o(^ARC("CARD",CARDRowId)) q:CARDRowId=""   
      s strCARDRowId="{ID:"_CARDRowId_"}"
      if (AuStr[strCARDRowId)||(AuFlag=1) 
      {
        s CARDCode=$p($g(^ARC("CARD",CARDRowId)),"^",1)
        s CARDDesc=$p($g(^ARC("CARD",CARDRowId)),"^",2) 
        s CARDDateFrom=$p($g(^ARC("CARD",CARDRowId)),"^",4)
        continue:(CARDDateFrom'="")&&(CARDDateFrom>+$h)
        s CARDDateTo=$p($g(^ARC("CARD",CARDRowId)),"^",5) 
        continue:(CARDDateTo'="")&&(CARDDateTo<+$h)
        if (desc'="")
        {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_BankCardType",CARDRowId,CARDDesc,desc)
        }
        else
        {
          s AliasFlag= 1   
        }
       if ($zcvt(CARDCode,"U")[code)&(AliasFlag=1)
       {
         d OutputRowCmb
       }
    }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(CARDRowId,CARDCode,CARDDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:双击时显示银行卡类型的内容
/// CreateDate:2013-5-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables: User.ARCBankCardType
/// Others:w ##class(web.DHCBL.CT.ARCBankCardType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.ARCBankCardType).%OpenId(id)
 s eobj = ##class(web.Entity.CT.ARCBankCardType).%New()
 s eobj.CARDRowId=id
 s eobj.CARDCode= pobj.CARDCode
 s eobj.CARDDesc = pobj.CARDDesc
 s:pobj.CARDDateFrom'="" eobj.CARDDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CARDDateFrom)
 s:pobj.CARDDateTo'="" eobj.CARDDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CARDDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对银行卡类型删除操作
/// Creator:孙凤超
/// CreateDate:2013-05-13
/// Desc:通过rowid号来删除银行卡类型 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  User.ARCBankCardType  
/// Others:d ##class(web.DHCBL.CT.ARCBankCardType)DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s eobj = ##class(web.Entity.CT.ARCBankCardType).%New()
    s obj = ##class(User.ARCBankCardType).%OpenId(id)
    s eobj.CARDRowId=id
    s eobj.CARDCode = obj.CARDCode
    s eobj.CARDDesc= obj.CARDDesc
    s eobj.CARDDateFrom = obj.CARDDateFrom
    s eobj.CARDDateTo=obj.CARDDateTo
   
    s sc=##class(User.ARCBankCardType).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BankCardType","User.ARCBankCardType","银行卡类型",id,eobj.CARDDesc,"D",eobj)
      d eobj.%Close()
    }
    else
    {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("银行卡类型","web.DHCBL.CT.ARCBankCardType","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-5-13
/// Description：数据重复校验
/// Table： ARC_BankCardType
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^ARC("CARD",0,"Code",code))
 s:desc'="" flagd=$d(^ARC("CARD",0,"Desc",desc))
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
  s idc="",idd=""
  s:code'="" idc=$o(^ARC("CARD",0,"Code",code,0))
  s:desc'="" idd=$o(^ARC("CARD",0,"Desc",desc,0))
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
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-05-13
/// Description：保存修改银行卡类型的内容
/// Table：User.ARCBankCardType
/// Input：web.Entity.CT.ARCBankCardType 实体类
/// Others: d ##class(web.DHCBL.CT.ARCBankCardType).SaveEntity()
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCBankCardType) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CARDDateFrom="" eobj.CARDDateFrom=+$h
  if eobj.CARDDateFrom'="" s eobj.CARDDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CARDDateFrom)   
  if eobj.CARDDateTo'="" s eobj.CARDDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CARDDateTo)      
  if (eobj.CARDRowId="")       
  {
   s obj=##class(User.ARCBankCardType).%New()
  }
  else                           
  {   
    s obj=##class(User.ARCBankCardType).%OpenId(eobj.CARDRowId)
    s bobj=##class(web.Entity.CT.ARCBankCardType).%New()
    s bobj.CARDRowId=eobj.CARDRowId
    s bobj.CARDCode = obj.CARDCode                      
    s bobj.CARDDesc= obj.CARDDesc                     
    s bobj.CARDDateFrom = obj.CARDDateFrom 
    s bobj.CARDDateTo=obj.CARDDateTo 
  }
   s obj.CARDCode = eobj.CARDCode                      
   s obj.CARDDesc= eobj.CARDDesc                      
   s obj.CARDDateFrom = eobj.CARDDateFrom 
   s obj.CARDDateTo=eobj.CARDDateTo
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
     Tcommit
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"          
     d:eobj.CARDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BankCardType","User.ARCBankCardType","银行卡类型",id,eobj.CARDDesc,"A",eobj)
     d:eobj.CARDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BankCardType","User.ARCBankCardType","银行卡类型",eobj.CARDRowId,eobj.CARDDesc,"U",eobj,bobj)
   }
   else
   {
      Trollback
      s logid="",errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("银行卡类型","web.DHCBL.CT.ARCBankCardType","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=errorinfo   
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
   } 
  }
  else
  {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
  } 
  q result
ERROR
  s logid="",errorinfo="保存失败！"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("银行卡类型","web.DHCBL.CT.ARCBankCardType","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=errorinfo  
  q "{success:'false',errorinfo:'保存失败！'}"
}

}

/// Function:　征收代码
/// Creator:   sunfengchao
/// CreateDate: 2015-10-29
Class web.DHCBL.CT.ARCTariff Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:　征收代码查询列表
/// Creator:   sunfengchao
/// CreateDate:2015-10-29
/// Table：    ARC_Tariff
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCTariff", "GetList","","","")
///   TAR_RowId TAR_Code  TAR_Desc
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARRowId:%String,TARCode:%String,TARDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.ARCTariff).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 if (rowid'="")  
 {
      s TARRowId=rowid
      s TARCode=$p($g(^ARC("TAR",rowid)),"^",1)
      s TARDesc=$p($g(^ARC("TAR",rowid)),"^",2)
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_Tariff",TARRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      S BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      d OutputRow
 }
 else
 {
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARRowId=0
   for
   { 
     s TARRowId=$o(^ARC("TAR",TARRowId)) q:TARRowId=""   
     s strTARRowId="{ID:"_TARRowId_"}"
     if (AuStr[strTARRowId)||(AuFlag=1) 
     {  
        s TARCode=$p($g(^ARC("TAR",TARRowId)),"^",1)
        s TARDesc=$p($g(^ARC("TAR",TARRowId)),"^",2) 
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_Tariff",TARRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        S BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_Tariff",TARRowId,TARDesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }  
        if (($ZCVT(TARCode,"U")[code))&&(AliasFlag=1) 
        {
         d OutputRow
        }
      }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TARRowId,TARCode,TARDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:　征收代码查询combox接口
/// Creator:   sunfengchao
/// CreateDate:2015-10-29
/// Tables: ARC_Tariff
/// Input:  code，desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCTariff", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARRowId:%String,TARCode:%String,TARDesc:%String")
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
 s AuStr=##class(web.DHCBL.Authorize.ARCTariff).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
 if (rowid'="")  
 {
  s TARRowId=rowid
  s TARCode=$p($g(^ARC("TAR",rowid)),"^",1)
  s TARDesc=$p($g(^ARC("TAR",rowid)),"^",2)
  d OutputRow2
 }
 else
 {
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   s TARRowId=0
   for
   { 
     s TARRowId=$o(^ARC("TAR",TARRowId)) q:TARRowId=""   
     s strTARRowId="{ID:"_TARRowId_"}"
     if (AuStr[strTARRowId)||(AuFlag=1) 
     {   
        s TARCode=$p($g(^ARC("TAR",TARRowId)),"^",1)
        s TARDesc=$p($g(^ARC("TAR",TARRowId)),"^",2)
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_Tariff",TARRowId,TARDesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }  
        if (($ZCVT(TARCode,"U")[code))&&(AliasFlag=1) 
        {
           d OutputRow2
        }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
  set Data=$lb(TARRowId,TARCode,TARDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function： 数据重复校验
/// Creator：  sunfengchao
/// CreatDate: 2012-12-7
/// Table：    ARC_Tariff
/// Input：    id, code, desc
/// Return：   "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^ARC("TAR",0,"Code",code))
 s:desc'="" flagd=$d(^ARC("TAR",0,"Desc",desc))
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
  s:code'="" idc=$o(^ARC("TAR",0,"Code",code,0))
  s:desc'="" idd=$o(^ARC("TAR",0,"Desc",desc,0))
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

/// Creator：sunfengchao
/// CreatDate: 2015-10-29
/// Table：ARC_Tariff
/// Others:d ##class(web.DHCBL.CT.ARCTariff).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
    s prbj = ##class(User.ARCTariff).%OpenId(id)
    s eobj = ##class(web.Entity.CT.ARCTariff).%New()
    s eobj.TARRowId = id
    s eobj.TARCode  = prbj.TARCode
    s eobj.TARDesc = prbj.TARDesc
    kill prbj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator：基础数据平台组
/// CreatDate: 2012-8-3
/// Description：保存修改押金类型内容
/// Table： ARC_Tariff
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCTariff) As %String
{
 s $zt="EEROE"
 s result="",jsonstr=""
 if $IsObject(eobj)
 { 
  if ((eobj.TARRowId)="")                             
  { 
    s obj=##class(User.ARCTariff).%New()
  }
  else                                                  
  {
   s obj=##class(User.ARCTariff).%OpenId(eobj.TARRowId)
   s bobj=##class(web.Entity.CT.ARCTariff).%New()
   s bobj.TARRowId=eobj.TARRowId
   s bobj.TARCode = obj.TARCode                     
   s bobj.TARDesc = obj.TARDesc   
  } 
  s obj.TARCode = eobj.TARCode                     
  s obj.TARDesc = eobj.TARDesc                      
  
  Ts
  s sc=obj.%Save()
  d obj.%Close()
  If $$$ISOK(sc)
  {
   Tc
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"          
   d:eobj.TARRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_Tariff","User.ARCTariff","征收代码",id,eobj.TARDesc,"A",eobj)
   d:eobj.TARRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_Tariff","User.ARCTariff","征收代码",eobj.TARRowId,eobj.TARDesc,"U",eobj,bobj)
  }
  else
  {
   Trollback
   s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("征收代码","web.DHCBL.CT.ARCTariff","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
  }   
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("征收代码","web.DHCBL.CT.ARCTariff","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！" 
 } 
 q result
EEROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("征收代码","web.DHCBL.CT.ARCTariff","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Function：删除征收代码内容
/// Creator：sunfengchao
/// CreatDate: 2015-10-29
/// Table： ARC_Tariff
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    Tstart
    s obj=##class(User.ARCTariff).%OpenId(id)
    s eobj = ##class(web.Entity.CT.ARCTariff).%New()
    s eobj.TARRowId = id
    s eobj.TARCode  = obj.TARCode
    s eobj.TARDesc = obj.TARDesc
 
    s sc=##class(User.ARCTariff).%DeleteId(id)
    if $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_Tariff","User.ARCTariff","征收代码",id,eobj.TARDesc,"D",eobj)
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("征收代码","web.DHCBL.CT.ARCTariff","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  q result
}

}

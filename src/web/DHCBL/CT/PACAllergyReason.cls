/// Creator:基础数据平台组  孙凤超
/// CreateDate:2013-9-16
/// Function: 过敏原因维护
Class web.DHCBL.CT.PACAllergyReason Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：查询过敏原因的内容
/// Table： PAC_AllergyReason
/// Input：rowid,code,desc
/// Return： ALRGREA_RowId ALRGREA_Code ALRGREA_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergyReason", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALRGREARowId:%String,ALRGREACode:%String,ALRGREADesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
  s AuStr=##class(web.DHCBL.Authorize.PACAllergyReason).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
    s ALRGREARowId=rowid
    s ALRGREACode=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",1)
    s ALRGREADesc=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",2)
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AllergyReason",ALRGREARowId)
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
   s ALRGREARowId=0
   for
   {
     s ALRGREARowId=$o(^PAC("ALRGREA",ALRGREARowId)) q:ALRGREARowId=""   
     s strALRGREARowId="{ID:"_ALRGREARowId_"}"
     if (AuStr[strALRGREARowId)||(AuFlag=1) 
     {
        s ALRGREACode=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",1)
        s ALRGREADesc=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",2) 
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AllergyReason",ALRGREARowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AllergyReason",ALRGREARowId,ALRGREADesc,desc)
        }
        else
        {
           s AliasFlag= 1   
        }    
        if ($ZCVT(ALRGREACode,"U")[code)&(AliasFlag=1)  
        {
            d OutputRow
        }
    }
 }
}
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutputRow
    set Data=$lb(ALRGREARowId,ALRGREACode,ALRGREADesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为combox查询过敏原因提供接口 
/// CreateDate:2013-9-16
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  PAC_AllergyReason
/// Input:   code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAllergyReason", "GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALRGREARowId:%String,ALRGREACode:%String,ALRGREADesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  s repid=$I(^CacheTemp)
  s ind=1
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U") 
  s AuStr=##class(web.DHCBL.Authorize.PACAllergyReason).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
 {
   s ALRGREARowId=rowid
   s ALRGREACode=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",1)
   s ALRGREADesc=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",2)
   d OutputRow2
 }
 else
 {
  s ALRGREARowId=0
  for
{
   s ALRGREARowId=$o(^PAC("ALRGREA",ALRGREARowId)) q:ALRGREARowId=""   
   s strALRGREARowId="{ID:"_ALRGREARowId_"}"
   if (AuStr[strALRGREARowId)||(AuFlag=1) 
   {
    s ALRGREACode=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",1)
    s ALRGREADesc=$p($g(^PAC("ALRGREA",ALRGREARowId)),"^",2)
    if (desc'="")
    {
       ;需要对描述或者别名进行检索      
       s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AllergyReason",ALRGREARowId,ALRGREADesc,desc)
    }
    else
    {
       s AliasFlag= 1   
    }    
    if ($ZCVT(ALRGREACode,"U")[code)&(AliasFlag=1) 
    {
      d OutputRow2
    }
  }
 }
}
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutputRow2
    set Data=$lb(ALRGREARowId,ALRGREACode,ALRGREADesc)
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

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：根据ID删除过敏原因的内容
/// Table： PAC_AllergyReason
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Debug: d ##class(web.DHCBL.CT.PACAllergyReason).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
  s result="",flag=""
  Tstart
  s eobj = ##class(web.Entity.CT.PACAllergyReason).%New()
  s eobj.ALRGREARowId = id
  S eobj.ALRGREACode=$p($g(^PAC("ALRGREA",id)),"^",1)
  s eobj.ALRGREADesc=$p($g(^PAC("ALRGREA",id)),"^",2)
 
  s sc=##class(User.PACAllergyReason).%DeleteId(id)
  IF $$$ISOK(sc)
  {
    Tc
    s result="{success:'true',info:'删除成功！'}"
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergyReason","User.PACAllergyReason","过敏原因",id,eobj.ALRGREADesc,"D",eobj)
    d eobj.%Close()
  }
  else
  {
    Trollback
    s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原因","web.DHCBL.CT.PACAllergyReason","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
 q result
}

/// Function:用于双击时加载过敏原因信息 
/// CreateDate:2013-9-16
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Others : w ##class(web.DHCBL.CT.PACAllergyReason).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.PACAllergyReason).%OpenId(id)
 s eobj = ##class(web.Entity.CT.PACAllergyReason).%New()
 s eobj.ALRGREARowId = id
 S eobj.ALRGREACode=pobj.ALRGREACode
 s eobj.ALRGREADesc= pobj.ALRGREADesc 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:实现对过敏原因修改增加操作
/// Creator: 基础数据平台组 孙凤超
/// CreateDate:2013-9-16
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: PAC_AllergyReason
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAllergyReason) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  //如果RowId未赋值则增加
  if (eobj.ALRGREARowId="")       
  {
   s obj=##class(User.PACAllergyReason).%New()
  }else                           
  {
   s obj=##class(User.PACAllergyReason).%OpenId(eobj.ALRGREARowId)
   s bobj=##class(web.Entity.CT.PACAllergyReason).%New()
   s bobj.ALRGREARowId=eobj.ALRGREARowId
   s bobj.ALRGREACode = obj.ALRGREACode                      
   s bobj.ALRGREADesc= obj.ALRGREADesc   
  }
   s obj.ALRGREACode = eobj.ALRGREACode                      
   s obj.ALRGREADesc= eobj.ALRGREADesc                      
  
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.ALRGREARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergyReason","User.PACAllergyReason","过敏原因",eobj.ALRGREARowId,eobj.ALRGREADesc,"U",eobj,bobj)
    d:eobj.ALRGREARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AllergyReason","User.PACAllergyReason","过敏原因",id,eobj.ALRGREADesc,"A",eobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原因","web.DHCBL.CT.PACAllergyReason","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 else
 {
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原因","web.DHCBL.CT.PACAllergyReason","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
   s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏原因","web.DHCBL.CT.PACAllergyReason","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-9-16
/// Description：对过敏原因维护中的代码，描述进行数据校验
/// Table：PAC_AllergyReason
/// Input：id,code,desc
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^PAC("ALRGREA",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("ALRGREA",0,"Desc",desc))
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
  s:code'="" idc=$o(^PAC("ALRGREA",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("ALRGREA",0,"Desc",desc,0))
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

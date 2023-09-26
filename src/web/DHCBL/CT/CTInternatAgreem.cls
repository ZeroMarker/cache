/// Function: 国际协定业务类
/// Creator:  sunfengchao
/// CreateDate:2015-3-4
Class web.DHCBL.CT.CTInternatAgreem Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  查询 病人管理-国际协定
/// CreatDate:  2015-3-4
/// Creator：   sunfengchao
/// Table：     CT_InternatAgreem
/// Input：     rowid,code,desc 
/// Output:     INAG_RowId INAG_Code INAG_Desc INAG_Country_DR
/// Debug:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTInternatAgreem","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "INAGRowId:%String,INAGCode:%String,INAGDesc:%String,INAGCountryDR:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1

   s AuStr=##class(web.DHCBL.Authorize.CTInternatAgreem).DHCGetDataByDefaultSession()
   s AuINAGCountryDRStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1
   
   s AuINAGCountryDRFlag=0
   if (AuINAGCountryDRStr="")||(AuINAGCountryDRStr["limited:0") s AuINAGCountryDRFlag=1
   if (rowid'="") 
   {       
     s INAGRowId=rowid
     s INAGCode=$p($g(^CT("INAG",INAGRowId)),"^",1)
     s INAGDesc=$p($g(^CT("INAG",INAGRowId)),"^",2)
     s INAGCountryDR=$p($g(^CT("INAG",INAGRowId)),"^",3) 
     s:INAGCountryDR'="" INAGCountryDR=$p($g(^CT("COU",INAGCountryDR)),"^",2)
     s:INAGCountryDR="" INAGCountryDR=""
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_InternatAgreem",INAGRowId)
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
     s INAGRowId=0
     for
     {  
        s INAGRowId=$o(^CT("INAG",INAGRowId)) q:INAGRowId=""   
        s strINAGRowId="{ID:"_INAGRowId_"}"
        s INAGCountryDR=$p($g(^CT("INAG",INAGRowId)),"^",3) 
        s strINAGCountryDR="{ID:"_INAGCountryDR_"}"
        if ((AuStr[strINAGRowId)||(AuFlag=1))&((AuINAGCountryDRStr[strINAGCountryDR)||(AuINAGCountryDRFlag=1))  
        {
           s INAGCode=$p($g(^CT("INAG",INAGRowId)),"^",1)
           s INAGDesc=$p($g(^CT("INAG",INAGRowId)),"^",2) 
           s:INAGCountryDR'="" INAGCountryDR=$p($g(^CT("COU",INAGCountryDR)),"^",2)
           s:INAGCountryDR="" INAGCountryDR=""
           s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_InternatAgreem",INAGRowId)
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           s BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_InternatAgreem",INAGRowId,INAGDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }  
           if ($zcvt(INAGCode,"U")[code)&(AliasFlag=1)  
           {
              d OutputRow
           }
        }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(INAGRowId,INAGCode,INAGDesc,INAGCountryDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function： 查询病人管理-国际协定的内容,用于combox查询
/// CreatDate: 2015-3-4
/// Creator：  sunfengchao
/// Table：    CT_InternatAgreem
/// Input：    rowid,code,desc
/// Return：   HINAGRowId INAGCode INAGDesc 
/// Debug:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTInternatAgreem","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "INAGRowId:%String,INAGCode:%String,INAGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.CTInternatAgreem).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 s AuINAGCountryDRStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession() 
 s AuINAGCountryDRFlag=0
 if (AuINAGCountryDRStr="")||(AuINAGCountryDRStr["limited:0") s AuINAGCountryDRFlag=1  
 if (rowid'="") 
 {
  s INAGRowId=rowid
  s INAGCode=$p($g(^CT("INAG",INAGRowId)),"^",1)
  s INAGDesc=$p($g(^CT("INAG",INAGRowId)),"^",2)
  d OutputRow2
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U")  
   s:desc'="" desc=$ZCONVERT(desc,"U")  
   s INAGRowId=0
   for
   {  
        s INAGRowId=$o(^CT("INAG",INAGRowId)) q:INAGRowId=""   
        s strINAGRowId="{ID:"_INAGRowId_"}"
        s INAGCountryDR=$p($g(^CT("INAG",INAGRowId)),"^",3) 
        s strINAGCountryDR="{ID:"_INAGCountryDR_"}"
        if ((AuStr[strINAGRowId)||(AuFlag=1))&((AuINAGCountryDRStr[strINAGCountryDR)||(AuINAGCountryDRFlag=1))  
        {
           s INAGCode=$p($g(^CT("INAG",INAGRowId)),"^",1)
           s INAGDesc=$p($g(^CT("INAG",INAGRowId)),"^",2)
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_InternatAgreem",INAGRowId,INAGDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }  
           if ($zcvt(INAGCode,"U")[code)&(AliasFlag=1) 
           {
             d OutputRow2
           }
        }
     }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(INAGRowId,INAGCode,INAGDesc)
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

/// Function:  用于数据删除时的逻辑判断
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
      s HCPInternAgreemDR=$p($g(^CT("HCP",HCPRowId)),"^",4)
      if HCPInternAgreemDR=id s found1=1
    }
   if (found1=1)  s myInfo=myInfo_"<合同单位>"
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

/// Function： 根据ID删除病人管理-国际协定的内容
/// Creator：  sunfengchao
/// CreatDate: 2015-3-3
/// Table ：   CT_InternatAgreem
/// Input：    id
/// Return：   成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Debug:     w ##class(web.DHCBL.CT.CTInternatAgreem).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 s re=..GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=1)
 {
  s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
{
 s eobj = ##class(web.Entity.CT.CTInternatAgreem).%New()
 s obj=##class(User.CTInternatAgreem).%OpenId(id)
 s eobj.INAGRowId = id
 s eobj.INAGCode= obj.INAGCode
 s eobj.INAGDesc=obj.INAGDesc
 s eobj.INAGCountryDR=obj.INAGCountryDR
 s:eobj.INAGCountryDR'="" eobj.INAGCountryDR=$p($g(^CT("COU",eobj.INAGCountryDR)),"^",2)
 s:eobj.INAGCountryDR="" eobj.INAGCountryDR=""
 
 s sc=##class(User.CTInternatAgreem).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result = "{success:'true',info:'删除成功！'}"
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_InternatAgreem","User.CTInternatAgreem","国际协定",id,eobj.INAGDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国际协定","web.DHCBL.CT.CTInternatAgreem","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
 }
}
 q result
}

/// Function :  双击时显示病人管理-国际协定信息
/// CreateDate: 2015-03-03
/// Creator:    sunfengchao
/// Input:      id
/// Tables:     CT_InternatAgreem
/// Other:      w ##class(web.DHCBL.CT.CTInternatAgreem).OpenData("2")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTInternatAgreem).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTInternatAgreem).%New()
 
 s eobj.INAGRowId=id
 s eobj.INAGCode = pobj.INAGCode 
 s eobj.INAGDesc= pobj.INAGDesc
 if $IsObject(pobj.INAGCountryDR){
   s eobj.INAGCountryDR = pobj.INAGCountryDR.%Id() 
 }
 else{
  s eobj.INAGCountryDR =""
 }
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function： 对病人管理-国际协定code,desc的数据重复校验
/// Creator：  sunfengchao
/// CreatDate: 2015-01-05
/// Table：    CT_InternatAgreem
/// Input：    id, code, desc
/// Return：   "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s flag="", flagc="",flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
 s:code'="" flagc=$d(^CT("INAG",0,"Code",code))
 s:desc'="" flagd=$d(^CT("INAG",0,"Desc",desc))
 if (id="")  
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
  
  s:code'="" idc=$o(^CT("INAG",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("INAG",0,"Desc",desc,0))
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

/// Function: 实现对病人管理-国际协定的修改和增加操作
/// Creator:  sunfengchao
/// CreateDate:2015-02-05
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: CT_InternatAgreem
ClassMethod SaveEntity(eobj As web.Entity.CT.CTInternatAgreem) As %String
{
   s result=""
   if $IsObject(eobj)
   {
     if (eobj.INAGRowId="")       
     {
       s obj=##class(User.CTInternatAgreem).%New()
     }
     else                           
     {
       s obj=##class(User.CTInternatAgreem).%OpenId(eobj.INAGRowId)
       s bobj=##class(web.Entity.CT.CTInternatAgreem).%New()
       s bobj.INAGRowId=eobj.INAGRowId
       s bobj.INAGCode = obj.INAGCode                    
       s bobj.INAGDesc= obj.INAGDesc  
       s bobj.INAGCountryDR=obj.INAGCountryDR
       s:bobj.INAGCountryDR'="" bobj.INAGCountryDR=$p($g(^CT("HCA",bobj.INAGCountryDR)),"^",2)
       s:bobj.INAGCountryDR="" bobj.INAGCountryDR=""
     }
    s obj.INAGCode = eobj.INAGCode                    
    s obj.INAGDesc= eobj.INAGDesc
    d obj.INAGCountryDRSetObjectId(eobj.INAGCountryDR)              
    Tstart
    s sc=obj.%Save()
    if $$$ISOK(sc)
    {
      Tcommit
      s id = obj.%Id()
      s result = "{success:'true',id:'"_id_"'}"       
      d:eobj.INAGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_InternatAgreem","User.CTInternatAgreem","国际协定",eobj.INAGRowId,eobj.INAGDesc,"U",eobj,bobj)
      d:eobj.INAGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_InternatAgreem","User.CTInternatAgreem","国际协定",id,eobj.INAGDesc,"A",eobj)
    }
    else
    {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国际协定","web.DHCBL.CT.CTInternatAgreem","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
    }   
  }
  else
  {
    s result = "{success:'false',errorinfo:'对象不存在！'}"
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国际协定","web.DHCBL.CT.CTInternatAgreem","SaveEntity","")
    s ^ERRORLOGINFO(logid)="对象不存在！" 
  } 
  q result
}

}

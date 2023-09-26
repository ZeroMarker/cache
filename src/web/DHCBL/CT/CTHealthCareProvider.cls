/// Function: 病人管理-合同单位
/// CreateDate: 2015-3-2
/// Creator: sunfengchao
Class web.DHCBL.CT.CTHealthCareProvider Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_HealthCareProvider";

/// Function：  查询 病人管理-合同单位
/// CreatDate:  2015-3-2
/// Creator：   孙凤超
/// Table：     CT_HealthCareProvider
/// Input：     rowid,code,desc 
/// Output:     HCPRowId HCPCode HCPDesc HCPHCADR HCPInternAgreemDR  HCPRegionDR
/// Debug:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHealthCareProvider","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "HCPRowId:%String,HCPCode:%String,HCPDesc:%String,HCPHCADR:%String,HCPInternAgreemDR:%String,HCPRegionDR:%String,HCPActiveFlag:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1

   s AuStr=##class(web.DHCBL.Authorize.CTHealthCareProvider).DHCGetDataByDefaultSession()
   s AuHCPHCADRStr=##class(web.DHCBL.Authorize.CTHealthCareArea).DHCGetDataByDefaultSession()
   s AuHCPInternAgreemDRStr=##class(web.DHCBL.Authorize.CTInternatAgreem).DHCGetDataByDefaultSession()
   s AuHCPRegionDRStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
   s AuFlag=0, AuHCPHCADRFlag=0,AuHCPRegionDRFlag=0,AuHCPInternAgreemDRFlag=0   
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   if (AuHCPHCADRStr="")||(AuHCPHCADRStr["limited:0") s AuHCPHCADRFlag=1 
   if (AuHCPInternAgreemDRStr="")||(AuHCPInternAgreemDRStr["limited:0") s AuHCPInternAgreemDRFlag=1 
   if (AuHCPRegionDRStr="")||(AuHCPRegionDRStr["limited:0") s AuHCPRegionDRFlag=1
   if (rowid'="") 
   {       
     s HCPRowId=rowid
     s HCPCode=$p($g(^CT("HCP",HCPRowId)),"^",1)
     s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2)
     s HCPHCADR=$p($g(^CT("HCP",HCPRowId)),"^",3) 
     s:HCPHCADR'="" HCPHCADR=$p($g(^CT("HCA",HCPHCADR)),"^",2)
     s:HCPHCADR="" HCPHCADR=""
     s HCPInternAgreemDR=$p($g(^CT("HCP",HCPRowId)),"^",4)
     S:HCPInternAgreemDR'="" HCPInternAgreemDR=$P($g(^CT("INAG",HCPInternAgreemDR)),"^",2)
     S:HCPInternAgreemDR="" HCPInternAgreemDR=""
     s HCPRegionDR=$p($g(^CT("HCP",HCPRowId)),"^",5)
     s:HCPRegionDR'="" HCPRegionDR=$p($g(^CT("RG",HCPRegionDR)),"^",2)
     s:HCPRegionDR="" HCPRegionDR=""
     s HCPActiveFlag=$p($g(^CT("HCP",HCPRowId)),"^",6)
     s:HCPActiveFlag="" HCPActiveFlag="N"
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_HealthCareProvider",HCPRowId)
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
     s HCPRowId=0
     for
     {  
        s HCPRowId=$o(^CT("HCP",HCPRowId)) q:HCPRowId=""   
        s strHCPRowId="{ID:"_HCPRowId_"}"
        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,HCPRowId,hospid)
        continue:showflag="N"
        s HCPHCADR=$p($g(^CT("HCP",HCPRowId)),"^",3)
        s HCPInternAgreemDR=$p($g(^CT("HCP",HCPRowId)),"^",4)
        s HCPRegionDR=$p($g(^CT("HCP",HCPRowId)),"^",5)
        s strHCPHCADR="{ID:"_HCPHCADR_"}"
        s strHCPInternAgreemDR="{ID:"_HCPInternAgreemDR_"}" 
        s strHCPRegionDR="{ID:"_HCPRegionDR_"}" 
        if ((AuStr[strHCPRowId)||(AuFlag=1))&((AuHCPHCADRStr[strHCPHCADR)||(AuHCPHCADRFlag=1))&((AuHCPInternAgreemDRStr[strHCPInternAgreemDR)||(AuHCPInternAgreemDRFlag=1))&((AuHCPRegionDRStr[strHCPRegionDR)||(AuHCPRegionDRFlag=1)) 
        {
            s HCPCode=$p($g(^CT("HCP",HCPRowId)),"^",1)
            s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2) 
            s:HCPHCADR'="" HCPHCADR=$p($g(^CT("HCA",HCPHCADR)),"^",2)
            s:HCPHCADR="" HCPHCADR=""
           
            S:HCPInternAgreemDR'="" HCPInternAgreemDR=$P($g(^CT("INAG",HCPInternAgreemDR)),"^",2)
            S:HCPInternAgreemDR="" HCPInternAgreemDR=""
           
            s:HCPRegionDR'="" HCPRegionDR=$p($g(^CT("RG",HCPRegionDR)),"^",2)
            s:HCPRegionDR="" HCPRegionDR=""
            s HCPActiveFlag=$p($g(^CT("HCP",HCPRowId)),"^",6)
            s:HCPActiveFlag="" HCPActiveFlag="N"
            s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
            s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_HealthCareProvider",HCPRowId)
            s BDPInternalCode =$p($g(resultStr),"^",1)       
            s BDPInternalDesc = $p($g(resultStr),"^",2)  
            s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            if (desc'="")
            {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_HealthCareProvider",HCPRowId,HCPDesc,desc)
            }
            else
            {
              s AliasFlag= 1   
            }  
            if ($zcvt(HCPCode,"U")[code)&(AliasFlag=1) 
            {
              d OutputRow
            }
        }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(HCPRowId,HCPCode,HCPDesc,HCPHCADR,HCPInternAgreemDR,HCPRegionDR,HCPActiveFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function： 查询病人管理-合同单位的内容,用于combox查询
/// CreatDate: 2012-12-10
/// Creator：  sunfengchao
/// Table：    CT_HealthCareProvider
/// Input：    rowid,code,desc
/// Return：   HHCPRowId HCPCode HCPDesc 
/// Debug:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHealthCareProvider","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "HCPRowId:%String,HCPCode:%String,HCPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.CTHealthCareProvider).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
 s AuHCPHCADRStr=##class(web.DHCBL.Authorize.CTHealthCareArea).DHCGetDataByDefaultSession()
 s AuHCPInternAgreemDRStr=##class(web.DHCBL.Authorize.CTInternatAgreem).DHCGetDataByDefaultSession()
 s AuHCPRegionDRStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
 s AuHCPHCADRFlag=0,AuHCPRegionDRFlag=0,AuHCPInternAgreemDRFlag=0
 if (AuHCPHCADRStr="")||(AuHCPHCADRStr["limited:0") s AuHCPHCADRFlag=1 
 if (AuHCPInternAgreemDRStr="")||(AuHCPInternAgreemDRStr["limited:0") s AuHCPInternAgreemDRFlag=1 
 if (AuHCPRegionDRStr="")||(AuHCPRegionDRStr["limited:0") s AuHCPRegionDRFlag=1
 if (rowid'="") 
 {
  s HCPRowId=rowid
  s HCPCode=$p($g(^CT("HCP",HCPRowId)),"^",1)
  s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U")  
  s:desc'="" desc=$ZCONVERT(desc,"U")  
  s HCPRowId=0
  for
  {  
    s HCPRowId=$o(^CT("HCP",HCPRowId)) q:HCPRowId=""   
    s strHCPRowId="{ID:"_HCPRowId_"}"
    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,HCPRowId,hospid)
    continue:showflag="N"
    s HCPActiveFlag=$p($g(^CT("HCP",HCPRowId)),"^",6)
    continue:HCPActiveFlag="N"
    s HCPHCADR=$p($g(^CT("HCP",HCPRowId)),"^",3)
    s HCPInternAgreemDR=$p($g(^CT("HCP",HCPRowId)),"^",4)
    s HCPRegionDR=$p($g(^CT("HCP",HCPRowId)),"^",5)
    s strHCPHCADR="{ID:"_HCPHCADR_"}"
    s strHCPInternAgreemDR="{ID:"_HCPInternAgreemDR_"}" 
    s strHCPRegionDR="{ID:"_HCPRegionDR_"}" 
    if ((AuStr[strHCPRowId)||(AuFlag=1))&((AuHCPHCADRStr[strHCPHCADR)||(AuHCPHCADRFlag=1))&((AuHCPInternAgreemDRStr[strHCPInternAgreemDR)||(AuHCPInternAgreemDRFlag=1))&((AuHCPRegionDRStr[strHCPRegionDR)||(AuHCPRegionDRFlag=1)) 
    {
       s HCPCode=$p($g(^CT("HCP",HCPRowId)),"^",1)
       s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2)
       if (desc'="")
       {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_HealthCareProvider",HCPRowId,HCPDesc,desc)
       }
       else
       {
          s AliasFlag= 1   
       }  
       if ($zcvt(HCPCode,"U")[code)&(AliasFlag=1) 
       {
          d OutputRow2
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(HCPRowId,HCPCode,HCPDesc)
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

/// Function： 根据ID删除病人管理-合同单位的内容
/// Creator：  sunfengchao
/// CreatDate: 2015-3-3
/// Table ：   CT_HealthCareProvider
/// Input：    id
/// Return：   成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Debug:     w ##class(web.DHCBL.CT.CTHealthCareProvider).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 s eobj = ##class(web.Entity.CT.CTHealthCareProvider).%New()
 s obj=##class(User.CTHealthCareProvider).%OpenId(id)
 s eobj.HCPRowId = id
 s eobj.HCPCode= obj.HCPCode
 s eobj.HCPDesc=obj.HCPDesc
 s eobj.HCPHCADR=obj.HCPHCADR
 s:eobj.HCPHCADR'="" eobj.HCPHCADR=$p($g(^CT("HCA",eobj.HCPHCADR)),"^",2)
 s:eobj.HCPHCADR="" eobj.HCPHCADR=""
 s eobj.HCPInternAgreemDR=obj.HCPInternAgreemDR
 s:eobj.HCPInternAgreemDR'="" eobj.HCPInternAgreemDR=$P($g(^CT("INAG",eobj.HCPInternAgreemDR)),"^",2)
 s:eobj.HCPInternAgreemDR="" eobj.HCPInternAgreemDR=""
 s eobj.HCPRegionDR=obj.HCPRegionDR
 s:eobj.HCPRegionDR'="" eobj.HCPRegionDR=$p($g(^CT("RG",eobj.HCPRegionDR)),"^",2)
 s:eobj.HCPRegionDR="" eobj.HCPRegionDR=""
 s eobj.HCPActiveFlag=obj.HCPActiveFlag
 s sc=##class(User.CTHealthCareProvider).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result = "{success:'true',info:'删除成功！'}"
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareProvider","User.CTHealthCareProvider","合同单位",id,eobj.HCPDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合同单位","web.DHCBL.CT.CTHealthCareProvider","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
 }
 q result
}

/// Function :  双击时显示病人管理-合同单位信息
/// CreateDate: 2015-03-03
/// Creator:    sunfengchao
/// Input:      id
/// Tables:     CT_HealthCareProvider
/// Other:      w ##class(web.DHCBL.CT.CTHealthCareProvider).OpenData("2")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTHealthCareProvider).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTHealthCareProvider).%New()
 
 s eobj.HCPRowId=id
 s eobj.HCPCode = pobj.HCPCode 
 s eobj.HCPDesc= pobj.HCPDesc
 if $IsObject(pobj.HCPHCADR)
 {
   s eobj.HCPHCADR = pobj.HCPHCADR.%Id() 
 }
 else
 {
  s eobj.HCPHCADR =""
 }
 if $IsObject(pobj.HCPInternAgreemDR)
 {
   s eobj.HCPInternAgreemDR = pobj.HCPInternAgreemDR.%Id() 
 }
 else
 {
  s eobj.HCPInternAgreemDR =""
 }
 if $IsObject(pobj.HCPRegionDR)
 {
   s eobj.HCPRegionDR = pobj.HCPRegionDR.%Id() 
 }
 else
 {
  s eobj.HCPRegionDR =""
 }
 s eobj.HCPActiveFlag=pobj.HCPActiveFlag
 s:eobj.HCPActiveFlag="Y" eobj.HCPActiveFlag="true"
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:   进行数据重复校验功能，并返回一个标志位
/// Creator:    基础数据平台组 sunfengchao
/// CreateDate: 2016-12-2
/// Table:      CT_HealthCareProvider
/// Debug:      w ##class(web.DHCBL.CT.CTHealthCareProvider).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^CT("HCP",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
	            //2022-12-30限制代码跨院区也不能重复
                //s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
                //continue:showflag="N"
                s flag=1
            }
        }
    }
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
            s idd=$o(^CT("HCP",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    q flag
}

/// Function: 实现对病人管理-合同单位的修改和增加操作
/// Creator:  sunfengchao
/// CreateDate:2015-02-05
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: CT_HealthCareProvider
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHealthCareProvider) As %String
{
   s result=""
   if $IsObject(eobj)
   {
      s flag=..FormValidate(eobj.HCPRowId,eobj.HCPCode,eobj.HCPDesc,eobj.LinkHospId)  //调用重复验证
      if (flag=1)
      {
          s result = "{success:'false',errorinfo:'该记录已经存在！'}"
      }
      else
      {
         if (eobj.HCPRowId="")       
         {
           s obj=##class(User.CTHealthCareProvider).%New()
         }
         else                           
         {
           s obj=##class(User.CTHealthCareProvider).%OpenId(eobj.HCPRowId)
           s bobj=##class(web.Entity.CT.CTHealthCareProvider).%New()
           s bobj.HCPRowId=eobj.HCPRowId
           s bobj.HCPCode = obj.HCPCode                    
           s bobj.HCPDesc= obj.HCPDesc 
           s:obj.HCPHCADR="" bobj.HCPHCADR=""
           s:obj.HCPInternAgreemDR="" bobj.HCPInternAgreemDR=""
           s:obj.HCPRegionDR="" bobj.HCPRegionDR="" 
           s:obj.HCPHCADR'="" bobj.HCPHCADR=obj.HCPHCADR.%Id()
           s:obj.HCPInternAgreemDR'="" bobj.HCPInternAgreemDR=obj.HCPInternAgreemDR.%Id()
           s:obj.HCPRegionDR'="" bobj.HCPRegionDR=obj.HCPRegionDR.%Id()
           s bobj.HCPActiveFlag= obj.HCPActiveFlag
         }
        s obj.HCPCode = eobj.HCPCode                    
        s obj.HCPDesc= eobj.HCPDesc
        d obj.HCPHCADRSetObjectId(eobj.HCPHCADR) 
        d obj.HCPInternAgreemDRSetObjectId(eobj.HCPInternAgreemDR)  
        d obj.HCPRegionDRSetObjectId(eobj.HCPRegionDR)
        s:eobj.HCPActiveFlag="" eobj.HCPActiveFlag="N" 
        s obj.HCPActiveFlag= eobj.HCPActiveFlag                 
        Tstart
        s sc=obj.%Save()
        if $$$ISOK(sc)
        {
          Tcommit
          s id = obj.%Id()
          s result = "{success:'true',id:'"_id_"'}"       
          d:eobj.HCPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareProvider","User.CTHealthCareProvider","合同单位",eobj.HCPRowId,eobj.HCPDesc,"U",eobj,bobj)
          d:eobj.HCPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HealthCareProvider","User.CTHealthCareProvider","合同单位",id,eobj.HCPDesc,"A",eobj)
        }
        else
        {
          Trollback
          s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
          s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合同单位","web.DHCBL.CT.CTHealthCareProvider","SaveEntity",eobj)
          s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }   
      }
     }
  else
  {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合同单位","web.DHCBL.CT.CTHealthCareProvider","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
  }  
  q result
}

}
